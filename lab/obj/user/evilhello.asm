
obj/user/evilhello:     file format elf32-i386


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
  80002c:	e8 35 00 00 00       	call   800066 <libmain>
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
  80003e:	e8 1f 00 00 00       	call   800062 <__x86.get_pc_thunk.ax>
  800043:	05 bd 1f 00 00       	add    $0x1fbd,%eax
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	6a 64                	push   $0x64
  80004d:	68 0c 00 10 f0       	push   $0xf010000c
  800052:	89 c3                	mov    %eax,%ebx
  800054:	e8 0b 01 00 00       	call   800164 <sys_cputs>
  800059:	83 c4 10             	add    $0x10,%esp
}
  80005c:	90                   	nop
  80005d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800060:	c9                   	leave  
  800061:	c3                   	ret    

00800062 <__x86.get_pc_thunk.ax>:
  800062:	8b 04 24             	mov    (%esp),%eax
  800065:	c3                   	ret    

00800066 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800066:	f3 0f 1e fb          	endbr32 
  80006a:	55                   	push   %ebp
  80006b:	89 e5                	mov    %esp,%ebp
  80006d:	53                   	push   %ebx
  80006e:	83 ec 04             	sub    $0x4,%esp
  800071:	e8 5a 00 00 00       	call   8000d0 <__x86.get_pc_thunk.bx>
  800076:	81 c3 8a 1f 00 00    	add    $0x1f8a,%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code h(ere.
	thisenv = envs + ENVX(sys_getenvid());
  80007c:	e8 76 01 00 00       	call   8001f7 <sys_getenvid>
  800081:	25 ff 03 00 00       	and    $0x3ff,%eax
  800086:	89 c2                	mov    %eax,%edx
  800088:	89 d0                	mov    %edx,%eax
  80008a:	01 c0                	add    %eax,%eax
  80008c:	01 d0                	add    %edx,%eax
  80008e:	c1 e0 05             	shl    $0x5,%eax
  800091:	89 c2                	mov    %eax,%edx
  800093:	c7 c0 00 00 c0 ee    	mov    $0xeec00000,%eax
  800099:	01 c2                	add    %eax,%edx
  80009b:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  8000a1:	89 10                	mov    %edx,(%eax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a7:	7e 0b                	jle    8000b4 <libmain+0x4e>
		binaryname = argv[0];
  8000a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ac:	8b 00                	mov    (%eax),%eax
  8000ae:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000b4:	83 ec 08             	sub    $0x8,%esp
  8000b7:	ff 75 0c             	pushl  0xc(%ebp)
  8000ba:	ff 75 08             	pushl  0x8(%ebp)
  8000bd:	e8 71 ff ff ff       	call   800033 <umain>
  8000c2:	83 c4 10             	add    $0x10,%esp

	// exit gracefully
	exit();
  8000c5:	e8 0a 00 00 00       	call   8000d4 <exit>
}
  8000ca:	90                   	nop
  8000cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ce:	c9                   	leave  
  8000cf:	c3                   	ret    

008000d0 <__x86.get_pc_thunk.bx>:
  8000d0:	8b 1c 24             	mov    (%esp),%ebx
  8000d3:	c3                   	ret    

008000d4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d4:	f3 0f 1e fb          	endbr32 
  8000d8:	55                   	push   %ebp
  8000d9:	89 e5                	mov    %esp,%ebp
  8000db:	53                   	push   %ebx
  8000dc:	83 ec 04             	sub    $0x4,%esp
  8000df:	e8 7e ff ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  8000e4:	05 1c 1f 00 00       	add    $0x1f1c,%eax
	sys_env_destroy(0);
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	6a 00                	push   $0x0
  8000ee:	89 c3                	mov    %eax,%ebx
  8000f0:	e8 d1 00 00 00       	call   8001c6 <sys_env_destroy>
  8000f5:	83 c4 10             	add    $0x10,%esp
}
  8000f8:	90                   	nop
  8000f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000fc:	c9                   	leave  
  8000fd:	c3                   	ret    

008000fe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	57                   	push   %edi
  800102:	56                   	push   %esi
  800103:	53                   	push   %ebx
  800104:	83 ec 2c             	sub    $0x2c,%esp
  800107:	e8 c4 ff ff ff       	call   8000d0 <__x86.get_pc_thunk.bx>
  80010c:	81 c3 f4 1e 00 00    	add    $0x1ef4,%ebx
  800112:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800115:	8b 45 08             	mov    0x8(%ebp),%eax
  800118:	8b 55 10             	mov    0x10(%ebp),%edx
  80011b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80011e:	8b 5d 18             	mov    0x18(%ebp),%ebx
  800121:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  800124:	8b 75 20             	mov    0x20(%ebp),%esi
  800127:	cd 30                	int    $0x30
  800129:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80012c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800130:	74 27                	je     800159 <syscall+0x5b>
  800132:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800136:	7e 21                	jle    800159 <syscall+0x5b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80013e:	ff 75 08             	pushl  0x8(%ebp)
  800141:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800144:	8d 83 da f2 ff ff    	lea    -0xd26(%ebx),%eax
  80014a:	50                   	push   %eax
  80014b:	6a 23                	push   $0x23
  80014d:	8d 83 f7 f2 ff ff    	lea    -0xd09(%ebx),%eax
  800153:	50                   	push   %eax
  800154:	e8 cd 00 00 00       	call   800226 <_panic>

	return ret;
  800159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80015c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80015f:	5b                   	pop    %ebx
  800160:	5e                   	pop    %esi
  800161:	5f                   	pop    %edi
  800162:	5d                   	pop    %ebp
  800163:	c3                   	ret    

00800164 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800164:	f3 0f 1e fb          	endbr32 
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	e8 ef fe ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800173:	05 8d 1e 00 00       	add    $0x1e8d,%eax
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800178:	8b 45 08             	mov    0x8(%ebp),%eax
  80017b:	83 ec 04             	sub    $0x4,%esp
  80017e:	6a 00                	push   $0x0
  800180:	6a 00                	push   $0x0
  800182:	6a 00                	push   $0x0
  800184:	ff 75 0c             	pushl  0xc(%ebp)
  800187:	50                   	push   %eax
  800188:	6a 00                	push   $0x0
  80018a:	6a 00                	push   $0x0
  80018c:	e8 6d ff ff ff       	call   8000fe <syscall>
  800191:	83 c4 20             	add    $0x20,%esp
}
  800194:	90                   	nop
  800195:	c9                   	leave  
  800196:	c3                   	ret    

00800197 <sys_cgetc>:

int
sys_cgetc(void)
{
  800197:	f3 0f 1e fb          	endbr32 
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	e8 bc fe ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  8001a6:	05 5a 1e 00 00       	add    $0x1e5a,%eax
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	6a 00                	push   $0x0
  8001b0:	6a 00                	push   $0x0
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 00                	push   $0x0
  8001b6:	6a 00                	push   $0x0
  8001b8:	6a 00                	push   $0x0
  8001ba:	6a 01                	push   $0x1
  8001bc:	e8 3d ff ff ff       	call   8000fe <syscall>
  8001c1:	83 c4 20             	add    $0x20,%esp
}
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    

