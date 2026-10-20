# FUN_00459e49
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00459e49
# extent:       0x00459e49-0x0045a07b (562 code bytes)
# span:         0x00459e49-0x0045a07b (code 562, tables 0, padding 0)
# sha256:       ad9a49266643d573e489532fbe7bb4388cf368bf68d2f7e916e376abaf856116
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m459e49_click_2742
# naming:       native port src/original_methods_fl24b.c:m459e49_click_2742 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m459e49_click_2742 (guards, arms, host calls in order). Direct: hand-derived arms and boundaries. Unicorn differential and oracle: 480 fixtures, every code instruction reached. See tasks/fl24b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1c, field_ce, field_d6, field_217; [ecx + n] field_1c, field_1e, field_cc, field_db, field_df, field_1d6, field_207; [edx + n] field_1c, field_cc, field_df, field_e1, field_1d6, field_207
# callees:      calls FUN_004f6334, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24b.c:m459e49_click_2742 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 134 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_cc, 0xcc  # offset +0xcc
.equ field_ce, 0xce  # offset +0xce
.equ field_d6, 0xd6  # offset +0xd6
.equ field_db, 0xdb  # offset +0xdb
.equ field_df, 0xdf  # offset +0xdf
.equ field_e1, 0xe1  # offset +0xe1
.equ field_1d6, 0x1d6  # offset +0x1d6
.equ field_207, 0x207  # offset +0x207
.equ field_217, 0x217  # offset +0x217

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00459e49 - 0x401000
.globl FUN_00459e49
FUN_00459e49:
    # block 0x00459e49: entry, 11 instruction(s), ends with je to 0x0045a075 (forward)
    push ebp                                     # 00459e49
    {load} mov ebp, esp                          # 00459e4a
    sub esp, 0x10                                # 00459e4c
    push esi                                     # 00459e4f
    push edi                                     # 00459e50
    mov dword ptr [ebp - local_10], ecx          # 00459e51
    mov eax, dword ptr [ebp - local_10]          # 00459e54
    {load} xor ecx, ecx                          # 00459e57
    mov cl, byte ptr [eax + field_d6]            # 00459e59
    test ecx, ecx                                # 00459e5f
    je.d32 L_0045a075                            # 00459e61
    # block 0x00459e67: entered by fall-through of je at 0x00459e61, 5 instruction(s), ends with jne to 0x0045a075 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00459e67
    {load} xor eax, eax                          # 00459e6a
    mov al, byte ptr [edx + field_e1]            # 00459e6c
    test eax, eax                                # 00459e72
    jne.d32 L_0045a075                           # 00459e74
    # block 0x00459e7a: entered by fall-through of jne at 0x00459e74, 3 instruction(s), ends with jne to 0x0045a075 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00459e7a
    cmp dword ptr [ecx + field_db], 0x0          # 00459e7d
    jne.d32 L_0045a075                           # 00459e84
    # block 0x00459e8a: entered by fall-through of jne at 0x00459e84, 5 instruction(s), ends with jne to 0x0045a075 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00459e8a
    movsx eax, word ptr [edx + field_1c]         # 00459e8d
    imul eax, eax, 0x8d                          # 00459e91
    cmp dword ptr [eax + 0x5bb632], 0x1          # 00459e97
    jne.d32 L_0045a075                           # 00459e9e
    # block 0x00459ea4: entered by fall-through of jne at 0x00459e9e, 2 instruction(s), ends with jne to 0x0045a075 (forward)
    cmp dword ptr [0x5c39e5], 0x2742             # 00459ea4
    jne.d32 L_0045a075                           # 00459eae
    # block 0x00459eb4: entered by fall-through of jne at 0x00459eae, 9 instruction(s), ends with je to 0x00459ef1 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00459eb4
    movsx edx, word ptr [ecx + field_1c]         # 00459eb7
    imul edx, edx, 0x8d                          # 00459ebb
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00459ec1
    mov cx, word ptr [eax + field_217]           # 00459ec7
    mov word ptr [ebp - local_4], cx             # 00459ece
    movsx edx, word ptr [ebp - local_4]          # 00459ed2
    cmp edx, 0xff                                # 00459ed6
    je.d8 L_00459ef1                             # 00459edc
    # block 0x00459ede: entered by fall-through of je at 0x00459edc, 4 instruction(s), ends with jne to 0x00459fef (forward)
    movsx eax, word ptr [0x583a29]               # 00459ede
    movsx ecx, word ptr [ebp - local_4]          # 00459ee5
    {load} cmp eax, ecx                          # 00459ee9
    jne.d32 L_00459fef                           # 00459eeb
