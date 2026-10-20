# FUN_0047b321
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047b321
# extent:       0x0047b321-0x0047b3bc (155 code bytes)
# span:         0x0047b321-0x0047b3bc (code 155, tables 0, padding 0)
# sha256:       0a5837e737b02db32eabbcc5e5f879eccb2bca1f7355ce1615867df99c6cba7d
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_memory_puzzle_clear
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_ee_runtime.h:239 says "0x47b321: release the surface, cells and slot, then 0x47b23b."
# name-note:    Clear of the Memory puzzle: releases surface, cells and render entry, then resets.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_14; [ecx + n] field_18; [edx + n] field_4, field_14, field_18
# callees:      calls FUN_004c2dfb, FUN_0051dc6c, FUN_004d3992, FUN_0047b23b
# track-n:      outputs/blackmoor-decomp/src/action_family_ee_runtime.c:mp_cleanup (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 50 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0047b23b, .text + (0x0047b23b - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0047b321 - 0x401000
.globl FUN_0047b321
FUN_0047b321:
    # block 0x0047b321: entry, 7 instruction(s), ends with je to 0x0047b344 (forward)
    push ebp                                     # 0047b321
    {load} mov ebp, esp                          # 0047b322
    sub esp, 0xc                                 # 0047b324
    mov dword ptr [ebp - local_c], ecx           # 0047b327
    mov eax, dword ptr [ebp - local_c]           # 0047b32a
    cmp dword ptr [eax + field_8], 0x0           # 0047b32d
    je.d8 L_0047b344                             # 0047b331
    # block 0x0047b333: entered by fall-through of je at 0x0047b331, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0047b344
    mov ecx, dword ptr [ebp - local_c]           # 0047b333
    add ecx, 0x8                                 # 0047b336
    push ecx                                     # 0047b339
    mov ecx, 0x5cf659                            # 0047b33a
    call FUN_004c2dfb                            # 0047b33f
L_0047b344:
    # block 0x0047b344: entered by je at 0x0047b331, 3 instruction(s), ends with je to 0x0047b36c (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047b344
    cmp dword ptr [edx + field_14], 0x0          # 0047b347
    je.d8 L_0047b36c                             # 0047b34b
    # block 0x0047b34d: entered by fall-through of je at 0x0047b34b, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0047b36c
    mov eax, dword ptr [ebp - local_c]           # 0047b34d
    mov ecx, dword ptr [eax + field_14]          # 0047b350
    mov dword ptr [ebp - local_4], ecx           # 0047b353
    mov edx, dword ptr [ebp - local_4]           # 0047b356
    push edx                                     # 0047b359
    call FUN_0051dc6c                            # 0047b35a
    add esp, 0x4                                 # 0047b35f
    mov eax, dword ptr [ebp - local_c]           # 0047b362
    mov dword ptr [eax + field_14], 0x0          # 0047b365
L_0047b36c:
    # block 0x0047b36c: entered by je at 0x0047b34b, 3 instruction(s), ends with je to 0x0047b394 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047b36c
    cmp dword ptr [ecx + field_18], 0x0          # 0047b36f
    je.d8 L_0047b394                             # 0047b373
    # block 0x0047b375: entered by fall-through of je at 0x0047b373, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0047b394
    mov edx, dword ptr [ebp - local_c]           # 0047b375
    mov eax, dword ptr [edx + field_18]          # 0047b378
    mov dword ptr [ebp - local_8], eax           # 0047b37b
    mov ecx, dword ptr [ebp - local_8]           # 0047b37e
    push ecx                                     # 0047b381
    call FUN_0051dc6c                            # 0047b382
    add esp, 0x4                                 # 0047b387
    mov edx, dword ptr [ebp - local_c]           # 0047b38a
    mov dword ptr [edx + field_18], 0x0          # 0047b38d
L_0047b394:
    # block 0x0047b394: entered by je at 0x0047b373, 4 instruction(s), ends with je to 0x0047b3b0 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047b394
    movsx ecx, word ptr [eax + field_4]          # 0047b397
    cmp ecx, -0x1                                # 0047b39b
    je.d8 L_0047b3b0                             # 0047b39e
    # block 0x0047b3a0: entered by fall-through of je at 0x0047b39e, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0047b3b0
    mov edx, dword ptr [ebp - local_c]           # 0047b3a0
    mov ax, word ptr [edx + field_4]             # 0047b3a3
    push eax                                     # 0047b3a7
    call FUN_004d3992                            # 0047b3a8
    add esp, 0x4                                 # 0047b3ad
L_0047b3b0:
    # block 0x0047b3b0: entered by je at 0x0047b39e, 5 instruction(s), calls FUN_0047b23b, ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 0047b3b0
    call FUN_0047b23b                            # 0047b3b3
    {load} mov esp, ebp                          # 0047b3b8
    pop ebp                                      # 0047b3ba
    ret                                          # 0047b3bb