008001c6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001c6:	f3 0f 1e fb          	endbr32 
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	83 ec 08             	sub    $0x8,%esp
  8001d0:	e8 8d fe ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  8001d5:	05 2b 1e 00 00       	add    $0x1e2b,%eax
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001da:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dd:	83 ec 04             	sub    $0x4,%esp
  8001e0:	6a 00                	push   $0x0
  8001e2:	6a 00                	push   $0x0
  8001e4:	6a 00                	push   $0x0
  8001e6:	6a 00                	push   $0x0
  8001e8:	50                   	push   %eax
  8001e9:	6a 01                	push   $0x1
  8001eb:	6a 03                	push   $0x3
  8001ed:	e8 0c ff ff ff       	call   8000fe <syscall>
  8001f2:	83 c4 20             	add    $0x20,%esp
}
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

008001f7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8001f7:	f3 0f 1e fb          	endbr32 
  8001fb:	55                   	push   %ebp
  8001fc:	89 e5                	mov    %esp,%ebp
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	e8 5c fe ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800206:	05 fa 1d 00 00       	add    $0x1dfa,%eax
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	6a 00                	push   $0x0
  800210:	6a 00                	push   $0x0
  800212:	6a 00                	push   $0x0
  800214:	6a 00                	push   $0x0
  800216:	6a 00                	push   $0x0
  800218:	6a 00                	push   $0x0
  80021a:	6a 02                	push   $0x2
  80021c:	e8 dd fe ff ff       	call   8000fe <syscall>
  800221:	83 c4 20             	add    $0x20,%esp
}
  800224:	c9                   	leave  
  800225:	c3                   	ret    

00800226 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800226:	f3 0f 1e fb          	endbr32 
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	56                   	push   %esi
  80022e:	53                   	push   %ebx
  80022f:	83 ec 10             	sub    $0x10,%esp
  800232:	e8 99 fe ff ff       	call   8000d0 <__x86.get_pc_thunk.bx>
  800237:	81 c3 c9 1d 00 00    	add    $0x1dc9,%ebx
	va_list ap;

	va_start(ap, fmt);
  80023d:	8d 45 14             	lea    0x14(%ebp),%eax
  800240:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800243:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800249:	8b 30                	mov    (%eax),%esi
  80024b:	e8 a7 ff ff ff       	call   8001f7 <sys_getenvid>
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	ff 75 0c             	pushl  0xc(%ebp)
  800256:	ff 75 08             	pushl  0x8(%ebp)
  800259:	56                   	push   %esi
  80025a:	50                   	push   %eax
  80025b:	8d 83 08 f3 ff ff    	lea    -0xcf8(%ebx),%eax
  800261:	50                   	push   %eax
  800262:	e8 0f 01 00 00       	call   800376 <cprintf>
  800267:	83 c4 20             	add    $0x20,%esp
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80026a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026d:	83 ec 08             	sub    $0x8,%esp
  800270:	50                   	push   %eax
  800271:	ff 75 10             	pushl  0x10(%ebp)
  800274:	e8 8d 00 00 00       	call   800306 <vcprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	8d 83 2b f3 ff ff    	lea    -0xcd5(%ebx),%eax
  800285:	50                   	push   %eax
  800286:	e8 eb 00 00 00       	call   800376 <cprintf>
  80028b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80028e:	cc                   	int3   
  80028f:	eb fd                	jmp    80028e <_panic+0x68>

00800291 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800291:	f3 0f 1e fb          	endbr32 
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	53                   	push   %ebx
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	e8 09 01 00 00       	call   8003aa <__x86.get_pc_thunk.dx>
  8002a1:	81 c2 5f 1d 00 00    	add    $0x1d5f,%edx
	b->buf[b->idx++] = ch;
  8002a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	8d 58 01             	lea    0x1(%eax),%ebx
  8002af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b2:	89 19                	mov    %ebx,(%ecx)
  8002b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b7:	89 cb                	mov    %ecx,%ebx
  8002b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bc:	88 5c 01 08          	mov    %bl,0x8(%ecx,%eax,1)
	if (b->idx == 256-1) {
  8002c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c3:	8b 00                	mov    (%eax),%eax
  8002c5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ca:	75 25                	jne    8002f1 <putch+0x60>
		sys_cputs(b->buf, b->idx);
  8002cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cf:	8b 00                	mov    (%eax),%eax
  8002d1:	89 c1                	mov    %eax,%ecx
  8002d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d6:	83 c0 08             	add    $0x8,%eax
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	51                   	push   %ecx
  8002dd:	50                   	push   %eax
  8002de:	89 d3                	mov    %edx,%ebx
  8002e0:	e8 7f fe ff ff       	call   800164 <sys_cputs>
  8002e5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f4:	8b 40 04             	mov    0x4(%eax),%eax
  8002f7:	8d 50 01             	lea    0x1(%eax),%edx
  8002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fd:	89 50 04             	mov    %edx,0x4(%eax)
}
  800300:	90                   	nop
  800301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800304:	c9                   	leave  
  800305:	c3                   	ret    

00800306 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800306:	f3 0f 1e fb          	endbr32 
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	53                   	push   %ebx
  80030e:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800314:	e8 b7 fd ff ff       	call   8000d0 <__x86.get_pc_thunk.bx>
  800319:	81 c3 e7 1c 00 00    	add    $0x1ce7,%ebx
	struct printbuf b;

	b.idx = 0;
  80031f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800326:	00 00 00 
	b.cnt = 0;
  800329:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800330:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800333:	ff 75 0c             	pushl  0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033f:	50                   	push   %eax
  800340:	8d 83 91 e2 ff ff    	lea    -0x1d6f(%ebx),%eax
  800346:	50                   	push   %eax
  800347:	e8 e3 01 00 00       	call   80052f <vprintfmt>
  80034c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  80034f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	50                   	push   %eax
  800359:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80035f:	83 c0 08             	add    $0x8,%eax
  800362:	50                   	push   %eax
  800363:	e8 fc fd ff ff       	call   800164 <sys_cputs>
  800368:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80036b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800371:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800374:	c9                   	leave  
  800375:	c3                   	ret    

00800376 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800376:	f3 0f 1e fb          	endbr32 
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
  80037d:	83 ec 18             	sub    $0x18,%esp
  800380:	e8 dd fc ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800385:	05 7b 1c 00 00       	add    $0x1c7b,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80038a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
  800390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	50                   	push   %eax
  800397:	ff 75 08             	pushl  0x8(%ebp)
  80039a:	e8 67 ff ff ff       	call   800306 <vcprintf>
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
  8003a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8003a8:	c9                   	leave  
  8003a9:	c3                   	ret    

008003aa <__x86.get_pc_thunk.dx>:
  8003aa:	8b 14 24             	mov    (%esp),%edx
  8003ad:	c3                   	ret    

