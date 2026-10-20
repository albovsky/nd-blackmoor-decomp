# FUN_004f8bdc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f8bdc
# extent:       0x004f8bdc-0x004f8ce2 (262 code bytes)
# span:         0x004f8bdc-0x004f8ce2 (code 262, tables 0, padding 0)
# sha256:       c32e11a3a46d98bc2107ff4fea32383abf7cf4fdeaec474952ab6e868e51be71
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_sound_set_3d_sound_mode
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4f8bdc.c.txt, not original source) refers to the data labelled s_CDirectSound__Set3DSoundMode_____0055f070, s_DS3DMODE_HEADRELATIVE_0055f044, s_DS3DMODE_NORMAL_0055f034
# name-note:    Stores and applies a channel 3D mode; logs CDirectSound::Set3DSoundMode with DS3DMODE_NORMAL, HEADRELATIVE or DISABLE.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_48, field_29b, field_3ca, field_3d2; [ecx + n] field_29b, field_2db, field_3ca, field_3ce; [edx + n] field_3ca
# callees:      calls FUN_0050ca3e, FUN_0044a2b7; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 72 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_48, 0x48  # offset +0x48
.equ field_29b, 0x29b  # offset +0x29b
.equ field_2db, 0x2db  # offset +0x2db
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_3d2, 0x3d2  # offset +0x3d2

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f8bdc - 0x401000
.globl FUN_004f8bdc
FUN_004f8bdc:
    # block 0x004f8bdc: entry, 15 instruction(s), ends with je to 0x004f8cda (forward)
    push ebp                                     # 004f8bdc
    {load} mov ebp, esp                          # 004f8bdd
    sub esp, 0xc                                 # 004f8bdf
    mov dword ptr [ebp - local_c], ecx           # 004f8be2
    mov eax, dword ptr [ebp + arg_8]             # 004f8be5
    imul eax, eax, 0x5bb                         # 004f8be8
    mov ecx, dword ptr [ebp - local_c]           # 004f8bee
    mov edx, dword ptr [ecx + field_3ce]         # 004f8bf1
    {load} add edx, eax                          # 004f8bf7
    mov dword ptr [ebp - local_4], edx           # 004f8bf9
    mov eax, dword ptr [ebp - local_c]           # 004f8bfc
    mov dword ptr [eax + field_3ca], 0x0         # 004f8bff
    mov ecx, dword ptr [ebp - local_4]           # 004f8c09
    cmp dword ptr [ecx + field_29b], 0x0         # 004f8c0c
    je.d32 L_004f8cda                            # 004f8c13
    # block 0x004f8c19: entered by fall-through of je at 0x004f8c13, 3 instruction(s), ends with je to 0x004f8c2c (forward)
    {load} xor edx, edx                          # 004f8c19
    test edx, edx                                # 004f8c1b
    je.d8 L_004f8c2c                             # 004f8c1d
    # block 0x004f8c1f: entered by fall-through of je at 0x004f8c1d, 2 instruction(s), falls into the block at 0x004f8c2c
    mov eax, dword ptr [ebp - local_c]           # 004f8c1f
    mov dword ptr [eax + field_3d2], 0x1         # 004f8c22
