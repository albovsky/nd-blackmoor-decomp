# FUN_00527464
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527464
# extent:       0x00527464-0x00527473 (15 code bytes)
# span:         0x00527464-0x00527473 (code 15, tables 0, padding 0)
# sha256:       e7e226e3df817380342a522120fc8ae5caa430987d7350e16d41ffbf0c5a4b1e
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527464
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_004e7684
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e7684, .text + (0x004e7684 - 0x401000)

.org 0x00527464 - 0x401000
.globl FUN_00527464
FUN_00527464:
    # block 0x00527464: entry, 4 instruction(s), calls FUN_004e7684, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527464
    add ecx, 0x12389                             # 00527467
    call FUN_004e7684                            # 0052746d
    ret                                          # 00527472

