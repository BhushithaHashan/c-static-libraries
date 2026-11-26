#include "log.h"
#include <unistd.h>
#include <string.h>

void log_info(const char *msg){
	write(1,msg,strlen(msg));
	write(1,"\n",1);
}
void log_warn(const char *msg){
	write(2,msg,strlen(msg));
	write(2,"\n",1);
}


