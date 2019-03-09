module deadmemory.syscall;

import convert = deadmemory.convert;

@safe pure nothrow @nogc:

enum BRK_CODE {
	X86 = 45,
	X86_64 = 12,
}

/**
 * BRK system call.
 */
pragma(inline)
T brk(T)(size_t heapBreak) {
	T res;
	version(X86_64) {
		asm @safe pure nothrow @nogc {
			mov RAX, BRK_CODE.X86_64;
			mov RDI, heapBreak[RBP];
			syscall;
			mov res[RBP], RAX;
		}
	} else version(X86) {
		asm @safe pure nothrow @nogc {
			mov EAX, BRK_CODE.X86;
			mov EBX, heapBreak[EBP];
			syscall;
			mov res[EBP], EAX;
		}
	} else {
		static assert(false, "Unsupported platform");
	}
	return res;
}

/**
 * Get current heap break.
 */
pragma(inline)
T getCurretnBrk(T)() {
	return brk!(T)(0);
}

struct MemView {
@safe pure nothrow @nogc:
	size_t from, to;

	pragma(inline)
	size_t len() const {
		return to - from;
	}

	pragma(inline)
	T* toPtr(T)() const {
		return convert.toPtr!T(this.from);
	}
}

/**
 * Shift the heap break.
 */
pragma(inline)
MemView shiftBrk(size_t len) {
	const size_t currentBrk = getCurretnBrk!size_t();
	const size_t newHeapBreak = currentBrk + len;
	return MemView(currentBrk, newHeapBreak);
}
