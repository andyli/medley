package medley.test;

import utest.Assert;
import medley.Medley;
import medley.note.EaseNote;
import medley.easing.Linear;
using Lambda;

class TestChain {
	public function new();
	
	public function testDoubleLink():Void {
		var children = [];
		for (i in 0...5) {
			children.push(new Medley(new EaseNote(0,1,1,Linear.easeNone)));
		}

		var head = children[0];
		var tail = children[children.length-1];

		//chain up the children
		for (i in 0...children.length-1) {
			children[i].next = children[i+1];
		}

		for (i in 0...children.length-1) {
			Assert.equals(children[i+1],children[i].next);
		}

		for (i in 1...children.length) {
			Assert.equals(children[i-1],children[i].prev);
		}

		for (i in 0...children.length) {
			Assert.equals(children[0],children[i].head);
		}

		for (i in 0...children.length) {
			Assert.equals(children[4],children[i].tail);
		}

		//remove head
		head.next = null;
		Assert.isNull(head.prev);
		Assert.isNull(head.next);
		Assert.equals(head.head, head);
		Assert.equals(head.tail, head);
		
		Assert.isNull(children[1].prev);
		Assert.equals(head.head, head);

		for (i in 1...children.length) {
			Assert.equals(children[1],children[i].head);
			Assert.equals(tail,children[i].tail);
		}

		//re-add the head
		children[1].prev = head;
		for (i in 0...children.length) {
			Assert.equals(head,children[i].head);
			Assert.equals(tail,children[i].tail);
		}


		

		//remove head 2
		children[1].prev = null;
		Assert.isNull(head.prev);
		Assert.isNull(head.next);
		Assert.equals(head.head, head);
		Assert.equals(head.tail, head);
		
		Assert.isNull(children[1].prev);
		Assert.equals(head.head, head);

		for (i in 1...children.length) {
			Assert.equals(children[1],children[i].head);
			Assert.equals(tail,children[i].tail);
		}

		//re-add the head 2
		head.next = children[1];
		for (i in 0...children.length) {
			Assert.equals(head,children[i].head);
			Assert.equals(tail,children[i].tail);
		}
		

		//remove tail
		tail.prev = null;
		Assert.isNull(tail.prev);
		Assert.isNull(tail.next);
		Assert.equals(tail.head, tail);
		Assert.equals(tail.tail, tail);

		for (i in 0...children.length-1) {
			Assert.equals(children[children.length-2],children[i].tail);
		}

		//re-add the tail
		children[children.length-2].next = tail;
		for (i in 0...children.length) {
			Assert.equals(head,children[i].head);
			Assert.equals(tail,children[i].tail);
		}
		

		//remove tail 2
		children[children.length-2].next = null;
		Assert.isNull(tail.prev);
		Assert.isNull(tail.next);
		Assert.equals(tail.head, tail);
		Assert.equals(tail.tail, tail);

		for (i in 0...children.length-1) {
			Assert.equals(children[children.length-2],children[i].tail);
		}

		//re-add the tail 2
		tail.prev = children[children.length-2];
		for (i in 0...children.length) {
			Assert.equals(head,children[i].head);
			Assert.equals(tail,children[i].tail);
		}
	}

	public function testParentChild():Void {
		var parent = new Medley(new EaseNote(0,1,1,Linear.easeNone));
		var children = [];
		for (i in 0...5) {
			children.push(new Medley(new EaseNote(0,1,1,Linear.easeNone)));
		}
		
		var head = children[0];
		var tail = children[children.length-1];

		//chain up the children
		for (i in 0...children.length-1) {
			children[i].next = children[i+1];
		}

		parent.children = tail;
		Assert.equals(head, parent.children);
		for (c in children) {
			Assert.equals(parent, c.parent);
		}

		tail.parent = null;
		Assert.isNull(parent.children);
		for (c in children) {
			Assert.isNull(c.parent);
		}

		//re-link parent-child
		head.parent = parent;
		Assert.equals(head, parent.children);
		for (c in children) {
			Assert.equals(parent, c.parent);
		}

		//remove head
		children[1].prev = null;
		Assert.equals(children[1], children[1].head);
		for (c in children[1]) {
			Assert.isNull(c.parent);
		}
		Assert.equals(parent, head.parent);

		//re-add head
		head.next = children[1];
		for (c in head) {
			Assert.equals(parent, c.parent);
		}

		//re-link parent-child
		parent.children = head;
		Assert.equals(head, parent.children);
		for (c in children) {
			Assert.equals(parent, c.parent);
		}

		//remove tail
		tail.prev = null;
		Assert.isNull(tail.parent);
		for (i in 0...children.length-1){
			Assert.equals(parent,children[i].parent);
		}

		//re-add tail
		children[children.length-2].next = tail;
		for (c in children) {
			Assert.equals(parent, c.parent);
		}
	}
}
