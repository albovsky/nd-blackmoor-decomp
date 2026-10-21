# FUN_0048a5f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a5f0
# extent:       0x0048a5f0-0x0048a61e (46 code bytes)
# span:         0x0048a5f0-0x0048a620 (code 46, tables 0, padding 2)
# sha256:       9c8d25c4f09898d50dcc41a4b3c468e91e97d2019bd43d063efb19f5044bc6d7
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48a5f0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m48a5f0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x488d89(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00488d89, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m48a5f0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00488d89, .text + (0x00488d89 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0048a5f0 - 0x401000
.globl FUN_0048a5f0
FUN_0048a5f0:
    # block 0x0048a5f0: entry, 10 instruction(s), calls FUN_00488d89, ends with je to 0x0048a615 (forward)
    push ebp                                     # 0048a5f0
    {load} mov ebp, esp                          # 0048a5f1
    push ecx                                     # 0048a5f3
    mov dword ptr [ebp - local_4], ecx           # 0048a5f4
    mov ecx, dword ptr [ebp - local_4]           # 0048a5f7
    call FUN_00488d89                            # 0048a5fa
    mov eax, dword ptr [ebp + arg_8]             # 0048a5ff
    and eax, 0x1                                 # 0048a602
    test eax, eax                                # 0048a605
    je.d8 L_0048a615                             # 0048a607
    # block 0x0048a609: entered by fall-through of je at 0x0048a607, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0048a615
    mov ecx, dword ptr [ebp - local_4]           # 0048a609
    push ecx                                     # 0048a60c
    call FUN_0051dc6c                            # 0048a60d
    add esp, 0x4                                 # 0048a612
L_0048a615:
    # block 0x0048a615: entered by je at 0x0048a607, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0048a615
    {load} mov esp, ebp                          # 0048a618
    pop ebp                                      # 0048a61a
    ret 0x4                                      # 0048a61b

# --- data items (not part of the function) -------------------------
.org 0x0048a61e - 0x401000
PAD_0048a61e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

