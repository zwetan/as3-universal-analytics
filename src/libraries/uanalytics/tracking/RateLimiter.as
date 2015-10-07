/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracking
{
    import flash.utils.getTimer;

    /**
     * Implements a rate limiting mecanism that ensures the tracker
     * does not send too many hits at once.
     * 
     * <p>
     * The mecanism is based on the <b>token bucket algorithm</b>,
     * and allows you to send bursts of hits to Google Analytics,
     * while preventing clients from sending data too quickly.
     * </p>
     * 
     * <p>
     * Each tracker has a maximum limit for the number of requests it can send concurrently.
     * The tracker also maintain a count of the number of concurrent hits that have been sent.
     * As a hit is sent to Google Analytics, the count decreases by one.
     * When the count is <code>0</code>, the maximum limit has been reached,
     * and no new requests are sent.
     * Then over a small period of time, the count is increased back to its original limit,
     * allowing data to be sent again.
     * </p>
     * 
     * <p>
     * The limiting rate is specified in each individual trackers.
     * For the <code>WebTracker</code>, we follow what is done with <b>analytics.js</b>,
     * the tracker starts with <code>20</code> hits that are replenished at a rate of <code>2</code> hits per second.
     * For the <code>ApplicationTracker</code>, we follow what is done with the <b>Android SDK</b> and the <b>iOS SDK</b>,
     * each trackers starts with <code>60</code> hits that are replenished at a rate of <code>1</code> hit every 2 seconds.
     * </p>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see http://en.wikipedia.org/wiki/Token_bucket Token bucket
     */
    public class RateLimiter
    {
        private var _capacity:int;
        private var _rate:int;
        private var _span:Number;
        private var _lastTime:int;
        private var _tokenCount:int;
        
        /**
         * Create a new <code>RateLimiter</code> with the specified maximum token <code>capacity</code>
         * and a specified number of new tokens generated per second (<code>rate</code>).
         * 
         * <p>
         * The token count is initialized to the maximum token capacity.
         * </p>
         * 
         * @param capacity maximum number of accumulated tokens.
         * @param rate the number of additional tokens to regenerate per second.
         * @param span the time span to generate tokens (default to 1 second)
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function RateLimiter( capacity:int, rate:int, span:Number = 1 )
        {
            _capacity = capacity;
            _rate = rate;
            _span = span;
            _tokenCount = capacity;
            _lastTime   = now();
        }
        
        /**
         * Returns the number of milliseconds that have elapsed since the
         * Flash runtime virtual machine for ActionScript 3.0 (AVM2) started.
         * 
         * <p>
         * Used internally for generating tokens and useful for testing purposes.
         * </p>
         * 
         * @return a relative time in milliseconds.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        protected function now():int
        {
            return getTimer();
        }
        
        /**
         * Attempt to consume a token and return <code>true</code> if successful.
         * 
         * <p>
         * A return value of false indicates that tokens are being consumed in excess
         * of the defined limits.
         * </p>
         * 
         * @return true if the rate limit has not been exceeded.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function consumeToken():Boolean
        {
            var now:int = now();
            var newTokens:int = Math.max( 0, (now - _lastTime) * ( (_rate * _span) / 1000) );
            _tokenCount = Math.min( _tokenCount + newTokens, _capacity );
            
            if( _tokenCount > 0 )
            {
                _tokenCount--;
                _lastTime = now;
                return true;
            }
            
            return false;
        }
        
    }
    
}