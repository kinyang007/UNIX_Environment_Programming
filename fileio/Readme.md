# 文件I/O
### 文件描述符
* 文件描述符0(`STDIN_FILENO`): 进程标准输入
* 文件描述符1(`STDOUT_FILENO`): 进程标准输出
* 文件描述符2(`STDERR_FILENO`): 进程标准错误
* 以上常量都在`<unistd.h>`中定义

### 函数open和openat
```cpp
#include <fcntl.h>
int open(const char *path, int oflag, ... /* mode_t mode */ );
int openat(int fd, const char *path, int oflag, ... /* mode_t mode */ );
/*
 *  返回值: 若成功，返回文件描述符；若出错，返回-1
 *  path: 要打开或创建文件的名字
 *  oflag: 用来说明此函数的多个选项，用下列一个或多个常量进行“或”运算构成oflag参数
 *    O_RDONLY  只读打开    
 *    O_WRONLY  只写打开    
 *    O_RDWR    读、写打开   
 *    O_EXEC    只执行打开
 *    O_SEARCH  只搜索打开（应用于目录）
 *    // 以上5个常量中必须指定一个且只能指定一个，下列常量则为可选（此处略）
 *  fd: 把open和openat函数区分开，共有以下3种可能：
 *    (1) path参数指定为绝对路径名，在此情况下，fd参数忽略，openat函数就相当于open函数
 *    (2) path参数指定为相对路径名，fd参数指出了相对路径名在文件系统中的开始地址。
 *        fd参数通过打开相对路径名所在的目录来获取。
 *    (3) path参数指定为相对路径名，fd参数具有特殊值AT_FDCWD。
 *       在此情况下，路径名在当前工作目录获取，openat函数操作上与open函数类似。
 */
```
* `openat`函数引进作用
  * 让线程可以使用相对路径名打开目录中的文件，而不再只能打开当前工作目录
  * 可以避免time-of-check-to-time-of-use(TOCTTOU)错误

### 函数creat
```cpp
#include <fcntl.h>
int creat(const char *path, mode_t mode);
/*
 *  返回值: 若成功，返回只写打开的文件描述符；若出错，返回-1
 *  此函数等效于open(path, O_WRONLY | O_CREAT | O_TRUNC, mode);
 */
```

### 函数close
```cpp
#include <unistd.h>
int close(int fd);
/*
 *  返回值: 若成功，返回0；若出错，返回-1
 */
```

### 函数lseek
* 当前文件偏移量(current file offset)
  * 通常是一个非负整数
  * 用于度量从文件开始处计算的字节数
  * 通常，读写操作都从当前文件偏移量处开始，并使偏移量增加所读写的字节数
  * 当打开一个文件时，除非指定`O_APPEND`选项，否则该偏移量被设置为0
