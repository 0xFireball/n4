package n4;

import kha.Canvas;

class NCamera extends NBasic {

	public static var defaultZoom:Float = 1;

	public var x:Float = 0;
	public var y:Float = 0;

	public var width:Float = 0;
	public var height:Float = 0;

	public var zoom:Float = 0;
	public var initialZoom:Float = 0;

	public var angle:Float = 0;
	
	public function new (X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0, Zoom:Float = 0) {
		super();

		x = X;
		y = Y;

		// use full game size if width/height not given
		width = (Width <= 0) ? NGame.width : Width;
		height = (Height <= 0) ? NGame.height : Height;

		zoom = Zoom == 0 ? defaultZoom : Zoom;
		initialZoom = zoom;
	}

	public override function render(f:Canvas) {
		super.render(f);

		f.g2.begin(false);
		f.g2.pushTranslation(x, y);
		f.g2.pushRotation(angle, NGame.width / 2, NGame.height / 2);
		f.g2.end();
	}

}