package medley;

import medley.IMedley;
import medley.easing.Linear;
import medley.events.MedleyEvents;
import medley.metronome.GlobalMetronome;
import medley.metronome.IMetronome;
import haxe.Timer;

using Lambda;

private typedef Easing = Float -> Float -> Float -> Float -> Float;

class Medley
extends AMedley<Medley>,
implements IMedley<Medley> 
{
	public function new(?medleys:Array<IMedley<Dynamic>>, ?ease:Easing):Void {
		super();
		
		this.ease = ease == null ? Linear.easeNone : ease;
		this.medleys = medleys == null ? [] : medleys;
		
		this.startValue = 0;
		this.endValue = 1;
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
		} else if (timeProgress >= getDuration()) { //reach end
			dispatchNewValue(timeProgress = getDuration());
			stop();
			events.reachEnd.dispatch();
		} else {
			dispatchNewValue(timeProgress);
		}

		return cast this;
	}

	override function dispatchNewValue(time:Float):Void {
		events.tick.dispatch(ease(time, getStartValue(), getEndValue() - getStartValue(), getDuration()));
	}

	override public function getDuration():Float {
		return medleys.fold(function(m:IMedley<Dynamic>,t:Float) return t + m.getDuration(), 0);
	}

	override public function getStartValue():Float {
		return startValue;
	}

	override public function getEndValue():Float {
		return endValue;
	}
	
	public var medleys:Array<IMedley<Dynamic>>;

	/*
		Easing function that apply to the value of each tick.
	*/
	public var ease:Easing;


	private var startValue:Float;
	private var endValue:Float;
}
