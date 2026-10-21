# FUN_004a1b30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a1b30
# extent:       0x004a1b30-0x004a1b5e (46 code bytes)
# span:         0x004a1b30-0x004a1b60 (code 46, tables 0, padding 2)
# sha256:       386f8fe4ed11669f4dae352450b5bb5b1b82fded8010b989b932a40f73d1be0f
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a1b30_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4a1b30_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x49c59f(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0049c59f, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4a1b30_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0049c59f, .text + (0x0049c59f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004a1b30 - 0x401000
.globl FUN_004a1b30
FUN_004a1b30:
    # block 0x004a1b30: entry, 10 instruction(s), calls FUN_0049c59f, ends with je to 0x004a1b55 (forward)
    push ebp                                     # 004a1b30
    {load} mov ebp, esp                          # 004a1b31
    push ecx                                     # 004a1b33
    mov dword ptr [ebp - local_4], ecx           # 004a1b34
    mov ecx, dword ptr [ebp - local_4]           # 004a1b37
    call FUN_0049c59f                            # 004a1b3a
    mov eax, dword ptr [ebp + arg_8]             # 004a1b3f
    and eax, 0x1                                 # 004a1b42
    test eax, eax                                # 004a1b45
    je.d8 L_004a1b55                             # 004a1b47
    # block 0x004a1b49: entered by fall-through of je at 0x004a1b47, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004a1b55
    mov ecx, dword ptr [ebp - local_4]           # 004a1b49
    push ecx                                     # 004a1b4c
    call FUN_0051dc6c                            # 004a1b4d
    add esp, 0x4                                 # 004a1b52
L_004a1b55:
    # block 0x004a1b55: entered by je at 0x004a1b47, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004a1b55
    {load} mov esp, ebp                          # 004a1b58
    pop ebp                                      # 004a1b5a
    ret 0x4                                      # 004a1b5b

# --- data items (not part of the function) -------------------------
.org 0x004a1b5e - 0x401000
PAD_004a1b5e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

