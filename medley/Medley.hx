package medley;

import medley.events.MedleyEvents;
import medley.metronome.GlobalMetronome;
import medley.metronome.IMetronome;
import medley.note.INote;
import medley.util.MedleyIterators.MedleyIteratorNext;
import hsl.haxe.Signaler;
import haxe.Timer;

using Lambda;

class Medley<N:medley.note.INote> {
	public function new(?note:N, ?children:Medley<Dynamic>):Void {
		if (children == null) {
			if (note == null)
				throw "You must provide either note or children.";
			
			this.note = note;
		} else {
			if (note != null)
				throw "You must provide either note or children.";
			
			this.children = children;
		}
		
		timeProgress = 0;
		timeProgressPasted = 0;
		timeScale = 1;
		timePrev = Math.NaN;
		isAtStart = true;
		isAtEnd = false;
		repeat = 0;
		yoyo = false;
		events = new MedleyEvents(this);
		metronome = GlobalMetronome.getInstance();
		head = tail = this;
	}

	/*
		Free memory. Not necessary since normally gc will do it job.
	*/
	public function destroy():Void {
		stop();
		events.destroy();
		events = null;
		head = tail = null;
		_prev = _next = null;
		_parent = _children = null;
		currentChild = null;
		metronome = null;
		note = null;
	}

	/*
		Calulate the values.
	*/
	public function tick(?updateTimeProgress = true):{ medley:Medley<N>, value:Float, timeExcessed:Float } {
		var value:Float = Math.NaN;
		var timeExcessed:Float = Math.NaN;
		var timeD:Float = 0;
		
		if (updateTimeProgress) {
			var timeCurrent = Timer.stamp();
			
			if (timePrev != Math.NaN)
				timeProgress += (timeD = (timeCurrent - timePrev) * timeScale);
				
			timePrev = timeCurrent;
		}

		if (_children == null) { //this is Medley that plays single Note.
			if (timeProgress <= 0) { //reach start
				isAtStart = true;
				timeExcessed = -timeProgress;
				
				dispatchNewTick(note.valueOf(value = timeProgress = 0));

				if (timeScale < 0) {
					if (repeat == 0) {
						if (_prev != null) {
							_stop(false);
							_prev._play(false);
							_prev.timeProgress = timeExcessed;
						} else {
							_stop(true);
						}
						events.reachStart.dispatch(timeExcessed);
					} else {
						if (repeat > 0) --repeat;

						if (yoyo) {
							timeScale *= -1;
							events.reachStart.dispatch(timeExcessed);
							timeProgress = timeExcessed;
						} else {
							timeProgress = getDuration();
							events.reachStart.dispatch(timeExcessed);
						}
					}
				} else {
					events.reachStart.dispatch(timeExcessed);
				}
			} else if (timeProgress >= getDuration()) { //reach end
				isAtEnd = true;
				timeExcessed = timeProgress - getDuration();
				value = timeProgress = getDuration();

				dispatchNewTick(note.valueOf(value));

				if (timeScale > 0){
					if (repeat == 0) {
						if (_next != null) {
							_stop(false);
							_next._play(false);
							_next.timeProgress = timeExcessed;
						} else {
							_stop(true);
						}
						events.reachEnd.dispatch(timeExcessed);
					} else {
						if (repeat > 0) --repeat;

						if (yoyo) {
							timeScale *= -1;
							timeProgress = getDuration() - timeExcessed;
							events.reachEnd.dispatch(timeExcessed);
						} else {
							events.reachEnd.dispatch(timeExcessed);
							timeProgress = 0;
							tick(false);
							timeProgress = timeExcessed;
						}
					}
				} else {
					events.reachEnd.dispatch(timeExcessed);
				}
			} else {
				isAtStart = isAtEnd = false;
				dispatchNewTick(note.valueOf(value = timeProgress));
			}
		} else { //this is Medley that plays children.
			var result = currentChild.tick(updateTimeProgress);
			value = result.value;
			//TODO
			timeExcessed = result.timeExcessed;
		}

		return { medley:this, value:value, timeExcessed:timeExcessed };
	}

	var timeProgressPasted:Float;

	function onTick():Void {
		tick();
	}

