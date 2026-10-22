# FUN_004959ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004959ea
# extent:       0x004959ea-0x00495a5b (113 code bytes)
# span:         0x004959ea-0x00495a5b (code 113, tables 0, padding 0)
# sha256:       9e08af707aa73faed3463253cee2175ad2d465d3662ea1c23c30cf1141ee03eb
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004959ea
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_c; [ecx + n] field_45c1, field_4765
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_45c1, 0x45c1  # offset +0x45c1
.equ field_4765, 0x4765  # offset +0x4765

# --- external targets -----------------------------------------------

.org 0x004959ea - 0x401000
.globl FUN_004959ea
FUN_004959ea:
    # block 0x004959ea: entry, 6 instruction(s), ends with forward jump to 0x00495a05
    push ebp                                     # 004959ea
    {load} mov ebp, esp                          # 004959eb
    sub esp, 0xc                                 # 004959ed
    mov dword ptr [ebp - local_c], ecx           # 004959f0
    mov dword ptr [ebp - local_4], 0x0           # 004959f3
    jmp.d8 L_00495a05                            # 004959fa
L_004959fc:
    # block 0x004959fc: entered by jmp at 0x00495a51, 3 instruction(s), falls into the block at 0x00495a05
    mov eax, dword ptr [ebp - local_4]           # 004959fc
    add eax, 0x1                                 # 004959ff
    mov dword ptr [ebp - local_4], eax           # 00495a02
L_00495a05:
    # block 0x00495a05: entered by jmp at 0x004959fa, 4 instruction(s), ends with jge to 0x00495a53 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00495a05
    mov edx, dword ptr [ebp - local_4]           # 00495a08
    cmp edx, dword ptr [ecx + field_4765]        # 00495a0b
    jge.d8 L_00495a53                            # 00495a11
    # block 0x00495a13: entered by fall-through of jge at 0x00495a11, 9 instruction(s), ends with jne to 0x00495a51 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00495a13
    imul eax, eax, 0x1c                          # 00495a16
    mov ecx, dword ptr [ebp - local_c]           # 00495a19
    lea edx, [ecx + eax + field_45c1]            # 00495a1c
    mov dword ptr [ebp - local_8], edx           # 00495a23
    mov eax, dword ptr [ebp - local_8]           # 00495a26
    mov ecx, dword ptr [eax + field_4]           # 00495a29
    cmp ecx, dword ptr [ebp + arg_8]             # 00495a2c
    jne.d8 L_00495a51                            # 00495a2f
    # block 0x00495a31: entered by fall-through of jne at 0x00495a2f, 3 instruction(s), ends with jne to 0x00495a3d (forward)
    mov edx, dword ptr [ebp - local_8]           # 00495a31
    cmp dword ptr [edx], 0x0                     # 00495a34
    jne.d8 L_00495a3d                            # 00495a37
    # block 0x00495a39: entered by fall-through of jne at 0x00495a37, 2 instruction(s), ends with forward jump to 0x00495a55
    {load} xor eax, eax                          # 00495a39
    jmp.d8 L_00495a55                            # 00495a3b
L_00495a3d:
    # block 0x00495a3d: entered by jne at 0x00495a37, 3 instruction(s), ends with je to 0x00495a4d (forward)
    mov eax, dword ptr [ebp - local_8]           # 00495a3d
    cmp dword ptr [eax + field_c], 0x0           # 00495a40
    je.d8 L_00495a4d                             # 00495a44
    # block 0x00495a46: entered by fall-through of je at 0x00495a44, 2 instruction(s), ends with forward jump to 0x00495a55
    mov eax, 0x1                                 # 00495a46
    jmp.d8 L_00495a55                            # 00495a4b
L_00495a4d:
    # block 0x00495a4d: entered by je at 0x00495a44, 2 instruction(s), ends with forward jump to 0x00495a55
    {load} xor eax, eax                          # 00495a4d
    jmp.d8 L_00495a55                            # 00495a4f
L_00495a51:
    # block 0x00495a51: entered by jne at 0x00495a2f, 1 instruction(s), ends with backward jump to 0x004959fc
    jmp.d8 L_004959fc                            # 00495a51
L_00495a53:
    # block 0x00495a53: entered by jge at 0x00495a11, 1 instruction(s), falls into the block at 0x00495a55
    {load} xor eax, eax                          # 00495a53
L_00495a55:
    # block 0x00495a55: entered by jmp at 0x00495a3b; jmp at 0x00495a4b; jmp at 0x00495a4f, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00495a55
    pop ebp                                      # 00495a57
    ret 0x4                                      # 00495a58

