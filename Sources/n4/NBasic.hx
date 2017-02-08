package n4;

import kha.Canvas;

class NBasic {

	public var exists(default, default):Bool = true;

	public function new() {}

	public function update(dt:Float) {}

	public function render(f:Canvas) {}

	public function destroy() {
		exists = false;
	}
}