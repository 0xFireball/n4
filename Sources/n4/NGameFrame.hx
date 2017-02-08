package n4;

import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import kha.Scheduler;
import kha.System;

class NGameFrame {

	private static var _frameWidth:Int;
	private static var _frameHeight:Int;
	private static var _backbuffer:Image;

	private static var _initialState:Class<NState>;
	private static var _state:NState = new NState();
	private static var _targetFramerate:Int;

	private static var _clock:NClock;

	public static function init(Title:String = "n4", Width:Int = 800, Height:Int = 600, ?InitialState:Class<NState>, Framerate:Int = 60) {
		_frameWidth = Width;
		_frameHeight = Height;
		_targetFramerate = Framerate;
		_initialState = (InitialState == null) ? NState : InitialState;
		System.init({title: Title, width: Width, height: Height}, function () {
			onInitialized();
		});
	}

	public static function switchState(state:NState) {
		_state = state;
	}

	private static function ge_update():Void {
		_clock.update();
		_state.update(_clock.dt);
	}

	private static function ge_render(framebuffer: Framebuffer): Void {
		_state.render(_backbuffer);
		framebuffer.g2.begin();
		// render backbuffer
		Scaler.scale(_backbuffer, framebuffer, System.screenRotation);
		framebuffer.g2.end();
	}

	private static function onInitialized() {
		// create a drawing buffer
    	_backbuffer = Image.createRenderTarget(_frameWidth, _frameHeight);
		// set up
		_clock = new NClock();
		// set up state
		_state = Type.createInstance(_initialState, []);
		System.notifyOnRender(ge_render);
		Scheduler.addTimeTask(ge_update, 0, 1 / _targetFramerate);
	}
}