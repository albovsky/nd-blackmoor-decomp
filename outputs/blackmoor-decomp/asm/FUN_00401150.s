# FUN_00401150
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401150
# extent:       0x00401150-0x0040116a (26 code bytes)
# span:         0x00401150-0x00401170 (code 26, tables 0, padding 6)
# sha256:       7b577c8e2700852cd6cf3246d661696ba834f63e4a24216539720975bac93ed5
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401150_lifted
# naming:       native port src/original_methods_fl40.c:m401150_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 12/12 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c
# callees:      calls USER32.dll!EnableWindow
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m401150_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x00401150 - 0x401000
.globl FUN_00401150
FUN_00401150:
    # block 0x00401150: entry, 12 instruction(s), calls USER32.dll!EnableWindow, ends with ret
    push ebp                                     # 00401150
    {load} mov ebp, esp                          # 00401151
    push ecx                                     # 00401153
    mov dword ptr [ebp - local_4], ecx           # 00401154
    push 0x0                                     # 00401157
    mov eax, dword ptr [ebp - local_4]           # 00401159
    mov ecx, dword ptr [eax + field_1c]          # 0040115c
    push ecx                                     # 0040115f
    call dword ptr [0x52a4d0]                    # 00401160
    {load} mov esp, ebp                          # 00401166
    pop ebp                                      # 00401168
    ret                                          # 00401169

# --- data items (not part of the function) -------------------------
.org 0x0040116a - 0x401000
PAD_0040116a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

