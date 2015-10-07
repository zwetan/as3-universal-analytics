/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker
{
    
    /**
     * The SessionControl class defines allowed values for the
     * "session control" parameter.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * see: libraries.uanalytics.tracking.Tracker#SESSION_CONTROL Tracker.SESSION_CONTROL
     * @see libraries.uanalytics.tracking.Metadata Metadata
     * @see http://developers.google.com/analytics/devguides/collection/protocol/v1/parameters#sc Session Control
     */
    public class SessionControl
    {
        
        /**
         * Forces a new session to start with the hit request.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const START:String = "start";
        
        /**
         * Forces the current session to end with the hit request.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const END:String   = "end";
        
        /**
         * Creates a SessionControl.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function SessionControl()
        {
            super();
        }
    }
}