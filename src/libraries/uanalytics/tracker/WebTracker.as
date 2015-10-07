/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker
{
    import flash.events.NetStatusEvent;
    import flash.net.SharedObject;
    import flash.net.SharedObjectFlushStatus;
    import flash.system.ApplicationDomain;
    
    import libraries.uanalytics.tracker.senders.LoaderHitSender;
    import libraries.uanalytics.tracking.Configuration;
    import libraries.uanalytics.tracking.HitModel;
    import libraries.uanalytics.tracking.RateLimiter;
    import libraries.uanalytics.tracking.Tracker;
    import libraries.uanalytics.utils.generateUUID;
    
    /**
     * A tracker specialised for the web.
     * 
     * <p>
     * The equivalent of <b>analytics.js</b> for online SWF files.
     * </p>
     * <pre>
     * analytics.js:
     * Each analytics.js tracker object starts with 20 hits that are replenished
     * at a rate of 2 hit per second. Applies to all hits except for ecommerce
     * (item or transaction).
     * </pre>
     * 
     * <p>
     * Features:
     * </p>
     * <ul>
     *   <li>
     *   <code>RateLimiter</code> settings: the tracker starts with 20 hits
     *   that are replenished at a rate of 2 hits per second.
     *   </li>
     *   <li>
     *   Data source is "web" by default.
     *   </li>
     *   <li>
     *   Use a <code>SharedObject</code> storage to save/restore the ClientId.
     *   </li>
     * </ul>
     * 
     * @example Usage
     * <listing>
     * import com.google.analytics.tracker.WebTracker;
     * 
     * var tracker:WebTracker = new WebTracker( "UA-12345-67" );
     * 
     *     tracer.pageview( "/hello/world", "Hello World" );
     * 
     * </listing>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://developers.google.com/analytics/devguides/collection/protocol/v1/limits-quotas Limits and Quotas
     */
    public class WebTracker extends DefaultTracker
    {
        protected var _storage:SharedObject;
        
        public function WebTracker( trackingId:String = "",
                                    config:Configuration = null )
        {
            super( trackingId, config );
        }
        
        /**
         * @private
         * 
         * Here the slight differences with the <code>DefaultTracker</code>
         * <ul>
         *   <li>different settings for the RateLimiter</li>
         *   <li>define the default data source as "web"</li>
         *   <li>use a storage to save/restore the ClientId</li>
         * </ul>
         */
        protected override function _ctor( trackingId:String = "" ):void
        {
            _model     = new HitModel();
            _temporary = new HitModel();
            
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
               the tracker starts with 20 hits
               that are replenished at a rate of 2 hits per second.
            */
            _limiter = new RateLimiter( 20, 2, 1 );
            
            if( trackingId != "" )
            {
                set( TRACKING_ID, trackingId );
            }
            
            var cid:String = _getClientID();
            if( cid != "" )
            {
                set( CLIENT_ID, cid );
            }
            
            set( Tracker.DATA_SOURCE, DataSource.WEB );
        }
        
        /**
         * @private
         * 
         * A storage mecanism based on <code>SharedObject</code>
         * to save and/or restore the ClientId.
         */
        protected override function _getClientID():String
        {
            // Load the SharedObject '_ga'
            _storage = SharedObject.getLocal( _config.storageName );
            var cid:String;
            
            if( !_storage.data.clientid )
            {
                // CID not found, generate Client ID
                cid = generateUUID();
                
                // Save CID into SharedObject
                _storage.data.clientid = cid;
                
                var flushStatus:String = null;
                try
                {
                    flushStatus = _storage.flush( 1024 ); //1KB
                }
                catch( e:Error )
                {
                    //trace( "Could not write SharedObject to disk: " + e.message );
                }
                
                if( flushStatus != null )
                {
                    switch( flushStatus )
                    {
                        case SharedObjectFlushStatus.PENDING:
                        // Requesting permission to save object...
                        _storage.addEventListener( NetStatusEvent.NET_STATUS, onFlushStatus );
                        break;
                        
                        case SharedObjectFlushStatus.FLUSHED:
                        // Value flushed to disk"
                        break;
                    }
                }
                
            }
            else
            {
                // CID found, restore from SharedObject
                cid = _storage.data.clientid;
            }
            
            return cid;
        }
        
        protected function onFlushStatus( event:NetStatusEvent ):void
        {
            // User closed permission dialog...
            _storage.removeEventListener( NetStatusEvent.NET_STATUS, onFlushStatus);
            
            switch( event.info.code )
            {
                case "SharedObject.Flush.Success":
                // User granted permission, value saved
                break;
                
                case "SharedObject.Flush.Failed":
                // User denied permission, value not saved
                break;
            }
        }
        
    }
}