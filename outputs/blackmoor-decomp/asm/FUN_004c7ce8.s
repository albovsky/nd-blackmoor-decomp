# FUN_004c7ce8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c7ce8
# extent:       0x004c7ce8-0x004c808f (935 code bytes)
# span:         0x004c7ce8-0x004c808f (code 935, tables 0, padding 0)
# sha256:       238dbb65ee4e8950693a0fd2b0b9b30d31be4f5581db80283060f3a4f0506f6e
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c7ce8
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       [eax + n] field_2f; [ecx + n] field_2f
# callees:      calls FUN_004c8757, FUN_004c880f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 327 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_2f, 0x2f  # offset +0x2f

# --- external targets -----------------------------------------------
.set FUN_004c8757, .text + (0x004c8757 - 0x401000)
.set FUN_004c880f, .text + (0x004c880f - 0x401000)

.org 0x004c7ce8 - 0x401000
.globl FUN_004c7ce8
FUN_004c7ce8:
    # block 0x004c7ce8: entry, 7 instruction(s), ends with jle to 0x004c7d1d (forward)
    push ebp                                     # 004c7ce8
    {load} mov ebp, esp                          # 004c7ce9
    sub esp, 0x38                                # 004c7ceb
    mov dword ptr [ebp - local_38], ecx          # 004c7cee
    mov eax, dword ptr [ebp + arg_10]            # 004c7cf1
    cmp eax, dword ptr [ebp + arg_18]            # 004c7cf4
    jle.d8 L_004c7d1d                            # 004c7cf7
    # block 0x004c7cf9: entered by fall-through of jle at 0x004c7cf7, 12 instruction(s), falls into the block at 0x004c7d1d
    mov ecx, dword ptr [ebp + arg_10]            # 004c7cf9
    mov dword ptr [ebp - local_14], ecx          # 004c7cfc
    mov edx, dword ptr [ebp + arg_18]            # 004c7cff
    mov dword ptr [ebp + arg_10], edx            # 004c7d02
    mov eax, dword ptr [ebp - local_14]          # 004c7d05
    mov dword ptr [ebp + arg_18], eax            # 004c7d08
    mov ecx, dword ptr [ebp + arg_c]             # 004c7d0b
    mov dword ptr [ebp - local_14], ecx          # 004c7d0e
    mov edx, dword ptr [ebp + arg_14]            # 004c7d11
    mov dword ptr [ebp + arg_c], edx             # 004c7d14
    mov eax, dword ptr [ebp - local_14]          # 004c7d17
    mov dword ptr [ebp + arg_14], eax            # 004c7d1a
L_004c7d1d:
    # block 0x004c7d1d: entered by jle at 0x004c7cf7, 17 instruction(s), ends with jge to 0x004c7d63 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004c7d1d
    movsx edx, word ptr [ecx + field_2f]         # 004c7d20
    mov eax, dword ptr [ebp + arg_10]            # 004c7d24
    imul eax, edx                                # 004c7d27
    mov ecx, dword ptr [ebp + arg_8]             # 004c7d2a
    mov edx, dword ptr [ecx]                     # 004c7d2d
    {load} add edx, eax                          # 004c7d2f
    movsx eax, word ptr [0x639895]               # 004c7d31
    mov ecx, dword ptr [ebp + arg_c]             # 004c7d38
    imul ecx, eax                                # 004c7d3b
    {load} add edx, ecx                          # 004c7d3e
    mov dword ptr [ebp - local_30], edx          # 004c7d40
    mov edx, dword ptr [ebp + arg_14]            # 004c7d43
    sub edx, dword ptr [ebp + arg_c]             # 004c7d46
    mov dword ptr [ebp - local_24], edx          # 004c7d49
    cmp dword ptr [ebp - local_24], 0x0          # 004c7d4c
    jge.d8 L_004c7d63                            # 004c7d50
    # block 0x004c7d52: entered by fall-through of jge at 0x004c7d50, 5 instruction(s), ends with forward jump to 0x004c7d6a
    mov dword ptr [ebp - local_4], 0xffffffff    # 004c7d52
    mov eax, dword ptr [ebp - local_24]          # 004c7d59
    neg eax                                      # 004c7d5c
    mov dword ptr [ebp - local_24], eax          # 004c7d5e
    jmp.d8 L_004c7d6a                            # 004c7d61
