# Pool for iOS

Play pool from your iOS device. Implemeneted in Swift using SpriteKit. All
resources are generated programmatically using SKShapeNode(point:count:).
## Project Goals
For this implementation, my goals were as follows:
* Need
- [x] Generate shapes programatically
- [ ] Reset game
- [ ] Score
- [ ] Great Job/Better Luck Next Time

* Want
- [ ] Start screen
- [ ] Numbers/stripes
- [ ] Correct ball order

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
  
* Oct 11-13
  * Get pockets working
  * Add cue
