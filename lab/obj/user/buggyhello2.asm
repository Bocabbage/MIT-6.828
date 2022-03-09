
obj/user/buggyhello2:     file format elf32-i386


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
  80002c:	e8 3a 00 00 00       	call   80006b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	e8 24 00 00 00       	call   800067 <__x86.get_pc_thunk.ax>
  800043:	05 bd 1f 00 00       	add    $0x1fbd,%eax
	sys_cputs(hello, 1024*1024);
  800048:	8b 90 0c 00 00 00    	mov    0xc(%eax),%edx
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	68 00 00 10 00       	push   $0x100000
  800056:	52                   	push   %edx
  800057:	89 c3                	mov    %eax,%ebx
  800059:	e8 0b 01 00 00       	call   800169 <sys_cputs>
  80005e:	83 c4 10             	add    $0x10,%esp
}
  800061:	90                   	nop
  800062:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <__x86.get_pc_thunk.ax>:
  800067:	8b 04 24             	mov    (%esp),%eax
  80006a:	c3                   	ret    

0080006b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006b:	f3 0f 1e fb          	endbr32 
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	53                   	push   %ebx
  800073:	83 ec 04             	sub    $0x4,%esp
  800076:	e8 5a 00 00 00       	call   8000d5 <__x86.get_pc_thunk.bx>
  80007b:	81 c3 85 1f 00 00    	add    $0x1f85,%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code h(ere.
	thisenv = envs + ENVX(sys_getenvid());
  800081:	e8 76 01 00 00       	call   8001fc <sys_getenvid>
  800086:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008b:	89 c2                	mov    %eax,%edx
  80008d:	89 d0                	mov    %edx,%eax
  80008f:	01 c0                	add    %eax,%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	c1 e0 05             	shl    $0x5,%eax
  800096:	89 c2                	mov    %eax,%edx
  800098:	c7 c0 00 00 c0 ee    	mov    $0xeec00000,%eax
  80009e:	01 c2                	add    %eax,%edx
  8000a0:	c7 c0 30 20 80 00    	mov    $0x802030,%eax
  8000a6:	89 10                	mov    %edx,(%eax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ac:	7e 0b                	jle    8000b9 <libmain+0x4e>
		binaryname = argv[0];
  8000ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b1:	8b 00                	mov    (%eax),%eax
  8000b3:	89 83 10 00 00 00    	mov    %eax,0x10(%ebx)

	// call user main routine
	umain(argc, argv);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 0c             	pushl  0xc(%ebp)
  8000bf:	ff 75 08             	pushl  0x8(%ebp)
  8000c2:	e8 6c ff ff ff       	call   800033 <umain>
  8000c7:	83 c4 10             	add    $0x10,%esp

	// exit gracefully
	exit();
  8000ca:	e8 0a 00 00 00       	call   8000d9 <exit>
}
  8000cf:	90                   	nop
  8000d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d3:	c9                   	leave  
  8000d4:	c3                   	ret    

008000d5 <__x86.get_pc_thunk.bx>:
  8000d5:	8b 1c 24             	mov    (%esp),%ebx
  8000d8:	c3                   	ret    

008000d9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d9:	f3 0f 1e fb          	endbr32 
  8000dd:	55                   	push   %ebp
  8000de:	89 e5                	mov    %esp,%ebp
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 04             	sub    $0x4,%esp
  8000e4:	e8 7e ff ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  8000e9:	05 17 1f 00 00       	add    $0x1f17,%eax
	sys_env_destroy(0);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	6a 00                	push   $0x0
  8000f3:	89 c3                	mov    %eax,%ebx
  8000f5:	e8 d1 00 00 00       	call   8001cb <sys_env_destroy>
  8000fa:	83 c4 10             	add    $0x10,%esp
}
  8000fd:	90                   	nop
  8000fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800101:	c9                   	leave  
  800102:	c3                   	ret    

00800103 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	57                   	push   %edi
  800107:	56                   	push   %esi
  800108:	53                   	push   %ebx
  800109:	83 ec 2c             	sub    $0x2c,%esp
  80010c:	e8 c4 ff ff ff       	call   8000d5 <__x86.get_pc_thunk.bx>
  800111:	81 c3 ef 1e 00 00    	add    $0x1eef,%ebx
  800117:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011a:	8b 45 08             	mov    0x8(%ebp),%eax
  80011d:	8b 55 10             	mov    0x10(%ebp),%edx
  800120:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800123:	8b 5d 18             	mov    0x18(%ebp),%ebx
  800126:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  800129:	8b 75 20             	mov    0x20(%ebp),%esi
  80012c:	cd 30                	int    $0x30
  80012e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800131:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800135:	74 27                	je     80015e <syscall+0x5b>
  800137:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80013b:	7e 21                	jle    80015e <syscall+0x5b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 e4             	pushl  -0x1c(%ebp)
  800143:	ff 75 08             	pushl  0x8(%ebp)
  800146:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800149:	8d 83 f8 f2 ff ff    	lea    -0xd08(%ebx),%eax
  80014f:	50                   	push   %eax
  800150:	6a 23                	push   $0x23
  800152:	8d 83 15 f3 ff ff    	lea    -0xceb(%ebx),%eax
  800158:	50                   	push   %eax
  800159:	e8 cd 00 00 00       	call   80022b <_panic>

	return ret;
  80015e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  800161:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    

00800169 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800169:	f3 0f 1e fb          	endbr32 
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	e8 ef fe ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800178:	05 88 1e 00 00       	add    $0x1e88,%eax
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80017d:	8b 45 08             	mov    0x8(%ebp),%eax
  800180:	83 ec 04             	sub    $0x4,%esp
  800183:	6a 00                	push   $0x0
  800185:	6a 00                	push   $0x0
  800187:	6a 00                	push   $0x0
  800189:	ff 75 0c             	pushl  0xc(%ebp)
  80018c:	50                   	push   %eax
  80018d:	6a 00                	push   $0x0
  80018f:	6a 00                	push   $0x0
  800191:	e8 6d ff ff ff       	call   800103 <syscall>
  800196:	83 c4 20             	add    $0x20,%esp
}
  800199:	90                   	nop
  80019a:	c9                   	leave  
  80019b:	c3                   	ret    

0080019c <sys_cgetc>:

int
sys_cgetc(void)
{
  80019c:	f3 0f 1e fb          	endbr32 
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	e8 bc fe ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  8001ab:	05 55 1e 00 00       	add    $0x1e55,%eax
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	6a 00                	push   $0x0
  8001b5:	6a 00                	push   $0x0
  8001b7:	6a 00                	push   $0x0
  8001b9:	6a 00                	push   $0x0
  8001bb:	6a 00                	push   $0x0
  8001bd:	6a 00                	push   $0x0
  8001bf:	6a 01                	push   $0x1
  8001c1:	e8 3d ff ff ff       	call   800103 <syscall>
  8001c6:	83 c4 20             	add    $0x20,%esp
}
  8001c9:	c9                   	leave  
  8001ca:	c3                   	ret    

