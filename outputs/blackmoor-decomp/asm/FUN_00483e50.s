# FUN_00483e50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00483e50
# extent:       0x00483e50-0x00483e7e (46 code bytes)
# span:         0x00483e50-0x00483e80 (code 46, tables 0, padding 2)
# sha256:       72eaf1ba4c90fcdb1ed4c890d423b6ce1d5b832f1f0a8b7e4958c07617a8515d
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00483e50
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0048215e, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0048215e, .text + (0x0048215e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00483e50 - 0x401000
.globl FUN_00483e50
FUN_00483e50:
    # block 0x00483e50: entry, 10 instruction(s), calls FUN_0048215e, ends with je to 0x00483e75 (forward)
    push ebp                                     # 00483e50
    {load} mov ebp, esp                          # 00483e51
    push ecx                                     # 00483e53
    mov dword ptr [ebp - local_4], ecx           # 00483e54
    mov ecx, dword ptr [ebp - local_4]           # 00483e57
    call FUN_0048215e                            # 00483e5a
    mov eax, dword ptr [ebp + arg_8]             # 00483e5f
    and eax, 0x1                                 # 00483e62
    test eax, eax                                # 00483e65
    je.d8 L_00483e75                             # 00483e67
    # block 0x00483e69: entered by fall-through of je at 0x00483e67, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00483e75
    mov ecx, dword ptr [ebp - local_4]           # 00483e69
    push ecx                                     # 00483e6c
    call FUN_0051dc6c                            # 00483e6d
    add esp, 0x4                                 # 00483e72
L_00483e75:
    # block 0x00483e75: entered by je at 0x00483e67, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00483e75
    {load} mov esp, ebp                          # 00483e78
    pop ebp                                      # 00483e7a
    ret 0x4                                      # 00483e7b

# --- data items (not part of the function) -------------------------
.org 0x00483e7e - 0x401000
PAD_00483e7e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

