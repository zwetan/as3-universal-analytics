/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics
{
    
    import flash.crypto.generateRandomBytes;
    import flash.display.Loader;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.net.SharedObject;
    import flash.net.SharedObjectFlushStatus;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.utils.ByteArray;

    /* Note:
       this code is not supported, not exception.
    */
    [ExcludeClass]
    public class SimplestTracker
    {
        private var _so:SharedObject;
        private var _loader:Loader;
        
        public var trackingID:String;
        public var clientID:String;
        
        public function SimplestTracker( trackingID:String )
        {
            trace( "SimplestTracker starts" );
            this.trackingID = trackingID;
            trace( "trackingID = " + trackingID );
            
            trace( "obtain the Client ID" );
            this.clientID  = _getClientID();
            trace( "clientID = " + clientID );
        }
        
        private function onFlushStatus( event:NetStatusEvent ):void
        {
            _so.removeEventListener( NetStatusEvent.NET_STATUS, onFlushStatus);
            trace( "User closed permission dialog..." );
            
            switch( event.info.code )
            {
                case "SharedObject.Flush.Success":
                trace( "User granted permission, value saved" );
                break;
                
                case "SharedObject.Flush.Failed":
                trace( "User denied permission, value not saved" );
                break;
            }
        }
        
        private function onLoaderUncaughtError( event:UncaughtErrorEvent ):void
        {
            trace( "onLoaderUncaughtError()" );
            
            if( event.error is Error )
            {
                var error:Error = event.error as Error;
                trace( "Error: " + error );
            }
            else if( event.error is ErrorEvent )
            {
                var errorEvent:ErrorEvent = event.error as ErrorEvent;
                trace( "ErrorEvent: " + errorEvent );
            }
            else
            {
                trace( "a non-Error, non-ErrorEvent type was thrown and uncaught" );
            }
            
            _removeLoaderEventsHook();
        }
        
        private function onLoaderHTTPStatus( event:HTTPStatusEvent ):void
        {
            trace( "onLoaderHTTPStatus()" );
            trace( "status: " + event.status );
            
            if( event.status == 200 )
            {
                trace( "the request was accepted" );
            }
            else
            {
                trace( "the request was not accepted" );
            }
        }
        
        private function onLoaderIOError( event:IOErrorEvent ):void
        {
            trace( "onLoaderIOError()" );
            _removeLoaderEventsHook();
        }
        
        private function onLoaderComplete( event:Event ):void
        {
            trace( "onLoaderComplete()" );
            
            trace( "done" );
            _removeLoaderEventsHook();
        }
        
        private function _removeLoaderEventsHook():void
        {
            _loader.uncaughtErrorEvents.removeEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, onLoaderUncaughtError );
            _loader.contentLoaderInfo.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onLoaderHTTPStatus );
            _loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoaderComplete );
            _loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onLoaderIOError );
        }
        
        private function _generateUUID():String
        {
           var randomBytes:ByteArray = generateRandomBytes( 16 );
            randomBytes[6] &= 0x0f; /* clear version */
            randomBytes[6] |= 0x40; /* set to version 4 */
            randomBytes[8] &= 0x3f; /* clear variant */
            randomBytes[8] |= 0x80; /* set to IETF variant */
            
            var toHex:Function = function( n:uint ):String
            {
                var h:String = n.toString( 16 );
                h = (h.length > 1 ) ? h: "0"+h;
                return h;
            }
            
            var str:String = "";
            var i:uint;
            var l:uint = randomBytes.length;
            randomBytes.position = 0;
            var byte:uint;
            
            for( i=0; i<l; i++ )
            {
                byte = randomBytes[ i ];
                str += toHex( byte );
            }
            
            var uuid:String = "";
            uuid += str.substr( 0, 8 );
            uuid += "-";
            uuid += str.substr( 8, 4 );
            uuid += "-";
            uuid += str.substr( 12, 4 );
            uuid += "-";
            uuid += str.substr( 16, 4 );
            uuid += "-";
            uuid += str.substr( 20, 12 );
            
            return uuid;
        }
        
        private function _getClientID():String
        {
            return _generateUUID();
        
            trace( "Load the SharedObject '_ga'" );
            _so = SharedObject.getLocal( "_ga" );
            var cid:String;
            
            if( !_so.data.clientid )
            {
                trace( "CID not found, generate Client ID" );
                cid = _generateUUID();
                
                trace( "Save CID into SharedObject" );
                _so.data.clientid = cid;
                
                var flushStatus:String = null;
                try
                {
                    flushStatus = _so.flush( 1024 ); //1KB
                }
                catch( e:Error )
                {
                    trace( "Could not write SharedObject to disk: " + e.message );
                }
                
                if( flushStatus != null )
                {
                    switch( flushStatus )
                    {
                        case SharedObjectFlushStatus.PENDING:
                        trace( "Requesting permission to save object..." );
                        _so.addEventListener( NetStatusEvent.NET_STATUS, onFlushStatus);
                        break;
                        
                        case SharedObjectFlushStatus.FLUSHED:
                        trace( "Value flushed to disk" );
                        break;
                    }
                }
                
            }
            else
            {
                trace( "CID found, restore from SharedObject" );
                cid = _so.data.clientid;
            }
            
            return cid;
        }
        
        public function sendPageview( page:String, title:String = "" ):void
        {
            trace( "sendPageview()" );
            
            var payload:Array = [];
                payload.push( "v=1" );
                payload.push( "tid=" + trackingID );
                payload.push( "cid=" + clientID );
                payload.push( "t=pageview" );
                payload.push( "dh=localhost" );
                //payload.push( "dh=tracking.redtamarin.com" );
                /*payload.push( "dh=mydomain.com" ); */
                payload.push( "dp=" + encodeURIComponent( page ) );
                
            if( title && (title.length > 0) )
            {
                payload.push( "dt=" + encodeURIComponent( title ) );    
            }
            
            var url:String = "";
                url += "http://www.google-analytics.com/collect";

            var request:URLRequest = new URLRequest();
                request.method = URLRequestMethod.GET;
                request.url    = url;
                request.data   = payload.join( "&" );

            trace( "request is: " + request.url + "?" + request.data );
                
            _loader = new Loader();
            _loader.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, onLoaderUncaughtError );
            _loader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, onLoaderHTTPStatus );
            _loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaderComplete );
            _loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onLoaderIOError );
            
            try
            {
                trace( "Loader send request" );
                _loader.load( request );
            }
            catch( e:Error )
            {
                trace( "unable to load requested page: " + e.message );
                _removeLoaderEventsHook();
            }
            
        }
    }
    
}