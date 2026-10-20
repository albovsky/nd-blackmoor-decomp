# FUN_0048bd91
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048bd91
# extent:       0x0048bd91-0x0048c0ac (795 code bytes)
# span:         0x0048bd91-0x0048c0ac (code 795, tables 0, padding 0)
# sha256:       903a8e158b77aa0b552d58eb2f612b0f0a0e6c4569fbdcbdefe1ca16c1baccf9
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48bd91_hit_test
# naming:       native port src/original_methods_fl19a.c:m48bd91_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m48bd91_hit_test. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 795 bytes.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_26, field_28, field_46, field_64, field_68, field_152, field_156, field_162, field_166, field_16a, field_16e; [ecx + n] field_28, field_74, field_78, field_7c, field_80, field_14e, field_15e; [edx + n] field_15a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl19a.c:m48bd91_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 178 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_26, 0x26  # offset +0x26
.equ field_28, 0x28  # offset +0x28
.equ field_46, 0x46  # offset +0x46
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_74, 0x74  # offset +0x74
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c
.equ field_80, 0x80  # offset +0x80
.equ field_14e, 0x14e  # offset +0x14e
.equ field_152, 0x152  # offset +0x152
.equ field_156, 0x156  # offset +0x156
.equ field_15a, 0x15a  # offset +0x15a
.equ field_15e, 0x15e  # offset +0x15e
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_16a, 0x16a  # offset +0x16a
.equ field_16e, 0x16e  # offset +0x16e

# --- external targets -----------------------------------------------

.org 0x0048bd91 - 0x401000
.globl FUN_0048bd91
FUN_0048bd91:
    # block 0x0048bd91: entry, 14 instruction(s), ends with je to 0x0048c0a4 (forward)
    push ebp                                     # 0048bd91
    {load} mov ebp, esp                          # 0048bd92
    sub esp, 0xc                                 # 0048bd94
    mov dword ptr [ebp - local_c], ecx           # 0048bd97
    mov eax, dword ptr [ebp - local_c]           # 0048bd9a
    movsx ecx, word ptr [eax + field_26]         # 0048bd9d
    imul ecx, ecx, 0x8d                          # 0048bda1
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048bda7
    mov dword ptr [ebp - local_8], edx           # 0048bdad
    mov eax, dword ptr [ebp - local_c]           # 0048bdb0
    {load} xor ecx, ecx                          # 0048bdb3
    mov cl, byte ptr [eax + field_46]            # 0048bdb5
    test ecx, ecx                                # 0048bdb8
    je.d32 L_0048c0a4                            # 0048bdba
    # block 0x0048bdc0: entered by fall-through of je at 0x0048bdba, 4 instruction(s), ends with jl to 0x0048be5c (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0048bdc0
    mov eax, dword ptr [ebp - local_8]           # 0048bdc4
    cmp edx, dword ptr [eax + field_152]         # 0048bdc7
    jl.d32 L_0048be5c                            # 0048bdcd
    # block 0x0048bdd3: entered by fall-through of jl at 0x0048bdcd, 4 instruction(s), ends with jg to 0x0048be5c (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0048bdd3
    mov edx, dword ptr [ebp - local_8]           # 0048bdd7
    cmp ecx, dword ptr [edx + field_15a]         # 0048bdda
    jg.d8 L_0048be5c                             # 0048bde0
    # block 0x0048bde2: entered by fall-through of jg at 0x0048bde0, 4 instruction(s), ends with jl to 0x0048be5c (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0048bde2
    mov ecx, dword ptr [ebp - local_8]           # 0048bde6
    cmp eax, dword ptr [ecx + field_14e]         # 0048bde9
    jl.d8 L_0048be5c                             # 0048bdef
    # block 0x0048bdf1: entered by fall-through of jl at 0x0048bdef, 4 instruction(s), ends with jg to 0x0048be5c (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0048bdf1
    mov eax, dword ptr [ebp - local_8]           # 0048bdf5
    cmp edx, dword ptr [eax + field_156]         # 0048bdf8
    jg.d8 L_0048be5c                             # 0048bdfe
    # block 0x0048be00: entered by fall-through of jg at 0x0048bdfe, 14 instruction(s), ends with forward jump to 0x0048c0a6
    mov dword ptr [0x5b44f0], 0x9                # 0048be00
    mov dword ptr [0x5b44f4], 0x1                # 0048be0a
    mov ecx, dword ptr [0x5d0377]                # 0048be14
    mov dword ptr [0x5d162d], ecx                # 0048be1a
    mov edx, dword ptr [0x5b44f0]                # 0048be20
    shl edx, 0x5                                 # 0048be26
    mov eax, dword ptr [0x5b44f4]                # 0048be29
    shl eax, 0x4                                 # 0048be2e
    lea ecx, [edx + eax + 0x5b160c]              # 0048be31
    mov dword ptr [0x5d1631], ecx                # 0048be38
    mov dword ptr [0x5d1639], 0x1                # 0048be3e
    mov dword ptr [0x5c39e5], 0x27a9             # 0048be48
    mov eax, 0x1                                 # 0048be52
    jmp.d32 L_0048c0a6                           # 0048be57
