# FUN_00479deb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00479deb
# extent:       0x00479deb-0x00479f72 (391 code bytes)
# span:         0x00479deb-0x00479f72 (code 391, tables 0, padding 0)
# sha256:       1bda2451177cc6be7fca942d86ac0302681a0c9e245b8330bd670da74c343711
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00479deb
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_17c, field_28b, field_157a, field_158e; [ecx + n] field_24, field_174, field_178, field_297, field_1590; [edx + n] field_170, field_28f, field_293, field_1528
# callees:      calls FUN_00478396, FUN_00479f72
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 106 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_170, 0x170  # offset +0x170
.equ field_174, 0x174  # offset +0x174
.equ field_178, 0x178  # offset +0x178
.equ field_17c, 0x17c  # offset +0x17c
.equ field_28b, 0x28b  # offset +0x28b
.equ field_28f, 0x28f  # offset +0x28f
.equ field_293, 0x293  # offset +0x293
.equ field_297, 0x297  # offset +0x297
.equ field_1528, 0x1528  # offset +0x1528
.equ field_157a, 0x157a  # offset +0x157a
.equ field_158e, 0x158e  # offset +0x158e
.equ field_1590, 0x1590  # offset +0x1590

# --- external targets -----------------------------------------------
.set FUN_00478396, .text + (0x00478396 - 0x401000)
.set FUN_00479f72, .text + (0x00479f72 - 0x401000)

.org 0x00479deb - 0x401000
.globl FUN_00479deb
FUN_00479deb:
    # block 0x00479deb: entry, 7 instruction(s), ends with je to 0x00479f6a (forward)
    push ebp                                     # 00479deb
    {load} mov ebp, esp                          # 00479dec
    sub esp, 0xc                                 # 00479dee
    mov dword ptr [ebp - local_c], ecx           # 00479df1
    mov eax, dword ptr [ebp - local_c]           # 00479df4
    cmp dword ptr [eax + field_157a], 0x0        # 00479df7
    je.d32 L_00479f6a                            # 00479dfe
    # block 0x00479e04: entered by fall-through of je at 0x00479dfe, 3 instruction(s), ends with je to 0x00479f6a (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00479e04
    cmp dword ptr [ecx + field_24], 0x2          # 00479e07
    je.d32 L_00479f6a                            # 00479e0b
    # block 0x00479e11: entered by fall-through of je at 0x00479e0b, 3 instruction(s), ends with jne to 0x00479f6a (forward)
    mov edx, dword ptr [ebp - local_c]           # 00479e11
    cmp dword ptr [edx + field_1528], 0x0        # 00479e14
    jne.d32 L_00479f6a                           # 00479e1b
    # block 0x00479e21: entered by fall-through of jne at 0x00479e1b, 7 instruction(s), ends with forward jump to 0x00479e4b
    mov eax, dword ptr [ebp - local_c]           # 00479e21
    movsx ecx, word ptr [eax + field_1e]         # 00479e24
    imul ecx, ecx, 0x8d                          # 00479e28
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00479e2e
    mov dword ptr [ebp - local_8], edx           # 00479e34
    mov word ptr [ebp - local_4], 0x0            # 00479e37
    jmp.d8 L_00479e4b                            # 00479e3d
L_00479e3f:
    # block 0x00479e3f: entered by jmp at 0x00479f13, 3 instruction(s), falls into the block at 0x00479e4b
    mov ax, word ptr [ebp - local_4]             # 00479e3f
    .insn 0x66, 0x05, 0x0001{:u16}               # 00479e43
    mov word ptr [ebp - local_4], ax             # 00479e47
