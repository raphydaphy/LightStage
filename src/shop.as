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
			
			if (itemCost <= money)
			{
				if (items.indexOf(item) == -1)
				{
					items[items.length] = item;
					money = money - itemCost;
					
					trace("You bought " + item + "! You have $" + money + " remaining!");
				}
				else
				{
					trace("You already own " + item + "!");
				}
			}
			else
			{
				trace("You are too poor to buy " + item + "! You only have $" + money + " but " + item + " costs $" + itemCost);
			}
			
			return money
		}

	}
	
}
