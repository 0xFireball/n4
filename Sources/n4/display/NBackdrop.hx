package n4.display;

import n4.entities.NSprite;
import n4.assets.NGraphicAsset;

class NBackdrop extends NSprite {
	private var _scrollW:Int = 0;
	private var _scrollH:Int = 0;
	private var _repeatX:Bool = false;
	private var _repeatY:Bool = false;
	
	private var _spaceX:Int = 0;
	private var _spaceY:Int = 0;
	
	private var _tileInfo:Array<Float>;
	private var _numTiles:Int = 0;
	
	/**
	 * Creates an instance of the NBackdrop class, used to create infinitely scrolling backgrounds.
	 * 
	 * @param   Graphic		The image you want to use for the backdrop.
	 * @param   ScrollX 	Scrollrate on the X axis.
	 * @param   ScrollY 	Scrollrate on the Y axis.
	 * @param   RepeatX 	If the backdrop should repeat on the X axis.
	 * @param   RepeatY 	If the backdrop should repeat on the Y axis.
	 * @param	SpaceX		Amount of spacing between tiles on the X axis
	 * @param	SpaceY		Amount of spacing between tiles on the Y axis
	 */
	public function new(?Graphic:NGraphicAsset, ScrollX:Float = 1, ScrollY:Float = 1, RepeatX:Bool = true, RepeatY:Bool = true, SpaceX:Int = 0, SpaceY:Int = 0) 
	{
		super();
		
		_repeatX = RepeatX;
		_repeatY = RepeatY;
		
		_spaceX = SpaceX;
		_spaceY = SpaceY;
		
		scrollFactor.x = ScrollX;
		scrollFactor.y = ScrollY;
		
		if (Graphic != null) {
			loadGraphic(Graphic);
		}
	}
	
	override public function destroy():Void 
	{
		_tileInfo = null;
		
		super.destroy();
	}
}