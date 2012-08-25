package entities
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2ContactManager;
	import Box2D.Dynamics.b2Fixture;
	
	import entities.Entity;
	
	import flash.display.Sprite;
	
	public class ContactManager extends b2ContactListener
	{
		public function ContactManager()
		{
			super();
		}
		
		private function one_of(contact:b2Contact, TargetClass:Class):* {
			var uda:* = contact.GetFixtureA().GetUserData();
			var udb:* = contact.GetFixtureB().GetUserData();
			
			if (uda is TargetClass || udb is TargetClass) {
				if (uda is TargetClass && udb is TargetClass) {
					return null;
				} else if (uda is TargetClass) {
					return uda;
				} else {
					return udb;
				}
			}
			return null;
		}
		
		public override function BeginContact(contact:b2Contact):void
		{
			var ts:TouchSensor = one_of(contact, TouchSensor);
			if (ts) {
				ts.touching++;
			}
		}
		
		public override function EndContact(contact:b2Contact):void
		{
			var ts:TouchSensor = one_of(contact, TouchSensor);
			if (ts) {
				ts.touching--;
			}
		}		
	}
}