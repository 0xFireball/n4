package n4.effects.particles;

import kha.Color;
import n4.group.NTypedGroup;
import n4.math.NPoint;

class NParticleEmitter extends NTypedGroup<NParticle> {
	public function new(MaxSize:Int = 40) {
		super(MaxSize);
	}

	public function emitSquare(X:Float, Y:Float, Size:Int, Velocity:NPoint, PColor:Color, Life:Float = 0) {
		X -= Size / 2;
		Y -= Size / 2;
		var particle = new NParticle(X, Y, PColor, Life);
		particle.makeGraphic(Size, Size, PColor);
		particle.velocity.x = Velocity.x;
		particle.velocity.y = Velocity.y;
		add(particle);
	}

	public static function velocitySpread(Radius:Float, XOffset:Float = 0, YOffset:Float = 0):NPoint {
		var theta = Math.random() * Math.PI * 2;
		var u = Math.random() + Math.random();
		var r = Radius * (u > 1 ? 2 - u : u);
		return new NPoint(Math.cos(theta) * r + XOffset, Math.sin(theta) * r + YOffset);
	}
}