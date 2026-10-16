# FUN_00527280
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527280
# extent:       0x00527280-0x0052728a (10 code bytes)
# span:         0x00527280-0x0052728a (code 10, tables 0, padding 0)
# sha256:       1cba44e17dc0b85b09a499c6f18aa180c3602a3b7c63d7a389a0da8d4efb9e97
# evidence:     ev_006a4e0c0f3816d014729cd22cd3627c49e1859fbb02a66a24789866f81eb18a
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527280
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052728a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x00527280 - 0x401000
.globl FUN_00527280
FUN_00527280:
    # block 0x00527280: entry, 4 instruction(s), calls FUN_00401c90, ends with ret
    mov eax, dword ptr [ebp - field_minus_14]    # 00527280
    push eax                                     # 00527283
    call FUN_00401c90                            # 00527284
    ret                                          # 00527289

