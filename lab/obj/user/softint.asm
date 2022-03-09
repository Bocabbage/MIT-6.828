
obj/user/softint:     file format elf32-i386


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
  80002c:	e8 1c 00 00 00       	call   80004d <libmain>
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
  80003a:	e8 0a 00 00 00       	call   800049 <__x86.get_pc_thunk.ax>
  80003f:	05 c1 1f 00 00       	add    $0x1fc1,%eax
	asm volatile("int $14");	// page fault
  800044:	cd 0e                	int    $0xe
}
  800046:	90                   	nop
  800047:	5d                   	pop    %ebp
  800048:	c3                   	ret    

00800049 <__x86.get_pc_thunk.ax>:
  800049:	8b 04 24             	mov    (%esp),%eax
  80004c:	c3                   	ret    

0080004d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004d:	f3 0f 1e fb          	endbr32 
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	53                   	push   %ebx
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	e8 5a 00 00 00       	call   8000b7 <__x86.get_pc_thunk.bx>
  80005d:	81 c3 a3 1f 00 00    	add    $0x1fa3,%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code h(ere.
	thisenv = envs + ENVX(sys_getenvid());
  800063:	e8 76 01 00 00       	call   8001de <sys_getenvid>
  800068:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006d:	89 c2                	mov    %eax,%edx
  80006f:	89 d0                	mov    %edx,%eax
  800071:	01 c0                	add    %eax,%eax
  800073:	01 d0                	add    %edx,%eax
  800075:	c1 e0 05             	shl    $0x5,%eax
  800078:	89 c2                	mov    %eax,%edx
  80007a:	c7 c0 00 00 c0 ee    	mov    $0xeec00000,%eax
  800080:	01 c2                	add    %eax,%edx
  800082:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  800088:	89 10                	mov    %edx,(%eax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80008e:	7e 0b                	jle    80009b <libmain+0x4e>
		binaryname = argv[0];
  800090:	8b 45 0c             	mov    0xc(%ebp),%eax
  800093:	8b 00                	mov    (%eax),%eax
  800095:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  80009b:	83 ec 08             	sub    $0x8,%esp
  80009e:	ff 75 0c             	pushl  0xc(%ebp)
  8000a1:	ff 75 08             	pushl  0x8(%ebp)
  8000a4:	e8 8a ff ff ff       	call   800033 <umain>
  8000a9:	83 c4 10             	add    $0x10,%esp

	// exit gracefully
	exit();
  8000ac:	e8 0a 00 00 00       	call   8000bb <exit>
}
  8000b1:	90                   	nop
  8000b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b5:	c9                   	leave  
  8000b6:	c3                   	ret    

008000b7 <__x86.get_pc_thunk.bx>:
  8000b7:	8b 1c 24             	mov    (%esp),%ebx
  8000ba:	c3                   	ret    

008000bb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000bb:	f3 0f 1e fb          	endbr32 
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	53                   	push   %ebx
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	e8 7e ff ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  8000cb:	05 35 1f 00 00       	add    $0x1f35,%eax
	sys_env_destroy(0);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	6a 00                	push   $0x0
  8000d5:	89 c3                	mov    %eax,%ebx
  8000d7:	e8 d1 00 00 00       	call   8001ad <sys_env_destroy>
  8000dc:	83 c4 10             	add    $0x10,%esp
}
  8000df:	90                   	nop
  8000e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e3:	c9                   	leave  
  8000e4:	c3                   	ret    

008000e5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000e5:	55                   	push   %ebp
  8000e6:	89 e5                	mov    %esp,%ebp
  8000e8:	57                   	push   %edi
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	83 ec 2c             	sub    $0x2c,%esp
  8000ee:	e8 c4 ff ff ff       	call   8000b7 <__x86.get_pc_thunk.bx>
  8000f3:	81 c3 0d 1f 00 00    	add    $0x1f0d,%ebx
  8000f9:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ff:	8b 55 10             	mov    0x10(%ebp),%edx
  800102:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800105:	8b 5d 18             	mov    0x18(%ebp),%ebx
  800108:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  80010b:	8b 75 20             	mov    0x20(%ebp),%esi
  80010e:	cd 30                	int    $0x30
  800110:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800113:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800117:	74 27                	je     800140 <syscall+0x5b>
  800119:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80011d:	7e 21                	jle    800140 <syscall+0x5b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	ff 75 08             	pushl  0x8(%ebp)
  800128:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80012b:	8d 83 ca f2 ff ff    	lea    -0xd36(%ebx),%eax
  800131:	50                   	push   %eax
  800132:	6a 23                	push   $0x23
  800134:	8d 83 e7 f2 ff ff    	lea    -0xd19(%ebx),%eax
  80013a:	50                   	push   %eax
  80013b:	e8 cd 00 00 00       	call   80020d <_panic>

	return ret;
  800140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  800143:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800146:	5b                   	pop    %ebx
  800147:	5e                   	pop    %esi
  800148:	5f                   	pop    %edi
  800149:	5d                   	pop    %ebp
  80014a:	c3                   	ret    

0080014b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80014b:	f3 0f 1e fb          	endbr32 
  80014f:	55                   	push   %ebp
  800150:	89 e5                	mov    %esp,%ebp
  800152:	83 ec 08             	sub    $0x8,%esp
  800155:	e8 ef fe ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  80015a:	05 a6 1e 00 00       	add    $0x1ea6,%eax
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  80015f:	8b 45 08             	mov    0x8(%ebp),%eax
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	6a 00                	push   $0x0
  800167:	6a 00                	push   $0x0
  800169:	6a 00                	push   $0x0
  80016b:	ff 75 0c             	pushl  0xc(%ebp)
  80016e:	50                   	push   %eax
  80016f:	6a 00                	push   $0x0
  800171:	6a 00                	push   $0x0
  800173:	e8 6d ff ff ff       	call   8000e5 <syscall>
  800178:	83 c4 20             	add    $0x20,%esp
}
  80017b:	90                   	nop
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    

0080017e <sys_cgetc>:

int
sys_cgetc(void)
{
  80017e:	f3 0f 1e fb          	endbr32 
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	e8 bc fe ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  80018d:	05 73 1e 00 00       	add    $0x1e73,%eax
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	6a 00                	push   $0x0
  800197:	6a 00                	push   $0x0
  800199:	6a 00                	push   $0x0
  80019b:	6a 00                	push   $0x0
  80019d:	6a 00                	push   $0x0
  80019f:	6a 00                	push   $0x0
  8001a1:	6a 01                	push   $0x1
  8001a3:	e8 3d ff ff ff       	call   8000e5 <syscall>
  8001a8:	83 c4 20             	add    $0x20,%esp
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001ad:	f3 0f 1e fb          	endbr32 
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	e8 8d fe ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  8001bc:	05 44 1e 00 00       	add    $0x1e44,%eax
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	6a 00                	push   $0x0
  8001c9:	6a 00                	push   $0x0
  8001cb:	6a 00                	push   $0x0
  8001cd:	6a 00                	push   $0x0
  8001cf:	50                   	push   %eax
  8001d0:	6a 01                	push   $0x1
  8001d2:	6a 03                	push   $0x3
  8001d4:	e8 0c ff ff ff       	call   8000e5 <syscall>
  8001d9:	83 c4 20             	add    $0x20,%esp
}
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8001de:	f3 0f 1e fb          	endbr32 
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	e8 5c fe ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  8001ed:	05 13 1e 00 00       	add    $0x1e13,%eax
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	6a 00                	push   $0x0
  8001f7:	6a 00                	push   $0x0
  8001f9:	6a 00                	push   $0x0
  8001fb:	6a 00                	push   $0x0
  8001fd:	6a 00                	push   $0x0
  8001ff:	6a 00                	push   $0x0
  800201:	6a 02                	push   $0x2
  800203:	e8 dd fe ff ff       	call   8000e5 <syscall>
  800208:	83 c4 20             	add    $0x20,%esp
}
  80020b:	c9                   	leave  
  80020c:	c3                   	ret    

