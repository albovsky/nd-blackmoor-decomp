#!/usr/bin/env python3
"""Packaging checks for the private ARM64 macOS bundle (RECOMP-49).

The bundle tool is exercised on a tiny synthetic app built with clang (a main executable, two
dylibs, a fake licence record) so every accept and every reject path is covered without GAME.EXE, the
lifted C or a network. The real minimal-FFmpeg checks run only when script/build_ffmpeg_macos.sh has
produced a prefix (BLACKMOOR_FFMPEG_PREFIX or work/ffmpeg-macos/prefix-*).
"""

from __future__ import annotations

import importlib.util
import json
import os
import pathlib
import plistlib
import re
import shutil
import subprocess
import sys
import tempfile
import unittest

PROJECT = pathlib.Path(__file__).resolve().parents[1]
REPOSITORY = PROJECT.parents[1]
SCRIPTS = REPOSITORY / "script"
SPEC = importlib.util.spec_from_file_location("macos_bundle", SCRIPTS / "macos_bundle.py")
bundle = importlib.util.module_from_spec(SPEC)
sys.modules["macos_bundle"] = bundle
SPEC.loader.exec_module(bundle)

CLANG = ["xcrun", "--sdk", "macosx", "clang", "-arch", "arm64"]
HAVE_TOOLCHAIN = sys.platform == "darwin" and shutil.which("xcrun") is not None


def real_ffmpeg_prefix() -> pathlib.Path | None:
    given = os.environ.get("BLACKMOOR_FFMPEG_PREFIX")
    if given:
        return pathlib.Path(given)
    base = REPOSITORY / "work" / "ffmpeg-macos"
    found = sorted(base.glob("prefix-*-macos11.0")) if base.is_dir() else []
    return found[-1] if found else None


def run(command, **kwargs):
    return subprocess.run([str(item) for item in command], check=True, capture_output=True, text=True, **kwargs)


class ShellScriptPolicyTests(unittest.TestCase):
    """The two shell entry points obey the packet's shell rules and refuse a wrong original first."""

    SCRIPT_NAMES = ("package_macos.sh", "build_ffmpeg_macos.sh")

    def executable_lines(self, name):
        lines = []
        for raw in (SCRIPTS / name).read_text().splitlines():
            stripped = raw.strip()
            if stripped and not stripped.startswith("#"):
                lines.append(stripped)
        return lines

    def test_no_chains_pipelines_or_deletion(self):
        for name in self.SCRIPT_NAMES:
            for line in self.executable_lines(name):
                code = re.sub(r"'[^']*'|\"[^\"]*\"", "''", line)
                self.assertNotIn("&&", code, (name, line))
                self.assertNotIn("||", code, (name, line))
                self.assertIsNone(re.search(r"(?<![|\\])\|(?!\|)", code), (name, line))
                self.assertIsNone(re.search(r"(^|\s)(rm|rmdir|unlink|sudo|trash)(\s|$)", code), (name, line))
                self.assertIsNone(re.search(r"^\w+=\S*\s+\w+=", code), (name, "two assignments on one line", line))

    def test_scripts_are_executable_and_parse(self):
        for name in self.SCRIPT_NAMES:
            path = SCRIPTS / name
            self.assertTrue(os.access(path, os.X_OK), name)
            subprocess.run(["bash", "-n", str(path)], check=True)

    def test_wrong_or_missing_original_stops_before_any_build(self):
        with tempfile.TemporaryDirectory() as scratch:
            out = pathlib.Path(scratch) / "out"
            wrong = pathlib.Path(scratch) / "GAME.EXE"
            wrong.write_bytes(b"not the original")
            environment = dict(os.environ, GAME_EXE=str(wrong), BLACKMOOR_PACKAGE_OUT=str(out))
            result = subprocess.run([str(SCRIPTS / "package_macos.sh")], env=environment, capture_output=True, text=True)
            self.assertEqual(result.returncode, 2)
            self.assertIn("not the owned original", result.stderr)
            self.assertFalse(out.exists(), "an output directory was created before the hash was validated")
            environment["GAME_EXE"] = str(pathlib.Path(scratch) / "absent.exe")
            result = subprocess.run([str(SCRIPTS / "package_macos.sh")], env=environment, capture_output=True, text=True)
            self.assertEqual(result.returncode, 2)
            self.assertIn("GAME_EXE not found", result.stderr)
            self.assertFalse(out.exists())

    def test_expected_hash_matches_the_project_pin(self):
        self.assertIn(bundle.EXPECTED_GAME_EXE_SHA256, (SCRIPTS / "package_macos.sh").read_text())
        self.assertEqual(bundle.EXPECTED_GAME_EXE_SHA256,
                         "afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45")


