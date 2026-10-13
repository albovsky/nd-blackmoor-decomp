import ctypes as c
import json
from pathlib import Path
import shutil
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
WORKSPACE = PROJECT.parent.parent


class ResourceBytes(c.Structure):
    _fields_ = [('bytes', c.c_void_p), ('length', c.c_size_t),
                ('type', c.c_uint8), ('source', c.c_int)]


class Image(c.Structure):
    _fields_ = [('name', c.c_char * 33), ('id', c.c_uint16),
                ('width', c.c_uint16), ('pitch', c.c_uint16),
                ('height', c.c_uint16), ('depth', c.c_uint16),
                ('pixels', c.c_void_p), ('byte_count', c.c_size_t)]


class GameResourcesTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        library = PROJECT / 'build/libgameresources.dylib'
        descriptor = WORKSPACE / 'work/analysis/game-source.json'
        if not library.is_file() or not descriptor.is_file():
            raise unittest.SkipTest('Build the resource manager and supply original game data')
        game = Path(json.loads(descriptor.read_text())['game_dir'])
        cls.original = game / 'Ciftree'
        if not (cls.original / 'CIFTREE.DAT').is_file():
            raise unittest.SkipTest('Original game directory is unavailable')
        cls.lib = c.CDLL(str(library))
        cls.lib.game_resources_open.argtypes = [c.c_char_p, c.c_int, c.c_char_p, c.c_size_t]
        cls.lib.game_resources_open.restype = c.c_void_p
        cls.lib.game_resources_close.argtypes = [c.c_void_p]
        cls.lib.game_resources_load_bytes.argtypes = [c.c_void_p, c.c_char_p,
                                                     c.POINTER(ResourceBytes), c.c_char_p, c.c_size_t]
        cls.lib.game_resource_bytes_destroy.argtypes = [c.POINTER(ResourceBytes)]
        cls.lib.game_resources_load_image.argtypes = [c.c_void_p, c.c_char_p,
                                                     c.POINTER(Image), c.POINTER(c.c_int), c.c_char_p, c.c_size_t]
        cls.lib.cif_image_destroy.argtypes = [c.POINTER(Image)]

    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.directory = Path(self.temporary.name)
        (self.directory / 'CIFTREE.DAT').symlink_to(self.original / 'CIFTREE.DAT')
        self.managers = []

    def tearDown(self):
        for manager in self.managers:
            self.lib.game_resources_close(manager)
        self.temporary.cleanup()

    def manager(self, enabled):
        error = c.create_string_buffer(192)
        manager = self.lib.game_resources_open(str(self.directory).encode(), enabled, error, len(error))
        self.assertTrue(manager, error.value)
        self.managers.append(manager)
        return manager

    def load(self, manager, name):
        output = ResourceBytes()
        error = c.create_string_buffer(192)
        status = self.lib.game_resources_load_bytes(manager, name, c.byref(output), error, len(error))
        try:
            data = c.string_at(output.bytes, output.length) if output.bytes else None
            return status, data, output.source, error.value
        finally:
            self.lib.game_resource_bytes_destroy(c.byref(output))

    def test_external_patch_precedes_different_archive_boot(self):
        shutil.copyfile(self.original / 'boot.CIF', self.directory / 'bOoT.cIf')
        status, data, source, error = self.load(self.manager(1), b'boot')
        self.assertEqual(status, 1, error)
        self.assertEqual(source, 1)
        self.assertEqual(len(data), 69442)
        expected = WORKSPACE / 'work/analysis/cif-boot-native.bin'
        self.assertEqual(data, expected.read_bytes())

    def test_disabled_external_checking_uses_archive_boot(self):
        shutil.copyfile(self.original / 'boot.CIF', self.directory / 'boot.CIF')
        status, data, source, error = self.load(self.manager(0), b'BOOT')
        self.assertEqual(status, 1, error)
        self.assertEqual(source, 0)
        self.assertEqual(len(data), 69410)

    def test_missing_external_file_falls_back_to_archive(self):
        status, data, source, error = self.load(self.manager(1), b's0')
        self.assertEqual(status, 1, error)
        self.assertEqual(source, 0)
        self.assertEqual(len(data), 2972)

    def test_present_invalid_external_file_does_not_fall_back(self):
        (self.directory / 'boot.CIF').write_bytes(b'not a CIF')
        status, data, _, _ = self.load(self.manager(1), b'BOOT')
        self.assertEqual(status, 0)
        self.assertIsNone(data)

    def test_ambiguous_casefold_patch_names_are_rejected(self):
        # Filesystems that collapse these names cannot represent this fixture.
        a, b = self.directory / 'BOOT.CIF', self.directory / 'boot.cif'
        a.write_bytes(b'first')
        b.write_bytes(b'second')
        if a.samefile(b):
            self.skipTest('Case-insensitive filesystem cannot represent duplicate names')
        status, data, _, error = self.load(self.manager(1), b'BOOT')
        self.assertEqual(status, 0)
        self.assertIsNone(data)
        self.assertIn(b'ambiguous', error)

    def test_resource_names_cannot_escape_the_original_directory(self):
        manager = self.manager(1)
        for name in (b'../boot', b'..\\boot', b'\xff', b'A' * 33):
            status, data, _, _ = self.load(manager, name)
            self.assertEqual(status, 0, name)
            self.assertIsNone(data)

    def test_external_logo_image_uses_actual_metadata(self):
        shutil.copyfile(self.original / 'Logo.CIF', self.directory / 'Logo.CIF')
        image = Image()
        source = c.c_int(-1)
        error = c.create_string_buffer(192)
        status = self.lib.game_resources_load_image(self.manager(1), b'logo',
            c.byref(image), c.byref(source), error, len(error))
        try:
            self.assertEqual(status, 1, error.value)
            self.assertEqual(source.value, 1)
            self.assertEqual((image.width, image.pitch, image.height, image.depth), (640, 1280, 480, 16))
            self.assertEqual(image.byte_count, 614400)
            self.assertEqual(image.name, b'LOGO')
        finally:
            self.lib.cif_image_destroy(c.byref(image))


if __name__ == '__main__':
    unittest.main()
