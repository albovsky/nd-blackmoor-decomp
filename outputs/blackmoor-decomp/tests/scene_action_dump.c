/* Lists the raw action type of every row of each decoded scene resource given on the
 * command line, through the production parser (scene_resource.c). Output: one line per
 * scene "<path> <rows> <type> <type> ...". Resource bytes stay in work/; only the derived
 * listing is printed. Used by scripts/scene_action_coverage.py. */
#include <stdio.h>
#include <stdlib.h>
#include "scene_resource.h"
int main(int argc,char**argv){for(int a=1;a<argc;++a){FILE*f=fopen(argv[a],"rb");if(!f)continue;fseek(f,0,SEEK_END);long n=ftell(f);fseek(f,0,SEEK_SET);unsigned char*b=malloc(n);if(fread(b,1,n,f)!=(size_t)n){fclose(f);free(b);continue;}fclose(f);char err[128]={0};SceneResource*s=scene_resource_open_memory(b,n,err,sizeof err);if(s){size_t c=scene_resource_action_count(s);printf("%s %zu",argv[a],c);for(size_t i=0;i<c;i++){SceneActionInfo in;if(scene_resource_action_at(s,i,&in)==0)printf(" %02x",in.type);else printf(" ??");}printf("\n");scene_resource_close(s);}free(b);}return 0;}
