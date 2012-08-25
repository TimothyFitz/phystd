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
		private var velocity:b2Vec2;
		private static const SPEED:Number = 5.0;
		private static const RADIUS:Number = 2.0;
		public function Missile(game:Game, pos:b2Vec2, target:Entity)
		{
			super(game, pos);
			draw(0x000000);
			this.target = target;
			
			var body_def:b2BodyDef = new b2BodyDef();
			body_def.type = b2Body.b2_kinematicBody;
			body_def.position = pos;
			body_def.fixedRotation = true;
			body_def.userData = this;
			
			var circle:b2CircleShape = new b2CircleShape();
			circle.SetRadius(RADIUS / Game.PX_PER_METER);
						
			var fixture_def:b2FixtureDef = new b2FixtureDef();
			fixture_def.shape = circle;
			fixture_def.density = 1.0;
			fixture_def.friction = 0.3;
			fixture_def.restitution = 0.2;
			fixture_def.userData = this;
			
			body = game.world.CreateBody(body_def);
			body.CreateFixture(fixture_def);
			update_velocity();
		}
		
		public override function step():void {
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
				var destination:b2Vec2 = target.body.GetWorldCenter();
				
				var velocity:b2Vec2 = destination.Copy();
				velocity.Subtract(body.GetWorldCenter());
				velocity.Normalize();
				velocity.Multiply(SPEED);
			}
			if (velocity) {
				body.SetLinearVelocity(velocity);
			}
		}
	}
}