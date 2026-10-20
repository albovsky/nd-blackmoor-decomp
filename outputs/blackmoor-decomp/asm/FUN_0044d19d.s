# FUN_0044d19d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d19d
# extent:       0x0044d19d-0x0044d1d1 (52 code bytes)
# span:         0x0044d19d-0x0044d1d1 (code 52, tables 0, padding 0)
# sha256:       249943da1f881b09d241d1ebeae9ece0805f770c39489fd451e48a47a5da9a32
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         alc_invalidate
# naming:       native port src/action_family_aa_runtime.c:alc_invalidate (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with alc_invalidate (active +0x25 != 0 and slot +0x1c != -1, then redraw dword := 1). The store is the host mark_dirty callback. Native-only: NULL args -> ALC_ERR_ARGUMENT, host error -> ALC_ERR_HOST.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_25; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_aa_runtime.c:alc_invalidate (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_25, 0x25  # offset +0x25

# --- external targets -----------------------------------------------

.org 0x0044d19d - 0x401000
.globl FUN_0044d19d
FUN_0044d19d:
    # block 0x0044d19d: entry, 7 instruction(s), ends with je to 0x0044d1cd (forward)
    push ebp                                     # 0044d19d
    {load} mov ebp, esp                          # 0044d19e
    push ecx                                     # 0044d1a0
    mov dword ptr [ebp - local_4], ecx           # 0044d1a1
    mov eax, dword ptr [ebp - local_4]           # 0044d1a4
    cmp dword ptr [eax + field_25], 0x0          # 0044d1a7
    je.d8 L_0044d1cd                             # 0044d1ab
    # block 0x0044d1ad: entered by fall-through of je at 0x0044d1ab, 4 instruction(s), ends with je to 0x0044d1cd (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0044d1ad
    movsx edx, word ptr [ecx + field_1c]         # 0044d1b0
    cmp edx, -0x1                                # 0044d1b4
    je.d8 L_0044d1cd                             # 0044d1b7
    # block 0x0044d1b9: entered by fall-through of je at 0x0044d1b7, 4 instruction(s), falls into the block at 0x0044d1cd
    mov eax, dword ptr [ebp - local_4]           # 0044d1b9
    movsx ecx, word ptr [eax + field_1c]         # 0044d1bc
    imul ecx, ecx, 0x4a                          # 0044d1c0
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0044d1c3
L_0044d1cd:
    # block 0x0044d1cd: entered by je at 0x0044d1ab; je at 0x0044d1b7, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044d1cd
    pop ebp                                      # 0044d1cf
    ret                                          # 0044d1d0

