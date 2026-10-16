# FUN_00521641
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521641
# extent:       0x00521641-0x005216b6 (117 code bytes)
# span:         0x00521641-0x005216b6 (code 117, tables 0, padding 0)
# sha256:       bfecfd691708c2a998d35b60fd859344a09a83d023836dcba21bf723d7b24010
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521641
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_10
# fields:       [esi + n] field_7c, field_90
# callees:      calls FUN_00526245, ADVAPI32.dll!RegSetValueExA, ADVAPI32.dll!RegCloseKey, USER32.dll!wsprintfA, KERNEL32.dll!WritePrivateProfileStringA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_7c, 0x7c  # offset +0x7c
.equ field_90, 0x90  # offset +0x90

# --- external targets -----------------------------------------------
.set FUN_00526245, .text + (0x00526245 - 0x401000)

.org 0x00521641 - 0x401000
.globl FUN_00521641
FUN_00521641:
    # block 0x00521641: entry, 7 instruction(s), ends with je to 0x00521686 (forward)
    push ebp                                     # 00521641
    {load} mov ebp, esp                          # 00521642
    sub esp, 0x10                                # 00521644
    push esi                                     # 00521647
    {load} mov esi, ecx                          # 00521648
    cmp dword ptr [esi + field_7c], 0x0          # 0052164a
    je.d8 L_00521686                             # 0052164e
    # block 0x00521650: entered by fall-through of je at 0x0052164e, 5 instruction(s), calls FUN_00526245, ends with je to 0x005216b1 (forward)
    push dword ptr [ebp + arg_8]                 # 00521650
    call FUN_00526245                            # 00521653
    {load} mov esi, eax                          # 00521658
    test esi, esi                                # 0052165a
    je.d8 L_005216b1                             # 0052165c
    # block 0x0052165e: entered by fall-through of je at 0x0052165c, 17 instruction(s), calls ADVAPI32.dll!RegSetValueExA, ADVAPI32.dll!RegCloseKey, ends with forward jump to 0x005216b1
    push edi                                     # 0052165e
    lea eax, [ebp + arg_10]                      # 0052165f
    push 0x4                                     # 00521662
    push eax                                     # 00521664
    push 0x4                                     # 00521665
    push 0x0                                     # 00521667
    push dword ptr [ebp + arg_c]                 # 00521669
    push esi                                     # 0052166c
    call dword ptr [0x52a014]                    # 0052166d
    push esi                                     # 00521673
    {load} mov edi, eax                          # 00521674
    call dword ptr [0x52a000]                    # 00521676
    {load} xor eax, eax                          # 0052167c
    test edi, edi                                # 0052167e
    sete al                                      # 00521680
    pop edi                                      # 00521683
    jmp.d8 L_005216b1                            # 00521684
L_00521686:
    # block 0x00521686: entered by je at 0x0052164e, 12 instruction(s), calls USER32.dll!wsprintfA, KERNEL32.dll!WritePrivateProfileStringA, falls into the block at 0x005216b1
    push dword ptr [ebp + arg_10]                # 00521686
    lea eax, [ebp - local_10]                    # 00521689
    push 0x5300cc                                # 0052168c
    push eax                                     # 00521691
    call dword ptr [0x52a3e8]                    # 00521692
    add esp, 0xc                                 # 00521698
    lea eax, [ebp - local_10]                    # 0052169b
    push dword ptr [esi + field_90]              # 0052169e
    push eax                                     # 005216a4
    push dword ptr [ebp + arg_c]                 # 005216a5
    push dword ptr [ebp + arg_8]                 # 005216a8
    call dword ptr [0x52a26c]                    # 005216ab
L_005216b1:
    # block 0x005216b1: entered by je at 0x0052165c; jmp at 0x00521684, 3 instruction(s), ends with ret 0xc
    pop esi                                      # 005216b1
    leave                                        # 005216b2
    ret 0xc                                      # 005216b3

