
obj/user/buggyhello:     file format elf32-i386


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
  80002c:	e8 32 00 00 00       	call   800063 <libmain>
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
  80003e:	e8 1c 00 00 00       	call   80005f <__x86.get_pc_thunk.ax>
  800043:	05 bd 1f 00 00       	add    $0x1fbd,%eax
	sys_cputs((char*)1, 1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	6a 01                	push   $0x1
  80004d:	6a 01                	push   $0x1
  80004f:	89 c3                	mov    %eax,%ebx
  800051:	e8 0b 01 00 00       	call   800161 <sys_cputs>
  800056:	83 c4 10             	add    $0x10,%esp
}
  800059:	90                   	nop
  80005a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80005d:	c9                   	leave  
  80005e:	c3                   	ret    

0080005f <__x86.get_pc_thunk.ax>:
  80005f:	8b 04 24             	mov    (%esp),%eax
  800062:	c3                   	ret    

00800063 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800063:	f3 0f 1e fb          	endbr32 
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	53                   	push   %ebx
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	e8 5a 00 00 00       	call   8000cd <__x86.get_pc_thunk.bx>
  800073:	81 c3 8d 1f 00 00    	add    $0x1f8d,%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code h(ere.
	thisenv = envs + ENVX(sys_getenvid());
  800079:	e8 76 01 00 00       	call   8001f4 <sys_getenvid>
  80007e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800083:	89 c2                	mov    %eax,%edx
  800085:	89 d0                	mov    %edx,%eax
  800087:	01 c0                	add    %eax,%eax
  800089:	01 d0                	add    %edx,%eax
  80008b:	c1 e0 05             	shl    $0x5,%eax
  80008e:	89 c2                	mov    %eax,%edx
  800090:	c7 c0 00 00 c0 ee    	mov    $0xeec00000,%eax
  800096:	01 c2                	add    %eax,%edx
  800098:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  80009e:	89 10                	mov    %edx,(%eax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a4:	7e 0b                	jle    8000b1 <libmain+0x4e>
		binaryname = argv[0];
  8000a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a9:	8b 00                	mov    (%eax),%eax
  8000ab:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000b1:	83 ec 08             	sub    $0x8,%esp
  8000b4:	ff 75 0c             	pushl  0xc(%ebp)
  8000b7:	ff 75 08             	pushl  0x8(%ebp)
  8000ba:	e8 74 ff ff ff       	call   800033 <umain>
  8000bf:	83 c4 10             	add    $0x10,%esp

	// exit gracefully
	exit();
  8000c2:	e8 0a 00 00 00       	call   8000d1 <exit>
}
  8000c7:	90                   	nop
  8000c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000cb:	c9                   	leave  
  8000cc:	c3                   	ret    

008000cd <__x86.get_pc_thunk.bx>:
  8000cd:	8b 1c 24             	mov    (%esp),%ebx
  8000d0:	c3                   	ret    

008000d1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d1:	f3 0f 1e fb          	endbr32 
  8000d5:	55                   	push   %ebp
  8000d6:	89 e5                	mov    %esp,%ebp
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	e8 7e ff ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  8000e1:	05 1f 1f 00 00       	add    $0x1f1f,%eax
	sys_env_destroy(0);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	6a 00                	push   $0x0
  8000eb:	89 c3                	mov    %eax,%ebx
  8000ed:	e8 d1 00 00 00       	call   8001c3 <sys_env_destroy>
  8000f2:	83 c4 10             	add    $0x10,%esp
}
  8000f5:	90                   	nop
  8000f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f9:	c9                   	leave  
  8000fa:	c3                   	ret    

008000fb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	57                   	push   %edi
  8000ff:	56                   	push   %esi
  800100:	53                   	push   %ebx
  800101:	83 ec 2c             	sub    $0x2c,%esp
  800104:	e8 c4 ff ff ff       	call   8000cd <__x86.get_pc_thunk.bx>
  800109:	81 c3 f7 1e 00 00    	add    $0x1ef7,%ebx
  80010f:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800112:	8b 45 08             	mov    0x8(%ebp),%eax
  800115:	8b 55 10             	mov    0x10(%ebp),%edx
  800118:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80011b:	8b 5d 18             	mov    0x18(%ebp),%ebx
  80011e:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  800121:	8b 75 20             	mov    0x20(%ebp),%esi
  800124:	cd 30                	int    $0x30
  800126:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800129:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80012d:	74 27                	je     800156 <syscall+0x5b>
  80012f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800133:	7e 21                	jle    800156 <syscall+0x5b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	ff 75 e4             	pushl  -0x1c(%ebp)
  80013b:	ff 75 08             	pushl  0x8(%ebp)
  80013e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800141:	8d 83 da f2 ff ff    	lea    -0xd26(%ebx),%eax
  800147:	50                   	push   %eax
  800148:	6a 23                	push   $0x23
  80014a:	8d 83 f7 f2 ff ff    	lea    -0xd09(%ebx),%eax
  800150:	50                   	push   %eax
  800151:	e8 cd 00 00 00       	call   800223 <_panic>

	return ret;
  800156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  800159:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80015c:	5b                   	pop    %ebx
  80015d:	5e                   	pop    %esi
  80015e:	5f                   	pop    %edi
  80015f:	5d                   	pop    %ebp
  800160:	c3                   	ret    

00800161 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800161:	f3 0f 1e fb          	endbr32 
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	e8 ef fe ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800170:	05 90 1e 00 00       	add    $0x1e90,%eax
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800175:	8b 45 08             	mov    0x8(%ebp),%eax
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	6a 00                	push   $0x0
  80017d:	6a 00                	push   $0x0
  80017f:	6a 00                	push   $0x0
  800181:	ff 75 0c             	pushl  0xc(%ebp)
  800184:	50                   	push   %eax
  800185:	6a 00                	push   $0x0
  800187:	6a 00                	push   $0x0
  800189:	e8 6d ff ff ff       	call   8000fb <syscall>
  80018e:	83 c4 20             	add    $0x20,%esp
}
  800191:	90                   	nop
  800192:	c9                   	leave  
  800193:	c3                   	ret    

00800194 <sys_cgetc>:

int
sys_cgetc(void)
{
  800194:	f3 0f 1e fb          	endbr32 
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	e8 bc fe ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  8001a3:	05 5d 1e 00 00       	add    $0x1e5d,%eax
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	6a 00                	push   $0x0
  8001ad:	6a 00                	push   $0x0
  8001af:	6a 00                	push   $0x0
  8001b1:	6a 00                	push   $0x0
  8001b3:	6a 00                	push   $0x0
  8001b5:	6a 00                	push   $0x0
  8001b7:	6a 01                	push   $0x1
  8001b9:	e8 3d ff ff ff       	call   8000fb <syscall>
  8001be:	83 c4 20             	add    $0x20,%esp
}
  8001c1:	c9                   	leave  
  8001c2:	c3                   	ret    

008001c3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001c3:	f3 0f 1e fb          	endbr32 
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	83 ec 08             	sub    $0x8,%esp
  8001cd:	e8 8d fe ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  8001d2:	05 2e 1e 00 00       	add    $0x1e2e,%eax
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001da:	83 ec 04             	sub    $0x4,%esp
  8001dd:	6a 00                	push   $0x0
  8001df:	6a 00                	push   $0x0
  8001e1:	6a 00                	push   $0x0
  8001e3:	6a 00                	push   $0x0
  8001e5:	50                   	push   %eax
  8001e6:	6a 01                	push   $0x1
  8001e8:	6a 03                	push   $0x3
  8001ea:	e8 0c ff ff ff       	call   8000fb <syscall>
  8001ef:	83 c4 20             	add    $0x20,%esp
}
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8001f4:	f3 0f 1e fb          	endbr32 
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	83 ec 08             	sub    $0x8,%esp
  8001fe:	e8 5c fe ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800203:	05 fd 1d 00 00       	add    $0x1dfd,%eax
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	6a 00                	push   $0x0
  80020d:	6a 00                	push   $0x0
  80020f:	6a 00                	push   $0x0
  800211:	6a 00                	push   $0x0
  800213:	6a 00                	push   $0x0
  800215:	6a 00                	push   $0x0
  800217:	6a 02                	push   $0x2
  800219:	e8 dd fe ff ff       	call   8000fb <syscall>
  80021e:	83 c4 20             	add    $0x20,%esp
}
  800221:	c9                   	leave  
  800222:	c3                   	ret    

