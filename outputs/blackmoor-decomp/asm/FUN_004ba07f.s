# FUN_004ba07f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ba07f
# extent:       0x004ba07f-0x004ba13d (190 code bytes)
# span:         0x004ba07f-0x004ba13d (code 190, tables 0, padding 0)
# sha256:       0f163c787ff573c48e76f3b58ecfe0c475b73073c628e5dc2c35cdef02e0c070
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ba07f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8, field_14, field_2bc; [ecx + n] field_4, field_10, field_2bc; [edx + n] field_4, field_c
# callees:      calls FUN_004c2dfb, FUN_004be18b, FUN_004d3992, FUN_004b9e3b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 60 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_2bc, 0x2bc  # offset +0x2bc

# --- external targets -----------------------------------------------
.set FUN_004b9e3b, .text + (0x004b9e3b - 0x401000)
.set FUN_004be18b, .text + (0x004be18b - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004ba07f - 0x401000
.globl FUN_004ba07f
FUN_004ba07f:
    # block 0x004ba07f: entry, 7 instruction(s), ends with je to 0x004ba0a0 (forward)
    push ebp                                     # 004ba07f
    {load} mov ebp, esp                          # 004ba080
    push ecx                                     # 004ba082
    mov dword ptr [ebp - local_4], ecx           # 004ba083
    mov eax, dword ptr [ebp - local_4]           # 004ba086
    cmp dword ptr [eax + field_8], 0x0           # 004ba089
    je.d8 L_004ba0a0                             # 004ba08d
    # block 0x004ba08f: entered by fall-through of je at 0x004ba08d, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004ba0a0
    mov ecx, dword ptr [ebp - local_4]           # 004ba08f
    add ecx, 0x8                                 # 004ba092
    push ecx                                     # 004ba095
    mov ecx, 0x5cf659                            # 004ba096
    call FUN_004c2dfb                            # 004ba09b
L_004ba0a0:
    # block 0x004ba0a0: entered by je at 0x004ba08d, 3 instruction(s), ends with je to 0x004ba0ba (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ba0a0
    cmp dword ptr [edx + field_c], 0x0           # 004ba0a3
    je.d8 L_004ba0ba                             # 004ba0a7
    # block 0x004ba0a9: entered by fall-through of je at 0x004ba0a7, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004ba0ba
    mov eax, dword ptr [ebp - local_4]           # 004ba0a9
    add eax, 0xc                                 # 004ba0ac
    push eax                                     # 004ba0af
    mov ecx, 0x5cf659                            # 004ba0b0
    call FUN_004c2dfb                            # 004ba0b5
L_004ba0ba:
    # block 0x004ba0ba: entered by je at 0x004ba0a7, 3 instruction(s), ends with je to 0x004ba0d4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ba0ba
    cmp dword ptr [ecx + field_10], 0x0          # 004ba0bd
    je.d8 L_004ba0d4                             # 004ba0c1
    # block 0x004ba0c3: entered by fall-through of je at 0x004ba0c1, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004ba0d4
    mov edx, dword ptr [ebp - local_4]           # 004ba0c3
    add edx, 0x10                                # 004ba0c6
    push edx                                     # 004ba0c9
    mov ecx, 0x5cf659                            # 004ba0ca
    call FUN_004c2dfb                            # 004ba0cf
L_004ba0d4:
    # block 0x004ba0d4: entered by je at 0x004ba0c1, 3 instruction(s), ends with je to 0x004ba0ee (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ba0d4
    cmp dword ptr [eax + field_14], 0x0          # 004ba0d7
    je.d8 L_004ba0ee                             # 004ba0db
    # block 0x004ba0dd: entered by fall-through of je at 0x004ba0db, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004ba0ee
    mov ecx, dword ptr [ebp - local_4]           # 004ba0dd
    add ecx, 0x14                                # 004ba0e0
    push ecx                                     # 004ba0e3
    mov ecx, 0x5cf659                            # 004ba0e4
    call FUN_004c2dfb                            # 004ba0e9
L_004ba0ee:
    # block 0x004ba0ee: entered by je at 0x004ba0db, 6 instruction(s), calls FUN_004be18b, ends with je to 0x004ba112 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ba0ee
    call FUN_004be18b                            # 004ba0f1
    mov edx, dword ptr [ebp - local_4]           # 004ba0f6
    movsx eax, word ptr [edx + field_4]          # 004ba0f9
    cmp eax, -0x1                                # 004ba0fd
    je.d8 L_004ba112                             # 004ba100
    # block 0x004ba102: entered by fall-through of je at 0x004ba100, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004ba112
    mov ecx, dword ptr [ebp - local_4]           # 004ba102
    mov dx, word ptr [ecx + field_4]             # 004ba105
    push edx                                     # 004ba109
    call FUN_004d3992                            # 004ba10a
    add esp, 0x4                                 # 004ba10f
L_004ba112:
    # block 0x004ba112: entered by je at 0x004ba100, 3 instruction(s), ends with je to 0x004ba131 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ba112
    cmp dword ptr [eax + field_2bc], -0x1        # 004ba115
    je.d8 L_004ba131                             # 004ba11c
    # block 0x004ba11e: entered by fall-through of je at 0x004ba11c, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004ba131
    mov ecx, dword ptr [ebp - local_4]           # 004ba11e
    mov dx, word ptr [ecx + field_2bc]           # 004ba121
    push edx                                     # 004ba128
    call FUN_004d3992                            # 004ba129
    add esp, 0x4                                 # 004ba12e
L_004ba131:
    # block 0x004ba131: entered by je at 0x004ba11c, 5 instruction(s), calls FUN_004b9e3b, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004ba131
    call FUN_004b9e3b                            # 004ba134
    {load} mov esp, ebp                          # 004ba139
    pop ebp                                      # 004ba13b
    ret                                          # 004ba13c

