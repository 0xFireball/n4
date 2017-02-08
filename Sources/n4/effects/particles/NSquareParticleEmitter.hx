package n4.effects.particles;

import kha.Color;
import kha.math.FastVector2;
import n4.group.NTypedGroup;

class NSquareParticleEmitter extends NTypedGroup<NParticle> {
	public function new() {
		super();
	}

	public function emit(X:Float, Y:Float, Size:Int, Velocity:FastVector2, PColor:Color) {
		var particle = new NParticle(X, Y, PColor);
		particle.makeGraphic(Size, Size, PColor);
		particle.velocity.x = Velocity.x;
		particle.velocity.y = Velocity.y;
		add(particle);
	}

	public function velocitySpread(Radius:Float, XOffset:Float = 0, YOffset:Float = 0):FastVector2 {
		var theta = Math.random() * Math.PI * 2;
		var u = Math.random() + Math.random();
		var r = Radius * (u > 1 ? 2 - u : u);
		return new FastVector2(Math.cos(theta) * r + XOffset, Math.sin(theta) * r + YOffset);
	}
}