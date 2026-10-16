# FUN_0041aeaa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041aeaa
# extent:       0x0041aeaa-0x0041b2e6 (1084 code bytes)
# span:         0x0041aeaa-0x0041b2e6 (code 1084, tables 0, padding 0)
# sha256:       53c8f3f5a96dc4dd62a7fc0666cb06fbdb8a5862d243168a87ee64de03b3b395
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041aeaa
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       13 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_2c, local_30, local_34, local_38, local_3c, local_40 and 1 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0041b925, FUN_0041b992, FUN_0041bbd9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 294 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0041b925, .text + (0x0041b925 - 0x401000)
.set FUN_0041b992, .text + (0x0041b992 - 0x401000)
.set FUN_0041bbd9, .text + (0x0041bbd9 - 0x401000)

.org 0x0041aeaa - 0x401000
.globl FUN_0041aeaa
FUN_0041aeaa:
    # block 0x0041aeaa: entry, 18 instruction(s), calls FUN_0041b925, ends with forward jump to 0x0041af00
    push ebp                                     # 0041aeaa
    {load} mov ebp, esp                          # 0041aeab
    sub esp, 0x44                                # 0041aead
    mov dword ptr [ebp - local_44], ecx          # 0041aeb0
    mov dword ptr [ebp - local_8], 0x0           # 0041aeb3
    mov dword ptr [ebp - local_14], 0x0          # 0041aeba
    mov byte ptr [ebp - local_18], 0x0           # 0041aec1
    mov ecx, dword ptr [ebp - local_44]          # 0041aec5
    call FUN_0041b925                            # 0041aec8
    mov byte ptr [ebp - local_2c], 0x0           # 0041aecd
    mov byte ptr [ebp - local_38], 0x1           # 0041aed1
    movzx ax, byte ptr [ebp - local_38]          # 0041aed5
    mov word ptr [ebp - local_40], ax            # 0041aeda
    mov word ptr [ebp - local_c], 0x0            # 0041aede
    mov word ptr [ebp - local_4], 0xfee          # 0041aee4
    mov cx, word ptr [ebp - local_c]             # 0041aeea
    mov word ptr [ebp - local_30], cx            # 0041aeee
    jmp.d8 L_0041af00                            # 0041aef2
L_0041aef4:
    # block 0x0041aef4: entered by jmp at 0x0041af17, 3 instruction(s), falls into the block at 0x0041af00
    mov dx, word ptr [ebp - local_30]            # 0041aef4
    add dx, 0x1                                  # 0041aef8
    mov word ptr [ebp - local_30], dx            # 0041aefc
L_0041af00:
    # block 0x0041af00: entered by jmp at 0x0041aef2, 4 instruction(s), ends with jge to 0x0041af19 (forward)
    movsx eax, word ptr [ebp - local_30]         # 0041af00
    movsx ecx, word ptr [ebp - local_4]          # 0041af04
    {load} cmp eax, ecx                          # 0041af08
    jge.d8 L_0041af19                            # 0041af0a
    # block 0x0041af0c: entered by fall-through of jge at 0x0041af0a, 3 instruction(s), ends with backward jump to 0x0041aef4
    movsx edx, word ptr [ebp - local_30]         # 0041af0c
    mov byte ptr [edx + 0x56f354], 0x20          # 0041af10
    jmp.d8 L_0041aef4                            # 0041af17
L_0041af19:
    # block 0x0041af19: entered by jge at 0x0041af0a, 2 instruction(s), ends with forward jump to 0x0041af2d
    mov word ptr [ebp - local_3c], 0x0           # 0041af19
    jmp.d8 L_0041af2d                            # 0041af1f
L_0041af21:
    # block 0x0041af21: entered by jmp at 0x0041af69, 3 instruction(s), falls into the block at 0x0041af2d
    mov ax, word ptr [ebp - local_3c]            # 0041af21
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041af25
    mov word ptr [ebp - local_3c], ax            # 0041af29
