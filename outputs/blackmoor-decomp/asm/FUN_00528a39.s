# FUN_00528a39
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528a39
# extent:       0x00528a39-0x00528a54 (27 code bytes)
# span:         0x00528a39-0x00528a54 (code 27, tables 0, padding 0)
# sha256:       f29a899b7d017cf125edbc9fbcbb7fb928d4eecbdb516b1b60c25caaee16c099
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528a39
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0050cba8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00528a54
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x00528a39 - 0x401000
.globl FUN_00528a39
FUN_00528a39:
    # block 0x00528a39: entry, 8 instruction(s), calls FUN_0050cba8, ends with ret
    push 0x4e1c83                                # 00528a39
    push 0x6                                     # 00528a3e
    push 0x18f                                   # 00528a40
    mov eax, dword ptr [ebp - field_minus_10]    # 00528a45
    add eax, 0x7654                              # 00528a48
    push eax                                     # 00528a4d
    call FUN_0050cba8                            # 00528a4e
    ret                                          # 00528a53

