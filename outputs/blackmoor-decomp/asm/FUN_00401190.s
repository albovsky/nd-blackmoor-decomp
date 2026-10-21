# FUN_00401190
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401190
# extent:       0x00401190-0x004011be (46 code bytes)
# span:         0x00401190-0x004011c0 (code 46, tables 0, padding 2)
# sha256:       031486508ead5fe25cd188796cc42ddd8915e166a2ef71ff862b30a189c1bcae
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401190_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m401190_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x521756(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00521756, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m401190_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_00521756, .text + (0x00521756 - 0x401000)

.org 0x00401190 - 0x401000
.globl FUN_00401190
FUN_00401190:
    # block 0x00401190: entry, 10 instruction(s), calls FUN_00521756, ends with je to 0x004011b5 (forward)
    push ebp                                     # 00401190
    {load} mov ebp, esp                          # 00401191
    push ecx                                     # 00401193
    mov dword ptr [ebp - local_4], ecx           # 00401194
    mov ecx, dword ptr [ebp - local_4]           # 00401197
    call FUN_00521756                            # 0040119a
    mov eax, dword ptr [ebp + arg_8]             # 0040119f
    and eax, 0x1                                 # 004011a2
    test eax, eax                                # 004011a5
    je.d8 L_004011b5                             # 004011a7
    # block 0x004011a9: entered by fall-through of je at 0x004011a7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004011b5
    mov ecx, dword ptr [ebp - local_4]           # 004011a9
    push ecx                                     # 004011ac
    call FUN_0051dc6c                            # 004011ad
    add esp, 0x4                                 # 004011b2
L_004011b5:
    # block 0x004011b5: entered by je at 0x004011a7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004011b5
    {load} mov esp, ebp                          # 004011b8
    pop ebp                                      # 004011ba
    ret 0x4                                      # 004011bb

# --- data items (not part of the function) -------------------------
.org 0x004011be - 0x401000
PAD_004011be:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

