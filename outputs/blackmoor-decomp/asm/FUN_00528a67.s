# FUN_00528a67
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00528a67
# extent:       0x00528a67-0x00528a82 (27 code bytes)
# span:         0x00528a67-0x00528a82 (code 27, tables 0, padding 0)
# sha256:       d556e269f749b7b9b561bbb375e7fa89248c96717c629ac52c663e3a204622ae
# evidence:     ev_d2c5fd8ee18803d4fcbad81aadf07f5107591d57975583e6b9ac0607df6e36be
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00528a67
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_10
# callees:      calls FUN_0050cba8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00528a82
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050cba8, .text + (0x0050cba8 - 0x401000)

.org 0x00528a67 - 0x401000
.globl FUN_00528a67
FUN_00528a67:
    # block 0x00528a67: entry, 8 instruction(s), calls FUN_0050cba8, ends with ret
    push 0x4e1c83                                # 00528a67
    push 0x6                                     # 00528a6c
    push 0x18f                                   # 00528a6e
    mov eax, dword ptr [ebp - field_minus_10]    # 00528a73
    add eax, 0x7654                              # 00528a76
    push eax                                     # 00528a7b
    call FUN_0050cba8                            # 00528a7c
    ret                                          # 00528a81

