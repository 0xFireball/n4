package n4.system.camera;

import n4.NCamera;

class NCameraGroup {
	
	private var cameras:Array<NCamera> = [];

	public function new() { }

	public function update(dt:Float) {
		for (cam in cameras) {
			cam.update(dt);
		}
	}

	public inline function push(cam:NCamera) {
		cameras.push(cam);
	}

	public inline function get(i:Int):NCamera {
		return cameras[i];
	}
}