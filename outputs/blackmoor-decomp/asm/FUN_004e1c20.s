# FUN_004e1c20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e1c20
# extent:       0x004e1c20-0x004e1c4e (46 code bytes)
# span:         0x004e1c20-0x004e1c50 (code 46, tables 0, padding 2)
# sha256:       1a7bc4bfaf5d3e387fd5e7b42d479829e2a5429e43fe175e2554ce2d2757da49
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e1c20
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e048f, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004e048f, .text + (0x004e048f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004e1c20 - 0x401000
.globl FUN_004e1c20
FUN_004e1c20:
    # block 0x004e1c20: entry, 10 instruction(s), calls FUN_004e048f, ends with je to 0x004e1c45 (forward)
    push ebp                                     # 004e1c20
    {load} mov ebp, esp                          # 004e1c21
    push ecx                                     # 004e1c23
    mov dword ptr [ebp - local_4], ecx           # 004e1c24
    mov ecx, dword ptr [ebp - local_4]           # 004e1c27
    call FUN_004e048f                            # 004e1c2a
    mov eax, dword ptr [ebp + arg_8]             # 004e1c2f
    and eax, 0x1                                 # 004e1c32
    test eax, eax                                # 004e1c35
    je.d8 L_004e1c45                             # 004e1c37
    # block 0x004e1c39: entered by fall-through of je at 0x004e1c37, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004e1c45
    mov ecx, dword ptr [ebp - local_4]           # 004e1c39
    push ecx                                     # 004e1c3c
    call FUN_0051dc6c                            # 004e1c3d
    add esp, 0x4                                 # 004e1c42
L_004e1c45:
    # block 0x004e1c45: entered by je at 0x004e1c37, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004e1c45
    {load} mov esp, ebp                          # 004e1c48
    pop ebp                                      # 004e1c4a
    ret 0x4                                      # 004e1c4b

# --- data items (not part of the function) -------------------------
.org 0x004e1c4e - 0x401000
PAD_004e1c4e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

