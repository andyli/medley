package medley;

import medley.IMedley;
import medley.easing.Linear;
import medley.events.MedleyEvents;
import medley.metronome.GlobalMetronome;
import medley.metronome.IMetronome;
import medley.note.INote;
import haxe.Timer;

class MedleySingle<N:INote> implements IMedley<MedleySingle<N>> #if production , implements haxe.rtti.Generic #end {
	public function new(note:N):Void {
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

	/*
		Start playing.
	*/
	public function play():MedleySingle<N> {
		if (!isPlaying) {
			timePrevious = Timer.stamp();

			metronome.bindVoid(onTick);
			
			isPlaying = true;
			
			events.play.dispatch();
		}

		return this;
	}

	/*
		Pause the Medley.
	*/
	public function stop():MedleySingle<N> {
		if(isPlaying){
			metronome.unbindVoid(onTick);
		
			isPlaying = false;
		
			events.stop.dispatch();
		}

		return this;
	}

	/*
		Seek to the specific time(in second). Does NOT auto play/stop/tick.
	*/
	public function seek(time:Float):MedleySingle<N> {
		timeProgress = time;
		
		events.seek.dispatch();

		return this;
	}

	/*
		Swap the start and end of the Medley. Does NOT auto play/stop/tick.
		If you want the Medley plays in reverse direction, set timeScale to -1 instead of using this method.
	*/
	public function reverse():MedleySingle<N> {
		timeProgress = duration - timeProgress;

		//swap start and end
		var temp = startValue;
		startValue = endValue;
		endValue = temp;

		events.reverse.dispatch();

		return this;
	}

	/*
		Calulate the values.
	*/
	public function tick(?updateTimeProgress = true):MedleySingle<N> {
		if (updateTimeProgress) {
			var timeCurrent = Timer.stamp();
			timeProgress += (timeCurrent - timePrevious) * timeScale;
			timePrevious = timeCurrent;
		}

		if (timeProgress <= 0) { //reach start
			dispatchNewValue(timeProgress = 0);
			stop();
			events.reachStart.dispatch();
		} else if (timeProgress >= duration) { //reach end
			dispatchNewValue(timeProgress = duration);
			stop();
			events.reachEnd.dispatch();
		} else {
			dispatchNewValue(timeProgress);
		}

		return this;
	}

	function onTick():Void {
		tick();
	}

	function dispatchNewValue(val:Float):Void {
		events.tick.dispatch(note.valueOf(val));
	}

	/*
		The object that stores Singlers.
	*/
	public var events:MedleyEvents;

	/*
		Time stamp(in seconds) of previous tick.
	*/
	public var timePrevious(default,null):Float;

	/*
		Progress of the Medley in seconds.
	*/
	public var timeProgress(default,null):Float;

	/*
		Start value.
	*/
	public var startValue:Float;

	/*
		End value.
	*/
	public var endValue:Float;

	/*
		Time scale that affect the speed of the Medley. Normal is 1.
		Nagative number will make the medley plays in reverse direction.
	*/
	public var timeScale:Float;

	/*
		Duration in seconds.
	*/
	public var duration:Float;

	/*
		Indicate if the Medley is playing.
	*/
	public var isPlaying(default,null):Bool;

	/*
		The Metronome that controlling this Medley.
	*/
	public var metronome(default,null):IMetronome;
}