@unittest.skipUnless(HAVE_TOOLCHAIN, "needs the macOS toolchain")
class SyntheticBundleTests(unittest.TestCase):
    """bundle + verify on a synthetic app: one accept path, one test per reject rule."""

    def setUp(self):
        self._scratch = tempfile.TemporaryDirectory()
        self.root = pathlib.Path(self._scratch.name)
        self.addCleanup(self._scratch.cleanup)
        self.prefix = self.root / "prefix"
        self.lib = self.prefix / "lib"
        self.lib.mkdir(parents=True)
        self.install_licence_record(self.prefix)

    def compile(self, source, output, *flags, minos="11.0"):
        source_path = self.root / (output.name + ".c")
        source_path.write_text(source)
        run(CLANG + ["-mmacosx-version-min=" + minos, "-Wl,-headerpad_max_install_names", str(source_path), "-o", str(output)] + list(flags))

    def install_licence_record(self, prefix):
        target = prefix / bundle.FFMPEG_PREFIX_LICENSE_SUBDIR
        target.mkdir(parents=True)
        for name in bundle.FFMPEG_LICENSE_FILES + ("SOURCE-AVAILABILITY.txt",):
            (target / name).write_text("licence text " + name + "\n")
        record = {"product": "FFmpeg", "version": "0.0-test", "license": "LGPL-2.1-or-later",
                  "source_url": "https://example.invalid/ffmpeg.tar.xz", "source_sha256": "0" * 64,
                  "configure_command": "configure --enable-shared --disable-static"}
        (target / "BUILD-INFO.json").write_text(json.dumps(record))

    def make_libraries(self, minos="11.0"):
        util = self.lib / "libavutil.99.dylib"
        self.compile("int au_value(void) { return 40; }\n", util, "-dynamiclib", "-install_name", str(util), minos=minos)
        scale = self.lib / "libswscale.99.dylib"
        self.compile("int au_value(void);\nint sw_value(void) { return au_value() + 2; }\n", scale,
                     "-dynamiclib", "-install_name", str(scale), "-L" + str(self.lib), "-lavutil.99", minos=minos)

    def make_app(self, minos="11.0", plist_min="11.0"):
        self.make_libraries(minos=minos)
        app = self.root / "stage" / "Blackmoor Recompiled.app"
        (app / "Contents/MacOS").mkdir(parents=True)
        executable = app / "Contents/MacOS/BlackmoorRecompiled"
        self.compile("#include <stdio.h>\nint sw_value(void);\nint main(void) { printf(\"value=%d\\n\", sw_value()); return 0; }\n",
                     executable, "-L" + str(self.lib), "-lswscale.99", "-Wl,-rpath," + str(self.lib), minos=minos)
        with open(app / "Contents/Info.plist", "wb") as handle:
            plistlib.dump({"CFBundleExecutable": "BlackmoorRecompiled", "CFBundleName": "Blackmoor Recompiled",
                           "CFBundleIdentifier": "test.blackmoor", "CFBundleVersion": "0.1",
                           "LSMinimumSystemVersion": plist_min}, handle)
        return app

    def bundled_app(self, **kwargs):
        app = self.make_app(**kwargs)
        bundle.bundle_dependencies(app, self.prefix)
        bundle.copy_ffmpeg_licenses(app, self.prefix)
        return app

    def problems(self, app, **kwargs):
        return bundle.verify_bundle(app, "11.0", check_runtime=False, **kwargs)

    def assertRejected(self, app, fragment, **kwargs):
        problems = self.problems(app, **kwargs)
        self.assertTrue(any(fragment in item for item in problems), (fragment, problems))

    # ---- accept path
    def test_bundle_is_self_contained_and_runs_without_the_build_prefix(self):
        app = self.bundled_app()
        self.assertEqual(self.problems(app), [])
        info = bundle.read_macho(app / "Contents/MacOS/BlackmoorRecompiled")
        self.assertEqual(info.rpaths, ["@executable_path/../Frameworks"])
        self.assertEqual(sorted(path.name for path in (app / "Contents/Frameworks").iterdir()),
                         ["libavutil.99.dylib", "libswscale.99.dylib"])
        os.rename(self.prefix, self.root / "prefix-moved-away")
        completed = run([app / "Contents/MacOS/BlackmoorRecompiled"])
        self.assertEqual(completed.stdout.strip(), "value=42")

    def test_every_bundled_macho_has_only_system_or_bundled_paths(self):
        app = self.bundled_app()
        for path in [app / "Contents/MacOS/BlackmoorRecompiled"] + sorted((app / "Contents/Frameworks").iterdir()):
            info = bundle.read_macho(path)
            for _cmd, name in info.deps:
                self.assertTrue(bundle.is_system_path(name) or name.startswith("@rpath/"), (path.name, name))
            self.assertTrue(set(info.rpaths) <= set(bundle.ALLOWED_RPATHS), (path.name, info.rpaths))
            self.assertLessEqual(info.minos, (11, 0, 0))

    def test_signing_inside_out_with_ad_hoc_identity_verifies(self):
        app = self.bundled_app()
        bundle.sign_app(app, "-", hardened=False)
        run(["codesign", "--verify", "--deep", "--strict", app])
        order = [path.name for path in bundle.signing_files(app)]
        self.assertEqual(order[-1], "BlackmoorRecompiled")
        self.assertEqual(order[:-1], ["libavutil.99.dylib", "libswscale.99.dylib"])

    # ---- reject paths
    def test_ffmpeg_libraries_come_only_from_the_verified_prefix_not_a_decoy_rpath(self):
        decoy = self.root / "decoy"
        decoy.mkdir()
        for directory, value in ((decoy, 1), (self.lib, 40)):
            source = self.root / ("util%d.c" % value)
            source.write_text("int au_value(void) { return %d; }\n" % value)
            run(CLANG + ["-mmacosx-version-min=11.0", "-dynamiclib", "-install_name", "@rpath/libavutil.99.dylib",
                         str(source), "-o", str(directory / "libavutil.99.dylib")])
        main = self.root / "main.c"
        main.write_text("int au_value(void);\nint main(void) { return au_value(); }\n")
        app = self.root / "stage" / "Blackmoor Recompiled.app"
        (app / "Contents/MacOS").mkdir(parents=True)
        run(CLANG + ["-mmacosx-version-min=11.0", "-Wl,-headerpad_max_install_names", str(main),
                     "-o", str(app / "Contents/MacOS/BlackmoorRecompiled"), "-L" + str(self.lib), "-lavutil.99",
                     "-Wl,-rpath," + str(decoy), "-Wl,-rpath," + str(self.lib)])
        with open(app / "Contents/Info.plist", "wb") as handle:
            plistlib.dump({"CFBundleExecutable": "BlackmoorRecompiled", "LSMinimumSystemVersion": "11.0"}, handle)
        bundle.bundle_dependencies(app, self.prefix)
        # the executable returns au_value(): 40 from the prefix copy, 1 from the decoy
        ran = subprocess.run([str(app / "Contents/MacOS/BlackmoorRecompiled")], capture_output=True)
        self.assertEqual(ran.returncode, 40)

    def test_unbundled_dependency_is_rejected(self):
        app = self.make_app()
        os.rename(self.lib / "libavutil.99.dylib", self.root / "hidden-libavutil.99.dylib")
        with self.assertRaises(bundle.BundleError) as caught:
            bundle.bundle_dependencies(app, self.prefix)
        self.assertIn("unbundled dependency", str(caught.exception))

    def test_homebrew_rpath_is_rejected(self):
        app = self.bundled_app()
        run(["install_name_tool", "-add_rpath", "/opt/homebrew/lib", app / "Contents/MacOS/BlackmoorRecompiled"])
        self.assertRejected(app, "disallowed rpath /opt/homebrew/lib")

    def test_absolute_non_system_dependency_is_rejected(self):
        app = self.bundled_app()
        run(["install_name_tool", "-change", "@rpath/libswscale.99.dylib", "/usr/local/lib/libswscale.99.dylib",
             app / "Contents/MacOS/BlackmoorRecompiled"])
        self.assertRejected(app, "non-system absolute path /usr/local/lib/libswscale.99.dylib")

    def test_dependency_that_resolves_nowhere_in_the_bundle_is_rejected(self):
        app = self.bundled_app()
        run(["install_name_tool", "-change", "@rpath/libavutil.99.dylib", "@rpath/libmissing.99.dylib",
             app / "Contents/Frameworks/libswscale.99.dylib"])
        self.assertRejected(app, "does not resolve inside the bundle")

    def test_binary_newer_than_the_floor_is_rejected(self):
        app = self.bundled_app(minos="14.0")
        self.assertRejected(app, "requires macOS 14.0.0, above the 11.0.0 floor")

    def test_info_plist_floor_must_match(self):
        app = self.bundled_app(plist_min="27.0")
        self.assertRejected(app, "LSMinimumSystemVersion is '27.0', expected 11.0")

    def add_resource(self, app, name, data):
        resources = app / "Contents/Resources"
        resources.mkdir(exist_ok=True)
        (resources / name).write_bytes(data)

    def test_game_executable_is_rejected(self):
        app = self.bundled_app()
        self.add_resource(app, "GAME.EXE", b"MZ" + bytes(64))
        self.assertRejected(app, "forbidden file name: Contents/Resources/GAME.EXE")
        self.assertRejected(app, "Windows executable header in Contents/Resources/GAME.EXE")

    def test_lifted_c_is_rejected(self):
        app = self.bundled_app()
        self.add_resource(app, "rc_lifted_0001.c", b"int x;\n")
        self.assertRejected(app, "forbidden file name: Contents/Resources/rc_lifted_0001.c")

    def test_unlisted_resource_payload_is_rejected(self):
        app = self.bundled_app()
        self.add_resource(app, "level.bin", b"\x01\x02\x03")
        self.assertRejected(app, "file outside the allowed bundle layout: Contents/Resources/level.bin")

    def test_harmless_icon_resource_passes(self):
        app = self.bundled_app()
        self.add_resource(app, "AppIcon.icns", b"icns" + bytes(32))
        self.assertEqual(self.problems(app), [])

    def test_byte_identical_game_file_is_rejected_even_when_renamed(self):
        app = self.bundled_app()
        game = self.root / "game"
        game.mkdir()
        (game / "DATA.VOL").write_bytes(bytes(range(256)) * 4)
        self.add_resource(app, "icon.png", bytes(range(256)) * 4)
        self.assertRejected(app, "byte-identical to game file DATA.VOL", game_dir=str(game))
        self.assertEqual(self.problems(app), [], "without --game-dir the same icon passes")

    def test_pe_header_is_rejected_whatever_the_name(self):
        app = self.bundled_app()
        self.add_resource(app, "logo.png", b"MZ\x90\x00" + bytes(100))
        self.assertRejected(app, "Windows executable header in Contents/Resources/logo.png")

    def test_unexpected_library_is_rejected(self):
        app = self.bundled_app()
        extra = app / "Contents/Frameworks/libthirdparty.1.dylib"
        self.compile("int tp(void) { return 1; }\n", extra, "-dynamiclib", "-install_name", "@rpath/libthirdparty.1.dylib")
        self.assertRejected(app, "unexpected library: Contents/Frameworks/libthirdparty.1.dylib")

    def test_missing_licence_record_is_rejected(self):
        app = self.make_app()
        bundle.bundle_dependencies(app, self.prefix)
        self.assertRejected(app, "missing licence record Contents/Resources/Licenses/FFmpeg/COPYING.LGPLv2.1")

    def test_gpl_build_record_is_rejected(self):
        app = self.bundled_app()
        path = app / bundle.FFMPEG_LICENSE_SUBDIR / "BUILD-INFO.json"
        record = json.loads(path.read_text())
        record["configure_command"] += " --enable-gpl"
        path.write_text(json.dumps(record))
        self.assertRejected(app, "BUILD-INFO.json shows --enable-gpl")

    def test_prefix_without_the_lgpl_record_cannot_be_bundled(self):
        app = self.make_app()
        with tempfile.TemporaryDirectory() as bare:
            with self.assertRaises(bundle.BundleError) as caught:
                bundle.copy_ffmpeg_licenses(app, bare)
        self.assertIn("not a Blackmoor LGPL FFmpeg build", str(caught.exception))

    def test_homebrew_ffmpeg_prefix_is_not_accepted(self):
        homebrew = pathlib.Path("/opt/homebrew")
        if not (homebrew / "lib").is_dir():
            self.skipTest("no Homebrew prefix on this machine")
        with self.assertRaises(bundle.BundleError):
            bundle.load_ffmpeg_record(homebrew)


