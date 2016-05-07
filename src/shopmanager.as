package  {
	
	import flash.events.MouseEvent;
	import G;
	public class shopmanager {
		
		public function buyDoubleCoins(event:MouseEvent) // purchases double G.vars.coins and tells the user if it worked
		{
			var newMoney = G.vars.playerShop.shopBuy("double G.vars.coins");
			if (newMoney == 9876) { G.vars.dialogbox.simpleDialog("Too poor!","You don't have enough coins to buy Double Coins!"); }
			else if (newMoney == 1337) { G.vars.dialogbox.simpleDialog("Already bought!","You already own Double Coins."); }
			else { G.vars.dialogbox.simpleDialog("Purchased Double Coins!","You sucessfully purchased Double Coins!"); G.vars.money = newMoney; }
			G.vars._root.safeUpdateText(false);
		}
		
		public function buyBombChance(event:MouseEvent) // purchases bomb defence chance and tells user if it worked
		{
			var newMoney = G.vars.playerShop.shopBuy("bomb deflect chance");
			trace(newMoney);
			if (newMoney == 9876) { G.vars.dialogbox.simpleDialog("Too poor!","You don't have enough coins to buy Bomb Deflection Chance!"); }
			else if (newMoney == 1337) { G.vars.dialogbox.simpleDialog("Already bought!","You already own Bomb Deflection Chance."); }
			else 
			{
				G.vars.dialogbox.simpleDialog("Purchased Bomb Deflection Chance!","You successfully purchased Bomb Deflection Chance!");
				G.vars.money = newMoney;
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
