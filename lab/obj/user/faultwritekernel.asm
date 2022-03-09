
obj/user/faultwritekernel:     file format elf32-i386


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
  80002c:	e8 25 00 00 00       	call   800056 <libmain>
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
  80003a:	e8 13 00 00 00       	call   800052 <__x86.get_pc_thunk.ax>
  80003f:	05 c1 1f 00 00       	add    $0x1fc1,%eax
	*(unsigned*)0xf0100000 = 0;
  800044:	b8 00 00 10 f0       	mov    $0xf0100000,%eax
  800049:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
  80004f:	90                   	nop
  800050:	5d                   	pop    %ebp
  800051:	c3                   	ret    

00800052 <__x86.get_pc_thunk.ax>:
  800052:	8b 04 24             	mov    (%esp),%eax
  800055:	c3                   	ret    

00800056 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800056:	f3 0f 1e fb          	endbr32 
  80005a:	55                   	push   %ebp
  80005b:	89 e5                	mov    %esp,%ebp
  80005d:	53                   	push   %ebx
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	e8 5a 00 00 00       	call   8000c0 <__x86.get_pc_thunk.bx>
  800066:	81 c3 9a 1f 00 00    	add    $0x1f9a,%ebx
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code h(ere.
	thisenv = envs + ENVX(sys_getenvid());
  80006c:	e8 76 01 00 00       	call   8001e7 <sys_getenvid>
  800071:	25 ff 03 00 00       	and    $0x3ff,%eax
  800076:	89 c2                	mov    %eax,%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	01 c0                	add    %eax,%eax
  80007c:	01 d0                	add    %edx,%eax
  80007e:	c1 e0 05             	shl    $0x5,%eax
  800081:	89 c2                	mov    %eax,%edx
  800083:	c7 c0 00 00 c0 ee    	mov    $0xeec00000,%eax
  800089:	01 c2                	add    %eax,%edx
  80008b:	c7 c0 2c 20 80 00    	mov    $0x80202c,%eax
  800091:	89 10                	mov    %edx,(%eax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800093:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800097:	7e 0b                	jle    8000a4 <libmain+0x4e>
		binaryname = argv[0];
  800099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80009c:	8b 00                	mov    (%eax),%eax
  80009e:	89 83 0c 00 00 00    	mov    %eax,0xc(%ebx)

	// call user main routine
	umain(argc, argv);
  8000a4:	83 ec 08             	sub    $0x8,%esp
  8000a7:	ff 75 0c             	pushl  0xc(%ebp)
  8000aa:	ff 75 08             	pushl  0x8(%ebp)
  8000ad:	e8 81 ff ff ff       	call   800033 <umain>
  8000b2:	83 c4 10             	add    $0x10,%esp

	// exit gracefully
	exit();
  8000b5:	e8 0a 00 00 00       	call   8000c4 <exit>
}
  8000ba:	90                   	nop
  8000bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <__x86.get_pc_thunk.bx>:
  8000c0:	8b 1c 24             	mov    (%esp),%ebx
  8000c3:	c3                   	ret    

008000c4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c4:	f3 0f 1e fb          	endbr32 
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	53                   	push   %ebx
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	e8 7e ff ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  8000d4:	05 2c 1f 00 00       	add    $0x1f2c,%eax
	sys_env_destroy(0);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	6a 00                	push   $0x0
  8000de:	89 c3                	mov    %eax,%ebx
  8000e0:	e8 d1 00 00 00       	call   8001b6 <sys_env_destroy>
  8000e5:	83 c4 10             	add    $0x10,%esp
}
  8000e8:	90                   	nop
  8000e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ec:	c9                   	leave  
  8000ed:	c3                   	ret    

008000ee <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int32_t
syscall(int num, int check, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
  8000ee:	55                   	push   %ebp
  8000ef:	89 e5                	mov    %esp,%ebp
  8000f1:	57                   	push   %edi
  8000f2:	56                   	push   %esi
  8000f3:	53                   	push   %ebx
  8000f4:	83 ec 2c             	sub    $0x2c,%esp
  8000f7:	e8 c4 ff ff ff       	call   8000c0 <__x86.get_pc_thunk.bx>
  8000fc:	81 c3 04 1f 00 00    	add    $0x1f04,%ebx
  800102:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800105:	8b 45 08             	mov    0x8(%ebp),%eax
  800108:	8b 55 10             	mov    0x10(%ebp),%edx
  80010b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80010e:	8b 5d 18             	mov    0x18(%ebp),%ebx
  800111:	8b 7d 1c             	mov    0x1c(%ebp),%edi
  800114:	8b 75 20             	mov    0x20(%ebp),%esi
  800117:	cd 30                	int    $0x30
  800119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80011c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800120:	74 27                	je     800149 <syscall+0x5b>
  800122:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800126:	7e 21                	jle    800149 <syscall+0x5b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80012e:	ff 75 08             	pushl  0x8(%ebp)
  800131:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800134:	8d 83 ca f2 ff ff    	lea    -0xd36(%ebx),%eax
  80013a:	50                   	push   %eax
  80013b:	6a 23                	push   $0x23
  80013d:	8d 83 e7 f2 ff ff    	lea    -0xd19(%ebx),%eax
  800143:	50                   	push   %eax
  800144:	e8 cd 00 00 00       	call   800216 <_panic>

	return ret;
  800149:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80014c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80014f:	5b                   	pop    %ebx
  800150:	5e                   	pop    %esi
  800151:	5f                   	pop    %edi
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    

00800154 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800154:	f3 0f 1e fb          	endbr32 
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	e8 ef fe ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800163:	05 9d 1e 00 00       	add    $0x1e9d,%eax
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
  800168:	8b 45 08             	mov    0x8(%ebp),%eax
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	6a 00                	push   $0x0
  800170:	6a 00                	push   $0x0
  800172:	6a 00                	push   $0x0
  800174:	ff 75 0c             	pushl  0xc(%ebp)
  800177:	50                   	push   %eax
  800178:	6a 00                	push   $0x0
  80017a:	6a 00                	push   $0x0
  80017c:	e8 6d ff ff ff       	call   8000ee <syscall>
  800181:	83 c4 20             	add    $0x20,%esp
}
  800184:	90                   	nop
  800185:	c9                   	leave  
  800186:	c3                   	ret    

00800187 <sys_cgetc>:

int
sys_cgetc(void)
{
  800187:	f3 0f 1e fb          	endbr32 
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	83 ec 08             	sub    $0x8,%esp
  800191:	e8 bc fe ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800196:	05 6a 1e 00 00       	add    $0x1e6a,%eax
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	6a 00                	push   $0x0
  8001a0:	6a 00                	push   $0x0
  8001a2:	6a 00                	push   $0x0
  8001a4:	6a 00                	push   $0x0
  8001a6:	6a 00                	push   $0x0
  8001a8:	6a 00                	push   $0x0
  8001aa:	6a 01                	push   $0x1
  8001ac:	e8 3d ff ff ff       	call   8000ee <syscall>
  8001b1:	83 c4 20             	add    $0x20,%esp
}
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8001b6:	f3 0f 1e fb          	endbr32 
  8001ba:	55                   	push   %ebp
  8001bb:	89 e5                	mov    %esp,%ebp
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	e8 8d fe ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  8001c5:	05 3b 1e 00 00       	add    $0x1e3b,%eax
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8001ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cd:	83 ec 04             	sub    $0x4,%esp
  8001d0:	6a 00                	push   $0x0
  8001d2:	6a 00                	push   $0x0
  8001d4:	6a 00                	push   $0x0
  8001d6:	6a 00                	push   $0x0
  8001d8:	50                   	push   %eax
  8001d9:	6a 01                	push   $0x1
  8001db:	6a 03                	push   $0x3
  8001dd:	e8 0c ff ff ff       	call   8000ee <syscall>
  8001e2:	83 c4 20             	add    $0x20,%esp
}
  8001e5:	c9                   	leave  
  8001e6:	c3                   	ret    

