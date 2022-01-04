# MIT6.828 Operating System Engineering



-  [MIT6.828: Fall 2018](https://pdos.csail.mit.edu/6.828/2018/schedule.html) 课程Homework与Labs内容
- 课程参考讲义(xv6)：[xv6-handbook](https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf)
-  其他参考内容：
   - [NJU Operating System](https://www.bilibili.com/video/BV1N741177F5)
   - [Operating System: Three Easy Pieces](http://pages.cs.wisc.edu/~remzi/OSTEP/)



### 环境搭建

- 实验环境：Windows10 WSL2 (Ubuntu 16.04 --> Ubuntu 20.04)

- 工具链：[Tools Used in 6.828](https://pdos.csail.mit.edu/6.828/2018/tools.html)

  环境搭建流程按照上述页面提示，分别需要安装：

  - Compile Toolchain [objdump, gcc, gdb, gcc-multilib]
  - Qemu (qemu-sys) [通过git链接安装]
  
  可能会遇到一些问题，需执行额外操作：
  
  ```shell
  # For test the tool-chain, you can run:
  gcc -m32 -print-libgcc-file-name # Ensure the env is ok
  # If output is like:
  # '/usr/lib/gcc/i486-linux-gnu/version/libgcc.a' or:
  # '/usr/lib/gcc/x86_64-linux-gnu/version/32/libgcc.a', that is ok
  # Otherwise, you need at least run one of the below commands:
  sudo apt-get install -y build-essential gdb
  sudo apt-get install gcc-multilib # for supporting 32-bits mode
  
  #### Install QEMU Bugs ####
  
  # lack packages:
  sudo apt-get install python # to support python2.7
  sudo apt-get install -y pkg-config
  sudo apt-get install zlib1g-dev
  sudo apt-get install libglib2.0-dev
  sudo apt-get install libpixman-1-dev
  
  # During Compiling:
  
  # Error1:
  # '/home/6.828/qemu/rules.mak:57: 
  # recipe for target 'qga/commands-posix.o' failed' 
  # Solution:
  # 	Add '#include<sys/sysmacros.h>' to qga/commands-posix.c
  
  # Error2:
  # '/home/6.828/qemu/rules.mak:57: recipe for target 'block/blkdebug.o' failed'
  #Solution:
  #	Remove '-Werror' in config-host.mak
  
  # After all-ok, run these commands in ./lab:
  make && make qemu
  
  ###########################
  ```



### 进度

注1：2021年12月重新实验，此处标记的进度为该次实验进度

注2：重新完成的实验内容根据 Lab 创建了不同分支，各实验内容详见各分支

- **Lab**
  * [x] Lab1: Booting a PC
  * [ ] Lab2: Memory Management
  * [ ] Lab3: User-Level Environments
  * [ ] Lab4: Preemptive Multitasking
  * [ ] Lab5: File system, spawn, and sh
  * [ ] *Lab6: Networking
  * [ ] *Lab7: Final project

- **Homework**
  * [x] HW1: Boot xv6
  * [ ] HW2: Shell
  * [ ] HW3: System Calls
  * [ ] HW4: Lazy Page Allocation
  * [ ] HW5: xv6 CPU alarm
  * [ ] HW6: Multithreaded Programming
  * [ ] HW7: xv6 Locks
  * [ ] HW8: Uthreads
  * [ ] HW9: Barrier
  * [ ] HW10: Big Files
  * [ ] HW11: Crash
  * [ ] HW12: Mmap
  * [ ] HW13: Exokernel Question
  * [ ] HW14: Biscuit Question
  * [ ] HW15: Ticket Lock Question
  * [ ] HW16: RCU Question
  * [ ] HW17: VM Question
  * [ ] HW18: Dune Question
  * [ ] HW19: IX Question

