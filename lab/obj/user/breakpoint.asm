
obj/user/breakpoint:     file format elf32-i386


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
  80002c:	e8 1b 00 00 00       	call   80004c <libmain>
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
  80003a:	e8 09 00 00 00       	call   800048 <__x86.get_pc_thunk.ax>
  80003f:	05 c1 1f 00 00       	add    $0x1fc1,%eax
	asm volatile("int $3");
  800044:	cc                   	int3   
}
  800045:	90                   	nop
  800046:	5d                   	pop    %ebp
  800047:	c3                   	ret    

00800048 <__x86.get_pc_thunk.ax>:
  800048:	8b 04 24             	mov    (%esp),%eax
  80004b:	c3                   	ret    

0080004c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004c:	f3 0f 1e fb          	endbr32 
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	53                   	push   %ebx
  800054:	83 ec 04             	sub    $0x4,%esp
  800057:	e8 5a 00 00 00       	call   8000b6 <__x86.get_pc_thunk.bx>
  80005c:	81 c3 a4 1f 00 00    	add    $0x1fa4,%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code h(ere.
	thisenv = envs + ENVX(sys_getenvid());
  800062:	e8 76 01 00 00       	call   8001dd <sys_getenvid>
  800067:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006c:	89 c2                	mov    %eax,%edx
  80006e:	89 d0                	mov    %edx,%eax
  800070:	01 c0                	add    %eax,%eax
  800072:	01 d0                	add    %edx,%eax
  800074:	c1 e0 05             	shl    $0x5,%eax
  800077:	89 c2                	mov    %eax,%edx
  800079:	c7 c0 00 00 c0 ee    	mov    $0xeec00000,%eax
  80007f:	01 c2                	add    %eax,%edx
  800081:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  800087:	89 10                	mov    %edx,(%eax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800089:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80008d:	7e 0b                	jle    80009a <libmain+0x4e>
		binaryname = argv[0];
  80008f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800092:	8b 00                	mov    (%eax),%eax
  800094:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	ff 75 0c             	pushl  0xc(%ebp)
  8000a0:	ff 75 08             	pushl  0x8(%ebp)
  8000a3:	e8 8b ff ff ff       	call   800033 <umain>
  8000a8:	83 c4 10             	add    $0x10,%esp

	// exit gracefully
	exit();
  8000ab:	e8 0a 00 00 00       	call   8000ba <exit>
}
  8000b0:	90                   	nop
  8000b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b4:	c9                   	leave  
  8000b5:	c3                   	ret    

008000b6 <__x86.get_pc_thunk.bx>:
  8000b6:	8b 1c 24             	mov    (%esp),%ebx
  8000b9:	c3                   	ret    

008000ba <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ba:	f3 0f 1e fb          	endbr32 
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	53                   	push   %ebx
  8000c2:	83 ec 04             	sub    $0x4,%esp
  8000c5:	e8 7e ff ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  8000ca:	05 36 1f 00 00       	add    $0x1f36,%eax
	sys_env_destroy(0);
  8000cf:	83 ec 0c             	sub    $0xc,%esp
  8000d2:	6a 00                	push   $0x0
  8000d4:	89 c3                	mov    %eax,%ebx
  8000d6:	e8 d1 00 00 00       	call   8001ac <sys_env_destroy>
  8000db:	83 c4 10             	add    $0x10,%esp
}
  8000de:	90                   	nop
  8000df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e2:	c9                   	leave  
  8000e3:	c3                   	ret    

008000e4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	57                   	push   %edi
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	83 ec 2c             	sub    $0x2c,%esp
  8000ed:	e8 c4 ff ff ff       	call   8000b6 <__x86.get_pc_thunk.bx>
  8000f2:	81 c3 0e 1f 00 00    	add    $0x1f0e,%ebx
  8000f8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8000fe:	8b 55 10             	mov    0x10(%ebp),%edx
  800101:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800104:	8b 5d 18             	mov    0x18(%ebp),%ebx
  800107:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  80010a:	8b 75 20             	mov    0x20(%ebp),%esi
  80010d:	cd 30                	int    $0x30
  80010f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800112:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800116:	74 27                	je     80013f <syscall+0x5b>
  800118:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80011c:	7e 21                	jle    80013f <syscall+0x5b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	ff 75 e4             	pushl  -0x1c(%ebp)
  800124:	ff 75 08             	pushl  0x8(%ebp)
  800127:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80012a:	8d 83 ca f2 ff ff    	lea    -0xd36(%ebx),%eax
  800130:	50                   	push   %eax
  800131:	6a 23                	push   $0x23
  800133:	8d 83 e7 f2 ff ff    	lea    -0xd19(%ebx),%eax
  800139:	50                   	push   %eax
  80013a:	e8 cd 00 00 00       	call   80020c <_panic>

	return ret;
  80013f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  800142:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5f                   	pop    %edi
  800148:	5d                   	pop    %ebp
  800149:	c3                   	ret    

0080014a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80014a:	f3 0f 1e fb          	endbr32 
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	e8 ef fe ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800159:	05 a7 1e 00 00       	add    $0x1ea7,%eax
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80015e:	8b 45 08             	mov    0x8(%ebp),%eax
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	6a 00                	push   $0x0
  800166:	6a 00                	push   $0x0
  800168:	6a 00                	push   $0x0
  80016a:	ff 75 0c             	pushl  0xc(%ebp)
  80016d:	50                   	push   %eax
  80016e:	6a 00                	push   $0x0
  800170:	6a 00                	push   $0x0
  800172:	e8 6d ff ff ff       	call   8000e4 <syscall>
  800177:	83 c4 20             	add    $0x20,%esp
}
  80017a:	90                   	nop
  80017b:	c9                   	leave  
  80017c:	c3                   	ret    

0080017d <sys_cgetc>:

int
sys_cgetc(void)
{
  80017d:	f3 0f 1e fb          	endbr32 
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	e8 bc fe ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  80018c:	05 74 1e 00 00       	add    $0x1e74,%eax
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800191:	83 ec 04             	sub    $0x4,%esp
  800194:	6a 00                	push   $0x0
  800196:	6a 00                	push   $0x0
  800198:	6a 00                	push   $0x0
  80019a:	6a 00                	push   $0x0
  80019c:	6a 00                	push   $0x0
  80019e:	6a 00                	push   $0x0
  8001a0:	6a 01                	push   $0x1
  8001a2:	e8 3d ff ff ff       	call   8000e4 <syscall>
  8001a7:	83 c4 20             	add    $0x20,%esp
}
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001ac:	f3 0f 1e fb          	endbr32 
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	e8 8d fe ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  8001bb:	05 45 1e 00 00       	add    $0x1e45,%eax
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c3:	83 ec 04             	sub    $0x4,%esp
  8001c6:	6a 00                	push   $0x0
  8001c8:	6a 00                	push   $0x0
  8001ca:	6a 00                	push   $0x0
  8001cc:	6a 00                	push   $0x0
  8001ce:	50                   	push   %eax
  8001cf:	6a 01                	push   $0x1
  8001d1:	6a 03                	push   $0x3
  8001d3:	e8 0c ff ff ff       	call   8000e4 <syscall>
  8001d8:	83 c4 20             	add    $0x20,%esp
}
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    

008001dd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8001dd:	f3 0f 1e fb          	endbr32 
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	e8 5c fe ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  8001ec:	05 14 1e 00 00       	add    $0x1e14,%eax
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8001f1:	83 ec 04             	sub    $0x4,%esp
  8001f4:	6a 00                	push   $0x0
  8001f6:	6a 00                	push   $0x0
  8001f8:	6a 00                	push   $0x0
  8001fa:	6a 00                	push   $0x0
  8001fc:	6a 00                	push   $0x0
  8001fe:	6a 00                	push   $0x0
  800200:	6a 02                	push   $0x2
  800202:	e8 dd fe ff ff       	call   8000e4 <syscall>
  800207:	83 c4 20             	add    $0x20,%esp
}
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80020c:	f3 0f 1e fb          	endbr32 
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	56                   	push   %esi
  800214:	53                   	push   %ebx
  800215:	83 ec 10             	sub    $0x10,%esp
  800218:	e8 99 fe ff ff       	call   8000b6 <__x86.get_pc_thunk.bx>
  80021d:	81 c3 e3 1d 00 00    	add    $0x1de3,%ebx
	va_list ap;

	va_start(ap, fmt);
  800223:	8d 45 14             	lea    0x14(%ebp),%eax
  800226:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800229:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  80022f:	8b 30                	mov    (%eax),%esi
  800231:	e8 a7 ff ff ff       	call   8001dd <sys_getenvid>
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	ff 75 0c             	pushl  0xc(%ebp)
  80023c:	ff 75 08             	pushl  0x8(%ebp)
  80023f:	56                   	push   %esi
  800240:	50                   	push   %eax
  800241:	8d 83 f8 f2 ff ff    	lea    -0xd08(%ebx),%eax
  800247:	50                   	push   %eax
  800248:	e8 0f 01 00 00       	call   80035c <cprintf>
  80024d:	83 c4 20             	add    $0x20,%esp
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	50                   	push   %eax
  800257:	ff 75 10             	pushl  0x10(%ebp)
  80025a:	e8 8d 00 00 00       	call   8002ec <vcprintf>
  80025f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	8d 83 1b f3 ff ff    	lea    -0xce5(%ebx),%eax
  80026b:	50                   	push   %eax
  80026c:	e8 eb 00 00 00       	call   80035c <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800274:	cc                   	int3   
  800275:	eb fd                	jmp    800274 <_panic+0x68>

