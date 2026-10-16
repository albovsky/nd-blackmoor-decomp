# FUN_0051f4ec
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f4ec
# extent:       0x0051f4ec-0x0051f599 (173 code bytes)
# span:         0x0051f4ec-0x0051f599 (code 173, tables 0, padding 0)
# sha256:       ecf4c39a2f7ee77ecce4e1c11a22341a99b8de38a1f893568e8287c08966013a
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f4ec
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2; [esi + n] field_94, field_98
# callees:      calls KERNEL32.dll!lstrcmpA, FUN_00519a54, FUN_005211ff, FUN_00519a4e, KERNEL32.dll!GlobalAlloc, FUN_00519a48; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 65 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98

# --- external targets -----------------------------------------------
.set FUN_00519a48, .text + (0x00519a48 - 0x401000)
.set FUN_00519a4e, .text + (0x00519a4e - 0x401000)
.set FUN_00519a54, .text + (0x00519a54 - 0x401000)
.set FUN_005211ff, .text + (0x005211ff - 0x401000)

.org 0x0051f4ec - 0x401000
.globl FUN_0051f4ec
FUN_0051f4ec:
    # block 0x0051f4ec: entry, 11 instruction(s), ends with je to 0x0051f592 (forward)
    push ebp                                     # 0051f4ec
    {load} mov ebp, esp                          # 0051f4ed
    push ecx                                     # 0051f4ef
    push ebx                                     # 0051f4f0
    push esi                                     # 0051f4f1
    {load} mov esi, ecx                          # 0051f4f2
    push edi                                     # 0051f4f4
    {load} xor edi, edi                          # 0051f4f5
    mov eax, dword ptr [esi + field_98]          # 0051f4f7
    {load} cmp eax, edi                          # 0051f4fd
    je.d32 L_0051f592                            # 0051f4ff
    # block 0x0051f505: entered by fall-through of je at 0x0051f4ff, 10 instruction(s), calls indirect ebx, KERNEL32.dll!lstrcmpA, ends with jne to 0x0051f592 (forward)
    mov ebx, dword ptr [0x52a204]                # 0051f505
    push eax                                     # 0051f50b
    call ebx                                     # 0051f50c
    movzx ecx, word ptr [eax + field_2]          # 0051f50e
    push dword ptr [ebp + arg_8]                 # 0051f512
    {load} add ecx, eax                          # 0051f515
    push ecx                                     # 0051f517
    call dword ptr [0x52a1e4]                    # 0051f518
    test eax, eax                                # 0051f51e
    jne.d8 L_0051f592                            # 0051f520
    # block 0x0051f522: entered by fall-through of jne at 0x0051f520, 7 instruction(s), calls FUN_00519a54, ends with je to 0x0051f592 (forward)
    lea eax, [ebp - local_4]                     # 0051f522
    push edi                                     # 0051f525
    push eax                                     # 0051f526
    push dword ptr [ebp + arg_8]                 # 0051f527
    call FUN_00519a54                            # 0051f52a
    test eax, eax                                # 0051f52f
    je.d8 L_0051f592                             # 0051f531
    # block 0x0051f533: entered by fall-through of je at 0x0051f531, 3 instruction(s), ends with je to 0x0051f543 (forward)
    mov eax, dword ptr [esi + field_94]          # 0051f533
    {load} cmp eax, edi                          # 0051f539
    je.d8 L_0051f543                             # 0051f53b
    # block 0x0051f53d: entered by fall-through of je at 0x0051f53b, 2 instruction(s), calls FUN_005211ff, falls into the block at 0x0051f543
    push eax                                     # 0051f53d
    call FUN_005211ff                            # 0051f53e
L_0051f543:
    # block 0x0051f543: entered by je at 0x0051f53b, 22 instruction(s), calls FUN_00519a4e, KERNEL32.dll!GlobalAlloc, indirect ebx, ends with je to 0x0051f58a (forward)
    push edi                                     # 0051f543
    push edi                                     # 0051f544
    push edi                                     # 0051f545
    push dword ptr [ebp + arg_8]                 # 0051f546
    push dword ptr [ebp - local_4]               # 0051f549
    push edi                                     # 0051f54c
    call FUN_00519a4e                            # 0051f54d
    push eax                                     # 0051f552
    push 0x42                                    # 0051f553
    call dword ptr [0x52a1dc]                    # 0051f555
    push eax                                     # 0051f55b
    mov dword ptr [esi + field_94], eax          # 0051f55c
    call ebx                                     # 0051f562
    push 0x2                                     # 0051f564
    push edi                                     # 0051f566
    push eax                                     # 0051f567
    push dword ptr [ebp + arg_8]                 # 0051f568
    push dword ptr [ebp - local_4]               # 0051f56b
    push edi                                     # 0051f56e
    call FUN_00519a4e                            # 0051f56f
    cmp eax, 0x1                                 # 0051f574
    je.d8 L_0051f58a                             # 0051f577
    # block 0x0051f579: entered by fall-through of je at 0x0051f577, 3 instruction(s), calls FUN_005211ff, falls into the block at 0x0051f58a
    push dword ptr [esi + field_94]              # 0051f579
    call FUN_005211ff                            # 0051f57f
    mov dword ptr [esi + field_94], edi          # 0051f584
L_0051f58a:
    # block 0x0051f58a: entered by je at 0x0051f577, 2 instruction(s), calls FUN_00519a48, falls into the block at 0x0051f592
    push dword ptr [ebp - local_4]               # 0051f58a
    call FUN_00519a48                            # 0051f58d
L_0051f592:
    # block 0x0051f592: entered by je at 0x0051f4ff; jne at 0x0051f520; je at 0x0051f531, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0051f592
    pop esi                                      # 0051f593
    pop ebx                                      # 0051f594
    leave                                        # 0051f595
    ret 0x4                                      # 0051f596

