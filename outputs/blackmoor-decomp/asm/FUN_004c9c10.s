# FUN_004c9c10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c9c10
# extent:       0x004c9c10-0x004c9ca0 (144 code bytes)
# span:         0x004c9c10-0x004c9ca0 (code 144, tables 0, padding 0)
# sha256:       ed7f87c0c6cfb92b37b5a73a9d03984d7457e5285f733f66d04c48b316f22876
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c9c10_lifted
# naming:       native port src/original_methods_fl39d.c:m4c9c10_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_1f24
# callees:      calls FUN_0050cd72, FUN_0050d0a9, FUN_0050e493, FUN_0050cee4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4c9c10_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1f24, 0x1f24  # offset +0x1f24

# --- external targets -----------------------------------------------
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050e493, .text + (0x0050e493 - 0x401000)

.org 0x004c9c10 - 0x401000
.globl FUN_004c9c10
FUN_004c9c10:
    # block 0x004c9c10: entry, 18 instruction(s), calls FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x004c9c59 (forward)
    push ebp                                     # 004c9c10
    {load} mov ebp, esp                          # 004c9c11
    sub esp, 0x8                                 # 004c9c13
    mov dword ptr [ebp - local_8], ecx           # 004c9c16
    push 0x557ca8                                # 004c9c19
    push 0x557cb0                                # 004c9c1e
    push 0x639aa2                                # 004c9c23
    push 0x639a9f                                # 004c9c28
    push 0x63888b                                # 004c9c2d
    call FUN_0050cd72                            # 004c9c32
    add esp, 0x14                                # 004c9c37
    push 0x557cb8                                # 004c9c3a
    push 0x63888b                                # 004c9c3f
    call FUN_0050d0a9                            # 004c9c44
    add esp, 0x8                                 # 004c9c49
    mov dword ptr [ebp - local_4], eax           # 004c9c4c
    cmp dword ptr [ebp - local_4], 0x0           # 004c9c4f
    jne.d8 L_004c9c59                            # 004c9c53
    # block 0x004c9c55: entered by fall-through of jne at 0x004c9c53, 2 instruction(s), ends with forward jump to 0x004c9c9c
    {load} xor eax, eax                          # 004c9c55
    jmp.d8 L_004c9c9c                            # 004c9c57
L_004c9c59:
    # block 0x004c9c59: entered by jne at 0x004c9c53, 11 instruction(s), calls FUN_0050e493, ends with je to 0x004c9c8b (forward)
    mov eax, dword ptr [ebp - local_4]           # 004c9c59
    push eax                                     # 004c9c5c
    push 0x1                                     # 004c9c5d
    push 0x1764                                  # 004c9c5f
    mov ecx, dword ptr [ebp - local_8]           # 004c9c64
    mov edx, dword ptr [ecx + field_1f24]        # 004c9c67
    push edx                                     # 004c9c6d
    call FUN_0050e493                            # 004c9c6e
    add esp, 0x10                                # 004c9c73
    cmp eax, 0x1                                 # 004c9c76
    je.d8 L_004c9c8b                             # 004c9c79
    # block 0x004c9c7b: entered by fall-through of je at 0x004c9c79, 6 instruction(s), calls FUN_0050cee4, ends with forward jump to 0x004c9c9c
    mov eax, dword ptr [ebp - local_4]           # 004c9c7b
    push eax                                     # 004c9c7e
    call FUN_0050cee4                            # 004c9c7f
    add esp, 0x4                                 # 004c9c84
    {load} xor eax, eax                          # 004c9c87
    jmp.d8 L_004c9c9c                            # 004c9c89
L_004c9c8b:
    # block 0x004c9c8b: entered by je at 0x004c9c79, 5 instruction(s), calls FUN_0050cee4, falls into the block at 0x004c9c9c
    mov ecx, dword ptr [ebp - local_4]           # 004c9c8b
    push ecx                                     # 004c9c8e
    call FUN_0050cee4                            # 004c9c8f
    add esp, 0x4                                 # 004c9c94
    mov eax, 0x1                                 # 004c9c97
L_004c9c9c:
    # block 0x004c9c9c: entered by jmp at 0x004c9c57; jmp at 0x004c9c89, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004c9c9c
    pop ebp                                      # 004c9c9e
    ret                                          # 004c9c9f

