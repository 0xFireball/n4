package n4.input.touch;

import kha.input.Surface;

class NTouchSurface {
	private var state(default, never):Map<String, NTouchState> = new Map<String, NTouchState>();
	public var list(default, never):Array<NTouchState>;

	public function new() {
		Surface.get().notify(onTouchStart, onTouchEnd, onTouchMove);
	}

	private function onTouchStart(id:Int, x:Int, y:Int) {
		// TODO
	}

	private function onTouchEnd(id:Int, x:Int, y:Int) {
		// TODO
	}

	private function onTouchMove(id:Int, x:Int, y:Int) {
		// TODO
	}
}