//
// Created by Kin Yang on 2019-06-03.
//

#include "apue.h"
int main()
{
    if (lseek(STDIN_FILENO, 0, SEEK_CUR) == -1)
        printf("cannot seek\n");
    else
        printf("seek OK\n");
    exit(0);
}

/*

$ ./seek < /etc/passwd
seek OK
$ cat < /etc/passwd | ./seek
cannot seek
$ ./seek < /var/spool/cron/FIFO
cannot seek

*/