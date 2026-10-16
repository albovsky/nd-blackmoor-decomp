# FUN_004a0bbd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a0bbd
# extent:       0x004a0bbd-0x004a0c7f (194 code bytes)
# span:         0x004a0bbd-0x004a0c7f (code 194, tables 0, padding 0)
# sha256:       24fbcb17fdabd970646f9b1cc4e156f92698ccb90b016c20bdf979015aa49c39
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a0bbd
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1c; [edx + n] field_e44
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_e44, 0xe44  # offset +0xe44

# --- external targets -----------------------------------------------

.org 0x004a0bbd - 0x401000
.globl FUN_004a0bbd
FUN_004a0bbd:
    # block 0x004a0bbd: entry, 52 instruction(s), ends with ret 0x10
    push ebp                                     # 004a0bbd
    {load} mov ebp, esp                          # 004a0bbe
    sub esp, 0x14                                # 004a0bc0
    mov dword ptr [ebp - local_14], ecx          # 004a0bc3
    mov word ptr [ebp - local_4], 0x0            # 004a0bc6
    mov ax, word ptr [ebp - local_4]             # 004a0bcc
    mov word ptr [ebp - local_10], ax            # 004a0bd0
    mov cx, word ptr [ebp - local_10]            # 004a0bd4
    mov word ptr [ebp - local_8], cx             # 004a0bd8
    mov dx, word ptr [ebp - local_8]             # 004a0bdc
    mov word ptr [ebp - local_c], dx             # 004a0be0
    mov ax, word ptr [ebp + arg_14]              # 004a0be4
    mov word ptr [ebp - local_4], ax             # 004a0be8
    mov cx, word ptr [ebp - local_4]             # 004a0bec
    shl cx, 0xc                                  # 004a0bf0
    mov word ptr [ebp - local_4], cx             # 004a0bf4
    mov edx, dword ptr [ebp + arg_10]            # 004a0bf8
    imul edx, edx, 0x5                           # 004a0bfb
    movzx ax, byte ptr [edx + 0x54f9cc]          # 004a0bfe
    mov cx, word ptr [ebp - local_10]            # 004a0c06
    {load} or cx, ax                             # 004a0c0a
    mov word ptr [ebp - local_10], cx            # 004a0c0d
    mov dx, word ptr [ebp - local_10]            # 004a0c11
    shl dx, 0x4                                  # 004a0c15
    mov word ptr [ebp - local_10], dx            # 004a0c19
    mov eax, dword ptr [ebp + arg_10]            # 004a0c1d
    imul eax, eax, 0x5                           # 004a0c20
    movzx cx, byte ptr [eax + 0x54f9cd]          # 004a0c23
    mov dx, word ptr [ebp - local_8]             # 004a0c2b
    {load} or dx, cx                             # 004a0c2f
    mov word ptr [ebp - local_8], dx             # 004a0c32
    mov eax, dword ptr [ebp - local_4]           # 004a0c36
    and eax, 0xffff                              # 004a0c39
    mov ecx, dword ptr [ebp - local_10]          # 004a0c3e
    and ecx, 0xffff                              # 004a0c41
    {load} or eax, ecx                           # 004a0c47
    mov edx, dword ptr [ebp - local_8]           # 004a0c49
    and edx, 0xffff                              # 004a0c4c
    {load} or eax, edx                           # 004a0c52
    mov word ptr [ebp - local_c], ax             # 004a0c54
    mov eax, dword ptr [ebp - local_14]          # 004a0c58
    mov ecx, dword ptr [ebp + arg_8]             # 004a0c5b
    imul ecx, dword ptr [eax + field_1c]         # 004a0c5e
    mov edx, dword ptr [ebp - local_14]          # 004a0c62
    mov eax, dword ptr [edx + field_e44]         # 004a0c65
    lea ecx, [eax + 2*ecx]                       # 004a0c6b
    mov edx, dword ptr [ebp + arg_c]             # 004a0c6e
    mov ax, word ptr [ebp - local_c]             # 004a0c71
    mov word ptr [ecx + 2*edx], ax               # 004a0c75
    {load} mov esp, ebp                          # 004a0c79
    pop ebp                                      # 004a0c7b
    ret 0x10                                     # 004a0c7c