@unittest.skipUnless(HAVE_TOOLCHAIN, "needs the macOS toolchain")
class SigningPolicyTests(unittest.TestCase):
    """Credential and hardened-runtime rules fail before anything is copied or signed."""

    def package(self, environment, *extra):
        with tempfile.TemporaryDirectory() as scratch:
            out = pathlib.Path(scratch) / "out"
            out.mkdir()
            app = pathlib.Path(scratch) / "stage.app"
            app.mkdir()
            cleaned = {key: value for key, value in os.environ.items()
                       if key not in ("BLACKMOOR_SIGN_IDENTITY", "BLACKMOOR_NOTARY_PROFILE")}
            cleaned.update(environment)
            result = subprocess.run(
                [sys.executable, "-I", str(SCRIPTS / "macos_bundle.py"), "package", "--app", str(app),
                 "--out-dir", str(out), "--ffmpeg-prefix", scratch] + list(extra),
                env=cleaned, capture_output=True, text=True)
            return result, sorted(path.name for path in out.iterdir())

    def test_notary_profile_without_identity_is_refused(self):
        result, produced = self.package({"BLACKMOOR_NOTARY_PROFILE": "some-profile"})
        self.assertEqual(result.returncode, 1)
        self.assertIn("without BLACKMOOR_SIGN_IDENTITY", result.stderr)
        self.assertNotIn("some-profile", result.stdout + result.stderr)
        self.assertEqual(produced, [])

    def test_unknown_identity_is_refused_and_never_echoed(self):
        secret = "Developer ID Application: Nobody Test (ZZZZZZZZZZ)"
        result, produced = self.package({"BLACKMOOR_SIGN_IDENTITY": secret})
        self.assertEqual(result.returncode, 1)
        self.assertIn("no matching code-signing identity", result.stderr)
        self.assertNotIn(secret, result.stdout + result.stderr)
        self.assertEqual(produced, [])

    def test_hardened_runtime_cannot_be_forced_on_an_ad_hoc_build(self):
        result, produced = self.package({}, "--hardened-runtime", "always")
        self.assertEqual(result.returncode, 1)
        self.assertIn("hardened runtime needs a Developer ID", result.stderr)
        self.assertEqual(produced, [])

    def test_codesign_flags_for_developer_id_and_ad_hoc(self):
        self.assertEqual(bundle.codesign_command("-", False), ["codesign", "--force", "--sign", "-", "--timestamp=none"])
        self.assertEqual(bundle.codesign_command("ID", True),
                         ["codesign", "--force", "--sign", "ID", "--timestamp", "--options", "runtime"])
        for flag in bundle.codesign_command("ID", True):
            self.assertNotIn("entitlements", flag)

    def test_redaction_hides_identity_and_profile(self):
        shown = bundle.redact(["codesign", "--sign", "SECRET ID", "x"])
        shown += bundle.redact(["xcrun", "notarytool", "submit", "f", "--keychain-profile", "SECRET PROFILE"])
        self.assertNotIn("SECRET", shown)