00800223 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800223:	f3 0f 1e fb          	endbr32 
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	56                   	push   %esi
  80022b:	53                   	push   %ebx
  80022c:	83 ec 10             	sub    $0x10,%esp
  80022f:	e8 99 fe ff ff       	call   8000cd <__x86.get_pc_thunk.bx>
  800234:	81 c3 cc 1d 00 00    	add    $0x1dcc,%ebx
	va_list ap;

	va_start(ap, fmt);
  80023a:	8d 45 14             	lea    0x14(%ebp),%eax
  80023d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800240:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800246:	8b 30                	mov    (%eax),%esi
  800248:	e8 a7 ff ff ff       	call   8001f4 <sys_getenvid>
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	ff 75 0c             	pushl  0xc(%ebp)
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	56                   	push   %esi
  800257:	50                   	push   %eax
  800258:	8d 83 08 f3 ff ff    	lea    -0xcf8(%ebx),%eax
  80025e:	50                   	push   %eax
  80025f:	e8 0f 01 00 00       	call   800373 <cprintf>
  800264:	83 c4 20             	add    $0x20,%esp
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	ff 75 10             	pushl  0x10(%ebp)
  800271:	e8 8d 00 00 00       	call   800303 <vcprintf>
  800276:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800279:	83 ec 0c             	sub    $0xc,%esp
  80027c:	8d 83 2b f3 ff ff    	lea    -0xcd5(%ebx),%eax
  800282:	50                   	push   %eax
  800283:	e8 eb 00 00 00       	call   800373 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80028b:	cc                   	int3   
  80028c:	eb fd                	jmp    80028b <_panic+0x68>

0080028e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80028e:	f3 0f 1e fb          	endbr32 
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	53                   	push   %ebx
  800296:	83 ec 04             	sub    $0x4,%esp
  800299:	e8 09 01 00 00       	call   8003a7 <__x86.get_pc_thunk.dx>
  80029e:	81 c2 62 1d 00 00    	add    $0x1d62,%edx
	b->buf[b->idx++] = ch;
  8002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a7:	8b 00                	mov    (%eax),%eax
  8002a9:	8d 58 01             	lea    0x1(%eax),%ebx
  8002ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002af:	89 19                	mov    %ebx,(%ecx)
  8002b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b4:	89 cb                	mov    %ecx,%ebx
  8002b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b9:	88 5c 01 08          	mov    %bl,0x8(%ecx,%eax,1)
	if (b->idx == 256-1) {
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c0:	8b 00                	mov    (%eax),%eax
  8002c2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c7:	75 25                	jne    8002ee <putch+0x60>
		sys_cputs(b->buf, b->idx);
  8002c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d3:	83 c0 08             	add    $0x8,%eax
  8002d6:	83 ec 08             	sub    $0x8,%esp
  8002d9:	51                   	push   %ecx
  8002da:	50                   	push   %eax
  8002db:	89 d3                	mov    %edx,%ebx
  8002dd:	e8 7f fe ff ff       	call   800161 <sys_cputs>
  8002e2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f1:	8b 40 04             	mov    0x4(%eax),%eax
  8002f4:	8d 50 01             	lea    0x1(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002fd:	90                   	nop
  8002fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800303:	f3 0f 1e fb          	endbr32 
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	53                   	push   %ebx
  80030b:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800311:	e8 b7 fd ff ff       	call   8000cd <__x86.get_pc_thunk.bx>
  800316:	81 c3 ea 1c 00 00    	add    $0x1cea,%ebx
	struct printbuf b;

	b.idx = 0;
  80031c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800323:	00 00 00 
	b.cnt = 0;
  800326:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800330:	ff 75 0c             	pushl  0xc(%ebp)
  800333:	ff 75 08             	pushl  0x8(%ebp)
  800336:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033c:	50                   	push   %eax
  80033d:	8d 83 8e e2 ff ff    	lea    -0x1d72(%ebx),%eax
  800343:	50                   	push   %eax
  800344:	e8 e3 01 00 00       	call   80052c <vprintfmt>
  800349:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  80034c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	50                   	push   %eax
  800356:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80035c:	83 c0 08             	add    $0x8,%eax
  80035f:	50                   	push   %eax
  800360:	e8 fc fd ff ff       	call   800161 <sys_cputs>
  800365:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800368:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80036e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800373:	f3 0f 1e fb          	endbr32 
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	83 ec 18             	sub    $0x18,%esp
  80037d:	e8 dd fc ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800382:	05 7e 1c 00 00       	add    $0x1c7e,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800387:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
  80038d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	50                   	push   %eax
  800394:	ff 75 08             	pushl  0x8(%ebp)
  800397:	e8 67 ff ff ff       	call   800303 <vcprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
  8003a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8003a5:	c9                   	leave  
  8003a6:	c3                   	ret    

008003a7 <__x86.get_pc_thunk.dx>:
  8003a7:	8b 14 24             	mov    (%esp),%edx
  8003aa:	c3                   	ret    

008003ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ab:	f3 0f 1e fb          	endbr32 
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	57                   	push   %edi
  8003b3:	56                   	push   %esi
  8003b4:	53                   	push   %ebx
  8003b5:	83 ec 1c             	sub    $0x1c,%esp
  8003b8:	e8 43 06 00 00       	call   800a00 <__x86.get_pc_thunk.si>
  8003bd:	81 c6 43 1c 00 00    	add    $0x1c43,%esi
  8003c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003cf:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003da:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8003dd:	19 d1                	sbb    %edx,%ecx
  8003df:	72 4d                	jb     80042e <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003e4:	8d 78 ff             	lea    -0x1(%eax),%edi
  8003e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ef:	52                   	push   %edx
  8003f0:	50                   	push   %eax
  8003f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f7:	89 f3                	mov    %esi,%ebx
  8003f9:	e8 72 0c 00 00       	call   801070 <__udivdi3>
  8003fe:	83 c4 10             	add    $0x10,%esp
  800401:	83 ec 04             	sub    $0x4,%esp
  800404:	ff 75 20             	pushl  0x20(%ebp)
  800407:	57                   	push   %edi
  800408:	ff 75 18             	pushl  0x18(%ebp)
  80040b:	52                   	push   %edx
  80040c:	50                   	push   %eax
  80040d:	ff 75 0c             	pushl  0xc(%ebp)
  800410:	ff 75 08             	pushl  0x8(%ebp)
  800413:	e8 93 ff ff ff       	call   8003ab <printnum>
  800418:	83 c4 20             	add    $0x20,%esp
  80041b:	eb 1b                	jmp    800438 <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	ff 75 0c             	pushl  0xc(%ebp)
  800423:	ff 75 20             	pushl  0x20(%ebp)
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	ff d0                	call   *%eax
  80042b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80042e:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  800432:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800436:	7f e5                	jg     80041d <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800438:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80043b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800440:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800443:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800446:	53                   	push   %ebx
  800447:	51                   	push   %ecx
  800448:	52                   	push   %edx
  800449:	50                   	push   %eax
  80044a:	89 f3                	mov    %esi,%ebx
  80044c:	e8 2f 0d 00 00       	call   801180 <__umoddi3>
  800451:	83 c4 10             	add    $0x10,%esp
  800454:	8d 8e 99 f3 ff ff    	lea    -0xc67(%esi),%ecx
  80045a:	01 c8                	add    %ecx,%eax
  80045c:	0f b6 00             	movzbl (%eax),%eax
  80045f:	0f be c0             	movsbl %al,%eax
  800462:	83 ec 08             	sub    $0x8,%esp
  800465:	ff 75 0c             	pushl  0xc(%ebp)
  800468:	50                   	push   %eax
  800469:	8b 45 08             	mov    0x8(%ebp),%eax
  80046c:	ff d0                	call   *%eax
  80046e:	83 c4 10             	add    $0x10,%esp
}
  800471:	90                   	nop
  800472:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800475:	5b                   	pop    %ebx
  800476:	5e                   	pop    %esi
  800477:	5f                   	pop    %edi
  800478:	5d                   	pop    %ebp
  800479:	c3                   	ret    

0080047a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80047a:	f3 0f 1e fb          	endbr32 
  80047e:	55                   	push   %ebp
  80047f:	89 e5                	mov    %esp,%ebp
  800481:	e8 d9 fb ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800486:	05 7a 1b 00 00       	add    $0x1b7a,%eax
	if (lflag >= 2)
  80048b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80048f:	7e 14                	jle    8004a5 <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	8d 48 08             	lea    0x8(%eax),%ecx
  800499:	8b 55 08             	mov    0x8(%ebp),%edx
  80049c:	89 0a                	mov    %ecx,(%edx)
  80049e:	8b 50 04             	mov    0x4(%eax),%edx
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	eb 30                	jmp    8004d5 <getuint+0x5b>
	else if (lflag)
  8004a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a9:	74 16                	je     8004c1 <getuint+0x47>
		return va_arg(*ap, unsigned long);
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	8d 48 04             	lea    0x4(%eax),%ecx
  8004b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b6:	89 0a                	mov    %ecx,(%edx)
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8004bf:	eb 14                	jmp    8004d5 <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	8d 48 04             	lea    0x4(%eax),%ecx
  8004c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004cc:	89 0a                	mov    %ecx,(%edx)
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004d5:	5d                   	pop    %ebp
  8004d6:	c3                   	ret    

008004d7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004d7:	f3 0f 1e fb          	endbr32 
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	e8 7c fb ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  8004e3:	05 1d 1b 00 00       	add    $0x1b1d,%eax
	if (lflag >= 2)
  8004e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ec:	7e 14                	jle    800502 <getint+0x2b>
		return va_arg(*ap, long long);
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	8d 48 08             	lea    0x8(%eax),%ecx
  8004f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f9:	89 0a                	mov    %ecx,(%edx)
  8004fb:	8b 50 04             	mov    0x4(%eax),%edx
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	eb 28                	jmp    80052a <getint+0x53>
	else if (lflag)
  800502:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800506:	74 12                	je     80051a <getint+0x43>
		return va_arg(*ap, long);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 48 04             	lea    0x4(%eax),%ecx
  800510:	8b 55 08             	mov    0x8(%ebp),%edx
  800513:	89 0a                	mov    %ecx,(%edx)
  800515:	8b 00                	mov    (%eax),%eax
  800517:	99                   	cltd   
  800518:	eb 10                	jmp    80052a <getint+0x53>
	else
		return va_arg(*ap, int);
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	8d 48 04             	lea    0x4(%eax),%ecx
  800522:	8b 55 08             	mov    0x8(%ebp),%edx
  800525:	89 0a                	mov    %ecx,(%edx)
  800527:	8b 00                	mov    (%eax),%eax
  800529:	99                   	cltd   
}
  80052a:	5d                   	pop    %ebp
  80052b:	c3                   	ret    

