package n4.events;

class NTimerManager {
	private var timers(default, null):Array<NTimer> = new Array<NTimer>();

	public function new() {

	}
	
	private var totalElapsed:Float = 0;

	public function update(dt:Float) {
    	totalElapsed += dt;
		var i:Int = 0;      
		while (i < timers.length) {
			var t = timers[i];
			if (totalElapsed >= t.triggerTime) {
				t.execute();
				timers.splice(i, 1);
			} else {
				i++;
			}
		}
	}

	/**
	 * Schedule a callback to run after a certain
	 * number of milliseconds.
	 */
	public function setTimer(delay:Float, callback:Void->Void) {
		timers.push(new NTimer(totalElapsed + delay / 1000, callback));
	}
}