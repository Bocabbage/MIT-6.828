# Homework2: Shell

​		这个Homework的内容与CSAPP的[shell-lab]( https://github.com/Bocabbage/CSAPP-Lab-Trail/tree/master/shlab-handout )内容相近：完成一个简单的shell。因此接近的内容不再赘述。与CSAPP的Lab相比，完成内容上的主要区别是：

- 把后台运行的实现放到了提高部分，故基础部分不涉及 *Signal* 的内容
- 增加了 *pipe* 和 *I/O redirection* 的实现需求

代码的整体结构同样是分为Parsing和Executing两部分，下面只记录本次Homework比较特异的内容。



### I/O 重定向的实现

```c
case '>':
case '<':
rcmd = (struct redircmd*)cmd;
// Your code here ...
close(rcmd->fd);
if(open(rcmd->file, rcmd->flags, 0) < 0)
{
    fprintf(stderr, "open %s failed.\n", rcmd->file);
    _exit(-1);
}
runcmd(rcmd->cmd);
break;
```

​	重定向的实现逻辑是检测到重定向符号时，首先关闭`stdout`或`stdin`，然后再重新打开一个write/read file descriptor。这种写法是基于对OS管理文件描述符方式的假设。具体来说，Unix-like系统从0开始寻找可以使用的文件描述符，因此一旦关闭了标准流再打开，该进程下原本与标准流相关的输出/输入检测到相应的file descriptor关闭后自行检索，找到在此处打开的descriptor，并将输入/输出与之联系。

（注：进程拥有自己独立的*File Descriptor Table*，但文件的开关状态及offset是共享的，详见CSAPP Chapter 10）



### PIPE的实现

```c
case '|':
    pcmd = (struct pipecmd*)cmd;
    // Your code here ...
    if(pipe(p) < 0)
    {
      fprintf(stderr, "pipe: error.\n");
      _exit(-1);
    }
    
    if(fork1() == 0)
    {
      close(1); // redir the output to p[0]
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }

    if(fork1() == 0)
    {
      // the left command will exit during 'runcmd'
      // so only the father process can arrive here
      close(0); // redir the input to p[1]
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }

    close(p[0]);
    close(p[1]);
    // The wait() system call suspends execution of 
    // the calling process until one of its children terminates.
    wait(&r);
    wait(&r);
    break;
```

​	分别建立新的子进程处理管道两端的内容，并使用POSIX `pipe()` 将两个输入输出流关联。另外要注意的是， `pipe()` 处理I/O内容是并行的（也即管道前端与后端同时工作），因此**在写端进程需要关闭读端、在读端进程需要关闭写端**，保证数据流向正常。

​	另外，在课程的Lecture 4中讨论到了 `fork` 的作用并提出了问题：能不能不使用 `fork` 直接运行左右两端的命令？答案是不行，重新建立进程的目的是因为读端和写端对文件描述符的操作不同，需要独立开来，不重新建立进程不能采用相同的代码段；更重要的是，由于 `runcmd` 运行后并不返回，故在父线程直接运行后，后续代码段将无法返回执行。



### Challenge



#### ';' 的实现

​	`;` 运算符的实现与 `|` 的逻辑基本完全一致，分开运算符左右两端命令并分别运行。

```c
case ';':
    scmd = (struct semicmd*)cmd;
    if(fork1() == 0)
      runcmd(scmd->left);

    // Wait for the first task:
    // prevent from problems like output chaos
    wait(&r);

    if(fork1() == 0)
      runcmd(scmd->right);

    wait(&r);
    break;
```

