package libraries.uanalytics.utils
{
    
    /**
     * Indicates if the specified character is a digit.
     * 
     * @param c The expression to evaluate.
     * @param index The optional index to evaluate a specific character in the
     *              passed-in expression.
     * 
     * @return True if the specified character is a digit.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     */
    public function isDigit( c:String , index:uint = 0 ):Boolean
    {
        if( index > 0 )
        {
            c = c.charAt( index ) ;
        }
        
        return ("0" <= c) && (c <= "9");
    }
}