L_004c7d63:
    # block 0x004c7d63: entered by jge at 0x004c7d50, 1 instruction(s), falls into the block at 0x004c7d6a
    mov dword ptr [ebp - local_4], 0x1           # 004c7d63
L_004c7d6a:
    # block 0x004c7d6a: entered by jmp at 0x004c7d61, 5 instruction(s), ends with jne to 0x004c7db3 (forward)
    mov ecx, dword ptr [ebp + arg_18]            # 004c7d6a
    sub ecx, dword ptr [ebp + arg_10]            # 004c7d6d
    mov dword ptr [ebp - local_20], ecx          # 004c7d70
    cmp dword ptr [ebp - local_24], 0x0          # 004c7d73
    jne.d8 L_004c7db3                            # 004c7d77
    # block 0x004c7d79: entered by fall-through of jne at 0x004c7d77, 2 instruction(s), ends with forward jump to 0x004c7d8b
    mov dword ptr [ebp - local_1c], 0x0          # 004c7d79
    jmp.d8 L_004c7d8b                            # 004c7d80
L_004c7d82:
    # block 0x004c7d82: entered by jmp at 0x004c7dac, 3 instruction(s), falls into the block at 0x004c7d8b
    mov edx, dword ptr [ebp - local_1c]          # 004c7d82
    add edx, 0x1                                 # 004c7d85
    mov dword ptr [ebp - local_1c], edx          # 004c7d88
L_004c7d8b:
    # block 0x004c7d8b: entered by jmp at 0x004c7d80, 3 instruction(s), ends with jg to 0x004c7dae (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c7d8b
    cmp eax, dword ptr [ebp - local_20]          # 004c7d8e
    jg.d8 L_004c7dae                             # 004c7d91
    # block 0x004c7d93: entered by fall-through of jg at 0x004c7d91, 9 instruction(s), ends with backward jump to 0x004c7d82
    mov ecx, dword ptr [ebp - local_30]          # 004c7d93
    mov dx, word ptr [ebp + arg_1c]              # 004c7d96
    mov word ptr [ecx], dx                       # 004c7d9a
    mov eax, dword ptr [ebp + arg_8]             # 004c7d9d
    movsx ecx, word ptr [eax + field_2f]         # 004c7da0
    mov edx, dword ptr [ebp - local_30]          # 004c7da4
    {load} add edx, ecx                          # 004c7da7
    mov dword ptr [ebp - local_30], edx          # 004c7da9
    jmp.d8 L_004c7d82                            # 004c7dac
L_004c7dae:
    # block 0x004c7dae: entered by jg at 0x004c7d91, 1 instruction(s), ends with forward jump to 0x004c8089
    jmp.d32 L_004c8089                           # 004c7dae
L_004c7db3:
    # block 0x004c7db3: entered by jne at 0x004c7d77, 2 instruction(s), ends with jne to 0x004c7df9 (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 004c7db3
    jne.d8 L_004c7df9                            # 004c7db7
    # block 0x004c7db9: entered by fall-through of jne at 0x004c7db7, 2 instruction(s), ends with forward jump to 0x004c7dcb
    mov dword ptr [ebp - local_1c], 0x0          # 004c7db9
    jmp.d8 L_004c7dcb                            # 004c7dc0
L_004c7dc2:
    # block 0x004c7dc2: entered by jmp at 0x004c7df2, 3 instruction(s), falls into the block at 0x004c7dcb
    mov eax, dword ptr [ebp - local_1c]          # 004c7dc2
    add eax, 0x1                                 # 004c7dc5
    mov dword ptr [ebp - local_1c], eax          # 004c7dc8
