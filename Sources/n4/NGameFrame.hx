package n4;

import kha.System;

class NGameFrame {

	private var _state:NState = null;
	private var _targetFramerate:Int;

	public static function init(?Title:String = "n4", ?Width:Int = 800, ?Height:Int = 600, ?Framerate:Int = 60) {
		_targetFramerate = Framerate;
		System.init({title: Title, width: Width, height: Height}, function () {
			onInit();
		});
	}

	public static function switchState(state:NState) {
		_state = state;
	}

	private static function ge_update() {

	}

	private static function ge_render() {

	}

	private static function onInit() {
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}
}