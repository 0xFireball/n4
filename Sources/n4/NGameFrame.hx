package n4;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class NGameFrame {

	private static var _initialState:Class<NState>;
	private static var _state:NState = new NState();
	private static var _targetFramerate:Int;

	public static function init(?Title:String = "n4", ?Width:Int = 800, ?Height:Int = 600, ?InitialState:Class<NState>, ?Framerate:Int = 60) {
		_targetFramerate = Framerate;
		_initialState = (InitialState == null) ? NState : InitialState;
		System.init({title: Title, width: Width, height: Height}, function () {
			onInit();
		});
	}

	public static function switchState(state:NState) {
		_state = state;
	}

	private static function ge_update():Void {
		// call update on entities
	}

	private static function ge_render(framebuffer: Framebuffer): Void {

	}

	private static function onInit() {
		// set up state
		_state = Type.createInstance(_initialState, []);
		System.notifyOnRender(ge_render);
		Scheduler.addTimeTask(ge_update, 0, 1 / _targetFramerate);
	}
}