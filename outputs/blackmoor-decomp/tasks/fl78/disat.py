"""dis.py ADDR [BEFORE_BYTES AFTER_BYTES]: disassemble the original bytes around an address (read-only helper)."""
import sys
sys.path.insert(0, 'scripts'); sys.path.insert(0, 'tests')
import fl41_world as W41
from capstone import Cs, CS_ARCH_X86, CS_MODE_32
pe = W41.od.load_image(); base = W41.IMAGE_BASE
a = int(sys.argv[1], 16); lo = int(sys.argv[2], 0) if len(sys.argv) > 2 else 0x40; hi = int(sys.argv[3], 0) if len(sys.argv) > 3 else 0x30
md = Cs(CS_ARCH_X86, CS_MODE_32)
start = a - lo
for i in md.disasm(bytes(pe.image[start - base:a + hi - base]), start):
    print(('=> ' if i.address == a else '   ') + hex(i.address), i.mnemonic, i.op_str)
