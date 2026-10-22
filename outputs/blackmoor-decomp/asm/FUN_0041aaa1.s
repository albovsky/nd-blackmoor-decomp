# FUN_0041aaa1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041aaa1
# extent:       0x0041aaa1-0x0041aeaa (1033 code bytes)
# span:         0x0041aaa1-0x0041aeaa (code 1033, tables 0, padding 0)
# sha256:       5eed8222b5e37e7a3d4dfcd45d9f613c9346105997420a8d108f66aa5e3ad10c
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41aaa1_lifted
# naming:       native port src/original_methods_fl40.c:m41aaa1_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 4 seeds; oracle: 281/281 instructions executed, 36/36 conditional-jump directions taken, callees as recording stubs.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_28, local_2c, local_30, local_34, local_38, local_3c, local_40
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0041b925, FUN_0041b992, FUN_0050d4f5, FUN_0041bbd9
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41aaa1_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 281 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0041b925, .text + (0x0041b925 - 0x401000)
.set FUN_0041b992, .text + (0x0041b992 - 0x401000)
.set FUN_0041bbd9, .text + (0x0041bbd9 - 0x401000)
.set FUN_0050d4f5, .text + (0x0050d4f5 - 0x401000)

.org 0x0041aaa1 - 0x401000
.globl FUN_0041aaa1
FUN_0041aaa1:
    # block 0x0041aaa1: entry, 17 instruction(s), calls FUN_0041b925, ends with forward jump to 0x0041aaf0
    push ebp                                     # 0041aaa1
    {load} mov ebp, esp                          # 0041aaa2
    sub esp, 0x40                                # 0041aaa4
    mov dword ptr [ebp - local_40], ecx          # 0041aaa7
    mov dword ptr [ebp - local_8], 0x0           # 0041aaaa
    mov byte ptr [ebp - local_14], 0x0           # 0041aab1
    mov ecx, dword ptr [ebp - local_40]          # 0041aab5
    call FUN_0041b925                            # 0041aab8
    mov byte ptr [ebp - local_28], 0x0           # 0041aabd
    mov byte ptr [ebp - local_34], 0x1           # 0041aac1
    movzx ax, byte ptr [ebp - local_34]          # 0041aac5
    mov word ptr [ebp - local_3c], ax            # 0041aaca
    mov word ptr [ebp - local_c], 0x0            # 0041aace
    mov word ptr [ebp - local_4], 0xfee          # 0041aad4
    mov cx, word ptr [ebp - local_c]             # 0041aada
    mov word ptr [ebp - local_2c], cx            # 0041aade
    jmp.d8 L_0041aaf0                            # 0041aae2
L_0041aae4:
    # block 0x0041aae4: entered by jmp at 0x0041ab07, 3 instruction(s), falls into the block at 0x0041aaf0
    mov dx, word ptr [ebp - local_2c]            # 0041aae4
    add dx, 0x1                                  # 0041aae8
    mov word ptr [ebp - local_2c], dx            # 0041aaec
L_0041aaf0:
    # block 0x0041aaf0: entered by jmp at 0x0041aae2, 4 instruction(s), ends with jge to 0x0041ab09 (forward)
    movsx eax, word ptr [ebp - local_2c]         # 0041aaf0
    movsx ecx, word ptr [ebp - local_4]          # 0041aaf4
    {load} cmp eax, ecx                          # 0041aaf8
    jge.d8 L_0041ab09                            # 0041aafa
    # block 0x0041aafc: entered by fall-through of jge at 0x0041aafa, 3 instruction(s), ends with backward jump to 0x0041aae4
    movsx edx, word ptr [ebp - local_2c]         # 0041aafc
    mov byte ptr [edx + 0x56f354], 0x20          # 0041ab00
    jmp.d8 L_0041aae4                            # 0041ab07
