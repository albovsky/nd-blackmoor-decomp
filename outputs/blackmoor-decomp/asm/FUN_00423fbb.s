# FUN_00423fbb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423fbb
# extent:       0x00423fbb-0x00423ff9 (62 code bytes)
# span:         0x00423fbb-0x00423ff9 (code 62, tables 0, padding 0)
# sha256:       eb8d7af48e1956312150518fd2a9baaad3c21b5ca69678ac4b18e875e04e78f8
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00423fbb
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_40; [ecx + n] field_12, field_20; [edx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/scene_conditions.h:scene_conditions_item_leaf_count (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_12, 0x12  # offset +0x12
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_40, 0x40  # offset +0x40

# --- external targets -----------------------------------------------

.org 0x00423fbb - 0x401000
.globl FUN_00423fbb
FUN_00423fbb:
    # block 0x00423fbb: entry, 7 instruction(s), ends with jne to 0x00423fda (forward)
    push ebp                                     # 00423fbb
    {load} mov ebp, esp                          # 00423fbc
    push ecx                                     # 00423fbe
    mov dword ptr [ebp - local_4], ecx           # 00423fbf
    mov eax, dword ptr [ebp + arg_8]             # 00423fc2
    cmp dword ptr [eax + field_1c], 0x0          # 00423fc5
    jne.d8 L_00423fda                            # 00423fc9
    # block 0x00423fcb: entered by fall-through of jne at 0x00423fc9, 4 instruction(s), ends with forward jump to 0x00423ff3
    mov ecx, dword ptr [ebp + arg_8]             # 00423fcb
    mov dword ptr [ecx + field_20], 0x0          # 00423fce
    or eax, -0x1                                 # 00423fd5
    jmp.d8 L_00423ff3                            # 00423fd8
L_00423fda:
    # block 0x00423fda: entered by jne at 0x00423fc9, 8 instruction(s), falls into the block at 0x00423ff3
    mov edx, dword ptr [ebp + arg_8]             # 00423fda
    mov eax, dword ptr [edx + field_1c]          # 00423fdd
    mov ecx, dword ptr [ebp + arg_8]             # 00423fe0
    mov edx, dword ptr [eax + field_40]          # 00423fe3
    mov dword ptr [ecx + field_20], edx          # 00423fe6
    mov eax, dword ptr [ebp + arg_8]             # 00423fe9
    mov ecx, dword ptr [eax + field_1c]          # 00423fec
    movsx eax, word ptr [ecx + field_12]         # 00423fef
L_00423ff3:
    # block 0x00423ff3: entered by jmp at 0x00423fd8, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00423ff3
    pop ebp                                      # 00423ff5
    ret 0x4                                      # 00423ff6

