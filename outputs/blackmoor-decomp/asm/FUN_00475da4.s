# FUN_00475da4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00475da4
# extent:       0x00475da4-0x00475fb1 (525 code bytes)
# span:         0x00475da4-0x00475fb1 (code 525, tables 0, padding 0)
# sha256:       c0a9f13ff633aba85096f7c8e3d62b51d815622d4c75d2a940d68d5a692a7e74
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m475da4_hit_test
# naming:       native port src/original_methods_fl19a.c:m475da4_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m475da4_hit_test. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 525 bytes.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_30, field_678, field_7ee, field_89a, field_8ba; [ecx + n] field_10, field_2c, field_30, field_42, field_684, field_7e6, field_7ea, field_8be; [edx + n] field_8, field_c, field_22, field_30, field_44, field_67c, field_680, field_7e2
# callees:      calls FUN_00475fb1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl19a.c:m475da4_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 138 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_22, 0x22  # offset +0x22
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_42, 0x42  # offset +0x42
.equ field_44, 0x44  # offset +0x44
.equ field_678, 0x678  # offset +0x678
.equ field_67c, 0x67c  # offset +0x67c
.equ field_680, 0x680  # offset +0x680
.equ field_684, 0x684  # offset +0x684
.equ field_7e2, 0x7e2  # offset +0x7e2
.equ field_7e6, 0x7e6  # offset +0x7e6
.equ field_7ea, 0x7ea  # offset +0x7ea
.equ field_7ee, 0x7ee  # offset +0x7ee
.equ field_89a, 0x89a  # offset +0x89a
.equ field_8ba, 0x8ba  # offset +0x8ba
.equ field_8be, 0x8be  # offset +0x8be

# --- external targets -----------------------------------------------
.set FUN_00475fb1, .text + (0x00475fb1 - 0x401000)

.org 0x00475da4 - 0x401000
.globl FUN_00475da4
FUN_00475da4:
    # block 0x00475da4: entry, 7 instruction(s), ends with je to 0x00475fa9 (forward)
    push ebp                                     # 00475da4
    {load} mov ebp, esp                          # 00475da5
    sub esp, 0x10                                # 00475da7
    mov dword ptr [ebp - local_10], ecx          # 00475daa
    mov eax, dword ptr [ebp - local_10]          # 00475dad
    cmp dword ptr [eax + field_89a], 0x0         # 00475db0
    je.d32 L_00475fa9                            # 00475db7
    # block 0x00475dbd: entered by fall-through of je at 0x00475db7, 3 instruction(s), ends with je to 0x00475fa9 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00475dbd
    cmp dword ptr [ecx + field_2c], 0x2          # 00475dc0
    je.d32 L_00475fa9                            # 00475dc4
    # block 0x00475dca: entered by fall-through of je at 0x00475dc4, 7 instruction(s), ends with forward jump to 0x00475df4
    mov edx, dword ptr [ebp - local_10]          # 00475dca
    movsx eax, word ptr [edx + field_22]         # 00475dcd
    imul eax, eax, 0x8d                          # 00475dd1
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00475dd7
    mov dword ptr [ebp - local_4], ecx           # 00475ddd
    mov word ptr [ebp - local_8], 0x0            # 00475de0
    jmp.d8 L_00475df4                            # 00475de6
L_00475de8:
    # block 0x00475de8: entered by jmp at 0x00475f04, 3 instruction(s), falls into the block at 0x00475df4
    mov dx, word ptr [ebp - local_8]             # 00475de8
    add dx, 0x1                                  # 00475dec
    mov word ptr [ebp - local_8], dx             # 00475df0
L_00475df4:
    # block 0x00475df4: entered by jmp at 0x00475de6, 5 instruction(s), ends with jge to 0x00475f09 (forward)
    movsx eax, word ptr [ebp - local_8]          # 00475df4
    mov ecx, dword ptr [ebp - local_4]           # 00475df8
    movsx edx, word ptr [ecx + field_42]         # 00475dfb
    {load} cmp eax, edx                          # 00475dff
    jge.d32 L_00475f09                           # 00475e01
    # block 0x00475e07: entered by fall-through of jge at 0x00475e01, 2 instruction(s), ends with forward jump to 0x00475e1b
    mov word ptr [ebp - local_c], 0x0            # 00475e07
    jmp.d8 L_00475e1b                            # 00475e0d
L_00475e0f:
    # block 0x00475e0f: entered by jmp at 0x00475eff, 3 instruction(s), falls into the block at 0x00475e1b
    mov ax, word ptr [ebp - local_c]             # 00475e0f
    .insn 0x66, 0x05, 0x0001{:u16}               # 00475e13
    mov word ptr [ebp - local_c], ax             # 00475e17
