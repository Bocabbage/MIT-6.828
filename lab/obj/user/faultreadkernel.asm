
obj/user/faultreadkernel:     file format elf32-i386


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
  80002c:	e8 3d 00 00 00       	call   80006e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	e8 27 00 00 00       	call   80006a <__x86.get_pc_thunk.ax>
  800043:	05 bd 1f 00 00       	add    $0x1fbd,%eax
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800048:	ba 00 00 10 f0       	mov    $0xf0100000,%edx
  80004d:	8b 12                	mov    (%edx),%edx
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	52                   	push   %edx
  800053:	8d 90 e0 f2 ff ff    	lea    -0xd20(%eax),%edx
  800059:	52                   	push   %edx
  80005a:	89 c3                	mov    %eax,%ebx
  80005c:	e8 8a 01 00 00       	call   8001eb <cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
}
  800064:	90                   	nop
  800065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800068:	c9                   	leave  
  800069:	c3                   	ret    

0080006a <__x86.get_pc_thunk.ax>:
  80006a:	8b 04 24             	mov    (%esp),%eax
  80006d:	c3                   	ret    

0080006e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006e:	f3 0f 1e fb          	endbr32 
  800072:	55                   	push   %ebp
  800073:	89 e5                	mov    %esp,%ebp
  800075:	53                   	push   %ebx
  800076:	83 ec 04             	sub    $0x4,%esp
  800079:	e8 5a 00 00 00       	call   8000d8 <__x86.get_pc_thunk.bx>
  80007e:	81 c3 82 1f 00 00    	add    $0x1f82,%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code h(ere.
	thisenv = envs + ENVX(sys_getenvid());
  800084:	e8 53 0f 00 00       	call   800fdc <sys_getenvid>
  800089:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008e:	89 c2                	mov    %eax,%edx
  800090:	89 d0                	mov    %edx,%eax
  800092:	01 c0                	add    %eax,%eax
  800094:	01 d0                	add    %edx,%eax
  800096:	c1 e0 05             	shl    $0x5,%eax
  800099:	89 c2                	mov    %eax,%edx
  80009b:	c7 c0 00 00 c0 ee    	mov    $0xeec00000,%eax
  8000a1:	01 c2                	add    %eax,%edx
  8000a3:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  8000a9:	89 10                	mov    %edx,(%eax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000af:	7e 0b                	jle    8000bc <libmain+0x4e>
		binaryname = argv[0];
  8000b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b4:	8b 00                	mov    (%eax),%eax
  8000b6:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000bc:	83 ec 08             	sub    $0x8,%esp
  8000bf:	ff 75 0c             	pushl  0xc(%ebp)
  8000c2:	ff 75 08             	pushl  0x8(%ebp)
  8000c5:	e8 69 ff ff ff       	call   800033 <umain>
  8000ca:	83 c4 10             	add    $0x10,%esp

	// exit gracefully
	exit();
  8000cd:	e8 0a 00 00 00       	call   8000dc <exit>
}
  8000d2:	90                   	nop
  8000d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d6:	c9                   	leave  
  8000d7:	c3                   	ret    

008000d8 <__x86.get_pc_thunk.bx>:
  8000d8:	8b 1c 24             	mov    (%esp),%ebx
  8000db:	c3                   	ret    

008000dc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000dc:	f3 0f 1e fb          	endbr32 
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	53                   	push   %ebx
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	e8 7e ff ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  8000ec:	05 14 1f 00 00       	add    $0x1f14,%eax
	sys_env_destroy(0);
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	6a 00                	push   $0x0
  8000f6:	89 c3                	mov    %eax,%ebx
  8000f8:	e8 ae 0e 00 00       	call   800fab <sys_env_destroy>
  8000fd:	83 c4 10             	add    $0x10,%esp
}
  800100:	90                   	nop
  800101:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800104:	c9                   	leave  
  800105:	c3                   	ret    

00800106 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800106:	f3 0f 1e fb          	endbr32 
  80010a:	55                   	push   %ebp
  80010b:	89 e5                	mov    %esp,%ebp
  80010d:	53                   	push   %ebx
  80010e:	83 ec 04             	sub    $0x4,%esp
  800111:	e8 09 01 00 00       	call   80021f <__x86.get_pc_thunk.dx>
  800116:	81 c2 ea 1e 00 00    	add    $0x1eea,%edx
	b->buf[b->idx++] = ch;
  80011c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011f:	8b 00                	mov    (%eax),%eax
  800121:	8d 58 01             	lea    0x1(%eax),%ebx
  800124:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800127:	89 19                	mov    %ebx,(%ecx)
  800129:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012c:	89 cb                	mov    %ecx,%ebx
  80012e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800131:	88 5c 01 08          	mov    %bl,0x8(%ecx,%eax,1)
	if (b->idx == 256-1) {
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	8b 00                	mov    (%eax),%eax
  80013a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013f:	75 25                	jne    800166 <putch+0x60>
		sys_cputs(b->buf, b->idx);
  800141:	8b 45 0c             	mov    0xc(%ebp),%eax
  800144:	8b 00                	mov    (%eax),%eax
  800146:	89 c1                	mov    %eax,%ecx
  800148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014b:	83 c0 08             	add    $0x8,%eax
  80014e:	83 ec 08             	sub    $0x8,%esp
  800151:	51                   	push   %ecx
  800152:	50                   	push   %eax
  800153:	89 d3                	mov    %edx,%ebx
  800155:	e8 ef 0d 00 00       	call   800f49 <sys_cputs>
  80015a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80015d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800160:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800166:	8b 45 0c             	mov    0xc(%ebp),%eax
  800169:	8b 40 04             	mov    0x4(%eax),%eax
  80016c:	8d 50 01             	lea    0x1(%eax),%edx
  80016f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800172:	89 50 04             	mov    %edx,0x4(%eax)
}
  800175:	90                   	nop
  800176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800179:	c9                   	leave  
  80017a:	c3                   	ret    

0080017b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80017b:	f3 0f 1e fb          	endbr32 
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	53                   	push   %ebx
  800183:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800189:	e8 4a ff ff ff       	call   8000d8 <__x86.get_pc_thunk.bx>
  80018e:	81 c3 72 1e 00 00    	add    $0x1e72,%ebx
	struct printbuf b;

	b.idx = 0;
  800194:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80019b:	00 00 00 
	b.cnt = 0;
  80019e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a8:	ff 75 0c             	pushl  0xc(%ebp)
  8001ab:	ff 75 08             	pushl  0x8(%ebp)
  8001ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	8d 83 06 e1 ff ff    	lea    -0x1efa(%ebx),%eax
  8001bb:	50                   	push   %eax
  8001bc:	e8 e3 01 00 00       	call   8003a4 <vprintfmt>
  8001c1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8001c4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001ca:	83 ec 08             	sub    $0x8,%esp
  8001cd:	50                   	push   %eax
  8001ce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d4:	83 c0 08             	add    $0x8,%eax
  8001d7:	50                   	push   %eax
  8001d8:	e8 6c 0d 00 00       	call   800f49 <sys_cputs>
  8001dd:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8001e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8001e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001eb:	f3 0f 1e fb          	endbr32 
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	83 ec 18             	sub    $0x18,%esp
  8001f5:	e8 70 fe ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  8001fa:	05 06 1e 00 00       	add    $0x1e06,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ff:	8d 45 0c             	lea    0xc(%ebp),%eax
  800202:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
  800205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800208:	83 ec 08             	sub    $0x8,%esp
  80020b:	50                   	push   %eax
  80020c:	ff 75 08             	pushl  0x8(%ebp)
  80020f:	e8 67 ff ff ff       	call   80017b <vcprintf>
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
  80021a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80021d:	c9                   	leave  
  80021e:	c3                   	ret    

0080021f <__x86.get_pc_thunk.dx>:
  80021f:	8b 14 24             	mov    (%esp),%edx
  800222:	c3                   	ret    

