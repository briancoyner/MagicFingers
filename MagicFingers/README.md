# Magic Fingers App
## Created by Brian Coyner

## App Details

The app tracks multiple touches. A CAReplicator spins a star image around each touch. 
The "options" popover allows the user to manipulate the CAReplicator layer while your 
fingers are down. 

## Technologies Used
- UITouch tracking
- Core Animation (CAReplicatorLayer and CABasicAnimation) to spin a star image around each touch
- Key Value Coding (KVC) and Key Value Observing (KVO)
- UITableViewController with custom cells that control the BTSMagicOptions object.


## Turning off the System Gestures
You need to turn off the System Gestures in order to lay down 4 or more fingers. 
  - Settings -> General -> Multitasking Gestures (OFF)

