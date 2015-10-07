package libraries.uanalytics.utils
{
    import flash.display.Screen;
    import flash.display.Stage;
    
    /**
     * Return the screen color depth.
     * 
     * @param stage the stage property of a <code>DisplayObject</code>.
     * 
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Screen.html#colorDepth Screen.colorDepth
     */
    public function getAIRScreenColors( stage:Stage ):String
    {
        var current:Screen = getCurrentScreen( stage );
        
        if( current )
        {
            return current.colorDepth + "-bits";
        }
        
        return "";
    }
}