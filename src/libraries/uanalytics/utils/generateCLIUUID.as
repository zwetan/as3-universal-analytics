package libraries.uanalytics.utils
{
    import flash.utils.ByteArray;
    import crypto.generateRandomBytes;
    
    /**
     * Generates a version 4 UUID string representation.
     * 
     * <p>
     * format is <code>xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx</code>
     * where <code>x</code> is any hexadecimal digit
     * and <code>y</code> is oen of <code>8</code>, <code>9</code>, <code>A</code>, or <code>B</code>.
     * </p>
     * 
     * <p>
     * <b>Note:</b> this is a temporary solution as the current redtamarin runtimes
     * does not implment <code>flash.crypto.generateRandomBytes</code> yet.<br>
     * It will work under Linux and Mac OS X but not under Windows.
     * </p>
     * 
     * @return a UUID v4 string.
     * 
     * @playerversion AVM 0.4
     * @playerversion POSIX +
     * @langversion 3.0
     * 
     * @see http://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_.28random.29 Universally unique identifier v4
     */
    public function generateCLIUUID():String
    {
        var randomBytes:ByteArray = generateRandomBytes( 16 );
            randomBytes[6] &= 0x0f; /* clear version */
            randomBytes[6] |= 0x40; /* set to version 4 */
            randomBytes[8] &= 0x3f; /* clear variant */
            randomBytes[8] |= 0x80; /* set to IETF variant */
        
        var toHex:Function = function( n:uint ):String
        {
            var h:String = n.toString( 16 );
                h = (h.length > 1 ) ? h: "0"+h;
            return h;
        }
        
        var str:String = "";
        var i:uint;
        var l:uint = randomBytes.length;
        randomBytes.position = 0;
        var byte:uint;
        
        for( i=0; i<l; i++ )
        {
            byte = randomBytes[ i ];
            str += toHex( byte );
        }
        
        var uuid:String = "";
            uuid += str.substr( 0, 8 );
            uuid += "-";
            uuid += str.substr( 8, 4 );
            uuid += "-";
            uuid += str.substr( 12, 4 );
            uuid += "-";
            uuid += str.substr( 16, 4 );
            uuid += "-";
            uuid += str.substr( 20, 12 );
        
        return uuid;
    }
}