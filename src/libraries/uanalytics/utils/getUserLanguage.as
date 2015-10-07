package libraries.uanalytics.utils
{
    import flash.system.Capabilities;

    /**
     * Returns the language code of the system on which the content is running.
     * 
     * <p>
     * The language is specified as a lowercase two-letter language code
     * from ISO 639-1.
     * </p>
     * 
     * <p>
     * On English systems, this property returns only the language code (en),
     * not the country code.
     * On Microsoft Windows systems, this property returns the user interface (UI)
     * language, which refers to the language used for all menus, dialog boxes,
     * error messages, and help files.
     * </p>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Capabilities.html#language Capabilities.language
     * @see http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes List of ISO 639-1 codes
     */
    public function getUserLanguage():String
    {
        var lang:String = Capabilities.language;
        
        // Other/unknown
        if( lang == "xu" )
        {
            lang = "";
        }
        
        return lang;
    }
}