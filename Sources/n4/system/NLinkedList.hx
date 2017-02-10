package n4.system;

import n4.NEntity;
import n4.util.NDestroyUtil.INDestroyable;

/**
 * A miniature linked list class.
 * Useful for optimizing time-critical or highly repetitive tasks!
 * See NQuadTree for how to use it, IF YOU DARE.
 * Ripped from https://raw.githubusercontent.com/HaxeFlixel/flixel/master/flixel/system/FlxLinkedList.hx
 */
class NLinkedList implements INDestroyable
{
	/**
	 * Pooling mechanism, when NLinkedLists are destroyed, they get added
	 * to this collection, and when they get recycled they get removed.
	 */
	public static var  _NUM_CACHED_N_LIST:Int = 0;
	private static var _cachedListsHead:NLinkedList;
	
	/**
	 * Recycle a cached Linked List, or creates a new one if needed.
	 */
	public static function recycle():NLinkedList
	{
		if (_cachedListsHead != null)
		{
			var cachedList:NLinkedList = _cachedListsHead;
			_cachedListsHead = _cachedListsHead.next;
			_NUM_CACHED_N_LIST--;
			
			cachedList.exists = true;
			cachedList.next = null;
			return cachedList;
		}
		else
			return new NLinkedList();
	}
	
	/**
	 * Clear cached List nodes. You might want to do this when loading new levels
	 * (probably not though, no need to clear cache unless you run into memory problems).
	 */
	public static function clearCache():Void 
	{
		// null out next pointers to help out garbage collector
		while (_cachedListsHead != null)
		{
			var node = _cachedListsHead;
			_cachedListsHead = _cachedListsHead.next;
			node.object = null;
			node.next = null;
		}
		_NUM_CACHED_N_LIST = 0;
	}
	
	/**
	 * Stores a reference to a NEntity.
	 */
	public var object:NEntity;
	/**
	 * Stores a reference to the next link in the list.
	 */
	public var next:NLinkedList;
	
	public var exists:Bool = true;
	
	/**
	 * Private, use recycle instead.
	 */
	private function new() {}
	
	/**
	 * Clean up memory.
	 */
	public function destroy():Void
	{
		// ensure we haven't been destroyed already
		if (!exists)
			return;
		
		object = null;
		if (next != null)
		{
			next.destroy();
		}
		exists = false;
		
		// Deposit this list into the linked list for reusal.
		next = _cachedListsHead;
		_cachedListsHead = this;
		_NUM_CACHED_N_LIST++;
	}
}