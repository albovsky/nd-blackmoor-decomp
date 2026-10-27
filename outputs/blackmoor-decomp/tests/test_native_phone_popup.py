"""NATIVE-27 normal isolated controller/render checks; no original execution."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]

HARNESS = r'''
#include "native_phone_popup.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define CHECK(x) do { if (!(x)) { fprintf(stderr,"line%d: %s\n",__LINE__,#x); return 1; } } while(0)
typedef struct { int opened, closed, ready, playing, prepared, plays, unloads, requests; SceneTransitionRequest request; } Host;
static int op(void *p) { ((Host *)p)->opened++; return 0; }
static int ready(void *p,int *r) { *r=((Host *)p)->ready; return 0; }
static int prep(void *p,const uint8_t *r,size_t n) { Host *h=p; if(n!=49 || strcmp((const char *)r,"TelPickUp01") || r[33]!=3)return 1;h->prepared++;return 0; }
static int play(void *p,uint16_t c) { Host *h=p;if(c!=3)return 1;h->plays++;return 0; }
static int busy(void *p,uint16_t c,int *r) { if(c!=3)return 1;*r=((Host *)p)->playing;return 0; }
static int unload(void *p,const uint8_t *r,size_t n) { if(n!=49 || r[33]!=3)return 1;((Host *)p)->unloads++;return 0; }
static int request(void *p,const SceneTransitionRequest *r) { Host *h=p;h->requests++;h->request=*r;return 0; }
static int close_phone(void *p) { ((Host *)p)->closed++;return 0; }
static NativePhoneHost callbacks(Host *h) { NativePhoneHost x={h,op,ready,prep,play,busy,unload,request,close_phone};return x; }
static void put32(uint8_t *p,int32_t v) { uint32_t n=(uint32_t)v;for(int i=0;i<4;i++)p[i]=(uint8_t)(n>>(8*i)); }
static void rect(uint8_t *p,int a,int b,int c,int d) { put32(p,a);put32(p+4,b);put32(p+8,c);put32(p+12,d); }
static void fixture(uint8_t *u) {
 memset(u,0,NATIVE_PHONE_UICL_MIN_BYTES); strcpy((char *)u,"UICellPopUp_OVL");strcpy((char *)u+0x2f0,"UICellXtra_OVL");
 rect(u+0x27,1,1,243,375);rect(u+0x47,377,0,619,374);put32(u+0x67,1);
 rect(u+0x7ce,418,37,587,198);put32(u+0x87e,219);
 rect(u+0x8a2,245,29,291,39);rect(u+0x8c2,483,23,529,33);
 rect(u+0x923,201,29,221,40);rect(u+0x933,223,29,243,40);rect(u+0x943,557,23,577,34);
 rect(u+0x862,362,29,382,43);rect(u+0x872,491,205,511,219);rect(u+0x882,384,29,436,43);rect(u+0x892,534,205,586,219);
 rect(u+0x973,389,59,471,68);rect(u+0x983,462,24,544,33);
 rect(u+0x993,1,70,74,106);rect(u+0x9b3,467,101,540,137);
 strcpy((char *)u+0x3ae,"NO SOUND");u[0x3ae + 33]=3;u[0x3ae + 35]=2;u[0x3ae + 37]=1;
 strcpy((char *)u+0xd5d,"TelPickUp01");
}
static NativePhoneWorld world(void) { NativePhoneWorld w={0};w.cells.cell_583204=5;w.cells.scene_5bb57b=3337;w.cells.scene_5bb57f=3337;w.frame_5bb50b=7;w.vertical_5bb593=9;w.dword_5bb5a7=11;w.dword_5bb5ab=13;w.dword_5bb5af=15;return w; }
static int controller(void) {
 uint8_t u[NATIVE_PHONE_UICL_MIN_BYTES];fixture(u);Host h={0};NativePhoneHost hs=callbacks(&h);NativePhonePopup p={0};Action80Object a={0};NativePhoneWorld w=world();NativePhoneResult r={0};a.word_6b2=1600;a.dword_6b4=1;a.dword_6ca=19;
 CHECK(native_phone_popup_open(&p,&a,&w,u,sizeof u,&hs)==NATIVE_PHONE_OK);CHECK(h.opened==1 && a.word_6b2==1600 && a.state_4528==0);
 CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==NATIVE_PHONE_OK);CHECK(a.state_4528==4 && h.plays==0);
 CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==NATIVE_PHONE_OK);CHECK(a.state_4528==4);
 h.ready=1;CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==NATIVE_PHONE_OK);CHECK(a.state_4528==5 && h.plays==0);
 h.playing=1;CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==NATIVE_PHONE_OK);CHECK(a.state_4528==2 && a.dword_4530==5 && h.prepared==1 && h.plays==1 && r.event==NATIVE_PHONE_EVENT_PICKUP_STARTED);
 CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==NATIVE_PHONE_OK);CHECK(h.requests==0 && a.dword_4530==5);
 h.playing=0;CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==NATIVE_PHONE_OK);CHECK(a.dword_4530==6 && h.requests==0 && h.unloads==1);
 CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==NATIVE_PHONE_OK);CHECK(h.requests==1 && h.request.target_scene==1600);CHECK(h.request.opaque_words[2]==1 && h.request.opaque_dwords[2]==1);CHECK(a.scene_6ba==3337 && a.word_6bc==7 && a.word_6be==9 && a.dword_6c2==11 && a.dword_6c6==15 && a.dword_6ca==19);CHECK(w.cells.cell_5bb22a==1 && w.cells.cell_583204==0 && a.dword_4530==0);
 ActionFamily80Decoded d={0};d.word_0=9999;CHECK(action_family_80_runtime_visit(&d,&a,&w.cells)==0);CHECK(w.cells.scene_5bb57b==3337 && w.cells.cell_583204==5 && a.dword_65d2==1);
 CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==NATIVE_PHONE_OK);CHECK(!p.active && h.closed==1 && w.cells.cell_583204==0 && w.cells.cell_5bb22a==0 && a.word_6b2==9999 && r.event==NATIVE_PHONE_EVENT_CLOSED);
 return 0;
}
static int plans(void) {
 uint8_t u[NATIVE_PHONE_UICL_MIN_BYTES];fixture(u);Host h={0};NativePhoneHost hs=callbacks(&h);NativePhonePopup p={0};Action80Object a={0};NativePhoneWorld w=world();NativePhonePlan plan={0};a.word_6b2=1600;CHECK(native_phone_popup_open(&p,&a,&w,u,sizeof u,&hs)==0);a.state_4528=2;a.dword_4530=5;
 CHECK(native_phone_popup_plan(&p,&a,&w,u,sizeof u,10,10,800,500,800,500,&plan)==0);CHECK(plan.visible && plan.count==4);CHECK(plan.blits[0].destination.left==387 && plan.blits[0].destination.top==10);CHECK(plan.blits[1].source.left==31 && plan.blits[1].source.top==27 && plan.blits[1].destination.bottom==219);CHECK(plan.blits[3].destination.left==467 && plan.blits[3].destination.top==101 && plan.blits[3].source.left==1);
 a.dword_4530=6;CHECK(native_phone_popup_plan(&p,&a,&w,u,sizeof u,10,10,800,500,800,500,&plan)==0);CHECK(plan.count==5 && plan.blits[3].source.left==389 && plan.blits[3].destination.left==462);
 w.cells.cell_583204=2;w.cells.cell_5bb22a=1;a.dword_4530=0;CHECK(native_phone_popup_plan(&p,&a,&w,u,sizeof u,10,10,800,500,800,500,&plan)==0);CHECK(plan.visible && plan.count==5 && plan.blits[2].source.left==201);
 p.active=0;CHECK(native_phone_popup_plan(&p,&a,&w,u,sizeof u,10,10,800,500,800,500,&plan)==0);CHECK(!plan.visible && plan.count==0);
 return 0;
}
static int no_pickup_sound(void) {
 uint8_t u[NATIVE_PHONE_UICL_MIN_BYTES];fixture(u);strcpy((char *)u+0xd5d,"NO SOUND");Host h={0};h.ready=1;NativePhoneHost hs=callbacks(&h);NativePhonePopup p={0};Action80Object a={0};NativePhoneWorld w=world();NativePhoneResult r={0};a.word_6b2=1600;a.dword_6b4=1;
 CHECK(native_phone_popup_open(&p,&a,&w,u,sizeof u,&hs)==0);CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==0 && a.state_4528==5);CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==0 && a.dword_4530==6 && h.requests==0 && h.plays==0);CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==0 && h.requests==1 && h.unloads==0);
 return 0;
}
static int refusals(void) {
 uint8_t u[NATIVE_PHONE_UICL_MIN_BYTES];fixture(u);Host h={0};NativePhoneHost hs=callbacks(&h);NativePhonePopup p={0};Action80Object a={0};NativePhoneWorld w=world();NativePhoneResult r={0};a.word_6b2=9999;
 CHECK(native_phone_popup_open(&p,&a,&w,u,sizeof u,&hs)==NATIVE_PHONE_UNSUPPORTED);CHECK(!p.active && !h.opened);
 a.word_6b2=1600;w.unavailable_5a1e58=1;CHECK(native_phone_popup_open(&p,&a,&w,u,sizeof u,&hs)==NATIVE_PHONE_UNSUPPORTED);CHECK(!h.opened);
 w.unavailable_5a1e58=0;CHECK(native_phone_popup_open(&p,&a,&w,u,sizeof u,&hs)==0);a.state_4528=2;a.dword_4530=1;CHECK(native_phone_popup_process(&p,&a,&w,&hs,&r)==NATIVE_PHONE_UNSUPPORTED);CHECK(!h.requests && !h.plays);
 return 0;
}
static int owned_boot(const char *path) {
 uint8_t u[8192], pickup[49];char base[33],extras[33];FILE *f=fopen(path,"rb");CHECK(f!=NULL);size_t n=fread(u,1,sizeof u,f);CHECK(fclose(f)==0 && n==3981);
 CHECK(native_phone_popup_assets(u,n,base,extras,pickup)==0);CHECK(!strcmp(base,"UICellPopUp_OVL") && !strcmp(extras,"UICellXtra_OVL") && !strcmp((const char *)pickup,"TelPickUp01") && pickup[33]==3);
 NativePhonePopup p={0};p.active=1;Action80Object a={0};a.word_6b2=1600;a.state_4528=2;a.dword_4530=5;NativePhoneWorld w=world();NativePhonePlan plan={0};
 CHECK(native_phone_popup_plan(&p,&a,&w,u,n,10,10,800,500,800,500,&plan)==0);CHECK(plan.visible && plan.count==5 && plan.blits[1].sheet==NATIVE_PHONE_SHEET_EXTRAS && plan.blits[1].destination.left==604);
 w.cells.cell_5bb22a=1;w.cells.cell_583204=2;a.dword_4530=0;CHECK(native_phone_popup_plan(&p,&a,&w,u,n,10,10,800,500,800,500,&plan)==0);CHECK(plan.visible && plan.count==6);
 w.battery_5a1e54=1;CHECK(native_phone_popup_plan(&p,&a,&w,u,n,10,10,800,500,800,500,&plan)==0);CHECK(plan.blits[3].source.left==223);
 return 0;
}
int main(int argc,char **argv) { if(argc==3 && !strcmp(argv[1],"owned-boot"))return owned_boot(argv[2]);if(argc!=2)return 1;if(!strcmp(argv[1],"controller"))return controller();if(!strcmp(argv[1],"plans"))return plans();if(!strcmp(argv[1],"refusals"))return refusals();if(!strcmp(argv[1],"no-sound"))return no_pickup_sound();return 1; }
'''


class NativePhonePopupTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp = tempfile.TemporaryDirectory(prefix="blackmoor-phone-")
        cls.addClassCleanup(cls.temp.cleanup)
        build = Path(cls.temp.name)
        fixture = build / "fixture.c"
        fixture.write_text(HARNESS)
        cls.exe = build / "phone"
        result = subprocess.run([os.environ.get("CC", "cc"), "-std=c11", "-O2",
            "-Wall", "-Wextra", "-Wpedantic", "-Werror", "-I", str(PROJECT / "src"),
            str(fixture), str(PROJECT / "src/native_phone_popup.c"),
            str(PROJECT / "src/action_family_80_runtime.c"), "-o", str(cls.exe)],
            capture_output=True, text=True, timeout=30)
        if result.returncode:
            raise RuntimeError(result.stderr)

    def run_case(self, name, *args):
        result = subprocess.run([str(self.exe), name, *args], capture_output=True, text=True, timeout=5)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_real_busy_wait_then_scene_request_and_raw80_return(self):
        self.run_case("controller")

    def test_frame_view_origin_and_persistence_during_conversation(self):
        self.run_case("plans")

    def test_normal_keypad_and_unavailable_phone_are_explicit_refusals(self):
        self.run_case("refusals")

    def test_configured_no_sound_enters_state6_without_faking_audio(self):
        self.run_case("no-sound")

    def test_owner_boot_popup_and_status_art_use_real_uicl_fields(self):
        work = Path(os.environ.get("BLACKMOOR_ORIGINAL_WORK", PROJECT.parents[1] / "work"))
        boot = work / "analysis/hiff-resources/0053.bin"
        if not boot.is_file():
            self.skipTest("Owner-local decoded BOOT unavailable")
        data = boot.read_bytes()
        at = 12
        uicl = None
        while at + 8 <= len(data):
            size = int.from_bytes(data[at + 4:at + 8], "big")
            if data[at:at + 4] == b"UICL":
                uicl = data[at + 8:at + 8 + size]
                break
            at += 8 + size + (size & 1)
        self.assertIsNotNone(uicl)
        path = Path(self.temp.name) / "uicl.bin"
        path.write_bytes(uicl)
        self.run_case("owned-boot", str(path))


if __name__ == "__main__":
    unittest.main()