0080020d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80020d:	f3 0f 1e fb          	endbr32 
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 10             	sub    $0x10,%esp
  800219:	e8 99 fe ff ff       	call   8000b7 <__x86.get_pc_thunk.bx>
  80021e:	81 c3 e2 1d 00 00    	add    $0x1de2,%ebx
	va_list ap;

	va_start(ap, fmt);
  800224:	8d 45 14             	lea    0x14(%ebp),%eax
  800227:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80022a:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800230:	8b 30                	mov    (%eax),%esi
  800232:	e8 a7 ff ff ff       	call   8001de <sys_getenvid>
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	ff 75 0c             	pushl  0xc(%ebp)
  80023d:	ff 75 08             	pushl  0x8(%ebp)
  800240:	56                   	push   %esi
  800241:	50                   	push   %eax
  800242:	8d 83 f8 f2 ff ff    	lea    -0xd08(%ebx),%eax
  800248:	50                   	push   %eax
  800249:	e8 0f 01 00 00       	call   80035d <cprintf>
  80024e:	83 c4 20             	add    $0x20,%esp
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800254:	83 ec 08             	sub    $0x8,%esp
  800257:	50                   	push   %eax
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	e8 8d 00 00 00       	call   8002ed <vcprintf>
  800260:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  800263:	83 ec 0c             	sub    $0xc,%esp
  800266:	8d 83 1b f3 ff ff    	lea    -0xce5(%ebx),%eax
  80026c:	50                   	push   %eax
  80026d:	e8 eb 00 00 00       	call   80035d <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800275:	cc                   	int3   
  800276:	eb fd                	jmp    800275 <_panic+0x68>

00800278 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800278:	f3 0f 1e fb          	endbr32 
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	53                   	push   %ebx
  800280:	83 ec 04             	sub    $0x4,%esp
  800283:	e8 09 01 00 00       	call   800391 <__x86.get_pc_thunk.dx>
  800288:	81 c2 78 1d 00 00    	add    $0x1d78,%edx
	b->buf[b->idx++] = ch;
  80028e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800291:	8b 00                	mov    (%eax),%eax
  800293:	8d 58 01             	lea    0x1(%eax),%ebx
  800296:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800299:	89 19                	mov    %ebx,(%ecx)
  80029b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80029e:	89 cb                	mov    %ecx,%ebx
  8002a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a3:	88 5c 01 08          	mov    %bl,0x8(%ecx,%eax,1)
	if (b->idx == 256-1) {
  8002a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b1:	75 25                	jne    8002d8 <putch+0x60>
		sys_cputs(b->buf, b->idx);
  8002b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b6:	8b 00                	mov    (%eax),%eax
  8002b8:	89 c1                	mov    %eax,%ecx
  8002ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bd:	83 c0 08             	add    $0x8,%eax
  8002c0:	83 ec 08             	sub    $0x8,%esp
  8002c3:	51                   	push   %ecx
  8002c4:	50                   	push   %eax
  8002c5:	89 d3                	mov    %edx,%ebx
  8002c7:	e8 7f fe ff ff       	call   80014b <sys_cputs>
  8002cc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002db:	8b 40 04             	mov    0x4(%eax),%eax
  8002de:	8d 50 01             	lea    0x1(%eax),%edx
  8002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002e7:	90                   	nop
  8002e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002eb:	c9                   	leave  
  8002ec:	c3                   	ret    

008002ed <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ed:	f3 0f 1e fb          	endbr32 
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	53                   	push   %ebx
  8002f5:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8002fb:	e8 b7 fd ff ff       	call   8000b7 <__x86.get_pc_thunk.bx>
  800300:	81 c3 00 1d 00 00    	add    $0x1d00,%ebx
	struct printbuf b;

	b.idx = 0;
  800306:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80030d:	00 00 00 
	b.cnt = 0;
  800310:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800317:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80031a:	ff 75 0c             	pushl  0xc(%ebp)
  80031d:	ff 75 08             	pushl  0x8(%ebp)
  800320:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800326:	50                   	push   %eax
  800327:	8d 83 78 e2 ff ff    	lea    -0x1d88(%ebx),%eax
  80032d:	50                   	push   %eax
  80032e:	e8 e3 01 00 00       	call   800516 <vprintfmt>
  800333:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  800336:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80033c:	83 ec 08             	sub    $0x8,%esp
  80033f:	50                   	push   %eax
  800340:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800346:	83 c0 08             	add    $0x8,%eax
  800349:	50                   	push   %eax
  80034a:	e8 fc fd ff ff       	call   80014b <sys_cputs>
  80034f:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  800352:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800358:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80035d:	f3 0f 1e fb          	endbr32 
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	83 ec 18             	sub    $0x18,%esp
  800367:	e8 dd fc ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  80036c:	05 94 1c 00 00       	add    $0x1c94,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800371:	8d 45 0c             	lea    0xc(%ebp),%eax
  800374:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
  800377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	50                   	push   %eax
  80037e:	ff 75 08             	pushl  0x8(%ebp)
  800381:	e8 67 ff ff ff       	call   8002ed <vcprintf>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
  80038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80038f:	c9                   	leave  
  800390:	c3                   	ret    

00800391 <__x86.get_pc_thunk.dx>:
  800391:	8b 14 24             	mov    (%esp),%edx
  800394:	c3                   	ret    

00800395 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800395:	f3 0f 1e fb          	endbr32 
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	57                   	push   %edi
  80039d:	56                   	push   %esi
  80039e:	53                   	push   %ebx
  80039f:	83 ec 1c             	sub    $0x1c,%esp
  8003a2:	e8 43 06 00 00       	call   8009ea <__x86.get_pc_thunk.si>
  8003a7:	81 c6 59 1c 00 00    	add    $0x1c59,%esi
  8003ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b9:	8b 45 18             	mov    0x18(%ebp),%eax
  8003bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003c4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8003c7:	19 d1                	sbb    %edx,%ecx
  8003c9:	72 4d                	jb     800418 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003ce:	8d 78 ff             	lea    -0x1(%eax),%edi
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d9:	52                   	push   %edx
  8003da:	50                   	push   %eax
  8003db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003de:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e1:	89 f3                	mov    %esi,%ebx
  8003e3:	e8 78 0c 00 00       	call   801060 <__udivdi3>
  8003e8:	83 c4 10             	add    $0x10,%esp
  8003eb:	83 ec 04             	sub    $0x4,%esp
  8003ee:	ff 75 20             	pushl  0x20(%ebp)
  8003f1:	57                   	push   %edi
  8003f2:	ff 75 18             	pushl  0x18(%ebp)
  8003f5:	52                   	push   %edx
  8003f6:	50                   	push   %eax
  8003f7:	ff 75 0c             	pushl  0xc(%ebp)
  8003fa:	ff 75 08             	pushl  0x8(%ebp)
  8003fd:	e8 93 ff ff ff       	call   800395 <printnum>
  800402:	83 c4 20             	add    $0x20,%esp
  800405:	eb 1b                	jmp    800422 <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	ff 75 0c             	pushl  0xc(%ebp)
  80040d:	ff 75 20             	pushl  0x20(%ebp)
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	ff d0                	call   *%eax
  800415:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800418:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  80041c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800420:	7f e5                	jg     800407 <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800422:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800425:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800430:	53                   	push   %ebx
  800431:	51                   	push   %ecx
  800432:	52                   	push   %edx
  800433:	50                   	push   %eax
  800434:	89 f3                	mov    %esi,%ebx
  800436:	e8 35 0d 00 00       	call   801170 <__umoddi3>
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	8d 8e 89 f3 ff ff    	lea    -0xc77(%esi),%ecx
  800444:	01 c8                	add    %ecx,%eax
  800446:	0f b6 00             	movzbl (%eax),%eax
  800449:	0f be c0             	movsbl %al,%eax
  80044c:	83 ec 08             	sub    $0x8,%esp
  80044f:	ff 75 0c             	pushl  0xc(%ebp)
  800452:	50                   	push   %eax
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	ff d0                	call   *%eax
  800458:	83 c4 10             	add    $0x10,%esp
}
  80045b:	90                   	nop
  80045c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80045f:	5b                   	pop    %ebx
  800460:	5e                   	pop    %esi
  800461:	5f                   	pop    %edi
  800462:	5d                   	pop    %ebp
  800463:	c3                   	ret    

