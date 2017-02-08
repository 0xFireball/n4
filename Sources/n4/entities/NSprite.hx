package n4.entities;

import kha.Color;
import kha.Image;
import n4.assets.NGraphic;

class NSprite extends NEntity {

	public var graphic(default, set):NGraphic;

	public function new(?X:Float = 0, ?Y:Float = 0, ?Graphic:NGraphic) {
		super(X, Y);
	}

	public function makeGraphic(Width:Int, Height:Int, ?GraphicColor:Color):NSprite {
		GraphicColor = (GraphicColor == null) ? Color.White : GraphicColor;
		graphic = Image.create(Width, Height);
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