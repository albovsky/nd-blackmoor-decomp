#import <Foundation/Foundation.h>
#include "macos_game_data.h"
#include <CommonCrypto/CommonDigest.h>
#include <cerrno>
#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <dirent.h>
#include <signal.h>
#include <strings.h>
#include <sys/stat.h>
#include <sys/stdio.h>
#include <unistd.h>
#include <vector>

namespace {
using Options = BlackmoorGameDataOptions;
static bool refuse(std::string *error, const std::string &message) {
    if (error) *error = message;
    return false;
}
static NSString *ns(const std::string &s) { return [NSString stringWithUTF8String:s.c_str()]; }
static std::string text(NSString *s) { return s ? std::string(s.fileSystemRepresentation) : std::string(); }
static NSString *canonical(const std::string &s) {
    if (s.empty() || !ns(s)) return nil;
    std::string p = s;
    if (p.front() != '/') p = text([[NSFileManager defaultManager] currentDirectoryPath]) + "/" + p;
    while (p.size() > 1 && p.back() == '/') p.pop_back();
    std::vector<std::string> tail;
    char *resolved;
    // Foundation can spell /private/tmp differently depending on whether the
    // final component exists. Resolve one existing ancestor with POSIX realpath
    // and append only the missing tail, before any mkdir/copy is possible.
    while (!(resolved = realpath(p.c_str(), nullptr))) {
        if (errno != ENOENT || p == "/") return nil;
        size_t slash = p.find_last_of('/');
        tail.push_back(p.substr(slash + 1));
        p = slash ? p.substr(0, slash) : "/";
    }
    p = resolved; free(resolved);
    for (auto i = tail.rbegin(); i != tail.rend(); ++i) {
        if (*i == ".") continue;
        if (*i == "..") { size_t slash = p.find_last_of('/'); p = slash ? p.substr(0, slash) : "/"; }
        else p += (p == "/" ? "" : "/") + *i;
    }
    if ((resolved = realpath(p.c_str(), nullptr))) { p = resolved; free(resolved); }
    else if (errno != ENOENT) return nil;
    return ns(p);
}
static bool ancestor_identity(NSString *root, NSString *path) {
    struct stat a, b;
    if (stat(root.fileSystemRepresentation, &a)) return false;
    std::string p = text(path);
    for (;;) {
        if (!stat(p.c_str(), &b) && a.st_dev == b.st_dev && a.st_ino == b.st_ino) return true;
        if (p == "/") return false;
        size_t slash = p.find_last_of('/'); p = slash ? p.substr(0, slash) : "/";
    }
}
static bool overlap(NSString *a, NSString *b) {
    // Device/inode ancestry also handles case aliases on case-insensitive APFS.
    return ancestor_identity(a, b) || ancestor_identity(b, a)
        || [a isEqualToString:b] || [a hasPrefix:[b stringByAppendingString:@"/"]]
        || [b hasPrefix:[a stringByAppendingString:@"/"]];
}
static bool metadata(NSString *p, struct stat *st) {
    std::string path = text(p);
    while (path.size() > 1 && path.back() == '/') path.pop_back();
    return lstat(path.c_str(), st) == 0;
}
static bool missing(NSString *p) {
    struct stat st;
    return !metadata(p, &st) && errno == ENOENT;
}
// A runtime directory must not contain aliases back into another data tree.
// APFS copy-on-write files have distinct inodes and remain permitted.
static bool safe_tree(NSFileManager *fm, NSString *p, bool runtime, std::string *error) {
    struct stat st;
    if (!metadata(p, &st)) return refuse(error, "cannot inspect data path: " + text(p));
    if (S_ISDIR(st.st_mode)) {
        NSArray<NSString *> *names = [fm contentsOfDirectoryAtPath:p error:nullptr];
        if (!names) return refuse(error, "cannot list data directory: " + text(p));
        for (NSString *name in names)
            if (!safe_tree(fm, [p stringByAppendingPathComponent:name], runtime, error)) return false;
        return true;
    }
    if (!S_ISREG(st.st_mode) || (runtime && st.st_nlink != 1))
        return refuse(error, "symlink, special file or shared hard link in data: " + text(p));
    return true;
}
static bool digest(NSString *p, std::string *out) {
    FILE *f = fopen(p.fileSystemRepresentation, "rb");
    if (!f) return false;
    CC_SHA256_CTX ctx; CC_SHA256_Init(&ctx);
    unsigned char buffer[65536], sum[CC_SHA256_DIGEST_LENGTH];
    size_t n;
    while ((n = fread(buffer, 1, sizeof buffer, f))) CC_SHA256_Update(&ctx, buffer, (CC_LONG)n);
    bool ok = !ferror(f); fclose(f);
    if (!ok) return false;
    CC_SHA256_Final(sum, &ctx);
    static const char hex[] = "0123456789abcdef";
    out->clear();
    for (unsigned char c : sum) { out->push_back(hex[c >> 4]); out->push_back(hex[c & 15]); }
    return true;
}
static bool hash_format(const std::string &s) {
    if (s.size() != 64) return false;
    for (char c : s) if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f'))) return false;
    return true;
}
static bool required(NSString *game, const std::string &hash, std::string *error) {
    for (NSString *name in @[@"GAME.EXE", @"Game.ini", @"Ciftree/CIFTREE.DAT", @"CDSound", @"CDVideo"]) {
        struct stat st;
        bool directory = [name isEqualToString:@"CDSound"] || [name isEqualToString:@"CDVideo"];
        if (!metadata([game stringByAppendingPathComponent:name], &st)
            || (directory ? !S_ISDIR(st.st_mode) : !S_ISREG(st.st_mode)))
            return refuse(error, "missing required original data: " + text(name));
    }
    std::string actual;
    if (!digest([game stringByAppendingPathComponent:@"GAME.EXE"], &actual) || actual != hash)
        return refuse(error, "GAME.EXE does not match the trusted original hash");
    return true;
}
static bool excluded(NSString *name, bool directory) {
    return (directory && [name.lowercaseString hasPrefix:@"documents"])
        || (!directory && [name.pathExtension.lowercaseString isEqualToString:@"sav"]);
}
// The receipt covers every copied file/directory. Mutable preferences and Award
// remain regular files but may change size. Other resources retain copied sizes;
// GAME.EXE additionally has the caller's trusted SHA256 ownership check.
static bool copy_tree(NSFileManager *fm, NSString *source, NSString *dest, NSString *relative,
                      NSMutableArray *entries, std::string *error) {
    struct stat st;
    if (!metadata(source, &st) || (!S_ISDIR(st.st_mode) && !S_ISREG(st.st_mode)))
        return refuse(error, "source contains a symlink or unsupported file: " + text(source));
    bool directory = S_ISDIR(st.st_mode);
    if (relative.length && excluded(source.lastPathComponent, directory)) return true;
    if (directory) {
        if (![fm createDirectoryAtPath:dest withIntermediateDirectories:NO
                attributes:@{NSFilePosixPermissions:@0700} error:nullptr])
            return refuse(error, "cannot create private clone directory: " + text(dest));
        if (relative.length) [entries addObject:@{@"path":relative, @"directory":@YES}];
        NSArray<NSString *> *names = [fm contentsOfDirectoryAtPath:source error:nullptr];
        if (!names) return refuse(error, "cannot enumerate original data: " + text(source));
        for (NSString *name in names) {
            NSString *child = relative.length ? [relative stringByAppendingPathComponent:name] : name;
            if (!copy_tree(fm, [source stringByAppendingPathComponent:name],
                           [dest stringByAppendingPathComponent:name], child, entries, error)) return false;
        }
    } else {
        if (![fm copyItemAtPath:source toPath:dest error:nullptr] || chmod(dest.fileSystemRepresentation, 0600))
            return refuse(error, "cannot make an independent writable data copy: " + text(relative));
        struct stat copied;
        if (!metadata(dest, &copied) || !S_ISREG(copied.st_mode) || copied.st_nlink != 1
            || copied.st_size != st.st_size || (copied.st_dev == st.st_dev && copied.st_ino == st.st_ino))
            return refuse(error, "data copy is incomplete or shares the original inode: " + text(relative));
        [entries addObject:@{@"path":relative, @"directory":@NO, @"bytes":@(st.st_size)}];
    }
    return true;
}
static bool valid_relative(NSString *path) {
    if (![path isKindOfClass:NSString.class] || !path.length || path.isAbsolutePath) return false;
    for (NSString *part in path.pathComponents) if ([part isEqualToString:@".."] || [part isEqualToString:@"."]) return false;
    return true;
}
static bool completed(NSFileManager *fm, NSString *package, const std::string &hash, std::string *error) {
    struct stat st;
    if (!metadata(package, &st) || !S_ISDIR(st.st_mode) || !safe_tree(fm, package, true, error))
        return refuse(error, "default data package is not a safe completed directory");
    NSDictionary *receipt = [NSDictionary dictionaryWithContentsOfFile:[package stringByAppendingPathComponent:@"complete.plist"]];
    if (![receipt isKindOfClass:NSDictionary.class] || ![receipt[@"version"] isEqual:@1]
        || ![receipt[@"executable_sha256"] isEqual:ns(hash)] || ![receipt[@"entries"] isKindOfClass:NSArray.class]
        || ![receipt[@"entries"] count]) return refuse(error, "incomplete or incompatible default data marker");
    NSString *game = [package stringByAppendingPathComponent:@"game"];
    if (access(game.fileSystemRepresentation, W_OK | X_OK)) return refuse(error, "default data directory is not writable");
    for (id item in receipt[@"entries"]) {
        if (![item isKindOfClass:NSDictionary.class] || !valid_relative(item[@"path"])
            || ![item[@"directory"] isKindOfClass:NSNumber.class]) return refuse(error, "invalid default data receipt entry");
        NSString *relative = item[@"path"];
        if (!metadata([game stringByAppendingPathComponent:relative], &st))
            return refuse(error, "default data copy is missing: " + text(relative));
        if ([item[@"directory"] boolValue] ? !S_ISDIR(st.st_mode) : !S_ISREG(st.st_mode))
            return refuse(error, "default data copy has changed file type: " + text(relative));
        bool mutable_file = [relative isEqualToString:@"Game.ini"] || [relative isEqualToString:@"Award.BMP"];
        if (mutable_file && access([game stringByAppendingPathComponent:relative].fileSystemRepresentation, W_OK))
            return refuse(error, "default preferences or Award file is not writable");
        if (![item[@"directory"] boolValue] && !mutable_file
            && (![item[@"bytes"] isKindOfClass:NSNumber.class] || [item[@"bytes"] longLongValue] != st.st_size))
            return refuse(error, "default data copy has changed resource size: " + text(relative));
    }
    return required(game, hash, error);
}
} // namespace

