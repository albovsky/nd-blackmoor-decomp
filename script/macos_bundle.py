#!/usr/bin/env python3
"""Relocatable, private ARM64 macOS bundle tooling for Blackmoor Recompiled (RECOMP-49).

Run through the project's pinned Python with isolated mode:

    work/tools/recomp-python/bin/python3 -I script/macos_bundle.py <command> ...

Commands
  ffmpeg-record          write the licence/source record into a freshly built FFmpeg prefix
  ffmpeg-stamp-matches   exit 0 when a prefix was built from the same tarball and configure command
  ffmpeg-check           load the built libraries and prove they are the minimal LGPL Bink-only build
  bundle                 copy non-system dependencies into Contents/Frameworks and rewrite load paths
  verify                 reject a bundle that is not self-contained, too new, or carries forbidden content
  package                bundle + verify + sign + (notarize) + DMG, then verify the DMG's app again

Nothing here deletes anything, shells out through a shell, or prints credentials. The signing
identity and notary profile come only from BLACKMOOR_SIGN_IDENTITY / BLACKMOOR_NOTARY_PROFILE and are
never echoed. No game executable, game resource, lifted C or save can enter a bundle: `verify`
checks the layout against an allowlist, names, magic bytes and (given --game-dir) content hashes.
"""

import argparse
import ctypes
import datetime
import hashlib
import json
import os
import plistlib
import re
import shutil
import subprocess
import sys
from pathlib import Path

EXPECTED_GAME_EXE_SHA256 = "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45"
DEFAULT_MIN_MACOS = "11.0"
SYSTEM_PREFIXES = ("/usr/lib/", "/System/Library/")
ALLOWED_RPATHS = ("@executable_path/../Frameworks", "@loader_path", "@loader_path/../Frameworks")
EXE_RPATH = "@executable_path/../Frameworks"
DYLIB_RPATH = "@loader_path"
# The only third-party code that may ship, and the only dylib names allowed in Contents/Frameworks.
BUNDLED_LIB_RE = re.compile(r"^lib(avformat|avcodec|avutil|swscale|swresample)\.\d+\.dylib$")
FFMPEG_LICENSE_SUBDIR = Path("Contents/Resources/licenses/FFmpeg")
FFMPEG_PREFIX_LICENSE_SUBDIR = Path("share/blackmoor-licenses/ffmpeg")
FFMPEG_LICENSE_FILES = ("COPYING.LGPLv2.1", "COPYING.LGPLv3", "LICENSE.md")
FFMPEG_REQUIRED_DECODERS = {"binkvideo", "binkaudio_dct", "binkaudio_rdft"}
FFMPEG_REQUIRED_DEMUXERS = {"bink"}
FFMPEG_REQUIRED_PROTOCOLS = {"file"}
FORBIDDEN_CONFIGURE_FLAGS = ("--enable-gpl", "--enable-nonfree", "--enable-version3")
MACHO_MAGICS = (
    b"\xcf\xfa\xed\xfe", b"\xce\xfa\xed\xfe", b"\xfe\xed\xfa\xcf", b"\xfe\xed\xfa\xce",
    b"\xca\xfe\xba\xbe", b"\xbe\xba\xfe\xca", b"\xca\xfe\xba\xbf", b"\xbf\xba\xfe\xca",
)
# Content that must never be inside the app, whatever the extension allowlist says.
FORBIDDEN_SUFFIXES = (
    ".exe", ".dll", ".c", ".h", ".cc", ".cpp", ".cxx", ".hpp", ".m", ".mm", ".s", ".asm", ".inc",
    ".sav", ".dmg", ".zip", ".vol", ".bik", ".wav", ".ogg", ".dat", ".pak", ".dump", ".lift",
)
FORBIDDEN_NAME_RE = re.compile(r"(^game\.exe$|^rc_lifted|lifted|generated\.c$)", re.IGNORECASE)
DEFAULT_RESOURCE_SUFFIXES = (".icns", ".png", ".strings", ".plist", ".nib", ".car", ".txt", ".md", ".json")
LICENSE_TEXT_SUFFIXES = ("", ".txt", ".md", ".json", ".lgplv2.1", ".lgplv3")


class BundleError(Exception):
    """A packaging failure; the message is safe to print."""


# --------------------------------------------------------------------------------------------
# small helpers
# --------------------------------------------------------------------------------------------

