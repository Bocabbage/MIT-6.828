
obj/user/testbss:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 0c 01 00 00       	call   80013d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 14             	sub    $0x14,%esp
  80003e:	e8 f6 00 00 00       	call   800139 <__x86.get_pc_thunk.bx>
  800043:	81 c3 bd 1f 00 00    	add    $0x1fbd,%ebx
	int i;

	cprintf("Making sure bss works right...\n");
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	8d 83 b0 f3 ff ff    	lea    -0xc50(%ebx),%eax
  800052:	50                   	push   %eax
  800053:	e8 cd 02 00 00       	call   800325 <cprintf>
  800058:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  80005b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800062:	eb 2c                	jmp    800090 <umain+0x5d>
		if (bigarray[i] != 0)
  800064:	c7 c0 40 20 80 00    	mov    $0x802040,%eax
  80006a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80006d:	8b 04 90             	mov    (%eax,%edx,4),%eax
  800070:	85 c0                	test   %eax,%eax
  800072:	74 18                	je     80008c <umain+0x59>
			panic("bigarray[%d] isn't cleared!\n", i);
  800074:	ff 75 f4             	pushl  -0xc(%ebp)
  800077:	8d 83 d0 f3 ff ff    	lea    -0xc30(%ebx),%eax
  80007d:	50                   	push   %eax
  80007e:	6a 11                	push   $0x11
  800080:	8d 83 ed f3 ff ff    	lea    -0xc13(%ebx),%eax
  800086:	50                   	push   %eax
  800087:	e8 49 01 00 00       	call   8001d5 <_panic>
	for (i = 0; i < ARRAYSIZE; i++)
  80008c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  800090:	81 7d f4 ff ff 0f 00 	cmpl   $0xfffff,-0xc(%ebp)
  800097:	7e cb                	jle    800064 <umain+0x31>
	for (i = 0; i < ARRAYSIZE; i++)
  800099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000a0:	eb 13                	jmp    8000b5 <umain+0x82>
		bigarray[i] = i;
  8000a2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8000a5:	c7 c0 40 20 80 00    	mov    $0x802040,%eax
  8000ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ae:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
	for (i = 0; i < ARRAYSIZE; i++)
  8000b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8000b5:	81 7d f4 ff ff 0f 00 	cmpl   $0xfffff,-0xc(%ebp)
  8000bc:	7e e4                	jle    8000a2 <umain+0x6f>
	for (i = 0; i < ARRAYSIZE; i++)
  8000be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c5:	eb 2f                	jmp    8000f6 <umain+0xc3>
		if (bigarray[i] != i)
  8000c7:	c7 c0 40 20 80 00    	mov    $0x802040,%eax
  8000cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d0:	8b 14 90             	mov    (%eax,%edx,4),%edx
  8000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d6:	39 c2                	cmp    %eax,%edx
  8000d8:	74 18                	je     8000f2 <umain+0xbf>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000da:	ff 75 f4             	pushl  -0xc(%ebp)
  8000dd:	8d 83 fc f3 ff ff    	lea    -0xc04(%ebx),%eax
  8000e3:	50                   	push   %eax
  8000e4:	6a 16                	push   $0x16
  8000e6:	8d 83 ed f3 ff ff    	lea    -0xc13(%ebx),%eax
  8000ec:	50                   	push   %eax
  8000ed:	e8 e3 00 00 00       	call   8001d5 <_panic>
	for (i = 0; i < ARRAYSIZE; i++)
  8000f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8000f6:	81 7d f4 ff ff 0f 00 	cmpl   $0xfffff,-0xc(%ebp)
  8000fd:	7e c8                	jle    8000c7 <umain+0x94>

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	8d 83 24 f4 ff ff    	lea    -0xbdc(%ebx),%eax
  800108:	50                   	push   %eax
  800109:	e8 17 02 00 00       	call   800325 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp
	bigarray[ARRAYSIZE+1024] = 0;
  800111:	c7 c0 40 20 80 00    	mov    $0x802040,%eax
  800117:	c7 80 00 10 40 00 00 	movl   $0x0,0x401000(%eax)
  80011e:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  800121:	83 ec 04             	sub    $0x4,%esp
  800124:	8d 83 57 f4 ff ff    	lea    -0xba9(%ebx),%eax
  80012a:	50                   	push   %eax
  80012b:	6a 1a                	push   $0x1a
  80012d:	8d 83 ed f3 ff ff    	lea    -0xc13(%ebx),%eax
  800133:	50                   	push   %eax
  800134:	e8 9c 00 00 00       	call   8001d5 <_panic>

00800139 <__x86.get_pc_thunk.bx>:
  800139:	8b 1c 24             	mov    (%esp),%ebx
  80013c:	c3                   	ret    

