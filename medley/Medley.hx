package medley;

import medley.IMedley;
import medley.easing.Linear;
import medley.events.MedleyEvents;
import medley.metronome.GlobalMetronome;
import medley.metronome.IMetronome;
import haxe.Timer;

class Medley implements IMedley<Medley> {
	public function new(?ease:Easing, ?startValue:Float = 0, ?endValue:Float = 1, ?duration:Float = 1, ?medleys:Array<IMedley<Dynamic>>):Void {
		this.ease = ease == null ? Linear.easeNone : ease;
		this.medleys = medleys == null ? [] : medleys;
		
		this.startValue = startValue;
		this.endValue = endValue;
		this.duration = duration;
		timeProgress = 0;
		timeScale = 1;
		events = new MedleyEvents(this);
		metronome = GlobalMetronome.getInstance();
	}

	/*
		Start playing.
	*/
	public function play():Medley {
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
	public function stop():Medley {
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
	public function seek(time:Float):Medley {
		timeProgress = time;
		
		events.seek.dispatch();

		return this;
	}

	/*
		Swap the start and end of the Medley. Does NOT auto play/stop/tick.
		If you want the Medley plays in reverse direction, set timeScale to -1 instead of using this method.
	*/
	public function reverse():Medley {
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
	public function tick(?updateTimeProgress = true):Medley {
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
		events.tick.dispatch(ease(val, startValue, endValue - startValue, duration));
	}

	/*
		The object that stores Singlers.
	*/
	public var events:MedleyEvents;
	
	public var medleys:Array<IMedley<Dynamic>>;

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
		Easing function that apply to the value of each tick.
	*/
	public var ease:Easing;

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
