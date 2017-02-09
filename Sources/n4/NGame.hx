package n4;

import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import kha.Scheduler;
import kha.System;

import n4.input.keyboard.NKeyboard;
import n4.events.NTimerManager;

class NGame {
	private static var _backbuffer:Image;
	private static var _initialState:Class<NState>;
	private static var _clock:NClock;
	
	public static var width:Int;
	public static var height:Int;
	public static var currentState:NState = new NState();
	public static var targetFramerate:Int;
	public static var keys:NKeyboard;
	public static var timers:NTimerManager;
	// render options
	public static var useDoubleBuffering:Bool = true;

	public static function init(Title:String = "n4", Width:Int = 800, Height:Int = 600, ?InitialState:Class<NState>, Framerate:Int = 60) {
		width = Width;
		height = Height;
		targetFramerate = Framerate;
		_initialState = (InitialState == null) ? NState : InitialState;
		System.init({title: Title, width: Width, height: Height}, function () {
			onInitialized();
		});
	}

	public static function switchState(state:NState) {
		currentState = state;
		currentState.create();
	}

	private static function ge_update():Void {
		_clock.update();
		var gdt = _clock.dt;
		timers.update(gdt);
		currentState.update(gdt);
	}

	private static function ge_render(framebuffer: Framebuffer): Void {
		if (useDoubleBuffering) {
			_backbuffer.g2.begin(currentState.bgColor);
			currentState.render(_backbuffer);
			_backbuffer.g2.end();
			framebuffer.g2.begin();
			// render backbuffer
			Scaler.scale(_backbuffer, framebuffer, System.screenRotation);
			framebuffer.g2.end();
		} else {
			framebuffer.g2.begin(currentState.bgColor);
			currentState.render(framebuffer);
			framebuffer.g2.end();
		}
	}

	private static function onInitialized() {
		// create a drawing buffer
    	_backbuffer = Image.createRenderTarget(width, height);
		// set up
		_clock = new NClock();
		timers = new NTimerManager();
		keys = new NKeyboard();
		// set up state
		currentState = Type.createInstance(_initialState, []);
		switchState(currentState);
		System.notifyOnRender(ge_render);
		Scheduler.addTimeTask(ge_update, 0, 1 / targetFramerate);
	}
}