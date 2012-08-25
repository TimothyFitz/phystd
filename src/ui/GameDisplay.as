package ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class GameDisplay extends Sprite
	{
		private var game:Game;
		private var cash:TextField = new TextField();
		public function GameDisplay(game:Game, battlefield:Battlefield)
		{
			super();
			this.game = game;
			
			graphics.beginFill(0xDDDDFF, 1);
			graphics.drawRoundRectComplex(0, 0,   800, 50, 10, 10, 0,0);
			graphics.drawRoundRectComplex(0, 550, 800, 50, 0, 0, 10, 10);
			graphics.endFill();
			
			addChild(battlefield);
			battlefield.y = 50;
			
			
			
			addChild(cash);
			update();
		}
		
		public function update():void
		{
			cash.text = "Cash: $" + game.cash.toString();
		}
	}
}