package n4.tile;

import n4.group.NGroup;
import n4.entities.NSprite;

class NTilemap extends NGroup {

	public var tileset:NTileset;
	public var map:Array<Int>;

	public function new(Map:Array<Int>, Tileset:NTileset) {
		super();
		map = Map;
		tileset = Tileset;
		if (!tileset.loaded) {
			tileset.registerOnLoaded(onTilesetReady);
		} else {
			onTilesetReady();
		}
	}

	private function onTilesetReady() {
		// TODO
	}
}