package n4.tile;

class NTilemapLoader {
	public static function loadTilemapFromArray(Map:Array<Int>, Tileset:NTileset):NTilemap {
		return new NTilemap(Map, Tileset);
	}
}