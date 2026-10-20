# FUN_0047e440
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e440
# extent:       0x0047e440-0x0047e477 (55 code bytes)
# span:         0x0047e440-0x0047e477 (code 55, tables 0, padding 0)
# sha256:       6e9316512425cebf2b9d69140ee024f2356da2e9489517ee8f814ccc81013ddc
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         eb_invalidate
# naming:       native port src/action_family_eb_runtime.c:eb_invalidate (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with eb_invalidate (active +0x13c5 != 0 and slot +0x1c != -1, then redraw dword := 1). The store is the host mark_dirty callback. Native-only: NULL args -> EB_ERR_ARGUMENT, host error -> EB_ERR_HOST.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_13c5; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:eb_invalidate (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_13c5, 0x13c5  # offset +0x13c5

# --- external targets -----------------------------------------------

.org 0x0047e440 - 0x401000
.globl FUN_0047e440
FUN_0047e440:
    # block 0x0047e440: entry, 7 instruction(s), ends with je to 0x0047e473 (forward)
    push ebp                                     # 0047e440
    {load} mov ebp, esp                          # 0047e441
    push ecx                                     # 0047e443
    mov dword ptr [ebp - local_4], ecx           # 0047e444
    mov eax, dword ptr [ebp - local_4]           # 0047e447
    cmp dword ptr [eax + field_13c5], 0x0        # 0047e44a
    je.d8 L_0047e473                             # 0047e451
    # block 0x0047e453: entered by fall-through of je at 0x0047e451, 4 instruction(s), ends with je to 0x0047e473 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047e453
    movsx edx, word ptr [ecx + field_1c]         # 0047e456
    cmp edx, -0x1                                # 0047e45a
    je.d8 L_0047e473                             # 0047e45d
    # block 0x0047e45f: entered by fall-through of je at 0x0047e45d, 4 instruction(s), falls into the block at 0x0047e473
    mov eax, dword ptr [ebp - local_4]           # 0047e45f
    movsx ecx, word ptr [eax + field_1c]         # 0047e462
    imul ecx, ecx, 0x4a                          # 0047e466
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0047e469
L_0047e473:
    # block 0x0047e473: entered by je at 0x0047e451; je at 0x0047e45d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047e473
    pop ebp                                      # 0047e475
    ret                                          # 0047e476

