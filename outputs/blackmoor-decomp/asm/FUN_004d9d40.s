# FUN_004d9d40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d9d40
# extent:       0x004d9d40-0x004d9d6e (46 code bytes)
# span:         0x004d9d40-0x004d9d70 (code 46, tables 0, padding 2)
# sha256:       582e35da096de6e98b6b8775378f27db195139b83057e6c27a25b3a1505ba204
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d9d40_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4d9d40_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4d58cf(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d58cf, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4d9d40_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004d58cf, .text + (0x004d58cf - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004d9d40 - 0x401000
.globl FUN_004d9d40
FUN_004d9d40:
    # block 0x004d9d40: entry, 10 instruction(s), calls FUN_004d58cf, ends with je to 0x004d9d65 (forward)
    push ebp                                     # 004d9d40
    {load} mov ebp, esp                          # 004d9d41
    push ecx                                     # 004d9d43
    mov dword ptr [ebp - local_4], ecx           # 004d9d44
    mov ecx, dword ptr [ebp - local_4]           # 004d9d47
    call FUN_004d58cf                            # 004d9d4a
    mov eax, dword ptr [ebp + arg_8]             # 004d9d4f
    and eax, 0x1                                 # 004d9d52
    test eax, eax                                # 004d9d55
    je.d8 L_004d9d65                             # 004d9d57
    # block 0x004d9d59: entered by fall-through of je at 0x004d9d57, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004d9d65
    mov ecx, dword ptr [ebp - local_4]           # 004d9d59
    push ecx                                     # 004d9d5c
    call FUN_0051dc6c                            # 004d9d5d
    add esp, 0x4                                 # 004d9d62
L_004d9d65:
    # block 0x004d9d65: entered by je at 0x004d9d57, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004d9d65
    {load} mov esp, ebp                          # 004d9d68
    pop ebp                                      # 004d9d6a
    ret 0x4                                      # 004d9d6b

# --- data items (not part of the function) -------------------------
.org 0x004d9d6e - 0x401000
PAD_004d9d6e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

