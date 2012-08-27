package ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
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
			
			var b1:PurchaseButton = new PurchaseButton("testing", 50);
			addChild(b1);
			b1.x = 200;
			b1.y = 2;
			
			b1.addEventListener(MouseEvent.CLICK, function (_:*):void {
				game.cash -= 50;
			});
			
			var format:TextFormat = new TextFormat();
			format.size = 20;
			format.font = "Arial";
			
			cash.defaultTextFormat = format;
			cash.x = 20;
			cash.y = 10;
			cash.width = 180;
			cash.height = 30;
			cash.selectable = false;
			
			addChild(cash);
			update();
		}
		
		public function update():void
		{
			cash.text = "Cash: $" + game.cash.toString();
		}
	}
}