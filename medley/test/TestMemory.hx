package medley.test;

import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.TypedDictionary;
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
		var trash = new Trash();

		var numOfSp = 5000;
		var init = new Point(Lib.current.stage.stageWidth*0.5, Lib.current.stage.stageHeight*0.5);
		for (i in 0...numOfSp) {
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
				trash.throws(sp);
				trash.throws(m);
				trash.throws(m.events);
				//m.destroy();
				if (--numOfSp == 0) { //if all Medley are ended.
					Trash.collectAll();
				}
			};
			
			m.events.tick.bind(onTick);
			m.events.reachEnd.bindVoid(onEnd);
			m.play();
		}
		
		var assert = Assert.createAsync(function(){
			Assert.isTrue(trash.isEmpty());
			Assert.equals(0,trash.garbages().count());
		}, 2000);

		haxe.Timer.delay(assert,1100);
	}
}

//http://gist.github.com/632717
#if flash9
import flash.utils.TypedDictionary;
import flash.system.System;
import flash.system.Capabilities;
#else
#error
#end

using Lambda;

/*
	A Trash that you can throw unused objects inside and see if they are GC'ed later.
	http://blog.onthewings.net/2010/10/18/how-to-know-objects-are-really-gced-in-flash-as3/
*/
class Trash {
	public function new():Void {
		dict = new TypedDictionary<Dynamic,String>(true);
	}

	/*
		Throws a garbage, an unused object that should be GC'ed soon, to the Trash.
		An optional identifier that let you know what is in the Trash by garbages().
	*/
	public function throws(garbage:Dynamic, ?identifier:String):Void {
		dict.set(garbage, identifier == null ? Std.string(garbage) : identifier);
	}

	/*
		Return an Array of identifier of the garbages inside.
		It does not let you pick out the garbages, since they are dirty, and you shouldn't hold reference of them again.
	*/
	public function garbages():Array<String> {
		return dict.array();
	}

	/*
		Tell if the Trash is empty.
	*/
	public function isEmpty():Bool {
		return dict.empty();
	}

	/*
		Trigger GC. Throws an error if it is not running in a debugger.
	*/
	static public function collectAll():Void {
		if (!Capabilities.isDebugger) throw "System.gc() only works on flash debugger.";
		System.gc();
	}

	var dict:TypedDictionary<Dynamic,String>;
}