bool blackmoor_select_game_data(const Options &o, BlackmoorGameDataSelection *selection, std::string *error) {
    if (error) error->clear();
    if (!selection) return refuse(error, "missing game-data selection output");
    *selection = {};
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSString *seed = canonical(o.seed_directory), *save = canonical(o.save_directory);
    if (!seed || !save || overlap(seed, save)) return refuse(error, "save directory overlaps the original or is empty");
    const char *explicit_path = o.argument_directory ? o.argument_directory : o.environment_directory;
    if (explicit_path) {
        NSString *raw = ns(explicit_path), *chosen = canonical(explicit_path);
        struct stat st;
        if (!raw.length || !chosen || overlap(seed, chosen) || !metadata(raw, &st) || !S_ISDIR(st.st_mode)
            || !safe_tree(fm, chosen, true, error)) return refuse(error, "explicit data must be a safe scratch directory outside the original");
        selection->directory = text(chosen);
        return true;
    }
    if (!hash_format(o.expected_executable_sha256)) return refuse(error, "missing trusted original executable SHA256");
    NSString *support = canonical(o.support_directory);
    if (!support || overlap(seed, support)) return refuse(error, "default data destination overlaps the original or is empty");
    struct stat support_st;
    if (metadata(ns(o.support_directory), &support_st) && !S_ISDIR(support_st.st_mode))
        return refuse(error, "Application Support root is not a regular directory");
    NSString *package = [support stringByAppendingPathComponent:@"DataClone-v1"];
    selection->default_clone = true;
    if (!missing(package)) {
        if (!completed(fm, package, o.expected_executable_sha256, error)) return false;
        selection->directory = text([package stringByAppendingPathComponent:@"game"]);
        return true;
    }
    struct stat source_st;
    if (!metadata(ns(o.seed_directory), &source_st) || !S_ISDIR(source_st.st_mode)
        || !safe_tree(fm, seed, false, error) || !required(seed, o.expected_executable_sha256, error))
        return refuse(error, "original data cannot initialize a safe default clone");
    if (![fm createDirectoryAtPath:support withIntermediateDirectories:YES
            attributes:@{NSFilePosixPermissions:@0700} error:nullptr]) return refuse(error, "cannot create Application Support data root");
    NSString *stage = [support stringByAppendingPathComponent:[@".DataClone-v1.stage-" stringByAppendingString:NSUUID.UUID.UUIDString]];
    if (![fm createDirectoryAtPath:stage withIntermediateDirectories:NO
            attributes:@{NSFilePosixPermissions:@0700} error:nullptr]) return refuse(error, "cannot create private data staging package");
    NSMutableArray *entries = [NSMutableArray array];
    bool ok = copy_tree(fm, seed, [stage stringByAppendingPathComponent:@"game"], @"", entries, error);
    if (ok) {
        NSDictionary *receipt = @{@"version":@1, @"executable_sha256":ns(o.expected_executable_sha256), @"entries":entries};
        ok = [receipt writeToFile:[stage stringByAppendingPathComponent:@"complete.plist"] atomically:YES];
        if (!ok) refuse(error, "cannot finish default data marker");
    }
    if (ok) ok = completed(fm, stage, o.expected_executable_sha256, error);
    if (ok && renamex_np(stage.fileSystemRepresentation, package.fileSystemRepresentation, RENAME_EXCL) == 0) {
        selection->created = true;
    } else if (ok) {
        int publish_error = errno;
        ok = (publish_error == EEXIST || publish_error == ENOTEMPTY)
            && completed(fm, package, o.expected_executable_sha256, error);
        if (!ok && error && error->empty()) refuse(error, "cannot publish default data without replacement");
    }
    // Only this invocation's UUID staging package can be removed. Never delete,
    // repair or replace an existing cache, the original, or a caller's scratch.
    if (!selection->created) [fm removeItemAtPath:stage error:nullptr];
    if (!ok) return false;
    selection->directory = text([package stringByAppendingPathComponent:@"game"]);
    return true;
}