L_0041ab09:
    # block 0x0041ab09: entered by jge at 0x0041aafa, 2 instruction(s), ends with forward jump to 0x0041ab1d
    mov word ptr [ebp - local_38], 0x0           # 0041ab09
    jmp.d8 L_0041ab1d                            # 0041ab0f
L_0041ab11:
    # block 0x0041ab11: entered by jmp at 0x0041ab59, 3 instruction(s), falls into the block at 0x0041ab1d
    mov ax, word ptr [ebp - local_38]            # 0041ab11
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041ab15
    mov word ptr [ebp - local_38], ax            # 0041ab19
L_0041ab1d:
    # block 0x0041ab1d: entered by jmp at 0x0041ab0f, 3 instruction(s), ends with jge to 0x0041ab5b (forward)
    movsx ecx, word ptr [ebp - local_38]         # 0041ab1d
    cmp ecx, 0x12                                # 0041ab21
    jge.d8 L_0041ab5b                            # 0041ab24
    # block 0x0041ab26: entered by fall-through of jge at 0x0041ab24, 3 instruction(s), ends with jl to 0x0041ab30 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0041ab26
    cmp edx, dword ptr [ebp + arg_c]             # 0041ab29
    jl.d8 L_0041ab30                             # 0041ab2c
    # block 0x0041ab2e: entered by fall-through of jl at 0x0041ab2c, 1 instruction(s), ends with forward jump to 0x0041ab5b
    jmp.d8 L_0041ab5b                            # 0041ab2e
L_0041ab30:
    # block 0x0041ab30: entered by jl at 0x0041ab2c, 12 instruction(s), ends with backward jump to 0x0041ab11
    mov eax, dword ptr [ebp + arg_8]             # 0041ab30
    add eax, dword ptr [ebp - local_8]           # 0041ab33
    movsx cx, byte ptr [eax]                     # 0041ab36
    mov word ptr [ebp - local_10], cx            # 0041ab3a
    mov edx, dword ptr [ebp - local_8]           # 0041ab3e
    add edx, 0x1                                 # 0041ab41
    mov dword ptr [ebp - local_8], edx           # 0041ab44
    movsx eax, word ptr [ebp - local_4]          # 0041ab47
    movsx ecx, word ptr [ebp - local_38]         # 0041ab4b
    mov dl, byte ptr [ebp - local_10]            # 0041ab4f
    mov byte ptr [eax + ecx + 0x56f354], dl      # 0041ab52
    jmp.d8 L_0041ab11                            # 0041ab59
L_0041ab5b:
    # block 0x0041ab5b: entered by jge at 0x0041ab24; jmp at 0x0041ab2e, 4 instruction(s), ends with jne to 0x0041ab72 (forward)
    movsx eax, word ptr [ebp - local_38]         # 0041ab5b
    mov dword ptr [0x570368], eax                # 0041ab5f
    cmp dword ptr [0x570368], 0x0                # 0041ab64
    jne.d8 L_0041ab72                            # 0041ab6b
    # block 0x0041ab6d: entered by fall-through of jne at 0x0041ab6b, 1 instruction(s), ends with forward jump to 0x0041aea4
    jmp.d32 L_0041aea4                           # 0041ab6d
L_0041ab72:
    # block 0x0041ab72: entered by jne at 0x0041ab6b, 2 instruction(s), ends with forward jump to 0x0041ab86
    mov word ptr [ebp - local_2c], 0x1           # 0041ab72
    jmp.d8 L_0041ab86                            # 0041ab78
L_0041ab7a:
    # block 0x0041ab7a: entered by jmp at 0x0041aba2, 3 instruction(s), falls into the block at 0x0041ab86
    mov cx, word ptr [ebp - local_2c]            # 0041ab7a
    add cx, 0x1                                  # 0041ab7e
    mov word ptr [ebp - local_2c], cx            # 0041ab82