	function dispatchNewTick(val:Float):Void {
		events.tick.dispatch(val);
		if (_parent != null) _parent.dispatchNewTick(val);
	}

	function dispatch(signaler:Signaler<Dynamic>, ?val:Dynamic = null):Void {
		signaler.dispatch(val);
	}

	/*
		Start playing.
	*/
	public function play():Medley<N> {
		_play(true);

		return this;
	}
	function _play(toParent:Bool):Void {
		if (!isPlaying) {
			if (toParent && _parent != null) {
				if (_parent.currentChild != null) {
					_parent.currentChild.stop();
				}
				_parent.currentChild = this;
			}
		
			timePrev = Timer.stamp();

			metronome.bindVoid(onTick);
			
			isPlaying = true;
			
			events.play.dispatch();

			tick(false);

			if (toParent) {
				var p = _parent;
				while (p != null) {
					p.dispatch(p.events.play);
					p = p._parent;
				}
			}
		}
	}

	/*
		Pause the Medley.
	*/
	public function stop():Medley<N> {
		_stop(true);

		return this;
	}
	function _stop(toParent:Bool):Void {
		if(isPlaying){
			metronome.unbindVoid(onTick);
		
			isPlaying = false;
		
			events.stop.dispatch();

			if (toParent && _parent != null) {
				_parent.currentChild = null;
				_parent.stop();
			}
		}
	}

	/*
		Seek to the specific time(in second). Does NOT auto play/stop/tick.
	*/
	public function seek(time:Float):Medley<N> {
		timeProgress = time;
		
		events.seek.dispatch();

		if (_parent != null) {
			//TODO
			var p = _parent;
			while (p != null) {
				p.dispatch(p.events.seek);
				p = p._parent;
			}
		}

		return this;
	}

	/*
		Time stamp(in seconds) of prev tick(true).
	*/
	public var timePrev(default,null):Float;

	/*
		Progress of the Medley in seconds.
	*/
	public var timeProgress(default,null):Float;

	/*
		Start value.
	*/
	public function getStartValue():Float {
		return _children == null ? note.startValue : _children.getStartValue();
	}

	/*
		End value.
	*/
	public function getEndValue():Float {
		return _children == null ? note.endValue : _children.tail.getEndValue();
	}

	/*
		Duration in seconds.
	*/
	public function getDuration():Float {
		return _children == null ? note.duration : _children.fold(function(m:Medley<Dynamic>,t:Float) return t + m.getDuration(), 0);
	}

	/*
		Time scale that affect the speed of the Medley. Normal is 1.
		Nagative number will make the medley plays in reverse direction.
	*/
	public var timeScale:Float;

	/*
		Indicate if the Medley is playing.
	*/
	public var isPlaying(default,null):Bool;

	/*
		Indicate if the Medley is at its start.
	*/
	public var isAtStart(default,null):Bool;

	/*
		Indicate if the Medley is at its end.
	*/
	public var isAtEnd(default,null):Bool;

	

	/*
		The Metronome that controlling this Medley.
	*/
	public var metronome(getMetronome, setMetronome):IMetronome;
	var _metronome:IMetronome;
	inline function getMetronome():IMetronome {
		return _metronome;
	}
	function setMetronome(m:IMetronome):IMetronome {
		if (isPlaying) {
			_metronome.unbindVoid(onTick);
			m.bindVoid(onTick);
		}
		return _metronome = m;
	}

	/*
		The object that stores Singlers.
	*/
	public var events(default,null):MedleyEvents;

	/*
		The head of children Medley chain of this Medley.
		If it is set to a Medley that is not a head, the head of that medley is used.
	*/
	public var children(getChildren,setChildren):Medley<Dynamic>;
	var _children:Medley<Dynamic>;
	inline function getChildren():Medley<Dynamic> {
		return _children;
	}
	function setChildren(m:Medley<Dynamic>):Medley<Dynamic> {
		if (m == null) {
			//unlink current children
			if (_children != null) {
				for (c in _children) {
					c._parent = null;
				}
			}

			_children = null;
		} else {
			if (_children != m.head) {
				//unlink current children
				if (_children != null) {
					for (c in _children) {
						c._parent = null;
					}
				}

				_children = m.head;
				for (c in m.head) {
					c._parent = this;
				}
			}
		}
		return m;
	}
	
