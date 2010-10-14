package;

import flash.Lib;
import flash.display.Sprite;

import medley.Medley;
import medley.easing.Linear;
import medley.note.EaseNote;

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
			
			var m = new Medley(new EaseNote(0,1,3,Linear.easeNone));
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
		var m =
		
			Medley
				.instrument(i1, i2)
				.____________________________________________________________________________
				.line(i1,	"[0=== ===1] [2-------- ------0.0]",
							"aa  b     a           b          ",
							"cc  c     c           c          ")
				.line(i2,	"[0=== ===1] ---------- ----------",
							"p    p    p                      ")
				.____________________________________________________________________________
				.line(i1,	"[3=== ===2] ---------- ----------",
							"c                                ")
				.____________________________________________________________________________

				.finish(); //return a Medley instance.
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
