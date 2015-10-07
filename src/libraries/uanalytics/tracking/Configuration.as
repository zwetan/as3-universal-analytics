/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracking
{
    /**
     * Analytics Tracking Configuration.
     * 
     * <p>
     * Those are the default configuration settings used by all the trackers.<br>
     * It is possible to overide them and provide your own configuration.
     * </p>
     * 
     * <p>
     * You can change the configuration settings while in use by the trackers,
     * each time a hit request is send the configuration is applied again.
     * </p>
     * 
     * @example Usage
     * <listing>
     * var config:Configuration = new Configuration();
     *     config.forcePOST = true;
     *     config.forceSSL = true;
     *     config.anonymizeIp = true;
     * 
     * var tracker:WebTracker = new WebTracker( trackingID, config );
     * </listing>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see http://github.com/zwetan/as3-universal-analytics/wiki/TrackingConfiguration Tracking Configuration
     */
    public class Configuration
    {
        
        /**
         * The SDK version number and/or signature.
         * 
         * <p>
         * Will add the undocumented <code>_v</code> parameters
         * to every <code>hitSender</code> requests.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static var SDKversion:String = "as3uanalytics1";
    
        /* Note:
           Those variables should not be edited.
        */
        private var _endpoint:String = "http://www.google-analytics.com/collect";
        private var _secureEndpoint:String = "https://ssl.google-analytics.com/collect";
        private var _maxGETlength:uint = 2000;
        private var _maxPOSTlength:uint = 8192;
        private var _storageName:String = "_ga";
        
        
        /* read-write */

        /**
         * Allows to dynamically change the type of <code>HitSender</code>
         * used by the tracker.
         * 
         * <p>
         * If empty, the tracker will use the default <code>HitSender</code>:
         * <code>LoaderHitSender</code> for Flash and AIR,
         * <code>BSDSocketHitSender</code> for Redtamarin.
         * </p>
         * 
         * <p>
         * To override the <code>HitSender</code> you need to provide the full
         * class path, for example if oyu want to use <code>TraceHitSender</code>
         * use the string "libraries.uanalytics.tracker.senders.TraceHitSender",
         * not just "TraceHitSender".
         * </p>
         * 
         * <p>
         * <b>Attention:</b><br>
         * You will have to define a reference to this <code>HitSender</code>
         * in your code, otherwise the code reflection will not be able to find
         * it in memory.
         * </p>
         * 
         * @example usage
         * <listing>
         * //important!
         * var tmp:DebugHitSender;
         * 
         * config.senderType = "libraries.uanalytics.tracker.senders.DebugHitSender";
         * </listing>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public var senderType:String = "";

        /**
         * Specifies whether errors encountered by the trackers are reported
         * to the application.
         * 
         * <p>
         * Default to <code>false</code>, we don't want the tracker
         * to throw any errors at all.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public var enableErrorChecking:Boolean = false;

        /**
         * Specifies whether or not the <code>RateLimiter</code> will ensure
         * the tracker does not send too many hits at once.
         * 
         * <p>
         * Default to <code>true</code>, each trackers define by default the
         * capacity, rate and span of the number of hits that can be send.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see RateLimiter
         * @see http://github.com/zwetan/as3-universal-analytics/wiki/TrackingDetailsAndTricks#throttling Tracking Details and Tricks: Throttling
         */
        public var enableThrottling:Boolean = true;

        /**
         * Specifies whether or not a particular hit should be sent to
         * Google Analytics collection servers due to sampling.
         * 
         * <p>
         * Default to <code>true</code>, each tracker will use the <code>sampleRate</code>
         * to select a subset (in percentage) of data to send.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see HitSampler
         * @see #sampleRate
         * @see http://github.com/zwetan/as3-universal-analytics/wiki/TrackingDetailsAndTricks#sampling Tracking Details and Tricks: Sampling
         */
        public var enableSampling:Boolean = true;
        
        /**
         * Specifies whether a "cache buster" will be automatically added to the
         * hit request to ensure browsers and proxies don't cache hits.
         * 
         * <p>
         * Default to <code>false</code>, as in general we don't need it.
         * Also note that a cache buster will be used only with GET requests,
         * not with POST requests. 
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see http://developers.google.com/analytics/devguides/collection/protocol/v1/parameters#z Cache Buster
         */
        public var enableCacheBusting:Boolean = false;
        
        /**
         * Setting this property to <code>true</code> will force the <code>HitSender</code>
         * to use the HTTPS protocol.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public var forceSSL:Boolean = false;
        
        /**
         * Setting this property to <code>true</code> will force the <code>HitSender</code>
         * to use send requests using POST.
         * 
         * <p>
         * When processinga hit request we do check <code>maxGETlength</code>
         * and if the payload data is bigger the tracker will automatically switch
         * to POST.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public var forcePOST:Boolean = false;

        /**
         * Specifies what percentage of users should be tracked.
         * 
         * <p>
         * This defaults to 100 (no users are sampled out) but large sites may
         * need to use a lower sample rate to stay within Google Analytics
         * processing limits.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public var sampleRate:Number = 100.0;

        /**
         * If <code>true</code> the IP address of the sender will be anonymized.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see Tracker#ANON_IP Tracker.ANON_IP
         */
        public var anonymizeIp:Boolean = false;
        
        /**
         * Allows to override the IP address of the user.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see Tracker#IP_OVERRIDE Tracker.IP_OVERRIDE
         */
        public var overrideIpAddress:String = "";
        
        /**
         * Allows to override the User Agent of the browser.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see Tracker#USER_AGENT_OVERRIDE Tracker.USER_AGENT_OVERRIDE
         */
        public var overrideUserAgent:String = "";
        
        /**
         * Allows to override the geographical location of the user.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see Tracker#GEOGRAPHICAL_OVERRIDE Tracker.GEOGRAPHICAL_OVERRIDE
         * @see http://developers.google.com/analytics/devguides/collection/protocol/v1/geoid Geographical Targeting
         */
        public var overrideGeographicalId:String = "";
        
        
        /* read-only */
        
        /**
         * The URL Endpoint where to send the HTTP requests.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see http://developers.google.com/analytics/devguides/collection/protocol/v1/reference#endpoint URL Endpoint
         */
        public function get endpoint():String { return _endpoint; }
        
        /**
         * The Secure URL Endpoint where to send the HTTPS requests.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see http://developers.google.com/analytics/devguides/collection/protocol/v1/reference#endpoint URL Endpoint
         */
        public function get secureEndpoint():String { return _secureEndpoint; }
        
        /**
         * The length of the entire encoded URL must be no longer than 2000 Bytes.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see http://developers.google.com/analytics/devguides/collection/protocol/v1/reference#get GET
         */
        public function get maxGETlength():uint { return _maxGETlength; }
        
        /**
         * The POST body of a request must be no longer than 8192 bytes.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see http://developers.google.com/analytics/devguides/collection/protocol/v1/reference#using-post using POST
         */
        public function get maxPOSTlength():uint { return _maxPOSTlength; }
        
        /**
         * The name of the storage container.
         * 
         * <p>
         * A storage could be anything: <code>SharedObject</code>, File, DataBase, etc.
         * </p>
         * 
         * <p>
         * In general, the storage will only contain the <b>ClientId</b> and no other informations.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see Tracker#CLIENT_ID Tracker.CLIENT_ID
         */
        public function get storageName():String { return _storageName; }
        
        /**
         * Creates a new Configuration.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function Configuration()
        {
            super();
        }
    }
}