bool blackmoor_verify_executable(const std::string &path, const std::string &expected, std::string *error) {
    if (error) error->clear();
    struct stat st;
    if (stat(path.c_str(), &st) != 0)
        return refuse(error, "GAME.EXE not found at " + path + " (" + strerror(errno) + "); use --exe or --game-dir with the owned original");
    if (!S_ISREG(st.st_mode)) return refuse(error, "the executable " + path + " is not a regular file");
    std::string actual;
    if (!digest(ns(path), &actual)) return refuse(error, "cannot read the executable " + path + ": " + strerror(errno));
    if (actual != expected)
        return refuse(error, "the executable " + path + " has SHA-256 " + actual + "; this port runs only the owned original GAME.EXE with SHA-256 " + expected);
    return true;
}

namespace {
// A temp file of an interrupted save is named .rcsave-<pid>-<n>.tmp by rc_win32.c; only one whose process is gone is removed.
static void sweep_dead_save_temps(const std::string &directory) {
    DIR *d = opendir(directory.c_str());
    if (!d) return;
    std::vector<std::string> stale;
    while (struct dirent *e = readdir(d)) {
        int pid = 0;
        if (sscanf(e->d_name, ".rcsave-%d-", &pid) == 1 && pid > 0 && kill(pid, 0) != 0 && errno == ESRCH) stale.push_back(e->d_name);
    }
    closedir(d);
    for (const std::string &name : stale) unlink((directory + "/" + name).c_str());
}
static bool writable_directory(const std::string &path, const char *role, std::string *error) {
    if (access(path.c_str(), W_OK | X_OK) == 0) return true;
    return refuse(error, std::string(role) + " " + path + " is not writable (" + strerror(errno) + "); the game cannot save there. "
                         "Fix its permissions or pass a writable --save-dir. Existing saves were not changed.");
}
static std::vector<std::string> subdirectories(const std::string &path, bool documents_only) {
    std::vector<std::string> names;
    DIR *d = opendir(path.c_str());
    if (!d) return names;
    while (struct dirent *e = readdir(d)) {
        if (!strcmp(e->d_name, ".") || !strcmp(e->d_name, "..")) continue;
        if (documents_only && strncasecmp(e->d_name, "Documents", 9) != 0) continue;
        struct stat st;
        if (stat((path + "/" + e->d_name).c_str(), &st) == 0 && S_ISDIR(st.st_mode)) names.push_back(e->d_name);
    }
    closedir(d);
    return names;
}
} // namespace

