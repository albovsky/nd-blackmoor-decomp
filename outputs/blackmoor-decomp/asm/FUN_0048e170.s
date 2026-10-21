# FUN_0048e170
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e170
# extent:       0x0048e170-0x0048e19e (46 code bytes)
# span:         0x0048e170-0x0048e1a0 (code 46, tables 0, padding 2)
# sha256:       4e7a1c76edcfabc994b27bc3c387f2815748d415044470ef8c71e7f44ee0bdd6
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48e170_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m48e170_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x48d04b(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0048d04b, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m48e170_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0048d04b, .text + (0x0048d04b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0048e170 - 0x401000
.globl FUN_0048e170
FUN_0048e170:
    # block 0x0048e170: entry, 10 instruction(s), calls FUN_0048d04b, ends with je to 0x0048e195 (forward)
    push ebp                                     # 0048e170
    {load} mov ebp, esp                          # 0048e171
    push ecx                                     # 0048e173
    mov dword ptr [ebp - local_4], ecx           # 0048e174
    mov ecx, dword ptr [ebp - local_4]           # 0048e177
    call FUN_0048d04b                            # 0048e17a
    mov eax, dword ptr [ebp + arg_8]             # 0048e17f
    and eax, 0x1                                 # 0048e182
    test eax, eax                                # 0048e185
    je.d8 L_0048e195                             # 0048e187
    # block 0x0048e189: entered by fall-through of je at 0x0048e187, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0048e195
    mov ecx, dword ptr [ebp - local_4]           # 0048e189
    push ecx                                     # 0048e18c
    call FUN_0051dc6c                            # 0048e18d
    add esp, 0x4                                 # 0048e192
L_0048e195:
    # block 0x0048e195: entered by je at 0x0048e187, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0048e195
    {load} mov esp, ebp                          # 0048e198
    pop ebp                                      # 0048e19a
    ret 0x4                                      # 0048e19b

# --- data items (not part of the function) -------------------------
.org 0x0048e19e - 0x401000
PAD_0048e19e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

