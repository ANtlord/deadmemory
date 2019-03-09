module deadmemory.convert;

@safe pure nothrow @nogc:

T* toPtr(T)(size_t address) {
	return safeCast!(T*, size_t)(address);
}

size_t fromPtr(T)(const T* ptr) {
	return safeCast!(size_t, const T*)(ptr);
}

/**
 * "Safe" convertion of types. ONLY for size_t and pointers.
 */
pragma(inline)
To safeCast(To, From)(From from) {
	To res;
	version(X86_64) {
		asm @safe pure nothrow @nogc {
			mov RAX, from[RBP];
			mov res[RBP], RAX;
		}
	} else version(X86) {
		asm @safe pure nothrow @nogc {
			mov EAX, from[EBP];
			mov res[EBP], EAX;
		}
	} else {
		static assert(false, "Unsupported platform");
	}
	return res;
}