0080052c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80052c:	f3 0f 1e fb          	endbr32 
  800530:	55                   	push   %ebp
  800531:	89 e5                	mov    %esp,%ebp
  800533:	57                   	push   %edi
  800534:	56                   	push   %esi
  800535:	53                   	push   %ebx
  800536:	83 ec 2c             	sub    $0x2c,%esp
  800539:	e8 c6 04 00 00       	call   800a04 <__x86.get_pc_thunk.di>
  80053e:	81 c7 c2 1a 00 00    	add    $0x1ac2,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800544:	eb 17                	jmp    80055d <vprintfmt+0x31>
			if (ch == '\0')
  800546:	85 db                	test   %ebx,%ebx
  800548:	0f 84 96 03 00 00    	je     8008e4 <.L20+0x2d>
				return;
			putch(ch, putdat);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	ff 75 0c             	pushl  0xc(%ebp)
  800554:	53                   	push   %ebx
  800555:	8b 45 08             	mov    0x8(%ebp),%eax
  800558:	ff d0                	call   *%eax
  80055a:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055d:	8b 45 10             	mov    0x10(%ebp),%eax
  800560:	8d 50 01             	lea    0x1(%eax),%edx
  800563:	89 55 10             	mov    %edx,0x10(%ebp)
  800566:	0f b6 00             	movzbl (%eax),%eax
  800569:	0f b6 d8             	movzbl %al,%ebx
  80056c:	83 fb 25             	cmp    $0x25,%ebx
  80056f:	75 d5                	jne    800546 <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
  800571:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
  800575:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
  80057c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
  800583:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
  80058a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800591:	8b 45 10             	mov    0x10(%ebp),%eax
  800594:	8d 50 01             	lea    0x1(%eax),%edx
  800597:	89 55 10             	mov    %edx,0x10(%ebp)
  80059a:	0f b6 00             	movzbl (%eax),%eax
  80059d:	0f b6 d8             	movzbl %al,%ebx
  8005a0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005a3:	83 f8 55             	cmp    $0x55,%eax
  8005a6:	0f 87 0b 03 00 00    	ja     8008b7 <.L20>
  8005ac:	c1 e0 02             	shl    $0x2,%eax
  8005af:	8b 84 38 c0 f3 ff ff 	mov    -0xc40(%eax,%edi,1),%eax
  8005b6:	01 f8                	add    %edi,%eax
  8005b8:	3e ff e0             	notrack jmp *%eax

008005bb <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
  8005bb:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
  8005bf:	eb d0                	jmp    800591 <vprintfmt+0x65>

008005c1 <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005c1:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
  8005c5:	eb ca                	jmp    800591 <vprintfmt+0x65>

