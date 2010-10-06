//import medley.Pipe;
//using medley.util.HashUtil;
import medley.Medley;

class Test {

	static public function main():Void {
	/*
		var a = new Pipe();
		var b = new Pipe();
		
		a	.blow("[0=== ===1] [2-------- ------0.0]")
			.note("aa  b     a           b          ")
			.note("cc  c     c           c          ");
			
		b	.blow("[0=== ===1]")
			.note("p    p    p");

		a	.blow("[3=== ===2]")
			.note("c          ");
			
		a	.play();
		b	.play();

	*/
		var m = new Medley();
		m.duration = 0.5;
		m.events.start.bindVoid(function() trace("start"));
		m.events.play.bindVoid(function() trace("play"));
		m.events.tick.bindVoid(function() trace(Math.random()));
		m.events.stop.bindVoid(function() trace("stop"));
		m.events.end.bindVoid(function() trace("end"));
		m.play();
	}
}