class FfmpegFactsTests(unittest.TestCase):
    GOOD = {
        "licenses": {name: "LGPL version 2.1 or later" for name in ("avutil", "avcodec", "avformat", "swscale", "swresample")},
        "configuration": "--enable-shared --disable-everything --enable-decoder=binkvideo",
        "codecs": ["binkaudio_dct", "binkaudio_rdft", "binkvideo"],
        "demuxers": ["bink"], "muxers": [], "protocols": ["file"], "bink_input_format_found": True,
    }

    def test_minimal_lgpl_bink_build_passes(self):
        self.assertEqual(bundle.ffmpeg_facts_violations(self.GOOD), [])

    def test_each_departure_is_flagged(self):
        cases = {
            "licence": dict(self.GOOD, licenses=dict(self.GOOD["licenses"], avcodec="GPL version 2 or later")),
            "gpl flag": dict(self.GOOD, configuration="--enable-gpl --enable-shared"),
            "extra codec": dict(self.GOOD, codecs=self.GOOD["codecs"] + ["h264"]),
            "missing decoder": dict(self.GOOD, codecs=["binkvideo"]),
            "extra demuxer": dict(self.GOOD, demuxers=["bink", "mov"]),
            "muxer": dict(self.GOOD, muxers=["mp4"]),
            "network": dict(self.GOOD, protocols=["file", "http"]),
            "no bink": dict(self.GOOD, bink_input_format_found=False),
        }
        for label, facts in cases.items():
            self.assertTrue(bundle.ffmpeg_facts_violations(facts), label)


