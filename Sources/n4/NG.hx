package n4;

import n4.math.NRect;
import n4.system.NQuadTree;
import n4.input.keyboard.NKeyboard;
import n4.input.touch.NTouchSurface;
import n4.system.camera.NCameraGroup;

// Utilities
class NG {
	/**
	 * The dimensions of the game world, used by the quad tree for collisions and overlap checks.
	 * Use .set() instead of creating a new object!
	 */
	public static var worldBounds(default, null):NRect = new NRect();

	public static var initialZoom(default, null):Float = 1.0;

	/**
	 * How many times the quad tree should divide the world on each axis. Generally, sparse collisions can have fewer divisons,
	 * while denser collision activity usually profits from more. Default value is 6.
	 */
	public static var worldDivisions:Int = 6;

	public static var hypot(get, never):Float;

	// input and utilities
	public static var keys:NKeyboard;
	public static var touches:NTouchSurface;

	// camera
	public static var cameras:NCameraGroup = new NCameraGroup();
	public static var camera(get, never):NCamera;
	
	// collision detection

	/**
	 * Call this function to see if one NEntity collides with another.
	 * Can be called with one object and one group, or two groups, or two objects,
	 * whatever floats your boat! For maximum performance try bundling a lot of objects
	 * together using a NGroup (or even bundling groups together!).
	 * This function just calls NGame.overlap and presets the ProcessCallback parameter to NEntity.separate.
	 * To create your own collision logic, write your own ProcessCallback and use NGame.overlap to set it up.
	 * NOTE: does NOT take objects' scrollfactor into account, all overlaps are checked in world space.
	 * 
	 * @param	ObjectOrGroup1	The first object or group you want to check.
	 * @param	ObjectOrGroup2	The second object or group you want to check.  If it is the same as the first, flixel knows to just do a comparison within that group.
	 * @param	NotifyCallback	A function with two NEntity parameters - e.g. myOverlapFunction(Object1:NEntity,Object2:NEntity) - that is called if those two objects overlap.
	 * @return	Whether any objects were successfully collided/separated.
	 */
	public static inline function collide(?ObjectOrGroup1:NBasic, ?ObjectOrGroup2:NBasic, ?NotifyCallback:Dynamic->Dynamic->Void):Bool
	{
		return overlap(ObjectOrGroup1, ObjectOrGroup2, NotifyCallback, NEntity.separate);
	}
	
	/**
	 * Call this function to see if one NEntity overlaps another.
	 * Can be called with one object and one group, or two groups, or two objects,
	 * whatever floats your boat! For maximum performance try bundling a lot of objects
	 * together using a NGroup (or even bundling groups together!).
	 * NOTE: does NOT take objects' scrollFactor into account, all overlaps are checked in world space.
	 * NOTE: this takes the entire area of NTilemaps into account (including "empty" tiles). Use NTilemap#overlaps() if you don't want that.
	 * 
	 * @param	ObjectOrGroup1	The first object or group you want to check.
	 * @param	ObjectOrGroup2	The second object or group you want to check.  If it is the same as the first, flixel knows to just do a comparison within that group.
	 * @param	NotifyCallback	A function with two NEntity parameters - e.g. myOverlapFunction(Object1:NEntity,Object2:NEntity) - that is called if those two objects overlap.
	 * @param	ProcessCallback	A function with two NEntity parameters - e.g. myOverlapFunction(Object1:NEntity,Object2:NEntity) - that is called if those two objects overlap.  If a ProcessCallback is provided, then NotifyCallback will only be called if ProcessCallback returns true for those objects!
	 * @return	Whether any overlaps were detected.
	 */
	public static function overlap(?ObjectOrGroup1:NBasic, ?ObjectOrGroup2:NBasic, ?NotifyCallback:Dynamic->Dynamic->Void, ?ProcessCallback:Dynamic->Dynamic->Bool):Bool
	{
		if (ObjectOrGroup1 == null)
		{
			ObjectOrGroup1 = NGame.currentState;
		}
		if (ObjectOrGroup2 == ObjectOrGroup1)
		{
			ObjectOrGroup2 = null;
		}
		NQuadTree.divisions = worldDivisions;
		var quadTree:NQuadTree = NQuadTree.recycle(worldBounds.x, worldBounds.y, worldBounds.width, worldBounds.height);
		quadTree.load(ObjectOrGroup1, ObjectOrGroup2, NotifyCallback, ProcessCallback);
		var result:Bool = quadTree.execute();
		quadTree.destroy();
		return result;
	}

	private static function get_hypot():Float {
		return Math.sqrt(NGame.width * NGame.width + NGame.height * NGame.height);
	}

	private static function get_camera():NCamera {
		return cameras.get(0);
	}
}