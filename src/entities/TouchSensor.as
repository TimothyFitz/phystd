package entities
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	public class TouchSensor
	{
		public var touching:int = 0;
		
		public function TouchSensor(body:b2Body, shape:b2Shape)
		{
			var sensor_fixture:b2FixtureDef = new b2FixtureDef();
			sensor_fixture.shape = shape;
			sensor_fixture.isSensor = true;
			sensor_fixture.userData = this;
			body.CreateFixture(sensor_fixture);
		}
	}
}