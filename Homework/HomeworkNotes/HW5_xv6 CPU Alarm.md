# Homework 5: xv6 CPU alarm

​		这个Homework的内容是增加一个新的系统调用：**alarm**，提供定期提醒进程的功能。根据Homework描述，这一功能对compute-bound进程控制计算时间有帮助。增加系统调用的方法与Homework3基本相同，Homework提供测试例程 `alarmtest.c` 代码。



根据Homework3对系统调用的构成方法，修改/增加代码如下：

```c
/* user.h */
// Declare the user syscall interface function
int alarm(int ticks, void(*handler)());

/* usys.S */
// Define the user syscall, turn to sys_xxx function
SYSCALL(alarm)
// Be careful that the '\n' here is indispensable
// the SYSCALL is a macro defined in usys.S

/* syscall.h */
#define SYS_alarm 22

/* syscall.c */
// Declare the syscall function
extern int sys_alarm(void);
...
static int (*syscalls[])(void) = {
    ...
	[SYS_alarm]    sys_alarm,
}

/* sysproc.c */
// Define the syscall function
int
sys_alarm(void)
{
    int ticks;
    void (*handler)();

    if(argint(0, &ticks) < 0)
        return -1;
    if(argptr(1, (char**)&handler, 1) < 0)
        return -1;
    myproc()->alarmticks = ticks;
    myproc()->alarmhandler = handler;
    return 0;
}

/* trap.c */
// Define the actions when the cpu alarms the process
// According to the Homework page, these actions only work
// at calling alarm-syscall in user mode.
trap(struct trapframe *tf)
{
    ...
    switch(tf->trapno):
    	// IRQ: Interrupt ReQuest
        case T_IRQ0 + IRQ_TIMER:
        if(cpuid() == 0){
          acquire(&tickslock);
          ticks++;
          wakeup(&ticks);
          release(&tickslock);
        }

        /********* Hw5 *********/    	
        if(myproc() != 0 && (tf->cs & 3) == 3)
          myproc()->currentticks++;
        if(myproc() != 0 && (myproc()->currentticks == myproc()->alarmticks))
        {
          myproc()->currentticks = 0;
          tf->esp -= 4;
          *((uint*)tf->esp) = tf->eip;
          tf->eip = (uint)myproc()->alarmhandler;
          // the code above can't be replaced by:
          // myproc()->alarmhandler();
        }
		/**********************/
        lapiceoi();
        break;
    ...
}

/* proc.h */
// Per-process state
struct proc {
  ...
  /* Hw5 */
  int alarmticks;
  int currentticks;
  void (*alarmhandler)();
};

/* proc.c */
static struct proc*
allocproc(void) 
{
	...
found:
    p->state = EMBRYO;
    p->pid = nextpid++;
    /* Hw5 */
    p->alarmticks = -1;
    p->currentticks = 0;
    ...
}

/* Makefile */
UPROGS:
...
_alarmtest\
```

在上述代码中，有以下几点需要注意：

-  **对 alarm handler 的调用方式：** <u>handler是处于用户态的函数，因此不应在内核态直接调用执行</u>。这里采用的方法是修改当前陷入内核的用户进程的陷阱帧，将陷入内核前PC寄存器修改为handler地址，并将原先地址入栈，构造成handler被用户态进程调用的情景。需要注意的是，即使不考虑安全性问题，直接在内核中调用也未能在 qemu 控制台上打印出 alarm! 字样。<u>使用 GDB 调试后发现，实际上在内核中直接调用确实运行了handler代码，未能打印的原因可能与内核/用户态切换后 fd 发生变换有关。【待解决】</u> 
-  **currentticks的递增分支条件：** 根据 Homework 页面的提示，仅在用户态时钟中断时增加 ticks 的计数。