bool blackmoor_prepare_save_directory(const std::string &directory, std::string *error) {
    if (error) error->clear();
    if (directory.empty()) return refuse(error, "the save directory is empty");
    int make_error = 0;
    for (size_t i = 1; i <= directory.size(); ++i) {
        if (i != directory.size() && directory[i] != '/') continue;
        if (mkdir(directory.substr(0, i).c_str(), 0755) != 0 && errno != EEXIST && !make_error) make_error = errno;
    }
    struct stat st;
    if (stat(directory.c_str(), &st) != 0)
        return refuse(error, "cannot create the save directory " + directory + " (" + strerror(make_error ? make_error : errno) + ")");
    if (!S_ISDIR(st.st_mode)) return refuse(error, "the save directory " + directory + " is not a directory");
    if (!writable_directory(directory, "the save directory", error)) return false;
    sweep_dead_save_temps(directory);
    for (const std::string &documents : subdirectories(directory, true)) {
        std::string folder = directory + "/" + documents;
        if (!writable_directory(folder, "the save folder", error)) return false;
        sweep_dead_save_temps(folder);
        for (const std::string &game : subdirectories(folder, false)) {
            std::string inner = folder + "/" + game;
            if (!writable_directory(inner, "the save folder", error)) return false;
            sweep_dead_save_temps(inner);
        }
    }
    return true;
}
