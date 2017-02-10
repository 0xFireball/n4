package n4.util;

/**
 * Ripped from Flixel
 */
class NDestroyUtil
{
	/**
	 * Checks if an object is not null before calling destroy(), always returns null.
	 * 
	 * @param	object	An INDestroyable object that will be destroyed if it's not null.
	 * @return	null
	 */
	public static function destroy<T:INDestroyable>(object:Null<INDestroyable>):T
	{
		if (object != null)
		{
			object.destroy(); 
		}
		return null;
	}
	
	/**
	 * Destroy every element of an array of INDestroyables
	 *
	 * @param	array	An Array of INDestroyable objects
	 * @return	null
	 */
	public static function destroyArray<T:INDestroyable>(array:Array<T>):Array<T>
	{
		if (array != null)
		{
			for (e in array)
				destroy(e);
			array.splice(0, array.length);
		}
		return null;
	}
}

interface INDestroyable
{
	public function destroy():Void;
}