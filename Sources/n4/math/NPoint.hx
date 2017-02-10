package n4.math;

import kha.math.FastMatrix4;

/**
 * Stores a 2D floating point coordinate.
 * Ripped from HaxeFlixel's FlxPoint: https://raw.githubusercontent.com/HaxeFlixel/flixel/master/flixel/math/FlxPoint.hx
 */
class NPoint
{	
	public var x(default, set):Float = 0;
	public var y(default, set):Float = 0;
	
	@:keep
	public function new(X:Float = 0, Y:Float = 0) 
	{
		set(X, Y);
	}

	public function toVector():NVector
	{
		return new NVector(x, y);
	}
	
	/**
	 * Set the coordinates of this point.
	 * 
	 * @param	X	The X-coordinate of the point in space.
	 * @param	Y	The Y-coordinate of the point in space.
	 * @return	This point.
	 */
	public function set(X:Float = 0, Y:Float = 0):NPoint
	{
		x = X;
		y = Y;
		return this;
	}
	
	/**
	 * Adds to the coordinates of this point.
	 * 
	 * @param	X	Amount to add to x
	 * @param	Y	Amount to add to y
	 * @return	This point.
	 */
	public inline function add(X:Float = 0, Y:Float = 0):NPoint
	{
		x += X;
		y += Y;
		return this;
	}
	
	/**
	 * Adds the coordinates of another point to the coordinates of this point.
	 * 
	 * @param	point	The point to add to this point
	 * @return	This point.
	 */
	public function addPoint(point:NPoint):NPoint
	{
		x += point.x;
		y += point.y;
		return this;
	}
	
	/**
	 * Subtracts from the coordinates of this point.
	 * 
	 * @param	X	Amount to subtract from x
	 * @param	Y	Amount to subtract from y
	 * @return	This point.
	 */
	public inline function subtract(X:Float = 0, Y:Float = 0):NPoint
	{
		x -= X;
		y -= Y;
		return this;
	}
	
	/**
	 * Subtracts the coordinates of another point from the coordinates of this point.
	 * 
	 * @param	point	The point to subtract from this point
	 * @return	This point.
	 */
	public function subtractPoint(point:NPoint):NPoint
	{
		x -= point.x;
		y -= point.y;
		return this;
	}
	
	/**
	 * Scale this point.
	 * 
	 * @param	k - scale coefficient
	 * @return	scaled point
	 * @since   4.1.0
	 */
	public function scale(k:Float):NPoint
	{
		x *= k;
		y *= k;
		return this;
	}
	
	/**
	 * Helper function, just copies the values from the specified point.
	 * 
	 * @param	point	Any NPoint.
	 * @return	A reference to itself.
	 */
	public inline function copyFrom(point:NPoint):NPoint
	{
		x = point.x;
		y = point.y;
		return this;
	}
	
	/**
	 * Helper function, just copies the values from this point to the specified point.
	 * 
	 * @param	Point	Any NPoint.
	 * @return	A reference to the altered point parameter.
	 */
	public function copyTo(?point:NPoint):NPoint
	{
		point.x = x;
		point.y = y;
		return point;
	}
	
	/**
	 * Returns true if this point is within the given rectangular block
	 * 
	 * @param	RectX		The X value of the region to test within
	 * @param	RectY		The Y value of the region to test within
	 * @param	RectWidth	The width of the region to test within
	 * @param	RectHeight	The height of the region to test within
	 * @return	True if the point is within the region, otherwise false
	 */
	public inline function inCoords(RectX:Float, RectY:Float, RectWidth:Float, RectHeight:Float):Bool
	{
		return NMath.pointInCoordinates(x, y, RectX, RectY, RectWidth, RectHeight);
	}
	
	/**
	 * Returns true if this point is within the given rectangular block
	 * 
	 * @param	Rect	The NRect to test within
	 * @return	True if pointX/pointY is within the NRect, otherwise false
	 */
	public inline function inRect(Rect:NRect):Bool
	{
		return NMath.pointInNRect(x, y, Rect);
	}
	
	/**
	 * Calculate the distance to another point.
	 * 
	 * @param 	AnotherPoint	A NPoint object to calculate the distance to.
	 * @return	The distance between the two points as a Float.
	 */
	public function distanceTo(point:NPoint):Float
	{
		var dx:Float = x - point.x;
		var dy:Float = y - point.y;
		return NMath.vectorLength(dx, dy);
	}
	
	/**
	 * Rounds x and y using Math.floor()
	 */
	public inline function floor():NPoint
	{
		x = Math.floor(x);
		y = Math.floor(y);
		return this;
	}
	
	/**
	 * Rounds x and y using Math.ceil()
	 */
	public inline function ceil():NPoint
	{
		x = Math.ceil(x);
		y = Math.ceil(y);
		return this;
	}
	
