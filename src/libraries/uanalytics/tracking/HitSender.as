/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracking
{
    
    /**
     * HitSender is a base class that will send hit data to Google Analytics servers.
     * 
     * <p>
     * To be considered as an abstract class to extend from.
     * </p>
     * 
     * @example Usage
     * 
     * <listing>
     * // extend from HitSender
     * public class TraceHitSender extends HitSender
     * {
     * 
     *     private var _tracker:AnalyticsTracker;
     *     
     *     // pass a tracker as constructor arguments
     *     public function TraceHitSender( tracker:AnalyticsTracker )
     *     {
     *         super();
     *         _tracker = tracker;
     *         
     *          // instanciate a URL sending mecanism
     *          /&#42; Note:
     *              eg. being able to POST or GET data to a URL
     *              
     *              but it could be anything really, for example
     *              you could save the HitModel data to a file
     *              ----
     *              2015-10-01 11:10 GET /collect?v=1&#38;tid=UA-123-45&#38;cid=12345
     *              2015-10-01 11:15 POST /collect v=1&#38;tid=UA-123-45&#38;cid=12345
     *              ...
     *              ----
     *              and have a kind of cron task later reading trough the file
     *              and actually sending / logging / tracing / etc. the data
     *              etc.
     *          &#42;/
     *     }
     * 
     * }
     * </listing>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see libraries.uanalytics.tracker.senders.BSDSocketHitSender
     * @see libraries.uanalytics.tracker.senders.CurlHitSender
     * @see libraries.uanalytics.tracker.senders.DebugHitSender
     * @see libraries.uanalytics.tracker.senders.LoaderHitSender
     * @see libraries.uanalytics.tracker.senders.TraceHitSender
     * @see libraries.uanalytics.tracker.senders.URLLoaderHitSender
     * @see libraries.uanalytics.tracker.senders.URLStreamSender
     */
    public class HitSender implements AnalyticsSender
    {
        
        /**
         * Create an empty HitSender.
         * 
         * <p>
         * Do not use or instanciate this class directly, extend it instead.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function HitSender()
        {
            super();
        }
        
        /**
         * Adds the named query parameter and value to the specified String.
         * This take care of URL encoding special characters.
         *
         * @param name the HitModel key name.
         * @param value the field value.
         * 
         * @return a string formated such as <code>&#38;NAME=VALUE</code>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected function _addParameter( name:String, value:String ):String
        {
            var str:String = "";
                str += "&";
                str += _appendEncoded( name.substring(1) );
                str += "=";
                str += _appendEncoded( value );
            
            return str;
        }
        
        /**
         * URL encodes the specified value.
         *
         * @param value the value to encode.
         * 
         * @return the value URL encoded.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected function _appendEncoded( value:String ):String
        {
            return encodeURIComponent( value );
        }
        
        /**
         * Build the hit payload from the hit model. The payload can be sent
         * via either setting this as the body of an HTTP POST request or
         * as the query parameter string of the request.
         * 
         * @param model the HitModel to send.
         * 
         * @return the payload representation that is used to send the hit.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected function _buildHit( model:HitModel ):String
        {
            var str:String = "";
                
                // This library supports version 1 of the tracking API.
                str += "v=1";
                
            if( Configuration.SDKversion != "" )
            {
                // Identify the client library version.
                str += _addParameter( "&_v", Configuration.SDKversion );
            }
            
            var names:Vector.<String> = model.getFieldNames();
                names.sort( Array.CASEINSENSITIVE );
                
            var name:String;
            var value:String;
            var i:uint;
            for( i=0; i<names.length; i++ )
            {
                name = names[i];
                if( (name.length > 0) &&
                    (name.charAt(0) == Metadata.FIELD_PREFIX) )
                {
                    value = model.get( name );
                    if( value != null )
                    {
                        str += _addParameter( name, value );
                    }
                }
            }
            
            return str;
        }
        
        /** @inheritDoc */
        public function send( model:HitModel ):void
        {
            //nothing
        }
        
    }
    
}