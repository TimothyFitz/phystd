package
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import entities.ContactManager;
	import entities.Entity;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="800", height="500", backgroundColor="#FFFFFF")]
	public class Game extends Sprite
	{
		public static const PX_PER_METER:Number = 30.0;
		public static const WORLD_WIDTH:Number = 800.0;
		public static const WORLD_HEIGHT:Number = 500.0;
		
		public var world:b2World;
		public var floor:b2Body;
		
		private var zombies:Array = [];
		
		public function Game()
		{
			var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
			world = new b2World(gravity, true);
			world.SetContactListener(new ContactManager());
			
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(this);
			debugDraw.SetDrawScale(PX_PER_METER);
			debugDraw.SetFillAlpha(0.3);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);			
			world.SetDebugDraw(debugDraw);
			
			create_walls();
						
			for (var i:int = 0; i < 10; i++) {
				zombies.push(new Entity(this, new b2Vec2(Math.random()*100, Math.random()*500)));
			}	
			
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		private function update(event:Event):void {
			world.Step(1.0/30.0, 10, 10);
			world.ClearForces();
			world.DrawDebugData();
			
			for (var body:b2Body = world.GetBodyList(); body; body = body.GetNext()) {
				if (body.GetUserData() is Sprite) {
					var sprite:Sprite = body.GetUserData();
					var pos:b2Vec2 = body.GetPosition();
					sprite.x = pos.x * Game.PX_PER_METER;
					sprite.y = pos.y * Game.PX_PER_METER;
					sprite.rotation = body.GetAngle() * 180.0/Math.PI;
				}
			}
			
			for each (var entity:Entity in zombies) {
				entity.step();
			}
		}
		
		private function create_walls():void {
			var wall_size:int = 10;
			create_wall(0, WORLD_HEIGHT - wall_size, WORLD_WIDTH, wall_size);
			create_wall(0, 0, WORLD_WIDTH, wall_size);
			create_wall(0, wall_size, wall_size, WORLD_HEIGHT - wall_size * 2);
			create_wall(WORLD_WIDTH - wall_size, wall_size, wall_size, WORLD_HEIGHT - wall_size * 2);
		}
		
		
		private function create_wall(x:Number, y:Number, width:Number, height:Number):b2Body {
			var body_def:b2BodyDef = new b2BodyDef();
			body_def.position.x = (x + width/2) / Game.PX_PER_METER;
			body_def.position.y = (y + height/2) / Game.PX_PER_METER;
			
			var box:b2PolygonShape = new b2PolygonShape();
			box.SetAsBox(width / 2.0 / Game.PX_PER_METER, height / 2.0 / Game.PX_PER_METER);
			
			var fixture_def:b2FixtureDef = new b2FixtureDef();
			fixture_def.shape = box;
			fixture_def.density = 1;
			fixture_def.friction = 1;

			var body:b2Body = world.CreateBody(body_def);
			body.CreateFixture(fixture_def);
			return body;
		}
	}
}