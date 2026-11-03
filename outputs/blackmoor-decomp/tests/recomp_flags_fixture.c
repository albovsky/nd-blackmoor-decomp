/* Synthetic header-only checks: no guest/original/CRT execution or memory callbacks. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include "original_methods_fl41.h"
#define CHECK(x) do { if (!(x)) { fprintf(stderr,"CHECK line %d: %s\n",__LINE__,#x); return 1; } } while (0)
#define FLAGS (cf | (pf << 2) | (zf << 6) | (sf << 7) | (of << 11))
typedef struct Context { Fl41Host host; uint32_t returned, published; int entry_empty; } Context;
typedef struct Result { Fl41Regs regs; uint32_t flags; int after; } Result;
static void publish(Fl41Regs *r, const Fl41Host *h, uint32_t bits)
{
    FL41_PROLOGUE
    cf=bits&1u; pf=(bits>>2)&1u; zf=(bits>>6)&1u; sf=(bits>>7)&1u; of=(bits>>11)&1u;
    eax=11u; ecx=22u; edx=33u;
    FL41_EPILOGUE
    FL41_FLAGS_OUT
}
static void stub(void *ctx, uint32_t target, Fl41Regs *r)
{
    Context *c=ctx; uint32_t *cell=c->host.callee_flags;
    c->entry_empty=!cell || *cell==FL41_NOFLAGS;
    c->published=FL41_NOFLAGS;
    if (target!=2u) {
        publish(r,&c->host,c->returned);
        c->published=cell ? *cell : FL41_NOFLAGS;
    }
    if (target==3u) r->esp=0xfffffff0u; /* Inert marker, never dereferenced here. */
}
static Result invoke(const Fl41Host *h, uint32_t target)
{
    Fl41Regs regs={1u,2u,3u,4u,5u,6u,7u,8u}, *r=&regs; Result out={0};
    FL41_PROLOGUE
    FL41_CALL_F(target);
    out.after=1;
done:
    out.flags=FLAGS;
    FL41_EPILOGUE
    out.regs=regs; return out;
}
int main(void)
{
    Context c={0}; uint32_t cell=0x8c5u; Result r;
    printf("LP64 ptr=%zu long=%zu Host=%zu ctx=%zu rd=%zu wr=%zu call=%zu fret=%zu fpu=%zu eflags=%zu callee_flags=%zu\n",
        sizeof(void *),sizeof(long),sizeof(Fl41Host),offsetof(Fl41Host,ctx),offsetof(Fl41Host,rd),offsetof(Fl41Host,wr),
        offsetof(Fl41Host,call),offsetof(Fl41Host,fret),offsetof(Fl41Host,fpu),offsetof(Fl41Host,eflags),offsetof(Fl41Host,callee_flags));
    CHECK(sizeof(void *)==8u && sizeof(long)==8u && sizeof(Fl41Host)==64u);
    CHECK(offsetof(Fl41Host,ctx)==0u && offsetof(Fl41Host,rd)==8u && offsetof(Fl41Host,wr)==16u);
    CHECK(offsetof(Fl41Host,call)==24u && offsetof(Fl41Host,fret)==32u && offsetof(Fl41Host,fpu)==40u);
    CHECK(offsetof(Fl41Host,eflags)==48u && offsetof(Fl41Host,callee_flags)==56u);
    c.host.ctx=&c; c.host.call=stub; c.host.callee_flags=&cell;
    c.host.eflags=0x884u; c.returned=0x41u; r=invoke(&c.host,1u);
    CHECK(c.entry_empty && c.published==0x41u && cell==FL41_NOFLAGS);
    CHECK(r.after && r.flags==0x41u && r.regs.eax==11u && r.regs.ecx==22u && r.regs.edx==33u);
    const uint32_t single_flags[]={1u,4u,0x40u,0x80u,0x800u};
    for (size_t i=0; i<sizeof(single_flags)/sizeof(single_flags[0]); ++i) {
        cell=0x8c5u; c.host.eflags=0x8c5u; c.returned=single_flags[i]; r=invoke(&c.host,1u);
        CHECK(c.entry_empty && c.published==single_flags[i] && cell==FL41_NOFLAGS);
        CHECK(r.after && r.flags==single_flags[i]);
    }
    puts("PASS individual flags, CF/ZF, consume, stale-entry reset, register return");
    cell=0x8c5u; c.host.eflags=0x41u; c.returned=0x884u; r=invoke(&c.host,1u);
    CHECK(c.entry_empty && c.published==0x884u && cell==FL41_NOFLAGS && r.after && r.flags==0x884u);
    puts("PASS transfer PF/SF/OF and clear old CF/ZF");
    cell=0x884u; c.host.eflags=0x8c5u; c.returned=0u; r=invoke(&c.host,1u);
    CHECK(c.entry_empty && c.published==0u && cell==FL41_NOFLAGS && r.after && r.flags==0u);
    puts("PASS valid zero flags differ from empty cell");
    cell=0x41u; c.host.eflags=0x884u; r=invoke(&c.host,2u);
    CHECK(c.entry_empty && c.published==FL41_NOFLAGS && cell==FL41_NOFLAGS && r.after && r.flags==0x884u);
    puts("PASS empty return preserves caller flags after stale-entry reset");
    cell=0x41u; c.host.callee_flags=NULL; c.returned=0x41u; r=invoke(&c.host,1u);
    CHECK(c.entry_empty && c.published==FL41_NOFLAGS && cell==0x41u && r.after && r.flags==0x884u);
    CHECK(r.regs.eax==11u && r.regs.ecx==22u && r.regs.edx==33u);
    puts("PASS NULL cell compatibility for actual publisher and caller macros");
    cell=0x884u; c.host.callee_flags=&cell; r=invoke(&c.host,3u);
    CHECK(c.entry_empty && c.published==0x41u && cell==0x41u && !r.after && r.flags==0x884u);
    CHECK(r.regs.eax==11u && r.regs.ecx==22u && r.regs.edx==33u);
    puts("PASS noreturn sentinel skips after-call and flag consumption");
    return 0;
}
