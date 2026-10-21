# FUN_00472ed0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00472ed0
# extent:       0x00472ed0-0x00472efe (46 code bytes)
# span:         0x00472ed0-0x00472f00 (code 46, tables 0, padding 2)
# sha256:       01d2d83793e32d428ebd8cef6e43ea81ed547488e8fd18901248b9385d5f63b3
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m472ed0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m472ed0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x470d5e(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00470d5e, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m472ed0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00470d5e, .text + (0x00470d5e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00472ed0 - 0x401000
.globl FUN_00472ed0
FUN_00472ed0:
    # block 0x00472ed0: entry, 10 instruction(s), calls FUN_00470d5e, ends with je to 0x00472ef5 (forward)
    push ebp                                     # 00472ed0
    {load} mov ebp, esp                          # 00472ed1
    push ecx                                     # 00472ed3
    mov dword ptr [ebp - local_4], ecx           # 00472ed4
    mov ecx, dword ptr [ebp - local_4]           # 00472ed7
    call FUN_00470d5e                            # 00472eda
    mov eax, dword ptr [ebp + arg_8]             # 00472edf
    and eax, 0x1                                 # 00472ee2
    test eax, eax                                # 00472ee5
    je.d8 L_00472ef5                             # 00472ee7
    # block 0x00472ee9: entered by fall-through of je at 0x00472ee7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00472ef5
    mov ecx, dword ptr [ebp - local_4]           # 00472ee9
    push ecx                                     # 00472eec
    call FUN_0051dc6c                            # 00472eed
    add esp, 0x4                                 # 00472ef2
L_00472ef5:
    # block 0x00472ef5: entered by je at 0x00472ee7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00472ef5
    {load} mov esp, ebp                          # 00472ef8
    pop ebp                                      # 00472efa
    ret 0x4                                      # 00472efb

# --- data items (not part of the function) -------------------------
.org 0x00472efe - 0x401000
PAD_00472efe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

