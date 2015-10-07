/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracking
{
    import flash.utils.Dictionary;

    /**
     * Defines the set of fields and field generators that comprise a data model.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see Tracker
     */
    public class Metadata
    {
        /**
         * The special prefix character used to identify a field name as representing
         * a tracking API query parameter name.
         * 
         * <p>
         * For example, the field named "&#38;sr" specify the screen resolution
         * which is sent as the URL query parameter name "sr" in the tracking API.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const FIELD_PREFIX:String = "&";
        
        /**
         * A map from field name to parameter.
         * 
         * <p>
         * Eg. "screenResolution" to "&#38;sr".
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        private var _nameToParameterMap:Dictionary = new Dictionary();
        
        /**
         * A map from a regular expression to a query parameter name.
         * 
         * <p>
         * Eg. "metric([0-9])+" to "&#38;cm".
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        private var _patternToParameterMap:Dictionary = new Dictionary();
        
        /**
         * Creates the default Metadata.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function Metadata()
        {
            super();
               
            // General
            addAlias( Tracker.PROTOCOL_VERSION, "v"  );
            addAlias( Tracker.TRACKING_ID,      "tid" );
            addAlias( Tracker.ANON_IP,          "aip" );
            addAlias( Tracker.DATA_SOURCE,      "ds"  );
            addAlias( Tracker.QUEUE_TIME,       "qt"  );
            addAlias( Tracker.CACHE_BUSTER,     "z"   );
            
            // User
            addAlias( Tracker.CLIENT_ID, "cid" );
            addAlias( Tracker.USER_ID,   "uid" );
            
            // Session
            addAlias( Tracker.SESSION_CONTROL,       "sc"    );
            addAlias( Tracker.IP_OVERRIDE,           "uip"   );
            addAlias( Tracker.USER_AGENT_OVERRIDE,   "ua"    );
            addAlias( Tracker.GEOGRAPHICAL_OVERRIDE, "geoid" );
            
            // Traffic Sources
            addAlias( Tracker.DOCUMENT_REFERRER,     "dr"    );            
            addAlias( Tracker.CAMPAIGN_NAME,         "cn"    );
            addAlias( Tracker.CAMPAIGN_SOURCE,       "cs"    );
            addAlias( Tracker.CAMPAIGN_MEDIUM,       "cm"    );
            addAlias( Tracker.CAMPAIGN_KEYWORD,      "ck"    );
            addAlias( Tracker.CAMPAIGN_CONTENT,      "cc"    );
            addAlias( Tracker.CAMPAIGN_ID,           "ci"    );
            addAlias( Tracker.GOOGLE_ADWORDS_ID,     "gclid" );
            addAlias( Tracker.GOOGLE_DISPLAY_ADS_ID, "dclid" );
            
            // System Info
            addAlias( Tracker.SCREEN_RESOLUTION, "sr" );
            addAlias( Tracker.VIEWPORT_SIZE,     "vp" );
            addAlias( Tracker.DOCUMENT_ENCODING, "de" );
            addAlias( Tracker.SCREEN_COLORS,     "sd" );
            addAlias( Tracker.USER_LANGUAGE,     "ul" );
            addAlias( Tracker.JAVA_ENABLED,      "je" );
            addAlias( Tracker.FLASH_VERSION,     "fl" );
            
            // Hit
            addAlias( Tracker.HIT_TYPE,        "t"  );
            addAlias( Tracker.NON_INTERACTION, "ni" );
            
            // Content Information
            addAlias( Tracker.DOCUMENT_LOCATION, "dl"     );
            addAlias( Tracker.DOCUMENT_HOSTNAME, "dh"     );
            addAlias( Tracker.DOCUMENT_PATH,     "dp"     );
            addAlias( Tracker.DOCUMENT_TITLE,    "dt"     );
            addAlias( Tracker.SCREEN_NAME,       "cd"     );
            addAlias( Tracker.LINK_ID,           "linkid" );
            
            // App Tracking
            addAlias( Tracker.APP_NAME,         "an"   );
            addAlias( Tracker.APP_ID,           "aid"  );
            addAlias( Tracker.APP_VERSION,      "av"   );
            addAlias( Tracker.APP_INSTALLER_ID, "aiid" );
            
            // Event Tracking
            addAlias( Tracker.EVENT_CATEGORY, "ec" );
            addAlias( Tracker.EVENT_ACTION,   "ea" );
            addAlias( Tracker.EVENT_LABEL,    "el" );
            addAlias( Tracker.EVENT_VALUE,    "ev" );
            
            // E-Commerce
            addAlias( Tracker.TRANSACTION_ID,          "ti" );
            addAlias( Tracker.TRANSACTION_AFFILIATION, "ta" );
            addAlias( Tracker.TRANSACTION_REVENUE,     "tr" );
            addAlias( Tracker.TRANSACTION_SHIPPING,    "ts" );
            addAlias( Tracker.TRANSACTION_TAX,         "tt" );
            addAlias( Tracker.ITEM_NAME,               "in" );
            addAlias( Tracker.ITEM_PRICE,              "ip" );
            addAlias( Tracker.ITEM_QUANTITY,           "iq" );
            addAlias( Tracker.ITEM_CODE,               "ic" );
            addAlias( Tracker.ITEM_CATEGORY,           "iv" );
            addAlias( Tracker.CURRENCY_CODE,           "cu" );
            
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
            addAlias( Tracker.PRODUCT_ACTION,       "pa" );
            // Transaction ID - duplicate
            // Affiliation - duplicate
            // Revenue - duplicate
            // Tax - duplicate
            // Shipping - duplicate
            addAlias( Tracker.COUPON_CODE,          "tcc" );
            addAlias( Tracker.PRODUCT_ACTION_LIST,  "pal" );
            addAlias( Tracker.CHECKOUT_STEP,        "cos" );
            addAlias( Tracker.CHECKOUT_STEP_OPTION, "col" );
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
            addAlias( Tracker.PROMOTION_ACTION,     "promoa" );
            
            // Social Interactions
            addAlias( Tracker.SOCIAL_NETWORK, "sn" );
            addAlias( Tracker.SOCIAL_ACTION,  "sa" );
            addAlias( Tracker.SOCIAL_TARGET,  "st" );
            
            // Timing
            addAlias( Tracker.USER_TIMING_CATEGORY,   "utc" );
            addAlias( Tracker.USER_TIMING_VAR,        "utv" );
            addAlias( Tracker.USER_TIMING_TIME,       "utt" );
            addAlias( Tracker.USER_TIMING_LABEL,      "utl" );
            addAlias( Tracker.PAGE_LOAD_TIME,         "plt" );
            addAlias( Tracker.DNS_TIME,               "dns" );
            addAlias( Tracker.PAGE_DOWNLOAD_TIME ,    "pdt" );
            addAlias( Tracker.REDIRECT_RESPONSE_TIME, "rrt" );
            addAlias( Tracker.TCP_CONNECT_TIME,       "tcp" );
            addAlias( Tracker.SERVER_RESPONSE_TIME,   "srt" );
            addAlias( Tracker.DOM_INTERACTIVE_TIME,   "dit" );
            addAlias( Tracker.CONTENT_LOAD_TIME,      "clt" );
            
            // Exceptions
            addAlias( Tracker.EXCEPT_DESCRIPTION, "exd" );
            addAlias( Tracker.EXCEPT_FATAL,       "exf" );
            
            // Custom Dimensions / Metrics
            addPatternAlias( "dimension([0-9]+)",    "cd" );
            addPatternAlias( "metric([0-9]+)",       "cm" );
            //addPatternAlias( "contentGroup([0-9]+)", "cg" ); // not supported anymore?            
                        
        }
        
        /**
         * Given a field name, return the key to use in the data model map based
         * on whether the field name matches a registered regular expression.
         * 
         * @param field the field name to find in pattern
         * 
         * @return the key to use in the data model map based on whether the
         *         field name matches a registered regular expression.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        private function _getKeyFromPattern( field:String ):String
        {
            for( var pattern:String in _patternToParameterMap )
            {
                var re:RegExp = new RegExp( pattern );
                var result:Object = re.exec( field );
                
                if( result && result[1] )
                {
                    var param:String = FIELD_PREFIX + _patternToParameterMap[pattern]  + result[1];
                    addAlias( field, param );
                    return param;
                }
            }
            
            return field;
        }
        
        /**
         * Add an alias in the data from field name to query parameter.
         * 
         * @param field     the field name
         * @param parameter the associated parameter
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected function addAlias( field:String, parameter:String ):void
        {
            _nameToParameterMap[ field ] = FIELD_PREFIX + parameter;
        }
        
        /**
         * Add an alias in the data from field name regular expression
         * to query parameter.
         * 
         * <p>
         * The pattern should have one group defined which will capture the
         * portion of the field name to use as the suffix for the parameter.
         * </p>
         * 
         * <p>
         * For example, the field name "metric34" would match the pattern:
         * "metric([0-9])+" with parameter prefix "cm" and would map the field
         * to the parameter "cm34"
         * </p>
         * 
         * @param pattern         the pattern to match
         * @param parameterPrefix the parameter prefix
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected function addPatternAlias( pattern:String, parameterPrefix:String ):void
        {
            _patternToParameterMap[ pattern ] = parameterPrefix;
        }
        
        /**
         * Given a field name, return the key to use in the data model map
         * for which to store the field value.
         * 
         * @param field the field name
         * 
         * @return the key to use in the data model map
         *         for which to store the field value.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function getHitModelKey( field:String ):String
        {
            if( (field.length > 0) && (field.charAt(0) == FIELD_PREFIX) )
            {
                return field;
            }
            
            var key:String = _nameToParameterMap[ field ];
            
            if( key == null )
            {
                key = _getKeyFromPattern( field );
            }
            
            return key;
        }
        
    }
    
}