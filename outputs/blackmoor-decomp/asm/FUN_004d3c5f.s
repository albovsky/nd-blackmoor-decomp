# FUN_004d3c5f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3c5f
# extent:       0x004d3c5f-0x004d3c88 (41 code bytes)
# span:         0x004d3c5f-0x004d3c88 (code 41, tables 0, padding 0)
# sha256:       d84aaecefb70ae14598dac8683f30d20331ff8aa477e1d91f1be97644ec67083
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3c5f_set_ready
# naming:       native port src/original_methods_fl20a.c:m4d3c5f_set_ready (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4d3c5f_set_ready. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 41 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_326
# callees:      calls FUN_004d3c31, FUN_004d3d20
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20a.c:m4d3c5f_set_ready (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_326, 0x326  # offset +0x326

# --- external targets -----------------------------------------------
.set FUN_004d3c31, .text + (0x004d3c31 - 0x401000)
.set FUN_004d3d20, .text + (0x004d3d20 - 0x401000)

.org 0x004d3c5f - 0x401000
.globl FUN_004d3c5f
FUN_004d3c5f:
    # block 0x004d3c5f: entry, 8 instruction(s), calls FUN_004d3c31, ends with je to 0x004d3c7a (forward)
    push ebp                                     # 004d3c5f
    {load} mov ebp, esp                          # 004d3c60
    push ecx                                     # 004d3c62
    mov dword ptr [ebp - local_4], ecx           # 004d3c63
    mov ecx, dword ptr [ebp - local_4]           # 004d3c66
    call FUN_004d3c31                            # 004d3c69
    test eax, eax                                # 004d3c6e
    je.d8 L_004d3c7a                             # 004d3c70
    # block 0x004d3c72: entered by fall-through of je at 0x004d3c70, 2 instruction(s), calls FUN_004d3d20, falls into the block at 0x004d3c7a
    mov ecx, dword ptr [ebp - local_4]           # 004d3c72
    call FUN_004d3d20                            # 004d3c75
L_004d3c7a:
    # block 0x004d3c7a: entered by je at 0x004d3c70, 5 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_4]           # 004d3c7a
    mov byte ptr [eax + field_326], 0x1          # 004d3c7d
    {load} mov esp, ebp                          # 004d3c84
    pop ebp                                      # 004d3c86
    ret                                          # 004d3c87

