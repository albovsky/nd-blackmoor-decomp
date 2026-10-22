# FUN_004d6787
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d6787
# extent:       0x004d6787-0x004d6824 (157 code bytes)
# span:         0x004d6787-0x004d6824 (code 157, tables 0, padding 0)
# sha256:       2d3f72658c75538e7c047e4ffc6061de23dc7c8f99d9e8722281ff826f5034f8
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d6787_lifted
# naming:       native port src/original_methods_fl39d.c:m4d6787_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_2b6; [ecx + n] field_2b4; [edx + n] field_955a
# callees:      calls FUN_00425fc0, FUN_0043da93, FUN_004c924d, FUN_004d8f0a, FUN_004d88de, FUN_004d8618, FUN_004dad60
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4d6787_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 38 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_2b4, 0x2b4  # offset +0x2b4
.equ field_2b6, 0x2b6  # offset +0x2b6
.equ field_955a, 0x955a  # offset +0x955a

# --- external targets -----------------------------------------------
.set FUN_00425fc0, .text + (0x00425fc0 - 0x401000)
.set FUN_0043da93, .text + (0x0043da93 - 0x401000)
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004d8618, .text + (0x004d8618 - 0x401000)
.set FUN_004d88de, .text + (0x004d88de - 0x401000)
.set FUN_004d8f0a, .text + (0x004d8f0a - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)

.org 0x004d6787 - 0x401000
.globl FUN_004d6787
FUN_004d6787:
    # block 0x004d6787: entry, 8 instruction(s), ends with je to 0x004d67a5 (forward)
    push ebp                                     # 004d6787
    {load} mov ebp, esp                          # 004d6788
    push ecx                                     # 004d678a
    mov dword ptr [ebp - local_4], ecx           # 004d678b
    {load} xor eax, eax                          # 004d678e
    mov al, byte ptr [0x58320d]                  # 004d6790
    test eax, eax                                # 004d6795
    je.d8 L_004d67a5                             # 004d6797
    # block 0x004d6799: entered by fall-through of je at 0x004d6797, 2 instruction(s), calls FUN_00425fc0, falls into the block at 0x004d67a5
    mov byte ptr [0x58320d], 0x0                 # 004d6799
    call FUN_00425fc0                            # 004d67a0
L_004d67a5:
    # block 0x004d67a5: entered by je at 0x004d6797, 28 instruction(s), calls FUN_0043da93, FUN_004c924d, FUN_004d8f0a, FUN_004d88de, FUN_004d8618, FUN_004dad60, ends with ret
    call FUN_0043da93                            # 004d67a5
    mov dword ptr [0x5d17f5], 0x0                # 004d67aa
    mov ecx, dword ptr [ebp - local_4]           # 004d67b4
    mov dx, word ptr [ecx + field_2b4]           # 004d67b7
    push edx                                     # 004d67be
    mov ecx, 0x5cf659                            # 004d67bf
    call FUN_004c924d                            # 004d67c4
    mov eax, dword ptr [ebp - local_4]           # 004d67c9
    mov cx, word ptr [eax + field_2b6]           # 004d67cc
    push ecx                                     # 004d67d3
    mov ecx, 0x5cf659                            # 004d67d4
    call FUN_004c924d                            # 004d67d9
    mov ecx, dword ptr [ebp - local_4]           # 004d67de
    call FUN_004d8f0a                            # 004d67e1
    mov ecx, dword ptr [ebp - local_4]           # 004d67e6
    call FUN_004d88de                            # 004d67e9
    mov edx, dword ptr [ebp - local_4]           # 004d67ee
    mov dword ptr [edx + field_955a], 0x0        # 004d67f1
    mov ecx, dword ptr [ebp - local_4]           # 004d67fb
    call FUN_004d8618                            # 004d67fe
    mov ecx, 0x5830a6                            # 004d6803
    call FUN_004dad60                            # 004d6808
    mov word ptr [0x63a998], 0x17                # 004d680d
    mov eax, dword ptr [ebp - local_4]           # 004d6816
    mov dword ptr [eax + field_4], 0x1           # 004d6819
    {load} mov esp, ebp                          # 004d6820
    pop ebp                                      # 004d6822
    ret                                          # 004d6823

