
obj/user/badsegment:     file format elf32-i386


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
  80002c:	e8 20 00 00 00       	call   800051 <libmain>
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
  80003a:	e8 0e 00 00 00       	call   80004d <__x86.get_pc_thunk.ax>
  80003f:	05 c1 1f 00 00       	add    $0x1fc1,%eax
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800044:	66 b8 28 00          	mov    $0x28,%ax
  800048:	8e d8                	mov    %eax,%ds
}
  80004a:	90                   	nop
  80004b:	5d                   	pop    %ebp
  80004c:	c3                   	ret    

0080004d <__x86.get_pc_thunk.ax>:
  80004d:	8b 04 24             	mov    (%esp),%eax
  800050:	c3                   	ret    

00800051 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800051:	f3 0f 1e fb          	endbr32 
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	53                   	push   %ebx
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	e8 5a 00 00 00       	call   8000bb <__x86.get_pc_thunk.bx>
  800061:	81 c3 9f 1f 00 00    	add    $0x1f9f,%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code h(ere.
	thisenv = envs + ENVX(sys_getenvid());
  800067:	e8 76 01 00 00       	call   8001e2 <sys_getenvid>
  80006c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800071:	89 c2                	mov    %eax,%edx
  800073:	89 d0                	mov    %edx,%eax
  800075:	01 c0                	add    %eax,%eax
  800077:	01 d0                	add    %edx,%eax
  800079:	c1 e0 05             	shl    $0x5,%eax
  80007c:	89 c2                	mov    %eax,%edx
  80007e:	c7 c0 00 00 c0 ee    	mov    $0xeec00000,%eax
  800084:	01 c2                	add    %eax,%edx
  800086:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  80008c:	89 10                	mov    %edx,(%eax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800092:	7e 0b                	jle    80009f <libmain+0x4e>
		binaryname = argv[0];
  800094:	8b 45 0c             	mov    0xc(%ebp),%eax
  800097:	8b 00                	mov    (%eax),%eax
  800099:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80009f:	83 ec 08             	sub    $0x8,%esp
  8000a2:	ff 75 0c             	pushl  0xc(%ebp)
  8000a5:	ff 75 08             	pushl  0x8(%ebp)
  8000a8:	e8 86 ff ff ff       	call   800033 <umain>
  8000ad:	83 c4 10             	add    $0x10,%esp

	// exit gracefully
	exit();
  8000b0:	e8 0a 00 00 00       	call   8000bf <exit>
}
  8000b5:	90                   	nop
  8000b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b9:	c9                   	leave  
  8000ba:	c3                   	ret    

008000bb <__x86.get_pc_thunk.bx>:
  8000bb:	8b 1c 24             	mov    (%esp),%ebx
  8000be:	c3                   	ret    

008000bf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000bf:	f3 0f 1e fb          	endbr32 
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	53                   	push   %ebx
  8000c7:	83 ec 04             	sub    $0x4,%esp
  8000ca:	e8 7e ff ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  8000cf:	05 31 1f 00 00       	add    $0x1f31,%eax
	sys_env_destroy(0);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	6a 00                	push   $0x0
  8000d9:	89 c3                	mov    %eax,%ebx
  8000db:	e8 d1 00 00 00       	call   8001b1 <sys_env_destroy>
  8000e0:	83 c4 10             	add    $0x10,%esp
}
  8000e3:	90                   	nop
  8000e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e7:	c9                   	leave  
  8000e8:	c3                   	ret    

008000e9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 2c             	sub    $0x2c,%esp
  8000f2:	e8 c4 ff ff ff       	call   8000bb <__x86.get_pc_thunk.bx>
  8000f7:	81 c3 09 1f 00 00    	add    $0x1f09,%ebx
  8000fd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800100:	8b 45 08             	mov    0x8(%ebp),%eax
  800103:	8b 55 10             	mov    0x10(%ebp),%edx
  800106:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800109:	8b 5d 18             	mov    0x18(%ebp),%ebx
  80010c:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  80010f:	8b 75 20             	mov    0x20(%ebp),%esi
  800112:	cd 30                	int    $0x30
  800114:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800117:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80011b:	74 27                	je     800144 <syscall+0x5b>
  80011d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800121:	7e 21                	jle    800144 <syscall+0x5b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	ff 75 e4             	pushl  -0x1c(%ebp)
  800129:	ff 75 08             	pushl  0x8(%ebp)
  80012c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80012f:	8d 83 ca f2 ff ff    	lea    -0xd36(%ebx),%eax
  800135:	50                   	push   %eax
  800136:	6a 23                	push   $0x23
  800138:	8d 83 e7 f2 ff ff    	lea    -0xd19(%ebx),%eax
  80013e:	50                   	push   %eax
  80013f:	e8 cd 00 00 00       	call   800211 <_panic>

	return ret;
  800144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  800147:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80014a:	5b                   	pop    %ebx
  80014b:	5e                   	pop    %esi
  80014c:	5f                   	pop    %edi
  80014d:	5d                   	pop    %ebp
  80014e:	c3                   	ret    

0080014f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80014f:	f3 0f 1e fb          	endbr32 
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	83 ec 08             	sub    $0x8,%esp
  800159:	e8 ef fe ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  80015e:	05 a2 1e 00 00       	add    $0x1ea2,%eax
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800163:	8b 45 08             	mov    0x8(%ebp),%eax
  800166:	83 ec 04             	sub    $0x4,%esp
  800169:	6a 00                	push   $0x0
  80016b:	6a 00                	push   $0x0
  80016d:	6a 00                	push   $0x0
  80016f:	ff 75 0c             	pushl  0xc(%ebp)
  800172:	50                   	push   %eax
  800173:	6a 00                	push   $0x0
  800175:	6a 00                	push   $0x0
  800177:	e8 6d ff ff ff       	call   8000e9 <syscall>
  80017c:	83 c4 20             	add    $0x20,%esp
}
  80017f:	90                   	nop
  800180:	c9                   	leave  
  800181:	c3                   	ret    

00800182 <sys_cgetc>:

int
sys_cgetc(void)
{
  800182:	f3 0f 1e fb          	endbr32 
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	83 ec 08             	sub    $0x8,%esp
  80018c:	e8 bc fe ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800191:	05 6f 1e 00 00       	add    $0x1e6f,%eax
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	6a 00                	push   $0x0
  80019b:	6a 00                	push   $0x0
  80019d:	6a 00                	push   $0x0
  80019f:	6a 00                	push   $0x0
  8001a1:	6a 00                	push   $0x0
  8001a3:	6a 00                	push   $0x0
  8001a5:	6a 01                	push   $0x1
  8001a7:	e8 3d ff ff ff       	call   8000e9 <syscall>
  8001ac:	83 c4 20             	add    $0x20,%esp
}
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    

008001b1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001b1:	f3 0f 1e fb          	endbr32 
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	e8 8d fe ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  8001c0:	05 40 1e 00 00       	add    $0x1e40,%eax
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c8:	83 ec 04             	sub    $0x4,%esp
  8001cb:	6a 00                	push   $0x0
  8001cd:	6a 00                	push   $0x0
  8001cf:	6a 00                	push   $0x0
  8001d1:	6a 00                	push   $0x0
  8001d3:	50                   	push   %eax
  8001d4:	6a 01                	push   $0x1
  8001d6:	6a 03                	push   $0x3
  8001d8:	e8 0c ff ff ff       	call   8000e9 <syscall>
  8001dd:	83 c4 20             	add    $0x20,%esp
}
  8001e0:	c9                   	leave  
  8001e1:	c3                   	ret    