L_0041af2d:
    # block 0x0041af2d: entered by jmp at 0x0041af1f, 3 instruction(s), ends with jge to 0x0041af6b (forward)
    movsx ecx, word ptr [ebp - local_3c]         # 0041af2d
    cmp ecx, 0x12                                # 0041af31
    jge.d8 L_0041af6b                            # 0041af34
    # block 0x0041af36: entered by fall-through of jge at 0x0041af34, 3 instruction(s), ends with jl to 0x0041af40 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0041af36
    cmp edx, dword ptr [ebp + arg_c]             # 0041af39
    jl.d8 L_0041af40                             # 0041af3c
    # block 0x0041af3e: entered by fall-through of jl at 0x0041af3c, 1 instruction(s), ends with forward jump to 0x0041af6b
    jmp.d8 L_0041af6b                            # 0041af3e
L_0041af40:
    # block 0x0041af40: entered by jl at 0x0041af3c, 12 instruction(s), ends with backward jump to 0x0041af21
    mov eax, dword ptr [ebp + arg_8]             # 0041af40
    add eax, dword ptr [ebp - local_8]           # 0041af43
    movsx cx, byte ptr [eax]                     # 0041af46
    mov word ptr [ebp - local_10], cx            # 0041af4a
    mov edx, dword ptr [ebp - local_8]           # 0041af4e
    add edx, 0x1                                 # 0041af51
    mov dword ptr [ebp - local_8], edx           # 0041af54
    movsx eax, word ptr [ebp - local_4]          # 0041af57
    movsx ecx, word ptr [ebp - local_3c]         # 0041af5b
    mov dl, byte ptr [ebp - local_10]            # 0041af5f
    mov byte ptr [eax + ecx + 0x56f354], dl      # 0041af62
    jmp.d8 L_0041af21                            # 0041af69
L_0041af6b:
    # block 0x0041af6b: entered by jge at 0x0041af34; jmp at 0x0041af3e, 4 instruction(s), ends with jne to 0x0041af85 (forward)
    movsx eax, word ptr [ebp - local_3c]         # 0041af6b
    mov dword ptr [0x570368], eax                # 0041af6f
    cmp dword ptr [0x570368], 0x0                # 0041af74
    jne.d8 L_0041af85                            # 0041af7b
    # block 0x0041af7d: entered by fall-through of jne at 0x0041af7b, 2 instruction(s), ends with forward jump to 0x0041b2e0
    {load} xor ax, ax                            # 0041af7d
    jmp.d32 L_0041b2e0                           # 0041af80
L_0041af85:
    # block 0x0041af85: entered by jne at 0x0041af7b, 2 instruction(s), ends with forward jump to 0x0041af99
    mov word ptr [ebp - local_30], 0x1           # 0041af85
    jmp.d8 L_0041af99                            # 0041af8b
L_0041af8d:
    # block 0x0041af8d: entered by jmp at 0x0041afb5, 3 instruction(s), falls into the block at 0x0041af99
    mov cx, word ptr [ebp - local_30]            # 0041af8d
    add cx, 0x1                                  # 0041af91
    mov word ptr [ebp - local_30], cx            # 0041af95
L_0041af99:
    # block 0x0041af99: entered by jmp at 0x0041af8b, 3 instruction(s), ends with jg to 0x0041afb7 (forward)
    movsx edx, word ptr [ebp - local_30]         # 0041af99
    cmp edx, 0x12                                # 0041af9d
    jg.d8 L_0041afb7                             # 0041afa0
    # block 0x0041afa2: entered by fall-through of jg at 0x0041afa0, 7 instruction(s), calls FUN_0041b992, ends with backward jump to 0x0041af8d
    movsx eax, word ptr [ebp - local_4]          # 0041afa2
    movsx ecx, word ptr [ebp - local_30]         # 0041afa6
    {load} sub eax, ecx                          # 0041afaa
    push eax                                     # 0041afac
    mov ecx, dword ptr [ebp - local_44]          # 0041afad
    call FUN_0041b992                            # 0041afb0
    jmp.d8 L_0041af8d                            # 0041afb5
