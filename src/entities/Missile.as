package entities
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	public class Missile extends Entity
	{
		private var target:Entity;
		private var heading:b2Vec2;
		private static const SPEED:Number = 1.0/30.0;
		private static const RADIUS:Number = 2.0;
		private static const SPLODE_FORCE:Number = 0.1; //5.0;
		private var age:int = 0;
		public function Missile(game:Game, pos:b2Vec2, target:Entity)
		{
			super(game, pos);
			draw(0x000000);
			this.target = target;
			
			make_projectile(pos, 2 / Game.PX_PER_METER);
			
			body.ApplyImpulse(new b2Vec2(0.0, -0.01), body.GetWorldCenter());
			
			update_velocity();
		}
		
		public override function step():void {
			age++;
			update_velocity();
			if (game.out_of_bounds(body.GetWorldCenter(), RADIUS / Game.PX_PER_METER)) {
				game.mark_dead(this);
			}
		}
		
		private function draw(color:uint):void {
			graphics.clear();
			graphics.beginFill(color, 1);
			graphics.drawCircle(0,0,2);
			graphics.endFill();
		}
		
		private function update_velocity():void {
			if (target.alive) {
				heading = Util.normal(body.GetWorldCenter(), target.body.GetWorldCenter());
				heading.Multiply(SPEED);
			}
			if (heading && age > 15) {
				body.ApplyForce(heading, body.GetWorldCenter());
				
				var thrust_up:b2Vec2 = Game.GRAVITY.Copy();
				thrust_up.Multiply(-1 * body.GetMass());
				body.ApplyForce(thrust_up, body.GetWorldCenter());
			}
		}
		
		public function splode():void {
			var center:b2Vec2 = body.GetWorldCenter();
			for each (var entity:Entity in game.active_entities) {
				if (entity.enemy) {
					var entity_center:b2Vec2 = entity.body.GetWorldCenter();
					var normal:b2Vec2 = Util.normal(center, entity_center);
					normal.Multiply(SPLODE_FORCE / Util.dist(center, entity_center));
					entity.body.ApplyImpulse(normal, entity_center);
				}
			}
			game.mark_dead(this);
		}		
	}
}