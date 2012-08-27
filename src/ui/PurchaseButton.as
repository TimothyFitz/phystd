package ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class PurchaseButton extends Sprite
	{
		private static const BORDER:int = 5;
		
		private static const COLOR:int = 0xBBBBBB;
		private static const COLOR_HIGHLIGHT:int = 0xDDDDDD;
		private static const COLOR_DEPRESSED:int = 0x999999;
		
		public var item:String;
		public var cost:int;
		
		private var hover:Boolean = false;
		private var depressed:Boolean = false;
		
		private var label:TextField = new TextField();
		public function PurchaseButton(item:String, cost:int)
		{
			super();
			this.item = item;
			this.cost = cost;
			
			var format:TextFormat = new TextFormat();
			format.size = 14;
			format.font = "Arial";
			format.align = TextFormatAlign.CENTER;
			
			label.defaultTextFormat = format;
			label.text = item.toString() + "\n ($" + cost.toString() + ")";
			label.x = label.y = BORDER;
			label.width = 60;
			label.height = 36;
			label.selectable = false;
			addChild(label);
			
			draw();
			
			addEventListener(MouseEvent.MOUSE_OVER, function (_:*):void { hover = true;      draw(); });
			addEventListener(MouseEvent.MOUSE_OUT,  function (_:*):void { hover = false;     draw(); });
			addEventListener(MouseEvent.MOUSE_DOWN, function (_:*):void { depressed = true;  draw(); });
			addEventListener(MouseEvent.MOUSE_UP,   function (_:*):void { depressed = false; draw(); });
		}
						
		private function draw():void {
			var color:int = 0xBBBBBB;
			if (hover) {
				color = 0xCCCCCC;
			}
			if (depressed) {
				label.x = label.y = BORDER + 2;
				color = 0xAAAAAA;
			} else {
				label.x = label.y = BORDER;
			}
			
			graphics.clear();
			graphics.beginFill(color, 1);
			graphics.drawRoundRect(0, 0, label.width + BORDER*2, label.height + BORDER * 2, BORDER * 2, BORDER *2);
			graphics.endFill();
		}
	}
}