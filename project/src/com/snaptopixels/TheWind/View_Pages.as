package com.snaptopixels.TheWind
{
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;

	import starling.display.Sprite;
	import starling.utils.AssetManager;

	/**
	 * @author Retropunk
	 */
	public class View_Pages extends Sprite
	{
		public function View_Pages()
		{
		}
		
		private var pagesList : List;
		
		public function createPages( sAssets : AssetManager ) : void
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
			addChild(pagesList);
			
			validatePagesListLayout();
		}
		
		private function validatePagesListLayout():void
		{
			pagesList.width = 2048;
			pagesList.height = 1536;
			pagesList.validate();

			checkCurrentPageIndex();
		}
		
		private function checkCurrentPageIndex() : void
		{
			Constants.CURRENT_PAGE_NUMBER = pagesList.horizontalPageIndex;
		}
		
		private function list_scrollStartHandler( event : String ) : void
		{
			dispatchEventWith( CustomEventType.CLOSE_THE_NAVBAR );
			dispatchEventWith( CustomEventType.HIDE_TEXT_IMAGE );
		}

		private function list_scrollCompleteHandler( event : String ) : void
		{
			checkCurrentPageIndex();
			dispatchEventWith( CustomEventType.SHOW_TEXT_IMAGE );
		}
		
		private function pagesItemRendererFactory():IListItemRenderer
		{
			const renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.labelField = "label";
			renderer.accessorySourceField = "texture";
			return renderer;
		}

		public function skipToPage( num : Number ) : void
		{
			if(Constants.CURRENT_PAGE_NUMBER != num)
			{
				dispatchEventWith( CustomEventType.HIDE_TEXT_IMAGE );
				pagesList.scrollToPageIndex( num, 0, .8 );
			}
			
		}
	}
}













