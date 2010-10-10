package;

import flash.Lib;
import flash.display.Sprite;

import medley.Medley;
import medley.MedleySingle;
import medley.note.LinearNote;

import medley.util.PropSetter;

class Test extends Sprite{
	public function new():Void {
		super();

		for (i in 0...1){
			var sp = new Sprite();
			sp.graphics.beginFill(cast Math.random() * 0xFFFFFF);
			sp.graphics.drawCircle(0,0,10);
			sp.x = sp.y = 100;
			addChild(sp);

			var m = new MedleySingle<LinearNote>(new LinearNote(0,1,3));

			
			//var m = new Medley(medley.easing.Bounce.easeOut,0,1,3);
			m.events.tick.bind(function(val:Float) {
				sp.x = 100 + val * 100;
			});
			
			/*
			m.events.reachStart.bindVoid(function() {
				trace("reachStart");
				m.timeScale = 1;
				m.play();
			});
			m.events.reachEnd.bindVoid(function() {
				trace("reachEnd");
				m.timeScale = -1;
				m.play();
			});*/
			m.events.stop.bindVoid(function() {
				//trace("stop");
				//m.timeScale *= -1;
				m.seek(2).play();
			});
			m.play();
		}
	}

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
		#if (cpp || neko)
			Lib.create(function(){
				Lib.current.addChild(new Test());
			}, 400,300,24,0xFFFFFF,Lib.RESIZABLE);
		#else
			Lib.current.addChild(new Test());
		#end
	}
}
