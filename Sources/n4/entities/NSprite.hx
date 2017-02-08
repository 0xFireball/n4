package n4.entities;

import kha.Canvas;
import kha.Color;
import kha.Image;
import n4.assets.NGraphic;

class NSprite extends NEntity {

	public var graphic(default, set):NGraphic;

	public function new(?X:Float = 0, ?Y:Float = 0, ?Graphic:NGraphic) {
		super(X, Y);
	}

	override public function render(f:Canvas) {
		var ctx = f.g2;
		ctx.drawImage(graphic, x, y);
	}

	public function makeGraphic(Width:Int, Height:Int, ?GraphicColor:Color):NSprite {
		GraphicColor = (GraphicColor == null) ? Color.White : GraphicColor;
		graphic = Image.createRenderTarget(Width, Height);
		graphic.g2.begin();
		graphic.g2.color = GraphicColor;
		graphic.g2.fillRect(0, 0, Width, Height);
		graphic.g2.end();
		return this;
	}

	private function set_graphic(Value:NGraphic):NGraphic
	{
		return graphic = Value;
	}
}