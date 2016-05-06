package  {
	
	import flash.events.MouseEvent;
	import flash.display.Stage;
	
	import G;
	
	public class leveleditor {
		var randomNum:int;
		public function startEditor(event:MouseEvent): void
		{
			randomNum = Math.floor(Math.random() * G.vars.lineColors.length);
			if (G.vars.dialog.G.vars._stage) { G.vars._stage.removeChild(G.vars.dialog); }
			G.vars.dialog.yesBtn.removeEventListener(MouseEvent.CLICK, G.vars.dialogbox.closeYNDialog);
			G.vars.dialog.noBtn.removeEventListener(MouseEvent.CLICK, G.vars.dialogbox.closeYNDialog);
			G.vars._stage.addChild(G.vars.dialog);
			G.vars.dialog.gotoAndStop(3);
			G.vars.dialog.visible = true;
			G.vars.dialog.x = 275;
			G.vars.dialog.y = 200;
			G.vars.dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			G.vars.dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			G.vars.dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			G.vars.dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			G.vars.dialog.headingText.text = "Level Editor Setup";
			G.vars.dialog.descText.text = "What direction do you want your base line to be going in?";
			G.vars.spawnCoins = true;
			G.vars.levelEdit = true;
			G.vars.backend.reset();
			G.vars.mirrors = new Vector.<mirror>(); // setup G.vars.mirrors vector
			G.vars.lines = new Vector.<line>(); // setup G.vars.lines vector
			G.vars.globes = new Vector.<globe>(); // setup G.vars.globes vector
			G.vars.bombs = new Vector.<bomb>(); // setup G.vars.bombs vector
			G.vars.level = "Editor";
			LightStage.instance.safeUpdateText();
			for (var destroyCoin: int = 0; destroyCoin < G.vars.coins.length; destroyCoin++) // loop through all the G.vars.coins
			{
				G.vars.coins[destroyCoin].destroy(); // reset the coin
				if (G.vars.coins[destroyCoin].G.vars._stage) { G.vars._stage.removeChild(G.vars.coins[destroyCoin]) }
			}
		}
		
		private function levelEditorSetLeft(event:MouseEvent)
		{
			if (G.vars.dialog.G.vars._stage) { G.vars._stage.removeChild(G.vars.dialog); }
			G.vars.dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			G.vars.dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			G.vars.dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			G.vars.dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			G.vars.lines.push(new line(550, 200, -450, 200, 'y', 'LEFT', 9999, G.vars.lineColors[randomNum], false, false));
			G.vars.lines[G.vars.lines.length - 1].visible = true;
			G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
		}
		
		private function levelEditorSetRight(event:MouseEvent)
		{
			if (G.vars.dialog.G.vars._stage) { G.vars._stage.removeChild(G.vars.dialog); }
			G.vars.dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			G.vars.dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			G.vars.dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			G.vars.dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			G.vars.lines.push(new line(0, 200, 1000, 200, 'y', 'RIGHT', 9999, G.vars.lineColors[randomNum], false, false));
			G.vars.lines[G.vars.lines.length - 1].visible = true;
			G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
		}
		
		private function levelEditorSetUp(event:MouseEvent)
		{
			if (G.vars.dialog.G.vars._stage) { G.vars._stage.removeChild(G.vars.dialog); }
			G.vars.dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			G.vars.dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			G.vars.dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			G.vars.dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			G.vars.lines.push(new line(275, 360, 275, -450, 'x', 'UP', 9999, G.vars.lineColors[randomNum], false, false));
			G.vars.lines[G.vars.lines.length - 1].visible = true;
			G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
		}
		
		private function levelEditorSetDown(event:MouseEvent)
		{
			if (G.vars.dialog.G.vars._stage) { G.vars._stage.removeChild(G.vars.dialog); }
			G.vars.dialog.leftBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetLeft);
			G.vars.dialog.rightBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetRight);
			G.vars.dialog.upBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetUp);
			G.vars.dialog.downBtn.addEventListener(MouseEvent.MOUSE_DOWN, levelEditorSetDown);
			
			G.vars.lines.push(new line(275, 120, 275, 450, 'x', 'DOWN', 9999, G.vars.lineColors[randomNum], false, false));
			G.vars.lines[G.vars.lines.length - 1].visible = true;
			G.vars._stage.addChild(G.vars.lines[G.vars.lines.length - 1]);
		}

	}
	
}
