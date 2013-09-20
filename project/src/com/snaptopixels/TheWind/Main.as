package com.snaptopixels.TheWind
{
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	[SWF(width="2048", height="1536", frameRate="60", backgroundColor="#000000")]
	public class Main extends Sprite
	{
		[Embed(source="/../bin/Default-Landscape.png")]
		private static var Background : Class;
		[Embed(source="/../bin/Default-Landscape@2x.png")]
		private static var BackgroundHD : Class;
		
		private var mStarling : Starling;

		public function Main()
		{
			var stageWidth : int = 2048;
			var stageHeight : int = 1536;
			var iOS : Boolean = Capabilities.manufacturer.indexOf( "iOS" ) != -1;

			Starling.multitouchEnabled = true;
			Starling.handleLostContext = false;

			var viewPort : Rectangle = RectangleUtil.fit( new Rectangle( 0, 0, stageWidth, stageHeight ), new Rectangle( 0, 0, stage.fullScreenWidth, stage.fullScreenHeight ), ScaleMode.SHOW_ALL, iOS );

			var scaleFactor : int = 1;
			var appDir : File = File.applicationDirectory;
			var assets : AssetManager = new AssetManager( scaleFactor );

			assets.verbose = Capabilities.isDebugger;
			assets.enqueue( appDir.resolvePath( "assets" ) );

			var backgroundClass : Class = BackgroundHD;
			var background : Bitmap = new backgroundClass();
			Background = BackgroundHD = null;

			background.x = viewPort.x;
			background.y = viewPort.y;
			background.width = viewPort.width;
			background.height = viewPort.height;
			background.smoothing = true;
			addChild( background );

			mStarling = new Starling( StartUp, stage, viewPort );
			mStarling.stage.stageWidth = stageWidth;
			mStarling.stage.stageHeight = stageHeight;
			
			mStarling.simulateMultitouch = false;
			mStarling.enableErrorChecking = Capabilities.isDebugger;
			mStarling.showStats = Capabilities.isDebugger;
			mStarling.showStatsAt("left", "top", 2);

			mStarling.addEventListener( starling.events.Event.ROOT_CREATED, function() : void
			{
				removeChild( background );
				background = null;

				var game : StartUp = mStarling.root as StartUp;
				var bgTexture : Texture = Texture.fromEmbeddedAsset( backgroundClass, false, false, scaleFactor );
				game.start( bgTexture, assets );
				mStarling.start();
			} );

			NativeApplication.nativeApplication.addEventListener( flash.events.Event.ACTIVATE, function( e : * ) : void
			{
				mStarling.start();
			} );

			NativeApplication.nativeApplication.addEventListener( flash.events.Event.DEACTIVATE, function( e : * ) : void
			{
				mStarling.stop();
			} );
		}
	}
}