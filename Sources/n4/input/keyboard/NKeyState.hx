package n4.input.keyboard;

class NKeyState {
	private var down:Bool = false;

	public function press() {
		down = true;
	}

	public function release() {
		down = false;
	}
}