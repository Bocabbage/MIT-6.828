
obj/user/divzero:     file format elf32-i386


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
  80002c:	e8 53 00 00 00       	call   800084 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	e8 3d 00 00 00       	call   800080 <__x86.get_pc_thunk.cx>
  800043:	81 c1 bd 1f 00 00    	add    $0x1fbd,%ecx
	zero = 0;
  800049:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  80004f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	cprintf("1/0 is %08x!\n", 1/zero);
  800055:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  80005b:	8b 18                	mov    (%eax),%ebx
  80005d:	b8 01 00 00 00       	mov    $0x1,%eax
  800062:	99                   	cltd   
  800063:	f7 fb                	idiv   %ebx
  800065:	83 ec 08             	sub    $0x8,%esp
  800068:	50                   	push   %eax
  800069:	8d 81 f0 f2 ff ff    	lea    -0xd10(%ecx),%eax
  80006f:	50                   	push   %eax
  800070:	89 cb                	mov    %ecx,%ebx
  800072:	e8 8e 01 00 00       	call   800205 <cprintf>
  800077:	83 c4 10             	add    $0x10,%esp
}
  80007a:	90                   	nop
  80007b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <__x86.get_pc_thunk.cx>:
  800080:	8b 0c 24             	mov    (%esp),%ecx
  800083:	c3                   	ret    

00800084 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800084:	f3 0f 1e fb          	endbr32 
  800088:	55                   	push   %ebp
  800089:	89 e5                	mov    %esp,%ebp
  80008b:	53                   	push   %ebx
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	e8 5a 00 00 00       	call   8000ee <__x86.get_pc_thunk.bx>
  800094:	81 c3 6c 1f 00 00    	add    $0x1f6c,%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code h(ere.
	thisenv = envs + ENVX(sys_getenvid());
  80009a:	e8 57 0f 00 00       	call   800ff6 <sys_getenvid>
  80009f:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a4:	89 c2                	mov    %eax,%edx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	01 c0                	add    %eax,%eax
  8000aa:	01 d0                	add    %edx,%eax
  8000ac:	c1 e0 05             	shl    $0x5,%eax
  8000af:	89 c2                	mov    %eax,%edx
  8000b1:	c7 c0 00 00 c0 ee    	mov    $0xeec00000,%eax
  8000b7:	01 c2                	add    %eax,%edx
  8000b9:	c7 c0 30 20 80 00    	mov    $0x802030,%eax
  8000bf:	89 10                	mov    %edx,(%eax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c5:	7e 0b                	jle    8000d2 <libmain+0x4e>
		binaryname = argv[0];
  8000c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ca:	8b 00                	mov    (%eax),%eax
  8000cc:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	ff 75 0c             	pushl  0xc(%ebp)
  8000d8:	ff 75 08             	pushl  0x8(%ebp)
  8000db:	e8 53 ff ff ff       	call   800033 <umain>
  8000e0:	83 c4 10             	add    $0x10,%esp

	// exit gracefully
	exit();
  8000e3:	e8 0a 00 00 00       	call   8000f2 <exit>
}
  8000e8:	90                   	nop
  8000e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ec:	c9                   	leave  
  8000ed:	c3                   	ret    

008000ee <__x86.get_pc_thunk.bx>:
  8000ee:	8b 1c 24             	mov    (%esp),%ebx
  8000f1:	c3                   	ret    

008000f2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f2:	f3 0f 1e fb          	endbr32 
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	53                   	push   %ebx
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	e8 1a 00 00 00       	call   80011c <__x86.get_pc_thunk.ax>
  800102:	05 fe 1e 00 00       	add    $0x1efe,%eax
	sys_env_destroy(0);
  800107:	83 ec 0c             	sub    $0xc,%esp
  80010a:	6a 00                	push   $0x0
  80010c:	89 c3                	mov    %eax,%ebx
  80010e:	e8 b2 0e 00 00       	call   800fc5 <sys_env_destroy>
  800113:	83 c4 10             	add    $0x10,%esp
}
  800116:	90                   	nop
  800117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011a:	c9                   	leave  
  80011b:	c3                   	ret    

0080011c <__x86.get_pc_thunk.ax>:
  80011c:	8b 04 24             	mov    (%esp),%eax
  80011f:	c3                   	ret    

00800120 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800120:	f3 0f 1e fb          	endbr32 
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	53                   	push   %ebx
  800128:	83 ec 04             	sub    $0x4,%esp
  80012b:	e8 09 01 00 00       	call   800239 <__x86.get_pc_thunk.dx>
  800130:	81 c2 d0 1e 00 00    	add    $0x1ed0,%edx
	b->buf[b->idx++] = ch;
  800136:	8b 45 0c             	mov    0xc(%ebp),%eax
  800139:	8b 00                	mov    (%eax),%eax
  80013b:	8d 58 01             	lea    0x1(%eax),%ebx
  80013e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800141:	89 19                	mov    %ebx,(%ecx)
  800143:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800146:	89 cb                	mov    %ecx,%ebx
  800148:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80014b:	88 5c 01 08          	mov    %bl,0x8(%ecx,%eax,1)
	if (b->idx == 256-1) {
  80014f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800152:	8b 00                	mov    (%eax),%eax
  800154:	3d ff 00 00 00       	cmp    $0xff,%eax
  800159:	75 25                	jne    800180 <putch+0x60>
		sys_cputs(b->buf, b->idx);
  80015b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	89 c1                	mov    %eax,%ecx
  800162:	8b 45 0c             	mov    0xc(%ebp),%eax
  800165:	83 c0 08             	add    $0x8,%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	51                   	push   %ecx
  80016c:	50                   	push   %eax
  80016d:	89 d3                	mov    %edx,%ebx
  80016f:	e8 ef 0d 00 00       	call   800f63 <sys_cputs>
  800174:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80017a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800180:	8b 45 0c             	mov    0xc(%ebp),%eax
  800183:	8b 40 04             	mov    0x4(%eax),%eax
  800186:	8d 50 01             	lea    0x1(%eax),%edx
  800189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80018f:	90                   	nop
  800190:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800195:	f3 0f 1e fb          	endbr32 
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	53                   	push   %ebx
  80019d:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8001a3:	e8 46 ff ff ff       	call   8000ee <__x86.get_pc_thunk.bx>
  8001a8:	81 c3 58 1e 00 00    	add    $0x1e58,%ebx
	struct printbuf b;

	b.idx = 0;
  8001ae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b5:	00 00 00 
	b.cnt = 0;
  8001b8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c2:	ff 75 0c             	pushl  0xc(%ebp)
  8001c5:	ff 75 08             	pushl  0x8(%ebp)
  8001c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ce:	50                   	push   %eax
  8001cf:	8d 83 20 e1 ff ff    	lea    -0x1ee0(%ebx),%eax
  8001d5:	50                   	push   %eax
  8001d6:	e8 e3 01 00 00       	call   8003be <vprintfmt>
  8001db:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8001de:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	50                   	push   %eax
  8001e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ee:	83 c0 08             	add    $0x8,%eax
  8001f1:	50                   	push   %eax
  8001f2:	e8 6c 0d 00 00       	call   800f63 <sys_cputs>
  8001f7:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8001fa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800205:	f3 0f 1e fb          	endbr32 
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	83 ec 18             	sub    $0x18,%esp
  80020f:	e8 08 ff ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800214:	05 ec 1d 00 00       	add    $0x1dec,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800219:	8d 45 0c             	lea    0xc(%ebp),%eax
  80021c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
  80021f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	ff 75 08             	pushl  0x8(%ebp)
  800229:	e8 67 ff ff ff       	call   800195 <vcprintf>
  80022e:	83 c4 10             	add    $0x10,%esp
  800231:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
  800234:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800237:	c9                   	leave  
  800238:	c3                   	ret    

00800239 <__x86.get_pc_thunk.dx>:
  800239:	8b 14 24             	mov    (%esp),%edx
  80023c:	c3                   	ret    

0080023d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80023d:	f3 0f 1e fb          	endbr32 
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	57                   	push   %edi
  800245:	56                   	push   %esi
  800246:	53                   	push   %ebx
  800247:	83 ec 1c             	sub    $0x1c,%esp
  80024a:	e8 43 06 00 00       	call   800892 <__x86.get_pc_thunk.si>
  80024f:	81 c6 b1 1d 00 00    	add    $0x1db1,%esi
  800255:	8b 45 10             	mov    0x10(%ebp),%eax
  800258:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80025b:	8b 45 14             	mov    0x14(%ebp),%eax
  80025e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800261:	8b 45 18             	mov    0x18(%ebp),%eax
  800264:	ba 00 00 00 00       	mov    $0x0,%edx
  800269:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80026c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  80026f:	19 d1                	sbb    %edx,%ecx
  800271:	72 4d                	jb     8002c0 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800273:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800276:	8d 78 ff             	lea    -0x1(%eax),%edi
  800279:	8b 45 18             	mov    0x18(%ebp),%eax
  80027c:	ba 00 00 00 00       	mov    $0x0,%edx
  800281:	52                   	push   %edx
  800282:	50                   	push   %eax
  800283:	ff 75 e4             	pushl  -0x1c(%ebp)
  800286:	ff 75 e0             	pushl  -0x20(%ebp)
  800289:	89 f3                	mov    %esi,%ebx
  80028b:	e8 00 0e 00 00       	call   801090 <__udivdi3>
  800290:	83 c4 10             	add    $0x10,%esp
  800293:	83 ec 04             	sub    $0x4,%esp
  800296:	ff 75 20             	pushl  0x20(%ebp)
  800299:	57                   	push   %edi
  80029a:	ff 75 18             	pushl  0x18(%ebp)
  80029d:	52                   	push   %edx
  80029e:	50                   	push   %eax
  80029f:	ff 75 0c             	pushl  0xc(%ebp)
  8002a2:	ff 75 08             	pushl  0x8(%ebp)
  8002a5:	e8 93 ff ff ff       	call   80023d <printnum>
  8002aa:	83 c4 20             	add    $0x20,%esp
  8002ad:	eb 1b                	jmp    8002ca <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 20             	pushl  0x20(%ebp)
  8002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bb:	ff d0                	call   *%eax
  8002bd:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002c0:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8002c4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8002c8:	7f e5                	jg     8002af <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002ca:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002d8:	53                   	push   %ebx
  8002d9:	51                   	push   %ecx
  8002da:	52                   	push   %edx
  8002db:	50                   	push   %eax
  8002dc:	89 f3                	mov    %esi,%ebx
  8002de:	e8 bd 0e 00 00       	call   8011a0 <__umoddi3>
  8002e3:	83 c4 10             	add    $0x10,%esp
  8002e6:	8d 8e 71 f3 ff ff    	lea    -0xc8f(%esi),%ecx
  8002ec:	01 c8                	add    %ecx,%eax
  8002ee:	0f b6 00             	movzbl (%eax),%eax
  8002f1:	0f be c0             	movsbl %al,%eax
  8002f4:	83 ec 08             	sub    $0x8,%esp
  8002f7:	ff 75 0c             	pushl  0xc(%ebp)
  8002fa:	50                   	push   %eax
  8002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fe:	ff d0                	call   *%eax
  800300:	83 c4 10             	add    $0x10,%esp
}
  800303:	90                   	nop
  800304:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800307:	5b                   	pop    %ebx
  800308:	5e                   	pop    %esi
  800309:	5f                   	pop    %edi
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80030c:	f3 0f 1e fb          	endbr32 
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	e8 04 fe ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800318:	05 e8 1c 00 00       	add    $0x1ce8,%eax
	if (lflag >= 2)
  80031d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800321:	7e 14                	jle    800337 <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
  800323:	8b 45 08             	mov    0x8(%ebp),%eax
  800326:	8b 00                	mov    (%eax),%eax
  800328:	8d 48 08             	lea    0x8(%eax),%ecx
  80032b:	8b 55 08             	mov    0x8(%ebp),%edx
  80032e:	89 0a                	mov    %ecx,(%edx)
  800330:	8b 50 04             	mov    0x4(%eax),%edx
  800333:	8b 00                	mov    (%eax),%eax
  800335:	eb 30                	jmp    800367 <getuint+0x5b>
	else if (lflag)
  800337:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80033b:	74 16                	je     800353 <getuint+0x47>
		return va_arg(*ap, unsigned long);
  80033d:	8b 45 08             	mov    0x8(%ebp),%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	8d 48 04             	lea    0x4(%eax),%ecx
  800345:	8b 55 08             	mov    0x8(%ebp),%edx
  800348:	89 0a                	mov    %ecx,(%edx)
  80034a:	8b 00                	mov    (%eax),%eax
  80034c:	ba 00 00 00 00       	mov    $0x0,%edx
  800351:	eb 14                	jmp    800367 <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
  800353:	8b 45 08             	mov    0x8(%ebp),%eax
  800356:	8b 00                	mov    (%eax),%eax
  800358:	8d 48 04             	lea    0x4(%eax),%ecx
  80035b:	8b 55 08             	mov    0x8(%ebp),%edx
  80035e:	89 0a                	mov    %ecx,(%edx)
  800360:	8b 00                	mov    (%eax),%eax
  800362:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800367:	5d                   	pop    %ebp
  800368:	c3                   	ret    

