package medley;

import medley.metronome.GlobalMetronome;
import medley.metronome.IMetronome;
import haxe.Timer;

class Medley {
	public function new(?medleys:Array<Medley>, ?metronome:IMetronome):Void {
		id = nextId++;
		this.medleys = medleys == null ? [] : medleys;
		this.metronome = metronome == null ? GlobalMetronome.getInstance() : metronome;
		start = 0;
		end = 1;
		timeProgress = 0;
		events = new MedleyEvents(this);
	}

	/*
		Start playing.
	*/
	public function play():Void {
		if (!isPlaying) {
			timePrevious = Timer.stamp();

			playingMedleys.set(id,this);
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
			playingMedleys.remove(id);
		
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
		var temp = start;
		start = end;
		end = temp;

		events.reverse.dispatch();
	}

	function onTick():Void {
		var timeCurrent = Timer.stamp();
		timeProgress += timeCurrent - timePrevious;
		timePrevious = timeCurrent;

		if (timeProgress <= duration) {
			//do tween
			events.tick.dispatch();
		} else {
			stop();
			events.end.dispatch();
		}
	}

	public var events:MedleyEvents;
	public var medleys:Array<Medley>;
	public var timePrevious(default,null):Float;
	public var timeProgress(default,null):Float;

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

	/*
		All the playing Medley objects are stored here so they would't be GC.
	*/
	static var playingMedleys:IntHash<Medley> = new IntHash<Medley>();

	static var nextId:Int = 0;
	var id:Int;
	var start:Float;
	var end:Float;
}
