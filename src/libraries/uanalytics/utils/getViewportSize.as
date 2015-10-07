package libraries.uanalytics.utils
{
    import flash.display.Stage;

    /**
     * Utility function to return the "viewport size"
     * (eg. the actual rectangle area used by the application).
     * 
     * @param stage the stage property of a <code>DisplayObject</code>.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://www.adobe.com/devnet/air/articles/multiple-screen-sizes.html Supporting the multiple screen sizes of multiple devices in Adobe AIR
     */
    public function getViewportSize( stage:Stage ):String
    {
        var w:Number = stage.stageWidth;
        var h:Number = stage.stageHeight;
        
        return String(w) + "x" + String(h);
    }
}