00800223 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800223:	f3 0f 1e fb          	endbr32 
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	57                   	push   %edi
  80022b:	56                   	push   %esi
  80022c:	53                   	push   %ebx
  80022d:	83 ec 1c             	sub    $0x1c,%esp
  800230:	e8 43 06 00 00       	call   800878 <__x86.get_pc_thunk.si>
  800235:	81 c6 cb 1d 00 00    	add    $0x1dcb,%esi
  80023b:	8b 45 10             	mov    0x10(%ebp),%eax
  80023e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800241:	8b 45 14             	mov    0x14(%ebp),%eax
  800244:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800247:	8b 45 18             	mov    0x18(%ebp),%eax
  80024a:	ba 00 00 00 00       	mov    $0x0,%edx
  80024f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800252:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  800255:	19 d1                	sbb    %edx,%ecx
  800257:	72 4d                	jb     8002a6 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800259:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80025c:	8d 78 ff             	lea    -0x1(%eax),%edi
  80025f:	8b 45 18             	mov    0x18(%ebp),%eax
  800262:	ba 00 00 00 00       	mov    $0x0,%edx
  800267:	52                   	push   %edx
  800268:	50                   	push   %eax
  800269:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026c:	ff 75 e0             	pushl  -0x20(%ebp)
  80026f:	89 f3                	mov    %esi,%ebx
  800271:	e8 0a 0e 00 00       	call   801080 <__udivdi3>
  800276:	83 c4 10             	add    $0x10,%esp
  800279:	83 ec 04             	sub    $0x4,%esp
  80027c:	ff 75 20             	pushl  0x20(%ebp)
  80027f:	57                   	push   %edi
  800280:	ff 75 18             	pushl  0x18(%ebp)
  800283:	52                   	push   %edx
  800284:	50                   	push   %eax
  800285:	ff 75 0c             	pushl  0xc(%ebp)
  800288:	ff 75 08             	pushl  0x8(%ebp)
  80028b:	e8 93 ff ff ff       	call   800223 <printnum>
  800290:	83 c4 20             	add    $0x20,%esp
  800293:	eb 1b                	jmp    8002b0 <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800295:	83 ec 08             	sub    $0x8,%esp
  800298:	ff 75 0c             	pushl  0xc(%ebp)
  80029b:	ff 75 20             	pushl  0x20(%ebp)
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	ff d0                	call   *%eax
  8002a3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002a6:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8002aa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8002ae:	7f e5                	jg     800295 <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002be:	53                   	push   %ebx
  8002bf:	51                   	push   %ecx
  8002c0:	52                   	push   %edx
  8002c1:	50                   	push   %eax
  8002c2:	89 f3                	mov    %esi,%ebx
  8002c4:	e8 c7 0e 00 00       	call   801190 <__umoddi3>
  8002c9:	83 c4 10             	add    $0x10,%esp
  8002cc:	8d 8e 7d f3 ff ff    	lea    -0xc83(%esi),%ecx
  8002d2:	01 c8                	add    %ecx,%eax
  8002d4:	0f b6 00             	movzbl (%eax),%eax
  8002d7:	0f be c0             	movsbl %al,%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	50                   	push   %eax
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	ff d0                	call   *%eax
  8002e6:	83 c4 10             	add    $0x10,%esp
}
  8002e9:	90                   	nop
  8002ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ed:	5b                   	pop    %ebx
  8002ee:	5e                   	pop    %esi
  8002ef:	5f                   	pop    %edi
  8002f0:	5d                   	pop    %ebp
  8002f1:	c3                   	ret    

008002f2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002f2:	f3 0f 1e fb          	endbr32 
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
  8002f9:	e8 6c fd ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  8002fe:	05 02 1d 00 00       	add    $0x1d02,%eax
	if (lflag >= 2)
  800303:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800307:	7e 14                	jle    80031d <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	8b 00                	mov    (%eax),%eax
  80030e:	8d 48 08             	lea    0x8(%eax),%ecx
  800311:	8b 55 08             	mov    0x8(%ebp),%edx
  800314:	89 0a                	mov    %ecx,(%edx)
  800316:	8b 50 04             	mov    0x4(%eax),%edx
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	eb 30                	jmp    80034d <getuint+0x5b>
	else if (lflag)
  80031d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800321:	74 16                	je     800339 <getuint+0x47>
		return va_arg(*ap, unsigned long);
  800323:	8b 45 08             	mov    0x8(%ebp),%eax
  800326:	8b 00                	mov    (%eax),%eax
  800328:	8d 48 04             	lea    0x4(%eax),%ecx
  80032b:	8b 55 08             	mov    0x8(%ebp),%edx
  80032e:	89 0a                	mov    %ecx,(%edx)
  800330:	8b 00                	mov    (%eax),%eax
  800332:	ba 00 00 00 00       	mov    $0x0,%edx
  800337:	eb 14                	jmp    80034d <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	8d 48 04             	lea    0x4(%eax),%ecx
  800341:	8b 55 08             	mov    0x8(%ebp),%edx
  800344:	89 0a                	mov    %ecx,(%edx)
  800346:	8b 00                	mov    (%eax),%eax
  800348:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80034f:	f3 0f 1e fb          	endbr32 
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	e8 0f fd ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  80035b:	05 a5 1c 00 00       	add    $0x1ca5,%eax
	if (lflag >= 2)
  800360:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800364:	7e 14                	jle    80037a <getint+0x2b>
		return va_arg(*ap, long long);
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	8b 00                	mov    (%eax),%eax
  80036b:	8d 48 08             	lea    0x8(%eax),%ecx
  80036e:	8b 55 08             	mov    0x8(%ebp),%edx
  800371:	89 0a                	mov    %ecx,(%edx)
  800373:	8b 50 04             	mov    0x4(%eax),%edx
  800376:	8b 00                	mov    (%eax),%eax
  800378:	eb 28                	jmp    8003a2 <getint+0x53>
	else if (lflag)
  80037a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80037e:	74 12                	je     800392 <getint+0x43>
		return va_arg(*ap, long);
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	8b 00                	mov    (%eax),%eax
  800385:	8d 48 04             	lea    0x4(%eax),%ecx
  800388:	8b 55 08             	mov    0x8(%ebp),%edx
  80038b:	89 0a                	mov    %ecx,(%edx)
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	99                   	cltd   
  800390:	eb 10                	jmp    8003a2 <getint+0x53>
	else
		return va_arg(*ap, int);
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	8b 00                	mov    (%eax),%eax
  800397:	8d 48 04             	lea    0x4(%eax),%ecx
  80039a:	8b 55 08             	mov    0x8(%ebp),%edx
  80039d:	89 0a                	mov    %ecx,(%edx)
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	99                   	cltd   
}
  8003a2:	5d                   	pop    %ebp
  8003a3:	c3                   	ret    

008003a4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003a4:	f3 0f 1e fb          	endbr32 
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	57                   	push   %edi
  8003ac:	56                   	push   %esi
  8003ad:	53                   	push   %ebx
  8003ae:	83 ec 2c             	sub    $0x2c,%esp
  8003b1:	e8 c6 04 00 00       	call   80087c <__x86.get_pc_thunk.di>
  8003b6:	81 c7 4a 1c 00 00    	add    $0x1c4a,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003bc:	eb 17                	jmp    8003d5 <vprintfmt+0x31>
			if (ch == '\0')
  8003be:	85 db                	test   %ebx,%ebx
  8003c0:	0f 84 96 03 00 00    	je     80075c <.L20+0x2d>
				return;
			putch(ch, putdat);
  8003c6:	83 ec 08             	sub    $0x8,%esp
  8003c9:	ff 75 0c             	pushl  0xc(%ebp)
  8003cc:	53                   	push   %ebx
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	ff d0                	call   *%eax
  8003d2:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d8:	8d 50 01             	lea    0x1(%eax),%edx
  8003db:	89 55 10             	mov    %edx,0x10(%ebp)
  8003de:	0f b6 00             	movzbl (%eax),%eax
  8003e1:	0f b6 d8             	movzbl %al,%ebx
  8003e4:	83 fb 25             	cmp    $0x25,%ebx
  8003e7:	75 d5                	jne    8003be <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
  8003e9:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
  8003ed:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
  8003f4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
  8003fb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
  800402:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800409:	8b 45 10             	mov    0x10(%ebp),%eax
  80040c:	8d 50 01             	lea    0x1(%eax),%edx
  80040f:	89 55 10             	mov    %edx,0x10(%ebp)
  800412:	0f b6 00             	movzbl (%eax),%eax
  800415:	0f b6 d8             	movzbl %al,%ebx
  800418:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80041b:	83 f8 55             	cmp    $0x55,%eax
  80041e:	0f 87 0b 03 00 00    	ja     80072f <.L20>
  800424:	c1 e0 02             	shl    $0x2,%eax
  800427:	8b 84 38 a4 f3 ff ff 	mov    -0xc5c(%eax,%edi,1),%eax
  80042e:	01 f8                	add    %edi,%eax
  800430:	3e ff e0             	notrack jmp *%eax

00800433 <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
  800433:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
  800437:	eb d0                	jmp    800409 <vprintfmt+0x65>

00800439 <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800439:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
  80043d:	eb ca                	jmp    800409 <vprintfmt+0x65>