008001e7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8001e7:	f3 0f 1e fb          	endbr32 
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	e8 5c fe ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  8001f6:	05 0a 1e 00 00       	add    $0x1e0a,%eax
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8001fb:	83 ec 04             	sub    $0x4,%esp
  8001fe:	6a 00                	push   $0x0
  800200:	6a 00                	push   $0x0
  800202:	6a 00                	push   $0x0
  800204:	6a 00                	push   $0x0
  800206:	6a 00                	push   $0x0
  800208:	6a 00                	push   $0x0
  80020a:	6a 02                	push   $0x2
  80020c:	e8 dd fe ff ff       	call   8000ee <syscall>
  800211:	83 c4 20             	add    $0x20,%esp
}
  800214:	c9                   	leave  
  800215:	c3                   	ret    

00800216 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800216:	f3 0f 1e fb          	endbr32 
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	56                   	push   %esi
  80021e:	53                   	push   %ebx
  80021f:	83 ec 10             	sub    $0x10,%esp
  800222:	e8 99 fe ff ff       	call   8000c0 <__x86.get_pc_thunk.bx>
  800227:	81 c3 d9 1d 00 00    	add    $0x1dd9,%ebx
	va_list ap;

	va_start(ap, fmt);
  80022d:	8d 45 14             	lea    0x14(%ebp),%eax
  800230:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800233:	c7 c0 0c 20 80 00    	mov    $0x80200c,%eax
  800239:	8b 30                	mov    (%eax),%esi
  80023b:	e8 a7 ff ff ff       	call   8001e7 <sys_getenvid>
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	ff 75 0c             	pushl  0xc(%ebp)
  800246:	ff 75 08             	pushl  0x8(%ebp)
  800249:	56                   	push   %esi
  80024a:	50                   	push   %eax
  80024b:	8d 83 f8 f2 ff ff    	lea    -0xd08(%ebx),%eax
  800251:	50                   	push   %eax
  800252:	e8 0f 01 00 00       	call   800366 <cprintf>
  800257:	83 c4 20             	add    $0x20,%esp
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	50                   	push   %eax
  800261:	ff 75 10             	pushl  0x10(%ebp)
  800264:	e8 8d 00 00 00       	call   8002f6 <vcprintf>
  800269:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	8d 83 1b f3 ff ff    	lea    -0xce5(%ebx),%eax
  800275:	50                   	push   %eax
  800276:	e8 eb 00 00 00       	call   800366 <cprintf>
  80027b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80027e:	cc                   	int3   
  80027f:	eb fd                	jmp    80027e <_panic+0x68>

00800281 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800281:	f3 0f 1e fb          	endbr32 
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	53                   	push   %ebx
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	e8 09 01 00 00       	call   80039a <__x86.get_pc_thunk.dx>
  800291:	81 c2 6f 1d 00 00    	add    $0x1d6f,%edx
	b->buf[b->idx++] = ch;
  800297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029a:	8b 00                	mov    (%eax),%eax
  80029c:	8d 58 01             	lea    0x1(%eax),%ebx
  80029f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a2:	89 19                	mov    %ebx,(%ecx)
  8002a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a7:	89 cb                	mov    %ecx,%ebx
  8002a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ac:	88 5c 01 08          	mov    %bl,0x8(%ecx,%eax,1)
	if (b->idx == 256-1) {
  8002b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b3:	8b 00                	mov    (%eax),%eax
  8002b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ba:	75 25                	jne    8002e1 <putch+0x60>
		sys_cputs(b->buf, b->idx);
  8002bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bf:	8b 00                	mov    (%eax),%eax
  8002c1:	89 c1                	mov    %eax,%ecx
  8002c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c6:	83 c0 08             	add    $0x8,%eax
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	51                   	push   %ecx
  8002cd:	50                   	push   %eax
  8002ce:	89 d3                	mov    %edx,%ebx
  8002d0:	e8 7f fe ff ff       	call   800154 <sys_cputs>
  8002d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e4:	8b 40 04             	mov    0x4(%eax),%eax
  8002e7:	8d 50 01             	lea    0x1(%eax),%edx
  8002ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002f0:	90                   	nop
  8002f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002f4:	c9                   	leave  
  8002f5:	c3                   	ret    

008002f6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002f6:	f3 0f 1e fb          	endbr32 
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	53                   	push   %ebx
  8002fe:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800304:	e8 b7 fd ff ff       	call   8000c0 <__x86.get_pc_thunk.bx>
  800309:	81 c3 f7 1c 00 00    	add    $0x1cf7,%ebx
	struct printbuf b;

	b.idx = 0;
  80030f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800316:	00 00 00 
	b.cnt = 0;
  800319:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800320:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032f:	50                   	push   %eax
  800330:	8d 83 81 e2 ff ff    	lea    -0x1d7f(%ebx),%eax
  800336:	50                   	push   %eax
  800337:	e8 e3 01 00 00       	call   80051f <vprintfmt>
  80033c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx);
  80033f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	50                   	push   %eax
  800349:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034f:	83 c0 08             	add    $0x8,%eax
  800352:	50                   	push   %eax
  800353:	e8 fc fd ff ff       	call   800154 <sys_cputs>
  800358:	83 c4 10             	add    $0x10,%esp

	return b.cnt;
  80035b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800361:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800364:	c9                   	leave  
  800365:	c3                   	ret    

00800366 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800366:	f3 0f 1e fb          	endbr32 
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 18             	sub    $0x18,%esp
  800370:	e8 dd fc ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800375:	05 8b 1c 00 00       	add    $0x1c8b,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80037a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
  800380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800383:	83 ec 08             	sub    $0x8,%esp
  800386:	50                   	push   %eax
  800387:	ff 75 08             	pushl  0x8(%ebp)
  80038a:	e8 67 ff ff ff       	call   8002f6 <vcprintf>
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
  800395:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <__x86.get_pc_thunk.dx>:
  80039a:	8b 14 24             	mov    (%esp),%edx
  80039d:	c3                   	ret    

