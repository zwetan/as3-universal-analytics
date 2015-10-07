package libraries.uanalytics.utils
{
    import flash.system.System;

    /**
     * Return the encoding or code page of the current SWF file
     * or AIR application.
     * 
     * <p>
     * Because <code>System.useCodePage = false</code> by default,
     * it should always be "UTF-8" (eg. we don't use the sytem code page
     * so we know we use Unicode).
     * And in the case where <code>System.useCodePage = true</code>
     * then it will return the empty string (eg. the system code page is used
     * so we don't know).
     * </p>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/System.html#useCodePage System.useCodePage
     */
    public function getDocumentEncoding():String
    {
        /* Note:
           "as is" we have no way to detect the codepage
           inside Flash/AIR, so if useCodePage is true
           then we agre to "don't know"
        */
        if( System.useCodePage )
        {
            return "";
        }
        
        /* Note:
           if useCodePage is false then we know
           we use the default UTF-8 codepage
        */
        return "UTF-8";
    }
}