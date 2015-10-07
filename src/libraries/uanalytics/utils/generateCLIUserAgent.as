package libraries.uanalytics.utils
{
    import shell.Runtime;
    
    /**
     * Utility function to generate a user-agent for the command-line.
     * 
     * <p>
     * Will generate a string looking like:
     * </p>
     * <listing>
     * //windows
     * uanalytics/0.8 (Windows NT 6.1) redtamarin/0.4.1T174 AVM+/2.1 cyclone
     * 
     * //macintosh
     * uanalytics/0.8 (Macintosh; Intel Mac OS X 10_10) redtamarin/0.4.1T174 AVM+/2.1 cyclone
     * 
     * //linux
     * uanalytics/0.8 (Linux x86_64) redtamarin/0.4.1T174 AVM+/2.1 cyclone
     * uanalytics/0.8 (Linux i686) redtamarin/0.4.1T174 AVM+/2.1 cyclone
     * </listing>
     * 
     * <p>
     * In your analytics reports you will find:
     * </p>
     * <ul>
     *   <li>
     *   <b>Operating System:</b> Windows<br>
     *   <b>Operating System Version:</b> 7
     *   </li>
     *   <li>
     *   <b>Operating System:</b> Macintosh<br>
     *   <b>Operating System Version:</b> Intel 10.10
     *   </li>
     *   <li>
     *   <b>Operating System:</b> Linux<br>
     *   <b>Operating System Version:</b> i686
     *   </li>
     *   <li>
     *   <b>Operating System:</b> Linux<br>
     *   <b>Operating System Version:</b> x86_64
     *   </li>
     * </ul>
     * 
     * <p>
     * <b>Note:</b><br>
     * The documentation do warn about that
     * </p>
     * <listing>
     * Note that Google has libraries to identify real user agents.
     * Hand crafting your own agent could break at any time.
     * </listing>
     * <p>
     * a wrong user-agent could be the reason of a hit request not being
     * registered by the Google Analytics Servers.
     * </p>
     * 
     * @param platform override the platform with either
     *                 "windows", "macintosh", "linux"
     * 
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters#ua User Agent Override
     */
    public function generateCLIUserAgent( platform:String = "" ):String
    {
        var ua:String = "";
            ua += "uanalytics/0.8";
            ua += " ";
            ua += "(";
            
        if( platform == "" )
        {
            platform = Runtime.platform;
        }
        else
        {
            switch( platform )
            {
                case "windows":
                case "macintosh":
                case "linux":
                //those are valid do nothing
                break;
                
                default:
                //not valid so we use system default
                platform = Runtime.platform;
            }
        }
        
        
        var p:String = platform.substr( 0, 1 );
            p = p.toUpperCase();
            platform = p + platform.substring( 1 );
        
        /* Note:
           the current release of Redtamarin do not detect further
           than the operating system platform
           eg. "windows", "macintosh", or "linux"
           
           It will be updated in the futur to detect the exact
           operating system informations.
           
           As a workaround it can also be done manually
           by parsing the result of
           lsb_release -a
           cat /etc/*release
           uname -a
           cat /System/Library/CoreServices/SystemVersion.plist
           sysctl kern.osrelease
           sysctl kern.osversion
        */
        switch( platform )
        {
            case "Windows":
            /* Note:
               "Windows" alone will not work
               "Windows NT" without a version will not work
               "Windows NT x.y" will work
            */
            ua += platform;
            ua += " NT 6.1";
            break;
            
            case "Macintosh":
            /* Note:
               "Macintosh" alone will not work
               "Macintosh; Intel Mac OS X" without a version will not work
               "Macintosh; Intel Mac OS X x_y" will work
            */
            ua += platform;
            ua += "; Intel Mac OS X 10_10";
            break;
            
            case "Linux":
            ua += platform;
            
            /* Note:
               "Linux" alone will not work
               either "Linux x86_64" or "Linux i686" will work
            */
            if( Runtime.is64bit() )
            {
                ua += " x86_64";
            }
            else
            {
                ua += " i686";
            }
            break;
        }
            
            ua += ")";
            ua += " ";
            ua += "redtamarin/" + Runtime.redtamarin;
            ua += " ";
            ua += "AVM+/" + Runtime.version;
        
        return ua;
    }
}