008001cb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001cb:	f3 0f 1e fb          	endbr32 
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	e8 8d fe ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  8001da:	05 26 1e 00 00       	add    $0x1e26,%eax
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001df:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 00                	push   $0x0
  8001e7:	6a 00                	push   $0x0
  8001e9:	6a 00                	push   $0x0
  8001eb:	6a 00                	push   $0x0
  8001ed:	50                   	push   %eax
  8001ee:	6a 01                	push   $0x1
  8001f0:	6a 03                	push   $0x3
  8001f2:	e8 0c ff ff ff       	call   800103 <syscall>
  8001f7:	83 c4 20             	add    $0x20,%esp
}
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8001fc:	f3 0f 1e fb          	endbr32 
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	e8 5c fe ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  80020b:	05 f5 1d 00 00       	add    $0x1df5,%eax
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800210:	83 ec 04             	sub    $0x4,%esp
  800213:	6a 00                	push   $0x0
  800215:	6a 00                	push   $0x0
  800217:	6a 00                	push   $0x0
  800219:	6a 00                	push   $0x0
  80021b:	6a 00                	push   $0x0
  80021d:	6a 00                	push   $0x0
  80021f:	6a 02                	push   $0x2
  800221:	e8 dd fe ff ff       	call   800103 <syscall>
  800226:	83 c4 20             	add    $0x20,%esp
}
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022b:	f3 0f 1e fb          	endbr32 
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	56                   	push   %esi
  800233:	53                   	push   %ebx
  800234:	83 ec 10             	sub    $0x10,%esp
  800237:	e8 99 fe ff ff       	call   8000d5 <__x86.get_pc_thunk.bx>
  80023c:	81 c3 c4 1d 00 00    	add    $0x1dc4,%ebx
	va_list ap;

	va_start(ap, fmt);
  800242:	8d 45 14             	lea    0x14(%ebp),%eax
  800245:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800248:	c7 c0 10 20 80 00    	mov    $0x802010,%eax
  80024e:	8b 30                	mov    (%eax),%esi
  800250:	e8 a7 ff ff ff       	call   8001fc <sys_getenvid>
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 0c             	pushl  0xc(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	56                   	push   %esi
  80025f:	50                   	push   %eax
  800260:	8d 83 24 f3 ff ff    	lea    -0xcdc(%ebx),%eax
  800266:	50                   	push   %eax
  800267:	e8 0f 01 00 00       	call   80037b <cprintf>
  80026c:	83 c4 20             	add    $0x20,%esp
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80026f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	50                   	push   %eax
  800276:	ff 75 10             	pushl  0x10(%ebp)
  800279:	e8 8d 00 00 00       	call   80030b <vcprintf>
  80027e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	8d 83 47 f3 ff ff    	lea    -0xcb9(%ebx),%eax
  80028a:	50                   	push   %eax
  80028b:	e8 eb 00 00 00       	call   80037b <cprintf>
  800290:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800293:	cc                   	int3   
  800294:	eb fd                	jmp    800293 <_panic+0x68>

00800296 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800296:	f3 0f 1e fb          	endbr32 
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	53                   	push   %ebx
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	e8 09 01 00 00       	call   8003af <__x86.get_pc_thunk.dx>
  8002a6:	81 c2 5a 1d 00 00    	add    $0x1d5a,%edx
	b->buf[b->idx++] = ch;
  8002ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002af:	8b 00                	mov    (%eax),%eax
  8002b1:	8d 58 01             	lea    0x1(%eax),%ebx
  8002b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b7:	89 19                	mov    %ebx,(%ecx)
  8002b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002bc:	89 cb                	mov    %ecx,%ebx
  8002be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c1:	88 5c 01 08          	mov    %bl,0x8(%ecx,%eax,1)
	if (b->idx == 256-1) {
  8002c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002cf:	75 25                	jne    8002f6 <putch+0x60>
		sys_cputs(b->buf, b->idx);
  8002d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d4:	8b 00                	mov    (%eax),%eax
  8002d6:	89 c1                	mov    %eax,%ecx
  8002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002db:	83 c0 08             	add    $0x8,%eax
  8002de:	83 ec 08             	sub    $0x8,%esp
  8002e1:	51                   	push   %ecx
  8002e2:	50                   	push   %eax
  8002e3:	89 d3                	mov    %edx,%ebx
  8002e5:	e8 7f fe ff ff       	call   800169 <sys_cputs>
  8002ea:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f9:	8b 40 04             	mov    0x4(%eax),%eax
  8002fc:	8d 50 01             	lea    0x1(%eax),%edx
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	89 50 04             	mov    %edx,0x4(%eax)
}
  800305:	90                   	nop
  800306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80030b:	f3 0f 1e fb          	endbr32 
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	53                   	push   %ebx
  800313:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800319:	e8 b7 fd ff ff       	call   8000d5 <__x86.get_pc_thunk.bx>
  80031e:	81 c3 e2 1c 00 00    	add    $0x1ce2,%ebx
	struct printbuf b;

	b.idx = 0;
  800324:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032b:	00 00 00 
	b.cnt = 0;
  80032e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800335:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800338:	ff 75 0c             	pushl  0xc(%ebp)
  80033b:	ff 75 08             	pushl  0x8(%ebp)
  80033e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800344:	50                   	push   %eax
  800345:	8d 83 96 e2 ff ff    	lea    -0x1d6a(%ebx),%eax
  80034b:	50                   	push   %eax
  80034c:	e8 e3 01 00 00       	call   800534 <vprintfmt>
  800351:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800354:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80035a:	83 ec 08             	sub    $0x8,%esp
  80035d:	50                   	push   %eax
  80035e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800364:	83 c0 08             	add    $0x8,%eax
  800367:	50                   	push   %eax
  800368:	e8 fc fd ff ff       	call   800169 <sys_cputs>
  80036d:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800370:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800376:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80037b:	f3 0f 1e fb          	endbr32 
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
  800385:	e8 dd fc ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  80038a:	05 76 1c 00 00       	add    $0x1c76,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80038f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800392:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
  800395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800398:	83 ec 08             	sub    $0x8,%esp
  80039b:	50                   	push   %eax
  80039c:	ff 75 08             	pushl  0x8(%ebp)
  80039f:	e8 67 ff ff ff       	call   80030b <vcprintf>
  8003a4:	83 c4 10             	add    $0x10,%esp
  8003a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
  8003aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8003ad:	c9                   	leave  
  8003ae:	c3                   	ret    

008003af <__x86.get_pc_thunk.dx>:
  8003af:	8b 14 24             	mov    (%esp),%edx
  8003b2:	c3                   	ret    

008003b3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b3:	f3 0f 1e fb          	endbr32 
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	57                   	push   %edi
  8003bb:	56                   	push   %esi
  8003bc:	53                   	push   %ebx
  8003bd:	83 ec 1c             	sub    $0x1c,%esp
  8003c0:	e8 43 06 00 00       	call   800a08 <__x86.get_pc_thunk.si>
  8003c5:	81 c6 3b 1c 00 00    	add    $0x1c3b,%esi
  8003cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8003da:	ba 00 00 00 00       	mov    $0x0,%edx
  8003df:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003e2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8003e5:	19 d1                	sbb    %edx,%ecx
  8003e7:	72 4d                	jb     800436 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003e9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003ec:	8d 78 ff             	lea    -0x1(%eax),%edi
  8003ef:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f7:	52                   	push   %edx
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ff:	89 f3                	mov    %esi,%ebx
  800401:	e8 7a 0c 00 00       	call   801080 <__udivdi3>
  800406:	83 c4 10             	add    $0x10,%esp
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	ff 75 20             	pushl  0x20(%ebp)
  80040f:	57                   	push   %edi
  800410:	ff 75 18             	pushl  0x18(%ebp)
  800413:	52                   	push   %edx
  800414:	50                   	push   %eax
  800415:	ff 75 0c             	pushl  0xc(%ebp)
  800418:	ff 75 08             	pushl  0x8(%ebp)
  80041b:	e8 93 ff ff ff       	call   8003b3 <printnum>
  800420:	83 c4 20             	add    $0x20,%esp
  800423:	eb 1b                	jmp    800440 <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	ff 75 0c             	pushl  0xc(%ebp)
  80042b:	ff 75 20             	pushl  0x20(%ebp)
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	ff d0                	call   *%eax
  800433:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800436:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  80043a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80043e:	7f e5                	jg     800425 <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800440:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800443:	bb 00 00 00 00       	mov    $0x0,%ebx
  800448:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80044e:	53                   	push   %ebx
  80044f:	51                   	push   %ecx
  800450:	52                   	push   %edx
  800451:	50                   	push   %eax
  800452:	89 f3                	mov    %esi,%ebx
  800454:	e8 37 0d 00 00       	call   801190 <__umoddi3>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	8d 8e b5 f3 ff ff    	lea    -0xc4b(%esi),%ecx
  800462:	01 c8                	add    %ecx,%eax
  800464:	0f b6 00             	movzbl (%eax),%eax
  800467:	0f be c0             	movsbl %al,%eax
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	ff 75 0c             	pushl  0xc(%ebp)
  800470:	50                   	push   %eax
  800471:	8b 45 08             	mov    0x8(%ebp),%eax
  800474:	ff d0                	call   *%eax
  800476:	83 c4 10             	add    $0x10,%esp
}
  800479:	90                   	nop
  80047a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80047d:	5b                   	pop    %ebx
  80047e:	5e                   	pop    %esi
  80047f:	5f                   	pop    %edi
  800480:	5d                   	pop    %ebp
  800481:	c3                   	ret    

