# Release Notes
This page contains information about each minor release of LightStage. LightStage was first added to GitHub when it was in Alpha version 0.13. This page contains information from Alpha 0.01 all the way up to the latest release.

## Alpha 0.15
- Added shop!
- Added Double Coins purchase option to the shop
- Added message boxes

## Alpha 0.14
- Added coins!
- Added text that shows your current level & coin balance
- You can't get coins multiple times by restarting the level
- Redesigned levels to incorporate coins

## Alpha 0.13
- Fixed glitch where the game can crash if you don't stop dragging when the frame changes
- Proper winning screen
- Game closes after you win after about 10 seconds
- You can rotate mirrors using the arrow keys (buggy)

## Alpha 0.12
- Added proper level integration with different things on each level and a level count

## Alpha 0.11
- Bombs have a tiny delay before blowing up, but you can't stop them once they start
- Different big messages on the loading screen based on their previous result in the game

## Alpha 0.10
- Random message shown on the game loading screen to teach you more about LightStage
- Added bombs!
- Bombs explode if light hits them

## Alpha 0.09
- Delete line after only one iteration instead of two to save memory
- Added globes!

## Alpha 0.08
- Bounced lines don't stop at 0/550 X position, they continue off the screen for 450 units so we have no more line cutoffs.
- We can see all the bounced lines! Finally!
- Removed the need to iterated over the lines vector twice per tick to save memory when running.

## Alpha 0.07
- Modified line.as to improve commenting and allow different colored lines (not always yellow)
- All core lines automatically get a flashlight icon before them
- Non-core lines have the same color as their parent core line
- Support for multiple core beams!
- Core beam flashlights work for all directions of core beams (UP, DOWN, LEFT & RIGHT) using a switch statement

## Alpha 0.06
- All mirror bounces work with current mirrors (type 1 & type 2)
- You can have as many mirrors as you want, the bounces will work, but only the first and last light beams show
- Added flashlight icon to the main (core) beam of light to show where it is coming from
- Made light beams extend past the width of the screen so the game looks correct in fullscreen mode as well as small
- Made an intro screen that prompts the user to press any key to play the game
- Allowed resetting the game without closing it by pressing any key

## Alpha 0.05
- Commented almost every line for superb code readability

## Alpha 0.04
- Fixed the direction that light goes when hit by different mirrors and added debug text in console
- Cleaned up simBounce code to save memory when running - no need to check line axis when bouncing light

## Alpha 0.03
- 148 lines shorter due to code simplification and better use of functions in main LightStage.as file

## Alpha 0.02
- Lines from a non-base beam to another mirror show correctly, unless the mirror is moved
- Line class converted from MovieClip to Sprite to save memory when running because we don't need all the MovieClip features

## Alpha 0.01
- You can deflect base laser beams
- You can have different deflections for different mirror types (not all directions supported yet)
- You can deflect non-base beams. However, this creates flashing lines and isn't very good yet