L_004c7dcb:
    # block 0x004c7dcb: entered by jmp at 0x004c7dc0, 3 instruction(s), ends with jg to 0x004c7df4 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004c7dcb
    cmp ecx, dword ptr [ebp - local_24]          # 004c7dce
    jg.d8 L_004c7df4                             # 004c7dd1
    # block 0x004c7dd3: entered by fall-through of jg at 0x004c7dd1, 10 instruction(s), ends with backward jump to 0x004c7dc2
    mov edx, dword ptr [ebp - local_30]          # 004c7dd3
    mov ax, word ptr [ebp + arg_1c]              # 004c7dd6
    mov word ptr [edx], ax                       # 004c7dda
    movsx ecx, word ptr [0x639895]               # 004c7ddd
    mov edx, dword ptr [ebp - local_4]           # 004c7de4
    imul edx, ecx                                # 004c7de7
    mov eax, dword ptr [ebp - local_30]          # 004c7dea
    {load} add eax, edx                          # 004c7ded
    mov dword ptr [ebp - local_30], eax          # 004c7def
    jmp.d8 L_004c7dc2                            # 004c7df2
L_004c7df4:
    # block 0x004c7df4: entered by jg at 0x004c7dd1, 1 instruction(s), ends with forward jump to 0x004c8089
    jmp.d32 L_004c8089                           # 004c7df4
L_004c7df9:
    # block 0x004c7df9: entered by jne at 0x004c7db7, 3 instruction(s), ends with jne to 0x004c7e48 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004c7df9
    cmp ecx, dword ptr [ebp - local_20]          # 004c7dfc
    jne.d8 L_004c7e48                            # 004c7dff
    # block 0x004c7e01: entered by fall-through of jne at 0x004c7dff, 2 instruction(s), ends with forward jump to 0x004c7e13
    mov dword ptr [ebp - local_1c], 0x0          # 004c7e01
    jmp.d8 L_004c7e13                            # 004c7e08
L_004c7e0a:
    # block 0x004c7e0a: entered by jmp at 0x004c7e41, 3 instruction(s), falls into the block at 0x004c7e13
    mov edx, dword ptr [ebp - local_1c]          # 004c7e0a
    add edx, 0x1                                 # 004c7e0d
    mov dword ptr [ebp - local_1c], edx          # 004c7e10
L_004c7e13:
    # block 0x004c7e13: entered by jmp at 0x004c7e08, 3 instruction(s), ends with jg to 0x004c7e43 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004c7e13
    cmp eax, dword ptr [ebp - local_24]          # 004c7e16
    jg.d8 L_004c7e43                             # 004c7e19
    # block 0x004c7e1b: entered by fall-through of jg at 0x004c7e19, 12 instruction(s), ends with backward jump to 0x004c7e0a
    mov ecx, dword ptr [ebp - local_30]          # 004c7e1b
    mov dx, word ptr [ebp + arg_1c]              # 004c7e1e
    mov word ptr [ecx], dx                       # 004c7e22
    mov eax, dword ptr [ebp + arg_8]             # 004c7e25
    movsx ecx, word ptr [eax + field_2f]         # 004c7e28
    movsx edx, word ptr [0x639895]               # 004c7e2c
    mov eax, dword ptr [ebp - local_4]           # 004c7e33
    imul eax, edx                                # 004c7e36
    add eax, dword ptr [ebp - local_30]          # 004c7e39
    {load} add eax, ecx                          # 004c7e3c
    mov dword ptr [ebp - local_30], eax          # 004c7e3e
    jmp.d8 L_004c7e0a                            # 004c7e41
L_004c7e43:
    # block 0x004c7e43: entered by jg at 0x004c7e19, 1 instruction(s), ends with forward jump to 0x004c8089
    jmp.d32 L_004c8089                           # 004c7e43
