﻿package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class mirror extends MovieClip
	{
		// Purple (frame 1) mirrors are type 1 mirrors
		// Red (frame 2) mirrors are type 2 mirrors
		
		public var dragging: Boolean = true;
		
		public function mirror(mirrorX: int, mirrorY: int, frame: int = 1)
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
			x = mirrorX;
			y = mirrorY;
			gotoAndStop(frame);
		}
		
		public function rotateForwards():void {
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