L_0041ab86:
    # block 0x0041ab86: entered by jmp at 0x0041ab78, 3 instruction(s), ends with jg to 0x0041aba4 (forward)
    movsx edx, word ptr [ebp - local_2c]         # 0041ab86
    cmp edx, 0x12                                # 0041ab8a
    jg.d8 L_0041aba4                             # 0041ab8d
    # block 0x0041ab8f: entered by fall-through of jg at 0x0041ab8d, 7 instruction(s), calls FUN_0041b992, ends with backward jump to 0x0041ab7a
    movsx eax, word ptr [ebp - local_4]          # 0041ab8f
    movsx ecx, word ptr [ebp - local_2c]         # 0041ab93
    {load} sub eax, ecx                          # 0041ab97
    push eax                                     # 0041ab99
    mov ecx, dword ptr [ebp - local_40]          # 0041ab9a
    call FUN_0041b992                            # 0041ab9d
    jmp.d8 L_0041ab7a                            # 0041aba2
L_0041aba4:
    # block 0x0041aba4: entered by jg at 0x0041ab8d, 4 instruction(s), calls FUN_0041b992, falls into the block at 0x0041abb1
    movsx edx, word ptr [ebp - local_4]          # 0041aba4
    push edx                                     # 0041aba8
    mov ecx, dword ptr [ebp - local_40]          # 0041aba9
    call FUN_0041b992                            # 0041abac
L_0041abb1:
    # block 0x0041abb1: entered by jg at 0x0041ae2f, 4 instruction(s), ends with jle to 0x0041abcb (forward)
    movsx eax, word ptr [0x56f34e]               # 0041abb1
    movsx ecx, word ptr [ebp - local_38]         # 0041abb8
    {load} cmp eax, ecx                          # 0041abbc
    jle.d8 L_0041abcb                            # 0041abbe
    # block 0x0041abc0: entered by fall-through of jle at 0x0041abbe, 2 instruction(s), falls into the block at 0x0041abcb
    mov dx, word ptr [ebp - local_38]            # 0041abc0
    mov word ptr [0x56f34e], dx                  # 0041abc4
L_0041abcb:
    # block 0x0041abcb: entered by jle at 0x0041abbe, 3 instruction(s), ends with jg to 0x0041ac09 (forward)
    movsx eax, word ptr [0x56f34e]               # 0041abcb
    cmp eax, 0x2                                 # 0041abd2
    jg.d8 L_0041ac09                             # 0041abd5
    # block 0x0041abd7: entered by fall-through of jg at 0x0041abd5, 12 instruction(s), ends with forward jump to 0x0041ac52
    mov word ptr [0x56f34e], 0x1                 # 0041abd7
    mov cl, byte ptr [ebp - local_28]            # 0041abe0
    or cl, byte ptr [ebp - local_34]             # 0041abe3
    mov byte ptr [ebp - local_28], cl            # 0041abe6
    movsx edx, word ptr [ebp - local_4]          # 0041abe9
    movsx eax, word ptr [ebp - local_3c]         # 0041abed
    mov cl, byte ptr [edx + 0x56f354]            # 0041abf1
    mov byte ptr [ebp + eax - local_28], cl      # 0041abf7
    mov dx, word ptr [ebp - local_3c]            # 0041abfb
    add dx, 0x1                                  # 0041abff
    mov word ptr [ebp - local_3c], dx            # 0041ac03
    jmp.d8 L_0041ac52                            # 0041ac07
L_0041ac09:
    # block 0x0041ac09: entered by jg at 0x0041abd5, 17 instruction(s), falls into the block at 0x0041ac52
    movsx eax, word ptr [ebp - local_3c]         # 0041ac09
    mov cl, byte ptr [0x56f350]                  # 0041ac0d
    mov byte ptr [ebp + eax - local_28], cl      # 0041ac13
    mov dx, word ptr [ebp - local_3c]            # 0041ac17
    add dx, 0x1                                  # 0041ac1b
    mov word ptr [ebp - local_3c], dx            # 0041ac1f
    movsx eax, word ptr [0x56f350]               # 0041ac23
    sar eax, 0x4                                 # 0041ac2a
    and eax, 0xf0                                # 0041ac2d
    movsx ecx, word ptr [0x56f34e]               # 0041ac32
    sub ecx, 0x3                                 # 0041ac39
    {load} or eax, ecx                           # 0041ac3c
    movsx edx, word ptr [ebp - local_3c]         # 0041ac3e
    mov byte ptr [ebp + edx - local_28], al      # 0041ac42
    mov ax, word ptr [ebp - local_3c]            # 0041ac46
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041ac4a
    mov word ptr [ebp - local_3c], ax            # 0041ac4e
