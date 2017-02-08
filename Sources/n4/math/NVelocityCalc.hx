package n4.math;

/**
 * Math utilities based on HaxeFlixel's FlxVelocity: https://github.com/HaxeFlixel/flixel/blob/master/flixel/math/FlxVelocity.hx
 */
class NVelocityCalc {
	/**
	 * A tween-like function that takes a starting velocity and some other factors and returns an altered velocity.
	 * 
	 * @param	Velocity		Any component of velocity (e.g. 20).
	 * @param	Acceleration		Rate at which the velocity is changing.
	 * @param	Drag			Really kind of a deceleration, this is how much the velocity changes if Acceleration is not set.
	 * @param	Max				An absolute value cap for the velocity (0 for no cap).
	 * @param	Elapsed			The amount of time passed in to the latest update cycle
	 * @return	The altered Velocity value.
	 */
	public static function computeVelocity(Velocity:Float, Acceleration:Float, Drag:Float, Max:Float, Elapsed:Float):Float
	{
		if (Acceleration != 0)
		{
			Velocity += Acceleration * Elapsed;
		}
		else if (Drag != 0)
		{
			var drag:Float = Drag * Elapsed;
			if (Velocity - drag > 0)
			{
				Velocity -= drag;
			}
			else if (Velocity + drag < 0)
			{
				Velocity += drag;
			}
			else
			{
				Velocity = 0;
			}
		}
		if ((Velocity != 0) && (Max != 0))
		{
			if (Velocity > Max)
			{
				Velocity = Max;
			}
			else if (Velocity < -Max)
			{
				Velocity = -Max;
			}
		}
		return Velocity;
	}
}