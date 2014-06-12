package
{
    import flash.display.Sprite;
    import flash.system.Capabilities;
    
    public class UniversalAnalytics extends Sprite
    {
        public function UniversalAnalytics()
        {
            trace( "as3-universal-analytics" );
            trace( "Flash " + Capabilities.version + " (debug=" + Capabilities.isDebugger + ")" );
        }
    }
}