00800369 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800369:	f3 0f 1e fb          	endbr32 
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	e8 a7 fd ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800375:	05 8b 1c 00 00       	add    $0x1c8b,%eax
	if (lflag >= 2)
  80037a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80037e:	7e 14                	jle    800394 <getint+0x2b>
		return va_arg(*ap, long long);
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	8b 00                	mov    (%eax),%eax
  800385:	8d 48 08             	lea    0x8(%eax),%ecx
  800388:	8b 55 08             	mov    0x8(%ebp),%edx
  80038b:	89 0a                	mov    %ecx,(%edx)
  80038d:	8b 50 04             	mov    0x4(%eax),%edx
  800390:	8b 00                	mov    (%eax),%eax
  800392:	eb 28                	jmp    8003bc <getint+0x53>
	else if (lflag)
  800394:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800398:	74 12                	je     8003ac <getint+0x43>
		return va_arg(*ap, long);
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	8b 00                	mov    (%eax),%eax
  80039f:	8d 48 04             	lea    0x4(%eax),%ecx
  8003a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a5:	89 0a                	mov    %ecx,(%edx)
  8003a7:	8b 00                	mov    (%eax),%eax
  8003a9:	99                   	cltd   
  8003aa:	eb 10                	jmp    8003bc <getint+0x53>
	else
		return va_arg(*ap, int);
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	8d 48 04             	lea    0x4(%eax),%ecx
  8003b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b7:	89 0a                	mov    %ecx,(%edx)
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	99                   	cltd   
}
  8003bc:	5d                   	pop    %ebp
  8003bd:	c3                   	ret    

008003be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003be:	f3 0f 1e fb          	endbr32 
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	57                   	push   %edi
  8003c6:	56                   	push   %esi
  8003c7:	53                   	push   %ebx
  8003c8:	83 ec 2c             	sub    $0x2c,%esp
  8003cb:	e8 c6 04 00 00       	call   800896 <__x86.get_pc_thunk.di>
  8003d0:	81 c7 30 1c 00 00    	add    $0x1c30,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003d6:	eb 17                	jmp    8003ef <vprintfmt+0x31>
			if (ch == '\0')
  8003d8:	85 db                	test   %ebx,%ebx
  8003da:	0f 84 96 03 00 00    	je     800776 <.L20+0x2d>
				return;
			putch(ch, putdat);
  8003e0:	83 ec 08             	sub    $0x8,%esp
  8003e3:	ff 75 0c             	pushl  0xc(%ebp)
  8003e6:	53                   	push   %ebx
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	ff d0                	call   *%eax
  8003ec:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f2:	8d 50 01             	lea    0x1(%eax),%edx
  8003f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8003f8:	0f b6 00             	movzbl (%eax),%eax
  8003fb:	0f b6 d8             	movzbl %al,%ebx
  8003fe:	83 fb 25             	cmp    $0x25,%ebx
  800401:	75 d5                	jne    8003d8 <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
  800403:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
  800407:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
  80040e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
  800415:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
  80041c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800423:	8b 45 10             	mov    0x10(%ebp),%eax
  800426:	8d 50 01             	lea    0x1(%eax),%edx
  800429:	89 55 10             	mov    %edx,0x10(%ebp)
  80042c:	0f b6 00             	movzbl (%eax),%eax
  80042f:	0f b6 d8             	movzbl %al,%ebx
  800432:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800435:	83 f8 55             	cmp    $0x55,%eax
  800438:	0f 87 0b 03 00 00    	ja     800749 <.L20>
  80043e:	c1 e0 02             	shl    $0x2,%eax
  800441:	8b 84 38 98 f3 ff ff 	mov    -0xc68(%eax,%edi,1),%eax
  800448:	01 f8                	add    %edi,%eax
  80044a:	3e ff e0             	notrack jmp *%eax

0080044d <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
  80044d:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
  800451:	eb d0                	jmp    800423 <vprintfmt+0x65>

00800453 <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800453:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
  800457:	eb ca                	jmp    800423 <vprintfmt+0x65>

