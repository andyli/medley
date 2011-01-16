package medley.metronome;

#if (flash || nme || jeash)
import hsl.haxe.DirectSignaler;
import flash.events.Event;
using hsl.avm2.plugins.DisplayObjectShortcuts;
#else
using hsl.haxe.plugins.TimerShortcuts;
#end

class GlobalMetronome {

	static public function getInstance():IMetronome {
		if (_instance == null) {
			#if (flash || nme || jeash)
				_instance = flash.Lib.current.getFrameEnteredSignaler();
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
