# FUN_00401c90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401c90
# extent:       0x00401c90-0x00401ca3 (19 code bytes)
# span:         0x00401c90-0x00401cb0 (code 19, tables 0, padding 13)
# sha256:       fac3a5c5a38f9716160012d860f486ffc4566d3575e307c186291895abb96a31
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401c90
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00401c90 - 0x401000
.globl FUN_00401c90
FUN_00401c90:
    # block 0x00401c90: entry, 8 instruction(s), calls FUN_0051dc6c, ends with ret 0x4
    push ebp                                     # 00401c90
    {load} mov ebp, esp                          # 00401c91
    mov eax, dword ptr [ebp + arg_8]             # 00401c93
    push eax                                     # 00401c96
    call FUN_0051dc6c                            # 00401c97
    add esp, 0x4                                 # 00401c9c
    pop ebp                                      # 00401c9f
    ret 0x4                                      # 00401ca0

# --- data items (not part of the function) -------------------------
.org 0x00401ca3 - 0x401000
PAD_00401ca3:  # 13 byte(s) of int3 padding
    .fill 13, 1, 0xcc

