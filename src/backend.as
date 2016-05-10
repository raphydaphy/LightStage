package  {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	import G;

	public class backend {

		public function reset():void //reset game
		{
			G.vars.resetting = true;
			
			if (G.vars.tutorial == true)
			{
				G.vars.mirrorDown = false;
				
				if (G.vars.hint1.stage) 
				{ 
					G.vars._stage.removeChild(G.vars.hint1); 
				}
				
				if (G.vars.level == 6)
				{
					if (G.vars.result == "WON")
					{
						G.vars.startupMsg = "You completed all the tutorials!";
						G.vars.badges.showBadge("Student","Complete all the tutorials.",4,6);
						G.vars.spawnCoins = true;
						G.vars.level = 1;
						G.vars.tutorial = false;
					}
					else if (G.vars.result == "DIED")
					{
						G.vars.spawnCoins = true;
						G.vars.startupMsg = "You died! Try again...";
					}
				}
				else if (G.vars.result == "WON")
				{
					G.vars.spawnCoins = true;
					G.vars.startupMsg = "You completed the tutorial!";
				}
				else if (G.vars.result == "DIED")
				{
					G.vars.spawnCoins = true;
					G.vars.startupMsg = "You died! Try again...";
				}
			}
			else if (G.vars.result == "NEW") // if it is the first game the user has played
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
				if (G.vars.lines[lineNum].noLoop == false && // Don't loop through lines that we don't need anymore
					(G.vars.lines[lineNum].startX != -100 && // if the line is not a super temporary line
					G.vars.lines[lineNum].startY != -100 && // same as above
					G.vars.lines[lineNum].endX != -100 && // also same as above :)
					G.vars.lines[lineNum].endY != -100))
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
							G.vars.mirrors[mirrorNum].hitbox.visible = true;
							if (G.vars.collisiontest.collision(G.vars.mirrors[mirrorNum],G.vars.lines[lineNum]))
							{
								if (G.vars.tutorial == true && G.vars.tutstage < 5 && G.vars.level == 1)
								{
									G.vars.tutstage = 5;
									G.vars.hint1.gotoAndStop(3);
									G.vars.hint1.hint.text = "deflect the laser onto the globe to win.";
									G.vars.hint1.x = 100;
									G.vars.hint1.y = 289;
								}
								for (var hitMirror: int = 0; hitMirror < G.vars.mirrors.length; hitMirror++) // iterate again
								{
									if (hitMirror != mirrorNum && 
										G.vars.collisiontest.collision(G.vars.mirrors[hitMirror],G.vars.mirrors[mirrorNum]))
									{
										G.vars.mirrors[hitMirror].x = G.vars.mirrors[hitMirror].oX;
										G.vars.mirrors[hitMirror].y = G.vars.mirrors[hitMirror].oY;
									}
								}
								hit = true;
								G.vars.lines[lineNum].draw(G.vars.mirrors[mirrorNum].x, G.vars.mirrors[mirrorNum].y); // Redraw line
								simBounce(G.vars.lines[lineNum], lineNum, G.vars.mirrors[mirrorNum], mirrorNum); // Run this
							}
							G.vars.mirrors[mirrorNum].hitbox.visible = false;
						}
					}
					
					for (var wallNum: int = 0; wallNum < G.vars.walls.length; wallNum++) // Iterate G.vars.walls
					{
						if (G.vars.collisiontest.collision(G.vars.walls[wallNum],G.vars.lines[lineNum]))
						{
							hit = true;
							G.vars.lines[lineNum].draw(G.vars.walls[wallNum].x, G.vars.walls[wallNum].y); // Redraw line
							G.vars.walls[wallNum].gotoAndStop(2);
							G.vars.walls[wallNum].blocking = true;
							bringToFront(G.vars.walls[wallNum]);
						}
					}
					
					if (!hit) // If there was no mirrors or walls interfering with the selected line
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
						if (G.vars.collisiontest.collision(G.vars.lines[lineNum], G.vars.globes[globeNum]))
						{
							if (G.vars.tutorial == true && G.vars.level == 1 && G.vars.tutstage < 6)
							{
								G.vars.tutstage = 6;
								G.vars.hint1.gotoAndStop(4);
								G.vars.hint1.hint.text = "don't move the mirror while the globe fills up.";
								G.vars.hint1.x = 450;
								G.vars.hint1.y = 289;
							}
							G.vars.globes[globeNum].hit = true;
							G.vars.globes[globeNum].filling = true; // tell that globe that it has been hit by a line
							G.vars.globes[globeNum].startFill(); // start filling that globe using it's function
						}
						
					}
					
					if (G.vars.spawnCoins == true)
					{
						for (var coinNum: int = 0; coinNum < G.vars.coins.length; coinNum++) //iterate through G.vars.coins
						{
							if (G.vars.collisiontest.collision(G.vars.lines[lineNum],G.vars.coins[coinNum]))
							{
								if (G.vars.tutorial == true && G.vars.level == 3)
								{
									G.vars.tutstage = 4;
									G.vars.hint1.gotoAndStop(5);
									G.vars.hint1.hint.text = "press 's' to open the shop and spend your coins.";
									G.vars._root.safeUpdateText();
									G.vars.hint1.x = 380;
									G.vars.hint1.y = 120;
								}
								G.vars.coins[coinNum].hit = true;
								G.vars.coins[coinNum].filling = true; // tell thatcoin that it has been hit by a line
								G.vars.coins[coinNum].startFill(); // start filling that coin using it's function
							}
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
						else if (G.vars.collisiontest.collision(G.vars.lines[lineNum],G.vars.bombs[bombNum]))
						{
							if (G.vars.bombs[bombNum].exploding == false)
							{
								G.vars.detonated += 1;
							}
							G.vars.bombs[bombNum].startExplode();
						}
					}
				}
				else if (G.vars.lines[lineNum].noLoop == false)
				{
					if (G.vars.lines[lineNum].stage)
					{
						G.vars._stage.removeChild(G.vars.lines[lineNum]);
					}
				}
			}
			var fullGlobes: int = 0; // set the number of globes to 0
			
			for (var checkGlobe: int = 0; checkGlobe < G.vars.globes.length; checkGlobe++) //iterate globes
			{
				if (G.vars.globes[checkGlobe].full == true) // If the selected globe is full
				{
					fullGlobes++; // increase the total number of globes that are full
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
				if (G.vars.tutorial == true && G.vars.tutstage == 6 && G.vars.level == 1)
				{
					G.vars.tutstage = 7;
					if (G.vars.hint1.stage) { G.vars._stage.removeChild(G.vars.hint1); }
				}
				G.vars.result = "WON"; // record that the user won
				levelUp(); // run the G.vars.levelUp function to go to the next G.vars.level
			}
			
			
			for (var checkCoin: int = 0; checkCoin < G.vars.coins.length; checkCoin++) //iterate through G.vars.coins
			{
				if (G.vars.coins[checkCoin].full == true && G.vars.coins[checkCoin].stage) // If the selected globe is full
				{
					if (G.vars.playerItems.indexOf("double coins") == -1) // if the player dosen't own the double G.vars.coins upgrade
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
			
			if (G.vars.tutorial == true && 
				G.vars.level == 1 &&
				G.vars.mirrorDown == true && 
				G.vars.hint1.stage && 
				G.vars.tutstage == 1)
			{
				G.vars.tutstage = 2;
				G.vars.hint1.gotoAndStop(3);
				G.vars.hint1.hint.text = "this is a globe. globes are the key to winning.";
				G.vars.hint1.x = 100;
				G.vars.hint1.y = 289;
				
				if (G.vars.skipTut.stage)
				{
					G.vars._stage.removeChild(G.vars.skipTut);
				}
				
				var tutTimer1:Timer = new Timer(4000, 1);
				tutTimer1.addEventListener(TimerEvent.TIMER, continueTut);
				tutTimer1.start();
			}
			else if (G.vars.tutorial == true && 
				G.vars.level == 3 &&
				G.vars.mirrorDown == true && 
				G.vars.hint1.stage && 
				G.vars.tutstage == 1)
			{
				G.vars.tutstage = 2;
				G.vars.hint1.gotoAndStop(4);
				G.vars.hint1.hint.text = "this is a coin. you can spend coins in the shop.";
				G.vars.hint1.x = 400;
				G.vars.hint1.y = 289;
				
				var tutTimer3:Timer = new Timer(4000, 1);
				tutTimer3.addEventListener(TimerEvent.TIMER, continueTut);
				tutTimer3.start();
			}
			
			else if (G.vars.tutorial == true && 
				G.vars.level == 5 &&
				G.vars.mirrorDown == true && 
				G.vars.hint1.stage && 
				G.vars.tutstage == 1)
			{
				G.vars.tutstage = 2;
				G.vars.hint1.gotoAndStop(3);
				G.vars.hint1.hint.text = "you need to fill up both globes at the same time.";
				G.vars.hint1.x = 310;
				G.vars.hint1.y = 123;
			}
			
			else if (G.vars.tutorial == true &&
					 G.vars.level == 4 &&
					 G.vars.mirrorDown == true &&
					 G.vars.hint1.stage &&
					 G.vars.tutstage == 1)
			{
				G.vars.tutstage = 2;
				G.vars.hint1.gotoAndStop(2);
				G.vars.hint1.hint.text = "this is a wall. light can't go past it.";
				G.vars._root.updateText();
				G.vars.hint1.x = 450;
				G.vars.hint1.y = 200;
				
			}
			
			if (G.vars.badgeManager1.stage)
			{
				bringToFront(G.vars.badgeManager1);
			}
			
			if (G.vars.badgeManager2.stage)
			{
				bringToFront(G.vars.badgeManager2);
			}
			
			if (G.vars.gameMenu.stage)
			{
				bringToFront(G.vars.gameMenu);
			}
			if (G.vars.levelSelect.stage)
			{
				bringToFront(G.vars.levelSelect);
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
		
		public function continueTut(event:TimerEvent)
		{
			if (G.vars.level == 1)
			{
				if (G.vars.tutstage == 2)
				{
					G.vars.tutstage = 3;
					G.vars.hint1.gotoAndStop(2);
					G.vars.hint1.hint.text = "this is a laser beam. it comes from a flashlight.";
					G.vars.hint1.x = 400;
					G.vars.hint1.y = 80;
					
					var tutTimer2:Timer = new Timer(4000, 1);
					tutTimer2.addEventListener(TimerEvent.TIMER, continueTut);
					tutTimer2.start();
				}
				
				else if (G.vars.tutstage == 3)
				{
					G.vars.tutstage = 4;
					G.vars.hint1.gotoAndStop(1);
					G.vars.hint1.hint.text = "drag the mirror onto the laser to continue.";
					G.vars.hint1.x = 400;
					G.vars.hint1.y = 330;
				}
			}
			else if (G.vars.level == 3)
			{
				if (G.vars.tutstage == 2)
				{
					G.vars.tutstage = 3;
					G.vars.hint1.gotoAndStop(2);
					G.vars.hint1.hint.text = "deflect light into the coin to get it.";
					G.vars.hint1.x = 400;
					G.vars.hint1.y = 80;
				}
			}
		}
		
		public function drawUp(_mirrorNum, _lineNum): line
		{
			return new line(G.vars.mirrors[_mirrorNum].x, G.vars.mirrors[_mirrorNum].y, 
							G.vars.mirrors[_mirrorNum].x, -450, 
							'x', 'UP', _mirrorNum, G.vars.lines[_lineNum].lineColor);
		}
		
		public function drawUpLeft(_mirrorNum, _lineNum): line
		{
			return new line(G.vars.mirrors[_mirrorNum].x, G.vars.mirrors[_mirrorNum].y, 
							G.vars.mirrors[_mirrorNum].x - 400, G.vars.mirrors[_mirrorNum].y - 400, 
							'd', 'UP LEFT', _mirrorNum, G.vars.lines[_lineNum].lineColor);
		}
		
		public function drawUpRight(_mirrorNum, _lineNum): line
		{
			return new line(G.vars.mirrors[_mirrorNum].x, G.vars.mirrors[_mirrorNum].y, 
							G.vars.mirrors[_mirrorNum].x + 400, G.vars.mirrors[_mirrorNum].y - 400, 
							'd', 'UP RIGHT', _mirrorNum, G.vars.lines[_lineNum].lineColor);
		}
		
		public function drawDown(_mirrorNum, _lineNum): line
		{
			return new line(G.vars.mirrors[_mirrorNum].x, G.vars.mirrors[_mirrorNum].y, 
							G.vars.mirrors[_mirrorNum].x, 1000, 
							'x', 'DOWN', _mirrorNum, G.vars.lines[_lineNum].lineColor);
		}
		
		public function drawDownLeft(_mirrorNum, _lineNum): line
		{
			return new line(G.vars.mirrors[_mirrorNum].x, G.vars.mirrors[_mirrorNum].y, 
							G.vars.mirrors[_mirrorNum].x - 400, G.vars.mirrors[_mirrorNum].y + 400, 
							'd', 'DOWN LEFT', _mirrorNum, G.vars.lines[_lineNum].lineColor);
		}
		
		public function drawDownRight(_mirrorNum, _lineNum): line
		{
			return new line(G.vars.mirrors[_mirrorNum].x, G.vars.mirrors[_mirrorNum].y, 
							G.vars.mirrors[_mirrorNum].x + 400, G.vars.mirrors[_mirrorNum].y + 400, 
							'd', 'DOWN RIGHT', _mirrorNum, G.vars.lines[_lineNum].lineColor);
		}
		
		public function drawLeft(_mirrorNum, _lineNum): line
		{
			return new line(G.vars.mirrors[_mirrorNum].x, G.vars.mirrors[_mirrorNum].y, 
							-450, G.vars.mirrors[_mirrorNum].y, 
							'y', 'LEFT', _mirrorNum, G.vars.lines[_lineNum].lineColor);
		}
		
		public function drawRight(_mirrorNum, _lineNum): line
		{
			return new line(G.vars.mirrors[_mirrorNum].x, G.vars.mirrors[_mirrorNum].y, 
							1000, G.vars.mirrors[_mirrorNum].y, 
							'y', 'RIGHT', _mirrorNum, G.vars.lines[_lineNum].lineColor);
		}
		
		// This function simulates a bounce, creates a temporary, invisible line
		// to test for colisions, stops the line at the collision point if any
		// is found, adds the new, fixed line to the stage and returns void
		public function simBounce(_line: line, lineNum: int, _mirror: mirror, mirrorNum: int): void
		{
			var tmpLine: line = new line(-100,-100,-100,-100,'','',mirrorNum,G.vars.lines[lineNum].lineColor);
			
			switch (_line.dir) // Switch between the possible directions the interfering line can be going in
			{
				case 'UP': // FINISHED FOR MIRRORS FRAME 1-8
					switch (_mirror.currentFrame)
					{
						case 1: tmpLine = drawRight(mirrorNum, lineNum); break;
						case 3: tmpLine = drawLeft(mirrorNum, lineNum); break;
						case 6: tmpLine = drawUpRight(mirrorNum, lineNum); break;
						case 8: tmpLine = drawUpLeft(mirrorNum, lineNum); break;
					}
					break;
				
				case 'UP LEFT': // FINISHED FOR MIRRORS FRAME 1-8
					switch (_mirror.currentFrame)
					{
						case 2: tmpLine = drawUpRight(mirrorNum, lineNum); break;
						case 4: tmpLine = drawDownLeft(mirrorNum, lineNum); break;
						case 5: tmpLine = drawLeft(mirrorNum, lineNum); break;
						case 8: tmpLine = drawUp(mirrorNum, lineNum); break;
					}
					break;
					
				case 'UP RIGHT': // FINISHED FOR MIRRORS FRAME 1-8
					switch (_mirror.currentFrame)
					{
						case 2: tmpLine = drawUpLeft(mirrorNum, lineNum); break;
						case 4: tmpLine = drawDownRight(mirrorNum, lineNum); break;
						case 6: tmpLine = drawUp(mirrorNum, lineNum); break;
						case 7: tmpLine = drawRight(mirrorNum, lineNum); break;
					}
					break;

				case 'DOWN': // FINISHED FOR MIRRORS FRAME 1-8
					switch (_mirror.currentFrame)
					{
						case 1: tmpLine = drawLeft(mirrorNum, lineNum); break;
						case 3: tmpLine = drawRight(mirrorNum, lineNum); break;
						case 6: tmpLine = drawDownLeft(mirrorNum, lineNum); break;
						case 8: tmpLine = drawDownRight(mirrorNum, lineNum); break;
					}
					break;
				
				case 'DOWN LEFT': // FINISHED FOR MIRRORS FRAME 1-8
					switch (_mirror.currentFrame)
					{
						case 2: tmpLine = drawDownRight(mirrorNum, lineNum); break;
						case 4: tmpLine = drawUpLeft(mirrorNum, lineNum); break;
						case 6: tmpLine = drawDown(mirrorNum, lineNum); break;
						case 7: tmpLine = drawLeft(mirrorNum, lineNum); break;
					}
					break;
					
				case 'DOWN RIGHT': // FINISHED FOR MIRRORS FRAME 1-8
					switch (_mirror.currentFrame)
					{
						case 2: tmpLine = drawDownLeft(mirrorNum, lineNum); break;
						case 4: tmpLine = drawUpRight(mirrorNum, lineNum); break;
						case 5: tmpLine = drawRight(mirrorNum, lineNum); break;
						case 8: tmpLine = drawDown(mirrorNum, lineNum); break;
					}
					break;
					
				case 'LEFT': // FINISHED FOR MIRRORS FRAME 1-8
					switch (_mirror.currentFrame)
					{
						case 1: tmpLine = drawDown(mirrorNum, lineNum); break;
						case 3: tmpLine = drawUp(mirrorNum, lineNum); break;
						case 5: tmpLine = drawUpLeft(mirrorNum, lineNum); break;
						case 7: tmpLine = drawDownLeft(mirrorNum, lineNum); break;
					}
					break;

				case 'RIGHT': // FINISHED FOR MIRRORS FRAME 1-8
					switch (_mirror.currentFrame)
					{
						case 1: tmpLine = drawUp(mirrorNum, lineNum); break;
						case 3: tmpLine = drawDown(mirrorNum, lineNum); break;
						case 5: tmpLine = drawDownRight(mirrorNum, lineNum); break;
						case 7: tmpLine = drawUpRight(mirrorNum, lineNum); break;
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
					
					switch (tmpLine.axis) // i don't think this does anything :/ the <line>.draw method handles it
					{
						case 'x':
							tmpLine.draw(G.vars.mirrors[tmpLine.owner].x, G.vars.mirrors[mHit].y); // only y axis should change
							break;
						case 'y':
							tmpLine.draw(G.vars.mirrors[mHit].x, G.vars.mirrors[tmpLine.owner].y); // only x axis should change
							break;
						case 'd':
							// not sure...
							break;
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
			if (G.vars.tutorial == false)
			{
				G.vars.completedLevels += 1;
			}
			G.vars.level += 1;
			reset();
			prepGame();
		}
		
		public function stopEnterFrame(event:TimerEvent)
		{
			G.vars._stage.removeEventListener(Event.ENTER_FRAME, G.vars.backend.enterFrame); // stop enterFrame listener
		}
		
		
		public function gotoLevel1(event:MouseEvent)
		{
			showLevelSelector(event);
			G.vars.level = 1;
			reset();
			prepGame();
		}
		
		public function gotoLevel2(event:MouseEvent)
		{
			showLevelSelector(event);
			G.vars.level = 2;
			reset();
			prepGame();
		}
		
		public function gotoLevel3(event:MouseEvent)
		{
			showLevelSelector(event);
			G.vars.level = 3;
			reset();
			prepGame();
		}
		
		public function gotoLevel4(event:MouseEvent)
		{
			showLevelSelector(event);
			G.vars.level = 4;
			reset();
			prepGame();
		}
		
		public function gotoLevel5(event:MouseEvent)
		{
			showLevelSelector(event);
			G.vars.level = 5;
			reset();
			prepGame();
		}
		
		public function gotoLevel6(event:MouseEvent)
		{
			showLevelSelector(event);
			G.vars.level = 6;
			reset();
			prepGame();
		}
		
		public function gotoLevel7(event:MouseEvent)
		{
			showLevelSelector(event);
			G.vars.level = 7;
			reset();
			prepGame();
		}
		
		public function gotoLevel8(event:MouseEvent)
		{
			showLevelSelector(event);
			G.vars.level = 8;
			reset();
			prepGame();
		}
		
		public function gotoLevel9(event:MouseEvent)
		{
			showLevelSelector(event);
			G.vars.level = 9;
			reset();
			prepGame();
		}
		
		public function gotoLevel10(event:MouseEvent)
		{
			showLevelSelector(event);
			G.vars.level = 10;
			reset();
			prepGame();
		}
		
		public function openMenuUI(event:MouseEvent)
		{
			if (!G.vars.gameMenu.stage)
			{
				G.vars._stage.addChild(G.vars.gameMenu);
				G.vars.gameMenu.x = 275;
				G.vars.gameMenu.y = 200;
				
				G.vars.gameMenu.closeMenu.addEventListener(MouseEvent.CLICK, closeMenuUI);
				G.vars.gameMenu.openLevelSelectBtn.addEventListener(MouseEvent.CLICK, showLevelSelector);
				G.vars.gameMenu.openShopBtn.addEventListener(MouseEvent.CLICK, openShopUI);
				G.vars.gameMenu.openLevelEditorBtn.addEventListener(MouseEvent.CLICK, openLevelEditorUI);
				G.vars.gameMenu.openBadgeArrayBtn.addEventListener(MouseEvent.CLICK, openBadgeArrayUI);
			}
		}
		
		public function closeMenuUI(event)
		{
			if (G.vars.gameMenu.stage)
			{
				G.vars.gameMenu.closeMenu.removeEventListener(MouseEvent.CLICK, closeMenuUI);
				G.vars.gameMenu.openLevelSelectBtn.removeEventListener(MouseEvent.CLICK, showLevelSelector);
				G.vars.gameMenu.openShopBtn.removeEventListener(MouseEvent.CLICK, openShopUI);
				G.vars.gameMenu.openLevelEditorBtn.removeEventListener(MouseEvent.CLICK, openLevelEditorUI);
				G.vars.gameMenu.openBadgeArrayBtn.removeEventListener(MouseEvent.CLICK, openBadgeArrayUI);
				G.vars._stage.removeChild(G.vars.gameMenu);
			}
		}
		
		public function showLevelSelector(event)
		{
			closeMenuUI(event);
			
			if (!G.vars.levelSelect.stage && G.vars.tutorial == false)
			{
				G.vars._stage.addChild(G.vars.levelSelect);
				G.vars.levelSelect.x = 275;
				G.vars.levelSelect.y = 200;
				
				G.vars.levelSelect.exitLevelSelect.addEventListener(MouseEvent.CLICK, showLevelSelector);
				
				G.vars.levelSelect.level1.levelNum.text = '?';
				G.vars.levelSelect.level2.levelNum.text = '?';
				G.vars.levelSelect.level3.levelNum.text = '?';
				G.vars.levelSelect.level4.levelNum.text = '?';
				G.vars.levelSelect.level5.levelNum.text = '?';
				G.vars.levelSelect.level6.levelNum.text = '?';
				G.vars.levelSelect.level7.levelNum.text = '?';
				G.vars.levelSelect.level8.levelNum.text = '?';
				G.vars.levelSelect.level9.levelNum.text = '?';
				G.vars.levelSelect.level10.levelNum.text = '?';
				
				if (G.vars.maxLevel > 0)
				{
					G.vars.levelSelect.level1.levelNum.text = '1';
					G.vars.levelSelect.level1.addEventListener(MouseEvent.CLICK, G.vars.backend.gotoLevel1);
				}
				if (G.vars.maxLevel > 1)
				{
					G.vars.levelSelect.level2.levelNum.text = '2';
					G.vars.levelSelect.level2.addEventListener(MouseEvent.CLICK, G.vars.backend.gotoLevel2);
				}
				if (G.vars.maxLevel > 2)
				{
					G.vars.levelSelect.level3.levelNum.text = '3';
					G.vars.levelSelect.level3.addEventListener(MouseEvent.CLICK, G.vars.backend.gotoLevel3);
				}
				if (G.vars.maxLevel > 3)
				{
					G.vars.levelSelect.level4.levelNum.text = '4';
					G.vars.levelSelect.level4.addEventListener(MouseEvent.CLICK, G.vars.backend.gotoLevel4);
				}
				if (G.vars.maxLevel > 4)
				{
					G.vars.levelSelect.level5.levelNum.text = '5';
					G.vars.levelSelect.level5.addEventListener(MouseEvent.CLICK, G.vars.backend.gotoLevel5);
				}
				if (G.vars.maxLevel > 5)
				{
					G.vars.levelSelect.level6.levelNum.text = '6';
					G.vars.levelSelect.level6.addEventListener(MouseEvent.CLICK, G.vars.backend.gotoLevel6);
				}
				if (G.vars.maxLEvel > 6)
				{
					G.vars.levelSelect.level7.levelNum.text = '7';
					G.vars.levelSelect.level7.addEventListener(MouseEvent.CLICK, G.vars.backend.gotoLevel7);
				}
				if (G.vars.maxLevel > 7)
				{
					G.vars.levelSelect.level8.levelNum.text = '8';
					G.vars.levelSelect.level8.addEventListener(MouseEvent.CLICK, G.vars.backend.gotoLevel8);
				}
				if (G.vars.maxLevel > 8)
				{
					G.vars.levelSelect.level9.levelNum.text = '9';
					G.vars.levelSelect.level9.addEventListener(MouseEvent.CLICK, G.vars.backend.gotoLevel9);
				}
				if (G.vars.maxLevel > 9)
				{
					G.vars.levelSelect.level10.levelNum.text = '10';
					G.vars.levelSelect.level10.addEventListener(MouseEvent.CLICK, G.vars.backend.gotoLevel10);
				}
				
				
				
			}
			else if (G.vars.levelSelect.stage)
			{
				G.vars.levelSelect.exitLevelSelect.removeEventListener(MouseEvent.CLICK, showLevelSelector);
				G.vars._stage.removeChild(G.vars.levelSelect);
			}
		}
		public function openShopUI(event)
		{
			closeMenuUI(event);
			G.vars._stage.addChild(G.vars.playerShop);
			G.vars.playerShop.x = 275;
			G.vars.playerShop.y = 200;
			G.vars.playerShop.gotoAndStop(1);
			G.vars.playerShop.exitShop.addEventListener(MouseEvent.CLICK, G.vars.shopmanager.closeShop);
			G.vars.playerShop.doubleCoins.addEventListener(MouseEvent.CLICK, G.vars.shopmanager.buyDoubleCoins);
			G.vars.playerShop.bombDeflectChance.addEventListener(MouseEvent.CLICK, G.vars.shopmanager.buyBombChance);
			G.vars.playerShop.nextPage.addEventListener(MouseEvent.CLICK, G.vars.shopmanager.nextPage);
			G.vars.playerShop.prevPage.addEventListener(MouseEvent.CLICK, G.vars.shopmanager.prevPage);
		}
		
		public function openLevelEditorUI(event)
		{
			closeMenuUI(event);
			G.vars._stage.addChild(G.vars.dialog);
			G.vars.dialog.gotoAndStop(1);
			G.vars.dialog.visible = true;
			G.vars.dialog.x = 275;
			G.vars.dialog.y = 200;
			
			if (G.vars.levelEdit == true)
			{
				G.vars.dialog.yesBtn.addEventListener(MouseEvent.MOUSE_DOWN, G.vars.leveleditor.startEditor);
				G.vars.dialog.noBtn.addEventListener(MouseEvent.MOUSE_DOWN, G.vars.dialogbox.closeYNDialog);
				G.vars.dialog.headingText.text = "Are you sure?";
				G.vars.dialog.descText.text = "Do you really want to reset this level?";
			}
			else
			{
				G.vars.dialog.yesBtn.addEventListener(MouseEvent.MOUSE_DOWN, G.vars.leveleditor.startEditor);
				G.vars.dialog.noBtn.addEventListener(MouseEvent.MOUSE_DOWN, G.vars.dialogbox.closeYNDialog);
				G.vars.dialog.headingText.text = "Are you sure?";
				G.vars.dialog.descText.text = "Opening the level editor will reset your game. Do you really want to open the editor?";
			}
		}
		
		public function openBadgeArrayUI(event)
		{
			closeMenuUI(event);
			G.vars._stage.addChild(G.vars.badgeArrayUI);
			G.vars.badgeArrayUI.x = 275;
			G.vars.badgeArrayUI.y = 200;
			
			G.vars.badgeArrayUI.badge1.gotoAndStop(7);
			G.vars.badgeArrayUI.badge2.gotoAndStop(7);
			G.vars.badgeArrayUI.badge3.gotoAndStop(7);
			G.vars.badgeArrayUI.badge4.gotoAndStop(7);
			G.vars.badgeArrayUI.badge5.gotoAndStop(7);
			G.vars.badgeArrayUI.badge6.gotoAndStop(7);
			G.vars.badgeArrayUI.badge7.gotoAndStop(7);
			G.vars.badgeArrayUI.badge8.gotoAndStop(7);
			G.vars.badgeArrayUI.badge9.gotoAndStop(7);
			G.vars.badgeArrayUI.badge10.gotoAndStop(7);
			G.vars.badgeArrayUI.badge11.gotoAndStop(7);
			G.vars.badgeArrayUI.badge12.gotoAndStop(7);
			
			if (G.vars.badgesArray.indexOf("student") != -1)
			{
				G.vars.badgeArrayUI.badge1.gotoAndStop(6);
			}
			
			if (G.vars.badgesArray.indexOf("crash test dummy 1") != -1)
			{
				G.vars.badgeArrayUI.badge2.gotoAndStop(1);
			}
			
			if (G.vars.badgesArray.indexOf("crash test dummy 2") != -1)
			{
				G.vars.badgeArrayUI.badge3.gotoAndStop(1);
			}
			
			if (G.vars.badgesArray.indexOf("spending spree 1") != -1)
			{
				G.vars.badgeArrayUI.badge4.gotoAndStop(2);
			}
			
			if (G.vars.badgesArray.indexOf("spending spree 2") != -1)
			{
				G.vars.badgeArrayUI.badge5.gotoAndStop(2);
			}
			
			if (G.vars.badgesArray.indexOf("survivor 1") != -1)
			{
				G.vars.badgeArrayUI.badge6.gotoAndStop(3);
			}
			
			if (G.vars.badgesArray.indexOf("survivor 2") != -1)
			{
				G.vars.badgeArrayUI.badge7.gotoAndStop(3);
			}
			
			if (G.vars.badgesArray.indexOf("killing spree 1") != -1)
			{
				G.vars.badgeArrayUI.badge8.gotoAndStop(4);
			}
			
			if (G.vars.badgesArray.indexOf("killing spree 2") != -1)
			{
				G.vars.badgeArrayUI.badge9.gotoAndStop(4);
			}
			
			if (G.vars.badgesArray.indexOf("escape artist 1") != -1)
			{
				G.vars.badgeArrayUI.badge10.gotoAndStop(5);
			}
			
			if (G.vars.badgesArray.indexOf("escape artist 2") != -1)
			{
				G.vars.badgeArrayUI.badge11.gotoAndStop(5);
			}
			G.vars.badgeArrayUI.exitBadgeUI.addEventListener(MouseEvent.CLICK, closeBadgeArrayUI);
		}
		
		public function closeBadgeArrayUI(event)
		{
			G.vars.badgeArrayUI.exitBadgeUI.removeEventListener(MouseEvent.CLICK, closeBadgeArrayUI);
			G.vars._stage.removeChild(G.vars.badgeArrayUI);
		}
		
		public function skipTutorial(event:MouseEvent)
		{
			G.vars.level = 1;
			G.vars.tutorial = false;
			
			G.vars.result = "RESTART"; // make sure the reset function knows that the user restarted the game
			G.vars.backend.reset(); // reset the game if the R key is pressed
			G.vars.backend.prepGame();
		}
		
		public function startGame(event)
		{
			if (G.vars.result == "NEW" && 
				G.vars.level == 1 && 
				G.vars.tutstage == 0 &&
				G.vars.started == false)
			{
				G.vars.started = true;
				G.vars.backend.reset();
				G.vars.backend.prepGame();
			}
		}
	}
	
}
