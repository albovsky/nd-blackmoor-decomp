# FUN_00527410
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527410
# extent:       0x00527410-0x00527419 (9 code bytes)
# span:         0x00527410-0x00527419 (code 9, tables 0, padding 0)
# sha256:       afa25ec80cd15e35eb56a5acfcb54b9c4f6b31dd8f1446666c22152d5bae4e45
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527410
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00524e1f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00524e1f, .text + (0x00524e1f - 0x401000)

.org 0x00527410 - 0x401000
.globl FUN_00527410
FUN_00527410:
    # block 0x00527410: entry, 3 instruction(s), calls FUN_00524e1f, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527410
    call FUN_00524e1f                            # 00527413
    ret                                          # 00527418

