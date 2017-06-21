package n4;

import kha.Canvas;

import n4.NGame;
import n4.group.NGroup;
import n4.math.NRect;

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

	public function render(f:Canvas, drawRoot:NGroup) {
		f.g2.begin(false);

		// push transformations
		f.g2.pushTranslation(x, y);
		f.g2.pushRotation(angle, NGame.width / 2, NGame.height / 2);

		// render draw root
		drawRoot.render(f);

		// pop transformations
		f.g2.popTransformation(); // translation
		f.g2.popTransformation(); // rotation

		f.g2.end();
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
		
		var helper:Float;
		var w:Float = 0;
		var h:Float = 0;

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