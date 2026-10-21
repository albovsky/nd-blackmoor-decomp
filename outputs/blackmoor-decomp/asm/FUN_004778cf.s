# FUN_004778cf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004778cf
# extent:       0x004778cf-0x004778df (16 code bytes)
# span:         0x004778cf-0x004778df (code 16, tables 0, padding 0)
# sha256:       46aa660bc621d28b7c45857a997856e1373bc16f242cd775a37ac3b68287143c
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4778cf_get_constant
# naming:       native port src/original_methods_fl36b.c:m4778cf_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d470u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4778cf_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004778cf - 0x401000
.globl FUN_004778cf
FUN_004778cf:
    # block 0x004778cf: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004778cf
    {load} mov ebp, esp                          # 004778d0
    push ecx                                     # 004778d2
    mov dword ptr [ebp - local_4], ecx           # 004778d3
    mov eax, 0x52d470                            # 004778d6
    {load} mov esp, ebp                          # 004778db
    pop ebp                                      # 004778dd
    ret                                          # 004778de

