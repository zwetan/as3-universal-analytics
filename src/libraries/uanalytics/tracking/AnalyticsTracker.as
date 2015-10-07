/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package libraries.uanalytics.tracking
{
    import flash.utils.Dictionary;

    /**
     * The contract of a Google Analytics tracker.
     * 
     * <p>
     * The strict minimum of what a tracker need to implement:
     * </p>
     * <ul>
     *   <li>a Tracking ID property</li>
     *   <li>a Client ID property</li>
     *   <li>the generic send() method, which can send any types of hit requests.</li>
     *   <li>the pageview() method, which send hits for page tracking</li>
     *   <li>the screenview() method, which send hits for screen tracking</li>
     *   <li>the event() method, which send hits for event tracking</li>
     *   <li>the transaction() method, which send hits for e-commerce transaction tracking</li>
     *   <li>the item() method, which send hits for e-commerce item tracking</li>
     *   <li>the social() method, which send hits for social interaction tracking</li>
     *   <li>the exception() method, which send hits for exception tracking</li>
     *   <li>the timing() method, which send hits for user timing tracking</li>
     * </ul>
     * 
     * @playerversion Flash 11
     * @playerversion AIR 3.0
     * @playerversion AVM 0.4
     * @langversion 3.0
     * 
     * @see libraries.uanalytics.tracker.DefaultTracker DefaultTracker
     * @see libraries.uanalytics.tracker.WebTracker WebTracker
     * @see libraries.uanalytics.tracker.AppTracker AppTracker
     * @see libraries.uanalytics.tracker.CliTracker CliTracker
     */
    public interface AnalyticsTracker
    {
        
        /**
         * The Tracking ID / Web Property ID.
         * 
         * <p>
         * The format is UA-XXXX-Y.
         * All collected data is associated by this ID.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        function get trackingId():String;
        
        /**
         * The Client ID anonymously identifies a particular user,
         * device, or browser instance.
         * 
         * <p>
         * For the web, this is generally stored as a first-party cookie with
         * a two-year expiration.
         * For mobile apps, this is randomly generated for each particular
         * instance of an application install.
         * The value of this field should be a random UUID (version 4)
         * as described in <a href="http://www.ietf.org/rfc/rfc4122.txt">rfc4122</a>.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        function get clientId():String;
        
        /**
         * The tracking configuration.
         * 
         * <p>
         * The configuration is applied for each hits, if you change properties
         * between hits, it will affect the way hits are processed.
         * </p>
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        function get config():Configuration;
        
        /**
         * Send the hit to Google Analytics servers.
         * 
         * @example Usage
         * <listing>
         * </listing>
         * 
         * @param hitType the hit type to send, e.g. "pageview" or "event".
         * @param tempValues a map of field and value pairs to be sent with
         *                   the hit that override current data model setting.
         * @return false if the hit has not been sent due to sampling
         *         or other reasons.
         * 
         * @throws IOError if there is an error sending the hit.
         * @throws RateLimitError if hits are being sent too quickly in succession.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        function send( hitType:String = null, tempValues:Dictionary = null ):Boolean;
        
        /**
         * Send a pageview hit.
         * 
         * <p>
         * Page tracking allows you to measure the number of views you had for a
         * particular page on your website.
         * </p>
         * 
         * <p>
         * Pages often correspond to an an entire HTML document, but they can
         * also represent dynamically loaded content;
         * this is known as "virtual pageviews".
         * </p>
         * 
         * @example Usage
         * <listing>
         * tracker.pageview( "/hello/world", "Hello World" );
         * </listing>
         * 
         * @param path the page / document path
         * @param title the page / document title
         * 
         * @return false if the hit has not been sent due to sampling
         *         or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        function pageview( path:String, title:String = "" ):Boolean;
        
        /**
         * Send a screenview hit.
         * 
         * <p>
         * Screens in Google Analytics represent content users are viewing
         * within your app.
         * The equivalent concept in web analytics is a pageview.
         * </p>
         * 
         * <p>
         * Measuring screen views allows you to see which content is being
         * viewed most by your users, and how they are navigating between
         * different pieces of content.
         * </p>
         * 
         * @example Usage
         * <listing>
         * tracker.screenview( "High Scores" );
         * </listing>
         * 
         * @param name the screen name
         * @param appinfo additional <code>ApplicationInfo</code> (optional)
         * 
         * @return false if the hit has not been sent due to sampling
         *         or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        function screenview( name:String, appinfo:Dictionary = null ):Boolean;
        
        /**
         * Send an event hit.
         * 
         * <p>
         * Events are user interactions with content that can be tracked
         * independently from a web page or a screen load.
         * </p>
         * 
         * <p>
         * Downloads, mobile ad clicks, gadgets, Flash elements, AJAX embedded
         * elements, and video plays are all examples of actions you might want
         * to track as Events.
         * </p>
         * 
         * @example Usage
         * <listing>
         * tracker.event( "Videos", "play", "Big Buck Bunny" );
         * </listing>
         * 
         * @param category the event category.
         *                 Must not be empty.
         * @param action   the event action.
         *                 Must not be empty.
         * @param label    the event label (optional).
         * @param value    the event value (optional).
         *                 Values must be non-negative.
         * 
         * @return false if the hit has not been sent due to sampling
         *         or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see http://support.google.com/analytics/answer/1033068 About Events
         */
        function event( category:String, action:String,
                        label:String = "", value:int = -1 ):Boolean;
        
        /**
         * Send a transaction hit.
         * 
         * <p>
         * Ecommerce tracking allows you to measure the number of transactions
         * and revenue that your website generates.
         * </p>
         * 
         * <p>
         * A transaction represents the entire transaction that occurs on your
         * site.
         * </p>
         * 
         * @example Usage
         * <listing>
         * tracker.transaction( "1234", "Acme Clothing", 11.99, 5, 1.29, "EUR" );
         * </listing>
         * 
         * @param id          The transaction ID.
         * @param affiliation The store or affiliation
         *                    from which this transaction occurred.
         * @param revenue     Specifies the total revenue or grand total
         *                    associated with the transaction.
         * @param shipping    Specifies the total shipping cost
         *                    of the transaction.
         * @param tax         Specifies the total tax of the transaction.
         * @param currency    When present indicates the local currency for
         *                    all transaction currency values.
         * 
         * @return false if the hit has not been sent due to sampling
         *         or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see http://support.google.com/analytics/answer/6205902#supported-currencies Currency Codes Reference
         */
        function transaction( id:String,
                              affiliation:String = "",
                              revenue:Number = 0,
                              shipping:Number = 0,
                              tax:Number = 0,
                              currency:String = "" ):Boolean;
        
        /**
         * Send an item hit.
         * 
         * <p>
         * An item represents the individual products that were in the shopping
         * cart.
         * </p>
         * 
         * @example Usage
         * <listing>
         * tracker.item( "1234", "Fluffy Pink Bunnies", 11.99, 1, "DD23444", "Party Toys" );
         * </listing>
         * 
         * @param transactionId The transaction ID.
         *                      This ID is what links items to the transactions
         *                      to which they belong.
         * @param name          The item name.
         * @param price         The individual, unit, price for each item. 
         * @param quantity      The number of units purchased in the transaction.
         * @param code          Specifies the SKU or item code.
         * @param category      The category to which the item belongs.
         * @param currency
         * 
         * @return false if the hit has not been sent due to sampling
         *         or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see http://en.wikipedia.org/wiki/Stock_keeping_unit SKU
         */
        function item( transactionId:String, name:String,
                       price:Number = 0,
                       quantity:int = 0,
                       code:String = "",
                       category:String = "",
                       currency:String = "" ):Boolean;
        
        /**
         * Send a social hit.
         * 
         * <p>
         * Social interaction measurement allows you to measure a user's
         * interactions with various social network sharing and recommendation
         * widgets embedded in your content.
         * </p>
         * 
         * <p>
         * While event tracking measures general user-interactions very well,
         * Social Analytics provides a consistent framework for recording social
         * interactions.
         * This in turn provides a consistent set of reports to compare social
         * network interactions across multiple networks.
         * </p>
         * 
         * @example Usage
         * <listing>
         * tracker.social( "Facebook", "Like", "Http://as3lang.org" );
         * </listing>
         * 
         * @param network The social network with which the user is interacting.
         * @param action  The social action taken.
         * @param target  The content on which the social action is being taken.
         * 
         * @return false if the hit has not been sent due to sampling
         *         or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         * 
         * @see http://support.google.com/analytics/answer/6209874 About Social plugins and interactions
         */
        function social( network:String, action:String, target:String ):Boolean;
        
        /**
         * Send an exception hit.
         * 
         * <p>
         * Exception tracking allows you to measure the number and type of
         * crashes or errors that occur on your property.
         * </p>
         * 
         * @example Usage
         * <listing>
         * try
         * {
         *     //an error is thrown here
         * }
         * catch( e:Error )
         * {
         *     tracker.exception( e.message, false );
         * }
         * </listing>
         * 
         * @param description A description of the exception.
         * @param isFatal     <code>true</code> if the exception was fatal.
         * 
         * @return false if the hit has not been sent due to sampling
         *         or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        function exception( description:String = "",
                            isFatal:Boolean = true ):Boolean;
        
        /**
         * Send a timing hit.
         * 
         * <p>
         * Allows to measure periods of time, particularly useful for developers
         * to measure the latency, or time spent, executing a particular action.
         * </p>
         * 
         * <p>
         * Google Analytics has a number of powerful reports that automatically
         * measure and report on page load times.
         * However, it is also possible to track custom timing information to
         * measure performance specific to your site.
         * </p>
         * 
         * @example Usage
         * <listing>
         * // in a Flash/AIR app it took 100ms to load a PNG image
         * tracker.timing( "timing", "imageloader", 100, "poster.png" );
         * </listing>
         * 
         * <listing>
         * // client-side, it took 300ms to receive the response
         * tracker.timing( "client", "REST", 300, "GET /api/version" );
         * 
         * // server-side, it took 100ms to proces the request
         * tracker.timing( "server", "REST", 100, "GET /api/version" ); 
         * </listing>
         * 
         * @param category   the user timing category
         *                   for categorizing all user timing variables into
         *                   logical groups
         * @param name       the user timing variable
         *                   to identify the variable being recorded
         * @param value      the user timing value,
         *                   the number of milliseconds in elapsed time
         *                   to report to Google Analytics
         * @param label      the user timing label (optional),
         *                   can be used to add flexibility in visualizing
         *                   user timings in the reports
         * @param timinginfo additional <code>TimingInfo</code> (optional)
         * 
         * @return false if the hit has not been sent due to sampling
         *         or other reasons.
         * 
         * @playerversion Flash 11
         * @playerversion AIR 3.0
         * @playerversion AVM 0.4
         * @langversion 3.0
         */
        function timing( category:String, name:String, value:int,
                         label:String = "",
                         timinginfo:Dictionary = null ):Boolean;
        

        
        
    }
}