package n4.group;

import kha.Canvas;
import n4.pooling.ItemPool;

class NTypedGroup<T:NBasic> extends NBasic {
	/**
	 * Array of all the members of this group.
	 */
	public var members(default, null):Array<T>;

	public var pool(default, null):ItemPool<T>;

	public var memberCount(default, null):Int;

	private var cycles:Int = 0;

	public function new() {
		super();

		members = [];
		pool = new ItemPool<T>();
	}

	private function getFirstNull():Int {
		var i:Int = 0;
		while (i < members.length) {
			if (members[i] == null) {
				return i;
			}
			i++;
		}
		return -1;
	}
	
	public function forEachActive(action:T->Void) {
		for (m in members) {
			if (m != null && m.exists) {
				action(m);
			}
		}
	}

	public function add(Object:T):T {
		// attempt to recycle
		var index = getFirstNull();
		if (index >= 0) {
			// recycle
			members[index] = Object;
			++memberCount;
			return Object;
		}
		members.push(Object);
		++memberCount;
		return Object;
	}

	override public function update(dt:Float) {
		++cycles;
		var i:Int = 0;
		while (i < members.length) {
			var member = members[i];
			if (member != null) {
				if (member.exists) {
					member.update(dt);
				} else {
					pool.putWeak(member);
					members[i] = null;
					--memberCount;
				}
			}
			// if (cycles % 200 == 0) { // null cleanup
			// 	if (member == null) {
			// 		members.splice(i, 1);
			// 	} else {
			// 		++i;
			// 	}
			// } else {
			// 	++i;
			// }
			++i;
		}
		// if (cycles % 200 == 0) { // null cleanup
		// 	// clean up pool
		// 	pool.empty();
		// }
	}

	override public function destroy():Void {
		super.destroy();
		if (members != null) {
			var i:Int = 0;
			var member = null;
			
			while (i < memberCount)
			{
				member = members[i++];
				
				if (member != null)
					member.destroy();
			}
			
			members = null;
		}
	}

	override public function render(f:Canvas) {
		for (member in members) {
			if (member != null) {
				member.render(f);
			}
		}
	}
}