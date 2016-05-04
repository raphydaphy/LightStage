package
{

	import flash.display.*;
	public class line extends Sprite
	{
		public var loops: int = 0; // how many times this line has been iterated over
		
		public var startX: int; // starting x position to draw the line
		public var startY: int; // starting y position to draw the line

		public var endX: int; // ending x position to draw the line
		public var endY: int; // ending y position to draw the line
		
		public var axis: String; // Axis is the direction which should not change after initialization
		public var dir: String; // Direction the line is traveling in. LEFT, RIGHT, UP or DOWN are valid.
		public var disp: Boolean = true; // Is this line made by another mirror (not a core line)
		public var inter: Boolean = false; // If the line is between TWO different mirrors

		public var origStartX: int; // origional starting x point before mirror hit the line
		public var origStartY: int; // origional starting y point before mirror hit the line
		public var origEndX: int; // origional ending x point before mirror hit the line
		public var origEndY: int; // origional ending y point before mirror hit the line
		
		public var owner: int; // What is the mirror number that created this line?
		public var endMirror: int; // What is the mirror number that this line ends at?
		public var noLoop: Boolean = false; // Should this line not be looped over ?
		public var lineColor: int = 0xf1c40f; // What color should the line be by default?

		public function line(sX: int,
			sY: int,
			eX: int,
			eY: int,
			ax: String,
			direction: String = 'RIGHT',
			fromMirror: int = 9999,
			lColor: int = 0xf1c40f,
			isInter = false,
			isDisp: Boolean = true): void
		{
			owner = fromMirror;

			origStartX = sX;
			origStartY = sY;

			origEndX = eX;
			origEndY = eY;

			axis = ax;
			disp = isDisp;
			dir = direction;
			lineColor = lColor;

			startX = origStartX;
			startY = origStartY;

			endX = origEndX;
			endY = origEndY;

			visible = false;

			draw(eX, eY);
			
			if (disp == false)
			{
				var flashlight = new light();
				
				switch (dir)
				{
					case "LEFT":
						flashlight.x = startX + 30; // move the flashlight so it looks like it is making the line
						flashlight.y = startY; // Move the flashlight to the same Y position as the line it comes from
						flashlight.rotation = 180; // rotate the flashlight so it is facing the right way
						break;
					case "RIGHT":
						flashlight.x = startX - 30; // Position the flashlight so it is just before the start of the line
						flashlight.y = startY; // Move the flashlight to the same Y position as the line it comes from
						flashlight.rotation = 0; // make sure the flash light remains un-rotated
						break;
					case "UP":
						flashlight.x = startX;
						flashlight.y = startY + 30;
						flashlight.rotation = 270;
						break;
					case "DOWN":
						flashlight.x = startX;
						flashlight.y = startY - 30;
						flashlight.rotation = 90;
						break;
				}
				
				this.addChild(flashlight);
			}
		}

		public function reset(): void
		{
			graphics.clear();
			graphics.lineStyle(2, lineColor, 1);
			graphics.moveTo(origStartX, origStartY);
			graphics.lineTo(origEndX, origEndY);
		}
		
		public function destroy(): void
		{
			this.visible = false;
			graphics.clear();
			
			origStartX = -100;
			origStartY = -100;
			
			origEndX = -100;
			origEndY = -100;
			
			update();
			
			noLoop = true;
			disp = true;
		}

		public function update(): void
		{
			origStartX = startX;
			origStartY = startY;

			origEndX = endX;
			origEndY = endY;
		}

		public function draw(toX: int, toY: int): void
		{
			graphics.clear();
			graphics.lineStyle(2, lineColor, 1);
			graphics.moveTo(startX, startY);

			if (axis == 'x')
			{
				graphics.lineTo(origEndX, toY);
			}
			else if (axis == 'y')
			{
				graphics.lineTo(toX, origEndY);
			}


			endX = toX;
			endY = toY;
		}

		public function rmLoop(): void
		{
			noLoop = true;
		}
	}
}