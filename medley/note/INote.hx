package medley.note;

interface INote {
	/*
		Calculate value of the given position of the note.
		Position should be 0(start) to 1(end).
	*/
	public function valueOf(pos:Float):Float;
	
	public var startValue(default,null):Float;
	public var endValue(default,null):Float;
	public var duration(default,null):Float;
}
