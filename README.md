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

* Sept 24
  * Add initial extended SurfaceView class
  * Experiment with random shape generation
  * Experiment with physics of rock interaction

* Sept 25
  * Add and play around with implementing buttons for Asteroids controls
    
* Sept 26
  * Attempt to make a start screen
    
* Oct 4
  * switch to Pool idea instead of asteroids  
  
* Oct 5
  * Enable better control over ball movement and touch handling
  
* Oct 6
  * Smooth out touchMoved/Ended action
  
* Oct 7
  * Sales walls and pockets based on device
  * Refactor, add colors to balls
  
* Oct 11
  * Get pockets working
  * Tweak physics

* Oct 12-13
  * Refactor
  * Game reset