def sha256_file(path):
    digest = hashlib.sha256()
    with open(path, "rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def version_tuple(text):
    parts = []
    for piece in str(text).split("."):
        parts.append(int(piece))
    while len(parts) < 3:
        parts.append(0)
    return tuple(parts)


def redact(command):
    """A printable form of a command with credential-bearing values removed."""
    shown = []
    hide_next = False
    for item in command:
        if hide_next:
            shown.append("<redacted>")
            hide_next = False
            continue
        shown.append(str(item))
        if item in ("--sign", "-s", "--keychain-profile"):
            hide_next = True
    return " ".join(shown)


def run(command, check=True, capture=True, timeout=None):
    """Run a program without a shell. Output is returned, never echoed."""
    try:
        completed = subprocess.run(
            [str(item) for item in command],
            check=False,
            capture_output=capture,
            text=True,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired as error:
        raise BundleError("timed out: " + redact(command)) from error
    if check and completed.returncode != 0:
        detail = (completed.stderr or completed.stdout or "").strip()
        detail = detail[-1500:]
        raise BundleError("command failed (%d): %s\n%s" % (completed.returncode, redact(command), detail))
    return completed


def is_macho(path):
    try:
        with open(path, "rb") as handle:
            return handle.read(4) in MACHO_MAGICS
    except OSError:
        return False


def is_system_path(name):
    return name.startswith(SYSTEM_PREFIXES) and ".." not in name


def lipo_archs(path):
    result = run(["lipo", "-archs", path])
    return result.stdout.split()


class MachOInfo:
    def __init__(self):
        self.deps = []          # [(load command, name)] excluding the dylib's own id
        self.dylib_id = None
        self.rpaths = []
        self.minos = None


def read_macho(path):
    """Parse `otool -l` of a thin Mach-O file."""
    text = run(["otool", "-l", path]).stdout
    info = MachOInfo()
    blocks = re.split(r"^Load command \d+\s*$", text, flags=re.MULTILINE)
    for block in blocks[1:]:
        cmd_match = re.search(r"^\s*cmd (\S+)", block, flags=re.MULTILINE)
        if not cmd_match:
            continue
        cmd = cmd_match.group(1)
        if cmd in ("LC_LOAD_DYLIB", "LC_LOAD_WEAK_DYLIB", "LC_REEXPORT_DYLIB",
                   "LC_LAZY_LOAD_DYLIB", "LC_LOAD_UPWARD_DYLIB"):
            name = re.search(r"^\s*name (.+) \(offset \d+\)", block, flags=re.MULTILINE)
            if name:
                info.deps.append((cmd, name.group(1)))
        elif cmd == "LC_ID_DYLIB":
            name = re.search(r"^\s*name (.+) \(offset \d+\)", block, flags=re.MULTILINE)
            if name:
                info.dylib_id = name.group(1)
        elif cmd == "LC_RPATH":
            value = re.search(r"^\s*path (.+) \(offset \d+\)", block, flags=re.MULTILINE)
            if value:
                info.rpaths.append(value.group(1))
        elif cmd == "LC_BUILD_VERSION":
            platform = re.search(r"^\s*platform (\S+)", block, flags=re.MULTILINE)
            minos = re.search(r"^\s*minos (\S+)", block, flags=re.MULTILINE)
            if minos and platform and platform.group(1) in ("1", "MACOS"):
                info.minos = version_tuple(minos.group(1))
        elif cmd == "LC_VERSION_MIN_MACOSX":
            value = re.search(r"^\s*version (\S+)", block, flags=re.MULTILINE)
            if value:
                info.minos = version_tuple(value.group(1))
    return info


def expand_loader_path(value, loader, executable):
    if value.startswith("@loader_path"):
        return os.path.normpath(str(Path(loader).parent) + value[len("@loader_path"):])
    if value.startswith("@executable_path"):
        return os.path.normpath(str(Path(executable).parent) + value[len("@executable_path"):])
    return os.path.normpath(value)


def resolve_dependency(name, loader, executable, rpaths, extra_dirs):
    """The file a load command resolves to, or None. `rpaths` are the loader's own, then the executable's."""
    if is_system_path(name):
        return None
    if name.startswith("@rpath/"):
        tail = name[len("@rpath/"):]
        for rpath in rpaths:
            candidate = Path(expand_loader_path(rpath, loader, executable)) / tail
            if candidate.is_file():
                return candidate
        for directory in extra_dirs:
            candidate = Path(directory) / tail
            if candidate.is_file():
                return candidate
        return None
    if name.startswith(("@executable_path/", "@loader_path/")):
        candidate = Path(expand_loader_path(name, loader, executable))
        return candidate if candidate.is_file() else None
    if name.startswith("/"):
        candidate = Path(name)
        return candidate if candidate.is_file() else None
    return None


def read_app_executable(app):
    plist_path = Path(app) / "Contents/Info.plist"
    try:
        with open(plist_path, "rb") as handle:
            plist = plistlib.load(handle)
    except (OSError, plistlib.InvalidFileException) as error:
        raise BundleError("cannot read %s: %s" % (plist_path, error)) from error
    name = plist.get("CFBundleExecutable")
    if not name:
        raise BundleError("Info.plist has no CFBundleExecutable")
    executable = Path(app) / "Contents/MacOS" / name
    if not executable.is_file():
        raise BundleError("missing executable %s" % executable)
    return plist, executable


def icon_violations(app, plist):
    """Require the build's declared local icon; artwork decoding stays in the builder."""
    name = plist.get("CFBundleIconFile")
    if (not isinstance(name, str) or not name or len(name) > 255 or name in (".", "..")
            or "/" in name or "\\" in name or any(ord(c) < 32 or ord(c) == 127 for c in name)):
        return ["missing or unsafe CFBundleIconFile"]
    if not Path(name).suffix:
        name += ".icns"
    if Path(name).suffix.lower() != ".icns":
        return ["CFBundleIconFile must name an ICNS file"]
    resources = (Path(app) / "Contents/Resources").resolve()
    icon = resources / name
    if not resources.is_relative_to(Path(app).resolve()) or icon.resolve().parent != resources:
        return ["declared icon leaves bundle Resources"]
    if not icon.is_file():
        return ["cannot read declared icon: not a regular file"]
    try:
        with icon.open("rb") as handle:
            header = handle.read(8)
            size = os.fstat(handle.fileno()).st_size
    except OSError as error:
        return ["cannot read declared icon: %s" % error]
    if (not 8 < size <= 16 * 1024 * 1024 or len(header) != 8
            or header[:4] != b"icns" or int.from_bytes(header[4:8], "big") != size):
        return ["invalid declared ICNS header or length"]
    return []


# --------------------------------------------------------------------------------------------
# FFmpeg prefix: record, stamp, check
# --------------------------------------------------------------------------------------------

def ffmpeg_record(args):
    prefix = Path(args.prefix)
    source = Path(args.source)
    target = prefix / FFMPEG_PREFIX_LICENSE_SUBDIR
    target.mkdir(parents=True, exist_ok=True)
    for name in FFMPEG_LICENSE_FILES:
        origin = source / name
        if not origin.is_file():
            raise BundleError("FFmpeg source lacks %s" % name)
        shutil.copyfile(origin, target / name)
    for flag in FORBIDDEN_CONFIGURE_FLAGS:
        if flag in args.configure:
            raise BundleError("refusing to record a build configured with %s" % flag)
    components = {
        "libraries": ["avformat", "avcodec", "avutil", "swscale", "swresample"],
        "protocols": sorted(FFMPEG_REQUIRED_PROTOCOLS),
        "demuxers": sorted(FFMPEG_REQUIRED_DEMUXERS),
        "decoders": sorted(FFMPEG_REQUIRED_DECODERS),
    }
    record = {
        "product": "FFmpeg",
        "version": args.version,
        "license": "LGPL-2.1-or-later",
        "license_files": list(FFMPEG_LICENSE_FILES),
        "source_url": args.url,
        "source_sha256": args.sha256,
        "modifications": "none; unmodified official release tarball",
        "configure_command": args.configure,
        "minimum_macos": args.min_macos,
        "architecture": "arm64",
        "compiler": args.compiler,
        "sdk": args.sdk,
        "build_fingerprint": args.build_fingerprint,
        "components": components,
        "recorded_utc": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    }
    with open(target / "BUILD-INFO.json", "w", encoding="utf-8") as handle:
        json.dump(record, handle, indent=2, sort_keys=True)
        handle.write("\n")
    offer = (
        "FFmpeg in Blackmoor Recompiled\n"
        "==============================\n\n"
        "This application includes unmodified FFmpeg %(version)s libraries (libavformat, libavcodec,\n"
        "libavutil, libswscale, libswresample), built only as LGPL v2.1-or-later shared libraries and\n"
        "reduced to the file protocol, the Bink demuxer and the Bink video/audio decoders. No GPL,\n"
        "version-3 or nonfree option is enabled. FFmpeg is a trademark of Fabrice Bellard; see\n"
        "LICENSE.md and COPYING.LGPLv2.1 in this folder.\n\n"
        "Source: the complete corresponding source is the official release tarball\n"
        "  %(url)s\n"
        "  SHA-256 %(sha)s\n"
        "which is publicly available at that address. The libraries were built from it unmodified\n"
        "with this command (run from an empty build directory):\n\n"
        "  %(configure)s\n\n"
        "The libraries are separate dynamic libraries in Contents/Frameworks. You may replace them\n"
        "with a compatible build of the same FFmpeg major version; macOS requires the application to\n"
        "be signed again after you do (codesign --force --sign - on each replaced library and the app).\n"
        "Minimum macOS: %(minos)s. Compiler: %(compiler)s.\n"
    ) % {
        "version": args.version, "url": args.url, "sha": args.sha256,
        "configure": args.configure, "minos": args.min_macos, "compiler": args.compiler,
    }
    with open(target / "SOURCE-AVAILABILITY.txt", "w", encoding="utf-8") as handle:
        handle.write(offer)
    print("recorded FFmpeg licence/source information in %s" % target)
    return 0


def ffmpeg_stamp_matches(args):
    stamp = Path(args.prefix) / FFMPEG_PREFIX_LICENSE_SUBDIR / "BUILD-INFO.json"
    try:
        with open(stamp, "r", encoding="utf-8") as handle:
            record = json.load(handle)
    except (OSError, ValueError):
        return 1
    if record.get("source_sha256") != args.sha256:
        return 1
    if record.get("configure_command") != args.configure:
        return 1
    if record.get("build_fingerprint") != args.build_fingerprint:
        return 1
    return 0


def _ffmpeg_lib_files(lib_dir):
    libs = {}
    for entry in sorted(Path(lib_dir).iterdir()):
        match = BUNDLED_LIB_RE.match(entry.name)
        if match:
            libs[match.group(1)] = entry
    return libs


def ffmpeg_runtime_facts(lib_dir):
    """Load the libraries from `lib_dir` in this process and return what they really contain."""
    libs = _ffmpeg_lib_files(lib_dir)
    missing = {"avformat", "avcodec", "avutil", "swscale", "swresample"} - set(libs)
    if missing:
        raise BundleError("missing libraries in %s: %s" % (lib_dir, ", ".join(sorted(missing))))
    handles = {}
    for name in ("avutil", "swresample", "swscale", "avcodec", "avformat"):
        handles[name] = ctypes.CDLL(str(libs[name]))
    for name in ("avutil", "avcodec", "avformat", "swscale", "swresample"):
        getattr(handles[name], name + "_license").restype = ctypes.c_char_p
    handles["avutil"].av_version_info.restype = ctypes.c_char_p
    handles["avcodec"].avcodec_configuration.restype = ctypes.c_char_p
    facts = {
        "licenses": {
            name: getattr(handles[name], name + "_license")().decode()
            for name in ("avutil", "avcodec", "avformat", "swscale", "swresample")
        },
        "version": handles["avutil"].av_version_info().decode(),
        "configuration": handles["avcodec"].avcodec_configuration().decode(),
    }

    def iterate(function, restype, extra=()):
        function.restype = restype
        function.argtypes = [ctypes.POINTER(ctypes.c_void_p)] + list(extra)
        opaque = ctypes.c_void_p(None)
        names = []
        while True:
            item = function(ctypes.byref(opaque), *[0 for _ in extra])
            if not item:
                break
            if restype is ctypes.c_char_p:
                names.append(item.decode())
            else:
                # AVCodec and AVInputFormat both start with `const char *name`.
                names.append(ctypes.cast(item, ctypes.POINTER(ctypes.c_char_p))[0].decode())
        return names

    facts["codecs"] = sorted(iterate(handles["avcodec"].av_codec_iterate, ctypes.c_void_p))
    facts["demuxers"] = sorted(iterate(handles["avformat"].av_demuxer_iterate, ctypes.c_void_p))
    facts["muxers"] = sorted(iterate(handles["avformat"].av_muxer_iterate, ctypes.c_void_p))
    facts["protocols"] = sorted(iterate(handles["avformat"].avio_enum_protocols, ctypes.c_char_p, (ctypes.c_int,)))
    handles["avformat"].av_find_input_format.restype = ctypes.c_void_p
    handles["avformat"].av_find_input_format.argtypes = [ctypes.c_char_p]
    facts["bink_input_format_found"] = bool(handles["avformat"].av_find_input_format(b"bink"))
    return facts


def ffmpeg_facts_violations(facts):
    problems = []
    for name, text in facts["licenses"].items():
        if not text.startswith("LGPL version 2.1"):
            problems.append("lib%s license is %r, expected LGPL version 2.1 or later" % (name, text))
    for flag in FORBIDDEN_CONFIGURE_FLAGS + ("--enable-libx", "--enable-openssl", "--enable-libopus"):
        if flag in facts["configuration"]:
            problems.append("configuration contains %s" % flag)
    if set(facts["codecs"]) != FFMPEG_REQUIRED_DECODERS:
        problems.append("codecs are %s, expected exactly %s" % (facts["codecs"], sorted(FFMPEG_REQUIRED_DECODERS)))
    if set(facts["demuxers"]) != FFMPEG_REQUIRED_DEMUXERS:
        problems.append("demuxers are %s, expected %s" % (facts["demuxers"], sorted(FFMPEG_REQUIRED_DEMUXERS)))
    if facts["muxers"]:
        problems.append("muxers are enabled: %s" % facts["muxers"])
    if set(facts["protocols"]) != FFMPEG_REQUIRED_PROTOCOLS:
        problems.append("protocols are %s, expected %s" % (facts["protocols"], sorted(FFMPEG_REQUIRED_PROTOCOLS)))
    if not facts["bink_input_format_found"]:
        problems.append("av_find_input_format('bink') failed")
    return problems


def ffmpeg_check(args):
    lib_dir = Path(args.lib_dir) if args.lib_dir else Path(args.prefix) / "lib"
    facts = ffmpeg_runtime_facts(lib_dir)
    problems = ffmpeg_facts_violations(facts)
    min_os = version_tuple(args.min_macos)
    for entry in sorted(lib_dir.iterdir()):
        if entry.is_symlink() or not entry.is_file() or not is_macho(entry):
            continue
        if lipo_archs(entry) != ["arm64"]:
            problems.append("%s is not thin arm64" % entry.name)
        info = read_macho(entry)
        if info.minos is None or info.minos > min_os:
            problems.append("%s minimum macOS %s is above %s" % (entry.name, info.minos, args.min_macos))
        for _cmd, name in info.deps:
            if not (is_system_path(name) or name.startswith("@rpath/")):
                problems.append("%s depends on %s" % (entry.name, name))
        for rpath in info.rpaths:
            if rpath not in ALLOWED_RPATHS:
                problems.append("%s has rpath %s" % (entry.name, rpath))
    print(json.dumps({"version": facts["version"], "licenses": facts["licenses"], "codecs": facts["codecs"],
                      "demuxers": facts["demuxers"], "protocols": facts["protocols"]}, sort_keys=True))
    if problems:
        for problem in problems:
            print("FFMPEG-CHECK FAIL: " + problem, file=sys.stderr)
        return 1
    print("FFMPEG-CHECK OK: %s, LGPL, Bink-only" % facts["version"])
    return 0


# --------------------------------------------------------------------------------------------
# bundle: copy dependencies, rewrite load commands
# --------------------------------------------------------------------------------------------

def load_ffmpeg_record(prefix):
    path = Path(prefix) / FFMPEG_PREFIX_LICENSE_SUBDIR / "BUILD-INFO.json"
    try:
        with open(path, "r", encoding="utf-8") as handle:
            record = json.load(handle)
    except (OSError, ValueError) as error:
        raise BundleError(
            "%s is not a Blackmoor LGPL FFmpeg build (no %s); build one with script/build_ffmpeg_macos.sh"
            % (prefix, path)) from error
    for flag in FORBIDDEN_CONFIGURE_FLAGS:
        if flag in record.get("configure_command", ""):
            raise BundleError("FFmpeg prefix was configured with %s and cannot be shipped" % flag)
    if record.get("license") != "LGPL-2.1-or-later":
        raise BundleError("FFmpeg prefix licence is %r, not LGPL-2.1-or-later" % record.get("license"))
    return record


def bundle_dependencies(app, ffmpeg_prefix):
    app = Path(app)
    plist, executable = read_app_executable(app)
    frameworks = app / "Contents/Frameworks"
    frameworks.mkdir(exist_ok=True)
    extra_dirs = [Path(ffmpeg_prefix) / "lib"]
    queue = [(executable, executable)]        # (file inside the bundle, where its load paths are resolved from)
    copied = {}                               # destination name -> real source path
    objects = {}                              # bundled file -> MachOInfo read before any rewriting
    origins = {}                              # bundled file -> location its @loader_path refers to
    origins[executable] = executable
    executable_info = read_macho(executable)
    while queue:
        current, origin = queue.pop()
        if current in objects:
            continue
        info = read_macho(current) if current != executable else executable_info
        objects[current] = info
        search_rpaths = list(info.rpaths) + [item for item in executable_info.rpaths if item not in info.rpaths]
        for _cmd, name in info.deps:
            if is_system_path(name):
                continue
            if BUNDLED_LIB_RE.match(os.path.basename(name)):
                # FFmpeg libraries come only from the verified LGPL prefix, never from whatever rpath
                # or absolute path (a Homebrew GPL build, say) the executable was linked against.
                candidate = Path(ffmpeg_prefix) / "lib" / os.path.basename(name)
                source = candidate if candidate.is_file() else None
            else:
                source = resolve_dependency(name, origin, executable, search_rpaths, extra_dirs)
            if source is None:
                raise BundleError("unbundled dependency of %s: %s" % (current.name, name))
            base = os.path.basename(name)
            real = Path(os.path.realpath(source))
            destination = frameworks / base
            if base in copied and copied[base] != real:
                raise BundleError("two different libraries are both named %s" % base)
            if base not in copied:
                shutil.copyfile(real, destination)
                destination.chmod(0o755)
                copied[base] = real
                origins[destination] = source
            queue.append((destination, origins[destination]))
    # rewrite once everything is copied
    for current, info in objects.items():
        arguments = []
        if current != executable:
            arguments += ["-id", "@rpath/" + current.name]
        for _cmd, name in info.deps:
            if not is_system_path(name):
                wanted = "@rpath/" + os.path.basename(name)
                if wanted != name:
                    arguments += ["-change", name, wanted]
        for rpath in info.rpaths:
            arguments += ["-delete_rpath", rpath]
        if arguments:
            run(["install_name_tool"] + arguments + [str(current)])
        wanted_rpath = EXE_RPATH if current == executable else DYLIB_RPATH
        try:
            run(["install_name_tool", "-add_rpath", wanted_rpath, str(current)])
        except BundleError as error:
            raise BundleError(
                "cannot add rpath to %s (build the executable with -Wl,-headerpad_max_install_names):\n%s"
                % (current.name, error)) from error
    return sorted(copied)


def copy_ffmpeg_licenses(app, ffmpeg_prefix):
    record = load_ffmpeg_record(ffmpeg_prefix)
    source = Path(ffmpeg_prefix) / FFMPEG_PREFIX_LICENSE_SUBDIR
    target = Path(app) / FFMPEG_LICENSE_SUBDIR
    target.mkdir(parents=True, exist_ok=True)
    for entry in sorted(source.iterdir()):
        if entry.is_file():
            shutil.copyfile(entry, target / entry.name)
    return record


def bundle_command(args):
    app = Path(args.app)
    copied = bundle_dependencies(app, args.ffmpeg_prefix)
    copy_ffmpeg_licenses(app, args.ffmpeg_prefix)
    print("bundled %d librar%s: %s" % (len(copied), "y" if len(copied) == 1 else "ies", ", ".join(copied)))
    return 0


# --------------------------------------------------------------------------------------------
# verify
# --------------------------------------------------------------------------------------------

def hash_game_directory(game_dir):
    hashes = {EXPECTED_GAME_EXE_SHA256: "GAME.EXE"}
    if game_dir:
        for root, _dirs, files in os.walk(game_dir):
            for name in files:
                path = Path(root) / name
                try:
                    if path.stat().st_size >= 16:
                        hashes[sha256_file(path)] = str(path.relative_to(game_dir))
                except OSError:
                    continue
    return hashes


def layout_violations(app, executable, resource_suffixes):
    problems = []
    app = Path(app)
    real_app = os.path.realpath(app)
    for root, dirs, files in os.walk(app):
        for name in dirs + files:
            path = Path(root) / name
            if path.is_symlink():
                target = os.path.realpath(path)
                if not (target == real_app or target.startswith(real_app + os.sep)):
                    problems.append("symlink leaves the bundle: %s" % path.relative_to(app))
        for name in files:
            path = Path(root) / name
            relative = path.relative_to(app)
            posix = relative.as_posix()
            lower = name.lower()
            if FORBIDDEN_NAME_RE.search(name):
                problems.append("forbidden file name: %s" % posix)
                continue
            if posix.startswith("Contents/Resources/licenses/"):
                if lower.endswith(FORBIDDEN_SUFFIXES) or is_macho(path):
                    problems.append("non-text file among licences: %s" % posix)
                continue
            if posix.startswith("Contents/_CodeSignature/") or posix == "Contents/CodeResources":
                continue
            if lower.endswith(FORBIDDEN_SUFFIXES) and not is_macho(path):
                problems.append("forbidden file type: %s" % posix)
                continue
            if path == executable:
                continue
            if posix.startswith("Contents/Frameworks/"):
                if not BUNDLED_LIB_RE.match(name) or "/" in posix[len("Contents/Frameworks/"):]:
                    problems.append("unexpected library: %s" % posix)
                continue
            if posix in ("Contents/Info.plist", "Contents/PkgInfo"):
                continue
            if posix.startswith("Contents/Resources/") and lower.endswith(resource_suffixes):
                continue
            problems.append("file outside the allowed bundle layout: %s" % posix)
    return problems


def forbidden_content_violations(app, game_hashes):
    problems = []
    for root, _dirs, files in os.walk(app):
        for name in files:
            path = Path(root) / name
            if path.is_symlink() or not path.is_file():
                continue
            try:
                with open(path, "rb") as handle:
                    head = handle.read(2)
            except OSError:
                continue
            relative = path.relative_to(app).as_posix()
            if head == b"MZ":
                problems.append("Windows executable header in %s" % relative)
            digest = sha256_file(path)
            if digest in game_hashes:
                problems.append("%s is byte-identical to game file %s" % (relative, game_hashes[digest]))
    return problems


def macho_violations(path, app, executable, executable_info, min_os):
    problems = []
    relative = Path(path).relative_to(app).as_posix()
    try:
        archs = lipo_archs(path)
    except BundleError as error:
        return ["%s: %s" % (relative, error)]
    if archs != ["arm64"]:
        problems.append("%s is not thin arm64: %s" % (relative, archs))
    info = executable_info if path == executable else read_macho(path)
    if info.minos is None:
        problems.append("%s has no minimum macOS" % relative)
    elif info.minos > min_os:
        problems.append("%s requires macOS %s, above the %s floor" % (relative, ".".join(map(str, info.minos)), ".".join(map(str, min_os))))
    for rpath in info.rpaths:
        if rpath not in ALLOWED_RPATHS:
            problems.append("%s has disallowed rpath %s" % (relative, rpath))
    if path != executable:
        if info.dylib_id != "@rpath/" + Path(path).name:
            problems.append("%s has install name %s" % (relative, info.dylib_id))
    search = list(info.rpaths) + [item for item in executable_info.rpaths if item not in info.rpaths]
    app_real = os.path.realpath(app)
    for _cmd, name in info.deps:
        if is_system_path(name):
            continue
        if name.startswith("/"):
            problems.append("%s loads non-system absolute path %s" % (relative, name))
            continue
        if not name.startswith(("@rpath/", "@executable_path/", "@loader_path/")):
            problems.append("%s has unrecognised dependency %s" % (relative, name))
            continue
        resolved = resolve_dependency(name, path, executable, search, [])
        if resolved is None:
            problems.append("%s: dependency %s does not resolve inside the bundle" % (relative, name))
            continue
        real = os.path.realpath(resolved)
        if not real.startswith(app_real + os.sep):
            problems.append("%s: dependency %s resolves outside the bundle" % (relative, name))
    return problems


def verify_bundle(app, min_macos, game_dir=None, resource_suffixes=DEFAULT_RESOURCE_SUFFIXES,
                  check_runtime=True, require_licenses=True):
    app = Path(app)
    if not app.is_dir() or app.suffix != ".app":
        return ["not an app bundle: %s" % app]
    problems = []
    min_os = version_tuple(min_macos)
    try:
        plist, executable = read_app_executable(app)
    except BundleError as error:
        return [str(error)]
    problems += icon_violations(app, plist)
    declared = plist.get("LSMinimumSystemVersion")
    if declared is None or version_tuple(declared) != min_os:
        problems.append("Info.plist LSMinimumSystemVersion is %r, expected %s" % (declared, min_macos))
    problems += layout_violations(app, executable, tuple(resource_suffixes))
    problems += forbidden_content_violations(app, hash_game_directory(game_dir))
    executable_info = read_macho(executable)
    machos = []
    for root, _dirs, files in os.walk(app):
        for name in sorted(files):
            path = Path(root) / name
            if path.is_file() and not path.is_symlink() and is_macho(path):
                machos.append(path)
    if executable not in machos:
        problems.append("main executable is not a Mach-O file")
    for path in machos:
        problems += macho_violations(path, app, executable, executable_info, min_os)
    frameworks = app / "Contents/Frameworks"
    if require_licenses:
        license_dir = app / FFMPEG_LICENSE_SUBDIR
        for name in FFMPEG_LICENSE_FILES + ("BUILD-INFO.json", "SOURCE-AVAILABILITY.txt"):
            if not (license_dir / name).is_file():
                problems.append("missing licence record %s" % (FFMPEG_LICENSE_SUBDIR / name).as_posix())
        record_path = license_dir / "BUILD-INFO.json"
        if record_path.is_file():
            try:
                with open(record_path, "r", encoding="utf-8") as handle:
                    record = json.load(handle)
                for key in ("version", "source_url", "source_sha256", "configure_command"):
                    if not record.get(key):
                        problems.append("BUILD-INFO.json lacks %s" % key)
                for flag in FORBIDDEN_CONFIGURE_FLAGS:
                    if flag in record.get("configure_command", ""):
                        problems.append("BUILD-INFO.json shows %s" % flag)
            except ValueError:
                problems.append("BUILD-INFO.json is not valid JSON")
        if frameworks.is_dir() and check_runtime:
            checker = run([sys.executable, "-I", str(Path(__file__).resolve()), "ffmpeg-check",
                           "--lib-dir", str(frameworks), "--min-macos", min_macos], check=False)
            if checker.returncode != 0:
                for line in checker.stderr.splitlines():
                    problems.append("bundled FFmpeg: " + line)
                if not checker.stderr.strip():
                    problems.append("bundled FFmpeg check failed")
    return problems


def verify_command(args):
    problems = verify_bundle(
        args.app, args.min_macos, game_dir=args.game_dir,
        resource_suffixes=tuple(DEFAULT_RESOURCE_SUFFIXES) + tuple(args.allow_resource_suffix),
        check_runtime=not args.skip_ffmpeg_runtime_check,
        require_licenses=not args.skip_licenses)
    if problems:
        for problem in problems:
            print("VERIFY FAIL: " + problem, file=sys.stderr)
        return 1
    print("VERIFY OK: %s" % args.app)
    return 0


# --------------------------------------------------------------------------------------------
# signing, notarisation, DMG
# --------------------------------------------------------------------------------------------

def signing_files(app):
    """Nested code in sign-inside-out order: libraries, then the main executable."""
    app = Path(app)
    _plist, executable = read_app_executable(app)
    libraries = []
    for root, _dirs, files in os.walk(app / "Contents/Frameworks"):
        for name in sorted(files):
            path = Path(root) / name
            if is_macho(path):
                libraries.append(path)
    return libraries + [executable]


def codesign_command(identity, hardened):
    command = ["codesign", "--force", "--sign", identity]
    if identity == "-":
        command += ["--timestamp=none"]
    else:
        command += ["--timestamp"]
    if hardened:
        command += ["--options", "runtime"]
    return command


def sign_app(app, identity, hardened):
    for path in signing_files(app):
        run(codesign_command(identity, hardened) + [str(path)])
    run(codesign_command(identity, hardened) + [str(app)])
    run(["codesign", "--verify", "--deep", "--strict", "--verbose=2", str(app)])
    if identity != "-":
        teams = set()
        for path in signing_files(app) + [Path(app)]:
            details = run(["codesign", "--display", "--verbose=4", str(path)])
            text = details.stdout + details.stderr
            team = re.search(r"(?m)^TeamIdentifier=([A-Z0-9]{10})$", text)
            if not team or "Authority=Developer ID Application:" not in text or not re.search(r"flags=0x[0-9a-fA-F]+\([^)]*\bruntime\b", text):
                raise BundleError("Developer ID signature lacks its team, authority or hardened runtime: " + str(path))
            teams.add(team.group(1))
        if len(teams) != 1:
            raise BundleError("nested signatures do not share the app's Developer ID team")


def submit_for_notarisation(artifact, profile, log_path):
    result = run(["xcrun", "notarytool", "submit", str(artifact), "--keychain-profile", profile,
                  "--wait", "--timeout", "90m", "--output-format", "json"], check=False)
    try:
        outcome = json.loads(result.stdout)
    except ValueError:
        outcome = {}
    status = outcome.get("status")
    if result.returncode != 0 or status != "Accepted":
        identifier = outcome.get("id")
        if identifier:
            run(["xcrun", "notarytool", "log", identifier, "--keychain-profile", profile, str(log_path)], check=False)
        raise BundleError("notarisation of %s ended with status %r (log: %s)" % (Path(artifact).name, status, log_path))
    print("notarytool: Accepted (%s)" % Path(artifact).name)
    return outcome


def sign_identity_available(identity):
    result = run(["security", "find-identity", "-v", "-p", "codesigning"], check=False)
    if result.returncode:
        return False
    for digest, name in re.findall(r'^\s*\d+\)\s+([0-9A-Fa-f]{40})\s+"(Developer ID Application:[^"\n]+)"\s*$', result.stdout, re.MULTILINE):
        if identity == name or identity.upper() == digest.upper():
            return True
    return False


def make_readme(adhoc, notarised, min_macos):
    lines = [
        "Blackmoor Recompiled",
        "====================",
        "",
        "This private Apple-silicon build contains game code rebuilt from the owner's GAME.EXE.",
        "Game data and GAME.EXE stay separate from this app. Use your GOG installation or the game-files folder",
        "from your private transfer package. The app checks known locations or asks you to choose it; your choice is",
        "remembered, the folder is only read, and your saves go to",
        "~/Library/Application Support (never into the game folder).",
        "",
        "Install: drag \"Blackmoor Recompiled\" onto the Applications shortcut.",
        "Requires macOS %s or later on an Apple-silicon Mac." % min_macos,
        "Keep the app and DMG on Glib's Macs or with testers he names; do not upload them publicly.",
        "Public distribution remains a separate question for Glib.",
        "",
    ]
    if adhoc:
        lines += [
            "THIS BUILD IS NOT NOTARISED. It is signed ad hoc, not with a Developer ID, so macOS",
            "will warn on first launch. Open System Settings > Privacy & Security and choose",
            "\"Open Anyway\" after the first blocked launch, if you trust this local development build.",
            "",
        ]
    elif not notarised:
        lines += ["This build is Developer-ID signed but was not notarised.", ""]
    lines += [
        "Third-party notices (FFmpeg, LGPL) are inside the app:",
        "  Blackmoor Recompiled.app/Contents/Resources/licenses/FFmpeg/",
        "",
    ]
    return "\n".join(lines)


def attach_and_verify_dmg(dmg, min_macos, game_dir):
    """Mount the DMG read-only without a window, verify its app, always detach."""
    attach = run(["hdiutil", "attach", "-readonly", "-nobrowse", "-noautoopen", "-noverify", "-plist", str(dmg)])
    mount_point = None
    for entity in plistlib.loads(attach.stdout.encode()).get("system-entities", []):
        if entity.get("mount-point"):
            mount_point = entity["mount-point"]
    if mount_point is None:
        raise BundleError("the DMG did not mount")
    try:
        mounted = Path(mount_point)
        app = mounted / "Blackmoor Recompiled.app"
        problems = verify_bundle(app, min_macos, game_dir=game_dir)
        link = mounted / "Applications"
        if not (link.is_symlink() and os.readlink(link) == "/Applications"):
            problems.append("DMG lacks the Applications link")
        if not (mounted / "README.txt").is_file():
            problems.append("DMG lacks README.txt")
        run(["codesign", "--verify", "--deep", "--strict", str(app)])
        return problems
    finally:
        run(["hdiutil", "detach", mount_point], check=False)


def package_command(args):
    staged = Path(args.app)
    out_dir = Path(args.out_dir)
    if not out_dir.is_dir():
        raise BundleError("output directory must exist: %s" % out_dir)
    if any(out_dir.iterdir()):
        raise BundleError("output directory is not empty: %s" % out_dir)
    identity = os.environ.get("BLACKMOOR_SIGN_IDENTITY", "")
    profile = os.environ.get("BLACKMOOR_NOTARY_PROFILE", "")
    adhoc = identity == ""
    if adhoc and profile:
        raise BundleError("BLACKMOOR_NOTARY_PROFILE is set without BLACKMOOR_SIGN_IDENTITY; notarisation needs a Developer ID")
    if not adhoc and not sign_identity_available(identity):
        raise BundleError("BLACKMOOR_SIGN_IDENTITY is set but no matching code-signing identity is in the keychain")
    notarise = bool(profile)
    sign_with = "-" if adhoc else identity
    hardened = {"always": True, "never": False}.get(args.hardened_runtime, not adhoc)
    if not adhoc and not hardened:
        raise BundleError("Developer ID packaging requires hardened runtime")
    if adhoc and hardened:
        # Verified: with library validation an ad-hoc app cannot load its own ad-hoc bundled
        # dylibs ("mapping process and mapped file have different Team IDs").
        raise BundleError("the hardened runtime needs a Developer ID: an ad-hoc signed app cannot load its bundled libraries under it")
    mode = "adhoc" if adhoc else ("developer-id-notarized" if notarise else "developer-id-unnotarized")

    app_dir = out_dir / "app"
    app_dir.mkdir()
    app = app_dir / "Blackmoor Recompiled.app"
    run(["ditto", "--noextattr", "--norsrc", str(staged), str(app)])

    bundled = bundle_dependencies(app, args.ffmpeg_prefix)
    copy_ffmpeg_licenses(app, args.ffmpeg_prefix)
    problems = verify_bundle(app, args.min_macos, game_dir=args.game_dir)
    if problems:
        raise BundleError("bundle rejected before signing:\n  " + "\n  ".join(problems))
    sign_app(app, sign_with, hardened)

    if notarise:
        archive = out_dir / "notarize-app.zip"
        run(["ditto", "-c", "-k", "--keepParent", str(app), str(archive)])
        submit_for_notarisation(archive, profile, out_dir / "notary-log-app.json")
        run(["xcrun", "stapler", "staple", str(app)])
        run(["xcrun", "stapler", "validate", str(app)])

    version = str(read_app_executable(app)[0].get("CFBundleVersion", "0"))
    label = {"adhoc": "ADHOC-UNNOTARIZED", "developer-id-unnotarized": "signed-UNNOTARIZED",
             "developer-id-notarized": "notarized"}[mode]
    dmg = out_dir / ("Blackmoor-Recompiled-%s-arm64-%s.dmg" % (version, label))
    dmg_root = out_dir / "dmg-root"
    dmg_root.mkdir()
    run(["ditto", "--noextattr", "--norsrc", str(app), str(dmg_root / "Blackmoor Recompiled.app")])
    os.symlink("/Applications", dmg_root / "Applications")
    with open(dmg_root / "README.txt", "w", encoding="utf-8") as handle:
        handle.write(make_readme(adhoc, notarise, args.min_macos))
    run(["hdiutil", "create", "-volname", "Blackmoor Recompiled", "-srcfolder", str(dmg_root),
         "-fs", "HFS+", "-format", "UDZO", str(dmg)])
    if not adhoc:
        run(["codesign", "--force", "--sign", sign_with, "--timestamp", str(dmg)])
    if notarise:
        submit_for_notarisation(dmg, profile, out_dir / "notary-log-dmg.json")
        run(["xcrun", "stapler", "staple", str(dmg)])
        run(["xcrun", "stapler", "validate", str(dmg)])
    run(["hdiutil", "verify", str(dmg)])

    mounted_problems = attach_and_verify_dmg(dmg, args.min_macos, args.game_dir)
    if mounted_problems:
        raise BundleError("the finished DMG failed verification:\n  " + "\n  ".join(mounted_problems))

    app_assess = run(["spctl", "--assess", "--type", "execute", "--verbose=2", str(app)], check=False)
    dmg_assess = run(["spctl", "--assess", "--type", "open", "--context", "context:primary-signature",
                      "--verbose=2", str(dmg)], check=False)
    if notarise:
        for what, assessed in (("app", app_assess), ("DMG", dmg_assess)):
            if assessed.returncode != 0:
                raise BundleError("Gatekeeper (spctl) rejected the %s: %s" % (what, (assessed.stderr or "").strip()))
    digest = sha256_file(dmg)
    size = dmg.stat().st_size
    files = {}
    for root, _dirs, names in os.walk(app):
        for name in sorted(names):
            path = Path(root) / name
            if path.is_file() and not path.is_symlink():
                files[path.relative_to(app).as_posix()] = sha256_file(path)
    manifest = {
        "dmg": dmg.name, "dmg_sha256": digest, "dmg_bytes": size, "signing_mode": mode,
        "hardened_runtime": hardened, "notarized": notarise, "minimum_macos": args.min_macos,
        "source_commit": read_app_executable(app)[0].get("BlackmoorSourceCommit"),
        "bundled_libraries": bundled,
        "gatekeeper_app_accepted": app_assess.returncode == 0,
        "gatekeeper_dmg_accepted": dmg_assess.returncode == 0,
        "app_files_sha256": files,
        "ffmpeg": load_ffmpeg_record(args.ffmpeg_prefix),
    }
    with open(out_dir / "package-manifest.json", "w", encoding="utf-8") as handle:
        json.dump(manifest, handle, indent=2, sort_keys=True)
        handle.write("\n")
    banner = {
        "adhoc": "AD-HOC SIGNED, NOT NOTARIZED (Gatekeeper will warn; this is not a trust success)",
        "developer-id-unnotarized": "DEVELOPER-ID SIGNED, NOT NOTARIZED",
        "developer-id-notarized": "NOTARIZED AND STAPLED",
    }[mode]
    print("package: %s" % banner)
    print("DMG: %s" % dmg)
    print("SHA256: %s" % digest)
    print("bytes: %d" % size)
    return 0


# --------------------------------------------------------------------------------------------

def build_parser():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="command", required=True)

    record = sub.add_parser("ffmpeg-record")
    record.add_argument("--prefix", required=True)
    record.add_argument("--source", required=True)
    record.add_argument("--version", required=True)
    record.add_argument("--url", required=True)
    record.add_argument("--sha256", required=True)
    record.add_argument("--configure", required=True)
    record.add_argument("--min-macos", default=DEFAULT_MIN_MACOS)
    record.add_argument("--compiler", default="unknown")
    record.add_argument("--sdk", default="unknown")
    record.add_argument("--build-fingerprint", default="")
    record.set_defaults(func=ffmpeg_record)

    stamp = sub.add_parser("ffmpeg-stamp-matches")
    stamp.add_argument("--prefix", required=True)
    stamp.add_argument("--sha256", required=True)
    stamp.add_argument("--configure", required=True)
    stamp.add_argument("--build-fingerprint", default="")
    stamp.set_defaults(func=ffmpeg_stamp_matches)

    check = sub.add_parser("ffmpeg-check")
    check.add_argument("--prefix")
    check.add_argument("--lib-dir")
    check.add_argument("--min-macos", default=DEFAULT_MIN_MACOS)
    check.set_defaults(func=ffmpeg_check)

    bundle = sub.add_parser("bundle")
    bundle.add_argument("--app", required=True)
    bundle.add_argument("--ffmpeg-prefix", required=True)
    bundle.set_defaults(func=bundle_command)

    verify = sub.add_parser("verify")
    verify.add_argument("--app", required=True)
    verify.add_argument("--min-macos", default=DEFAULT_MIN_MACOS)
    verify.add_argument("--game-dir")
    verify.add_argument("--allow-resource-suffix", action="append", default=[])
    verify.add_argument("--skip-ffmpeg-runtime-check", action="store_true")
    verify.add_argument("--skip-licenses", action="store_true")
    verify.set_defaults(func=verify_command)

    package = sub.add_parser("package")
    package.add_argument("--app", required=True, help="staged app produced by recomp/build_macos.sh")
    package.add_argument("--out-dir", required=True, help="existing empty directory for this run")
    package.add_argument("--ffmpeg-prefix", required=True)
    package.add_argument("--min-macos", default=DEFAULT_MIN_MACOS)
    package.add_argument("--game-dir", help="a game folder whose files must not appear in the bundle")
    package.add_argument("--hardened-runtime", choices=("auto", "always", "never"), default="auto")
    package.set_defaults(func=package_command)
    return parser


def main(argv=None):
    args = build_parser().parse_args(argv)
    if args.command == "ffmpeg-check" and not (args.prefix or args.lib_dir):
        print("ffmpeg-check needs --prefix or --lib-dir", file=sys.stderr)
        return 2
    try:
        return args.func(args)
    except BundleError as error:
        print("macos_bundle.py: %s" % error, file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
