
# n4

an extremely lightweight 2d graphics framework for kha

design is inspired by haxeflixel, but n4 is much more minimal.
n4 uses a lot of code (mostly math) ripped directly from flixel with some modifications
and unnecessary parts removed.

## features

- it's lightweight
  - runs at 60fps with a lot of particles on a cheap cpu
- state and group system
  - switch between states, which have child groups and objects
  - state updates are passed down to each member
- basic physics
  - integrates velocity and acceleration
- math
  - vector math classes ripped from haxeflixel
- basic particle system
  - particle emitters that automatically limit particle count
