# FUN_004e03e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e03e0
# extent:       0x004e03e0-0x004e040e (46 code bytes)
# span:         0x004e03e0-0x004e0410 (code 46, tables 0, padding 2)
# sha256:       93c8e6fdae6b424866969ef5ee2a1853317f598c029c238b3dc8641f67b9ae50
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e03e0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4e03e0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4de66e(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004de66e, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4e03e0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004de66e, .text + (0x004de66e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004e03e0 - 0x401000
.globl FUN_004e03e0
FUN_004e03e0:
    # block 0x004e03e0: entry, 10 instruction(s), calls FUN_004de66e, ends with je to 0x004e0405 (forward)
    push ebp                                     # 004e03e0
    {load} mov ebp, esp                          # 004e03e1
    push ecx                                     # 004e03e3
    mov dword ptr [ebp - local_4], ecx           # 004e03e4
    mov ecx, dword ptr [ebp - local_4]           # 004e03e7
    call FUN_004de66e                            # 004e03ea
    mov eax, dword ptr [ebp + arg_8]             # 004e03ef
    and eax, 0x1                                 # 004e03f2
    test eax, eax                                # 004e03f5
    je.d8 L_004e0405                             # 004e03f7
    # block 0x004e03f9: entered by fall-through of je at 0x004e03f7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004e0405
    mov ecx, dword ptr [ebp - local_4]           # 004e03f9
    push ecx                                     # 004e03fc
    call FUN_0051dc6c                            # 004e03fd
    add esp, 0x4                                 # 004e0402
L_004e0405:
    # block 0x004e0405: entered by je at 0x004e03f7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004e0405
    {load} mov esp, ebp                          # 004e0408
    pop ebp                                      # 004e040a
    ret 0x4                                      # 004e040b

# --- data items (not part of the function) -------------------------
.org 0x004e040e - 0x401000
PAD_004e040e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

