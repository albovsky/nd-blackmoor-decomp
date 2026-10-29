#!/usr/bin/env python3
"""Spike driver: load GAME.EXE into a flat 32-bit space, run the lifted functions natively from the entry point, play the
Win32 imports in Python, and fall back to Unicorn (original bytes, same memory) for the functions the lifter refused.

  python3 -I driver.py [--max-imports N] [--trace]
"""
import ctypes, json, mmap, struct, sys, time, os, collections
from pathlib import Path
import pefile

HERE = Path(__file__).resolve().parent
GAMEDIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'gamedir')
PROJECT = HERE.parent.parent          # outputs/blackmoor-decomp
EXE = Path(os.environ.get('GAME_EXE', PROJECT.parent.parent / 'work' / 'original' / 'GAME.EXE'))
IMAGE_BASE = 0x400000
STACK_BASE, STACK_SIZE = 0x7c000000, 0x100000
TIB = 0x7d000000
MAGIC = 0x7e000000              # import stubs: 16 bytes each
HEAP_BASE, HEAP_SIZE = 0x10000000, 0x4000000
SURF_BASE, SURF_SIZE = 0x20000000, 0x20000000   # DirectDraw surface memory (mmap is lazy)
STOP = 0x7f000000               # return address that ends a Unicorn run
PAGE = 0x1000

class Regs(ctypes.Structure):
    _fields_ = [(n, ctypes.c_uint32) for n in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')]

FALLBACK = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_uint32, ctypes.POINTER(Regs))
FAULT = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_uint32, ctypes.c_int, ctypes.c_int)
TRACE = ctypes.CFUNCTYPE(None, ctypes.c_uint32, ctypes.c_int)
LIFTED = ctypes.CFUNCTYPE(None, ctypes.POINTER(Regs), ctypes.c_void_p)


class Memory:
    def __init__(self, lib):
        self.lib = lib
        self.regions = []       # (va, size, mmap)
        self.uc_maps = []       # regions to map into unicorn
    def map(self, va, size, name, data=b''):
        size = (size + PAGE - 1) & ~(PAGE - 1)
        m = mmap.mmap(-1, size)
        if data:
            m[:len(data)] = data
        addr = ctypes.addressof(ctypes.c_char.from_buffer(m))
        assert self.lib.host_map(va, size, ctypes.c_void_p(addr)) == 0, name
        self.regions.append((va, size, m, name))
        self.uc_maps.append((va, size, addr))
        return m
    def region(self, va):
        for base, size, m, name in self.regions:
            if base <= va < base + size:
                return base, m
        return None, None
    def read(self, va, n):
        base, m = self.region(va)
        if m is None:
            raise KeyError('read of unmapped 0x%x' % va)
        return bytes(m[va - base:va - base + n])
    def write(self, va, data):
        base, m = self.region(va)
        if m is None:
            raise KeyError('write of unmapped 0x%x' % va)
        m[va - base:va - base + len(data)] = data
    def u32(self, va): return struct.unpack('<I', self.read(va, 4))[0]
    def u32w(self, va, v): self.write(va, struct.pack('<I', v & 0xffffffff))
    def u16(self, va): return struct.unpack('<H', self.read(va, 2))[0]
    def w32(self, va, v): self.write(va, struct.pack('<I', v & 0xffffffff))
    def w16(self, va, v): self.write(va, struct.pack('<H', v & 0xffff))
    def cstr(self, va, limit=4096):
        out = bytearray()
        while len(out) < limit:
            b = self.read(va + len(out), 1)
            if b == b'\0':
                break
            out += b
        return bytes(out).decode('latin-1')


