#ifndef _CTLFS_H
#define _CTLFS_H


#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <sys/socket.h>
#include <netinet/in.h>


int ctlfs_init_dirs(void);

int ctlfs_stop_dirs(void);

int ctlfs_init_files(void);

int ctlfs_stop_files(void);

int create_pen_node_directory(struct sockaddr_in * pen_node_addr, int index);

void inc_ccn_count();

void dec_ccn_count();

void inc_pen_count();

void dec_pen_count();

#ifdef __cplusplus
}
#endif


#endif


