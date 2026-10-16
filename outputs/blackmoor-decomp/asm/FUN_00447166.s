# FUN_00447166
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447166
# extent:       0x00447166-0x004471ca (100 code bytes)
# span:         0x00447166-0x004471ca (code 100, tables 0, padding 0)
# sha256:       a055dead0ab06548aea5a9ff5819bdc598ffa0c87bb65ef0cb9713fe940918a2
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00447166
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1c, field_35; [ecx + n] field_31, field_35; [edx + n] field_31
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00447166 - 0x401000
.globl FUN_00447166
FUN_00447166:
    # block 0x00447166: entry, 9 instruction(s), ends with je to 0x0044719e (forward)
    push ebp                                     # 00447166
    {load} mov ebp, esp                          # 00447167
    sub esp, 0xc                                 # 00447169
    mov dword ptr [ebp - local_c], ecx           # 0044716c
    mov eax, dword ptr [ebp - local_c]           # 0044716f
    mov byte ptr [eax + field_1c], 0x0           # 00447172
    mov ecx, dword ptr [ebp - local_c]           # 00447176
    cmp dword ptr [ecx + field_31], 0x0          # 00447179
    je.d8 L_0044719e                             # 0044717d
    # block 0x0044717f: entered by fall-through of je at 0x0044717d, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044719e
    mov edx, dword ptr [ebp - local_c]           # 0044717f
    mov eax, dword ptr [edx + field_31]          # 00447182
    mov dword ptr [ebp - local_4], eax           # 00447185
    mov ecx, dword ptr [ebp - local_4]           # 00447188
    push ecx                                     # 0044718b
    call FUN_0051dc6c                            # 0044718c
    add esp, 0x4                                 # 00447191
    mov edx, dword ptr [ebp - local_c]           # 00447194
    mov dword ptr [edx + field_31], 0x0          # 00447197
L_0044719e:
    # block 0x0044719e: entered by je at 0x0044717d, 3 instruction(s), ends with je to 0x004471c6 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0044719e
    cmp dword ptr [eax + field_35], 0x0          # 004471a1
    je.d8 L_004471c6                             # 004471a5
    # block 0x004471a7: entered by fall-through of je at 0x004471a5, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004471c6
    mov ecx, dword ptr [ebp - local_c]           # 004471a7
    mov edx, dword ptr [ecx + field_35]          # 004471aa
    mov dword ptr [ebp - local_8], edx           # 004471ad
    mov eax, dword ptr [ebp - local_8]           # 004471b0
    push eax                                     # 004471b3
    call FUN_0051dc6c                            # 004471b4
    add esp, 0x4                                 # 004471b9
    mov ecx, dword ptr [ebp - local_c]           # 004471bc
    mov dword ptr [ecx + field_35], 0x0          # 004471bf
L_004471c6:
    # block 0x004471c6: entered by je at 0x004471a5, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004471c6
    pop ebp                                      # 004471c8
    ret                                          # 004471c9

