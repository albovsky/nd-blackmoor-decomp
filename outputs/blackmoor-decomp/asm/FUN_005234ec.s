# FUN_005234ec
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005234ec
# extent:       0x005234ec-0x00523515 (41 code bytes)
# span:         0x005234ec-0x00523515 (code 41, tables 0, padding 0)
# sha256:       87d56cd8a96da377a523f3db6655ab897818084c628ab54e11e3711d4aed39d1
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005233c8 (+0x124)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005234ec
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_c; [esi + n] field_1c
# callees:      calls FUN_0052398b, FUN_0051ab16, USER32.dll!SendMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00523515
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051ab16, .text + (0x0051ab16 - 0x401000)
.set FUN_0052398b, .text + (0x0052398b - 0x401000)

.org 0x005234ec - 0x401000
.globl FUN_005234ec
FUN_005234ec:
    # block 0x005234ec: entry, 5 instruction(s), calls FUN_0052398b, ends with je to 0x00523511 (forward)
    push esi                                     # 005234ec
    call FUN_0052398b                            # 005234ed
    {load} mov esi, eax                          # 005234f2
    test esi, esi                                # 005234f4
    je.d8 L_00523511                             # 005234f6
    # block 0x005234f8: entered by fall-through of je at 0x005234f6, 6 instruction(s), calls FUN_0051ab16, USER32.dll!SendMessageA, falls into the block at 0x00523511
    call FUN_0051ab16                            # 005234f8
    push dword ptr [eax + field_c]               # 005234fd
    push dword ptr [eax + field_8]               # 00523500
    push 0x115                                   # 00523503
    push dword ptr [esi + field_1c]              # 00523508
    call dword ptr [0x52a4c8]                    # 0052350b
L_00523511:
    # block 0x00523511: entered by je at 0x005234f6, 2 instruction(s), ends with ret 0xc
    pop esi                                      # 00523511
    ret 0xc                                      # 00523512

