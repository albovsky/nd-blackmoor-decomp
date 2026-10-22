# FUN_00437cff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00437cff
# extent:       0x00437cff-0x00437dcd (206 code bytes)
# span:         0x00437cff-0x00437dcd (code 206, tables 0, padding 0)
# sha256:       18708aba6de15320fa48a35228144a177aa592c6789361bf4a2c3eaac57039fa
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00437cff
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_b, field_e, field_1e, field_1f; [ecx + n] field_b, field_c, field_d, field_20; [edx + n] field_c, field_d, field_e, field_1d
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 78 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_b, 0xb  # offset +0xb
.equ field_c, 0xc  # offset +0xc
.equ field_d, 0xd  # offset +0xd
.equ field_e, 0xe  # offset +0xe
.equ field_1d, 0x1d  # offset +0x1d
.equ field_1e, 0x1e  # offset +0x1e
.equ field_1f, 0x1f  # offset +0x1f
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------

.org 0x00437cff - 0x401000
.globl FUN_00437cff
FUN_00437cff:
    # block 0x00437cff: entry, 7 instruction(s), ends with jne to 0x00437d39 (forward)
    push ebp                                     # 00437cff
    {load} mov ebp, esp                          # 00437d00
    push ecx                                     # 00437d02
    mov dword ptr [ebp - local_4], ecx           # 00437d03
    mov eax, dword ptr [ebp + arg_8]             # 00437d06
    cmp dword ptr [eax], 0x25                    # 00437d09
    jne.d8 L_00437d39                            # 00437d0c
    # block 0x00437d0e: entered by fall-through of jne at 0x00437d0c, 5 instruction(s), ends with jne to 0x00437d26 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00437d0e
    {load} xor edx, edx                          # 00437d11
    mov dl, byte ptr [ecx + field_d]             # 00437d13
    test edx, edx                                # 00437d16
    jne.d8 L_00437d26                            # 00437d18
    # block 0x00437d1a: entered by fall-through of jne at 0x00437d18, 5 instruction(s), ends with je to 0x00437d39 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00437d1a
    {load} xor ecx, ecx                          # 00437d1d
    mov cl, byte ptr [eax + field_1f]            # 00437d1f
    test ecx, ecx                                # 00437d22
    je.d8 L_00437d39                             # 00437d24
L_00437d26:
    # block 0x00437d26: entered by jne at 0x00437d18; fall-through of je at 0x00437d24, 5 instruction(s), ends with forward jump to 0x00437dc7
    mov edx, dword ptr [ebp - local_4]           # 00437d26
    mov byte ptr [edx + field_d], 0x0            # 00437d29
    mov eax, dword ptr [ebp - local_4]           # 00437d2d
    mov byte ptr [eax + field_1f], 0x0           # 00437d30
    jmp.d32 L_00437dc7                           # 00437d34
L_00437d39:
    # block 0x00437d39: entered by jne at 0x00437d0c; je at 0x00437d24, 3 instruction(s), ends with jne to 0x00437d69 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00437d39
    cmp dword ptr [ecx], 0x27                    # 00437d3c
    jne.d8 L_00437d69                            # 00437d3f
    # block 0x00437d41: entered by fall-through of jne at 0x00437d3f, 5 instruction(s), ends with jne to 0x00437d59 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00437d41
    {load} xor eax, eax                          # 00437d44
    mov al, byte ptr [edx + field_e]             # 00437d46
    test eax, eax                                # 00437d49
    jne.d8 L_00437d59                            # 00437d4b
    # block 0x00437d4d: entered by fall-through of jne at 0x00437d4b, 5 instruction(s), ends with je to 0x00437d69 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00437d4d
    {load} xor edx, edx                          # 00437d50
    mov dl, byte ptr [ecx + field_20]            # 00437d52
    test edx, edx                                # 00437d55
    je.d8 L_00437d69                             # 00437d57
