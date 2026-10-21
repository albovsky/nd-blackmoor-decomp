# FUN_0044e650
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e650
# extent:       0x0044e650-0x0044e67e (46 code bytes)
# span:         0x0044e650-0x0044e680 (code 46, tables 0, padding 2)
# sha256:       4b305c6a293891e8ea1492915776c9716a178596f9fa17e265cec47b0a114872
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44e650_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m44e650_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x44d0eb(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044d0eb, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m44e650_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044d0eb, .text + (0x0044d0eb - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0044e650 - 0x401000
.globl FUN_0044e650
FUN_0044e650:
    # block 0x0044e650: entry, 10 instruction(s), calls FUN_0044d0eb, ends with je to 0x0044e675 (forward)
    push ebp                                     # 0044e650
    {load} mov ebp, esp                          # 0044e651
    push ecx                                     # 0044e653
    mov dword ptr [ebp - local_4], ecx           # 0044e654
    mov ecx, dword ptr [ebp - local_4]           # 0044e657
    call FUN_0044d0eb                            # 0044e65a
    mov eax, dword ptr [ebp + arg_8]             # 0044e65f
    and eax, 0x1                                 # 0044e662
    test eax, eax                                # 0044e665
    je.d8 L_0044e675                             # 0044e667
    # block 0x0044e669: entered by fall-through of je at 0x0044e667, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044e675
    mov ecx, dword ptr [ebp - local_4]           # 0044e669
    push ecx                                     # 0044e66c
    call FUN_0051dc6c                            # 0044e66d
    add esp, 0x4                                 # 0044e672
L_0044e675:
    # block 0x0044e675: entered by je at 0x0044e667, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0044e675
    {load} mov esp, ebp                          # 0044e678
    pop ebp                                      # 0044e67a
    ret 0x4                                      # 0044e67b

# --- data items (not part of the function) -------------------------
.org 0x0044e67e - 0x401000
PAD_0044e67e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