00800482 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800482:	f3 0f 1e fb          	endbr32 
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	e8 d9 fb ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  80048e:	05 72 1b 00 00       	add    $0x1b72,%eax
	if (lflag >= 2)
  800493:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800497:	7e 14                	jle    8004ad <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 48 08             	lea    0x8(%eax),%ecx
  8004a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a4:	89 0a                	mov    %ecx,(%edx)
  8004a6:	8b 50 04             	mov    0x4(%eax),%edx
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	eb 30                	jmp    8004dd <getuint+0x5b>
	else if (lflag)
  8004ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b1:	74 16                	je     8004c9 <getuint+0x47>
		return va_arg(*ap, unsigned long);
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	8d 48 04             	lea    0x4(%eax),%ecx
  8004bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8004be:	89 0a                	mov    %ecx,(%edx)
  8004c0:	8b 00                	mov    (%eax),%eax
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c7:	eb 14                	jmp    8004dd <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	8d 48 04             	lea    0x4(%eax),%ecx
  8004d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d4:	89 0a                	mov    %ecx,(%edx)
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004dd:	5d                   	pop    %ebp
  8004de:	c3                   	ret    

008004df <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004df:	f3 0f 1e fb          	endbr32 
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	e8 7c fb ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  8004eb:	05 15 1b 00 00       	add    $0x1b15,%eax
	if (lflag >= 2)
  8004f0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004f4:	7e 14                	jle    80050a <getint+0x2b>
		return va_arg(*ap, long long);
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	8d 48 08             	lea    0x8(%eax),%ecx
  8004fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800501:	89 0a                	mov    %ecx,(%edx)
  800503:	8b 50 04             	mov    0x4(%eax),%edx
  800506:	8b 00                	mov    (%eax),%eax
  800508:	eb 28                	jmp    800532 <getint+0x53>
	else if (lflag)
  80050a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80050e:	74 12                	je     800522 <getint+0x43>
		return va_arg(*ap, long);
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	8d 48 04             	lea    0x4(%eax),%ecx
  800518:	8b 55 08             	mov    0x8(%ebp),%edx
  80051b:	89 0a                	mov    %ecx,(%edx)
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	99                   	cltd   
  800520:	eb 10                	jmp    800532 <getint+0x53>
	else
		return va_arg(*ap, int);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	8d 48 04             	lea    0x4(%eax),%ecx
  80052a:	8b 55 08             	mov    0x8(%ebp),%edx
  80052d:	89 0a                	mov    %ecx,(%edx)
  80052f:	8b 00                	mov    (%eax),%eax
  800531:	99                   	cltd   
}
  800532:	5d                   	pop    %ebp
  800533:	c3                   	ret    

00800534 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800534:	f3 0f 1e fb          	endbr32 
  800538:	55                   	push   %ebp
  800539:	89 e5                	mov    %esp,%ebp
  80053b:	57                   	push   %edi
  80053c:	56                   	push   %esi
  80053d:	53                   	push   %ebx
  80053e:	83 ec 2c             	sub    $0x2c,%esp
  800541:	e8 c6 04 00 00       	call   800a0c <__x86.get_pc_thunk.di>
  800546:	81 c7 ba 1a 00 00    	add    $0x1aba,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80054c:	eb 17                	jmp    800565 <vprintfmt+0x31>
			if (ch == '\0')
  80054e:	85 db                	test   %ebx,%ebx
  800550:	0f 84 96 03 00 00    	je     8008ec <.L20+0x2d>
				return;
			putch(ch, putdat);
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	ff 75 0c             	pushl  0xc(%ebp)
  80055c:	53                   	push   %ebx
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	ff d0                	call   *%eax
  800562:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800565:	8b 45 10             	mov    0x10(%ebp),%eax
  800568:	8d 50 01             	lea    0x1(%eax),%edx
  80056b:	89 55 10             	mov    %edx,0x10(%ebp)
  80056e:	0f b6 00             	movzbl (%eax),%eax
  800571:	0f b6 d8             	movzbl %al,%ebx
  800574:	83 fb 25             	cmp    $0x25,%ebx
  800577:	75 d5                	jne    80054e <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
  800579:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
  80057d:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
  800584:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
  80058b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
  800592:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800599:	8b 45 10             	mov    0x10(%ebp),%eax
  80059c:	8d 50 01             	lea    0x1(%eax),%edx
  80059f:	89 55 10             	mov    %edx,0x10(%ebp)
  8005a2:	0f b6 00             	movzbl (%eax),%eax
  8005a5:	0f b6 d8             	movzbl %al,%ebx
  8005a8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005ab:	83 f8 55             	cmp    $0x55,%eax
  8005ae:	0f 87 0b 03 00 00    	ja     8008bf <.L20>
  8005b4:	c1 e0 02             	shl    $0x2,%eax
  8005b7:	8b 84 38 dc f3 ff ff 	mov    -0xc24(%eax,%edi,1),%eax
  8005be:	01 f8                	add    %edi,%eax
  8005c0:	3e ff e0             	notrack jmp *%eax

008005c3 <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
  8005c3:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
  8005c7:	eb d0                	jmp    800599 <vprintfmt+0x65>

008005c9 <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005c9:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
  8005cd:	eb ca                	jmp    800599 <vprintfmt+0x65>

