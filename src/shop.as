package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import G;
	
	public class shop extends MovieClip
	{
		public var playerItems: Array = [];
		
		public function shopBuy(item: String): int
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
			
			if (itemCost <= G.vars.money)
			{
				if (playerItems.indexOf(item) == -1)
				{
					playerItems[playerItems.length] = item;
					G.vars.money = G.vars.money - itemCost;
				}
				else
				{
					
					return 1337;
				}
			}
			return G.vars.money;
		}
	}
}