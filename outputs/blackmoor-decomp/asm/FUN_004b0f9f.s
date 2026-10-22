# FUN_004b0f9f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b0f9f
# extent:       0x004b0f9f-0x004b10e3 (324 code bytes)
# span:         0x004b0f9f-0x004b10e3 (code 324, tables 0, padding 0)
# sha256:       a2ae89c317be3bb9d02ff1a28e45c302ede8829f527f4248554ee3b559a26e7c
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b0f9f_lifted
# naming:       native port src/original_methods_fl41.c:m4b0f9f_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 4 seeds; oracle: 97/97 instructions, 10/10 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1e, field_23, field_2b; [edx + n] field_18, field_21, field_2b; [esi + n] field_43
# callees:      calls FUN_004b10e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4b0f9f_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 97 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_18, 0x18  # offset +0x18
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_2b, 0x2b  # offset +0x2b
.equ field_43, 0x43  # offset +0x43

# --- external targets -----------------------------------------------
.set FUN_004b10e3, .text + (0x004b10e3 - 0x401000)

.org 0x004b0f9f - 0x401000
.globl FUN_004b0f9f
FUN_004b0f9f:
    # block 0x004b0f9f: entry, 13 instruction(s), ends with forward jump to 0x004b0fd4
    push ebp                                     # 004b0f9f
    {load} mov ebp, esp                          # 004b0fa0
    sub esp, 0x10                                # 004b0fa2
    push esi                                     # 004b0fa5
    push edi                                     # 004b0fa6
    mov dword ptr [ebp - local_10], ecx          # 004b0fa7
    mov eax, dword ptr [ebp - local_10]          # 004b0faa
    movsx ecx, word ptr [eax + field_1e]         # 004b0fad
    imul ecx, ecx, 0x8d                          # 004b0fb1
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b0fb7
    mov dword ptr [ebp - local_c], edx           # 004b0fbd
    mov word ptr [ebp - local_4], 0x0            # 004b0fc0
    jmp.d8 L_004b0fd4                            # 004b0fc6
L_004b0fc8:
    # block 0x004b0fc8: entered by jmp at 0x004b102b, 3 instruction(s), falls into the block at 0x004b0fd4
    mov ax, word ptr [ebp - local_4]             # 004b0fc8
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b0fcc
    mov word ptr [ebp - local_4], ax             # 004b0fd0
L_004b0fd4:
    # block 0x004b0fd4: entered by jmp at 0x004b0fc6, 5 instruction(s), ends with jge to 0x004b102d (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b0fd4
    mov edx, dword ptr [ebp - local_c]           # 004b0fd8
    movsx eax, word ptr [edx + field_21]         # 004b0fdb
    {load} cmp ecx, eax                          # 004b0fdf
    jge.d8 L_004b102d                            # 004b0fe1
    # block 0x004b0fe3: entered by fall-through of jge at 0x004b0fe1, 2 instruction(s), ends with forward jump to 0x004b0ff7
    mov word ptr [ebp - local_8], 0x0            # 004b0fe3
    jmp.d8 L_004b0ff7                            # 004b0fe9
L_004b0feb:
    # block 0x004b0feb: entered by jmp at 0x004b1029, 3 instruction(s), falls into the block at 0x004b0ff7
    mov cx, word ptr [ebp - local_8]             # 004b0feb
    add cx, 0x1                                  # 004b0fef
    mov word ptr [ebp - local_8], cx             # 004b0ff3
L_004b0ff7:
    # block 0x004b0ff7: entered by jmp at 0x004b0fe9, 5 instruction(s), ends with jge to 0x004b102b (forward)
    movsx edx, word ptr [ebp - local_8]          # 004b0ff7
    mov eax, dword ptr [ebp - local_c]           # 004b0ffb
    movsx ecx, word ptr [eax + field_23]         # 004b0ffe
    {load} cmp edx, ecx                          # 004b1002
    jge.d8 L_004b102b                            # 004b1004
    # block 0x004b1006: entered by fall-through of jge at 0x004b1004, 11 instruction(s), ends with backward jump to 0x004b0feb
    mov ecx, 0xb                                 # 004b1006
    {load} xor eax, eax                          # 004b100b
    movsx edx, word ptr [ebp - local_4]          # 004b100d
    imul edx, edx, 0x1e4                         # 004b1011
    mov esi, dword ptr [ebp - local_10]          # 004b1017
    lea edi, [esi + edx + field_43]              # 004b101a
    movsx edx, word ptr [ebp - local_8]          # 004b101e
    imul edx, edx, 0x2c                          # 004b1022
    {load} add edi, edx                          # 004b1025
    rep stosd dword ptr es:[edi], eax            # 004b1027
    jmp.d8 L_004b0feb                            # 004b1029
