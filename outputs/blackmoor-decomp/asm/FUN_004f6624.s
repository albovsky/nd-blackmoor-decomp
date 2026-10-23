# FUN_004f6624
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f6624
# extent:       0x004f6624-0x004f67be (410 code bytes)
# span:         0x004f6624-0x004f67be (code 410, tables 0, padding 0)
# sha256:       8897f9217ff3e12ec38a9890c22b11a623fb6cd232cab2669459d4780afc0525
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f6624
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_16e, field_3be, field_3c2; [ecx + n] field_162, field_172, field_3be, field_3c2; [edx + n] field_19e, field_28f, field_3be, field_3ce
# callees:      calls FUN_004f709c, FUN_0050ca3e, FUN_0044a2b7, FUN_004f6059
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 99 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_162, 0x162  # offset +0x162
.equ field_16e, 0x16e  # offset +0x16e
.equ field_172, 0x172  # offset +0x172
.equ field_19e, 0x19e  # offset +0x19e
.equ field_28f, 0x28f  # offset +0x28f
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f6059, .text + (0x004f6059 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f6624 - 0x401000
.globl FUN_004f6624
FUN_004f6624:
    # block 0x004f6624: entry, 10 instruction(s), calls FUN_004f709c, ends with jne to 0x004f666e (forward)
    push ebp                                     # 004f6624
    {load} mov ebp, esp                          # 004f6625
    sub esp, 0x8                                 # 004f6627
    mov dword ptr [ebp - local_8], ecx           # 004f662a
    mov eax, dword ptr [ebp - local_8]           # 004f662d
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f6630
    mov ecx, dword ptr [ebp - local_8]           # 004f663a
    call FUN_004f709c                            # 004f663d
    test eax, eax                                # 004f6642
    jne.d8 L_004f666e                            # 004f6644
    # block 0x004f6646: entered by fall-through of jne at 0x004f6644, 7 instruction(s), ends with forward jump to 0x004f67b8
    mov ecx, dword ptr [ebp - local_8]           # 004f6646
    mov dword ptr [ecx + field_3c2], 0x3ea       # 004f6649
    mov edx, dword ptr [ebp - local_8]           # 004f6653
    mov dword ptr [edx + field_3be], 0x0         # 004f6656
    mov eax, dword ptr [ebp - local_8]           # 004f6660
    mov eax, dword ptr [eax + field_3be]         # 004f6663
    jmp.d32 L_004f67b8                           # 004f6669
L_004f666e:
    # block 0x004f666e: entered by jne at 0x004f6644, 9 instruction(s), ends with je to 0x004f669d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004f666e
    imul ecx, ecx, 0x5bb                         # 004f6671
    mov edx, dword ptr [ebp - local_8]           # 004f6677
    mov eax, dword ptr [edx + field_3ce]         # 004f667a
    {load} add eax, ecx                          # 004f6680
    mov dword ptr [ebp - local_4], eax           # 004f6682
    mov ecx, dword ptr [ebp - local_4]           # 004f6685
    cmp dword ptr [ecx + field_162], 0x0         # 004f6688
    je.d8 L_004f669d                             # 004f668f
    # block 0x004f6691: entered by fall-through of je at 0x004f668f, 3 instruction(s), ends with jne to 0x004f66c5 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f6691
    cmp dword ptr [edx + field_28f], 0x0         # 004f6694
    jne.d8 L_004f66c5                            # 004f669b
L_004f669d:
    # block 0x004f669d: entered by je at 0x004f668f; fall-through of jne at 0x004f669b, 7 instruction(s), ends with forward jump to 0x004f67b8
    mov eax, dword ptr [ebp - local_8]           # 004f669d
    mov dword ptr [eax + field_3c2], 0x3ef       # 004f66a0
    mov ecx, dword ptr [ebp - local_8]           # 004f66aa
    mov dword ptr [ecx + field_3be], 0x0         # 004f66ad
    mov edx, dword ptr [ebp - local_8]           # 004f66b7
    mov eax, dword ptr [edx + field_3be]         # 004f66ba
    jmp.d32 L_004f67b8                           # 004f66c0
L_004f66c5:
    # block 0x004f66c5: entered by jne at 0x004f669b, 3 instruction(s), ends with je to 0x004f6795 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f66c5
    cmp dword ptr [eax + field_16e], 0x0         # 004f66c8
    je.d32 L_004f6795                            # 004f66cf
    # block 0x004f66d5: entered by fall-through of je at 0x004f66cf, 4 instruction(s), ends with jne to 0x004f6795 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f66d5
    mov edx, dword ptr [ecx + field_172]         # 004f66d8
    cmp edx, dword ptr [ebp + arg_c]             # 004f66de
    jne.d32 L_004f6795                           # 004f66e1
    # block 0x004f66e7: entered by fall-through of jne at 0x004f66e1, 7 instruction(s), ends with je to 0x004f6749 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f66e7
    mov dword ptr [eax + field_16e], 0x0         # 004f66ea
    mov ecx, dword ptr [ebp - local_4]           # 004f66f4
    mov dword ptr [ecx + field_172], 0x0         # 004f66f7
    mov edx, dword ptr [ebp - local_4]           # 004f6701
    cmp dword ptr [edx + field_19e], 0x0         # 004f6704
    je.d8 L_004f6749                             # 004f670b
    # block 0x004f670d: entered by fall-through of je at 0x004f670b, 3 instruction(s), ends with je to 0x004f6742 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f670d
    test eax, eax                                # 004f6714
    je.d8 L_004f6742                             # 004f6716
    # block 0x004f6718: entered by fall-through of je at 0x004f6716, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f6742
    mov ecx, dword ptr [ebp - local_4]           # 004f6718
    add ecx, 0x4                                 # 004f671b
    push ecx                                     # 004f671e
    mov edx, dword ptr [ebp + arg_8]             # 004f671f
    push edx                                     # 004f6722
    push 0x55e858                                # 004f6723
    push 0x63888b                                # 004f6728
    call FUN_0050ca3e                            # 004f672d
    add esp, 0x10                                # 004f6732
    push 0x63888b                                # 004f6735
    call FUN_0044a2b7                            # 004f673a
    add esp, 0x4                                 # 004f673f
L_004f6742:
    # block 0x004f6742: entered by je at 0x004f6716, 2 instruction(s), ends with forward jump to 0x004f67b8
    mov eax, 0x1                                 # 004f6742
    jmp.d8 L_004f67b8                            # 004f6747
L_004f6749:
    # block 0x004f6749: entered by je at 0x004f670b, 6 instruction(s), calls FUN_004f6059, ends with je to 0x004f6795 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004f6749
    push eax                                     # 004f674c
    mov ecx, dword ptr [ebp - local_8]           # 004f674d
    call FUN_004f6059                            # 004f6750
    test eax, eax                                # 004f6755
    je.d8 L_004f6795                             # 004f6757
    # block 0x004f6759: entered by fall-through of je at 0x004f6757, 3 instruction(s), ends with je to 0x004f678e (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f6759
    test ecx, ecx                                # 004f6760
    je.d8 L_004f678e                             # 004f6762
    # block 0x004f6764: entered by fall-through of je at 0x004f6762, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f678e
    mov edx, dword ptr [ebp - local_4]           # 004f6764
    add edx, 0x4                                 # 004f6767
    push edx                                     # 004f676a
    mov eax, dword ptr [ebp + arg_8]             # 004f676b
    push eax                                     # 004f676e
    push 0x55e89c                                # 004f676f
    push 0x63888b                                # 004f6774
    call FUN_0050ca3e                            # 004f6779
    add esp, 0x10                                # 004f677e
    push 0x63888b                                # 004f6781
    call FUN_0044a2b7                            # 004f6786
    add esp, 0x4                                 # 004f678b
L_004f678e:
    # block 0x004f678e: entered by je at 0x004f6762, 2 instruction(s), ends with forward jump to 0x004f67b8
    mov eax, 0x1                                 # 004f678e
    jmp.d8 L_004f67b8                            # 004f6793
L_004f6795:
    # block 0x004f6795: entered by je at 0x004f66cf; jne at 0x004f66e1; je at 0x004f6757, 6 instruction(s), falls into the block at 0x004f67b8
    mov ecx, dword ptr [ebp - local_8]           # 004f6795
    mov dword ptr [ecx + field_3c2], 0x40d       # 004f6798
    mov edx, dword ptr [ebp - local_8]           # 004f67a2
    mov dword ptr [edx + field_3be], 0x0         # 004f67a5
    mov eax, dword ptr [ebp - local_8]           # 004f67af
    mov eax, dword ptr [eax + field_3be]         # 004f67b2
L_004f67b8:
    # block 0x004f67b8: entered by jmp at 0x004f6669; jmp at 0x004f66c0; jmp at 0x004f6747; jmp at 0x004f6793, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f67b8
    pop ebp                                      # 004f67ba
    ret 0x8                                      # 004f67bb

