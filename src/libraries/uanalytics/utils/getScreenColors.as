package libraries.uanalytics.utils
{
    import flash.system.Capabilities;

    /**
     * Return the screen color depth.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Capabilities.html#screenColor Capabilities.screenColor
     */
    public function getScreenColors():String
    {
        var str:String = "";
        
        switch( Capabilities.screenColor )
        {
            case "bw":
            str = "1";
            break;
            
            case "gray":
            str = "2";
            break;
            
            case "color":
            default:
            str = "24";
        }
        
            str += "-bits";
        
        return str;
    }
}