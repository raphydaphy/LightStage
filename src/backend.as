package  {
	import flash.display.Stage;
	import flash.events.*;
	import flash.utils.Timer;
	
	import G;

	public class backend {
		
		public function reset():void //reset game
		{
			G.vars.resetting = true;
			if (G.vars.result == "NEW") // if it is the first game the user has played
			{
				G.vars.spawnCoins = true;
				G.vars.startupMsg = "LightStage is starting..."; // show the initial starting message
				G.vars.result = "RESTART"; // prepare the next loading message so that it isn't always the default
			}
			else if (G.vars.result == "DIED") // if the user died on their last turn
			{
				G.vars.deaths += 1;
				G.vars.spawnCoins = false;
				G.vars.startupMsg = "You died!"; // the text on the loading screen should be 'You died!'
				G.vars.level = 1;
			}
			else if (G.vars.result == "WON") // if the user completed the last G.vars.level
			{
				if (G.vars.level - 1 > G.vars.maxLevel) // if this is the best G.vars.level they have reached
				{
					G.vars.maxLevel = G.vars.level - 1;
					G.vars.money += G.vars.level - 1;
					G.vars.spawnCoins = true;
				}
				G.vars.startupMsg = "You completed level " + (G.vars.level - 1) + "!"; // show the user what G.vars.level they are on
			}
			else if (G.vars.result == "RESTART") // if the user pressed any key to restart
			{
				G.vars.spawnCoins = false;
				G.vars.startupMsg = "Resetting your level..."; // show the user that the G.vars.level is being reset
			}
			else if (G.vars.result == "OVER") // if the user completed all the G.vars.levels
			{
				G.vars.spawnCoins = true;
				G.vars.startupMsg = "You completed all the levels!";
			}
			else // if the reason for the reset is unknown
			{
				G.vars.spawnCoins = false;
				G.vars.startupMsg = "LightStage is starting..."; // show the default message
			}
			for (var destroyLine: int = 0; destroyLine < G.vars.lines.length; destroyLine++) // loop through G.vars.lines
			{
				G.vars.lines[destroyLine].destroy(); // destroy delected line (or at least clear it from the screen)
				if (G.vars.lines[destroyLine].stage) { G.vars._stage.removeChild(G.vars.lines[destroyLine]); } // remove from G.vars._stage
			}
			for (var destroyMirror: int = 0; destroyMirror < G.vars.mirrors.length; destroyMirror++) // loop through G.vars.mirrors vector
			{
				G.vars.mirrors[destroyMirror].destroy(); // Kind of destroy the mirror (run the function in the class)
				if (G.vars.mirrors[destroyMirror].stage) { G.vars._stage.removeChild(G.vars.mirrors[destroyMirror]); } // remove mirror from G.vars._stage
			}
			for (var destroyGlobe: int = 0; destroyGlobe < G.vars.globes.length; destroyGlobe++) // loop through all the G.vars.globes
			{
				G.vars.globes[destroyGlobe].resetAll(); // reset the globe
				G.vars.globes[destroyGlobe].destroy(); // destroy the globe
				if (G.vars.globes[destroyGlobe].stage) { G.vars._stage.removeChild(G.vars.globes[destroyGlobe]) } // remove globe from the G.vars._stage
			}
			for (var destroyBomb: int = 0; destroyBomb < G.vars.bombs.length; destroyBomb++) // loop through all the G.vars.bombs
			{
				G.vars.bombs[destroyBomb].destroy(); // destroy the bomb
				if (G.vars.bombs[destroyBomb].stage) { G.vars._stage.removeChild(G.vars.bombs[destroyBomb]) } // remove bomb from the G.vars._stage
			}
			for (var destroyWall: int = 0; destroyWall < G.vars.walls.length; destroyWall++) // loop through all the G.vars.walls
			{
				G.vars.walls[destroyWall].resetAll(); // reset the wall
				G.vars.walls[destroyWall].destroy(); // destroy the wall
				if (G.vars.walls[destroyWall].stage) { G.vars._stage.removeChild(G.vars.walls[destroyWall]) } // remove G.vars.walls from the G.vars._stage
			}
			
			
			for (var destroyCoin: int = 0; destroyCoin < G.vars.coins.length; destroyCoin++) // loop through all the G.vars.coins
			{
				G.vars.coins[destroyCoin].resetAll(); // reset the coin
				if (G.vars.coins[destroyCoin].stage) { G.vars._stage.removeChild(G.vars.coins[destroyCoin]) }
			}
			
			G.vars._stage.removeEventListener(Event.ENTER_FRAME, enterFrame); // stop enterFrame listener
		}
		
		public function enterFrame(event: Event)
		{
			for (var fixWallVis: int = 0; fixWallVis < G.vars.walls.length; fixWallVis++)
			{
				if (!G.vars.walls[fixWallVis].stage &&
					G.vars.walls[fixWallVis].x != -100 &&
					G.vars.walls[fixWallVis].y != -100)
				{
					G.vars._stage.addChild(G.vars.walls[fixWallVis]);
				}
			}
			for (var lineNum: int = 0; lineNum < G.vars.lines.length; lineNum++) // Loop through G.vars.lines vector
			{
				if (G.vars.lines[lineNum].noLoop == false) // Don't loop through G.vars.lines that we don't need anymore
				{
					G.vars.lines[lineNum].loops += 1; // increase the amount of times we have looped over this line
					
					if (G.vars.lines[lineNum].loops > 1 && G.vars.lines[lineNum].disp == true) // if the line has been iterated already
					{
						G.vars.lines[lineNum].noLoop = true; // make sure the line never gets iterated over again
						G.vars._stage.removeChild(G.vars.lines[lineNum]); // remove the line from the stage
					}
					
					var hit: Boolean = false; // Set to true later if the selected line has hit a mirror

					for (var mirrorNum: int = 0; mirrorNum < G.vars.mirrors.length; mirrorNum++) // Iterate G.vars.mirrors
					{
						if (G.vars.lines[lineNum].owner != mirrorNum) // If mirror is not the one that made this line
						{
							if (G.vars.mirrors[mirrorNum].hitTestObject(G.vars.lines[lineNum])) // If mirror is touching line
							{
								for (var hitMirror: int = 0; hitMirror < G.vars.mirrors.length; hitMirror++) // iterate again
								{
									if (hitMirror != mirrorNum && G.vars.mirrors[hitMirror].hitTestObject(G.vars.mirrors[mirrorNum]))
									{
										G.vars.mirrors[hitMirror].x = G.vars.mirrors[hitMirror].oX;
										G.vars.mirrors[hitMirror].y = G.vars.mirrors[hitMirror].oY;
									}
								}
								hit = true;
								G.vars.lines[lineNum].draw(G.vars.mirrors[mirrorNum].x, G.vars.mirrors[mirrorNum].y); // Redraw line
								simBounce(G.vars.lines[lineNum], lineNum, G.vars.mirrors[mirrorNum], mirrorNum); // Run this
							}

						}
					}
					
					for (var wallNum: int = 0; wallNum < G.vars.walls.length; wallNum++) // Iterate G.vars.walls
					{
						if (G.vars.walls[wallNum].hitTestObject(G.vars.lines[lineNum])) // If wall is touching line
						{
							hit = true;
							G.vars.lines[lineNum].draw(G.vars.walls[wallNum].x, G.vars.walls[wallNum].y); // Redraw line
							G.vars.walls[wallNum].gotoAndStop(2);
							G.vars.walls[wallNum].blocking = true;
							bringToFront(G.vars.walls[wallNum]);
						}
					}
					
					if (!hit) // If there was no G.vars.mirrors or G.vars.walls interfering with the selected line
					{
						G.vars.lines[lineNum].reset(); // Reset the line to the origional X and Y values
						if (G.vars.lines[lineNum].stage && // If the line is on the G.vars._stage
							G.vars.lines[lineNum].disp == true && // If the line is disposible (not base line)
							lineNum != G.vars.lines.length - 1) // If it is not within the last 1 G.vars.lines made
						{
							G.vars._stage.removeChild(G.vars.lines[lineNum]); // Remove the line from the G.vars._stage
							G.vars.lines[lineNum].rmLoop(); // Remove it from ever being iterated over again
						}
					}
					
					for (var globeNum: int = 0; globeNum < G.vars.globes.length; globeNum++) //iterate through G.vars.globes
					{
						if (G.vars.lines[lineNum].hitTestObject(G.vars.globes[globeNum])) // If the line is touching the selected globe
						{
							G.vars.globes[globeNum].hit = true;
							G.vars.globes[globeNum].filling = true; // tell that globe that it has been hit by a line
							G.vars.globes[globeNum].startFill(); // start filling that globe using it's function
						}
					}
					
					for (var coinNum: int = 0; coinNum < G.vars.coins.length; coinNum++) //iterate through G.vars.coins
					{
						if (G.vars.lines[lineNum].hitTestObject(G.vars.coins[coinNum])) // If the line is touching the selected coin
						{
							G.vars.coins[coinNum].hit = true;
							G.vars.coins[coinNum].filling = true; // tell thatcoin that it has been hit by a line
							G.vars.coins[coinNum].startFill(); // start filling that coin using it's function
						}
					}
					
					for (var bombNum: int = 0; bombNum < G.vars.bombs.length; bombNum++) //iterate through G.vars.globes
					{
						if (G.vars.bombs[bombNum].exploded == true)
						{
							if (G.vars.playerItems.indexOf("bomb deflect chance") != -1 && // if they have bomb defence chance
								Math.round(Math.random())) // if they are lucky and manage to dodge the bomb
							{
								G.vars.bombs[bombNum].resetAll();
								G.vars.bombs[bombNum].destroy();
								if (G.vars.bombs[bombNum].stage) { G.vars._stage.removeChild(G.vars.bombs[bombNum]); }
								G.vars.escaped += 1;
							}
							else // if they don't have bomb deflect chance, or didn't manage to deflect the bomb (50% chance)
							{
								G.vars.result = "DIED";
								reset();
								prepGame();
							}
						}
						else if (G.vars.lines[lineNum].hitTestObject(G.vars.bombs[bombNum])) // If the line is touching the selected globe
						{
							if (G.vars.bombs[bombNum].exploding == false)
							{
								G.vars.detonated += 1;
							}
							G.vars.bombs[bombNum].startExplode();
						}
					}
				}
			}
			var fullGlobes: int = 0; // set the number of full G.vars.globes to 0
			
			for (var checkGlobe: int = 0; checkGlobe < G.vars.globes.length; checkGlobe++) //iterate through G.vars.globes
			{
				if (G.vars.globes[checkGlobe].full == true) // If the selected globe is full
				{
					fullGlobes++; // increase the total number of G.vars.globes that are full
				}
				if (G.vars.globes[checkGlobe].hit == false) // If the globe didn't get hit by a beam last iteration
				{
					G.vars.globes[checkGlobe].filling = false; // set the globe's filling property to false
					G.vars.globes[checkGlobe].resetAll(); // reset the selected globe
				}
				G.vars.globes[checkGlobe].hit = false;
			}
			if (fullGlobes == G.vars.globes.length) // if all the G.vars.globes are full
			{
				G.vars.result = "WON"; // record that the user won
				levelUp(); // run the G.vars.levelUp function to go to the next G.vars.level
			}
			
			
			for (var checkCoin: int = 0; checkCoin < G.vars.coins.length; checkCoin++) //iterate through G.vars.coins
			{
				if (G.vars.coins[checkCoin].full == true && G.vars.coins[checkCoin].stage) // If the selected globe is full
				{
					if (G.vars.playerItems.indexOf("double G.vars.coins") == -1) // if the player dosen't own the double G.vars.coins upgrade
					{
						G.vars.money += 1; // increase G.vars.money by one coin
					}
					else // if they do own the double G.vars.coins upgrade
					{
						G.vars.money += 2;
					}
					G.vars._root.safeUpdateText(false);
					G.vars.coins[checkCoin].resetAll(); // reset selected coin
					G.vars._stage.removeChild(G.vars.coins[checkCoin]); // remove the coin from the G.vars._stage
				}
				if (G.vars.coins[checkCoin].hit == false) // If the coin didn't get hit by a beam last iteration
				{
					G.vars.coins[checkCoin].filling = false; // set the coin's filling property to false
					G.vars.coins[checkCoin].resetAll(); // reset the selected coin
				}
				G.vars.coins[checkCoin].hit = false; // set the hit property to false so that it is only reflecting the last loop
			}
			
			for (var checkWall: int = 0; checkWall < G.vars.walls.length; checkWall++) // Iterate G.vars.walls
			{
				if (G.vars.walls[checkWall].blocking == false) // If wall is not touching any line
				{
					G.vars.walls[checkWall].gotoAndStop(1);
				}
				G.vars.walls[checkWall].blocking = false;
			}
			
			G.vars.badges.checkBadges(); // check if they should get any new G.vars.badges
			
			if (G.vars.badgeManager1.stage)
			{
				bringToFront(G.vars.badgeManager1);
			}
			
			if (G.vars.badgeManager2.stage)
			{
				bringToFront(G.vars.badgeManager2);
			}
			
			if (G.vars.playerShop.stage)
			{
				bringToFront(G.vars.playerShop);
			}
			
			if (G.vars.dialog.stage)
			{
				bringToFront(G.vars.dialog);
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
											   'y', 'RIGHT', mirrorNum, G.vars.lines[lineNum].lineColor);
							break;
						case 2: // A type 2 mirror hitting a line going up should bounce left
							tmpLine = new line(_mirror.x, _mirror.y, -450, _mirror.y, 
											   'y', 'LEFT', mirrorNum, G.vars.lines[lineNum].lineColor);
							break;
					}
					break;

				case 'DOWN':
					switch (_mirror.currentFrame)
					{
						case 1: // A type 1 mirror hitting a line going down should bounce left
							tmpLine = new line(_mirror.x, _mirror.y, -450, _mirror.y, 
											   'y', 'LEFT', mirrorNum, G.vars.lines[lineNum].lineColor);
							break;
						case 2: // A type 2 mirror hitting a line going down should bounce right
							tmpLine = new line(_mirror.x, _mirror.y, 1000, _mirror.y, 
											   'y', 'RIGHT', mirrorNum, G.vars.lines[lineNum].lineColor);
							break;
					}
					break;
					
				case 'LEFT':
					switch (_mirror.currentFrame)
					{
						case 1: // A type 1 mirror hitting a line going left should bounce down
							tmpLine = new line(_mirror.x, _mirror.y, _mirror.x, 400, 
											   'x', 'DOWN', mirrorNum, G.vars.lines[lineNum].lineColor);
							break;
						case 2: // A type 2 mirror hitting a line going left should bounce up
							tmpLine = new line(_mirror.x, _mirror.y, _mirror.x, 0, 
											   'x', 'UP', mirrorNum, G.vars.lines[lineNum].lineColor);
							break;
					}
					break;

				case 'RIGHT':
					switch (_mirror.currentFrame)
					{
						case 1: // A type 1 mirror hitting a line going right should bounce up
							tmpLine = new line(_mirror.x, _mirror.y, _mirror.x, 0, 
											   'x', 'UP', mirrorNum, G.vars.lines[lineNum].lineColor);
							break;
						case 2: // A type 2 mirror hitting a line going right should bounce down
							tmpLine = new line(_mirror.x, _mirror.y, _mirror.x, 400,
											   'x', 'DOWN', mirrorNum, G.vars.lines[lineNum].lineColor);
							break;
					}
					break;
			}
			if (_line.owner == 9999) // If the line that the mirror hit was put there by the G.vars.level
			{
				G.vars.lines.push(tmpLine); // Add the temporary line to the G.vars.lines vector for looping
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]); // Add the temporary line to the stage
				G.vars.lines[G.vars.lines.length - 1].visible = true; // Make the line visible to the user
			}
			else // If the line that the mirror hit was created by another mirror bounce
			{
				G.vars._stage.addChild(tmpLine); // Add the (invisible) temp line to the stage for hit testing
				var mHit = checkLine(tmpLine); // see if any G.vars.mirrors are in the way of the new line
				
				if (mHit != 'OK') // If a mirror was touching the temporary line
				{
					
					tmpLine.startX = G.vars.mirrors[tmpLine.owner].x; // don't change the start x point of the line
					tmpLine.startY = G.vars.mirrors[tmpLine.owner].y; // also donn't change the starting y point
					
					switch (tmpLine.axis)
					{
						case 'x':
							tmpLine.draw(G.vars.mirrors[tmpLine.owner].x, G.vars.mirrors[mHit].y); // only y axis should change
							break;
						case 'y':
							tmpLine.draw(G.vars.mirrors[mHit].x, G.vars.mirrors[tmpLine.owner].y); // only x axis should change
					}
					
					tmpLine.endMirror = mHit; // set the endMirror of the temporary line to the bad mirror
					
					tmpLine.inter = true;
					tmpLine.update(); // update the origional values of the temporary line so they don't reset
				}
					
				G.vars._stage.removeChild(tmpLine);
				G.vars.lines.push(tmpLine);
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
			}

		}
		
		// This function checks if any G.vars.mirrors are touching the line (passed to the function)
		// To do this, it loops through the G.vars.mirrors vector and returns any that are touching '_line'
		// The line that is being tested must be a child of the stage but dosen't have to be visible
		public function checkLine(_line)
		{
			var returned: Boolean = false;
			for (var mirrorNumber: int = 0; mirrorNumber < G.vars.mirrors.length; mirrorNumber++)
			{
				if (mirrorNumber != _line.owner && mirrorNumber != _line.endMirror) // not the owner mirror
				{
					if (_line.hitTestObject(G.vars.mirrors[mirrorNumber])) // if the mirror is touching the line
					{
						if (returned == false) { return mirrorNumber; } // return the selected mirror number
						returned = true; // make sure we don't return two values
					}
				}
			}
			if (returned == false) { return 'OK'; } // If nothing hit the mirror, return 'OK' as mHit
		}
		
		private function bringToFront(stageItem)
		{
			if (stageItem.stage)
			{
				G.vars._stage.setChildIndex(stageItem, G.vars._stage.numChildren-1);
			}
		}
		
		public function prepGame(): void
		{
			G.vars._root.gotoAndStop(2); // Go to second frame 'LightStage is starting..'
			
			var startGameTimer:Timer = new Timer(3000, 1); // prepare a one second timer to start the game
			startGameTimer.addEventListener(TimerEvent.TIMER, G.vars._root.game); // create a listner for the timer
			startGameTimer.start(); // start the timer
		}
		
		private function levelUp(): void // if the user completes the previous G.vars.level
		{
			G.vars.level += 1;
			reset();
			prepGame();
		}
		
		public function stopEnterFrame(event:TimerEvent)
		{
			G.vars._stage.removeEventListener(Event.ENTER_FRAME, G.vars.backend.enterFrame); // stop enterFrame listener
		}
		
	}
	
}
