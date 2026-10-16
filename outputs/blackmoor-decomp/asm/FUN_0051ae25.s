# FUN_0051ae25
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ae25
# extent:       0x0051ae25-0x0051aea1 (124 code bytes)
# span:         0x0051ae25-0x0051aea1 (code 124, tables 0, padding 0)
# sha256:       1ab6ec818c1e360eae1f147ee8363842074b64792f45523a0971b0a8725a5e47
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ae25
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [edi + n] field_minus_132; [esi + n] field_4, field_8
# callees:      calls FUN_00525bd1, FUN_0051ca36, FUN_0051acc6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_132, 0x132  # offset -0x132
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051acc6, .text + (0x0051acc6 - 0x401000)
.set FUN_0051ca36, .text + (0x0051ca36 - 0x401000)
.set FUN_00525bd1, .text + (0x00525bd1 - 0x401000)

.org 0x0051ae25 - 0x401000
.globl FUN_0051ae25
FUN_0051ae25:
    # block 0x0051ae25: entry, 12 instruction(s), calls FUN_00525bd1, ends with je to 0x0051ae8c (forward)
    push ebp                                     # 0051ae25
    {load} mov ebp, esp                          # 0051ae26
    push esi                                     # 0051ae28
    push edi                                     # 0051ae29
    push 0x5249a0                                # 0051ae2a
    mov ecx, 0x63c41c                            # 0051ae2f
    call FUN_00525bd1                            # 0051ae34
    mov edi, dword ptr [ebp + arg_c]             # 0051ae39
    {load} mov esi, eax                          # 0051ae3c
    mov eax, dword ptr [esi + field_4]           # 0051ae3e
    test eax, eax                                # 0051ae41
    je.d8 L_0051ae8c                             # 0051ae43
    # block 0x0051ae45: entered by fall-through of je at 0x0051ae43, 2 instruction(s), ends with je to 0x0051ae6d (forward)
    cmp edi, 0x135                               # 0051ae45
    je.d8 L_0051ae6d                             # 0051ae4b
    # block 0x0051ae4d: entered by fall-through of je at 0x0051ae4b, 2 instruction(s), ends with je to 0x0051ae6d (forward)
    cmp edi, 0x136                               # 0051ae4d
    je.d8 L_0051ae6d                             # 0051ae53
    # block 0x0051ae55: entered by fall-through of je at 0x0051ae53, 2 instruction(s), ends with je to 0x0051ae6d (forward)
    cmp edi, 0x138                               # 0051ae55
    je.d8 L_0051ae6d                             # 0051ae5b
    # block 0x0051ae5d: entered by fall-through of je at 0x0051ae5b, 2 instruction(s), ends with je to 0x0051ae6d (forward)
    cmp edi, 0x137                               # 0051ae5d
    je.d8 L_0051ae6d                             # 0051ae63
    # block 0x0051ae65: entered by fall-through of je at 0x0051ae63, 2 instruction(s), ends with jne to 0x0051ae8c (forward)
    cmp edi, 0x134                               # 0051ae65
    jne.d8 L_0051ae8c                            # 0051ae6b
L_0051ae6d:
    # block 0x0051ae6d: entered by je at 0x0051ae4b; je at 0x0051ae53; je at 0x0051ae5b; je at 0x0051ae63; more, 9 instruction(s), calls FUN_0051ca36, ends with je to 0x0051ae8c (forward)
    push dword ptr [esi + field_8]               # 0051ae6d
    push eax                                     # 0051ae70
    lea eax, [edi - field_minus_132]             # 0051ae71
    push eax                                     # 0051ae77
    push dword ptr [ebp + arg_14]                # 0051ae78
    push dword ptr [ebp + arg_10]                # 0051ae7b
    call FUN_0051ca36                            # 0051ae7e
    test eax, eax                                # 0051ae83
    je.d8 L_0051ae8c                             # 0051ae85
    # block 0x0051ae87: entered by fall-through of je at 0x0051ae85, 2 instruction(s), ends with forward jump to 0x0051ae9b
    mov eax, dword ptr [esi + field_4]           # 0051ae87
    jmp.d8 L_0051ae9b                            # 0051ae8a
L_0051ae8c:
    # block 0x0051ae8c: entered by je at 0x0051ae43; jne at 0x0051ae6b; je at 0x0051ae85, 5 instruction(s), calls FUN_0051acc6, falls into the block at 0x0051ae9b
    push dword ptr [ebp + arg_14]                # 0051ae8c
    push dword ptr [ebp + arg_10]                # 0051ae8f
    push edi                                     # 0051ae92
    push dword ptr [ebp + arg_8]                 # 0051ae93
    call FUN_0051acc6                            # 0051ae96
L_0051ae9b:
    # block 0x0051ae9b: entered by jmp at 0x0051ae8a, 4 instruction(s), ends with ret 0x10
    pop edi                                      # 0051ae9b
    pop esi                                      # 0051ae9c
    pop ebp                                      # 0051ae9d
    ret 0x10                                     # 0051ae9e

