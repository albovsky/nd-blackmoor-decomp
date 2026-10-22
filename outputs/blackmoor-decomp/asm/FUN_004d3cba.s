# FUN_004d3cba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3cba
# extent:       0x004d3cba-0x004d3ced (51 code bytes)
# span:         0x004d3cba-0x004d3ced (code 51, tables 0, padding 0)
# sha256:       bc1dfb5e0403067125dd42790c35c0cd58b034d5e4fdbdd228bc302a8c4d08c3
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3cba_lifted
# naming:       native port src/original_methods_fl39d.c:m4d3cba_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (25 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_45e; [ecx + n] field_45a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4d3cba_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_45a, 0x45a  # offset +0x45a
.equ field_45e, 0x45e  # offset +0x45e

# --- external targets -----------------------------------------------

.org 0x004d3cba - 0x401000
.globl FUN_004d3cba
FUN_004d3cba:
    # block 0x004d3cba: entry, 7 instruction(s), ends with jne to 0x004d3ce9 (forward)
    push ebp                                     # 004d3cba
    {load} mov ebp, esp                          # 004d3cbb
    push ecx                                     # 004d3cbd
    mov dword ptr [ebp - local_4], ecx           # 004d3cbe
    mov eax, dword ptr [ebp - local_4]           # 004d3cc1
    cmp dword ptr [eax + field_45e], 0x0         # 004d3cc4
    jne.d8 L_004d3ce9                            # 004d3ccb
    # block 0x004d3ccd: entered by fall-through of jne at 0x004d3ccb, 5 instruction(s), falls into the block at 0x004d3ce9
    mov ecx, dword ptr [ebp - local_4]           # 004d3ccd
    mov edx, dword ptr [0x5d1c4b]                # 004d3cd0
    mov dword ptr [ecx + field_45a], edx         # 004d3cd6
    mov eax, dword ptr [ebp - local_4]           # 004d3cdc
    mov dword ptr [eax + field_45e], 0x1         # 004d3cdf
L_004d3ce9:
    # block 0x004d3ce9: entered by jne at 0x004d3ccb, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d3ce9
    pop ebp                                      # 004d3ceb
    ret                                          # 004d3cec

