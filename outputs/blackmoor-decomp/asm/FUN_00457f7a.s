# FUN_00457f7a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00457f7a
# extent:       0x00457f7a-0x00457fc2 (72 code bytes)
# span:         0x00457f7a-0x00457fc2 (code 72, tables 0, padding 0)
# sha256:       39dee1af352647c412775258580ed521e571acbbbd36b565bf90dd2e6881722b
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m457f7a_lifted
# naming:       native port src/original_methods_fl40.c:m457f7a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 19/19 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_26, field_9c; [ecx + n] field_24, field_9d; [edx + n] field_2e, field_98
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m457f7a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_2e, 0x2e  # offset +0x2e
.equ field_98, 0x98  # offset +0x98
.equ field_9c, 0x9c  # offset +0x9c
.equ field_9d, 0x9d  # offset +0x9d

# --- external targets -----------------------------------------------

.org 0x00457f7a - 0x401000
.globl FUN_00457f7a
FUN_00457f7a:
    # block 0x00457f7a: entry, 19 instruction(s), ends with ret
    push ebp                                     # 00457f7a
    {load} mov ebp, esp                          # 00457f7b
    push ecx                                     # 00457f7d
    mov dword ptr [ebp - local_4], ecx           # 00457f7e
    mov eax, dword ptr [ebp - local_4]           # 00457f81
    mov word ptr [eax + field_26], 0xffff        # 00457f84
    mov ecx, dword ptr [ebp - local_4]           # 00457f8a
    mov word ptr [ecx + field_24], 0xffff        # 00457f8d
    mov edx, dword ptr [ebp - local_4]           # 00457f93
    mov dword ptr [edx + field_98], 0x0          # 00457f96
    mov eax, dword ptr [ebp - local_4]           # 00457fa0
    mov byte ptr [eax + field_9c], 0x0           # 00457fa3
    mov ecx, dword ptr [ebp - local_4]           # 00457faa
    mov byte ptr [ecx + field_9d], 0x0           # 00457fad
    mov edx, dword ptr [ebp - local_4]           # 00457fb4
    mov dword ptr [edx + field_2e], 0x0          # 00457fb7
    {load} mov esp, ebp                          # 00457fbe
    pop ebp                                      # 00457fc0
    ret                                          # 00457fc1

