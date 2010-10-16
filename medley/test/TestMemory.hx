package medley.test;

import flash.display.Sprite;
import flash.geom.Point;
import flash.system.System;
import flash.Lib;
import hsl.haxe.Signal;
import utest.Assert;
import medley.Medley;
import medley.note.EaseNote;
import medley.easing.Linear;

using Lambda;

class TestMemory {
	public function new(){}

	public function testSimpleMedley():Void {
		var oUsage = Math.NaN;
		var assert = Assert.createAsync(function(){
			System.gc();
			Assert.floatEquals(oUsage, System.totalMemory, oUsage * 0.2);
		}, 6000);
		
		runSimpleMedley(5000);
		haxe.Timer.delay(function(){
			System.gc();
			oUsage = System.totalMemory;
			runSimpleMedley(5000);
			haxe.Timer.delay(assert, 1200);
		}, 1200);
	}

	static function runSimpleMedley(num:Int):Void {
		var init = new Point(Lib.current.stage.stageWidth*0.5, Lib.current.stage.stageHeight*0.5);
		for (i in 0...num) {
			var sp = new Sprite();
			sp.graphics.beginFill(Std.int(Math.random()*0xFFFFFF));
			sp.graphics.drawCircle(0,0,4);
			Lib.current.addChild(sp);
			
			var target = new Point(Math.random()*Lib.current.stage.stageWidth, Math.random()*Lib.current.stage.stageHeight);
			
			var m = new Medley(new EaseNote(1, 0, 1, Linear.easeNone));
			
			var onTick = function(val:Float) {
				var r = Point.interpolate(init,target,val);
				sp.x = r.x;
				sp.y = r.y;
			};
			
			var onEnd = function() {
				sp.parent.removeChild(sp);
				//m.destroy();
			};
			
			m.events.tick.bind(onTick);
			m.events.reachEnd.bindVoid(onEnd);
			m.play();
		}
	}
}
