/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker
{
    import libraries.uanalytics.tracking.Configuration;
    import libraries.uanalytics.utils.generateCLIUUID;
    
    import shell.FileSystem;
    
    import C.errno.*;
    import C.sys.stat.*;
    import C.unistd.*;
    
    /**
     * A tracker specialised for Redtamarin applications.
     * 
     * <p>
     * Features:
     * </p>
     * <ul>
     *   <li>
     *   <code>RateLimiter</code> settings: the tracker starts with 100 hits
     *   that are replenished at a rate of 10 hits per second.
     *   </li>
     *   <li>
     *   Data source is "commandline" by default.
     *   </li>
     *   <li>
     *   Use a File System storage to save/restore the ClientId.
     *   </li>
     * </ul>
     * 
     * @example Usage
     * <listing>
     * import com.google.analytics.tracker.CommandLineTracker;
     * 
     * var tracker:CliTracker = new CliTracker( "UA-12345-67" );
     * 
     *     tracker.pageview( "/hello/world", "Hello World" );
     * 
     * </listing>
     * 
     * @playerversion AVM 0.4
     * @playerversion POSIX +
     * @langversion 3.0
     */
    public class CliTracker extends CommandLineTracker
    {
    
        /**
         * Create a new CliTracker with no data model fields set.
         * 
         * @param trackingId the Tracking ID
         * @param config the tracker configuration
         * @param verbose enable sender verbose mode
         * @param debug enable sender debug mode
         * @param senderErrorChecking enable sender error checking
         * 
         * @playerversion AVM 0.4
         * @playerversion POSIX +
         * @langversion 3.0
         */
        public function CliTracker( trackingId:String = "",
                                    config:Configuration = null,
                                    verbose:Boolean = false,
                                    debug:Boolean = false,
                                    senderErrorChecking:Boolean = false )
        {
            super( trackingId, config, verbose, debug, senderErrorChecking );
        }
        
        /**
         * @private
         * 
         * A storage mecanism based on the File System
         * to save and/or restore the ClientId.
         * 
         * @see http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap08.html Environment Variables
         */
        protected override function _getClientID():String
        {
            
            /* Note:
               homeDirectory do special checks to really find the home directory
               eg. if getenv( "HOME" ) is empty
               it will then fetch the user login and check in different folders
               like /var/users/login, etc.
               
               see https://github.com/Corsaair/redtamarin/blob/master/src/as3/shell/FileSystem.as
            */
            var homedir:String = FileSystem.homeDirectory;
            
            if( homedir == "" )
            {
                homedir = "/"; // root dir
                if( _verbose )
                {
                    trace( "WARNING: use ROOT directory as HOME directory \"" + homedir + "\"" );
                }
            }
            
            var exists:int = access( homedir, F_OK );
            if( exists < 0 )
            {
                var created:int = mkdir( homedir );
                if( created < 0 )
                {
                    if( _verbose )
                    {
                        trace( "WARNING: Could not create HOME directory \"" + homedir + "\"" );
                    }
                    
                    if( config.enableErrorChecking )
                    {
                        throw new CError( errno );
                    }
                    
                    return super._getClientID();
                }
            }
            
            var canread:int = access( homedir, R_OK );
            if( canread < 0 )
            {
                if( _verbose )
                {
                    trace( "WARNING: Can not read from HOME directory \"" + homedir + "\"" );
                }
                
                if( config.enableErrorChecking )
                {
                    throw new CError( errno );
                }
            }
            
            var canwrite:int = access( homedir, W_OK );
            if( canwrite < 0 )
            {
                if( _verbose )
                {
                    trace( "WARNING: Can not write to HOME directory \"" + homedir + "\"" );
                }
                
                if( config.enableErrorChecking )
                {
                    throw new CError( errno );
                }
            }
            
            // by that point we are sure the HOME directory exists and is readable/writable
            // for ex: /home/username
            
            var savepath:String = homedir + "/.uanalytics";
            var s_exists:int = access( savepath, F_OK );
            if( s_exists < 0 )
            {
                var s_created:int = mkdir( savepath );
                if( created < 0 )
                {
                    if( _verbose )
                    {
                        trace( "WARNING: Could not create save directory \"" + savepath + "\"" );
                    }
                    
                    if( config.enableErrorChecking )
                    {
                        throw new CError( errno );
                    }
                    
                    return super._getClientID();
                }
            }
            
            // by that point we are sure our preference dir .uanalytics exists
            // for ex: /home/username/.uanalytics
            
            var filepath:String = savepath + "/" + _config.storageName;
            var cid:String = "";
            
            var f_exists:int = access( filepath, F_OK );
            if( f_exists < 0 )
            {
                // the save file does not exists yet
                cid = generateCLIUUID();
                FileSystem.write( filepath, cid ); //we save the UUID
                return cid;
            }
            else
            {
                // the save file already exists
                var data:String = FileSystem.read( filepath );
                if( data != "" )
                {
                    cid = data;
                }
                else
                {
                    var newid:String = generateCLIUUID();
                    FileSystem.write( filepath, newid ); //we save
                    cid = newid;
                }
            }
            
            // somehow something went wrong and no clientId were found
            if( cid == "" )
            {
                cid = super._getClientID();
            }
            
            return cid;
        }
    }
}