008001e2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8001e2:	f3 0f 1e fb          	endbr32 
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 08             	sub    $0x8,%esp
  8001ec:	e8 5c fe ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  8001f1:	05 0f 1e 00 00       	add    $0x1e0f,%eax
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8001f6:	83 ec 04             	sub    $0x4,%esp
  8001f9:	6a 00                	push   $0x0
  8001fb:	6a 00                	push   $0x0
  8001fd:	6a 00                	push   $0x0
  8001ff:	6a 00                	push   $0x0
  800201:	6a 00                	push   $0x0
  800203:	6a 00                	push   $0x0
  800205:	6a 02                	push   $0x2
  800207:	e8 dd fe ff ff       	call   8000e9 <syscall>
  80020c:	83 c4 20             	add    $0x20,%esp
}
  80020f:	c9                   	leave  
  800210:	c3                   	ret    

00800211 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800211:	f3 0f 1e fb          	endbr32 
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	56                   	push   %esi
  800219:	53                   	push   %ebx
  80021a:	83 ec 10             	sub    $0x10,%esp
  80021d:	e8 99 fe ff ff       	call   8000bb <__x86.get_pc_thunk.bx>
  800222:	81 c3 de 1d 00 00    	add    $0x1dde,%ebx
	va_list ap;

	va_start(ap, fmt);
  800228:	8d 45 14             	lea    0x14(%ebp),%eax
  80022b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80022e:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800234:	8b 30                	mov    (%eax),%esi
  800236:	e8 a7 ff ff ff       	call   8001e2 <sys_getenvid>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	ff 75 0c             	pushl  0xc(%ebp)
  800241:	ff 75 08             	pushl  0x8(%ebp)
  800244:	56                   	push   %esi
  800245:	50                   	push   %eax
  800246:	8d 83 f8 f2 ff ff    	lea    -0xd08(%ebx),%eax
  80024c:	50                   	push   %eax
  80024d:	e8 0f 01 00 00       	call   800361 <cprintf>
  800252:	83 c4 20             	add    $0x20,%esp
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	50                   	push   %eax
  80025c:	ff 75 10             	pushl  0x10(%ebp)
  80025f:	e8 8d 00 00 00       	call   8002f1 <vcprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	8d 83 1b f3 ff ff    	lea    -0xce5(%ebx),%eax
  800270:	50                   	push   %eax
  800271:	e8 eb 00 00 00       	call   800361 <cprintf>
  800276:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800279:	cc                   	int3   
  80027a:	eb fd                	jmp    800279 <_panic+0x68>

0080027c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80027c:	f3 0f 1e fb          	endbr32 
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	53                   	push   %ebx
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	e8 09 01 00 00       	call   800395 <__x86.get_pc_thunk.dx>
  80028c:	81 c2 74 1d 00 00    	add    $0x1d74,%edx
	b->buf[b->idx++] = ch;
  800292:	8b 45 0c             	mov    0xc(%ebp),%eax
  800295:	8b 00                	mov    (%eax),%eax
  800297:	8d 58 01             	lea    0x1(%eax),%ebx
  80029a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80029d:	89 19                	mov    %ebx,(%ecx)
  80029f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a2:	89 cb                	mov    %ecx,%ebx
  8002a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a7:	88 5c 01 08          	mov    %bl,0x8(%ecx,%eax,1)
	if (b->idx == 256-1) {
  8002ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b5:	75 25                	jne    8002dc <putch+0x60>
		sys_cputs(b->buf, b->idx);
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	8b 00                	mov    (%eax),%eax
  8002bc:	89 c1                	mov    %eax,%ecx
  8002be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c1:	83 c0 08             	add    $0x8,%eax
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	51                   	push   %ecx
  8002c8:	50                   	push   %eax
  8002c9:	89 d3                	mov    %edx,%ebx
  8002cb:	e8 7f fe ff ff       	call   80014f <sys_cputs>
  8002d0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002df:	8b 40 04             	mov    0x4(%eax),%eax
  8002e2:	8d 50 01             	lea    0x1(%eax),%edx
  8002e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002eb:	90                   	nop
  8002ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002f1:	f3 0f 1e fb          	endbr32 
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	53                   	push   %ebx
  8002f9:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8002ff:	e8 b7 fd ff ff       	call   8000bb <__x86.get_pc_thunk.bx>
  800304:	81 c3 fc 1c 00 00    	add    $0x1cfc,%ebx
	struct printbuf b;

	b.idx = 0;
  80030a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800311:	00 00 00 
	b.cnt = 0;
  800314:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80031b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032a:	50                   	push   %eax
  80032b:	8d 83 7c e2 ff ff    	lea    -0x1d84(%ebx),%eax
  800331:	50                   	push   %eax
  800332:	e8 e3 01 00 00       	call   80051a <vprintfmt>
  800337:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  80033a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800340:	83 ec 08             	sub    $0x8,%esp
  800343:	50                   	push   %eax
  800344:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034a:	83 c0 08             	add    $0x8,%eax
  80034d:	50                   	push   %eax
  80034e:	e8 fc fd ff ff       	call   80014f <sys_cputs>
  800353:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800356:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80035c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035f:	c9                   	leave  
  800360:	c3                   	ret    

00800361 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800361:	f3 0f 1e fb          	endbr32 
  800365:	55                   	push   %ebp
  800366:	89 e5                	mov    %esp,%ebp
  800368:	83 ec 18             	sub    $0x18,%esp
  80036b:	e8 dd fc ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800370:	05 90 1c 00 00       	add    $0x1c90,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800375:	8d 45 0c             	lea    0xc(%ebp),%eax
  800378:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
  80037b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	50                   	push   %eax
  800382:	ff 75 08             	pushl  0x8(%ebp)
  800385:	e8 67 ff ff ff       	call   8002f1 <vcprintf>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
  800390:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800393:	c9                   	leave  
  800394:	c3                   	ret    

00800395 <__x86.get_pc_thunk.dx>:
  800395:	8b 14 24             	mov    (%esp),%edx
  800398:	c3                   	ret    

00800399 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800399:	f3 0f 1e fb          	endbr32 
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	57                   	push   %edi
  8003a1:	56                   	push   %esi
  8003a2:	53                   	push   %ebx
  8003a3:	83 ec 1c             	sub    $0x1c,%esp
  8003a6:	e8 43 06 00 00       	call   8009ee <__x86.get_pc_thunk.si>
  8003ab:	81 c6 55 1c 00 00    	add    $0x1c55,%esi
  8003b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003bd:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003c8:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8003cb:	19 d1                	sbb    %edx,%ecx
  8003cd:	72 4d                	jb     80041c <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d2:	8d 78 ff             	lea    -0x1(%eax),%edi
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	52                   	push   %edx
  8003de:	50                   	push   %eax
  8003df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e5:	89 f3                	mov    %esi,%ebx
  8003e7:	e8 74 0c 00 00       	call   801060 <__udivdi3>
  8003ec:	83 c4 10             	add    $0x10,%esp
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	ff 75 20             	pushl  0x20(%ebp)
  8003f5:	57                   	push   %edi
  8003f6:	ff 75 18             	pushl  0x18(%ebp)
  8003f9:	52                   	push   %edx
  8003fa:	50                   	push   %eax
  8003fb:	ff 75 0c             	pushl  0xc(%ebp)
  8003fe:	ff 75 08             	pushl  0x8(%ebp)
  800401:	e8 93 ff ff ff       	call   800399 <printnum>
  800406:	83 c4 20             	add    $0x20,%esp
  800409:	eb 1b                	jmp    800426 <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	ff 75 0c             	pushl  0xc(%ebp)
  800411:	ff 75 20             	pushl  0x20(%ebp)
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	ff d0                	call   *%eax
  800419:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80041c:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  800420:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800424:	7f e5                	jg     80040b <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800426:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800429:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800431:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800434:	53                   	push   %ebx
  800435:	51                   	push   %ecx
  800436:	52                   	push   %edx
  800437:	50                   	push   %eax
  800438:	89 f3                	mov    %esi,%ebx
  80043a:	e8 31 0d 00 00       	call   801170 <__umoddi3>
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	8d 8e 89 f3 ff ff    	lea    -0xc77(%esi),%ecx
  800448:	01 c8                	add    %ecx,%eax
  80044a:	0f b6 00             	movzbl (%eax),%eax
  80044d:	0f be c0             	movsbl %al,%eax
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	ff 75 0c             	pushl  0xc(%ebp)
  800456:	50                   	push   %eax
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	ff d0                	call   *%eax
  80045c:	83 c4 10             	add    $0x10,%esp
}
  80045f:	90                   	nop
  800460:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800463:	5b                   	pop    %ebx
  800464:	5e                   	pop    %esi
  800465:	5f                   	pop    %edi
  800466:	5d                   	pop    %ebp
  800467:	c3                   	ret    