00800459 <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800459:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
  800460:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	c1 e0 02             	shl    $0x2,%eax
  800468:	01 d0                	add    %edx,%eax
  80046a:	01 c0                	add    %eax,%eax
  80046c:	01 d8                	add    %ebx,%eax
  80046e:	83 e8 30             	sub    $0x30,%eax
  800471:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
  800474:	8b 45 10             	mov    0x10(%ebp),%eax
  800477:	0f b6 00             	movzbl (%eax),%eax
  80047a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80047d:	83 fb 2f             	cmp    $0x2f,%ebx
  800480:	7e 39                	jle    8004bb <.L37+0xc>
  800482:	83 fb 39             	cmp    $0x39,%ebx
  800485:	7f 34                	jg     8004bb <.L37+0xc>
			for (precision = 0; ; ++fmt) {
  800487:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
  80048b:	eb d3                	jmp    800460 <.L31+0x7>

0080048d <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80048d:	8b 45 14             	mov    0x14(%ebp),%eax
  800490:	8d 50 04             	lea    0x4(%eax),%edx
  800493:	89 55 14             	mov    %edx,0x14(%ebp)
  800496:	8b 00                	mov    (%eax),%eax
  800498:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
  80049b:	eb 1f                	jmp    8004bc <.L37+0xd>

0080049d <.L33>:

		case '.':
			if (width < 0)
  80049d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004a1:	79 80                	jns    800423 <vprintfmt+0x65>
				width = 0;
  8004a3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
  8004aa:	e9 74 ff ff ff       	jmp    800423 <vprintfmt+0x65>

008004af <.L37>:

		case '#':
			altflag = 1;
  8004af:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
  8004b6:	e9 68 ff ff ff       	jmp    800423 <vprintfmt+0x65>
			goto process_precision;
  8004bb:	90                   	nop

		process_precision:
			if (width < 0)
  8004bc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004c0:	0f 89 5d ff ff ff    	jns    800423 <vprintfmt+0x65>
				width = precision, precision = -1;
  8004c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004cc:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
  8004d3:	e9 4b ff ff ff       	jmp    800423 <vprintfmt+0x65>

008004d8 <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004d8:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004dc:	e9 42 ff ff ff       	jmp    800423 <vprintfmt+0x65>

008004e1 <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e4:	8d 50 04             	lea    0x4(%eax),%edx
  8004e7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	ff 75 0c             	pushl  0xc(%ebp)
  8004f2:	50                   	push   %eax
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	ff d0                	call   *%eax
  8004f8:	83 c4 10             	add    $0x10,%esp
			break;
  8004fb:	e9 71 02 00 00       	jmp    800771 <.L20+0x28>

00800500 <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
  800500:	8b 45 14             	mov    0x14(%ebp),%eax
  800503:	8d 50 04             	lea    0x4(%eax),%edx
  800506:	89 55 14             	mov    %edx,0x14(%ebp)
  800509:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80050b:	85 db                	test   %ebx,%ebx
  80050d:	79 02                	jns    800511 <.L28+0x11>
				err = -err;
  80050f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800511:	83 fb 06             	cmp    $0x6,%ebx
  800514:	7f 0b                	jg     800521 <.L28+0x21>
  800516:	8b b4 9f 10 00 00 00 	mov    0x10(%edi,%ebx,4),%esi
  80051d:	85 f6                	test   %esi,%esi
  80051f:	75 1b                	jne    80053c <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
  800521:	53                   	push   %ebx
  800522:	8d 87 82 f3 ff ff    	lea    -0xc7e(%edi),%eax
  800528:	50                   	push   %eax
  800529:	ff 75 0c             	pushl  0xc(%ebp)
  80052c:	ff 75 08             	pushl  0x8(%ebp)
  80052f:	e8 4b 02 00 00       	call   80077f <printfmt>
  800534:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800537:	e9 35 02 00 00       	jmp    800771 <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
  80053c:	56                   	push   %esi
  80053d:	8d 87 8b f3 ff ff    	lea    -0xc75(%edi),%eax
  800543:	50                   	push   %eax
  800544:	ff 75 0c             	pushl  0xc(%ebp)
  800547:	ff 75 08             	pushl  0x8(%ebp)
  80054a:	e8 30 02 00 00       	call   80077f <printfmt>
  80054f:	83 c4 10             	add    $0x10,%esp
			break;
  800552:	e9 1a 02 00 00       	jmp    800771 <.L20+0x28>

00800557 <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8d 50 04             	lea    0x4(%eax),%edx
  80055d:	89 55 14             	mov    %edx,0x14(%ebp)
  800560:	8b 30                	mov    (%eax),%esi
  800562:	85 f6                	test   %esi,%esi
  800564:	75 06                	jne    80056c <.L24+0x15>
				p = "(null)";
  800566:	8d b7 8e f3 ff ff    	lea    -0xc72(%edi),%esi
			if (width > 0 && padc != '-')
  80056c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800570:	7e 71                	jle    8005e3 <.L24+0x8c>
  800572:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  800576:	74 6b                	je     8005e3 <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800578:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80057b:	83 ec 08             	sub    $0x8,%esp
  80057e:	50                   	push   %eax
  80057f:	56                   	push   %esi
  800580:	89 fb                	mov    %edi,%ebx
  800582:	e8 47 03 00 00       	call   8008ce <strnlen>
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	29 45 d4             	sub    %eax,-0x2c(%ebp)
  80058d:	eb 17                	jmp    8005a6 <.L24+0x4f>
					putch(padc, putdat);
  80058f:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	ff 75 0c             	pushl  0xc(%ebp)
  800599:	50                   	push   %eax
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	ff d0                	call   *%eax
  80059f:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a2:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  8005a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005aa:	7f e3                	jg     80058f <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ac:	eb 35                	jmp    8005e3 <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ae:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005b2:	74 1c                	je     8005d0 <.L24+0x79>
  8005b4:	83 fb 1f             	cmp    $0x1f,%ebx
  8005b7:	7e 05                	jle    8005be <.L24+0x67>
  8005b9:	83 fb 7e             	cmp    $0x7e,%ebx
  8005bc:	7e 12                	jle    8005d0 <.L24+0x79>
					putch('?', putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	ff 75 0c             	pushl  0xc(%ebp)
  8005c4:	6a 3f                	push   $0x3f
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	ff d0                	call   *%eax
  8005cb:	83 c4 10             	add    $0x10,%esp
  8005ce:	eb 0f                	jmp    8005df <.L24+0x88>
				else
					putch(ch, putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	53                   	push   %ebx
  8005d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005da:	ff d0                	call   *%eax
  8005dc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005df:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  8005e3:	89 f0                	mov    %esi,%eax
  8005e5:	8d 70 01             	lea    0x1(%eax),%esi
  8005e8:	0f b6 00             	movzbl (%eax),%eax
  8005eb:	0f be d8             	movsbl %al,%ebx
  8005ee:	85 db                	test   %ebx,%ebx
  8005f0:	74 26                	je     800618 <.L24+0xc1>
  8005f2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005f6:	78 b6                	js     8005ae <.L24+0x57>
  8005f8:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  8005fc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800600:	79 ac                	jns    8005ae <.L24+0x57>
			for (; width > 0; width--)
  800602:	eb 14                	jmp    800618 <.L24+0xc1>
				putch(' ', putdat);
  800604:	83 ec 08             	sub    $0x8,%esp
  800607:	ff 75 0c             	pushl  0xc(%ebp)
  80060a:	6a 20                	push   $0x20
  80060c:	8b 45 08             	mov    0x8(%ebp),%eax
  80060f:	ff d0                	call   *%eax
  800611:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
  800614:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800618:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80061c:	7f e6                	jg     800604 <.L24+0xad>
			break;
  80061e:	e9 4e 01 00 00       	jmp    800771 <.L20+0x28>

00800623 <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	ff 75 d8             	pushl  -0x28(%ebp)
  800629:	8d 45 14             	lea    0x14(%ebp),%eax
  80062c:	50                   	push   %eax
  80062d:	e8 37 fd ff ff       	call   800369 <getint>
  800632:	83 c4 10             	add    $0x10,%esp
  800635:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800638:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
  80063b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800641:	85 d2                	test   %edx,%edx
  800643:	79 23                	jns    800668 <.L29+0x45>
				putch('-', putdat);
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	ff 75 0c             	pushl  0xc(%ebp)
  80064b:	6a 2d                	push   $0x2d
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	ff d0                	call   *%eax
  800652:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800655:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800658:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80065b:	f7 d8                	neg    %eax
  80065d:	83 d2 00             	adc    $0x0,%edx
  800660:	f7 da                	neg    %edx
  800662:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800665:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
  800668:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  80066f:	e9 9f 00 00 00       	jmp    800713 <.L21+0x1f>

00800674 <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	ff 75 d8             	pushl  -0x28(%ebp)
  80067a:	8d 45 14             	lea    0x14(%ebp),%eax
  80067d:	50                   	push   %eax
  80067e:	e8 89 fc ff ff       	call   80030c <getuint>
  800683:	83 c4 10             	add    $0x10,%esp
  800686:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800689:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
  80068c:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  800693:	eb 7e                	jmp    800713 <.L21+0x1f>

00800695 <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	ff 75 d8             	pushl  -0x28(%ebp)
  80069b:	8d 45 14             	lea    0x14(%ebp),%eax
  80069e:	50                   	push   %eax
  80069f:	e8 68 fc ff ff       	call   80030c <getuint>
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
  8006ad:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
  8006b4:	eb 5d                	jmp    800713 <.L21+0x1f>

008006b6 <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	6a 30                	push   $0x30
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	ff d0                	call   *%eax
  8006c3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 0c             	pushl  0xc(%ebp)
  8006cc:	6a 78                	push   $0x78
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	ff d0                	call   *%eax
  8006d3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 50 04             	lea    0x4(%eax),%edx
  8006dc:	89 55 14             	mov    %edx,0x14(%ebp)
  8006df:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
  8006e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
  8006eb:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
  8006f2:	eb 1f                	jmp    800713 <.L21+0x1f>

008006f4 <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8006fd:	50                   	push   %eax
  8006fe:	e8 09 fc ff ff       	call   80030c <getuint>
  800703:	83 c4 10             	add    $0x10,%esp
  800706:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800709:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
  80070c:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800713:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  800717:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80071a:	83 ec 04             	sub    $0x4,%esp
  80071d:	52                   	push   %edx
  80071e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800721:	50                   	push   %eax
  800722:	ff 75 e4             	pushl  -0x1c(%ebp)
  800725:	ff 75 e0             	pushl  -0x20(%ebp)
  800728:	ff 75 0c             	pushl  0xc(%ebp)
  80072b:	ff 75 08             	pushl  0x8(%ebp)
  80072e:	e8 0a fb ff ff       	call   80023d <printnum>
  800733:	83 c4 20             	add    $0x20,%esp
			break;
  800736:	eb 39                	jmp    800771 <.L20+0x28>

00800738 <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	ff 75 0c             	pushl  0xc(%ebp)
  80073e:	53                   	push   %ebx
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	ff d0                	call   *%eax
  800744:	83 c4 10             	add    $0x10,%esp
			break;
  800747:	eb 28                	jmp    800771 <.L20+0x28>

00800749 <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	ff 75 0c             	pushl  0xc(%ebp)
  80074f:	6a 25                	push   $0x25
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	ff d0                	call   *%eax
  800756:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800759:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  80075d:	eb 04                	jmp    800763 <.L20+0x1a>
  80075f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800763:	8b 45 10             	mov    0x10(%ebp),%eax
  800766:	83 e8 01             	sub    $0x1,%eax
  800769:	0f b6 00             	movzbl (%eax),%eax
  80076c:	3c 25                	cmp    $0x25,%al
  80076e:	75 ef                	jne    80075f <.L20+0x16>
				/* do nothing */;
			break;
  800770:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800771:	e9 79 fc ff ff       	jmp    8003ef <vprintfmt+0x31>
				return;
  800776:	90                   	nop
		}
	}
}
  800777:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80077a:	5b                   	pop    %ebx
  80077b:	5e                   	pop    %esi
  80077c:	5f                   	pop    %edi
  80077d:	5d                   	pop    %ebp
  80077e:	c3                   	ret    