L_0041afb7:
    # block 0x0041afb7: entered by jg at 0x0041afa0, 4 instruction(s), calls FUN_0041b992, falls into the block at 0x0041afc4
    movsx edx, word ptr [ebp - local_4]          # 0041afb7
    push edx                                     # 0041afbb
    mov ecx, dword ptr [ebp - local_44]          # 0041afbc
    call FUN_0041b992                            # 0041afbf
L_0041afc4:
    # block 0x0041afc4: entered by jg at 0x0041b259, 4 instruction(s), ends with jle to 0x0041afde (forward)
    movsx eax, word ptr [0x56f34e]               # 0041afc4
    movsx ecx, word ptr [ebp - local_3c]         # 0041afcb
    {load} cmp eax, ecx                          # 0041afcf
    jle.d8 L_0041afde                            # 0041afd1
    # block 0x0041afd3: entered by fall-through of jle at 0x0041afd1, 2 instruction(s), falls into the block at 0x0041afde
    mov dx, word ptr [ebp - local_3c]            # 0041afd3
    mov word ptr [0x56f34e], dx                  # 0041afd7
L_0041afde:
    # block 0x0041afde: entered by jle at 0x0041afd1, 3 instruction(s), ends with jg to 0x0041b01c (forward)
    movsx eax, word ptr [0x56f34e]               # 0041afde
    cmp eax, 0x2                                 # 0041afe5
    jg.d8 L_0041b01c                             # 0041afe8
    # block 0x0041afea: entered by fall-through of jg at 0x0041afe8, 12 instruction(s), ends with forward jump to 0x0041b065
    mov word ptr [0x56f34e], 0x1                 # 0041afea
    mov cl, byte ptr [ebp - local_2c]            # 0041aff3
    or cl, byte ptr [ebp - local_38]             # 0041aff6
    mov byte ptr [ebp - local_2c], cl            # 0041aff9
    movsx edx, word ptr [ebp - local_4]          # 0041affc
    movsx eax, word ptr [ebp - local_40]         # 0041b000
    mov cl, byte ptr [edx + 0x56f354]            # 0041b004
    mov byte ptr [ebp + eax - local_2c], cl      # 0041b00a
    mov dx, word ptr [ebp - local_40]            # 0041b00e
    add dx, 0x1                                  # 0041b012
    mov word ptr [ebp - local_40], dx            # 0041b016
    jmp.d8 L_0041b065                            # 0041b01a
L_0041b01c:
    # block 0x0041b01c: entered by jg at 0x0041afe8, 17 instruction(s), falls into the block at 0x0041b065
    movsx eax, word ptr [ebp - local_40]         # 0041b01c
    mov cl, byte ptr [0x56f350]                  # 0041b020
    mov byte ptr [ebp + eax - local_2c], cl      # 0041b026
    mov dx, word ptr [ebp - local_40]            # 0041b02a
    add dx, 0x1                                  # 0041b02e
    mov word ptr [ebp - local_40], dx            # 0041b032
    movsx eax, word ptr [0x56f350]               # 0041b036
    sar eax, 0x4                                 # 0041b03d
    and eax, 0xf0                                # 0041b040
    movsx ecx, word ptr [0x56f34e]               # 0041b045
    sub ecx, 0x3                                 # 0041b04c
    {load} or eax, ecx                           # 0041b04f
    movsx edx, word ptr [ebp - local_40]         # 0041b051
    mov byte ptr [ebp + edx - local_2c], al      # 0041b055
    mov ax, word ptr [ebp - local_40]            # 0041b059
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041b05d
    mov word ptr [ebp - local_40], ax            # 0041b061
L_0041b065:
    # block 0x0041b065: entered by jmp at 0x0041b01a, 7 instruction(s), ends with jne to 0x0041b107 (forward)
    mov cl, byte ptr [ebp - local_38]            # 0041b065
    shl cl                                       # 0041b068
    mov byte ptr [ebp - local_38], cl            # 0041b06a
    mov edx, dword ptr [ebp - local_38]          # 0041b06d
    and edx, 0xff                                # 0041b070
    test edx, edx                                # 0041b076
    jne.d32 L_0041b107                           # 0041b078
    # block 0x0041b07e: entered by fall-through of jne at 0x0041b078, 2 instruction(s), ends with forward jump to 0x0041b092
    mov word ptr [ebp - local_30], 0x0           # 0041b07e
    jmp.d8 L_0041b092                            # 0041b084
