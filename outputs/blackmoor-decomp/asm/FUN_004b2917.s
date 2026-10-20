# FUN_004b2917
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b2917
# extent:       0x004b2917-0x004b2a8e (375 code bytes)
# span:         0x004b2917-0x004b2a9e (code 375, tables 16, padding 0)
# sha256:       39098b04035d651f6877a8c82050b884e34e083b96592744226dff8e45eaa398
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b2917
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_1531
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 70 instruction(s), 3 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_1531, 0x1531  # offset +0x1531

# --- external targets -----------------------------------------------

.org 0x004b2917 - 0x401000
.globl FUN_004b2917
FUN_004b2917:
    # block 0x004b2917: entry, 7 instruction(s), ends with jne to 0x004b2982 (forward)
    push ebp                                     # 004b2917
    {load} mov ebp, esp                          # 004b2918
    sub esp, 0x8                                 # 004b291a
    mov dword ptr [ebp - local_4], ecx           # 004b291d
    movsx eax, word ptr [ebp + arg_8]            # 004b2920
    cmp eax, 0x2793                              # 004b2924
    jne.d8 L_004b2982                            # 004b2929
    # block 0x004b292b: entered by fall-through of jne at 0x004b2929, 13 instruction(s), ends with forward jump to 0x004b2a88
    mov ecx, dword ptr [0x5d0377]                # 004b292b
    mov dword ptr [0x5d162d], ecx                # 004b2931
    mov dword ptr [0x5b44f0], 0x9                # 004b2937
    mov dword ptr [0x5b44f4], 0x1                # 004b2941
    mov edx, dword ptr [0x5b44f0]                # 004b294b
    shl edx, 0x5                                 # 004b2951
    mov eax, dword ptr [0x5b44f4]                # 004b2954
    shl eax, 0x4                                 # 004b2959
    lea ecx, [edx + eax + 0x5b160c]              # 004b295c
    mov dword ptr [0x5d1631], ecx                # 004b2963
    mov dword ptr [0x5d1639], 0x1                # 004b2969
    mov dword ptr [0x5c39e5], 0x2793             # 004b2973
    jmp.d32 L_004b2a88                           # 004b297d
L_004b2982:
    # block 0x004b2982: entered by jne at 0x004b2929, 3 instruction(s), ends with jne to 0x004b29e3 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004b2982
    cmp edx, 0x2792                              # 004b2986
    jne.d8 L_004b29e3                            # 004b298c
    # block 0x004b298e: entered by fall-through of jne at 0x004b298c, 13 instruction(s), ends with forward jump to 0x004b2a88
    mov eax, dword ptr [0x5d0377]                # 004b298e
    mov dword ptr [0x5d162d], eax                # 004b2993
    mov dword ptr [0x5b44f0], 0x16               # 004b2998
    mov dword ptr [0x5b44f4], 0x1                # 004b29a2
    mov ecx, dword ptr [0x5b44f0]                # 004b29ac
    shl ecx, 0x5                                 # 004b29b2
    mov edx, dword ptr [0x5b44f4]                # 004b29b5
    shl edx, 0x4                                 # 004b29bb
    lea eax, [ecx + edx + 0x5b160c]              # 004b29be
    mov dword ptr [0x5d1631], eax                # 004b29c5
    mov dword ptr [0x5d1639], 0x1                # 004b29ca
    mov dword ptr [0x5c39e5], 0x2792             # 004b29d4
    jmp.d32 L_004b2a88                           # 004b29de
L_004b29e3:
    # block 0x004b29e3: entered by jne at 0x004b298c, 10 instruction(s), ends with ja to 0x004b2a42 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b29e3
    mov dx, word ptr [ebp + arg_8]               # 004b29e6
    mov word ptr [ecx + field_1531], dx          # 004b29ea
    movsx eax, word ptr [ebp + arg_8]            # 004b29f1
    mov dword ptr [ebp - local_8], eax           # 004b29f5
    mov ecx, dword ptr [ebp - local_8]           # 004b29f8
    sub ecx, 0x2794                              # 004b29fb
    mov dword ptr [ebp - local_8], ecx           # 004b2a01
    cmp dword ptr [ebp - local_8], 0x3           # 004b2a04
    ja.d8 L_004b2a42                             # 004b2a08
    # block 0x004b2a0a: entered by fall-through of ja at 0x004b2a08, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4b2a8e]
    mov edx, dword ptr [ebp - local_8]           # 004b2a0a
    jmp dword ptr [4*edx + SWTAB_004b2a8e_VA]    # 004b2a0d
L_004b2a14:
    # block 0x004b2a14: entered by switch case, 2 instruction(s), ends with forward jump to 0x004b2a42
    mov dword ptr [0x5b44f0], 0x19               # 004b2a14
    jmp.d8 L_004b2a42                            # 004b2a1e
L_004b2a20:
    # block 0x004b2a20: entered by switch case, 2 instruction(s), ends with forward jump to 0x004b2a42
    mov dword ptr [0x5b44f0], 0x17               # 004b2a20
    jmp.d8 L_004b2a42                            # 004b2a2a
L_004b2a2c:
    # block 0x004b2a2c: entered by switch case, 2 instruction(s), ends with forward jump to 0x004b2a42
    mov dword ptr [0x5b44f0], 0x18               # 004b2a2c
    jmp.d8 L_004b2a42                            # 004b2a36
L_004b2a38:
    # block 0x004b2a38: entered by switch case, 1 instruction(s), falls into the block at 0x004b2a42
    mov dword ptr [0x5b44f0], 0x1a               # 004b2a38
L_004b2a42:
    # block 0x004b2a42: entered by ja at 0x004b2a08; jmp at 0x004b2a1e; jmp at 0x004b2a2a; jmp at 0x004b2a36, 12 instruction(s), falls into the block at 0x004b2a88
    mov dword ptr [0x5b44f4], 0x1                # 004b2a42
    mov eax, dword ptr [0x5d0377]                # 004b2a4c
    mov dword ptr [0x5d162d], eax                # 004b2a51
    mov ecx, dword ptr [0x5b44f0]                # 004b2a56
    shl ecx, 0x5                                 # 004b2a5c
    mov edx, dword ptr [0x5b44f4]                # 004b2a5f
    shl edx, 0x4                                 # 004b2a65
    lea eax, [ecx + edx + 0x5b160c]              # 004b2a68
    mov dword ptr [0x5d1631], eax                # 004b2a6f
    mov dword ptr [0x5d1639], 0x1                # 004b2a74
    movsx ecx, word ptr [ebp + arg_8]            # 004b2a7e
    mov dword ptr [0x5c39e5], ecx                # 004b2a82
L_004b2a88:
    # block 0x004b2a88: entered by jmp at 0x004b297d; jmp at 0x004b29de, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004b2a88
    pop ebp                                      # 004b2a8a
    ret 0x4                                      # 004b2a8b

# --- data items (not part of the function) -------------------------
.org 0x004b2a8e - 0x401000
SWTAB_004b2a8e:  # 4 case address(es)
    .long L_004b2a14 - .text + 0x401000
    .long L_004b2a20 - .text + 0x401000
    .long L_004b2a2c - .text + 0x401000
    .long L_004b2a38 - .text + 0x401000
.set SWTAB_004b2a8e_VA, SWTAB_004b2a8e - .text + 0x401000