0080013d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80013d:	f3 0f 1e fb          	endbr32 
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	53                   	push   %ebx
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	e8 ec ff ff ff       	call   800139 <__x86.get_pc_thunk.bx>
  80014d:	81 c3 b3 1e 00 00    	add    $0x1eb3,%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code h(ere.
	thisenv = envs + ENVX(sys_getenvid());
  800153:	e8 be 0f 00 00       	call   801116 <sys_getenvid>
  800158:	25 ff 03 00 00       	and    $0x3ff,%eax
  80015d:	89 c2                	mov    %eax,%edx
  80015f:	89 d0                	mov    %edx,%eax
  800161:	01 c0                	add    %eax,%eax
  800163:	01 d0                	add    %edx,%eax
  800165:	c1 e0 05             	shl    $0x5,%eax
  800168:	89 c2                	mov    %eax,%edx
  80016a:	c7 c0 00 00 c0 ee    	mov    $0xeec00000,%eax
  800170:	01 c2                	add    %eax,%edx
  800172:	c7 c0 40 20 c0 00    	mov    $0xc02040,%eax
  800178:	89 10                	mov    %edx,(%eax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80017e:	7e 0b                	jle    80018b <libmain+0x4e>
		binaryname = argv[0];
  800180:	8b 45 0c             	mov    0xc(%ebp),%eax
  800183:	8b 00                	mov    (%eax),%eax
  800185:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	ff 75 0c             	pushl  0xc(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 9a fe ff ff       	call   800033 <umain>
  800199:	83 c4 10             	add    $0x10,%esp

	// exit gracefully
	exit();
  80019c:	e8 06 00 00 00       	call   8001a7 <exit>
}
  8001a1:	90                   	nop
  8001a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a5:	c9                   	leave  
  8001a6:	c3                   	ret    

008001a7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a7:	f3 0f 1e fb          	endbr32 
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	53                   	push   %ebx
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	e8 1a 00 00 00       	call   8001d1 <__x86.get_pc_thunk.ax>
  8001b7:	05 49 1e 00 00       	add    $0x1e49,%eax
	sys_env_destroy(0);
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	6a 00                	push   $0x0
  8001c1:	89 c3                	mov    %eax,%ebx
  8001c3:	e8 1d 0f 00 00       	call   8010e5 <sys_env_destroy>
  8001c8:	83 c4 10             	add    $0x10,%esp
}
  8001cb:	90                   	nop
  8001cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001cf:	c9                   	leave  
  8001d0:	c3                   	ret    

008001d1 <__x86.get_pc_thunk.ax>:
  8001d1:	8b 04 24             	mov    (%esp),%eax
  8001d4:	c3                   	ret    

008001d5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001d5:	f3 0f 1e fb          	endbr32 
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	56                   	push   %esi
  8001dd:	53                   	push   %ebx
  8001de:	83 ec 10             	sub    $0x10,%esp
  8001e1:	e8 53 ff ff ff       	call   800139 <__x86.get_pc_thunk.bx>
  8001e6:	81 c3 1a 1e 00 00    	add    $0x1e1a,%ebx
	va_list ap;

	va_start(ap, fmt);
  8001ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8001ef:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001f2:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  8001f8:	8b 30                	mov    (%eax),%esi
  8001fa:	e8 17 0f 00 00       	call   801116 <sys_getenvid>
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	ff 75 0c             	pushl  0xc(%ebp)
  800205:	ff 75 08             	pushl  0x8(%ebp)
  800208:	56                   	push   %esi
  800209:	50                   	push   %eax
  80020a:	8d 83 78 f4 ff ff    	lea    -0xb88(%ebx),%eax
  800210:	50                   	push   %eax
  800211:	e8 0f 01 00 00       	call   800325 <cprintf>
  800216:	83 c4 20             	add    $0x20,%esp
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80021c:	83 ec 08             	sub    $0x8,%esp
  80021f:	50                   	push   %eax
  800220:	ff 75 10             	pushl  0x10(%ebp)
  800223:	e8 8d 00 00 00       	call   8002b5 <vcprintf>
  800228:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	8d 83 9b f4 ff ff    	lea    -0xb65(%ebx),%eax
  800234:	50                   	push   %eax
  800235:	e8 eb 00 00 00       	call   800325 <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80023d:	cc                   	int3   
  80023e:	eb fd                	jmp    80023d <_panic+0x68>

00800240 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800240:	f3 0f 1e fb          	endbr32 
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	53                   	push   %ebx
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	e8 09 01 00 00       	call   800359 <__x86.get_pc_thunk.dx>
  800250:	81 c2 b0 1d 00 00    	add    $0x1db0,%edx
	b->buf[b->idx++] = ch;
  800256:	8b 45 0c             	mov    0xc(%ebp),%eax
  800259:	8b 00                	mov    (%eax),%eax
  80025b:	8d 58 01             	lea    0x1(%eax),%ebx
  80025e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800261:	89 19                	mov    %ebx,(%ecx)
  800263:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800266:	89 cb                	mov    %ecx,%ebx
  800268:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026b:	88 5c 01 08          	mov    %bl,0x8(%ecx,%eax,1)
	if (b->idx == 256-1) {
  80026f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800272:	8b 00                	mov    (%eax),%eax
  800274:	3d ff 00 00 00       	cmp    $0xff,%eax
  800279:	75 25                	jne    8002a0 <putch+0x60>
		sys_cputs(b->buf, b->idx);
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027e:	8b 00                	mov    (%eax),%eax
  800280:	89 c1                	mov    %eax,%ecx
  800282:	8b 45 0c             	mov    0xc(%ebp),%eax
  800285:	83 c0 08             	add    $0x8,%eax
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	51                   	push   %ecx
  80028c:	50                   	push   %eax
  80028d:	89 d3                	mov    %edx,%ebx
  80028f:	e8 ef 0d 00 00       	call   801083 <sys_cputs>
  800294:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	8b 40 04             	mov    0x4(%eax),%eax
  8002a6:	8d 50 01             	lea    0x1(%eax),%edx
  8002a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ac:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002af:	90                   	nop
  8002b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b5:	f3 0f 1e fb          	endbr32 
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	53                   	push   %ebx
  8002bd:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8002c3:	e8 71 fe ff ff       	call   800139 <__x86.get_pc_thunk.bx>
  8002c8:	81 c3 38 1d 00 00    	add    $0x1d38,%ebx
	struct printbuf b;

	b.idx = 0;
  8002ce:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002d5:	00 00 00 
	b.cnt = 0;
  8002d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002df:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002e2:	ff 75 0c             	pushl  0xc(%ebp)
  8002e5:	ff 75 08             	pushl  0x8(%ebp)
  8002e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ee:	50                   	push   %eax
  8002ef:	8d 83 40 e2 ff ff    	lea    -0x1dc0(%ebx),%eax
  8002f5:	50                   	push   %eax
  8002f6:	e8 e3 01 00 00       	call   8004de <vprintfmt>
  8002fb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8002fe:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800304:	83 ec 08             	sub    $0x8,%esp
  800307:	50                   	push   %eax
  800308:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80030e:	83 c0 08             	add    $0x8,%eax
  800311:	50                   	push   %eax
  800312:	e8 6c 0d 00 00       	call   801083 <sys_cputs>
  800317:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80031a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800325:	f3 0f 1e fb          	endbr32 
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 18             	sub    $0x18,%esp
  80032f:	e8 9d fe ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800334:	05 cc 1c 00 00       	add    $0x1ccc,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800339:	8d 45 0c             	lea    0xc(%ebp),%eax
  80033c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
  80033f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	50                   	push   %eax
  800346:	ff 75 08             	pushl  0x8(%ebp)
  800349:	e8 67 ff ff ff       	call   8002b5 <vcprintf>
  80034e:	83 c4 10             	add    $0x10,%esp
  800351:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
  800354:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <__x86.get_pc_thunk.dx>:
  800359:	8b 14 24             	mov    (%esp),%edx
  80035c:	c3                   	ret    

0080035d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80035d:	f3 0f 1e fb          	endbr32 
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	57                   	push   %edi
  800365:	56                   	push   %esi
  800366:	53                   	push   %ebx
  800367:	83 ec 1c             	sub    $0x1c,%esp
  80036a:	e8 43 06 00 00       	call   8009b2 <__x86.get_pc_thunk.si>
  80036f:	81 c6 91 1c 00 00    	add    $0x1c91,%esi
  800375:	8b 45 10             	mov    0x10(%ebp),%eax
  800378:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037b:	8b 45 14             	mov    0x14(%ebp),%eax
  80037e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800381:	8b 45 18             	mov    0x18(%ebp),%eax
  800384:	ba 00 00 00 00       	mov    $0x0,%edx
  800389:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80038c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  80038f:	19 d1                	sbb    %edx,%ecx
  800391:	72 4d                	jb     8003e0 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800393:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800396:	8d 78 ff             	lea    -0x1(%eax),%edi
  800399:	8b 45 18             	mov    0x18(%ebp),%eax
  80039c:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a1:	52                   	push   %edx
  8003a2:	50                   	push   %eax
  8003a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a9:	89 f3                	mov    %esi,%ebx
  8003ab:	e8 a0 0d 00 00       	call   801150 <__udivdi3>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	83 ec 04             	sub    $0x4,%esp
  8003b6:	ff 75 20             	pushl  0x20(%ebp)
  8003b9:	57                   	push   %edi
  8003ba:	ff 75 18             	pushl  0x18(%ebp)
  8003bd:	52                   	push   %edx
  8003be:	50                   	push   %eax
  8003bf:	ff 75 0c             	pushl  0xc(%ebp)
  8003c2:	ff 75 08             	pushl  0x8(%ebp)
  8003c5:	e8 93 ff ff ff       	call   80035d <printnum>
  8003ca:	83 c4 20             	add    $0x20,%esp
  8003cd:	eb 1b                	jmp    8003ea <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003cf:	83 ec 08             	sub    $0x8,%esp
  8003d2:	ff 75 0c             	pushl  0xc(%ebp)
  8003d5:	ff 75 20             	pushl  0x20(%ebp)
  8003d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003db:	ff d0                	call   *%eax
  8003dd:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003e0:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8003e4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003e8:	7f e5                	jg     8003cf <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ea:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003f8:	53                   	push   %ebx
  8003f9:	51                   	push   %ecx
  8003fa:	52                   	push   %edx
  8003fb:	50                   	push   %eax
  8003fc:	89 f3                	mov    %esi,%ebx
  8003fe:	e8 5d 0e 00 00       	call   801260 <__umoddi3>
  800403:	83 c4 10             	add    $0x10,%esp
  800406:	8d 8e 09 f5 ff ff    	lea    -0xaf7(%esi),%ecx
  80040c:	01 c8                	add    %ecx,%eax
  80040e:	0f b6 00             	movzbl (%eax),%eax
  800411:	0f be c0             	movsbl %al,%eax
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	ff 75 0c             	pushl  0xc(%ebp)
  80041a:	50                   	push   %eax
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	ff d0                	call   *%eax
  800420:	83 c4 10             	add    $0x10,%esp
}
  800423:	90                   	nop
  800424:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800427:	5b                   	pop    %ebx
  800428:	5e                   	pop    %esi
  800429:	5f                   	pop    %edi
  80042a:	5d                   	pop    %ebp
  80042b:	c3                   	ret    

0080042c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80042c:	f3 0f 1e fb          	endbr32 
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	e8 99 fd ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800438:	05 c8 1b 00 00       	add    $0x1bc8,%eax
	if (lflag >= 2)
  80043d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800441:	7e 14                	jle    800457 <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	8d 48 08             	lea    0x8(%eax),%ecx
  80044b:	8b 55 08             	mov    0x8(%ebp),%edx
  80044e:	89 0a                	mov    %ecx,(%edx)
  800450:	8b 50 04             	mov    0x4(%eax),%edx
  800453:	8b 00                	mov    (%eax),%eax
  800455:	eb 30                	jmp    800487 <getuint+0x5b>
	else if (lflag)
  800457:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80045b:	74 16                	je     800473 <getuint+0x47>
		return va_arg(*ap, unsigned long);
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	8d 48 04             	lea    0x4(%eax),%ecx
  800465:	8b 55 08             	mov    0x8(%ebp),%edx
  800468:	89 0a                	mov    %ecx,(%edx)
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	ba 00 00 00 00       	mov    $0x0,%edx
  800471:	eb 14                	jmp    800487 <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	8b 00                	mov    (%eax),%eax
  800478:	8d 48 04             	lea    0x4(%eax),%ecx
  80047b:	8b 55 08             	mov    0x8(%ebp),%edx
  80047e:	89 0a                	mov    %ecx,(%edx)
  800480:	8b 00                	mov    (%eax),%eax
  800482:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800487:	5d                   	pop    %ebp
  800488:	c3                   	ret    

00800489 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800489:	f3 0f 1e fb          	endbr32 
  80048d:	55                   	push   %ebp
  80048e:	89 e5                	mov    %esp,%ebp
  800490:	e8 3c fd ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800495:	05 6b 1b 00 00       	add    $0x1b6b,%eax
	if (lflag >= 2)
  80049a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80049e:	7e 14                	jle    8004b4 <getint+0x2b>
		return va_arg(*ap, long long);
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	8d 48 08             	lea    0x8(%eax),%ecx
  8004a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ab:	89 0a                	mov    %ecx,(%edx)
  8004ad:	8b 50 04             	mov    0x4(%eax),%edx
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	eb 28                	jmp    8004dc <getint+0x53>
	else if (lflag)
  8004b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b8:	74 12                	je     8004cc <getint+0x43>
		return va_arg(*ap, long);
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	8d 48 04             	lea    0x4(%eax),%ecx
  8004c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c5:	89 0a                	mov    %ecx,(%edx)
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	eb 10                	jmp    8004dc <getint+0x53>
	else
		return va_arg(*ap, int);
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	8d 48 04             	lea    0x4(%eax),%ecx
  8004d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d7:	89 0a                	mov    %ecx,(%edx)
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	99                   	cltd   
}
  8004dc:	5d                   	pop    %ebp
  8004dd:	c3                   	ret    

