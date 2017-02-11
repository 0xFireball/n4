package n4;

import kha.Canvas;
import kha.FastFloat;
import n4.math.NPoint;
import n4.math.NRect;
import n4.math.NVelocityCalc;
import n4.util.NAxes;

class NEntity extends NBasic {

	// Flags

	/**
	 * This value dictates the maximum number of pixels two objects have to intersect before collision stops trying to separate them.
	 * Don't modify this unless your objects are passing through eachother.
	 */
	public static var SEPARATE_BIAS:Float = 4;
	/**
	 * Generic value for "left" Used by facing, allowCollisions, and touching.
	 */
	public static inline var LEFT:Int = 0x0001;
	/**
	 * Generic value for "right" Used by facing, allowCollisions, and touching.
	 */
	public static inline var RIGHT:Int = 0x0010;
	/**
	 * Generic value for "up" Used by facing, allowCollisions, and touching.
	 */
	public static inline var UP:Int = 0x0100;
	/**
	 * Generic value for "down" Used by facing, allowCollisions, and touching.
	 */
	public static inline var DOWN:Int = 0x1000;
	/**
	 * Special-case constant meaning no collisions, used mainly by allowCollisions and touching.
	 */
	public static inline var NONE:Int = 0x0000;
	/**
	 * Special-case constant meaning up, used mainly by allowCollisions and touching.
	 */
	public static inline var CEILING:Int = UP;
	/**
	 * Special-case constant meaning down, used mainly by allowCollisions and touching.
	 */
	public static inline var FLOOR:Int = DOWN;
	/**
	 * Special-case constant meaning only the left and right sides, used mainly by allowCollisions and touching.
	 */
	public static inline var WALL:Int = LEFT | RIGHT;
	/**
	 * Special-case constant meaning any direction, used mainly by allowCollisions and touching.
	 */
	public static inline var ANY:Int = LEFT | RIGHT | UP | DOWN;

	@:noCompletion
	private static var _firstSeparateNRect:NRect = new NRect();
	@:noCompletion
	private static var _secondSeparateNRect:NRect = new NRect();

	/**
	 * Bit field of flags (use with UP, DOWN, LEFT, RIGHT, etc) indicating collision directions. Use bitwise operators to check the values stored here.
	 * Useful for things like one-way platforms (e.g. allowCollisions = UP;). The accessor "solid" just flips this variable between NONE and ANY.
	 */
	public var allowCollisions(default, set):Int = ANY;

	/**
	 * Bit field of flags (use with UP, DOWN, LEFT, RIGHT, etc) indicating surface contacts. Use bitwise operators to check the values 
	 * stored here, or use isTouching(), justTouched(), etc. You can even use them broadly as boolean values if you're feeling saucy!
	 */
	public var touching:Int = NONE;
	/**
	 * Bit field of flags (use with UP, DOWN, LEFT, RIGHT, etc) indicating surface contacts from the previous game loop step. Use bitwise operators to check the values 
	 * stored here, or use isTouching(), justTouched(), etc. You can even use them broadly as boolean values if you're feeling saucy!
	 */
	public var wasTouching:Int = NONE;

	/**
	 * Whether this sprite is dragged along with the horizontal movement of objects it collides with 
	 * (makes sense for horizontally-moving platforms in platformers for example).
	 */
	public var collisionXDrag:Bool = true;

