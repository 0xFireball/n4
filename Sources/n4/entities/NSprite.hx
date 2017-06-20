package n4.entities;

import kha.Canvas;
import kha.Color;
import kha.Image;
import kha.math.FastMatrix3;
import n4.assets.NGraphic;
import n4.pooling.NGraphicPool;

class NSprite extends NEntity {

	public var graphic(default, set):NGraphic;
	private var graphicRenderer:Canvas->Void;
	public var color(default, default):Color = Color.White;

	public function new(?X:Float = 0, ?Y:Float = 0, ?Graphic:NGraphic) {
		super(X, Y);
		graphic = Graphic;
	}

	override public function render(f:Canvas) {
		var ctx = f.g2;
		ctx.color = color;
		ctx.pushRotation(angle, x + width / 2, y + height / 2);
		if (graphic != null) {
			ctx.drawImage(graphic, x, y);
		} else if (graphicRenderer != null) {
			graphicRenderer(f);
		}
		ctx.popTransformation();
		super.render(f);
	}

	public function makeGraphic(Width:Int, Height:Int, ?GraphicColor:Color) {
		graphicRenderer = function (f) {
			// f.g2.begin(false);
			f.g2.color = GraphicColor;
			f.g2.fillRect(x, y, Width, Height);
			// f.g2.end();
		};
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