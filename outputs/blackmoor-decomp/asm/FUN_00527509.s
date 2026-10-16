# FUN_00527509
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527509
# extent:       0x00527509-0x00527518 (15 code bytes)
# span:         0x00527509-0x00527518 (code 15, tables 0, padding 0)
# sha256:       30eb2b049d1820d4afe359b786d80bc35e759740ed399349381a607f830e4fa8
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527509
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_00414ccf
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00414ccf, .text + (0x00414ccf - 0x401000)

.org 0x00527509 - 0x401000
.globl FUN_00527509
FUN_00527509:
    # block 0x00527509: entry, 4 instruction(s), calls FUN_00414ccf, ends with ret
    mov ecx, dword ptr [ebp - field_minus_10]    # 00527509
    add ecx, 0x72a36                             # 0052750c
    call FUN_00414ccf                            # 00527512
    ret                                          # 00527517