008004de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004de:	f3 0f 1e fb          	endbr32 
  8004e2:	55                   	push   %ebp
  8004e3:	89 e5                	mov    %esp,%ebp
  8004e5:	57                   	push   %edi
  8004e6:	56                   	push   %esi
  8004e7:	53                   	push   %ebx
  8004e8:	83 ec 2c             	sub    $0x2c,%esp
  8004eb:	e8 c6 04 00 00       	call   8009b6 <__x86.get_pc_thunk.di>
  8004f0:	81 c7 10 1b 00 00    	add    $0x1b10,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f6:	eb 17                	jmp    80050f <vprintfmt+0x31>
			if (ch == '\0')
  8004f8:	85 db                	test   %ebx,%ebx
  8004fa:	0f 84 96 03 00 00    	je     800896 <.L20+0x2d>
				return;
			putch(ch, putdat);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	53                   	push   %ebx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	ff d0                	call   *%eax
  80050c:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80050f:	8b 45 10             	mov    0x10(%ebp),%eax
  800512:	8d 50 01             	lea    0x1(%eax),%edx
  800515:	89 55 10             	mov    %edx,0x10(%ebp)
  800518:	0f b6 00             	movzbl (%eax),%eax
  80051b:	0f b6 d8             	movzbl %al,%ebx
  80051e:	83 fb 25             	cmp    $0x25,%ebx
  800521:	75 d5                	jne    8004f8 <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
  800523:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
  800527:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
  80052e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
  800535:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
  80053c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	8d 50 01             	lea    0x1(%eax),%edx
  800549:	89 55 10             	mov    %edx,0x10(%ebp)
  80054c:	0f b6 00             	movzbl (%eax),%eax
  80054f:	0f b6 d8             	movzbl %al,%ebx
  800552:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800555:	83 f8 55             	cmp    $0x55,%eax
  800558:	0f 87 0b 03 00 00    	ja     800869 <.L20>
  80055e:	c1 e0 02             	shl    $0x2,%eax
  800561:	8b 84 38 30 f5 ff ff 	mov    -0xad0(%eax,%edi,1),%eax
  800568:	01 f8                	add    %edi,%eax
  80056a:	3e ff e0             	notrack jmp *%eax

0080056d <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
  80056d:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
  800571:	eb d0                	jmp    800543 <vprintfmt+0x65>

00800573 <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800573:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
  800577:	eb ca                	jmp    800543 <vprintfmt+0x65>

00800579 <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800579:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
  800580:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800583:	89 d0                	mov    %edx,%eax
  800585:	c1 e0 02             	shl    $0x2,%eax
  800588:	01 d0                	add    %edx,%eax
  80058a:	01 c0                	add    %eax,%eax
  80058c:	01 d8                	add    %ebx,%eax
  80058e:	83 e8 30             	sub    $0x30,%eax
  800591:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
  800594:	8b 45 10             	mov    0x10(%ebp),%eax
  800597:	0f b6 00             	movzbl (%eax),%eax
  80059a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80059d:	83 fb 2f             	cmp    $0x2f,%ebx
  8005a0:	7e 39                	jle    8005db <.L37+0xc>
  8005a2:	83 fb 39             	cmp    $0x39,%ebx
  8005a5:	7f 34                	jg     8005db <.L37+0xc>
			for (precision = 0; ; ++fmt) {
  8005a7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
  8005ab:	eb d3                	jmp    800580 <.L31+0x7>

008005ad <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8d 50 04             	lea    0x4(%eax),%edx
  8005b3:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
  8005bb:	eb 1f                	jmp    8005dc <.L37+0xd>

008005bd <.L33>:

		case '.':
			if (width < 0)
  8005bd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c1:	79 80                	jns    800543 <vprintfmt+0x65>
				width = 0;
  8005c3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
  8005ca:	e9 74 ff ff ff       	jmp    800543 <vprintfmt+0x65>

008005cf <.L37>:

		case '#':
			altflag = 1;
  8005cf:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
  8005d6:	e9 68 ff ff ff       	jmp    800543 <vprintfmt+0x65>
			goto process_precision;
  8005db:	90                   	nop

		process_precision:
			if (width < 0)
  8005dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005e0:	0f 89 5d ff ff ff    	jns    800543 <vprintfmt+0x65>
				width = precision, precision = -1;
  8005e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005ec:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
  8005f3:	e9 4b ff ff ff       	jmp    800543 <vprintfmt+0x65>

008005f8 <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005f8:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005fc:	e9 42 ff ff ff       	jmp    800543 <vprintfmt+0x65>

00800601 <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8d 50 04             	lea    0x4(%eax),%edx
  800607:	89 55 14             	mov    %edx,0x14(%ebp)
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	ff 75 0c             	pushl  0xc(%ebp)
  800612:	50                   	push   %eax
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	ff d0                	call   *%eax
  800618:	83 c4 10             	add    $0x10,%esp
			break;
  80061b:	e9 71 02 00 00       	jmp    800891 <.L20+0x28>

00800620 <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	8d 50 04             	lea    0x4(%eax),%edx
  800626:	89 55 14             	mov    %edx,0x14(%ebp)
  800629:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80062b:	85 db                	test   %ebx,%ebx
  80062d:	79 02                	jns    800631 <.L28+0x11>
				err = -err;
  80062f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800631:	83 fb 06             	cmp    $0x6,%ebx
  800634:	7f 0b                	jg     800641 <.L28+0x21>
  800636:	8b b4 9f 10 00 00 00 	mov    0x10(%edi,%ebx,4),%esi
  80063d:	85 f6                	test   %esi,%esi
  80063f:	75 1b                	jne    80065c <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
  800641:	53                   	push   %ebx
  800642:	8d 87 1a f5 ff ff    	lea    -0xae6(%edi),%eax
  800648:	50                   	push   %eax
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	ff 75 08             	pushl  0x8(%ebp)
  80064f:	e8 4b 02 00 00       	call   80089f <printfmt>
  800654:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800657:	e9 35 02 00 00       	jmp    800891 <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
  80065c:	56                   	push   %esi
  80065d:	8d 87 23 f5 ff ff    	lea    -0xadd(%edi),%eax
  800663:	50                   	push   %eax
  800664:	ff 75 0c             	pushl  0xc(%ebp)
  800667:	ff 75 08             	pushl  0x8(%ebp)
  80066a:	e8 30 02 00 00       	call   80089f <printfmt>
  80066f:	83 c4 10             	add    $0x10,%esp
			break;
  800672:	e9 1a 02 00 00       	jmp    800891 <.L20+0x28>

00800677 <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8d 50 04             	lea    0x4(%eax),%edx
  80067d:	89 55 14             	mov    %edx,0x14(%ebp)
  800680:	8b 30                	mov    (%eax),%esi
  800682:	85 f6                	test   %esi,%esi
  800684:	75 06                	jne    80068c <.L24+0x15>
				p = "(null)";
  800686:	8d b7 26 f5 ff ff    	lea    -0xada(%edi),%esi
			if (width > 0 && padc != '-')
  80068c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800690:	7e 71                	jle    800703 <.L24+0x8c>
  800692:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  800696:	74 6b                	je     800703 <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800698:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	50                   	push   %eax
  80069f:	56                   	push   %esi
  8006a0:	89 fb                	mov    %edi,%ebx
  8006a2:	e8 47 03 00 00       	call   8009ee <strnlen>
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	29 45 d4             	sub    %eax,-0x2c(%ebp)
  8006ad:	eb 17                	jmp    8006c6 <.L24+0x4f>
					putch(padc, putdat);
  8006af:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	50                   	push   %eax
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	ff d0                	call   *%eax
  8006bf:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c2:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  8006c6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006ca:	7f e3                	jg     8006af <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006cc:	eb 35                	jmp    800703 <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8006d2:	74 1c                	je     8006f0 <.L24+0x79>
  8006d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8006d7:	7e 05                	jle    8006de <.L24+0x67>
  8006d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8006dc:	7e 12                	jle    8006f0 <.L24+0x79>
					putch('?', putdat);
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	ff 75 0c             	pushl  0xc(%ebp)
  8006e4:	6a 3f                	push   $0x3f
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	ff d0                	call   *%eax
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	eb 0f                	jmp    8006ff <.L24+0x88>
				else
					putch(ch, putdat);
  8006f0:	83 ec 08             	sub    $0x8,%esp
  8006f3:	ff 75 0c             	pushl  0xc(%ebp)
  8006f6:	53                   	push   %ebx
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	ff d0                	call   *%eax
  8006fc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ff:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800703:	89 f0                	mov    %esi,%eax
  800705:	8d 70 01             	lea    0x1(%eax),%esi
  800708:	0f b6 00             	movzbl (%eax),%eax
  80070b:	0f be d8             	movsbl %al,%ebx
  80070e:	85 db                	test   %ebx,%ebx
  800710:	74 26                	je     800738 <.L24+0xc1>
  800712:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800716:	78 b6                	js     8006ce <.L24+0x57>
  800718:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  80071c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800720:	79 ac                	jns    8006ce <.L24+0x57>
			for (; width > 0; width--)
  800722:	eb 14                	jmp    800738 <.L24+0xc1>
				putch(' ', putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 0c             	pushl  0xc(%ebp)
  80072a:	6a 20                	push   $0x20
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	ff d0                	call   *%eax
  800731:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
  800734:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800738:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80073c:	7f e6                	jg     800724 <.L24+0xad>
			break;
  80073e:	e9 4e 01 00 00       	jmp    800891 <.L20+0x28>

00800743 <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 d8             	pushl  -0x28(%ebp)
  800749:	8d 45 14             	lea    0x14(%ebp),%eax
  80074c:	50                   	push   %eax
  80074d:	e8 37 fd ff ff       	call   800489 <getint>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800758:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
  80075b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800761:	85 d2                	test   %edx,%edx
  800763:	79 23                	jns    800788 <.L29+0x45>
				putch('-', putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	6a 2d                	push   $0x2d
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	ff d0                	call   *%eax
  800772:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800775:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800778:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80077b:	f7 d8                	neg    %eax
  80077d:	83 d2 00             	adc    $0x0,%edx
  800780:	f7 da                	neg    %edx
  800782:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800785:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
  800788:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  80078f:	e9 9f 00 00 00       	jmp    800833 <.L21+0x1f>

00800794 <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	ff 75 d8             	pushl  -0x28(%ebp)
  80079a:	8d 45 14             	lea    0x14(%ebp),%eax
  80079d:	50                   	push   %eax
  80079e:	e8 89 fc ff ff       	call   80042c <getuint>
  8007a3:	83 c4 10             	add    $0x10,%esp
  8007a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
  8007ac:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007b3:	eb 7e                	jmp    800833 <.L21+0x1f>

008007b5 <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8007bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8007be:	50                   	push   %eax
  8007bf:	e8 68 fc ff ff       	call   80042c <getuint>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007ca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
  8007cd:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
  8007d4:	eb 5d                	jmp    800833 <.L21+0x1f>

008007d6 <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	6a 30                	push   $0x30
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	ff d0                	call   *%eax
  8007e3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ec:	6a 78                	push   $0x78
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	ff d0                	call   *%eax
  8007f3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8d 50 04             	lea    0x4(%eax),%edx
  8007fc:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ff:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
  800801:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800804:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
  80080b:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
  800812:	eb 1f                	jmp    800833 <.L21+0x1f>

00800814 <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 d8             	pushl  -0x28(%ebp)
  80081a:	8d 45 14             	lea    0x14(%ebp),%eax
  80081d:	50                   	push   %eax
  80081e:	e8 09 fc ff ff       	call   80042c <getuint>
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800829:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
  80082c:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800833:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  800837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	52                   	push   %edx
  80083e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800841:	50                   	push   %eax
  800842:	ff 75 e4             	pushl  -0x1c(%ebp)
  800845:	ff 75 e0             	pushl  -0x20(%ebp)
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	ff 75 08             	pushl  0x8(%ebp)
  80084e:	e8 0a fb ff ff       	call   80035d <printnum>
  800853:	83 c4 20             	add    $0x20,%esp
			break;
  800856:	eb 39                	jmp    800891 <.L20+0x28>

00800858 <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	ff 75 0c             	pushl  0xc(%ebp)
  80085e:	53                   	push   %ebx
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	ff d0                	call   *%eax
  800864:	83 c4 10             	add    $0x10,%esp
			break;
  800867:	eb 28                	jmp    800891 <.L20+0x28>

00800869 <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	6a 25                	push   $0x25
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800879:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  80087d:	eb 04                	jmp    800883 <.L20+0x1a>
  80087f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800883:	8b 45 10             	mov    0x10(%ebp),%eax
  800886:	83 e8 01             	sub    $0x1,%eax
  800889:	0f b6 00             	movzbl (%eax),%eax
  80088c:	3c 25                	cmp    $0x25,%al
  80088e:	75 ef                	jne    80087f <.L20+0x16>
				/* do nothing */;
			break;
  800890:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800891:	e9 79 fc ff ff       	jmp    80050f <vprintfmt+0x31>
				return;
  800896:	90                   	nop
		}
	}
}
  800897:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80089a:	5b                   	pop    %ebx
  80089b:	5e                   	pop    %esi
  80089c:	5f                   	pop    %edi
  80089d:	5d                   	pop    %ebp
  80089e:	c3                   	ret    

