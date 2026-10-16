# FUN_0051ef58
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ef58
# extent:       0x0051ef58-0x0051ef5c (4 code bytes)
# span:         0x0051ef58-0x0051ef5c (code 4, tables 0, padding 0)
# sha256:       7e6bda0a031f94dbe8477fe3ce3ba2b7e3d761a050d55625bc7d92212670e60c
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051ee80 (+0xd8)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ef58
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_38
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------

.org 0x0051ef58 - 0x401000
.globl FUN_0051ef58
FUN_0051ef58:
    # block 0x0051ef58: entry, 2 instruction(s), ends with ret
    mov eax, dword ptr [ecx + field_38]          # 0051ef58
    ret                                          # 0051ef5b

