# FUN_005258ba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005258ba
# extent:       0x005258ba-0x00525917 (93 code bytes)
# span:         0x005258ba-0x00525917 (code 93, tables 0, padding 0)
# sha256:       c8ce5222d0368cc1b21f66749badbb606062346110f38c63a3f53f77b5923607
# evidence:     ev_d63d6a362278f40ee32ccb564ca8ec5738c7bbf1d9d11225df7a30f9c22e09d6
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005258ba
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [edi + n] field_10, field_14, field_1c; [esi + n] field_4, field_8, field_c
# callees:      calls KERNEL32.dll!EnterCriticalSection, KERNEL32.dll!LeaveCriticalSection; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x005258ba - 0x401000
.globl FUN_005258ba
FUN_005258ba:
    # block 0x005258ba: entry, 15 instruction(s), calls KERNEL32.dll!EnterCriticalSection, ends with je to 0x005258fd (forward)
    push ebp                                     # 005258ba
    {load} mov ebp, esp                          # 005258bb
    push ecx                                     # 005258bd
    push ebx                                     # 005258be
    push esi                                     # 005258bf
    push edi                                     # 005258c0
    {load} mov edi, ecx                          # 005258c1
    lea eax, [edi + field_1c]                    # 005258c3
    push eax                                     # 005258c6
    mov dword ptr [ebp - local_4], eax           # 005258c7
    call dword ptr [0x52a0d0]                    # 005258ca
    mov esi, dword ptr [edi + field_14]          # 005258d0
    mov ebx, dword ptr [ebp + arg_8]             # 005258d3
    test esi, esi                                # 005258d6
    je.d8 L_005258fd                             # 005258d8
L_005258da:
    # block 0x005258da: entered by jne at 0x005258fb; fall-through of je at 0x005258d8, 2 instruction(s), ends with jge to 0x005258f6 (forward)
    cmp ebx, dword ptr [esi + field_8]           # 005258da
    jge.d8 L_005258f6                            # 005258dd
    # block 0x005258df: entered by fall-through of jge at 0x005258dd, 4 instruction(s), ends with je to 0x005258ef (forward)
    mov eax, dword ptr [esi + field_c]           # 005258df
    mov ecx, dword ptr [eax + 4*ebx]             # 005258e2
    test ecx, ecx                                # 005258e5
    je.d8 L_005258ef                             # 005258e7
    # block 0x005258e9: entered by fall-through of je at 0x005258e7, 3 instruction(s), calls indirect dword ptr [eax], falls into the block at 0x005258ef
    mov eax, dword ptr [ecx]                     # 005258e9
    push 0x1                                     # 005258eb
    call dword ptr [eax]                         # 005258ed
L_005258ef:
    # block 0x005258ef: entered by je at 0x005258e7, 2 instruction(s), falls into the block at 0x005258f6
    mov eax, dword ptr [esi + field_c]           # 005258ef
    and dword ptr [eax + 4*ebx], 0x0             # 005258f2
L_005258f6:
    # block 0x005258f6: entered by jge at 0x005258dd, 3 instruction(s), ends with jne to 0x005258da (backward)
    mov esi, dword ptr [esi + field_4]           # 005258f6
    test esi, esi                                # 005258f9
    jne.d8 L_005258da                            # 005258fb
L_005258fd:
    # block 0x005258fd: entered by je at 0x005258d8; fall-through of jne at 0x005258fb, 10 instruction(s), calls KERNEL32.dll!LeaveCriticalSection, ends with ret 0x4
    mov eax, dword ptr [edi + field_10]          # 005258fd
    push dword ptr [ebp - local_4]               # 00525900
    and dword ptr [eax + 8*ebx], -0x2            # 00525903
    lea eax, [eax + 8*ebx]                       # 00525907
    call dword ptr [0x52a0c8]                    # 0052590a
    pop edi                                      # 00525910
    pop esi                                      # 00525911
    pop ebx                                      # 00525912
    leave                                        # 00525913
    ret 0x4                                      # 00525914

