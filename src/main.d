import deadmemory.mem: malloc;
import deadmemory.syscall: getCurretnBrk;
import core.stdc.stdio: printf;
// import core.stdc.stdlib: malloc;

struct memoryNode {
	memoryNode* prev, next;
}

struct Point {
	int x;
	int y;
	int z;
}

// @safe pure nothrow @nogc:
extern(C)
void main(string[] args)
{
	printf("%lu\n", Point.sizeof);

	auto cur1 = getCurretnBrk!size_t();
	printf("cur1=%lu\n", cur1);

	Point* pptr = malloc.call!Point(1000);
	// printf("pptr=%lu\n", pptr);
	// printf("pptr+1=%lu\n", pptr+1);
	// auto cur2 = brk();
	// printf("cur2=%lu\n", cur2);
	// printf("cur2 - cur1 %lu\n", cur2 - cur1);

	// free(pptr);
	// auto cur3 = brk();
	// printf("cur3=%lu\n", cur3);
	// printf("cur3 - cur1 %lu\n", cur3 - cur1);

	// (*pptr).x = 321;
	// (*pptr).y = 111;
	// (*pptr).z = 333;
	// with (pptr) {
		// printf("x=%lu, y=%lu, z=%lu\n", x, y, z);
	// }
}