00800277 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800277:	f3 0f 1e fb          	endbr32 
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	53                   	push   %ebx
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	e8 09 01 00 00       	call   800390 <__x86.get_pc_thunk.dx>
  800287:	81 c2 79 1d 00 00    	add    $0x1d79,%edx
	b->buf[b->idx++] = ch;
  80028d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800290:	8b 00                	mov    (%eax),%eax
  800292:	8d 58 01             	lea    0x1(%eax),%ebx
  800295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800298:	89 19                	mov    %ebx,(%ecx)
  80029a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80029d:	89 cb                	mov    %ecx,%ebx
  80029f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a2:	88 5c 01 08          	mov    %bl,0x8(%ecx,%eax,1)
	if (b->idx == 256-1) {
  8002a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a9:	8b 00                	mov    (%eax),%eax
  8002ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b0:	75 25                	jne    8002d7 <putch+0x60>
		sys_cputs(b->buf, b->idx);
  8002b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 c1                	mov    %eax,%ecx
  8002b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bc:	83 c0 08             	add    $0x8,%eax
  8002bf:	83 ec 08             	sub    $0x8,%esp
  8002c2:	51                   	push   %ecx
  8002c3:	50                   	push   %eax
  8002c4:	89 d3                	mov    %edx,%ebx
  8002c6:	e8 7f fe ff ff       	call   80014a <sys_cputs>
  8002cb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002da:	8b 40 04             	mov    0x4(%eax),%eax
  8002dd:	8d 50 01             	lea    0x1(%eax),%edx
  8002e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002e6:	90                   	nop
  8002e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ec:	f3 0f 1e fb          	endbr32 
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	53                   	push   %ebx
  8002f4:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8002fa:	e8 b7 fd ff ff       	call   8000b6 <__x86.get_pc_thunk.bx>
  8002ff:	81 c3 01 1d 00 00    	add    $0x1d01,%ebx
	struct printbuf b;

	b.idx = 0;
  800305:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80030c:	00 00 00 
	b.cnt = 0;
  80030f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800316:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800319:	ff 75 0c             	pushl  0xc(%ebp)
  80031c:	ff 75 08             	pushl  0x8(%ebp)
  80031f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800325:	50                   	push   %eax
  800326:	8d 83 77 e2 ff ff    	lea    -0x1d89(%ebx),%eax
  80032c:	50                   	push   %eax
  80032d:	e8 e3 01 00 00       	call   800515 <vprintfmt>
  800332:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800335:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	50                   	push   %eax
  80033f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800345:	83 c0 08             	add    $0x8,%eax
  800348:	50                   	push   %eax
  800349:	e8 fc fd ff ff       	call   80014a <sys_cputs>
  80034e:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800351:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80035c:	f3 0f 1e fb          	endbr32 
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	83 ec 18             	sub    $0x18,%esp
  800366:	e8 dd fc ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  80036b:	05 95 1c 00 00       	add    $0x1c95,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800370:	8d 45 0c             	lea    0xc(%ebp),%eax
  800373:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
  800376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800379:	83 ec 08             	sub    $0x8,%esp
  80037c:	50                   	push   %eax
  80037d:	ff 75 08             	pushl  0x8(%ebp)
  800380:	e8 67 ff ff ff       	call   8002ec <vcprintf>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
  80038b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <__x86.get_pc_thunk.dx>:
  800390:	8b 14 24             	mov    (%esp),%edx
  800393:	c3                   	ret    

00800394 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800394:	f3 0f 1e fb          	endbr32 
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	57                   	push   %edi
  80039c:	56                   	push   %esi
  80039d:	53                   	push   %ebx
  80039e:	83 ec 1c             	sub    $0x1c,%esp
  8003a1:	e8 43 06 00 00       	call   8009e9 <__x86.get_pc_thunk.si>
  8003a6:	81 c6 5a 1c 00 00    	add    $0x1c5a,%esi
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003c3:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8003c6:	19 d1                	sbb    %edx,%ecx
  8003c8:	72 4d                	jb     800417 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ca:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003cd:	8d 78 ff             	lea    -0x1(%eax),%edi
  8003d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d8:	52                   	push   %edx
  8003d9:	50                   	push   %eax
  8003da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e0:	89 f3                	mov    %esi,%ebx
  8003e2:	e8 79 0c 00 00       	call   801060 <__udivdi3>
  8003e7:	83 c4 10             	add    $0x10,%esp
  8003ea:	83 ec 04             	sub    $0x4,%esp
  8003ed:	ff 75 20             	pushl  0x20(%ebp)
  8003f0:	57                   	push   %edi
  8003f1:	ff 75 18             	pushl  0x18(%ebp)
  8003f4:	52                   	push   %edx
  8003f5:	50                   	push   %eax
  8003f6:	ff 75 0c             	pushl  0xc(%ebp)
  8003f9:	ff 75 08             	pushl  0x8(%ebp)
  8003fc:	e8 93 ff ff ff       	call   800394 <printnum>
  800401:	83 c4 20             	add    $0x20,%esp
  800404:	eb 1b                	jmp    800421 <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	ff 75 20             	pushl  0x20(%ebp)
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	ff d0                	call   *%eax
  800414:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800417:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  80041b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80041f:	7f e5                	jg     800406 <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800421:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800424:	bb 00 00 00 00       	mov    $0x0,%ebx
  800429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80042f:	53                   	push   %ebx
  800430:	51                   	push   %ecx
  800431:	52                   	push   %edx
  800432:	50                   	push   %eax
  800433:	89 f3                	mov    %esi,%ebx
  800435:	e8 36 0d 00 00       	call   801170 <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	8d 8e 89 f3 ff ff    	lea    -0xc77(%esi),%ecx
  800443:	01 c8                	add    %ecx,%eax
  800445:	0f b6 00             	movzbl (%eax),%eax
  800448:	0f be c0             	movsbl %al,%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	ff 75 0c             	pushl  0xc(%ebp)
  800451:	50                   	push   %eax
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	ff d0                	call   *%eax
  800457:	83 c4 10             	add    $0x10,%esp
}
  80045a:	90                   	nop
  80045b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80045e:	5b                   	pop    %ebx
  80045f:	5e                   	pop    %esi
  800460:	5f                   	pop    %edi
  800461:	5d                   	pop    %ebp
  800462:	c3                   	ret    

00800463 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800463:	f3 0f 1e fb          	endbr32 
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	e8 d9 fb ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  80046f:	05 91 1b 00 00       	add    $0x1b91,%eax
	if (lflag >= 2)
  800474:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800478:	7e 14                	jle    80048e <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	8d 48 08             	lea    0x8(%eax),%ecx
  800482:	8b 55 08             	mov    0x8(%ebp),%edx
  800485:	89 0a                	mov    %ecx,(%edx)
  800487:	8b 50 04             	mov    0x4(%eax),%edx
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	eb 30                	jmp    8004be <getuint+0x5b>
	else if (lflag)
  80048e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800492:	74 16                	je     8004aa <getuint+0x47>
		return va_arg(*ap, unsigned long);
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	8d 48 04             	lea    0x4(%eax),%ecx
  80049c:	8b 55 08             	mov    0x8(%ebp),%edx
  80049f:	89 0a                	mov    %ecx,(%edx)
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a8:	eb 14                	jmp    8004be <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	8d 48 04             	lea    0x4(%eax),%ecx
  8004b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b5:	89 0a                	mov    %ecx,(%edx)
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004be:	5d                   	pop    %ebp
  8004bf:	c3                   	ret    