	/*
		Parent of this Medley.
	*/
	public var parent(getParent,setParent):Medley<Dynamic>;
	var _parent:Medley<Dynamic>;
	inline function getParent():Medley<Dynamic>{
		return _parent;
	}
	function setParent(m:Medley<Dynamic>):Medley<Dynamic> {
		if (m != null) {
			//unlink target's children
			if (m._children != null) {
				for (c in m._children) {
					c._parent = null;
				}
			}
			
			m._children = head;
		}

		if (_parent != null) _parent._children = null;
		
		//propagate parent
		for (c in head){
			c._parent = m;
		}
		
		return m;
	}

	/*
		Prev Medley.
		If it is linked to a Medley that has parent, this chain becomes the children of that parent.
	*/
	public var prev(getPrev,setPrev):Medley<Dynamic>;
	var _prev:Medley<Dynamic>;
	inline function getPrev():Medley<Dynamic>{
		return _prev;
	}
	function setPrev(m:Medley<Dynamic>):Medley<Dynamic> {
		if (_prev != m){
			if (_prev != null) _prev._next = null;
			
			//change tail of current prevs
			var curPrev = _prev;
			while (curPrev != null) {
				curPrev.tail = _prev;
				curPrev = curPrev._prev;
			}
			
			_prev = m;

			if (_parent != null && head == this) {
				_parent._children = null;
			}
			_parent = m == null ? null : m._parent;
			
			if (m != null){
				m._next = this;
				head = m.head;

				//propagate tail
				var mPrev:Medley<Dynamic> = m;
				do {
					mPrev.tail = tail;
					mPrev = mPrev._prev;
				} while (mPrev != null);
			} else {
				head = this;
			}

			//propagate head and parent
			for (c in this){
				c.head = head;
				c._parent = _parent;
			}
		}
		return m;
	}

	/*
		Next Medley.
		If it has parent, this linked Medley chain becomes the children of this parent.
	*/
	public var next(getNext,setNext):Medley<Dynamic>;
	var _next:Medley<Dynamic>;
	inline function getNext():Medley<Dynamic>{
		return _next;
	}
	function setNext(m:Medley<Dynamic>):Medley<Dynamic> {
		if (_next != m){
			if (_next != null) _next._prev = null;
			
			//change head and parent of current nexts
			var curNext = _next;
			while (curNext != null) {
				curNext.head = _next;
				curNext._parent = null;
				curNext = curNext._next;
			}
			
			_next = m;
			
			if (m != null){
				m._prev = this;
				tail = m.tail;

				if (m._parent != null) {
					if (m.head == m) {
						m.parent = null; //using parent setter to unlink parent
					} else {
						m.prev = null; //using prev setter to unlink prev and parent
					}
				}

				//propagate head and parent
				for (c in m) {
					c.head = head;
					c._parent = _parent;
				}
			} else {
				tail = this;
			}

			//propagate tail
			var thisPrev:Medley<Dynamic> = this;
			do {
				thisPrev.tail = tail;
				thisPrev = thisPrev._prev;
			} while (thisPrev != null);
		}
		return m;
	}

	/*
		The head(1st one) of the whole Medley chain.
	*/
	public var head(default,null):Medley<Dynamic>;
	
	/*
		The tail(last one) of the whole Medley chain.
	*/
	public var tail(default,null):Medley<Dynamic>;

	/*
		Current playing child.
	*/
	public var currentChild(default,null):Medley<Dynamic>;

	/*
		The Medley will auto repeat for the value of it. Default is 0. Set it to -1 for end-less repeat.
	*/
	public var repeat:Int;

	/*
		If set to true, the Medlay will auto reverse its direction when it reach end/start. Should also set repeat to a non-zero value. Default is false.
	*/
	public var yoyo:Bool;

	/*
		The Note of this Medley.
	*/
	public var note(default,null):N;

	/*
		Iterate from this to tail.
		Caution: a endless loop will be created if the linked-list is a loop. You should always use "repeat" if you want a loop.
	*/
	public function iterator():Iterator<Medley<Dynamic>> {
		return new MedleyIteratorNext(this);
	}
}