L_0041b086:
    # block 0x0041b086: entered by jmp at 0x0041b0e2, 3 instruction(s), falls into the block at 0x0041b092
    mov ax, word ptr [ebp - local_30]            # 0041b086
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041b08a
    mov word ptr [ebp - local_30], ax            # 0041b08e
L_0041b092:
    # block 0x0041b092: entered by jmp at 0x0041b084, 4 instruction(s), ends with jge to 0x0041b0e4 (forward)
    movsx ecx, word ptr [ebp - local_30]         # 0041b092
    movsx edx, word ptr [ebp - local_40]         # 0041b096
    {load} cmp ecx, edx                          # 0041b09a
    jge.d8 L_0041b0e4                            # 0041b09c
    # block 0x0041b09e: entered by fall-through of jge at 0x0041b09c, 11 instruction(s), ends with jl to 0x0041b0c9 (forward)
    movsx eax, word ptr [ebp - local_30]         # 0041b09e
    mov cl, byte ptr [ebp + eax - local_2c]      # 0041b0a2
    add cl, byte ptr [ebp - local_18]            # 0041b0a6
    movsx edx, word ptr [ebp - local_30]         # 0041b0a9
    mov byte ptr [ebp + edx - local_2c], cl      # 0041b0ad
    mov al, byte ptr [ebp - local_18]            # 0041b0b1
    add al, 0x1                                  # 0041b0b4
    mov byte ptr [ebp - local_18], al            # 0041b0b6
    mov ecx, dword ptr [ebp - local_14]          # 0041b0b9
    cmp ecx, dword ptr [ebp + arg_14]            # 0041b0bc
    jl.d8 L_0041b0c9                             # 0041b0bf
    # block 0x0041b0c1: entered by fall-through of jl at 0x0041b0bf, 2 instruction(s), ends with forward jump to 0x0041b2e0
    {load} xor ax, ax                            # 0041b0c1
    jmp.d32 L_0041b2e0                           # 0041b0c4
L_0041b0c9:
    # block 0x0041b0c9: entered by jl at 0x0041b0bf, 9 instruction(s), ends with backward jump to 0x0041b086
    movsx edx, word ptr [ebp - local_30]         # 0041b0c9
    mov eax, dword ptr [ebp + arg_10]            # 0041b0cd
    add eax, dword ptr [ebp - local_14]          # 0041b0d0
    mov cl, byte ptr [ebp + edx - local_2c]      # 0041b0d3
    mov byte ptr [eax], cl                       # 0041b0d7
    mov edx, dword ptr [ebp - local_14]          # 0041b0d9
    add edx, 0x1                                 # 0041b0dc
    mov dword ptr [ebp - local_14], edx          # 0041b0df
    jmp.d8 L_0041b086                            # 0041b0e2
L_0041b0e4:
    # block 0x0041b0e4: entered by jge at 0x0041b09c, 8 instruction(s), falls into the block at 0x0041b107
    movsx eax, word ptr [ebp - local_40]         # 0041b0e4
    mov ecx, dword ptr [0x57036c]                # 0041b0e8
    {load} add ecx, eax                          # 0041b0ee
    mov dword ptr [0x57036c], ecx                # 0041b0f0
    mov byte ptr [ebp - local_2c], 0x0           # 0041b0f6
    mov byte ptr [ebp - local_38], 0x1           # 0041b0fa
    movzx dx, byte ptr [ebp - local_38]          # 0041b0fe
    mov word ptr [ebp - local_40], dx            # 0041b103
L_0041b107:
    # block 0x0041b107: entered by jne at 0x0041b078, 4 instruction(s), ends with forward jump to 0x0041b125
    mov ax, word ptr [0x56f34e]                  # 0041b107
    mov word ptr [ebp - local_34], ax            # 0041b10d
    mov word ptr [ebp - local_30], 0x0           # 0041b111
    jmp.d8 L_0041b125                            # 0041b117
