module deadmemory.freelist;

import syscall = deadmemory.syscall;


/**
 * Node ...
 */
struct Node {
	Node* prev, next;	
	syscall.MemView memView;
	bool isFree;

@safe pure nothrow @nogc:

	T* getPtr(T)() const {
		return memView.toPtr!T();
	}

	private:
	static auto opCall(size_t memViewLen) {
		auto newNode = syscall.shiftBrk(Node.sizeof).toPtr!Node();
		newNode.memView = syscall.shiftBrk(memViewLen);
		return newNode;
	}

	Node* addNext(size_t memViewLen) {
		auto newNode = Node(memViewLen);
		newNode.prev = &this;
		this.next = newNode;
		return this.next;
	}

	size_t len() const {
		return this.memView.len();
	}

}


struct FreeList {
	Node* head, tail;

	@disable this(this);
@safe pure nothrow @nogc:
	Node* getFisrtFree(size_t memViewLen) {
		Node* current = this.head;
		immutable size_t forLen = memViewLen;
		while (current !is null && current.len() < forLen)
			current = current.next;
		return current;
	}

	Node* getFisrtFreeOrAdd(size_t memViewLen) {
		// this is NULL.
		Node* res = this.getFisrtFree(memViewLen);
		if (res is null)
			res = this.add(memViewLen);
		return res;
	}

	Node* add(size_t memViewLen) {
		if (this.tail !is null) {
			this.tail = this.tail.addNext(memViewLen);
		} else {
			this.head = Node(memViewLen);
			this.tail = this.head;
		}
		return this.tail;
	}

}
