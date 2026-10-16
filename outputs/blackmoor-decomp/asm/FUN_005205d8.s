# FUN_005205d8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005205d8
# extent:       0x005205d8-0x00520656 (126 code bytes)
# span:         0x005205d8-0x00520656 (code 126, tables 0, padding 0)
# sha256:       0abc4b36fe27934f6d67cee73511963f78bdfe1e015ba51621342b65494d092f
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005205d8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_minus_8; [edi + n] field_1, field_minus_8; [esi + n] field_4, field_8, field_c, field_10
# callees:      calls FUN_0051dc43, FUN_00525371, FUN_005216b6, USER32.dll!wsprintfA, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ local_8, 0x8  # offset -0x8
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_005216b6, .text + (0x005216b6 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x005205d8 - 0x401000
.globl FUN_005205d8
FUN_005205d8:
    # block 0x005205d8: entry, 25 instruction(s), calls FUN_0051dc43, FUN_00525371, FUN_005216b6, ends with jle to 0x00520649 (forward)
    push ebp                                     # 005205d8
    {load} mov ebp, esp                          # 005205d9
    push ecx                                     # 005205db
    push ecx                                     # 005205dc
    push esi                                     # 005205dd
    {load} mov esi, ecx                          # 005205de
    push edi                                     # 005205e0
    mov eax, dword ptr [esi + field_10]          # 005205e1
    mov eax, dword ptr [eax - field_minus_8]     # 005205e4
    add eax, 0x5                                 # 005205e7
    push eax                                     # 005205ea
    call FUN_0051dc43                            # 005205eb
    pop ecx                                      # 005205f0
    mov dword ptr [ebp - local_4], eax           # 005205f1
    call FUN_00525371                            # 005205f4
    mov eax, dword ptr [eax + field_4]           # 005205f9
    {load} xor edi, edi                          # 005205fc
    push edi                                     # 005205fe
    push edi                                     # 005205ff
    push dword ptr [esi + field_c]               # 00520600
    {load} mov ecx, eax                          # 00520603
    mov dword ptr [ebp - local_8], eax           # 00520605
    call FUN_005216b6                            # 00520608
    cmp dword ptr [esi + field_4], edi           # 0052060d
    jle.d8 L_00520649                            # 00520610
    # block 0x00520612: entered by fall-through of jle at 0x00520610, 1 instruction(s), falls into the block at 0x00520613
    push ebx                                     # 00520612
L_00520613:
    # block 0x00520613: entered by jl at 0x00520646, 10 instruction(s), calls USER32.dll!wsprintfA, ends with je to 0x00520641 (forward)
    lea ebx, [edi + field_1]                     # 00520613
    push ebx                                     # 00520616
    push dword ptr [esi + field_10]              # 00520617
    push dword ptr [ebp - local_4]               # 0052061a
    call dword ptr [0x52a3e8]                    # 0052061d
    mov eax, dword ptr [esi + field_8]           # 00520623
    add esp, 0xc                                 # 00520626
    mov edi, dword ptr [eax + 4*edi]             # 00520629
    cmp dword ptr [edi - field_minus_8], 0x0     # 0052062c
    je.d8 L_00520641                             # 00520630
    # block 0x00520632: entered by fall-through of je at 0x00520630, 5 instruction(s), calls FUN_005216b6, falls into the block at 0x00520641
    mov ecx, dword ptr [ebp - local_8]           # 00520632
    push edi                                     # 00520635
    push dword ptr [ebp - local_4]               # 00520636
    push dword ptr [esi + field_c]               # 00520639
    call FUN_005216b6                            # 0052063c
L_00520641:
    # block 0x00520641: entered by je at 0x00520630, 3 instruction(s), ends with jl to 0x00520613 (backward)
    {load} mov edi, ebx                          # 00520641
    cmp edi, dword ptr [esi + field_4]           # 00520643
    jl.d8 L_00520613                             # 00520646
    # block 0x00520648: entered by fall-through of jl at 0x00520646, 1 instruction(s), falls into the block at 0x00520649
    pop ebx                                      # 00520648
L_00520649:
    # block 0x00520649: entered by jle at 0x00520610, 7 instruction(s), calls FUN_0051dc6c, ends with ret
    push dword ptr [ebp - local_4]               # 00520649
    call FUN_0051dc6c                            # 0052064c
    pop ecx                                      # 00520651
    pop edi                                      # 00520652
    pop esi                                      # 00520653
    leave                                        # 00520654
    ret                                          # 00520655

