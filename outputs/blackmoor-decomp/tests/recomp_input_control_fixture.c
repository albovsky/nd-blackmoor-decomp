/* Real FIFO + unchanged RcInputScript, fake host boundaries; never a guest. */
#include "rc_internal.h"
#include "rc_input_control.h"
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#define CHECK(x) do { if (!(x)) { fprintf(stderr,"%s:%d CHECK(%s) failed\n",__FILE__,__LINE__,#x); exit(1); } } while (0)
static uint32_t now;
static int main_thread = 1, shot_ok = 1, anchor_known;
static unsigned stops, inputs, shots, polls, log_count, ack_count;
static uint32_t event_times[16];
static unsigned shot_numbers[16];
static char last_log[1024];
uint32_t rc_main_hwnd = 1;
uint8_t *rc_pages[RC_NPAGES];
uint32_t rc_clock(void) { return now; }
int rc_thread_is_main(void) { return main_thread; }
int rc_seen_at(const char *name,uint32_t *at) { if (!anchor_known || strcmp(name,"READY.CIF")) return 0; *at=50; return 1; }
void rc_request_stop(void) { stops++; }
uint32_t rc_rd_slow(uint32_t address,int bytes) { (void)address; (void)bytes; CHECK(0 && "guest memory read forbidden"); return 0; }
void rc_log(const char *format,...) {
    va_list ap; va_start(ap,format); int n=vsnprintf(last_log,sizeof last_log,format,ap); va_end(ap);
    CHECK(n>=0 && (size_t)n<sizeof last_log); log_count++;
    if (strstr(last_log,"CONTROL ACK ")) ack_count++;
}
void rc_input_event(uint32_t k,int32_t x,int32_t y,uint32_t hold,uint32_t key) {
    CHECK(main_thread && k==0 && x==11 && y==22 && hold==300 && key==0);
    if (inputs<16) event_times[inputs]=now; inputs++;
}
void rc_input_pointer_mask(int32_t x,int32_t y,uint32_t mask) { (void)x; (void)y; (void)mask; CHECK(0 && "unused pointer boundary"); }
void rc_input_key(uint32_t key,int down) { (void)key; (void)down; CHECK(0 && "unused key boundary"); }
static int shot(void *user,unsigned number,uint32_t at) {
    CHECK(user==&shots && main_thread && now==at && number==shots+1);
    if (shots<16) shot_numbers[shots]=number; shots++; return shot_ok;
}
static void poll(RcInputControl *c,uint32_t at) { CHECK(++polls<=200000u); now=at; rc_input_control_poll(c); }
static RcInputControlStatus status(RcInputControl *c) { return rc_input_control_status(c); }
static void send_bytes(RcInputControl *c,int writer,const char *data,size_t length) {
    size_t sent=0;
    for (unsigned n=0; sent<length && n<20000; ++n) {
        size_t count=length-sent; if (count>1024) count=1024;
        ssize_t got=write(writer,data+sent,count);
        if (got>0) sent+=(size_t)got;
        else CHECK(got<0 && (errno==EAGAIN || errno==EWOULDBLOCK || errno==EINTR));
        if (sent<length) poll(c,now);
        CHECK(!status(c).failed);
    }
    CHECK(sent==length);
}
static void send_line(RcInputControl *c,int writer,const char *text) { send_bytes(c,writer,text,strlen(text)); }
static void finish(RcInputControl *c,int writer,const char *line) {
    send_line(c,writer,line);
    for (unsigned i=0;i<16 && !status(c).complete && !status(c).failed;i++) poll(c,now);
    CHECK(status(c).complete && !status(c).failed && stops==1);
    CHECK(rc_input_control_end(c)); CHECK(strstr(last_log,"CONTROL SUMMARY complete=1"));
}
static void failed(RcInputControl *c) {
    CHECK(status(c).failed && !status(c).complete && status(c).error[0] && stops==1);
    CHECK(!rc_input_control_end(c)); CHECK(strstr(last_log,"CONTROL SUMMARY complete=0"));
    poll(c,now+100000); CHECK(stops==1);
}
static void ordered(RcInputControl *c,int writer) {
    send_line(c,writer,"1 1:move:11,22;101:shot:0,0\n2 1:shot:0,0;101:shot:0,0\n3 finish\n");
    poll(c,1000); CHECK(inputs==1 && shots==0 && ack_count==0);
    poll(c,1099); CHECK(shots==0);
    poll(c,1100); CHECK(shots==1 && ack_count==1 && stops==0);
    poll(c,1100); CHECK(shots==2 && ack_count==1);
    poll(c,1199); CHECK(shots==2);
    poll(c,1200); CHECK(shots==3 && ack_count==2 && stops==0);
    CHECK(event_times[0]==1000 && shot_numbers[0]==1 && shot_numbers[1]==2 && shot_numbers[2]==3);
    poll(c,1200); CHECK(!status(c).complete); poll(c,1200);
    CHECK(status(c).complete && stops==1 && status(c).finish_id==3);
    CHECK(status(c).delivered==4 && status(c).total_steps==4 && status(c).shots==3);
    CHECK(rc_input_control_end(c));
}
static void split_worker(RcInputControl *c,int writer) {
    send_line(c,writer,"1 1:mo"); main_thread=0; poll(c,100); CHECK(!status(c).bytes_read && !inputs);
    main_thread=1; poll(c,100); CHECK(!inputs && status(c).pending_bytes==6);
    poll(c,100); CHECK(!inputs && !stops); /* EAGAIN, no internal wait */
    send_line(c,writer,"ve:11,22\n"); poll(c,100); CHECK(inputs==1 && ack_count==1);
    for (unsigned i=0;i<4;i++) poll(c,100000+i*10000); /* old tail would stop */
    CHECK(stops==0 && !status(c).complete);
    finish(c,writer,"2 finish\n");
}
static void early_eof(RcInputControl *c,int writer,const char *which) {
    if (!strcmp(which,"partial-eof")) send_line(c,writer,"1 1:shot:");
    else if (!strcmp(which,"active-eof")) send_line(c,writer,"1 READY.CIF+1:shot:0,0\n");
    else poll(c,1); /* attached writer with no bytes is activity (EAGAIN) */
    CHECK(close(writer)==0);
    for (unsigned i=0;i<10 && !status(c).failed;i++) poll(c,1000+i);
    if (!strcmp(which,"active-eof") && !status(c).failed) CHECK(!rc_input_control_end(c));
    failed(c);
}
static void rejected(RcInputControl *c,int writer,const char *text) {
    send_line(c,writer,text);
    for (unsigned i=0;i<12 && !status(c).failed;i++) poll(c,1000+i);
    failed(c);
}
static void maximum_batch(RcInputControl *c,int writer,int too_big) {
    size_t payload=too_big?65537u:65536u, length=payload+3u;
    char *text=malloc(length+1); CHECK(text); memcpy(text,"1 1:shot:0,0",12);
    memset(text+12,' ',length-13u); text[length-1]='\n'; text[length]=0;
    /* Feed without assuming FIFO pipe capacity; failure is checked after read. */
    size_t sent=0;
    for (unsigned i=0;i<1000 && sent<length && !status(c).failed;i++) {
        size_t count=length-sent; if(count>1024) count=1024;
        ssize_t n=write(writer,text+sent,count); CHECK(n>0 || (n<0 && errno==EAGAIN));
        if(n>0) sent+=(size_t)n; poll(c,1000);
    }
    free(text);
    if (too_big) { for(unsigned i=0;i<4 && !status(c).failed;i++) poll(c,1000); failed(c); }
    else { CHECK(sent==length && shots==1 && ack_count==1); finish(c,writer,"2 finish\n"); }
}
static void maximum_requests(RcInputControl *c,int writer) {
    char line[64];
    for(unsigned i=1;i<4096;i++) {
        snprintf(line,sizeof line,"%u 1:shot:0,0\n",i); send_line(c,writer,line); poll(c,1);
        CHECK(ack_count==i && !stops);
    }
    finish(c,writer,"4096 finish\n"); CHECK(shots==4095 && status(c).requests==4096);
}
int main(int argc,char **argv) {
    CHECK(argc==3); const char *which=argv[1]; char path[1024],error[256];
    CHECK(snprintf(path,sizeof path,"%s/control.fifo",argv[2])>0);
    CHECK(mkfifo(path,0600)==0);
    RcInputControl *c=rc_input_control_open(path,NULL,shot,&shots,error,sizeof error); CHECK(c && !error[0]);
    /* Before the first writer, repeated EOF is allowed and workers do nothing. */
    poll(c,0); poll(c,0); CHECK(!status(c).failed && !stops);
    int writer=open(path,O_WRONLY|O_NONBLOCK); CHECK(writer>=0);
    if (!strcmp(which,"ordered")) ordered(c,writer);
    else if (!strcmp(which,"split-worker-tail")) split_worker(c,writer);
    else if (!strcmp(which,"missing-hwnd")) { rc_main_hwnd=0; rejected(c,writer,"1 1:shot:0,0\n"); CHECK(!shots); }
    else if (!strcmp(which,"shot-failure")) { shot_ok=0; rejected(c,writer,"1 1:shot:0,0\n"); CHECK(shots==1 && !ack_count); }
    else if (!strcmp(which,"partial-eof") || !strcmp(which,"empty-writer-eof") || !strcmp(which,"active-eof")) { early_eof(c,writer,which); writer=-1; }
    else if (!strcmp(which,"finish-eof")) { send_line(c,writer,"1 1:shot:0,0\n2 finish\n"); CHECK(close(writer)==0); writer=-1; for(unsigned i=0;i<8 && !status(c).complete;i++) poll(c,1); CHECK(rc_input_control_end(c)); }
    else if (!strcmp(which,"finish-then-host-error")) { send_line(c,writer,"1 finish\n"); poll(c,1); poll(c,1); CHECK(status(c).complete && stops==1); rc_input_control_fail(c,"fake host callback failure"); failed(c); }
    else if (!strcmp(which,"early-exit")) { send_line(c,writer,"1 READY.CIF+1:shot:0,0\n"); poll(c,1); CHECK(!rc_input_control_end(c)); failed(c); }
    else if (!strcmp(which,"malformed")) rejected(c,writer,"1 broken\n");
    else if (!strcmp(which,"duplicate")) rejected(c,writer,"1 1:shot:0,0\n1 finish\n");
    else if (!strcmp(which,"out-of-order")) rejected(c,writer,"2 finish\n");
    else if (!strcmp(which,"id-overflow")) rejected(c,writer,"42949672960 finish\n");
    else if (!strcmp(which,"id-leading-zero")) rejected(c,writer,"01 finish\n");
    else if (!strcmp(which,"after-finish")) rejected(c,writer,"1 finish\n2 1:shot:0,0\n");
    else if (!strcmp(which,"partial-after-finish")) rejected(c,writer,"1 finish\n2");
    else if (!strcmp(which,"delayed-after-finish")) { send_line(c,writer,"1 finish\n"); poll(c,1); CHECK(!status(c).complete && !stops); rejected(c,writer,"2"); }
    else if (!strcmp(which,"nul")) { const char b[]="1 1:shot:0,0\0\n"; send_bytes(c,writer,b,sizeof b-1); poll(c,1); failed(c); }
    else if (!strcmp(which,"crlf")) rejected(c,writer,"1 finish\r\n");
    else if (!strcmp(which,"max-batch")) maximum_batch(c,writer,0);
    else if (!strcmp(which,"oversize")) maximum_batch(c,writer,1);
    else if (!strcmp(which,"step-limit")) { char text[8192]="1 "; for(unsigned i=0;i<513;i++) strcat(text,"1:shot:0,0;"); strcat(text,"\n"); send_line(c,writer,text); for(unsigned i=0;i<4 && !status(c).failed;i++) poll(c,1); failed(c); CHECK(!shots); }
    else if (!strcmp(which,"max-requests")) maximum_requests(c,writer);
    else if (!strcmp(which,"open-guards")) {
        RcInputControl *bad=rc_input_control_open(path,"1:shot:",shot,&shots,error,sizeof error); CHECK(!bad && error[0]);
        char regular[1024]; CHECK(snprintf(regular,sizeof regular,"%s/regular",argv[2])>0);
        FILE *f=fopen(regular,"wb"); CHECK(f && fclose(f)==0);
        bad=rc_input_control_open(regular,NULL,shot,&shots,error,sizeof error); CHECK(!bad && error[0]);
        finish(c,writer,"1 finish\n");
    } else CHECK(0 && "unknown scenario");
    if(writer>=0) CHECK(close(writer)==0);
    rc_input_control_destroy(c); printf("INPUT_CONTROL %s ok polls=%u shots=%u\n",which,polls,shots); return 0;
}
