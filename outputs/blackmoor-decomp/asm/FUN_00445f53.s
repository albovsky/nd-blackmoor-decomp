# FUN_00445f53
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00445f53
# extent:       0x00445f53-0x00445fc5 (114 code bytes)
# span:         0x00445f53-0x00445fc5 (code 114, tables 0, padding 0)
# sha256:       a463f7a840cf35daebe3d4a411a77df582920ad77dd6fec30e4e8e9f39d4dfa5
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00445f53
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_25c; [ecx + n] field_c, field_27a; [edx + n] field_23c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ field_23c, 0x23c  # offset +0x23c
.equ field_25c, 0x25c  # offset +0x25c
.equ field_27a, 0x27a  # offset +0x27a

# --- external targets -----------------------------------------------

.org 0x00445f53 - 0x401000
.globl FUN_00445f53
FUN_00445f53:
    # block 0x00445f53: entry, 34 instruction(s), ends with ret
    push ebp                                     # 00445f53
    {load} mov ebp, esp                          # 00445f54
    push ecx                                     # 00445f56
    push edi                                     # 00445f57
    mov dword ptr [ebp - local_4], ecx           # 00445f58
    mov eax, dword ptr [ebp - local_4]           # 00445f5b
    mov dword ptr [eax + field_4], 0x0           # 00445f5e
    mov ecx, dword ptr [ebp - local_4]           # 00445f65
    mov dword ptr [ecx + field_c], 0x0           # 00445f68
    mov edx, dword ptr [ebp - local_4]           # 00445f6f
    mov dword ptr [edx + field_23c], 0x0         # 00445f72
    mov eax, dword ptr [ebp - local_4]           # 00445f7c
    mov byte ptr [eax + field_25c], 0x0          # 00445f7f
    mov ecx, dword ptr [ebp - local_4]           # 00445f86
    mov byte ptr [ecx + field_27a], 0x0          # 00445f89
    mov ecx, 0xa                                 # 00445f90
    {load} xor eax, eax                          # 00445f95
    mov edi, dword ptr [ebp - local_4]           # 00445f97
    add edi, 0x14                                # 00445f9a
    rep stosd dword ptr es:[edi], eax            # 00445f9d
    mov ecx, 0xa                                 # 00445f9f
    {load} xor eax, eax                          # 00445fa4
    mov edi, dword ptr [ebp - local_4]           # 00445fa6
    add edi, 0x3c                                # 00445fa9
    rep stosd dword ptr es:[edi], eax            # 00445fac
    mov ecx, 0x2e                                # 00445fae
    {load} xor eax, eax                          # 00445fb3
    mov edi, dword ptr [ebp - local_4]           # 00445fb5
    add edi, 0xbc                                # 00445fb8
    rep stosd dword ptr es:[edi], eax            # 00445fbe
    pop edi                                      # 00445fc0
    {load} mov esp, ebp                          # 00445fc1
    pop ebp                                      # 00445fc3
    ret                                          # 00445fc4