0080039e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80039e:	f3 0f 1e fb          	endbr32 
  8003a2:	55                   	push   %ebp
  8003a3:	89 e5                	mov    %esp,%ebp
  8003a5:	57                   	push   %edi
  8003a6:	56                   	push   %esi
  8003a7:	53                   	push   %ebx
  8003a8:	83 ec 1c             	sub    $0x1c,%esp
  8003ab:	e8 43 06 00 00       	call   8009f3 <__x86.get_pc_thunk.si>
  8003b0:	81 c6 50 1c 00 00    	add    $0x1c50,%esi
  8003b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003cd:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8003d0:	19 d1                	sbb    %edx,%ecx
  8003d2:	72 4d                	jb     800421 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d7:	8d 78 ff             	lea    -0x1(%eax),%edi
  8003da:	8b 45 18             	mov    0x18(%ebp),%eax
  8003dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e2:	52                   	push   %edx
  8003e3:	50                   	push   %eax
  8003e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ea:	89 f3                	mov    %esi,%ebx
  8003ec:	e8 6f 0c 00 00       	call   801060 <__udivdi3>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	83 ec 04             	sub    $0x4,%esp
  8003f7:	ff 75 20             	pushl  0x20(%ebp)
  8003fa:	57                   	push   %edi
  8003fb:	ff 75 18             	pushl  0x18(%ebp)
  8003fe:	52                   	push   %edx
  8003ff:	50                   	push   %eax
  800400:	ff 75 0c             	pushl  0xc(%ebp)
  800403:	ff 75 08             	pushl  0x8(%ebp)
  800406:	e8 93 ff ff ff       	call   80039e <printnum>
  80040b:	83 c4 20             	add    $0x20,%esp
  80040e:	eb 1b                	jmp    80042b <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	ff 75 0c             	pushl  0xc(%ebp)
  800416:	ff 75 20             	pushl  0x20(%ebp)
  800419:	8b 45 08             	mov    0x8(%ebp),%eax
  80041c:	ff d0                	call   *%eax
  80041e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800421:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  800425:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800429:	7f e5                	jg     800410 <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80042e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800436:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800439:	53                   	push   %ebx
  80043a:	51                   	push   %ecx
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	89 f3                	mov    %esi,%ebx
  80043f:	e8 2c 0d 00 00       	call   801170 <__umoddi3>
  800444:	83 c4 10             	add    $0x10,%esp
  800447:	8d 8e 89 f3 ff ff    	lea    -0xc77(%esi),%ecx
  80044d:	01 c8                	add    %ecx,%eax
  80044f:	0f b6 00             	movzbl (%eax),%eax
  800452:	0f be c0             	movsbl %al,%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	ff 75 0c             	pushl  0xc(%ebp)
  80045b:	50                   	push   %eax
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	ff d0                	call   *%eax
  800461:	83 c4 10             	add    $0x10,%esp
}
  800464:	90                   	nop
  800465:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800468:	5b                   	pop    %ebx
  800469:	5e                   	pop    %esi
  80046a:	5f                   	pop    %edi
  80046b:	5d                   	pop    %ebp
  80046c:	c3                   	ret    

0080046d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80046d:	f3 0f 1e fb          	endbr32 
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	e8 d9 fb ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800479:	05 87 1b 00 00       	add    $0x1b87,%eax
	if (lflag >= 2)
  80047e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800482:	7e 14                	jle    800498 <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	8b 00                	mov    (%eax),%eax
  800489:	8d 48 08             	lea    0x8(%eax),%ecx
  80048c:	8b 55 08             	mov    0x8(%ebp),%edx
  80048f:	89 0a                	mov    %ecx,(%edx)
  800491:	8b 50 04             	mov    0x4(%eax),%edx
  800494:	8b 00                	mov    (%eax),%eax
  800496:	eb 30                	jmp    8004c8 <getuint+0x5b>
	else if (lflag)
  800498:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80049c:	74 16                	je     8004b4 <getuint+0x47>
		return va_arg(*ap, unsigned long);
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	8d 48 04             	lea    0x4(%eax),%ecx
  8004a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a9:	89 0a                	mov    %ecx,(%edx)
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b2:	eb 14                	jmp    8004c8 <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 48 04             	lea    0x4(%eax),%ecx
  8004bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8004bf:	89 0a                	mov    %ecx,(%edx)
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c8:	5d                   	pop    %ebp
  8004c9:	c3                   	ret    

008004ca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004ca:	f3 0f 1e fb          	endbr32 
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	e8 7c fb ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  8004d6:	05 2a 1b 00 00       	add    $0x1b2a,%eax
	if (lflag >= 2)
  8004db:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004df:	7e 14                	jle    8004f5 <getint+0x2b>
		return va_arg(*ap, long long);
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 48 08             	lea    0x8(%eax),%ecx
  8004e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ec:	89 0a                	mov    %ecx,(%edx)
  8004ee:	8b 50 04             	mov    0x4(%eax),%edx
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	eb 28                	jmp    80051d <getint+0x53>
	else if (lflag)
  8004f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f9:	74 12                	je     80050d <getint+0x43>
		return va_arg(*ap, long);
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 48 04             	lea    0x4(%eax),%ecx
  800503:	8b 55 08             	mov    0x8(%ebp),%edx
  800506:	89 0a                	mov    %ecx,(%edx)
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	99                   	cltd   
  80050b:	eb 10                	jmp    80051d <getint+0x53>
	else
		return va_arg(*ap, int);
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	8d 48 04             	lea    0x4(%eax),%ecx
  800515:	8b 55 08             	mov    0x8(%ebp),%edx
  800518:	89 0a                	mov    %ecx,(%edx)
  80051a:	8b 00                	mov    (%eax),%eax
  80051c:	99                   	cltd   
}
  80051d:	5d                   	pop    %ebp
  80051e:	c3                   	ret    

0080051f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80051f:	f3 0f 1e fb          	endbr32 
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	57                   	push   %edi
  800527:	56                   	push   %esi
  800528:	53                   	push   %ebx
  800529:	83 ec 2c             	sub    $0x2c,%esp
  80052c:	e8 c6 04 00 00       	call   8009f7 <__x86.get_pc_thunk.di>
  800531:	81 c7 cf 1a 00 00    	add    $0x1acf,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800537:	eb 17                	jmp    800550 <vprintfmt+0x31>
			if (ch == '\0')
  800539:	85 db                	test   %ebx,%ebx
  80053b:	0f 84 96 03 00 00    	je     8008d7 <.L20+0x2d>
				return;
			putch(ch, putdat);
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 0c             	pushl  0xc(%ebp)
  800547:	53                   	push   %ebx
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	ff d0                	call   *%eax
  80054d:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800550:	8b 45 10             	mov    0x10(%ebp),%eax
  800553:	8d 50 01             	lea    0x1(%eax),%edx
  800556:	89 55 10             	mov    %edx,0x10(%ebp)
  800559:	0f b6 00             	movzbl (%eax),%eax
  80055c:	0f b6 d8             	movzbl %al,%ebx
  80055f:	83 fb 25             	cmp    $0x25,%ebx
  800562:	75 d5                	jne    800539 <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
  800564:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
  800568:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
  80056f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
  800576:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
  80057d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800584:	8b 45 10             	mov    0x10(%ebp),%eax
  800587:	8d 50 01             	lea    0x1(%eax),%edx
  80058a:	89 55 10             	mov    %edx,0x10(%ebp)
  80058d:	0f b6 00             	movzbl (%eax),%eax
  800590:	0f b6 d8             	movzbl %al,%ebx
  800593:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800596:	83 f8 55             	cmp    $0x55,%eax
  800599:	0f 87 0b 03 00 00    	ja     8008aa <.L20>
  80059f:	c1 e0 02             	shl    $0x2,%eax
  8005a2:	8b 84 38 b0 f3 ff ff 	mov    -0xc50(%eax,%edi,1),%eax
  8005a9:	01 f8                	add    %edi,%eax
  8005ab:	3e ff e0             	notrack jmp *%eax