0080089f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80089f:	f3 0f 1e fb          	endbr32 
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	83 ec 18             	sub    $0x18,%esp
  8008a9:	e8 23 f9 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  8008ae:	05 52 17 00 00       	add    $0x1752,%eax
	va_list ap;

	va_start(ap, fmt);
  8008b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008bc:	50                   	push   %eax
  8008bd:	ff 75 10             	pushl  0x10(%ebp)
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	ff 75 08             	pushl  0x8(%ebp)
  8008c6:	e8 13 fc ff ff       	call   8004de <vprintfmt>
  8008cb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008ce:	90                   	nop
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    

008008d1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008d1:	f3 0f 1e fb          	endbr32 
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	e8 f4 f8 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  8008dd:	05 23 17 00 00       	add    $0x1723,%eax
	b->cnt++;
  8008e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e5:	8b 40 08             	mov    0x8(%eax),%eax
  8008e8:	8d 50 01             	lea    0x1(%eax),%edx
  8008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ee:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f4:	8b 10                	mov    (%eax),%edx
  8008f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f9:	8b 40 04             	mov    0x4(%eax),%eax
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	73 12                	jae    800912 <sprintputch+0x41>
		*b->buf++ = ch;
  800900:	8b 45 0c             	mov    0xc(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	8d 48 01             	lea    0x1(%eax),%ecx
  800908:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090b:	89 0a                	mov    %ecx,(%edx)
  80090d:	8b 55 08             	mov    0x8(%ebp),%edx
  800910:	88 10                	mov    %dl,(%eax)
}
  800912:	90                   	nop
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800915:	f3 0f 1e fb          	endbr32 
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	83 ec 18             	sub    $0x18,%esp
  80091f:	e8 ad f8 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800924:	05 dc 16 00 00       	add    $0x16dc,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
  800929:	8b 55 08             	mov    0x8(%ebp),%edx
  80092c:	89 55 ec             	mov    %edx,-0x14(%ebp)
  80092f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800932:	8d 4a ff             	lea    -0x1(%edx),%ecx
  800935:	8b 55 08             	mov    0x8(%ebp),%edx
  800938:	01 ca                	add    %ecx,%edx
  80093a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80093d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800944:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800948:	74 06                	je     800950 <vsnprintf+0x3b>
  80094a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094e:	7f 07                	jg     800957 <vsnprintf+0x42>
		return -E_INVAL;
  800950:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800955:	eb 22                	jmp    800979 <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800957:	ff 75 14             	pushl  0x14(%ebp)
  80095a:	ff 75 10             	pushl  0x10(%ebp)
  80095d:	8d 55 ec             	lea    -0x14(%ebp),%edx
  800960:	52                   	push   %edx
  800961:	8d 80 d1 e8 ff ff    	lea    -0x172f(%eax),%eax
  800967:	50                   	push   %eax
  800968:	e8 71 fb ff ff       	call   8004de <vprintfmt>
  80096d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800970:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800973:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800976:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80097b:	f3 0f 1e fb          	endbr32 
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	83 ec 18             	sub    $0x18,%esp
  800985:	e8 47 f8 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  80098a:	05 76 16 00 00       	add    $0x1676,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80098f:	8d 45 14             	lea    0x14(%ebp),%eax
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	ff 75 10             	pushl  0x10(%ebp)
  80099c:	ff 75 0c             	pushl  0xc(%ebp)
  80099f:	ff 75 08             	pushl  0x8(%ebp)
  8009a2:	e8 6e ff ff ff       	call   800915 <vsnprintf>
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
  8009ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009b0:	c9                   	leave  
  8009b1:	c3                   	ret    

008009b2 <__x86.get_pc_thunk.si>:
  8009b2:	8b 34 24             	mov    (%esp),%esi
  8009b5:	c3                   	ret    

008009b6 <__x86.get_pc_thunk.di>:
  8009b6:	8b 3c 24             	mov    (%esp),%edi
  8009b9:	c3                   	ret    

008009ba <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ba:	f3 0f 1e fb          	endbr32 
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	83 ec 10             	sub    $0x10,%esp
  8009c4:	e8 08 f8 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  8009c9:	05 37 16 00 00       	add    $0x1637,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d5:	eb 08                	jmp    8009df <strlen+0x25>
		n++;
  8009d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
  8009db:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	0f b6 00             	movzbl (%eax),%eax
  8009e5:	84 c0                	test   %al,%al
  8009e7:	75 ee                	jne    8009d7 <strlen+0x1d>
	return n;
  8009e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    

008009ee <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009ee:	f3 0f 1e fb          	endbr32 
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	83 ec 10             	sub    $0x10,%esp
  8009f8:	e8 d4 f7 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  8009fd:	05 03 16 00 00       	add    $0x1603,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a09:	eb 0c                	jmp    800a17 <strnlen+0x29>
		n++;
  800a0b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a13:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800a17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a1b:	74 0a                	je     800a27 <strnlen+0x39>
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	0f b6 00             	movzbl (%eax),%eax
  800a23:	84 c0                	test   %al,%al
  800a25:	75 e4                	jne    800a0b <strnlen+0x1d>
	return n;
  800a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2c:	f3 0f 1e fb          	endbr32 
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	83 ec 10             	sub    $0x10,%esp
  800a36:	e8 96 f7 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800a3b:	05 c5 15 00 00       	add    $0x15c5,%eax
	char *ret;

	ret = dst;
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a46:	90                   	nop
  800a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4a:	8d 42 01             	lea    0x1(%edx),%eax
  800a4d:	89 45 0c             	mov    %eax,0xc(%ebp)
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	8d 48 01             	lea    0x1(%eax),%ecx
  800a56:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800a59:	0f b6 12             	movzbl (%edx),%edx
  800a5c:	88 10                	mov    %dl,(%eax)
  800a5e:	0f b6 00             	movzbl (%eax),%eax
  800a61:	84 c0                	test   %al,%al
  800a63:	75 e2                	jne    800a47 <strcpy+0x1b>
		/* do nothing */;
	return ret;
  800a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a6a:	f3 0f 1e fb          	endbr32 
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	83 ec 10             	sub    $0x10,%esp
  800a74:	e8 58 f7 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800a79:	05 87 15 00 00       	add    $0x1587,%eax
	int len = strlen(dst);
  800a7e:	ff 75 08             	pushl  0x8(%ebp)
  800a81:	e8 34 ff ff ff       	call   8009ba <strlen>
  800a86:	83 c4 04             	add    $0x4,%esp
  800a89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
  800a8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	01 d0                	add    %edx,%eax
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	50                   	push   %eax
  800a98:	e8 8f ff ff ff       	call   800a2c <strcpy>
  800a9d:	83 c4 08             	add    $0x8,%esp
	return dst;
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800aa3:	c9                   	leave  
  800aa4:	c3                   	ret    

