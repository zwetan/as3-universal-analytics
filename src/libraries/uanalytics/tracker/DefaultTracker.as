/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker
{
    import flash.system.ApplicationDomain;
    import flash.utils.Dictionary;
    
    import libraries.uanalytics.tracker.senders.LoaderHitSender;
    import libraries.uanalytics.tracking.Configuration;
    import libraries.uanalytics.tracking.HitModel;
    import libraries.uanalytics.tracking.HitSampler;
    import libraries.uanalytics.tracking.RateLimitError;
    import libraries.uanalytics.tracking.RateLimiter;
    import libraries.uanalytics.tracking.Tracker;
    import libraries.uanalytics.utils.generateUUID;
    import libraries.uanalytics.utils.getHostname;
    
    /**
     * Default Google Analytics tracker implementation.
     * 
     * <p>
     * This tracker is to be considered as a basic common denominator,
     * we mainly use it to do quick tests and experiments,
     * and you do not want to use it "as is" in production unless you really
     * know what you are doing.
     * </p>
     * 
     * <p>
     * Important things to know:
     * </p>
     * <ul>
     *   <li>
     *   The <code>RateLimiter</code> of this tracker starts with 100 hits
     *   that are replenished at a rate of 10 hits per second.
     *   </li>
     *   <li>
     *   This tracker does not save nor restore the <b>ClientId</b>,
     *   each time you instanciate it you will obtain a new ClientId. 
     *   </li>
     *   <li>
     *   It uses by default the <code>LoaderHitSender</code>.
     *   </li>
     *   <li>
     *   No Data Source is defined.
     *   </li>
     *   <li>
     *   It will work with Flash and AIR but not with Redtamarin on the command-line
     *   </li>
     * </ul>
     * 
     * <p>
     * depending on your use case you would want to use a specialised tracker:
     * <code>WebTracker</code>, <code>AppTracker</code>, etc.
     * </p>
     * 
     *  @example Usage
     * <listing>
     * import com.google.analytics.tracker.DefaultTracker;
     * import com.google.analytics.tracking.Configuration;
     * import flash.utils.Dictionary;
     * 
     * // we want to override the default config
     * var config:Configuration = new Configuration();
     *     //we want to throw errors
     *     config.enableErrorChecking = true;
     *     //we want to use a debug sender
     *     config.senderType = "libraries.uanalytics.tracker.senders.DebugHitSender";
     * 
     * //store a reference of a dynamic sender otherwise it will not be found
     * var sender_tmp:DebugHitSender;
     * 
     * //replace this with a valid Tracking ID
     * var trackingID:String = "UA-12345-67";
     * 
     * /&#42; Unless you store the Client ID somewhere
     *    each time you will launch this code you will be in a new session
     *    with a new Client ID.
     *    If you launch multiple instances of this code at the same time,
     *    each instance will represent a different tracked user.
     * &#42;/
     * var tracker:DefaultTracker = new DefaultTracker( trackingID, config );
     * trace( "trackingID: " + tracker.trackingID );
     * trace( "  clientID: " + tracker.clientID ); 
     * 
     * // if you want to reuse a previous ClientID
     * // tracker.set( Tracker.CLIENT_ID, savedClientId );
     * 
     * // the set() function allow you to set any tracker values
     * tracker.set( Tracker.PAGE, "/my default page €" );
     * 
     * // if you want a particular field to be used only one time
     * // once used by a hit request, the hit will be removed
     * // tracker.setOneTime( Tracker.NON_INTERACTION, "1" );
     * 
     * // you can also define a dictionary
     * var values:Dictionary = new Dictionary();
     *     values[ Tracker.PAGE ] = "/my page €"; //path
     *     values[ Tracker.TITLE ] = "My Page Title with €"; //title
     * 
     *     // those values are temporary and will be used only for this hit
     *     // temp values will override set() values
     *     tracker.send( "pageview", values );
     * 
     *     // if you wanted to make them permanent for each hit requests
     *     // tracker.add( values );
     * 
     * </listing>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     */
    public class DefaultTracker extends Tracker
    {
        
        /**
         * Create a new Tracker with no data model fields set.
         * 
         * @param trackingId the Tracking ID
         * @param config the tracker configuration
         */
        public function DefaultTracker( trackingId:String = "",
                                        config:Configuration = null )
        {
            super();
            
            if( !config )
            {
                config = new Configuration();
            }
            
            _config = config;
            _ctor( trackingId );
        }
        
        /**
         * @private
         * 
         * We want to move the constructor logic into a method
         * so when we inherit it we can replace it
         * with other custom builds.
         */
        protected function _ctor( trackingId:String = "" ):void
        {
            _model     = new HitModel();
            _temporary = new HitModel();
            
            /* Note:
               our default safe sender is LoaderHitSender
               but we want to be able ot dynamically instantiate
               other type of sender with config.senderType
            */
            if( _config.senderType != "" )
            {
                var S:Class = ApplicationDomain.currentDomain.getDefinition( _config.senderType ) as Class;
                _sender = new S( this );
            }
            else
            {
                _sender = new LoaderHitSender( this );
            }
            
            /* Note:
               the tracker starts with 100 hits
               that are replenished at a rate of 10 hits per second.
            */
            _limiter = new RateLimiter( 100, 10 );
            
            if( trackingId != "" )
            {
                set( TRACKING_ID, trackingId );
            }
            
            var cid:String = _getClientID();
            if( cid != "" )
            {
                set( CLIENT_ID, cid );
            }
            
            // no data source by default
        }
        
        /**
         * @private
         * 
         * Here we obtain the client id
         * in the default implementation we keep it simple
         * and each time we will use this tracker we will obtain
         * a new clientId.
         * 
         * Ideally we would want to be able to save and reuse
         * a clientId, see more advanced implementation.
         */
        protected function _getClientID():String
        {
            return generateUUID();
        }
        
        /**
         * @private
         * 
         * A very basic cache buster.
         */
        protected function _getCacheBuster():String
        {
            var d:Date = new Date();
            var rnd:Number = Math.random();
            return String( d.valueOf() + rnd );
        }
        
        /** @inheritDoc */
        public override function send( hitType:String = null, tempValues:Dictionary = null ):Boolean
        {
            /* Note:
               yep defensive programming, as trackingId and clientId
               are mandatory for a valid hit we really do want them
               to be here.
            */
            if( (trackingId == "") || (trackingId == null) )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "tracking id is missing." );
                }
                else
                {
                    return false;
                }
            }
            
            if( (clientId == "") || (clientId == null) )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "client id is missing." );
                }
                else
                {
                    return false;
                }
            }
            
            /* Note:
               We make a copy of our internal data model
               and add temporary values (eg. one time values)
               and clear up those.
            */
            var copy:HitModel = _model.clone();
                copy.add( _temporary );
            
            _temporary.clear();
            
            /* Note:
               If we have user temp values we add them
               those will override any other set values
            */
            if( tempValues != null )
            {
                for( var entry:String in tempValues )
                {
                    copy.set( entry, tempValues[entry] );
                }
            }
            
            /* Note:
               Again defensive programming, we really want the hit type
               to be valid, eg. be any of "pageview", "screenview", etc.
            */
            if( ((hitType != "") || (hitType != null)) &&
                HitType.isValid( hitType ) )
            {
                copy.set( HIT_TYPE, hitType );
            }
            else
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "hit type \"" + hitType + "\" is not valid." );
                }
                else
                {
                    return false;
                }
            }
            
            /* Note:
               we want to be able to sample the hit requests
               if Tracker.SAMPLE_RATE = 20.0
               then we want to send only 20% of the hits, not 100% of them
            */
            if( _config && _config.enableSampling )
            {
                if( HitSampler.isSampled( copy, String(_config.sampleRate) ) )
                {
                    return false;
                }
            }
            
            if( _config && _config.enableThrottling )
            {
                if( !_limiter.consumeToken() )
                {
                    if( _config && _config.enableErrorChecking )
                    {
                        throw new RateLimitError();
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            
            if( _config && _config.enableCacheBusting )
            {
                copy.set( CACHE_BUSTER, _getCacheBuster() );
            }
            
            //configuration options
            
            if( _config && _config.anonymizeIp )
            {
                copy.set( ANON_IP, "1" );
            }
            
            if( _config && (_config.overrideIpAddress != "") )
            {
                copy.set( IP_OVERRIDE, _config.overrideIpAddress );
            }
            
            if( _config && (_config.overrideUserAgent != "") )
            {
                copy.set( USER_AGENT_OVERRIDE, _config.overrideUserAgent );
            }
            
            if( _config && (_config.overrideGeographicalId != "") )
            {
                copy.set( GEOGRAPHICAL_OVERRIDE, _config.overrideGeographicalId );
            }
            
            
            var err:Error = null;
            
            /* Note:
               Here we wrap the sender call in a try/catch
               to only throw errors if config.enableErrorChecking is enabled
               that way by default an error in the analytics does not
               break the containing app
               also it also allow you to log/capture this error
               in your tracker implementation
               but most important important if an error occurs
               we wan to return false to signal the hit was not sent
            */
            try
            {
                _sender.send( copy ); //can throw Error, IOError, etc.
            }
            catch( e:Error )
            {
                err = e;
            }
            
            if( _config && _config.enableErrorChecking && err )
            {
                throw err;
            }
            
            /* Note:
               If the HitSender generated an error then we consider
               the hit not valid and return false
            */
            if( err )
            {
                return false;
            }
            
            return true;
        }
        
        /** @inheritDoc */
        public override function pageview( path:String, title:String = "" ):Boolean
        {
            /* Note:
               For 'pageview' hits,
               either &dl
               or both &dh and &dp have to be specified for the hit to be valid.
               
               dl - document location  - http://foo.com/home?a=b
               dh - document hostname  - foo.com
               dp - document path      - /foo
               
               
               Screen Name
               This parameter is optional on web properties
               On web properties this will default to the unique URL of the page by
               either using the &dl parameter as-is
               or assembling it from &dh and &dp.
               cd - screen name        - High Scores
               
               ----
                v=1              // Version.
                &tid=UA-XXXXX-Y  // Tracking ID / Property ID.
                &cid=555         // Anonymous Client ID.
                
                &t=pageview      // Pageview hit type.
                &dh=mydemo.com   // Document hostname.
                &dp=/home        // Page.
                &dt=homepage     // Title.
            */
        
            if( (path == null) || (path == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "path is empty" );
                }
                else
                {
                    return false;
                }
                
            }
            
            var values:Dictionary = new Dictionary();
                values[ Tracker.DOCUMENT_PATH ] = path;
            
            if( title && (title.length > 0) )
            {
                if( title.length > 1500 )
                {
                    if( _config && _config.enableErrorChecking )
                    {
                        throw new ArgumentError( "Title is bigger than 1500 bytes." );
                    }
                    else
                    {
                        return false;
                    }
                }
                
                values[ Tracker.DOCUMENT_TITLE ] = title;
            }

            /* Note:
               by default we will fetch the hostname and at worst
               this one will be "localhost" if it can not be found.
               
               eg. a pageview hit
                   with dh=localhost is valid
                   without dh= is invalid
            */
            var hostname:String = get( Tracker.DOCUMENT_HOSTNAME );
            if( hostname == null )
            {
                if( !(Tracker.DOCUMENT_HOSTNAME in values) )
                {
                    hostname = getHostname();
                    
                    if( hostname == "" )
                    {
                        if( _config && _config.enableErrorChecking )
                        {
                            throw new ArgumentError( "hostname is not defined." );
                        }
                        else
                        {
                            return false;
                        }
                    }
                    else
                    {
                        values[ Tracker.DOCUMENT_HOSTNAME ] = hostname;
                    }
                }
            }
            
            return send( HitType.PAGEVIEW, values );
        }
        
        /** @inheritDoc */
        public override function screenview( name:String, appinfo:Dictionary = null ):Boolean
        {
            /* Note:
               Application Name
               This field is required for all hit types sent to app properties.
               an - application name   - My App
               
               Screen Name
               required on mobile properties for screenview hits,
               where it is used for the 'Screen Name' of the screenview hit.
               cd - screen name        - High Scores
               
               ----
                v=1                         // Version.
                &tid=UA-XXXXX-Y             // Tracking ID / Property ID.
                &cid=555                    // Anonymous Client ID.
                
                &t=screenview               // Screenview hit type.
                &an=funTimes                // App name.
                &av=4.2.0                   // App version.
                &aid=com.foo.App            // App Id.
                &aiid=com.android.vending   // App Installer Id.
                
                &cd=Home                    // Screen name / content description.
            */
        
            if( (name == null) || (name == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "name is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            var values:Dictionary = new Dictionary();
            if( appinfo != null )
            {
                for( var entry:String in appinfo )
                {
                    values[ entry ] = appinfo[ entry ];
                }
            }
            
            var app_name:String = get( Tracker.APP_NAME );
            if( app_name == null )
            {
                if( !(Tracker.APP_NAME in values) )
                {
                    if( _config && _config.enableErrorChecking )
                    {
                        throw new ArgumentError( "Application name is not defined." );
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            
                values[ Tracker.SCREEN_NAME ] = name;
            
            return send( HitType.SCREENVIEW, values );
        }
        
        /** @inheritDoc */
        public override function event( category:String, action:String,
                                        label:String = "", value:int = -1 ):Boolean
        {
            /* Note:
               
               Event Category
               Required for event hit type.
               Specifies the event category. Must not be empty.
               ec - event category     - Category
               
               Event Action
               Required for event hit type.
               Specifies the event action. Must not be empty.
               ea - event action       - Action
               
               ----
                v=1              // Version.
                &tid=UA-XXXXX-Y  // Tracking ID / Property ID.
                &cid=555         // Anonymous Client ID.
                
                &t=event         // Event hit type
                &ec=video        // Event Category. Required.
                &ea=play         // Event Action. Required.
                &el=holiday      // Event label.
                &ev=300          // Event value.
            */
            
            if( (category == null) || (category == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "category is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            if( (action == null) || (action == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "action is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            var values:Dictionary = new Dictionary();
            
                values[ Tracker.EVENT_CATEGORY ] = category;
                values[ Tracker.EVENT_ACTION ] = action;
            
            if( label != "" )
            {
                values[ Tracker.EVENT_LABEL ] = label;
            }
            
            /* Note:
               Event Value must be non-negative.
               it is an integer type so range goes from 0 to MAX_INT.
            */
            if( value > -1 )
            {
                values[ Tracker.EVENT_VALUE ] = value;
            }
            
            return send( HitType.EVENT, values );
        }
        
        /** @inheritDoc */
        public override function transaction( id:String,
                                              affiliation:String = "",
                                              revenue:Number = 0,
                                              shipping:Number = 0,
                                              tax:Number = 0,
                                              currency:String = "" ):Boolean
        {
            /* Note:
               
               
               ----
                v=1               // Version.
                &tid=UA-XXXXX-Y   // Tracking ID / Property ID.
                &cid=555          // Anonymous Client ID.
                
                &t=transaction    // Transaction hit type.
                &ti=12345         // transaction ID. Required.
                &ta=westernWear   // Transaction affiliation.
                &tr=50.00         // Transaction revenue.
                &ts=32.00         // Transaction shipping.
                &tt=12.00         // Transaction tax.
                &cu=EUR           // Currency code.
            */
        
            if( (id == null) || (id == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "id is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            var values:Dictionary = new Dictionary();
            
                values[ Tracker.TRANSACTION_ID ] = id;
            
            if( affiliation != "" )
            {
                values[ Tracker.TRANSACTION_AFFILIATION ] = affiliation;
            }
            
                values[ Tracker.TRANSACTION_REVENUE ] = revenue;
                values[ Tracker.TRANSACTION_SHIPPING ] = shipping;
                values[ Tracker.TRANSACTION_TAX ] = tax;
            
            if( currency != "" )
            {
                values[ Tracker.CURRENCY_CODE ] = currency;
            }
            
            return send( HitType.TRANSACTION, values );
        }
        
        /** @inheritDoc */
        public override function item( transactionId:String, name:String,
                                       price:Number = 0,
                                       quantity:int = 0,
                                       code:String = "",
                                       category:String = "",
                                       currency:String = "" ):Boolean
        {
            /* Note:
               
               
               ----
                v=1               // Version.
                &tid=UA-XXXXX-Y   // Tracking ID / Property ID.
                &cid=555          // Anonymous Client ID.
                
                &t=item           // Item hit type.
                &ti=12345         // Transaction ID. Required.
                &in=sofa          // Item name. Required.
                &ip=300           // Item price.
                &iq=2             // Item quantity.
                &ic=u3eqds43      // Item code / SKU.
                &iv=furniture     // Item variation / category.
                &cu=EUR           // Currency code.
            */
        
            if( (transactionId == null) || (transactionId == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "transaction id is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            if( (name == null) || (name == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "name is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            var values:Dictionary = new Dictionary();
            
                values[ Tracker.TRANSACTION_ID ] = transactionId;
                values[ Tracker.ITEM_NAME ] = name;
            
                values[ Tracker.ITEM_PRICE ] = price;
                values[ Tracker.ITEM_QUANTITY ] = quantity;
            
            if( code != "" )
            {
                values[ Tracker.ITEM_CODE ] = code;
            }
            
            if( category != "" )
            {
                values[ Tracker.ITEM_CATEGORY ] = category;
            }
            
            if( currency != "" )
            {
                values[ Tracker.CURRENCY_CODE ] = currency;
            }
            
            return send( HitType.ITEM, values );
        }
        
        /** @inheritDoc */
        public override function social( network:String, action:String, target:String ):Boolean
        {
            /* Note:
               
               Social Network
               Required for social hit type.
               Specifies the social network, for example Facebook or Google Plus.
               sn - social network     - twitter
               
               Social Action
               Required for social hit type.
               Specifies the social interaction action. For example on Google Plus
               when a user clicks the +1 button, the social action is 'plus'.
               sa - social action      - share
               
               Social Action Target
               Required for social hit type.
               Specifies the target of a social interaction.
               This value is typically a URL but can be any text.
               st - social target      - http://foo.com
               
               
               ----
                v=1              // Version.
                &tid=UA-XXXXX-Y  // Tracking ID / Property ID.
                &cid=555         // Anonymous Client ID.
                
                &t=social        // Social hit type.
                &sa=like         // Social Action. Required.
                &sn=facebook     // Social Network. Required.
                &st=/home        // Social Target. Required.
            */
        
            if( (network == null) || (network == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "network is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            if( (action == null) || (action == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "action is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            if( (target == null) || (target == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "target is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            var values:Dictionary = new Dictionary();
            
                values[ Tracker.SOCIAL_NETWORK ] = network;
                values[ Tracker.SOCIAL_ACTION ] = action;
                values[ Tracker.SOCIAL_TARGET ] = target;
            
            return send( HitType.SOCIAL, values );
        }
        
        /** @inheritDoc */
        public override function exception( description:String = "",
                                            isFatal:Boolean = true ):Boolean
        {
            /* Note:
               
               
               ----
                v=1              // Version.
                &tid=UA-XXXXX-Y  // Tracking ID / Property ID.
                &cid=555         // Anonymous Client ID.
                
                &t=exception       // Exception hit type.
                &exd=IOException   // Exception description.
                &exf=1             // Exception is fatal?
            */
        
            var values:Dictionary = new Dictionary();
            
            if( description != "" )
            {
                values[ Tracker.EXCEPT_DESCRIPTION ] = description;
            }
            
            if( isFatal )
            {
                values[ Tracker.EXCEPT_FATAL ] = "1";
            }
            else
            {
                values[ Tracker.EXCEPT_FATAL ] = "0";
            }
            
            return send( HitType.EXCEPTION, values );
        }
        
        /** @inheritDoc */
        public override function timing( category:String, name:String, value:int,
                                         label:String = "",
                                         timinginfo:Dictionary = null ):Boolean
        {
            /* Note:
               
               User timing category
               Required for timing hit type.
               Specifies the user timing category.
               utc - user timing category - category
               
               User timing variable name
               Required for timing hit type.
               Specifies the user timing variable.
               utv - user timing variable - lookup
               
               User timing time
               Required for timing hit type.
               Specifies the user timing value. The value is in milliseconds.
               utt - user timing time - 123
               
               User timing label
               Optional.
               utl - user timing label - label
               
               ----
                v=1              // Version.
                &tid=UA-XXXXX-Y  // Tracking ID / Property ID.
                &cid=555         // Anonymous Client ID.
                
                &t=timing        // Timing hit type.
                &utc=jsonLoader  // Timing category.
                &utv=load        // Timing variable.
                &utt=5000        // Timing time.
                &utl=jQuery      // Timing label.
                
                 // These values are part of browser load times
                
                &dns=100         // DNS load time.
                &pdt=20          // Page download time.
                &rrt=32          // Redirect time.
                &tcp=56          // TCP connect time.
                &srt=12          // Server response time.
            */
        
            if( (category == null) || (category == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "category is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            if( (name == null) || (name == "") )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "name is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            if( value < 0 )
            {
                if( _config && _config.enableErrorChecking )
                {
                    throw new ArgumentError( "value is empty" );
                }
                else
                {
                    return false;
                }
            }
            
            var values:Dictionary = new Dictionary();
            
                values[ Tracker.USER_TIMING_CATEGORY ] = category;
                values[ Tracker.USER_TIMING_VAR ] = name;
                values[ Tracker.USER_TIMING_TIME ] = value;
            
            if( label != "" )
            {
                values[ Tracker.USER_TIMING_LABEL ] = label;
            }
            
            if( timinginfo != null )
            {
                for( var entry:String in timinginfo )
                {
                    values[ entry ] = timinginfo[ entry ];
                }
            }
            
            return send( HitType.TIMING, values );
        }
        
    }
    
}