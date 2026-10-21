# FUN_004e2cb0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2cb0
# extent:       0x004e2cb0-0x004e2cde (46 code bytes)
# span:         0x004e2cb0-0x004e2ce0 (code 46, tables 0, padding 2)
# sha256:       4db7f4d624616bb766a91744380a04a03a2695209f38281fa0baae863223739b
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e2cb0_scalar_deleting_dtor
# naming:       native port src/original_methods_fl36d.c:m4e2cb0_scalar_deleting_dtor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4e1c83(this); with bit 0 of the argument also 0x51dc6c(this); returns this. je taken both ways; all 18 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e1c83, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m4e2cb0_scalar_deleting_dtor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004e1c83, .text + (0x004e1c83 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004e2cb0 - 0x401000
.globl FUN_004e2cb0
FUN_004e2cb0:
    # block 0x004e2cb0: entry, 10 instruction(s), calls FUN_004e1c83, ends with je to 0x004e2cd5 (forward)
    push ebp                                     # 004e2cb0
    {load} mov ebp, esp                          # 004e2cb1
    push ecx                                     # 004e2cb3
    mov dword ptr [ebp - local_4], ecx           # 004e2cb4
    mov ecx, dword ptr [ebp - local_4]           # 004e2cb7
    call FUN_004e1c83                            # 004e2cba
    mov eax, dword ptr [ebp + arg_8]             # 004e2cbf
    and eax, 0x1                                 # 004e2cc2
    test eax, eax                                # 004e2cc5
    je.d8 L_004e2cd5                             # 004e2cc7
    # block 0x004e2cc9: entered by fall-through of je at 0x004e2cc7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004e2cd5
    mov ecx, dword ptr [ebp - local_4]           # 004e2cc9
    push ecx                                     # 004e2ccc
    call FUN_0051dc6c                            # 004e2ccd
    add esp, 0x4                                 # 004e2cd2
L_004e2cd5:
    # block 0x004e2cd5: entered by je at 0x004e2cc7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004e2cd5
    {load} mov esp, ebp                          # 004e2cd8
    pop ebp                                      # 004e2cda
    ret 0x4                                      # 004e2cdb

# --- data items (not part of the function) -------------------------
.org 0x004e2cde - 0x401000
PAD_004e2cde:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