L_0041b119:
    # block 0x0041b119: entered by jmp at 0x0041b1b4, 3 instruction(s), falls into the block at 0x0041b125
    mov cx, word ptr [ebp - local_30]            # 0041b119
    add cx, 0x1                                  # 0041b11d
    mov word ptr [ebp - local_30], cx            # 0041b121
L_0041b125:
    # block 0x0041b125: entered by jmp at 0x0041b117, 4 instruction(s), ends with jge to 0x0041b1b9 (forward)
    movsx edx, word ptr [ebp - local_30]         # 0041b125
    movsx eax, word ptr [ebp - local_34]         # 0041b129
    {load} cmp edx, eax                          # 0041b12d
    jge.d32 L_0041b1b9                           # 0041b12f
    # block 0x0041b135: entered by fall-through of jge at 0x0041b12f, 3 instruction(s), ends with jl to 0x0041b13f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0041b135
    cmp ecx, dword ptr [ebp + arg_c]             # 0041b138
    jl.d8 L_0041b13f                             # 0041b13b
    # block 0x0041b13d: entered by fall-through of jl at 0x0041b13b, 1 instruction(s), ends with forward jump to 0x0041b1b9
    jmp.d8 L_0041b1b9                            # 0041b13d
L_0041b13f:
    # block 0x0041b13f: entered by jl at 0x0041b13b, 17 instruction(s), calls FUN_0041bbd9, ends with jge to 0x0041b186 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0041b13f
    add edx, dword ptr [ebp - local_8]           # 0041b142
    movsx ax, byte ptr [edx]                     # 0041b145
    mov word ptr [ebp - local_10], ax            # 0041b149
    mov ecx, dword ptr [ebp - local_8]           # 0041b14d
    add ecx, 0x1                                 # 0041b150
    mov dword ptr [ebp - local_8], ecx           # 0041b153
    movsx edx, word ptr [ebp - local_c]          # 0041b156
    push edx                                     # 0041b15a
    mov ecx, dword ptr [ebp - local_44]          # 0041b15b
    call FUN_0041bbd9                            # 0041b15e
    movsx eax, word ptr [ebp - local_c]          # 0041b163
    mov cl, byte ptr [ebp - local_10]            # 0041b167
    mov byte ptr [eax + 0x56f354], cl            # 0041b16a
    movsx edx, word ptr [ebp - local_c]          # 0041b170
    cmp edx, 0x11                                # 0041b174
    jge.d8 L_0041b186                            # 0041b177
    # block 0x0041b179: entered by fall-through of jge at 0x0041b177, 3 instruction(s), falls into the block at 0x0041b186
    movsx eax, word ptr [ebp - local_c]          # 0041b179
    mov cl, byte ptr [ebp - local_10]            # 0041b17d
    mov byte ptr [eax + 0x570354], cl            # 0041b180
L_0041b186:
    # block 0x0041b186: entered by jge at 0x0041b177, 13 instruction(s), calls FUN_0041b992, ends with backward jump to 0x0041b119
    movsx edx, word ptr [ebp - local_c]          # 0041b186
    add edx, 0x1                                 # 0041b18a
    and edx, 0xfff                               # 0041b18d
    mov word ptr [ebp - local_c], dx             # 0041b193
    movsx eax, word ptr [ebp - local_4]          # 0041b197
    add eax, 0x1                                 # 0041b19b
    and eax, 0xfff                               # 0041b19e
    mov word ptr [ebp - local_4], ax             # 0041b1a3
    movsx ecx, word ptr [ebp - local_4]          # 0041b1a7
    push ecx                                     # 0041b1ab
    mov ecx, dword ptr [ebp - local_44]          # 0041b1ac
    call FUN_0041b992                            # 0041b1af
    jmp.d32 L_0041b119                           # 0041b1b4
