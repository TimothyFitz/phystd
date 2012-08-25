package entities
{
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
		protected var game:Game;
		
		public function Entity(game:Game, pos:b2Vec2)
		{
			super();
			this.game = game;
			game.addChild(this);
		}
				
		public function step():void
		{
		}
	}
}