/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker
{
    import flash.system.System;
    import flash.utils.describeType;

    /**
     * The HitType class defines allowed values for the "hit type" parameter.
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see libraries.uanalytics.tracking.Tracker#send() Tracker.send()
     * @see libraries.uanalytics.tracking.Tracker#HIT_TYPE Tracker.HIT_TYPE
     * @see libraries.uanalytics.tracking.Metadata Metadata
     * @see http://developers.google.com/analytics/devguides/collection/protocol/v1/parameters#t Hit Type
     */
    public class HitType
    {
        
        /**
         * Defines a "pageview" hit type.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const PAGEVIEW:String    = "pageview";
        
        /**
         * Defines a "screenview" hit type.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const SCREENVIEW:String  = "screenview";
        
        /**
         * Defines an "event" hit type.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const EVENT:String       = "event";
        
        /**
         * Defines a "transaction" hit type.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const TRANSACTION:String = "transaction";
        
        /**
         * Defines an "item" hit type.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const ITEM:String        = "item";
        
        /**
         * Defines a "social" hit type.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const SOCIAL:String      = "social";
        
        /**
         * Defines an "exception" hit type.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const EXCEPTION:String   = "exception";
        
        /**
         * Defines a "timing" hit type.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const TIMING:String      = "timing";
        
        /**
         * Returns <code>true</code> is the passed string <code>type</code>
         * is a valid Hit Type.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static function isValid( type:String ):Boolean
        {
            var _class:XML = describeType( HitType );
            var found:Boolean = false;
            
            var property:String;
            for each( var member:XML in _class.constant )
            {
                property = String( member.@name );
                
                if( HitType[ property ] == type )
                {
                    found = true;
                    break;
                }
                
            }
            System.disposeXML( _class );
            
            if( found )
            {
                return true;
            }
            
            return false;
        }
        
        /**
         * Creates a HitType.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function HitType()
        {
            super();
        }
    }
}