package medley;

import medley.easing.Linear;
import medley.events.MedleyEvents;
import medley.metronome.GlobalMetronome;
import medley.metronome.IMetronome;
import haxe.Timer;

typedef Easing = Float -> Float -> Float -> Float -> Float;

class Medley {
	public function new(?ease:Easing, ?startValue:Float = 0, ?endValue:Float = 1, ?medleys:Array<Medley>):Void {
		this.ease = ease == null ? Linear.easeNone : ease;
		this.medleys = medleys == null ? [] : medleys;
		
		this.startValue = startValue;
		this.endValue = endValue;
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
		Seek to the specific time(in second). Does NOT auto play/stop.
	*/
	public function seekToTime(time:Float):Medley {
		timePrevious = Timer.stamp();

		dispatchNewValue(timeProgress = time);
		
		events.seek.dispatch();

		return this;
	}

	/*
		Seek to the specific point of the Medley (start is 0, end is 1). Does NOT auto play/stop.
	*/
	public function seekToPoint(point:Float):Medley {
		timePrevious = Timer.stamp();

		dispatchNewValue(timeProgress = duration * point);
		
		events.seek.dispatch();

		return this;
	}

	/*
		Swap the start and end of the Medley. Does NOT auto play/stop.
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

	function onTick():Void {
		var timeCurrent = Timer.stamp();
		timeProgress += (timeCurrent - timePrevious) * timeScale;
		timePrevious = timeCurrent;

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
	}

	function dispatchNewValue(val:Float):Void {
		events.tick.dispatch(ease(val, startValue, endValue - startValue, duration));
	}

	public var events:MedleyEvents;
	public var medleys:Array<Medley>;
	public var timePrevious(default,null):Float;
	public var timeProgress(default,null):Float;
	public var startValue:Float;
	public var endValue:Float;
	public var timeScale:Float;
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
	public var metronome:IMetronome;
}
