# FUN_00449770
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00449770
# extent:       0x00449770-0x0044979e (46 code bytes)
# span:         0x00449770-0x004497a0 (code 46, tables 0, padding 2)
# sha256:       b52f6f910b67ee72c77ad9f9e1ffee7c688011877c423020664f69193ac5af89
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m449770_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m449770_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x44883f(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044883f, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m449770_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044883f, .text + (0x0044883f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00449770 - 0x401000
.globl FUN_00449770
FUN_00449770:
    # block 0x00449770: entry, 10 instruction(s), calls FUN_0044883f, ends with je to 0x00449795 (forward)
    push ebp                                     # 00449770
    {load} mov ebp, esp                          # 00449771
    push ecx                                     # 00449773
    mov dword ptr [ebp - local_4], ecx           # 00449774
    mov ecx, dword ptr [ebp - local_4]           # 00449777
    call FUN_0044883f                            # 0044977a
    mov eax, dword ptr [ebp + arg_8]             # 0044977f
    and eax, 0x1                                 # 00449782
    test eax, eax                                # 00449785
    je.d8 L_00449795                             # 00449787
    # block 0x00449789: entered by fall-through of je at 0x00449787, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00449795
    mov ecx, dword ptr [ebp - local_4]           # 00449789
    push ecx                                     # 0044978c
    call FUN_0051dc6c                            # 0044978d
    add esp, 0x4                                 # 00449792
L_00449795:
    # block 0x00449795: entered by je at 0x00449787, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00449795
    {load} mov esp, ebp                          # 00449798
    pop ebp                                      # 0044979a
    ret 0x4                                      # 0044979b

# --- data items (not part of the function) -------------------------
.org 0x0044979e - 0x401000
PAD_0044979e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

