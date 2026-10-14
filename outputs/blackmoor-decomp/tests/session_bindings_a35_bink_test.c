#include "session_bindings_a35_bink.h"
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* Controlled codec boundary: the actual decoder/pacing is tested by S02 and
 * test_bink_audio. These probes catch host side effects on wrong visits. */
struct BinkPlayer { int at, reverse; uint64_t origin; };
static int opens, closes, starts, stops, presents, fail_audio, with_audio = 1;
static uint64_t now;
static uint32_t frame_count = 3;
static int fail_decode;
static const uint8_t pixels[16] = {1,2,3,255, 4,5,6,255, 7,8,9,255, 10,11,12,255};
int bink_player_open(const char *p, BinkPlayer **out, BinkPlayerInfo *i, char *e, size_t n)
{ (void)e;(void)n; if (!strcmp(p,"bad")) return -2;
  *out = calloc(1,sizeof(**out)); ++opens; memset(i,0,sizeof(*i)); i->total_frames=frame_count;i->width=2;i->height=2;return 0; }
int bink_player_set_mode(BinkPlayer *p,int32_t m,uint64_t t,char *e,size_t n)
{ (void)e;(void)n;p->reverse=m==1;p->at=m==1?2:0;p->origin=t;return 0; }
int bink_player_advance(BinkPlayer *p,uint64_t t,BinkPlayerFrame *f,char *e,size_t n)
{ if(fail_decode){snprintf(e,n,"fixture corrupt packet");return BINK_PLAYER_ERR_DECODE;}
  if(p->at<0||p->at>2)return 2;
  if(t<p->origin+(uint64_t)(p->reverse?2-p->at:p->at)*100)return 1;
  memset(f,0,sizeof(*f));f->rgba=pixels;f->rgba_bytes=16;f->width=f->height=2;f->stride=8;
  f->current_frame=p->at;f->is_terminal=p->reverse?p->at==0:p->at==2;p->at+=p->reverse?-1:1;return 0; }
void bink_player_close(BinkPlayer *p) { if(p){++closes;free(p);} }
int bink_audio_decode_file(const char *p,BinkAudio *a,char *e,size_t n)
{ (void)p;(void)e;(void)n;memset(a,0,sizeof(*a));if(!with_audio)return 1;
  a->pcm=calloc(4,sizeof(float));a->frame_count=4;a->channels=1;a->sample_rate=44100;return 0; }