008005c7 <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005c7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
  8005ce:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005d1:	89 d0                	mov    %edx,%eax
  8005d3:	c1 e0 02             	shl    $0x2,%eax
  8005d6:	01 d0                	add    %edx,%eax
  8005d8:	01 c0                	add    %eax,%eax
  8005da:	01 d8                	add    %ebx,%eax
  8005dc:	83 e8 30             	sub    $0x30,%eax
  8005df:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
  8005e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e5:	0f b6 00             	movzbl (%eax),%eax
  8005e8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005eb:	83 fb 2f             	cmp    $0x2f,%ebx
  8005ee:	7e 39                	jle    800629 <.L37+0xc>
  8005f0:	83 fb 39             	cmp    $0x39,%ebx
  8005f3:	7f 34                	jg     800629 <.L37+0xc>
			for (precision = 0; ; ++fmt) {
  8005f5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
  8005f9:	eb d3                	jmp    8005ce <.L31+0x7>

008005fb <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8d 50 04             	lea    0x4(%eax),%edx
  800601:	89 55 14             	mov    %edx,0x14(%ebp)
  800604:	8b 00                	mov    (%eax),%eax
  800606:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
  800609:	eb 1f                	jmp    80062a <.L37+0xd>

0080060b <.L33>:

		case '.':
			if (width < 0)
  80060b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80060f:	79 80                	jns    800591 <vprintfmt+0x65>
				width = 0;
  800611:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
  800618:	e9 74 ff ff ff       	jmp    800591 <vprintfmt+0x65>

0080061d <.L37>:

		case '#':
			altflag = 1;
  80061d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
  800624:	e9 68 ff ff ff       	jmp    800591 <vprintfmt+0x65>
			goto process_precision;
  800629:	90                   	nop

		process_precision:
			if (width < 0)
  80062a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80062e:	0f 89 5d ff ff ff    	jns    800591 <vprintfmt+0x65>
				width = precision, precision = -1;
  800634:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800637:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80063a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
  800641:	e9 4b ff ff ff       	jmp    800591 <vprintfmt+0x65>

00800646 <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800646:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
  80064a:	e9 42 ff ff ff       	jmp    800591 <vprintfmt+0x65>

0080064f <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 50 04             	lea    0x4(%eax),%edx
  800655:	89 55 14             	mov    %edx,0x14(%ebp)
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 0c             	pushl  0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	ff d0                	call   *%eax
  800666:	83 c4 10             	add    $0x10,%esp
			break;
  800669:	e9 71 02 00 00       	jmp    8008df <.L20+0x28>

0080066e <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	89 55 14             	mov    %edx,0x14(%ebp)
  800677:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800679:	85 db                	test   %ebx,%ebx
  80067b:	79 02                	jns    80067f <.L28+0x11>
				err = -err;
  80067d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80067f:	83 fb 06             	cmp    $0x6,%ebx
  800682:	7f 0b                	jg     80068f <.L28+0x21>
  800684:	8b b4 9f 10 00 00 00 	mov    0x10(%edi,%ebx,4),%esi
  80068b:	85 f6                	test   %esi,%esi
  80068d:	75 1b                	jne    8006aa <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
  80068f:	53                   	push   %ebx
  800690:	8d 87 aa f3 ff ff    	lea    -0xc56(%edi),%eax
  800696:	50                   	push   %eax
  800697:	ff 75 0c             	pushl  0xc(%ebp)
  80069a:	ff 75 08             	pushl  0x8(%ebp)
  80069d:	e8 4b 02 00 00       	call   8008ed <printfmt>
  8006a2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006a5:	e9 35 02 00 00       	jmp    8008df <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
  8006aa:	56                   	push   %esi
  8006ab:	8d 87 b3 f3 ff ff    	lea    -0xc4d(%edi),%eax
  8006b1:	50                   	push   %eax
  8006b2:	ff 75 0c             	pushl  0xc(%ebp)
  8006b5:	ff 75 08             	pushl  0x8(%ebp)
  8006b8:	e8 30 02 00 00       	call   8008ed <printfmt>
  8006bd:	83 c4 10             	add    $0x10,%esp
			break;
  8006c0:	e9 1a 02 00 00       	jmp    8008df <.L20+0x28>

008006c5 <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8d 50 04             	lea    0x4(%eax),%edx
  8006cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ce:	8b 30                	mov    (%eax),%esi
  8006d0:	85 f6                	test   %esi,%esi
  8006d2:	75 06                	jne    8006da <.L24+0x15>
				p = "(null)";
  8006d4:	8d b7 b6 f3 ff ff    	lea    -0xc4a(%edi),%esi
			if (width > 0 && padc != '-')
  8006da:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006de:	7e 71                	jle    800751 <.L24+0x8c>
  8006e0:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  8006e4:	74 6b                	je     800751 <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	50                   	push   %eax
  8006ed:	56                   	push   %esi
  8006ee:	89 fb                	mov    %edi,%ebx
  8006f0:	e8 47 03 00 00       	call   800a3c <strnlen>
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	29 45 d4             	sub    %eax,-0x2c(%ebp)
  8006fb:	eb 17                	jmp    800714 <.L24+0x4f>
					putch(padc, putdat);
  8006fd:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	50                   	push   %eax
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	ff d0                	call   *%eax
  80070d:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
  800710:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800714:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800718:	7f e3                	jg     8006fd <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80071a:	eb 35                	jmp    800751 <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
  80071c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800720:	74 1c                	je     80073e <.L24+0x79>
  800722:	83 fb 1f             	cmp    $0x1f,%ebx
  800725:	7e 05                	jle    80072c <.L24+0x67>
  800727:	83 fb 7e             	cmp    $0x7e,%ebx
  80072a:	7e 12                	jle    80073e <.L24+0x79>
					putch('?', putdat);
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	ff 75 0c             	pushl  0xc(%ebp)
  800732:	6a 3f                	push   $0x3f
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	ff d0                	call   *%eax
  800739:	83 c4 10             	add    $0x10,%esp
  80073c:	eb 0f                	jmp    80074d <.L24+0x88>
				else
					putch(ch, putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	53                   	push   %ebx
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	ff d0                	call   *%eax
  80074a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80074d:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800751:	89 f0                	mov    %esi,%eax
  800753:	8d 70 01             	lea    0x1(%eax),%esi
  800756:	0f b6 00             	movzbl (%eax),%eax
  800759:	0f be d8             	movsbl %al,%ebx
  80075c:	85 db                	test   %ebx,%ebx
  80075e:	74 26                	je     800786 <.L24+0xc1>
  800760:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800764:	78 b6                	js     80071c <.L24+0x57>
  800766:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  80076a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80076e:	79 ac                	jns    80071c <.L24+0x57>
			for (; width > 0; width--)
  800770:	eb 14                	jmp    800786 <.L24+0xc1>
				putch(' ', putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 0c             	pushl  0xc(%ebp)
  800778:	6a 20                	push   $0x20
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
  800782:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800786:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80078a:	7f e6                	jg     800772 <.L24+0xad>
			break;
  80078c:	e9 4e 01 00 00       	jmp    8008df <.L20+0x28>

00800791 <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	ff 75 d8             	pushl  -0x28(%ebp)
  800797:	8d 45 14             	lea    0x14(%ebp),%eax
  80079a:	50                   	push   %eax
  80079b:	e8 37 fd ff ff       	call   8004d7 <getint>
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
  8007a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007af:	85 d2                	test   %edx,%edx
  8007b1:	79 23                	jns    8007d6 <.L29+0x45>
				putch('-', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	6a 2d                	push   $0x2d
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	ff d0                	call   *%eax
  8007c0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007c9:	f7 d8                	neg    %eax
  8007cb:	83 d2 00             	adc    $0x0,%edx
  8007ce:	f7 da                	neg    %edx
  8007d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007d3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
  8007d6:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007dd:	e9 9f 00 00 00       	jmp    800881 <.L21+0x1f>

008007e2 <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007eb:	50                   	push   %eax
  8007ec:	e8 89 fc ff ff       	call   80047a <getuint>
  8007f1:	83 c4 10             	add    $0x10,%esp
  8007f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
  8007fa:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  800801:	eb 7e                	jmp    800881 <.L21+0x1f>

00800803 <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 d8             	pushl  -0x28(%ebp)
  800809:	8d 45 14             	lea    0x14(%ebp),%eax
  80080c:	50                   	push   %eax
  80080d:	e8 68 fc ff ff       	call   80047a <getuint>
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800818:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
  80081b:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
  800822:	eb 5d                	jmp    800881 <.L21+0x1f>

00800824 <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	6a 30                	push   $0x30
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	ff d0                	call   *%eax
  800831:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	ff 75 0c             	pushl  0xc(%ebp)
  80083a:	6a 78                	push   $0x78
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	ff d0                	call   *%eax
  800841:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8d 50 04             	lea    0x4(%eax),%edx
  80084a:	89 55 14             	mov    %edx,0x14(%ebp)
  80084d:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800852:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
  800859:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
  800860:	eb 1f                	jmp    800881 <.L21+0x1f>

00800862 <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 d8             	pushl  -0x28(%ebp)
  800868:	8d 45 14             	lea    0x14(%ebp),%eax
  80086b:	50                   	push   %eax
  80086c:	e8 09 fc ff ff       	call   80047a <getuint>
  800871:	83 c4 10             	add    $0x10,%esp
  800874:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800877:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
  80087a:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800881:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  800885:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800888:	83 ec 04             	sub    $0x4,%esp
  80088b:	52                   	push   %edx
  80088c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80088f:	50                   	push   %eax
  800890:	ff 75 e4             	pushl  -0x1c(%ebp)
  800893:	ff 75 e0             	pushl  -0x20(%ebp)
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	ff 75 08             	pushl  0x8(%ebp)
  80089c:	e8 0a fb ff ff       	call   8003ab <printnum>
  8008a1:	83 c4 20             	add    $0x20,%esp
			break;
  8008a4:	eb 39                	jmp    8008df <.L20+0x28>

008008a6 <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	53                   	push   %ebx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	ff d0                	call   *%eax
  8008b2:	83 c4 10             	add    $0x10,%esp
			break;
  8008b5:	eb 28                	jmp    8008df <.L20+0x28>

008008b7 <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	ff 75 0c             	pushl  0xc(%ebp)
  8008bd:	6a 25                	push   $0x25
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	ff d0                	call   *%eax
  8008c4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008cb:	eb 04                	jmp    8008d1 <.L20+0x1a>
  8008cd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d4:	83 e8 01             	sub    $0x1,%eax
  8008d7:	0f b6 00             	movzbl (%eax),%eax
  8008da:	3c 25                	cmp    $0x25,%al
  8008dc:	75 ef                	jne    8008cd <.L20+0x16>
				/* do nothing */;
			break;
  8008de:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008df:	e9 79 fc ff ff       	jmp    80055d <vprintfmt+0x31>
				return;
  8008e4:	90                   	nop
		}
	}
}
  8008e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e8:	5b                   	pop    %ebx
  8008e9:	5e                   	pop    %esi
  8008ea:	5f                   	pop    %edi
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    

008008ed <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008ed:	f3 0f 1e fb          	endbr32 
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 18             	sub    $0x18,%esp
  8008f7:	e8 63 f7 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  8008fc:	05 04 17 00 00       	add    $0x1704,%eax
	va_list ap;

	va_start(ap, fmt);
  800901:	8d 45 14             	lea    0x14(%ebp),%eax
  800904:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80090a:	50                   	push   %eax
  80090b:	ff 75 10             	pushl  0x10(%ebp)
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	ff 75 08             	pushl  0x8(%ebp)
  800914:	e8 13 fc ff ff       	call   80052c <vprintfmt>
  800919:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80091c:	90                   	nop
  80091d:	c9                   	leave  
  80091e:	c3                   	ret    

0080091f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80091f:	f3 0f 1e fb          	endbr32 
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	e8 34 f7 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  80092b:	05 d5 16 00 00       	add    $0x16d5,%eax
	b->cnt++;
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
  800933:	8b 40 08             	mov    0x8(%eax),%eax
  800936:	8d 50 01             	lea    0x1(%eax),%edx
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	8b 10                	mov    (%eax),%edx
  800944:	8b 45 0c             	mov    0xc(%ebp),%eax
  800947:	8b 40 04             	mov    0x4(%eax),%eax
  80094a:	39 c2                	cmp    %eax,%edx
  80094c:	73 12                	jae    800960 <sprintputch+0x41>
		*b->buf++ = ch;
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	8d 48 01             	lea    0x1(%eax),%ecx
  800956:	8b 55 0c             	mov    0xc(%ebp),%edx
  800959:	89 0a                	mov    %ecx,(%edx)
  80095b:	8b 55 08             	mov    0x8(%ebp),%edx
  80095e:	88 10                	mov    %dl,(%eax)
}
  800960:	90                   	nop
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800963:	f3 0f 1e fb          	endbr32 
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
  80096d:	e8 ed f6 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800972:	05 8e 16 00 00       	add    $0x168e,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
  800977:	8b 55 08             	mov    0x8(%ebp),%edx
  80097a:	89 55 ec             	mov    %edx,-0x14(%ebp)
  80097d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800980:	8d 4a ff             	lea    -0x1(%edx),%ecx
  800983:	8b 55 08             	mov    0x8(%ebp),%edx
  800986:	01 ca                	add    %ecx,%edx
  800988:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80098b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800992:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800996:	74 06                	je     80099e <vsnprintf+0x3b>
  800998:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80099c:	7f 07                	jg     8009a5 <vsnprintf+0x42>
		return -E_INVAL;
  80099e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009a3:	eb 22                	jmp    8009c7 <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a5:	ff 75 14             	pushl  0x14(%ebp)
  8009a8:	ff 75 10             	pushl  0x10(%ebp)
  8009ab:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8009ae:	52                   	push   %edx
  8009af:	8d 80 1f e9 ff ff    	lea    -0x16e1(%eax),%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 71 fb ff ff       	call   80052c <vprintfmt>
  8009bb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c9:	f3 0f 1e fb          	endbr32 
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	83 ec 18             	sub    $0x18,%esp
  8009d3:	e8 87 f6 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  8009d8:	05 28 16 00 00       	add    $0x1628,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 10             	pushl  0x10(%ebp)
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 6e ff ff ff       	call   800963 <vsnprintf>
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
  8009fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <__x86.get_pc_thunk.si>:
  800a00:	8b 34 24             	mov    (%esp),%esi
  800a03:	c3                   	ret    

