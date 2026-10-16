# FUN_00528064
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528064
# extent:       0x00528064-0x0052806d (9 code bytes)
# span:         0x00528064-0x0052806d (code 9, tables 0, padding 0)
# sha256:       181367a5046394d924784da610fcb2349171d189af93101dea5b3060c7876c11
# evidence:     ev_7a152dca5b4d4270e26c3d32ca1ad001d44bfc411ed4e2c4ce09c304a9d9da5d
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528064
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052806d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00528064 - 0x401000
.globl FUN_00528064
FUN_00528064:
    # block 0x00528064: entry, 3 instruction(s), calls FUN_0051d730, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00528064
    call FUN_0051d730                            # 00528067
    ret                                          # 0052806c

