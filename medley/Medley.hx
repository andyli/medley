package medley;

import medley.events.MedleyEvents;
import medley.metronome.GlobalMetronome;
import medley.metronome.IMetronome;
import haxe.Timer;

class Medley {
	public function new(?startValue:Float = 0, ?endValue:Float = 1, ?medleys:Array<Medley>):Void {
		this.medleys = medleys == null ? [] : medleys;
		
		this.startValue = startValue;
		this.endValue = endValue;
		timeProgress = 0;
		events = new MedleyEvents(this);
		metronome = GlobalMetronome.getInstance();
	}

	/*
		Start playing.
	*/
	public function play():Void {
		if (!isPlaying) {
			timePrevious = Timer.stamp();

			metronome.bindVoid(onTick);
			
			isPlaying = true;

			if (timeProgress <= 0) {
				events.start.dispatch();
			}
			
			events.play.dispatch();
		}
	}

	/*
		Pause the Medley.
	*/
	public function stop():Void {
		if(isPlaying){
			metronome.unbindVoid(onTick);
		
			isPlaying = false;
		
			events.stop.dispatch();
		}
	}

	/*
		Back to the start point. Does NOT auto play/stop.
	*/
	public function reset():Void {
		timePrevious = Timer.stamp();
		timeProgress = 0;
		
		events.reset.dispatch();
	}

	/*
		Make the Medley goes the opposite way. Does NOT auto play/stop.
	*/
	public function reverse():Void {
		timeProgress = duration - timeProgress;

		//swap start and end
		var temp = startValue;
		startValue = endValue;
		endValue = temp;

		events.reverse.dispatch();
	}

	function onTick():Void {
		var timeCurrent = Timer.stamp();
		timeProgress += timeCurrent - timePrevious;
		timePrevious = timeCurrent;

		if (timeProgress <= duration) {
			events.tick.dispatch(startValue + (endValue - startValue) * (timeProgress / duration));
		} else {
			stop();
			events.end.dispatch();
		}
	}

	public var events:MedleyEvents;
	public var medleys:Array<Medley>;
	public var timePrevious(default,null):Float;
	public var timeProgress(default,null):Float;
	public var startValue:Float;
	public var endValue:Float;

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
