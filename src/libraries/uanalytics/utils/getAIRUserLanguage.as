package libraries.uanalytics.utils
{
    import flash.system.Capabilities;
    
    /**
     * Returns a language tag (and script and region information, where applicable)
     * defined by RFC4646.
     * 
     * <p>
     * <b>Note:</b><br>
     * The value of <code>Capabilities.language</code> property is limited to the possible
     * values on this list.
     * Because of this limitation, Adobe AIR applications should use the first
     * element in the <code>Capabilities.languages</code> array to determine the primary user
     * interface language for the system.
     * </p>
     * 
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Capabilities.html#language Capabilities.language
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Capabilities.html#languages Capabilities.languages
     * @see http://www.ietf.org/rfc/rfc4646.txt RFC4646
     * @see http://help.adobe.com/en_US/as3/dev/WS9b644acd4ebe59993a5b57f812214f2074b-8000.html#WS9b644acd4ebe59993a5b57f812214f2074b-7ffd Choosing a locale
     */
    public function getAIRUserLanguage():String
    {
        // more accurate than Capabilities.language
        return Capabilities.languages[0];
    }
}