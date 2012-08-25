package entities
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	public class Tower extends Entity
	{
		public static const PROJ_CANNONBALL:int = 1;
		public static const PROJ_MISSILE:int = 2;
		
		
		private var shot_cooldown:int;
		private var shot_cycle:int;
		private var min_range:Number;
		private var max_range:Number;
		private var Projectile:Class;
		
		public var proj_type:int;
		
		public function Tower(game:Game, pos:b2Vec2, proj_type:int)
		{
			super(game, pos);
			draw(0x00FF00);
			this.proj_type = proj_type;
			
			if (proj_type == PROJ_CANNONBALL) {
				min_range = 7;
				max_range = 10;
				shot_cycle = 90;
				Projectile = CannonBall;
			} else if (proj_type == PROJ_MISSILE) {
				min_range = 3;
				max_range = 20;
				shot_cycle = 300;
				Projectile = Missile;
			}
			
			shot_cooldown = shot_cycle;
			
			make_static_rect(pos, Util.screenToPhysics(new b2Vec2(20,40)));
		}
		
		private function draw(color:uint):void {
			graphics.clear();
			graphics.beginFill(color, 1);
			graphics.drawRect(-1,-1,2,2);
			graphics.endFill();
		}
		
		public override function step():void {
			shot_cooldown--;
			if (shot_cooldown <= 0) {
				if (shoot()) {
					shot_cooldown = shot_cycle;
				}
			}
		}
		
		private function find_closest_enemy():Entity {
			var closest_dist2:Number = Math.pow(max_range, 2);
			var closest_entity:Entity = null;
			var min_dist2:Number = Math.pow(min_range, 2)
			
			var pos:b2Vec2 = body.GetWorldCenter();
			for each (var entity:Entity in game.active_entities) {
				if (!entity.enemy || !entity.alive) continue;
				var epos:b2Vec2 = entity.body.GetWorldCenter();
				var dist2:Number = Util.dist2(pos, epos);
				if (dist2 < closest_dist2 && dist2 >= min_dist2) {
					closest_dist2 = dist2;
					closest_entity = entity;
				}
			}
			
			return closest_entity;			
		}
		
		private function shoot():Boolean {
			var enemy:Entity = find_closest_enemy();
			if (!enemy) {
				return false;
			}
			
			var start_pos:b2Vec2 = body.GetWorldCenter().Copy();
			start_pos.Add(Util.screenToPhysics(new b2Vec2(-20, -20)));
			
			game.add(new Projectile(game, start_pos, enemy));
			
			return true;
		}
	}
}