00800aa5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aa5:	f3 0f 1e fb          	endbr32 
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	83 ec 10             	sub    $0x10,%esp
  800aaf:	e8 1d f7 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800ab4:	05 4c 15 00 00       	add    $0x154c,%eax
	size_t i;
	char *ret;

	ret = dst;
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800abf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ac6:	eb 23                	jmp    800aeb <strncpy+0x46>
		*dst++ = *src;
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	8d 50 01             	lea    0x1(%eax),%edx
  800ace:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad4:	0f b6 12             	movzbl (%edx),%edx
  800ad7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	0f b6 00             	movzbl (%eax),%eax
  800adf:	84 c0                	test   %al,%al
  800ae1:	74 04                	je     800ae7 <strncpy+0x42>
			src++;
  800ae3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
  800ae7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aee:	3b 45 10             	cmp    0x10(%ebp),%eax
  800af1:	72 d5                	jb     800ac8 <strncpy+0x23>
	}
	return ret;
  800af3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800af6:	c9                   	leave  
  800af7:	c3                   	ret    

00800af8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800af8:	f3 0f 1e fb          	endbr32 
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 10             	sub    $0x10,%esp
  800b02:	e8 ca f6 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800b07:	05 f9 14 00 00       	add    $0x14f9,%eax
	char *dst_in;

	dst_in = dst;
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b16:	74 33                	je     800b4b <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
  800b18:	eb 17                	jmp    800b31 <strlcpy+0x39>
			*dst++ = *src++;
  800b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1d:	8d 42 01             	lea    0x1(%edx),%eax
  800b20:	89 45 0c             	mov    %eax,0xc(%ebp)
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8d 48 01             	lea    0x1(%eax),%ecx
  800b29:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800b2c:	0f b6 12             	movzbl (%edx),%edx
  800b2f:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
  800b31:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b39:	74 0a                	je     800b45 <strlcpy+0x4d>
  800b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3e:	0f b6 00             	movzbl (%eax),%eax
  800b41:	84 c0                	test   %al,%al
  800b43:	75 d5                	jne    800b1a <strlcpy+0x22>
		*dst = '\0';
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b53:	f3 0f 1e fb          	endbr32 
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	e8 72 f6 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800b5f:	05 a1 14 00 00       	add    $0x14a1,%eax
	while (*p && *p == *q)
  800b64:	eb 08                	jmp    800b6e <strcmp+0x1b>
		p++, q++;
  800b66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b6a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	0f b6 00             	movzbl (%eax),%eax
  800b74:	84 c0                	test   %al,%al
  800b76:	74 10                	je     800b88 <strcmp+0x35>
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	0f b6 10             	movzbl (%eax),%edx
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	0f b6 00             	movzbl (%eax),%eax
  800b84:	38 c2                	cmp    %al,%dl
  800b86:	74 de                	je     800b66 <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	0f b6 00             	movzbl (%eax),%eax
  800b8e:	0f b6 d0             	movzbl %al,%edx
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	0f b6 00             	movzbl (%eax),%eax
  800b97:	0f b6 c0             	movzbl %al,%eax
  800b9a:	29 c2                	sub    %eax,%edx
  800b9c:	89 d0                	mov    %edx,%eax
}
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ba0:	f3 0f 1e fb          	endbr32 
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	e8 25 f6 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800bac:	05 54 14 00 00       	add    $0x1454,%eax
	while (n > 0 && *p && *p == *q)
  800bb1:	eb 0c                	jmp    800bbf <strncmp+0x1f>
		n--, p++, q++;
  800bb3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800bb7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bbb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
  800bbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc3:	74 1a                	je     800bdf <strncmp+0x3f>
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	0f b6 00             	movzbl (%eax),%eax
  800bcb:	84 c0                	test   %al,%al
  800bcd:	74 10                	je     800bdf <strncmp+0x3f>
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	0f b6 10             	movzbl (%eax),%edx
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	0f b6 00             	movzbl (%eax),%eax
  800bdb:	38 c2                	cmp    %al,%dl
  800bdd:	74 d4                	je     800bb3 <strncmp+0x13>
	if (n == 0)
  800bdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be3:	75 07                	jne    800bec <strncmp+0x4c>
		return 0;
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bea:	eb 16                	jmp    800c02 <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	0f b6 00             	movzbl (%eax),%eax
  800bf2:	0f b6 d0             	movzbl %al,%edx
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	0f b6 00             	movzbl (%eax),%eax
  800bfb:	0f b6 c0             	movzbl %al,%eax
  800bfe:	29 c2                	sub    %eax,%edx
  800c00:	89 d0                	mov    %edx,%eax
}
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c04:	f3 0f 1e fb          	endbr32 
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	83 ec 04             	sub    $0x4,%esp
  800c0e:	e8 be f5 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800c13:	05 ed 13 00 00       	add    $0x13ed,%eax
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c1e:	eb 14                	jmp    800c34 <strchr+0x30>
		if (*s == c)
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	0f b6 00             	movzbl (%eax),%eax
  800c26:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800c29:	75 05                	jne    800c30 <strchr+0x2c>
			return (char *) s;
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	eb 13                	jmp    800c43 <strchr+0x3f>
	for (; *s; s++)
  800c30:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	0f b6 00             	movzbl (%eax),%eax
  800c3a:	84 c0                	test   %al,%al
  800c3c:	75 e2                	jne    800c20 <strchr+0x1c>
	return 0;
  800c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c43:	c9                   	leave  
  800c44:	c3                   	ret    

00800c45 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c45:	f3 0f 1e fb          	endbr32 
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 04             	sub    $0x4,%esp
  800c4f:	e8 7d f5 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800c54:	05 ac 13 00 00       	add    $0x13ac,%eax
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c5f:	eb 0f                	jmp    800c70 <strfind+0x2b>
		if (*s == c)
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	0f b6 00             	movzbl (%eax),%eax
  800c67:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800c6a:	74 10                	je     800c7c <strfind+0x37>
	for (; *s; s++)
  800c6c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	0f b6 00             	movzbl (%eax),%eax
  800c76:	84 c0                	test   %al,%al
  800c78:	75 e7                	jne    800c61 <strfind+0x1c>
  800c7a:	eb 01                	jmp    800c7d <strfind+0x38>
			break;
  800c7c:	90                   	nop
	return (char *) s;
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    

