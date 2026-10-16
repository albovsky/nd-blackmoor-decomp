# FUN_0051f8c4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f8c4
# extent:       0x0051f8c4-0x0051f929 (101 code bytes)
# span:         0x0051f8c4-0x0051f929 (code 101, tables 0, padding 0)
# sha256:       e7513b1a217edac3ecc6de2f796a8b3027d55ff604bedbf56424285629afc874
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f8c4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4; [esi + n] field_20, field_2c, field_40, field_44
# callees:      calls FUN_0051a643, FUN_0051a492; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_20, 0x20  # offset +0x20
.equ field_2c, 0x2c  # offset +0x2c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44

# --- external targets -----------------------------------------------
.set FUN_0051a492, .text + (0x0051a492 - 0x401000)
.set FUN_0051a643, .text + (0x0051a643 - 0x401000)

.org 0x0051f8c4 - 0x401000
.globl FUN_0051f8c4
FUN_0051f8c4:
    # block 0x0051f8c4: entry, 7 instruction(s), ends with je to 0x0051f926 (forward)
    push ebp                                     # 0051f8c4
    {load} mov ebp, esp                          # 0051f8c5
    sub esp, 0xc                                 # 0051f8c7
    push esi                                     # 0051f8ca
    {load} mov esi, ecx                          # 0051f8cb
    test esi, esi                                # 0051f8cd
    je.d8 L_0051f926                             # 0051f8cf
    # block 0x0051f8d1: entered by fall-through of je at 0x0051f8cf, 6 instruction(s), ends with je to 0x0051f91e (forward)
    mov eax, dword ptr [esi + field_2c]          # 0051f8d1
    neg eax                                      # 0051f8d4
    {load} sbb eax, eax                          # 0051f8d6
    test eax, eax                                # 0051f8d8
    mov dword ptr [ebp - local_8], eax           # 0051f8da
    je.d8 L_0051f91e                             # 0051f8dd
    # block 0x0051f8df: entered by fall-through of je at 0x0051f8dd, 2 instruction(s), falls into the block at 0x0051f8e3
    push edi                                     # 0051f8df
    lea edi, [esi + field_20]                    # 0051f8e0
L_0051f8e3:
    # block 0x0051f8e3: entered by jne at 0x0051f91b, 13 instruction(s), calls FUN_0051a643, ends with jne to 0x0051f909 (forward)
    lea eax, [ebp - local_4]                     # 0051f8e3
    {load} mov ecx, edi                          # 0051f8e6
    push eax                                     # 0051f8e8
    lea eax, [ebp - local_c]                     # 0051f8e9
    push eax                                     # 0051f8ec
    lea eax, [ebp - local_8]                     # 0051f8ed
    push eax                                     # 0051f8f0
    call FUN_0051a643                            # 0051f8f1
    mov eax, dword ptr [esi + field_40]          # 0051f8f6
    add eax, dword ptr [ebp - local_4]           # 0051f8f9
    and dword ptr [eax], 0x0                     # 0051f8fc
    cmp dword ptr [esi + field_44], 0x2          # 0051f8ff
    jne.d8 L_0051f909                            # 0051f903
    # block 0x0051f905: entered by fall-through of jne at 0x0051f903, 1 instruction(s), falls into the block at 0x0051f909
    and dword ptr [eax + field_4], 0x0           # 0051f905
L_0051f909:
    # block 0x0051f909: entered by jne at 0x0051f903, 3 instruction(s), ends with je to 0x0051f917 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0051f909
    test ecx, ecx                                # 0051f90c
    je.d8 L_0051f917                             # 0051f90e
    # block 0x0051f910: entered by fall-through of je at 0x0051f90e, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x0051f917
    mov eax, dword ptr [ecx]                     # 0051f910
    push 0x1                                     # 0051f912
    call dword ptr [eax + field_4]               # 0051f914
L_0051f917:
    # block 0x0051f917: entered by je at 0x0051f90e, 2 instruction(s), ends with jne to 0x0051f8e3 (backward)
    cmp dword ptr [ebp - local_8], 0x0           # 0051f917
    jne.d8 L_0051f8e3                            # 0051f91b
    # block 0x0051f91d: entered by fall-through of jne at 0x0051f91b, 1 instruction(s), falls into the block at 0x0051f91e
    pop edi                                      # 0051f91d
L_0051f91e:
    # block 0x0051f91e: entered by je at 0x0051f8dd, 2 instruction(s), calls FUN_0051a492, falls into the block at 0x0051f926
    lea ecx, [esi + field_20]                    # 0051f91e
    call FUN_0051a492                            # 0051f921
L_0051f926:
    # block 0x0051f926: entered by je at 0x0051f8cf, 3 instruction(s), ends with ret
    pop esi                                      # 0051f926
    leave                                        # 0051f927
    ret                                          # 0051f928

