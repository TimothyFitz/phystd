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
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Entity extends Sprite
	{
		public var body:b2Body;
		public var enemy:Boolean = false;
		public var alive:Boolean = true;
		public var hp:int = 0;
		
		
		protected var game:Game;
		
		public function Entity(game:Game, pos:b2Vec2)
		{
			super();
			this.game = game;
		}
				
		public function step():void
		{
		}
		
		public function damage(amount:int):void
		{
			hp -= amount;
			if (hp <= 0) {
				die();
			}
		}
		
		protected function die():void
		{
			game.mark_dead(this);
		}
		
		protected function make_static_rect(pos:b2Vec2, size:b2Vec2):void
		{
			var body_def:b2BodyDef = new b2BodyDef();
			body_def.type = b2Body.b2_staticBody;
			body_def.position = pos;
			body_def.userData = this;
			
			var box:b2PolygonShape = new b2PolygonShape();
			
			box.SetAsBox(size.x / 2.0, size.y / 2.0);
			
			width = size.x * Game.PX_PER_METER;
			height = size.y * Game.PX_PER_METER;
			
			var fixture_def:b2FixtureDef = new b2FixtureDef();
			fixture_def.shape = box;
			fixture_def.userData = this;
			
			body = game.world.CreateBody(body_def);
			body.CreateFixture(fixture_def);
		}
		
		protected function make_projectile(pos:b2Vec2, radius:Number):void
		{
			var body_def:b2BodyDef = new b2BodyDef();
			body_def.type = b2Body.b2_dynamicBody;
			body_def.position = pos;
			body_def.fixedRotation = true;
			body_def.userData = this;
			body_def.linearDamping = 0.0;
			
			var circle:b2CircleShape = new b2CircleShape();
			circle.SetRadius(radius);
			
			var fixture_def:b2FixtureDef = new b2FixtureDef();
			fixture_def.shape = circle;
			fixture_def.density = 0.1;
			fixture_def.friction = 0.3;
			fixture_def.restitution = 0.2;
			fixture_def.userData = this;
			
			body = game.world.CreateBody(body_def);
			body.CreateFixture(fixture_def);
		}
	}
}