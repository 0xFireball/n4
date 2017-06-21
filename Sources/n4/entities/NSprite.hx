package n4.entities;

import kha.Canvas;
import kha.Color;
import kha.Image;
import kha.Assets;
import kha.math.FastMatrix3;
import n4.assets.NGraphic;
import n4.assets.NGraphicAsset;
import n4.pooling.NGraphicPool;
import n4.math.NPoint;
import n4.math.NMath;
import n4.display.NAnimationController;

class NSprite extends NEntity {

	public var graphic(default, set):NGraphic;
	private var graphicRenderer:Canvas->Void;
	public var color:Color = Color.White;
	public var scale(default, null):NPoint = new NPoint(1.0, 1.0);

	public var animation:NAnimationController = new NAnimationController();
	public var animated:Bool = false;

	/**
	 * WARNING: The origin of the sprite will default to its center. If you change this, 
	 * the visuals and the collisions will likely be pretty out-of-sync if you do any rotation.
	 */
	public var origin(default, null):NPoint = new NPoint(0, 0);
	/**
	 * Controls the position of the sprite's hitbox. Likely needs to be adjusted after
	 * changing a sprite's width, height or scale.
	 */
	public var offset(default, null):NPoint = new NPoint(0, 0);

	/**
	 * The width of the actual graphic or image being displayed (not necessarily the game object/bounding box).
	 */
	public var frameWidth(default, null):Int = 0;
	/**
	 * The height of the actual graphic or image being displayed (not necessarily the game object/bounding box).
	 */
	public var frameHeight(default, null):Int = 0;

	public var horizFrames(default, null):Int = 1;
	public var vertFrames(default, null):Int = 1;

	public function new(?X:Float = 0, ?Y:Float = 0, ?Graphic:NGraphic) {
		super(X, Y);
		graphic = Graphic;
	}

	override public function render(f:Canvas) {
		var ctx = f.g2;
		ctx.color = color;

		f.g2.pushTransformation(f.g2.transformation.multmat( // scale
			FastMatrix3.scale(scale.x, scale.y)
		));
		ctx.pushRotation(angle, x + width / 2, y + height / 2); // rotate sprite
		if (graphic != null) {
			if (animated) {
				// draw frame
				var frameX = (animation.frameIndex % horizFrames) * frameWidth;
				var frameY = Std.int(animation.frameIndex / horizFrames);
				ctx.drawSubImage(
					graphic,
					x - offset.x, y - offset.y,
					frameX, frameY,
					frameWidth, frameHeight
				);
			} else {
				// draw static image
				ctx.drawImage(graphic, x - offset.x, y - offset.y);
			}
		} else if (graphicRenderer != null) {
			graphicRenderer(f);
		}
		#if COLLISION_DEBUG
		// draw debug collision shapes
		ctx.color = Color.Red;
		ctx.drawRect(x, y, width, height);
		#end
		ctx.popTransformation(); // rotation
		ctx.popTransformation(); // scaling
		super.render(f);
	}

	override public function update(dt:Float) {
		super.update(dt);

		animation.update(dt);
		animate();
	}

	private function animate() { }

	public function makeGraphic(Width:Int, Height:Int, ?GraphicColor:Color) {
		graphicRenderer = function (f) {
			f.g2.begin(false);
			f.g2.fillRect(x - offset.x, y - offset.y, Width, Height);
			f.g2.end();
		};
		color = GraphicColor;
		width = Width;
		height = Height;
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

	public function loadGraphic(asset:NGraphicAsset, Animated:Bool = false, ?Width:Int = 0, ?Height:Int = 0) {
		animated = Animated;
		if (Width != 0 && Height != 0) {
			width = Width;
			height = Height;
			// set temporary frame dimensions
			frameWidth = Std.int(width);
			frameHeight = Std.int(height);
		}
		kha.Assets.loadImageFromPath(asset, true, function (i) {
			graphic = i;
			if (width == 0 || height == 0) {
				// set new width and height if not yet set
				if (Width == 0) {
					width = Width = i.width;
				}
				if (Height == 0) {
					height = Height = i.height;
				}
			}
			if (animated) {
				horizFrames = Std.int(i.width / Width);
				vertFrames = Std.int(i.height / Height);
				frameWidth = Std.int(i.width / horizFrames);
				frameHeight = Std.int(i.height / vertFrames);
			}
			graphicLoaded();
		});
	}

	public function setGraphicSize(Width:Int = 0, Height:Int = 0):Void {
		if (Width <= 0 && Height <= 0)
			return;
		
		var newScaleX:Float = Width / frameWidth;
		var newScaleY:Float = Height / frameHeight;
		scale.set(newScaleX, newScaleY);
		
		if (Width <= 0)
		{
			scale.x = newScaleY;
		}
		else if (Height <= 0)
		{
			scale.y = newScaleX;
		}
	}

	/**
	 * Check and see if this object is currently on screen. Differs from NObject's implementation
	 * in that it takes the actual graphic into account, not just the hitbox or bounding box or whatever.
	 * 
	 * @param	Camera		Specify which game camera you want.  If null getScreenPosition() will just grab the first global camera.
	 * @return	Whether the object is on screen or not.
	 */
	public override function isOnScreen(?Camera:NCamera):Bool {
		if (Camera == null)
			Camera = NG.camera;
		
		var minX:Float = x - offset.x - Camera.scroll.x * scrollFactor.x;
		var minY:Float = y - offset.y - Camera.scroll.y * scrollFactor.y;
		
		if ((angle == 0) && (scale.x == 1) && (scale.y == 1))
		{
			if (minX > Camera.width || minX + frameWidth < 0)
				return false;
			
			if (minY > Camera.height || minY + frameHeight < 0)
				return false;
		}
		else
		{
			var radiusX:Float = frameWidth / 2;
			var radiusY:Float = frameHeight / 2;
			
			var ox:Float = origin.x;
			if (ox != radiusX)
			{
				var x1:Float = Math.abs(ox);
				var x2:Float = Math.abs(frameWidth - ox);
				radiusX = Math.max(x2, x1);
			}
			
			var oy:Float = origin.y;
			if (oy != radiusY)
			{
				var y1:Float = Math.abs(oy);
				var y2:Float = Math.abs(frameHeight - oy);
				radiusY = Math.max(y2, y1);
			}
			
			radiusX *= Math.abs(scale.x);
			radiusY *= Math.abs(scale.y);
			var radius:Float = Math.max(radiusX, radiusY);
			radius *= NMath.SQUARE_ROOT_OF_TWO;
			
			minX += ox;
			var maxX:Float = minX + radius;
			minX -= radius;
			
			if (maxX < 0 || minX > Camera.width)
				return false;
			
			minY += oy;
			var maxY:Float = minY + radius;
			minY -= radius;
			
			if (maxY < 0 || minY > Camera.height)
				return false;
		}
		
		return true;
	}

	/**
	 * Sets the sprite's origin to its center - useful after adjusting 
	 * scale to make sure rotations work as expected.
	 */
	public inline function centerOrigin():Void {
		origin.set(frameWidth * 0.5, frameHeight * 0.5);
	}

	/**
	 * Updates the sprite's hitbox (width, height, offset) according to the current scale. 
	 * Also calls centerOrigin().
	 */
	public function updateHitbox():Void {
		width = Math.abs(scale.x) * frameWidth;
		height = Math.abs(scale.y) * frameHeight;
		offset.set(-0.5 * (width - frameWidth), -0.5 * (height - frameHeight));
		centerOrigin();
	}

	private function graphicLoaded() {}

	private function set_graphic(Value:NGraphic):NGraphic
	{
		return graphic = Value;
	}
}