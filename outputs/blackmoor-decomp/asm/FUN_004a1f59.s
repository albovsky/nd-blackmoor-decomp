# FUN_004a1f59
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1f59
# extent:       0x004a1f59-0x004a1fd1 (120 code bytes)
# span:         0x004a1f59-0x004a1fd1 (code 120, tables 0, padding 0)
# sha256:       4be5ce077515976ee1037269caad3cffc75e26d04b355321b59b78630dcd13dc
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a1f59_lifted
# naming:       native port src/original_methods_fl41.c:m4a1f59_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 18 seeds; oracle: 40/40 instructions, 14/14 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_4c, field_5f, field_60; [ecx + n] field_50, field_58; [edx + n] field_5b
# callees:      calls FUN_00437ea1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4a1f59_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 40 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_58, 0x58  # offset +0x58
.equ field_5b, 0x5b  # offset +0x5b
.equ field_5f, 0x5f  # offset +0x5f
.equ field_60, 0x60  # offset +0x60

# --- external targets -----------------------------------------------
.set FUN_00437ea1, .text + (0x00437ea1 - 0x401000)

.org 0x004a1f59 - 0x401000
.globl FUN_004a1f59
FUN_004a1f59:
    # block 0x004a1f59: entry, 7 instruction(s), ends with je to 0x004a1fcb (forward)
    push ebp                                     # 004a1f59
    {load} mov ebp, esp                          # 004a1f5a
    push ecx                                     # 004a1f5c
    mov dword ptr [ebp - local_4], ecx           # 004a1f5d
    mov eax, dword ptr [ebp - local_4]           # 004a1f60
    cmp dword ptr [eax + field_60], 0x0          # 004a1f63
    je.d8 L_004a1fcb                             # 004a1f67
    # block 0x004a1f69: entered by fall-through of je at 0x004a1f67, 5 instruction(s), ends with jne to 0x004a1fcb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a1f69
    {load} xor edx, edx                          # 004a1f6c
    mov dl, byte ptr [ecx + field_58]            # 004a1f6e
    test edx, edx                                # 004a1f71
    jne.d8 L_004a1fcb                            # 004a1f73
    # block 0x004a1f75: entered by fall-through of jne at 0x004a1f73, 3 instruction(s), ends with jne to 0x004a1fcb (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a1f75
    cmp dword ptr [eax + field_4c], 0x0          # 004a1f78
    jne.d8 L_004a1fcb                            # 004a1f7c
    # block 0x004a1f7e: entered by fall-through of jne at 0x004a1f7c, 3 instruction(s), ends with jne to 0x004a1fcb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a1f7e
    cmp dword ptr [ecx + field_50], 0x2          # 004a1f81
    jne.d8 L_004a1fcb                            # 004a1f85
    # block 0x004a1f87: entered by fall-through of jne at 0x004a1f85, 3 instruction(s), ends with jne to 0x004a1fcb (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a1f87
    cmp dword ptr [edx + field_5b], 0x0          # 004a1f8a
    jne.d8 L_004a1fcb                            # 004a1f8e
    # block 0x004a1f90: entered by fall-through of jne at 0x004a1f8e, 5 instruction(s), ends with jne to 0x004a1fcb (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a1f90
    movsx ecx, word ptr [eax + field_1e]         # 004a1f93
    imul ecx, ecx, 0x8d                          # 004a1f97
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 004a1f9d
    jne.d8 L_004a1fcb                            # 004a1fa4
    # block 0x004a1fa6: entered by fall-through of jne at 0x004a1fa4, 6 instruction(s), calls FUN_00437ea1, ends with je to 0x004a1fcb (forward)
    mov dl, byte ptr [ebp + arg_8]               # 004a1fa6
    push edx                                     # 004a1fa9
    mov ecx, 0x583208                            # 004a1faa
    call FUN_00437ea1                            # 004a1faf
    test eax, eax                                # 004a1fb4
    je.d8 L_004a1fcb                             # 004a1fb6
    # block 0x004a1fb8: entered by fall-through of je at 0x004a1fb6, 5 instruction(s), falls into the block at 0x004a1fcb
    mov eax, dword ptr [ebp - local_4]           # 004a1fb8
    mov cl, byte ptr [ebp + arg_8]               # 004a1fbb
    mov byte ptr [eax + field_5f], cl            # 004a1fbe
    mov edx, dword ptr [ebp - local_4]           # 004a1fc1
    mov dword ptr [edx + field_5b], 0x1          # 004a1fc4
L_004a1fcb:
    # block 0x004a1fcb: entered by je at 0x004a1f67; jne at 0x004a1f73; jne at 0x004a1f7c; jne at 0x004a1f85; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004a1fcb
    pop ebp                                      # 004a1fcd
    ret 0x4                                      # 004a1fce

