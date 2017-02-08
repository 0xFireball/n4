package n4;

import n4.group.NGroup;
import kha.Color;

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

	private function set_bgColor(Value:Color):Color {
		return bgColor = Value;
	}
}