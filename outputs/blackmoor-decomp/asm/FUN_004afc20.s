# FUN_004afc20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afc20
# extent:       0x004afc20-0x004afc4e (46 code bytes)
# span:         0x004afc20-0x004afc50 (code 46, tables 0, padding 2)
# sha256:       d4fea23fd3de979e0d0c36d6c9e8524bdfeefc56b7c2415812c3a409a18b8e9e
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4afc20_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4afc20_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4ac8be(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ac8be, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4afc20_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004ac8be, .text + (0x004ac8be - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004afc20 - 0x401000
.globl FUN_004afc20
FUN_004afc20:
    # block 0x004afc20: entry, 10 instruction(s), calls FUN_004ac8be, ends with je to 0x004afc45 (forward)
    push ebp                                     # 004afc20
    {load} mov ebp, esp                          # 004afc21
    push ecx                                     # 004afc23
    mov dword ptr [ebp - local_4], ecx           # 004afc24
    mov ecx, dword ptr [ebp - local_4]           # 004afc27
    call FUN_004ac8be                            # 004afc2a
    mov eax, dword ptr [ebp + arg_8]             # 004afc2f
    and eax, 0x1                                 # 004afc32
    test eax, eax                                # 004afc35
    je.d8 L_004afc45                             # 004afc37
    # block 0x004afc39: entered by fall-through of je at 0x004afc37, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004afc45
    mov ecx, dword ptr [ebp - local_4]           # 004afc39
    push ecx                                     # 004afc3c
    call FUN_0051dc6c                            # 004afc3d
    add esp, 0x4                                 # 004afc42
L_004afc45:
    # block 0x004afc45: entered by je at 0x004afc37, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004afc45
    {load} mov esp, ebp                          # 004afc48
    pop ebp                                      # 004afc4a
    ret 0x4                                      # 004afc4b

# --- data items (not part of the function) -------------------------
.org 0x004afc4e - 0x401000
PAD_004afc4e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

