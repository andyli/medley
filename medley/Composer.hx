package medley;

import medley.Medley;
import medley.note.VoidNote;

class Composer {
	public function new():Void {
		
	}
	
	public function writeFor(instruments:Array<String>):Composer {
		if (instruments == null || instruments.length < 1) throw "Give some instruments for the Composer!";
		
		return this;
	}
	
	public function write(instrument:String, noteLine:String, ?vocals:Array<String>):Composer {
		
		return this;
	}
	
	public function ____________________________________________________________________________():Composer {
		return this;
	}
	
	public function finish():Medley<Dynamic> {
		return new Medley(new VoidNote());
	}
}