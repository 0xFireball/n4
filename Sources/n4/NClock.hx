package n4;

import kha.Scheduler;

class NClock {
  public var dt(default, null): Float;
  public var last(default, null): Float;

  public function new() {
    reset();
  }

  public function update() {
    var now = Scheduler.realTime();
    dt = now - last;
    last = now;
  }

  public function reset() {
    last = Scheduler.realTime();
    dt = 0;
  }
}