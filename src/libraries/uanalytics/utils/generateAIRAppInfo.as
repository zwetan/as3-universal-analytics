package libraries.uanalytics.utils
{
    import flash.desktop.NativeApplication;
    import flash.system.Capabilities;
    
    import libraries.uanalytics.tracker.ApplicationInfo;

    /**
     * Utility function to gather automatically the <code>ApplicationInfo</code>
     * from the AIR application descriptor.
     * 
     * @param installerID     provide a string for the installer id (optional).
     * @param useVersionLabel option flag to use the version label
     *                        over the version number (default to <code>true</code>).
     * 
     * @playerversion AIR 3.0
     * @langversion 3.0
     * 
     * @see http://help.adobe.com/en_US/air/build/WS5b3ccc516d4fbf351e63e3d118666ade46-7ff1.html AIR application descriptor files
     * @see http://help.adobe.com/en_US/air/build/WSD079A3A2-1B38-4543-A792-06594E4325FE.html Localizing the application name and description in the AIR application installer
     * @see http://blog.dannypatterson.com/2010/03/namespaces-on-attributes-with-e4x-in-actionscript-3/ Namespaces on Attributes with E4X in ActionScript 3
     */
    public function generateAIRAppInfo( installerID:String = "",
                                        useVersionLabel:Boolean = true ):ApplicationInfo
    {
        var appinfo:ApplicationInfo = new ApplicationInfo();
        
        var na:NativeApplication = NativeApplication.nativeApplication;
        var app_name:String    = "";
        var app_id:String      = "";
        var app_version:String = "";
        
        if( na )
        {
            var descriptor:XML = na.applicationDescriptor;
            
            // we get the default namespace, eg. <application xmlns=
            var ns:Namespace = descriptor.namespace();
            
            /* Note:
               don't see that in AS3 everyday right ?
               it simply make a namespace default
               so instead of using
               descriptor.ns::name[0]
               we can simply use
               descriptor.name[0]
            */
            default xml namespace = ns;
            
            //name
            if( descriptor.name.hasComplexContent() )
            {
                /* Note:
                   some elements of an AIR app descriptor can define multiple languages
                   eg.
                    <name> 
                        <text xml:lang="en">Sample 1.0</text> 
                        <text xml:lang="fr">Échantillon 1.0</text> 
                        <text xml:lang="de">Stichprobe 1.0</text> 
                    </name>
                   
                   see:
                   Localizing the application name and description in the AIR application installer
                   http://help.adobe.com/en_US/air/build/WSD079A3A2-1B38-4543-A792-06594E4325FE.html
                */
                
                // first we use the default system language
                var lang:String = Capabilities.language;
                
                /* Note:
                   the peculiarities of the xml:lang
                   
                   even if your node is defined like that
                   <text xml:lang="en">Sample 1.0</text>
                   
                   the xml namespace autoresolve to "http://www.w3.org/XML/1998/namespace"
                   and if you were to test it with
                   trace( descriptor.toXMLString() );
                   you would see
                   <text aaa:lang="en" xmlns:aaa="http://www.w3.org/XML/1998/namespace">Sample 1.0</text>
                   
                   WAT? aaa:lang and not xml:lang ?
                   yes "xml" is a namespace, but the root XML node does not define it
                   and so for any namespace reference not resolved the naming starts
                   with aaa, then aab, then aac, etc.
                   
                   we could force the namespace reference to be found with
                   var xml:Namespace = new Namespace("xml", "http://www.w3.org/XML/1998/namespace");
                   descriptor.addNamespace(xml);
                   trace( descriptor.toXMLString() );
                   
                   you will then see
                   <application
                     xmlns="http://ns.adobe.com/air/application/18.0"
                     xmlns:xml="http://www.w3.org/XML/1998/namespace">
                */
                
                namespace xml = "http://www.w3.org/XML/1998/namespace";
                
                // alternative
                //var xml:Namespace = new Namespace("xml", "http://www.w3.org/XML/1998/namespace");
                //descriptor.addNamespace(xml);
                //trace( descriptor.toXMLString() );
                
                app_name = descriptor.name.text.(@xml::lang == lang);
                
                // fall back to "en" if the app name for the default language is not found
                if( (app_name == "") && (lang != "en") )
                {
                    //app_name = descriptor.name.text.(@w3xml::lang == "en");
                    app_name = descriptor.name.text.(@xml::lang == "en");
                }
            }
            else
            {
                /* Note:
                   simple case without multiple languages
                   eg.
                    <name>My App</name>
                */
                app_name = descriptor.name;
            }
            
            //id
            app_id = descriptor.id;
            
            //version
            if( useVersionLabel )
            {
                // by default use the version label if allowed
                app_version = descriptor.versionLabel;
            }
            
            if( app_version == "" )
            {
                // fall back to the version number
                app_version = descriptor.versionNumber;
            }
        }
                
        if( app_name != "" )
        {
            appinfo.name = app_name;
        }
        
        if( app_id != "" )
        {
            appinfo.ID = app_id;
        }
        
        if( app_version != "" )
        {
            appinfo.version = app_version;
        }
        
        if( installerID != "" )
        {
            appinfo.installerID = installerID;
        }
        
        return appinfo;
    }
}