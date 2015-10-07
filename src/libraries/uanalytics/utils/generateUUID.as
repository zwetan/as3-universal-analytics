package libraries.uanalytics.utils
{
    import flash.crypto.generateRandomBytes;
    import flash.utils.ByteArray;
    
    /**
     * Generates a version 4 UUID string representation.
     * 
     * <p>
     * format is <code>xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx</code>
     * where <code>x</code> is any hexadecimal digit
     * and <code>y</code> is oen of <code>8</code>, <code>9</code>, <code>A</code>, or <code>B</code>.
     * </p>
     * 
     * @return a UUID v4 string.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_.28random.29 Universally unique identifier v4
     * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/crypto/package.html#generateRandomBytes() flash.crypto.generateRandomBytes()
     */
    public function generateUUID():String
    {
        /* note:
           using flash.crypto.generateRandomBytes
           force a dependency on a minimum version of Flash Player 11.0 / AIR 3.0
           it can be refactored later to target lower versions
        */
        
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
        
        /* note:
           The UUID string representation is as described by this BNF
           UUID = <time_low> "-" <time_mid> "-" <time_high_and_version> "-" <variant_and_sequence> "-" <node>
           time_low = 4*<hexOctet>
           time_mid = 2*<hexOctet>
           time_high_and_version = 2*<hexOctet>
           variant_and_sequence = 2*<hexOctet>
           node = 6*<hexOctet>
           hexOctet = <hexDigit><hexDigit>
        
           see http://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_.28random.29
           Version 4 UUIDs have the form xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
           where x is any hexadecimal digit and y is one of 8, 9, a, or b
           (e.g., f47ac10b-58cc-4372-a567-0e02b2c3d479).
        */
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