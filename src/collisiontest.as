package
{
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.geom.*;

	import G;
	
	public class collisiontest
	{
		function collision(blueClip, redClip): Boolean
		{ 
			var returnValue: Boolean = false;
			
			if (blueClip.hitTestObject(redClip))
			{
				var blueRect:Rectangle = blueClip.getBounds(G.vars._root);
				var blueOffset:Matrix = blueClip.transform.matrix;
				blueOffset.tx = blueClip.x - blueRect.x;
				blueOffset.ty = blueClip.y - blueRect.y;    

				var blueClipBmpData = new BitmapData(blueRect.width, blueRect.height, true, 0);
				blueClipBmpData.draw(blueClip, blueOffset);     

				var redRect:Rectangle = redClip.getBounds(G.vars._root);
				var redClipBmpData = new BitmapData(redRect.width, redRect.height, true, 0);

				var redOffset:Matrix = redClip.transform.matrix;
				redOffset.tx = redClip.x - redRect.x;
				redOffset.ty = redClip.y - redRect.y;   

				redClipBmpData.draw(redClip, redOffset);    

				var rLoc:Point = new Point(redRect.x, redRect.y);
				var bLoc:Point = new Point(blueRect.x, blueRect.y); 


				if(redClipBmpData.hitTest(rLoc,
												255,
												blueClipBmpData,
												bLoc,
												255
											))
				{
					returnValue = true;
				}
				
				blueClipBmpData.dispose();
				redClipBmpData.dispose();
			}
			
			if (returnValue == true)
			{
				return true;
			}
			else
			{
				return false;
			}
			
		}
	}

}