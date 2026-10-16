# FUN_00528610
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528610
# extent:       0x00528610-0x0052861a (10 code bytes)
# span:         0x00528610-0x0052861a (code 10, tables 0, padding 0)
# sha256:       d257faeff0d0c30ed141d28ba612d5ab14cb034e2e7f0119038e9c305d8a4df0
# evidence:     ev_ae635b4fd276b6b5af385d914372d11115281daf9983e2ed88208809835d41c6
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528610
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_14
# callees:      calls FUN_00401c90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0052861a
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_00401c90, .text + (0x00401c90 - 0x401000)

.org 0x00528610 - 0x401000
.globl FUN_00528610
FUN_00528610:
    # block 0x00528610: entry, 4 instruction(s), calls FUN_00401c90, ends with ret
    mov eax, dword ptr [ebp - field_minus_14]    # 00528610
    push eax                                     # 00528613
    call FUN_00401c90                            # 00528614
    ret                                          # 00528619

