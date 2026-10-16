# FUN_00523056
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00523056
# extent:       0x00523056-0x005230ce (120 code bytes)
# span:         0x00523056-0x005230ce (code 120, tables 0, padding 0)
# sha256:       918ecc4451e4e6edae9cb378df56f390e2410a7e40951d96d9363090fc05c15b
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00523056
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_54
# callees:      calls FUN_0051f5cb, FUN_0051d540, FUN_0051d55a; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 51 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005230ce
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_54, 0x54  # offset +0x54

# --- external targets -----------------------------------------------
.set FUN_0051d540, .text + (0x0051d540 - 0x401000)
.set FUN_0051d55a, .text + (0x0051d55a - 0x401000)
.set FUN_0051f5cb, .text + (0x0051f5cb - 0x401000)

.org 0x00523056 - 0x401000
.globl FUN_00523056
FUN_00523056:
    # block 0x00523056: entry, 14 instruction(s), calls FUN_0051f5cb, ends with je to 0x0052309d (forward)
    push ebp                                     # 00523056
    {load} mov ebp, esp                          # 00523057
    sub esp, 0x14                                # 00523059
    push ebx                                     # 0052305c
    mov ebx, dword ptr [ebp + arg_8]             # 0052305d
    mov dword ptr [ebp - local_4], ecx           # 00523060
    push esi                                     # 00523063
    mov ecx, dword ptr [ebx]                     # 00523064
    push edi                                     # 00523066
    call FUN_0051f5cb                            # 00523067
    {load} mov edi, eax                          # 0052306c
    {load} xor esi, esi                          # 0052306e
    {load} cmp edi, esi                          # 00523070
    je.d8 L_0052309d                             # 00523072
    # block 0x00523074: entered by fall-through of je at 0x00523072, 17 instruction(s), calls indirect dword ptr [eax + 0x54], ends with jne to 0x005230a1 (forward)
    push ebx                                     # 00523074
    mov eax, dword ptr [edi]                     # 00523075
    push dword ptr [ebp + arg_c]                 # 00523077
    lea ecx, [ebp - local_14]                    # 0052307a
    mov dword ptr [ebp - local_14], esi          # 0052307d
    mov dword ptr [ebp - local_10], esi          # 00523080
    push dword ptr [ebp - local_4]               # 00523083
    mov dword ptr [ebp - local_c], esi           # 00523086
    mov dword ptr [ebp - local_8], esi           # 00523089
    push ecx                                     # 0052308c
    push 0x50800000                              # 0052308d
    push esi                                     # 00523092
    push esi                                     # 00523093
    {load} mov ecx, edi                          # 00523094
    call dword ptr [eax + field_54]              # 00523096
    test eax, eax                                # 00523099
    jne.d8 L_005230a1                            # 0052309b
L_0052309d:
    # block 0x0052309d: entered by je at 0x00523072; fall-through of jne at 0x0052309b, 2 instruction(s), ends with forward jump to 0x005230c7
    {load} xor eax, eax                          # 0052309d
    jmp.d8 L_005230c7                            # 0052309f
L_005230a1:
    # block 0x005230a1: entered by jne at 0x0052309b, 2 instruction(s), ends with je to 0x005230c5 (forward)
    cmp dword ptr [0x63c7a4], esi                # 005230a1
    je.d8 L_005230c5                             # 005230a7
    # block 0x005230a9: entered by fall-through of je at 0x005230a7, 5 instruction(s), calls FUN_0051d540, ends with je to 0x005230c5 (forward)
    {load} mov ecx, edi                          # 005230a9
    call FUN_0051d540                            # 005230ab
    mov ecx, 0x200                               # 005230b0
    test ecx, eax                                # 005230b5
    je.d8 L_005230c5                             # 005230b7
    # block 0x005230b9: entered by fall-through of je at 0x005230b7, 5 instruction(s), calls FUN_0051d55a, falls into the block at 0x005230c5
    push 0x20                                    # 005230b9
    push esi                                     # 005230bb
    push ecx                                     # 005230bc
    mov ecx, dword ptr [ebp - local_4]           # 005230bd
    call FUN_0051d55a                            # 005230c0
L_005230c5:
    # block 0x005230c5: entered by je at 0x005230a7; je at 0x005230b7, 1 instruction(s), falls into the block at 0x005230c7
    {load} mov eax, edi                          # 005230c5
L_005230c7:
    # block 0x005230c7: entered by jmp at 0x0052309f, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 005230c7
    pop esi                                      # 005230c8
    pop ebx                                      # 005230c9
    leave                                        # 005230ca
    ret 0x8                                      # 005230cb