008005ae <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
  8005ae:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
  8005b2:	eb d0                	jmp    800584 <vprintfmt+0x65>

008005b4 <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005b4:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
  8005b8:	eb ca                	jmp    800584 <vprintfmt+0x65>

008005ba <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ba:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
  8005c1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005c4:	89 d0                	mov    %edx,%eax
  8005c6:	c1 e0 02             	shl    $0x2,%eax
  8005c9:	01 d0                	add    %edx,%eax
  8005cb:	01 c0                	add    %eax,%eax
  8005cd:	01 d8                	add    %ebx,%eax
  8005cf:	83 e8 30             	sub    $0x30,%eax
  8005d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
  8005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d8:	0f b6 00             	movzbl (%eax),%eax
  8005db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005de:	83 fb 2f             	cmp    $0x2f,%ebx
  8005e1:	7e 39                	jle    80061c <.L37+0xc>
  8005e3:	83 fb 39             	cmp    $0x39,%ebx
  8005e6:	7f 34                	jg     80061c <.L37+0xc>
			for (precision = 0; ; ++fmt) {
  8005e8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
  8005ec:	eb d3                	jmp    8005c1 <.L31+0x7>

008005ee <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8d 50 04             	lea    0x4(%eax),%edx
  8005f4:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
  8005fc:	eb 1f                	jmp    80061d <.L37+0xd>

008005fe <.L33>:

		case '.':
			if (width < 0)
  8005fe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800602:	79 80                	jns    800584 <vprintfmt+0x65>
				width = 0;
  800604:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
  80060b:	e9 74 ff ff ff       	jmp    800584 <vprintfmt+0x65>

00800610 <.L37>:

		case '#':
			altflag = 1;
  800610:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
  800617:	e9 68 ff ff ff       	jmp    800584 <vprintfmt+0x65>
			goto process_precision;
  80061c:	90                   	nop

		process_precision:
			if (width < 0)
  80061d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800621:	0f 89 5d ff ff ff    	jns    800584 <vprintfmt+0x65>
				width = precision, precision = -1;
  800627:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80062a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80062d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
  800634:	e9 4b ff ff ff       	jmp    800584 <vprintfmt+0x65>

00800639 <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800639:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
  80063d:	e9 42 ff ff ff       	jmp    800584 <vprintfmt+0x65>

00800642 <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8d 50 04             	lea    0x4(%eax),%edx
  800648:	89 55 14             	mov    %edx,0x14(%ebp)
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	83 ec 08             	sub    $0x8,%esp
  800650:	ff 75 0c             	pushl  0xc(%ebp)
  800653:	50                   	push   %eax
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	ff d0                	call   *%eax
  800659:	83 c4 10             	add    $0x10,%esp
			break;
  80065c:	e9 71 02 00 00       	jmp    8008d2 <.L20+0x28>

00800661 <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8d 50 04             	lea    0x4(%eax),%edx
  800667:	89 55 14             	mov    %edx,0x14(%ebp)
  80066a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80066c:	85 db                	test   %ebx,%ebx
  80066e:	79 02                	jns    800672 <.L28+0x11>
				err = -err;
  800670:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800672:	83 fb 06             	cmp    $0x6,%ebx
  800675:	7f 0b                	jg     800682 <.L28+0x21>
  800677:	8b b4 9f 10 00 00 00 	mov    0x10(%edi,%ebx,4),%esi
  80067e:	85 f6                	test   %esi,%esi
  800680:	75 1b                	jne    80069d <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
  800682:	53                   	push   %ebx
  800683:	8d 87 9a f3 ff ff    	lea    -0xc66(%edi),%eax
  800689:	50                   	push   %eax
  80068a:	ff 75 0c             	pushl  0xc(%ebp)
  80068d:	ff 75 08             	pushl  0x8(%ebp)
  800690:	e8 4b 02 00 00       	call   8008e0 <printfmt>
  800695:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800698:	e9 35 02 00 00       	jmp    8008d2 <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
  80069d:	56                   	push   %esi
  80069e:	8d 87 a3 f3 ff ff    	lea    -0xc5d(%edi),%eax
  8006a4:	50                   	push   %eax
  8006a5:	ff 75 0c             	pushl  0xc(%ebp)
  8006a8:	ff 75 08             	pushl  0x8(%ebp)
  8006ab:	e8 30 02 00 00       	call   8008e0 <printfmt>
  8006b0:	83 c4 10             	add    $0x10,%esp
			break;
  8006b3:	e9 1a 02 00 00       	jmp    8008d2 <.L20+0x28>

008006b8 <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8d 50 04             	lea    0x4(%eax),%edx
  8006be:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c1:	8b 30                	mov    (%eax),%esi
  8006c3:	85 f6                	test   %esi,%esi
  8006c5:	75 06                	jne    8006cd <.L24+0x15>
				p = "(null)";
  8006c7:	8d b7 a6 f3 ff ff    	lea    -0xc5a(%edi),%esi
			if (width > 0 && padc != '-')
  8006cd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006d1:	7e 71                	jle    800744 <.L24+0x8c>
  8006d3:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
  8006d7:	74 6b                	je     800744 <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	50                   	push   %eax
  8006e0:	56                   	push   %esi
  8006e1:	89 fb                	mov    %edi,%ebx
  8006e3:	e8 47 03 00 00       	call   800a2f <strnlen>
  8006e8:	83 c4 10             	add    $0x10,%esp
  8006eb:	29 45 d4             	sub    %eax,-0x2c(%ebp)
  8006ee:	eb 17                	jmp    800707 <.L24+0x4f>
					putch(padc, putdat);
  8006f0:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 0c             	pushl  0xc(%ebp)
  8006fa:	50                   	push   %eax
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	ff d0                	call   *%eax
  800700:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
  800703:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800707:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80070b:	7f e3                	jg     8006f0 <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070d:	eb 35                	jmp    800744 <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
  80070f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800713:	74 1c                	je     800731 <.L24+0x79>
  800715:	83 fb 1f             	cmp    $0x1f,%ebx
  800718:	7e 05                	jle    80071f <.L24+0x67>
  80071a:	83 fb 7e             	cmp    $0x7e,%ebx
  80071d:	7e 12                	jle    800731 <.L24+0x79>
					putch('?', putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	6a 3f                	push   $0x3f
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	eb 0f                	jmp    800740 <.L24+0x88>
				else
					putch(ch, putdat);
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	53                   	push   %ebx
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800740:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800744:	89 f0                	mov    %esi,%eax
  800746:	8d 70 01             	lea    0x1(%eax),%esi
  800749:	0f b6 00             	movzbl (%eax),%eax
  80074c:	0f be d8             	movsbl %al,%ebx
  80074f:	85 db                	test   %ebx,%ebx
  800751:	74 26                	je     800779 <.L24+0xc1>
  800753:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800757:	78 b6                	js     80070f <.L24+0x57>
  800759:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  80075d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800761:	79 ac                	jns    80070f <.L24+0x57>
			for (; width > 0; width--)
  800763:	eb 14                	jmp    800779 <.L24+0xc1>
				putch(' ', putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	6a 20                	push   $0x20
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	ff d0                	call   *%eax
  800772:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
  800775:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
  800779:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80077d:	7f e6                	jg     800765 <.L24+0xad>
			break;
  80077f:	e9 4e 01 00 00       	jmp    8008d2 <.L20+0x28>

00800784 <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d8             	pushl  -0x28(%ebp)
  80078a:	8d 45 14             	lea    0x14(%ebp),%eax
  80078d:	50                   	push   %eax
  80078e:	e8 37 fd ff ff       	call   8004ca <getint>
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800799:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
  80079c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80079f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007a2:	85 d2                	test   %edx,%edx
  8007a4:	79 23                	jns    8007c9 <.L29+0x45>
				putch('-', putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ac:	6a 2d                	push   $0x2d
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007bc:	f7 d8                	neg    %eax
  8007be:	83 d2 00             	adc    $0x0,%edx
  8007c1:	f7 da                	neg    %edx
  8007c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
  8007c9:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007d0:	e9 9f 00 00 00       	jmp    800874 <.L21+0x1f>

008007d5 <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8007db:	8d 45 14             	lea    0x14(%ebp),%eax
  8007de:	50                   	push   %eax
  8007df:	e8 89 fc ff ff       	call   80046d <getuint>
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
  8007ed:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
  8007f4:	eb 7e                	jmp    800874 <.L21+0x1f>

008007f6 <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8007fc:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ff:	50                   	push   %eax
  800800:	e8 68 fc ff ff       	call   80046d <getuint>
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80080b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
  80080e:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
  800815:	eb 5d                	jmp    800874 <.L21+0x1f>

00800817 <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	6a 30                	push   $0x30
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	ff d0                	call   *%eax
  800824:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	ff 75 0c             	pushl  0xc(%ebp)
  80082d:	6a 78                	push   $0x78
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	ff d0                	call   *%eax
  800834:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	8d 50 04             	lea    0x4(%eax),%edx
  80083d:	89 55 14             	mov    %edx,0x14(%ebp)
  800840:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
  800842:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800845:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
  80084c:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
  800853:	eb 1f                	jmp    800874 <.L21+0x1f>

00800855 <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 d8             	pushl  -0x28(%ebp)
  80085b:	8d 45 14             	lea    0x14(%ebp),%eax
  80085e:	50                   	push   %eax
  80085f:	e8 09 fc ff ff       	call   80046d <getuint>
  800864:	83 c4 10             	add    $0x10,%esp
  800867:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80086a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
  80086d:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800874:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
  800878:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	52                   	push   %edx
  80087f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800882:	50                   	push   %eax
  800883:	ff 75 e4             	pushl  -0x1c(%ebp)
  800886:	ff 75 e0             	pushl  -0x20(%ebp)
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	ff 75 08             	pushl  0x8(%ebp)
  80088f:	e8 0a fb ff ff       	call   80039e <printnum>
  800894:	83 c4 20             	add    $0x20,%esp
			break;
  800897:	eb 39                	jmp    8008d2 <.L20+0x28>

00800899 <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	53                   	push   %ebx
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	ff d0                	call   *%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
			break;
  8008a8:	eb 28                	jmp    8008d2 <.L20+0x28>

008008aa <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	6a 25                	push   $0x25
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	ff d0                	call   *%eax
  8008b7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ba:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008be:	eb 04                	jmp    8008c4 <.L20+0x1a>
  8008c0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8008c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c7:	83 e8 01             	sub    $0x1,%eax
  8008ca:	0f b6 00             	movzbl (%eax),%eax
  8008cd:	3c 25                	cmp    $0x25,%al
  8008cf:	75 ef                	jne    8008c0 <.L20+0x16>
				/* do nothing */;
			break;
  8008d1:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d2:	e9 79 fc ff ff       	jmp    800550 <vprintfmt+0x31>
				return;
  8008d7:	90                   	nop
		}
	}
}
  8008d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008db:	5b                   	pop    %ebx
  8008dc:	5e                   	pop    %esi
  8008dd:	5f                   	pop    %edi
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008e0:	f3 0f 1e fb          	endbr32 
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	83 ec 18             	sub    $0x18,%esp
  8008ea:	e8 63 f7 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  8008ef:	05 11 17 00 00       	add    $0x1711,%eax
	va_list ap;

	va_start(ap, fmt);
  8008f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008fd:	50                   	push   %eax
  8008fe:	ff 75 10             	pushl  0x10(%ebp)
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	ff 75 08             	pushl  0x8(%ebp)
  800907:	e8 13 fc ff ff       	call   80051f <vprintfmt>
  80090c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090f:	90                   	nop
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800912:	f3 0f 1e fb          	endbr32 
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	e8 34 f7 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  80091e:	05 e2 16 00 00       	add    $0x16e2,%eax
	b->cnt++;
  800923:	8b 45 0c             	mov    0xc(%ebp),%eax
  800926:	8b 40 08             	mov    0x8(%eax),%eax
  800929:	8d 50 01             	lea    0x1(%eax),%edx
  80092c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	8b 10                	mov    (%eax),%edx
  800937:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093a:	8b 40 04             	mov    0x4(%eax),%eax
  80093d:	39 c2                	cmp    %eax,%edx
  80093f:	73 12                	jae    800953 <sprintputch+0x41>
		*b->buf++ = ch;
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	8d 48 01             	lea    0x1(%eax),%ecx
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 0a                	mov    %ecx,(%edx)
  80094e:	8b 55 08             	mov    0x8(%ebp),%edx
  800951:	88 10                	mov    %dl,(%eax)
}
  800953:	90                   	nop
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800956:	f3 0f 1e fb          	endbr32 
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 18             	sub    $0x18,%esp
  800960:	e8 ed f6 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800965:	05 9b 16 00 00       	add    $0x169b,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
  80096a:	8b 55 08             	mov    0x8(%ebp),%edx
  80096d:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800970:	8b 55 0c             	mov    0xc(%ebp),%edx
  800973:	8d 4a ff             	lea    -0x1(%edx),%ecx
  800976:	8b 55 08             	mov    0x8(%ebp),%edx
  800979:	01 ca                	add    %ecx,%edx
  80097b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80097e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800985:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800989:	74 06                	je     800991 <vsnprintf+0x3b>
  80098b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098f:	7f 07                	jg     800998 <vsnprintf+0x42>
		return -E_INVAL;
  800991:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800996:	eb 22                	jmp    8009ba <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800998:	ff 75 14             	pushl  0x14(%ebp)
  80099b:	ff 75 10             	pushl  0x10(%ebp)
  80099e:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8009a1:	52                   	push   %edx
  8009a2:	8d 80 12 e9 ff ff    	lea    -0x16ee(%eax),%eax
  8009a8:	50                   	push   %eax
  8009a9:	e8 71 fb ff ff       	call   80051f <vprintfmt>
  8009ae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009bc:	f3 0f 1e fb          	endbr32 
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	83 ec 18             	sub    $0x18,%esp
  8009c6:	e8 87 f6 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  8009cb:	05 35 16 00 00       	add    $0x1635,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d9:	50                   	push   %eax
  8009da:	ff 75 10             	pushl  0x10(%ebp)
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	ff 75 08             	pushl  0x8(%ebp)
  8009e3:	e8 6e ff ff ff       	call   800956 <vsnprintf>
  8009e8:	83 c4 10             	add    $0x10,%esp
  8009eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
  8009ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009f1:	c9                   	leave  
  8009f2:	c3                   	ret    

