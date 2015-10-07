package libraries.uanalytics.utils
{
    import flash.system.Capabilities;

    /**
     * Return the Flash version.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Capabilities.html#version Capabilities.version
     */
    public function getFlashVersion():String
    {
        // AND 10,2,150,0
        var v:String = Capabilities.version;
        
        var tmp:Array = v.split( " " );
        // 10,2,150,0
        var v2:String = tmp[1];
        var c:Array = v2.split( "," );
        
        var str:String = "";
            str += c[0];
            str += " " + c[1];
            str += " r" + c[2];
            // 10 2 r150
        
        return str;
    }
}