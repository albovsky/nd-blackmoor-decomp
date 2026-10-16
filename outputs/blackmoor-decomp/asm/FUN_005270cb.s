# FUN_005270cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005270cb
# extent:       0x005270cb-0x005270da (15 code bytes)
# span:         0x005270cb-0x005270da (code 15, tables 0, padding 0)
# sha256:       c780633b75b68f8a579b6a578fa8569e6581134b1ba12b4aa40b4d3d0ddce257
# evidence:     ev_ece41028d6fef6bb0a900a8bf1bb6dcc384180be71ba7a9d527a5d7890f79415
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005270cb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00401032
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401032, .text + (0x00401032 - 0x401000)

.org 0x005270cb - 0x401000
.globl FUN_005270cb
FUN_005270cb:
    # block 0x005270cb: entry, 4 instruction(s), calls FUN_00401032, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005270cb
    add ecx, 0x40c                               # 005270ce
    call FUN_00401032                            # 005270d4
    ret                                          # 005270d9