00800464 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800464:	f3 0f 1e fb          	endbr32 
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	e8 d9 fb ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800470:	05 90 1b 00 00       	add    $0x1b90,%eax
	if (lflag >= 2)
  800475:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800479:	7e 14                	jle    80048f <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	8d 48 08             	lea    0x8(%eax),%ecx
  800483:	8b 55 08             	mov    0x8(%ebp),%edx
  800486:	89 0a                	mov    %ecx,(%edx)
  800488:	8b 50 04             	mov    0x4(%eax),%edx
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	eb 30                	jmp    8004bf <getuint+0x5b>
	else if (lflag)
  80048f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800493:	74 16                	je     8004ab <getuint+0x47>
		return va_arg(*ap, unsigned long);
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	8d 48 04             	lea    0x4(%eax),%ecx
  80049d:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a0:	89 0a                	mov    %ecx,(%edx)
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a9:	eb 14                	jmp    8004bf <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	8d 48 04             	lea    0x4(%eax),%ecx
  8004b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b6:	89 0a                	mov    %ecx,(%edx)
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004bf:	5d                   	pop    %ebp
  8004c0:	c3                   	ret    

008004c1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c1:	f3 0f 1e fb          	endbr32 
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	e8 7c fb ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  8004cd:	05 33 1b 00 00       	add    $0x1b33,%eax
	if (lflag >= 2)
  8004d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d6:	7e 14                	jle    8004ec <getint+0x2b>
		return va_arg(*ap, long long);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 48 08             	lea    0x8(%eax),%ecx
  8004e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e3:	89 0a                	mov    %ecx,(%edx)
  8004e5:	8b 50 04             	mov    0x4(%eax),%edx
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	eb 28                	jmp    800514 <getint+0x53>
	else if (lflag)
  8004ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f0:	74 12                	je     800504 <getint+0x43>
		return va_arg(*ap, long);
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	8d 48 04             	lea    0x4(%eax),%ecx
  8004fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8004fd:	89 0a                	mov    %ecx,(%edx)
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	99                   	cltd   
  800502:	eb 10                	jmp    800514 <getint+0x53>
	else
		return va_arg(*ap, int);
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 48 04             	lea    0x4(%eax),%ecx
  80050c:	8b 55 08             	mov    0x8(%ebp),%edx
  80050f:	89 0a                	mov    %ecx,(%edx)
  800511:	8b 00                	mov    (%eax),%eax
  800513:	99                   	cltd   
}
  800514:	5d                   	pop    %ebp
  800515:	c3                   	ret    

00800516 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800516:	f3 0f 1e fb          	endbr32 
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	57                   	push   %edi
  80051e:	56                   	push   %esi
  80051f:	53                   	push   %ebx
  800520:	83 ec 2c             	sub    $0x2c,%esp
  800523:	e8 c6 04 00 00       	call   8009ee <__x86.get_pc_thunk.di>
  800528:	81 c7 d8 1a 00 00    	add    $0x1ad8,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052e:	eb 17                	jmp    800547 <vprintfmt+0x31>
			if (ch == '\0')
  800530:	85 db                	test   %ebx,%ebx
  800532:	0f 84 96 03 00 00    	je     8008ce <.L20+0x2d>
				return;
			putch(ch, putdat);
  800538:	83 ec 08             	sub    $0x8,%esp
  80053b:	ff 75 0c             	pushl  0xc(%ebp)
  80053e:	53                   	push   %ebx
  80053f:	8b 45 08             	mov    0x8(%ebp),%eax
  800542:	ff d0                	call   *%eax
  800544:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800547:	8b 45 10             	mov    0x10(%ebp),%eax
  80054a:	8d 50 01             	lea    0x1(%eax),%edx
  80054d:	89 55 10             	mov    %edx,0x10(%ebp)
  800550:	0f b6 00             	movzbl (%eax),%eax
  800553:	0f b6 d8             	movzbl %al,%ebx
  800556:	83 fb 25             	cmp    $0x25,%ebx
  800559:	75 d5                	jne    800530 <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
  80055b:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
  80055f:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
  800566:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
  80056d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
  800574:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057b:	8b 45 10             	mov    0x10(%ebp),%eax
  80057e:	8d 50 01             	lea    0x1(%eax),%edx
  800581:	89 55 10             	mov    %edx,0x10(%ebp)
  800584:	0f b6 00             	movzbl (%eax),%eax
  800587:	0f b6 d8             	movzbl %al,%ebx
  80058a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80058d:	83 f8 55             	cmp    $0x55,%eax
  800590:	0f 87 0b 03 00 00    	ja     8008a1 <.L20>
  800596:	c1 e0 02             	shl    $0x2,%eax
  800599:	8b 84 38 b0 f3 ff ff 	mov    -0xc50(%eax,%edi,1),%eax
  8005a0:	01 f8                	add    %edi,%eax
  8005a2:	3e ff e0             	notrack jmp *%eax

008005a5 <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a5:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
  8005a9:	eb d0                	jmp    80057b <vprintfmt+0x65>

008005ab <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005ab:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
  8005af:	eb ca                	jmp    80057b <vprintfmt+0x65>