008004c0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c0:	f3 0f 1e fb          	endbr32 
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	e8 7c fb ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  8004cc:	05 34 1b 00 00       	add    $0x1b34,%eax
	if (lflag >= 2)
  8004d1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d5:	7e 14                	jle    8004eb <getint+0x2b>
		return va_arg(*ap, long long);
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	8b 00                	mov    (%eax),%eax
  8004dc:	8d 48 08             	lea    0x8(%eax),%ecx
  8004df:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e2:	89 0a                	mov    %ecx,(%edx)
  8004e4:	8b 50 04             	mov    0x4(%eax),%edx
  8004e7:	8b 00                	mov    (%eax),%eax
  8004e9:	eb 28                	jmp    800513 <getint+0x53>
	else if (lflag)
  8004eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ef:	74 12                	je     800503 <getint+0x43>
		return va_arg(*ap, long);
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	8d 48 04             	lea    0x4(%eax),%ecx
  8004f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004fc:	89 0a                	mov    %ecx,(%edx)
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	99                   	cltd   
  800501:	eb 10                	jmp    800513 <getint+0x53>
	else
		return va_arg(*ap, int);
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	8d 48 04             	lea    0x4(%eax),%ecx
  80050b:	8b 55 08             	mov    0x8(%ebp),%edx
  80050e:	89 0a                	mov    %ecx,(%edx)
  800510:	8b 00                	mov    (%eax),%eax
  800512:	99                   	cltd   
}
  800513:	5d                   	pop    %ebp
  800514:	c3                   	ret    

00800515 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800515:	f3 0f 1e fb          	endbr32 
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	57                   	push   %edi
  80051d:	56                   	push   %esi
  80051e:	53                   	push   %ebx
  80051f:	83 ec 2c             	sub    $0x2c,%esp
  800522:	e8 c6 04 00 00       	call   8009ed <__x86.get_pc_thunk.di>
  800527:	81 c7 d9 1a 00 00    	add    $0x1ad9,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052d:	eb 17                	jmp    800546 <vprintfmt+0x31>
			if (ch == '\0')
  80052f:	85 db                	test   %ebx,%ebx
  800531:	0f 84 96 03 00 00    	je     8008cd <.L20+0x2d>
				return;
			putch(ch, putdat);
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	ff 75 0c             	pushl  0xc(%ebp)
  80053d:	53                   	push   %ebx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	ff d0                	call   *%eax
  800543:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800546:	8b 45 10             	mov    0x10(%ebp),%eax
  800549:	8d 50 01             	lea    0x1(%eax),%edx
  80054c:	89 55 10             	mov    %edx,0x10(%ebp)
  80054f:	0f b6 00             	movzbl (%eax),%eax
  800552:	0f b6 d8             	movzbl %al,%ebx
  800555:	83 fb 25             	cmp    $0x25,%ebx
  800558:	75 d5                	jne    80052f <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
  80055a:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
  80055e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
  800565:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
  80056c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
  800573:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	8b 45 10             	mov    0x10(%ebp),%eax
  80057d:	8d 50 01             	lea    0x1(%eax),%edx
  800580:	89 55 10             	mov    %edx,0x10(%ebp)
  800583:	0f b6 00             	movzbl (%eax),%eax
  800586:	0f b6 d8             	movzbl %al,%ebx
  800589:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80058c:	83 f8 55             	cmp    $0x55,%eax
  80058f:	0f 87 0b 03 00 00    	ja     8008a0 <.L20>
  800595:	c1 e0 02             	shl    $0x2,%eax
  800598:	8b 84 38 b0 f3 ff ff 	mov    -0xc50(%eax,%edi,1),%eax
  80059f:	01 f8                	add    %edi,%eax
  8005a1:	3e ff e0             	notrack jmp *%eax

008005a4 <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a4:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
  8005a8:	eb d0                	jmp    80057a <vprintfmt+0x65>

008005aa <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005aa:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
  8005ae:	eb ca                	jmp    80057a <vprintfmt+0x65>