L_0048be5c:
    # block 0x0048be5c: entered by jl at 0x0048bdcd; jg at 0x0048bde0; jl at 0x0048bdef; jg at 0x0048bdfe, 2 instruction(s), ends with forward jump to 0x0048be70
    mov word ptr [ebp - local_4], 0x0            # 0048be5c
    jmp.d8 L_0048be70                            # 0048be62
L_0048be64:
    # block 0x0048be64: entered by jmp at 0x0048bf8b, 3 instruction(s), falls into the block at 0x0048be70
    mov dx, word ptr [ebp - local_4]             # 0048be64
    add dx, 0x1                                  # 0048be68
    mov word ptr [ebp - local_4], dx             # 0048be6c
L_0048be70:
    # block 0x0048be70: entered by jmp at 0x0048be62, 3 instruction(s), ends with jge to 0x0048bf90 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0048be70
    cmp eax, 0x4                                 # 0048be74
    jge.d32 L_0048bf90                           # 0048be77
    # block 0x0048be7d: entered by fall-through of jge at 0x0048be77, 8 instruction(s), ends with jl to 0x0048bf8b (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048be7d
    mov word ptr [ecx + field_28], 0xffff        # 0048be80
    movsx edx, word ptr [ebp + arg_c]            # 0048be86
    movsx eax, word ptr [ebp - local_4]          # 0048be8a
    shl eax, 0x4                                 # 0048be8e
    mov ecx, dword ptr [ebp - local_8]           # 0048be91
    cmp edx, dword ptr [ecx + eax + field_78]    # 0048be94
    jl.d32 L_0048bf8b                            # 0048be98
    # block 0x0048be9e: entered by fall-through of jl at 0x0048be98, 6 instruction(s), ends with jg to 0x0048bf8b (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0048be9e
    movsx eax, word ptr [ebp - local_4]          # 0048bea2
    shl eax, 0x4                                 # 0048bea6
    mov ecx, dword ptr [ebp - local_8]           # 0048bea9
    cmp edx, dword ptr [ecx + eax + field_80]    # 0048beac
    jg.d32 L_0048bf8b                            # 0048beb3
    # block 0x0048beb9: entered by fall-through of jg at 0x0048beb3, 6 instruction(s), ends with jl to 0x0048bf8b (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0048beb9
    movsx eax, word ptr [ebp - local_4]          # 0048bebd
    shl eax, 0x4                                 # 0048bec1
    mov ecx, dword ptr [ebp - local_8]           # 0048bec4
    cmp edx, dword ptr [ecx + eax + field_74]    # 0048bec7
    jl.d32 L_0048bf8b                            # 0048becb
    # block 0x0048bed1: entered by fall-through of jl at 0x0048becb, 6 instruction(s), ends with jg to 0x0048bf8b (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0048bed1
    movsx eax, word ptr [ebp - local_4]          # 0048bed5
    shl eax, 0x4                                 # 0048bed9
    mov ecx, dword ptr [ebp - local_8]           # 0048bedc
    cmp edx, dword ptr [ecx + eax + field_7c]    # 0048bedf
    jg.d32 L_0048bf8b                            # 0048bee3
    # block 0x0048bee9: entered by fall-through of jg at 0x0048bee3, 3 instruction(s), ends with je to 0x0048bf1b (forward)
    movsx edx, word ptr [0x583a29]               # 0048bee9
    cmp edx, -0x1                                # 0048bef0
    je.d8 L_0048bf1b                             # 0048bef3
    # block 0x0048bef5: entered by fall-through of je at 0x0048bef3, 2 instruction(s), ends with jne to 0x0048bf1b (forward)
    cmp dword ptr [0x5b44f8], 0x0                # 0048bef5
    jne.d8 L_0048bf1b                            # 0048befc
    # block 0x0048befe: entered by fall-through of jne at 0x0048befc, 6 instruction(s), ends with forward jump to 0x0048bf3a
    movsx eax, word ptr [0x583a29]               # 0048befe
    add eax, 0x25                                # 0048bf05
    mov dword ptr [0x5b44f0], eax                # 0048bf08
    mov ecx, dword ptr [0x571ad3]                # 0048bf0d
    mov dword ptr [0x5d162d], ecx                # 0048bf13
    jmp.d8 L_0048bf3a                            # 0048bf19
