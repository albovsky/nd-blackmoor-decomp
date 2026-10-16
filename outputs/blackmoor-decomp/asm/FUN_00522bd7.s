# FUN_00522bd7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522bd7
# extent:       0x00522bd7-0x00522bf7 (32 code bytes)
# span:         0x00522bd7-0x00522bf7 (code 32, tables 0, padding 0)
# sha256:       e62fda797e6418ab1232f49c52265b010d354b3df72313915335b88a0e28b1f1
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522bd7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      calls FUN_0051c107
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00522bf7
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051c107, .text + (0x0051c107 - 0x401000)

.org 0x00522bd7 - 0x401000
.globl FUN_00522bd7
FUN_00522bd7:
    # block 0x00522bd7: entry, 1 instruction(s), falls into the block at 0x00522bdb
    mov eax, dword ptr [esp + stk_8]             # 00522bd7
L_00522bdb:
    # block 0x00522bdb: entered by jmp at 0x00522beb, 2 instruction(s), ends with je to 0x00522bed (forward)
    cmp dword ptr [esp + stk_4], eax             # 00522bdb
    je.d8 L_00522bed                             # 00522bdf
    # block 0x00522be1: entered by fall-through of je at 0x00522bdf, 4 instruction(s), calls FUN_0051c107, ends with je to 0x00522bf2 (forward)
    push eax                                     # 00522be1
    call FUN_0051c107                            # 00522be2
    test eax, eax                                # 00522be7
    je.d8 L_00522bf2                             # 00522be9
    # block 0x00522beb: entered by fall-through of je at 0x00522be9, 1 instruction(s), ends with backward jump to 0x00522bdb
    jmp.d8 L_00522bdb                            # 00522beb
L_00522bed:
    # block 0x00522bed: entered by je at 0x00522bdf, 3 instruction(s), ends with forward jump to 0x00522bf4
    push 0x1                                     # 00522bed
    pop eax                                      # 00522bef
    jmp.d8 L_00522bf4                            # 00522bf0
L_00522bf2:
    # block 0x00522bf2: entered by je at 0x00522be9, 1 instruction(s), falls into the block at 0x00522bf4
    {load} xor eax, eax                          # 00522bf2
L_00522bf4:
    # block 0x00522bf4: entered by jmp at 0x00522bf0, 1 instruction(s), ends with ret 0x8
    ret 0x8                                      # 00522bf4

