/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker.senders
{
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    
    import libraries.uanalytics.tracking.AnalyticsTracker;
    import libraries.uanalytics.tracking.Configuration;
    import libraries.uanalytics.tracking.HitModel;
    import libraries.uanalytics.tracking.HitSender;

    /**
     * The <code>DebugHitSender</code> will send hit requests
     * to the Measurement Protocol Validation Server.
     * 
     * <p>
     * To ensure that your hits are correctly formatted and contain all required
     * parameters, you can test them against the validation server before
     * deploying them to production.
     * </p>
     * 
     * <p>
     * The sender use the endpoint <code>/debug/collect</code>
     * instead of <code>/collect</code>.
     * Hits sent to the Measurement Protocol Validation Server will not show up
     * in reports. They are for debugging only.
     * </p>
     * 
     * @see http://developers.google.com/analytics/devguides/collection/protocol/v1/validating-hits Validating Hits
     */
    public class DebugHitSender extends URLLoaderHitSender
    {
        
        public function DebugHitSender( tracker:AnalyticsTracker )
        {
            super( tracker );
        }
        
        protected override function onComplete( event:Event ):void
        {
            const loader:URLLoader = event.target as URLLoader;
            
            trace( "onLoaderComplete()" );
            _unhookEvents(loader);
            
            var raw:String = String( loader.data );
            
            trace( "Measurement Protocol Validation Server:" );
            trace( "--------" );
            //trace( raw );
            //trace( "--------" );
            var obj:Object = JSON.parse( raw );
            var json:String = JSON.stringify( obj, null, "    " );
            trace( json );
            
            var payload:String = obj.hitParsingResult[0].hit.split( "/debug/collect?" ).join( "" );
            var data:Array = payload.split( "&" );
            var i:uint;
            var pair:Array;
            for( i = 0; i < data.length; i ++ )
            {
                pair = data[i].split( "=" );
                trace( "  " + pair[0] + " = " + decodeURIComponent( pair[1] ) );
            }
            trace( "--------" );
        }
        
        /** @inheritDoc */
        public override function send( model:HitModel ):void
        {
            var payload:String = _buildHit( model );
            var url:String     = "";
            
            var sendViaPOST:Boolean = false;
            
            if( _tracker.config.forcePOST ||
                (payload.length > _tracker.config.maxGETlength) )
            {
                sendViaPOST = true;
            }
            
            if( payload.length > _tracker.config.maxPOSTlength )
            {
                throw new ArgumentError( "POST data is bigger than " + _tracker.config.maxPOSTlength + " bytes." );
            }
            
            if( _tracker.config.forceSSL )
            {
                url = _tracker.config.secureEndpoint.replace( "/collect", "/debug/collect" );
            }
            else
            {
                url = _tracker.config.endpoint.replace( "/collect", "/debug/collect" );
            }
            
            var request:URLRequest = new URLRequest();
            request.url = url;
            
            if( sendViaPOST )
            {
                request.method = URLRequestMethod.POST;
            }
            else
            {
                request.method = URLRequestMethod.GET;
            }
            
            request.data = payload;
            
            trace( "payload:" );
            trace( "--------" );
            trace( payload );
            var data:Array = payload.split( "&" );
            var i:uint;
            var pair:Array;
            for( i = 0; i < data.length; i ++ )
            {
                pair = data[i].split( "=" );
                trace( "  " + pair[0] + " = " + decodeURIComponent( pair[1] ) );
            }
            trace( "--------" );
            
            const loader:URLLoader = new URLLoader();
            
            /* Note:
            the Measurement Protocol Validation Server
            returns data in JSON format, so we want TEXT
            */
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            
            _hookEvents(loader);
            var err:* = null;
            
            try
            {
                loader.load( request );
            }
            catch( e:Error )
            {
                _unhookEvents(loader);
                trace( "unable to load requested page." );
                trace( "Error: " + e.message );
                err = e;
            }
            
            if( err )
            {
                throw err;
            }
            
        }
        
    }
}