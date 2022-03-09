
obj/user/hello:     file format elf32-i386


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
  80002c:	e8 52 00 00 00       	call   800083 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	e8 3c 00 00 00       	call   80007f <__x86.get_pc_thunk.bx>
  800043:	81 c3 bd 1f 00 00    	add    $0x1fbd,%ebx
	cprintf("hello, world\n");
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	8d 83 f0 f2 ff ff    	lea    -0xd10(%ebx),%eax
  800052:	50                   	push   %eax
  800053:	e8 a8 01 00 00       	call   800200 <cprintf>
  800058:	83 c4 10             	add    $0x10,%esp
	cprintf("i am environment %08x\n", thisenv->env_id);
  80005b:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  800061:	8b 00                	mov    (%eax),%eax
  800063:	8b 40 48             	mov    0x48(%eax),%eax
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	50                   	push   %eax
  80006a:	8d 83 fe f2 ff ff    	lea    -0xd02(%ebx),%eax
  800070:	50                   	push   %eax
  800071:	e8 8a 01 00 00       	call   800200 <cprintf>
  800076:	83 c4 10             	add    $0x10,%esp
}
  800079:	90                   	nop
  80007a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007d:	c9                   	leave  
  80007e:	c3                   	ret    

0080007f <__x86.get_pc_thunk.bx>:
  80007f:	8b 1c 24             	mov    (%esp),%ebx
  800082:	c3                   	ret    

00800083 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800083:	f3 0f 1e fb          	endbr32 
  800087:	55                   	push   %ebp
  800088:	89 e5                	mov    %esp,%ebp
  80008a:	53                   	push   %ebx
  80008b:	83 ec 04             	sub    $0x4,%esp
  80008e:	e8 ec ff ff ff       	call   80007f <__x86.get_pc_thunk.bx>
  800093:	81 c3 6d 1f 00 00    	add    $0x1f6d,%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code h(ere.
	thisenv = envs + ENVX(sys_getenvid());
  800099:	e8 53 0f 00 00       	call   800ff1 <sys_getenvid>
  80009e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a3:	89 c2                	mov    %eax,%edx
  8000a5:	89 d0                	mov    %edx,%eax
  8000a7:	01 c0                	add    %eax,%eax
  8000a9:	01 d0                	add    %edx,%eax
  8000ab:	c1 e0 05             	shl    $0x5,%eax
  8000ae:	89 c2                	mov    %eax,%edx
  8000b0:	c7 c0 00 00 c0 ee    	mov    $0xeec00000,%eax
  8000b6:	01 c2                	add    %eax,%edx
  8000b8:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  8000be:	89 10                	mov    %edx,(%eax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c4:	7e 0b                	jle    8000d1 <libmain+0x4e>
		binaryname = argv[0];
  8000c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c9:	8b 00                	mov    (%eax),%eax
  8000cb:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000d1:	83 ec 08             	sub    $0x8,%esp
  8000d4:	ff 75 0c             	pushl  0xc(%ebp)
  8000d7:	ff 75 08             	pushl  0x8(%ebp)
  8000da:	e8 54 ff ff ff       	call   800033 <umain>
  8000df:	83 c4 10             	add    $0x10,%esp

	// exit gracefully
	exit();
  8000e2:	e8 06 00 00 00       	call   8000ed <exit>
}
  8000e7:	90                   	nop
  8000e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000eb:	c9                   	leave  
  8000ec:	c3                   	ret    

008000ed <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ed:	f3 0f 1e fb          	endbr32 
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	53                   	push   %ebx
  8000f5:	83 ec 04             	sub    $0x4,%esp
  8000f8:	e8 1a 00 00 00       	call   800117 <__x86.get_pc_thunk.ax>
  8000fd:	05 03 1f 00 00       	add    $0x1f03,%eax
	sys_env_destroy(0);
  800102:	83 ec 0c             	sub    $0xc,%esp
  800105:	6a 00                	push   $0x0
  800107:	89 c3                	mov    %eax,%ebx
  800109:	e8 b2 0e 00 00       	call   800fc0 <sys_env_destroy>
  80010e:	83 c4 10             	add    $0x10,%esp
}
  800111:	90                   	nop
  800112:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800115:	c9                   	leave  
  800116:	c3                   	ret    

00800117 <__x86.get_pc_thunk.ax>:
  800117:	8b 04 24             	mov    (%esp),%eax
  80011a:	c3                   	ret    

0080011b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80011b:	f3 0f 1e fb          	endbr32 
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	53                   	push   %ebx
  800123:	83 ec 04             	sub    $0x4,%esp
  800126:	e8 09 01 00 00       	call   800234 <__x86.get_pc_thunk.dx>
  80012b:	81 c2 d5 1e 00 00    	add    $0x1ed5,%edx
	b->buf[b->idx++] = ch;
  800131:	8b 45 0c             	mov    0xc(%ebp),%eax
  800134:	8b 00                	mov    (%eax),%eax
  800136:	8d 58 01             	lea    0x1(%eax),%ebx
  800139:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80013c:	89 19                	mov    %ebx,(%ecx)
  80013e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800141:	89 cb                	mov    %ecx,%ebx
  800143:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800146:	88 5c 01 08          	mov    %bl,0x8(%ecx,%eax,1)
	if (b->idx == 256-1) {
  80014a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014d:	8b 00                	mov    (%eax),%eax
  80014f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800154:	75 25                	jne    80017b <putch+0x60>
		sys_cputs(b->buf, b->idx);
  800156:	8b 45 0c             	mov    0xc(%ebp),%eax
  800159:	8b 00                	mov    (%eax),%eax
  80015b:	89 c1                	mov    %eax,%ecx
  80015d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800160:	83 c0 08             	add    $0x8,%eax
  800163:	83 ec 08             	sub    $0x8,%esp
  800166:	51                   	push   %ecx
  800167:	50                   	push   %eax
  800168:	89 d3                	mov    %edx,%ebx
  80016a:	e8 ef 0d 00 00       	call   800f5e <sys_cputs>
  80016f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800172:	8b 45 0c             	mov    0xc(%ebp),%eax
  800175:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80017b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80017e:	8b 40 04             	mov    0x4(%eax),%eax
  800181:	8d 50 01             	lea    0x1(%eax),%edx
  800184:	8b 45 0c             	mov    0xc(%ebp),%eax
  800187:	89 50 04             	mov    %edx,0x4(%eax)
}
  80018a:	90                   	nop
  80018b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800190:	f3 0f 1e fb          	endbr32 
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	53                   	push   %ebx
  800198:	81 ec 14 01 00 00    	sub    $0x114,%esp
  80019e:	e8 dc fe ff ff       	call   80007f <__x86.get_pc_thunk.bx>
  8001a3:	81 c3 5d 1e 00 00    	add    $0x1e5d,%ebx
	struct printbuf b;

	b.idx = 0;
  8001a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b0:	00 00 00 
	b.cnt = 0;
  8001b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ba:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bd:	ff 75 0c             	pushl  0xc(%ebp)
  8001c0:	ff 75 08             	pushl  0x8(%ebp)
  8001c3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c9:	50                   	push   %eax
  8001ca:	8d 83 1b e1 ff ff    	lea    -0x1ee5(%ebx),%eax
  8001d0:	50                   	push   %eax
  8001d1:	e8 e3 01 00 00       	call   8003b9 <vprintfmt>
  8001d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  8001d9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001df:	83 ec 08             	sub    $0x8,%esp
  8001e2:	50                   	push   %eax
  8001e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e9:	83 c0 08             	add    $0x8,%eax
  8001ec:	50                   	push   %eax
  8001ed:	e8 6c 0d 00 00       	call   800f5e <sys_cputs>
  8001f2:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  8001f5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8001fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001fe:	c9                   	leave  
  8001ff:	c3                   	ret    

