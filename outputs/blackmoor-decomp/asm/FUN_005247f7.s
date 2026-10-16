# FUN_005247f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005247f7
# extent:       0x005247f7-0x00524826 (47 code bytes)
# span:         0x005247f7-0x00524826 (code 47, tables 0, padding 0)
# sha256:       307bdda26f49513a12b9c21f7ddeacb034ed12f2fd605b8efb293a5d9d04c433
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005247f7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c; [esp + n] stk_4
# callees:      calls USER32.dll!GetLastActivePopup, USER32.dll!BringWindowToTop
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x005247f7 - 0x401000
.globl FUN_005247f7
FUN_005247f7:
    # block 0x005247f7: entry, 3 instruction(s), ends with je to 0x00524823 (forward)
    mov eax, dword ptr [esp + stk_4]             # 005247f7
    test eax, eax                                # 005247fb
    je.d8 L_00524823                             # 005247fd
    # block 0x005247ff: entered by fall-through of je at 0x005247fd, 2 instruction(s), ends with je to 0x00524823 (forward)
    cmp eax, 0x6                                 # 005247ff
    je.d8 L_00524823                             # 00524802
    # block 0x00524804: entered by fall-through of je at 0x00524802, 2 instruction(s), ends with je to 0x00524823 (forward)
    cmp eax, 0x7                                 # 00524804
    je.d8 L_00524823                             # 00524807
    # block 0x00524809: entered by fall-through of je at 0x00524807, 2 instruction(s), ends with je to 0x00524823 (forward)
    cmp eax, 0x8                                 # 00524809
    je.d8 L_00524823                             # 0052480c
    # block 0x0052480e: entered by fall-through of je at 0x0052480c, 2 instruction(s), ends with je to 0x00524823 (forward)
    cmp eax, 0x4                                 # 0052480e
    je.d8 L_00524823                             # 00524811
    # block 0x00524813: entered by fall-through of je at 0x00524811, 4 instruction(s), calls USER32.dll!GetLastActivePopup, USER32.dll!BringWindowToTop, falls into the block at 0x00524823
    push dword ptr [ecx + field_1c]              # 00524813
    call dword ptr [0x52a444]                    # 00524816
    push eax                                     # 0052481c
    call dword ptr [0x52a3a0]                    # 0052481d
L_00524823:
    # block 0x00524823: entered by je at 0x005247fd; je at 0x00524802; je at 0x00524807; je at 0x0052480c; je at 0x00524811, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 00524823

