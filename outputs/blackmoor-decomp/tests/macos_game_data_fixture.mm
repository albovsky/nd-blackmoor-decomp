#import <Foundation/Foundation.h>
#include "macos_game_data.h"
#include <CommonCrypto/CommonDigest.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <map>
#include <string>
#include <sys/stat.h>
#include <thread>
#include <unistd.h>

static int failures;
static void expect(bool value, const char *what) {
    if (!value) { fprintf(stderr, "FAIL %s\n", what); ++failures; }
}
static NSString *ns(const std::string &s) { return [NSString stringWithUTF8String:s.c_str()]; }
static void dir(const std::string &p) {
    expect([[NSFileManager defaultManager] createDirectoryAtPath:ns(p) withIntermediateDirectories:YES
                 attributes:nil error:nullptr], "fixture directory");
}
static void put(const std::string &p, const char *value) {
    NSData *d = [NSData dataWithBytes:value length:strlen(value)];
    expect([d writeToFile:ns(p) atomically:YES], "fixture file");
}
static std::string get(const std::string &p) {
    NSData *d = [NSData dataWithContentsOfFile:ns(p)];
    return d ? std::string((const char *)d.bytes, d.length) : std::string();
}
static bool exists(const std::string &p) { return [[NSFileManager defaultManager] fileExistsAtPath:ns(p)]; }
using Inventory = std::map<std::string,std::string>;
static void inventory(const std::string &root,const std::string &relative,Inventory &items) {
    std::string path=root+(relative.empty()?"":"/"+relative);struct stat st{};
    if(lstat(path.c_str(),&st)) {items[relative]="missing";return;}
    std::string mode=std::to_string(st.st_mode&07777);
    if(S_ISDIR(st.st_mode)) {
        items[relative]="directory:"+mode;
        for(NSString *name in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:ns(path) error:nullptr])
            inventory(root,relative.empty()?name.fileSystemRepresentation:relative+"/"+name.fileSystemRepresentation,items);
    } else if(S_ISREG(st.st_mode)) {
        NSData *d=[NSData dataWithContentsOfFile:ns(path)];std::string value="unreadable";
        if(d) {unsigned char sum[CC_SHA256_DIGEST_LENGTH];CC_SHA256(d.bytes,(CC_LONG)d.length,sum);
            static const char hex[]="0123456789abcdef";value.clear();
            for(unsigned char c:sum){value.push_back(hex[c>>4]);value.push_back(hex[c&15]);}}
        items[relative]="file:"+mode+":"+value;
    } else if(S_ISLNK(st.st_mode)) {
        NSString *target=[[NSFileManager defaultManager] destinationOfSymbolicLinkAtPath:ns(path) error:nullptr];
        items[relative]="symlink:"+std::string(target?target.fileSystemRepresentation:"");
    } else items[relative]="special:"+mode;
}
static BlackmoorGameDataOptions seed(const std::string &root) {
    BlackmoorGameDataOptions o;
    o.seed_directory=root+"/owned seed"; o.support_directory=root+"/support"; o.save_directory=root+"/scratch saves";
    o.expected_executable_sha256="ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"; // SHA256("abc")
    dir(o.seed_directory+"/Ciftree"); dir(o.seed_directory+"/CDSound"); dir(o.seed_directory+"/CDVideo");
    dir(o.seed_directory+"/Documents5/Game");
    put(o.seed_directory+"/GAME.EXE","abc"); put(o.seed_directory+"/Game.ini","original=1\n");
    put(o.seed_directory+"/Ciftree/CIFTREE.DAT","archive"); put(o.seed_directory+"/CDVideo/movie.bin","movie");
    put(o.seed_directory+"/Award.BMP","original award"); put(o.seed_directory+"/Documents5/Game/old.SAV","original save");
    put(o.seed_directory+"/stray.sAv","stray save"); put(o.seed_directory+"/CDSound/old.SAV","nested save");
    return o;
}
static void original_unchanged(const BlackmoorGameDataOptions &o) {
    expect(get(o.seed_directory+"/GAME.EXE")=="abc", "source executable unchanged");
    expect(get(o.seed_directory+"/Game.ini")=="original=1\n", "source INI unchanged");
    expect(get(o.seed_directory+"/Award.BMP")=="original award", "source award unchanged");
    expect(get(o.seed_directory+"/Documents5/Game/old.SAV")=="original save", "source save unchanged");
    expect(get(o.seed_directory+"/Ciftree/CIFTREE.DAT")=="archive", "source archive unchanged");
    expect(get(o.seed_directory+"/CDVideo/movie.bin")=="movie", "source movie unchanged");
    expect(get(o.seed_directory+"/CDSound/old.SAV")=="nested save", "source nested save unchanged");
    expect(get(o.seed_directory+"/stray.sAv")=="stray save", "source stray save unchanged");
}
static bool choose(const BlackmoorGameDataOptions &o, BlackmoorGameDataSelection &r) {
    Inventory before,after;inventory(o.seed_directory,"",before);
    std::string error; bool ok=blackmoor_select_game_data(o,&r,&error);
    inventory(o.seed_directory,"",after);
    expect(before==after,"recursive source names/types/permissions/hashes unchanged on every selection, including refusals");
    printf("SELECTION ok=%d path=%s\n",ok,r.directory.c_str());
    if (!ok) fprintf(stderr,"selection refused: %s\n",error.c_str());
    return ok;
}
int main(int argc,char **argv) {
  @autoreleasepool {
    char temp[]="/private/tmp/blackmoor-data-fixture.XXXXXX";
    char *created=mkdtemp(temp); if(!created||argc!=2)return 2;
    const std::string root=created; auto o=seed(root); BlackmoorGameDataSelection r;
    std::string mode=argv[1];
    if(mode=="validation") {
        std::string resolved,error;
        const auto hash=o.expected_executable_sha256;
        expect(blackmoor_validate_game_seed(o.seed_directory,hash,&resolved,&error),"valid seed accepted");
        expect(resolved==o.seed_directory,"resolved seed is original, not runtime");
        auto refuse_seed=[&](const std::string &path,const char *message) {
            expect(!blackmoor_validate_game_seed(path,hash,&resolved,&error),"invalid seed refuses");
            expect(resolved.empty()&&error.find(message)!=std::string::npos,"plain actionable refusal");
            printf("FOLDER_REFUSED %s\n",error.c_str());
        };
        dir(root+"/empty");refuse_seed(root+"/empty","This folder is empty.");
        dir(root+"/wrong");put(root+"/wrong/readme.txt","another game");
        refuse_seed(root+"/wrong","This is not the game folder.");
        dir(root+"/missing");put(root+"/missing/GAME.EXE","abc");
        refuse_seed(root+"/missing","Some game files are missing");
        auto other=seed(root+"/second");
        put(other.seed_directory+"/GAME.EXE","xyz");
        refuse_seed(other.seed_directory,"This game version is not supported.");
        put(other.seed_directory+"/GAME.EXE","abc");
        expect(blackmoor_find_game_seed(o.seed_directory,{other.seed_directory},hash,&resolved,&error)
            &&resolved==o.seed_directory,"remembered valid seed wins over known location");
        expect(blackmoor_find_game_seed(root+"/wrong",{root+"/empty",other.seed_directory},hash,&resolved,&error)
            &&resolved==other.seed_directory,"unavailable remembered seed falls back to valid known location");
        expect(!blackmoor_find_game_seed(root+"/wrong",{root+"/empty"},hash,&resolved,&error),"no candidate requests picker");
        std::string wrapper=root+"/GOG.app";
        std::string nested=wrapper+"/Contents/Resources/game/Nancy Drew Curse of the Blackmoor Manor.app/Contents/Resources/drive_c/GOG Games/Nancy Drew - Curse of Blackmoor Manor";
        dir(nested);
        expect([[NSFileManager defaultManager] copyItemAtPath:ns(o.seed_directory+"/GAME.EXE")
            toPath:ns(nested+"/GAME.EXE") error:nullptr],"nested fixture executable");
        for (const char *name : {"Game.ini","Ciftree","CDSound","CDVideo"})
            expect([[NSFileManager defaultManager] copyItemAtPath:ns(o.seed_directory+"/"+name)
                toPath:ns(nested+"/"+name) error:nullptr],"nested fixture resource");
        expect(blackmoor_validate_game_seed(wrapper,hash,&resolved,&error)&&resolved==nested,"Mac app selection resolves nested seed");
        o.protected_seed_directories={other.seed_directory};
        o.argument_directory=other.seed_directory.c_str();
        expect(!choose(o,r),"alternate remembered/known original cannot become writable scratch");
        o.argument_directory=nullptr;
        expect(choose(o,r),"working clone prepared for picker overlap case");
        expect(blackmoor_validate_game_seed(r.directory,hash,&resolved,&error),"working copy contains valid game files");
        expect(!blackmoor_validate_seed_destinations(resolved,o.support_directory,o.save_directory,&error),
            "picker rejects a working copy before remembering it");
        expect(blackmoor_validate_seed_destinations(o.seed_directory,o.support_directory,o.save_directory,&error),
            "original installation has separate data and save destinations");
    } else if(mode=="default") {
        expect(choose(o,r),"default selection succeeds");
        expect(r.default_clone&&r.created&&r.directory!=o.seed_directory,"default selects independent private data");
        if (r.directory.find(root+"/")!=0 || r.directory==o.seed_directory) return 1; // Never mutate an unexpected path, even on regression.
        expect(r.directory.find(o.support_directory+"/")==0,"data uses support root, not scratch save override");
        expect(!exists(o.save_directory),"helper does not create/migrate save root");
        expect(get(r.directory+"/GAME.EXE")=="abc"&&get(r.directory+"/CDVideo/movie.bin")=="movie","resources copied");
        expect(!exists(r.directory+"/Documents5")&&!exists(r.directory+"/stray.sAv")&&!exists(r.directory+"/CDSound/old.SAV"),"no old Documents or SAV import");
        struct stat a{},b{}; stat((o.seed_directory+"/GAME.EXE").c_str(),&a);stat((r.directory+"/GAME.EXE").c_str(),&b);
        expect(a.st_dev!=b.st_dev||a.st_ino!=b.st_ino,"no source hard link");
        put(r.directory+"/Award.BMP","new earned award"); put(r.directory+"/Game.ini","personal preference changed\n");
        BlackmoorGameDataSelection again;expect(choose(o,again),"completed clone reusable");
        expect(!again.created&&again.directory==r.directory,"same completed clone reused");
        expect(get(r.directory+"/Award.BMP")=="new earned award"&&get(r.directory+"/Game.ini")=="personal preference changed\n","reuse preserves outputs/preferences");
        auto unavailable=o;
        unavailable.seed_directory=root+"/unmounted original";
        expect(choose(unavailable,again)&&!again.created&&again.directory==r.directory,
            "completed working copy is usable when the original is unavailable");
    } else if(mode=="explicit") {
        std::string arg=root+"/arg scratch",env=root+"/env scratch";dir(arg);dir(env);
        o.argument_directory=arg.c_str();o.environment_directory=env.c_str();
        expect(choose(o,r)&&!r.default_clone&&r.directory==arg,"CLI scratch wins env, stays in place");
        o.argument_directory=nullptr;expect(choose(o,r)&&r.directory==env,"environment scratch used");
        expect(!exists(o.support_directory),"explicit selection never initializes default clone");
        o.argument_directory="";expect(!choose(o,r),"empty explicit arg refuses even with env");
        o.argument_directory=nullptr;o.environment_directory="";expect(!choose(o,r),"empty explicit env refuses");
        o.argument_directory=arg.c_str();o.environment_directory=nullptr;
        std::string hard=arg+"/source hardlink";
        expect(link((o.seed_directory+"/CDVideo/movie.bin").c_str(),hard.c_str())==0,"fixture explicit source hardlink");
        expect(!choose(o,r),"explicit scratch containing a source hardlink refuses");
        expect(unlink(hard.c_str())==0,"remove only fixture scratch hardlink");
        std::string symbolic=arg+"/source symlink";
        expect([[NSFileManager defaultManager] createSymbolicLinkAtPath:ns(symbolic)
            withDestinationPath:ns(o.seed_directory+"/CDVideo/movie.bin") error:nullptr],"fixture explicit source symlink");
        expect(!choose(o,r),"explicit scratch containing a source symlink refuses");
        expect(unlink(symbolic.c_str())==0,"remove only fixture scratch symlink");
        std::string scratch_alias=root+"/scratch alias";
        expect([[NSFileManager defaultManager] createSymbolicLinkAtPath:ns(scratch_alias)
            withDestinationPath:ns(env) error:nullptr],"fixture nonsource scratch root symlink");
        o.argument_directory=scratch_alias.c_str();expect(!choose(o,r),"symlinked nonsource scratch root refuses");
        std::string trailing=scratch_alias+"/";o.argument_directory=trailing.c_str();
        expect(!choose(o,r),"trailing slash cannot hide nonsource scratch root symlink");
    } else if(mode=="wrong-incomplete") {
        auto wrong=o;wrong.expected_executable_sha256=std::string(64,'0');expect(!choose(wrong,r),"wrong owned executable refuses");
        expect(!exists(o.support_directory+"/DataClone-v1"),"wrong source not published");
        dir(o.support_directory+"/DataClone-v1/game");put(o.support_directory+"/DataClone-v1/game/GAME.EXE","abc");
        expect(!choose(o,r),"incomplete package without marker refuses, no overwrite");
        expect(get(o.support_directory+"/DataClone-v1/game/GAME.EXE")=="abc","incomplete cache untouched");
    } else if(mode=="tamper") {
        expect(choose(o,r),"initial cache succeeds");
        if (r.directory.find(root+"/")!=0 || r.directory==o.seed_directory) return 1;
        std::string chosen=r.directory,sibling=root+"/cache sibling hardlink";
        expect(link((chosen+"/Game.ini").c_str(),sibling.c_str())==0,"fixture completed-cache hardlink to sibling");
        expect(!choose(o,r),"completed cache containing a shared hardlink refuses");
        expect(get(chosen+"/Game.ini")=="original=1\n","hardlink refusal preserves completed cache bytes");
        expect(unlink(sibling.c_str())==0,"remove only fixture sibling alias");
        expect(choose(o,r)&&r.directory==chosen,"completed cache reusable after fixture alias removed");
        put(chosen+"/GAME.EXE","xyz");
        expect(!choose(o,r),"wrong completed-cache executable refuses without source fallback");
        expect(get(chosen+"/GAME.EXE")=="xyz","wrong completed cache not silently replaced");
    } else if(mode=="aliases-failure") {
        o.argument_directory=o.seed_directory.c_str();expect(!choose(o,r),"explicit original directory refuses");
        o.argument_directory=nullptr;auto save=o;save.save_directory=o.seed_directory+"/Documents9";
        expect(!choose(save,r),"save root inside original refuses");
        std::string case_seed=root+"/OWNED SEED";struct stat actual{},alias{};
        bool case_alias=!stat(o.seed_directory.c_str(),&actual)&&!stat(case_seed.c_str(),&alias)
            &&actual.st_dev==alias.st_dev&&actual.st_ino==alias.st_ino;
        printf("CASE_ALIAS same_directory=%d\n",case_alias);
        if(case_alias) {
            auto c=o;c.argument_directory=case_seed.c_str();expect(!choose(c,r),"case alias of original refuses");
            c.argument_directory=nullptr;c.save_directory=case_seed+"/Documents9";
            expect(!choose(c,r),"nonexistent save descendant via case alias refuses before any write");
            c=o;c.support_directory=case_seed+"/cache";
            expect(!choose(c,r),"nonexistent default descendant via case alias refuses before any write");
        }
        std::string link=root+"/alias";expect([[NSFileManager defaultManager] createSymbolicLinkAtPath:ns(link) withDestinationPath:ns(o.seed_directory) error:nullptr],"fixture symlink");
        o.argument_directory=link.c_str();expect(!choose(o,r),"explicit original symlink refuses");o.argument_directory=nullptr;
        auto parent_alias=o;std::string indirect=link+"/new cache";parent_alias.support_directory=indirect;
        expect(!choose(parent_alias,r),"canonical ancestor alias into original refuses");
        auto support_alias=o;support_alias.support_directory=link;
        expect(!choose(support_alias,r),"support root symlink refuses");
        auto overlap=o;overlap.support_directory=o.seed_directory+"/cache";expect(!choose(overlap,r),"default destination inside seed refuses");
        std::string blocked=root+"/blocked";put(blocked,"file");auto bad=o;bad.support_directory=blocked+"/child";
        expect(!choose(bad,r),"blocked parent fails closed");
        if (geteuid()!=0) {
            std::string unreadable=o.seed_directory+"/Ciftree/CIFTREE.DAT";
            expect(chmod(unreadable.c_str(),0000)==0,"fixture unreadable resource");
            expect(!choose(o,r),"ordinary resource copy failure refuses");
            expect(chmod(unreadable.c_str(),0600)==0,"restore fixture read permission");
            expect(!exists(o.support_directory+"/DataClone-v1"),"failed copy never publishes partial package");
        }
        expect([[NSFileManager defaultManager] createSymbolicLinkAtPath:ns(o.seed_directory+"/Ciftree/unsafe") withDestinationPath:ns(root) error:nullptr],"fixture resource link");
        expect(!choose(o,r),"resource symlink refuses copy");
    } else if(mode=="competing") {
        BlackmoorGameDataSelection a,b;bool first=false,second=false;
        std::thread x([&]{@autoreleasepool{first=choose(o,a);}}),y([&]{@autoreleasepool{second=choose(o,b);}});x.join();y.join();
        expect(first&&second,"both competing callers get completed data");
        expect(a.directory==b.directory&&a.created!=b.created,"non-replacing winner published once");
        expect(get(a.directory+"/CDVideo/movie.bin")=="movie","winner complete");
    } else return 2;
    original_unchanged(o);
    printf("GAME_DATA_FIXTURE mode=%s failures=%d root=%s\n",mode.c_str(),failures,root.c_str());
    return failures?1:0;
  }
}
