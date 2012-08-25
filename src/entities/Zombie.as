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
	
	public class Zombie extends Entity
	{
		private static const MAX_SPEED:Number = 5.0;
		private var foot:TouchSensor;
		private var step_count:int = 0;
		private var lurch_count:int = 0;

		public function Zombie(game:Game, pos:b2Vec2)
		{
			super(game, pos);
			draw(0xFF0000);
			enemy = true;
			
			var body_def:b2BodyDef = new b2BodyDef();
			body_def.type = b2Body.b2_dynamicBody;
			body_def.fixedRotation = true;
			body_def.position = pos;
			body_def.userData = this;

			var box:b2PolygonShape = new b2PolygonShape();
			var size:b2Vec2 = Util.screenToPhysics(new b2Vec2(10,10));
			box.SetAsBox(size.x / 2.0, size.y / 2.0);
			
			width = size.x * Game.PX_PER_METER;
			height = size.y * Game.PX_PER_METER;
			
			var fixture_def:b2FixtureDef = new b2FixtureDef();
			fixture_def.shape = box;
			fixture_def.density = 1.0;
			fixture_def.friction = 0.75;
			fixture_def.restitution = 0.2;
			fixture_def.userData = this;
			
			body = game.world.CreateBody(body_def);
			body.CreateFixture(fixture_def);
			
			var foot_shape:b2PolygonShape = new b2PolygonShape();
			foot_shape.SetAsOrientedBox(size.x / 2.0 / 2.0, 4 / 2.0 / Game.PX_PER_METER, new b2Vec2(0, size.y / 2.0), 0);
			foot = new TouchSensor(body, foot_shape);
			
			addEventListener(MouseEvent.CLICK, on_click);
		}
		
		private function draw(color:uint):void {
			graphics.clear();
			graphics.beginFill(color, 1);
			graphics.drawRect(-1,-1,2,2);
			graphics.endFill();
		}
		
		public override function step():void {
			step_count++;
			if (foot.touching) {
				draw(0x0000FF);
				if (body.GetLinearVelocity().x < MAX_SPEED) {
					if (step_count < 5) {
						body.ApplyForce(new b2Vec2(Util.float_randrange(1.0, 6.0), 0.0), body.GetWorldCenter());
					} else if (step_count > lurch_count) {
						lurch_count = Util.randrange(15, 40);
						step_count = 0;
					}
				}
			} else {
				draw(0xFF0000);
			}
		}
		
		public function on_click(event:MouseEvent):void {
			body.ApplyImpulse(new b2Vec2(-4.0, -2.0), body.GetWorldCenter());
		}
	}
}