00800468 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800468:	f3 0f 1e fb          	endbr32 
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	e8 d9 fb ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800474:	05 8c 1b 00 00       	add    $0x1b8c,%eax
	if (lflag >= 2)
  800479:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80047d:	7e 14                	jle    800493 <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	8b 00                	mov    (%eax),%eax
  800484:	8d 48 08             	lea    0x8(%eax),%ecx
  800487:	8b 55 08             	mov    0x8(%ebp),%edx
  80048a:	89 0a                	mov    %ecx,(%edx)
  80048c:	8b 50 04             	mov    0x4(%eax),%edx
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	eb 30                	jmp    8004c3 <getuint+0x5b>
	else if (lflag)
  800493:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800497:	74 16                	je     8004af <getuint+0x47>
		return va_arg(*ap, unsigned long);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 48 04             	lea    0x4(%eax),%ecx
  8004a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a4:	89 0a                	mov    %ecx,(%edx)
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ad:	eb 14                	jmp    8004c3 <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	8d 48 04             	lea    0x4(%eax),%ecx
  8004b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ba:	89 0a                	mov    %ecx,(%edx)
  8004bc:	8b 00                	mov    (%eax),%eax
  8004be:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c3:	5d                   	pop    %ebp
  8004c4:	c3                   	ret    

008004c5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c5:	f3 0f 1e fb          	endbr32 
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	e8 7c fb ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  8004d1:	05 2f 1b 00 00       	add    $0x1b2f,%eax
	if (lflag >= 2)
  8004d6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004da:	7e 14                	jle    8004f0 <getint+0x2b>
		return va_arg(*ap, long long);
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	8d 48 08             	lea    0x8(%eax),%ecx
  8004e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e7:	89 0a                	mov    %ecx,(%edx)
  8004e9:	8b 50 04             	mov    0x4(%eax),%edx
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	eb 28                	jmp    800518 <getint+0x53>
	else if (lflag)
  8004f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f4:	74 12                	je     800508 <getint+0x43>
		return va_arg(*ap, long);
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	8d 48 04             	lea    0x4(%eax),%ecx
  8004fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800501:	89 0a                	mov    %ecx,(%edx)
  800503:	8b 00                	mov    (%eax),%eax
  800505:	99                   	cltd   
  800506:	eb 10                	jmp    800518 <getint+0x53>
	else
		return va_arg(*ap, int);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 48 04             	lea    0x4(%eax),%ecx
  800510:	8b 55 08             	mov    0x8(%ebp),%edx
  800513:	89 0a                	mov    %ecx,(%edx)
  800515:	8b 00                	mov    (%eax),%eax
  800517:	99                   	cltd   
}
  800518:	5d                   	pop    %ebp
  800519:	c3                   	ret    

