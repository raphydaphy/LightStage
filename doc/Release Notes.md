# Release Notes
This page contains information about each minor release of LightStage. LightStage was first added to GitHub when it was in Alpha version 0.13. This page contains information from Alpha 0.01 all the way up to the latest release.

## LightStage 0.3 Final
- You can click to start the game now
- The overlay glitch in issue #1 is FINALLY fixed
- You can skip the tutorial
- You only get the Student badge if you actually do the tutorial
- You can't restart the game using the spacebar

## LightStage 0.3 Beta 3
- All the game levels have been remade up to level 6
- The menu button only shows up when the tutorial is finished
- Changed the game licence 
- Added 'heavy' mirrors that can't be dragged from issue #42 
- Added a menu button to easily access the shop, level editor and level chooser
- Added a level selector that lets you go back to levels you have already completed
- Bombs no longer take you back to level 1
- Spending Spree 1 now is awarded after three purchases
- Added Spending Spree 2 badge for 6 purchases in the shop

## LightStage 0.3 Beta 2
- Fixed useless next page buttons in the shop in issue #17
- Added Remove Bomb in the shop for $10 in-game money
- Added Skip Level in the shop for $25 in-game money
- Fixed Remove Bomb glitch in issue #38 
- Fixed tutorial level 1 glitch in issue #37
- Fixed opening shop glitch in issue #39

## LightStage 0.3 Beta 1
- Added a tutorial at the start of the game from issue #32 

## LightStage 0.2 Final
- Gave mirrors a hit-box to prevent you from dying due to a glitch
- Fixed light bending glitch in issue #36 which was caused by an error in 0.2 Beta 3

## LightStage 0.2 Beta 3
- Finished adding refractors and closed issue #33 
- Every single possible light direction and mirror combination now works
- Mirrors have been enlarged to make them easier to drag
- Added rotated versions of refractors
- Properly implemented all rotations of the standard, flat mirrors

## LightStage 0.2 Beta 2
- Added two new rotation states of the standard mirror, made one of them work (Frame 2)
- Added refractors from issue #33 but still work needed to close the issue
- Made non-straight collisions possible from issue #34
- Fixed collisions crash from issue #35
- Closed mirror enhancement from issue #4 and replaced with seperate issues for each kind of mirror

## LightStage 0.2 Beta 1
- Fixed duplicate badge glitch in issue #31
- Fixed corner mirror visibility glitch in issue #30
- Fixed double coins upgrade glitch in issue #29
- Fixed flashlights not visible in fullscreen glitch in issue #28
- Fixed infinite purchase glitch in issue #27
- Fixed bomb deflect chance glitch in issue #26
- Fixed badge crash in issue #25
- Fixed shop glitch in issue #24

## LightStage 0.1 Final
- Globalised everything & added new files for different functions!
- Fixed wall invisibility glitch from issue #16 
- Fixed stage rewrite crash in issue #23 

## LightStage 0.1 Beta 4
- Badge system awards you with a badge & money for completing achievements
- Fixed badge display glitch in issue #22
- Fixed wall blocking glitch in issue #21
- Fixed bomb damage glitch in issue #20
- Fixed mirror crash in issue #19
- Fixed shop glitch in issue #18
- Fixed level changing cash in issue #15

## LightStage 0.1 Beta 3
- Added an option to test levels made in the level editor by pressing T
- Added an option to pick core line direction in level editor

## LightStage 0.1 Beta 2
- Fixed overlay glitch in issue #1
- Added 7th level
- Fixed standalone SWF glitch in issue #6
- Nerfed upgrade costs as they used to be too OP
- Fixed glitch were walls don't stop blocking light after completing the level

## LightStage 0.1 Beta 1
- Fixed bendy line glitch in issue #5
- Added simple level editor
- Level editor can generate level code
- Added walls to block light
- Added a 4th level

## LightStage Alpha 0.16
- Added Bomb Deflection Chance to the shop
- Fixed infinite coin glitch in issue #3
- You no longer need to restart level after using the shop

## LightStage Alpha 0.15
- Added shop!
- Added Double Coins purchase option to the shop
- Added message boxes

## LightStage Alpha 0.14
- Added coins!
- Added text that shows your current level & coin balance
- You can't get coins multiple times by restarting the level
- Redesigned levels to incorporate coins

## LightStage Alpha 0.13
- Fixed glitch where the game can crash if you don't stop dragging when the frame changes
- Proper winning screen
- Game closes after you win after about 10 seconds
- You can rotate mirrors using the arrow keys (buggy)

## LightStage Alpha 0.12
- Added proper level integration with different things on each level and a level count

## LightStage Alpha 0.11
- Bombs have a tiny delay before blowing up, but you can't stop them once they start
- Different big messages on the loading screen based on their previous result in the game

## LightStage Alpha 0.10
- Random message shown on the game loading screen to teach you more about LightStage
- Added bombs!
- Bombs explode if light hits them

## LightStage Alpha 0.09
- Delete line after only one iteration instead of two to save memory
- Added globes!

## LightStage Alpha 0.08
- Bounced lines don't stop at 0/550 X position, they continue off the screen for 450 units so we have no more line cutoffs.
- We can see all the bounced lines! Finally!
- Removed the need to iterated over the lines vector twice per tick to save memory when running.

## LightStage Alpha 0.07
- Modified line.as to improve commenting and allow different colored lines (not always yellow)
- All core lines automatically get a flashlight icon before them
- Non-core lines have the same color as their parent core line
- Support for multiple core beams!
- Core beam flashlights work for all directions of core beams (UP, DOWN, LEFT & RIGHT) using a switch statement

## LightStage Alpha 0.06
- All mirror bounces work with current mirrors (type 1 & type 2)
- You can have as many mirrors as you want, the bounces will work, but only the first and last light beams show
- Added flashlight icon to the main (core) beam of light to show where it is coming from
- Made light beams extend past the width of the screen so the game looks correct in fullscreen mode as well as small
- Made an intro screen that prompts the user to press any key to play the game
- Allowed resetting the game without closing it by pressing any key

## LightStage Alpha 0.05
- Commented almost every line for superb code readability

## LightStage Alpha 0.04
- Fixed the direction that light goes when hit by different mirrors and added debug text in console
- Cleaned up simBounce code to save memory when running - no need to check line axis when bouncing light

## LightStage Alpha 0.03
- 148 lines shorter due to code simplification and better use of functions in main LightStage.as file

## LightStage Alpha 0.02
- Lines from a non-base beam to another mirror show correctly, unless the mirror is moved
- Line class converted from MovieClip to Sprite to save memory when running because we don't need all the MovieClip features

## LightStage Alpha 0.01
- You can deflect base laser beams
- You can have different deflections for different mirror types (not all directions supported yet)
- You can deflect non-base beams. However, this creates flashing lines and isn't very good yet
