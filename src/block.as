package  {
	
	import flash.display.MovieClip;
	
	public class block extends MovieClip {
		
		var blocking: Boolean = false;
		
		public function block(blockX: int, blockY: int) {
			x = blockX;
			y = blockY;
			
			gotoAndStop(1); // block has 2 frames from (1) empty to (2) blocked
		}
	}
	
}