0080051a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80051a:	f3 0f 1e fb          	endbr32 
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	57                   	push   %edi
  800522:	56                   	push   %esi
  800523:	53                   	push   %ebx
  800524:	83 ec 2c             	sub    $0x2c,%esp
  800527:	e8 c6 04 00 00       	call   8009f2 <__x86.get_pc_thunk.di>
  80052c:	81 c7 d4 1a 00 00    	add    $0x1ad4,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800532:	eb 17                	jmp    80054b <vprintfmt+0x31>
			if (ch == '\0')
  800534:	85 db                	test   %ebx,%ebx
  800536:	0f 84 96 03 00 00    	je     8008d2 <.L20+0x2d>
				return;
			putch(ch, putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 0c             	pushl  0xc(%ebp)
  800542:	53                   	push   %ebx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	ff d0                	call   *%eax
  800548:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80054b:	8b 45 10             	mov    0x10(%ebp),%eax
  80054e:	8d 50 01             	lea    0x1(%eax),%edx
  800551:	89 55 10             	mov    %edx,0x10(%ebp)
  800554:	0f b6 00             	movzbl (%eax),%eax
  800557:	0f b6 d8             	movzbl %al,%ebx
  80055a:	83 fb 25             	cmp    $0x25,%ebx
  80055d:	75 d5                	jne    800534 <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
  80055f:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
  800563:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
  80056a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
  800571:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
  800578:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057f:	8b 45 10             	mov    0x10(%ebp),%eax
  800582:	8d 50 01             	lea    0x1(%eax),%edx
  800585:	89 55 10             	mov    %edx,0x10(%ebp)
  800588:	0f b6 00             	movzbl (%eax),%eax
  80058b:	0f b6 d8             	movzbl %al,%ebx
  80058e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800591:	83 f8 55             	cmp    $0x55,%eax
  800594:	0f 87 0b 03 00 00    	ja     8008a5 <.L20>
  80059a:	c1 e0 02             	shl    $0x2,%eax
  80059d:	8b 84 38 b0 f3 ff ff 	mov    -0xc50(%eax,%edi,1),%eax
  8005a4:	01 f8                	add    %edi,%eax
  8005a6:	3e ff e0             	notrack jmp *%eax

008005a9 <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a9:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
  8005ad:	eb d0                	jmp    80057f <vprintfmt+0x65>

008005af <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005af:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
  8005b3:	eb ca                	jmp    80057f <vprintfmt+0x65>

008005b5 <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
  8005bc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	c1 e0 02             	shl    $0x2,%eax
  8005c4:	01 d0                	add    %edx,%eax
  8005c6:	01 c0                	add    %eax,%eax
  8005c8:	01 d8                	add    %ebx,%eax
  8005ca:	83 e8 30             	sub    $0x30,%eax
  8005cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
  8005d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d3:	0f b6 00             	movzbl (%eax),%eax
  8005d6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005d9:	83 fb 2f             	cmp    $0x2f,%ebx
  8005dc:	7e 39                	jle    800617 <.L37+0xc>
  8005de:	83 fb 39             	cmp    $0x39,%ebx
  8005e1:	7f 34                	jg     800617 <.L37+0xc>
			for (precision = 0; ; ++fmt) {
  8005e3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
  8005e7:	eb d3                	jmp    8005bc <.L31+0x7>

008005e9 <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8d 50 04             	lea    0x4(%eax),%edx
  8005ef:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
  8005f7:	eb 1f                	jmp    800618 <.L37+0xd>

008005f9 <.L33>:

		case '.':
			if (width < 0)
  8005f9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005fd:	79 80                	jns    80057f <vprintfmt+0x65>
				width = 0;
  8005ff:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
  800606:	e9 74 ff ff ff       	jmp    80057f <vprintfmt+0x65>

0080060b <.L37>:

		case '#':
			altflag = 1;
  80060b:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
  800612:	e9 68 ff ff ff       	jmp    80057f <vprintfmt+0x65>
			goto process_precision;
  800617:	90                   	nop

		process_precision:
			if (width < 0)
  800618:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80061c:	0f 89 5d ff ff ff    	jns    80057f <vprintfmt+0x65>
				width = precision, precision = -1;
  800622:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800625:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800628:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
  80062f:	e9 4b ff ff ff       	jmp    80057f <vprintfmt+0x65>

00800634 <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800634:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
  800638:	e9 42 ff ff ff       	jmp    80057f <vprintfmt+0x65>

0080063d <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8d 50 04             	lea    0x4(%eax),%edx
  800643:	89 55 14             	mov    %edx,0x14(%ebp)
  800646:	8b 00                	mov    (%eax),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 0c             	pushl  0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
			break;
  800657:	e9 71 02 00 00       	jmp    8008cd <.L20+0x28>

0080065c <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8d 50 04             	lea    0x4(%eax),%edx
  800662:	89 55 14             	mov    %edx,0x14(%ebp)
  800665:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800667:	85 db                	test   %ebx,%ebx
  800669:	79 02                	jns    80066d <.L28+0x11>
				err = -err;
  80066b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80066d:	83 fb 06             	cmp    $0x6,%ebx
  800670:	7f 0b                	jg     80067d <.L28+0x21>
  800672:	8b b4 9f 10 00 00 00 	mov    0x10(%edi,%ebx,4),%esi
  800679:	85 f6                	test   %esi,%esi
  80067b:	75 1b                	jne    800698 <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
  80067d:	53                   	push   %ebx
  80067e:	8d 87 9a f3 ff ff    	lea    -0xc66(%edi),%eax
  800684:	50                   	push   %eax
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	ff 75 08             	pushl  0x8(%ebp)
  80068b:	e8 4b 02 00 00       	call   8008db <printfmt>
  800690:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800693:	e9 35 02 00 00       	jmp    8008cd <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
  800698:	56                   	push   %esi
  800699:	8d 87 a3 f3 ff ff    	lea    -0xc5d(%edi),%eax
  80069f:	50                   	push   %eax
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	ff 75 08             	pushl  0x8(%ebp)
  8006a6:	e8 30 02 00 00       	call   8008db <printfmt>
  8006ab:	83 c4 10             	add    $0x10,%esp
			break;
  8006ae:	e9 1a 02 00 00       	jmp    8008cd <.L20+0x28>

008006b3 <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8d 50 04             	lea    0x4(%eax),%edx
  8006b9:	89 55 14             	mov    %edx,0x14(%ebp)
  8006bc:	8b 30                	mov    (%eax),%esi
  8006be:	85 f6                	test   %esi,%esi
  8006c0:	75 06                	jne    8006c8 <.L24+0x15>
				p = "(null)";
  8006c2:	8d b7 a6 f3 ff ff    	lea    -0xc5a(%edi),%esi
			if (width > 0 && padc != '-')
  8006c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006cc:	7e 71                	jle    80073f <.L24+0x8c>
  8006ce:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  8006d2:	74 6b                	je     80073f <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	50                   	push   %eax
  8006db:	56                   	push   %esi
  8006dc:	89 fb                	mov    %edi,%ebx
  8006de:	e8 47 03 00 00       	call   800a2a <strnlen>
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	29 45 d4             	sub    %eax,-0x2c(%ebp)
  8006e9:	eb 17                	jmp    800702 <.L24+0x4f>
					putch(padc, putdat);
  8006eb:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	50                   	push   %eax
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	ff d0                	call   *%eax
  8006fb:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fe:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800702:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800706:	7f e3                	jg     8006eb <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800708:	eb 35                	jmp    80073f <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
  80070a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80070e:	74 1c                	je     80072c <.L24+0x79>
  800710:	83 fb 1f             	cmp    $0x1f,%ebx
  800713:	7e 05                	jle    80071a <.L24+0x67>
  800715:	83 fb 7e             	cmp    $0x7e,%ebx
  800718:	7e 12                	jle    80072c <.L24+0x79>
					putch('?', putdat);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 0c             	pushl  0xc(%ebp)
  800720:	6a 3f                	push   $0x3f
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	ff d0                	call   *%eax
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	eb 0f                	jmp    80073b <.L24+0x88>
				else
					putch(ch, putdat);
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	ff 75 0c             	pushl  0xc(%ebp)
  800732:	53                   	push   %ebx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	ff d0                	call   *%eax
  800738:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80073b:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  80073f:	89 f0                	mov    %esi,%eax
  800741:	8d 70 01             	lea    0x1(%eax),%esi
  800744:	0f b6 00             	movzbl (%eax),%eax
  800747:	0f be d8             	movsbl %al,%ebx
  80074a:	85 db                	test   %ebx,%ebx
  80074c:	74 26                	je     800774 <.L24+0xc1>
  80074e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800752:	78 b6                	js     80070a <.L24+0x57>
  800754:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  800758:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80075c:	79 ac                	jns    80070a <.L24+0x57>
			for (; width > 0; width--)
  80075e:	eb 14                	jmp    800774 <.L24+0xc1>
				putch(' ', putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	ff 75 0c             	pushl  0xc(%ebp)
  800766:	6a 20                	push   $0x20
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	ff d0                	call   *%eax
  80076d:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
  800770:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800774:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800778:	7f e6                	jg     800760 <.L24+0xad>
			break;
  80077a:	e9 4e 01 00 00       	jmp    8008cd <.L20+0x28>

0080077f <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 d8             	pushl  -0x28(%ebp)
  800785:	8d 45 14             	lea    0x14(%ebp),%eax
  800788:	50                   	push   %eax
  800789:	e8 37 fd ff ff       	call   8004c5 <getint>
  80078e:	83 c4 10             	add    $0x10,%esp
  800791:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800794:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
  800797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80079a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80079d:	85 d2                	test   %edx,%edx
  80079f:	79 23                	jns    8007c4 <.L29+0x45>
				putch('-', putdat);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	6a 2d                	push   $0x2d
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	ff d0                	call   *%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b7:	f7 d8                	neg    %eax
  8007b9:	83 d2 00             	adc    $0x0,%edx
  8007bc:	f7 da                	neg    %edx
  8007be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
  8007c4:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007cb:	e9 9f 00 00 00       	jmp    80086f <.L21+0x1f>

008007d0 <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8007d6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d9:	50                   	push   %eax
  8007da:	e8 89 fc ff ff       	call   800468 <getuint>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
  8007e8:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007ef:	eb 7e                	jmp    80086f <.L21+0x1f>

008007f1 <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8007f7:	8d 45 14             	lea    0x14(%ebp),%eax
  8007fa:	50                   	push   %eax
  8007fb:	e8 68 fc ff ff       	call   800468 <getuint>
  800800:	83 c4 10             	add    $0x10,%esp
  800803:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800806:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
  800809:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
  800810:	eb 5d                	jmp    80086f <.L21+0x1f>

00800812 <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	6a 30                	push   $0x30
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	6a 78                	push   $0x78
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8d 50 04             	lea    0x4(%eax),%edx
  800838:	89 55 14             	mov    %edx,0x14(%ebp)
  80083b:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
  80083d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800840:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
  800847:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
  80084e:	eb 1f                	jmp    80086f <.L21+0x1f>

00800850 <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800850:	83 ec 08             	sub    $0x8,%esp
  800853:	ff 75 d8             	pushl  -0x28(%ebp)
  800856:	8d 45 14             	lea    0x14(%ebp),%eax
  800859:	50                   	push   %eax
  80085a:	e8 09 fc ff ff       	call   800468 <getuint>
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800865:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
  800868:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80086f:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  800873:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800876:	83 ec 04             	sub    $0x4,%esp
  800879:	52                   	push   %edx
  80087a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80087d:	50                   	push   %eax
  80087e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800881:	ff 75 e0             	pushl  -0x20(%ebp)
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	ff 75 08             	pushl  0x8(%ebp)
  80088a:	e8 0a fb ff ff       	call   800399 <printnum>
  80088f:	83 c4 20             	add    $0x20,%esp
			break;
  800892:	eb 39                	jmp    8008cd <.L20+0x28>

00800894 <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
			break;
  8008a3:	eb 28                	jmp    8008cd <.L20+0x28>

008008a5 <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	6a 25                	push   $0x25
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	ff d0                	call   *%eax
  8008b2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008b9:	eb 04                	jmp    8008bf <.L20+0x1a>
  8008bb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c2:	83 e8 01             	sub    $0x1,%eax
  8008c5:	0f b6 00             	movzbl (%eax),%eax
  8008c8:	3c 25                	cmp    $0x25,%al
  8008ca:	75 ef                	jne    8008bb <.L20+0x16>
				/* do nothing */;
			break;
  8008cc:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cd:	e9 79 fc ff ff       	jmp    80054b <vprintfmt+0x31>
				return;
  8008d2:	90                   	nop
		}
	}
}
  8008d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008d6:	5b                   	pop    %ebx
  8008d7:	5e                   	pop    %esi
  8008d8:	5f                   	pop    %edi
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008db:	f3 0f 1e fb          	endbr32 
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	83 ec 18             	sub    $0x18,%esp
  8008e5:	e8 63 f7 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  8008ea:	05 16 17 00 00       	add    $0x1716,%eax
	va_list ap;

	va_start(ap, fmt);
  8008ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f8:	50                   	push   %eax
  8008f9:	ff 75 10             	pushl  0x10(%ebp)
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	ff 75 08             	pushl  0x8(%ebp)
  800902:	e8 13 fc ff ff       	call   80051a <vprintfmt>
  800907:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090a:	90                   	nop
  80090b:	c9                   	leave  
  80090c:	c3                   	ret    

