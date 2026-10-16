# FUN_00487b4f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487b4f
# extent:       0x00487b4f-0x00487b98 (73 code bytes)
# span:         0x00487b4f-0x00487b98 (code 73, tables 0, padding 0)
# sha256:       2b9bd251b9620dd3ef7f8a1051f367f06e18d7927e78d929072ad6634fba753d
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00487b4f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_00487b1a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_00487b1a, .text + (0x00487b1a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00487b4f - 0x401000
.globl FUN_00487b4f
FUN_00487b4f:
    # block 0x00487b4f: entry, 7 instruction(s), ends with je to 0x00487b70 (forward)
    push ebp                                     # 00487b4f
    {load} mov ebp, esp                          # 00487b50
    push ecx                                     # 00487b52
    mov dword ptr [ebp - local_4], ecx           # 00487b53
    mov eax, dword ptr [ebp - local_4]           # 00487b56
    cmp dword ptr [eax + field_20], 0x0          # 00487b59
    je.d8 L_00487b70                             # 00487b5d
    # block 0x00487b5f: entered by fall-through of je at 0x00487b5d, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00487b70
    mov ecx, dword ptr [ebp - local_4]           # 00487b5f
    add ecx, 0x20                                # 00487b62
    push ecx                                     # 00487b65
    mov ecx, 0x5cf659                            # 00487b66
    call FUN_004c2dfb                            # 00487b6b
L_00487b70:
    # block 0x00487b70: entered by je at 0x00487b5d, 4 instruction(s), ends with je to 0x00487b8c (forward)
    mov edx, dword ptr [ebp - local_4]           # 00487b70
    movsx eax, word ptr [edx + field_1c]         # 00487b73
    cmp eax, -0x1                                # 00487b77
    je.d8 L_00487b8c                             # 00487b7a
    # block 0x00487b7c: entered by fall-through of je at 0x00487b7a, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x00487b8c
    mov ecx, dword ptr [ebp - local_4]           # 00487b7c
    mov dx, word ptr [ecx + field_1c]            # 00487b7f
    push edx                                     # 00487b83
    call FUN_004d3992                            # 00487b84
    add esp, 0x4                                 # 00487b89
L_00487b8c:
    # block 0x00487b8c: entered by je at 0x00487b7a, 5 instruction(s), calls FUN_00487b1a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00487b8c
    call FUN_00487b1a                            # 00487b8f
    {load} mov esp, ebp                          # 00487b94
    pop ebp                                      # 00487b96
    ret                                          # 00487b97