008005cf <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005cf:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
  8005d6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005d9:	89 d0                	mov    %edx,%eax
  8005db:	c1 e0 02             	shl    $0x2,%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	01 c0                	add    %eax,%eax
  8005e2:	01 d8                	add    %ebx,%eax
  8005e4:	83 e8 30             	sub    $0x30,%eax
  8005e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
  8005ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ed:	0f b6 00             	movzbl (%eax),%eax
  8005f0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005f3:	83 fb 2f             	cmp    $0x2f,%ebx
  8005f6:	7e 39                	jle    800631 <.L37+0xc>
  8005f8:	83 fb 39             	cmp    $0x39,%ebx
  8005fb:	7f 34                	jg     800631 <.L37+0xc>
			for (precision = 0; ; ++fmt) {
  8005fd:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
  800601:	eb d3                	jmp    8005d6 <.L31+0x7>

00800603 <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 50 04             	lea    0x4(%eax),%edx
  800609:	89 55 14             	mov    %edx,0x14(%ebp)
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
  800611:	eb 1f                	jmp    800632 <.L37+0xd>

00800613 <.L33>:

		case '.':
			if (width < 0)
  800613:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800617:	79 80                	jns    800599 <vprintfmt+0x65>
				width = 0;
  800619:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
  800620:	e9 74 ff ff ff       	jmp    800599 <vprintfmt+0x65>

00800625 <.L37>:

		case '#':
			altflag = 1;
  800625:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
  80062c:	e9 68 ff ff ff       	jmp    800599 <vprintfmt+0x65>
			goto process_precision;
  800631:	90                   	nop

		process_precision:
			if (width < 0)
  800632:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800636:	0f 89 5d ff ff ff    	jns    800599 <vprintfmt+0x65>
				width = precision, precision = -1;
  80063c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80063f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800642:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
  800649:	e9 4b ff ff ff       	jmp    800599 <vprintfmt+0x65>

0080064e <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80064e:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
  800652:	e9 42 ff ff ff       	jmp    800599 <vprintfmt+0x65>

00800657 <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 50 04             	lea    0x4(%eax),%edx
  80065d:	89 55 14             	mov    %edx,0x14(%ebp)
  800660:	8b 00                	mov    (%eax),%eax
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	ff 75 0c             	pushl  0xc(%ebp)
  800668:	50                   	push   %eax
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	ff d0                	call   *%eax
  80066e:	83 c4 10             	add    $0x10,%esp
			break;
  800671:	e9 71 02 00 00       	jmp    8008e7 <.L20+0x28>

00800676 <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8d 50 04             	lea    0x4(%eax),%edx
  80067c:	89 55 14             	mov    %edx,0x14(%ebp)
  80067f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800681:	85 db                	test   %ebx,%ebx
  800683:	79 02                	jns    800687 <.L28+0x11>
				err = -err;
  800685:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800687:	83 fb 06             	cmp    $0x6,%ebx
  80068a:	7f 0b                	jg     800697 <.L28+0x21>
  80068c:	8b b4 9f 14 00 00 00 	mov    0x14(%edi,%ebx,4),%esi
  800693:	85 f6                	test   %esi,%esi
  800695:	75 1b                	jne    8006b2 <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
  800697:	53                   	push   %ebx
  800698:	8d 87 c6 f3 ff ff    	lea    -0xc3a(%edi),%eax
  80069e:	50                   	push   %eax
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	ff 75 08             	pushl  0x8(%ebp)
  8006a5:	e8 4b 02 00 00       	call   8008f5 <printfmt>
  8006aa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006ad:	e9 35 02 00 00       	jmp    8008e7 <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
  8006b2:	56                   	push   %esi
  8006b3:	8d 87 cf f3 ff ff    	lea    -0xc31(%edi),%eax
  8006b9:	50                   	push   %eax
  8006ba:	ff 75 0c             	pushl  0xc(%ebp)
  8006bd:	ff 75 08             	pushl  0x8(%ebp)
  8006c0:	e8 30 02 00 00       	call   8008f5 <printfmt>
  8006c5:	83 c4 10             	add    $0x10,%esp
			break;
  8006c8:	e9 1a 02 00 00       	jmp    8008e7 <.L20+0x28>

008006cd <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8d 50 04             	lea    0x4(%eax),%edx
  8006d3:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d6:	8b 30                	mov    (%eax),%esi
  8006d8:	85 f6                	test   %esi,%esi
  8006da:	75 06                	jne    8006e2 <.L24+0x15>
				p = "(null)";
  8006dc:	8d b7 d2 f3 ff ff    	lea    -0xc2e(%edi),%esi
			if (width > 0 && padc != '-')
  8006e2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006e6:	7e 71                	jle    800759 <.L24+0x8c>
  8006e8:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  8006ec:	74 6b                	je     800759 <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	50                   	push   %eax
  8006f5:	56                   	push   %esi
  8006f6:	89 fb                	mov    %edi,%ebx
  8006f8:	e8 47 03 00 00       	call   800a44 <strnlen>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	29 45 d4             	sub    %eax,-0x2c(%ebp)
  800703:	eb 17                	jmp    80071c <.L24+0x4f>
					putch(padc, putdat);
  800705:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	50                   	push   %eax
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	ff d0                	call   *%eax
  800715:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
  800718:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  80071c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800720:	7f e3                	jg     800705 <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800722:	eb 35                	jmp    800759 <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
  800724:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800728:	74 1c                	je     800746 <.L24+0x79>
  80072a:	83 fb 1f             	cmp    $0x1f,%ebx
  80072d:	7e 05                	jle    800734 <.L24+0x67>
  80072f:	83 fb 7e             	cmp    $0x7e,%ebx
  800732:	7e 12                	jle    800746 <.L24+0x79>
					putch('?', putdat);
  800734:	83 ec 08             	sub    $0x8,%esp
  800737:	ff 75 0c             	pushl  0xc(%ebp)
  80073a:	6a 3f                	push   $0x3f
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	ff d0                	call   *%eax
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	eb 0f                	jmp    800755 <.L24+0x88>
				else
					putch(ch, putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 0c             	pushl  0xc(%ebp)
  80074c:	53                   	push   %ebx
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800755:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800759:	89 f0                	mov    %esi,%eax
  80075b:	8d 70 01             	lea    0x1(%eax),%esi
  80075e:	0f b6 00             	movzbl (%eax),%eax
  800761:	0f be d8             	movsbl %al,%ebx
  800764:	85 db                	test   %ebx,%ebx
  800766:	74 26                	je     80078e <.L24+0xc1>
  800768:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80076c:	78 b6                	js     800724 <.L24+0x57>
  80076e:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  800772:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800776:	79 ac                	jns    800724 <.L24+0x57>
			for (; width > 0; width--)
  800778:	eb 14                	jmp    80078e <.L24+0xc1>
				putch(' ', putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 0c             	pushl  0xc(%ebp)
  800780:	6a 20                	push   $0x20
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	ff d0                	call   *%eax
  800787:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
  80078a:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  80078e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800792:	7f e6                	jg     80077a <.L24+0xad>
			break;
  800794:	e9 4e 01 00 00       	jmp    8008e7 <.L20+0x28>

00800799 <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 d8             	pushl  -0x28(%ebp)
  80079f:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a2:	50                   	push   %eax
  8007a3:	e8 37 fd ff ff       	call   8004df <getint>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
  8007b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b7:	85 d2                	test   %edx,%edx
  8007b9:	79 23                	jns    8007de <.L29+0x45>
				putch('-', putdat);
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	6a 2d                	push   $0x2d
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	ff d0                	call   *%eax
  8007c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007d1:	f7 d8                	neg    %eax
  8007d3:	83 d2 00             	adc    $0x0,%edx
  8007d6:	f7 da                	neg    %edx
  8007d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
  8007de:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007e5:	e9 9f 00 00 00       	jmp    800889 <.L21+0x1f>

008007ea <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8007f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f3:	50                   	push   %eax
  8007f4:	e8 89 fc ff ff       	call   800482 <getuint>
  8007f9:	83 c4 10             	add    $0x10,%esp
  8007fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
  800802:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  800809:	eb 7e                	jmp    800889 <.L21+0x1f>

0080080b <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	ff 75 d8             	pushl  -0x28(%ebp)
  800811:	8d 45 14             	lea    0x14(%ebp),%eax
  800814:	50                   	push   %eax
  800815:	e8 68 fc ff ff       	call   800482 <getuint>
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800820:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
  800823:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
  80082a:	eb 5d                	jmp    800889 <.L21+0x1f>

0080082c <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	6a 30                	push   $0x30
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	ff d0                	call   *%eax
  800839:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	6a 78                	push   $0x78
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8d 50 04             	lea    0x4(%eax),%edx
  800852:	89 55 14             	mov    %edx,0x14(%ebp)
  800855:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
  800857:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80085a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
  800861:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
  800868:	eb 1f                	jmp    800889 <.L21+0x1f>

0080086a <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 d8             	pushl  -0x28(%ebp)
  800870:	8d 45 14             	lea    0x14(%ebp),%eax
  800873:	50                   	push   %eax
  800874:	e8 09 fc ff ff       	call   800482 <getuint>
  800879:	83 c4 10             	add    $0x10,%esp
  80087c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80087f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
  800882:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800889:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  80088d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800890:	83 ec 04             	sub    $0x4,%esp
  800893:	52                   	push   %edx
  800894:	ff 75 d4             	pushl  -0x2c(%ebp)
  800897:	50                   	push   %eax
  800898:	ff 75 e4             	pushl  -0x1c(%ebp)
  80089b:	ff 75 e0             	pushl  -0x20(%ebp)
  80089e:	ff 75 0c             	pushl  0xc(%ebp)
  8008a1:	ff 75 08             	pushl  0x8(%ebp)
  8008a4:	e8 0a fb ff ff       	call   8003b3 <printnum>
  8008a9:	83 c4 20             	add    $0x20,%esp
			break;
  8008ac:	eb 39                	jmp    8008e7 <.L20+0x28>

008008ae <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	53                   	push   %ebx
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	ff d0                	call   *%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
			break;
  8008bd:	eb 28                	jmp    8008e7 <.L20+0x28>

008008bf <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	6a 25                	push   $0x25
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	ff d0                	call   *%eax
  8008cc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008d3:	eb 04                	jmp    8008d9 <.L20+0x1a>
  8008d5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dc:	83 e8 01             	sub    $0x1,%eax
  8008df:	0f b6 00             	movzbl (%eax),%eax
  8008e2:	3c 25                	cmp    $0x25,%al
  8008e4:	75 ef                	jne    8008d5 <.L20+0x16>
				/* do nothing */;
			break;
  8008e6:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e7:	e9 79 fc ff ff       	jmp    800565 <vprintfmt+0x31>
				return;
  8008ec:	90                   	nop
		}
	}
}
  8008ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5f                   	pop    %edi
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f5:	f3 0f 1e fb          	endbr32 
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	83 ec 18             	sub    $0x18,%esp
  8008ff:	e8 63 f7 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800904:	05 fc 16 00 00       	add    $0x16fc,%eax
	va_list ap;

	va_start(ap, fmt);
  800909:	8d 45 14             	lea    0x14(%ebp),%eax
  80090c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80090f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800912:	50                   	push   %eax
  800913:	ff 75 10             	pushl  0x10(%ebp)
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	ff 75 08             	pushl  0x8(%ebp)
  80091c:	e8 13 fc ff ff       	call   800534 <vprintfmt>
  800921:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800924:	90                   	nop
  800925:	c9                   	leave  
  800926:	c3                   	ret    

