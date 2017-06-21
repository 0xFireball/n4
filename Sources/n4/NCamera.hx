package n4;

import kha.Canvas;

import n4.NGame;
import n4.group.NGroup;
import n4.math.NPoint;
import n4.math.NMath;
import n4.math.NRect;
import n4.entities.NSprite;

// N4 NCamera
// Some code adapted from HaxeFlixel: https://github.com/HaxeFlixel/flixel/blob/master/flixel/FlxCamera.hx

class NCamera {

	public static var defaultZoom:Float = 1;

	public var x:Float = 0;
	public var y:Float = 0;

	public var width:Float = 0;
	public var height:Float = 0;

	public var zoom:Float = 0;
	public var initialZoom(default, null):Float = 0;

	public var angle:Float = 0;

	public var target(default, null):NEntity;
	public var deadzone(default, null):NRect;

	/**
	 * Lower bound of the cameras scroll on the x axis
	 */
	public var minScrollX:Null<Float>;
	/**
	 * Upper bound of the cameras scroll on the x axis
	 */
	public var maxScrollX:Null<Float>;
	/**
	 * Lower bound of the cameras scroll on the y axis
	 */
	public var minScrollY:Null<Float>;
	/**
	 * Upper bound of the cameras scroll on the y axis
	 */
	public var maxScrollY:Null<Float>;

	public var followLerp(default, null):Float = NGame.defaultTargetFramerate / NGame.targetFramerate;

	/**
	 * Offset the camera target
	 */
	public var targetOffset(default, null):NPoint = new NPoint();
	public var scroll(default, null):NPoint = new NPoint();
	
	/**
	 * Helper to calculate follow target current scroll.
	 */
	private var _scrollTarget:NPoint = new NPoint();

	/**
	 * Used to force the camera to look ahead of the target.
	 */
	public var followLead(default, null):NPoint = new NPoint();

	/**
	 * Used to calculate the following target current velocity.
	 */
	private var _lastTargetPosition:NPoint;

	private var style(default, null):NCameraFollowStyle;
	
	public function new (X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0, Zoom:Float = 0) {

		x = X;
		y = Y;

		// use full game size if width/height not given
		width = (Width <= 0) ? NGame.width : Width;
		height = (Height <= 0) ? NGame.height : Height;

		zoom = Zoom == 0 ? defaultZoom : Zoom;
		initialZoom = zoom;
	}

	public function update(dt:Float) {
		// follow target
		if (target != null) {
			updateFollow();
		}

		updateScroll();
	}

	// Based on HaxeFlixel implementation
	// https://github.com/HaxeFlixel/flixel/blob/master/flixel/FlxCamera.hx#L884
	private function updateFollow() {
		// Either follow the object closely, 
		// or doublecheck our deadzone and update accordingly.
		if (deadzone == null)
		{
			var mp = target.getMidpoint();
			mp.addPoint(targetOffset);
			focusOn(mp);
		}
		else
		{
			var edge:Float;
			var targetX:Float = target.x + targetOffset.x;
			var targetY:Float = target.y + targetOffset.y;
			
			if (style == SCREEN_BY_SCREEN) 
			{
				if (targetX >= (scroll.x + width))
				{
					_scrollTarget.x += width;
				}
				else if (targetX < scroll.x)
				{
					_scrollTarget.x -= width;
				}

				if (targetY >= (scroll.y + height))
				{
					_scrollTarget.y += height;
				}
				else if (targetY < scroll.y)
				{
					_scrollTarget.y -= height;
				}
			}
			else
			{
				edge = targetX - deadzone.x;
				if (_scrollTarget.x > edge)
				{
					_scrollTarget.x = edge;
				} 
				edge = targetX + target.width - deadzone.x - deadzone.width;
				if (_scrollTarget.x < edge)
				{
					_scrollTarget.x = edge;
				}
				
				edge = targetY - deadzone.y;
				if (_scrollTarget.y > edge)
				{
					_scrollTarget.y = edge;
				}
				edge = targetY + target.height - deadzone.y - deadzone.height;
				if (_scrollTarget.y < edge)
				{
					_scrollTarget.y = edge;
				}
			}
			
			if (Std.is(target, NSprite))
			{
				if (_lastTargetPosition == null)  
				{
					_lastTargetPosition = new NPoint(target.x, target.y); // Creates this point.
				} 
				_scrollTarget.x += (target.x - _lastTargetPosition.x) * followLead.x;
				_scrollTarget.y += (target.y - _lastTargetPosition.y) * followLead.y;
				
				_lastTargetPosition.x = target.x;
				_lastTargetPosition.y = target.y;
			}
			
			if (followLerp >= NGame.defaultTargetFramerate / NGame.targetFramerate)
			{
				scroll.copyFrom(_scrollTarget); // no easing
			}
			else
			{
				scroll.x += (_scrollTarget.x - scroll.x) * followLerp * NGame.targetFramerate / NGame.defaultTargetFramerate;
				scroll.y += (_scrollTarget.y - scroll.y) * followLerp * NGame.targetFramerate / NGame.defaultTargetFramerate;
			}
		}
	}

