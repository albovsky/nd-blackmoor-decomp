# FUN_004b7ed0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7ed0
# extent:       0x004b7ed0-0x004b7efe (46 code bytes)
# span:         0x004b7ed0-0x004b7f00 (code 46, tables 0, padding 2)
# sha256:       a2f6eccfd592cd1f500d1153b6244cbe36dda7f579ffbf2b9b78c90cec76687c
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b7ed0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4b7ed0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4b71db(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004b71db, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4b7ed0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004b71db, .text + (0x004b71db - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004b7ed0 - 0x401000
.globl FUN_004b7ed0
FUN_004b7ed0:
    # block 0x004b7ed0: entry, 10 instruction(s), calls FUN_004b71db, ends with je to 0x004b7ef5 (forward)
    push ebp                                     # 004b7ed0
    {load} mov ebp, esp                          # 004b7ed1
    push ecx                                     # 004b7ed3
    mov dword ptr [ebp - local_4], ecx           # 004b7ed4
    mov ecx, dword ptr [ebp - local_4]           # 004b7ed7
    call FUN_004b71db                            # 004b7eda
    mov eax, dword ptr [ebp + arg_8]             # 004b7edf
    and eax, 0x1                                 # 004b7ee2
    test eax, eax                                # 004b7ee5
    je.d8 L_004b7ef5                             # 004b7ee7
    # block 0x004b7ee9: entered by fall-through of je at 0x004b7ee7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004b7ef5
    mov ecx, dword ptr [ebp - local_4]           # 004b7ee9
    push ecx                                     # 004b7eec
    call FUN_0051dc6c                            # 004b7eed
    add esp, 0x4                                 # 004b7ef2
L_004b7ef5:
    # block 0x004b7ef5: entered by je at 0x004b7ee7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004b7ef5
    {load} mov esp, ebp                          # 004b7ef8
    pop ebp                                      # 004b7efa
    ret 0x4                                      # 004b7efb

# --- data items (not part of the function) -------------------------
.org 0x004b7efe - 0x401000
PAD_004b7efe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

