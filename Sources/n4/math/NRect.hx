package n4.math;

/**
 * Stores a rectangle.
 * Ripped from HaxeFlixel's FlxRect: https://raw.githubusercontent.com/HaxeFlixel/flixel/master/flixel/math/FlxRect.hx
 */
class NRect
{
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	
	/**
	 * The x coordinate of the left side of the rectangle.
	 */
	public var left(get, set):Float;
	
	/**
	 * The x coordinate of the right side of the rectangle.
	 */
	public var right(get, set):Float;
	
	/**
	 * The x coordinate of the top of the rectangle.
	 */
	public var top(get, set):Float;
	
	/**
	 * The y coordinate of the bottom of the rectangle.
	 */
	public var bottom(get, set):Float;
	
	/**
	 * Whether width or height of this rectangle is equal to zero or not.
	 */
	public var isEmpty(get, null):Bool;
	
	@:keep
	public function new(X:Float = 0, Y:Float = 0, Width:Float = 0, Height:Float = 0)
	{
		set(X, Y, Width, Height);
	}
	
	/**
	 * Shortcut for setting both width and Height.
	 * 
	 * @param	Width	The new sprite width.
	 * @param	Height	The new sprite height.
	 */
	public inline function setSize(Width:Float, Height:Float):NRect
	{
		width = Width;
		height = Height;
		return this;
	}
	
	/**
	 * Shortcut for setting both x and y.
	 */
	public inline function setPosition(x:Float, y:Float):NRect
	{
		this.x = x;
		this.y = y;
		return this;
	}
	
	/**
	 * Fill this rectangle with the data provided.
	 * 
	 * @param	X		The X-coordinate of the point in space.
	 * @param	Y		The Y-coordinate of the point in space.
	 * @param	Width	Desired width of the rectangle.
	 * @param	Height	Desired height of the rectangle.
	 * @return	A reference to itself.
	 */
	public inline function set(X:Float = 0, Y:Float = 0, Width:Float = 0, Height:Float = 0):NRect
	{
		x = X;
		y = Y;
		width = Width;
		height = Height;
		return this;
	}

	/**
	 * Helper function, just copies the values from the specified rectangle.
	 * 
	 * @param	Rect	Any NRect.
	 * @return	A reference to itself.
	 */
	public inline function copyFrom(Rect:NRect):NRect
	{
		x = Rect.x;
		y = Rect.y;
		width = Rect.width;
		height = Rect.height;
		
		return this;
	}
	
	/**
	 * Helper function, just copies the values from this rectangle to the specified rectangle.
	 * 
	 * @param	Point	Any NRect.
	 * @return	A reference to the altered rectangle parameter.
	 */
	public inline function copyTo(Rect:NRect):NRect
	{
		Rect.x = x;
		Rect.y = y;
		Rect.width = width;
		Rect.height = height;
		
		return Rect;
	}
	
	/**
	 * Checks to see if some NRect object overlaps this NRect object.
	 * 
	 * @param	Rect	The rectangle being tested.
	 * @return	Whether or not the two rectangles overlap.
	 */
	public inline function overlaps(Rect:NRect):Bool
	{
		var result =
			(Rect.x + Rect.width > x) &&
			(Rect.x < x + width) &&
			(Rect.y + Rect.height > y) &&
			(Rect.y < y + height);
		return result;
	}
	
	/**
	 * Returns true if this NRect contains the NPoint
	 * 
	 * @param	Point	The NPoint to check
	 * @return	True if the NPoint is within this NRect, otherwise false
	 */
	public inline function containsPoint(Point:NPoint):Bool
	{
		var result = NMath.pointInNRect(Point.x, Point.y, this);
		return result;
	}
	
	/**
	 * Add another rectangle to this one by filling in the 
	 * horizontal and vertical space between the two rectangles.
	 * 
	 * @param	Rect	The second NRect to add to this one
	 * @return	The changed NRect
	 */
	public inline function union(Rect:NRect):NRect
	{
		var minX:Float = Math.min(x, Rect.x);
		var minY:Float = Math.min(y, Rect.y);
		var maxX:Float = Math.max(right, Rect.right);
		var maxY:Float = Math.max(bottom, Rect.bottom);
		
		return set(minX, minY, maxX - minX, maxY - minY);
	}
	