L_00475e1b:
    # block 0x00475e1b: entered by jmp at 0x00475e0d, 5 instruction(s), ends with jge to 0x00475f04 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 00475e1b
    mov edx, dword ptr [ebp - local_4]           # 00475e1f
    movsx eax, word ptr [edx + field_44]         # 00475e22
    {load} cmp ecx, eax                          # 00475e26
    jge.d32 L_00475f04                           # 00475e28
    # block 0x00475e2e: entered by fall-through of jge at 0x00475e28, 11 instruction(s), ends with jl to 0x00475eff (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00475e2e
    movsx edx, word ptr [ebp - local_8]          # 00475e32
    imul edx, edx, 0xc8                          # 00475e36
    mov eax, dword ptr [ebp - local_10]          # 00475e3c
    lea edx, [eax + edx + field_30]              # 00475e3f
    movsx eax, word ptr [ebp - local_c]          # 00475e43
    imul eax, eax, 0x14                          # 00475e47
    mov edx, dword ptr [edx + eax + field_8]     # 00475e4a
    add edx, 0x3                                 # 00475e4e
    {load} cmp ecx, edx                          # 00475e51
    jl.d32 L_00475eff                            # 00475e53
    # block 0x00475e59: entered by fall-through of jl at 0x00475e53, 11 instruction(s), ends with jg to 0x00475eff (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00475e59
    movsx ecx, word ptr [ebp - local_8]          # 00475e5d
    imul ecx, ecx, 0xc8                          # 00475e61
    mov edx, dword ptr [ebp - local_10]          # 00475e67
    lea ecx, [edx + ecx + field_30]              # 00475e6a
    movsx edx, word ptr [ebp - local_c]          # 00475e6e
    imul edx, edx, 0x14                          # 00475e72
    mov ecx, dword ptr [ecx + edx + field_10]    # 00475e75
    sub ecx, 0x3                                 # 00475e79
    {load} cmp eax, ecx                          # 00475e7c
    jg.d8 L_00475eff                             # 00475e7e
    # block 0x00475e80: entered by fall-through of jg at 0x00475e7e, 11 instruction(s), ends with jl to 0x00475eff (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00475e80
    movsx eax, word ptr [ebp - local_8]          # 00475e84
    imul eax, eax, 0xc8                          # 00475e88
    mov ecx, dword ptr [ebp - local_10]          # 00475e8e
    lea eax, [ecx + eax + field_30]              # 00475e91
    movsx ecx, word ptr [ebp - local_c]          # 00475e95
    imul ecx, ecx, 0x14                          # 00475e99
    mov eax, dword ptr [eax + ecx + field_4]     # 00475e9c
    add eax, 0x3                                 # 00475ea0
    {load} cmp edx, eax                          # 00475ea3
    jl.d8 L_00475eff                             # 00475ea5
    # block 0x00475ea7: entered by fall-through of jl at 0x00475ea5, 11 instruction(s), ends with jg to 0x00475eff (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00475ea7
    movsx edx, word ptr [ebp - local_8]          # 00475eab
    imul edx, edx, 0xc8                          # 00475eaf
    mov eax, dword ptr [ebp - local_10]          # 00475eb5
    lea edx, [eax + edx + field_30]              # 00475eb8
    movsx eax, word ptr [ebp - local_c]          # 00475ebc
    imul eax, eax, 0x14                          # 00475ec0
    mov edx, dword ptr [edx + eax + field_c]     # 00475ec3
    sub edx, 0x3                                 # 00475ec7
    {load} cmp ecx, edx                          # 00475eca
    jg.d8 L_00475eff                             # 00475ecc
    # block 0x00475ece: entered by fall-through of jg at 0x00475ecc, 11 instruction(s), calls FUN_00475fb1, ends with forward jump to 0x00475fab
    push 0x27d5                                  # 00475ece
    mov ecx, dword ptr [ebp - local_10]          # 00475ed3
    call FUN_00475fb1                            # 00475ed6
    movsx eax, word ptr [ebp - local_8]          # 00475edb
    mov ecx, dword ptr [ebp - local_10]          # 00475edf
    mov dword ptr [ecx + field_8be], eax         # 00475ee2
    movsx edx, word ptr [ebp - local_c]          # 00475ee8
    mov eax, dword ptr [ebp - local_10]          # 00475eec
    mov dword ptr [eax + field_8ba], edx         # 00475eef
    mov eax, 0x1                                 # 00475ef5
    jmp.d32 L_00475fab                           # 00475efa
L_00475eff:
    # block 0x00475eff: entered by jl at 0x00475e53; jg at 0x00475e7e; jl at 0x00475ea5; jg at 0x00475ecc, 1 instruction(s), ends with backward jump to 0x00475e0f
    jmp.d32 L_00475e0f                           # 00475eff