00800c82 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c82:	f3 0f 1e fb          	endbr32 
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	e8 42 f5 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800c8f:	05 71 13 00 00       	add    $0x1371,%eax
	char *p;

	if (n == 0)
  800c94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c98:	75 05                	jne    800c9f <memset+0x1d>
		return v;
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	eb 5c                	jmp    800cfb <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	83 e0 03             	and    $0x3,%eax
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	75 41                	jne    800cea <memset+0x68>
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	83 e0 03             	and    $0x3,%eax
  800caf:	85 c0                	test   %eax,%eax
  800cb1:	75 37                	jne    800cea <memset+0x68>
		c &= 0xFF;
  800cb3:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbd:	c1 e0 18             	shl    $0x18,%eax
  800cc0:	89 c2                	mov    %eax,%edx
  800cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc5:	c1 e0 10             	shl    $0x10,%eax
  800cc8:	09 c2                	or     %eax,%edx
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	c1 e0 08             	shl    $0x8,%eax
  800cd0:	09 d0                	or     %edx,%eax
  800cd2:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd8:	c1 e8 02             	shr    $0x2,%eax
  800cdb:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
  800cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	89 d7                	mov    %edx,%edi
  800ce5:	fc                   	cld    
  800ce6:	f3 ab                	rep stos %eax,%es:(%edi)
  800ce8:	eb 0e                	jmp    800cf8 <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800cf3:	89 d7                	mov    %edx,%edi
  800cf5:	fc                   	cld    
  800cf6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cfe:	f3 0f 1e fb          	endbr32 
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	83 ec 10             	sub    $0x10,%esp
  800d0b:	e8 c1 f4 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800d10:	05 f0 12 00 00       	add    $0x12f0,%eax
	const char *s;
	char *d;

	s = src;
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
  800d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d27:	73 6d                	jae    800d96 <memmove+0x98>
  800d29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2f:	01 d0                	add    %edx,%eax
  800d31:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  800d34:	73 60                	jae    800d96 <memmove+0x98>
		s += n;
  800d36:	8b 45 10             	mov    0x10(%ebp),%eax
  800d39:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d45:	83 e0 03             	and    $0x3,%eax
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	75 2f                	jne    800d7b <memmove+0x7d>
  800d4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d4f:	83 e0 03             	and    $0x3,%eax
  800d52:	85 c0                	test   %eax,%eax
  800d54:	75 25                	jne    800d7b <memmove+0x7d>
  800d56:	8b 45 10             	mov    0x10(%ebp),%eax
  800d59:	83 e0 03             	and    $0x3,%eax
  800d5c:	85 c0                	test   %eax,%eax
  800d5e:	75 1b                	jne    800d7b <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d63:	83 e8 04             	sub    $0x4,%eax
  800d66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d69:	83 ea 04             	sub    $0x4,%edx
  800d6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d6f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d72:	89 c7                	mov    %eax,%edi
  800d74:	89 d6                	mov    %edx,%esi
  800d76:	fd                   	std    
  800d77:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d79:	eb 18                	jmp    800d93 <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d84:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
  800d87:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8a:	89 d7                	mov    %edx,%edi
  800d8c:	89 de                	mov    %ebx,%esi
  800d8e:	89 c1                	mov    %eax,%ecx
  800d90:	fd                   	std    
  800d91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d93:	fc                   	cld    
  800d94:	eb 45                	jmp    800ddb <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d99:	83 e0 03             	and    $0x3,%eax
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	75 2b                	jne    800dcb <memmove+0xcd>
  800da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da3:	83 e0 03             	and    $0x3,%eax
  800da6:	85 c0                	test   %eax,%eax
  800da8:	75 21                	jne    800dcb <memmove+0xcd>
  800daa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dad:	83 e0 03             	and    $0x3,%eax
  800db0:	85 c0                	test   %eax,%eax
  800db2:	75 17                	jne    800dcb <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800db4:	8b 45 10             	mov    0x10(%ebp),%eax
  800db7:	c1 e8 02             	shr    $0x2,%eax
  800dba:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
  800dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800dc2:	89 c7                	mov    %eax,%edi
  800dc4:	89 d6                	mov    %edx,%esi
  800dc6:	fc                   	cld    
  800dc7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dc9:	eb 10                	jmp    800ddb <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
  800dcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800dd1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800dd4:	89 c7                	mov    %eax,%edi
  800dd6:	89 d6                	mov    %edx,%esi
  800dd8:	fc                   	cld    
  800dd9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800de6:	f3 0f 1e fb          	endbr32 
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	e8 df f3 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800df2:	05 0e 12 00 00       	add    $0x120e,%eax
	return memmove(dst, src, n);
  800df7:	ff 75 10             	pushl  0x10(%ebp)
  800dfa:	ff 75 0c             	pushl  0xc(%ebp)
  800dfd:	ff 75 08             	pushl  0x8(%ebp)
  800e00:	e8 f9 fe ff ff       	call   800cfe <memmove>
  800e05:	83 c4 0c             	add    $0xc,%esp
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e0a:	f3 0f 1e fb          	endbr32 
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
  800e14:	e8 b8 f3 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800e19:	05 e7 11 00 00       	add    $0x11e7,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e2a:	eb 30                	jmp    800e5c <memcmp+0x52>
		if (*s1 != *s2)
  800e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2f:	0f b6 10             	movzbl (%eax),%edx
  800e32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e35:	0f b6 00             	movzbl (%eax),%eax
  800e38:	38 c2                	cmp    %al,%dl
  800e3a:	74 18                	je     800e54 <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
  800e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3f:	0f b6 00             	movzbl (%eax),%eax
  800e42:	0f b6 d0             	movzbl %al,%edx
  800e45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e48:	0f b6 00             	movzbl (%eax),%eax
  800e4b:	0f b6 c0             	movzbl %al,%eax
  800e4e:	29 c2                	sub    %eax,%edx
  800e50:	89 d0                	mov    %edx,%eax
  800e52:	eb 1a                	jmp    800e6e <memcmp+0x64>
		s1++, s2++;
  800e54:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800e58:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
  800e5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e62:	89 55 10             	mov    %edx,0x10(%ebp)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	75 c3                	jne    800e2c <memcmp+0x22>
	}

	return 0;
  800e69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e70:	f3 0f 1e fb          	endbr32 
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	83 ec 10             	sub    $0x10,%esp
  800e7a:	e8 52 f3 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800e7f:	05 81 11 00 00       	add    $0x1181,%eax
	const void *ends = (const char *) s + n;
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	01 d0                	add    %edx,%eax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e8f:	eb 11                	jmp    800ea2 <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	0f b6 00             	movzbl (%eax),%eax
  800e97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9a:	38 d0                	cmp    %dl,%al
  800e9c:	74 0e                	je     800eac <memfind+0x3c>
	for (; s < ends; s++)
  800e9e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ea8:	72 e7                	jb     800e91 <memfind+0x21>
  800eaa:	eb 01                	jmp    800ead <memfind+0x3d>
			break;
  800eac:	90                   	nop
	return (void *) s;
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb0:	c9                   	leave  
  800eb1:	c3                   	ret    

00800eb2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eb2:	f3 0f 1e fb          	endbr32 
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
  800ebc:	e8 10 f3 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  800ec1:	05 3f 11 00 00       	add    $0x113f,%eax
	int neg = 0;
  800ec6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ecd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed4:	eb 04                	jmp    800eda <strtol+0x28>
		s++;
  800ed6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	0f b6 00             	movzbl (%eax),%eax
  800ee0:	3c 20                	cmp    $0x20,%al
  800ee2:	74 f2                	je     800ed6 <strtol+0x24>
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	0f b6 00             	movzbl (%eax),%eax
  800eea:	3c 09                	cmp    $0x9,%al
  800eec:	74 e8                	je     800ed6 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	0f b6 00             	movzbl (%eax),%eax
  800ef4:	3c 2b                	cmp    $0x2b,%al
  800ef6:	75 06                	jne    800efe <strtol+0x4c>
		s++;
  800ef8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800efc:	eb 15                	jmp    800f13 <strtol+0x61>
	else if (*s == '-')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	0f b6 00             	movzbl (%eax),%eax
  800f04:	3c 2d                	cmp    $0x2d,%al
  800f06:	75 0b                	jne    800f13 <strtol+0x61>
		s++, neg = 1;
  800f08:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f0c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 06                	je     800f1f <strtol+0x6d>
  800f19:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f1d:	75 24                	jne    800f43 <strtol+0x91>
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	0f b6 00             	movzbl (%eax),%eax
  800f25:	3c 30                	cmp    $0x30,%al
  800f27:	75 1a                	jne    800f43 <strtol+0x91>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	83 c0 01             	add    $0x1,%eax
  800f2f:	0f b6 00             	movzbl (%eax),%eax
  800f32:	3c 78                	cmp    $0x78,%al
  800f34:	75 0d                	jne    800f43 <strtol+0x91>
		s += 2, base = 16;
  800f36:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f3a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f41:	eb 2a                	jmp    800f6d <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	75 17                	jne    800f60 <strtol+0xae>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	0f b6 00             	movzbl (%eax),%eax
  800f4f:	3c 30                	cmp    $0x30,%al
  800f51:	75 0d                	jne    800f60 <strtol+0xae>
		s++, base = 8;
  800f53:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f57:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f5e:	eb 0d                	jmp    800f6d <strtol+0xbb>
	else if (base == 0)
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	75 07                	jne    800f6d <strtol+0xbb>
		base = 10;
  800f66:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	0f b6 00             	movzbl (%eax),%eax
  800f73:	3c 2f                	cmp    $0x2f,%al
  800f75:	7e 1b                	jle    800f92 <strtol+0xe0>
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	0f b6 00             	movzbl (%eax),%eax
  800f7d:	3c 39                	cmp    $0x39,%al
  800f7f:	7f 11                	jg     800f92 <strtol+0xe0>
			dig = *s - '0';
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	0f b6 00             	movzbl (%eax),%eax
  800f87:	0f be c0             	movsbl %al,%eax
  800f8a:	83 e8 30             	sub    $0x30,%eax
  800f8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f90:	eb 48                	jmp    800fda <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	0f b6 00             	movzbl (%eax),%eax
  800f98:	3c 60                	cmp    $0x60,%al
  800f9a:	7e 1b                	jle    800fb7 <strtol+0x105>
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	0f b6 00             	movzbl (%eax),%eax
  800fa2:	3c 7a                	cmp    $0x7a,%al
  800fa4:	7f 11                	jg     800fb7 <strtol+0x105>
			dig = *s - 'a' + 10;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	0f b6 00             	movzbl (%eax),%eax
  800fac:	0f be c0             	movsbl %al,%eax
  800faf:	83 e8 57             	sub    $0x57,%eax
  800fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb5:	eb 23                	jmp    800fda <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	0f b6 00             	movzbl (%eax),%eax
  800fbd:	3c 40                	cmp    $0x40,%al
  800fbf:	7e 3c                	jle    800ffd <strtol+0x14b>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	0f b6 00             	movzbl (%eax),%eax
  800fc7:	3c 5a                	cmp    $0x5a,%al
  800fc9:	7f 32                	jg     800ffd <strtol+0x14b>
			dig = *s - 'A' + 10;
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	0f b6 00             	movzbl (%eax),%eax
  800fd1:	0f be c0             	movsbl %al,%eax
  800fd4:	83 e8 37             	sub    $0x37,%eax
  800fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fdd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fe0:	7d 1a                	jge    800ffc <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
  800fe2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fe6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fed:	89 c2                	mov    %eax,%edx
  800fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff2:	01 d0                	add    %edx,%eax
  800ff4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
  800ff7:	e9 71 ff ff ff       	jmp    800f6d <strtol+0xbb>
			break;
  800ffc:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
  800ffd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801001:	74 08                	je     80100b <strtol+0x159>
		*endptr = (char *) s;
  801003:	8b 45 0c             	mov    0xc(%ebp),%eax
  801006:	8b 55 08             	mov    0x8(%ebp),%edx
  801009:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80100b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80100f:	74 07                	je     801018 <strtol+0x166>
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801014:	f7 d8                	neg    %eax
  801016:	eb 03                	jmp    80101b <strtol+0x169>
  801018:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80101b:	c9                   	leave  
  80101c:	c3                   	ret    

