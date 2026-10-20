# FUN_0047e52f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e52f
# extent:       0x0047e52f-0x0047e582 (83 code bytes)
# span:         0x0047e52f-0x0047e582 (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         translate
# naming:       native port src/action_family_eb_runtime.c:translate (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with translate (rect plus view origin). Native: offsets inside the object image; returns a status on host view failure (no original path).
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_eb_runtime.c:translate (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0047e52f - 0x401000
.globl FUN_0047e52f
FUN_0047e52f:
    # block 0x0047e52f: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 0047e52f
    {load} mov ebp, esp                          # 0047e530
    push ecx                                     # 0047e532
    mov dword ptr [ebp - local_4], ecx           # 0047e533
    mov eax, dword ptr [ebp + arg_8]             # 0047e536
    mov ecx, dword ptr [eax + field_4]           # 0047e539
    add ecx, dword ptr [0x58318a]                # 0047e53c
    mov edx, dword ptr [ebp + arg_c]             # 0047e542
    mov dword ptr [edx + field_4], ecx           # 0047e545
    mov eax, dword ptr [ebp + arg_8]             # 0047e548
    mov ecx, dword ptr [eax + field_c]           # 0047e54b
    add ecx, dword ptr [0x58318a]                # 0047e54e
    mov edx, dword ptr [ebp + arg_c]             # 0047e554
    mov dword ptr [edx + field_c], ecx           # 0047e557
    mov eax, dword ptr [ebp + arg_8]             # 0047e55a
    mov ecx, dword ptr [eax]                     # 0047e55d
    add ecx, dword ptr [0x583186]                # 0047e55f
    mov edx, dword ptr [ebp + arg_c]             # 0047e565
    mov dword ptr [edx], ecx                     # 0047e568
    mov eax, dword ptr [ebp + arg_8]             # 0047e56a
    mov ecx, dword ptr [eax + field_8]           # 0047e56d
    add ecx, dword ptr [0x583186]                # 0047e570
    mov edx, dword ptr [ebp + arg_c]             # 0047e576
    mov dword ptr [edx + field_8], ecx           # 0047e579
    {load} mov esp, ebp                          # 0047e57c
    pop ebp                                      # 0047e57e
    ret 0x8                                      # 0047e57f

