# FUN_004ed9e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ed9e0
# extent:       0x004ed9e0-0x004eda0e (46 code bytes)
# span:         0x004ed9e0-0x004eda10 (code 46, tables 0, padding 2)
# sha256:       273db218eea9b1c68a4969b567822c6f5ec9a1e9341c061c22877d37b097bfa3
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ed9e0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4ed9e0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4eb8fe(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004eb8fe, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4ed9e0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004eb8fe, .text + (0x004eb8fe - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004ed9e0 - 0x401000
.globl FUN_004ed9e0
FUN_004ed9e0:
    # block 0x004ed9e0: entry, 10 instruction(s), calls FUN_004eb8fe, ends with je to 0x004eda05 (forward)
    push ebp                                     # 004ed9e0
    {load} mov ebp, esp                          # 004ed9e1
    push ecx                                     # 004ed9e3
    mov dword ptr [ebp - local_4], ecx           # 004ed9e4
    mov ecx, dword ptr [ebp - local_4]           # 004ed9e7
    call FUN_004eb8fe                            # 004ed9ea
    mov eax, dword ptr [ebp + arg_8]             # 004ed9ef
    and eax, 0x1                                 # 004ed9f2
    test eax, eax                                # 004ed9f5
    je.d8 L_004eda05                             # 004ed9f7
    # block 0x004ed9f9: entered by fall-through of je at 0x004ed9f7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004eda05
    mov ecx, dword ptr [ebp - local_4]           # 004ed9f9
    push ecx                                     # 004ed9fc
    call FUN_0051dc6c                            # 004ed9fd
    add esp, 0x4                                 # 004eda02
L_004eda05:
    # block 0x004eda05: entered by je at 0x004ed9f7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004eda05
    {load} mov esp, ebp                          # 004eda08
    pop ebp                                      # 004eda0a
    ret 0x4                                      # 004eda0b

# --- data items (not part of the function) -------------------------
.org 0x004eda0e - 0x401000
PAD_004eda0e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

