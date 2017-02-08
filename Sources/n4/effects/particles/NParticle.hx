package n4.effects.particles;

import kha.Color;
import n4.entities.NSprite;

class NParticle extends NSprite {

	public var life:Float;
	public var age:Float = 0;
	public var particleColor:Color;

	public function new(X:Float = 0, Y:Float = 0, PColor:Color, Life:Float = 0) {
		super(X, Y);

		life = Life;
		particleColor = PColor;
	}

	public override function update(dt:Float) {
		age += dt;

		if (age >= life) {
			destroy();
		} else {
			var alpha = 1 - (age / life);
			color = Color.fromFloats(particleColor.R, particleColor.G, particleColor.B, alpha);
		}

		super.update(dt);
	}
}