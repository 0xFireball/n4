package n4.tile;

import n4.assets.NGraphic;
import n4.assets.NGraphicAsset;

class NTileset {

	public var tileWidth:Int;
	public var tileHeight:Int;

	public var tilesetImage:NGraphic;
	
	public var tiles:Array<Int> = [];
	public var loaded:Bool = false;

	private var loadCallback:Void->Void;

	public function new(Graphic:NGraphicAsset, TileWidth:Int = 32, TileHeight:Int = 32) {
		tileWidth = TileWidth;
		tileHeight = TileHeight;

		loadTilesetImage(Graphic);
	}

	private function loadTilesetImage(asset:NGraphicAsset) {
		if (Std.is(asset, NGraphic)) {
			tilesetImageLoaded(asset);
		} else if (Std.is(asset, String)) {
			kha.Assets.loadImageFromPath(asset, true, tilesetImageLoaded);
		}
	}

	private function tilesetImageLoaded(g:NGraphic) {
		tilesetImage = g;
		// add tiles
		var horizTiles = Std.int(g.width / tileWidth);
		var vertTiles = Std.int(g.height / tileHeight);

		for (i in 0...(horizTiles * vertTiles)) {
			tiles.push(i);
		}
		loaded = true;
		loadCallback();
	}

	public function registerOnLoaded(Callback:Void->Void) {
		loadCallback = Callback;
	}
}