008005b0 <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
  8005b7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ba:	89 d0                	mov    %edx,%eax
  8005bc:	c1 e0 02             	shl    $0x2,%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	01 c0                	add    %eax,%eax
  8005c3:	01 d8                	add    %ebx,%eax
  8005c5:	83 e8 30             	sub    $0x30,%eax
  8005c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
  8005cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ce:	0f b6 00             	movzbl (%eax),%eax
  8005d1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005d4:	83 fb 2f             	cmp    $0x2f,%ebx
  8005d7:	7e 39                	jle    800612 <.L37+0xc>
  8005d9:	83 fb 39             	cmp    $0x39,%ebx
  8005dc:	7f 34                	jg     800612 <.L37+0xc>
			for (precision = 0; ; ++fmt) {
  8005de:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
  8005e2:	eb d3                	jmp    8005b7 <.L31+0x7>

008005e4 <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ea:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
  8005f2:	eb 1f                	jmp    800613 <.L37+0xd>

008005f4 <.L33>:

		case '.':
			if (width < 0)
  8005f4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005f8:	79 80                	jns    80057a <vprintfmt+0x65>
				width = 0;
  8005fa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
  800601:	e9 74 ff ff ff       	jmp    80057a <vprintfmt+0x65>

00800606 <.L37>:

		case '#':
			altflag = 1;
  800606:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
  80060d:	e9 68 ff ff ff       	jmp    80057a <vprintfmt+0x65>
			goto process_precision;
  800612:	90                   	nop

		process_precision:
			if (width < 0)
  800613:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800617:	0f 89 5d ff ff ff    	jns    80057a <vprintfmt+0x65>
				width = precision, precision = -1;
  80061d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800620:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800623:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
  80062a:	e9 4b ff ff ff       	jmp    80057a <vprintfmt+0x65>

0080062f <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80062f:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
  800633:	e9 42 ff ff ff       	jmp    80057a <vprintfmt+0x65>

00800638 <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 50 04             	lea    0x4(%eax),%edx
  80063e:	89 55 14             	mov    %edx,0x14(%ebp)
  800641:	8b 00                	mov    (%eax),%eax
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	50                   	push   %eax
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	ff d0                	call   *%eax
  80064f:	83 c4 10             	add    $0x10,%esp
			break;
  800652:	e9 71 02 00 00       	jmp    8008c8 <.L20+0x28>

00800657 <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 50 04             	lea    0x4(%eax),%edx
  80065d:	89 55 14             	mov    %edx,0x14(%ebp)
  800660:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800662:	85 db                	test   %ebx,%ebx
  800664:	79 02                	jns    800668 <.L28+0x11>
				err = -err;
  800666:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800668:	83 fb 06             	cmp    $0x6,%ebx
  80066b:	7f 0b                	jg     800678 <.L28+0x21>
  80066d:	8b b4 9f 10 00 00 00 	mov    0x10(%edi,%ebx,4),%esi
  800674:	85 f6                	test   %esi,%esi
  800676:	75 1b                	jne    800693 <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
  800678:	53                   	push   %ebx
  800679:	8d 87 9a f3 ff ff    	lea    -0xc66(%edi),%eax
  80067f:	50                   	push   %eax
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	ff 75 08             	pushl  0x8(%ebp)
  800686:	e8 4b 02 00 00       	call   8008d6 <printfmt>
  80068b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80068e:	e9 35 02 00 00       	jmp    8008c8 <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
  800693:	56                   	push   %esi
  800694:	8d 87 a3 f3 ff ff    	lea    -0xc5d(%edi),%eax
  80069a:	50                   	push   %eax
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	ff 75 08             	pushl  0x8(%ebp)
  8006a1:	e8 30 02 00 00       	call   8008d6 <printfmt>
  8006a6:	83 c4 10             	add    $0x10,%esp
			break;
  8006a9:	e9 1a 02 00 00       	jmp    8008c8 <.L20+0x28>

008006ae <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 50 04             	lea    0x4(%eax),%edx
  8006b4:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b7:	8b 30                	mov    (%eax),%esi
  8006b9:	85 f6                	test   %esi,%esi
  8006bb:	75 06                	jne    8006c3 <.L24+0x15>
				p = "(null)";
  8006bd:	8d b7 a6 f3 ff ff    	lea    -0xc5a(%edi),%esi
			if (width > 0 && padc != '-')
  8006c3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006c7:	7e 71                	jle    80073a <.L24+0x8c>
  8006c9:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  8006cd:	74 6b                	je     80073a <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	50                   	push   %eax
  8006d6:	56                   	push   %esi
  8006d7:	89 fb                	mov    %edi,%ebx
  8006d9:	e8 47 03 00 00       	call   800a25 <strnlen>
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	29 45 d4             	sub    %eax,-0x2c(%ebp)
  8006e4:	eb 17                	jmp    8006fd <.L24+0x4f>
					putch(padc, putdat);
  8006e6:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	ff 75 0c             	pushl  0xc(%ebp)
  8006f0:	50                   	push   %eax
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	ff d0                	call   *%eax
  8006f6:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f9:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  8006fd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800701:	7f e3                	jg     8006e6 <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800703:	eb 35                	jmp    80073a <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
  800705:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800709:	74 1c                	je     800727 <.L24+0x79>
  80070b:	83 fb 1f             	cmp    $0x1f,%ebx
  80070e:	7e 05                	jle    800715 <.L24+0x67>
  800710:	83 fb 7e             	cmp    $0x7e,%ebx
  800713:	7e 12                	jle    800727 <.L24+0x79>
					putch('?', putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	6a 3f                	push   $0x3f
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	ff d0                	call   *%eax
  800722:	83 c4 10             	add    $0x10,%esp
  800725:	eb 0f                	jmp    800736 <.L24+0x88>
				else
					putch(ch, putdat);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	ff 75 0c             	pushl  0xc(%ebp)
  80072d:	53                   	push   %ebx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	ff d0                	call   *%eax
  800733:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800736:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  80073a:	89 f0                	mov    %esi,%eax
  80073c:	8d 70 01             	lea    0x1(%eax),%esi
  80073f:	0f b6 00             	movzbl (%eax),%eax
  800742:	0f be d8             	movsbl %al,%ebx
  800745:	85 db                	test   %ebx,%ebx
  800747:	74 26                	je     80076f <.L24+0xc1>
  800749:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80074d:	78 b6                	js     800705 <.L24+0x57>
  80074f:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  800753:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800757:	79 ac                	jns    800705 <.L24+0x57>
			for (; width > 0; width--)
  800759:	eb 14                	jmp    80076f <.L24+0xc1>
				putch(' ', putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	ff 75 0c             	pushl  0xc(%ebp)
  800761:	6a 20                	push   $0x20
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
  80076b:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  80076f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800773:	7f e6                	jg     80075b <.L24+0xad>
			break;
  800775:	e9 4e 01 00 00       	jmp    8008c8 <.L20+0x28>

0080077a <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	ff 75 d8             	pushl  -0x28(%ebp)
  800780:	8d 45 14             	lea    0x14(%ebp),%eax
  800783:	50                   	push   %eax
  800784:	e8 37 fd ff ff       	call   8004c0 <getint>
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80078f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
  800792:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800795:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800798:	85 d2                	test   %edx,%edx
  80079a:	79 23                	jns    8007bf <.L29+0x45>
				putch('-', putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	6a 2d                	push   $0x2d
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	ff d0                	call   *%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b2:	f7 d8                	neg    %eax
  8007b4:	83 d2 00             	adc    $0x0,%edx
  8007b7:	f7 da                	neg    %edx
  8007b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007bc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
  8007bf:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007c6:	e9 9f 00 00 00       	jmp    80086a <.L21+0x1f>

008007cb <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8007d1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d4:	50                   	push   %eax
  8007d5:	e8 89 fc ff ff       	call   800463 <getuint>
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
  8007e3:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007ea:	eb 7e                	jmp    80086a <.L21+0x1f>

008007ec <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8007f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f5:	50                   	push   %eax
  8007f6:	e8 68 fc ff ff       	call   800463 <getuint>
  8007fb:	83 c4 10             	add    $0x10,%esp
  8007fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800801:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
  800804:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
  80080b:	eb 5d                	jmp    80086a <.L21+0x1f>

0080080d <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 30                	push   $0x30
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	6a 78                	push   $0x78
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8d 50 04             	lea    0x4(%eax),%edx
  800833:	89 55 14             	mov    %edx,0x14(%ebp)
  800836:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
  800838:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80083b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
  800842:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
  800849:	eb 1f                	jmp    80086a <.L21+0x1f>

0080084b <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 d8             	pushl  -0x28(%ebp)
  800851:	8d 45 14             	lea    0x14(%ebp),%eax
  800854:	50                   	push   %eax
  800855:	e8 09 fc ff ff       	call   800463 <getuint>
  80085a:	83 c4 10             	add    $0x10,%esp
  80085d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800860:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
  800863:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80086a:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  80086e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800871:	83 ec 04             	sub    $0x4,%esp
  800874:	52                   	push   %edx
  800875:	ff 75 d4             	pushl  -0x2c(%ebp)
  800878:	50                   	push   %eax
  800879:	ff 75 e4             	pushl  -0x1c(%ebp)
  80087c:	ff 75 e0             	pushl  -0x20(%ebp)
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	ff 75 08             	pushl  0x8(%ebp)
  800885:	e8 0a fb ff ff       	call   800394 <printnum>
  80088a:	83 c4 20             	add    $0x20,%esp
			break;
  80088d:	eb 39                	jmp    8008c8 <.L20+0x28>

0080088f <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	53                   	push   %ebx
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	ff d0                	call   *%eax
  80089b:	83 c4 10             	add    $0x10,%esp
			break;
  80089e:	eb 28                	jmp    8008c8 <.L20+0x28>

008008a0 <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	6a 25                	push   $0x25
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	ff d0                	call   *%eax
  8008ad:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008b4:	eb 04                	jmp    8008ba <.L20+0x1a>
  8008b6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bd:	83 e8 01             	sub    $0x1,%eax
  8008c0:	0f b6 00             	movzbl (%eax),%eax
  8008c3:	3c 25                	cmp    $0x25,%al
  8008c5:	75 ef                	jne    8008b6 <.L20+0x16>
				/* do nothing */;
			break;
  8008c7:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c8:	e9 79 fc ff ff       	jmp    800546 <vprintfmt+0x31>
				return;
  8008cd:	90                   	nop
		}
	}
}
  8008ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5f                   	pop    %edi
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008d6:	f3 0f 1e fb          	endbr32 
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	83 ec 18             	sub    $0x18,%esp
  8008e0:	e8 63 f7 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  8008e5:	05 1b 17 00 00       	add    $0x171b,%eax
	va_list ap;

	va_start(ap, fmt);
  8008ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f3:	50                   	push   %eax
  8008f4:	ff 75 10             	pushl  0x10(%ebp)
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	ff 75 08             	pushl  0x8(%ebp)
  8008fd:	e8 13 fc ff ff       	call   800515 <vprintfmt>
  800902:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800905:	90                   	nop
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800908:	f3 0f 1e fb          	endbr32 
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	e8 34 f7 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800914:	05 ec 16 00 00       	add    $0x16ec,%eax
	b->cnt++;
  800919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091c:	8b 40 08             	mov    0x8(%eax),%eax
  80091f:	8d 50 01             	lea    0x1(%eax),%edx
  800922:	8b 45 0c             	mov    0xc(%ebp),%eax
  800925:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092b:	8b 10                	mov    (%eax),%edx
  80092d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800930:	8b 40 04             	mov    0x4(%eax),%eax
  800933:	39 c2                	cmp    %eax,%edx
  800935:	73 12                	jae    800949 <sprintputch+0x41>
		*b->buf++ = ch;
  800937:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	8d 48 01             	lea    0x1(%eax),%ecx
  80093f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800942:	89 0a                	mov    %ecx,(%edx)
  800944:	8b 55 08             	mov    0x8(%ebp),%edx
  800947:	88 10                	mov    %dl,(%eax)
}
  800949:	90                   	nop
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80094c:	f3 0f 1e fb          	endbr32 
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	83 ec 18             	sub    $0x18,%esp
  800956:	e8 ed f6 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  80095b:	05 a5 16 00 00       	add    $0x16a5,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
  800960:	8b 55 08             	mov    0x8(%ebp),%edx
  800963:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800966:	8b 55 0c             	mov    0xc(%ebp),%edx
  800969:	8d 4a ff             	lea    -0x1(%edx),%ecx
  80096c:	8b 55 08             	mov    0x8(%ebp),%edx
  80096f:	01 ca                	add    %ecx,%edx
  800971:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800974:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80097b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80097f:	74 06                	je     800987 <vsnprintf+0x3b>
  800981:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800985:	7f 07                	jg     80098e <vsnprintf+0x42>
		return -E_INVAL;
  800987:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80098c:	eb 22                	jmp    8009b0 <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80098e:	ff 75 14             	pushl  0x14(%ebp)
  800991:	ff 75 10             	pushl  0x10(%ebp)
  800994:	8d 55 ec             	lea    -0x14(%ebp),%edx
  800997:	52                   	push   %edx
  800998:	8d 80 08 e9 ff ff    	lea    -0x16f8(%eax),%eax
  80099e:	50                   	push   %eax
  80099f:	e8 71 fb ff ff       	call   800515 <vprintfmt>
  8009a4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009aa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009b0:	c9                   	leave  
  8009b1:	c3                   	ret    

008009b2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b2:	f3 0f 1e fb          	endbr32 
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	83 ec 18             	sub    $0x18,%esp
  8009bc:	e8 87 f6 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  8009c1:	05 3f 16 00 00       	add    $0x163f,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	50                   	push   %eax
  8009d0:	ff 75 10             	pushl  0x10(%ebp)
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	ff 75 08             	pushl  0x8(%ebp)
  8009d9:	e8 6e ff ff ff       	call   80094c <vsnprintf>
  8009de:	83 c4 10             	add    $0x10,%esp
  8009e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
  8009e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    

008009e9 <__x86.get_pc_thunk.si>:
  8009e9:	8b 34 24             	mov    (%esp),%esi
  8009ec:	c3                   	ret    

