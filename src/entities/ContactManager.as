package entities
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2ContactManager;
	import Box2D.Dynamics.b2Fixture;
	
	import entities.Entity;
	
	import flash.display.Sprite;
	
	public class ContactManager extends b2ContactListener
	{
		private var game:Game;
		public function ContactManager(game:Game)
		{
			super();
			this.game = game;
		}
		
		private var to_die:Array = [];
		
		private function one_of(contact:b2Contact, TargetClass:Class):ContactMatch {
			var uda:* = contact.GetFixtureA().GetUserData();
			var udb:* = contact.GetFixtureB().GetUserData();
			
			if (uda is TargetClass || udb is TargetClass) {
				if (uda is TargetClass && udb is TargetClass) {
					return null;
				} else if (uda is TargetClass) {
					return new ContactMatch(uda, udb);
				} else {
					return new ContactMatch(udb, uda);
				}
			}
			return null;
		}
		
		public override function BeginContact(contact:b2Contact):void
		{
			var match:ContactMatch = one_of(contact, TouchSensor);
			if (match) {
				(match.target as TouchSensor).touching++;
			}
			
			match = one_of(contact, Missile);
			if (match) {
				if (match.other is Entity) {
					var other:Entity = match.other;
					if (other.enemy) {
						(match.target as Missile).splode();
					}
				} else if (match.other == "WALL") {
					(match.target as Missile).splode();
				}
			}
			
			match = one_of(contact, CannonBall);
			if (match) {
				if (match.other == "WALL" || match.other is Entity) {
					(match.target as CannonBall).thud(match.other);
				}
			}
		}
		
		public override function EndContact(contact:b2Contact):void
		{
			var match:ContactMatch = one_of(contact, TouchSensor);
			if (match) {
				(match.target as TouchSensor).touching--;
			}
		}
		
		public override function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
		{
			var uda:* = contact.GetFixtureA().GetUserData();
			var udb:* = contact.GetFixtureB().GetUserData();

			if (uda is Entity && udb is Entity) {
				var e1:Entity = uda;
				var e2:Entity = udb;
				
				if (e1.enemy && e2.enemy) {
					if (impulse.normalImpulses[0] > 1) {
						var dmg:Number = impulse.normalImpulses[0] * 10;
						e1.damage(dmg);
						e2.damage(dmg);
					}
				}
			}
			
		}
	}
}