L_0041b1b9:
    # block 0x0041b1b9: entered by jge at 0x0041b12f; jmp at 0x0041b13d, 7 instruction(s), ends with jbe to 0x0041b1e9 (forward)
    movsx edx, word ptr [ebp - local_30]         # 0041b1b9
    mov eax, dword ptr [0x570368]                # 0041b1bd
    {load} add eax, edx                          # 0041b1c2
    mov dword ptr [0x570368], eax                # 0041b1c4
    mov ecx, dword ptr [0x570368]                # 0041b1c9
    cmp ecx, dword ptr [0x570370]                # 0041b1cf
    jbe.d8 L_0041b1e9                            # 0041b1d5
    # block 0x0041b1d7: entered by fall-through of jbe at 0x0041b1d5, 3 instruction(s), falls into the block at 0x0041b1e9
    mov edx, dword ptr [0x570370]                # 0041b1d7
    add edx, 0x400                               # 0041b1dd
    mov dword ptr [0x570370], edx                # 0041b1e3
L_0041b1e9:
    # block 0x0041b1e9: entered by jbe at 0x0041b1d5; jmp at 0x0041b251, 7 instruction(s), ends with jge to 0x0041b253 (forward)
    movsx eax, word ptr [ebp - local_30]         # 0041b1e9
    movsx ecx, word ptr [ebp - local_34]         # 0041b1ed
    mov dx, word ptr [ebp - local_30]            # 0041b1f1
    add dx, 0x1                                  # 0041b1f5
    mov word ptr [ebp - local_30], dx            # 0041b1f9
    {load} cmp eax, ecx                          # 0041b1fd
    jge.d8 L_0041b253                            # 0041b1ff
    # block 0x0041b201: entered by fall-through of jge at 0x0041b1ff, 18 instruction(s), calls FUN_0041bbd9, ends with je to 0x0041b251 (forward)
    movsx eax, word ptr [ebp - local_c]          # 0041b201
    push eax                                     # 0041b205
    mov ecx, dword ptr [ebp - local_44]          # 0041b206
    call FUN_0041bbd9                            # 0041b209
    movsx ecx, word ptr [ebp - local_c]          # 0041b20e
    add ecx, 0x1                                 # 0041b212
    and ecx, 0xfff                               # 0041b215
    mov word ptr [ebp - local_c], cx             # 0041b21b
    movsx edx, word ptr [ebp - local_4]          # 0041b21f
    add edx, 0x1                                 # 0041b223
    and edx, 0xfff                               # 0041b226
    mov word ptr [ebp - local_4], dx             # 0041b22c
    mov ax, word ptr [ebp - local_3c]            # 0041b230
    .insn 0x66, 0x2d, 0x0001{:u16}               # 0041b234
    mov word ptr [ebp - local_3c], ax            # 0041b238
    movsx ecx, word ptr [ebp - local_3c]         # 0041b23c
    test ecx, ecx                                # 0041b240
    je.d8 L_0041b251                             # 0041b242
    # block 0x0041b244: entered by fall-through of je at 0x0041b242, 4 instruction(s), calls FUN_0041b992, falls into the block at 0x0041b251
    movsx edx, word ptr [ebp - local_4]          # 0041b244
    push edx                                     # 0041b248
    mov ecx, dword ptr [ebp - local_44]          # 0041b249
    call FUN_0041b992                            # 0041b24c
L_0041b251:
    # block 0x0041b251: entered by je at 0x0041b242, 1 instruction(s), ends with backward jump to 0x0041b1e9
    jmp.d8 L_0041b1e9                            # 0041b251
L_0041b253:
    # block 0x0041b253: entered by jge at 0x0041b1ff, 3 instruction(s), ends with jg to 0x0041afc4 (backward)
    movsx eax, word ptr [ebp - local_3c]         # 0041b253
    test eax, eax                                # 0041b257
    jg.d32 L_0041afc4                            # 0041b259
    # block 0x0041b25f: entered by fall-through of jg at 0x0041b259, 3 instruction(s), ends with jle to 0x0041b2dc (forward)
    movsx ecx, word ptr [ebp - local_40]         # 0041b25f
    cmp ecx, 0x1                                 # 0041b263
    jle.d8 L_0041b2dc                            # 0041b266
    # block 0x0041b268: entered by fall-through of jle at 0x0041b266, 2 instruction(s), ends with forward jump to 0x0041b27c
    mov word ptr [ebp - local_30], 0x0           # 0041b268
    jmp.d8 L_0041b27c                            # 0041b26e
