# FUN_0044e9ae
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e9ae
# extent:       0x0044e9ae-0x0044eab1 (259 code bytes)
# span:         0x0044e9ae-0x0044eab1 (code 259, tables 0, padding 0)
# sha256:       c34b0253cfb2a1926ae1e4e5973bf16859e046baed348501acd1d312dbae60e4
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044e9ae
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_26, field_29, field_23a; [ecx + n] field_24, field_2b; [edx + n] field_24, field_26, field_236, field_238, field_23c, field_23e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 67 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_29, 0x29  # offset +0x29
.equ field_2b, 0x2b  # offset +0x2b
.equ field_236, 0x236  # offset +0x236
.equ field_238, 0x238  # offset +0x238
.equ field_23a, 0x23a  # offset +0x23a
.equ field_23c, 0x23c  # offset +0x23c
.equ field_23e, 0x23e  # offset +0x23e

# --- external targets -----------------------------------------------

.org 0x0044e9ae - 0x401000
.globl FUN_0044e9ae
FUN_0044e9ae:
    # block 0x0044e9ae: entry, 15 instruction(s), ends with jne to 0x0044ea0b (forward)
    push ebp                                     # 0044e9ae
    {load} mov ebp, esp                          # 0044e9af
    sub esp, 0x8                                 # 0044e9b1
    mov dword ptr [ebp - local_8], ecx           # 0044e9b4
    mov eax, dword ptr [ebp - local_8]           # 0044e9b7
    movsx ecx, word ptr [eax + field_1e]         # 0044e9ba
    imul ecx, ecx, 0x8d                          # 0044e9be
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0044e9c4
    mov dword ptr [ebp - local_4], edx           # 0044e9ca
    mov eax, dword ptr [ebp - local_4]           # 0044e9cd
    movsx ecx, word ptr [eax + field_29]         # 0044e9d0
    mov edx, dword ptr [ebp - local_8]           # 0044e9d4
    movsx eax, word ptr [edx + field_24]         # 0044e9d7
    {load} cmp ecx, eax                          # 0044e9db
    jne.d8 L_0044ea0b                            # 0044e9dd
    # block 0x0044e9df: entered by fall-through of jne at 0x0044e9dd, 6 instruction(s), ends with jne to 0x0044ea0b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044e9df
    movsx edx, word ptr [ecx + field_2b]         # 0044e9e2
    mov eax, dword ptr [ebp - local_8]           # 0044e9e6
    movsx ecx, word ptr [eax + field_26]         # 0044e9e9
    {load} cmp edx, ecx                          # 0044e9ed
    jne.d8 L_0044ea0b                            # 0044e9ef
    # block 0x0044e9f1: entered by fall-through of jne at 0x0044e9ef, 4 instruction(s), ends with forward jump to 0x0044eaad
    mov edx, dword ptr [ebp - local_4]           # 0044e9f1
    movsx eax, word ptr [edx + field_23e]        # 0044e9f4
    mov dword ptr [4*eax + 0x585801], 0x1        # 0044e9fb
    jmp.d32 L_0044eaad                           # 0044ea06
L_0044ea0b:
    # block 0x0044ea0b: entered by jne at 0x0044e9dd; jne at 0x0044e9ef, 6 instruction(s), ends with jle to 0x0044ea34 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0044ea0b
    movsx edx, word ptr [ecx + field_24]         # 0044ea0e
    mov eax, dword ptr [ebp - local_4]           # 0044ea12
    movsx ecx, word ptr [eax + field_29]         # 0044ea15
    {load} cmp edx, ecx                          # 0044ea19
    jle.d8 L_0044ea34                            # 0044ea1b
    # block 0x0044ea1d: entered by fall-through of jle at 0x0044ea1b, 4 instruction(s), ends with forward jump to 0x0044eaad
    mov edx, dword ptr [ebp - local_4]           # 0044ea1d
    movsx eax, word ptr [edx + field_236]        # 0044ea20
    mov dword ptr [4*eax + 0x585801], 0x1        # 0044ea27
    jmp.d8 L_0044eaad                            # 0044ea32
L_0044ea34:
    # block 0x0044ea34: entered by jle at 0x0044ea1b, 6 instruction(s), ends with jge to 0x0044ea5d (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0044ea34
    movsx edx, word ptr [ecx + field_24]         # 0044ea37
    mov eax, dword ptr [ebp - local_4]           # 0044ea3b
    movsx ecx, word ptr [eax + field_29]         # 0044ea3e
    {load} cmp edx, ecx                          # 0044ea42
    jge.d8 L_0044ea5d                            # 0044ea44
    # block 0x0044ea46: entered by fall-through of jge at 0x0044ea44, 4 instruction(s), ends with forward jump to 0x0044eaad
    mov edx, dword ptr [ebp - local_4]           # 0044ea46
    movsx eax, word ptr [edx + field_238]        # 0044ea49
    mov dword ptr [4*eax + 0x585801], 0x1        # 0044ea50
    jmp.d8 L_0044eaad                            # 0044ea5b
L_0044ea5d:
    # block 0x0044ea5d: entered by jge at 0x0044ea44, 6 instruction(s), ends with jg to 0x0044ea98 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0044ea5d
    movsx edx, word ptr [ecx + field_24]         # 0044ea60
    mov eax, dword ptr [ebp - local_4]           # 0044ea64
    movsx ecx, word ptr [eax + field_29]         # 0044ea67
    {load} cmp edx, ecx                          # 0044ea6b
    jg.d8 L_0044ea98                             # 0044ea6d
    # block 0x0044ea6f: entered by fall-through of jg at 0x0044ea6d, 6 instruction(s), ends with jge to 0x0044ea98 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0044ea6f
    movsx eax, word ptr [edx + field_26]         # 0044ea72
    mov ecx, dword ptr [ebp - local_4]           # 0044ea76
    movsx edx, word ptr [ecx + field_2b]         # 0044ea79
    {load} cmp eax, edx                          # 0044ea7d
    jge.d8 L_0044ea98                            # 0044ea7f
    # block 0x0044ea81: entered by fall-through of jge at 0x0044ea7f, 4 instruction(s), ends with forward jump to 0x0044eaad
    mov eax, dword ptr [ebp - local_4]           # 0044ea81
    movsx ecx, word ptr [eax + field_23a]        # 0044ea84
    mov dword ptr [4*ecx + 0x585801], 0x1        # 0044ea8b
    jmp.d8 L_0044eaad                            # 0044ea96
L_0044ea98:
    # block 0x0044ea98: entered by jg at 0x0044ea6d; jge at 0x0044ea7f, 3 instruction(s), falls into the block at 0x0044eaad
    mov edx, dword ptr [ebp - local_4]           # 0044ea98
    movsx eax, word ptr [edx + field_23c]        # 0044ea9b
    mov dword ptr [4*eax + 0x585801], 0x1        # 0044eaa2
L_0044eaad:
    # block 0x0044eaad: entered by jmp at 0x0044ea06; jmp at 0x0044ea32; jmp at 0x0044ea5b; jmp at 0x0044ea96, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044eaad
    pop ebp                                      # 0044eaaf
    ret                                          # 0044eab0

