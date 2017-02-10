package n4;

import kha.Canvas;

class NBasic {

	public var exists(default, default):Bool = true;

	/**
	 * Enum that informs the collision system which type of object this is (to avoid expensive type casting).
	 */
	@:noCompletion
	private var n4Type(default, null):NItemType = NONE;

	public function new() {
		initialize();
	}

	public function update(dt:Float) {}

	public function render(f:Canvas) {}

	public function destroy() {
		exists = false;
	}

	public function initialize() {
		exists = true;
	}
}

@:enum
abstract NItemType(Int)
{
	var NONE        = 0;
	var OBJECT      = 1;
	var GROUP       = 2;
	var TILEMAP     = 3;
	var SPRITEGROUP = 4;
}