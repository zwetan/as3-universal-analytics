package libraries.uanalytics.utils
{
    import shell.Runtime;
    
    import C.stdlib.*;
    import C.unistd.which;
    
    import libraries.uanalytics.tracker.SystemInfo;
    
    /**
     * Utility function to gather automatically the <code>SystemInfo</code>
     * from a command-line program.
     * 
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap07.html POSIX Locale
     * @see http://docs.redtamarin.com/latest/shell/Runtime.html#api Runtime.api
     */
    public function generateCLISystemInfo():SystemInfo
    {
        var sysinfo:SystemInfo = new SystemInfo();
        
        /* Note:
           for the command-line we ignore
           screenResolution and viewportSize.
        */
        
        var documentEncoding:String = "";
        var userLanguage:String = "";
        
        /* Note:
           under POSIX, you could find somethign like
           LANG = en_GB.UTF-8
           which allow us to find out the language and encoding used
        */
        var LANG:String = getenv( "LANG" );
        if( LANG != "" )
        {
            var pos:int = LANG.indexOf( "." );
            if( pos > -1 )
            {
                userLanguage = LANG.substring( 0, pos );
                documentEncoding = LANG.substr( pos + 1 );
            }
            else
            {
                userLanguage = LANG;
            }
            
            userLanguage = userLanguage.split( "_" ).join( "-" );
            userLanguage = userLanguage.toLowerCase();
        }
        
        var JAVA:String = which( "java" );
        
        if( documentEncoding != "" )
        {
            sysinfo.documentEncoding = documentEncoding;
        }
        
        // as default we set for a "gray" color depth
        sysinfo.screenColors = "2-bits";
        
        if( userLanguage != "" )
        {
            sysinfo.userLanguage = userLanguage;
        }
        
        if( JAVA != "" )
        {
            sysinfo.javaEnabled = true;
        }

        var FLASH:String = "";
        switch( Runtime.api )
        {
            
            case "FP_10_0":
            case "AIR_1_5":
            FLASH = "10 0";
            break;
            
            case "FP_10_0_32":
            case "AIR_1_5_1":
            FLASH = "10 0 r32";
            break;
            
            case "FP_10_1":
            case "AIR_1_5_2":
            FLASH = "10 1";
            break;
            
            case "AIR_2_0":
            case "AIR_2_5":
            FLASH = "10 2";
            break;
            
            case "FP_10_2":
            case "AIR_2_6":
            FLASH = "10 2";
            break;
            
            case "SWF_12":
            case "AIR_2_7":
            FLASH = "10 3";
            break;
            
            case "SWF_13":
            case "AIR_3_0":
            FLASH = "11 0";
            break;
            
            case "SWF_14":
            case "AIR_3_1":
            FLASH = "11 1";
            break;
            
            case "SWF_15":
            case "AIR_3_2":
            FLASH = "11 2";
            break;
            
            case "SWF_16":
            case "AIR_3_3":
            FLASH = "11 3";
            break;
            
            case "SWF_17":
            case "AIR_3_4":
            FLASH = "11 4";
            break;
            
            case "SWF_18":
            case "AIR_3_5":
            FLASH = "11 5";
            break;
            
            case "SWF_19":
            case "AIR_3_6":
            FLASH = "11 6";
            break;
            
            case "FP_9_0":
            case "AIR_1_0":
            default:
            FLASH = "9 0";
        }
        
        if( FLASH != "" )
        {
            sysinfo.flashVersion = FLASH;
        }
        
        return sysinfo;
    }
}