package  {
	import flash.display.MovieClip; // We need the movieclip library since the globe class extends movieclip
	import flash.utils.Timer; // We need the timer module so that we can pause for one second to fill up the globe
	import flash.events.TimerEvent; // In order to trigger an event with the timer, we need the TimerEvent library
	
	public class globe extends MovieClip 
	{
		var filling: Boolean = false; // Is this globe currently getting light from a beam to fill up?
		var fillTimer:Timer; // Timer variable to use for waiting 6 seconds before completely filling globe
		var full: Boolean = false; // Is the globe completely full?
		var wait: Boolean = false; // if the globe is already working on a timer to fill
		var hit: Boolean = false; // If the globe was hit in the latest globe loop in LightStage.as
		
		public function globe(globeX: int, globeY: int) // Initialize the globe by putting it somewhere and setting it to empty
		{
			x = globeX; // Move the the X position specified by the main script LightStage.as
			y = globeY; // Move the the Y position specified by the main script LightStage.as
			
			gotoAndStop(1); // globe has 7 frames from empty (1) to full (7)
		}
		
		public function startFill()
		{
			update(); // Make sure all the globe variables are accurate
			if (full == false && filling == true && wait == false) // If it is not already full and a lazer is touching it
			{
				wait = true; // we need to wait for the globe to increment before incrementing the globe again
				fillTimer = new Timer(1000, 1); // prepare a one second timer to pause for one second
				fillTimer.addEventListener(TimerEvent.TIMER, increment); // create a listner for the timer
				fillTimer.start(); // start the timer
			}
		}
		
		public function resetAll() // This function resets the globe to it's origional state
		{
			gotoAndStop(1); // go back to frame 1
			wait = false; // We don't need to wait after resetting the globe - no increment is running
			filling = false; // reset the filling variable (it is no longer being hit by a lazer)
			full = false; // make sure the globe knows that it is not full (it is on frame 1 now)
			update(); // update the globe properties
		}
		
		private function update() // This function makes sure all the globe variables are accurate
		{
			if (filling == false) // If the globe is no longer touching a lazer beam
			{
				full = false; // set full to false, because it is no longer touching a beam
				gotoAndStop(1);
			}
			else if (filling == true && currentFrame == 7 && full == false) // If the globe is full but not set that way
			{
				full = true;
			}
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
			update(); // Check that the globe is not already full
			if (full == false) // If the globe is not already full (on frame 7)
			{
				if (filling == true) // If the globe is touching a lazer beam
				{
					gotoAndStop(currentFrame + 1); // Increase the current frame by one frame to show that it has filled up
					fillTimer.removeEventListener(TimerEvent.TIMER, increment); // remove the timer listener
					wait = false;
					update(); // check that the globe is still touching a line & still not completely full
					if (full == false && filling == true) // If we need to continue filling the globe up
					{
						startFill(); // Run the fill function again 
					}
				}
			}
		}
	}
}
