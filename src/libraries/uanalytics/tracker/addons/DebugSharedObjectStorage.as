/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker.addons
{
    import flash.net.SharedObject;
    
    import libraries.uanalytics.tracking.Configuration;
    
    /**
     * Utility function to debug and/or reset the <code>SharedObject</code>
     * storage.
     * 
     * @param show show informations and datas of the sotrage (default to <code>true</code>).
     * @param reset clear the storage from its data (default to <code>false</code>).
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @langversion 3.0
     */
    public function DebugSharedObjectStorage( show:Boolean = true,
                                              reset:Boolean = false ):void
    {
        var conf:Configuration = new Configuration();
        var so:SharedObject = SharedObject.getLocal( conf.storageName );
        
        if( show )
        {
            trace( "SharedObject: " + conf.storageName );
            trace( "size: " + so.size + " bytes" );
            trace( "data:" );
            for( var m:String in so.data )
            {
                trace( "  |_ " + m + ": " + so.data[m] );
            }
        }
        
        if( reset )
        {
            so.clear();
        }
        
    }
}