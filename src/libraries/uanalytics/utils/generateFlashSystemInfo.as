package libraries.uanalytics.utils
{
    import flash.display.DisplayObject;
    
    import libraries.uanalytics.tracker.SystemInfo;

    /**
     * Utility function to gather automatically the <code>SystemInfo</code>
     * from a SWF file.
     * 
     * <p>
     * Even if the <code>display</code> argument is optional,
     * it is the only way to obtain a reference to the <code>stage</code> property
     * to obtain the "viewport size".
     * </p>
     * <pre>
     * If a display object is not added to the display list,
     * its stage property is set to null.
     * </pre>
     * 
     * @param display <code>DisplayObject</code> reference (optional).
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/as3/dev/WS5b3ccc516d4fbf351e63e3d118a9b90204-7e3e.html Basics of display programming
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#stage DisplayObject.stage property
     * 
     */
    public function generateFlashSystemInfo( display:DisplayObject = null ):SystemInfo
    {
        /* Note:
           the principle is pretty simple, we build a defautl value object
           if we can detect system info we then fill the info
           otherwise we keep the value empty (or false, whatever the default).
           
           Yes we took a very conservative and safe approach to avoid as much
           as possible errors, ex: "I don't understand why my display object
           does not work", that said you can do more advanced things
           like: use a JS bridge to detect if Java is enabled, find out the
           document encoding, etc.
           
           The point is the default will work no matter what, more advanced users
           will know how to setup things in order to gather more info.
           
           usage:
           var tracker:DefaultTracker = new DefaultTracker( trackingId );
           var sysinfo:SystemInfo = generateFlashSystemInfo();
               tracker.add( sysinfo );
           
        */
        var sysinfo:SystemInfo = new SystemInfo();
            sysinfo.screenResolution = getScreenResolution();
        
        if( display && display.stage )
        {
            sysinfo.viewportSize = getViewportSize( display.stage );
        }
            
            sysinfo.documentEncoding = getDocumentEncoding();
            sysinfo.screenColors = getScreenColors();
            sysinfo.userLanguage = getUserLanguage();
            sysinfo.javaEnabled = false;
            sysinfo.flashVersion = getFlashVersion();
        
        return sysinfo;
    }
}