008009f3 <__x86.get_pc_thunk.si>:
  8009f3:	8b 34 24             	mov    (%esp),%esi
  8009f6:	c3                   	ret    

008009f7 <__x86.get_pc_thunk.di>:
  8009f7:	8b 3c 24             	mov    (%esp),%edi
  8009fa:	c3                   	ret    

008009fb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009fb:	f3 0f 1e fb          	endbr32 
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 10             	sub    $0x10,%esp
  800a05:	e8 48 f6 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800a0a:	05 f6 15 00 00       	add    $0x15f6,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a16:	eb 08                	jmp    800a20 <strlen+0x25>
		n++;
  800a18:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
  800a1c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	0f b6 00             	movzbl (%eax),%eax
  800a26:	84 c0                	test   %al,%al
  800a28:	75 ee                	jne    800a18 <strlen+0x1d>
	return n;
  800a2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a2f:	f3 0f 1e fb          	endbr32 
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	83 ec 10             	sub    $0x10,%esp
  800a39:	e8 14 f6 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800a3e:	05 c2 15 00 00       	add    $0x15c2,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a4a:	eb 0c                	jmp    800a58 <strnlen+0x29>
		n++;
  800a4c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a50:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800a54:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
  800a58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a5c:	74 0a                	je     800a68 <strnlen+0x39>
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	0f b6 00             	movzbl (%eax),%eax
  800a64:	84 c0                	test   %al,%al
  800a66:	75 e4                	jne    800a4c <strnlen+0x1d>
	return n;
  800a68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a6b:	c9                   	leave  
  800a6c:	c3                   	ret    

