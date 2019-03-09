module deadmemory.mem;

import core.stdc.stdio: printf;

import convert = deadmemory.convert;
import freelist = deadmemory.freelist;
import syscall = deadmemory.syscall;

alias FreeList = freelist.FreeList;

struct Malloc {
@safe pure nothrow @nogc:
	@disable this(this);

	T* call(T)(size_t len = 1) {
		immutable size_t memViewLen = T.sizeof * len;
		if (this.list is null)
			this.list = syscall.shiftBrk(FreeList.sizeof).toPtr!FreeList();
		assert(this.list !is null);
		T* ptr = this.list.getFisrtFreeOrAdd(memViewLen).getPtr!T();

		debug {
			const size_t blockSize = memViewLen;
			const size_t* blockSizePtr = &blockSize;
			printf(
				"blockSizePtr=%llu, ptr=%llu, diff=%llu\n",
				blockSizePtr, ptr, cast(size_t)ptr - cast(size_t)blockSizePtr,
			);
			assert(cast(size_t*)ptr != blockSizePtr);
		}

		return ptr;
	}

private:
	FreeList* list = null;
}

Malloc malloc;