00800200 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800200:	f3 0f 1e fb          	endbr32 
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	83 ec 18             	sub    $0x18,%esp
  80020a:	e8 08 ff ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  80020f:	05 f1 1d 00 00       	add    $0x1df1,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800214:	8d 45 0c             	lea    0xc(%ebp),%eax
  800217:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
  80021a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	50                   	push   %eax
  800221:	ff 75 08             	pushl  0x8(%ebp)
  800224:	e8 67 ff ff ff       	call   800190 <vcprintf>
  800229:	83 c4 10             	add    $0x10,%esp
  80022c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
  80022f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800232:	c9                   	leave  
  800233:	c3                   	ret    

00800234 <__x86.get_pc_thunk.dx>:
  800234:	8b 14 24             	mov    (%esp),%edx
  800237:	c3                   	ret    

00800238 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800238:	f3 0f 1e fb          	endbr32 
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	57                   	push   %edi
  800240:	56                   	push   %esi
  800241:	53                   	push   %ebx
  800242:	83 ec 1c             	sub    $0x1c,%esp
  800245:	e8 43 06 00 00       	call   80088d <__x86.get_pc_thunk.si>
  80024a:	81 c6 b6 1d 00 00    	add    $0x1db6,%esi
  800250:	8b 45 10             	mov    0x10(%ebp),%eax
  800253:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800256:	8b 45 14             	mov    0x14(%ebp),%eax
  800259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80025c:	8b 45 18             	mov    0x18(%ebp),%eax
  80025f:	ba 00 00 00 00       	mov    $0x0,%edx
  800264:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800267:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  80026a:	19 d1                	sbb    %edx,%ecx
  80026c:	72 4d                	jb     8002bb <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800271:	8d 78 ff             	lea    -0x1(%eax),%edi
  800274:	8b 45 18             	mov    0x18(%ebp),%eax
  800277:	ba 00 00 00 00       	mov    $0x0,%edx
  80027c:	52                   	push   %edx
  80027d:	50                   	push   %eax
  80027e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800281:	ff 75 e0             	pushl  -0x20(%ebp)
  800284:	89 f3                	mov    %esi,%ebx
  800286:	e8 05 0e 00 00       	call   801090 <__udivdi3>
  80028b:	83 c4 10             	add    $0x10,%esp
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	ff 75 20             	pushl  0x20(%ebp)
  800294:	57                   	push   %edi
  800295:	ff 75 18             	pushl  0x18(%ebp)
  800298:	52                   	push   %edx
  800299:	50                   	push   %eax
  80029a:	ff 75 0c             	pushl  0xc(%ebp)
  80029d:	ff 75 08             	pushl  0x8(%ebp)
  8002a0:	e8 93 ff ff ff       	call   800238 <printnum>
  8002a5:	83 c4 20             	add    $0x20,%esp
  8002a8:	eb 1b                	jmp    8002c5 <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 20             	pushl  0x20(%ebp)
  8002b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b6:	ff d0                	call   *%eax
  8002b8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002bb:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8002bf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8002c3:	7f e5                	jg     8002aa <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002d3:	53                   	push   %ebx
  8002d4:	51                   	push   %ecx
  8002d5:	52                   	push   %edx
  8002d6:	50                   	push   %eax
  8002d7:	89 f3                	mov    %esi,%ebx
  8002d9:	e8 c2 0e 00 00       	call   8011a0 <__umoddi3>
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	8d 8e 89 f3 ff ff    	lea    -0xc77(%esi),%ecx
  8002e7:	01 c8                	add    %ecx,%eax
  8002e9:	0f b6 00             	movzbl (%eax),%eax
  8002ec:	0f be c0             	movsbl %al,%eax
  8002ef:	83 ec 08             	sub    $0x8,%esp
  8002f2:	ff 75 0c             	pushl  0xc(%ebp)
  8002f5:	50                   	push   %eax
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	ff d0                	call   *%eax
  8002fb:	83 c4 10             	add    $0x10,%esp
}
  8002fe:	90                   	nop
  8002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800302:	5b                   	pop    %ebx
  800303:	5e                   	pop    %esi
  800304:	5f                   	pop    %edi
  800305:	5d                   	pop    %ebp
  800306:	c3                   	ret    

00800307 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800307:	f3 0f 1e fb          	endbr32 
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	e8 04 fe ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800313:	05 ed 1c 00 00       	add    $0x1ced,%eax
	if (lflag >= 2)
  800318:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80031c:	7e 14                	jle    800332 <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	8b 00                	mov    (%eax),%eax
  800323:	8d 48 08             	lea    0x8(%eax),%ecx
  800326:	8b 55 08             	mov    0x8(%ebp),%edx
  800329:	89 0a                	mov    %ecx,(%edx)
  80032b:	8b 50 04             	mov    0x4(%eax),%edx
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	eb 30                	jmp    800362 <getuint+0x5b>
	else if (lflag)
  800332:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800336:	74 16                	je     80034e <getuint+0x47>
		return va_arg(*ap, unsigned long);
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	8b 00                	mov    (%eax),%eax
  80033d:	8d 48 04             	lea    0x4(%eax),%ecx
  800340:	8b 55 08             	mov    0x8(%ebp),%edx
  800343:	89 0a                	mov    %ecx,(%edx)
  800345:	8b 00                	mov    (%eax),%eax
  800347:	ba 00 00 00 00       	mov    $0x0,%edx
  80034c:	eb 14                	jmp    800362 <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	8d 48 04             	lea    0x4(%eax),%ecx
  800356:	8b 55 08             	mov    0x8(%ebp),%edx
  800359:	89 0a                	mov    %ecx,(%edx)
  80035b:	8b 00                	mov    (%eax),%eax
  80035d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800362:	5d                   	pop    %ebp
  800363:	c3                   	ret    

00800364 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800364:	f3 0f 1e fb          	endbr32 
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	e8 a7 fd ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800370:	05 90 1c 00 00       	add    $0x1c90,%eax
	if (lflag >= 2)
  800375:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800379:	7e 14                	jle    80038f <getint+0x2b>
		return va_arg(*ap, long long);
  80037b:	8b 45 08             	mov    0x8(%ebp),%eax
  80037e:	8b 00                	mov    (%eax),%eax
  800380:	8d 48 08             	lea    0x8(%eax),%ecx
  800383:	8b 55 08             	mov    0x8(%ebp),%edx
  800386:	89 0a                	mov    %ecx,(%edx)
  800388:	8b 50 04             	mov    0x4(%eax),%edx
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	eb 28                	jmp    8003b7 <getint+0x53>
	else if (lflag)
  80038f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800393:	74 12                	je     8003a7 <getint+0x43>
		return va_arg(*ap, long);
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	8b 00                	mov    (%eax),%eax
  80039a:	8d 48 04             	lea    0x4(%eax),%ecx
  80039d:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a0:	89 0a                	mov    %ecx,(%edx)
  8003a2:	8b 00                	mov    (%eax),%eax
  8003a4:	99                   	cltd   
  8003a5:	eb 10                	jmp    8003b7 <getint+0x53>
	else
		return va_arg(*ap, int);
  8003a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003aa:	8b 00                	mov    (%eax),%eax
  8003ac:	8d 48 04             	lea    0x4(%eax),%ecx
  8003af:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b2:	89 0a                	mov    %ecx,(%edx)
  8003b4:	8b 00                	mov    (%eax),%eax
  8003b6:	99                   	cltd   
}
  8003b7:	5d                   	pop    %ebp
  8003b8:	c3                   	ret    

