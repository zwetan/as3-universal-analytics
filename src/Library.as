/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package
{
    import flash.display.Sprite;
    
    /**
     * The basic framework Library to be included in the SWC.
     * 
     * <p>
     * <b>Note:</b> This class is not a component, it is just
     * a shim that allow to declare the SWC manifest and associate an icon file.
     * </p>
     */
    [ExcludeClass]
    [IconFile("uanalytics.png")]
    public class Library extends Sprite
    {
        public function Library()
        {
            super();
        }
    }
}