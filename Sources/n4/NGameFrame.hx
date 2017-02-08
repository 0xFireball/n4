package n4;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class NGameFrame {

	private static var _state:NState = null;
	private static var _targetFramerate:Int;

	public static function init(?Title:String = "n4", ?Width:Int = 800, ?Height:Int = 600, ?Framerate:Int = 60) {
		_targetFramerate = Framerate;
		System.init({title: Title, width: Width, height: Height}, function () {
			onInit();
		});
	}

	public static function switchState(state:NState) {
		_state = state;
	}

	private static function ge_update():Void {

	}

	private static function ge_render(framebuffer: Framebuffer): Void {

	}

	private static function onInit() {
		System.notifyOnRender(ge_render);
		Scheduler.addTimeTask(ge_update, 0, 1 / _targetFramerate);
	}
}