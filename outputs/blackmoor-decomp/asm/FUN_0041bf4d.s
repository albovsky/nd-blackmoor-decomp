# FUN_0041bf4d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041bf4d
# extent:       0x0041bf4d-0x0041c133 (486 code bytes)
# span:         0x0041bf4d-0x0041c133 (code 486, tables 0, padding 0)
# sha256:       e9cf52274024f5377c986d4c794114d6321beff85a616c901d06636edbf95072
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041bf4d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1c, field_f73, field_fa1; [ecx + n] field_6, field_f75, field_fa5; [edx + n] field_1c, field_1e, field_6b2, field_fa9
# callees:      calls FUN_004c2c3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 92 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_6, 0x6  # offset +0x6
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_6b2, 0x6b2  # offset +0x6b2
.equ field_f73, 0xf73  # offset +0xf73
.equ field_f75, 0xf75  # offset +0xf75
.equ field_fa1, 0xfa1  # offset +0xfa1
.equ field_fa5, 0xfa5  # offset +0xfa5
.equ field_fa9, 0xfa9  # offset +0xfa9

# --- external targets -----------------------------------------------
.set FUN_004c2c3a, .text + (0x004c2c3a - 0x401000)

.org 0x0041bf4d - 0x401000
.globl FUN_0041bf4d
FUN_0041bf4d:
    # block 0x0041bf4d: entry, 13 instruction(s), ends with forward jump to 0x0041bf90
    push ebp                                     # 0041bf4d
    {load} mov ebp, esp                          # 0041bf4e
    sub esp, 0xc                                 # 0041bf50
    push edi                                     # 0041bf53
    mov dword ptr [ebp - local_c], ecx           # 0041bf54
    mov eax, dword ptr [ebp - local_c]           # 0041bf57
    mov word ptr [eax + field_f73], 0xffff       # 0041bf5a
    mov ecx, dword ptr [ebp - local_c]           # 0041bf63
    mov word ptr [ecx + field_f75], 0xffff       # 0041bf66
    mov edx, dword ptr [ebp - local_c]           # 0041bf6f
    mov dword ptr [edx + field_6b2], 0x0         # 0041bf72
    mov word ptr [ebp - local_8], 0x0            # 0041bf7c
    jmp.d8 L_0041bf90                            # 0041bf82
L_0041bf84:
    # block 0x0041bf84: entered by jmp at 0x0041c026, 3 instruction(s), falls into the block at 0x0041bf90
    mov ax, word ptr [ebp - local_8]             # 0041bf84
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041bf88
    mov word ptr [ebp - local_8], ax             # 0041bf8c
L_0041bf90:
    # block 0x0041bf90: entered by jmp at 0x0041bf82, 3 instruction(s), ends with jge to 0x0041c02b (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0041bf90
    cmp ecx, 0x4b                                # 0041bf94
    jge.d32 L_0041c02b                           # 0041bf97
    # block 0x0041bf9d: entered by fall-through of jge at 0x0041bf97, 10 instruction(s), ends with forward jump to 0x0041bfd4
    movsx edx, word ptr [ebp - local_8]          # 0041bf9d
    imul edx, edx, 0x16                          # 0041bfa1
    mov eax, dword ptr [ebp - local_c]           # 0041bfa4
    mov word ptr [eax + edx + field_1c], 0xffff  # 0041bfa7
    movsx ecx, word ptr [ebp - local_8]          # 0041bfae
    imul ecx, ecx, 0x16                          # 0041bfb2
    mov edx, dword ptr [ebp - local_c]           # 0041bfb5
    mov dword ptr [edx + ecx + field_1e], 0x0    # 0041bfb8
    mov word ptr [ebp - local_4], 0x0            # 0041bfc0
    jmp.d8 L_0041bfd4                            # 0041bfc6
L_0041bfc8:
    # block 0x0041bfc8: entered by jmp at 0x0041c024, 3 instruction(s), falls into the block at 0x0041bfd4
    mov ax, word ptr [ebp - local_4]             # 0041bfc8
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041bfcc
    mov word ptr [ebp - local_4], ax             # 0041bfd0
