# FUN_004618ab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004618ab
# extent:       0x004618ab-0x004618df (52 code bytes)
# span:         0x004618ab-0x004618df (code 52, tables 0, padding 0)
# sha256:       0c4cac37cbe806d1015a6d647c96305802f683eadaaf5f12b05526349fb0c43d
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         cpz_invalidate
# naming:       native port src/action_family_d3_runtime.c:cpz_invalidate (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with cpz_invalidate (active +0x3f != 0 and slot +0x1c != -1, then redraw dword := 1). The store is the host mark_dirty callback. Native-only: NULL args -> CPZ_ERR_ARGUMENT, host error -> CPZ_ERR_HOST.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_3f; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d3_runtime.c:cpz_invalidate (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_3f, 0x3f  # offset +0x3f

# --- external targets -----------------------------------------------

.org 0x004618ab - 0x401000
.globl FUN_004618ab
FUN_004618ab:
    # block 0x004618ab: entry, 7 instruction(s), ends with je to 0x004618db (forward)
    push ebp                                     # 004618ab
    {load} mov ebp, esp                          # 004618ac
    push ecx                                     # 004618ae
    mov dword ptr [ebp - local_4], ecx           # 004618af
    mov eax, dword ptr [ebp - local_4]           # 004618b2
    cmp dword ptr [eax + field_3f], 0x0          # 004618b5
    je.d8 L_004618db                             # 004618b9
    # block 0x004618bb: entered by fall-through of je at 0x004618b9, 4 instruction(s), ends with je to 0x004618db (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004618bb
    movsx edx, word ptr [ecx + field_1c]         # 004618be
    cmp edx, -0x1                                # 004618c2
    je.d8 L_004618db                             # 004618c5
    # block 0x004618c7: entered by fall-through of je at 0x004618c5, 4 instruction(s), falls into the block at 0x004618db
    mov eax, dword ptr [ebp - local_4]           # 004618c7
    movsx ecx, word ptr [eax + field_1c]         # 004618ca
    imul ecx, ecx, 0x4a                          # 004618ce
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004618d1
L_004618db:
    # block 0x004618db: entered by je at 0x004618b9; je at 0x004618c5, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004618db
    pop ebp                                      # 004618dd
    ret                                          # 004618de