0080077f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80077f:	f3 0f 1e fb          	endbr32 
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	83 ec 18             	sub    $0x18,%esp
  800789:	e8 8e f9 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  80078e:	05 72 18 00 00       	add    $0x1872,%eax
	va_list ap;

	va_start(ap, fmt);
  800793:	8d 45 14             	lea    0x14(%ebp),%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80079c:	50                   	push   %eax
  80079d:	ff 75 10             	pushl  0x10(%ebp)
  8007a0:	ff 75 0c             	pushl  0xc(%ebp)
  8007a3:	ff 75 08             	pushl  0x8(%ebp)
  8007a6:	e8 13 fc ff ff       	call   8003be <vprintfmt>
  8007ab:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8007ae:	90                   	nop
  8007af:	c9                   	leave  
  8007b0:	c3                   	ret    

008007b1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007b1:	f3 0f 1e fb          	endbr32 
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	e8 5f f9 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  8007bd:	05 43 18 00 00       	add    $0x1843,%eax
	b->cnt++;
  8007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c5:	8b 40 08             	mov    0x8(%eax),%eax
  8007c8:	8d 50 01             	lea    0x1(%eax),%edx
  8007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ce:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8007d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d4:	8b 10                	mov    (%eax),%edx
  8007d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d9:	8b 40 04             	mov    0x4(%eax),%eax
  8007dc:	39 c2                	cmp    %eax,%edx
  8007de:	73 12                	jae    8007f2 <sprintputch+0x41>
		*b->buf++ = ch;
  8007e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8007e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007eb:	89 0a                	mov    %ecx,(%edx)
  8007ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8007f0:	88 10                	mov    %dl,(%eax)
}
  8007f2:	90                   	nop
  8007f3:	5d                   	pop    %ebp
  8007f4:	c3                   	ret    

008007f5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f5:	f3 0f 1e fb          	endbr32 
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	83 ec 18             	sub    $0x18,%esp
  8007ff:	e8 18 f9 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800804:	05 fc 17 00 00       	add    $0x17fc,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
  800809:	8b 55 08             	mov    0x8(%ebp),%edx
  80080c:	89 55 ec             	mov    %edx,-0x14(%ebp)
  80080f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800812:	8d 4a ff             	lea    -0x1(%edx),%ecx
  800815:	8b 55 08             	mov    0x8(%ebp),%edx
  800818:	01 ca                	add    %ecx,%edx
  80081a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80081d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800824:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800828:	74 06                	je     800830 <vsnprintf+0x3b>
  80082a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80082e:	7f 07                	jg     800837 <vsnprintf+0x42>
		return -E_INVAL;
  800830:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800835:	eb 22                	jmp    800859 <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800837:	ff 75 14             	pushl  0x14(%ebp)
  80083a:	ff 75 10             	pushl  0x10(%ebp)
  80083d:	8d 55 ec             	lea    -0x14(%ebp),%edx
  800840:	52                   	push   %edx
  800841:	8d 80 b1 e7 ff ff    	lea    -0x184f(%eax),%eax
  800847:	50                   	push   %eax
  800848:	e8 71 fb ff ff       	call   8003be <vprintfmt>
  80084d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800853:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800856:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80085b:	f3 0f 1e fb          	endbr32 
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	83 ec 18             	sub    $0x18,%esp
  800865:	e8 b2 f8 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  80086a:	05 96 17 00 00       	add    $0x1796,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80086f:	8d 45 14             	lea    0x14(%ebp),%eax
  800872:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800878:	50                   	push   %eax
  800879:	ff 75 10             	pushl  0x10(%ebp)
  80087c:	ff 75 0c             	pushl  0xc(%ebp)
  80087f:	ff 75 08             	pushl  0x8(%ebp)
  800882:	e8 6e ff ff ff       	call   8007f5 <vsnprintf>
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
  80088d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800890:	c9                   	leave  
  800891:	c3                   	ret    

00800892 <__x86.get_pc_thunk.si>:
  800892:	8b 34 24             	mov    (%esp),%esi
  800895:	c3                   	ret    

00800896 <__x86.get_pc_thunk.di>:
  800896:	8b 3c 24             	mov    (%esp),%edi
  800899:	c3                   	ret    

0080089a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80089a:	f3 0f 1e fb          	endbr32 
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	83 ec 10             	sub    $0x10,%esp
  8008a4:	e8 73 f8 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  8008a9:	05 57 17 00 00       	add    $0x1757,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008b5:	eb 08                	jmp    8008bf <strlen+0x25>
		n++;
  8008b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
  8008bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	0f b6 00             	movzbl (%eax),%eax
  8008c5:	84 c0                	test   %al,%al
  8008c7:	75 ee                	jne    8008b7 <strlen+0x1d>
	return n;
  8008c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008cc:	c9                   	leave  
  8008cd:	c3                   	ret    

008008ce <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ce:	f3 0f 1e fb          	endbr32 
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	83 ec 10             	sub    $0x10,%esp
  8008d8:	e8 3f f8 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  8008dd:	05 23 17 00 00       	add    $0x1723,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008e9:	eb 0c                	jmp    8008f7 <strnlen+0x29>
		n++;
  8008eb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8008f3:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  8008f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008fb:	74 0a                	je     800907 <strnlen+0x39>
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	0f b6 00             	movzbl (%eax),%eax
  800903:	84 c0                	test   %al,%al
  800905:	75 e4                	jne    8008eb <strnlen+0x1d>
	return n;
  800907:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80090c:	f3 0f 1e fb          	endbr32 
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	83 ec 10             	sub    $0x10,%esp
  800916:	e8 01 f8 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  80091b:	05 e5 16 00 00       	add    $0x16e5,%eax
	char *ret;

	ret = dst;
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800926:	90                   	nop
  800927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092a:	8d 42 01             	lea    0x1(%edx),%eax
  80092d:	89 45 0c             	mov    %eax,0xc(%ebp)
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8d 48 01             	lea    0x1(%eax),%ecx
  800936:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800939:	0f b6 12             	movzbl (%edx),%edx
  80093c:	88 10                	mov    %dl,(%eax)
  80093e:	0f b6 00             	movzbl (%eax),%eax
  800941:	84 c0                	test   %al,%al
  800943:	75 e2                	jne    800927 <strcpy+0x1b>
		/* do nothing */;
	return ret;
  800945:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800948:	c9                   	leave  
  800949:	c3                   	ret    

0080094a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80094a:	f3 0f 1e fb          	endbr32 
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	83 ec 10             	sub    $0x10,%esp
  800954:	e8 c3 f7 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800959:	05 a7 16 00 00       	add    $0x16a7,%eax
	int len = strlen(dst);
  80095e:	ff 75 08             	pushl  0x8(%ebp)
  800961:	e8 34 ff ff ff       	call   80089a <strlen>
  800966:	83 c4 04             	add    $0x4,%esp
  800969:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
  80096c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	01 d0                	add    %edx,%eax
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	50                   	push   %eax
  800978:	e8 8f ff ff ff       	call   80090c <strcpy>
  80097d:	83 c4 08             	add    $0x8,%esp
	return dst;
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800983:	c9                   	leave  
  800984:	c3                   	ret    

00800985 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800985:	f3 0f 1e fb          	endbr32 
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	83 ec 10             	sub    $0x10,%esp
  80098f:	e8 88 f7 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800994:	05 6c 16 00 00       	add    $0x166c,%eax
	size_t i;
	char *ret;

	ret = dst;
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80099f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009a6:	eb 23                	jmp    8009cb <strncpy+0x46>
		*dst++ = *src;
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8d 50 01             	lea    0x1(%eax),%edx
  8009ae:	89 55 08             	mov    %edx,0x8(%ebp)
  8009b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b4:	0f b6 12             	movzbl (%edx),%edx
  8009b7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bc:	0f b6 00             	movzbl (%eax),%eax
  8009bf:	84 c0                	test   %al,%al
  8009c1:	74 04                	je     8009c7 <strncpy+0x42>
			src++;
  8009c3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
  8009c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  8009cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009ce:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009d1:	72 d5                	jb     8009a8 <strncpy+0x23>
	}
	return ret;
  8009d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009d6:	c9                   	leave  
  8009d7:	c3                   	ret    

