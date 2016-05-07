package  
{
	import G;
	public class levels 
	{
		public function demoLevel() // a level for testing new features
		{
			var num:int=Math.floor(Math.random() * G.vars.lineColors.length);

			G.vars.mirrors.push(new mirror(22, 22, 5));
	G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

	G.vars.mirrors.push(new mirror(66, 22, 4));
	G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

	G.vars.mirrors.push(new mirror(110, 22, 2));
	G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

	G.vars.mirrors.push(new mirror(154, 22, 5));
	G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

	G.vars.mirrors.push(new mirror(198, 22, 1));
	G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

	G.vars.globes.push(new globe(151, 252));
	G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

	G.vars.globes.push(new globe(362, 189));
	G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

	G.vars.globes.push(new globe(382, 85));
	G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

	G.vars.globes.push(new globe(209, 39));
	G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

	G.vars.globes.push(new globe(139, 378));
	G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
	if (G.vars.spawnCoins)
	{

		G.vars.coins.push(new coin(177, 281));
		G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

		G.vars.coins.push(new coin(280, 272));
		G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

		G.vars.coins.push(new coin(320, 232));
		G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

		G.vars.coins.push(new coin(136, 97));
		G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

		G.vars.coins.push(new coin(137, 167));
		G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
	}
	G.vars.lines.push(new line(50, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false));
	G.vars.lines[G.vars.lines.length - 1].visible = true;
	G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1])
		}
		public function setupLevel()
		{
			var num:int=Math.floor(Math.random() * G.vars.lineColors.length);
			
			if (G.vars.level == 1)
			{
				G.vars.mirrors.push(new mirror(100, 350)); // Make a testing mirror to deflect UP / RIGHT
				G.vars._stage.addChild(G.vars.mirrors[0]); // Add the new mirror to the stage
				
				G.vars.mirrors.push(new mirror(300, 350, 3)); // Make a nw mirror
				G.vars._stage.addChild(G.vars.mirrors[1]); // Add the new mirror to the stage
				
				G.vars.globes.push(new globe(100, 250)); // add a new globe to the G.vars.globes array
				G.vars._stage.addChild(G.vars.globes[0]); // add the new globe to the stage
				
				G.vars.globes.push(new globe(300, 250)); // add a new globe to the G.vars.globes array
				G.vars._stage.addChild(G.vars.globes[1]); // add the new globe to the stage
				
				if (G.vars.spawnCoins) // make sure users don't get duplicate G.vars.coins
				{
					G.vars.coins.push(new coin(200, 250)); // add a new coin to the G.vars.coins vector
					G.vars._stage.addChild(G.vars.coins[0]); // add the new coin to the stage
				}
				
				G.vars.lines.push(new line(50, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				G.vars._stage.addChild(G.vars.lines[0]); // Add baseline to the stage
			}
			else if (G.vars.level == 2)
			{
				G.vars.mirrors.push(new mirror(450, 200)); // Make a mirror
				G.vars._stage.addChild(G.vars.mirrors[0]); // Add the new mirror to the stage
				
				G.vars.mirrors.push(new mirror(450, 300, 3)); // Make a mirror
				G.vars._stage.addChild(G.vars.mirrors[1]); // Add the new mirror to the stage
				
				G.vars.globes.push(new globe(225, 300)); // add a new globe to the G.vars.globes vector
				G.vars._stage.addChild(G.vars.globes[0]); // add the new globe to the stage
				
				G.vars.bombs.push(new bomb(300, 300)); // make a new bomb
				G.vars._stage.addChild(G.vars.bombs[0]); // add the new bomb to the stage
				
				G.vars.walls.push(new block(300, 340));
				G.vars._stage.addChild(G.vars.walls[0]);
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(260, 300)); // add a new coin to the G.vars.coins vector
					G.vars._stage.addChild(G.vars.coins[0]); // add the new coin to the stage
				}
				
				G.vars.lines.push(new line(400, 350, 400, 0, 'x', 'UP', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				G.vars._stage.addChild(G.vars.lines[0]); // Add baseline to the stage
			}
			else if (G.vars.level == 3)
			{
				G.vars.mirrors.push(new mirror(191, 300)); // Make a new mirror
				G.vars._stage.addChild(G.vars.mirrors[0]); // Add the new mirror to the stage
				
				G.vars.mirrors.push(new mirror(332, 300, 3)); // Make a new mirror
				G.vars._stage.addChild(G.vars.mirrors[1]); // Add the new mirror to the stage
				
				G.vars.mirrors.push(new mirror(498, 300, 3)); // Make a new mirror
				G.vars._stage.addChild(G.vars.mirrors[2]); // Add the new mirror to the stage
				
				G.vars.globes.push(new globe(191, 250)); // add a new globe to the G.vars.globes array
				G.vars._stage.addChild(G.vars.globes[0]); // add the new globe to the stage
				
				G.vars.globes.push(new globe(498, 250)); // add a new globe to the G.vars.globes array
				G.vars._stage.addChild(G.vars.globes[1]); // add the new globe to the stage
				
				G.vars.bombs.push(new bomb(332, 235)); // add a new bomb to the G.vars.bombs array
				G.vars._stage.addChild(G.vars.bombs[0]); // add the new globe to the stage
				
				G.vars.bombs.push(new bomb(332, 270)); // add a new bomb to the G.vars.bombs array
				G.vars._stage.addChild(G.vars.bombs[1]); // add the new globe to the stage
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(414, 300)); // add a new coin to the G.vars.coins vector
					G.vars._stage.addChild(G.vars.coins[0]); // add the new coin to the stage
					
					G.vars.coins.push(new coin(250, 300)); // add a new coin to the G.vars.coins vector
					G.vars._stage.addChild(G.vars.coins[1]); // add the new coin to the stage
				}
				
				G.vars.lines.push(new line(50, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				G.vars._stage.addChild(G.vars.lines[0]); // Add baseline to the stage
			}
			else if (G.vars.level == 4)
			{
				G.vars.mirrors.push(new mirror(3.45, 21.45, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.mirrors.push(new mirror(41.2, 21.45, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.mirrors.push(new mirror(84.45, 20.05, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.mirrors.push(new mirror(120, 20.45));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(254.5, 274.75));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
					
					G.vars.coins.push(new coin(254.5, 139.75));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				
				G.vars.globes.push(new globe(301, 274.75));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				G.vars.globes.push(new globe(341.5, 332.5));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				G.vars.globes.push(new globe(285.75, 139.75));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				G.vars.bombs.push(new bomb(334.75, 216.5));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
				
				G.vars.bombs.push(new bomb(284.75, 216.5));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
				
				G.vars.bombs.push(new bomb(234.75, 216.5));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
				
				G.vars.lines.push(new line(500, 383.75, -450, 383.75, 'y', 'LEFT', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				G.vars._stage.addChild(G.vars.lines[0]); // Add baseline to the stage
				
			}
			else if (G.vars.level == 5)
			{
				G.vars.lines.push(new line(450, 50, 450, 1000, 'x', 'DOWN', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				G.vars._stage.addChild(G.vars.lines[0]); // Add baseline to the stage
				
				G.vars.mirrors.push(new mirror(22, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.mirrors.push(new mirror(102, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);


				G.vars.globes.push(new globe(361, 153));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(313, 292));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(394, 340));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(311, 243));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(391, 153));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(514, 153));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				G.vars.bombs.push(new bomb(267, 152));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(313, 378));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(520, 333));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(522, 280));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(521, 215));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
			}
			else if (G.vars.level == 6)
			{
				G.vars.lines.push(new line(480, 350, 480, 0, 'x', 'UP', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				G.vars._stage.addChild(G.vars.lines[0]); // Add baseline to the stage
				
				G.vars.mirrors.push(new mirror(22, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.mirrors.push(new mirror(110, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(387, 296));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(544, 176));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(350, 299));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(309, 298));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(297, 182));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(331, 179));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(367, 181));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(399, 180));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				G.vars.bombs.push(new bomb(189, 299));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(186, 243));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(185, 180));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(432, 238));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(386, 239));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(338, 240));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(299, 242));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(188, 119));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(225, 119));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(277, 123));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(319, 124));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(363, 127));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(411, 123));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(539, 109));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(544, 237));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(545, 291));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(546, 345));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(539, 53));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(410, 60));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(356, 59));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(302, 56));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(240, 52));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(190, 53));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(191, 348));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(242, 348));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(289, 351));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(332, 352));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(370, 353));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(408, 355));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(435, 354));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
			}
			else if (G.vars.level == 7)
			{
				G.vars.lines.push(new line(275, 350, 275, 0, 'x', 'UP', 9999, G.vars.lineColors[num], false, false)); // add core line
				G.vars.lines[0].visible = true; // Make the baseline visible
				G.vars._stage.addChild(G.vars.lines[0]); // Add baseline to the stage
				
				G.vars.mirrors.push(new mirror(22, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.mirrors.push(new mirror(110, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(360, 230));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(320, 294));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(560, 164));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(598, 164));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				
				if (G.vars.spawnCoins)
				{

					G.vars.coins.push(new coin(395, 166));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(440, 165));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(482, 164));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(519, 164));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}
				
				G.vars.walls.push(new block(275, 84));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(234, 85));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(233, 126));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(234, 168));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(233, 251));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(235, 298));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(235, 342));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(233, 385));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(320, 128));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(323, 209));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(321, 251));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(323, 338));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(324, 381));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(390, 123));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(442, 126));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(403, 253));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(401, 205));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(448, 203));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(367, 342));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(411, 342));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(487, 203));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(523, 204));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(560, 202));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(595, 204));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(598, 125));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(561, 121));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(520, 123));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(480, 128));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(629, 164));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.bombs.push(new bomb(234, 209));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(317, 84));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(323, 167));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(351, 126));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(407, 300));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
			}
			else if (G.vars.level == 8)
			{
				G.vars.lines.push(new line(275, 350, 275, -450, 'x', 'UP', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1])

				G.vars.mirrors.push(new mirror(22, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(110, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(154, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(198, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.mirrors.push(new mirror(22, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(374, 135));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(387, 299));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(146, 262));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{
					G.vars.coins.push(new coin(294, 216));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(330, 135));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(338, 303));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(428, 219));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(191, 302));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}

				G.vars.walls.push(new block(275, 85));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(329, 83));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(378, 81));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(427, 81));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(470, 80));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(478, 190));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(477, 243));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(479, 296));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(481, 345));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(438, 348));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(391, 351));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(340, 353));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(148, 363));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(78, 360));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(76, 91));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(116, 93));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(160, 94));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(203, 92));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(241, 90));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.bombs.push(new bomb(469, 135));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(436, 300));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(79, 258));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(76, 216));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(76, 172));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(76, 127));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(76, 310));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(112, 359));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(131, 160));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(192, 210));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(219, 139));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(135, 209));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
			}
			else if (G.vars.level == 9)
			{
				G.vars.lines.push(new line(500, 200, -450, 200, 'y', 'LEFT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1])
				G.vars.mirrors.push(new mirror(22, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(110, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(154, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(198, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.globes.push(new globe(108, 126));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(369, 66));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(433, 323));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(393, 324));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(236, 333));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{

					G.vars.coins.push(new coin(416, 68));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(468, 325));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}

				G.vars.walls.push(new block(63, 199));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(437, 377));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(60, 377));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.walls.push(new block(100, 377));
				G.vars._stage.addChild(G.vars.walls[G.vars.walls.length - 1]);

				G.vars.bombs.push(new bomb(108, 32));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(367, 14));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(415, 17));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(515, 378));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(477, 379));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(391, 378));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(59, 333));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
			}
			else if (G.vars.level == 10)
			{
				G.vars.lines.push(new line(50, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[num], false, false));
				G.vars.lines[G.vars.lines.length - 1].visible = true;
				G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1])

				G.vars.mirrors.push(new mirror(22, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(66, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(110, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.mirrors.push(new mirror(154, 22, 3));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);
				
				G.vars.mirrors.push(new mirror(198, 22, 1));
				G.vars._stage.addChild(G.vars.mirrors[G.vars.mirrors.length - 1]);

				G.vars.globes.push(new globe(163, 130));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(347, 74));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);

				G.vars.globes.push(new globe(387, 316));
				G.vars._stage.addChild(G.vars.globes[G.vars.globes.length - 1]);
				if (G.vars.spawnCoins)
				{

					G.vars.coins.push(new coin(310, 76));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(227, 320));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);

					G.vars.coins.push(new coin(265, 317));
					G.vars._stage.addChild(G.vars.coins[G.vars.coins.length - 1]);
				}

				G.vars.bombs.push(new bomb(164, 26));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(439, 75));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(163, 335));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(399, 22));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(108, 74));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(384, 367));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);

				G.vars.bombs.push(new bomb(434, 319));
				G.vars._stage.addChild(G.vars.bombs[G.vars.bombs.length - 1]);
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
