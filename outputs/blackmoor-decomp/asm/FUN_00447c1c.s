# FUN_00447c1c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447c1c
# extent:       0x00447c1c-0x00447c36 (26 code bytes)
# span:         0x00447c1c-0x00447c36 (code 26, tables 0, padding 0)
# sha256:       ea52bcb581b7bc2921dfc981e0c7da32d7c3d2fa7eac3db509d6660b7d6295d4
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m447c1c_lifted
# naming:       native port src/original_methods_fl40.c:m447c1c_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 11/11 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c
# callees:      calls FUN_004473a9
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m447c1c_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_004473a9, .text + (0x004473a9 - 0x401000)

.org 0x00447c1c - 0x401000
.globl FUN_00447c1c
FUN_00447c1c:
    # block 0x00447c1c: entry, 11 instruction(s), calls FUN_004473a9, ends with ret
    push ebp                                     # 00447c1c
    {load} mov ebp, esp                          # 00447c1d
    push ecx                                     # 00447c1f
    mov dword ptr [ebp - local_4], ecx           # 00447c20
    mov eax, dword ptr [ebp - local_4]           # 00447c23
    mov byte ptr [eax + field_1c], 0x0           # 00447c26
    mov ecx, dword ptr [ebp - local_4]           # 00447c2a
    call FUN_004473a9                            # 00447c2d
    {load} mov esp, ebp                          # 00447c32
    pop ebp                                      # 00447c34
    ret                                          # 00447c35