L_00459ef1:
    # block 0x00459ef1: entered by je at 0x00459edc; fall-through of jne at 0x00459eeb, 8 instruction(s), ends with jg to 0x00459f31 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00459ef1
    movsx eax, word ptr [edx + field_cc]         # 00459ef4
    mov ecx, dword ptr [ebp - local_10]          # 00459efb
    mov byte ptr [ecx + eax + field_1e], 0x1     # 00459efe
    mov edx, dword ptr [ebp - local_10]          # 00459f03
    movsx eax, word ptr [edx + field_df]         # 00459f06
    cmp eax, 0x3                                 # 00459f0d
    jg.d8 L_00459f31                             # 00459f10
    # block 0x00459f12: entered by fall-through of jg at 0x00459f10, 6 instruction(s), falls into the block at 0x00459f31
    mov ecx, dword ptr [ebp - local_10]          # 00459f12
    movsx edx, word ptr [ecx + field_df]         # 00459f15
    mov eax, dword ptr [ebp - local_10]          # 00459f1c
    mov ecx, dword ptr [ebp - local_10]          # 00459f1f
    mov cx, word ptr [ecx + field_cc]            # 00459f22
    mov word ptr [eax + 2*edx + field_ce], cx    # 00459f29
L_00459f31:
    # block 0x00459f31: entered by jg at 0x00459f10, 9 instruction(s), ends with jle to 0x00459f64 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00459f31
    mov ax, word ptr [edx + field_df]            # 00459f34
    .insn 0x66, 0x05, 0x0001{:u16}               # 00459f3b
    mov ecx, dword ptr [ebp - local_10]          # 00459f3f
    mov word ptr [ecx + field_df], ax            # 00459f42
    mov edx, dword ptr [ebp - local_10]          # 00459f49
    movsx eax, word ptr [edx + field_df]         # 00459f4c
    cmp eax, 0x4                                 # 00459f53
    jle.d8 L_00459f64                            # 00459f56
    # block 0x00459f58: entered by fall-through of jle at 0x00459f56, 2 instruction(s), falls into the block at 0x00459f64
    mov ecx, dword ptr [ebp - local_10]          # 00459f58
    mov word ptr [ecx + field_df], 0x4           # 00459f5b
L_00459f64:
    # block 0x00459f64: entered by jle at 0x00459f56, 2 instruction(s), ends with je to 0x00459fea (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 00459f64
    je.d8 L_00459fea                             # 00459f6b
    # block 0x00459f6d: entered by fall-through of je at 0x00459f6b, 10 instruction(s), ends with je to 0x00459fea (forward)
    mov edi, 0x54a7c4                            # 00459f6d
    mov edx, dword ptr [ebp - local_10]          # 00459f72
    movsx eax, word ptr [edx + field_1c]         # 00459f75
    imul eax, eax, 0x8d                          # 00459f79
    mov esi, dword ptr [eax + 0x5bb5e5]          # 00459f7f
    add esi, 0x1b5                               # 00459f85
    mov ecx, 0x9                                 # 00459f8b
    {load} xor edx, edx                          # 00459f90
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00459f92
    je.d8 L_00459fea                             # 00459f94
    # block 0x00459f96: entered by fall-through of je at 0x00459f94, 12 instruction(s), calls FUN_004f6334, ends with jne to 0x00459fea (forward)
    mov eax, dword ptr [ebp - local_10]          # 00459f96
    movsx ecx, word ptr [eax + field_1c]         # 00459f99
    imul ecx, ecx, 0x8d                          # 00459f9d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00459fa3
    movsx eax, word ptr [edx + field_1d6]        # 00459fa9
    mov dword ptr [ebp - local_8], eax           # 00459fb0
    mov ecx, dword ptr [ebp - local_8]           # 00459fb3
    push ecx                                     # 00459fb6
    mov ecx, 0x5cf1eb                            # 00459fb7
    call FUN_004f6334                            # 00459fbc
    test eax, eax                                # 00459fc1
    jne.d8 L_00459fea                            # 00459fc3
    # block 0x00459fc5: entered by fall-through of jne at 0x00459fc3, 8 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00459fea
    mov edx, dword ptr [ebp - local_10]          # 00459fc5
    movsx eax, word ptr [edx + field_1c]         # 00459fc8
    imul eax, eax, 0x8d                          # 00459fcc
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00459fd2
    mov dx, word ptr [ecx + field_1d6]           # 00459fd8
    push edx                                     # 00459fdf
    mov ecx, 0x5c3a67                            # 00459fe0
    call FUN_004fb2e3                            # 00459fe5
