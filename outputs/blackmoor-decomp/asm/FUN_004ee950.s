# FUN_004ee950
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee950
# extent:       0x004ee950-0x004ee97e (46 code bytes)
# span:         0x004ee950-0x004ee980 (code 46, tables 0, padding 2)
# sha256:       e9914ff61f4a80a5c94d3ec70b3240266a9ccb1e90e4827ed82af0c3f3ec00e5
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ee950
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004eda7c, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004eda7c, .text + (0x004eda7c - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004ee950 - 0x401000
.globl FUN_004ee950
FUN_004ee950:
    # block 0x004ee950: entry, 10 instruction(s), calls FUN_004eda7c, ends with je to 0x004ee975 (forward)
    push ebp                                     # 004ee950
    {load} mov ebp, esp                          # 004ee951
    push ecx                                     # 004ee953
    mov dword ptr [ebp - local_4], ecx           # 004ee954
    mov ecx, dword ptr [ebp - local_4]           # 004ee957
    call FUN_004eda7c                            # 004ee95a
    mov eax, dword ptr [ebp + arg_8]             # 004ee95f
    and eax, 0x1                                 # 004ee962
    test eax, eax                                # 004ee965
    je.d8 L_004ee975                             # 004ee967
    # block 0x004ee969: entered by fall-through of je at 0x004ee967, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004ee975
    mov ecx, dword ptr [ebp - local_4]           # 004ee969
    push ecx                                     # 004ee96c
    call FUN_0051dc6c                            # 004ee96d
    add esp, 0x4                                 # 004ee972
L_004ee975:
    # block 0x004ee975: entered by je at 0x004ee967, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004ee975
    {load} mov esp, ebp                          # 004ee978
    pop ebp                                      # 004ee97a
    ret 0x4                                      # 004ee97b

# --- data items (not part of the function) -------------------------
.org 0x004ee97e - 0x401000
PAD_004ee97e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

