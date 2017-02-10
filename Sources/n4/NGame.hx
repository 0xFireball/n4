package n4;

import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import kha.Scheduler;
import kha.System;

import n4.input.keyboard.NKeyboard;
import n4.input.touch.NTouchSurface;
import n4.events.NTimerManager;
import n4.math.NRect;
import n4.system.NQuadTree;

class NGame {
	private static var _backbuffer:Image;
	private static var _initialState:Class<NState>;
	private static var _clock:NClock;
	
	// configuration
	public static var width:Int;
	public static var height:Int;
	public static var targetFramerate:Int;

	// state variables
	public static var currentState:NState = new NState();
	public static var drawFrameCount(default, null):Int = 0;
	public static var updateFrameCount(default, null):Int = 0;

	// render options
	public static var useDoubleBuffering:Bool = true;
	public static var syncDrawUpdate:Bool = true;

	// input and utilities
	public static var keys:NKeyboard;
	public static var touches:NTouchSurface;
	public static var timers:NTimerManager;

	/**
	 * The dimensions of the game world, used by the quad tree for collisions and overlap checks.
	 * Use .set() instead of creating a new object!
	 */
	public static var worldBounds(default, null):NRect = new NRect();

	/**
	 * How many times the quad tree should divide the world on each axis. Generally, sparse collisions can have fewer divisons,
	 * while denser collision activity usually profits from more. Default value is 6.
	 */
	public static var worldDivisions:Int = 6;

	public static function init(?Title:String = "n4", ?Width:Int = 800, ?Height:Int = 600, ?InitialState:Class<NState>, ?Framerate:Int = 60) {
		width = Width;
		height = Height;
		targetFramerate = Framerate;
		_initialState = (InitialState == null) ? NState : InitialState;
		System.init({title: Title, width: Width, height: Height, samplesPerPixel: 4}, function () {
			onInitialized();
		});
	}

	public static function switchState(state:NState) {
		currentState = state;
		currentState.create();
	}

	private static function ge_update():Void {
		++updateFrameCount;
		_clock.update();
		var gdt = _clock.dt;
		// var gdt = Math.min(1 / targetFramerate, _clock.dt);
		// trace("current framerate: " + 1 / gdt);
 		// timers.update(gdt);
		currentState.update(gdt);
	}

	private static function ge_render(framebuffer: Framebuffer): Void {
		if (syncDrawUpdate) {
			ge_update();
		}
		++drawFrameCount;
		if (useDoubleBuffering) {
			_backbuffer.g2.begin(true, currentState.bgColor);
			currentState.render(_backbuffer);
			_backbuffer.g2.end();
			framebuffer.g2.begin();
			// render backbuffer
			Scaler.scale(_backbuffer, framebuffer, System.screenRotation);
			framebuffer.g2.end();
		} else {
			framebuffer.g2.begin(true, currentState.bgColor);
			currentState.render(framebuffer);
			framebuffer.g2.end();
		}
	}

	private static function onInitialized() {
		// create a drawing buffer
    	_backbuffer = Image.createRenderTarget(width, height);
		// set up
		_clock = new NClock();
		initVars();
		// timers = new NTimerManager();
		keys = new NKeyboard();
		// set up state
		currentState = Type.createInstance(_initialState, []);
		switchState(currentState);
		System.notifyOnRender(ge_render);
		if (!syncDrawUpdate) {
			Scheduler.addTimeTask(ge_update, 0, 1 / targetFramerate);
		}
	}

	private static function initVars() {
		worldBounds.set(-10, -10, width + 20, height + 20);
		drawFrameCount = 0;
		updateFrameCount = 0;
	}
	
	// collision detection

	/**
	 * Call this function to see if one NEntity collides with another.
	 * Can be called with one object and one group, or two groups, or two objects,
	 * whatever floats your boat! For maximum performance try bundling a lot of objects
	 * together using a NGroup (or even bundling groups together!).
	 * This function just calls NGame.overlap and presets the ProcessCallback parameter to NEntity.separate.
	 * To create your own collision logic, write your own ProcessCallback and use NGame.overlap to set it up.
	 * NOTE: does NOT take objects' scrollfactor into account, all overlaps are checked in world space.
	 * 
	 * @param	ObjectOrGroup1	The first object or group you want to check.
	 * @param	ObjectOrGroup2	The second object or group you want to check.  If it is the same as the first, flixel knows to just do a comparison within that group.
	 * @param	NotifyCallback	A function with two NEntity parameters - e.g. myOverlapFunction(Object1:NEntity,Object2:NEntity) - that is called if those two objects overlap.
	 * @return	Whether any objects were successfully collided/separated.
	 */
	public static inline function collide(?ObjectOrGroup1:NBasic, ?ObjectOrGroup2:NBasic, ?NotifyCallback:Dynamic->Dynamic->Void):Bool
	{
		return overlap(ObjectOrGroup1, ObjectOrGroup2, NotifyCallback, NEntity.separate);
	}
	
	/**
	 * Call this function to see if one NEntity overlaps another.
	 * Can be called with one object and one group, or two groups, or two objects,
	 * whatever floats your boat! For maximum performance try bundling a lot of objects
	 * together using a NGroup (or even bundling groups together!).
	 * NOTE: does NOT take objects' scrollFactor into account, all overlaps are checked in world space.
	 * NOTE: this takes the entire area of NTilemaps into account (including "empty" tiles). Use NTilemap#overlaps() if you don't want that.
	 * 
	 * @param	ObjectOrGroup1	The first object or group you want to check.
	 * @param	ObjectOrGroup2	The second object or group you want to check.  If it is the same as the first, flixel knows to just do a comparison within that group.
	 * @param	NotifyCallback	A function with two NEntity parameters - e.g. myOverlapFunction(Object1:NEntity,Object2:NEntity) - that is called if those two objects overlap.
	 * @param	ProcessCallback	A function with two NEntity parameters - e.g. myOverlapFunction(Object1:NEntity,Object2:NEntity) - that is called if those two objects overlap.  If a ProcessCallback is provided, then NotifyCallback will only be called if ProcessCallback returns true for those objects!
	 * @return	Whether any overlaps were detected.
	 */
	public static function overlap(?ObjectOrGroup1:NBasic, ?ObjectOrGroup2:NBasic, ?NotifyCallback:Dynamic->Dynamic->Void, ?ProcessCallback:Dynamic->Dynamic->Bool):Bool
	{
		if (ObjectOrGroup1 == null)
		{
			ObjectOrGroup1 = NGame.currentState;
		}
		if (ObjectOrGroup2 == ObjectOrGroup1)
		{
			ObjectOrGroup2 = null;
		}
		NQuadTree.divisions = worldDivisions;
		var quadTree:NQuadTree = NQuadTree.recycle(worldBounds.x, worldBounds.y, worldBounds.width, worldBounds.height);
		quadTree.load(ObjectOrGroup1, ObjectOrGroup2, NotifyCallback, ProcessCallback);
		var result:Bool = quadTree.execute();
		quadTree.destroy();
		return result;
	}
}