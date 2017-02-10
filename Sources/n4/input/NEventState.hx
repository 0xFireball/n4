package n4.input;

class NEventState {
	public var justPressed(get, null):Bool;
	public var pressed(get, null):Bool;

	private var down:Bool = false;
	private var pressFrame:Int;

	public function new() {

	}

	/**
	 * Used internally
	 */
	public function press() {
		pressFrame = NGame.updateFrameCount;
		down = true;
	}

	/**
	 * Used internally
	 */
	public function release() {
		down = false;
	}

	private function get_justPressed() {
		return down && pressFrame == NGame.updateFrameCount;
	}

	private function get_pressed() {
		return down;
	}
}