L_004c7e48:
    # block 0x004c7e48: entered by jne at 0x004c7dff, 3 instruction(s), ends with jl to 0x004c7f71 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 004c7e48
    cmp ecx, dword ptr [ebp - local_20]          # 004c7e4b
    jl.d32 L_004c7f71                            # 004c7e4e
    # block 0x004c7e54: entered by fall-through of jl at 0x004c7e4e, 29 instruction(s), ends with jne to 0x004c7eb0 (forward)
    mov eax, dword ptr [ebp - local_24]          # 004c7e54
    cdq                                          # 004c7e57
    idiv dword ptr [ebp - local_20]              # 004c7e58
    mov dword ptr [ebp - local_8], eax           # 004c7e5b
    mov eax, dword ptr [ebp - local_24]          # 004c7e5e
    cdq                                          # 004c7e61
    idiv dword ptr [ebp - local_20]              # 004c7e62
    shl edx                                      # 004c7e65
    mov dword ptr [ebp - local_10], edx          # 004c7e67
    mov edx, dword ptr [ebp - local_20]          # 004c7e6a
    shl edx                                      # 004c7e6d
    mov dword ptr [ebp - local_34], edx          # 004c7e6f
    mov eax, dword ptr [ebp - local_24]          # 004c7e72
    cdq                                          # 004c7e75
    idiv dword ptr [ebp - local_20]              # 004c7e76
    mov eax, dword ptr [ebp - local_20]          # 004c7e79
    shl eax                                      # 004c7e7c
    {load} sub edx, eax                          # 004c7e7e
    mov dword ptr [ebp - local_2c], edx          # 004c7e80
    mov eax, dword ptr [ebp - local_8]           # 004c7e83
    cdq                                          # 004c7e86
    {load} sub eax, edx                          # 004c7e87
    sar eax                                      # 004c7e89
    add eax, 0x1                                 # 004c7e8b
    mov dword ptr [ebp - local_28], eax          # 004c7e8e
    mov ecx, dword ptr [ebp - local_28]          # 004c7e91
    mov dword ptr [ebp - local_18], ecx          # 004c7e94
    cmp dword ptr [ebp - local_10], 0x0          # 004c7e97
    jne.d8 L_004c7eb0                            # 004c7e9b
    # block 0x004c7e9d: entered by fall-through of jne at 0x004c7e9b, 4 instruction(s), ends with jne to 0x004c7eb0 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c7e9d
    and edx, 0x1                                 # 004c7ea0
    test edx, edx                                # 004c7ea3
    jne.d8 L_004c7eb0                            # 004c7ea5
    # block 0x004c7ea7: entered by fall-through of jne at 0x004c7ea5, 3 instruction(s), falls into the block at 0x004c7eb0
    mov eax, dword ptr [ebp - local_28]          # 004c7ea7
    sub eax, 0x1                                 # 004c7eaa
    mov dword ptr [ebp - local_28], eax          # 004c7ead
L_004c7eb0:
    # block 0x004c7eb0: entered by jne at 0x004c7e9b; jne at 0x004c7ea5, 4 instruction(s), ends with je to 0x004c7ec3 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c7eb0
    and ecx, 0x1                                 # 004c7eb3
    test ecx, ecx                                # 004c7eb6
    je.d8 L_004c7ec3                             # 004c7eb8
    # block 0x004c7eba: entered by fall-through of je at 0x004c7eb8, 3 instruction(s), falls into the block at 0x004c7ec3
    mov edx, dword ptr [ebp - local_2c]          # 004c7eba
    add edx, dword ptr [ebp - local_20]          # 004c7ebd
    mov dword ptr [ebp - local_2c], edx          # 004c7ec0
L_004c7ec3:
    # block 0x004c7ec3: entered by je at 0x004c7eb8, 15 instruction(s), calls FUN_004c8757, ends with forward jump to 0x004c7ef6
    mov ax, word ptr [ebp + arg_1c]              # 004c7ec3
    push eax                                     # 004c7ec7
    mov ecx, dword ptr [ebp - local_28]          # 004c7ec8
    push ecx                                     # 004c7ecb
    mov edx, dword ptr [ebp - local_4]           # 004c7ecc
    push edx                                     # 004c7ecf
    mov eax, dword ptr [ebp + arg_8]             # 004c7ed0
    movsx ecx, word ptr [eax + field_2f]         # 004c7ed3
    push ecx                                     # 004c7ed7
    lea edx, [ebp - local_30]                    # 004c7ed8
    push edx                                     # 004c7edb
    mov ecx, dword ptr [ebp - local_38]          # 004c7edc
    call FUN_004c8757                            # 004c7edf
    mov dword ptr [ebp - local_1c], 0x0          # 004c7ee4
    jmp.d8 L_004c7ef6                            # 004c7eeb
