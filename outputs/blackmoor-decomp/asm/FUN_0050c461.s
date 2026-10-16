# FUN_0050c461
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c461
# extent:       0x0050c461-0x0050c468 (7 code bytes)
# span:         0x0050c461-0x0050c468 (code 7, tables 0, padding 0)
# sha256:       3bd6e35bfbda35d057c4dcbde68acce44a0d2599fc0469ebb6c0048b9a25c2d7
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c461
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0050c461 - 0x401000
.globl FUN_0050c461
FUN_0050c461:
    # block 0x0050c461: entry, 2 instruction(s), ends with ret
    mov dword ptr [ecx], 0x52fe60                # 0050c461
    ret                                          # 0050c467

