/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker
{
    import flash.utils.Dictionary;
    
    import libraries.uanalytics.tracker.senders.BSDSocketHitSender;
    import libraries.uanalytics.tracking.Configuration;
    import libraries.uanalytics.tracking.HitModel;
    import libraries.uanalytics.tracking.HitSampler;
    import libraries.uanalytics.tracking.RateLimitError;
    import libraries.uanalytics.tracking.RateLimiter;
    import libraries.uanalytics.tracking.Tracker;
    import libraries.uanalytics.utils.generateCLIUUID;
    import libraries.uanalytics.utils.getCLIHostname;
    
    import shell.Domain;
    
    /**
     * Default Google Analytics tracker implementation for the command-line.
     * 
     * <p>
     * This tracker is to be considered as a basic common denominator,
     * but you would want to customise it for different use cases. 
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
     *   It uses by default the <code>BSDSocketHitSender</code>.
     *   </li>
     *   <li>
     *   The Data Source "commandline" is defined by default.
     *   </li>
     *   <li>
     *   It will work with Redtamarin on the command-line, not with Flash or AIR.
     *   </li>
     * </ul>
     * 
     * @example Usage
     * <listing>
     * import com.google.analytics.tracker.CommandLineTracker;
     * import com.google.analytics.tracking.Configuration;
     * 
     * // we want to override the default config
     * var config:Configuration = new Configuration();
     *     //we want to throw errors
     *     config.enableErrorChecking = true;
     * 
     * /&#42; be careful here
     *    the command-line have access to much less sender
     *    - the default BSDSocketHitSender
     *      will work everywhere but does not support SSL
     *      and so will nto work with "/debug/collect" which needs HTTPS
     *    - the CurlHitSender
     *      will work as long as curl is available on the system
     *      and because it reuse curl it supports SSL and "/debug/collect"
     *    - the TraceHitSender
     *      which does not use any mecanism to send to a URL
     *      but only trace(0 the data to send
     * &#42;/
     *     //we want to use the cURL sender so we can use debug
     *     config.senderType = "libraries.uanalytics.tracker.senders.CurlHitSender";
     * 
     * //replace this with a valid Tracking ID
     * var trackingID:String = "UA-12345-67";
     * 
     * // if you want to see results on the standard output
     * var verbose:Boolean = true;
     * 
     * // if you want to use the validation servers
     * var debug:Boolean = true;
     * 
     * // if you want to see specific sender error for debugging
     * var senderErrorChecking:Boolean = false;
     * 
     * /&#42; At the contrary of the trackers for Flash / AIR
     *    a command-line tracker need a bit more configuration.
     *    on top of the usual trackingID and config
     *    you will want to configure the verbose, debug and senderErrorChecking
     * &#42;/
     * var tracker:CommandLineTracker = new CommandLineTracker( trackingID,
     *                                                          config,
     *                                                          verbose,
     *                                                          debug
     *                                                          senderErrorChecking );
     * </listing>
     * 
     * @playerversion AVM 0.4
     * @playerversion POSIX +
     * @langversion 3.0
     */
    public class CommandLineTracker extends Tracker
    {
        
        protected var _verbose:Boolean;
        protected var _debug:Boolean;
        protected var _senderErrorChecking:Boolean;
        
        /**
         * Create a new Tracker with no data model fields set.
         * 
         * @param trackingId the Tracking ID
         * @param config the tracker configuration
         * @param verbose enable sender verbose mode
         * @param debug enable sender debug mode
         * @param senderErrorChecking enable sender error checking
         */
        public function CommandLineTracker( trackingId:String = "",
                                            config:Configuration = null,
                                            verbose:Boolean = false,
                                            debug:Boolean = false,
                                            senderErrorChecking:Boolean = false )
        {
            super();
            
            if( !config )
            {
                config = new Configuration();
            }
            
            _config = config;
            _verbose = verbose;
            _debug  = debug;
            _senderErrorChecking = senderErrorChecking;
            _ctor( trackingId );
        }
        
        /**
         * @private
         * 
         * We want to move the constructor logic into a method
         * so when we inherit it we can prevent the build and replace it
         * with other custom builds.
         */
        protected function _ctor( trackingId:String = "" ):void
        {
            _model     = new HitModel();
            _temporary = new HitModel();
            
            /* Note:
               our default safe sender for the CLI is BSDSocketSender
               but we want to be able ot dynamically instantiate
               other type of sender with config.senderType
            */
            if( _config.senderType != "" )
            {
                var S:Class = Domain.currentDomain.getClass( _config.senderType );
                _sender = new S( this );
                
                if( _config.senderType.indexOf( "CurlHitSender" ) > -1 )
                {
                    if( _verbose )
                    {
                        S(_sender).verbose = _verbose;
                    }

                    if( _debug )
                    {
                        S(_sender).debug = _debug;
                    }
                    
                    if( _senderErrorChecking )
                    {
                        S(_sender).enableErrorChecking = _senderErrorChecking;
                    }
                }
                
            }
            else
            {
                _sender = new BSDSocketHitSender( this );
                
                if( _debug )
                {
                    BSDSocketHitSender(_sender).verbose = _verbose;
                }
                
                if( _debug )
                {
                    BSDSocketHitSender(_sender).debug = _debug;
                }
                
                if( _senderErrorChecking )
                {
                    BSDSocketHitSender(_sender).enableErrorChecking = _senderErrorChecking;
                }
                
            }
            
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
            
            set( Tracker.DATA_SOURCE, DataSource.COMMAND_LINE );
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
            return generateCLIUUID();
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
            
            var copy:HitModel = _model.clone();
                copy.add( _temporary );
            
            _temporary.clear();
            
            if( tempValues != null )
            {
                for( var entry:String in tempValues )
                {
                    copy.set( entry, tempValues[entry] );
                }
            }
            
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
            try
            {
                _sender.send( copy );
            }
            catch( e:Error )
            {
                err = e;
            }
            
            if( _config && _config.enableErrorChecking && err )
            {
                throw err;
            }
            
            if( err )
            {
                return false;
            }
            
            return true;
        }
        
        /** @inheritDoc */
        public override function pageview( path:String, title:String = "" ):Boolean
        {
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

            var hostname:String = get( Tracker.DOCUMENT_HOSTNAME );
            if( hostname == null )
            {
                hostname = getCLIHostname();
                
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
                        
            return send( HitType.PAGEVIEW, values );
        }
        
        /** @inheritDoc */
        public override function screenview( name:String, appinfo:Dictionary = null ):Boolean
        {
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