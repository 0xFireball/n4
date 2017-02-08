package n4;

import kha.Canvas;
import kha.Color;
import n4.group.NGroup;

class NState extends NGroup {
	public var bgColor(default, set):Color = Color.Black;

	public function new() {
		super();
	}

	/**
	 * Should be overrided to be customized
	 */
	public function create():Void {
	}

	public override function render(f:Canvas) {
		super.render(f);
	}

	private function set_bgColor(Value:Color):Color {
		return bgColor = Value;
	}
}