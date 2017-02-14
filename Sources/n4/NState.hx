package n4;

import kha.Canvas;
import kha.Color;
import n4.group.NGroup;

class NState extends NGroup {
	public var bgColor(default, set):Color = Color.Black;
	
	/**
	 * To allow reusing states, create will only be called once.
	 */
	public var created:Bool = false;

	public function new() {
		super();
	}

	/**
	 * To customize the state, override this method.

	 */
	public function create():Void {
		created = true;
	}

	public override function render(f:Canvas) {
		super.render(f);
	}

	private function set_bgColor(Value:Color):Color {
		return bgColor = Value;
	}
}