008003b9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003b9:	f3 0f 1e fb          	endbr32 
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	57                   	push   %edi
  8003c1:	56                   	push   %esi
  8003c2:	53                   	push   %ebx
  8003c3:	83 ec 2c             	sub    $0x2c,%esp
  8003c6:	e8 c6 04 00 00       	call   800891 <__x86.get_pc_thunk.di>
  8003cb:	81 c7 35 1c 00 00    	add    $0x1c35,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003d1:	eb 17                	jmp    8003ea <vprintfmt+0x31>
			if (ch == '\0')
  8003d3:	85 db                	test   %ebx,%ebx
  8003d5:	0f 84 96 03 00 00    	je     800771 <.L20+0x2d>
				return;
			putch(ch, putdat);
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	ff 75 0c             	pushl  0xc(%ebp)
  8003e1:	53                   	push   %ebx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	ff d0                	call   *%eax
  8003e7:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ed:	8d 50 01             	lea    0x1(%eax),%edx
  8003f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8003f3:	0f b6 00             	movzbl (%eax),%eax
  8003f6:	0f b6 d8             	movzbl %al,%ebx
  8003f9:	83 fb 25             	cmp    $0x25,%ebx
  8003fc:	75 d5                	jne    8003d3 <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
  8003fe:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
  800402:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
  800409:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
  800410:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
  800417:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	8b 45 10             	mov    0x10(%ebp),%eax
  800421:	8d 50 01             	lea    0x1(%eax),%edx
  800424:	89 55 10             	mov    %edx,0x10(%ebp)
  800427:	0f b6 00             	movzbl (%eax),%eax
  80042a:	0f b6 d8             	movzbl %al,%ebx
  80042d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800430:	83 f8 55             	cmp    $0x55,%eax
  800433:	0f 87 0b 03 00 00    	ja     800744 <.L20>
  800439:	c1 e0 02             	shl    $0x2,%eax
  80043c:	8b 84 38 b0 f3 ff ff 	mov    -0xc50(%eax,%edi,1),%eax
  800443:	01 f8                	add    %edi,%eax
  800445:	3e ff e0             	notrack jmp *%eax

00800448 <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
  800448:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
  80044c:	eb d0                	jmp    80041e <vprintfmt+0x65>

0080044e <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80044e:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
  800452:	eb ca                	jmp    80041e <vprintfmt+0x65>

