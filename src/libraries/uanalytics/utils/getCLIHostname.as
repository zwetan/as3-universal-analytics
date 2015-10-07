package libraries.uanalytics.utils
{
    import C.stdlib.*;
    import C.unistd.*;
    
    /**
     * Obtain the hostname of a command-line program.
     * 
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see http://tools.ietf.org/html/rfc3875#section-4.1.14 SERVER_NAME
     * @see http://docs.redtamarin.com/latest/C/unistd/package.html#gethostname() C.unistd.gethostname()
     * @see http://pubs.opengroup.org/onlinepubs/9699919799/functions/gethostname.html gethostname()
     */
    public function getCLIHostname():String
    {
        var hostname:String = "";
        
        /* Note:
           when run with CGI you can access the SERVER_NAME env var
           
           for ex:
           SERVER_NAME = as3lang.org
           SERVER_NAME = www.as3lang.org
           etc.
        */
        var SERVER_NAME:String = getenv( "SERVER_NAME" );
        //trace( "SERVER_NAME = " + SERVER_NAME );
        
        /* Note:
           if SERVER_NAME is empty
           that means the program is not running under CGI
           you must be either a static binary, a shell script, or
           an ABC/SWF file run with redshell
           
           then we can use gethostname() to resolve the machine hostname
        */
        if( SERVER_NAME == "" )
        {
            // get name of current host
            hostname = gethostname();
            //trace( "gethostname() = " + hostname );
        }
        
        if( (hostname == null) || (hostname == "") )
        {
            hostname = "localhost";
            //trace( "hostname = " + hostname );
        }
        
        return hostname;
    }
}