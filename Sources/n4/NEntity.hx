package n4;

import kha.Framebuffer;
import kha.math.FastVector2;
import kha.FastFloat;

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
	 * The basic speed of this object (in pixels per second).
	 */
	public var velocity(default, null):FastVector2;
	/**
	 * How fast the speed of this object is changing (in pixels per second).
	 * Useful for smooth movement and gravity.
	 */
	public var acceleration(default, null):FastVector2;
	/**
	 * This isn't drag exactly, more like deceleration that is only applied
	 * when acceleration is not affecting the sprite.
	 */
	public var drag(default, null):FastVector2;
	/**
	 * If you are using acceleration, you can use maxVelocity with it
	 * to cap the speed automatically (very useful!).
	 */
	public var maxVelocity(default, null):FastVector2;

	/**
	 * Utility for storing health
	 */
	public var health:Float = 1;

	public function new(X:Float = 0, Y:Float = 0, Width:Float = 0, Height:Float = 0) {
		super();

		x = X;
		y = Y;
		width = Width;
		height = Height;

		init();
	}

	private function init() {

	}

	override public function update(dt:Float):Void {
		super.update(dt);
	}

	override public function render(f:Framebuffer):Void {
		super.render(f);
	}

	private function set_x(Value:Float):Float {
		return x = Value;
	}

	private function set_y(Value:Float):Float {
		return y = Value;
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
}