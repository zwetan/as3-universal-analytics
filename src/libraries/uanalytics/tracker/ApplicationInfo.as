/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker
{
    import flash.utils.Dictionary;
    
    import libraries.uanalytics.tracking.Tracker;

    /**
     * The ApplicationInfo defines parameters meant to be used
     * for the App / Screen Tracking.
     * 
     * <p>
     * By default, all the parameters are empty (not initialised).
     * Only the non-empty (or initialised) parameters wil be exported
     * by the <code>toDictionary()</code> function.
     * </p>
     * 
     * @example Usage
     * <listing>
     * // define the app properties manually
     * var appinfo:ApplicationInfo = new ApplicationInfo();
     *     appinfo.name        = "My App";
     *     appinfo.ID          = "com.something.myapp";
     *     appinfo.version     = "1.0.0";
     *     appinfo.installerID = "Local testing";
     * 
     * // pass it to the tracker
     * tracker.add( appinfo.toDictionary() );
     * </listing>
     * 
     * <listing>
     * // automatically generate the app properties
     * var appinfo:ApplicationInfo = generateAIRAppInfo();
     * 
     * // pass it to the tracker
     * tracker.add( appinfo.toDictionary() );
     * </listing>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see libraries.uanalytics.utils#generateAIRAppInfo() generateAIRAppInfo()
     */
    public class ApplicationInfo
    {
       
        /**
         * The application name.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#APP_NAME Tracker.APP_NAME
         */
        public var name:String        = "";
        
        /**
         * The application identifier.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#APP_ID Tracker.APP_ID
         */
        public var ID:String          = "";
        
        /**
         * The application version.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#APP_VERSION Tracker.APP_VERSION
         */
        public var version:String     = "";
        
        /**
         * The application installer identifier.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#APP_INSTALLER_ID Tracker.APP_INSTALLER_ID
         */
        public var installerID:String = "";
        
        /**
         * Creates an empty ApplicationInfo.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function ApplicationInfo()
        {
            super();
        }
        
        /**
         * Export the initialised (non-empty) parameters.
         * 
         * @return a Dictionary containing field/value pairs.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function toDictionary():Dictionary
        {
            var values:Dictionary = new Dictionary();
            
            if( name.length > 0 )
            {
                values[ Tracker.APP_NAME ] = name;
            }
            
            if( ID.length > 0 )
            {
                values[ Tracker.APP_ID ] = ID;
            }
            
            if( version.length > 0 )
            {
                values[ Tracker.APP_VERSION ] = version;
            }
            
            if( installerID.length > 0 )
            {
                values[ Tracker.APP_INSTALLER_ID ] = installerID;
            }
            
            return values;
        }
    }
}