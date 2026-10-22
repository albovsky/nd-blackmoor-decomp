# FUN_004dbb13
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dbb13
# extent:       0x004dbb13-0x004dbc67 (340 code bytes)
# span:         0x004dbb13-0x004dbc77 (code 340, tables 16, padding 0)
# sha256:       bb518e68444484c1b4ee8cc7e613164e0aadb7c598d753b9cb67fcea9b83861d
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dbb13
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_18; [ecx + n] field_14; [edx + n] field_14, field_18
# callees:      calls FUN_004e779f, FUN_004e89d2, FUN_004ebd6c, FUN_004e4114, FUN_004dae88
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl33c.c:m4db38a_update_cursor (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 92 instruction(s), 5 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004e4114, .text + (0x004e4114 - 0x401000)
.set FUN_004e779f, .text + (0x004e779f - 0x401000)
.set FUN_004e89d2, .text + (0x004e89d2 - 0x401000)
.set FUN_004ebd6c, .text + (0x004ebd6c - 0x401000)

.org 0x004dbb13 - 0x401000
.globl FUN_004dbb13
FUN_004dbb13:
    # block 0x004dbb13: entry, 11 instruction(s), ends with ja to 0x004dbb3d (forward)
    push ebp                                     # 004dbb13
    {load} mov ebp, esp                          # 004dbb14
    sub esp, 0x8                                 # 004dbb16
    mov dword ptr [ebp - local_4], ecx           # 004dbb19
    mov eax, dword ptr [0x583204]                # 004dbb1c
    mov dword ptr [ebp - local_8], eax           # 004dbb21
    mov ecx, dword ptr [ebp - local_8]           # 004dbb24
    sub ecx, 0x2                                 # 004dbb27
    mov dword ptr [ebp - local_8], ecx           # 004dbb2a
    cmp dword ptr [ebp - local_8], 0x3           # 004dbb2d
    ja.d8 L_004dbb3d                             # 004dbb31
    # block 0x004dbb33: entered by fall-through of ja at 0x004dbb31, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4dbc67]
    mov edx, dword ptr [ebp - local_8]           # 004dbb33
    jmp dword ptr [4*edx + SWTAB_004dbc67_VA]    # 004dbb36
L_004dbb3d:
    # block 0x004dbb3d: entered by ja at 0x004dbb31, 9 instruction(s), ends with jl to 0x004dbb8b (forward)
    movsx eax, word ptr [0x63988b]               # 004dbb3d
    mov ecx, dword ptr [0x5b44f4]                # 004dbb44
    shl ecx, 0x2                                 # 004dbb4a
    mov edx, dword ptr [0x5b44f0]                # 004dbb4d
    movsx ecx, word ptr [ecx + 8*edx + 0x5b3790] # 004dbb53
    {load} sub eax, ecx                          # 004dbb5b
    mov edx, dword ptr [ebp - local_4]           # 004dbb5d
    cmp dword ptr [edx + field_14], eax          # 004dbb60
    jl.d8 L_004dbb8b                             # 004dbb63
    # block 0x004dbb65: entered by fall-through of jl at 0x004dbb63, 8 instruction(s), falls into the block at 0x004dbb8b
    movsx eax, word ptr [0x63988b]               # 004dbb65
    mov ecx, dword ptr [0x5b44f4]                # 004dbb6c
    shl ecx, 0x2                                 # 004dbb72
    mov edx, dword ptr [0x5b44f0]                # 004dbb75
    movsx ecx, word ptr [ecx + 8*edx + 0x5b3790] # 004dbb7b
    {load} sub eax, ecx                          # 004dbb83
    mov edx, dword ptr [ebp - local_4]           # 004dbb85
    mov dword ptr [edx + field_14], eax          # 004dbb88
L_004dbb8b:
    # block 0x004dbb8b: entered by jl at 0x004dbb63, 9 instruction(s), ends with jl to 0x004dbbd9 (forward)
    movsx eax, word ptr [0x63988d]               # 004dbb8b
    mov ecx, dword ptr [0x5b44f4]                # 004dbb92
    shl ecx, 0x2                                 # 004dbb98
    mov edx, dword ptr [0x5b44f0]                # 004dbb9b
    movsx ecx, word ptr [ecx + 8*edx + 0x5b3792] # 004dbba1
    {load} sub eax, ecx                          # 004dbba9
    mov edx, dword ptr [ebp - local_4]           # 004dbbab
    cmp dword ptr [edx + field_18], eax          # 004dbbae
    jl.d8 L_004dbbd9                             # 004dbbb1
    # block 0x004dbbb3: entered by fall-through of jl at 0x004dbbb1, 8 instruction(s), falls into the block at 0x004dbbd9
    movsx eax, word ptr [0x63988d]               # 004dbbb3
    mov ecx, dword ptr [0x5b44f4]                # 004dbbba
    shl ecx, 0x2                                 # 004dbbc0
    mov edx, dword ptr [0x5b44f0]                # 004dbbc3
    movsx ecx, word ptr [ecx + 8*edx + 0x5b3792] # 004dbbc9
    {load} sub eax, ecx                          # 004dbbd1
    mov edx, dword ptr [ebp - local_4]           # 004dbbd3
    mov dword ptr [edx + field_18], eax          # 004dbbd6
L_004dbbd9:
    # block 0x004dbbd9: entered by jl at 0x004dbbb1, 2 instruction(s), ends with je to 0x004dbbff (forward)
    cmp dword ptr [0x5c39e9], 0x0                # 004dbbd9
    je.d8 L_004dbbff                             # 004dbbe0
    # block 0x004dbbe2: entered by fall-through of je at 0x004dbbe0, 4 instruction(s), ends with jg to 0x004dbbff (forward)
    mov eax, dword ptr [ebp - local_4]           # 004dbbe2
    mov ecx, dword ptr [eax + field_18]          # 004dbbe5
    cmp ecx, dword ptr [0x5b3788]                # 004dbbe8
    jg.d8 L_004dbbff                             # 004dbbee
    # block 0x004dbbf0: entered by fall-through of jg at 0x004dbbee, 4 instruction(s), falls into the block at 0x004dbbff
    mov edx, dword ptr [0x5b3788]                # 004dbbf0
    add edx, 0x1                                 # 004dbbf6
    mov eax, dword ptr [ebp - local_4]           # 004dbbf9
    mov dword ptr [eax + field_18], edx          # 004dbbfc
L_004dbbff:
    # block 0x004dbbff: entered by je at 0x004dbbe0; jg at 0x004dbbee, 1 instruction(s), ends with forward jump to 0x004dbc4b
    jmp.d8 L_004dbc4b                            # 004dbbff
L_004dbc01:
    # block 0x004dbc01: entered by switch case, 6 instruction(s), calls FUN_004e779f, ends with forward jump to 0x004dbc4b
    mov ecx, dword ptr [ebp - local_4]           # 004dbc01
    add ecx, 0x14                                # 004dbc04
    push ecx                                     # 004dbc07
    mov ecx, 0x582711                            # 004dbc08
    call FUN_004e779f                            # 004dbc0d
    jmp.d8 L_004dbc4b                            # 004dbc12
L_004dbc14:
    # block 0x004dbc14: entered by switch case, 6 instruction(s), calls FUN_004e89d2, ends with forward jump to 0x004dbc4b
    mov edx, dword ptr [ebp - local_4]           # 004dbc14
    add edx, 0x14                                # 004dbc17
    push edx                                     # 004dbc1a
    mov ecx, 0x571442                            # 004dbc1b
    call FUN_004e89d2                            # 004dbc20
    jmp.d8 L_004dbc4b                            # 004dbc25
L_004dbc27:
    # block 0x004dbc27: entered by switch case, 6 instruction(s), calls FUN_004ebd6c, ends with forward jump to 0x004dbc4b
    mov eax, dword ptr [ebp - local_4]           # 004dbc27
    add eax, 0x14                                # 004dbc2a
    push eax                                     # 004dbc2d
    mov ecx, 0x57fd34                            # 004dbc2e
    call FUN_004ebd6c                            # 004dbc33
    jmp.d8 L_004dbc4b                            # 004dbc38
L_004dbc3a:
    # block 0x004dbc3a: entered by switch case, 5 instruction(s), calls FUN_004e4114, falls into the block at 0x004dbc4b
    mov ecx, dword ptr [ebp - local_4]           # 004dbc3a
    add ecx, 0x14                                # 004dbc3d
    push ecx                                     # 004dbc40
    mov ecx, 0x57975c                            # 004dbc41
    call FUN_004e4114                            # 004dbc46
L_004dbc4b:
    # block 0x004dbc4b: entered by jmp at 0x004dbbff; jmp at 0x004dbc12; jmp at 0x004dbc25; jmp at 0x004dbc38, 11 instruction(s), calls FUN_004dae88, ends with ret
    mov edx, dword ptr [ebp - local_4]           # 004dbc4b
    mov eax, dword ptr [edx + field_18]          # 004dbc4e
    push eax                                     # 004dbc51
    mov ecx, dword ptr [ebp - local_4]           # 004dbc52
    mov edx, dword ptr [ecx + field_14]          # 004dbc55
    push edx                                     # 004dbc58
    mov ecx, 0x5830a6                            # 004dbc59
    call FUN_004dae88                            # 004dbc5e
    {load} mov esp, ebp                          # 004dbc63
    pop ebp                                      # 004dbc65
    ret                                          # 004dbc66

# --- data items (not part of the function) -------------------------
.org 0x004dbc67 - 0x401000
SWTAB_004dbc67:  # 4 case address(es)
    .long L_004dbc01 - .text + 0x401000
    .long L_004dbc14 - .text + 0x401000
    .long L_004dbc27 - .text + 0x401000
    .long L_004dbc3a - .text + 0x401000
.set SWTAB_004dbc67_VA, SWTAB_004dbc67 - .text + 0x401000