0080043f <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80043f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
  800446:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800449:	89 d0                	mov    %edx,%eax
  80044b:	c1 e0 02             	shl    $0x2,%eax
  80044e:	01 d0                	add    %edx,%eax
  800450:	01 c0                	add    %eax,%eax
  800452:	01 d8                	add    %ebx,%eax
  800454:	83 e8 30             	sub    $0x30,%eax
  800457:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
  80045a:	8b 45 10             	mov    0x10(%ebp),%eax
  80045d:	0f b6 00             	movzbl (%eax),%eax
  800460:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800463:	83 fb 2f             	cmp    $0x2f,%ebx
  800466:	7e 39                	jle    8004a1 <.L37+0xc>
  800468:	83 fb 39             	cmp    $0x39,%ebx
  80046b:	7f 34                	jg     8004a1 <.L37+0xc>
			for (precision = 0; ; ++fmt) {
  80046d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
  800471:	eb d3                	jmp    800446 <.L31+0x7>

00800473 <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	8d 50 04             	lea    0x4(%eax),%edx
  800479:	89 55 14             	mov    %edx,0x14(%ebp)
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
  800481:	eb 1f                	jmp    8004a2 <.L37+0xd>

00800483 <.L33>:

		case '.':
			if (width < 0)
  800483:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800487:	79 80                	jns    800409 <vprintfmt+0x65>
				width = 0;
  800489:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
  800490:	e9 74 ff ff ff       	jmp    800409 <vprintfmt+0x65>

00800495 <.L37>:

		case '#':
			altflag = 1;
  800495:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
  80049c:	e9 68 ff ff ff       	jmp    800409 <vprintfmt+0x65>
			goto process_precision;
  8004a1:	90                   	nop

		process_precision:
			if (width < 0)
  8004a2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004a6:	0f 89 5d ff ff ff    	jns    800409 <vprintfmt+0x65>
				width = precision, precision = -1;
  8004ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004b2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
  8004b9:	e9 4b ff ff ff       	jmp    800409 <vprintfmt+0x65>

008004be <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004be:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004c2:	e9 42 ff ff ff       	jmp    800409 <vprintfmt+0x65>

008004c7 <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	8d 50 04             	lea    0x4(%eax),%edx
  8004cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	ff 75 0c             	pushl  0xc(%ebp)
  8004d8:	50                   	push   %eax
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	ff d0                	call   *%eax
  8004de:	83 c4 10             	add    $0x10,%esp
			break;
  8004e1:	e9 71 02 00 00       	jmp    800757 <.L20+0x28>

008004e6 <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e9:	8d 50 04             	lea    0x4(%eax),%edx
  8004ec:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ef:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8004f1:	85 db                	test   %ebx,%ebx
  8004f3:	79 02                	jns    8004f7 <.L28+0x11>
				err = -err;
  8004f5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004f7:	83 fb 06             	cmp    $0x6,%ebx
  8004fa:	7f 0b                	jg     800507 <.L28+0x21>
  8004fc:	8b b4 9f 10 00 00 00 	mov    0x10(%edi,%ebx,4),%esi
  800503:	85 f6                	test   %esi,%esi
  800505:	75 1b                	jne    800522 <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
  800507:	53                   	push   %ebx
  800508:	8d 87 8e f3 ff ff    	lea    -0xc72(%edi),%eax
  80050e:	50                   	push   %eax
  80050f:	ff 75 0c             	pushl  0xc(%ebp)
  800512:	ff 75 08             	pushl  0x8(%ebp)
  800515:	e8 4b 02 00 00       	call   800765 <printfmt>
  80051a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80051d:	e9 35 02 00 00       	jmp    800757 <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
  800522:	56                   	push   %esi
  800523:	8d 87 97 f3 ff ff    	lea    -0xc69(%edi),%eax
  800529:	50                   	push   %eax
  80052a:	ff 75 0c             	pushl  0xc(%ebp)
  80052d:	ff 75 08             	pushl  0x8(%ebp)
  800530:	e8 30 02 00 00       	call   800765 <printfmt>
  800535:	83 c4 10             	add    $0x10,%esp
			break;
  800538:	e9 1a 02 00 00       	jmp    800757 <.L20+0x28>

0080053d <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8d 50 04             	lea    0x4(%eax),%edx
  800543:	89 55 14             	mov    %edx,0x14(%ebp)
  800546:	8b 30                	mov    (%eax),%esi
  800548:	85 f6                	test   %esi,%esi
  80054a:	75 06                	jne    800552 <.L24+0x15>
				p = "(null)";
  80054c:	8d b7 9a f3 ff ff    	lea    -0xc66(%edi),%esi
			if (width > 0 && padc != '-')
  800552:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800556:	7e 71                	jle    8005c9 <.L24+0x8c>
  800558:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  80055c:	74 6b                	je     8005c9 <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80055e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	50                   	push   %eax
  800565:	56                   	push   %esi
  800566:	89 fb                	mov    %edi,%ebx
  800568:	e8 47 03 00 00       	call   8008b4 <strnlen>
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	29 45 d4             	sub    %eax,-0x2c(%ebp)
  800573:	eb 17                	jmp    80058c <.L24+0x4f>
					putch(padc, putdat);
  800575:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  800579:	83 ec 08             	sub    $0x8,%esp
  80057c:	ff 75 0c             	pushl  0xc(%ebp)
  80057f:	50                   	push   %eax
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	ff d0                	call   *%eax
  800585:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
  800588:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  80058c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800590:	7f e3                	jg     800575 <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800592:	eb 35                	jmp    8005c9 <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
  800594:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800598:	74 1c                	je     8005b6 <.L24+0x79>
  80059a:	83 fb 1f             	cmp    $0x1f,%ebx
  80059d:	7e 05                	jle    8005a4 <.L24+0x67>
  80059f:	83 fb 7e             	cmp    $0x7e,%ebx
  8005a2:	7e 12                	jle    8005b6 <.L24+0x79>
					putch('?', putdat);
  8005a4:	83 ec 08             	sub    $0x8,%esp
  8005a7:	ff 75 0c             	pushl  0xc(%ebp)
  8005aa:	6a 3f                	push   $0x3f
  8005ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8005af:	ff d0                	call   *%eax
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	eb 0f                	jmp    8005c5 <.L24+0x88>
				else
					putch(ch, putdat);
  8005b6:	83 ec 08             	sub    $0x8,%esp
  8005b9:	ff 75 0c             	pushl  0xc(%ebp)
  8005bc:	53                   	push   %ebx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	ff d0                	call   *%eax
  8005c2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c5:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  8005c9:	89 f0                	mov    %esi,%eax
  8005cb:	8d 70 01             	lea    0x1(%eax),%esi
  8005ce:	0f b6 00             	movzbl (%eax),%eax
  8005d1:	0f be d8             	movsbl %al,%ebx
  8005d4:	85 db                	test   %ebx,%ebx
  8005d6:	74 26                	je     8005fe <.L24+0xc1>
  8005d8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005dc:	78 b6                	js     800594 <.L24+0x57>
  8005de:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  8005e2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005e6:	79 ac                	jns    800594 <.L24+0x57>
			for (; width > 0; width--)
  8005e8:	eb 14                	jmp    8005fe <.L24+0xc1>
				putch(' ', putdat);
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	ff 75 0c             	pushl  0xc(%ebp)
  8005f0:	6a 20                	push   $0x20
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	ff d0                	call   *%eax
  8005f7:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
  8005fa:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  8005fe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800602:	7f e6                	jg     8005ea <.L24+0xad>
			break;
  800604:	e9 4e 01 00 00       	jmp    800757 <.L20+0x28>

00800609 <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	ff 75 d8             	pushl  -0x28(%ebp)
  80060f:	8d 45 14             	lea    0x14(%ebp),%eax
  800612:	50                   	push   %eax
  800613:	e8 37 fd ff ff       	call   80034f <getint>
  800618:	83 c4 10             	add    $0x10,%esp
  80061b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80061e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
  800621:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800624:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800627:	85 d2                	test   %edx,%edx
  800629:	79 23                	jns    80064e <.L29+0x45>
				putch('-', putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	6a 2d                	push   $0x2d
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	ff d0                	call   *%eax
  800638:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80063b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800641:	f7 d8                	neg    %eax
  800643:	83 d2 00             	adc    $0x0,%edx
  800646:	f7 da                	neg    %edx
  800648:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80064b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
  80064e:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  800655:	e9 9f 00 00 00       	jmp    8006f9 <.L21+0x1f>

0080065a <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 d8             	pushl  -0x28(%ebp)
  800660:	8d 45 14             	lea    0x14(%ebp),%eax
  800663:	50                   	push   %eax
  800664:	e8 89 fc ff ff       	call   8002f2 <getuint>
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80066f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
  800672:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  800679:	eb 7e                	jmp    8006f9 <.L21+0x1f>

0080067b <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	ff 75 d8             	pushl  -0x28(%ebp)
  800681:	8d 45 14             	lea    0x14(%ebp),%eax
  800684:	50                   	push   %eax
  800685:	e8 68 fc ff ff       	call   8002f2 <getuint>
  80068a:	83 c4 10             	add    $0x10,%esp
  80068d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800690:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
  800693:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
  80069a:	eb 5d                	jmp    8006f9 <.L21+0x1f>

0080069c <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	6a 30                	push   $0x30
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	ff 75 0c             	pushl  0xc(%ebp)
  8006b2:	6a 78                	push   $0x78
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	ff d0                	call   *%eax
  8006b9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8d 50 04             	lea    0x4(%eax),%edx
  8006c2:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c5:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
  8006c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
  8006d1:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
  8006d8:	eb 1f                	jmp    8006f9 <.L21+0x1f>

008006da <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8006e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e3:	50                   	push   %eax
  8006e4:	e8 09 fc ff ff       	call   8002f2 <getuint>
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
  8006f2:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006f9:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  8006fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800700:	83 ec 04             	sub    $0x4,%esp
  800703:	52                   	push   %edx
  800704:	ff 75 d4             	pushl  -0x2c(%ebp)
  800707:	50                   	push   %eax
  800708:	ff 75 e4             	pushl  -0x1c(%ebp)
  80070b:	ff 75 e0             	pushl  -0x20(%ebp)
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	ff 75 08             	pushl  0x8(%ebp)
  800714:	e8 0a fb ff ff       	call   800223 <printnum>
  800719:	83 c4 20             	add    $0x20,%esp
			break;
  80071c:	eb 39                	jmp    800757 <.L20+0x28>

0080071e <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	53                   	push   %ebx
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	ff d0                	call   *%eax
  80072a:	83 c4 10             	add    $0x10,%esp
			break;
  80072d:	eb 28                	jmp    800757 <.L20+0x28>

0080072f <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	6a 25                	push   $0x25
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80073f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800743:	eb 04                	jmp    800749 <.L20+0x1a>
  800745:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800749:	8b 45 10             	mov    0x10(%ebp),%eax
  80074c:	83 e8 01             	sub    $0x1,%eax
  80074f:	0f b6 00             	movzbl (%eax),%eax
  800752:	3c 25                	cmp    $0x25,%al
  800754:	75 ef                	jne    800745 <.L20+0x16>
				/* do nothing */;
			break;
  800756:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800757:	e9 79 fc ff ff       	jmp    8003d5 <vprintfmt+0x31>
				return;
  80075c:	90                   	nop
		}
	}
}
  80075d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800760:	5b                   	pop    %ebx
  800761:	5e                   	pop    %esi
  800762:	5f                   	pop    %edi
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800765:	f3 0f 1e fb          	endbr32 
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	83 ec 18             	sub    $0x18,%esp
  80076f:	e8 f6 f8 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800774:	05 8c 18 00 00       	add    $0x188c,%eax
	va_list ap;

	va_start(ap, fmt);
  800779:	8d 45 14             	lea    0x14(%ebp),%eax
  80077c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800782:	50                   	push   %eax
  800783:	ff 75 10             	pushl  0x10(%ebp)
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	ff 75 08             	pushl  0x8(%ebp)
  80078c:	e8 13 fc ff ff       	call   8003a4 <vprintfmt>
  800791:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800794:	90                   	nop
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800797:	f3 0f 1e fb          	endbr32 
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	e8 c7 f8 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  8007a3:	05 5d 18 00 00       	add    $0x185d,%eax
	b->cnt++;
  8007a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ab:	8b 40 08             	mov    0x8(%eax),%eax
  8007ae:	8d 50 01             	lea    0x1(%eax),%edx
  8007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8007b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ba:	8b 10                	mov    (%eax),%edx
  8007bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bf:	8b 40 04             	mov    0x4(%eax),%eax
  8007c2:	39 c2                	cmp    %eax,%edx
  8007c4:	73 12                	jae    8007d8 <sprintputch+0x41>
		*b->buf++ = ch;
  8007c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8007ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d1:	89 0a                	mov    %ecx,(%edx)
  8007d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8007d6:	88 10                	mov    %dl,(%eax)
}
  8007d8:	90                   	nop
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    

