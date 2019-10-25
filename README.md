# Pool for iOS

Play pool from your iOS device. Implemeneted in Swift using SpriteKit. All
resources are generated programmatically using SKShapeNode(point:count:).
## Project Goals
For this implementation, my goals were as follows:
### Current
- [x] Generate shapes programatically
- [x] Looks generally like pool, has somewhat realistic action
- [x] Game reset at end of game (i.e. no colored balls
  remaining, or 8-ball in pocket)
- [x] Pockets work reasonably well

### Future
- [ ] Visible numbers/stripes
- [ ] Cue
- [ ] Alternate views (start screen, "better luck next time"/"great job")
- [ ] Running score
- [ ] Correct (or better, configurable) ball order
- [ ] Bumpers

This was really fun to make, and while the game works basically as advertised, there are a number of future additions I would like to continue to work on to make this a more polished game.

## Daily Log

Note: this app started off as an Asteroids knock-off, so early commits reference polygons, asteroids, etc.

* Oct 25
  * Add players, begin work on scoring

* Oct 23
  * Continue working on unwind game -> game over segue

* Oct 21
  * Work on segue unwind

* Oct 18
  * Continue working on Game Over scene

* Oct 16
  * Add basic start screen with button
  * Fix full screen presentation in game after segue from start screen

* Oct 14
  * Continue with pool project
  * Add player class, instantiate player 1 and 2

* Oct 12-13
  * Refactor
  * Game reset

* Oct 11
  * Get pockets working
  * Tweak physics
  
* Oct 7
  * Sales walls and pockets based on device
  * Refactor, add colors to balls
  
* Oct 6
  * Smooth out touchMoved/Ended action
  
* Oct 5
  * Enable better control over ball movement and touch handling
    
* Oct 4
  * switch to Pool idea instead of asteroids  
    
* Sept 26
  * Attempt to make a start screen

* Sept 25
  * Add and play around with implementing buttons for Asteroids controls

* Sept 24
  * Add initial extended SurfaceView class
  * Experiment with random shape generation
  * Experiment with physics of rock interaction
  

