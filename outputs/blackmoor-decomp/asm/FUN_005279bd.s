# FUN_005279bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005279bd
# extent:       0x005279bd-0x005279cc (15 code bytes)
# span:         0x005279bd-0x005279cc (code 15, tables 0, padding 0)
# sha256:       ec74a4a8983b7ef167d1df191a8e9dbd17f0218dc236a8e52498faf69eb39a1b
# evidence:     ev_b63e1118bba1204c7ea8b81c8fd34d19f989b1bf23170257a27495e3973a3a30
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005279bd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004fa9e7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004fa9e7, .text + (0x004fa9e7 - 0x401000)

.org 0x005279bd - 0x401000
.globl FUN_005279bd
FUN_005279bd:
    # block 0x005279bd: entry, 4 instruction(s), calls FUN_004fa9e7, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 005279bd
    add ecx, 0x536df                             # 005279c0
    call FUN_004fa9e7                            # 005279c6
    ret                                          # 005279cb

