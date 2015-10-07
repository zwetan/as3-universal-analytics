/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracking
{
    
    /**
     * The contract to send a hit request to Google Analytics servers.
     * 
     * <p>
     * The strict minimum of what a sender need to implement
     * is to send a data model to a URL.
     * </p>
     * 
     * <p>
     * For a Flash / AIR implementation see <code>URLLoaderHitSender</code>,
     * for a Redtamarin implementation see <code>BSDSocketHitSender</code>.
     * </p>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see HitSender
     * @see libraries.uanalytics.tracker.senders.URLLoaderHitSender URLLoaderHitSender
     * @see libraries.uanalytics.tracker.senders.BSDSocketHitSender BSDSocketHitSender
     */
    public interface AnalyticsSender
    {
        
        /**
         * Sends the hit in the specified data model.
         * 
         * @param model the hit to send.
         * 
         * @throws Error if there is a problem sending the data.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        function send( model:HitModel ):void;
        
    }
    
}