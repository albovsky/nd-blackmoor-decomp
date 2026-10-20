# FUN_00423b51
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423b51
# extent:       0x00423b51-0x00423c2b (218 code bytes)
# span:         0x00423b51-0x00423c2b (code 218, tables 0, padding 0)
# sha256:       918a1b51e6a925839988b64f0ffc7c30a9fdff1053d35bfb65375dbbccd04a3a
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m423b51_reset_record
# naming:       native port src/original_methods_fl18.c:m423b51_reset_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m423b51_reset_record. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 218 bytes.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_c, field_18, field_24, field_30; [ecx + n] field_4, field_10, field_1c, field_28, field_34; [edx + n] field_4, field_8, field_14, field_20, field_2c, field_38
# callees:      calls FUN_004234c8, FUN_00423876
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl18.c:m423b51_reset_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 53 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_004234c8, .text + (0x004234c8 - 0x401000)
.set FUN_00423876, .text + (0x00423876 - 0x401000)

.org 0x00423b51 - 0x401000
.globl FUN_00423b51
FUN_00423b51:
    # block 0x00423b51: entry, 15 instruction(s), calls FUN_004234c8, ends with je to 0x00423b90 (forward)
    push ebp                                     # 00423b51
    {load} mov ebp, esp                          # 00423b52
    sub esp, 0xc                                 # 00423b54
    mov dword ptr [ebp - local_c], ecx           # 00423b57
    mov ecx, dword ptr [ebp - local_c]           # 00423b5a
    call FUN_004234c8                            # 00423b5d
    mov eax, dword ptr [ebp + arg_8]             # 00423b62
    imul eax, eax, 0x8d                          # 00423b65
    add eax, 0x5bb5e9                            # 00423b6b
    mov dword ptr [ebp - local_4], eax           # 00423b70
    mov ecx, dword ptr [ebp - local_4]           # 00423b73
    mov dword ptr [ebp - local_8], ecx           # 00423b76
    mov edx, dword ptr [ebp - local_8]           # 00423b79
    cmp dword ptr [edx + field_4], 0x0           # 00423b7c
    je.d8 L_00423b90                             # 00423b80
    # block 0x00423b82: entered by fall-through of je at 0x00423b80, 5 instruction(s), calls FUN_00423876, falls into the block at 0x00423b90
    push 0x0                                     # 00423b82
    lea eax, [ebp - local_8]                     # 00423b84
    push eax                                     # 00423b87
    mov ecx, dword ptr [ebp - local_c]           # 00423b88
    call FUN_00423876                            # 00423b8b
L_00423b90:
    # block 0x00423b90: entered by je at 0x00423b80, 33 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - local_4]           # 00423b90
    mov dword ptr [ecx + field_1c], 0x0          # 00423b93
    mov edx, dword ptr [ebp - local_4]           # 00423b9a
    mov dword ptr [edx + field_20], 0x0          # 00423b9d
    mov eax, dword ptr [ebp - local_4]           # 00423ba4
    mov dword ptr [eax + field_24], 0x0          # 00423ba7
    mov ecx, dword ptr [ebp - local_4]           # 00423bae
    mov dword ptr [ecx + field_28], 0x0          # 00423bb1
    mov edx, dword ptr [ebp - local_4]           # 00423bb8
    mov dword ptr [edx + field_2c], 0x0          # 00423bbb
    mov eax, dword ptr [ebp - local_4]           # 00423bc2
    mov dword ptr [eax + field_30], 0x0          # 00423bc5
    mov ecx, dword ptr [ebp - local_4]           # 00423bcc
    mov dword ptr [ecx + field_34], 0x0          # 00423bcf
    mov edx, dword ptr [ebp - local_4]           # 00423bd6
    mov dword ptr [edx + field_38], 0x0          # 00423bd9
    mov eax, dword ptr [ebp - local_8]           # 00423be0
    mov dword ptr [eax], 0x0                     # 00423be3
    mov ecx, dword ptr [ebp - local_8]           # 00423be9
    mov dword ptr [ecx + field_4], 0x0           # 00423bec
    mov edx, dword ptr [ebp - local_8]           # 00423bf3
    mov dword ptr [edx + field_8], 0xffffffff    # 00423bf6
    mov eax, dword ptr [ebp - local_8]           # 00423bfd
    mov dword ptr [eax + field_c], 0x0           # 00423c00
    mov ecx, dword ptr [ebp - local_8]           # 00423c07
    mov dword ptr [ecx + field_10], 0x0          # 00423c0a
    mov edx, dword ptr [ebp - local_8]           # 00423c11
    mov dword ptr [edx + field_14], 0x0          # 00423c14
    mov eax, dword ptr [ebp - local_8]           # 00423c1b
    mov dword ptr [eax + field_18], 0x0          # 00423c1e
    {load} mov esp, ebp                          # 00423c25
    pop ebp                                      # 00423c27
    ret 0x4                                      # 00423c28

