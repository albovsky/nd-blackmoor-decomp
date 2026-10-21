# FUN_004ab290
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab290
# extent:       0x004ab290-0x004ab2be (46 code bytes)
# span:         0x004ab290-0x004ab2c0 (code 46, tables 0, padding 2)
# sha256:       067b6a2e6264de264920716f12d3d60db60591ebd2bbb68772a94006d1922099
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ab290_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4ab290_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4a9f0b(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004a9f0b, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4ab290_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004a9f0b, .text + (0x004a9f0b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004ab290 - 0x401000
.globl FUN_004ab290
FUN_004ab290:
    # block 0x004ab290: entry, 10 instruction(s), calls FUN_004a9f0b, ends with je to 0x004ab2b5 (forward)
    push ebp                                     # 004ab290
    {load} mov ebp, esp                          # 004ab291
    push ecx                                     # 004ab293
    mov dword ptr [ebp - local_4], ecx           # 004ab294
    mov ecx, dword ptr [ebp - local_4]           # 004ab297
    call FUN_004a9f0b                            # 004ab29a
    mov eax, dword ptr [ebp + arg_8]             # 004ab29f
    and eax, 0x1                                 # 004ab2a2
    test eax, eax                                # 004ab2a5
    je.d8 L_004ab2b5                             # 004ab2a7
    # block 0x004ab2a9: entered by fall-through of je at 0x004ab2a7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004ab2b5
    mov ecx, dword ptr [ebp - local_4]           # 004ab2a9
    push ecx                                     # 004ab2ac
    call FUN_0051dc6c                            # 004ab2ad
    add esp, 0x4                                 # 004ab2b2
L_004ab2b5:
    # block 0x004ab2b5: entered by je at 0x004ab2a7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004ab2b5
    {load} mov esp, ebp                          # 004ab2b8
    pop ebp                                      # 004ab2ba
    ret 0x4                                      # 004ab2bb

# --- data items (not part of the function) -------------------------
.org 0x004ab2be - 0x401000
PAD_004ab2be:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

