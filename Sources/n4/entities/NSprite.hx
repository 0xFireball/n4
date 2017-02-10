package n4.entities;

import kha.Canvas;
import kha.Color;
import kha.Image;
import n4.assets.NGraphic;
import n4.pooling.NGraphicPool;

class NSprite extends NEntity {

	public var graphic(default, set):NGraphic;
	public var color(default, default):Color = Color.White;

	public function new(?X:Float = 0, ?Y:Float = 0, ?Graphic:NGraphic) {
		super(X, Y);
	}

	override public function render(f:Canvas) {
		var ctx = f.g2;
		ctx.color = color;
		ctx.drawImage(graphic, x, y);
		super.render(f);
	}

	public function makeGraphic(Width:Int, Height:Int, ?GraphicColor:Color):NSprite {
		var g = NGraphicPool.getM(Width, Height, GraphicColor);
		width = Width;
		height = Height;
		if (g == null) {
			GraphicColor = (GraphicColor == null) ? Color.White : GraphicColor;
			graphic = Image.createRenderTarget(Width, Height);
			graphic.g2.begin();
			graphic.g2.color = GraphicColor;
			graphic.g2.fillRect(0, 0, Width, Height);
			graphic.g2.end();
			NGraphicPool.putM(Width, Height, GraphicColor, graphic);
		} else {
			graphic = g;
		}
		return this;
	}

	public function renderGraphic(Width:Int, Height:Int, render:NGraphic->Void, ?Key:String = null):NSprite {
		var g = NGraphicPool.getR(Width, Height, Key);
		width = Width;
		height = Height;
		if (g == null) {
			var target = Image.createRenderTarget(Width, Height);
			render(target);
			graphic = target;
			if (Key != null) {
				NGraphicPool.putR(Width, Height, Key, graphic);
			}
		} else {
			graphic = g;
		}
		return this;
	}

	private function set_graphic(Value:NGraphic):NGraphic
	{
		return graphic = Value;
	}
}