L_004c7eed:
    # block 0x004c7eed: entered by jmp at 0x004c7f49, 3 instruction(s), falls into the block at 0x004c7ef6
    mov eax, dword ptr [ebp - local_1c]          # 004c7eed
    add eax, 0x1                                 # 004c7ef0
    mov dword ptr [ebp - local_1c], eax          # 004c7ef3
L_004c7ef6:
    # block 0x004c7ef6: entered by jmp at 0x004c7eeb, 4 instruction(s), ends with jge to 0x004c7f4b (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004c7ef6
    sub ecx, 0x1                                 # 004c7ef9
    cmp dword ptr [ebp - local_1c], ecx          # 004c7efc
    jge.d8 L_004c7f4b                            # 004c7eff
    # block 0x004c7f01: entered by fall-through of jge at 0x004c7eff, 7 instruction(s), ends with jle to 0x004c7f28 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c7f01
    mov dword ptr [ebp - local_c], edx           # 004c7f04
    mov eax, dword ptr [ebp - local_2c]          # 004c7f07
    add eax, dword ptr [ebp - local_10]          # 004c7f0a
    mov dword ptr [ebp - local_2c], eax          # 004c7f0d
    cmp dword ptr [ebp - local_2c], 0x0          # 004c7f10
    jle.d8 L_004c7f28                            # 004c7f14
    # block 0x004c7f16: entered by fall-through of jle at 0x004c7f14, 6 instruction(s), falls into the block at 0x004c7f28
    mov ecx, dword ptr [ebp - local_c]           # 004c7f16
    add ecx, 0x1                                 # 004c7f19
    mov dword ptr [ebp - local_c], ecx           # 004c7f1c
    mov edx, dword ptr [ebp - local_2c]          # 004c7f1f
    sub edx, dword ptr [ebp - local_34]          # 004c7f22
    mov dword ptr [ebp - local_2c], edx          # 004c7f25
L_004c7f28:
    # block 0x004c7f28: entered by jle at 0x004c7f14, 14 instruction(s), calls FUN_004c8757, ends with backward jump to 0x004c7eed
    mov ax, word ptr [ebp + arg_1c]              # 004c7f28
    push eax                                     # 004c7f2c
    mov ecx, dword ptr [ebp - local_c]           # 004c7f2d
    push ecx                                     # 004c7f30
    mov edx, dword ptr [ebp - local_4]           # 004c7f31
    push edx                                     # 004c7f34
    mov eax, dword ptr [ebp + arg_8]             # 004c7f35
    movsx ecx, word ptr [eax + field_2f]         # 004c7f38
    push ecx                                     # 004c7f3c
    lea edx, [ebp - local_30]                    # 004c7f3d
    push edx                                     # 004c7f40
    mov ecx, dword ptr [ebp - local_38]          # 004c7f41
    call FUN_004c8757                            # 004c7f44
    jmp.d8 L_004c7eed                            # 004c7f49
L_004c7f4b:
    # block 0x004c7f4b: entered by jge at 0x004c7eff, 14 instruction(s), calls FUN_004c8757, ends with forward jump to 0x004c8089
    mov ax, word ptr [ebp + arg_1c]              # 004c7f4b
    push eax                                     # 004c7f4f
    mov ecx, dword ptr [ebp - local_18]          # 004c7f50
    push ecx                                     # 004c7f53
    mov edx, dword ptr [ebp - local_4]           # 004c7f54
    push edx                                     # 004c7f57
    mov eax, dword ptr [ebp + arg_8]             # 004c7f58
    movsx ecx, word ptr [eax + field_2f]         # 004c7f5b
    push ecx                                     # 004c7f5f
    lea edx, [ebp - local_30]                    # 004c7f60
    push edx                                     # 004c7f63
    mov ecx, dword ptr [ebp - local_38]          # 004c7f64
    call FUN_004c8757                            # 004c7f67
    jmp.d32 L_004c8089                           # 004c7f6c
