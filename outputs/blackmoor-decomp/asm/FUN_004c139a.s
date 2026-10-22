# FUN_004c139a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c139a
# extent:       0x004c139a-0x004c1451 (183 code bytes)
# span:         0x004c139a-0x004c1451 (code 183, tables 0, padding 0)
# sha256:       e2388afef3cbd8b6064fe6260c1dc955be3487b47e11ed4d09735c43edf3af07
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c139a_lifted
# naming:       native port src/original_methods_fl39d.c:m4c139a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (16 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_1f28; [ecx + n] field_1f24, field_1f28; [edx + n] field_1f24
# callees:      calls FUN_0051dc6c, FUN_0043ef27
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4c139a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 46 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_1f24, 0x1f24  # offset +0x1f24
.equ field_1f28, 0x1f28  # offset +0x1f28

# --- external targets -----------------------------------------------
.set FUN_0043ef27, .text + (0x0043ef27 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004c139a - 0x401000
.globl FUN_004c139a
FUN_004c139a:
    # block 0x004c139a: entry, 15 instruction(s), ends with je to 0x004c13f9 (forward)
    push ebp                                     # 004c139a
    {load} mov ebp, esp                          # 004c139b
    push -0x1                                    # 004c139d
    push 0x5287ea                                # 004c139f
    mov eax, dword ptr fs:[0x0]                  # 004c13a4
    push eax                                     # 004c13aa
    mov dword ptr fs:[0x0], esp                  # 004c13ab
    sub esp, 0xc                                 # 004c13b2
    mov dword ptr [ebp - local_18], ecx          # 004c13b5
    mov eax, dword ptr [ebp - local_18]          # 004c13b8
    mov dword ptr [eax], 0x52e230                # 004c13bb
    mov dword ptr [ebp - local_4], 0x1           # 004c13c1
    mov ecx, dword ptr [ebp - local_18]          # 004c13c8
    cmp dword ptr [ecx + field_1f24], 0x0        # 004c13cb
    je.d8 L_004c13f9                             # 004c13d2
    # block 0x004c13d4: entered by fall-through of je at 0x004c13d2, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c13f9
    mov edx, dword ptr [ebp - local_18]          # 004c13d4
    mov eax, dword ptr [edx + field_1f24]        # 004c13d7
    mov dword ptr [ebp - local_10], eax          # 004c13dd
    mov ecx, dword ptr [ebp - local_10]          # 004c13e0
    push ecx                                     # 004c13e3
    call FUN_0051dc6c                            # 004c13e4
    add esp, 0x4                                 # 004c13e9
    mov edx, dword ptr [ebp - local_18]          # 004c13ec
    mov dword ptr [edx + field_1f24], 0x0        # 004c13ef
L_004c13f9:
    # block 0x004c13f9: entered by je at 0x004c13d2, 3 instruction(s), ends with je to 0x004c142a (forward)
    mov eax, dword ptr [ebp - local_18]          # 004c13f9
    cmp dword ptr [eax + field_1f28], 0x0        # 004c13fc
    je.d8 L_004c142a                             # 004c1403
    # block 0x004c1405: entered by fall-through of je at 0x004c1403, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c142a
    mov ecx, dword ptr [ebp - local_18]          # 004c1405
    mov edx, dword ptr [ecx + field_1f28]        # 004c1408
    mov dword ptr [ebp - local_14], edx          # 004c140e
    mov eax, dword ptr [ebp - local_14]          # 004c1411
    push eax                                     # 004c1414
    call FUN_0051dc6c                            # 004c1415
    add esp, 0x4                                 # 004c141a
    mov ecx, dword ptr [ebp - local_18]          # 004c141d
    mov dword ptr [ecx + field_1f28], 0x0        # 004c1420
L_004c142a:
    # block 0x004c142a: entered by je at 0x004c1403, 10 instruction(s), calls FUN_0043ef27, ends with ret
    mov byte ptr [ebp - local_4], 0x0            # 004c142a
    mov ecx, dword ptr [ebp - local_18]          # 004c142e
    add ecx, 0x38cc                              # 004c1431
    call FUN_0043ef27                            # 004c1437
    mov dword ptr [ebp - local_4], 0xffffffff    # 004c143c
    mov ecx, dword ptr [ebp - local_c]           # 004c1443
    mov dword ptr fs:[0x0], ecx                  # 004c1446
    {load} mov esp, ebp                          # 004c144d
    pop ebp                                      # 004c144f
    ret                                          # 004c1450