008009d8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d8:	f3 0f 1e fb          	endbr32 
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 10             	sub    $0x10,%esp
  8009e2:	e8 35 f7 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  8009e7:	05 19 16 00 00       	add    $0x1619,%eax
	char *dst_in;

	dst_in = dst;
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009f6:	74 33                	je     800a2b <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
  8009f8:	eb 17                	jmp    800a11 <strlcpy+0x39>
			*dst++ = *src++;
  8009fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fd:	8d 42 01             	lea    0x1(%edx),%eax
  800a00:	89 45 0c             	mov    %eax,0xc(%ebp)
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8d 48 01             	lea    0x1(%eax),%ecx
  800a09:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800a0c:	0f b6 12             	movzbl (%edx),%edx
  800a0f:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
  800a11:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800a15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a19:	74 0a                	je     800a25 <strlcpy+0x4d>
  800a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1e:	0f b6 00             	movzbl (%eax),%eax
  800a21:	84 c0                	test   %al,%al
  800a23:	75 d5                	jne    8009fa <strlcpy+0x22>
		*dst = '\0';
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
  800a31:	c9                   	leave  
  800a32:	c3                   	ret    

00800a33 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a33:	f3 0f 1e fb          	endbr32 
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	e8 dd f6 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800a3f:	05 c1 15 00 00       	add    $0x15c1,%eax
	while (*p && *p == *q)
  800a44:	eb 08                	jmp    800a4e <strcmp+0x1b>
		p++, q++;
  800a46:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a4a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	0f b6 00             	movzbl (%eax),%eax
  800a54:	84 c0                	test   %al,%al
  800a56:	74 10                	je     800a68 <strcmp+0x35>
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	0f b6 10             	movzbl (%eax),%edx
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	0f b6 00             	movzbl (%eax),%eax
  800a64:	38 c2                	cmp    %al,%dl
  800a66:	74 de                	je     800a46 <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	0f b6 00             	movzbl (%eax),%eax
  800a6e:	0f b6 d0             	movzbl %al,%edx
  800a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a74:	0f b6 00             	movzbl (%eax),%eax
  800a77:	0f b6 c0             	movzbl %al,%eax
  800a7a:	29 c2                	sub    %eax,%edx
  800a7c:	89 d0                	mov    %edx,%eax
}
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a80:	f3 0f 1e fb          	endbr32 
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	e8 90 f6 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800a8c:	05 74 15 00 00       	add    $0x1574,%eax
	while (n > 0 && *p && *p == *q)
  800a91:	eb 0c                	jmp    800a9f <strncmp+0x1f>
		n--, p++, q++;
  800a93:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800a97:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a9b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
  800a9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa3:	74 1a                	je     800abf <strncmp+0x3f>
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	0f b6 00             	movzbl (%eax),%eax
  800aab:	84 c0                	test   %al,%al
  800aad:	74 10                	je     800abf <strncmp+0x3f>
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	0f b6 10             	movzbl (%eax),%edx
  800ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab8:	0f b6 00             	movzbl (%eax),%eax
  800abb:	38 c2                	cmp    %al,%dl
  800abd:	74 d4                	je     800a93 <strncmp+0x13>
	if (n == 0)
  800abf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac3:	75 07                	jne    800acc <strncmp+0x4c>
		return 0;
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aca:	eb 16                	jmp    800ae2 <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	0f b6 00             	movzbl (%eax),%eax
  800ad2:	0f b6 d0             	movzbl %al,%edx
  800ad5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad8:	0f b6 00             	movzbl (%eax),%eax
  800adb:	0f b6 c0             	movzbl %al,%eax
  800ade:	29 c2                	sub    %eax,%edx
  800ae0:	89 d0                	mov    %edx,%eax
}
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae4:	f3 0f 1e fb          	endbr32 
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	83 ec 04             	sub    $0x4,%esp
  800aee:	e8 29 f6 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800af3:	05 0d 15 00 00       	add    $0x150d,%eax
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800afe:	eb 14                	jmp    800b14 <strchr+0x30>
		if (*s == c)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	0f b6 00             	movzbl (%eax),%eax
  800b06:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800b09:	75 05                	jne    800b10 <strchr+0x2c>
			return (char *) s;
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	eb 13                	jmp    800b23 <strchr+0x3f>
	for (; *s; s++)
  800b10:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	0f b6 00             	movzbl (%eax),%eax
  800b1a:	84 c0                	test   %al,%al
  800b1c:	75 e2                	jne    800b00 <strchr+0x1c>
	return 0;
  800b1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b23:	c9                   	leave  
  800b24:	c3                   	ret    

00800b25 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b25:	f3 0f 1e fb          	endbr32 
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	83 ec 04             	sub    $0x4,%esp
  800b2f:	e8 e8 f5 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800b34:	05 cc 14 00 00       	add    $0x14cc,%eax
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b3f:	eb 0f                	jmp    800b50 <strfind+0x2b>
		if (*s == c)
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	0f b6 00             	movzbl (%eax),%eax
  800b47:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800b4a:	74 10                	je     800b5c <strfind+0x37>
	for (; *s; s++)
  800b4c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	0f b6 00             	movzbl (%eax),%eax
  800b56:	84 c0                	test   %al,%al
  800b58:	75 e7                	jne    800b41 <strfind+0x1c>
  800b5a:	eb 01                	jmp    800b5d <strfind+0x38>
			break;
  800b5c:	90                   	nop
	return (char *) s;
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b60:	c9                   	leave  
  800b61:	c3                   	ret    

00800b62 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b62:	f3 0f 1e fb          	endbr32 
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	e8 ad f5 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800b6f:	05 91 14 00 00       	add    $0x1491,%eax
	char *p;

	if (n == 0)
  800b74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b78:	75 05                	jne    800b7f <memset+0x1d>
		return v;
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	eb 5c                	jmp    800bdb <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	83 e0 03             	and    $0x3,%eax
  800b85:	85 c0                	test   %eax,%eax
  800b87:	75 41                	jne    800bca <memset+0x68>
  800b89:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8c:	83 e0 03             	and    $0x3,%eax
  800b8f:	85 c0                	test   %eax,%eax
  800b91:	75 37                	jne    800bca <memset+0x68>
		c &= 0xFF;
  800b93:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	c1 e0 18             	shl    $0x18,%eax
  800ba0:	89 c2                	mov    %eax,%edx
  800ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba5:	c1 e0 10             	shl    $0x10,%eax
  800ba8:	09 c2                	or     %eax,%edx
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	c1 e0 08             	shl    $0x8,%eax
  800bb0:	09 d0                	or     %edx,%eax
  800bb2:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb8:	c1 e8 02             	shr    $0x2,%eax
  800bbb:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
  800bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	89 d7                	mov    %edx,%edi
  800bc5:	fc                   	cld    
  800bc6:	f3 ab                	rep stos %eax,%es:(%edi)
  800bc8:	eb 0e                	jmp    800bd8 <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bca:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800bd3:	89 d7                	mov    %edx,%edi
  800bd5:	fc                   	cld    
  800bd6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bdb:	5f                   	pop    %edi
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bde:	f3 0f 1e fb          	endbr32 
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	57                   	push   %edi
  800be6:	56                   	push   %esi
  800be7:	53                   	push   %ebx
  800be8:	83 ec 10             	sub    $0x10,%esp
  800beb:	e8 2c f5 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800bf0:	05 10 14 00 00       	add    $0x1410,%eax
	const char *s;
	char *d;

	s = src;
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
  800c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c04:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800c07:	73 6d                	jae    800c76 <memmove+0x98>
  800c09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  800c14:	73 60                	jae    800c76 <memmove+0x98>
		s += n;
  800c16:	8b 45 10             	mov    0x10(%ebp),%eax
  800c19:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
  800c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1f:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c25:	83 e0 03             	and    $0x3,%eax
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	75 2f                	jne    800c5b <memmove+0x7d>
  800c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c2f:	83 e0 03             	and    $0x3,%eax
  800c32:	85 c0                	test   %eax,%eax
  800c34:	75 25                	jne    800c5b <memmove+0x7d>
  800c36:	8b 45 10             	mov    0x10(%ebp),%eax
  800c39:	83 e0 03             	and    $0x3,%eax
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	75 1b                	jne    800c5b <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c43:	83 e8 04             	sub    $0x4,%eax
  800c46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c49:	83 ea 04             	sub    $0x4,%edx
  800c4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c4f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c52:	89 c7                	mov    %eax,%edi
  800c54:	89 d6                	mov    %edx,%esi
  800c56:	fd                   	std    
  800c57:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c59:	eb 18                	jmp    800c73 <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c5e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c64:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	89 d7                	mov    %edx,%edi
  800c6c:	89 de                	mov    %ebx,%esi
  800c6e:	89 c1                	mov    %eax,%ecx
  800c70:	fd                   	std    
  800c71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c73:	fc                   	cld    
  800c74:	eb 45                	jmp    800cbb <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c79:	83 e0 03             	and    $0x3,%eax
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	75 2b                	jne    800cab <memmove+0xcd>
  800c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c83:	83 e0 03             	and    $0x3,%eax
  800c86:	85 c0                	test   %eax,%eax
  800c88:	75 21                	jne    800cab <memmove+0xcd>
  800c8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8d:	83 e0 03             	and    $0x3,%eax
  800c90:	85 c0                	test   %eax,%eax
  800c92:	75 17                	jne    800cab <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c94:	8b 45 10             	mov    0x10(%ebp),%eax
  800c97:	c1 e8 02             	shr    $0x2,%eax
  800c9a:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ca2:	89 c7                	mov    %eax,%edi
  800ca4:	89 d6                	mov    %edx,%esi
  800ca6:	fc                   	cld    
  800ca7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca9:	eb 10                	jmp    800cbb <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
  800cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800cb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800cb4:	89 c7                	mov    %eax,%edi
  800cb6:	89 d6                	mov    %edx,%esi
  800cb8:	fc                   	cld    
  800cb9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cbe:	83 c4 10             	add    $0x10,%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cc6:	f3 0f 1e fb          	endbr32 
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	e8 4a f4 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800cd2:	05 2e 13 00 00       	add    $0x132e,%eax
	return memmove(dst, src, n);
  800cd7:	ff 75 10             	pushl  0x10(%ebp)
  800cda:	ff 75 0c             	pushl  0xc(%ebp)
  800cdd:	ff 75 08             	pushl  0x8(%ebp)
  800ce0:	e8 f9 fe ff ff       	call   800bde <memmove>
  800ce5:	83 c4 0c             	add    $0xc,%esp
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    

