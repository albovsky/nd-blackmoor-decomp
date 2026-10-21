# FUN_00456bf0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00456bf0
# extent:       0x00456bf0-0x00456c1e (46 code bytes)
# span:         0x00456bf0-0x00456c20 (code 46, tables 0, padding 2)
# sha256:       c27ae3b683015cbadeacd6b6c450b21aa2bc2703e59d083bc73172eb701e2ea7
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m456bf0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m456bf0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x454d6e(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00454d6e, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m456bf0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00454d6e, .text + (0x00454d6e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00456bf0 - 0x401000
.globl FUN_00456bf0
FUN_00456bf0:
    # block 0x00456bf0: entry, 10 instruction(s), calls FUN_00454d6e, ends with je to 0x00456c15 (forward)
    push ebp                                     # 00456bf0
    {load} mov ebp, esp                          # 00456bf1
    push ecx                                     # 00456bf3
    mov dword ptr [ebp - local_4], ecx           # 00456bf4
    mov ecx, dword ptr [ebp - local_4]           # 00456bf7
    call FUN_00454d6e                            # 00456bfa
    mov eax, dword ptr [ebp + arg_8]             # 00456bff
    and eax, 0x1                                 # 00456c02
    test eax, eax                                # 00456c05
    je.d8 L_00456c15                             # 00456c07
    # block 0x00456c09: entered by fall-through of je at 0x00456c07, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00456c15
    mov ecx, dword ptr [ebp - local_4]           # 00456c09
    push ecx                                     # 00456c0c
    call FUN_0051dc6c                            # 00456c0d
    add esp, 0x4                                 # 00456c12
L_00456c15:
    # block 0x00456c15: entered by je at 0x00456c07, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00456c15
    {load} mov esp, ebp                          # 00456c18
    pop ebp                                      # 00456c1a
    ret 0x4                                      # 00456c1b

# --- data items (not part of the function) -------------------------
.org 0x00456c1e - 0x401000
PAD_00456c1e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

