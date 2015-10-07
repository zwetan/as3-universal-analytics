/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker
{
    import flash.utils.Dictionary;
    
    import libraries.uanalytics.tracking.Tracker;

    /**
     * The TimingInfo defines parameters meant to be used
     * for the Timing Tracking.
     * 
     * <p>
     * By default, all the parameters are empty (not initialised).
     * Only the non-empty (or initialised) parameters wil be exported
     * by the <code>toDictionary()</code> function.
     * </p>
     * 
     * @example Usage
     * <listing>
     * // define the timing info properties manually
     * var timeinfo:TimingInfo = new TimingInfo();
     *     timeinfo.tcpConnectTime = 100;
     *     timeinfo.pageLoadTime   = 500;
     * 
     * // pass it to the tracker
     * tracker.add( timeinfo.toDictionary() );
     * 
     * // OR pass it only for the current hit
     * tracker.timing( "timing", "application_load", 100, "", timeinfo.toDictionary() );
     * 
     * </listing>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see libraries.uanalytics.utils#generateAIRAppInfo() generateAIRAppInfo()
     */
    public class TimingInfo
    {
        
        /**
         * The time it took for a page to load.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#PAGE_LOAD_TIME Tracker.PAGE_LOAD_TIME
         */
        public var pageLoadTime:int         = -1;
        
        /**
         * The time it took to do a DNS lookup.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#DNS_TIME Tracker.DNS_TIME
         */
        public var dnsTime:int              = -1;
        
        /**
         * The time it took for the page to be downloaded.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#PAGE_DOWNLOAD_TIME Tracker.PAGE_DOWNLOAD_TIME
         */
        public var pageDownloadTime:int     = -1;
        
        /**
         * The time it took for any redirects to happen.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#REDIRECT_RESPONSE_TIME Tracker.REDIRECT_RESPONSE_TIME
         */
        public var redirectResponseTime:int = -1;
        
        /**
         * The time it took for a TCP connection to be made.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#TCP_CONNECT_TIME Tracker.TCP_CONNECT_TIME
         */
        public var tcpConnectTime:int       = -1;
        
        /**
         * The time it took for the server to respond after the
         * connect time.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#TIME Tracker.TIME
         */
        public var serverResponseTime:int   = -1;
        
        /**
         * The time it took for <code>Document.readyState</code>
         * to be 'interactive'.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#DOM_INTERACTIVE_TIME Tracker.DOM_INTERACTIVE_TIME
         */
        public var domInteractiveTime:int   = -1;
        
        /**
         * The time it took for the <code>DOMContentLoaded</code> Event
         * to fire.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#CONTENT_LOAD_TIME Tracker.CONTENT_LOAD_TIME
         */
        public var contentLoadTime:int      = -1;
        
        /**
         * Creates an empty TimingInfo.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function TimingInfo()
        {
            super();
        }
        
        /**
         * Export the initialised (non-empty) parameters.
         * 
         * @return a Dictionary containing field/value pairs.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function toDictionary():Dictionary
        {
            var values:Dictionary = new Dictionary();
            
            if( pageLoadTime > -1 )
            {
                values[ Tracker.PAGE_LOAD_TIME ] = String(pageLoadTime);
            }
            
            if( dnsTime > -1 )
            {
                values[ Tracker.DNS_TIME ] = String(dnsTime);
            }
            
            if( pageDownloadTime > -1 )
            {
                values[ Tracker.PAGE_DOWNLOAD_TIME ] = String(pageDownloadTime);
            }
            
            if( redirectResponseTime > -1 )
            {
                values[ Tracker.REDIRECT_RESPONSE_TIME ] = String(redirectResponseTime);
            }
            
            if( tcpConnectTime > -1 )
            {
                values[ Tracker.TCP_CONNECT_TIME ] = String(tcpConnectTime);
            }
            
            if( serverResponseTime > -1 )
            {
                values[ Tracker.SERVER_RESPONSE_TIME ] = String(serverResponseTime);
            }
            
            if( domInteractiveTime > -1 )
            {
                values[ Tracker.DOM_INTERACTIVE_TIME ] = String(domInteractiveTime);
            }
            
            if( contentLoadTime > -1 )
            {
                values[ Tracker.CONTENT_LOAD_TIME ] = String(contentLoadTime);
            }
            
            return values;
        }
    }
}