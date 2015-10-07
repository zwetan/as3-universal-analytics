/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker.addons
{
    import C.errno.*;
    import C.sys.stat.*;
    import C.unistd.*;
    import C.stdio.*;
    
    import flash.utils.ByteArray;
    
    import libraries.uanalytics.tracking.Configuration;
    
    import shell.FileSystem;
    
    /**
     * Utility function to debug and/or reset the File System storage.
     * 
     * @param show show informations and datas of the sotrage (default to <code>true</code>).
     * @param reset clear the storage from its data (default to <code>false</code>).
     * 
     * @playerversion AVM 0.4
     * @langversion 3.0
     */
    public function DebugFileSystemStorage( show:Boolean = true,
                                            reset:Boolean = false ):void
    {
        var homedir:String = FileSystem.homeDirectory;
        
        if( homedir == "" )
        {
            homedir = "/"; // root dir
        }
        
        var exists:int = access( homedir, F_OK );
        if( exists < 0 )
        {
            throw new CError( errno );
        }
        
        var canread:int = access( homedir, R_OK );
        if( canread < 0 )
        {
            throw new CError( errno );
        }
        
        var canwrite:int = access( homedir, W_OK );
        if( canwrite < 0 )
        {
            throw new CError( errno );
        }
        
        // by that point we are sure the HOME directory exists and is readable/writable
        // for ex: /home/username
        
        var savepath:String = homedir + "/.uanalytics";
        var s_exists:int = access( savepath, F_OK );
        if( s_exists < 0 )
        {
            throw new CError( errno );
        }
        
        // by that point we are sure our preference dir .uanalytics exists
        // for ex: /home/username/.uanalytics
        
        var config:Configuration = new Configuration();
        var filepath:String = savepath + "/" + config.storageName;
        var data:String = "";
        
        var f_exists:int = access( filepath, F_OK );
        if( f_exists < 0 )
        {
            throw new CError( errno );
        }
        else
        {
            // the save file already exists
            data = FileSystem.read( filepath );
        }
            
        if( show )
        {
            trace( "File: " + filepath );
            trace( "size: " + data.length + " bytes" );
            trace( "data:" );
            trace( "  |_ " + data );
        }
        
        if( reset )
        {
            // bug: does not allow you to write an empty file
            //FileSystem.write( filepath, "" );
            var fp:FILE = fopen( filepath, "w" );
            if( fp )
            {
                var bytes:ByteArray = new ByteArray();
                fwrite( bytes, bytes.length, fp );
                fflush( fp );
                bytes.clear();
                fclose( fp );
            }
        }
    }
}