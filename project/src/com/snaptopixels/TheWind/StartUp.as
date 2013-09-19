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
	import starling.utils.AssetManager;

	import com.greensock.TweenMax;
	import com.snaptopixels.utils.ProgressBar;
	
	public class StartUp extends Sprite
	{
		private static var sAssets : AssetManager;
		
		private var mLoadingProgress : ProgressBar;
		private var loaderContainer : Sprite = new Sprite();
		private var pagesContainer : Sprite = new Sprite();
		private var list : List;

		public function StartUp()
		{
			
		}
		
		public function start( background : Texture, assets : AssetManager ) : void
		{
			sAssets = assets;

			this.addChild( pagesContainer );
			this.addChild( loaderContainer );

			this.loaderContainer.addChild( new Image( background ) );

			mLoadingProgress = new ProgressBar( 175, 20 );
			mLoadingProgress.x = (background.width - mLoadingProgress.width) / 2;
			mLoadingProgress.y = background.height * 0.7;
			this.loaderContainer.addChild( mLoadingProgress );

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
		
		private function removeLoaderContainer() : void
		{
			mLoadingProgress.removeFromParent( true );
			loaderContainer.removeFromParent( true );
			loaderContainer = mLoadingProgress = null;
		}
		
		private function createPages() : void
		{
			trace("createPages");
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
			listLayout.manageVisibility = true;
			
			this.list = new List();
			this.list.dataProvider = collection;
			this.list.layout = listLayout;
			this.list.snapToPages = true;
			this.list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			this.list.verticalScrollPolicy = List.SCROLL_POLICY_OFF;
			this.list.itemRendererFactory = itemRendererFactory;
			this.list.addEventListener("scrollStart", list_scrollStartHandler);
			this.list.addEventListener("scrollComplete", list_scrollCompleteHandler);
			this.pagesContainer.addChild(this.list);
			
			this.layout();
		}
		
		private function layout():void
		{
			this.list.width = 2048;
			this.list.height = 1536;
			this.list.validate();

			checkCurrentPageIndex();
		}

		private function checkCurrentPageIndex() : void
		{
			trace( "horizontalPageIndex :: " + this.list.horizontalPageIndex );
			trace( "horizontalPageCount :: " + this.list.horizontalPageCount );
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














