00800454 <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800454:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
  80045b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80045e:	89 d0                	mov    %edx,%eax
  800460:	c1 e0 02             	shl    $0x2,%eax
  800463:	01 d0                	add    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d8                	add    %ebx,%eax
  800469:	83 e8 30             	sub    $0x30,%eax
  80046c:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
  80046f:	8b 45 10             	mov    0x10(%ebp),%eax
  800472:	0f b6 00             	movzbl (%eax),%eax
  800475:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800478:	83 fb 2f             	cmp    $0x2f,%ebx
  80047b:	7e 39                	jle    8004b6 <.L37+0xc>
  80047d:	83 fb 39             	cmp    $0x39,%ebx
  800480:	7f 34                	jg     8004b6 <.L37+0xc>
			for (precision = 0; ; ++fmt) {
  800482:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
  800486:	eb d3                	jmp    80045b <.L31+0x7>

00800488 <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8d 50 04             	lea    0x4(%eax),%edx
  80048e:	89 55 14             	mov    %edx,0x14(%ebp)
  800491:	8b 00                	mov    (%eax),%eax
  800493:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
  800496:	eb 1f                	jmp    8004b7 <.L37+0xd>

00800498 <.L33>:

		case '.':
			if (width < 0)
  800498:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80049c:	79 80                	jns    80041e <vprintfmt+0x65>
				width = 0;
  80049e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
  8004a5:	e9 74 ff ff ff       	jmp    80041e <vprintfmt+0x65>

008004aa <.L37>:

		case '#':
			altflag = 1;
  8004aa:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
  8004b1:	e9 68 ff ff ff       	jmp    80041e <vprintfmt+0x65>
			goto process_precision;
  8004b6:	90                   	nop

		process_precision:
			if (width < 0)
  8004b7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004bb:	0f 89 5d ff ff ff    	jns    80041e <vprintfmt+0x65>
				width = precision, precision = -1;
  8004c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004c7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
  8004ce:	e9 4b ff ff ff       	jmp    80041e <vprintfmt+0x65>

008004d3 <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004d3:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004d7:	e9 42 ff ff ff       	jmp    80041e <vprintfmt+0x65>

008004dc <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	8d 50 04             	lea    0x4(%eax),%edx
  8004e2:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	ff 75 0c             	pushl  0xc(%ebp)
  8004ed:	50                   	push   %eax
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	ff d0                	call   *%eax
  8004f3:	83 c4 10             	add    $0x10,%esp
			break;
  8004f6:	e9 71 02 00 00       	jmp    80076c <.L20+0x28>

008004fb <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	8d 50 04             	lea    0x4(%eax),%edx
  800501:	89 55 14             	mov    %edx,0x14(%ebp)
  800504:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800506:	85 db                	test   %ebx,%ebx
  800508:	79 02                	jns    80050c <.L28+0x11>
				err = -err;
  80050a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050c:	83 fb 06             	cmp    $0x6,%ebx
  80050f:	7f 0b                	jg     80051c <.L28+0x21>
  800511:	8b b4 9f 10 00 00 00 	mov    0x10(%edi,%ebx,4),%esi
  800518:	85 f6                	test   %esi,%esi
  80051a:	75 1b                	jne    800537 <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
  80051c:	53                   	push   %ebx
  80051d:	8d 87 9a f3 ff ff    	lea    -0xc66(%edi),%eax
  800523:	50                   	push   %eax
  800524:	ff 75 0c             	pushl  0xc(%ebp)
  800527:	ff 75 08             	pushl  0x8(%ebp)
  80052a:	e8 4b 02 00 00       	call   80077a <printfmt>
  80052f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800532:	e9 35 02 00 00       	jmp    80076c <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
  800537:	56                   	push   %esi
  800538:	8d 87 a3 f3 ff ff    	lea    -0xc5d(%edi),%eax
  80053e:	50                   	push   %eax
  80053f:	ff 75 0c             	pushl  0xc(%ebp)
  800542:	ff 75 08             	pushl  0x8(%ebp)
  800545:	e8 30 02 00 00       	call   80077a <printfmt>
  80054a:	83 c4 10             	add    $0x10,%esp
			break;
  80054d:	e9 1a 02 00 00       	jmp    80076c <.L20+0x28>

00800552 <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8d 50 04             	lea    0x4(%eax),%edx
  800558:	89 55 14             	mov    %edx,0x14(%ebp)
  80055b:	8b 30                	mov    (%eax),%esi
  80055d:	85 f6                	test   %esi,%esi
  80055f:	75 06                	jne    800567 <.L24+0x15>
				p = "(null)";
  800561:	8d b7 a6 f3 ff ff    	lea    -0xc5a(%edi),%esi
			if (width > 0 && padc != '-')
  800567:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80056b:	7e 71                	jle    8005de <.L24+0x8c>
  80056d:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  800571:	74 6b                	je     8005de <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800573:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	50                   	push   %eax
  80057a:	56                   	push   %esi
  80057b:	89 fb                	mov    %edi,%ebx
  80057d:	e8 47 03 00 00       	call   8008c9 <strnlen>
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	29 45 d4             	sub    %eax,-0x2c(%ebp)
  800588:	eb 17                	jmp    8005a1 <.L24+0x4f>
					putch(padc, putdat);
  80058a:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	ff 75 0c             	pushl  0xc(%ebp)
  800594:	50                   	push   %eax
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	ff d0                	call   *%eax
  80059a:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
  80059d:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  8005a1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005a5:	7f e3                	jg     80058a <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a7:	eb 35                	jmp    8005de <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8005ad:	74 1c                	je     8005cb <.L24+0x79>
  8005af:	83 fb 1f             	cmp    $0x1f,%ebx
  8005b2:	7e 05                	jle    8005b9 <.L24+0x67>
  8005b4:	83 fb 7e             	cmp    $0x7e,%ebx
  8005b7:	7e 12                	jle    8005cb <.L24+0x79>
					putch('?', putdat);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	ff 75 0c             	pushl  0xc(%ebp)
  8005bf:	6a 3f                	push   $0x3f
  8005c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c4:	ff d0                	call   *%eax
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	eb 0f                	jmp    8005da <.L24+0x88>
				else
					putch(ch, putdat);
  8005cb:	83 ec 08             	sub    $0x8,%esp
  8005ce:	ff 75 0c             	pushl  0xc(%ebp)
  8005d1:	53                   	push   %ebx
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	ff d0                	call   *%eax
  8005d7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005da:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  8005de:	89 f0                	mov    %esi,%eax
  8005e0:	8d 70 01             	lea    0x1(%eax),%esi
  8005e3:	0f b6 00             	movzbl (%eax),%eax
  8005e6:	0f be d8             	movsbl %al,%ebx
  8005e9:	85 db                	test   %ebx,%ebx
  8005eb:	74 26                	je     800613 <.L24+0xc1>
  8005ed:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005f1:	78 b6                	js     8005a9 <.L24+0x57>
  8005f3:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  8005f7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005fb:	79 ac                	jns    8005a9 <.L24+0x57>
			for (; width > 0; width--)
  8005fd:	eb 14                	jmp    800613 <.L24+0xc1>
				putch(' ', putdat);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	6a 20                	push   $0x20
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	ff d0                	call   *%eax
  80060c:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
  80060f:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800613:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800617:	7f e6                	jg     8005ff <.L24+0xad>
			break;
  800619:	e9 4e 01 00 00       	jmp    80076c <.L20+0x28>

0080061e <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	ff 75 d8             	pushl  -0x28(%ebp)
  800624:	8d 45 14             	lea    0x14(%ebp),%eax
  800627:	50                   	push   %eax
  800628:	e8 37 fd ff ff       	call   800364 <getint>
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800633:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
  800636:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800639:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80063c:	85 d2                	test   %edx,%edx
  80063e:	79 23                	jns    800663 <.L29+0x45>
				putch('-', putdat);
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	ff 75 0c             	pushl  0xc(%ebp)
  800646:	6a 2d                	push   $0x2d
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	ff d0                	call   *%eax
  80064d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800650:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800653:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800656:	f7 d8                	neg    %eax
  800658:	83 d2 00             	adc    $0x0,%edx
  80065b:	f7 da                	neg    %edx
  80065d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800660:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
  800663:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  80066a:	e9 9f 00 00 00       	jmp    80070e <.L21+0x1f>

0080066f <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80066f:	83 ec 08             	sub    $0x8,%esp
  800672:	ff 75 d8             	pushl  -0x28(%ebp)
  800675:	8d 45 14             	lea    0x14(%ebp),%eax
  800678:	50                   	push   %eax
  800679:	e8 89 fc ff ff       	call   800307 <getuint>
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800684:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
  800687:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  80068e:	eb 7e                	jmp    80070e <.L21+0x1f>

00800690 <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	ff 75 d8             	pushl  -0x28(%ebp)
  800696:	8d 45 14             	lea    0x14(%ebp),%eax
  800699:	50                   	push   %eax
  80069a:	e8 68 fc ff ff       	call   800307 <getuint>
  80069f:	83 c4 10             	add    $0x10,%esp
  8006a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
  8006a8:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
  8006af:	eb 5d                	jmp    80070e <.L21+0x1f>

008006b1 <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	ff 75 0c             	pushl  0xc(%ebp)
  8006b7:	6a 30                	push   $0x30
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	ff d0                	call   *%eax
  8006be:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	ff 75 0c             	pushl  0xc(%ebp)
  8006c7:	6a 78                	push   $0x78
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	ff d0                	call   *%eax
  8006ce:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8d 50 04             	lea    0x4(%eax),%edx
  8006d7:	89 55 14             	mov    %edx,0x14(%ebp)
  8006da:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
  8006dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
  8006e6:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
  8006ed:	eb 1f                	jmp    80070e <.L21+0x1f>

008006ef <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 d8             	pushl  -0x28(%ebp)
  8006f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f8:	50                   	push   %eax
  8006f9:	e8 09 fc ff ff       	call   800307 <getuint>
  8006fe:	83 c4 10             	add    $0x10,%esp
  800701:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800704:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
  800707:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80070e:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  800712:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800715:	83 ec 04             	sub    $0x4,%esp
  800718:	52                   	push   %edx
  800719:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071c:	50                   	push   %eax
  80071d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800720:	ff 75 e0             	pushl  -0x20(%ebp)
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	ff 75 08             	pushl  0x8(%ebp)
  800729:	e8 0a fb ff ff       	call   800238 <printnum>
  80072e:	83 c4 20             	add    $0x20,%esp
			break;
  800731:	eb 39                	jmp    80076c <.L20+0x28>

00800733 <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800733:	83 ec 08             	sub    $0x8,%esp
  800736:	ff 75 0c             	pushl  0xc(%ebp)
  800739:	53                   	push   %ebx
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	ff d0                	call   *%eax
  80073f:	83 c4 10             	add    $0x10,%esp
			break;
  800742:	eb 28                	jmp    80076c <.L20+0x28>

00800744 <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	6a 25                	push   $0x25
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	ff d0                	call   *%eax
  800751:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800754:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800758:	eb 04                	jmp    80075e <.L20+0x1a>
  80075a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  80075e:	8b 45 10             	mov    0x10(%ebp),%eax
  800761:	83 e8 01             	sub    $0x1,%eax
  800764:	0f b6 00             	movzbl (%eax),%eax
  800767:	3c 25                	cmp    $0x25,%al
  800769:	75 ef                	jne    80075a <.L20+0x16>
				/* do nothing */;
			break;
  80076b:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076c:	e9 79 fc ff ff       	jmp    8003ea <vprintfmt+0x31>
				return;
  800771:	90                   	nop
		}
	}
}
  800772:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800775:	5b                   	pop    %ebx
  800776:	5e                   	pop    %esi
  800777:	5f                   	pop    %edi
  800778:	5d                   	pop    %ebp
  800779:	c3                   	ret    

0080077a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80077a:	f3 0f 1e fb          	endbr32 
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	83 ec 18             	sub    $0x18,%esp
  800784:	e8 8e f9 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800789:	05 77 18 00 00       	add    $0x1877,%eax
	va_list ap;

	va_start(ap, fmt);
  80078e:	8d 45 14             	lea    0x14(%ebp),%eax
  800791:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800797:	50                   	push   %eax
  800798:	ff 75 10             	pushl  0x10(%ebp)
  80079b:	ff 75 0c             	pushl  0xc(%ebp)
  80079e:	ff 75 08             	pushl  0x8(%ebp)
  8007a1:	e8 13 fc ff ff       	call   8003b9 <vprintfmt>
  8007a6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8007a9:	90                   	nop
  8007aa:	c9                   	leave  
  8007ab:	c3                   	ret    

008007ac <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007ac:	f3 0f 1e fb          	endbr32 
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	e8 5f f9 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  8007b8:	05 48 18 00 00       	add    $0x1848,%eax
	b->cnt++;
  8007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c0:	8b 40 08             	mov    0x8(%eax),%eax
  8007c3:	8d 50 01             	lea    0x1(%eax),%edx
  8007c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8007cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cf:	8b 10                	mov    (%eax),%edx
  8007d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d4:	8b 40 04             	mov    0x4(%eax),%eax
  8007d7:	39 c2                	cmp    %eax,%edx
  8007d9:	73 12                	jae    8007ed <sprintputch+0x41>
		*b->buf++ = ch;
  8007db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	8d 48 01             	lea    0x1(%eax),%ecx
  8007e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e6:	89 0a                	mov    %ecx,(%edx)
  8007e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8007eb:	88 10                	mov    %dl,(%eax)
}
  8007ed:	90                   	nop
  8007ee:	5d                   	pop    %ebp
  8007ef:	c3                   	ret    

