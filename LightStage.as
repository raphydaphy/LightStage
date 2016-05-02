/***************************
LIGHTSTAGE ALPHA 0.13
Built by Raph Hennessy
All Rights Reserved 2nd May 2016
Currently, these features work:
- Deflect base lazer beams
- Different deflections for different mirror types
- Deflecting non-base beams
- Restarting the game & having introduction text before the game starts the first time
- Hit globes with lazer beams to fill them up
- Fill up all the globes to reset the game
- Bombs explode if light hits them
- Level up by completing the current level
- Different loading messages for if you died, reset the game or completed the level
- The R key can be used to reset the level
- The user is informed when they win the game and the game closes shortly after
- Rotate mirrors using the arrow keys (buggy)

Changes from LightStage Alpha 0.12:
- Fixed glitch where the game can crash if you don't stop dragging when the frame changes
- Proper winning screen
- Game closes after you win after about 10 seconds
- You can rotate mirrors using the arrow keys (buggy)
***************************/
package
{
	import flash.events.* // Import all flash event modules for enterFrame, mouseEvent etc..
	import flash.display.MovieClip;  // The mirrors are movieclips, so we need their library
	import flash.utils.Timer; // We need the timer library for the one second game start delay
	import flash.ui.Keyboard; // We need this for controlling the keyboard events
	import flash.system.fscommand; // We need this to stop the game when you win
	
	[SWF(backgroundColor = "0x1abc9c")] // Set the background color to turquoise
	
	public class LightStage extends MovieClip // Main class declaration for the LightStage game
	{
		public var mirrors: Vector.<mirror> = new Vector.<mirror>(); // vector for the mirror movieclips
		public var lines: Vector.<line> = new Vector.<line>(); // this vector stores all the line sprites
		public var globes: Vector.<globe> = new Vector.<globe>(); // vector to store all the globes
		public var bombs: Vector.<bomb> = new Vector.<bomb>(); // vector to store all the bomb movieclips
		
		public var result: String = "NEW"; // what happened in the last game that was played?
		public var level: int = 1 // What level is the user up to?
		
		private var lastDragged: int;
		
		public function LightStage() // The initialization function that sets up the game
		{
			gotoAndStop(1); // go to the first frame 'Welcome to LightStage'
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler); // start keyHandler listener
		}
		
		private function keyHandler(event:KeyboardEvent): void // if a key is pressed
		{
			var key:uint = event.keyCode;
			var step:uint = 5
			switch (key)
			{
				case Keyboard.SPACE:
					if (result == "NEW")
					{
						reset();
					}
					break;
				case Keyboard.R:
					result = "RESTART"; // make sure the reset function knows that the user restarted the game
					reset(); // reset the game if the R key is pressed
					break;
				case Keyboard.LEFT:
					if (lastDragged || lastDragged == 0)
					{
						mirrors[lastDragged].rotateBackwards();
					}
					break;
				case Keyboard.RIGHT:
					if (lastDragged || lastDragged == 0)
					{
						mirrors[lastDragged].rotateForwards();
					}
			}
			
		}
		
		private function levelUp(): void // if the user completes the previous level
		{
			level += 1;
			reset();
		}
		
		private function prepGame(): void
		{
			gotoAndStop(2); // Go to second frame 'LightStage is starting..'
			
			var startGameTimer:Timer = new Timer(3000, 1); // prepare a one second timer to start the game
			startGameTimer.addEventListener(TimerEvent.TIMER, game); // create a listner for the timer
			startGameTimer.start(); // start the timer
		}
		
		private function reset():void //reset game
		{
			if (result == "NEW") // if it is the first game the user has played
			{
				startupMsg = "LightStage is starting..."; // show the initial starting message
				result = "RESTART"; // prepare the next loading message so that it isn't always the default
			}
			else if (result == "DIED") // if the user died on their last turn
			{
				startupMsg = "You died!"; // the text on the loading screen should be 'You died!'
			}
			else if (result == "WON") // if the user completed the last level
			{
				startupMsg = "You completed level " + (level - 1) + "!"; // show the user what level they are on
			}
			else if (result == "RESTART") // if the user pressed any key to restart
			{
				startupMsg = "Resetting your level..."; // show the user that the level is being reset
			}
			else if (result == "OVER") // if the user completed all the levels
			{
				startupMsg = "You completed all the levels!";
			}
			else // if the reason for the reset is unknown
			{
				startupMsg = "LightStage is starting..."; // show the default message
			}
			for (var destroyLine: int = 0; destroyLine < lines.length; destroyLine++) // loop through lines
			{
				lines[destroyLine].destroy(); // destroy delected line (or at least clear it from the screen)
				if (lines[destroyLine].stage) { stage.removeChild(lines[destroyLine]); } // remove from stage
			}
			for (var destroyMirror: int = 0; destroyMirror < mirrors.length; destroyMirror++) // loop through mirrors vector
			{
				mirrors[destroyMirror].destroy(); // Kind of destroy the mirror (run the function in the class)
				if (mirrors[destroyMirror].stage) { stage.removeChild(mirrors[destroyMirror]); } // remove mirror from stage
			}
			for (var destroyGlobe: int = 0; destroyGlobe < globes.length; destroyGlobe++) // loop through all the globes
			{
				globes[destroyGlobe].resetAll(); // reset the globe
				if (globes[destroyGlobe].stage) { stage.removeChild(globes[destroyGlobe]) } // remove globe from the stage
			}
			for (var destroyBomb: int = 0; destroyBomb < bombs.length; destroyBomb++) // loop through all the bombs
			{
				if (bombs[destroyBomb].stage) { stage.removeChild(bombs[destroyBomb]) } // remove bomb from the stage
			}
			
			stage.removeEventListener(Event.ENTER_FRAME, enterFrame); // stop enterFrame listener
			
			prepGame();
		}
		
		private function game(event:TimerEvent):void // start the game
		{
			if (result == "OVER") // if the user has won the game
			{
				fscommand("quit"); // exit the game
			}
			gotoAndStop(3); // Go to blank frame to start the game on
			
			mirrors = new Vector.<mirror>(); // setup mirrors vector
			lines = new Vector.<line>(); // setup lines vector
			globes = new Vector.<globe>(); // setup globes vector
			bombs = new Vector.<bomb>(); // setup bombs vector
			
			if (level == 1) // if the user is on level 1
			{
				mirrors.push(new mirror(150, 350)); // Make a testing mirror to deflect UP / RIGHT
				stage.addChild(mirrors[0]); // Add the new mirror to the stage
				
				mirrors.push(new mirror(250, 350)); // Make a nw mirror
				stage.addChild(mirrors[1]); // Add the new mirror to the stage
				
				globes.push(new globe(200, 250)); // add a new globe to the globes array
				stage.addChild(globes[0]); // add the new globe to the stage
				
				globes.push(new globe(250, 250)); // add a new globe to the globes array
				stage.addChild(globes[1]); // add the new globe to the stage
				
				lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, 0xe67e22, false, false)); // add core line
				lines[0].visible = true; // Make the baseline visible
				stage.addChild(lines[0]); // Add baseline to the stage
			}
			else if (level == 2)
			{
				mirrors.push(new mirror(450, 200)); // Make a mirror
				stage.addChild(mirrors[0]); // Add the new mirror to the stage
				
				mirrors.push(new mirror(450, 300)); // Make a mirror
				stage.addChild(mirrors[1]); // Add the new mirror to the stage
				
				globes.push(new globe(225, 300)); // add a new globe to the globes vector
				stage.addChild(globes[0]); // add the new globe to the stage
				
				bombs.push(new bomb(300, 300)); // make a new bomb
				stage.addChild(bombs[0]); // add the new bomb to the stage
				
				lines.push(new line(400, 370, 400, 0, 'x', 'UP', 9999, 0xecf0f1, false, false)); // add core line
				lines[0].visible = true; // Make the baseline visible
				stage.addChild(lines[0]); // Add baseline to the stage
			}
			else if (level == 3)
			{
				mirrors.push(new mirror(191, 300)); // Make a new mirror
				stage.addChild(mirrors[0]); // Add the new mirror to the stage
				
				mirrors.push(new mirror(332, 300)); // Make a new mirror
				stage.addChild(mirrors[1]); // Add the new mirror to the stage
				
				mirrors.push(new mirror(498, 300)); // Make a new mirror
				stage.addChild(mirrors[2]); // Add the new mirror to the stage
				
				globes.push(new globe(191, 250)); // add a new globe to the globes array
				stage.addChild(globes[0]); // add the new globe to the stage
				
				globes.push(new globe(498, 250)); // add a new globe to the globes array
				stage.addChild(globes[1]); // add the new globe to the stage
				
				bombs.push(new bomb(332, 235)); // add a new bomb to the bombs array
				stage.addChild(bombs[0]); // add the new globe to the stage
				
				bombs.push(new bomb(332, 270)); // add a new bomb to the bombs array
				stage.addChild(bombs[1]); // add the new globe to the stage
				
				lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, 0x8e44ad, false, false)); // add core line
				lines[0].visible = true; // Make the baseline visible
				stage.addChild(lines[0]); // Add baseline to the stage
			}
			else
			{
				trace('You win!');
				result = "OVER";
				reset();
			}
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrame); // Start enterFrame listener
		}

		// This function is called once every milisecond, unless it takes longer than that to run
		// In that case, it is called when it finishes running. Essentially, it runs once each tick.
		private function enterFrame(event: Event)
		{
			for (var lineNum: int = 0; lineNum < lines.length; lineNum++) // Loop through lines vector
			{
				if (lines[lineNum].noLoop == false) // Don't loop through lines that we don't need anymore
				{
					lines[lineNum].loops += 1; // increase the amount of times we have looped over this line
					
					if (lines[lineNum].loops > 1 && lines[lineNum].disp == true) // if the line has been iterated already
					{
						lines[lineNum].noLoop = true; // make sure the line never gets iterated over again
						stage.removeChild(lines[lineNum]); // remove the line from the stage
					}
					
					var hit: Boolean = false; // Set to true later if the selected line has hit a mirror

					for (var mirrorNum: int = 0; mirrorNum < mirrors.length; mirrorNum++) // Iterate mirrors
					{
						if (mirrors[mirrorNum].dragging == true) // if the mirror is currently being dragged
						{
							lastDragged = mirrorNum;
						}
						if (lines[lineNum].owner != mirrorNum) // If mirror is not the one that made this line
						{
							if (mirrors[mirrorNum].hitTestObject(lines[lineNum])) // If mirror is touching line
							{
								hit = true;
								lines[lineNum].draw(mirrors[mirrorNum].x, mirrors[mirrorNum].y); // Redraw line
								simBounce(lines[lineNum], lineNum, mirrors[mirrorNum], mirrorNum); // Run this
							}

						}
					}
					if (!hit) // If there was no mirrors interfering with the selected line
					{
						lines[lineNum].reset(); // Reset the line to the origional X and Y values
						if (lines[lineNum].stage && // If the line is on the stage
							lines[lineNum].disp == true && // If the line is disposible (not base line)
							lineNum != lines.length - 1) // If it is not within the last 1 lines made
						{
							stage.removeChild(lines[lineNum]); // Remove the line from the stage
							lines[lineNum].rmLoop(); // Remove it from ever being iterated over again
						}
					}
					
					for (var globeNum: int = 0; globeNum < globes.length; globeNum++) //iterate through globes
					{
						if (lines[lineNum].hitTestObject(globes[globeNum])) // If the line is touching the selected globe
						{
							globes[globeNum].hit = true;
							globes[globeNum].filling = true; // tell that globe that it has been hit by a line
							globes[globeNum].startFill(); // start filling that globe using it's function
						}
					}
					
					for (var bombNum: int = 0; bombNum < bombs.length; bombNum++) //iterate through globes
					{
						if (bombs[bombNum].exploded == true)
						{
							result = "DIED";
							reset();
						}
						else if (lines[lineNum].hitTestObject(bombs[bombNum])) // If the line is touching the selected globe
						{
							bombs[bombNum].startExplode();
						}
					}
				}
			}
			var fullGlobes: int = 0; // set the number of full globes to 0
			
			for (var checkGlobe: int = 0; checkGlobe < globes.length; checkGlobe++) //iterate through globes
			{
				if (globes[checkGlobe].full == true) // If the selected globe is full
				{
					fullGlobes++; // increase the total number of globes that are full
				}
				if (globes[checkGlobe].hit == false) // If the globe didn't get hit by a beam last iteration
				{
					globes[checkGlobe].filling = false; // set the globe's filling property to false
					globes[checkGlobe].resetAll(); // reset the selected globe
				}
				globes[checkGlobe].hit = false;
			}
			if (fullGlobes == globes.length) // if all the globes are full
			{
				result = "WON"; // record that the user won
				levelUp(); // run the levelUp function to go to the next level
			}
		}

		// This function simulates a bounce, creates a temporary, invisible line
		// to test for colisions, stops the line at the collision point if any
		// is found, adds the new, fixed line to the stage and returns void
		public function simBounce(_line: line, lineNum: int, _mirror: mirror, mirrorNum: int): void
		{
			var tmpLine: line; // Note: stage width is 550, height is 400
			
			switch (_line.dir) // Switch between the possible directions the interfering line can be going in
			{
				case 'UP':
					switch (_mirror.currentFrame)
					{
						case 1: // A type 1 mirror hitting a line going up should bounce right
							tmpLine = new line(_mirror.x, _mirror.y, 1000, _mirror.y, 
											   'y', 'RIGHT', mirrorNum, lines[lineNum].lineColor);
							break;
						case 2: // A type 2 mirror hitting a line going up should bounce left
							tmpLine = new line(_mirror.x, _mirror.y, -450, _mirror.y, 
											   'y', 'LEFT', mirrorNum, lines[lineNum].lineColor);
							break;
					}
					break;

				case 'DOWN':
					switch (_mirror.currentFrame)
					{
						case 1: // A type 1 mirror hitting a line going down should bounce left
							tmpLine = new line(_mirror.x, _mirror.y, -450, _mirror.y, 
											   'y', 'LEFT', mirrorNum, lines[lineNum].lineColor);
							break;
						case 2: // A type 2 mirror hitting a line going down should bounce right
							tmpLine = new line(_mirror.x, _mirror.y, 1000, _mirror.y, 
											   'y', 'RIGHT', mirrorNum, lines[lineNum].lineColor);
							break;
					}
					break;
					
				case 'LEFT':
					switch (_mirror.currentFrame)
					{
						case 1: // A type 1 mirror hitting a line going left should bounce down
							tmpLine = new line(_mirror.x, _mirror.y, _mirror.x, 400, 
											   'x', 'DOWN', mirrorNum, lines[lineNum].lineColor);
							break;
						case 2: // A type 2 mirror hitting a line going left should bounce up
							tmpLine = new line(_mirror.x, _mirror.y, _mirror.x, 0, 
											   'x', 'UP', mirrorNum, lines[lineNum].lineColor);
							break;
					}
					break;

				case 'RIGHT':
					switch (_mirror.currentFrame)
					{
						case 1: // A type 1 mirror hitting a line going right should bounce up
							tmpLine = new line(_mirror.x, _mirror.y, _mirror.x, 0, 
											   'x', 'UP', mirrorNum, lines[lineNum].lineColor);
							break;
						case 2: // A type 2 mirror hitting a line going right should bounce down
							tmpLine = new line(_mirror.x, _mirror.y, _mirror.x, 400,
											   'x', 'DOWN', mirrorNum, lines[lineNum].lineColor);
							break;
					}
					break;
			}
			if (_line.owner == 9999) // If the line that the mirror hit was put there by the level
			{
				lines.push(tmpLine); // Add the temporary line to the lines vector for looping
				stage.addChild(lines[lines.length - 1]); // Add the temporary line to the stage
				lines[lines.length - 1].visible = true; // Make the line visible to the user
			}
			else // If the line that the mirror hit was created by another mirror bounce
			{
				stage.addChild(tmpLine); // Add the (invisible) temp line to the stage for hit testing
				var mHit = checkLine(tmpLine); // see if any mirrors are in the way of the new line
				
				if (mHit != 'OK') // If a mirror was touching the temporary line
				{
					
					tmpLine.startX = mirrors[tmpLine.owner].x; // don't change the start x point of the line
					tmpLine.startY = mirrors[tmpLine.owner].y; // also donn't change the starting y point
					
					tmpLine.draw(mirrors[mHit].x, mirrors[mHit].y); // redraw the line to hit the bad mirror
					tmpLine.endMirror = mHit; // set the endMirror of the temporary line to the bad mirror
					
					tmpLine.inter = true;
					tmpLine.update(); // update the origional values of the temporary line so they don't reset
				}
					
				stage.removeChild(tmpLine);
				lines.push(tmpLine);
				lines[lines.length - 1].visible = true;
				stage.addChild(lines[lines.length - 1]);
			}

		}
		
		// This function checks if any mirrors are touching the line (passed to the function)
		// To do this, it loops through the mirrors vector and returns any that are touching '_line'
		// The line that is being tested must be a child of the stage but dosen't have to be visible
		public function checkLine(_line)
		{
			var returned: Boolean = false;
			for (var mirrorNumber: int = 0; mirrorNumber < mirrors.length; mirrorNumber++)
			{
				if (mirrorNumber != _line.owner && mirrorNumber != _line.endMirror) // not the owner mirror
				{
					if (_line.hitTestObject(mirrors[mirrorNumber])) // if the mirror is touching the line
					{
						if (returned == false) { return mirrorNumber; } // return the selected mirror number
						returned = true; // make sure we don't return two values
					}
				}
			}
			if (returned == false) { return 'OK'; } // If nothing hit the mirror, return 'OK' as mHit
		}
	}
	
}