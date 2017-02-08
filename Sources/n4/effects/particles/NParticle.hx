package n4.effects.particles;

import kha.Color;
import n4.entities.NSprite;

class NParticle extends NSprite {

	public var life(default, null):Float;
	public var age(default, null):Float = 0;

	private var _col:Color;

	public function new(X:Float = 0, Y:Float = 0, PColor:Color, Life:Float = 0) {
		super(X, Y);

		life = Life;
		_col = PColor;
	}

	public override function update(dt:Float) {
		age += dt;

		if (age >= life) {
			destroy();
		} else {
			var alpha = 1 - (age / life);
			color = Color.fromFloats(_col.R, _col.G, _col.B, alpha);
		}

		super.update(dt);
	}
}