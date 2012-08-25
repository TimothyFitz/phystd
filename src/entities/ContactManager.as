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
				if (match.other == "WALL") {
					var cb:CannonBall = match.target;
					trace("730 - cb.x", 730 - cb.body.GetWorldCenter().x * Game.PX_PER_METER);
					game.mark_dead(cb);
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
	}
}