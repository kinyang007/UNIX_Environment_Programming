//
// Created by Kin Yang on 2019-06-06.
//

#include "apue.h"
#include <fcntl.h>

void set_fl(int fd, int flags)  // flags are file status flags to turn on
{
    int val;
    if ((val = fcntl(fd, F_GETFL, 0)) < 0)
        err_sys("fcntl F_GETFL error");

    val |= flags;               // turn on flags
/*  val &= ~flags;              // turn off flags    */
    if (fcntl(fd, F_SETFL, val) < 0)
        err_sys("fcntl F_SETFL error");
}

