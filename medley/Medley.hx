package medley;

import medley.IMedley;
import medley.easing.Linear;
import medley.events.MedleyEvents;
import medley.metronome.GlobalMetronome;
import medley.metronome.IMetronome;
import haxe.Timer;

private typedef Easing = Float -> Float -> Float -> Float -> Float;

class Medley
extends AMedley<Medley>,
implements IMedley<Medley> 
{
	public function new(?medleys:Array<IMedley<Dynamic>>, ?duration:Float = 1, ?ease:Easing):Void {
		super();
		
		this.ease = ease == null ? Linear.easeNone : ease;
		this.medleys = medleys == null ? [] : medleys;
		
		this.startValue = 0;
		this.endValue = 1;
		this.duration = duration;
		timeProgress = 0;
		timeScale = 1;
		events = new MedleyEvents(this);
		metronome = GlobalMetronome.getInstance();
	}

	/*
		Calulate the values.
	*/
	override public function tick(?updateTimeProgress = true):Medley {
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

		return cast this;
	}

	override function dispatchNewValue(time:Float):Void {
		events.tick.dispatch(ease(time, startValue, endValue - startValue, duration));
	}
	
	public var medleys:Array<IMedley<Dynamic>>;

	/*
		Easing function that apply to the value of each tick.
	*/
	public var ease:Easing;
}