00800a04 <__x86.get_pc_thunk.di>:
  800a04:	8b 3c 24             	mov    (%esp),%edi
  800a07:	c3                   	ret    

00800a08 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a08:	f3 0f 1e fb          	endbr32 
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 10             	sub    $0x10,%esp
  800a12:	e8 48 f6 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800a17:	05 e9 15 00 00       	add    $0x15e9,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800a1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a23:	eb 08                	jmp    800a2d <strlen+0x25>
		n++;
  800a25:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
  800a29:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	0f b6 00             	movzbl (%eax),%eax
  800a33:	84 c0                	test   %al,%al
  800a35:	75 ee                	jne    800a25 <strlen+0x1d>
	return n;
  800a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a3c:	f3 0f 1e fb          	endbr32 
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	83 ec 10             	sub    $0x10,%esp
  800a46:	e8 14 f6 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800a4b:	05 b5 15 00 00       	add    $0x15b5,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a57:	eb 0c                	jmp    800a65 <strnlen+0x29>
		n++;
  800a59:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a5d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a61:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800a65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a69:	74 0a                	je     800a75 <strnlen+0x39>
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	0f b6 00             	movzbl (%eax),%eax
  800a71:	84 c0                	test   %al,%al
  800a73:	75 e4                	jne    800a59 <strnlen+0x1d>
	return n;
  800a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a7a:	f3 0f 1e fb          	endbr32 
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	83 ec 10             	sub    $0x10,%esp
  800a84:	e8 d6 f5 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800a89:	05 77 15 00 00       	add    $0x1577,%eax
	char *ret;

	ret = dst;
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a94:	90                   	nop
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a98:	8d 42 01             	lea    0x1(%edx),%eax
  800a9b:	89 45 0c             	mov    %eax,0xc(%ebp)
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8d 48 01             	lea    0x1(%eax),%ecx
  800aa4:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800aa7:	0f b6 12             	movzbl (%edx),%edx
  800aaa:	88 10                	mov    %dl,(%eax)
  800aac:	0f b6 00             	movzbl (%eax),%eax
  800aaf:	84 c0                	test   %al,%al
  800ab1:	75 e2                	jne    800a95 <strcpy+0x1b>
		/* do nothing */;
	return ret;
  800ab3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ab6:	c9                   	leave  
  800ab7:	c3                   	ret    

00800ab8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ab8:	f3 0f 1e fb          	endbr32 
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 10             	sub    $0x10,%esp
  800ac2:	e8 98 f5 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800ac7:	05 39 15 00 00       	add    $0x1539,%eax
	int len = strlen(dst);
  800acc:	ff 75 08             	pushl  0x8(%ebp)
  800acf:	e8 34 ff ff ff       	call   800a08 <strlen>
  800ad4:	83 c4 04             	add    $0x4,%esp
  800ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
  800ada:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	01 d0                	add    %edx,%eax
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	50                   	push   %eax
  800ae6:	e8 8f ff ff ff       	call   800a7a <strcpy>
  800aeb:	83 c4 08             	add    $0x8,%esp
	return dst;
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800af1:	c9                   	leave  
  800af2:	c3                   	ret    

00800af3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800af3:	f3 0f 1e fb          	endbr32 
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	83 ec 10             	sub    $0x10,%esp
  800afd:	e8 5d f5 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800b02:	05 fe 14 00 00       	add    $0x14fe,%eax
	size_t i;
	char *ret;

	ret = dst;
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b14:	eb 23                	jmp    800b39 <strncpy+0x46>
		*dst++ = *src;
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8d 50 01             	lea    0x1(%eax),%edx
  800b1c:	89 55 08             	mov    %edx,0x8(%ebp)
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	0f b6 12             	movzbl (%edx),%edx
  800b25:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2a:	0f b6 00             	movzbl (%eax),%eax
  800b2d:	84 c0                	test   %al,%al
  800b2f:	74 04                	je     800b35 <strncpy+0x42>
			src++;
  800b31:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
  800b35:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b3c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b3f:	72 d5                	jb     800b16 <strncpy+0x23>
	}
	return ret;
  800b41:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b44:	c9                   	leave  
  800b45:	c3                   	ret    

00800b46 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b46:	f3 0f 1e fb          	endbr32 
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	83 ec 10             	sub    $0x10,%esp
  800b50:	e8 0a f5 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800b55:	05 ab 14 00 00       	add    $0x14ab,%eax
	char *dst_in;

	dst_in = dst;
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b64:	74 33                	je     800b99 <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
  800b66:	eb 17                	jmp    800b7f <strlcpy+0x39>
			*dst++ = *src++;
  800b68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6b:	8d 42 01             	lea    0x1(%edx),%eax
  800b6e:	89 45 0c             	mov    %eax,0xc(%ebp)
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8d 48 01             	lea    0x1(%eax),%ecx
  800b77:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800b7a:	0f b6 12             	movzbl (%edx),%edx
  800b7d:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
  800b7f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b87:	74 0a                	je     800b93 <strlcpy+0x4d>
  800b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8c:	0f b6 00             	movzbl (%eax),%eax
  800b8f:	84 c0                	test   %al,%al
  800b91:	75 d5                	jne    800b68 <strlcpy+0x22>
		*dst = '\0';
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
  800b9f:	c9                   	leave  
  800ba0:	c3                   	ret    

00800ba1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ba1:	f3 0f 1e fb          	endbr32 
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	e8 b2 f4 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800bad:	05 53 14 00 00       	add    $0x1453,%eax
	while (*p && *p == *q)
  800bb2:	eb 08                	jmp    800bbc <strcmp+0x1b>
		p++, q++;
  800bb4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bb8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	0f b6 00             	movzbl (%eax),%eax
  800bc2:	84 c0                	test   %al,%al
  800bc4:	74 10                	je     800bd6 <strcmp+0x35>
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	0f b6 10             	movzbl (%eax),%edx
  800bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcf:	0f b6 00             	movzbl (%eax),%eax
  800bd2:	38 c2                	cmp    %al,%dl
  800bd4:	74 de                	je     800bb4 <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	0f b6 00             	movzbl (%eax),%eax
  800bdc:	0f b6 d0             	movzbl %al,%edx
  800bdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be2:	0f b6 00             	movzbl (%eax),%eax
  800be5:	0f b6 c0             	movzbl %al,%eax
  800be8:	29 c2                	sub    %eax,%edx
  800bea:	89 d0                	mov    %edx,%eax
}
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bee:	f3 0f 1e fb          	endbr32 
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	e8 65 f4 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800bfa:	05 06 14 00 00       	add    $0x1406,%eax
	while (n > 0 && *p && *p == *q)
  800bff:	eb 0c                	jmp    800c0d <strncmp+0x1f>
		n--, p++, q++;
  800c01:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800c05:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c09:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
  800c0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c11:	74 1a                	je     800c2d <strncmp+0x3f>
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	0f b6 00             	movzbl (%eax),%eax
  800c19:	84 c0                	test   %al,%al
  800c1b:	74 10                	je     800c2d <strncmp+0x3f>
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	0f b6 10             	movzbl (%eax),%edx
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	0f b6 00             	movzbl (%eax),%eax
  800c29:	38 c2                	cmp    %al,%dl
  800c2b:	74 d4                	je     800c01 <strncmp+0x13>
	if (n == 0)
  800c2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c31:	75 07                	jne    800c3a <strncmp+0x4c>
		return 0;
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
  800c38:	eb 16                	jmp    800c50 <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	0f b6 00             	movzbl (%eax),%eax
  800c40:	0f b6 d0             	movzbl %al,%edx
  800c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c46:	0f b6 00             	movzbl (%eax),%eax
  800c49:	0f b6 c0             	movzbl %al,%eax
  800c4c:	29 c2                	sub    %eax,%edx
  800c4e:	89 d0                	mov    %edx,%eax
}
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c52:	f3 0f 1e fb          	endbr32 
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 04             	sub    $0x4,%esp
  800c5c:	e8 fe f3 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800c61:	05 9f 13 00 00       	add    $0x139f,%eax
  800c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c6c:	eb 14                	jmp    800c82 <strchr+0x30>
		if (*s == c)
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	0f b6 00             	movzbl (%eax),%eax
  800c74:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800c77:	75 05                	jne    800c7e <strchr+0x2c>
			return (char *) s;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	eb 13                	jmp    800c91 <strchr+0x3f>
	for (; *s; s++)
  800c7e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	0f b6 00             	movzbl (%eax),%eax
  800c88:	84 c0                	test   %al,%al
  800c8a:	75 e2                	jne    800c6e <strchr+0x1c>
	return 0;
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c91:	c9                   	leave  
  800c92:	c3                   	ret    