008005b1 <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
  8005b8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005bb:	89 d0                	mov    %edx,%eax
  8005bd:	c1 e0 02             	shl    $0x2,%eax
  8005c0:	01 d0                	add    %edx,%eax
  8005c2:	01 c0                	add    %eax,%eax
  8005c4:	01 d8                	add    %ebx,%eax
  8005c6:	83 e8 30             	sub    $0x30,%eax
  8005c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
  8005cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cf:	0f b6 00             	movzbl (%eax),%eax
  8005d2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005d5:	83 fb 2f             	cmp    $0x2f,%ebx
  8005d8:	7e 39                	jle    800613 <.L37+0xc>
  8005da:	83 fb 39             	cmp    $0x39,%ebx
  8005dd:	7f 34                	jg     800613 <.L37+0xc>
			for (precision = 0; ; ++fmt) {
  8005df:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
  8005e3:	eb d3                	jmp    8005b8 <.L31+0x7>

008005e5 <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8d 50 04             	lea    0x4(%eax),%edx
  8005eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
  8005f3:	eb 1f                	jmp    800614 <.L37+0xd>

008005f5 <.L33>:

		case '.':
			if (width < 0)
  8005f5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005f9:	79 80                	jns    80057b <vprintfmt+0x65>
				width = 0;
  8005fb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
  800602:	e9 74 ff ff ff       	jmp    80057b <vprintfmt+0x65>

00800607 <.L37>:

		case '#':
			altflag = 1;
  800607:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
  80060e:	e9 68 ff ff ff       	jmp    80057b <vprintfmt+0x65>
			goto process_precision;
  800613:	90                   	nop

		process_precision:
			if (width < 0)
  800614:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800618:	0f 89 5d ff ff ff    	jns    80057b <vprintfmt+0x65>
				width = precision, precision = -1;
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800624:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
  80062b:	e9 4b ff ff ff       	jmp    80057b <vprintfmt+0x65>

00800630 <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800630:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
  800634:	e9 42 ff ff ff       	jmp    80057b <vprintfmt+0x65>

00800639 <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8d 50 04             	lea    0x4(%eax),%edx
  80063f:	89 55 14             	mov    %edx,0x14(%ebp)
  800642:	8b 00                	mov    (%eax),%eax
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	ff 75 0c             	pushl  0xc(%ebp)
  80064a:	50                   	push   %eax
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	ff d0                	call   *%eax
  800650:	83 c4 10             	add    $0x10,%esp
			break;
  800653:	e9 71 02 00 00       	jmp    8008c9 <.L20+0x28>

00800658 <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8d 50 04             	lea    0x4(%eax),%edx
  80065e:	89 55 14             	mov    %edx,0x14(%ebp)
  800661:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800663:	85 db                	test   %ebx,%ebx
  800665:	79 02                	jns    800669 <.L28+0x11>
				err = -err;
  800667:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800669:	83 fb 06             	cmp    $0x6,%ebx
  80066c:	7f 0b                	jg     800679 <.L28+0x21>
  80066e:	8b b4 9f 10 00 00 00 	mov    0x10(%edi,%ebx,4),%esi
  800675:	85 f6                	test   %esi,%esi
  800677:	75 1b                	jne    800694 <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
  800679:	53                   	push   %ebx
  80067a:	8d 87 9a f3 ff ff    	lea    -0xc66(%edi),%eax
  800680:	50                   	push   %eax
  800681:	ff 75 0c             	pushl  0xc(%ebp)
  800684:	ff 75 08             	pushl  0x8(%ebp)
  800687:	e8 4b 02 00 00       	call   8008d7 <printfmt>
  80068c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80068f:	e9 35 02 00 00       	jmp    8008c9 <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
  800694:	56                   	push   %esi
  800695:	8d 87 a3 f3 ff ff    	lea    -0xc5d(%edi),%eax
  80069b:	50                   	push   %eax
  80069c:	ff 75 0c             	pushl  0xc(%ebp)
  80069f:	ff 75 08             	pushl  0x8(%ebp)
  8006a2:	e8 30 02 00 00       	call   8008d7 <printfmt>
  8006a7:	83 c4 10             	add    $0x10,%esp
			break;
  8006aa:	e9 1a 02 00 00       	jmp    8008c9 <.L20+0x28>

008006af <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 50 04             	lea    0x4(%eax),%edx
  8006b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b8:	8b 30                	mov    (%eax),%esi
  8006ba:	85 f6                	test   %esi,%esi
  8006bc:	75 06                	jne    8006c4 <.L24+0x15>
				p = "(null)";
  8006be:	8d b7 a6 f3 ff ff    	lea    -0xc5a(%edi),%esi
			if (width > 0 && padc != '-')
  8006c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006c8:	7e 71                	jle    80073b <.L24+0x8c>
  8006ca:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  8006ce:	74 6b                	je     80073b <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	50                   	push   %eax
  8006d7:	56                   	push   %esi
  8006d8:	89 fb                	mov    %edi,%ebx
  8006da:	e8 47 03 00 00       	call   800a26 <strnlen>
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	29 45 d4             	sub    %eax,-0x2c(%ebp)
  8006e5:	eb 17                	jmp    8006fe <.L24+0x4f>
					putch(padc, putdat);
  8006e7:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	ff 75 0c             	pushl  0xc(%ebp)
  8006f1:	50                   	push   %eax
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	ff d0                	call   *%eax
  8006f7:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fa:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  8006fe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800702:	7f e3                	jg     8006e7 <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800704:	eb 35                	jmp    80073b <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
  800706:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80070a:	74 1c                	je     800728 <.L24+0x79>
  80070c:	83 fb 1f             	cmp    $0x1f,%ebx
  80070f:	7e 05                	jle    800716 <.L24+0x67>
  800711:	83 fb 7e             	cmp    $0x7e,%ebx
  800714:	7e 12                	jle    800728 <.L24+0x79>
					putch('?', putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	6a 3f                	push   $0x3f
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	eb 0f                	jmp    800737 <.L24+0x88>
				else
					putch(ch, putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 0c             	pushl  0xc(%ebp)
  80072e:	53                   	push   %ebx
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	ff d0                	call   *%eax
  800734:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800737:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  80073b:	89 f0                	mov    %esi,%eax
  80073d:	8d 70 01             	lea    0x1(%eax),%esi
  800740:	0f b6 00             	movzbl (%eax),%eax
  800743:	0f be d8             	movsbl %al,%ebx
  800746:	85 db                	test   %ebx,%ebx
  800748:	74 26                	je     800770 <.L24+0xc1>
  80074a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80074e:	78 b6                	js     800706 <.L24+0x57>
  800750:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  800754:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800758:	79 ac                	jns    800706 <.L24+0x57>
			for (; width > 0; width--)
  80075a:	eb 14                	jmp    800770 <.L24+0xc1>
				putch(' ', putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	6a 20                	push   $0x20
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
  80076c:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800770:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800774:	7f e6                	jg     80075c <.L24+0xad>
			break;
  800776:	e9 4e 01 00 00       	jmp    8008c9 <.L20+0x28>

0080077b <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 d8             	pushl  -0x28(%ebp)
  800781:	8d 45 14             	lea    0x14(%ebp),%eax
  800784:	50                   	push   %eax
  800785:	e8 37 fd ff ff       	call   8004c1 <getint>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800790:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
  800793:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800796:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800799:	85 d2                	test   %edx,%edx
  80079b:	79 23                	jns    8007c0 <.L29+0x45>
				putch('-', putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	ff 75 0c             	pushl  0xc(%ebp)
  8007a3:	6a 2d                	push   $0x2d
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	ff d0                	call   *%eax
  8007aa:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b3:	f7 d8                	neg    %eax
  8007b5:	83 d2 00             	adc    $0x0,%edx
  8007b8:	f7 da                	neg    %edx
  8007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
  8007c0:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007c7:	e9 9f 00 00 00       	jmp    80086b <.L21+0x1f>

008007cc <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	ff 75 d8             	pushl  -0x28(%ebp)
  8007d2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d5:	50                   	push   %eax
  8007d6:	e8 89 fc ff ff       	call   800464 <getuint>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
  8007e4:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007eb:	eb 7e                	jmp    80086b <.L21+0x1f>

008007ed <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8007f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f6:	50                   	push   %eax
  8007f7:	e8 68 fc ff ff       	call   800464 <getuint>
  8007fc:	83 c4 10             	add    $0x10,%esp
  8007ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800802:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
  800805:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
  80080c:	eb 5d                	jmp    80086b <.L21+0x1f>

0080080e <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	6a 30                	push   $0x30
  800816:	8b 45 08             	mov    0x8(%ebp),%eax
  800819:	ff d0                	call   *%eax
  80081b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	6a 78                	push   $0x78
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	ff d0                	call   *%eax
  80082b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	8d 50 04             	lea    0x4(%eax),%edx
  800834:	89 55 14             	mov    %edx,0x14(%ebp)
  800837:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
  800839:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80083c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
  800843:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
  80084a:	eb 1f                	jmp    80086b <.L21+0x1f>

0080084c <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 d8             	pushl  -0x28(%ebp)
  800852:	8d 45 14             	lea    0x14(%ebp),%eax
  800855:	50                   	push   %eax
  800856:	e8 09 fc ff ff       	call   800464 <getuint>
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800861:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
  800864:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80086b:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  80086f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800872:	83 ec 04             	sub    $0x4,%esp
  800875:	52                   	push   %edx
  800876:	ff 75 d4             	pushl  -0x2c(%ebp)
  800879:	50                   	push   %eax
  80087a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80087d:	ff 75 e0             	pushl  -0x20(%ebp)
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	ff 75 08             	pushl  0x8(%ebp)
  800886:	e8 0a fb ff ff       	call   800395 <printnum>
  80088b:	83 c4 20             	add    $0x20,%esp
			break;
  80088e:	eb 39                	jmp    8008c9 <.L20+0x28>

00800890 <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	ff 75 0c             	pushl  0xc(%ebp)
  800896:	53                   	push   %ebx
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	ff d0                	call   *%eax
  80089c:	83 c4 10             	add    $0x10,%esp
			break;
  80089f:	eb 28                	jmp    8008c9 <.L20+0x28>

008008a1 <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	6a 25                	push   $0x25
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	ff d0                	call   *%eax
  8008ae:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008b5:	eb 04                	jmp    8008bb <.L20+0x1a>
  8008b7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008be:	83 e8 01             	sub    $0x1,%eax
  8008c1:	0f b6 00             	movzbl (%eax),%eax
  8008c4:	3c 25                	cmp    $0x25,%al
  8008c6:	75 ef                	jne    8008b7 <.L20+0x16>
				/* do nothing */;
			break;
  8008c8:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c9:	e9 79 fc ff ff       	jmp    800547 <vprintfmt+0x31>
				return;
  8008ce:	90                   	nop
		}
	}
}
  8008cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008d2:	5b                   	pop    %ebx
  8008d3:	5e                   	pop    %esi
  8008d4:	5f                   	pop    %edi
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008d7:	f3 0f 1e fb          	endbr32 
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	83 ec 18             	sub    $0x18,%esp
  8008e1:	e8 63 f7 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  8008e6:	05 1a 17 00 00       	add    $0x171a,%eax
	va_list ap;

	va_start(ap, fmt);
  8008eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f4:	50                   	push   %eax
  8008f5:	ff 75 10             	pushl  0x10(%ebp)
  8008f8:	ff 75 0c             	pushl  0xc(%ebp)
  8008fb:	ff 75 08             	pushl  0x8(%ebp)
  8008fe:	e8 13 fc ff ff       	call   800516 <vprintfmt>
  800903:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800906:	90                   	nop
  800907:	c9                   	leave  
  800908:	c3                   	ret    

00800909 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800909:	f3 0f 1e fb          	endbr32 
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
  800910:	e8 34 f7 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800915:	05 eb 16 00 00       	add    $0x16eb,%eax
	b->cnt++;
  80091a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091d:	8b 40 08             	mov    0x8(%eax),%eax
  800920:	8d 50 01             	lea    0x1(%eax),%edx
  800923:	8b 45 0c             	mov    0xc(%ebp),%eax
  800926:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 10                	mov    (%eax),%edx
  80092e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800931:	8b 40 04             	mov    0x4(%eax),%eax
  800934:	39 c2                	cmp    %eax,%edx
  800936:	73 12                	jae    80094a <sprintputch+0x41>
		*b->buf++ = ch;
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	8d 48 01             	lea    0x1(%eax),%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	89 0a                	mov    %ecx,(%edx)
  800945:	8b 55 08             	mov    0x8(%ebp),%edx
  800948:	88 10                	mov    %dl,(%eax)
}
  80094a:	90                   	nop
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	83 ec 18             	sub    $0x18,%esp
  800957:	e8 ed f6 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  80095c:	05 a4 16 00 00       	add    $0x16a4,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
  800961:	8b 55 08             	mov    0x8(%ebp),%edx
  800964:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096a:	8d 4a ff             	lea    -0x1(%edx),%ecx
  80096d:	8b 55 08             	mov    0x8(%ebp),%edx
  800970:	01 ca                	add    %ecx,%edx
  800972:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800975:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80097c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800980:	74 06                	je     800988 <vsnprintf+0x3b>
  800982:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800986:	7f 07                	jg     80098f <vsnprintf+0x42>
		return -E_INVAL;
  800988:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80098d:	eb 22                	jmp    8009b1 <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80098f:	ff 75 14             	pushl  0x14(%ebp)
  800992:	ff 75 10             	pushl  0x10(%ebp)
  800995:	8d 55 ec             	lea    -0x14(%ebp),%edx
  800998:	52                   	push   %edx
  800999:	8d 80 09 e9 ff ff    	lea    -0x16f7(%eax),%eax
  80099f:	50                   	push   %eax
  8009a0:	e8 71 fb ff ff       	call   800516 <vprintfmt>
  8009a5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009b1:	c9                   	leave  
  8009b2:	c3                   	ret    

008009b3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b3:	f3 0f 1e fb          	endbr32 
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 18             	sub    $0x18,%esp
  8009bd:	e8 87 f6 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  8009c2:	05 3e 16 00 00       	add    $0x163e,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c7:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d0:	50                   	push   %eax
  8009d1:	ff 75 10             	pushl  0x10(%ebp)
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	ff 75 08             	pushl  0x8(%ebp)
  8009da:	e8 6e ff ff ff       	call   80094d <vsnprintf>
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
  8009e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <__x86.get_pc_thunk.si>:
  8009ea:	8b 34 24             	mov    (%esp),%esi
  8009ed:	c3                   	ret    

008009ee <__x86.get_pc_thunk.di>:
  8009ee:	8b 3c 24             	mov    (%esp),%edi
  8009f1:	c3                   	ret    

008009f2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f2:	f3 0f 1e fb          	endbr32 
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	83 ec 10             	sub    $0x10,%esp
  8009fc:	e8 48 f6 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800a01:	05 ff 15 00 00       	add    $0x15ff,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800a06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0d:	eb 08                	jmp    800a17 <strlen+0x25>
		n++;
  800a0f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
  800a13:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	0f b6 00             	movzbl (%eax),%eax
  800a1d:	84 c0                	test   %al,%al
  800a1f:	75 ee                	jne    800a0f <strlen+0x1d>
	return n;
  800a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a26:	f3 0f 1e fb          	endbr32 
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	83 ec 10             	sub    $0x10,%esp
  800a30:	e8 14 f6 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800a35:	05 cb 15 00 00       	add    $0x15cb,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a41:	eb 0c                	jmp    800a4f <strnlen+0x29>
		n++;
  800a43:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a47:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a4b:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800a4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a53:	74 0a                	je     800a5f <strnlen+0x39>
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	0f b6 00             	movzbl (%eax),%eax
  800a5b:	84 c0                	test   %al,%al
  800a5d:	75 e4                	jne    800a43 <strnlen+0x1d>
	return n;
  800a5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a62:	c9                   	leave  
  800a63:	c3                   	ret    

00800a64 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a64:	f3 0f 1e fb          	endbr32 
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	83 ec 10             	sub    $0x10,%esp
  800a6e:	e8 d6 f5 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800a73:	05 8d 15 00 00       	add    $0x158d,%eax
	char *ret;

	ret = dst;
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a7e:	90                   	nop
  800a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a82:	8d 42 01             	lea    0x1(%edx),%eax
  800a85:	89 45 0c             	mov    %eax,0xc(%ebp)
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8e:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800a91:	0f b6 12             	movzbl (%edx),%edx
  800a94:	88 10                	mov    %dl,(%eax)
  800a96:	0f b6 00             	movzbl (%eax),%eax
  800a99:	84 c0                	test   %al,%al
  800a9b:	75 e2                	jne    800a7f <strcpy+0x1b>
		/* do nothing */;
	return ret;
  800a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800aa2:	f3 0f 1e fb          	endbr32 
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	83 ec 10             	sub    $0x10,%esp
  800aac:	e8 98 f5 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800ab1:	05 4f 15 00 00       	add    $0x154f,%eax
	int len = strlen(dst);
  800ab6:	ff 75 08             	pushl  0x8(%ebp)
  800ab9:	e8 34 ff ff ff       	call   8009f2 <strlen>
  800abe:	83 c4 04             	add    $0x4,%esp
  800ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
  800ac4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	01 d0                	add    %edx,%eax
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	50                   	push   %eax
  800ad0:	e8 8f ff ff ff       	call   800a64 <strcpy>
  800ad5:	83 c4 08             	add    $0x8,%esp
	return dst;
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800adb:	c9                   	leave  
  800adc:	c3                   	ret    

00800add <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800add:	f3 0f 1e fb          	endbr32 
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 10             	sub    $0x10,%esp
  800ae7:	e8 5d f5 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800aec:	05 14 15 00 00       	add    $0x1514,%eax
	size_t i;
	char *ret;

	ret = dst;
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800af7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800afe:	eb 23                	jmp    800b23 <strncpy+0x46>
		*dst++ = *src;
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	8d 50 01             	lea    0x1(%eax),%edx
  800b06:	89 55 08             	mov    %edx,0x8(%ebp)
  800b09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0c:	0f b6 12             	movzbl (%edx),%edx
  800b0f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	0f b6 00             	movzbl (%eax),%eax
  800b17:	84 c0                	test   %al,%al
  800b19:	74 04                	je     800b1f <strncpy+0x42>
			src++;
  800b1b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
  800b1f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800b23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b26:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b29:	72 d5                	jb     800b00 <strncpy+0x23>
	}
	return ret;
  800b2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b30:	f3 0f 1e fb          	endbr32 
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	83 ec 10             	sub    $0x10,%esp
  800b3a:	e8 0a f5 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800b3f:	05 c1 14 00 00       	add    $0x14c1,%eax
	char *dst_in;

	dst_in = dst;
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b4e:	74 33                	je     800b83 <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
  800b50:	eb 17                	jmp    800b69 <strlcpy+0x39>
			*dst++ = *src++;
  800b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b55:	8d 42 01             	lea    0x1(%edx),%eax
  800b58:	89 45 0c             	mov    %eax,0xc(%ebp)
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8d 48 01             	lea    0x1(%eax),%ecx
  800b61:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800b64:	0f b6 12             	movzbl (%edx),%edx
  800b67:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
  800b69:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b71:	74 0a                	je     800b7d <strlcpy+0x4d>
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	0f b6 00             	movzbl (%eax),%eax
  800b79:	84 c0                	test   %al,%al
  800b7b:	75 d5                	jne    800b52 <strlcpy+0x22>
		*dst = '\0';
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b8b:	f3 0f 1e fb          	endbr32 
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	e8 b2 f4 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800b97:	05 69 14 00 00       	add    $0x1469,%eax
	while (*p && *p == *q)
  800b9c:	eb 08                	jmp    800ba6 <strcmp+0x1b>
		p++, q++;
  800b9e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ba2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	0f b6 00             	movzbl (%eax),%eax
  800bac:	84 c0                	test   %al,%al
  800bae:	74 10                	je     800bc0 <strcmp+0x35>
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	0f b6 10             	movzbl (%eax),%edx
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	0f b6 00             	movzbl (%eax),%eax
  800bbc:	38 c2                	cmp    %al,%dl
  800bbe:	74 de                	je     800b9e <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	0f b6 00             	movzbl (%eax),%eax
  800bc6:	0f b6 d0             	movzbl %al,%edx
  800bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcc:	0f b6 00             	movzbl (%eax),%eax
  800bcf:	0f b6 c0             	movzbl %al,%eax
  800bd2:	29 c2                	sub    %eax,%edx
  800bd4:	89 d0                	mov    %edx,%eax
}
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bd8:	f3 0f 1e fb          	endbr32 
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	e8 65 f4 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800be4:	05 1c 14 00 00       	add    $0x141c,%eax
	while (n > 0 && *p && *p == *q)
  800be9:	eb 0c                	jmp    800bf7 <strncmp+0x1f>
		n--, p++, q++;
  800beb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800bef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bf3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
  800bf7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bfb:	74 1a                	je     800c17 <strncmp+0x3f>
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	0f b6 00             	movzbl (%eax),%eax
  800c03:	84 c0                	test   %al,%al
  800c05:	74 10                	je     800c17 <strncmp+0x3f>
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	0f b6 10             	movzbl (%eax),%edx
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	0f b6 00             	movzbl (%eax),%eax
  800c13:	38 c2                	cmp    %al,%dl
  800c15:	74 d4                	je     800beb <strncmp+0x13>
	if (n == 0)
  800c17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c1b:	75 07                	jne    800c24 <strncmp+0x4c>
		return 0;
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c22:	eb 16                	jmp    800c3a <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	0f b6 00             	movzbl (%eax),%eax
  800c2a:	0f b6 d0             	movzbl %al,%edx
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	0f b6 00             	movzbl (%eax),%eax
  800c33:	0f b6 c0             	movzbl %al,%eax
  800c36:	29 c2                	sub    %eax,%edx
  800c38:	89 d0                	mov    %edx,%eax
}
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c3c:	f3 0f 1e fb          	endbr32 
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 04             	sub    $0x4,%esp
  800c46:	e8 fe f3 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800c4b:	05 b5 13 00 00       	add    $0x13b5,%eax
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c56:	eb 14                	jmp    800c6c <strchr+0x30>
		if (*s == c)
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	0f b6 00             	movzbl (%eax),%eax
  800c5e:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800c61:	75 05                	jne    800c68 <strchr+0x2c>
			return (char *) s;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	eb 13                	jmp    800c7b <strchr+0x3f>
	for (; *s; s++)
  800c68:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	0f b6 00             	movzbl (%eax),%eax
  800c72:	84 c0                	test   %al,%al
  800c74:	75 e2                	jne    800c58 <strchr+0x1c>
	return 0;
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7b:	c9                   	leave  
  800c7c:	c3                   	ret    

