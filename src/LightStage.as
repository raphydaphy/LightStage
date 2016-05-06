/********************************
LIGHTSTAGE 0.1 BETA 4
Built by Raph Hennessy
All Rights Reserved 4th May 2016
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
		/**********************************************
		PUBLIC VECTORS FOR MOVIECLIPS & CLASS INSTANCES
		**********************************************/
		public var mirrors: Vector.<mirror> = new Vector.<mirror>(); // vector for the mirror movieclips
		public var lines: Vector.<line> = new Vector.<line>(); // this vector stores all the line sprites
		public var globes: Vector.<globe> = new Vector.<globe>(); // vector to store all the globes
		public var bombs: Vector.<bomb> = new Vector.<bomb>(); // vector to store all the bomb movieclips
		public var coins: Vector.<coin> = new Vector.<coin>(); // vector to store all the coin movieclips
		public var walls: Vector.<block> = new Vector.<block>(); // vector to store all the coin movieclips

		/********************************************************
		PRIVATE VARIABLES FOR COUNTING SCORES & STORING INSTANCES
		********************************************************/
		private var dialog: openShop = new openShop();
		private var playerShop: shop = new shop(money);
		private var badgeManager: badgeAlert = new badgeAlert();
		private var badges: Array = [];
		private var levelEdit: Boolean = false;
		private var resetting: Boolean = false;
		private var maxLevel = 0;
		private var deaths = 0;
		private var lineColors: Array = [0x2ecc71, 0x27ae60, 0x3498db, 0x2980b9, 0x9b59b6, 0x8e44ad, 0x34495e, 0x2c3e50,
										 0xf1c40f, 0xf1c40f, 0xe67e22, 0xe74c3c, 0xecf0f1, 0x95a5a6, 0xf39c12, 0xd35400,
										 0xc0392b, 0xbdc3c7, 0x7f8c8d];
		public var result: String = "NEW"; // what happened in the last game that was played?
		private var spawnCoins: Boolean = true; // did they win or is it their first game? then we should spawn new coins!
		
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
					for (var bombNum: int = 0; bombNum < bombs.length; bombNum++) //iterate through globes
					{
						if (bombs[bombNum].exploded == true)
						{
							if (levelEdit == false && resetting == false)
							{
								result = "RESTART"; // make sure the reset function knows that the user restarted the game
								reset(); // reset the game if the R key is pressed
								prepGame();
							}
						}
					}
					
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
						playerShop.setCoins(money);
						reset();
						prepGame();
					}
					break;
					
				case Keyboard.M:
					if (levelEdit == true)
					{
						mirrors.push(new mirror(mouseX, mouseY, 9999));
						stage.addChild(mirrors[mirrors.length - 1]);
					}
					break;
					
				case Keyboard.B:
					if (levelEdit == true)
					{
						bombs.push(new bomb(mouseX, mouseY));
						stage.addChild(bombs[bombs.length - 1]);
					}
					break;
					
				case Keyboard.G:
					if (levelEdit == true)
					{
						globes.push(new globe(mouseX, mouseY));
						stage.addChild(globes[globes.length - 1]);
					}
					break;
					
				case Keyboard.C:
					if (levelEdit == true)
					{
						coins.push(new coin(mouseX, mouseY));
						stage.addChild(coins[coins.length - 1]);
					}
					break;
				case Keyboard.W:
					if (levelEdit == true)
					{
						walls.push(new block(mouseX, mouseY));
						stage.addChild(walls[walls.length - 1]);
					}
					break;
				case Keyboard.T:
					if (levelEdit = true)
					{
						if (globes.length > 0)
						{
							level = 0;
							money = 0;
							playerShop.setCoins(money);
							stage.addEventListener(Event.ENTER_FRAME, enterFrame);
							
							var stopGameTimer:Timer = new Timer(500, 1); 
							stopGameTimer.addEventListener(TimerEvent.TIMER, stopEnterFrame);
							stopGameTimer.start(); // start the timer
						}
						else
						{
							simpleDialog("Error!","You need to put at least one globe on the stage to test the level");
						}
					}
					break;
				case Keyboard.P:
					if (levelEdit == true)
					{
						trace('===================START LEVEL CODE===================');
						for (var printLine: int = 0; printLine < lines.length; printLine++)
						{
							if (lines[printLine].disp == false)
							{
								trace('lines.push(new line(' + lines[printLine].origStartX +
									   ', ' + lines[printLine].origStartY +
									   ', ' + lines[printLine].origEndX +
									   ', ' + lines[printLine].origEndY +
									   ", '" + lines[printLine].axis + "'" +
									   ", '" + lines[printLine].dir + "'" +
									   ', 9999, lineColors[num]' +
									   ', false, false));');
								trace('lines[lines.length - 1].visible = true;');
								trace('stage.addChild(lines[lines.length - 1])');
							}
						}
						
						var mirrorX = -22
						var mirrorY = 22;
						for (var printMirror: int = 0; printMirror < mirrors.length; printMirror++)
						{
							trace('\nmirrors.push(new mirror(' + 
								  mirrorX + 
								  ', ' + mirrorY +
								  ', ' + mirrors[printMirror].currentFrame +
								  '));');
							trace('stage.addChild(mirrors[mirrors.length - 1]);');
							if (mirrorX > 197) { mirrorX = -22; mirrorY += 50; }
							else { mirrorX += 44; }
						}
						for (var printGlobe: int = 0; printGlobe < globes.length; printGlobe++)
						{
							trace('\nglobes.push(new globe(' + 
								  globes[printGlobe].x + 
								  ', ' + globes[printGlobe].y +
								  '));');
							trace('stage.addChild(globes[globes.length - 1]);');
						}
						
						if (coins.length > 0)
						{
							trace('if (spawnCoins)');
							trace('{');
							for (var printCoin: int = 0; printCoin < coins.length; printCoin++)
							{
								if (coins[printCoin].x != -100 && coins[printCoin].y != -100)
								{
									trace('\n\tcoins.push(new coin(' + 
										  coins[printCoin].x + 
										  ', ' + coins[printCoin].y +
										  '));');
									trace('\tstage.addChild(coins[coins.length - 1]);');
								}
							}
							trace('}');
						}
						for (var printWall: int = 0; printWall < walls.length; printWall++)
						{
							trace('\nwalls.push(new block(' + 
								  walls[printWall].x + 
								  ', ' + walls[printWall].y +
								  '));');
							trace('stage.addChild(walls[walls.length - 1]);');
						}
						for (var printBomb: int = 0; printBomb < bombs.length; printBomb++)
						{
							trace('\nbombs.push(new bomb(' + 
								  bombs[printBomb].x + 
								  ', ' + bombs[printBomb].y +
								  '));');
							trace('stage.addChild(bombs[bombs.length - 1]);');
						}
						trace('====================END LEVEL CODE====================');
					}
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
		
		private function stopEnterFrame(event:TimerEvent)
		{
			stage.removeEventListener(Event.ENTER_FRAME, enterFrame); // stop enterFrame listener
		}
		
		private function buyDoubleCoins(event:MouseEvent) // purchases double coins and tells the user if it worked
		{
			var newMoney = playerShop.shopBuy("double coins");
			if (newMoney == money) { simpleDialog("Too poor!","You don't have enough coins to buy Double Coins!"); }
			else if (newMoney == 1337) { simpleDialog("Already bought!","You already own Double Coins."); }
			else { simpleDialog("Purchased Double Coins!","You sucessfully purchased Double Coins!"); money = newMoney; }
			safeUpdateText(false);
			playerShop.setCoins(money);
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
			safeUpdateText(false)
			playerShop.setCoins(money);
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
			var num:int=Math.floor(Math.random() * lineColors.length);
			if (dialog.stage) { stage.removeChild(dialog); }
			dialog.yesBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
			dialog.noBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
			stage.addChild(dialog);
			dialog.gotoAndStop(3);
			dialog.visible = true;
			dialog.x = 275;
			dialog.y = 200;
			dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			dialog.headingText.text = "Level Editor Setup";
			dialog.descText.text = "What direction do you want your base line to be going in?";
			spawnCoins = true;
			levelEdit = true;
			reset();
			mirrors = new Vector.<mirror>(); // setup mirrors vector
			lines = new Vector.<line>(); // setup lines vector
			globes = new Vector.<globe>(); // setup globes vector
			bombs = new Vector.<bomb>(); // setup bombs vector
			level = "Editor";
			safeUpdateText()
			for (var destroyCoin: int = 0; destroyCoin < coins.length; destroyCoin++) // loop through all the coins
			{
				coins[destroyCoin].destroy(); // reset the coin
				if (coins[destroyCoin].stage) { stage.removeChild(coins[destroyCoin]) }
			}
		}
		
		private function levelEditorSetLeft(event:MouseEvent)
		{
			if (dialog.stage) { stage.removeChild(dialog); }
			dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			lines.push(new line(550, 200, -450, 200, 'y', 'LEFT', 9999, lineColors[num], false, false));
			lines[lines.length - 1].visible = true;
			stage.addChild(lines[lines.length - 1]);
		}
		
		private function levelEditorSetRight(event:MouseEvent)
		{
			if (dialog.stage) { stage.removeChild(dialog); }
			dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, lineColors[num], false, false));
			lines[lines.length - 1].visible = true;
			stage.addChild(lines[lines.length - 1]);
		}
		
		private function levelEditorSetUp(event:MouseEvent)
		{
			if (dialog.stage) { stage.removeChild(dialog); }
			dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			lines.push(new line(275, 360, 275, -450, 'x', 'UP', 9999, lineColors[num], false, false));
			lines[lines.length - 1].visible = true;
			stage.addChild(lines[lines.length - 1]);
		}
		
		private function levelEditorSetDown(event:MouseEvent)
		{
			if (dialog.stage) { stage.removeChild(dialog); }
			dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			lines.push(new line(275, 120, 275, 450, 'x', 'DOWN', 9999, lineColors[num], false, false));
			lines[lines.length - 1].visible = true;
			stage.addChild(lines[lines.length - 1]);
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
			resetting = true;
			if (result == "NEW") // if it is the first game the user has played
			{
				spawnCoins = true;
				startupMsg = "LightStage is starting..."; // show the initial starting message
				result = "RESTART"; // prepare the next loading message so that it isn't always the default
			}
			else if (result == "DIED") // if the user died on their last turn
			{
				deaths += 1;
				spawnCoins = false;
				startupMsg = "You died!"; // the text on the loading screen should be 'You died!'
				level = 1;
			}
			else if (result == "WON") // if the user completed the last level
			{
				if (level - 1 > maxLevel) // if this is the best level they have reached
				{
					maxLevel = level - 1;
					money += level - 1;
					spawnCoins = true;
					playerShop.setCoins(money);
				}
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
				globes[destroyGlobe].destroy(); // destroy the globe
				if (globes[destroyGlobe].stage) { stage.removeChild(globes[destroyGlobe]) } // remove globe from the stage
			}
			for (var destroyBomb: int = 0; destroyBomb < bombs.length; destroyBomb++) // loop through all the bombs
			{
				bombs[destroyBomb].destroy(); // destroy the bomb
				if (bombs[destroyBomb].stage) { stage.removeChild(bombs[destroyBomb]) } // remove bomb from the stage
			}
			for (var destroyWall: int = 0; destroyWall < walls.length; destroyWall++) // loop through all the walls
			{
				walls[destroyWall].resetAll(); // reset the wall
				walls[destroyWall].destroy(); // destroy the wall
				if (walls[destroyWall].stage) { stage.removeChild(walls[destroyWall]) } // remove walls from the stage
			}
			
			
			for (var destroyCoin: int = 0; destroyCoin < coins.length; destroyCoin++) // loop through all the coins
			{
				coins[destroyCoin].resetAll(); // reset the coin
				if (coins[destroyCoin].stage) { stage.removeChild(coins[destroyCoin]) }
			}
			
			stage.removeEventListener(Event.ENTER_FRAME, enterFrame); // stop enterFrame listener
		}
		
		private function hideBadge(event:TimerEvent): void // hide the badge alert movieclip
		{
			if (badgeManager.stage) { stage.removeChild(badgeManager); }
		}
		
		private function safeUpdateText(changeFrame: Boolean = true): void
		{
			if (currentFrame == 3)
			{
				updateText();
			}
			else if (changeFrame)
			{
				gotoAndStop(3);
				updateText();
			}
		}
		
		private function showBadge(title: String, desc: String, cost: int, frame: int): void
		{
			badges.push(title.toLocaleLowerCase());
			badgeManager = new badgeAlert();
			badgeManager.badgeHeading.text = title;
			badgeManager.badgeDesc.text = desc;
			badgeManager.badgeCost.text = "$" + cost;
			badgeManager.badgeIcon.gotoAndStop(frame);
			badgeManager.x = 275;
			badgeManager.y = 350;
			stage.addChild(badgeManager);
			money += cost;
			playerShop.setCoins(money);
			safeUpdateText(false);
			var hideBadgeTimer:Timer = new Timer(2500, 1);
			hideBadgeTimer.addEventListener(TimerEvent.TIMER, hideBadge);
			hideBadgeTimer.start();
		}
		
		private function checkBadges(): void
		{
			if (deaths > 4 && // if they have died at least 5 times in a row
				badges.indexOf("crash test dummy 1") == -1 ) // if they don't already have the badge
			{
				showBadge("Crash Test Dummy 1","Die 5 times in a single game",10,1);
			}
			
			if (deaths > 9 && // if they have died at least 10 times in a row
				badges.indexOf("crash test dummy 2") == -1 ) // if they don't already have the badge
			{
				showBadge("Crash Test Dummy 2","Die 10 times in a single game",25,1);
			}
			
			if (playerShop.playerItems.length > 1 && // if they have purchased at least 2 items from the shop
				badges.indexOf("spending spree 1") == -1) // if they don't already have the badge
			{
				showBadge("Spending Spree 1","Buy at least two items from the ingame shop",10,2);
			}
				
		}
		
		private function game(event:TimerEvent):void // start the game
		{
			resetting = false;
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
			
			var num:int=Math.floor(Math.random() * lineColors.length);
			
			if (level == 1)
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
				
				lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, lineColors[num], false, false)); // add core line
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
				
				walls.push(new block(300, 340));
				stage.addChild(walls[0]);
				
				if (spawnCoins)
				{
					coins.push(new coin(260, 300)); // add a new coin to the coins vector
					stage.addChild(coins[0]); // add the new coin to the stage
				}
				
				lines.push(new line(400, 370, 400, 0, 'x', 'UP', 9999, lineColors[num], false, false)); // add core line
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
				
				lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, lineColors[num], false, false)); // add core line
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
				
				lines.push(new line(550, 383.75, -450, 383.75, 'y', 'LEFT', 9999, lineColors[num], false, false)); // add core line
				lines[0].visible = true; // Make the baseline visible
				stage.addChild(lines[0]); // Add baseline to the stage
				
			}
			else if (level == 5)
			{
				lines.push(new line(450, 50, 450, 1000, 'x', 'DOWN', 9999, lineColors[num], false, false)); // add core line
				lines[0].visible = true; // Make the baseline visible
				stage.addChild(lines[0]); // Add baseline to the stage
				
				mirrors.push(new mirror(-22, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(22, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(66, 22, 2));
				stage.addChild(mirrors[mirrors.length - 1]);

				globes.push(new globe(361, 153));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(313, 292));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(394, 340));
				stage.addChild(globes[globes.length - 1]);
				if (spawnCoins)
				{
					coins.push(new coin(311, 243));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(391, 153));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(514, 153));
					stage.addChild(coins[coins.length - 1]);
				}
				bombs.push(new bomb(267, 152));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(313, 378));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(520, 333));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(522, 280));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(521, 215));
				stage.addChild(bombs[bombs.length - 1]);
			}
			else if (level == 6)
			{
				lines.push(new line(480, 370, 480, 0, 'x', 'UP', 9999, lineColors[num], false, false)); // add core line
				lines[0].visible = true; // Make the baseline visible
				stage.addChild(lines[0]); // Add baseline to the stage
				
				mirrors.push(new mirror(-22, 22, 2));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(22, 22, 2));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(66, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				globes.push(new globe(387, 296));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(544, 176));
				stage.addChild(globes[globes.length - 1]);
				if (spawnCoins)
				{
					coins.push(new coin(350, 299));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(309, 298));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(297, 182));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(331, 179));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(367, 181));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(399, 180));
					stage.addChild(coins[coins.length - 1]);
				}
				bombs.push(new bomb(189, 299));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(186, 243));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(185, 180));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(432, 238));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(386, 239));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(338, 240));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(299, 242));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(188, 119));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(225, 119));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(277, 123));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(319, 124));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(363, 127));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(411, 123));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(539, 109));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(544, 237));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(545, 291));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(546, 345));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(539, 53));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(410, 60));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(356, 59));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(302, 56));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(240, 52));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(190, 53));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(191, 348));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(242, 348));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(289, 351));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(332, 352));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(370, 353));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(408, 355));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(435, 354));
				stage.addChild(bombs[bombs.length - 1]);
			}
			else if (level == 7)
			{
				lines.push(new line(275, 370, 275, 0, 'x', 'UP', 9999, lineColors[num], false, false)); // add core line
				lines[0].visible = true; // Make the baseline visible
				stage.addChild(lines[0]); // Add baseline to the stage
				
				mirrors.push(new mirror(-22, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(22, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(66, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				globes.push(new globe(360, 230));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(320, 294));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(560, 164));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(598, 164));
				stage.addChild(globes[globes.length - 1]);
				
				if (spawnCoins)
				{

					coins.push(new coin(395, 166));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(440, 165));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(482, 164));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(519, 164));
					stage.addChild(coins[coins.length - 1]);
				}

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(275, 84));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(234, 85));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(233, 126));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(234, 168));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(233, 251));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(235, 298));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(235, 342));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(233, 385));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(320, 128));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(323, 209));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(321, 251));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(323, 338));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(324, 381));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(390, 123));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(442, 126));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(403, 253));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(401, 205));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(448, 203));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(367, 342));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(411, 342));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(487, 203));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(523, 204));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(560, 202));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(595, 204));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(598, 125));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(561, 121));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(520, 123));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(480, 128));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(629, 164));
				stage.addChild(walls[walls.length - 1]);

				bombs.push(new bomb(234, 209));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(317, 84));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(323, 167));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(351, 126));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(407, 300));
				stage.addChild(bombs[bombs.length - 1]);
			}
			else if (level == 8)
			{
				lines.push(new line(275, 360, 275, -450, 'x', 'UP', 9999, lineColors[num], false, false));
				lines[lines.length - 1].visible = true;
				stage.addChild(lines[lines.length - 1])

				mirrors.push(new mirror(-22, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(22, 22, 2));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(66, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(110, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(154, 22, 2));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(198, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				globes.push(new globe(374, 135));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(387, 299));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(146, 262));
				stage.addChild(globes[globes.length - 1]);
				if (spawnCoins)
				{
					coins.push(new coin(294, 216));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(330, 135));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(338, 303));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(428, 219));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(191, 302));
					stage.addChild(coins[coins.length - 1]);
				}

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(-100, -100));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(275, 85));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(329, 83));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(378, 81));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(427, 81));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(470, 80));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(478, 190));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(477, 243));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(479, 296));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(481, 345));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(438, 348));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(391, 351));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(340, 353));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(148, 363));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(78, 360));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(76, 91));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(116, 93));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(160, 94));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(203, 92));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(241, 90));
				stage.addChild(walls[walls.length - 1]);

				bombs.push(new bomb(469, 135));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(436, 300));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(79, 258));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(76, 216));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(76, 172));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(76, 127));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(76, 310));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(112, 359));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(131, 160));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(192, 210));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(219, 139));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(135, 209));
				stage.addChild(bombs[bombs.length - 1]);
			}
			else if (level == 9)
			{
				lines.push(new line(550, 200, -450, 200, 'y', 'LEFT', 9999, lineColors[num], false, false));
				lines[lines.length - 1].visible = true;
				stage.addChild(lines[lines.length - 1])

				mirrors.push(new mirror(-22, 22, 2));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(22, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(66, 22, 2));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(110, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(154, 22, 2));
				stage.addChild(mirrors[mirrors.length - 1]);

				globes.push(new globe(108, 126));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(369, 66));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(433, 323));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(393, 324));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(236, 333));
				stage.addChild(globes[globes.length - 1]);
				if (spawnCoins)
				{

					coins.push(new coin(416, 68));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(468, 325));
					stage.addChild(coins[coins.length - 1]);
				}

				walls.push(new block(63, 199));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(437, 377));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(60, 377));
				stage.addChild(walls[walls.length - 1]);

				walls.push(new block(100, 377));
				stage.addChild(walls[walls.length - 1]);

				bombs.push(new bomb(108, 32));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(367, 14));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(415, 17));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(515, 378));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(477, 379));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(391, 378));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(59, 333));
				stage.addChild(bombs[bombs.length - 1]);
			}
			else if (level == 10)
			{
				lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, lineColors[num], false, false));
				lines[lines.length - 1].visible = true;
				stage.addChild(lines[lines.length - 1])

				mirrors.push(new mirror(-22, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(22, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(66, 22, 2));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(110, 22, 1));
				stage.addChild(mirrors[mirrors.length - 1]);

				mirrors.push(new mirror(154, 22, 2));
				stage.addChild(mirrors[mirrors.length - 1]);

				globes.push(new globe(163, 130));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(347, 74));
				stage.addChild(globes[globes.length - 1]);

				globes.push(new globe(387, 316));
				stage.addChild(globes[globes.length - 1]);
				if (spawnCoins)
				{

					coins.push(new coin(310, 76));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(227, 320));
					stage.addChild(coins[coins.length - 1]);

					coins.push(new coin(265, 317));
					stage.addChild(coins[coins.length - 1]);
				}

				bombs.push(new bomb(164, 26));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(439, 75));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(163, 335));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(399, 22));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(108, 74));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(384, 367));
				stage.addChild(bombs[bombs.length - 1]);

				bombs.push(new bomb(434, 319));
				stage.addChild(bombs[bombs.length - 1]);
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
					
					for (var wallNum: int = 0; wallNum < walls.length; wallNum++) // Iterate walls
					{
						if (walls[wallNum].hitTestObject(lines[lineNum])) // If wall is touching line
						{
							hit = true;
							lines[lineNum].draw(walls[wallNum].x, walls[wallNum].y); // Redraw line
							walls[wallNum].gotoAndStop(2);
							walls[wallNum].blocking = true;
						}
					}
					
					if (!hit) // If there was no mirrors or walls interfering with the selected line
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
							if (playerShop.playerItems.indexOf("bomb deflect chance") != -1 && // if they have bomb defence chance
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
					if (playerShop.playerItems.indexOf("double coins") == -1) // if the player dosen't own the double coins upgrade
					{
						money += 1; // increase money by one coin
					}
					else // if they do own the double coins upgrade
					{
						money += 2;
					}
					safeUpdateText(false)
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
			
			for (var checkWall: int = 0; checkWall < walls.length; checkWall++) // Iterate walls
			{
				if (walls[checkWall].blocking == false) // If wall is not touching any line
				{
					walls[checkWall].gotoAndStop(1);
				}
				walls[checkWall].blocking = false;
			}
			
			checkBadges(); // check if they should get any new badges
			
			if (badgeManager.stage)
			{
				stage.setChildIndex(badgeManager, stage.numChildren-1);
			}
			
			if (dialog.stage)
			{
				stage.setChildIndex(dialog, stage.numChildren-1);
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
