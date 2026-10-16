# FUN_00527936
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527936
# extent:       0x00527936-0x00527945 (15 code bytes)
# span:         0x00527936-0x00527945 (code 15, tables 0, padding 0)
# sha256:       ad037062d5b9388750e17fb2daf4806eec08ee288d053ed72f3b23e96c30626f
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527936
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004e2d63
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e2d63, .text + (0x004e2d63 - 0x401000)

.org 0x00527936 - 0x401000
.globl FUN_00527936
FUN_00527936:
    # block 0x00527936: entry, 4 instruction(s), calls FUN_004e2d63, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527936
    add ecx, 0x93d4                              # 00527939
    call FUN_004e2d63                            # 0052793f
    ret                                          # 00527944

