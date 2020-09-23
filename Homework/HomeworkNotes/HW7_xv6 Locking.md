# Homework 7: xv6 locking 

​		本Homework的内容主要是对xv6的锁设计进行简单的探究。

### Don't do this

Homework的第一个内容要求用一句话解释下列代码段的运行结果：

```c
struct spinlock lk;
initlock(&lk, "test lock");
acquire(&lk);
acquire(&lk);
```

我们检查 `spinlock.c/acquire()` 可得：

```c
...
if(holding(lk))
    panic("acquire");
...
```

**因此上述代码段将引发panic并显示错误信息：”acquire“。**



### Interrupts in ide.c

在 *ide.c/idew()* 中尝试在持锁期间打开中断，观察最后产生的结果。

当触发panic时，打印 stack trace：

（尝试数次未触发，直接截取  https://github.com/batmanW1/6.828-1/blob/master/hw7/solution.md  结果）

```
proc.c:sched():313
proc.c:yield():329
trap.c:trap():130
trapasm.S:alltraps:23
...
...
```

`shed()` 被调用时假设当前状态下仅有一个锁处于持有状态，但引发异常时共有两个锁被持有：一个是 `yield()` 持有的 *ptable.lock* ，另一个是 `idew()` 持有的 *idelock* 。而 *cpu->ncli* 变量每当有锁被持有/释放时都递增，以供确认仅当没有锁被持有时才打开中断。结合上述两点，当进入 `shed()` 时， *cpu->ncli* 并不恰好为1，引发 panic 。



### Interrupts in file.c

在 *file.c/filealloc()* 中尝试持锁阶段打开中断，观察最后产生的结果。

结果是触发 panic概率极小。*file_table_lock* 保护文件描述符表的读写，推测不引发 panic 的原因是 `filealloc()` 运行时间极短，较难遭遇中断。



### xv6 lock implementation

问题：为什么 `release()` 要在释放锁之前置零 *lk->pcs[0]* 及 *lk->cpu* ？如果将这一步放到锁释放后会发生什么？

这两个变量分别描述当前锁的调用栈和持有当前锁的CPU，根据 xv6-book 的描述，属于 *invariant* 的范畴，需要保证其在被另外调用前更新完成。若在释放锁后修改，在修改前锁可能被其他线程抢占，无效的数据被误作有效数据读写，造出错误。