00800c93 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c93:	f3 0f 1e fb          	endbr32 
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 04             	sub    $0x4,%esp
  800c9d:	e8 bd f3 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800ca2:	05 5e 13 00 00       	add    $0x135e,%eax
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cad:	eb 0f                	jmp    800cbe <strfind+0x2b>
		if (*s == c)
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	0f b6 00             	movzbl (%eax),%eax
  800cb5:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800cb8:	74 10                	je     800cca <strfind+0x37>
	for (; *s; s++)
  800cba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	0f b6 00             	movzbl (%eax),%eax
  800cc4:	84 c0                	test   %al,%al
  800cc6:	75 e7                	jne    800caf <strfind+0x1c>
  800cc8:	eb 01                	jmp    800ccb <strfind+0x38>
			break;
  800cca:	90                   	nop
	return (char *) s;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    

00800cd0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd0:	f3 0f 1e fb          	endbr32 
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	e8 82 f3 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800cdd:	05 23 13 00 00       	add    $0x1323,%eax
	char *p;

	if (n == 0)
  800ce2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce6:	75 05                	jne    800ced <memset+0x1d>
		return v;
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	eb 5c                	jmp    800d49 <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	83 e0 03             	and    $0x3,%eax
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	75 41                	jne    800d38 <memset+0x68>
  800cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfa:	83 e0 03             	and    $0x3,%eax
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	75 37                	jne    800d38 <memset+0x68>
		c &= 0xFF;
  800d01:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0b:	c1 e0 18             	shl    $0x18,%eax
  800d0e:	89 c2                	mov    %eax,%edx
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	c1 e0 10             	shl    $0x10,%eax
  800d16:	09 c2                	or     %eax,%edx
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	c1 e0 08             	shl    $0x8,%eax
  800d1e:	09 d0                	or     %edx,%eax
  800d20:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d23:	8b 45 10             	mov    0x10(%ebp),%eax
  800d26:	c1 e8 02             	shr    $0x2,%eax
  800d29:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	89 d7                	mov    %edx,%edi
  800d33:	fc                   	cld    
  800d34:	f3 ab                	rep stos %eax,%es:(%edi)
  800d36:	eb 0e                	jmp    800d46 <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d41:	89 d7                	mov    %edx,%edi
  800d43:	fc                   	cld    
  800d44:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d4c:	f3 0f 1e fb          	endbr32 
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
  800d56:	83 ec 10             	sub    $0x10,%esp
  800d59:	e8 01 f3 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800d5e:	05 a2 12 00 00       	add    $0x12a2,%eax
	const char *s;
	char *d;

	s = src;
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
  800d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d72:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d75:	73 6d                	jae    800de4 <memmove+0x98>
  800d77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7d:	01 d0                	add    %edx,%eax
  800d7f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  800d82:	73 60                	jae    800de4 <memmove+0x98>
		s += n;
  800d84:	8b 45 10             	mov    0x10(%ebp),%eax
  800d87:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
  800d8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8d:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d93:	83 e0 03             	and    $0x3,%eax
  800d96:	85 c0                	test   %eax,%eax
  800d98:	75 2f                	jne    800dc9 <memmove+0x7d>
  800d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9d:	83 e0 03             	and    $0x3,%eax
  800da0:	85 c0                	test   %eax,%eax
  800da2:	75 25                	jne    800dc9 <memmove+0x7d>
  800da4:	8b 45 10             	mov    0x10(%ebp),%eax
  800da7:	83 e0 03             	and    $0x3,%eax
  800daa:	85 c0                	test   %eax,%eax
  800dac:	75 1b                	jne    800dc9 <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db1:	83 e8 04             	sub    $0x4,%eax
  800db4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800db7:	83 ea 04             	sub    $0x4,%edx
  800dba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800dbd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800dc0:	89 c7                	mov    %eax,%edi
  800dc2:	89 d6                	mov    %edx,%esi
  800dc4:	fd                   	std    
  800dc5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dc7:	eb 18                	jmp    800de1 <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd2:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	89 d7                	mov    %edx,%edi
  800dda:	89 de                	mov    %ebx,%esi
  800ddc:	89 c1                	mov    %eax,%ecx
  800dde:	fd                   	std    
  800ddf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800de1:	fc                   	cld    
  800de2:	eb 45                	jmp    800e29 <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de7:	83 e0 03             	and    $0x3,%eax
  800dea:	85 c0                	test   %eax,%eax
  800dec:	75 2b                	jne    800e19 <memmove+0xcd>
  800dee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df1:	83 e0 03             	and    $0x3,%eax
  800df4:	85 c0                	test   %eax,%eax
  800df6:	75 21                	jne    800e19 <memmove+0xcd>
  800df8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfb:	83 e0 03             	and    $0x3,%eax
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	75 17                	jne    800e19 <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e02:	8b 45 10             	mov    0x10(%ebp),%eax
  800e05:	c1 e8 02             	shr    $0x2,%eax
  800e08:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
  800e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e10:	89 c7                	mov    %eax,%edi
  800e12:	89 d6                	mov    %edx,%esi
  800e14:	fc                   	cld    
  800e15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e17:	eb 10                	jmp    800e29 <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
  800e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e22:	89 c7                	mov    %eax,%edi
  800e24:	89 d6                	mov    %edx,%esi
  800e26:	fc                   	cld    
  800e27:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    

00800e34 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e34:	f3 0f 1e fb          	endbr32 
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	e8 1f f2 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800e40:	05 c0 11 00 00       	add    $0x11c0,%eax
	return memmove(dst, src, n);
  800e45:	ff 75 10             	pushl  0x10(%ebp)
  800e48:	ff 75 0c             	pushl  0xc(%ebp)
  800e4b:	ff 75 08             	pushl  0x8(%ebp)
  800e4e:	e8 f9 fe ff ff       	call   800d4c <memmove>
  800e53:	83 c4 0c             	add    $0xc,%esp
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e58:	f3 0f 1e fb          	endbr32 
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	83 ec 10             	sub    $0x10,%esp
  800e62:	e8 f8 f1 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800e67:	05 99 11 00 00       	add    $0x1199,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e78:	eb 30                	jmp    800eaa <memcmp+0x52>
		if (*s1 != *s2)
  800e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7d:	0f b6 10             	movzbl (%eax),%edx
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e83:	0f b6 00             	movzbl (%eax),%eax
  800e86:	38 c2                	cmp    %al,%dl
  800e88:	74 18                	je     800ea2 <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
  800e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8d:	0f b6 00             	movzbl (%eax),%eax
  800e90:	0f b6 d0             	movzbl %al,%edx
  800e93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e96:	0f b6 00             	movzbl (%eax),%eax
  800e99:	0f b6 c0             	movzbl %al,%eax
  800e9c:	29 c2                	sub    %eax,%edx
  800e9e:	89 d0                	mov    %edx,%eax
  800ea0:	eb 1a                	jmp    800ebc <memcmp+0x64>
		s1++, s2++;
  800ea2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800ea6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
  800eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ead:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb0:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	75 c3                	jne    800e7a <memcmp+0x22>
	}

	return 0;
  800eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ebe:	f3 0f 1e fb          	endbr32 
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
  800ec8:	e8 92 f1 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800ecd:	05 33 11 00 00       	add    $0x1133,%eax
	const void *ends = (const char *) s + n;
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed8:	01 d0                	add    %edx,%eax
  800eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800edd:	eb 11                	jmp    800ef0 <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	0f b6 00             	movzbl (%eax),%eax
  800ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee8:	38 d0                	cmp    %dl,%al
  800eea:	74 0e                	je     800efa <memfind+0x3c>
	for (; s < ends; s++)
  800eec:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef6:	72 e7                	jb     800edf <memfind+0x21>
  800ef8:	eb 01                	jmp    800efb <memfind+0x3d>
			break;
  800efa:	90                   	nop
	return (void *) s;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efe:	c9                   	leave  
  800eff:	c3                   	ret    