L_0041ac52:
    # block 0x0041ac52: entered by jmp at 0x0041ac07, 7 instruction(s), ends with jne to 0x0041acde (forward)
    mov cl, byte ptr [ebp - local_34]            # 0041ac52
    shl cl                                       # 0041ac55
    mov byte ptr [ebp - local_34], cl            # 0041ac57
    mov edx, dword ptr [ebp - local_34]          # 0041ac5a
    and edx, 0xff                                # 0041ac5d
    test edx, edx                                # 0041ac63
    jne.d8 L_0041acde                            # 0041ac65
    # block 0x0041ac67: entered by fall-through of jne at 0x0041ac65, 2 instruction(s), ends with forward jump to 0x0041ac7b
    mov word ptr [ebp - local_2c], 0x0           # 0041ac67
    jmp.d8 L_0041ac7b                            # 0041ac6d
L_0041ac6f:
    # block 0x0041ac6f: entered by jmp at 0x0041acb9, 3 instruction(s), falls into the block at 0x0041ac7b
    mov ax, word ptr [ebp - local_2c]            # 0041ac6f
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041ac73
    mov word ptr [ebp - local_2c], ax            # 0041ac77
L_0041ac7b:
    # block 0x0041ac7b: entered by jmp at 0x0041ac6d, 4 instruction(s), ends with jge to 0x0041acbb (forward)
    movsx ecx, word ptr [ebp - local_2c]         # 0041ac7b
    movsx edx, word ptr [ebp - local_3c]         # 0041ac7f
    {load} cmp ecx, edx                          # 0041ac83
    jge.d8 L_0041acbb                            # 0041ac85
    # block 0x0041ac87: entered by fall-through of jge at 0x0041ac85, 17 instruction(s), calls FUN_0050d4f5, ends with backward jump to 0x0041ac6f
    movsx eax, word ptr [ebp - local_2c]         # 0041ac87
    mov cl, byte ptr [ebp + eax - local_28]      # 0041ac8b
    add cl, byte ptr [ebp - local_14]            # 0041ac8f
    movsx edx, word ptr [ebp - local_2c]         # 0041ac92
    mov byte ptr [ebp + edx - local_28], cl      # 0041ac96
    mov al, byte ptr [ebp - local_14]            # 0041ac9a
    add al, 0x1                                  # 0041ac9d
    mov byte ptr [ebp - local_14], al            # 0041ac9f
    mov ecx, dword ptr [ebp + arg_10]            # 0041aca2
    push ecx                                     # 0041aca5
    movsx edx, word ptr [ebp - local_2c]         # 0041aca6
    {load} xor eax, eax                          # 0041acaa
    mov al, byte ptr [ebp + edx - local_28]      # 0041acac
    push eax                                     # 0041acb0
    call FUN_0050d4f5                            # 0041acb1
    add esp, 0x8                                 # 0041acb6
    jmp.d8 L_0041ac6f                            # 0041acb9
L_0041acbb:
    # block 0x0041acbb: entered by jge at 0x0041ac85, 8 instruction(s), falls into the block at 0x0041acde
    movsx ecx, word ptr [ebp - local_3c]         # 0041acbb
    mov edx, dword ptr [0x57036c]                # 0041acbf
    {load} add edx, ecx                          # 0041acc5
    mov dword ptr [0x57036c], edx                # 0041acc7
    mov byte ptr [ebp - local_28], 0x0           # 0041accd
    mov byte ptr [ebp - local_34], 0x1           # 0041acd1
    movzx ax, byte ptr [ebp - local_34]          # 0041acd5
    mov word ptr [ebp - local_3c], ax            # 0041acda
