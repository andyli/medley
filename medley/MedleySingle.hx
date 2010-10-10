package medley;

import medley.events.MedleyEvents;
import medley.metronome.GlobalMetronome;
import medley.note.INote;

class MedleySingle<N:INote> 
extends AMedley<MedleySingle<N>>, 
implements IMedley<MedleySingle<N>> 
#if production , implements haxe.rtti.Generic #end 
{
	public function new(note:N):Void {
		super();
		
		this.note = note;
		
		this.startValue = note.startValue;
		this.endValue = note.endValue;
		this.duration = note.duration;
		timeProgress = 0;
		timeScale = 1;
		events = new MedleyEvents(this);
		metronome = GlobalMetronome.getInstance();
	}

	public var note:N;

	override function dispatchNewValue(time:Float):Void {
		events.tick.dispatch(note.valueOf(time));
	}
}