	/**
	 * Updates (bounds) the camera scroll.
	 * Called every frame by camera's update() method.
	 */
	private function updateScroll():Void
	{
		// Adjust bounds to account for zoom
		var zoom = this.zoom / NG.initialZoom;
		var minX:Null<Float> = minScrollX == null ? null : minScrollX - (zoom - 1) * width / (2 * zoom);
		var maxX:Null<Float> = maxScrollX == null ? null : maxScrollX + (zoom - 1) * width / (2 * zoom);
		var minY:Null<Float> = minScrollY == null ? null : minScrollY - (zoom - 1) * height / (2 * zoom);
		var maxY:Null<Float> = maxScrollY == null ? null : maxScrollY + (zoom - 1) * height / (2 * zoom);
		
		// Make sure we didn't go outside the camera's bounds
		scroll.x = NMath.bound(scroll.x, minX, (maxX != null) ? maxX - width : null);
		scroll.y = NMath.bound(scroll.y, minY, (maxY != null) ? maxY - height : null);
	}
	
	public inline function focusOn(p:NPoint) {
		scroll.set(p.x - width / 2, p.y - height / 2);
	}

	public function render(f:Canvas, drawRoot:NGroup) {
		f.g2.begin(false);

		// push transformations
		f.g2.pushTranslation(-scroll.x, -scroll.y);
		f.g2.pushRotation(angle, NGame.width / 2, NGame.height / 2);

		// render draw root
		drawRoot.render(f);

		// pop transformations
		f.g2.popTransformation(); // translation
		f.g2.popTransformation(); // rotation

		f.g2.end();
	}

	/**
	 * Specify the bounding rectangle of where the camera is allowed to move.
	 * 
	 * @param	X				The smallest X value of your level (usually 0).
	 * @param	Y				The smallest Y value of your level (usually 0).
	 * @param	Width			The largest X value of your level (usually the level width).
	 * @param	Height			The largest Y value of your level (usually the level height).
	 * @param	UpdateWorld		Whether the global quad-tree's dimensions should be updated to match (default: false).
	 */
	public function setScrollBoundsRect(X:Float = 0, Y:Float = 0, Width:Float = 0, Height:Float = 0, UpdateWorld:Bool = false):Void
	{
		if (UpdateWorld)
		{
			NG.worldBounds.set(X, Y, Width, Height);
		}
		
		setScrollBounds(X, X + Width, Y, Y + Height);
	}

	/**
	 * Specify the bounds of where the camera is allowed to move.
	 * Set the boundary of a side to null to leave that side unbounded.
	 * 
	 * @param	MinX	The minimum X value the camera can scroll to
	 * @param	MaxX	The maximum X value the camera can scroll to
	 * @param	MinY	The minimum Y value the camera can scroll to
	 * @param	MaxY	The maximum Y value the camera can scroll to
	 */
	private function setScrollBounds(MinX:Null<Float>, MaxX:Null<Float>, MinY:Null<Float>, MaxY:Null<Float>):Void
	{
		minScrollX = MinX;
		maxScrollX = MaxX;
		minScrollY = MinY;
		maxScrollY = MaxY;
		updateScroll();
	}

	public function follow(Target:NEntity, ?Style:NCameraFollowStyle, ?Lerp:Float) {
		if (Style == null) {
			Style = NCameraFollowStyle.LOCKON;
		}
		if (Lerp == null) {
			Lerp = NGame.defaultTargetFramerate / NGame.targetFramerate;
		}

		style = Style;
		target = Target;
		followLerp = Lerp;
		
		var helper:Float;
		var w:Float = 0;
		var h:Float = 0;
		_lastTargetPosition = null;

		switch (Style)
		{
			case LOCKON:
				if (target != null) 
				{	
					w = target.width;
					h = target.height;
				}
				deadzone = new NRect((width - w) / 2, (height - h) / 2 - h * 0.25, w, h);
			
			case PLATFORMER:
				var w:Float = (width / 8);
				var h:Float = (height / 3);
				deadzone = new NRect((width - w) / 2, (height - h) / 2 - h * 0.25, w, h);
				
			case TOPDOWN:
				helper = Math.max(width, height) / 4;
				deadzone = new NRect((width - helper) / 2, (height - helper) / 2, helper, helper);
				
			case TOPDOWN_TIGHT:
				helper = Math.max(width, height) / 8;
				deadzone = new NRect((width - helper) / 2, (height - helper) / 2, helper, helper);
				
			case SCREEN_BY_SCREEN:
				deadzone = new NRect(0, 0, width, height);
				
			case NO_DEAD_ZONE:
				deadzone = null;
		}
	}

}

enum NCameraFollowStyle {
	LOCKON;
	PLATFORMER;
	TOPDOWN;
	TOPDOWN_TIGHT;
	SCREEN_BY_SCREEN;
	NO_DEAD_ZONE;
}