L_0041acde:
    # block 0x0041acde: entered by jne at 0x0041ac65, 4 instruction(s), ends with forward jump to 0x0041acfd
    mov cx, word ptr [0x56f34e]                  # 0041acde
    mov word ptr [ebp - local_30], cx            # 0041ace5
    mov word ptr [ebp - local_2c], 0x0           # 0041ace9
    jmp.d8 L_0041acfd                            # 0041acef
L_0041acf1:
    # block 0x0041acf1: entered by jmp at 0x0041ad8c, 3 instruction(s), falls into the block at 0x0041acfd
    mov dx, word ptr [ebp - local_2c]            # 0041acf1
    add dx, 0x1                                  # 0041acf5
    mov word ptr [ebp - local_2c], dx            # 0041acf9
L_0041acfd:
    # block 0x0041acfd: entered by jmp at 0x0041acef, 4 instruction(s), ends with jge to 0x0041ad91 (forward)
    movsx eax, word ptr [ebp - local_2c]         # 0041acfd
    movsx ecx, word ptr [ebp - local_30]         # 0041ad01
    {load} cmp eax, ecx                          # 0041ad05
    jge.d32 L_0041ad91                           # 0041ad07
    # block 0x0041ad0d: entered by fall-through of jge at 0x0041ad07, 3 instruction(s), ends with jl to 0x0041ad17 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0041ad0d
    cmp edx, dword ptr [ebp + arg_c]             # 0041ad10
    jl.d8 L_0041ad17                             # 0041ad13
    # block 0x0041ad15: entered by fall-through of jl at 0x0041ad13, 1 instruction(s), ends with forward jump to 0x0041ad91
    jmp.d8 L_0041ad91                            # 0041ad15
L_0041ad17:
    # block 0x0041ad17: entered by jl at 0x0041ad13, 17 instruction(s), calls FUN_0041bbd9, ends with jge to 0x0041ad5e (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0041ad17
    add eax, dword ptr [ebp - local_8]           # 0041ad1a
    movsx cx, byte ptr [eax]                     # 0041ad1d
    mov word ptr [ebp - local_10], cx            # 0041ad21
    mov edx, dword ptr [ebp - local_8]           # 0041ad25
    add edx, 0x1                                 # 0041ad28
    mov dword ptr [ebp - local_8], edx           # 0041ad2b
    movsx eax, word ptr [ebp - local_c]          # 0041ad2e
    push eax                                     # 0041ad32
    mov ecx, dword ptr [ebp - local_40]          # 0041ad33
    call FUN_0041bbd9                            # 0041ad36
    movsx ecx, word ptr [ebp - local_c]          # 0041ad3b
    mov dl, byte ptr [ebp - local_10]            # 0041ad3f
    mov byte ptr [ecx + 0x56f354], dl            # 0041ad42
    movsx eax, word ptr [ebp - local_c]          # 0041ad48
    cmp eax, 0x11                                # 0041ad4c
    jge.d8 L_0041ad5e                            # 0041ad4f
    # block 0x0041ad51: entered by fall-through of jge at 0x0041ad4f, 3 instruction(s), falls into the block at 0x0041ad5e
    movsx ecx, word ptr [ebp - local_c]          # 0041ad51
    mov dl, byte ptr [ebp - local_10]            # 0041ad55
    mov byte ptr [ecx + 0x570354], dl            # 0041ad58
