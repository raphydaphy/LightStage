package  {
	
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import G;
	
	public class keyboard {

		public function keyboard() {
			// constructor code
		}
		
		
		public function keyHandler(event:KeyboardEvent): void // if a key is pressed
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
					if (noReset == false && G.vars.levelEdit == false && G.vars.resetting == false && G.vars.tutorial == false)
					{
						G.vars.result = "RESTART"; // make sure the reset function knows that the user restarted the game
						G.vars.backend.reset(); // reset the game if the R key is pressed
						G.vars.backend.prepGame();
					}
					
					break;
				
				case Keyboard.S:
					G.vars._stage.addChild(G.vars.playerShop);
					G.vars.playerShop.x = 275;
					G.vars.playerShop.y = 200;
					
					G.vars.playerShop.exitShop.addEventListener(MouseEvent.CLICK, G.vars.shopmanager.closeShop);
					G.vars.playerShop.doubleCoins.addEventListener(MouseEvent.CLICK, G.vars.shopmanager.buyDoubleCoins);
					G.vars.playerShop.bombDeflectChance.addEventListener(MouseEvent.CLICK, G.vars.shopmanager.buyBombChance);	
					break;
				
				case Keyboard.L:
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
						G.vars.mirrors.push(new mirror(G.vars._root.mouseX, G.vars._root.mouseY, 9999));
						G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
					}
					break;
					
				case Keyboard.B:
					if (G.vars.levelEdit == true)
					{
						G.vars.bombs.push(new bomb(G.vars._root.mouseX, G.vars._root.mouseY));
						G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
					}
					break;
					
				case Keyboard.G:
					if (G.vars.levelEdit == true)
					{
						G.vars.globes.push(new globe(G.vars._root.mouseX, G.vars._root.mouseY));
						G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
					}
					break;
					
				case Keyboard.C:
					if (G.vars.levelEdit == true)
					{
						G.vars.coins.push(new coin(G.vars._root.mouseX, G.vars._root.mouseY));
						G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
					}
					break;
				case Keyboard.W:
					if (G.vars.levelEdit == true)
					{
						G.vars.walls.push(new block(G.vars._root.mouseX, G.vars._root.mouseY));
						G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);
					}
					break;
				case Keyboard.T:
					if (G.vars.levelEdit == true)
					{
						if (G.vars.globes.length > 0)
						{
							G.vars.level = 0;
							G.vars.money = 0;
							G.vars._stage.addEventListener(Event.ENTER_FRAME, G.vars.backend.enterFrame);
							
							var stopGameTimer:Timer = new Timer(500, 1); 
							stopGameTimer.addEventListener(TimerEvent.TIMER, G.vars.backend.stopEnterFrame);
							stopGameTimer.start(); // start the timer
						}
						else
						{
							G.vars.dialogbox.simpleDialog("Error!","You need to put at least one globe on the stage to test the level");
						}
					}
					break;
				case Keyboard.P:
					if (G.vars.levelEdit == true)
					{
						trace('===================START LEVEL CODE===================');
						var mirrorX = 22;
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
								trace('G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);');
								if (mirrorX > 197) { mirrorX = 22; mirrorY += 50; }
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
								trace('G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);');
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
									trace('\tG.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);');
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
								trace('G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);');
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
								trace('G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);');
							}
						}
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
								trace('G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1])');
							}
						}
						trace('====================END LEVEL CODE====================');
					}
			}
			
		}

	}
	
}
