package  {
	import flash.display.MovieClip; // we need the movieclip module since coin is a movieclip class that extends MovieClip
	import flash.utils.Timer; // We need the timer module so that we can pause for one second to fill up the coin
	import flash.events.TimerEvent; // In order to trigger an event with the timer, we need the TimerEvent library
	
	public class coin extends MovieClip {
		
		var filling: Boolean = false; // Is this coin currently getting light from a beam to fill up?
		var fillTimer:Timer; // Timer variable to use for waiting 1200ms before completely filling coin
		var full: Boolean = false; // Is the coin completely full?
		var wait: Boolean = false; // if the coin is already working on a timer to fill
		var hit: Boolean = false; // If the coin was hit in the latest coin loop in LightStage.as
		
		public function coin(coinX: int, coinY: int) {
			x = coinX;
			y = coinY;
			gotoAndStop(1); // coin has 7 frames, from empty (0) to full (7)
		}
		
		public function startFill()
		{
			update(); // Make sure all the coin variables are accurate
			if (full == false && filling == true && wait == false) // If it is not already full and a lazer is touching it
			{
				wait = true; // we need to wait for the coin to increment before incrementing the coin again
				fillTimer = new Timer(200, 1); // prepare a one second timer to pause for 200ms
				fillTimer.addEventListener(TimerEvent.TIMER, increment); // create a listener for the timer
				fillTimer.start(); // start the timer
			}
		}
		
		public function resetAll() // This function resets the coin to it's origional state and hides it
		{
			gotoAndStop(1); // go back to frame 1
			wait = false; // We don't need to wait after resetting the coin - no increment is running
			filling = false; // reset the filling variable (it is no longer being hit by a lazer)
			full = false; // make sure the coin knows that it is not full (it is on frame 1 now)
			update(); // update the coin properties
		}
		
		public function destroy()
		{
			gotoAndStop(1);
			visible = false;
			x = -100;
			y = -100;
		}
		
		private function update() // This function makes sure all the coin variables are accurate
		{
			if (filling == false) // If the coin is no longer touching a lazer beam
			{
				full = false; // set full to false, because it is no longer touching a beam
				gotoAndStop(1);
			}
			else if (filling == true && currentFrame == 7 && full == false) // If the coin is full but not set that way
			{
				full = true;
			}
		}
		
		private function increment(event:TimerEvent) // This function increments the fill state of the coin
		{
			update(); // Check that the coin is not already full
			if (full == false) // If the coin is not already full (on frame 7)
			{
				if (filling == true) // If the coin is touching a lazer beam
				{
					gotoAndStop(currentFrame + 1); // Increase the current frame by one frame to show that it has filled up
					fillTimer.removeEventListener(TimerEvent.TIMER, increment); // remove the timer listener
					wait = false;
					update(); // check that the coin is still touching a line & still not completely full
					if (full == false && filling == true) // If we need to continue filling the coin up
					{
						startFill(); // Run the fill function again 
					}
				}
			}
		}

	}
	
}
