package n4.drawing;

import kha.graphics2.Graphics;
import n4.math.NPoint;

class N4Graphics2 {
	private var ctx:Graphics;

	public var drawingContext(get, null):Graphics;

	public function new(DrawingContext: Graphics) {
		ctx = DrawingContext;
	}

	public function drawPoly(points:Array<NPoint>) {
		for (i in 0...points.length) {
			var h = (i + 1) % points.length;
			ctx.drawLine(points[i].x, points[i].y, points[h].x, points[h].y);
		}
	}

	public function fillPoly(points:Array<NPoint>) {
		for (i in 0...points.length) {
			var h = (i + 1) % points.length;
			var k = (i + 2) % points.length;
			ctx.fillTriangle(
				points[i].x, points[i].y,
				points[h].x, points[h].y
				points[k].x, points[k].y);
		}
	}

	private function get_drawingContext():Graphics {
		return ctx;
	}
}