00800927 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800927:	f3 0f 1e fb          	endbr32 
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	e8 34 f7 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800933:	05 cd 16 00 00       	add    $0x16cd,%eax
	b->cnt++;
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	8b 40 08             	mov    0x8(%eax),%eax
  80093e:	8d 50 01             	lea    0x1(%eax),%edx
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094a:	8b 10                	mov    (%eax),%edx
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	8b 40 04             	mov    0x4(%eax),%eax
  800952:	39 c2                	cmp    %eax,%edx
  800954:	73 12                	jae    800968 <sprintputch+0x41>
		*b->buf++ = ch;
  800956:	8b 45 0c             	mov    0xc(%ebp),%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	8d 48 01             	lea    0x1(%eax),%ecx
  80095e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800961:	89 0a                	mov    %ecx,(%edx)
  800963:	8b 55 08             	mov    0x8(%ebp),%edx
  800966:	88 10                	mov    %dl,(%eax)
}
  800968:	90                   	nop
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80096b:	f3 0f 1e fb          	endbr32 
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	83 ec 18             	sub    $0x18,%esp
  800975:	e8 ed f6 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  80097a:	05 86 16 00 00       	add    $0x1686,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
  80097f:	8b 55 08             	mov    0x8(%ebp),%edx
  800982:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800985:	8b 55 0c             	mov    0xc(%ebp),%edx
  800988:	8d 4a ff             	lea    -0x1(%edx),%ecx
  80098b:	8b 55 08             	mov    0x8(%ebp),%edx
  80098e:	01 ca                	add    %ecx,%edx
  800990:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800993:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80099e:	74 06                	je     8009a6 <vsnprintf+0x3b>
  8009a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a4:	7f 07                	jg     8009ad <vsnprintf+0x42>
		return -E_INVAL;
  8009a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009ab:	eb 22                	jmp    8009cf <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ad:	ff 75 14             	pushl  0x14(%ebp)
  8009b0:	ff 75 10             	pushl  0x10(%ebp)
  8009b3:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8009b6:	52                   	push   %edx
  8009b7:	8d 80 27 e9 ff ff    	lea    -0x16d9(%eax),%eax
  8009bd:	50                   	push   %eax
  8009be:	e8 71 fb ff ff       	call   800534 <vprintfmt>
  8009c3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d1:	f3 0f 1e fb          	endbr32 
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	83 ec 18             	sub    $0x18,%esp
  8009db:	e8 87 f6 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  8009e0:	05 20 16 00 00       	add    $0x1620,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ee:	50                   	push   %eax
  8009ef:	ff 75 10             	pushl  0x10(%ebp)
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	ff 75 08             	pushl  0x8(%ebp)
  8009f8:	e8 6e ff ff ff       	call   80096b <vsnprintf>
  8009fd:	83 c4 10             	add    $0x10,%esp
  800a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
  800a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a06:	c9                   	leave  
  800a07:	c3                   	ret    

00800a08 <__x86.get_pc_thunk.si>:
  800a08:	8b 34 24             	mov    (%esp),%esi
  800a0b:	c3                   	ret    

00800a0c <__x86.get_pc_thunk.di>:
  800a0c:	8b 3c 24             	mov    (%esp),%edi
  800a0f:	c3                   	ret    

