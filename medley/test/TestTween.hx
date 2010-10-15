package medley.test;

import medley.Medley;
import medley.note.EaseNote;
import medley.easing.Linear;
import utest.Assert;
import flash.Lib;
import flash.display.Sprite;
import haxe.Timer;

using Lambda;

class TestTween {
	public function new():Void {}

	public function testSingleMedley():Void {
		var cir = new Sprite();
		cir.graphics.beginFill(0);
		cir.graphics.drawCircle(0,0,10);
		cir.x = cir.y = 200;
		Lib.current.addChild(cir);

		var assertStart = Assert.createAsync(function() Assert.equals(20,cir.x), 100);
		var assertFirstTick = Assert.createAsync(function() Assert.equals(20,cir.x), 100);
		var assertEnd = Assert.createAsync(function() Assert.equals(100,cir.x), 1500);
		var assertStop = Assert.createAsync(function() Assert.equals(100,cir.x), 1500);

		var firstTick = true;
		
		var m = new Medley(new EaseNote(20,100,1,Linear.easeNone));
		
		m.events.tick.bind(function(val:Float) {
			cir.x = val;
			if (firstTick) {
				assertFirstTick();
				firstTick = false;
			}
		});
		
		m.events.stop.bindVoid(assertStop);

		m.events.reachStart.bindVoid(assertStart);

		m.events.reachEnd.bindVoid(function(){
			assertEnd();
			Lib.current.removeChild(cir);
		});
		
		m.play();
	}

	public function testChainedMedley():Void {
		var cir = new Sprite();
		cir.graphics.beginFill(0);
		cir.graphics.drawCircle(0,0,10);
		cir.x = cir.y = 200;
		Lib.current.addChild(cir);

		var m1 = new Medley(new EaseNote(20,40,0.3,Linear.easeNone));
		var m2 = new Medley(new EaseNote(50,70,0.3,Linear.easeNone));
		var m3 = new Medley(new EaseNote(80,100,0.3,Linear.easeNone));

		m1.next = m2;
		m2.next = m3;
		
		var assertAllEnd = Assert.createAsync(function() {
			Assert.equals(100,cir.x);
			Assert.isFalse(m1.isPlaying);
			Assert.isFalse(m2.isPlaying);
			Assert.isFalse(m3.isPlaying);
			Assert.isTrue(m1.isAtEnd);
			Assert.isTrue(m2.isAtEnd);
			Assert.isTrue(m3.isAtEnd);
		}, 1500);

		var updateCir = function(val:Float) {
			cir.x = val;

			//assert there is one and only one in the chain is playing.
			Assert.equals(1,[m1,m2,m3].fold(function(m:Medley<Dynamic>,val:Float) return m.isPlaying ? val + 1 : val,0));
		}
		m1.events.tick.bind(updateCir);
		m2.events.tick.bind(updateCir);
		m3.events.tick.bind(updateCir);

		m3.events.reachEnd.bindVoid(function(){
			assertAllEnd();
			Lib.current.removeChild(cir);
		});

		m1.play();
	}

	public function testChainedMedleyAdvanced():Void {
		var cir = new Sprite();
		cir.graphics.beginFill(0);
		cir.graphics.drawCircle(0,0,10);
		cir.x = cir.y = 200;
		Lib.current.addChild(cir);

		var m1 = new Medley(new EaseNote(20,50,0.3,Linear.easeNone));
		var m2 = new Medley(new EaseNote(50,80,0.3,Linear.easeNone));
		var m3 = new Medley(new EaseNote(80,100,0.3,Linear.easeNone));

		m1.next = m2;
		m2.next = m3;

		m1.repeat = 2;
		m2.repeat = 2;
		m2.yoyo = true;
		m3.yoyo = true;

		var m1ReachStart = 0;
		var m1ReachEnd = 0;
		var m2ReachStart = 0;
		var m2ReachEnd = 0;
		var m3ReachStart = 0;
		var m3ReachEnd = 0;
		
		var assertAllEnd = Assert.createAsync(function() {
			Assert.equals(100,cir.x);
			Assert.isFalse(m1.isPlaying);
			Assert.isFalse(m2.isPlaying);
			Assert.isFalse(m3.isPlaying);
			Assert.isTrue(m1.isAtEnd);
			Assert.isTrue(m2.isAtEnd);
			Assert.isTrue(m3.isAtEnd);

			Assert.equals(3,m1ReachStart);
			Assert.equals(3,m1ReachEnd);
			Assert.equals(2,m2ReachStart);
			Assert.equals(2,m2ReachEnd);
			Assert.equals(1,m3ReachStart);
			Assert.equals(1,m3ReachEnd);
		}, 2500);

		var updateCir = function(val:Float) {
			cir.x = val;

			//assert there is one and only one in the chain is playing.
			Assert.equals(1,[m1,m2,m3].fold(function(m:Medley<Dynamic>,val:Float) return m.isPlaying ? val + 1 : val,0));
		}
		m1.events.tick.bind(updateCir);
		m2.events.tick.bind(updateCir);
		m3.events.tick.bind(updateCir);
		
		m1.events.reachStart.bindVoid(function() ++m1ReachStart);
		m2.events.reachStart.bindVoid(function() ++m2ReachStart);
		m3.events.reachStart.bindVoid(function() ++m3ReachStart);

		m1.events.reachEnd.bindVoid(function() ++m1ReachEnd);
		m2.events.reachEnd.bindVoid(function() ++m2ReachEnd);
		m3.events.reachEnd.bindVoid(function(){
			++m3ReachEnd;
			assertAllEnd();
			Lib.current.removeChild(cir);
		});

		m1.play();
	}
}