L_00479e4b:
    # block 0x00479e4b: entered by jmp at 0x00479e3d, 3 instruction(s), ends with jge to 0x00479f18 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00479e4b
    cmp ecx, 0x5                                 # 00479e4f
    jge.d32 L_00479f18                           # 00479e52
    # block 0x00479e58: entered by fall-through of jge at 0x00479e52, 8 instruction(s), ends with jl to 0x00479f13 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 00479e58
    movsx eax, word ptr [ebp - local_4]          # 00479e5c
    shl eax, 0x4                                 # 00479e60
    mov ecx, dword ptr [ebp - local_8]           # 00479e63
    mov eax, dword ptr [ecx + eax + field_174]   # 00479e66
    add eax, 0xa                                 # 00479e6d
    {load} cmp edx, eax                          # 00479e70
    jl.d32 L_00479f13                            # 00479e72
    # block 0x00479e78: entered by fall-through of jl at 0x00479e72, 8 instruction(s), ends with jg to 0x00479f13 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00479e78
    movsx edx, word ptr [ebp - local_4]          # 00479e7c
    shl edx, 0x4                                 # 00479e80
    mov eax, dword ptr [ebp - local_8]           # 00479e83
    mov edx, dword ptr [eax + edx + field_17c]   # 00479e86
    sub edx, 0xa                                 # 00479e8d
    {load} cmp ecx, edx                          # 00479e90
    jg.d8 L_00479f13                             # 00479e92
    # block 0x00479e94: entered by fall-through of jg at 0x00479e92, 8 instruction(s), ends with jl to 0x00479f13 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00479e94
    movsx ecx, word ptr [ebp - local_4]          # 00479e98
    shl ecx, 0x4                                 # 00479e9c
    mov edx, dword ptr [ebp - local_8]           # 00479e9f
    mov ecx, dword ptr [edx + ecx + field_170]   # 00479ea2
    add ecx, 0xa                                 # 00479ea9
    {load} cmp eax, ecx                          # 00479eac
    jl.d8 L_00479f13                             # 00479eae
    # block 0x00479eb0: entered by fall-through of jl at 0x00479eae, 8 instruction(s), ends with jg to 0x00479f13 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00479eb0
    movsx eax, word ptr [ebp - local_4]          # 00479eb4
    shl eax, 0x4                                 # 00479eb8
    mov ecx, dword ptr [ebp - local_8]           # 00479ebb
    mov eax, dword ptr [ecx + eax + field_178]   # 00479ebe
    sub eax, 0xa                                 # 00479ec5
    {load} cmp edx, eax                          # 00479ec8
    jg.d8 L_00479f13                             # 00479eca
    # block 0x00479ecc: entered by fall-through of jg at 0x00479eca, 13 instruction(s), calls FUN_00478396, ends with jne to 0x00479f13 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00479ecc
    mov dx, word ptr [ecx + field_1590]          # 00479ecf
    push edx                                     # 00479ed6
    mov eax, dword ptr [ebp - local_c]           # 00479ed7
    mov cx, word ptr [eax + field_158e]          # 00479eda
    push ecx                                     # 00479ee1
    movsx edx, word ptr [ebp - local_4]          # 00479ee2
    add edx, 0x1                                 # 00479ee6
    push edx                                     # 00479ee9
    mov ecx, dword ptr [ebp - local_c]           # 00479eea
    call FUN_00478396                            # 00479eed
    cmp eax, 0x1                                 # 00479ef2
    jne.d8 L_00479f13                            # 00479ef5
    # block 0x00479ef7: entered by fall-through of jne at 0x00479ef5, 8 instruction(s), calls FUN_00479f72, ends with forward jump to 0x00479f6c
    movsx eax, word ptr [ebp - local_4]          # 00479ef7
    add eax, 0x1                                 # 00479efb
    push eax                                     # 00479efe
    push 0x279c                                  # 00479eff
    mov ecx, dword ptr [ebp - local_c]           # 00479f04
    call FUN_00479f72                            # 00479f07
    mov eax, 0x1                                 # 00479f0c
    jmp.d8 L_00479f6c                            # 00479f11
L_00479f13:
    # block 0x00479f13: entered by jl at 0x00479e72; jg at 0x00479e92; jl at 0x00479eae; jg at 0x00479eca; jne at 0x00479ef5, 1 instruction(s), ends with backward jump to 0x00479e3f
    jmp.d32 L_00479e3f                           # 00479f13
L_00479f18:
    # block 0x00479f18: entered by jge at 0x00479e52, 4 instruction(s), ends with jl to 0x00479f6a (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00479f18
    mov edx, dword ptr [ebp - local_8]           # 00479f1c
    cmp ecx, dword ptr [edx + field_28f]         # 00479f1f
    jl.d8 L_00479f6a                             # 00479f25
    # block 0x00479f27: entered by fall-through of jl at 0x00479f25, 4 instruction(s), ends with jg to 0x00479f6a (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00479f27
    mov ecx, dword ptr [ebp - local_8]           # 00479f2b
    cmp eax, dword ptr [ecx + field_297]         # 00479f2e
    jg.d8 L_00479f6a                             # 00479f34
    # block 0x00479f36: entered by fall-through of jg at 0x00479f34, 4 instruction(s), ends with jl to 0x00479f6a (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00479f36
    mov eax, dword ptr [ebp - local_8]           # 00479f3a
    cmp edx, dword ptr [eax + field_28b]         # 00479f3d
    jl.d8 L_00479f6a                             # 00479f43
    # block 0x00479f45: entered by fall-through of jl at 0x00479f43, 4 instruction(s), ends with jg to 0x00479f6a (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00479f45
    mov edx, dword ptr [ebp - local_8]           # 00479f49
    cmp ecx, dword ptr [edx + field_293]         # 00479f4c
    jg.d8 L_00479f6a                             # 00479f52
    # block 0x00479f54: entered by fall-through of jg at 0x00479f52, 6 instruction(s), calls FUN_00479f72, ends with forward jump to 0x00479f6c
    push 0x0                                     # 00479f54
    push 0x279d                                  # 00479f56
    mov ecx, dword ptr [ebp - local_c]           # 00479f5b
    call FUN_00479f72                            # 00479f5e
    mov eax, 0x1                                 # 00479f63
    jmp.d8 L_00479f6c                            # 00479f68
L_00479f6a:
    # block 0x00479f6a: entered by je at 0x00479dfe; je at 0x00479e0b; jne at 0x00479e1b; jl at 0x00479f25; more, 1 instruction(s), falls into the block at 0x00479f6c
    {load} xor eax, eax                          # 00479f6a
L_00479f6c:
    # block 0x00479f6c: entered by jmp at 0x00479f11; jmp at 0x00479f68, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00479f6c
    pop ebp                                      # 00479f6e
    ret 0x8                                      # 00479f6f

