# FUN_004de5c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de5c0
# extent:       0x004de5c0-0x004de5ee (46 code bytes)
# span:         0x004de5c0-0x004de5f0 (code 46, tables 0, padding 2)
# sha256:       87436524d7217f7945d942707f6629033e5f8f454d7740f69b18ebdfaf75d520
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4de5c0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4de5c0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4de1a4(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004de1a4, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4de5c0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004de1a4, .text + (0x004de1a4 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004de5c0 - 0x401000
.globl FUN_004de5c0
FUN_004de5c0:
    # block 0x004de5c0: entry, 10 instruction(s), calls FUN_004de1a4, ends with je to 0x004de5e5 (forward)
    push ebp                                     # 004de5c0
    {load} mov ebp, esp                          # 004de5c1
    push ecx                                     # 004de5c3
    mov dword ptr [ebp - local_4], ecx           # 004de5c4
    mov ecx, dword ptr [ebp - local_4]           # 004de5c7
    call FUN_004de1a4                            # 004de5ca
    mov eax, dword ptr [ebp + arg_8]             # 004de5cf
    and eax, 0x1                                 # 004de5d2
    test eax, eax                                # 004de5d5
    je.d8 L_004de5e5                             # 004de5d7
    # block 0x004de5d9: entered by fall-through of je at 0x004de5d7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004de5e5
    mov ecx, dword ptr [ebp - local_4]           # 004de5d9
    push ecx                                     # 004de5dc
    call FUN_0051dc6c                            # 004de5dd
    add esp, 0x4                                 # 004de5e2
L_004de5e5:
    # block 0x004de5e5: entered by je at 0x004de5d7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004de5e5
    {load} mov esp, ebp                          # 004de5e8
    pop ebp                                      # 004de5ea
    ret 0x4                                      # 004de5eb

# --- data items (not part of the function) -------------------------
.org 0x004de5ee - 0x401000
PAD_004de5ee:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

