# MIT6.828 Operating System Engineering



-  [MIT6.828: Fall 2018](https://pdos.csail.mit.edu/6.828/2018/schedule.html) 课程Homework与Labs内容

- 课程参考讲义(xv6)：[xv6-handbook](https://pdos.csail.mit.edu/6.828/2018/xv6/book-rev11.pdf)



### 环境搭建

- 实验环境：Windows10 WSL2 (Ubuntu 16.04)

- 工具链：[Tools Used in 6.828](https://pdos.csail.mit.edu/6.828/2018/tools.html)

  ​	环境搭建流程按照上述页面提示；可能会遇到一些问题，可能需执行：

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
  # '/home/fabrice/6.828/qemu/rules.mak:57: 
  # recipe for target 'qga/commands-posix.o' failed' 
  # Solution:
  # 	Add '#include<sys/sysmacros.h>' to qga/commands-posix.c
  
  # Error2:
  # '/home/fabrice/6.828/qemu/rules.mak:57: recipe for target 'block/blkdebug.o' failed'
  #Solution:
  #	Remove '-Werror' in config-host.mak
  
  # After all-ok, run these commands in ./lab:
  make && make qemu
  
  ###########################
  ```




### 进度

- **Lab**
  * [x] Lab1: Booting a PC
  * [x] Lab2: Memory Management
  * [ ] Lab3: User-Level Environments
  * [ ] Lab4: Preemptive Multitasking
  * [ ] Lab5: File system, spawn, and sh
  * [ ] *Lab6: Networking
  * [ ] *Lab7: Final project