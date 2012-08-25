package entity
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	
	public class Entity extends Sprite
	{
		public var body:b2Body;
		
		public function Entity(game:Game, pos:b2Vec2)
		{
			super();
			graphics.beginFill(0xFF0000, 0.1);
			//graphics.drawRect(-1,-1,2,2);
			graphics.endFill();
			
			var body_def:b2BodyDef = new b2BodyDef();
			var phys_pos:b2Vec2 = pos.Copy();
			phys_pos.Multiply(1.0/Game.PX_PER_METER);
			body_def.type = b2Body.b2_dynamicBody;
			body_def.position = phys_pos;
			body_def.userData = this;
			
			var box:b2PolygonShape = new b2PolygonShape();
			var size:b2Vec2 = new b2Vec2(20,20);
			box.SetAsBox(size.x / 2.0 / Game.PX_PER_METER, size.y / 2.0 / Game.PX_PER_METER);
			
			width = size.x;
			height = size.y;
			
			var fixture_def:b2FixtureDef = new b2FixtureDef();
			fixture_def.shape = box;
			fixture_def.density = 1.0;
			fixture_def.friction = 0.5;
			fixture_def.restitution = 0.2;
			
			body = game.world.CreateBody(body_def);
			body.CreateFixture(fixture_def);
			
			game.addChild(this);
		}
	}
}