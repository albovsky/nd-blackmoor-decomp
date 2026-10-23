# FUN_004d3fa9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3fa9
# extent:       0x004d3fa9-0x004d3ffe (85 code bytes)
# span:         0x004d3fa9-0x004d3ffe (code 85, tables 0, padding 0)
# sha256:       7ee243f37f784323a4374d4e15619736889f0f02d95c099c340da5cc64c11402
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3fa9_lifted
# naming:       native port src/original_methods_fl41.c:m4d3fa9_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 8 seeds; oracle: 24/24 instructions, 2/2 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_456, field_462; [edx + n] field_324, field_452
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4d3fa9_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_324, 0x324  # offset +0x324
.equ field_452, 0x452  # offset +0x452
.equ field_456, 0x456  # offset +0x456
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004d3fa9 - 0x401000
.globl FUN_004d3fa9
FUN_004d3fa9:
    # block 0x004d3fa9: entry, 10 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x004d3ffa (forward)
    push ebp                                     # 004d3fa9
    {load} mov ebp, esp                          # 004d3faa
    sub esp, 0x8                                 # 004d3fac
    mov dword ptr [ebp - local_8], ecx           # 004d3faf
    call dword ptr [0x52a23c]                    # 004d3fb2
    mov dword ptr [ebp - local_4], eax           # 004d3fb8
    mov eax, dword ptr [ebp - local_8]           # 004d3fbb
    mov ecx, dword ptr [ebp - local_4]           # 004d3fbe
    cmp ecx, dword ptr [eax + field_456]         # 004d3fc1
    jbe.d8 L_004d3ffa                            # 004d3fc7
    # block 0x004d3fc9: entered by fall-through of jbe at 0x004d3fc7, 11 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004d3ffa
    mov edx, dword ptr [ebp - local_8]           # 004d3fc9
    movsx eax, word ptr [edx + field_324]        # 004d3fcc
    mov ecx, dword ptr [ebp - local_4]           # 004d3fd3
    {load} add ecx, eax                          # 004d3fd6
    mov edx, dword ptr [ebp - local_8]           # 004d3fd8
    mov dword ptr [edx + field_452], ecx         # 004d3fdb
    push 0x14                                    # 004d3fe1
    mov ecx, 0x5c3a67                            # 004d3fe3
    call FUN_004fb2e3                            # 004d3fe8
    mov eax, dword ptr [ebp - local_8]           # 004d3fed
    mov dword ptr [eax + field_462], 0x1         # 004d3ff0
L_004d3ffa:
    # block 0x004d3ffa: entered by jbe at 0x004d3fc7, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d3ffa
    pop ebp                                      # 004d3ffc
    ret                                          # 004d3ffd

