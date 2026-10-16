# FUN_0051a0ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a0ca
# extent:       0x0051a0ca-0x0051a0e1 (23 code bytes)
# span:         0x0051a0ca-0x0051a0e1 (code 23, tables 0, padding 0)
# sha256:       a80ec3df414c3fc38fb7ff1fb994a29d0e41c10b4e3d7bfb77c275d2f645ffee
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a0ca
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051cab3, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051a0e1
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051cab3, .text + (0x0051cab3 - 0x401000)

.org 0x0051a0ca - 0x401000
.globl FUN_0051a0ca
FUN_0051a0ca:
    # block 0x0051a0ca: entry, 6 instruction(s), calls FUN_0051cab3, ends with je to 0x0051a0df (forward)
    push esi                                     # 0051a0ca
    {load} mov esi, ecx                          # 0051a0cb
    push 0x1                                     # 0051a0cd
    call FUN_0051cab3                            # 0051a0cf
    test eax, eax                                # 0051a0d4
    je.d8 L_0051a0df                             # 0051a0d6
    # block 0x0051a0d8: entered by fall-through of je at 0x0051a0d6, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0051a0df
    {load} mov ecx, esi                          # 0051a0d8
    call FUN_0051ab4b                            # 0051a0da
L_0051a0df:
    # block 0x0051a0df: entered by je at 0x0051a0d6, 2 instruction(s), ends with ret
    pop esi                                      # 0051a0df
    ret                                          # 0051a0e0