00800a6d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a6d:	f3 0f 1e fb          	endbr32 
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	83 ec 10             	sub    $0x10,%esp
  800a77:	e8 d6 f5 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800a7c:	05 84 15 00 00       	add    $0x1584,%eax
	char *ret;

	ret = dst;
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a87:	90                   	nop
  800a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8b:	8d 42 01             	lea    0x1(%edx),%eax
  800a8e:	89 45 0c             	mov    %eax,0xc(%ebp)
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8d 48 01             	lea    0x1(%eax),%ecx
  800a97:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800a9a:	0f b6 12             	movzbl (%edx),%edx
  800a9d:	88 10                	mov    %dl,(%eax)
  800a9f:	0f b6 00             	movzbl (%eax),%eax
  800aa2:	84 c0                	test   %al,%al
  800aa4:	75 e2                	jne    800a88 <strcpy+0x1b>
		/* do nothing */;
	return ret;
  800aa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <strcat>:

char *
strcat(char *dst, const char *src)
{
  800aab:	f3 0f 1e fb          	endbr32 
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	83 ec 10             	sub    $0x10,%esp
  800ab5:	e8 98 f5 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800aba:	05 46 15 00 00       	add    $0x1546,%eax
	int len = strlen(dst);
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 34 ff ff ff       	call   8009fb <strlen>
  800ac7:	83 c4 04             	add    $0x4,%esp
  800aca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
  800acd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	01 d0                	add    %edx,%eax
  800ad5:	ff 75 0c             	pushl  0xc(%ebp)
  800ad8:	50                   	push   %eax
  800ad9:	e8 8f ff ff ff       	call   800a6d <strcpy>
  800ade:	83 c4 08             	add    $0x8,%esp
	return dst;
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ae6:	f3 0f 1e fb          	endbr32 
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	83 ec 10             	sub    $0x10,%esp
  800af0:	e8 5d f5 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800af5:	05 0b 15 00 00       	add    $0x150b,%eax
	size_t i;
	char *ret;

	ret = dst;
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b07:	eb 23                	jmp    800b2c <strncpy+0x46>
		*dst++ = *src;
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8d 50 01             	lea    0x1(%eax),%edx
  800b0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b15:	0f b6 12             	movzbl (%edx),%edx
  800b18:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	0f b6 00             	movzbl (%eax),%eax
  800b20:	84 c0                	test   %al,%al
  800b22:	74 04                	je     800b28 <strncpy+0x42>
			src++;
  800b24:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
  800b28:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800b2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b2f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b32:	72 d5                	jb     800b09 <strncpy+0x23>
	}
	return ret;
  800b34:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    

00800b39 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b39:	f3 0f 1e fb          	endbr32 
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	83 ec 10             	sub    $0x10,%esp
  800b43:	e8 0a f5 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800b48:	05 b8 14 00 00       	add    $0x14b8,%eax
	char *dst_in;

	dst_in = dst;
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b57:	74 33                	je     800b8c <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
  800b59:	eb 17                	jmp    800b72 <strlcpy+0x39>
			*dst++ = *src++;
  800b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5e:	8d 42 01             	lea    0x1(%edx),%eax
  800b61:	89 45 0c             	mov    %eax,0xc(%ebp)
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6a:	89 4d 08             	mov    %ecx,0x8(%ebp)
  800b6d:	0f b6 12             	movzbl (%edx),%edx
  800b70:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
  800b72:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800b76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b7a:	74 0a                	je     800b86 <strlcpy+0x4d>
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	0f b6 00             	movzbl (%eax),%eax
  800b82:	84 c0                	test   %al,%al
  800b84:	75 d5                	jne    800b5b <strlcpy+0x22>
		*dst = '\0';
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
  800b92:	c9                   	leave  
  800b93:	c3                   	ret    

