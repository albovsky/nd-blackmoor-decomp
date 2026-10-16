# FUN_004a7f08
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7f08
# extent:       0x004a7f08-0x004a8007 (255 code bytes)
# span:         0x004a7f08-0x004a8007 (code 255, tables 0, padding 0)
# sha256:       452548d93761dc4be1a8a76b34a67e0b66fb340b918979a92379c30dd3506246
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a7f08
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_e26, field_e2a, field_e2e, field_e32; [ecx + n] field_13a4, field_13a6; [edx + n] field_e26, field_e2a, field_e2e, field_e32
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 63 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_e26, 0xe26  # offset +0xe26
.equ field_e2a, 0xe2a  # offset +0xe2a
.equ field_e2e, 0xe2e  # offset +0xe2e
.equ field_e32, 0xe32  # offset +0xe32
.equ field_13a4, 0x13a4  # offset +0x13a4
.equ field_13a6, 0x13a6  # offset +0x13a6

# --- external targets -----------------------------------------------

.org 0x004a7f08 - 0x401000
.globl FUN_004a7f08
FUN_004a7f08:
    # block 0x004a7f08: entry, 8 instruction(s), ends with jge to 0x004a7f4c (forward)
    push ebp                                     # 004a7f08
    {load} mov ebp, esp                          # 004a7f09
    push ecx                                     # 004a7f0b
    mov dword ptr [ebp - local_4], ecx           # 004a7f0c
    mov eax, dword ptr [ebp - local_4]           # 004a7f0f
    mov ecx, dword ptr [eax + field_e2a]         # 004a7f12
    cmp ecx, dword ptr [0x58319a]                # 004a7f18
    jge.d8 L_004a7f4c                            # 004a7f1e
    # block 0x004a7f20: entered by fall-through of jge at 0x004a7f1e, 10 instruction(s), falls into the block at 0x004a7f4c
    mov edx, dword ptr [ebp - local_4]           # 004a7f20
    mov eax, dword ptr [0x58319a]                # 004a7f23
    mov dword ptr [edx + field_e2a], eax         # 004a7f28
    mov ecx, dword ptr [ebp - local_4]           # 004a7f2e
    movsx edx, word ptr [ecx + field_13a6]       # 004a7f31
    mov eax, dword ptr [ebp - local_4]           # 004a7f38
    mov ecx, dword ptr [eax + field_e2a]         # 004a7f3b
    {load} add ecx, edx                          # 004a7f41
    mov edx, dword ptr [ebp - local_4]           # 004a7f43
    mov dword ptr [edx + field_e32], ecx         # 004a7f46
L_004a7f4c:
    # block 0x004a7f4c: entered by jge at 0x004a7f1e, 4 instruction(s), ends with jle to 0x004a7f89 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a7f4c
    mov ecx, dword ptr [eax + field_e32]         # 004a7f4f
    cmp ecx, dword ptr [0x5831a2]                # 004a7f55
    jle.d8 L_004a7f89                            # 004a7f5b
    # block 0x004a7f5d: entered by fall-through of jle at 0x004a7f5b, 10 instruction(s), falls into the block at 0x004a7f89
    mov edx, dword ptr [ebp - local_4]           # 004a7f5d
    mov eax, dword ptr [0x5831a2]                # 004a7f60
    mov dword ptr [edx + field_e32], eax         # 004a7f65
    mov ecx, dword ptr [ebp - local_4]           # 004a7f6b
    movsx edx, word ptr [ecx + field_13a6]       # 004a7f6e
    mov eax, dword ptr [ebp - local_4]           # 004a7f75
    mov ecx, dword ptr [eax + field_e32]         # 004a7f78
    {load} sub ecx, edx                          # 004a7f7e
    mov edx, dword ptr [ebp - local_4]           # 004a7f80
    mov dword ptr [edx + field_e2a], ecx         # 004a7f83
L_004a7f89:
    # block 0x004a7f89: entered by jle at 0x004a7f5b, 4 instruction(s), ends with jge to 0x004a7fc6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a7f89
    mov ecx, dword ptr [eax + field_e26]         # 004a7f8c
    cmp ecx, dword ptr [0x583196]                # 004a7f92
    jge.d8 L_004a7fc6                            # 004a7f98
    # block 0x004a7f9a: entered by fall-through of jge at 0x004a7f98, 10 instruction(s), falls into the block at 0x004a7fc6
    mov edx, dword ptr [ebp - local_4]           # 004a7f9a
    mov eax, dword ptr [0x583196]                # 004a7f9d
    mov dword ptr [edx + field_e26], eax         # 004a7fa2
    mov ecx, dword ptr [ebp - local_4]           # 004a7fa8
    movsx edx, word ptr [ecx + field_13a4]       # 004a7fab
    mov eax, dword ptr [ebp - local_4]           # 004a7fb2
    mov ecx, dword ptr [eax + field_e26]         # 004a7fb5
    {load} add ecx, edx                          # 004a7fbb
    mov edx, dword ptr [ebp - local_4]           # 004a7fbd
    mov dword ptr [edx + field_e2e], ecx         # 004a7fc0
L_004a7fc6:
    # block 0x004a7fc6: entered by jge at 0x004a7f98, 4 instruction(s), ends with jle to 0x004a8003 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a7fc6
    mov ecx, dword ptr [eax + field_e2e]         # 004a7fc9
    cmp ecx, dword ptr [0x58319e]                # 004a7fcf
    jle.d8 L_004a8003                            # 004a7fd5
    # block 0x004a7fd7: entered by fall-through of jle at 0x004a7fd5, 10 instruction(s), falls into the block at 0x004a8003
    mov edx, dword ptr [ebp - local_4]           # 004a7fd7
    mov eax, dword ptr [0x58319e]                # 004a7fda
    mov dword ptr [edx + field_e2e], eax         # 004a7fdf
    mov ecx, dword ptr [ebp - local_4]           # 004a7fe5
    movsx edx, word ptr [ecx + field_13a4]       # 004a7fe8
    mov eax, dword ptr [ebp - local_4]           # 004a7fef
    mov ecx, dword ptr [eax + field_e2e]         # 004a7ff2
    {load} sub ecx, edx                          # 004a7ff8
    mov edx, dword ptr [ebp - local_4]           # 004a7ffa
    mov dword ptr [edx + field_e26], ecx         # 004a7ffd
L_004a8003:
    # block 0x004a8003: entered by jle at 0x004a7fd5, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a8003
    pop ebp                                      # 004a8005
    ret                                          # 004a8006

