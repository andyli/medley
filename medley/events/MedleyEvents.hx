package medley.events;

import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

import medley.Medley;

class MedleyEvents {
	public function new(m:Medley<Dynamic>):Void {
		play = new DirectSignaler<Void>(m);
		stop = new DirectSignaler<Void>(m);
		reachStart = new DirectSignaler<Float>(m);
		reachEnd = new DirectSignaler<Float>(m);
		seek = new DirectSignaler<Void>(m);
		reverse = new DirectSignaler<Void>(m);
		tick = new DirectSignaler<Float>(m);
	}

	public var play:Signaler<Void>;
	public var stop:Signaler<Void>;
	public var reachStart:Signaler<Float>;
	public var reachEnd:Signaler<Float>;
	public var seek:Signaler<Void>;
	public var reverse:Signaler<Void>;
	public var tick:Signaler<Float>;

	public function destroy():Void {
		play = null;
		stop = null;
		reachStart = null;
		reachEnd = null;
		seek = null;
		reverse = null;
		tick = null;
	}
}
