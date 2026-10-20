# FUN_0048d0e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048d0e5
# extent:       0x0048d0e5-0x0048d119 (52 code bytes)
# span:         0x0048d0e5-0x0048d119 (code 52, tables 0, padding 0)
# sha256:       22238852c847900892e6c7f71c17a6d5670012b4b2faee044cfdbbd321fcc170
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         d0_invalidate
# naming:       native port src/action_family_d0_runtime.c:d0_invalidate (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with d0_invalidate (active +0x33 != 0 and slot +0x1c != -1, then redraw dword := 1). The store is the host mark_dirty callback. Native-only: NULL args -> D0_ERR_ARGUMENT, host error -> D0_ERR_HOST.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_33; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d0_runtime.c:d0_invalidate (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_33, 0x33  # offset +0x33

# --- external targets -----------------------------------------------

.org 0x0048d0e5 - 0x401000
.globl FUN_0048d0e5
FUN_0048d0e5:
    # block 0x0048d0e5: entry, 7 instruction(s), ends with je to 0x0048d115 (forward)
    push ebp                                     # 0048d0e5
    {load} mov ebp, esp                          # 0048d0e6
    push ecx                                     # 0048d0e8
    mov dword ptr [ebp - local_4], ecx           # 0048d0e9
    mov eax, dword ptr [ebp - local_4]           # 0048d0ec
    cmp dword ptr [eax + field_33], 0x0          # 0048d0ef
    je.d8 L_0048d115                             # 0048d0f3
    # block 0x0048d0f5: entered by fall-through of je at 0x0048d0f3, 4 instruction(s), ends with je to 0x0048d115 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048d0f5
    movsx edx, word ptr [ecx + field_1c]         # 0048d0f8
    cmp edx, -0x1                                # 0048d0fc
    je.d8 L_0048d115                             # 0048d0ff
    # block 0x0048d101: entered by fall-through of je at 0x0048d0ff, 4 instruction(s), falls into the block at 0x0048d115
    mov eax, dword ptr [ebp - local_4]           # 0048d101
    movsx ecx, word ptr [eax + field_1c]         # 0048d104
    imul ecx, ecx, 0x4a                          # 0048d108
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0048d10b
L_0048d115:
    # block 0x0048d115: entered by je at 0x0048d0f3; je at 0x0048d0ff, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048d115
    pop ebp                                      # 0048d117
    ret                                          # 0048d118