008007db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007db:	f3 0f 1e fb          	endbr32 
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	83 ec 18             	sub    $0x18,%esp
  8007e5:	e8 80 f8 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  8007ea:	05 16 18 00 00       	add    $0x1816,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8007f2:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8007f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f8:	8d 4a ff             	lea    -0x1(%edx),%ecx
  8007fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8007fe:	01 ca                	add    %ecx,%edx
  800800:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800803:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80080a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80080e:	74 06                	je     800816 <vsnprintf+0x3b>
  800810:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800814:	7f 07                	jg     80081d <vsnprintf+0x42>
		return -E_INVAL;
  800816:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081b:	eb 22                	jmp    80083f <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80081d:	ff 75 14             	pushl  0x14(%ebp)
  800820:	ff 75 10             	pushl  0x10(%ebp)
  800823:	8d 55 ec             	lea    -0x14(%ebp),%edx
  800826:	52                   	push   %edx
  800827:	8d 80 97 e7 ff ff    	lea    -0x1869(%eax),%eax
  80082d:	50                   	push   %eax
  80082e:	e8 71 fb ff ff       	call   8003a4 <vprintfmt>
  800833:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800836:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800839:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80083c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80083f:	c9                   	leave  
  800840:	c3                   	ret    

00800841 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800841:	f3 0f 1e fb          	endbr32 
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	83 ec 18             	sub    $0x18,%esp
  80084b:	e8 1a f8 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800850:	05 b0 17 00 00       	add    $0x17b0,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800855:	8d 45 14             	lea    0x14(%ebp),%eax
  800858:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80085b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085e:	50                   	push   %eax
  80085f:	ff 75 10             	pushl  0x10(%ebp)
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	ff 75 08             	pushl  0x8(%ebp)
  800868:	e8 6e ff ff ff       	call   8007db <vsnprintf>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
  800873:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800876:	c9                   	leave  
  800877:	c3                   	ret    

00800878 <__x86.get_pc_thunk.si>:
  800878:	8b 34 24             	mov    (%esp),%esi
  80087b:	c3                   	ret    

0080087c <__x86.get_pc_thunk.di>:
  80087c:	8b 3c 24             	mov    (%esp),%edi
  80087f:	c3                   	ret    

00800880 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800880:	f3 0f 1e fb          	endbr32 
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	83 ec 10             	sub    $0x10,%esp
  80088a:	e8 db f7 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  80088f:	05 71 17 00 00       	add    $0x1771,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80089b:	eb 08                	jmp    8008a5 <strlen+0x25>
		n++;
  80089d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
  8008a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	0f b6 00             	movzbl (%eax),%eax
  8008ab:	84 c0                	test   %al,%al
  8008ad:	75 ee                	jne    80089d <strlen+0x1d>
	return n;
  8008af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008b2:	c9                   	leave  
  8008b3:	c3                   	ret    

008008b4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b4:	f3 0f 1e fb          	endbr32 
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	83 ec 10             	sub    $0x10,%esp
  8008be:	e8 a7 f7 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  8008c3:	05 3d 17 00 00       	add    $0x173d,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008cf:	eb 0c                	jmp    8008dd <strnlen+0x29>
		n++;
  8008d1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8008d9:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  8008dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e1:	74 0a                	je     8008ed <strnlen+0x39>
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	0f b6 00             	movzbl (%eax),%eax
  8008e9:	84 c0                	test   %al,%al
  8008eb:	75 e4                	jne    8008d1 <strnlen+0x1d>
	return n;
  8008ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    

008008f2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f2:	f3 0f 1e fb          	endbr32 
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	83 ec 10             	sub    $0x10,%esp
  8008fc:	e8 69 f7 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800901:	05 ff 16 00 00       	add    $0x16ff,%eax
	char *ret;

	ret = dst;
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80090c:	90                   	nop
  80090d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800910:	8d 42 01             	lea    0x1(%edx),%eax
  800913:	89 45 0c             	mov    %eax,0xc(%ebp)
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8d 48 01             	lea    0x1(%eax),%ecx
  80091c:	89 4d 08             	mov    %ecx,0x8(%ebp)
  80091f:	0f b6 12             	movzbl (%edx),%edx
  800922:	88 10                	mov    %dl,(%eax)
  800924:	0f b6 00             	movzbl (%eax),%eax
  800927:	84 c0                	test   %al,%al
  800929:	75 e2                	jne    80090d <strcpy+0x1b>
		/* do nothing */;
	return ret;
  80092b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    

00800930 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800930:	f3 0f 1e fb          	endbr32 
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	83 ec 10             	sub    $0x10,%esp
  80093a:	e8 2b f7 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  80093f:	05 c1 16 00 00       	add    $0x16c1,%eax
	int len = strlen(dst);
  800944:	ff 75 08             	pushl  0x8(%ebp)
  800947:	e8 34 ff ff ff       	call   800880 <strlen>
  80094c:	83 c4 04             	add    $0x4,%esp
  80094f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
  800952:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	ff 75 0c             	pushl  0xc(%ebp)
  80095d:	50                   	push   %eax
  80095e:	e8 8f ff ff ff       	call   8008f2 <strcpy>
  800963:	83 c4 08             	add    $0x8,%esp
	return dst;
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800969:	c9                   	leave  
  80096a:	c3                   	ret    

0080096b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80096b:	f3 0f 1e fb          	endbr32 
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	83 ec 10             	sub    $0x10,%esp
  800975:	e8 f0 f6 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  80097a:	05 86 16 00 00       	add    $0x1686,%eax
	size_t i;
	char *ret;

	ret = dst;
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800985:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80098c:	eb 23                	jmp    8009b1 <strncpy+0x46>
		*dst++ = *src;
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8d 50 01             	lea    0x1(%eax),%edx
  800994:	89 55 08             	mov    %edx,0x8(%ebp)
  800997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099a:	0f b6 12             	movzbl (%edx),%edx
  80099d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80099f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a2:	0f b6 00             	movzbl (%eax),%eax
  8009a5:	84 c0                	test   %al,%al
  8009a7:	74 04                	je     8009ad <strncpy+0x42>
			src++;
  8009a9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
  8009ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  8009b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009b4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009b7:	72 d5                	jb     80098e <strncpy+0x23>
	}
	return ret;
  8009b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009bc:	c9                   	leave  
  8009bd:	c3                   	ret    

