package medley.note;

private typedef Easing = Float -> Float -> Float -> Float -> Float;

class EaseNote implements INote {
	public function new(startVal:Float, endVal:Float, dur:Float, easeFn:Easing):Void {
		startValue = startVal;
		endValue = endVal;
		duration = dur;
		ease = easeFn;
	}
	
	public var startValue(default,null):Float;
	public var endValue(default,null):Float;
	public var duration(default,null):Float;
	public var ease(default,null):Easing;
	inline public function valueOf(pos:Float):Float {
		return ease(pos, startValue, endValue, duration);
	}
}
