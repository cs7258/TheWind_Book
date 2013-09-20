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
		private var navbarButtonsContainer : Sprite = new Sprite();
		private var pagesList : List;
		private var navigationList : List;
		
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
			
			var navbarButton : InvisibleButton = new InvisibleButton( 160, 80, false );
			navbarButton.name = "navbar_button";
			navbarContainer.addChild( navbarButton );
			navbarButton.addEventListener( Event.TRIGGERED, openCloseNavBarContainer );
			navbarButton.x = stage.stageWidth*.5 - navbarButton.width*.5;
			navbarButton.y = 200;
			
			navbarContainer.addChild( navbarButtonsContainer );
			navbarButtonsContainer.x = 534;
			navbarButtonsContainer.y = 54;
			
			const navButtonsListCollection:ListCollection = new ListCollection(
			[
				{ label: "0", texture: sAssets.getTexture( "NavButton00" ) },
				{ label: "1", texture: sAssets.getTexture( "NavButton01" ) },
				{ label: "2", texture: sAssets.getTexture( "NavButton02" ) },
				{ label: "3", texture: sAssets.getTexture( "NavButton03" ) },
				{ label: "4", texture: sAssets.getTexture( "NavButton04" ) },
				{ label: "5", texture: sAssets.getTexture( "NavButton05" ) },
				{ label: "6", texture: sAssets.getTexture( "NavButton06" ) },
				{ label: "7", texture: sAssets.getTexture( "NavButton07" ) },
				{ label: "8", texture: sAssets.getTexture( "NavButton08" ) },
				{ label: "9", texture: sAssets.getTexture( "NavButton09" ) },
				{ label: "10", texture: sAssets.getTexture( "NavButton10" ) },
				{ label: "11", texture: sAssets.getTexture( "NavButton11" ) },
				{ label: "12", texture: sAssets.getTexture( "NavButton12" ) },
				{ label: "13", texture: sAssets.getTexture( "NavButton13" ) },
			]);
			
			const navigationListLayout:HorizontalLayout = new HorizontalLayout();
			navigationListLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			navigationListLayout.gap = 20;
			navigationListLayout.useVirtualLayout = true;
			
			navigationList = new List();
			navigationList.dataProvider = navButtonsListCollection;
			navigationList.layout = navigationListLayout;
			navigationList.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			navigationList.verticalScrollPolicy = List.SCROLL_POLICY_OFF;
			navigationList.itemRendererFactory = navListItemRendererFactory;
			navigationList.addEventListener(Event.CHANGE, skipToChapterIndex);
			navbarButtonsContainer.addChild( navigationList );
			
			validateNavigationListLayout();
			
			TweenMax.to( navbarContainer, .5, { y:navBarYposOpen, ease:Quad.easeOut, onComplete:closeNavBarContainer, onCompleteParams:[true] } );
		}

		private function validateNavigationListLayout() : void
		{
			navigationList.width = 980;
			navigationList.height = 110;
			navigationList.validate();
		}
		
		private function closeNavBarContainer(firstTime:Boolean):void
		{
			TweenMax.killTweensOf( navbarContainer );
			if(firstTime)
			{
				firstTime = false;
				TweenMax.to( navbarContainer, .3, { y:navBarYposClosed, ease:Quad.easeOut, delay: .4} );
			}
			else
			{
				TweenMax.to( navbarContainer, .3, { y:navBarYposClosed, ease:Quad.easeOut} );
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
			const pagesListCollection:ListCollection = new ListCollection(
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
			
			const pagesListLayout:HorizontalLayout = new HorizontalLayout();
			pagesListLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			pagesListLayout.useVirtualLayout = true;
			
			pagesList = new List();
			pagesList.dataProvider = pagesListCollection;
			pagesList.layout = pagesListLayout;
			pagesList.snapToPages = true;
			pagesList.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			pagesList.verticalScrollPolicy = List.SCROLL_POLICY_OFF;
			pagesList.itemRendererFactory = pagesItemRendererFactory;
			pagesList.addEventListener("scrollStart", list_scrollStartHandler);
			pagesList.addEventListener("scrollComplete", list_scrollCompleteHandler);
			pagesContainer.addChild(pagesList);
			
			validatePagesListLayout();
		}
		
		private function validatePagesListLayout():void
		{
			pagesList.width = 2048;
			pagesList.height = 1536;
			pagesList.validate();

			checkCurrentPageIndex();
		}
		
		
		private function skipToChapterIndex( event:Event ):void 
		{
			var list : List = List( event.currentTarget );
			var item : Object = list.selectedItem;
			var num : Number = Number(item.label);
			pagesList.scrollToPageIndex(num, 0, .8);
		}
		
		private function checkCurrentPageIndex() : void
		{
			trace( "page number is :: " + pagesList.horizontalPageIndex );
		}

		private function list_scrollStartHandler( event : String ) : void
		{
//			trace("// page scrolling START :: ");
			closeNavBarContainer(false);
			checkCurrentPageIndex();
		}

		private function list_scrollCompleteHandler( event : Event ) : void
		{
//			trace("// page scrolling COMPLETE :: ");
			checkCurrentPageIndex();
		}
		
		private function pagesItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
			renderer.accessorySourceField = "texture";
			return renderer;
		}
		
		private function navListItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.isQuickHitAreaEnabled = true;
			renderer.labelField = "label";
			renderer.accessorySourceField = "texture";
			return renderer;
		}

	}
}














































