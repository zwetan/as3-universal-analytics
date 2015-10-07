/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker.senders
{
    import libraries.uanalytics.tracking.AnalyticsTracker;
    import libraries.uanalytics.tracking.Configuration;
    import libraries.uanalytics.tracking.HitModel;
    import libraries.uanalytics.tracking.HitSender;
    
    import shell.Program;
    import C.unistd.which;
    
    /**
     * A <code>HitSender</code> based on the cURL command-line tool.
     * 
     * <p>
     * As Redtamarin doesn't have SSL support for sockets on the command-line
     * cURL allow to fill this void.<br>
     * Mainly to be able to test with the Measurement Protocol Validation Server
     * which works only with HTTPS, and/or if you absolutely have to use HTTPS.
     * </p>
     * 
     * @playerversion AVM 0.4
     * @playerversion POSIX +
     * @langversion 3.0
     * 
     * @see http://curl.haxx.se/ cURL
     */
    public class CurlHitSender extends HitSender
    {
        
        protected var _tracker:AnalyticsTracker;
        
        private var _debug:Boolean;
        private var _verbose:Boolean;
        
        public function CurlHitSender( tracker:AnalyticsTracker )
        {
            super();
            _tracker = tracker;
            
            _debug = false;
            _verbose = false;
        }
        
        public function get debug():Boolean { return _debug; }
        public function set debug( value:Boolean ):void { _debug = value; }
        
        public function get verbose():Boolean { return _verbose; }
        public function set verbose( value:Boolean ):void { _verbose = value; }
        
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
            
            /* Note:
               we detect is curl is found in the system paths
               for ex:
               Mac OS X found it in "/opt/local/bin/curl"
               Linux Ubuntu found it in "/usr/bin/curl"
            */
            if( which( "curl" ) == "" )
            {
                throw new Error( "curl was not found." );
            }
            
            
            var host:String = "";
            var path:String = "";
            var secure:Boolean = false;
            
            if( _tracker.config.forceSSL )
            {
                // https://ssl.google-analytics.com/collect
                secure = true;
                url  = _tracker.config.secureEndpoint;
                host = "ssl.google-analytics.com";
                path = "/collect";
            }
            else
            {
                // http://www.google-analytics.com/collect
                secure = false;
                url  = _tracker.config.endpoint;
                host = "www.google-analytics.com";
                path = "/collect";
            }
            
            if( debug )
            {
                secure = true;
                host = "www.google-analytics.com";
                path = "/debug/collect";
            }
            
            var curl:String = "curl ";
            var curlopt:Array = [];
                curlopt.push( "-s" );
                
            
            if( sendViaPOST )
            {
                curlopt.push( "-X POST" );
                curlopt.push( "-d \'" + payload + "\'" );
                url = (secure ? "https://": "http://") + host + path;
            }
            else
            {
                curlopt.push( "-X GET" );
                url = (secure ? "https://": "http://") + host + path + "?" + payload;
            }
            
            curl += curlopt.join( " " );
            curl += " \'" + url + "\'";
            
            if( verbose )
            {
                trace( "command-line:" );
                trace( "--------" );
                trace( curl );
                trace( "--------" );
                trace( "" );
            }
            
            var response:String = "";
            var err:Error = null;
            
            try
            {
                response = Program.open( curl );
            }
            catch( e:Error )
            {
                err = e;
            }

            if( err )
            {
                throw err;
            }
            
            if( verbose )
            {
                trace( "response:" );
                trace( "--------" );
                trace( response );
                trace( "--------" );
                trace( "" );
            }
        }
        
    }
}