```cpp
#include <unistd.h>
off_t lseek(int fd, off_t offset, int whence);
/*
 *  返回值：若成功，返回新的文件偏移量；若出错，返回-1
 *  对参数offset的解释与参数whence的值有关
 *  1. 若whence是SEEK_SET，则将该文件的偏移量设置为距文件开始处offset个字节
 *  2. 若whence是SEEK_CUR，则将该文件的偏移量为其当前值加offset，offset可为正负
 *  3. 若whence是SEEK_END，则将该文件的偏移量设置为文件长度加offset，offset可为正负
 */
```
* 若`lseek`成功执行，则返回新的文件偏移量，为此可以用下列方式确定打开文件的当前偏移量：
```cpp
off_t currpos;
currpos = lseek(fd, 0, SEEK_CUR);
/*
 *  这种方法也可用来确定所涉及的文件是否可以设置偏移量。
 *  如果文件描述符指向的是一个管道、FIFO或网络套接字，则lseek返回-1，并将errno设置为ESPIPE
 */
```
* 实例：[seek.cpp](https://github.com/kinyang007/UNIX_Environment_Programming/blob/master/fileio/seek.cpp)
* 比较`lseek`的返回值时应当谨慎，不要测试它是否小于0，而要测试它是否等于-1（某些文件的偏移量可能为负值）
* 文件偏移量可以大于文件的当前长度，在此情况下，对该文件下一次写将加长该文件，并在文件中构成一个空洞。位于文件中但没有写过的字节都被读为0
* 文件的空洞并不要求在磁盘上占用存储区。对于原文件尾端和新开始写位置之间的部分不需要分配磁盘快
* 实例：[hole.cpp](https://github.com/kinyang007/UNIX_Environment_Programming/blob/master/fileio/hole.cpp)

### 函数read
```cpp
#include <unistd.h>
ssize_t read(int fd, void *buf, size_t nbytes);
/*
 * 返回值：读到的字节数；若已到文件尾，返回0；若出错，返回-1
 */
```
* 有多种情况可使实际读到的字节数少于要求读的字节数：
  * 普通文件：在读到要求字节数之前已到达了文件尾端
  * 终端：通常一次最多读一行
  * 网络：网络中的缓冲机制可能造成返回值小于所要求读的字节数
  * 管道或FIFO：如若管道包含的字节少于所需的数量，那么read将只返回实际可用的字节数
  * 某些面向记录的设备（如磁带）：一次最多返回一个记录
  * 一信号造成中断，已经付了部分数据量
* 读操作从文件的当前偏移量处开始，在成功返回之前，该偏移量将增加实际读到的字节数

### 函数write
```cpp
#include <unistd.h>
ssize_t write(int fd, const void *buf, size_t nbytes);
/*
 *  返回值：若成功，返回已写的字节数；若出错，返回-1
 */
```
* 返回值通常与参数nbytes的值相同，否则表示出错
* `write`出错的一个常见原因使磁盘已写满，或者超过了一个给定进程的文件长度限制
* 对于普通文件，写操作从文件的当前偏移量处开始
* 若打开该文件时，指定了`O_APPEND`选项，则在每次写操作之前，将文件偏移量设置在文件的当前结尾处
* 在一次成功写之后，该文件偏移量增加实际写的字节数

### I/O的效率
* 实例：[mycat.cpp](https://github.com/kinyang007/UNIX_Environment_Programming/blob/master/fileio/mycat.cpp)

### 文件共享
* 内核使用3种数据结构表示打开文件，它们之间的关系决定了在文件共享方面一个进程对另一个进程可能产生的影响
  * 每个进程的进程表中都有一个记录项，记录项中包含一张打开文件描述符表，可将其视为一个矢量，每个描述符占用一项。与每个文件描述符相关联的是：
    * 文件描述符标志(close_on_exec)
    * 指向一个文件表项的指针
  * 内核为所有打开文件维持一张文件表。每个文件表项包含：
    * 文件状态标志（读、写、读写、同步和非阻塞等）
    * 当前文件偏移量
    * 指向该文件v节点表项的指针
  * 每个打开文件（或设备）都有一个v节点(v-node)结构。v节点包含了文件类型和对此文件进行各种操作函数的指针。对大多数文件，v节点还包含了该文件的i节点(i-node，索引节点)。
    * 这些信息是在打开文件时从磁盘上读入内存的，所以文件的所有相关信息都是随时可用的。
* 两个独立进程各自打开了同一文件，从不同文件描述符上打开该文件
  * 每个进程都获得自己的文件表项，是因为这可以使每个进程都有它自己的对该文件的当前偏移量

### 原子操作
* 任何要求多于一个函数调用的操作都不是原子操作
  * 因为在两个函数调用之间，内核有可能会临时挂起进程
##### 函数pread和pwrite（允许原子性地定位并执行I/O）
```cpp
#include <unistd.h>
ssize_t pread(int fd, void *buf, size_t nbytes, off_t offset);
ssize_t pwrite(int fd, const void *buf, size_t nbytes, off_t offset);
/*
 *  返回值：
 *      pread：读到的字节数；若已到文件尾，返回0；若出错，返回-1
 *      pwrite：若成功，返回已写的字节数；若出错，返回-1
 */
```
* 调用`pread`相当于调用`lseek`后调用`read`，但`pread`又与这种顺序调用有下列重要区别
  * 调用`pread`时，无法中断其定位和读操作
  * 不更新当前文件偏移量
* 一般而言，原子操作(atomic operation)指的是由多步组成的一个操作。如果该操作原子地执行，则要么执行完所有步骤，要么一步也不执行，不可能只执行所有步骤的一个子集

### 函数dup和dup2
```cpp
#include <unistd.h>
int dup(int fd);
int dup2(int fd, int fd2);
/*
 *  返回值：若成功，返回新的文件描述符；若出错，返回-1
 */
```
* 用处：复制一个现有的文件描述符
* `dup`返回的新文件描述符一定是当前可用文件描述符中的最小数值
* `dup2`可以用fd2参数指定新描述符的值
  * 如果fd2已经打开，则先将其关闭
  * 如果fd等于fd2，则`dup2`返回fd2，而不关闭它，否则fd2的FD_CLOEXEC文件描述符标志就被清除，这样fd2在进程调用`exec`时是打开状态
* 这些函数返回的新文件描述符与参数fd共享同一个文件表项

### 函数sync、fsync和fdatasync
* 延迟写（delay write）
  * 传统的Unix系统实现在内核中设有缓冲区高速缓存或页高速缓存，大多数磁盘I/O都通过缓冲区进行
  * 向文件写入数据时，内核通常先将数据复制到缓冲区中，然后排入队列，晚些时候再写入磁盘
  * 为了保证磁盘上实际文件系统与缓冲区中内容的一致性，提供三个函数
```cpp
#include <unistd.h>
int fsync(int fd);      // 返回值：若成功，返回0；若出错，返回-1
int fdatasync(int fd);  // 返回值：若成功，返回0；若出错，返回-1
void sync(void);
```
* `sync`函数只是将所有修改过的块缓冲区排入写队列，然后就返回，它并不等待实际写磁盘操作结束
  * 通常，称为`update`的系统守护进程周期性地调用（一般间隔30秒）`sync`函数。这就保证了定期冲洗(flush)内核的块缓冲区
  * 命令`sync`也调用`sync`函数
* `fsync`函数只对由文件描述符fd指定的一个文件起作用，并且等待写磁盘操作结束才返回
  * `fsync`可用于数据库这样的应用程序，这种应用程序需要确保修改过的块立即写到磁盘上
* `fdatasync`函数类似于`fsync`，但它只影响文件的数据部分。除数据外，`fsync`还会同步更新文件的属性

### 函数fcntl
```cpp
#include <fcntl.h>
int fcntl(int fd, int cmd, ... /* int arg */);
/*
 *  返回值：若成功，则依赖于cmd（见下）；若出错，返回-1
 */
```
* `fcntl`函数可以改变已经打开文件的属性，有以下5种功能
  * 复制一个已有的描述符(cmd = `F_DUPFD` 或 `F_DUPFD_CLOEXEC`)
    * `F_DUPFD`: 复制文件描述符fd，新文件描述符作为函数值返回
    * `F_DUPFD_CLOEXEC`: 复制文件描述符，设置与新描述符关联的`FD_CLOEXEC`文件描述符标志的值，返回新文件描述符
  * 获取/设置文件描述符标志(cmd = `F_GETFD` 或 `F_SETFD`)
    * `F_GETFD`: 对应于fd的文件描述符标志作为函数值返回。当前只定义了一个文件描述符标志`FD_CLOEXEC`
    * `F_SETFD`: 对于fd设置文件描述符标志。新标志按第3个参数（取为整形值）设置
      * 很多现有的与文件描述符有关的程序并不使用常量`FD_CLOEXEC`，而是将此标志设置为0（系统默认，在`exec`时不关闭）或1（在`exec`时关闭）
  * 获取/设置文件状态标志(cmd = `F_GETFL` 或 `F_SETFL`)
    * `F_GETFL`: 对应于fd的文件状态标志作为函数值返回
      * 5个访问方式标志(`O_RDONLY`, `O_WRONLY`, `O_RDWR`, `O_EXEC`, `O_SEARCH`)并不各占1位，因此首先必须用屏蔽字`O_ACCMODE`取得访问方式位，然后将结果与这5个值中的每一个相比较
      * 实例：[fileflags.cpp](https://github.com/kinyang007/UNIX_Environment_Programming/blob/master/fileio/fileflags.cpp)
    * `F_SETFL`: 将文件状态标志设置为第3个参数的值（取为整型值）
      * 可更改的几个标志是：`O_APPEND`, `O_NONBLOCK`, `O_SYNC`, `O_DSYNC`, `O_RSYNC`, `O_FSYNC`, `O_ASYNC` 
  * 获取/设置异步I/O所有权(cmd = `F_GETOWN` 或 `F_SETOWN`)
    * `F_GETOWN`: 获取当前接收`SIGIO`和`SIGURG`信号的进程ID或进程组ID
    * `F_SETOWN`: 设置接收`SIGIO`和`SIGURG`信号的进程ID或进程组ID
      * 正的arg指定一个进程ID，负的arg表示等于arg绝对值的一个进程组ID
  * 获取/设置记录锁(cmd = `F_GETLK` 、 `F_SETLK` 或 `F_SETLKW`)
* 在修改文件描述符标志或文件状态标志时必须谨慎，先要获得现在的标志值，然后按照期望修改它，最后设置新标志值。不能只是执行`F_SETFD`或`F_SETFL`命令，这样会关闭以前设置的标志位
  * 实例：[setfl.cpp](https://github.com/kinyang007/UNIX_Environment_Programming/blob/master/fileio/setfl.cpp)
  * 在程序[mycat.cpp](https://github.com/kinyang007/UNIX_Environment_Programming/blob/master/fileio/mycat.cpp)开始处加上下面一行以调用`set_fl`，则开启了同步写标志
  ```cpp
  set_fl(STDOUT_FILENO, O_SYNC);
  ``` 

### 函数ioctl
```cpp
#include <unistd.h>     // System V
#include <sys/ioctl.h>  // BSD and Linux

int ioctl(int fd, int request, ...);
/*
 *  返回值：若出错，返回-1；若成功，返回其他值
 */
```
* `ioctl`函数一直是I/O操作的杂物箱。不能用本章中其他函数表示的I/O操作通常都能用`ioctl`表示
* 磁盘操作使我们可以在磁带上写一个文件结束标志、倒带、越过指定个数的文件或记录等，用本章中的其他函数(`read`, `write`, `lseek`等)都难于表示这些操作，所以，对这些设备进行操作最容易的方法就是使用`ioctl`

### /dev/fd
