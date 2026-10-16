# FUN_0050c414
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c414
# extent:       0x0050c414-0x0050c41b (7 code bytes)
# span:         0x0050c414-0x0050c41b (code 7, tables 0, padding 0)
# sha256:       462c6172c7af6c4217a5de453c0c95baf853388f3385a8a0bcb0b77695d523a5
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c414
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

.org 0x0050c414 - 0x401000
.globl FUN_0050c414
FUN_0050c414:
    # block 0x0050c414: entry, 2 instruction(s), ends with ret
    mov dword ptr [ecx], 0x52fe48                # 0050c414
    ret                                          # 0050c41a