00800a10 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a10:	f3 0f 1e fb          	endbr32 
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 10             	sub    $0x10,%esp
  800a1a:	e8 48 f6 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800a1f:	05 e1 15 00 00       	add    $0x15e1,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800a24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2b:	eb 08                	jmp    800a35 <strlen+0x25>
		n++;
  800a2d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
  800a31:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	0f b6 00             	movzbl (%eax),%eax
  800a3b:	84 c0                	test   %al,%al
  800a3d:	75 ee                	jne    800a2d <strlen+0x1d>
	return n;
  800a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a44:	f3 0f 1e fb          	endbr32 
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	83 ec 10             	sub    $0x10,%esp
  800a4e:	e8 14 f6 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800a53:	05 ad 15 00 00       	add    $0x15ad,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5f:	eb 0c                	jmp    800a6d <strnlen+0x29>
		n++;
  800a61:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a69:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800a6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a71:	74 0a                	je     800a7d <strnlen+0x39>
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	0f b6 00             	movzbl (%eax),%eax
  800a79:	84 c0                	test   %al,%al
  800a7b:	75 e4                	jne    800a61 <strnlen+0x1d>
	return n;
  800a7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a82:	f3 0f 1e fb          	endbr32 
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	83 ec 10             	sub    $0x10,%esp
  800a8c:	e8 d6 f5 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800a91:	05 6f 15 00 00       	add    $0x156f,%eax
	char *ret;

	ret = dst;
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a9c:	90                   	nop
  800a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa0:	8d 42 01             	lea    0x1(%edx),%eax
  800aa3:	89 45 0c             	mov    %eax,0xc(%ebp)
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8d 48 01             	lea    0x1(%eax),%ecx
  800aac:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800aaf:	0f b6 12             	movzbl (%edx),%edx
  800ab2:	88 10                	mov    %dl,(%eax)
  800ab4:	0f b6 00             	movzbl (%eax),%eax
  800ab7:	84 c0                	test   %al,%al
  800ab9:	75 e2                	jne    800a9d <strcpy+0x1b>
		/* do nothing */;
	return ret;
  800abb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800abe:	c9                   	leave  
  800abf:	c3                   	ret    

00800ac0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ac0:	f3 0f 1e fb          	endbr32 
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 10             	sub    $0x10,%esp
  800aca:	e8 98 f5 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800acf:	05 31 15 00 00       	add    $0x1531,%eax
	int len = strlen(dst);
  800ad4:	ff 75 08             	pushl  0x8(%ebp)
  800ad7:	e8 34 ff ff ff       	call   800a10 <strlen>
  800adc:	83 c4 04             	add    $0x4,%esp
  800adf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
  800ae2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	01 d0                	add    %edx,%eax
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	50                   	push   %eax
  800aee:	e8 8f ff ff ff       	call   800a82 <strcpy>
  800af3:	83 c4 08             	add    $0x8,%esp
	return dst;
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800af9:	c9                   	leave  
  800afa:	c3                   	ret    

00800afb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800afb:	f3 0f 1e fb          	endbr32 
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
  800b05:	e8 5d f5 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800b0a:	05 f6 14 00 00       	add    $0x14f6,%eax
	size_t i;
	char *ret;

	ret = dst;
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b1c:	eb 23                	jmp    800b41 <strncpy+0x46>
		*dst++ = *src;
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8d 50 01             	lea    0x1(%eax),%edx
  800b24:	89 55 08             	mov    %edx,0x8(%ebp)
  800b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2a:	0f b6 12             	movzbl (%edx),%edx
  800b2d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	0f b6 00             	movzbl (%eax),%eax
  800b35:	84 c0                	test   %al,%al
  800b37:	74 04                	je     800b3d <strncpy+0x42>
			src++;
  800b39:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
  800b3d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800b41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b44:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b47:	72 d5                	jb     800b1e <strncpy+0x23>
	}
	return ret;
  800b49:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b4e:	f3 0f 1e fb          	endbr32 
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 10             	sub    $0x10,%esp
  800b58:	e8 0a f5 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800b5d:	05 a3 14 00 00       	add    $0x14a3,%eax
	char *dst_in;

	dst_in = dst;
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b6c:	74 33                	je     800ba1 <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
  800b6e:	eb 17                	jmp    800b87 <strlcpy+0x39>
			*dst++ = *src++;
  800b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b73:	8d 42 01             	lea    0x1(%edx),%eax
  800b76:	89 45 0c             	mov    %eax,0xc(%ebp)
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8d 48 01             	lea    0x1(%eax),%ecx
  800b7f:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800b82:	0f b6 12             	movzbl (%edx),%edx
  800b85:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
  800b87:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b8f:	74 0a                	je     800b9b <strlcpy+0x4d>
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	0f b6 00             	movzbl (%eax),%eax
  800b97:	84 c0                	test   %al,%al
  800b99:	75 d5                	jne    800b70 <strlcpy+0x22>
		*dst = '\0';
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    

