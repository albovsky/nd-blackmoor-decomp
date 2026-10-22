# FUN_00465b07
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00465b07
# extent:       0x00465b07-0x00465b3c (53 code bytes)
# span:         0x00465b07-0x00465b3c (code 53, tables 0, padding 0)
# sha256:       974d3966cc8bca58beef7aba627e67653e9d024c7a7db9becb11f5a76af486ba
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m465b07_lifted
# naming:       native port src/original_methods_fl40.c:m465b07_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 17/17 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_4d; [ecx + n] field_1c, field_4e; [edx + n] field_49
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m465b07_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_49, 0x49  # offset +0x49
.equ field_4d, 0x4d  # offset +0x4d
.equ field_4e, 0x4e  # offset +0x4e

# --- external targets -----------------------------------------------

.org 0x00465b07 - 0x401000
.globl FUN_00465b07
FUN_00465b07:
    # block 0x00465b07: entry, 17 instruction(s), ends with ret
    push ebp                                     # 00465b07
    {load} mov ebp, esp                          # 00465b08
    push ecx                                     # 00465b0a
    mov dword ptr [ebp - local_4], ecx           # 00465b0b
    mov eax, dword ptr [ebp - local_4]           # 00465b0e
    mov word ptr [eax + field_1e], 0xffff        # 00465b11
    mov ecx, dword ptr [ebp - local_4]           # 00465b17
    mov word ptr [ecx + field_1c], 0xffff        # 00465b1a
    mov edx, dword ptr [ebp - local_4]           # 00465b20
    mov dword ptr [edx + field_49], 0x0          # 00465b23
    mov eax, dword ptr [ebp - local_4]           # 00465b2a
    mov byte ptr [eax + field_4d], 0x0           # 00465b2d
    mov ecx, dword ptr [ebp - local_4]           # 00465b31
    mov byte ptr [ecx + field_4e], 0x0           # 00465b34
    {load} mov esp, ebp                          # 00465b38
    pop ebp                                      # 00465b3a
    ret                                          # 00465b3b

