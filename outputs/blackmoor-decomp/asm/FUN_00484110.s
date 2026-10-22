# FUN_00484110
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00484110
# extent:       0x00484110-0x004841cb (187 code bytes)
# span:         0x00484110-0x004841cb (code 187, tables 0, padding 0)
# sha256:       f2b4c99b905fd4f8d1bf46b915e7827d0a7df2b8a16d018ad593a10b25e61dd0
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m484110_clone_record
# naming:       native port src/original_methods_fl39b.c:m484110_clone_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Allocates 0xf07 bytes with 0x51dc43, stores the block to [p0], reports a null block (0x50ca3e, 0x42639d, 0x4c97b4), otherwise copies 0xf07 bytes (rep movsd, movsw, movsb) from [p1] to [p0]. All instructions run; both jump directions taken.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39b.c:m484110_clone_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00484110 - 0x401000
.globl FUN_00484110
FUN_00484110:
    # block 0x00484110: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00484177 (forward)
    push ebp                                     # 00484110
    {load} mov ebp, esp                          # 00484111
    sub esp, 0x8                                 # 00484113
    push esi                                     # 00484116
    push edi                                     # 00484117
    mov dword ptr [ebp - local_8], ecx           # 00484118
    push 0xf07                                   # 0048411b
    call FUN_0051dc43                            # 00484120
    add esp, 0x4                                 # 00484125
    mov dword ptr [ebp - local_4], eax           # 00484128
    mov eax, dword ptr [ebp + arg_8]             # 0048412b
    mov ecx, dword ptr [ebp - local_4]           # 0048412e
    mov dword ptr [eax], ecx                     # 00484131
    cmp dword ptr [ebp - local_4], 0x0           # 00484133
    jne.d8 L_00484177                            # 00484137
    # block 0x00484139: entered by fall-through of jne at 0x00484137, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00484177
    movsx edx, word ptr [0x5c39e3]               # 00484139
    push edx                                     # 00484140
    mov eax, dword ptr [0x5bb57b]                # 00484141
    push eax                                     # 00484146
    push 0x54da20                                # 00484147
    push 0x63888b                                # 0048414c
    call FUN_0050ca3e                            # 00484151
    add esp, 0x10                                # 00484156
    push 0x63888b                                # 00484159
    push 0x54da4c                                # 0048415e
    mov ecx, 0x583979                            # 00484163
    call FUN_0042639d                            # 00484168
    mov ecx, 0x5cf659                            # 0048416d
    call FUN_004c97b4                            # 00484172
L_00484177:
    # block 0x00484177: entered by jne at 0x00484137, 21 instruction(s), ends with je to 0x004841c3 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00484177
    mov esi, dword ptr [ecx]                     # 0048417a
    mov edx, dword ptr [ebp + arg_8]             # 0048417c
    mov edi, dword ptr [edx]                     # 0048417f
    mov ecx, 0x3c1                               # 00484181
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00484186
    movsw word ptr es:[edi], word ptr [esi]      # 00484188
    movsb byte ptr es:[edi], byte ptr [esi]      # 0048418a
    mov eax, dword ptr [ebp + arg_10]            # 0048418b
    mov ecx, dword ptr [eax]                     # 0048418e
    add ecx, 0xf07                               # 00484190
    mov edx, dword ptr [ebp + arg_10]            # 00484196
    mov dword ptr [edx], ecx                     # 00484199
    mov eax, dword ptr [ebp + arg_c]             # 0048419b
    mov ecx, dword ptr [eax]                     # 0048419e
    add ecx, 0xf07                               # 004841a0
    mov edx, dword ptr [ebp + arg_c]             # 004841a6
    mov dword ptr [edx], ecx                     # 004841a9
    movsx eax, word ptr [0x63a4cd]               # 004841ab
    test eax, eax                                # 004841b2
    je.d8 L_004841c3                             # 004841b4
    # block 0x004841b6: entered by fall-through of je at 0x004841b4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004841c3
    push 0x54da68                                # 004841b6
    call FUN_0044a2b7                            # 004841bb
    add esp, 0x4                                 # 004841c0
L_004841c3:
    # block 0x004841c3: entered by je at 0x004841b4, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004841c3
    pop esi                                      # 004841c4
    {load} mov esp, ebp                          # 004841c5
    pop ebp                                      # 004841c7
    ret 0xc                                      # 004841c8

