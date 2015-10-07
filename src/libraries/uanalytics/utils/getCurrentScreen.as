package libraries.uanalytics.utils
{
    import flash.display.Screen;
    import flash.display.Stage;
    
    /**
     * Utility function to obtain the current <code>Screen</code>
     * of an AIR application.
     * 
     * <p>
     * For example, if an AIR desktop application run on a system with
     * multiple screens, this function will return the screen reference
     * under which the app is running.
     * </p>
     * 
     * @param stage the stage property of a <code>DisplayObject</code>.
     * 
     * @playerversion AIR 3.0
     * @langversion 3.0
     */
    public function getCurrentScreen( stage:Stage ):Screen
    {
        if( stage && stage.nativeWindow )
        {
            var screens:Array = Screen.getScreensForRectangle( stage.nativeWindow.bounds );
            if( screens.length > 0 )
            {
                return screens[0];
            }
        }
        
        return Screen.mainScreen;
    }
}