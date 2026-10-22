# FUN_00401000
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401000
# extent:       0x00401000-0x00401032 (50 code bytes)
# span:         0x00401000-0x00401032 (code 50, tables 0, padding 0)
# sha256:       5f07a9bdf47d7e3b59dc984ecddad85744db10e93f0aa3b3331b3d732fa7f767
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401000_lifted
# naming:       native port src/original_methods_fl40.c:m401000_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 16/16 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [edx + n] field_3c
# callees:      calls FUN_0051a7c3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m401000_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_3c, 0x3c  # offset +0x3c

# --- external targets -----------------------------------------------
.set FUN_0051a7c3, .text + (0x0051a7c3 - 0x401000)

.org 0x00401000 - 0x401000
.globl FUN_00401000
FUN_00401000:
    # block 0x00401000: entry, 16 instruction(s), calls FUN_0051a7c3, ends with ret
    push ebp                                     # 00401000
    {load} mov ebp, esp                          # 00401001
    push ecx                                     # 00401003
    mov dword ptr [ebp - local_4], ecx           # 00401004
    mov ecx, dword ptr [ebp - local_4]           # 00401007
    call FUN_0051a7c3                            # 0040100a
    mov eax, dword ptr [ebp - local_4]           # 0040100f
    mov dword ptr [eax], 0x52ed6c                # 00401012
    mov ecx, dword ptr [ebp - local_4]           # 00401018
    mov dword ptr [ecx], 0x52a5d0                # 0040101b
    mov edx, dword ptr [ebp - local_4]           # 00401021
    mov dword ptr [edx + field_3c], 0x0          # 00401024
    mov eax, dword ptr [ebp - local_4]           # 0040102b
    {load} mov esp, ebp                          # 0040102e
    pop ebp                                      # 00401030
    ret                                          # 00401031

