package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import G;
	
	public class mirror extends MovieClip
	{
		// Purple (frame 1) mirrors are type 1 mirrors
		// Red (frame 2) mirrors are type 2 mirrors
		
		public var dragging: Boolean = true;
		public var oX: int;
		public var oY: int;
		public var stuck: Boolean = false;
		public function mirror(mirrorX: int, mirrorY: int, frame: int = 1, special: String = "NONE")
		{
			if (special == "STUCK")
			{
				stuck = true;
				var transColor = new ColorTransform();
				transColor.color = 0x34495e;
				this.transform.colorTransform = transColor;
			}
			else 
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
			}
			this.hitbox.visible = false;
			
			x = mirrorX;
			y = mirrorY;
			
			oX = mirrorX;
			oY = mirrorY;
			
			if (frame == 9999)
			{
				gotoAndStop(1);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, onDown, false);
				this.addEventListener(MouseEvent.CLICK, rotateForwards);
			}
			else
			{
				gotoAndStop(frame);
			}
		}
		
		public function rotateForwards(event:MouseEvent):void {
			if(currentFrame < totalFrames)
			{
				gotoAndStop(currentFrame + 1);
			}
			else
			{
				gotoAndStop(1);
			}
		}  
		
		public function rotateBackwards():void {
			if(currentFrame != 1)
			{
				gotoAndStop(currentFrame - 1);
			}
			else
			{
				gotoAndStop(totalFrames);
			}
		} 
		
		public function destroy(): void
		{
			this.visible = false;
			x = -100;
			y = -100;
			try // if the user is still dragging, this can cause an exception
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onDown, false); // they have lifted mouse, so remove listener
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUp, false); // they have lifted mouse, so remove listener
			}
			catch(event:TypeError) // If that causes an error
			{
				// don't need to do anything here
			}
		}

		private function onDown(event: MouseEvent): void
		{
			if (G.vars.tutorial == true)
			{
				G.vars.mirrorDown = true;
			}
			dragging = true;
			
			// add the mouse up listener on the stage, that way it's consistent even if
			// the user drags so fast that the mouse leaves the bounds of the mirror
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);

			this.startDrag();
		}

		private function onUp(event: MouseEvent): void
		{
			dragging = false;
			
			try // if the user is still dragging, this can cause an exception
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUp, false); // they have lifted mouse, so remove listener
			}
			catch(event:TypeError) // If that causes an error
			{
				// don't need to do anything here
			}
			

			this.stopDrag();
		}
	}
}