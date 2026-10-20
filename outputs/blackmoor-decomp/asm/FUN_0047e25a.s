# FUN_0047e25a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e25a
# extent:       0x0047e25a-0x0047e2a5 (75 code bytes)
# span:         0x0047e25a-0x0047e2a5 (code 75, tables 0, padding 0)
# sha256:       04952f760b878ea3ba1b4dfc57b6712698aea36a5575255f03d512b7caab32a6
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47e25a_reset_fields
# naming:       native port src/original_methods_fl16.c:m47e25a_reset_fields (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m47e25a_reset_fields (words +0x1e/+0x1c := 0xffff, dword +0x13c5, bytes +0x13c9/+0x13ce, dword +0x1344 := 0).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_13c9; [ecx + n] field_1c, field_13ce; [edx + n] field_1344, field_13c5
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:eb_cleanup (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_1344, 0x1344  # offset +0x1344
.equ field_13c5, 0x13c5  # offset +0x13c5
.equ field_13c9, 0x13c9  # offset +0x13c9
.equ field_13ce, 0x13ce  # offset +0x13ce

# --- external targets -----------------------------------------------

.org 0x0047e25a - 0x401000
.globl FUN_0047e25a
FUN_0047e25a:
    # block 0x0047e25a: entry, 19 instruction(s), ends with ret
    push ebp                                     # 0047e25a
    {load} mov ebp, esp                          # 0047e25b
    push ecx                                     # 0047e25d
    mov dword ptr [ebp - local_4], ecx           # 0047e25e
    mov eax, dword ptr [ebp - local_4]           # 0047e261
    mov word ptr [eax + field_1e], 0xffff        # 0047e264
    mov ecx, dword ptr [ebp - local_4]           # 0047e26a
    mov word ptr [ecx + field_1c], 0xffff        # 0047e26d
    mov edx, dword ptr [ebp - local_4]           # 0047e273
    mov dword ptr [edx + field_13c5], 0x0        # 0047e276
    mov eax, dword ptr [ebp - local_4]           # 0047e280
    mov byte ptr [eax + field_13c9], 0x0         # 0047e283
    mov ecx, dword ptr [ebp - local_4]           # 0047e28a
    mov byte ptr [ecx + field_13ce], 0x0         # 0047e28d
    mov edx, dword ptr [ebp - local_4]           # 0047e294
    mov dword ptr [edx + field_1344], 0x0        # 0047e297
    {load} mov esp, ebp                          # 0047e2a1
    pop ebp                                      # 0047e2a3
    ret                                          # 0047e2a4

