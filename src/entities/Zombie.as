package entities
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import assets.Zed;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Zombie extends Entity
	{
		private static const MAX_SPEED:Number = 5.0;
		private var foot:TouchSensor;
		private var step_count:int = 0;
		private var lurch_count:int = 0;
		
		private var zed:MovieClip;
		
		private static const HAPPY_FACE:int = 1;
		private static const WORRIED_FACE:int = 10;
		private static const DEAD_FACE:int = 20;
		
		private static const small_jump:b2Vec2 = new b2Vec2(0.25, -0.3);
		private static const big_jump:b2Vec2 = new b2Vec2(0.1, -0.5);
		
		private var unhappy_count:int = 0;
		private var death_count:int = 60;

		public function Zombie(game:Game, pos:b2Vec2)	
		{
			super(game, pos);
			zed = new Zed();
			zed.gotoAndStop(WORRIED_FACE);
			addChild(zed);

			enemy = true;
			hp = 100;
			
			var body_def:b2BodyDef = new b2BodyDef();
			body_def.type = b2Body.b2_dynamicBody;
			body_def.fixedRotation = true;
			body_def.position = pos;
			body_def.userData = this;

			var box:b2PolygonShape = new b2PolygonShape();
			var size:b2Vec2 = Util.screenToPhysics(new b2Vec2(20,20));
			box.SetAsBox(size.x / 2.0, size.y / 2.0);
			
			width = size.x * Game.PX_PER_METER;
			height = size.y * Game.PX_PER_METER;
			
			var fixture_def:b2FixtureDef = new b2FixtureDef();
			fixture_def.shape = box;
			fixture_def.density = 0.25;
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
				
		public override function step():void {
			step_count++;
			
			if (foot.touching && alive) {
				if (body.GetLinearVelocity().Length() < MAX_SPEED) {
					if (step_count > lurch_count) {
						var jump:b2Vec2 = (Math.random() < 0.05) ? big_jump : small_jump;
						body.ApplyImpulse(
							jump, 
							body.GetWorldCenter());
						lurch_count = Util.randrange(15, 40);
						step_count = 0;
					}
				}
			}
			
			var face:int = HAPPY_FACE;
			
			if (!foot.touching && body.GetLinearVelocity().Length() > 5) {
				face = WORRIED_FACE;
			}
			
			if (unhappy_count > 0) {
				unhappy_count--;
				face = WORRIED_FACE;
			}
			
			if (!alive) {
				death_count--;
				face = DEAD_FACE;
				if (death_count < 0) {
					game.mark_dead(this);
				} else if (death_count < 15) {
					zed.alpha = (death_count % 5 < 3) ? 1 : 0
				}
			}
			
			zed.gotoAndStop(face);
		}
		
		public function on_click(event:MouseEvent):void {
			body.ApplyImpulse(new b2Vec2(-4.0, -2.0), body.GetWorldCenter());
		}
		
		public override function damage(amount:int):void {
			super.damage(amount);
			unhappy_count = 10;
		}
		
		protected override function die():void {
			alive = false;
		}
			
	}
}