"""Finite fake-input/generator fixtures; no compiler, native game or owner assets."""
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('generation_cache', PROJECT / 'recomp/generation_cache.py')
cache = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(cache)

STUB = '''import json,sys
from pathlib import Path
project=Path(__file__).resolve().parent.parent
out=Path(sys.argv[1]);chunks=int(sys.argv[2])
counter=project/'calls.txt'
counter.write_text(str(int(counter.read_text())+1)if counter.exists()else'1')
mode=(project/'mode.txt').read_text()if(project/'mode.txt').exists()else'normal'
if mode=='exit':raise SystemExit(7)
if mode=='incomplete':raise SystemExit(0)
out.mkdir(parents=True,exist_ok=True)
for i in range(chunks):
    path=out/f'rc_lifted_{i:02d}.c';text=f'/* synthetic chunk {i} */\\n'
    if not path.exists()or path.read_text()!=text:path.write_text(text)
for name in ['rc_generated.c','rc_generated.h']: (out/name).write_text('/* synthetic registration */\\n')
(out/'lift_census.json').write_text(json.dumps({'lifted':['synthetic'],'refused':{}}))
'''


class GenerationCacheTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='generation cache fixture ')
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.project = self.root / 'repo/outputs/blackmoor-decomp'
        for relative in cache.INPUTS:
            path = self.project / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text('synthetic input\n')
        (self.project / 'recomp/lift_recomp.py').write_text(STUB)
        self.original = self.project.parent.parent / 'work/original/GAME.EXE'
        self.original.parent.mkdir(parents=True)
        self.original.write_bytes(b'synthetic original input; not an executable')
        self.out = self.root / 'generated output'

    def ensure(self, chunks=2, force=False, image=None):
        return cache.ensure_generated(self.project, self.out, chunks, force,
                                      import_image=image or self.original)

    def calls(self):
        return int((self.project / 'calls.txt').read_text())

    def test_full_input_hashes_chunks_force_and_unchanged_chunk_mtime(self):
        self.assertTrue(self.ensure())
        chunk = self.out / 'rc_lifted_00.c'
        os.utime(chunk, ns=(1000000000, 1000000000))
        self.assertFalse(self.ensure())
        self.assertEqual(self.calls(), 1)
        for relative in cache.INPUTS:
            path = self.project / relative
            path.write_text(path.read_text() + '\n# input changed\n')
            self.assertTrue(self.ensure())
        self.original.write_bytes(b'changed synthetic image')
        self.assertTrue(self.ensure())
        alternate = self.root / 'alternate original'
        alternate.write_bytes(b'alternate synthetic import image')
        self.assertTrue(self.ensure(image=alternate))
        alternate.write_bytes(b'changed synthetic import image')
        self.assertTrue(self.ensure(image=alternate))
        self.assertTrue(self.ensure(chunks=3))
        self.assertTrue(self.ensure(chunks=3, force=True))
        self.assertEqual(chunk.stat().st_mtime_ns, 1000000000)
        self.assertFalse(self.ensure(chunks=3))

    def test_missing_or_changed_outputs_and_missing_invalid_stamp_regenerate(self):
        self.ensure()
        for name in ['rc_lifted_01.c', 'rc_generated.c', 'rc_generated.h', 'lift_census.json', cache.STAMP]:
            (self.out / name).unlink()
            before = self.calls()
            self.assertTrue(self.ensure())
            self.assertEqual(self.calls(), before + 1)
        (self.out / cache.STAMP).write_text('{invalid')
        self.assertTrue(self.ensure())
        (self.out / 'rc_lifted_00.c').write_text('changed generated source')
        self.assertTrue(self.ensure())
        (self.out / 'lift_census.json').write_text('{}')
        self.assertTrue(self.ensure())
        self.assertFalse(self.ensure())

    def test_unsuccessful_or_incomplete_generation_never_leaves_valid_stamp(self):
        self.ensure()
        mode = self.project / 'mode.txt'
        mode.write_text('exit')
        with self.assertRaises(subprocess.CalledProcessError):
            self.ensure(force=True)
        self.assertFalse((self.out / cache.STAMP).exists())
        mode.write_text('incomplete')
        (self.out / 'rc_generated.h').unlink()
        with self.assertRaisesRegex(ValueError, 'generated output'):
            self.ensure()
        self.assertFalse((self.out / cache.STAMP).exists())
        mode.write_text('normal')
        self.assertTrue(self.ensure())

    def test_old_extra_chunks_or_objects_refuse_without_deleting_them(self):
        self.ensure(chunks=3)
        with self.assertRaisesRegex(ValueError, 'fresh build directory'):
            self.ensure(chunks=2)
        self.assertTrue((self.out / 'rc_lifted_02.c').exists())
        self.assertFalse((self.out / cache.STAMP).exists())
        self.ensure(chunks=3)
        extra = self.out / 'rc_lifted_03.o'
        extra.write_bytes(b'synthetic stale object; never linked')
        with self.assertRaisesRegex(ValueError, 'fresh build directory'):
            self.ensure(chunks=3)
        self.assertTrue(extra.exists())
        self.assertFalse((self.out / cache.STAMP).exists())

    def test_both_shell_generation_prefixes_forward_options_and_refresh(self):
        shutil.copy2(PROJECT / 'recomp/generation_cache.py', self.project / 'recomp/generation_cache.py')
        environment = dict(os.environ, JOBS='1', GAME_EXE=str(self.original), CHUNKS='2', RELIFT='')
        for name, shell in [('build_linux.sh', 'sh'), ('build_macos.sh', 'bash')]:
            text = (PROJECT / 'recomp' / name).read_text()
            # Execute only the real generation prefix, ending before any compiler,
            # link, signing or bundle command. The child is the synthetic stub.
            lines = text.splitlines(keepends=True)
            last = next(i for i, line in enumerate(lines) if '/generation_cache.py"' in line)
            prefix = self.project / 'recomp' / ('prefix-' + name)
            prefix.write_text(''.join(lines[:last + 1]))
            out = self.root / (name + ' output')
            environment['BUILD_DIR'] = str(out)
            command = [shell, str(prefix), str(out)]
            subprocess.run(command, env=environment, check=True, capture_output=True)
            before = self.calls()
            subprocess.run(command, env=environment, check=True, capture_output=True)
            self.assertEqual(self.calls(), before)
            changed = self.project / 'scripts/lift_fl41.py'
            changed.write_text(changed.read_text() + '\n# generator dependency changed\n')
            subprocess.run(command, env=environment, check=True, capture_output=True)
            self.assertEqual(self.calls(), before + 1)
            environment['RELIFT'] = '1'
            subprocess.run(command, env=environment, check=True, capture_output=True)
            self.assertEqual(self.calls(), before + 2)
            environment['RELIFT'] = ''
            self.assertTrue((out / cache.STAMP).is_file())


if __name__ == '__main__':
    unittest.main()