L_00475f04:
    # block 0x00475f04: entered by jge at 0x00475e28, 1 instruction(s), ends with backward jump to 0x00475de8
    jmp.d32 L_00475de8                           # 00475f04
L_00475f09:
    # block 0x00475f09: entered by jge at 0x00475e01, 4 instruction(s), ends with jl to 0x00475f59 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00475f09
    mov edx, dword ptr [ebp - local_4]           # 00475f0d
    cmp ecx, dword ptr [edx + field_67c]         # 00475f10
    jl.d8 L_00475f59                             # 00475f16
    # block 0x00475f18: entered by fall-through of jl at 0x00475f16, 4 instruction(s), ends with jg to 0x00475f59 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00475f18
    mov ecx, dword ptr [ebp - local_4]           # 00475f1c
    cmp eax, dword ptr [ecx + field_684]         # 00475f1f
    jg.d8 L_00475f59                             # 00475f25
    # block 0x00475f27: entered by fall-through of jg at 0x00475f25, 4 instruction(s), ends with jl to 0x00475f59 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00475f27
    mov eax, dword ptr [ebp - local_4]           # 00475f2b
    cmp edx, dword ptr [eax + field_678]         # 00475f2e
    jl.d8 L_00475f59                             # 00475f34
    # block 0x00475f36: entered by fall-through of jl at 0x00475f34, 4 instruction(s), ends with jg to 0x00475f59 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00475f36
    mov edx, dword ptr [ebp - local_4]           # 00475f3a
    cmp ecx, dword ptr [edx + field_680]         # 00475f3d
    jg.d8 L_00475f59                             # 00475f43
    # block 0x00475f45: entered by fall-through of jg at 0x00475f43, 5 instruction(s), calls FUN_00475fb1, ends with forward jump to 0x00475fab
    push 0x27d7                                  # 00475f45
    mov ecx, dword ptr [ebp - local_10]          # 00475f4a
    call FUN_00475fb1                            # 00475f4d
    mov eax, 0x1                                 # 00475f52
    jmp.d8 L_00475fab                            # 00475f57
L_00475f59:
    # block 0x00475f59: entered by jl at 0x00475f16; jg at 0x00475f25; jl at 0x00475f34; jg at 0x00475f43, 4 instruction(s), ends with jl to 0x00475fa9 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00475f59
    mov ecx, dword ptr [ebp - local_4]           # 00475f5d
    cmp eax, dword ptr [ecx + field_7e6]         # 00475f60
    jl.d8 L_00475fa9                             # 00475f66
    # block 0x00475f68: entered by fall-through of jl at 0x00475f66, 4 instruction(s), ends with jg to 0x00475fa9 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00475f68
    mov eax, dword ptr [ebp - local_4]           # 00475f6c
    cmp edx, dword ptr [eax + field_7ee]         # 00475f6f
    jg.d8 L_00475fa9                             # 00475f75
    # block 0x00475f77: entered by fall-through of jg at 0x00475f75, 4 instruction(s), ends with jl to 0x00475fa9 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00475f77
    mov edx, dword ptr [ebp - local_4]           # 00475f7b
    cmp ecx, dword ptr [edx + field_7e2]         # 00475f7e
    jl.d8 L_00475fa9                             # 00475f84
    # block 0x00475f86: entered by fall-through of jl at 0x00475f84, 4 instruction(s), ends with jg to 0x00475fa9 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00475f86
    mov ecx, dword ptr [ebp - local_4]           # 00475f8a
    cmp eax, dword ptr [ecx + field_7ea]         # 00475f8d
    jg.d8 L_00475fa9                             # 00475f93
    # block 0x00475f95: entered by fall-through of jg at 0x00475f93, 5 instruction(s), calls FUN_00475fb1, ends with forward jump to 0x00475fab
    push 0x27d6                                  # 00475f95
    mov ecx, dword ptr [ebp - local_10]          # 00475f9a
    call FUN_00475fb1                            # 00475f9d
    mov eax, 0x1                                 # 00475fa2
    jmp.d8 L_00475fab                            # 00475fa7
L_00475fa9:
    # block 0x00475fa9: entered by je at 0x00475db7; je at 0x00475dc4; jl at 0x00475f66; jg at 0x00475f75; more, 1 instruction(s), falls into the block at 0x00475fab
    {load} xor eax, eax                          # 00475fa9
L_00475fab:
    # block 0x00475fab: entered by jmp at 0x00475efa; jmp at 0x00475f57; jmp at 0x00475fa7, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00475fab
    pop ebp                                      # 00475fad
    ret 0x8                                      # 00475fae

