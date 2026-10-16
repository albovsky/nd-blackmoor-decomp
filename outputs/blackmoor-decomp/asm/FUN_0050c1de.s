# FUN_0050c1de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c1de
# extent:       0x0050c1de-0x0050c1ea (12 code bytes)
# span:         0x0050c1de-0x0050c1ea (code 12, tables 0, padding 0)
# sha256:       a39b5191c542f0749806cac7471a5c4d74c79d879d73433fd494f64e1674fac9
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c1de
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c4; [ecx + n] field_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_c4, 0xc4  # offset +0xc4

# --- external targets -----------------------------------------------

.org 0x0050c1de - 0x401000
.globl FUN_0050c1de
FUN_0050c1de:
    # block 0x0050c1de: entry, 4 instruction(s), ends with ret
    mov eax, dword ptr [ecx + field_4]           # 0050c1de
    mov ecx, dword ptr [ecx]                     # 0050c1e1
    mov dword ptr [eax + field_c4], ecx          # 0050c1e3
    ret                                          # 0050c1e9

