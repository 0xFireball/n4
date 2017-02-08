package n4.effects.particles;

import kha.Color;
import n4.entities.NSprite;

class NParticle extends NSprite {

	private var _rgbColor:Int;

	public function new(X:Float = 0, Y:Float = 0, PColor:Color) {
		super(X, Y);

		_rgbColor = PColor.value & 0x00FFFFFF;
	}
}