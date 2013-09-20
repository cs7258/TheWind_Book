package com.snaptopixels.utils
{
	import starling.display.Quad;
//	import com.iomedia.baxter.common.Assets;
//	import com.iomedia.baxter.model.Vo;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;



	/** Dispatched when the user triggers the button. Bubbles. */
	[Event(name="triggered", type="starling.events.Event")]
	
	public class InvisibleButton extends DisplayObjectContainer
	{
		private static const MAX_DRAG_DIST : Number = 50;
		private var mContents : Sprite;
		private var tagContents : Sprite;
		private var mTextBounds : Rectangle;
		private var mEnabled : Boolean;
		private var mIsDown : Boolean;
		private var mUseHandCursor : Boolean;
		private var displayTheButton : Boolean;
		
		public var id : String;
		public var _name : String;

		public function InvisibleButton( _width : int = 25, _height : int = 25, _displayTheButton : Boolean = false, _id : String = "InvisibleButton" )
		{
			// I still need to implement the direction parameter
			var quadCover : Quad = new Quad( 1, 1, 0xFF0000 );
			displayTheButton = _displayTheButton;
			id = _id;
			mEnabled = true;
			mIsDown = false;
			mUseHandCursor = true;
			mContents = new Sprite();
			tagContents = new Sprite();
			mContents.addChild( tagContents );
			tagContents.addChild( quadCover );
			quadCover.width = _width;
			quadCover.height = _height;
			if(displayTheButton)
			{
				quadCover.alpha = .8;
			}
			else
			{
				quadCover.alpha = 0;
			}
			addChild( mContents );
			addEventListener( TouchEvent.TOUCH, onTouch );

			mTextBounds = new Rectangle( 0, 0, mContents.width, mContents.height );
		}

		private function resetContents() : void
		{
			mIsDown = false;
			mContents.x = mContents.y = 0;
			mContents.scaleX = mContents.scaleY = 1.0;
		}

		private function onTouch( event : TouchEvent ) : void
		{
			Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith( this )) ? MouseCursor.BUTTON : MouseCursor.AUTO;

			var touch : Touch = event.getTouch( this );
			if (!mEnabled || touch == null) return;

			if (touch.phase == TouchPhase.BEGAN && !mIsDown)
			{
				mIsDown = true;
			}
			else if (touch.phase == TouchPhase.MOVED && mIsDown)
			{
				// reset button when user dragged too far away after pushing
				var buttonRect : Rectangle = getBounds( stage );
				if (touch.globalX < buttonRect.x - MAX_DRAG_DIST || 
					touch.globalY < buttonRect.y - MAX_DRAG_DIST || 
					touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST || touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
				{
					resetContents();
				}
			}
			else if (touch.phase == TouchPhase.ENDED && mIsDown)
			{
				resetContents();
				dispatchEventWith( Event.TRIGGERED, true ); // this is for Starling 1.2
			}
		}

		/** Indicates if the button can be triggered. */
		public function get enabled():Boolean { return mEnabled; }
        public function set enabled(value:Boolean):void
        {
            if (mEnabled != value)
            {
                mEnabled = value;
                resetContents();
            }
        }
		
	}
}
