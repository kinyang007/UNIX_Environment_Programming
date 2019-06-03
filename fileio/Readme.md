# 文件IO
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

* openat函数引进作用
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

* 若lseek成功执行，则返回新的文件偏移量，为此可以用下列方式确定打开文件的当前偏移量：

```cpp
off_t currpos;
currpos = lseek(fd, 0, SEEK_CUR);
/*
 *  这种方法也可用来确定所涉及的文件是否可以设置偏移量。
 *  如果文件描述符指向的是一个管道、FIFO或网络套接字，则lseek返回-1，并将errno设置为ESPIPE
 */
```

* 实例：[seek.cpp]()
* 比较lseek的返回值时应当谨慎，不要测试它是否小于0，而要测试它是否等于-1（某些文件的偏移量可能为负值）
* 文件偏移量可以大于文件的当前长度，在此情况下，对该文件下一次写将加长该文件，并在文件中构成一个空洞。位于文件中但没有写过的字节都被读为0
* 文件的空洞并不要求在磁盘上占用存储区。对于原文件尾端和新开始写位置之间的部分不需要分配磁盘快
* 实例：[hole.cpp]()

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
* write出错的一个常见原因使磁盘已写满，或者超过了一个给定进程的文件长度限制
* 对于普通文件，写操作从文件的当前偏移量处开始
* 若打开该文件时，指定了`O_APPEND`选项，则在每次写操作之前，将文件偏移量设置在文件的当前结尾处
* 在一次成功写之后，该文件偏移量增加实际写的字节数

### I/O的效率
* [mycat.cpp]()