0080101d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	57                   	push   %edi
  801021:	56                   	push   %esi
  801022:	53                   	push   %ebx
  801023:	83 ec 2c             	sub    $0x2c,%esp
  801026:	e8 0e f1 ff ff       	call   800139 <__x86.get_pc_thunk.bx>
  80102b:	81 c3 d5 0f 00 00    	add    $0xfd5,%ebx
  801031:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	8b 55 10             	mov    0x10(%ebp),%edx
  80103a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80103d:	8b 5d 18             	mov    0x18(%ebp),%ebx
  801040:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  801043:	8b 75 20             	mov    0x20(%ebp),%esi
  801046:	cd 30                	int    $0x30
  801048:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80104b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104f:	74 27                	je     801078 <syscall+0x5b>
  801051:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801055:	7e 21                	jle    801078 <syscall+0x5b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801057:	83 ec 0c             	sub    $0xc,%esp
  80105a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80105d:	ff 75 08             	pushl  0x8(%ebp)
  801060:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801063:	8d 83 88 f6 ff ff    	lea    -0x978(%ebx),%eax
  801069:	50                   	push   %eax
  80106a:	6a 23                	push   $0x23
  80106c:	8d 83 a5 f6 ff ff    	lea    -0x95b(%ebx),%eax
  801072:	50                   	push   %eax
  801073:	e8 5d f1 ff ff       	call   8001d5 <_panic>

	return ret;
  801078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80107b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5f                   	pop    %edi
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801083:	f3 0f 1e fb          	endbr32 
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 08             	sub    $0x8,%esp
  80108d:	e8 3f f1 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  801092:	05 6e 0f 00 00       	add    $0xf6e,%eax
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	83 ec 04             	sub    $0x4,%esp
  80109d:	6a 00                	push   $0x0
  80109f:	6a 00                	push   $0x0
  8010a1:	6a 00                	push   $0x0
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	50                   	push   %eax
  8010a7:	6a 00                	push   $0x0
  8010a9:	6a 00                	push   $0x0
  8010ab:	e8 6d ff ff ff       	call   80101d <syscall>
  8010b0:	83 c4 20             	add    $0x20,%esp
}
  8010b3:	90                   	nop
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010b6:	f3 0f 1e fb          	endbr32 
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	e8 0c f1 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  8010c5:	05 3b 0f 00 00       	add    $0xf3b,%eax
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8010ca:	83 ec 04             	sub    $0x4,%esp
  8010cd:	6a 00                	push   $0x0
  8010cf:	6a 00                	push   $0x0
  8010d1:	6a 00                	push   $0x0
  8010d3:	6a 00                	push   $0x0
  8010d5:	6a 00                	push   $0x0
  8010d7:	6a 00                	push   $0x0
  8010d9:	6a 01                	push   $0x1
  8010db:	e8 3d ff ff ff       	call   80101d <syscall>
  8010e0:	83 c4 20             	add    $0x20,%esp
}
  8010e3:	c9                   	leave  
  8010e4:	c3                   	ret    

008010e5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010e5:	f3 0f 1e fb          	endbr32 
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	e8 dd f0 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  8010f4:	05 0c 0f 00 00       	add    $0xf0c,%eax
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	83 ec 04             	sub    $0x4,%esp
  8010ff:	6a 00                	push   $0x0
  801101:	6a 00                	push   $0x0
  801103:	6a 00                	push   $0x0
  801105:	6a 00                	push   $0x0
  801107:	50                   	push   %eax
  801108:	6a 01                	push   $0x1
  80110a:	6a 03                	push   $0x3
  80110c:	e8 0c ff ff ff       	call   80101d <syscall>
  801111:	83 c4 20             	add    $0x20,%esp
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801116:	f3 0f 1e fb          	endbr32 
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	83 ec 08             	sub    $0x8,%esp
  801120:	e8 ac f0 ff ff       	call   8001d1 <__x86.get_pc_thunk.ax>
  801125:	05 db 0e 00 00       	add    $0xedb,%eax
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80112a:	83 ec 04             	sub    $0x4,%esp
  80112d:	6a 00                	push   $0x0
  80112f:	6a 00                	push   $0x0
  801131:	6a 00                	push   $0x0
  801133:	6a 00                	push   $0x0
  801135:	6a 00                	push   $0x0
  801137:	6a 00                	push   $0x0
  801139:	6a 02                	push   $0x2
  80113b:	e8 dd fe ff ff       	call   80101d <syscall>
  801140:	83 c4 20             	add    $0x20,%esp
}
  801143:	c9                   	leave  
  801144:	c3                   	ret    
  801145:	66 90                	xchg   %ax,%ax
  801147:	66 90                	xchg   %ax,%ax
  801149:	66 90                	xchg   %ax,%ax
  80114b:	66 90                	xchg   %ax,%ax
  80114d:	66 90                	xchg   %ax,%ax
  80114f:	90                   	nop

00801150 <__udivdi3>:
  801150:	f3 0f 1e fb          	endbr32 
  801154:	55                   	push   %ebp
  801155:	57                   	push   %edi
  801156:	56                   	push   %esi
  801157:	53                   	push   %ebx
  801158:	83 ec 1c             	sub    $0x1c,%esp
  80115b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80115f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801163:	8b 74 24 34          	mov    0x34(%esp),%esi
  801167:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80116b:	85 d2                	test   %edx,%edx
  80116d:	75 19                	jne    801188 <__udivdi3+0x38>
  80116f:	39 f3                	cmp    %esi,%ebx
  801171:	76 4d                	jbe    8011c0 <__udivdi3+0x70>
  801173:	31 ff                	xor    %edi,%edi
  801175:	89 e8                	mov    %ebp,%eax
  801177:	89 f2                	mov    %esi,%edx
  801179:	f7 f3                	div    %ebx
  80117b:	89 fa                	mov    %edi,%edx
  80117d:	83 c4 1c             	add    $0x1c,%esp
  801180:	5b                   	pop    %ebx
  801181:	5e                   	pop    %esi
  801182:	5f                   	pop    %edi
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    
  801185:	8d 76 00             	lea    0x0(%esi),%esi
  801188:	39 f2                	cmp    %esi,%edx
  80118a:	76 14                	jbe    8011a0 <__udivdi3+0x50>
  80118c:	31 ff                	xor    %edi,%edi
  80118e:	31 c0                	xor    %eax,%eax
  801190:	89 fa                	mov    %edi,%edx
  801192:	83 c4 1c             	add    $0x1c,%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    
  80119a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011a0:	0f bd fa             	bsr    %edx,%edi
  8011a3:	83 f7 1f             	xor    $0x1f,%edi
  8011a6:	75 48                	jne    8011f0 <__udivdi3+0xa0>
  8011a8:	39 f2                	cmp    %esi,%edx
  8011aa:	72 06                	jb     8011b2 <__udivdi3+0x62>
  8011ac:	31 c0                	xor    %eax,%eax
  8011ae:	39 eb                	cmp    %ebp,%ebx
  8011b0:	77 de                	ja     801190 <__udivdi3+0x40>
  8011b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8011b7:	eb d7                	jmp    801190 <__udivdi3+0x40>
  8011b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011c0:	89 d9                	mov    %ebx,%ecx
  8011c2:	85 db                	test   %ebx,%ebx
  8011c4:	75 0b                	jne    8011d1 <__udivdi3+0x81>
  8011c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8011cb:	31 d2                	xor    %edx,%edx
  8011cd:	f7 f3                	div    %ebx
  8011cf:	89 c1                	mov    %eax,%ecx
  8011d1:	31 d2                	xor    %edx,%edx
  8011d3:	89 f0                	mov    %esi,%eax
  8011d5:	f7 f1                	div    %ecx
  8011d7:	89 c6                	mov    %eax,%esi
  8011d9:	89 e8                	mov    %ebp,%eax
  8011db:	89 f7                	mov    %esi,%edi
  8011dd:	f7 f1                	div    %ecx
  8011df:	89 fa                	mov    %edi,%edx
  8011e1:	83 c4 1c             	add    $0x1c,%esp
  8011e4:	5b                   	pop    %ebx
  8011e5:	5e                   	pop    %esi
  8011e6:	5f                   	pop    %edi
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    
  8011e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011f0:	89 f9                	mov    %edi,%ecx
  8011f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8011f7:	29 f8                	sub    %edi,%eax
  8011f9:	d3 e2                	shl    %cl,%edx
  8011fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8011ff:	89 c1                	mov    %eax,%ecx
  801201:	89 da                	mov    %ebx,%edx
  801203:	d3 ea                	shr    %cl,%edx
  801205:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801209:	09 d1                	or     %edx,%ecx
  80120b:	89 f2                	mov    %esi,%edx
  80120d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801211:	89 f9                	mov    %edi,%ecx
  801213:	d3 e3                	shl    %cl,%ebx
  801215:	89 c1                	mov    %eax,%ecx
  801217:	d3 ea                	shr    %cl,%edx
  801219:	89 f9                	mov    %edi,%ecx
  80121b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80121f:	89 eb                	mov    %ebp,%ebx
  801221:	d3 e6                	shl    %cl,%esi
  801223:	89 c1                	mov    %eax,%ecx
  801225:	d3 eb                	shr    %cl,%ebx
  801227:	09 de                	or     %ebx,%esi
  801229:	89 f0                	mov    %esi,%eax
  80122b:	f7 74 24 08          	divl   0x8(%esp)
  80122f:	89 d6                	mov    %edx,%esi
  801231:	89 c3                	mov    %eax,%ebx
  801233:	f7 64 24 0c          	mull   0xc(%esp)
  801237:	39 d6                	cmp    %edx,%esi
  801239:	72 15                	jb     801250 <__udivdi3+0x100>
  80123b:	89 f9                	mov    %edi,%ecx
  80123d:	d3 e5                	shl    %cl,%ebp
  80123f:	39 c5                	cmp    %eax,%ebp
  801241:	73 04                	jae    801247 <__udivdi3+0xf7>
  801243:	39 d6                	cmp    %edx,%esi
  801245:	74 09                	je     801250 <__udivdi3+0x100>
  801247:	89 d8                	mov    %ebx,%eax
  801249:	31 ff                	xor    %edi,%edi
  80124b:	e9 40 ff ff ff       	jmp    801190 <__udivdi3+0x40>
  801250:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801253:	31 ff                	xor    %edi,%edi
  801255:	e9 36 ff ff ff       	jmp    801190 <__udivdi3+0x40>
  80125a:	66 90                	xchg   %ax,%ax
  80125c:	66 90                	xchg   %ax,%ax
  80125e:	66 90                	xchg   %ax,%ax

