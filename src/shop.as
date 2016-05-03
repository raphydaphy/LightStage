package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class shop extends MovieClip
	{
		public var money: int = 0;
		public var items: Array = [];
		
		public function shop(playerCoins: int) 
		{
			trace('working');
			money = playerCoins;
		}
		
		public function setCoins(newBal: int)
		{
			money = newBal;
		}
		
		public function shopBuy(item: String): int
		{
			var itemCost: int = 0;
			if (item == "double coins")
			{
				itemCost = 2;
			}
			else if (item == "bomb deflect chance")
			{
				itemCost = 4;
			}
			
			if (itemCost <= money)
			{
				if (items.indexOf(item) == -1)
				{
					items[items.length] = item;
					money = money - itemCost;
				}
				else
				{
					
					return 1337;
				}
			}
			return money
		}
	}
}