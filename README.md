# Magic Fingers App (iOS 5 + ARC)
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

