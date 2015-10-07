/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker.senders
{
    import flash.errors.MemoryError;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLStream;
    
    import libraries.uanalytics.tracking.AnalyticsTracker;
    import libraries.uanalytics.tracking.HitModel;
    import libraries.uanalytics.tracking.HitSender;
    
    /**
     * A <code>hitSender</code> implemented with <code>URLStream</code>.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLStream.html URLStream
     */
    public class URLStreamHitSender extends HitSender
    {
        
        /**
         * An Analytics tracker.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected var _tracker:AnalyticsTracker;
        
        /**
         * A URLStream.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected var _loader:URLStream;

        /**
         * Creates a URLStreamHitSender.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */        
        public function URLStreamHitSender( tracker:AnalyticsTracker )
        {
            super();
            _tracker = tracker;
            _loader  = new URLStream();
        }
        
        protected function _hookEvents():void
        {
            _loader.addEventListener( Event.OPEN, onOpen );
            _loader.addEventListener( ProgressEvent.PROGRESS, onProgress );
            _loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
            //_loader.addEventListener( HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHTTPResponseStatus );
            _loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
            _loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
            _loader.addEventListener( Event.COMPLETE, onComplete );
        }
        
        protected function _unhookEvents():void
        {
            _loader.removeEventListener( Event.OPEN, onOpen );
            _loader.removeEventListener( ProgressEvent.PROGRESS, onProgress );
            _loader.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
            //_loader.removeEventListener( HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHTTPResponseStatus );
            _loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
            _loader.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
            _loader.removeEventListener( Event.COMPLETE, onComplete );
        }
        
        protected function onOpen( event:Event ):void
        {
            //trace( "onOpen()" );
        }
        
        protected function onProgress( event:ProgressEvent ):void
        {
            //trace( "onProgress()" );
        }
        
        protected function onHTTPStatus( event:HTTPStatusEvent ):void
        {
            //trace( "onHTTPStatus()" );
        }
        
        protected function onHTTPResponseStatus( event:HTTPStatusEvent ):void
        {
            //trace( "onHTTPResponseStatus()" );
        }
        
        protected function onSecurityError( event:SecurityErrorEvent ):void
        {
            /* Note:
               An error occured and so we want to unhook all our events
            */
            _unhookEvents();
            //trace( "onSecurityError()" );
        }
        
        protected function onIOError( event:IOErrorEvent ):void
        {
            /* Note:
               An error occured and so we want to unhook all our events
            */
            _unhookEvents();
            //trace( "onIOError()" );
        }
        
        protected function onComplete( event:Event ):void
        {
            /* Note:
               We are done and so we want to unhook all our events
            */
            _unhookEvents();
            //trace( "onComplete()" );
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
                url = _tracker.config.secureEndpoint;
            }
            else
            {
                url = _tracker.config.endpoint;
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
            
            _hookEvents();
            var err:* = null;
            
            try
            {
                _loader.load( request );
            }
            catch( e:ArgumentError )
            {
                _unhookEvents();
                //trace( "objects may not contain certain prohibited HTTP request headers." );
                //trace( "ArgumentError: " + e.message );
                err = e;
            }
            catch( e:MemoryError )
            {
                _unhookEvents();
                /*
                if( request.method == URLRequestMethod.GET )
                {
                    trace( "cannot convert the URLRequest.data parameter from UTF8 to MBCS." );
                }
                else if( request.method == URLRequestMethod.POST )
                {
                    trace( "cannot allocate memory for the POST data." );
                }
                */
                
                //trace( "MemoryError: " + e.message );
                err = e;
            }
            catch( e:SecurityError )
            {
                _unhookEvents();
                //trace( "Local untrusted SWF files may not communicate with the Internet." );
                //trace( "OR" );
                //trace( "You are trying to connect to a commonly reserved port." );
                //trace( "Error: " + e.message );
                err = e;
            }
            catch( e:Error )
            {
                _unhookEvents();
                //trace( "unable to load requested page." );
                //trace( "Error: " + e.message );
                err = e;
            }
            
            if( err )
            {
                throw err;
            }
            
        }
        
    }
}