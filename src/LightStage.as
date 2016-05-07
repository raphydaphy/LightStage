/***************************
LIGHTSTAGE 0.1 FINAL
Built by Raph Hennessy
All Rights Reserved May 2016
***************************/
package
{
	import flash.events.* // Import all flash event modules for enterFrame, mouseEvent etc..
	import flash.display.MovieClip;  // The G.vars.mirrors are movieclips, so we need their library
	import flash.utils.Timer; // We need the timer library for the one second game start delay
	import flash.system.fscommand; // We need this to stop the game when you win
	
	import G;
	
	[SWF(backgroundColor = "0x1abc9c")] // Set the background color to turquoise
	
	public class LightStage extends MovieClip // Main class declaration for the LightStage game
	{
		/***************************
		INSTANCE OF LIGHTSTAGE CLASS
		***************************/
		private static var _instance:LightStage;
		public static function get instance():LightStage { return _instance; }
		
		/**********************************************
		PUBLIC VECTORS FOR MOVIECLIPS & CLASS INSTANCES
		**********************************************/
		G.vars.mirrors = new Vector.<mirror>(); // vector for the mirror movieclips
		G.vars.lines = new Vector.<line>(); // this vector stores all the line sprites
		G.vars.globes = new Vector.<globe>(); // vector to store all the G.vars.globes
		G.vars.bombs = new Vector.<bomb>(); // vector to store all the bomb movieclips
		G.vars.coins = new Vector.<coin>(); // vector to store all the coin movieclips
		G.vars.walls = new Vector.<block>(); // vector to store all the coin movieclips
		
		/*******************************************
		GLOBAL VARIABLES FOR STORING CLASS INSTANCES
		*******************************************/
		G.vars.dialog = new openShop();
		G.vars.dialogbox = new dialogbox();
		G.vars.leveleditor = new leveleditor();
		G.vars.backend = new backend();
		G.vars.badges = new badges();
		G.vars.playerShop = new shop();
		G.vars.badgeManager1 = new badgeAlert();
		G.vars.badgeManager2 = new badgeAlert();
		G.vars.keyboard = new keyboard();
		G.vars.shopmanager = new shopmanager();
		G.vars.levels = new levels();
		
		/*********************************************
		GLOBAL VARIABLES FOR COUNTING SCORES & STRINGS
		*********************************************/
		G.vars.money = 0;
		G.vars.level = 1;
		G.vars.startupMsg = "LightStage is starting...";
		G.vars.badgesArray = [];
		G.vars.levelEdit = false;
		G.vars.resetting = false;
		G.vars.maxLevel = 0;
		G.vars.deaths = 0;
		G.vars.detonated = 0;
		G.vars.escaped = 0;
		G.vars.curBadgeBox = 0;
		G.vars.lineColors = [0x2ecc71, 0x27ae60, 0x3498db, 0x2980b9, 0x9b59b6, 0x8e44ad, 0x34495e, 0x2c3e50,
							 0xf1c40f, 0xf1c40f, 0xe67e22, 0xe74c3c, 0xecf0f1, 0x95a5a6, 0xf39c12, 0xd35400,
							 0xc0392b, 0xbdc3c7, 0x7f8c8d];
		G.vars.result = "NEW"; // what happened in the last game that was played?
		G.vars.spawnCoins = true; // did they win or is it their first game? then we should spawn new G.vars.coins!
		
		public function LightStage() // The initialization function that sets up the game
		{
			gotoAndStop(1); // go to the first frame 'Welcome to LightStage'
			stage.addEventListener(KeyboardEvent.KEY_DOWN, G.vars.keyboard.keyHandler); // start keyHandler listener
			G.vars._stage = stage;
			G.vars._root = this;
		}
		
		public function safeUpdateText(changeFrame: Boolean = true): void
		{
			if (currentFrame == 3)
			{
				updateText();
			}
			else if (changeFrame)
			{
				gotoAndStop(3);
				updateText();
			}
		}
		
		public function game(event:TimerEvent):void // start the game
		{
			G.vars.resetting = false;
			if (G.vars.result == "OVER") // if the user has won the game
			{
				fscommand("quit"); // exit the game
			}
			
			gotoAndStop(3); // Go to blank frame to start the game on
			
			G.vars.mirrors = new Vector.<mirror>(); // setup G.vars.mirrors vector
			G.vars.lines = new Vector.<line>(); // setup G.vars.lines vector
			G.vars.globes = new Vector.<globe>(); // setup G.vars.globes vector
			G.vars.bombs = new Vector.<bomb>(); // setup G.vars.bombs vector
			
			if (G.vars.spawnCoins) // make sure users don't get duplicate G.vars.coins
			{
				G.vars.coins = new Vector.<coin>(); // setup G.vars.coins vector
			}
			else
			{
				for (var fixCoin: int = 0; fixCoin < G.vars.coins.length; fixCoin++) // loop through all the G.vars.coins
				{
					if (G.vars.coins[fixCoin].full == false)
					{
						G.vars.coins[fixCoin].visible = true;
					}
				}
			}
			
			G.vars.levels.setupLevel();
			
			stage.addEventListener(Event.ENTER_FRAME, G.vars.backend.enterFrame); // Start enterFrame listener
		}

		
	}
	
}
