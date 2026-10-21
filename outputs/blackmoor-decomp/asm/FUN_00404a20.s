# FUN_00404a20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00404a20
# extent:       0x00404a20-0x00404a4e (46 code bytes)
# span:         0x00404a20-0x00404a50 (code 46, tables 0, padding 2)
# sha256:       7e20a182468a3ef80fd67f6cdbac6156e7ce400e41009aff0f12d324ae2e0c22
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m404a20_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m404a20_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x403229(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00403229, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m404a20_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00403229, .text + (0x00403229 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00404a20 - 0x401000
.globl FUN_00404a20
FUN_00404a20:
    # block 0x00404a20: entry, 10 instruction(s), calls FUN_00403229, ends with je to 0x00404a45 (forward)
    push ebp                                     # 00404a20
    {load} mov ebp, esp                          # 00404a21
    push ecx                                     # 00404a23
    mov dword ptr [ebp - local_4], ecx           # 00404a24
    mov ecx, dword ptr [ebp - local_4]           # 00404a27
    call FUN_00403229                            # 00404a2a
    mov eax, dword ptr [ebp + arg_8]             # 00404a2f
    and eax, 0x1                                 # 00404a32
    test eax, eax                                # 00404a35
    je.d8 L_00404a45                             # 00404a37
    # block 0x00404a39: entered by fall-through of je at 0x00404a37, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00404a45
    mov ecx, dword ptr [ebp - local_4]           # 00404a39
    push ecx                                     # 00404a3c
    call FUN_0051dc6c                            # 00404a3d
    add esp, 0x4                                 # 00404a42
L_00404a45:
    # block 0x00404a45: entered by je at 0x00404a37, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00404a45
    {load} mov esp, ebp                          # 00404a48
    pop ebp                                      # 00404a4a
    ret 0x4                                      # 00404a4b

# --- data items (not part of the function) -------------------------
.org 0x00404a4e - 0x401000
PAD_00404a4e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

