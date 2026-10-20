# FUN_004c08d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c08d3
# extent:       0x004c08d3-0x004c09fe (299 code bytes)
# span:         0x004c08d3-0x004c09fe (code 299, tables 0, padding 0)
# sha256:       e2448122431318d65674c214f5954c8fb21a613d8a09cf62d61de697567378ad
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c08d3_shift_rects
# naming:       native port src/original_methods_fl18.c:m4c08d3_shift_rects (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4c08d3_shift_rects. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 299 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2, field_1e, field_1ea, field_1ee, field_24a; [ecx + n] field_6, field_a, field_12, field_1de, field_1f2, field_1f6, field_1fe, field_202, field_206, field_20a, field_24a; [edx + n] field_e, field_16, field_1a, field_1e2, field_1e6, field_1ee, field_1f2, field_1f6, field_1fa, field_24a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl18.c:m4c08d3_shift_rects (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 71 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2, 0x2  # offset +0x2
.equ field_6, 0x6  # offset +0x6
.equ field_a, 0xa  # offset +0xa
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1e, 0x1e  # offset +0x1e
.equ field_1de, 0x1de  # offset +0x1de
.equ field_1e2, 0x1e2  # offset +0x1e2
.equ field_1e6, 0x1e6  # offset +0x1e6
.equ field_1ea, 0x1ea  # offset +0x1ea
.equ field_1ee, 0x1ee  # offset +0x1ee
.equ field_1f2, 0x1f2  # offset +0x1f2
.equ field_1f6, 0x1f6  # offset +0x1f6
.equ field_1fa, 0x1fa  # offset +0x1fa
.equ field_1fe, 0x1fe  # offset +0x1fe
.equ field_202, 0x202  # offset +0x202
.equ field_206, 0x206  # offset +0x206
.equ field_20a, 0x20a  # offset +0x20a
.equ field_24a, 0x24a  # offset +0x24a

# --- external targets -----------------------------------------------

.org 0x004c08d3 - 0x401000
.globl FUN_004c08d3
FUN_004c08d3:
    # block 0x004c08d3: entry, 71 instruction(s), ends with ret
    push ebp                                     # 004c08d3
    {load} mov ebp, esp                          # 004c08d4
    push ecx                                     # 004c08d6
    mov dword ptr [ebp - local_4], ecx           # 004c08d7
    mov eax, dword ptr [ebp - local_4]           # 004c08da
    mov ecx, dword ptr [eax + field_24a]         # 004c08dd
    mov edx, dword ptr [ebp - local_4]           # 004c08e3
    mov eax, dword ptr [ecx + field_6]           # 004c08e6
    mov dword ptr [edx + field_1e2], eax         # 004c08e9
    mov ecx, dword ptr [ebp - local_4]           # 004c08ef
    mov edx, dword ptr [ecx + field_24a]         # 004c08f2
    mov eax, dword ptr [ebp - local_4]           # 004c08f8
    mov ecx, dword ptr [edx + field_e]           # 004c08fb
    mov dword ptr [eax + field_1ea], ecx         # 004c08fe
    mov edx, dword ptr [ebp - local_4]           # 004c0904
    mov eax, dword ptr [edx + field_24a]         # 004c0907
    mov ecx, dword ptr [ebp - local_4]           # 004c090d
    mov edx, dword ptr [eax + field_2]           # 004c0910
    mov dword ptr [ecx + field_1de], edx         # 004c0913
    mov eax, dword ptr [ebp - local_4]           # 004c0919
    mov ecx, dword ptr [eax + field_24a]         # 004c091c
    mov edx, dword ptr [ebp - local_4]           # 004c0922
    mov eax, dword ptr [ecx + field_a]           # 004c0925
    mov dword ptr [edx + field_1e6], eax         # 004c0928
    mov ecx, dword ptr [ebp - local_4]           # 004c092e
    mov edx, dword ptr [ecx + field_24a]         # 004c0931
    mov eax, dword ptr [edx + field_16]          # 004c0937
    add eax, dword ptr [0x58318a]                # 004c093a
    mov ecx, dword ptr [ebp - local_4]           # 004c0940
    mov dword ptr [ecx + field_1f2], eax         # 004c0943
    mov edx, dword ptr [ebp - local_4]           # 004c0949
    mov eax, dword ptr [edx + field_24a]         # 004c094c
    mov ecx, dword ptr [eax + field_1e]          # 004c0952
    add ecx, dword ptr [0x58318a]                # 004c0955
    mov edx, dword ptr [ebp - local_4]           # 004c095b
    mov dword ptr [edx + field_1fa], ecx         # 004c095e
    mov eax, dword ptr [ebp - local_4]           # 004c0964
    mov ecx, dword ptr [eax + field_24a]         # 004c0967
    mov edx, dword ptr [ecx + field_12]          # 004c096d
    add edx, dword ptr [0x583186]                # 004c0970
    mov eax, dword ptr [ebp - local_4]           # 004c0976
    mov dword ptr [eax + field_1ee], edx         # 004c0979
    mov ecx, dword ptr [ebp - local_4]           # 004c097f
    mov edx, dword ptr [ecx + field_24a]         # 004c0982
    mov eax, dword ptr [edx + field_1a]          # 004c0988
    add eax, dword ptr [0x583186]                # 004c098b
    mov ecx, dword ptr [ebp - local_4]           # 004c0991
    mov dword ptr [ecx + field_1f6], eax         # 004c0994
    mov edx, dword ptr [ebp - local_4]           # 004c099a
    mov eax, dword ptr [edx + field_1f2]         # 004c099d
    sub eax, dword ptr [0x58318a]                # 004c09a3
    mov ecx, dword ptr [ebp - local_4]           # 004c09a9
    mov dword ptr [ecx + field_202], eax         # 004c09ac
    mov edx, dword ptr [ebp - local_4]           # 004c09b2
    mov eax, dword ptr [edx + field_1fa]         # 004c09b5
    sub eax, dword ptr [0x58318a]                # 004c09bb
    mov ecx, dword ptr [ebp - local_4]           # 004c09c1
    mov dword ptr [ecx + field_20a], eax         # 004c09c4
    mov edx, dword ptr [ebp - local_4]           # 004c09ca
    mov eax, dword ptr [edx + field_1ee]         # 004c09cd
    sub eax, dword ptr [0x583186]                # 004c09d3
    mov ecx, dword ptr [ebp - local_4]           # 004c09d9
    mov dword ptr [ecx + field_1fe], eax         # 004c09dc
    mov edx, dword ptr [ebp - local_4]           # 004c09e2
    mov eax, dword ptr [edx + field_1f6]         # 004c09e5
    sub eax, dword ptr [0x583186]                # 004c09eb
    mov ecx, dword ptr [ebp - local_4]           # 004c09f1
    mov dword ptr [ecx + field_206], eax         # 004c09f4
    {load} mov esp, ebp                          # 004c09fa
    pop ebp                                      # 004c09fc
    ret                                          # 004c09fd

