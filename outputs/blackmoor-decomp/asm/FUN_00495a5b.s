# FUN_00495a5b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00495a5b
# extent:       0x00495a5b-0x00495af3 (152 code bytes)
# span:         0x00495a5b-0x00495af3 (code 152, tables 0, padding 0)
# sha256:       730028178658eb8b746c98d04547b4bd71917cbb52b2cf3dde7d2bc91aafbd49
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m495a5b_lifted
# naming:       native port src/original_methods_fl39d.c:m495a5b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4791; [ecx + n] field_4791; [edx + n] field_4795
# callees:      calls FUN_004921a1, FUN_004922f4, FUN_0049192b, FUN_004d36ed
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m495a5b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 36 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4791, 0x4791  # offset +0x4791
.equ field_4795, 0x4795  # offset +0x4795

# --- external targets -----------------------------------------------
.set FUN_0049192b, .text + (0x0049192b - 0x401000)
.set FUN_004921a1, .text + (0x004921a1 - 0x401000)
.set FUN_004922f4, .text + (0x004922f4 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)

.org 0x00495a5b - 0x401000
.globl FUN_00495a5b
FUN_00495a5b:
    # block 0x00495a5b: entry, 13 instruction(s), ends with jge to 0x00495aa5 (forward)
    push ebp                                     # 00495a5b
    {load} mov ebp, esp                          # 00495a5c
    push ecx                                     # 00495a5e
    mov dword ptr [ebp - local_4], ecx           # 00495a5f
    mov eax, dword ptr [ebp - local_4]           # 00495a62
    mov ecx, dword ptr [eax + field_4791]        # 00495a65
    mov edx, dword ptr [ebp - local_4]           # 00495a6b
    add ecx, dword ptr [edx + field_4795]        # 00495a6e
    mov eax, dword ptr [ebp - local_4]           # 00495a74
    mov dword ptr [eax + field_4791], ecx        # 00495a77
    mov ecx, dword ptr [ebp - local_4]           # 00495a7d
    cmp dword ptr [ecx + field_4791], 0x0        # 00495a80
    jge.d8 L_00495aa5                            # 00495a87
    # block 0x00495a89: entered by fall-through of jge at 0x00495a87, 5 instruction(s), ends with forward jump to 0x00495acb
    mov edx, dword ptr [ebp - local_4]           # 00495a89
    mov dword ptr [edx + field_4795], 0x1        # 00495a8c
    mov eax, dword ptr [ebp - local_4]           # 00495a96
    mov dword ptr [eax + field_4791], 0x1        # 00495a99
    jmp.d8 L_00495acb                            # 00495aa3
L_00495aa5:
    # block 0x00495aa5: entered by jge at 0x00495a87, 3 instruction(s), ends with jl to 0x00495acb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00495aa5
    cmp dword ptr [ecx + field_4791], 0x6        # 00495aa8
    jl.d8 L_00495acb                             # 00495aaf
    # block 0x00495ab1: entered by fall-through of jl at 0x00495aaf, 4 instruction(s), falls into the block at 0x00495acb
    mov edx, dword ptr [ebp - local_4]           # 00495ab1
    mov dword ptr [edx + field_4795], 0xffffffff # 00495ab4
    mov eax, dword ptr [ebp - local_4]           # 00495abe
    mov dword ptr [eax + field_4791], 0x4        # 00495ac1
L_00495acb:
    # block 0x00495acb: entered by jmp at 0x00495aa3; jl at 0x00495aaf, 11 instruction(s), calls FUN_004921a1, FUN_004922f4, FUN_0049192b, FUN_004d36ed, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00495acb
    call FUN_004921a1                            # 00495ace
    mov ecx, dword ptr [ebp - local_4]           # 00495ad3
    call FUN_004922f4                            # 00495ad6
    mov ecx, dword ptr [ebp - local_4]           # 00495adb
    call FUN_0049192b                            # 00495ade
    call FUN_004d36ed                            # 00495ae3
    mov byte ptr [0x58322d], 0x0                 # 00495ae8
    {load} mov esp, ebp                          # 00495aef
    pop ebp                                      # 00495af1
    ret                                          # 00495af2