00800b94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b94:	f3 0f 1e fb          	endbr32 
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	e8 b2 f4 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800ba0:	05 60 14 00 00       	add    $0x1460,%eax
	while (*p && *p == *q)
  800ba5:	eb 08                	jmp    800baf <strcmp+0x1b>
		p++, q++;
  800ba7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bab:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	0f b6 00             	movzbl (%eax),%eax
  800bb5:	84 c0                	test   %al,%al
  800bb7:	74 10                	je     800bc9 <strcmp+0x35>
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	0f b6 10             	movzbl (%eax),%edx
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	0f b6 00             	movzbl (%eax),%eax
  800bc5:	38 c2                	cmp    %al,%dl
  800bc7:	74 de                	je     800ba7 <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	0f b6 00             	movzbl (%eax),%eax
  800bcf:	0f b6 d0             	movzbl %al,%edx
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	0f b6 00             	movzbl (%eax),%eax
  800bd8:	0f b6 c0             	movzbl %al,%eax
  800bdb:	29 c2                	sub    %eax,%edx
  800bdd:	89 d0                	mov    %edx,%eax
}
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800be1:	f3 0f 1e fb          	endbr32 
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	e8 65 f4 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800bed:	05 13 14 00 00       	add    $0x1413,%eax
	while (n > 0 && *p && *p == *q)
  800bf2:	eb 0c                	jmp    800c00 <strncmp+0x1f>
		n--, p++, q++;
  800bf4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800bf8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bfc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
  800c00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c04:	74 1a                	je     800c20 <strncmp+0x3f>
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	0f b6 00             	movzbl (%eax),%eax
  800c0c:	84 c0                	test   %al,%al
  800c0e:	74 10                	je     800c20 <strncmp+0x3f>
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	0f b6 10             	movzbl (%eax),%edx
  800c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c19:	0f b6 00             	movzbl (%eax),%eax
  800c1c:	38 c2                	cmp    %al,%dl
  800c1e:	74 d4                	je     800bf4 <strncmp+0x13>
	if (n == 0)
  800c20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c24:	75 07                	jne    800c2d <strncmp+0x4c>
		return 0;
  800c26:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2b:	eb 16                	jmp    800c43 <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	0f b6 00             	movzbl (%eax),%eax
  800c33:	0f b6 d0             	movzbl %al,%edx
  800c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c39:	0f b6 00             	movzbl (%eax),%eax
  800c3c:	0f b6 c0             	movzbl %al,%eax
  800c3f:	29 c2                	sub    %eax,%edx
  800c41:	89 d0                	mov    %edx,%eax
}
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c45:	f3 0f 1e fb          	endbr32 
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 04             	sub    $0x4,%esp
  800c4f:	e8 fe f3 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800c54:	05 ac 13 00 00       	add    $0x13ac,%eax
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c5f:	eb 14                	jmp    800c75 <strchr+0x30>
		if (*s == c)
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	0f b6 00             	movzbl (%eax),%eax
  800c67:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800c6a:	75 05                	jne    800c71 <strchr+0x2c>
			return (char *) s;
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	eb 13                	jmp    800c84 <strchr+0x3f>
	for (; *s; s++)
  800c71:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	0f b6 00             	movzbl (%eax),%eax
  800c7b:	84 c0                	test   %al,%al
  800c7d:	75 e2                	jne    800c61 <strchr+0x1c>
	return 0;
  800c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c86:	f3 0f 1e fb          	endbr32 
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	83 ec 04             	sub    $0x4,%esp
  800c90:	e8 bd f3 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800c95:	05 6b 13 00 00       	add    $0x136b,%eax
  800c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ca0:	eb 0f                	jmp    800cb1 <strfind+0x2b>
		if (*s == c)
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	0f b6 00             	movzbl (%eax),%eax
  800ca8:	38 45 fc             	cmp    %al,-0x4(%ebp)
  800cab:	74 10                	je     800cbd <strfind+0x37>
	for (; *s; s++)
  800cad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	0f b6 00             	movzbl (%eax),%eax
  800cb7:	84 c0                	test   %al,%al
  800cb9:	75 e7                	jne    800ca2 <strfind+0x1c>
  800cbb:	eb 01                	jmp    800cbe <strfind+0x38>
			break;
  800cbd:	90                   	nop
	return (char *) s;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cc3:	f3 0f 1e fb          	endbr32 
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	e8 82 f3 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800cd0:	05 30 13 00 00       	add    $0x1330,%eax
	char *p;

	if (n == 0)
  800cd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd9:	75 05                	jne    800ce0 <memset+0x1d>
		return v;
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	eb 5c                	jmp    800d3c <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	83 e0 03             	and    $0x3,%eax
  800ce6:	85 c0                	test   %eax,%eax
  800ce8:	75 41                	jne    800d2b <memset+0x68>
  800cea:	8b 45 10             	mov    0x10(%ebp),%eax
  800ced:	83 e0 03             	and    $0x3,%eax
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	75 37                	jne    800d2b <memset+0x68>
		c &= 0xFF;
  800cf4:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	c1 e0 18             	shl    $0x18,%eax
  800d01:	89 c2                	mov    %eax,%edx
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	c1 e0 10             	shl    $0x10,%eax
  800d09:	09 c2                	or     %eax,%edx
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	c1 e0 08             	shl    $0x8,%eax
  800d11:	09 d0                	or     %edx,%eax
  800d13:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d16:	8b 45 10             	mov    0x10(%ebp),%eax
  800d19:	c1 e8 02             	shr    $0x2,%eax
  800d1c:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
  800d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d24:	89 d7                	mov    %edx,%edi
  800d26:	fc                   	cld    
  800d27:	f3 ab                	rep stos %eax,%es:(%edi)
  800d29:	eb 0e                	jmp    800d39 <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d34:	89 d7                	mov    %edx,%edi
  800d36:	fc                   	cld    
  800d37:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d3f:	f3 0f 1e fb          	endbr32 
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 10             	sub    $0x10,%esp
  800d4c:	e8 01 f3 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800d51:	05 af 12 00 00       	add    $0x12af,%eax
	const char *s;
	char *d;

	s = src;
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
  800d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d68:	73 6d                	jae    800dd7 <memmove+0x98>
  800d6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d70:	01 d0                	add    %edx,%eax
  800d72:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  800d75:	73 60                	jae    800dd7 <memmove+0x98>
		s += n;
  800d77:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7a:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
  800d7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d80:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d86:	83 e0 03             	and    $0x3,%eax
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	75 2f                	jne    800dbc <memmove+0x7d>
  800d8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d90:	83 e0 03             	and    $0x3,%eax
  800d93:	85 c0                	test   %eax,%eax
  800d95:	75 25                	jne    800dbc <memmove+0x7d>
  800d97:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9a:	83 e0 03             	and    $0x3,%eax
  800d9d:	85 c0                	test   %eax,%eax
  800d9f:	75 1b                	jne    800dbc <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da4:	83 e8 04             	sub    $0x4,%eax
  800da7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800daa:	83 ea 04             	sub    $0x4,%edx
  800dad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800db0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800db3:	89 c7                	mov    %eax,%edi
  800db5:	89 d6                	mov    %edx,%esi
  800db7:	fd                   	std    
  800db8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dba:	eb 18                	jmp    800dd4 <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
  800dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcb:	89 d7                	mov    %edx,%edi
  800dcd:	89 de                	mov    %ebx,%esi
  800dcf:	89 c1                	mov    %eax,%ecx
  800dd1:	fd                   	std    
  800dd2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dd4:	fc                   	cld    
  800dd5:	eb 45                	jmp    800e1c <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dda:	83 e0 03             	and    $0x3,%eax
  800ddd:	85 c0                	test   %eax,%eax
  800ddf:	75 2b                	jne    800e0c <memmove+0xcd>
  800de1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800de4:	83 e0 03             	and    $0x3,%eax
  800de7:	85 c0                	test   %eax,%eax
  800de9:	75 21                	jne    800e0c <memmove+0xcd>
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	83 e0 03             	and    $0x3,%eax
  800df1:	85 c0                	test   %eax,%eax
  800df3:	75 17                	jne    800e0c <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	c1 e8 02             	shr    $0x2,%eax
  800dfb:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
  800dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e03:	89 c7                	mov    %eax,%edi
  800e05:	89 d6                	mov    %edx,%esi
  800e07:	fc                   	cld    
  800e08:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e0a:	eb 10                	jmp    800e1c <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
  800e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e15:	89 c7                	mov    %eax,%edi
  800e17:	89 d6                	mov    %edx,%esi
  800e19:	fc                   	cld    
  800e1a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1f:	83 c4 10             	add    $0x10,%esp
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e27:	f3 0f 1e fb          	endbr32 
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	e8 1f f2 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800e33:	05 cd 11 00 00       	add    $0x11cd,%eax
	return memmove(dst, src, n);
  800e38:	ff 75 10             	pushl  0x10(%ebp)
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	ff 75 08             	pushl  0x8(%ebp)
  800e41:	e8 f9 fe ff ff       	call   800d3f <memmove>
  800e46:	83 c4 0c             	add    $0xc,%esp
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e4b:	f3 0f 1e fb          	endbr32 
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
  800e55:	e8 f8 f1 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800e5a:	05 a6 11 00 00       	add    $0x11a6,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
  800e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e6b:	eb 30                	jmp    800e9d <memcmp+0x52>
		if (*s1 != *s2)
  800e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e70:	0f b6 10             	movzbl (%eax),%edx
  800e73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e76:	0f b6 00             	movzbl (%eax),%eax
  800e79:	38 c2                	cmp    %al,%dl
  800e7b:	74 18                	je     800e95 <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e80:	0f b6 00             	movzbl (%eax),%eax
  800e83:	0f b6 d0             	movzbl %al,%edx
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	0f b6 00             	movzbl (%eax),%eax
  800e8c:	0f b6 c0             	movzbl %al,%eax
  800e8f:	29 c2                	sub    %eax,%edx
  800e91:	89 d0                	mov    %edx,%eax
  800e93:	eb 1a                	jmp    800eaf <memcmp+0x64>
		s1++, s2++;
  800e95:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800e99:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
  800e9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	75 c3                	jne    800e6d <memcmp+0x22>
	}

	return 0;
  800eaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eaf:	c9                   	leave  
  800eb0:	c3                   	ret    

