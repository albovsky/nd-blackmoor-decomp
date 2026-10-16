# FUN_00524861
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524861
# extent:       0x00524861-0x00524871 (16 code bytes)
# span:         0x00524861-0x00524871 (code 16, tables 0, padding 0)
# sha256:       1a5a18c3150ba9c41d78887067896ffe80fe1573c1afcc34086e69cd2a9ff767
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524861
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_2c
# callees:      calls FUN_00525371
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00524861 - 0x401000
.globl FUN_00524861
FUN_00524861:
    # block 0x00524861: entry, 6 instruction(s), calls FUN_00525371, ends with ret
    call FUN_00525371                            # 00524861
    {load} xor ecx, ecx                          # 00524866
    cmp dword ptr [eax + field_2c], ecx          # 00524868
    sete cl                                      # 0052486b
    {load} mov eax, ecx                          # 0052486e
    ret                                          # 00524870

