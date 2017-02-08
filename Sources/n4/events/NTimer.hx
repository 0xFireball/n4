package n4.events;

class NTimer {
	public var triggerTime(default, null):Float;

	private var _callback:Void->Void;

	public function new (TriggerTime:Float, Callback:Void->Void) {
		triggerTime = TriggerTime;
		_callback = Callback;
	}

	public function execute() {
		_callback();
	}
}