package n4;

import kha.Scheduler;

class NClock {
  public var dt(default, null): Float;
  public var last(default, null): Float;

  public function new() {
    reset();
  }

  private inline function getTime() {
    return Scheduler.realTime();
  }

  public function update() {
    var now = getTime();
    dt = now - last;
    last = now;
  }

  public function reset() {
    last = getTime();
    dt = 0;
  }
}