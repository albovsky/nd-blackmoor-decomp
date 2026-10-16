# FUN_004b9dd0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b9dd0
# extent:       0x004b9dd0-0x004b9dfe (46 code bytes)
# span:         0x004b9dd0-0x004b9e00 (code 46, tables 0, padding 2)
# sha256:       0a4118cd7c135de57daa120fd89f7c12c9565c354ac0e3987f3a92f91717e123
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b9dd0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004b7f1f, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004b7f1f, .text + (0x004b7f1f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004b9dd0 - 0x401000
.globl FUN_004b9dd0
FUN_004b9dd0:
    # block 0x004b9dd0: entry, 10 instruction(s), calls FUN_004b7f1f, ends with je to 0x004b9df5 (forward)
    push ebp                                     # 004b9dd0
    {load} mov ebp, esp                          # 004b9dd1
    push ecx                                     # 004b9dd3
    mov dword ptr [ebp - local_4], ecx           # 004b9dd4
    mov ecx, dword ptr [ebp - local_4]           # 004b9dd7
    call FUN_004b7f1f                            # 004b9dda
    mov eax, dword ptr [ebp + arg_8]             # 004b9ddf
    and eax, 0x1                                 # 004b9de2
    test eax, eax                                # 004b9de5
    je.d8 L_004b9df5                             # 004b9de7
    # block 0x004b9de9: entered by fall-through of je at 0x004b9de7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004b9df5
    mov ecx, dword ptr [ebp - local_4]           # 004b9de9
    push ecx                                     # 004b9dec
    call FUN_0051dc6c                            # 004b9ded
    add esp, 0x4                                 # 004b9df2
L_004b9df5:
    # block 0x004b9df5: entered by je at 0x004b9de7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004b9df5
    {load} mov esp, ebp                          # 004b9df8
    pop ebp                                      # 004b9dfa
    ret 0x4                                      # 004b9dfb

# --- data items (not part of the function) -------------------------
.org 0x004b9dfe - 0x401000
PAD_004b9dfe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

