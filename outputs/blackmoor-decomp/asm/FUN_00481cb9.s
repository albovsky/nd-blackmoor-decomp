# FUN_00481cb9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00481cb9
# extent:       0x00481cb9-0x00482054 (923 code bytes)
# span:         0x00481cb9-0x00482060 (code 923, tables 0, padding 12)
# sha256:       d8fa449b774c615e75b3f0feef7343dc893a1fff6f122c5e6018db9dd8ad9a5f
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m481cb9_draw_cells
# naming:       native port src/original_methods_fl20c.c:m481cb9_draw_cells (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m481cb9_draw_cells. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 923 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_28
# fields:       [eax + n] field_22, field_23; [ecx + n] field_22, field_23, field_24, field_99, field_c9; [edx + n] field_23, field_99
# callees:      calls FUN_004c5377, FUN_0047e52f, FUN_004c5d4b, FUN_0047e99e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20c.c:m481cb9_draw_cells (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 256 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ local_28, 0x28  # offset -0x28
.equ field_22, 0x22  # offset +0x22
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_99, 0x99  # offset +0x99
.equ field_c9, 0xc9  # offset +0xc9

# --- external targets -----------------------------------------------
.set FUN_0047e52f, .text + (0x0047e52f - 0x401000)
.set FUN_0047e99e, .text + (0x0047e99e - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x00481cb9 - 0x401000
.globl FUN_00481cb9
FUN_00481cb9:
    # block 0x00481cb9: entry, 9 instruction(s), ends with jne to 0x00481ce7 (forward)
    push ebp                                     # 00481cb9
    {load} mov ebp, esp                          # 00481cba
    sub esp, 0x28                                # 00481cbc
    movsx eax, word ptr [0x625f06]               # 00481cbf
    imul eax, eax, 0x8d                          # 00481cc6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00481ccc
    mov dword ptr [ebp - local_c], ecx           # 00481cd2
    cmp dword ptr [0x627230], 0x0                # 00481cd5
    jne.d8 L_00481ce7                            # 00481cdc
    # block 0x00481cde: entered by fall-through of jne at 0x00481cdc, 2 instruction(s), ends with je to 0x00481d17 (forward)
    cmp dword ptr [0x62722c], 0x0                # 00481cde
    je.d8 L_00481d17                             # 00481ce5
L_00481ce7:
    # block 0x00481ce7: entered by jne at 0x00481cdc; fall-through of je at 0x00481ce5, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x00481d17
    push 0x54d6e8                                # 00481ce7
    push 0x62725a                                # 00481cec
    push 0x62723a                                # 00481cf1
    mov edx, dword ptr [0x5cf665]                # 00481cf6
    push edx                                     # 00481cfc
    mov eax, dword ptr [0x5d15e3]                # 00481cfd
    push eax                                     # 00481d02
    mov ecx, 0x5cf659                            # 00481d03
    call FUN_004c5377                            # 00481d08
    mov dword ptr [0x627230], 0x0                # 00481d0d
L_00481d17:
    # block 0x00481d17: entered by je at 0x00481ce5, 2 instruction(s), ends with je to 0x00481d62 (forward)
    cmp dword ptr [0x627234], 0x0                # 00481d17
    je.d8 L_00481d62                             # 00481d1e
    # block 0x00481d20: entered by fall-through of je at 0x00481d1e, 16 instruction(s), calls FUN_0047e52f, FUN_004c5377, falls into the block at 0x00481d62
    lea ecx, [ebp - local_28]                    # 00481d20
    push ecx                                     # 00481d23
    push 0x62727a                                # 00481d24
    mov ecx, 0x625ee8                            # 00481d29
    call FUN_0047e52f                            # 00481d2e
    push 0x54d720                                # 00481d33
    lea edx, [ebp - local_28]                    # 00481d38
    push edx                                     # 00481d3b
    push 0x62727a                                # 00481d3c
    mov eax, dword ptr [0x5cf665]                # 00481d41
    push eax                                     # 00481d46
    mov ecx, dword ptr [0x5d15e3]                # 00481d47
    push ecx                                     # 00481d4d
    mov ecx, 0x5cf659                            # 00481d4e
    call FUN_004c5377                            # 00481d53
    mov dword ptr [0x627234], 0x0                # 00481d58
L_00481d62:
    # block 0x00481d62: entered by je at 0x00481d1e, 4 instruction(s), ends with je to 0x00481d82 (forward)
    mov dx, word ptr [0x62728a]                  # 00481d62
    mov word ptr [ebp - local_18], dx            # 00481d69
    cmp dword ptr [0x62722c], 0x0                # 00481d6d
    je.d8 L_00481d82                             # 00481d74
    # block 0x00481d76: entered by fall-through of je at 0x00481d74, 3 instruction(s), falls into the block at 0x00481d82
    mov ax, word ptr [ebp - local_18]            # 00481d76
    .insn 0x66, 0x2d, 0x0001{:u16}               # 00481d7a
    mov word ptr [ebp - local_18], ax            # 00481d7e
L_00481d82:
    # block 0x00481d82: entered by je at 0x00481d74, 3 instruction(s), ends with forward jump to 0x00481d9c
    mov word ptr [ebp - local_4], 0x0            # 00481d82
    mov word ptr [ebp - local_10], 0x0           # 00481d88
    jmp.d8 L_00481d9c                            # 00481d8e
L_00481d90:
    # block 0x00481d90: entered by jmp at 0x00481ef0, 3 instruction(s), falls into the block at 0x00481d9c
    mov cx, word ptr [ebp - local_4]             # 00481d90
    add cx, 0x1                                  # 00481d94
    mov word ptr [ebp - local_4], cx             # 00481d98
L_00481d9c:
    # block 0x00481d9c: entered by jmp at 0x00481d8e, 4 instruction(s), ends with je to 0x00481ef5 (forward)
    movsx edx, word ptr [ebp - local_10]         # 00481d9c
    movsx eax, word ptr [ebp - local_18]         # 00481da0
    {load} cmp edx, eax                          # 00481da4
    je.d32 L_00481ef5                            # 00481da6
    # block 0x00481dac: entered by fall-through of je at 0x00481da6, 2 instruction(s), ends with forward jump to 0x00481dc0
    mov word ptr [ebp - local_8], 0x0            # 00481dac
    jmp.d8 L_00481dc0                            # 00481db2
L_00481db4:
    # block 0x00481db4: entered by jmp at 0x00481deb; jmp at 0x00481eeb, 3 instruction(s), falls into the block at 0x00481dc0
    mov cx, word ptr [ebp - local_8]             # 00481db4
    add cx, 0x1                                  # 00481db8
    mov word ptr [ebp - local_8], cx             # 00481dbc
L_00481dc0:
    # block 0x00481dc0: entered by jmp at 0x00481db2, 4 instruction(s), ends with jge to 0x00481ef0 (forward)
    movsx edx, word ptr [ebp - local_8]          # 00481dc0
    movsx eax, word ptr [0x62728a]               # 00481dc4
    {load} cmp edx, eax                          # 00481dcb
    jge.d32 L_00481ef0                           # 00481dcd
    # block 0x00481dd3: entered by fall-through of jge at 0x00481dcd, 2 instruction(s), ends with je to 0x00481ded (forward)
    cmp dword ptr [0x62722c], 0x0                # 00481dd3
    je.d8 L_00481ded                             # 00481dda
    # block 0x00481ddc: entered by fall-through of je at 0x00481dda, 4 instruction(s), ends with jne to 0x00481ded (forward)
    movsx ecx, word ptr [0x627238]               # 00481ddc
    movsx edx, word ptr [ebp - local_8]          # 00481de3
    {load} cmp ecx, edx                          # 00481de7
    jne.d8 L_00481ded                            # 00481de9
    # block 0x00481deb: entered by fall-through of jne at 0x00481de9, 1 instruction(s), ends with backward jump to 0x00481db4
    jmp.d8 L_00481db4                            # 00481deb
L_00481ded:
    # block 0x00481ded: entered by je at 0x00481dda; jne at 0x00481de9, 9 instruction(s), ends with jne to 0x00481eeb (forward)
    movsx eax, word ptr [ebp - local_8]          # 00481ded
    imul eax, eax, 0x25                          # 00481df1
    add eax, 0x62669c                            # 00481df4
    mov dword ptr [ebp - local_14], eax          # 00481df9
    mov ecx, dword ptr [ebp - local_14]          # 00481dfc
    movsx edx, word ptr [ecx]                    # 00481dff
    movsx eax, word ptr [ebp - local_4]          # 00481e02
    {load} cmp edx, eax                          # 00481e06
    jne.d32 L_00481eeb                           # 00481e08
    # block 0x00481e0e: entered by fall-through of jne at 0x00481e08, 5 instruction(s), ends with je to 0x00481e74 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00481e0e
    {load} xor edx, edx                          # 00481e11
    mov dl, byte ptr [ecx + field_24]            # 00481e13
    test edx, edx                                # 00481e16
    je.d8 L_00481e74                             # 00481e18
    # block 0x00481e1a: entered by fall-through of je at 0x00481e18, 29 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x00481ed1
    push 0x54d750                                # 00481e1a
    mov eax, dword ptr [ebp - local_14]          # 00481e1f
    add eax, 0x12                                # 00481e22
    push eax                                     # 00481e25
    mov ecx, dword ptr [ebp - local_14]          # 00481e26
    {load} xor edx, edx                          # 00481e29
    mov dl, byte ptr [ecx + field_23]            # 00481e2b
    imul edx, edx, 0x60                          # 00481e2e
    mov eax, dword ptr [ebp - local_14]          # 00481e31
    {load} xor ecx, ecx                          # 00481e34
    mov cl, byte ptr [eax + field_22]            # 00481e36
    imul ecx, ecx, 0x18                          # 00481e39
    lea edx, [edx + ecx + 0x625f0c]              # 00481e3c
    push edx                                     # 00481e43
    mov eax, dword ptr [0x5cf665]                # 00481e44
    push eax                                     # 00481e49
    mov ecx, dword ptr [ebp - local_14]          # 00481e4a
    {load} xor edx, edx                          # 00481e4d
    mov dl, byte ptr [ecx + field_23]            # 00481e4f
    imul edx, edx, 0x60                          # 00481e52
    mov eax, dword ptr [ebp - local_14]          # 00481e55
    {load} xor ecx, ecx                          # 00481e58
    mov cl, byte ptr [eax + field_22]            # 00481e5a
    imul ecx, ecx, 0x18                          # 00481e5d
    mov edx, dword ptr [edx + ecx + 0x625f08]    # 00481e60
    push edx                                     # 00481e67
    mov ecx, 0x5cf659                            # 00481e68
    call FUN_004c5d4b                            # 00481e6d
    jmp.d8 L_00481ed1                            # 00481e72
L_00481e74:
    # block 0x00481e74: entered by je at 0x00481e18, 11 instruction(s), calls FUN_0047e99e, ends with je to 0x00481ed1 (forward)
    mov eax, dword ptr [ebp - local_14]          # 00481e74
    {load} xor ecx, ecx                          # 00481e77
    mov cl, byte ptr [eax + field_23]            # 00481e79
    imul ecx, ecx, 0x53                          # 00481e7c
    mov edx, dword ptr [ebp - local_c]           # 00481e7f
    lea eax, [edx + ecx + field_99]              # 00481e82
    push eax                                     # 00481e89
    mov ecx, 0x625ee8                            # 00481e8a
    call FUN_0047e99e                            # 00481e8f
    test eax, eax                                # 00481e94
    je.d8 L_00481ed1                             # 00481e96
    # block 0x00481e98: entered by fall-through of je at 0x00481e96, 17 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00481ed1
    push 0x54d774                                # 00481e98
    mov ecx, dword ptr [ebp - local_14]          # 00481e9d
    add ecx, 0x12                                # 00481ea0
    push ecx                                     # 00481ea3
    mov edx, dword ptr [ebp - local_14]          # 00481ea4
    {load} xor eax, eax                          # 00481ea7
    mov al, byte ptr [edx + field_23]            # 00481ea9
    imul eax, eax, 0x53                          # 00481eac
    mov ecx, dword ptr [ebp - local_c]           # 00481eaf
    lea edx, [ecx + eax + field_99]              # 00481eb2
    push edx                                     # 00481eb9
    mov eax, dword ptr [0x5cf665]                # 00481eba
    push eax                                     # 00481ebf
    mov ecx, dword ptr [0x62728c]                # 00481ec0
    push ecx                                     # 00481ec6
    mov ecx, 0x5cf659                            # 00481ec7
    call FUN_004c5d4b                            # 00481ecc
L_00481ed1:
    # block 0x00481ed1: entered by jmp at 0x00481e72; je at 0x00481e96, 7 instruction(s), ends with jne to 0x00481eeb (forward)
    mov dx, word ptr [ebp - local_10]            # 00481ed1
    add dx, 0x1                                  # 00481ed5
    mov word ptr [ebp - local_10], dx            # 00481ed9
    movsx eax, word ptr [ebp - local_10]         # 00481edd
    movsx ecx, word ptr [ebp - local_18]         # 00481ee1
    {load} cmp eax, ecx                          # 00481ee5
    jne.d8 L_00481eeb                            # 00481ee7
    # block 0x00481ee9: entered by fall-through of jne at 0x00481ee7, 1 instruction(s), ends with forward jump to 0x00481ef0
    jmp.d8 L_00481ef0                            # 00481ee9
L_00481eeb:
    # block 0x00481eeb: entered by jne at 0x00481e08; jne at 0x00481ee7, 1 instruction(s), ends with backward jump to 0x00481db4
    jmp.d32 L_00481db4                           # 00481eeb
L_00481ef0:
    # block 0x00481ef0: entered by jge at 0x00481dcd; jmp at 0x00481ee9, 1 instruction(s), ends with backward jump to 0x00481d90
    jmp.d32 L_00481d90                           # 00481ef0
L_00481ef5:
    # block 0x00481ef5: entered by je at 0x00481da6, 2 instruction(s), ends with je to 0x00481fb2 (forward)
    cmp dword ptr [0x62722c], 0x0                # 00481ef5
    je.d32 L_00481fb2                            # 00481efc
    # block 0x00481f02: entered by fall-through of je at 0x00481efc, 8 instruction(s), ends with je to 0x00481f5b (forward)
    movsx edx, word ptr [0x627238]               # 00481f02
    imul edx, edx, 0x25                          # 00481f09
    add edx, 0x62669c                            # 00481f0c
    mov dword ptr [ebp - local_14], edx          # 00481f12
    {load} xor eax, eax                          # 00481f15
    mov al, byte ptr [0x627299]                  # 00481f17
    test eax, eax                                # 00481f1c
    je.d8 L_00481f5b                             # 00481f1e
    # block 0x00481f20: entered by fall-through of je at 0x00481f1e, 18 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x00481fb2
    push 0x54d798                                # 00481f20
    mov ecx, dword ptr [ebp - local_14]          # 00481f25
    add ecx, 0x12                                # 00481f28
    push ecx                                     # 00481f2b
    mov edx, dword ptr [ebp - local_14]          # 00481f2c
    {load} xor eax, eax                          # 00481f2f
    mov al, byte ptr [edx + field_23]            # 00481f31
    imul eax, eax, 0x53                          # 00481f34
    mov ecx, dword ptr [ebp - local_c]           # 00481f37
    lea edx, [ecx + eax + field_c9]              # 00481f3a
    push edx                                     # 00481f41
    mov eax, dword ptr [0x5cf665]                # 00481f42
    push eax                                     # 00481f47
    mov ecx, dword ptr [0x627290]                # 00481f48
    push ecx                                     # 00481f4e
    mov ecx, 0x5cf659                            # 00481f4f
    call FUN_004c5d4b                            # 00481f54
    jmp.d8 L_00481fb2                            # 00481f59
L_00481f5b:
    # block 0x00481f5b: entered by je at 0x00481f1e, 26 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00481fb2
    push 0x54d7bc                                # 00481f5b
    push 0x62726a                                # 00481f60
    mov edx, dword ptr [ebp - local_14]          # 00481f65
    {load} xor eax, eax                          # 00481f68
    mov al, byte ptr [edx + field_23]            # 00481f6a
    imul eax, eax, 0x60                          # 00481f6d
    mov ecx, dword ptr [ebp - local_14]          # 00481f70
    {load} xor edx, edx                          # 00481f73
    mov dl, byte ptr [ecx + field_22]            # 00481f75
    imul edx, edx, 0x18                          # 00481f78
    lea eax, [eax + edx + 0x625f0c]              # 00481f7b
    push eax                                     # 00481f82
    mov ecx, dword ptr [0x5cf665]                # 00481f83
    push ecx                                     # 00481f89
    mov edx, dword ptr [ebp - local_14]          # 00481f8a
    {load} xor eax, eax                          # 00481f8d
    mov al, byte ptr [edx + field_23]            # 00481f8f
    imul eax, eax, 0x60                          # 00481f92
    mov ecx, dword ptr [ebp - local_14]          # 00481f95
    {load} xor edx, edx                          # 00481f98
    mov dl, byte ptr [ecx + field_22]            # 00481f9a
    imul edx, edx, 0x18                          # 00481f9d
    mov eax, dword ptr [eax + edx + 0x625f08]    # 00481fa0
    push eax                                     # 00481fa7
    mov ecx, 0x5cf659                            # 00481fa8
    call FUN_004c5d4b                            # 00481fad
L_00481fb2:
    # block 0x00481fb2: entered by je at 0x00481efc; jmp at 0x00481f59, 4 instruction(s), ends with je to 0x00481ffc (forward)
    {load} xor ecx, ecx                          # 00481fb2
    mov cl, byte ptr [0x62729a]                  # 00481fb4
    test ecx, ecx                                # 00481fba
    je.d8 L_00481ffc                             # 00481fbc
    # block 0x00481fbe: entered by fall-through of je at 0x00481fbc, 18 instruction(s), calls FUN_0047e52f, FUN_004c5377, ends with forward jump to 0x00482050
    lea edx, [ebp - local_28]                    # 00481fbe
    push edx                                     # 00481fc1
    mov eax, dword ptr [ebp - local_c]           # 00481fc2
    add eax, 0x81                                # 00481fc5
    push eax                                     # 00481fca
    mov ecx, 0x625ee8                            # 00481fcb
    call FUN_0047e52f                            # 00481fd0
    push 0x54d7e8                                # 00481fd5
    lea ecx, [ebp - local_28]                    # 00481fda
    push ecx                                     # 00481fdd
    push 0x62729d                                # 00481fde
    mov edx, dword ptr [0x5cf665]                # 00481fe3
    push edx                                     # 00481fe9
    mov eax, dword ptr [0x627294]                # 00481fea
    push eax                                     # 00481fef
    mov ecx, 0x5cf659                            # 00481ff0
    call FUN_004c5377                            # 00481ff5
    jmp.d8 L_00482050                            # 00481ffa
L_00481ffc:
    # block 0x00481ffc: entered by je at 0x00481fbc, 4 instruction(s), ends with je to 0x00482050 (forward)
    {load} xor ecx, ecx                          # 00481ffc
    mov cl, byte ptr [0x62729b]                  # 00481ffe
    test ecx, ecx                                # 00482004
    je.d8 L_00482050                             # 00482006
    # block 0x00482008: entered by fall-through of je at 0x00482006, 20 instruction(s), calls FUN_0047e52f, FUN_004c5377, falls into the block at 0x00482050
    lea edx, [ebp - local_28]                    # 00482008
    push edx                                     # 0048200b
    mov eax, dword ptr [ebp - local_c]           # 0048200c
    add eax, 0x81                                # 0048200f
    push eax                                     # 00482014
    mov ecx, 0x625ee8                            # 00482015
    call FUN_0047e52f                            # 0048201a
    push 0x54d808                                # 0048201f
    lea ecx, [ebp - local_28]                    # 00482024
    push ecx                                     # 00482027
    mov edx, dword ptr [ebp - local_c]           # 00482028
    add edx, 0x81                                # 0048202b
    push edx                                     # 00482031
    mov eax, dword ptr [0x5cf665]                # 00482032
    push eax                                     # 00482037
    mov ecx, dword ptr [0x5d15e3]                # 00482038
    push ecx                                     # 0048203e
    mov ecx, 0x5cf659                            # 0048203f
    call FUN_004c5377                            # 00482044
    mov byte ptr [0x62729b], 0x0                 # 00482049
L_00482050:
    # block 0x00482050: entered by jmp at 0x00481ffa; je at 0x00482006, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00482050
    pop ebp                                      # 00482052
    ret                                          # 00482053

# --- data items (not part of the function) -------------------------
.org 0x00482054 - 0x401000
PAD_00482054:  # 12 byte(s) of int3 padding
    .fill 12, 1, 0xcc