L_004c7f71:
    # block 0x004c7f71: entered by jl at 0x004c7e4e, 29 instruction(s), ends with jne to 0x004c7fcd (forward)
    mov eax, dword ptr [ebp - local_20]          # 004c7f71
    cdq                                          # 004c7f74
    idiv dword ptr [ebp - local_24]              # 004c7f75
    mov dword ptr [ebp - local_8], eax           # 004c7f78
    mov eax, dword ptr [ebp - local_20]          # 004c7f7b
    cdq                                          # 004c7f7e
    idiv dword ptr [ebp - local_24]              # 004c7f7f
    shl edx                                      # 004c7f82
    mov dword ptr [ebp - local_10], edx          # 004c7f84
    mov eax, dword ptr [ebp - local_24]          # 004c7f87
    shl eax                                      # 004c7f8a
    mov dword ptr [ebp - local_34], eax          # 004c7f8c
    mov eax, dword ptr [ebp - local_20]          # 004c7f8f
    cdq                                          # 004c7f92
    idiv dword ptr [ebp - local_24]              # 004c7f93
    mov ecx, dword ptr [ebp - local_24]          # 004c7f96
    shl ecx                                      # 004c7f99
    {load} sub edx, ecx                          # 004c7f9b
    mov dword ptr [ebp - local_2c], edx          # 004c7f9d
    mov eax, dword ptr [ebp - local_8]           # 004c7fa0
    cdq                                          # 004c7fa3
    {load} sub eax, edx                          # 004c7fa4
    sar eax                                      # 004c7fa6
    add eax, 0x1                                 # 004c7fa8
    mov dword ptr [ebp - local_28], eax          # 004c7fab
    mov edx, dword ptr [ebp - local_28]          # 004c7fae
    mov dword ptr [ebp - local_18], edx          # 004c7fb1
    cmp dword ptr [ebp - local_10], 0x0          # 004c7fb4
    jne.d8 L_004c7fcd                            # 004c7fb8
    # block 0x004c7fba: entered by fall-through of jne at 0x004c7fb8, 4 instruction(s), ends with jne to 0x004c7fcd (forward)
    mov eax, dword ptr [ebp - local_8]           # 004c7fba
    and eax, 0x1                                 # 004c7fbd
    test eax, eax                                # 004c7fc0
    jne.d8 L_004c7fcd                            # 004c7fc2
    # block 0x004c7fc4: entered by fall-through of jne at 0x004c7fc2, 3 instruction(s), falls into the block at 0x004c7fcd
    mov ecx, dword ptr [ebp - local_28]          # 004c7fc4
    sub ecx, 0x1                                 # 004c7fc7
    mov dword ptr [ebp - local_28], ecx          # 004c7fca
L_004c7fcd:
    # block 0x004c7fcd: entered by jne at 0x004c7fb8; jne at 0x004c7fc2, 4 instruction(s), ends with je to 0x004c7fe0 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004c7fcd
    and edx, 0x1                                 # 004c7fd0
    test edx, edx                                # 004c7fd3
    je.d8 L_004c7fe0                             # 004c7fd5
    # block 0x004c7fd7: entered by fall-through of je at 0x004c7fd5, 3 instruction(s), falls into the block at 0x004c7fe0
    mov eax, dword ptr [ebp - local_2c]          # 004c7fd7
    add eax, dword ptr [ebp - local_24]          # 004c7fda
    mov dword ptr [ebp - local_2c], eax          # 004c7fdd
L_004c7fe0:
    # block 0x004c7fe0: entered by je at 0x004c7fd5, 15 instruction(s), calls FUN_004c880f, ends with forward jump to 0x004c8013
    mov cx, word ptr [ebp + arg_1c]              # 004c7fe0
    push ecx                                     # 004c7fe4
    mov edx, dword ptr [ebp - local_28]          # 004c7fe5
    push edx                                     # 004c7fe8
    mov eax, dword ptr [ebp - local_4]           # 004c7fe9
    push eax                                     # 004c7fec
    mov ecx, dword ptr [ebp + arg_8]             # 004c7fed
    movsx edx, word ptr [ecx + field_2f]         # 004c7ff0
    push edx                                     # 004c7ff4
    lea eax, [ebp - local_30]                    # 004c7ff5
    push eax                                     # 004c7ff8
    mov ecx, dword ptr [ebp - local_38]          # 004c7ff9
    call FUN_004c880f                            # 004c7ffc
    mov dword ptr [ebp - local_1c], 0x0          # 004c8001
    jmp.d8 L_004c8013                            # 004c8008
