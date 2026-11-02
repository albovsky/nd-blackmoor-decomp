/* Includes only host frontend code; dead-strip discards its uncalled game main. */
#define main unused_headless_program_main
#ifndef RC_CONTROL_HEADLESS_SOURCE
#define RC_CONTROL_HEADLESS_SOURCE "../recomp/rc_headless.c"
#endif
#include RC_CONTROL_HEADLESS_SOURCE
#undef main
#include <stdarg.h>
#define CHECK(x) do { if (!(x)) { fprintf(stderr,"%s:%d CHECK(%s) failed\n",__FILE__,__LINE__,#x); return 1; } } while (0)
static const uint16_t primary[] = {0xf800};
static uint32_t fake_pitch = 2;
int rc_get_primary(const uint16_t **pixels,uint32_t *w,uint32_t *h,uint32_t *pitch)
{ *pixels=primary; *w=1; *h=1; *pitch=fake_pitch; return 1; }
void rc_input_script_log_observation(void) { rc_log("  STATE fake read-only primary"); }
void rc_log(const char *format,...) {
    char line[1024]; va_list ap; va_start(ap,format); vsnprintf(line,sizeof line,format,ap); va_end(ap); plat_log(NULL,line);
}
int main(int argc,char **argv) {
    CHECK(argc==2); CHECK(strlen(argv[1])<sizeof out_dir);
    strcpy(out_dir,argv[1]); control_mode=1;
    char path[700]; snprintf(path,sizeof path,"%s/frames",out_dir); CHECK(mkdir(path,0700)==0);
    snprintf(path,sizeof path,"%s/run.log",out_dir); logf=fopen(path,"w"); CHECK(logf);
    CHECK(control_shot_checked(NULL,1,100)); CHECK(control_shot_checked(NULL,2,200));
    CHECK(!control_shot_checked(NULL,1,300)); /* never overwrite an existing shot */
    for(unsigned number=1;number<=2;number++) {
        snprintf(path,sizeof path,"%s/frames/shot%03u.ppm",out_dir,number);
        FILE *f=fopen(path,"rb"); CHECK(f); unsigned char bytes[64]; size_t n=fread(bytes,1,sizeof bytes,f); CHECK(fclose(f)==0);
        static const unsigned char expected[]={'P','6',' ','1',' ','1',' ','2','5','5','\n',248,0,0};
        CHECK(n==sizeof expected && memcmp(bytes,expected,n)==0);
    }
    fake_pitch=1; CHECK(!control_shot_checked(NULL,3,300)); fake_pitch=2;
    rc_log("  CONTROL ACK id=2");
    snprintf(path,sizeof path,"%s/run.log",out_dir); FILE *reader=fopen(path,"rb"); CHECK(reader);
    char live[1024]; size_t n=fread(live,1,sizeof live-1,reader); live[n]=0; CHECK(fclose(reader)==0);
    CHECK(strstr(live,"CONTROL ACK id=2") && !control_log_failed); /* writer log is still open */
    snprintf(out_dir,sizeof out_dir,"%s/absent",argv[1]); CHECK(!control_shot_checked(NULL,3,300));
    CHECK(fclose(logf)==0);
    puts("INPUT_CONTROL capture ok unique=2 live_flush=1 duplicate_refused=1"); return 0;
}
