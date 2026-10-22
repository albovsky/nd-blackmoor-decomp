# FUN_0042347b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042347b
# extent:       0x0042347b-0x004234b5 (58 code bytes)
# span:         0x0042347b-0x004234b5 (code 58, tables 0, padding 0)
# sha256:       b99e18894195e0dc91a4d1192c9e4a6c595ba40fa761b7d791b7def9df95cabc
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42347b_lifted
# naming:       native port src/original_methods_fl40.c:m42347b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 15/15 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_608; [ecx + n] field_60c; [edx + n] field_614
# callees:      calls FUN_004234c8
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m42347b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_608, 0x608  # offset +0x608
.equ field_60c, 0x60c  # offset +0x60c
.equ field_614, 0x614  # offset +0x614

# --- external targets -----------------------------------------------
.set FUN_004234c8, .text + (0x004234c8 - 0x401000)

.org 0x0042347b - 0x401000
.globl FUN_0042347b
FUN_0042347b:
    # block 0x0042347b: entry, 15 instruction(s), calls FUN_004234c8, ends with ret
    push ebp                                     # 0042347b
    {load} mov ebp, esp                          # 0042347c
    push ecx                                     # 0042347e
    mov dword ptr [ebp - local_4], ecx           # 0042347f
    mov eax, dword ptr [ebp - local_4]           # 00423482
    mov dword ptr [eax + field_608], 0x0         # 00423485
    mov ecx, dword ptr [ebp - local_4]           # 0042348f
    mov dword ptr [ecx + field_60c], 0x0         # 00423492
    mov edx, dword ptr [ebp - local_4]           # 0042349c
    mov dword ptr [edx + field_614], 0x0         # 0042349f
    mov ecx, dword ptr [ebp - local_4]           # 004234a9
    call FUN_004234c8                            # 004234ac
    {load} mov esp, ebp                          # 004234b1
    pop ebp                                      # 004234b3
    ret                                          # 004234b4

