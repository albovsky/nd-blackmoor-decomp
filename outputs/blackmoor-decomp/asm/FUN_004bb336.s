# FUN_004bb336
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bb336
# extent:       0x004bb336-0x004bb3de (168 code bytes)
# span:         0x004bb336-0x004bb3de (code 168, tables 0, padding 0)
# sha256:       f4a1c17302fb943029dc07c8397d0b00ccb4034baf4a974a391e60108d20e993
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bb336
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_24, field_2d8, field_310; [ecx + n] field_28, field_40, field_2d8, field_310; [edx + n] field_44, field_310
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_2d8, 0x2d8  # offset +0x2d8
.equ field_310, 0x310  # offset +0x310

# --- external targets -----------------------------------------------

.org 0x004bb336 - 0x401000
.globl FUN_004bb336
FUN_004bb336:
    # block 0x004bb336: entry, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004bb370
    push ebp                                     # 004bb336
    {load} mov ebp, esp                          # 004bb337
    push ecx                                     # 004bb339
    mov dword ptr [ebp - local_4], ecx           # 004bb33a
    call dword ptr [0x52a23c]                    # 004bb33d
    mov ecx, dword ptr [ebp - local_4]           # 004bb343
    mov dword ptr [ecx + field_2d8], eax         # 004bb346
    mov edx, dword ptr [ebp - local_4]           # 004bb34c
    mov dword ptr [edx + field_310], 0x0         # 004bb34f
    jmp.d8 L_004bb370                            # 004bb359
L_004bb35b:
    # block 0x004bb35b: entered by jmp at 0x004bb3d8, 5 instruction(s), falls into the block at 0x004bb370
    mov eax, dword ptr [ebp - local_4]           # 004bb35b
    mov ecx, dword ptr [eax + field_310]         # 004bb35e
    add ecx, 0x1                                 # 004bb364
    mov edx, dword ptr [ebp - local_4]           # 004bb367
    mov dword ptr [edx + field_310], ecx         # 004bb36a
L_004bb370:
    # block 0x004bb370: entered by jmp at 0x004bb359, 3 instruction(s), ends with jge to 0x004bb3da (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bb370
    cmp dword ptr [eax + field_310], 0x2         # 004bb373
    jge.d8 L_004bb3da                            # 004bb37a
    # block 0x004bb37c: entered by fall-through of jge at 0x004bb37a, 5 instruction(s), ends with jne to 0x004bb3d8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bb37c
    mov edx, dword ptr [ecx + field_310]         # 004bb37f
    mov eax, dword ptr [ebp - local_4]           # 004bb385
    cmp dword ptr [eax + 8*edx + field_24], 0x1  # 004bb388
    jne.d8 L_004bb3d8                            # 004bb38d
    # block 0x004bb38f: entered by fall-through of jne at 0x004bb38d, 7 instruction(s), ends with jbe to 0x004bb3d8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bb38f
    mov edx, dword ptr [ecx + field_310]         # 004bb392
    mov eax, dword ptr [ebp - local_4]           # 004bb398
    mov ecx, dword ptr [ebp - local_4]           # 004bb39b
    mov eax, dword ptr [eax + field_2d8]         # 004bb39e
    cmp eax, dword ptr [ecx + 8*edx + field_28]  # 004bb3a4
    jbe.d8 L_004bb3d8                            # 004bb3a8
    # block 0x004bb3aa: entered by fall-through of jbe at 0x004bb3a8, 3 instruction(s), ends with jne to 0x004bb3c2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bb3aa
    cmp dword ptr [ecx + field_310], 0x0         # 004bb3ad
    jne.d8 L_004bb3c2                            # 004bb3b4
    # block 0x004bb3b6: entered by fall-through of jne at 0x004bb3b4, 3 instruction(s), ends with forward jump to 0x004bb3d8
    mov edx, dword ptr [ebp - local_4]           # 004bb3b6
    mov dword ptr [edx + field_44], 0x1          # 004bb3b9
    jmp.d8 L_004bb3d8                            # 004bb3c0
L_004bb3c2:
    # block 0x004bb3c2: entered by jne at 0x004bb3b4, 3 instruction(s), ends with jne to 0x004bb3d8 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bb3c2
    cmp dword ptr [eax + field_310], 0x1         # 004bb3c5
    jne.d8 L_004bb3d8                            # 004bb3cc
    # block 0x004bb3ce: entered by fall-through of jne at 0x004bb3cc, 2 instruction(s), falls into the block at 0x004bb3d8
    mov ecx, dword ptr [ebp - local_4]           # 004bb3ce
    mov dword ptr [ecx + field_40], 0x1          # 004bb3d1
L_004bb3d8:
    # block 0x004bb3d8: entered by jne at 0x004bb38d; jbe at 0x004bb3a8; jmp at 0x004bb3c0; jne at 0x004bb3cc, 1 instruction(s), ends with backward jump to 0x004bb35b
    jmp.d8 L_004bb35b                            # 004bb3d8
L_004bb3da:
    # block 0x004bb3da: entered by jge at 0x004bb37a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004bb3da
    pop ebp                                      # 004bb3dc
    ret                                          # 004bb3dd