008009ed <__x86.get_pc_thunk.di>:
  8009ed:	8b 3c 24             	mov    (%esp),%edi
  8009f0:	c3                   	ret    

008009f1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f1:	f3 0f 1e fb          	endbr32 
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	83 ec 10             	sub    $0x10,%esp
  8009fb:	e8 48 f6 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800a00:	05 00 16 00 00       	add    $0x1600,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800a05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0c:	eb 08                	jmp    800a16 <strlen+0x25>
		n++;
  800a0e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
  800a12:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	0f b6 00             	movzbl (%eax),%eax
  800a1c:	84 c0                	test   %al,%al
  800a1e:	75 ee                	jne    800a0e <strlen+0x1d>
	return n;
  800a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a23:	c9                   	leave  
  800a24:	c3                   	ret    

00800a25 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a25:	f3 0f 1e fb          	endbr32 
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	83 ec 10             	sub    $0x10,%esp
  800a2f:	e8 14 f6 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800a34:	05 cc 15 00 00       	add    $0x15cc,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a40:	eb 0c                	jmp    800a4e <strnlen+0x29>
		n++;
  800a42:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a46:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a4a:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800a4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a52:	74 0a                	je     800a5e <strnlen+0x39>
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	0f b6 00             	movzbl (%eax),%eax
  800a5a:	84 c0                	test   %al,%al
  800a5c:	75 e4                	jne    800a42 <strnlen+0x1d>
	return n;
  800a5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a61:	c9                   	leave  
  800a62:	c3                   	ret    

00800a63 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a63:	f3 0f 1e fb          	endbr32 
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	83 ec 10             	sub    $0x10,%esp
  800a6d:	e8 d6 f5 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800a72:	05 8e 15 00 00       	add    $0x158e,%eax
	char *ret;

	ret = dst;
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a7d:	90                   	nop
  800a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a81:	8d 42 01             	lea    0x1(%edx),%eax
  800a84:	89 45 0c             	mov    %eax,0xc(%ebp)
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8d:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800a90:	0f b6 12             	movzbl (%edx),%edx
  800a93:	88 10                	mov    %dl,(%eax)
  800a95:	0f b6 00             	movzbl (%eax),%eax
  800a98:	84 c0                	test   %al,%al
  800a9a:	75 e2                	jne    800a7e <strcpy+0x1b>
		/* do nothing */;
	return ret;
  800a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800aa1:	f3 0f 1e fb          	endbr32 
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	83 ec 10             	sub    $0x10,%esp
  800aab:	e8 98 f5 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800ab0:	05 50 15 00 00       	add    $0x1550,%eax
	int len = strlen(dst);
  800ab5:	ff 75 08             	pushl  0x8(%ebp)
  800ab8:	e8 34 ff ff ff       	call   8009f1 <strlen>
  800abd:	83 c4 04             	add    $0x4,%esp
  800ac0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
  800ac3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	01 d0                	add    %edx,%eax
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	50                   	push   %eax
  800acf:	e8 8f ff ff ff       	call   800a63 <strcpy>
  800ad4:	83 c4 08             	add    $0x8,%esp
	return dst;
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800adc:	f3 0f 1e fb          	endbr32 
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 10             	sub    $0x10,%esp
  800ae6:	e8 5d f5 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800aeb:	05 15 15 00 00       	add    $0x1515,%eax
	size_t i;
	char *ret;

	ret = dst;
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800af6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800afd:	eb 23                	jmp    800b22 <strncpy+0x46>
		*dst++ = *src;
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8d 50 01             	lea    0x1(%eax),%edx
  800b05:	89 55 08             	mov    %edx,0x8(%ebp)
  800b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0b:	0f b6 12             	movzbl (%edx),%edx
  800b0e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	0f b6 00             	movzbl (%eax),%eax
  800b16:	84 c0                	test   %al,%al
  800b18:	74 04                	je     800b1e <strncpy+0x42>
			src++;
  800b1a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
  800b1e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b25:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b28:	72 d5                	jb     800aff <strncpy+0x23>
	}
	return ret;
  800b2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b2f:	f3 0f 1e fb          	endbr32 
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 10             	sub    $0x10,%esp
  800b39:	e8 0a f5 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800b3e:	05 c2 14 00 00       	add    $0x14c2,%eax
	char *dst_in;

	dst_in = dst;
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b4d:	74 33                	je     800b82 <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
  800b4f:	eb 17                	jmp    800b68 <strlcpy+0x39>
			*dst++ = *src++;
  800b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b54:	8d 42 01             	lea    0x1(%edx),%eax
  800b57:	89 45 0c             	mov    %eax,0xc(%ebp)
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b60:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800b63:	0f b6 12             	movzbl (%edx),%edx
  800b66:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
  800b68:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b70:	74 0a                	je     800b7c <strlcpy+0x4d>
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	0f b6 00             	movzbl (%eax),%eax
  800b78:	84 c0                	test   %al,%al
  800b7a:	75 d5                	jne    800b51 <strlcpy+0x22>
		*dst = '\0';
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
  800b88:	c9                   	leave  
  800b89:	c3                   	ret    

00800b8a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b8a:	f3 0f 1e fb          	endbr32 
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	e8 b2 f4 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800b96:	05 6a 14 00 00       	add    $0x146a,%eax
	while (*p && *p == *q)
  800b9b:	eb 08                	jmp    800ba5 <strcmp+0x1b>
		p++, q++;
  800b9d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ba1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	0f b6 00             	movzbl (%eax),%eax
  800bab:	84 c0                	test   %al,%al
  800bad:	74 10                	je     800bbf <strcmp+0x35>
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	0f b6 10             	movzbl (%eax),%edx
  800bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb8:	0f b6 00             	movzbl (%eax),%eax
  800bbb:	38 c2                	cmp    %al,%dl
  800bbd:	74 de                	je     800b9d <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	0f b6 00             	movzbl (%eax),%eax
  800bc5:	0f b6 d0             	movzbl %al,%edx
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	0f b6 00             	movzbl (%eax),%eax
  800bce:	0f b6 c0             	movzbl %al,%eax
  800bd1:	29 c2                	sub    %eax,%edx
  800bd3:	89 d0                	mov    %edx,%eax
}
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bd7:	f3 0f 1e fb          	endbr32 
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	e8 65 f4 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800be3:	05 1d 14 00 00       	add    $0x141d,%eax
	while (n > 0 && *p && *p == *q)
  800be8:	eb 0c                	jmp    800bf6 <strncmp+0x1f>
		n--, p++, q++;
  800bea:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800bee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bf2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
  800bf6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bfa:	74 1a                	je     800c16 <strncmp+0x3f>
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	0f b6 00             	movzbl (%eax),%eax
  800c02:	84 c0                	test   %al,%al
  800c04:	74 10                	je     800c16 <strncmp+0x3f>
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	0f b6 10             	movzbl (%eax),%edx
  800c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0f:	0f b6 00             	movzbl (%eax),%eax
  800c12:	38 c2                	cmp    %al,%dl
  800c14:	74 d4                	je     800bea <strncmp+0x13>
	if (n == 0)
  800c16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c1a:	75 07                	jne    800c23 <strncmp+0x4c>
		return 0;
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c21:	eb 16                	jmp    800c39 <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	0f b6 00             	movzbl (%eax),%eax
  800c29:	0f b6 d0             	movzbl %al,%edx
  800c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2f:	0f b6 00             	movzbl (%eax),%eax
  800c32:	0f b6 c0             	movzbl %al,%eax
  800c35:	29 c2                	sub    %eax,%edx
  800c37:	89 d0                	mov    %edx,%eax
}
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c3b:	f3 0f 1e fb          	endbr32 
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 04             	sub    $0x4,%esp
  800c45:	e8 fe f3 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800c4a:	05 b6 13 00 00       	add    $0x13b6,%eax
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c55:	eb 14                	jmp    800c6b <strchr+0x30>
		if (*s == c)
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	0f b6 00             	movzbl (%eax),%eax
  800c5d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800c60:	75 05                	jne    800c67 <strchr+0x2c>
			return (char *) s;
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	eb 13                	jmp    800c7a <strchr+0x3f>
	for (; *s; s++)
  800c67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	0f b6 00             	movzbl (%eax),%eax
  800c71:	84 c0                	test   %al,%al
  800c73:	75 e2                	jne    800c57 <strchr+0x1c>
	return 0;
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7a:	c9                   	leave  
  800c7b:	c3                   	ret    