00800f00 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f00:	f3 0f 1e fb          	endbr32 
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 10             	sub    $0x10,%esp
  800f0a:	e8 50 f1 ff ff       	call   80005f <__x86.get_pc_thunk.ax>
  800f0f:	05 f1 10 00 00       	add    $0x10f1,%eax
	int neg = 0;
  800f14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f22:	eb 04                	jmp    800f28 <strtol+0x28>
		s++;
  800f24:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	0f b6 00             	movzbl (%eax),%eax
  800f2e:	3c 20                	cmp    $0x20,%al
  800f30:	74 f2                	je     800f24 <strtol+0x24>
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	0f b6 00             	movzbl (%eax),%eax
  800f38:	3c 09                	cmp    $0x9,%al
  800f3a:	74 e8                	je     800f24 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	0f b6 00             	movzbl (%eax),%eax
  800f42:	3c 2b                	cmp    $0x2b,%al
  800f44:	75 06                	jne    800f4c <strtol+0x4c>
		s++;
  800f46:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f4a:	eb 15                	jmp    800f61 <strtol+0x61>
	else if (*s == '-')
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	0f b6 00             	movzbl (%eax),%eax
  800f52:	3c 2d                	cmp    $0x2d,%al
  800f54:	75 0b                	jne    800f61 <strtol+0x61>
		s++, neg = 1;
  800f56:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f5a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f65:	74 06                	je     800f6d <strtol+0x6d>
  800f67:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6b:	75 24                	jne    800f91 <strtol+0x91>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	0f b6 00             	movzbl (%eax),%eax
  800f73:	3c 30                	cmp    $0x30,%al
  800f75:	75 1a                	jne    800f91 <strtol+0x91>
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	83 c0 01             	add    $0x1,%eax
  800f7d:	0f b6 00             	movzbl (%eax),%eax
  800f80:	3c 78                	cmp    $0x78,%al
  800f82:	75 0d                	jne    800f91 <strtol+0x91>
		s += 2, base = 16;
  800f84:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f88:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8f:	eb 2a                	jmp    800fbb <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
  800f91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f95:	75 17                	jne    800fae <strtol+0xae>
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	0f b6 00             	movzbl (%eax),%eax
  800f9d:	3c 30                	cmp    $0x30,%al
  800f9f:	75 0d                	jne    800fae <strtol+0xae>
		s++, base = 8;
  800fa1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fa5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fac:	eb 0d                	jmp    800fbb <strtol+0xbb>
	else if (base == 0)
  800fae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb2:	75 07                	jne    800fbb <strtol+0xbb>
		base = 10;
  800fb4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	0f b6 00             	movzbl (%eax),%eax
  800fc1:	3c 2f                	cmp    $0x2f,%al
  800fc3:	7e 1b                	jle    800fe0 <strtol+0xe0>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	0f b6 00             	movzbl (%eax),%eax
  800fcb:	3c 39                	cmp    $0x39,%al
  800fcd:	7f 11                	jg     800fe0 <strtol+0xe0>
			dig = *s - '0';
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	0f b6 00             	movzbl (%eax),%eax
  800fd5:	0f be c0             	movsbl %al,%eax
  800fd8:	83 e8 30             	sub    $0x30,%eax
  800fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fde:	eb 48                	jmp    801028 <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	0f b6 00             	movzbl (%eax),%eax
  800fe6:	3c 60                	cmp    $0x60,%al
  800fe8:	7e 1b                	jle    801005 <strtol+0x105>
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	0f b6 00             	movzbl (%eax),%eax
  800ff0:	3c 7a                	cmp    $0x7a,%al
  800ff2:	7f 11                	jg     801005 <strtol+0x105>
			dig = *s - 'a' + 10;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	0f b6 00             	movzbl (%eax),%eax
  800ffa:	0f be c0             	movsbl %al,%eax
  800ffd:	83 e8 57             	sub    $0x57,%eax
  801000:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801003:	eb 23                	jmp    801028 <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	0f b6 00             	movzbl (%eax),%eax
  80100b:	3c 40                	cmp    $0x40,%al
  80100d:	7e 3c                	jle    80104b <strtol+0x14b>
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	0f b6 00             	movzbl (%eax),%eax
  801015:	3c 5a                	cmp    $0x5a,%al
  801017:	7f 32                	jg     80104b <strtol+0x14b>
			dig = *s - 'A' + 10;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	0f b6 00             	movzbl (%eax),%eax
  80101f:	0f be c0             	movsbl %al,%eax
  801022:	83 e8 37             	sub    $0x37,%eax
  801025:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80102e:	7d 1a                	jge    80104a <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
  801030:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801034:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801037:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103b:	89 c2                	mov    %eax,%edx
  80103d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801040:	01 d0                	add    %edx,%eax
  801042:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
  801045:	e9 71 ff ff ff       	jmp    800fbb <strtol+0xbb>
			break;
  80104a:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
  80104b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104f:	74 08                	je     801059 <strtol+0x159>
		*endptr = (char *) s;
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801059:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105d:	74 07                	je     801066 <strtol+0x166>
  80105f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801062:	f7 d8                	neg    %eax
  801064:	eb 03                	jmp    801069 <strtol+0x169>
  801066:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    
  80106b:	66 90                	xchg   %ax,%ax
  80106d:	66 90                	xchg   %ax,%ax
  80106f:	90                   	nop

00801070 <__udivdi3>:
  801070:	f3 0f 1e fb          	endbr32 
  801074:	55                   	push   %ebp
  801075:	57                   	push   %edi
  801076:	56                   	push   %esi
  801077:	53                   	push   %ebx
  801078:	83 ec 1c             	sub    $0x1c,%esp
  80107b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80107f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801083:	8b 74 24 34          	mov    0x34(%esp),%esi
  801087:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80108b:	85 d2                	test   %edx,%edx
  80108d:	75 19                	jne    8010a8 <__udivdi3+0x38>
  80108f:	39 f3                	cmp    %esi,%ebx
  801091:	76 4d                	jbe    8010e0 <__udivdi3+0x70>
  801093:	31 ff                	xor    %edi,%edi
  801095:	89 e8                	mov    %ebp,%eax
  801097:	89 f2                	mov    %esi,%edx
  801099:	f7 f3                	div    %ebx
  80109b:	89 fa                	mov    %edi,%edx
  80109d:	83 c4 1c             	add    $0x1c,%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    
  8010a5:	8d 76 00             	lea    0x0(%esi),%esi
  8010a8:	39 f2                	cmp    %esi,%edx
  8010aa:	76 14                	jbe    8010c0 <__udivdi3+0x50>
  8010ac:	31 ff                	xor    %edi,%edi
  8010ae:	31 c0                	xor    %eax,%eax
  8010b0:	89 fa                	mov    %edi,%edx
  8010b2:	83 c4 1c             	add    $0x1c,%esp
  8010b5:	5b                   	pop    %ebx
  8010b6:	5e                   	pop    %esi
  8010b7:	5f                   	pop    %edi
  8010b8:	5d                   	pop    %ebp
  8010b9:	c3                   	ret    
  8010ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010c0:	0f bd fa             	bsr    %edx,%edi
  8010c3:	83 f7 1f             	xor    $0x1f,%edi
  8010c6:	75 48                	jne    801110 <__udivdi3+0xa0>
  8010c8:	39 f2                	cmp    %esi,%edx
  8010ca:	72 06                	jb     8010d2 <__udivdi3+0x62>
  8010cc:	31 c0                	xor    %eax,%eax
  8010ce:	39 eb                	cmp    %ebp,%ebx
  8010d0:	77 de                	ja     8010b0 <__udivdi3+0x40>
  8010d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8010d7:	eb d7                	jmp    8010b0 <__udivdi3+0x40>
  8010d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010e0:	89 d9                	mov    %ebx,%ecx
  8010e2:	85 db                	test   %ebx,%ebx
  8010e4:	75 0b                	jne    8010f1 <__udivdi3+0x81>
  8010e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8010eb:	31 d2                	xor    %edx,%edx
  8010ed:	f7 f3                	div    %ebx
  8010ef:	89 c1                	mov    %eax,%ecx
  8010f1:	31 d2                	xor    %edx,%edx
  8010f3:	89 f0                	mov    %esi,%eax
  8010f5:	f7 f1                	div    %ecx
  8010f7:	89 c6                	mov    %eax,%esi
  8010f9:	89 e8                	mov    %ebp,%eax
  8010fb:	89 f7                	mov    %esi,%edi
  8010fd:	f7 f1                	div    %ecx
  8010ff:	89 fa                	mov    %edi,%edx
  801101:	83 c4 1c             	add    $0x1c,%esp
  801104:	5b                   	pop    %ebx
  801105:	5e                   	pop    %esi
  801106:	5f                   	pop    %edi
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    
  801109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801110:	89 f9                	mov    %edi,%ecx
  801112:	b8 20 00 00 00       	mov    $0x20,%eax
  801117:	29 f8                	sub    %edi,%eax
  801119:	d3 e2                	shl    %cl,%edx
  80111b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80111f:	89 c1                	mov    %eax,%ecx
  801121:	89 da                	mov    %ebx,%edx
  801123:	d3 ea                	shr    %cl,%edx
  801125:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801129:	09 d1                	or     %edx,%ecx
  80112b:	89 f2                	mov    %esi,%edx
  80112d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801131:	89 f9                	mov    %edi,%ecx
  801133:	d3 e3                	shl    %cl,%ebx
  801135:	89 c1                	mov    %eax,%ecx
  801137:	d3 ea                	shr    %cl,%edx
  801139:	89 f9                	mov    %edi,%ecx
  80113b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80113f:	89 eb                	mov    %ebp,%ebx
  801141:	d3 e6                	shl    %cl,%esi
  801143:	89 c1                	mov    %eax,%ecx
  801145:	d3 eb                	shr    %cl,%ebx
  801147:	09 de                	or     %ebx,%esi
  801149:	89 f0                	mov    %esi,%eax
  80114b:	f7 74 24 08          	divl   0x8(%esp)
  80114f:	89 d6                	mov    %edx,%esi
  801151:	89 c3                	mov    %eax,%ebx
  801153:	f7 64 24 0c          	mull   0xc(%esp)
  801157:	39 d6                	cmp    %edx,%esi
  801159:	72 15                	jb     801170 <__udivdi3+0x100>
  80115b:	89 f9                	mov    %edi,%ecx
  80115d:	d3 e5                	shl    %cl,%ebp
  80115f:	39 c5                	cmp    %eax,%ebp
  801161:	73 04                	jae    801167 <__udivdi3+0xf7>
  801163:	39 d6                	cmp    %edx,%esi
  801165:	74 09                	je     801170 <__udivdi3+0x100>
  801167:	89 d8                	mov    %ebx,%eax
  801169:	31 ff                	xor    %edi,%edi
  80116b:	e9 40 ff ff ff       	jmp    8010b0 <__udivdi3+0x40>
  801170:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801173:	31 ff                	xor    %edi,%edi
  801175:	e9 36 ff ff ff       	jmp    8010b0 <__udivdi3+0x40>
  80117a:	66 90                	xchg   %ax,%ax
  80117c:	66 90                	xchg   %ax,%ax
  80117e:	66 90                	xchg   %ax,%ax

