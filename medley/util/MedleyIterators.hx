package medley.util;

import medley.Medley;

/*
	Providing various iterators for Medley.
	Use it with "using medley.util.MedleyIterators;".
*/
class MedleyIterators {
	/*
		Iterator that iterates recursively to prev.
	*/
	static public function iteratorPrev(m:Medley<Dynamic>):Iterator<Medley<Dynamic>> {
		return new MedleyIteratorPrev(m);
	}

	/*
		Iterator that iterates recursively to next.
	*/
	static public function iteratorNext(m:Medley<Dynamic>):Iterator<Medley<Dynamic>> {
		return new MedleyIteratorNext(m);
	}

	/*
		Iterator that iterates recursively to parent.
	*/
	static public function iteratorParent(m:Medley<Dynamic>):Iterator<Medley<Dynamic>> {
		return new MedleyIteratorParent(m);
	}

	/*
		Iterator that iterates through children.
	*/
	static public function iteratorChildren(m:Medley<Dynamic>):Iterator<Medley<Dynamic>> {
		return new MedleyIteratorChildren(m);
	}
}

class MedleyIteratorPrev {
	var medley:Medley<Dynamic>;
	
	public function new(m:Medley<Dynamic>):Void {
		medley = m;
	}

	inline public function hasNext():Bool {
		return medley != null;
	}

	inline public function next():Medley<Dynamic> {
		var ret = medley;
		medley = medley.prev;
		return ret;
	}
}

class MedleyIteratorNext {
	var medley:Medley<Dynamic>;
	
	public function new(m:Medley<Dynamic>):Void {
		medley = m;
	}

	inline public function hasNext():Bool {
		return medley != null;
	}

	inline public function next():Medley<Dynamic> {
		var ret = medley;
		medley = medley.next;
		return ret;
	}
}

class MedleyIteratorParent {
	var medley:Medley<Dynamic>;
	
	public function new(m:Medley<Dynamic>):Void {
		medley = m;
	}

	inline public function hasNext():Bool {
		return medley != null;
	}

	inline public function next():Medley<Dynamic> {
		var ret = medley;
		medley = medley.parent;
		return ret;
	}
}

class MedleyIteratorChildren {
	var medley:Medley<Dynamic>;
	
	public function new(m:Medley<Dynamic>):Void {
		medley = m.children;
	}

	inline public function hasNext():Bool {
		return medley != null;
	}

	inline public function next():Medley<Dynamic> {
		var ret = medley;
		medley = medley.next;
		return ret;
	}
}
