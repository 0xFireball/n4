package n4.group;

import kha.Canvas;

class NTypedGroup<T:NBasic> extends NBasic {
	/**
	 * Array of all the members of this group.
	 */
	public var members(default, null):Array<T>;

	public var memberCount(default, null):Int = 0;

	public var maxSize(default, null):Int;

	private var freePosition:Int = 0;

	public function new(MaxSize:Int = 1000) {
		super();

		maxSize = MaxSize;
		members = [];
	}

	private function getFirstAvailable():Int {
		var i = freePosition;
		while (i < members.length + freePosition) {
			var h = i % members.length;
			if (members[h] == null || !members[h].exists) {
				return h;
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
		var index = getFirstAvailable();
		if (index < 0 && memberCount >= maxSize) { // If max size exceeded, recycle
			index = 0;
			--memberCount; // pop old member
		}
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
		var i:Int = 0;
		while (i < members.length) {
			var member = members[i];
			if (member != null) {
				if (member.exists) {
					member.update(dt);
					if (!member.exists) { // the member died
						--memberCount;
					}
				} else {
					if (i < freePosition) {
						freePosition = i;
					}
				}
			}
			++i;
		}
		super.update(dt);
	}

	override public function destroy():Void {
		super.destroy();
		if (members != null) {
			var i:Int = 0;
			var member = null;
			
			while (i < memberCount)
			{
				member = members[i++];
				
				if (member != null && member.exists)
					member.destroy();
			}
			
			members = null;
		}
	}

	override public function render(f:Canvas) {
		for (member in members) {
			if (member != null && member.exists) {
				member.render(f);
			}
		}
	}
}