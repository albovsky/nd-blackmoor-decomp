# FUN_0050acd0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050acd0
# extent:       0x0050acd0-0x0050ad50 (128 code bytes)
# span:         0x0050acd0-0x0050ad50 (code 128, tables 0, padding 0)
# sha256:       c89d495565a98143fa06c2972f9bac169057a8d0f60d945e865289677475212a
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050acd0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebx + n] field_1c; [edi + n] field_10; [esi + n] field_4, field_8, field_c, field_14; [esp + n] stk_8, stk_10, stk_1c, stk_24, stk_34
# callees:      calls FUN_0050ad50, FUN_0050aeb0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ stk_24, 0x24  # offset +0x24
.equ stk_34, 0x34  # offset +0x34

# --- external targets -----------------------------------------------
.set FUN_0050ad50, .text + (0x0050ad50 - 0x401000)
.set FUN_0050aeb0, .text + (0x0050aeb0 - 0x401000)

.org 0x0050acd0 - 0x401000
.globl FUN_0050acd0
FUN_0050acd0:
    # block 0x0050acd0: entry, 14 instruction(s), calls FUN_0050ad50, ends with je to 0x0050ad2c (forward)
    push ebx                                     # 0050acd0
    mov ebx, dword ptr [esp + stk_8]             # 0050acd1
    push esi                                     # 0050acd5
    mov esi, dword ptr [esp + stk_10]            # 0050acd6
    push edi                                     # 0050acda
    push esi                                     # 0050acdb
    mov edi, dword ptr [esi + field_14]          # 0050acdc
    push edi                                     # 0050acdf
    push ebx                                     # 0050ace0
    call FUN_0050ad50                            # 0050ace1
    mov edx, dword ptr [esp + stk_24]            # 0050ace6
    add esp, 0xc                                 # 0050acea
    test edx, edx                                # 0050aced
    je.d8 L_0050ad2c                             # 0050acef
    # block 0x0050acf1: entered by fall-through of je at 0x0050acef, 26 instruction(s), calls FUN_0050aeb0, ends with ret
    mov ecx, dword ptr [ebx + field_1c]          # 0050acf1
    mov eax, dword ptr [esi + field_4]           # 0050acf4
    fild dword ptr [edi + field_10]              # 0050acf7
    push ecx                                     # 0050acfa
    fstp dword ptr [esp]                         # 0050acfb
    fld dword ptr [edx + 4*eax]                  # 0050acfe
    push ecx                                     # 0050ad01
    fstp dword ptr [esp]                         # 0050ad02
    push eax                                     # 0050ad05
    mov eax, dword ptr [esi]                     # 0050ad06
    push edx                                     # 0050ad08
    mov edx, dword ptr [esi + 4*ecx + field_c]   # 0050ad09
    push eax                                     # 0050ad0d
    mov eax, dword ptr [esi + field_8]           # 0050ad0e
    push edx                                     # 0050ad11
    mov edx, dword ptr [esp + stk_34]            # 0050ad12
    mov ecx, dword ptr [eax + 4*ecx]             # 0050ad16
    push ecx                                     # 0050ad19
    push edx                                     # 0050ad1a
    call FUN_0050aeb0                            # 0050ad1b
    add esp, 0x20                                # 0050ad20
    mov eax, 0x1                                 # 0050ad23
    pop edi                                      # 0050ad28
    pop esi                                      # 0050ad29
    pop ebx                                      # 0050ad2a
    ret                                          # 0050ad2b
L_0050ad2c:
    # block 0x0050ad2c: entered by je at 0x0050acef, 16 instruction(s), ends with ret
    mov eax, dword ptr [ebx + field_1c]          # 0050ad2c
    mov edi, dword ptr [esp + stk_1c]            # 0050ad2f
    mov ecx, dword ptr [esi + 4*eax + field_c]   # 0050ad33
    {load} xor eax, eax                          # 0050ad37
    shl ecx, 0x2                                 # 0050ad39
    {load} mov edx, ecx                          # 0050ad3c
    shr ecx, 0x2                                 # 0050ad3e
    rep stosd dword ptr es:[edi], eax            # 0050ad41
    {load} mov ecx, edx                          # 0050ad43
    and ecx, 0x3                                 # 0050ad45
    rep stosb byte ptr es:[edi], al              # 0050ad48
    pop edi                                      # 0050ad4a
    pop esi                                      # 0050ad4b
    {load} xor eax, eax                          # 0050ad4c
    pop ebx                                      # 0050ad4e
    ret                                          # 0050ad4f

