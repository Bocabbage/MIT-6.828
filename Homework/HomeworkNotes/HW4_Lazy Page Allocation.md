# Homework4: lazy page allocation

​		这个Homework的内容是将分配内存改为**"lazy allocation"**：在调用 `sys_sbrk` 时暂时不分配内存，直到新的内存被使用时再通过trap--page fault处理调用。这种实现方法有助于减少内存分配的压力和不必要的浪费。



### Part One: Eliminate allocation from sbrk()

​		第一个任务是将xv6原来代码中的内存分配部分抹去。根据提示，这个内容是在 `syspro.c/sys_sbrk()` 中实现的（调用`groproc()`）；我们注释掉跟这个关键功能有关的两行代码，同时需要注意：手动增在当前进程的size（这一步原本是在 `groproc()` 中调用 `allocuvm()` 实现的）：

```c
int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  /* Hw4 */
  // if(growproc(n) < 0)
  //   return -1;
  myproc()->sz += n;
  /******/
  return addr;
}
```

​		修改后 `sys_sbrk()` 只修改了当前进程的空间使用记录但没有真正地分配空间，因此根据Homework中提示进行测试时，会发生**PAGE FAULT**，而当前OS没有处理这个问题的相应trap，自然会引发错误。

```
init: starting sh
$ echo hi
pid 3 sh: trap 14 err 6 on cpu 0 eip 0x12f1 addr 0x4004--kill proc
$ 
```



### Part Two: Lazy allocation

​		第二个任务是实现对PAGE FAULT的处理，根据提示，应当修改 `trap.c/trap()` 。此外，Homework页面也提供了另外几个提示：

```
Hint: look at the cprintf arguments to see how to find the virtual address that caused the page fault.

Hint: steal code from allocuvm() in vm.c, which is what sbrk() calls (via growproc()).

Hint: use PGROUNDDOWN(va) to round the faulting virtual address down to a page boundary.

Hint: break or return in order to avoid the cprintf and the myproc()->killed = 1.

Hint: you'll need to call mappages(). In order to do this you'll need to delete the static in the declaration of mappages() in vm.c, and you'll need to declare mappages() in trap.c. Add this declaration to trap.c before any call to mappages():
      int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);
      
Hint: you can check whether a fault is a page fault by checking if tf->trapno is equal to T_PGFLT in trap().
```

根据第一个提示，我们找到打印上述错误的位置，从而得知可以调用 `rcr2()` 来获取发生问题的VA；我们的工作是为该地址（准确的说是该地址所处的页）分配物理空间，而根据提示分配空间的任务是由 `allocuvm()` 实现的，我们的代码可以仿照它来写；分配完成后我们需要完成VA到PA的映射，可以调用 `mappages()` 来完成：该函数原本声明为 `static`，在外部调用需取消。

```c
...
// In user space, assume process misbehaved.
    /* Hw4 */
    if(tf->trapno == T_PGFLT)
    {
      char* mem;
      mem = kalloc();
      if(mem == 0)
      {
        cprintf("kalloc out of memory\n");
        myproc()->killed = 1;
        break;
      }
      memset(mem, 0, PGSIZE);
      mappages(myproc()->pgdir, (void *)PGROUNDDOWN(rcr2()), PGSIZE, V2P(mem), PTE_W|PTE_U);
      break;
    }
	/******/
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

...
```

