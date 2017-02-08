package n4.input.keyboard;

import kha.input.Keyboard;
import kha.Key;

class NKeyboard {
	private var pressedKeys:Map<String, Bool> = new Map<String, Bool>();

	public function new() {
		Keyboard.get().notify(onKeyDown, onKeyUp);
	}

	public function getKey(name:String):Bool {
		return pressedKeys[name] != null ? pressedKeys[name] : false;
	}

	private function onKeyDown(k:Key, c:String) {
		if (c == "") c = k.getName();
		pressedKeys[c] = true;
	}

	private function onKeyUp(k:Key, c:String) {
		if (c == "") c = k.getName();
		pressedKeys[c] = false;
	}
}