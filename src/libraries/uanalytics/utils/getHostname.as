package libraries.uanalytics.utils
{
    import flash.net.LocalConnection;

    /**
     * Obtain the hostname of the Flash or AIR application.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/LocalConnection.html#domain LocalConnection.domain
     */
    public function getHostname():String
    {
        var hostname:String = "";
        
        /* See doc:
           In content running in the application security sandbox in Adobe AIR
           (content installed with the AIR application), the runtime uses the
           string app# followed by the application ID for the AIR application
           (defined in the application descriptor file) in place of the superdomain.
           For example a connectionName for an application with the
           application ID com.example.air.MyApp connectionName
           resolves to "app#com.example.air.MyApp:connectionName".

           In SWF files published for Flash Player 9 or later, the returned string
           is the exact domain of the file, including subdomains.
           For example, if the file is located at www.adobe.com,
           this command returns "www.adobe.com".

           If the current file is a local file residing on the client computer
           running in Flash Player, this command returns "localhost".
        */
        if( LocalConnection.isSupported )
        {
            var lc:LocalConnection = new LocalConnection();
            hostname = lc.domain;
        }
        
        // we don not want to use: "app#com.example.air.MyApp:connectionName"
        if( (hostname.substr( 0, 4) == "app#") ||
            (hostname == "") )
        {
            hostname = "localhost";
        }
        
        return hostname;
    }
}