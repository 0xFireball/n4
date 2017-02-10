package n4;

import kha.Canvas;
import kha.FastFloat;
import n4.math.NPoint;
import n4.math.NVelocityCalc;

class NEntity extends NBasic {

	/**
	 * X position of the upper left corner of this object in world space.
	 */
	public var x(default, set):FastFloat = 0;
	/**
	 * Y position of the upper left corner of this object in world space.
	 */
	public var y(default, set):FastFloat = 0;
	/**
	 * The width of this entity's hitbox. For sprites, use offset to control the hitbox position.
	 */
	@:isVar
	public var width(get, set):FastFloat;
	/**
	 * The height of this entity's hitbox. For sprites, use offset to control the hitbox position.
	 */
	@:isVar
	public var height(get, set):FastFloat;

	/**
	 * Set the angle (in radians) of a sprite to rotate it. WARNING: rotating sprites
	 * decreases their rendering performance by a factor of ~10x when using blitting!
	 */
	public var angle(default, set):Float = 0;

	/**
	 * The basic speed of this object (in pixels per second).
	 */
	public var velocity(default, null):NPoint;
	/**
	 * How fast the speed of this object is changing (in pixels per second).
	 * Useful for smooth movement and gravity.
	 */
	public var acceleration(default, null):NPoint;
	/**
	 * This isn't drag exactly, more like deceleration that is only applied
	 * when acceleration is not affecting the sprite.
	 */
	public var drag(default, null):NPoint;
	/**
	 * If you are using acceleration, you can use maxVelocity with it
	 * to cap the speed automatically (very useful!).
	 */
	public var maxVelocity(default, null):NPoint;

	/**
	 * This is how fast you want this sprite to spin (in radians per second).
	 */
	public var angularVelocity:Float = 0;
	/**
	 * How fast the spin speed should change (in radians per second).
	 */
	public var angularAcceleration:Float = 0;
	/**
	 * Like drag but for spinning.
	 */
	public var angularDrag:Float = 0;
	/**
	 * Use in conjunction with angularAcceleration for fluid spin speed control.
	 */
	public var maxAngular:Float = 10000;


	// Utilties

	/**
	 * Utility for storing health
	 */
	public var health:Float = 1;

	public var mass:Float = 1;

	public var momentum(get, null):Float;

	public function new(X:Float = 0, Y:Float = 0, Width:Float = 0, Height:Float = 0) {
		super();

		x = X;
		y = Y;
		width = Width;
		height = Height;

		init();
	}

	private function init() {
		velocity = new NPoint(0, 0);
		maxVelocity = new NPoint(10000, 10000);
		acceleration = new NPoint(0, 0);
		drag = new NPoint(0, 0);
	}

	override public function update(dt:Float):Void {
		super.update(dt);

		// motion updates
		updateMotion(dt);
	}

	private function updateMotion(dt:Float) {
		var velocityDelta = 0.5 * (NVelocityCalc.computeVelocity(angularVelocity, angularAcceleration, angularDrag, maxAngular, dt) - angularVelocity);
		angularVelocity += velocityDelta; 
		angle += angularVelocity * dt;
		angularVelocity += velocityDelta;
		
		velocityDelta = 0.5 * (NVelocityCalc.computeVelocity(velocity.x, acceleration.x, drag.x, maxVelocity.x, dt) - velocity.x);
		velocity.x += velocityDelta;
		var delta = velocity.x * dt;
		velocity.x += velocityDelta;
		x += delta;
		
		velocityDelta = 0.5 * (NVelocityCalc.computeVelocity(velocity.y, acceleration.y, drag.y, maxVelocity.y, dt) - velocity.y);
		velocity.y += velocityDelta;
		delta = velocity.y * dt;
		velocity.y += velocityDelta;
		y += delta;
	}

	override public function render(f:Canvas):Void {
		super.render(f);
	}

	private function set_x(Value:Float):Float {
		return x = Value;
	}

	private function set_y(Value:Float):Float {
		return y = Value;
	}

	private function set_angle(Value:Float):Float
	{
		return angle = Value;
	}

	private function get_width():Float {
		return width;
	}

	private function set_width(Value:Float):Float {
		return width = Value;
	}
	
	private function get_height():Float {
		return height;
	}

	private function set_height(Value:Float):Float {
		return height = Value;
	}

	private function get_momentum():Float {
		return mass * velocity.toVector().length;
	}
}