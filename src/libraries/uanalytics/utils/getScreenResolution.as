package libraries.uanalytics.utils
{
    import flash.system.Capabilities;
    
    /**
     * Return the screen resolution.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Capabilities.html#screenResolutionX Capabilities.screenResolutionX
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Capabilities.html#screenResolutionY Capabilities.screenResolutionY
     */
    public function getScreenResolution():String
    {
        var w:Number = Capabilities.screenResolutionX;
        var h:Number = Capabilities.screenResolutionY;
        
        return String(w) + "x" + String(h);
    }
}