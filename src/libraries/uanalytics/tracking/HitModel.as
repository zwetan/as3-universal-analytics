/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracking
{
    import flash.utils.Dictionary;
    
    /**
     * Core data model class that represents a single "hit".
     * 
     * <p>
     * Users primarily get and set field values.
     * </p>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     */
    public class HitModel
    {
        private var _data:Dictionary;
        private var _metadata:Metadata;
        
        /**
         * Create a new HitModel.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function HitModel()
        {
            _metadata = new Metadata();
            clear();
        }
        
        /**
         * Set a model field to a specific value.
         * 
         * <p>
         * Common field names are provided as static members of the <code>Tracker</code> class.
         * You may also use your own field names to store information in the data
         * model but they will not be sent in the tracking beacon.
         * </p>
         * 
         * @param field the field to set. May not be null.
         * @param value the new field value. May be null.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function set( field:String, value:String ):void
        {
            _data[ _metadata.getHitModelKey( field ) ] = value; 
        }
        
        /**
         * Returns the value of the specified field.
         * 
         * <p>
         * See the <code>set</code> method for a description of possible field
         * names.
         * </p>
         * 
         * @param field the field to return.
         * 
         * @return the value of the specified field. May return null.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function get( field:String ):String
        {
            return _data[ _metadata.getHitModelKey( field ) ];
        }
        
        /**
         * Add the data of a <code>HitModel</code> to this model.
         * 
         * @param model the model to add.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function add( model:HitModel ):void
        {
            for( var key:String in model._data )
            {
                _data[ key ] = model._data[ key ];
            }
        }
        
        /**
         * Returns a new copy of this <code>HitModel</code> with all the same
         * fields set.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function clone():HitModel
        {
            var copy:HitModel = new HitModel();
            
            for( var key:String in _data )
            {
                copy._data[ key ] = _data[ key ];
            }
            
            return copy;
        }
        
        /**
         * Clear all the fields set in the model.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function clear():void
        {
            _data = new Dictionary();
        }
        
        /**
         * Returns all of the field names currently set in the model.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function getFieldNames():Vector.<String>
        {
            var data:Vector.<String> = new Vector.<String>();
            
            for( var keys:String in _data )
            {
                data.push( keys );
            }
            
            return data;
        }
    }
    
}