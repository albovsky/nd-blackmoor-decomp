# FUN_00446075
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00446075
# extent:       0x00446075-0x004460d6 (97 code bytes)
# span:         0x00446075-0x004460d6 (code 97, tables 0, padding 0)
# sha256:       88bf59a676aa31a178c9f63957e41e871490ddac59eae92b9f2508c2bf59dadf
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00446075
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_234; [ecx + n] field_8, field_16c; [edx + n] field_16c, field_234
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_16c, 0x16c  # offset +0x16c
.equ field_234, 0x234  # offset +0x234

# --- external targets -----------------------------------------------

.org 0x00446075 - 0x401000
.globl FUN_00446075
FUN_00446075:
    # block 0x00446075: entry, 7 instruction(s), ends with je to 0x004460a7 (forward)
    push ebp                                     # 00446075
    {load} mov ebp, esp                          # 00446076
    push ecx                                     # 00446078
    mov dword ptr [ebp - local_4], ecx           # 00446079
    mov eax, dword ptr [ebp - local_4]           # 0044607c
    cmp dword ptr [eax + field_4], 0x0           # 0044607f
    je.d8 L_004460a7                             # 00446083
    # block 0x00446085: entered by fall-through of je at 0x00446083, 3 instruction(s), ends with je to 0x004460a7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00446085
    cmp dword ptr [ecx + field_16c], -0x1        # 00446088
    je.d8 L_004460a7                             # 0044608f
    # block 0x00446091: entered by fall-through of je at 0x0044608f, 4 instruction(s), falls into the block at 0x004460a7
    mov edx, dword ptr [ebp - local_4]           # 00446091
    mov eax, dword ptr [edx + field_16c]         # 00446094
    imul eax, eax, 0x4a                          # 0044609a
    mov dword ptr [eax + 0x5d15a5], 0x1          # 0044609d
L_004460a7:
    # block 0x004460a7: entered by je at 0x00446083; je at 0x0044608f, 3 instruction(s), ends with je to 0x004460d2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004460a7
    cmp dword ptr [ecx + field_8], 0x0           # 004460aa
    je.d8 L_004460d2                             # 004460ae
    # block 0x004460b0: entered by fall-through of je at 0x004460ae, 3 instruction(s), ends with je to 0x004460d2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004460b0
    cmp dword ptr [edx + field_234], -0x1        # 004460b3
    je.d8 L_004460d2                             # 004460ba
    # block 0x004460bc: entered by fall-through of je at 0x004460ba, 4 instruction(s), falls into the block at 0x004460d2
    mov eax, dword ptr [ebp - local_4]           # 004460bc
    mov ecx, dword ptr [eax + field_234]         # 004460bf
    imul ecx, ecx, 0x4a                          # 004460c5
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004460c8
L_004460d2:
    # block 0x004460d2: entered by je at 0x004460ae; je at 0x004460ba, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004460d2
    pop ebp                                      # 004460d4
    ret                                          # 004460d5

