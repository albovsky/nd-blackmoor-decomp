# FUN_004e7600
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7600
# extent:       0x004e7600-0x004e762e (46 code bytes)
# span:         0x004e7600-0x004e7630 (code 46, tables 0, padding 2)
# sha256:       4f5995c82ebdf7372bd4612161f000208173b4bb54a1ecdcf2f009a756bbdef1
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e7600_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4e7600_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4e2d63(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e2d63, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4e7600_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004e2d63, .text + (0x004e2d63 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004e7600 - 0x401000
.globl FUN_004e7600
FUN_004e7600:
    # block 0x004e7600: entry, 10 instruction(s), calls FUN_004e2d63, ends with je to 0x004e7625 (forward)
    push ebp                                     # 004e7600
    {load} mov ebp, esp                          # 004e7601
    push ecx                                     # 004e7603
    mov dword ptr [ebp - local_4], ecx           # 004e7604
    mov ecx, dword ptr [ebp - local_4]           # 004e7607
    call FUN_004e2d63                            # 004e760a
    mov eax, dword ptr [ebp + arg_8]             # 004e760f
    and eax, 0x1                                 # 004e7612
    test eax, eax                                # 004e7615
    je.d8 L_004e7625                             # 004e7617
    # block 0x004e7619: entered by fall-through of je at 0x004e7617, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004e7625
    mov ecx, dword ptr [ebp - local_4]           # 004e7619
    push ecx                                     # 004e761c
    call FUN_0051dc6c                            # 004e761d
    add esp, 0x4                                 # 004e7622
L_004e7625:
    # block 0x004e7625: entered by je at 0x004e7617, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004e7625
    {load} mov esp, ebp                          # 004e7628
    pop ebp                                      # 004e762a
    ret 0x4                                      # 004e762b

# --- data items (not part of the function) -------------------------
.org 0x004e762e - 0x401000
PAD_004e762e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

