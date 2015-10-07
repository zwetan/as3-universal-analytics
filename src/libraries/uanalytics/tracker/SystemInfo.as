/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker
{
    import flash.utils.Dictionary;
    
    import libraries.uanalytics.tracking.Tracker;

    /**
     * The SystemInfo defines parameters meant to be used
     * for System Information Tracking.
     * 
     * <p>
     * By default, all the parameters are empty (not initialised).
     * Only the non-empty (or initialised) parameters wil be exported
     * by the <code>toDictionary()</code> function.
     * </p>
     * 
     * @example Usage
     * <listing>
     * // define the system info properties manually
     * var sysinfo:SystemInfo = new SystemInfo();
     *     sysinfo.userLanguage = "en";
     *     sysinfo.documentEncoding = "UTF-8";
     *     sysinfo.screenResolution = "800x600";
     * 
     * // pass it to the tracker
     * tracker.add( sysinfo.toDictionary() );
     * </listing>
     * 
     * <listing>
     * // automatically generate the system info properties
     * var sysinfo:SystemInfo = generateFlashSystemInfo();
     * 
     * // pass it to the tracker
     * tracker.add( sysinfo.toDictionary() );
     * </listing>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see libraries.uanalytics.utils#generateFlashSystemInfo() generateFlashSystemInfo()
     * @see libraries.uanalytics.utils#generateAIRSystemInfo() generateAIRSystemInfo()
     * @see libraries.uanalytics.utils#generateCLISystemInfo() generateCLISystemInfo()
     */
    public class SystemInfo
    {
        
        /**
         * The screen resolution.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#SCREEN_RESOLUTION Tracker.SCREEN_RESOLUTION
         */
        public var screenResolution:String = "";
        
        /**
         * The viewable area of the browser / device.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#VIEWPORT_SIZE Tracker.VIEWPORT_SIZE
         */
        public var viewportSize:String     = "";
        
        /**
         * The character set used to encode the page / document.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#DOCUMENT_ENCODING Tracker.DOCUMENT_ENCODING
         */
        public var documentEncoding:String = "";
        
        /**
         * The screen color depth.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#SCREEN_COLORS Tracker.SCREEN_COLORS
         */
        public var screenColors:String     = "";
        
        /**
         * The language.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#USER_LANGUAGE Tracker.USER_LANGUAGE
         */
        public var userLanguage:String     = "";
        
        /**
         * Whether Java is enabled.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#JAVA_ENABLED Tracker.JAVA_ENABLED
         */
        public var javaEnabled:Boolean     = false;
        
        /**
         * The flash version.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see libraries.uanalytics.tracking.Tracker#FLASH_VERSION Tracker.FLASH_VERSION
         */
        public var flashVersion:String     = "";
        
        /**
         * Creates an empty SystemInfo.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function SystemInfo()
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
            
            if( screenResolution.length > 0 )
            {
                values[ Tracker.SCREEN_RESOLUTION ] = screenResolution;
            }
            
            if( viewportSize.length > 0 )
            {
                values[ Tracker.VIEWPORT_SIZE ] = viewportSize;
            }
            
            if( documentEncoding.length > 0 )
            {
                values[ Tracker.DOCUMENT_ENCODING ] = documentEncoding;
            }
            
            if( screenColors.length > 0 )
            {
                values[ Tracker.SCREEN_COLORS ] = screenColors;
            }
            
            if( userLanguage.length > 0 )
            {
                values[ Tracker.USER_LANGUAGE ] = userLanguage;
            }
            
            if( javaEnabled )
            {
                values[ Tracker.JAVA_ENABLED ] = "1";
            }
            
            if( flashVersion.length > 0 )
            {
                values[ Tracker.FLASH_VERSION ] = flashVersion;
            }
            
            return values;
        }
        
    }
}