00800c7c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c7c:	f3 0f 1e fb          	endbr32 
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	83 ec 04             	sub    $0x4,%esp
  800c86:	e8 bd f3 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800c8b:	05 75 13 00 00       	add    $0x1375,%eax
  800c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c93:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c96:	eb 0f                	jmp    800ca7 <strfind+0x2b>
		if (*s == c)
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	0f b6 00             	movzbl (%eax),%eax
  800c9e:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800ca1:	74 10                	je     800cb3 <strfind+0x37>
	for (; *s; s++)
  800ca3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	0f b6 00             	movzbl (%eax),%eax
  800cad:	84 c0                	test   %al,%al
  800caf:	75 e7                	jne    800c98 <strfind+0x1c>
  800cb1:	eb 01                	jmp    800cb4 <strfind+0x38>
			break;
  800cb3:	90                   	nop
	return (char *) s;
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cb9:	f3 0f 1e fb          	endbr32 
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	57                   	push   %edi
  800cc1:	e8 82 f3 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800cc6:	05 3a 13 00 00       	add    $0x133a,%eax
	char *p;

	if (n == 0)
  800ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccf:	75 05                	jne    800cd6 <memset+0x1d>
		return v;
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	eb 5c                	jmp    800d32 <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	83 e0 03             	and    $0x3,%eax
  800cdc:	85 c0                	test   %eax,%eax
  800cde:	75 41                	jne    800d21 <memset+0x68>
  800ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce3:	83 e0 03             	and    $0x3,%eax
  800ce6:	85 c0                	test   %eax,%eax
  800ce8:	75 37                	jne    800d21 <memset+0x68>
		c &= 0xFF;
  800cea:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf4:	c1 e0 18             	shl    $0x18,%eax
  800cf7:	89 c2                	mov    %eax,%edx
  800cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfc:	c1 e0 10             	shl    $0x10,%eax
  800cff:	09 c2                	or     %eax,%edx
  800d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d04:	c1 e0 08             	shl    $0x8,%eax
  800d07:	09 d0                	or     %edx,%eax
  800d09:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0f:	c1 e8 02             	shr    $0x2,%eax
  800d12:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	89 d7                	mov    %edx,%edi
  800d1c:	fc                   	cld    
  800d1d:	f3 ab                	rep stos %eax,%es:(%edi)
  800d1f:	eb 0e                	jmp    800d2f <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d27:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d2a:	89 d7                	mov    %edx,%edi
  800d2c:	fc                   	cld    
  800d2d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d35:	f3 0f 1e fb          	endbr32 
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 10             	sub    $0x10,%esp
  800d42:	e8 01 f3 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800d47:	05 b9 12 00 00       	add    $0x12b9,%eax
	const char *s;
	char *d;

	s = src;
  800d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
  800d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d5e:	73 6d                	jae    800dcd <memmove+0x98>
  800d60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	01 d0                	add    %edx,%eax
  800d68:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  800d6b:	73 60                	jae    800dcd <memmove+0x98>
		s += n;
  800d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d70:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
  800d73:	8b 45 10             	mov    0x10(%ebp),%eax
  800d76:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d7c:	83 e0 03             	and    $0x3,%eax
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	75 2f                	jne    800db2 <memmove+0x7d>
  800d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d86:	83 e0 03             	and    $0x3,%eax
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	75 25                	jne    800db2 <memmove+0x7d>
  800d8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d90:	83 e0 03             	and    $0x3,%eax
  800d93:	85 c0                	test   %eax,%eax
  800d95:	75 1b                	jne    800db2 <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9a:	83 e8 04             	sub    $0x4,%eax
  800d9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800da0:	83 ea 04             	sub    $0x4,%edx
  800da3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800da6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800da9:	89 c7                	mov    %eax,%edi
  800dab:	89 d6                	mov    %edx,%esi
  800dad:	fd                   	std    
  800dae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800db0:	eb 18                	jmp    800dca <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dbb:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
  800dbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc1:	89 d7                	mov    %edx,%edi
  800dc3:	89 de                	mov    %ebx,%esi
  800dc5:	89 c1                	mov    %eax,%ecx
  800dc7:	fd                   	std    
  800dc8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dca:	fc                   	cld    
  800dcb:	eb 45                	jmp    800e12 <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd0:	83 e0 03             	and    $0x3,%eax
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	75 2b                	jne    800e02 <memmove+0xcd>
  800dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dda:	83 e0 03             	and    $0x3,%eax
  800ddd:	85 c0                	test   %eax,%eax
  800ddf:	75 21                	jne    800e02 <memmove+0xcd>
  800de1:	8b 45 10             	mov    0x10(%ebp),%eax
  800de4:	83 e0 03             	and    $0x3,%eax
  800de7:	85 c0                	test   %eax,%eax
  800de9:	75 17                	jne    800e02 <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	c1 e8 02             	shr    $0x2,%eax
  800df1:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
  800df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800df9:	89 c7                	mov    %eax,%edi
  800dfb:	89 d6                	mov    %edx,%esi
  800dfd:	fc                   	cld    
  800dfe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e00:	eb 10                	jmp    800e12 <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
  800e02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e0b:	89 c7                	mov    %eax,%edi
  800e0d:	89 d6                	mov    %edx,%esi
  800e0f:	fc                   	cld    
  800e10:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e15:	83 c4 10             	add    $0x10,%esp
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    

00800e1d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e1d:	f3 0f 1e fb          	endbr32 
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	e8 1f f2 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800e29:	05 d7 11 00 00       	add    $0x11d7,%eax
	return memmove(dst, src, n);
  800e2e:	ff 75 10             	pushl  0x10(%ebp)
  800e31:	ff 75 0c             	pushl  0xc(%ebp)
  800e34:	ff 75 08             	pushl  0x8(%ebp)
  800e37:	e8 f9 fe ff ff       	call   800d35 <memmove>
  800e3c:	83 c4 0c             	add    $0xc,%esp
}
  800e3f:	c9                   	leave  
  800e40:	c3                   	ret    

00800e41 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e41:	f3 0f 1e fb          	endbr32 
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 10             	sub    $0x10,%esp
  800e4b:	e8 f8 f1 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800e50:	05 b0 11 00 00       	add    $0x11b0,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e61:	eb 30                	jmp    800e93 <memcmp+0x52>
		if (*s1 != *s2)
  800e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e66:	0f b6 10             	movzbl (%eax),%edx
  800e69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6c:	0f b6 00             	movzbl (%eax),%eax
  800e6f:	38 c2                	cmp    %al,%dl
  800e71:	74 18                	je     800e8b <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e76:	0f b6 00             	movzbl (%eax),%eax
  800e79:	0f b6 d0             	movzbl %al,%edx
  800e7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7f:	0f b6 00             	movzbl (%eax),%eax
  800e82:	0f b6 c0             	movzbl %al,%eax
  800e85:	29 c2                	sub    %eax,%edx
  800e87:	89 d0                	mov    %edx,%eax
  800e89:	eb 1a                	jmp    800ea5 <memcmp+0x64>
		s1++, s2++;
  800e8b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800e8f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
  800e93:	8b 45 10             	mov    0x10(%ebp),%eax
  800e96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e99:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	75 c3                	jne    800e63 <memcmp+0x22>
	}

	return 0;
  800ea0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea5:	c9                   	leave  
  800ea6:	c3                   	ret    

