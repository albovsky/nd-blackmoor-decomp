# FUN_004db817
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db817
# extent:       0x004db817-0x004db870 (89 code bytes)
# span:         0x004db817-0x004db870 (code 89, tables 0, padding 0)
# sha256:       212fb2656efb3a13deaf6de715cb5a08b478d59064ccfde982087bff2d044b03
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4db817_lifted
# naming:       native port src/original_methods_fl39d.c:m4db817_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (34 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4, field_8, field_c
# callees:      calls FUN_00493a47, FUN_00493af0
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4db817_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00493a47, .text + (0x00493a47 - 0x401000)
.set FUN_00493af0, .text + (0x00493af0 - 0x401000)

.org 0x004db817 - 0x401000
.globl FUN_004db817
FUN_004db817:
    # block 0x004db817: entry, 22 instruction(s), calls FUN_00493a47, ends with je to 0x004db86c (forward)
    push ebp                                     # 004db817
    {load} mov ebp, esp                          # 004db818
    push ecx                                     # 004db81a
    mov dword ptr [ebp - local_4], ecx           # 004db81b
    mov eax, dword ptr [ebp - local_4]           # 004db81e
    add eax, 0x34                                # 004db821
    mov ecx, dword ptr [ebp - local_4]           # 004db824
    add ecx, 0x24                                # 004db827
    mov edx, dword ptr [eax]                     # 004db82a
    mov dword ptr [ecx], edx                     # 004db82c
    mov edx, dword ptr [eax + field_4]           # 004db82e
    mov dword ptr [ecx + field_4], edx           # 004db831
    mov edx, dword ptr [eax + field_8]           # 004db834
    mov dword ptr [ecx + field_8], edx           # 004db837
    mov eax, dword ptr [eax + field_c]           # 004db83a
    mov dword ptr [ecx + field_c], eax           # 004db83d
    mov dword ptr [0x5d1683], 0x1                # 004db840
    mov dword ptr [0x5d16cd], 0x0                # 004db84a
    mov ecx, 0x630a9a                            # 004db854
    call FUN_00493a47                            # 004db859
    test eax, eax                                # 004db85e
    je.d8 L_004db86c                             # 004db860
    # block 0x004db862: entered by fall-through of je at 0x004db860, 2 instruction(s), calls FUN_00493af0, falls into the block at 0x004db86c
    mov ecx, 0x630a9a                            # 004db862
    call FUN_00493af0                            # 004db867
L_004db86c:
    # block 0x004db86c: entered by je at 0x004db860, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004db86c
    pop ebp                                      # 004db86e
    ret                                          # 004db86f

