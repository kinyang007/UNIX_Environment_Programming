//
// Created by Kin Yang on 2019-06-03.
//
#include "apue.h"
#include <fcntl.h>

char buf1[] = "abcdefghij";
char buf2[] = "ABCDEFGHIJ";

int main()
{
    int fd;

    if ((fd = creat("file.hole", FILE_MODE)) < 0)
        err_sys("creat error");

    if (write(fd, buf1, 10) != 10)
        err_sys("buf1 write error");
    // offset now = 10

    if (lseek(fd, 16384, SEEK_SET) == -1)
        err_sys("lseek error");
    // offset now = 16384

    if (write(fd, buf2, 10) != 10)
        err_sys("buf2 write error");
    // offset now = 16394

    exit(0);
}

/*

$ ./hole
$ ls -l file.hole # 检查其大小
-rw-r--r--  1 kinyang  staff  16394 Jun  3 11:37 file.hole
$ od -c file.hole # 观察实际内容
0000000    a   b   c   d   e   f   g   h   i   j  \0  \0  \0  \0  \0  \0
0000020   \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
*
0040000    A   B   C   D   E   F   G   H   I   J
0040012

*/