008003ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ae:	f3 0f 1e fb          	endbr32 
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	57                   	push   %edi
  8003b6:	56                   	push   %esi
  8003b7:	53                   	push   %ebx
  8003b8:	83 ec 1c             	sub    $0x1c,%esp
  8003bb:	e8 43 06 00 00       	call   800a03 <__x86.get_pc_thunk.si>
  8003c0:	81 c6 40 1c 00 00    	add    $0x1c40,%esi
  8003c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003dd:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8003e0:	19 d1                	sbb    %edx,%ecx
  8003e2:	72 4d                	jb     800431 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003e4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003e7:	8d 78 ff             	lea    -0x1(%eax),%edi
  8003ea:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f2:	52                   	push   %edx
  8003f3:	50                   	push   %eax
  8003f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003fa:	89 f3                	mov    %esi,%ebx
  8003fc:	e8 6f 0c 00 00       	call   801070 <__udivdi3>
  800401:	83 c4 10             	add    $0x10,%esp
  800404:	83 ec 04             	sub    $0x4,%esp
  800407:	ff 75 20             	pushl  0x20(%ebp)
  80040a:	57                   	push   %edi
  80040b:	ff 75 18             	pushl  0x18(%ebp)
  80040e:	52                   	push   %edx
  80040f:	50                   	push   %eax
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	e8 93 ff ff ff       	call   8003ae <printnum>
  80041b:	83 c4 20             	add    $0x20,%esp
  80041e:	eb 1b                	jmp    80043b <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800420:	83 ec 08             	sub    $0x8,%esp
  800423:	ff 75 0c             	pushl  0xc(%ebp)
  800426:	ff 75 20             	pushl  0x20(%ebp)
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	ff d0                	call   *%eax
  80042e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800431:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  800435:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800439:	7f e5                	jg     800420 <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80043b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80043e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800443:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800446:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800449:	53                   	push   %ebx
  80044a:	51                   	push   %ecx
  80044b:	52                   	push   %edx
  80044c:	50                   	push   %eax
  80044d:	89 f3                	mov    %esi,%ebx
  80044f:	e8 2c 0d 00 00       	call   801180 <__umoddi3>
  800454:	83 c4 10             	add    $0x10,%esp
  800457:	8d 8e 99 f3 ff ff    	lea    -0xc67(%esi),%ecx
  80045d:	01 c8                	add    %ecx,%eax
  80045f:	0f b6 00             	movzbl (%eax),%eax
  800462:	0f be c0             	movsbl %al,%eax
  800465:	83 ec 08             	sub    $0x8,%esp
  800468:	ff 75 0c             	pushl  0xc(%ebp)
  80046b:	50                   	push   %eax
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	ff d0                	call   *%eax
  800471:	83 c4 10             	add    $0x10,%esp
}
  800474:	90                   	nop
  800475:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800478:	5b                   	pop    %ebx
  800479:	5e                   	pop    %esi
  80047a:	5f                   	pop    %edi
  80047b:	5d                   	pop    %ebp
  80047c:	c3                   	ret    

0080047d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80047d:	f3 0f 1e fb          	endbr32 
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
  800484:	e8 d9 fb ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800489:	05 77 1b 00 00       	add    $0x1b77,%eax
	if (lflag >= 2)
  80048e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800492:	7e 14                	jle    8004a8 <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	8d 48 08             	lea    0x8(%eax),%ecx
  80049c:	8b 55 08             	mov    0x8(%ebp),%edx
  80049f:	89 0a                	mov    %ecx,(%edx)
  8004a1:	8b 50 04             	mov    0x4(%eax),%edx
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	eb 30                	jmp    8004d8 <getuint+0x5b>
	else if (lflag)
  8004a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ac:	74 16                	je     8004c4 <getuint+0x47>
		return va_arg(*ap, unsigned long);
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	8d 48 04             	lea    0x4(%eax),%ecx
  8004b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b9:	89 0a                	mov    %ecx,(%edx)
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c2:	eb 14                	jmp    8004d8 <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	8d 48 04             	lea    0x4(%eax),%ecx
  8004cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8004cf:	89 0a                	mov    %ecx,(%edx)
  8004d1:	8b 00                	mov    (%eax),%eax
  8004d3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004d8:	5d                   	pop    %ebp
  8004d9:	c3                   	ret    

008004da <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004da:	f3 0f 1e fb          	endbr32 
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	e8 7c fb ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  8004e6:	05 1a 1b 00 00       	add    $0x1b1a,%eax
	if (lflag >= 2)
  8004eb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ef:	7e 14                	jle    800505 <getint+0x2b>
		return va_arg(*ap, long long);
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	8d 48 08             	lea    0x8(%eax),%ecx
  8004f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004fc:	89 0a                	mov    %ecx,(%edx)
  8004fe:	8b 50 04             	mov    0x4(%eax),%edx
  800501:	8b 00                	mov    (%eax),%eax
  800503:	eb 28                	jmp    80052d <getint+0x53>
	else if (lflag)
  800505:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800509:	74 12                	je     80051d <getint+0x43>
		return va_arg(*ap, long);
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	8d 48 04             	lea    0x4(%eax),%ecx
  800513:	8b 55 08             	mov    0x8(%ebp),%edx
  800516:	89 0a                	mov    %ecx,(%edx)
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	99                   	cltd   
  80051b:	eb 10                	jmp    80052d <getint+0x53>
	else
		return va_arg(*ap, int);
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	8b 00                	mov    (%eax),%eax
  800522:	8d 48 04             	lea    0x4(%eax),%ecx
  800525:	8b 55 08             	mov    0x8(%ebp),%edx
  800528:	89 0a                	mov    %ecx,(%edx)
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	99                   	cltd   
}
  80052d:	5d                   	pop    %ebp
  80052e:	c3                   	ret    

0080052f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80052f:	f3 0f 1e fb          	endbr32 
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	57                   	push   %edi
  800537:	56                   	push   %esi
  800538:	53                   	push   %ebx
  800539:	83 ec 2c             	sub    $0x2c,%esp
  80053c:	e8 c6 04 00 00       	call   800a07 <__x86.get_pc_thunk.di>
  800541:	81 c7 bf 1a 00 00    	add    $0x1abf,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800547:	eb 17                	jmp    800560 <vprintfmt+0x31>
			if (ch == '\0')
  800549:	85 db                	test   %ebx,%ebx
  80054b:	0f 84 96 03 00 00    	je     8008e7 <.L20+0x2d>
				return;
			putch(ch, putdat);
  800551:	83 ec 08             	sub    $0x8,%esp
  800554:	ff 75 0c             	pushl  0xc(%ebp)
  800557:	53                   	push   %ebx
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	ff d0                	call   *%eax
  80055d:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800560:	8b 45 10             	mov    0x10(%ebp),%eax
  800563:	8d 50 01             	lea    0x1(%eax),%edx
  800566:	89 55 10             	mov    %edx,0x10(%ebp)
  800569:	0f b6 00             	movzbl (%eax),%eax
  80056c:	0f b6 d8             	movzbl %al,%ebx
  80056f:	83 fb 25             	cmp    $0x25,%ebx
  800572:	75 d5                	jne    800549 <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
  800574:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
  800578:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
  80057f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
  800586:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
  80058d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800594:	8b 45 10             	mov    0x10(%ebp),%eax
  800597:	8d 50 01             	lea    0x1(%eax),%edx
  80059a:	89 55 10             	mov    %edx,0x10(%ebp)
  80059d:	0f b6 00             	movzbl (%eax),%eax
  8005a0:	0f b6 d8             	movzbl %al,%ebx
  8005a3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005a6:	83 f8 55             	cmp    $0x55,%eax
  8005a9:	0f 87 0b 03 00 00    	ja     8008ba <.L20>
  8005af:	c1 e0 02             	shl    $0x2,%eax
  8005b2:	8b 84 38 c0 f3 ff ff 	mov    -0xc40(%eax,%edi,1),%eax
  8005b9:	01 f8                	add    %edi,%eax
  8005bb:	3e ff e0             	notrack jmp *%eax