00800cea <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cea:	f3 0f 1e fb          	endbr32 
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	83 ec 10             	sub    $0x10,%esp
  800cf4:	e8 23 f4 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800cf9:	05 07 13 00 00       	add    $0x1307,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d0a:	eb 30                	jmp    800d3c <memcmp+0x52>
		if (*s1 != *s2)
  800d0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0f:	0f b6 10             	movzbl (%eax),%edx
  800d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d15:	0f b6 00             	movzbl (%eax),%eax
  800d18:	38 c2                	cmp    %al,%dl
  800d1a:	74 18                	je     800d34 <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1f:	0f b6 00             	movzbl (%eax),%eax
  800d22:	0f b6 d0             	movzbl %al,%edx
  800d25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d28:	0f b6 00             	movzbl (%eax),%eax
  800d2b:	0f b6 c0             	movzbl %al,%eax
  800d2e:	29 c2                	sub    %eax,%edx
  800d30:	89 d0                	mov    %edx,%eax
  800d32:	eb 1a                	jmp    800d4e <memcmp+0x64>
		s1++, s2++;
  800d34:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800d38:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d42:	89 55 10             	mov    %edx,0x10(%ebp)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	75 c3                	jne    800d0c <memcmp+0x22>
	}

	return 0;
  800d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d50:	f3 0f 1e fb          	endbr32 
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 10             	sub    $0x10,%esp
  800d5a:	e8 bd f3 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800d5f:	05 a1 12 00 00       	add    $0x12a1,%eax
	const void *ends = (const char *) s + n;
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	01 d0                	add    %edx,%eax
  800d6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d6f:	eb 11                	jmp    800d82 <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	0f b6 00             	movzbl (%eax),%eax
  800d77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7a:	38 d0                	cmp    %dl,%al
  800d7c:	74 0e                	je     800d8c <memfind+0x3c>
	for (; s < ends; s++)
  800d7e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d88:	72 e7                	jb     800d71 <memfind+0x21>
  800d8a:	eb 01                	jmp    800d8d <memfind+0x3d>
			break;
  800d8c:	90                   	nop
	return (void *) s;
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d90:	c9                   	leave  
  800d91:	c3                   	ret    

00800d92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d92:	f3 0f 1e fb          	endbr32 
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 10             	sub    $0x10,%esp
  800d9c:	e8 7b f3 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800da1:	05 5f 12 00 00       	add    $0x125f,%eax
	int neg = 0;
  800da6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800dad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800db4:	eb 04                	jmp    800dba <strtol+0x28>
		s++;
  800db6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	0f b6 00             	movzbl (%eax),%eax
  800dc0:	3c 20                	cmp    $0x20,%al
  800dc2:	74 f2                	je     800db6 <strtol+0x24>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	0f b6 00             	movzbl (%eax),%eax
  800dca:	3c 09                	cmp    $0x9,%al
  800dcc:	74 e8                	je     800db6 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	0f b6 00             	movzbl (%eax),%eax
  800dd4:	3c 2b                	cmp    $0x2b,%al
  800dd6:	75 06                	jne    800dde <strtol+0x4c>
		s++;
  800dd8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ddc:	eb 15                	jmp    800df3 <strtol+0x61>
	else if (*s == '-')
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	0f b6 00             	movzbl (%eax),%eax
  800de4:	3c 2d                	cmp    $0x2d,%al
  800de6:	75 0b                	jne    800df3 <strtol+0x61>
		s++, neg = 1;
  800de8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800df3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df7:	74 06                	je     800dff <strtol+0x6d>
  800df9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800dfd:	75 24                	jne    800e23 <strtol+0x91>
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	0f b6 00             	movzbl (%eax),%eax
  800e05:	3c 30                	cmp    $0x30,%al
  800e07:	75 1a                	jne    800e23 <strtol+0x91>
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	83 c0 01             	add    $0x1,%eax
  800e0f:	0f b6 00             	movzbl (%eax),%eax
  800e12:	3c 78                	cmp    $0x78,%al
  800e14:	75 0d                	jne    800e23 <strtol+0x91>
		s += 2, base = 16;
  800e16:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e1a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e21:	eb 2a                	jmp    800e4d <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
  800e23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e27:	75 17                	jne    800e40 <strtol+0xae>
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	0f b6 00             	movzbl (%eax),%eax
  800e2f:	3c 30                	cmp    $0x30,%al
  800e31:	75 0d                	jne    800e40 <strtol+0xae>
		s++, base = 8;
  800e33:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e37:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e3e:	eb 0d                	jmp    800e4d <strtol+0xbb>
	else if (base == 0)
  800e40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e44:	75 07                	jne    800e4d <strtol+0xbb>
		base = 10;
  800e46:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	0f b6 00             	movzbl (%eax),%eax
  800e53:	3c 2f                	cmp    $0x2f,%al
  800e55:	7e 1b                	jle    800e72 <strtol+0xe0>
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	0f b6 00             	movzbl (%eax),%eax
  800e5d:	3c 39                	cmp    $0x39,%al
  800e5f:	7f 11                	jg     800e72 <strtol+0xe0>
			dig = *s - '0';
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	0f b6 00             	movzbl (%eax),%eax
  800e67:	0f be c0             	movsbl %al,%eax
  800e6a:	83 e8 30             	sub    $0x30,%eax
  800e6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e70:	eb 48                	jmp    800eba <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	0f b6 00             	movzbl (%eax),%eax
  800e78:	3c 60                	cmp    $0x60,%al
  800e7a:	7e 1b                	jle    800e97 <strtol+0x105>
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	0f b6 00             	movzbl (%eax),%eax
  800e82:	3c 7a                	cmp    $0x7a,%al
  800e84:	7f 11                	jg     800e97 <strtol+0x105>
			dig = *s - 'a' + 10;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	0f b6 00             	movzbl (%eax),%eax
  800e8c:	0f be c0             	movsbl %al,%eax
  800e8f:	83 e8 57             	sub    $0x57,%eax
  800e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e95:	eb 23                	jmp    800eba <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	0f b6 00             	movzbl (%eax),%eax
  800e9d:	3c 40                	cmp    $0x40,%al
  800e9f:	7e 3c                	jle    800edd <strtol+0x14b>
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	0f b6 00             	movzbl (%eax),%eax
  800ea7:	3c 5a                	cmp    $0x5a,%al
  800ea9:	7f 32                	jg     800edd <strtol+0x14b>
			dig = *s - 'A' + 10;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	0f b6 00             	movzbl (%eax),%eax
  800eb1:	0f be c0             	movsbl %al,%eax
  800eb4:	83 e8 37             	sub    $0x37,%eax
  800eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec0:	7d 1a                	jge    800edc <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
  800ec2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ecd:	89 c2                	mov    %eax,%edx
  800ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed2:	01 d0                	add    %edx,%eax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
  800ed7:	e9 71 ff ff ff       	jmp    800e4d <strtol+0xbb>
			break;
  800edc:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
  800edd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ee1:	74 08                	je     800eeb <strtol+0x159>
		*endptr = (char *) s;
  800ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800eeb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800eef:	74 07                	je     800ef8 <strtol+0x166>
  800ef1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef4:	f7 d8                	neg    %eax
  800ef6:	eb 03                	jmp    800efb <strtol+0x169>
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
  800f03:	83 ec 2c             	sub    $0x2c,%esp
  800f06:	e8 e3 f1 ff ff       	call   8000ee <__x86.get_pc_thunk.bx>
  800f0b:	81 c3 f5 10 00 00    	add    $0x10f5,%ebx
  800f11:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8b 55 10             	mov    0x10(%ebp),%edx
  800f1a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800f1d:	8b 5d 18             	mov    0x18(%ebp),%ebx
  800f20:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  800f23:	8b 75 20             	mov    0x20(%ebp),%esi
  800f26:	cd 30                	int    $0x30
  800f28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f2f:	74 27                	je     800f58 <syscall+0x5b>
  800f31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f35:	7e 21                	jle    800f58 <syscall+0x5b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f37:	83 ec 0c             	sub    $0xc,%esp
  800f3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f3d:	ff 75 08             	pushl  0x8(%ebp)
  800f40:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800f43:	8d 83 f0 f4 ff ff    	lea    -0xb10(%ebx),%eax
  800f49:	50                   	push   %eax
  800f4a:	6a 23                	push   $0x23
  800f4c:	8d 83 0d f5 ff ff    	lea    -0xaf3(%ebx),%eax
  800f52:	50                   	push   %eax
  800f53:	e8 cd 00 00 00       	call   801025 <_panic>

	return ret;
  800f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  800f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800f63:	f3 0f 1e fb          	endbr32 
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 08             	sub    $0x8,%esp
  800f6d:	e8 aa f1 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800f72:	05 8e 10 00 00       	add    $0x108e,%eax
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	83 ec 04             	sub    $0x4,%esp
  800f7d:	6a 00                	push   $0x0
  800f7f:	6a 00                	push   $0x0
  800f81:	6a 00                	push   $0x0
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	50                   	push   %eax
  800f87:	6a 00                	push   $0x0
  800f89:	6a 00                	push   $0x0
  800f8b:	e8 6d ff ff ff       	call   800efd <syscall>
  800f90:	83 c4 20             	add    $0x20,%esp
}
  800f93:	90                   	nop
  800f94:	c9                   	leave  
  800f95:	c3                   	ret    