L_0041ad5e:
    # block 0x0041ad5e: entered by jge at 0x0041ad4f, 13 instruction(s), calls FUN_0041b992, ends with backward jump to 0x0041acf1
    movsx eax, word ptr [ebp - local_c]          # 0041ad5e
    add eax, 0x1                                 # 0041ad62
    and eax, 0xfff                               # 0041ad65
    mov word ptr [ebp - local_c], ax             # 0041ad6a
    movsx ecx, word ptr [ebp - local_4]          # 0041ad6e
    add ecx, 0x1                                 # 0041ad72
    and ecx, 0xfff                               # 0041ad75
    mov word ptr [ebp - local_4], cx             # 0041ad7b
    movsx edx, word ptr [ebp - local_4]          # 0041ad7f
    push edx                                     # 0041ad83
    mov ecx, dword ptr [ebp - local_40]          # 0041ad84
    call FUN_0041b992                            # 0041ad87
    jmp.d32 L_0041acf1                           # 0041ad8c
L_0041ad91:
    # block 0x0041ad91: entered by jge at 0x0041ad07; jmp at 0x0041ad15, 7 instruction(s), ends with jbe to 0x0041adc0 (forward)
    movsx eax, word ptr [ebp - local_2c]         # 0041ad91
    mov ecx, dword ptr [0x570368]                # 0041ad95
    {load} add ecx, eax                          # 0041ad9b
    mov dword ptr [0x570368], ecx                # 0041ad9d
    mov edx, dword ptr [0x570368]                # 0041ada3
    cmp edx, dword ptr [0x570370]                # 0041ada9
    jbe.d8 L_0041adc0                            # 0041adaf
    # block 0x0041adb1: entered by fall-through of jbe at 0x0041adaf, 3 instruction(s), falls into the block at 0x0041adc0
    mov eax, dword ptr [0x570370]                # 0041adb1
    add eax, 0x400                               # 0041adb6
    mov dword ptr [0x570370], eax                # 0041adbb
L_0041adc0:
    # block 0x0041adc0: entered by jbe at 0x0041adaf; jmp at 0x0041ae27, 7 instruction(s), ends with jge to 0x0041ae29 (forward)
    movsx ecx, word ptr [ebp - local_2c]         # 0041adc0
    movsx edx, word ptr [ebp - local_30]         # 0041adc4
    mov ax, word ptr [ebp - local_2c]            # 0041adc8
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041adcc
    mov word ptr [ebp - local_2c], ax            # 0041add0
    {load} cmp ecx, edx                          # 0041add4
    jge.d8 L_0041ae29                            # 0041add6
    # block 0x0041add8: entered by fall-through of jge at 0x0041add6, 18 instruction(s), calls FUN_0041bbd9, ends with je to 0x0041ae27 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 0041add8
    push ecx                                     # 0041addc
    mov ecx, dword ptr [ebp - local_40]          # 0041addd
    call FUN_0041bbd9                            # 0041ade0
    movsx edx, word ptr [ebp - local_c]          # 0041ade5
    add edx, 0x1                                 # 0041ade9
    and edx, 0xfff                               # 0041adec
    mov word ptr [ebp - local_c], dx             # 0041adf2
    movsx eax, word ptr [ebp - local_4]          # 0041adf6
    add eax, 0x1                                 # 0041adfa
    and eax, 0xfff                               # 0041adfd
    mov word ptr [ebp - local_4], ax             # 0041ae02
    mov cx, word ptr [ebp - local_38]            # 0041ae06
    sub cx, 0x1                                  # 0041ae0a
    mov word ptr [ebp - local_38], cx            # 0041ae0e
    movsx edx, word ptr [ebp - local_38]         # 0041ae12
    test edx, edx                                # 0041ae16
    je.d8 L_0041ae27                             # 0041ae18
    # block 0x0041ae1a: entered by fall-through of je at 0x0041ae18, 4 instruction(s), calls FUN_0041b992, falls into the block at 0x0041ae27
    movsx eax, word ptr [ebp - local_4]          # 0041ae1a
    push eax                                     # 0041ae1e
    mov ecx, dword ptr [ebp - local_40]          # 0041ae1f
    call FUN_0041b992                            # 0041ae22
