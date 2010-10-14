package medley.note;

class VoidNote implements INote {
	public function new():Void {
		startValue = endValue = duration = Math.NaN;
	}
	
	public var startValue(default,null):Float;
	public var endValue(default,null):Float;
	public var duration(default,null):Float;
	
	inline public function valueOf(pos:Float):Float {
		return Math.NaN;
	}
}
