package n4.display;

class NAnimationController {

	public var frameIndex:Int = 0;
	public var current:NAnimation;
	private var animations:Map<String, NAnimation> = new Map<String, NAnimation>();
	private var playing:Bool = false;
	private var frameElapsed:Float = 0;

	public function new() {
	}

	public function add(Name:String, Sequence:Array<Int>, Framerate:Int) {
		animations[Name] = new NAnimation(Sequence, Framerate);
	}

	public function play(Name:String, Force:Bool = false) {
		if (!playing || Force) {
			var anim = animations[Name];
			current = anim;
			frameIndex = 0;
			playing = true;
		}
	}

	public function stop() {
		playing = false;
		current = null;
	}

	public function update(dt:Float) {
		if (playing) {
			var frameTime = 1.0 / current.framerate;
			if (frameElapsed < frameTime) {
				frameElapsed += dt;
			} else {
				// time to switch frames
				if (frameIndex >= current.seq.length - 1) {
					// last frame, end animation
					playing = false;
					current = null;
				} else {
					frameIndex++;
					frameElapsed = 0;
				}
			}
		}
	}
}

class NAnimation {
	public var seq(default, null):Array<Int>;
	public var framerate(default, null):Int;

	public function new(Sequence:Array<Int>, Framerate:Int) {
		seq = Sequence;
		framerate = Framerate;
	}


}