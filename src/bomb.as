package  {
	import flash.display.MovieClip; // the bomb class extends the bomb movieclip, so we need this module to control it
	import flash.utils.Timer; // We need the timer module so that we can pause for one second to blow up the bomb
	import flash.events.TimerEvent; // In order to trigger an event with the timer, we need the TimerEvent library
	
	public class bomb extends MovieClip 
	{
		var explodeTimer:Timer; // Timer variable to use for waiting 2400ms before blowing up the bomb
		var exploded: Boolean = false; // Is the bomb completely exploded?
		var wait: Boolean = false; // if the bomb is already working on a timer to fill
		
		public function bomb(bombX: int, bombY: int) // bomb initialization
		{
			x = bombX; // move the bomb to the specified x position
			y = bombY; // move the bomb to the specified y position
			gotoAndStop(1); // bomb has 8 frames from empty (1) to full (8)
		}
		
		public function startExplode() // start blowing up the bomb
		{
			if (wait == false)
			{
				wait = true; // we need to wait for the bomb to increment before incrementing the bomb again
				explodeTimer = new Timer(300, 1); // prepare a 300 millisecond timer to pause for 300 milliseconds
				explodeTimer.addEventListener(TimerEvent.TIMER, increment); // create a listener for the timer
				explodeTimer.start(); // start the timer
			}
		}
		
		public function resetAll() // This function resets the bomb to it's origional state
		{
			gotoAndStop(1); // go back to frame 1
			wait = false; // We don't need to wait after resetting the bomb - no increment is running
			exploded = false; // make sure the bomb knows that it is not exploded (it is on frame 1 now)
		}
		
		public function destroy()
		{
			gotoAndStop(1);
			visible = false;
			x = -100;
			y = -100;
		}
		
		private function increment(event:TimerEvent) // This function increments the fill state of the globe
		{
			if (currentFrame < 8) // If the bomb is not already full (on frame 8)
			{
				gotoAndStop(currentFrame + 1); // Increase the current frame by one frame to show that it has filled up
				explodeTimer.removeEventListener(TimerEvent.TIMER, increment); // remove the timer listener
				wait = false;
				if (currentFrame == 8) // should the bomb be marked as exploded now?
				{
					exploded = true; // if it should, set it as exploded
				}
				if (exploded == false) // If we need to continue filling the globe up
				{
					startExplode(); // Run the fill function again 
				}
			}
			else
			{
				exploded = true; // the bomb has passed frame 7, so it has fully exploded
			}
		}

	}
	
}
