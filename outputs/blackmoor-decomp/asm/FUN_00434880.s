# FUN_00434880
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00434880
# extent:       0x00434880-0x004348ae (46 code bytes)
# span:         0x00434880-0x004348b0 (code 46, tables 0, padding 2)
# sha256:       555e5809b47e6f7b01636a173643019aeae226fe79fd0cb646c792cda982f36c
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00434880
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00433e63, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00433e63, .text + (0x00433e63 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00434880 - 0x401000
.globl FUN_00434880
FUN_00434880:
    # block 0x00434880: entry, 10 instruction(s), calls FUN_00433e63, ends with je to 0x004348a5 (forward)
    push ebp                                     # 00434880
    {load} mov ebp, esp                          # 00434881
    push ecx                                     # 00434883
    mov dword ptr [ebp - local_4], ecx           # 00434884
    mov ecx, dword ptr [ebp - local_4]           # 00434887
    call FUN_00433e63                            # 0043488a
    mov eax, dword ptr [ebp + arg_8]             # 0043488f
    and eax, 0x1                                 # 00434892
    test eax, eax                                # 00434895
    je.d8 L_004348a5                             # 00434897
    # block 0x00434899: entered by fall-through of je at 0x00434897, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004348a5
    mov ecx, dword ptr [ebp - local_4]           # 00434899
    push ecx                                     # 0043489c
    call FUN_0051dc6c                            # 0043489d
    add esp, 0x4                                 # 004348a2
L_004348a5:
    # block 0x004348a5: entered by je at 0x00434897, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004348a5
    {load} mov esp, ebp                          # 004348a8
    pop ebp                                      # 004348aa
    ret 0x4                                      # 004348ab

# --- data items (not part of the function) -------------------------
.org 0x004348ae - 0x401000
PAD_004348ae:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

