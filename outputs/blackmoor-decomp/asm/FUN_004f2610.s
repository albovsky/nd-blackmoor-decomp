# FUN_004f2610
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f2610
# extent:       0x004f2610-0x004f263e (46 code bytes)
# span:         0x004f2610-0x004f2640 (code 46, tables 0, padding 2)
# sha256:       65df81dd3d1853ed7dfb2e1fdbab24e312c8a85ae4c39220a4b65a26b9bce558
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4f2610_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4f2610_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4f001f(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004f001f, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4f2610_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004f001f, .text + (0x004f001f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004f2610 - 0x401000
.globl FUN_004f2610
FUN_004f2610:
    # block 0x004f2610: entry, 10 instruction(s), calls FUN_004f001f, ends with je to 0x004f2635 (forward)
    push ebp                                     # 004f2610
    {load} mov ebp, esp                          # 004f2611
    push ecx                                     # 004f2613
    mov dword ptr [ebp - local_4], ecx           # 004f2614
    mov ecx, dword ptr [ebp - local_4]           # 004f2617
    call FUN_004f001f                            # 004f261a
    mov eax, dword ptr [ebp + arg_8]             # 004f261f
    and eax, 0x1                                 # 004f2622
    test eax, eax                                # 004f2625
    je.d8 L_004f2635                             # 004f2627
    # block 0x004f2629: entered by fall-through of je at 0x004f2627, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004f2635
    mov ecx, dword ptr [ebp - local_4]           # 004f2629
    push ecx                                     # 004f262c
    call FUN_0051dc6c                            # 004f262d
    add esp, 0x4                                 # 004f2632
L_004f2635:
    # block 0x004f2635: entered by je at 0x004f2627, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004f2635
    {load} mov esp, ebp                          # 004f2638
    pop ebp                                      # 004f263a
    ret 0x4                                      # 004f263b

# --- data items (not part of the function) -------------------------
.org 0x004f263e - 0x401000
PAD_004f263e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

