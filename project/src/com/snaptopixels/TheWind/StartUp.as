package com.snaptopixels.TheWind
{
	import com.greensock.easing.Back;
	import starling.display.BlendMode;
	import starling.textures.TextureSmoothing;
	import flash.utils.getQualifiedClassName;
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.snaptopixels.utils.ProgressBar;
	
	public class StartUp extends Sprite
	{
		private static var sAssets : AssetManager;
		
		private var mLoadingProgress : ProgressBar;
		private var loaderContainer : Sprite = new Sprite();
		private var pagesContainer : Sprite = new Sprite();
		private var navbarContainer : Sprite = new Sprite();
		private var navbarButtonsContainer : Sprite = new Sprite();
		private var textImageContainer : Sprite = new Sprite();
		private var textImage : Image;
		private var pagesList : List;
		private var navigationList : List;
		
		private static var navBarYposOpen : Number = 0;
		private static var navBarYposClosed : Number;
		private static var navBarWidth : Number;
		private static var navBarHeight : Number;
		private static var currentPageNumber : Number;
		private static var textImageName : String;

		public function StartUp()
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
						createPages();
						TweenMax.to( loaderContainer, .5, { autoAlpha:0, onComplete:removeLoaderContainer } );
					}, 0.15 );
			} );
		}

		private function createNavigation() : void
		{
			var image : starling.display.Quad = new starling.display.Quad( 2048, 215, 0x023954, true );
			image.alpha = .9;
			navbarContainer.addChild( image );
			
			navBarWidth = navbarContainer.width;
			navBarHeight = navbarContainer.height;
			navBarYposClosed = -navBarHeight;
			navbarContainer.y = -navBarHeight;
			
			var logo : Image = new Image( sAssets.getTexture( "NavTheWindLogo" ) );
			navbarContainer.addChild(logo);
			logo.x = 77;
			logo.y = 61;
			
			var sep1: Image = new Image( sAssets.getTexture( "NavSeperator" ) );
			navbarContainer.addChild(sep1);
			sep1.x = 353;
			sep1.y = 31;
			
			var sep2: Image = new Image( sAssets.getTexture( "NavSeperator" ) );
			navbarContainer.addChild(sep2);
			sep2.x = 1682;
			sep2.y = 31;
			
			var arrowLeft: Image = new Image( sAssets.getTexture( "NavChapterArrow" ) );
			navbarContainer.addChild(arrowLeft);
			arrowLeft.x = 416;
			arrowLeft.y = 70;
			
			var arrowRight: Image = new Image( sAssets.getTexture( "NavChapterArrow" ) );
			navbarContainer.addChild(arrowRight);

			arrowRight.scaleX = -1;
			arrowRight.x = 1630;
			arrowRight.y = 70;
			
			var navbarButton : Button = new Button();
			navbarButton.defaultSkin = new Image( sAssets.getTexture( "NavButtonUp" ) );
			navbarButton.downSkin = new Image( sAssets.getTexture( "NavButtonDown" ) );
			navbarButton.name = "navbar_button";
			navbarButton.addEventListener( Event.TRIGGERED, openCloseNavBarContainer );
			navbarContainer.addChild( navbarButton );
			navbarButton.validate();
			
			navbarButton.x = stage.stageWidth*.5 -(navbarButton.width*.5);
			navbarButton.y = navBarHeight;
			
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
			
			TweenMax.to( navbarContainer, .5, { y:navBarYposOpen, ease:com.greensock.easing.Quad.easeOut, onComplete:closeNavBarContainer, onCompleteParams:[true] } );
		}

		private function validateNavigationListLayout() : void
		{
			navigationList.width = 980;
			navigationList.height = 110;
			navigationList.validate();
			
			var marker : Marker = new Marker( 980, 110 );
			navbarContainer.addChildAt( marker, 1 );
			marker.x = navbarButtonsContainer.x;
			marker.y = navbarButtonsContainer.y;
		}
		
		private function closeNavBarContainer(firstTime:Boolean):void
		{
			TweenMax.killTweensOf( navbarContainer );
			if(firstTime)
			{
				firstTime = false;
				TweenMax.to( navbarContainer, .3, { y:navBarYposClosed, ease:com.greensock.easing.Quad.easeOut, delay: .4} );
			}
			else
			{
				TweenMax.to( navbarContainer, .3, { y:navBarYposClosed, ease:com.greensock.easing.Quad.easeOut} );
			}
		}
		
		private function openNavBarContainer():void
		{
			TweenMax.killTweensOf( navbarContainer );
			TweenMax.to( navbarContainer, .3, { y:navBarYposOpen, ease:com.greensock.easing.Quad.easeInOut } );
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
			currentPageNumber = pagesList.horizontalPageIndex;
		}

		private function list_scrollStartHandler( event : String ) : void
		{
			closeNavBarContainer(false);
			hideTextImage();
		}

		private function list_scrollCompleteHandler( event : Event ) : void
		{
			checkCurrentPageIndex();
			loadTextImage();
		}
		
		private function hideTextImage():void
		{
			TweenMax.killTweensOf( textImageContainer );
			TweenMax.to( textImageContainer, 0, {alpha:0} );
		}
		
		private function loadTextImage() : void
		{
			switch(currentPageNumber){
				case 1:
					textImageContainer.x = 1096;
					textImageContainer.y = 569;
					break;
				case 2:
					textImageContainer.x = 1096;
					textImageContainer.y = 320;
					break;
				case 3:
					textImageContainer.x = 1062;
					textImageContainer.y = 1035;
					break;
				case 4:
					textImageContainer.x = 1077;
					textImageContainer.y = 1152;
					break;
				case 5:
					textImageContainer.x = 1077;
					textImageContainer.y = 277;
					break;
				case 6:
					textImageContainer.x = 1077;
					textImageContainer.y = 311;
					break;
				case 7:
					textImageContainer.x = 1077;
					textImageContainer.y = 398;
					break;
				case 8:
					textImageContainer.x = 1077;
					textImageContainer.y = 333;
					break;
				case 9:
					textImageContainer.x = 1194;
					textImageContainer.y = 287;
					break;
				case 10:
					textImageContainer.x = 1212;
					textImageContainer.y = 419;
					break;
				case 11:
					textImageContainer.x = 1262;
					textImageContainer.y = 184;
					break;
				case 12:
					textImageContainer.x = 1080;
					textImageContainer.y = 386;
					break;
				default:
			}
			
			if (pagesList.horizontalPageIndex > 0 && pagesList.horizontalPageIndex < 13)
			{
				if (pagesList.horizontalPageIndex > 0 && pagesList.horizontalPageIndex < 10)
				{
					textImageName = "Text0" + String( pagesList.horizontalPageIndex );
				}
				else 
				if (pagesList.horizontalPageIndex >= 10)
				{
					textImageName = "Text" + String( pagesList.horizontalPageIndex );
				}
			}
			else
			{
				textImageName = "Blank";
			}
			
			trace( 'textImageName: ' + (textImageName) );

			const texture : Texture = sAssets.getTexture( textImageName );
			if (textImage)
			{
				textImage.texture.dispose();
				textImage.texture = texture;
				textImage.readjustSize();
				trace( getQualifiedClassName( this ) + " -> textImage is already created so reuse this texture" );
			}
			else
			{
				trace( getQualifiedClassName( this ) + " -> textImage created" );
				textImage = new Image( texture );
				textImageContainer.addChild( textImage );
				textImageContainer.blendMode = BlendMode.MULTIPLY;
				textImageContainer.touchable = false;
				textImage.dispose();
			}

			textImage.touchable = false;
			textImage.smoothing = TextureSmoothing.BILINEAR;
			
			textImageContainer.x += 40;
			TweenMax.to( textImageContainer, .8, {x:"-40", alpha:1, ease:com.greensock.easing.Back.easeOut, delay:.4} );
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














































