package n4;

import kha.Assets;
import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import kha.Scheduler;
import kha.System;

import n4.events.NTimerManager;
import n4.preload.N4AssetPreloader;
import n4.input.keyboard.NKeyboard;
import n4.input.touch.NTouchSurface;

class NGame {
	private static var _backbuffer:Image;
	private static var _initialState:Class<NState>;
	private static var _clock:NClock;
	
	// configuration
	public static var width(default, null):Int;
	public static var height(default, null):Int;
	public static var targetFramerate:Int;

	// default configuration
	public static var defaultTargetFramerate:Int = 60;

	// state variables
	public static var currentState:NState = new NState();
	public static var drawFrameCount(default, null):Int = 0;
	public static var updateFrameCount(default, null):Int = 0;
	public static var assetsLoaded(get, null):Bool;

	// render options
	public static var useDoubleBuffering:Bool = true;
	public static var syncDrawUpdate:Bool = true;
	public static var stabilizeUpdateInterval:Bool = false;

	// utilities
	public static var timers:NTimerManager;

	public static function init(?Title:String = "n4", ?Width:Int = 800, ?Height:Int = 600, ?InitialState:Class<NState>, ?Framerate:Int = 60) {
		#if sys_html5
		if (Width == 0 && Height == 0) {
			Width =
				untyped __js__('window.innerWidth');
			Height = 
				untyped __js__('window.innerHeight');
		}
		#end
		width = Width;
		height = Height;
		targetFramerate = Framerate;
		_initialState = (InitialState == null) ? NState : InitialState;
		System.init({title: Title, width: Width, height: Height, samplesPerPixel: 16}, function () {
			onInitialized();
		});
	}

	public static function switchState(state:NState) {
		currentState = state;
		if (!currentState.created) currentState.create();
	}

	private static function ge_update():Void {
		++updateFrameCount;
		_clock.update();
		var gdt = _clock.dt;
		if (stabilizeUpdateInterval) {
			// for frame stability, use half the framerate as a minimum
			gdt = Math.min(gdt, 2 / targetFramerate);
		}
		// #if debug
		// trace("current framerate: " + 1 / gdt);
		// #end
 		timers.update(gdt);
		currentState.update(gdt);
	}

	private static function ge_render(framebuffer: Framebuffer): Void {
		if (syncDrawUpdate) {
			ge_update();
		}
		++drawFrameCount;
		var renderCall:kha.Canvas->Void = function(f) {
			f.g2.begin(true, currentState.bgColor);
			NG.camera.render(f, currentState);
			f.g2.end();
		};
		if (useDoubleBuffering) {
			renderCall(_backbuffer);
			framebuffer.g2.begin();
			// render backbuffer
			Scaler.scale(_backbuffer, framebuffer, System.screenRotation);
			framebuffer.g2.end();
		} else {
			renderCall(framebuffer);
		}
	}

	private static function onInitialized() {
		// set up
		_clock = new NClock();
		initVars();
		timers = new NTimerManager();
		// set up input
		NG.keys = new NKeyboard();
		NG.touches = new NTouchSurface();

		// create a drawing backbuffer
    	_backbuffer = Image.createRenderTarget(width, height);
		// set up rendering system
		NG.cameras.push(new NCamera(
			0, 0, width, height, 1.0
		));
		System.notifyOnRender(ge_render);
		if (!syncDrawUpdate) {
			Scheduler.addTimeTask(ge_update, 0, 1 / targetFramerate);
		}
		// start preloader state
		currentState = new N4AssetPreloader();
		switchState(currentState);
		// start loading assets
		Assets.loadEverything(onAssetsLoaded);
	}

	private static function onAssetsLoaded() {
		// set up main state
		currentState = Type.createInstance(_initialState, []);
		switchState(currentState);
	}

	private static function initVars() {
		NG.worldBounds.set(-10, -10, width + 20, height + 20);
		drawFrameCount = 0;
		updateFrameCount = 0;
	}

	private static function get_assetsLoaded():Bool {
		return !(Assets.progress < 1);
	}
}