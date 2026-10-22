# FUN_004ee5b8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee5b8
# extent:       0x004ee5b8-0x004ee5cd (21 code bytes)
# span:         0x004ee5b8-0x004ee5cd (code 21, tables 0, padding 0)
# sha256:       a960a8755eae7f3d4db32efb50ca0acfbce596555132708c90ba2cc1141ea50c
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ee5b8_store_global
# naming:       native port src/original_methods_fl39e.c:m4ee5b8_store_global (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the stack argument (a dword) in the global at 0x55cd94 and pops 4 bytes; nothing else is written and nothing is called. No jumps; all 9 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39e.c:m4ee5b8_store_global (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004ee5b8 - 0x401000
.globl FUN_004ee5b8
FUN_004ee5b8:
    # block 0x004ee5b8: entry, 9 instruction(s), ends with ret 0x4
    push ebp                                     # 004ee5b8
    {load} mov ebp, esp                          # 004ee5b9
    push ecx                                     # 004ee5bb
    mov dword ptr [ebp - local_4], ecx           # 004ee5bc
    mov eax, dword ptr [ebp + arg_8]             # 004ee5bf
    mov dword ptr [0x55cd94], eax                # 004ee5c2
    {load} mov esp, ebp                          # 004ee5c7
    pop ebp                                      # 004ee5c9
    ret 0x4                                      # 004ee5ca