00800c7d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c7d:	f3 0f 1e fb          	endbr32 
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 04             	sub    $0x4,%esp
  800c87:	e8 bd f3 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800c8c:	05 74 13 00 00       	add    $0x1374,%eax
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c97:	eb 0f                	jmp    800ca8 <strfind+0x2b>
		if (*s == c)
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	0f b6 00             	movzbl (%eax),%eax
  800c9f:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800ca2:	74 10                	je     800cb4 <strfind+0x37>
	for (; *s; s++)
  800ca4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	0f b6 00             	movzbl (%eax),%eax
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 e7                	jne    800c99 <strfind+0x1c>
  800cb2:	eb 01                	jmp    800cb5 <strfind+0x38>
			break;
  800cb4:	90                   	nop
	return (char *) s;
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cba:	f3 0f 1e fb          	endbr32 
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	57                   	push   %edi
  800cc2:	e8 82 f3 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800cc7:	05 39 13 00 00       	add    $0x1339,%eax
	char *p;

	if (n == 0)
  800ccc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd0:	75 05                	jne    800cd7 <memset+0x1d>
		return v;
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	eb 5c                	jmp    800d33 <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	83 e0 03             	and    $0x3,%eax
  800cdd:	85 c0                	test   %eax,%eax
  800cdf:	75 41                	jne    800d22 <memset+0x68>
  800ce1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce4:	83 e0 03             	and    $0x3,%eax
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	75 37                	jne    800d22 <memset+0x68>
		c &= 0xFF;
  800ceb:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf5:	c1 e0 18             	shl    $0x18,%eax
  800cf8:	89 c2                	mov    %eax,%edx
  800cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfd:	c1 e0 10             	shl    $0x10,%eax
  800d00:	09 c2                	or     %eax,%edx
  800d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d05:	c1 e0 08             	shl    $0x8,%eax
  800d08:	09 d0                	or     %edx,%eax
  800d0a:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	c1 e8 02             	shr    $0x2,%eax
  800d13:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	89 d7                	mov    %edx,%edi
  800d1d:	fc                   	cld    
  800d1e:	f3 ab                	rep stos %eax,%es:(%edi)
  800d20:	eb 0e                	jmp    800d30 <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d22:	8b 55 08             	mov    0x8(%ebp),%edx
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d2b:	89 d7                	mov    %edx,%edi
  800d2d:	fc                   	cld    
  800d2e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d36:	f3 0f 1e fb          	endbr32 
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	57                   	push   %edi
  800d3e:	56                   	push   %esi
  800d3f:	53                   	push   %ebx
  800d40:	83 ec 10             	sub    $0x10,%esp
  800d43:	e8 01 f3 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800d48:	05 b8 12 00 00       	add    $0x12b8,%eax
	const char *s;
	char *d;

	s = src;
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
  800d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d5f:	73 6d                	jae    800dce <memmove+0x98>
  800d61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d64:	8b 45 10             	mov    0x10(%ebp),%eax
  800d67:	01 d0                	add    %edx,%eax
  800d69:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  800d6c:	73 60                	jae    800dce <memmove+0x98>
		s += n;
  800d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d71:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
  800d74:	8b 45 10             	mov    0x10(%ebp),%eax
  800d77:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d7d:	83 e0 03             	and    $0x3,%eax
  800d80:	85 c0                	test   %eax,%eax
  800d82:	75 2f                	jne    800db3 <memmove+0x7d>
  800d84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d87:	83 e0 03             	and    $0x3,%eax
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	75 25                	jne    800db3 <memmove+0x7d>
  800d8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d91:	83 e0 03             	and    $0x3,%eax
  800d94:	85 c0                	test   %eax,%eax
  800d96:	75 1b                	jne    800db3 <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9b:	83 e8 04             	sub    $0x4,%eax
  800d9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800da1:	83 ea 04             	sub    $0x4,%edx
  800da4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800da7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800daa:	89 c7                	mov    %eax,%edi
  800dac:	89 d6                	mov    %edx,%esi
  800dae:	fd                   	std    
  800daf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800db1:	eb 18                	jmp    800dcb <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dbc:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
  800dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc2:	89 d7                	mov    %edx,%edi
  800dc4:	89 de                	mov    %ebx,%esi
  800dc6:	89 c1                	mov    %eax,%ecx
  800dc8:	fd                   	std    
  800dc9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dcb:	fc                   	cld    
  800dcc:	eb 45                	jmp    800e13 <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd1:	83 e0 03             	and    $0x3,%eax
  800dd4:	85 c0                	test   %eax,%eax
  800dd6:	75 2b                	jne    800e03 <memmove+0xcd>
  800dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ddb:	83 e0 03             	and    $0x3,%eax
  800dde:	85 c0                	test   %eax,%eax
  800de0:	75 21                	jne    800e03 <memmove+0xcd>
  800de2:	8b 45 10             	mov    0x10(%ebp),%eax
  800de5:	83 e0 03             	and    $0x3,%eax
  800de8:	85 c0                	test   %eax,%eax
  800dea:	75 17                	jne    800e03 <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	c1 e8 02             	shr    $0x2,%eax
  800df2:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
  800df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800dfa:	89 c7                	mov    %eax,%edi
  800dfc:	89 d6                	mov    %edx,%esi
  800dfe:	fc                   	cld    
  800dff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e01:	eb 10                	jmp    800e13 <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
  800e03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e0c:	89 c7                	mov    %eax,%edi
  800e0e:	89 d6                	mov    %edx,%esi
  800e10:	fc                   	cld    
  800e11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e16:	83 c4 10             	add    $0x10,%esp
  800e19:	5b                   	pop    %ebx
  800e1a:	5e                   	pop    %esi
  800e1b:	5f                   	pop    %edi
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    