0080090d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80090d:	f3 0f 1e fb          	endbr32 
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	e8 34 f7 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800919:	05 e7 16 00 00       	add    $0x16e7,%eax
	b->cnt++;
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	8b 40 08             	mov    0x8(%eax),%eax
  800924:	8d 50 01             	lea    0x1(%eax),%edx
  800927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80092d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800930:	8b 10                	mov    (%eax),%edx
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	8b 40 04             	mov    0x4(%eax),%eax
  800938:	39 c2                	cmp    %eax,%edx
  80093a:	73 12                	jae    80094e <sprintputch+0x41>
		*b->buf++ = ch;
  80093c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	8d 48 01             	lea    0x1(%eax),%ecx
  800944:	8b 55 0c             	mov    0xc(%ebp),%edx
  800947:	89 0a                	mov    %ecx,(%edx)
  800949:	8b 55 08             	mov    0x8(%ebp),%edx
  80094c:	88 10                	mov    %dl,(%eax)
}
  80094e:	90                   	nop
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800951:	f3 0f 1e fb          	endbr32 
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	83 ec 18             	sub    $0x18,%esp
  80095b:	e8 ed f6 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800960:	05 a0 16 00 00       	add    $0x16a0,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
  800965:	8b 55 08             	mov    0x8(%ebp),%edx
  800968:	89 55 ec             	mov    %edx,-0x14(%ebp)
  80096b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096e:	8d 4a ff             	lea    -0x1(%edx),%ecx
  800971:	8b 55 08             	mov    0x8(%ebp),%edx
  800974:	01 ca                	add    %ecx,%edx
  800976:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800979:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800980:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800984:	74 06                	je     80098c <vsnprintf+0x3b>
  800986:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098a:	7f 07                	jg     800993 <vsnprintf+0x42>
		return -E_INVAL;
  80098c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800991:	eb 22                	jmp    8009b5 <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800993:	ff 75 14             	pushl  0x14(%ebp)
  800996:	ff 75 10             	pushl  0x10(%ebp)
  800999:	8d 55 ec             	lea    -0x14(%ebp),%edx
  80099c:	52                   	push   %edx
  80099d:	8d 80 0d e9 ff ff    	lea    -0x16f3(%eax),%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 71 fb ff ff       	call   80051a <vprintfmt>
  8009a9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009af:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b7:	f3 0f 1e fb          	endbr32 
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	83 ec 18             	sub    $0x18,%esp
  8009c1:	e8 87 f6 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  8009c6:	05 3a 16 00 00       	add    $0x163a,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d4:	50                   	push   %eax
  8009d5:	ff 75 10             	pushl  0x10(%ebp)
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	ff 75 08             	pushl  0x8(%ebp)
  8009de:	e8 6e ff ff ff       	call   800951 <vsnprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
  8009e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
  8009e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    

008009ee <__x86.get_pc_thunk.si>:
  8009ee:	8b 34 24             	mov    (%esp),%esi
  8009f1:	c3                   	ret    

008009f2 <__x86.get_pc_thunk.di>:
  8009f2:	8b 3c 24             	mov    (%esp),%edi
  8009f5:	c3                   	ret    

