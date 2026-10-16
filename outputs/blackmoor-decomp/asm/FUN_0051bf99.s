# FUN_0051bf99
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051bf99
# extent:       0x0051bf99-0x0051bfb2 (25 code bytes)
# span:         0x0051bf99-0x0051bfb2 (code 25, tables 0, padding 0)
# sha256:       90f73a589d1dcdfc6a93274c19729a0c2a075c93e75962c5e4a3793b51be993e
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051bf99
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_28
# callees:      calls FUN_0051da03
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0051bfb2
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_0051da03, .text + (0x0051da03 - 0x401000)

.org 0x0051bf99 - 0x401000
.globl FUN_0051bf99
FUN_0051bf99:
    # block 0x0051bf99: entry, 8 instruction(s), calls FUN_0051da03, ends with ret
    push esi                                     # 0051bf99
    {load} mov esi, ecx                          # 0051bf9a
    call FUN_0051da03                            # 0051bf9c
    mov dword ptr [esi], 0x52eb40                # 0051bfa1
    mov dword ptr [esi + field_28], 0x1          # 0051bfa7
    {load} mov eax, esi                          # 0051bfae
    pop esi                                      # 0051bfb0
    ret                                          # 0051bfb1