00801260 <__umoddi3>:
  801260:	f3 0f 1e fb          	endbr32 
  801264:	55                   	push   %ebp
  801265:	57                   	push   %edi
  801266:	56                   	push   %esi
  801267:	53                   	push   %ebx
  801268:	83 ec 1c             	sub    $0x1c,%esp
  80126b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80126f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801273:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801277:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80127b:	85 c0                	test   %eax,%eax
  80127d:	75 19                	jne    801298 <__umoddi3+0x38>
  80127f:	39 df                	cmp    %ebx,%edi
  801281:	76 5d                	jbe    8012e0 <__umoddi3+0x80>
  801283:	89 f0                	mov    %esi,%eax
  801285:	89 da                	mov    %ebx,%edx
  801287:	f7 f7                	div    %edi
  801289:	89 d0                	mov    %edx,%eax
  80128b:	31 d2                	xor    %edx,%edx
  80128d:	83 c4 1c             	add    $0x1c,%esp
  801290:	5b                   	pop    %ebx
  801291:	5e                   	pop    %esi
  801292:	5f                   	pop    %edi
  801293:	5d                   	pop    %ebp
  801294:	c3                   	ret    
  801295:	8d 76 00             	lea    0x0(%esi),%esi
  801298:	89 f2                	mov    %esi,%edx
  80129a:	39 d8                	cmp    %ebx,%eax
  80129c:	76 12                	jbe    8012b0 <__umoddi3+0x50>
  80129e:	89 f0                	mov    %esi,%eax
  8012a0:	89 da                	mov    %ebx,%edx
  8012a2:	83 c4 1c             	add    $0x1c,%esp
  8012a5:	5b                   	pop    %ebx
  8012a6:	5e                   	pop    %esi
  8012a7:	5f                   	pop    %edi
  8012a8:	5d                   	pop    %ebp
  8012a9:	c3                   	ret    
  8012aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8012b0:	0f bd e8             	bsr    %eax,%ebp
  8012b3:	83 f5 1f             	xor    $0x1f,%ebp
  8012b6:	75 50                	jne    801308 <__umoddi3+0xa8>
  8012b8:	39 d8                	cmp    %ebx,%eax
  8012ba:	0f 82 e0 00 00 00    	jb     8013a0 <__umoddi3+0x140>
  8012c0:	89 d9                	mov    %ebx,%ecx
  8012c2:	39 f7                	cmp    %esi,%edi
  8012c4:	0f 86 d6 00 00 00    	jbe    8013a0 <__umoddi3+0x140>
  8012ca:	89 d0                	mov    %edx,%eax
  8012cc:	89 ca                	mov    %ecx,%edx
  8012ce:	83 c4 1c             	add    $0x1c,%esp
  8012d1:	5b                   	pop    %ebx
  8012d2:	5e                   	pop    %esi
  8012d3:	5f                   	pop    %edi
  8012d4:	5d                   	pop    %ebp
  8012d5:	c3                   	ret    
  8012d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012dd:	8d 76 00             	lea    0x0(%esi),%esi
  8012e0:	89 fd                	mov    %edi,%ebp
  8012e2:	85 ff                	test   %edi,%edi
  8012e4:	75 0b                	jne    8012f1 <__umoddi3+0x91>
  8012e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8012eb:	31 d2                	xor    %edx,%edx
  8012ed:	f7 f7                	div    %edi
  8012ef:	89 c5                	mov    %eax,%ebp
  8012f1:	89 d8                	mov    %ebx,%eax
  8012f3:	31 d2                	xor    %edx,%edx
  8012f5:	f7 f5                	div    %ebp
  8012f7:	89 f0                	mov    %esi,%eax
  8012f9:	f7 f5                	div    %ebp
  8012fb:	89 d0                	mov    %edx,%eax
  8012fd:	31 d2                	xor    %edx,%edx
  8012ff:	eb 8c                	jmp    80128d <__umoddi3+0x2d>
  801301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801308:	89 e9                	mov    %ebp,%ecx
  80130a:	ba 20 00 00 00       	mov    $0x20,%edx
  80130f:	29 ea                	sub    %ebp,%edx
  801311:	d3 e0                	shl    %cl,%eax
  801313:	89 44 24 08          	mov    %eax,0x8(%esp)
  801317:	89 d1                	mov    %edx,%ecx
  801319:	89 f8                	mov    %edi,%eax
  80131b:	d3 e8                	shr    %cl,%eax
  80131d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801321:	89 54 24 04          	mov    %edx,0x4(%esp)
  801325:	8b 54 24 04          	mov    0x4(%esp),%edx
  801329:	09 c1                	or     %eax,%ecx
  80132b:	89 d8                	mov    %ebx,%eax
  80132d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801331:	89 e9                	mov    %ebp,%ecx
  801333:	d3 e7                	shl    %cl,%edi
  801335:	89 d1                	mov    %edx,%ecx
  801337:	d3 e8                	shr    %cl,%eax
  801339:	89 e9                	mov    %ebp,%ecx
  80133b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80133f:	d3 e3                	shl    %cl,%ebx
  801341:	89 c7                	mov    %eax,%edi
  801343:	89 d1                	mov    %edx,%ecx
  801345:	89 f0                	mov    %esi,%eax
  801347:	d3 e8                	shr    %cl,%eax
  801349:	89 e9                	mov    %ebp,%ecx
  80134b:	89 fa                	mov    %edi,%edx
  80134d:	d3 e6                	shl    %cl,%esi
  80134f:	09 d8                	or     %ebx,%eax
  801351:	f7 74 24 08          	divl   0x8(%esp)
  801355:	89 d1                	mov    %edx,%ecx
  801357:	89 f3                	mov    %esi,%ebx
  801359:	f7 64 24 0c          	mull   0xc(%esp)
  80135d:	89 c6                	mov    %eax,%esi
  80135f:	89 d7                	mov    %edx,%edi
  801361:	39 d1                	cmp    %edx,%ecx
  801363:	72 06                	jb     80136b <__umoddi3+0x10b>
  801365:	75 10                	jne    801377 <__umoddi3+0x117>
  801367:	39 c3                	cmp    %eax,%ebx
  801369:	73 0c                	jae    801377 <__umoddi3+0x117>
  80136b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80136f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801373:	89 d7                	mov    %edx,%edi
  801375:	89 c6                	mov    %eax,%esi
  801377:	89 ca                	mov    %ecx,%edx
  801379:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80137e:	29 f3                	sub    %esi,%ebx
  801380:	19 fa                	sbb    %edi,%edx
  801382:	89 d0                	mov    %edx,%eax
  801384:	d3 e0                	shl    %cl,%eax
  801386:	89 e9                	mov    %ebp,%ecx
  801388:	d3 eb                	shr    %cl,%ebx
  80138a:	d3 ea                	shr    %cl,%edx
  80138c:	09 d8                	or     %ebx,%eax
  80138e:	83 c4 1c             	add    $0x1c,%esp
  801391:	5b                   	pop    %ebx
  801392:	5e                   	pop    %esi
  801393:	5f                   	pop    %edi
  801394:	5d                   	pop    %ebp
  801395:	c3                   	ret    
  801396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80139d:	8d 76 00             	lea    0x0(%esi),%esi
  8013a0:	29 fe                	sub    %edi,%esi
  8013a2:	19 c3                	sbb    %eax,%ebx
  8013a4:	89 f2                	mov    %esi,%edx
  8013a6:	89 d9                	mov    %ebx,%ecx
  8013a8:	e9 1d ff ff ff       	jmp    8012ca <__umoddi3+0x6a>
