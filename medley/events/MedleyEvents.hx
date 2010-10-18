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

	public var play(default,null):Signaler<Void>;
	public var stop(default,null):Signaler<Void>;
	public var reachStart(default,null):Signaler<Float>;
	public var reachEnd(default,null):Signaler<Float>;
	public var seek(default,null):Signaler<Void>;
	public var reverse(default,null):Signaler<Void>;
	public var tick(default,null):Signaler<Float>;

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
