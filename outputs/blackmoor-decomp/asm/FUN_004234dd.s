# FUN_004234dd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004234dd
# extent:       0x004234dd-0x0042356d (144 code bytes)
# span:         0x004234dd-0x0042356d (code 144, tables 0, padding 0)
# sha256:       898fa0ca170e36d30d3b16e22a6d96c6ea745ae2e83543c3fa5cd4467e94cd97
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_dependency_stack_push
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4234dd.c.txt, not original source) refers to the data labelled s_CDependency__PushStack_____ERROR_005444cc
# name-note:    CDependency::PushStack: errors out if the stack count reaches 0x80, otherwise stores two values and increments the count.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [ecx + n] field_4, field_c; [edx + n] field_4, field_10
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30c.c:m423876_unwind_chain (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 43 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004234dd - 0x401000
.globl FUN_004234dd
FUN_004234dd:
    # block 0x004234dd: entry, 7 instruction(s), ends with jl to 0x00423532 (forward)
    push ebp                                     # 004234dd
    {load} mov ebp, esp                          # 004234de
    push ecx                                     # 004234e0
    mov dword ptr [ebp - local_4], ecx           # 004234e1
    mov eax, dword ptr [ebp - local_4]           # 004234e4
    cmp dword ptr [eax + field_4], 0x80          # 004234e7
    jl.d8 L_00423532                             # 004234ee
    # block 0x004234f0: entered by fall-through of jl at 0x004234ee, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x00423528 (forward)
    push 0x5444cc                                # 004234f0
    push 0x63888b                                # 004234f5
    call FUN_0050ca3e                            # 004234fa
    add esp, 0x8                                 # 004234ff
    push 0x0                                     # 00423502
    push 0x0                                     # 00423504
    push 0x63888b                                # 00423506
    call FUN_0052139c                            # 0042350b
    movsx ecx, word ptr [0x63a4cd]               # 00423510
    test ecx, ecx                                # 00423517
    je.d8 L_00423528                             # 00423519
    # block 0x0042351b: entered by fall-through of je at 0x00423519, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00423528
    push 0x63888b                                # 0042351b
    call FUN_0044a2b7                            # 00423520
    add esp, 0x4                                 # 00423525
L_00423528:
    # block 0x00423528: entered by je at 0x00423519, 2 instruction(s), calls FUN_004c97b4, falls into the block at 0x00423532
    mov ecx, 0x5cf659                            # 00423528
    call FUN_004c97b4                            # 0042352d
L_00423532:
    # block 0x00423532: entered by jl at 0x004234ee, 20 instruction(s), ends with ret 0x8
    mov edx, dword ptr [ebp - local_4]           # 00423532
    mov eax, dword ptr [edx + field_4]           # 00423535
    imul eax, eax, 0xc                           # 00423538
    mov ecx, dword ptr [ebp - local_4]           # 0042353b
    mov edx, dword ptr [ebp + arg_8]             # 0042353e
    mov dword ptr [ecx + eax + field_c], edx     # 00423541
    mov eax, dword ptr [ebp - local_4]           # 00423545
    mov ecx, dword ptr [eax + field_4]           # 00423548
    imul ecx, ecx, 0xc                           # 0042354b
    mov edx, dword ptr [ebp - local_4]           # 0042354e
    mov eax, dword ptr [ebp + arg_c]             # 00423551
    mov dword ptr [edx + ecx + field_10], eax    # 00423554
    mov ecx, dword ptr [ebp - local_4]           # 00423558
    mov edx, dword ptr [ecx + field_4]           # 0042355b
    add edx, 0x1                                 # 0042355e
    mov eax, dword ptr [ebp - local_4]           # 00423561
    mov dword ptr [eax + field_4], edx           # 00423564
    {load} mov esp, ebp                          # 00423567
    pop ebp                                      # 00423569
    ret 0x8                                      # 0042356a