008009f6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f6:	f3 0f 1e fb          	endbr32 
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	83 ec 10             	sub    $0x10,%esp
  800a00:	e8 48 f6 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800a05:	05 fb 15 00 00       	add    $0x15fb,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a11:	eb 08                	jmp    800a1b <strlen+0x25>
		n++;
  800a13:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
  800a17:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	0f b6 00             	movzbl (%eax),%eax
  800a21:	84 c0                	test   %al,%al
  800a23:	75 ee                	jne    800a13 <strlen+0x1d>
	return n;
  800a25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a2a:	f3 0f 1e fb          	endbr32 
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	83 ec 10             	sub    $0x10,%esp
  800a34:	e8 14 f6 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800a39:	05 c7 15 00 00       	add    $0x15c7,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a45:	eb 0c                	jmp    800a53 <strnlen+0x29>
		n++;
  800a47:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a4b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a4f:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800a53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a57:	74 0a                	je     800a63 <strnlen+0x39>
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	0f b6 00             	movzbl (%eax),%eax
  800a5f:	84 c0                	test   %al,%al
  800a61:	75 e4                	jne    800a47 <strnlen+0x1d>
	return n;
  800a63:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a66:	c9                   	leave  
  800a67:	c3                   	ret    

00800a68 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a68:	f3 0f 1e fb          	endbr32 
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 10             	sub    $0x10,%esp
  800a72:	e8 d6 f5 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800a77:	05 89 15 00 00       	add    $0x1589,%eax
	char *ret;

	ret = dst;
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a82:	90                   	nop
  800a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a86:	8d 42 01             	lea    0x1(%edx),%eax
  800a89:	89 45 0c             	mov    %eax,0xc(%ebp)
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8d 48 01             	lea    0x1(%eax),%ecx
  800a92:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800a95:	0f b6 12             	movzbl (%edx),%edx
  800a98:	88 10                	mov    %dl,(%eax)
  800a9a:	0f b6 00             	movzbl (%eax),%eax
  800a9d:	84 c0                	test   %al,%al
  800a9f:	75 e2                	jne    800a83 <strcpy+0x1b>
		/* do nothing */;
	return ret;
  800aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aa4:	c9                   	leave  
  800aa5:	c3                   	ret    

00800aa6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800aa6:	f3 0f 1e fb          	endbr32 
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	83 ec 10             	sub    $0x10,%esp
  800ab0:	e8 98 f5 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800ab5:	05 4b 15 00 00       	add    $0x154b,%eax
	int len = strlen(dst);
  800aba:	ff 75 08             	pushl  0x8(%ebp)
  800abd:	e8 34 ff ff ff       	call   8009f6 <strlen>
  800ac2:	83 c4 04             	add    $0x4,%esp
  800ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
  800ac8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	01 d0                	add    %edx,%eax
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	50                   	push   %eax
  800ad4:	e8 8f ff ff ff       	call   800a68 <strcpy>
  800ad9:	83 c4 08             	add    $0x8,%esp
	return dst;
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800adf:	c9                   	leave  
  800ae0:	c3                   	ret    

00800ae1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ae1:	f3 0f 1e fb          	endbr32 
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	83 ec 10             	sub    $0x10,%esp
  800aeb:	e8 5d f5 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800af0:	05 10 15 00 00       	add    $0x1510,%eax
	size_t i;
	char *ret;

	ret = dst;
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800afb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b02:	eb 23                	jmp    800b27 <strncpy+0x46>
		*dst++ = *src;
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8d 50 01             	lea    0x1(%eax),%edx
  800b0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	0f b6 12             	movzbl (%edx),%edx
  800b13:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	0f b6 00             	movzbl (%eax),%eax
  800b1b:	84 c0                	test   %al,%al
  800b1d:	74 04                	je     800b23 <strncpy+0x42>
			src++;
  800b1f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
  800b23:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800b27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b2a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b2d:	72 d5                	jb     800b04 <strncpy+0x23>
	}
	return ret;
  800b2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b34:	f3 0f 1e fb          	endbr32 
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	83 ec 10             	sub    $0x10,%esp
  800b3e:	e8 0a f5 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800b43:	05 bd 14 00 00       	add    $0x14bd,%eax
	char *dst_in;

	dst_in = dst;
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b52:	74 33                	je     800b87 <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
  800b54:	eb 17                	jmp    800b6d <strlcpy+0x39>
			*dst++ = *src++;
  800b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b59:	8d 42 01             	lea    0x1(%edx),%eax
  800b5c:	89 45 0c             	mov    %eax,0xc(%ebp)
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8d 48 01             	lea    0x1(%eax),%ecx
  800b65:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800b68:	0f b6 12             	movzbl (%edx),%edx
  800b6b:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
  800b6d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b75:	74 0a                	je     800b81 <strlcpy+0x4d>
  800b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7a:	0f b6 00             	movzbl (%eax),%eax
  800b7d:	84 c0                	test   %al,%al
  800b7f:	75 d5                	jne    800b56 <strlcpy+0x22>
		*dst = '\0';
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
  800b8d:	c9                   	leave  
  800b8e:	c3                   	ret    

00800b8f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b8f:	f3 0f 1e fb          	endbr32 
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	e8 b2 f4 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800b9b:	05 65 14 00 00       	add    $0x1465,%eax
	while (*p && *p == *q)
  800ba0:	eb 08                	jmp    800baa <strcmp+0x1b>
		p++, q++;
  800ba2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ba6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	0f b6 00             	movzbl (%eax),%eax
  800bb0:	84 c0                	test   %al,%al
  800bb2:	74 10                	je     800bc4 <strcmp+0x35>
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	0f b6 10             	movzbl (%eax),%edx
  800bba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbd:	0f b6 00             	movzbl (%eax),%eax
  800bc0:	38 c2                	cmp    %al,%dl
  800bc2:	74 de                	je     800ba2 <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	0f b6 00             	movzbl (%eax),%eax
  800bca:	0f b6 d0             	movzbl %al,%edx
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	0f b6 00             	movzbl (%eax),%eax
  800bd3:	0f b6 c0             	movzbl %al,%eax
  800bd6:	29 c2                	sub    %eax,%edx
  800bd8:	89 d0                	mov    %edx,%eax
}
  800bda:	5d                   	pop    %ebp
  800bdb:	c3                   	ret    

