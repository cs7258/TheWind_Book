package com.snaptopixels.TheWind
{
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.AssetManager;

	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.snaptopixels.utils.InvisibleButton;
	import com.snaptopixels.utils.ProgressBar;
	
	public class StartUp extends Sprite
	{
		private static var sAssets : AssetManager;
		
		private var mLoadingProgress : ProgressBar;
		private var loaderContainer : Sprite = new Sprite();
		private var pagesContainer : Sprite = new Sprite();
		private var navbarContainer : Sprite = new Sprite();
		private var pagesList : List;
		
		private static var navBarYposOpen : Number = 0;
		private static var navBarYposClosed : Number;
		private static var navBarWidth : Number;
		private static var navBarHeight : Number;

		public function StartUp()
		{
			
		}
		
		public function start( background : Texture, assets : AssetManager ) : void
		{
			sAssets = assets;

			addChild( pagesContainer );
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
						createPages();
						TweenMax.to( loaderContainer, .5, { autoAlpha:0, onComplete:removeLoaderContainer } );
					}, 0.15 );
			} );
		}

		private function createNavigation() : void
		{
			var image : Image = new Image( sAssets.getTexture( "NavBar" ) );
			image.smoothing = TextureSmoothing.TRILINEAR;
			navbarContainer.addChild( image );
			navBarWidth = navbarContainer.width;
			navBarHeight = navbarContainer.height;
			navBarYposClosed = navbarContainer.y = -(navBarHeight - 55);
			navbarContainer.y = -navBarHeight;
			
			var navbarButton : InvisibleButton = new InvisibleButton( navBarWidth, navBarHeight, false );
			navbarButton.name = "navbar_button";
			navbarContainer.addChild( navbarButton );
			navbarButton.addEventListener( Event.TRIGGERED, openCloseNavBarContainer );
			
			TweenMax.to( navbarContainer, .5, { y:navBarYposOpen, ease:Quad.easeInOut, onComplete:closeNavBarContainer, onCompleteParams:[true] } );
		}
		
		private function closeNavBarContainer(firstTime:Boolean):void
		{
			TweenMax.killTweensOf( navbarContainer );
			if(firstTime)
			{
				firstTime = false;
				TweenMax.to( navbarContainer, .3, { y:navBarYposClosed, ease:Quad.easeInOut, delay: .7} );
			}
			else
			{
				TweenMax.to( navbarContainer, .3, { y:navBarYposClosed, ease:Quad.easeInOut} );
			}
		}
		
		private function openNavBarContainer():void
		{
			TweenMax.killTweensOf( navbarContainer );
			TweenMax.to( navbarContainer, .3, { y:navBarYposOpen, ease:Quad.easeInOut } );
		}
		
		private function openCloseNavBarContainer(event:Event):void
		{
			if(navbarContainer.y > navBarYposClosed )
			{
				closeNavBarContainer(false);
			}
			else
			{
				openNavBarContainer();
			}
		}
		
		private function removeLoaderContainer() : void
		{
			createNavigation();
			mLoadingProgress.removeFromParent( true );
			loaderContainer.removeFromParent( true );
			loaderContainer = mLoadingProgress = null;
		}
		
		private function createPages() : void
		{
			const collection:ListCollection = new ListCollection(
			[
				{ label: "cover", texture: sAssets.getTexture( "cover" ) },
				{ label: "page_01", texture: sAssets.getTexture( "page_01" ) },
				{ label: "page_02", texture: sAssets.getTexture( "page_02" ) },
				{ label: "page_03", texture: sAssets.getTexture( "page_03" ) },
				{ label: "page_04", texture: sAssets.getTexture( "page_04" ) },
				{ label: "page_05", texture: sAssets.getTexture( "page_05" ) },
				{ label: "page_06", texture: sAssets.getTexture( "page_06" ) },
				{ label: "page_07", texture: sAssets.getTexture( "page_07" ) },
				{ label: "page_08", texture: sAssets.getTexture( "page_08" ) },
				{ label: "page_09", texture: sAssets.getTexture( "page_09" ) },
				{ label: "page_10", texture: sAssets.getTexture( "page_10" ) },
				{ label: "page_11", texture: sAssets.getTexture( "page_11" ) },
				{ label: "page_12", texture: sAssets.getTexture( "page_12" ) },
				{ label: "page_13", texture: sAssets.getTexture( "page_13" ) },
			]);
			
			const listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.useVirtualLayout = true;
//			listLayout.manageVisibility = true;
			
			pagesList = new List();
			pagesList.dataProvider = collection;
			pagesList.layout = listLayout;
			pagesList.snapToPages = true;
			pagesList.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			pagesList.verticalScrollPolicy = List.SCROLL_POLICY_OFF;
			pagesList.itemRendererFactory = itemRendererFactory;
			pagesList.addEventListener("scrollStart", list_scrollStartHandler);
			pagesList.addEventListener("scrollComplete", list_scrollCompleteHandler);
			pagesContainer.addChild(pagesList);
			
			layout();
		}
		
		private function layout():void
		{
			pagesList.width = 2048;
			pagesList.height = 1536;
			pagesList.validate();

			checkCurrentPageIndex();
		}

		private function skipToChapterIndex(_num: int) : void
		{
			pagesList.scrollToDisplayIndex( _num, .4 );
		}

		private function checkCurrentPageIndex() : void
		{
			trace( "horizontalPageIndex :: " + pagesList.horizontalPageIndex );
			trace( "horizontalPageCount :: " + pagesList.horizontalPageCount );
		}

		private function list_scrollStartHandler( event : String ) : void
		{
			trace("// page scrolling START :: " + event);
			checkCurrentPageIndex();
		}

		private function list_scrollCompleteHandler( event : Event ) : void
		{
			trace("// page scrolling COMPLETE :: " + event);
			checkCurrentPageIndex();
		}
		
		private function itemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
//			renderer.iconSourceField = "texture";
			renderer.accessorySourceField = "texture";
			return renderer;
		}

	}
}














































