package n4.tile;

class NTile {
	public var tileIndex:Int;
	public var visible:Bool;
	public var collides:Bool;

	public function new(TileIndex:Int, Collides:Bool = true, Visible:Bool = true) {
		tileIndex = TileIndex;
		collides = Collides;
		visible = Visible;
	}
}