008007f0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f0:	f3 0f 1e fb          	endbr32 
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
  8007f7:	83 ec 18             	sub    $0x18,%esp
  8007fa:	e8 18 f9 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  8007ff:	05 01 18 00 00       	add    $0x1801,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
  800804:	8b 55 08             	mov    0x8(%ebp),%edx
  800807:	89 55 ec             	mov    %edx,-0x14(%ebp)
  80080a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080d:	8d 4a ff             	lea    -0x1(%edx),%ecx
  800810:	8b 55 08             	mov    0x8(%ebp),%edx
  800813:	01 ca                	add    %ecx,%edx
  800815:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800818:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80081f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800823:	74 06                	je     80082b <vsnprintf+0x3b>
  800825:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800829:	7f 07                	jg     800832 <vsnprintf+0x42>
		return -E_INVAL;
  80082b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800830:	eb 22                	jmp    800854 <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800832:	ff 75 14             	pushl  0x14(%ebp)
  800835:	ff 75 10             	pushl  0x10(%ebp)
  800838:	8d 55 ec             	lea    -0x14(%ebp),%edx
  80083b:	52                   	push   %edx
  80083c:	8d 80 ac e7 ff ff    	lea    -0x1854(%eax),%eax
  800842:	50                   	push   %eax
  800843:	e8 71 fb ff ff       	call   8003b9 <vprintfmt>
  800848:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80084b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800851:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800854:	c9                   	leave  
  800855:	c3                   	ret    

00800856 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800856:	f3 0f 1e fb          	endbr32 
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	83 ec 18             	sub    $0x18,%esp
  800860:	e8 b2 f8 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800865:	05 9b 17 00 00       	add    $0x179b,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80086a:	8d 45 14             	lea    0x14(%ebp),%eax
  80086d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800873:	50                   	push   %eax
  800874:	ff 75 10             	pushl  0x10(%ebp)
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	ff 75 08             	pushl  0x8(%ebp)
  80087d:	e8 6e ff ff ff       	call   8007f0 <vsnprintf>
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
  800888:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80088b:	c9                   	leave  
  80088c:	c3                   	ret    

0080088d <__x86.get_pc_thunk.si>:
  80088d:	8b 34 24             	mov    (%esp),%esi
  800890:	c3                   	ret    

00800891 <__x86.get_pc_thunk.di>:
  800891:	8b 3c 24             	mov    (%esp),%edi
  800894:	c3                   	ret    

00800895 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800895:	f3 0f 1e fb          	endbr32 
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	83 ec 10             	sub    $0x10,%esp
  80089f:	e8 73 f8 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  8008a4:	05 5c 17 00 00       	add    $0x175c,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008b0:	eb 08                	jmp    8008ba <strlen+0x25>
		n++;
  8008b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
  8008b6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	0f b6 00             	movzbl (%eax),%eax
  8008c0:	84 c0                	test   %al,%al
  8008c2:	75 ee                	jne    8008b2 <strlen+0x1d>
	return n;
  8008c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c9:	f3 0f 1e fb          	endbr32 
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	83 ec 10             	sub    $0x10,%esp
  8008d3:	e8 3f f8 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  8008d8:	05 28 17 00 00       	add    $0x1728,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008e4:	eb 0c                	jmp    8008f2 <strnlen+0x29>
		n++;
  8008e6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8008ee:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  8008f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f6:	74 0a                	je     800902 <strnlen+0x39>
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	0f b6 00             	movzbl (%eax),%eax
  8008fe:	84 c0                	test   %al,%al
  800900:	75 e4                	jne    8008e6 <strnlen+0x1d>
	return n;
  800902:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800905:	c9                   	leave  
  800906:	c3                   	ret    

00800907 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800907:	f3 0f 1e fb          	endbr32 
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	83 ec 10             	sub    $0x10,%esp
  800911:	e8 01 f8 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800916:	05 ea 16 00 00       	add    $0x16ea,%eax
	char *ret;

	ret = dst;
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800921:	90                   	nop
  800922:	8b 55 0c             	mov    0xc(%ebp),%edx
  800925:	8d 42 01             	lea    0x1(%edx),%eax
  800928:	89 45 0c             	mov    %eax,0xc(%ebp)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8d 48 01             	lea    0x1(%eax),%ecx
  800931:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800934:	0f b6 12             	movzbl (%edx),%edx
  800937:	88 10                	mov    %dl,(%eax)
  800939:	0f b6 00             	movzbl (%eax),%eax
  80093c:	84 c0                	test   %al,%al
  80093e:	75 e2                	jne    800922 <strcpy+0x1b>
		/* do nothing */;
	return ret;
  800940:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800945:	f3 0f 1e fb          	endbr32 
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 10             	sub    $0x10,%esp
  80094f:	e8 c3 f7 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800954:	05 ac 16 00 00       	add    $0x16ac,%eax
	int len = strlen(dst);
  800959:	ff 75 08             	pushl  0x8(%ebp)
  80095c:	e8 34 ff ff ff       	call   800895 <strlen>
  800961:	83 c4 04             	add    $0x4,%esp
  800964:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
  800967:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	01 d0                	add    %edx,%eax
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	50                   	push   %eax
  800973:	e8 8f ff ff ff       	call   800907 <strcpy>
  800978:	83 c4 08             	add    $0x8,%esp
	return dst;
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    

00800980 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800980:	f3 0f 1e fb          	endbr32 
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	83 ec 10             	sub    $0x10,%esp
  80098a:	e8 88 f7 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  80098f:	05 71 16 00 00       	add    $0x1671,%eax
	size_t i;
	char *ret;

	ret = dst;
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80099a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009a1:	eb 23                	jmp    8009c6 <strncpy+0x46>
		*dst++ = *src;
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	8d 50 01             	lea    0x1(%eax),%edx
  8009a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8009ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009af:	0f b6 12             	movzbl (%edx),%edx
  8009b2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b7:	0f b6 00             	movzbl (%eax),%eax
  8009ba:	84 c0                	test   %al,%al
  8009bc:	74 04                	je     8009c2 <strncpy+0x42>
			src++;
  8009be:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
  8009c2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  8009c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009c9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009cc:	72 d5                	jb     8009a3 <strncpy+0x23>
	}
	return ret;
  8009ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009d1:	c9                   	leave  
  8009d2:	c3                   	ret    

008009d3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d3:	f3 0f 1e fb          	endbr32 
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	83 ec 10             	sub    $0x10,%esp
  8009dd:	e8 35 f7 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  8009e2:	05 1e 16 00 00       	add    $0x161e,%eax
	char *dst_in;

	dst_in = dst;
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009f1:	74 33                	je     800a26 <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
  8009f3:	eb 17                	jmp    800a0c <strlcpy+0x39>
			*dst++ = *src++;
  8009f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f8:	8d 42 01             	lea    0x1(%edx),%eax
  8009fb:	89 45 0c             	mov    %eax,0xc(%ebp)
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8d 48 01             	lea    0x1(%eax),%ecx
  800a04:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800a07:	0f b6 12             	movzbl (%edx),%edx
  800a0a:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
  800a0c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800a10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a14:	74 0a                	je     800a20 <strlcpy+0x4d>
  800a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a19:	0f b6 00             	movzbl (%eax),%eax
  800a1c:	84 c0                	test   %al,%al
  800a1e:	75 d5                	jne    8009f5 <strlcpy+0x22>
		*dst = '\0';
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
  800a2c:	c9                   	leave  
  800a2d:	c3                   	ret    