void bink_audio_destroy(BinkAudio *a) { free(a->pcm);memset(a,0,sizeof(*a)); }
static uint64_t clock_fn(void *c){(void)c;return now;}
static int start(void *c,const BinkAudio *a){(void)c;assert(a->frame_count==4);++starts;return fail_audio;}
static void stop(void *c){(void)c;++stops;}
static int present(void *c,const BinkPlayerFrame *f,const A35Rect *s,const A35Rect *d)
{ (void)c;assert(f->rgba==pixels&&s->left==0&&d->left==10);++presents;return 0; }
static SessionA35Bink *open_movie(SessionA35BinkHost *h,int m)
{ SessionA35Bink *b=NULL;BinkPlayerInfo i;char e[128];assert(!session_a35_bink_open("ok",m,h,&b,&i,e,sizeof(e)));return b; }
int main(void)
{
 SessionA35BinkHost h={NULL,clock_fn,start,stop,present};SessionA35Bink *b;
 SessionA35BinkStats stats;A35Rect src={0,0,1,1},dst={10,20,11,21};int due,more;int16_t frame;
 now=0;b=open_movie(&h,0);assert(starts==0);
 assert(session_a35_bink_next(b,&more));assert(session_a35_bink_decode(b,&frame));
 assert(!session_a35_bink_due(b,&due)&&due);assert(!session_a35_bink_due(b,&due)&&due);
 assert(starts==0&&presents==0);assert(!session_a35_bink_decode(b,&frame)&&frame==0&&starts==1);
 assert(session_a35_bink_decode(b,&frame));assert(!session_a35_bink_rect(b,&src,&dst));
 assert(!session_a35_bink_next(b,&more)&&more);assert(!session_a35_bink_due(b,&due)&&!due);
 assert(session_a35_bink_decode(b,&frame));now=100;
 assert(!session_a35_bink_due(b,&due)&&due);assert(!session_a35_bink_decode(b,&frame)&&frame==1);
 assert(!session_a35_bink_rect(b,&src,&dst));assert(!session_a35_bink_next(b,&more)&&more);
 now=200;assert(!session_a35_bink_due(b,&due)&&due);assert(!session_a35_bink_decode(b,&frame)&&frame==2);
 assert(!session_a35_bink_rect(b,&src,&dst));assert(!session_a35_bink_next(b,&more)&&!more);
 /* A duplicate matching view revisits the terminal frame in the same pass. */
 assert(!session_a35_bink_due(b,&due)&&due);assert(!session_a35_bink_decode(b,&frame)&&frame==2);
 assert(!session_a35_bink_rect(b,&src,&dst));assert(!session_a35_bink_next(b,&more)&&!more);
 assert(!session_a35_bink_stats(b,&stats));
 assert(stats.decoded==4&&stats.presented==4&&strlen(stats.rgba_sha256)==64&&strlen(stats.pcm_sha256)==64);
 session_a35_bink_close(b);assert(starts==1&&stops==1&&presents==4);
 b=NULL;{BinkPlayerInfo i;char e[128];assert(session_a35_bink_open("ok",1,&h,&b,&i,e,sizeof(e))==2&&!b);
 assert(session_a35_bink_open("bad",0,&h,&b,&i,e,sizeof(e))==2&&!b);}
 with_audio=0;b=open_movie(&h,1);
 assert(!session_a35_bink_due(b,&due)&&due);assert(!session_a35_bink_decode(b,&frame)&&frame==2);
 assert(!session_a35_bink_rect(b,&src,&dst));assert(!session_a35_bink_next(b,&more)&&more);
 now+=100;assert(!session_a35_bink_due(b,&due)&&due);assert(!session_a35_bink_decode(b,&frame)&&frame==1);
 assert(!session_a35_bink_next(b,&more)&&more);now+=100;
 assert(!session_a35_bink_due(b,&due)&&due);assert(!session_a35_bink_decode(b,&frame)&&frame==0);
 assert(!session_a35_bink_next(b,&more)&&!more);session_a35_bink_close(b);
 with_audio=1;fail_audio=1;b=open_movie(&h,0);assert(!session_a35_bink_due(b,&due)&&due);
 assert(session_a35_bink_decode(b,&frame));assert(stops==2);
 assert(session_a35_bink_due(b,&due));session_a35_bink_close(b);
 assert(stops==2);fail_audio=0;b=open_movie(&h,0);assert(!session_a35_bink_due(b,&due)&&due);
 assert(!session_a35_bink_decode(b,&frame));src.right=2;assert(session_a35_bink_rect(b,&src,&dst));
 assert(session_a35_bink_next(b,&more));session_a35_bink_close(b);
 /* Span mismatch with a fully in-bounds source, and inclusive right==width. */
 src=(A35Rect){0,0,1,1};dst=(A35Rect){10,20,12,21};
 b=open_movie(&h,0);assert(!session_a35_bink_due(b,&due)&&due);
 assert(!session_a35_bink_decode(b,&frame));assert(session_a35_bink_rect(b,&src,&dst));
 session_a35_bink_close(b);
 dst=(A35Rect){10,20,11,22};b=open_movie(&h,0);
 assert(!session_a35_bink_due(b,&due)&&due);assert(!session_a35_bink_decode(b,&frame));
 assert(session_a35_bink_rect(b,&src,&dst));session_a35_bink_close(b);
 src=(A35Rect){0,0,2,1};dst=(A35Rect){10,20,12,21};b=open_movie(&h,0);
 assert(!session_a35_bink_due(b,&due)&&due);assert(!session_a35_bink_decode(b,&frame));
 assert(session_a35_bink_rect(b,&src,&dst));session_a35_bink_close(b);
 frame_count=32768;b=open_movie(&h,0);session_a35_bink_close(b);
 frame_count=32769;{BinkPlayerInfo i;char e[128];b=NULL;
 assert(session_a35_bink_open("ok",0,&h,&b,&i,e,sizeof(e))==A35_RUNTIME_UNSUPPORTED&&!b);}
 frame_count=3;b=open_movie(&h,0);
 assert(!session_a35_bink_due(b,&due)&&due);assert(!session_a35_bink_decode(b,&frame));
 assert(!session_a35_bink_next(b,&more)&&more);
 {int stopped=stops;fail_decode=1;now+=100;
 assert(session_a35_bink_due(b,&due));assert(stops==stopped+1);
 assert(strstr(session_a35_bink_failure(b),"player_status=-4")&&
        strstr(session_a35_bink_failure(b),"fixture corrupt packet"));
 assert(session_a35_bink_due(b,&due));assert(stops==stopped+1);
 session_a35_bink_close(b);assert(stops==stopped+1);fail_decode=0;}
 assert(opens==closes);
 puts("RT-9 provider: forward/reverse, due staging, terminal, audio once/stop, failure latch, rect bounds, cleanup passed");return 0;
}
