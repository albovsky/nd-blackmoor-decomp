# FUN_00487dcf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487dcf
# extent:       0x00487dcf-0x00487ed5 (262 code bytes)
# span:         0x00487dcf-0x00487ed5 (code 262, tables 0, padding 0)
# sha256:       de24c896e42503c22d6e02bf7370a56c08466b9697354849aac4b00dc852aacb
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00487dcf
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_24, field_66; [ecx + n] field_65; [edx + n] field_24, field_66
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 55 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_24, 0x24  # offset +0x24
.equ field_65, 0x65  # offset +0x65
.equ field_66, 0x66  # offset +0x66

# --- external targets -----------------------------------------------

.org 0x00487dcf - 0x401000
.globl FUN_00487dcf
FUN_00487dcf:
    # block 0x00487dcf: entry, 7 instruction(s), ends with jne to 0x00487e48 (forward)
    push ebp                                     # 00487dcf
    {load} mov ebp, esp                          # 00487dd0
    push ecx                                     # 00487dd2
    mov dword ptr [ebp - local_4], ecx           # 00487dd3
    movsx eax, word ptr [ebp + arg_8]            # 00487dd6
    cmp eax, 0x2789                              # 00487dda
    jne.d8 L_00487e48                            # 00487ddf
    # block 0x00487de1: entered by fall-through of jne at 0x00487ddf, 17 instruction(s), ends with forward jump to 0x00487ecf
    mov dword ptr [0x5b44f0], 0x9                # 00487de1
    mov dword ptr [0x5b44f4], 0x1                # 00487deb
    mov ecx, dword ptr [0x5d0377]                # 00487df5
    mov dword ptr [0x5d162d], ecx                # 00487dfb
    mov edx, dword ptr [0x5b44f0]                # 00487e01
    shl edx, 0x5                                 # 00487e07
    mov eax, dword ptr [0x5b44f4]                # 00487e0a
    shl eax, 0x4                                 # 00487e0f
    lea ecx, [edx + eax + 0x5b160c]              # 00487e12
    mov dword ptr [0x5d1631], ecx                # 00487e19
    mov dword ptr [0x5d1639], 0x1                # 00487e1f
    mov dword ptr [0x5c39e5], 0x2789             # 00487e29
    mov edx, dword ptr [ebp - local_4]           # 00487e33
    mov byte ptr [edx + field_24], 0x1           # 00487e36
    mov eax, dword ptr [ebp - local_4]           # 00487e3a
    mov word ptr [eax + field_66], 0xffff        # 00487e3d
    jmp.d32 L_00487ecf                           # 00487e43
L_00487e48:
    # block 0x00487e48: entered by jne at 0x00487ddf, 3 instruction(s), ends with jne to 0x00487ec6 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00487e48
    cmp ecx, 0x2788                              # 00487e4c
    jne.d8 L_00487ec6                            # 00487e52
    # block 0x00487e54: entered by fall-through of jne at 0x00487e52, 19 instruction(s), ends with jne to 0x00487ec4 (forward)
    mov dword ptr [0x5b44f0], 0x16               # 00487e54
    mov dword ptr [0x5b44f4], 0x1                # 00487e5e
    mov edx, dword ptr [0x5d0377]                # 00487e68
    mov dword ptr [0x5d162d], edx                # 00487e6e
    mov eax, dword ptr [0x5b44f0]                # 00487e74
    shl eax, 0x5                                 # 00487e79
    mov ecx, dword ptr [0x5b44f4]                # 00487e7c
    shl ecx, 0x4                                 # 00487e82
    lea edx, [eax + ecx + 0x5b160c]              # 00487e85
    mov dword ptr [0x5d1631], edx                # 00487e8c
    mov dword ptr [0x5d1639], 0x1                # 00487e92
    mov dword ptr [0x5c39e5], 0x2788             # 00487e9c
    mov eax, dword ptr [ebp - local_4]           # 00487ea6
    mov byte ptr [eax + field_24], 0x1           # 00487ea9
    mov ecx, dword ptr [ebp - local_4]           # 00487ead
    {load} xor edx, edx                          # 00487eb0
    mov dl, byte ptr [ecx + field_65]            # 00487eb2
    test edx, edx                                # 00487eb5
    jne.d8 L_00487ec4                            # 00487eb7
    # block 0x00487eb9: entered by fall-through of jne at 0x00487eb7, 3 instruction(s), falls into the block at 0x00487ec4
    mov eax, dword ptr [ebp - local_4]           # 00487eb9
    mov cx, word ptr [ebp + arg_c]               # 00487ebc
    mov word ptr [eax + field_66], cx            # 00487ec0
L_00487ec4:
    # block 0x00487ec4: entered by jne at 0x00487eb7, 1 instruction(s), ends with forward jump to 0x00487ecf
    jmp.d8 L_00487ecf                            # 00487ec4
L_00487ec6:
    # block 0x00487ec6: entered by jne at 0x00487e52, 2 instruction(s), falls into the block at 0x00487ecf
    mov edx, dword ptr [ebp - local_4]           # 00487ec6
    mov word ptr [edx + field_66], 0xffff        # 00487ec9
L_00487ecf:
    # block 0x00487ecf: entered by jmp at 0x00487e43; jmp at 0x00487ec4, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00487ecf
    pop ebp                                      # 00487ed1
    ret 0x8                                      # 00487ed2

