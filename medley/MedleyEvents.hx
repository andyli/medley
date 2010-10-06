package medley;

import hsl.haxe.Signaler;
import hsl.haxe.DirectSignaler;

class MedleyEvents {
	public function new(m:Medley):Void {
		play = new DirectSignaler<Void>(m);
		stop = new DirectSignaler<Void>(m);
		start = new DirectSignaler<Void>(m);
		end = new DirectSignaler<Void>(m);
		reset = new DirectSignaler<Void>(m);
		reverse = new DirectSignaler<Void>(m);
		tick = new DirectSignaler<Void>(m);
	}

	public var play:Signaler<Void>;
	public var stop:Signaler<Void>;
	public var start:Signaler<Void>;
	public var end:Signaler<Void>;
	public var reset:Signaler<Void>;
	public var reverse:Signaler<Void>;
	public var tick:Signaler<Void>;
}