L_0041b270:
    # block 0x0041b270: entered by jmp at 0x0041b2ca, 3 instruction(s), falls into the block at 0x0041b27c
    mov dx, word ptr [ebp - local_30]            # 0041b270
    add dx, 0x1                                  # 0041b274
    mov word ptr [ebp - local_30], dx            # 0041b278
L_0041b27c:
    # block 0x0041b27c: entered by jmp at 0x0041b26e, 4 instruction(s), ends with jge to 0x0041b2cc (forward)
    movsx eax, word ptr [ebp - local_30]         # 0041b27c
    movsx ecx, word ptr [ebp - local_40]         # 0041b280
    {load} cmp eax, ecx                          # 0041b284
    jge.d8 L_0041b2cc                            # 0041b286
    # block 0x0041b288: entered by fall-through of jge at 0x0041b286, 11 instruction(s), ends with jl to 0x0041b2b1 (forward)
    movsx edx, word ptr [ebp - local_30]         # 0041b288
    mov al, byte ptr [ebp + edx - local_2c]      # 0041b28c
    add al, byte ptr [ebp - local_18]            # 0041b290
    movsx ecx, word ptr [ebp - local_30]         # 0041b293
    mov byte ptr [ebp + ecx - local_2c], al      # 0041b297
    mov dl, byte ptr [ebp - local_18]            # 0041b29b
    add dl, 0x1                                  # 0041b29e
    mov byte ptr [ebp - local_18], dl            # 0041b2a1
    mov eax, dword ptr [ebp - local_14]          # 0041b2a4
    cmp eax, dword ptr [ebp + arg_14]            # 0041b2a7
    jl.d8 L_0041b2b1                             # 0041b2aa
    # block 0x0041b2ac: entered by fall-through of jl at 0x0041b2aa, 2 instruction(s), ends with forward jump to 0x0041b2e0
    {load} xor ax, ax                            # 0041b2ac
    jmp.d8 L_0041b2e0                            # 0041b2af
L_0041b2b1:
    # block 0x0041b2b1: entered by jl at 0x0041b2aa, 9 instruction(s), ends with backward jump to 0x0041b270
    movsx ecx, word ptr [ebp - local_30]         # 0041b2b1
    mov edx, dword ptr [ebp + arg_10]            # 0041b2b5
    add edx, dword ptr [ebp - local_14]          # 0041b2b8
    mov al, byte ptr [ebp + ecx - local_2c]      # 0041b2bb
    mov byte ptr [edx], al                       # 0041b2bf
    mov ecx, dword ptr [ebp - local_14]          # 0041b2c1
    add ecx, 0x1                                 # 0041b2c4
    mov dword ptr [ebp - local_14], ecx          # 0041b2c7
    jmp.d8 L_0041b270                            # 0041b2ca
L_0041b2cc:
    # block 0x0041b2cc: entered by jge at 0x0041b286, 4 instruction(s), falls into the block at 0x0041b2dc
    movsx edx, word ptr [ebp - local_40]         # 0041b2cc
    mov eax, dword ptr [0x57036c]                # 0041b2d0
    {load} add eax, edx                          # 0041b2d5
    mov dword ptr [0x57036c], eax                # 0041b2d7
L_0041b2dc:
    # block 0x0041b2dc: entered by jle at 0x0041b266, 1 instruction(s), falls into the block at 0x0041b2e0
    mov ax, 0x1                                  # 0041b2dc
L_0041b2e0:
    # block 0x0041b2e0: entered by jmp at 0x0041af80; jmp at 0x0041b0c4; jmp at 0x0041b2af, 3 instruction(s), ends with ret 0x10
    {load} mov esp, ebp                          # 0041b2e0
    pop ebp                                      # 0041b2e2
    ret 0x10                                     # 0041b2e3

