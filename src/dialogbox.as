package  {
	import flash.events.MouseEvent;
	import flash.display.Stage;

	public class dialogbox {
		public function closeSimpleDialog(event:MouseEvent): void
		{
			if (G.vars.dialog.stage) { G.vars._stage.removeChild(G.vars.dialog); }
			G.vars.dialog.okBtn.removeEventListener(MouseEvent.CLICK, closeSimpleDialog);
		}
		
		public function closeYNDialog(event:MouseEvent): void
		{
			if (G.vars.dialog.stage) { G.vars._stage.removeChild(G.vars.dialog); }
			G.vars.dialog.yesBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
			G.vars.dialog.noBtn.removeEventListener(MouseEvent.CLICK, closeYNDialog);
		}

		public function simpleDialog(heading: String, desc: String)
		{
			G.vars._stage.addChild(G.vars.dialog);
			G.vars.dialog.gotoAndStop(2);
			G.vars.dialog.visible = true;
			G.vars.dialog.x = 275;
			G.vars.dialog.y = 200;
			G.vars.dialog.okBtn.addEventListener(MouseEvent.MOUSE_DOWN, closeSimpleDialog);
			G.vars.dialog.headingText.text = heading;
			G.vars.dialog.descText.text = desc;
		}
	}
	
}