008009be <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009be:	f3 0f 1e fb          	endbr32 
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 10             	sub    $0x10,%esp
  8009c8:	e8 9d f6 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  8009cd:	05 33 16 00 00       	add    $0x1633,%eax
	char *dst_in;

	dst_in = dst;
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009dc:	74 33                	je     800a11 <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
  8009de:	eb 17                	jmp    8009f7 <strlcpy+0x39>
			*dst++ = *src++;
  8009e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e3:	8d 42 01             	lea    0x1(%edx),%eax
  8009e6:	89 45 0c             	mov    %eax,0xc(%ebp)
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	8d 48 01             	lea    0x1(%eax),%ecx
  8009ef:	89 4d 08             	mov    %ecx,0x8(%ebp)
  8009f2:	0f b6 12             	movzbl (%edx),%edx
  8009f5:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
  8009f7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8009fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009ff:	74 0a                	je     800a0b <strlcpy+0x4d>
  800a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a04:	0f b6 00             	movzbl (%eax),%eax
  800a07:	84 c0                	test   %al,%al
  800a09:	75 d5                	jne    8009e0 <strlcpy+0x22>
		*dst = '\0';
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a19:	f3 0f 1e fb          	endbr32 
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	e8 45 f6 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800a25:	05 db 15 00 00       	add    $0x15db,%eax
	while (*p && *p == *q)
  800a2a:	eb 08                	jmp    800a34 <strcmp+0x1b>
		p++, q++;
  800a2c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a30:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	0f b6 00             	movzbl (%eax),%eax
  800a3a:	84 c0                	test   %al,%al
  800a3c:	74 10                	je     800a4e <strcmp+0x35>
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	0f b6 10             	movzbl (%eax),%edx
  800a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a47:	0f b6 00             	movzbl (%eax),%eax
  800a4a:	38 c2                	cmp    %al,%dl
  800a4c:	74 de                	je     800a2c <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	0f b6 00             	movzbl (%eax),%eax
  800a54:	0f b6 d0             	movzbl %al,%edx
  800a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5a:	0f b6 00             	movzbl (%eax),%eax
  800a5d:	0f b6 c0             	movzbl %al,%eax
  800a60:	29 c2                	sub    %eax,%edx
  800a62:	89 d0                	mov    %edx,%eax
}
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a66:	f3 0f 1e fb          	endbr32 
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	e8 f8 f5 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800a72:	05 8e 15 00 00       	add    $0x158e,%eax
	while (n > 0 && *p && *p == *q)
  800a77:	eb 0c                	jmp    800a85 <strncmp+0x1f>
		n--, p++, q++;
  800a79:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800a7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a81:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
  800a85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a89:	74 1a                	je     800aa5 <strncmp+0x3f>
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	0f b6 00             	movzbl (%eax),%eax
  800a91:	84 c0                	test   %al,%al
  800a93:	74 10                	je     800aa5 <strncmp+0x3f>
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	0f b6 10             	movzbl (%eax),%edx
  800a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9e:	0f b6 00             	movzbl (%eax),%eax
  800aa1:	38 c2                	cmp    %al,%dl
  800aa3:	74 d4                	je     800a79 <strncmp+0x13>
	if (n == 0)
  800aa5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa9:	75 07                	jne    800ab2 <strncmp+0x4c>
		return 0;
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab0:	eb 16                	jmp    800ac8 <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	0f b6 00             	movzbl (%eax),%eax
  800ab8:	0f b6 d0             	movzbl %al,%edx
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	0f b6 00             	movzbl (%eax),%eax
  800ac1:	0f b6 c0             	movzbl %al,%eax
  800ac4:	29 c2                	sub    %eax,%edx
  800ac6:	89 d0                	mov    %edx,%eax
}
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aca:	f3 0f 1e fb          	endbr32 
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	e8 91 f5 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800ad9:	05 27 15 00 00       	add    $0x1527,%eax
  800ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ae4:	eb 14                	jmp    800afa <strchr+0x30>
		if (*s == c)
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	0f b6 00             	movzbl (%eax),%eax
  800aec:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800aef:	75 05                	jne    800af6 <strchr+0x2c>
			return (char *) s;
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	eb 13                	jmp    800b09 <strchr+0x3f>
	for (; *s; s++)
  800af6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	0f b6 00             	movzbl (%eax),%eax
  800b00:	84 c0                	test   %al,%al
  800b02:	75 e2                	jne    800ae6 <strchr+0x1c>
	return 0;
  800b04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b09:	c9                   	leave  
  800b0a:	c3                   	ret    

00800b0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b0b:	f3 0f 1e fb          	endbr32 
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	83 ec 04             	sub    $0x4,%esp
  800b15:	e8 50 f5 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800b1a:	05 e6 14 00 00       	add    $0x14e6,%eax
  800b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b22:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b25:	eb 0f                	jmp    800b36 <strfind+0x2b>
		if (*s == c)
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	0f b6 00             	movzbl (%eax),%eax
  800b2d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800b30:	74 10                	je     800b42 <strfind+0x37>
	for (; *s; s++)
  800b32:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	0f b6 00             	movzbl (%eax),%eax
  800b3c:	84 c0                	test   %al,%al
  800b3e:	75 e7                	jne    800b27 <strfind+0x1c>
  800b40:	eb 01                	jmp    800b43 <strfind+0x38>
			break;
  800b42:	90                   	nop
	return (char *) s;
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b48:	f3 0f 1e fb          	endbr32 
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	e8 15 f5 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800b55:	05 ab 14 00 00       	add    $0x14ab,%eax
	char *p;

	if (n == 0)
  800b5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b5e:	75 05                	jne    800b65 <memset+0x1d>
		return v;
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	eb 5c                	jmp    800bc1 <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	83 e0 03             	and    $0x3,%eax
  800b6b:	85 c0                	test   %eax,%eax
  800b6d:	75 41                	jne    800bb0 <memset+0x68>
  800b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b72:	83 e0 03             	and    $0x3,%eax
  800b75:	85 c0                	test   %eax,%eax
  800b77:	75 37                	jne    800bb0 <memset+0x68>
		c &= 0xFF;
  800b79:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b83:	c1 e0 18             	shl    $0x18,%eax
  800b86:	89 c2                	mov    %eax,%edx
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	c1 e0 10             	shl    $0x10,%eax
  800b8e:	09 c2                	or     %eax,%edx
  800b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b93:	c1 e0 08             	shl    $0x8,%eax
  800b96:	09 d0                	or     %edx,%eax
  800b98:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	c1 e8 02             	shr    $0x2,%eax
  800ba1:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
  800ba3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba9:	89 d7                	mov    %edx,%edi
  800bab:	fc                   	cld    
  800bac:	f3 ab                	rep stos %eax,%es:(%edi)
  800bae:	eb 0e                	jmp    800bbe <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800bb9:	89 d7                	mov    %edx,%edi
  800bbb:	fc                   	cld    
  800bbc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
  800bce:	83 ec 10             	sub    $0x10,%esp
  800bd1:	e8 94 f4 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800bd6:	05 2a 14 00 00       	add    $0x142a,%eax
	const char *s;
	char *d;

	s = src;
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
  800be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800bed:	73 6d                	jae    800c5c <memmove+0x98>
  800bef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800bf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf5:	01 d0                	add    %edx,%eax
  800bf7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  800bfa:	73 60                	jae    800c5c <memmove+0x98>
		s += n;
  800bfc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bff:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	83 e0 03             	and    $0x3,%eax
  800c0e:	85 c0                	test   %eax,%eax
  800c10:	75 2f                	jne    800c41 <memmove+0x7d>
  800c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c15:	83 e0 03             	and    $0x3,%eax
  800c18:	85 c0                	test   %eax,%eax
  800c1a:	75 25                	jne    800c41 <memmove+0x7d>
  800c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1f:	83 e0 03             	and    $0x3,%eax
  800c22:	85 c0                	test   %eax,%eax
  800c24:	75 1b                	jne    800c41 <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c29:	83 e8 04             	sub    $0x4,%eax
  800c2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c2f:	83 ea 04             	sub    $0x4,%edx
  800c32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c35:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c38:	89 c7                	mov    %eax,%edi
  800c3a:	89 d6                	mov    %edx,%esi
  800c3c:	fd                   	std    
  800c3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c3f:	eb 18                	jmp    800c59 <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4a:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
  800c4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c50:	89 d7                	mov    %edx,%edi
  800c52:	89 de                	mov    %ebx,%esi
  800c54:	89 c1                	mov    %eax,%ecx
  800c56:	fd                   	std    
  800c57:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c59:	fc                   	cld    
  800c5a:	eb 45                	jmp    800ca1 <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5f:	83 e0 03             	and    $0x3,%eax
  800c62:	85 c0                	test   %eax,%eax
  800c64:	75 2b                	jne    800c91 <memmove+0xcd>
  800c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c69:	83 e0 03             	and    $0x3,%eax
  800c6c:	85 c0                	test   %eax,%eax
  800c6e:	75 21                	jne    800c91 <memmove+0xcd>
  800c70:	8b 45 10             	mov    0x10(%ebp),%eax
  800c73:	83 e0 03             	and    $0x3,%eax
  800c76:	85 c0                	test   %eax,%eax
  800c78:	75 17                	jne    800c91 <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7d:	c1 e8 02             	shr    $0x2,%eax
  800c80:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
  800c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c88:	89 c7                	mov    %eax,%edi
  800c8a:	89 d6                	mov    %edx,%esi
  800c8c:	fc                   	cld    
  800c8d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c8f:	eb 10                	jmp    800ca1 <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
  800c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c9a:	89 c7                	mov    %eax,%edi
  800c9c:	89 d6                	mov    %edx,%esi
  800c9e:	fc                   	cld    
  800c9f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca4:	83 c4 10             	add    $0x10,%esp
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cac:	f3 0f 1e fb          	endbr32 
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	e8 b2 f3 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800cb8:	05 48 13 00 00       	add    $0x1348,%eax
	return memmove(dst, src, n);
  800cbd:	ff 75 10             	pushl  0x10(%ebp)
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	ff 75 08             	pushl  0x8(%ebp)
  800cc6:	e8 f9 fe ff ff       	call   800bc4 <memmove>
  800ccb:	83 c4 0c             	add    $0xc,%esp
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    

