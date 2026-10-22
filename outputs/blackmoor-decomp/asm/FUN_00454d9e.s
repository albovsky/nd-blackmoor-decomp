# FUN_00454d9e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454d9e
# extent:       0x00454d9e-0x00454de6 (72 code bytes)
# span:         0x00454d9e-0x00454de6 (code 72, tables 0, padding 0)
# sha256:       31e7b762b90b1f0001a2ce74e3b8ece9dee9dc368b5285a6e555ea0af6333985
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m454d9e_lifted
# naming:       native port src/original_methods_fl40.c:m454d9e_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 19/19 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_154; [ecx + n] field_1c, field_159; [edx + n] field_2a, field_150
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m454d9e_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_2a, 0x2a  # offset +0x2a
.equ field_150, 0x150  # offset +0x150
.equ field_154, 0x154  # offset +0x154
.equ field_159, 0x159  # offset +0x159

# --- external targets -----------------------------------------------

.org 0x00454d9e - 0x401000
.globl FUN_00454d9e
FUN_00454d9e:
    # block 0x00454d9e: entry, 19 instruction(s), ends with ret
    push ebp                                     # 00454d9e
    {load} mov ebp, esp                          # 00454d9f
    push ecx                                     # 00454da1
    mov dword ptr [ebp - local_4], ecx           # 00454da2
    mov eax, dword ptr [ebp - local_4]           # 00454da5
    mov word ptr [eax + field_1e], 0xffff        # 00454da8
    mov ecx, dword ptr [ebp - local_4]           # 00454dae
    mov word ptr [ecx + field_1c], 0xffff        # 00454db1
    mov edx, dword ptr [ebp - local_4]           # 00454db7
    mov dword ptr [edx + field_150], 0x0         # 00454dba
    mov eax, dword ptr [ebp - local_4]           # 00454dc4
    mov byte ptr [eax + field_154], 0x0          # 00454dc7
    mov ecx, dword ptr [ebp - local_4]           # 00454dce
    mov byte ptr [ecx + field_159], 0x0          # 00454dd1
    mov edx, dword ptr [ebp - local_4]           # 00454dd8
    mov dword ptr [edx + field_2a], 0x0          # 00454ddb
    {load} mov esp, ebp                          # 00454de2
    pop ebp                                      # 00454de4
    ret                                          # 00454de5

