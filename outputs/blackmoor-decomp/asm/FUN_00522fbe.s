# FUN_00522fbe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522fbe
# extent:       0x00522fbe-0x00523056 (152 code bytes)
# span:         0x00522fbe-0x00523056 (code 152, tables 0, padding 0)
# sha256:       32ee30f3478adbdf8d5b9bf5fbc9544d5e2bc9b94757fb284f07c9114d6d891d
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522fbe
# arguments:    8 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24; ret 0x20 (callee pops 32 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4, field_8, field_c, field_1c, field_a4; [esi + n] field_ac
# callees:      calls FUN_00525371, USER32.dll!LoadMenuA, FUN_0051e8f7, FUN_0051b125, USER32.dll!DestroyMenu; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 64 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ field_a4, 0xa4  # offset +0xa4
.equ field_ac, 0xac  # offset +0xac

# --- external targets -----------------------------------------------
.set FUN_0051b125, .text + (0x0051b125 - 0x401000)
.set FUN_0051e8f7, .text + (0x0051e8f7 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00522fbe - 0x401000
.globl FUN_00522fbe
FUN_00522fbe:
    # block 0x00522fbe: entry, 10 instruction(s), ends with je to 0x00522ff3 (forward)
    push ebp                                     # 00522fbe
    {load} mov ebp, esp                          # 00522fbf
    push ebx                                     # 00522fc1
    push esi                                     # 00522fc2
    push edi                                     # 00522fc3
    {load} xor edi, edi                          # 00522fc4
    {load} xor ebx, ebx                          # 00522fc6
    cmp dword ptr [ebp + arg_1c], edi            # 00522fc8
    {load} mov esi, ecx                          # 00522fcb
    je.d8 L_00522ff3                             # 00522fcd
    # block 0x00522fcf: entered by fall-through of je at 0x00522fcd, 8 instruction(s), calls FUN_00525371, USER32.dll!LoadMenuA, ends with jne to 0x00522ff3 (forward)
    call FUN_00525371                            # 00522fcf
    push dword ptr [ebp + arg_1c]                # 00522fd4
    mov eax, dword ptr [eax + field_c]           # 00522fd7
    push eax                                     # 00522fda
    call dword ptr [0x52a38c]                    # 00522fdb
    {load} mov ebx, eax                          # 00522fe1
    {load} cmp ebx, edi                          # 00522fe3
    jne.d8 L_00522ff3                            # 00522fe5
    # block 0x00522fe7: entered by fall-through of jne at 0x00522fe5, 4 instruction(s), calls indirect dword ptr [eax + 0xa4], ends with forward jump to 0x00523048
    mov eax, dword ptr [esi]                     # 00522fe7
    {load} mov ecx, esi                          # 00522fe9
    call dword ptr [eax + field_a4]              # 00522feb
    jmp.d8 L_00523048                            # 00522ff1
L_00522ff3:
    # block 0x00522ff3: entered by je at 0x00522fcd; jne at 0x00522fe5, 6 instruction(s), calls FUN_0051e8f7, ends with je to 0x0052300b (forward)
    push dword ptr [ebp + arg_c]                 # 00522ff3
    lea ecx, [esi + field_ac]                    # 00522ff6
    call FUN_0051e8f7                            # 00522ffc
    mov eax, dword ptr [ebp + arg_18]            # 00523001
    {load} cmp eax, edi                          # 00523004
    je.d8 L_0052300b                             # 00523006
    # block 0x00523008: entered by fall-through of je at 0x00523006, 1 instruction(s), falls into the block at 0x0052300b
    mov edi, dword ptr [eax + field_1c]          # 00523008
L_0052300b:
    # block 0x0052300b: entered by je at 0x00523006, 22 instruction(s), calls FUN_0051b125, ends with jne to 0x0052304c (forward)
    push dword ptr [ebp + arg_24]                # 0052300b
    mov eax, dword ptr [ebp + arg_14]            # 0052300e
    mov ecx, dword ptr [eax + field_4]           # 00523011
    mov edx, dword ptr [eax]                     # 00523014
    push ebx                                     # 00523016
    push edi                                     # 00523017
    mov edi, dword ptr [eax + field_c]           # 00523018
    mov eax, dword ptr [eax + field_8]           # 0052301b
    {load} sub edi, ecx                          # 0052301e
    {load} sub eax, edx                          # 00523020
    push edi                                     # 00523022
    push eax                                     # 00523023
    push ecx                                     # 00523024
    push edx                                     # 00523025
    push dword ptr [ebp + arg_10]                # 00523026
    {load} mov ecx, esi                          # 00523029
    push dword ptr [ebp + arg_c]                 # 0052302b
    push dword ptr [ebp + arg_8]                 # 0052302e
    push dword ptr [ebp + arg_20]                # 00523031
    call FUN_0051b125                            # 00523034
    test eax, eax                                # 00523039
    jne.d8 L_0052304c                            # 0052303b
    # block 0x0052303d: entered by fall-through of jne at 0x0052303b, 2 instruction(s), ends with je to 0x00523048 (forward)
    test ebx, ebx                                # 0052303d
    je.d8 L_00523048                             # 0052303f
    # block 0x00523041: entered by fall-through of je at 0x0052303f, 2 instruction(s), calls USER32.dll!DestroyMenu, falls into the block at 0x00523048
    push ebx                                     # 00523041
    call dword ptr [0x52a388]                    # 00523042
L_00523048:
    # block 0x00523048: entered by jmp at 0x00522ff1; je at 0x0052303f, 2 instruction(s), ends with forward jump to 0x0052304f
    {load} xor eax, eax                          # 00523048
    jmp.d8 L_0052304f                            # 0052304a
L_0052304c:
    # block 0x0052304c: entered by jne at 0x0052303b, 2 instruction(s), falls into the block at 0x0052304f
    push 0x1                                     # 0052304c
    pop eax                                      # 0052304e
L_0052304f:
    # block 0x0052304f: entered by jmp at 0x0052304a, 5 instruction(s), ends with ret 0x20
    pop edi                                      # 0052304f
    pop esi                                      # 00523050
    pop ebx                                      # 00523051
    pop ebp                                      # 00523052
    ret 0x20                                     # 00523053

