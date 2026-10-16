# FUN_0051f69d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f69d
# extent:       0x0051f69d-0x0051f6a6 (9 code bytes)
# span:         0x0051f69d-0x0051f6a6 (code 9, tables 0, padding 0)
# sha256:       3201d89e03e03005e1533ab26ba0329af0049e4944db66460fd8daf5191a3aab
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f69d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_10
# callees:      calls FUN_00525397
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00525397, .text + (0x00525397 - 0x401000)

.org 0x0051f69d - 0x401000
.globl FUN_0051f69d
FUN_0051f69d:
    # block 0x0051f69d: entry, 3 instruction(s), calls FUN_00525397, ends with ret
    call FUN_00525397                            # 0051f69d
    inc dword ptr [eax + field_10]               # 0051f6a2
    ret                                          # 0051f6a5

