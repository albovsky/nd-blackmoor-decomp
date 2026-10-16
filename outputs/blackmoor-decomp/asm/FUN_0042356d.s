# FUN_0042356d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042356d
# extent:       0x0042356d-0x004235fd (144 code bytes)
# span:         0x0042356d-0x004235fd (code 144, tables 0, padding 0)
# sha256:       a6dc33d7551652dc77db241a4b9d86dce0b508ed4deefc755006e966dde76506
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042356d
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [ecx + n] field_4, field_8; [edx + n] field_4, field_10
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0042356d - 0x401000
.globl FUN_0042356d
FUN_0042356d:
    # block 0x0042356d: entry, 7 instruction(s), ends with jl to 0x004235c2 (forward)
    push ebp                                     # 0042356d
    {load} mov ebp, esp                          # 0042356e
    push ecx                                     # 00423570
    mov dword ptr [ebp - local_4], ecx           # 00423571
    mov eax, dword ptr [ebp - local_4]           # 00423574
    cmp dword ptr [eax + field_4], 0x80          # 00423577
    jl.d8 L_004235c2                             # 0042357e
    # block 0x00423580: entered by fall-through of jl at 0x0042357e, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x004235b8 (forward)
    push 0x544514                                # 00423580
    push 0x63888b                                # 00423585
    call FUN_0050ca3e                            # 0042358a
    add esp, 0x8                                 # 0042358f
    push 0x0                                     # 00423592
    push 0x0                                     # 00423594
    push 0x63888b                                # 00423596
    call FUN_0052139c                            # 0042359b
    movsx ecx, word ptr [0x63a4cd]               # 004235a0
    test ecx, ecx                                # 004235a7
    je.d8 L_004235b8                             # 004235a9
    # block 0x004235ab: entered by fall-through of je at 0x004235a9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004235b8
    push 0x63888b                                # 004235ab
    call FUN_0044a2b7                            # 004235b0
    add esp, 0x4                                 # 004235b5
L_004235b8:
    # block 0x004235b8: entered by je at 0x004235a9, 2 instruction(s), calls FUN_004c97b4, falls into the block at 0x004235c2
    mov ecx, 0x5cf659                            # 004235b8
    call FUN_004c97b4                            # 004235bd
L_004235c2:
    # block 0x004235c2: entered by jl at 0x0042357e, 20 instruction(s), ends with ret 0x8
    mov edx, dword ptr [ebp - local_4]           # 004235c2
    mov eax, dword ptr [edx + field_4]           # 004235c5
    imul eax, eax, 0xc                           # 004235c8
    mov ecx, dword ptr [ebp - local_4]           # 004235cb
    mov edx, dword ptr [ebp + arg_8]             # 004235ce
    mov dword ptr [ecx + eax + field_8], edx     # 004235d1
    mov eax, dword ptr [ebp - local_4]           # 004235d5
    mov ecx, dword ptr [eax + field_4]           # 004235d8
    imul ecx, ecx, 0xc                           # 004235db
    mov edx, dword ptr [ebp - local_4]           # 004235de
    mov eax, dword ptr [ebp + arg_c]             # 004235e1
    mov dword ptr [edx + ecx + field_10], eax    # 004235e4
    mov ecx, dword ptr [ebp - local_4]           # 004235e8
    mov edx, dword ptr [ecx + field_4]           # 004235eb
    add edx, 0x1                                 # 004235ee
    mov eax, dword ptr [ebp - local_4]           # 004235f1
    mov dword ptr [eax + field_4], edx           # 004235f4
    {load} mov esp, ebp                          # 004235f7
    pop ebp                                      # 004235f9
    ret 0x8                                      # 004235fa