	/**
	 * Rounds x and y using Math.round()
	 */
	public inline function round():NPoint
	{
		x = Math.round(x);
		y = Math.round(y);
		return this;
	}
	
	/**
	 * Rotates this point clockwise in 2D space around another point by the given angle.
	 * 
	 * @param   Pivot   The pivot you want to rotate this point around
	 * @param   Angle   Rotate the point by this many degrees clockwise.
	 * @return  A NPoint containing the coordinates of the rotated point.
	 */
	public function rotate(Pivot:NPoint, Angle:Float):NPoint
	{
		var radians:Float = Angle * NAngle.TO_RAD;
		var sin:Float = NMath.fastSin(radians);
		var cos:Float = NMath.fastCos(radians);
		
		var dx:Float = x - Pivot.x;
		var dy:Float = y - Pivot.y;
		x = cos * dx - sin * dy + Pivot.x;
		y = sin * dx + cos * dy + Pivot.y;
		
		return this;
	}
	
	/**
	 * Calculates the angle between this and another point. 0 degrees points straight up.
	 * 
	 * @param   point   The other point.
	 * @return  The angle in degrees, between -180 and 180.
	 */
	public function angleBetween(point:NPoint):Float
	{
		var x:Float = point.x - x;
		var y:Float = point.y - y;
		var angle:Float = 0;
		
		if ((x != 0) || (y != 0))
		{
			var c1:Float = Math.PI * 0.25;
			var c2:Float = 3 * c1;
			var ay:Float = (y < 0) ? -y : y;
			
			if (x >= 0)
			{
				angle = c1 - c1 * ((x - ay) / (x + ay));
			}
			else
			{
				angle = c2 - c1 * ((x + ay) / (ay - x));
			}
			angle = ((y < 0) ? -angle : angle) * NAngle.TO_DEG;
			
			if (angle > 90)
			{
				angle = angle - 270;
			}
			else
			{
				angle += 90;
			}
		}
		
		return angle;
	}
	
	/**
	 * Function to compare this NPoint to another.
	 * 
	 * @param	point  The other NPoint to compare to this one.
	 * @return	True if the NPoints have the same x and y value, false otherwise.
	 */
	public inline function equals(point:NPoint):Bool
	{
		var result = NMath.equal(x, point.x) && NMath.equal(y, point.y);
		return result;
	}
	
	/**
	 * Applies tranformation matrix to this point
	 * @param	matrix	tranformation matrix
	 * @return	transformed point
	 */
	// public inline function transform(matrix:Matrix):NPoint
	// {
	// 	var x1:Float = x * matrix.a + y * matrix.c + matrix.tx;
	// 	var y1:Float = x * matrix.b + y * matrix.d + matrix.ty;
		
	// 	return set(x1, y1);
	// }
	
	/**
	 * Necessary for NCallbackPoint.
	 */
	private function set_x(Value:Float):Float 
	{ 
		return x = Value;
	}
	
	/**
	 * Necessary for NCallbackPoint.
	 */
	private function set_y(Value:Float):Float
	{
		return y = Value; 
	}
}

/**
 * A NPoint that calls a function when set_x(), set_y() or set() is called. Used in NSpriteGroup.
 * IMPORTANT: Calling set(x, y); is MUCH FASTER than setting x and y separately. Needs to be destroyed unlike simple NPoints!
 */
class NCallbackPoint extends NPoint
{
	private var _setXCallback:NPoint->Void;
	private var _setYCallback:NPoint->Void;
	private var _setXYCallback:NPoint->Void;
	
	/**
	 * If you only specifiy one callback function, then the remaining two will use the same.
	 * 
	 * @param	setXCallback	Callback for set_x()
	 * @param	setYCallback	Callback for set_y()
	 * @param	setXYCallback	Callback for set()
	 */
	public function new(setXCallback:NPoint->Void, ?setYCallback:NPoint->Void, ?setXYCallback:NPoint->Void)
	{
		super();
		
		_setXCallback = setXCallback;
		_setYCallback = setXYCallback;
		_setXYCallback = setXYCallback;
		
		if (_setXCallback != null)
		{
			if (_setYCallback == null)
				_setYCallback = setXCallback;
			if (_setXYCallback == null)
				_setXYCallback = setXCallback;
		}
	}
	
	override public inline function set(X:Float = 0, Y:Float = 0):NCallbackPoint
	{
		super.set(X, Y);
		if (_setXYCallback != null)
			_setXYCallback(this);
		return this;
	}
	
	override private inline function set_x(Value:Float):Float
	{
		super.set_x(Value);
		if (_setXCallback != null)
			_setXCallback(this);
		return Value;
	}
	
	override private inline function set_y(Value:Float):Float
	{
		super.set_y(Value);
		if (_setYCallback != null)
			_setYCallback(this);
		return Value;
	}
}