# FUN_004aa002
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004aa002
# extent:       0x004aa002-0x004aa0f0 (238 code bytes)
# span:         0x004aa002-0x004aa0f0 (code 238, tables 0, padding 0)
# sha256:       2216cbb7f1457b56b07f712e696a74c2c5637f96d81eb6823fae52beb806fa09
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004aa002
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [edx + n] field_f7
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 75 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_f7, 0xf7  # offset +0xf7

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004aa002 - 0x401000
.globl FUN_004aa002
FUN_004aa002:
    # block 0x004aa002: entry, 27 instruction(s), calls FUN_0051dc43, ends with jne to 0x004aa094 (forward)
    push ebp                                     # 004aa002
    {load} mov ebp, esp                          # 004aa003
    sub esp, 0x10                                # 004aa005
    push esi                                     # 004aa008
    push edi                                     # 004aa009
    mov dword ptr [ebp - local_10], ecx          # 004aa00a
    mov eax, dword ptr [ebp + arg_c]             # 004aa00d
    mov ecx, dword ptr [eax]                     # 004aa010
    mov dword ptr [ebp - local_8], ecx           # 004aa012
    mov edx, dword ptr [ebp - local_8]           # 004aa015
    movsx eax, word ptr [edx + field_f7]         # 004aa018
    mov ecx, 0x14                                # 004aa01f
    {load} sub ecx, eax                          # 004aa024
    imul ecx, ecx, 0x15c                         # 004aa026
    mov edx, 0x1c29                              # 004aa02c
    {load} sub edx, ecx                          # 004aa031
    mov word ptr [ebp - local_4], dx             # 004aa033
    movsx eax, word ptr [ebp - local_4]          # 004aa037
    push eax                                     # 004aa03b
    call FUN_0051dc43                            # 004aa03c
    add esp, 0x4                                 # 004aa041
    mov dword ptr [ebp - local_c], eax           # 004aa044
    mov ecx, dword ptr [ebp + arg_8]             # 004aa047
    mov edx, dword ptr [ebp - local_c]           # 004aa04a
    mov dword ptr [ecx], edx                     # 004aa04d
    cmp dword ptr [ebp - local_c], 0x0           # 004aa04f
    jne.d8 L_004aa094                            # 004aa053
    # block 0x004aa055: entered by fall-through of jne at 0x004aa053, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004aa094
    movsx eax, word ptr [0x5c39e3]               # 004aa055
    push eax                                     # 004aa05c
    mov ecx, dword ptr [0x5bb57b]                # 004aa05d
    push ecx                                     # 004aa063
    push 0x550dbc                                # 004aa064
    push 0x63888b                                # 004aa069
    call FUN_0050ca3e                            # 004aa06e
    add esp, 0x10                                # 004aa073
    push 0x63888b                                # 004aa076
    push 0x550de8                                # 004aa07b
    mov ecx, 0x583979                            # 004aa080
    call FUN_0042639d                            # 004aa085
    mov ecx, 0x5cf659                            # 004aa08a
    call FUN_004c97b4                            # 004aa08f
L_004aa094:
    # block 0x004aa094: entered by jne at 0x004aa053, 26 instruction(s), ends with je to 0x004aa0e8 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004aa094
    mov edx, dword ptr [ebp + arg_c]             # 004aa098
    mov esi, dword ptr [edx]                     # 004aa09b
    mov eax, dword ptr [ebp + arg_8]             # 004aa09d
    mov edi, dword ptr [eax]                     # 004aa0a0
    {load} mov edx, ecx                          # 004aa0a2
    shr ecx, 0x2                                 # 004aa0a4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004aa0a7
    {load} mov ecx, edx                          # 004aa0a9
    and ecx, 0x3                                 # 004aa0ab
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004aa0ae
    movsx eax, word ptr [ebp - local_4]          # 004aa0b0
    mov ecx, dword ptr [ebp + arg_10]            # 004aa0b4
    mov edx, dword ptr [ecx]                     # 004aa0b7
    {load} add edx, eax                          # 004aa0b9
    mov eax, dword ptr [ebp + arg_10]            # 004aa0bb
    mov dword ptr [eax], edx                     # 004aa0be
    movsx ecx, word ptr [ebp - local_4]          # 004aa0c0
    mov edx, dword ptr [ebp + arg_c]             # 004aa0c4
    mov eax, dword ptr [edx]                     # 004aa0c7
    {load} add eax, ecx                          # 004aa0c9
    mov ecx, dword ptr [ebp + arg_c]             # 004aa0cb
    mov dword ptr [ecx], eax                     # 004aa0ce
    movsx edx, word ptr [0x63a4cd]               # 004aa0d0
    test edx, edx                                # 004aa0d7
    je.d8 L_004aa0e8                             # 004aa0d9
    # block 0x004aa0db: entered by fall-through of je at 0x004aa0d9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004aa0e8
    push 0x550e04                                # 004aa0db
    call FUN_0044a2b7                            # 004aa0e0
    add esp, 0x4                                 # 004aa0e5
L_004aa0e8:
    # block 0x004aa0e8: entered by je at 0x004aa0d9, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004aa0e8
    pop esi                                      # 004aa0e9
    {load} mov esp, ebp                          # 004aa0ea
    pop ebp                                      # 004aa0ec
    ret 0xc                                      # 004aa0ed