L_004f8c2c:
    # block 0x004f8c2c: entered by je at 0x004f8c1d, 18 instruction(s), calls indirect dword ptr [eax + 0x48], ends with jne to 0x004f8cd6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f8c2c
    mov edx, dword ptr [ebp + arg_c]             # 004f8c2f
    mov dword ptr [ecx + field_2db], edx         # 004f8c32
    push 0x0                                     # 004f8c38
    mov eax, dword ptr [ebp + arg_c]             # 004f8c3a
    push eax                                     # 004f8c3d
    mov ecx, dword ptr [ebp - local_4]           # 004f8c3e
    mov edx, dword ptr [ecx + field_29b]         # 004f8c41
    mov eax, dword ptr [ebp - local_4]           # 004f8c47
    mov ecx, dword ptr [eax + field_29b]         # 004f8c4a
    mov eax, dword ptr [ecx]                     # 004f8c50
    push edx                                     # 004f8c52
    call dword ptr [eax + field_48]              # 004f8c53
    mov ecx, dword ptr [ebp - local_c]           # 004f8c56
    mov dword ptr [ecx + field_3ca], eax         # 004f8c59
    mov edx, dword ptr [ebp - local_c]           # 004f8c5f
    cmp dword ptr [edx + field_3ca], 0x0         # 004f8c62
    jne.d8 L_004f8cd6                            # 004f8c69
    # block 0x004f8c6b: entered by fall-through of jne at 0x004f8c69, 3 instruction(s), ends with je to 0x004f8ccf (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f8c6b
    test eax, eax                                # 004f8c72
    je.d8 L_004f8ccf                             # 004f8c74
    # block 0x004f8c76: entered by fall-through of je at 0x004f8c74, 3 instruction(s), ends with jne to 0x004f8c8c (forward)
    mov dword ptr [ebp - local_8], 0x0           # 004f8c76
    cmp dword ptr [ebp + arg_c], 0x0             # 004f8c7d
    jne.d8 L_004f8c8c                            # 004f8c81
    # block 0x004f8c83: entered by fall-through of jne at 0x004f8c81, 2 instruction(s), ends with forward jump to 0x004f8ca8
    mov dword ptr [ebp - local_8], 0x55f034      # 004f8c83
    jmp.d8 L_004f8ca8                            # 004f8c8a
L_004f8c8c:
    # block 0x004f8c8c: entered by jne at 0x004f8c81, 2 instruction(s), ends with jne to 0x004f8c9b (forward)
    cmp dword ptr [ebp + arg_c], 0x1             # 004f8c8c
    jne.d8 L_004f8c9b                            # 004f8c90
    # block 0x004f8c92: entered by fall-through of jne at 0x004f8c90, 2 instruction(s), ends with forward jump to 0x004f8ca8
    mov dword ptr [ebp - local_8], 0x55f044      # 004f8c92
    jmp.d8 L_004f8ca8                            # 004f8c99
L_004f8c9b:
    # block 0x004f8c9b: entered by jne at 0x004f8c90, 2 instruction(s), ends with jne to 0x004f8ca8 (forward)
    cmp dword ptr [ebp + arg_c], 0x2             # 004f8c9b
    jne.d8 L_004f8ca8                            # 004f8c9f
    # block 0x004f8ca1: entered by fall-through of jne at 0x004f8c9f, 1 instruction(s), falls into the block at 0x004f8ca8
    mov dword ptr [ebp - local_8], 0x55f05c      # 004f8ca1
L_004f8ca8:
    # block 0x004f8ca8: entered by jmp at 0x004f8c8a; jmp at 0x004f8c99; jne at 0x004f8c9f, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f8ccf
    mov ecx, dword ptr [ebp - local_8]           # 004f8ca8
    push ecx                                     # 004f8cab
    mov edx, dword ptr [ebp + arg_8]             # 004f8cac
    push edx                                     # 004f8caf
    push 0x55f070                                # 004f8cb0
    push 0x63888b                                # 004f8cb5
    call FUN_0050ca3e                            # 004f8cba
    add esp, 0x10                                # 004f8cbf
    push 0x63888b                                # 004f8cc2
    call FUN_0044a2b7                            # 004f8cc7
    add esp, 0x4                                 # 004f8ccc
L_004f8ccf:
    # block 0x004f8ccf: entered by je at 0x004f8c74, 2 instruction(s), ends with forward jump to 0x004f8cdc
    mov eax, 0x1                                 # 004f8ccf
    jmp.d8 L_004f8cdc                            # 004f8cd4
L_004f8cd6:
    # block 0x004f8cd6: entered by jne at 0x004f8c69, 2 instruction(s), ends with forward jump to 0x004f8cdc
    {load} xor eax, eax                          # 004f8cd6
    jmp.d8 L_004f8cdc                            # 004f8cd8
L_004f8cda:
    # block 0x004f8cda: entered by je at 0x004f8c13, 1 instruction(s), falls into the block at 0x004f8cdc
    {load} xor eax, eax                          # 004f8cda
L_004f8cdc:
    # block 0x004f8cdc: entered by jmp at 0x004f8cd4; jmp at 0x004f8cd8, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f8cdc
    pop ebp                                      # 004f8cde
    ret 0x8                                      # 004f8cdf

