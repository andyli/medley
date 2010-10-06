package medley.metronome;

#if js
using hsl.haxe.plugins.TimerShortcuts;
#else
using hsl.avm2.plugins.DisplayObjectShortcuts;
#end

class GlobalMetronome {

	static public function getInstance():IMetronome {
		if (_instance == null) {
			#if js
			_timer = new haxe.Timer(40);
			_timer.run();
			_instance = _timer.getTickedSignaler();
			#else
			_instance = flash.Lib.current.getFrameEnteredSignaler();
			#end
		}
		return _instance;
	}
	#if js
	static var _timer:Timer;
	#end
	static var _instance:IMetronome;
}
