# FUN_004780e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004780e0
# extent:       0x004780e0-0x0047810e (46 code bytes)
# span:         0x004780e0-0x00478110 (code 46, tables 0, padding 2)
# sha256:       e52757cc77f20a81f1e4fc80c1ce35db48fc2234e19207be55464da21880e730
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4780e0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4780e0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4757be(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004757be, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4780e0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004757be, .text + (0x004757be - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004780e0 - 0x401000
.globl FUN_004780e0
FUN_004780e0:
    # block 0x004780e0: entry, 10 instruction(s), calls FUN_004757be, ends with je to 0x00478105 (forward)
    push ebp                                     # 004780e0
    {load} mov ebp, esp                          # 004780e1
    push ecx                                     # 004780e3
    mov dword ptr [ebp - local_4], ecx           # 004780e4
    mov ecx, dword ptr [ebp - local_4]           # 004780e7
    call FUN_004757be                            # 004780ea
    mov eax, dword ptr [ebp + arg_8]             # 004780ef
    and eax, 0x1                                 # 004780f2
    test eax, eax                                # 004780f5
    je.d8 L_00478105                             # 004780f7
    # block 0x004780f9: entered by fall-through of je at 0x004780f7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00478105
    mov ecx, dword ptr [ebp - local_4]           # 004780f9
    push ecx                                     # 004780fc
    call FUN_0051dc6c                            # 004780fd
    add esp, 0x4                                 # 00478102
L_00478105:
    # block 0x00478105: entered by je at 0x004780f7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00478105
    {load} mov esp, ebp                          # 00478108
    pop ebp                                      # 0047810a
    ret 0x4                                      # 0047810b

# --- data items (not part of the function) -------------------------
.org 0x0047810e - 0x401000
PAD_0047810e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