class Machine:
    def __init__(self, trace=False, max_imports=200000):
        self.lib = ctypes.CDLL(str(HERE / 'libspike.so'))
        lib = self.lib
        lib.host_map.argtypes = [ctypes.c_uint32, ctypes.c_uint32, ctypes.c_void_p]
        lib.host_run.argtypes = [ctypes.c_uint32, ctypes.POINTER(Regs)]
        lib.host_register.argtypes = [ctypes.c_uint32, LIFTED]
        lib.host_has.argtypes = [ctypes.c_uint32]
        lib.host_abort_reason.restype = ctypes.c_char_p
        lib.host_fpu_get.argtypes = [ctypes.c_void_p]; lib.host_fpu_set.argtypes = [ctypes.c_void_p]
        lib.host_set_abort.argtypes = [ctypes.c_char_p]
        lib.host_stats.argtypes = [ctypes.POINTER(ctypes.c_uint64 * 4)]
        lib.host_init.argtypes = [FALLBACK, FAULT, TRACE]
        self.mem = Memory(lib)
        self.log = open(HERE / 'run.log', 'w')
        self.import_log = collections.Counter()
        self.import_calls = 0
        self.com_vtables = {}
        self.com_objects = {}
        self.com_stub_count = 0
        self.surf_next = SURF_BASE
        self.frames = 0
        self.display = (640, 480, 16)
        self.max_imports = max_imports
        self.trace = trace
        self.depth = 0
        self.stop_reason = None
        self.pe = pefile.PE(str(EXE))
        self.load_image()
        self.setup_regions()
        self.setup_imports()
        self.register_lifted()
        self.on_demand = []
        self.heap_next = HEAP_BASE + 0x1000
        self.handles = {}
        self.next_handle = 0x100
        self.wndclasses = {}
        self.windows = {}
        self.hooks = {}
        self.timers = {}
        self.msgq = collections.deque()
        self.vclock = 1000
        self.idle_polls = 0
        self.max_idle_polls = 20000
        self.msg_log = 0
        self.tls = {}
        self.last_error = 0
        self.file_log = []
        self.ring = []
        self.stack = []
        self.files_opened = 0
        self.first_data_file = None
        self.gpa_names = {}
        self.cbs = (FALLBACK(self.fallback), FAULT(self.fault), TRACE(self.trace_cb))
        lib.host_init(*self.cbs)

    # ---- image and regions ----
    def load_image(self):
        pe = self.pe
        size = (pe.OPTIONAL_HEADER.SizeOfImage + PAGE - 1) & ~(PAGE - 1)
        image = bytearray(pe.get_memory_mapped_image())
        image += bytes(size - len(image))
        self.image_size = size
        self.mem.map(IMAGE_BASE, size, 'image', bytes(image))
        self.entry = IMAGE_BASE + pe.OPTIONAL_HEADER.AddressOfEntryPoint
    def setup_regions(self):
        self.mem.map(STACK_BASE, STACK_SIZE, 'stack')
        self.mem.map(TIB, PAGE, 'tib')
        self.mem.map(HEAP_BASE, HEAP_SIZE, 'heap')
        self.mem.map(SURF_BASE, SURF_SIZE, 'surfaces')
        self.mem.map(MAGIC, 0x10000, 'magic')
        self.mem.map(STOP, PAGE, 'stop')
        m = self.mem
        m.w32(TIB + 0x00, 0xffffffff)            # SEH chain end
        m.w32(TIB + 0x04, STACK_BASE + STACK_SIZE)
        m.w32(TIB + 0x08, STACK_BASE)
        m.w32(TIB + 0x18, TIB)                   # self
        m.w32(TIB + 0x20, 0x1234)                # pid
        m.w32(TIB + 0x24, 0x5678)                # tid
        m.w32(TIB + 0x30, TIB + 0x800)           # PEB (fake, inside the page)
    def setup_imports(self):
        census = json.load(open(HERE / 'lift_census.json'))
        cleanup = {}
        for va, meta in census['meta'].items():
            for slot, n in meta['imports'].items():
                cleanup[int(slot, 16)] = n
        self.imports = {}          # slot va -> (name, dll, stub va, cleanup bytes)
        self.stub_to_slot = {}
        k = 0
        for d in self.pe.DIRECTORY_ENTRY_IMPORT:
            dll = d.dll.decode()
            for imp in d.imports:
                name = imp.name.decode() if imp.name else '#%d' % imp.ordinal
                slot = imp.address
                stub = MAGIC + 0x10 * (k + 1)
                n = cleanup.get(slot)
                if n is None:
                    n = ARGS.get(name, 0) * 4
                self.imports[slot] = (name, dll, stub, n)
                self.stub_to_slot[stub] = slot
                self.mem.w32(slot, stub)
                self.mem.write(stub, b'\xc2' + struct.pack('<H', n) if n else b'\xc3')      # ret N
                k += 1
        self.log.write('%d imports\n' % k)
        xrefs = json.load(open(PROJECT / 'function-xrefs.json'))
        byname = {dll + '!' + name: slot for slot, (name, dll, stub, n) in self.imports.items()}
        self.thunks = {int(t['va'], 16): byname[t['import']] for t in xrefs['thunks'] if t.get('kind') == 'import' and t['import'] in byname}
    def register_lifted(self):
        census = json.load(open(HERE / 'lift_census.json'))
        self.lifted = set()
        self._keep = []
        forced_list = [x for x in os.environ.get('FORCE_UC', '').split(',') if x]            # debugging: run these (or lo-hi ranges) on the emulator instead
        forced = {int(x, 16) for x in forced_list if '-' not in x}
        ranges = [tuple(int(y, 16) for y in x.split('-')) for x in forced_list if '-' in x]
        for va in census['lifted']:
            v = int(va, 16)
            if v in forced or any(lo <= v < hi for lo, hi in ranges): continue
            fn = LIFTED(('m%x_lifted' % v, self.lib))
            self._keep.append(fn)
            self.lib.host_register(v, fn)
            self.lifted.add(v)
        self.refused = {int(k, 16): v for k, v in census['refused'].items()}
        self.log.write('%d lifted registered, %d refused\n' % (len(self.lifted), len(self.refused)))

    # ---- callbacks from the host ----
    def fault(self, address, size, write):
        if address >= 0xfff00000 or len(self.on_demand) > 64:
            return 0
        page = address & ~(PAGE - 1)
        try:
            self.mem.map(page, PAGE, 'on-demand')
        except AssertionError:
            return 0
        self.on_demand.append(page)
        if page == 0x646000:
            self.log.write('STACK at first write past image: %s\n' % ' '.join('0x%x' % t for t in self.stack[-30:]))
            self.log.write('LAST CALLS: %s\n' % ' '.join('0x%x' % t for t in self.ring[-60:]))
            for a in (0x63a3c9, 0x63a5a0, 0x63a5a4, 0x639dae, 0x546000, 0x546008, 0x63a2c5, 0x639aa2, 0x639db1):
                self.log.write('  str 0x%x = %r\n' % (a, self.mem.cstr(a, 300)))
        if len(self.on_demand) <= 20:
            self.log.write('on-demand page 0x%08x (%s %d)\n' % (page, 'write' if write else 'read', size))
        va, sz, addr = self.mem.uc_maps[-1]
        for uc in self.__dict__.get('uc_pool', []):
            uc.mem_map_ptr(va, sz, 7, addr)
        return 1
    def trace_cb(self, target, enter):
        if enter:
            self.ring.append(target)
            if len(self.ring) > 400: del self.ring[:200]
            self.stack.append(target)
        elif self.stack:
            self.stack.pop()
        pass
    def fallback(self, target, regs):
        try:
            r = regs.contents
            if target == 0xffffffff:
                self.lib.host_set_abort(b'divide error / trap in lifted code')
                return -3
            if target in self.imports:
                return self.call_import(target, r)
            if target in self.stub_to_slot:
                return self.call_import(self.stub_to_slot[target], r)
            if target in self.thunks:
                return self.call_import(self.thunks[target], r)
            if IMAGE_BASE <= target < IMAGE_BASE + self.image_size:
                return self.run_unicorn(target, r)
            self.log.write('BAD CALL 0x%x: stack %s\n  last calls %s\n' % (target, ' '.join('0x%x' % t for t in self.stack[-25:]), ' '.join('0x%x' % t for t in self.ring[-40:])))
            self.lib.host_set_abort(('call to 0x%08x: not lifted, not an import, not in the image' % target).encode())
            return -3
        except StopRun as ex:
            self.lib.host_set_abort(str(ex).encode()[:200])
            return -3
        except Exception as ex:
            import traceback
            traceback.print_exc(file=self.log)
            self.lib.host_set_abort(('python error in fallback for 0x%x: %r' % (target, ex)).encode()[:200])
            return -3

    # ---- imports ----
    def arg(self, r, i):
        return self.mem.u32(r.esp + 4 + 4 * i)
    def call_import(self, slot, r):
        name, dll, stub, n = self.imports[slot]
        self.import_calls += 1
        self.import_log[name] += 1
        if self.import_calls > self.max_imports:
            raise StopRun('import budget exhausted')
        fn = getattr(self, 'api_' + name.replace('@', '_').replace('#', '_'), None)
        nargs = n // 4
        if fn is not None:
            nargs = fn.__code__.co_argcount - 2
        args = [self.arg(r, i) for i in range(nargs)]
        if fn is None:
            if self.import_log[name] <= 3:
                self.log.write('IMPORT %s!%s%s -> unimplemented, returns 0\n' % (dll, name, tuple(hex(a) for a in args)))
            r.eax = 0
            return 0
        if self.trace or self.import_log[name] <= 5:
            self.log.write('IMPORT %s!%s%s\n' % (dll, name, tuple(hex(a) for a in args)))
        ret = fn(r, *args)
        if ret is NEVER:
            return -1
        r.eax = (ret or 0) & 0xffffffff
        return 0

    # ---- Unicorn fallback over the same memory ----
    def uc_for(self, level):
        """one emulator per nesting level (an emulator cannot be re-entered from its own hook)"""
        import unicorn
        from unicorn import x86_const as X
        self.X = X
        pool = self.__dict__.setdefault('uc_pool', [])
        while len(pool) <= level:
            uc = unicorn.Uc(unicorn.UC_ARCH_X86, unicorn.UC_MODE_32)
            if not hasattr(self, 'gdt'):
                self.gdt = 0x7d001000
                self.mem.map(self.gdt, PAGE, 'gdt')
                def seg(base, limit, access, flags):
                    return struct.pack('<HHBBBB', limit & 0xffff, base & 0xffff, (base >> 16) & 0xff, access, ((limit >> 16) & 0xf) | (flags << 4), (base >> 24) & 0xff)
                self.mem.write(self.gdt, bytes(8) + seg(0, 0xfffff, 0x9b, 0xc) + seg(0, 0xfffff, 0x93, 0xc) + seg(TIB, 0xfff, 0x93, 0x4))
            for va, size, addr in self.mem.uc_maps:
                uc.mem_map_ptr(va, size, 7, addr)
            uc.reg_write(X.UC_X86_REG_GDTR, (0, self.gdt, 0xfff, 0))
            uc.reg_write(X.UC_X86_REG_CS, 0x08)
            for reg in (X.UC_X86_REG_SS, X.UC_X86_REG_DS, X.UC_X86_REG_ES, X.UC_X86_REG_GS):
                uc.reg_write(reg, 0x10)
            uc.reg_write(X.UC_X86_REG_FS, 0x18)
            state = {'depth': 0, 'ret_at': None, 'count': 0}
            uc.spike_state = state
            def unmapped(uc_, access, address, size, value, user):
                return bool(self.fault(address, size, 1 if access == unicorn.UC_MEM_WRITE_UNMAPPED else 0))
            uc.hook_add(unicorn.UC_HOOK_MEM_READ_UNMAPPED | unicorn.UC_HOOK_MEM_WRITE_UNMAPPED, unmapped)
            def on_code(uc_, address, size, user, uc=uc, state=state):
                state['count'] += 1
                if state['count'] > 30_000_000:
                    state['ret_at'] = ('budget', address)
                    uc.emu_stop(); return
                b = self.mem.read(address, 2)
                b0 = b[0]
                if b0 == 0xe8 or (b0 == 0xff and ((b[1] >> 3) & 7) in (2, 3)):
                    state['depth'] += 1
                elif b0 in (0xc3, 0xc2):
                    if state['depth'] == 0:
                        state['ret_at'] = (address, b0)
                        uc.emu_stop()
                    else:
                        state['depth'] -= 1
                slot = self.stub_to_slot.get(address)
                if slot is not None:
                    r = Regs(*(uc.reg_read(getattr(X, 'UC_X86_REG_' + n.upper())) for n in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')))
                    res = self.call_import(slot, r)
                    if res == -1:
                        raise StopRun('never-returning import inside emulation')
                    uc.reg_write(X.UC_X86_REG_EAX, r.eax); uc.reg_write(X.UC_X86_REG_ECX, r.ecx); uc.reg_write(X.UC_X86_REG_EDX, r.edx)
            uc.hook_add(unicorn.UC_HOOK_CODE, on_code)
            pool.append(uc)
        return pool[level]
    def fpu_to_uc(self, uc):
        """the x87 stack is one machine state: hand the native side's stack to the emulator before a refused body runs"""
        X = self.X
        buf = (ctypes.c_uint8 * 140)()
        self.lib.host_fpu_get(buf)
        sw, cw = struct.unpack_from('<HH', bytes(buf), 0)
        valid = bytes(buf[4:12])
        top = (sw >> 11) & 7
        uc.reg_write(X.UC_X86_REG_FPSW, sw)
        uc.reg_write(X.UC_X86_REG_FPCW, cw)
        tag = 0xffff
        for phys in range(8):                                      # UC_X86_REG_FPn are the physical registers
            if valid[phys]:
                mant, exp = struct.unpack_from('<QH', bytes(buf), 12 + 16 * phys)
                uc.reg_write(X.UC_X86_REG_FP0 + phys, (mant, exp))
                tag &= ~(3 << (2 * phys))
        uc.reg_write(X.UC_X86_REG_FPTAG, tag)
    def fpu_from_uc(self, uc):
        X = self.X
        buf = (ctypes.c_uint8 * 140)()
        self.lib.host_fpu_get(buf)
        raw = bytearray(bytes(buf))
        sw = uc.reg_read(X.UC_X86_REG_FPSW); cw = uc.reg_read(X.UC_X86_REG_FPCW); tag = uc.reg_read(X.UC_X86_REG_FPTAG)
        top = (sw >> 11) & 7
        struct.pack_into('<HH', raw, 0, sw, cw)
        for phys in range(8):
            live = ((tag >> (2 * phys)) & 3) != 3
            raw[4 + phys] = 1 if live else 0
            if live:
                mant, exp = uc.reg_read(X.UC_X86_REG_FP0 + phys)
                struct.pack_into('<QH', raw, 12 + 16 * phys, mant, exp)
        self.lib.host_fpu_set((ctypes.c_uint8 * 140).from_buffer_copy(bytes(raw)))
    def run_unicorn(self, target, r):
        level = self.__dict__.setdefault('uc_level', 0)
        uc = self.uc_for(level)
        X = self.X
        self.uc_level = level + 1
        name = self.refused.get(target, 'unlifted')
        self.log.write('UNICORN 0x%x (%s) esp=0x%x level %d\n' % (target, name, r.esp, level))
        state = uc.spike_state
        state['depth'] = 0; state['ret_at'] = None
        try:
            for n in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi'):
                uc.reg_write(getattr(X, 'UC_X86_REG_' + n.upper()), getattr(r, n))
            self.fpu_to_uc(uc)
            try:
                uc.emu_start(target, 0)
            except Exception as ex:
                regs = {n: uc.reg_read(getattr(X, 'UC_X86_REG_' + n.upper())) for n in ('eip', 'eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi')}
                stack = [self.mem.u32(r.esp + 4 * i) for i in range(6)]
                raise StopRun('unicorn error %r at %s; entry 0x%x esp=0x%x stack=%s' % (ex, {k: hex(v) for k, v in regs.items()}, target, r.esp, [hex(x) for x in stack]))
            if state['ret_at'] is None or state['ret_at'][0] == 'budget':
                raise StopRun('unicorn run of 0x%x did not reach its return (eip 0x%x, %s)' % (target, uc.reg_read(X.UC_X86_REG_EIP), state['ret_at']))
            self.uc_instr = getattr(self, 'uc_instr', 0) + state['count']
            self.fpu_from_uc(uc)
            for n in ('eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi'):
                setattr(r, n, uc.reg_read(getattr(X, 'UC_X86_REG_' + n.upper())))
            at, b0 = state['ret_at']
            if uc.reg_read(X.UC_X86_REG_EIP) == at:
                # the ret was not executed: do it here
                n = self.mem.u16(at + 1) if b0 == 0xc2 else 0
                r.esp = r.esp + 4 + n
        finally:
            self.uc_level = level
        return 0

    # ---- running ----
    def call(self, target, *args, ecx=0):
        """Call a function of the image from Python (a window procedure, the entry point)."""
        r = Regs()
        sp = STACK_BASE + STACK_SIZE - 0x1000 - 0x100 * self.depth
        if self.depth:
            sp = self.cur_sp - 0x200
        sp -= 4 * (len(args) + 1)
        self.mem.w32(sp, STOP)
        for i, a in enumerate(args):
            self.mem.w32(sp + 4 + 4 * i, a)
        r.esp = sp; r.ecx = ecx
        saved = getattr(self, 'cur_sp', None)
        self.cur_sp = sp
        self.depth += 1
        try:
            rc = self.lib.host_run(target, ctypes.byref(r))
        finally:
            self.depth -= 1
            self.cur_sp = saved
        if rc:
            raise StopRun(self.lib.host_abort_reason().decode(errors='replace'))
        return r.eax

    # ---- heap and handles ----
    def alloc(self, size):
        size = (size + 15) & ~15
        p = self.heap_next
        self.heap_next += size
        if self.heap_next > HEAP_BASE + HEAP_SIZE:
            raise StopRun('heap exhausted')
        return p
    def handle(self, kind, obj=None):
        h = self.next_handle
        self.next_handle += 4
        self.handles[h] = (kind, obj)
        return h
    def wstr(self, va, limit=4096):
        out = []
        while len(out) < limit:
            c = self.mem.u16(va + 2 * len(out))
            if c == 0:
                break
            out.append(chr(c))
        return ''.join(out)

    # ---- Win32 subset ----
    def api_GetVersion(self, r): return 0x0a280105           # Windows XP 5.1 build 2600, platform NT
    def api_GetVersionExA(self, r, p):
        size = self.mem.u32(p)
        self.mem.w32(p + 4, 5); self.mem.w32(p + 8, 1); self.mem.w32(p + 12, 2600); self.mem.w32(p + 16, 2)
        self.mem.write(p + 20, b'Service Pack 3\0')
        return 1
    def api_HeapCreate(self, r, flags, init, maxsize): return self.handle('heap')
    def api_HeapDestroy(self, r, h): return 1
    def api_GetProcessHeap(self, r): return 0x100
    def api_HeapAlloc(self, r, heap, flags, size):
        p = self.alloc(size)
        self.handles.setdefault('sizes', {})[p] = size
        return p
    def api_HeapReAlloc(self, r, heap, flags, p, size):
        q = self.alloc(size)
        old = self.handles.get('sizes', {}).get(p, 0)
        if old:
            self.mem.write(q, self.mem.read(p, min(old, size)))
        self.handles.setdefault('sizes', {})[q] = size
        return q
    def api_HeapFree(self, r, heap, flags, p): return 1
    def api_HeapSize(self, r, heap, flags, p): return self.handles.get('sizes', {}).get(p, 0)
    def api_VirtualAlloc(self, r, addr, size, kind, prot): return self.alloc(size)
    def api_VirtualFree(self, r, addr, size, kind): return 1
    def api_GlobalAlloc(self, r, flags, size):
        p = self.alloc(size); self.handles.setdefault('sizes', {})[p] = size; return p
    def api_GlobalLock(self, r, h): return h
    def api_GlobalUnlock(self, r, h): return 1
    def api_GlobalFree(self, r, h): return 0
    def api_GlobalHandle(self, r, p): return p
    def api_LocalAlloc(self, r, flags, size):
        p = self.alloc(size); self.handles.setdefault('sizes', {})[p] = size; return p
    def api_LocalReAlloc(self, r, p, size, flags):
        q = self.alloc(size); old = self.handles.get('sizes', {}).get(p, 0)
        if old: self.mem.write(q, self.mem.read(p, min(old, size)))
        self.handles.setdefault('sizes', {})[q] = size; return q
    def api_GlobalReAlloc(self, r, p, size, flags): return self.api_LocalReAlloc(r, p, size, flags)
    def api_LocalLock(self, r, h): return h
    def api_LocalUnlock(self, r, h): return 0
    def api_LocalSize(self, r, h): return self.handles.get('sizes', {}).get(h, 0)
    def api_GlobalSize(self, r, h): return self.handles.get('sizes', {}).get(h, 0)
    def api_GlobalFlags(self, r, h): return 0
    def api_LocalFree(self, r, h): return 0
    def api_GetCommandLineA(self, r):
        if not hasattr(self, 'cmdline'):
            self.cmdline = self.alloc(64); self.mem.write(self.cmdline, b'"C:\\GAME\\GAME.EXE"\0')
        return self.cmdline
    def api_GetEnvironmentStrings(self, r):
        p = self.alloc(64); self.mem.write(p, b'PATH=C:\\GAME\0\0'); return p
    api_GetEnvironmentStringsA = api_GetEnvironmentStrings
    def api_GetEnvironmentStringsW(self, r):
        p = self.alloc(128); self.mem.write(p, 'PATH=C:\\GAME\0\0'.encode('utf-16-le')); return p
    def api_FreeEnvironmentStringsA(self, r, p): return 1
    def api_FreeEnvironmentStringsW(self, r, p): return 1
    def api_GetStartupInfoA(self, r, p):
        self.mem.write(p, bytes(68)); self.mem.w32(p, 68); return 0
    def api_GetModuleHandleA(self, r, name):
        return IMAGE_BASE if name == 0 else self.handle('module', self.mem.cstr(name))
    def api_GetModuleFileNameA(self, r, h, buf, n):
        s = b'C:\\GAME\\GAME.EXE\0'; self.mem.write(buf, s[:n]); return len(s) - 1
    def api_GetProcAddress(self, r, h, name):
        s = self.mem.cstr(name) if name >= 0x10000 else '#%d' % name
        self.log.write('  GetProcAddress(%s)\n' % s)
        return 0
    def api_LoadLibraryA(self, r, name):
        self.log.write('  LoadLibraryA(%s)\n' % self.mem.cstr(name)); return 0
    def api_GetCurrentThreadId(self, r): return 0x5678
    def api_GetCurrentProcessId(self, r): return 0x1234
    def api_GetCurrentProcess(self, r): return 0xffffffff
    def api_GetCurrentThread(self, r): return 0xfffffffe
    def api_TlsAlloc(self, r):
        i = len(self.tls); self.tls[i] = 0; return i
    def api_TlsSetValue(self, r, i, v): self.tls[i] = v; return 1
    def api_TlsGetValue(self, r, i): return self.tls.get(i, 0)
    def api_TlsFree(self, r, i): return 1
    def api_InitializeCriticalSection(self, r, p): return 0
    def api_EnterCriticalSection(self, r, p): return 0
    def api_LeaveCriticalSection(self, r, p): return 0
    def api_DeleteCriticalSection(self, r, p): return 0
    def api_GetLastError(self, r): return self.last_error
    def api_SetLastError(self, r, e): self.last_error = e; return 0
    def api_SetUnhandledExceptionFilter(self, r, f): return 0
    def api_UnhandledExceptionFilter(self, r, p): return 1
    def api_GetACP(self, r): return 1252
    def api_GetOEMCP(self, r): return 437
    def api_GetCPInfo(self, r, cp, p):
        self.mem.write(p, bytes(20)); self.mem.w32(p, 1); return 1
    def api_GetStdHandle(self, r, n): return 0x300 + (n & 0xff)
    def api_GetFileType(self, r, h): return 2
    def api_SetHandleCount(self, r, n): return n
    def api_ExitProcess(self, r, code):
        raise StopRun('ExitProcess(%d)' % code)
    def api_TerminateProcess(self, r, h, code): raise StopRun('TerminateProcess(%d)' % code)
    def api_GetSystemInfo(self, r, p):
        self.mem.write(p, bytes(36)); self.mem.w32(p + 4, PAGE); self.mem.w32(p + 20, 1); return 0
    def api_QueryPerformanceFrequency(self, r, p): self.mem.w32(p, 1000000); self.mem.w32(p + 4, 0); return 1
    def api_QueryPerformanceCounter(self, r, p):
        t = int((time.time() - T0) * 1000000); self.mem.w32(p, t & 0xffffffff); self.mem.w32(p + 4, t >> 32); return 1
    def api_GetTickCount(self, r): return (self.vclock + int((time.time() - T0) * 1000)) & 0xffffffff
    def api_timeGetTime(self, r): return self.api_GetTickCount(r)
    def api_Sleep(self, r, ms): return 0
    def api_GetKeyboardType(self, r, n): return 4 if n == 0 else 0
    def api_GetSystemMetrics(self, r, n): return {0: 1024, 1: 768, 4: 19, 6: 1, 7: 1, 15: 4, 16: 1024, 17: 768, 80: 1}.get(n, 0)
    def api_GetDC(self, r, h): return self.handle('dc')
    def api_ReleaseDC(self, r, h, dc): return 1
    def api_GetDeviceCaps(self, r, dc, n): return {8: 1024, 10: 768, 12: 32, 14: 1, 88: 96, 90: 96}.get(n, 0)
    def api_RegOpenKeyExA(self, r, k, sub, o, sam, out):
        self.log.write('  RegOpenKeyExA(%s)\n' % self.mem.cstr(sub)); return 2
    def api_RegCreateKeyExA(self, r, k, sub, res, cls, opt, sam, sec, out, disp):
        self.log.write('  RegCreateKeyExA(%s)\n' % self.mem.cstr(sub)); self.mem.w32(out, self.handle('key')); return 0
    def api_RegQueryValueExA(self, r, k, name, res, typ, data, size):
        self.log.write('  RegQueryValueExA(%s)\n' % (self.mem.cstr(name) if name else '')); return 2
    def api_RegSetValueExA(self, r, k, name, res, typ, data, size): return 0
    def api_RegCloseKey(self, r, k): return 0
    def api_GetCurrentDirectoryA(self, r, n, buf): s = b'C:\\GAME\0'; self.mem.write(buf, s[:n]); return 7
    def api_SetCurrentDirectoryA(self, r, p): self.log.write('  SetCurrentDirectoryA(%s)\n' % self.mem.cstr(p)); return 1
    def api_GetWindowsDirectoryA(self, r, buf, n): s = b'C:\\WINDOWS\0'; self.mem.write(buf, s[:n]); return 10
    def api_GetSystemDirectoryA(self, r, buf, n): s = b'C:\\WINDOWS\\SYSTEM32\0'; self.mem.write(buf, s[:n]); return 19
    # ---- virtual file system: a host directory stands for the game folder (never the real install) ----
    def fs_path(self, win, must_exist=True):
        win = win.replace('/', '\\')
        if len(win) > 1 and win[1] == ':': win = win[2:]
        parts = [x for x in win.split('\\') if x and x != '.']
        if parts[:1] == ['GAME']: parts = parts[1:]
        cur = GAMEDIR
        for i, part in enumerate(parts):
            names = os.listdir(cur) if os.path.isdir(cur) else []
            hit = next((n for n in names if n.lower() == part.lower()), None)
            if hit is None:
                if must_exist or i < len(parts) - 1: return None
                hit = part
            cur = os.path.join(cur, hit)
        return cur
    def fs_log(self, what, win):
        self.file_log.append((what, win))
        self.log.write('  FILE %s %s\n' % (what, win))
    def api_GetFileAttributesA(self, r, p):
        win = self.mem.cstr(p); h = self.fs_path(win); self.fs_log('attr', win)
        if h is None: self.last_error = 2; return 0xffffffff
        return 0x10 if os.path.isdir(h) else 0x80
    def api_PathFileExistsA(self, r, p): return 0 if self.fs_path(self.mem.cstr(p)) is None else 1
    def api_PathAppendA(self, r, p, more):
        a, b = self.mem.cstr(p), self.mem.cstr(more)
        self.mem.write(p, (a.rstrip('\\') + '\\' + b.lstrip('\\')).encode('latin-1') + b'\0'); return 1
    def api_CopyFileA(self, r, src, dst, fail_if_exists):
        a, b = self.mem.cstr(src), self.mem.cstr(dst); self.fs_log('copy %s ->' % a, b)
        hs = self.fs_path(a)
        if hs is None: self.last_error = 2; return 0
        hd = self.fs_path(b, must_exist=False)
        if hd is None: self.last_error = 3; return 0
        if os.path.exists(hd) and fail_if_exists: self.last_error = 80; return 0
        with open(hs, 'rb') as f: data = f.read()
        with open(hd, 'wb') as f: f.write(data)
        return 1
    def api_DeleteFileA(self, r, p): self.fs_log('delete', self.mem.cstr(p)); return 1
    def api_CreateFileA(self, r, p, acc, share, sec, disp, flags, tmpl):
        win = self.mem.cstr(p); self.fs_log('open', win)
        h = self.fs_path(win, must_exist=disp in (3,))
        if h is None or (disp == 1 and os.path.exists(h)):
            self.last_error = 2 if h is None else 80; return 0xffffffff
        if not os.path.exists(h) or disp in (2, 5):
            if not (acc & 0x40000000): self.last_error = 2; return 0xffffffff
            open(h, 'wb').close()
        self.files_opened += 1
        if self.first_data_file is None and os.path.splitext(win)[1].lower() not in ('.ini', '.exe', '.dll'):
            self.first_data_file = win
        return self.handle('file', [h, 0])
    def _file(self, h):
        kind, obj = self.handles.get(h, (None, None))
        return obj if kind == 'file' else None
    def api_ReadFile(self, r, h, buf, n, out, ovl):
        f = self._file(h)
        if f is None: self.last_error = 6; return 0
        with open(f[0], 'rb') as fh:
            fh.seek(f[1]); data = fh.read(n)
        f[1] += len(data)
        if data: self.mem.write(buf, data)
        if out: self.mem.u32w(out, len(data))
        return 1
    def api_WriteFile(self, r, h, buf, n, out, ovl):
        f = self._file(h)
        if f is None:
            if h in (0x13, 0x17): self.log.write('  stdout: %r\n' % self.mem.read(buf, n)); return 1
            self.last_error = 6; return 0
        with open(f[0], 'r+b') as fh:
            fh.seek(f[1]); fh.write(self.mem.read(buf, n))
        f[1] += n
        if out: self.mem.u32w(out, n)
        return 1
    def api_SetFilePointer(self, r, h, dist, high, method):
        f = self._file(h)
        if f is None: self.last_error = 6; return 0xffffffff
        d = dist - (1 << 32) if dist & 0x80000000 else dist
        size = os.path.getsize(f[0])
        f[1] = max(0, (d, f[1] + d, size + d)[method])
        if high: self.mem.u32w(high, 0)
        return f[1]
    def api_GetFileSize(self, r, h, high):
        f = self._file(h)
        if f is None: self.last_error = 6; return 0xffffffff
        if high: self.mem.u32w(high, 0)
        return os.path.getsize(f[0])
    def api_SetEndOfFile(self, r, h): return 1
    def api_FlushFileBuffers(self, r, h): return 1
    def api_CloseHandle(self, r, h): self.handles.pop(h, None); return 1
    # events: manual/auto reset flag and signalled state; waits never block (single guest thread, virtual clock)
    def api_CreateEventA(self, r, attrs, manual, initial, name): return self.handle('event', {'manual': manual, 'set': initial})
    def wait_one(self, h):
        k = self.handles.get(h)
        if k and k[0] == 'event':
            if k[1]['set']:
                if not k[1]['manual']: k[1]['set'] = 0
                return True
            return False
        return True                                                  # other handles (threads, processes) count as signalled
    def api_WaitForSingleObject(self, r, h, ms):
        if self.wait_one(h): return 0
        self.vclock += ms if ms != 0xffffffff else 5
        return 0x102
    def api_WaitForMultipleObjects(self, r, n, ptr, wait_all, ms):
        hs = [self.mem.u32(ptr + 4 * i) for i in range(n)]
        if wait_all:
            if all(self.handles.get(h, ('', {'set': 1}))[1].get('set', 1) for h in hs):
                for h in hs: self.wait_one(h)
                return 0
        else:
            for i, h in enumerate(hs):
                if self.wait_one(h): return i
        self.vclock += ms if ms != 0xffffffff else 5            # the wait times out on the virtual clock
        return 0x102
    def api_SetEvent(self, r, h):
        k = self.handles.get(h)
        if k and k[0] == 'event': k[1]['set'] = 1
        return 1
    def api_ResetEvent(self, r, h):
        k = self.handles.get(h)
        if k and k[0] == 'event': k[1]['set'] = 0
        return 1
    def find_data(self, out, path):
        name = os.path.basename(path).encode('latin-1')[:259]
        st = os.stat(path)
        self.mem.write(out, struct.pack('<I', 0x10 if os.path.isdir(path) else 0x80) + bytes(24) + struct.pack('<II', 0, st.st_size & 0xffffffff) + bytes(8) + name + bytes(260 - len(name)) + bytes(14))
    def api_FindFirstFileA(self, r, p, out):
        import fnmatch
        win = self.mem.cstr(p); self.fs_log('find', win)
        d, pat = win.rsplit('\\', 1) if '\\' in win else ('', win)
        hd = self.fs_path(d or 'C:\\GAME')
        names = sorted(n for n in (os.listdir(hd) if hd and os.path.isdir(hd) else []) if fnmatch.fnmatch(n.lower(), pat.lower()))
        if not names: self.last_error = 2; return 0xffffffff
        self.find_data(out, os.path.join(hd, names[0]))
        return self.handle('find', [hd, names, 1])
    def api_FindNextFileA(self, r, h, out):
        kind, obj = self.handles.get(h, (None, None))
        if kind != 'find' or obj[2] >= len(obj[1]): self.last_error = 18; return 0
        self.find_data(out, os.path.join(obj[0], obj[1][obj[2]])); obj[2] += 1
        return 1
    def ini_read(self, path):
        import configparser
        h = self.fs_path(self.mem.cstr(path)) if path else None
        cp = configparser.RawConfigParser(strict=False); cp.optionxform = str
        if h and os.path.isfile(h):
            try: cp.read(h, encoding='latin-1')
            except Exception: pass
        return cp
    def ini_get(self, cp, sec, key):
        for s in cp.sections():
            if s.lower() == sec.lower():
                for k, v in cp.items(s):
                    if k.lower() == key.lower(): return v
        return None
    def api_GetPrivateProfileIntA(self, r, sec, key, dflt, path):
        v = self.ini_get(self.ini_read(path), self.mem.cstr(sec), self.mem.cstr(key))
        try: return int(v.strip(), 0) & 0xffffffff
        except Exception: return dflt
    def api_GetPrivateProfileStringA(self, r, sec, key, dflt, buf, n, path):
        v = self.ini_get(self.ini_read(path), self.mem.cstr(sec), self.mem.cstr(key)) if sec and key else None
        if v is None: v = self.mem.cstr(dflt) if dflt else ''
        d = v.encode('latin-1')[:max(n - 1, 0)]
        self.mem.write(buf, d + b'\0')
        return len(d)
    def api_FindClose(self, r, h): return 1
    def api_GetDriveTypeA(self, r, p): return 3
    def api_GetLogicalDrives(self, r): return 0x4
    def api_MessageBoxA(self, r, h, text, cap, flags):
        self.log.write('  MessageBoxA(%r, %r)\n' % (self.mem.cstr(text) if text else '', self.mem.cstr(cap) if cap else ''))
        raise StopRun('MessageBoxA: %r' % (self.mem.cstr(text) if text else ''))
    def api_LoadCursorA(self, r, h, name): return self.handle('cursor')
    def api_LoadIconA(self, r, h, name): return self.handle('icon')
    def api_LoadImageA(self, r, h, name, kind, cx, cy, flags): return self.handle('image')
    def api_RegisterClassA(self, r, wc):
        proc = self.mem.u32(wc + 4); name = self.mem.u32(wc + 36)
        n = self.mem.cstr(name) if name >= 0x10000 else '#%d' % name
        atom = 0xc000 + len(self.wndclasses); self.wndclasses[n] = proc; self.wndclasses[atom] = proc
        self.log.write('  RegisterClassA(%r, proc=0x%x)\n' % (n, proc)); return atom
    def api_RegisterClassExA(self, r, wc):
        proc = self.mem.u32(wc + 8); name = self.mem.u32(wc + 40)
        n = self.mem.cstr(name) if name >= 0x10000 else '#%d' % name
        atom = 0xc000 + len(self.wndclasses); self.wndclasses[n] = proc; self.wndclasses[atom] = proc
        self.log.write('  RegisterClassExA(%r, proc=0x%x)\n' % (n, proc)); return atom
    def api_GetClassInfoA(self, r, h, name, out):
        n = self.mem.cstr(name) if name >= 0x10000 else name
        return 1 if n in self.wndclasses else 0
    def api_GetClassInfoExA(self, r, h, name, out):
        n = self.mem.cstr(name) if name >= 0x10000 else name
        return 1 if n in self.wndclasses else 0
    def api_CreateWindowExA(self, r, ex, cls, title, style, x, y, w, hgt, parent, menu, inst, param):
        n = self.mem.cstr(cls) if cls >= 0x10000 else cls
        t = self.mem.cstr(title) if title else ''
        hwnd = self.handle('window', n)
        if x == 0x80000000: x = 0
        if y == 0x80000000: y = 0
        if w == 0x80000000: w = 640
        if hgt == 0x80000000: hgt = 480
        self.log.write('  CreateWindowExA(class=%r, title=%r, style=0x%x, %dx%d) -> hwnd 0x%x\n' % (n, t, style, w, hgt, hwnd))
        self.windows[hwnd] = {'cls': n, 'proc': self.wndclasses.get(n), 'title': t, 'style': style, 'ex': ex, 'rect': (x, y, x + w, y + hgt),
                              'parent': parent, 'user': 0, 'id': menu if parent else 0, 'visible': False}
        self.reached_create_window = True
        cs = self.alloc(48)
        self.mem.w32(cs, param); self.mem.w32(cs + 4, inst); self.mem.w32(cs + 8, menu); self.mem.w32(cs + 12, parent)
        self.mem.w32(cs + 16, hgt); self.mem.w32(cs + 20, w); self.mem.w32(cs + 24, y); self.mem.w32(cs + 28, x)
        self.mem.w32(cs + 32, style); self.mem.w32(cs + 36, title); self.mem.w32(cs + 40, cls); self.mem.w32(cs + 44, ex)
        hook = self.hooks.get(5)                 # WH_CBT: MFC attaches its CWnd and subclasses here
        if hook:
            cbt = self.alloc(8); self.mem.w32(cbt, cs); self.mem.w32(cbt + 4, 0)
            self.call(hook, 3, hwnd, cbt)        # HCBT_CREATEWND
        if self.windows[hwnd]['proc']:
            self.send(hwnd, 0x0081, 0, cs)       # WM_NCCREATE
            self.send(hwnd, 0x0001, 0, cs)       # WM_CREATE
        if style & 0x10000000:                   # WS_VISIBLE
            self.show_window(hwnd)
        return hwnd
    def api_DestroyWindow(self, r, hwnd):
        if hwnd in self.windows:
            self.send(hwnd, 0x0002, 0, 0); self.send(hwnd, 0x0082, 0, 0)   # WM_DESTROY, WM_NCDESTROY
        return 1
    def api_CallNextHookEx(self, r, hook, code, wp, lp): return 0
    def api_CallWindowProcA(self, r, proc, hwnd, msg, wp, lp): return self.call(proc, hwnd, msg, wp, lp)
    def api_IsWindowEnabled(self, r, hwnd): return 1
    def api_EnableWindow(self, r, hwnd, en): return 0
    def api_GetTopWindow(self, r, hwnd): return 0
    def api_GetWindow(self, r, hwnd, cmd): return 0
    def api_GetDlgItem(self, r, hwnd, id_): return 0
    def api_LoadAcceleratorsA(self, r, inst, name): return self.handle('accel')
    def api_BeginDeferWindowPos(self, r, n): return self.handle('dwp')
    def api_DeferWindowPos(self, r, dwp, hwnd, after, x, y, cx, cy, flags): return dwp
    def api_EndDeferWindowPos(self, r, dwp): return 1
    def api_GetCapture(self, r): return 0
    def api_SetCapture(self, r, hwnd): return 0
    def api_ReleaseCapture(self, r): return 1
    def api_ClientToScreen(self, r, hwnd, pt): return 1
    def api_ScreenToClient(self, r, hwnd, pt): return 1
    def api_GetSystemMenu(self, r, hwnd, revert): return self.handle('menu')
    def api_GetMenu(self, r, hwnd): return 0
    def api_SetMenu(self, r, hwnd, menu): return 1
    def api_DrawMenuBar(self, r, hwnd): return 1
    def api_SetWindowTextA(self, r, hwnd, text): return 1
    def api_GetWindowTextA(self, r, hwnd, buf, n):
        t = self.windows.get(hwnd, {}).get('title', '').encode('latin-1')[:max(n - 1, 0)]; self.mem.write(buf, t + b'\0'); return len(t)
    def api_GetWindowTextLengthA(self, r, hwnd): return len(self.windows.get(hwnd, {}).get('title', ''))
    def api_SetRect(self, r, p, l, t, rt, b): self.mem.write(p, struct.pack('<iiii', l, t, rt, b)); return 1
    def api_CopyRect(self, r, d, s_): self.mem.write(d, self.mem.read(s_, 16)); return 1
    def api_IntersectRect(self, r, d, a, b):
        al, at, ar, ab = struct.unpack('<iiii', self.mem.read(a, 16)); bl, bt, br, bb = struct.unpack('<iiii', self.mem.read(b, 16))
        l, t, rt, bo = max(al, bl), max(at, bt), min(ar, br), min(ab, bb)
        if rt <= l or bo <= t: self.mem.write(d, bytes(16)); return 0
        self.mem.write(d, struct.pack('<iiii', l, t, rt, bo)); return 1
    def api_PtInRect(self, r, p, x, y):
        l, t, rt, b = struct.unpack('<iiii', self.mem.read(p, 16)); x = x - (1 << 32) if x & 0x80000000 else x; y = y - (1 << 32) if y & 0x80000000 else y
        return 1 if l <= x < rt and t <= y < b else 0
    def api_IsRectEmpty(self, r, p):
        l, t, rt, b = struct.unpack('<iiii', self.mem.read(p, 16)); return 1 if rt <= l or b <= t else 0
    def api_OffsetRect(self, r, p, dx, dy):
        l, t, rt, b = struct.unpack('<iiii', self.mem.read(p, 16)); dx = dx - (1 << 32) if dx & 0x80000000 else dx; dy = dy - (1 << 32) if dy & 0x80000000 else dy
        self.mem.write(p, struct.pack('<iiii', l + dx, t + dy, rt + dx, b + dy)); return 1
    def api_SetWindowsHookExA(self, r, kind, proc, inst, tid):
        self.hooks[kind] = proc; return self.handle('hook', kind)
    def api_UnhookWindowsHookEx(self, r, h):
        kind = self.handles.get(h, (None, None))[1]
        self.hooks.pop(kind, None); return 1
    def send(self, hwnd, msg, wp, lp):
        wnd = self.windows.get(hwnd)
        proc = wnd['proc'] if wnd else 0
        if not proc:
            return 0
        if self.msg_log < 400 or msg not in (0x0113, 0x000f, 0x0020, 0x0084, 0x0200):
            self.msg_log += 1
            self.log.write('  -> WndProc 0x%x(hwnd=0x%x, msg=0x%04x, wp=0x%x, lp=0x%x)\n' % (proc, hwnd, msg, wp, lp))
        return self.call(proc, hwnd, msg, wp, lp)
    def api_SendMessageA(self, r, hwnd, msg, wp, lp): return self.send(hwnd, msg, wp, lp)
    def api_PostMessageA(self, r, hwnd, msg, wp, lp): self.msgq.append((hwnd, msg, wp, lp)); return 1
    def api_PostQuitMessage(self, r, code): self.msgq.append((0, 0x0012, code, 0)); return 0
    def api_DefWindowProcA(self, r, hwnd, msg, wp, lp):
        if msg == 0x0081: return 1               # WM_NCCREATE
        if msg == 0x0083 or msg == 0x0005: return 0
        return 0
    def api_SetWindowLongA(self, r, hwnd, i, v):
        wnd = self.windows.get(hwnd)
        if not wnd: return 0
        i = i - (1 << 32) if i & 0x80000000 else i
        key = {-4: 'proc', -16: 'style', -20: 'ex', -21: 'user', -12: 'id'}.get(i)
        if key is None: return 0
        old = wnd[key]; wnd[key] = v
        if key == 'proc': self.log.write('  subclass hwnd 0x%x: proc 0x%x -> 0x%x\n' % (hwnd, old or 0, v))
        return old or 0
    def api_GetWindowLongA(self, r, hwnd, i):
        wnd = self.windows.get(hwnd)
        if not wnd: return 0
        i = i - (1 << 32) if i & 0x80000000 else i
        key = {-4: 'proc', -16: 'style', -20: 'ex', -21: 'user', -12: 'id'}.get(i)
        return (wnd[key] or 0) if key else 0
    def show_window(self, hwnd):
        wnd = self.windows[hwnd]
        if wnd['visible']: return
        wnd['visible'] = True
        l, t, rt, b = wnd['rect']
        self.send(hwnd, 0x0018, 1, 0)                                   # WM_SHOWWINDOW
        self.send(hwnd, 0x0005, 0, ((b - t) << 16) | ((rt - l) & 0xffff))  # WM_SIZE
        self.send(hwnd, 0x001c, 1, 0)                                   # WM_ACTIVATEAPP
        self.send(hwnd, 0x0086, 1, 0)                                   # WM_NCACTIVATE
        self.send(hwnd, 0x0006, 1, 0)                                   # WM_ACTIVATE
        self.send(hwnd, 0x0007, 0, 0)                                   # WM_SETFOCUS
        self.msgq.append((hwnd, 0x000f, 0, 0))                          # WM_PAINT
    def api_ShowWindow(self, r, hwnd, cmd):
        self.log.write('  ShowWindow(0x%x, %d)\n' % (hwnd, cmd))
        if cmd and hwnd in self.windows: self.show_window(hwnd)
        return 0
    def api_UpdateWindow(self, r, hwnd): self.send(hwnd, 0x000f, 0, 0); return 1
    def api_InvalidateRect(self, r, hwnd, rect, erase):
        if (hwnd, 0x000f, 0, 0) not in self.msgq: self.msgq.append((hwnd, 0x000f, 0, 0))
        return 1
    def api_ValidateRect(self, r, hwnd, rect): return 1
    def api_BeginPaint(self, r, hwnd, ps):
        wnd = self.windows.get(hwnd); l, t, rt, b = wnd['rect'] if wnd else (0, 0, 640, 480)
        self.mem.write(ps, struct.pack('<IIiiii', self.handle('dc'), 0, 0, 0, rt - l, b - t) + bytes(64 - 24)); return self.mem.u32(ps)
    def api_EndPaint(self, r, hwnd, ps): return 1
    def api_GetClientRect(self, r, hwnd, p):
        wnd = self.windows.get(hwnd); l, t, rt, b = wnd['rect'] if wnd else (0, 0, 640, 480)
        self.mem.write(p, struct.pack('<iiii', 0, 0, rt - l, b - t)); return 1
    def api_GetWindowRect(self, r, hwnd, p):
        wnd = self.windows.get(hwnd); self.mem.write(p, struct.pack('<iiii', *(wnd['rect'] if wnd else (0, 0, 640, 480)))); return 1
    def api_SetFocus(self, r, hwnd): old = getattr(self, 'focus', 0); self.focus = hwnd; return old
    def api_GetFocus(self, r): return getattr(self, 'focus', 0)
    def api_SetActiveWindow(self, r, hwnd): return 0
    def api_GetActiveWindow(self, r): return getattr(self, 'focus', 0)
    def api_GetForegroundWindow(self, r): return getattr(self, 'focus', 0)
    def api_SetForegroundWindow(self, r, hwnd): return 1
    def api_IsWindow(self, r, hwnd): return 1 if hwnd in self.windows else 0
    def api_IsWindowVisible(self, r, hwnd): return 1 if hwnd in self.windows and self.windows[hwnd]['visible'] else 0
    def api_GetParent(self, r, hwnd): return self.windows.get(hwnd, {}).get('parent', 0)
    def api_SetWindowPos(self, r, hwnd, after, x, y, cx, cy, flags):
        wnd = self.windows.get(hwnd)
        if wnd and not flags & 0x1: wnd['rect'] = (x, y, x + cx, y + cy) if not flags & 0x2 else (x, y, x + (wnd['rect'][2] - wnd['rect'][0]), y + (wnd['rect'][3] - wnd['rect'][1]))
        return 1
    def api_MoveWindow(self, r, hwnd, x, y, w, h, repaint):
        wnd = self.windows.get(hwnd)
        if wnd: wnd['rect'] = (x, y, x + w, y + h)
        return 1
    def api_SetTimer(self, r, hwnd, tid, elapse, proc):
        tid = tid or (len(self.timers) + 1)
        self.timers[(hwnd, tid)] = (max(elapse, 1), proc, self.vclock)
        self.log.write('  SetTimer(hwnd=0x%x, id=%d, %d ms)\n' % (hwnd, tid, elapse)); return tid
    def api_KillTimer(self, r, hwnd, tid): self.timers.pop((hwnd, tid), None); return 1
    def fill_msg(self, p, m):
        hwnd, msg, wp, lp = m
        self.mem.write(p, struct.pack('<IIIIIii', hwnd, msg, wp, lp, self.vclock & 0xffffffff, 320, 240))
    def next_message(self):
        """the queue, then a due timer; the virtual clock advances 5 ms per empty poll"""
        if self.msgq:
            return self.msgq.popleft()
        self.vclock += 5
        self.idle_polls += 1
        if self.idle_polls in (200, 2000):
            self.log.write('IDLE SAMPLE at poll %d, last native calls: %s\n' % (self.idle_polls, ' '.join('0x%x' % t for t in self.ring[-80:])))
        for (hwnd, tid), (elapse, proc, last) in list(self.timers.items()):
            if self.vclock - last >= elapse:
                self.timers[(hwnd, tid)] = (elapse, proc, self.vclock)
                return (hwnd, 0x0113, tid, proc)
        return None
    def api_PeekMessageA(self, r, msg, hwnd, a, b, flags):
        m = self.next_message()
        if m is None:
            if self.idle_polls > self.max_idle_polls: raise StopRun('message loop idle for %d polls' % self.idle_polls)
            return 0
        self.fill_msg(msg, m)
        if not flags & 1: self.msgq.appendleft(m)        # PM_NOREMOVE
        return 1
    def api_GetMessageA(self, r, msg, hwnd, a, b):
        while True:
            m = self.next_message()
            if m is not None: break
            if self.idle_polls > self.max_idle_polls: raise StopRun('message loop idle for %d polls' % self.idle_polls)
        self.fill_msg(msg, m)
        return 0 if m[1] == 0x0012 else 1
    def api_TranslateMessage(self, r, msg): return 0
    def api_DispatchMessageA(self, r, msg):
        hwnd, m, wp, lp = struct.unpack('<IIII', self.mem.read(msg, 16))
        if m == 0x0113 and lp:                           # WM_TIMER with a TIMERPROC
            return self.call(lp, hwnd, m, wp, self.vclock)
        return self.send(hwnd, m, wp, lp)
    def api_GetTimeZoneInformation(self, r, out): self.mem.write(out, bytes(172)); return 0
    def api_GetComputerNameA(self, r, buf, n): self.mem.write(buf, b'SPIKE\0'); self.mem.w32(n, 5); return 1
    def api_GlobalMemoryStatus(self, r, ms):
        self.mem.write(ms, struct.pack('<8I', 32, 40, 512 << 20, 300 << 20, 1024 << 20, 900 << 20, 2047 << 20, 1900 << 20))
    def api_SetRectEmpty(self, r, p): self.mem.write(p, bytes(16)); return 1
    def api_FindWindowA(self, r, cls, title): return 0
    def api_LoadStringA(self, r, inst, sid, buf, n):
        s = self.resource_string(sid)
        self.log.write('  LoadStringA(%d) -> %r\n' % (sid, s))
        data = s.encode('latin-1')[:n - 1] + b'\0'
        self.mem.write(buf, data)
        return len(data) - 1
    def resource_string(self, sid):
        try:
            for e in self.pe.DIRECTORY_ENTRY_RESOURCE.entries:
                if e.id != 6:
                    continue
                for blk in e.directory.entries:
                    if blk.id != (sid >> 4) + 1:
                        continue
                    lang = blk.directory.entries[0]
                    data = self.pe.get_data(lang.data.struct.OffsetToData, lang.data.struct.Size)
                    pos = 0
                    for i in range(16):
                        ln = struct.unpack_from('<H', data, pos)[0]; pos += 2
                        if i == (sid & 15):
                            return data[pos:pos + 2 * ln].decode('utf-16-le')
                        pos += 2 * ln
        except Exception:
            pass
        return ''
    def api_FindResourceA(self, r, h, name, typ):
        n = self.mem.cstr(name) if name >= 0x10000 else name
        t = self.mem.cstr(typ) if typ >= 0x10000 else typ
        self.log.write('  FindResourceA(%r, %r)\n' % (n, t))
        try:
            for e in self.pe.DIRECTORY_ENTRY_RESOURCE.entries:
                if (e.id if e.name is None else e.name.decode()) != t:
                    continue
                for blk in e.directory.entries:
                    if (blk.id if blk.name is None else blk.name.decode()) != n:
                        continue
                    lang = blk.directory.entries[0]
                    return self.handle('res', (IMAGE_BASE + lang.data.struct.OffsetToData, lang.data.struct.Size))
        except Exception:
            pass
        return 0
    def api_LoadResource(self, r, h, res): return res
    def api_LockResource(self, r, res): return self.handles.get(res, (None, (0, 0)))[1][0]
    def api_SizeofResource(self, r, h, res): return self.handles.get(res, (None, (0, 0)))[1][1]
    def api_FreeResource(self, r, res): return 0
    def api_MultiByteToWideChar(self, r, cp, flags, src, n, dst, dn):
        s = self.mem.read(src, n) if n != 0xffffffff else self.mem.cstr(src).encode('latin-1') + b'\0'
        w = s.decode('latin-1').encode('utf-16-le')
        if dn: self.mem.write(dst, w[:2 * dn])
        return len(w) // 2
    def api_WideCharToMultiByte(self, r, cp, flags, src, n, dst, dn, dc, used):
        s = self.mem.read(src, 2 * n) if n != 0xffffffff else (self.wstr(src) + '\0').encode('utf-16-le')
        a = s.decode('utf-16-le').encode('latin-1', 'replace')
        if dn: self.mem.write(dst, a[:dn])
        return len(a)
    def api_GetStringTypeA(self, r, loc, kind, src, n, out):
        for i in range(n if n != 0xffffffff else 0):
            c = self.mem.read(src + i, 1)[0]
            v = 0
            if 48 <= c <= 57: v |= 0x4 | 0x80
            if 65 <= c <= 90: v |= 0x1 | 0x100 | 0x80
            if 97 <= c <= 122: v |= 0x2 | 0x100 | 0x80
            if c in (32, 9, 10, 13): v |= 0x8 | 0x40
            if 33 <= c <= 47 or 58 <= c <= 64: v |= 0x10
            self.mem.w16(out + 2 * i, v)
        return 1
    def api_GetStringTypeW(self, r, kind, src, n, out): return self.api_GetStringTypeA(r, 0, kind, src, n, out)
    def api_LCMapStringA(self, r, loc, flags, src, n, dst, dn):
        s = self.mem.read(src, n) if n != 0xffffffff else self.mem.cstr(src).encode('latin-1') + b'\0'
        if flags & 0x100: s = s.lower()
        if flags & 0x200: s = s.upper()
        if dn: self.mem.write(dst, s[:dn])
        return len(s)
    def api_LCMapStringW(self, r, loc, flags, src, n, dst, dn): return 0
    def api_IsBadReadPtr(self, r, p, n): return 0
    def api_IsBadWritePtr(self, r, p, n): return 0
    def api_IsBadCodePtr(self, r, p): return 0
    def api_IsBadStringPtrA(self, r, p, n): return 0
    def api_GetUserDefaultLCID(self, r): return 0x409
    def api_GetThreadLocale(self, r): return 0x409
    def api_GetLocaleInfoA(self, r, loc, t, buf, n):
        self.mem.write(buf, b'1\0'[:max(n, 0)]); return 2
    def api_InterlockedIncrement(self, r, p): v = (self.mem.u32(p) + 1) & 0xffffffff; self.mem.w32(p, v); return v
    def api_InterlockedDecrement(self, r, p): v = (self.mem.u32(p) - 1) & 0xffffffff; self.mem.w32(p, v); return v
    def api_InterlockedExchange(self, r, p, v): old = self.mem.u32(p); self.mem.w32(p, v); return old
    def api_lstrlenA(self, r, p): return len(self.mem.cstr(p))
    def api_lstrcpyA(self, r, d, s): self.mem.write(d, self.mem.cstr(s).encode('latin-1') + b'\0'); return d
    def api_lstrcpynA(self, r, d, s, n): self.mem.write(d, (self.mem.cstr(s).encode('latin-1')[:n - 1] + b'\0')); return d
    def api_lstrcatA(self, r, d, s): self.mem.write(d + len(self.mem.cstr(d)), self.mem.cstr(s).encode('latin-1') + b'\0'); return d
    def api_lstrcmpA(self, r, a, b): x, y = self.mem.cstr(a), self.mem.cstr(b); return (x > y) - (x < y)
    def api_lstrcmpiA(self, r, a, b): x, y = self.mem.cstr(a).lower(), self.mem.cstr(b).lower(); return (x > y) - (x < y)
    def api_CharUpperA(self, r, p):
        if p >= 0x10000: self.mem.write(p, self.mem.cstr(p).upper().encode('latin-1') + b'\0'); return p
        return ord(chr(p & 0xff).upper())
    def api_CharNextA(self, r, p): return p + (1 if self.mem.read(p, 1) != b'\0' else 0)
    def api_GetKeyState(self, r, k): return 0
    def api_GetCursorPos(self, r, p): self.mem.w32(p, 320); self.mem.w32(p + 4, 240); return 1
    def api_SetCursor(self, r, c): return 0
    def api_ShowCursor(self, r, b):
        self.cursor_count = getattr(self, 'cursor_count', 0) + (1 if b else -1)
        return self.cursor_count & 0xffffffff
    def api_GetDesktopWindow(self, r): return 0x10
    def api_SystemParametersInfoA(self, r, a, b, p, f):
        if a == 0x30 and p: self.mem.write(p, struct.pack('<iiii', 0, 0, 1024, 768))
        return 1
    def api_GetSysColor(self, r, i): return 0xc0c0c0
    def api_SHGetSpecialFolderPathA(self, r, hwnd, buf, csidl, create):
        self.mem.write(buf, b'C:\\GAME\\Documents%d\0' % csidl)
        os.makedirs(os.path.join(GAMEDIR, 'Documents%d' % csidl), exist_ok=True); return 1
    def api_CreateDirectoryA(self, r, p, sec):
        win = self.mem.cstr(p); self.fs_log('mkdir', win)
        h = self.fs_path(win, must_exist=False)
        if h is None: self.last_error = 3; return 0
        if os.path.exists(h): self.last_error = 183; return 0
        os.makedirs(h); return 1
    def api_RemoveDirectoryA(self, r, p): return 1
    def systemtime(self, out):
        t = time.localtime()
        self.mem.write(out, struct.pack('<8H', t.tm_year, t.tm_mon, (t.tm_wday + 1) % 7, t.tm_mday, t.tm_hour, t.tm_min, t.tm_sec, 0))
    def api_GetLocalTime(self, r, out): self.systemtime(out)
    def api_GetSystemTime(self, r, out): self.systemtime(out)
    def version_block(self):
        if not hasattr(self, '_verblk'):
            self._verblk = b''
            for e in self.pe.DIRECTORY_ENTRY_RESOURCE.entries:
                if e.id == 16:
                    lang = e.directory.entries[0].directory.entries[0]
                    self._verblk = self.pe.get_data(lang.data.struct.OffsetToData, lang.data.struct.Size)
        return self._verblk
    def api_GetFileVersionInfoSizeA(self, r, path, handle_out):
        if handle_out: self.mem.write(handle_out, bytes(4))
        return len(self.version_block())
    def api_GetFileVersionInfoA(self, r, path, h, n, buf):
        blk = self.version_block()[:n]
        self.mem.write(buf, blk)
        return 1 if blk else 0
    def ver_children(self, blk, off):
        # one VS_VERSIONINFO / StringFileInfo / StringTable / String node: (length, value_length, type, key, value_off, children_off)
        length, vlen, typ = struct.unpack_from('<HHH', blk, off)
        key_end = blk.index(b'\0\0', off + 6)
        if (key_end - (off + 6)) % 2: key_end += 1
        key = blk[off + 6:key_end].decode('utf-16-le')
        voff = (key_end + 2 + 3) & ~3
        vbytes = vlen * (2 if typ == 1 else 1)
        coff = (voff + vbytes + 3) & ~3
        return length, vlen, typ, key, voff, vbytes, coff
    def api_VerQueryValueA(self, r, block, sub, out_ptr, out_len):
        blk = self.mem.read(block, 4096)
        path = [x for x in self.mem.cstr(sub).split('\\') if x]
        off, end = 0, struct.unpack_from('<H', blk, 0)[0]
        length, vlen, typ, key, voff, vbytes, coff = self.ver_children(blk, 0)
        if not path:
            self.mem.u32w(out_ptr, block + voff); self.mem.u32w(out_len, vbytes); return 1
        node = (coff, end)
        for part in path:
            o, e = node; found = None
            while o + 6 <= e:
                l, vl, t, k, vo, vb, co = self.ver_children(blk, o)
                if l == 0: break
                if k.lower() == part.lower(): found = (o, l, vo, vb, co); break
                o += (l + 3) & ~3
            if found is None: return 0
            o, l, vo, vb, co = found
            node = (co, o + l); last = (vo, vb)
        self.mem.u32w(out_ptr, block + last[0]); self.mem.u32w(out_len, last[1] if path[0].lower() != 'stringfileinfo' else last[1] // 2 or last[1])
        return 1
    def api_GetKeyboardLayout(self, r, tid): return 0x04090409
    def api_WritePrivateProfileStringA(self, r, sec, key, val, path): return 1
    def api_wsprintfA(self, r, buf, fmt):
        # cdecl varargs: the extra arguments follow fmt on the stack
        text = self.c_format(self.mem.cstr(fmt), lambda i: self.arg(r, 2 + i))
        self.mem.write(buf, text.encode('latin-1', 'replace') + b'\0')
        return len(text)
    def c_format(self, fmt, nth):
        import re
        out, i, n = [], 0, 0
        for m in re.finditer(r'%([-+ 0#]*)(\d*)(?:\.(\d+))?(l|h)?([diuxXcsp%])', fmt):
            out.append(fmt[i:m.start()]); i = m.end()
            conv = m.group(5)
            if conv == '%': out.append('%'); continue
            v = nth(n); n += 1
            if conv == 's': val = self.mem.cstr(v) if v else '(null)'
            elif conv == 'c': val = chr(v & 0xff)
            elif conv in 'di': val = str(v - (1 << 32) if v & 0x80000000 else v)
            else: val = '%' + m.group(1) + m.group(2) + ('.' + m.group(3) if m.group(3) else '') + conv.replace('p', 'x')
            if conv in 'uxXp' or conv in 'di':
                try: val = ('%' + m.group(1) + m.group(2) + ('.' + m.group(3) if m.group(3) else '') + ('d' if conv in 'di' else conv.replace('p', 'x'))) % (v - (1 << 32) if conv in 'di' and v & 0x80000000 else v)
                except Exception: val = str(v)
            out.append(val)
        out.append(fmt[i:])
        return ''.join(out)
    def api_GetSysColorBrush(self, r, i): return self.handle('gdi')
    def api_RegisterWindowMessageA(self, r, name): return 0xc100 + (hash(self.mem.cstr(name)) & 0xff)
    def api_GetProcessVersion(self, r, pid): return 0x00050001
    def api_SetErrorMode(self, r, m): return 0
    def api_GetStringTypeExA(self, r, loc, kind, src, n, out): return self.api_GetStringTypeA(r, loc, kind, src, n, out)
    def api_GetStockObject(self, r, i): return self.handle('gdi')
    def api_CreateSolidBrush(self, r, c): return self.handle('gdi')
    def api_DeleteObject(self, r, h): return 1
    def api_GetObjectA(self, r, h, n, p): return 0
    def api_CoInitialize(self, r, p): return 0
    def api_OleInitialize(self, r, p): return 0
    def api_RaiseException(self, r, code, flags, n, args):
        raise StopRun('RaiseException(0x%08x) (a C++ throw or a fault)' % code)
    # ---- COM objects: a vtable of import-like stubs, methods answered by api_<Interface>_<Method> ----
    def com_class(self, iface, methods):
        if iface in self.com_vtables:
            return self.com_vtables[iface]
        vt = self.alloc(4 * len(methods))
        for i, (name, nargs) in enumerate(methods):
            stub = MAGIC + 0x8000 + 0x10 * self.com_stub_count
            self.com_stub_count += 1
            n = 4 * (nargs + 1)
            self.mem.write(stub, b'\xc2' + struct.pack('<H', n))
            self.imports[stub] = (iface + '_' + name, 'COM', stub, n)
            self.stub_to_slot[stub] = stub
            self.mem.w32(vt + 4 * i, stub)
        self.com_vtables[iface] = vt
        return vt
    def com_new(self, iface, methods, obj):
        p = self.alloc(0x40)
        self.mem.w32(p, self.com_class(iface, methods))
        obj['iface'] = iface
        self.com_objects[p] = obj
        return p
    def com(self, this):
        return self.com_objects.get(this)
    def cstring(self, text):
        p = self.alloc(len(text) + 1)
        self.mem.write(p, text.encode('latin-1') + b'\0')
        return p

    # DirectDraw
    def api_DirectDrawEnumerateExA(self, r, cb, ctx, flags):
        self.reached_ddraw = True
        self.log.write('  DirectDrawEnumerateExA -> one device\n')
        self.call(cb, 0, self.cstring('Primary Display Driver'), self.cstring('display'), ctx, 0)
        return 0
    def ddraw_new(self):
        return self.com_new('IDirectDraw7', DD7_METHODS, {'surfaces': []})
    def api_DirectDrawCreateEx(self, r, guid, out, iid, unk):
        self.reached_ddraw = True
        self.mem.w32(out, self.ddraw_new()); self.log.write('  DirectDrawCreateEx -> IDirectDraw7\n'); return 0
    def api_DirectDrawCreate(self, r, guid, out, unk):
        self.reached_ddraw = True
        self.mem.w32(out, self.ddraw_new()); return 0
    def api_IDirectDraw7_QueryInterface(self, r, this, iid, out): self.mem.w32(out, this); return 0
    def api_IDirectDraw7_AddRef(self, r, this): return 1
    def api_IDirectDraw7_Release(self, r, this): return 0
    def api_IDirectDraw7_SetCooperativeLevel(self, r, this, hwnd, flags):
        self.log.write('  SetCooperativeLevel(hwnd=0x%x, flags=0x%x)\n' % (hwnd, flags)); return 0
    def api_IDirectDraw7_SetDisplayMode(self, r, this, w, h, bpp, rate, flags):
        self.log.write('  SetDisplayMode(%dx%dx%d)\n' % (w, h, bpp)); self.display = (w, h, bpp or 16); return 0
    def api_IDirectDraw7_RestoreDisplayMode(self, r, this): return 0
    def api_IDirectDraw7_GetDisplayMode(self, r, this, desc):
        self.fill_desc(desc, {'w': self.display[0], 'h': self.display[1], 'pitch': self.display[0] * 2, 'caps': 0, 'buf': 0}); return 0
    def api_IDirectDraw7_EnumDisplayModes(self, r, this, flags, desc, ctx, cb):
        for w, h in ((640, 480), (800, 600), (1024, 768)):
            d = self.alloc(0x7c)
            self.fill_desc(d, {'w': w, 'h': h, 'pitch': w * 2, 'caps': 0, 'buf': 0})
            self.mem.w32(d + 0x14, 60)       # dwRefreshRate shares the back-buffer-count slot
            if not self.call(cb, d, ctx): break
        return 0
    def api_IDirectDraw7_GetCaps(self, r, this, caps, hel):
        for p in (caps, hel):
            if not p: continue
            size = self.mem.u32(p)
            self.mem.write(p + 4, bytes(max(size - 4, 0)))
            self.mem.w32(p + 4, 0x40 | 0x4000000 | 0x8000000 | 0x80 | 0x100)     # BLT, BLTCOLORFILL, BLTSTRETCH, BLTQUEUE, CANBLTSYSMEM
            self.mem.w32(p + 0x14, 64 << 20); self.mem.w32(p + 0x18, 64 << 20)  # dwVidMemTotal, dwVidMemFree
        return 0
    def api_IDirectDraw7_GetAvailableVidMem(self, r, this, caps, total, free):
        if total: self.mem.w32(total, 64 << 20)
        if free: self.mem.w32(free, 60 << 20)
        return 0
    def api_IDirectDraw7_GetDeviceIdentifier(self, r, this, ident, flags):
        self.mem.write(ident, bytes(0x4c0))
        self.mem.write(ident, b'display.drv\0'); self.mem.write(ident + 0x200, b'Primary Display Driver\0')
        self.mem.w32(ident + 0x400, 0x5000f); self.mem.w32(ident + 0x404, 0x0007000d)   # driver version
        return 0
    def api_IDirectDraw7_GetMonitorFrequency(self, r, this, out): self.mem.w32(out, 60); return 0
    def api_IDirectDraw7_WaitForVerticalBlank(self, r, this, flags, ev): return 0
    def api_IDirectDraw7_TestCooperativeLevel(self, r, this): return 0
    def api_IDirectDraw7_RestoreAllSurfaces(self, r, this): return 0
    def api_IDirectDraw7_FlipToGDISurface(self, r, this): return 0
    def api_IDirectDraw7_GetGDISurface(self, r, this, out):
        prim = next((p for p, o in self.com_objects.items() if o.get('primary')), 0)
        self.mem.w32(out, prim); return 0 if prim else 0x887601c2
    def api_IDirectDraw7_CreateClipper(self, r, this, flags, out, unk):
        self.mem.w32(out, self.com_new('IDirectDrawClipper', CLIPPER_METHODS, {})); return 0
    def api_IDirectDrawClipper_SetHWnd(self, r, this, flags, hwnd): return 0
    def api_IDirectDrawClipper_Release(self, r, this): return 0
    def api_IDirectDraw7_CreatePalette(self, r, this, flags, entries, out, unk):
        self.mem.w32(out, self.com_new('IDirectDrawPalette', PALETTE_METHODS, {})); return 0
    def api_IDirectDraw7_CreateSurface(self, r, this, desc, out, unk):
        flags = self.mem.u32(desc + 4); caps = self.mem.u32(desc + 0x68)
        w = self.mem.u32(desc + 0xc) if flags & 4 else self.display[0]
        h = self.mem.u32(desc + 8) if flags & 2 else self.display[1]
        nback = self.mem.u32(desc + 0x14) if flags & 0x20 else 0
        surf = self.surface_new(w, h, caps, primary=bool(caps & 0x200))
        o = self.com(surf)
        if nback:
            back = self.surface_new(w, h, (caps & ~0x200) | 0x4, primary=False)   # DDSCAPS_BACKBUFFER
            o['back'] = back
        self.mem.w32(out, surf)
        if len(self.com_objects) < 40 or caps & 0x200:
            self.log.write('  CreateSurface(%dx%d caps=0x%x back=%d) -> 0x%x\n' % (w, h, caps, nback, surf))
        return 0
    def surface_new(self, w, h, caps, primary):
        pitch = (w * 2 + 7) & ~7
        buf = self.surf_next
        self.surf_next += (pitch * h + 0xfff) & ~0xfff
        if self.surf_next > SURF_BASE + SURF_SIZE: raise StopRun('surface memory exhausted')
        return self.com_new('IDirectDrawSurface7', DDS7_METHODS, {'w': w, 'h': h, 'pitch': pitch, 'buf': buf, 'caps': caps, 'primary': primary, 'ckey': None})
    def fill_desc(self, desc, o):
        self.mem.write(desc, bytes(0x7c))
        self.mem.w32(desc, 0x7c)
        self.mem.w32(desc + 4, 0x1 | 0x2 | 0x4 | 0x8 | 0x800 | 0x1000)   # CAPS HEIGHT WIDTH PITCH LPSURFACE PIXELFORMAT
        self.mem.w32(desc + 8, o['h']); self.mem.w32(desc + 0xc, o['w']); self.mem.w32(desc + 0x10, o['pitch'])
        self.mem.w32(desc + 0x24, o['buf'])
        self.mem.w32(desc + 0x48, 32); self.mem.w32(desc + 0x4c, 0x40)      # DDPF_RGB
        self.mem.w32(desc + 0x54, 16); self.mem.w32(desc + 0x58, 0xf800); self.mem.w32(desc + 0x5c, 0x07e0); self.mem.w32(desc + 0x60, 0x001f)
        self.mem.w32(desc + 0x68, o['caps'])
    def api_IDirectDrawSurface7_QueryInterface(self, r, this, iid, out): self.mem.w32(out, this); return 0
    def api_IDirectDrawSurface7_AddRef(self, r, this): return 1
    def api_IDirectDrawSurface7_Release(self, r, this): return 0
    def api_IDirectDrawSurface7_GetSurfaceDesc(self, r, this, desc): self.fill_desc(desc, self.com(this)); return 0
    def api_IDirectDrawSurface7_GetPixelFormat(self, r, this, pf):
        d = self.alloc(0x7c); self.fill_desc(d, self.com(this)); self.mem.write(pf, self.mem.read(d + 0x48, 32)); return 0
    def api_IDirectDrawSurface7_GetCaps(self, r, this, caps): self.mem.write(caps, struct.pack('<IIII', self.com(this)['caps'], 0, 0, 0)); return 0
    def api_IDirectDrawSurface7_GetAttachedSurface(self, r, this, caps, out):
        back = self.com(this).get('back')
        if not back: return 0x887601c2
        self.mem.w32(out, back); return 0
    def api_IDirectDrawSurface7_Lock(self, r, this, rect, desc, flags, ev):
        o = self.com(this); self.fill_desc(desc, o)
        if rect:
            l, t = struct.unpack('<ii', self.mem.read(rect, 8))
            self.mem.w32(desc + 0x24, o['buf'] + t * o['pitch'] + l * 2)
        return 0
    def api_IDirectDrawSurface7_Unlock(self, r, this, rect): return 0
    def api_IDirectDrawSurface7_SetSurfaceDesc(self, r, this, desc, flags):
        o = self.com(this); f = self.mem.u32(desc + 4)
        if f & 0x800: o['buf'] = self.mem.u32(desc + 0x24); o['client'] = True
        if f & 0x8: o['pitch'] = self.mem.u32(desc + 0x10)
        if f & 0x4: o['w'] = self.mem.u32(desc + 0xc)
        if f & 0x2: o['h'] = self.mem.u32(desc + 8)
        self.log.write('  SetSurfaceDesc(0x%x: %dx%d pitch %d buf 0x%x)\n' % (this, o['w'], o['h'], o['pitch'], o['buf']))
        return 0
    def api_SetThreadPriority(self, r, h, pri): return 1
    def api_IDirectDrawSurface7_IsLost(self, r, this): return 0
    def api_IDirectDrawSurface7_Restore(self, r, this): return 0
    def api_IDirectDrawSurface7_SetClipper(self, r, this, clipper): return 0
    def api_IDirectDrawSurface7_SetPalette(self, r, this, pal): return 0
    def api_IDirectDrawSurface7_GetDC(self, r, this, out): self.mem.w32(out, self.handle('surfdc', this)); return 0
    def api_IDirectDrawSurface7_ReleaseDC(self, r, this, dc): return 0
    def api_IDirectDrawSurface7_SetColorKey(self, r, this, flags, key):
        self.com(this)['ckey'] = self.mem.u32(key) if key else None; return 0
    def api_IDirectDrawSurface7_GetColorKey(self, r, this, flags, key):
        ck = self.com(this)['ckey']
        if ck is None: return 0x8876021b
        self.mem.write(key, struct.pack('<II', ck, ck)); return 0
    def api_IDirectDrawSurface7_GetBltStatus(self, r, this, flags): return 0
    def api_IDirectDrawSurface7_GetFlipStatus(self, r, this, flags): return 0
    def api_IDirectDrawSurface7_Flip(self, r, this, override, flags):
        o = self.com(this); back = self.com(o.get('back') or 0)
        if back:
            o['buf'], back['buf'] = back['buf'], o['buf']
        self.frame_dump(o)
        return 0
    def rect(self, p, o):
        if not p: return (0, 0, o['w'], o['h'])
        l, t, rt, b = struct.unpack('<iiii', self.mem.read(p, 16))
        return (l, t, rt, b)
    def api_IDirectDrawSurface7_Blt(self, r, this, drect, src, srect, flags, fx):
        d = self.com(this); dl, dt, dr, db = self.rect(drect, d)
        if flags & 0x400:                                 # DDBLT_COLORFILL
            color = self.mem.u32(fx + 0x50) & 0xffff
            row = struct.pack('<H', color) * max(dr - dl, 0)
            for y in range(max(dt, 0), min(db, d['h'])):
                self.mem.write(d['buf'] + y * d['pitch'] + dl * 2, row)
            return 0
        s_ = self.com(src)
        if s_ is None: return 0
        sl, st, sr, sb = self.rect(srect, s_)
        ckey = s_['ckey'] if flags & 0x8000 else None     # DDBLT_KEYSRC
        self.blit(d, dl, dt, s_, sl, st, sr - sl, sb - st, ckey, dr - dl, db - dt)
        return 0
    def api_IDirectDrawSurface7_BltFast(self, r, this, x, y, src, srect, trans):
        d = self.com(this); s_ = self.com(src)
        if s_ is None: return 0
        sl, st, sr, sb = self.rect(srect, s_)
        ckey = s_['ckey'] if trans & 1 else None
        self.blit(d, x, y, s_, sl, st, sr - sl, sb - st, ckey, sr - sl, sb - st)
        self.primary_dump(d)
        return 0
    def primary_dump(self, d):
        # the game draws straight onto the primary surface (BltFast, no Flip): take a picture after the 1st, 300th, 3000th ... blit
        if not d.get('primary'): return
        self.prim_blits = getattr(self, 'prim_blits', 0) + 1
        if self.prim_blits in (1, 300, 3000, 30000, 100000): self.frame_dump(d)
    def blit(self, d, dx, dy, s_, sx, sy, w, h, ckey, dw, dh):
        if w <= 0 or h <= 0: return
        stretch = (dw != w or dh != h) and dw > 0 and dh > 0
        for j in range(dh if stretch else h):
            ty = dy + j
            if ty < 0 or ty >= d['h']: continue
            syy = sy + (j * h // dh if stretch else j)
            if syy < 0 or syy >= s_['h']: continue
            srow = self.mem.read(s_['buf'] + syy * s_['pitch'] + sx * 2, w * 2)
            if stretch:
                srow = b''.join(srow[2 * (i * w // dw):2 * (i * w // dw) + 2] for i in range(dw))
            n = dw if stretch else w
            x0 = max(dx, 0); x1 = min(dx + n, d['w'])
            if x1 <= x0: continue
            seg = srow[2 * (x0 - dx):2 * (x1 - dx)]
            dst = d['buf'] + ty * d['pitch'] + x0 * 2
            if ckey is None:
                self.mem.write(dst, seg)
            else:
                cur = bytearray(self.mem.read(dst, len(seg)))
                key = struct.pack('<H', ckey & 0xffff)
                for i in range(0, len(seg), 2):
                    if seg[i:i + 2] != key: cur[i:i + 2] = seg[i:i + 2]
                self.mem.write(dst, bytes(cur))
    def frame_dump(self, o):
        self.frames += 1
        if self.frames > 40: return
        os.makedirs(HERE / 'frames', exist_ok=True)
        w, h = o['w'], o['h']
        out = bytearray()
        for y in range(h):
            row = self.mem.read(o['buf'] + y * o['pitch'], w * 2)
            for i in range(0, w * 2, 2):
                v = row[i] | (row[i + 1] << 8)
                out += bytes(((v >> 11) << 3, ((v >> 5) & 0x3f) << 2, (v & 0x1f) << 3))
        with open(HERE / 'frames' / ('frame%03d.ppm' % self.frames), 'wb') as f:
            f.write(b'P6 %d %d 255\n' % (w, h) + bytes(out))
        self.log.write('  FRAME %d dumped (%dx%d)\n' % (self.frames, w, h))

    # Bink video: the real decoder is a binary DLL; report a 565 surface, refuse to open movies (game treats it as skipped)
    def api__BinkDDSurfaceType_4(self, r, surf): return 10          # BINKSURFACE565
    def api_GetLastActivePopup(self, r, hwnd): return hwnd
    # DirectSound: a silent device whose buffers live in host memory and whose play cursor follows the virtual clock
    def api_DirectSoundCreate(self, r, guid, out, unk):
        self.reached_dsound = True
        self.mem.w32(out, self.com_new('IDirectSound', DS_METHODS, {'buffers': 0}))
        self.log.write('  DirectSoundCreate -> IDirectSound\n'); return 0
    api__1 = api_DirectSoundCreate                               # DSOUND.dll ordinal 1
    def api__2(self, r, cb, ctx):                                # DirectSoundEnumerateA
        # the game's callback (0x4fa8d2) skips the null-GUID "Primary Sound Driver" entry and keeps the first real device's GUID
        for guid, desc in ((0, 'Primary Sound Driver'), (self.alloc(16), 'Silent Sound Device')):
            if guid: self.mem.write(guid, bytes([0x11] * 16))
            if self.call(cb, guid, self.cstring(desc), self.cstring(''), ctx) == 0: break
        return 0
    def api_IDirectSound_QueryInterface(self, r, this, iid, out): self.mem.w32(out, this); return 0
    def api_IDirectSound_AddRef(self, r, this): return 1
    def api_IDirectSound_Release(self, r, this): return 0
    def api_IDirectSound_SetCooperativeLevel(self, r, this, hwnd, level): return 0
    def api_IDirectSound_Compact(self, r, this): return 0
    def api_IDirectSound_GetSpeakerConfig(self, r, this, out): self.mem.w32(out, 4); return 0
    def api_IDirectSound_SetSpeakerConfig(self, r, this, cfg): return 0
    def api_IDirectSound_Initialize(self, r, this, guid): return 0
    def api_IDirectSound_GetCaps(self, r, this, caps):
        size = self.mem.u32(caps); self.mem.write(caps + 4, bytes(max(size - 4, 0)))
        self.mem.w32(caps + 4, 0x1 | 0x20 | 0x40 | 0x80 | 0x100 | 0x200 | 0x400 | 0x800)   # primary 16/stereo, secondary mono/stereo/8/16
        self.mem.w32(caps + 8, 100); self.mem.w32(caps + 0xc, 100000)                        # min/max secondary rate
        self.mem.w32(caps + 0x10, 32); self.mem.w32(caps + 0x14, 32); self.mem.w32(caps + 0x18, 32); self.mem.w32(caps + 0x1c, 32)
        return 0
    def api_IDirectSound_CreateSoundBuffer(self, r, this, desc, out, unk):
        flags = self.mem.u32(desc + 4); nbytes = self.mem.u32(desc + 8); fmt = self.mem.u32(desc + 0x10)
        if flags & 1 or nbytes == 0: nbytes = 0x10000
        nbytes = min(nbytes, 16 << 20)
        buf = self.surf_next; self.surf_next += (nbytes + 0xfff) & ~0xfff
        wf = self.mem.read(fmt, 18) if fmt else struct.pack('<HHIIHH', 1, 2, 22050, 88200, 4, 16)
        self.com(this)['buffers'] += 1
        o = {'size': nbytes, 'buf': buf, 'flags': flags, 'fmt': wf, 'playing': 0, 'pos': 0, 'start': 0, 'volume': 0, 'pan': 0, 'freq': struct.unpack('<I', wf[4:8])[0]}
        self.mem.w32(out, self.com_new('IDirectSoundBuffer', DSB_METHODS, o))
        if self.com(this)['buffers'] <= 20: self.log.write('  CreateSoundBuffer(%d bytes, flags 0x%x)\n' % (nbytes, flags))
        return 0
    def api_IDirectSound_DuplicateSoundBuffer(self, r, this, orig, out):
        o = dict(self.com(orig)); o['playing'] = 0
        self.mem.w32(out, self.com_new('IDirectSoundBuffer', DSB_METHODS, o)); return 0
    def api_IDirectSoundBuffer_QueryInterface(self, r, this, iid, out):
        # 3D buffer and 3D listener get their own (stub) vtables so their methods do not land on the buffer's; no notify interface
        tag = bytes(self.mem.read(iid, 4))
        if tag == b'\x86\xfa\x9a\x27': self.mem.w32(out, self.com_new('IDirectSound3DBuffer', DS3DB_METHODS, {})); return 0
        if tag == b'\x84\xfa\x9a\x27': self.mem.w32(out, self.com_new('IDirectSound3DListener', DS3DL_METHODS, {})); return 0
        if tag == b'\x83\x07\x21\xb0': self.mem.w32(out, self.com_new('IDirectSoundNotify', DSN_METHODS, {'buf': this})); return 0
        self.mem.w32(out, this); return 0
    def api_IDirectSoundNotify_SetNotificationPositions(self, r, this, n, ptr):
        self.com(this)['notify'] = [(self.mem.u32(ptr + 8 * i), self.mem.u32(ptr + 8 * i + 4)) for i in range(n)]; return 0
    def api_IDirectSoundBuffer_AddRef(self, r, this): return 1
    def api_IDirectSoundBuffer_Release(self, r, this): return 0
    def api_IDirectSoundBuffer_GetCaps(self, r, this, caps):
        o = self.com(this); self.mem.write(caps, struct.pack('<IIIII', 20, o['flags'] | 0x8, o['size'], 0, 0)); return 0
    def dsb_pos(self, o):
        if not o['playing']: return o['pos']
        bps = struct.unpack('<I', o['fmt'][8:12])[0] or 88200
        pos = o['pos'] + (self.vclock - o['start']) * bps // 1000
        if o['playing'] & 1: return pos % o['size']           # DSBPLAY_LOOPING
        if pos >= o['size']: o['playing'] = 0; o['pos'] = 0; return 0
        return pos
    def api_IDirectSoundBuffer_GetCurrentPosition(self, r, this, play, write):
        pos = self.dsb_pos(self.com(this))
        if play: self.mem.w32(play, pos)
        if write: self.mem.w32(write, pos)
        return 0
    def api_IDirectSoundBuffer_GetFormat(self, r, this, fmt, n, written):
        o = self.com(this)
        if fmt: self.mem.write(fmt, o['fmt'][:n])
        if written: self.mem.w32(written, len(o['fmt']))
        return 0
    def api_IDirectSoundBuffer_SetFormat(self, r, this, fmt): self.com(this)['fmt'] = self.mem.read(fmt, 18); return 0
    def api_IDirectSoundBuffer_GetVolume(self, r, this, out): self.mem.w32(out, self.com(this)['volume']); return 0
    def api_IDirectSoundBuffer_SetVolume(self, r, this, v): self.com(this)['volume'] = v; return 0
    def api_IDirectSoundBuffer_GetPan(self, r, this, out): self.mem.w32(out, self.com(this)['pan']); return 0
    def api_IDirectSoundBuffer_SetPan(self, r, this, v): self.com(this)['pan'] = v; return 0
    def api_IDirectSoundBuffer_GetFrequency(self, r, this, out): self.mem.w32(out, self.com(this)['freq']); return 0
    def api_IDirectSoundBuffer_SetFrequency(self, r, this, v): self.com(this)['freq'] = v; return 0
    def api_IDirectSoundBuffer_GetStatus(self, r, this, out):
        o = self.com(this); self.dsb_pos(o)
        self.mem.w32(out, (0x1 | (0x4 if o['playing'] & 1 else 0)) if o['playing'] else 0); return 0
    def api_IDirectSoundBuffer_Initialize(self, r, this, ds, desc): return 0
    def api_IDirectSoundBuffer_Lock(self, r, this, offset, nbytes, p1, n1, p2, n2, flags):
        o = self.com(this)
        if flags & 2: nbytes = o['size']                       # DSBLOCK_ENTIREBUFFER
        if flags & 1: offset = self.dsb_pos(o)                 # DSBLOCK_FROMWRITECURSOR
        offset %= o['size']; first = min(nbytes, o['size'] - offset)
        self.mem.w32(p1, o['buf'] + offset); self.mem.w32(n1, first)
        if p2: self.mem.w32(p2, o['buf'] if nbytes > first else 0)
        if n2: self.mem.w32(n2, nbytes - first if nbytes > first else 0)
        return 0
    def api_IDirectSoundBuffer_Unlock(self, r, this, p1, n1, p2, n2): return 0
    def api_IDirectSoundBuffer_Play(self, r, this, res, pri, flags):
        o = self.com(this); o['playing'] = 0x10 | (flags & 1); o['start'] = self.vclock; return 0
    def api_IDirectSoundBuffer_Stop(self, r, this):
        o = self.com(this); o['pos'] = self.dsb_pos(o); o['playing'] = 0; return 0
    def api_IDirectSoundBuffer_SetCurrentPosition(self, r, this, pos):
        o = self.com(this); o['pos'] = pos % o['size']; o['start'] = self.vclock; return 0
    def api_IDirectSoundBuffer_Restore(self, r, this): return 0


DD7_METHODS = [('QueryInterface', 2), ('AddRef', 0), ('Release', 0), ('Compact', 0), ('CreateClipper', 3), ('CreatePalette', 4), ('CreateSurface', 3),
               ('DuplicateSurface', 2), ('EnumDisplayModes', 4), ('EnumSurfaces', 4), ('FlipToGDISurface', 0), ('GetCaps', 2), ('GetDisplayMode', 1),
               ('GetFourCCCodes', 2), ('GetGDISurface', 1), ('GetMonitorFrequency', 1), ('GetScanLine', 1), ('GetVerticalBlankStatus', 1), ('Initialize', 1),
               ('RestoreDisplayMode', 0), ('SetCooperativeLevel', 2), ('SetDisplayMode', 5), ('WaitForVerticalBlank', 2), ('GetAvailableVidMem', 3),
               ('GetSurfaceFromDC', 2), ('RestoreAllSurfaces', 0), ('TestCooperativeLevel', 0), ('GetDeviceIdentifier', 2), ('StartModeTest', 3), ('EvaluateMode', 2)]
DDS7_METHODS = [('QueryInterface', 2), ('AddRef', 0), ('Release', 0), ('AddAttachedSurface', 1), ('AddOverlayDirtyRect', 1), ('Blt', 5), ('BltBatch', 3),
                ('BltFast', 5), ('DeleteAttachedSurface', 2), ('EnumAttachedSurfaces', 2), ('EnumOverlayZOrders', 3), ('Flip', 2), ('GetAttachedSurface', 2),
                ('GetBltStatus', 1), ('GetCaps', 1), ('GetClipper', 1), ('GetColorKey', 2), ('GetDC', 1), ('GetFlipStatus', 1), ('GetOverlayPosition', 2),
                ('GetPalette', 1), ('GetPixelFormat', 1), ('GetSurfaceDesc', 1), ('Initialize', 2), ('IsLost', 0), ('Lock', 4), ('ReleaseDC', 1), ('Restore', 0),
                ('SetClipper', 1), ('SetColorKey', 2), ('SetOverlayPosition', 2), ('SetPalette', 1), ('Unlock', 1), ('UpdateOverlay', 5), ('UpdateOverlayDisplay', 1),
                ('UpdateOverlayZOrder', 2), ('GetDDInterface', 1), ('PageLock', 1), ('PageUnlock', 1), ('SetSurfaceDesc', 2), ('SetPrivateData', 4), ('GetPrivateData', 3),
                ('FreePrivateData', 1), ('GetUniquenessValue', 1), ('ChangeUniquenessValue', 0), ('SetPriority', 1), ('GetPriority', 1), ('SetLOD', 1), ('GetLOD', 1)]
CLIPPER_METHODS = [('QueryInterface', 2), ('AddRef', 0), ('Release', 0), ('GetClipList', 3), ('GetHWnd', 1), ('Initialize', 2), ('IsClipListChanged', 1), ('SetClipList', 2), ('SetHWnd', 2)]
PALETTE_METHODS = [('QueryInterface', 2), ('AddRef', 0), ('Release', 0), ('GetCaps', 1), ('GetEntries', 4), ('Initialize', 3), ('SetEntries', 4)]

DS_METHODS = [('QueryInterface', 2), ('AddRef', 0), ('Release', 0), ('CreateSoundBuffer', 3), ('GetCaps', 1), ('DuplicateSoundBuffer', 2), ('SetCooperativeLevel', 2),
              ('Compact', 0), ('GetSpeakerConfig', 1), ('SetSpeakerConfig', 1), ('Initialize', 1)]
DS3DB_METHODS = [('QueryInterface', 2), ('AddRef', 0), ('Release', 0), ('GetAllParameters', 1), ('GetConeAngles', 2), ('GetConeOrientation', 1),
                 ('GetConeOutsideVolume', 1), ('GetMaxDistance', 1), ('GetMinDistance', 1), ('GetMode', 1), ('GetPosition', 1), ('GetVelocity', 1),
                 ('SetAllParameters', 2), ('SetConeAngles', 3), ('SetConeOrientation', 4), ('SetConeOutsideVolume', 2), ('SetMaxDistance', 2),
                 ('SetMinDistance', 2), ('SetMode', 2), ('SetPosition', 4), ('SetVelocity', 4)]
DS3DL_METHODS = [('QueryInterface', 2), ('AddRef', 0), ('Release', 0), ('GetAllParameters', 1), ('GetDistanceFactor', 1), ('GetDopplerFactor', 1),
                 ('GetOrientation', 2), ('GetPosition', 1), ('GetRolloffFactor', 1), ('GetVelocity', 1), ('SetAllParameters', 2),
                 ('SetDistanceFactor', 2), ('SetDopplerFactor', 2), ('SetOrientation', 7), ('SetPosition', 4), ('SetRolloffFactor', 2),
                 ('SetVelocity', 4), ('CommitDeferredSettings', 0)]
DSN_METHODS = [('QueryInterface', 2), ('AddRef', 0), ('Release', 0), ('SetNotificationPositions', 2)]
DSB_METHODS = [('QueryInterface', 2), ('AddRef', 0), ('Release', 0), ('GetCaps', 1), ('GetCurrentPosition', 2), ('GetFormat', 3), ('GetVolume', 1), ('GetPan', 1),
               ('GetFrequency', 1), ('GetStatus', 1), ('Initialize', 2), ('Lock', 7), ('Play', 3), ('SetCurrentPosition', 1), ('SetFormat', 1), ('SetVolume', 1),
               ('SetPan', 1), ('SetFrequency', 1), ('Stop', 0), ('Unlock', 4), ('Restore', 0)]
ARGS = {'GetStringTypeW': 4, 'GetStringTypeA': 5, 'LCMapStringW': 6, 'LCMapStringA': 6, 'MultiByteToWideChar': 6, 'WideCharToMultiByte': 8,
        'GetModuleHandleA': 1, 'GetProcAddress': 2, 'LoadLibraryA': 1, 'FreeLibrary': 1, 'RtlUnwind': 4, 'RaiseException': 4,
        'GetLocaleInfoA': 4, 'GetLocaleInfoW': 4, 'CompareStringA': 6, 'CompareStringW': 6, 'IsValidCodePage': 1, 'IsValidLocale': 2,
        'EnumSystemLocalesA': 2, 'GetUserDefaultLCID': 0, 'SetConsoleCtrlHandler': 2, 'FlushFileBuffers': 1, 'SetStdHandle': 2,
        'CloseHandle': 1, 'ReadFile': 5, 'SetFilePointer': 4, 'SetEndOfFile': 1, 'GetTimeZoneInformation': 1, 'GetSystemTime': 1,
        'GetLocalTime': 1, 'SystemTimeToFileTime': 2, 'FileTimeToSystemTime': 2, 'FileTimeToLocalFileTime': 2, 'LocalFileTimeToFileTime': 2,
        'GetFileTime': 4, 'SetFileTime': 4, 'DeleteFileA': 1, 'MoveFileA': 2, 'CreateDirectoryA': 2, 'RemoveDirectoryA': 1,
        'FindNextFileA': 2, 'GetFullPathNameA': 4, 'GetShortPathNameA': 3, 'SetErrorMode': 1, 'GetExitCodeProcess': 2,
        'CreateProcessA': 10, 'WaitForSingleObject': 2, 'CreateEventA': 4, 'SetEvent': 1, 'ResetEvent': 1, 'CreateThread': 6,
        'ResumeThread': 1, 'SuspendThread': 1, 'SetThreadPriority': 2, 'GetThreadPriority': 1, 'ExitThread': 1, 'TerminateThread': 2,
        'CreateMutexA': 3, 'ReleaseMutex': 1, 'OutputDebugStringA': 1, 'IsDBCSLeadByte': 1, 'GetTempPathA': 2, 'GetTempFileNameA': 4,
        'FormatMessageA': 7, 'GetDiskFreeSpaceA': 5, 'GetVolumeInformationA': 8, 'GlobalReAlloc': 3, 'GlobalSize': 1, 'GlobalFlags': 1,
        'LocalReAlloc': 3, 'LocalLock': 1, 'LocalUnlock': 1, 'VirtualProtect': 4, 'VirtualQuery': 3, 'DuplicateHandle': 7, 'Beep': 2,
        'DirectDrawEnumerateExA': 3, 'DirectDrawCreateEx': 4, '#1': 3, '#2': 2, 'VerQueryValueA': 4, 'GetFileVersionInfoA': 4,
        'GetFileVersionInfoSizeA': 2, '_BinkOpenDirectSound@4': 1, 'GetStringTypeExA': 5, 'GetEnvironmentStringsW': 0, 'VirtualFree': 3,
        'SetUnhandledExceptionFilter': 1, 'TranslateAcceleratorA': 3, 'ReleaseCapture': 0, 'ReuseDDElParam': 5, 'UnpackDDElParam': 4,
        'DrawTextA': 5, 'GetSysColorBrush': 1, 'GetMenuItemID': 2, 'RegisterWindowMessageA': 1, 'GetClipBox': 2, 'SaveDC': 1, 'RestoreDC': 2,
        'SelectObject': 2, 'SetMapMode': 2, 'SetViewportOrgEx': 4, 'OffsetViewportOrgEx': 4, 'SetViewportExtEx': 4, 'ScaleViewportExtEx': 6,
        'SetWindowExtEx': 4, 'ScaleWindowExtEx': 6, 'PtVisible': 3, 'RectVisible': 2, 'TextOutA': 5, 'Escape': 5, 'GetFileTitleA': 3,
        'PrintDlgA': 1, 'CommDlgExtendedError': 0, 'DocumentPropertiesA': 6, 'OpenPrinterA': 3, 'ClosePrinter': 1, 'DragQueryFileA': 4, 'GetACP': 0}
        # stdcall argument counts for imports that no lifted function calls
NEVER = object()
T0 = time.time()


class StopRun(Exception):
    pass


def main():
    trace = '--trace' in sys.argv
    m = Machine(trace=trace)
    m.log.write('entry 0x%x\n' % m.entry)
    t0 = time.time()
    why = 'returned from the entry point'
    try:
        m.call(m.entry)
    except StopRun as ex:
        why = str(ex)
    dt = time.time() - t0
    stats = (ctypes.c_uint64 * 4)()
    m.lib.host_stats(ctypes.byref(stats))
    out = {'stopped': why, 'seconds': round(dt, 2), 'native_calls': stats[0], 'fallback_calls': stats[1], 'reads': stats[2], 'writes': stats[3],
           'imports_called': m.import_calls, 'distinct_imports': len(m.import_log), 'on_demand_pages': len(m.on_demand),
           'reached_create_window': getattr(m, 'reached_create_window', False), 'reached_ddraw': getattr(m, 'reached_ddraw', False), 'files_opened': m.files_opened, 'first_data_file': m.first_data_file, 'file_log': m.file_log[:40],
           'unicorn_instructions': getattr(m, 'uc_instr', 0)}
    prim = next((o for o in m.com_objects.values() if o.get('primary')), None)
    if prim: m.frames = 0; m.frame_dump(prim)                                  # the last picture of the primary surface
    for spec in filter(None, os.environ.get('DUMP', '').split(',')):         # debugging: DUMP=addr:words,...
        a, n = spec.split(':'); a = int(a, 16)
        m.log.write('DUMP %x: %s\n' % (a, ' '.join('%x' % m.mem.u32(a + 4 * i) for i in range(int(n)))))
    m.log.write('\nRESULT %s\n' % json.dumps(out))
    m.log.write('imports by count:\n')
    for name, n in m.import_log.most_common():
        m.log.write('  %6d %s\n' % (n, name))
    m.log.close()
    print(json.dumps(out, indent=1))


if __name__ == '__main__':
    main()
