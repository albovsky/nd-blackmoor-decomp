# FUN_00527990
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527990
# extent:       0x00527990-0x0052799f (15 code bytes)
# span:         0x00527990-0x0052799f (code 15, tables 0, padding 0)
# sha256:       4c9ecfd726d7be58b623e5f27576563f34ba3dcad47cd47584d474db772fdba6
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527990
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0043772f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0043772f, .text + (0x0043772f - 0x401000)

.org 0x00527990 - 0x401000
.globl FUN_00527990
FUN_00527990:
    # block 0x00527990: entry, 4 instruction(s), calls FUN_0043772f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527990
    add ecx, 0x12e80                             # 00527993
    call FUN_0043772f                            # 00527999
    ret                                          # 0052799e

