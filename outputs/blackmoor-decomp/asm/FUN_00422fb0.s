# FUN_00422fb0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00422fb0
# extent:       0x00422fb0-0x00422fde (46 code bytes)
# span:         0x00422fb0-0x00422fe0 (code 46, tables 0, padding 2)
# sha256:       9b07b0271b745ff9110d4513fc8f6870c4ae470c8a557be784cbf21a49b0a9f5
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00422fb0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0041bebc, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0041bebc, .text + (0x0041bebc - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00422fb0 - 0x401000
.globl FUN_00422fb0
FUN_00422fb0:
    # block 0x00422fb0: entry, 10 instruction(s), calls FUN_0041bebc, ends with je to 0x00422fd5 (forward)
    push ebp                                     # 00422fb0
    {load} mov ebp, esp                          # 00422fb1
    push ecx                                     # 00422fb3
    mov dword ptr [ebp - local_4], ecx           # 00422fb4
    mov ecx, dword ptr [ebp - local_4]           # 00422fb7
    call FUN_0041bebc                            # 00422fba
    mov eax, dword ptr [ebp + arg_8]             # 00422fbf
    and eax, 0x1                                 # 00422fc2
    test eax, eax                                # 00422fc5
    je.d8 L_00422fd5                             # 00422fc7
    # block 0x00422fc9: entered by fall-through of je at 0x00422fc7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00422fd5
    mov ecx, dword ptr [ebp - local_4]           # 00422fc9
    push ecx                                     # 00422fcc
    call FUN_0051dc6c                            # 00422fcd
    add esp, 0x4                                 # 00422fd2
L_00422fd5:
    # block 0x00422fd5: entered by je at 0x00422fc7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00422fd5
    {load} mov esp, ebp                          # 00422fd8
    pop ebp                                      # 00422fda
    ret 0x4                                      # 00422fdb

# --- data items (not part of the function) -------------------------
.org 0x00422fde - 0x401000
PAD_00422fde:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

