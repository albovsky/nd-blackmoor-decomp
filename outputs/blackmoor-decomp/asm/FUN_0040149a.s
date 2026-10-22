# FUN_0040149a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040149a
# extent:       0x0040149a-0x004014f5 (91 code bytes)
# span:         0x0040149a-0x004014f5 (code 91, tables 0, padding 0)
# sha256:       6626152fa86f66bd13c906c763e3e34d13050bf6f82a70b6e4b3c94ef86cef64
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40149a_lifted
# naming:       native port src/original_methods_fl40.c:m40149a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 25/25 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005217e4, FUN_00401511
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m40149a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 25 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401511, .text + (0x00401511 - 0x401000)
.set FUN_005217e4, .text + (0x005217e4 - 0x401000)

.org 0x0040149a - 0x401000
.globl FUN_0040149a
FUN_0040149a:
    # block 0x0040149a: entry, 25 instruction(s), calls FUN_005217e4, FUN_00401511, ends with ret
    push ebp                                     # 0040149a
    {load} mov ebp, esp                          # 0040149b
    push -0x1                                    # 0040149d
    push 0x526add                                # 0040149f
    mov eax, dword ptr fs:[0x0]                  # 004014a4
    push eax                                     # 004014aa
    mov dword ptr fs:[0x0], esp                  # 004014ab
    push ecx                                     # 004014b2
    mov dword ptr [ebp - local_10], ecx          # 004014b3
    push 0x0                                     # 004014b6
    push 0xa0                                    # 004014b8
    mov ecx, dword ptr [ebp - local_10]          # 004014bd
    call FUN_005217e4                            # 004014c0
    mov dword ptr [ebp - local_4], 0x0           # 004014c5
    mov eax, dword ptr [ebp - local_10]          # 004014cc
    mov dword ptr [eax], 0x52ab70                # 004014cf
    mov ecx, dword ptr [ebp - local_10]          # 004014d5
    call FUN_00401511                            # 004014d8
    mov dword ptr [ebp - local_4], 0xffffffff    # 004014dd
    mov eax, dword ptr [ebp - local_10]          # 004014e4
    mov ecx, dword ptr [ebp - local_c]           # 004014e7
    mov dword ptr fs:[0x0], ecx                  # 004014ea
    {load} mov esp, ebp                          # 004014f1
    pop ebp                                      # 004014f3
    ret                                          # 004014f4

