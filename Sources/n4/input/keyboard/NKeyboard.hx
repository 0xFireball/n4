package n4.input.keyboard;

import kha.input.Keyboard;
import kha.Key;

class NKeyboard {
	public var pressedKeys:Map<String, Bool> = new Map<String, Bool>();

	public function new() {
		Keyboard.get().notify(onKeyDown, onKeyUp);
	}

	private function onKeyDown(k:Key, c:String) {
		pressedKeys[c] = true;
	}

	private function onKeyUp(k:Key, c:String) {
		pressedKeys[c] = false;
	}
}