008005be <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
  8005be:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
  8005c2:	eb d0                	jmp    800594 <vprintfmt+0x65>

008005c4 <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005c4:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
  8005c8:	eb ca                	jmp    800594 <vprintfmt+0x65>

008005ca <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
  8005d1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005d4:	89 d0                	mov    %edx,%eax
  8005d6:	c1 e0 02             	shl    $0x2,%eax
  8005d9:	01 d0                	add    %edx,%eax
  8005db:	01 c0                	add    %eax,%eax
  8005dd:	01 d8                	add    %ebx,%eax
  8005df:	83 e8 30             	sub    $0x30,%eax
  8005e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
  8005e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e8:	0f b6 00             	movzbl (%eax),%eax
  8005eb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005ee:	83 fb 2f             	cmp    $0x2f,%ebx
  8005f1:	7e 39                	jle    80062c <.L37+0xc>
  8005f3:	83 fb 39             	cmp    $0x39,%ebx
  8005f6:	7f 34                	jg     80062c <.L37+0xc>
			for (precision = 0; ; ++fmt) {
  8005f8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
  8005fc:	eb d3                	jmp    8005d1 <.L31+0x7>

008005fe <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	8d 50 04             	lea    0x4(%eax),%edx
  800604:	89 55 14             	mov    %edx,0x14(%ebp)
  800607:	8b 00                	mov    (%eax),%eax
  800609:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
  80060c:	eb 1f                	jmp    80062d <.L37+0xd>

0080060e <.L33>:

		case '.':
			if (width < 0)
  80060e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800612:	79 80                	jns    800594 <vprintfmt+0x65>
				width = 0;
  800614:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
  80061b:	e9 74 ff ff ff       	jmp    800594 <vprintfmt+0x65>

00800620 <.L37>:

		case '#':
			altflag = 1;
  800620:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
  800627:	e9 68 ff ff ff       	jmp    800594 <vprintfmt+0x65>
			goto process_precision;
  80062c:	90                   	nop

		process_precision:
			if (width < 0)
  80062d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800631:	0f 89 5d ff ff ff    	jns    800594 <vprintfmt+0x65>
				width = precision, precision = -1;
  800637:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80063a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80063d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
  800644:	e9 4b ff ff ff       	jmp    800594 <vprintfmt+0x65>

00800649 <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800649:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
  80064d:	e9 42 ff ff ff       	jmp    800594 <vprintfmt+0x65>

00800652 <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8d 50 04             	lea    0x4(%eax),%edx
  800658:	89 55 14             	mov    %edx,0x14(%ebp)
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	50                   	push   %eax
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	ff d0                	call   *%eax
  800669:	83 c4 10             	add    $0x10,%esp
			break;
  80066c:	e9 71 02 00 00       	jmp    8008e2 <.L20+0x28>

00800671 <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8d 50 04             	lea    0x4(%eax),%edx
  800677:	89 55 14             	mov    %edx,0x14(%ebp)
  80067a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80067c:	85 db                	test   %ebx,%ebx
  80067e:	79 02                	jns    800682 <.L28+0x11>
				err = -err;
  800680:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800682:	83 fb 06             	cmp    $0x6,%ebx
  800685:	7f 0b                	jg     800692 <.L28+0x21>
  800687:	8b b4 9f 10 00 00 00 	mov    0x10(%edi,%ebx,4),%esi
  80068e:	85 f6                	test   %esi,%esi
  800690:	75 1b                	jne    8006ad <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
  800692:	53                   	push   %ebx
  800693:	8d 87 aa f3 ff ff    	lea    -0xc56(%edi),%eax
  800699:	50                   	push   %eax
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	ff 75 08             	pushl  0x8(%ebp)
  8006a0:	e8 4b 02 00 00       	call   8008f0 <printfmt>
  8006a5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006a8:	e9 35 02 00 00       	jmp    8008e2 <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
  8006ad:	56                   	push   %esi
  8006ae:	8d 87 b3 f3 ff ff    	lea    -0xc4d(%edi),%eax
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	e8 30 02 00 00       	call   8008f0 <printfmt>
  8006c0:	83 c4 10             	add    $0x10,%esp
			break;
  8006c3:	e9 1a 02 00 00       	jmp    8008e2 <.L20+0x28>

008006c8 <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8d 50 04             	lea    0x4(%eax),%edx
  8006ce:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d1:	8b 30                	mov    (%eax),%esi
  8006d3:	85 f6                	test   %esi,%esi
  8006d5:	75 06                	jne    8006dd <.L24+0x15>
				p = "(null)";
  8006d7:	8d b7 b6 f3 ff ff    	lea    -0xc4a(%edi),%esi
			if (width > 0 && padc != '-')
  8006dd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006e1:	7e 71                	jle    800754 <.L24+0x8c>
  8006e3:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  8006e7:	74 6b                	je     800754 <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	50                   	push   %eax
  8006f0:	56                   	push   %esi
  8006f1:	89 fb                	mov    %edi,%ebx
  8006f3:	e8 47 03 00 00       	call   800a3f <strnlen>
  8006f8:	83 c4 10             	add    $0x10,%esp
  8006fb:	29 45 d4             	sub    %eax,-0x2c(%ebp)
  8006fe:	eb 17                	jmp    800717 <.L24+0x4f>
					putch(padc, putdat);
  800700:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	50                   	push   %eax
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	ff d0                	call   *%eax
  800710:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
  800713:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800717:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80071b:	7f e3                	jg     800700 <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80071d:	eb 35                	jmp    800754 <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
  80071f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800723:	74 1c                	je     800741 <.L24+0x79>
  800725:	83 fb 1f             	cmp    $0x1f,%ebx
  800728:	7e 05                	jle    80072f <.L24+0x67>
  80072a:	83 fb 7e             	cmp    $0x7e,%ebx
  80072d:	7e 12                	jle    800741 <.L24+0x79>
					putch('?', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	6a 3f                	push   $0x3f
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	eb 0f                	jmp    800750 <.L24+0x88>
				else
					putch(ch, putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	53                   	push   %ebx
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800750:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800754:	89 f0                	mov    %esi,%eax
  800756:	8d 70 01             	lea    0x1(%eax),%esi
  800759:	0f b6 00             	movzbl (%eax),%eax
  80075c:	0f be d8             	movsbl %al,%ebx
  80075f:	85 db                	test   %ebx,%ebx
  800761:	74 26                	je     800789 <.L24+0xc1>
  800763:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800767:	78 b6                	js     80071f <.L24+0x57>
  800769:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  80076d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800771:	79 ac                	jns    80071f <.L24+0x57>
			for (; width > 0; width--)
  800773:	eb 14                	jmp    800789 <.L24+0xc1>
				putch(' ', putdat);
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	6a 20                	push   $0x20
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	ff d0                	call   *%eax
  800782:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
  800785:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800789:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80078d:	7f e6                	jg     800775 <.L24+0xad>
			break;
  80078f:	e9 4e 01 00 00       	jmp    8008e2 <.L20+0x28>

00800794 <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	ff 75 d8             	pushl  -0x28(%ebp)
  80079a:	8d 45 14             	lea    0x14(%ebp),%eax
  80079d:	50                   	push   %eax
  80079e:	e8 37 fd ff ff       	call   8004da <getint>
  8007a3:	83 c4 10             	add    $0x10,%esp
  8007a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
  8007ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b2:	85 d2                	test   %edx,%edx
  8007b4:	79 23                	jns    8007d9 <.L29+0x45>
				putch('-', putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	6a 2d                	push   $0x2d
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	ff d0                	call   *%eax
  8007c3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007cc:	f7 d8                	neg    %eax
  8007ce:	83 d2 00             	adc    $0x0,%edx
  8007d1:	f7 da                	neg    %edx
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
  8007d9:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007e0:	e9 9f 00 00 00       	jmp    800884 <.L21+0x1f>

008007e5 <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8007eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ee:	50                   	push   %eax
  8007ef:	e8 89 fc ff ff       	call   80047d <getuint>
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007fa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
  8007fd:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  800804:	eb 7e                	jmp    800884 <.L21+0x1f>

00800806 <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 d8             	pushl  -0x28(%ebp)
  80080c:	8d 45 14             	lea    0x14(%ebp),%eax
  80080f:	50                   	push   %eax
  800810:	e8 68 fc ff ff       	call   80047d <getuint>
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80081b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
  80081e:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
  800825:	eb 5d                	jmp    800884 <.L21+0x1f>

00800827 <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	ff 75 0c             	pushl  0xc(%ebp)
  80082d:	6a 30                	push   $0x30
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	ff d0                	call   *%eax
  800834:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800837:	83 ec 08             	sub    $0x8,%esp
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	6a 78                	push   $0x78
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	8d 50 04             	lea    0x4(%eax),%edx
  80084d:	89 55 14             	mov    %edx,0x14(%ebp)
  800850:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
  800852:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800855:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
  80085c:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
  800863:	eb 1f                	jmp    800884 <.L21+0x1f>

00800865 <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 d8             	pushl  -0x28(%ebp)
  80086b:	8d 45 14             	lea    0x14(%ebp),%eax
  80086e:	50                   	push   %eax
  80086f:	e8 09 fc ff ff       	call   80047d <getuint>
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80087a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
  80087d:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800884:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  800888:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80088b:	83 ec 04             	sub    $0x4,%esp
  80088e:	52                   	push   %edx
  80088f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800892:	50                   	push   %eax
  800893:	ff 75 e4             	pushl  -0x1c(%ebp)
  800896:	ff 75 e0             	pushl  -0x20(%ebp)
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	ff 75 08             	pushl  0x8(%ebp)
  80089f:	e8 0a fb ff ff       	call   8003ae <printnum>
  8008a4:	83 c4 20             	add    $0x20,%esp
			break;
  8008a7:	eb 39                	jmp    8008e2 <.L20+0x28>

008008a9 <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	53                   	push   %ebx
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	ff d0                	call   *%eax
  8008b5:	83 c4 10             	add    $0x10,%esp
			break;
  8008b8:	eb 28                	jmp    8008e2 <.L20+0x28>

008008ba <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	6a 25                	push   $0x25
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	ff d0                	call   *%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ca:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008ce:	eb 04                	jmp    8008d4 <.L20+0x1a>
  8008d0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d7:	83 e8 01             	sub    $0x1,%eax
  8008da:	0f b6 00             	movzbl (%eax),%eax
  8008dd:	3c 25                	cmp    $0x25,%al
  8008df:	75 ef                	jne    8008d0 <.L20+0x16>
				/* do nothing */;
			break;
  8008e1:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e2:	e9 79 fc ff ff       	jmp    800560 <vprintfmt+0x31>
				return;
  8008e7:	90                   	nop
		}
	}
}
  8008e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008eb:	5b                   	pop    %ebx
  8008ec:	5e                   	pop    %esi
  8008ed:	5f                   	pop    %edi
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f0:	f3 0f 1e fb          	endbr32 
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 18             	sub    $0x18,%esp
  8008fa:	e8 63 f7 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  8008ff:	05 01 17 00 00       	add    $0x1701,%eax
	va_list ap;

	va_start(ap, fmt);
  800904:	8d 45 14             	lea    0x14(%ebp),%eax
  800907:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80090a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80090d:	50                   	push   %eax
  80090e:	ff 75 10             	pushl  0x10(%ebp)
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	ff 75 08             	pushl  0x8(%ebp)
  800917:	e8 13 fc ff ff       	call   80052f <vprintfmt>
  80091c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80091f:	90                   	nop
  800920:	c9                   	leave  
  800921:	c3                   	ret    

00800922 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800922:	f3 0f 1e fb          	endbr32 
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	e8 34 f7 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  80092e:	05 d2 16 00 00       	add    $0x16d2,%eax
	b->cnt++;
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8b 40 08             	mov    0x8(%eax),%eax
  800939:	8d 50 01             	lea    0x1(%eax),%edx
  80093c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800942:	8b 45 0c             	mov    0xc(%ebp),%eax
  800945:	8b 10                	mov    (%eax),%edx
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094a:	8b 40 04             	mov    0x4(%eax),%eax
  80094d:	39 c2                	cmp    %eax,%edx
  80094f:	73 12                	jae    800963 <sprintputch+0x41>
		*b->buf++ = ch;
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	8d 48 01             	lea    0x1(%eax),%ecx
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	89 0a                	mov    %ecx,(%edx)
  80095e:	8b 55 08             	mov    0x8(%ebp),%edx
  800961:	88 10                	mov    %dl,(%eax)
}
  800963:	90                   	nop
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800966:	f3 0f 1e fb          	endbr32 
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	83 ec 18             	sub    $0x18,%esp
  800970:	e8 ed f6 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800975:	05 8b 16 00 00       	add    $0x168b,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
  80097a:	8b 55 08             	mov    0x8(%ebp),%edx
  80097d:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800980:	8b 55 0c             	mov    0xc(%ebp),%edx
  800983:	8d 4a ff             	lea    -0x1(%edx),%ecx
  800986:	8b 55 08             	mov    0x8(%ebp),%edx
  800989:	01 ca                	add    %ecx,%edx
  80098b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80098e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800995:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800999:	74 06                	je     8009a1 <vsnprintf+0x3b>
  80099b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80099f:	7f 07                	jg     8009a8 <vsnprintf+0x42>
		return -E_INVAL;
  8009a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009a6:	eb 22                	jmp    8009ca <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a8:	ff 75 14             	pushl  0x14(%ebp)
  8009ab:	ff 75 10             	pushl  0x10(%ebp)
  8009ae:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8009b1:	52                   	push   %edx
  8009b2:	8d 80 22 e9 ff ff    	lea    -0x16de(%eax),%eax
  8009b8:	50                   	push   %eax
  8009b9:	e8 71 fb ff ff       	call   80052f <vprintfmt>
  8009be:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009ca:	c9                   	leave  
  8009cb:	c3                   	ret    

