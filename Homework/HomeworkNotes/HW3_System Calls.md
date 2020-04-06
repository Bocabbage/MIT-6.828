# Homework3: xv6 system calls

​		这个Homework的内容主要是借助xv6源码的内容先简单理解***system calls***的调用链以及构建一个system call并利用其构建内建命令的方法。Homework的内容分为两部分。



### Part One: System call tracing

​		这个任务是将系统初始化过程的系统调用及其返回值打印出来。任务的Hint提示得很清楚，只需修改 `syscall.c` 中的 `syscall()` 函数即可。观察可知这个函数是一个通用接口，通过 `kernel.asm` 可知其被 `trap()` 调用：

```assembly
void
trap(struct trapframe *tf)
{
  ...
80105094:	e8 47 f0 ff ff       	call   801040e0 <syscall>
    if(myproc()->killed)
80105099:	e8 12 e2 ff ff       	call   801032b0 <myproc>
8010509e:	8b 48 24             	mov    0x24(%eax),%ecx
801050a1:	85 c9                	test   %ecx,%ecx
801050a3:	0f 84 1d ff ff ff    	je     80104fc6 <trap+0x10e>
  ...
}
```

 并根据陷阱帧(*TrapFrame*)中记录的 `syscall id` 来调用具体的函数（通过函数指针数组实现）。因此，我们可以仿照它构建字符串数组，在调用前进行打印：

```c
static char* syscalls_name[] = {
[SYS_fork]    "fork",
...
[SYS_close]   "close",
};

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
    /* ----------------Code---------------- */
    cprintf("%s -> %d\n", syscalls_name[num], curproc->tf->eax);
    /* ----------------Code---------------- */
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
```

​	Challenge部分要求打印system calls的参数，可以注意到 `syscall.c` 文件中也包含 `argptr(), argint(), argstr()` 等函数用于打印参数，可利用这几个函数实现。



### Part Two: Date system call

​		这个任务是构建一个简单的 `date ` system call，用于显示当前时间。底层的实现需要与硬件交互，这部分被封装在 `lapic.c/cmostime()` 中，构建时直接调用填充 `rtcdate` 结构体即可；此外，还要构建一个User-level Program供使用者调用（类似于 `ls` 这样的Build-in Command）。

任务的提示是观察其他的system call（例如`uptime`）存在于哪些文件中并依此修改相应文件：

```c
grep -n uptime *.[chS]

// Output Result:
syscall.c:105:extern int sys_uptime(void);
syscall.c:121:[SYS_uptime]  sys_uptime,
syscall.h:15:#define SYS_uptime 14
sysproc.c:83:sys_uptime(void)
user.h:25:int uptime(void);
usys.S:31:SYSCALL(uptime)
```

实际上由于还要实现User-level Program，要修改的地方还要更多一些。

首先要做的是实现system call本身。根据在Part One中了解到的，我们在`syscall.c` 的函数指针数组中添加`SYS_date`，并在其对应的头文件 `syscall.h` 中指定这个调用的id；参考 `fork` 的实现位置，我们也在 `sysproc.c` 中实现一个`sys_date()` ：

```c
// In sysproc.c
int
sys_date(void)
{
  struct rtcdate *r;
  if (argptr(0, (char **) &r, sizeof(struct rtcdate)) < 0)
    return -1;
  return date(r);
}
```

这里没有直接实现，将真正的实现放在 `date()` 中，使其可以被User-Level Program重用：

```c
// In proc.c
int date(struct rtcdate* r)
{
  cmostime(r);
  return 0;
}
```

并在 `defs.h` 中声明该函数。

最后，根据提示修改 `Makefile` 以及 `usys.S` 即可。