00800a2e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2e:	f3 0f 1e fb          	endbr32 
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	e8 dd f6 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800a3a:	05 c6 15 00 00       	add    $0x15c6,%eax
	while (*p && *p == *q)
  800a3f:	eb 08                	jmp    800a49 <strcmp+0x1b>
		p++, q++;
  800a41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a45:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	0f b6 00             	movzbl (%eax),%eax
  800a4f:	84 c0                	test   %al,%al
  800a51:	74 10                	je     800a63 <strcmp+0x35>
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	0f b6 10             	movzbl (%eax),%edx
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	0f b6 00             	movzbl (%eax),%eax
  800a5f:	38 c2                	cmp    %al,%dl
  800a61:	74 de                	je     800a41 <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	0f b6 00             	movzbl (%eax),%eax
  800a69:	0f b6 d0             	movzbl %al,%edx
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	0f b6 00             	movzbl (%eax),%eax
  800a72:	0f b6 c0             	movzbl %al,%eax
  800a75:	29 c2                	sub    %eax,%edx
  800a77:	89 d0                	mov    %edx,%eax
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a7b:	f3 0f 1e fb          	endbr32 
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	e8 90 f6 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800a87:	05 79 15 00 00       	add    $0x1579,%eax
	while (n > 0 && *p && *p == *q)
  800a8c:	eb 0c                	jmp    800a9a <strncmp+0x1f>
		n--, p++, q++;
  800a8e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800a92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a96:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
  800a9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a9e:	74 1a                	je     800aba <strncmp+0x3f>
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	0f b6 00             	movzbl (%eax),%eax
  800aa6:	84 c0                	test   %al,%al
  800aa8:	74 10                	je     800aba <strncmp+0x3f>
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	0f b6 10             	movzbl (%eax),%edx
  800ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab3:	0f b6 00             	movzbl (%eax),%eax
  800ab6:	38 c2                	cmp    %al,%dl
  800ab8:	74 d4                	je     800a8e <strncmp+0x13>
	if (n == 0)
  800aba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800abe:	75 07                	jne    800ac7 <strncmp+0x4c>
		return 0;
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac5:	eb 16                	jmp    800add <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	0f b6 00             	movzbl (%eax),%eax
  800acd:	0f b6 d0             	movzbl %al,%edx
  800ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad3:	0f b6 00             	movzbl (%eax),%eax
  800ad6:	0f b6 c0             	movzbl %al,%eax
  800ad9:	29 c2                	sub    %eax,%edx
  800adb:	89 d0                	mov    %edx,%eax
}
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    

00800adf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800adf:	f3 0f 1e fb          	endbr32 
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	83 ec 04             	sub    $0x4,%esp
  800ae9:	e8 29 f6 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800aee:	05 12 15 00 00       	add    $0x1512,%eax
  800af3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800af9:	eb 14                	jmp    800b0f <strchr+0x30>
		if (*s == c)
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	0f b6 00             	movzbl (%eax),%eax
  800b01:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800b04:	75 05                	jne    800b0b <strchr+0x2c>
			return (char *) s;
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	eb 13                	jmp    800b1e <strchr+0x3f>
	for (; *s; s++)
  800b0b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	0f b6 00             	movzbl (%eax),%eax
  800b15:	84 c0                	test   %al,%al
  800b17:	75 e2                	jne    800afb <strchr+0x1c>
	return 0;
  800b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b20:	f3 0f 1e fb          	endbr32 
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	83 ec 04             	sub    $0x4,%esp
  800b2a:	e8 e8 f5 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800b2f:	05 d1 14 00 00       	add    $0x14d1,%eax
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b3a:	eb 0f                	jmp    800b4b <strfind+0x2b>
		if (*s == c)
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	0f b6 00             	movzbl (%eax),%eax
  800b42:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800b45:	74 10                	je     800b57 <strfind+0x37>
	for (; *s; s++)
  800b47:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	0f b6 00             	movzbl (%eax),%eax
  800b51:	84 c0                	test   %al,%al
  800b53:	75 e7                	jne    800b3c <strfind+0x1c>
  800b55:	eb 01                	jmp    800b58 <strfind+0x38>
			break;
  800b57:	90                   	nop
	return (char *) s;
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    

00800b5d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b5d:	f3 0f 1e fb          	endbr32 
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	57                   	push   %edi
  800b65:	e8 ad f5 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800b6a:	05 96 14 00 00       	add    $0x1496,%eax
	char *p;

	if (n == 0)
  800b6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b73:	75 05                	jne    800b7a <memset+0x1d>
		return v;
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	eb 5c                	jmp    800bd6 <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	83 e0 03             	and    $0x3,%eax
  800b80:	85 c0                	test   %eax,%eax
  800b82:	75 41                	jne    800bc5 <memset+0x68>
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	83 e0 03             	and    $0x3,%eax
  800b8a:	85 c0                	test   %eax,%eax
  800b8c:	75 37                	jne    800bc5 <memset+0x68>
		c &= 0xFF;
  800b8e:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	c1 e0 18             	shl    $0x18,%eax
  800b9b:	89 c2                	mov    %eax,%edx
  800b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba0:	c1 e0 10             	shl    $0x10,%eax
  800ba3:	09 c2                	or     %eax,%edx
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	c1 e0 08             	shl    $0x8,%eax
  800bab:	09 d0                	or     %edx,%eax
  800bad:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb3:	c1 e8 02             	shr    $0x2,%eax
  800bb6:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
  800bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	89 d7                	mov    %edx,%edi
  800bc0:	fc                   	cld    
  800bc1:	f3 ab                	rep stos %eax,%es:(%edi)
  800bc3:	eb 0e                	jmp    800bd3 <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800bce:	89 d7                	mov    %edx,%edi
  800bd0:	fc                   	cld    
  800bd1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd6:	5f                   	pop    %edi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bd9:	f3 0f 1e fb          	endbr32 
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	57                   	push   %edi
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	83 ec 10             	sub    $0x10,%esp
  800be6:	e8 2c f5 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800beb:	05 15 14 00 00       	add    $0x1415,%eax
	const char *s;
	char *d;

	s = src;
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
  800bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800c02:	73 6d                	jae    800c71 <memmove+0x98>
  800c04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c07:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0a:	01 d0                	add    %edx,%eax
  800c0c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  800c0f:	73 60                	jae    800c71 <memmove+0x98>
		s += n;
  800c11:	8b 45 10             	mov    0x10(%ebp),%eax
  800c14:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
  800c17:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1a:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c20:	83 e0 03             	and    $0x3,%eax
  800c23:	85 c0                	test   %eax,%eax
  800c25:	75 2f                	jne    800c56 <memmove+0x7d>
  800c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c2a:	83 e0 03             	and    $0x3,%eax
  800c2d:	85 c0                	test   %eax,%eax
  800c2f:	75 25                	jne    800c56 <memmove+0x7d>
  800c31:	8b 45 10             	mov    0x10(%ebp),%eax
  800c34:	83 e0 03             	and    $0x3,%eax
  800c37:	85 c0                	test   %eax,%eax
  800c39:	75 1b                	jne    800c56 <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c3e:	83 e8 04             	sub    $0x4,%eax
  800c41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c44:	83 ea 04             	sub    $0x4,%edx
  800c47:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c4a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c4d:	89 c7                	mov    %eax,%edi
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	fd                   	std    
  800c52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c54:	eb 18                	jmp    800c6e <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c59:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5f:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	89 d7                	mov    %edx,%edi
  800c67:	89 de                	mov    %ebx,%esi
  800c69:	89 c1                	mov    %eax,%ecx
  800c6b:	fd                   	std    
  800c6c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c6e:	fc                   	cld    
  800c6f:	eb 45                	jmp    800cb6 <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c74:	83 e0 03             	and    $0x3,%eax
  800c77:	85 c0                	test   %eax,%eax
  800c79:	75 2b                	jne    800ca6 <memmove+0xcd>
  800c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c7e:	83 e0 03             	and    $0x3,%eax
  800c81:	85 c0                	test   %eax,%eax
  800c83:	75 21                	jne    800ca6 <memmove+0xcd>
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	83 e0 03             	and    $0x3,%eax
  800c8b:	85 c0                	test   %eax,%eax
  800c8d:	75 17                	jne    800ca6 <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c92:	c1 e8 02             	shr    $0x2,%eax
  800c95:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
  800c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c9d:	89 c7                	mov    %eax,%edi
  800c9f:	89 d6                	mov    %edx,%esi
  800ca1:	fc                   	cld    
  800ca2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca4:	eb 10                	jmp    800cb6 <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
  800ca6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ca9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800cac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800caf:	89 c7                	mov    %eax,%edi
  800cb1:	89 d6                	mov    %edx,%esi
  800cb3:	fc                   	cld    
  800cb4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb9:	83 c4 10             	add    $0x10,%esp
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5f                   	pop    %edi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cc1:	f3 0f 1e fb          	endbr32 
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	e8 4a f4 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800ccd:	05 33 13 00 00       	add    $0x1333,%eax
	return memmove(dst, src, n);
  800cd2:	ff 75 10             	pushl  0x10(%ebp)
  800cd5:	ff 75 0c             	pushl  0xc(%ebp)
  800cd8:	ff 75 08             	pushl  0x8(%ebp)
  800cdb:	e8 f9 fe ff ff       	call   800bd9 <memmove>
  800ce0:	83 c4 0c             	add    $0xc,%esp
}
  800ce3:	c9                   	leave  
  800ce4:	c3                   	ret    

