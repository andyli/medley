package medley.metronome;

#if (flash || nme || jeash)
import hsl.haxe.DirectSignaler;
import flash.events.Event;
#else
using hsl.haxe.plugins.TimerShortcuts;
#end

class GlobalMetronome {

	static public function getInstance():IMetronome {
		if (_instance == null) {
			#if (flash || nme || jeash)
				var sp = flash.Lib.current;
				_instance = new DirectSignaler<Void>(GlobalMetronome);
				sp.addEventListener(Event.ENTER_FRAME,function(e:Event) _instance.dispatch());
			#else
				_timer = new haxe.Timer(40);
				_instance = _timer.getTickedSignaler();
				_timer.run();
			#end
		}
		return _instance;
	}
	#if !(flash || nme || jeash)
	static var _timer:Timer;
	#end
	static var _instance:IMetronome;
}
