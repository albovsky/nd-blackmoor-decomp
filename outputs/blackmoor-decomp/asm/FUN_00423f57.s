# FUN_00423f57
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423f57
# extent:       0x00423f57-0x00423fbb (100 code bytes)
# span:         0x00423f57-0x00423fbb (code 100, tables 0, padding 0)
# sha256:       5093f0ba82e963de43e474acd41e6057604127a9ba5b035896bfe11874578aed
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00423f57
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_614; [edx + n] field_4
# callees:      calls FUN_004234c8, FUN_00424201
# track-n:      outputs/blackmoor-decomp/src/scene_conditions.h:scene_conditions_evaluate_ex (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 33 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_614, 0x614  # offset +0x614

# --- external targets -----------------------------------------------
.set FUN_004234c8, .text + (0x004234c8 - 0x401000)
.set FUN_00424201, .text + (0x00424201 - 0x401000)

.org 0x00423f57 - 0x401000
.globl FUN_00423f57
FUN_00423f57:
    # block 0x00423f57: entry, 12 instruction(s), calls FUN_004234c8, ends with je to 0x00423f9f (forward)
    push ebp                                     # 00423f57
    {load} mov ebp, esp                          # 00423f58
    push ecx                                     # 00423f5a
    mov dword ptr [ebp - local_4], ecx           # 00423f5b
    mov ecx, dword ptr [ebp - local_4]           # 00423f5e
    call FUN_004234c8                            # 00423f61
    mov eax, dword ptr [ebp - local_4]           # 00423f66
    mov ecx, dword ptr [ebp + arg_c]             # 00423f69
    mov dword ptr [eax + field_614], ecx         # 00423f6c
    mov edx, dword ptr [ebp + arg_8]             # 00423f72
    cmp dword ptr [edx + field_4], 0x0           # 00423f75
    je.d8 L_00423f9f                             # 00423f79
    # block 0x00423f7b: entered by fall-through of je at 0x00423f79, 12 instruction(s), calls FUN_00424201, ends with forward jump to 0x00423fb5
    mov eax, dword ptr [ebp + arg_8]             # 00423f7b
    push eax                                     # 00423f7e
    mov ecx, dword ptr [ebp - local_4]           # 00423f7f
    call FUN_00424201                            # 00423f82
    mov ecx, dword ptr [ebp + arg_8]             # 00423f87
    {load} xor edx, edx                          # 00423f8a
    cmp dword ptr [ecx], 0x0                     # 00423f8c
    sete dl                                      # 00423f8f
    mov dword ptr [0x5c3a47], edx                # 00423f92
    mov eax, dword ptr [ebp + arg_8]             # 00423f98
    mov eax, dword ptr [eax]                     # 00423f9b
    jmp.d8 L_00423fb5                            # 00423f9d
L_00423f9f:
    # block 0x00423f9f: entered by je at 0x00423f79, 6 instruction(s), falls into the block at 0x00423fb5
    mov ecx, dword ptr [ebp + arg_8]             # 00423f9f
    {load} xor edx, edx                          # 00423fa2
    cmp dword ptr [ecx], 0x0                     # 00423fa4
    sete dl                                      # 00423fa7
    mov dword ptr [0x5c3a47], edx                # 00423faa
    mov eax, 0x1                                 # 00423fb0
L_00423fb5:
    # block 0x00423fb5: entered by jmp at 0x00423f9d, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 00423fb5
    pop ebp                                      # 00423fb7
    ret 0x8                                      # 00423fb8

