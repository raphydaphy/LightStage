package  
{
	import G;
	import flash.events.MouseEvent;
	
	public class levels 
	{
		public function tutorial() // a tutorial level set for the first time you play the game
		{
			var num:int=Math.floor(Math.random() * G.vars.lineColors.length);
			
			if (G.vars.level == 1)
			{
				G.vars.hint1.gotoAndStop(1);
				G.vars.hint1.hint.text = "this is a mirror. you can drag it around.";
				G.vars.tutstage = 1;
				G.vars.hint1.x = 70;
				G.vars.hint1.y = 150;
				G.vars._stage.addChild(G.vars.hint1);
				
				G.vars.skipTut.x = 467;
				G.vars.skipTut.y = 383.50;
				G.vars._stage.addChild(G.vars.skipTut);
				G.vars.skipTut.addEventListener(MouseEvent.CLICK, G.vars.backend.skipTutorial);
				
				G.vars.mirrors.push(new mirror(22, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(269, 289));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				G.vars.lines.push(new line(50, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
			}
			else if (G.vars.level == 2)
			{
				G.vars.hint1.gotoAndStop(5);
				G.vars.hint1.hint.text = "this is a bomb. don't direct light at it!";
				G.vars.tutstage = 1;
				G.vars.hint1.x = 180;
				G.vars.hint1.y = 245;
				G.vars._stage.addChild(G.vars.hint1);
				
				G.vars.mirrors.push(new mirror(22, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(72, 301));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.bombs.push(new bomb(75, 180));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
				
				G.vars.lines.push(new line(275, 120, 275, 450, 'x', 'DOWN', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1])
			}
			else if (G.vars.level == 3)
			{		
				G.vars.hint1.gotoAndStop(1);
				G.vars.hint1.hint.text = "this is a refractor. it's another kind of mirror.";
				G.vars.tutstage = 1;
				G.vars.hint1.x = 80;
				G.vars.hint1.y = 150;
				G.vars._stage.addChild(G.vars.hint1);
				
				G.vars.mirrors.push(new mirror(22, 22, 7));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(179, 318));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(223, 279));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				G.vars.lines.push(new line(500, 200, -450, 200, 'y', 'LEFT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1])
			}
			else if (G.vars.level == 4)
			{
				G.vars.hint1.gotoAndStop(2);
				G.vars.hint1.hint.text = "this is a heavy mirror. you can't move it.";
				G.vars.tutstage = 1;
				G.vars.hint1.x = 295;
				G.vars.hint1.y = 80;
				G.vars._stage.addChild(G.vars.hint1);
				
				G.vars.mirrors.push(new mirror(308, 198, 5, "STUCK"));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(22, 22, 2));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(288, 352));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(332, 308));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}

				G.vars.walls.push(new block(452, 337));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);
				
				G.vars.lines.push(new line(50, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
			}
			else if (G.vars.level == 5)
			{
				G.vars.hint1.gotoAndStop(1);
				G.vars.hint1.hint.text = "some levels have multiple mirrors. you will need both of them.";
				G.vars.tutstage = 1;
				G.vars.hint1.x = 80;
				G.vars.hint1.y = 150;
				G.vars._stage.addChild(G.vars.hint1);
				
				G.vars.mirrors.push(new mirror(22, 22, 5));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 4));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(207, 263));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(494, 123));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(238, 293));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				G.vars.lines.push(new line(50, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
			}
		}
		
		public function setupLevel()
		{
			var num:int=Math.floor(Math.random() * G.vars.lineColors.length);
			
			if (G.vars.level == 1)
			{
				G.vars.mirrors.push(new mirror(22, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(357, 364, 1, "STUCK"));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(358, 264));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(254, 363));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(357, 315));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				
				G.vars.lines.push(new line(500, 200, -450, 200, 'y', 'LEFT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
			}
			else if (G.vars.level == 2)
			{
				G.vars.mirrors.push(new mirror(22, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 5));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(220, 167));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(104, 100));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(67, 65));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}

				G.vars.walls.push(new block(274, 94));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);
				
				G.vars.lines.push(new line(275, 350, 275, -450, 'x', 'UP', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
			}
			else if (G.vars.level == 3)
			{
				G.vars.mirrors.push(new mirror(22, 22, 5));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(286, 327, 5, "STUCK"));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 7));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(206, 248));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(361, 328));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(509, 265));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(403, 327));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				
				G.vars.lines.push(new line(50, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
			}
			else if (G.vars.level == 4)
			{
				G.vars.mirrors.push(new mirror(22, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(110, 22, 7));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(91, 269));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(204, 368));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(377, 300));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(91, 316));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(418, 259));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				
				G.vars.lines.push(new line(500, 200, -450, 200, 'y', 'LEFT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
			}
			else if (G.vars.level == 5)
			{
				G.vars.mirrors.push(new mirror(184, 199, 5, "STUCK"));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(22, 22, 4));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 2));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(110, 22, 5));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(347, 287));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(339, 187));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(296, 142));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}

				G.vars.bombs.push(new bomb(435, 200));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(207, 53));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
				
				G.vars.lines.push(new line(50, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
			}
			else if (G.vars.level == 6)
			{
				G.vars.mirrors.push(new mirror(22, 22, 6));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(355, 215, 2, "STUCK"));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 8));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(315, 254));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(252, 54));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(313, 172));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}

				G.vars.walls.push(new block(276, 217));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.bombs.push(new bomb(201, 59));
				
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
				G.vars.lines.push(new line(275, 350, 275, -450, 'x', 'UP', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
			}
			else
			{
				G.vars.result = "OVER";
				G.vars.backend.reset();
				G.vars.backend.prepGame();
			}
		}

	}
	
}
