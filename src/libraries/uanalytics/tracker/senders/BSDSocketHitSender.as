/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker.senders
{
    import C.arpa.inet.*;
    import C.errno.*;
    import C.netdb.*;
    import C.netinet.*;
    import C.sys.socket.*;
    import C.unistd.*;
    
    import flash.utils.ByteArray;
    
    import libraries.uanalytics.tracking.AnalyticsTracker;
    import libraries.uanalytics.tracking.HitModel;
    import libraries.uanalytics.tracking.HitSender;
    import libraries.uanalytics.utils.generateCLIUserAgent;
    
    /**
     * A simple implementation using BSD Sockets that will send hit data
     * on the command-line to Google Analytics servers.
     * 
     * <p>
     * This is the default implementation we use in all the Redtamarin trackers.
     * </p>
     * 
     * <b>
     * It will work everywhere Redtamarin can run: Windows, Mac OS X, and Linux.
     * From inside ABC files, SWF files, static binaries and shell scripts.
     * </b>
     * 
     * <p>
     * Different and More complicated implementations could do more things;
     * for example: queue hits and send them at a later time, validate the hit
     * by checking the HTTP response code, etc.
     * </p>
     * 
     * @playerversion AVM 0.4
     * @langversion 3.0
     */
    public class BSDSocketHitSender extends HitSender
    {
        private static const _CRLF:String = "\r\n"; // CRLF 0x0D 0x0A
        
        /**
         * The default <b>HTTP</b> port (<code>80</code>).
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */ 
        public static const DEFAULT_PORT:int = 80;
        
        /**
         * The default <b>HTTPS</b> port (<code>443</code>).
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */ 
        public static const SECURE_PORT:int = 443;
        
        /**
         * An Analytics tracker.
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected var _tracker:AnalyticsTracker;
        
        private var _enableErrorChecking:Boolean;
        private var _debug:Boolean;
        private var _verbose:Boolean;
        
        private var _connected:Boolean;
        
        private var _addrlist:Array;
        private var _sockfd:int;
        private var _info:addrinfo;
        
        private var _localAddress:String;
        private var _localPort:int;
        
        private var _remoteAddress:String;
        private var _remotePort:int;
        
        private var _remoteAddresses:Array;
        
        /**
         * Creates a BSDSocketHitSender.
         * 
         * @param tracker an analytics tracker
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function BSDSocketHitSender( tracker:AnalyticsTracker )
        {
            super();
            _tracker = tracker;
            
            _enableErrorChecking = false;
            _debug = false;
            _verbose = false;
            _reset();
        }
        
        /**
         * Function hook for the socket "connect" event.
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */ 
        public var onConnect:Function;/* = function():void
        {
            trace( "onConnect()" );
        }*/
        
        /**
         * Function hook for the socket "disconnect" event.
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */ 
        public var onDisconnect:Function;/* = function():void
        {
            trace( "onDisconnect()" );
        }*/
        
        /**
         * Function hook for the socket "send" event.
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */ 
        public var onSend:Function;/* = function():void
        {
            trace( "onSend( bytes:ByteArray, total:int )" );
        }*/
        
        /**
         * Function hook for the socket "receive" event.
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */ 
        public var onReceive:Function;/* = function():void
        {
            trace( "onReceive( bytes:ByteArray, total:int )" );
        }*/
        
        private function _reset():void
        {
            _connected = false;
            
            _addrlist = null;
            _sockfd   = -1;
            _info     = null;
            
            _localAddress  = "";
            _localPort     = -1;
            _remoteAddress = "";
            _remotePort    = -1;
            
            _remoteAddresses = null;
        }
        
        private function _open( hostname:String, port:String ):int
        {
            var hints:addrinfo = new addrinfo();
                hints.ai_socktype = SOCK_STREAM;
                hints.ai_family   = AF_UNSPEC;

            var eaierr:CEAIrror = new CEAIrror();
            var addrlist:Array  = getaddrinfo( hostname, port, hints, eaierr );
            
            if( !addrlist )
            {
                if( enableErrorChecking ) { throw eaierr; }
                
                return -1;
            }

            _addrlist = addrlist;
            
            var i:uint;
            var info:addrinfo;
            var sockfd:int;
            var result:int;
            
            for( i = 0; i < addrlist.length; i++ )
            {
                info = addrlist[i];
                
                sockfd = socket( info.ai_family, info.ai_socktype, info.ai_protocol );
                if( sockfd < 0 )
                {
                    var e:CError = new CError( "", errno );
                    if( enableErrorChecking ) { throw e; }
                    
                    return -1;
                }
                
                result = connect( sockfd, info.ai_addr );
                if( result < 0 )
                {
                    var e:CError = new CError( "", errno );
                    if( enableErrorChecking ) { throw e; }
                    
                    return -1;
                }
                break;
            }
            
            _info = info;
            
            var a:String = inet_ntop( _info.ai_family, _info.ai_addr );
            if( !a )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            else
            {
                _remoteAddress = a;
            }
            
            if( _info.ai_family == AF_INET )
            {
                // IPv4
                _remotePort = ntohs( _info.ai_addr.sin_port );
            }
            else
            {
                // IPv6
                _remotePort = ntohs( _info.ai_addr.sin6_port );
            }
            
            
            return sockfd;
        }
        
        private function _findLocalAddressAndPort():void
        {
            if( _info.ai_family == AF_INET )
            {
                _findLocalAddressAndPort4();
            }
            else
            {
                _findLocalAddressAndPort6();
            }
        }
        
        private function _findLocalAddressAndPort4():void
        {
            var addr:sockaddr_in = new sockaddr_in();
            
            var result:int = getsockname( _sockfd, addr );
            if( result == -1 )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            else
            {
                var a:String = inet_ntop( addr.sin_family, addr );
                if( !a )
                {
                    var e:CError = new CError( "", errno );
                    if( enableErrorChecking ) { throw e; }
                }
                else
                {
                    _localAddress = a;    
                }
                
                _localPort = ntohs( addr.sin_port );
            }
        }
        
        private function _findLocalAddressAndPort6():void
        {
            var addr:sockaddr_in6 = new sockaddr_in6();
            
            var result:int = getsockname( _sockfd, addr );
            if( result == -1 )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            else
            {
                var a:String = inet_ntop( addr.sin6_family, addr );
                if( !a )
                {
                    var e:CError = new CError( "", errno );
                    if( enableErrorChecking ) { throw e; }
                }
                else
                {
                    _localAddress = a;    
                }
                
                _localPort = ntohs( addr.sin6_port );
            }
        }
        
        private function _receiveAll( socket:int, bytes:ByteArray, len:int = 8192, flags:int = 0 ):int
        {
            var total:uint = 0; // how many bytes we received
            var n:int;
            var b:ByteArray = new ByteArray();
            
            var run:Boolean = true;            
            while( run )
            {
                b.clear();
                n = recv( socket, b, len, flags );
                
                if( n == -1 ) { run = false; break; }
                bytes.writeBytes( b );
                total += n;
                if( n == 0 ) { run = false; break; }
            }
            
            b.clear();
        
            if( n < 0 )
            {
                return -1; //failure
            }
        
            return total; // number of bytes actually received
        }
        
        /**
         * Specifies whether errors encountered by the sockets are reported
         * to the application.
         * 
         * <p>
         * When enableErrorChecking is <code>true</code> methods are synchronous
         * and can throw errors. When enableErrorChecking is <code>false</code>,
         * the default, the methods are asynchronous and errors are not reported.
         * </p>
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */ 
        public function get enableErrorChecking():Boolean { return _enableErrorChecking; }
        /** @private */
        public function set enableErrorChecking( value:Boolean ):void { _enableErrorChecking = value; }
        
        /**
         * Specifies whether we use the endpoint <code>/debug/collect</code>
         * instead of <code>/collect</code>.
         * 
         * <p>
         * The "debug mode", if set to <code>true</code>, allows to send the
         * hit requests to the Measurement Protocol Validation Server.
         * </p>
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function get debug():Boolean { return _debug; }
        /** @private */
        public function set debug( value:Boolean ):void { _debug = value; }
        
        /**
         * Specifies whether the output will be verbose or not.
         * 
         * <p>
         * The "verbose mode", if set to <code>true</code>, will print the details
         * of the hit request to the standard output.
         * </p>
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function get verbose():Boolean { return _verbose; }
        /** @private */
        public function set verbose( value:Boolean ):void { _verbose = value; }
        
        /**
         * Open a connection to a <code>host</code> on a specific <code>port</code>.
         * 
         * <p>
         * Will call the <code>onConnect()</code> function if defined.
         * </p>
         * 
         * @param host The remote host to connect to.
         * @param port The port to connect to (optional, default to <code>80</code>).
         * 
         * Errors
         * "CEAIrror: EAI_NONAME #8: nodename nor servname provided, or not known"
         * the host provided was not found
         * 
         * "CError: ETIMEDOUT #60: Operation timed out"
         * most likely the port provided is not opne on this particular host
         * (for ex: try to connect on www.comain.com on port 8080 when only port 80 is open)
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected function open( host:String, port:int = -1 ):void
        {
            //trace( "HttpConnection.open()" );
            
            if( port == -1 )
            {
                port = DEFAULT_PORT;
            }
            
            var sockfd:int = _open( host, String( port ) );
            
            if( sockfd == -1 )
            {
                //trace( "Could not connect" );
                if( enableErrorChecking )
                {
                    throw new Error( "Could not connect to " + host + ":" + port );
                }
            }
            else
            {
                _sockfd = sockfd;
                _connected = true;
                _findLocalAddressAndPort();
                
                if( onConnect ) { this.onConnect(); }
            }
        }
        
        /**
         * Close the connection.
         * 
         * <p>
         * Will call the <code>onDisconnect()</code> function if defined.
         * </p>
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected function close():void
        {
            //trace( "HttpConnection.close()" );
            
            if( !_connected )
            {
                /* NOTE
                   never connected
                   or already disconnected
                */
                return;
            }
            
            var result:int = C.unistd.close( _sockfd );
            if( result == -1 )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            
            if( onDisconnect ) { this.onDisconnect(); }
            _reset();
        }
        
        /**
         * Send bytes on the socket connection.
         * 
         * @param bytes the bytes to send.
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected function sendBytes( bytes:ByteArray ):void
        {
            var sent:int = sendall( _sockfd, bytes );
            //trace( "sent " + sent + " bytes" );
            if( sent < 0 )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            
            if( onSend ) { this.onSend( bytes, sent ); }
        }
        
        /**
         * Receive bytes on the socket connection.
         * 
         * <p>
         * Will call the <code>onReceive()</code> function if defined.
         * </p>
         * 
         * @return the bytes received.
         * 
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected function receive():ByteArray
        {
            var bytes:ByteArray = new ByteArray();
            var received:int = _receiveAll( _sockfd, bytes );
            if( received < 0 )
            {
                var e:CError = new CError( "", errno );
                if( enableErrorChecking ) { throw e; }
            }
            
            if( onReceive ) { this.onReceive( bytes, received ); }
            return bytes;
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
            
            if( _tracker.config.forceSSL || debug )
            {
                throw new Error( "HTTPS connection is not supported yet." );
            }
            
            var ua:String = generateCLIUserAgent();
            var host:String = "";
            var port:int = -1;
            var path:String = "";
            var secure:Boolean = false;
            
            if( _tracker.config.forceSSL )
            {
                // https://ssl.google-analytics.com/collect
                secure = true;
                url  = _tracker.config.secureEndpoint;
                host = "ssl.google-analytics.com";
                port = SECURE_PORT;
                path = "/collect";
            }
            else
            {
                // http://www.google-analytics.com/collect
                secure = false;
                url  = _tracker.config.endpoint;
                host = "www.google-analytics.com";
                port = DEFAULT_PORT;
                path = "/collect";
            }
            
            if( debug )
            {
                secure = true;
                host = "www.google-analytics.com";
                path = "/debug/collect";
            }
            
            // we build the request
            var request:String = "";
            
            if( sendViaPOST )
            {
                request += "POST " + path + " HTTP/1.1" + _CRLF;
                
                if( secure )
                {
                request += "Host: " + host + ":" + port + _CRLF;
                }
                else
                {
                request += "Host: " + host + _CRLF;
                }
                
                request += "User-Agent: " + ua + _CRLF;
                request += "Content-Type: " + "application/x-www-form-urlencoded" + _CRLF;
                request += "Content-Length: " + (payload.length) + _CRLF;
                request += "Connection: close" + _CRLF;
                request += _CRLF;
                request += payload + _CRLF;
            }
            else
            {
                request += "GET " + path + "?" + payload  + " HTTP/1.1" + _CRLF;
                
                if( secure )
                {
                request += "Host: " + host + ":" + port + _CRLF;
                }
                else
                {
                request += "Host: " + host + _CRLF;
                }
                
                request += "User-Agent: " + ua + _CRLF;
                request += "Connection: close" + _CRLF;
                request += _CRLF;
            }
            
            if( verbose )
            {
                trace( "request:" );
                trace( "--------" );
                trace( request );
                trace( "--------" );
                trace( "" );
            }
            
            var bytes:ByteArray = new ByteArray();
                bytes.writeUTFBytes( request );
                bytes.position = 0;
            
            var err:Error = null;
            
            try
            {
                open( host, port );
                sendBytes( bytes );
            }
            catch( e:Error )
            {
                err = e;
            }

            if( err )
            {
                throw err;
            }
            
            var received:ByteArray = receive();
                received.position = 0;
            //trace( "received: " + received.length + " bytes" );
            close();
            
            if( verbose )
            {
                var response:String = received.readUTFBytes( received.length );
                trace( "response:" );
                trace( "--------" );
                trace( response );
                trace( "--------" );
                trace( "" );
            }
        }
        
    }
}