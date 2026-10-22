# FUN_004fb1c6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fb1c6
# extent:       0x004fb1c6-0x004fb2a6 (224 code bytes)
# span:         0x004fb1c6-0x004fb2a6 (code 224, tables 0, padding 0)
# sha256:       75fc76a8caf6b7510bae9abdf7247d604e4f1676834d6597d20c3e23f9b8d4fb
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fb1c6
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_12c, field_132
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004f6334, FUN_004f646c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4fafc7_lifted (function ledger class candidate_port; also m4fb1c6_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 56 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_12c, 0x12c  # offset +0x12c
.equ field_132, 0x132  # offset +0x132

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004f646c, .text + (0x004f646c - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004fb1c6 - 0x401000
.globl FUN_004fb1c6
FUN_004fb1c6:
    # block 0x004fb1c6: entry, 7 instruction(s), ends with je to 0x004fb201 (forward)
    push ebp                                     # 004fb1c6
    {load} mov ebp, esp                          # 004fb1c7
    push ecx                                     # 004fb1c9
    mov dword ptr [ebp - local_4], ecx           # 004fb1ca
    movsx eax, word ptr [0x63a4cd]               # 004fb1cd
    test eax, eax                                # 004fb1d4
    je.d8 L_004fb201                             # 004fb1d6
    # block 0x004fb1d8: entered by fall-through of je at 0x004fb1d6, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fb201
    mov ecx, dword ptr [ebp + arg_8]             # 004fb1d8
    and ecx, 0xffff                              # 004fb1db
    push ecx                                     # 004fb1e1
    push 0x560720                                # 004fb1e2
    push 0x63888b                                # 004fb1e7
    call FUN_0050ca3e                            # 004fb1ec
    add esp, 0xc                                 # 004fb1f1
    push 0x63888b                                # 004fb1f4
    call FUN_0044a2b7                            # 004fb1f9
    add esp, 0x4                                 # 004fb1fe
L_004fb201:
    # block 0x004fb201: entered by je at 0x004fb1d6, 7 instruction(s), calls FUN_004f6334, ends with je to 0x004fb2a0 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004fb201
    and edx, 0xffff                              # 004fb204
    push edx                                     # 004fb20a
    mov ecx, 0x5cf1eb                            # 004fb20b
    call FUN_004f6334                            # 004fb210
    test eax, eax                                # 004fb215
    je.d32 L_004fb2a0                            # 004fb217
    # block 0x004fb21d: entered by fall-through of je at 0x004fb217, 3 instruction(s), ends with je to 0x004fb251 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004fb21d
    test eax, eax                                # 004fb224
    je.d8 L_004fb251                             # 004fb226
    # block 0x004fb228: entered by fall-through of je at 0x004fb226, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fb251
    mov ecx, dword ptr [ebp + arg_8]             # 004fb228
    and ecx, 0xffff                              # 004fb22b
    push ecx                                     # 004fb231
    push 0x56075c                                # 004fb232
    push 0x63888b                                # 004fb237
    call FUN_0050ca3e                            # 004fb23c
    add esp, 0xc                                 # 004fb241
    push 0x63888b                                # 004fb244
    call FUN_0044a2b7                            # 004fb249
    add esp, 0x4                                 # 004fb24e
L_004fb251:
    # block 0x004fb251: entered by je at 0x004fb226, 16 instruction(s), calls FUN_004f646c, falls into the block at 0x004fb2a0
    mov edx, dword ptr [ebp + arg_8]             # 004fb251
    and edx, 0xffff                              # 004fb254
    imul edx, edx, 0x5bb                         # 004fb25a
    mov eax, dword ptr [ebp - local_4]           # 004fb260
    mov dword ptr [eax + edx + field_12c], 0x1   # 004fb263
    push 0x0                                     # 004fb26e
    mov ecx, dword ptr [ebp + arg_8]             # 004fb270
    and ecx, 0xffff                              # 004fb273
    push ecx                                     # 004fb279
    mov ecx, 0x5cf1eb                            # 004fb27a
    call FUN_004f646c                            # 004fb27f
    mov edx, dword ptr [ebp + arg_8]             # 004fb284
    and edx, 0xffff                              # 004fb287
    imul edx, edx, 0x5bb                         # 004fb28d
    mov eax, dword ptr [ebp - local_4]           # 004fb293
    mov word ptr [eax + edx + field_132], 0x2    # 004fb296
L_004fb2a0:
    # block 0x004fb2a0: entered by je at 0x004fb217, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004fb2a0
    pop ebp                                      # 004fb2a2
    ret 0x4                                      # 004fb2a3