L_00437d59:
    # block 0x00437d59: entered by jne at 0x00437d4b; fall-through of je at 0x00437d57, 5 instruction(s), ends with forward jump to 0x00437dc7
    mov eax, dword ptr [ebp - local_4]           # 00437d59
    mov byte ptr [eax + field_e], 0x0            # 00437d5c
    mov ecx, dword ptr [ebp - local_4]           # 00437d60
    mov byte ptr [ecx + field_20], 0x0           # 00437d63
    jmp.d8 L_00437dc7                            # 00437d67
L_00437d69:
    # block 0x00437d69: entered by jne at 0x00437d3f; je at 0x00437d57, 3 instruction(s), ends with jne to 0x00437d99 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00437d69
    cmp dword ptr [edx], 0x26                    # 00437d6c
    jne.d8 L_00437d99                            # 00437d6f
    # block 0x00437d71: entered by fall-through of jne at 0x00437d6f, 5 instruction(s), ends with jne to 0x00437d89 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00437d71
    {load} xor ecx, ecx                          # 00437d74
    mov cl, byte ptr [eax + field_b]             # 00437d76
    test ecx, ecx                                # 00437d79
    jne.d8 L_00437d89                            # 00437d7b
    # block 0x00437d7d: entered by fall-through of jne at 0x00437d7b, 5 instruction(s), ends with je to 0x00437d99 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00437d7d
    {load} xor eax, eax                          # 00437d80
    mov al, byte ptr [edx + field_1d]            # 00437d82
    test eax, eax                                # 00437d85
    je.d8 L_00437d99                             # 00437d87
L_00437d89:
    # block 0x00437d89: entered by jne at 0x00437d7b; fall-through of je at 0x00437d87, 5 instruction(s), ends with forward jump to 0x00437dc7
    mov ecx, dword ptr [ebp - local_4]           # 00437d89
    mov byte ptr [ecx + field_b], 0x0            # 00437d8c
    mov edx, dword ptr [ebp - local_4]           # 00437d90
    mov byte ptr [edx + field_1d], 0x0           # 00437d93
    jmp.d8 L_00437dc7                            # 00437d97
L_00437d99:
    # block 0x00437d99: entered by jne at 0x00437d6f; je at 0x00437d87, 3 instruction(s), ends with jne to 0x00437dc7 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00437d99
    cmp dword ptr [eax], 0x28                    # 00437d9c
    jne.d8 L_00437dc7                            # 00437d9f
    # block 0x00437da1: entered by fall-through of jne at 0x00437d9f, 5 instruction(s), ends with jne to 0x00437db9 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00437da1
    {load} xor edx, edx                          # 00437da4
    mov dl, byte ptr [ecx + field_c]             # 00437da6
    test edx, edx                                # 00437da9
    jne.d8 L_00437db9                            # 00437dab
    # block 0x00437dad: entered by fall-through of jne at 0x00437dab, 5 instruction(s), ends with je to 0x00437dc7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00437dad
    {load} xor ecx, ecx                          # 00437db0
    mov cl, byte ptr [eax + field_1e]            # 00437db2
    test ecx, ecx                                # 00437db5
    je.d8 L_00437dc7                             # 00437db7
L_00437db9:
    # block 0x00437db9: entered by jne at 0x00437dab; fall-through of je at 0x00437db7, 4 instruction(s), falls into the block at 0x00437dc7
    mov edx, dword ptr [ebp - local_4]           # 00437db9
    mov byte ptr [edx + field_c], 0x0            # 00437dbc
    mov eax, dword ptr [ebp - local_4]           # 00437dc0
    mov byte ptr [eax + field_1e], 0x0           # 00437dc3
L_00437dc7:
    # block 0x00437dc7: entered by jmp at 0x00437d34; jmp at 0x00437d67; jmp at 0x00437d97; jne at 0x00437d9f; more, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 00437dc7
    pop ebp                                      # 00437dc9
    ret 0xc                                      # 00437dca

