package n4.input.keyboard;

import kha.input.Keyboard;
import kha.Key;

class NKeyboard {
	private var state(default, never):Map<String, NKeyState> = new Map<String, NKeyState>();
	public var list(default, never):Array<NKeyState> = new Array<NKeyState>();

	public function new() {
		Keyboard.get().notify(onKeyDown, onKeyUp);
	}

	private inline function fillPosition(c:String) {
		state[c] = new NKeyState();
	}

	private function onKeyDown(k:Key, c:String) {
		if (c == "") c = k.getName().toUpperCase();
		if (state[c] == null) state[c] = new NKeyState();
		else c = c.toUpperCase();
		list.push(state[c]);
		state[c].press();
	}

	private function onKeyUp(k:Key, c:String) {
		if (c == "") c = k.getName().toUpperCase();
		if (state[c] == null) state[c] = new NKeyState();
		else c = c.toUpperCase();
		state[c].release();
		list.remove(state[c]);
	}

	public function pressed(keys:Array<String>):Bool {
		for (key in keys) {
			if (state[key] == null) state[key] = new NKeyState();
			var ks = state[key];
			if (ks.pressed) return true;
		}
		return false;
	}

	public function justPressed(keys:Array<String>):Bool {
		for (key in keys) {
			if (state[key] == null) state[key] = new NKeyState();
			var ks = state[key];
			if (ks.justPressed) return true;
		}
		return false;
	}
}