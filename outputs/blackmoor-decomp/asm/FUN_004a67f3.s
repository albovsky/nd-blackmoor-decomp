# FUN_004a67f3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a67f3
# extent:       0x004a67f3-0x004a6946 (339 code bytes)
# span:         0x004a67f3-0x004a6946 (code 339, tables 0, padding 0)
# sha256:       bd1d95bbef76b1f9f0414f699ccc23e25680297db07f550db0fc71f1910c05b0
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a67f3
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_25, field_2ce; [edx + n] field_21, field_2ce
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 72 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_2ce, 0x2ce  # offset +0x2ce

# --- external targets -----------------------------------------------

.org 0x004a67f3 - 0x401000
.globl FUN_004a67f3
FUN_004a67f3:
    # block 0x004a67f3: entry, 12 instruction(s), ends with jne to 0x004a6874 (forward)
    push ebp                                     # 004a67f3
    {load} mov ebp, esp                          # 004a67f4
    sub esp, 0xc                                 # 004a67f6
    mov dword ptr [ebp - local_8], ecx           # 004a67f9
    mov eax, dword ptr [ebp - local_8]           # 004a67fc
    movsx ecx, word ptr [eax + field_1e]         # 004a67ff
    imul ecx, ecx, 0x8d                          # 004a6803
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004a6809
    mov dword ptr [ebp - local_4], edx           # 004a680f
    movsx eax, word ptr [ebp + arg_8]            # 004a6812
    cmp eax, 0x2770                              # 004a6816
    jne.d8 L_004a6874                            # 004a681b
    # block 0x004a681d: entered by fall-through of jne at 0x004a681b, 13 instruction(s), ends with forward jump to 0x004a6940
    mov ecx, dword ptr [0x5d0377]                # 004a681d
    mov dword ptr [0x5d162d], ecx                # 004a6823
    mov dword ptr [0x5b44f0], 0x9                # 004a6829
    mov dword ptr [0x5b44f4], 0x1                # 004a6833
    mov edx, dword ptr [0x5b44f0]                # 004a683d
    shl edx, 0x5                                 # 004a6843
    mov eax, dword ptr [0x5b44f4]                # 004a6846
    shl eax, 0x4                                 # 004a684b
    lea ecx, [edx + eax + 0x5b160c]              # 004a684e
    mov dword ptr [0x5d1631], ecx                # 004a6855
    mov dword ptr [0x5d1639], 0x1                # 004a685b
    mov dword ptr [0x5c39e5], 0x2770             # 004a6865
    jmp.d32 L_004a6940                           # 004a686f
L_004a6874:
    # block 0x004a6874: entered by jne at 0x004a681b, 4 instruction(s), ends with je to 0x004a6898 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004a6874
    mov dword ptr [ebp - local_c], edx           # 004a6878
    cmp dword ptr [ebp - local_c], 0x276f        # 004a687b
    je.d8 L_004a6898                             # 004a6882
    # block 0x004a6884: entered by fall-through of je at 0x004a6882, 2 instruction(s), ends with je to 0x004a68a4 (forward)
    cmp dword ptr [ebp - local_c], 0x2771        # 004a6884
    je.d8 L_004a68a4                             # 004a688b
    # block 0x004a688d: entered by fall-through of je at 0x004a688b, 2 instruction(s), ends with je to 0x004a68cb (forward)
    cmp dword ptr [ebp - local_c], 0x2772        # 004a688d
    je.d8 L_004a68cb                             # 004a6894
    # block 0x004a6896: entered by fall-through of je at 0x004a6894, 1 instruction(s), ends with forward jump to 0x004a68f0
    jmp.d8 L_004a68f0                            # 004a6896
L_004a6898:
    # block 0x004a6898: entered by je at 0x004a6882, 2 instruction(s), ends with forward jump to 0x004a68f0
    mov dword ptr [0x5b44f0], 0x16               # 004a6898
    jmp.d8 L_004a68f0                            # 004a68a2
L_004a68a4:
    # block 0x004a68a4: entered by je at 0x004a688b, 5 instruction(s), ends with je to 0x004a68bf (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a68a4
    {load} xor ecx, ecx                          # 004a68a7
    mov cl, byte ptr [eax + field_2ce]           # 004a68a9
    test ecx, ecx                                # 004a68af
    je.d8 L_004a68bf                             # 004a68b1
    # block 0x004a68b3: entered by fall-through of je at 0x004a68b1, 2 instruction(s), ends with forward jump to 0x004a68c9
    mov dword ptr [0x5b44f0], 0x19               # 004a68b3
    jmp.d8 L_004a68c9                            # 004a68bd
L_004a68bf:
    # block 0x004a68bf: entered by je at 0x004a68b1, 1 instruction(s), falls into the block at 0x004a68c9
    mov dword ptr [0x5b44f0], 0x14               # 004a68bf
L_004a68c9:
    # block 0x004a68c9: entered by jmp at 0x004a68bd, 1 instruction(s), ends with forward jump to 0x004a68f0
    jmp.d8 L_004a68f0                            # 004a68c9
L_004a68cb:
    # block 0x004a68cb: entered by je at 0x004a6894, 5 instruction(s), ends with je to 0x004a68e6 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a68cb
    {load} xor eax, eax                          # 004a68ce
    mov al, byte ptr [edx + field_2ce]           # 004a68d0
    test eax, eax                                # 004a68d6
    je.d8 L_004a68e6                             # 004a68d8
    # block 0x004a68da: entered by fall-through of je at 0x004a68d8, 2 instruction(s), ends with forward jump to 0x004a68f0
    mov dword ptr [0x5b44f0], 0x1a               # 004a68da
    jmp.d8 L_004a68f0                            # 004a68e4
L_004a68e6:
    # block 0x004a68e6: entered by je at 0x004a68d8, 1 instruction(s), falls into the block at 0x004a68f0
    mov dword ptr [0x5b44f0], 0x15               # 004a68e6
L_004a68f0:
    # block 0x004a68f0: entered by jmp at 0x004a6896; jmp at 0x004a68a2; jmp at 0x004a68c9; jmp at 0x004a68e4, 13 instruction(s), ends with jne to 0x004a6940 (forward)
    mov ecx, dword ptr [0x5d0377]                # 004a68f0
    mov dword ptr [0x5d162d], ecx                # 004a68f6
    mov edx, dword ptr [0x5b44f0]                # 004a68fc
    shl edx, 0x5                                 # 004a6902
    mov eax, dword ptr [0x5b44f4]                # 004a6905
    shl eax, 0x4                                 # 004a690a
    lea ecx, [edx + eax + 0x5b160c]              # 004a690d
    mov dword ptr [0x5d1631], ecx                # 004a6914
    mov dword ptr [0x5d1639], 0x1                # 004a691a
    mov dword ptr [0x5c39e5], 0x276f             # 004a6924
    mov edx, dword ptr [ebp - local_8]           # 004a692e
    cmp dword ptr [edx + field_21], 0x0          # 004a6931
    jne.d8 L_004a6940                            # 004a6935
    # block 0x004a6937: entered by fall-through of jne at 0x004a6935, 3 instruction(s), falls into the block at 0x004a6940
    mov eax, dword ptr [ebp - local_8]           # 004a6937
    mov ecx, dword ptr [ebp + arg_c]             # 004a693a
    mov dword ptr [eax + field_25], ecx          # 004a693d
L_004a6940:
    # block 0x004a6940: entered by jmp at 0x004a686f; jne at 0x004a6935, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004a6940
    pop ebp                                      # 004a6942
    ret 0x8                                      # 004a6943

