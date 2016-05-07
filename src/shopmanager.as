package  {
	
	import flash.events.MouseEvent;
	import G;
	public class shopmanager {
		
		public function buyDoubleCoins(event:MouseEvent) // purchases double G.vars.coins and tells the user if it worked
		{
			G.vars.playerShop.shopBuy("double coins");
			trace(G.vars.shopResult);
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
			trace(G.vars.shopResult);
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
		
		public function closeShop(event:MouseEvent): void
		{
			G.vars._stage.removeChild(G.vars.playerShop);
			G.vars.playerShop.exitShop.removeEventListener(MouseEvent.CLICK, closeShop);
			G.vars.playerShop.doubleCoins.removeEventListener(MouseEvent.CLICK, buyDoubleCoins);
			G.vars.playerShop.bombDeflectChance.removeEventListener(MouseEvent.CLICK, buyBombChance);
		}

	}
	
}
