package n4.input.mouse;

import kha.input.Mouse;

class NMouse {
	private var state(default, never):Map<Int, NMouseState> = new Map<Int, NMouseState>();
	public var khaMouse(get, never):Mouse;

	public static inline var LEFT:Int = 0;

	public static inline var RIGHT:Int = 1;

	public static inline var MIDDLE:Int = 2;

	public function new() {
		khaMouse.notifyWindowed(0, onMouseDown, onMouseUp, onMouseMove, onMouseWheel);
	}

	public function onMouseDown(button:Int, x:Int, y:Int) {
		if (state[button] == null) state[button] = new NMouseState();
		state[button].press();
	}

	public function onMouseUp(button:Int, x:Int, y:Int) {
		if (state[button] == null) state[button] = new NMouseState();
		state[button].release();
	}

	public function onMouseMove(x:Int, y:Int, movementX:Int, movementY:Int) {
		// TODO
	}

	public function onMouseWheel(delta:Int) {
		// TODO
	}

	private function get_khaMouse():Mouse {
		return Mouse.get();
	}
}