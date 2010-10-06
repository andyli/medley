package medley;

import medley.ease.IEase;
import medley.metronome.IMetronome;
import medley.metronome.GlobalMetronome;
import haxe.Timer;

typedef TimeMap = Hash<Int>;
typedef EaseMap = Hash<IEase>;
typedef NoteMap = Hash<Void->Dynamic>;

class Pipe {
	static public function __init__():Void {
		defaultTimeMap = new TimeMap();
		defaultTimeMap.set("-", 10);
		defaultTimeMap.set("=", 20);
		defaultTimeMap.set("#", 100);
		
		defaultEaseMap = new EaseMap();
		/*
		defaultEaseMap.set(new Linear("[","]"));
		defaultEaseMap.set(new Sine("(",")","]"));
		defaultEaseMap.set(new Strong("<",">","]"));
		defaultEaseMap.set(new Elastic("{","}","]"));
		*/
		
		defaultNoteMap = new NoteMap();
	}

	static public var defaultTimeMap(default,null):TimeMap;
	static public var defaultEaseMap(default,null):EaseMap;
	static public var defaultNoteMap(default,null):NoteMap;
	
	public var timeMap(default,null):TimeMap;
	public var easeMap(default,null):EaseMap;
	public var noteMap(default,null):NoteMap;
	public var metronome(default,null):IMetronome;

	public var score(default,null):Array<String>;
	public var scorePos(default,null):Int;

	public var value(default,null):Float;
	
	public function new(?timeMap:TimeMap, ?easeMap:EaseMap, ?noteMap:NoteMap, ?metronome:IMetronome):Void {
		this.timeMap = timeMap == null ? defaultTimeMap : timeMap;
		this.easeMap = easeMap == null ? defaultEaseMap : easeMap;
		this.noteMap = noteMap == null ? defaultNoteMap : noteMap;

		this.metronome = metronome == null ? GlobalMetronome.getInstance() : metronome;

		score = [""];
		value = Math.NaN;
		_blankNotes = "";
		setSpeed(1);
		scorePos = 0;
		_curTwnTimePos = 0;
	}

	public function blow(timeEaseVal:String):Pipe {
		_blankNotes = StringTools.rpad(_blankNotes, " ", score[0].length);
		score[0] += timeEaseVal;
		_lastLength = timeEaseVal.length;
		return this;
	}

	public function note(notes:String):Pipe {
		if (notes.length != _lastLength) throw "Length of actionFthrs should be the same as length of timeEaseVal.";
		score.push(_blankNotes + notes);
		return this;
	}

	public function play():Pipe {
		_lastTimeStamp = Timer.stamp() * 1000;
		metronome.bindVoid(_update);
		return this;
	}

	public function stop():Pipe {
		metronome.unbindVoid(_update);
		return this;
	}

	public function update():Pipe {
		_update();
		return this;
	}

	public function setSpeed(speed:Float):Pipe {
		_speed = speed;

		if (_speed > 0) {
			_update = _updateForward;
		} else if (_speed < 0) {
			_update = _updateBackward;
		} else {
			stop();
		}
		
		return this;
	}

	public function getSpeed():Float {
		return _speed;
	}

	public function destroy():Void {
		stop();
		timeMap = null;
		easeMap = null;
		noteMap = null;
		metronome = null;
		score = null;
	}
	
	private var _blankNotes:String;
	private var _lastLength:Int;
	private var _speed:Float;
	private var _curTwnEaseFunc:Dynamic;
	private var _curTwnStart:Float;
	private var _curTwnEnd:Float;
	private var _curTwnDuration:Float;
	private var _curTwnTimePos:Float; //in ms
	private var _lastTimeStamp:Float; //in ms
	private var 
	private var _update:Void->Void;
	private function _updateForward():Void {
		var curStamp = Timer.stamp() * 1000;
		var circumlatedTime = _lastTimeStamp - curStamp;
		
		
		
		if(_curTwnEaseFunc == null) {	//start of scroll
			var blowF = score[0].charAt(scorePos);
			if(easeMap.exists(blowF)) {
				
			}
			if(timeMap.exists(blowF)) {
				var time = timeMap.get(blowF);
				if (circumlatedTime >= time) { //reach blow frame
					_curTwnTimePos += circumlatedTime;
					_lastTimeStamp = curStamp;
					
				}
			}
		}
		++scorePos;
	}
	private function _updateBackward():Void {
		//TODO
		if(value == Math.NaN) {
			
		}
	}
}