L_0041ae27:
    # block 0x0041ae27: entered by je at 0x0041ae18, 1 instruction(s), ends with backward jump to 0x0041adc0
    jmp.d8 L_0041adc0                            # 0041ae27
L_0041ae29:
    # block 0x0041ae29: entered by jge at 0x0041add6, 3 instruction(s), ends with jg to 0x0041abb1 (backward)
    movsx ecx, word ptr [ebp - local_38]         # 0041ae29
    test ecx, ecx                                # 0041ae2d
    jg.d32 L_0041abb1                            # 0041ae2f
    # block 0x0041ae35: entered by fall-through of jg at 0x0041ae2f, 3 instruction(s), ends with jle to 0x0041aea4 (forward)
    movsx edx, word ptr [ebp - local_3c]         # 0041ae35
    cmp edx, 0x1                                 # 0041ae39
    jle.d8 L_0041aea4                            # 0041ae3c
    # block 0x0041ae3e: entered by fall-through of jle at 0x0041ae3c, 2 instruction(s), ends with forward jump to 0x0041ae52
    mov word ptr [ebp - local_2c], 0x0           # 0041ae3e
    jmp.d8 L_0041ae52                            # 0041ae44
L_0041ae46:
    # block 0x0041ae46: entered by jmp at 0x0041ae90, 3 instruction(s), falls into the block at 0x0041ae52
    mov ax, word ptr [ebp - local_2c]            # 0041ae46
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041ae4a
    mov word ptr [ebp - local_2c], ax            # 0041ae4e
L_0041ae52:
    # block 0x0041ae52: entered by jmp at 0x0041ae44, 4 instruction(s), ends with jge to 0x0041ae92 (forward)
    movsx ecx, word ptr [ebp - local_2c]         # 0041ae52
    movsx edx, word ptr [ebp - local_3c]         # 0041ae56
    {load} cmp ecx, edx                          # 0041ae5a
    jge.d8 L_0041ae92                            # 0041ae5c
    # block 0x0041ae5e: entered by fall-through of jge at 0x0041ae5c, 17 instruction(s), calls FUN_0050d4f5, ends with backward jump to 0x0041ae46
    movsx eax, word ptr [ebp - local_2c]         # 0041ae5e
    mov cl, byte ptr [ebp + eax - local_28]      # 0041ae62
    add cl, byte ptr [ebp - local_14]            # 0041ae66
    movsx edx, word ptr [ebp - local_2c]         # 0041ae69
    mov byte ptr [ebp + edx - local_28], cl      # 0041ae6d
    mov al, byte ptr [ebp - local_14]            # 0041ae71
    add al, 0x1                                  # 0041ae74
    mov byte ptr [ebp - local_14], al            # 0041ae76
    mov ecx, dword ptr [ebp + arg_10]            # 0041ae79
    push ecx                                     # 0041ae7c
    movsx edx, word ptr [ebp - local_2c]         # 0041ae7d
    {load} xor eax, eax                          # 0041ae81
    mov al, byte ptr [ebp + edx - local_28]      # 0041ae83
    push eax                                     # 0041ae87
    call FUN_0050d4f5                            # 0041ae88
    add esp, 0x8                                 # 0041ae8d
    jmp.d8 L_0041ae46                            # 0041ae90
L_0041ae92:
    # block 0x0041ae92: entered by jge at 0x0041ae5c, 4 instruction(s), falls into the block at 0x0041aea4
    movsx ecx, word ptr [ebp - local_3c]         # 0041ae92
    mov edx, dword ptr [0x57036c]                # 0041ae96
    {load} add edx, ecx                          # 0041ae9c
    mov dword ptr [0x57036c], edx                # 0041ae9e
L_0041aea4:
    # block 0x0041aea4: entered by jmp at 0x0041ab6d; jle at 0x0041ae3c, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 0041aea4
    pop ebp                                      # 0041aea6
    ret 0xc                                      # 0041aea7

