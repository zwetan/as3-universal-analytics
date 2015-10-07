/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracking
{
    import libraries.uanalytics.utils.isDigit;
    import libraries.uanalytics.utils.crc32;
    
    import flash.utils.ByteArray;

    /**
     * Utility methods for determining whether or not a particular hit
     * should be sent to Google Analytics collection servers due to sampling.
     * 
     * <p>
     * Sampling is determined on a per-client basis as identified by
     * the <code>Tracker.CLIENT_ID</code> field.
     * This means that either all or none of the hits from a particular client
     * will be sent.
     * </p>
     * 
     * <p>
     * By default we use the value set in <code>Configuration</code>,
     * you can edit the configuration to use something else than the
     * default (100%).
     * </p>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see Configuration#sampleRate Configuration.sampleRate
     * @see http://support.google.com/analytics/answer/2637192?hl=en How sampling works
     */
    public class HitSampler
    {
        /**
         * Return a hash for the specified string.
         * 
         * @param source input string to be hashed.
         * @return hash of input string.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        private static function _hashString( source:String ):Number
        {
            var crc:crc32 = new crc32();
            var bytes:ByteArray = new ByteArray();
                //bytes.writeMultiByte( source, "UTF-8" );
                bytes.writeUTFBytes( source );
                crc.update( bytes );
            return crc.valueOf();
        }
        
        /**
         * Converts a string to a Number.
         * Follows almost the same rules as <code>parseFloat()</code>
         * except that trailing non-numeric characters are not ignored and return NaN.
         * 
         * @param The string to read and convert to a Number.
         * @return A number or NaN (not a number).
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */        
        private static function _parseNumber( str:String ):Number
        {
            if( str == "" ) { return NaN; }
            
            var i:uint;
            var l:uint = str.length;
            var dot:uint = 0;
            for( i=0; i<l; i++ )
            {
                //you can have only one "." per number
                if( (str.charAt(i) == ".") && (dot == 0) ) { dot++; continue; }
                //any other chars need to be a digit
                if( !isDigit( str, i ) ) { return NaN; }
            }
            
            return parseFloat( str );
        }
        
        /**
         * Return true if the hit should not be sent due to sampling.
         * 
         * <p>
         * Sampling is implemented per visitor.
         * The sample rate is determined from the <code>SAMPLE_RATE</code> field.
         * </p>
         * 
         * @param model
         * 
         * @return true if the hit should be sampled out and not sent.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static function isSampled( model:HitModel, samplerate:String = "" ):Boolean
        {
            var sampleRate:Number = getSampleRate( samplerate );
            
            return (sampleRate < 100) && (_hashString( model.get(Tracker.CLIENT_ID) ) % 10000 >= 100 * sampleRate)
        }
        
        /**
         * Parse the specified sample rate string expressed as a floating point numbers.
         * 
         * <p>
         * Values will be rounded to the nearest 100th.
         * Invalid numbers will return <code>0</code>.
         * Values greater than 100 will return <code>100</code>.
         * </p>
         * 
         * @param rate sample rate string
         * 
         * @return the sample rate as a double
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static function getSampleRate( rate:String ):Number
        {
            if( (rate == null) || (rate == "") ) { return 100; }
            
            var result:Number = Math.max( 0, Math.min(100, Math.round( _parseNumber(rate) * 100) / 100) );
            
            // An invalid number so sample everything out.
            if( isNaN( result ) ) { return 0; }
            
            return result;
        }
    }
    
}