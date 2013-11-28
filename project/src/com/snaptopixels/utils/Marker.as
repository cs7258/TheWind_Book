package com.snaptopixels.utils
{
	import starling.display.Quad;
	import starling.display.Sprite;

	/**
	 * @author Retropunk
	 */
	public class Marker extends Sprite
	{
		public function Marker(_width:int, _height:int)
		{
			var quad : Quad = new Quad( _width, _height, 0x000000 );
			addChild( quad );
			quad.width = _width;
			quad.height = _height;
			quad.alpha = .3;
			quad.touchable = false;
		}
	}
}