L_0048bf1b:
    # block 0x0048bf1b: entered by je at 0x0048bef3; jne at 0x0048befc, 3 instruction(s), ends with jne to 0x0048bf3a (forward)
    movsx edx, word ptr [0x583a29]               # 0048bf1b
    cmp edx, -0x1                                # 0048bf22
    jne.d8 L_0048bf3a                            # 0048bf25
    # block 0x0048bf27: entered by fall-through of jne at 0x0048bf25, 2 instruction(s), ends with jne to 0x0048bf3a (forward)
    cmp dword ptr [0x5b44f8], 0x0                # 0048bf27
    jne.d8 L_0048bf3a                            # 0048bf2e
    # block 0x0048bf30: entered by fall-through of jne at 0x0048bf2e, 1 instruction(s), falls into the block at 0x0048bf3a
    mov dword ptr [0x5b44f0], 0x0                # 0048bf30
L_0048bf3a:
    # block 0x0048bf3a: entered by jmp at 0x0048bf19; jne at 0x0048bf25; jne at 0x0048bf2e, 14 instruction(s), ends with forward jump to 0x0048c0a6
    mov dword ptr [0x5b44f4], 0x1                # 0048bf3a
    mov eax, dword ptr [0x5b44f0]                # 0048bf44
    shl eax, 0x5                                 # 0048bf49
    mov ecx, dword ptr [0x5b44f4]                # 0048bf4c
    shl ecx, 0x4                                 # 0048bf52
    lea edx, [eax + ecx + 0x5b160c]              # 0048bf55
    mov dword ptr [0x5d1631], edx                # 0048bf5c
    mov dword ptr [0x5d1639], 0x1                # 0048bf62
    mov dword ptr [0x5c39e5], 0x27a7             # 0048bf6c
    mov eax, dword ptr [ebp - local_c]           # 0048bf76
    mov cx, word ptr [ebp - local_4]             # 0048bf79
    mov word ptr [eax + field_28], cx            # 0048bf7d
    mov eax, 0x1                                 # 0048bf81
    jmp.d32 L_0048c0a6                           # 0048bf86
L_0048bf8b:
    # block 0x0048bf8b: entered by jl at 0x0048be98; jg at 0x0048beb3; jl at 0x0048becb; jg at 0x0048bee3, 1 instruction(s), ends with backward jump to 0x0048be64
    jmp.d32 L_0048be64                           # 0048bf8b
L_0048bf90:
    # block 0x0048bf90: entered by jge at 0x0048be77, 2 instruction(s), ends with forward jump to 0x0048bfa4
    mov word ptr [ebp - local_4], 0x0            # 0048bf90
    jmp.d8 L_0048bfa4                            # 0048bf96
L_0048bf98:
    # block 0x0048bf98: entered by jmp at 0x0048c09f, 3 instruction(s), falls into the block at 0x0048bfa4
    mov dx, word ptr [ebp - local_4]             # 0048bf98
    add dx, 0x1                                  # 0048bf9c
    mov word ptr [ebp - local_4], dx             # 0048bfa0
