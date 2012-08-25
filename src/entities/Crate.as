package entities
{
	import Box2D.Common.Math.b2Vec2;
	
	public class Crate extends Entity
	{
		public function Crate(game:Game, pos:b2Vec2)
		{
			super(game, pos);
			draw(0xA62A00);
			
			make_static_rect(pos, Util.screenToPhysics(new b2Vec2(20,20)));
		}
		
		private function draw(color:uint):void {
			graphics.clear();
			graphics.beginFill(color, 1);
			graphics.drawRect(-1,-1,2,2);
			graphics.endFill();
		}
	}
}