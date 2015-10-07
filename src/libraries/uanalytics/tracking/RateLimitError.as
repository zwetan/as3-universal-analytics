/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracking
{
    /**
     * An error that will be thrown when hits are being sent at too great a rate.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     */
    public class RateLimitError extends Error
    {
        prototype.name = "RateLimitError";
        
        /**
         * Creates a RateLimitError.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function RateLimitError( message:String = "", id:int = 0 )
        {
            super( message, id );
            this.name = prototype.name;
        }
    }
}