00800cd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cd0:	f3 0f 1e fb          	endbr32 
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	83 ec 10             	sub    $0x10,%esp
  800cda:	e8 8b f3 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800cdf:	05 21 13 00 00       	add    $0x1321,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cf0:	eb 30                	jmp    800d22 <memcmp+0x52>
		if (*s1 != *s2)
  800cf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf5:	0f b6 10             	movzbl (%eax),%edx
  800cf8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cfb:	0f b6 00             	movzbl (%eax),%eax
  800cfe:	38 c2                	cmp    %al,%dl
  800d00:	74 18                	je     800d1a <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
  800d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d05:	0f b6 00             	movzbl (%eax),%eax
  800d08:	0f b6 d0             	movzbl %al,%edx
  800d0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d0e:	0f b6 00             	movzbl (%eax),%eax
  800d11:	0f b6 c0             	movzbl %al,%eax
  800d14:	29 c2                	sub    %eax,%edx
  800d16:	89 d0                	mov    %edx,%eax
  800d18:	eb 1a                	jmp    800d34 <memcmp+0x64>
		s1++, s2++;
  800d1a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800d1e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
  800d22:	8b 45 10             	mov    0x10(%ebp),%eax
  800d25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d28:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	75 c3                	jne    800cf2 <memcmp+0x22>
	}

	return 0;
  800d2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d36:	f3 0f 1e fb          	endbr32 
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	83 ec 10             	sub    $0x10,%esp
  800d40:	e8 25 f3 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800d45:	05 bb 12 00 00       	add    $0x12bb,%eax
	const void *ends = (const char *) s + n;
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	01 d0                	add    %edx,%eax
  800d52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d55:	eb 11                	jmp    800d68 <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	0f b6 00             	movzbl (%eax),%eax
  800d5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d60:	38 d0                	cmp    %dl,%al
  800d62:	74 0e                	je     800d72 <memfind+0x3c>
	for (; s < ends; s++)
  800d64:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d6e:	72 e7                	jb     800d57 <memfind+0x21>
  800d70:	eb 01                	jmp    800d73 <memfind+0x3d>
			break;
  800d72:	90                   	nop
	return (void *) s;
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d76:	c9                   	leave  
  800d77:	c3                   	ret    

00800d78 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d78:	f3 0f 1e fb          	endbr32 
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 10             	sub    $0x10,%esp
  800d82:	e8 e3 f2 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800d87:	05 79 12 00 00       	add    $0x1279,%eax
	int neg = 0;
  800d8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d93:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d9a:	eb 04                	jmp    800da0 <strtol+0x28>
		s++;
  800d9c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	0f b6 00             	movzbl (%eax),%eax
  800da6:	3c 20                	cmp    $0x20,%al
  800da8:	74 f2                	je     800d9c <strtol+0x24>
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	0f b6 00             	movzbl (%eax),%eax
  800db0:	3c 09                	cmp    $0x9,%al
  800db2:	74 e8                	je     800d9c <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	0f b6 00             	movzbl (%eax),%eax
  800dba:	3c 2b                	cmp    $0x2b,%al
  800dbc:	75 06                	jne    800dc4 <strtol+0x4c>
		s++;
  800dbe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dc2:	eb 15                	jmp    800dd9 <strtol+0x61>
	else if (*s == '-')
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	0f b6 00             	movzbl (%eax),%eax
  800dca:	3c 2d                	cmp    $0x2d,%al
  800dcc:	75 0b                	jne    800dd9 <strtol+0x61>
		s++, neg = 1;
  800dce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dd2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddd:	74 06                	je     800de5 <strtol+0x6d>
  800ddf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800de3:	75 24                	jne    800e09 <strtol+0x91>
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	0f b6 00             	movzbl (%eax),%eax
  800deb:	3c 30                	cmp    $0x30,%al
  800ded:	75 1a                	jne    800e09 <strtol+0x91>
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	83 c0 01             	add    $0x1,%eax
  800df5:	0f b6 00             	movzbl (%eax),%eax
  800df8:	3c 78                	cmp    $0x78,%al
  800dfa:	75 0d                	jne    800e09 <strtol+0x91>
		s += 2, base = 16;
  800dfc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e00:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e07:	eb 2a                	jmp    800e33 <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
  800e09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0d:	75 17                	jne    800e26 <strtol+0xae>
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	0f b6 00             	movzbl (%eax),%eax
  800e15:	3c 30                	cmp    $0x30,%al
  800e17:	75 0d                	jne    800e26 <strtol+0xae>
		s++, base = 8;
  800e19:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e1d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e24:	eb 0d                	jmp    800e33 <strtol+0xbb>
	else if (base == 0)
  800e26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2a:	75 07                	jne    800e33 <strtol+0xbb>
		base = 10;
  800e2c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	0f b6 00             	movzbl (%eax),%eax
  800e39:	3c 2f                	cmp    $0x2f,%al
  800e3b:	7e 1b                	jle    800e58 <strtol+0xe0>
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	0f b6 00             	movzbl (%eax),%eax
  800e43:	3c 39                	cmp    $0x39,%al
  800e45:	7f 11                	jg     800e58 <strtol+0xe0>
			dig = *s - '0';
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	0f b6 00             	movzbl (%eax),%eax
  800e4d:	0f be c0             	movsbl %al,%eax
  800e50:	83 e8 30             	sub    $0x30,%eax
  800e53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e56:	eb 48                	jmp    800ea0 <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	0f b6 00             	movzbl (%eax),%eax
  800e5e:	3c 60                	cmp    $0x60,%al
  800e60:	7e 1b                	jle    800e7d <strtol+0x105>
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	0f b6 00             	movzbl (%eax),%eax
  800e68:	3c 7a                	cmp    $0x7a,%al
  800e6a:	7f 11                	jg     800e7d <strtol+0x105>
			dig = *s - 'a' + 10;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	0f b6 00             	movzbl (%eax),%eax
  800e72:	0f be c0             	movsbl %al,%eax
  800e75:	83 e8 57             	sub    $0x57,%eax
  800e78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e7b:	eb 23                	jmp    800ea0 <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	0f b6 00             	movzbl (%eax),%eax
  800e83:	3c 40                	cmp    $0x40,%al
  800e85:	7e 3c                	jle    800ec3 <strtol+0x14b>
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	0f b6 00             	movzbl (%eax),%eax
  800e8d:	3c 5a                	cmp    $0x5a,%al
  800e8f:	7f 32                	jg     800ec3 <strtol+0x14b>
			dig = *s - 'A' + 10;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	0f b6 00             	movzbl (%eax),%eax
  800e97:	0f be c0             	movsbl %al,%eax
  800e9a:	83 e8 37             	sub    $0x37,%eax
  800e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ea6:	7d 1a                	jge    800ec2 <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
  800ea8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800eac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eb8:	01 d0                	add    %edx,%eax
  800eba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
  800ebd:	e9 71 ff ff ff       	jmp    800e33 <strtol+0xbb>
			break;
  800ec2:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
  800ec3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec7:	74 08                	je     800ed1 <strtol+0x159>
		*endptr = (char *) s;
  800ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ed1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ed5:	74 07                	je     800ede <strtol+0x166>
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	f7 d8                	neg    %eax
  800edc:	eb 03                	jmp    800ee1 <strtol+0x169>
  800ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	57                   	push   %edi
  800ee7:	56                   	push   %esi
  800ee8:	53                   	push   %ebx
  800ee9:	83 ec 2c             	sub    $0x2c,%esp
  800eec:	e8 e7 f1 ff ff       	call   8000d8 <__x86.get_pc_thunk.bx>
  800ef1:	81 c3 0f 11 00 00    	add    $0x110f,%ebx
  800ef7:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8b 55 10             	mov    0x10(%ebp),%edx
  800f00:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800f03:	8b 5d 18             	mov    0x18(%ebp),%ebx
  800f06:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  800f09:	8b 75 20             	mov    0x20(%ebp),%esi
  800f0c:	cd 30                	int    $0x30
  800f0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f15:	74 27                	je     800f3e <syscall+0x5b>
  800f17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1b:	7e 21                	jle    800f3e <syscall+0x5b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1d:	83 ec 0c             	sub    $0xc,%esp
  800f20:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f23:	ff 75 08             	pushl  0x8(%ebp)
  800f26:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800f29:	8d 83 fc f4 ff ff    	lea    -0xb04(%ebx),%eax
  800f2f:	50                   	push   %eax
  800f30:	6a 23                	push   $0x23
  800f32:	8d 83 19 f5 ff ff    	lea    -0xae7(%ebx),%eax
  800f38:	50                   	push   %eax
  800f39:	e8 cd 00 00 00       	call   80100b <_panic>

	return ret;
  800f3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  800f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5f                   	pop    %edi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    

