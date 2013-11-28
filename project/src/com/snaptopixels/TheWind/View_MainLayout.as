package com.snaptopixels.TheWind
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import com.greensock.TweenMax;
	import com.snaptopixels.utils.ProgressBar;
	
	public class View_MainLayout extends Sprite
	{
		private static var sAssets : AssetManager;
		
		private var mLoadingProgress : ProgressBar;
		private var loaderContainer : Sprite = new Sprite();
		private var pagesContainer : View_Pages = new View_Pages();
		private var navbarContainer : View_Navigation = new View_Navigation();
		private var textImageContainer : View_TextContainer = new View_TextContainer();

		public function View_MainLayout()
		{
			
		}
		
		public function start( background : Texture, assets : AssetManager ) : void
		{
			sAssets = assets;

			addChild( pagesContainer );
			addChild( textImageContainer );
			addChild( loaderContainer );
			addChild( navbarContainer );

			loaderContainer.addChild( new Image( background ) );

			mLoadingProgress = new ProgressBar( 175, 20 );
			mLoadingProgress.x = (background.width - mLoadingProgress.width) / 2;
			mLoadingProgress.y = background.height * 0.7;
			loaderContainer.addChild( mLoadingProgress );

			assets.loadQueue( function( ratio : Number ) : void
			{
				mLoadingProgress.ratio = ratio;

				if (ratio == 1)
					Starling.juggler.delayCall( function() : void
					{
						pagesContainer.createPages( sAssets );
						pagesContainer.addEventListener(CustomEventType.CLOSE_THE_NAVBAR, closeNavBarContainer);
						pagesContainer.addEventListener(CustomEventType.HIDE_TEXT_IMAGE, hideTextImage);
						pagesContainer.addEventListener(CustomEventType.SHOW_TEXT_IMAGE, showTextImage);
						TweenMax.to( loaderContainer, .5, { autoAlpha:0, onComplete:startUpApp } );
					}, 0.15 );
			} );
		}
		
		private function startUpApp() : void
		{
			navbarContainer.createNavigation( sAssets );
			navbarContainer.addEventListener("SKIP_TO_CHAPTER", skipToChapter);
			mLoadingProgress.removeFromParent( true );
			loaderContainer.removeFromParent( true );
			loaderContainer = mLoadingProgress = null;
		}

		private function skipToChapter( event : String, num : Number ) : void
		{
			closeNavBarContainer();
			Constants.NEXT_PAGE_NUMBER = num;
			pagesContainer.skipToPage( Constants.NEXT_PAGE_NUMBER );
		}
		
		private function closeNavBarContainer():void
		{
			navbarContainer.closeNavBarContainer();
		}
		
		private function hideTextImage():void
		{
			textImageContainer.hideTextImage();
		}
		
		private function showTextImage() : void
		{
			textImageContainer.createTextImage(sAssets);
		}

	}
}














































