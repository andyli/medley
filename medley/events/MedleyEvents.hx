package medley.events;

import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

import medley.Medley;

class MedleyEvents {
	public function new(m:Medley):Void {
		play = new DirectSignaler<Void>(m);
		stop = new DirectSignaler<Void>(m);
		reachStart = new DirectSignaler<Void>(m);
		reachEnd = new DirectSignaler<Void>(m);
		seek = new DirectSignaler<Void>(m);
		reverse = new DirectSignaler<Void>(m);
		tick = new DirectSignaler<Float>(m);
	}

	public var play:Signaler<Void>;
	public var stop:Signaler<Void>;
	public var reachStart:Signaler<Void>;
	public var reachEnd:Signaler<Void>;
	public var seek:Signaler<Void>;
	public var reverse:Signaler<Void>;
	public var tick:Signaler<Float>;
}