00800e1e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e1e:	f3 0f 1e fb          	endbr32 
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	e8 1f f2 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800e2a:	05 d6 11 00 00       	add    $0x11d6,%eax
	return memmove(dst, src, n);
  800e2f:	ff 75 10             	pushl  0x10(%ebp)
  800e32:	ff 75 0c             	pushl  0xc(%ebp)
  800e35:	ff 75 08             	pushl  0x8(%ebp)
  800e38:	e8 f9 fe ff ff       	call   800d36 <memmove>
  800e3d:	83 c4 0c             	add    $0xc,%esp
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e42:	f3 0f 1e fb          	endbr32 
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
  800e4c:	e8 f8 f1 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800e51:	05 af 11 00 00       	add    $0x11af,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e62:	eb 30                	jmp    800e94 <memcmp+0x52>
		if (*s1 != *s2)
  800e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e67:	0f b6 10             	movzbl (%eax),%edx
  800e6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6d:	0f b6 00             	movzbl (%eax),%eax
  800e70:	38 c2                	cmp    %al,%dl
  800e72:	74 18                	je     800e8c <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
  800e74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e77:	0f b6 00             	movzbl (%eax),%eax
  800e7a:	0f b6 d0             	movzbl %al,%edx
  800e7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e80:	0f b6 00             	movzbl (%eax),%eax
  800e83:	0f b6 c0             	movzbl %al,%eax
  800e86:	29 c2                	sub    %eax,%edx
  800e88:	89 d0                	mov    %edx,%eax
  800e8a:	eb 1a                	jmp    800ea6 <memcmp+0x64>
		s1++, s2++;
  800e8c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800e90:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
  800e94:	8b 45 10             	mov    0x10(%ebp),%eax
  800e97:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e9a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9d:	85 c0                	test   %eax,%eax
  800e9f:	75 c3                	jne    800e64 <memcmp+0x22>
	}

	return 0;
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea6:	c9                   	leave  
  800ea7:	c3                   	ret    

