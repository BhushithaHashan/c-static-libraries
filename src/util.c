#include "util.h"
#include <string.h>
#include <unistd.h>
#include <sys/syscall.h>

void die(const char *msg){
	long is_suc=syscall(SYS_write,2,msg,strlen(msg));
	write(1,"\n",1);
	_exit(1);	
}
