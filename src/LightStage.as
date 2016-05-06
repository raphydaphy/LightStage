/***************************
LIGHTSTAGE 0.1 BETA 4
Built by Raph Hennessy
All Rights Reserved May 2016
***************************/
package
{
	import flash.events.* // Import all flash event modules for enterFrame, mouseEvent etc..
	import flash.display.MovieClip;  // The G.vars.mirrors are movieclips, so we need their library
	import flash.utils.Timer; // We need the timer library for the one second game start delay
	import flash.ui.Keyboard; // We need this for controlling the keyboard events
	import flash.system.fscommand; // We need this to stop the game when you win
	
	import G;
	
	[SWF(backgroundColor = "0x1abc9c")] // Set the background color to turquoise
	
	public class LightStage extends MovieClip // Main class declaration for the LightStage game
	{
		/**********************************************
		PUBLIC VECTORS FOR MOVIECLIPS & CLASS INSTANCES
		**********************************************/
		G.vars.mirrors = new Vector.<mirror>(); // vector for the mirror movieclips
		G.vars.lines = new Vector.<line>(); // this vector stores all the line sprites
		G.vars.globes = new Vector.<globe>(); // vector to store all the G.vars.globes
		G.vars.bombs = new Vector.<bomb>(); // vector to store all the bomb movieclips
		G.vars.coins = new Vector.<coin>(); // vector to store all the coin movieclips
		G.vars.walls = new Vector.<block>(); // vector to store all the coin movieclips
		
		/*******************************************************
		GLOBAL VARIABLES FOR COUNTING SCORES & STORING INSTANCES
		*******************************************************/
		G.vars.money = 0;
		G.vars.level = 1;
		G.vars.startupMsg = "LightStage is starting...";
		G.vars.dialog = new openShop();
		G.vars.playerShop = new shop(G.vars.money);
		G.vars.badgeManager1 = new badgeAlert();
		G.vars.badgeManager2 = new badgeAlert();
		G.vars.badges = [];
		G.vars.levelEdit = false;
		G.vars.resetting = false;
		G.vars.maxLevel = 0;
		G.vars.deaths = 0;
		G.vars.detonated = 0;
		G.vars.escaped = 0;
		G.vars.curBadgeBox = 0;
		G.vars.lineColors = [0x2ecc71, 0x27ae60, 0x3498db, 0x2980b9, 0x9b59b6, 0x8e44ad, 0x34495e, 0x2c3e50,
										 0xf1c40f, 0xf1c40f, 0xe67e22, 0xe74c3c, 0xecf0f1, 0x95a5a6, 0xf39c12, 0xd35400,
										 0xc0392b, 0xbdc3c7, 0x7f8c8d];
		G.vars.result = "NEW"; // what happened in the last game that was played?
		G.vars.spawnCoins = true; // did they win or is it their first game? then we should spawn new G.vars.coins!
		
		public function LightStage() // The initialization function that sets up the game
		{
			gotoAndStop(1); // go to the first frame 'Welcome to LightStage'
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler); // start keyHandler listener
		}
		
		private function keyHandler(event:KeyboardEvent): void // if a key is pressed
		{
			var key:uint = event.keyCode;
			switch (key)
			{
				case Keyboard.SPACE:
					if (G.vars.result == "NEW")
					{
						reset();
						prepGame();
					}
					break;
					
				case Keyboard.R:
					var noReset: Boolean = false;
					for (var bombNum: int = 0; bombNum < G.vars.bombs.length; bombNum++) //iterate through G.vars.globes
					{
						if (G.vars.bombs[bombNum].exploding == true)
						{
							noReset = true;
						}
					}
					if (noReset == false && G.vars.levelEdit == false && G.vars.resetting == false)
					{
						G.vars.result = "RESTART"; // make sure the reset function knows that the user restarted the game
						reset(); // reset the game if the R key is pressed
						prepGame();
					}
					
					break;
				
				case Keyboard.S:
					stage.addChild(G.vars.playerShop);
					G.vars.playerShop.x = 275;
					G.vars.playerShop.y = 200;
					
					G.vars.playerShop.exitShop.addEventListener(MouseEvent.CLICK, closeShop);
					G.vars.playerShop.doubleCoins.addEventListener(MouseEvent.CLICK, buyDoubleCoins);
					G.vars.playerShop.bombDeflectChance.addEventListener(MouseEvent.CLICK, buyBombChance);	
					break;
				
				case Keyboard.L:
					stage.addChild(G.vars.dialog);
					G.vars.dialog.gotoAndStop(1);
					G.vars.dialog.visible = true;
					G.vars.dialog.x = 275;
					G.vars.dialog.y = 200;
					
					if (G.vars.levelEdit == true)
					{
						G.vars.dialog.yesBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditor);
						G.vars.dialog.noBtn.addEventListener(MouseEvent.MOUSE_DOWN, closeYNDialog);
						G.vars.dialog.headingText.text = "Are you sure?";
						G.vars.dialog.descText.text = "Do you really want to reset this G.vars.level?";
					}
					else
					{
						G.vars.dialog.yesBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditor);
						G.vars.dialog.noBtn.addEventListener(MouseEvent.MOUSE_DOWN, closeYNDialog);
						G.vars.dialog.headingText.text = "Are you sure?";
						G.vars.dialog.descText.text = "Opening the G.vars.level editor will reset your game. Do you really want to open the G.vars.level editor?";
					}
					
					break;
				
				case Keyboard.Q:
					if (G.vars.levelEdit == true)
					{
						G.vars.levelEdit = false;
						G.vars.level = 1;
						G.vars.money = 0;
						G.vars.playerShop.setCoins(G.vars.money);
						reset();
						prepGame();
					}
					break;
					
				case Keyboard.M:
					if (G.vars.levelEdit == true)
					{
						G.vars.mirrors.push(new mirror(mouseX, mouseY, 9999));
						stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
					}
					break;
					
				case Keyboard.B:
					if (G.vars.levelEdit == true)
					{
						G.vars.bombs.push(new bomb(mouseX, mouseY));
						stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
					}
					break;
					
				case Keyboard.G:
					if (G.vars.levelEdit == true)
					{
						G.vars.globes.push(new globe(mouseX, mouseY));
						stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
					}
					break;
					
				case Keyboard.C:
					if (G.vars.levelEdit == true)
					{
						G.vars.coins.push(new coin(mouseX, mouseY));
						stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
					}
					break;
				case Keyboard.W:
					if (G.vars.levelEdit == true)
					{
						G.vars.walls.push(new block(mouseX, mouseY));
						stage.addChild(G.vars.walls[G.vars.walls.length - 1]);
					}
					break;
				case Keyboard.T:
					if (G.vars.levelEdit == true)
					{
						if (G.vars.globes.length > 0)
						{
							G.vars.level = 0;
							G.vars.money = 0;
							G.vars.playerShop.setCoins(G.vars.money);
							stage.addEventListener(Event.ENTER_FRAME, enterFrame);
							
							var stopGameTimer:Timer = new Timer(500, 1); 
							stopGameTimer.addEventListener(TimerEvent.TIMER, stopEnterFrame);
							stopGameTimer.start(); // start the timer
						}
						else
						{
							simpleDialog("Error!","You need to put at least one globe on the stage to test the G.vars.level");
						}
					}
					break;
				case Keyboard.P:
					if (G.vars.levelEdit == true)
					{
						trace('===================START LEVEL CODE===================');
						for (var printLine: int = 0; printLine < G.vars.lines.length; printLine++)
						{
							if (G.vars.lines[printLine].disp == false)
							{
								trace('G.vars.lines.push(new line(' + G.vars.lines[printLine].origStartX +
									   ', ' + G.vars.lines[printLine].origStartY +
									   ', ' + G.vars.lines[printLine].origEndX +
									   ', ' + G.vars.lines[printLine].origEndY +
									   ", '" + G.vars.lines[printLine].axis + "'" +
									   ", '" + G.vars.lines[printLine].dir + "'" +
									   ', 9999, G.vars.lineColors[num]' +
									   ', false, false));');
								trace('G.vars.lines[G.vars.lines.length - 1].visible = true;');
								trace('stage.addChild(G.vars.lines[G.vars.lines.length - 1])');
							}
						}
						
						var mirrorX = -22
						var mirrorY = 22;
						for (var printMirror: int = 0; printMirror < G.vars.mirrors.length; printMirror++)
						{
							if (G.vars.mirrors[printMirror].x != -100 && G.vars.mirrors[printMirror].y != -100)
							{
								trace('\nG.vars.mirrors.push(new mirror(' + 
									  mirrorX + 
									  ', ' + mirrorY +
									  ', ' + G.vars.mirrors[printMirror].currentFrame +
									  '));');
								trace('stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);');
								if (mirrorX > 197) { mirrorX = -22; mirrorY += 50; }
								else { mirrorX += 44; }
							}
						}
						for (var printGlobe: int = 0; printGlobe < G.vars.globes.length; printGlobe++)
						{
							if (G.vars.globes[printGlobe].x != -100 && G.vars.globes[printGlobe].y != -100)
							{
								trace('\nG.vars.globes.push(new globe(' + 
									  G.vars.globes[printGlobe].x + 
									  ', ' + G.vars.globes[printGlobe].y +
									  '));');
								trace('stage.addChild(G.vars.globes[G.vars.globes.length - 1]);');
							}
						}
						
						if (G.vars.coins.length > 0)
						{
							trace('if (G.vars.spawnCoins)');
							trace('{');
							for (var printCoin: int = 0; printCoin < G.vars.coins.length; printCoin++)
							{
								if (G.vars.coins[printCoin].x != -100 && G.vars.coins[printCoin].y != -100)
								{
									trace('\n\tG.vars.coins.push(new coin(' + 
										  G.vars.coins[printCoin].x + 
										  ', ' + G.vars.coins[printCoin].y +
										  '));');
									trace('\tstage.addChild(G.vars.coins[G.vars.coins.length - 1]);');
								}
							}
							trace('}');
						}
						for (var printWall: int = 0; printWall < G.vars.walls.length; printWall++)
						{
							if (G.vars.walls[printWall].x != -100 && G.vars.walls[printWall].y != -100)
							{
								trace('\nG.vars.walls.push(new block(' + 
									  G.vars.walls[printWall].x + 
									  ', ' + G.vars.walls[printWall].y +
									  '));');
								trace('stage.addChild(G.vars.walls[G.vars.walls.length - 1]);');
							}
						}
						for (var printBomb: int = 0; printBomb < G.vars.bombs.length; printBomb++)
						{
							if (G.vars.bombs[printBomb].x != -100 && G.vars.bombs[printBomb].y != -100)
							{
								trace('\nG.vars.bombs.push(new bomb(' + 
									  G.vars.bombs[printBomb].x + 
									  ', ' + G.vars.bombs[printBomb].y +
									  '));');
								trace('stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);');
							}
						}
						trace('====================END LEVEL CODE====================');
					}
			}
			
		}

		private function simpleDialog(heading: String, desc: String)
		{
			stage.addChild(G.vars.dialog);
			G.vars.dialog.gotoAndStop(2);
			G.vars.dialog.visible = true;
			G.vars.dialog.x = 275;
			G.vars.dialog.y = 200;
			G.vars.dialog.okBtn.addEventListener(MouseEvent.MOUSE_DOWN, closeSimpleDialog);
			G.vars.dialog.headingText.text = heading;
			G.vars.dialog.descText.text = desc;
		}
		
		private function stopEnterFrame(event:TimerEvent)
		{
			stage.removeEventListener(Event.ENTER_FRAME, enterFrame); // stop enterFrame listener
		}
		
		private function buyDoubleCoins(event:MouseEvent) // purchases double G.vars.coins and tells the user if it worked
		{
			var newMoney = G.vars.playerShop.shopBuy("double G.vars.coins");
			if (newMoney == G.vars.money) { simpleDialog("Too poor!","You don't have enough G.vars.coins to buy Double Coins!"); }
			else if (newMoney == 1337) { simpleDialog("Already bought!","You already own Double Coins."); }
			else { simpleDialog("Purchased Double Coins!","You sucessfully purchased Double Coins!"); G.vars.money = newMoney; }
			safeUpdateText(false);
			G.vars.playerShop.setCoins(G.vars.money);
		}
		
		private function buyBombChance(event:MouseEvent) // purchases bomb defence chance and tells user if it worked
		{
			var newMoney = G.vars.playerShop.shopBuy("bomb deflect chance");
			if (newMoney == G.vars.money) { simpleDialog("Too poor!","You don't have enough G.vars.coins to buy Bomb Deflection Chance!"); }
			else if (newMoney == 1337) { simpleDialog("Already bought!","You already own Bomb Deflection Chance."); }
			else 
			{
				simpleDialog("Purchased Bomb Deflection Chance!","You successfully purchased Bomb Deflection Chance!");
				G.vars.money = newMoney;
			}
			safeUpdateText(false)
			G.vars.playerShop.setCoins(G.vars.money);
		}
		
		private function closeShop(event:MouseEvent): void
		{
			stage.removeChild(G.vars.playerShop);
			G.vars.playerShop.exitShop.removeEventListener(MouseEvent.CLICK, closeShop);
			G.vars.playerShop.doubleCoins.removeEventListener(MouseEvent.CLICK, buyDoubleCoins);
			G.vars.playerShop.bombDeflectChance.removeEventListener(MouseEvent.CLICK, buyBombChance);
		}
		
		private function closeSimpleDialog(event:MouseEvent): void
		{
			if (G.vars.dialog.stage) { stage.removeChild(G.vars.dialog); }
			G.vars.dialog.okBtn.removeEventListener(MouseEvent.CLICK, closeSimpleDialog);
		}
		
		private function closeYNDialog(event:MouseEvent): void
		{
			if (G.vars.dialog.stage) { stage.removeChild(G.vars.dialog); }
			G.vars.dialog.yesBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
			G.vars.dialog.noBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
		}
		
		private function levelUp(): void // if the user completes the previous G.vars.level
		{
			G.vars.level += 1;
			reset();
			prepGame();
		}
		
		private function levelEditor(event:MouseEvent): void
		{
			var num:int=Math.floor(Math.random() * G.vars.lineColors.length);
			if (G.vars.dialog.stage) { stage.removeChild(G.vars.dialog); }
			G.vars.dialog.yesBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
			G.vars.dialog.noBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
			stage.addChild(G.vars.dialog);
			G.vars.dialog.gotoAndStop(3);
			G.vars.dialog.visible = true;
			G.vars.dialog.x = 275;
			G.vars.dialog.y = 200;
			G.vars.dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			G.vars.dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			G.vars.dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			G.vars.dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			G.vars.dialog.headingText.text = "Level Editor Setup";
			G.vars.dialog.descText.text = "What direction do you want your base line to be going in?";
			G.vars.spawnCoins = true;
			G.vars.levelEdit = true;
			reset();
			G.vars.mirrors = new Vector.<mirror>(); // setup G.vars.mirrors vector
			G.vars.lines = new Vector.<line>(); // setup G.vars.lines vector
			G.vars.globes = new Vector.<globe>(); // setup G.vars.globes vector
			G.vars.bombs = new Vector.<bomb>(); // setup G.vars.bombs vector
			G.vars.level = "Editor";
			safeUpdateText()
			for (var destroyCoin: int = 0; destroyCoin < G.vars.coins.length; destroyCoin++) // loop through all the G.vars.coins
			{
				G.vars.coins[destroyCoin].destroy(); // reset the coin
				if (G.vars.coins[destroyCoin].stage) { stage.removeChild(G.vars.coins[destroyCoin]) }
			}
		}
		
		private function levelEditorSetLeft(event:MouseEvent)
		{
			if (G.vars.dialog.stage) { stage.removeChild(G.vars.dialog); }
			G.vars.dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			G.vars.dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			G.vars.dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			G.vars.dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			G.vars.lines.push(new line(550, 200, -450, 200, 'y', 'LEFT', 9999, G.vars.lineColors[num], false, false));
			G.vars.lines[G.vars.lines.length - 1].visible = true;
			stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
		}
		
		private function levelEditorSetRight(event:MouseEvent)
		{
			if (G.vars.dialog.stage) { stage.removeChild(G.vars.dialog); }
			G.vars.dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			G.vars.dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			G.vars.dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			G.vars.dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			G.vars.lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false));
			G.vars.lines[G.vars.lines.length - 1].visible = true;
			stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
		}
		
		private function levelEditorSetUp(event:MouseEvent)
		{
			if (G.vars.dialog.stage) { stage.removeChild(G.vars.dialog); }
			G.vars.dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			G.vars.dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			G.vars.dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			G.vars.dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			G.vars.lines.push(new line(275, 360, 275, -450, 'x', 'UP', 9999, G.vars.lineColors[num], false, false));
			G.vars.lines[G.vars.lines.length - 1].visible = true;
			stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
		}
		
		private function levelEditorSetDown(event:MouseEvent)
		{
			if (G.vars.dialog.stage) { stage.removeChild(G.vars.dialog); }
			G.vars.dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			G.vars.dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			G.vars.dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			G.vars.dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			G.vars.lines.push(new line(275, 120, 275, 450, 'x', 'DOWN', 9999, G.vars.lineColors[num], false, false));
			G.vars.lines[G.vars.lines.length - 1].visible = true;
			stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
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
					G.vars.playerShop.setCoins(G.vars.money);
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
				if (G.vars.lines[destroyLine].stage) { stage.removeChild(G.vars.lines[destroyLine]); } // remove from stage
			}
			for (var destroyMirror: int = 0; destroyMirror < G.vars.mirrors.length; destroyMirror++) // loop through G.vars.mirrors vector
			{
				G.vars.mirrors[destroyMirror].destroy(); // Kind of destroy the mirror (run the function in the class)
				if (G.vars.mirrors[destroyMirror].stage) { stage.removeChild(G.vars.mirrors[destroyMirror]); } // remove mirror from stage
			}
			for (var destroyGlobe: int = 0; destroyGlobe < G.vars.globes.length; destroyGlobe++) // loop through all the G.vars.globes
			{
				G.vars.globes[destroyGlobe].resetAll(); // reset the globe
				G.vars.globes[destroyGlobe].destroy(); // destroy the globe
				if (G.vars.globes[destroyGlobe].stage) { stage.removeChild(G.vars.globes[destroyGlobe]) } // remove globe from the stage
			}
			for (var destroyBomb: int = 0; destroyBomb < G.vars.bombs.length; destroyBomb++) // loop through all the G.vars.bombs
			{
				G.vars.bombs[destroyBomb].destroy(); // destroy the bomb
				if (G.vars.bombs[destroyBomb].stage) { stage.removeChild(G.vars.bombs[destroyBomb]) } // remove bomb from the stage
			}
			for (var destroyWall: int = 0; destroyWall < G.vars.walls.length; destroyWall++) // loop through all the G.vars.walls
			{
				G.vars.walls[destroyWall].resetAll(); // reset the wall
				G.vars.walls[destroyWall].destroy(); // destroy the wall
				if (G.vars.walls[destroyWall].stage) { stage.removeChild(G.vars.walls[destroyWall]) } // remove G.vars.walls from the stage
			}
			
			
			for (var destroyCoin: int = 0; destroyCoin < G.vars.coins.length; destroyCoin++) // loop through all the G.vars.coins
			{
				G.vars.coins[destroyCoin].resetAll(); // reset the coin
				if (G.vars.coins[destroyCoin].stage) { stage.removeChild(G.vars.coins[destroyCoin]) }
			}
			
			stage.removeEventListener(Event.ENTER_FRAME, enterFrame); // stop enterFrame listener
		}
		
		private function hideBadge1(event:TimerEvent): void // hide the badge alert movieclip
		{
			if (G.vars.badgeManager1.stage) { stage.removeChild(G.vars.badgeManager1); }
			G.vars.curBadgeBox -= 1;
		}
		
		private function hideBadge2(event:TimerEvent): void // hide the badge alert movieclip
		{
			if (G.vars.badgeManager2.stage) { stage.removeChild(G.vars.badgeManager2); }
			G.vars.curBadgeBox -= 1;
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
			if (!G.vars.badgeManager1.stage)
			{
				G.vars.badges.push(title.toLocaleLowerCase());
				G.vars.badgeManager1 = new badgeAlert();
				G.vars.badgeManager1.badgeHeading.text = title;
				G.vars.badgeManager1.badgeDesc.text = desc;
				G.vars.badgeManager1.badgeCost.text = "$" + cost;
				G.vars.badgeManager1.badgeIcon.gotoAndStop(frame);
				G.vars.badgeManager1.x = 275;
				G.vars.badgeManager1.y = 350;
				stage.addChild(G.vars.badgeManager1);
				
				var hideBadge1Timer:Timer = new Timer(5000, 1);
				hideBadge1Timer.addEventListener(TimerEvent.TIMER, hideBadge1);
				hideBadge1Timer.start();
			}
			else if (!G.vars.badgeManager2.stage)
			{
				G.vars.badges.push(title.toLocaleLowerCase());
				G.vars.badgeManager2 = new badgeAlert();
				G.vars.badgeManager2.badgeHeading.text = title;
				G.vars.badgeManager2.badgeDesc.text = desc;
				G.vars.badgeManager2.badgeCost.text = "$" + cost;
				G.vars.badgeManager2.badgeIcon.gotoAndStop(frame);
				G.vars.badgeManager2.x = 275;
				G.vars.badgeManager2.y = 265;
				stage.addChild(G.vars.badgeManager2);
				
				var hideBadge2Timer:Timer = new Timer(5000, 1);
				hideBadge2Timer.addEventListener(TimerEvent.TIMER, hideBadge2);
				hideBadge2Timer.start();
			}
			G.vars.money += cost;
			G.vars.playerShop.setCoins(G.vars.money);
			safeUpdateText(false);
			G.vars.curBadgeBox += 1;
		}
		
		private function checkBadges(): void
		{
			if (G.vars.deaths > 4 && // if they have died at least 5 times in a row
				G.vars.badges.indexOf("crash test dummy 1") == -1 ) // if they don't already have the badge
			{
				showBadge("Crash Test Dummy 1","Die 5 times in a single game",5,1);
			}
			
			if (G.vars.deaths > 9 && // if they have died at least 10 times in a row
				G.vars.badges.indexOf("crash test dummy 2") == -1 ) // if they don't already have the badge
			{
				showBadge("Crash Test Dummy 2","Die 10 times in a single game",10,1);
			}
			
			if (G.vars.playerShop.playerItems.length > 1 && // if they have purchased at least 2 items from the shop
				G.vars.badges.indexOf("spending spree 1") == -1) // if they don't already have the badge
			{
				showBadge("Spending Spree 1","Buy at least two items from the ingame shop",5,2);
			}
			
			if (G.vars.level > 4 &&
				G.vars.badges.indexOf("survivor 1") == -1)
			{
				showBadge("Survivor 1","Complete 4 G.vars.levels in a row without dying",10,3);
			}
			
			if (G.vars.level > 8 &&
				G.vars.badges.indexOf("survivor 2") == -1)
			{
				showBadge("Survivor 2","Complete 8 G.vars.levels in a row without dying",25,3);
			}
			
			if (G.vars.detonated > 5 &&
				G.vars.badges.indexOf("killing spree 1") == -1)
			{
				showBadge("Killing Spree 1","Detonate 5 G.vars.bombs",5,4);
			}
			
			if (G.vars.detonated > 10 &&
				G.vars.badges.indexOf("killing spree 2") == -1)
			{
				showBadge("Killing Spree 2","Detonate 10 G.vars.bombs",15,4);
			}
				
			if (G.vars.escaped > 5 &&
				G.vars.badges.indexOf("escape artist 1") == -1)
			{
				showBadge("Escape Artist 1","Dodge 5 G.vars.bombs using Bomb Deflection Chance",10,5);
			}
			
			if (G.vars.escaped > 10 &&
				G.vars.badges.indexOf("escape artist 2") == -2)
			{
				showBadge("Escape Artist 2","Dodge 10 G.vars.bombs using Bomb Deflection Chance",25,5);
			}
		}
		
		private function game(event:TimerEvent):void // start the game
		{
			G.vars.resetting = false;
			if (G.vars.result == "OVER") // if the user has won the game
			{
				fscommand("quit"); // exit the game
			}
			
			gotoAndStop(3); // Go to blank frame to start the game on
			
			G.vars.mirrors = new Vector.<mirror>(); // setup G.vars.mirrors vector
			G.vars.lines = new Vector.<line>(); // setup G.vars.lines vector
			G.vars.globes = new Vector.<globe>(); // setup G.vars.globes vector
			G.vars.bombs = new Vector.<bomb>(); // setup G.vars.bombs vector
			
			if (G.vars.spawnCoins) // make sure users don't get duplicate G.vars.coins
			{
				G.vars.coins = new Vector.<coin>(); // setup G.vars.coins vector
			}
			else
			{
				for (var fixCoin: int = 0; fixCoin < G.vars.coins.length; fixCoin++) // loop through all the G.vars.coins
				{
					if (G.vars.coins[fixCoin].full == false)
					{
						G.vars.coins[fixCoin].visible = true;
					}
				}
			}
			
			var num:int=Math.floor(Math.random() * G.vars.lineColors.length);
			
			if (G.vars.level == 1)
			{
				G.vars.mirrors.push(new mirror(100, 350)); // Make a testing mirror to deflect UP / RIGHT
				stage.addChild(G.vars.mirrors[0]); // Add the new mirror to the stage
				
				G.vars.mirrors.push(new mirror(300, 350, 2)); // Make a nw mirror
				stage.addChild(G.vars.mirrors[1]); // Add the new mirror to the stage
				
				G.vars.globes.push(new globe(100, 250)); // add a new globe to the G.vars.globes array
				stage.addChild(G.vars.globes[0]); // add the new globe to the stage
				
				G.vars.globes.push(new globe(300, 250)); // add a new globe to the G.vars.globes array
				stage.addChild(G.vars.globes[1]); // add the new globe to the stage
				
				if (G.vars.spawnCoins) // make sure users don't get duplicate G.vars.coins
				{
					G.vars.coins.push(new coin(200, 250)); // add a new coin to the G.vars.coins vector
					stage.addChild(G.vars.coins[0]); // add the new coin to the stage
				}
				
				G.vars.lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				stage.addChild(G.vars.lines[0]); // Add baseline to the stage
			}
			else if (G.vars.level == 2)
			{
				G.vars.mirrors.push(new mirror(450, 200)); // Make a mirror
				stage.addChild(G.vars.mirrors[0]); // Add the new mirror to the stage
				
				G.vars.mirrors.push(new mirror(450, 300, 2)); // Make a mirror
				stage.addChild(G.vars.mirrors[1]); // Add the new mirror to the stage
				
				G.vars.globes.push(new globe(225, 300)); // add a new globe to the G.vars.globes vector
				stage.addChild(G.vars.globes[0]); // add the new globe to the stage
				
				G.vars.bombs.push(new bomb(300, 300)); // make a new bomb
				stage.addChild(G.vars.bombs[0]); // add the new bomb to the stage
				
				G.vars.walls.push(new block(300, 340));
				stage.addChild(G.vars.walls[0]);
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(260, 300)); // add a new coin to the G.vars.coins vector
					stage.addChild(G.vars.coins[0]); // add the new coin to the stage
				}
				
				G.vars.lines.push(new line(400, 370, 400, 0, 'x', 'UP', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				stage.addChild(G.vars.lines[0]); // Add baseline to the stage
			}
			else if (G.vars.level == 3)
			{
				G.vars.mirrors.push(new mirror(191, 300)); // Make a new mirror
				stage.addChild(G.vars.mirrors[0]); // Add the new mirror to the stage
				
				G.vars.mirrors.push(new mirror(332, 300, 2)); // Make a new mirror
				stage.addChild(G.vars.mirrors[1]); // Add the new mirror to the stage
				
				G.vars.mirrors.push(new mirror(498, 300, 2)); // Make a new mirror
				stage.addChild(G.vars.mirrors[2]); // Add the new mirror to the stage
				
				G.vars.globes.push(new globe(191, 250)); // add a new globe to the G.vars.globes array
				stage.addChild(G.vars.globes[0]); // add the new globe to the stage
				
				G.vars.globes.push(new globe(498, 250)); // add a new globe to the G.vars.globes array
				stage.addChild(G.vars.globes[1]); // add the new globe to the stage
				
				G.vars.bombs.push(new bomb(332, 235)); // add a new bomb to the G.vars.bombs array
				stage.addChild(G.vars.bombs[0]); // add the new globe to the stage
				
				G.vars.bombs.push(new bomb(332, 270)); // add a new bomb to the G.vars.bombs array
				stage.addChild(G.vars.bombs[1]); // add the new globe to the stage
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(414, 300)); // add a new coin to the G.vars.coins vector
					stage.addChild(G.vars.coins[0]); // add the new coin to the stage
					
					G.vars.coins.push(new coin(250, 300)); // add a new coin to the G.vars.coins vector
					stage.addChild(G.vars.coins[1]); // add the new coin to the stage
				}
				
				G.vars.lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				stage.addChild(G.vars.lines[0]); // Add baseline to the stage
			}
			else if (G.vars.level == 4)
			{
				G.vars.mirrors.push(new mirror(-37, 20.45));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.mirrors.push(new mirror(3.45, 21.45, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.mirrors.push(new mirror(41.2, 21.45, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.mirrors.push(new mirror(84.45, 20.05, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(254.5, 274.75));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
					
					G.vars.coins.push(new coin(254.5, 139.75));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				
				G.vars.globes.push(new globe(301, 274.75));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				G.vars.globes.push(new globe(341.5, 332.5));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				G.vars.globes.push(new globe(285.75, 139.75));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				G.vars.bombs.push(new bomb(334.75, 216.5));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
				
				G.vars.bombs.push(new bomb(284.75, 216.5));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
				
				G.vars.bombs.push(new bomb(234.75, 216.5));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
				
				G.vars.lines.push(new line(550, 383.75, -450, 383.75, 'y', 'LEFT', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				stage.addChild(G.vars.lines[0]); // Add baseline to the stage
				
			}
			else if (G.vars.level == 5)
			{
				G.vars.lines.push(new line(450, 50, 450, 1000, 'x', 'DOWN', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				stage.addChild(G.vars.lines[0]); // Add baseline to the stage
				
				G.vars.mirrors.push(new mirror(-22, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(22, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(361, 153));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(313, 292));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(394, 340));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(311, 243));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(391, 153));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(514, 153));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				G.vars.bombs.push(new bomb(267, 152));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(313, 378));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(520, 333));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(522, 280));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(521, 215));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
			}
			else if (G.vars.level == 6)
			{
				G.vars.lines.push(new line(480, 370, 480, 0, 'x', 'UP', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				stage.addChild(G.vars.lines[0]); // Add baseline to the stage
				
				G.vars.mirrors.push(new mirror(-22, 22, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(22, 22, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(387, 296));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(544, 176));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(350, 299));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(309, 298));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(297, 182));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(331, 179));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(367, 181));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(399, 180));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				G.vars.bombs.push(new bomb(189, 299));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(186, 243));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(185, 180));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(432, 238));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(386, 239));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(338, 240));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(299, 242));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(188, 119));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(225, 119));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(277, 123));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(319, 124));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(363, 127));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(411, 123));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(539, 109));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(544, 237));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(545, 291));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(546, 345));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(539, 53));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(410, 60));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(356, 59));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(302, 56));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(240, 52));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(190, 53));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(191, 348));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(242, 348));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(289, 351));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(332, 352));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(370, 353));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(408, 355));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(435, 354));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
			}
			else if (G.vars.level == 7)
			{
				G.vars.lines.push(new line(275, 370, 275, 0, 'x', 'UP', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				stage.addChild(G.vars.lines[0]); // Add baseline to the stage
				
				G.vars.mirrors.push(new mirror(-22, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(22, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(360, 230));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(320, 294));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(560, 164));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(598, 164));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				if (G.vars.spawnCoins)
				{

					G.vars.coins.push(new coin(395, 166));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(440, 165));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(482, 164));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(519, 164));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				
				G.vars.walls.push(new block(275, 84));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(234, 85));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(233, 126));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(234, 168));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(233, 251));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(235, 298));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(235, 342));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(233, 385));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(320, 128));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(323, 209));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(321, 251));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(323, 338));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(324, 381));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(390, 123));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(442, 126));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(403, 253));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(401, 205));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(448, 203));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(367, 342));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(411, 342));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(487, 203));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(523, 204));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(560, 202));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(595, 204));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(598, 125));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(561, 121));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(520, 123));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(480, 128));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(629, 164));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.bombs.push(new bomb(234, 209));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(317, 84));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(323, 167));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(351, 126));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(407, 300));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
			}
			else if (G.vars.level == 8)
			{
				G.vars.lines.push(new line(275, 360, 275, -450, 'x', 'UP', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				stage.addChild(G.vars.lines[G.vars.lines.length - 1])

				G.vars.mirrors.push(new mirror(-22, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(22, 22, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(110, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(154, 22, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(198, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(374, 135));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(387, 299));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(146, 262));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(294, 216));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(330, 135));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(338, 303));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(428, 219));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(191, 302));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}

				G.vars.walls.push(new block(275, 85));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(329, 83));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(378, 81));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(427, 81));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(470, 80));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(478, 190));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(477, 243));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(479, 296));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(481, 345));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(438, 348));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(391, 351));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(340, 353));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(148, 363));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(78, 360));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(76, 91));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(116, 93));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(160, 94));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(203, 92));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(241, 90));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.bombs.push(new bomb(469, 135));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(436, 300));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(79, 258));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(76, 216));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(76, 172));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(76, 127));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(76, 310));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(112, 359));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(131, 160));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(192, 210));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(219, 139));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(135, 209));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
			}
			else if (G.vars.level == 9)
			{
				G.vars.lines.push(new line(550, 200, -450, 200, 'y', 'LEFT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				stage.addChild(G.vars.lines[G.vars.lines.length - 1])

				G.vars.mirrors.push(new mirror(-22, 22, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(22, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(110, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(154, 22, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(108, 126));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(369, 66));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(433, 323));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(393, 324));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(236, 333));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{

					G.vars.coins.push(new coin(416, 68));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(468, 325));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}

				G.vars.walls.push(new block(63, 199));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(437, 377));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(60, 377));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(100, 377));
				stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.bombs.push(new bomb(108, 32));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(367, 14));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(415, 17));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(515, 378));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(477, 379));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(391, 378));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(59, 333));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
			}
			else if (G.vars.level == 10)
			{
				G.vars.lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				stage.addChild(G.vars.lines[G.vars.lines.length - 1])

				G.vars.mirrors.push(new mirror(-22, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(22, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(110, 22, 1));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(154, 22, 2));
				stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(163, 130));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(347, 74));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(387, 316));
				stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{

					G.vars.coins.push(new coin(310, 76));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(227, 320));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(265, 317));
					stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}

				G.vars.bombs.push(new bomb(164, 26));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(439, 75));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(163, 335));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(399, 22));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(108, 74));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(384, 367));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(434, 319));
				stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
			}
			else
			{
				G.vars.result = "OVER";
				reset();
				prepGame();
			}
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrame); // Start enterFrame listener
		}

		// This function is called once every milisecond, unless it takes longer than that to run
		// In that case, it is called when it finishes running. Essentially, it runs once each tick.
		private function enterFrame(event: Event)
		{
			
			for (var lineNum: int = 0; lineNum < G.vars.lines.length; lineNum++) // Loop through G.vars.lines vector
			{
				if (G.vars.lines[lineNum].noLoop == false) // Don't loop through G.vars.lines that we don't need anymore
				{
					G.vars.lines[lineNum].loops += 1; // increase the amount of times we have looped over this line
					
					if (G.vars.lines[lineNum].loops > 1 && G.vars.lines[lineNum].disp == true) // if the line has been iterated already
					{
						G.vars.lines[lineNum].noLoop = true; // make sure the line never gets iterated over again
						stage.removeChild(G.vars.lines[lineNum]); // remove the line from the stage
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
						if (G.vars.lines[lineNum].stage && // If the line is on the stage
							G.vars.lines[lineNum].disp == true && // If the line is disposible (not base line)
							lineNum != G.vars.lines.length - 1) // If it is not within the last 1 G.vars.lines made
						{
							stage.removeChild(G.vars.lines[lineNum]); // Remove the line from the stage
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
							if (G.vars.playerShop.playerItems.indexOf("bomb deflect chance") != -1 && // if they have bomb defence chance
								Math.round(Math.random())) // if they are lucky and manage to dodge the bomb
							{
								G.vars.bombs[bombNum].resetAll();
								G.vars.bombs[bombNum].destroy();
								if (G.vars.bombs[bombNum].stage) { stage.removeChild(G.vars.bombs[bombNum]); }
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
					if (G.vars.playerShop.playerItems.indexOf("double G.vars.coins") == -1) // if the player dosen't own the double G.vars.coins upgrade
					{
						G.vars.money += 1; // increase G.vars.money by one coin
					}
					else // if they do own the double G.vars.coins upgrade
					{
						G.vars.money += 2;
					}
					safeUpdateText(false)
					G.vars.playerShop.setCoins(G.vars.money);
					G.vars.coins[checkCoin].resetAll(); // reset selected coin
					stage.removeChild(G.vars.coins[checkCoin]); // remove the coin from the stage
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
			
			checkBadges(); // check if they should get any new G.vars.badges
			
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
		
		private function bringToFront(stageItem)
		{
			stage.setChildIndex(stageItem, stage.numChildren-1);
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
				stage.addChild(G.vars.lines[G.vars.lines.length - 1]); // Add the temporary line to the stage
				G.vars.lines[G.vars.lines.length - 1].visible = true; // Make the line visible to the user
			}
			else // If the line that the mirror hit was created by another mirror bounce
			{
				stage.addChild(tmpLine); // Add the (invisible) temp line to the stage for hit testing
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
					
				stage.removeChild(tmpLine);
				G.vars.lines.push(tmpLine);
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
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
	}
	
}