00800bdc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bdc:	f3 0f 1e fb          	endbr32 
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	e8 65 f4 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800be8:	05 18 14 00 00       	add    $0x1418,%eax
	while (n > 0 && *p && *p == *q)
  800bed:	eb 0c                	jmp    800bfb <strncmp+0x1f>
		n--, p++, q++;
  800bef:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800bf3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bf7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
  800bfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bff:	74 1a                	je     800c1b <strncmp+0x3f>
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	0f b6 00             	movzbl (%eax),%eax
  800c07:	84 c0                	test   %al,%al
  800c09:	74 10                	je     800c1b <strncmp+0x3f>
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	0f b6 10             	movzbl (%eax),%edx
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	0f b6 00             	movzbl (%eax),%eax
  800c17:	38 c2                	cmp    %al,%dl
  800c19:	74 d4                	je     800bef <strncmp+0x13>
	if (n == 0)
  800c1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c1f:	75 07                	jne    800c28 <strncmp+0x4c>
		return 0;
  800c21:	b8 00 00 00 00       	mov    $0x0,%eax
  800c26:	eb 16                	jmp    800c3e <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	0f b6 00             	movzbl (%eax),%eax
  800c2e:	0f b6 d0             	movzbl %al,%edx
  800c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c34:	0f b6 00             	movzbl (%eax),%eax
  800c37:	0f b6 c0             	movzbl %al,%eax
  800c3a:	29 c2                	sub    %eax,%edx
  800c3c:	89 d0                	mov    %edx,%eax
}
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c40:	f3 0f 1e fb          	endbr32 
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 04             	sub    $0x4,%esp
  800c4a:	e8 fe f3 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800c4f:	05 b1 13 00 00       	add    $0x13b1,%eax
  800c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c57:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c5a:	eb 14                	jmp    800c70 <strchr+0x30>
		if (*s == c)
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	0f b6 00             	movzbl (%eax),%eax
  800c62:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800c65:	75 05                	jne    800c6c <strchr+0x2c>
			return (char *) s;
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	eb 13                	jmp    800c7f <strchr+0x3f>
	for (; *s; s++)
  800c6c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	0f b6 00             	movzbl (%eax),%eax
  800c76:	84 c0                	test   %al,%al
  800c78:	75 e2                	jne    800c5c <strchr+0x1c>
	return 0;
  800c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c81:	f3 0f 1e fb          	endbr32 
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	83 ec 04             	sub    $0x4,%esp
  800c8b:	e8 bd f3 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800c90:	05 70 13 00 00       	add    $0x1370,%eax
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c9b:	eb 0f                	jmp    800cac <strfind+0x2b>
		if (*s == c)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	0f b6 00             	movzbl (%eax),%eax
  800ca3:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800ca6:	74 10                	je     800cb8 <strfind+0x37>
	for (; *s; s++)
  800ca8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	0f b6 00             	movzbl (%eax),%eax
  800cb2:	84 c0                	test   %al,%al
  800cb4:	75 e7                	jne    800c9d <strfind+0x1c>
  800cb6:	eb 01                	jmp    800cb9 <strfind+0x38>
			break;
  800cb8:	90                   	nop
	return (char *) s;
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cbc:	c9                   	leave  
  800cbd:	c3                   	ret    

00800cbe <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cbe:	f3 0f 1e fb          	endbr32 
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	e8 82 f3 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800ccb:	05 35 13 00 00       	add    $0x1335,%eax
	char *p;

	if (n == 0)
  800cd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd4:	75 05                	jne    800cdb <memset+0x1d>
		return v;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	eb 5c                	jmp    800d37 <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	83 e0 03             	and    $0x3,%eax
  800ce1:	85 c0                	test   %eax,%eax
  800ce3:	75 41                	jne    800d26 <memset+0x68>
  800ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce8:	83 e0 03             	and    $0x3,%eax
  800ceb:	85 c0                	test   %eax,%eax
  800ced:	75 37                	jne    800d26 <memset+0x68>
		c &= 0xFF;
  800cef:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf9:	c1 e0 18             	shl    $0x18,%eax
  800cfc:	89 c2                	mov    %eax,%edx
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	c1 e0 10             	shl    $0x10,%eax
  800d04:	09 c2                	or     %eax,%edx
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d09:	c1 e0 08             	shl    $0x8,%eax
  800d0c:	09 d0                	or     %edx,%eax
  800d0e:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	c1 e8 02             	shr    $0x2,%eax
  800d17:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1f:	89 d7                	mov    %edx,%edi
  800d21:	fc                   	cld    
  800d22:	f3 ab                	rep stos %eax,%es:(%edi)
  800d24:	eb 0e                	jmp    800d34 <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d2f:	89 d7                	mov    %edx,%edi
  800d31:	fc                   	cld    
  800d32:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d3a:	f3 0f 1e fb          	endbr32 
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	57                   	push   %edi
  800d42:	56                   	push   %esi
  800d43:	53                   	push   %ebx
  800d44:	83 ec 10             	sub    $0x10,%esp
  800d47:	e8 01 f3 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800d4c:	05 b4 12 00 00       	add    $0x12b4,%eax
	const char *s;
	char *d;

	s = src;
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
  800d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d60:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d63:	73 6d                	jae    800dd2 <memmove+0x98>
  800d65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d68:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6b:	01 d0                	add    %edx,%eax
  800d6d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  800d70:	73 60                	jae    800dd2 <memmove+0x98>
		s += n;
  800d72:	8b 45 10             	mov    0x10(%ebp),%eax
  800d75:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
  800d78:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7b:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d81:	83 e0 03             	and    $0x3,%eax
  800d84:	85 c0                	test   %eax,%eax
  800d86:	75 2f                	jne    800db7 <memmove+0x7d>
  800d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8b:	83 e0 03             	and    $0x3,%eax
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	75 25                	jne    800db7 <memmove+0x7d>
  800d92:	8b 45 10             	mov    0x10(%ebp),%eax
  800d95:	83 e0 03             	and    $0x3,%eax
  800d98:	85 c0                	test   %eax,%eax
  800d9a:	75 1b                	jne    800db7 <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9f:	83 e8 04             	sub    $0x4,%eax
  800da2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800da5:	83 ea 04             	sub    $0x4,%edx
  800da8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800dab:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800dae:	89 c7                	mov    %eax,%edi
  800db0:	89 d6                	mov    %edx,%esi
  800db2:	fd                   	std    
  800db3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800db5:	eb 18                	jmp    800dcf <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc0:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
  800dc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc6:	89 d7                	mov    %edx,%edi
  800dc8:	89 de                	mov    %ebx,%esi
  800dca:	89 c1                	mov    %eax,%ecx
  800dcc:	fd                   	std    
  800dcd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dcf:	fc                   	cld    
  800dd0:	eb 45                	jmp    800e17 <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd5:	83 e0 03             	and    $0x3,%eax
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	75 2b                	jne    800e07 <memmove+0xcd>
  800ddc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ddf:	83 e0 03             	and    $0x3,%eax
  800de2:	85 c0                	test   %eax,%eax
  800de4:	75 21                	jne    800e07 <memmove+0xcd>
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	83 e0 03             	and    $0x3,%eax
  800dec:	85 c0                	test   %eax,%eax
  800dee:	75 17                	jne    800e07 <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800df0:	8b 45 10             	mov    0x10(%ebp),%eax
  800df3:	c1 e8 02             	shr    $0x2,%eax
  800df6:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
  800df8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800dfe:	89 c7                	mov    %eax,%edi
  800e00:	89 d6                	mov    %edx,%esi
  800e02:	fc                   	cld    
  800e03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e05:	eb 10                	jmp    800e17 <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
  800e07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e10:	89 c7                	mov    %eax,%edi
  800e12:	89 d6                	mov    %edx,%esi
  800e14:	fc                   	cld    
  800e15:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1a:	83 c4 10             	add    $0x10,%esp
  800e1d:	5b                   	pop    %ebx
  800e1e:	5e                   	pop    %esi
  800e1f:	5f                   	pop    %edi
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e22:	f3 0f 1e fb          	endbr32 
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	e8 1f f2 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800e2e:	05 d2 11 00 00       	add    $0x11d2,%eax
	return memmove(dst, src, n);
  800e33:	ff 75 10             	pushl  0x10(%ebp)
  800e36:	ff 75 0c             	pushl  0xc(%ebp)
  800e39:	ff 75 08             	pushl  0x8(%ebp)
  800e3c:	e8 f9 fe ff ff       	call   800d3a <memmove>
  800e41:	83 c4 0c             	add    $0xc,%esp
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e46:	f3 0f 1e fb          	endbr32 
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
  800e50:	e8 f8 f1 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800e55:	05 ab 11 00 00       	add    $0x11ab,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e66:	eb 30                	jmp    800e98 <memcmp+0x52>
		if (*s1 != *s2)
  800e68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6b:	0f b6 10             	movzbl (%eax),%edx
  800e6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e71:	0f b6 00             	movzbl (%eax),%eax
  800e74:	38 c2                	cmp    %al,%dl
  800e76:	74 18                	je     800e90 <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
  800e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7b:	0f b6 00             	movzbl (%eax),%eax
  800e7e:	0f b6 d0             	movzbl %al,%edx
  800e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e84:	0f b6 00             	movzbl (%eax),%eax
  800e87:	0f b6 c0             	movzbl %al,%eax
  800e8a:	29 c2                	sub    %eax,%edx
  800e8c:	89 d0                	mov    %edx,%eax
  800e8e:	eb 1a                	jmp    800eaa <memcmp+0x64>
		s1++, s2++;
  800e90:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800e94:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
  800e98:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9e:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	75 c3                	jne    800e68 <memcmp+0x22>
	}

	return 0;
  800ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eaa:	c9                   	leave  
  800eab:	c3                   	ret    