00800f96 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f96:	f3 0f 1e fb          	endbr32 
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	e8 77 f1 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800fa5:	05 5b 10 00 00       	add    $0x105b,%eax
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800faa:	83 ec 04             	sub    $0x4,%esp
  800fad:	6a 00                	push   $0x0
  800faf:	6a 00                	push   $0x0
  800fb1:	6a 00                	push   $0x0
  800fb3:	6a 00                	push   $0x0
  800fb5:	6a 00                	push   $0x0
  800fb7:	6a 00                	push   $0x0
  800fb9:	6a 01                	push   $0x1
  800fbb:	e8 3d ff ff ff       	call   800efd <syscall>
  800fc0:	83 c4 20             	add    $0x20,%esp
}
  800fc3:	c9                   	leave  
  800fc4:	c3                   	ret    

00800fc5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fc5:	f3 0f 1e fb          	endbr32 
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	83 ec 08             	sub    $0x8,%esp
  800fcf:	e8 48 f1 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  800fd4:	05 2c 10 00 00       	add    $0x102c,%eax
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	6a 00                	push   $0x0
  800fe1:	6a 00                	push   $0x0
  800fe3:	6a 00                	push   $0x0
  800fe5:	6a 00                	push   $0x0
  800fe7:	50                   	push   %eax
  800fe8:	6a 01                	push   $0x1
  800fea:	6a 03                	push   $0x3
  800fec:	e8 0c ff ff ff       	call   800efd <syscall>
  800ff1:	83 c4 20             	add    $0x20,%esp
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ff6:	f3 0f 1e fb          	endbr32 
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 08             	sub    $0x8,%esp
  801000:	e8 17 f1 ff ff       	call   80011c <__x86.get_pc_thunk.ax>
  801005:	05 fb 0f 00 00       	add    $0xffb,%eax
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80100a:	83 ec 04             	sub    $0x4,%esp
  80100d:	6a 00                	push   $0x0
  80100f:	6a 00                	push   $0x0
  801011:	6a 00                	push   $0x0
  801013:	6a 00                	push   $0x0
  801015:	6a 00                	push   $0x0
  801017:	6a 00                	push   $0x0
  801019:	6a 02                	push   $0x2
  80101b:	e8 dd fe ff ff       	call   800efd <syscall>
  801020:	83 c4 20             	add    $0x20,%esp
}
  801023:	c9                   	leave  
  801024:	c3                   	ret    

00801025 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801025:	f3 0f 1e fb          	endbr32 
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	56                   	push   %esi
  80102d:	53                   	push   %ebx
  80102e:	83 ec 10             	sub    $0x10,%esp
  801031:	e8 b8 f0 ff ff       	call   8000ee <__x86.get_pc_thunk.bx>
  801036:	81 c3 ca 0f 00 00    	add    $0xfca,%ebx
	va_list ap;

	va_start(ap, fmt);
  80103c:	8d 45 14             	lea    0x14(%ebp),%eax
  80103f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801042:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  801048:	8b 30                	mov    (%eax),%esi
  80104a:	e8 a7 ff ff ff       	call   800ff6 <sys_getenvid>
  80104f:	83 ec 0c             	sub    $0xc,%esp
  801052:	ff 75 0c             	pushl  0xc(%ebp)
  801055:	ff 75 08             	pushl  0x8(%ebp)
  801058:	56                   	push   %esi
  801059:	50                   	push   %eax
  80105a:	8d 83 1c f5 ff ff    	lea    -0xae4(%ebx),%eax
  801060:	50                   	push   %eax
  801061:	e8 9f f1 ff ff       	call   800205 <cprintf>
  801066:	83 c4 20             	add    $0x20,%esp
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	50                   	push   %eax
  801070:	ff 75 10             	pushl  0x10(%ebp)
  801073:	e8 1d f1 ff ff       	call   800195 <vcprintf>
  801078:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  80107b:	83 ec 0c             	sub    $0xc,%esp
  80107e:	8d 83 3f f5 ff ff    	lea    -0xac1(%ebx),%eax
  801084:	50                   	push   %eax
  801085:	e8 7b f1 ff ff       	call   800205 <cprintf>
  80108a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80108d:	cc                   	int3   
  80108e:	eb fd                	jmp    80108d <_panic+0x68>

00801090 <__udivdi3>:
  801090:	f3 0f 1e fb          	endbr32 
  801094:	55                   	push   %ebp
  801095:	57                   	push   %edi
  801096:	56                   	push   %esi
  801097:	53                   	push   %ebx
  801098:	83 ec 1c             	sub    $0x1c,%esp
  80109b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80109f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8010a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8010a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8010ab:	85 d2                	test   %edx,%edx
  8010ad:	75 19                	jne    8010c8 <__udivdi3+0x38>
  8010af:	39 f3                	cmp    %esi,%ebx
  8010b1:	76 4d                	jbe    801100 <__udivdi3+0x70>
  8010b3:	31 ff                	xor    %edi,%edi
  8010b5:	89 e8                	mov    %ebp,%eax
  8010b7:	89 f2                	mov    %esi,%edx
  8010b9:	f7 f3                	div    %ebx
  8010bb:	89 fa                	mov    %edi,%edx
  8010bd:	83 c4 1c             	add    $0x1c,%esp
  8010c0:	5b                   	pop    %ebx
  8010c1:	5e                   	pop    %esi
  8010c2:	5f                   	pop    %edi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    
  8010c5:	8d 76 00             	lea    0x0(%esi),%esi
  8010c8:	39 f2                	cmp    %esi,%edx
  8010ca:	76 14                	jbe    8010e0 <__udivdi3+0x50>
  8010cc:	31 ff                	xor    %edi,%edi
  8010ce:	31 c0                	xor    %eax,%eax
  8010d0:	89 fa                	mov    %edi,%edx
  8010d2:	83 c4 1c             	add    $0x1c,%esp
  8010d5:	5b                   	pop    %ebx
  8010d6:	5e                   	pop    %esi
  8010d7:	5f                   	pop    %edi
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    
  8010da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010e0:	0f bd fa             	bsr    %edx,%edi
  8010e3:	83 f7 1f             	xor    $0x1f,%edi
  8010e6:	75 48                	jne    801130 <__udivdi3+0xa0>
  8010e8:	39 f2                	cmp    %esi,%edx
  8010ea:	72 06                	jb     8010f2 <__udivdi3+0x62>
  8010ec:	31 c0                	xor    %eax,%eax
  8010ee:	39 eb                	cmp    %ebp,%ebx
  8010f0:	77 de                	ja     8010d0 <__udivdi3+0x40>
  8010f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8010f7:	eb d7                	jmp    8010d0 <__udivdi3+0x40>
  8010f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801100:	89 d9                	mov    %ebx,%ecx
  801102:	85 db                	test   %ebx,%ebx
  801104:	75 0b                	jne    801111 <__udivdi3+0x81>
  801106:	b8 01 00 00 00       	mov    $0x1,%eax
  80110b:	31 d2                	xor    %edx,%edx
  80110d:	f7 f3                	div    %ebx
  80110f:	89 c1                	mov    %eax,%ecx
  801111:	31 d2                	xor    %edx,%edx
  801113:	89 f0                	mov    %esi,%eax
  801115:	f7 f1                	div    %ecx
  801117:	89 c6                	mov    %eax,%esi
  801119:	89 e8                	mov    %ebp,%eax
  80111b:	89 f7                	mov    %esi,%edi
  80111d:	f7 f1                	div    %ecx
  80111f:	89 fa                	mov    %edi,%edx
  801121:	83 c4 1c             	add    $0x1c,%esp
  801124:	5b                   	pop    %ebx
  801125:	5e                   	pop    %esi
  801126:	5f                   	pop    %edi
  801127:	5d                   	pop    %ebp
  801128:	c3                   	ret    
  801129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801130:	89 f9                	mov    %edi,%ecx
  801132:	b8 20 00 00 00       	mov    $0x20,%eax
  801137:	29 f8                	sub    %edi,%eax
  801139:	d3 e2                	shl    %cl,%edx
  80113b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80113f:	89 c1                	mov    %eax,%ecx
  801141:	89 da                	mov    %ebx,%edx
  801143:	d3 ea                	shr    %cl,%edx
  801145:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801149:	09 d1                	or     %edx,%ecx
  80114b:	89 f2                	mov    %esi,%edx
  80114d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801151:	89 f9                	mov    %edi,%ecx
  801153:	d3 e3                	shl    %cl,%ebx
  801155:	89 c1                	mov    %eax,%ecx
  801157:	d3 ea                	shr    %cl,%edx
  801159:	89 f9                	mov    %edi,%ecx
  80115b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80115f:	89 eb                	mov    %ebp,%ebx
  801161:	d3 e6                	shl    %cl,%esi
  801163:	89 c1                	mov    %eax,%ecx
  801165:	d3 eb                	shr    %cl,%ebx
  801167:	09 de                	or     %ebx,%esi
  801169:	89 f0                	mov    %esi,%eax
  80116b:	f7 74 24 08          	divl   0x8(%esp)
  80116f:	89 d6                	mov    %edx,%esi
  801171:	89 c3                	mov    %eax,%ebx
  801173:	f7 64 24 0c          	mull   0xc(%esp)
  801177:	39 d6                	cmp    %edx,%esi
  801179:	72 15                	jb     801190 <__udivdi3+0x100>
  80117b:	89 f9                	mov    %edi,%ecx
  80117d:	d3 e5                	shl    %cl,%ebp
  80117f:	39 c5                	cmp    %eax,%ebp
  801181:	73 04                	jae    801187 <__udivdi3+0xf7>
  801183:	39 d6                	cmp    %edx,%esi
  801185:	74 09                	je     801190 <__udivdi3+0x100>
  801187:	89 d8                	mov    %ebx,%eax
  801189:	31 ff                	xor    %edi,%edi
  80118b:	e9 40 ff ff ff       	jmp    8010d0 <__udivdi3+0x40>
  801190:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801193:	31 ff                	xor    %edi,%edi
  801195:	e9 36 ff ff ff       	jmp    8010d0 <__udivdi3+0x40>
  80119a:	66 90                	xchg   %ax,%ax
  80119c:	66 90                	xchg   %ax,%ax
  80119e:	66 90                	xchg   %ax,%ax

