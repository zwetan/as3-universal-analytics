package libraries.uanalytics.utils
{
    import flash.display.DisplayObject;
    
    import libraries.uanalytics.tracker.SystemInfo;
    
    /**
     * Utility function to gather automatically the <code>SystemInfo</code>
     * from an AIR application.
     * 
     * <p>
     * Almost the same function as <code>generateFlashSystemInfo()</code>
     * but provide a bit more details for "screenColors" and "userLanguage".
     * </p>
     * 
     * @param display <code>DisplayObject</code> reference (optional).
     * 
     * @playerversion AIR 3.0
     * @langversion 3.0
     */
    public function generateAIRSystemInfo( display:DisplayObject = null ):SystemInfo
    {
        var sysinfo:SystemInfo = new SystemInfo();
            sysinfo.screenResolution = getScreenResolution();
        
        if( display && display.stage )
        {
            sysinfo.viewportSize = getViewportSize( display.stage );
        }
        
            sysinfo.documentEncoding = getDocumentEncoding();
        
        var screenColors:String = "";
        
        if( display && display.stage )
        {
            screenColors = getAIRScreenColors( display.stage );
        }
        
        if( screenColors == "" )
        {
            screenColors = getScreenColors();
        }
        
        var userLanguage:String = "";
        
            userLanguage = getAIRUserLanguage();
        
        if( userLanguage == "" )
        {
            userLanguage = getUserLanguage();
        }
        
            sysinfo.screenColors = screenColors;
            sysinfo.userLanguage = userLanguage;
            sysinfo.javaEnabled = false;
            sysinfo.flashVersion = getFlashVersion();
        
        return sysinfo;
    }
}