package libraries.uanalytics.utils
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    /**
     * A class to compute the <b>CRC-32</b> checksum of a data stream.
     * 
     * <p>
     * Other names: <b>CRC-32/ADCCP</b>, <b>PKZIP</b>
     * </p>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see https://en.wikipedia.org/wiki/Computation_of_cyclic_redundancy_checks Computation of cyclic redundancy checks
     */
    public final class crc32
    {
        
        private static var lookup:Vector.<uint> = make_crc_table();
        
        private static function make_crc_table():Vector.<uint>
        {
            var table:Vector.<uint> = new Vector.<uint>();
            
            var c:uint;
            var i:uint;
            var j:uint;
            
            for( i=0; i < 256; i++ )
            {
                c = i;
                for( j=0; j < 8; j++ )
                {
                    if( (c & 0x00000001) != 0 )
                    {
                        c = (c >>> 1) ^ _poly;
                    }
                    else
                    {
                        c = (c >>> 1);
                    }
                }
                table[i] = c;
            }
            
            return table;
        }
        
        // ---- CONFIG ----
        
        private static var _poly:uint = 0xedb88320;
        private static var _init:uint = 0xffffffff;
        
        // ---- CONFIG ----
        
        private var _crc:uint;
        private var _length:uint;
        private var _endian:String;
        
        /**
         * Creates a CRC-32 object.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function crc32()
        {
            _length = 0xffffffff;
            _endian = Endian.LITTLE_ENDIAN;
            reset();
        }
        
        /**
         * Returns the byte order for the CRC.
         * 
         * <p>
         * Either <code>Endian.BIG_ENDIAN</code> for "Most significant bit first"
         * or <code>Endian.LITTLE_ENDIAN</code> for "Least significant bit first".
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see http://en.wikipedia.org/wiki/Computation_of_CRC#Bit_ordering_.28Endianness.29 Bit ordering (endianness)
         */
        public function get endian():String { return _endian; }
        
        /**
         * Returns the length the CRC;
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function get length():uint { return _length; }
        
        /**
         * Updates the CRC-32 with a specified array of bytes.
         * 
         * @param bytes  The ByteArray object
         * @param offset A zero-based index indicating the position into the
         *               array to begin reading.
         * @param length An unsigned integer indicating how far into the buffer
         *               to read (if 0, the length of the ByteArray is used).
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function update( bytes:ByteArray, offset:uint = 0, length:uint = 0 ):void
        {
            if( length == 0 ) { length = bytes.length; }
        
            bytes.position = offset;
            
            var i:uint;
            var c:uint;
            var crc:uint = _length & (_crc);
            
            for( i = offset; i < length; i++ )
            {
                c    = uint( bytes[ i ] );
                crc  = (crc >>> 8) ^ lookup[(crc ^ c) & 0xff];
            }
            
            _crc = ~crc;
        }
        
        /**
         * Resets the CRC-32 to its initial value.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function reset():void
        {
            _crc = _init;
        }
        
        /**
         * Returns the primitive value type of the CRC-32 object (unsigned integer).
         * 
         * @return a 32bits digest
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function valueOf():uint
        {
            return _crc;
        }
        
        /**
         * Returns the string representation of the CRC-32 value.
         * 
         * @param radix Specifies the numeric base (from 2 to 36) to use for
         *              the uint-to-string conversion. If you do not specify the
         *              radix parameter, the default value is 16.
         * 
         * @return The numeric representation of the CRC-32 object as a string.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */ 
        public function toString( radix:Number = 16 ):String
        {
            return _crc.toString( radix );
        }
    
    }
    
}