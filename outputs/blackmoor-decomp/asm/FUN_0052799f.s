# FUN_0052799f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052799f
# extent:       0x0052799f-0x005279ae (15 code bytes)
# span:         0x0052799f-0x005279ae (code 15, tables 0, padding 0)
# sha256:       f70d4d63740cea4f4afb6543ac88513baf43a33efc035d88c92d3c01b6c3d683
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052799f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004de66e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004de66e, .text + (0x004de66e - 0x401000)

.org 0x0052799f - 0x401000
.globl FUN_0052799f
FUN_0052799f:
    # block 0x0052799f: entry, 4 instruction(s), calls FUN_004de66e, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 0052799f
    add ecx, 0x12ead                             # 005279a2
    call FUN_004de66e                            # 005279a8
    ret                                          # 005279ad

