
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 20 19 00       	mov    $0x192000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 f0 11 f0       	mov    $0xf011f000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 02 00 00 00       	call   f0100040 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <i386_init>:
#include <kern/trap.h>


void
i386_init(void)
{
f0100040:	f3 0f 1e fb          	endbr32 
f0100044:	55                   	push   %ebp
f0100045:	89 e5                	mov    %esp,%ebp
f0100047:	53                   	push   %ebx
f0100048:	83 ec 04             	sub    $0x4,%esp
f010004b:	e8 5e 01 00 00       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100050:	81 c3 64 19 09 00    	add    $0x91964,%ebx
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f0100056:	c7 c0 a0 3f 19 f0    	mov    $0xf0193fa0,%eax
f010005c:	89 c2                	mov    %eax,%edx
f010005e:	c7 c0 c0 30 19 f0    	mov    $0xf01930c0,%eax
f0100064:	29 c2                	sub    %eax,%edx
f0100066:	89 d0                	mov    %edx,%eax
f0100068:	83 ec 04             	sub    $0x4,%esp
f010006b:	50                   	push   %eax
f010006c:	6a 00                	push   $0x0
f010006e:	c7 c0 c0 30 19 f0    	mov    $0xf01930c0,%eax
f0100074:	50                   	push   %eax
f0100075:	e8 a6 6b 00 00       	call   f0106c20 <memset>
f010007a:	83 c4 10             	add    $0x10,%esp

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f010007d:	e8 cd 09 00 00       	call   f0100a4f <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f0100082:	83 ec 08             	sub    $0x8,%esp
f0100085:	68 ac 1a 00 00       	push   $0x1aac
f010008a:	8d 83 6c 58 f7 ff    	lea    -0x8a794(%ebx),%eax
f0100090:	50                   	push   %eax
f0100091:	e8 cf 47 00 00       	call   f0104865 <cprintf>
f0100096:	83 c4 10             	add    $0x10,%esp

	// Lab 2 memory management initialization functions
	mem_init();
f0100099:	e8 a4 12 00 00       	call   f0101342 <mem_init>

	// Lab 3 user environment initialization functions
	env_init();
f010009e:	e8 dc 3c 00 00       	call   f0103d7f <env_init>
	trap_init();
f01000a3:	e8 98 48 00 00       	call   f0104940 <trap_init>

#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01000a8:	83 ec 08             	sub    $0x8,%esp
f01000ab:	6a 00                	push   $0x0
f01000ad:	c7 c0 74 a7 13 f0    	mov    $0xf013a774,%eax
f01000b3:	50                   	push   %eax
f01000b4:	e8 27 43 00 00       	call   f01043e0 <env_create>
f01000b9:	83 c4 10             	add    $0x10,%esp
	// Touch all you want.
	ENV_CREATE(user_hello, ENV_TYPE_USER);
#endif // TEST*

	// We only have one user environment for now, so just run it.
	env_run(&envs[0]);
f01000bc:	c7 c0 fc 32 19 f0    	mov    $0xf01932fc,%eax
f01000c2:	8b 00                	mov    (%eax),%eax
f01000c4:	83 ec 0c             	sub    $0xc,%esp
f01000c7:	50                   	push   %eax
f01000c8:	e8 de 45 00 00       	call   f01046ab <env_run>

f01000cd <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f01000cd:	f3 0f 1e fb          	endbr32 
f01000d1:	55                   	push   %ebp
f01000d2:	89 e5                	mov    %esp,%ebp
f01000d4:	53                   	push   %ebx
f01000d5:	83 ec 14             	sub    $0x14,%esp
f01000d8:	e8 d1 00 00 00       	call   f01001ae <__x86.get_pc_thunk.bx>
f01000dd:	81 c3 d7 18 09 00    	add    $0x918d7,%ebx
	va_list ap;

	if (panicstr)
f01000e3:	c7 c0 a4 3f 19 f0    	mov    $0xf0193fa4,%eax
f01000e9:	8b 00                	mov    (%eax),%eax
f01000eb:	85 c0                	test   %eax,%eax
f01000ed:	75 51                	jne    f0100140 <_panic+0x73>
		goto dead;
	panicstr = fmt;
f01000ef:	c7 c0 a4 3f 19 f0    	mov    $0xf0193fa4,%eax
f01000f5:	8b 55 10             	mov    0x10(%ebp),%edx
f01000f8:	89 10                	mov    %edx,(%eax)

	// Be extra sure that the machine is in as reasonable state
	asm volatile("cli; cld");
f01000fa:	fa                   	cli    
f01000fb:	fc                   	cld    

	va_start(ap, fmt);
f01000fc:	8d 45 14             	lea    0x14(%ebp),%eax
f01000ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cprintf("kernel panic at %s:%d: ", file, line);
f0100102:	83 ec 04             	sub    $0x4,%esp
f0100105:	ff 75 0c             	pushl  0xc(%ebp)
f0100108:	ff 75 08             	pushl  0x8(%ebp)
f010010b:	8d 83 87 58 f7 ff    	lea    -0x8a779(%ebx),%eax
f0100111:	50                   	push   %eax
f0100112:	e8 4e 47 00 00       	call   f0104865 <cprintf>
f0100117:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
f010011a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010011d:	83 ec 08             	sub    $0x8,%esp
f0100120:	50                   	push   %eax
f0100121:	ff 75 10             	pushl  0x10(%ebp)
f0100124:	e8 fd 46 00 00       	call   f0104826 <vcprintf>
f0100129:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
f010012c:	83 ec 0c             	sub    $0xc,%esp
f010012f:	8d 83 9f 58 f7 ff    	lea    -0x8a761(%ebx),%eax
f0100135:	50                   	push   %eax
f0100136:	e8 2a 47 00 00       	call   f0104865 <cprintf>
f010013b:	83 c4 10             	add    $0x10,%esp
f010013e:	eb 01                	jmp    f0100141 <_panic+0x74>
		goto dead;
f0100140:	90                   	nop
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100141:	83 ec 0c             	sub    $0xc,%esp
f0100144:	6a 00                	push   $0x0
f0100146:	e8 0e 0e 00 00       	call   f0100f59 <monitor>
f010014b:	83 c4 10             	add    $0x10,%esp
f010014e:	eb f1                	jmp    f0100141 <_panic+0x74>

f0100150 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100150:	f3 0f 1e fb          	endbr32 
f0100154:	55                   	push   %ebp
f0100155:	89 e5                	mov    %esp,%ebp
f0100157:	53                   	push   %ebx
f0100158:	83 ec 14             	sub    $0x14,%esp
f010015b:	e8 4e 00 00 00       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100160:	81 c3 54 18 09 00    	add    $0x91854,%ebx
	va_list ap;

	va_start(ap, fmt);
f0100166:	8d 45 14             	lea    0x14(%ebp),%eax
f0100169:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cprintf("kernel warning at %s:%d: ", file, line);
f010016c:	83 ec 04             	sub    $0x4,%esp
f010016f:	ff 75 0c             	pushl  0xc(%ebp)
f0100172:	ff 75 08             	pushl  0x8(%ebp)
f0100175:	8d 83 a1 58 f7 ff    	lea    -0x8a75f(%ebx),%eax
f010017b:	50                   	push   %eax
f010017c:	e8 e4 46 00 00       	call   f0104865 <cprintf>
f0100181:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
f0100184:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100187:	83 ec 08             	sub    $0x8,%esp
f010018a:	50                   	push   %eax
f010018b:	ff 75 10             	pushl  0x10(%ebp)
f010018e:	e8 93 46 00 00       	call   f0104826 <vcprintf>
f0100193:	83 c4 10             	add    $0x10,%esp
	cprintf("\n");
f0100196:	83 ec 0c             	sub    $0xc,%esp
f0100199:	8d 83 9f 58 f7 ff    	lea    -0x8a761(%ebx),%eax
f010019f:	50                   	push   %eax
f01001a0:	e8 c0 46 00 00       	call   f0104865 <cprintf>
f01001a5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
f01001a8:	90                   	nop
f01001a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01001ac:	c9                   	leave  
f01001ad:	c3                   	ret    

f01001ae <__x86.get_pc_thunk.bx>:
f01001ae:	8b 1c 24             	mov    (%esp),%ebx
f01001b1:	c3                   	ret    

f01001b2 <inb>:
	asm volatile("int3");
}

static inline uint8_t
inb(int port)
{
f01001b2:	55                   	push   %ebp
f01001b3:	89 e5                	mov    %esp,%ebp
f01001b5:	83 ec 10             	sub    $0x10,%esp
f01001b8:	e8 42 09 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f01001bd:	05 f7 17 09 00       	add    $0x917f7,%eax
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01001c2:	8b 45 08             	mov    0x8(%ebp),%eax
f01001c5:	89 c2                	mov    %eax,%edx
f01001c7:	ec                   	in     (%dx),%al
f01001c8:	88 45 ff             	mov    %al,-0x1(%ebp)
	return data;
f01001cb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
f01001cf:	c9                   	leave  
f01001d0:	c3                   	ret    

f01001d1 <outb>:
		     : "memory", "cc");
}

static inline void
outb(int port, uint8_t data)
{
f01001d1:	55                   	push   %ebp
f01001d2:	89 e5                	mov    %esp,%ebp
f01001d4:	83 ec 04             	sub    $0x4,%esp
f01001d7:	e8 23 09 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f01001dc:	05 d8 17 09 00       	add    $0x917d8,%eax
f01001e1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01001e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01001e7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
f01001eb:	8b 55 08             	mov    0x8(%ebp),%edx
f01001ee:	ee                   	out    %al,(%dx)
}
f01001ef:	90                   	nop
f01001f0:	c9                   	leave  
f01001f1:	c3                   	ret    

f01001f2 <delay>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f01001f2:	f3 0f 1e fb          	endbr32 
f01001f6:	55                   	push   %ebp
f01001f7:	89 e5                	mov    %esp,%ebp
f01001f9:	e8 01 09 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f01001fe:	05 b6 17 09 00       	add    $0x917b6,%eax
	inb(0x84);
f0100203:	68 84 00 00 00       	push   $0x84
f0100208:	e8 a5 ff ff ff       	call   f01001b2 <inb>
f010020d:	83 c4 04             	add    $0x4,%esp
	inb(0x84);
f0100210:	68 84 00 00 00       	push   $0x84
f0100215:	e8 98 ff ff ff       	call   f01001b2 <inb>
f010021a:	83 c4 04             	add    $0x4,%esp
	inb(0x84);
f010021d:	68 84 00 00 00       	push   $0x84
f0100222:	e8 8b ff ff ff       	call   f01001b2 <inb>
f0100227:	83 c4 04             	add    $0x4,%esp
	inb(0x84);
f010022a:	68 84 00 00 00       	push   $0x84
f010022f:	e8 7e ff ff ff       	call   f01001b2 <inb>
f0100234:	83 c4 04             	add    $0x4,%esp
}
f0100237:	90                   	nop
f0100238:	c9                   	leave  
f0100239:	c3                   	ret    

f010023a <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f010023a:	f3 0f 1e fb          	endbr32 
f010023e:	55                   	push   %ebp
f010023f:	89 e5                	mov    %esp,%ebp
f0100241:	e8 b9 08 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f0100246:	05 6e 17 09 00       	add    $0x9176e,%eax
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f010024b:	68 fd 03 00 00       	push   $0x3fd
f0100250:	e8 5d ff ff ff       	call   f01001b2 <inb>
f0100255:	83 c4 04             	add    $0x4,%esp
f0100258:	0f b6 c0             	movzbl %al,%eax
f010025b:	83 e0 01             	and    $0x1,%eax
f010025e:	85 c0                	test   %eax,%eax
f0100260:	75 07                	jne    f0100269 <serial_proc_data+0x2f>
		return -1;
f0100262:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100267:	eb 10                	jmp    f0100279 <serial_proc_data+0x3f>
	return inb(COM1+COM_RX);
f0100269:	68 f8 03 00 00       	push   $0x3f8
f010026e:	e8 3f ff ff ff       	call   f01001b2 <inb>
f0100273:	83 c4 04             	add    $0x4,%esp
f0100276:	0f b6 c0             	movzbl %al,%eax
}
f0100279:	c9                   	leave  
f010027a:	c3                   	ret    

f010027b <serial_intr>:

void
serial_intr(void)
{
f010027b:	f3 0f 1e fb          	endbr32 
f010027f:	55                   	push   %ebp
f0100280:	89 e5                	mov    %esp,%ebp
f0100282:	83 ec 08             	sub    $0x8,%esp
f0100285:	e8 75 08 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f010028a:	05 2a 17 09 00       	add    $0x9172a,%eax
	if (serial_exists)
f010028f:	0f b6 90 0c 17 00 00 	movzbl 0x170c(%eax),%edx
f0100296:	84 d2                	test   %dl,%dl
f0100298:	74 12                	je     f01002ac <serial_intr+0x31>
		cons_intr(serial_proc_data);
f010029a:	83 ec 0c             	sub    $0xc,%esp
f010029d:	8d 80 86 e8 f6 ff    	lea    -0x9177a(%eax),%eax
f01002a3:	50                   	push   %eax
f01002a4:	e8 91 06 00 00       	call   f010093a <cons_intr>
f01002a9:	83 c4 10             	add    $0x10,%esp
}
f01002ac:	90                   	nop
f01002ad:	c9                   	leave  
f01002ae:	c3                   	ret    

f01002af <serial_putc>:

static void
serial_putc(int c)
{
f01002af:	f3 0f 1e fb          	endbr32 
f01002b3:	55                   	push   %ebp
f01002b4:	89 e5                	mov    %esp,%ebp
f01002b6:	83 ec 10             	sub    $0x10,%esp
f01002b9:	e8 41 08 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f01002be:	05 f6 16 09 00       	add    $0x916f6,%eax
	int i;

	for (i = 0;
f01002c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
f01002ca:	eb 09                	jmp    f01002d5 <serial_putc+0x26>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
f01002cc:	e8 21 ff ff ff       	call   f01001f2 <delay>
	     i++)
f01002d1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01002d5:	68 fd 03 00 00       	push   $0x3fd
f01002da:	e8 d3 fe ff ff       	call   f01001b2 <inb>
f01002df:	83 c4 04             	add    $0x4,%esp
f01002e2:	0f b6 c0             	movzbl %al,%eax
f01002e5:	83 e0 20             	and    $0x20,%eax
	for (i = 0;
f01002e8:	85 c0                	test   %eax,%eax
f01002ea:	75 09                	jne    f01002f5 <serial_putc+0x46>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01002ec:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
f01002f3:	7e d7                	jle    f01002cc <serial_putc+0x1d>

	outb(COM1 + COM_TX, c);
f01002f5:	8b 45 08             	mov    0x8(%ebp),%eax
f01002f8:	0f b6 c0             	movzbl %al,%eax
f01002fb:	50                   	push   %eax
f01002fc:	68 f8 03 00 00       	push   $0x3f8
f0100301:	e8 cb fe ff ff       	call   f01001d1 <outb>
f0100306:	83 c4 08             	add    $0x8,%esp
}
f0100309:	90                   	nop
f010030a:	c9                   	leave  
f010030b:	c3                   	ret    

f010030c <serial_init>:

static void
serial_init(void)
{
f010030c:	f3 0f 1e fb          	endbr32 
f0100310:	55                   	push   %ebp
f0100311:	89 e5                	mov    %esp,%ebp
f0100313:	53                   	push   %ebx
f0100314:	e8 95 fe ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100319:	81 c3 9b 16 09 00    	add    $0x9169b,%ebx
	// Turn off the FIFO
	outb(COM1+COM_FCR, 0);
f010031f:	6a 00                	push   $0x0
f0100321:	68 fa 03 00 00       	push   $0x3fa
f0100326:	e8 a6 fe ff ff       	call   f01001d1 <outb>
f010032b:	83 c4 08             	add    $0x8,%esp

	// Set speed; requires DLAB latch
	outb(COM1+COM_LCR, COM_LCR_DLAB);
f010032e:	68 80 00 00 00       	push   $0x80
f0100333:	68 fb 03 00 00       	push   $0x3fb
f0100338:	e8 94 fe ff ff       	call   f01001d1 <outb>
f010033d:	83 c4 08             	add    $0x8,%esp
	outb(COM1+COM_DLL, (uint8_t) (115200 / 9600));
f0100340:	6a 0c                	push   $0xc
f0100342:	68 f8 03 00 00       	push   $0x3f8
f0100347:	e8 85 fe ff ff       	call   f01001d1 <outb>
f010034c:	83 c4 08             	add    $0x8,%esp
	outb(COM1+COM_DLM, 0);
f010034f:	6a 00                	push   $0x0
f0100351:	68 f9 03 00 00       	push   $0x3f9
f0100356:	e8 76 fe ff ff       	call   f01001d1 <outb>
f010035b:	83 c4 08             	add    $0x8,%esp

	// 8 data bits, 1 stop bit, parity off; turn off DLAB latch
	outb(COM1+COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);
f010035e:	6a 03                	push   $0x3
f0100360:	68 fb 03 00 00       	push   $0x3fb
f0100365:	e8 67 fe ff ff       	call   f01001d1 <outb>
f010036a:	83 c4 08             	add    $0x8,%esp

	// No modem controls
	outb(COM1+COM_MCR, 0);
f010036d:	6a 00                	push   $0x0
f010036f:	68 fc 03 00 00       	push   $0x3fc
f0100374:	e8 58 fe ff ff       	call   f01001d1 <outb>
f0100379:	83 c4 08             	add    $0x8,%esp
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);
f010037c:	6a 01                	push   $0x1
f010037e:	68 f9 03 00 00       	push   $0x3f9
f0100383:	e8 49 fe ff ff       	call   f01001d1 <outb>
f0100388:	83 c4 08             	add    $0x8,%esp

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f010038b:	68 fd 03 00 00       	push   $0x3fd
f0100390:	e8 1d fe ff ff       	call   f01001b2 <inb>
f0100395:	83 c4 04             	add    $0x4,%esp
f0100398:	3c ff                	cmp    $0xff,%al
f010039a:	0f 95 c0             	setne  %al
f010039d:	88 83 0c 17 00 00    	mov    %al,0x170c(%ebx)
	(void) inb(COM1+COM_IIR);
f01003a3:	68 fa 03 00 00       	push   $0x3fa
f01003a8:	e8 05 fe ff ff       	call   f01001b2 <inb>
f01003ad:	83 c4 04             	add    $0x4,%esp
	(void) inb(COM1+COM_RX);
f01003b0:	68 f8 03 00 00       	push   $0x3f8
f01003b5:	e8 f8 fd ff ff       	call   f01001b2 <inb>
f01003ba:	83 c4 04             	add    $0x4,%esp

}
f01003bd:	90                   	nop
f01003be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01003c1:	c9                   	leave  
f01003c2:	c3                   	ret    

f01003c3 <lpt_putc>:
// For information on PC parallel port programming, see the class References
// page.

static void
lpt_putc(int c)
{
f01003c3:	f3 0f 1e fb          	endbr32 
f01003c7:	55                   	push   %ebp
f01003c8:	89 e5                	mov    %esp,%ebp
f01003ca:	83 ec 10             	sub    $0x10,%esp
f01003cd:	e8 2d 07 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f01003d2:	05 e2 15 09 00       	add    $0x915e2,%eax
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01003d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
f01003de:	eb 09                	jmp    f01003e9 <lpt_putc+0x26>
		delay();
f01003e0:	e8 0d fe ff ff       	call   f01001f2 <delay>
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01003e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
f01003e9:	68 79 03 00 00       	push   $0x379
f01003ee:	e8 bf fd ff ff       	call   f01001b2 <inb>
f01003f3:	83 c4 04             	add    $0x4,%esp
f01003f6:	84 c0                	test   %al,%al
f01003f8:	78 09                	js     f0100403 <lpt_putc+0x40>
f01003fa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
f0100401:	7e dd                	jle    f01003e0 <lpt_putc+0x1d>
	outb(0x378+0, c);
f0100403:	8b 45 08             	mov    0x8(%ebp),%eax
f0100406:	0f b6 c0             	movzbl %al,%eax
f0100409:	50                   	push   %eax
f010040a:	68 78 03 00 00       	push   $0x378
f010040f:	e8 bd fd ff ff       	call   f01001d1 <outb>
f0100414:	83 c4 08             	add    $0x8,%esp
	outb(0x378+2, 0x08|0x04|0x01);
f0100417:	6a 0d                	push   $0xd
f0100419:	68 7a 03 00 00       	push   $0x37a
f010041e:	e8 ae fd ff ff       	call   f01001d1 <outb>
f0100423:	83 c4 08             	add    $0x8,%esp
	outb(0x378+2, 0x08);
f0100426:	6a 08                	push   $0x8
f0100428:	68 7a 03 00 00       	push   $0x37a
f010042d:	e8 9f fd ff ff       	call   f01001d1 <outb>
f0100432:	83 c4 08             	add    $0x8,%esp
}
f0100435:	90                   	nop
f0100436:	c9                   	leave  
f0100437:	c3                   	ret    

f0100438 <cga_init>:
static uint16_t *crt_buf;
static uint16_t crt_pos;

static void
cga_init(void)
{
f0100438:	f3 0f 1e fb          	endbr32 
f010043c:	55                   	push   %ebp
f010043d:	89 e5                	mov    %esp,%ebp
f010043f:	53                   	push   %ebx
f0100440:	83 ec 10             	sub    $0x10,%esp
f0100443:	e8 66 fd ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100448:	81 c3 6c 15 09 00    	add    $0x9156c,%ebx
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f010044e:	c7 45 f8 00 80 0b f0 	movl   $0xf00b8000,-0x8(%ebp)
	was = *cp;
f0100455:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0100458:	0f b7 00             	movzwl (%eax),%eax
f010045b:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
	*cp = (uint16_t) 0xA55A;
f010045f:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0100462:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
	if (*cp != 0xA55A) {
f0100467:	8b 45 f8             	mov    -0x8(%ebp),%eax
f010046a:	0f b7 00             	movzwl (%eax),%eax
f010046d:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100471:	74 13                	je     f0100486 <cga_init+0x4e>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f0100473:	c7 45 f8 00 00 0b f0 	movl   $0xf00b0000,-0x8(%ebp)
		addr_6845 = MONO_BASE;
f010047a:	c7 83 10 17 00 00 b4 	movl   $0x3b4,0x1710(%ebx)
f0100481:	03 00 00 
f0100484:	eb 14                	jmp    f010049a <cga_init+0x62>
	} else {
		*cp = was;
f0100486:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0100489:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
f010048d:	66 89 10             	mov    %dx,(%eax)
		addr_6845 = CGA_BASE;
f0100490:	c7 83 10 17 00 00 d4 	movl   $0x3d4,0x1710(%ebx)
f0100497:	03 00 00 
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f010049a:	8b 83 10 17 00 00    	mov    0x1710(%ebx),%eax
f01004a0:	6a 0e                	push   $0xe
f01004a2:	50                   	push   %eax
f01004a3:	e8 29 fd ff ff       	call   f01001d1 <outb>
f01004a8:	83 c4 08             	add    $0x8,%esp
	pos = inb(addr_6845 + 1) << 8;
f01004ab:	8b 83 10 17 00 00    	mov    0x1710(%ebx),%eax
f01004b1:	83 c0 01             	add    $0x1,%eax
f01004b4:	50                   	push   %eax
f01004b5:	e8 f8 fc ff ff       	call   f01001b2 <inb>
f01004ba:	83 c4 04             	add    $0x4,%esp
f01004bd:	0f b6 c0             	movzbl %al,%eax
f01004c0:	c1 e0 08             	shl    $0x8,%eax
f01004c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	outb(addr_6845, 15);
f01004c6:	8b 83 10 17 00 00    	mov    0x1710(%ebx),%eax
f01004cc:	6a 0f                	push   $0xf
f01004ce:	50                   	push   %eax
f01004cf:	e8 fd fc ff ff       	call   f01001d1 <outb>
f01004d4:	83 c4 08             	add    $0x8,%esp
	pos |= inb(addr_6845 + 1);
f01004d7:	8b 83 10 17 00 00    	mov    0x1710(%ebx),%eax
f01004dd:	83 c0 01             	add    $0x1,%eax
f01004e0:	50                   	push   %eax
f01004e1:	e8 cc fc ff ff       	call   f01001b2 <inb>
f01004e6:	83 c4 04             	add    $0x4,%esp
f01004e9:	0f b6 c0             	movzbl %al,%eax
f01004ec:	09 45 f0             	or     %eax,-0x10(%ebp)

	crt_buf = (uint16_t*) cp;
f01004ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
f01004f2:	89 83 14 17 00 00    	mov    %eax,0x1714(%ebx)
	crt_pos = pos;
f01004f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01004fb:	66 89 83 18 17 00 00 	mov    %ax,0x1718(%ebx)
}
f0100502:	90                   	nop
f0100503:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100506:	c9                   	leave  
f0100507:	c3                   	ret    

f0100508 <cga_putc>:



static void
cga_putc(int c)
{
f0100508:	f3 0f 1e fb          	endbr32 
f010050c:	55                   	push   %ebp
f010050d:	89 e5                	mov    %esp,%ebp
f010050f:	56                   	push   %esi
f0100510:	53                   	push   %ebx
f0100511:	83 ec 10             	sub    $0x10,%esp
f0100514:	e8 95 fc ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100519:	81 c3 9b 14 09 00    	add    $0x9149b,%ebx
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f010051f:	8b 45 08             	mov    0x8(%ebp),%eax
f0100522:	b0 00                	mov    $0x0,%al
f0100524:	85 c0                	test   %eax,%eax
f0100526:	75 07                	jne    f010052f <cga_putc+0x27>
		c |= 0x0700;
f0100528:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)

	switch (c & 0xff) {
f010052f:	8b 45 08             	mov    0x8(%ebp),%eax
f0100532:	0f b6 c0             	movzbl %al,%eax
f0100535:	83 f8 0d             	cmp    $0xd,%eax
f0100538:	0f 84 84 00 00 00    	je     f01005c2 <cga_putc+0xba>
f010053e:	83 f8 0d             	cmp    $0xd,%eax
f0100541:	0f 8f f9 00 00 00    	jg     f0100640 <cga_putc+0x138>
f0100547:	83 f8 0a             	cmp    $0xa,%eax
f010054a:	74 65                	je     f01005b1 <cga_putc+0xa9>
f010054c:	83 f8 0a             	cmp    $0xa,%eax
f010054f:	0f 8f eb 00 00 00    	jg     f0100640 <cga_putc+0x138>
f0100555:	83 f8 08             	cmp    $0x8,%eax
f0100558:	74 0e                	je     f0100568 <cga_putc+0x60>
f010055a:	83 f8 09             	cmp    $0x9,%eax
f010055d:	0f 84 9a 00 00 00    	je     f01005fd <cga_putc+0xf5>
f0100563:	e9 d8 00 00 00       	jmp    f0100640 <cga_putc+0x138>
	case '\b':
		if (crt_pos > 0) {
f0100568:	0f b7 83 18 17 00 00 	movzwl 0x1718(%ebx),%eax
f010056f:	66 85 c0             	test   %ax,%ax
f0100572:	0f 84 ee 00 00 00    	je     f0100666 <cga_putc+0x15e>
			crt_pos--;
f0100578:	0f b7 83 18 17 00 00 	movzwl 0x1718(%ebx),%eax
f010057f:	83 e8 01             	sub    $0x1,%eax
f0100582:	66 89 83 18 17 00 00 	mov    %ax,0x1718(%ebx)
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100589:	8b 45 08             	mov    0x8(%ebp),%eax
f010058c:	b0 00                	mov    $0x0,%al
f010058e:	83 c8 20             	or     $0x20,%eax
f0100591:	89 c1                	mov    %eax,%ecx
f0100593:	8b 83 14 17 00 00    	mov    0x1714(%ebx),%eax
f0100599:	0f b7 93 18 17 00 00 	movzwl 0x1718(%ebx),%edx
f01005a0:	0f b7 d2             	movzwl %dx,%edx
f01005a3:	01 d2                	add    %edx,%edx
f01005a5:	01 d0                	add    %edx,%eax
f01005a7:	89 ca                	mov    %ecx,%edx
f01005a9:	66 89 10             	mov    %dx,(%eax)
		}
		break;
f01005ac:	e9 b5 00 00 00       	jmp    f0100666 <cga_putc+0x15e>
	case '\n':
		crt_pos += CRT_COLS;
f01005b1:	0f b7 83 18 17 00 00 	movzwl 0x1718(%ebx),%eax
f01005b8:	83 c0 50             	add    $0x50,%eax
f01005bb:	66 89 83 18 17 00 00 	mov    %ax,0x1718(%ebx)
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f01005c2:	0f b7 b3 18 17 00 00 	movzwl 0x1718(%ebx),%esi
f01005c9:	0f b7 8b 18 17 00 00 	movzwl 0x1718(%ebx),%ecx
f01005d0:	0f b7 c1             	movzwl %cx,%eax
f01005d3:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01005d9:	c1 e8 10             	shr    $0x10,%eax
f01005dc:	89 c2                	mov    %eax,%edx
f01005de:	66 c1 ea 06          	shr    $0x6,%dx
f01005e2:	89 d0                	mov    %edx,%eax
f01005e4:	c1 e0 02             	shl    $0x2,%eax
f01005e7:	01 d0                	add    %edx,%eax
f01005e9:	c1 e0 04             	shl    $0x4,%eax
f01005ec:	29 c1                	sub    %eax,%ecx
f01005ee:	89 ca                	mov    %ecx,%edx
f01005f0:	89 f0                	mov    %esi,%eax
f01005f2:	29 d0                	sub    %edx,%eax
f01005f4:	66 89 83 18 17 00 00 	mov    %ax,0x1718(%ebx)
		break;
f01005fb:	eb 6a                	jmp    f0100667 <cga_putc+0x15f>
	case '\t':
		cons_putc(' ');
f01005fd:	83 ec 0c             	sub    $0xc,%esp
f0100600:	6a 20                	push   $0x20
f0100602:	e8 0d 04 00 00       	call   f0100a14 <cons_putc>
f0100607:	83 c4 10             	add    $0x10,%esp
		cons_putc(' ');
f010060a:	83 ec 0c             	sub    $0xc,%esp
f010060d:	6a 20                	push   $0x20
f010060f:	e8 00 04 00 00       	call   f0100a14 <cons_putc>
f0100614:	83 c4 10             	add    $0x10,%esp
		cons_putc(' ');
f0100617:	83 ec 0c             	sub    $0xc,%esp
f010061a:	6a 20                	push   $0x20
f010061c:	e8 f3 03 00 00       	call   f0100a14 <cons_putc>
f0100621:	83 c4 10             	add    $0x10,%esp
		cons_putc(' ');
f0100624:	83 ec 0c             	sub    $0xc,%esp
f0100627:	6a 20                	push   $0x20
f0100629:	e8 e6 03 00 00       	call   f0100a14 <cons_putc>
f010062e:	83 c4 10             	add    $0x10,%esp
		cons_putc(' ');
f0100631:	83 ec 0c             	sub    $0xc,%esp
f0100634:	6a 20                	push   $0x20
f0100636:	e8 d9 03 00 00       	call   f0100a14 <cons_putc>
f010063b:	83 c4 10             	add    $0x10,%esp
		break;
f010063e:	eb 27                	jmp    f0100667 <cga_putc+0x15f>
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f0100640:	8b 8b 14 17 00 00    	mov    0x1714(%ebx),%ecx
f0100646:	0f b7 83 18 17 00 00 	movzwl 0x1718(%ebx),%eax
f010064d:	8d 50 01             	lea    0x1(%eax),%edx
f0100650:	66 89 93 18 17 00 00 	mov    %dx,0x1718(%ebx)
f0100657:	0f b7 c0             	movzwl %ax,%eax
f010065a:	01 c0                	add    %eax,%eax
f010065c:	01 c8                	add    %ecx,%eax
f010065e:	8b 55 08             	mov    0x8(%ebp),%edx
f0100661:	66 89 10             	mov    %dx,(%eax)
		break;
f0100664:	eb 01                	jmp    f0100667 <cga_putc+0x15f>
		break;
f0100666:	90                   	nop
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f0100667:	0f b7 83 18 17 00 00 	movzwl 0x1718(%ebx),%eax
f010066e:	66 3d cf 07          	cmp    $0x7cf,%ax
f0100672:	76 5d                	jbe    f01006d1 <cga_putc+0x1c9>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100674:	8b 83 14 17 00 00    	mov    0x1714(%ebx),%eax
f010067a:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100680:	8b 83 14 17 00 00    	mov    0x1714(%ebx),%eax
f0100686:	83 ec 04             	sub    $0x4,%esp
f0100689:	68 00 0f 00 00       	push   $0xf00
f010068e:	52                   	push   %edx
f010068f:	50                   	push   %eax
f0100690:	e8 07 66 00 00       	call   f0106c9c <memmove>
f0100695:	83 c4 10             	add    $0x10,%esp
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100698:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
f010069f:	eb 16                	jmp    f01006b7 <cga_putc+0x1af>
			crt_buf[i] = 0x0700 | ' ';
f01006a1:	8b 83 14 17 00 00    	mov    0x1714(%ebx),%eax
f01006a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01006aa:	01 d2                	add    %edx,%edx
f01006ac:	01 d0                	add    %edx,%eax
f01006ae:	66 c7 00 20 07       	movw   $0x720,(%eax)
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01006b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f01006b7:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
f01006be:	7e e1                	jle    f01006a1 <cga_putc+0x199>
		crt_pos -= CRT_COLS;
f01006c0:	0f b7 83 18 17 00 00 	movzwl 0x1718(%ebx),%eax
f01006c7:	83 e8 50             	sub    $0x50,%eax
f01006ca:	66 89 83 18 17 00 00 	mov    %ax,0x1718(%ebx)
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f01006d1:	8b 83 10 17 00 00    	mov    0x1710(%ebx),%eax
f01006d7:	83 ec 08             	sub    $0x8,%esp
f01006da:	6a 0e                	push   $0xe
f01006dc:	50                   	push   %eax
f01006dd:	e8 ef fa ff ff       	call   f01001d1 <outb>
f01006e2:	83 c4 10             	add    $0x10,%esp
	outb(addr_6845 + 1, crt_pos >> 8);
f01006e5:	0f b7 83 18 17 00 00 	movzwl 0x1718(%ebx),%eax
f01006ec:	66 c1 e8 08          	shr    $0x8,%ax
f01006f0:	0f b6 c0             	movzbl %al,%eax
f01006f3:	8b 93 10 17 00 00    	mov    0x1710(%ebx),%edx
f01006f9:	83 c2 01             	add    $0x1,%edx
f01006fc:	83 ec 08             	sub    $0x8,%esp
f01006ff:	50                   	push   %eax
f0100700:	52                   	push   %edx
f0100701:	e8 cb fa ff ff       	call   f01001d1 <outb>
f0100706:	83 c4 10             	add    $0x10,%esp
	outb(addr_6845, 15);
f0100709:	8b 83 10 17 00 00    	mov    0x1710(%ebx),%eax
f010070f:	83 ec 08             	sub    $0x8,%esp
f0100712:	6a 0f                	push   $0xf
f0100714:	50                   	push   %eax
f0100715:	e8 b7 fa ff ff       	call   f01001d1 <outb>
f010071a:	83 c4 10             	add    $0x10,%esp
	outb(addr_6845 + 1, crt_pos);
f010071d:	0f b7 83 18 17 00 00 	movzwl 0x1718(%ebx),%eax
f0100724:	0f b6 c0             	movzbl %al,%eax
f0100727:	8b 93 10 17 00 00    	mov    0x1710(%ebx),%edx
f010072d:	83 c2 01             	add    $0x1,%edx
f0100730:	83 ec 08             	sub    $0x8,%esp
f0100733:	50                   	push   %eax
f0100734:	52                   	push   %edx
f0100735:	e8 97 fa ff ff       	call   f01001d1 <outb>
f010073a:	83 c4 10             	add    $0x10,%esp
}
f010073d:	90                   	nop
f010073e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100741:	5b                   	pop    %ebx
f0100742:	5e                   	pop    %esi
f0100743:	5d                   	pop    %ebp
f0100744:	c3                   	ret    

f0100745 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f0100745:	f3 0f 1e fb          	endbr32 
f0100749:	55                   	push   %ebp
f010074a:	89 e5                	mov    %esp,%ebp
f010074c:	53                   	push   %ebx
f010074d:	83 ec 14             	sub    $0x14,%esp
f0100750:	e8 59 fa ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100755:	81 c3 5f 12 09 00    	add    $0x9125f,%ebx
	int c;
	uint8_t stat, data;
	static uint32_t shift;

	stat = inb(KBSTATP);
f010075b:	6a 64                	push   $0x64
f010075d:	e8 50 fa ff ff       	call   f01001b2 <inb>
f0100762:	83 c4 04             	add    $0x4,%esp
f0100765:	88 45 f2             	mov    %al,-0xe(%ebp)
	if ((stat & KBS_DIB) == 0)
f0100768:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
f010076c:	83 e0 01             	and    $0x1,%eax
f010076f:	85 c0                	test   %eax,%eax
f0100771:	75 0a                	jne    f010077d <kbd_proc_data+0x38>
		return -1;
f0100773:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100778:	e9 7b 01 00 00       	jmp    f01008f8 <kbd_proc_data+0x1b3>
	// Ignore data from mouse.
	if (stat & KBS_TERR)
f010077d:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
f0100781:	83 e0 20             	and    $0x20,%eax
f0100784:	85 c0                	test   %eax,%eax
f0100786:	74 0a                	je     f0100792 <kbd_proc_data+0x4d>
		return -1;
f0100788:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010078d:	e9 66 01 00 00       	jmp    f01008f8 <kbd_proc_data+0x1b3>

	data = inb(KBDATAP);
f0100792:	6a 60                	push   $0x60
f0100794:	e8 19 fa ff ff       	call   f01001b2 <inb>
f0100799:	83 c4 04             	add    $0x4,%esp
f010079c:	88 45 f3             	mov    %al,-0xd(%ebp)

	if (data == 0xE0) {
f010079f:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
f01007a3:	75 19                	jne    f01007be <kbd_proc_data+0x79>
		// E0 escape character
		shift |= E0ESC;
f01007a5:	8b 83 34 19 00 00    	mov    0x1934(%ebx),%eax
f01007ab:	83 c8 40             	or     $0x40,%eax
f01007ae:	89 83 34 19 00 00    	mov    %eax,0x1934(%ebx)
		return 0;
f01007b4:	b8 00 00 00 00       	mov    $0x0,%eax
f01007b9:	e9 3a 01 00 00       	jmp    f01008f8 <kbd_proc_data+0x1b3>
	} else if (data & 0x80) {
f01007be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f01007c2:	84 c0                	test   %al,%al
f01007c4:	79 4b                	jns    f0100811 <kbd_proc_data+0xcc>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f01007c6:	8b 83 34 19 00 00    	mov    0x1934(%ebx),%eax
f01007cc:	83 e0 40             	and    $0x40,%eax
f01007cf:	85 c0                	test   %eax,%eax
f01007d1:	75 09                	jne    f01007dc <kbd_proc_data+0x97>
f01007d3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f01007d7:	83 e0 7f             	and    $0x7f,%eax
f01007da:	eb 04                	jmp    f01007e0 <kbd_proc_data+0x9b>
f01007dc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f01007e0:	88 45 f3             	mov    %al,-0xd(%ebp)
		shift &= ~(shiftcode[data] | E0ESC);
f01007e3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f01007e7:	0f b6 84 03 4c e6 f8 	movzbl -0x719b4(%ebx,%eax,1),%eax
f01007ee:	ff 
f01007ef:	83 c8 40             	or     $0x40,%eax
f01007f2:	0f b6 c0             	movzbl %al,%eax
f01007f5:	f7 d0                	not    %eax
f01007f7:	89 c2                	mov    %eax,%edx
f01007f9:	8b 83 34 19 00 00    	mov    0x1934(%ebx),%eax
f01007ff:	21 d0                	and    %edx,%eax
f0100801:	89 83 34 19 00 00    	mov    %eax,0x1934(%ebx)
		return 0;
f0100807:	b8 00 00 00 00       	mov    $0x0,%eax
f010080c:	e9 e7 00 00 00       	jmp    f01008f8 <kbd_proc_data+0x1b3>
	} else if (shift & E0ESC) {
f0100811:	8b 83 34 19 00 00    	mov    0x1934(%ebx),%eax
f0100817:	83 e0 40             	and    $0x40,%eax
f010081a:	85 c0                	test   %eax,%eax
f010081c:	74 13                	je     f0100831 <kbd_proc_data+0xec>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f010081e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
		shift &= ~E0ESC;
f0100822:	8b 83 34 19 00 00    	mov    0x1934(%ebx),%eax
f0100828:	83 e0 bf             	and    $0xffffffbf,%eax
f010082b:	89 83 34 19 00 00    	mov    %eax,0x1934(%ebx)
	}

	shift |= shiftcode[data];
f0100831:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f0100835:	0f b6 84 03 4c e6 f8 	movzbl -0x719b4(%ebx,%eax,1),%eax
f010083c:	ff 
f010083d:	0f b6 d0             	movzbl %al,%edx
f0100840:	8b 83 34 19 00 00    	mov    0x1934(%ebx),%eax
f0100846:	09 d0                	or     %edx,%eax
f0100848:	89 83 34 19 00 00    	mov    %eax,0x1934(%ebx)
	shift ^= togglecode[data];
f010084e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f0100852:	0f b6 84 03 4c e7 f8 	movzbl -0x718b4(%ebx,%eax,1),%eax
f0100859:	ff 
f010085a:	0f b6 d0             	movzbl %al,%edx
f010085d:	8b 83 34 19 00 00    	mov    0x1934(%ebx),%eax
f0100863:	31 d0                	xor    %edx,%eax
f0100865:	89 83 34 19 00 00    	mov    %eax,0x1934(%ebx)

	c = charcode[shift & (CTL | SHIFT)][data];
f010086b:	8b 83 34 19 00 00    	mov    0x1934(%ebx),%eax
f0100871:	83 e0 03             	and    $0x3,%eax
f0100874:	8b 94 83 4c 16 00 00 	mov    0x164c(%ebx,%eax,4),%edx
f010087b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
f010087f:	01 d0                	add    %edx,%eax
f0100881:	0f b6 00             	movzbl (%eax),%eax
f0100884:	0f b6 c0             	movzbl %al,%eax
f0100887:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (shift & CAPSLOCK) {
f010088a:	8b 83 34 19 00 00    	mov    0x1934(%ebx),%eax
f0100890:	83 e0 08             	and    $0x8,%eax
f0100893:	85 c0                	test   %eax,%eax
f0100895:	74 22                	je     f01008b9 <kbd_proc_data+0x174>
		if ('a' <= c && c <= 'z')
f0100897:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
f010089b:	7e 0c                	jle    f01008a9 <kbd_proc_data+0x164>
f010089d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
f01008a1:	7f 06                	jg     f01008a9 <kbd_proc_data+0x164>
			c += 'A' - 'a';
f01008a3:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
f01008a7:	eb 10                	jmp    f01008b9 <kbd_proc_data+0x174>
		else if ('A' <= c && c <= 'Z')
f01008a9:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
f01008ad:	7e 0a                	jle    f01008b9 <kbd_proc_data+0x174>
f01008af:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
f01008b3:	7f 04                	jg     f01008b9 <kbd_proc_data+0x174>
			c += 'a' - 'A';
f01008b5:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01008b9:	8b 83 34 19 00 00    	mov    0x1934(%ebx),%eax
f01008bf:	f7 d0                	not    %eax
f01008c1:	83 e0 06             	and    $0x6,%eax
f01008c4:	85 c0                	test   %eax,%eax
f01008c6:	75 2d                	jne    f01008f5 <kbd_proc_data+0x1b0>
f01008c8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
f01008cf:	75 24                	jne    f01008f5 <kbd_proc_data+0x1b0>
		cprintf("Rebooting!\n");
f01008d1:	83 ec 0c             	sub    $0xc,%esp
f01008d4:	8d 83 bb 58 f7 ff    	lea    -0x8a745(%ebx),%eax
f01008da:	50                   	push   %eax
f01008db:	e8 85 3f 00 00       	call   f0104865 <cprintf>
f01008e0:	83 c4 10             	add    $0x10,%esp
		outb(0x92, 0x3); // courtesy of Chris Frost
f01008e3:	83 ec 08             	sub    $0x8,%esp
f01008e6:	6a 03                	push   $0x3
f01008e8:	68 92 00 00 00       	push   $0x92
f01008ed:	e8 df f8 ff ff       	call   f01001d1 <outb>
f01008f2:	83 c4 10             	add    $0x10,%esp
	}

	return c;
f01008f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f01008f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01008fb:	c9                   	leave  
f01008fc:	c3                   	ret    

f01008fd <kbd_intr>:

void
kbd_intr(void)
{
f01008fd:	f3 0f 1e fb          	endbr32 
f0100901:	55                   	push   %ebp
f0100902:	89 e5                	mov    %esp,%ebp
f0100904:	83 ec 08             	sub    $0x8,%esp
f0100907:	e8 f3 01 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f010090c:	05 a8 10 09 00       	add    $0x910a8,%eax
	cons_intr(kbd_proc_data);
f0100911:	83 ec 0c             	sub    $0xc,%esp
f0100914:	8d 80 91 ed f6 ff    	lea    -0x9126f(%eax),%eax
f010091a:	50                   	push   %eax
f010091b:	e8 1a 00 00 00       	call   f010093a <cons_intr>
f0100920:	83 c4 10             	add    $0x10,%esp
}
f0100923:	90                   	nop
f0100924:	c9                   	leave  
f0100925:	c3                   	ret    

f0100926 <kbd_init>:

static void
kbd_init(void)
{
f0100926:	f3 0f 1e fb          	endbr32 
f010092a:	55                   	push   %ebp
f010092b:	89 e5                	mov    %esp,%ebp
f010092d:	e8 cd 01 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f0100932:	05 82 10 09 00       	add    $0x91082,%eax
}
f0100937:	90                   	nop
f0100938:	5d                   	pop    %ebp
f0100939:	c3                   	ret    

f010093a <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010093a:	f3 0f 1e fb          	endbr32 
f010093e:	55                   	push   %ebp
f010093f:	89 e5                	mov    %esp,%ebp
f0100941:	53                   	push   %ebx
f0100942:	83 ec 14             	sub    $0x14,%esp
f0100945:	e8 64 f8 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f010094a:	81 c3 6a 10 09 00    	add    $0x9106a,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100950:	eb 38                	jmp    f010098a <cons_intr+0x50>
		if (c == 0)
f0100952:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0100956:	75 02                	jne    f010095a <cons_intr+0x20>
			continue;
f0100958:	eb 30                	jmp    f010098a <cons_intr+0x50>
		cons.buf[cons.wpos++] = c;
f010095a:	8b 83 30 19 00 00    	mov    0x1930(%ebx),%eax
f0100960:	8d 50 01             	lea    0x1(%eax),%edx
f0100963:	89 93 30 19 00 00    	mov    %edx,0x1930(%ebx)
f0100969:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010096c:	88 94 03 2c 17 00 00 	mov    %dl,0x172c(%ebx,%eax,1)
		if (cons.wpos == CONSBUFSIZE)
f0100973:	8b 83 30 19 00 00    	mov    0x1930(%ebx),%eax
f0100979:	3d 00 02 00 00       	cmp    $0x200,%eax
f010097e:	75 0a                	jne    f010098a <cons_intr+0x50>
			cons.wpos = 0;
f0100980:	c7 83 30 19 00 00 00 	movl   $0x0,0x1930(%ebx)
f0100987:	00 00 00 
	while ((c = (*proc)()) != -1) {
f010098a:	8b 45 08             	mov    0x8(%ebp),%eax
f010098d:	ff d0                	call   *%eax
f010098f:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0100992:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
f0100996:	75 ba                	jne    f0100952 <cons_intr+0x18>
	}
}
f0100998:	90                   	nop
f0100999:	90                   	nop
f010099a:	83 c4 14             	add    $0x14,%esp
f010099d:	5b                   	pop    %ebx
f010099e:	5d                   	pop    %ebp
f010099f:	c3                   	ret    

f01009a0 <cons_getc>:

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f01009a0:	f3 0f 1e fb          	endbr32 
f01009a4:	55                   	push   %ebp
f01009a5:	89 e5                	mov    %esp,%ebp
f01009a7:	53                   	push   %ebx
f01009a8:	83 ec 14             	sub    $0x14,%esp
f01009ab:	e8 fe f7 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f01009b0:	81 c3 04 10 09 00    	add    $0x91004,%ebx
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f01009b6:	e8 c0 f8 ff ff       	call   f010027b <serial_intr>
	kbd_intr();
f01009bb:	e8 3d ff ff ff       	call   f01008fd <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f01009c0:	8b 93 2c 19 00 00    	mov    0x192c(%ebx),%edx
f01009c6:	8b 83 30 19 00 00    	mov    0x1930(%ebx),%eax
f01009cc:	39 c2                	cmp    %eax,%edx
f01009ce:	74 39                	je     f0100a09 <cons_getc+0x69>
		c = cons.buf[cons.rpos++];
f01009d0:	8b 83 2c 19 00 00    	mov    0x192c(%ebx),%eax
f01009d6:	8d 50 01             	lea    0x1(%eax),%edx
f01009d9:	89 93 2c 19 00 00    	mov    %edx,0x192c(%ebx)
f01009df:	0f b6 84 03 2c 17 00 	movzbl 0x172c(%ebx,%eax,1),%eax
f01009e6:	00 
f01009e7:	0f b6 c0             	movzbl %al,%eax
f01009ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (cons.rpos == CONSBUFSIZE)
f01009ed:	8b 83 2c 19 00 00    	mov    0x192c(%ebx),%eax
f01009f3:	3d 00 02 00 00       	cmp    $0x200,%eax
f01009f8:	75 0a                	jne    f0100a04 <cons_getc+0x64>
			cons.rpos = 0;
f01009fa:	c7 83 2c 19 00 00 00 	movl   $0x0,0x192c(%ebx)
f0100a01:	00 00 00 
		return c;
f0100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100a07:	eb 05                	jmp    f0100a0e <cons_getc+0x6e>
	}
	return 0;
f0100a09:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100a0e:	83 c4 14             	add    $0x14,%esp
f0100a11:	5b                   	pop    %ebx
f0100a12:	5d                   	pop    %ebp
f0100a13:	c3                   	ret    

f0100a14 <cons_putc>:

// output a character to the console
static void
cons_putc(int c)
{
f0100a14:	f3 0f 1e fb          	endbr32 
f0100a18:	55                   	push   %ebp
f0100a19:	89 e5                	mov    %esp,%ebp
f0100a1b:	83 ec 08             	sub    $0x8,%esp
f0100a1e:	e8 dc 00 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f0100a23:	05 91 0f 09 00       	add    $0x90f91,%eax
	serial_putc(c);
f0100a28:	ff 75 08             	pushl  0x8(%ebp)
f0100a2b:	e8 7f f8 ff ff       	call   f01002af <serial_putc>
f0100a30:	83 c4 04             	add    $0x4,%esp
	lpt_putc(c);
f0100a33:	ff 75 08             	pushl  0x8(%ebp)
f0100a36:	e8 88 f9 ff ff       	call   f01003c3 <lpt_putc>
f0100a3b:	83 c4 04             	add    $0x4,%esp
	cga_putc(c);
f0100a3e:	83 ec 0c             	sub    $0xc,%esp
f0100a41:	ff 75 08             	pushl  0x8(%ebp)
f0100a44:	e8 bf fa ff ff       	call   f0100508 <cga_putc>
f0100a49:	83 c4 10             	add    $0x10,%esp
}
f0100a4c:	90                   	nop
f0100a4d:	c9                   	leave  
f0100a4e:	c3                   	ret    

f0100a4f <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100a4f:	f3 0f 1e fb          	endbr32 
f0100a53:	55                   	push   %ebp
f0100a54:	89 e5                	mov    %esp,%ebp
f0100a56:	53                   	push   %ebx
f0100a57:	83 ec 04             	sub    $0x4,%esp
f0100a5a:	e8 4f f7 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100a5f:	81 c3 55 0f 09 00    	add    $0x90f55,%ebx
	cga_init();
f0100a65:	e8 ce f9 ff ff       	call   f0100438 <cga_init>
	kbd_init();
f0100a6a:	e8 b7 fe ff ff       	call   f0100926 <kbd_init>
	serial_init();
f0100a6f:	e8 98 f8 ff ff       	call   f010030c <serial_init>

	if (!serial_exists)
f0100a74:	0f b6 83 0c 17 00 00 	movzbl 0x170c(%ebx),%eax
f0100a7b:	83 f0 01             	xor    $0x1,%eax
f0100a7e:	84 c0                	test   %al,%al
f0100a80:	74 12                	je     f0100a94 <cons_init+0x45>
		cprintf("Serial port does not exist!\n");
f0100a82:	83 ec 0c             	sub    $0xc,%esp
f0100a85:	8d 83 c7 58 f7 ff    	lea    -0x8a739(%ebx),%eax
f0100a8b:	50                   	push   %eax
f0100a8c:	e8 d4 3d 00 00       	call   f0104865 <cprintf>
f0100a91:	83 c4 10             	add    $0x10,%esp
}
f0100a94:	90                   	nop
f0100a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100a98:	c9                   	leave  
f0100a99:	c3                   	ret    

f0100a9a <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100a9a:	f3 0f 1e fb          	endbr32 
f0100a9e:	55                   	push   %ebp
f0100a9f:	89 e5                	mov    %esp,%ebp
f0100aa1:	83 ec 08             	sub    $0x8,%esp
f0100aa4:	e8 56 00 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f0100aa9:	05 0b 0f 09 00       	add    $0x90f0b,%eax
	cons_putc(c);
f0100aae:	83 ec 0c             	sub    $0xc,%esp
f0100ab1:	ff 75 08             	pushl  0x8(%ebp)
f0100ab4:	e8 5b ff ff ff       	call   f0100a14 <cons_putc>
f0100ab9:	83 c4 10             	add    $0x10,%esp
}
f0100abc:	90                   	nop
f0100abd:	c9                   	leave  
f0100abe:	c3                   	ret    

f0100abf <getchar>:

int
getchar(void)
{
f0100abf:	f3 0f 1e fb          	endbr32 
f0100ac3:	55                   	push   %ebp
f0100ac4:	89 e5                	mov    %esp,%ebp
f0100ac6:	83 ec 18             	sub    $0x18,%esp
f0100ac9:	e8 31 00 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f0100ace:	05 e6 0e 09 00       	add    $0x90ee6,%eax
	int c;

	while ((c = cons_getc()) == 0)
f0100ad3:	90                   	nop
f0100ad4:	e8 c7 fe ff ff       	call   f01009a0 <cons_getc>
f0100ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0100adc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0100ae0:	74 f2                	je     f0100ad4 <getchar+0x15>
		/* do nothing */;
	return c;
f0100ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0100ae5:	c9                   	leave  
f0100ae6:	c3                   	ret    

f0100ae7 <iscons>:

int
iscons(int fdnum)
{
f0100ae7:	f3 0f 1e fb          	endbr32 
f0100aeb:	55                   	push   %ebp
f0100aec:	89 e5                	mov    %esp,%ebp
f0100aee:	e8 0c 00 00 00       	call   f0100aff <__x86.get_pc_thunk.ax>
f0100af3:	05 c1 0e 09 00       	add    $0x90ec1,%eax
	// used by readline
	return 1;
f0100af8:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0100afd:	5d                   	pop    %ebp
f0100afe:	c3                   	ret    

f0100aff <__x86.get_pc_thunk.ax>:
f0100aff:	8b 04 24             	mov    (%esp),%eax
f0100b02:	c3                   	ret    

f0100b03 <read_ebp>:
	asm volatile("pushl %0; popfl" : : "r" (eflags));
}

static inline uint32_t
read_ebp(void)
{
f0100b03:	55                   	push   %ebp
f0100b04:	89 e5                	mov    %esp,%ebp
f0100b06:	83 ec 10             	sub    $0x10,%esp
f0100b09:	e8 f1 ff ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0100b0e:	05 a6 0e 09 00       	add    $0x90ea6,%eax
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100b13:	89 e8                	mov    %ebp,%eax
f0100b15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return ebp;
f0100b18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
f0100b1b:	c9                   	leave  
f0100b1c:	c3                   	ret    

f0100b1d <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100b1d:	f3 0f 1e fb          	endbr32 
f0100b21:	55                   	push   %ebp
f0100b22:	89 e5                	mov    %esp,%ebp
f0100b24:	56                   	push   %esi
f0100b25:	53                   	push   %ebx
f0100b26:	83 ec 10             	sub    $0x10,%esp
f0100b29:	e8 80 f6 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100b2e:	81 c3 86 0e 09 00    	add    $0x90e86,%ebx
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
f0100b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0100b3b:	eb 44                	jmp    f0100b81 <mon_help+0x64>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100b3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0100b40:	8d 8b 60 16 00 00    	lea    0x1660(%ebx),%ecx
f0100b46:	89 d0                	mov    %edx,%eax
f0100b48:	01 c0                	add    %eax,%eax
f0100b4a:	01 d0                	add    %edx,%eax
f0100b4c:	c1 e0 02             	shl    $0x2,%eax
f0100b4f:	01 c8                	add    %ecx,%eax
f0100b51:	8b 08                	mov    (%eax),%ecx
f0100b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0100b56:	8d b3 5c 16 00 00    	lea    0x165c(%ebx),%esi
f0100b5c:	89 d0                	mov    %edx,%eax
f0100b5e:	01 c0                	add    %eax,%eax
f0100b60:	01 d0                	add    %edx,%eax
f0100b62:	c1 e0 02             	shl    $0x2,%eax
f0100b65:	01 f0                	add    %esi,%eax
f0100b67:	8b 00                	mov    (%eax),%eax
f0100b69:	83 ec 04             	sub    $0x4,%esp
f0100b6c:	51                   	push   %ecx
f0100b6d:	50                   	push   %eax
f0100b6e:	8d 83 35 59 f7 ff    	lea    -0x8a6cb(%ebx),%eax
f0100b74:	50                   	push   %eax
f0100b75:	e8 eb 3c 00 00       	call   f0104865 <cprintf>
f0100b7a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAY_SIZE(commands); i++)
f0100b7d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0100b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100b84:	83 f8 01             	cmp    $0x1,%eax
f0100b87:	76 b4                	jbe    f0100b3d <mon_help+0x20>
	return 0;
f0100b89:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100b8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100b91:	5b                   	pop    %ebx
f0100b92:	5e                   	pop    %esi
f0100b93:	5d                   	pop    %ebp
f0100b94:	c3                   	ret    

f0100b95 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100b95:	f3 0f 1e fb          	endbr32 
f0100b99:	55                   	push   %ebp
f0100b9a:	89 e5                	mov    %esp,%ebp
f0100b9c:	53                   	push   %ebx
f0100b9d:	83 ec 14             	sub    $0x14,%esp
f0100ba0:	e8 09 f6 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100ba5:	81 c3 0f 0e 09 00    	add    $0x90e0f,%ebx
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100bab:	83 ec 0c             	sub    $0xc,%esp
f0100bae:	8d 83 3e 59 f7 ff    	lea    -0x8a6c2(%ebx),%eax
f0100bb4:	50                   	push   %eax
f0100bb5:	e8 ab 3c 00 00       	call   f0104865 <cprintf>
f0100bba:	83 c4 10             	add    $0x10,%esp
	cprintf("  _start                  %08x (phys)\n", _start);
f0100bbd:	83 ec 08             	sub    $0x8,%esp
f0100bc0:	c7 c0 0c 00 10 00    	mov    $0x10000c,%eax
f0100bc6:	50                   	push   %eax
f0100bc7:	8d 83 58 59 f7 ff    	lea    -0x8a6a8(%ebx),%eax
f0100bcd:	50                   	push   %eax
f0100bce:	e8 92 3c 00 00       	call   f0104865 <cprintf>
f0100bd3:	83 c4 10             	add    $0x10,%esp
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100bd6:	c7 c0 0c 00 10 f0    	mov    $0xf010000c,%eax
f0100bdc:	8d 80 00 00 00 10    	lea    0x10000000(%eax),%eax
f0100be2:	83 ec 04             	sub    $0x4,%esp
f0100be5:	50                   	push   %eax
f0100be6:	c7 c0 0c 00 10 f0    	mov    $0xf010000c,%eax
f0100bec:	50                   	push   %eax
f0100bed:	8d 83 80 59 f7 ff    	lea    -0x8a680(%ebx),%eax
f0100bf3:	50                   	push   %eax
f0100bf4:	e8 6c 3c 00 00       	call   f0104865 <cprintf>
f0100bf9:	83 c4 10             	add    $0x10,%esp
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100bfc:	c7 c0 1d 72 10 f0    	mov    $0xf010721d,%eax
f0100c02:	8d 80 00 00 00 10    	lea    0x10000000(%eax),%eax
f0100c08:	83 ec 04             	sub    $0x4,%esp
f0100c0b:	50                   	push   %eax
f0100c0c:	c7 c0 1d 72 10 f0    	mov    $0xf010721d,%eax
f0100c12:	50                   	push   %eax
f0100c13:	8d 83 a4 59 f7 ff    	lea    -0x8a65c(%ebx),%eax
f0100c19:	50                   	push   %eax
f0100c1a:	e8 46 3c 00 00       	call   f0104865 <cprintf>
f0100c1f:	83 c4 10             	add    $0x10,%esp
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100c22:	c7 c0 c0 30 19 f0    	mov    $0xf01930c0,%eax
f0100c28:	8d 80 00 00 00 10    	lea    0x10000000(%eax),%eax
f0100c2e:	83 ec 04             	sub    $0x4,%esp
f0100c31:	50                   	push   %eax
f0100c32:	c7 c0 c0 30 19 f0    	mov    $0xf01930c0,%eax
f0100c38:	50                   	push   %eax
f0100c39:	8d 83 c8 59 f7 ff    	lea    -0x8a638(%ebx),%eax
f0100c3f:	50                   	push   %eax
f0100c40:	e8 20 3c 00 00       	call   f0104865 <cprintf>
f0100c45:	83 c4 10             	add    $0x10,%esp
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100c48:	c7 c0 a0 3f 19 f0    	mov    $0xf0193fa0,%eax
f0100c4e:	8d 80 00 00 00 10    	lea    0x10000000(%eax),%eax
f0100c54:	83 ec 04             	sub    $0x4,%esp
f0100c57:	50                   	push   %eax
f0100c58:	c7 c0 a0 3f 19 f0    	mov    $0xf0193fa0,%eax
f0100c5e:	50                   	push   %eax
f0100c5f:	8d 83 ec 59 f7 ff    	lea    -0x8a614(%ebx),%eax
f0100c65:	50                   	push   %eax
f0100c66:	e8 fa 3b 00 00       	call   f0104865 <cprintf>
f0100c6b:	83 c4 10             	add    $0x10,%esp
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
f0100c6e:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
f0100c75:	c7 c0 a0 3f 19 f0    	mov    $0xf0193fa0,%eax
f0100c7b:	89 c2                	mov    %eax,%edx
f0100c7d:	c7 c0 0c 00 10 f0    	mov    $0xf010000c,%eax
f0100c83:	29 c2                	sub    %eax,%edx
f0100c85:	89 d0                	mov    %edx,%eax
f0100c87:	8d 50 ff             	lea    -0x1(%eax),%edx
f0100c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100c8d:	01 d0                	add    %edx,%eax
f0100c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0100c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100c95:	ba 00 00 00 00       	mov    $0x0,%edx
f0100c9a:	f7 75 f4             	divl   -0xc(%ebp)
f0100c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100ca0:	29 d0                	sub    %edx,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100ca2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
f0100ca8:	85 c0                	test   %eax,%eax
f0100caa:	0f 48 c2             	cmovs  %edx,%eax
f0100cad:	c1 f8 0a             	sar    $0xa,%eax
f0100cb0:	83 ec 08             	sub    $0x8,%esp
f0100cb3:	50                   	push   %eax
f0100cb4:	8d 83 10 5a f7 ff    	lea    -0x8a5f0(%ebx),%eax
f0100cba:	50                   	push   %eax
f0100cbb:	e8 a5 3b 00 00       	call   f0104865 <cprintf>
f0100cc0:	83 c4 10             	add    $0x10,%esp
	return 0;
f0100cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100cc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100ccb:	c9                   	leave  
f0100ccc:	c3                   	ret    

f0100ccd <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100ccd:	f3 0f 1e fb          	endbr32 
f0100cd1:	55                   	push   %ebp
f0100cd2:	89 e5                	mov    %esp,%ebp
f0100cd4:	57                   	push   %edi
f0100cd5:	56                   	push   %esi
f0100cd6:	53                   	push   %ebx
f0100cd7:	83 ec 3c             	sub    $0x3c,%esp
f0100cda:	e8 cf f4 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100cdf:	81 c3 d5 0c 09 00    	add    $0x90cd5,%ebx
	// Your code here.
	cprintf("Stack backtrace:\n");
f0100ce5:	83 ec 0c             	sub    $0xc,%esp
f0100ce8:	8d 83 3a 5a f7 ff    	lea    -0x8a5c6(%ebx),%eax
f0100cee:	50                   	push   %eax
f0100cef:	e8 71 3b 00 00       	call   f0104865 <cprintf>
f0100cf4:	83 c4 10             	add    $0x10,%esp

	int* now_ebp = (int *)read_ebp();
f0100cf7:	e8 07 fe ff ff       	call   f0100b03 <read_ebp>
f0100cfc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	while(now_ebp != NULL)
f0100cff:	e9 c6 00 00 00       	jmp    f0100dca <mon_backtrace+0xfd>
	// when the bootstack was initialized the 
	// ebp was also initialized with 0 and pushed
	// into the bootstack
	{
		// print ebp and eip(in *(now_ebp + 1))
		int eip = *(now_ebp + 1);
f0100d04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100d07:	8b 40 04             	mov    0x4(%eax),%eax
f0100d0a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("ebp %08x eip %08x args", now_ebp, eip);
f0100d0d:	83 ec 04             	sub    $0x4,%esp
f0100d10:	ff 75 dc             	pushl  -0x24(%ebp)
f0100d13:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100d16:	8d 83 4c 5a f7 ff    	lea    -0x8a5b4(%ebx),%eax
f0100d1c:	50                   	push   %eax
f0100d1d:	e8 43 3b 00 00       	call   f0104865 <cprintf>
f0100d22:	83 c4 10             	add    $0x10,%esp
		for(int i = 1; i <= 5; ++i)
f0100d25:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
f0100d2c:	eb 2b                	jmp    f0100d59 <mon_backtrace+0x8c>
		{
			// print the first 5 args
			cprintf(" %08x", *(now_ebp + 1 + i));
f0100d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100d31:	83 c0 01             	add    $0x1,%eax
f0100d34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f0100d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100d3e:	01 d0                	add    %edx,%eax
f0100d40:	8b 00                	mov    (%eax),%eax
f0100d42:	83 ec 08             	sub    $0x8,%esp
f0100d45:	50                   	push   %eax
f0100d46:	8d 83 63 5a f7 ff    	lea    -0x8a59d(%ebx),%eax
f0100d4c:	50                   	push   %eax
f0100d4d:	e8 13 3b 00 00       	call   f0104865 <cprintf>
f0100d52:	83 c4 10             	add    $0x10,%esp
		for(int i = 1; i <= 5; ++i)
f0100d55:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f0100d59:	83 7d e0 05          	cmpl   $0x5,-0x20(%ebp)
f0100d5d:	7e cf                	jle    f0100d2e <mon_backtrace+0x61>
		}
		cprintf("\n");
f0100d5f:	83 ec 0c             	sub    $0xc,%esp
f0100d62:	8d 83 69 5a f7 ff    	lea    -0x8a597(%ebx),%eax
f0100d68:	50                   	push   %eax
f0100d69:	e8 f7 3a 00 00       	call   f0104865 <cprintf>
f0100d6e:	83 c4 10             	add    $0x10,%esp

		// Add EpiInfo debug information
		struct Eipdebuginfo eip_info;
		if(debuginfo_eip(eip, &eip_info) == 0)
f0100d71:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100d74:	83 ec 08             	sub    $0x8,%esp
f0100d77:	8d 55 c4             	lea    -0x3c(%ebp),%edx
f0100d7a:	52                   	push   %edx
f0100d7b:	50                   	push   %eax
f0100d7c:	e8 dd 50 00 00       	call   f0105e5e <debuginfo_eip>
f0100d81:	83 c4 10             	add    $0x10,%esp
f0100d84:	85 c0                	test   %eax,%eax
f0100d86:	75 28                	jne    f0100db0 <mon_backtrace+0xe3>
		{
			cprintf("\t%s:%d: %.*s+%d\n", 
f0100d88:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0100d8b:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0100d8e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0100d91:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0100d94:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0100d97:	83 ec 08             	sub    $0x8,%esp
f0100d9a:	57                   	push   %edi
f0100d9b:	56                   	push   %esi
f0100d9c:	51                   	push   %ecx
f0100d9d:	52                   	push   %edx
f0100d9e:	50                   	push   %eax
f0100d9f:	8d 83 6b 5a f7 ff    	lea    -0x8a595(%ebx),%eax
f0100da5:	50                   	push   %eax
f0100da6:	e8 ba 3a 00 00       	call   f0104865 <cprintf>
f0100dab:	83 c4 20             	add    $0x20,%esp
f0100dae:	eb 12                	jmp    f0100dc2 <mon_backtrace+0xf5>
					eip_info.eip_fn_name,
					eip_info.eip_fn_addr
			);
		}
		else
            cprintf("Error happened when reading symbol table\n");
f0100db0:	83 ec 0c             	sub    $0xc,%esp
f0100db3:	8d 83 7c 5a f7 ff    	lea    -0x8a584(%ebx),%eax
f0100db9:	50                   	push   %eax
f0100dba:	e8 a6 3a 00 00       	call   f0104865 <cprintf>
f0100dbf:	83 c4 10             	add    $0x10,%esp
		now_ebp = (int *)*(now_ebp);
f0100dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100dc5:	8b 00                	mov    (%eax),%eax
f0100dc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	while(now_ebp != NULL)
f0100dca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0100dce:	0f 85 30 ff ff ff    	jne    f0100d04 <mon_backtrace+0x37>
	}
	return 0;
f0100dd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100ddc:	5b                   	pop    %ebx
f0100ddd:	5e                   	pop    %esi
f0100dde:	5f                   	pop    %edi
f0100ddf:	5d                   	pop    %ebp
f0100de0:	c3                   	ret    

f0100de1 <runcmd>:
#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
f0100de1:	f3 0f 1e fb          	endbr32 
f0100de5:	55                   	push   %ebp
f0100de6:	89 e5                	mov    %esp,%ebp
f0100de8:	53                   	push   %ebx
f0100de9:	83 ec 54             	sub    $0x54,%esp
f0100dec:	e8 bd f3 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100df1:	81 c3 c3 0b 09 00    	add    $0x90bc3,%ebx
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f0100df7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	argv[argc] = 0;
f0100dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100e01:	c7 44 85 b0 00 00 00 	movl   $0x0,-0x50(%ebp,%eax,4)
f0100e08:	00 
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100e09:	eb 0c                	jmp    f0100e17 <runcmd+0x36>
			*buf++ = 0;
f0100e0b:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e0e:	8d 50 01             	lea    0x1(%eax),%edx
f0100e11:	89 55 08             	mov    %edx,0x8(%ebp)
f0100e14:	c6 00 00             	movb   $0x0,(%eax)
		while (*buf && strchr(WHITESPACE, *buf))
f0100e17:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e1a:	0f b6 00             	movzbl (%eax),%eax
f0100e1d:	84 c0                	test   %al,%al
f0100e1f:	74 20                	je     f0100e41 <runcmd+0x60>
f0100e21:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e24:	0f b6 00             	movzbl (%eax),%eax
f0100e27:	0f be c0             	movsbl %al,%eax
f0100e2a:	83 ec 08             	sub    $0x8,%esp
f0100e2d:	50                   	push   %eax
f0100e2e:	8d 83 a6 5a f7 ff    	lea    -0x8a55a(%ebx),%eax
f0100e34:	50                   	push   %eax
f0100e35:	e8 68 5d 00 00       	call   f0106ba2 <strchr>
f0100e3a:	83 c4 10             	add    $0x10,%esp
f0100e3d:	85 c0                	test   %eax,%eax
f0100e3f:	75 ca                	jne    f0100e0b <runcmd+0x2a>
		if (*buf == 0)
f0100e41:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e44:	0f b6 00             	movzbl (%eax),%eax
f0100e47:	84 c0                	test   %al,%al
f0100e49:	74 69                	je     f0100eb4 <runcmd+0xd3>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100e4b:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
f0100e4f:	75 1e                	jne    f0100e6f <runcmd+0x8e>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100e51:	83 ec 08             	sub    $0x8,%esp
f0100e54:	6a 10                	push   $0x10
f0100e56:	8d 83 ab 5a f7 ff    	lea    -0x8a555(%ebx),%eax
f0100e5c:	50                   	push   %eax
f0100e5d:	e8 03 3a 00 00       	call   f0104865 <cprintf>
f0100e62:	83 c4 10             	add    $0x10,%esp
			return 0;
f0100e65:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e6a:	e9 e5 00 00 00       	jmp    f0100f54 <runcmd+0x173>
		}
		argv[argc++] = buf;
f0100e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100e72:	8d 50 01             	lea    0x1(%eax),%edx
f0100e75:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0100e78:	8b 55 08             	mov    0x8(%ebp),%edx
f0100e7b:	89 54 85 b0          	mov    %edx,-0x50(%ebp,%eax,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100e7f:	eb 04                	jmp    f0100e85 <runcmd+0xa4>
			buf++;
f0100e81:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100e85:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e88:	0f b6 00             	movzbl (%eax),%eax
f0100e8b:	84 c0                	test   %al,%al
f0100e8d:	74 88                	je     f0100e17 <runcmd+0x36>
f0100e8f:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e92:	0f b6 00             	movzbl (%eax),%eax
f0100e95:	0f be c0             	movsbl %al,%eax
f0100e98:	83 ec 08             	sub    $0x8,%esp
f0100e9b:	50                   	push   %eax
f0100e9c:	8d 83 a6 5a f7 ff    	lea    -0x8a55a(%ebx),%eax
f0100ea2:	50                   	push   %eax
f0100ea3:	e8 fa 5c 00 00       	call   f0106ba2 <strchr>
f0100ea8:	83 c4 10             	add    $0x10,%esp
f0100eab:	85 c0                	test   %eax,%eax
f0100ead:	74 d2                	je     f0100e81 <runcmd+0xa0>
		while (*buf && strchr(WHITESPACE, *buf))
f0100eaf:	e9 63 ff ff ff       	jmp    f0100e17 <runcmd+0x36>
			break;
f0100eb4:	90                   	nop
	}
	argv[argc] = 0;
f0100eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100eb8:	c7 44 85 b0 00 00 00 	movl   $0x0,-0x50(%ebp,%eax,4)
f0100ebf:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100ec0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0100ec4:	75 0a                	jne    f0100ed0 <runcmd+0xef>
		return 0;
f0100ec6:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ecb:	e9 84 00 00 00       	jmp    f0100f54 <runcmd+0x173>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100ed0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0100ed7:	eb 58                	jmp    f0100f31 <runcmd+0x150>
		if (strcmp(argv[0], commands[i].name) == 0)
f0100ed9:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100edc:	8d 8b 5c 16 00 00    	lea    0x165c(%ebx),%ecx
f0100ee2:	89 d0                	mov    %edx,%eax
f0100ee4:	01 c0                	add    %eax,%eax
f0100ee6:	01 d0                	add    %edx,%eax
f0100ee8:	c1 e0 02             	shl    $0x2,%eax
f0100eeb:	01 c8                	add    %ecx,%eax
f0100eed:	8b 10                	mov    (%eax),%edx
f0100eef:	8b 45 b0             	mov    -0x50(%ebp),%eax
f0100ef2:	83 ec 08             	sub    $0x8,%esp
f0100ef5:	52                   	push   %edx
f0100ef6:	50                   	push   %eax
f0100ef7:	e8 f5 5b 00 00       	call   f0106af1 <strcmp>
f0100efc:	83 c4 10             	add    $0x10,%esp
f0100eff:	85 c0                	test   %eax,%eax
f0100f01:	75 2a                	jne    f0100f2d <runcmd+0x14c>
			return commands[i].func(argc, argv, tf);
f0100f03:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0100f06:	8d 8b 64 16 00 00    	lea    0x1664(%ebx),%ecx
f0100f0c:	89 d0                	mov    %edx,%eax
f0100f0e:	01 c0                	add    %eax,%eax
f0100f10:	01 d0                	add    %edx,%eax
f0100f12:	c1 e0 02             	shl    $0x2,%eax
f0100f15:	01 c8                	add    %ecx,%eax
f0100f17:	8b 00                	mov    (%eax),%eax
f0100f19:	83 ec 04             	sub    $0x4,%esp
f0100f1c:	ff 75 0c             	pushl  0xc(%ebp)
f0100f1f:	8d 55 b0             	lea    -0x50(%ebp),%edx
f0100f22:	52                   	push   %edx
f0100f23:	ff 75 f4             	pushl  -0xc(%ebp)
f0100f26:	ff d0                	call   *%eax
f0100f28:	83 c4 10             	add    $0x10,%esp
f0100f2b:	eb 27                	jmp    f0100f54 <runcmd+0x173>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100f2d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
f0100f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0100f34:	83 f8 01             	cmp    $0x1,%eax
f0100f37:	76 a0                	jbe    f0100ed9 <runcmd+0xf8>
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100f39:	8b 45 b0             	mov    -0x50(%ebp),%eax
f0100f3c:	83 ec 08             	sub    $0x8,%esp
f0100f3f:	50                   	push   %eax
f0100f40:	8d 83 c8 5a f7 ff    	lea    -0x8a538(%ebx),%eax
f0100f46:	50                   	push   %eax
f0100f47:	e8 19 39 00 00       	call   f0104865 <cprintf>
f0100f4c:	83 c4 10             	add    $0x10,%esp
	return 0;
f0100f4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100f54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100f57:	c9                   	leave  
f0100f58:	c3                   	ret    

f0100f59 <monitor>:

void
monitor(struct Trapframe *tf)
{
f0100f59:	f3 0f 1e fb          	endbr32 
f0100f5d:	55                   	push   %ebp
f0100f5e:	89 e5                	mov    %esp,%ebp
f0100f60:	53                   	push   %ebx
f0100f61:	83 ec 14             	sub    $0x14,%esp
f0100f64:	e8 45 f2 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0100f69:	81 c3 4b 0a 09 00    	add    $0x90a4b,%ebx
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100f6f:	83 ec 0c             	sub    $0xc,%esp
f0100f72:	8d 83 e0 5a f7 ff    	lea    -0x8a520(%ebx),%eax
f0100f78:	50                   	push   %eax
f0100f79:	e8 e7 38 00 00       	call   f0104865 <cprintf>
f0100f7e:	83 c4 10             	add    $0x10,%esp
	cprintf("Type 'help' for a list of commands.\n");
f0100f81:	83 ec 0c             	sub    $0xc,%esp
f0100f84:	8d 83 04 5b f7 ff    	lea    -0x8a4fc(%ebx),%eax
f0100f8a:	50                   	push   %eax
f0100f8b:	e8 d5 38 00 00       	call   f0104865 <cprintf>
f0100f90:	83 c4 10             	add    $0x10,%esp

	if (tf != NULL)
f0100f93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100f97:	74 0e                	je     f0100fa7 <monitor+0x4e>
		print_trapframe(tf);
f0100f99:	83 ec 0c             	sub    $0xc,%esp
f0100f9c:	ff 75 08             	pushl  0x8(%ebp)
f0100f9f:	e8 a3 45 00 00       	call   f0105547 <print_trapframe>
f0100fa4:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100fa7:	83 ec 0c             	sub    $0xc,%esp
f0100faa:	8d 83 29 5b f7 ff    	lea    -0x8a4d7(%ebx),%eax
f0100fb0:	50                   	push   %eax
f0100fb1:	e8 87 58 00 00       	call   f010683d <readline>
f0100fb6:	83 c4 10             	add    $0x10,%esp
f0100fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (buf != NULL)
f0100fbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0100fc0:	74 e5                	je     f0100fa7 <monitor+0x4e>
			if (runcmd(buf, tf) < 0)
f0100fc2:	83 ec 08             	sub    $0x8,%esp
f0100fc5:	ff 75 08             	pushl  0x8(%ebp)
f0100fc8:	ff 75 f4             	pushl  -0xc(%ebp)
f0100fcb:	e8 11 fe ff ff       	call   f0100de1 <runcmd>
f0100fd0:	83 c4 10             	add    $0x10,%esp
f0100fd3:	85 c0                	test   %eax,%eax
f0100fd5:	78 02                	js     f0100fd9 <monitor+0x80>
		buf = readline("K> ");
f0100fd7:	eb ce                	jmp    f0100fa7 <monitor+0x4e>
				break;
f0100fd9:	90                   	nop
	}
}
f0100fda:	90                   	nop
f0100fdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100fde:	c9                   	leave  
f0100fdf:	c3                   	ret    

f0100fe0 <invlpg>:
{
f0100fe0:	55                   	push   %ebp
f0100fe1:	89 e5                	mov    %esp,%ebp
f0100fe3:	e8 17 fb ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0100fe8:	05 cc 09 09 00       	add    $0x909cc,%eax
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0100fed:	8b 45 08             	mov    0x8(%ebp),%eax
f0100ff0:	0f 01 38             	invlpg (%eax)
}
f0100ff3:	90                   	nop
f0100ff4:	5d                   	pop    %ebp
f0100ff5:	c3                   	ret    

f0100ff6 <lcr0>:
{
f0100ff6:	55                   	push   %ebp
f0100ff7:	89 e5                	mov    %esp,%ebp
f0100ff9:	e8 01 fb ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0100ffe:	05 b6 09 09 00       	add    $0x909b6,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0101003:	8b 45 08             	mov    0x8(%ebp),%eax
f0101006:	0f 22 c0             	mov    %eax,%cr0
}
f0101009:	90                   	nop
f010100a:	5d                   	pop    %ebp
f010100b:	c3                   	ret    

f010100c <rcr0>:
{
f010100c:	55                   	push   %ebp
f010100d:	89 e5                	mov    %esp,%ebp
f010100f:	83 ec 10             	sub    $0x10,%esp
f0101012:	e8 e8 fa ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0101017:	05 9d 09 09 00       	add    $0x9099d,%eax
	asm volatile("movl %%cr0,%0" : "=r" (val));
f010101c:	0f 20 c0             	mov    %cr0,%eax
f010101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return val;
f0101022:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
f0101025:	c9                   	leave  
f0101026:	c3                   	ret    

f0101027 <lcr3>:
{
f0101027:	55                   	push   %ebp
f0101028:	89 e5                	mov    %esp,%ebp
f010102a:	e8 d0 fa ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f010102f:	05 85 09 09 00       	add    $0x90985,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0101034:	8b 45 08             	mov    0x8(%ebp),%eax
f0101037:	0f 22 d8             	mov    %eax,%cr3
}
f010103a:	90                   	nop
f010103b:	5d                   	pop    %ebp
f010103c:	c3                   	ret    

f010103d <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
f010103d:	55                   	push   %ebp
f010103e:	89 e5                	mov    %esp,%ebp
f0101040:	53                   	push   %ebx
f0101041:	83 ec 04             	sub    $0x4,%esp
f0101044:	e8 b6 fa ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0101049:	05 6b 09 09 00       	add    $0x9096b,%eax
	if ((uint32_t)kva < KERNBASE)
f010104e:	8b 55 10             	mov    0x10(%ebp),%edx
f0101051:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0101057:	77 17                	ja     f0101070 <_paddr+0x33>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101059:	ff 75 10             	pushl  0x10(%ebp)
f010105c:	8d 90 30 5b f7 ff    	lea    -0x8a4d0(%eax),%edx
f0101062:	52                   	push   %edx
f0101063:	ff 75 0c             	pushl  0xc(%ebp)
f0101066:	ff 75 08             	pushl  0x8(%ebp)
f0101069:	89 c3                	mov    %eax,%ebx
f010106b:	e8 5d f0 ff ff       	call   f01000cd <_panic>
	return (physaddr_t)kva - KERNBASE;
f0101070:	8b 45 10             	mov    0x10(%ebp),%eax
f0101073:	05 00 00 00 10       	add    $0x10000000,%eax
}
f0101078:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010107b:	c9                   	leave  
f010107c:	c3                   	ret    

f010107d <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f010107d:	55                   	push   %ebp
f010107e:	89 e5                	mov    %esp,%ebp
f0101080:	53                   	push   %ebx
f0101081:	83 ec 04             	sub    $0x4,%esp
f0101084:	e8 76 fa ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0101089:	05 2b 09 09 00       	add    $0x9092b,%eax
	if (PGNUM(pa) >= npages)
f010108e:	8b 55 10             	mov    0x10(%ebp),%edx
f0101091:	89 d1                	mov    %edx,%ecx
f0101093:	c1 e9 0c             	shr    $0xc,%ecx
f0101096:	c7 c2 a8 3f 19 f0    	mov    $0xf0193fa8,%edx
f010109c:	8b 12                	mov    (%edx),%edx
f010109e:	39 d1                	cmp    %edx,%ecx
f01010a0:	72 17                	jb     f01010b9 <_kaddr+0x3c>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01010a2:	ff 75 10             	pushl  0x10(%ebp)
f01010a5:	8d 90 54 5b f7 ff    	lea    -0x8a4ac(%eax),%edx
f01010ab:	52                   	push   %edx
f01010ac:	ff 75 0c             	pushl  0xc(%ebp)
f01010af:	ff 75 08             	pushl  0x8(%ebp)
f01010b2:	89 c3                	mov    %eax,%ebx
f01010b4:	e8 14 f0 ff ff       	call   f01000cd <_panic>
	return (void *)(pa + KERNBASE);
f01010b9:	8b 45 10             	mov    0x10(%ebp),%eax
f01010bc:	2d 00 00 00 10       	sub    $0x10000000,%eax
}
f01010c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01010c4:	c9                   	leave  
f01010c5:	c3                   	ret    

f01010c6 <page2pa>:
int	user_mem_check(struct Env *env, const void *va, size_t len, int perm);
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
f01010c6:	55                   	push   %ebp
f01010c7:	89 e5                	mov    %esp,%ebp
f01010c9:	e8 31 fa ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01010ce:	05 e6 08 09 00       	add    $0x908e6,%eax
	return (pp - pages) << PGSHIFT;
f01010d3:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f01010d9:	8b 00                	mov    (%eax),%eax
f01010db:	8b 55 08             	mov    0x8(%ebp),%edx
f01010de:	29 c2                	sub    %eax,%edx
f01010e0:	89 d0                	mov    %edx,%eax
f01010e2:	c1 f8 03             	sar    $0x3,%eax
f01010e5:	c1 e0 0c             	shl    $0xc,%eax
}
f01010e8:	5d                   	pop    %ebp
f01010e9:	c3                   	ret    

f01010ea <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
f01010ea:	55                   	push   %ebp
f01010eb:	89 e5                	mov    %esp,%ebp
f01010ed:	53                   	push   %ebx
f01010ee:	83 ec 04             	sub    $0x4,%esp
f01010f1:	e8 09 fa ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01010f6:	05 be 08 09 00       	add    $0x908be,%eax
	if (PGNUM(pa) >= npages)
f01010fb:	8b 55 08             	mov    0x8(%ebp),%edx
f01010fe:	89 d1                	mov    %edx,%ecx
f0101100:	c1 e9 0c             	shr    $0xc,%ecx
f0101103:	c7 c2 a8 3f 19 f0    	mov    $0xf0193fa8,%edx
f0101109:	8b 12                	mov    (%edx),%edx
f010110b:	39 d1                	cmp    %edx,%ecx
f010110d:	72 1a                	jb     f0101129 <pa2page+0x3f>
		panic("pa2page called with invalid pa");
f010110f:	83 ec 04             	sub    $0x4,%esp
f0101112:	8d 90 78 5b f7 ff    	lea    -0x8a488(%eax),%edx
f0101118:	52                   	push   %edx
f0101119:	6a 4f                	push   $0x4f
f010111b:	8d 90 97 5b f7 ff    	lea    -0x8a469(%eax),%edx
f0101121:	52                   	push   %edx
f0101122:	89 c3                	mov    %eax,%ebx
f0101124:	e8 a4 ef ff ff       	call   f01000cd <_panic>
	return &pages[PGNUM(pa)];
f0101129:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f010112f:	8b 00                	mov    (%eax),%eax
f0101131:	8b 55 08             	mov    0x8(%ebp),%edx
f0101134:	c1 ea 0c             	shr    $0xc,%edx
f0101137:	c1 e2 03             	shl    $0x3,%edx
f010113a:	01 d0                	add    %edx,%eax
}
f010113c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010113f:	c9                   	leave  
f0101140:	c3                   	ret    

f0101141 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
f0101141:	55                   	push   %ebp
f0101142:	89 e5                	mov    %esp,%ebp
f0101144:	53                   	push   %ebx
f0101145:	83 ec 04             	sub    $0x4,%esp
f0101148:	e8 61 f0 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f010114d:	81 c3 67 08 09 00    	add    $0x90867,%ebx
	return KADDR(page2pa(pp));
f0101153:	ff 75 08             	pushl  0x8(%ebp)
f0101156:	e8 6b ff ff ff       	call   f01010c6 <page2pa>
f010115b:	83 c4 04             	add    $0x4,%esp
f010115e:	83 ec 04             	sub    $0x4,%esp
f0101161:	50                   	push   %eax
f0101162:	6a 56                	push   $0x56
f0101164:	8d 83 97 5b f7 ff    	lea    -0x8a469(%ebx),%eax
f010116a:	50                   	push   %eax
f010116b:	e8 0d ff ff ff       	call   f010107d <_kaddr>
f0101170:	83 c4 10             	add    $0x10,%esp
}
f0101173:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101176:	c9                   	leave  
f0101177:	c3                   	ret    

f0101178 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0101178:	f3 0f 1e fb          	endbr32 
f010117c:	55                   	push   %ebp
f010117d:	89 e5                	mov    %esp,%ebp
f010117f:	56                   	push   %esi
f0101180:	53                   	push   %ebx
f0101181:	e8 28 f0 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0101186:	81 c3 2e 08 09 00    	add    $0x9082e,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f010118c:	8b 45 08             	mov    0x8(%ebp),%eax
f010118f:	83 ec 0c             	sub    $0xc,%esp
f0101192:	50                   	push   %eax
f0101193:	e8 f3 35 00 00       	call   f010478b <mc146818_read>
f0101198:	83 c4 10             	add    $0x10,%esp
f010119b:	89 c6                	mov    %eax,%esi
f010119d:	8b 45 08             	mov    0x8(%ebp),%eax
f01011a0:	83 c0 01             	add    $0x1,%eax
f01011a3:	83 ec 0c             	sub    $0xc,%esp
f01011a6:	50                   	push   %eax
f01011a7:	e8 df 35 00 00       	call   f010478b <mc146818_read>
f01011ac:	83 c4 10             	add    $0x10,%esp
f01011af:	c1 e0 08             	shl    $0x8,%eax
f01011b2:	09 f0                	or     %esi,%eax
}
f01011b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01011b7:	5b                   	pop    %ebx
f01011b8:	5e                   	pop    %esi
f01011b9:	5d                   	pop    %ebp
f01011ba:	c3                   	ret    

f01011bb <i386_detect_memory>:

static void
i386_detect_memory(void)
{
f01011bb:	f3 0f 1e fb          	endbr32 
f01011bf:	55                   	push   %ebp
f01011c0:	89 e5                	mov    %esp,%ebp
f01011c2:	53                   	push   %ebx
f01011c3:	83 ec 14             	sub    $0x14,%esp
f01011c6:	e8 e3 ef ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f01011cb:	81 c3 e9 07 09 00    	add    $0x907e9,%ebx
	size_t basemem, extmem, ext16mem, totalmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	basemem = nvram_read(NVRAM_BASELO);
f01011d1:	83 ec 0c             	sub    $0xc,%esp
f01011d4:	6a 15                	push   $0x15
f01011d6:	e8 9d ff ff ff       	call   f0101178 <nvram_read>
f01011db:	83 c4 10             	add    $0x10,%esp
f01011de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	extmem = nvram_read(NVRAM_EXTLO);
f01011e1:	83 ec 0c             	sub    $0xc,%esp
f01011e4:	6a 17                	push   $0x17
f01011e6:	e8 8d ff ff ff       	call   f0101178 <nvram_read>
f01011eb:	83 c4 10             	add    $0x10,%esp
f01011ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f01011f1:	83 ec 0c             	sub    $0xc,%esp
f01011f4:	6a 34                	push   $0x34
f01011f6:	e8 7d ff ff ff       	call   f0101178 <nvram_read>
f01011fb:	83 c4 10             	add    $0x10,%esp
f01011fe:	c1 e0 06             	shl    $0x6,%eax
f0101201:	89 45 e8             	mov    %eax,-0x18(%ebp)

	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (ext16mem)
f0101204:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0101208:	74 0d                	je     f0101217 <i386_detect_memory+0x5c>
		totalmem = 16 * 1024 + ext16mem;
f010120a:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010120d:	05 00 40 00 00       	add    $0x4000,%eax
f0101212:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101215:	eb 19                	jmp    f0101230 <i386_detect_memory+0x75>
	else if (extmem)
f0101217:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f010121b:	74 0d                	je     f010122a <i386_detect_memory+0x6f>
		totalmem = 1 * 1024 + extmem;
f010121d:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101220:	05 00 04 00 00       	add    $0x400,%eax
f0101225:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101228:	eb 06                	jmp    f0101230 <i386_detect_memory+0x75>
	else
		totalmem = basemem;
f010122a:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010122d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	npages = totalmem / (PGSIZE / 1024);
f0101230:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101233:	c1 e8 02             	shr    $0x2,%eax
f0101236:	89 c2                	mov    %eax,%edx
f0101238:	c7 c0 a8 3f 19 f0    	mov    $0xf0193fa8,%eax
f010123e:	89 10                	mov    %edx,(%eax)
	npages_basemem = basemem / (PGSIZE / 1024);
f0101240:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101243:	c1 e8 02             	shr    $0x2,%eax
f0101246:	89 83 38 19 00 00    	mov    %eax,0x1938(%ebx)

	// Modified: add unit-present to make it more cleare
	// cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
	// 	totalmem, basemem, totalmem - basemem);
	cprintf("Physical memory: %uKB available, base = %uKB, extended = %uKB\n",
f010124c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010124f:	2b 45 f0             	sub    -0x10(%ebp),%eax
f0101252:	50                   	push   %eax
f0101253:	ff 75 f0             	pushl  -0x10(%ebp)
f0101256:	ff 75 f4             	pushl  -0xc(%ebp)
f0101259:	8d 83 a8 5b f7 ff    	lea    -0x8a458(%ebx),%eax
f010125f:	50                   	push   %eax
f0101260:	e8 00 36 00 00       	call   f0104865 <cprintf>
f0101265:	83 c4 10             	add    $0x10,%esp
		totalmem, basemem, totalmem - basemem);
}
f0101268:	90                   	nop
f0101269:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010126c:	c9                   	leave  
f010126d:	c3                   	ret    

f010126e <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f010126e:	f3 0f 1e fb          	endbr32 
f0101272:	55                   	push   %ebp
f0101273:	89 e5                	mov    %esp,%ebp
f0101275:	53                   	push   %ebx
f0101276:	83 ec 24             	sub    $0x24,%esp
f0101279:	e8 30 ef ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f010127e:	81 c3 36 07 09 00    	add    $0x90736,%ebx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0101284:	8b 83 44 19 00 00    	mov    0x1944(%ebx),%eax
f010128a:	85 c0                	test   %eax,%eax
f010128c:	75 2e                	jne    f01012bc <boot_alloc+0x4e>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f010128e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
f0101295:	c7 c0 a0 3f 19 f0    	mov    $0xf0193fa0,%eax
f010129b:	8d 50 ff             	lea    -0x1(%eax),%edx
f010129e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01012a1:	01 d0                	add    %edx,%eax
f01012a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01012a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01012a9:	ba 00 00 00 00       	mov    $0x0,%edx
f01012ae:	f7 75 f4             	divl   -0xc(%ebp)
f01012b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01012b4:	29 d0                	sub    %edx,%eax
f01012b6:	89 83 44 19 00 00    	mov    %eax,0x1944(%ebx)
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = nextfree;
f01012bc:	8b 83 44 19 00 00    	mov    0x1944(%ebx),%eax
f01012c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(n > 0)
f01012c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f01012c9:	74 35                	je     f0101300 <boot_alloc+0x92>
		nextfree = ROUNDUP(nextfree + n, PGSIZE);
f01012cb:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
f01012d2:	8b 93 44 19 00 00    	mov    0x1944(%ebx),%edx
f01012d8:	8b 45 08             	mov    0x8(%ebp),%eax
f01012db:	01 d0                	add    %edx,%eax
f01012dd:	89 c2                	mov    %eax,%edx
f01012df:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01012e2:	01 d0                	add    %edx,%eax
f01012e4:	83 e8 01             	sub    $0x1,%eax
f01012e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01012ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01012ed:	ba 00 00 00 00       	mov    $0x0,%edx
f01012f2:	f7 75 e8             	divl   -0x18(%ebp)
f01012f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01012f8:	29 d0                	sub    %edx,%eax
f01012fa:	89 83 44 19 00 00    	mov    %eax,0x1944(%ebx)
	else if(n < 0)
		// n < 0: should not come here
		panic("boot_alloc: parameter n < 0.");
	
	// fix me: need to be explained
	if(PADDR(nextfree) >= 0x400000)
f0101300:	8b 83 44 19 00 00    	mov    0x1944(%ebx),%eax
f0101306:	83 ec 04             	sub    $0x4,%esp
f0101309:	50                   	push   %eax
f010130a:	6a 75                	push   $0x75
f010130c:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101312:	50                   	push   %eax
f0101313:	e8 25 fd ff ff       	call   f010103d <_paddr>
f0101318:	83 c4 10             	add    $0x10,%esp
f010131b:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
f0101320:	76 18                	jbe    f010133a <boot_alloc+0xcc>
		panic("boot_alloc: run out of mem.");
f0101322:	83 ec 04             	sub    $0x4,%esp
f0101325:	8d 83 f3 5b f7 ff    	lea    -0x8a40d(%ebx),%eax
f010132b:	50                   	push   %eax
f010132c:	6a 76                	push   $0x76
f010132e:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101334:	50                   	push   %eax
f0101335:	e8 93 ed ff ff       	call   f01000cd <_panic>

	return result;
f010133a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
f010133d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101340:	c9                   	leave  
f0101341:	c3                   	ret    

f0101342 <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0101342:	f3 0f 1e fb          	endbr32 
f0101346:	55                   	push   %ebp
f0101347:	89 e5                	mov    %esp,%ebp
f0101349:	53                   	push   %ebx
f010134a:	83 ec 14             	sub    $0x14,%esp
f010134d:	e8 5c ee ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0101352:	81 c3 62 06 09 00    	add    $0x90662,%ebx
	uint32_t cr0;
	size_t n;

	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();
f0101358:	e8 5e fe ff ff       	call   f01011bb <i386_detect_memory>
	// Remove this line when you're ready to test this function.
	// panic("mem_init: This function is not finished\n");

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f010135d:	83 ec 0c             	sub    $0xc,%esp
f0101360:	68 00 10 00 00       	push   $0x1000
f0101365:	e8 04 ff ff ff       	call   f010126e <boot_alloc>
f010136a:	83 c4 10             	add    $0x10,%esp
f010136d:	c7 c2 ac 3f 19 f0    	mov    $0xf0193fac,%edx
f0101373:	89 02                	mov    %eax,(%edx)
	memset(kern_pgdir, 0, PGSIZE);
f0101375:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f010137b:	8b 00                	mov    (%eax),%eax
f010137d:	83 ec 04             	sub    $0x4,%esp
f0101380:	68 00 10 00 00       	push   $0x1000
f0101385:	6a 00                	push   $0x0
f0101387:	50                   	push   %eax
f0101388:	e8 93 58 00 00       	call   f0106c20 <memset>
f010138d:	83 c4 10             	add    $0x10,%esp
	// a virtual page table at virtual address UVPT.
	// (For now, you don't have understand the greater purpose of the
	// following line.)

	// Permissions: kernel R, user R
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101390:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0101396:	8b 00                	mov    (%eax),%eax
f0101398:	83 ec 04             	sub    $0x4,%esp
f010139b:	50                   	push   %eax
f010139c:	68 9c 00 00 00       	push   $0x9c
f01013a1:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01013a7:	50                   	push   %eax
f01013a8:	e8 90 fc ff ff       	call   f010103d <_paddr>
f01013ad:	83 c4 10             	add    $0x10,%esp
f01013b0:	c7 c2 ac 3f 19 f0    	mov    $0xf0193fac,%edx
f01013b6:	8b 12                	mov    (%edx),%edx
f01013b8:	81 c2 f4 0e 00 00    	add    $0xef4,%edx
f01013be:	83 c8 05             	or     $0x5,%eax
f01013c1:	89 02                	mov    %eax,(%edx)
	// The kernel uses this array to keep track of physical pages: for
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
	pages = (struct PageInfo *) boot_alloc(npages * sizeof(struct PageInfo));
f01013c3:	c7 c0 a8 3f 19 f0    	mov    $0xf0193fa8,%eax
f01013c9:	8b 00                	mov    (%eax),%eax
f01013cb:	c1 e0 03             	shl    $0x3,%eax
f01013ce:	83 ec 0c             	sub    $0xc,%esp
f01013d1:	50                   	push   %eax
f01013d2:	e8 97 fe ff ff       	call   f010126e <boot_alloc>
f01013d7:	83 c4 10             	add    $0x10,%esp
f01013da:	c7 c2 b0 3f 19 f0    	mov    $0xf0193fb0,%edx
f01013e0:	89 02                	mov    %eax,(%edx)
	memset(pages, 0, npages * sizeof(struct PageInfo));
f01013e2:	c7 c0 a8 3f 19 f0    	mov    $0xf0193fa8,%eax
f01013e8:	8b 00                	mov    (%eax),%eax
f01013ea:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f01013f1:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f01013f7:	8b 00                	mov    (%eax),%eax
f01013f9:	83 ec 04             	sub    $0x4,%esp
f01013fc:	52                   	push   %edx
f01013fd:	6a 00                	push   $0x0
f01013ff:	50                   	push   %eax
f0101400:	e8 1b 58 00 00       	call   f0106c20 <memset>
f0101405:	83 c4 10             	add    $0x10,%esp

	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
	envs = (struct Env *) boot_alloc(NENV * sizeof(struct Env));
f0101408:	83 ec 0c             	sub    $0xc,%esp
f010140b:	68 00 80 01 00       	push   $0x18000
f0101410:	e8 59 fe ff ff       	call   f010126e <boot_alloc>
f0101415:	83 c4 10             	add    $0x10,%esp
f0101418:	c7 c2 fc 32 19 f0    	mov    $0xf01932fc,%edx
f010141e:	89 02                	mov    %eax,(%edx)
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
	page_init();
f0101420:	e8 6a 01 00 00       	call   f010158f <page_init>

	check_page_free_list(1);
f0101425:	83 ec 0c             	sub    $0xc,%esp
f0101428:	6a 01                	push   $0x1
f010142a:	e8 bc 07 00 00       	call   f0101beb <check_page_free_list>
f010142f:	83 c4 10             	add    $0x10,%esp
	check_page_alloc();
f0101432:	e8 4c 0b 00 00       	call   f0101f83 <check_page_alloc>
	check_page();
f0101437:	e8 33 15 00 00       	call   f010296f <check_page>
	// Permissions:
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f010143c:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f0101442:	8b 00                	mov    (%eax),%eax
f0101444:	83 ec 04             	sub    $0x4,%esp
f0101447:	50                   	push   %eax
f0101448:	68 c3 00 00 00       	push   $0xc3
f010144d:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101453:	50                   	push   %eax
f0101454:	e8 e4 fb ff ff       	call   f010103d <_paddr>
f0101459:	83 c4 10             	add    $0x10,%esp
f010145c:	c7 c2 ac 3f 19 f0    	mov    $0xf0193fac,%edx
f0101462:	8b 12                	mov    (%edx),%edx
f0101464:	83 ec 0c             	sub    $0xc,%esp
f0101467:	6a 04                	push   $0x4
f0101469:	50                   	push   %eax
f010146a:	68 00 00 40 00       	push   $0x400000
f010146f:	68 00 00 00 ef       	push   $0xef000000
f0101474:	52                   	push   %edx
f0101475:	e8 3f 04 00 00       	call   f01018b9 <boot_map_region>
f010147a:	83 c4 20             	add    $0x20,%esp
	// (ie. perm = PTE_U | PTE_P).
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f010147d:	c7 c0 fc 32 19 f0    	mov    $0xf01932fc,%eax
f0101483:	8b 00                	mov    (%eax),%eax
f0101485:	83 ec 04             	sub    $0x4,%esp
f0101488:	50                   	push   %eax
f0101489:	68 cc 00 00 00       	push   $0xcc
f010148e:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101494:	50                   	push   %eax
f0101495:	e8 a3 fb ff ff       	call   f010103d <_paddr>
f010149a:	83 c4 10             	add    $0x10,%esp
f010149d:	c7 c2 ac 3f 19 f0    	mov    $0xf0193fac,%edx
f01014a3:	8b 12                	mov    (%edx),%edx
f01014a5:	83 ec 0c             	sub    $0xc,%esp
f01014a8:	6a 04                	push   $0x4
f01014aa:	50                   	push   %eax
f01014ab:	68 00 00 40 00       	push   $0x400000
f01014b0:	68 00 00 c0 ee       	push   $0xeec00000
f01014b5:	52                   	push   %edx
f01014b6:	e8 fe 03 00 00       	call   f01018b9 <boot_map_region>
f01014bb:	83 c4 20             	add    $0x20,%esp
	//     * [KSTACKTOP-PTSIZE, KSTACKTOP-KSTKSIZE) -- not backed; so if
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
	boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstacktop)-KSTKSIZE, PTE_W);
f01014be:	83 ec 04             	sub    $0x4,%esp
f01014c1:	c7 c0 00 f0 11 f0    	mov    $0xf011f000,%eax
f01014c7:	50                   	push   %eax
f01014c8:	68 d9 00 00 00       	push   $0xd9
f01014cd:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01014d3:	50                   	push   %eax
f01014d4:	e8 64 fb ff ff       	call   f010103d <_paddr>
f01014d9:	83 c4 10             	add    $0x10,%esp
f01014dc:	8d 90 00 80 ff ff    	lea    -0x8000(%eax),%edx
f01014e2:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f01014e8:	8b 00                	mov    (%eax),%eax
f01014ea:	83 ec 0c             	sub    $0xc,%esp
f01014ed:	6a 02                	push   $0x2
f01014ef:	52                   	push   %edx
f01014f0:	68 00 80 00 00       	push   $0x8000
f01014f5:	68 00 80 ff ef       	push   $0xefff8000
f01014fa:	50                   	push   %eax
f01014fb:	e8 b9 03 00 00       	call   f01018b9 <boot_map_region>
f0101500:	83 c4 20             	add    $0x20,%esp
	//      the PA range [0, 2^32 - KERNBASE)
	// We might not have 2^32 - KERNBASE bytes of physical memory, but
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:
	boot_map_region(kern_pgdir, KERNBASE, (size_t)(0x40000000000 - KERNBASE), 0, PTE_W);
f0101503:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0101509:	8b 00                	mov    (%eax),%eax
f010150b:	83 ec 0c             	sub    $0xc,%esp
f010150e:	6a 02                	push   $0x2
f0101510:	6a 00                	push   $0x0
f0101512:	68 00 00 00 10       	push   $0x10000000
f0101517:	68 00 00 00 f0       	push   $0xf0000000
f010151c:	50                   	push   %eax
f010151d:	e8 97 03 00 00       	call   f01018b9 <boot_map_region>
f0101522:	83 c4 20             	add    $0x20,%esp

	// Check that the initial page directory has been set up correctly.
	check_kern_pgdir();
f0101525:	e8 f0 0f 00 00       	call   f010251a <check_kern_pgdir>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f010152a:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0101530:	8b 00                	mov    (%eax),%eax
f0101532:	83 ec 04             	sub    $0x4,%esp
f0101535:	50                   	push   %eax
f0101536:	68 ef 00 00 00       	push   $0xef
f010153b:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101541:	50                   	push   %eax
f0101542:	e8 f6 fa ff ff       	call   f010103d <_paddr>
f0101547:	83 c4 10             	add    $0x10,%esp
f010154a:	83 ec 0c             	sub    $0xc,%esp
f010154d:	50                   	push   %eax
f010154e:	e8 d4 fa ff ff       	call   f0101027 <lcr3>
f0101553:	83 c4 10             	add    $0x10,%esp

	check_page_free_list(0);
f0101556:	83 ec 0c             	sub    $0xc,%esp
f0101559:	6a 00                	push   $0x0
f010155b:	e8 8b 06 00 00       	call   f0101beb <check_page_free_list>
f0101560:	83 c4 10             	add    $0x10,%esp

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
f0101563:	e8 a4 fa ff ff       	call   f010100c <rcr0>
f0101568:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
f010156b:	81 4d f4 23 00 05 80 	orl    $0x80050023,-0xc(%ebp)
	cr0 &= ~(CR0_TS|CR0_EM);
f0101572:	83 65 f4 f3          	andl   $0xfffffff3,-0xc(%ebp)
	lcr0(cr0);
f0101576:	83 ec 0c             	sub    $0xc,%esp
f0101579:	ff 75 f4             	pushl  -0xc(%ebp)
f010157c:	e8 75 fa ff ff       	call   f0100ff6 <lcr0>
f0101581:	83 c4 10             	add    $0x10,%esp

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
f0101584:	e8 55 22 00 00       	call   f01037de <check_page_installed_pgdir>
}
f0101589:	90                   	nop
f010158a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010158d:	c9                   	leave  
f010158e:	c3                   	ret    

f010158f <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f010158f:	f3 0f 1e fb          	endbr32 
f0101593:	55                   	push   %ebp
f0101594:	89 e5                	mov    %esp,%ebp
f0101596:	53                   	push   %ebx
f0101597:	83 ec 14             	sub    $0x14,%esp
f010159a:	e8 0f ec ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f010159f:	81 c3 15 04 09 00    	add    $0x90415,%ebx
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	
	// 1) Mark physical page 0 as in use
	pages[0].pp_ref = 1;
f01015a5:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f01015ab:	8b 00                	mov    (%eax),%eax
f01015ad:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)

	// 2) Base-memory
	size_t i;
	for (i = 1; i < npages_basemem; i++) {
f01015b3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
f01015ba:	eb 48                	jmp    f0101604 <page_init+0x75>
		pages[i].pp_ref = 0;
f01015bc:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f01015c2:	8b 00                	mov    (%eax),%eax
f01015c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01015c7:	c1 e2 03             	shl    $0x3,%edx
f01015ca:	01 d0                	add    %edx,%eax
f01015cc:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
		pages[i].pp_link = page_free_list;
f01015d2:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f01015d8:	8b 00                	mov    (%eax),%eax
f01015da:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01015dd:	c1 e2 03             	shl    $0x3,%edx
f01015e0:	01 c2                	add    %eax,%edx
f01015e2:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f01015e8:	89 02                	mov    %eax,(%edx)
		page_free_list = &pages[i];
f01015ea:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f01015f0:	8b 00                	mov    (%eax),%eax
f01015f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01015f5:	c1 e2 03             	shl    $0x3,%edx
f01015f8:	01 d0                	add    %edx,%eax
f01015fa:	89 83 3c 19 00 00    	mov    %eax,0x193c(%ebx)
	for (i = 1; i < npages_basemem; i++) {
f0101600:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0101604:	8b 83 38 19 00 00    	mov    0x1938(%ebx),%eax
f010160a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
f010160d:	72 ad                	jb     f01015bc <page_init+0x2d>
	}

	// 3) IO hole + pages that have been used
	int hole_and_used = npages_basemem + ((EXTPHYSMEM - IOPHYSMEM) + PADDR(boot_alloc(0)))/PGSIZE;
f010160f:	83 ec 0c             	sub    $0xc,%esp
f0101612:	6a 00                	push   $0x0
f0101614:	e8 55 fc ff ff       	call   f010126e <boot_alloc>
f0101619:	83 c4 10             	add    $0x10,%esp
f010161c:	83 ec 04             	sub    $0x4,%esp
f010161f:	50                   	push   %eax
f0101620:	68 2b 01 00 00       	push   $0x12b
f0101625:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010162b:	50                   	push   %eax
f010162c:	e8 0c fa ff ff       	call   f010103d <_paddr>
f0101631:	83 c4 10             	add    $0x10,%esp
f0101634:	05 00 00 06 00       	add    $0x60000,%eax
f0101639:	c1 e8 0c             	shr    $0xc,%eax
f010163c:	89 c2                	mov    %eax,%edx
f010163e:	8b 83 38 19 00 00    	mov    0x1938(%ebx),%eax
f0101644:	01 d0                	add    %edx,%eax
f0101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for(; i < hole_and_used; i++)
f0101649:	eb 1a                	jmp    f0101665 <page_init+0xd6>
		pages[i].pp_ref = 1;
f010164b:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f0101651:	8b 00                	mov    (%eax),%eax
f0101653:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0101656:	c1 e2 03             	shl    $0x3,%edx
f0101659:	01 d0                	add    %edx,%eax
f010165b:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	for(; i < hole_and_used; i++)
f0101661:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0101665:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101668:	39 45 f4             	cmp    %eax,-0xc(%ebp)
f010166b:	72 de                	jb     f010164b <page_init+0xbc>

	// 4) extended memory
	for(; i < npages; i++)
f010166d:	eb 48                	jmp    f01016b7 <page_init+0x128>
	{
		pages[i].pp_ref = 0;
f010166f:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f0101675:	8b 00                	mov    (%eax),%eax
f0101677:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010167a:	c1 e2 03             	shl    $0x3,%edx
f010167d:	01 d0                	add    %edx,%eax
f010167f:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
		pages[i].pp_link = page_free_list;
f0101685:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f010168b:	8b 00                	mov    (%eax),%eax
f010168d:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0101690:	c1 e2 03             	shl    $0x3,%edx
f0101693:	01 c2                	add    %eax,%edx
f0101695:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f010169b:	89 02                	mov    %eax,(%edx)
		page_free_list = &pages[i];
f010169d:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f01016a3:	8b 00                	mov    (%eax),%eax
f01016a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01016a8:	c1 e2 03             	shl    $0x3,%edx
f01016ab:	01 d0                	add    %edx,%eax
f01016ad:	89 83 3c 19 00 00    	mov    %eax,0x193c(%ebx)
	for(; i < npages; i++)
f01016b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f01016b7:	c7 c0 a8 3f 19 f0    	mov    $0xf0193fa8,%eax
f01016bd:	8b 00                	mov    (%eax),%eax
f01016bf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
f01016c2:	72 ab                	jb     f010166f <page_init+0xe0>
	}

}
f01016c4:	90                   	nop
f01016c5:	90                   	nop
f01016c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01016c9:	c9                   	leave  
f01016ca:	c3                   	ret    

f01016cb <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f01016cb:	f3 0f 1e fb          	endbr32 
f01016cf:	55                   	push   %ebp
f01016d0:	89 e5                	mov    %esp,%ebp
f01016d2:	53                   	push   %ebx
f01016d3:	83 ec 14             	sub    $0x14,%esp
f01016d6:	e8 d3 ea ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f01016db:	81 c3 d9 02 09 00    	add    $0x902d9,%ebx
	// Fill this function in
	if(!page_free_list)
f01016e1:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f01016e7:	85 c0                	test   %eax,%eax
f01016e9:	75 07                	jne    f01016f2 <page_alloc+0x27>
		return NULL;
f01016eb:	b8 00 00 00 00       	mov    $0x0,%eax
f01016f0:	eb 4e                	jmp    f0101740 <page_alloc+0x75>

	struct PageInfo *alloc_page = page_free_list;
f01016f2:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f01016f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	page_free_list = page_free_list->pp_link;
f01016fb:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f0101701:	8b 00                	mov    (%eax),%eax
f0101703:	89 83 3c 19 00 00    	mov    %eax,0x193c(%ebx)
	alloc_page->pp_link = NULL;
f0101709:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010170c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	if(alloc_flags & ALLOC_ZERO)
f0101712:	8b 45 08             	mov    0x8(%ebp),%eax
f0101715:	83 e0 01             	and    $0x1,%eax
f0101718:	85 c0                	test   %eax,%eax
f010171a:	74 21                	je     f010173d <page_alloc+0x72>
		memset(page2kva(alloc_page), 0, PGSIZE);
f010171c:	83 ec 0c             	sub    $0xc,%esp
f010171f:	ff 75 f4             	pushl  -0xc(%ebp)
f0101722:	e8 1a fa ff ff       	call   f0101141 <page2kva>
f0101727:	83 c4 10             	add    $0x10,%esp
f010172a:	83 ec 04             	sub    $0x4,%esp
f010172d:	68 00 10 00 00       	push   $0x1000
f0101732:	6a 00                	push   $0x0
f0101734:	50                   	push   %eax
f0101735:	e8 e6 54 00 00       	call   f0106c20 <memset>
f010173a:	83 c4 10             	add    $0x10,%esp

	return alloc_page;
f010173d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0101740:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101743:	c9                   	leave  
f0101744:	c3                   	ret    

f0101745 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f0101745:	f3 0f 1e fb          	endbr32 
f0101749:	55                   	push   %ebp
f010174a:	89 e5                	mov    %esp,%ebp
f010174c:	53                   	push   %ebx
f010174d:	83 ec 04             	sub    $0x4,%esp
f0101750:	e8 aa f3 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0101755:	05 5f 02 09 00       	add    $0x9025f,%eax
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
	if(pp->pp_ref != 0 || pp->pp_link != NULL)
f010175a:	8b 55 08             	mov    0x8(%ebp),%edx
f010175d:	0f b7 52 04          	movzwl 0x4(%edx),%edx
f0101761:	66 85 d2             	test   %dx,%dx
f0101764:	75 09                	jne    f010176f <page_free+0x2a>
f0101766:	8b 55 08             	mov    0x8(%ebp),%edx
f0101769:	8b 12                	mov    (%edx),%edx
f010176b:	85 d2                	test   %edx,%edx
f010176d:	74 1d                	je     f010178c <page_free+0x47>
		panic("page_free: pp_ref != 0");
f010176f:	83 ec 04             	sub    $0x4,%esp
f0101772:	8d 90 0f 5c f7 ff    	lea    -0x8a3f1(%eax),%edx
f0101778:	52                   	push   %edx
f0101779:	68 61 01 00 00       	push   $0x161
f010177e:	8d 90 e7 5b f7 ff    	lea    -0x8a419(%eax),%edx
f0101784:	52                   	push   %edx
f0101785:	89 c3                	mov    %eax,%ebx
f0101787:	e8 41 e9 ff ff       	call   f01000cd <_panic>
	
	pp->pp_link = page_free_list;
f010178c:	8b 88 3c 19 00 00    	mov    0x193c(%eax),%ecx
f0101792:	8b 55 08             	mov    0x8(%ebp),%edx
f0101795:	89 0a                	mov    %ecx,(%edx)
	page_free_list = pp;
f0101797:	8b 55 08             	mov    0x8(%ebp),%edx
f010179a:	89 90 3c 19 00 00    	mov    %edx,0x193c(%eax)

}
f01017a0:	90                   	nop
f01017a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01017a4:	c9                   	leave  
f01017a5:	c3                   	ret    

f01017a6 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f01017a6:	f3 0f 1e fb          	endbr32 
f01017aa:	55                   	push   %ebp
f01017ab:	89 e5                	mov    %esp,%ebp
f01017ad:	83 ec 08             	sub    $0x8,%esp
f01017b0:	e8 4a f3 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01017b5:	05 ff 01 09 00       	add    $0x901ff,%eax
	if (--pp->pp_ref == 0)
f01017ba:	8b 45 08             	mov    0x8(%ebp),%eax
f01017bd:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f01017c1:	8d 50 ff             	lea    -0x1(%eax),%edx
f01017c4:	8b 45 08             	mov    0x8(%ebp),%eax
f01017c7:	66 89 50 04          	mov    %dx,0x4(%eax)
f01017cb:	8b 45 08             	mov    0x8(%ebp),%eax
f01017ce:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f01017d2:	66 85 c0             	test   %ax,%ax
f01017d5:	75 0e                	jne    f01017e5 <page_decref+0x3f>
		page_free(pp);
f01017d7:	83 ec 0c             	sub    $0xc,%esp
f01017da:	ff 75 08             	pushl  0x8(%ebp)
f01017dd:	e8 63 ff ff ff       	call   f0101745 <page_free>
f01017e2:	83 c4 10             	add    $0x10,%esp
}
f01017e5:	90                   	nop
f01017e6:	c9                   	leave  
f01017e7:	c3                   	ret    

f01017e8 <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that manipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f01017e8:	f3 0f 1e fb          	endbr32 
f01017ec:	55                   	push   %ebp
f01017ed:	89 e5                	mov    %esp,%ebp
f01017ef:	53                   	push   %ebx
f01017f0:	83 ec 14             	sub    $0x14,%esp
f01017f3:	e8 b6 e9 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f01017f8:	81 c3 bc 01 09 00    	add    $0x901bc,%ebx
	// ppde/ppte: point-to-pde/pte
	pde_t *ppde = pgdir + PDX(va); // pde is the VA of pgdir[PDX(va)]
f01017fe:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101801:	c1 e8 16             	shr    $0x16,%eax
f0101804:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f010180b:	8b 45 08             	mov    0x8(%ebp),%eax
f010180e:	01 d0                	add    %edx,%eax
f0101810:	89 45 f4             	mov    %eax,-0xc(%ebp)
	pte_t *ppte = NULL;			  // default result: NULL
f0101813:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	if(!(*ppde & PTE_P))
f010181a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010181d:	8b 00                	mov    (%eax),%eax
f010181f:	83 e0 01             	and    $0x1,%eax
f0101822:	85 c0                	test   %eax,%eax
f0101824:	75 55                	jne    f010187b <pgdir_walk+0x93>
	{
		if(create)
f0101826:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010182a:	74 48                	je     f0101874 <pgdir_walk+0x8c>
		{
			struct PageInfo *new_pt = page_alloc(ALLOC_ZERO);
f010182c:	83 ec 0c             	sub    $0xc,%esp
f010182f:	6a 01                	push   $0x1
f0101831:	e8 95 fe ff ff       	call   f01016cb <page_alloc>
f0101836:	83 c4 10             	add    $0x10,%esp
f0101839:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(!new_pt)
f010183c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f0101840:	75 07                	jne    f0101849 <pgdir_walk+0x61>
				// alloc failed
				return NULL;
f0101842:	b8 00 00 00 00       	mov    $0x0,%eax
f0101847:	eb 6b                	jmp    f01018b4 <pgdir_walk+0xcc>
			(new_pt->pp_ref)++;
f0101849:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010184c:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0101850:	8d 50 01             	lea    0x1(%eax),%edx
f0101853:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101856:	66 89 50 04          	mov    %dx,0x4(%eax)
			*ppde = (page2pa(new_pt) | PTE_P | PTE_W | PTE_U);
f010185a:	83 ec 0c             	sub    $0xc,%esp
f010185d:	ff 75 ec             	pushl  -0x14(%ebp)
f0101860:	e8 61 f8 ff ff       	call   f01010c6 <page2pa>
f0101865:	83 c4 10             	add    $0x10,%esp
f0101868:	83 c8 07             	or     $0x7,%eax
f010186b:	89 c2                	mov    %eax,%edx
f010186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101870:	89 10                	mov    %edx,(%eax)
f0101872:	eb 07                	jmp    f010187b <pgdir_walk+0x93>
		}
		else
			return NULL;
f0101874:	b8 00 00 00 00       	mov    $0x0,%eax
f0101879:	eb 39                	jmp    f01018b4 <pgdir_walk+0xcc>
	}

	// Don't forget the (pte_t*) cast
	ppte = (pte_t*)KADDR(PTE_ADDR(*ppde)) + PTX(va);	// key: the use of KADDR
f010187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010187e:	8b 00                	mov    (%eax),%eax
f0101880:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101885:	83 ec 04             	sub    $0x4,%esp
f0101888:	50                   	push   %eax
f0101889:	68 9f 01 00 00       	push   $0x19f
f010188e:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101894:	50                   	push   %eax
f0101895:	e8 e3 f7 ff ff       	call   f010107d <_kaddr>
f010189a:	83 c4 10             	add    $0x10,%esp
f010189d:	8b 55 0c             	mov    0xc(%ebp),%edx
f01018a0:	c1 ea 0c             	shr    $0xc,%edx
f01018a3:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f01018a9:	c1 e2 02             	shl    $0x2,%edx
f01018ac:	01 d0                	add    %edx,%eax
f01018ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return ppte;
f01018b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
f01018b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01018b7:	c9                   	leave  
f01018b8:	c3                   	ret    

f01018b9 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
f01018b9:	f3 0f 1e fb          	endbr32 
f01018bd:	55                   	push   %ebp
f01018be:	89 e5                	mov    %esp,%ebp
f01018c0:	53                   	push   %ebx
f01018c1:	83 ec 14             	sub    $0x14,%esp
f01018c4:	e8 e5 e8 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f01018c9:	81 c3 eb 00 09 00    	add    $0x900eb,%ebx
	if((size % PGSIZE))
f01018cf:	8b 45 10             	mov    0x10(%ebp),%eax
f01018d2:	25 ff 0f 00 00       	and    $0xfff,%eax
f01018d7:	85 c0                	test   %eax,%eax
f01018d9:	74 33                	je     f010190e <boot_map_region+0x55>
	{
		cprintf("HERE:%#x, SIZE:%#x\n", va, size);
f01018db:	83 ec 04             	sub    $0x4,%esp
f01018de:	ff 75 10             	pushl  0x10(%ebp)
f01018e1:	ff 75 0c             	pushl  0xc(%ebp)
f01018e4:	8d 83 26 5c f7 ff    	lea    -0x8a3da(%ebx),%eax
f01018ea:	50                   	push   %eax
f01018eb:	e8 75 2f 00 00       	call   f0104865 <cprintf>
f01018f0:	83 c4 10             	add    $0x10,%esp
		panic("boot_map_region: size is not a multiple of PGSIZE.");
f01018f3:	83 ec 04             	sub    $0x4,%esp
f01018f6:	8d 83 3c 5c f7 ff    	lea    -0x8a3c4(%ebx),%eax
f01018fc:	50                   	push   %eax
f01018fd:	68 b4 01 00 00       	push   $0x1b4
f0101902:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101908:	50                   	push   %eax
f0101909:	e8 bf e7 ff ff       	call   f01000cd <_panic>
	}

	for(int sz = 0; sz < size; sz += PGSIZE)
f010190e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0101915:	eb 3a                	jmp    f0101951 <boot_map_region+0x98>
	{
		pte_t *pte = pgdir_walk(pgdir, (void *)(va + sz), 1);
f0101917:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010191a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010191d:	01 d0                	add    %edx,%eax
f010191f:	83 ec 04             	sub    $0x4,%esp
f0101922:	6a 01                	push   $0x1
f0101924:	50                   	push   %eax
f0101925:	ff 75 08             	pushl  0x8(%ebp)
f0101928:	e8 bb fe ff ff       	call   f01017e8 <pgdir_walk>
f010192d:	83 c4 10             	add    $0x10,%esp
f0101930:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*pte = (pa + sz) | perm | PTE_P;
f0101933:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0101936:	8b 45 14             	mov    0x14(%ebp),%eax
f0101939:	01 c2                	add    %eax,%edx
f010193b:	8b 45 18             	mov    0x18(%ebp),%eax
f010193e:	09 d0                	or     %edx,%eax
f0101940:	83 c8 01             	or     $0x1,%eax
f0101943:	89 c2                	mov    %eax,%edx
f0101945:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101948:	89 10                	mov    %edx,(%eax)
	for(int sz = 0; sz < size; sz += PGSIZE)
f010194a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f0101951:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101954:	39 45 10             	cmp    %eax,0x10(%ebp)
f0101957:	77 be                	ja     f0101917 <boot_map_region+0x5e>
	}

}
f0101959:	90                   	nop
f010195a:	90                   	nop
f010195b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010195e:	c9                   	leave  
f010195f:	c3                   	ret    

f0101960 <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f0101960:	f3 0f 1e fb          	endbr32 
f0101964:	55                   	push   %ebp
f0101965:	89 e5                	mov    %esp,%ebp
f0101967:	83 ec 18             	sub    $0x18,%esp
f010196a:	e8 90 f1 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f010196f:	05 45 00 09 00       	add    $0x90045,%eax
	pte_t *ppte = pgdir_walk(pgdir, va, 1);
f0101974:	83 ec 04             	sub    $0x4,%esp
f0101977:	6a 01                	push   $0x1
f0101979:	ff 75 10             	pushl  0x10(%ebp)
f010197c:	ff 75 08             	pushl  0x8(%ebp)
f010197f:	e8 64 fe ff ff       	call   f01017e8 <pgdir_walk>
f0101984:	83 c4 10             	add    $0x10,%esp
f0101987:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(!ppte)
f010198a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f010198e:	75 07                	jne    f0101997 <page_insert+0x37>
		return -E_NO_MEM;
f0101990:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101995:	eb 44                	jmp    f01019db <page_insert+0x7b>
	// Consider the corner-case
	pp->pp_ref++;
f0101997:	8b 45 0c             	mov    0xc(%ebp),%eax
f010199a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f010199e:	8d 50 01             	lea    0x1(%eax),%edx
f01019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01019a4:	66 89 50 04          	mov    %dx,0x4(%eax)
	page_remove(pgdir, va);	// If page-map exists, remove it
f01019a8:	83 ec 08             	sub    $0x8,%esp
f01019ab:	ff 75 10             	pushl  0x10(%ebp)
f01019ae:	ff 75 08             	pushl  0x8(%ebp)
f01019b1:	e8 97 00 00 00       	call   f0101a4d <page_remove>
f01019b6:	83 c4 10             	add    $0x10,%esp
	*ppte = page2pa(pp) | perm | PTE_P;
f01019b9:	83 ec 0c             	sub    $0xc,%esp
f01019bc:	ff 75 0c             	pushl  0xc(%ebp)
f01019bf:	e8 02 f7 ff ff       	call   f01010c6 <page2pa>
f01019c4:	83 c4 10             	add    $0x10,%esp
f01019c7:	8b 55 14             	mov    0x14(%ebp),%edx
f01019ca:	09 d0                	or     %edx,%eax
f01019cc:	83 c8 01             	or     $0x1,%eax
f01019cf:	89 c2                	mov    %eax,%edx
f01019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01019d4:	89 10                	mov    %edx,(%eax)
	return 0;
f01019d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01019db:	c9                   	leave  
f01019dc:	c3                   	ret    

f01019dd <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f01019dd:	f3 0f 1e fb          	endbr32 
f01019e1:	55                   	push   %ebp
f01019e2:	89 e5                	mov    %esp,%ebp
f01019e4:	83 ec 18             	sub    $0x18,%esp
f01019e7:	e8 13 f1 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01019ec:	05 c8 ff 08 00       	add    $0x8ffc8,%eax
	// ppte: point-to-pte
	pte_t *ppte = pgdir_walk(pgdir, va, 0);
f01019f1:	83 ec 04             	sub    $0x4,%esp
f01019f4:	6a 00                	push   $0x0
f01019f6:	ff 75 0c             	pushl  0xc(%ebp)
f01019f9:	ff 75 08             	pushl  0x8(%ebp)
f01019fc:	e8 e7 fd ff ff       	call   f01017e8 <pgdir_walk>
f0101a01:	83 c4 10             	add    $0x10,%esp
f0101a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(!ppte)
f0101a07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0101a0b:	75 07                	jne    f0101a14 <page_lookup+0x37>
		return NULL;
f0101a0d:	b8 00 00 00 00       	mov    $0x0,%eax
f0101a12:	eb 37                	jmp    f0101a4b <page_lookup+0x6e>

	if(!(*ppte & PTE_P))
f0101a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101a17:	8b 00                	mov    (%eax),%eax
f0101a19:	83 e0 01             	and    $0x1,%eax
f0101a1c:	85 c0                	test   %eax,%eax
f0101a1e:	75 07                	jne    f0101a27 <page_lookup+0x4a>
		return NULL;
f0101a20:	b8 00 00 00 00       	mov    $0x0,%eax
f0101a25:	eb 24                	jmp    f0101a4b <page_lookup+0x6e>

	if(pte_store != NULL)
f0101a27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101a2b:	74 08                	je     f0101a35 <page_lookup+0x58>
		*pte_store = ppte;
f0101a2d:	8b 45 10             	mov    0x10(%ebp),%eax
f0101a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0101a33:	89 10                	mov    %edx,(%eax)

	return pa2page(PTE_ADDR(*ppte));
f0101a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101a38:	8b 00                	mov    (%eax),%eax
f0101a3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101a3f:	83 ec 0c             	sub    $0xc,%esp
f0101a42:	50                   	push   %eax
f0101a43:	e8 a2 f6 ff ff       	call   f01010ea <pa2page>
f0101a48:	83 c4 10             	add    $0x10,%esp
}
f0101a4b:	c9                   	leave  
f0101a4c:	c3                   	ret    

f0101a4d <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f0101a4d:	f3 0f 1e fb          	endbr32 
f0101a51:	55                   	push   %ebp
f0101a52:	89 e5                	mov    %esp,%ebp
f0101a54:	83 ec 18             	sub    $0x18,%esp
f0101a57:	e8 a3 f0 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0101a5c:	05 58 ff 08 00       	add    $0x8ff58,%eax
	pte_t *ppte;
	struct PageInfo* unmap_pg = page_lookup(pgdir, va, &ppte);
f0101a61:	83 ec 04             	sub    $0x4,%esp
f0101a64:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0101a67:	50                   	push   %eax
f0101a68:	ff 75 0c             	pushl  0xc(%ebp)
f0101a6b:	ff 75 08             	pushl  0x8(%ebp)
f0101a6e:	e8 6a ff ff ff       	call   f01019dd <page_lookup>
f0101a73:	83 c4 10             	add    $0x10,%esp
f0101a76:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// such physic-page exist
	if(unmap_pg)
f0101a79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0101a7d:	74 28                	je     f0101aa7 <page_remove+0x5a>
	{
		*ppte = 0;
f0101a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101a82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		page_decref(unmap_pg);
f0101a88:	83 ec 0c             	sub    $0xc,%esp
f0101a8b:	ff 75 f4             	pushl  -0xc(%ebp)
f0101a8e:	e8 13 fd ff ff       	call   f01017a6 <page_decref>
f0101a93:	83 c4 10             	add    $0x10,%esp
		tlb_invalidate(pgdir, va);
f0101a96:	83 ec 08             	sub    $0x8,%esp
f0101a99:	ff 75 0c             	pushl  0xc(%ebp)
f0101a9c:	ff 75 08             	pushl  0x8(%ebp)
f0101a9f:	e8 06 00 00 00       	call   f0101aaa <tlb_invalidate>
f0101aa4:	83 c4 10             	add    $0x10,%esp
	}
}
f0101aa7:	90                   	nop
f0101aa8:	c9                   	leave  
f0101aa9:	c3                   	ret    

f0101aaa <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0101aaa:	f3 0f 1e fb          	endbr32 
f0101aae:	55                   	push   %ebp
f0101aaf:	89 e5                	mov    %esp,%ebp
f0101ab1:	e8 49 f0 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0101ab6:	05 fe fe 08 00       	add    $0x8fefe,%eax
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
f0101abb:	ff 75 0c             	pushl  0xc(%ebp)
f0101abe:	e8 1d f5 ff ff       	call   f0100fe0 <invlpg>
f0101ac3:	83 c4 04             	add    $0x4,%esp
}
f0101ac6:	90                   	nop
f0101ac7:	c9                   	leave  
f0101ac8:	c3                   	ret    

f0101ac9 <user_mem_check>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f0101ac9:	f3 0f 1e fb          	endbr32 
f0101acd:	55                   	push   %ebp
f0101ace:	89 e5                	mov    %esp,%ebp
f0101ad0:	53                   	push   %ebx
f0101ad1:	83 ec 24             	sub    $0x24,%esp
f0101ad4:	e8 d5 e6 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0101ad9:	81 c3 db fe 08 00    	add    $0x8fedb,%ebx
	// LAB 3: Your code here.
	uintptr_t va_start = (uintptr_t)ROUNDDOWN(va, PGSIZE);		// first-page
f0101adf:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101ae8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101aed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uintptr_t va_end = (uintptr_t)ROUNDDOWN(va+len, PGSIZE);	// last-page
f0101af0:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101af3:	8b 45 10             	mov    0x10(%ebp),%eax
f0101af6:	01 d0                	add    %edx,%eax
f0101af8:	89 45 e8             	mov    %eax,-0x18(%ebp)
f0101afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101afe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101b03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for(uintptr_t pva = va_start; pva <= va_end; pva += PGSIZE)
f0101b06:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101b0c:	eb 65                	jmp    f0101b73 <user_mem_check+0xaa>
	{
		pte_t *ppte;
		// struct PageInfo *ppage;
		// ppage = page_lookup(env->env_pgdir, (void *)pva, &ppte);
		ppte = pgdir_walk(env->env_pgdir, (void *)pva, 0);
f0101b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0101b11:	8b 45 08             	mov    0x8(%ebp),%eax
f0101b14:	8b 40 5c             	mov    0x5c(%eax),%eax
f0101b17:	83 ec 04             	sub    $0x4,%esp
f0101b1a:	6a 00                	push   $0x0
f0101b1c:	52                   	push   %edx
f0101b1d:	50                   	push   %eax
f0101b1e:	e8 c5 fc ff ff       	call   f01017e8 <pgdir_walk>
f0101b23:	83 c4 10             	add    $0x10,%esp
f0101b26:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(!ppte || pva > ULIM || ((*ppte & perm) != perm))
f0101b29:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0101b2d:	74 1a                	je     f0101b49 <user_mem_check+0x80>
f0101b2f:	81 7d f4 00 00 80 ef 	cmpl   $0xef800000,-0xc(%ebp)
f0101b36:	77 11                	ja     f0101b49 <user_mem_check+0x80>
f0101b38:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101b3b:	8b 10                	mov    (%eax),%edx
f0101b3d:	8b 45 14             	mov    0x14(%ebp),%eax
f0101b40:	21 c2                	and    %eax,%edx
f0101b42:	8b 45 14             	mov    0x14(%ebp),%eax
f0101b45:	39 c2                	cmp    %eax,%edx
f0101b47:	74 23                	je     f0101b6c <user_mem_check+0xa3>
		{
			if(pva < (uintptr_t)va)
f0101b49:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101b4c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
f0101b4f:	73 0b                	jae    f0101b5c <user_mem_check+0x93>
				user_mem_check_addr = (uintptr_t)va;
f0101b51:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101b54:	89 83 40 19 00 00    	mov    %eax,0x1940(%ebx)
f0101b5a:	eb 09                	jmp    f0101b65 <user_mem_check+0x9c>
			else
				user_mem_check_addr = pva;
f0101b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101b5f:	89 83 40 19 00 00    	mov    %eax,0x1940(%ebx)
			return -E_FAULT;
f0101b65:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0101b6a:	eb 14                	jmp    f0101b80 <user_mem_check+0xb7>
	for(uintptr_t pva = va_start; pva <= va_end; pva += PGSIZE)
f0101b6c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f0101b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101b76:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f0101b79:	76 93                	jbe    f0101b0e <user_mem_check+0x45>
		}

	}

	return 0;
f0101b7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101b80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101b83:	c9                   	leave  
f0101b84:	c3                   	ret    

f0101b85 <user_mem_assert>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f0101b85:	f3 0f 1e fb          	endbr32 
f0101b89:	55                   	push   %ebp
f0101b8a:	89 e5                	mov    %esp,%ebp
f0101b8c:	53                   	push   %ebx
f0101b8d:	83 ec 04             	sub    $0x4,%esp
f0101b90:	e8 19 e6 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0101b95:	81 c3 1f fe 08 00    	add    $0x8fe1f,%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0101b9b:	8b 45 14             	mov    0x14(%ebp),%eax
f0101b9e:	83 c8 04             	or     $0x4,%eax
f0101ba1:	50                   	push   %eax
f0101ba2:	ff 75 10             	pushl  0x10(%ebp)
f0101ba5:	ff 75 0c             	pushl  0xc(%ebp)
f0101ba8:	ff 75 08             	pushl  0x8(%ebp)
f0101bab:	e8 19 ff ff ff       	call   f0101ac9 <user_mem_check>
f0101bb0:	83 c4 10             	add    $0x10,%esp
f0101bb3:	85 c0                	test   %eax,%eax
f0101bb5:	79 2e                	jns    f0101be5 <user_mem_assert+0x60>
		cprintf("[%08x] user_mem_check assertion failure for "
f0101bb7:	8b 93 40 19 00 00    	mov    0x1940(%ebx),%edx
f0101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
f0101bc0:	8b 40 48             	mov    0x48(%eax),%eax
f0101bc3:	83 ec 04             	sub    $0x4,%esp
f0101bc6:	52                   	push   %edx
f0101bc7:	50                   	push   %eax
f0101bc8:	8d 83 70 5c f7 ff    	lea    -0x8a390(%ebx),%eax
f0101bce:	50                   	push   %eax
f0101bcf:	e8 91 2c 00 00       	call   f0104865 <cprintf>
f0101bd4:	83 c4 10             	add    $0x10,%esp
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f0101bd7:	83 ec 0c             	sub    $0xc,%esp
f0101bda:	ff 75 08             	pushl  0x8(%ebp)
f0101bdd:	e8 48 2a 00 00       	call   f010462a <env_destroy>
f0101be2:	83 c4 10             	add    $0x10,%esp
	}
}
f0101be5:	90                   	nop
f0101be6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101be9:	c9                   	leave  
f0101bea:	c3                   	ret    

f0101beb <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f0101beb:	f3 0f 1e fb          	endbr32 
f0101bef:	55                   	push   %ebp
f0101bf0:	89 e5                	mov    %esp,%ebp
f0101bf2:	53                   	push   %ebx
f0101bf3:	83 ec 44             	sub    $0x44,%esp
f0101bf6:	e8 b3 e5 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0101bfb:	81 c3 b9 fd 08 00    	add    $0x8fdb9,%ebx
f0101c01:	8b 45 08             	mov    0x8(%ebp),%eax
f0101c04:	88 45 c4             	mov    %al,-0x3c(%ebp)
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101c07:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0101c0b:	74 07                	je     f0101c14 <check_page_free_list+0x29>
f0101c0d:	b8 01 00 00 00       	mov    $0x1,%eax
f0101c12:	eb 05                	jmp    f0101c19 <check_page_free_list+0x2e>
f0101c14:	b8 00 04 00 00       	mov    $0x400,%eax
f0101c19:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int nfree_basemem = 0, nfree_extmem = 0;
f0101c1c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101c23:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	char *first_free_page;

	if (!page_free_list)
f0101c2a:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f0101c30:	85 c0                	test   %eax,%eax
f0101c32:	75 1b                	jne    f0101c4f <check_page_free_list+0x64>
		panic("'page_free_list' is a null pointer!");
f0101c34:	83 ec 04             	sub    $0x4,%esp
f0101c37:	8d 83 a8 5c f7 ff    	lea    -0x8a358(%ebx),%eax
f0101c3d:	50                   	push   %eax
f0101c3e:	68 7b 02 00 00       	push   $0x27b
f0101c43:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101c49:	50                   	push   %eax
f0101c4a:	e8 7e e4 ff ff       	call   f01000cd <_panic>

	if (only_low_memory) {
f0101c4f:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0101c53:	74 77                	je     f0101ccc <check_page_free_list+0xe1>
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0101c55:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0101c58:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101c5b:	8d 45 d8             	lea    -0x28(%ebp),%eax
f0101c5e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101c61:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f0101c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101c6a:	eb 40                	jmp    f0101cac <check_page_free_list+0xc1>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0101c6c:	83 ec 0c             	sub    $0xc,%esp
f0101c6f:	ff 75 f4             	pushl  -0xc(%ebp)
f0101c72:	e8 4f f4 ff ff       	call   f01010c6 <page2pa>
f0101c77:	83 c4 10             	add    $0x10,%esp
f0101c7a:	c1 e8 16             	shr    $0x16,%eax
f0101c7d:	25 ff 03 00 00       	and    $0x3ff,%eax
f0101c82:	39 45 e8             	cmp    %eax,-0x18(%ebp)
f0101c85:	0f 96 c0             	setbe  %al
f0101c88:	0f b6 c0             	movzbl %al,%eax
f0101c8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			*tp[pagetype] = pp;
f0101c8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101c91:	8b 44 85 d0          	mov    -0x30(%ebp,%eax,4),%eax
f0101c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0101c98:	89 10                	mov    %edx,(%eax)
			tp[pagetype] = &pp->pp_link;
f0101c9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0101c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101ca0:	89 54 85 d0          	mov    %edx,-0x30(%ebp,%eax,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101ca7:	8b 00                	mov    (%eax),%eax
f0101ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101cac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0101cb0:	75 ba                	jne    f0101c6c <check_page_free_list+0x81>
		}
		*tp[1] = 0;
f0101cb2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101cb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0101cbb:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101cbe:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0101cc1:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0101cc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101cc6:	89 83 3c 19 00 00    	mov    %eax,0x193c(%ebx)
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101ccc:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f0101cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101cd5:	eb 47                	jmp    f0101d1e <check_page_free_list+0x133>
		if (PDX(page2pa(pp)) < pdx_limit)
f0101cd7:	83 ec 0c             	sub    $0xc,%esp
f0101cda:	ff 75 f4             	pushl  -0xc(%ebp)
f0101cdd:	e8 e4 f3 ff ff       	call   f01010c6 <page2pa>
f0101ce2:	83 c4 10             	add    $0x10,%esp
f0101ce5:	c1 e8 16             	shr    $0x16,%eax
f0101ce8:	25 ff 03 00 00       	and    $0x3ff,%eax
f0101ced:	39 45 e8             	cmp    %eax,-0x18(%ebp)
f0101cf0:	76 24                	jbe    f0101d16 <check_page_free_list+0x12b>
			memset(page2kva(pp), 0x97, 128);
f0101cf2:	83 ec 0c             	sub    $0xc,%esp
f0101cf5:	ff 75 f4             	pushl  -0xc(%ebp)
f0101cf8:	e8 44 f4 ff ff       	call   f0101141 <page2kva>
f0101cfd:	83 c4 10             	add    $0x10,%esp
f0101d00:	83 ec 04             	sub    $0x4,%esp
f0101d03:	68 80 00 00 00       	push   $0x80
f0101d08:	68 97 00 00 00       	push   $0x97
f0101d0d:	50                   	push   %eax
f0101d0e:	e8 0d 4f 00 00       	call   f0106c20 <memset>
f0101d13:	83 c4 10             	add    $0x10,%esp
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101d19:	8b 00                	mov    (%eax),%eax
f0101d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101d1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0101d22:	75 b3                	jne    f0101cd7 <check_page_free_list+0xec>

	first_free_page = (char *) boot_alloc(0);
f0101d24:	83 ec 0c             	sub    $0xc,%esp
f0101d27:	6a 00                	push   $0x0
f0101d29:	e8 40 f5 ff ff       	call   f010126e <boot_alloc>
f0101d2e:	83 c4 10             	add    $0x10,%esp
f0101d31:	89 45 e0             	mov    %eax,-0x20(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101d34:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f0101d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101d3d:	e9 d5 01 00 00       	jmp    f0101f17 <check_page_free_list+0x32c>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0101d42:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f0101d48:	8b 00                	mov    (%eax),%eax
f0101d4a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
f0101d4d:	73 1f                	jae    f0101d6e <check_page_free_list+0x183>
f0101d4f:	8d 83 cc 5c f7 ff    	lea    -0x8a334(%ebx),%eax
f0101d55:	50                   	push   %eax
f0101d56:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0101d5c:	50                   	push   %eax
f0101d5d:	68 95 02 00 00       	push   $0x295
f0101d62:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101d68:	50                   	push   %eax
f0101d69:	e8 5f e3 ff ff       	call   f01000cd <_panic>
		assert(pp < pages + npages);
f0101d6e:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f0101d74:	8b 10                	mov    (%eax),%edx
f0101d76:	c7 c0 a8 3f 19 f0    	mov    $0xf0193fa8,%eax
f0101d7c:	8b 00                	mov    (%eax),%eax
f0101d7e:	c1 e0 03             	shl    $0x3,%eax
f0101d81:	01 d0                	add    %edx,%eax
f0101d83:	39 45 f4             	cmp    %eax,-0xc(%ebp)
f0101d86:	72 1f                	jb     f0101da7 <check_page_free_list+0x1bc>
f0101d88:	8d 83 ed 5c f7 ff    	lea    -0x8a313(%ebx),%eax
f0101d8e:	50                   	push   %eax
f0101d8f:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0101d95:	50                   	push   %eax
f0101d96:	68 96 02 00 00       	push   $0x296
f0101d9b:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101da1:	50                   	push   %eax
f0101da2:	e8 26 e3 ff ff       	call   f01000cd <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101da7:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f0101dad:	8b 00                	mov    (%eax),%eax
f0101daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0101db2:	29 c2                	sub    %eax,%edx
f0101db4:	89 d0                	mov    %edx,%eax
f0101db6:	83 e0 07             	and    $0x7,%eax
f0101db9:	85 c0                	test   %eax,%eax
f0101dbb:	74 1f                	je     f0101ddc <check_page_free_list+0x1f1>
f0101dbd:	8d 83 04 5d f7 ff    	lea    -0x8a2fc(%ebx),%eax
f0101dc3:	50                   	push   %eax
f0101dc4:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0101dca:	50                   	push   %eax
f0101dcb:	68 97 02 00 00       	push   $0x297
f0101dd0:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101dd6:	50                   	push   %eax
f0101dd7:	e8 f1 e2 ff ff       	call   f01000cd <_panic>

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f0101ddc:	83 ec 0c             	sub    $0xc,%esp
f0101ddf:	ff 75 f4             	pushl  -0xc(%ebp)
f0101de2:	e8 df f2 ff ff       	call   f01010c6 <page2pa>
f0101de7:	83 c4 10             	add    $0x10,%esp
f0101dea:	85 c0                	test   %eax,%eax
f0101dec:	75 1f                	jne    f0101e0d <check_page_free_list+0x222>
f0101dee:	8d 83 36 5d f7 ff    	lea    -0x8a2ca(%ebx),%eax
f0101df4:	50                   	push   %eax
f0101df5:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0101dfb:	50                   	push   %eax
f0101dfc:	68 9a 02 00 00       	push   $0x29a
f0101e01:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101e07:	50                   	push   %eax
f0101e08:	e8 c0 e2 ff ff       	call   f01000cd <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0101e0d:	83 ec 0c             	sub    $0xc,%esp
f0101e10:	ff 75 f4             	pushl  -0xc(%ebp)
f0101e13:	e8 ae f2 ff ff       	call   f01010c6 <page2pa>
f0101e18:	83 c4 10             	add    $0x10,%esp
f0101e1b:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0101e20:	75 1f                	jne    f0101e41 <check_page_free_list+0x256>
f0101e22:	8d 83 47 5d f7 ff    	lea    -0x8a2b9(%ebx),%eax
f0101e28:	50                   	push   %eax
f0101e29:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0101e2f:	50                   	push   %eax
f0101e30:	68 9b 02 00 00       	push   $0x29b
f0101e35:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101e3b:	50                   	push   %eax
f0101e3c:	e8 8c e2 ff ff       	call   f01000cd <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101e41:	83 ec 0c             	sub    $0xc,%esp
f0101e44:	ff 75 f4             	pushl  -0xc(%ebp)
f0101e47:	e8 7a f2 ff ff       	call   f01010c6 <page2pa>
f0101e4c:	83 c4 10             	add    $0x10,%esp
f0101e4f:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0101e54:	75 1f                	jne    f0101e75 <check_page_free_list+0x28a>
f0101e56:	8d 83 60 5d f7 ff    	lea    -0x8a2a0(%ebx),%eax
f0101e5c:	50                   	push   %eax
f0101e5d:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0101e63:	50                   	push   %eax
f0101e64:	68 9c 02 00 00       	push   $0x29c
f0101e69:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101e6f:	50                   	push   %eax
f0101e70:	e8 58 e2 ff ff       	call   f01000cd <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101e75:	83 ec 0c             	sub    $0xc,%esp
f0101e78:	ff 75 f4             	pushl  -0xc(%ebp)
f0101e7b:	e8 46 f2 ff ff       	call   f01010c6 <page2pa>
f0101e80:	83 c4 10             	add    $0x10,%esp
f0101e83:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0101e88:	75 1f                	jne    f0101ea9 <check_page_free_list+0x2be>
f0101e8a:	8d 83 83 5d f7 ff    	lea    -0x8a27d(%ebx),%eax
f0101e90:	50                   	push   %eax
f0101e91:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0101e97:	50                   	push   %eax
f0101e98:	68 9d 02 00 00       	push   $0x29d
f0101e9d:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101ea3:	50                   	push   %eax
f0101ea4:	e8 24 e2 ff ff       	call   f01000cd <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101ea9:	83 ec 0c             	sub    $0xc,%esp
f0101eac:	ff 75 f4             	pushl  -0xc(%ebp)
f0101eaf:	e8 12 f2 ff ff       	call   f01010c6 <page2pa>
f0101eb4:	83 c4 10             	add    $0x10,%esp
f0101eb7:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0101ebc:	76 32                	jbe    f0101ef0 <check_page_free_list+0x305>
f0101ebe:	83 ec 0c             	sub    $0xc,%esp
f0101ec1:	ff 75 f4             	pushl  -0xc(%ebp)
f0101ec4:	e8 78 f2 ff ff       	call   f0101141 <page2kva>
f0101ec9:	83 c4 10             	add    $0x10,%esp
f0101ecc:	39 45 e0             	cmp    %eax,-0x20(%ebp)
f0101ecf:	76 1f                	jbe    f0101ef0 <check_page_free_list+0x305>
f0101ed1:	8d 83 a0 5d f7 ff    	lea    -0x8a260(%ebx),%eax
f0101ed7:	50                   	push   %eax
f0101ed8:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0101ede:	50                   	push   %eax
f0101edf:	68 9e 02 00 00       	push   $0x29e
f0101ee4:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101eea:	50                   	push   %eax
f0101eeb:	e8 dd e1 ff ff       	call   f01000cd <_panic>

		if (page2pa(pp) < EXTPHYSMEM)
f0101ef0:	83 ec 0c             	sub    $0xc,%esp
f0101ef3:	ff 75 f4             	pushl  -0xc(%ebp)
f0101ef6:	e8 cb f1 ff ff       	call   f01010c6 <page2pa>
f0101efb:	83 c4 10             	add    $0x10,%esp
f0101efe:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0101f03:	77 06                	ja     f0101f0b <check_page_free_list+0x320>
			++nfree_basemem;
f0101f05:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
f0101f09:	eb 04                	jmp    f0101f0f <check_page_free_list+0x324>
		else
			++nfree_extmem;
f0101f0b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101f12:	8b 00                	mov    (%eax),%eax
f0101f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101f17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0101f1b:	0f 85 21 fe ff ff    	jne    f0101d42 <check_page_free_list+0x157>
	}

	assert(nfree_basemem > 0);
f0101f21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0101f25:	7f 1f                	jg     f0101f46 <check_page_free_list+0x35b>
f0101f27:	8d 83 e5 5d f7 ff    	lea    -0x8a21b(%ebx),%eax
f0101f2d:	50                   	push   %eax
f0101f2e:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0101f34:	50                   	push   %eax
f0101f35:	68 a6 02 00 00       	push   $0x2a6
f0101f3a:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101f40:	50                   	push   %eax
f0101f41:	e8 87 e1 ff ff       	call   f01000cd <_panic>
	assert(nfree_extmem > 0);
f0101f46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f0101f4a:	7f 1f                	jg     f0101f6b <check_page_free_list+0x380>
f0101f4c:	8d 83 f7 5d f7 ff    	lea    -0x8a209(%ebx),%eax
f0101f52:	50                   	push   %eax
f0101f53:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0101f59:	50                   	push   %eax
f0101f5a:	68 a7 02 00 00       	push   $0x2a7
f0101f5f:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101f65:	50                   	push   %eax
f0101f66:	e8 62 e1 ff ff       	call   f01000cd <_panic>

	cprintf("check_page_free_list() succeeded!\n");
f0101f6b:	83 ec 0c             	sub    $0xc,%esp
f0101f6e:	8d 83 08 5e f7 ff    	lea    -0x8a1f8(%ebx),%eax
f0101f74:	50                   	push   %eax
f0101f75:	e8 eb 28 00 00       	call   f0104865 <cprintf>
f0101f7a:	83 c4 10             	add    $0x10,%esp
}
f0101f7d:	90                   	nop
f0101f7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101f81:	c9                   	leave  
f0101f82:	c3                   	ret    

f0101f83 <check_page_alloc>:
// Check the physical page allocator (page_alloc(), page_free(),
// and page_init()).
//
static void
check_page_alloc(void)
{
f0101f83:	f3 0f 1e fb          	endbr32 
f0101f87:	55                   	push   %ebp
f0101f88:	89 e5                	mov    %esp,%ebp
f0101f8a:	53                   	push   %ebx
f0101f8b:	83 ec 24             	sub    $0x24,%esp
f0101f8e:	e8 1b e2 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0101f93:	81 c3 21 fa 08 00    	add    $0x8fa21,%ebx
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f0101f99:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f0101f9f:	8b 00                	mov    (%eax),%eax
f0101fa1:	85 c0                	test   %eax,%eax
f0101fa3:	75 1b                	jne    f0101fc0 <check_page_alloc+0x3d>
		panic("'pages' is a null pointer!");
f0101fa5:	83 ec 04             	sub    $0x4,%esp
f0101fa8:	8d 83 2b 5e f7 ff    	lea    -0x8a1d5(%ebx),%eax
f0101fae:	50                   	push   %eax
f0101faf:	68 ba 02 00 00       	push   $0x2ba
f0101fb4:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0101fba:	50                   	push   %eax
f0101fbb:	e8 0d e1 ff ff       	call   f01000cd <_panic>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101fc0:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f0101fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101fc9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0101fd0:	eb 0c                	jmp    f0101fde <check_page_alloc+0x5b>
		++nfree;
f0101fd2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101fd9:	8b 00                	mov    (%eax),%eax
f0101fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0101fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0101fe2:	75 ee                	jne    f0101fd2 <check_page_alloc+0x4f>

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0101fe4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
f0101feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101fee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101ff1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101ff4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	assert((pp0 = page_alloc(0)));
f0101ff7:	83 ec 0c             	sub    $0xc,%esp
f0101ffa:	6a 00                	push   $0x0
f0101ffc:	e8 ca f6 ff ff       	call   f01016cb <page_alloc>
f0102001:	83 c4 10             	add    $0x10,%esp
f0102004:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0102007:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010200b:	75 1f                	jne    f010202c <check_page_alloc+0xa9>
f010200d:	8d 83 46 5e f7 ff    	lea    -0x8a1ba(%ebx),%eax
f0102013:	50                   	push   %eax
f0102014:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010201a:	50                   	push   %eax
f010201b:	68 c2 02 00 00       	push   $0x2c2
f0102020:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102026:	50                   	push   %eax
f0102027:	e8 a1 e0 ff ff       	call   f01000cd <_panic>
	assert((pp1 = page_alloc(0)));
f010202c:	83 ec 0c             	sub    $0xc,%esp
f010202f:	6a 00                	push   $0x0
f0102031:	e8 95 f6 ff ff       	call   f01016cb <page_alloc>
f0102036:	83 c4 10             	add    $0x10,%esp
f0102039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010203c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0102040:	75 1f                	jne    f0102061 <check_page_alloc+0xde>
f0102042:	8d 83 5c 5e f7 ff    	lea    -0x8a1a4(%ebx),%eax
f0102048:	50                   	push   %eax
f0102049:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010204f:	50                   	push   %eax
f0102050:	68 c3 02 00 00       	push   $0x2c3
f0102055:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010205b:	50                   	push   %eax
f010205c:	e8 6c e0 ff ff       	call   f01000cd <_panic>
	assert((pp2 = page_alloc(0)));
f0102061:	83 ec 0c             	sub    $0xc,%esp
f0102064:	6a 00                	push   $0x0
f0102066:	e8 60 f6 ff ff       	call   f01016cb <page_alloc>
f010206b:	83 c4 10             	add    $0x10,%esp
f010206e:	89 45 e8             	mov    %eax,-0x18(%ebp)
f0102071:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0102075:	75 1f                	jne    f0102096 <check_page_alloc+0x113>
f0102077:	8d 83 72 5e f7 ff    	lea    -0x8a18e(%ebx),%eax
f010207d:	50                   	push   %eax
f010207e:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102084:	50                   	push   %eax
f0102085:	68 c4 02 00 00       	push   $0x2c4
f010208a:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102090:	50                   	push   %eax
f0102091:	e8 37 e0 ff ff       	call   f01000cd <_panic>

	assert(pp0);
f0102096:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010209a:	75 1f                	jne    f01020bb <check_page_alloc+0x138>
f010209c:	8d 83 88 5e f7 ff    	lea    -0x8a178(%ebx),%eax
f01020a2:	50                   	push   %eax
f01020a3:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01020a9:	50                   	push   %eax
f01020aa:	68 c6 02 00 00       	push   $0x2c6
f01020af:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01020b5:	50                   	push   %eax
f01020b6:	e8 12 e0 ff ff       	call   f01000cd <_panic>
	assert(pp1 && pp1 != pp0);
f01020bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01020bf:	74 08                	je     f01020c9 <check_page_alloc+0x146>
f01020c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01020c4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
f01020c7:	75 1f                	jne    f01020e8 <check_page_alloc+0x165>
f01020c9:	8d 83 8c 5e f7 ff    	lea    -0x8a174(%ebx),%eax
f01020cf:	50                   	push   %eax
f01020d0:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01020d6:	50                   	push   %eax
f01020d7:	68 c7 02 00 00       	push   $0x2c7
f01020dc:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01020e2:	50                   	push   %eax
f01020e3:	e8 e5 df ff ff       	call   f01000cd <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01020e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f01020ec:	74 10                	je     f01020fe <check_page_alloc+0x17b>
f01020ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01020f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f01020f4:	74 08                	je     f01020fe <check_page_alloc+0x17b>
f01020f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01020f9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
f01020fc:	75 1f                	jne    f010211d <check_page_alloc+0x19a>
f01020fe:	8d 83 a0 5e f7 ff    	lea    -0x8a160(%ebx),%eax
f0102104:	50                   	push   %eax
f0102105:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010210b:	50                   	push   %eax
f010210c:	68 c8 02 00 00       	push   $0x2c8
f0102111:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102117:	50                   	push   %eax
f0102118:	e8 b0 df ff ff       	call   f01000cd <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f010211d:	83 ec 0c             	sub    $0xc,%esp
f0102120:	ff 75 e0             	pushl  -0x20(%ebp)
f0102123:	e8 9e ef ff ff       	call   f01010c6 <page2pa>
f0102128:	83 c4 10             	add    $0x10,%esp
f010212b:	c7 c2 a8 3f 19 f0    	mov    $0xf0193fa8,%edx
f0102131:	8b 12                	mov    (%edx),%edx
f0102133:	c1 e2 0c             	shl    $0xc,%edx
f0102136:	39 d0                	cmp    %edx,%eax
f0102138:	72 1f                	jb     f0102159 <check_page_alloc+0x1d6>
f010213a:	8d 83 c0 5e f7 ff    	lea    -0x8a140(%ebx),%eax
f0102140:	50                   	push   %eax
f0102141:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102147:	50                   	push   %eax
f0102148:	68 c9 02 00 00       	push   $0x2c9
f010214d:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102153:	50                   	push   %eax
f0102154:	e8 74 df ff ff       	call   f01000cd <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0102159:	83 ec 0c             	sub    $0xc,%esp
f010215c:	ff 75 e4             	pushl  -0x1c(%ebp)
f010215f:	e8 62 ef ff ff       	call   f01010c6 <page2pa>
f0102164:	83 c4 10             	add    $0x10,%esp
f0102167:	c7 c2 a8 3f 19 f0    	mov    $0xf0193fa8,%edx
f010216d:	8b 12                	mov    (%edx),%edx
f010216f:	c1 e2 0c             	shl    $0xc,%edx
f0102172:	39 d0                	cmp    %edx,%eax
f0102174:	72 1f                	jb     f0102195 <check_page_alloc+0x212>
f0102176:	8d 83 dd 5e f7 ff    	lea    -0x8a123(%ebx),%eax
f010217c:	50                   	push   %eax
f010217d:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102183:	50                   	push   %eax
f0102184:	68 ca 02 00 00       	push   $0x2ca
f0102189:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010218f:	50                   	push   %eax
f0102190:	e8 38 df ff ff       	call   f01000cd <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0102195:	83 ec 0c             	sub    $0xc,%esp
f0102198:	ff 75 e8             	pushl  -0x18(%ebp)
f010219b:	e8 26 ef ff ff       	call   f01010c6 <page2pa>
f01021a0:	83 c4 10             	add    $0x10,%esp
f01021a3:	c7 c2 a8 3f 19 f0    	mov    $0xf0193fa8,%edx
f01021a9:	8b 12                	mov    (%edx),%edx
f01021ab:	c1 e2 0c             	shl    $0xc,%edx
f01021ae:	39 d0                	cmp    %edx,%eax
f01021b0:	72 1f                	jb     f01021d1 <check_page_alloc+0x24e>
f01021b2:	8d 83 fa 5e f7 ff    	lea    -0x8a106(%ebx),%eax
f01021b8:	50                   	push   %eax
f01021b9:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01021bf:	50                   	push   %eax
f01021c0:	68 cb 02 00 00       	push   $0x2cb
f01021c5:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01021cb:	50                   	push   %eax
f01021cc:	e8 fc de ff ff       	call   f01000cd <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f01021d1:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f01021d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	page_free_list = 0;
f01021da:	c7 83 3c 19 00 00 00 	movl   $0x0,0x193c(%ebx)
f01021e1:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f01021e4:	83 ec 0c             	sub    $0xc,%esp
f01021e7:	6a 00                	push   $0x0
f01021e9:	e8 dd f4 ff ff       	call   f01016cb <page_alloc>
f01021ee:	83 c4 10             	add    $0x10,%esp
f01021f1:	85 c0                	test   %eax,%eax
f01021f3:	74 1f                	je     f0102214 <check_page_alloc+0x291>
f01021f5:	8d 83 17 5f f7 ff    	lea    -0x8a0e9(%ebx),%eax
f01021fb:	50                   	push   %eax
f01021fc:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102202:	50                   	push   %eax
f0102203:	68 d2 02 00 00       	push   $0x2d2
f0102208:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010220e:	50                   	push   %eax
f010220f:	e8 b9 de ff ff       	call   f01000cd <_panic>

	// free and re-allocate?
	page_free(pp0);
f0102214:	83 ec 0c             	sub    $0xc,%esp
f0102217:	ff 75 e0             	pushl  -0x20(%ebp)
f010221a:	e8 26 f5 ff ff       	call   f0101745 <page_free>
f010221f:	83 c4 10             	add    $0x10,%esp
	page_free(pp1);
f0102222:	83 ec 0c             	sub    $0xc,%esp
f0102225:	ff 75 e4             	pushl  -0x1c(%ebp)
f0102228:	e8 18 f5 ff ff       	call   f0101745 <page_free>
f010222d:	83 c4 10             	add    $0x10,%esp
	page_free(pp2);
f0102230:	83 ec 0c             	sub    $0xc,%esp
f0102233:	ff 75 e8             	pushl  -0x18(%ebp)
f0102236:	e8 0a f5 ff ff       	call   f0101745 <page_free>
f010223b:	83 c4 10             	add    $0x10,%esp
	pp0 = pp1 = pp2 = 0;
f010223e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
f0102245:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0102248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010224b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010224e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	assert((pp0 = page_alloc(0)));
f0102251:	83 ec 0c             	sub    $0xc,%esp
f0102254:	6a 00                	push   $0x0
f0102256:	e8 70 f4 ff ff       	call   f01016cb <page_alloc>
f010225b:	83 c4 10             	add    $0x10,%esp
f010225e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0102261:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0102265:	75 1f                	jne    f0102286 <check_page_alloc+0x303>
f0102267:	8d 83 46 5e f7 ff    	lea    -0x8a1ba(%ebx),%eax
f010226d:	50                   	push   %eax
f010226e:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102274:	50                   	push   %eax
f0102275:	68 d9 02 00 00       	push   $0x2d9
f010227a:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102280:	50                   	push   %eax
f0102281:	e8 47 de ff ff       	call   f01000cd <_panic>
	assert((pp1 = page_alloc(0)));
f0102286:	83 ec 0c             	sub    $0xc,%esp
f0102289:	6a 00                	push   $0x0
f010228b:	e8 3b f4 ff ff       	call   f01016cb <page_alloc>
f0102290:	83 c4 10             	add    $0x10,%esp
f0102293:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102296:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010229a:	75 1f                	jne    f01022bb <check_page_alloc+0x338>
f010229c:	8d 83 5c 5e f7 ff    	lea    -0x8a1a4(%ebx),%eax
f01022a2:	50                   	push   %eax
f01022a3:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01022a9:	50                   	push   %eax
f01022aa:	68 da 02 00 00       	push   $0x2da
f01022af:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01022b5:	50                   	push   %eax
f01022b6:	e8 12 de ff ff       	call   f01000cd <_panic>
	assert((pp2 = page_alloc(0)));
f01022bb:	83 ec 0c             	sub    $0xc,%esp
f01022be:	6a 00                	push   $0x0
f01022c0:	e8 06 f4 ff ff       	call   f01016cb <page_alloc>
f01022c5:	83 c4 10             	add    $0x10,%esp
f01022c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
f01022cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f01022cf:	75 1f                	jne    f01022f0 <check_page_alloc+0x36d>
f01022d1:	8d 83 72 5e f7 ff    	lea    -0x8a18e(%ebx),%eax
f01022d7:	50                   	push   %eax
f01022d8:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01022de:	50                   	push   %eax
f01022df:	68 db 02 00 00       	push   $0x2db
f01022e4:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01022ea:	50                   	push   %eax
f01022eb:	e8 dd dd ff ff       	call   f01000cd <_panic>
	assert(pp0);
f01022f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01022f4:	75 1f                	jne    f0102315 <check_page_alloc+0x392>
f01022f6:	8d 83 88 5e f7 ff    	lea    -0x8a178(%ebx),%eax
f01022fc:	50                   	push   %eax
f01022fd:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102303:	50                   	push   %eax
f0102304:	68 dc 02 00 00       	push   $0x2dc
f0102309:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010230f:	50                   	push   %eax
f0102310:	e8 b8 dd ff ff       	call   f01000cd <_panic>
	assert(pp1 && pp1 != pp0);
f0102315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0102319:	74 08                	je     f0102323 <check_page_alloc+0x3a0>
f010231b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010231e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
f0102321:	75 1f                	jne    f0102342 <check_page_alloc+0x3bf>
f0102323:	8d 83 8c 5e f7 ff    	lea    -0x8a174(%ebx),%eax
f0102329:	50                   	push   %eax
f010232a:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102330:	50                   	push   %eax
f0102331:	68 dd 02 00 00       	push   $0x2dd
f0102336:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010233c:	50                   	push   %eax
f010233d:	e8 8b dd ff ff       	call   f01000cd <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102342:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0102346:	74 10                	je     f0102358 <check_page_alloc+0x3d5>
f0102348:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010234b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f010234e:	74 08                	je     f0102358 <check_page_alloc+0x3d5>
f0102350:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0102353:	3b 45 e0             	cmp    -0x20(%ebp),%eax
f0102356:	75 1f                	jne    f0102377 <check_page_alloc+0x3f4>
f0102358:	8d 83 a0 5e f7 ff    	lea    -0x8a160(%ebx),%eax
f010235e:	50                   	push   %eax
f010235f:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102365:	50                   	push   %eax
f0102366:	68 de 02 00 00       	push   $0x2de
f010236b:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102371:	50                   	push   %eax
f0102372:	e8 56 dd ff ff       	call   f01000cd <_panic>
	assert(!page_alloc(0));
f0102377:	83 ec 0c             	sub    $0xc,%esp
f010237a:	6a 00                	push   $0x0
f010237c:	e8 4a f3 ff ff       	call   f01016cb <page_alloc>
f0102381:	83 c4 10             	add    $0x10,%esp
f0102384:	85 c0                	test   %eax,%eax
f0102386:	74 1f                	je     f01023a7 <check_page_alloc+0x424>
f0102388:	8d 83 17 5f f7 ff    	lea    -0x8a0e9(%ebx),%eax
f010238e:	50                   	push   %eax
f010238f:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102395:	50                   	push   %eax
f0102396:	68 df 02 00 00       	push   $0x2df
f010239b:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01023a1:	50                   	push   %eax
f01023a2:	e8 26 dd ff ff       	call   f01000cd <_panic>

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f01023a7:	83 ec 0c             	sub    $0xc,%esp
f01023aa:	ff 75 e0             	pushl  -0x20(%ebp)
f01023ad:	e8 8f ed ff ff       	call   f0101141 <page2kva>
f01023b2:	83 c4 10             	add    $0x10,%esp
f01023b5:	83 ec 04             	sub    $0x4,%esp
f01023b8:	68 00 10 00 00       	push   $0x1000
f01023bd:	6a 01                	push   $0x1
f01023bf:	50                   	push   %eax
f01023c0:	e8 5b 48 00 00       	call   f0106c20 <memset>
f01023c5:	83 c4 10             	add    $0x10,%esp
	page_free(pp0);
f01023c8:	83 ec 0c             	sub    $0xc,%esp
f01023cb:	ff 75 e0             	pushl  -0x20(%ebp)
f01023ce:	e8 72 f3 ff ff       	call   f0101745 <page_free>
f01023d3:	83 c4 10             	add    $0x10,%esp
	assert((pp = page_alloc(ALLOC_ZERO)));
f01023d6:	83 ec 0c             	sub    $0xc,%esp
f01023d9:	6a 01                	push   $0x1
f01023db:	e8 eb f2 ff ff       	call   f01016cb <page_alloc>
f01023e0:	83 c4 10             	add    $0x10,%esp
f01023e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01023e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f01023ea:	75 1f                	jne    f010240b <check_page_alloc+0x488>
f01023ec:	8d 83 26 5f f7 ff    	lea    -0x8a0da(%ebx),%eax
f01023f2:	50                   	push   %eax
f01023f3:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01023f9:	50                   	push   %eax
f01023fa:	68 e4 02 00 00       	push   $0x2e4
f01023ff:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102405:	50                   	push   %eax
f0102406:	e8 c2 dc ff ff       	call   f01000cd <_panic>
	assert(pp && pp0 == pp);
f010240b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f010240f:	74 08                	je     f0102419 <check_page_alloc+0x496>
f0102411:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102414:	3b 45 f4             	cmp    -0xc(%ebp),%eax
f0102417:	74 1f                	je     f0102438 <check_page_alloc+0x4b5>
f0102419:	8d 83 44 5f f7 ff    	lea    -0x8a0bc(%ebx),%eax
f010241f:	50                   	push   %eax
f0102420:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102426:	50                   	push   %eax
f0102427:	68 e5 02 00 00       	push   $0x2e5
f010242c:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102432:	50                   	push   %eax
f0102433:	e8 95 dc ff ff       	call   f01000cd <_panic>
	c = page2kva(pp);
f0102438:	83 ec 0c             	sub    $0xc,%esp
f010243b:	ff 75 f4             	pushl  -0xc(%ebp)
f010243e:	e8 fe ec ff ff       	call   f0101141 <page2kva>
f0102443:	83 c4 10             	add    $0x10,%esp
f0102446:	89 45 d8             	mov    %eax,-0x28(%ebp)
	for (i = 0; i < PGSIZE; i++)
f0102449:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
f0102450:	eb 32                	jmp    f0102484 <check_page_alloc+0x501>
		assert(c[i] == 0);
f0102452:	8b 55 ec             	mov    -0x14(%ebp),%edx
f0102455:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0102458:	01 d0                	add    %edx,%eax
f010245a:	0f b6 00             	movzbl (%eax),%eax
f010245d:	84 c0                	test   %al,%al
f010245f:	74 1f                	je     f0102480 <check_page_alloc+0x4fd>
f0102461:	8d 83 54 5f f7 ff    	lea    -0x8a0ac(%ebx),%eax
f0102467:	50                   	push   %eax
f0102468:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010246e:	50                   	push   %eax
f010246f:	68 e8 02 00 00       	push   $0x2e8
f0102474:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010247a:	50                   	push   %eax
f010247b:	e8 4d dc ff ff       	call   f01000cd <_panic>
	for (i = 0; i < PGSIZE; i++)
f0102480:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
f0102484:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
f010248b:	7e c5                	jle    f0102452 <check_page_alloc+0x4cf>

	// give free list back
	page_free_list = fl;
f010248d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0102490:	89 83 3c 19 00 00    	mov    %eax,0x193c(%ebx)

	// free the pages we took
	page_free(pp0);
f0102496:	83 ec 0c             	sub    $0xc,%esp
f0102499:	ff 75 e0             	pushl  -0x20(%ebp)
f010249c:	e8 a4 f2 ff ff       	call   f0101745 <page_free>
f01024a1:	83 c4 10             	add    $0x10,%esp
	page_free(pp1);
f01024a4:	83 ec 0c             	sub    $0xc,%esp
f01024a7:	ff 75 e4             	pushl  -0x1c(%ebp)
f01024aa:	e8 96 f2 ff ff       	call   f0101745 <page_free>
f01024af:	83 c4 10             	add    $0x10,%esp
	page_free(pp2);
f01024b2:	83 ec 0c             	sub    $0xc,%esp
f01024b5:	ff 75 e8             	pushl  -0x18(%ebp)
f01024b8:	e8 88 f2 ff ff       	call   f0101745 <page_free>
f01024bd:	83 c4 10             	add    $0x10,%esp

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01024c0:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f01024c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01024c9:	eb 0c                	jmp    f01024d7 <check_page_alloc+0x554>
		--nfree;
f01024cb:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01024d2:	8b 00                	mov    (%eax),%eax
f01024d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01024d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f01024db:	75 ee                	jne    f01024cb <check_page_alloc+0x548>
	assert(nfree == 0);
f01024dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f01024e1:	74 1f                	je     f0102502 <check_page_alloc+0x57f>
f01024e3:	8d 83 5e 5f f7 ff    	lea    -0x8a0a2(%ebx),%eax
f01024e9:	50                   	push   %eax
f01024ea:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01024f0:	50                   	push   %eax
f01024f1:	68 f5 02 00 00       	push   $0x2f5
f01024f6:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01024fc:	50                   	push   %eax
f01024fd:	e8 cb db ff ff       	call   f01000cd <_panic>

	cprintf("check_page_alloc() succeeded!\n");
f0102502:	83 ec 0c             	sub    $0xc,%esp
f0102505:	8d 83 6c 5f f7 ff    	lea    -0x8a094(%ebx),%eax
f010250b:	50                   	push   %eax
f010250c:	e8 54 23 00 00       	call   f0104865 <cprintf>
f0102511:	83 c4 10             	add    $0x10,%esp
}
f0102514:	90                   	nop
f0102515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102518:	c9                   	leave  
f0102519:	c3                   	ret    

f010251a <check_kern_pgdir>:
// but it is a pretty good sanity check.
//

static void
check_kern_pgdir(void)
{
f010251a:	f3 0f 1e fb          	endbr32 
f010251e:	55                   	push   %ebp
f010251f:	89 e5                	mov    %esp,%ebp
f0102521:	56                   	push   %esi
f0102522:	53                   	push   %ebx
f0102523:	83 ec 20             	sub    $0x20,%esp
f0102526:	e8 83 dc ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f010252b:	81 c3 89 f4 08 00    	add    $0x8f489,%ebx
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f0102531:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102537:	8b 00                	mov    (%eax),%eax
f0102539:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f010253c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
f0102543:	c7 c0 a8 3f 19 f0    	mov    $0xf0193fa8,%eax
f0102549:	8b 00                	mov    (%eax),%eax
f010254b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
f0102552:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0102555:	01 d0                	add    %edx,%eax
f0102557:	83 e8 01             	sub    $0x1,%eax
f010255a:	89 45 e8             	mov    %eax,-0x18(%ebp)
f010255d:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0102560:	ba 00 00 00 00       	mov    $0x0,%edx
f0102565:	f7 75 ec             	divl   -0x14(%ebp)
f0102568:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010256b:	29 d0                	sub    %edx,%eax
f010256d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f0102570:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0102577:	eb 68                	jmp    f01025e1 <check_kern_pgdir+0xc7>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102579:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010257c:	2d 00 00 00 11       	sub    $0x11000000,%eax
f0102581:	83 ec 08             	sub    $0x8,%esp
f0102584:	50                   	push   %eax
f0102585:	ff 75 f0             	pushl  -0x10(%ebp)
f0102588:	e8 42 03 00 00       	call   f01028cf <check_va2pa>
f010258d:	83 c4 10             	add    $0x10,%esp
f0102590:	89 c6                	mov    %eax,%esi
f0102592:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f0102598:	8b 00                	mov    (%eax),%eax
f010259a:	83 ec 04             	sub    $0x4,%esp
f010259d:	50                   	push   %eax
f010259e:	68 0d 03 00 00       	push   $0x30d
f01025a3:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01025a9:	50                   	push   %eax
f01025aa:	e8 8e ea ff ff       	call   f010103d <_paddr>
f01025af:	83 c4 10             	add    $0x10,%esp
f01025b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01025b5:	01 d0                	add    %edx,%eax
f01025b7:	39 c6                	cmp    %eax,%esi
f01025b9:	74 1f                	je     f01025da <check_kern_pgdir+0xc0>
f01025bb:	8d 83 8c 5f f7 ff    	lea    -0x8a074(%ebx),%eax
f01025c1:	50                   	push   %eax
f01025c2:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01025c8:	50                   	push   %eax
f01025c9:	68 0d 03 00 00       	push   $0x30d
f01025ce:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01025d4:	50                   	push   %eax
f01025d5:	e8 f3 da ff ff       	call   f01000cd <_panic>
	for (i = 0; i < n; i += PGSIZE)
f01025da:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f01025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01025e4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f01025e7:	72 90                	jb     f0102579 <check_kern_pgdir+0x5f>

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
f01025e9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
f01025f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01025f3:	05 ff 7f 01 00       	add    $0x17fff,%eax
f01025f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01025fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01025fe:	ba 00 00 00 00       	mov    $0x0,%edx
f0102603:	f7 75 e0             	divl   -0x20(%ebp)
f0102606:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0102609:	29 d0                	sub    %edx,%eax
f010260b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f010260e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0102615:	eb 68                	jmp    f010267f <check_kern_pgdir+0x165>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102617:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010261a:	2d 00 00 40 11       	sub    $0x11400000,%eax
f010261f:	83 ec 08             	sub    $0x8,%esp
f0102622:	50                   	push   %eax
f0102623:	ff 75 f0             	pushl  -0x10(%ebp)
f0102626:	e8 a4 02 00 00       	call   f01028cf <check_va2pa>
f010262b:	83 c4 10             	add    $0x10,%esp
f010262e:	89 c6                	mov    %eax,%esi
f0102630:	c7 c0 fc 32 19 f0    	mov    $0xf01932fc,%eax
f0102636:	8b 00                	mov    (%eax),%eax
f0102638:	83 ec 04             	sub    $0x4,%esp
f010263b:	50                   	push   %eax
f010263c:	68 12 03 00 00       	push   $0x312
f0102641:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102647:	50                   	push   %eax
f0102648:	e8 f0 e9 ff ff       	call   f010103d <_paddr>
f010264d:	83 c4 10             	add    $0x10,%esp
f0102650:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0102653:	01 d0                	add    %edx,%eax
f0102655:	39 c6                	cmp    %eax,%esi
f0102657:	74 1f                	je     f0102678 <check_kern_pgdir+0x15e>
f0102659:	8d 83 c0 5f f7 ff    	lea    -0x8a040(%ebx),%eax
f010265f:	50                   	push   %eax
f0102660:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102666:	50                   	push   %eax
f0102667:	68 12 03 00 00       	push   $0x312
f010266c:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102672:	50                   	push   %eax
f0102673:	e8 55 da ff ff       	call   f01000cd <_panic>
	for (i = 0; i < n; i += PGSIZE)
f0102678:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f010267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102682:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f0102685:	72 90                	jb     f0102617 <check_kern_pgdir+0xfd>

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102687:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f010268e:	eb 42                	jmp    f01026d2 <check_kern_pgdir+0x1b8>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102690:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102693:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102698:	83 ec 08             	sub    $0x8,%esp
f010269b:	50                   	push   %eax
f010269c:	ff 75 f0             	pushl  -0x10(%ebp)
f010269f:	e8 2b 02 00 00       	call   f01028cf <check_va2pa>
f01026a4:	83 c4 10             	add    $0x10,%esp
f01026a7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
f01026aa:	74 1f                	je     f01026cb <check_kern_pgdir+0x1b1>
f01026ac:	8d 83 f4 5f f7 ff    	lea    -0x8a00c(%ebx),%eax
f01026b2:	50                   	push   %eax
f01026b3:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01026b9:	50                   	push   %eax
f01026ba:	68 16 03 00 00       	push   $0x316
f01026bf:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01026c5:	50                   	push   %eax
f01026c6:	e8 02 da ff ff       	call   f01000cd <_panic>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01026cb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f01026d2:	c7 c0 a8 3f 19 f0    	mov    $0xf0193fa8,%eax
f01026d8:	8b 00                	mov    (%eax),%eax
f01026da:	c1 e0 0c             	shl    $0xc,%eax
f01026dd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
f01026e0:	72 ae                	jb     f0102690 <check_kern_pgdir+0x176>

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f01026e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01026e9:	eb 66                	jmp    f0102751 <check_kern_pgdir+0x237>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f01026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01026ee:	2d 00 80 00 10       	sub    $0x10008000,%eax
f01026f3:	83 ec 08             	sub    $0x8,%esp
f01026f6:	50                   	push   %eax
f01026f7:	ff 75 f0             	pushl  -0x10(%ebp)
f01026fa:	e8 d0 01 00 00       	call   f01028cf <check_va2pa>
f01026ff:	83 c4 10             	add    $0x10,%esp
f0102702:	89 c6                	mov    %eax,%esi
f0102704:	83 ec 04             	sub    $0x4,%esp
f0102707:	c7 c0 00 70 11 f0    	mov    $0xf0117000,%eax
f010270d:	50                   	push   %eax
f010270e:	68 1a 03 00 00       	push   $0x31a
f0102713:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102719:	50                   	push   %eax
f010271a:	e8 1e e9 ff ff       	call   f010103d <_paddr>
f010271f:	83 c4 10             	add    $0x10,%esp
f0102722:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0102725:	01 d0                	add    %edx,%eax
f0102727:	39 c6                	cmp    %eax,%esi
f0102729:	74 1f                	je     f010274a <check_kern_pgdir+0x230>
f010272b:	8d 83 1c 60 f7 ff    	lea    -0x89fe4(%ebx),%eax
f0102731:	50                   	push   %eax
f0102732:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102738:	50                   	push   %eax
f0102739:	68 1a 03 00 00       	push   $0x31a
f010273e:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102744:	50                   	push   %eax
f0102745:	e8 83 d9 ff ff       	call   f01000cd <_panic>
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f010274a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
f0102751:	81 7d f4 ff 7f 00 00 	cmpl   $0x7fff,-0xc(%ebp)
f0102758:	76 91                	jbe    f01026eb <check_kern_pgdir+0x1d1>
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f010275a:	83 ec 08             	sub    $0x8,%esp
f010275d:	68 00 00 c0 ef       	push   $0xefc00000
f0102762:	ff 75 f0             	pushl  -0x10(%ebp)
f0102765:	e8 65 01 00 00       	call   f01028cf <check_va2pa>
f010276a:	83 c4 10             	add    $0x10,%esp
f010276d:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102770:	74 1f                	je     f0102791 <check_kern_pgdir+0x277>
f0102772:	8d 83 64 60 f7 ff    	lea    -0x89f9c(%ebx),%eax
f0102778:	50                   	push   %eax
f0102779:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010277f:	50                   	push   %eax
f0102780:	68 1b 03 00 00       	push   $0x31b
f0102785:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010278b:	50                   	push   %eax
f010278c:	e8 3c d9 ff ff       	call   f01000cd <_panic>

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f0102791:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0102798:	e9 0b 01 00 00       	jmp    f01028a8 <check_kern_pgdir+0x38e>
		switch (i) {
f010279d:	81 7d f4 bd 03 00 00 	cmpl   $0x3bd,-0xc(%ebp)
f01027a4:	77 0b                	ja     f01027b1 <check_kern_pgdir+0x297>
f01027a6:	81 7d f4 bb 03 00 00 	cmpl   $0x3bb,-0xc(%ebp)
f01027ad:	73 0b                	jae    f01027ba <check_kern_pgdir+0x2a0>
f01027af:	eb 44                	jmp    f01027f5 <check_kern_pgdir+0x2db>
f01027b1:	81 7d f4 bf 03 00 00 	cmpl   $0x3bf,-0xc(%ebp)
f01027b8:	75 3b                	jne    f01027f5 <check_kern_pgdir+0x2db>
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
			assert(pgdir[i] & PTE_P);
f01027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01027bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f01027c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01027c7:	01 d0                	add    %edx,%eax
f01027c9:	8b 00                	mov    (%eax),%eax
f01027cb:	83 e0 01             	and    $0x1,%eax
f01027ce:	85 c0                	test   %eax,%eax
f01027d0:	0f 85 ca 00 00 00    	jne    f01028a0 <check_kern_pgdir+0x386>
f01027d6:	8d 83 91 60 f7 ff    	lea    -0x89f6f(%ebx),%eax
f01027dc:	50                   	push   %eax
f01027dd:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01027e3:	50                   	push   %eax
f01027e4:	68 24 03 00 00       	push   $0x324
f01027e9:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01027ef:	50                   	push   %eax
f01027f0:	e8 d8 d8 ff ff       	call   f01000cd <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f01027f5:	81 7d f4 bf 03 00 00 	cmpl   $0x3bf,-0xc(%ebp)
f01027fc:	76 6e                	jbe    f010286c <check_kern_pgdir+0x352>
				assert(pgdir[i] & PTE_P);
f01027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102801:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f0102808:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010280b:	01 d0                	add    %edx,%eax
f010280d:	8b 00                	mov    (%eax),%eax
f010280f:	83 e0 01             	and    $0x1,%eax
f0102812:	85 c0                	test   %eax,%eax
f0102814:	75 1f                	jne    f0102835 <check_kern_pgdir+0x31b>
f0102816:	8d 83 91 60 f7 ff    	lea    -0x89f6f(%ebx),%eax
f010281c:	50                   	push   %eax
f010281d:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102823:	50                   	push   %eax
f0102824:	68 28 03 00 00       	push   $0x328
f0102829:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010282f:	50                   	push   %eax
f0102830:	e8 98 d8 ff ff       	call   f01000cd <_panic>
				assert(pgdir[i] & PTE_W);
f0102835:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102838:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f010283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102842:	01 d0                	add    %edx,%eax
f0102844:	8b 00                	mov    (%eax),%eax
f0102846:	83 e0 02             	and    $0x2,%eax
f0102849:	85 c0                	test   %eax,%eax
f010284b:	75 56                	jne    f01028a3 <check_kern_pgdir+0x389>
f010284d:	8d 83 a2 60 f7 ff    	lea    -0x89f5e(%ebx),%eax
f0102853:	50                   	push   %eax
f0102854:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010285a:	50                   	push   %eax
f010285b:	68 29 03 00 00       	push   $0x329
f0102860:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102866:	50                   	push   %eax
f0102867:	e8 61 d8 ff ff       	call   f01000cd <_panic>
			} else
				assert(pgdir[i] == 0);
f010286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010286f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f0102876:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102879:	01 d0                	add    %edx,%eax
f010287b:	8b 00                	mov    (%eax),%eax
f010287d:	85 c0                	test   %eax,%eax
f010287f:	74 22                	je     f01028a3 <check_kern_pgdir+0x389>
f0102881:	8d 83 b3 60 f7 ff    	lea    -0x89f4d(%ebx),%eax
f0102887:	50                   	push   %eax
f0102888:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010288e:	50                   	push   %eax
f010288f:	68 2b 03 00 00       	push   $0x32b
f0102894:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010289a:	50                   	push   %eax
f010289b:	e8 2d d8 ff ff       	call   f01000cd <_panic>
			break;
f01028a0:	90                   	nop
f01028a1:	eb 01                	jmp    f01028a4 <check_kern_pgdir+0x38a>
			break;
f01028a3:	90                   	nop
	for (i = 0; i < NPDENTRIES; i++) {
f01028a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f01028a8:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
f01028af:	0f 86 e8 fe ff ff    	jbe    f010279d <check_kern_pgdir+0x283>
		}
	}
	cprintf("check_kern_pgdir() succeeded!\n");
f01028b5:	83 ec 0c             	sub    $0xc,%esp
f01028b8:	8d 83 c4 60 f7 ff    	lea    -0x89f3c(%ebx),%eax
f01028be:	50                   	push   %eax
f01028bf:	e8 a1 1f 00 00       	call   f0104865 <cprintf>
f01028c4:	83 c4 10             	add    $0x10,%esp
}
f01028c7:	90                   	nop
f01028c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01028cb:	5b                   	pop    %ebx
f01028cc:	5e                   	pop    %esi
f01028cd:	5d                   	pop    %ebp
f01028ce:	c3                   	ret    

f01028cf <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f01028cf:	f3 0f 1e fb          	endbr32 
f01028d3:	55                   	push   %ebp
f01028d4:	89 e5                	mov    %esp,%ebp
f01028d6:	83 ec 18             	sub    $0x18,%esp
f01028d9:	e8 21 e2 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01028de:	05 d6 f0 08 00       	add    $0x8f0d6,%eax
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f01028e3:	8b 55 0c             	mov    0xc(%ebp),%edx
f01028e6:	c1 ea 16             	shr    $0x16,%edx
f01028e9:	c1 e2 02             	shl    $0x2,%edx
f01028ec:	01 55 08             	add    %edx,0x8(%ebp)
	if (!(*pgdir & PTE_P))
f01028ef:	8b 55 08             	mov    0x8(%ebp),%edx
f01028f2:	8b 12                	mov    (%edx),%edx
f01028f4:	83 e2 01             	and    $0x1,%edx
f01028f7:	85 d2                	test   %edx,%edx
f01028f9:	75 07                	jne    f0102902 <check_va2pa+0x33>
		return ~0;
f01028fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0102900:	eb 6b                	jmp    f010296d <check_va2pa+0x9e>
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0102902:	8b 55 08             	mov    0x8(%ebp),%edx
f0102905:	8b 12                	mov    (%edx),%edx
f0102907:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010290d:	83 ec 04             	sub    $0x4,%esp
f0102910:	52                   	push   %edx
f0102911:	68 3f 03 00 00       	push   $0x33f
f0102916:	8d 80 e7 5b f7 ff    	lea    -0x8a419(%eax),%eax
f010291c:	50                   	push   %eax
f010291d:	e8 5b e7 ff ff       	call   f010107d <_kaddr>
f0102922:	83 c4 10             	add    $0x10,%esp
f0102925:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!(p[PTX(va)] & PTE_P))
f0102928:	8b 45 0c             	mov    0xc(%ebp),%eax
f010292b:	c1 e8 0c             	shr    $0xc,%eax
f010292e:	25 ff 03 00 00       	and    $0x3ff,%eax
f0102933:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f010293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010293d:	01 d0                	add    %edx,%eax
f010293f:	8b 00                	mov    (%eax),%eax
f0102941:	83 e0 01             	and    $0x1,%eax
f0102944:	85 c0                	test   %eax,%eax
f0102946:	75 07                	jne    f010294f <check_va2pa+0x80>
		return ~0;
f0102948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010294d:	eb 1e                	jmp    f010296d <check_va2pa+0x9e>
	return PTE_ADDR(p[PTX(va)]);
f010294f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102952:	c1 e8 0c             	shr    $0xc,%eax
f0102955:	25 ff 03 00 00       	and    $0x3ff,%eax
f010295a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f0102961:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102964:	01 d0                	add    %edx,%eax
f0102966:	8b 00                	mov    (%eax),%eax
f0102968:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
f010296d:	c9                   	leave  
f010296e:	c3                   	ret    

f010296f <check_page>:


// check page_insert, page_remove, &c
static void
check_page(void)
{
f010296f:	f3 0f 1e fb          	endbr32 
f0102973:	55                   	push   %ebp
f0102974:	89 e5                	mov    %esp,%ebp
f0102976:	56                   	push   %esi
f0102977:	53                   	push   %ebx
f0102978:	83 ec 30             	sub    $0x30,%esp
f010297b:	e8 2e d8 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0102980:	81 c3 34 f0 08 00    	add    $0x8f034,%ebx
	void *va;
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0102986:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f010298d:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102990:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0102993:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0102996:	89 45 e8             	mov    %eax,-0x18(%ebp)
	assert((pp0 = page_alloc(0)));
f0102999:	83 ec 0c             	sub    $0xc,%esp
f010299c:	6a 00                	push   $0x0
f010299e:	e8 28 ed ff ff       	call   f01016cb <page_alloc>
f01029a3:	83 c4 10             	add    $0x10,%esp
f01029a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
f01029a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f01029ad:	75 1f                	jne    f01029ce <check_page+0x5f>
f01029af:	8d 83 46 5e f7 ff    	lea    -0x8a1ba(%ebx),%eax
f01029b5:	50                   	push   %eax
f01029b6:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01029bc:	50                   	push   %eax
f01029bd:	68 53 03 00 00       	push   $0x353
f01029c2:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01029c8:	50                   	push   %eax
f01029c9:	e8 ff d6 ff ff       	call   f01000cd <_panic>
	assert((pp1 = page_alloc(0)));
f01029ce:	83 ec 0c             	sub    $0xc,%esp
f01029d1:	6a 00                	push   $0x0
f01029d3:	e8 f3 ec ff ff       	call   f01016cb <page_alloc>
f01029d8:	83 c4 10             	add    $0x10,%esp
f01029db:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01029de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f01029e2:	75 1f                	jne    f0102a03 <check_page+0x94>
f01029e4:	8d 83 5c 5e f7 ff    	lea    -0x8a1a4(%ebx),%eax
f01029ea:	50                   	push   %eax
f01029eb:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01029f1:	50                   	push   %eax
f01029f2:	68 54 03 00 00       	push   $0x354
f01029f7:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01029fd:	50                   	push   %eax
f01029fe:	e8 ca d6 ff ff       	call   f01000cd <_panic>
	assert((pp2 = page_alloc(0)));
f0102a03:	83 ec 0c             	sub    $0xc,%esp
f0102a06:	6a 00                	push   $0x0
f0102a08:	e8 be ec ff ff       	call   f01016cb <page_alloc>
f0102a0d:	83 c4 10             	add    $0x10,%esp
f0102a10:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0102a13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0102a17:	75 1f                	jne    f0102a38 <check_page+0xc9>
f0102a19:	8d 83 72 5e f7 ff    	lea    -0x8a18e(%ebx),%eax
f0102a1f:	50                   	push   %eax
f0102a20:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102a26:	50                   	push   %eax
f0102a27:	68 55 03 00 00       	push   $0x355
f0102a2c:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102a32:	50                   	push   %eax
f0102a33:	e8 95 d6 ff ff       	call   f01000cd <_panic>

	assert(pp0);
f0102a38:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0102a3c:	75 1f                	jne    f0102a5d <check_page+0xee>
f0102a3e:	8d 83 88 5e f7 ff    	lea    -0x8a178(%ebx),%eax
f0102a44:	50                   	push   %eax
f0102a45:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102a4b:	50                   	push   %eax
f0102a4c:	68 57 03 00 00       	push   $0x357
f0102a51:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102a57:	50                   	push   %eax
f0102a58:	e8 70 d6 ff ff       	call   f01000cd <_panic>
	assert(pp1 && pp1 != pp0);
f0102a5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f0102a61:	74 08                	je     f0102a6b <check_page+0xfc>
f0102a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0102a66:	3b 45 e8             	cmp    -0x18(%ebp),%eax
f0102a69:	75 1f                	jne    f0102a8a <check_page+0x11b>
f0102a6b:	8d 83 8c 5e f7 ff    	lea    -0x8a174(%ebx),%eax
f0102a71:	50                   	push   %eax
f0102a72:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102a78:	50                   	push   %eax
f0102a79:	68 58 03 00 00       	push   $0x358
f0102a7e:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102a84:	50                   	push   %eax
f0102a85:	e8 43 d6 ff ff       	call   f01000cd <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102a8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0102a8e:	74 10                	je     f0102aa0 <check_page+0x131>
f0102a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102a93:	3b 45 ec             	cmp    -0x14(%ebp),%eax
f0102a96:	74 08                	je     f0102aa0 <check_page+0x131>
f0102a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102a9b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
f0102a9e:	75 1f                	jne    f0102abf <check_page+0x150>
f0102aa0:	8d 83 a0 5e f7 ff    	lea    -0x8a160(%ebx),%eax
f0102aa6:	50                   	push   %eax
f0102aa7:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102aad:	50                   	push   %eax
f0102aae:	68 59 03 00 00       	push   $0x359
f0102ab3:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102ab9:	50                   	push   %eax
f0102aba:	e8 0e d6 ff ff       	call   f01000cd <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102abf:	8b 83 3c 19 00 00    	mov    0x193c(%ebx),%eax
f0102ac5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	page_free_list = 0;
f0102ac8:	c7 83 3c 19 00 00 00 	movl   $0x0,0x193c(%ebx)
f0102acf:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0102ad2:	83 ec 0c             	sub    $0xc,%esp
f0102ad5:	6a 00                	push   $0x0
f0102ad7:	e8 ef eb ff ff       	call   f01016cb <page_alloc>
f0102adc:	83 c4 10             	add    $0x10,%esp
f0102adf:	85 c0                	test   %eax,%eax
f0102ae1:	74 1f                	je     f0102b02 <check_page+0x193>
f0102ae3:	8d 83 17 5f f7 ff    	lea    -0x8a0e9(%ebx),%eax
f0102ae9:	50                   	push   %eax
f0102aea:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102af0:	50                   	push   %eax
f0102af1:	68 60 03 00 00       	push   $0x360
f0102af6:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102afc:	50                   	push   %eax
f0102afd:	e8 cb d5 ff ff       	call   f01000cd <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102b02:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102b08:	8b 00                	mov    (%eax),%eax
f0102b0a:	83 ec 04             	sub    $0x4,%esp
f0102b0d:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0102b10:	52                   	push   %edx
f0102b11:	6a 00                	push   $0x0
f0102b13:	50                   	push   %eax
f0102b14:	e8 c4 ee ff ff       	call   f01019dd <page_lookup>
f0102b19:	83 c4 10             	add    $0x10,%esp
f0102b1c:	85 c0                	test   %eax,%eax
f0102b1e:	74 1f                	je     f0102b3f <check_page+0x1d0>
f0102b20:	8d 83 e4 60 f7 ff    	lea    -0x89f1c(%ebx),%eax
f0102b26:	50                   	push   %eax
f0102b27:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102b2d:	50                   	push   %eax
f0102b2e:	68 63 03 00 00       	push   $0x363
f0102b33:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102b39:	50                   	push   %eax
f0102b3a:	e8 8e d5 ff ff       	call   f01000cd <_panic>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102b3f:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102b45:	8b 00                	mov    (%eax),%eax
f0102b47:	6a 02                	push   $0x2
f0102b49:	6a 00                	push   $0x0
f0102b4b:	ff 75 ec             	pushl  -0x14(%ebp)
f0102b4e:	50                   	push   %eax
f0102b4f:	e8 0c ee ff ff       	call   f0101960 <page_insert>
f0102b54:	83 c4 10             	add    $0x10,%esp
f0102b57:	85 c0                	test   %eax,%eax
f0102b59:	78 1f                	js     f0102b7a <check_page+0x20b>
f0102b5b:	8d 83 1c 61 f7 ff    	lea    -0x89ee4(%ebx),%eax
f0102b61:	50                   	push   %eax
f0102b62:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102b68:	50                   	push   %eax
f0102b69:	68 66 03 00 00       	push   $0x366
f0102b6e:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102b74:	50                   	push   %eax
f0102b75:	e8 53 d5 ff ff       	call   f01000cd <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0102b7a:	83 ec 0c             	sub    $0xc,%esp
f0102b7d:	ff 75 e8             	pushl  -0x18(%ebp)
f0102b80:	e8 c0 eb ff ff       	call   f0101745 <page_free>
f0102b85:	83 c4 10             	add    $0x10,%esp
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102b88:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102b8e:	8b 00                	mov    (%eax),%eax
f0102b90:	6a 02                	push   $0x2
f0102b92:	6a 00                	push   $0x0
f0102b94:	ff 75 ec             	pushl  -0x14(%ebp)
f0102b97:	50                   	push   %eax
f0102b98:	e8 c3 ed ff ff       	call   f0101960 <page_insert>
f0102b9d:	83 c4 10             	add    $0x10,%esp
f0102ba0:	85 c0                	test   %eax,%eax
f0102ba2:	74 1f                	je     f0102bc3 <check_page+0x254>
f0102ba4:	8d 83 4c 61 f7 ff    	lea    -0x89eb4(%ebx),%eax
f0102baa:	50                   	push   %eax
f0102bab:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102bb1:	50                   	push   %eax
f0102bb2:	68 6a 03 00 00       	push   $0x36a
f0102bb7:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102bbd:	50                   	push   %eax
f0102bbe:	e8 0a d5 ff ff       	call   f01000cd <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102bc3:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102bc9:	8b 00                	mov    (%eax),%eax
f0102bcb:	8b 00                	mov    (%eax),%eax
f0102bcd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102bd2:	89 c6                	mov    %eax,%esi
f0102bd4:	83 ec 0c             	sub    $0xc,%esp
f0102bd7:	ff 75 e8             	pushl  -0x18(%ebp)
f0102bda:	e8 e7 e4 ff ff       	call   f01010c6 <page2pa>
f0102bdf:	83 c4 10             	add    $0x10,%esp
f0102be2:	39 c6                	cmp    %eax,%esi
f0102be4:	74 1f                	je     f0102c05 <check_page+0x296>
f0102be6:	8d 83 7c 61 f7 ff    	lea    -0x89e84(%ebx),%eax
f0102bec:	50                   	push   %eax
f0102bed:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102bf3:	50                   	push   %eax
f0102bf4:	68 6b 03 00 00       	push   $0x36b
f0102bf9:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102bff:	50                   	push   %eax
f0102c00:	e8 c8 d4 ff ff       	call   f01000cd <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102c05:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102c0b:	8b 00                	mov    (%eax),%eax
f0102c0d:	83 ec 08             	sub    $0x8,%esp
f0102c10:	6a 00                	push   $0x0
f0102c12:	50                   	push   %eax
f0102c13:	e8 b7 fc ff ff       	call   f01028cf <check_va2pa>
f0102c18:	83 c4 10             	add    $0x10,%esp
f0102c1b:	89 c6                	mov    %eax,%esi
f0102c1d:	83 ec 0c             	sub    $0xc,%esp
f0102c20:	ff 75 ec             	pushl  -0x14(%ebp)
f0102c23:	e8 9e e4 ff ff       	call   f01010c6 <page2pa>
f0102c28:	83 c4 10             	add    $0x10,%esp
f0102c2b:	39 c6                	cmp    %eax,%esi
f0102c2d:	74 1f                	je     f0102c4e <check_page+0x2df>
f0102c2f:	8d 83 a4 61 f7 ff    	lea    -0x89e5c(%ebx),%eax
f0102c35:	50                   	push   %eax
f0102c36:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102c3c:	50                   	push   %eax
f0102c3d:	68 6c 03 00 00       	push   $0x36c
f0102c42:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102c48:	50                   	push   %eax
f0102c49:	e8 7f d4 ff ff       	call   f01000cd <_panic>
	assert(pp1->pp_ref == 1);
f0102c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0102c51:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0102c55:	66 83 f8 01          	cmp    $0x1,%ax
f0102c59:	74 1f                	je     f0102c7a <check_page+0x30b>
f0102c5b:	8d 83 d1 61 f7 ff    	lea    -0x89e2f(%ebx),%eax
f0102c61:	50                   	push   %eax
f0102c62:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102c68:	50                   	push   %eax
f0102c69:	68 6d 03 00 00       	push   $0x36d
f0102c6e:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102c74:	50                   	push   %eax
f0102c75:	e8 53 d4 ff ff       	call   f01000cd <_panic>
	assert(pp0->pp_ref == 1);
f0102c7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0102c7d:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0102c81:	66 83 f8 01          	cmp    $0x1,%ax
f0102c85:	74 1f                	je     f0102ca6 <check_page+0x337>
f0102c87:	8d 83 e2 61 f7 ff    	lea    -0x89e1e(%ebx),%eax
f0102c8d:	50                   	push   %eax
f0102c8e:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102c94:	50                   	push   %eax
f0102c95:	68 6e 03 00 00       	push   $0x36e
f0102c9a:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102ca0:	50                   	push   %eax
f0102ca1:	e8 27 d4 ff ff       	call   f01000cd <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102ca6:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102cac:	8b 00                	mov    (%eax),%eax
f0102cae:	6a 02                	push   $0x2
f0102cb0:	68 00 10 00 00       	push   $0x1000
f0102cb5:	ff 75 f0             	pushl  -0x10(%ebp)
f0102cb8:	50                   	push   %eax
f0102cb9:	e8 a2 ec ff ff       	call   f0101960 <page_insert>
f0102cbe:	83 c4 10             	add    $0x10,%esp
f0102cc1:	85 c0                	test   %eax,%eax
f0102cc3:	74 1f                	je     f0102ce4 <check_page+0x375>
f0102cc5:	8d 83 f4 61 f7 ff    	lea    -0x89e0c(%ebx),%eax
f0102ccb:	50                   	push   %eax
f0102ccc:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102cd2:	50                   	push   %eax
f0102cd3:	68 71 03 00 00       	push   $0x371
f0102cd8:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102cde:	50                   	push   %eax
f0102cdf:	e8 e9 d3 ff ff       	call   f01000cd <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102ce4:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102cea:	8b 00                	mov    (%eax),%eax
f0102cec:	83 ec 08             	sub    $0x8,%esp
f0102cef:	68 00 10 00 00       	push   $0x1000
f0102cf4:	50                   	push   %eax
f0102cf5:	e8 d5 fb ff ff       	call   f01028cf <check_va2pa>
f0102cfa:	83 c4 10             	add    $0x10,%esp
f0102cfd:	89 c6                	mov    %eax,%esi
f0102cff:	83 ec 0c             	sub    $0xc,%esp
f0102d02:	ff 75 f0             	pushl  -0x10(%ebp)
f0102d05:	e8 bc e3 ff ff       	call   f01010c6 <page2pa>
f0102d0a:	83 c4 10             	add    $0x10,%esp
f0102d0d:	39 c6                	cmp    %eax,%esi
f0102d0f:	74 1f                	je     f0102d30 <check_page+0x3c1>
f0102d11:	8d 83 30 62 f7 ff    	lea    -0x89dd0(%ebx),%eax
f0102d17:	50                   	push   %eax
f0102d18:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102d1e:	50                   	push   %eax
f0102d1f:	68 72 03 00 00       	push   $0x372
f0102d24:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102d2a:	50                   	push   %eax
f0102d2b:	e8 9d d3 ff ff       	call   f01000cd <_panic>
	assert(pp2->pp_ref == 1);
f0102d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102d33:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0102d37:	66 83 f8 01          	cmp    $0x1,%ax
f0102d3b:	74 1f                	je     f0102d5c <check_page+0x3ed>
f0102d3d:	8d 83 60 62 f7 ff    	lea    -0x89da0(%ebx),%eax
f0102d43:	50                   	push   %eax
f0102d44:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102d4a:	50                   	push   %eax
f0102d4b:	68 73 03 00 00       	push   $0x373
f0102d50:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102d56:	50                   	push   %eax
f0102d57:	e8 71 d3 ff ff       	call   f01000cd <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f0102d5c:	83 ec 0c             	sub    $0xc,%esp
f0102d5f:	6a 00                	push   $0x0
f0102d61:	e8 65 e9 ff ff       	call   f01016cb <page_alloc>
f0102d66:	83 c4 10             	add    $0x10,%esp
f0102d69:	85 c0                	test   %eax,%eax
f0102d6b:	74 1f                	je     f0102d8c <check_page+0x41d>
f0102d6d:	8d 83 17 5f f7 ff    	lea    -0x8a0e9(%ebx),%eax
f0102d73:	50                   	push   %eax
f0102d74:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102d7a:	50                   	push   %eax
f0102d7b:	68 76 03 00 00       	push   $0x376
f0102d80:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102d86:	50                   	push   %eax
f0102d87:	e8 41 d3 ff ff       	call   f01000cd <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102d8c:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102d92:	8b 00                	mov    (%eax),%eax
f0102d94:	6a 02                	push   $0x2
f0102d96:	68 00 10 00 00       	push   $0x1000
f0102d9b:	ff 75 f0             	pushl  -0x10(%ebp)
f0102d9e:	50                   	push   %eax
f0102d9f:	e8 bc eb ff ff       	call   f0101960 <page_insert>
f0102da4:	83 c4 10             	add    $0x10,%esp
f0102da7:	85 c0                	test   %eax,%eax
f0102da9:	74 1f                	je     f0102dca <check_page+0x45b>
f0102dab:	8d 83 f4 61 f7 ff    	lea    -0x89e0c(%ebx),%eax
f0102db1:	50                   	push   %eax
f0102db2:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102db8:	50                   	push   %eax
f0102db9:	68 79 03 00 00       	push   $0x379
f0102dbe:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102dc4:	50                   	push   %eax
f0102dc5:	e8 03 d3 ff ff       	call   f01000cd <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102dca:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102dd0:	8b 00                	mov    (%eax),%eax
f0102dd2:	83 ec 08             	sub    $0x8,%esp
f0102dd5:	68 00 10 00 00       	push   $0x1000
f0102dda:	50                   	push   %eax
f0102ddb:	e8 ef fa ff ff       	call   f01028cf <check_va2pa>
f0102de0:	83 c4 10             	add    $0x10,%esp
f0102de3:	89 c6                	mov    %eax,%esi
f0102de5:	83 ec 0c             	sub    $0xc,%esp
f0102de8:	ff 75 f0             	pushl  -0x10(%ebp)
f0102deb:	e8 d6 e2 ff ff       	call   f01010c6 <page2pa>
f0102df0:	83 c4 10             	add    $0x10,%esp
f0102df3:	39 c6                	cmp    %eax,%esi
f0102df5:	74 1f                	je     f0102e16 <check_page+0x4a7>
f0102df7:	8d 83 30 62 f7 ff    	lea    -0x89dd0(%ebx),%eax
f0102dfd:	50                   	push   %eax
f0102dfe:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102e04:	50                   	push   %eax
f0102e05:	68 7a 03 00 00       	push   $0x37a
f0102e0a:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102e10:	50                   	push   %eax
f0102e11:	e8 b7 d2 ff ff       	call   f01000cd <_panic>
	assert(pp2->pp_ref == 1);
f0102e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102e19:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0102e1d:	66 83 f8 01          	cmp    $0x1,%ax
f0102e21:	74 1f                	je     f0102e42 <check_page+0x4d3>
f0102e23:	8d 83 60 62 f7 ff    	lea    -0x89da0(%ebx),%eax
f0102e29:	50                   	push   %eax
f0102e2a:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102e30:	50                   	push   %eax
f0102e31:	68 7b 03 00 00       	push   $0x37b
f0102e36:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102e3c:	50                   	push   %eax
f0102e3d:	e8 8b d2 ff ff       	call   f01000cd <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0102e42:	83 ec 0c             	sub    $0xc,%esp
f0102e45:	6a 00                	push   $0x0
f0102e47:	e8 7f e8 ff ff       	call   f01016cb <page_alloc>
f0102e4c:	83 c4 10             	add    $0x10,%esp
f0102e4f:	85 c0                	test   %eax,%eax
f0102e51:	74 1f                	je     f0102e72 <check_page+0x503>
f0102e53:	8d 83 17 5f f7 ff    	lea    -0x8a0e9(%ebx),%eax
f0102e59:	50                   	push   %eax
f0102e5a:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102e60:	50                   	push   %eax
f0102e61:	68 7f 03 00 00       	push   $0x37f
f0102e66:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102e6c:	50                   	push   %eax
f0102e6d:	e8 5b d2 ff ff       	call   f01000cd <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0102e72:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102e78:	8b 00                	mov    (%eax),%eax
f0102e7a:	8b 00                	mov    (%eax),%eax
f0102e7c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102e81:	83 ec 04             	sub    $0x4,%esp
f0102e84:	50                   	push   %eax
f0102e85:	68 82 03 00 00       	push   $0x382
f0102e8a:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102e90:	50                   	push   %eax
f0102e91:	e8 e7 e1 ff ff       	call   f010107d <_kaddr>
f0102e96:	83 c4 10             	add    $0x10,%esp
f0102e99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102e9c:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102ea2:	8b 00                	mov    (%eax),%eax
f0102ea4:	83 ec 04             	sub    $0x4,%esp
f0102ea7:	6a 00                	push   $0x0
f0102ea9:	68 00 10 00 00       	push   $0x1000
f0102eae:	50                   	push   %eax
f0102eaf:	e8 34 e9 ff ff       	call   f01017e8 <pgdir_walk>
f0102eb4:	83 c4 10             	add    $0x10,%esp
f0102eb7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0102eba:	83 c2 04             	add    $0x4,%edx
f0102ebd:	39 d0                	cmp    %edx,%eax
f0102ebf:	74 1f                	je     f0102ee0 <check_page+0x571>
f0102ec1:	8d 83 74 62 f7 ff    	lea    -0x89d8c(%ebx),%eax
f0102ec7:	50                   	push   %eax
f0102ec8:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102ece:	50                   	push   %eax
f0102ecf:	68 83 03 00 00       	push   $0x383
f0102ed4:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102eda:	50                   	push   %eax
f0102edb:	e8 ed d1 ff ff       	call   f01000cd <_panic>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102ee0:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102ee6:	8b 00                	mov    (%eax),%eax
f0102ee8:	6a 06                	push   $0x6
f0102eea:	68 00 10 00 00       	push   $0x1000
f0102eef:	ff 75 f0             	pushl  -0x10(%ebp)
f0102ef2:	50                   	push   %eax
f0102ef3:	e8 68 ea ff ff       	call   f0101960 <page_insert>
f0102ef8:	83 c4 10             	add    $0x10,%esp
f0102efb:	85 c0                	test   %eax,%eax
f0102efd:	74 1f                	je     f0102f1e <check_page+0x5af>
f0102eff:	8d 83 b4 62 f7 ff    	lea    -0x89d4c(%ebx),%eax
f0102f05:	50                   	push   %eax
f0102f06:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102f0c:	50                   	push   %eax
f0102f0d:	68 86 03 00 00       	push   $0x386
f0102f12:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102f18:	50                   	push   %eax
f0102f19:	e8 af d1 ff ff       	call   f01000cd <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102f1e:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102f24:	8b 00                	mov    (%eax),%eax
f0102f26:	83 ec 08             	sub    $0x8,%esp
f0102f29:	68 00 10 00 00       	push   $0x1000
f0102f2e:	50                   	push   %eax
f0102f2f:	e8 9b f9 ff ff       	call   f01028cf <check_va2pa>
f0102f34:	83 c4 10             	add    $0x10,%esp
f0102f37:	89 c6                	mov    %eax,%esi
f0102f39:	83 ec 0c             	sub    $0xc,%esp
f0102f3c:	ff 75 f0             	pushl  -0x10(%ebp)
f0102f3f:	e8 82 e1 ff ff       	call   f01010c6 <page2pa>
f0102f44:	83 c4 10             	add    $0x10,%esp
f0102f47:	39 c6                	cmp    %eax,%esi
f0102f49:	74 1f                	je     f0102f6a <check_page+0x5fb>
f0102f4b:	8d 83 30 62 f7 ff    	lea    -0x89dd0(%ebx),%eax
f0102f51:	50                   	push   %eax
f0102f52:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102f58:	50                   	push   %eax
f0102f59:	68 87 03 00 00       	push   $0x387
f0102f5e:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102f64:	50                   	push   %eax
f0102f65:	e8 63 d1 ff ff       	call   f01000cd <_panic>
	assert(pp2->pp_ref == 1);
f0102f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0102f6d:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0102f71:	66 83 f8 01          	cmp    $0x1,%ax
f0102f75:	74 1f                	je     f0102f96 <check_page+0x627>
f0102f77:	8d 83 60 62 f7 ff    	lea    -0x89da0(%ebx),%eax
f0102f7d:	50                   	push   %eax
f0102f7e:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102f84:	50                   	push   %eax
f0102f85:	68 88 03 00 00       	push   $0x388
f0102f8a:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102f90:	50                   	push   %eax
f0102f91:	e8 37 d1 ff ff       	call   f01000cd <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102f96:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102f9c:	8b 00                	mov    (%eax),%eax
f0102f9e:	83 ec 04             	sub    $0x4,%esp
f0102fa1:	6a 00                	push   $0x0
f0102fa3:	68 00 10 00 00       	push   $0x1000
f0102fa8:	50                   	push   %eax
f0102fa9:	e8 3a e8 ff ff       	call   f01017e8 <pgdir_walk>
f0102fae:	83 c4 10             	add    $0x10,%esp
f0102fb1:	8b 00                	mov    (%eax),%eax
f0102fb3:	83 e0 04             	and    $0x4,%eax
f0102fb6:	85 c0                	test   %eax,%eax
f0102fb8:	75 1f                	jne    f0102fd9 <check_page+0x66a>
f0102fba:	8d 83 f4 62 f7 ff    	lea    -0x89d0c(%ebx),%eax
f0102fc0:	50                   	push   %eax
f0102fc1:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102fc7:	50                   	push   %eax
f0102fc8:	68 89 03 00 00       	push   $0x389
f0102fcd:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0102fd3:	50                   	push   %eax
f0102fd4:	e8 f4 d0 ff ff       	call   f01000cd <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102fd9:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0102fdf:	8b 00                	mov    (%eax),%eax
f0102fe1:	8b 00                	mov    (%eax),%eax
f0102fe3:	83 e0 04             	and    $0x4,%eax
f0102fe6:	85 c0                	test   %eax,%eax
f0102fe8:	75 1f                	jne    f0103009 <check_page+0x69a>
f0102fea:	8d 83 27 63 f7 ff    	lea    -0x89cd9(%ebx),%eax
f0102ff0:	50                   	push   %eax
f0102ff1:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0102ff7:	50                   	push   %eax
f0102ff8:	68 8a 03 00 00       	push   $0x38a
f0102ffd:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103003:	50                   	push   %eax
f0103004:	e8 c4 d0 ff ff       	call   f01000cd <_panic>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0103009:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f010300f:	8b 00                	mov    (%eax),%eax
f0103011:	6a 02                	push   $0x2
f0103013:	68 00 10 00 00       	push   $0x1000
f0103018:	ff 75 f0             	pushl  -0x10(%ebp)
f010301b:	50                   	push   %eax
f010301c:	e8 3f e9 ff ff       	call   f0101960 <page_insert>
f0103021:	83 c4 10             	add    $0x10,%esp
f0103024:	85 c0                	test   %eax,%eax
f0103026:	74 1f                	je     f0103047 <check_page+0x6d8>
f0103028:	8d 83 f4 61 f7 ff    	lea    -0x89e0c(%ebx),%eax
f010302e:	50                   	push   %eax
f010302f:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103035:	50                   	push   %eax
f0103036:	68 8d 03 00 00       	push   $0x38d
f010303b:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103041:	50                   	push   %eax
f0103042:	e8 86 d0 ff ff       	call   f01000cd <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0103047:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f010304d:	8b 00                	mov    (%eax),%eax
f010304f:	83 ec 04             	sub    $0x4,%esp
f0103052:	6a 00                	push   $0x0
f0103054:	68 00 10 00 00       	push   $0x1000
f0103059:	50                   	push   %eax
f010305a:	e8 89 e7 ff ff       	call   f01017e8 <pgdir_walk>
f010305f:	83 c4 10             	add    $0x10,%esp
f0103062:	8b 00                	mov    (%eax),%eax
f0103064:	83 e0 02             	and    $0x2,%eax
f0103067:	85 c0                	test   %eax,%eax
f0103069:	75 1f                	jne    f010308a <check_page+0x71b>
f010306b:	8d 83 40 63 f7 ff    	lea    -0x89cc0(%ebx),%eax
f0103071:	50                   	push   %eax
f0103072:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103078:	50                   	push   %eax
f0103079:	68 8e 03 00 00       	push   $0x38e
f010307e:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103084:	50                   	push   %eax
f0103085:	e8 43 d0 ff ff       	call   f01000cd <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010308a:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103090:	8b 00                	mov    (%eax),%eax
f0103092:	83 ec 04             	sub    $0x4,%esp
f0103095:	6a 00                	push   $0x0
f0103097:	68 00 10 00 00       	push   $0x1000
f010309c:	50                   	push   %eax
f010309d:	e8 46 e7 ff ff       	call   f01017e8 <pgdir_walk>
f01030a2:	83 c4 10             	add    $0x10,%esp
f01030a5:	8b 00                	mov    (%eax),%eax
f01030a7:	83 e0 04             	and    $0x4,%eax
f01030aa:	85 c0                	test   %eax,%eax
f01030ac:	74 1f                	je     f01030cd <check_page+0x75e>
f01030ae:	8d 83 74 63 f7 ff    	lea    -0x89c8c(%ebx),%eax
f01030b4:	50                   	push   %eax
f01030b5:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01030bb:	50                   	push   %eax
f01030bc:	68 8f 03 00 00       	push   $0x38f
f01030c1:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01030c7:	50                   	push   %eax
f01030c8:	e8 00 d0 ff ff       	call   f01000cd <_panic>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f01030cd:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f01030d3:	8b 00                	mov    (%eax),%eax
f01030d5:	6a 02                	push   $0x2
f01030d7:	68 00 00 40 00       	push   $0x400000
f01030dc:	ff 75 e8             	pushl  -0x18(%ebp)
f01030df:	50                   	push   %eax
f01030e0:	e8 7b e8 ff ff       	call   f0101960 <page_insert>
f01030e5:	83 c4 10             	add    $0x10,%esp
f01030e8:	85 c0                	test   %eax,%eax
f01030ea:	78 1f                	js     f010310b <check_page+0x79c>
f01030ec:	8d 83 ac 63 f7 ff    	lea    -0x89c54(%ebx),%eax
f01030f2:	50                   	push   %eax
f01030f3:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01030f9:	50                   	push   %eax
f01030fa:	68 92 03 00 00       	push   $0x392
f01030ff:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103105:	50                   	push   %eax
f0103106:	e8 c2 cf ff ff       	call   f01000cd <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f010310b:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103111:	8b 00                	mov    (%eax),%eax
f0103113:	6a 02                	push   $0x2
f0103115:	68 00 10 00 00       	push   $0x1000
f010311a:	ff 75 ec             	pushl  -0x14(%ebp)
f010311d:	50                   	push   %eax
f010311e:	e8 3d e8 ff ff       	call   f0101960 <page_insert>
f0103123:	83 c4 10             	add    $0x10,%esp
f0103126:	85 c0                	test   %eax,%eax
f0103128:	74 1f                	je     f0103149 <check_page+0x7da>
f010312a:	8d 83 e4 63 f7 ff    	lea    -0x89c1c(%ebx),%eax
f0103130:	50                   	push   %eax
f0103131:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103137:	50                   	push   %eax
f0103138:	68 95 03 00 00       	push   $0x395
f010313d:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103143:	50                   	push   %eax
f0103144:	e8 84 cf ff ff       	call   f01000cd <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0103149:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f010314f:	8b 00                	mov    (%eax),%eax
f0103151:	83 ec 04             	sub    $0x4,%esp
f0103154:	6a 00                	push   $0x0
f0103156:	68 00 10 00 00       	push   $0x1000
f010315b:	50                   	push   %eax
f010315c:	e8 87 e6 ff ff       	call   f01017e8 <pgdir_walk>
f0103161:	83 c4 10             	add    $0x10,%esp
f0103164:	8b 00                	mov    (%eax),%eax
f0103166:	83 e0 04             	and    $0x4,%eax
f0103169:	85 c0                	test   %eax,%eax
f010316b:	74 1f                	je     f010318c <check_page+0x81d>
f010316d:	8d 83 74 63 f7 ff    	lea    -0x89c8c(%ebx),%eax
f0103173:	50                   	push   %eax
f0103174:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010317a:	50                   	push   %eax
f010317b:	68 96 03 00 00       	push   $0x396
f0103180:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103186:	50                   	push   %eax
f0103187:	e8 41 cf ff ff       	call   f01000cd <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010318c:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103192:	8b 00                	mov    (%eax),%eax
f0103194:	83 ec 08             	sub    $0x8,%esp
f0103197:	6a 00                	push   $0x0
f0103199:	50                   	push   %eax
f010319a:	e8 30 f7 ff ff       	call   f01028cf <check_va2pa>
f010319f:	83 c4 10             	add    $0x10,%esp
f01031a2:	89 c6                	mov    %eax,%esi
f01031a4:	83 ec 0c             	sub    $0xc,%esp
f01031a7:	ff 75 ec             	pushl  -0x14(%ebp)
f01031aa:	e8 17 df ff ff       	call   f01010c6 <page2pa>
f01031af:	83 c4 10             	add    $0x10,%esp
f01031b2:	39 c6                	cmp    %eax,%esi
f01031b4:	74 1f                	je     f01031d5 <check_page+0x866>
f01031b6:	8d 83 20 64 f7 ff    	lea    -0x89be0(%ebx),%eax
f01031bc:	50                   	push   %eax
f01031bd:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01031c3:	50                   	push   %eax
f01031c4:	68 99 03 00 00       	push   $0x399
f01031c9:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01031cf:	50                   	push   %eax
f01031d0:	e8 f8 ce ff ff       	call   f01000cd <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01031d5:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f01031db:	8b 00                	mov    (%eax),%eax
f01031dd:	83 ec 08             	sub    $0x8,%esp
f01031e0:	68 00 10 00 00       	push   $0x1000
f01031e5:	50                   	push   %eax
f01031e6:	e8 e4 f6 ff ff       	call   f01028cf <check_va2pa>
f01031eb:	83 c4 10             	add    $0x10,%esp
f01031ee:	89 c6                	mov    %eax,%esi
f01031f0:	83 ec 0c             	sub    $0xc,%esp
f01031f3:	ff 75 ec             	pushl  -0x14(%ebp)
f01031f6:	e8 cb de ff ff       	call   f01010c6 <page2pa>
f01031fb:	83 c4 10             	add    $0x10,%esp
f01031fe:	39 c6                	cmp    %eax,%esi
f0103200:	74 1f                	je     f0103221 <check_page+0x8b2>
f0103202:	8d 83 4c 64 f7 ff    	lea    -0x89bb4(%ebx),%eax
f0103208:	50                   	push   %eax
f0103209:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010320f:	50                   	push   %eax
f0103210:	68 9a 03 00 00       	push   $0x39a
f0103215:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010321b:	50                   	push   %eax
f010321c:	e8 ac ce ff ff       	call   f01000cd <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0103221:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0103224:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0103228:	66 83 f8 02          	cmp    $0x2,%ax
f010322c:	74 1f                	je     f010324d <check_page+0x8de>
f010322e:	8d 83 7c 64 f7 ff    	lea    -0x89b84(%ebx),%eax
f0103234:	50                   	push   %eax
f0103235:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010323b:	50                   	push   %eax
f010323c:	68 9c 03 00 00       	push   $0x39c
f0103241:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103247:	50                   	push   %eax
f0103248:	e8 80 ce ff ff       	call   f01000cd <_panic>
	assert(pp2->pp_ref == 0);
f010324d:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103250:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0103254:	66 85 c0             	test   %ax,%ax
f0103257:	74 1f                	je     f0103278 <check_page+0x909>
f0103259:	8d 83 8d 64 f7 ff    	lea    -0x89b73(%ebx),%eax
f010325f:	50                   	push   %eax
f0103260:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103266:	50                   	push   %eax
f0103267:	68 9d 03 00 00       	push   $0x39d
f010326c:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103272:	50                   	push   %eax
f0103273:	e8 55 ce ff ff       	call   f01000cd <_panic>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0103278:	83 ec 0c             	sub    $0xc,%esp
f010327b:	6a 00                	push   $0x0
f010327d:	e8 49 e4 ff ff       	call   f01016cb <page_alloc>
f0103282:	83 c4 10             	add    $0x10,%esp
f0103285:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103288:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010328c:	74 08                	je     f0103296 <check_page+0x927>
f010328e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103291:	3b 45 f0             	cmp    -0x10(%ebp),%eax
f0103294:	74 1f                	je     f01032b5 <check_page+0x946>
f0103296:	8d 83 a0 64 f7 ff    	lea    -0x89b60(%ebx),%eax
f010329c:	50                   	push   %eax
f010329d:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01032a3:	50                   	push   %eax
f01032a4:	68 a0 03 00 00       	push   $0x3a0
f01032a9:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01032af:	50                   	push   %eax
f01032b0:	e8 18 ce ff ff       	call   f01000cd <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f01032b5:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f01032bb:	8b 00                	mov    (%eax),%eax
f01032bd:	83 ec 08             	sub    $0x8,%esp
f01032c0:	6a 00                	push   $0x0
f01032c2:	50                   	push   %eax
f01032c3:	e8 85 e7 ff ff       	call   f0101a4d <page_remove>
f01032c8:	83 c4 10             	add    $0x10,%esp
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01032cb:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f01032d1:	8b 00                	mov    (%eax),%eax
f01032d3:	83 ec 08             	sub    $0x8,%esp
f01032d6:	6a 00                	push   $0x0
f01032d8:	50                   	push   %eax
f01032d9:	e8 f1 f5 ff ff       	call   f01028cf <check_va2pa>
f01032de:	83 c4 10             	add    $0x10,%esp
f01032e1:	83 f8 ff             	cmp    $0xffffffff,%eax
f01032e4:	74 1f                	je     f0103305 <check_page+0x996>
f01032e6:	8d 83 c4 64 f7 ff    	lea    -0x89b3c(%ebx),%eax
f01032ec:	50                   	push   %eax
f01032ed:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01032f3:	50                   	push   %eax
f01032f4:	68 a4 03 00 00       	push   $0x3a4
f01032f9:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01032ff:	50                   	push   %eax
f0103300:	e8 c8 cd ff ff       	call   f01000cd <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0103305:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f010330b:	8b 00                	mov    (%eax),%eax
f010330d:	83 ec 08             	sub    $0x8,%esp
f0103310:	68 00 10 00 00       	push   $0x1000
f0103315:	50                   	push   %eax
f0103316:	e8 b4 f5 ff ff       	call   f01028cf <check_va2pa>
f010331b:	83 c4 10             	add    $0x10,%esp
f010331e:	89 c6                	mov    %eax,%esi
f0103320:	83 ec 0c             	sub    $0xc,%esp
f0103323:	ff 75 ec             	pushl  -0x14(%ebp)
f0103326:	e8 9b dd ff ff       	call   f01010c6 <page2pa>
f010332b:	83 c4 10             	add    $0x10,%esp
f010332e:	39 c6                	cmp    %eax,%esi
f0103330:	74 1f                	je     f0103351 <check_page+0x9e2>
f0103332:	8d 83 4c 64 f7 ff    	lea    -0x89bb4(%ebx),%eax
f0103338:	50                   	push   %eax
f0103339:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010333f:	50                   	push   %eax
f0103340:	68 a5 03 00 00       	push   $0x3a5
f0103345:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010334b:	50                   	push   %eax
f010334c:	e8 7c cd ff ff       	call   f01000cd <_panic>
	assert(pp1->pp_ref == 1);
f0103351:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0103354:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0103358:	66 83 f8 01          	cmp    $0x1,%ax
f010335c:	74 1f                	je     f010337d <check_page+0xa0e>
f010335e:	8d 83 d1 61 f7 ff    	lea    -0x89e2f(%ebx),%eax
f0103364:	50                   	push   %eax
f0103365:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010336b:	50                   	push   %eax
f010336c:	68 a6 03 00 00       	push   $0x3a6
f0103371:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103377:	50                   	push   %eax
f0103378:	e8 50 cd ff ff       	call   f01000cd <_panic>
	assert(pp2->pp_ref == 0);
f010337d:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0103380:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0103384:	66 85 c0             	test   %ax,%ax
f0103387:	74 1f                	je     f01033a8 <check_page+0xa39>
f0103389:	8d 83 8d 64 f7 ff    	lea    -0x89b73(%ebx),%eax
f010338f:	50                   	push   %eax
f0103390:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103396:	50                   	push   %eax
f0103397:	68 a7 03 00 00       	push   $0x3a7
f010339c:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01033a2:	50                   	push   %eax
f01033a3:	e8 25 cd ff ff       	call   f01000cd <_panic>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01033a8:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f01033ae:	8b 00                	mov    (%eax),%eax
f01033b0:	6a 00                	push   $0x0
f01033b2:	68 00 10 00 00       	push   $0x1000
f01033b7:	ff 75 ec             	pushl  -0x14(%ebp)
f01033ba:	50                   	push   %eax
f01033bb:	e8 a0 e5 ff ff       	call   f0101960 <page_insert>
f01033c0:	83 c4 10             	add    $0x10,%esp
f01033c3:	85 c0                	test   %eax,%eax
f01033c5:	74 1f                	je     f01033e6 <check_page+0xa77>
f01033c7:	8d 83 e8 64 f7 ff    	lea    -0x89b18(%ebx),%eax
f01033cd:	50                   	push   %eax
f01033ce:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01033d4:	50                   	push   %eax
f01033d5:	68 aa 03 00 00       	push   $0x3aa
f01033da:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01033e0:	50                   	push   %eax
f01033e1:	e8 e7 cc ff ff       	call   f01000cd <_panic>
	assert(pp1->pp_ref);
f01033e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01033e9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f01033ed:	66 85 c0             	test   %ax,%ax
f01033f0:	75 1f                	jne    f0103411 <check_page+0xaa2>
f01033f2:	8d 83 1d 65 f7 ff    	lea    -0x89ae3(%ebx),%eax
f01033f8:	50                   	push   %eax
f01033f9:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01033ff:	50                   	push   %eax
f0103400:	68 ab 03 00 00       	push   $0x3ab
f0103405:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010340b:	50                   	push   %eax
f010340c:	e8 bc cc ff ff       	call   f01000cd <_panic>
	assert(pp1->pp_link == NULL);
f0103411:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0103414:	8b 00                	mov    (%eax),%eax
f0103416:	85 c0                	test   %eax,%eax
f0103418:	74 1f                	je     f0103439 <check_page+0xaca>
f010341a:	8d 83 29 65 f7 ff    	lea    -0x89ad7(%ebx),%eax
f0103420:	50                   	push   %eax
f0103421:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103427:	50                   	push   %eax
f0103428:	68 ac 03 00 00       	push   $0x3ac
f010342d:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103433:	50                   	push   %eax
f0103434:	e8 94 cc ff ff       	call   f01000cd <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0103439:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f010343f:	8b 00                	mov    (%eax),%eax
f0103441:	83 ec 08             	sub    $0x8,%esp
f0103444:	68 00 10 00 00       	push   $0x1000
f0103449:	50                   	push   %eax
f010344a:	e8 fe e5 ff ff       	call   f0101a4d <page_remove>
f010344f:	83 c4 10             	add    $0x10,%esp
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0103452:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103458:	8b 00                	mov    (%eax),%eax
f010345a:	83 ec 08             	sub    $0x8,%esp
f010345d:	6a 00                	push   $0x0
f010345f:	50                   	push   %eax
f0103460:	e8 6a f4 ff ff       	call   f01028cf <check_va2pa>
f0103465:	83 c4 10             	add    $0x10,%esp
f0103468:	83 f8 ff             	cmp    $0xffffffff,%eax
f010346b:	74 1f                	je     f010348c <check_page+0xb1d>
f010346d:	8d 83 c4 64 f7 ff    	lea    -0x89b3c(%ebx),%eax
f0103473:	50                   	push   %eax
f0103474:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010347a:	50                   	push   %eax
f010347b:	68 b0 03 00 00       	push   $0x3b0
f0103480:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103486:	50                   	push   %eax
f0103487:	e8 41 cc ff ff       	call   f01000cd <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f010348c:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103492:	8b 00                	mov    (%eax),%eax
f0103494:	83 ec 08             	sub    $0x8,%esp
f0103497:	68 00 10 00 00       	push   $0x1000
f010349c:	50                   	push   %eax
f010349d:	e8 2d f4 ff ff       	call   f01028cf <check_va2pa>
f01034a2:	83 c4 10             	add    $0x10,%esp
f01034a5:	83 f8 ff             	cmp    $0xffffffff,%eax
f01034a8:	74 1f                	je     f01034c9 <check_page+0xb5a>
f01034aa:	8d 83 40 65 f7 ff    	lea    -0x89ac0(%ebx),%eax
f01034b0:	50                   	push   %eax
f01034b1:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01034b7:	50                   	push   %eax
f01034b8:	68 b1 03 00 00       	push   $0x3b1
f01034bd:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01034c3:	50                   	push   %eax
f01034c4:	e8 04 cc ff ff       	call   f01000cd <_panic>
	assert(pp1->pp_ref == 0);
f01034c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01034cc:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f01034d0:	66 85 c0             	test   %ax,%ax
f01034d3:	74 1f                	je     f01034f4 <check_page+0xb85>
f01034d5:	8d 83 66 65 f7 ff    	lea    -0x89a9a(%ebx),%eax
f01034db:	50                   	push   %eax
f01034dc:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01034e2:	50                   	push   %eax
f01034e3:	68 b2 03 00 00       	push   $0x3b2
f01034e8:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01034ee:	50                   	push   %eax
f01034ef:	e8 d9 cb ff ff       	call   f01000cd <_panic>
	assert(pp2->pp_ref == 0);
f01034f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01034f7:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f01034fb:	66 85 c0             	test   %ax,%ax
f01034fe:	74 1f                	je     f010351f <check_page+0xbb0>
f0103500:	8d 83 8d 64 f7 ff    	lea    -0x89b73(%ebx),%eax
f0103506:	50                   	push   %eax
f0103507:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010350d:	50                   	push   %eax
f010350e:	68 b3 03 00 00       	push   $0x3b3
f0103513:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103519:	50                   	push   %eax
f010351a:	e8 ae cb ff ff       	call   f01000cd <_panic>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f010351f:	83 ec 0c             	sub    $0xc,%esp
f0103522:	6a 00                	push   $0x0
f0103524:	e8 a2 e1 ff ff       	call   f01016cb <page_alloc>
f0103529:	83 c4 10             	add    $0x10,%esp
f010352c:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010352f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0103533:	74 08                	je     f010353d <check_page+0xbce>
f0103535:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103538:	3b 45 ec             	cmp    -0x14(%ebp),%eax
f010353b:	74 1f                	je     f010355c <check_page+0xbed>
f010353d:	8d 83 78 65 f7 ff    	lea    -0x89a88(%ebx),%eax
f0103543:	50                   	push   %eax
f0103544:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010354a:	50                   	push   %eax
f010354b:	68 b6 03 00 00       	push   $0x3b6
f0103550:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103556:	50                   	push   %eax
f0103557:	e8 71 cb ff ff       	call   f01000cd <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f010355c:	83 ec 0c             	sub    $0xc,%esp
f010355f:	6a 00                	push   $0x0
f0103561:	e8 65 e1 ff ff       	call   f01016cb <page_alloc>
f0103566:	83 c4 10             	add    $0x10,%esp
f0103569:	85 c0                	test   %eax,%eax
f010356b:	74 1f                	je     f010358c <check_page+0xc1d>
f010356d:	8d 83 17 5f f7 ff    	lea    -0x8a0e9(%ebx),%eax
f0103573:	50                   	push   %eax
f0103574:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010357a:	50                   	push   %eax
f010357b:	68 b9 03 00 00       	push   $0x3b9
f0103580:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103586:	50                   	push   %eax
f0103587:	e8 41 cb ff ff       	call   f01000cd <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010358c:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103592:	8b 00                	mov    (%eax),%eax
f0103594:	8b 00                	mov    (%eax),%eax
f0103596:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010359b:	89 c6                	mov    %eax,%esi
f010359d:	83 ec 0c             	sub    $0xc,%esp
f01035a0:	ff 75 e8             	pushl  -0x18(%ebp)
f01035a3:	e8 1e db ff ff       	call   f01010c6 <page2pa>
f01035a8:	83 c4 10             	add    $0x10,%esp
f01035ab:	39 c6                	cmp    %eax,%esi
f01035ad:	74 1f                	je     f01035ce <check_page+0xc5f>
f01035af:	8d 83 7c 61 f7 ff    	lea    -0x89e84(%ebx),%eax
f01035b5:	50                   	push   %eax
f01035b6:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01035bc:	50                   	push   %eax
f01035bd:	68 bc 03 00 00       	push   $0x3bc
f01035c2:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01035c8:	50                   	push   %eax
f01035c9:	e8 ff ca ff ff       	call   f01000cd <_panic>
	kern_pgdir[0] = 0;
f01035ce:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f01035d4:	8b 00                	mov    (%eax),%eax
f01035d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f01035dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01035df:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f01035e3:	66 83 f8 01          	cmp    $0x1,%ax
f01035e7:	74 1f                	je     f0103608 <check_page+0xc99>
f01035e9:	8d 83 e2 61 f7 ff    	lea    -0x89e1e(%ebx),%eax
f01035ef:	50                   	push   %eax
f01035f0:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01035f6:	50                   	push   %eax
f01035f7:	68 be 03 00 00       	push   $0x3be
f01035fc:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103602:	50                   	push   %eax
f0103603:	e8 c5 ca ff ff       	call   f01000cd <_panic>
	pp0->pp_ref = 0;
f0103608:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010360b:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0103611:	83 ec 0c             	sub    $0xc,%esp
f0103614:	ff 75 e8             	pushl  -0x18(%ebp)
f0103617:	e8 29 e1 ff ff       	call   f0101745 <page_free>
f010361c:	83 c4 10             	add    $0x10,%esp
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
f010361f:	c7 45 dc 00 10 40 00 	movl   $0x401000,-0x24(%ebp)
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0103626:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f010362c:	8b 00                	mov    (%eax),%eax
f010362e:	83 ec 04             	sub    $0x4,%esp
f0103631:	6a 01                	push   $0x1
f0103633:	ff 75 dc             	pushl  -0x24(%ebp)
f0103636:	50                   	push   %eax
f0103637:	e8 ac e1 ff ff       	call   f01017e8 <pgdir_walk>
f010363c:	83 c4 10             	add    $0x10,%esp
f010363f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0103642:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103648:	8b 00                	mov    (%eax),%eax
f010364a:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010364d:	c1 ea 16             	shr    $0x16,%edx
f0103650:	c1 e2 02             	shl    $0x2,%edx
f0103653:	01 d0                	add    %edx,%eax
f0103655:	8b 00                	mov    (%eax),%eax
f0103657:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010365c:	83 ec 04             	sub    $0x4,%esp
f010365f:	50                   	push   %eax
f0103660:	68 c5 03 00 00       	push   $0x3c5
f0103665:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010366b:	50                   	push   %eax
f010366c:	e8 0c da ff ff       	call   f010107d <_kaddr>
f0103671:	83 c4 10             	add    $0x10,%esp
f0103674:	89 45 d8             	mov    %eax,-0x28(%ebp)
	assert(ptep == ptep1 + PTX(va));
f0103677:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010367a:	c1 e8 0c             	shr    $0xc,%eax
f010367d:	25 ff 03 00 00       	and    $0x3ff,%eax
f0103682:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f0103689:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010368c:	01 c2                	add    %eax,%edx
f010368e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103691:	39 c2                	cmp    %eax,%edx
f0103693:	74 1f                	je     f01036b4 <check_page+0xd45>
f0103695:	8d 83 9a 65 f7 ff    	lea    -0x89a66(%ebx),%eax
f010369b:	50                   	push   %eax
f010369c:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01036a2:	50                   	push   %eax
f01036a3:	68 c6 03 00 00       	push   $0x3c6
f01036a8:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01036ae:	50                   	push   %eax
f01036af:	e8 19 ca ff ff       	call   f01000cd <_panic>
	kern_pgdir[PDX(va)] = 0;
f01036b4:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f01036ba:	8b 00                	mov    (%eax),%eax
f01036bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01036bf:	c1 ea 16             	shr    $0x16,%edx
f01036c2:	c1 e2 02             	shl    $0x2,%edx
f01036c5:	01 d0                	add    %edx,%eax
f01036c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f01036cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01036d0:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f01036d6:	83 ec 0c             	sub    $0xc,%esp
f01036d9:	ff 75 e8             	pushl  -0x18(%ebp)
f01036dc:	e8 60 da ff ff       	call   f0101141 <page2kva>
f01036e1:	83 c4 10             	add    $0x10,%esp
f01036e4:	83 ec 04             	sub    $0x4,%esp
f01036e7:	68 00 10 00 00       	push   $0x1000
f01036ec:	68 ff 00 00 00       	push   $0xff
f01036f1:	50                   	push   %eax
f01036f2:	e8 29 35 00 00       	call   f0106c20 <memset>
f01036f7:	83 c4 10             	add    $0x10,%esp
	page_free(pp0);
f01036fa:	83 ec 0c             	sub    $0xc,%esp
f01036fd:	ff 75 e8             	pushl  -0x18(%ebp)
f0103700:	e8 40 e0 ff ff       	call   f0101745 <page_free>
f0103705:	83 c4 10             	add    $0x10,%esp
	pgdir_walk(kern_pgdir, 0x0, 1);
f0103708:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f010370e:	8b 00                	mov    (%eax),%eax
f0103710:	83 ec 04             	sub    $0x4,%esp
f0103713:	6a 01                	push   $0x1
f0103715:	6a 00                	push   $0x0
f0103717:	50                   	push   %eax
f0103718:	e8 cb e0 ff ff       	call   f01017e8 <pgdir_walk>
f010371d:	83 c4 10             	add    $0x10,%esp
	ptep = (pte_t *) page2kva(pp0);
f0103720:	83 ec 0c             	sub    $0xc,%esp
f0103723:	ff 75 e8             	pushl  -0x18(%ebp)
f0103726:	e8 16 da ff ff       	call   f0101141 <page2kva>
f010372b:	83 c4 10             	add    $0x10,%esp
f010372e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for(i=0; i<NPTENTRIES; i++)
f0103731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0103738:	eb 37                	jmp    f0103771 <check_page+0xe02>
		assert((ptep[i] & PTE_P) == 0);
f010373a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010373d:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0103740:	c1 e2 02             	shl    $0x2,%edx
f0103743:	01 d0                	add    %edx,%eax
f0103745:	8b 00                	mov    (%eax),%eax
f0103747:	83 e0 01             	and    $0x1,%eax
f010374a:	85 c0                	test   %eax,%eax
f010374c:	74 1f                	je     f010376d <check_page+0xdfe>
f010374e:	8d 83 b2 65 f7 ff    	lea    -0x89a4e(%ebx),%eax
f0103754:	50                   	push   %eax
f0103755:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010375b:	50                   	push   %eax
f010375c:	68 d0 03 00 00       	push   $0x3d0
f0103761:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103767:	50                   	push   %eax
f0103768:	e8 60 c9 ff ff       	call   f01000cd <_panic>
	for(i=0; i<NPTENTRIES; i++)
f010376d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0103771:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
f0103778:	7e c0                	jle    f010373a <check_page+0xdcb>
	kern_pgdir[0] = 0;
f010377a:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103780:	8b 00                	mov    (%eax),%eax
f0103782:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0103788:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010378b:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0103791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103794:	89 83 3c 19 00 00    	mov    %eax,0x193c(%ebx)

	// free the pages we took
	page_free(pp0);
f010379a:	83 ec 0c             	sub    $0xc,%esp
f010379d:	ff 75 e8             	pushl  -0x18(%ebp)
f01037a0:	e8 a0 df ff ff       	call   f0101745 <page_free>
f01037a5:	83 c4 10             	add    $0x10,%esp
	page_free(pp1);
f01037a8:	83 ec 0c             	sub    $0xc,%esp
f01037ab:	ff 75 ec             	pushl  -0x14(%ebp)
f01037ae:	e8 92 df ff ff       	call   f0101745 <page_free>
f01037b3:	83 c4 10             	add    $0x10,%esp
	page_free(pp2);
f01037b6:	83 ec 0c             	sub    $0xc,%esp
f01037b9:	ff 75 f0             	pushl  -0x10(%ebp)
f01037bc:	e8 84 df ff ff       	call   f0101745 <page_free>
f01037c1:	83 c4 10             	add    $0x10,%esp

	cprintf("check_page() succeeded!\n");
f01037c4:	83 ec 0c             	sub    $0xc,%esp
f01037c7:	8d 83 c9 65 f7 ff    	lea    -0x89a37(%ebx),%eax
f01037cd:	50                   	push   %eax
f01037ce:	e8 92 10 00 00       	call   f0104865 <cprintf>
f01037d3:	83 c4 10             	add    $0x10,%esp
}
f01037d6:	90                   	nop
f01037d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01037da:	5b                   	pop    %ebx
f01037db:	5e                   	pop    %esi
f01037dc:	5d                   	pop    %ebp
f01037dd:	c3                   	ret    

f01037de <check_page_installed_pgdir>:

// check page_insert, page_remove, &c, with an installed kern_pgdir
static void
check_page_installed_pgdir(void)
{
f01037de:	f3 0f 1e fb          	endbr32 
f01037e2:	55                   	push   %ebp
f01037e3:	89 e5                	mov    %esp,%ebp
f01037e5:	56                   	push   %esi
f01037e6:	53                   	push   %ebx
f01037e7:	83 ec 10             	sub    $0x10,%esp
f01037ea:	e8 bf c9 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f01037ef:	81 c3 c5 e1 08 00    	add    $0x8e1c5,%ebx
	pte_t *ptep, *ptep1;
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
f01037f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01037fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01037ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	assert((pp0 = page_alloc(0)));
f0103802:	83 ec 0c             	sub    $0xc,%esp
f0103805:	6a 00                	push   $0x0
f0103807:	e8 bf de ff ff       	call   f01016cb <page_alloc>
f010380c:	83 c4 10             	add    $0x10,%esp
f010380f:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0103812:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f0103816:	75 1f                	jne    f0103837 <check_page_installed_pgdir+0x59>
f0103818:	8d 83 46 5e f7 ff    	lea    -0x8a1ba(%ebx),%eax
f010381e:	50                   	push   %eax
f010381f:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103825:	50                   	push   %eax
f0103826:	68 eb 03 00 00       	push   $0x3eb
f010382b:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103831:	50                   	push   %eax
f0103832:	e8 96 c8 ff ff       	call   f01000cd <_panic>
	assert((pp1 = page_alloc(0)));
f0103837:	83 ec 0c             	sub    $0xc,%esp
f010383a:	6a 00                	push   $0x0
f010383c:	e8 8a de ff ff       	call   f01016cb <page_alloc>
f0103841:	83 c4 10             	add    $0x10,%esp
f0103844:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0103847:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f010384b:	75 1f                	jne    f010386c <check_page_installed_pgdir+0x8e>
f010384d:	8d 83 5c 5e f7 ff    	lea    -0x8a1a4(%ebx),%eax
f0103853:	50                   	push   %eax
f0103854:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010385a:	50                   	push   %eax
f010385b:	68 ec 03 00 00       	push   $0x3ec
f0103860:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103866:	50                   	push   %eax
f0103867:	e8 61 c8 ff ff       	call   f01000cd <_panic>
	assert((pp2 = page_alloc(0)));
f010386c:	83 ec 0c             	sub    $0xc,%esp
f010386f:	6a 00                	push   $0x0
f0103871:	e8 55 de ff ff       	call   f01016cb <page_alloc>
f0103876:	83 c4 10             	add    $0x10,%esp
f0103879:	89 45 f4             	mov    %eax,-0xc(%ebp)
f010387c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0103880:	75 1f                	jne    f01038a1 <check_page_installed_pgdir+0xc3>
f0103882:	8d 83 72 5e f7 ff    	lea    -0x8a18e(%ebx),%eax
f0103888:	50                   	push   %eax
f0103889:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010388f:	50                   	push   %eax
f0103890:	68 ed 03 00 00       	push   $0x3ed
f0103895:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010389b:	50                   	push   %eax
f010389c:	e8 2c c8 ff ff       	call   f01000cd <_panic>
	page_free(pp0);
f01038a1:	83 ec 0c             	sub    $0xc,%esp
f01038a4:	ff 75 ec             	pushl  -0x14(%ebp)
f01038a7:	e8 99 de ff ff       	call   f0101745 <page_free>
f01038ac:	83 c4 10             	add    $0x10,%esp
	memset(page2kva(pp1), 1, PGSIZE);
f01038af:	83 ec 0c             	sub    $0xc,%esp
f01038b2:	ff 75 f0             	pushl  -0x10(%ebp)
f01038b5:	e8 87 d8 ff ff       	call   f0101141 <page2kva>
f01038ba:	83 c4 10             	add    $0x10,%esp
f01038bd:	83 ec 04             	sub    $0x4,%esp
f01038c0:	68 00 10 00 00       	push   $0x1000
f01038c5:	6a 01                	push   $0x1
f01038c7:	50                   	push   %eax
f01038c8:	e8 53 33 00 00       	call   f0106c20 <memset>
f01038cd:	83 c4 10             	add    $0x10,%esp
	memset(page2kva(pp2), 2, PGSIZE);
f01038d0:	83 ec 0c             	sub    $0xc,%esp
f01038d3:	ff 75 f4             	pushl  -0xc(%ebp)
f01038d6:	e8 66 d8 ff ff       	call   f0101141 <page2kva>
f01038db:	83 c4 10             	add    $0x10,%esp
f01038de:	83 ec 04             	sub    $0x4,%esp
f01038e1:	68 00 10 00 00       	push   $0x1000
f01038e6:	6a 02                	push   $0x2
f01038e8:	50                   	push   %eax
f01038e9:	e8 32 33 00 00       	call   f0106c20 <memset>
f01038ee:	83 c4 10             	add    $0x10,%esp
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f01038f1:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f01038f7:	8b 00                	mov    (%eax),%eax
f01038f9:	6a 02                	push   $0x2
f01038fb:	68 00 10 00 00       	push   $0x1000
f0103900:	ff 75 f0             	pushl  -0x10(%ebp)
f0103903:	50                   	push   %eax
f0103904:	e8 57 e0 ff ff       	call   f0101960 <page_insert>
f0103909:	83 c4 10             	add    $0x10,%esp
	assert(pp1->pp_ref == 1);
f010390c:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010390f:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0103913:	66 83 f8 01          	cmp    $0x1,%ax
f0103917:	74 1f                	je     f0103938 <check_page_installed_pgdir+0x15a>
f0103919:	8d 83 d1 61 f7 ff    	lea    -0x89e2f(%ebx),%eax
f010391f:	50                   	push   %eax
f0103920:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103926:	50                   	push   %eax
f0103927:	68 f2 03 00 00       	push   $0x3f2
f010392c:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103932:	50                   	push   %eax
f0103933:	e8 95 c7 ff ff       	call   f01000cd <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0103938:	b8 00 10 00 00       	mov    $0x1000,%eax
f010393d:	8b 00                	mov    (%eax),%eax
f010393f:	3d 01 01 01 01       	cmp    $0x1010101,%eax
f0103944:	74 1f                	je     f0103965 <check_page_installed_pgdir+0x187>
f0103946:	8d 83 e4 65 f7 ff    	lea    -0x89a1c(%ebx),%eax
f010394c:	50                   	push   %eax
f010394d:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103953:	50                   	push   %eax
f0103954:	68 f3 03 00 00       	push   $0x3f3
f0103959:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f010395f:	50                   	push   %eax
f0103960:	e8 68 c7 ff ff       	call   f01000cd <_panic>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0103965:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f010396b:	8b 00                	mov    (%eax),%eax
f010396d:	6a 02                	push   $0x2
f010396f:	68 00 10 00 00       	push   $0x1000
f0103974:	ff 75 f4             	pushl  -0xc(%ebp)
f0103977:	50                   	push   %eax
f0103978:	e8 e3 df ff ff       	call   f0101960 <page_insert>
f010397d:	83 c4 10             	add    $0x10,%esp
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103980:	b8 00 10 00 00       	mov    $0x1000,%eax
f0103985:	8b 00                	mov    (%eax),%eax
f0103987:	3d 02 02 02 02       	cmp    $0x2020202,%eax
f010398c:	74 1f                	je     f01039ad <check_page_installed_pgdir+0x1cf>
f010398e:	8d 83 08 66 f7 ff    	lea    -0x899f8(%ebx),%eax
f0103994:	50                   	push   %eax
f0103995:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f010399b:	50                   	push   %eax
f010399c:	68 f5 03 00 00       	push   $0x3f5
f01039a1:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01039a7:	50                   	push   %eax
f01039a8:	e8 20 c7 ff ff       	call   f01000cd <_panic>
	assert(pp2->pp_ref == 1);
f01039ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01039b0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f01039b4:	66 83 f8 01          	cmp    $0x1,%ax
f01039b8:	74 1f                	je     f01039d9 <check_page_installed_pgdir+0x1fb>
f01039ba:	8d 83 60 62 f7 ff    	lea    -0x89da0(%ebx),%eax
f01039c0:	50                   	push   %eax
f01039c1:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01039c7:	50                   	push   %eax
f01039c8:	68 f6 03 00 00       	push   $0x3f6
f01039cd:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01039d3:	50                   	push   %eax
f01039d4:	e8 f4 c6 ff ff       	call   f01000cd <_panic>
	assert(pp1->pp_ref == 0);
f01039d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01039dc:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f01039e0:	66 85 c0             	test   %ax,%ax
f01039e3:	74 1f                	je     f0103a04 <check_page_installed_pgdir+0x226>
f01039e5:	8d 83 66 65 f7 ff    	lea    -0x89a9a(%ebx),%eax
f01039eb:	50                   	push   %eax
f01039ec:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f01039f2:	50                   	push   %eax
f01039f3:	68 f7 03 00 00       	push   $0x3f7
f01039f8:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f01039fe:	50                   	push   %eax
f01039ff:	e8 c9 c6 ff ff       	call   f01000cd <_panic>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0103a04:	b8 00 10 00 00       	mov    $0x1000,%eax
f0103a09:	c7 00 03 03 03 03    	movl   $0x3030303,(%eax)
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103a0f:	83 ec 0c             	sub    $0xc,%esp
f0103a12:	ff 75 f4             	pushl  -0xc(%ebp)
f0103a15:	e8 27 d7 ff ff       	call   f0101141 <page2kva>
f0103a1a:	83 c4 10             	add    $0x10,%esp
f0103a1d:	8b 00                	mov    (%eax),%eax
f0103a1f:	3d 03 03 03 03       	cmp    $0x3030303,%eax
f0103a24:	74 1f                	je     f0103a45 <check_page_installed_pgdir+0x267>
f0103a26:	8d 83 2c 66 f7 ff    	lea    -0x899d4(%ebx),%eax
f0103a2c:	50                   	push   %eax
f0103a2d:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103a33:	50                   	push   %eax
f0103a34:	68 f9 03 00 00       	push   $0x3f9
f0103a39:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103a3f:	50                   	push   %eax
f0103a40:	e8 88 c6 ff ff       	call   f01000cd <_panic>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0103a45:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103a4b:	8b 00                	mov    (%eax),%eax
f0103a4d:	83 ec 08             	sub    $0x8,%esp
f0103a50:	68 00 10 00 00       	push   $0x1000
f0103a55:	50                   	push   %eax
f0103a56:	e8 f2 df ff ff       	call   f0101a4d <page_remove>
f0103a5b:	83 c4 10             	add    $0x10,%esp
	assert(pp2->pp_ref == 0);
f0103a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103a61:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0103a65:	66 85 c0             	test   %ax,%ax
f0103a68:	74 1f                	je     f0103a89 <check_page_installed_pgdir+0x2ab>
f0103a6a:	8d 83 8d 64 f7 ff    	lea    -0x89b73(%ebx),%eax
f0103a70:	50                   	push   %eax
f0103a71:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103a77:	50                   	push   %eax
f0103a78:	68 fb 03 00 00       	push   $0x3fb
f0103a7d:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103a83:	50                   	push   %eax
f0103a84:	e8 44 c6 ff ff       	call   f01000cd <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103a89:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103a8f:	8b 00                	mov    (%eax),%eax
f0103a91:	8b 00                	mov    (%eax),%eax
f0103a93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103a98:	89 c6                	mov    %eax,%esi
f0103a9a:	83 ec 0c             	sub    $0xc,%esp
f0103a9d:	ff 75 ec             	pushl  -0x14(%ebp)
f0103aa0:	e8 21 d6 ff ff       	call   f01010c6 <page2pa>
f0103aa5:	83 c4 10             	add    $0x10,%esp
f0103aa8:	39 c6                	cmp    %eax,%esi
f0103aaa:	74 1f                	je     f0103acb <check_page_installed_pgdir+0x2ed>
f0103aac:	8d 83 7c 61 f7 ff    	lea    -0x89e84(%ebx),%eax
f0103ab2:	50                   	push   %eax
f0103ab3:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103ab9:	50                   	push   %eax
f0103aba:	68 fe 03 00 00       	push   $0x3fe
f0103abf:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103ac5:	50                   	push   %eax
f0103ac6:	e8 02 c6 ff ff       	call   f01000cd <_panic>
	kern_pgdir[0] = 0;
f0103acb:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103ad1:	8b 00                	mov    (%eax),%eax
f0103ad3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0103ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0103adc:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0103ae0:	66 83 f8 01          	cmp    $0x1,%ax
f0103ae4:	74 1f                	je     f0103b05 <check_page_installed_pgdir+0x327>
f0103ae6:	8d 83 e2 61 f7 ff    	lea    -0x89e1e(%ebx),%eax
f0103aec:	50                   	push   %eax
f0103aed:	8d 83 d8 5c f7 ff    	lea    -0x8a328(%ebx),%eax
f0103af3:	50                   	push   %eax
f0103af4:	68 00 04 00 00       	push   $0x400
f0103af9:	8d 83 e7 5b f7 ff    	lea    -0x8a419(%ebx),%eax
f0103aff:	50                   	push   %eax
f0103b00:	e8 c8 c5 ff ff       	call   f01000cd <_panic>
	pp0->pp_ref = 0;
f0103b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0103b08:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// free the pages we took
	page_free(pp0);
f0103b0e:	83 ec 0c             	sub    $0xc,%esp
f0103b11:	ff 75 ec             	pushl  -0x14(%ebp)
f0103b14:	e8 2c dc ff ff       	call   f0101745 <page_free>
f0103b19:	83 c4 10             	add    $0x10,%esp

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0103b1c:	83 ec 0c             	sub    $0xc,%esp
f0103b1f:	8d 83 58 66 f7 ff    	lea    -0x899a8(%ebx),%eax
f0103b25:	50                   	push   %eax
f0103b26:	e8 3a 0d 00 00       	call   f0104865 <cprintf>
f0103b2b:	83 c4 10             	add    $0x10,%esp
}
f0103b2e:	90                   	nop
f0103b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103b32:	5b                   	pop    %ebx
f0103b33:	5e                   	pop    %esi
f0103b34:	5d                   	pop    %ebp
f0103b35:	c3                   	ret    

f0103b36 <lgdt>:
{
f0103b36:	55                   	push   %ebp
f0103b37:	89 e5                	mov    %esp,%ebp
f0103b39:	e8 c1 cf ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0103b3e:	05 76 de 08 00       	add    $0x8de76,%eax
	asm volatile("lgdt (%0)" : : "r" (p));
f0103b43:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b46:	0f 01 10             	lgdtl  (%eax)
}
f0103b49:	90                   	nop
f0103b4a:	5d                   	pop    %ebp
f0103b4b:	c3                   	ret    

f0103b4c <lldt>:
{
f0103b4c:	55                   	push   %ebp
f0103b4d:	89 e5                	mov    %esp,%ebp
f0103b4f:	83 ec 04             	sub    $0x4,%esp
f0103b52:	e8 a8 cf ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0103b57:	05 5d de 08 00       	add    $0x8de5d,%eax
f0103b5c:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b5f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
	asm volatile("lldt %0" : : "r" (sel));
f0103b63:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
f0103b67:	0f 00 d0             	lldt   %ax
}
f0103b6a:	90                   	nop
f0103b6b:	c9                   	leave  
f0103b6c:	c3                   	ret    

f0103b6d <lcr3>:
{
f0103b6d:	55                   	push   %ebp
f0103b6e:	89 e5                	mov    %esp,%ebp
f0103b70:	e8 8a cf ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0103b75:	05 3f de 08 00       	add    $0x8de3f,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103b7a:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b7d:	0f 22 d8             	mov    %eax,%cr3
}
f0103b80:	90                   	nop
f0103b81:	5d                   	pop    %ebp
f0103b82:	c3                   	ret    

f0103b83 <_paddr>:
{
f0103b83:	55                   	push   %ebp
f0103b84:	89 e5                	mov    %esp,%ebp
f0103b86:	53                   	push   %ebx
f0103b87:	83 ec 04             	sub    $0x4,%esp
f0103b8a:	e8 70 cf ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0103b8f:	05 25 de 08 00       	add    $0x8de25,%eax
	if ((uint32_t)kva < KERNBASE)
f0103b94:	8b 55 10             	mov    0x10(%ebp),%edx
f0103b97:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0103b9d:	77 17                	ja     f0103bb6 <_paddr+0x33>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103b9f:	ff 75 10             	pushl  0x10(%ebp)
f0103ba2:	8d 90 84 66 f7 ff    	lea    -0x8997c(%eax),%edx
f0103ba8:	52                   	push   %edx
f0103ba9:	ff 75 0c             	pushl  0xc(%ebp)
f0103bac:	ff 75 08             	pushl  0x8(%ebp)
f0103baf:	89 c3                	mov    %eax,%ebx
f0103bb1:	e8 17 c5 ff ff       	call   f01000cd <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103bb6:	8b 45 10             	mov    0x10(%ebp),%eax
f0103bb9:	05 00 00 00 10       	add    $0x10000000,%eax
}
f0103bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103bc1:	c9                   	leave  
f0103bc2:	c3                   	ret    

f0103bc3 <_kaddr>:
{
f0103bc3:	55                   	push   %ebp
f0103bc4:	89 e5                	mov    %esp,%ebp
f0103bc6:	53                   	push   %ebx
f0103bc7:	83 ec 04             	sub    $0x4,%esp
f0103bca:	e8 30 cf ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0103bcf:	05 e5 dd 08 00       	add    $0x8dde5,%eax
	if (PGNUM(pa) >= npages)
f0103bd4:	8b 55 10             	mov    0x10(%ebp),%edx
f0103bd7:	89 d1                	mov    %edx,%ecx
f0103bd9:	c1 e9 0c             	shr    $0xc,%ecx
f0103bdc:	c7 c2 a8 3f 19 f0    	mov    $0xf0193fa8,%edx
f0103be2:	8b 12                	mov    (%edx),%edx
f0103be4:	39 d1                	cmp    %edx,%ecx
f0103be6:	72 17                	jb     f0103bff <_kaddr+0x3c>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103be8:	ff 75 10             	pushl  0x10(%ebp)
f0103beb:	8d 90 a8 66 f7 ff    	lea    -0x89958(%eax),%edx
f0103bf1:	52                   	push   %edx
f0103bf2:	ff 75 0c             	pushl  0xc(%ebp)
f0103bf5:	ff 75 08             	pushl  0x8(%ebp)
f0103bf8:	89 c3                	mov    %eax,%ebx
f0103bfa:	e8 ce c4 ff ff       	call   f01000cd <_panic>
	return (void *)(pa + KERNBASE);
f0103bff:	8b 45 10             	mov    0x10(%ebp),%eax
f0103c02:	2d 00 00 00 10       	sub    $0x10000000,%eax
}
f0103c07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103c0a:	c9                   	leave  
f0103c0b:	c3                   	ret    

f0103c0c <page2pa>:
{
f0103c0c:	55                   	push   %ebp
f0103c0d:	89 e5                	mov    %esp,%ebp
f0103c0f:	e8 eb ce ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0103c14:	05 a0 dd 08 00       	add    $0x8dda0,%eax
	return (pp - pages) << PGSHIFT;
f0103c19:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f0103c1f:	8b 00                	mov    (%eax),%eax
f0103c21:	8b 55 08             	mov    0x8(%ebp),%edx
f0103c24:	29 c2                	sub    %eax,%edx
f0103c26:	89 d0                	mov    %edx,%eax
f0103c28:	c1 f8 03             	sar    $0x3,%eax
f0103c2b:	c1 e0 0c             	shl    $0xc,%eax
}
f0103c2e:	5d                   	pop    %ebp
f0103c2f:	c3                   	ret    

f0103c30 <pa2page>:
{
f0103c30:	55                   	push   %ebp
f0103c31:	89 e5                	mov    %esp,%ebp
f0103c33:	53                   	push   %ebx
f0103c34:	83 ec 04             	sub    $0x4,%esp
f0103c37:	e8 c3 ce ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0103c3c:	05 78 dd 08 00       	add    $0x8dd78,%eax
	if (PGNUM(pa) >= npages)
f0103c41:	8b 55 08             	mov    0x8(%ebp),%edx
f0103c44:	89 d1                	mov    %edx,%ecx
f0103c46:	c1 e9 0c             	shr    $0xc,%ecx
f0103c49:	c7 c2 a8 3f 19 f0    	mov    $0xf0193fa8,%edx
f0103c4f:	8b 12                	mov    (%edx),%edx
f0103c51:	39 d1                	cmp    %edx,%ecx
f0103c53:	72 1a                	jb     f0103c6f <pa2page+0x3f>
		panic("pa2page called with invalid pa");
f0103c55:	83 ec 04             	sub    $0x4,%esp
f0103c58:	8d 90 cc 66 f7 ff    	lea    -0x89934(%eax),%edx
f0103c5e:	52                   	push   %edx
f0103c5f:	6a 4f                	push   $0x4f
f0103c61:	8d 90 eb 66 f7 ff    	lea    -0x89915(%eax),%edx
f0103c67:	52                   	push   %edx
f0103c68:	89 c3                	mov    %eax,%ebx
f0103c6a:	e8 5e c4 ff ff       	call   f01000cd <_panic>
	return &pages[PGNUM(pa)];
f0103c6f:	c7 c0 b0 3f 19 f0    	mov    $0xf0193fb0,%eax
f0103c75:	8b 00                	mov    (%eax),%eax
f0103c77:	8b 55 08             	mov    0x8(%ebp),%edx
f0103c7a:	c1 ea 0c             	shr    $0xc,%edx
f0103c7d:	c1 e2 03             	shl    $0x3,%edx
f0103c80:	01 d0                	add    %edx,%eax
}
f0103c82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103c85:	c9                   	leave  
f0103c86:	c3                   	ret    

f0103c87 <page2kva>:
{
f0103c87:	55                   	push   %ebp
f0103c88:	89 e5                	mov    %esp,%ebp
f0103c8a:	53                   	push   %ebx
f0103c8b:	83 ec 04             	sub    $0x4,%esp
f0103c8e:	e8 1b c5 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0103c93:	81 c3 21 dd 08 00    	add    $0x8dd21,%ebx
	return KADDR(page2pa(pp));
f0103c99:	ff 75 08             	pushl  0x8(%ebp)
f0103c9c:	e8 6b ff ff ff       	call   f0103c0c <page2pa>
f0103ca1:	83 c4 04             	add    $0x4,%esp
f0103ca4:	83 ec 04             	sub    $0x4,%esp
f0103ca7:	50                   	push   %eax
f0103ca8:	6a 56                	push   $0x56
f0103caa:	8d 83 eb 66 f7 ff    	lea    -0x89915(%ebx),%eax
f0103cb0:	50                   	push   %eax
f0103cb1:	e8 0d ff ff ff       	call   f0103bc3 <_kaddr>
f0103cb6:	83 c4 10             	add    $0x10,%esp
}
f0103cb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103cbc:	c9                   	leave  
f0103cbd:	c3                   	ret    

f0103cbe <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f0103cbe:	f3 0f 1e fb          	endbr32 
f0103cc2:	55                   	push   %ebp
f0103cc3:	89 e5                	mov    %esp,%ebp
f0103cc5:	53                   	push   %ebx
f0103cc6:	83 ec 14             	sub    $0x14,%esp
f0103cc9:	e8 79 0a 00 00       	call   f0104747 <__x86.get_pc_thunk.dx>
f0103cce:	81 c2 e6 dc 08 00    	add    $0x8dce6,%edx
f0103cd4:	8b 45 10             	mov    0x10(%ebp),%eax
f0103cd7:	88 45 e8             	mov    %al,-0x18(%ebp)
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0103cda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0103cde:	75 15                	jne    f0103cf5 <envid2env+0x37>
		*env_store = curenv;
f0103ce0:	8b 92 4c 19 00 00    	mov    0x194c(%edx),%edx
f0103ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103ce9:	89 10                	mov    %edx,(%eax)
		return 0;
f0103ceb:	b8 00 00 00 00       	mov    $0x0,%eax
f0103cf0:	e9 84 00 00 00       	jmp    f0103d79 <envid2env+0xbb>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f0103cf5:	8b 9a 48 19 00 00    	mov    0x1948(%edx),%ebx
f0103cfb:	8b 45 08             	mov    0x8(%ebp),%eax
f0103cfe:	25 ff 03 00 00       	and    $0x3ff,%eax
f0103d03:	89 c1                	mov    %eax,%ecx
f0103d05:	89 c8                	mov    %ecx,%eax
f0103d07:	01 c0                	add    %eax,%eax
f0103d09:	01 c8                	add    %ecx,%eax
f0103d0b:	c1 e0 05             	shl    $0x5,%eax
f0103d0e:	01 d8                	add    %ebx,%eax
f0103d10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103d13:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0103d16:	8b 40 54             	mov    0x54(%eax),%eax
f0103d19:	85 c0                	test   %eax,%eax
f0103d1b:	74 0b                	je     f0103d28 <envid2env+0x6a>
f0103d1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0103d20:	8b 40 48             	mov    0x48(%eax),%eax
f0103d23:	39 45 08             	cmp    %eax,0x8(%ebp)
f0103d26:	74 10                	je     f0103d38 <envid2env+0x7a>
		*env_store = 0;
f0103d28:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103d2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103d31:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103d36:	eb 41                	jmp    f0103d79 <envid2env+0xbb>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103d38:	80 7d e8 00          	cmpb   $0x0,-0x18(%ebp)
f0103d3c:	74 2e                	je     f0103d6c <envid2env+0xae>
f0103d3e:	8b 82 4c 19 00 00    	mov    0x194c(%edx),%eax
f0103d44:	39 45 f8             	cmp    %eax,-0x8(%ebp)
f0103d47:	74 23                	je     f0103d6c <envid2env+0xae>
f0103d49:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0103d4c:	8b 48 4c             	mov    0x4c(%eax),%ecx
f0103d4f:	8b 82 4c 19 00 00    	mov    0x194c(%edx),%eax
f0103d55:	8b 40 48             	mov    0x48(%eax),%eax
f0103d58:	39 c1                	cmp    %eax,%ecx
f0103d5a:	74 10                	je     f0103d6c <envid2env+0xae>
		*env_store = 0;
f0103d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103d5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103d65:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103d6a:	eb 0d                	jmp    f0103d79 <envid2env+0xbb>
	}

	*env_store = e;
f0103d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103d6f:	8b 55 f8             	mov    -0x8(%ebp),%edx
f0103d72:	89 10                	mov    %edx,(%eax)
	return 0;
f0103d74:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103d79:	83 c4 14             	add    $0x14,%esp
f0103d7c:	5b                   	pop    %ebx
f0103d7d:	5d                   	pop    %ebp
f0103d7e:	c3                   	ret    

f0103d7f <env_init>:
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
{
f0103d7f:	f3 0f 1e fb          	endbr32 
f0103d83:	55                   	push   %ebp
f0103d84:	89 e5                	mov    %esp,%ebp
f0103d86:	57                   	push   %edi
f0103d87:	56                   	push   %esi
f0103d88:	53                   	push   %ebx
f0103d89:	83 ec 1c             	sub    $0x1c,%esp
f0103d8c:	e8 6e cd ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0103d91:	05 23 dc 08 00       	add    $0x8dc23,%eax
	// Set up envs array
	// LAB 3: Your code here.
	assert(envs != NULL);	// Make sure the envs is allocated successfully
f0103d96:	8b 90 48 19 00 00    	mov    0x1948(%eax),%edx
f0103d9c:	85 d2                	test   %edx,%edx
f0103d9e:	75 1e                	jne    f0103dbe <env_init+0x3f>
f0103da0:	8d 90 f9 66 f7 ff    	lea    -0x89907(%eax),%edx
f0103da6:	52                   	push   %edx
f0103da7:	8d 90 06 67 f7 ff    	lea    -0x898fa(%eax),%edx
f0103dad:	52                   	push   %edx
f0103dae:	6a 77                	push   $0x77
f0103db0:	8d 90 1b 67 f7 ff    	lea    -0x898e5(%eax),%edx
f0103db6:	52                   	push   %edx
f0103db7:	89 c3                	mov    %eax,%ebx
f0103db9:	e8 0f c3 ff ff       	call   f01000cd <_panic>
	assert(env_free_list == NULL);
f0103dbe:	8b 90 50 19 00 00    	mov    0x1950(%eax),%edx
f0103dc4:	85 d2                	test   %edx,%edx
f0103dc6:	74 1e                	je     f0103de6 <env_init+0x67>
f0103dc8:	8d 90 26 67 f7 ff    	lea    -0x898da(%eax),%edx
f0103dce:	52                   	push   %edx
f0103dcf:	8d 90 06 67 f7 ff    	lea    -0x898fa(%eax),%edx
f0103dd5:	52                   	push   %edx
f0103dd6:	6a 78                	push   $0x78
f0103dd8:	8d 90 1b 67 f7 ff    	lea    -0x898e5(%eax),%edx
f0103dde:	52                   	push   %edx
f0103ddf:	89 c3                	mov    %eax,%ebx
f0103de1:	e8 e7 c2 ff ff       	call   f01000cd <_panic>

	env_free_list = envs;
f0103de6:	8b 90 48 19 00 00    	mov    0x1948(%eax),%edx
f0103dec:	89 90 50 19 00 00    	mov    %edx,0x1950(%eax)
	envs[0].env_id = 0;
f0103df2:	8b 90 48 19 00 00    	mov    0x1948(%eax),%edx
f0103df8:	c7 42 48 00 00 00 00 	movl   $0x0,0x48(%edx)
	envs[0].env_link = NULL; // Not necessary
f0103dff:	8b 90 48 19 00 00    	mov    0x1948(%eax),%edx
f0103e05:	c7 42 44 00 00 00 00 	movl   $0x0,0x44(%edx)
	envs[0].env_status = ENV_FREE;
f0103e0c:	8b 90 48 19 00 00    	mov    0x1948(%eax),%edx
f0103e12:	c7 42 54 00 00 00 00 	movl   $0x0,0x54(%edx)

	for(int i = 1; i < NENV; ++i)
f0103e19:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0103e20:	eb 6e                	jmp    f0103e90 <env_init+0x111>
	{
		envs[i].env_id = 0;
f0103e22:	8b 98 48 19 00 00    	mov    0x1948(%eax),%ebx
f0103e28:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0103e2b:	89 ca                	mov    %ecx,%edx
f0103e2d:	01 d2                	add    %edx,%edx
f0103e2f:	01 ca                	add    %ecx,%edx
f0103e31:	c1 e2 05             	shl    $0x5,%edx
f0103e34:	01 da                	add    %ebx,%edx
f0103e36:	c7 42 48 00 00 00 00 	movl   $0x0,0x48(%edx)
		envs[i-1].env_link = &envs[i];
f0103e3d:	8b 98 48 19 00 00    	mov    0x1948(%eax),%ebx
f0103e43:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0103e46:	89 ca                	mov    %ecx,%edx
f0103e48:	01 d2                	add    %edx,%edx
f0103e4a:	01 ca                	add    %ecx,%edx
f0103e4c:	c1 e2 05             	shl    $0x5,%edx
f0103e4f:	89 d7                	mov    %edx,%edi
f0103e51:	8b b0 48 19 00 00    	mov    0x1948(%eax),%esi
f0103e57:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0103e5a:	89 ca                	mov    %ecx,%edx
f0103e5c:	01 d2                	add    %edx,%edx
f0103e5e:	01 ca                	add    %ecx,%edx
f0103e60:	c1 e2 05             	shl    $0x5,%edx
f0103e63:	83 ea 60             	sub    $0x60,%edx
f0103e66:	01 f2                	add    %esi,%edx
f0103e68:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
f0103e6b:	89 4a 44             	mov    %ecx,0x44(%edx)
		envs[i-1].env_status = ENV_FREE;
f0103e6e:	8b 98 48 19 00 00    	mov    0x1948(%eax),%ebx
f0103e74:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0103e77:	89 ca                	mov    %ecx,%edx
f0103e79:	01 d2                	add    %edx,%edx
f0103e7b:	01 ca                	add    %ecx,%edx
f0103e7d:	c1 e2 05             	shl    $0x5,%edx
f0103e80:	83 ea 60             	sub    $0x60,%edx
f0103e83:	01 da                	add    %ebx,%edx
f0103e85:	c7 42 54 00 00 00 00 	movl   $0x0,0x54(%edx)
	for(int i = 1; i < NENV; ++i)
f0103e8c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
f0103e90:	81 7d e4 ff 03 00 00 	cmpl   $0x3ff,-0x1c(%ebp)
f0103e97:	7e 89                	jle    f0103e22 <env_init+0xa3>
	}
	envs[NENV-1].env_link = NULL;
f0103e99:	8b 80 48 19 00 00    	mov    0x1948(%eax),%eax
f0103e9f:	05 a0 7f 01 00       	add    $0x17fa0,%eax
f0103ea4:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)

	// Per-CPU part of the initialization
	env_init_percpu();
f0103eab:	e8 09 00 00 00       	call   f0103eb9 <env_init_percpu>
}
f0103eb0:	90                   	nop
f0103eb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103eb4:	5b                   	pop    %ebx
f0103eb5:	5e                   	pop    %esi
f0103eb6:	5f                   	pop    %edi
f0103eb7:	5d                   	pop    %ebp
f0103eb8:	c3                   	ret    

f0103eb9 <env_init_percpu>:

// Load GDT and segment descriptors.
void
env_init_percpu(void)
{
f0103eb9:	f3 0f 1e fb          	endbr32 
f0103ebd:	55                   	push   %ebp
f0103ebe:	89 e5                	mov    %esp,%ebp
f0103ec0:	e8 3a cc ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0103ec5:	05 ef da 08 00       	add    $0x8daef,%eax
	lgdt(&gdt_pd);
f0103eca:	8d 80 74 16 00 00    	lea    0x1674(%eax),%eax
f0103ed0:	50                   	push   %eax
f0103ed1:	e8 60 fc ff ff       	call   f0103b36 <lgdt>
f0103ed6:	83 c4 04             	add    $0x4,%esp
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f0103ed9:	b8 23 00 00 00       	mov    $0x23,%eax
f0103ede:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f0103ee0:	b8 23 00 00 00       	mov    $0x23,%eax
f0103ee5:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f0103ee7:	b8 10 00 00 00       	mov    $0x10,%eax
f0103eec:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f0103eee:	b8 10 00 00 00       	mov    $0x10,%eax
f0103ef3:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103ef5:	b8 10 00 00 00       	mov    $0x10,%eax
f0103efa:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103efc:	ea 03 3f 10 f0 08 00 	ljmp   $0x8,$0xf0103f03
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
f0103f03:	6a 00                	push   $0x0
f0103f05:	e8 42 fc ff ff       	call   f0103b4c <lldt>
f0103f0a:	83 c4 04             	add    $0x4,%esp
}
f0103f0d:	90                   	nop
f0103f0e:	c9                   	leave  
f0103f0f:	c3                   	ret    

f0103f10 <env_setup_vm>:
// Returns 0 on success, < 0 on error.  Errors include:
//	-E_NO_MEM if page directory or table could not be allocated.
//
static int
env_setup_vm(struct Env *e)
{
f0103f10:	f3 0f 1e fb          	endbr32 
f0103f14:	55                   	push   %ebp
f0103f15:	89 e5                	mov    %esp,%ebp
f0103f17:	53                   	push   %ebx
f0103f18:	83 ec 14             	sub    $0x14,%esp
f0103f1b:	e8 8e c2 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0103f20:	81 c3 94 da 08 00    	add    $0x8da94,%ebx
	int i;
	struct PageInfo *p = NULL;
f0103f26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103f2d:	83 ec 0c             	sub    $0xc,%esp
f0103f30:	6a 01                	push   $0x1
f0103f32:	e8 94 d7 ff ff       	call   f01016cb <page_alloc>
f0103f37:	83 c4 10             	add    $0x10,%esp
f0103f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0103f3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0103f41:	75 07                	jne    f0103f4a <env_setup_vm+0x3a>
		return -E_NO_MEM;
f0103f43:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103f48:	eb 79                	jmp    f0103fc3 <env_setup_vm+0xb3>
	//	is an exception -- you need to increment env_pgdir's
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.
	e->env_pgdir = page2kva(p);
f0103f4a:	83 ec 0c             	sub    $0xc,%esp
f0103f4d:	ff 75 f4             	pushl  -0xc(%ebp)
f0103f50:	e8 32 fd ff ff       	call   f0103c87 <page2kva>
f0103f55:	83 c4 10             	add    $0x10,%esp
f0103f58:	8b 55 08             	mov    0x8(%ebp),%edx
f0103f5b:	89 42 5c             	mov    %eax,0x5c(%edx)
	// e->env_pgdir[PDX(UENVS)] = kern_pgdir[PDX(UENVS)];
	// e->env_pgdir[PDX(UPAGES)] = kern_pgdir[PDX(UPAGES)];
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f0103f5e:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0103f64:	8b 10                	mov    (%eax),%edx
f0103f66:	8b 45 08             	mov    0x8(%ebp),%eax
f0103f69:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103f6c:	83 ec 04             	sub    $0x4,%esp
f0103f6f:	68 00 10 00 00       	push   $0x1000
f0103f74:	52                   	push   %edx
f0103f75:	50                   	push   %eax
f0103f76:	e8 09 2e 00 00       	call   f0106d84 <memcpy>
f0103f7b:	83 c4 10             	add    $0x10,%esp

	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103f7e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103f81:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103f84:	83 ec 04             	sub    $0x4,%esp
f0103f87:	50                   	push   %eax
f0103f88:	68 cc 00 00 00       	push   $0xcc
f0103f8d:	8d 83 1b 67 f7 ff    	lea    -0x898e5(%ebx),%eax
f0103f93:	50                   	push   %eax
f0103f94:	e8 ea fb ff ff       	call   f0103b83 <_paddr>
f0103f99:	83 c4 10             	add    $0x10,%esp
f0103f9c:	8b 55 08             	mov    0x8(%ebp),%edx
f0103f9f:	8b 52 5c             	mov    0x5c(%edx),%edx
f0103fa2:	81 c2 f4 0e 00 00    	add    $0xef4,%edx
f0103fa8:	83 c8 05             	or     $0x5,%eax
f0103fab:	89 02                	mov    %eax,(%edx)
	
	// increment the pp_ref
	p->pp_ref++;
f0103fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103fb0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
f0103fb4:	8d 50 01             	lea    0x1(%eax),%edx
f0103fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103fba:	66 89 50 04          	mov    %dx,0x4(%eax)

	return 0;
f0103fbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103fc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103fc6:	c9                   	leave  
f0103fc7:	c3                   	ret    

f0103fc8 <env_alloc>:
//	-E_NO_FREE_ENV if all NENV environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0103fc8:	f3 0f 1e fb          	endbr32 
f0103fcc:	55                   	push   %ebp
f0103fcd:	89 e5                	mov    %esp,%ebp
f0103fcf:	53                   	push   %ebx
f0103fd0:	83 ec 14             	sub    $0x14,%esp
f0103fd3:	e8 d6 c1 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0103fd8:	81 c3 dc d9 08 00    	add    $0x8d9dc,%ebx
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
f0103fde:	8b 83 50 19 00 00    	mov    0x1950(%ebx),%eax
f0103fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0103fe7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0103feb:	75 0a                	jne    f0103ff7 <env_alloc+0x2f>
		return -E_NO_FREE_ENV;
f0103fed:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103ff2:	e9 15 01 00 00       	jmp    f010410c <env_alloc+0x144>

	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
f0103ff7:	83 ec 0c             	sub    $0xc,%esp
f0103ffa:	ff 75 f0             	pushl  -0x10(%ebp)
f0103ffd:	e8 0e ff ff ff       	call   f0103f10 <env_setup_vm>
f0104002:	83 c4 10             	add    $0x10,%esp
f0104005:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104008:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f010400c:	79 08                	jns    f0104016 <env_alloc+0x4e>
		return r;
f010400e:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104011:	e9 f6 00 00 00       	jmp    f010410c <env_alloc+0x144>

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0104016:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104019:	8b 40 48             	mov    0x48(%eax),%eax
f010401c:	05 00 10 00 00       	add    $0x1000,%eax
f0104021:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f0104026:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (generation <= 0)	// Don't create a negative env_id.
f0104029:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f010402d:	7f 07                	jg     f0104036 <env_alloc+0x6e>
		generation = 1 << ENVGENSHIFT;
f010402f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
	e->env_id = generation | (e - envs);
f0104036:	8b 83 48 19 00 00    	mov    0x1948(%ebx),%eax
f010403c:	8b 55 f0             	mov    -0x10(%ebp),%edx
f010403f:	29 c2                	sub    %eax,%edx
f0104041:	89 d0                	mov    %edx,%eax
f0104043:	c1 f8 05             	sar    $0x5,%eax
f0104046:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f010404c:	0b 45 f4             	or     -0xc(%ebp),%eax
f010404f:	89 c2                	mov    %eax,%edx
f0104051:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104054:	89 50 48             	mov    %edx,0x48(%eax)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0104057:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010405a:	8b 55 0c             	mov    0xc(%ebp),%edx
f010405d:	89 50 4c             	mov    %edx,0x4c(%eax)
	e->env_type = ENV_TYPE_USER;
f0104060:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104063:	c7 40 50 00 00 00 00 	movl   $0x0,0x50(%eax)
	e->env_status = ENV_RUNNABLE;
f010406a:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010406d:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	e->env_runs = 0;
f0104074:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104077:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f010407e:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104081:	83 ec 04             	sub    $0x4,%esp
f0104084:	6a 44                	push   $0x44
f0104086:	6a 00                	push   $0x0
f0104088:	50                   	push   %eax
f0104089:	e8 92 2b 00 00       	call   f0106c20 <memset>
f010408e:	83 c4 10             	add    $0x10,%esp
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f0104091:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104094:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
	e->env_tf.tf_es = GD_UD | 3;
f010409a:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010409d:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
	e->env_tf.tf_ss = GD_UD | 3;
f01040a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01040a6:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
	e->env_tf.tf_esp = USTACKTOP;
f01040ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01040af:	c7 40 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%eax)
	e->env_tf.tf_cs = GD_UT | 3;
f01040b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01040b9:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
	// You will set e->env_tf.tf_eip later.

	// commit the allocation
	env_free_list = e->env_link;
f01040bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01040c2:	8b 40 44             	mov    0x44(%eax),%eax
f01040c5:	89 83 50 19 00 00    	mov    %eax,0x1950(%ebx)
	*newenv_store = e;
f01040cb:	8b 45 08             	mov    0x8(%ebp),%eax
f01040ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
f01040d1:	89 10                	mov    %edx,(%eax)

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01040d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01040d6:	8b 50 48             	mov    0x48(%eax),%edx
f01040d9:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f01040df:	85 c0                	test   %eax,%eax
f01040e1:	74 0b                	je     f01040ee <env_alloc+0x126>
f01040e3:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f01040e9:	8b 40 48             	mov    0x48(%eax),%eax
f01040ec:	eb 05                	jmp    f01040f3 <env_alloc+0x12b>
f01040ee:	b8 00 00 00 00       	mov    $0x0,%eax
f01040f3:	83 ec 04             	sub    $0x4,%esp
f01040f6:	52                   	push   %edx
f01040f7:	50                   	push   %eax
f01040f8:	8d 83 3c 67 f7 ff    	lea    -0x898c4(%ebx),%eax
f01040fe:	50                   	push   %eax
f01040ff:	e8 61 07 00 00       	call   f0104865 <cprintf>
f0104104:	83 c4 10             	add    $0x10,%esp
	return 0;
f0104107:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010410c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010410f:	c9                   	leave  
f0104110:	c3                   	ret    

f0104111 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0104111:	f3 0f 1e fb          	endbr32 
f0104115:	55                   	push   %ebp
f0104116:	89 e5                	mov    %esp,%ebp
f0104118:	53                   	push   %ebx
f0104119:	83 ec 24             	sub    $0x24,%esp
f010411c:	e8 8d c0 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0104121:	81 c3 93 d8 08 00    	add    $0x8d893,%ebx
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	uintptr_t start = ROUNDDOWN((uintptr_t)(va), PGSIZE);
f0104127:	8b 45 0c             	mov    0xc(%ebp),%eax
f010412a:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010412d:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104130:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0104135:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uintptr_t end = ROUNDUP((uintptr_t)(va) + len, PGSIZE);
f0104138:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
f010413f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104142:	8b 45 10             	mov    0x10(%ebp),%eax
f0104145:	01 c2                	add    %eax,%edx
f0104147:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010414a:	01 d0                	add    %edx,%eax
f010414c:	83 e8 01             	sub    $0x1,%eax
f010414f:	89 45 e8             	mov    %eax,-0x18(%ebp)
f0104152:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0104155:	ba 00 00 00 00       	mov    $0x0,%edx
f010415a:	f7 75 ec             	divl   -0x14(%ebp)
f010415d:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0104160:	29 d0                	sub    %edx,%eax
f0104162:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if(!e)
f0104165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0104169:	75 6b                	jne    f01041d6 <region_alloc+0xc5>
		panic("region_alloc: env is NULL.\n");
f010416b:	83 ec 04             	sub    $0x4,%esp
f010416e:	8d 83 51 67 f7 ff    	lea    -0x898af(%ebx),%eax
f0104174:	50                   	push   %eax
f0104175:	68 28 01 00 00       	push   $0x128
f010417a:	8d 83 1b 67 f7 ff    	lea    -0x898e5(%ebx),%eax
f0104180:	50                   	push   %eax
f0104181:	e8 47 bf ff ff       	call   f01000cd <_panic>

	while(start < end)
	{
		struct PageInfo *p = page_alloc(0);
f0104186:	83 ec 0c             	sub    $0xc,%esp
f0104189:	6a 00                	push   $0x0
f010418b:	e8 3b d5 ff ff       	call   f01016cb <page_alloc>
f0104190:	83 c4 10             	add    $0x10,%esp
f0104193:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(!p)
f0104196:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010419a:	75 1b                	jne    f01041b7 <region_alloc+0xa6>
			panic("region_alloc: page_alloc failed.\n");
f010419c:	83 ec 04             	sub    $0x4,%esp
f010419f:	8d 83 70 67 f7 ff    	lea    -0x89890(%ebx),%eax
f01041a5:	50                   	push   %eax
f01041a6:	68 2e 01 00 00       	push   $0x12e
f01041ab:	8d 83 1b 67 f7 ff    	lea    -0x898e5(%ebx),%eax
f01041b1:	50                   	push   %eax
f01041b2:	e8 16 bf ff ff       	call   f01000cd <_panic>
		page_insert(e->env_pgdir, p, (void *)start, PTE_U | PTE_W);
f01041b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01041ba:	8b 45 08             	mov    0x8(%ebp),%eax
f01041bd:	8b 40 5c             	mov    0x5c(%eax),%eax
f01041c0:	6a 06                	push   $0x6
f01041c2:	52                   	push   %edx
f01041c3:	ff 75 e0             	pushl  -0x20(%ebp)
f01041c6:	50                   	push   %eax
f01041c7:	e8 94 d7 ff ff       	call   f0101960 <page_insert>
f01041cc:	83 c4 10             	add    $0x10,%esp
		start += PGSIZE;
f01041cf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
	while(start < end)
f01041d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01041d9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f01041dc:	72 a8                	jb     f0104186 <region_alloc+0x75>
	}

}
f01041de:	90                   	nop
f01041df:	90                   	nop
f01041e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01041e3:	c9                   	leave  
f01041e4:	c3                   	ret    

f01041e5 <load_icode>:
// load_icode panics if it encounters problems.
//  - How might load_icode fail?  What might be wrong with the given input?
//
static void
load_icode(struct Env *e, uint8_t *binary)
{
f01041e5:	f3 0f 1e fb          	endbr32 
f01041e9:	55                   	push   %ebp
f01041ea:	89 e5                	mov    %esp,%ebp
f01041ec:	56                   	push   %esi
f01041ed:	53                   	push   %ebx
f01041ee:	83 ec 10             	sub    $0x10,%esp
f01041f1:	e8 b8 bf ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f01041f6:	81 c3 be d7 08 00    	add    $0x8d7be,%ebx
	//  You must also do something with the program's entry point,
	//  to make sure that the environment starts executing there.
	//  What?  (See env_run() and env_pop_tf() below.)

	// LAB 3: Your code here.
	struct Elf *elf = (struct Elf *)binary;
f01041fc:	8b 45 0c             	mov    0xc(%ebp),%eax
f01041ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(elf->e_magic != ELF_MAGIC)
f0104202:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104205:	8b 00                	mov    (%eax),%eax
f0104207:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
f010420c:	74 1b                	je     f0104229 <load_icode+0x44>
		panic("load_icode: e_magic != ELF_MAGIC.\n");
f010420e:	83 ec 04             	sub    $0x4,%esp
f0104211:	8d 83 94 67 f7 ff    	lea    -0x8986c(%ebx),%eax
f0104217:	50                   	push   %eax
f0104218:	68 6d 01 00 00       	push   $0x16d
f010421d:	8d 83 1b 67 f7 ff    	lea    -0x898e5(%ebx),%eax
f0104223:	50                   	push   %eax
f0104224:	e8 a4 be ff ff       	call   f01000cd <_panic>

	struct Proghdr *pht = (struct Proghdr *)(binary + elf->e_phoff);
f0104229:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010422c:	8b 50 1c             	mov    0x1c(%eax),%edx
f010422f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104232:	01 d0                	add    %edx,%eax
f0104234:	89 45 ec             	mov    %eax,-0x14(%ebp)

	lcr3(PADDR(e->env_pgdir)); // for valid-use of memcpy/memset
f0104237:	8b 45 08             	mov    0x8(%ebp),%eax
f010423a:	8b 40 5c             	mov    0x5c(%eax),%eax
f010423d:	83 ec 04             	sub    $0x4,%esp
f0104240:	50                   	push   %eax
f0104241:	68 71 01 00 00       	push   $0x171
f0104246:	8d 83 1b 67 f7 ff    	lea    -0x898e5(%ebx),%eax
f010424c:	50                   	push   %eax
f010424d:	e8 31 f9 ff ff       	call   f0103b83 <_paddr>
f0104252:	83 c4 10             	add    $0x10,%esp
f0104255:	83 ec 0c             	sub    $0xc,%esp
f0104258:	50                   	push   %eax
f0104259:	e8 0f f9 ff ff       	call   f0103b6d <lcr3>
f010425e:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < elf->e_phnum; ++i)
f0104261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0104268:	e9 08 01 00 00       	jmp    f0104375 <load_icode+0x190>
	{
		if(pht[i].p_type == ELF_PROG_LOAD)
f010426d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104270:	c1 e0 05             	shl    $0x5,%eax
f0104273:	89 c2                	mov    %eax,%edx
f0104275:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104278:	01 d0                	add    %edx,%eax
f010427a:	8b 00                	mov    (%eax),%eax
f010427c:	83 f8 01             	cmp    $0x1,%eax
f010427f:	0f 85 ec 00 00 00    	jne    f0104371 <load_icode+0x18c>
		{
			// Allocate physical regions
			region_alloc(e, (void *)pht[i].p_va, pht[i].p_memsz);
f0104285:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104288:	c1 e0 05             	shl    $0x5,%eax
f010428b:	89 c2                	mov    %eax,%edx
f010428d:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104290:	01 d0                	add    %edx,%eax
f0104292:	8b 40 14             	mov    0x14(%eax),%eax
f0104295:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104298:	89 d1                	mov    %edx,%ecx
f010429a:	c1 e1 05             	shl    $0x5,%ecx
f010429d:	8b 55 ec             	mov    -0x14(%ebp),%edx
f01042a0:	01 ca                	add    %ecx,%edx
f01042a2:	8b 52 08             	mov    0x8(%edx),%edx
f01042a5:	83 ec 04             	sub    $0x4,%esp
f01042a8:	50                   	push   %eax
f01042a9:	52                   	push   %edx
f01042aa:	ff 75 08             	pushl  0x8(%ebp)
f01042ad:	e8 5f fe ff ff       	call   f0104111 <region_alloc>
f01042b2:	83 c4 10             	add    $0x10,%esp
			// Copy the contents from ELF
			memcpy(
				(void *)pht[i].p_va, 
				(void *)(binary) + pht[i].p_offset,
				pht[i].p_filesz
f01042b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01042b8:	c1 e0 05             	shl    $0x5,%eax
f01042bb:	89 c2                	mov    %eax,%edx
f01042bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01042c0:	01 d0                	add    %edx,%eax
			memcpy(
f01042c2:	8b 40 10             	mov    0x10(%eax),%eax
				(void *)(binary) + pht[i].p_offset,
f01042c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01042c8:	89 d1                	mov    %edx,%ecx
f01042ca:	c1 e1 05             	shl    $0x5,%ecx
f01042cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
f01042d0:	01 ca                	add    %ecx,%edx
f01042d2:	8b 4a 04             	mov    0x4(%edx),%ecx
			memcpy(
f01042d5:	8b 55 0c             	mov    0xc(%ebp),%edx
f01042d8:	01 ca                	add    %ecx,%edx
				(void *)pht[i].p_va, 
f01042da:	8b 4d f4             	mov    -0xc(%ebp),%ecx
f01042dd:	89 ce                	mov    %ecx,%esi
f01042df:	c1 e6 05             	shl    $0x5,%esi
f01042e2:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01042e5:	01 f1                	add    %esi,%ecx
f01042e7:	8b 49 08             	mov    0x8(%ecx),%ecx
			memcpy(
f01042ea:	83 ec 04             	sub    $0x4,%esp
f01042ed:	50                   	push   %eax
f01042ee:	52                   	push   %edx
f01042ef:	51                   	push   %ecx
f01042f0:	e8 8f 2a 00 00       	call   f0106d84 <memcpy>
f01042f5:	83 c4 10             	add    $0x10,%esp
			);
			// Set the rest to be zero
			if(pht[i].p_filesz < pht[i].p_memsz)
f01042f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01042fb:	c1 e0 05             	shl    $0x5,%eax
f01042fe:	89 c2                	mov    %eax,%edx
f0104300:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104303:	01 d0                	add    %edx,%eax
f0104305:	8b 50 10             	mov    0x10(%eax),%edx
f0104308:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010430b:	c1 e0 05             	shl    $0x5,%eax
f010430e:	89 c1                	mov    %eax,%ecx
f0104310:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104313:	01 c8                	add    %ecx,%eax
f0104315:	8b 40 14             	mov    0x14(%eax),%eax
f0104318:	39 c2                	cmp    %eax,%edx
f010431a:	73 55                	jae    f0104371 <load_icode+0x18c>
				memset(
					(void *)pht[i].p_va + pht[i].p_filesz,
					0,
					pht[i].p_memsz - pht[i].p_filesz
f010431c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010431f:	c1 e0 05             	shl    $0x5,%eax
f0104322:	89 c2                	mov    %eax,%edx
f0104324:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104327:	01 d0                	add    %edx,%eax
f0104329:	8b 50 14             	mov    0x14(%eax),%edx
f010432c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010432f:	c1 e0 05             	shl    $0x5,%eax
f0104332:	89 c1                	mov    %eax,%ecx
f0104334:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104337:	01 c8                	add    %ecx,%eax
f0104339:	8b 40 10             	mov    0x10(%eax),%eax
				memset(
f010433c:	29 c2                	sub    %eax,%edx
f010433e:	89 d0                	mov    %edx,%eax
					(void *)pht[i].p_va + pht[i].p_filesz,
f0104340:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104343:	89 d1                	mov    %edx,%ecx
f0104345:	c1 e1 05             	shl    $0x5,%ecx
f0104348:	8b 55 ec             	mov    -0x14(%ebp),%edx
f010434b:	01 ca                	add    %ecx,%edx
f010434d:	8b 4a 10             	mov    0x10(%edx),%ecx
f0104350:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104353:	89 d6                	mov    %edx,%esi
f0104355:	c1 e6 05             	shl    $0x5,%esi
f0104358:	8b 55 ec             	mov    -0x14(%ebp),%edx
f010435b:	01 f2                	add    %esi,%edx
f010435d:	8b 52 08             	mov    0x8(%edx),%edx
f0104360:	01 ca                	add    %ecx,%edx
				memset(
f0104362:	83 ec 04             	sub    $0x4,%esp
f0104365:	50                   	push   %eax
f0104366:	6a 00                	push   $0x0
f0104368:	52                   	push   %edx
f0104369:	e8 b2 28 00 00       	call   f0106c20 <memset>
f010436e:	83 c4 10             	add    $0x10,%esp
	for(int i = 0; i < elf->e_phnum; ++i)
f0104371:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f0104375:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104378:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f010437c:	0f b7 c0             	movzwl %ax,%eax
f010437f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
f0104382:	0f 8c e5 fe ff ff    	jl     f010426d <load_icode+0x88>
				);
			
		}
	}
	lcr3(PADDR(kern_pgdir));
f0104388:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f010438e:	8b 00                	mov    (%eax),%eax
f0104390:	83 ec 04             	sub    $0x4,%esp
f0104393:	50                   	push   %eax
f0104394:	68 88 01 00 00       	push   $0x188
f0104399:	8d 83 1b 67 f7 ff    	lea    -0x898e5(%ebx),%eax
f010439f:	50                   	push   %eax
f01043a0:	e8 de f7 ff ff       	call   f0103b83 <_paddr>
f01043a5:	83 c4 10             	add    $0x10,%esp
f01043a8:	83 ec 0c             	sub    $0xc,%esp
f01043ab:	50                   	push   %eax
f01043ac:	e8 bc f7 ff ff       	call   f0103b6d <lcr3>
f01043b1:	83 c4 10             	add    $0x10,%esp

	// Setup the entry
	e->env_tf.tf_eip = elf->e_entry;	
f01043b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01043b7:	8b 50 18             	mov    0x18(%eax),%edx
f01043ba:	8b 45 08             	mov    0x8(%ebp),%eax
f01043bd:	89 50 30             	mov    %edx,0x30(%eax)

	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.
	// LAB 3: Your code here.
	region_alloc(e, (void *)(USTACKTOP-PGSIZE), PGSIZE);
f01043c0:	83 ec 04             	sub    $0x4,%esp
f01043c3:	68 00 10 00 00       	push   $0x1000
f01043c8:	68 00 d0 bf ee       	push   $0xeebfd000
f01043cd:	ff 75 08             	pushl  0x8(%ebp)
f01043d0:	e8 3c fd ff ff       	call   f0104111 <region_alloc>
f01043d5:	83 c4 10             	add    $0x10,%esp
}
f01043d8:	90                   	nop
f01043d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01043dc:	5b                   	pop    %ebx
f01043dd:	5e                   	pop    %esi
f01043de:	5d                   	pop    %ebp
f01043df:	c3                   	ret    

f01043e0 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f01043e0:	f3 0f 1e fb          	endbr32 
f01043e4:	55                   	push   %ebp
f01043e5:	89 e5                	mov    %esp,%ebp
f01043e7:	53                   	push   %ebx
f01043e8:	83 ec 14             	sub    $0x14,%esp
f01043eb:	e8 be bd ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f01043f0:	81 c3 c4 d5 08 00    	add    $0x8d5c4,%ebx
	// LAB 3: Your code here.
	struct Env *new_env = NULL;
f01043f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if(env_alloc(&new_env, 0) < 0)
f01043fd:	83 ec 08             	sub    $0x8,%esp
f0104400:	6a 00                	push   $0x0
f0104402:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0104405:	50                   	push   %eax
f0104406:	e8 bd fb ff ff       	call   f0103fc8 <env_alloc>
f010440b:	83 c4 10             	add    $0x10,%esp
f010440e:	85 c0                	test   %eax,%eax
f0104410:	79 1b                	jns    f010442d <env_create+0x4d>
		panic("env_crate: env_alloc failed.\n");
f0104412:	83 ec 04             	sub    $0x4,%esp
f0104415:	8d 83 b7 67 f7 ff    	lea    -0x89849(%ebx),%eax
f010441b:	50                   	push   %eax
f010441c:	68 a0 01 00 00       	push   $0x1a0
f0104421:	8d 83 1b 67 f7 ff    	lea    -0x898e5(%ebx),%eax
f0104427:	50                   	push   %eax
f0104428:	e8 a0 bc ff ff       	call   f01000cd <_panic>
	new_env->env_type = type;
f010442d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104430:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104433:	89 50 50             	mov    %edx,0x50(%eax)
	load_icode(new_env, binary);
f0104436:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104439:	83 ec 08             	sub    $0x8,%esp
f010443c:	ff 75 08             	pushl  0x8(%ebp)
f010443f:	50                   	push   %eax
f0104440:	e8 a0 fd ff ff       	call   f01041e5 <load_icode>
f0104445:	83 c4 10             	add    $0x10,%esp
}
f0104448:	90                   	nop
f0104449:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010444c:	c9                   	leave  
f010444d:	c3                   	ret    

f010444e <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f010444e:	f3 0f 1e fb          	endbr32 
f0104452:	55                   	push   %ebp
f0104453:	89 e5                	mov    %esp,%ebp
f0104455:	53                   	push   %ebx
f0104456:	83 ec 14             	sub    $0x14,%esp
f0104459:	e8 50 bd ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f010445e:	81 c3 56 d5 08 00    	add    $0x8d556,%ebx
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0104464:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f010446a:	39 45 08             	cmp    %eax,0x8(%ebp)
f010446d:	75 2c                	jne    f010449b <env_free+0x4d>
		lcr3(PADDR(kern_pgdir));
f010446f:	c7 c0 ac 3f 19 f0    	mov    $0xf0193fac,%eax
f0104475:	8b 00                	mov    (%eax),%eax
f0104477:	83 ec 04             	sub    $0x4,%esp
f010447a:	50                   	push   %eax
f010447b:	68 b3 01 00 00       	push   $0x1b3
f0104480:	8d 83 1b 67 f7 ff    	lea    -0x898e5(%ebx),%eax
f0104486:	50                   	push   %eax
f0104487:	e8 f7 f6 ff ff       	call   f0103b83 <_paddr>
f010448c:	83 c4 10             	add    $0x10,%esp
f010448f:	83 ec 0c             	sub    $0xc,%esp
f0104492:	50                   	push   %eax
f0104493:	e8 d5 f6 ff ff       	call   f0103b6d <lcr3>
f0104498:	83 c4 10             	add    $0x10,%esp

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010449b:	8b 45 08             	mov    0x8(%ebp),%eax
f010449e:	8b 50 48             	mov    0x48(%eax),%edx
f01044a1:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f01044a7:	85 c0                	test   %eax,%eax
f01044a9:	74 0b                	je     f01044b6 <env_free+0x68>
f01044ab:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f01044b1:	8b 40 48             	mov    0x48(%eax),%eax
f01044b4:	eb 05                	jmp    f01044bb <env_free+0x6d>
f01044b6:	b8 00 00 00 00       	mov    $0x0,%eax
f01044bb:	83 ec 04             	sub    $0x4,%esp
f01044be:	52                   	push   %edx
f01044bf:	50                   	push   %eax
f01044c0:	8d 83 d5 67 f7 ff    	lea    -0x8982b(%ebx),%eax
f01044c6:	50                   	push   %eax
f01044c7:	e8 99 03 00 00       	call   f0104865 <cprintf>
f01044cc:	83 c4 10             	add    $0x10,%esp

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f01044cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01044d6:	e9 d8 00 00 00       	jmp    f01045b3 <env_free+0x165>

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f01044db:	8b 45 08             	mov    0x8(%ebp),%eax
f01044de:	8b 40 5c             	mov    0x5c(%eax),%eax
f01044e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01044e4:	c1 e2 02             	shl    $0x2,%edx
f01044e7:	01 d0                	add    %edx,%eax
f01044e9:	8b 00                	mov    (%eax),%eax
f01044eb:	83 e0 01             	and    $0x1,%eax
f01044ee:	85 c0                	test   %eax,%eax
f01044f0:	0f 84 b8 00 00 00    	je     f01045ae <env_free+0x160>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f01044f6:	8b 45 08             	mov    0x8(%ebp),%eax
f01044f9:	8b 40 5c             	mov    0x5c(%eax),%eax
f01044fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01044ff:	c1 e2 02             	shl    $0x2,%edx
f0104502:	01 d0                	add    %edx,%eax
f0104504:	8b 00                	mov    (%eax),%eax
f0104506:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010450b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		pt = (pte_t*) KADDR(pa);
f010450e:	83 ec 04             	sub    $0x4,%esp
f0104511:	ff 75 ec             	pushl  -0x14(%ebp)
f0104514:	68 c2 01 00 00       	push   $0x1c2
f0104519:	8d 83 1b 67 f7 ff    	lea    -0x898e5(%ebx),%eax
f010451f:	50                   	push   %eax
f0104520:	e8 9e f6 ff ff       	call   f0103bc3 <_kaddr>
f0104525:	83 c4 10             	add    $0x10,%esp
f0104528:	89 45 e8             	mov    %eax,-0x18(%ebp)

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f010452b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0104532:	eb 41                	jmp    f0104575 <env_free+0x127>
			if (pt[pteno] & PTE_P)
f0104534:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104537:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f010453e:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0104541:	01 d0                	add    %edx,%eax
f0104543:	8b 00                	mov    (%eax),%eax
f0104545:	83 e0 01             	and    $0x1,%eax
f0104548:	85 c0                	test   %eax,%eax
f010454a:	74 25                	je     f0104571 <env_free+0x123>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010454c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010454f:	c1 e0 16             	shl    $0x16,%eax
f0104552:	89 c2                	mov    %eax,%edx
f0104554:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104557:	c1 e0 0c             	shl    $0xc,%eax
f010455a:	09 d0                	or     %edx,%eax
f010455c:	89 c2                	mov    %eax,%edx
f010455e:	8b 45 08             	mov    0x8(%ebp),%eax
f0104561:	8b 40 5c             	mov    0x5c(%eax),%eax
f0104564:	83 ec 08             	sub    $0x8,%esp
f0104567:	52                   	push   %edx
f0104568:	50                   	push   %eax
f0104569:	e8 df d4 ff ff       	call   f0101a4d <page_remove>
f010456e:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0104571:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
f0104575:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
f010457c:	76 b6                	jbe    f0104534 <env_free+0xe6>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f010457e:	8b 45 08             	mov    0x8(%ebp),%eax
f0104581:	8b 40 5c             	mov    0x5c(%eax),%eax
f0104584:	8b 55 f4             	mov    -0xc(%ebp),%edx
f0104587:	c1 e2 02             	shl    $0x2,%edx
f010458a:	01 d0                	add    %edx,%eax
f010458c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		page_decref(pa2page(pa));
f0104592:	83 ec 0c             	sub    $0xc,%esp
f0104595:	ff 75 ec             	pushl  -0x14(%ebp)
f0104598:	e8 93 f6 ff ff       	call   f0103c30 <pa2page>
f010459d:	83 c4 10             	add    $0x10,%esp
f01045a0:	83 ec 0c             	sub    $0xc,%esp
f01045a3:	50                   	push   %eax
f01045a4:	e8 fd d1 ff ff       	call   f01017a6 <page_decref>
f01045a9:	83 c4 10             	add    $0x10,%esp
f01045ac:	eb 01                	jmp    f01045af <env_free+0x161>
			continue;
f01045ae:	90                   	nop
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f01045af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
f01045b3:	81 7d f4 ba 03 00 00 	cmpl   $0x3ba,-0xc(%ebp)
f01045ba:	0f 86 1b ff ff ff    	jbe    f01044db <env_free+0x8d>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01045c0:	8b 45 08             	mov    0x8(%ebp),%eax
f01045c3:	8b 40 5c             	mov    0x5c(%eax),%eax
f01045c6:	83 ec 04             	sub    $0x4,%esp
f01045c9:	50                   	push   %eax
f01045ca:	68 d0 01 00 00       	push   $0x1d0
f01045cf:	8d 83 1b 67 f7 ff    	lea    -0x898e5(%ebx),%eax
f01045d5:	50                   	push   %eax
f01045d6:	e8 a8 f5 ff ff       	call   f0103b83 <_paddr>
f01045db:	83 c4 10             	add    $0x10,%esp
f01045de:	89 45 ec             	mov    %eax,-0x14(%ebp)
	e->env_pgdir = 0;
f01045e1:	8b 45 08             	mov    0x8(%ebp),%eax
f01045e4:	c7 40 5c 00 00 00 00 	movl   $0x0,0x5c(%eax)
	page_decref(pa2page(pa));
f01045eb:	83 ec 0c             	sub    $0xc,%esp
f01045ee:	ff 75 ec             	pushl  -0x14(%ebp)
f01045f1:	e8 3a f6 ff ff       	call   f0103c30 <pa2page>
f01045f6:	83 c4 10             	add    $0x10,%esp
f01045f9:	83 ec 0c             	sub    $0xc,%esp
f01045fc:	50                   	push   %eax
f01045fd:	e8 a4 d1 ff ff       	call   f01017a6 <page_decref>
f0104602:	83 c4 10             	add    $0x10,%esp

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0104605:	8b 45 08             	mov    0x8(%ebp),%eax
f0104608:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	e->env_link = env_free_list;
f010460f:	8b 93 50 19 00 00    	mov    0x1950(%ebx),%edx
f0104615:	8b 45 08             	mov    0x8(%ebp),%eax
f0104618:	89 50 44             	mov    %edx,0x44(%eax)
	env_free_list = e;
f010461b:	8b 45 08             	mov    0x8(%ebp),%eax
f010461e:	89 83 50 19 00 00    	mov    %eax,0x1950(%ebx)
}
f0104624:	90                   	nop
f0104625:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104628:	c9                   	leave  
f0104629:	c3                   	ret    

f010462a <env_destroy>:
//
// Frees environment e.
//
void
env_destroy(struct Env *e)
{
f010462a:	f3 0f 1e fb          	endbr32 
f010462e:	55                   	push   %ebp
f010462f:	89 e5                	mov    %esp,%ebp
f0104631:	53                   	push   %ebx
f0104632:	83 ec 04             	sub    $0x4,%esp
f0104635:	e8 74 bb ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f010463a:	81 c3 7a d3 08 00    	add    $0x8d37a,%ebx
	env_free(e);
f0104640:	83 ec 0c             	sub    $0xc,%esp
f0104643:	ff 75 08             	pushl  0x8(%ebp)
f0104646:	e8 03 fe ff ff       	call   f010444e <env_free>
f010464b:	83 c4 10             	add    $0x10,%esp

	cprintf("Destroyed the only environment - nothing more to do!\n");
f010464e:	83 ec 0c             	sub    $0xc,%esp
f0104651:	8d 83 ec 67 f7 ff    	lea    -0x89814(%ebx),%eax
f0104657:	50                   	push   %eax
f0104658:	e8 08 02 00 00       	call   f0104865 <cprintf>
f010465d:	83 c4 10             	add    $0x10,%esp
	while (1)
		monitor(NULL);
f0104660:	83 ec 0c             	sub    $0xc,%esp
f0104663:	6a 00                	push   $0x0
f0104665:	e8 ef c8 ff ff       	call   f0100f59 <monitor>
f010466a:	83 c4 10             	add    $0x10,%esp
f010466d:	eb f1                	jmp    f0104660 <env_destroy+0x36>

f010466f <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f010466f:	f3 0f 1e fb          	endbr32 
f0104673:	55                   	push   %ebp
f0104674:	89 e5                	mov    %esp,%ebp
f0104676:	53                   	push   %ebx
f0104677:	83 ec 04             	sub    $0x4,%esp
f010467a:	e8 80 c4 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f010467f:	05 35 d3 08 00       	add    $0x8d335,%eax
	asm volatile(
f0104684:	8b 65 08             	mov    0x8(%ebp),%esp
f0104687:	61                   	popa   
f0104688:	07                   	pop    %es
f0104689:	1f                   	pop    %ds
f010468a:	83 c4 08             	add    $0x8,%esp
f010468d:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f010468e:	83 ec 04             	sub    $0x4,%esp
f0104691:	8d 90 22 68 f7 ff    	lea    -0x897de(%eax),%edx
f0104697:	52                   	push   %edx
f0104698:	68 f9 01 00 00       	push   $0x1f9
f010469d:	8d 90 1b 67 f7 ff    	lea    -0x898e5(%eax),%edx
f01046a3:	52                   	push   %edx
f01046a4:	89 c3                	mov    %eax,%ebx
f01046a6:	e8 22 ba ff ff       	call   f01000cd <_panic>

f01046ab <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01046ab:	f3 0f 1e fb          	endbr32 
f01046af:	55                   	push   %ebp
f01046b0:	89 e5                	mov    %esp,%ebp
f01046b2:	53                   	push   %ebx
f01046b3:	83 ec 04             	sub    $0x4,%esp
f01046b6:	e8 f3 ba ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f01046bb:	81 c3 f9 d2 08 00    	add    $0x8d2f9,%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv)
f01046c1:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f01046c7:	85 c0                	test   %eax,%eax
f01046c9:	74 1b                	je     f01046e6 <env_run+0x3b>
	{
		if(curenv->env_status == ENV_RUNNING)
f01046cb:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f01046d1:	8b 40 54             	mov    0x54(%eax),%eax
f01046d4:	83 f8 03             	cmp    $0x3,%eax
f01046d7:	75 0d                	jne    f01046e6 <env_run+0x3b>
			curenv->env_status = ENV_RUNNABLE;
f01046d9:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f01046df:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	}
	curenv = e;
f01046e6:	8b 45 08             	mov    0x8(%ebp),%eax
f01046e9:	89 83 4c 19 00 00    	mov    %eax,0x194c(%ebx)
	curenv->env_status = ENV_RUNNING;
f01046ef:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f01046f5:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
	curenv->env_runs++;
f01046fc:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f0104702:	8b 50 58             	mov    0x58(%eax),%edx
f0104705:	83 c2 01             	add    $0x1,%edx
f0104708:	89 50 58             	mov    %edx,0x58(%eax)

	// !Use physic addr of pgdir
	lcr3(PADDR(curenv->env_pgdir));
f010470b:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f0104711:	8b 40 5c             	mov    0x5c(%eax),%eax
f0104714:	83 ec 04             	sub    $0x4,%esp
f0104717:	50                   	push   %eax
f0104718:	68 21 02 00 00       	push   $0x221
f010471d:	8d 83 1b 67 f7 ff    	lea    -0x898e5(%ebx),%eax
f0104723:	50                   	push   %eax
f0104724:	e8 5a f4 ff ff       	call   f0103b83 <_paddr>
f0104729:	83 c4 10             	add    $0x10,%esp
f010472c:	83 ec 0c             	sub    $0xc,%esp
f010472f:	50                   	push   %eax
f0104730:	e8 38 f4 ff ff       	call   f0103b6d <lcr3>
f0104735:	83 c4 10             	add    $0x10,%esp
	env_pop_tf(&(curenv->env_tf));
f0104738:	8b 83 4c 19 00 00    	mov    0x194c(%ebx),%eax
f010473e:	83 ec 0c             	sub    $0xc,%esp
f0104741:	50                   	push   %eax
f0104742:	e8 28 ff ff ff       	call   f010466f <env_pop_tf>

f0104747 <__x86.get_pc_thunk.dx>:
f0104747:	8b 14 24             	mov    (%esp),%edx
f010474a:	c3                   	ret    

f010474b <inb>:
{
f010474b:	55                   	push   %ebp
f010474c:	89 e5                	mov    %esp,%ebp
f010474e:	83 ec 10             	sub    $0x10,%esp
f0104751:	e8 a9 c3 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0104756:	05 5e d2 08 00       	add    $0x8d25e,%eax
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010475b:	8b 45 08             	mov    0x8(%ebp),%eax
f010475e:	89 c2                	mov    %eax,%edx
f0104760:	ec                   	in     (%dx),%al
f0104761:	88 45 ff             	mov    %al,-0x1(%ebp)
	return data;
f0104764:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
f0104768:	c9                   	leave  
f0104769:	c3                   	ret    

f010476a <outb>:
{
f010476a:	55                   	push   %ebp
f010476b:	89 e5                	mov    %esp,%ebp
f010476d:	83 ec 04             	sub    $0x4,%esp
f0104770:	e8 8a c3 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0104775:	05 3f d2 08 00       	add    $0x8d23f,%eax
f010477a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010477d:	88 45 fc             	mov    %al,-0x4(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104780:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
f0104784:	8b 55 08             	mov    0x8(%ebp),%edx
f0104787:	ee                   	out    %al,(%dx)
}
f0104788:	90                   	nop
f0104789:	c9                   	leave  
f010478a:	c3                   	ret    

f010478b <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010478b:	f3 0f 1e fb          	endbr32 
f010478f:	55                   	push   %ebp
f0104790:	89 e5                	mov    %esp,%ebp
f0104792:	e8 68 c3 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0104797:	05 1d d2 08 00       	add    $0x8d21d,%eax
	outb(IO_RTC, reg);
f010479c:	8b 45 08             	mov    0x8(%ebp),%eax
f010479f:	0f b6 c0             	movzbl %al,%eax
f01047a2:	50                   	push   %eax
f01047a3:	6a 70                	push   $0x70
f01047a5:	e8 c0 ff ff ff       	call   f010476a <outb>
f01047aa:	83 c4 08             	add    $0x8,%esp
	return inb(IO_RTC+1);
f01047ad:	6a 71                	push   $0x71
f01047af:	e8 97 ff ff ff       	call   f010474b <inb>
f01047b4:	83 c4 04             	add    $0x4,%esp
f01047b7:	0f b6 c0             	movzbl %al,%eax
}
f01047ba:	c9                   	leave  
f01047bb:	c3                   	ret    

f01047bc <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01047bc:	f3 0f 1e fb          	endbr32 
f01047c0:	55                   	push   %ebp
f01047c1:	89 e5                	mov    %esp,%ebp
f01047c3:	e8 37 c3 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01047c8:	05 ec d1 08 00       	add    $0x8d1ec,%eax
	outb(IO_RTC, reg);
f01047cd:	8b 45 08             	mov    0x8(%ebp),%eax
f01047d0:	0f b6 c0             	movzbl %al,%eax
f01047d3:	50                   	push   %eax
f01047d4:	6a 70                	push   $0x70
f01047d6:	e8 8f ff ff ff       	call   f010476a <outb>
f01047db:	83 c4 08             	add    $0x8,%esp
	outb(IO_RTC+1, datum);
f01047de:	8b 45 0c             	mov    0xc(%ebp),%eax
f01047e1:	0f b6 c0             	movzbl %al,%eax
f01047e4:	50                   	push   %eax
f01047e5:	6a 71                	push   $0x71
f01047e7:	e8 7e ff ff ff       	call   f010476a <outb>
f01047ec:	83 c4 08             	add    $0x8,%esp
}
f01047ef:	90                   	nop
f01047f0:	c9                   	leave  
f01047f1:	c3                   	ret    

f01047f2 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01047f2:	f3 0f 1e fb          	endbr32 
f01047f6:	55                   	push   %ebp
f01047f7:	89 e5                	mov    %esp,%ebp
f01047f9:	53                   	push   %ebx
f01047fa:	83 ec 04             	sub    $0x4,%esp
f01047fd:	e8 fd c2 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0104802:	05 b2 d1 08 00       	add    $0x8d1b2,%eax
	cputchar(ch);
f0104807:	83 ec 0c             	sub    $0xc,%esp
f010480a:	ff 75 08             	pushl  0x8(%ebp)
f010480d:	89 c3                	mov    %eax,%ebx
f010480f:	e8 86 c2 ff ff       	call   f0100a9a <cputchar>
f0104814:	83 c4 10             	add    $0x10,%esp
	*cnt++;
f0104817:	8b 45 0c             	mov    0xc(%ebp),%eax
f010481a:	83 c0 04             	add    $0x4,%eax
f010481d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
f0104820:	90                   	nop
f0104821:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104824:	c9                   	leave  
f0104825:	c3                   	ret    

f0104826 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0104826:	f3 0f 1e fb          	endbr32 
f010482a:	55                   	push   %ebp
f010482b:	89 e5                	mov    %esp,%ebp
f010482d:	53                   	push   %ebx
f010482e:	83 ec 14             	sub    $0x14,%esp
f0104831:	e8 c9 c2 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0104836:	05 7e d1 08 00       	add    $0x8d17e,%eax
	int cnt = 0;
f010483b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0104842:	ff 75 0c             	pushl  0xc(%ebp)
f0104845:	ff 75 08             	pushl  0x8(%ebp)
f0104848:	8d 55 f4             	lea    -0xc(%ebp),%edx
f010484b:	52                   	push   %edx
f010484c:	8d 90 3e 2e f7 ff    	lea    -0x8d1c2(%eax),%edx
f0104852:	52                   	push   %edx
f0104853:	89 c3                	mov    %eax,%ebx
f0104855:	e8 07 1b 00 00       	call   f0106361 <vprintfmt>
f010485a:	83 c4 10             	add    $0x10,%esp
	return cnt;
f010485d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0104860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104863:	c9                   	leave  
f0104864:	c3                   	ret    

f0104865 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0104865:	f3 0f 1e fb          	endbr32 
f0104869:	55                   	push   %ebp
f010486a:	89 e5                	mov    %esp,%ebp
f010486c:	83 ec 18             	sub    $0x18,%esp
f010486f:	e8 8b c2 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0104874:	05 40 d1 08 00       	add    $0x8d140,%eax
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0104879:	8d 45 0c             	lea    0xc(%ebp),%eax
f010487c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cnt = vcprintf(fmt, ap);
f010487f:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104882:	83 ec 08             	sub    $0x8,%esp
f0104885:	50                   	push   %eax
f0104886:	ff 75 08             	pushl  0x8(%ebp)
f0104889:	e8 98 ff ff ff       	call   f0104826 <vcprintf>
f010488e:	83 c4 10             	add    $0x10,%esp
f0104891:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return cnt;
f0104894:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0104897:	c9                   	leave  
f0104898:	c3                   	ret    

f0104899 <lidt>:
{
f0104899:	55                   	push   %ebp
f010489a:	89 e5                	mov    %esp,%ebp
f010489c:	e8 5e c2 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01048a1:	05 13 d1 08 00       	add    $0x8d113,%eax
	asm volatile("lidt (%0)" : : "r" (p));
f01048a6:	8b 45 08             	mov    0x8(%ebp),%eax
f01048a9:	0f 01 18             	lidtl  (%eax)
}
f01048ac:	90                   	nop
f01048ad:	5d                   	pop    %ebp
f01048ae:	c3                   	ret    

f01048af <ltr>:
{
f01048af:	55                   	push   %ebp
f01048b0:	89 e5                	mov    %esp,%ebp
f01048b2:	83 ec 04             	sub    $0x4,%esp
f01048b5:	e8 45 c2 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01048ba:	05 fa d0 08 00       	add    $0x8d0fa,%eax
f01048bf:	8b 45 08             	mov    0x8(%ebp),%eax
f01048c2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
	asm volatile("ltr %0" : : "r" (sel));
f01048c6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
f01048ca:	0f 00 d8             	ltr    %ax
}
f01048cd:	90                   	nop
f01048ce:	c9                   	leave  
f01048cf:	c3                   	ret    

f01048d0 <rcr2>:
{
f01048d0:	55                   	push   %ebp
f01048d1:	89 e5                	mov    %esp,%ebp
f01048d3:	83 ec 10             	sub    $0x10,%esp
f01048d6:	e8 24 c2 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01048db:	05 d9 d0 08 00       	add    $0x8d0d9,%eax
	asm volatile("movl %%cr2,%0" : "=r" (val));
f01048e0:	0f 20 d0             	mov    %cr2,%eax
f01048e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return val;
f01048e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
f01048e9:	c9                   	leave  
f01048ea:	c3                   	ret    

f01048eb <read_eflags>:
{
f01048eb:	55                   	push   %ebp
f01048ec:	89 e5                	mov    %esp,%ebp
f01048ee:	83 ec 10             	sub    $0x10,%esp
f01048f1:	e8 09 c2 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01048f6:	05 be d0 08 00       	add    $0x8d0be,%eax
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f01048fb:	9c                   	pushf  
f01048fc:	58                   	pop    %eax
f01048fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return eflags;
f0104900:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
f0104903:	c9                   	leave  
f0104904:	c3                   	ret    

f0104905 <trapname>:
	sizeof(idt) - 1, (uint32_t) idt
};


static const char *trapname(int trapno)
{
f0104905:	f3 0f 1e fb          	endbr32 
f0104909:	55                   	push   %ebp
f010490a:	89 e5                	mov    %esp,%ebp
f010490c:	e8 ee c1 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0104911:	05 a3 d0 08 00       	add    $0x8d0a3,%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < ARRAY_SIZE(excnames))
f0104916:	8b 55 08             	mov    0x8(%ebp),%edx
f0104919:	83 fa 13             	cmp    $0x13,%edx
f010491c:	77 0c                	ja     f010492a <trapname+0x25>
		return excnames[trapno];
f010491e:	8b 55 08             	mov    0x8(%ebp),%edx
f0104921:	8b 84 90 8c 16 00 00 	mov    0x168c(%eax,%edx,4),%eax
f0104928:	eb 14                	jmp    f010493e <trapname+0x39>
	if (trapno == T_SYSCALL)
f010492a:	83 7d 08 30          	cmpl   $0x30,0x8(%ebp)
f010492e:	75 08                	jne    f0104938 <trapname+0x33>
		return "System call";
f0104930:	8d 80 30 68 f7 ff    	lea    -0x897d0(%eax),%eax
f0104936:	eb 06                	jmp    f010493e <trapname+0x39>
	return "(unknown trap)";
f0104938:	8d 80 3c 68 f7 ff    	lea    -0x897c4(%eax),%eax
}
f010493e:	5d                   	pop    %ebp
f010493f:	c3                   	ret    

f0104940 <trap_init>:


void
trap_init(void)
{
f0104940:	f3 0f 1e fb          	endbr32 
f0104944:	55                   	push   %ebp
f0104945:	89 e5                	mov    %esp,%ebp
f0104947:	83 ec 08             	sub    $0x8,%esp
f010494a:	e8 b0 c1 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f010494f:	05 65 d0 08 00       	add    $0x8d065,%eax
	extern void ALIGN();
	extern void MCHK();
	extern void SIMDERR();
	extern void SYSCALL();
	extern void DEFAULT();
	SETGATE(idt[T_DIVIDE], 0, GD_KT, DIVIDE, 0);
f0104954:	c7 c2 d0 5a 10 f0    	mov    $0xf0105ad0,%edx
f010495a:	66 89 90 6c 19 00 00 	mov    %dx,0x196c(%eax)
f0104961:	66 c7 80 6e 19 00 00 	movw   $0x8,0x196e(%eax)
f0104968:	08 00 
f010496a:	0f b6 90 70 19 00 00 	movzbl 0x1970(%eax),%edx
f0104971:	83 e2 e0             	and    $0xffffffe0,%edx
f0104974:	88 90 70 19 00 00    	mov    %dl,0x1970(%eax)
f010497a:	0f b6 90 70 19 00 00 	movzbl 0x1970(%eax),%edx
f0104981:	83 e2 1f             	and    $0x1f,%edx
f0104984:	88 90 70 19 00 00    	mov    %dl,0x1970(%eax)
f010498a:	0f b6 90 71 19 00 00 	movzbl 0x1971(%eax),%edx
f0104991:	83 e2 f0             	and    $0xfffffff0,%edx
f0104994:	83 ca 0e             	or     $0xe,%edx
f0104997:	88 90 71 19 00 00    	mov    %dl,0x1971(%eax)
f010499d:	0f b6 90 71 19 00 00 	movzbl 0x1971(%eax),%edx
f01049a4:	83 e2 ef             	and    $0xffffffef,%edx
f01049a7:	88 90 71 19 00 00    	mov    %dl,0x1971(%eax)
f01049ad:	0f b6 90 71 19 00 00 	movzbl 0x1971(%eax),%edx
f01049b4:	83 e2 9f             	and    $0xffffff9f,%edx
f01049b7:	88 90 71 19 00 00    	mov    %dl,0x1971(%eax)
f01049bd:	0f b6 90 71 19 00 00 	movzbl 0x1971(%eax),%edx
f01049c4:	83 ca 80             	or     $0xffffff80,%edx
f01049c7:	88 90 71 19 00 00    	mov    %dl,0x1971(%eax)
f01049cd:	c7 c2 d0 5a 10 f0    	mov    $0xf0105ad0,%edx
f01049d3:	c1 ea 10             	shr    $0x10,%edx
f01049d6:	66 89 90 72 19 00 00 	mov    %dx,0x1972(%eax)
	SETGATE(idt[T_DEBUG], 0, GD_KT, DEBUG, 0);
f01049dd:	c7 c2 d6 5a 10 f0    	mov    $0xf0105ad6,%edx
f01049e3:	66 89 90 74 19 00 00 	mov    %dx,0x1974(%eax)
f01049ea:	66 c7 80 76 19 00 00 	movw   $0x8,0x1976(%eax)
f01049f1:	08 00 
f01049f3:	0f b6 90 78 19 00 00 	movzbl 0x1978(%eax),%edx
f01049fa:	83 e2 e0             	and    $0xffffffe0,%edx
f01049fd:	88 90 78 19 00 00    	mov    %dl,0x1978(%eax)
f0104a03:	0f b6 90 78 19 00 00 	movzbl 0x1978(%eax),%edx
f0104a0a:	83 e2 1f             	and    $0x1f,%edx
f0104a0d:	88 90 78 19 00 00    	mov    %dl,0x1978(%eax)
f0104a13:	0f b6 90 79 19 00 00 	movzbl 0x1979(%eax),%edx
f0104a1a:	83 e2 f0             	and    $0xfffffff0,%edx
f0104a1d:	83 ca 0e             	or     $0xe,%edx
f0104a20:	88 90 79 19 00 00    	mov    %dl,0x1979(%eax)
f0104a26:	0f b6 90 79 19 00 00 	movzbl 0x1979(%eax),%edx
f0104a2d:	83 e2 ef             	and    $0xffffffef,%edx
f0104a30:	88 90 79 19 00 00    	mov    %dl,0x1979(%eax)
f0104a36:	0f b6 90 79 19 00 00 	movzbl 0x1979(%eax),%edx
f0104a3d:	83 e2 9f             	and    $0xffffff9f,%edx
f0104a40:	88 90 79 19 00 00    	mov    %dl,0x1979(%eax)
f0104a46:	0f b6 90 79 19 00 00 	movzbl 0x1979(%eax),%edx
f0104a4d:	83 ca 80             	or     $0xffffff80,%edx
f0104a50:	88 90 79 19 00 00    	mov    %dl,0x1979(%eax)
f0104a56:	c7 c2 d6 5a 10 f0    	mov    $0xf0105ad6,%edx
f0104a5c:	c1 ea 10             	shr    $0x10,%edx
f0104a5f:	66 89 90 7a 19 00 00 	mov    %dx,0x197a(%eax)
	SETGATE(idt[T_NMI], 0, GD_KT, NMI, 0);
f0104a66:	c7 c2 dc 5a 10 f0    	mov    $0xf0105adc,%edx
f0104a6c:	66 89 90 7c 19 00 00 	mov    %dx,0x197c(%eax)
f0104a73:	66 c7 80 7e 19 00 00 	movw   $0x8,0x197e(%eax)
f0104a7a:	08 00 
f0104a7c:	0f b6 90 80 19 00 00 	movzbl 0x1980(%eax),%edx
f0104a83:	83 e2 e0             	and    $0xffffffe0,%edx
f0104a86:	88 90 80 19 00 00    	mov    %dl,0x1980(%eax)
f0104a8c:	0f b6 90 80 19 00 00 	movzbl 0x1980(%eax),%edx
f0104a93:	83 e2 1f             	and    $0x1f,%edx
f0104a96:	88 90 80 19 00 00    	mov    %dl,0x1980(%eax)
f0104a9c:	0f b6 90 81 19 00 00 	movzbl 0x1981(%eax),%edx
f0104aa3:	83 e2 f0             	and    $0xfffffff0,%edx
f0104aa6:	83 ca 0e             	or     $0xe,%edx
f0104aa9:	88 90 81 19 00 00    	mov    %dl,0x1981(%eax)
f0104aaf:	0f b6 90 81 19 00 00 	movzbl 0x1981(%eax),%edx
f0104ab6:	83 e2 ef             	and    $0xffffffef,%edx
f0104ab9:	88 90 81 19 00 00    	mov    %dl,0x1981(%eax)
f0104abf:	0f b6 90 81 19 00 00 	movzbl 0x1981(%eax),%edx
f0104ac6:	83 e2 9f             	and    $0xffffff9f,%edx
f0104ac9:	88 90 81 19 00 00    	mov    %dl,0x1981(%eax)
f0104acf:	0f b6 90 81 19 00 00 	movzbl 0x1981(%eax),%edx
f0104ad6:	83 ca 80             	or     $0xffffff80,%edx
f0104ad9:	88 90 81 19 00 00    	mov    %dl,0x1981(%eax)
f0104adf:	c7 c2 dc 5a 10 f0    	mov    $0xf0105adc,%edx
f0104ae5:	c1 ea 10             	shr    $0x10,%edx
f0104ae8:	66 89 90 82 19 00 00 	mov    %dx,0x1982(%eax)
	SETGATE(idt[T_BRKPT], 0, GD_KT, BRKPT, 3);
f0104aef:	c7 c2 e2 5a 10 f0    	mov    $0xf0105ae2,%edx
f0104af5:	66 89 90 84 19 00 00 	mov    %dx,0x1984(%eax)
f0104afc:	66 c7 80 86 19 00 00 	movw   $0x8,0x1986(%eax)
f0104b03:	08 00 
f0104b05:	0f b6 90 88 19 00 00 	movzbl 0x1988(%eax),%edx
f0104b0c:	83 e2 e0             	and    $0xffffffe0,%edx
f0104b0f:	88 90 88 19 00 00    	mov    %dl,0x1988(%eax)
f0104b15:	0f b6 90 88 19 00 00 	movzbl 0x1988(%eax),%edx
f0104b1c:	83 e2 1f             	and    $0x1f,%edx
f0104b1f:	88 90 88 19 00 00    	mov    %dl,0x1988(%eax)
f0104b25:	0f b6 90 89 19 00 00 	movzbl 0x1989(%eax),%edx
f0104b2c:	83 e2 f0             	and    $0xfffffff0,%edx
f0104b2f:	83 ca 0e             	or     $0xe,%edx
f0104b32:	88 90 89 19 00 00    	mov    %dl,0x1989(%eax)
f0104b38:	0f b6 90 89 19 00 00 	movzbl 0x1989(%eax),%edx
f0104b3f:	83 e2 ef             	and    $0xffffffef,%edx
f0104b42:	88 90 89 19 00 00    	mov    %dl,0x1989(%eax)
f0104b48:	0f b6 90 89 19 00 00 	movzbl 0x1989(%eax),%edx
f0104b4f:	83 ca 60             	or     $0x60,%edx
f0104b52:	88 90 89 19 00 00    	mov    %dl,0x1989(%eax)
f0104b58:	0f b6 90 89 19 00 00 	movzbl 0x1989(%eax),%edx
f0104b5f:	83 ca 80             	or     $0xffffff80,%edx
f0104b62:	88 90 89 19 00 00    	mov    %dl,0x1989(%eax)
f0104b68:	c7 c2 e2 5a 10 f0    	mov    $0xf0105ae2,%edx
f0104b6e:	c1 ea 10             	shr    $0x10,%edx
f0104b71:	66 89 90 8a 19 00 00 	mov    %dx,0x198a(%eax)
	SETGATE(idt[T_OFLOW], 0, GD_KT, OFLOW, 0);
f0104b78:	c7 c2 e8 5a 10 f0    	mov    $0xf0105ae8,%edx
f0104b7e:	66 89 90 8c 19 00 00 	mov    %dx,0x198c(%eax)
f0104b85:	66 c7 80 8e 19 00 00 	movw   $0x8,0x198e(%eax)
f0104b8c:	08 00 
f0104b8e:	0f b6 90 90 19 00 00 	movzbl 0x1990(%eax),%edx
f0104b95:	83 e2 e0             	and    $0xffffffe0,%edx
f0104b98:	88 90 90 19 00 00    	mov    %dl,0x1990(%eax)
f0104b9e:	0f b6 90 90 19 00 00 	movzbl 0x1990(%eax),%edx
f0104ba5:	83 e2 1f             	and    $0x1f,%edx
f0104ba8:	88 90 90 19 00 00    	mov    %dl,0x1990(%eax)
f0104bae:	0f b6 90 91 19 00 00 	movzbl 0x1991(%eax),%edx
f0104bb5:	83 e2 f0             	and    $0xfffffff0,%edx
f0104bb8:	83 ca 0e             	or     $0xe,%edx
f0104bbb:	88 90 91 19 00 00    	mov    %dl,0x1991(%eax)
f0104bc1:	0f b6 90 91 19 00 00 	movzbl 0x1991(%eax),%edx
f0104bc8:	83 e2 ef             	and    $0xffffffef,%edx
f0104bcb:	88 90 91 19 00 00    	mov    %dl,0x1991(%eax)
f0104bd1:	0f b6 90 91 19 00 00 	movzbl 0x1991(%eax),%edx
f0104bd8:	83 e2 9f             	and    $0xffffff9f,%edx
f0104bdb:	88 90 91 19 00 00    	mov    %dl,0x1991(%eax)
f0104be1:	0f b6 90 91 19 00 00 	movzbl 0x1991(%eax),%edx
f0104be8:	83 ca 80             	or     $0xffffff80,%edx
f0104beb:	88 90 91 19 00 00    	mov    %dl,0x1991(%eax)
f0104bf1:	c7 c2 e8 5a 10 f0    	mov    $0xf0105ae8,%edx
f0104bf7:	c1 ea 10             	shr    $0x10,%edx
f0104bfa:	66 89 90 92 19 00 00 	mov    %dx,0x1992(%eax)
	SETGATE(idt[T_BOUND], 0, GD_KT, BOUND, 0);
f0104c01:	c7 c2 ee 5a 10 f0    	mov    $0xf0105aee,%edx
f0104c07:	66 89 90 94 19 00 00 	mov    %dx,0x1994(%eax)
f0104c0e:	66 c7 80 96 19 00 00 	movw   $0x8,0x1996(%eax)
f0104c15:	08 00 
f0104c17:	0f b6 90 98 19 00 00 	movzbl 0x1998(%eax),%edx
f0104c1e:	83 e2 e0             	and    $0xffffffe0,%edx
f0104c21:	88 90 98 19 00 00    	mov    %dl,0x1998(%eax)
f0104c27:	0f b6 90 98 19 00 00 	movzbl 0x1998(%eax),%edx
f0104c2e:	83 e2 1f             	and    $0x1f,%edx
f0104c31:	88 90 98 19 00 00    	mov    %dl,0x1998(%eax)
f0104c37:	0f b6 90 99 19 00 00 	movzbl 0x1999(%eax),%edx
f0104c3e:	83 e2 f0             	and    $0xfffffff0,%edx
f0104c41:	83 ca 0e             	or     $0xe,%edx
f0104c44:	88 90 99 19 00 00    	mov    %dl,0x1999(%eax)
f0104c4a:	0f b6 90 99 19 00 00 	movzbl 0x1999(%eax),%edx
f0104c51:	83 e2 ef             	and    $0xffffffef,%edx
f0104c54:	88 90 99 19 00 00    	mov    %dl,0x1999(%eax)
f0104c5a:	0f b6 90 99 19 00 00 	movzbl 0x1999(%eax),%edx
f0104c61:	83 e2 9f             	and    $0xffffff9f,%edx
f0104c64:	88 90 99 19 00 00    	mov    %dl,0x1999(%eax)
f0104c6a:	0f b6 90 99 19 00 00 	movzbl 0x1999(%eax),%edx
f0104c71:	83 ca 80             	or     $0xffffff80,%edx
f0104c74:	88 90 99 19 00 00    	mov    %dl,0x1999(%eax)
f0104c7a:	c7 c2 ee 5a 10 f0    	mov    $0xf0105aee,%edx
f0104c80:	c1 ea 10             	shr    $0x10,%edx
f0104c83:	66 89 90 9a 19 00 00 	mov    %dx,0x199a(%eax)
	SETGATE(idt[T_ILLOP], 0, GD_KT, ILLOP, 0);
f0104c8a:	c7 c2 f4 5a 10 f0    	mov    $0xf0105af4,%edx
f0104c90:	66 89 90 9c 19 00 00 	mov    %dx,0x199c(%eax)
f0104c97:	66 c7 80 9e 19 00 00 	movw   $0x8,0x199e(%eax)
f0104c9e:	08 00 
f0104ca0:	0f b6 90 a0 19 00 00 	movzbl 0x19a0(%eax),%edx
f0104ca7:	83 e2 e0             	and    $0xffffffe0,%edx
f0104caa:	88 90 a0 19 00 00    	mov    %dl,0x19a0(%eax)
f0104cb0:	0f b6 90 a0 19 00 00 	movzbl 0x19a0(%eax),%edx
f0104cb7:	83 e2 1f             	and    $0x1f,%edx
f0104cba:	88 90 a0 19 00 00    	mov    %dl,0x19a0(%eax)
f0104cc0:	0f b6 90 a1 19 00 00 	movzbl 0x19a1(%eax),%edx
f0104cc7:	83 e2 f0             	and    $0xfffffff0,%edx
f0104cca:	83 ca 0e             	or     $0xe,%edx
f0104ccd:	88 90 a1 19 00 00    	mov    %dl,0x19a1(%eax)
f0104cd3:	0f b6 90 a1 19 00 00 	movzbl 0x19a1(%eax),%edx
f0104cda:	83 e2 ef             	and    $0xffffffef,%edx
f0104cdd:	88 90 a1 19 00 00    	mov    %dl,0x19a1(%eax)
f0104ce3:	0f b6 90 a1 19 00 00 	movzbl 0x19a1(%eax),%edx
f0104cea:	83 e2 9f             	and    $0xffffff9f,%edx
f0104ced:	88 90 a1 19 00 00    	mov    %dl,0x19a1(%eax)
f0104cf3:	0f b6 90 a1 19 00 00 	movzbl 0x19a1(%eax),%edx
f0104cfa:	83 ca 80             	or     $0xffffff80,%edx
f0104cfd:	88 90 a1 19 00 00    	mov    %dl,0x19a1(%eax)
f0104d03:	c7 c2 f4 5a 10 f0    	mov    $0xf0105af4,%edx
f0104d09:	c1 ea 10             	shr    $0x10,%edx
f0104d0c:	66 89 90 a2 19 00 00 	mov    %dx,0x19a2(%eax)
	SETGATE(idt[T_DEVICE], 0, GD_KT, DEVICE, 0);
f0104d13:	c7 c2 fa 5a 10 f0    	mov    $0xf0105afa,%edx
f0104d19:	66 89 90 a4 19 00 00 	mov    %dx,0x19a4(%eax)
f0104d20:	66 c7 80 a6 19 00 00 	movw   $0x8,0x19a6(%eax)
f0104d27:	08 00 
f0104d29:	0f b6 90 a8 19 00 00 	movzbl 0x19a8(%eax),%edx
f0104d30:	83 e2 e0             	and    $0xffffffe0,%edx
f0104d33:	88 90 a8 19 00 00    	mov    %dl,0x19a8(%eax)
f0104d39:	0f b6 90 a8 19 00 00 	movzbl 0x19a8(%eax),%edx
f0104d40:	83 e2 1f             	and    $0x1f,%edx
f0104d43:	88 90 a8 19 00 00    	mov    %dl,0x19a8(%eax)
f0104d49:	0f b6 90 a9 19 00 00 	movzbl 0x19a9(%eax),%edx
f0104d50:	83 e2 f0             	and    $0xfffffff0,%edx
f0104d53:	83 ca 0e             	or     $0xe,%edx
f0104d56:	88 90 a9 19 00 00    	mov    %dl,0x19a9(%eax)
f0104d5c:	0f b6 90 a9 19 00 00 	movzbl 0x19a9(%eax),%edx
f0104d63:	83 e2 ef             	and    $0xffffffef,%edx
f0104d66:	88 90 a9 19 00 00    	mov    %dl,0x19a9(%eax)
f0104d6c:	0f b6 90 a9 19 00 00 	movzbl 0x19a9(%eax),%edx
f0104d73:	83 e2 9f             	and    $0xffffff9f,%edx
f0104d76:	88 90 a9 19 00 00    	mov    %dl,0x19a9(%eax)
f0104d7c:	0f b6 90 a9 19 00 00 	movzbl 0x19a9(%eax),%edx
f0104d83:	83 ca 80             	or     $0xffffff80,%edx
f0104d86:	88 90 a9 19 00 00    	mov    %dl,0x19a9(%eax)
f0104d8c:	c7 c2 fa 5a 10 f0    	mov    $0xf0105afa,%edx
f0104d92:	c1 ea 10             	shr    $0x10,%edx
f0104d95:	66 89 90 aa 19 00 00 	mov    %dx,0x19aa(%eax)
	SETGATE(idt[T_DBLFLT], 0, GD_KT, DBLFLT, 0);
f0104d9c:	c7 c2 00 5b 10 f0    	mov    $0xf0105b00,%edx
f0104da2:	66 89 90 ac 19 00 00 	mov    %dx,0x19ac(%eax)
f0104da9:	66 c7 80 ae 19 00 00 	movw   $0x8,0x19ae(%eax)
f0104db0:	08 00 
f0104db2:	0f b6 90 b0 19 00 00 	movzbl 0x19b0(%eax),%edx
f0104db9:	83 e2 e0             	and    $0xffffffe0,%edx
f0104dbc:	88 90 b0 19 00 00    	mov    %dl,0x19b0(%eax)
f0104dc2:	0f b6 90 b0 19 00 00 	movzbl 0x19b0(%eax),%edx
f0104dc9:	83 e2 1f             	and    $0x1f,%edx
f0104dcc:	88 90 b0 19 00 00    	mov    %dl,0x19b0(%eax)
f0104dd2:	0f b6 90 b1 19 00 00 	movzbl 0x19b1(%eax),%edx
f0104dd9:	83 e2 f0             	and    $0xfffffff0,%edx
f0104ddc:	83 ca 0e             	or     $0xe,%edx
f0104ddf:	88 90 b1 19 00 00    	mov    %dl,0x19b1(%eax)
f0104de5:	0f b6 90 b1 19 00 00 	movzbl 0x19b1(%eax),%edx
f0104dec:	83 e2 ef             	and    $0xffffffef,%edx
f0104def:	88 90 b1 19 00 00    	mov    %dl,0x19b1(%eax)
f0104df5:	0f b6 90 b1 19 00 00 	movzbl 0x19b1(%eax),%edx
f0104dfc:	83 e2 9f             	and    $0xffffff9f,%edx
f0104dff:	88 90 b1 19 00 00    	mov    %dl,0x19b1(%eax)
f0104e05:	0f b6 90 b1 19 00 00 	movzbl 0x19b1(%eax),%edx
f0104e0c:	83 ca 80             	or     $0xffffff80,%edx
f0104e0f:	88 90 b1 19 00 00    	mov    %dl,0x19b1(%eax)
f0104e15:	c7 c2 00 5b 10 f0    	mov    $0xf0105b00,%edx
f0104e1b:	c1 ea 10             	shr    $0x10,%edx
f0104e1e:	66 89 90 b2 19 00 00 	mov    %dx,0x19b2(%eax)
	SETGATE(idt[T_TSS], 0, GD_KT, TSS, 0);
f0104e25:	c7 c2 04 5b 10 f0    	mov    $0xf0105b04,%edx
f0104e2b:	66 89 90 bc 19 00 00 	mov    %dx,0x19bc(%eax)
f0104e32:	66 c7 80 be 19 00 00 	movw   $0x8,0x19be(%eax)
f0104e39:	08 00 
f0104e3b:	0f b6 90 c0 19 00 00 	movzbl 0x19c0(%eax),%edx
f0104e42:	83 e2 e0             	and    $0xffffffe0,%edx
f0104e45:	88 90 c0 19 00 00    	mov    %dl,0x19c0(%eax)
f0104e4b:	0f b6 90 c0 19 00 00 	movzbl 0x19c0(%eax),%edx
f0104e52:	83 e2 1f             	and    $0x1f,%edx
f0104e55:	88 90 c0 19 00 00    	mov    %dl,0x19c0(%eax)
f0104e5b:	0f b6 90 c1 19 00 00 	movzbl 0x19c1(%eax),%edx
f0104e62:	83 e2 f0             	and    $0xfffffff0,%edx
f0104e65:	83 ca 0e             	or     $0xe,%edx
f0104e68:	88 90 c1 19 00 00    	mov    %dl,0x19c1(%eax)
f0104e6e:	0f b6 90 c1 19 00 00 	movzbl 0x19c1(%eax),%edx
f0104e75:	83 e2 ef             	and    $0xffffffef,%edx
f0104e78:	88 90 c1 19 00 00    	mov    %dl,0x19c1(%eax)
f0104e7e:	0f b6 90 c1 19 00 00 	movzbl 0x19c1(%eax),%edx
f0104e85:	83 e2 9f             	and    $0xffffff9f,%edx
f0104e88:	88 90 c1 19 00 00    	mov    %dl,0x19c1(%eax)
f0104e8e:	0f b6 90 c1 19 00 00 	movzbl 0x19c1(%eax),%edx
f0104e95:	83 ca 80             	or     $0xffffff80,%edx
f0104e98:	88 90 c1 19 00 00    	mov    %dl,0x19c1(%eax)
f0104e9e:	c7 c2 04 5b 10 f0    	mov    $0xf0105b04,%edx
f0104ea4:	c1 ea 10             	shr    $0x10,%edx
f0104ea7:	66 89 90 c2 19 00 00 	mov    %dx,0x19c2(%eax)
	SETGATE(idt[T_SEGNP], 0, GD_KT, SEGNP, 0);
f0104eae:	c7 c2 08 5b 10 f0    	mov    $0xf0105b08,%edx
f0104eb4:	66 89 90 c4 19 00 00 	mov    %dx,0x19c4(%eax)
f0104ebb:	66 c7 80 c6 19 00 00 	movw   $0x8,0x19c6(%eax)
f0104ec2:	08 00 
f0104ec4:	0f b6 90 c8 19 00 00 	movzbl 0x19c8(%eax),%edx
f0104ecb:	83 e2 e0             	and    $0xffffffe0,%edx
f0104ece:	88 90 c8 19 00 00    	mov    %dl,0x19c8(%eax)
f0104ed4:	0f b6 90 c8 19 00 00 	movzbl 0x19c8(%eax),%edx
f0104edb:	83 e2 1f             	and    $0x1f,%edx
f0104ede:	88 90 c8 19 00 00    	mov    %dl,0x19c8(%eax)
f0104ee4:	0f b6 90 c9 19 00 00 	movzbl 0x19c9(%eax),%edx
f0104eeb:	83 e2 f0             	and    $0xfffffff0,%edx
f0104eee:	83 ca 0e             	or     $0xe,%edx
f0104ef1:	88 90 c9 19 00 00    	mov    %dl,0x19c9(%eax)
f0104ef7:	0f b6 90 c9 19 00 00 	movzbl 0x19c9(%eax),%edx
f0104efe:	83 e2 ef             	and    $0xffffffef,%edx
f0104f01:	88 90 c9 19 00 00    	mov    %dl,0x19c9(%eax)
f0104f07:	0f b6 90 c9 19 00 00 	movzbl 0x19c9(%eax),%edx
f0104f0e:	83 e2 9f             	and    $0xffffff9f,%edx
f0104f11:	88 90 c9 19 00 00    	mov    %dl,0x19c9(%eax)
f0104f17:	0f b6 90 c9 19 00 00 	movzbl 0x19c9(%eax),%edx
f0104f1e:	83 ca 80             	or     $0xffffff80,%edx
f0104f21:	88 90 c9 19 00 00    	mov    %dl,0x19c9(%eax)
f0104f27:	c7 c2 08 5b 10 f0    	mov    $0xf0105b08,%edx
f0104f2d:	c1 ea 10             	shr    $0x10,%edx
f0104f30:	66 89 90 ca 19 00 00 	mov    %dx,0x19ca(%eax)
	SETGATE(idt[T_STACK], 0, GD_KT, STACK, 0);
f0104f37:	c7 c2 0c 5b 10 f0    	mov    $0xf0105b0c,%edx
f0104f3d:	66 89 90 cc 19 00 00 	mov    %dx,0x19cc(%eax)
f0104f44:	66 c7 80 ce 19 00 00 	movw   $0x8,0x19ce(%eax)
f0104f4b:	08 00 
f0104f4d:	0f b6 90 d0 19 00 00 	movzbl 0x19d0(%eax),%edx
f0104f54:	83 e2 e0             	and    $0xffffffe0,%edx
f0104f57:	88 90 d0 19 00 00    	mov    %dl,0x19d0(%eax)
f0104f5d:	0f b6 90 d0 19 00 00 	movzbl 0x19d0(%eax),%edx
f0104f64:	83 e2 1f             	and    $0x1f,%edx
f0104f67:	88 90 d0 19 00 00    	mov    %dl,0x19d0(%eax)
f0104f6d:	0f b6 90 d1 19 00 00 	movzbl 0x19d1(%eax),%edx
f0104f74:	83 e2 f0             	and    $0xfffffff0,%edx
f0104f77:	83 ca 0e             	or     $0xe,%edx
f0104f7a:	88 90 d1 19 00 00    	mov    %dl,0x19d1(%eax)
f0104f80:	0f b6 90 d1 19 00 00 	movzbl 0x19d1(%eax),%edx
f0104f87:	83 e2 ef             	and    $0xffffffef,%edx
f0104f8a:	88 90 d1 19 00 00    	mov    %dl,0x19d1(%eax)
f0104f90:	0f b6 90 d1 19 00 00 	movzbl 0x19d1(%eax),%edx
f0104f97:	83 e2 9f             	and    $0xffffff9f,%edx
f0104f9a:	88 90 d1 19 00 00    	mov    %dl,0x19d1(%eax)
f0104fa0:	0f b6 90 d1 19 00 00 	movzbl 0x19d1(%eax),%edx
f0104fa7:	83 ca 80             	or     $0xffffff80,%edx
f0104faa:	88 90 d1 19 00 00    	mov    %dl,0x19d1(%eax)
f0104fb0:	c7 c2 0c 5b 10 f0    	mov    $0xf0105b0c,%edx
f0104fb6:	c1 ea 10             	shr    $0x10,%edx
f0104fb9:	66 89 90 d2 19 00 00 	mov    %dx,0x19d2(%eax)
	SETGATE(idt[T_GPFLT], 0, GD_KT, GPFLT, 0);
f0104fc0:	c7 c2 10 5b 10 f0    	mov    $0xf0105b10,%edx
f0104fc6:	66 89 90 d4 19 00 00 	mov    %dx,0x19d4(%eax)
f0104fcd:	66 c7 80 d6 19 00 00 	movw   $0x8,0x19d6(%eax)
f0104fd4:	08 00 
f0104fd6:	0f b6 90 d8 19 00 00 	movzbl 0x19d8(%eax),%edx
f0104fdd:	83 e2 e0             	and    $0xffffffe0,%edx
f0104fe0:	88 90 d8 19 00 00    	mov    %dl,0x19d8(%eax)
f0104fe6:	0f b6 90 d8 19 00 00 	movzbl 0x19d8(%eax),%edx
f0104fed:	83 e2 1f             	and    $0x1f,%edx
f0104ff0:	88 90 d8 19 00 00    	mov    %dl,0x19d8(%eax)
f0104ff6:	0f b6 90 d9 19 00 00 	movzbl 0x19d9(%eax),%edx
f0104ffd:	83 e2 f0             	and    $0xfffffff0,%edx
f0105000:	83 ca 0e             	or     $0xe,%edx
f0105003:	88 90 d9 19 00 00    	mov    %dl,0x19d9(%eax)
f0105009:	0f b6 90 d9 19 00 00 	movzbl 0x19d9(%eax),%edx
f0105010:	83 e2 ef             	and    $0xffffffef,%edx
f0105013:	88 90 d9 19 00 00    	mov    %dl,0x19d9(%eax)
f0105019:	0f b6 90 d9 19 00 00 	movzbl 0x19d9(%eax),%edx
f0105020:	83 e2 9f             	and    $0xffffff9f,%edx
f0105023:	88 90 d9 19 00 00    	mov    %dl,0x19d9(%eax)
f0105029:	0f b6 90 d9 19 00 00 	movzbl 0x19d9(%eax),%edx
f0105030:	83 ca 80             	or     $0xffffff80,%edx
f0105033:	88 90 d9 19 00 00    	mov    %dl,0x19d9(%eax)
f0105039:	c7 c2 10 5b 10 f0    	mov    $0xf0105b10,%edx
f010503f:	c1 ea 10             	shr    $0x10,%edx
f0105042:	66 89 90 da 19 00 00 	mov    %dx,0x19da(%eax)
	SETGATE(idt[T_PGFLT], 0, GD_KT, PGFLT, 0);
f0105049:	c7 c2 14 5b 10 f0    	mov    $0xf0105b14,%edx
f010504f:	66 89 90 dc 19 00 00 	mov    %dx,0x19dc(%eax)
f0105056:	66 c7 80 de 19 00 00 	movw   $0x8,0x19de(%eax)
f010505d:	08 00 
f010505f:	0f b6 90 e0 19 00 00 	movzbl 0x19e0(%eax),%edx
f0105066:	83 e2 e0             	and    $0xffffffe0,%edx
f0105069:	88 90 e0 19 00 00    	mov    %dl,0x19e0(%eax)
f010506f:	0f b6 90 e0 19 00 00 	movzbl 0x19e0(%eax),%edx
f0105076:	83 e2 1f             	and    $0x1f,%edx
f0105079:	88 90 e0 19 00 00    	mov    %dl,0x19e0(%eax)
f010507f:	0f b6 90 e1 19 00 00 	movzbl 0x19e1(%eax),%edx
f0105086:	83 e2 f0             	and    $0xfffffff0,%edx
f0105089:	83 ca 0e             	or     $0xe,%edx
f010508c:	88 90 e1 19 00 00    	mov    %dl,0x19e1(%eax)
f0105092:	0f b6 90 e1 19 00 00 	movzbl 0x19e1(%eax),%edx
f0105099:	83 e2 ef             	and    $0xffffffef,%edx
f010509c:	88 90 e1 19 00 00    	mov    %dl,0x19e1(%eax)
f01050a2:	0f b6 90 e1 19 00 00 	movzbl 0x19e1(%eax),%edx
f01050a9:	83 e2 9f             	and    $0xffffff9f,%edx
f01050ac:	88 90 e1 19 00 00    	mov    %dl,0x19e1(%eax)
f01050b2:	0f b6 90 e1 19 00 00 	movzbl 0x19e1(%eax),%edx
f01050b9:	83 ca 80             	or     $0xffffff80,%edx
f01050bc:	88 90 e1 19 00 00    	mov    %dl,0x19e1(%eax)
f01050c2:	c7 c2 14 5b 10 f0    	mov    $0xf0105b14,%edx
f01050c8:	c1 ea 10             	shr    $0x10,%edx
f01050cb:	66 89 90 e2 19 00 00 	mov    %dx,0x19e2(%eax)
	SETGATE(idt[T_FPERR], 0, GD_KT, FPERR, 0);
f01050d2:	c7 c2 18 5b 10 f0    	mov    $0xf0105b18,%edx
f01050d8:	66 89 90 ec 19 00 00 	mov    %dx,0x19ec(%eax)
f01050df:	66 c7 80 ee 19 00 00 	movw   $0x8,0x19ee(%eax)
f01050e6:	08 00 
f01050e8:	0f b6 90 f0 19 00 00 	movzbl 0x19f0(%eax),%edx
f01050ef:	83 e2 e0             	and    $0xffffffe0,%edx
f01050f2:	88 90 f0 19 00 00    	mov    %dl,0x19f0(%eax)
f01050f8:	0f b6 90 f0 19 00 00 	movzbl 0x19f0(%eax),%edx
f01050ff:	83 e2 1f             	and    $0x1f,%edx
f0105102:	88 90 f0 19 00 00    	mov    %dl,0x19f0(%eax)
f0105108:	0f b6 90 f1 19 00 00 	movzbl 0x19f1(%eax),%edx
f010510f:	83 e2 f0             	and    $0xfffffff0,%edx
f0105112:	83 ca 0e             	or     $0xe,%edx
f0105115:	88 90 f1 19 00 00    	mov    %dl,0x19f1(%eax)
f010511b:	0f b6 90 f1 19 00 00 	movzbl 0x19f1(%eax),%edx
f0105122:	83 e2 ef             	and    $0xffffffef,%edx
f0105125:	88 90 f1 19 00 00    	mov    %dl,0x19f1(%eax)
f010512b:	0f b6 90 f1 19 00 00 	movzbl 0x19f1(%eax),%edx
f0105132:	83 e2 9f             	and    $0xffffff9f,%edx
f0105135:	88 90 f1 19 00 00    	mov    %dl,0x19f1(%eax)
f010513b:	0f b6 90 f1 19 00 00 	movzbl 0x19f1(%eax),%edx
f0105142:	83 ca 80             	or     $0xffffff80,%edx
f0105145:	88 90 f1 19 00 00    	mov    %dl,0x19f1(%eax)
f010514b:	c7 c2 18 5b 10 f0    	mov    $0xf0105b18,%edx
f0105151:	c1 ea 10             	shr    $0x10,%edx
f0105154:	66 89 90 f2 19 00 00 	mov    %dx,0x19f2(%eax)
	SETGATE(idt[T_ALIGN], 0, GD_KT, ALIGN, 0);
f010515b:	c7 c2 1e 5b 10 f0    	mov    $0xf0105b1e,%edx
f0105161:	66 89 90 f4 19 00 00 	mov    %dx,0x19f4(%eax)
f0105168:	66 c7 80 f6 19 00 00 	movw   $0x8,0x19f6(%eax)
f010516f:	08 00 
f0105171:	0f b6 90 f8 19 00 00 	movzbl 0x19f8(%eax),%edx
f0105178:	83 e2 e0             	and    $0xffffffe0,%edx
f010517b:	88 90 f8 19 00 00    	mov    %dl,0x19f8(%eax)
f0105181:	0f b6 90 f8 19 00 00 	movzbl 0x19f8(%eax),%edx
f0105188:	83 e2 1f             	and    $0x1f,%edx
f010518b:	88 90 f8 19 00 00    	mov    %dl,0x19f8(%eax)
f0105191:	0f b6 90 f9 19 00 00 	movzbl 0x19f9(%eax),%edx
f0105198:	83 e2 f0             	and    $0xfffffff0,%edx
f010519b:	83 ca 0e             	or     $0xe,%edx
f010519e:	88 90 f9 19 00 00    	mov    %dl,0x19f9(%eax)
f01051a4:	0f b6 90 f9 19 00 00 	movzbl 0x19f9(%eax),%edx
f01051ab:	83 e2 ef             	and    $0xffffffef,%edx
f01051ae:	88 90 f9 19 00 00    	mov    %dl,0x19f9(%eax)
f01051b4:	0f b6 90 f9 19 00 00 	movzbl 0x19f9(%eax),%edx
f01051bb:	83 e2 9f             	and    $0xffffff9f,%edx
f01051be:	88 90 f9 19 00 00    	mov    %dl,0x19f9(%eax)
f01051c4:	0f b6 90 f9 19 00 00 	movzbl 0x19f9(%eax),%edx
f01051cb:	83 ca 80             	or     $0xffffff80,%edx
f01051ce:	88 90 f9 19 00 00    	mov    %dl,0x19f9(%eax)
f01051d4:	c7 c2 1e 5b 10 f0    	mov    $0xf0105b1e,%edx
f01051da:	c1 ea 10             	shr    $0x10,%edx
f01051dd:	66 89 90 fa 19 00 00 	mov    %dx,0x19fa(%eax)
	SETGATE(idt[T_MCHK], 0, GD_KT, MCHK, 0);
f01051e4:	c7 c2 22 5b 10 f0    	mov    $0xf0105b22,%edx
f01051ea:	66 89 90 fc 19 00 00 	mov    %dx,0x19fc(%eax)
f01051f1:	66 c7 80 fe 19 00 00 	movw   $0x8,0x19fe(%eax)
f01051f8:	08 00 
f01051fa:	0f b6 90 00 1a 00 00 	movzbl 0x1a00(%eax),%edx
f0105201:	83 e2 e0             	and    $0xffffffe0,%edx
f0105204:	88 90 00 1a 00 00    	mov    %dl,0x1a00(%eax)
f010520a:	0f b6 90 00 1a 00 00 	movzbl 0x1a00(%eax),%edx
f0105211:	83 e2 1f             	and    $0x1f,%edx
f0105214:	88 90 00 1a 00 00    	mov    %dl,0x1a00(%eax)
f010521a:	0f b6 90 01 1a 00 00 	movzbl 0x1a01(%eax),%edx
f0105221:	83 e2 f0             	and    $0xfffffff0,%edx
f0105224:	83 ca 0e             	or     $0xe,%edx
f0105227:	88 90 01 1a 00 00    	mov    %dl,0x1a01(%eax)
f010522d:	0f b6 90 01 1a 00 00 	movzbl 0x1a01(%eax),%edx
f0105234:	83 e2 ef             	and    $0xffffffef,%edx
f0105237:	88 90 01 1a 00 00    	mov    %dl,0x1a01(%eax)
f010523d:	0f b6 90 01 1a 00 00 	movzbl 0x1a01(%eax),%edx
f0105244:	83 e2 9f             	and    $0xffffff9f,%edx
f0105247:	88 90 01 1a 00 00    	mov    %dl,0x1a01(%eax)
f010524d:	0f b6 90 01 1a 00 00 	movzbl 0x1a01(%eax),%edx
f0105254:	83 ca 80             	or     $0xffffff80,%edx
f0105257:	88 90 01 1a 00 00    	mov    %dl,0x1a01(%eax)
f010525d:	c7 c2 22 5b 10 f0    	mov    $0xf0105b22,%edx
f0105263:	c1 ea 10             	shr    $0x10,%edx
f0105266:	66 89 90 02 1a 00 00 	mov    %dx,0x1a02(%eax)
	SETGATE(idt[T_SIMDERR], 0, GD_KT, SIMDERR, 0);
f010526d:	c7 c2 28 5b 10 f0    	mov    $0xf0105b28,%edx
f0105273:	66 89 90 04 1a 00 00 	mov    %dx,0x1a04(%eax)
f010527a:	66 c7 80 06 1a 00 00 	movw   $0x8,0x1a06(%eax)
f0105281:	08 00 
f0105283:	0f b6 90 08 1a 00 00 	movzbl 0x1a08(%eax),%edx
f010528a:	83 e2 e0             	and    $0xffffffe0,%edx
f010528d:	88 90 08 1a 00 00    	mov    %dl,0x1a08(%eax)
f0105293:	0f b6 90 08 1a 00 00 	movzbl 0x1a08(%eax),%edx
f010529a:	83 e2 1f             	and    $0x1f,%edx
f010529d:	88 90 08 1a 00 00    	mov    %dl,0x1a08(%eax)
f01052a3:	0f b6 90 09 1a 00 00 	movzbl 0x1a09(%eax),%edx
f01052aa:	83 e2 f0             	and    $0xfffffff0,%edx
f01052ad:	83 ca 0e             	or     $0xe,%edx
f01052b0:	88 90 09 1a 00 00    	mov    %dl,0x1a09(%eax)
f01052b6:	0f b6 90 09 1a 00 00 	movzbl 0x1a09(%eax),%edx
f01052bd:	83 e2 ef             	and    $0xffffffef,%edx
f01052c0:	88 90 09 1a 00 00    	mov    %dl,0x1a09(%eax)
f01052c6:	0f b6 90 09 1a 00 00 	movzbl 0x1a09(%eax),%edx
f01052cd:	83 e2 9f             	and    $0xffffff9f,%edx
f01052d0:	88 90 09 1a 00 00    	mov    %dl,0x1a09(%eax)
f01052d6:	0f b6 90 09 1a 00 00 	movzbl 0x1a09(%eax),%edx
f01052dd:	83 ca 80             	or     $0xffffff80,%edx
f01052e0:	88 90 09 1a 00 00    	mov    %dl,0x1a09(%eax)
f01052e6:	c7 c2 28 5b 10 f0    	mov    $0xf0105b28,%edx
f01052ec:	c1 ea 10             	shr    $0x10,%edx
f01052ef:	66 89 90 0a 1a 00 00 	mov    %dx,0x1a0a(%eax)
	SETGATE(idt[T_SYSCALL], 0, GD_KT, SYSCALL, 3);
f01052f6:	c7 c2 2e 5b 10 f0    	mov    $0xf0105b2e,%edx
f01052fc:	66 89 90 ec 1a 00 00 	mov    %dx,0x1aec(%eax)
f0105303:	66 c7 80 ee 1a 00 00 	movw   $0x8,0x1aee(%eax)
f010530a:	08 00 
f010530c:	0f b6 90 f0 1a 00 00 	movzbl 0x1af0(%eax),%edx
f0105313:	83 e2 e0             	and    $0xffffffe0,%edx
f0105316:	88 90 f0 1a 00 00    	mov    %dl,0x1af0(%eax)
f010531c:	0f b6 90 f0 1a 00 00 	movzbl 0x1af0(%eax),%edx
f0105323:	83 e2 1f             	and    $0x1f,%edx
f0105326:	88 90 f0 1a 00 00    	mov    %dl,0x1af0(%eax)
f010532c:	0f b6 90 f1 1a 00 00 	movzbl 0x1af1(%eax),%edx
f0105333:	83 e2 f0             	and    $0xfffffff0,%edx
f0105336:	83 ca 0e             	or     $0xe,%edx
f0105339:	88 90 f1 1a 00 00    	mov    %dl,0x1af1(%eax)
f010533f:	0f b6 90 f1 1a 00 00 	movzbl 0x1af1(%eax),%edx
f0105346:	83 e2 ef             	and    $0xffffffef,%edx
f0105349:	88 90 f1 1a 00 00    	mov    %dl,0x1af1(%eax)
f010534f:	0f b6 90 f1 1a 00 00 	movzbl 0x1af1(%eax),%edx
f0105356:	83 ca 60             	or     $0x60,%edx
f0105359:	88 90 f1 1a 00 00    	mov    %dl,0x1af1(%eax)
f010535f:	0f b6 90 f1 1a 00 00 	movzbl 0x1af1(%eax),%edx
f0105366:	83 ca 80             	or     $0xffffff80,%edx
f0105369:	88 90 f1 1a 00 00    	mov    %dl,0x1af1(%eax)
f010536f:	c7 c2 2e 5b 10 f0    	mov    $0xf0105b2e,%edx
f0105375:	c1 ea 10             	shr    $0x10,%edx
f0105378:	66 89 90 f2 1a 00 00 	mov    %dx,0x1af2(%eax)
	SETGATE(idt[T_DEFAULT], 0, GD_KT, DEFAULT, 0);
f010537f:	c7 c2 34 5b 10 f0    	mov    $0xf0105b34,%edx
f0105385:	66 89 90 0c 29 00 00 	mov    %dx,0x290c(%eax)
f010538c:	66 c7 80 0e 29 00 00 	movw   $0x8,0x290e(%eax)
f0105393:	08 00 
f0105395:	0f b6 90 10 29 00 00 	movzbl 0x2910(%eax),%edx
f010539c:	83 e2 e0             	and    $0xffffffe0,%edx
f010539f:	88 90 10 29 00 00    	mov    %dl,0x2910(%eax)
f01053a5:	0f b6 90 10 29 00 00 	movzbl 0x2910(%eax),%edx
f01053ac:	83 e2 1f             	and    $0x1f,%edx
f01053af:	88 90 10 29 00 00    	mov    %dl,0x2910(%eax)
f01053b5:	0f b6 90 11 29 00 00 	movzbl 0x2911(%eax),%edx
f01053bc:	83 e2 f0             	and    $0xfffffff0,%edx
f01053bf:	83 ca 0e             	or     $0xe,%edx
f01053c2:	88 90 11 29 00 00    	mov    %dl,0x2911(%eax)
f01053c8:	0f b6 90 11 29 00 00 	movzbl 0x2911(%eax),%edx
f01053cf:	83 e2 ef             	and    $0xffffffef,%edx
f01053d2:	88 90 11 29 00 00    	mov    %dl,0x2911(%eax)
f01053d8:	0f b6 90 11 29 00 00 	movzbl 0x2911(%eax),%edx
f01053df:	83 e2 9f             	and    $0xffffff9f,%edx
f01053e2:	88 90 11 29 00 00    	mov    %dl,0x2911(%eax)
f01053e8:	0f b6 90 11 29 00 00 	movzbl 0x2911(%eax),%edx
f01053ef:	83 ca 80             	or     $0xffffff80,%edx
f01053f2:	88 90 11 29 00 00    	mov    %dl,0x2911(%eax)
f01053f8:	c7 c2 34 5b 10 f0    	mov    $0xf0105b34,%edx
f01053fe:	c1 ea 10             	shr    $0x10,%edx
f0105401:	66 89 90 12 29 00 00 	mov    %dx,0x2912(%eax)
	// Per-CPU setup 
	trap_init_percpu();
f0105408:	e8 03 00 00 00       	call   f0105410 <trap_init_percpu>
}
f010540d:	90                   	nop
f010540e:	c9                   	leave  
f010540f:	c3                   	ret    

f0105410 <trap_init_percpu>:

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0105410:	f3 0f 1e fb          	endbr32 
f0105414:	55                   	push   %ebp
f0105415:	89 e5                	mov    %esp,%ebp
f0105417:	53                   	push   %ebx
f0105418:	e8 91 ad ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f010541d:	81 c3 97 c5 08 00    	add    $0x8c597,%ebx
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
f0105423:	c7 83 70 21 00 00 00 	movl   $0xf0000000,0x2170(%ebx)
f010542a:	00 00 f0 
	ts.ts_ss0 = GD_KD;
f010542d:	66 c7 83 74 21 00 00 	movw   $0x10,0x2174(%ebx)
f0105434:	10 00 
	ts.ts_iomb = sizeof(struct Taskstate);
f0105436:	66 c7 83 d2 21 00 00 	movw   $0x68,0x21d2(%ebx)
f010543d:	68 00 

	// Initialize the TSS slot of the gdt.
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
f010543f:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f0105445:	66 c7 40 28 67 00    	movw   $0x67,0x28(%eax)
f010544b:	8d 83 6c 21 00 00    	lea    0x216c(%ebx),%eax
f0105451:	89 c2                	mov    %eax,%edx
f0105453:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f0105459:	66 89 50 2a          	mov    %dx,0x2a(%eax)
f010545d:	8d 83 6c 21 00 00    	lea    0x216c(%ebx),%eax
f0105463:	c1 e8 10             	shr    $0x10,%eax
f0105466:	89 c2                	mov    %eax,%edx
f0105468:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f010546e:	88 50 2c             	mov    %dl,0x2c(%eax)
f0105471:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f0105477:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
f010547b:	83 e2 f0             	and    $0xfffffff0,%edx
f010547e:	83 ca 09             	or     $0x9,%edx
f0105481:	88 50 2d             	mov    %dl,0x2d(%eax)
f0105484:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f010548a:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
f010548e:	83 ca 10             	or     $0x10,%edx
f0105491:	88 50 2d             	mov    %dl,0x2d(%eax)
f0105494:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f010549a:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
f010549e:	83 e2 9f             	and    $0xffffff9f,%edx
f01054a1:	88 50 2d             	mov    %dl,0x2d(%eax)
f01054a4:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f01054aa:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
f01054ae:	83 ca 80             	or     $0xffffff80,%edx
f01054b1:	88 50 2d             	mov    %dl,0x2d(%eax)
f01054b4:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f01054ba:	0f b6 50 2e          	movzbl 0x2e(%eax),%edx
f01054be:	83 e2 f0             	and    $0xfffffff0,%edx
f01054c1:	88 50 2e             	mov    %dl,0x2e(%eax)
f01054c4:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f01054ca:	0f b6 50 2e          	movzbl 0x2e(%eax),%edx
f01054ce:	83 e2 ef             	and    $0xffffffef,%edx
f01054d1:	88 50 2e             	mov    %dl,0x2e(%eax)
f01054d4:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f01054da:	0f b6 50 2e          	movzbl 0x2e(%eax),%edx
f01054de:	83 e2 df             	and    $0xffffffdf,%edx
f01054e1:	88 50 2e             	mov    %dl,0x2e(%eax)
f01054e4:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f01054ea:	0f b6 50 2e          	movzbl 0x2e(%eax),%edx
f01054ee:	83 ca 40             	or     $0x40,%edx
f01054f1:	88 50 2e             	mov    %dl,0x2e(%eax)
f01054f4:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f01054fa:	0f b6 50 2e          	movzbl 0x2e(%eax),%edx
f01054fe:	83 e2 7f             	and    $0x7f,%edx
f0105501:	88 50 2e             	mov    %dl,0x2e(%eax)
f0105504:	8d 83 6c 21 00 00    	lea    0x216c(%ebx),%eax
f010550a:	c1 e8 18             	shr    $0x18,%eax
f010550d:	89 c2                	mov    %eax,%edx
f010550f:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f0105515:	88 50 2f             	mov    %dl,0x2f(%eax)
					sizeof(struct Taskstate) - 1, 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;
f0105518:	c7 c0 00 05 12 f0    	mov    $0xf0120500,%eax
f010551e:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
f0105522:	83 e2 ef             	and    $0xffffffef,%edx
f0105525:	88 50 2d             	mov    %dl,0x2d(%eax)

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0);
f0105528:	6a 28                	push   $0x28
f010552a:	e8 80 f3 ff ff       	call   f01048af <ltr>
f010552f:	83 c4 04             	add    $0x4,%esp

	// Load the IDT
	lidt(&idt_pd);
f0105532:	8d 83 7c 16 00 00    	lea    0x167c(%ebx),%eax
f0105538:	50                   	push   %eax
f0105539:	e8 5b f3 ff ff       	call   f0104899 <lidt>
f010553e:	83 c4 04             	add    $0x4,%esp
}
f0105541:	90                   	nop
f0105542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105545:	c9                   	leave  
f0105546:	c3                   	ret    

f0105547 <print_trapframe>:

void
print_trapframe(struct Trapframe *tf)
{
f0105547:	f3 0f 1e fb          	endbr32 
f010554b:	55                   	push   %ebp
f010554c:	89 e5                	mov    %esp,%ebp
f010554e:	53                   	push   %ebx
f010554f:	83 ec 04             	sub    $0x4,%esp
f0105552:	e8 57 ac ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0105557:	81 c3 5d c4 08 00    	add    $0x8c45d,%ebx
	cprintf("TRAP frame at %p\n", tf);
f010555d:	83 ec 08             	sub    $0x8,%esp
f0105560:	ff 75 08             	pushl  0x8(%ebp)
f0105563:	8d 83 4b 68 f7 ff    	lea    -0x897b5(%ebx),%eax
f0105569:	50                   	push   %eax
f010556a:	e8 f6 f2 ff ff       	call   f0104865 <cprintf>
f010556f:	83 c4 10             	add    $0x10,%esp
	print_regs(&tf->tf_regs);
f0105572:	8b 45 08             	mov    0x8(%ebp),%eax
f0105575:	83 ec 0c             	sub    $0xc,%esp
f0105578:	50                   	push   %eax
f0105579:	e8 ce 01 00 00       	call   f010574c <print_regs>
f010557e:	83 c4 10             	add    $0x10,%esp
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0105581:	8b 45 08             	mov    0x8(%ebp),%eax
f0105584:	0f b7 40 20          	movzwl 0x20(%eax),%eax
f0105588:	0f b7 c0             	movzwl %ax,%eax
f010558b:	83 ec 08             	sub    $0x8,%esp
f010558e:	50                   	push   %eax
f010558f:	8d 83 5d 68 f7 ff    	lea    -0x897a3(%ebx),%eax
f0105595:	50                   	push   %eax
f0105596:	e8 ca f2 ff ff       	call   f0104865 <cprintf>
f010559b:	83 c4 10             	add    $0x10,%esp
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f010559e:	8b 45 08             	mov    0x8(%ebp),%eax
f01055a1:	0f b7 40 24          	movzwl 0x24(%eax),%eax
f01055a5:	0f b7 c0             	movzwl %ax,%eax
f01055a8:	83 ec 08             	sub    $0x8,%esp
f01055ab:	50                   	push   %eax
f01055ac:	8d 83 70 68 f7 ff    	lea    -0x89790(%ebx),%eax
f01055b2:	50                   	push   %eax
f01055b3:	e8 ad f2 ff ff       	call   f0104865 <cprintf>
f01055b8:	83 c4 10             	add    $0x10,%esp
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01055bb:	8b 45 08             	mov    0x8(%ebp),%eax
f01055be:	8b 40 28             	mov    0x28(%eax),%eax
f01055c1:	83 ec 0c             	sub    $0xc,%esp
f01055c4:	50                   	push   %eax
f01055c5:	e8 3b f3 ff ff       	call   f0104905 <trapname>
f01055ca:	83 c4 10             	add    $0x10,%esp
f01055cd:	8b 55 08             	mov    0x8(%ebp),%edx
f01055d0:	8b 52 28             	mov    0x28(%edx),%edx
f01055d3:	83 ec 04             	sub    $0x4,%esp
f01055d6:	50                   	push   %eax
f01055d7:	52                   	push   %edx
f01055d8:	8d 83 83 68 f7 ff    	lea    -0x8977d(%ebx),%eax
f01055de:	50                   	push   %eax
f01055df:	e8 81 f2 ff ff       	call   f0104865 <cprintf>
f01055e4:	83 c4 10             	add    $0x10,%esp
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01055e7:	8b 83 d4 21 00 00    	mov    0x21d4(%ebx),%eax
f01055ed:	39 45 08             	cmp    %eax,0x8(%ebp)
f01055f0:	75 23                	jne    f0105615 <print_trapframe+0xce>
f01055f2:	8b 45 08             	mov    0x8(%ebp),%eax
f01055f5:	8b 40 28             	mov    0x28(%eax),%eax
f01055f8:	83 f8 0e             	cmp    $0xe,%eax
f01055fb:	75 18                	jne    f0105615 <print_trapframe+0xce>
		cprintf("  cr2  0x%08x\n", rcr2());
f01055fd:	e8 ce f2 ff ff       	call   f01048d0 <rcr2>
f0105602:	83 ec 08             	sub    $0x8,%esp
f0105605:	50                   	push   %eax
f0105606:	8d 83 95 68 f7 ff    	lea    -0x8976b(%ebx),%eax
f010560c:	50                   	push   %eax
f010560d:	e8 53 f2 ff ff       	call   f0104865 <cprintf>
f0105612:	83 c4 10             	add    $0x10,%esp
	cprintf("  err  0x%08x", tf->tf_err);
f0105615:	8b 45 08             	mov    0x8(%ebp),%eax
f0105618:	8b 40 2c             	mov    0x2c(%eax),%eax
f010561b:	83 ec 08             	sub    $0x8,%esp
f010561e:	50                   	push   %eax
f010561f:	8d 83 a4 68 f7 ff    	lea    -0x8975c(%ebx),%eax
f0105625:	50                   	push   %eax
f0105626:	e8 3a f2 ff ff       	call   f0104865 <cprintf>
f010562b:	83 c4 10             	add    $0x10,%esp
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f010562e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105631:	8b 40 28             	mov    0x28(%eax),%eax
f0105634:	83 f8 0e             	cmp    $0xe,%eax
f0105637:	75 65                	jne    f010569e <print_trapframe+0x157>
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
f0105639:	8b 45 08             	mov    0x8(%ebp),%eax
f010563c:	8b 40 2c             	mov    0x2c(%eax),%eax
f010563f:	83 e0 01             	and    $0x1,%eax
		cprintf(" [%s, %s, %s]\n",
f0105642:	85 c0                	test   %eax,%eax
f0105644:	74 08                	je     f010564e <print_trapframe+0x107>
f0105646:	8d 8b b2 68 f7 ff    	lea    -0x8974e(%ebx),%ecx
f010564c:	eb 06                	jmp    f0105654 <print_trapframe+0x10d>
f010564e:	8d 8b bd 68 f7 ff    	lea    -0x89743(%ebx),%ecx
			tf->tf_err & 2 ? "write" : "read",
f0105654:	8b 45 08             	mov    0x8(%ebp),%eax
f0105657:	8b 40 2c             	mov    0x2c(%eax),%eax
f010565a:	83 e0 02             	and    $0x2,%eax
		cprintf(" [%s, %s, %s]\n",
f010565d:	85 c0                	test   %eax,%eax
f010565f:	74 08                	je     f0105669 <print_trapframe+0x122>
f0105661:	8d 93 c9 68 f7 ff    	lea    -0x89737(%ebx),%edx
f0105667:	eb 06                	jmp    f010566f <print_trapframe+0x128>
f0105669:	8d 93 cf 68 f7 ff    	lea    -0x89731(%ebx),%edx
			tf->tf_err & 4 ? "user" : "kernel",
f010566f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105672:	8b 40 2c             	mov    0x2c(%eax),%eax
f0105675:	83 e0 04             	and    $0x4,%eax
		cprintf(" [%s, %s, %s]\n",
f0105678:	85 c0                	test   %eax,%eax
f010567a:	74 08                	je     f0105684 <print_trapframe+0x13d>
f010567c:	8d 83 d4 68 f7 ff    	lea    -0x8972c(%ebx),%eax
f0105682:	eb 06                	jmp    f010568a <print_trapframe+0x143>
f0105684:	8d 83 d9 68 f7 ff    	lea    -0x89727(%ebx),%eax
f010568a:	51                   	push   %ecx
f010568b:	52                   	push   %edx
f010568c:	50                   	push   %eax
f010568d:	8d 83 e0 68 f7 ff    	lea    -0x89720(%ebx),%eax
f0105693:	50                   	push   %eax
f0105694:	e8 cc f1 ff ff       	call   f0104865 <cprintf>
f0105699:	83 c4 10             	add    $0x10,%esp
f010569c:	eb 12                	jmp    f01056b0 <print_trapframe+0x169>
	else
		cprintf("\n");
f010569e:	83 ec 0c             	sub    $0xc,%esp
f01056a1:	8d 83 ef 68 f7 ff    	lea    -0x89711(%ebx),%eax
f01056a7:	50                   	push   %eax
f01056a8:	e8 b8 f1 ff ff       	call   f0104865 <cprintf>
f01056ad:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f01056b0:	8b 45 08             	mov    0x8(%ebp),%eax
f01056b3:	8b 40 30             	mov    0x30(%eax),%eax
f01056b6:	83 ec 08             	sub    $0x8,%esp
f01056b9:	50                   	push   %eax
f01056ba:	8d 83 f1 68 f7 ff    	lea    -0x8970f(%ebx),%eax
f01056c0:	50                   	push   %eax
f01056c1:	e8 9f f1 ff ff       	call   f0104865 <cprintf>
f01056c6:	83 c4 10             	add    $0x10,%esp
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f01056c9:	8b 45 08             	mov    0x8(%ebp),%eax
f01056cc:	0f b7 40 34          	movzwl 0x34(%eax),%eax
f01056d0:	0f b7 c0             	movzwl %ax,%eax
f01056d3:	83 ec 08             	sub    $0x8,%esp
f01056d6:	50                   	push   %eax
f01056d7:	8d 83 00 69 f7 ff    	lea    -0x89700(%ebx),%eax
f01056dd:	50                   	push   %eax
f01056de:	e8 82 f1 ff ff       	call   f0104865 <cprintf>
f01056e3:	83 c4 10             	add    $0x10,%esp
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f01056e6:	8b 45 08             	mov    0x8(%ebp),%eax
f01056e9:	8b 40 38             	mov    0x38(%eax),%eax
f01056ec:	83 ec 08             	sub    $0x8,%esp
f01056ef:	50                   	push   %eax
f01056f0:	8d 83 13 69 f7 ff    	lea    -0x896ed(%ebx),%eax
f01056f6:	50                   	push   %eax
f01056f7:	e8 69 f1 ff ff       	call   f0104865 <cprintf>
f01056fc:	83 c4 10             	add    $0x10,%esp
	if ((tf->tf_cs & 3) != 0) {
f01056ff:	8b 45 08             	mov    0x8(%ebp),%eax
f0105702:	0f b7 40 34          	movzwl 0x34(%eax),%eax
f0105706:	0f b7 c0             	movzwl %ax,%eax
f0105709:	83 e0 03             	and    $0x3,%eax
f010570c:	85 c0                	test   %eax,%eax
f010570e:	74 36                	je     f0105746 <print_trapframe+0x1ff>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0105710:	8b 45 08             	mov    0x8(%ebp),%eax
f0105713:	8b 40 3c             	mov    0x3c(%eax),%eax
f0105716:	83 ec 08             	sub    $0x8,%esp
f0105719:	50                   	push   %eax
f010571a:	8d 83 22 69 f7 ff    	lea    -0x896de(%ebx),%eax
f0105720:	50                   	push   %eax
f0105721:	e8 3f f1 ff ff       	call   f0104865 <cprintf>
f0105726:	83 c4 10             	add    $0x10,%esp
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0105729:	8b 45 08             	mov    0x8(%ebp),%eax
f010572c:	0f b7 40 40          	movzwl 0x40(%eax),%eax
f0105730:	0f b7 c0             	movzwl %ax,%eax
f0105733:	83 ec 08             	sub    $0x8,%esp
f0105736:	50                   	push   %eax
f0105737:	8d 83 31 69 f7 ff    	lea    -0x896cf(%ebx),%eax
f010573d:	50                   	push   %eax
f010573e:	e8 22 f1 ff ff       	call   f0104865 <cprintf>
f0105743:	83 c4 10             	add    $0x10,%esp
	}
}
f0105746:	90                   	nop
f0105747:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010574a:	c9                   	leave  
f010574b:	c3                   	ret    

f010574c <print_regs>:

void
print_regs(struct PushRegs *regs)
{
f010574c:	f3 0f 1e fb          	endbr32 
f0105750:	55                   	push   %ebp
f0105751:	89 e5                	mov    %esp,%ebp
f0105753:	53                   	push   %ebx
f0105754:	83 ec 04             	sub    $0x4,%esp
f0105757:	e8 52 aa ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f010575c:	81 c3 58 c2 08 00    	add    $0x8c258,%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0105762:	8b 45 08             	mov    0x8(%ebp),%eax
f0105765:	8b 00                	mov    (%eax),%eax
f0105767:	83 ec 08             	sub    $0x8,%esp
f010576a:	50                   	push   %eax
f010576b:	8d 83 44 69 f7 ff    	lea    -0x896bc(%ebx),%eax
f0105771:	50                   	push   %eax
f0105772:	e8 ee f0 ff ff       	call   f0104865 <cprintf>
f0105777:	83 c4 10             	add    $0x10,%esp
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f010577a:	8b 45 08             	mov    0x8(%ebp),%eax
f010577d:	8b 40 04             	mov    0x4(%eax),%eax
f0105780:	83 ec 08             	sub    $0x8,%esp
f0105783:	50                   	push   %eax
f0105784:	8d 83 53 69 f7 ff    	lea    -0x896ad(%ebx),%eax
f010578a:	50                   	push   %eax
f010578b:	e8 d5 f0 ff ff       	call   f0104865 <cprintf>
f0105790:	83 c4 10             	add    $0x10,%esp
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0105793:	8b 45 08             	mov    0x8(%ebp),%eax
f0105796:	8b 40 08             	mov    0x8(%eax),%eax
f0105799:	83 ec 08             	sub    $0x8,%esp
f010579c:	50                   	push   %eax
f010579d:	8d 83 62 69 f7 ff    	lea    -0x8969e(%ebx),%eax
f01057a3:	50                   	push   %eax
f01057a4:	e8 bc f0 ff ff       	call   f0104865 <cprintf>
f01057a9:	83 c4 10             	add    $0x10,%esp
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f01057ac:	8b 45 08             	mov    0x8(%ebp),%eax
f01057af:	8b 40 0c             	mov    0xc(%eax),%eax
f01057b2:	83 ec 08             	sub    $0x8,%esp
f01057b5:	50                   	push   %eax
f01057b6:	8d 83 71 69 f7 ff    	lea    -0x8968f(%ebx),%eax
f01057bc:	50                   	push   %eax
f01057bd:	e8 a3 f0 ff ff       	call   f0104865 <cprintf>
f01057c2:	83 c4 10             	add    $0x10,%esp
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01057c5:	8b 45 08             	mov    0x8(%ebp),%eax
f01057c8:	8b 40 10             	mov    0x10(%eax),%eax
f01057cb:	83 ec 08             	sub    $0x8,%esp
f01057ce:	50                   	push   %eax
f01057cf:	8d 83 80 69 f7 ff    	lea    -0x89680(%ebx),%eax
f01057d5:	50                   	push   %eax
f01057d6:	e8 8a f0 ff ff       	call   f0104865 <cprintf>
f01057db:	83 c4 10             	add    $0x10,%esp
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f01057de:	8b 45 08             	mov    0x8(%ebp),%eax
f01057e1:	8b 40 14             	mov    0x14(%eax),%eax
f01057e4:	83 ec 08             	sub    $0x8,%esp
f01057e7:	50                   	push   %eax
f01057e8:	8d 83 8f 69 f7 ff    	lea    -0x89671(%ebx),%eax
f01057ee:	50                   	push   %eax
f01057ef:	e8 71 f0 ff ff       	call   f0104865 <cprintf>
f01057f4:	83 c4 10             	add    $0x10,%esp
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01057f7:	8b 45 08             	mov    0x8(%ebp),%eax
f01057fa:	8b 40 18             	mov    0x18(%eax),%eax
f01057fd:	83 ec 08             	sub    $0x8,%esp
f0105800:	50                   	push   %eax
f0105801:	8d 83 9e 69 f7 ff    	lea    -0x89662(%ebx),%eax
f0105807:	50                   	push   %eax
f0105808:	e8 58 f0 ff ff       	call   f0104865 <cprintf>
f010580d:	83 c4 10             	add    $0x10,%esp
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0105810:	8b 45 08             	mov    0x8(%ebp),%eax
f0105813:	8b 40 1c             	mov    0x1c(%eax),%eax
f0105816:	83 ec 08             	sub    $0x8,%esp
f0105819:	50                   	push   %eax
f010581a:	8d 83 ad 69 f7 ff    	lea    -0x89653(%ebx),%eax
f0105820:	50                   	push   %eax
f0105821:	e8 3f f0 ff ff       	call   f0104865 <cprintf>
f0105826:	83 c4 10             	add    $0x10,%esp
}
f0105829:	90                   	nop
f010582a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010582d:	c9                   	leave  
f010582e:	c3                   	ret    

f010582f <trap_dispatch>:

static void
trap_dispatch(struct Trapframe *tf)
{
f010582f:	f3 0f 1e fb          	endbr32 
f0105833:	55                   	push   %ebp
f0105834:	89 e5                	mov    %esp,%ebp
f0105836:	57                   	push   %edi
f0105837:	56                   	push   %esi
f0105838:	53                   	push   %ebx
f0105839:	83 ec 1c             	sub    $0x1c,%esp
f010583c:	e8 6d a9 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0105841:	81 c3 73 c1 08 00    	add    $0x8c173,%ebx
	// Handle processor exceptions.
	// LAB 3: Your code here.
	switch(tf->tf_trapno)
f0105847:	8b 45 08             	mov    0x8(%ebp),%eax
f010584a:	8b 40 28             	mov    0x28(%eax),%eax
f010584d:	83 f8 30             	cmp    $0x30,%eax
f0105850:	74 2f                	je     f0105881 <trap_dispatch+0x52>
f0105852:	83 f8 30             	cmp    $0x30,%eax
f0105855:	77 6d                	ja     f01058c4 <trap_dispatch+0x95>
f0105857:	83 f8 03             	cmp    $0x3,%eax
f010585a:	74 15                	je     f0105871 <trap_dispatch+0x42>
f010585c:	83 f8 0e             	cmp    $0xe,%eax
f010585f:	75 63                	jne    f01058c4 <trap_dispatch+0x95>
	{
		case T_PGFLT:
			page_fault_handler(tf);
f0105861:	83 ec 0c             	sub    $0xc,%esp
f0105864:	ff 75 08             	pushl  0x8(%ebp)
f0105867:	e8 d0 01 00 00       	call   f0105a3c <page_fault_handler>
f010586c:	83 c4 10             	add    $0x10,%esp
			break;
f010586f:	eb 53                	jmp    f01058c4 <trap_dispatch+0x95>
		case T_BRKPT:
			monitor(tf);
f0105871:	83 ec 0c             	sub    $0xc,%esp
f0105874:	ff 75 08             	pushl  0x8(%ebp)
f0105877:	e8 dd b6 ff ff       	call   f0100f59 <monitor>
f010587c:	83 c4 10             	add    $0x10,%esp
			break;
f010587f:	eb 43                	jmp    f01058c4 <trap_dispatch+0x95>
		case T_SYSCALL:
			tf->tf_regs.reg_eax = syscall(
f0105881:	8b 45 08             	mov    0x8(%ebp),%eax
f0105884:	8b 40 04             	mov    0x4(%eax),%eax
f0105887:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010588a:	8b 45 08             	mov    0x8(%ebp),%eax
f010588d:	8b 38                	mov    (%eax),%edi
f010588f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105892:	8b 70 10             	mov    0x10(%eax),%esi
f0105895:	8b 45 08             	mov    0x8(%ebp),%eax
f0105898:	8b 48 18             	mov    0x18(%eax),%ecx
f010589b:	8b 45 08             	mov    0x8(%ebp),%eax
f010589e:	8b 50 14             	mov    0x14(%eax),%edx
f01058a1:	8b 45 08             	mov    0x8(%ebp),%eax
f01058a4:	8b 40 1c             	mov    0x1c(%eax),%eax
f01058a7:	83 ec 08             	sub    $0x8,%esp
f01058aa:	ff 75 e4             	pushl  -0x1c(%ebp)
f01058ad:	57                   	push   %edi
f01058ae:	56                   	push   %esi
f01058af:	51                   	push   %ecx
f01058b0:	52                   	push   %edx
f01058b1:	50                   	push   %eax
f01058b2:	e8 c9 03 00 00       	call   f0105c80 <syscall>
f01058b7:	83 c4 20             	add    $0x20,%esp
f01058ba:	89 c2                	mov    %eax,%edx
f01058bc:	8b 45 08             	mov    0x8(%ebp),%eax
f01058bf:	89 50 1c             	mov    %edx,0x1c(%eax)
				tf->tf_regs.reg_ecx,
				tf->tf_regs.reg_ebx,
				tf->tf_regs.reg_edi,
				tf->tf_regs.reg_esi
			);
			return;	// !
f01058c2:	eb 4b                	jmp    f010590f <trap_dispatch+0xe0>
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f01058c4:	83 ec 0c             	sub    $0xc,%esp
f01058c7:	ff 75 08             	pushl  0x8(%ebp)
f01058ca:	e8 78 fc ff ff       	call   f0105547 <print_trapframe>
f01058cf:	83 c4 10             	add    $0x10,%esp
	if (tf->tf_cs == GD_KT)
f01058d2:	8b 45 08             	mov    0x8(%ebp),%eax
f01058d5:	0f b7 40 34          	movzwl 0x34(%eax),%eax
f01058d9:	66 83 f8 08          	cmp    $0x8,%ax
f01058dd:	75 1b                	jne    f01058fa <trap_dispatch+0xcb>
		panic("unhandled trap in kernel");
f01058df:	83 ec 04             	sub    $0x4,%esp
f01058e2:	8d 83 bc 69 f7 ff    	lea    -0x89644(%ebx),%eax
f01058e8:	50                   	push   %eax
f01058e9:	68 d1 00 00 00       	push   $0xd1
f01058ee:	8d 83 d5 69 f7 ff    	lea    -0x8962b(%ebx),%eax
f01058f4:	50                   	push   %eax
f01058f5:	e8 d3 a7 ff ff       	call   f01000cd <_panic>
	else {
		env_destroy(curenv);
f01058fa:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105900:	8b 00                	mov    (%eax),%eax
f0105902:	83 ec 0c             	sub    $0xc,%esp
f0105905:	50                   	push   %eax
f0105906:	e8 1f ed ff ff       	call   f010462a <env_destroy>
f010590b:	83 c4 10             	add    $0x10,%esp
		return;
f010590e:	90                   	nop
	}
}
f010590f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105912:	5b                   	pop    %ebx
f0105913:	5e                   	pop    %esi
f0105914:	5f                   	pop    %edi
f0105915:	5d                   	pop    %ebp
f0105916:	c3                   	ret    

f0105917 <trap>:

void
trap(struct Trapframe *tf)
{
f0105917:	f3 0f 1e fb          	endbr32 
f010591b:	55                   	push   %ebp
f010591c:	89 e5                	mov    %esp,%ebp
f010591e:	57                   	push   %edi
f010591f:	56                   	push   %esi
f0105920:	53                   	push   %ebx
f0105921:	83 ec 0c             	sub    $0xc,%esp
f0105924:	e8 85 a8 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0105929:	81 c3 8b c0 08 00    	add    $0x8c08b,%ebx
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");
f010592f:	fc                   	cld    

	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f0105930:	e8 b6 ef ff ff       	call   f01048eb <read_eflags>
f0105935:	25 00 02 00 00       	and    $0x200,%eax
f010593a:	85 c0                	test   %eax,%eax
f010593c:	74 1f                	je     f010595d <trap+0x46>
f010593e:	8d 83 e1 69 f7 ff    	lea    -0x8961f(%ebx),%eax
f0105944:	50                   	push   %eax
f0105945:	8d 83 fa 69 f7 ff    	lea    -0x89606(%ebx),%eax
f010594b:	50                   	push   %eax
f010594c:	68 e2 00 00 00       	push   $0xe2
f0105951:	8d 83 d5 69 f7 ff    	lea    -0x8962b(%ebx),%eax
f0105957:	50                   	push   %eax
f0105958:	e8 70 a7 ff ff       	call   f01000cd <_panic>

	cprintf("Incoming TRAP frame at %p and trap-no %u\n", tf, tf->tf_trapno);
f010595d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105960:	8b 40 28             	mov    0x28(%eax),%eax
f0105963:	83 ec 04             	sub    $0x4,%esp
f0105966:	50                   	push   %eax
f0105967:	ff 75 08             	pushl  0x8(%ebp)
f010596a:	8d 83 10 6a f7 ff    	lea    -0x895f0(%ebx),%eax
f0105970:	50                   	push   %eax
f0105971:	e8 ef ee ff ff       	call   f0104865 <cprintf>
f0105976:	83 c4 10             	add    $0x10,%esp

	if ((tf->tf_cs & 3) == 3) {
f0105979:	8b 45 08             	mov    0x8(%ebp),%eax
f010597c:	0f b7 40 34          	movzwl 0x34(%eax),%eax
f0105980:	0f b7 c0             	movzwl %ax,%eax
f0105983:	83 e0 03             	and    $0x3,%eax
f0105986:	83 f8 03             	cmp    $0x3,%eax
f0105989:	75 4e                	jne    f01059d9 <trap+0xc2>
		// Trapped from user mode.
		assert(curenv);
f010598b:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105991:	8b 00                	mov    (%eax),%eax
f0105993:	85 c0                	test   %eax,%eax
f0105995:	75 1f                	jne    f01059b6 <trap+0x9f>
f0105997:	8d 83 3a 6a f7 ff    	lea    -0x895c6(%ebx),%eax
f010599d:	50                   	push   %eax
f010599e:	8d 83 fa 69 f7 ff    	lea    -0x89606(%ebx),%eax
f01059a4:	50                   	push   %eax
f01059a5:	68 e8 00 00 00       	push   $0xe8
f01059aa:	8d 83 d5 69 f7 ff    	lea    -0x8962b(%ebx),%eax
f01059b0:	50                   	push   %eax
f01059b1:	e8 17 a7 ff ff       	call   f01000cd <_panic>

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
f01059b6:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f01059bc:	8b 10                	mov    (%eax),%edx
f01059be:	8b 45 08             	mov    0x8(%ebp),%eax
f01059c1:	89 c6                	mov    %eax,%esi
f01059c3:	b8 11 00 00 00       	mov    $0x11,%eax
f01059c8:	89 d7                	mov    %edx,%edi
f01059ca:	89 c1                	mov    %eax,%ecx
f01059cc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f01059ce:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f01059d4:	8b 00                	mov    (%eax),%eax
f01059d6:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f01059d9:	8b 45 08             	mov    0x8(%ebp),%eax
f01059dc:	89 83 d4 21 00 00    	mov    %eax,0x21d4(%ebx)

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
f01059e2:	83 ec 0c             	sub    $0xc,%esp
f01059e5:	ff 75 08             	pushl  0x8(%ebp)
f01059e8:	e8 42 fe ff ff       	call   f010582f <trap_dispatch>
f01059ed:	83 c4 10             	add    $0x10,%esp

	// Return to the current environment, which should be running.
	assert(curenv && curenv->env_status == ENV_RUNNING);
f01059f0:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f01059f6:	8b 00                	mov    (%eax),%eax
f01059f8:	85 c0                	test   %eax,%eax
f01059fa:	74 10                	je     f0105a0c <trap+0xf5>
f01059fc:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105a02:	8b 00                	mov    (%eax),%eax
f0105a04:	8b 40 54             	mov    0x54(%eax),%eax
f0105a07:	83 f8 03             	cmp    $0x3,%eax
f0105a0a:	74 1f                	je     f0105a2b <trap+0x114>
f0105a0c:	8d 83 44 6a f7 ff    	lea    -0x895bc(%ebx),%eax
f0105a12:	50                   	push   %eax
f0105a13:	8d 83 fa 69 f7 ff    	lea    -0x89606(%ebx),%eax
f0105a19:	50                   	push   %eax
f0105a1a:	68 fa 00 00 00       	push   $0xfa
f0105a1f:	8d 83 d5 69 f7 ff    	lea    -0x8962b(%ebx),%eax
f0105a25:	50                   	push   %eax
f0105a26:	e8 a2 a6 ff ff       	call   f01000cd <_panic>
	env_run(curenv);
f0105a2b:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105a31:	8b 00                	mov    (%eax),%eax
f0105a33:	83 ec 0c             	sub    $0xc,%esp
f0105a36:	50                   	push   %eax
f0105a37:	e8 6f ec ff ff       	call   f01046ab <env_run>

f0105a3c <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0105a3c:	f3 0f 1e fb          	endbr32 
f0105a40:	55                   	push   %ebp
f0105a41:	89 e5                	mov    %esp,%ebp
f0105a43:	53                   	push   %ebx
f0105a44:	83 ec 14             	sub    $0x14,%esp
f0105a47:	e8 62 a7 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0105a4c:	81 c3 68 bf 08 00    	add    $0x8bf68,%ebx
	uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();
f0105a52:	e8 79 ee ff ff       	call   f01048d0 <rcr2>
f0105a57:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if(tf->tf_cs == GD_KT)
f0105a5a:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a5d:	0f b7 40 34          	movzwl 0x34(%eax),%eax
f0105a61:	66 83 f8 08          	cmp    $0x8,%ax
f0105a65:	75 1b                	jne    f0105a82 <page_fault_handler+0x46>
		panic("Page fault from kernel.");
f0105a67:	83 ec 04             	sub    $0x4,%esp
f0105a6a:	8d 83 70 6a f7 ff    	lea    -0x89590(%ebx),%eax
f0105a70:	50                   	push   %eax
f0105a71:	68 0b 01 00 00       	push   $0x10b
f0105a76:	8d 83 d5 69 f7 ff    	lea    -0x8962b(%ebx),%eax
f0105a7c:	50                   	push   %eax
f0105a7d:	e8 4b a6 ff ff       	call   f01000cd <_panic>

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0105a82:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a85:	8b 50 30             	mov    0x30(%eax),%edx
		curenv->env_id, fault_va, tf->tf_eip);
f0105a88:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105a8e:	8b 00                	mov    (%eax),%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0105a90:	8b 40 48             	mov    0x48(%eax),%eax
f0105a93:	52                   	push   %edx
f0105a94:	ff 75 f4             	pushl  -0xc(%ebp)
f0105a97:	50                   	push   %eax
f0105a98:	8d 83 88 6a f7 ff    	lea    -0x89578(%ebx),%eax
f0105a9e:	50                   	push   %eax
f0105a9f:	e8 c1 ed ff ff       	call   f0104865 <cprintf>
f0105aa4:	83 c4 10             	add    $0x10,%esp
	print_trapframe(tf);
f0105aa7:	83 ec 0c             	sub    $0xc,%esp
f0105aaa:	ff 75 08             	pushl  0x8(%ebp)
f0105aad:	e8 95 fa ff ff       	call   f0105547 <print_trapframe>
f0105ab2:	83 c4 10             	add    $0x10,%esp
	env_destroy(curenv);
f0105ab5:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105abb:	8b 00                	mov    (%eax),%eax
f0105abd:	83 ec 0c             	sub    $0xc,%esp
f0105ac0:	50                   	push   %eax
f0105ac1:	e8 64 eb ff ff       	call   f010462a <env_destroy>
f0105ac6:	83 c4 10             	add    $0x10,%esp
}
f0105ac9:	90                   	nop
f0105aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105acd:	c9                   	leave  
f0105ace:	c3                   	ret    
f0105acf:	90                   	nop

f0105ad0 <DIVIDE>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(DIVIDE, T_DIVIDE)
f0105ad0:	6a 00                	push   $0x0
f0105ad2:	6a 00                	push   $0x0
f0105ad4:	eb 67                	jmp    f0105b3d <_alltraps>

f0105ad6 <DEBUG>:
TRAPHANDLER_NOEC(DEBUG, T_DEBUG)
f0105ad6:	6a 00                	push   $0x0
f0105ad8:	6a 01                	push   $0x1
f0105ada:	eb 61                	jmp    f0105b3d <_alltraps>

f0105adc <NMI>:
TRAPHANDLER_NOEC(NMI, T_NMI)
f0105adc:	6a 00                	push   $0x0
f0105ade:	6a 02                	push   $0x2
f0105ae0:	eb 5b                	jmp    f0105b3d <_alltraps>

f0105ae2 <BRKPT>:
TRAPHANDLER_NOEC(BRKPT, T_BRKPT)
f0105ae2:	6a 00                	push   $0x0
f0105ae4:	6a 03                	push   $0x3
f0105ae6:	eb 55                	jmp    f0105b3d <_alltraps>

f0105ae8 <OFLOW>:
TRAPHANDLER_NOEC(OFLOW, T_OFLOW)
f0105ae8:	6a 00                	push   $0x0
f0105aea:	6a 04                	push   $0x4
f0105aec:	eb 4f                	jmp    f0105b3d <_alltraps>

f0105aee <BOUND>:
TRAPHANDLER_NOEC(BOUND, T_BOUND)
f0105aee:	6a 00                	push   $0x0
f0105af0:	6a 05                	push   $0x5
f0105af2:	eb 49                	jmp    f0105b3d <_alltraps>

f0105af4 <ILLOP>:
TRAPHANDLER_NOEC(ILLOP, T_ILLOP)
f0105af4:	6a 00                	push   $0x0
f0105af6:	6a 06                	push   $0x6
f0105af8:	eb 43                	jmp    f0105b3d <_alltraps>

f0105afa <DEVICE>:
TRAPHANDLER_NOEC(DEVICE, T_DEVICE)
f0105afa:	6a 00                	push   $0x0
f0105afc:	6a 07                	push   $0x7
f0105afe:	eb 3d                	jmp    f0105b3d <_alltraps>

f0105b00 <DBLFLT>:
TRAPHANDLER(DBLFLT, T_DBLFLT)
f0105b00:	6a 08                	push   $0x8
f0105b02:	eb 39                	jmp    f0105b3d <_alltraps>

f0105b04 <TSS>:
TRAPHANDLER(TSS, T_TSS)
f0105b04:	6a 0a                	push   $0xa
f0105b06:	eb 35                	jmp    f0105b3d <_alltraps>

f0105b08 <SEGNP>:
TRAPHANDLER(SEGNP, T_SEGNP)
f0105b08:	6a 0b                	push   $0xb
f0105b0a:	eb 31                	jmp    f0105b3d <_alltraps>

f0105b0c <STACK>:
TRAPHANDLER(STACK, T_STACK)
f0105b0c:	6a 0c                	push   $0xc
f0105b0e:	eb 2d                	jmp    f0105b3d <_alltraps>

f0105b10 <GPFLT>:
TRAPHANDLER(GPFLT, T_GPFLT)
f0105b10:	6a 0d                	push   $0xd
f0105b12:	eb 29                	jmp    f0105b3d <_alltraps>

f0105b14 <PGFLT>:
TRAPHANDLER(PGFLT, T_PGFLT)
f0105b14:	6a 0e                	push   $0xe
f0105b16:	eb 25                	jmp    f0105b3d <_alltraps>

f0105b18 <FPERR>:
TRAPHANDLER_NOEC(FPERR, T_FPERR)
f0105b18:	6a 00                	push   $0x0
f0105b1a:	6a 10                	push   $0x10
f0105b1c:	eb 1f                	jmp    f0105b3d <_alltraps>

f0105b1e <ALIGN>:
TRAPHANDLER(ALIGN, T_ALIGN)
f0105b1e:	6a 11                	push   $0x11
f0105b20:	eb 1b                	jmp    f0105b3d <_alltraps>

f0105b22 <MCHK>:
TRAPHANDLER_NOEC(MCHK, T_MCHK)
f0105b22:	6a 00                	push   $0x0
f0105b24:	6a 12                	push   $0x12
f0105b26:	eb 15                	jmp    f0105b3d <_alltraps>

f0105b28 <SIMDERR>:
TRAPHANDLER_NOEC(SIMDERR, T_SIMDERR)
f0105b28:	6a 00                	push   $0x0
f0105b2a:	6a 13                	push   $0x13
f0105b2c:	eb 0f                	jmp    f0105b3d <_alltraps>

f0105b2e <SYSCALL>:
TRAPHANDLER_NOEC(SYSCALL, T_SYSCALL)
f0105b2e:	6a 00                	push   $0x0
f0105b30:	6a 30                	push   $0x30
f0105b32:	eb 09                	jmp    f0105b3d <_alltraps>

f0105b34 <DEFAULT>:
TRAPHANDLER_NOEC(DEFAULT, T_DEFAULT)
f0105b34:	6a 00                	push   $0x0
f0105b36:	68 f4 01 00 00       	push   $0x1f4
f0105b3b:	eb 00                	jmp    f0105b3d <_alltraps>

f0105b3d <_alltraps>:
 * Lab 3: Your code here for _alltraps
 */
 .global _alltraps
 _alltraps:
	# Build trap frame
	pushl %ds
f0105b3d:	1e                   	push   %ds
	pushl %es
f0105b3e:	06                   	push   %es
	pushal
f0105b3f:	60                   	pusha  

	# Set up data segments
	movw $(GD_KD), %ax
f0105b40:	66 b8 10 00          	mov    $0x10,%ax
	movw %ax, %ds
f0105b44:	8e d8                	mov    %eax,%ds
	movw %ax, %es
f0105b46:	8e c0                	mov    %eax,%es

	# Call trap(tf), where tf=%esp
	pushl %esp
f0105b48:	54                   	push   %esp
	call trap
f0105b49:	e8 c9 fd ff ff       	call   f0105917 <trap>

f0105b4e <sys_cputs>:
// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
f0105b4e:	f3 0f 1e fb          	endbr32 
f0105b52:	55                   	push   %ebp
f0105b53:	89 e5                	mov    %esp,%ebp
f0105b55:	53                   	push   %ebx
f0105b56:	83 ec 04             	sub    $0x4,%esp
f0105b59:	e8 50 a6 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0105b5e:	81 c3 56 be 08 00    	add    $0x8be56,%ebx
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.
	user_mem_assert(curenv, (void *)s, len, 0);
f0105b64:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105b6a:	8b 00                	mov    (%eax),%eax
f0105b6c:	6a 00                	push   $0x0
f0105b6e:	ff 75 0c             	pushl  0xc(%ebp)
f0105b71:	ff 75 08             	pushl  0x8(%ebp)
f0105b74:	50                   	push   %eax
f0105b75:	e8 0b c0 ff ff       	call   f0101b85 <user_mem_assert>
f0105b7a:	83 c4 10             	add    $0x10,%esp

	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f0105b7d:	83 ec 04             	sub    $0x4,%esp
f0105b80:	ff 75 08             	pushl  0x8(%ebp)
f0105b83:	ff 75 0c             	pushl  0xc(%ebp)
f0105b86:	8d 83 ee 6b f7 ff    	lea    -0x89412(%ebx),%eax
f0105b8c:	50                   	push   %eax
f0105b8d:	e8 d3 ec ff ff       	call   f0104865 <cprintf>
f0105b92:	83 c4 10             	add    $0x10,%esp
}
f0105b95:	90                   	nop
f0105b96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105b99:	c9                   	leave  
f0105b9a:	c3                   	ret    

f0105b9b <sys_cgetc>:

// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
f0105b9b:	f3 0f 1e fb          	endbr32 
f0105b9f:	55                   	push   %ebp
f0105ba0:	89 e5                	mov    %esp,%ebp
f0105ba2:	53                   	push   %ebx
f0105ba3:	83 ec 04             	sub    $0x4,%esp
f0105ba6:	e8 54 af ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0105bab:	05 09 be 08 00       	add    $0x8be09,%eax
	return cons_getc();
f0105bb0:	89 c3                	mov    %eax,%ebx
f0105bb2:	e8 e9 ad ff ff       	call   f01009a0 <cons_getc>
}
f0105bb7:	83 c4 04             	add    $0x4,%esp
f0105bba:	5b                   	pop    %ebx
f0105bbb:	5d                   	pop    %ebp
f0105bbc:	c3                   	ret    

f0105bbd <sys_getenvid>:

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
f0105bbd:	f3 0f 1e fb          	endbr32 
f0105bc1:	55                   	push   %ebp
f0105bc2:	89 e5                	mov    %esp,%ebp
f0105bc4:	e8 36 af ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0105bc9:	05 eb bd 08 00       	add    $0x8bdeb,%eax
	return curenv->env_id;
f0105bce:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105bd4:	8b 00                	mov    (%eax),%eax
f0105bd6:	8b 40 48             	mov    0x48(%eax),%eax
}
f0105bd9:	5d                   	pop    %ebp
f0105bda:	c3                   	ret    

f0105bdb <sys_env_destroy>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
f0105bdb:	f3 0f 1e fb          	endbr32 
f0105bdf:	55                   	push   %ebp
f0105be0:	89 e5                	mov    %esp,%ebp
f0105be2:	53                   	push   %ebx
f0105be3:	83 ec 14             	sub    $0x14,%esp
f0105be6:	e8 c3 a5 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0105beb:	81 c3 c9 bd 08 00    	add    $0x8bdc9,%ebx
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0105bf1:	83 ec 04             	sub    $0x4,%esp
f0105bf4:	6a 01                	push   $0x1
f0105bf6:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0105bf9:	50                   	push   %eax
f0105bfa:	ff 75 08             	pushl  0x8(%ebp)
f0105bfd:	e8 bc e0 ff ff       	call   f0103cbe <envid2env>
f0105c02:	83 c4 10             	add    $0x10,%esp
f0105c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0105c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0105c0c:	79 05                	jns    f0105c13 <sys_env_destroy+0x38>
		return r;
f0105c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105c11:	eb 68                	jmp    f0105c7b <sys_env_destroy+0xa0>
	if (e == curenv)
f0105c13:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105c16:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105c1c:	8b 00                	mov    (%eax),%eax
f0105c1e:	39 c2                	cmp    %eax,%edx
f0105c20:	75 20                	jne    f0105c42 <sys_env_destroy+0x67>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0105c22:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105c28:	8b 00                	mov    (%eax),%eax
f0105c2a:	8b 40 48             	mov    0x48(%eax),%eax
f0105c2d:	83 ec 08             	sub    $0x8,%esp
f0105c30:	50                   	push   %eax
f0105c31:	8d 83 f3 6b f7 ff    	lea    -0x8940d(%ebx),%eax
f0105c37:	50                   	push   %eax
f0105c38:	e8 28 ec ff ff       	call   f0104865 <cprintf>
f0105c3d:	83 c4 10             	add    $0x10,%esp
f0105c40:	eb 25                	jmp    f0105c67 <sys_env_destroy+0x8c>
	else
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0105c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105c45:	8b 50 48             	mov    0x48(%eax),%edx
f0105c48:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105c4e:	8b 00                	mov    (%eax),%eax
f0105c50:	8b 40 48             	mov    0x48(%eax),%eax
f0105c53:	83 ec 04             	sub    $0x4,%esp
f0105c56:	52                   	push   %edx
f0105c57:	50                   	push   %eax
f0105c58:	8d 83 0e 6c f7 ff    	lea    -0x893f2(%ebx),%eax
f0105c5e:	50                   	push   %eax
f0105c5f:	e8 01 ec ff ff       	call   f0104865 <cprintf>
f0105c64:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f0105c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105c6a:	83 ec 0c             	sub    $0xc,%esp
f0105c6d:	50                   	push   %eax
f0105c6e:	e8 b7 e9 ff ff       	call   f010462a <env_destroy>
f0105c73:	83 c4 10             	add    $0x10,%esp
	return 0;
f0105c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105c7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105c7e:	c9                   	leave  
f0105c7f:	c3                   	ret    

f0105c80 <syscall>:

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0105c80:	f3 0f 1e fb          	endbr32 
f0105c84:	55                   	push   %ebp
f0105c85:	89 e5                	mov    %esp,%ebp
f0105c87:	83 ec 08             	sub    $0x8,%esp
f0105c8a:	e8 70 ae ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0105c8f:	05 25 bd 08 00       	add    $0x8bd25,%eax
	// Return any appropriate return value.
	// LAB 3: Your code here.

	// panic("syscall not implemented");

	switch (syscallno) 
f0105c94:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0105c98:	74 47                	je     f0105ce1 <syscall+0x61>
f0105c9a:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0105c9e:	77 52                	ja     f0105cf2 <syscall+0x72>
f0105ca0:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0105ca4:	74 34                	je     f0105cda <syscall+0x5a>
f0105ca6:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0105caa:	77 46                	ja     f0105cf2 <syscall+0x72>
f0105cac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0105cb0:	74 08                	je     f0105cba <syscall+0x3a>
f0105cb2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
f0105cb6:	74 1b                	je     f0105cd3 <syscall+0x53>
f0105cb8:	eb 38                	jmp    f0105cf2 <syscall+0x72>
	{
		case SYS_cputs:
			sys_cputs((char *)a1, a2);
f0105cba:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105cbd:	83 ec 08             	sub    $0x8,%esp
f0105cc0:	ff 75 10             	pushl  0x10(%ebp)
f0105cc3:	50                   	push   %eax
f0105cc4:	e8 85 fe ff ff       	call   f0105b4e <sys_cputs>
f0105cc9:	83 c4 10             	add    $0x10,%esp
			return 0;
f0105ccc:	b8 00 00 00 00       	mov    $0x0,%eax
f0105cd1:	eb 24                	jmp    f0105cf7 <syscall+0x77>
		case SYS_cgetc:
			return sys_cgetc();
f0105cd3:	e8 c3 fe ff ff       	call   f0105b9b <sys_cgetc>
f0105cd8:	eb 1d                	jmp    f0105cf7 <syscall+0x77>
		case SYS_getenvid:
			return sys_getenvid();
f0105cda:	e8 de fe ff ff       	call   f0105bbd <sys_getenvid>
f0105cdf:	eb 16                	jmp    f0105cf7 <syscall+0x77>
		case SYS_env_destroy:
			return sys_env_destroy(a1);
f0105ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105ce4:	83 ec 0c             	sub    $0xc,%esp
f0105ce7:	50                   	push   %eax
f0105ce8:	e8 ee fe ff ff       	call   f0105bdb <sys_env_destroy>
f0105ced:	83 c4 10             	add    $0x10,%esp
f0105cf0:	eb 05                	jmp    f0105cf7 <syscall+0x77>
		default:
			return -E_INVAL;
f0105cf2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
}
f0105cf7:	c9                   	leave  
f0105cf8:	c3                   	ret    

f0105cf9 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105cf9:	f3 0f 1e fb          	endbr32 
f0105cfd:	55                   	push   %ebp
f0105cfe:	89 e5                	mov    %esp,%ebp
f0105d00:	83 ec 20             	sub    $0x20,%esp
f0105d03:	e8 f7 ad ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0105d08:	05 ac bc 08 00       	add    $0x8bcac,%eax
	int l = *region_left, r = *region_right, any_matches = 0;
f0105d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105d10:	8b 00                	mov    (%eax),%eax
f0105d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
f0105d15:	8b 45 10             	mov    0x10(%ebp),%eax
f0105d18:	8b 00                	mov    (%eax),%eax
f0105d1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
f0105d1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	while (l <= r) {
f0105d24:	e9 d2 00 00 00       	jmp    f0105dfb <stab_binsearch+0x102>
		int true_m = (l + r) / 2, m = true_m;
f0105d29:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0105d2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0105d2f:	01 d0                	add    %edx,%eax
f0105d31:	89 c2                	mov    %eax,%edx
f0105d33:	c1 ea 1f             	shr    $0x1f,%edx
f0105d36:	01 d0                	add    %edx,%eax
f0105d38:	d1 f8                	sar    %eax
f0105d3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105d40:	89 45 f0             	mov    %eax,-0x10(%ebp)

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105d43:	eb 04                	jmp    f0105d49 <stab_binsearch+0x50>
			m--;
f0105d45:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
		while (m >= l && stabs[m].n_type != type)
f0105d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105d4c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
f0105d4f:	7c 1f                	jl     f0105d70 <stab_binsearch+0x77>
f0105d51:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105d54:	89 d0                	mov    %edx,%eax
f0105d56:	01 c0                	add    %eax,%eax
f0105d58:	01 d0                	add    %edx,%eax
f0105d5a:	c1 e0 02             	shl    $0x2,%eax
f0105d5d:	89 c2                	mov    %eax,%edx
f0105d5f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105d62:	01 d0                	add    %edx,%eax
f0105d64:	0f b6 40 04          	movzbl 0x4(%eax),%eax
f0105d68:	0f b6 c0             	movzbl %al,%eax
f0105d6b:	39 45 14             	cmp    %eax,0x14(%ebp)
f0105d6e:	75 d5                	jne    f0105d45 <stab_binsearch+0x4c>
		if (m < l) {	// no match in [l, m]
f0105d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105d73:	3b 45 fc             	cmp    -0x4(%ebp),%eax
f0105d76:	7d 0b                	jge    f0105d83 <stab_binsearch+0x8a>
			l = true_m + 1;
f0105d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105d7b:	83 c0 01             	add    $0x1,%eax
f0105d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
			continue;
f0105d81:	eb 78                	jmp    f0105dfb <stab_binsearch+0x102>
		}

		// actual binary search
		any_matches = 1;
f0105d83:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		if (stabs[m].n_value < addr) {
f0105d8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105d8d:	89 d0                	mov    %edx,%eax
f0105d8f:	01 c0                	add    %eax,%eax
f0105d91:	01 d0                	add    %edx,%eax
f0105d93:	c1 e0 02             	shl    $0x2,%eax
f0105d96:	89 c2                	mov    %eax,%edx
f0105d98:	8b 45 08             	mov    0x8(%ebp),%eax
f0105d9b:	01 d0                	add    %edx,%eax
f0105d9d:	8b 40 08             	mov    0x8(%eax),%eax
f0105da0:	39 45 18             	cmp    %eax,0x18(%ebp)
f0105da3:	76 13                	jbe    f0105db8 <stab_binsearch+0xbf>
			*region_left = m;
f0105da5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105da8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105dab:	89 10                	mov    %edx,(%eax)
			l = true_m + 1;
f0105dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105db0:	83 c0 01             	add    $0x1,%eax
f0105db3:	89 45 fc             	mov    %eax,-0x4(%ebp)
f0105db6:	eb 43                	jmp    f0105dfb <stab_binsearch+0x102>
		} else if (stabs[m].n_value > addr) {
f0105db8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105dbb:	89 d0                	mov    %edx,%eax
f0105dbd:	01 c0                	add    %eax,%eax
f0105dbf:	01 d0                	add    %edx,%eax
f0105dc1:	c1 e0 02             	shl    $0x2,%eax
f0105dc4:	89 c2                	mov    %eax,%edx
f0105dc6:	8b 45 08             	mov    0x8(%ebp),%eax
f0105dc9:	01 d0                	add    %edx,%eax
f0105dcb:	8b 40 08             	mov    0x8(%eax),%eax
f0105dce:	39 45 18             	cmp    %eax,0x18(%ebp)
f0105dd1:	73 16                	jae    f0105de9 <stab_binsearch+0xf0>
			*region_right = m - 1;
f0105dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105dd6:	8d 50 ff             	lea    -0x1(%eax),%edx
f0105dd9:	8b 45 10             	mov    0x10(%ebp),%eax
f0105ddc:	89 10                	mov    %edx,(%eax)
			r = m - 1;
f0105dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105de1:	83 e8 01             	sub    $0x1,%eax
f0105de4:	89 45 f8             	mov    %eax,-0x8(%ebp)
f0105de7:	eb 12                	jmp    f0105dfb <stab_binsearch+0x102>
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0105de9:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105dec:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105def:	89 10                	mov    %edx,(%eax)
			l = m;
f0105df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
			addr++;
f0105df7:	83 45 18 01          	addl   $0x1,0x18(%ebp)
	while (l <= r) {
f0105dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
f0105dfe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
f0105e01:	0f 8e 22 ff ff ff    	jle    f0105d29 <stab_binsearch+0x30>
		}
	}

	if (!any_matches)
f0105e07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f0105e0b:	75 0f                	jne    f0105e1c <stab_binsearch+0x123>
		*region_right = *region_left - 1;
f0105e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105e10:	8b 00                	mov    (%eax),%eax
f0105e12:	8d 50 ff             	lea    -0x1(%eax),%edx
f0105e15:	8b 45 10             	mov    0x10(%ebp),%eax
f0105e18:	89 10                	mov    %edx,(%eax)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105e1a:	eb 3f                	jmp    f0105e5b <stab_binsearch+0x162>
		for (l = *region_right;
f0105e1c:	8b 45 10             	mov    0x10(%ebp),%eax
f0105e1f:	8b 00                	mov    (%eax),%eax
f0105e21:	89 45 fc             	mov    %eax,-0x4(%ebp)
f0105e24:	eb 04                	jmp    f0105e2a <stab_binsearch+0x131>
		     l--)
f0105e26:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
		     l > *region_left && stabs[l].n_type != type;
f0105e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105e2d:	8b 00                	mov    (%eax),%eax
		for (l = *region_right;
f0105e2f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
f0105e32:	7e 1f                	jle    f0105e53 <stab_binsearch+0x15a>
		     l > *region_left && stabs[l].n_type != type;
f0105e34:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0105e37:	89 d0                	mov    %edx,%eax
f0105e39:	01 c0                	add    %eax,%eax
f0105e3b:	01 d0                	add    %edx,%eax
f0105e3d:	c1 e0 02             	shl    $0x2,%eax
f0105e40:	89 c2                	mov    %eax,%edx
f0105e42:	8b 45 08             	mov    0x8(%ebp),%eax
f0105e45:	01 d0                	add    %edx,%eax
f0105e47:	0f b6 40 04          	movzbl 0x4(%eax),%eax
f0105e4b:	0f b6 c0             	movzbl %al,%eax
f0105e4e:	39 45 14             	cmp    %eax,0x14(%ebp)
f0105e51:	75 d3                	jne    f0105e26 <stab_binsearch+0x12d>
		*region_left = l;
f0105e53:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105e56:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0105e59:	89 10                	mov    %edx,(%eax)
}
f0105e5b:	90                   	nop
f0105e5c:	c9                   	leave  
f0105e5d:	c3                   	ret    

f0105e5e <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105e5e:	f3 0f 1e fb          	endbr32 
f0105e62:	55                   	push   %ebp
f0105e63:	89 e5                	mov    %esp,%ebp
f0105e65:	53                   	push   %ebx
f0105e66:	83 ec 34             	sub    $0x34,%esp
f0105e69:	e8 40 a3 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f0105e6e:	81 c3 46 bb 08 00    	add    $0x8bb46,%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105e74:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105e77:	8d 93 26 6c f7 ff    	lea    -0x893da(%ebx),%edx
f0105e7d:	89 10                	mov    %edx,(%eax)
	info->eip_line = 0;
f0105e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105e82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	info->eip_fn_name = "<unknown>";
f0105e89:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105e8c:	8d 93 26 6c f7 ff    	lea    -0x893da(%ebx),%edx
f0105e92:	89 50 08             	mov    %edx,0x8(%eax)
	info->eip_fn_namelen = 9;
f0105e95:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105e98:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
	info->eip_fn_addr = addr;
f0105e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105ea2:	8b 55 08             	mov    0x8(%ebp),%edx
f0105ea5:	89 50 10             	mov    %edx,0x10(%eax)
	info->eip_fn_narg = 0;
f0105ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105eab:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105eb2:	81 7d 08 ff ff 7f ef 	cmpl   $0xef7fffff,0x8(%ebp)
f0105eb9:	76 26                	jbe    f0105ee1 <debuginfo_eip+0x83>
		stabs = __STAB_BEGIN__;
f0105ebb:	c7 c0 e0 87 10 f0    	mov    $0xf01087e0,%eax
f0105ec1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		stab_end = __STAB_END__;
f0105ec4:	c7 c0 f4 30 11 f0    	mov    $0xf01130f4,%eax
f0105eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0105ecd:	c7 c0 f5 30 11 f0    	mov    $0xf01130f5,%eax
f0105ed3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		stabstr_end = __STABSTR_END__;
f0105ed6:	c7 c0 08 60 11 f0    	mov    $0xf0116008,%eax
f0105edc:	89 45 e8             	mov    %eax,-0x18(%ebp)
f0105edf:	eb 50                	jmp    f0105f31 <debuginfo_eip+0xd3>
		// The user-application linker script, user/user.ld,
		// puts information about the application's stabs (equivalent
		// to __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__, and
		// __STABSTR_END__) in a structure located at virtual address
		// USTABDATA.
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;
f0105ee1:	c7 45 e4 00 00 20 00 	movl   $0x200000,-0x1c(%ebp)

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if(user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U))
f0105ee8:	c7 c0 00 33 19 f0    	mov    $0xf0193300,%eax
f0105eee:	8b 00                	mov    (%eax),%eax
f0105ef0:	6a 04                	push   $0x4
f0105ef2:	6a 10                	push   $0x10
f0105ef4:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105ef7:	50                   	push   %eax
f0105ef8:	e8 cc bb ff ff       	call   f0101ac9 <user_mem_check>
f0105efd:	83 c4 10             	add    $0x10,%esp
f0105f00:	85 c0                	test   %eax,%eax
f0105f02:	74 0a                	je     f0105f0e <debuginfo_eip+0xb0>
			return -1;
f0105f04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f09:	e9 cd 02 00 00       	jmp    f01061db <debuginfo_eip+0x37d>

		stabs = usd->stabs;
f0105f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105f11:	8b 00                	mov    (%eax),%eax
f0105f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
		stab_end = usd->stab_end;
f0105f16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105f19:	8b 40 04             	mov    0x4(%eax),%eax
f0105f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		stabstr = usd->stabstr;
f0105f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105f22:	8b 40 08             	mov    0x8(%eax),%eax
f0105f25:	89 45 ec             	mov    %eax,-0x14(%ebp)
		stabstr_end = usd->stabstr_end;
f0105f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105f2b:	8b 40 0c             	mov    0xc(%eax),%eax
f0105f2e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0105f31:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105f34:	3b 45 ec             	cmp    -0x14(%ebp),%eax
f0105f37:	76 0d                	jbe    f0105f46 <debuginfo_eip+0xe8>
f0105f39:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105f3c:	83 e8 01             	sub    $0x1,%eax
f0105f3f:	0f b6 00             	movzbl (%eax),%eax
f0105f42:	84 c0                	test   %al,%al
f0105f44:	74 0a                	je     f0105f50 <debuginfo_eip+0xf2>
		return -1;
f0105f46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f4b:	e9 8b 02 00 00       	jmp    f01061db <debuginfo_eip+0x37d>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0105f50:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	rfile = (stab_end - stabs) - 1;
f0105f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105f5a:	2b 45 f4             	sub    -0xc(%ebp),%eax
f0105f5d:	c1 f8 02             	sar    $0x2,%eax
f0105f60:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0105f66:	83 e8 01             	sub    $0x1,%eax
f0105f69:	89 45 dc             	mov    %eax,-0x24(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0105f6c:	83 ec 0c             	sub    $0xc,%esp
f0105f6f:	ff 75 08             	pushl  0x8(%ebp)
f0105f72:	6a 64                	push   $0x64
f0105f74:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0105f77:	50                   	push   %eax
f0105f78:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105f7b:	50                   	push   %eax
f0105f7c:	ff 75 f4             	pushl  -0xc(%ebp)
f0105f7f:	e8 75 fd ff ff       	call   f0105cf9 <stab_binsearch>
f0105f84:	83 c4 20             	add    $0x20,%esp
	if (lfile == 0)
f0105f87:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105f8a:	85 c0                	test   %eax,%eax
f0105f8c:	75 0a                	jne    f0105f98 <debuginfo_eip+0x13a>
		return -1;
f0105f8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f93:	e9 43 02 00 00       	jmp    f01061db <debuginfo_eip+0x37d>

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105f9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	rfun = rfile;
f0105f9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105fa1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105fa4:	83 ec 0c             	sub    $0xc,%esp
f0105fa7:	ff 75 08             	pushl  0x8(%ebp)
f0105faa:	6a 24                	push   $0x24
f0105fac:	8d 45 d4             	lea    -0x2c(%ebp),%eax
f0105faf:	50                   	push   %eax
f0105fb0:	8d 45 d8             	lea    -0x28(%ebp),%eax
f0105fb3:	50                   	push   %eax
f0105fb4:	ff 75 f4             	pushl  -0xc(%ebp)
f0105fb7:	e8 3d fd ff ff       	call   f0105cf9 <stab_binsearch>
f0105fbc:	83 c4 20             	add    $0x20,%esp

	if (lfun <= rfun) {
f0105fbf:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105fc2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105fc5:	39 c2                	cmp    %eax,%edx
f0105fc7:	7f 78                	jg     f0106041 <debuginfo_eip+0x1e3>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105fc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105fcc:	89 c2                	mov    %eax,%edx
f0105fce:	89 d0                	mov    %edx,%eax
f0105fd0:	01 c0                	add    %eax,%eax
f0105fd2:	01 d0                	add    %edx,%eax
f0105fd4:	c1 e0 02             	shl    $0x2,%eax
f0105fd7:	89 c2                	mov    %eax,%edx
f0105fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105fdc:	01 d0                	add    %edx,%eax
f0105fde:	8b 10                	mov    (%eax),%edx
f0105fe0:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105fe3:	2b 45 ec             	sub    -0x14(%ebp),%eax
f0105fe6:	39 c2                	cmp    %eax,%edx
f0105fe8:	73 22                	jae    f010600c <debuginfo_eip+0x1ae>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105fea:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0105fed:	89 c2                	mov    %eax,%edx
f0105fef:	89 d0                	mov    %edx,%eax
f0105ff1:	01 c0                	add    %eax,%eax
f0105ff3:	01 d0                	add    %edx,%eax
f0105ff5:	c1 e0 02             	shl    $0x2,%eax
f0105ff8:	89 c2                	mov    %eax,%edx
f0105ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105ffd:	01 d0                	add    %edx,%eax
f0105fff:	8b 10                	mov    (%eax),%edx
f0106001:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106004:	01 c2                	add    %eax,%edx
f0106006:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106009:	89 50 08             	mov    %edx,0x8(%eax)
		info->eip_fn_addr = stabs[lfun].n_value;
f010600c:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010600f:	89 c2                	mov    %eax,%edx
f0106011:	89 d0                	mov    %edx,%eax
f0106013:	01 c0                	add    %eax,%eax
f0106015:	01 d0                	add    %edx,%eax
f0106017:	c1 e0 02             	shl    $0x2,%eax
f010601a:	89 c2                	mov    %eax,%edx
f010601c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010601f:	01 d0                	add    %edx,%eax
f0106021:	8b 50 08             	mov    0x8(%eax),%edx
f0106024:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106027:	89 50 10             	mov    %edx,0x10(%eax)
		addr -= info->eip_fn_addr;
f010602a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010602d:	8b 40 10             	mov    0x10(%eax),%eax
f0106030:	29 45 08             	sub    %eax,0x8(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
f0106033:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106036:	89 45 d0             	mov    %eax,-0x30(%ebp)
		rline = rfun;
f0106039:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010603c:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010603f:	eb 15                	jmp    f0106056 <debuginfo_eip+0x1f8>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0106041:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106044:	8b 55 08             	mov    0x8(%ebp),%edx
f0106047:	89 50 10             	mov    %edx,0x10(%eax)
		lline = lfile;
f010604a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010604d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		rline = rfile;
f0106050:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0106053:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0106056:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106059:	8b 40 08             	mov    0x8(%eax),%eax
f010605c:	83 ec 08             	sub    $0x8,%esp
f010605f:	6a 3a                	push   $0x3a
f0106061:	50                   	push   %eax
f0106062:	e8 7c 0b 00 00       	call   f0106be3 <strfind>
f0106067:	83 c4 10             	add    $0x10,%esp
f010606a:	8b 55 0c             	mov    0xc(%ebp),%edx
f010606d:	8b 52 08             	mov    0x8(%edx),%edx
f0106070:	29 d0                	sub    %edx,%eax
f0106072:	89 c2                	mov    %eax,%edx
f0106074:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106077:	89 50 0c             	mov    %edx,0xc(%eax)
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	// lline and rline have been assigned with lline/rline in the former step
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f010607a:	83 ec 0c             	sub    $0xc,%esp
f010607d:	ff 75 08             	pushl  0x8(%ebp)
f0106080:	6a 44                	push   $0x44
f0106082:	8d 45 cc             	lea    -0x34(%ebp),%eax
f0106085:	50                   	push   %eax
f0106086:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0106089:	50                   	push   %eax
f010608a:	ff 75 f4             	pushl  -0xc(%ebp)
f010608d:	e8 67 fc ff ff       	call   f0105cf9 <stab_binsearch>
f0106092:	83 c4 20             	add    $0x20,%esp
	if(lline > rline)
f0106095:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0106098:	8b 45 cc             	mov    -0x34(%ebp),%eax
f010609b:	39 c2                	cmp    %eax,%edx
f010609d:	7e 0a                	jle    f01060a9 <debuginfo_eip+0x24b>
		return -1;
f010609f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01060a4:	e9 32 01 00 00       	jmp    f01061db <debuginfo_eip+0x37d>
	else
		info->eip_line = stabs[lline].n_desc;
f01060a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01060ac:	89 c2                	mov    %eax,%edx
f01060ae:	89 d0                	mov    %edx,%eax
f01060b0:	01 c0                	add    %eax,%eax
f01060b2:	01 d0                	add    %edx,%eax
f01060b4:	c1 e0 02             	shl    $0x2,%eax
f01060b7:	89 c2                	mov    %eax,%edx
f01060b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01060bc:	01 d0                	add    %edx,%eax
f01060be:	0f b7 40 06          	movzwl 0x6(%eax),%eax
f01060c2:	0f b7 d0             	movzwl %ax,%edx
f01060c5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01060c8:	89 50 04             	mov    %edx,0x4(%eax)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f01060cb:	eb 09                	jmp    f01060d6 <debuginfo_eip+0x278>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f01060cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01060d0:	83 e8 01             	sub    $0x1,%eax
f01060d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
	while (lline >= lfile
f01060d6:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01060d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01060dc:	39 c2                	cmp    %eax,%edx
f01060de:	7c 56                	jl     f0106136 <debuginfo_eip+0x2d8>
	       && stabs[lline].n_type != N_SOL
f01060e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01060e3:	89 c2                	mov    %eax,%edx
f01060e5:	89 d0                	mov    %edx,%eax
f01060e7:	01 c0                	add    %eax,%eax
f01060e9:	01 d0                	add    %edx,%eax
f01060eb:	c1 e0 02             	shl    $0x2,%eax
f01060ee:	89 c2                	mov    %eax,%edx
f01060f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01060f3:	01 d0                	add    %edx,%eax
f01060f5:	0f b6 40 04          	movzbl 0x4(%eax),%eax
f01060f9:	3c 84                	cmp    $0x84,%al
f01060fb:	74 39                	je     f0106136 <debuginfo_eip+0x2d8>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01060fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106100:	89 c2                	mov    %eax,%edx
f0106102:	89 d0                	mov    %edx,%eax
f0106104:	01 c0                	add    %eax,%eax
f0106106:	01 d0                	add    %edx,%eax
f0106108:	c1 e0 02             	shl    $0x2,%eax
f010610b:	89 c2                	mov    %eax,%edx
f010610d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106110:	01 d0                	add    %edx,%eax
f0106112:	0f b6 40 04          	movzbl 0x4(%eax),%eax
f0106116:	3c 64                	cmp    $0x64,%al
f0106118:	75 b3                	jne    f01060cd <debuginfo_eip+0x26f>
f010611a:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010611d:	89 c2                	mov    %eax,%edx
f010611f:	89 d0                	mov    %edx,%eax
f0106121:	01 c0                	add    %eax,%eax
f0106123:	01 d0                	add    %edx,%eax
f0106125:	c1 e0 02             	shl    $0x2,%eax
f0106128:	89 c2                	mov    %eax,%edx
f010612a:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010612d:	01 d0                	add    %edx,%eax
f010612f:	8b 40 08             	mov    0x8(%eax),%eax
f0106132:	85 c0                	test   %eax,%eax
f0106134:	74 97                	je     f01060cd <debuginfo_eip+0x26f>
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0106136:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0106139:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010613c:	39 c2                	cmp    %eax,%edx
f010613e:	7c 42                	jl     f0106182 <debuginfo_eip+0x324>
f0106140:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106143:	89 c2                	mov    %eax,%edx
f0106145:	89 d0                	mov    %edx,%eax
f0106147:	01 c0                	add    %eax,%eax
f0106149:	01 d0                	add    %edx,%eax
f010614b:	c1 e0 02             	shl    $0x2,%eax
f010614e:	89 c2                	mov    %eax,%edx
f0106150:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106153:	01 d0                	add    %edx,%eax
f0106155:	8b 10                	mov    (%eax),%edx
f0106157:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010615a:	2b 45 ec             	sub    -0x14(%ebp),%eax
f010615d:	39 c2                	cmp    %eax,%edx
f010615f:	73 21                	jae    f0106182 <debuginfo_eip+0x324>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0106161:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0106164:	89 c2                	mov    %eax,%edx
f0106166:	89 d0                	mov    %edx,%eax
f0106168:	01 c0                	add    %eax,%eax
f010616a:	01 d0                	add    %edx,%eax
f010616c:	c1 e0 02             	shl    $0x2,%eax
f010616f:	89 c2                	mov    %eax,%edx
f0106171:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106174:	01 d0                	add    %edx,%eax
f0106176:	8b 10                	mov    (%eax),%edx
f0106178:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010617b:	01 c2                	add    %eax,%edx
f010617d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106180:	89 10                	mov    %edx,(%eax)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0106182:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0106185:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0106188:	39 c2                	cmp    %eax,%edx
f010618a:	7d 4a                	jge    f01061d6 <debuginfo_eip+0x378>
		for (lline = lfun + 1;
f010618c:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010618f:	83 c0 01             	add    $0x1,%eax
f0106192:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0106195:	eb 18                	jmp    f01061af <debuginfo_eip+0x351>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0106197:	8b 45 0c             	mov    0xc(%ebp),%eax
f010619a:	8b 40 14             	mov    0x14(%eax),%eax
f010619d:	8d 50 01             	lea    0x1(%eax),%edx
f01061a0:	8b 45 0c             	mov    0xc(%ebp),%eax
f01061a3:	89 50 14             	mov    %edx,0x14(%eax)
		     lline++)
f01061a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01061a9:	83 c0 01             	add    $0x1,%eax
f01061ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01061af:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01061b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
		for (lline = lfun + 1;
f01061b5:	39 c2                	cmp    %eax,%edx
f01061b7:	7d 1d                	jge    f01061d6 <debuginfo_eip+0x378>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01061b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01061bc:	89 c2                	mov    %eax,%edx
f01061be:	89 d0                	mov    %edx,%eax
f01061c0:	01 c0                	add    %eax,%eax
f01061c2:	01 d0                	add    %edx,%eax
f01061c4:	c1 e0 02             	shl    $0x2,%eax
f01061c7:	89 c2                	mov    %eax,%edx
f01061c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01061cc:	01 d0                	add    %edx,%eax
f01061ce:	0f b6 40 04          	movzbl 0x4(%eax),%eax
f01061d2:	3c a0                	cmp    $0xa0,%al
f01061d4:	74 c1                	je     f0106197 <debuginfo_eip+0x339>

	return 0;
f01061d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01061db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01061de:	c9                   	leave  
f01061df:	c3                   	ret    

f01061e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f01061e0:	f3 0f 1e fb          	endbr32 
f01061e4:	55                   	push   %ebp
f01061e5:	89 e5                	mov    %esp,%ebp
f01061e7:	57                   	push   %edi
f01061e8:	56                   	push   %esi
f01061e9:	53                   	push   %ebx
f01061ea:	83 ec 1c             	sub    $0x1c,%esp
f01061ed:	e8 43 06 00 00       	call   f0106835 <__x86.get_pc_thunk.si>
f01061f2:	81 c6 c2 b7 08 00    	add    $0x8b7c2,%esi
f01061f8:	8b 45 10             	mov    0x10(%ebp),%eax
f01061fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01061fe:	8b 45 14             	mov    0x14(%ebp),%eax
f0106201:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0106204:	8b 45 18             	mov    0x18(%ebp),%eax
f0106207:	ba 00 00 00 00       	mov    $0x0,%edx
f010620c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010620f:	39 45 e0             	cmp    %eax,-0x20(%ebp)
f0106212:	19 d1                	sbb    %edx,%ecx
f0106214:	72 4d                	jb     f0106263 <printnum+0x83>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0106216:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0106219:	8d 78 ff             	lea    -0x1(%eax),%edi
f010621c:	8b 45 18             	mov    0x18(%ebp),%eax
f010621f:	ba 00 00 00 00       	mov    $0x0,%edx
f0106224:	52                   	push   %edx
f0106225:	50                   	push   %eax
f0106226:	ff 75 e4             	pushl  -0x1c(%ebp)
f0106229:	ff 75 e0             	pushl  -0x20(%ebp)
f010622c:	89 f3                	mov    %esi,%ebx
f010622e:	e8 8d 0d 00 00       	call   f0106fc0 <__udivdi3>
f0106233:	83 c4 10             	add    $0x10,%esp
f0106236:	83 ec 04             	sub    $0x4,%esp
f0106239:	ff 75 20             	pushl  0x20(%ebp)
f010623c:	57                   	push   %edi
f010623d:	ff 75 18             	pushl  0x18(%ebp)
f0106240:	52                   	push   %edx
f0106241:	50                   	push   %eax
f0106242:	ff 75 0c             	pushl  0xc(%ebp)
f0106245:	ff 75 08             	pushl  0x8(%ebp)
f0106248:	e8 93 ff ff ff       	call   f01061e0 <printnum>
f010624d:	83 c4 20             	add    $0x20,%esp
f0106250:	eb 1b                	jmp    f010626d <printnum+0x8d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0106252:	83 ec 08             	sub    $0x8,%esp
f0106255:	ff 75 0c             	pushl  0xc(%ebp)
f0106258:	ff 75 20             	pushl  0x20(%ebp)
f010625b:	8b 45 08             	mov    0x8(%ebp),%eax
f010625e:	ff d0                	call   *%eax
f0106260:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0106263:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
f0106267:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
f010626b:	7f e5                	jg     f0106252 <printnum+0x72>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f010626d:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0106270:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106275:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106278:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010627b:	53                   	push   %ebx
f010627c:	51                   	push   %ecx
f010627d:	52                   	push   %edx
f010627e:	50                   	push   %eax
f010627f:	89 f3                	mov    %esi,%ebx
f0106281:	e8 4a 0e 00 00       	call   f01070d0 <__umoddi3>
f0106286:	83 c4 10             	add    $0x10,%esp
f0106289:	8d 8e 99 6c f7 ff    	lea    -0x89367(%esi),%ecx
f010628f:	01 c8                	add    %ecx,%eax
f0106291:	0f b6 00             	movzbl (%eax),%eax
f0106294:	0f be c0             	movsbl %al,%eax
f0106297:	83 ec 08             	sub    $0x8,%esp
f010629a:	ff 75 0c             	pushl  0xc(%ebp)
f010629d:	50                   	push   %eax
f010629e:	8b 45 08             	mov    0x8(%ebp),%eax
f01062a1:	ff d0                	call   *%eax
f01062a3:	83 c4 10             	add    $0x10,%esp
}
f01062a6:	90                   	nop
f01062a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01062aa:	5b                   	pop    %ebx
f01062ab:	5e                   	pop    %esi
f01062ac:	5f                   	pop    %edi
f01062ad:	5d                   	pop    %ebp
f01062ae:	c3                   	ret    

f01062af <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f01062af:	f3 0f 1e fb          	endbr32 
f01062b3:	55                   	push   %ebp
f01062b4:	89 e5                	mov    %esp,%ebp
f01062b6:	e8 44 a8 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01062bb:	05 f9 b6 08 00       	add    $0x8b6f9,%eax
	if (lflag >= 2)
f01062c0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f01062c4:	7e 14                	jle    f01062da <getuint+0x2b>
		return va_arg(*ap, unsigned long long);
f01062c6:	8b 45 08             	mov    0x8(%ebp),%eax
f01062c9:	8b 00                	mov    (%eax),%eax
f01062cb:	8d 48 08             	lea    0x8(%eax),%ecx
f01062ce:	8b 55 08             	mov    0x8(%ebp),%edx
f01062d1:	89 0a                	mov    %ecx,(%edx)
f01062d3:	8b 50 04             	mov    0x4(%eax),%edx
f01062d6:	8b 00                	mov    (%eax),%eax
f01062d8:	eb 30                	jmp    f010630a <getuint+0x5b>
	else if (lflag)
f01062da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01062de:	74 16                	je     f01062f6 <getuint+0x47>
		return va_arg(*ap, unsigned long);
f01062e0:	8b 45 08             	mov    0x8(%ebp),%eax
f01062e3:	8b 00                	mov    (%eax),%eax
f01062e5:	8d 48 04             	lea    0x4(%eax),%ecx
f01062e8:	8b 55 08             	mov    0x8(%ebp),%edx
f01062eb:	89 0a                	mov    %ecx,(%edx)
f01062ed:	8b 00                	mov    (%eax),%eax
f01062ef:	ba 00 00 00 00       	mov    $0x0,%edx
f01062f4:	eb 14                	jmp    f010630a <getuint+0x5b>
	else
		return va_arg(*ap, unsigned int);
f01062f6:	8b 45 08             	mov    0x8(%ebp),%eax
f01062f9:	8b 00                	mov    (%eax),%eax
f01062fb:	8d 48 04             	lea    0x4(%eax),%ecx
f01062fe:	8b 55 08             	mov    0x8(%ebp),%edx
f0106301:	89 0a                	mov    %ecx,(%edx)
f0106303:	8b 00                	mov    (%eax),%eax
f0106305:	ba 00 00 00 00       	mov    $0x0,%edx
}
f010630a:	5d                   	pop    %ebp
f010630b:	c3                   	ret    

f010630c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
f010630c:	f3 0f 1e fb          	endbr32 
f0106310:	55                   	push   %ebp
f0106311:	89 e5                	mov    %esp,%ebp
f0106313:	e8 e7 a7 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106318:	05 9c b6 08 00       	add    $0x8b69c,%eax
	if (lflag >= 2)
f010631d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f0106321:	7e 14                	jle    f0106337 <getint+0x2b>
		return va_arg(*ap, long long);
f0106323:	8b 45 08             	mov    0x8(%ebp),%eax
f0106326:	8b 00                	mov    (%eax),%eax
f0106328:	8d 48 08             	lea    0x8(%eax),%ecx
f010632b:	8b 55 08             	mov    0x8(%ebp),%edx
f010632e:	89 0a                	mov    %ecx,(%edx)
f0106330:	8b 50 04             	mov    0x4(%eax),%edx
f0106333:	8b 00                	mov    (%eax),%eax
f0106335:	eb 28                	jmp    f010635f <getint+0x53>
	else if (lflag)
f0106337:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f010633b:	74 12                	je     f010634f <getint+0x43>
		return va_arg(*ap, long);
f010633d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106340:	8b 00                	mov    (%eax),%eax
f0106342:	8d 48 04             	lea    0x4(%eax),%ecx
f0106345:	8b 55 08             	mov    0x8(%ebp),%edx
f0106348:	89 0a                	mov    %ecx,(%edx)
f010634a:	8b 00                	mov    (%eax),%eax
f010634c:	99                   	cltd   
f010634d:	eb 10                	jmp    f010635f <getint+0x53>
	else
		return va_arg(*ap, int);
f010634f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106352:	8b 00                	mov    (%eax),%eax
f0106354:	8d 48 04             	lea    0x4(%eax),%ecx
f0106357:	8b 55 08             	mov    0x8(%ebp),%edx
f010635a:	89 0a                	mov    %ecx,(%edx)
f010635c:	8b 00                	mov    (%eax),%eax
f010635e:	99                   	cltd   
}
f010635f:	5d                   	pop    %ebp
f0106360:	c3                   	ret    

f0106361 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0106361:	f3 0f 1e fb          	endbr32 
f0106365:	55                   	push   %ebp
f0106366:	89 e5                	mov    %esp,%ebp
f0106368:	57                   	push   %edi
f0106369:	56                   	push   %esi
f010636a:	53                   	push   %ebx
f010636b:	83 ec 2c             	sub    $0x2c,%esp
f010636e:	e8 c6 04 00 00       	call   f0106839 <__x86.get_pc_thunk.di>
f0106373:	81 c7 41 b6 08 00    	add    $0x8b641,%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0106379:	eb 17                	jmp    f0106392 <vprintfmt+0x31>
			if (ch == '\0')
f010637b:	85 db                	test   %ebx,%ebx
f010637d:	0f 84 96 03 00 00    	je     f0106719 <.L20+0x2d>
				return;
			putch(ch, putdat);
f0106383:	83 ec 08             	sub    $0x8,%esp
f0106386:	ff 75 0c             	pushl  0xc(%ebp)
f0106389:	53                   	push   %ebx
f010638a:	8b 45 08             	mov    0x8(%ebp),%eax
f010638d:	ff d0                	call   *%eax
f010638f:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0106392:	8b 45 10             	mov    0x10(%ebp),%eax
f0106395:	8d 50 01             	lea    0x1(%eax),%edx
f0106398:	89 55 10             	mov    %edx,0x10(%ebp)
f010639b:	0f b6 00             	movzbl (%eax),%eax
f010639e:	0f b6 d8             	movzbl %al,%ebx
f01063a1:	83 fb 25             	cmp    $0x25,%ebx
f01063a4:	75 d5                	jne    f010637b <vprintfmt+0x1a>
		}

		// Process a %-escape sequence
		padc = ' ';
f01063a6:	c6 45 cb 20          	movb   $0x20,-0x35(%ebp)
		width = -1;
f01063aa:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		precision = -1;
f01063b1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		lflag = 0;
f01063b8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		altflag = 0;
f01063bf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01063c6:	8b 45 10             	mov    0x10(%ebp),%eax
f01063c9:	8d 50 01             	lea    0x1(%eax),%edx
f01063cc:	89 55 10             	mov    %edx,0x10(%ebp)
f01063cf:	0f b6 00             	movzbl (%eax),%eax
f01063d2:	0f b6 d8             	movzbl %al,%ebx
f01063d5:	8d 43 dd             	lea    -0x23(%ebx),%eax
f01063d8:	83 f8 55             	cmp    $0x55,%eax
f01063db:	0f 87 0b 03 00 00    	ja     f01066ec <.L20>
f01063e1:	c1 e0 02             	shl    $0x2,%eax
f01063e4:	8b 84 38 c0 6c f7 ff 	mov    -0x89340(%eax,%edi,1),%eax
f01063eb:	01 f8                	add    %edi,%eax
f01063ed:	3e ff e0             	notrack jmp *%eax

f01063f0 <.L34>:

		// flag to pad on the right
		case '-':
			padc = '-';
f01063f0:	c6 45 cb 2d          	movb   $0x2d,-0x35(%ebp)
			goto reswitch;
f01063f4:	eb d0                	jmp    f01063c6 <vprintfmt+0x65>

f01063f6 <.L32>:

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f01063f6:	c6 45 cb 30          	movb   $0x30,-0x35(%ebp)
			goto reswitch;
f01063fa:	eb ca                	jmp    f01063c6 <vprintfmt+0x65>

f01063fc <.L31>:
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f01063fc:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				precision = precision * 10 + ch - '0';
f0106403:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0106406:	89 d0                	mov    %edx,%eax
f0106408:	c1 e0 02             	shl    $0x2,%eax
f010640b:	01 d0                	add    %edx,%eax
f010640d:	01 c0                	add    %eax,%eax
f010640f:	01 d8                	add    %ebx,%eax
f0106411:	83 e8 30             	sub    $0x30,%eax
f0106414:	89 45 d0             	mov    %eax,-0x30(%ebp)
				ch = *fmt;
f0106417:	8b 45 10             	mov    0x10(%ebp),%eax
f010641a:	0f b6 00             	movzbl (%eax),%eax
f010641d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
f0106420:	83 fb 2f             	cmp    $0x2f,%ebx
f0106423:	7e 39                	jle    f010645e <.L37+0xc>
f0106425:	83 fb 39             	cmp    $0x39,%ebx
f0106428:	7f 34                	jg     f010645e <.L37+0xc>
			for (precision = 0; ; ++fmt) {
f010642a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
				precision = precision * 10 + ch - '0';
f010642e:	eb d3                	jmp    f0106403 <.L31+0x7>

f0106430 <.L35>:
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0106430:	8b 45 14             	mov    0x14(%ebp),%eax
f0106433:	8d 50 04             	lea    0x4(%eax),%edx
f0106436:	89 55 14             	mov    %edx,0x14(%ebp)
f0106439:	8b 00                	mov    (%eax),%eax
f010643b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			goto process_precision;
f010643e:	eb 1f                	jmp    f010645f <.L37+0xd>

f0106440 <.L33>:

		case '.':
			if (width < 0)
f0106440:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0106444:	79 80                	jns    f01063c6 <vprintfmt+0x65>
				width = 0;
f0106446:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			goto reswitch;
f010644d:	e9 74 ff ff ff       	jmp    f01063c6 <vprintfmt+0x65>

f0106452 <.L37>:

		case '#':
			altflag = 1;
f0106452:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
			goto reswitch;
f0106459:	e9 68 ff ff ff       	jmp    f01063c6 <vprintfmt+0x65>
			goto process_precision;
f010645e:	90                   	nop

		process_precision:
			if (width < 0)
f010645f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0106463:	0f 89 5d ff ff ff    	jns    f01063c6 <vprintfmt+0x65>
				width = precision, precision = -1;
f0106469:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010646c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010646f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
			goto reswitch;
f0106476:	e9 4b ff ff ff       	jmp    f01063c6 <vprintfmt+0x65>

f010647b <.L27>:

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f010647b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
			goto reswitch;
f010647f:	e9 42 ff ff ff       	jmp    f01063c6 <vprintfmt+0x65>

f0106484 <.L30>:

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f0106484:	8b 45 14             	mov    0x14(%ebp),%eax
f0106487:	8d 50 04             	lea    0x4(%eax),%edx
f010648a:	89 55 14             	mov    %edx,0x14(%ebp)
f010648d:	8b 00                	mov    (%eax),%eax
f010648f:	83 ec 08             	sub    $0x8,%esp
f0106492:	ff 75 0c             	pushl  0xc(%ebp)
f0106495:	50                   	push   %eax
f0106496:	8b 45 08             	mov    0x8(%ebp),%eax
f0106499:	ff d0                	call   *%eax
f010649b:	83 c4 10             	add    $0x10,%esp
			break;
f010649e:	e9 71 02 00 00       	jmp    f0106714 <.L20+0x28>

f01064a3 <.L28>:

		// error message
		case 'e':
			err = va_arg(ap, int);
f01064a3:	8b 45 14             	mov    0x14(%ebp),%eax
f01064a6:	8d 50 04             	lea    0x4(%eax),%edx
f01064a9:	89 55 14             	mov    %edx,0x14(%ebp)
f01064ac:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
f01064ae:	85 db                	test   %ebx,%ebx
f01064b0:	79 02                	jns    f01064b4 <.L28+0x11>
				err = -err;
f01064b2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01064b4:	83 fb 06             	cmp    $0x6,%ebx
f01064b7:	7f 0b                	jg     f01064c4 <.L28+0x21>
f01064b9:	8b b4 9f dc 16 00 00 	mov    0x16dc(%edi,%ebx,4),%esi
f01064c0:	85 f6                	test   %esi,%esi
f01064c2:	75 1b                	jne    f01064df <.L28+0x3c>
				printfmt(putch, putdat, "error %d", err);
f01064c4:	53                   	push   %ebx
f01064c5:	8d 87 aa 6c f7 ff    	lea    -0x89356(%edi),%eax
f01064cb:	50                   	push   %eax
f01064cc:	ff 75 0c             	pushl  0xc(%ebp)
f01064cf:	ff 75 08             	pushl  0x8(%ebp)
f01064d2:	e8 4b 02 00 00       	call   f0106722 <printfmt>
f01064d7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
f01064da:	e9 35 02 00 00       	jmp    f0106714 <.L20+0x28>
				printfmt(putch, putdat, "%s", p);
f01064df:	56                   	push   %esi
f01064e0:	8d 87 b3 6c f7 ff    	lea    -0x8934d(%edi),%eax
f01064e6:	50                   	push   %eax
f01064e7:	ff 75 0c             	pushl  0xc(%ebp)
f01064ea:	ff 75 08             	pushl  0x8(%ebp)
f01064ed:	e8 30 02 00 00       	call   f0106722 <printfmt>
f01064f2:	83 c4 10             	add    $0x10,%esp
			break;
f01064f5:	e9 1a 02 00 00       	jmp    f0106714 <.L20+0x28>

f01064fa <.L24>:

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f01064fa:	8b 45 14             	mov    0x14(%ebp),%eax
f01064fd:	8d 50 04             	lea    0x4(%eax),%edx
f0106500:	89 55 14             	mov    %edx,0x14(%ebp)
f0106503:	8b 30                	mov    (%eax),%esi
f0106505:	85 f6                	test   %esi,%esi
f0106507:	75 06                	jne    f010650f <.L24+0x15>
				p = "(null)";
f0106509:	8d b7 b6 6c f7 ff    	lea    -0x8934a(%edi),%esi
			if (width > 0 && padc != '-')
f010650f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0106513:	7e 71                	jle    f0106586 <.L24+0x8c>
f0106515:	80 7d cb 2d          	cmpb   $0x2d,-0x35(%ebp)
f0106519:	74 6b                	je     f0106586 <.L24+0x8c>
				for (width -= strnlen(p, precision); width > 0; width--)
f010651b:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010651e:	83 ec 08             	sub    $0x8,%esp
f0106521:	50                   	push   %eax
f0106522:	56                   	push   %esi
f0106523:	89 fb                	mov    %edi,%ebx
f0106525:	e8 62 04 00 00       	call   f010698c <strnlen>
f010652a:	83 c4 10             	add    $0x10,%esp
f010652d:	29 45 d4             	sub    %eax,-0x2c(%ebp)
f0106530:	eb 17                	jmp    f0106549 <.L24+0x4f>
					putch(padc, putdat);
f0106532:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
f0106536:	83 ec 08             	sub    $0x8,%esp
f0106539:	ff 75 0c             	pushl  0xc(%ebp)
f010653c:	50                   	push   %eax
f010653d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106540:	ff d0                	call   *%eax
f0106542:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision); width > 0; width--)
f0106545:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
f0106549:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f010654d:	7f e3                	jg     f0106532 <.L24+0x38>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010654f:	eb 35                	jmp    f0106586 <.L24+0x8c>
				if (altflag && (ch < ' ' || ch > '~'))
f0106551:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
f0106555:	74 1c                	je     f0106573 <.L24+0x79>
f0106557:	83 fb 1f             	cmp    $0x1f,%ebx
f010655a:	7e 05                	jle    f0106561 <.L24+0x67>
f010655c:	83 fb 7e             	cmp    $0x7e,%ebx
f010655f:	7e 12                	jle    f0106573 <.L24+0x79>
					putch('?', putdat);
f0106561:	83 ec 08             	sub    $0x8,%esp
f0106564:	ff 75 0c             	pushl  0xc(%ebp)
f0106567:	6a 3f                	push   $0x3f
f0106569:	8b 45 08             	mov    0x8(%ebp),%eax
f010656c:	ff d0                	call   *%eax
f010656e:	83 c4 10             	add    $0x10,%esp
f0106571:	eb 0f                	jmp    f0106582 <.L24+0x88>
				else
					putch(ch, putdat);
f0106573:	83 ec 08             	sub    $0x8,%esp
f0106576:	ff 75 0c             	pushl  0xc(%ebp)
f0106579:	53                   	push   %ebx
f010657a:	8b 45 08             	mov    0x8(%ebp),%eax
f010657d:	ff d0                	call   *%eax
f010657f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0106582:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
f0106586:	89 f0                	mov    %esi,%eax
f0106588:	8d 70 01             	lea    0x1(%eax),%esi
f010658b:	0f b6 00             	movzbl (%eax),%eax
f010658e:	0f be d8             	movsbl %al,%ebx
f0106591:	85 db                	test   %ebx,%ebx
f0106593:	74 26                	je     f01065bb <.L24+0xc1>
f0106595:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0106599:	78 b6                	js     f0106551 <.L24+0x57>
f010659b:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
f010659f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f01065a3:	79 ac                	jns    f0106551 <.L24+0x57>
			for (; width > 0; width--)
f01065a5:	eb 14                	jmp    f01065bb <.L24+0xc1>
				putch(' ', putdat);
f01065a7:	83 ec 08             	sub    $0x8,%esp
f01065aa:	ff 75 0c             	pushl  0xc(%ebp)
f01065ad:	6a 20                	push   $0x20
f01065af:	8b 45 08             	mov    0x8(%ebp),%eax
f01065b2:	ff d0                	call   *%eax
f01065b4:	83 c4 10             	add    $0x10,%esp
			for (; width > 0; width--)
f01065b7:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
f01065bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01065bf:	7f e6                	jg     f01065a7 <.L24+0xad>
			break;
f01065c1:	e9 4e 01 00 00       	jmp    f0106714 <.L20+0x28>

f01065c6 <.L29>:

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f01065c6:	83 ec 08             	sub    $0x8,%esp
f01065c9:	ff 75 d8             	pushl  -0x28(%ebp)
f01065cc:	8d 45 14             	lea    0x14(%ebp),%eax
f01065cf:	50                   	push   %eax
f01065d0:	e8 37 fd ff ff       	call   f010630c <getint>
f01065d5:	83 c4 10             	add    $0x10,%esp
f01065d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01065db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			if ((long long) num < 0) {
f01065de:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01065e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01065e4:	85 d2                	test   %edx,%edx
f01065e6:	79 23                	jns    f010660b <.L29+0x45>
				putch('-', putdat);
f01065e8:	83 ec 08             	sub    $0x8,%esp
f01065eb:	ff 75 0c             	pushl  0xc(%ebp)
f01065ee:	6a 2d                	push   $0x2d
f01065f0:	8b 45 08             	mov    0x8(%ebp),%eax
f01065f3:	ff d0                	call   *%eax
f01065f5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
f01065f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01065fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01065fe:	f7 d8                	neg    %eax
f0106600:	83 d2 00             	adc    $0x0,%edx
f0106603:	f7 da                	neg    %edx
f0106605:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0106608:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			}
			base = 10;
f010660b:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
f0106612:	e9 9f 00 00 00       	jmp    f01066b6 <.L21+0x1f>

f0106617 <.L23>:

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0106617:	83 ec 08             	sub    $0x8,%esp
f010661a:	ff 75 d8             	pushl  -0x28(%ebp)
f010661d:	8d 45 14             	lea    0x14(%ebp),%eax
f0106620:	50                   	push   %eax
f0106621:	e8 89 fc ff ff       	call   f01062af <getuint>
f0106626:	83 c4 10             	add    $0x10,%esp
f0106629:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010662c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 10;
f010662f:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
			goto number;
f0106636:	eb 7e                	jmp    f01066b6 <.L21+0x1f>

f0106638 <.L26>:
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
f0106638:	83 ec 08             	sub    $0x8,%esp
f010663b:	ff 75 d8             	pushl  -0x28(%ebp)
f010663e:	8d 45 14             	lea    0x14(%ebp),%eax
f0106641:	50                   	push   %eax
f0106642:	e8 68 fc ff ff       	call   f01062af <getuint>
f0106647:	83 c4 10             	add    $0x10,%esp
f010664a:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010664d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 8;
f0106650:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
			goto number;
f0106657:	eb 5d                	jmp    f01066b6 <.L21+0x1f>

f0106659 <.L25>:
			break;

		// pointer
		case 'p':
			putch('0', putdat);
f0106659:	83 ec 08             	sub    $0x8,%esp
f010665c:	ff 75 0c             	pushl  0xc(%ebp)
f010665f:	6a 30                	push   $0x30
f0106661:	8b 45 08             	mov    0x8(%ebp),%eax
f0106664:	ff d0                	call   *%eax
f0106666:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
f0106669:	83 ec 08             	sub    $0x8,%esp
f010666c:	ff 75 0c             	pushl  0xc(%ebp)
f010666f:	6a 78                	push   $0x78
f0106671:	8b 45 08             	mov    0x8(%ebp),%eax
f0106674:	ff d0                	call   *%eax
f0106676:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f0106679:	8b 45 14             	mov    0x14(%ebp),%eax
f010667c:	8d 50 04             	lea    0x4(%eax),%edx
f010667f:	89 55 14             	mov    %edx,0x14(%ebp)
f0106682:	8b 00                	mov    (%eax),%eax
			num = (unsigned long long)
f0106684:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0106687:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			base = 16;
f010668e:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
			goto number;
f0106695:	eb 1f                	jmp    f01066b6 <.L21+0x1f>

f0106697 <.L21>:

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0106697:	83 ec 08             	sub    $0x8,%esp
f010669a:	ff 75 d8             	pushl  -0x28(%ebp)
f010669d:	8d 45 14             	lea    0x14(%ebp),%eax
f01066a0:	50                   	push   %eax
f01066a1:	e8 09 fc ff ff       	call   f01062af <getuint>
f01066a6:	83 c4 10             	add    $0x10,%esp
f01066a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01066ac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			base = 16;
f01066af:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
f01066b6:	0f be 55 cb          	movsbl -0x35(%ebp),%edx
f01066ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01066bd:	83 ec 04             	sub    $0x4,%esp
f01066c0:	52                   	push   %edx
f01066c1:	ff 75 d4             	pushl  -0x2c(%ebp)
f01066c4:	50                   	push   %eax
f01066c5:	ff 75 e4             	pushl  -0x1c(%ebp)
f01066c8:	ff 75 e0             	pushl  -0x20(%ebp)
f01066cb:	ff 75 0c             	pushl  0xc(%ebp)
f01066ce:	ff 75 08             	pushl  0x8(%ebp)
f01066d1:	e8 0a fb ff ff       	call   f01061e0 <printnum>
f01066d6:	83 c4 20             	add    $0x20,%esp
			break;
f01066d9:	eb 39                	jmp    f0106714 <.L20+0x28>

f01066db <.L36>:

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f01066db:	83 ec 08             	sub    $0x8,%esp
f01066de:	ff 75 0c             	pushl  0xc(%ebp)
f01066e1:	53                   	push   %ebx
f01066e2:	8b 45 08             	mov    0x8(%ebp),%eax
f01066e5:	ff d0                	call   *%eax
f01066e7:	83 c4 10             	add    $0x10,%esp
			break;
f01066ea:	eb 28                	jmp    f0106714 <.L20+0x28>

f01066ec <.L20>:

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f01066ec:	83 ec 08             	sub    $0x8,%esp
f01066ef:	ff 75 0c             	pushl  0xc(%ebp)
f01066f2:	6a 25                	push   $0x25
f01066f4:	8b 45 08             	mov    0x8(%ebp),%eax
f01066f7:	ff d0                	call   *%eax
f01066f9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
f01066fc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
f0106700:	eb 04                	jmp    f0106706 <.L20+0x1a>
f0106702:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
f0106706:	8b 45 10             	mov    0x10(%ebp),%eax
f0106709:	83 e8 01             	sub    $0x1,%eax
f010670c:	0f b6 00             	movzbl (%eax),%eax
f010670f:	3c 25                	cmp    $0x25,%al
f0106711:	75 ef                	jne    f0106702 <.L20+0x16>
				/* do nothing */;
			break;
f0106713:	90                   	nop
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0106714:	e9 79 fc ff ff       	jmp    f0106392 <vprintfmt+0x31>
				return;
f0106719:	90                   	nop
		}
	}
}
f010671a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010671d:	5b                   	pop    %ebx
f010671e:	5e                   	pop    %esi
f010671f:	5f                   	pop    %edi
f0106720:	5d                   	pop    %ebp
f0106721:	c3                   	ret    

f0106722 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0106722:	f3 0f 1e fb          	endbr32 
f0106726:	55                   	push   %ebp
f0106727:	89 e5                	mov    %esp,%ebp
f0106729:	83 ec 18             	sub    $0x18,%esp
f010672c:	e8 ce a3 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106731:	05 83 b2 08 00       	add    $0x8b283,%eax
	va_list ap;

	va_start(ap, fmt);
f0106736:	8d 45 14             	lea    0x14(%ebp),%eax
f0106739:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
f010673c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010673f:	50                   	push   %eax
f0106740:	ff 75 10             	pushl  0x10(%ebp)
f0106743:	ff 75 0c             	pushl  0xc(%ebp)
f0106746:	ff 75 08             	pushl  0x8(%ebp)
f0106749:	e8 13 fc ff ff       	call   f0106361 <vprintfmt>
f010674e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
f0106751:	90                   	nop
f0106752:	c9                   	leave  
f0106753:	c3                   	ret    

f0106754 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0106754:	f3 0f 1e fb          	endbr32 
f0106758:	55                   	push   %ebp
f0106759:	89 e5                	mov    %esp,%ebp
f010675b:	e8 9f a3 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106760:	05 54 b2 08 00       	add    $0x8b254,%eax
	b->cnt++;
f0106765:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106768:	8b 40 08             	mov    0x8(%eax),%eax
f010676b:	8d 50 01             	lea    0x1(%eax),%edx
f010676e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106771:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
f0106774:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106777:	8b 10                	mov    (%eax),%edx
f0106779:	8b 45 0c             	mov    0xc(%ebp),%eax
f010677c:	8b 40 04             	mov    0x4(%eax),%eax
f010677f:	39 c2                	cmp    %eax,%edx
f0106781:	73 12                	jae    f0106795 <sprintputch+0x41>
		*b->buf++ = ch;
f0106783:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106786:	8b 00                	mov    (%eax),%eax
f0106788:	8d 48 01             	lea    0x1(%eax),%ecx
f010678b:	8b 55 0c             	mov    0xc(%ebp),%edx
f010678e:	89 0a                	mov    %ecx,(%edx)
f0106790:	8b 55 08             	mov    0x8(%ebp),%edx
f0106793:	88 10                	mov    %dl,(%eax)
}
f0106795:	90                   	nop
f0106796:	5d                   	pop    %ebp
f0106797:	c3                   	ret    

f0106798 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0106798:	f3 0f 1e fb          	endbr32 
f010679c:	55                   	push   %ebp
f010679d:	89 e5                	mov    %esp,%ebp
f010679f:	83 ec 18             	sub    $0x18,%esp
f01067a2:	e8 58 a3 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01067a7:	05 0d b2 08 00       	add    $0x8b20d,%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
f01067ac:	8b 55 08             	mov    0x8(%ebp),%edx
f01067af:	89 55 ec             	mov    %edx,-0x14(%ebp)
f01067b2:	8b 55 0c             	mov    0xc(%ebp),%edx
f01067b5:	8d 4a ff             	lea    -0x1(%edx),%ecx
f01067b8:	8b 55 08             	mov    0x8(%ebp),%edx
f01067bb:	01 ca                	add    %ecx,%edx
f01067bd:	89 55 f0             	mov    %edx,-0x10(%ebp)
f01067c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01067c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f01067cb:	74 06                	je     f01067d3 <vsnprintf+0x3b>
f01067cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01067d1:	7f 07                	jg     f01067da <vsnprintf+0x42>
		return -E_INVAL;
f01067d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01067d8:	eb 22                	jmp    f01067fc <vsnprintf+0x64>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01067da:	ff 75 14             	pushl  0x14(%ebp)
f01067dd:	ff 75 10             	pushl  0x10(%ebp)
f01067e0:	8d 55 ec             	lea    -0x14(%ebp),%edx
f01067e3:	52                   	push   %edx
f01067e4:	8d 80 a0 4d f7 ff    	lea    -0x8b260(%eax),%eax
f01067ea:	50                   	push   %eax
f01067eb:	e8 71 fb ff ff       	call   f0106361 <vprintfmt>
f01067f0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
f01067f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01067f6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01067f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f01067fc:	c9                   	leave  
f01067fd:	c3                   	ret    

f01067fe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01067fe:	f3 0f 1e fb          	endbr32 
f0106802:	55                   	push   %ebp
f0106803:	89 e5                	mov    %esp,%ebp
f0106805:	83 ec 18             	sub    $0x18,%esp
f0106808:	e8 f2 a2 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f010680d:	05 a7 b1 08 00       	add    $0x8b1a7,%eax
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106812:	8d 45 14             	lea    0x14(%ebp),%eax
f0106815:	89 45 f0             	mov    %eax,-0x10(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
f0106818:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010681b:	50                   	push   %eax
f010681c:	ff 75 10             	pushl  0x10(%ebp)
f010681f:	ff 75 0c             	pushl  0xc(%ebp)
f0106822:	ff 75 08             	pushl  0x8(%ebp)
f0106825:	e8 6e ff ff ff       	call   f0106798 <vsnprintf>
f010682a:	83 c4 10             	add    $0x10,%esp
f010682d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	va_end(ap);

	return rc;
f0106830:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0106833:	c9                   	leave  
f0106834:	c3                   	ret    

f0106835 <__x86.get_pc_thunk.si>:
f0106835:	8b 34 24             	mov    (%esp),%esi
f0106838:	c3                   	ret    

f0106839 <__x86.get_pc_thunk.di>:
f0106839:	8b 3c 24             	mov    (%esp),%edi
f010683c:	c3                   	ret    

f010683d <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010683d:	f3 0f 1e fb          	endbr32 
f0106841:	55                   	push   %ebp
f0106842:	89 e5                	mov    %esp,%ebp
f0106844:	53                   	push   %ebx
f0106845:	83 ec 14             	sub    $0x14,%esp
f0106848:	e8 61 99 ff ff       	call   f01001ae <__x86.get_pc_thunk.bx>
f010684d:	81 c3 67 b1 08 00    	add    $0x8b167,%ebx
	int i, c, echoing;

	if (prompt != NULL)
f0106853:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0106857:	74 15                	je     f010686e <readline+0x31>
		cprintf("%s", prompt);
f0106859:	83 ec 08             	sub    $0x8,%esp
f010685c:	ff 75 08             	pushl  0x8(%ebp)
f010685f:	8d 83 18 6e f7 ff    	lea    -0x891e8(%ebx),%eax
f0106865:	50                   	push   %eax
f0106866:	e8 fa df ff ff       	call   f0104865 <cprintf>
f010686b:	83 c4 10             	add    $0x10,%esp

	i = 0;
f010686e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
f0106875:	83 ec 0c             	sub    $0xc,%esp
f0106878:	6a 00                	push   $0x0
f010687a:	e8 68 a2 ff ff       	call   f0100ae7 <iscons>
f010687f:	83 c4 10             	add    $0x10,%esp
f0106882:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
f0106885:	e8 35 a2 ff ff       	call   f0100abf <getchar>
f010688a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
f010688d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f0106891:	79 1f                	jns    f01068b2 <readline+0x75>
			cprintf("read error: %e\n", c);
f0106893:	83 ec 08             	sub    $0x8,%esp
f0106896:	ff 75 ec             	pushl  -0x14(%ebp)
f0106899:	8d 83 1b 6e f7 ff    	lea    -0x891e5(%ebx),%eax
f010689f:	50                   	push   %eax
f01068a0:	e8 c0 df ff ff       	call   f0104865 <cprintf>
f01068a5:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01068a8:	b8 00 00 00 00       	mov    $0x0,%eax
f01068ad:	e9 a1 00 00 00       	jmp    f0106953 <readline+0x116>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01068b2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
f01068b6:	74 06                	je     f01068be <readline+0x81>
f01068b8:	83 7d ec 7f          	cmpl   $0x7f,-0x14(%ebp)
f01068bc:	75 1f                	jne    f01068dd <readline+0xa0>
f01068be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
f01068c2:	7e 19                	jle    f01068dd <readline+0xa0>
			if (echoing)
f01068c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f01068c8:	74 0d                	je     f01068d7 <readline+0x9a>
				cputchar('\b');
f01068ca:	83 ec 0c             	sub    $0xc,%esp
f01068cd:	6a 08                	push   $0x8
f01068cf:	e8 c6 a1 ff ff       	call   f0100a9a <cputchar>
f01068d4:	83 c4 10             	add    $0x10,%esp
			i--;
f01068d7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
f01068db:	eb 71                	jmp    f010694e <readline+0x111>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01068dd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
f01068e1:	7e 32                	jle    f0106915 <readline+0xd8>
f01068e3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
f01068ea:	7f 29                	jg     f0106915 <readline+0xd8>
			if (echoing)
f01068ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f01068f0:	74 0e                	je     f0106900 <readline+0xc3>
				cputchar(c);
f01068f2:	83 ec 0c             	sub    $0xc,%esp
f01068f5:	ff 75 ec             	pushl  -0x14(%ebp)
f01068f8:	e8 9d a1 ff ff       	call   f0100a9a <cputchar>
f01068fd:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f0106900:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106903:	8d 50 01             	lea    0x1(%eax),%edx
f0106906:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0106909:	8b 55 ec             	mov    -0x14(%ebp),%edx
f010690c:	88 94 03 ec 21 00 00 	mov    %dl,0x21ec(%ebx,%eax,1)
f0106913:	eb 39                	jmp    f010694e <readline+0x111>
		} else if (c == '\n' || c == '\r') {
f0106915:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
f0106919:	74 0a                	je     f0106925 <readline+0xe8>
f010691b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
f010691f:	0f 85 60 ff ff ff    	jne    f0106885 <readline+0x48>
			if (echoing)
f0106925:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f0106929:	74 0d                	je     f0106938 <readline+0xfb>
				cputchar('\n');
f010692b:	83 ec 0c             	sub    $0xc,%esp
f010692e:	6a 0a                	push   $0xa
f0106930:	e8 65 a1 ff ff       	call   f0100a9a <cputchar>
f0106935:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
f0106938:	8d 93 ec 21 00 00    	lea    0x21ec(%ebx),%edx
f010693e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106941:	01 d0                	add    %edx,%eax
f0106943:	c6 00 00             	movb   $0x0,(%eax)
			return buf;
f0106946:	8d 83 ec 21 00 00    	lea    0x21ec(%ebx),%eax
f010694c:	eb 05                	jmp    f0106953 <readline+0x116>
		c = getchar();
f010694e:	e9 32 ff ff ff       	jmp    f0106885 <readline+0x48>
		}
	}
}
f0106953:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106956:	c9                   	leave  
f0106957:	c3                   	ret    

f0106958 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106958:	f3 0f 1e fb          	endbr32 
f010695c:	55                   	push   %ebp
f010695d:	89 e5                	mov    %esp,%ebp
f010695f:	83 ec 10             	sub    $0x10,%esp
f0106962:	e8 98 a1 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106967:	05 4d b0 08 00       	add    $0x8b04d,%eax
	int n;

	for (n = 0; *s != '\0'; s++)
f010696c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
f0106973:	eb 08                	jmp    f010697d <strlen+0x25>
		n++;
f0106975:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; *s != '\0'; s++)
f0106979:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f010697d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106980:	0f b6 00             	movzbl (%eax),%eax
f0106983:	84 c0                	test   %al,%al
f0106985:	75 ee                	jne    f0106975 <strlen+0x1d>
	return n;
f0106987:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
f010698a:	c9                   	leave  
f010698b:	c3                   	ret    

f010698c <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010698c:	f3 0f 1e fb          	endbr32 
f0106990:	55                   	push   %ebp
f0106991:	89 e5                	mov    %esp,%ebp
f0106993:	83 ec 10             	sub    $0x10,%esp
f0106996:	e8 64 a1 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f010699b:	05 19 b0 08 00       	add    $0x8b019,%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01069a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
f01069a7:	eb 0c                	jmp    f01069b5 <strnlen+0x29>
		n++;
f01069a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01069ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f01069b1:	83 6d 0c 01          	subl   $0x1,0xc(%ebp)
f01069b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01069b9:	74 0a                	je     f01069c5 <strnlen+0x39>
f01069bb:	8b 45 08             	mov    0x8(%ebp),%eax
f01069be:	0f b6 00             	movzbl (%eax),%eax
f01069c1:	84 c0                	test   %al,%al
f01069c3:	75 e4                	jne    f01069a9 <strnlen+0x1d>
	return n;
f01069c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
f01069c8:	c9                   	leave  
f01069c9:	c3                   	ret    

f01069ca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f01069ca:	f3 0f 1e fb          	endbr32 
f01069ce:	55                   	push   %ebp
f01069cf:	89 e5                	mov    %esp,%ebp
f01069d1:	83 ec 10             	sub    $0x10,%esp
f01069d4:	e8 26 a1 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f01069d9:	05 db af 08 00       	add    $0x8afdb,%eax
	char *ret;

	ret = dst;
f01069de:	8b 45 08             	mov    0x8(%ebp),%eax
f01069e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
f01069e4:	90                   	nop
f01069e5:	8b 55 0c             	mov    0xc(%ebp),%edx
f01069e8:	8d 42 01             	lea    0x1(%edx),%eax
f01069eb:	89 45 0c             	mov    %eax,0xc(%ebp)
f01069ee:	8b 45 08             	mov    0x8(%ebp),%eax
f01069f1:	8d 48 01             	lea    0x1(%eax),%ecx
f01069f4:	89 4d 08             	mov    %ecx,0x8(%ebp)
f01069f7:	0f b6 12             	movzbl (%edx),%edx
f01069fa:	88 10                	mov    %dl,(%eax)
f01069fc:	0f b6 00             	movzbl (%eax),%eax
f01069ff:	84 c0                	test   %al,%al
f0106a01:	75 e2                	jne    f01069e5 <strcpy+0x1b>
		/* do nothing */;
	return ret;
f0106a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
f0106a06:	c9                   	leave  
f0106a07:	c3                   	ret    

f0106a08 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0106a08:	f3 0f 1e fb          	endbr32 
f0106a0c:	55                   	push   %ebp
f0106a0d:	89 e5                	mov    %esp,%ebp
f0106a0f:	83 ec 10             	sub    $0x10,%esp
f0106a12:	e8 e8 a0 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106a17:	05 9d af 08 00       	add    $0x8af9d,%eax
	int len = strlen(dst);
f0106a1c:	ff 75 08             	pushl  0x8(%ebp)
f0106a1f:	e8 34 ff ff ff       	call   f0106958 <strlen>
f0106a24:	83 c4 04             	add    $0x4,%esp
f0106a27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	strcpy(dst + len, src);
f0106a2a:	8b 55 fc             	mov    -0x4(%ebp),%edx
f0106a2d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106a30:	01 d0                	add    %edx,%eax
f0106a32:	ff 75 0c             	pushl  0xc(%ebp)
f0106a35:	50                   	push   %eax
f0106a36:	e8 8f ff ff ff       	call   f01069ca <strcpy>
f0106a3b:	83 c4 08             	add    $0x8,%esp
	return dst;
f0106a3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
f0106a41:	c9                   	leave  
f0106a42:	c3                   	ret    

f0106a43 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0106a43:	f3 0f 1e fb          	endbr32 
f0106a47:	55                   	push   %ebp
f0106a48:	89 e5                	mov    %esp,%ebp
f0106a4a:	83 ec 10             	sub    $0x10,%esp
f0106a4d:	e8 ad a0 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106a52:	05 62 af 08 00       	add    $0x8af62,%eax
	size_t i;
	char *ret;

	ret = dst;
f0106a57:	8b 45 08             	mov    0x8(%ebp),%eax
f0106a5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
f0106a5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
f0106a64:	eb 23                	jmp    f0106a89 <strncpy+0x46>
		*dst++ = *src;
f0106a66:	8b 45 08             	mov    0x8(%ebp),%eax
f0106a69:	8d 50 01             	lea    0x1(%eax),%edx
f0106a6c:	89 55 08             	mov    %edx,0x8(%ebp)
f0106a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106a72:	0f b6 12             	movzbl (%edx),%edx
f0106a75:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
f0106a77:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106a7a:	0f b6 00             	movzbl (%eax),%eax
f0106a7d:	84 c0                	test   %al,%al
f0106a7f:	74 04                	je     f0106a85 <strncpy+0x42>
			src++;
f0106a81:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	for (i = 0; i < size; i++) {
f0106a85:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
f0106a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
f0106a8c:	3b 45 10             	cmp    0x10(%ebp),%eax
f0106a8f:	72 d5                	jb     f0106a66 <strncpy+0x23>
	}
	return ret;
f0106a91:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
f0106a94:	c9                   	leave  
f0106a95:	c3                   	ret    

f0106a96 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0106a96:	f3 0f 1e fb          	endbr32 
f0106a9a:	55                   	push   %ebp
f0106a9b:	89 e5                	mov    %esp,%ebp
f0106a9d:	83 ec 10             	sub    $0x10,%esp
f0106aa0:	e8 5a a0 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106aa5:	05 0f af 08 00       	add    $0x8af0f,%eax
	char *dst_in;

	dst_in = dst;
f0106aaa:	8b 45 08             	mov    0x8(%ebp),%eax
f0106aad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
f0106ab0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0106ab4:	74 33                	je     f0106ae9 <strlcpy+0x53>
		while (--size > 0 && *src != '\0')
f0106ab6:	eb 17                	jmp    f0106acf <strlcpy+0x39>
			*dst++ = *src++;
f0106ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106abb:	8d 42 01             	lea    0x1(%edx),%eax
f0106abe:	89 45 0c             	mov    %eax,0xc(%ebp)
f0106ac1:	8b 45 08             	mov    0x8(%ebp),%eax
f0106ac4:	8d 48 01             	lea    0x1(%eax),%ecx
f0106ac7:	89 4d 08             	mov    %ecx,0x8(%ebp)
f0106aca:	0f b6 12             	movzbl (%edx),%edx
f0106acd:	88 10                	mov    %dl,(%eax)
		while (--size > 0 && *src != '\0')
f0106acf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
f0106ad3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0106ad7:	74 0a                	je     f0106ae3 <strlcpy+0x4d>
f0106ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106adc:	0f b6 00             	movzbl (%eax),%eax
f0106adf:	84 c0                	test   %al,%al
f0106ae1:	75 d5                	jne    f0106ab8 <strlcpy+0x22>
		*dst = '\0';
f0106ae3:	8b 45 08             	mov    0x8(%ebp),%eax
f0106ae6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0106ae9:	8b 45 08             	mov    0x8(%ebp),%eax
f0106aec:	2b 45 fc             	sub    -0x4(%ebp),%eax
}
f0106aef:	c9                   	leave  
f0106af0:	c3                   	ret    

f0106af1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0106af1:	f3 0f 1e fb          	endbr32 
f0106af5:	55                   	push   %ebp
f0106af6:	89 e5                	mov    %esp,%ebp
f0106af8:	e8 02 a0 ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106afd:	05 b7 ae 08 00       	add    $0x8aeb7,%eax
	while (*p && *p == *q)
f0106b02:	eb 08                	jmp    f0106b0c <strcmp+0x1b>
		p++, q++;
f0106b04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0106b08:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (*p && *p == *q)
f0106b0c:	8b 45 08             	mov    0x8(%ebp),%eax
f0106b0f:	0f b6 00             	movzbl (%eax),%eax
f0106b12:	84 c0                	test   %al,%al
f0106b14:	74 10                	je     f0106b26 <strcmp+0x35>
f0106b16:	8b 45 08             	mov    0x8(%ebp),%eax
f0106b19:	0f b6 10             	movzbl (%eax),%edx
f0106b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106b1f:	0f b6 00             	movzbl (%eax),%eax
f0106b22:	38 c2                	cmp    %al,%dl
f0106b24:	74 de                	je     f0106b04 <strcmp+0x13>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106b26:	8b 45 08             	mov    0x8(%ebp),%eax
f0106b29:	0f b6 00             	movzbl (%eax),%eax
f0106b2c:	0f b6 d0             	movzbl %al,%edx
f0106b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106b32:	0f b6 00             	movzbl (%eax),%eax
f0106b35:	0f b6 c0             	movzbl %al,%eax
f0106b38:	29 c2                	sub    %eax,%edx
f0106b3a:	89 d0                	mov    %edx,%eax
}
f0106b3c:	5d                   	pop    %ebp
f0106b3d:	c3                   	ret    

f0106b3e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0106b3e:	f3 0f 1e fb          	endbr32 
f0106b42:	55                   	push   %ebp
f0106b43:	89 e5                	mov    %esp,%ebp
f0106b45:	e8 b5 9f ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106b4a:	05 6a ae 08 00       	add    $0x8ae6a,%eax
	while (n > 0 && *p && *p == *q)
f0106b4f:	eb 0c                	jmp    f0106b5d <strncmp+0x1f>
		n--, p++, q++;
f0106b51:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
f0106b55:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0106b59:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
	while (n > 0 && *p && *p == *q)
f0106b5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0106b61:	74 1a                	je     f0106b7d <strncmp+0x3f>
f0106b63:	8b 45 08             	mov    0x8(%ebp),%eax
f0106b66:	0f b6 00             	movzbl (%eax),%eax
f0106b69:	84 c0                	test   %al,%al
f0106b6b:	74 10                	je     f0106b7d <strncmp+0x3f>
f0106b6d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106b70:	0f b6 10             	movzbl (%eax),%edx
f0106b73:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106b76:	0f b6 00             	movzbl (%eax),%eax
f0106b79:	38 c2                	cmp    %al,%dl
f0106b7b:	74 d4                	je     f0106b51 <strncmp+0x13>
	if (n == 0)
f0106b7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0106b81:	75 07                	jne    f0106b8a <strncmp+0x4c>
		return 0;
f0106b83:	b8 00 00 00 00       	mov    $0x0,%eax
f0106b88:	eb 16                	jmp    f0106ba0 <strncmp+0x62>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106b8a:	8b 45 08             	mov    0x8(%ebp),%eax
f0106b8d:	0f b6 00             	movzbl (%eax),%eax
f0106b90:	0f b6 d0             	movzbl %al,%edx
f0106b93:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106b96:	0f b6 00             	movzbl (%eax),%eax
f0106b99:	0f b6 c0             	movzbl %al,%eax
f0106b9c:	29 c2                	sub    %eax,%edx
f0106b9e:	89 d0                	mov    %edx,%eax
}
f0106ba0:	5d                   	pop    %ebp
f0106ba1:	c3                   	ret    

f0106ba2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0106ba2:	f3 0f 1e fb          	endbr32 
f0106ba6:	55                   	push   %ebp
f0106ba7:	89 e5                	mov    %esp,%ebp
f0106ba9:	83 ec 04             	sub    $0x4,%esp
f0106bac:	e8 4e 9f ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106bb1:	05 03 ae 08 00       	add    $0x8ae03,%eax
f0106bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106bb9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
f0106bbc:	eb 14                	jmp    f0106bd2 <strchr+0x30>
		if (*s == c)
f0106bbe:	8b 45 08             	mov    0x8(%ebp),%eax
f0106bc1:	0f b6 00             	movzbl (%eax),%eax
f0106bc4:	38 45 fc             	cmp    %al,-0x4(%ebp)
f0106bc7:	75 05                	jne    f0106bce <strchr+0x2c>
			return (char *) s;
f0106bc9:	8b 45 08             	mov    0x8(%ebp),%eax
f0106bcc:	eb 13                	jmp    f0106be1 <strchr+0x3f>
	for (; *s; s++)
f0106bce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0106bd2:	8b 45 08             	mov    0x8(%ebp),%eax
f0106bd5:	0f b6 00             	movzbl (%eax),%eax
f0106bd8:	84 c0                	test   %al,%al
f0106bda:	75 e2                	jne    f0106bbe <strchr+0x1c>
	return 0;
f0106bdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106be1:	c9                   	leave  
f0106be2:	c3                   	ret    

f0106be3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0106be3:	f3 0f 1e fb          	endbr32 
f0106be7:	55                   	push   %ebp
f0106be8:	89 e5                	mov    %esp,%ebp
f0106bea:	83 ec 04             	sub    $0x4,%esp
f0106bed:	e8 0d 9f ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106bf2:	05 c2 ad 08 00       	add    $0x8adc2,%eax
f0106bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106bfa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
f0106bfd:	eb 0f                	jmp    f0106c0e <strfind+0x2b>
		if (*s == c)
f0106bff:	8b 45 08             	mov    0x8(%ebp),%eax
f0106c02:	0f b6 00             	movzbl (%eax),%eax
f0106c05:	38 45 fc             	cmp    %al,-0x4(%ebp)
f0106c08:	74 10                	je     f0106c1a <strfind+0x37>
	for (; *s; s++)
f0106c0a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0106c0e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106c11:	0f b6 00             	movzbl (%eax),%eax
f0106c14:	84 c0                	test   %al,%al
f0106c16:	75 e7                	jne    f0106bff <strfind+0x1c>
f0106c18:	eb 01                	jmp    f0106c1b <strfind+0x38>
			break;
f0106c1a:	90                   	nop
	return (char *) s;
f0106c1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
f0106c1e:	c9                   	leave  
f0106c1f:	c3                   	ret    

f0106c20 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0106c20:	f3 0f 1e fb          	endbr32 
f0106c24:	55                   	push   %ebp
f0106c25:	89 e5                	mov    %esp,%ebp
f0106c27:	57                   	push   %edi
f0106c28:	e8 d2 9e ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106c2d:	05 87 ad 08 00       	add    $0x8ad87,%eax
	char *p;

	if (n == 0)
f0106c32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0106c36:	75 05                	jne    f0106c3d <memset+0x1d>
		return v;
f0106c38:	8b 45 08             	mov    0x8(%ebp),%eax
f0106c3b:	eb 5c                	jmp    f0106c99 <memset+0x79>
	if ((int)v%4 == 0 && n%4 == 0) {
f0106c3d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106c40:	83 e0 03             	and    $0x3,%eax
f0106c43:	85 c0                	test   %eax,%eax
f0106c45:	75 41                	jne    f0106c88 <memset+0x68>
f0106c47:	8b 45 10             	mov    0x10(%ebp),%eax
f0106c4a:	83 e0 03             	and    $0x3,%eax
f0106c4d:	85 c0                	test   %eax,%eax
f0106c4f:	75 37                	jne    f0106c88 <memset+0x68>
		c &= 0xFF;
f0106c51:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0106c58:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106c5b:	c1 e0 18             	shl    $0x18,%eax
f0106c5e:	89 c2                	mov    %eax,%edx
f0106c60:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106c63:	c1 e0 10             	shl    $0x10,%eax
f0106c66:	09 c2                	or     %eax,%edx
f0106c68:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106c6b:	c1 e0 08             	shl    $0x8,%eax
f0106c6e:	09 d0                	or     %edx,%eax
f0106c70:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0106c73:	8b 45 10             	mov    0x10(%ebp),%eax
f0106c76:	c1 e8 02             	shr    $0x2,%eax
f0106c79:	89 c1                	mov    %eax,%ecx
		asm volatile("cld; rep stosl\n"
f0106c7b:	8b 55 08             	mov    0x8(%ebp),%edx
f0106c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106c81:	89 d7                	mov    %edx,%edi
f0106c83:	fc                   	cld    
f0106c84:	f3 ab                	rep stos %eax,%es:(%edi)
f0106c86:	eb 0e                	jmp    f0106c96 <memset+0x76>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0106c88:	8b 55 08             	mov    0x8(%ebp),%edx
f0106c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106c8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0106c91:	89 d7                	mov    %edx,%edi
f0106c93:	fc                   	cld    
f0106c94:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
f0106c96:	8b 45 08             	mov    0x8(%ebp),%eax
}
f0106c99:	5f                   	pop    %edi
f0106c9a:	5d                   	pop    %ebp
f0106c9b:	c3                   	ret    

f0106c9c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0106c9c:	f3 0f 1e fb          	endbr32 
f0106ca0:	55                   	push   %ebp
f0106ca1:	89 e5                	mov    %esp,%ebp
f0106ca3:	57                   	push   %edi
f0106ca4:	56                   	push   %esi
f0106ca5:	53                   	push   %ebx
f0106ca6:	83 ec 10             	sub    $0x10,%esp
f0106ca9:	e8 51 9e ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106cae:	05 06 ad 08 00       	add    $0x8ad06,%eax
	const char *s;
	char *d;

	s = src;
f0106cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	d = dst;
f0106cb9:	8b 45 08             	mov    0x8(%ebp),%eax
f0106cbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (s < d && s + n > d) {
f0106cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0106cc2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
f0106cc5:	73 6d                	jae    f0106d34 <memmove+0x98>
f0106cc7:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0106cca:	8b 45 10             	mov    0x10(%ebp),%eax
f0106ccd:	01 d0                	add    %edx,%eax
f0106ccf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
f0106cd2:	73 60                	jae    f0106d34 <memmove+0x98>
		s += n;
f0106cd4:	8b 45 10             	mov    0x10(%ebp),%eax
f0106cd7:	01 45 f0             	add    %eax,-0x10(%ebp)
		d += n;
f0106cda:	8b 45 10             	mov    0x10(%ebp),%eax
f0106cdd:	01 45 ec             	add    %eax,-0x14(%ebp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0106ce3:	83 e0 03             	and    $0x3,%eax
f0106ce6:	85 c0                	test   %eax,%eax
f0106ce8:	75 2f                	jne    f0106d19 <memmove+0x7d>
f0106cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106ced:	83 e0 03             	and    $0x3,%eax
f0106cf0:	85 c0                	test   %eax,%eax
f0106cf2:	75 25                	jne    f0106d19 <memmove+0x7d>
f0106cf4:	8b 45 10             	mov    0x10(%ebp),%eax
f0106cf7:	83 e0 03             	and    $0x3,%eax
f0106cfa:	85 c0                	test   %eax,%eax
f0106cfc:	75 1b                	jne    f0106d19 <memmove+0x7d>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106d01:	83 e8 04             	sub    $0x4,%eax
f0106d04:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0106d07:	83 ea 04             	sub    $0x4,%edx
f0106d0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0106d0d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0106d10:	89 c7                	mov    %eax,%edi
f0106d12:	89 d6                	mov    %edx,%esi
f0106d14:	fd                   	std    
f0106d15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106d17:	eb 18                	jmp    f0106d31 <memmove+0x95>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0106d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106d1c:	8d 50 ff             	lea    -0x1(%eax),%edx
f0106d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0106d22:	8d 58 ff             	lea    -0x1(%eax),%ebx
			asm volatile("std; rep movsb\n"
f0106d25:	8b 45 10             	mov    0x10(%ebp),%eax
f0106d28:	89 d7                	mov    %edx,%edi
f0106d2a:	89 de                	mov    %ebx,%esi
f0106d2c:	89 c1                	mov    %eax,%ecx
f0106d2e:	fd                   	std    
f0106d2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0106d31:	fc                   	cld    
f0106d32:	eb 45                	jmp    f0106d79 <memmove+0xdd>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0106d37:	83 e0 03             	and    $0x3,%eax
f0106d3a:	85 c0                	test   %eax,%eax
f0106d3c:	75 2b                	jne    f0106d69 <memmove+0xcd>
f0106d3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106d41:	83 e0 03             	and    $0x3,%eax
f0106d44:	85 c0                	test   %eax,%eax
f0106d46:	75 21                	jne    f0106d69 <memmove+0xcd>
f0106d48:	8b 45 10             	mov    0x10(%ebp),%eax
f0106d4b:	83 e0 03             	and    $0x3,%eax
f0106d4e:	85 c0                	test   %eax,%eax
f0106d50:	75 17                	jne    f0106d69 <memmove+0xcd>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0106d52:	8b 45 10             	mov    0x10(%ebp),%eax
f0106d55:	c1 e8 02             	shr    $0x2,%eax
f0106d58:	89 c1                	mov    %eax,%ecx
			asm volatile("cld; rep movsl\n"
f0106d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106d5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0106d60:	89 c7                	mov    %eax,%edi
f0106d62:	89 d6                	mov    %edx,%esi
f0106d64:	fc                   	cld    
f0106d65:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106d67:	eb 10                	jmp    f0106d79 <memmove+0xdd>
		else
			asm volatile("cld; rep movsb\n"
f0106d69:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106d6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0106d6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0106d72:	89 c7                	mov    %eax,%edi
f0106d74:	89 d6                	mov    %edx,%esi
f0106d76:	fc                   	cld    
f0106d77:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
f0106d79:	8b 45 08             	mov    0x8(%ebp),%eax
}
f0106d7c:	83 c4 10             	add    $0x10,%esp
f0106d7f:	5b                   	pop    %ebx
f0106d80:	5e                   	pop    %esi
f0106d81:	5f                   	pop    %edi
f0106d82:	5d                   	pop    %ebp
f0106d83:	c3                   	ret    

f0106d84 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0106d84:	f3 0f 1e fb          	endbr32 
f0106d88:	55                   	push   %ebp
f0106d89:	89 e5                	mov    %esp,%ebp
f0106d8b:	e8 6f 9d ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106d90:	05 24 ac 08 00       	add    $0x8ac24,%eax
	return memmove(dst, src, n);
f0106d95:	ff 75 10             	pushl  0x10(%ebp)
f0106d98:	ff 75 0c             	pushl  0xc(%ebp)
f0106d9b:	ff 75 08             	pushl  0x8(%ebp)
f0106d9e:	e8 f9 fe ff ff       	call   f0106c9c <memmove>
f0106da3:	83 c4 0c             	add    $0xc,%esp
}
f0106da6:	c9                   	leave  
f0106da7:	c3                   	ret    

f0106da8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0106da8:	f3 0f 1e fb          	endbr32 
f0106dac:	55                   	push   %ebp
f0106dad:	89 e5                	mov    %esp,%ebp
f0106daf:	83 ec 10             	sub    $0x10,%esp
f0106db2:	e8 48 9d ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106db7:	05 fd ab 08 00       	add    $0x8abfd,%eax
	const uint8_t *s1 = (const uint8_t *) v1;
f0106dbc:	8b 45 08             	mov    0x8(%ebp),%eax
f0106dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8_t *s2 = (const uint8_t *) v2;
f0106dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106dc5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
f0106dc8:	eb 30                	jmp    f0106dfa <memcmp+0x52>
		if (*s1 != *s2)
f0106dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
f0106dcd:	0f b6 10             	movzbl (%eax),%edx
f0106dd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0106dd3:	0f b6 00             	movzbl (%eax),%eax
f0106dd6:	38 c2                	cmp    %al,%dl
f0106dd8:	74 18                	je     f0106df2 <memcmp+0x4a>
			return (int) *s1 - (int) *s2;
f0106dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
f0106ddd:	0f b6 00             	movzbl (%eax),%eax
f0106de0:	0f b6 d0             	movzbl %al,%edx
f0106de3:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0106de6:	0f b6 00             	movzbl (%eax),%eax
f0106de9:	0f b6 c0             	movzbl %al,%eax
f0106dec:	29 c2                	sub    %eax,%edx
f0106dee:	89 d0                	mov    %edx,%eax
f0106df0:	eb 1a                	jmp    f0106e0c <memcmp+0x64>
		s1++, s2++;
f0106df2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
f0106df6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
	while (n-- > 0) {
f0106dfa:	8b 45 10             	mov    0x10(%ebp),%eax
f0106dfd:	8d 50 ff             	lea    -0x1(%eax),%edx
f0106e00:	89 55 10             	mov    %edx,0x10(%ebp)
f0106e03:	85 c0                	test   %eax,%eax
f0106e05:	75 c3                	jne    f0106dca <memcmp+0x22>
	}

	return 0;
f0106e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106e0c:	c9                   	leave  
f0106e0d:	c3                   	ret    

f0106e0e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0106e0e:	f3 0f 1e fb          	endbr32 
f0106e12:	55                   	push   %ebp
f0106e13:	89 e5                	mov    %esp,%ebp
f0106e15:	83 ec 10             	sub    $0x10,%esp
f0106e18:	e8 e2 9c ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106e1d:	05 97 ab 08 00       	add    $0x8ab97,%eax
	const void *ends = (const char *) s + n;
f0106e22:	8b 55 08             	mov    0x8(%ebp),%edx
f0106e25:	8b 45 10             	mov    0x10(%ebp),%eax
f0106e28:	01 d0                	add    %edx,%eax
f0106e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
f0106e2d:	eb 11                	jmp    f0106e40 <memfind+0x32>
		if (*(const unsigned char *) s == (unsigned char) c)
f0106e2f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e32:	0f b6 00             	movzbl (%eax),%eax
f0106e35:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106e38:	38 d0                	cmp    %dl,%al
f0106e3a:	74 0e                	je     f0106e4a <memfind+0x3c>
	for (; s < ends; s++)
f0106e3c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0106e40:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e43:	3b 45 fc             	cmp    -0x4(%ebp),%eax
f0106e46:	72 e7                	jb     f0106e2f <memfind+0x21>
f0106e48:	eb 01                	jmp    f0106e4b <memfind+0x3d>
			break;
f0106e4a:	90                   	nop
	return (void *) s;
f0106e4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
f0106e4e:	c9                   	leave  
f0106e4f:	c3                   	ret    

f0106e50 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0106e50:	f3 0f 1e fb          	endbr32 
f0106e54:	55                   	push   %ebp
f0106e55:	89 e5                	mov    %esp,%ebp
f0106e57:	83 ec 10             	sub    $0x10,%esp
f0106e5a:	e8 a0 9c ff ff       	call   f0100aff <__x86.get_pc_thunk.ax>
f0106e5f:	05 55 ab 08 00       	add    $0x8ab55,%eax
	int neg = 0;
f0106e64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
f0106e6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0106e72:	eb 04                	jmp    f0106e78 <strtol+0x28>
		s++;
f0106e74:	83 45 08 01          	addl   $0x1,0x8(%ebp)
	while (*s == ' ' || *s == '\t')
f0106e78:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e7b:	0f b6 00             	movzbl (%eax),%eax
f0106e7e:	3c 20                	cmp    $0x20,%al
f0106e80:	74 f2                	je     f0106e74 <strtol+0x24>
f0106e82:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e85:	0f b6 00             	movzbl (%eax),%eax
f0106e88:	3c 09                	cmp    $0x9,%al
f0106e8a:	74 e8                	je     f0106e74 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
f0106e8c:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e8f:	0f b6 00             	movzbl (%eax),%eax
f0106e92:	3c 2b                	cmp    $0x2b,%al
f0106e94:	75 06                	jne    f0106e9c <strtol+0x4c>
		s++;
f0106e96:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0106e9a:	eb 15                	jmp    f0106eb1 <strtol+0x61>
	else if (*s == '-')
f0106e9c:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e9f:	0f b6 00             	movzbl (%eax),%eax
f0106ea2:	3c 2d                	cmp    $0x2d,%al
f0106ea4:	75 0b                	jne    f0106eb1 <strtol+0x61>
		s++, neg = 1;
f0106ea6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0106eaa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106eb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0106eb5:	74 06                	je     f0106ebd <strtol+0x6d>
f0106eb7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
f0106ebb:	75 24                	jne    f0106ee1 <strtol+0x91>
f0106ebd:	8b 45 08             	mov    0x8(%ebp),%eax
f0106ec0:	0f b6 00             	movzbl (%eax),%eax
f0106ec3:	3c 30                	cmp    $0x30,%al
f0106ec5:	75 1a                	jne    f0106ee1 <strtol+0x91>
f0106ec7:	8b 45 08             	mov    0x8(%ebp),%eax
f0106eca:	83 c0 01             	add    $0x1,%eax
f0106ecd:	0f b6 00             	movzbl (%eax),%eax
f0106ed0:	3c 78                	cmp    $0x78,%al
f0106ed2:	75 0d                	jne    f0106ee1 <strtol+0x91>
		s += 2, base = 16;
f0106ed4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
f0106ed8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
f0106edf:	eb 2a                	jmp    f0106f0b <strtol+0xbb>
	else if (base == 0 && s[0] == '0')
f0106ee1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0106ee5:	75 17                	jne    f0106efe <strtol+0xae>
f0106ee7:	8b 45 08             	mov    0x8(%ebp),%eax
f0106eea:	0f b6 00             	movzbl (%eax),%eax
f0106eed:	3c 30                	cmp    $0x30,%al
f0106eef:	75 0d                	jne    f0106efe <strtol+0xae>
		s++, base = 8;
f0106ef1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0106ef5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
f0106efc:	eb 0d                	jmp    f0106f0b <strtol+0xbb>
	else if (base == 0)
f0106efe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0106f02:	75 07                	jne    f0106f0b <strtol+0xbb>
		base = 10;
f0106f04:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0106f0b:	8b 45 08             	mov    0x8(%ebp),%eax
f0106f0e:	0f b6 00             	movzbl (%eax),%eax
f0106f11:	3c 2f                	cmp    $0x2f,%al
f0106f13:	7e 1b                	jle    f0106f30 <strtol+0xe0>
f0106f15:	8b 45 08             	mov    0x8(%ebp),%eax
f0106f18:	0f b6 00             	movzbl (%eax),%eax
f0106f1b:	3c 39                	cmp    $0x39,%al
f0106f1d:	7f 11                	jg     f0106f30 <strtol+0xe0>
			dig = *s - '0';
f0106f1f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106f22:	0f b6 00             	movzbl (%eax),%eax
f0106f25:	0f be c0             	movsbl %al,%eax
f0106f28:	83 e8 30             	sub    $0x30,%eax
f0106f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0106f2e:	eb 48                	jmp    f0106f78 <strtol+0x128>
		else if (*s >= 'a' && *s <= 'z')
f0106f30:	8b 45 08             	mov    0x8(%ebp),%eax
f0106f33:	0f b6 00             	movzbl (%eax),%eax
f0106f36:	3c 60                	cmp    $0x60,%al
f0106f38:	7e 1b                	jle    f0106f55 <strtol+0x105>
f0106f3a:	8b 45 08             	mov    0x8(%ebp),%eax
f0106f3d:	0f b6 00             	movzbl (%eax),%eax
f0106f40:	3c 7a                	cmp    $0x7a,%al
f0106f42:	7f 11                	jg     f0106f55 <strtol+0x105>
			dig = *s - 'a' + 10;
f0106f44:	8b 45 08             	mov    0x8(%ebp),%eax
f0106f47:	0f b6 00             	movzbl (%eax),%eax
f0106f4a:	0f be c0             	movsbl %al,%eax
f0106f4d:	83 e8 57             	sub    $0x57,%eax
f0106f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0106f53:	eb 23                	jmp    f0106f78 <strtol+0x128>
		else if (*s >= 'A' && *s <= 'Z')
f0106f55:	8b 45 08             	mov    0x8(%ebp),%eax
f0106f58:	0f b6 00             	movzbl (%eax),%eax
f0106f5b:	3c 40                	cmp    $0x40,%al
f0106f5d:	7e 3c                	jle    f0106f9b <strtol+0x14b>
f0106f5f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106f62:	0f b6 00             	movzbl (%eax),%eax
f0106f65:	3c 5a                	cmp    $0x5a,%al
f0106f67:	7f 32                	jg     f0106f9b <strtol+0x14b>
			dig = *s - 'A' + 10;
f0106f69:	8b 45 08             	mov    0x8(%ebp),%eax
f0106f6c:	0f b6 00             	movzbl (%eax),%eax
f0106f6f:	0f be c0             	movsbl %al,%eax
f0106f72:	83 e8 37             	sub    $0x37,%eax
f0106f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
f0106f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106f7b:	3b 45 10             	cmp    0x10(%ebp),%eax
f0106f7e:	7d 1a                	jge    f0106f9a <strtol+0x14a>
			break;
		s++, val = (val * base) + dig;
f0106f80:	83 45 08 01          	addl   $0x1,0x8(%ebp)
f0106f84:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0106f87:	0f af 45 10          	imul   0x10(%ebp),%eax
f0106f8b:	89 c2                	mov    %eax,%edx
f0106f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106f90:	01 d0                	add    %edx,%eax
f0106f92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (1) {
f0106f95:	e9 71 ff ff ff       	jmp    f0106f0b <strtol+0xbb>
			break;
f0106f9a:	90                   	nop
		// we don't properly detect overflow!
	}

	if (endptr)
f0106f9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106f9f:	74 08                	je     f0106fa9 <strtol+0x159>
		*endptr = (char *) s;
f0106fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106fa4:	8b 55 08             	mov    0x8(%ebp),%edx
f0106fa7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
f0106fa9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
f0106fad:	74 07                	je     f0106fb6 <strtol+0x166>
f0106faf:	8b 45 f8             	mov    -0x8(%ebp),%eax
f0106fb2:	f7 d8                	neg    %eax
f0106fb4:	eb 03                	jmp    f0106fb9 <strtol+0x169>
f0106fb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
f0106fb9:	c9                   	leave  
f0106fba:	c3                   	ret    
f0106fbb:	66 90                	xchg   %ax,%ax
f0106fbd:	66 90                	xchg   %ax,%ax
f0106fbf:	90                   	nop

f0106fc0 <__udivdi3>:
f0106fc0:	f3 0f 1e fb          	endbr32 
f0106fc4:	55                   	push   %ebp
f0106fc5:	57                   	push   %edi
f0106fc6:	56                   	push   %esi
f0106fc7:	53                   	push   %ebx
f0106fc8:	83 ec 1c             	sub    $0x1c,%esp
f0106fcb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0106fcf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0106fd3:	8b 74 24 34          	mov    0x34(%esp),%esi
f0106fd7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0106fdb:	85 d2                	test   %edx,%edx
f0106fdd:	75 19                	jne    f0106ff8 <__udivdi3+0x38>
f0106fdf:	39 f3                	cmp    %esi,%ebx
f0106fe1:	76 4d                	jbe    f0107030 <__udivdi3+0x70>
f0106fe3:	31 ff                	xor    %edi,%edi
f0106fe5:	89 e8                	mov    %ebp,%eax
f0106fe7:	89 f2                	mov    %esi,%edx
f0106fe9:	f7 f3                	div    %ebx
f0106feb:	89 fa                	mov    %edi,%edx
f0106fed:	83 c4 1c             	add    $0x1c,%esp
f0106ff0:	5b                   	pop    %ebx
f0106ff1:	5e                   	pop    %esi
f0106ff2:	5f                   	pop    %edi
f0106ff3:	5d                   	pop    %ebp
f0106ff4:	c3                   	ret    
f0106ff5:	8d 76 00             	lea    0x0(%esi),%esi
f0106ff8:	39 f2                	cmp    %esi,%edx
f0106ffa:	76 14                	jbe    f0107010 <__udivdi3+0x50>
f0106ffc:	31 ff                	xor    %edi,%edi
f0106ffe:	31 c0                	xor    %eax,%eax
f0107000:	89 fa                	mov    %edi,%edx
f0107002:	83 c4 1c             	add    $0x1c,%esp
f0107005:	5b                   	pop    %ebx
f0107006:	5e                   	pop    %esi
f0107007:	5f                   	pop    %edi
f0107008:	5d                   	pop    %ebp
f0107009:	c3                   	ret    
f010700a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107010:	0f bd fa             	bsr    %edx,%edi
f0107013:	83 f7 1f             	xor    $0x1f,%edi
f0107016:	75 48                	jne    f0107060 <__udivdi3+0xa0>
f0107018:	39 f2                	cmp    %esi,%edx
f010701a:	72 06                	jb     f0107022 <__udivdi3+0x62>
f010701c:	31 c0                	xor    %eax,%eax
f010701e:	39 eb                	cmp    %ebp,%ebx
f0107020:	77 de                	ja     f0107000 <__udivdi3+0x40>
f0107022:	b8 01 00 00 00       	mov    $0x1,%eax
f0107027:	eb d7                	jmp    f0107000 <__udivdi3+0x40>
f0107029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107030:	89 d9                	mov    %ebx,%ecx
f0107032:	85 db                	test   %ebx,%ebx
f0107034:	75 0b                	jne    f0107041 <__udivdi3+0x81>
f0107036:	b8 01 00 00 00       	mov    $0x1,%eax
f010703b:	31 d2                	xor    %edx,%edx
f010703d:	f7 f3                	div    %ebx
f010703f:	89 c1                	mov    %eax,%ecx
f0107041:	31 d2                	xor    %edx,%edx
f0107043:	89 f0                	mov    %esi,%eax
f0107045:	f7 f1                	div    %ecx
f0107047:	89 c6                	mov    %eax,%esi
f0107049:	89 e8                	mov    %ebp,%eax
f010704b:	89 f7                	mov    %esi,%edi
f010704d:	f7 f1                	div    %ecx
f010704f:	89 fa                	mov    %edi,%edx
f0107051:	83 c4 1c             	add    $0x1c,%esp
f0107054:	5b                   	pop    %ebx
f0107055:	5e                   	pop    %esi
f0107056:	5f                   	pop    %edi
f0107057:	5d                   	pop    %ebp
f0107058:	c3                   	ret    
f0107059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107060:	89 f9                	mov    %edi,%ecx
f0107062:	b8 20 00 00 00       	mov    $0x20,%eax
f0107067:	29 f8                	sub    %edi,%eax
f0107069:	d3 e2                	shl    %cl,%edx
f010706b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010706f:	89 c1                	mov    %eax,%ecx
f0107071:	89 da                	mov    %ebx,%edx
f0107073:	d3 ea                	shr    %cl,%edx
f0107075:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107079:	09 d1                	or     %edx,%ecx
f010707b:	89 f2                	mov    %esi,%edx
f010707d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107081:	89 f9                	mov    %edi,%ecx
f0107083:	d3 e3                	shl    %cl,%ebx
f0107085:	89 c1                	mov    %eax,%ecx
f0107087:	d3 ea                	shr    %cl,%edx
f0107089:	89 f9                	mov    %edi,%ecx
f010708b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010708f:	89 eb                	mov    %ebp,%ebx
f0107091:	d3 e6                	shl    %cl,%esi
f0107093:	89 c1                	mov    %eax,%ecx
f0107095:	d3 eb                	shr    %cl,%ebx
f0107097:	09 de                	or     %ebx,%esi
f0107099:	89 f0                	mov    %esi,%eax
f010709b:	f7 74 24 08          	divl   0x8(%esp)
f010709f:	89 d6                	mov    %edx,%esi
f01070a1:	89 c3                	mov    %eax,%ebx
f01070a3:	f7 64 24 0c          	mull   0xc(%esp)
f01070a7:	39 d6                	cmp    %edx,%esi
f01070a9:	72 15                	jb     f01070c0 <__udivdi3+0x100>
f01070ab:	89 f9                	mov    %edi,%ecx
f01070ad:	d3 e5                	shl    %cl,%ebp
f01070af:	39 c5                	cmp    %eax,%ebp
f01070b1:	73 04                	jae    f01070b7 <__udivdi3+0xf7>
f01070b3:	39 d6                	cmp    %edx,%esi
f01070b5:	74 09                	je     f01070c0 <__udivdi3+0x100>
f01070b7:	89 d8                	mov    %ebx,%eax
f01070b9:	31 ff                	xor    %edi,%edi
f01070bb:	e9 40 ff ff ff       	jmp    f0107000 <__udivdi3+0x40>
f01070c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01070c3:	31 ff                	xor    %edi,%edi
f01070c5:	e9 36 ff ff ff       	jmp    f0107000 <__udivdi3+0x40>
f01070ca:	66 90                	xchg   %ax,%ax
f01070cc:	66 90                	xchg   %ax,%ax
f01070ce:	66 90                	xchg   %ax,%ax

f01070d0 <__umoddi3>:
f01070d0:	f3 0f 1e fb          	endbr32 
f01070d4:	55                   	push   %ebp
f01070d5:	57                   	push   %edi
f01070d6:	56                   	push   %esi
f01070d7:	53                   	push   %ebx
f01070d8:	83 ec 1c             	sub    $0x1c,%esp
f01070db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01070df:	8b 74 24 30          	mov    0x30(%esp),%esi
f01070e3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01070e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01070eb:	85 c0                	test   %eax,%eax
f01070ed:	75 19                	jne    f0107108 <__umoddi3+0x38>
f01070ef:	39 df                	cmp    %ebx,%edi
f01070f1:	76 5d                	jbe    f0107150 <__umoddi3+0x80>
f01070f3:	89 f0                	mov    %esi,%eax
f01070f5:	89 da                	mov    %ebx,%edx
f01070f7:	f7 f7                	div    %edi
f01070f9:	89 d0                	mov    %edx,%eax
f01070fb:	31 d2                	xor    %edx,%edx
f01070fd:	83 c4 1c             	add    $0x1c,%esp
f0107100:	5b                   	pop    %ebx
f0107101:	5e                   	pop    %esi
f0107102:	5f                   	pop    %edi
f0107103:	5d                   	pop    %ebp
f0107104:	c3                   	ret    
f0107105:	8d 76 00             	lea    0x0(%esi),%esi
f0107108:	89 f2                	mov    %esi,%edx
f010710a:	39 d8                	cmp    %ebx,%eax
f010710c:	76 12                	jbe    f0107120 <__umoddi3+0x50>
f010710e:	89 f0                	mov    %esi,%eax
f0107110:	89 da                	mov    %ebx,%edx
f0107112:	83 c4 1c             	add    $0x1c,%esp
f0107115:	5b                   	pop    %ebx
f0107116:	5e                   	pop    %esi
f0107117:	5f                   	pop    %edi
f0107118:	5d                   	pop    %ebp
f0107119:	c3                   	ret    
f010711a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107120:	0f bd e8             	bsr    %eax,%ebp
f0107123:	83 f5 1f             	xor    $0x1f,%ebp
f0107126:	75 50                	jne    f0107178 <__umoddi3+0xa8>
f0107128:	39 d8                	cmp    %ebx,%eax
f010712a:	0f 82 e0 00 00 00    	jb     f0107210 <__umoddi3+0x140>
f0107130:	89 d9                	mov    %ebx,%ecx
f0107132:	39 f7                	cmp    %esi,%edi
f0107134:	0f 86 d6 00 00 00    	jbe    f0107210 <__umoddi3+0x140>
f010713a:	89 d0                	mov    %edx,%eax
f010713c:	89 ca                	mov    %ecx,%edx
f010713e:	83 c4 1c             	add    $0x1c,%esp
f0107141:	5b                   	pop    %ebx
f0107142:	5e                   	pop    %esi
f0107143:	5f                   	pop    %edi
f0107144:	5d                   	pop    %ebp
f0107145:	c3                   	ret    
f0107146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010714d:	8d 76 00             	lea    0x0(%esi),%esi
f0107150:	89 fd                	mov    %edi,%ebp
f0107152:	85 ff                	test   %edi,%edi
f0107154:	75 0b                	jne    f0107161 <__umoddi3+0x91>
f0107156:	b8 01 00 00 00       	mov    $0x1,%eax
f010715b:	31 d2                	xor    %edx,%edx
f010715d:	f7 f7                	div    %edi
f010715f:	89 c5                	mov    %eax,%ebp
f0107161:	89 d8                	mov    %ebx,%eax
f0107163:	31 d2                	xor    %edx,%edx
f0107165:	f7 f5                	div    %ebp
f0107167:	89 f0                	mov    %esi,%eax
f0107169:	f7 f5                	div    %ebp
f010716b:	89 d0                	mov    %edx,%eax
f010716d:	31 d2                	xor    %edx,%edx
f010716f:	eb 8c                	jmp    f01070fd <__umoddi3+0x2d>
f0107171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107178:	89 e9                	mov    %ebp,%ecx
f010717a:	ba 20 00 00 00       	mov    $0x20,%edx
f010717f:	29 ea                	sub    %ebp,%edx
f0107181:	d3 e0                	shl    %cl,%eax
f0107183:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107187:	89 d1                	mov    %edx,%ecx
f0107189:	89 f8                	mov    %edi,%eax
f010718b:	d3 e8                	shr    %cl,%eax
f010718d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0107191:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107195:	8b 54 24 04          	mov    0x4(%esp),%edx
f0107199:	09 c1                	or     %eax,%ecx
f010719b:	89 d8                	mov    %ebx,%eax
f010719d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01071a1:	89 e9                	mov    %ebp,%ecx
f01071a3:	d3 e7                	shl    %cl,%edi
f01071a5:	89 d1                	mov    %edx,%ecx
f01071a7:	d3 e8                	shr    %cl,%eax
f01071a9:	89 e9                	mov    %ebp,%ecx
f01071ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01071af:	d3 e3                	shl    %cl,%ebx
f01071b1:	89 c7                	mov    %eax,%edi
f01071b3:	89 d1                	mov    %edx,%ecx
f01071b5:	89 f0                	mov    %esi,%eax
f01071b7:	d3 e8                	shr    %cl,%eax
f01071b9:	89 e9                	mov    %ebp,%ecx
f01071bb:	89 fa                	mov    %edi,%edx
f01071bd:	d3 e6                	shl    %cl,%esi
f01071bf:	09 d8                	or     %ebx,%eax
f01071c1:	f7 74 24 08          	divl   0x8(%esp)
f01071c5:	89 d1                	mov    %edx,%ecx
f01071c7:	89 f3                	mov    %esi,%ebx
f01071c9:	f7 64 24 0c          	mull   0xc(%esp)
f01071cd:	89 c6                	mov    %eax,%esi
f01071cf:	89 d7                	mov    %edx,%edi
f01071d1:	39 d1                	cmp    %edx,%ecx
f01071d3:	72 06                	jb     f01071db <__umoddi3+0x10b>
f01071d5:	75 10                	jne    f01071e7 <__umoddi3+0x117>
f01071d7:	39 c3                	cmp    %eax,%ebx
f01071d9:	73 0c                	jae    f01071e7 <__umoddi3+0x117>
f01071db:	2b 44 24 0c          	sub    0xc(%esp),%eax
f01071df:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01071e3:	89 d7                	mov    %edx,%edi
f01071e5:	89 c6                	mov    %eax,%esi
f01071e7:	89 ca                	mov    %ecx,%edx
f01071e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01071ee:	29 f3                	sub    %esi,%ebx
f01071f0:	19 fa                	sbb    %edi,%edx
f01071f2:	89 d0                	mov    %edx,%eax
f01071f4:	d3 e0                	shl    %cl,%eax
f01071f6:	89 e9                	mov    %ebp,%ecx
f01071f8:	d3 eb                	shr    %cl,%ebx
f01071fa:	d3 ea                	shr    %cl,%edx
f01071fc:	09 d8                	or     %ebx,%eax
f01071fe:	83 c4 1c             	add    $0x1c,%esp
f0107201:	5b                   	pop    %ebx
f0107202:	5e                   	pop    %esi
f0107203:	5f                   	pop    %edi
f0107204:	5d                   	pop    %ebp
f0107205:	c3                   	ret    
f0107206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010720d:	8d 76 00             	lea    0x0(%esi),%esi
f0107210:	29 fe                	sub    %edi,%esi
f0107212:	19 c3                	sbb    %eax,%ebx
f0107214:	89 f2                	mov    %esi,%edx
f0107216:	89 d9                	mov    %ebx,%ecx
f0107218:	e9 1d ff ff ff       	jmp    f010713a <__umoddi3+0x6a>
