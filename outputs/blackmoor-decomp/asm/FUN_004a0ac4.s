# FUN_004a0ac4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a0ac4
# extent:       0x004a0ac4-0x004a0bbd (249 code bytes)
# span:         0x004a0ac4-0x004a0bbd (code 249, tables 0, padding 0)
# sha256:       62d833bf88cc8bd93261633c89d1e3992712e23d043632fad7347cf62f7df56c
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a0ac4
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_e40; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 66 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_e40, 0xe40  # offset +0xe40

# --- external targets -----------------------------------------------

.org 0x004a0ac4 - 0x401000
.globl FUN_004a0ac4
FUN_004a0ac4:
    # block 0x004a0ac4: entry, 66 instruction(s), ends with ret 0x10
    push ebp                                     # 004a0ac4
    {load} mov ebp, esp                          # 004a0ac5
    sub esp, 0x18                                # 004a0ac7
    mov dword ptr [ebp - local_18], ecx          # 004a0aca
    mov word ptr [ebp - local_4], 0x0            # 004a0acd
    mov ax, word ptr [ebp - local_4]             # 004a0ad3
    mov word ptr [ebp - local_8], ax             # 004a0ad7
    mov cx, word ptr [ebp - local_8]             # 004a0adb
    mov word ptr [ebp - local_10], cx            # 004a0adf
    mov dx, word ptr [ebp - local_10]            # 004a0ae3
    mov word ptr [ebp - local_14], dx            # 004a0ae7
    mov ax, word ptr [ebp - local_14]            # 004a0aeb
    mov word ptr [ebp - local_c], ax             # 004a0aef
    mov cx, word ptr [ebp + arg_14]              # 004a0af3
    mov word ptr [ebp - local_4], cx             # 004a0af7
    mov dx, word ptr [ebp - local_4]             # 004a0afb
    shl dx, 0xc                                  # 004a0aff
    mov word ptr [ebp - local_4], dx             # 004a0b03
    mov eax, dword ptr [ebp + arg_10]            # 004a0b07
    imul eax, eax, 0x5                           # 004a0b0a
    movzx cx, byte ptr [eax + 0x54f9ce]          # 004a0b0d
    mov dx, word ptr [ebp - local_14]            # 004a0b15
    {load} or dx, cx                             # 004a0b19
    mov word ptr [ebp - local_14], dx            # 004a0b1c
    mov ax, word ptr [ebp - local_14]            # 004a0b20
    shl ax, 0x8                                  # 004a0b24
    mov word ptr [ebp - local_14], ax            # 004a0b28
    mov ecx, dword ptr [ebp + arg_10]            # 004a0b2c
    imul ecx, ecx, 0x5                           # 004a0b2f
    movzx dx, byte ptr [ecx + 0x54f9cf]          # 004a0b32
    mov ax, word ptr [ebp - local_10]            # 004a0b3a
    {load} or ax, dx                             # 004a0b3e
    mov word ptr [ebp - local_10], ax            # 004a0b41
    mov cx, word ptr [ebp - local_10]            # 004a0b45
    shl cx, 0x4                                  # 004a0b49
    mov word ptr [ebp - local_10], cx            # 004a0b4d
    mov edx, dword ptr [ebp + arg_10]            # 004a0b51
    imul edx, edx, 0x5                           # 004a0b54
    movzx ax, byte ptr [edx + 0x54f9d0]          # 004a0b57
    mov cx, word ptr [ebp - local_8]             # 004a0b5f
    {load} or cx, ax                             # 004a0b63
    mov word ptr [ebp - local_8], cx             # 004a0b66
    mov edx, dword ptr [ebp - local_4]           # 004a0b6a
    and edx, 0xffff                              # 004a0b6d
    mov eax, dword ptr [ebp - local_14]          # 004a0b73
    and eax, 0xffff                              # 004a0b76
    {load} or edx, eax                           # 004a0b7b
    mov ecx, dword ptr [ebp - local_10]          # 004a0b7d
    and ecx, 0xffff                              # 004a0b80
    {load} or edx, ecx                           # 004a0b86
    mov eax, dword ptr [ebp - local_8]           # 004a0b88
    and eax, 0xffff                              # 004a0b8b
    {load} or edx, eax                           # 004a0b90
    mov word ptr [ebp - local_c], dx             # 004a0b92
    mov ecx, dword ptr [ebp - local_18]          # 004a0b96
    mov edx, dword ptr [ebp + arg_8]             # 004a0b99
    imul edx, dword ptr [ecx + field_1c]         # 004a0b9c
    mov eax, dword ptr [ebp - local_18]          # 004a0ba0
    mov ecx, dword ptr [eax + field_e40]         # 004a0ba3
    lea edx, [ecx + 2*edx]                       # 004a0ba9
    mov eax, dword ptr [ebp + arg_c]             # 004a0bac
    mov cx, word ptr [ebp - local_c]             # 004a0baf
    mov word ptr [edx + 2*eax], cx               # 004a0bb3
    {load} mov esp, ebp                          # 004a0bb7
    pop ebp                                      # 004a0bb9
    ret 0x10                                     # 004a0bba