008011a0 <__umoddi3>:
  8011a0:	f3 0f 1e fb          	endbr32 
  8011a4:	55                   	push   %ebp
  8011a5:	57                   	push   %edi
  8011a6:	56                   	push   %esi
  8011a7:	53                   	push   %ebx
  8011a8:	83 ec 1c             	sub    $0x1c,%esp
  8011ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8011af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8011b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8011b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	75 19                	jne    8011d8 <__umoddi3+0x38>
  8011bf:	39 df                	cmp    %ebx,%edi
  8011c1:	76 5d                	jbe    801220 <__umoddi3+0x80>
  8011c3:	89 f0                	mov    %esi,%eax
  8011c5:	89 da                	mov    %ebx,%edx
  8011c7:	f7 f7                	div    %edi
  8011c9:	89 d0                	mov    %edx,%eax
  8011cb:	31 d2                	xor    %edx,%edx
  8011cd:	83 c4 1c             	add    $0x1c,%esp
  8011d0:	5b                   	pop    %ebx
  8011d1:	5e                   	pop    %esi
  8011d2:	5f                   	pop    %edi
  8011d3:	5d                   	pop    %ebp
  8011d4:	c3                   	ret    
  8011d5:	8d 76 00             	lea    0x0(%esi),%esi
  8011d8:	89 f2                	mov    %esi,%edx
  8011da:	39 d8                	cmp    %ebx,%eax
  8011dc:	76 12                	jbe    8011f0 <__umoddi3+0x50>
  8011de:	89 f0                	mov    %esi,%eax
  8011e0:	89 da                	mov    %ebx,%edx
  8011e2:	83 c4 1c             	add    $0x1c,%esp
  8011e5:	5b                   	pop    %ebx
  8011e6:	5e                   	pop    %esi
  8011e7:	5f                   	pop    %edi
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    
  8011ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011f0:	0f bd e8             	bsr    %eax,%ebp
  8011f3:	83 f5 1f             	xor    $0x1f,%ebp
  8011f6:	75 50                	jne    801248 <__umoddi3+0xa8>
  8011f8:	39 d8                	cmp    %ebx,%eax
  8011fa:	0f 82 e0 00 00 00    	jb     8012e0 <__umoddi3+0x140>
  801200:	89 d9                	mov    %ebx,%ecx
  801202:	39 f7                	cmp    %esi,%edi
  801204:	0f 86 d6 00 00 00    	jbe    8012e0 <__umoddi3+0x140>
  80120a:	89 d0                	mov    %edx,%eax
  80120c:	89 ca                	mov    %ecx,%edx
  80120e:	83 c4 1c             	add    $0x1c,%esp
  801211:	5b                   	pop    %ebx
  801212:	5e                   	pop    %esi
  801213:	5f                   	pop    %edi
  801214:	5d                   	pop    %ebp
  801215:	c3                   	ret    
  801216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80121d:	8d 76 00             	lea    0x0(%esi),%esi
  801220:	89 fd                	mov    %edi,%ebp
  801222:	85 ff                	test   %edi,%edi
  801224:	75 0b                	jne    801231 <__umoddi3+0x91>
  801226:	b8 01 00 00 00       	mov    $0x1,%eax
  80122b:	31 d2                	xor    %edx,%edx
  80122d:	f7 f7                	div    %edi
  80122f:	89 c5                	mov    %eax,%ebp
  801231:	89 d8                	mov    %ebx,%eax
  801233:	31 d2                	xor    %edx,%edx
  801235:	f7 f5                	div    %ebp
  801237:	89 f0                	mov    %esi,%eax
  801239:	f7 f5                	div    %ebp
  80123b:	89 d0                	mov    %edx,%eax
  80123d:	31 d2                	xor    %edx,%edx
  80123f:	eb 8c                	jmp    8011cd <__umoddi3+0x2d>
  801241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801248:	89 e9                	mov    %ebp,%ecx
  80124a:	ba 20 00 00 00       	mov    $0x20,%edx
  80124f:	29 ea                	sub    %ebp,%edx
  801251:	d3 e0                	shl    %cl,%eax
  801253:	89 44 24 08          	mov    %eax,0x8(%esp)
  801257:	89 d1                	mov    %edx,%ecx
  801259:	89 f8                	mov    %edi,%eax
  80125b:	d3 e8                	shr    %cl,%eax
  80125d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801261:	89 54 24 04          	mov    %edx,0x4(%esp)
  801265:	8b 54 24 04          	mov    0x4(%esp),%edx
  801269:	09 c1                	or     %eax,%ecx
  80126b:	89 d8                	mov    %ebx,%eax
  80126d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801271:	89 e9                	mov    %ebp,%ecx
  801273:	d3 e7                	shl    %cl,%edi
  801275:	89 d1                	mov    %edx,%ecx
  801277:	d3 e8                	shr    %cl,%eax
  801279:	89 e9                	mov    %ebp,%ecx
  80127b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80127f:	d3 e3                	shl    %cl,%ebx
  801281:	89 c7                	mov    %eax,%edi
  801283:	89 d1                	mov    %edx,%ecx
  801285:	89 f0                	mov    %esi,%eax
  801287:	d3 e8                	shr    %cl,%eax
  801289:	89 e9                	mov    %ebp,%ecx
  80128b:	89 fa                	mov    %edi,%edx
  80128d:	d3 e6                	shl    %cl,%esi
  80128f:	09 d8                	or     %ebx,%eax
  801291:	f7 74 24 08          	divl   0x8(%esp)
  801295:	89 d1                	mov    %edx,%ecx
  801297:	89 f3                	mov    %esi,%ebx
  801299:	f7 64 24 0c          	mull   0xc(%esp)
  80129d:	89 c6                	mov    %eax,%esi
  80129f:	89 d7                	mov    %edx,%edi
  8012a1:	39 d1                	cmp    %edx,%ecx
  8012a3:	72 06                	jb     8012ab <__umoddi3+0x10b>
  8012a5:	75 10                	jne    8012b7 <__umoddi3+0x117>
  8012a7:	39 c3                	cmp    %eax,%ebx
  8012a9:	73 0c                	jae    8012b7 <__umoddi3+0x117>
  8012ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8012af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8012b3:	89 d7                	mov    %edx,%edi
  8012b5:	89 c6                	mov    %eax,%esi
  8012b7:	89 ca                	mov    %ecx,%edx
  8012b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8012be:	29 f3                	sub    %esi,%ebx
  8012c0:	19 fa                	sbb    %edi,%edx
  8012c2:	89 d0                	mov    %edx,%eax
  8012c4:	d3 e0                	shl    %cl,%eax
  8012c6:	89 e9                	mov    %ebp,%ecx
  8012c8:	d3 eb                	shr    %cl,%ebx
  8012ca:	d3 ea                	shr    %cl,%edx
  8012cc:	09 d8                	or     %ebx,%eax
  8012ce:	83 c4 1c             	add    $0x1c,%esp
  8012d1:	5b                   	pop    %ebx
  8012d2:	5e                   	pop    %esi
  8012d3:	5f                   	pop    %edi
  8012d4:	5d                   	pop    %ebp
  8012d5:	c3                   	ret    
  8012d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012dd:	8d 76 00             	lea    0x0(%esi),%esi
  8012e0:	29 fe                	sub    %edi,%esi
  8012e2:	19 c3                	sbb    %eax,%ebx
  8012e4:	89 f2                	mov    %esi,%edx
  8012e6:	89 d9                	mov    %ebx,%ecx
  8012e8:	e9 1d ff ff ff       	jmp    80120a <__umoddi3+0x6a>
