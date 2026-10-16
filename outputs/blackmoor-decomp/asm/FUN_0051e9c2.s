# FUN_0051e9c2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e9c2
# extent:       0x0051e9c2-0x0051ea21 (95 code bytes)
# span:         0x0051e9c2-0x0051ea21 (code 95, tables 0, padding 0)
# sha256:       3acf86a26f9fe1dbde53a7533a8215cd776e0b37901fa8856803e126b34c2c82
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e9c2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4, field_minus_8, field_minus_c; [esp + n] stk_10, stk_14, stk_18
# callees:      calls FUN_0050fa90, FUN_0051e91e, FUN_0051e722
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_0051e722, .text + (0x0051e722 - 0x401000)
.set FUN_0051e91e, .text + (0x0051e91e - 0x401000)

.org 0x0051e9c2 - 0x401000
.globl FUN_0051e9c2
FUN_0051e9c2:
    # block 0x0051e9c2: entry, 7 instruction(s), ends with je to 0x0051ea1b (forward)
    push ebx                                     # 0051e9c2
    push esi                                     # 0051e9c3
    push edi                                     # 0051e9c4
    mov edi, dword ptr [esp + stk_10]            # 0051e9c5
    test edi, edi                                # 0051e9c9
    {load} mov esi, ecx                          # 0051e9cb
    je.d8 L_0051ea1b                             # 0051e9cd
    # block 0x0051e9cf: entered by fall-through of je at 0x0051e9cd, 4 instruction(s), ends with jg to 0x0051ea05 (forward)
    mov eax, dword ptr [esi]                     # 0051e9cf
    cmp dword ptr [eax - field_minus_c], 0x1     # 0051e9d1
    lea ebx, [eax - field_minus_c]               # 0051e9d5
    jg.d8 L_0051ea05                             # 0051e9d8
    # block 0x0051e9da: entered by fall-through of jg at 0x0051e9d8, 4 instruction(s), ends with jg to 0x0051ea05 (forward)
    mov ecx, dword ptr [eax - field_minus_8]     # 0051e9da
    lea edx, [ecx + edi]                         # 0051e9dd
    cmp edx, dword ptr [eax - field_minus_4]     # 0051e9e0
    jg.d8 L_0051ea05                             # 0051e9e3
    # block 0x0051e9e5: entered by fall-through of jg at 0x0051e9e3, 12 instruction(s), calls FUN_0050fa90, ends with forward jump to 0x0051ea1b
    push edi                                     # 0051e9e5
    {load} add ecx, eax                          # 0051e9e6
    push dword ptr [esp + stk_18]                # 0051e9e8
    push ecx                                     # 0051e9ec
    call FUN_0050fa90                            # 0051e9ed
    mov eax, dword ptr [esi]                     # 0051e9f2
    add esp, 0xc                                 # 0051e9f4
    add dword ptr [eax - field_minus_8], edi     # 0051e9f7
    mov eax, dword ptr [esi]                     # 0051e9fa
    mov ecx, dword ptr [eax - field_minus_8]     # 0051e9fc
    and byte ptr [ecx + eax], 0x0                # 0051e9ff
    jmp.d8 L_0051ea1b                            # 0051ea03
L_0051ea05:
    # block 0x0051ea05: entered by jg at 0x0051e9d8; jg at 0x0051e9e3, 8 instruction(s), calls FUN_0051e91e, FUN_0051e722, falls into the block at 0x0051ea1b
    push dword ptr [esp + stk_14]                # 0051ea05
    {load} mov ecx, esi                          # 0051ea09
    push edi                                     # 0051ea0b
    push eax                                     # 0051ea0c
    push dword ptr [eax - field_minus_8]         # 0051ea0d
    call FUN_0051e91e                            # 0051ea10
    push ebx                                     # 0051ea15
    call FUN_0051e722                            # 0051ea16
L_0051ea1b:
    # block 0x0051ea1b: entered by je at 0x0051e9cd; jmp at 0x0051ea03, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 0051ea1b
    pop esi                                      # 0051ea1c
    pop ebx                                      # 0051ea1d
    ret 0x8                                      # 0051ea1e