00800ba9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ba9:	f3 0f 1e fb          	endbr32 
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	e8 b2 f4 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800bb5:	05 4b 14 00 00       	add    $0x144b,%eax
	while (*p && *p == *q)
  800bba:	eb 08                	jmp    800bc4 <strcmp+0x1b>
		p++, q++;
  800bbc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bc0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	0f b6 00             	movzbl (%eax),%eax
  800bca:	84 c0                	test   %al,%al
  800bcc:	74 10                	je     800bde <strcmp+0x35>
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	0f b6 10             	movzbl (%eax),%edx
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	0f b6 00             	movzbl (%eax),%eax
  800bda:	38 c2                	cmp    %al,%dl
  800bdc:	74 de                	je     800bbc <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	0f b6 00             	movzbl (%eax),%eax
  800be4:	0f b6 d0             	movzbl %al,%edx
  800be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bea:	0f b6 00             	movzbl (%eax),%eax
  800bed:	0f b6 c0             	movzbl %al,%eax
  800bf0:	29 c2                	sub    %eax,%edx
  800bf2:	89 d0                	mov    %edx,%eax
}
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bf6:	f3 0f 1e fb          	endbr32 
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	e8 65 f4 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800c02:	05 fe 13 00 00       	add    $0x13fe,%eax
	while (n > 0 && *p && *p == *q)
  800c07:	eb 0c                	jmp    800c15 <strncmp+0x1f>
		n--, p++, q++;
  800c09:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800c0d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c11:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
  800c15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c19:	74 1a                	je     800c35 <strncmp+0x3f>
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	0f b6 00             	movzbl (%eax),%eax
  800c21:	84 c0                	test   %al,%al
  800c23:	74 10                	je     800c35 <strncmp+0x3f>
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	0f b6 10             	movzbl (%eax),%edx
  800c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2e:	0f b6 00             	movzbl (%eax),%eax
  800c31:	38 c2                	cmp    %al,%dl
  800c33:	74 d4                	je     800c09 <strncmp+0x13>
	if (n == 0)
  800c35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c39:	75 07                	jne    800c42 <strncmp+0x4c>
		return 0;
  800c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c40:	eb 16                	jmp    800c58 <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	0f b6 00             	movzbl (%eax),%eax
  800c48:	0f b6 d0             	movzbl %al,%edx
  800c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4e:	0f b6 00             	movzbl (%eax),%eax
  800c51:	0f b6 c0             	movzbl %al,%eax
  800c54:	29 c2                	sub    %eax,%edx
  800c56:	89 d0                	mov    %edx,%eax
}
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c5a:	f3 0f 1e fb          	endbr32 
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 04             	sub    $0x4,%esp
  800c64:	e8 fe f3 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800c69:	05 97 13 00 00       	add    $0x1397,%eax
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c74:	eb 14                	jmp    800c8a <strchr+0x30>
		if (*s == c)
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	0f b6 00             	movzbl (%eax),%eax
  800c7c:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800c7f:	75 05                	jne    800c86 <strchr+0x2c>
			return (char *) s;
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	eb 13                	jmp    800c99 <strchr+0x3f>
	for (; *s; s++)
  800c86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	0f b6 00             	movzbl (%eax),%eax
  800c90:	84 c0                	test   %al,%al
  800c92:	75 e2                	jne    800c76 <strchr+0x1c>
	return 0;
  800c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9b:	f3 0f 1e fb          	endbr32 
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	83 ec 04             	sub    $0x4,%esp
  800ca5:	e8 bd f3 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800caa:	05 56 13 00 00       	add    $0x1356,%eax
  800caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cb5:	eb 0f                	jmp    800cc6 <strfind+0x2b>
		if (*s == c)
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	0f b6 00             	movzbl (%eax),%eax
  800cbd:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800cc0:	74 10                	je     800cd2 <strfind+0x37>
	for (; *s; s++)
  800cc2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	0f b6 00             	movzbl (%eax),%eax
  800ccc:	84 c0                	test   %al,%al
  800cce:	75 e7                	jne    800cb7 <strfind+0x1c>
  800cd0:	eb 01                	jmp    800cd3 <strfind+0x38>
			break;
  800cd2:	90                   	nop
	return (char *) s;
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd8:	f3 0f 1e fb          	endbr32 
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	57                   	push   %edi
  800ce0:	e8 82 f3 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800ce5:	05 1b 13 00 00       	add    $0x131b,%eax
	char *p;

	if (n == 0)
  800cea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cee:	75 05                	jne    800cf5 <memset+0x1d>
		return v;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	eb 5c                	jmp    800d51 <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	83 e0 03             	and    $0x3,%eax
  800cfb:	85 c0                	test   %eax,%eax
  800cfd:	75 41                	jne    800d40 <memset+0x68>
  800cff:	8b 45 10             	mov    0x10(%ebp),%eax
  800d02:	83 e0 03             	and    $0x3,%eax
  800d05:	85 c0                	test   %eax,%eax
  800d07:	75 37                	jne    800d40 <memset+0x68>
		c &= 0xFF;
  800d09:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	c1 e0 18             	shl    $0x18,%eax
  800d16:	89 c2                	mov    %eax,%edx
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	c1 e0 10             	shl    $0x10,%eax
  800d1e:	09 c2                	or     %eax,%edx
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	c1 e0 08             	shl    $0x8,%eax
  800d26:	09 d0                	or     %edx,%eax
  800d28:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2e:	c1 e8 02             	shr    $0x2,%eax
  800d31:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
  800d33:	8b 55 08             	mov    0x8(%ebp),%edx
  800d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d39:	89 d7                	mov    %edx,%edi
  800d3b:	fc                   	cld    
  800d3c:	f3 ab                	rep stos %eax,%es:(%edi)
  800d3e:	eb 0e                	jmp    800d4e <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d49:	89 d7                	mov    %edx,%edi
  800d4b:	fc                   	cld    
  800d4c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d54:	f3 0f 1e fb          	endbr32 
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	57                   	push   %edi
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 10             	sub    $0x10,%esp
  800d61:	e8 01 f3 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800d66:	05 9a 12 00 00       	add    $0x129a,%eax
	const char *s;
	char *d;

	s = src;
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
  800d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d7a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d7d:	73 6d                	jae    800dec <memmove+0x98>
  800d7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d82:	8b 45 10             	mov    0x10(%ebp),%eax
  800d85:	01 d0                	add    %edx,%eax
  800d87:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  800d8a:	73 60                	jae    800dec <memmove+0x98>
		s += n;
  800d8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8f:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
  800d92:	8b 45 10             	mov    0x10(%ebp),%eax
  800d95:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d9b:	83 e0 03             	and    $0x3,%eax
  800d9e:	85 c0                	test   %eax,%eax
  800da0:	75 2f                	jne    800dd1 <memmove+0x7d>
  800da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da5:	83 e0 03             	and    $0x3,%eax
  800da8:	85 c0                	test   %eax,%eax
  800daa:	75 25                	jne    800dd1 <memmove+0x7d>
  800dac:	8b 45 10             	mov    0x10(%ebp),%eax
  800daf:	83 e0 03             	and    $0x3,%eax
  800db2:	85 c0                	test   %eax,%eax
  800db4:	75 1b                	jne    800dd1 <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db9:	83 e8 04             	sub    $0x4,%eax
  800dbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800dbf:	83 ea 04             	sub    $0x4,%edx
  800dc2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800dc5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800dc8:	89 c7                	mov    %eax,%edi
  800dca:	89 d6                	mov    %edx,%esi
  800dcc:	fd                   	std    
  800dcd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dcf:	eb 18                	jmp    800de9 <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dda:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
  800ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  800de0:	89 d7                	mov    %edx,%edi
  800de2:	89 de                	mov    %ebx,%esi
  800de4:	89 c1                	mov    %eax,%ecx
  800de6:	fd                   	std    
  800de7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800de9:	fc                   	cld    
  800dea:	eb 45                	jmp    800e31 <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800def:	83 e0 03             	and    $0x3,%eax
  800df2:	85 c0                	test   %eax,%eax
  800df4:	75 2b                	jne    800e21 <memmove+0xcd>
  800df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df9:	83 e0 03             	and    $0x3,%eax
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	75 21                	jne    800e21 <memmove+0xcd>
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	83 e0 03             	and    $0x3,%eax
  800e06:	85 c0                	test   %eax,%eax
  800e08:	75 17                	jne    800e21 <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0d:	c1 e8 02             	shr    $0x2,%eax
  800e10:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
  800e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e18:	89 c7                	mov    %eax,%edi
  800e1a:	89 d6                	mov    %edx,%esi
  800e1c:	fc                   	cld    
  800e1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e1f:	eb 10                	jmp    800e31 <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
  800e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e27:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e2a:	89 c7                	mov    %eax,%edi
  800e2c:	89 d6                	mov    %edx,%esi
  800e2e:	fc                   	cld    
  800e2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e34:	83 c4 10             	add    $0x10,%esp
  800e37:	5b                   	pop    %ebx
  800e38:	5e                   	pop    %esi
  800e39:	5f                   	pop    %edi
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e3c:	f3 0f 1e fb          	endbr32 
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	e8 1f f2 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800e48:	05 b8 11 00 00       	add    $0x11b8,%eax
	return memmove(dst, src, n);
  800e4d:	ff 75 10             	pushl  0x10(%ebp)
  800e50:	ff 75 0c             	pushl  0xc(%ebp)
  800e53:	ff 75 08             	pushl  0x8(%ebp)
  800e56:	e8 f9 fe ff ff       	call   800d54 <memmove>
  800e5b:	83 c4 0c             	add    $0xc,%esp
}
  800e5e:	c9                   	leave  
  800e5f:	c3                   	ret    