008009cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009cc:	f3 0f 1e fb          	endbr32 
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 18             	sub    $0x18,%esp
  8009d6:	e8 87 f6 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  8009db:	05 25 16 00 00       	add    $0x1625,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e9:	50                   	push   %eax
  8009ea:	ff 75 10             	pushl  0x10(%ebp)
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	ff 75 08             	pushl  0x8(%ebp)
  8009f3:	e8 6e ff ff ff       	call   800966 <vsnprintf>
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
  8009fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <__x86.get_pc_thunk.si>:
  800a03:	8b 34 24             	mov    (%esp),%esi
  800a06:	c3                   	ret    

00800a07 <__x86.get_pc_thunk.di>:
  800a07:	8b 3c 24             	mov    (%esp),%edi
  800a0a:	c3                   	ret    

00800a0b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a0b:	f3 0f 1e fb          	endbr32 
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	83 ec 10             	sub    $0x10,%esp
  800a15:	e8 48 f6 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800a1a:	05 e6 15 00 00       	add    $0x15e6,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800a1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a26:	eb 08                	jmp    800a30 <strlen+0x25>
		n++;
  800a28:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
  800a2c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	0f b6 00             	movzbl (%eax),%eax
  800a36:	84 c0                	test   %al,%al
  800a38:	75 ee                	jne    800a28 <strlen+0x1d>
	return n;
  800a3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a3d:	c9                   	leave  
  800a3e:	c3                   	ret    

