/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracker.addons
{
    import libraries.uanalytics.tracking.AnalyticsTracker;
    
    /**
     * Helper class to send Twitter social hits.
     * 
     * <p>
     * To integrate with a Twitter API.
     * </p>
     * 
     * @example Usage
     * <listing>
     * var tracker:AppTracker = new AppTracker( "UA-12345-67" );
     * var twitter:Twitter = new Twitter( tracker );
     * 
     * //...
     * 
     * private function onClick( event:MouseEvent ):void
     * {
     *     var sent:Boolean = twitter.retweet( this.url );
     *     trace( "your retweet has been tracked" );
     * }
     * </listing>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     */
    public class Twitter
    {
    
        /**
         * The Twitter network definition.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const NETWORK:String = "Twitter";


        /**
         * The Click action.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */        
        public static const CLICK:String   = "Click";
        
        /**
         * The Tweet action.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const TWEET:String   = "Tweet";
        
        /**
         * The Retweet action.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const RETWEET:String = "Retweet";
        
        /**
         * The Star action.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const STAR:String    = "Star";
        
        /**
         * The Follow action.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public static const FOLLOW:String  = "Follow";
        
        
        private var _tracker:AnalyticsTracker;
        
        /**
         * Create a Twitter social hits helper.
         * 
         * @param tracker the tracker that will send the social hits.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function Twitter( tracker:AnalyticsTracker )
        {
            super();
            _tracker = tracker;
        }
        
        /**
         * The action to click on a Twitter button.
         * 
         * <p>
         * Some example of buttons: Tweet, Follow, hashtag, Mention, etc.
         * </p>
         * 
         * @param target the target of the social interaction.
         * @return false if the social hit has not been sent due to sampling
         * or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function click( target:String ):Boolean
        {
            return _tracker.social( NETWORK, CLICK, target );
        }
        
        /**
         * The action of publishing a tweet.
         * 
         * @param target the target of the social interaction.
         * @return false if the social hit has not been sent due to sampling
         * or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function tweet( target:String ):Boolean
        {
            return _tracker.social( NETWORK, TWEET, target );
        }
        
        /**
         * The action to retweet a tweet.
         * 
         * @param target the target of the social interaction.
         * @return false if the social hit has not been sent due to sampling
         * or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function retweet( target:String ):Boolean
        {
            return _tracker.social( NETWORK, RETWEET, target );
        }
        
        /**
         * The action to favorite a tweet.
         * 
         * @param target the target of the social interaction.
         * @return false if the social hit has not been sent due to sampling
         * or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function star( target:String ):Boolean
        {
            return _tracker.social( NETWORK, STAR, target );
        }
        
        /**
         * The action to follow a twitter user.
         * 
         * @param target the target of the social interaction.
         * @return false if the social hit has not been sent due to sampling
         * or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        public function follow( target:String ):Boolean
        {
            return _tracker.social( NETWORK, FOLLOW, target );
        }
        
    }
}