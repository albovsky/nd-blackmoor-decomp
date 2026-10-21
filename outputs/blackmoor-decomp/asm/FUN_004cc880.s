# FUN_004cc880
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cc880
# extent:       0x004cc880-0x004cc8ae (46 code bytes)
# span:         0x004cc880-0x004cc8b0 (code 46, tables 0, padding 2)
# sha256:       3bdd8e932731a04daf1cfc8c407a2cd95fafbd03c5c0427c715402bef700bb24
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cc880_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4cc880_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4caeef(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004caeef, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4cc880_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004caeef, .text + (0x004caeef - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004cc880 - 0x401000
.globl FUN_004cc880
FUN_004cc880:
    # block 0x004cc880: entry, 10 instruction(s), calls FUN_004caeef, ends with je to 0x004cc8a5 (forward)
    push ebp                                     # 004cc880
    {load} mov ebp, esp                          # 004cc881
    push ecx                                     # 004cc883
    mov dword ptr [ebp - local_4], ecx           # 004cc884
    mov ecx, dword ptr [ebp - local_4]           # 004cc887
    call FUN_004caeef                            # 004cc88a
    mov eax, dword ptr [ebp + arg_8]             # 004cc88f
    and eax, 0x1                                 # 004cc892
    test eax, eax                                # 004cc895
    je.d8 L_004cc8a5                             # 004cc897
    # block 0x004cc899: entered by fall-through of je at 0x004cc897, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004cc8a5
    mov ecx, dword ptr [ebp - local_4]           # 004cc899
    push ecx                                     # 004cc89c
    call FUN_0051dc6c                            # 004cc89d
    add esp, 0x4                                 # 004cc8a2
L_004cc8a5:
    # block 0x004cc8a5: entered by je at 0x004cc897, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004cc8a5
    {load} mov esp, ebp                          # 004cc8a8
    pop ebp                                      # 004cc8aa
    ret 0x4                                      # 004cc8ab

# --- data items (not part of the function) -------------------------
.org 0x004cc8ae - 0x401000
PAD_004cc8ae:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

