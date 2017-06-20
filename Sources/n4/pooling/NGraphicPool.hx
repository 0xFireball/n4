package n4.pooling;

import kha.Color;
import n4.assets.NGraphic;

class NGraphicPool {
	public static var items:Map<String, NGraphic> = new Map<String, NGraphic>();

	// RenderGraphic pooling

	private static inline function hashR(Width:Int, Height:Int, Key:String) {
		return Width + Height + Key + "R";
	}

	public static function putR(Width:Int, Height:Int, Key:String, Graphic:NGraphic) {
		var h = hashR(Width, Height, Key);
		items[h] = Graphic;
	}

	public static function getR(Width:Int, Height:Int, Key:String):NGraphic {
		var h = hashR(Width, Height, Key);
		return items[h];
	}
}