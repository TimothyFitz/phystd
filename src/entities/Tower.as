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
		private static const SHOT_COOLDOWN:int = 15;
		private var shot_countdown:int = SHOT_COOLDOWN;
		
		public function Tower(game:Game, pos:b2Vec2)
		{
			super(game, pos);
			draw(0x00FF00);
			
			var body_def:b2BodyDef = new b2BodyDef();
			body_def.type = b2Body.b2_staticBody;
			body_def.position = pos;
			body_def.userData = this;
			
			var box:b2PolygonShape = new b2PolygonShape();
			var size:b2Vec2 = Util.screenToPhysics(new b2Vec2(20,40));
			box.SetAsBox(size.x / 2.0, size.y / 2.0);
			
			width = size.x * Game.PX_PER_METER;
			height = size.y * Game.PX_PER_METER;
			
			var fixture_def:b2FixtureDef = new b2FixtureDef();
			fixture_def.shape = box;
			fixture_def.userData = this;
			
			body = game.world.CreateBody(body_def);
			body.CreateFixture(fixture_def);
		}
		
		private function draw(color:uint):void {
			graphics.clear();
			graphics.beginFill(color, 1);
			graphics.drawRect(-1,-1,2,2);
			graphics.endFill();
		}
		
		public override function step():void {
			shot_countdown--;
			if (shot_countdown <= 0) {
				if (shoot()) {
					shot_countdown = SHOT_COOLDOWN;
				}
			}
		}
		
		private function find_closest_enemy():Entity {
			var closest_dist2:Number = +Infinity;
			var closest_entity:Entity = null;
			
			var pos:b2Vec2 = body.GetWorldCenter();
			for each (var entity:Entity in game.active_entities) {
				if (!entity.enemy) continue;
				var epos:b2Vec2 = entity.body.GetWorldCenter();
				var dist2:Number = Util.dist2(pos, epos);
				if (dist2 < closest_dist2) {
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
			
			game.add(new Missile(game, start_pos, enemy));
			
			return true;
		}
	}
}