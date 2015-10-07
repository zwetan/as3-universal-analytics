/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker.senders
{
    import libraries.uanalytics.tracking.AnalyticsTracker;
    import libraries.uanalytics.tracking.Configuration;
    import libraries.uanalytics.tracking.HitModel;
    import libraries.uanalytics.tracking.HitSender;
    
    /**
     * A <code>HitSender</code> that will trace the hit requests to the console
     * output.
     * 
     * <p>
     * It will work only in a debug Flash Player, debug AIR application,
     * and with the debug redshell (or as3shebang).
     * It will not send any data to the Google Analytics servers.
     * </p>
     * 
     * @example Usage
     * <listing>
     * var config:Configuration = new Configuration();
     *     // replace the sender type
     *     config.senderType = "libraries.uanalytics.tracker.senders.TraceHitSender";
     * 
     * var tracker:WebTracker = new WebTracker( "UA-12345-67", config );
     *     tracker.pageview( "/hello/world", "Hello World" );
     * 
     * //output:
     * /&#42;
     * request:
     * --------
     * GET /collect?v=1&#38;_v=as3uanalytics1&#38;cid=1898e890-5aad-49a8-b7f2-83751bab4c9c&#38;dh=localhost&#38;dp=%2Fhello%2Fworld&#38;ds=web&#38;dt=Hello%20World&#38;t=pageview&#38;tid=UA-12345-67 HTTP/1.1
     * Host: http://www.google-analytics.com
     * User-Agent: user_agent_string
     * 
     * 
     *   v = 1
     *   _v = as3uanalytics1
     *   cid = 1898e890-5aad-49a8-b7f2-83751bab4c9c
     *   dh = localhost
     *   dp = /hello/world
     *   ds = web
     *   dt = Hello World
     *   t = pageview
     *   tid = UA-12345-67
     * 
     * --------
     * &#42;/
     * </listing>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     */
    public class TraceHitSender extends HitSender
    {
        private var _tracker:AnalyticsTracker;
        
        /**
         * Creates a TraceHitSender.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function TraceHitSender( tracker:AnalyticsTracker )
        {
            super();
            _tracker = tracker;
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
            
            var str:String = "";
            
            if( sendViaPOST )
            {
                /* POST:
                   ----
                    User-Agent: user_agent_string
                    POST http://www.google-analytics.com/collect
                    payload_data
                   ----
                */
                str += "User-Agent: user_agent_string\n";
                str += "POST " + url + "\n";
                str += payload;
                str += "\n\n";
            }
            else
            {
                // that's quick poorman parsing but it works ;)
                // http://www.google-analytics.com/collect
                // https://ssl.google-analytics.com/collect
                var domain:String = url.split( "/collect" )[0];
                var path:String   = "/collect";
            
                /* GET:
                   ----
                    GET /collect?payload_data HTTP/1.1
                    Host: http://www.google-analytics.com
                    User-Agent: user_agent_string
                   ----
                */
                str += "GET " + path + "?" + payload  + " HTTP/1.1\n";
                str += "Host: " + domain + "\n";
                str += "User-Agent: user_agent_string\n";
                str += "\n\n";
            }
            
            var data:Array = payload.split( "&" );
            var i:uint;
            var pair:Array;
            for( i = 0; i < data.length; i ++ )
            {
                pair = data[i].split( "=" );
                str += "  " + pair[0] + " = " + decodeURIComponent( pair[1] ) + "\n";
            }
            
            trace( "request:" );
            trace( "--------" );
            trace( str );
            trace( "--------" );
            throw new Error( "hit not sent" );
        }
    }
}