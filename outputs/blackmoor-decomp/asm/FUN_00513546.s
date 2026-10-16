# FUN_00513546
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513546
# extent:       0x00513546-0x00513570 (42 code bytes)
# span:         0x00513546-0x00513570 (code 42, tables 0, padding 0)
# sha256:       30591dd9dc6c77ad243502fadad27ae524a003886b2d692902920ba4b7f3f3e9
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513546
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_8, field_d, field_18; [esp + n] stk_4, stk_c
# callees:      calls FUN_0050dcb0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00513570
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_d, 0xd  # offset +0xd
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050dcb0, .text + (0x0050dcb0 - 0x401000)

.org 0x00513546 - 0x401000
.globl FUN_00513546
FUN_00513546:
    # block 0x00513546: entry, 3 instruction(s), ends with je to 0x0051356e (forward)
    cmp dword ptr [esp + stk_4], 0x0             # 00513546
    push esi                                     # 0051354b
    je.d8 L_0051356e                             # 0051354c
    # block 0x0051354e: entered by fall-through of je at 0x0051354c, 3 instruction(s), ends with je to 0x0051356e (forward)
    mov esi, dword ptr [esp + stk_c]             # 0051354e
    test byte ptr [esi + field_d], 0x10          # 00513552
    je.d8 L_0051356e                             # 00513556
    # block 0x00513558: entered by fall-through of je at 0x00513556, 7 instruction(s), calls FUN_0050dcb0, falls into the block at 0x0051356e
    push esi                                     # 00513558
    call FUN_0050dcb0                            # 00513559
    and byte ptr [esi + field_d], -0x12          # 0051355e
    and dword ptr [esi + field_18], 0x0          # 00513562
    and dword ptr [esi], 0x0                     # 00513566
    and dword ptr [esi + field_8], 0x0           # 00513569
    pop ecx                                      # 0051356d
L_0051356e:
    # block 0x0051356e: entered by je at 0x0051354c; je at 0x00513556, 2 instruction(s), ends with ret
    pop esi                                      # 0051356e
    ret                                          # 0051356f

