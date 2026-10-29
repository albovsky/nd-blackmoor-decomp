#include <stdio.h>
#include <stdlib.h>
#include "scene_resource.h"
int main(int argc,char**argv){for(int a=1;a<argc;++a){FILE*f=fopen(argv[a],"rb");if(!f)continue;fseek(f,0,SEEK_END);long n=ftell(f);fseek(f,0,SEEK_SET);unsigned char*b=malloc(n);if(fread(b,1,n,f)!=(size_t)n){fclose(f);free(b);continue;}fclose(f);char err[128]={0};SceneResource*s=scene_resource_open_memory(b,n,err,sizeof err);if(!s){free(b);continue;}
SceneResourceSummary sm; scene_resource_get_summary(s,&sm); printf("SCENE %s title=%s bg=%s snd=%s rows=%zu\n",argv[a],sm.title,sm.background,sm.audio,sm.action_count);
size_t c=scene_resource_action_count(s);for(size_t i=0;i<c;i++){SceneActionInfo in;if(scene_resource_action_at(s,i,&in))continue;printf("  %zu t=%02x s=%02x k=%d '%s' body=",i,in.type,in.subtype,in.payload_kind,in.description);const uint8_t*p=in.typed_body?in.typed_body:in.raw_body;size_t l=in.typed_body?in.typed_body_length:in.raw_body_length;for(size_t j=0;j<l;j++)printf("%02x",p[j]);
printf(" deps=%zu",in.dependency_count);for(size_t d=0;d<in.dependency_count&&d<6;d++){SceneDependencyInfo di;if(scene_resource_dependency_at(s,i,d,&di)==0){printf(" [op%u:",di.opcode);for(int q=0;q<8;q++)printf("%d%s",di.fields[q],q<7?",":"");printf("]");}}printf("\n");}
scene_resource_close(s);free(b);}return 0;}
