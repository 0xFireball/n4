package n4;

import kha.Framebuffer;

class NTypedGroup<T:NEntity> extends NEntity {
	/**
	 * Array of all the members of this group.
	 */
	public var members(default, null):Array<T>;

	public function new() {
		super();

		members = [];
	}

	override public function update(dt:Float) {
		for (member in members) {
			if (member != null) {
				member.update(dt);
			}
		}
	}

	override public function render(f:Framebuffer) {
		for (member in members) {
			if (member != null) {
				member.render(f);
			}
		}
	}
}