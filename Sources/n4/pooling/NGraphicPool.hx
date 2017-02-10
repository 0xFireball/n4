package n4.pooling;

import kha.Color;
import n4.assets.NGraphic;

class NGraphicPool {
	public static var items:Map<String, NGraphic> = new Map<String, NGraphic>();

	private static function hash(Width:Int, Height:Int, ItemColor:Color):String {
		return Width + Height + ItemColor.value + "";
	}

	public static function put(Width:Int, Height:Int, ItemColor:Color, Graphic:NGraphic) {
		var h = hash(Width, Height, ItemColor);
		items[h] = Graphic;
	}

	public static function get(Width:Int, Height:Int, ItemColor:Color):NGraphic {
		var h = hash(Width, Height, ItemColor);
		return items[h];
	}
}