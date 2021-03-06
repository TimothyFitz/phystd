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
	
	import assets.Zed;
	
	import entities.ContactManager;
	import entities.Crate;
	import entities.Entity;
	import entities.Missile;
	import entities.Tower;
	import entities.Zombie;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ui.Battlefield;
	
	import ui.GameDisplay;
	
	[SWF(width="800", height="600", backgroundColor="#FFFFFF")]
	public class Game extends Sprite
	{
		public static const PX_PER_METER:Number = 30.0;
		public static const WORLD_WIDTH:Number = 800.0;
		public static const WORLD_HEIGHT:Number = 500.0;
		public static const WALL_SIZE:Number = 10.0;
		public static const GRAVITY_SPEED:Number = 10.0;
		public static const GRAVITY:b2Vec2 = new b2Vec2(0.0, GRAVITY_SPEED);
		
		public var world:b2World;
		public var floor:b2Body;
		public var active_entities:Array = [];
		public var step_count:int = 0;
		
		public var cash:int = 100;
		
		public var battlefield:Battlefield = new Battlefield();
		
		private var contact_manager:ContactManager;
		private var dead_entities:Array = [];
		private var display:GameDisplay;
		
		public function Game()
		{
			world = new b2World(GRAVITY, true);
			
			contact_manager = new ContactManager(this);
			world.SetContactListener(contact_manager);
			
			/*
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(battlefield);
			debugDraw.SetDrawScale(PX_PER_METER);
			debugDraw.SetFillAlpha(0.3);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);			
			world.SetDebugDraw(debugDraw);
			*/
			
			create_walls();
						
			for (var i:int = 0; i < 10; i++) {
				add_zed();
			}
			
			add(new Tower(this, Util.screenToPhysics(new b2Vec2(WORLD_WIDTH - 10.0, WORLD_HEIGHT - 30)), Tower.PROJ_MISSILE));
			add(new Tower(this, Util.screenToPhysics(new b2Vec2(WORLD_WIDTH - 40.0, WORLD_HEIGHT - 30)), Tower.PROJ_CANNONBALL));
			
			//add(new Crate(this, Util.screenToPhysics(new b2Vec2(WORLD_WIDTH - 100.0, WORLD_HEIGHT - 20))));
			
			display = new GameDisplay(this, battlefield);
			addChild(display);
			
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		public function add_zed():void {
			add(new Zombie(this, Util.screenToPhysics(new b2Vec2(Math.random()*300, 450 - Math.random()*50))));
		}
		
		public function add(entity:Entity):void {
			active_entities.push(entity);
			update_body(entity.body);
			battlefield.addChild(entity);
		}
		
		public function update_body(body:b2Body):void {
			if (body.GetUserData() is Sprite) {
				var sprite:Sprite = body.GetUserData();
				var pos:b2Vec2 = body.GetPosition();
				sprite.x = pos.x * Game.PX_PER_METER;
				sprite.y = pos.y * Game.PX_PER_METER;
				sprite.rotation = body.GetAngle() * 180.0/Math.PI;
			}
		}
		
		private function update(event:Event):void {
			step_count++;
			world.Step(1.0/30.0, 10, 10);
			world.ClearForces();
			world.DrawDebugData();
			
			for (var body:b2Body = world.GetBodyList(); body; body = body.GetNext()) {
				update_body(body);
			}
			
			for each (var entity:Entity in active_entities) {
				entity.step();
			}
			
			if (dead_entities.length) {
				for each (var dead:Entity in dead_entities) {
					world.DestroyBody(dead.body);
					battlefield.removeChild(dead);
					Util.remove(active_entities, dead);
				}
				dead_entities = [];
			}
			
			if (step_count % 45 == 0) {
				add_zed();
			}
			
			display.update();
		}
		
		public function out_of_bounds(pos:b2Vec2, radius:Number):Boolean {
			return pos.x - radius < WALL_SIZE / Game.PX_PER_METER || 
				pos.x + radius > (WORLD_WIDTH - WALL_SIZE) / Game.PX_PER_METER ||
				pos.y - radius < WALL_SIZE / Game.PX_PER_METER ||
				pos.y + radius > (WORLD_HEIGHT - WALL_SIZE) / Game.PX_PER_METER;
		}
		
		private function create_walls():void {
			create_wall(0, WORLD_HEIGHT - WALL_SIZE, WORLD_WIDTH, WALL_SIZE);
			create_wall(0, 0, WORLD_WIDTH, WALL_SIZE);
			create_wall(0, WALL_SIZE, WALL_SIZE, WORLD_HEIGHT - WALL_SIZE * 2);
			create_wall(WORLD_WIDTH - WALL_SIZE, WALL_SIZE, WALL_SIZE, WORLD_HEIGHT - WALL_SIZE * 2);
		}
		
		private function create_wall(x:Number, y:Number, width:Number, height:Number):b2Body {
			var body_def:b2BodyDef = new b2BodyDef();
			body_def.position.x = (x + width/2) / Game.PX_PER_METER;
			body_def.position.y = (y + height/2) / Game.PX_PER_METER;
			body_def.userData = "BODY_DEF_WALL";
			
			var box:b2PolygonShape = new b2PolygonShape();
			box.SetAsBox(width / 2.0 / Game.PX_PER_METER, height / 2.0 / Game.PX_PER_METER);
			
			var fixture_def:b2FixtureDef = new b2FixtureDef();
			fixture_def.shape = box;
			fixture_def.density = 1;
			fixture_def.friction = 1;
			fixture_def.userData = "WALL";

			var body:b2Body = world.CreateBody(body_def);
			body.CreateFixture(fixture_def);
			return body;
		}
		
		public function mark_dead(entity:Entity):void {
			if (dead_entities.indexOf(entity) == -1) {
				dead_entities.push(entity);
			}
			entity.alive = false;
		}
	}
}