00800ce5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ce5:	f3 0f 1e fb          	endbr32 
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 10             	sub    $0x10,%esp
  800cef:	e8 23 f4 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800cf4:	05 0c 13 00 00       	add    $0x130c,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d05:	eb 30                	jmp    800d37 <memcmp+0x52>
		if (*s1 != *s2)
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	0f b6 10             	movzbl (%eax),%edx
  800d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d10:	0f b6 00             	movzbl (%eax),%eax
  800d13:	38 c2                	cmp    %al,%dl
  800d15:	74 18                	je     800d2f <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
  800d17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1a:	0f b6 00             	movzbl (%eax),%eax
  800d1d:	0f b6 d0             	movzbl %al,%edx
  800d20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d23:	0f b6 00             	movzbl (%eax),%eax
  800d26:	0f b6 c0             	movzbl %al,%eax
  800d29:	29 c2                	sub    %eax,%edx
  800d2b:	89 d0                	mov    %edx,%eax
  800d2d:	eb 1a                	jmp    800d49 <memcmp+0x64>
		s1++, s2++;
  800d2f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800d33:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
  800d37:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d40:	85 c0                	test   %eax,%eax
  800d42:	75 c3                	jne    800d07 <memcmp+0x22>
	}

	return 0;
  800d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d49:	c9                   	leave  
  800d4a:	c3                   	ret    

00800d4b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d4b:	f3 0f 1e fb          	endbr32 
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	83 ec 10             	sub    $0x10,%esp
  800d55:	e8 bd f3 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800d5a:	05 a6 12 00 00       	add    $0x12a6,%eax
	const void *ends = (const char *) s + n;
  800d5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d62:	8b 45 10             	mov    0x10(%ebp),%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d6a:	eb 11                	jmp    800d7d <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	0f b6 00             	movzbl (%eax),%eax
  800d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d75:	38 d0                	cmp    %dl,%al
  800d77:	74 0e                	je     800d87 <memfind+0x3c>
	for (; s < ends; s++)
  800d79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d83:	72 e7                	jb     800d6c <memfind+0x21>
  800d85:	eb 01                	jmp    800d88 <memfind+0x3d>
			break;
  800d87:	90                   	nop
	return (void *) s;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8b:	c9                   	leave  
  800d8c:	c3                   	ret    