00801180 <__umoddi3>:
  801180:	f3 0f 1e fb          	endbr32 
  801184:	55                   	push   %ebp
  801185:	57                   	push   %edi
  801186:	56                   	push   %esi
  801187:	53                   	push   %ebx
  801188:	83 ec 1c             	sub    $0x1c,%esp
  80118b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80118f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801193:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801197:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80119b:	85 c0                	test   %eax,%eax
  80119d:	75 19                	jne    8011b8 <__umoddi3+0x38>
  80119f:	39 df                	cmp    %ebx,%edi
  8011a1:	76 5d                	jbe    801200 <__umoddi3+0x80>
  8011a3:	89 f0                	mov    %esi,%eax
  8011a5:	89 da                	mov    %ebx,%edx
  8011a7:	f7 f7                	div    %edi
  8011a9:	89 d0                	mov    %edx,%eax
  8011ab:	31 d2                	xor    %edx,%edx
  8011ad:	83 c4 1c             	add    $0x1c,%esp
  8011b0:	5b                   	pop    %ebx
  8011b1:	5e                   	pop    %esi
  8011b2:	5f                   	pop    %edi
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    
  8011b5:	8d 76 00             	lea    0x0(%esi),%esi
  8011b8:	89 f2                	mov    %esi,%edx
  8011ba:	39 d8                	cmp    %ebx,%eax
  8011bc:	76 12                	jbe    8011d0 <__umoddi3+0x50>
  8011be:	89 f0                	mov    %esi,%eax
  8011c0:	89 da                	mov    %ebx,%edx
  8011c2:	83 c4 1c             	add    $0x1c,%esp
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    
  8011ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011d0:	0f bd e8             	bsr    %eax,%ebp
  8011d3:	83 f5 1f             	xor    $0x1f,%ebp
  8011d6:	75 50                	jne    801228 <__umoddi3+0xa8>
  8011d8:	39 d8                	cmp    %ebx,%eax
  8011da:	0f 82 e0 00 00 00    	jb     8012c0 <__umoddi3+0x140>
  8011e0:	89 d9                	mov    %ebx,%ecx
  8011e2:	39 f7                	cmp    %esi,%edi
  8011e4:	0f 86 d6 00 00 00    	jbe    8012c0 <__umoddi3+0x140>
  8011ea:	89 d0                	mov    %edx,%eax
  8011ec:	89 ca                	mov    %ecx,%edx
  8011ee:	83 c4 1c             	add    $0x1c,%esp
  8011f1:	5b                   	pop    %ebx
  8011f2:	5e                   	pop    %esi
  8011f3:	5f                   	pop    %edi
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    
  8011f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011fd:	8d 76 00             	lea    0x0(%esi),%esi
  801200:	89 fd                	mov    %edi,%ebp
  801202:	85 ff                	test   %edi,%edi
  801204:	75 0b                	jne    801211 <__umoddi3+0x91>
  801206:	b8 01 00 00 00       	mov    $0x1,%eax
  80120b:	31 d2                	xor    %edx,%edx
  80120d:	f7 f7                	div    %edi
  80120f:	89 c5                	mov    %eax,%ebp
  801211:	89 d8                	mov    %ebx,%eax
  801213:	31 d2                	xor    %edx,%edx
  801215:	f7 f5                	div    %ebp
  801217:	89 f0                	mov    %esi,%eax
  801219:	f7 f5                	div    %ebp
  80121b:	89 d0                	mov    %edx,%eax
  80121d:	31 d2                	xor    %edx,%edx
  80121f:	eb 8c                	jmp    8011ad <__umoddi3+0x2d>
  801221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801228:	89 e9                	mov    %ebp,%ecx
  80122a:	ba 20 00 00 00       	mov    $0x20,%edx
  80122f:	29 ea                	sub    %ebp,%edx
  801231:	d3 e0                	shl    %cl,%eax
  801233:	89 44 24 08          	mov    %eax,0x8(%esp)
  801237:	89 d1                	mov    %edx,%ecx
  801239:	89 f8                	mov    %edi,%eax
  80123b:	d3 e8                	shr    %cl,%eax
  80123d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801241:	89 54 24 04          	mov    %edx,0x4(%esp)
  801245:	8b 54 24 04          	mov    0x4(%esp),%edx
  801249:	09 c1                	or     %eax,%ecx
  80124b:	89 d8                	mov    %ebx,%eax
  80124d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801251:	89 e9                	mov    %ebp,%ecx
  801253:	d3 e7                	shl    %cl,%edi
  801255:	89 d1                	mov    %edx,%ecx
  801257:	d3 e8                	shr    %cl,%eax
  801259:	89 e9                	mov    %ebp,%ecx
  80125b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80125f:	d3 e3                	shl    %cl,%ebx
  801261:	89 c7                	mov    %eax,%edi
  801263:	89 d1                	mov    %edx,%ecx
  801265:	89 f0                	mov    %esi,%eax
  801267:	d3 e8                	shr    %cl,%eax
  801269:	89 e9                	mov    %ebp,%ecx
  80126b:	89 fa                	mov    %edi,%edx
  80126d:	d3 e6                	shl    %cl,%esi
  80126f:	09 d8                	or     %ebx,%eax
  801271:	f7 74 24 08          	divl   0x8(%esp)
  801275:	89 d1                	mov    %edx,%ecx
  801277:	89 f3                	mov    %esi,%ebx
  801279:	f7 64 24 0c          	mull   0xc(%esp)
  80127d:	89 c6                	mov    %eax,%esi
  80127f:	89 d7                	mov    %edx,%edi
  801281:	39 d1                	cmp    %edx,%ecx
  801283:	72 06                	jb     80128b <__umoddi3+0x10b>
  801285:	75 10                	jne    801297 <__umoddi3+0x117>
  801287:	39 c3                	cmp    %eax,%ebx
  801289:	73 0c                	jae    801297 <__umoddi3+0x117>
  80128b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80128f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801293:	89 d7                	mov    %edx,%edi
  801295:	89 c6                	mov    %eax,%esi
  801297:	89 ca                	mov    %ecx,%edx
  801299:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80129e:	29 f3                	sub    %esi,%ebx
  8012a0:	19 fa                	sbb    %edi,%edx
  8012a2:	89 d0                	mov    %edx,%eax
  8012a4:	d3 e0                	shl    %cl,%eax
  8012a6:	89 e9                	mov    %ebp,%ecx
  8012a8:	d3 eb                	shr    %cl,%ebx
  8012aa:	d3 ea                	shr    %cl,%edx
  8012ac:	09 d8                	or     %ebx,%eax
  8012ae:	83 c4 1c             	add    $0x1c,%esp
  8012b1:	5b                   	pop    %ebx
  8012b2:	5e                   	pop    %esi
  8012b3:	5f                   	pop    %edi
  8012b4:	5d                   	pop    %ebp
  8012b5:	c3                   	ret    
  8012b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012bd:	8d 76 00             	lea    0x0(%esi),%esi
  8012c0:	29 fe                	sub    %edi,%esi
  8012c2:	19 c3                	sbb    %eax,%ebx
  8012c4:	89 f2                	mov    %esi,%edx
  8012c6:	89 d9                	mov    %ebx,%ecx
  8012c8:	e9 1d ff ff ff       	jmp    8011ea <__umoddi3+0x6a>