00800e60 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e60:	f3 0f 1e fb          	endbr32 
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 10             	sub    $0x10,%esp
  800e6a:	e8 f8 f1 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800e6f:	05 91 11 00 00       	add    $0x1191,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e80:	eb 30                	jmp    800eb2 <memcmp+0x52>
		if (*s1 != *s2)
  800e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e85:	0f b6 10             	movzbl (%eax),%edx
  800e88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8b:	0f b6 00             	movzbl (%eax),%eax
  800e8e:	38 c2                	cmp    %al,%dl
  800e90:	74 18                	je     800eaa <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
  800e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e95:	0f b6 00             	movzbl (%eax),%eax
  800e98:	0f b6 d0             	movzbl %al,%edx
  800e9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9e:	0f b6 00             	movzbl (%eax),%eax
  800ea1:	0f b6 c0             	movzbl %al,%eax
  800ea4:	29 c2                	sub    %eax,%edx
  800ea6:	89 d0                	mov    %edx,%eax
  800ea8:	eb 1a                	jmp    800ec4 <memcmp+0x64>
		s1++, s2++;
  800eaa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800eae:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
  800eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebb:	85 c0                	test   %eax,%eax
  800ebd:	75 c3                	jne    800e82 <memcmp+0x22>
	}

	return 0;
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ec6:	f3 0f 1e fb          	endbr32 
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
  800ed0:	e8 92 f1 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800ed5:	05 2b 11 00 00       	add    $0x112b,%eax
	const void *ends = (const char *) s + n;
  800eda:	8b 55 08             	mov    0x8(%ebp),%edx
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee5:	eb 11                	jmp    800ef8 <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	0f b6 00             	movzbl (%eax),%eax
  800eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef0:	38 d0                	cmp    %dl,%al
  800ef2:	74 0e                	je     800f02 <memfind+0x3c>
	for (; s < ends; s++)
  800ef4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efe:	72 e7                	jb     800ee7 <memfind+0x21>
  800f00:	eb 01                	jmp    800f03 <memfind+0x3d>
			break;
  800f02:	90                   	nop
	return (void *) s;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f08:	f3 0f 1e fb          	endbr32 
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 10             	sub    $0x10,%esp
  800f12:	e8 50 f1 ff ff       	call   800067 <__x86.get_pc_thunk.ax>
  800f17:	05 e9 10 00 00       	add    $0x10e9,%eax
	int neg = 0;
  800f1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f23:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2a:	eb 04                	jmp    800f30 <strtol+0x28>
		s++;
  800f2c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	0f b6 00             	movzbl (%eax),%eax
  800f36:	3c 20                	cmp    $0x20,%al
  800f38:	74 f2                	je     800f2c <strtol+0x24>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	0f b6 00             	movzbl (%eax),%eax
  800f40:	3c 09                	cmp    $0x9,%al
  800f42:	74 e8                	je     800f2c <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	0f b6 00             	movzbl (%eax),%eax
  800f4a:	3c 2b                	cmp    $0x2b,%al
  800f4c:	75 06                	jne    800f54 <strtol+0x4c>
		s++;
  800f4e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f52:	eb 15                	jmp    800f69 <strtol+0x61>
	else if (*s == '-')
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	0f b6 00             	movzbl (%eax),%eax
  800f5a:	3c 2d                	cmp    $0x2d,%al
  800f5c:	75 0b                	jne    800f69 <strtol+0x61>
		s++, neg = 1;
  800f5e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f62:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	74 06                	je     800f75 <strtol+0x6d>
  800f6f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f73:	75 24                	jne    800f99 <strtol+0x91>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	0f b6 00             	movzbl (%eax),%eax
  800f7b:	3c 30                	cmp    $0x30,%al
  800f7d:	75 1a                	jne    800f99 <strtol+0x91>
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	83 c0 01             	add    $0x1,%eax
  800f85:	0f b6 00             	movzbl (%eax),%eax
  800f88:	3c 78                	cmp    $0x78,%al
  800f8a:	75 0d                	jne    800f99 <strtol+0x91>
		s += 2, base = 16;
  800f8c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f90:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f97:	eb 2a                	jmp    800fc3 <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
  800f99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9d:	75 17                	jne    800fb6 <strtol+0xae>
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	0f b6 00             	movzbl (%eax),%eax
  800fa5:	3c 30                	cmp    $0x30,%al
  800fa7:	75 0d                	jne    800fb6 <strtol+0xae>
		s++, base = 8;
  800fa9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fad:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb4:	eb 0d                	jmp    800fc3 <strtol+0xbb>
	else if (base == 0)
  800fb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fba:	75 07                	jne    800fc3 <strtol+0xbb>
		base = 10;
  800fbc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	0f b6 00             	movzbl (%eax),%eax
  800fc9:	3c 2f                	cmp    $0x2f,%al
  800fcb:	7e 1b                	jle    800fe8 <strtol+0xe0>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	0f b6 00             	movzbl (%eax),%eax
  800fd3:	3c 39                	cmp    $0x39,%al
  800fd5:	7f 11                	jg     800fe8 <strtol+0xe0>
			dig = *s - '0';
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	0f b6 00             	movzbl (%eax),%eax
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 30             	sub    $0x30,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe6:	eb 48                	jmp    801030 <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	0f b6 00             	movzbl (%eax),%eax
  800fee:	3c 60                	cmp    $0x60,%al
  800ff0:	7e 1b                	jle    80100d <strtol+0x105>
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	0f b6 00             	movzbl (%eax),%eax
  800ff8:	3c 7a                	cmp    $0x7a,%al
  800ffa:	7f 11                	jg     80100d <strtol+0x105>
			dig = *s - 'a' + 10;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	0f b6 00             	movzbl (%eax),%eax
  801002:	0f be c0             	movsbl %al,%eax
  801005:	83 e8 57             	sub    $0x57,%eax
  801008:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100b:	eb 23                	jmp    801030 <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	0f b6 00             	movzbl (%eax),%eax
  801013:	3c 40                	cmp    $0x40,%al
  801015:	7e 3c                	jle    801053 <strtol+0x14b>
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	0f b6 00             	movzbl (%eax),%eax
  80101d:	3c 5a                	cmp    $0x5a,%al
  80101f:	7f 32                	jg     801053 <strtol+0x14b>
			dig = *s - 'A' + 10;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	0f b6 00             	movzbl (%eax),%eax
  801027:	0f be c0             	movsbl %al,%eax
  80102a:	83 e8 37             	sub    $0x37,%eax
  80102d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	3b 45 10             	cmp    0x10(%ebp),%eax
  801036:	7d 1a                	jge    801052 <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
  801038:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80103c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801043:	89 c2                	mov    %eax,%edx
  801045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801048:	01 d0                	add    %edx,%eax
  80104a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
  80104d:	e9 71 ff ff ff       	jmp    800fc3 <strtol+0xbb>
			break;
  801052:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
  801053:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801057:	74 08                	je     801061 <strtol+0x159>
		*endptr = (char *) s;
  801059:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105c:	8b 55 08             	mov    0x8(%ebp),%edx
  80105f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801061:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801065:	74 07                	je     80106e <strtol+0x166>
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106a:	f7 d8                	neg    %eax
  80106c:	eb 03                	jmp    801071 <strtol+0x169>
  80106e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801071:	c9                   	leave  
  801072:	c3                   	ret    
  801073:	66 90                	xchg   %ax,%ax
  801075:	66 90                	xchg   %ax,%ax
  801077:	66 90                	xchg   %ax,%ax
  801079:	66 90                	xchg   %ax,%ax
  80107b:	66 90                	xchg   %ax,%ax
  80107d:	66 90                	xchg   %ax,%ax
  80107f:	90                   	nop

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