L_0048bfa4:
    # block 0x0048bfa4: entered by jmp at 0x0048bf96, 5 instruction(s), ends with jge to 0x0048c0a4 (forward)
    movsx eax, word ptr [ebp - local_4]          # 0048bfa4
    mov ecx, dword ptr [ebp - local_8]           # 0048bfa8
    movsx edx, word ptr [ecx + field_15e]        # 0048bfab
    {load} cmp eax, edx                          # 0048bfb2
    jge.d32 L_0048c0a4                           # 0048bfb4
    # block 0x0048bfba: entered by fall-through of jge at 0x0048bfb4, 11 instruction(s), ends with jl to 0x0048c09f (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048bfba
    mov word ptr [eax + field_28], 0xffff        # 0048bfbd
    movsx ecx, word ptr [ebp + arg_c]            # 0048bfc3
    movsx edx, word ptr [ebp - local_4]          # 0048bfc7
    imul edx, edx, 0x12                          # 0048bfcb
    mov eax, dword ptr [ebp - local_8]           # 0048bfce
    mov edx, dword ptr [eax + edx + field_166]   # 0048bfd1
    mov eax, dword ptr [ebp - local_8]           # 0048bfd8
    add edx, dword ptr [eax + field_68]          # 0048bfdb
    {load} cmp ecx, edx                          # 0048bfde
    jl.d32 L_0048c09f                            # 0048bfe0
    # block 0x0048bfe6: entered by fall-through of jl at 0x0048bfe0, 9 instruction(s), ends with jg to 0x0048c09f (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0048bfe6
    movsx edx, word ptr [ebp - local_4]          # 0048bfea
    imul edx, edx, 0x12                          # 0048bfee
    mov eax, dword ptr [ebp - local_8]           # 0048bff1
    mov edx, dword ptr [eax + edx + field_16e]   # 0048bff4
    mov eax, dword ptr [ebp - local_8]           # 0048bffb
    add edx, dword ptr [eax + field_68]          # 0048bffe
    {load} cmp ecx, edx                          # 0048c001
    jg.d32 L_0048c09f                            # 0048c003
    # block 0x0048c009: entered by fall-through of jg at 0x0048c003, 9 instruction(s), ends with jl to 0x0048c09f (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0048c009
    movsx edx, word ptr [ebp - local_4]          # 0048c00d
    imul edx, edx, 0x12                          # 0048c011
    mov eax, dword ptr [ebp - local_8]           # 0048c014
    mov edx, dword ptr [eax + edx + field_162]   # 0048c017
    mov eax, dword ptr [ebp - local_8]           # 0048c01e
    add edx, dword ptr [eax + field_64]          # 0048c021
    {load} cmp ecx, edx                          # 0048c024
    jl.d8 L_0048c09f                             # 0048c026
    # block 0x0048c028: entered by fall-through of jl at 0x0048c026, 9 instruction(s), ends with jg to 0x0048c09f (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0048c028
    movsx edx, word ptr [ebp - local_4]          # 0048c02c
    imul edx, edx, 0x12                          # 0048c030
    mov eax, dword ptr [ebp - local_8]           # 0048c033
    mov edx, dword ptr [eax + edx + field_16a]   # 0048c036
    mov eax, dword ptr [ebp - local_8]           # 0048c03d
    add edx, dword ptr [eax + field_64]          # 0048c040
    {load} cmp ecx, edx                          # 0048c043
    jg.d8 L_0048c09f                             # 0048c045
    # block 0x0048c047: entered by fall-through of jg at 0x0048c045, 15 instruction(s), ends with forward jump to 0x0048c0a6
    mov dword ptr [0x5b44f0], 0x0                # 0048c047
    mov dword ptr [0x5b44f4], 0x1                # 0048c051
    mov ecx, dword ptr [0x5b44f0]                # 0048c05b
    shl ecx, 0x5                                 # 0048c061
    mov edx, dword ptr [0x5b44f4]                # 0048c064
    shl edx, 0x4                                 # 0048c06a
    lea eax, [ecx + edx + 0x5b160c]              # 0048c06d
    mov dword ptr [0x5d1631], eax                # 0048c074
    mov dword ptr [0x5d1639], 0x1                # 0048c079
    mov dword ptr [0x5c39e5], 0x27a8             # 0048c083
    mov ecx, dword ptr [ebp - local_c]           # 0048c08d
    mov dx, word ptr [ebp - local_4]             # 0048c090
    mov word ptr [ecx + field_28], dx            # 0048c094
    mov eax, 0x1                                 # 0048c098
    jmp.d8 L_0048c0a6                            # 0048c09d
L_0048c09f:
    # block 0x0048c09f: entered by jl at 0x0048bfe0; jg at 0x0048c003; jl at 0x0048c026; jg at 0x0048c045, 1 instruction(s), ends with backward jump to 0x0048bf98
    jmp.d32 L_0048bf98                           # 0048c09f
L_0048c0a4:
    # block 0x0048c0a4: entered by je at 0x0048bdba; jge at 0x0048bfb4, 1 instruction(s), falls into the block at 0x0048c0a6
    {load} xor eax, eax                          # 0048c0a4
L_0048c0a6:
    # block 0x0048c0a6: entered by jmp at 0x0048be57; jmp at 0x0048bf86; jmp at 0x0048c09d, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0048c0a6
    pop ebp                                      # 0048c0a8
    ret 0x8                                      # 0048c0a9

