# FUN_00457e60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00457e60
# extent:       0x00457e60-0x00457e8e (46 code bytes)
# span:         0x00457e60-0x00457e90 (code 46, tables 0, padding 2)
# sha256:       990d46bcdcf90f62043f7ee4e727c782e52b72761acaa20611f7e81c94c69279
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m457e60_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m457e60_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x456ceb(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00456ceb, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m457e60_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00456ceb, .text + (0x00456ceb - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00457e60 - 0x401000
.globl FUN_00457e60
FUN_00457e60:
    # block 0x00457e60: entry, 10 instruction(s), calls FUN_00456ceb, ends with je to 0x00457e85 (forward)
    push ebp                                     # 00457e60
    {load} mov ebp, esp                          # 00457e61
    push ecx                                     # 00457e63
    mov dword ptr [ebp - local_4], ecx           # 00457e64
    mov ecx, dword ptr [ebp - local_4]           # 00457e67
    call FUN_00456ceb                            # 00457e6a
    mov eax, dword ptr [ebp + arg_8]             # 00457e6f
    and eax, 0x1                                 # 00457e72
    test eax, eax                                # 00457e75
    je.d8 L_00457e85                             # 00457e77
    # block 0x00457e79: entered by fall-through of je at 0x00457e77, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00457e85
    mov ecx, dword ptr [ebp - local_4]           # 00457e79
    push ecx                                     # 00457e7c
    call FUN_0051dc6c                            # 00457e7d
    add esp, 0x4                                 # 00457e82
L_00457e85:
    # block 0x00457e85: entered by je at 0x00457e77, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00457e85
    {load} mov esp, ebp                          # 00457e88
    pop ebp                                      # 00457e8a
    ret 0x4                                      # 00457e8b

# --- data items (not part of the function) -------------------------
.org 0x00457e8e - 0x401000
PAD_00457e8e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

