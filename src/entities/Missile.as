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
	
	import flash.display.MovieClip;
	
	public class Missile extends Entity
	{
		private var target:Entity;
		private var heading:b2Vec2;
		private static const SPEED:Number = 1.0/30.0;
		private static const RADIUS:Number = 2.0;
		private static const SPLODE_FORCE:Number = 2.5;
		private var age:int = 0;
		private var missile_sprite:MovieClip;
		
		public function Missile(game:Game, pos:b2Vec2, target:Entity)
		{
			super(game, pos);
			this.target = target;
			
			make_projectile(pos, 2 / Game.PX_PER_METER);
			
			missile_sprite = new MissileAsset();
			missile_sprite.scaleX = missile_sprite.scaleY = 0.25;
			missile_sprite.gotoAndStop(0);
			addChild(missile_sprite);
			missile_sprite.rotation = -90;
			
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
		
		private function update_velocity():void {
			if (target.alive) {
				heading = Util.normal(body.GetWorldCenter(), target.body.GetWorldCenter());
				heading.Multiply(SPEED);
			}
			
			var thrusters_enabled:Boolean = heading && age >= 15;
			
			if (thrusters_enabled) {
				if (age == 15) { 
					missile_sprite.gotoAndPlay(10);
				}
				body.ApplyForce(heading, body.GetWorldCenter());
			}
				
			// Rotate the sprite based on where it looks like it's going
			// If we took into account the thrust_up vector, it looks crazy
			var velocity:b2Vec2 = body.GetLinearVelocity();
			missile_sprite.rotation = Math.atan2(velocity.y, velocity.x) * 180.0 / Math.PI + 90;
			
			if (thrusters_enabled) {
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
					var dist:Number = Util.dist(center, entity_center);
					
					if (dist <= 1) {				
						var normal:b2Vec2 = Util.normal(center, entity_center);
						normal.Multiply(SPLODE_FORCE / dist);
						entity.body.ApplyImpulse(normal, entity_center);
						
						entity.damage(200 * (1 - dist));
					}
				}
			}
			game.mark_dead(this);
		}		
	}
}