/***************************
LIGHTSTAGE 0.1 FINAL
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
		/***************************
		INSTANCE OF LIGHTSTAGE CLASS
		***************************/
		private static var _instance:LightStage;
		public static function get instance():LightStage { return _instance; }
		
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
		G.vars.dialogbox = new dialogbox();
		G.vars.leveleditor = new leveleditor();
		G.vars.backend = new backend();
		G.vars.badges = new badges();
		G.vars.playerShop = new shop();
		G.vars.badgeManager1 = new badgeAlert();
		G.vars.badgeManager2 = new badgeAlert();
		G.vars.badgesArray = [];
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
			G.vars._stage = stage;
			G.vars._root = this;
		}
		public function safeUpdateText(changeFrame: Boolean = true): void
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
		
		private function keyHandler(event:KeyboardEvent): void // if a key is pressed
		{
			var key:uint = event.keyCode;
			switch (key)
			{
				case Keyboard.SPACE:
					if (G.vars.result == "NEW")
					{
						G.vars.backend.reset();
						G.vars.backend.prepGame();
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
						G.vars.backend.reset(); // reset the game if the R key is pressed
						G.vars.backend.prepGame();
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
						G.vars.dialog.descText.text = "Opening the level editor will reset your game. Do you really want to open the level editor?";
					}
					
					break;
				
				case Keyboard.Q:
					if (G.vars.levelEdit == true)
					{
						G.vars.levelEdit = false;
						G.vars.level = 1;
						G.vars.money = 0;
						G.vars.backend.reset();
						G.vars.backend.prepGame();
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
							stage.addEventListener(Event.ENTER_FRAME, G.vars.backend.enterFrame);
							
							var stopGameTimer:Timer = new Timer(500, 1); 
							stopGameTimer.addEventListener(TimerEvent.TIMER, stopEnterFrame);
							stopGameTimer.start(); // start the timer
						}
						else
						{
							G.vars.dialogbox.simpleDialog("Error!","You need to put at least one globe on the stage to test the G.vars.level");
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
		
		private function stopEnterFrame(event:TimerEvent)
		{
			stage.removeEventListener(Event.ENTER_FRAME, G.vars.backend.enterFrame); // stop enterFrame listener
		}
		
		private function buyDoubleCoins(event:MouseEvent) // purchases double G.vars.coins and tells the user if it worked
		{
			var newMoney = G.vars.playerShop.shopBuy("double G.vars.coins");
			if (newMoney == G.vars.money) { G.vars.dialogbox.simpleDialog("Too poor!","You don't have enough G.vars.coins to buy Double Coins!"); }
			else if (newMoney == 1337) { G.vars.dialogbox.simpleDialog("Already bought!","You already own Double Coins."); }
			else { G.vars.dialogbox.simpleDialog("Purchased Double Coins!","You sucessfully purchased Double Coins!"); G.vars.money = newMoney; }
			safeUpdateText(false);
		}
		
		private function buyBombChance(event:MouseEvent) // purchases bomb defence chance and tells user if it worked
		{
			var newMoney = G.vars.playerShop.shopBuy("bomb deflect chance");
			if (newMoney == G.vars.money) { G.vars.dialogbox.simpleDialog("Too poor!","You don't have enough G.vars.coins to buy Bomb Deflection Chance!"); }
			else if (newMoney == 1337) { G.vars.dialogbox.simpleDialog("Already bought!","You already own Bomb Deflection Chance."); }
			else 
			{
				G.vars.dialogbox.simpleDialog("Purchased Bomb Deflection Chance!","You successfully purchased Bomb Deflection Chance!");
				G.vars.money = newMoney;
			}
			safeUpdateText(false)
		}
		
		private function closeShop(event:MouseEvent): void
		{
			stage.removeChild(G.vars.playerShop);
			G.vars.playerShop.exitShop.removeEventListener(MouseEvent.CLICK, closeShop);
			G.vars.playerShop.doubleCoins.removeEventListener(MouseEvent.CLICK, buyDoubleCoins);
			G.vars.playerShop.bombDeflectChance.removeEventListener(MouseEvent.CLICK, buyBombChance);
		}
		
		
		public function game(event:TimerEvent):void // start the game
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
				G.vars.backend.reset();
				G.vars.backend.prepGame();
			}
			
			stage.addEventListener(Event.ENTER_FRAME, G.vars.backend.enterFrame); // Start enterFrame listener
		}

		
	}
	
}
