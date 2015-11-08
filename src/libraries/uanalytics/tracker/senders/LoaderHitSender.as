/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker.senders
{
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.errors.IOError;
    import flash.errors.IllegalOperationError;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    
    import libraries.uanalytics.tracking.AnalyticsTracker;
    import libraries.uanalytics.tracking.HitModel;
    import libraries.uanalytics.tracking.HitSender;
    
    /**
     * A simple implementation that will send hit data to Google Analytics servers.
     * 
     * <p>
     * This is the default implementation we use in all the Flash and AIR trackers
     * for the following reasons:
     * </p>
     * <ul>
     *   <li>
     *   "You can load content from any accessible source",
     *    and HTTP on port 80 and HTTPS on port 443 are not blocked by default.
     *   </li>
     *   <li>
     *   a send call is about sending but not receiving variables to an URL,
     *   we will not get cross-scripting or other security errors trying to load
     *   the content.
     *   </li>
     *   <li>
     *   It will work by default when you test locally from Flash CS, FlashCC,
     *   Flash Builder, etc.
     *   </li>
     *   <li>
     *   It will work by default when you publish a SWF file to be hosted online.
     *   </li>
     *   <li>
     *   It will work by default when you publish an AIR application.
     *   </li>
     * </ul>
     * 
     * <p>
     * The only problem you can encounter is with local SWF files outside the
     * "User Flash Player Trust directories".
     * By default a local SWF file is placed in the <b>local-with-filesystem</b> sandbox
     * see <a href="http://help.adobe.com/en_US/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7e3f.html" target="_blank">security sandboxes</a>
     * and will prevent the tracking to work (as it can not access the network).
     * Although, this behaviour can be changed by setting the document’s publish
     * settings in the authoring tool.
     * </p>
     * <ul>
     *   <li>
     *   It will still works for local SWF in developer environments as they are
     *   placed by default in the "User Flash Player Trust directories"
     *   </li>
     *   <li>
     *   You can detect from your code the <code>Security.sandboxType</code> to
     *   know if the SWF file has been published with <code>Security.LOCAL_WITH_FILE</code>
     *   or <code>Security.LOCAL_WITH_NETWORK</code>
     *   </li>
     *   <li>
     *   A local SWF file or projector executable published <b>local-with-filesystem</b>
     *   and which is not in the "User Flash Player Trust directories" will not
     *   be able to send tracking data over the network.
     *   </li>
     *   <li>
     *   A local SWF file or projector executable published <b>local-with-networking</b>
     *   wether or not is in the "User Flash Player Trust directories" will be
     *   able to send trackign data over the network.
     *   </li>
     * </ul>
     * 
     * <p>
     * Different and More complicated implementations could do more things;
     * for example: queue hits and send them at a later time, validate the hit
     * by checking the HTTP response code, etc.
     * </p>
     * 
     * <p>
     * <b>Note:</b>
     * </p>
     * <pre>
     * When you use the Loader class, consider the Flash Player
     * and Adobe AIR security model:
     * 
     *   - You can load content from any accessible source.
     * 
     *   - Loading is not allowed if the calling SWF file is in a network sandbox
     *     and the file to be loaded is local.
     * 
     *   - If the loaded content is a SWF file written with ActionScript 3.0,
     *     it cannot be cross-scripted by a SWF file in another security sandbox
     *     unless that cross-scripting arrangement was approved through a call
     *     to the System.allowDomain() or the System.allowInsecureDomain() method
     *     in the loaded content file.
     * 
     *   - If the loaded content is an AVM1 SWF file
     *     (written using ActionScript 1.0 or 2.0), it cannot be cross-scripted
     *     by an AVM2 SWF file (written using ActionScript 3.0). However, you
     *     can communicate between the two SWF files by using the LocalConnection class.
     * 
     *   - If the loaded content is an image, its data cannot be accessed by a
     *     SWF file outside of the security sandbox, unless the domain of that
     *     SWF file was included in a URL policy file at the origin domain of
     *     the image.
     * 
     *   - Movie clips in the local-with-file-system sandbox cannot script movie
     *     clips in the local-with-networking sandbox, and the reverse is also
     *     prevented.
     * 
     *   - You cannot connect to commonly reserved ports. For a complete list of
     *     blocked ports, see “Restricting Networking APIs” in the ActionScript
     *     3.0 Developer’s Guide.
     * 
     * However, in AIR, content in the application security sandbox
     * (content installed with the AIR application) are not restricted by these
     * security limitations.
     * </pre>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Loader.html Loader
     * @see http://help.adobe.com/en_US/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7e3f.html Security sandboxes
     * @see http://help.adobe.com/en_US/as3/dev/WS1EFE2EDA-026D-4d14-864E-79DFD56F87C6.html Restricting networking APIs
     */
    public class LoaderHitSender extends HitSender
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
         * Creates a LoaderHitSender.
         * 
         * @param tracker an analytics tracker
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        public function LoaderHitSender( tracker:AnalyticsTracker )
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
        protected function _hookEvents(loader:Loader):void
        {
            loader.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError );
            
            loader.contentLoaderInfo.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
            loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
            loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onComplete );
        }
        
        /**
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected function _unhookEvents(loader:Loader):void
        {
            loader.uncaughtErrorEvents.removeEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError );
            
            loader.contentLoaderInfo.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
            loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
            loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onComplete );
        }
        
        /**
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @langversion 3.0
         */
        protected function onUncaughtError( event:UncaughtErrorEvent ):void
        {
            /* Note:
               An error occured and so we want to unhook all our events
            */
            _unhookEvents(event.target as Loader);
            
            var error:Error;
            
            if( event.error is Error )
            {
                error = event.error as Error;
            }
            else if( event.error is ErrorEvent )
            {
                var errorEvent:ErrorEvent = event.error as ErrorEvent;
                error = new Error( errorEvent.text, errorEvent.errorID );
            }
            else
            {
                error = new Error( "a non-Error, non-ErrorEvent type was thrown and uncaught" );
            }
            
            if( _tracker.config.enableErrorChecking )
            {
                throw error;
            }
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
               An advanced implementation could detect the HTTP status code
               and if not equal to 200 block any following hit requests.
               
               see:
               Response Codes https://developers.google.com/analytics/devguides/collection/protocol/v1/reference#response-codes
               
               The Measurement Protocol will return a 2xx status code if the
               HTTP request was received.
               The Measurement Protocol does not return an error code if the
               payload data was malformed, or if the data in the payload was
               incorrect or was not processed by Google Analytics.

               If you do not get a 2xx status code, you should NOT retry the request.
               Instead, you should stop and correct any errors in your HTTP request.
            */
            /*
            if( event.status == 200 )
            {
                // do something here
            }
            */
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
            const loaderInfo:LoaderInfo = event.target as LoaderInfo;
            _unhookEvents(loaderInfo.loader);
            
            if( _tracker.config.enableErrorChecking )
            {
                var error:IOError = new IOError( event.text, event.errorID );
                throw error;
            }
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
            const loaderInfo:LoaderInfo = event.target as LoaderInfo;
            _unhookEvents(loaderInfo.loader);
        }
        
        /** @inheritDoc */
        public override function send( model:HitModel ):void
        {
            var payload:String = _buildHit( model );
            var url:String     = "";
            
            /* Note:
               It is more performant to send a GET request
               so by default we want to send a GET request
            */
            var sendViaPOST:Boolean = false;
            
            /* Note:
               unless we forcePOST
               or the payload size is bigger than maxGETlength (2000 bytes)
               then we send a POST request
            */
            if( _tracker.config.forcePOST ||
                (payload.length > _tracker.config.maxGETlength) )
            {
                sendViaPOST = true;
            }
            
            /* Note:
               if payload is bigger than maxPOSTlength (8192 bytes)
               Google Analytics backend will ignore the request
            */
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
            
            // we build the request
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
            
            const loader:Loader = new Loader();
            
            _hookEvents(loader);
            var err:* = null;
            
            /* Note:
               Here we wrap the sender call in a try/catch
               only to remove our event listeners if an error occur
               but we do want to throw errors.
               
               this is not the same as config.enableErrorChecking
               in a tracker.
            */
            try
            {
                // we send the request
                loader.load( request );
            }
            catch( e:IOError )
            {
                _unhookEvents(loader);
                //trace( "unable to load requested page." );
                //trace( "IOError: " + e.message );
                err = e;
            }
            catch( e:SecurityError )
            {
                _unhookEvents(loader);
                //trace( "unable to load requested page." );
                //trace( "SecurityError: " + e.message );
                err = e;
            }
            catch( e:IllegalOperationError )
            {
                _unhookEvents(loader);
                //trace( "unable to load requested page." );
                //trace( "IllegalOperationError: " + e.message );
                err = e;
            }
            catch( e:Error )
            {
                _unhookEvents(loader);
                //trace( "unable to load requested page." );
                //trace( "Error: " + e.message );
                err = e;
            }
            
            // a HitSender always throw errors
            if( err )
            {
                throw err;
            }
            
        }
        
    }
}