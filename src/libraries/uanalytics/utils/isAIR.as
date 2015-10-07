package libraries.uanalytics.utils
{
    import flash.system.Security;

    /**
     * Returns <code>true</code> if the current context is an AIR application.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     */
    public function isAIR():Boolean
    {
        return Security.sandboxType == Security.APPLICATION;
    }
}