	/**
	 * Rounds x, y, width and height using Math.floor()
	 */
	public inline function floor():NRect
	{
		x = Math.floor(x);
		y = Math.floor(y);
		width = Math.floor(width);
		height = Math.floor(height);
		return this;
	}
	
	/**
	 * Rounds x, y, width and height using Math.ceil()
	 */
	public inline function ceil():NRect
	{
		x = Math.ceil(x);
		y = Math.ceil(y);
		width = Math.ceil(width);
		height = Math.ceil(height);
		return this;
	}
	
	/**
	 * Rounds x, y, width and height using Math.round()
	 */
	public inline function round():NRect
	{
		x = Math.round(x);
		y = Math.round(y);
		width = Math.round(width);
		height = Math.round(height);
		return this;
	}
	
	/**
	 * Calculation of bounding box for two points
	 * 
	 * @param	point1	first point to calculate bounding box
	 * @param	point2	second point to calculate bounding box
	 * @return	this rectangle filled with the position and size of bounding box for two specified points
	 */
	public inline function fromTwoPoints(Point1:NPoint, Point2:NPoint):NRect
	{
		var minX:Float = Math.min(Point1.x, Point2.x);
		var minY:Float = Math.min(Point1.y, Point2.y);
		
		var maxX:Float = Math.max(Point1.x, Point2.x);
		var maxY:Float = Math.max(Point1.y, Point2.y);
		
		return this.set(minX, minY, maxX - minX, maxY - minY);
	}
	
	/**
	 * Add another point to this rectangle one by filling in the 
	 * horizontal and vertical space between the point and this rectangle.
	 * 
	 * @param	Point	point to add to this one
	 * @return	The changed NRect
	 */
	public inline function unionWithPoint(Point:NPoint):NRect
	{
		var minX:Float = Math.min(x, Point.x);
		var minY:Float = Math.min(y, Point.y);
		var maxX:Float = Math.max(right, Point.x);
		var maxY:Float = Math.max(bottom, Point.y);
		
		return set(minX, minY, maxX - minX, maxY - minY);
	}
	
	public inline function offset(dx:Float, dy:Float):NRect
	{
		x += dx;
		y += dy;
		return this;
	}
	
	/**
	 * Necessary for INDestroyable.
	 */
	public function destroy() {}
	
	/**
	 * Checks if this rectangle's properties are equal to properties of provided rect.
	 * 
	 * @param	rect	Rectangle to check equality to.
	 * @return	Whether both rectangles are equal.
	 */
	public inline function equals(rect:NRect):Bool
	{
		var result =
			NMath.equal(x, rect.x) &&
			NMath.equal(y, rect.y) &&
			NMath.equal(width, rect.width) &&
			NMath.equal(height, rect.height);
		return result;
	}
	
	/**
	 * Returns the area of intersection with specified rectangle. 
	 * If the rectangles do not intersect, this method returns an empty rectangle.
	 * 
	 * @param	rect	Rectangle to check intersection againist.
	 * @return	The area of intersection of two rectangles.
	 */
	public function intersection(rect:NRect, ?result:NRect):NRect
	{
		if (result == null)
			result = new NRect();
		
		var x0:Float = x < rect.x ? rect.x : x;
		var x1:Float = right > rect.right ? rect.right : right;
		if (x1 <= x0) 
		{	
			return result;
		}
		
		var y0:Float = y < rect.y ? rect.y : y;
		var y1:Float = bottom > rect.bottom ? rect.bottom : bottom;
		if (y1 <= y0) 
		{	
			return result;
		}
		
		return result.set(x0, y0, x1 - x0, y1 - y0);
	}
	
	private inline function get_left():Float
	{
		return x;
	}
	
	private inline function set_left(Value:Float):Float
	{
		width -= Value - x;
		return x = Value;
	}
	
	private inline function get_right():Float
	{
		return x + width;
	}
	
	private inline function set_right(Value:Float):Float
	{
		width = Value - x;
		return Value;
	}
	
	private inline function get_top():Float
	{
		return y;
	}
	
	private inline function set_top(Value:Float):Float
	{
		height -= Value - y;
		return y = Value;
	}
	
	private inline function get_bottom():Float
	{
		return y + height;
	}
	
	private inline function set_bottom(Value:Float):Float
	{
		height = Value - y;
		return Value;
	}
	
	private inline function get_isEmpty():Bool
	{
		return width == 0 || height == 0;
	}
}