L_0041bfd4:
    # block 0x0041bfd4: entered by jmp at 0x0041bfc6, 3 instruction(s), ends with jge to 0x0041c026 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041bfd4
    cmp ecx, 0x4                                 # 0041bfd8
    jge.d8 L_0041c026                            # 0041bfdb
    # block 0x0041bfdd: entered by fall-through of jge at 0x0041bfdb, 20 instruction(s), calls FUN_004c2c3a, ends with backward jump to 0x0041bfc8
    movsx edx, word ptr [ebp - local_8]          # 0041bfdd
    imul edx, edx, 0x16                          # 0041bfe1
    mov eax, dword ptr [ebp - local_c]           # 0041bfe4
    lea ecx, [eax + edx + field_1c]              # 0041bfe7
    movsx edx, word ptr [ebp - local_4]          # 0041bfeb
    mov dword ptr [ecx + 4*edx + field_6], 0x0   # 0041bfef
    push 0x543188                                # 0041bff7
    push 0x1                                     # 0041bffc
    push 0x8                                     # 0041bffe
    push 0x1                                     # 0041c000
    push 0x1                                     # 0041c002
    mov ecx, 0x5cf659                            # 0041c004
    call FUN_004c2c3a                            # 0041c009
    movsx ecx, word ptr [ebp - local_8]          # 0041c00e
    imul ecx, ecx, 0x16                          # 0041c012
    mov edx, dword ptr [ebp - local_c]           # 0041c015
    lea ecx, [edx + ecx + field_1c]              # 0041c018
    movsx edx, word ptr [ebp - local_4]          # 0041c01c
    mov dword ptr [ecx + 4*edx + field_6], eax   # 0041c020
    jmp.d8 L_0041bfc8                            # 0041c024
L_0041c026:
    # block 0x0041c026: entered by jge at 0x0041bfdb, 1 instruction(s), ends with backward jump to 0x0041bf84
    jmp.d32 L_0041bf84                           # 0041c026
L_0041c02b:
    # block 0x0041c02b: entered by jge at 0x0041bf97, 36 instruction(s), ends with ret
    mov ecx, 0xa                                 # 0041c02b
    {load} xor eax, eax                          # 0041c030
    mov edi, dword ptr [ebp - local_c]           # 0041c032
    add edi, 0xf77                               # 0041c035
    rep stosd dword ptr es:[edi], eax            # 0041c03b
    stosw word ptr es:[edi], ax                  # 0041c03d
    mov eax, dword ptr [ebp - local_c]           # 0041c03f
    mov dword ptr [eax + field_fa1], 0x0         # 0041c042
    mov ecx, dword ptr [ebp - local_c]           # 0041c04c
    mov dword ptr [ecx + field_fa5], 0x0         # 0041c04f
    mov edx, dword ptr [ebp - local_c]           # 0041c059
    mov dword ptr [edx + field_fa9], 0x0         # 0041c05c
    mov dword ptr [0x61870b], 0x43f31a           # 0041c066
    mov dword ptr [0x61870f], 0x43ff18           # 0041c070
    mov dword ptr [0x618713], 0x440dfc           # 0041c07a
    mov dword ptr [0x618717], 0x4416a2           # 0041c084
    mov dword ptr [0x61871b], 0x441931           # 0041c08e
    mov dword ptr [0x61871f], 0x441d74           # 0041c098
    mov dword ptr [0x618723], 0x443ad8           # 0041c0a2
    mov dword ptr [0x618727], 0x443ecd           # 0041c0ac
    mov dword ptr [0x61872b], 0x44423f           # 0041c0b6
    mov dword ptr [0x61872f], 0x44499c           # 0041c0c0
    mov dword ptr [0x618733], 0x44512a           # 0041c0ca
    mov dword ptr [0x618737], 0x445253           # 0041c0d4
    mov dword ptr [0x61873b], 0x4453b7           # 0041c0de
    mov dword ptr [0x61873f], 0x44551b           # 0041c0e8
    mov dword ptr [0x618743], 0x4455b8           # 0041c0f2
    mov dword ptr [0x618747], 0x4456e1           # 0041c0fc
    mov dword ptr [0x61874b], 0x4458d4           # 0041c106
    mov dword ptr [0x61874f], 0x4459fd           # 0041c110
    mov dword ptr [0x618753], 0x445b26           # 0041c11a
    mov dword ptr [0x618757], 0x445c8a           # 0041c124
    pop edi                                      # 0041c12e
    {load} mov esp, ebp                          # 0041c12f
    pop ebp                                      # 0041c131
    ret                                          # 0041c132