00800ea7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ea7:	f3 0f 1e fb          	endbr32 
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	83 ec 10             	sub    $0x10,%esp
  800eb1:	e8 92 f1 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800eb6:	05 4a 11 00 00       	add    $0x114a,%eax
	const void *ends = (const char *) s + n;
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	01 d0                	add    %edx,%eax
  800ec3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ec6:	eb 11                	jmp    800ed9 <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	0f b6 00             	movzbl (%eax),%eax
  800ece:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed1:	38 d0                	cmp    %dl,%al
  800ed3:	74 0e                	je     800ee3 <memfind+0x3c>
	for (; s < ends; s++)
  800ed5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800edf:	72 e7                	jb     800ec8 <memfind+0x21>
  800ee1:	eb 01                	jmp    800ee4 <memfind+0x3d>
			break;
  800ee3:	90                   	nop
	return (void *) s;
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ee9:	f3 0f 1e fb          	endbr32 
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 10             	sub    $0x10,%esp
  800ef3:	e8 50 f1 ff ff       	call   800048 <__x86.get_pc_thunk.ax>
  800ef8:	05 08 11 00 00       	add    $0x1108,%eax
	int neg = 0;
  800efd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f04:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0b:	eb 04                	jmp    800f11 <strtol+0x28>
		s++;
  800f0d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	0f b6 00             	movzbl (%eax),%eax
  800f17:	3c 20                	cmp    $0x20,%al
  800f19:	74 f2                	je     800f0d <strtol+0x24>
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	0f b6 00             	movzbl (%eax),%eax
  800f21:	3c 09                	cmp    $0x9,%al
  800f23:	74 e8                	je     800f0d <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	0f b6 00             	movzbl (%eax),%eax
  800f2b:	3c 2b                	cmp    $0x2b,%al
  800f2d:	75 06                	jne    800f35 <strtol+0x4c>
		s++;
  800f2f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f33:	eb 15                	jmp    800f4a <strtol+0x61>
	else if (*s == '-')
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	0f b6 00             	movzbl (%eax),%eax
  800f3b:	3c 2d                	cmp    $0x2d,%al
  800f3d:	75 0b                	jne    800f4a <strtol+0x61>
		s++, neg = 1;
  800f3f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f43:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4e:	74 06                	je     800f56 <strtol+0x6d>
  800f50:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f54:	75 24                	jne    800f7a <strtol+0x91>
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	0f b6 00             	movzbl (%eax),%eax
  800f5c:	3c 30                	cmp    $0x30,%al
  800f5e:	75 1a                	jne    800f7a <strtol+0x91>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	83 c0 01             	add    $0x1,%eax
  800f66:	0f b6 00             	movzbl (%eax),%eax
  800f69:	3c 78                	cmp    $0x78,%al
  800f6b:	75 0d                	jne    800f7a <strtol+0x91>
		s += 2, base = 16;
  800f6d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f71:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f78:	eb 2a                	jmp    800fa4 <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	75 17                	jne    800f97 <strtol+0xae>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	0f b6 00             	movzbl (%eax),%eax
  800f86:	3c 30                	cmp    $0x30,%al
  800f88:	75 0d                	jne    800f97 <strtol+0xae>
		s++, base = 8;
  800f8a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f8e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f95:	eb 0d                	jmp    800fa4 <strtol+0xbb>
	else if (base == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strtol+0xbb>
		base = 10;
  800f9d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	0f b6 00             	movzbl (%eax),%eax
  800faa:	3c 2f                	cmp    $0x2f,%al
  800fac:	7e 1b                	jle    800fc9 <strtol+0xe0>
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	0f b6 00             	movzbl (%eax),%eax
  800fb4:	3c 39                	cmp    $0x39,%al
  800fb6:	7f 11                	jg     800fc9 <strtol+0xe0>
			dig = *s - '0';
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	0f b6 00             	movzbl (%eax),%eax
  800fbe:	0f be c0             	movsbl %al,%eax
  800fc1:	83 e8 30             	sub    $0x30,%eax
  800fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc7:	eb 48                	jmp    801011 <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	0f b6 00             	movzbl (%eax),%eax
  800fcf:	3c 60                	cmp    $0x60,%al
  800fd1:	7e 1b                	jle    800fee <strtol+0x105>
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	0f b6 00             	movzbl (%eax),%eax
  800fd9:	3c 7a                	cmp    $0x7a,%al
  800fdb:	7f 11                	jg     800fee <strtol+0x105>
			dig = *s - 'a' + 10;
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	0f b6 00             	movzbl (%eax),%eax
  800fe3:	0f be c0             	movsbl %al,%eax
  800fe6:	83 e8 57             	sub    $0x57,%eax
  800fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fec:	eb 23                	jmp    801011 <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	0f b6 00             	movzbl (%eax),%eax
  800ff4:	3c 40                	cmp    $0x40,%al
  800ff6:	7e 3c                	jle    801034 <strtol+0x14b>
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	0f b6 00             	movzbl (%eax),%eax
  800ffe:	3c 5a                	cmp    $0x5a,%al
  801000:	7f 32                	jg     801034 <strtol+0x14b>
			dig = *s - 'A' + 10;
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	0f b6 00             	movzbl (%eax),%eax
  801008:	0f be c0             	movsbl %al,%eax
  80100b:	83 e8 37             	sub    $0x37,%eax
  80100e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801014:	3b 45 10             	cmp    0x10(%ebp),%eax
  801017:	7d 1a                	jge    801033 <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
  801019:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80101d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801020:	0f af 45 10          	imul   0x10(%ebp),%eax
  801024:	89 c2                	mov    %eax,%edx
  801026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
  80102e:	e9 71 ff ff ff       	jmp    800fa4 <strtol+0xbb>
			break;
  801033:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
  801034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801038:	74 08                	je     801042 <strtol+0x159>
		*endptr = (char *) s;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801042:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801046:	74 07                	je     80104f <strtol+0x166>
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104b:	f7 d8                	neg    %eax
  80104d:	eb 03                	jmp    801052 <strtol+0x169>
  80104f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    
  801054:	66 90                	xchg   %ax,%ax
  801056:	66 90                	xchg   %ax,%ax
  801058:	66 90                	xchg   %ax,%ax
  80105a:	66 90                	xchg   %ax,%ax
  80105c:	66 90                	xchg   %ax,%ax
  80105e:	66 90                	xchg   %ax,%ax

00801060 <__udivdi3>:
  801060:	f3 0f 1e fb          	endbr32 
  801064:	55                   	push   %ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
  801068:	83 ec 1c             	sub    $0x1c,%esp
  80106b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80106f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801073:	8b 74 24 34          	mov    0x34(%esp),%esi
  801077:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80107b:	85 d2                	test   %edx,%edx
  80107d:	75 19                	jne    801098 <__udivdi3+0x38>
  80107f:	39 f3                	cmp    %esi,%ebx
  801081:	76 4d                	jbe    8010d0 <__udivdi3+0x70>
  801083:	31 ff                	xor    %edi,%edi
  801085:	89 e8                	mov    %ebp,%eax
  801087:	89 f2                	mov    %esi,%edx
  801089:	f7 f3                	div    %ebx
  80108b:	89 fa                	mov    %edi,%edx
  80108d:	83 c4 1c             	add    $0x1c,%esp
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    
  801095:	8d 76 00             	lea    0x0(%esi),%esi
  801098:	39 f2                	cmp    %esi,%edx
  80109a:	76 14                	jbe    8010b0 <__udivdi3+0x50>
  80109c:	31 ff                	xor    %edi,%edi
  80109e:	31 c0                	xor    %eax,%eax
  8010a0:	89 fa                	mov    %edi,%edx
  8010a2:	83 c4 1c             	add    $0x1c,%esp
  8010a5:	5b                   	pop    %ebx
  8010a6:	5e                   	pop    %esi
  8010a7:	5f                   	pop    %edi
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    
  8010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8010b0:	0f bd fa             	bsr    %edx,%edi
  8010b3:	83 f7 1f             	xor    $0x1f,%edi
  8010b6:	75 48                	jne    801100 <__udivdi3+0xa0>
  8010b8:	39 f2                	cmp    %esi,%edx
  8010ba:	72 06                	jb     8010c2 <__udivdi3+0x62>
  8010bc:	31 c0                	xor    %eax,%eax
  8010be:	39 eb                	cmp    %ebp,%ebx
  8010c0:	77 de                	ja     8010a0 <__udivdi3+0x40>
  8010c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8010c7:	eb d7                	jmp    8010a0 <__udivdi3+0x40>
  8010c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010d0:	89 d9                	mov    %ebx,%ecx
  8010d2:	85 db                	test   %ebx,%ebx
  8010d4:	75 0b                	jne    8010e1 <__udivdi3+0x81>
  8010d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8010db:	31 d2                	xor    %edx,%edx
  8010dd:	f7 f3                	div    %ebx
  8010df:	89 c1                	mov    %eax,%ecx
  8010e1:	31 d2                	xor    %edx,%edx
  8010e3:	89 f0                	mov    %esi,%eax
  8010e5:	f7 f1                	div    %ecx
  8010e7:	89 c6                	mov    %eax,%esi
  8010e9:	89 e8                	mov    %ebp,%eax
  8010eb:	89 f7                	mov    %esi,%edi
  8010ed:	f7 f1                	div    %ecx
  8010ef:	89 fa                	mov    %edi,%edx
  8010f1:	83 c4 1c             	add    $0x1c,%esp
  8010f4:	5b                   	pop    %ebx
  8010f5:	5e                   	pop    %esi
  8010f6:	5f                   	pop    %edi
  8010f7:	5d                   	pop    %ebp
  8010f8:	c3                   	ret    
  8010f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801100:	89 f9                	mov    %edi,%ecx
  801102:	b8 20 00 00 00       	mov    $0x20,%eax
  801107:	29 f8                	sub    %edi,%eax
  801109:	d3 e2                	shl    %cl,%edx
  80110b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80110f:	89 c1                	mov    %eax,%ecx
  801111:	89 da                	mov    %ebx,%edx
  801113:	d3 ea                	shr    %cl,%edx
  801115:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801119:	09 d1                	or     %edx,%ecx
  80111b:	89 f2                	mov    %esi,%edx
  80111d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801121:	89 f9                	mov    %edi,%ecx
  801123:	d3 e3                	shl    %cl,%ebx
  801125:	89 c1                	mov    %eax,%ecx
  801127:	d3 ea                	shr    %cl,%edx
  801129:	89 f9                	mov    %edi,%ecx
  80112b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80112f:	89 eb                	mov    %ebp,%ebx
  801131:	d3 e6                	shl    %cl,%esi
  801133:	89 c1                	mov    %eax,%ecx
  801135:	d3 eb                	shr    %cl,%ebx
  801137:	09 de                	or     %ebx,%esi
  801139:	89 f0                	mov    %esi,%eax
  80113b:	f7 74 24 08          	divl   0x8(%esp)
  80113f:	89 d6                	mov    %edx,%esi
  801141:	89 c3                	mov    %eax,%ebx
  801143:	f7 64 24 0c          	mull   0xc(%esp)
  801147:	39 d6                	cmp    %edx,%esi
  801149:	72 15                	jb     801160 <__udivdi3+0x100>
  80114b:	89 f9                	mov    %edi,%ecx
  80114d:	d3 e5                	shl    %cl,%ebp
  80114f:	39 c5                	cmp    %eax,%ebp
  801151:	73 04                	jae    801157 <__udivdi3+0xf7>
  801153:	39 d6                	cmp    %edx,%esi
  801155:	74 09                	je     801160 <__udivdi3+0x100>
  801157:	89 d8                	mov    %ebx,%eax
  801159:	31 ff                	xor    %edi,%edi
  80115b:	e9 40 ff ff ff       	jmp    8010a0 <__udivdi3+0x40>
  801160:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801163:	31 ff                	xor    %edi,%edi
  801165:	e9 36 ff ff ff       	jmp    8010a0 <__udivdi3+0x40>
  80116a:	66 90                	xchg   %ax,%ax
  80116c:	66 90                	xchg   %ax,%ax
  80116e:	66 90                	xchg   %ax,%ax

00801170 <__umoddi3>:
  801170:	f3 0f 1e fb          	endbr32 
  801174:	55                   	push   %ebp
  801175:	57                   	push   %edi
  801176:	56                   	push   %esi
  801177:	53                   	push   %ebx
  801178:	83 ec 1c             	sub    $0x1c,%esp
  80117b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80117f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801183:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801187:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80118b:	85 c0                	test   %eax,%eax
  80118d:	75 19                	jne    8011a8 <__umoddi3+0x38>
  80118f:	39 df                	cmp    %ebx,%edi
  801191:	76 5d                	jbe    8011f0 <__umoddi3+0x80>
  801193:	89 f0                	mov    %esi,%eax
  801195:	89 da                	mov    %ebx,%edx
  801197:	f7 f7                	div    %edi
  801199:	89 d0                	mov    %edx,%eax
  80119b:	31 d2                	xor    %edx,%edx
  80119d:	83 c4 1c             	add    $0x1c,%esp
  8011a0:	5b                   	pop    %ebx
  8011a1:	5e                   	pop    %esi
  8011a2:	5f                   	pop    %edi
  8011a3:	5d                   	pop    %ebp
  8011a4:	c3                   	ret    
  8011a5:	8d 76 00             	lea    0x0(%esi),%esi
  8011a8:	89 f2                	mov    %esi,%edx
  8011aa:	39 d8                	cmp    %ebx,%eax
  8011ac:	76 12                	jbe    8011c0 <__umoddi3+0x50>
  8011ae:	89 f0                	mov    %esi,%eax
  8011b0:	89 da                	mov    %ebx,%edx
  8011b2:	83 c4 1c             	add    $0x1c,%esp
  8011b5:	5b                   	pop    %ebx
  8011b6:	5e                   	pop    %esi
  8011b7:	5f                   	pop    %edi
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    
  8011ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011c0:	0f bd e8             	bsr    %eax,%ebp
  8011c3:	83 f5 1f             	xor    $0x1f,%ebp
  8011c6:	75 50                	jne    801218 <__umoddi3+0xa8>
  8011c8:	39 d8                	cmp    %ebx,%eax
  8011ca:	0f 82 e0 00 00 00    	jb     8012b0 <__umoddi3+0x140>
  8011d0:	89 d9                	mov    %ebx,%ecx
  8011d2:	39 f7                	cmp    %esi,%edi
  8011d4:	0f 86 d6 00 00 00    	jbe    8012b0 <__umoddi3+0x140>
  8011da:	89 d0                	mov    %edx,%eax
  8011dc:	89 ca                	mov    %ecx,%edx
  8011de:	83 c4 1c             	add    $0x1c,%esp
  8011e1:	5b                   	pop    %ebx
  8011e2:	5e                   	pop    %esi
  8011e3:	5f                   	pop    %edi
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    
  8011e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011ed:	8d 76 00             	lea    0x0(%esi),%esi
  8011f0:	89 fd                	mov    %edi,%ebp
  8011f2:	85 ff                	test   %edi,%edi
  8011f4:	75 0b                	jne    801201 <__umoddi3+0x91>
  8011f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8011fb:	31 d2                	xor    %edx,%edx
  8011fd:	f7 f7                	div    %edi
  8011ff:	89 c5                	mov    %eax,%ebp
  801201:	89 d8                	mov    %ebx,%eax
  801203:	31 d2                	xor    %edx,%edx
  801205:	f7 f5                	div    %ebp
  801207:	89 f0                	mov    %esi,%eax
  801209:	f7 f5                	div    %ebp
  80120b:	89 d0                	mov    %edx,%eax
  80120d:	31 d2                	xor    %edx,%edx
  80120f:	eb 8c                	jmp    80119d <__umoddi3+0x2d>
  801211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801218:	89 e9                	mov    %ebp,%ecx
  80121a:	ba 20 00 00 00       	mov    $0x20,%edx
  80121f:	29 ea                	sub    %ebp,%edx
  801221:	d3 e0                	shl    %cl,%eax
  801223:	89 44 24 08          	mov    %eax,0x8(%esp)
  801227:	89 d1                	mov    %edx,%ecx
  801229:	89 f8                	mov    %edi,%eax
  80122b:	d3 e8                	shr    %cl,%eax
  80122d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801231:	89 54 24 04          	mov    %edx,0x4(%esp)
  801235:	8b 54 24 04          	mov    0x4(%esp),%edx
  801239:	09 c1                	or     %eax,%ecx
  80123b:	89 d8                	mov    %ebx,%eax
  80123d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801241:	89 e9                	mov    %ebp,%ecx
  801243:	d3 e7                	shl    %cl,%edi
  801245:	89 d1                	mov    %edx,%ecx
  801247:	d3 e8                	shr    %cl,%eax
  801249:	89 e9                	mov    %ebp,%ecx
  80124b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80124f:	d3 e3                	shl    %cl,%ebx
  801251:	89 c7                	mov    %eax,%edi
  801253:	89 d1                	mov    %edx,%ecx
  801255:	89 f0                	mov    %esi,%eax
  801257:	d3 e8                	shr    %cl,%eax
  801259:	89 e9                	mov    %ebp,%ecx
  80125b:	89 fa                	mov    %edi,%edx
  80125d:	d3 e6                	shl    %cl,%esi
  80125f:	09 d8                	or     %ebx,%eax
  801261:	f7 74 24 08          	divl   0x8(%esp)
  801265:	89 d1                	mov    %edx,%ecx
  801267:	89 f3                	mov    %esi,%ebx
  801269:	f7 64 24 0c          	mull   0xc(%esp)
  80126d:	89 c6                	mov    %eax,%esi
  80126f:	89 d7                	mov    %edx,%edi
  801271:	39 d1                	cmp    %edx,%ecx
  801273:	72 06                	jb     80127b <__umoddi3+0x10b>
  801275:	75 10                	jne    801287 <__umoddi3+0x117>
  801277:	39 c3                	cmp    %eax,%ebx
  801279:	73 0c                	jae    801287 <__umoddi3+0x117>
  80127b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80127f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801283:	89 d7                	mov    %edx,%edi
  801285:	89 c6                	mov    %eax,%esi
  801287:	89 ca                	mov    %ecx,%edx
  801289:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80128e:	29 f3                	sub    %esi,%ebx
  801290:	19 fa                	sbb    %edi,%edx
  801292:	89 d0                	mov    %edx,%eax
  801294:	d3 e0                	shl    %cl,%eax
  801296:	89 e9                	mov    %ebp,%ecx
  801298:	d3 eb                	shr    %cl,%ebx
  80129a:	d3 ea                	shr    %cl,%edx
  80129c:	09 d8                	or     %ebx,%eax
  80129e:	83 c4 1c             	add    $0x1c,%esp
  8012a1:	5b                   	pop    %ebx
  8012a2:	5e                   	pop    %esi
  8012a3:	5f                   	pop    %edi
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    
  8012a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012ad:	8d 76 00             	lea    0x0(%esi),%esi
  8012b0:	29 fe                	sub    %edi,%esi
  8012b2:	19 c3                	sbb    %eax,%ebx
  8012b4:	89 f2                	mov    %esi,%edx
  8012b6:	89 d9                	mov    %ebx,%ecx
  8012b8:	e9 1d ff ff ff       	jmp    8011da <__umoddi3+0x6a>
