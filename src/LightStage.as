/********************************
LIGHTSTAGE BETA 0.1.0
Built by Raph Hennessy
All Rights Reserved 3rd May 2016
********************************/
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
		public var coins: Vector.<coin> = new Vector.<coin>(); // vector to store all the coin movieclips
		
		public var result: String = "NEW"; // what happened in the last game that was played?
		private var spawnCoins: Boolean = true; // did they win or is it their first game? then we should spawn new coins!
		
		private var lastDragged: int;
		private var dialog: openShop = new openShop();
		private var playerShop: shop = new shop(money);
		private var levelEdit: Boolean = false;
		
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
						prepGame();
					}
					break;
					
				case Keyboard.R:
					result = "RESTART"; // make sure the reset function knows that the user restarted the game
					reset(); // reset the game if the R key is pressed
					prepGame();
					break;
				
				case Keyboard.S:
					stage.addChild(playerShop);
					playerShop.x = 275;
					playerShop.y = 200;
					
					playerShop.exitShop.addEventListener(MouseEvent.CLICK, closeShop);
					playerShop.doubleCoins.addEventListener(MouseEvent.CLICK, buyDoubleCoins);
					playerShop.bombDeflectChance.addEventListener(MouseEvent.CLICK, buyBombChance);	
					break;
				
				case Keyboard.L:
					stage.addChild(dialog);
					dialog.gotoAndStop(1);
					dialog.visible = true;
					dialog.x = 275;
					dialog.y = 200;
					
					if (levelEdit == true)
					{
						dialog.yesBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditor);
						dialog.noBtn.addEventListener(MouseEvent.MOUSE_DOWN, closeYNDialog);
						dialog.headingText.text = "Are you sure?";
						dialog.descText.text = "Do you really want to reset this level?";
						trace('================RESET================');
					}
					else
					{
						dialog.yesBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditor);
						dialog.noBtn.addEventListener(MouseEvent.MOUSE_DOWN, closeYNDialog);
						dialog.headingText.text = "Are you sure?";
						dialog.descText.text = "Opening the level editor will reset your game. Do you really want to open the level editor?";
					}
					
					break;
				
				case Keyboard.Q:
					if (levelEdit == true)
					{
						levelEdit = false;
						level = 1;
						money = 0;
						reset();
						prepGame();
					}
					break;
					
				case Keyboard.M:
					if (levelEdit == true)
					{
						mirrors.push(new mirror(mouseX, mouseY, 9999));
						stage.addChild(mirrors[mirrors.length - 1]);
						trace('added new mirror at X: ' + mouseX + ', Y: ' + mouseY);
					}
					break;
					
				case Keyboard.B:
					if (levelEdit == true)
					{
						bombs.push(new bomb(mouseX, mouseY));
						stage.addChild(bombs[bombs.length - 1]);
						trace('added new bomb at X: ' + mouseX + ', Y: ' + mouseY);
					}
					break;
					
				case Keyboard.G:
					if (levelEdit == true)
					{
						globes.push(new globe(mouseX, mouseY));
						stage.addChild(globes[globes.length - 1]);
						trace('added new globe at X: ' + mouseX + ', Y: ' + mouseY);
					}
					break;
					
				case Keyboard.C:
					if (levelEdit == true)
					{
						coins.push(new coin(mouseX, mouseY));
						stage.addChild(coins[coins.length - 1]);
						trace('added new coin at X: ' + mouseX + ', Y: ' + mouseY);
					}
					break;
			}
			
		}
		private function simpleDialog(heading: String, desc: String)
		{
			stage.addChild(dialog);
			dialog.gotoAndStop(2);
			dialog.visible = true;
			dialog.x = 275;
			dialog.y = 200;
			dialog.okBtn.addEventListener(MouseEvent.MOUSE_DOWN, closeSimpleDialog);
			dialog.headingText.text = heading;
			dialog.descText.text = desc;
		}
		private function buyDoubleCoins(event:MouseEvent) // purchases double coins and tells the user if it worked
		{
			var newMoney = playerShop.shopBuy("double coins");
			if (newMoney == money) { simpleDialog("Too poor!","You don't have enough coins to buy Double Coins!"); }
			else if (newMoney == 1337) { simpleDialog("Already bought!","You already own Double Coins."); }
			else { simpleDialog("Purchased Double Coins!","You sucessfully purchased Double Coins!"); money = newMoney; }
			updateText();
		}
		
		private function buyBombChance(event:MouseEvent) // purchases bomb defence chance and tells user if it worked
		{
			var newMoney = playerShop.shopBuy("bomb deflect chance");
			if (newMoney == money) { simpleDialog("Too poor!","You don't have enough coins to buy Bomb Deflection Chance!"); }
			else if (newMoney == 1337) { simpleDialog("Already bought!","You already own Bomb Deflection Chance."); }
			else 
			{
				simpleDialog("Purchased Bomb Deflection Chance!","You successfully purchased Bomb Deflection Chance!");
				money = newMoney;
			}
			updateText();
		}
		
		private function closeShop(event:MouseEvent): void
		{
			stage.removeChild(playerShop);
			playerShop.exitShop.removeEventListener(MouseEvent.CLICK, closeShop);
			playerShop.doubleCoins.removeEventListener(MouseEvent.CLICK, buyDoubleCoins);
			playerShop.bombDeflectChance.removeEventListener(MouseEvent.CLICK, buyBombChance);
		}
		
		private function closeSimpleDialog(event:MouseEvent): void
		{
			if (dialog.stage) { stage.removeChild(dialog); }
			dialog.okBtn.removeEventListener(MouseEvent.CLICK, closeSimpleDialog);
		}
		
		private function closeYNDialog(event:MouseEvent): void
		{
			if (dialog.stage) { stage.removeChild(dialog); }
			dialog.yesBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
			dialog.noBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
		}
		
		private function levelUp(): void // if the user completes the previous level
		{
			level += 1;
			reset();
			prepGame();
		}
		
		private function levelEditor(event:MouseEvent): void
		{
			if (dialog.stage) { stage.removeChild(dialog); }
			dialog.yesBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
			dialog.noBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
			levelEdit = true;
			reset();
			simpleDialog("Level Editor","Use Q to quit, M to get mirror, B to get bomb, C to get coin, and G to get globe.");
			mirrors = new Vector.<mirror>(); // setup mirrors vector
			lines = new Vector.<line>(); // setup lines vector
			globes = new Vector.<globe>(); // setup globes vector
			bombs = new Vector.<bomb>(); // setup bombs vector
			level = "Editor";
			updateText();
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
				spawnCoins = true;
				startupMsg = "LightStage is starting..."; // show the initial starting message
				result = "RESTART"; // prepare the next loading message so that it isn't always the default
			}
			else if (result == "DIED") // if the user died on their last turn
			{
				spawnCoins = false;
				startupMsg = "You died!"; // the text on the loading screen should be 'You died!'
			}
			else if (result == "WON") // if the user completed the last level
			{
				spawnCoins = true;
				startupMsg = "You completed level " + (level - 1) + "!"; // show the user what level they are on
			}
			else if (result == "RESTART") // if the user pressed any key to restart
			{
				spawnCoins = false;
				startupMsg = "Resetting your level..."; // show the user that the level is being reset
			}
			else if (result == "OVER") // if the user completed all the levels
			{
				spawnCoins = true;
				startupMsg = "You completed all the levels!";
			}
			else // if the reason for the reset is unknown
			{
				spawnCoins = false;
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
			
			
			for (var destroyCoin: int = 0; destroyCoin < coins.length; destroyCoin++) // loop through all the coins
			{
				if (spawnCoins) // make sure users don't get duplicate coins
				{
					coins[destroyCoin].resetAll(); // reset the coin
					if (coins[destroyCoin].stage) { stage.removeChild(coins[destroyCoin]) }
				}
				else
				{
					if (coins[destroyCoin].full == false)
					{
						coins[destroyCoin].visible = false;
					}
				}
			}
			
			stage.removeEventListener(Event.ENTER_FRAME, enterFrame); // stop enterFrame listener
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
			
			if (spawnCoins) // make sure users don't get duplicate coins
			{
				coins = new Vector.<coin>(); // setup coins vector
			}
			else
			{
				for (var fixCoin: int = 0; fixCoin < coins.length; fixCoin++) // loop through all the coins
				{
					if (coins[fixCoin].full == false)
					{
						coins[fixCoin].visible = true;
					}
				}
			}
			
			if (level == 1) // if the user is on level 1
			{
				mirrors.push(new mirror(100, 350)); // Make a testing mirror to deflect UP / RIGHT
				stage.addChild(mirrors[0]); // Add the new mirror to the stage
				
				mirrors.push(new mirror(300, 350, 2)); // Make a nw mirror
				stage.addChild(mirrors[1]); // Add the new mirror to the stage
				
				globes.push(new globe(100, 250)); // add a new globe to the globes array
				stage.addChild(globes[0]); // add the new globe to the stage
				
				globes.push(new globe(300, 250)); // add a new globe to the globes array
				stage.addChild(globes[1]); // add the new globe to the stage
				
				if (spawnCoins) // make sure users don't get duplicate coins
				{
					coins.push(new coin(200, 250)); // add a new coin to the coins vector
					stage.addChild(coins[0]); // add the new coin to the stage
				}
				
				lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, 0xe67e22, false, false)); // add core line
				lines[0].visible = true; // Make the baseline visible
				stage.addChild(lines[0]); // Add baseline to the stage
			}
			else if (level == 2)
			{
				mirrors.push(new mirror(450, 200)); // Make a mirror
				stage.addChild(mirrors[0]); // Add the new mirror to the stage
				
				mirrors.push(new mirror(450, 300, 2)); // Make a mirror
				stage.addChild(mirrors[1]); // Add the new mirror to the stage
				
				globes.push(new globe(225, 300)); // add a new globe to the globes vector
				stage.addChild(globes[0]); // add the new globe to the stage
				
				bombs.push(new bomb(300, 300)); // make a new bomb
				stage.addChild(bombs[0]); // add the new bomb to the stage
				
				if (spawnCoins)
				{
					coins.push(new coin(260, 300)); // add a new coin to the coins vector
					stage.addChild(coins[0]); // add the new coin to the stage
				}
				
				lines.push(new line(400, 370, 400, 0, 'x', 'UP', 9999, 0xecf0f1, false, false)); // add core line
				lines[0].visible = true; // Make the baseline visible
				stage.addChild(lines[0]); // Add baseline to the stage
			}
			else if (level == 3)
			{
				mirrors.push(new mirror(191, 300)); // Make a new mirror
				stage.addChild(mirrors[0]); // Add the new mirror to the stage
				
				mirrors.push(new mirror(332, 300, 2)); // Make a new mirror
				stage.addChild(mirrors[1]); // Add the new mirror to the stage
				
				mirrors.push(new mirror(498, 300, 2)); // Make a new mirror
				stage.addChild(mirrors[2]); // Add the new mirror to the stage
				
				globes.push(new globe(191, 250)); // add a new globe to the globes array
				stage.addChild(globes[0]); // add the new globe to the stage
				
				globes.push(new globe(498, 250)); // add a new globe to the globes array
				stage.addChild(globes[1]); // add the new globe to the stage
				
				bombs.push(new bomb(332, 235)); // add a new bomb to the bombs array
				stage.addChild(bombs[0]); // add the new globe to the stage
				
				bombs.push(new bomb(332, 270)); // add a new bomb to the bombs array
				stage.addChild(bombs[1]); // add the new globe to the stage
				
				if (spawnCoins)
				{
					coins.push(new coin(414, 300)); // add a new coin to the coins vector
					stage.addChild(coins[0]); // add the new coin to the stage
					
					coins.push(new coin(250, 300)); // add a new coin to the coins vector
					stage.addChild(coins[1]); // add the new coin to the stage
				}
				
				lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, 0x8e44ad, false, false)); // add core line
				lines[0].visible = true; // Make the baseline visible
				stage.addChild(lines[0]); // Add baseline to the stage
			}
			else if (level == 4)
			{
				mirrors.push(new mirror(-37, 20.45));
				stage.addChild(mirrors[mirrors.length - 1]);
				
				mirrors.push(new mirror(3.45, 21.45, 2));
				stage.addChild(mirrors[mirrors.length - 1]);
				
				mirrors.push(new mirror(41.2, 21.45, 2));
				stage.addChild(mirrors[mirrors.length - 1]);
				
				mirrors.push(new mirror(84.45, 20.05, 2));
				stage.addChild(mirrors[mirrors.length - 1]);
				
				if (spawnCoins)
				{
					coins.push(new coin(254.5, 274.75));
					stage.addChild(coins[coins.length - 1]);
					
					coins.push(new coin(254.5, 139.75));
					stage.addChild(coins[coins.length - 1]);
				}
				
				globes.push(new globe(301, 274.75));
				stage.addChild(globes[globes.length - 1]);
				
				globes.push(new globe(341.5, 332.5));
				stage.addChild(globes[globes.length - 1]);
				
				globes.push(new globe(285.75, 139.75));
				stage.addChild(globes[globes.length - 1]);
				
				bombs.push(new bomb(334.75, 216.5));
				stage.addChild(bombs[bombs.length - 1]);
				
				bombs.push(new bomb(284.75, 216.5));
				stage.addChild(bombs[bombs.length - 1]);
				
				bombs.push(new bomb(234.75, 216.5));
				stage.addChild(bombs[bombs.length - 1]);
				
				lines.push(new line(550, 383.75, -450, 383.75, 'y', 'LEFT', 9999, 0x2c3e50, false, false)); // add core line
				lines[0].visible = true; // Make the baseline visible
				stage.addChild(lines[0]); // Add baseline to the stage
				
			}
			else
			{
				result = "OVER";
				reset();
				prepGame();
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
					
					for (var coinNum: int = 0; coinNum < coins.length; coinNum++) //iterate through coins
					{
						if (lines[lineNum].hitTestObject(coins[coinNum])) // If the line is touching the selected coin
						{
							coins[coinNum].hit = true;
							coins[coinNum].filling = true; // tell thatcoin that it has been hit by a line
							coins[coinNum].startFill(); // start filling that coin using it's function
						}
					}
					
					for (var bombNum: int = 0; bombNum < bombs.length; bombNum++) //iterate through globes
					{
						if (bombs[bombNum].exploded == true)
						{
							if (playerShop.items.indexOf("bomb deflect chance") != -1 && // if they have bomb defence chance
								Math.round(Math.random())) // if they are lucky and manage to dodge the bomb
							{
								bombs[bombNum].resetAll();
								if (bombs[bombNum].stage) { stage.removeChild(bombs[bombNum]); }
							}
							else // if they don't have bomb deflect chance, or didn't manage to deflect the bomb (50% chance)
							{
								result = "DIED";
								reset();
								prepGame();
							}
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
			
			
			for (var checkCoin: int = 0; checkCoin < coins.length; checkCoin++) //iterate through coins
			{
				if (coins[checkCoin].full == true && coins[checkCoin].stage) // If the selected globe is full
				{
					if (playerShop.items.indexOf("double coins") == -1) // if the player dosen't own the double coins upgrade
					{
						money += 1; // increase money by one coin
					}
					else // if they do own the double coins upgrade
					{
						money += 2;
					}
					updateText();
					playerShop.setCoins(money);
					coins[checkCoin].resetAll(); // reset selected coin
					stage.removeChild(coins[checkCoin]); // remove the coin from the stage
				}
				if (coins[checkCoin].hit == false) // If the coin didn't get hit by a beam last iteration
				{
					coins[checkCoin].filling = false; // set the coin's filling property to false
					coins[checkCoin].resetAll(); // reset the selected coin
				}
				coins[checkCoin].hit = false; // set the hit property to false so that it is only reflecting the last loop
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
					
					switch (tmpLine.axis)
					{
						case 'x':
							tmpLine.draw(mirrors[tmpLine.owner].x, mirrors[mHit].y); // only y axis should change
							break;
						case 'y':
							tmpLine.draw(mirrors[mHit].x, mirrors[tmpLine.owner].y); // only x axis should change
					}
					
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