L_00459fea:
    # block 0x00459fea: entered by je at 0x00459f6b; je at 0x00459f94; jne at 0x00459fc3, 1 instruction(s), ends with forward jump to 0x0045a075
    jmp.d32 L_0045a075                           # 00459fea
L_00459fef:
    # block 0x00459fef: entered by jne at 0x00459eeb, 2 instruction(s), ends with je to 0x0045a075 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 00459fef
    je.d8 L_0045a075                             # 00459ff6
    # block 0x00459ff8: entered by fall-through of je at 0x00459ff6, 10 instruction(s), ends with je to 0x0045a075 (forward)
    mov edi, 0x54a7d0                            # 00459ff8
    mov eax, dword ptr [ebp - local_10]          # 00459ffd
    movsx ecx, word ptr [eax + field_1c]         # 0045a000
    imul ecx, ecx, 0x8d                          # 0045a004
    mov esi, dword ptr [ecx + 0x5bb5e5]          # 0045a00a
    add esi, 0x1e6                               # 0045a010
    mov ecx, 0x9                                 # 0045a016
    {load} xor edx, edx                          # 0045a01b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045a01d
    je.d8 L_0045a075                             # 0045a01f
    # block 0x0045a021: entered by fall-through of je at 0x0045a01f, 12 instruction(s), calls FUN_004f6334, ends with jne to 0x0045a075 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0045a021
    movsx ecx, word ptr [eax + field_1c]         # 0045a024
    imul ecx, ecx, 0x8d                          # 0045a028
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0045a02e
    movsx eax, word ptr [edx + field_207]        # 0045a034
    mov dword ptr [ebp - local_c], eax           # 0045a03b
    mov ecx, dword ptr [ebp - local_c]           # 0045a03e
    push ecx                                     # 0045a041
    mov ecx, 0x5cf1eb                            # 0045a042
    call FUN_004f6334                            # 0045a047
    test eax, eax                                # 0045a04c
    jne.d8 L_0045a075                            # 0045a04e
    # block 0x0045a050: entered by fall-through of jne at 0x0045a04e, 8 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0045a075
    mov edx, dword ptr [ebp - local_10]          # 0045a050
    movsx eax, word ptr [edx + field_1c]         # 0045a053
    imul eax, eax, 0x8d                          # 0045a057
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045a05d
    mov dx, word ptr [ecx + field_207]           # 0045a063
    push edx                                     # 0045a06a
    mov ecx, 0x5c3a67                            # 0045a06b
    call FUN_004fb2e3                            # 0045a070
L_0045a075:
    # block 0x0045a075: entered by je at 0x00459e61; jne at 0x00459e74; jne at 0x00459e84; jne at 0x00459e9e; more, 5 instruction(s), ends with ret
    pop edi                                      # 0045a075
    pop esi                                      # 0045a076
    {load} mov esp, ebp                          # 0045a077
    pop ebp                                      # 0045a079
    ret                                          # 0045a07a