00800ea8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ea8:	f3 0f 1e fb          	endbr32 
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 10             	sub    $0x10,%esp
  800eb2:	e8 92 f1 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800eb7:	05 49 11 00 00       	add    $0x1149,%eax
	const void *ends = (const char *) s + n;
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ec7:	eb 11                	jmp    800eda <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	0f b6 00             	movzbl (%eax),%eax
  800ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed2:	38 d0                	cmp    %dl,%al
  800ed4:	74 0e                	je     800ee4 <memfind+0x3c>
	for (; s < ends; s++)
  800ed6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee0:	72 e7                	jb     800ec9 <memfind+0x21>
  800ee2:	eb 01                	jmp    800ee5 <memfind+0x3d>
			break;
  800ee4:	90                   	nop
	return (void *) s;
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee8:	c9                   	leave  
  800ee9:	c3                   	ret    

00800eea <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eea:	f3 0f 1e fb          	endbr32 
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
  800ef4:	e8 50 f1 ff ff       	call   800049 <__x86.get_pc_thunk.ax>
  800ef9:	05 07 11 00 00       	add    $0x1107,%eax
	int neg = 0;
  800efe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f05:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0c:	eb 04                	jmp    800f12 <strtol+0x28>
		s++;
  800f0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	0f b6 00             	movzbl (%eax),%eax
  800f18:	3c 20                	cmp    $0x20,%al
  800f1a:	74 f2                	je     800f0e <strtol+0x24>
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	0f b6 00             	movzbl (%eax),%eax
  800f22:	3c 09                	cmp    $0x9,%al
  800f24:	74 e8                	je     800f0e <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	0f b6 00             	movzbl (%eax),%eax
  800f2c:	3c 2b                	cmp    $0x2b,%al
  800f2e:	75 06                	jne    800f36 <strtol+0x4c>
		s++;
  800f30:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f34:	eb 15                	jmp    800f4b <strtol+0x61>
	else if (*s == '-')
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	0f b6 00             	movzbl (%eax),%eax
  800f3c:	3c 2d                	cmp    $0x2d,%al
  800f3e:	75 0b                	jne    800f4b <strtol+0x61>
		s++, neg = 1;
  800f40:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f44:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4f:	74 06                	je     800f57 <strtol+0x6d>
  800f51:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f55:	75 24                	jne    800f7b <strtol+0x91>
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	0f b6 00             	movzbl (%eax),%eax
  800f5d:	3c 30                	cmp    $0x30,%al
  800f5f:	75 1a                	jne    800f7b <strtol+0x91>
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	83 c0 01             	add    $0x1,%eax
  800f67:	0f b6 00             	movzbl (%eax),%eax
  800f6a:	3c 78                	cmp    $0x78,%al
  800f6c:	75 0d                	jne    800f7b <strtol+0x91>
		s += 2, base = 16;
  800f6e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f72:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f79:	eb 2a                	jmp    800fa5 <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 17                	jne    800f98 <strtol+0xae>
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	0f b6 00             	movzbl (%eax),%eax
  800f87:	3c 30                	cmp    $0x30,%al
  800f89:	75 0d                	jne    800f98 <strtol+0xae>
		s++, base = 8;
  800f8b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f8f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f96:	eb 0d                	jmp    800fa5 <strtol+0xbb>
	else if (base == 0)
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	75 07                	jne    800fa5 <strtol+0xbb>
		base = 10;
  800f9e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	0f b6 00             	movzbl (%eax),%eax
  800fab:	3c 2f                	cmp    $0x2f,%al
  800fad:	7e 1b                	jle    800fca <strtol+0xe0>
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	0f b6 00             	movzbl (%eax),%eax
  800fb5:	3c 39                	cmp    $0x39,%al
  800fb7:	7f 11                	jg     800fca <strtol+0xe0>
			dig = *s - '0';
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	0f b6 00             	movzbl (%eax),%eax
  800fbf:	0f be c0             	movsbl %al,%eax
  800fc2:	83 e8 30             	sub    $0x30,%eax
  800fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc8:	eb 48                	jmp    801012 <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	0f b6 00             	movzbl (%eax),%eax
  800fd0:	3c 60                	cmp    $0x60,%al
  800fd2:	7e 1b                	jle    800fef <strtol+0x105>
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	0f b6 00             	movzbl (%eax),%eax
  800fda:	3c 7a                	cmp    $0x7a,%al
  800fdc:	7f 11                	jg     800fef <strtol+0x105>
			dig = *s - 'a' + 10;
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	0f b6 00             	movzbl (%eax),%eax
  800fe4:	0f be c0             	movsbl %al,%eax
  800fe7:	83 e8 57             	sub    $0x57,%eax
  800fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fed:	eb 23                	jmp    801012 <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	0f b6 00             	movzbl (%eax),%eax
  800ff5:	3c 40                	cmp    $0x40,%al
  800ff7:	7e 3c                	jle    801035 <strtol+0x14b>
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	0f b6 00             	movzbl (%eax),%eax
  800fff:	3c 5a                	cmp    $0x5a,%al
  801001:	7f 32                	jg     801035 <strtol+0x14b>
			dig = *s - 'A' + 10;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	0f b6 00             	movzbl (%eax),%eax
  801009:	0f be c0             	movsbl %al,%eax
  80100c:	83 e8 37             	sub    $0x37,%eax
  80100f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801015:	3b 45 10             	cmp    0x10(%ebp),%eax
  801018:	7d 1a                	jge    801034 <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
  80101a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80101e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801021:	0f af 45 10          	imul   0x10(%ebp),%eax
  801025:	89 c2                	mov    %eax,%edx
  801027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
  80102f:	e9 71 ff ff ff       	jmp    800fa5 <strtol+0xbb>
			break;
  801034:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
  801035:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801039:	74 08                	je     801043 <strtol+0x159>
		*endptr = (char *) s;
  80103b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
  801041:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801043:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801047:	74 07                	je     801050 <strtol+0x166>
  801049:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104c:	f7 d8                	neg    %eax
  80104e:	eb 03                	jmp    801053 <strtol+0x169>
  801050:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801053:	c9                   	leave  
  801054:	c3                   	ret    
  801055:	66 90                	xchg   %ax,%ax
  801057:	66 90                	xchg   %ax,%ax
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
