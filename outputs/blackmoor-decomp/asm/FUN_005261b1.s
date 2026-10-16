# FUN_005261b1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005261b1
# extent:       0x005261b1-0x00526245 (148 code bytes)
# span:         0x005261b1-0x00526245 (code 148, tables 0, padding 0)
# sha256:       c13b790c1501ca1fef0717934596913fb010137cbc8b129e51e1f1ceea8f9003
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005261b1
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_90; [ebx + n] field_7c
# callees:      calls ADVAPI32.dll!RegOpenKeyExA; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 65 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_7c, 0x7c  # offset +0x7c
.equ field_90, 0x90  # offset +0x90

# --- external targets -----------------------------------------------

.org 0x005261b1 - 0x401000
.globl FUN_005261b1
FUN_005261b1:
    # block 0x005261b1: entry, 22 instruction(s), calls ADVAPI32.dll!RegOpenKeyExA, ends with jne to 0x00526223 (forward)
    push ebp                                     # 005261b1
    {load} mov ebp, esp                          # 005261b2
    sub esp, 0x14                                # 005261b4
    push ebx                                     # 005261b7
    push esi                                     # 005261b8
    lea eax, [ebp - local_4]                     # 005261b9
    push edi                                     # 005261bc
    mov esi, 0x2001f                             # 005261bd
    {load} xor edi, edi                          # 005261c2
    push eax                                     # 005261c4
    push esi                                     # 005261c5
    push edi                                     # 005261c6
    {load} mov ebx, ecx                          # 005261c7
    push 0x5300c0                                # 005261c9
    push 0x80000001                              # 005261ce
    mov dword ptr [ebp - local_14], ebx          # 005261d3
    mov dword ptr [ebp - local_c], edi           # 005261d6
    mov dword ptr [ebp - local_4], edi           # 005261d9
    mov dword ptr [ebp - local_8], edi           # 005261dc
    call dword ptr [0x52a010]                    # 005261df
    test eax, eax                                # 005261e5
    jne.d8 L_00526223                            # 005261e7
    # block 0x005261e9: entered by fall-through of jne at 0x005261e7, 15 instruction(s), calls indirect ebx, ends with jne to 0x00526223 (forward)
    lea eax, [ebp - local_10]                    # 005261e9
    push eax                                     # 005261ec
    lea eax, [ebp - local_8]                     # 005261ed
    push eax                                     # 005261f0
    push edi                                     # 005261f1
    push esi                                     # 005261f2
    push edi                                     # 005261f3
    push edi                                     # 005261f4
    push edi                                     # 005261f5
    push dword ptr [ebx + field_7c]              # 005261f6
    mov ebx, dword ptr [0x52a008]                # 005261f9
    push dword ptr [ebp - local_4]               # 005261ff
    call ebx                                     # 00526202
    test eax, eax                                # 00526204
    jne.d8 L_00526223                            # 00526206
    # block 0x00526208: entered by fall-through of jne at 0x00526206, 13 instruction(s), calls indirect ebx, falls into the block at 0x00526223
    lea eax, [ebp - local_10]                    # 00526208
    push eax                                     # 0052620b
    lea eax, [ebp - local_c]                     # 0052620c
    push eax                                     # 0052620f
    mov eax, dword ptr [ebp - local_14]          # 00526210
    push edi                                     # 00526213
    push esi                                     # 00526214
    push edi                                     # 00526215
    push edi                                     # 00526216
    push edi                                     # 00526217
    push dword ptr [eax + field_90]              # 00526218
    push dword ptr [ebp - local_8]               # 0052621e
    call ebx                                     # 00526221
L_00526223:
    # block 0x00526223: entered by jne at 0x005261e7; jne at 0x00526206, 3 instruction(s), ends with je to 0x00526233 (forward)
    cmp dword ptr [ebp - local_4], edi           # 00526223
    mov esi, dword ptr [0x52a000]                # 00526226
    je.d8 L_00526233                             # 0052622c
    # block 0x0052622e: entered by fall-through of je at 0x0052622c, 2 instruction(s), calls indirect esi, falls into the block at 0x00526233
    push dword ptr [ebp - local_4]               # 0052622e
    call esi                                     # 00526231
L_00526233:
    # block 0x00526233: entered by je at 0x0052622c, 2 instruction(s), ends with je to 0x0052623d (forward)
    cmp dword ptr [ebp - local_8], edi           # 00526233
    je.d8 L_0052623d                             # 00526236
    # block 0x00526238: entered by fall-through of je at 0x00526236, 2 instruction(s), calls indirect esi, falls into the block at 0x0052623d
    push dword ptr [ebp - local_8]               # 00526238
    call esi                                     # 0052623b
L_0052623d:
    # block 0x0052623d: entered by je at 0x00526236, 6 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_c]           # 0052623d
    pop edi                                      # 00526240
    pop esi                                      # 00526241
    pop ebx                                      # 00526242
    leave                                        # 00526243
    ret                                          # 00526244

