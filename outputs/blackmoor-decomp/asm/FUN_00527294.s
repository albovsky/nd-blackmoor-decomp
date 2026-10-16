# FUN_00527294
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527294
# extent:       0x00527294-0x0052729d (9 code bytes)
# span:         0x00527294-0x0052729d (code 9, tables 0, padding 0)
# sha256:       2098d91793b301699f542a92d4b1e7029504e4ad07d09844b9faf6df9e2a5f2d
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527294
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052729d
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00527294 - 0x401000
.globl FUN_00527294
FUN_00527294:
    # block 0x00527294: entry, 3 instruction(s), calls FUN_0051d730, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527294
    call FUN_0051d730                            # 00527297
    ret                                          # 0052729c

