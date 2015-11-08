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
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    
    import libraries.uanalytics.tracking.AnalyticsTracker;
    import libraries.uanalytics.tracking.HitModel;
    import libraries.uanalytics.tracking.HitSender;
    
    /**
     * A <code>hitSender</code> implemented with <code>URLLoader</code>.
     * 
     * <p>
     * <b>Note:</b>
     * </p>
     * <pre>
     * When you use this class in Flash Player and in AIR application content
     * in security sandboxes other than then application security sandbox,
     * consider the following security model:
     * 
     *   - A SWF file in the local-with-filesystem sandbox may not load data
     *     from, or provide data to, a resource that is in the network sandbox.
     * 
     *   - By default, the calling SWF file and the URL you load must be in
     *     exactly the same domain. For example, a SWF file at www.adobe.com
     *     can load data only from sources that are also at www.adobe.com.
     *     To load data from a different domain, place a URL policy file on the
     *     server hosting the data.
     * 
     * </pre>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLLoader.html URLLoader
     */
    public class URLLoaderHitSender extends HitSender
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
         * Creates a URLLoaderHitSender.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        public function URLLoaderHitSender( tracker:AnalyticsTracker )
        {
            super();
            _tracker = tracker;
        }
        
        /**
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected function _hookEvents(loader:URLLoader):void
        {
            loader.addEventListener( Event.OPEN, onOpen );
            loader.addEventListener( ProgressEvent.PROGRESS , onProgress );
            loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
            loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
            loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
            loader.addEventListener( Event.COMPLETE, onComplete );
        }
        
        /**
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected function _unhookEvents(loader:URLLoader):void
        {
            loader.removeEventListener( Event.OPEN, onOpen );
            loader.removeEventListener( ProgressEvent.PROGRESS , onProgress );
            loader.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
            loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
            loader.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
            loader.removeEventListener( Event.COMPLETE, onComplete );
        }
        
        /**
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected function onOpen( event:Event ):void
        {
            //nothing
        }
        
        /**
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected function onProgress( event:ProgressEvent ):void
        {
            //nothing
        }
        
        /**
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected function onHTTPStatus( event:HTTPStatusEvent ):void
        {
            /* Note:
               Here you can deal with the HTTP response status
               see comments in LoaderHitSender.onHTTPStatus()
            */
        }
        
        /**
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected function onSecurityError( event:SecurityErrorEvent ):void
        {
            /* Note:
               An error occured and so we want to unhook all our events
            */
            _unhookEvents(event.target as URLLoader);
        }
        
        /**
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected function onIOError( event:IOErrorEvent ):void
        {
            /* Note:
               An error occured and so we want to unhook all our events
            */
            _unhookEvents(event.target as URLLoader);
        }
        
        /**
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected function onComplete( event:Event ):void
        {
            /* Note:
               We are done and so we want to unhook all our events
            */
            _unhookEvents(event.target as URLLoader);
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
            
            const loader:URLLoader = new URLLoader();
            
            _hookEvents(loader);
            var err:* = null;
            
            try
            {
                loader.load( request );
            }
            catch( e:Error )
            {
                _unhookEvents(loader);
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