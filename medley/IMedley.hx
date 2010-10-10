package medley;

import medley.events.MedleyEvents;
import medley.metronome.IMetronome;

/*
	Interface for the Medley classes.
*/
interface IMedley<M:IMedley<Dynamic>> {
	/*
		Start playing.
	*/
	public function play():M;

	/*
		Pause the Medley.
	*/
	public function stop():M;

	/*
		Seek to the specific time(in second). Does NOT auto play/stop/tick.
	*/
	public function seek(time:Float):M;

	/*
		Calulate the values.
	*/
	public function tick(?updateTimeProgress:Bool = true):M;

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
	public function getStartValue():Float;

	/*
		End value.
	*/
	public function getEndValue():Float;

	/*
		Time scale that affect the speed of the Medley. Normal is 1.
		Nagative number will make the medley plays in reverse direction.
	*/
	public var timeScale:Float;

	/*
		Duration in seconds.
	*/
	public function getDuration():Float;

	/*
		Indicate if the Medley is playing.
	*/
	public var isPlaying(default,null):Bool;

	/*
		The Metronome that controlling this Medley.
	*/
	public var metronome(default,null):IMetronome;
}
