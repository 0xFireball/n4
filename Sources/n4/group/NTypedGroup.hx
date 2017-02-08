package n4.group;

import kha.Canvas;

class NTypedGroup<T:NBasic> extends NBasic {
	/**
	 * Array of all the members of this group.
	 */
	public var members(default, null):Array<T>;

	public function new() {
		super();

		members = [];
	}

	public function add(Object:T):T {
		members.push(Object);
		return Object;
	}

	override public function update(dt:Float) {
		for (member in members) {
			if (member != null) {
				member.update(dt);
			}
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