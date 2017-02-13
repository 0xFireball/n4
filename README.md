
# n4 engine

a lightweight and minimal 2d game engine
built from scratch on kha's cross-platform low-level graphics

design is inspired by haxeflixel, but n4 is much more minimal.
n4 uses a lot of code (mostly math) ripped directly from flixel with some modifications
and unnecessary parts removed.

## samples

n4 is still in its very early stages, but i've made some simple demos along with the engine core:

- [SuperBoats](https://github.com/0xFireball/SuperBoats) (a game) **[Play](https://0xfireball.github.io/SuperBoats/)**
- [n4e](https://github.com/0xFireball/n4e) (an extensions library with tools such as text/HUD)
- [squareworld_n4](https://github.com/0xFireball/squareworld_n4) **[Play](https://0xfireball.github.io/squareworld_n4/)**

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