00800eac <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800eac:	f3 0f 1e fb          	endbr32 
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 10             	sub    $0x10,%esp
  800eb6:	e8 92 f1 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800ebb:	05 45 11 00 00       	add    $0x1145,%eax
	const void *ends = (const char *) s + n;
  800ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec6:	01 d0                	add    %edx,%eax
  800ec8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ecb:	eb 11                	jmp    800ede <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	0f b6 00             	movzbl (%eax),%eax
  800ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed6:	38 d0                	cmp    %dl,%al
  800ed8:	74 0e                	je     800ee8 <memfind+0x3c>
	for (; s < ends; s++)
  800eda:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee4:	72 e7                	jb     800ecd <memfind+0x21>
  800ee6:	eb 01                	jmp    800ee9 <memfind+0x3d>
			break;
  800ee8:	90                   	nop
	return (void *) s;
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eee:	f3 0f 1e fb          	endbr32 
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 10             	sub    $0x10,%esp
  800ef8:	e8 50 f1 ff ff       	call   80004d <__x86.get_pc_thunk.ax>
  800efd:	05 03 11 00 00       	add    $0x1103,%eax
	int neg = 0;
  800f02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f10:	eb 04                	jmp    800f16 <strtol+0x28>
		s++;
  800f12:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	0f b6 00             	movzbl (%eax),%eax
  800f1c:	3c 20                	cmp    $0x20,%al
  800f1e:	74 f2                	je     800f12 <strtol+0x24>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	0f b6 00             	movzbl (%eax),%eax
  800f26:	3c 09                	cmp    $0x9,%al
  800f28:	74 e8                	je     800f12 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	0f b6 00             	movzbl (%eax),%eax
  800f30:	3c 2b                	cmp    $0x2b,%al
  800f32:	75 06                	jne    800f3a <strtol+0x4c>
		s++;
  800f34:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f38:	eb 15                	jmp    800f4f <strtol+0x61>
	else if (*s == '-')
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	0f b6 00             	movzbl (%eax),%eax
  800f40:	3c 2d                	cmp    $0x2d,%al
  800f42:	75 0b                	jne    800f4f <strtol+0x61>
		s++, neg = 1;
  800f44:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f48:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f53:	74 06                	je     800f5b <strtol+0x6d>
  800f55:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f59:	75 24                	jne    800f7f <strtol+0x91>
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	0f b6 00             	movzbl (%eax),%eax
  800f61:	3c 30                	cmp    $0x30,%al
  800f63:	75 1a                	jne    800f7f <strtol+0x91>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	83 c0 01             	add    $0x1,%eax
  800f6b:	0f b6 00             	movzbl (%eax),%eax
  800f6e:	3c 78                	cmp    $0x78,%al
  800f70:	75 0d                	jne    800f7f <strtol+0x91>
		s += 2, base = 16;
  800f72:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f76:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7d:	eb 2a                	jmp    800fa9 <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	75 17                	jne    800f9c <strtol+0xae>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	0f b6 00             	movzbl (%eax),%eax
  800f8b:	3c 30                	cmp    $0x30,%al
  800f8d:	75 0d                	jne    800f9c <strtol+0xae>
		s++, base = 8;
  800f8f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f93:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9a:	eb 0d                	jmp    800fa9 <strtol+0xbb>
	else if (base == 0)
  800f9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa0:	75 07                	jne    800fa9 <strtol+0xbb>
		base = 10;
  800fa2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	0f b6 00             	movzbl (%eax),%eax
  800faf:	3c 2f                	cmp    $0x2f,%al
  800fb1:	7e 1b                	jle    800fce <strtol+0xe0>
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	0f b6 00             	movzbl (%eax),%eax
  800fb9:	3c 39                	cmp    $0x39,%al
  800fbb:	7f 11                	jg     800fce <strtol+0xe0>
			dig = *s - '0';
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	0f b6 00             	movzbl (%eax),%eax
  800fc3:	0f be c0             	movsbl %al,%eax
  800fc6:	83 e8 30             	sub    $0x30,%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcc:	eb 48                	jmp    801016 <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	0f b6 00             	movzbl (%eax),%eax
  800fd4:	3c 60                	cmp    $0x60,%al
  800fd6:	7e 1b                	jle    800ff3 <strtol+0x105>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	0f b6 00             	movzbl (%eax),%eax
  800fde:	3c 7a                	cmp    $0x7a,%al
  800fe0:	7f 11                	jg     800ff3 <strtol+0x105>
			dig = *s - 'a' + 10;
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	0f b6 00             	movzbl (%eax),%eax
  800fe8:	0f be c0             	movsbl %al,%eax
  800feb:	83 e8 57             	sub    $0x57,%eax
  800fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff1:	eb 23                	jmp    801016 <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	0f b6 00             	movzbl (%eax),%eax
  800ff9:	3c 40                	cmp    $0x40,%al
  800ffb:	7e 3c                	jle    801039 <strtol+0x14b>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	0f b6 00             	movzbl (%eax),%eax
  801003:	3c 5a                	cmp    $0x5a,%al
  801005:	7f 32                	jg     801039 <strtol+0x14b>
			dig = *s - 'A' + 10;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	0f b6 00             	movzbl (%eax),%eax
  80100d:	0f be c0             	movsbl %al,%eax
  801010:	83 e8 37             	sub    $0x37,%eax
  801013:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801019:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101c:	7d 1a                	jge    801038 <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
  80101e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801022:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801025:	0f af 45 10          	imul   0x10(%ebp),%eax
  801029:	89 c2                	mov    %eax,%edx
  80102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102e:	01 d0                	add    %edx,%eax
  801030:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
  801033:	e9 71 ff ff ff       	jmp    800fa9 <strtol+0xbb>
			break;
  801038:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
  801039:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103d:	74 08                	je     801047 <strtol+0x159>
		*endptr = (char *) s;
  80103f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801042:	8b 55 08             	mov    0x8(%ebp),%edx
  801045:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801047:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104b:	74 07                	je     801054 <strtol+0x166>
  80104d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801050:	f7 d8                	neg    %eax
  801052:	eb 03                	jmp    801057 <strtol+0x169>
  801054:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    
  801059:	66 90                	xchg   %ax,%ax
  80105b:	66 90                	xchg   %ax,%ax
  80105d:	66 90                	xchg   %ax,%ax
  80105f:	90                   	nop

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
