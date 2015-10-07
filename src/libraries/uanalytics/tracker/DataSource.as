/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker
{

    /**
     * The DataSource class defines values for the "data source" parameter.
     * 
     * <p>
     * Those values are examples of what we think is "common use case",
     * you can use any value you want.
     * </p>
     * 
     * <p>
     * In general, we think you would want to differentiate between
     * the <b>web</b>: a SWF hosted in an online HTML page,
     * an <b>app</b>: an AIR application,
     * and <b>commandline</b>: a Redtamarin command-line program.
     * </p>
     * 
     * <p>
     * You may want also to differentiate between
     * a <b>desktop</b> app: AIR published for the desktop
     * and a <b>mobile</b> app: AIR published for mobile. 
     * </p>
     * 
     * <p>
     * That said, you could use any values, here few more examples:
     * "cms" (content management system), "server" (when you do tracking server-side),
     * "shellscript" (when using a shell script vs a static binary), etc.
     * </p>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see libraries.uanalytics.tracking.Tracker#DATA_SOURCE Tracker.DATA_SOURCE
     * @see libraries.uanalytics.tracking.Metadata Metadata
     */
    public class DataSource
    {
        
        /**
         * When hit is sent from an online SWF.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const WEB:String = "web";
        
        /**
         * When hit is sent from an AIR application.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const APP:String = "app";
        
        /**
         * When hit is sent from a desktop AIR application.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const DESKTOP:String = "desktop";
        
        /**
         * When hit is sent from a mobile AIR application.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const MOBILE:String = "mobile";
        
        /**
         * When hit is sent from a Redtamarin command-line program. 
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const COMMAND_LINE:String = "commandline";
        
        /**
         * Creates a DataSource.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function DataSource()
        {
            super();
        }
    }
}