00800a3f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a3f:	f3 0f 1e fb          	endbr32 
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	83 ec 10             	sub    $0x10,%esp
  800a49:	e8 14 f6 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800a4e:	05 b2 15 00 00       	add    $0x15b2,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5a:	eb 0c                	jmp    800a68 <strnlen+0x29>
		n++;
  800a5c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a60:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a64:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800a68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a6c:	74 0a                	je     800a78 <strnlen+0x39>
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	0f b6 00             	movzbl (%eax),%eax
  800a74:	84 c0                	test   %al,%al
  800a76:	75 e4                	jne    800a5c <strnlen+0x1d>
	return n;
  800a78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    

00800a7d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a7d:	f3 0f 1e fb          	endbr32 
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 10             	sub    $0x10,%esp
  800a87:	e8 d6 f5 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800a8c:	05 74 15 00 00       	add    $0x1574,%eax
	char *ret;

	ret = dst;
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a97:	90                   	nop
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8d 42 01             	lea    0x1(%edx),%eax
  800a9e:	89 45 0c             	mov    %eax,0xc(%ebp)
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8d 48 01             	lea    0x1(%eax),%ecx
  800aa7:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800aaa:	0f b6 12             	movzbl (%edx),%edx
  800aad:	88 10                	mov    %dl,(%eax)
  800aaf:	0f b6 00             	movzbl (%eax),%eax
  800ab2:	84 c0                	test   %al,%al
  800ab4:	75 e2                	jne    800a98 <strcpy+0x1b>
		/* do nothing */;
	return ret;
  800ab6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800abb:	f3 0f 1e fb          	endbr32 
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	83 ec 10             	sub    $0x10,%esp
  800ac5:	e8 98 f5 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800aca:	05 36 15 00 00       	add    $0x1536,%eax
	int len = strlen(dst);
  800acf:	ff 75 08             	pushl  0x8(%ebp)
  800ad2:	e8 34 ff ff ff       	call   800a0b <strlen>
  800ad7:	83 c4 04             	add    $0x4,%esp
  800ada:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
  800add:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	e8 8f ff ff ff       	call   800a7d <strcpy>
  800aee:	83 c4 08             	add    $0x8,%esp
	return dst;
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800af6:	f3 0f 1e fb          	endbr32 
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	83 ec 10             	sub    $0x10,%esp
  800b00:	e8 5d f5 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800b05:	05 fb 14 00 00       	add    $0x14fb,%eax
	size_t i;
	char *ret;

	ret = dst;
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b17:	eb 23                	jmp    800b3c <strncpy+0x46>
		*dst++ = *src;
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8d 50 01             	lea    0x1(%eax),%edx
  800b1f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b25:	0f b6 12             	movzbl (%edx),%edx
  800b28:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	0f b6 00             	movzbl (%eax),%eax
  800b30:	84 c0                	test   %al,%al
  800b32:	74 04                	je     800b38 <strncpy+0x42>
			src++;
  800b34:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
  800b38:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800b3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b3f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b42:	72 d5                	jb     800b19 <strncpy+0x23>
	}
	return ret;
  800b44:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b47:	c9                   	leave  
  800b48:	c3                   	ret    

