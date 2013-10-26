package com.snaptopixels.TheWind
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;

	/**
	 * @author Retropunk
	 */
	public class View_Navigation extends Sprite
	{
		public function View_Navigation()
		{
		}
		
		private var navigationList : List;
		private var navbarContainer : Sprite = new Sprite();
		private var navbarButtonsContainer : Sprite = new Sprite();
		
		private static var navBarYposOpen : Number = 0;
		private static var navBarYposClosed : Number;
		private static var navBarWidth : Number;
		private static var navBarHeight : Number;
		
		public function createNavigation(sAssets : AssetManager) : void
		{
			addChild( navbarContainer );
			
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
			
			TweenMax.to( navbarContainer, .5, { y:navBarYposOpen, ease:com.greensock.easing.Quad.easeOut, onComplete:closeNavBarContainer } );
		}
		
		private function validateNavigationListLayout() : void
		{
			navigationList.width = 980;
			navigationList.height = 110;
			navigationList.validate();
		}
		
		private function skipToChapterIndex( event : Event ) : void
		{
			var list : List = List( event.currentTarget );
			var item : Object = list.selectedItem;
			var num : Number = Number( item.label );

			dispatchEventWith( "SKIP_TO_CHAPTER", false, num );
		}
		
		public function closeNavBarContainer():void
		{
			TweenMax.killTweensOf( navbarContainer );
			TweenMax.to( navbarContainer, .3, { y:navBarYposClosed, ease:com.greensock.easing.Quad.easeOut} );
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
				closeNavBarContainer();
			}
			else
			{
				openNavBarContainer();
			}
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
























