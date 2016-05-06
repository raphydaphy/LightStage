package  {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import G;
	public class badges {
		
		private function hideBadge1(event:TimerEvent): void // hide the badge alert movieclip
		{
			if (G.vars.badgeManager1.G.vars._stage) { G.vars._stage.removeChild(G.vars.badgeManager1); }
			G.vars.curBadgeBox -= 1;
		}
		
		private function hideBadge2(event:TimerEvent): void // hide the badge alert movieclip
		{
			if (G.vars.badgeManager2.G.vars._stage) { G.vars._stage.removeChild(G.vars.badgeManager2); }
			G.vars.curBadgeBox -= 1;
		}
		
		private function showBadge(title: String, desc: String, cost: int, frame: int): void
		{
			if (!G.vars.badgeManager1.G.vars._stage)
			{
				G.vars.badgesArray.push(title.toLocaleLowerCase());
				G.vars.badgeManager1 = new badgeAlert();
				G.vars.badgeManager1.badgeHeading.text = title;
				G.vars.badgeManager1.badgeDesc.text = desc;
				G.vars.badgeManager1.badgeCost.text = "$" + cost;
				G.vars.badgeManager1.badgeIcon.gotoAndStop(frame);
				G.vars.badgeManager1.x = 275;
				G.vars.badgeManager1.y = 350;
				G.vars._stage.addChild(G.vars.badgeManager1);
				
				var hideBadge1Timer:Timer = new Timer(5000, 1);
				hideBadge1Timer.addEventListener(TimerEvent.TIMER, hideBadge1);
				hideBadge1Timer.start();
			}
			else if (!G.vars.badgeManager2.G.vars._stage)
			{
				G.vars.badgesArray.push(title.toLocaleLowerCase());
				G.vars.badgeManager2 = new badgeAlert();
				G.vars.badgeManager2.badgeHeading.text = title;
				G.vars.badgeManager2.badgeDesc.text = desc;
				G.vars.badgeManager2.badgeCost.text = "$" + cost;
				G.vars.badgeManager2.badgeIcon.gotoAndStop(frame);
				G.vars.badgeManager2.x = 275;
				G.vars.badgeManager2.y = 265;
				G.vars._stage.addChild(G.vars.badgeManager2);
				
				var hideBadge2Timer:Timer = new Timer(5000, 1);
				hideBadge2Timer.addEventListener(TimerEvent.TIMER, hideBadge2);
				hideBadge2Timer.start();
			}
			G.vars.money += cost;
			LightStage.instance.safeUpdateText(false);
			G.vars.curBadgeBox += 1;
		}
		
		public function checkBadges(): void
		{
			if (G.vars.deaths > 4 && // if they have died at least 5 times in a row
				G.vars.badgesArray.indexOf("crash test dummy 1") == -1 ) // if they don't already have the badge
			{
				showBadge("Crash Test Dummy 1","Die 5 times in a single game",5,1);
			}
			
			if (G.vars.deaths > 9 && // if they have died at least 10 times in a row
				G.vars.badgesArray.indexOf("crash test dummy 2") == -1 ) // if they don't already have the badge
			{
				showBadge("Crash Test Dummy 2","Die 10 times in a single game",10,1);
			}
			
			if (G.vars.playerShop.playerItems.length > 1 && // if they have purchased at least 2 items from the shop
				G.vars.badgesArray.indexOf("spending spree 1") == -1) // if they don't already have the badge
			{
				showBadge("Spending Spree 1","Buy at least two items from the ingame shop",5,2);
			}
			
			if (G.vars.level > 4 &&
				G.vars.badgesArray.indexOf("survivor 1") == -1)
			{
				showBadge("Survivor 1","Complete 4 G.vars.levels in a row without dying",10,3);
			}
			
			if (G.vars.level > 8 &&
				G.vars.badgesArray.indexOf("survivor 2") == -1)
			{
				showBadge("Survivor 2","Complete 8 G.vars.levels in a row without dying",25,3);
			}
			
			if (G.vars.detonated > 5 &&
				G.vars.badgesArray.indexOf("killing spree 1") == -1)
			{
				showBadge("Killing Spree 1","Detonate 5 G.vars.bombs",5,4);
			}
			
			if (G.vars.detonated > 10 &&
				G.vars.badgesArray.indexOf("killing spree 2") == -1)
			{
				showBadge("Killing Spree 2","Detonate 10 G.vars.bombs",15,4);
			}
				
			if (G.vars.escaped > 5 &&
				G.vars.badgesArray.indexOf("escape artist 1") == -1)
			{
				showBadge("Escape Artist 1","Dodge 5 G.vars.bombs using Bomb Deflection Chance",10,5);
			}
			
			if (G.vars.escaped > 10 &&
				G.vars.badgesArray.indexOf("escape artist 2") == -2)
			{
				showBadge("Escape Artist 2","Dodge 10 G.vars.bombs using Bomb Deflection Chance",25,5);
			}
		}

	}
	
}
