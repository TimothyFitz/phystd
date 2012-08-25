package entities
{
	import Box2D.Common.Math.b2Vec2;
	
	public class CannonBall extends Entity
	{		
		public static var speed:Number = 10.0;
		public static var max_range:Number = Math.pow(speed, 2) / Game.GRAVITY_SPEED;
		
		public function CannonBall(game:Game, pos:b2Vec2, target:Entity)
		{
			super(game, pos);
			draw(0x000000);
			make_projectile(pos, 4/Game.PX_PER_METER);
			
			var target_pos:b2Vec2 = target.body.GetWorldCenter();
			// Thanks, http://en.wikipedia.org/wiki/Trajectory_of_a_projectile !
			
			var distance:Number = pos.x - target_pos.x;
			var height:Number = pos.y - target_pos.y;
			
			var sqrt_term:Number = Math.pow(speed, 4) - Game.GRAVITY_SPEED * (
				Game.GRAVITY_SPEED * Math.pow(distance, 2) +
				2 * height * Math.pow(speed, 2));
			
			if (sqrt_term <= 0) {
				// Target too far away to be hit
				trace("too far");
				return;
			}
			
			
			sqrt_term = Math.sqrt(sqrt_term);
				
			// High angle (>45deg)
			var theta1:Number = Math.atan((Math.pow(speed, 2) + sqrt_term) / (Game.GRAVITY_SPEED * distance));
			// low angle (<45deg)
			var theta2:Number = Math.atan((Math.pow(speed, 2) - sqrt_term) / (Game.GRAVITY_SPEED * distance));
			
			var impulse1:b2Vec2 = new b2Vec2(-Math.cos(theta1), -Math.sin(theta1));
			var impulse2:b2Vec2 = new b2Vec2(-Math.cos(theta2), -Math.sin(theta2));
			
			var impulse:b2Vec2 = impulse1;
			
			impulse.Multiply(speed);
			impulse.Multiply(body.GetMass());
			
			body.ApplyImpulse(impulse, body.GetWorldCenter());
		}
		
		private function draw(color:uint):void {
			graphics.clear();
			graphics.beginFill(color, 1);
			graphics.drawCircle(0,0,4);
			graphics.endFill();
		}
		
		public function thud(other:*):void {
			game.mark_dead(this);
			
			if (other == "WALL" || !(other is Entity)) {
				return;
			}
			
			var entity:Entity = other;
			if (entity.enemy) {
				entity.damage(50);
			}
		}
			
	}
}