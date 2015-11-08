/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracking
{

    import flash.utils.Dictionary;

    /**
     * A base class for the Google Analytics tracker.
     * 
     * <p>
     * To be considered as an abstract class that provides
     * measurement protocol contants and utility methods
     * related to the <code>HitModel</code>.
     * </p>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     */
    public class Tracker implements AnalyticsTracker
    {
                
        // General
        /**
         * <b>Required for all hit types.</b>
         * <p>
         * The Protocol version.
         * </p>
         * 
         * <p>
         * The current value is <code>'1'</code>.
         * This will only change when there are changes made that are not
         * backwards compatible.
         * </p>
         * 
         * @example
         * <code>v=1</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const PROTOCOL_VERSION:String        = "protocolVersion";
        
        /**
         * <b>Required for all hit types.</b>
         * <p>
         * The tracking ID / web property ID.
         * </p>
         * 
         * <p>
         * The format is <code>UA-XXXX-Y</code>.
         * All collected data is associated by this ID.
         * </p>
         * 
         * @example
         * <code>tid=UA-XXXX-Y</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const TRACKING_ID:String             = "trackingId";
        
        /**
         * <b>Optional.</b>
         * <p>
         * When present, the IP address of the sender will be anonymized.
         * </p>
         * 
         * <p>
         * For example, the IP will be anonymized if any of the following
         * parameters are present in the payload: <code>&#38;aip=</code>,
         * <code>&#38;aip=0</code>, or <code>&#38;aip=1</code>
         * </p>
         * 
         * @example
         * <code>aip=1</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const ANON_IP:String                 = "anonymizeIp";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Indicates the data source of the hit.
         * </p>
         * 
         * <p>
         * Hits sent from analytics.js will have data source set to <code>'web'</code>;
         * hits sent from one of the mobile SDKs will have data source set to <code>'app'</code>.
         * </p>
         * 
         * @example
         * <code>ds=web</code>, 
         * <code>ds=app</code>. 
         * <code>ds=call%20center</code>, 
         * <code>ds=crm</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const DATA_SOURCE:String             = "dataSource";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Used to collect offline / latent hits.
         * </p>
         * 
         * <p>
         * The value represents the time delta (in milliseconds) between when
         * the hit being reported occurred and the time the hit was sent.
         * The value must be greater than or equal to 0.
         * Values greater than four hours may lead to hits not being processed.
         * </p>
         * 
         * @example
         * <code>qt=560</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const QUEUE_TIME:String              = "queueTime";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Used to send a random number in GET requests to ensure browsers and
         * proxies don't cache hits.
         * </p>
         * 
         * <p>
         * It should be sent as the final parameter of the request since we've
         * seen some 3rd party internet filtering software add additional
         * parameters to HTTP requests incorrectly.
         * This value is not used in reporting.
         * </p>
         * 
         * @example
         * <code>z=289372387623</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CACHE_BUSTER:String            = "cacheBuster";
        
        
        // User
        
        /**
         * <b>Required for all hit types.</b>
         * <p>
         * The Client ID anonymously identifies a particular user, device,
         * or browser instance.
         * </p>
         * 
         * <p>
         * For the web, this is generally stored as a first-party cookie with a
         * two-year expiration.
         * For mobile apps, this is randomly generated for each particular
         * instance of an application install.
         * The value of this field should be a random UUID (version 4) as
         * described in <a href="http://www.ietf.org/rfc/rfc4122.txt" tager="_blank">rfc4122</a>.
         * </p>
         * 
         * @example
         * <code>cid=35009a79-1a05-49d7-b876-2b884d0f825b</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CLIENT_ID:String               = "clientId";
        
        /**
         * <b>Optional.</b>
         * <p>
         * This is intended to be a known identifier for a user provided by
         * the site owner/tracking library user.
         * </p>
         * 
         * <p>
         * It must not itself be PII (personally identifiable information).
         * The value should never be persisted in GA cookies or other Analytics
         * provided storage.
         * </p>
         * 
         * @example
         * <code>uid=as8eknlll</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const USER_ID:String                 = "userId";
        
        
        // Session
        
        /**
         * <b>Optional.</b>
         * <p>
         * Used to control the session duration.
         * </p>
         * 
         * <p>
         * A value of 'start' forces a new session to start with this hit
         * and 'end' forces the current session to end with this hit.
         * All other values are ignored.
         * </p>
         * 
         * @example
         * <code>sc=start</code>, <code>sc=end</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const SESSION_CONTROL:String         = "sessionControl";
        
        /**
         * <b>Optional.</b>
         * <p>
         * The IP address of the user.
         * </p>
         * 
         * <p>
         * This should be a valid IP address in IPv4 or IPv6 format.
         * It will always be anonymized just as though <code>aip</code> (anonymize IP)
         * had been used.
         * </p>
         * 
         * @example
         * <code>uip=1.2.3.4</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const IP_OVERRIDE:String             = "ipOverride";
        
        /**
         * <b>Optional.</b>
         * <p>
         * The User Agent of the browser.
         * </p>
         * 
         * <p>
         * Note that Google has libraries to identify real user agents.
         * Hand crafting your own agent could break at any time.
         * </p>
         * 
         * @example
         * <code>ua=Opera%2F9.80%20%28Windows%20NT%206.0%29%20Presto%2F2.12.388%20Version%2F12.14</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const USER_AGENT_OVERRIDE:String     = "userAgentOverride";
        
        /**
         * <b>Optional.</b>
         * <p>
         * The geographical location of the user.
         * </p>
         * 
         * <p>
         * The geographical ID should be a two letter country code or a
         * criteria ID representing a city or region
         * (see <a href="http://developers.google.com/analytics/devguides/collection/protocol/v1/geoid" target="_blank">geoid</a>).
         * This parameter takes precedent over any location derived from IP
         * address, including the IP Override parameter.
         * An invalid code will result in geographical dimensions to be set to
         * '(not set)'.
         * </p>
         * 
         * @example
         * <code>geoid=21137</code>, <code>geoid=US</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const GEOGRAPHICAL_OVERRIDE:String   = "geographicalOverride";
        
        
        // Traffic Sources
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies which referral source brought traffic to a website.
         * </p>
         * 
         * <p>
         * This value is also used to compute the traffic source.
         * The format of this value is a URL.
         * </p>
         * 
         * @example
         * <code>dr=http%3A%2F%2Fexample.com</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const DOCUMENT_REFERRER:String       = "documentReferrer";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the campaign name.
         * </p>
         * 
         * @example
         * <code>cn=%28direct%29</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CAMPAIGN_NAME:String           = "campaignName";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the campaign source.
         * </p>
         * 
         * @example
         * <code>cs=%28direct%29</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CAMPAIGN_SOURCE:String         = "campaignSource";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the campaign medium.
         * </p>
         * 
         * @example
         * <code>cm=organic</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CAMPAIGN_MEDIUM:String         = "campaignMedium";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the campaign keyword.
         * </p>
         * 
         * @example
         * <code>ck=Blue%20Shoes</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CAMPAIGN_KEYWORD:String        = "campaignKeyword";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the campaign content.
         * </p>
         * 
         * @example
         * <code>cc=content</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CAMPAIGN_CONTENT:String        = "campaignContent";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the campaign ID.
         * </p>
         * 
         * @example
         * <code>ci=ID</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CAMPAIGN_ID:String             = "campaignId";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the Google AdWords Id.
         * </p>
         * 
         * @example
         * <code>gclid=CL6Q-OXyqKUCFcgK2goddQuoHg</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const GOOGLE_ADWORDS_ID:String       = "googleAdwordsId";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the Google Display Ads Id.
         * </p>
         * 
         * @example
         * <code>dclid=d_click_id</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const GOOGLE_DISPLAY_ADS_ID:String   = "googleDisplayAdsId";
        
        
        // System Info
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the screen resolution.
         * </p>
         * 
         * @example
         * <code>sr=800x600</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const SCREEN_RESOLUTION:String       = "screenResolution";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the viewable area of the browser / device.
         * </p>
         * 
         * @example
         * <code>vp=123x456</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const VIEWPORT_SIZE:String           = "viewportSize";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the character set used to encode the page / document.
         * </p>
         * 
         * @example
         * <code>de=UTF-8</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const DOCUMENT_ENCODING:String       = "documentEncoding";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the screen color depth.
         * </p>
         * 
         * @example
         * <code>sd=24-bits</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const SCREEN_COLORS:String           = "screenColors";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the language.
         * </p>
         * 
         * @example
         * <code>ul=en-us</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const USER_LANGUAGE:String           = "userLanguage";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies whether Java was enabled.
         * </p>
         * 
         * @example
         * <code>je=1</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const JAVA_ENABLED:String            = "javaEnabled";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the flash version.
         * </p>
         * 
         * @example
         * <code>fl=10%201%20r103</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const FLASH_VERSION:String           = "flashVersion";
        
        
        // Hit
        
        /**
         * <b>Required for all hit types.</b>
         * <p>
         * The type of hit. Must be one of 'pageview', 'screenview', 'event',
         * 'transaction', 'item', 'social', 'exception', 'timing'.
         * </p>
         * 
         * @example
         * <code>t=pageview</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const HIT_TYPE:String                = "hitType";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies that a hit be considered non-interactive.
         * </p>
         * 
         * @example
         * <code>ni=1</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const NON_INTERACTION:String         = "nonInteraction";
        
        
        // Content Information
        
        /**
         * <b>Optional.</b>
         * <p>
         * Use this parameter to send the full URL (document location) of the
         * page on which content resides.
         * </p>
         * 
         * <p>
         * You can use the <code>dh</code> and <code>dp</code> parameters to
         * override the hostname and path + query portions of the document
         * location, accordingly.
         * The JavaScript clients determine this parameter using the
         * concatenation of the <code>document.location.origin +
         * document.location.pathname + document.location.search</code> browser
         * parameters.
         * Be sure to remove any user authentication or other private information
         * from the URL if present.
         * 
         * For 'pageview' hits, either <code>dl</code>
         * or both <code>dh</code> and <code>dp</code> have to be specified for
         * the hit to be valid.
         * </p>
         * 
         * @example
         * <code>dl=http%3A%2F%2Ffoo.com%2Fhome%3Fa%3Db</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const DOCUMENT_LOCATION:String       = "documentLocation";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the hostname from which content was hosted.
         * </p>
         * 
         * @example
         * <code>dh=foo.com</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const DOCUMENT_HOSTNAME:String       = "documentHostname";
        
        /**
         * <b>Optional.</b>
         * <p>
         * The path portion of the page URL.
         * </p>
         * 
         * <p>
         * Should begin with '/'.
         * For 'pageview' hits, either <code>dl</code>
         * or both <code>dh</code> and <code>dp</code> have to be specified for
         * the hit to be valid.
         * </p>
         * 
         * @example
         * <code>dp=%2Ffoo</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const DOCUMENT_PATH:String           = "documentPath";
        
        /**
         * <b>Optional.</b>
         * <p>
         * The title of the page / document.
         * </p>
         * 
         * @example
         * <code>dt=Settings</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const DOCUMENT_TITLE:String          = "documentTitle";
        
        /**
         * <b>Required for all hit types.</b>
         * 
         * <p>
         * This parameter is optional on web properties, and required on mobile
         * properties for screenview hits, where it is used for the 'Screen Name'
         * of the screenview hit.
         * 
         * On web properties this will default to the unique URL of the page by
         * either using the <code>dl</code> parameter as-is
         * or assembling it from <code>dh</code> and <code>dp</code>.
         * </p>
         * 
         * @example
         * <code>cd=High%20Scores</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const SCREEN_NAME:String             = "screenName"; //also: Content Description
        
        /**
         * <b>Optional.</b>
         * <p>
         * The ID of a clicked DOM element.
         * </p>
         * 
         * <p>
         * Used to disambiguate multiple links to the same URL in
         * In-Page Analytics reports when Enhanced Link Attribution is enabled
         * for the property.
         * </p>
         * 
         * @example
         * <code>linkid=nav_bar</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const LINK_ID:String                 = "linkId";
        
        
        // App Tracking
        
        /**
         * <b>Required for all hit types.</b>
         * <p>
         * Specifies the application name.
         * </p>
         * 
         * <p>
         * This field is required for all hit types sent to app properties.
         * For hits sent to web properties, this field is optional.
         * </p>
         * 
         * @example
         * <code>an=My%20App</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const APP_NAME:String                = "appName";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Application identifier.
         * </p>
         * 
         * @example
         * <code>aid=com.company.app</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const APP_ID:String                  = "appId";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the application version.
         * </p>
         * 
         * @example
         * <code>av=1.2</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const APP_VERSION:String             = "appVersion";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Application installer identifier.
         * </p>
         * 
         * @example
         * <code>aiid=com.platform.vending</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const APP_INSTALLER_ID:String        = "appInstallerId";
        
        
        // Event Tracking
        
        /**
         * <b>Required for event hit type.</b>
         * <p>
         * Specifies the event category.
         * </p>
         * 
         * <p>
         * Must not be empty.
         * </p>
         * 
         * @example
         * <code>ec=Category</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const EVENT_CATEGORY:String          = "eventCategory";
        
        /**
         * <b>Required for event hit type.</b>
         * <p>
         * Specifies the event action
         * </p>
         * 
         * <p>
         * Must not be empty.
         * </p>
         * 
         * @example
         * <code>ea=Action</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const EVENT_ACTION:String            = "eventAction";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the event label.
         * </p>
         * 
         * @example
         * <code>el=Label</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const EVENT_LABEL:String             = "eventLabel";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the event value.
         * </p>
         * 
         * <p>
         * Values must be non-negative.
         * </p>
         * 
         * @example
         * <code>ev=55</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const EVENT_VALUE:String             = "eventValue";
        
        
        // E-Commerce
        
        /**
         * <b>Required for transaction hit type.</b>
         * <p><b>Required for item hit type.</b></p>
         * <p>
         * A unique identifier for the transaction.
         * </p>
         * 
         * <p>
         * This value should be the same for both the Transaction hit and
         * Items hits associated to the particular transaction.
         * </p>
         * 
         * @example
         * <code>ti=OD564</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const TRANSACTION_ID:String          = "transactionId";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the affiliation or store name.
         * </p>
         * 
         * @example
         * <code>ta=Member</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const TRANSACTION_AFFILIATION:String = "transactionAffiliation";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the total revenue associated with the transaction.
         * </p>
         * 
         * <p>
         * This value should include any shipping or tax costs.
         * </p>
         * 
         * @example
         * <code>tr=15.47</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const TRANSACTION_REVENUE:String     = "transactionRevenue";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the total shipping cost of the transaction.
         * </p>
         * 
         * @example
         * <code>ts=3.50</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const TRANSACTION_SHIPPING:String    = "transactionShipping";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the total tax of the transaction.
         * </p>
         * 
         * @example
         * <code>tt=11.20</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const TRANSACTION_TAX:String         = "transactionTax";
        
        /**
         * <b>Required for item hit type.</b>
         * <p>
         * Specifies the item name.
         * </p>
         * 
         * @example
         * <code>in=Shoe</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const ITEM_NAME:String               = "itemName";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the price for a single item / unit.
         * </p>
         * 
         * @example
         * <code>ip=3.50</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const ITEM_PRICE:String              = "itemPrice";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the number of items purchased.
         * </p>
         * 
         * @example
         * <code>iq=4</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const ITEM_QUANTITY:String           = "itemQuantity";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the SKU or item code.
         * </p>
         * 
         * @example
         * <code>ic=SKU47</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const ITEM_CODE:String               = "itemCode";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the category that the item belongs to.
         * </p>
         * 
         * @example
         * <code>iv=Blue</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const ITEM_CATEGORY:String           = "itemCategory";
        
        /**
         * <b>Optional.</b>
         * <p>
         * When present indicates the local currency for all transaction
         * currency values.
         * </p>
         * 
         * <p>
         * Value should be a valid ISO 4217 currency code.
         * </p>
         * 
         * @example
         * <code>cu=EUR</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CURRENCY_CODE:String           = "currencyCode";
        
        // Enhanced E-Commerce (not completely supported yet)
        
        // Product SKU
        // Product Name
        // Product Brand
        // Product Category
        // Product Variant
        // Product Price
        // Product Quantity
        // Product Coupon Code
        // Product Position
        // Product Custom Dimension
        // Product Custom Metric
        
        /**
         * <b>Optional.</b>
         * <p>
         * The role of the products included in a hit.
         * </p>
         * 
         * <p>
         * If a product action is not specified, all product definitions
         * included with the hit will be ignored.
         * Must be one of: detail, click, add, remove, checkout, checkout_option,
         * purchase, refund.
         * 
         * For analytics.js the Enhanced Ecommerce plugin must be installed
         * before using this field.
         * </p>
         * 
         * @example
         * <code>pa=detail</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const PRODUCT_ACTION:String          = "productAction";
        
        // Transaction ID - duplicate
        // Affiliation - duplicate
        // Revenue - duplicate
        // Tax - duplicate
        // Shipping - duplicate
        
        /**
         * <b>Optional.</b>
         * <p>
         * The transaction coupon redeemed with the transaction.
         * </p>
         * 
         * <p>
         * This is an additional parameter that can be sent when Product Action
         * is set to 'purchase' or 'refund'.
         * 
         * For analytics.js the Enhanced Ecommerce plugin must be installed
         * before using this field.
         * </p>
         * 
         * @example
         * <code>tcc=SUMMER08</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const COUPON_CODE:String             = "couponCode";
        
        /**
         * <b>Optional.</b>
         * <p>
         * The list or collection from which a product action occurred.
         * </p>
         * 
         * <p>
         * This is an additional parameter that can be sent when Product Action
         * is set to 'detail' or 'click'.
         * 
         * For analytics.js the Enhanced Ecommerce plugin must be installed
         * before using this field.
         * </p>
         * 
         * @example
         * <code>pal=Search%20Results</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const PRODUCT_ACTION_LIST:String     = "productActionList";
        
        /**
         * <b>Optional.</b>
         * <p>
         * The step number in a checkout funnel.
         * </p>
         * 
         * <p>
         * This is an additional parameter that can be sent when Product Action
         * is set to 'checkout'.
         * 
         * For analytics.js the Enhanced Ecommerce plugin must be installed
         * before using this field.
         * </p>
         * 
         * @example
         * <code>cos=2</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CHECKOUT_STEP:String           = "checkoutStep";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Additional information about a checkout step.
         * </p>
         * 
         * <p>
         * This is an additional parameter that can be sent when Product Action
         * is set to 'checkout'.
         * 
         * For analytics.js the Enhanced Ecommerce plugin must be installed
         * before using this field.
         * </p>
         * 
         * @example
         * <code>col=Visa</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CHECKOUT_STEP_OPTION:String    = "checkoutStepOption";
        
        // Product Impression List Name
        // Product Impression SKU
        // Product Impression Name
        // Product Impression Brand
        // Product Impression Category
        // Product Impression Variant
        // Product Impression Position
        // Product Impression Price
        // Product Impression Custom Dimension
        // Product Impression Custom Metric
        // Promotion ID
        // Promotion Name
        // Promotion Creative
        // Promotion Position
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the role of the promotions included in a hit.
         * </p>
         * 
         * <p>
         * If a promotion action is not specified, the default promotion action,
         * 'view', is assumed.
         * To measure a user click on a promotion set this to 'promo_click'.
         * 
         * For analytics.js the Enhanced Ecommerce plugin must be installed
         * before using this field.
         * </p>
         * 
         * @example
         * <code>promoa=click</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const PROMOTION_ACTION:String        = "promotionAction";
        
        
        // Social Interactions
        
        /**
         * <b>Required for social hit type.</b>
         * <p>
         * Specifies the social network.
         * </p>
         * 
         * <p>
         * For example Facebook or Google Plus.
         * </p>
         * 
         * @example
         * <code>sn=facebook</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const SOCIAL_NETWORK:String          = "socialNetwork";
        
        /**
         * <b>Required for social hit type.</b>
         * <p>
         * Specifies the social interaction action.
         * </p>
         * 
         * <p>
         * For example on Google Plus when a user clicks the +1 button,
         * the social action is 'plus'.
         * </p>
         * 
         * @example
         * <code>sa=like</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const SOCIAL_ACTION:String           = "socialAction";
        
        /**
         * <b>Required for social hit type.</b>
         * <p>
         * Specifies the target of a social interaction.
         * </p>
         * 
         * <p>
         * This value is typically a URL but can be any text.
         * </p>
         * 
         * @example
         * <code>st=http%3A%2F%2Ffoo.com</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const SOCIAL_TARGET:String           = "socialTarget";
        

        // Timing
        
        /**
         * <b>Required for timing hit type.</b>
         * <p>
         * Specifies the user timing category.
         * </p>
         * 
         * @example
         * <code>utc=category</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const USER_TIMING_CATEGORY:String    = "userTimingCategory";
        
        /**
         * <b>Required for timing hit type.</b>
         * <p>
         * Specifies the user timing variable.
         * </p>
         * 
         * @example
         * <code>utv=lookup</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const USER_TIMING_VAR:String         = "userTimingVar";
        
        /**
         * <b>Required for timing hit type.</b>
         * <p>
         * Specifies the user timing value.
         * </p>
         * 
         * <p>
         * The value is in milliseconds.
         * </p>
         * 
         * @example
         * <code>utt=123</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const USER_TIMING_TIME:String        = "userTimingTime";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the user timing label.
         * </p>
         * 
         * @example
         * <code>utl=label</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const USER_TIMING_LABEL:String       = "userTimingLabel";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the time it took for a page to load.
         * </p>
         * 
         * <p>
         * The value is in milliseconds.
         * </p>
         * 
         * @example
         * <code>plt=3554</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const PAGE_LOAD_TIME:String          = "pageLoadTime";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the time it took to do a DNS lookup.
         * </p>
         * 
         * <p>
         * The value is in milliseconds.
         * </p>
         * 
         * @example
         * <code>dns=43</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const DNS_TIME:String                = "dnsTime";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the time it took for the page to be downloaded.
         * </p>
         * 
         * <p>
         * The value is in milliseconds.
         * </p>
         * 
         * @example
         * <code>pdt=500</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const PAGE_DOWNLOAD_TIME:String      = "pageDownloadTime";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the time it took for any redirects to happen.
         * </p>
         * 
         * <p>
         * The value is in milliseconds.
         * </p>
         * 
         * @example
         * <code>rrt=500</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const REDIRECT_RESPONSE_TIME:String  = "redirectResponseTime";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the time it took for a TCP connection to be made.
         * </p>
         * 
         * <p>
         * The value is in milliseconds.
         * </p>
         * 
         * @example
         * <code>tcp=500</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const TCP_CONNECT_TIME:String        = "tcpConnectTime";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the time it took for the server to respond after the
         * connect time.
         * </p>
         * 
         * <p>
         * The value is in milliseconds.
         * </p>
         * 
         * @example
         * <code>srt=500</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const SERVER_RESPONSE_TIME:String    = "serverResponseTime";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the time it took for <code>Document.readyState</code>
         * to be 'interactive'.
         * </p>
         * 
         * <p>
         * The value is in milliseconds.
         * </p>
         * 
         * @example
         * <code>dit=500</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const DOM_INTERACTIVE_TIME:String    = "domInteractiveTime";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the time it took for the <code>DOMContentLoaded</code> Event
         * to fire.
         * </p>
         * 
         * <p>
         * The value is in milliseconds.
         * </p>
         * 
         * @example
         * <code>clt=500</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const CONTENT_LOAD_TIME:String       = "contentLoadTime";
        
        
        // Exceptions
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies the description of an exception.
         * </p>
         * 
         * @example
         * <code>exd=DatabaseError</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const EXCEPT_DESCRIPTION:String      = "exceptionDescription";
        
        /**
         * <b>Optional.</b>
         * <p>
         * Specifies whether the exception was fatal.
         * </p>
         * 
         * @example
         * <code>exf=0</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const EXCEPT_FATAL:String            = "exceptionFatal";
        
        
        // Custom Dimensions / Metrics
        
        /**
         * <b>Optional.</b>
         * <p>
         * Each custom dimension has an associated index.
         * </p>
         * 
         * <p>
         * There is a maximum of 20 custom dimensions (200 for Premium accounts).
         * The dimension index must be a positive integer between 1 and 200, inclusive.
         * </p>
         * 
         * <p>
         * Dimensions describe data, it answers "What?"
         * (what keyword did they use, what city is the visitor from).
         * </p>
         * 
         * @example
         * <code>cd&lt;dimensionIndex&gt;=Sports</code>
         * 
         * @example Usage
         * <listing>
         * tracker.set( "dimension1", "aaa" ); // cd1=aaa
         * tracker.set( "dimension2", "bbb" ); // cd2=bbb
         * tracker.set( Tracker.CUSTOM_DIMENSION(3), "ccc" ); // cd3=ccc
         * </listing>
         * 
         * @param index the dimension associated index
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static function CUSTOM_DIMENSION( index:uint = 0 ):String
        {
            if( index < 1 ) { index = 1; }
            
            if( index > 200 ) { index = 200; }
            
            return "dimension" + index;
        }
        
        /**
         * <b>Optional.</b>
         * <p>
         * Each custom metric has an associated index.
         * </p>
         * 
         * <p>
         * There is a maximum of 20 custom metrics (200 for Premium accounts).
         * The metric index must be a positive integer between 1 and 200, inclusive.
         * </p>
         * 
         * <p>
         * Metrics measure data, it answers "How long?", "How many?"
         * (how many sessions).
         * </p>
         * 
         * @example
         * <code>cm&lt;metricIndex&gt;=47</code>
         * 
         * @example Usage
         * <listing>
         * tracker.set( "metric1", "ddd" ); // cm1=ddd
         * tracker.set( "metric2", "eee" ); // cm2=eee
         * tracker.set( Tracker.CUSTOM_METRIC(3), "fff" ); // cm3=fff
         * </listing>
         * 
         * @param index the metric associated index
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static function CUSTOM_METRIC( index:uint = 0 ):String
        {
            if( index < 1 ) { index = 1; }
            
            if( index > 200 ) { index = 200; }
            
            return "metric" + index;
        }
        
        /**
         * The data model containing the hit.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected var _model:HitModel;
        
        /**
         * The temporary data model for one time fields.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected var _temporary:HitModel;
        
        /**
         * The sender which send the hit data to Google Analytics servers.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected var _sender:HitSender;
        
        /**
         * The limiter which ensure not too many hits are send at once.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected var _limiter:RateLimiter;
        
        /**
         * The configuration of the tracker.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected var _config:Configuration;
        
        /**
         * Create an empty Tracker.
         * 
         * <p>
         * Do not use or instanciate this class directly, extend it instead.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracker.DefaultTracker
         */
        public function Tracker()
        {
            super();
        }
        
        /** @inheritDoc */
        public function get trackingId():String
        {
            return get( TRACKING_ID );
        }
        
        /** @inheritDoc */
        public function get clientId():String
        {
            return get( CLIENT_ID );
        }
        
        /** @inheritDoc */
        public function get config():Configuration
        {
            return _config;
        }
        
        /**
         * Set the specified model field to the specified value.
         * 
         * @param field the field to set. May not be null.
         * @param value the new field value. May be null.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function set( field:String, value:String ):void
        {
            if( _model )
            {
                _model.set( field, value );
            }
        }
        
        /**
         * Set the specified model field to the specified value
         * for a one time use.
         * 
         * <p>
         * The field will be consumed on next hit and then will be reset.
         * </p>
         * 
         * @param field the field to set. May not be null.
         * @param value the new field value. May be null.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function setOneTime( field:String, value:String ):void
        {
            if( _temporary )
            {
                _temporary.set( field, value );
            }
        }
        
        /**
         * Return the value of the specified field.
         * 
         * @param field the field to get.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function get( field:String ):String
        {
            if( _model )
            {
                return _model.get( field );
            }
            
            return null;
        }
        
        /**
         * Set multiple field values as specified in the Dictionary.
         * 
         * @param values field/value pairs to set in the model.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function add( values:Dictionary ):void
        {
            if( _model )
            {
                for( var entry:String in values )
                {
                    set( entry, values[entry] );
                }
            }
        }
        
        /**
         * Set multiple field values as specified in the Dictionary 
         * for a one time use.
         * 
         * <p>
         * The fields will be consumed on next hit and then will be reset.
         * </p>
         * 
         * @param values field/value pairs to set in the model.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function addOneTime( values:Dictionary ):void
        {
            if( _temporary )
            {
                for( var entry:String in values )
                {
                    setOneTime( entry, values[entry] );
                }
            }
        }
        
        /** @inheritDoc */
        public function send( hitType:String = null, tempValues:Dictionary = null ):Boolean
        {
            return false;
        }
        
        /** @inheritDoc */
        public function pageview( path:String, title:String = "" ):Boolean
        {
            return false;
        }
        
        /** @inheritDoc */
        public function screenview( name:String, appinfo:Dictionary = null ):Boolean
        {
            return false;
        }
        
        /** @inheritDoc */
        public function event( category:String, action:String,
                               label:String = "", value:int = -1 ):Boolean
        {
            return false;
        }
        
        /** @inheritDoc */
        public function transaction( id:String,
                                     affiliation:String = "",
                                     revenue:Number = 0,
                                     shipping:Number = 0,
                                     tax:Number = 0,
                                     currency:String = "" ):Boolean
        {
            return false;
        }
        
        /** @inheritDoc */
        public function item( transactionId:String, name:String,
                              price:Number = 0,
                              quantity:int = 0,
                              code:String = "",
                              category:String = "",
                              currency:String = "" ):Boolean
        {
            return false;
        }
        
        /** @inheritDoc */
        public function social( network:String, action:String, target:String ):Boolean
        {
            return false;
        }
        
        /** @inheritDoc */
        public function exception( description:String = "",
                                   isFatal:Boolean = true ):Boolean
        {
            return false;
        }
        
        /** @inheritDoc */
        public function timing( category:String, name:String, value:int,
                                label:String = "",
                                timinginfo:Dictionary = null ):Boolean
        {
            return false;
        }
    }

}