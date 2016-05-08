package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import G;
	
	public class shop extends MovieClip
	{
		public function shop()
		{
			gotoAndStop(1);
			G.vars.itemsPurchased = 0;
		}
		public function shopBuy(item: String)
		{
			var itemCost: int = 0;
			if (item == "double coins")
			{
				itemCost = 8;
			}
			else if (item == "bomb deflect chance")
			{
				itemCost = 5;
			}
			else if (item == "skip level")
			{
				itemCost = 25;
			}
			else if (item == "remove bomb")
			{
				itemCost = 10;
			}
			
			if (itemCost <= G.vars.money)
			{
				if (G.vars.playerItems.indexOf(item) == -1)
				{
					G.vars.itemsPurchased += 1;
					if (item != "skip level" && item != "remove bomb")
					{
						G.vars.playerItems[G.vars.playerItems.length] = item;
					}
					G.vars.money = G.vars.money - itemCost;
					G.vars.shopResult = "purchased";
				}
				else
				{
					G.vars.shopResult = "already got";
				}
			}
			else
			{
				G.vars.shopResult = "poor";
			}
		}
	}
}