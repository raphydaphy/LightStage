package  {
	
	import flash.events.MouseEvent;
	import G;
	public class shopmanager {
		
		public function buyDoubleCoins(event:MouseEvent) // purchases double G.vars.coins and tells the user if it worked
		{
			G.vars.playerShop.shopBuy("double coins");
			if (G.vars.shopResult == "poor") 
			{ 
				G.vars.dialogbox.simpleDialog("Too poor!","You don't have enough coins to buy Double Coins!"); 
			}
			else if (G.vars.shopResult == "already got") 
			{ 
				G.vars.dialogbox.simpleDialog("Already bought!","You already own Double Coins."); 
			}
			else if (G.vars.shopResult == "purchased")
			{
				G.vars.dialogbox.simpleDialog("Purchased Double Coins","You successfully purchased Double Coins!");
			}
			G.vars._root.safeUpdateText(false);
		}
		
		public function buyBombChance(event:MouseEvent) // purchases bomb defence chance and tells user if it worked
		{
			G.vars.playerShop.shopBuy("bomb deflect chance");
			if (G.vars.shopResult == "poor") 
			{ 
				G.vars.dialogbox.simpleDialog("Too poor!","You don't have enough coins to buy Bomb Deflection Chance!"); 
			}
			else if (G.vars.shopResult == "already got") 
			{ 
				G.vars.dialogbox.simpleDialog("Already bought!","You already own Bomb Deflection Chance."); 
			}
			else if (G.vars.shopResult == "purchased")
			{
				G.vars.dialogbox.simpleDialog("Purchased Bomb Deflection Chance!","You successfully purchased Bomb Deflection Chance!");
			}
			G.vars._root.safeUpdateText(false)
		}
		
		public function buySkipLevel(event:MouseEvent)
		{
			G.vars.playerShop.shopBuy("skip level");
			if (G.vars.shopResult == "poor")
			{
				G.vars.dialogbox.simpleDialog("Too poor!","You don't have enough coins to skip this level!"); 
			}
			else if (G.vars.shopResult == "purchased")
			{
				G.vars.dialogbox.simpleDialog("Skipped the level!","You successfully purchased Skip Level!");
				G.vars.level = G.vars.level + 1;
				G.vars.backend.reset();
				G.vars.backend.prepGame();
			}
			G.vars._root.safeUpdateText(false);
		}
		
		public function buyRemoveBomb(event:MouseEvent)
		{
			G.vars.playerShop.shopBuy("remove bomb");
			if (G.vars.shopResult == "poor")
			{
				G.vars.dialogbox.simpleDialog("Too poor!","You don't have enough coins to remove a bomb!"); 
			}
			else if (G.vars.shopResult == "purchased")
			{
				if (G.vars.bombs.length > 0)
				{
				var rmBomb:int=Math.floor(Math.random() * G.vars.bombs.length);
					G.vars.bombs[rmBomb].resetAll();
						G.vars.bombs[rmBomb].destroy();
					if (G.vars.bombs[rmBomb].stage) { G.vars._stage.removeChild(G.vars.bombs[rmBomb]); }
					G.vars.dialogbox.simpleDialog("Removed a bomb!","You successfully removed a bomb!");
				}
				else
				{
					G.vars.dialogbox.simpleDialog("There are no bombs!","Sorry! There are no bombs to remove. Lol rip :)");
				}
			}
			G.vars._root.safeUpdateText(false);
		}
		
		public function nextPage(event:MouseEvent): void
		{
			if (G.vars.playerShop.currentFrame == 1)
			{
				G.vars.playerShop.doubleCoins.removeEventListener(MouseEvent.CLICK, buyDoubleCoins);
				G.vars.playerShop.bombDeflectChance.removeEventListener(MouseEvent.CLICK, buyBombChance);
			}
			
			if (G.vars.playerShop.currentFrame != G.vars.playerShop.totalFrames)
			{
				G.vars.playerShop.nextFrame();
			}
			
			if (G.vars.playerShop.currentFrame == 2)
			{
				G.vars.playerShop.skipLevel.addEventListener(MouseEvent.CLICK, buySkipLevel);
				G.vars.playerShop.removeBomb.addEventListener(MouseEvent.CLICK, buyRemoveBomb);
			}
		}
		
		public function prevPage(event:MouseEvent): void
		{
			if (G.vars.playerShop.currentFrame == 2)
			{
				G.vars.playerShop.skipLevel.removeEventListener(MouseEvent.CLICK, buySkipLevel);
				G.vars.playerShop.removeBomb.removeEventListener(MouseEvent.CLICK, buyRemoveBomb);
			}
			
			if (G.vars.playerShop.currentFrame != 1)
			{
				G.vars.playerShop.prevFrame();
			}
			
			if (G.vars.playerShop.currentFrame == 1)
			{
				G.vars.playerShop.doubleCoins.addEventListener(MouseEvent.CLICK, buyDoubleCoins);
				G.vars.playerShop.bombDeflectChance.addEventListener(MouseEvent.CLICK, buyBombChance);
			}
		}
		public function closeShop(event:MouseEvent): void
		{
			G.vars._stage.removeChild(G.vars.playerShop);
			if (G.vars.playerShop.currentFrame == 1)
			{
				G.vars.playerShop.doubleCoins.removeEventListener(MouseEvent.CLICK, buyDoubleCoins);
				G.vars.playerShop.bombDeflectChance.removeEventListener(MouseEvent.CLICK, buyBombChance);
			}
			else if (G.vars.playerShop.currentFrame == 2)
			{
				G.vars.playerShop.skipLevel.removeEventListener(MouseEvent.CLICK, buySkipLevel);
				G.vars.playerShop.removeBomb.removeEventListener(MouseEvent.CLICK, buyRemoveBomb);
			}
			G.vars.playerShop.exitShop.removeEventListener(MouseEvent.CLICK, closeShop);
			
		}

	}
	
}
