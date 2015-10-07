package
{
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.system.Capabilities;
    
    import libraries.uanalytics.tracker.ApplicationInfo;
    import libraries.uanalytics.tracker.DefaultTracker;
    import libraries.uanalytics.tracker.HitType;
    import libraries.uanalytics.tracker.SystemInfo;
    import libraries.uanalytics.tracker.WebTracker;
    import libraries.uanalytics.tracker.addons.DebugSharedObjectStorage;
    import libraries.uanalytics.tracker.senders.DebugHitSender;
    import libraries.uanalytics.tracker.senders.TraceHitSender;
    import libraries.uanalytics.tracker.senders.URLLoaderHitSender;
    import libraries.uanalytics.tracker.senders.URLStreamHitSender;
    import libraries.uanalytics.tracking.Configuration;
    import libraries.uanalytics.tracking.Tracker;
    import libraries.uanalytics.utils.generateAIRAppInfo;
    import libraries.uanalytics.utils.generateFlashSystemInfo;
    import libraries.uanalytics.utils.getHostname;
        
    public class UniversalAnalytics extends Sprite
    {
        public function UniversalAnalytics()
        {
            super();
            
            if( stage )
            {
                onAddedToStage();
            }
            else
            {
                addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
            }
        }
        
        private function onAddedToStage( event:Event = null ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
            main();
        }
        
        //public var tracker:DefaultTracker;
        public var tracker:WebTracker;
        
        public function main():void
        {
            trace( "as3-universal-analytics" );
            trace( "Flash " + Capabilities.version + " (debug=" + Capabilities.isDebugger + ")" );
            
            var hostname:String = getHostname();
            trace( "hostname = " + hostname );
            
            var hitType:String = "pageview";
            //var hitType:String = "foobar";
            var valid:Boolean  = HitType.isValid( hitType );
            trace( "valid = " + valid );
            
            //var trackingID:String = "UA-94526-30"; //APP
            var trackingID:String = "UA-94526-31"; //WEB
            //var trackingID:String = "UA-00-00"; //ERR
            
            var config:Configuration = new Configuration();
                //config.forcePOST = true;
                //config.forceSSL = true;
                config.enableErrorChecking = false;
                //config.anonymizeIp = true;
                //config.overrideIpAddress = "127.0.0.1";
                //config.overrideUserAgent = "as3bot/1.0";
                //config.overrideUserAgent = "Opera/9.80 (Windows NT 6.0) Presto/2.12.388 Version/12.14";
                //config.overrideGeographicalId = "US";
                
                config.senderType = "libraries.uanalytics.tracker.senders.TraceHitSender";
                //config.senderType = "libraries.uanalytics.tracker.senders.DebugHitSender";
                //config.senderType = "libraries.uanalytics.tracker.senders.URLLoaderHitSender";
                //config.senderType = "libraries.uanalytics.tracker.senders.URLStreamSender";
                
            
            var sender:TraceHitSender;
            var sender2:DebugHitSender;
            var sender3:URLLoaderHitSender;
            var sender4:URLStreamHitSender;
            
            //tracker = new DefaultTracker( trackingID, config );
            //var tracker:DefaultTracker = new DefaultTracker( trackingID, config );
            //var tracker:DefaultTracker = new DefaultTracker( trackingID );
            //var tracker:WebTracker = new WebTracker( trackingID, config );
            tracker = new WebTracker( trackingID, config );
            trace( "trackingId = " + tracker.trackingId );
            trace( "  clientId = " + tracker.clientId );
            
            var sysinfo:SystemInfo = generateFlashSystemInfo( this );
                
                //tracker.add( sysinfo.toDictionary() );
            
            var appinfo:ApplicationInfo = new ApplicationInfo();
                appinfo.name        = "My App";
                appinfo.ID          = "com.something.myapp";
                appinfo.version     = "1.0.0";
                appinfo.installerID = "Local testing";
            
                //tracker.add( appinfo.toDictionary() );
            
            //var air_appinfo:ApplicationInfo = generateAIRAppInfo();
                
                //tracker.setOneTime( Tracker.NON_INTERACTION, "1" );
            var sent:Boolean = tracker.pageview( "/my page € web1", "NI - My Page Title with € web1" );
                //tracker.set( Tracker.APP_NAME, "My App" );
            //var sent:Boolean = tracker.screenview( "My Screen €2" ); 
            
            trace( "sent = " + sent );
            
            //DebugSharedObjectStorage( false, true );
            //DebugSharedObjectStorage();
            
            var test:Sprite = new Sprite();
                test.graphics.beginFill( 0xffcc00 );
                test.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
                test.graphics.endFill();
                test.width = stage.stageWidth;
                test.height = stage.stageHeight;
            
            stage.addChild( test );
            
            test.addEventListener( MouseEvent.CLICK, onClick );
        }
        
        private function onClick( event:MouseEvent ):void
        {
            trace( "onClick()" );
            var sent:Boolean = tracker.pageview( "/my page € web1", "My Page Title with € web1" );
            trace( "sent = " + sent );
        }
        
        
    }
}