00800d8d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d8d:	f3 0f 1e fb          	endbr32 
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
  800d97:	e8 7b f3 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800d9c:	05 64 12 00 00       	add    $0x1264,%eax
	int neg = 0;
  800da1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800da8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800daf:	eb 04                	jmp    800db5 <strtol+0x28>
		s++;
  800db1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	0f b6 00             	movzbl (%eax),%eax
  800dbb:	3c 20                	cmp    $0x20,%al
  800dbd:	74 f2                	je     800db1 <strtol+0x24>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	0f b6 00             	movzbl (%eax),%eax
  800dc5:	3c 09                	cmp    $0x9,%al
  800dc7:	74 e8                	je     800db1 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	0f b6 00             	movzbl (%eax),%eax
  800dcf:	3c 2b                	cmp    $0x2b,%al
  800dd1:	75 06                	jne    800dd9 <strtol+0x4c>
		s++;
  800dd3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dd7:	eb 15                	jmp    800dee <strtol+0x61>
	else if (*s == '-')
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	0f b6 00             	movzbl (%eax),%eax
  800ddf:	3c 2d                	cmp    $0x2d,%al
  800de1:	75 0b                	jne    800dee <strtol+0x61>
		s++, neg = 1;
  800de3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800de7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df2:	74 06                	je     800dfa <strtol+0x6d>
  800df4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800df8:	75 24                	jne    800e1e <strtol+0x91>
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	0f b6 00             	movzbl (%eax),%eax
  800e00:	3c 30                	cmp    $0x30,%al
  800e02:	75 1a                	jne    800e1e <strtol+0x91>
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	83 c0 01             	add    $0x1,%eax
  800e0a:	0f b6 00             	movzbl (%eax),%eax
  800e0d:	3c 78                	cmp    $0x78,%al
  800e0f:	75 0d                	jne    800e1e <strtol+0x91>
		s += 2, base = 16;
  800e11:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e15:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e1c:	eb 2a                	jmp    800e48 <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
  800e1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e22:	75 17                	jne    800e3b <strtol+0xae>
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	0f b6 00             	movzbl (%eax),%eax
  800e2a:	3c 30                	cmp    $0x30,%al
  800e2c:	75 0d                	jne    800e3b <strtol+0xae>
		s++, base = 8;
  800e2e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e32:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e39:	eb 0d                	jmp    800e48 <strtol+0xbb>
	else if (base == 0)
  800e3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3f:	75 07                	jne    800e48 <strtol+0xbb>
		base = 10;
  800e41:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	0f b6 00             	movzbl (%eax),%eax
  800e4e:	3c 2f                	cmp    $0x2f,%al
  800e50:	7e 1b                	jle    800e6d <strtol+0xe0>
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	0f b6 00             	movzbl (%eax),%eax
  800e58:	3c 39                	cmp    $0x39,%al
  800e5a:	7f 11                	jg     800e6d <strtol+0xe0>
			dig = *s - '0';
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	0f b6 00             	movzbl (%eax),%eax
  800e62:	0f be c0             	movsbl %al,%eax
  800e65:	83 e8 30             	sub    $0x30,%eax
  800e68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e6b:	eb 48                	jmp    800eb5 <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	0f b6 00             	movzbl (%eax),%eax
  800e73:	3c 60                	cmp    $0x60,%al
  800e75:	7e 1b                	jle    800e92 <strtol+0x105>
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	0f b6 00             	movzbl (%eax),%eax
  800e7d:	3c 7a                	cmp    $0x7a,%al
  800e7f:	7f 11                	jg     800e92 <strtol+0x105>
			dig = *s - 'a' + 10;
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	0f b6 00             	movzbl (%eax),%eax
  800e87:	0f be c0             	movsbl %al,%eax
  800e8a:	83 e8 57             	sub    $0x57,%eax
  800e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e90:	eb 23                	jmp    800eb5 <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	0f b6 00             	movzbl (%eax),%eax
  800e98:	3c 40                	cmp    $0x40,%al
  800e9a:	7e 3c                	jle    800ed8 <strtol+0x14b>
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	0f b6 00             	movzbl (%eax),%eax
  800ea2:	3c 5a                	cmp    $0x5a,%al
  800ea4:	7f 32                	jg     800ed8 <strtol+0x14b>
			dig = *s - 'A' + 10;
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	0f b6 00             	movzbl (%eax),%eax
  800eac:	0f be c0             	movsbl %al,%eax
  800eaf:	83 e8 37             	sub    $0x37,%eax
  800eb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eb8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ebb:	7d 1a                	jge    800ed7 <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
  800ebd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ec1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ec8:	89 c2                	mov    %eax,%edx
  800eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecd:	01 d0                	add    %edx,%eax
  800ecf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
  800ed2:	e9 71 ff ff ff       	jmp    800e48 <strtol+0xbb>
			break;
  800ed7:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
  800ed8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800edc:	74 08                	je     800ee6 <strtol+0x159>
		*endptr = (char *) s;
  800ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ee6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800eea:	74 07                	je     800ef3 <strtol+0x166>
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	f7 d8                	neg    %eax
  800ef1:	eb 03                	jmp    800ef6 <strtol+0x169>
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
  800efe:	83 ec 2c             	sub    $0x2c,%esp
  800f01:	e8 79 f1 ff ff       	call   80007f <__x86.get_pc_thunk.bx>
  800f06:	81 c3 fa 10 00 00    	add    $0x10fa,%ebx
  800f0c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8b 55 10             	mov    0x10(%ebp),%edx
  800f15:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800f18:	8b 5d 18             	mov    0x18(%ebp),%ebx
  800f1b:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  800f1e:	8b 75 20             	mov    0x20(%ebp),%esi
  800f21:	cd 30                	int    $0x30
  800f23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f2a:	74 27                	je     800f53 <syscall+0x5b>
  800f2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f30:	7e 21                	jle    800f53 <syscall+0x5b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f32:	83 ec 0c             	sub    $0xc,%esp
  800f35:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f38:	ff 75 08             	pushl  0x8(%ebp)
  800f3b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800f3e:	8d 83 08 f5 ff ff    	lea    -0xaf8(%ebx),%eax
  800f44:	50                   	push   %eax
  800f45:	6a 23                	push   $0x23
  800f47:	8d 83 25 f5 ff ff    	lea    -0xadb(%ebx),%eax
  800f4d:	50                   	push   %eax
  800f4e:	e8 cd 00 00 00       	call   801020 <_panic>

	return ret;
  800f53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  800f56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f59:	5b                   	pop    %ebx
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800f5e:	f3 0f 1e fb          	endbr32 
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	e8 aa f1 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800f6d:	05 93 10 00 00       	add    $0x1093,%eax
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	83 ec 04             	sub    $0x4,%esp
  800f78:	6a 00                	push   $0x0
  800f7a:	6a 00                	push   $0x0
  800f7c:	6a 00                	push   $0x0
  800f7e:	ff 75 0c             	pushl  0xc(%ebp)
  800f81:	50                   	push   %eax
  800f82:	6a 00                	push   $0x0
  800f84:	6a 00                	push   $0x0
  800f86:	e8 6d ff ff ff       	call   800ef8 <syscall>
  800f8b:	83 c4 20             	add    $0x20,%esp
}
  800f8e:	90                   	nop
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f91:	f3 0f 1e fb          	endbr32 
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 08             	sub    $0x8,%esp
  800f9b:	e8 77 f1 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800fa0:	05 60 10 00 00       	add    $0x1060,%eax
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800fa5:	83 ec 04             	sub    $0x4,%esp
  800fa8:	6a 00                	push   $0x0
  800faa:	6a 00                	push   $0x0
  800fac:	6a 00                	push   $0x0
  800fae:	6a 00                	push   $0x0
  800fb0:	6a 00                	push   $0x0
  800fb2:	6a 00                	push   $0x0
  800fb4:	6a 01                	push   $0x1
  800fb6:	e8 3d ff ff ff       	call   800ef8 <syscall>
  800fbb:	83 c4 20             	add    $0x20,%esp
}
  800fbe:	c9                   	leave  
  800fbf:	c3                   	ret    

00800fc0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fc0:	f3 0f 1e fb          	endbr32 
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	e8 48 f1 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  800fcf:	05 31 10 00 00       	add    $0x1031,%eax
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	83 ec 04             	sub    $0x4,%esp
  800fda:	6a 00                	push   $0x0
  800fdc:	6a 00                	push   $0x0
  800fde:	6a 00                	push   $0x0
  800fe0:	6a 00                	push   $0x0
  800fe2:	50                   	push   %eax
  800fe3:	6a 01                	push   $0x1
  800fe5:	6a 03                	push   $0x3
  800fe7:	e8 0c ff ff ff       	call   800ef8 <syscall>
  800fec:	83 c4 20             	add    $0x20,%esp
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ff1:	f3 0f 1e fb          	endbr32 
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	83 ec 08             	sub    $0x8,%esp
  800ffb:	e8 17 f1 ff ff       	call   800117 <__x86.get_pc_thunk.ax>
  801000:	05 00 10 00 00       	add    $0x1000,%eax
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801005:	83 ec 04             	sub    $0x4,%esp
  801008:	6a 00                	push   $0x0
  80100a:	6a 00                	push   $0x0
  80100c:	6a 00                	push   $0x0
  80100e:	6a 00                	push   $0x0
  801010:	6a 00                	push   $0x0
  801012:	6a 00                	push   $0x0
  801014:	6a 02                	push   $0x2
  801016:	e8 dd fe ff ff       	call   800ef8 <syscall>
  80101b:	83 c4 20             	add    $0x20,%esp
}
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801020:	f3 0f 1e fb          	endbr32 
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	56                   	push   %esi
  801028:	53                   	push   %ebx
  801029:	83 ec 10             	sub    $0x10,%esp
  80102c:	e8 4e f0 ff ff       	call   80007f <__x86.get_pc_thunk.bx>
  801031:	81 c3 cf 0f 00 00    	add    $0xfcf,%ebx
	va_list ap;

	va_start(ap, fmt);
  801037:	8d 45 14             	lea    0x14(%ebp),%eax
  80103a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80103d:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  801043:	8b 30                	mov    (%eax),%esi
  801045:	e8 a7 ff ff ff       	call   800ff1 <sys_getenvid>
  80104a:	83 ec 0c             	sub    $0xc,%esp
  80104d:	ff 75 0c             	pushl  0xc(%ebp)
  801050:	ff 75 08             	pushl  0x8(%ebp)
  801053:	56                   	push   %esi
  801054:	50                   	push   %eax
  801055:	8d 83 34 f5 ff ff    	lea    -0xacc(%ebx),%eax
  80105b:	50                   	push   %eax
  80105c:	e8 9f f1 ff ff       	call   800200 <cprintf>
  801061:	83 c4 20             	add    $0x20,%esp
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	83 ec 08             	sub    $0x8,%esp
  80106a:	50                   	push   %eax
  80106b:	ff 75 10             	pushl  0x10(%ebp)
  80106e:	e8 1d f1 ff ff       	call   800190 <vcprintf>
  801073:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  801076:	83 ec 0c             	sub    $0xc,%esp
  801079:	8d 83 57 f5 ff ff    	lea    -0xaa9(%ebx),%eax
  80107f:	50                   	push   %eax
  801080:	e8 7b f1 ff ff       	call   800200 <cprintf>
  801085:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801088:	cc                   	int3   
  801089:	eb fd                	jmp    801088 <_panic+0x68>
  80108b:	66 90                	xchg   %ax,%ax
  80108d:	66 90                	xchg   %ax,%ax
  80108f:	90                   	nop

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