L_004c800a:
    # block 0x004c800a: entered by jmp at 0x004c8066, 3 instruction(s), falls into the block at 0x004c8013
    mov ecx, dword ptr [ebp - local_1c]          # 004c800a
    add ecx, 0x1                                 # 004c800d
    mov dword ptr [ebp - local_1c], ecx          # 004c8010
L_004c8013:
    # block 0x004c8013: entered by jmp at 0x004c8008, 4 instruction(s), ends with jge to 0x004c8068 (forward)
    mov edx, dword ptr [ebp - local_24]          # 004c8013
    sub edx, 0x1                                 # 004c8016
    cmp dword ptr [ebp - local_1c], edx          # 004c8019
    jge.d8 L_004c8068                            # 004c801c
    # block 0x004c801e: entered by fall-through of jge at 0x004c801c, 7 instruction(s), ends with jle to 0x004c8045 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004c801e
    mov dword ptr [ebp - local_c], eax           # 004c8021
    mov ecx, dword ptr [ebp - local_2c]          # 004c8024
    add ecx, dword ptr [ebp - local_10]          # 004c8027
    mov dword ptr [ebp - local_2c], ecx          # 004c802a
    cmp dword ptr [ebp - local_2c], 0x0          # 004c802d
    jle.d8 L_004c8045                            # 004c8031
    # block 0x004c8033: entered by fall-through of jle at 0x004c8031, 6 instruction(s), falls into the block at 0x004c8045
    mov edx, dword ptr [ebp - local_c]           # 004c8033
    add edx, 0x1                                 # 004c8036
    mov dword ptr [ebp - local_c], edx           # 004c8039
    mov eax, dword ptr [ebp - local_2c]          # 004c803c
    sub eax, dword ptr [ebp - local_34]          # 004c803f
    mov dword ptr [ebp - local_2c], eax          # 004c8042
L_004c8045:
    # block 0x004c8045: entered by jle at 0x004c8031, 14 instruction(s), calls FUN_004c880f, ends with backward jump to 0x004c800a
    mov cx, word ptr [ebp + arg_1c]              # 004c8045
    push ecx                                     # 004c8049
    mov edx, dword ptr [ebp - local_c]           # 004c804a
    push edx                                     # 004c804d
    mov eax, dword ptr [ebp - local_4]           # 004c804e
    push eax                                     # 004c8051
    mov ecx, dword ptr [ebp + arg_8]             # 004c8052
    movsx edx, word ptr [ecx + field_2f]         # 004c8055
    push edx                                     # 004c8059
    lea eax, [ebp - local_30]                    # 004c805a
    push eax                                     # 004c805d
    mov ecx, dword ptr [ebp - local_38]          # 004c805e
    call FUN_004c880f                            # 004c8061
    jmp.d8 L_004c800a                            # 004c8066
L_004c8068:
    # block 0x004c8068: entered by jge at 0x004c801c, 13 instruction(s), calls FUN_004c880f, falls into the block at 0x004c8089
    mov cx, word ptr [ebp + arg_1c]              # 004c8068
    push ecx                                     # 004c806c
    mov edx, dword ptr [ebp - local_18]          # 004c806d
    push edx                                     # 004c8070
    mov eax, dword ptr [ebp - local_4]           # 004c8071
    push eax                                     # 004c8074
    mov ecx, dword ptr [ebp + arg_8]             # 004c8075
    movsx edx, word ptr [ecx + field_2f]         # 004c8078
    push edx                                     # 004c807c
    lea eax, [ebp - local_30]                    # 004c807d
    push eax                                     # 004c8080
    mov ecx, dword ptr [ebp - local_38]          # 004c8081
    call FUN_004c880f                            # 004c8084
L_004c8089:
    # block 0x004c8089: entered by jmp at 0x004c7dae; jmp at 0x004c7df4; jmp at 0x004c7e43; jmp at 0x004c7f6c, 3 instruction(s), ends with ret 0x18
    {load} mov esp, ebp                          # 004c8089
    pop ebp                                      # 004c808b
    ret 0x18                                     # 004c808c