L_004b102b:
    # block 0x004b102b: entered by jge at 0x004b1004, 1 instruction(s), ends with backward jump to 0x004b0fc8
    jmp.d8 L_004b0fc8                            # 004b102b
L_004b102d:
    # block 0x004b102d: entered by jge at 0x004b0fe1, 2 instruction(s), ends with forward jump to 0x004b1041
    mov word ptr [ebp - local_4], 0x0            # 004b102d
    jmp.d8 L_004b1041                            # 004b1033
L_004b1035:
    # block 0x004b1035: entered by jmp at 0x004b10d8, 3 instruction(s), falls into the block at 0x004b1041
    mov ax, word ptr [ebp - local_4]             # 004b1035
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b1039
    mov word ptr [ebp - local_4], ax             # 004b103d
L_004b1041:
    # block 0x004b1041: entered by jmp at 0x004b1033, 5 instruction(s), ends with jge to 0x004b10dd (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b1041
    mov edx, dword ptr [ebp - local_c]           # 004b1045
    movsx eax, word ptr [edx + field_21]         # 004b1048
    {load} cmp ecx, eax                          # 004b104c
    jge.d32 L_004b10dd                           # 004b104e
    # block 0x004b1054: entered by fall-through of jge at 0x004b104e, 2 instruction(s), ends with forward jump to 0x004b1068
    mov word ptr [ebp - local_8], 0x0            # 004b1054
    jmp.d8 L_004b1068                            # 004b105a
L_004b105c:
    # block 0x004b105c: entered by jmp at 0x004b10d6, 3 instruction(s), falls into the block at 0x004b1068
    mov cx, word ptr [ebp - local_8]             # 004b105c
    add cx, 0x1                                  # 004b1060
    mov word ptr [ebp - local_8], cx             # 004b1064
L_004b1068:
    # block 0x004b1068: entered by jmp at 0x004b105a, 5 instruction(s), ends with jge to 0x004b10d8 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004b1068
    mov eax, dword ptr [ebp - local_c]           # 004b106c
    movsx ecx, word ptr [eax + field_23]         # 004b106f
    {load} cmp edx, ecx                          # 004b1073
    jge.d8 L_004b10d8                            # 004b1075
    # block 0x004b1077: entered by fall-through of jge at 0x004b1075, 8 instruction(s), ends with je to 0x004b10d6 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b1077
    imul edx, edx, 0x16                          # 004b107b
    mov eax, dword ptr [ebp - local_c]           # 004b107e
    lea ecx, [eax + edx + field_2b]              # 004b1081
    movsx edx, word ptr [ebp - local_8]          # 004b1085
    movsx eax, word ptr [ecx + 2*edx]            # 004b1089
    test eax, eax                                # 004b108d
    je.d8 L_004b10d6                             # 004b108f
    # block 0x004b1091: entered by fall-through of je at 0x004b108f, 19 instruction(s), calls FUN_004b10e3, falls into the block at 0x004b10d6
    movsx ecx, word ptr [ebp - local_4]          # 004b1091
    imul ecx, ecx, 0x16                          # 004b1095
    mov edx, dword ptr [ebp - local_c]           # 004b1098
    lea eax, [edx + ecx + field_2b]              # 004b109b
    movsx ecx, word ptr [ebp - local_8]          # 004b109f
    movsx edx, word ptr [ebp - local_4]          # 004b10a3
    imul edx, edx, 0x1e4                         # 004b10a7
    mov esi, dword ptr [ebp - local_10]          # 004b10ad
    lea edx, [esi + edx + field_43]              # 004b10b0
    movsx esi, word ptr [ebp - local_8]          # 004b10b4
    imul esi, esi, 0x2c                          # 004b10b8
    mov ax, word ptr [eax + 2*ecx]               # 004b10bb
    mov word ptr [edx + esi + field_18], ax      # 004b10bf
    mov cx, word ptr [ebp - local_8]             # 004b10c4
    push ecx                                     # 004b10c8
    mov dx, word ptr [ebp - local_4]             # 004b10c9
    push edx                                     # 004b10cd
    mov ecx, dword ptr [ebp - local_10]          # 004b10ce
    call FUN_004b10e3                            # 004b10d1
L_004b10d6:
    # block 0x004b10d6: entered by je at 0x004b108f, 1 instruction(s), ends with backward jump to 0x004b105c
    jmp.d8 L_004b105c                            # 004b10d6
L_004b10d8:
    # block 0x004b10d8: entered by jge at 0x004b1075, 1 instruction(s), ends with backward jump to 0x004b1035
    jmp.d32 L_004b1035                           # 004b10d8
L_004b10dd:
    # block 0x004b10dd: entered by jge at 0x004b104e, 5 instruction(s), ends with ret
    pop edi                                      # 004b10dd
    pop esi                                      # 004b10de
    {load} mov esp, ebp                          # 004b10df
    pop ebp                                      # 004b10e1
    ret                                          # 004b10e2

