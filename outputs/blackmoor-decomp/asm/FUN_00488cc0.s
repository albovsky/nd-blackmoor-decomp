# FUN_00488cc0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00488cc0
# extent:       0x00488cc0-0x00488cee (46 code bytes)
# span:         0x00488cc0-0x00488cf0 (code 46, tables 0, padding 2)
# sha256:       df9ff4cea386076fbb113a116bb1b8d58fcc4a4dab21a5f69622a87ece8fb2fd
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m488cc0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m488cc0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x487afe(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00487afe, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m488cc0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00487afe, .text + (0x00487afe - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00488cc0 - 0x401000
.globl FUN_00488cc0
FUN_00488cc0:
    # block 0x00488cc0: entry, 10 instruction(s), calls FUN_00487afe, ends with je to 0x00488ce5 (forward)
    push ebp                                     # 00488cc0
    {load} mov ebp, esp                          # 00488cc1
    push ecx                                     # 00488cc3
    mov dword ptr [ebp - local_4], ecx           # 00488cc4
    mov ecx, dword ptr [ebp - local_4]           # 00488cc7
    call FUN_00487afe                            # 00488cca
    mov eax, dword ptr [ebp + arg_8]             # 00488ccf
    and eax, 0x1                                 # 00488cd2
    test eax, eax                                # 00488cd5
    je.d8 L_00488ce5                             # 00488cd7
    # block 0x00488cd9: entered by fall-through of je at 0x00488cd7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00488ce5
    mov ecx, dword ptr [ebp - local_4]           # 00488cd9
    push ecx                                     # 00488cdc
    call FUN_0051dc6c                            # 00488cdd
    add esp, 0x4                                 # 00488ce2
L_00488ce5:
    # block 0x00488ce5: entered by je at 0x00488cd7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00488ce5
    {load} mov esp, ebp                          # 00488ce8
    pop ebp                                      # 00488cea
    ret 0x4                                      # 00488ceb

# --- data items (not part of the function) -------------------------
.org 0x00488cee - 0x401000
PAD_00488cee:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

