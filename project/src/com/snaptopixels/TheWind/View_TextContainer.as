package com.snaptopixels.TheWind
{
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.AssetManager;

	import com.greensock.TweenMax;
	import com.greensock.easing.Back;

	/**
	 * @author Retropunk
	 */
	public class View_TextContainer extends Sprite
	{
		public function View_TextContainer()
		{
			
		}
		
		private var textImage_Image : Image;
		private var textImage_TextureName : String;

		public function createTextImage( sAssets : AssetManager ) : void
		{
			switch(Constants.CURRENT_PAGE_NUMBER){
				case 1:
					this.x = 1096;
					this.y = 569;
					break;
				case 2:
					this.x = 1096;
					this.y = 320;
					break;
				case 3:
					this.x = 1062;
					this.y = 1035;
					break;
				case 4:
					this.x = 1077;
					this.y = 1152;
					break;
				case 5:
					this.x = 1077;
					this.y = 277;
					break;
				case 6:
					this.x = 1077;
					this.y = 311;
					break;
				case 7:
					this.x = 1077;
					this.y = 398;
					break;
				case 8:
					this.x = 1077;
					this.y = 333;
					break;
				case 9:
					this.x = 1194;
					this.y = 287;
					break;
				case 10:
					this.x = 1212;
					this.y = 419;
					break;
				case 11:
					this.x = 1262;
					this.y = 184;
					break;
				case 12:
					this.x = 1080;
					this.y = 386;
					break;
				default:
			}
			
			if (Constants.CURRENT_PAGE_NUMBER > 0 && Constants.CURRENT_PAGE_NUMBER < 13)
			{
				if (Constants.CURRENT_PAGE_NUMBER > 0 && Constants.CURRENT_PAGE_NUMBER < 10)
				{
					textImage_TextureName = "Text0" + String( Constants.CURRENT_PAGE_NUMBER );
				}
				else 
				if (Constants.CURRENT_PAGE_NUMBER >= 10)
				{
					textImage_TextureName = "Text" + String( Constants.CURRENT_PAGE_NUMBER );
				}
			}
			else
			{
				textImage_TextureName = "Blank";
			}

			const texture : Texture = sAssets.getTexture( textImage_TextureName );
			if (textImage_Image)
			{
				textImage_Image.texture.dispose();
				textImage_Image.texture = texture;
				textImage_Image.readjustSize();
			}
			else
			{
				textImage_Image = new Image( texture );
				this.addChild( textImage_Image );
				this.blendMode = BlendMode.MULTIPLY;
				this.touchable = false;
				textImage_Image.dispose();
			}

			textImage_Image.touchable = false;
			textImage_Image.smoothing = TextureSmoothing.BILINEAR;
			
			this.x += 100;
			TweenMax.to( this, .8, {x:"-100", alpha:1, ease:Back.easeOut, delay:.1} );
		}

		public function hideTextImage() : void
		{
			TweenMax.killTweensOf( this );
			TweenMax.to( this, 0, {alpha:0} );
		}
	}
}