00800f49 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800f49:	f3 0f 1e fb          	endbr32 
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	83 ec 08             	sub    $0x8,%esp
  800f53:	e8 12 f1 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800f58:	05 a8 10 00 00       	add    $0x10a8,%eax
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	83 ec 04             	sub    $0x4,%esp
  800f63:	6a 00                	push   $0x0
  800f65:	6a 00                	push   $0x0
  800f67:	6a 00                	push   $0x0
  800f69:	ff 75 0c             	pushl  0xc(%ebp)
  800f6c:	50                   	push   %eax
  800f6d:	6a 00                	push   $0x0
  800f6f:	6a 00                	push   $0x0
  800f71:	e8 6d ff ff ff       	call   800ee3 <syscall>
  800f76:	83 c4 20             	add    $0x20,%esp
}
  800f79:	90                   	nop
  800f7a:	c9                   	leave  
  800f7b:	c3                   	ret    

00800f7c <sys_cgetc>:

int
sys_cgetc(void)
{
  800f7c:	f3 0f 1e fb          	endbr32 
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 08             	sub    $0x8,%esp
  800f86:	e8 df f0 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800f8b:	05 75 10 00 00       	add    $0x1075,%eax
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800f90:	83 ec 04             	sub    $0x4,%esp
  800f93:	6a 00                	push   $0x0
  800f95:	6a 00                	push   $0x0
  800f97:	6a 00                	push   $0x0
  800f99:	6a 00                	push   $0x0
  800f9b:	6a 00                	push   $0x0
  800f9d:	6a 00                	push   $0x0
  800f9f:	6a 01                	push   $0x1
  800fa1:	e8 3d ff ff ff       	call   800ee3 <syscall>
  800fa6:	83 c4 20             	add    $0x20,%esp
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fab:	f3 0f 1e fb          	endbr32 
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	e8 b0 f0 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800fba:	05 46 10 00 00       	add    $0x1046,%eax
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	83 ec 04             	sub    $0x4,%esp
  800fc5:	6a 00                	push   $0x0
  800fc7:	6a 00                	push   $0x0
  800fc9:	6a 00                	push   $0x0
  800fcb:	6a 00                	push   $0x0
  800fcd:	50                   	push   %eax
  800fce:	6a 01                	push   $0x1
  800fd0:	6a 03                	push   $0x3
  800fd2:	e8 0c ff ff ff       	call   800ee3 <syscall>
  800fd7:	83 c4 20             	add    $0x20,%esp
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fdc:	f3 0f 1e fb          	endbr32 
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	e8 7f f0 ff ff       	call   80006a <__x86.get_pc_thunk.ax>
  800feb:	05 15 10 00 00       	add    $0x1015,%eax
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800ff0:	83 ec 04             	sub    $0x4,%esp
  800ff3:	6a 00                	push   $0x0
  800ff5:	6a 00                	push   $0x0
  800ff7:	6a 00                	push   $0x0
  800ff9:	6a 00                	push   $0x0
  800ffb:	6a 00                	push   $0x0
  800ffd:	6a 00                	push   $0x0
  800fff:	6a 02                	push   $0x2
  801001:	e8 dd fe ff ff       	call   800ee3 <syscall>
  801006:	83 c4 20             	add    $0x20,%esp
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80100b:	f3 0f 1e fb          	endbr32 
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	56                   	push   %esi
  801013:	53                   	push   %ebx
  801014:	83 ec 10             	sub    $0x10,%esp
  801017:	e8 bc f0 ff ff       	call   8000d8 <__x86.get_pc_thunk.bx>
  80101c:	81 c3 e4 0f 00 00    	add    $0xfe4,%ebx
	va_list ap;

	va_start(ap, fmt);
  801022:	8d 45 14             	lea    0x14(%ebp),%eax
  801025:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801028:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  80102e:	8b 30                	mov    (%eax),%esi
  801030:	e8 a7 ff ff ff       	call   800fdc <sys_getenvid>
  801035:	83 ec 0c             	sub    $0xc,%esp
  801038:	ff 75 0c             	pushl  0xc(%ebp)
  80103b:	ff 75 08             	pushl  0x8(%ebp)
  80103e:	56                   	push   %esi
  80103f:	50                   	push   %eax
  801040:	8d 83 28 f5 ff ff    	lea    -0xad8(%ebx),%eax
  801046:	50                   	push   %eax
  801047:	e8 9f f1 ff ff       	call   8001eb <cprintf>
  80104c:	83 c4 20             	add    $0x20,%esp
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80104f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801052:	83 ec 08             	sub    $0x8,%esp
  801055:	50                   	push   %eax
  801056:	ff 75 10             	pushl  0x10(%ebp)
  801059:	e8 1d f1 ff ff       	call   80017b <vcprintf>
  80105e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  801061:	83 ec 0c             	sub    $0xc,%esp
  801064:	8d 83 4b f5 ff ff    	lea    -0xab5(%ebx),%eax
  80106a:	50                   	push   %eax
  80106b:	e8 7b f1 ff ff       	call   8001eb <cprintf>
  801070:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801073:	cc                   	int3   
  801074:	eb fd                	jmp    801073 <_panic+0x68>
  801076:	66 90                	xchg   %ax,%ax
  801078:	66 90                	xchg   %ax,%ax
  80107a:	66 90                	xchg   %ax,%ax
  80107c:	66 90                	xchg   %ax,%ax
  80107e:	66 90                	xchg   %ax,%ax

00801080 <__udivdi3>:
  801080:	f3 0f 1e fb          	endbr32 
  801084:	55                   	push   %ebp
  801085:	57                   	push   %edi
  801086:	56                   	push   %esi
  801087:	53                   	push   %ebx
  801088:	83 ec 1c             	sub    $0x1c,%esp
  80108b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80108f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801093:	8b 74 24 34          	mov    0x34(%esp),%esi
  801097:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80109b:	85 d2                	test   %edx,%edx
  80109d:	75 19                	jne    8010b8 <__udivdi3+0x38>
  80109f:	39 f3                	cmp    %esi,%ebx
  8010a1:	76 4d                	jbe    8010f0 <__udivdi3+0x70>
  8010a3:	31 ff                	xor    %edi,%edi
  8010a5:	89 e8                	mov    %ebp,%eax
  8010a7:	89 f2                	mov    %esi,%edx
  8010a9:	f7 f3                	div    %ebx
  8010ab:	89 fa                	mov    %edi,%edx
  8010ad:	83 c4 1c             	add    $0x1c,%esp
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5f                   	pop    %edi
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    
  8010b5:	8d 76 00             	lea    0x0(%esi),%esi
  8010b8:	39 f2                	cmp    %esi,%edx
  8010ba:	76 14                	jbe    8010d0 <__udivdi3+0x50>
  8010bc:	31 ff                	xor    %edi,%edi
  8010be:	31 c0                	xor    %eax,%eax
  8010c0:	89 fa                	mov    %edi,%edx
  8010c2:	83 c4 1c             	add    $0x1c,%esp
  8010c5:	5b                   	pop    %ebx
  8010c6:	5e                   	pop    %esi
  8010c7:	5f                   	pop    %edi
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    
  8010ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010d0:	0f bd fa             	bsr    %edx,%edi
  8010d3:	83 f7 1f             	xor    $0x1f,%edi
  8010d6:	75 48                	jne    801120 <__udivdi3+0xa0>
  8010d8:	39 f2                	cmp    %esi,%edx
  8010da:	72 06                	jb     8010e2 <__udivdi3+0x62>
  8010dc:	31 c0                	xor    %eax,%eax
  8010de:	39 eb                	cmp    %ebp,%ebx
  8010e0:	77 de                	ja     8010c0 <__udivdi3+0x40>
  8010e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8010e7:	eb d7                	jmp    8010c0 <__udivdi3+0x40>
  8010e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010f0:	89 d9                	mov    %ebx,%ecx
  8010f2:	85 db                	test   %ebx,%ebx
  8010f4:	75 0b                	jne    801101 <__udivdi3+0x81>
  8010f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8010fb:	31 d2                	xor    %edx,%edx
  8010fd:	f7 f3                	div    %ebx
  8010ff:	89 c1                	mov    %eax,%ecx
  801101:	31 d2                	xor    %edx,%edx
  801103:	89 f0                	mov    %esi,%eax
  801105:	f7 f1                	div    %ecx
  801107:	89 c6                	mov    %eax,%esi
  801109:	89 e8                	mov    %ebp,%eax
  80110b:	89 f7                	mov    %esi,%edi
  80110d:	f7 f1                	div    %ecx
  80110f:	89 fa                	mov    %edi,%edx
  801111:	83 c4 1c             	add    $0x1c,%esp
  801114:	5b                   	pop    %ebx
  801115:	5e                   	pop    %esi
  801116:	5f                   	pop    %edi
  801117:	5d                   	pop    %ebp
  801118:	c3                   	ret    
  801119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801120:	89 f9                	mov    %edi,%ecx
  801122:	b8 20 00 00 00       	mov    $0x20,%eax
  801127:	29 f8                	sub    %edi,%eax
  801129:	d3 e2                	shl    %cl,%edx
  80112b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80112f:	89 c1                	mov    %eax,%ecx
  801131:	89 da                	mov    %ebx,%edx
  801133:	d3 ea                	shr    %cl,%edx
  801135:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801139:	09 d1                	or     %edx,%ecx
  80113b:	89 f2                	mov    %esi,%edx
  80113d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801141:	89 f9                	mov    %edi,%ecx
  801143:	d3 e3                	shl    %cl,%ebx
  801145:	89 c1                	mov    %eax,%ecx
  801147:	d3 ea                	shr    %cl,%edx
  801149:	89 f9                	mov    %edi,%ecx
  80114b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80114f:	89 eb                	mov    %ebp,%ebx
  801151:	d3 e6                	shl    %cl,%esi
  801153:	89 c1                	mov    %eax,%ecx
  801155:	d3 eb                	shr    %cl,%ebx
  801157:	09 de                	or     %ebx,%esi
  801159:	89 f0                	mov    %esi,%eax
  80115b:	f7 74 24 08          	divl   0x8(%esp)
  80115f:	89 d6                	mov    %edx,%esi
  801161:	89 c3                	mov    %eax,%ebx
  801163:	f7 64 24 0c          	mull   0xc(%esp)
  801167:	39 d6                	cmp    %edx,%esi
  801169:	72 15                	jb     801180 <__udivdi3+0x100>
  80116b:	89 f9                	mov    %edi,%ecx
  80116d:	d3 e5                	shl    %cl,%ebp
  80116f:	39 c5                	cmp    %eax,%ebp
  801171:	73 04                	jae    801177 <__udivdi3+0xf7>
  801173:	39 d6                	cmp    %edx,%esi
  801175:	74 09                	je     801180 <__udivdi3+0x100>
  801177:	89 d8                	mov    %ebx,%eax
  801179:	31 ff                	xor    %edi,%edi
  80117b:	e9 40 ff ff ff       	jmp    8010c0 <__udivdi3+0x40>
  801180:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801183:	31 ff                	xor    %edi,%edi
  801185:	e9 36 ff ff ff       	jmp    8010c0 <__udivdi3+0x40>
  80118a:	66 90                	xchg   %ax,%ax
  80118c:	66 90                	xchg   %ax,%ax
  80118e:	66 90                	xchg   %ax,%ax

00801190 <__umoddi3>:
  801190:	f3 0f 1e fb          	endbr32 
  801194:	55                   	push   %ebp
  801195:	57                   	push   %edi
  801196:	56                   	push   %esi
  801197:	53                   	push   %ebx
  801198:	83 ec 1c             	sub    $0x1c,%esp
  80119b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80119f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8011a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8011a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	75 19                	jne    8011c8 <__umoddi3+0x38>
  8011af:	39 df                	cmp    %ebx,%edi
  8011b1:	76 5d                	jbe    801210 <__umoddi3+0x80>
  8011b3:	89 f0                	mov    %esi,%eax
  8011b5:	89 da                	mov    %ebx,%edx
  8011b7:	f7 f7                	div    %edi
  8011b9:	89 d0                	mov    %edx,%eax
  8011bb:	31 d2                	xor    %edx,%edx
  8011bd:	83 c4 1c             	add    $0x1c,%esp
  8011c0:	5b                   	pop    %ebx
  8011c1:	5e                   	pop    %esi
  8011c2:	5f                   	pop    %edi
  8011c3:	5d                   	pop    %ebp
  8011c4:	c3                   	ret    
  8011c5:	8d 76 00             	lea    0x0(%esi),%esi
  8011c8:	89 f2                	mov    %esi,%edx
  8011ca:	39 d8                	cmp    %ebx,%eax
  8011cc:	76 12                	jbe    8011e0 <__umoddi3+0x50>
  8011ce:	89 f0                	mov    %esi,%eax
  8011d0:	89 da                	mov    %ebx,%edx
  8011d2:	83 c4 1c             	add    $0x1c,%esp
  8011d5:	5b                   	pop    %ebx
  8011d6:	5e                   	pop    %esi
  8011d7:	5f                   	pop    %edi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    
  8011da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011e0:	0f bd e8             	bsr    %eax,%ebp
  8011e3:	83 f5 1f             	xor    $0x1f,%ebp
  8011e6:	75 50                	jne    801238 <__umoddi3+0xa8>
  8011e8:	39 d8                	cmp    %ebx,%eax
  8011ea:	0f 82 e0 00 00 00    	jb     8012d0 <__umoddi3+0x140>
  8011f0:	89 d9                	mov    %ebx,%ecx
  8011f2:	39 f7                	cmp    %esi,%edi
  8011f4:	0f 86 d6 00 00 00    	jbe    8012d0 <__umoddi3+0x140>
  8011fa:	89 d0                	mov    %edx,%eax
  8011fc:	89 ca                	mov    %ecx,%edx
  8011fe:	83 c4 1c             	add    $0x1c,%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    
  801206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80120d:	8d 76 00             	lea    0x0(%esi),%esi
  801210:	89 fd                	mov    %edi,%ebp
  801212:	85 ff                	test   %edi,%edi
  801214:	75 0b                	jne    801221 <__umoddi3+0x91>
  801216:	b8 01 00 00 00       	mov    $0x1,%eax
  80121b:	31 d2                	xor    %edx,%edx
  80121d:	f7 f7                	div    %edi
  80121f:	89 c5                	mov    %eax,%ebp
  801221:	89 d8                	mov    %ebx,%eax
  801223:	31 d2                	xor    %edx,%edx
  801225:	f7 f5                	div    %ebp
  801227:	89 f0                	mov    %esi,%eax
  801229:	f7 f5                	div    %ebp
  80122b:	89 d0                	mov    %edx,%eax
  80122d:	31 d2                	xor    %edx,%edx
  80122f:	eb 8c                	jmp    8011bd <__umoddi3+0x2d>
  801231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801238:	89 e9                	mov    %ebp,%ecx
  80123a:	ba 20 00 00 00       	mov    $0x20,%edx
  80123f:	29 ea                	sub    %ebp,%edx
  801241:	d3 e0                	shl    %cl,%eax
  801243:	89 44 24 08          	mov    %eax,0x8(%esp)
  801247:	89 d1                	mov    %edx,%ecx
  801249:	89 f8                	mov    %edi,%eax
  80124b:	d3 e8                	shr    %cl,%eax
  80124d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801251:	89 54 24 04          	mov    %edx,0x4(%esp)
  801255:	8b 54 24 04          	mov    0x4(%esp),%edx
  801259:	09 c1                	or     %eax,%ecx
  80125b:	89 d8                	mov    %ebx,%eax
  80125d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801261:	89 e9                	mov    %ebp,%ecx
  801263:	d3 e7                	shl    %cl,%edi
  801265:	89 d1                	mov    %edx,%ecx
  801267:	d3 e8                	shr    %cl,%eax
  801269:	89 e9                	mov    %ebp,%ecx
  80126b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80126f:	d3 e3                	shl    %cl,%ebx
  801271:	89 c7                	mov    %eax,%edi
  801273:	89 d1                	mov    %edx,%ecx
  801275:	89 f0                	mov    %esi,%eax
  801277:	d3 e8                	shr    %cl,%eax
  801279:	89 e9                	mov    %ebp,%ecx
  80127b:	89 fa                	mov    %edi,%edx
  80127d:	d3 e6                	shl    %cl,%esi
  80127f:	09 d8                	or     %ebx,%eax
  801281:	f7 74 24 08          	divl   0x8(%esp)
  801285:	89 d1                	mov    %edx,%ecx
  801287:	89 f3                	mov    %esi,%ebx
  801289:	f7 64 24 0c          	mull   0xc(%esp)
  80128d:	89 c6                	mov    %eax,%esi
  80128f:	89 d7                	mov    %edx,%edi
  801291:	39 d1                	cmp    %edx,%ecx
  801293:	72 06                	jb     80129b <__umoddi3+0x10b>
  801295:	75 10                	jne    8012a7 <__umoddi3+0x117>
  801297:	39 c3                	cmp    %eax,%ebx
  801299:	73 0c                	jae    8012a7 <__umoddi3+0x117>
  80129b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80129f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8012a3:	89 d7                	mov    %edx,%edi
  8012a5:	89 c6                	mov    %eax,%esi
  8012a7:	89 ca                	mov    %ecx,%edx
  8012a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8012ae:	29 f3                	sub    %esi,%ebx
  8012b0:	19 fa                	sbb    %edi,%edx
  8012b2:	89 d0                	mov    %edx,%eax
  8012b4:	d3 e0                	shl    %cl,%eax
  8012b6:	89 e9                	mov    %ebp,%ecx
  8012b8:	d3 eb                	shr    %cl,%ebx
  8012ba:	d3 ea                	shr    %cl,%edx
  8012bc:	09 d8                	or     %ebx,%eax
  8012be:	83 c4 1c             	add    $0x1c,%esp
  8012c1:	5b                   	pop    %ebx
  8012c2:	5e                   	pop    %esi
  8012c3:	5f                   	pop    %edi
  8012c4:	5d                   	pop    %ebp
  8012c5:	c3                   	ret    
  8012c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012cd:	8d 76 00             	lea    0x0(%esi),%esi
  8012d0:	29 fe                	sub    %edi,%esi
  8012d2:	19 c3                	sbb    %eax,%ebx
  8012d4:	89 f2                	mov    %esi,%edx
  8012d6:	89 d9                	mov    %ebx,%ecx
  8012d8:	e9 1d ff ff ff       	jmp    8011fa <__umoddi3+0x6a>
