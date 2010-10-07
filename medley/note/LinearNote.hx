package medley.note;

import medley.easing.Linear;

class LinearNote implements INote {
	public function new(startVal:Float, endVal:Float, dur:Float):Void {
		startValue = startVal;
		endValue = endVal;
		duration = dur;
	}
	
	public var startValue(default,null):Float;
	public var endValue(default,null):Float;
	public var duration(default,null):Float;
	inline public function valueOf(pos:Float):Float {
		return Linear.easeNone(pos, startValue, endValue, duration);
	}
}