00800b49 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b49:	f3 0f 1e fb          	endbr32 
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 10             	sub    $0x10,%esp
  800b53:	e8 0a f5 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800b58:	05 a8 14 00 00       	add    $0x14a8,%eax
	char *dst_in;

	dst_in = dst;
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b67:	74 33                	je     800b9c <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
  800b69:	eb 17                	jmp    800b82 <strlcpy+0x39>
			*dst++ = *src++;
  800b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6e:	8d 42 01             	lea    0x1(%edx),%eax
  800b71:	89 45 0c             	mov    %eax,0xc(%ebp)
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	8d 48 01             	lea    0x1(%eax),%ecx
  800b7a:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800b7d:	0f b6 12             	movzbl (%edx),%edx
  800b80:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
  800b82:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b8a:	74 0a                	je     800b96 <strlcpy+0x4d>
  800b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8f:	0f b6 00             	movzbl (%eax),%eax
  800b92:	84 c0                	test   %al,%al
  800b94:	75 d5                	jne    800b6b <strlcpy+0x22>
		*dst = '\0';
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ba4:	f3 0f 1e fb          	endbr32 
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	e8 b2 f4 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800bb0:	05 50 14 00 00       	add    $0x1450,%eax
	while (*p && *p == *q)
  800bb5:	eb 08                	jmp    800bbf <strcmp+0x1b>
		p++, q++;
  800bb7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bbb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	0f b6 00             	movzbl (%eax),%eax
  800bc5:	84 c0                	test   %al,%al
  800bc7:	74 10                	je     800bd9 <strcmp+0x35>
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	0f b6 10             	movzbl (%eax),%edx
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	0f b6 00             	movzbl (%eax),%eax
  800bd5:	38 c2                	cmp    %al,%dl
  800bd7:	74 de                	je     800bb7 <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	0f b6 00             	movzbl (%eax),%eax
  800bdf:	0f b6 d0             	movzbl %al,%edx
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	0f b6 00             	movzbl (%eax),%eax
  800be8:	0f b6 c0             	movzbl %al,%eax
  800beb:	29 c2                	sub    %eax,%edx
  800bed:	89 d0                	mov    %edx,%eax
}
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bf1:	f3 0f 1e fb          	endbr32 
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	e8 65 f4 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800bfd:	05 03 14 00 00       	add    $0x1403,%eax
	while (n > 0 && *p && *p == *q)
  800c02:	eb 0c                	jmp    800c10 <strncmp+0x1f>
		n--, p++, q++;
  800c04:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800c08:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c0c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
  800c10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c14:	74 1a                	je     800c30 <strncmp+0x3f>
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	0f b6 00             	movzbl (%eax),%eax
  800c1c:	84 c0                	test   %al,%al
  800c1e:	74 10                	je     800c30 <strncmp+0x3f>
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	0f b6 10             	movzbl (%eax),%edx
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	0f b6 00             	movzbl (%eax),%eax
  800c2c:	38 c2                	cmp    %al,%dl
  800c2e:	74 d4                	je     800c04 <strncmp+0x13>
	if (n == 0)
  800c30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c34:	75 07                	jne    800c3d <strncmp+0x4c>
		return 0;
  800c36:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3b:	eb 16                	jmp    800c53 <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	0f b6 00             	movzbl (%eax),%eax
  800c43:	0f b6 d0             	movzbl %al,%edx
  800c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c49:	0f b6 00             	movzbl (%eax),%eax
  800c4c:	0f b6 c0             	movzbl %al,%eax
  800c4f:	29 c2                	sub    %eax,%edx
  800c51:	89 d0                	mov    %edx,%eax
}
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c55:	f3 0f 1e fb          	endbr32 
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	83 ec 04             	sub    $0x4,%esp
  800c5f:	e8 fe f3 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800c64:	05 9c 13 00 00       	add    $0x139c,%eax
  800c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c6f:	eb 14                	jmp    800c85 <strchr+0x30>
		if (*s == c)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	0f b6 00             	movzbl (%eax),%eax
  800c77:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800c7a:	75 05                	jne    800c81 <strchr+0x2c>
			return (char *) s;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	eb 13                	jmp    800c94 <strchr+0x3f>
	for (; *s; s++)
  800c81:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	0f b6 00             	movzbl (%eax),%eax
  800c8b:	84 c0                	test   %al,%al
  800c8d:	75 e2                	jne    800c71 <strchr+0x1c>
	return 0;
  800c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c96:	f3 0f 1e fb          	endbr32 
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 04             	sub    $0x4,%esp
  800ca0:	e8 bd f3 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800ca5:	05 5b 13 00 00       	add    $0x135b,%eax
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cb0:	eb 0f                	jmp    800cc1 <strfind+0x2b>
		if (*s == c)
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	0f b6 00             	movzbl (%eax),%eax
  800cb8:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800cbb:	74 10                	je     800ccd <strfind+0x37>
	for (; *s; s++)
  800cbd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	0f b6 00             	movzbl (%eax),%eax
  800cc7:	84 c0                	test   %al,%al
  800cc9:	75 e7                	jne    800cb2 <strfind+0x1c>
  800ccb:	eb 01                	jmp    800cce <strfind+0x38>
			break;
  800ccd:	90                   	nop
	return (char *) s;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd3:	f3 0f 1e fb          	endbr32 
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	e8 82 f3 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800ce0:	05 20 13 00 00       	add    $0x1320,%eax
	char *p;

	if (n == 0)
  800ce5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce9:	75 05                	jne    800cf0 <memset+0x1d>
		return v;
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	eb 5c                	jmp    800d4c <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	83 e0 03             	and    $0x3,%eax
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	75 41                	jne    800d3b <memset+0x68>
  800cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfd:	83 e0 03             	and    $0x3,%eax
  800d00:	85 c0                	test   %eax,%eax
  800d02:	75 37                	jne    800d3b <memset+0x68>
		c &= 0xFF;
  800d04:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	c1 e0 18             	shl    $0x18,%eax
  800d11:	89 c2                	mov    %eax,%edx
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	c1 e0 10             	shl    $0x10,%eax
  800d19:	09 c2                	or     %eax,%edx
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	c1 e0 08             	shl    $0x8,%eax
  800d21:	09 d0                	or     %edx,%eax
  800d23:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d26:	8b 45 10             	mov    0x10(%ebp),%eax
  800d29:	c1 e8 02             	shr    $0x2,%eax
  800d2c:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
  800d2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	89 d7                	mov    %edx,%edi
  800d36:	fc                   	cld    
  800d37:	f3 ab                	rep stos %eax,%es:(%edi)
  800d39:	eb 0e                	jmp    800d49 <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d44:	89 d7                	mov    %edx,%edi
  800d46:	fc                   	cld    
  800d47:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d4c:	5f                   	pop    %edi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d4f:	f3 0f 1e fb          	endbr32 
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
  800d59:	83 ec 10             	sub    $0x10,%esp
  800d5c:	e8 01 f3 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800d61:	05 9f 12 00 00       	add    $0x129f,%eax
	const char *s;
	char *d;

	s = src;
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
  800d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d75:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d78:	73 6d                	jae    800de7 <memmove+0x98>
  800d7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d80:	01 d0                	add    %edx,%eax
  800d82:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  800d85:	73 60                	jae    800de7 <memmove+0x98>
		s += n;
  800d87:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8a:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
  800d8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d90:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d96:	83 e0 03             	and    $0x3,%eax
  800d99:	85 c0                	test   %eax,%eax
  800d9b:	75 2f                	jne    800dcc <memmove+0x7d>
  800d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da0:	83 e0 03             	and    $0x3,%eax
  800da3:	85 c0                	test   %eax,%eax
  800da5:	75 25                	jne    800dcc <memmove+0x7d>
  800da7:	8b 45 10             	mov    0x10(%ebp),%eax
  800daa:	83 e0 03             	and    $0x3,%eax
  800dad:	85 c0                	test   %eax,%eax
  800daf:	75 1b                	jne    800dcc <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db4:	83 e8 04             	sub    $0x4,%eax
  800db7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800dba:	83 ea 04             	sub    $0x4,%edx
  800dbd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800dc0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800dc3:	89 c7                	mov    %eax,%edi
  800dc5:	89 d6                	mov    %edx,%esi
  800dc7:	fd                   	std    
  800dc8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dca:	eb 18                	jmp    800de4 <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dcf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd5:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
  800dd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddb:	89 d7                	mov    %edx,%edi
  800ddd:	89 de                	mov    %ebx,%esi
  800ddf:	89 c1                	mov    %eax,%ecx
  800de1:	fd                   	std    
  800de2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800de4:	fc                   	cld    
  800de5:	eb 45                	jmp    800e2c <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dea:	83 e0 03             	and    $0x3,%eax
  800ded:	85 c0                	test   %eax,%eax
  800def:	75 2b                	jne    800e1c <memmove+0xcd>
  800df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df4:	83 e0 03             	and    $0x3,%eax
  800df7:	85 c0                	test   %eax,%eax
  800df9:	75 21                	jne    800e1c <memmove+0xcd>
  800dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfe:	83 e0 03             	and    $0x3,%eax
  800e01:	85 c0                	test   %eax,%eax
  800e03:	75 17                	jne    800e1c <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e05:	8b 45 10             	mov    0x10(%ebp),%eax
  800e08:	c1 e8 02             	shr    $0x2,%eax
  800e0b:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
  800e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e13:	89 c7                	mov    %eax,%edi
  800e15:	89 d6                	mov    %edx,%esi
  800e17:	fc                   	cld    
  800e18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e1a:	eb 10                	jmp    800e2c <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
  800e1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e25:	89 c7                	mov    %eax,%edi
  800e27:	89 d6                	mov    %edx,%esi
  800e29:	fc                   	cld    
  800e2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e2f:	83 c4 10             	add    $0x10,%esp
  800e32:	5b                   	pop    %ebx
  800e33:	5e                   	pop    %esi
  800e34:	5f                   	pop    %edi
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e37:	f3 0f 1e fb          	endbr32 
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	e8 1f f2 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800e43:	05 bd 11 00 00       	add    $0x11bd,%eax
	return memmove(dst, src, n);
  800e48:	ff 75 10             	pushl  0x10(%ebp)
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	ff 75 08             	pushl  0x8(%ebp)
  800e51:	e8 f9 fe ff ff       	call   800d4f <memmove>
  800e56:	83 c4 0c             	add    $0xc,%esp
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e5b:	f3 0f 1e fb          	endbr32 
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 10             	sub    $0x10,%esp
  800e65:	e8 f8 f1 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800e6a:	05 96 11 00 00       	add    $0x1196,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e7b:	eb 30                	jmp    800ead <memcmp+0x52>
		if (*s1 != *s2)
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e80:	0f b6 10             	movzbl (%eax),%edx
  800e83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e86:	0f b6 00             	movzbl (%eax),%eax
  800e89:	38 c2                	cmp    %al,%dl
  800e8b:	74 18                	je     800ea5 <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
  800e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e90:	0f b6 00             	movzbl (%eax),%eax
  800e93:	0f b6 d0             	movzbl %al,%edx
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	0f b6 00             	movzbl (%eax),%eax
  800e9c:	0f b6 c0             	movzbl %al,%eax
  800e9f:	29 c2                	sub    %eax,%edx
  800ea1:	89 d0                	mov    %edx,%eax
  800ea3:	eb 1a                	jmp    800ebf <memcmp+0x64>
		s1++, s2++;
  800ea5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800ea9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
  800ead:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb3:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	75 c3                	jne    800e7d <memcmp+0x22>
	}

	return 0;
  800eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ec1:	f3 0f 1e fb          	endbr32 
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
  800ecb:	e8 92 f1 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800ed0:	05 30 11 00 00       	add    $0x1130,%eax
	const void *ends = (const char *) s + n;
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee0:	eb 11                	jmp    800ef3 <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	0f b6 00             	movzbl (%eax),%eax
  800ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eeb:	38 d0                	cmp    %dl,%al
  800eed:	74 0e                	je     800efd <memfind+0x3c>
	for (; s < ends; s++)
  800eef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef9:	72 e7                	jb     800ee2 <memfind+0x21>
  800efb:	eb 01                	jmp    800efe <memfind+0x3d>
			break;
  800efd:	90                   	nop
	return (void *) s;
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f03:	f3 0f 1e fb          	endbr32 
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
  800f0d:	e8 50 f1 ff ff       	call   800062 <__x86.get_pc_thunk.ax>
  800f12:	05 ee 10 00 00       	add    $0x10ee,%eax
	int neg = 0;
  800f17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f25:	eb 04                	jmp    800f2b <strtol+0x28>
		s++;
  800f27:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	0f b6 00             	movzbl (%eax),%eax
  800f31:	3c 20                	cmp    $0x20,%al
  800f33:	74 f2                	je     800f27 <strtol+0x24>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	0f b6 00             	movzbl (%eax),%eax
  800f3b:	3c 09                	cmp    $0x9,%al
  800f3d:	74 e8                	je     800f27 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	0f b6 00             	movzbl (%eax),%eax
  800f45:	3c 2b                	cmp    $0x2b,%al
  800f47:	75 06                	jne    800f4f <strtol+0x4c>
		s++;
  800f49:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f4d:	eb 15                	jmp    800f64 <strtol+0x61>
	else if (*s == '-')
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	0f b6 00             	movzbl (%eax),%eax
  800f55:	3c 2d                	cmp    $0x2d,%al
  800f57:	75 0b                	jne    800f64 <strtol+0x61>
		s++, neg = 1;
  800f59:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f5d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	74 06                	je     800f70 <strtol+0x6d>
  800f6a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6e:	75 24                	jne    800f94 <strtol+0x91>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	0f b6 00             	movzbl (%eax),%eax
  800f76:	3c 30                	cmp    $0x30,%al
  800f78:	75 1a                	jne    800f94 <strtol+0x91>
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	83 c0 01             	add    $0x1,%eax
  800f80:	0f b6 00             	movzbl (%eax),%eax
  800f83:	3c 78                	cmp    $0x78,%al
  800f85:	75 0d                	jne    800f94 <strtol+0x91>
		s += 2, base = 16;
  800f87:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f8b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f92:	eb 2a                	jmp    800fbe <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	75 17                	jne    800fb1 <strtol+0xae>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	0f b6 00             	movzbl (%eax),%eax
  800fa0:	3c 30                	cmp    $0x30,%al
  800fa2:	75 0d                	jne    800fb1 <strtol+0xae>
		s++, base = 8;
  800fa4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800fa8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800faf:	eb 0d                	jmp    800fbe <strtol+0xbb>
	else if (base == 0)
  800fb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb5:	75 07                	jne    800fbe <strtol+0xbb>
		base = 10;
  800fb7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	0f b6 00             	movzbl (%eax),%eax
  800fc4:	3c 2f                	cmp    $0x2f,%al
  800fc6:	7e 1b                	jle    800fe3 <strtol+0xe0>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	0f b6 00             	movzbl (%eax),%eax
  800fce:	3c 39                	cmp    $0x39,%al
  800fd0:	7f 11                	jg     800fe3 <strtol+0xe0>
			dig = *s - '0';
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	0f b6 00             	movzbl (%eax),%eax
  800fd8:	0f be c0             	movsbl %al,%eax
  800fdb:	83 e8 30             	sub    $0x30,%eax
  800fde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe1:	eb 48                	jmp    80102b <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	0f b6 00             	movzbl (%eax),%eax
  800fe9:	3c 60                	cmp    $0x60,%al
  800feb:	7e 1b                	jle    801008 <strtol+0x105>
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	0f b6 00             	movzbl (%eax),%eax
  800ff3:	3c 7a                	cmp    $0x7a,%al
  800ff5:	7f 11                	jg     801008 <strtol+0x105>
			dig = *s - 'a' + 10;
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	0f b6 00             	movzbl (%eax),%eax
  800ffd:	0f be c0             	movsbl %al,%eax
  801000:	83 e8 57             	sub    $0x57,%eax
  801003:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801006:	eb 23                	jmp    80102b <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	0f b6 00             	movzbl (%eax),%eax
  80100e:	3c 40                	cmp    $0x40,%al
  801010:	7e 3c                	jle    80104e <strtol+0x14b>
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	0f b6 00             	movzbl (%eax),%eax
  801018:	3c 5a                	cmp    $0x5a,%al
  80101a:	7f 32                	jg     80104e <strtol+0x14b>
			dig = *s - 'A' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	0f b6 00             	movzbl (%eax),%eax
  801022:	0f be c0             	movsbl %al,%eax
  801025:	83 e8 37             	sub    $0x37,%eax
  801028:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801031:	7d 1a                	jge    80104d <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
  801033:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801037:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103e:	89 c2                	mov    %eax,%edx
  801040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801043:	01 d0                	add    %edx,%eax
  801045:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
  801048:	e9 71 ff ff ff       	jmp    800fbe <strtol+0xbb>
			break;
  80104d:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
  80104e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801052:	74 08                	je     80105c <strtol+0x159>
		*endptr = (char *) s;
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	8b 55 08             	mov    0x8(%ebp),%edx
  80105a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80105c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801060:	74 07                	je     801069 <strtol+0x166>
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	f7 d8                	neg    %eax
  801067:	eb 03                	jmp    80106c <strtol+0x169>
  801069:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    
  80106e:	66 90                	xchg   %ax,%ax

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