00800eb1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800eb1:	f3 0f 1e fb          	endbr32 
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	83 ec 10             	sub    $0x10,%esp
  800ebb:	e8 92 f1 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800ec0:	05 40 11 00 00       	add    $0x1140,%eax
	const void *ends = (const char *) s + n;
  800ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	01 d0                	add    %edx,%eax
  800ecd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ed0:	eb 11                	jmp    800ee3 <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	0f b6 00             	movzbl (%eax),%eax
  800ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edb:	38 d0                	cmp    %dl,%al
  800edd:	74 0e                	je     800eed <memfind+0x3c>
	for (; s < ends; s++)
  800edf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee9:	72 e7                	jb     800ed2 <memfind+0x21>
  800eeb:	eb 01                	jmp    800eee <memfind+0x3d>
			break;
  800eed:	90                   	nop
	return (void *) s;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef3:	f3 0f 1e fb          	endbr32 
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	83 ec 10             	sub    $0x10,%esp
  800efd:	e8 50 f1 ff ff       	call   800052 <__x86.get_pc_thunk.ax>
  800f02:	05 fe 10 00 00       	add    $0x10fe,%eax
	int neg = 0;
  800f07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f0e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f15:	eb 04                	jmp    800f1b <strtol+0x28>
		s++;
  800f17:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	0f b6 00             	movzbl (%eax),%eax
  800f21:	3c 20                	cmp    $0x20,%al
  800f23:	74 f2                	je     800f17 <strtol+0x24>
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	0f b6 00             	movzbl (%eax),%eax
  800f2b:	3c 09                	cmp    $0x9,%al
  800f2d:	74 e8                	je     800f17 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	0f b6 00             	movzbl (%eax),%eax
  800f35:	3c 2b                	cmp    $0x2b,%al
  800f37:	75 06                	jne    800f3f <strtol+0x4c>
		s++;
  800f39:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f3d:	eb 15                	jmp    800f54 <strtol+0x61>
	else if (*s == '-')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	0f b6 00             	movzbl (%eax),%eax
  800f45:	3c 2d                	cmp    $0x2d,%al
  800f47:	75 0b                	jne    800f54 <strtol+0x61>
		s++, neg = 1;
  800f49:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f4d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f58:	74 06                	je     800f60 <strtol+0x6d>
  800f5a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5e:	75 24                	jne    800f84 <strtol+0x91>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	0f b6 00             	movzbl (%eax),%eax
  800f66:	3c 30                	cmp    $0x30,%al
  800f68:	75 1a                	jne    800f84 <strtol+0x91>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	83 c0 01             	add    $0x1,%eax
  800f70:	0f b6 00             	movzbl (%eax),%eax
  800f73:	3c 78                	cmp    $0x78,%al
  800f75:	75 0d                	jne    800f84 <strtol+0x91>
		s += 2, base = 16;
  800f77:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f7b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f82:	eb 2a                	jmp    800fae <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 17                	jne    800fa1 <strtol+0xae>
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	0f b6 00             	movzbl (%eax),%eax
  800f90:	3c 30                	cmp    $0x30,%al
  800f92:	75 0d                	jne    800fa1 <strtol+0xae>
		s++, base = 8;
  800f94:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800f98:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9f:	eb 0d                	jmp    800fae <strtol+0xbb>
	else if (base == 0)
  800fa1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa5:	75 07                	jne    800fae <strtol+0xbb>
		base = 10;
  800fa7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	0f b6 00             	movzbl (%eax),%eax
  800fb4:	3c 2f                	cmp    $0x2f,%al
  800fb6:	7e 1b                	jle    800fd3 <strtol+0xe0>
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	0f b6 00             	movzbl (%eax),%eax
  800fbe:	3c 39                	cmp    $0x39,%al
  800fc0:	7f 11                	jg     800fd3 <strtol+0xe0>
			dig = *s - '0';
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	0f b6 00             	movzbl (%eax),%eax
  800fc8:	0f be c0             	movsbl %al,%eax
  800fcb:	83 e8 30             	sub    $0x30,%eax
  800fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd1:	eb 48                	jmp    80101b <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	0f b6 00             	movzbl (%eax),%eax
  800fd9:	3c 60                	cmp    $0x60,%al
  800fdb:	7e 1b                	jle    800ff8 <strtol+0x105>
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	0f b6 00             	movzbl (%eax),%eax
  800fe3:	3c 7a                	cmp    $0x7a,%al
  800fe5:	7f 11                	jg     800ff8 <strtol+0x105>
			dig = *s - 'a' + 10;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	0f b6 00             	movzbl (%eax),%eax
  800fed:	0f be c0             	movsbl %al,%eax
  800ff0:	83 e8 57             	sub    $0x57,%eax
  800ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff6:	eb 23                	jmp    80101b <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	0f b6 00             	movzbl (%eax),%eax
  800ffe:	3c 40                	cmp    $0x40,%al
  801000:	7e 3c                	jle    80103e <strtol+0x14b>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	0f b6 00             	movzbl (%eax),%eax
  801008:	3c 5a                	cmp    $0x5a,%al
  80100a:	7f 32                	jg     80103e <strtol+0x14b>
			dig = *s - 'A' + 10;
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	0f b6 00             	movzbl (%eax),%eax
  801012:	0f be c0             	movsbl %al,%eax
  801015:	83 e8 37             	sub    $0x37,%eax
  801018:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801021:	7d 1a                	jge    80103d <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
  801023:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102e:	89 c2                	mov    %eax,%edx
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
  801038:	e9 71 ff ff ff       	jmp    800fae <strtol+0xbb>
			break;
  80103d:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
  80103e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801042:	74 08                	je     80104c <strtol+0x159>
		*endptr = (char *) s;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801050:	74 07                	je     801059 <strtol+0x166>
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801055:	f7 d8                	neg    %eax
  801057:	eb 03                	jmp    80105c <strtol+0x169>
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    
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
