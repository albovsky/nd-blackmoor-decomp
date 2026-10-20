# FUN_004b450f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b450f
# extent:       0x004b450f-0x004b45ed (222 code bytes)
# span:         0x004b450f-0x004b45ed (code 222, tables 0, padding 0)
# sha256:       6960478f3ed685fcb1ba8ea7d9e55d4faa966452930618953b188766f65fb9cb
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b450f
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_758
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_758, 0x758  # offset +0x758

# --- external targets -----------------------------------------------

.org 0x004b450f - 0x401000
.globl FUN_004b450f
FUN_004b450f:
    # block 0x004b450f: entry, 7 instruction(s), ends with jl to 0x004b4589 (forward)
    push ebp                                     # 004b450f
    {load} mov ebp, esp                          # 004b4510
    push ecx                                     # 004b4512
    mov dword ptr [ebp - local_4], ecx           # 004b4513
    movsx eax, word ptr [ebp + arg_8]            # 004b4516
    test eax, eax                                # 004b451a
    jl.d8 L_004b4589                             # 004b451c
    # block 0x004b451e: entered by fall-through of jl at 0x004b451c, 3 instruction(s), ends with jge to 0x004b4589 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004b451e
    cmp ecx, 0x3                                 # 004b4522
    jge.d8 L_004b4589                            # 004b4525
    # block 0x004b4527: entered by fall-through of jge at 0x004b4525, 16 instruction(s), ends with forward jump to 0x004b45e7
    mov dword ptr [0x5b44f0], 0x12               # 004b4527
    mov dword ptr [0x5b44f4], 0x1                # 004b4531
    mov edx, dword ptr [0x5d0377]                # 004b453b
    mov dword ptr [0x5d162d], edx                # 004b4541
    mov eax, dword ptr [0x5b44f0]                # 004b4547
    shl eax, 0x5                                 # 004b454c
    mov ecx, dword ptr [0x5b44f4]                # 004b454f
    shl ecx, 0x4                                 # 004b4555
    lea edx, [eax + ecx + 0x5b160c]              # 004b4558
    mov dword ptr [0x5d1631], edx                # 004b455f
    mov dword ptr [0x5d1639], 0x1                # 004b4565
    mov dword ptr [0x5c39e5], 0x2738             # 004b456f
    mov eax, dword ptr [ebp - local_4]           # 004b4579
    mov cx, word ptr [ebp + arg_8]               # 004b457c
    mov word ptr [eax + field_758], cx           # 004b4580
    jmp.d8 L_004b45e7                            # 004b4587
L_004b4589:
    # block 0x004b4589: entered by jl at 0x004b451c; jge at 0x004b4525, 14 instruction(s), falls into the block at 0x004b45e7
    mov dword ptr [0x5b44f0], 0x9                # 004b4589
    mov dword ptr [0x5b44f4], 0x1                # 004b4593
    mov edx, dword ptr [0x5d0377]                # 004b459d
    mov dword ptr [0x5d162d], edx                # 004b45a3
    mov eax, dword ptr [0x5b44f0]                # 004b45a9
    shl eax, 0x5                                 # 004b45ae
    mov ecx, dword ptr [0x5b44f4]                # 004b45b1
    shl ecx, 0x4                                 # 004b45b7
    lea edx, [eax + ecx + 0x5b160c]              # 004b45ba
    mov dword ptr [0x5d1631], edx                # 004b45c1
    mov dword ptr [0x5d1639], 0x1                # 004b45c7
    mov dword ptr [0x5c39e5], 0x2739             # 004b45d1
    mov eax, dword ptr [ebp - local_4]           # 004b45db
    mov word ptr [eax + field_758], 0xffff       # 004b45de
L_004b45e7:
    # block 0x004b45e7: entered by jmp at 0x004b4587, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004b45e7
    pop ebp                                      # 004b45e9
    ret 0x4                                      # 004b45ea