	/**
	 * Important variable for collision processing.
	 * By default this value is set automatically during preUpdate().
	 */
	public var last(default, null):NPoint;

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
	 * Set this to false if you want to skip the automatic motion/movement stuff (see updateMotion()).
	 * NObject and NSprite default to true. NText, NTileblock and NTilemap default to false.
	 */
	public var moves(default, set):Bool = true;
	/**
	 * Whether an object will move/alter position after a collision.
	 */
	public var immovable(default, set):Bool = false;
	/**
	 * Whether the object collides or not.  For more control over what directions the object will collide from, 
	 * use collision constants (like LEFT, FLOOR, etc) to set the value of allowCollisions directly.
	 */
	public var solid(get, set):Bool;
	/**
	 * Controls how much this object is affected by camera scrolling. 0 = no movement (e.g. a background layer), 
	 * 1 = same movement speed as the foreground. Default value is (1,1), except for UI elements like NButton where it's (0,0).
	 */
	public var scrollFactor(default, null):NPoint;

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
	 * The bounciness of this object. Only affects collisions. Default value is 0, or "not bouncy at all."
	 */
	public var elasticity:Float = 0;
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
		n4Type = OBJECT;
		last = new NPoint(x, y);
		velocity = new NPoint(0, 0);
		maxVelocity = new NPoint(10000, 10000);
		acceleration = new NPoint(0, 0);
		drag = new NPoint(0, 0);
		scrollFactor = new NPoint(1, 1);
	}

	override public function update(dt:Float):Void {
		super.update(dt);

		last.x = x;
		last.y = y;

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

	/**
	 * The main collision resolution function in n4.
	 * 
	 * @param	Object1 	Any NEntity.
	 * @param	Object2		Any other NEntity.
	 * @return	Whether the objects in fact touched and were separated.
	 */
	public static function separate(Object1:NEntity, Object2:NEntity):Bool
	{
		var separatedX:Bool = separateX(Object1, Object2);
		var separatedY:Bool = separateY(Object1, Object2);
		return separatedX || separatedY;
	}

	
	
	/**
	 * Similar to "separate", but only checks whether any overlap is found and updates 
	 * the "touching" flags of the input objects, but no separation is performed.
	 * 
	 * @param	Object1		Any NEntity.
	 * @param	Object2		Any other NEntity.
	 * @return	Whether the objects in fact touched.
	 */
	public static function updateTouchingFlags(Object1:NEntity, Object2:NEntity):Bool
	{	
		var touchingX:Bool = updateTouchingFlagsX(Object1, Object2);
		var touchingY:Bool = updateTouchingFlagsY(Object1, Object2);
		return touchingX || touchingY;
	}
	
	/**
	 * Internal function that computes overlap among two objects on the X axis. It also updates the "touching" variable.
	 * "checkMaxOverlap" is used to determine whether we want to exclude (therefore check) overlaps which are
	 * greater than a certain maximum (linked to SEPARATE_BIAS). Default is true, handy for "separateX" code.
	 */
	@:noCompletion
	private static function computeOverlapX(Object1:NEntity, Object2:NEntity, checkMaxOverlap:Bool = true):Float
	{
		var overlap:Float = 0;
		//First, get the two object deltas
		var obj1delta:Float = Object1.x - Object1.last.x;
		var obj2delta:Float = Object2.x - Object2.last.x;
		
		if (obj1delta != obj2delta)
		{
			//Check if the X hulls actually overlap
			var obj1deltaAbs:Float = (obj1delta > 0) ? obj1delta : -obj1delta;
			var obj2deltaAbs:Float = (obj2delta > 0) ? obj2delta : -obj2delta;
			
			var obj1rect:NRect = _firstSeparateNRect.set(Object1.x - ((obj1delta > 0) ? obj1delta : 0), Object1.last.y, Object1.width + obj1deltaAbs, Object1.height);
			var obj2rect:NRect = _secondSeparateNRect.set(Object2.x - ((obj2delta > 0) ? obj2delta : 0), Object2.last.y, Object2.width + obj2deltaAbs, Object2.height);
			
			if ((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
			{
				var maxOverlap:Float = checkMaxOverlap ? (obj1deltaAbs + obj2deltaAbs + SEPARATE_BIAS) : 0;
				
				//If they did overlap (and can), figure out by how much and flip the corresponding flags
				if (obj1delta > obj2delta)
				{
					overlap = Object1.x + Object1.width - Object2.x;
					if ((checkMaxOverlap && (overlap > maxOverlap)) || ((Object1.allowCollisions & RIGHT) == 0) || ((Object2.allowCollisions & LEFT) == 0))
					{
						overlap = 0;
					}
					else
					{
						Object1.touching |= RIGHT;
						Object2.touching |= LEFT;
					}
				}
				else if (obj1delta < obj2delta)
				{
					overlap = Object1.x - Object2.width - Object2.x;
					if ((checkMaxOverlap && (-overlap > maxOverlap)) || ((Object1.allowCollisions & LEFT) == 0) || ((Object2.allowCollisions & RIGHT) == 0))
					{
						overlap = 0;
					}
					else
					{
						Object1.touching |= LEFT;
						Object2.touching |= RIGHT;
					}
				}
			}
		}
		return overlap;
	}
	
	/**
	 * The X-axis component of the object separation process.
	 * 
	 * @param	Object1 	Any NEntity.
	 * @param	Object2		Any other NEntity.
	 * @return	Whether the objects in fact touched and were separated along the X axis.
	 */
	public static function separateX(Object1:NEntity, Object2:NEntity):Bool
	{
		//can't separate two immovable objects
		var obj1immovable:Bool = Object1.immovable;
		var obj2immovable:Bool = Object2.immovable;
		if (obj1immovable && obj2immovable)
		{
			return false;
		}
		
		//If one of the objects is a tilemap, just pass it off.
		// if (Object1.n4Type == TILEMAP)
		// {
		// 	var tilemap:NBaseTilemap<Dynamic> = cast Object1;
		// 	return tilemap.overlapsWithCallback(Object2, separateX);
		// }
		// if (Object2.n4Type == TILEMAP)
		// {
		// 	var tilemap:NBaseTilemap<Dynamic> = cast Object2;
		// 	return tilemap.overlapsWithCallback(Object1, separateX, true);
		// }
		
		var overlap:Float = computeOverlapX(Object1, Object2);
		//Then adjust their positions and velocities accordingly (if there was any overlap)
		if (overlap != 0)
		{
			var obj1v:Float = Object1.velocity.x;
			var obj2v:Float = Object2.velocity.x;
			
			if (!obj1immovable && !obj2immovable)
			{
				overlap *= 0.5;
				Object1.x = Object1.x - overlap;
				Object2.x += overlap;
				
				var obj1velocity:Float = Math.sqrt((obj2v * obj2v * Object2.mass) / Object1.mass) * ((obj2v > 0) ? 1 : -1);
				var obj2velocity:Float = Math.sqrt((obj1v * obj1v * Object1.mass) / Object2.mass) * ((obj1v > 0) ? 1 : -1);
				var average:Float = (obj1velocity + obj2velocity) * 0.5;
				obj1velocity -= average;
				obj2velocity -= average;
				Object1.velocity.x = average + obj1velocity * Object1.elasticity;
				Object2.velocity.x = average + obj2velocity * Object2.elasticity;
			}
			else if (!obj1immovable)
			{
				Object1.x = Object1.x - overlap;
				Object1.velocity.x = obj2v - obj1v * Object1.elasticity;
			}
			else if (!obj2immovable)
			{
				Object2.x += overlap;
				Object2.velocity.x = obj1v - obj2v * Object2.elasticity;
			}
			return true;
		}

		return false;
	}
	
	/**
	 * Checking overlap and updating touching variables, X-axis part used by "updateTouchingFlags".
	 * 
	 * @param	Object1 	Any NEntity.
	 * @param	Object2		Any other NEntity.
	 * @return	Whether the objects in fact touched along the X axis.
	 */
	public static function updateTouchingFlagsX(Object1:NEntity, Object2:NEntity):Bool
	{		
		//If one of the objects is a tilemap, just pass it off.
		// if (Object1.n4Type == TILEMAP)
		// {
		// 	var tilemap:NBaseTilemap<Dynamic> = cast Object1;
		// 	return tilemap.overlapsWithCallback(Object2, updateTouchingFlagsX);
		// }
		// if (Object2.n4Type == TILEMAP)
		// {
		// 	var tilemap:NBaseTilemap<Dynamic> = cast Object2;
		// 	return tilemap.overlapsWithCallback(Object1, updateTouchingFlagsX, true);
		// }
		// Since we are not separating, always return any amount of overlap => false as last parameter
		return computeOverlapX(Object1, Object2, false) != 0;
	}
	
	/**
	 * Internal function that computes overlap among two objects on the Y axis. It also updates the "touching" variable.
	 * "checkMaxOverlap" is used to determine whether we want to exclude (therefore check) overlaps which are
	 * greater than a certain maximum (linked to SEPARATE_BIAS). Default is true, handy for "separateY" code.
	 */
	@:noCompletion
	private static function computeOverlapY(Object1:NEntity, Object2:NEntity, checkMaxOverlap:Bool = true):Float
	{
		var overlap:Float = 0;
		//First, get the two object deltas
		var obj1delta:Float = Object1.y - Object1.last.y;
		var obj2delta:Float = Object2.y - Object2.last.y;
		
		if (obj1delta != obj2delta)
		{
			//Check if the Y hulls actually overlap
			var obj1deltaAbs:Float = (obj1delta > 0) ? obj1delta : -obj1delta;
			var obj2deltaAbs:Float = (obj2delta > 0) ? obj2delta : -obj2delta;
			
			var obj1rect:NRect = _firstSeparateNRect.set(Object1.x, Object1.y - ((obj1delta > 0) ? obj1delta : 0), Object1.width, Object1.height + obj1deltaAbs);
			var obj2rect:NRect = _secondSeparateNRect.set(Object2.x, Object2.y - ((obj2delta > 0) ? obj2delta : 0), Object2.width, Object2.height + obj2deltaAbs);
			
			if ((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
			{
				var maxOverlap:Float = checkMaxOverlap ? (obj1deltaAbs + obj2deltaAbs + SEPARATE_BIAS) : 0;
				
				//If they did overlap (and can), figure out by how much and flip the corresponding flags
				if (obj1delta > obj2delta)
				{
					overlap = Object1.y + Object1.height - Object2.y;
					if ((checkMaxOverlap && (overlap > maxOverlap)) || ((Object1.allowCollisions & DOWN) == 0) || ((Object2.allowCollisions & UP) == 0))
					{
						overlap = 0;
					}
					else
					{
						Object1.touching |= DOWN;
						Object2.touching |= UP;
					}
				}
				else if (obj1delta < obj2delta)
				{
					overlap = Object1.y - Object2.height - Object2.y;
					if ((checkMaxOverlap && (-overlap > maxOverlap)) || ((Object1.allowCollisions & UP) == 0) || ((Object2.allowCollisions & DOWN) == 0))
					{
						overlap = 0;
					}
					else
					{
						Object1.touching |= UP;
						Object2.touching |= DOWN;
					}
				}
			}
		}
		return overlap;
	}
	
	/**
	 * The Y-axis component of the object separation process.
	 * 
	 * @param	Object1 	Any NEntity.
	 * @param	Object2		Any other NEntity.
	 * @return	Whether the objects in fact touched and were separated along the Y axis.
	 */
	public static function separateY(Object1:NEntity, Object2:NEntity):Bool
	{
		//can't separate two immovable objects
		var obj1immovable:Bool = Object1.immovable;
		var obj2immovable:Bool = Object2.immovable;
		if (obj1immovable && obj2immovable)
		{
			return false;
		}
		
		//If one of the objects is a tilemap, just pass it off.
		// if (Object1.n4Type == TILEMAP)
		// {
		// 	var tilemap:NBaseTilemap<Dynamic> = cast Object1;
		// 	return tilemap.overlapsWithCallback(Object2, separateY);
		// }
		// if (Object2.n4Type == TILEMAP)
		// {
		// 	var tilemap:NBaseTilemap<Dynamic> = cast Object2;
		// 	return tilemap.overlapsWithCallback(Object1, separateY, true);
		// }

		var overlap:Float = computeOverlapY(Object1, Object2);
		// Then adjust their positions and velocities accordingly (if there was any overlap)
		if (overlap != 0)
		{
			var obj1delta:Float = Object1.y - Object1.last.y;
			var obj2delta:Float = Object2.y - Object2.last.y;
			var obj1v:Float = Object1.velocity.y;
			var obj2v:Float = Object2.velocity.y;
			
			if (!obj1immovable && !obj2immovable)
			{
				overlap *= 0.5;
				Object1.y = Object1.y - overlap;
				Object2.y += overlap;
				
				var obj1velocity:Float = Math.sqrt((obj2v * obj2v * Object2.mass) / Object1.mass) * ((obj2v > 0) ? 1 : -1);
				var obj2velocity:Float = Math.sqrt((obj1v * obj1v * Object1.mass) / Object2.mass) * ((obj1v > 0) ? 1 : -1);
				var average:Float = (obj1velocity + obj2velocity) * 0.5;
				obj1velocity -= average;
				obj2velocity -= average;
				Object1.velocity.y = average + obj1velocity * Object1.elasticity;
				Object2.velocity.y = average + obj2velocity * Object2.elasticity;
			}
			else if (!obj1immovable)
			{
				Object1.y = Object1.y - overlap;
				Object1.velocity.y = obj2v - obj1v * Object1.elasticity;
				// This is special case code that handles cases like horizontal moving platforms you can ride
				if (Object1.collisionXDrag && Object2.exists && Object2.moves && (obj1delta > obj2delta))
				{
					Object1.x += Object2.x - Object2.last.x;
				}
			}
			else if (!obj2immovable)
			{
				Object2.y += overlap;
				Object2.velocity.y = obj1v - obj2v * Object2.elasticity;
				// This is special case code that handles cases like horizontal moving platforms you can ride
				if (Object2.collisionXDrag && Object1.exists && Object1.moves && (obj1delta < obj2delta))
				{
					Object2.x += Object1.x - Object1.last.x;
				}
			}
			return true;
		}
		
		return false;
	}
	
	/**
	 * Checking overlap and updating touching variables, Y-axis part used by "updateTouchingFlags".
	 * 
	 * @param	Object1 	Any NEntity.
	 * @param	Object2		Any other NEntity.
	 * @return	Whether the objects in fact touched along the Y axis.
	 */
	public static function updateTouchingFlagsY(Object1:NEntity, Object2:NEntity):Bool
	{
		//If one of the objects is a tilemap, just pass it off.
		// if (Object1.n4Type == TILEMAP)
		// {
		// 	var tilemap:NBaseTilemap<Dynamic> = cast Object1;
		// 	return tilemap.overlapsWithCallback(Object2, updateTouchingFlagsY);
		// }
		// if (Object2.n4Type == TILEMAP)
		// {
		// 	var tilemap:NBaseTilemap<Dynamic> = cast Object2;
		// 	return tilemap.overlapsWithCallback(Object1, updateTouchingFlagsY, true);
		// }
		// Since we are not separating, always return any amount of overlap => false as last parameter
		return computeOverlapY(Object1, Object2, false) != 0;
	}

	public function screenCenter(?axes:NAxes):NEntity {
		if (axes == null) axes = NAxes.XY;
		if (axes != NAxes.Y)
			x = (NGame.width / 2) - (width / 2);
		if (axes != NAxes.X)
			y = (NGame.height / 2) - (height / 2);
		
		return this;
	}

	private function set_x(Value:Float):Float {
		return x = Value;
	}

	private function set_y(Value:Float):Float {
		return y = Value;
	}

	@:noCompletion
	private inline function get_solid():Bool
	{
		return (allowCollisions & ANY) > NONE;
	}
	
	@:noCompletion
	private function set_solid(Solid:Bool):Bool
	{
		allowCollisions = Solid ? ANY : NONE;
		return Solid;
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

	@:noCompletion
	private function set_moves(Value:Bool):Bool
	{
		return moves = Value;
	}
	
	@:noCompletion
	private function set_immovable(Value:Bool):Bool
	{
		return immovable = Value;
	}

	@:noCompletion
	private function set_allowCollisions(Value:Int):Int 
	{
		return allowCollisions = Value;
	}
}