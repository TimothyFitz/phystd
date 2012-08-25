package
{
	import Box2D.Common.Math.b2Vec2;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class Util
	{
		public function Util()
		{
		}
		
		public static function screenToPhysics(point:b2Vec2):b2Vec2 {
			point.Multiply(1.0 / Game.PX_PER_METER);
			return point;
		}
		
		public static function randrange(low:Number, high:Number):Number {
			return Math.floor(Math.random() * (high-low)) + low;
		}
		
		public static function float_randrange(low:Number, high:Number):Number {
			return Math.random() * (high-low) + low;	
		}
		
		public static function randchoice(array:Array):* {
			if (!array.length) {
				return null;
			}
			return array[Util.randrange(0, array.length)];
		}
		
		public static function remove(array:Array, target:*):Boolean {
			var index:int = array.indexOf(target);
			if (index >= 0) {
				array.splice(index, 1);
				return true;
			}
			return false;
		}
		
		public static function dist2(pt1:*, pt2:*):Number {
			var dx:Number = pt2.x - pt1.x;
			var dy:Number = pt2.y - pt1.y;
			return dx*dx + dy*dy;
		}
		
		public static function closest(target:DisplayObject, choices:Array):* {
			var closest:DisplayObject = null;
			var closest_dist:Number = +Infinity;
			for each (var choice:DisplayObject in choices) {
				var dist:Number = dist2(target, choice);
				if (dist < closest_dist) {
					closest = choice;
					closest_dist = dist;
				}
			}
			return closest;
		}
		
		public static function quickAdd(container:DisplayObjectContainer, object:*, x:int = 0, y:int = 0):* {
			object.x = x;
			object.y = y;
			container.addChild(object);
			return object;
		}
		
		public static function array2d(d1:int = 1, d2:int = 1, default_:* = null):Array {
			var result:Array = [];
			for (var i:int = 0; i < d1; i++) {
				var row:Array = [];
				for (var j:int = 0; j < d2; j++) {
					row.push(default_);
				}
				result.push(row);
			}
			return result;
		}
	}
}
