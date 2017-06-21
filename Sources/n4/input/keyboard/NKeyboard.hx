package n4.input.keyboard;

import kha.input.Keyboard;
import kha.input.KeyCode;

class NKeyboard {
	private var state(default, never):Map<Int, NKeyState> = new Map<Int, NKeyState>();
	public var list(default, never):Array<NKeyState> = new Array<NKeyState>();

	public function new() {
		Keyboard.get().notify(onKeyDown, onKeyUp);
	}

	private inline function fillPosition(k:Int) {
		state[k] = new NKeyState();
	}

	private function onKeyDown(k:Int) {
		if (state[k] == null) fillPosition(k);
		list.push(state[k]);
		state[k].press();
	}

	private function onKeyUp(k:Int) {
		if (state[k] == null) fillPosition(k);
		state[k].release();
		list.remove(state[k]);
	}

	public function pressed(keys:Array<Int>):Bool {
		for (key in keys) {
			if (state[key] == null) state[key] = new NKeyState();
			var ks = state[key];
			if (ks.pressed) return true;
		}
		return false;
	}

	public function justPressed(keys:Array<Int>):Bool {
		for (key in keys) {
			if (state[key] == null) state[key] = new NKeyState();
			var ks = state[key];
			if (ks.justPressed) return true;
		}
		return false;
	}
}