@unittest.skipUnless(real_ffmpeg_prefix() is not None and real_ffmpeg_prefix().is_dir(),
                     "run script/build_ffmpeg_macos.sh first")
class RealFfmpegBuildTests(unittest.TestCase):
    def test_built_libraries_are_the_minimal_lgpl_bink_build(self):
        prefix = real_ffmpeg_prefix()
        completed = subprocess.run([sys.executable, "-I", str(SCRIPTS / "macos_bundle.py"), "ffmpeg-check",
                                    "--prefix", str(prefix), "--min-macos", "11.0"], capture_output=True, text=True)
        self.assertEqual(completed.returncode, 0, completed.stderr)
        self.assertIn("FFMPEG-CHECK OK", completed.stdout)

    def test_record_carries_hash_version_configure_and_licence_texts(self):
        prefix = real_ffmpeg_prefix()
        record = bundle.load_ffmpeg_record(prefix)
        self.assertEqual(record["source_sha256"], "cf38e0e28c7e5605942c4a77755349b0145804a397af37eb1fb4c77cb237f635")
        self.assertEqual(record["version"], "9.0.1")
        self.assertIn("--disable-everything", record["configure_command"])
        self.assertIn("--enable-demuxer=bink", record["configure_command"])
        for flag in bundle.FORBIDDEN_CONFIGURE_FLAGS:
            self.assertNotIn(flag, record["configure_command"])
        license_dir = prefix / bundle.FFMPEG_PREFIX_LICENSE_SUBDIR
        for name in bundle.FFMPEG_LICENSE_FILES + ("SOURCE-AVAILABILITY.txt",):
            self.assertGreater((license_dir / name).stat().st_size, 100, name)
        self.assertIn("GNU LESSER GENERAL PUBLIC LICENSE", (license_dir / "COPYING.LGPLv2.1").read_text())

    @unittest.skipUnless(HAVE_TOOLCHAIN, "needs the macOS toolchain")
    def test_ad_hoc_dmg_end_to_end_with_the_real_libraries(self):
        prefix = real_ffmpeg_prefix()
        with tempfile.TemporaryDirectory() as scratch:
            root = pathlib.Path(scratch)
            source = root / "main.c"
            source.write_text(
                "#include <stdio.h>\n#include <libavformat/avformat.h>\n#include <libavcodec/avcodec.h>\n"
                "int main(void) {\n"
                "  printf(\"bink=%d video=%d audio=%d %s\\n\", av_find_input_format(\"bink\") != 0,\n"
                "         avcodec_find_decoder(AV_CODEC_ID_BINKVIDEO) != 0,\n"
                "         avcodec_find_decoder(AV_CODEC_ID_BINKAUDIO_RDFT) != 0, avformat_license());\n"
                "  return 0;\n}\n")
            staged = root / "Blackmoor Recompiled.app"
            (staged / "Contents/MacOS").mkdir(parents=True)
            run(CLANG + ["-mmacosx-version-min=11.0", "-Wl,-headerpad_max_install_names", "-I" + str(prefix / "include"),
                         str(source), "-o", str(staged / "Contents/MacOS/BlackmoorRecompiled"),
                         "-L" + str(prefix / "lib"), "-lavformat", "-lavcodec", "-lavutil", "-lswscale", "-lswresample",
                         "-Wl,-rpath," + str(prefix / "lib")])
            with open(staged / "Contents/Info.plist", "wb") as handle:
                plistlib.dump({"CFBundleExecutable": "BlackmoorRecompiled", "CFBundleVersion": "0.1",
                               "LSMinimumSystemVersion": "11.0"}, handle)
            out = root / "out"
            out.mkdir()
            cleaned = {key: value for key, value in os.environ.items()
                       if key not in ("BLACKMOOR_SIGN_IDENTITY", "BLACKMOOR_NOTARY_PROFILE")}
            completed = subprocess.run(
                [sys.executable, "-I", str(SCRIPTS / "macos_bundle.py"), "package", "--app", str(staged),
                 "--out-dir", str(out), "--ffmpeg-prefix", str(prefix), "--min-macos", "11.0"],
                env=cleaned, capture_output=True, text=True)
            self.assertEqual(completed.returncode, 0, completed.stderr)
            self.assertIn("AD-HOC SIGNED, NOT NOTARIZED", completed.stdout)
            dmgs = sorted(out.glob("*.dmg"))
            self.assertEqual(len(dmgs), 1)
            self.assertIn("ADHOC-UNNOTARIZED", dmgs[0].name)
            self.assertIn("SHA256: " + bundle.sha256_file(dmgs[0]), completed.stdout)
            self.assertIn("bytes: %d" % dmgs[0].stat().st_size, completed.stdout)
            manifest = json.loads((out / "package-manifest.json").read_text())
            self.assertEqual(manifest["signing_mode"], "adhoc")
            self.assertFalse(manifest["notarized"])
            self.assertFalse(manifest["gatekeeper_app_accepted"])
            self.assertEqual(len(manifest["bundled_libraries"]), 5)
            packaged = out / "app/Blackmoor Recompiled.app"
            self.assertEqual(bundle.verify_bundle(packaged, "11.0"), [])
            run(["codesign", "--verify", "--deep", "--strict", packaged])
            ran = run([packaged / "Contents/MacOS/BlackmoorRecompiled"])
            self.assertEqual(ran.stdout.strip(), "bink=1 video=1 audio=1 LGPL version 2.1 or later")
            readme = (out / "dmg-root/README.txt").read_text()
            self.assertIn("NOT NOTARISED", readme)
            self.assertEqual(os.readlink(out / "dmg-root/Applications"), "/Applications")

    @unittest.skipUnless(HAVE_TOOLCHAIN, "needs the macOS toolchain")
    def test_real_libraries_bundle_into_a_clean_relocatable_app(self):
        prefix = real_ffmpeg_prefix()
        with tempfile.TemporaryDirectory() as scratch:
            root = pathlib.Path(scratch)
            source = root / "main.c"
            source.write_text("#include <stdio.h>\nconst char *avutil_license(void);\nint main(void) { puts(avutil_license()); return 0; }\n")
            app = root / "Blackmoor Recompiled.app"
            (app / "Contents/MacOS").mkdir(parents=True)
            executable = app / "Contents/MacOS/BlackmoorRecompiled"
            libutil = sorted(path for path in (prefix / "lib").glob("libavutil.*.dylib") if bundle.BUNDLED_LIB_RE.match(path.name))[0]
            run(CLANG + ["-mmacosx-version-min=11.0", "-Wl,-headerpad_max_install_names", str(source), "-o", str(executable),
                         "-L" + str(prefix / "lib"), "-lavutil", "-Wl,-rpath," + str(prefix / "lib")])
            with open(app / "Contents/Info.plist", "wb") as handle:
                plistlib.dump({"CFBundleExecutable": "BlackmoorRecompiled", "LSMinimumSystemVersion": "11.0"}, handle)
            bundle.bundle_dependencies(app, prefix)
            bundle.copy_ffmpeg_licenses(app, prefix)
            self.assertEqual((app / "Contents/Frameworks" / libutil.name).is_file(), True)
            problems = [item for item in bundle.verify_bundle(app, "11.0", check_runtime=False)]
            self.assertEqual(problems, [])
            completed = run([executable])
            self.assertEqual(completed.stdout.strip(), "LGPL version 2.1 or later")


if __name__ == "__main__":
    unittest.main()
