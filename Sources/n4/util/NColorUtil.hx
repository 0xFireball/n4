package n4.util;

import kha.Color;

class NColorUtil {
	public static function randCol(R:Float, G:Float, B:Float, Variation:Float = 0.2):Color {
		var colDiff = Math.random() * Variation * 2 - Variation;
		return Color.fromFloats(R + colDiff, G + colDiff, B + colDiff);
	}
}