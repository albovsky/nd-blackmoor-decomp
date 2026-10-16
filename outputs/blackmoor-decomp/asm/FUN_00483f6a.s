# FUN_00483f6a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00483f6a
# extent:       0x00483f6a-0x00483fb5 (75 code bytes)
# span:         0x00483f6a-0x00483fb5 (code 75, tables 0, padding 0)
# sha256:       ba788905e75086f9b1f4b580463e82a115a71f94cda011b5c77ede5734fcc623
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00483f6a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_26, field_bab; [ecx + n] field_1c, field_bb0; [edx + n] field_a92, field_ba7
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_26, 0x26  # offset +0x26
.equ field_a92, 0xa92  # offset +0xa92
.equ field_ba7, 0xba7  # offset +0xba7
.equ field_bab, 0xbab  # offset +0xbab
.equ field_bb0, 0xbb0  # offset +0xbb0

# --- external targets -----------------------------------------------

.org 0x00483f6a - 0x401000
.globl FUN_00483f6a
FUN_00483f6a:
    # block 0x00483f6a: entry, 19 instruction(s), ends with ret
    push ebp                                     # 00483f6a
    {load} mov ebp, esp                          # 00483f6b
    push ecx                                     # 00483f6d
    mov dword ptr [ebp - local_4], ecx           # 00483f6e
    mov eax, dword ptr [ebp - local_4]           # 00483f71
    mov word ptr [eax + field_26], 0xffff        # 00483f74
    mov ecx, dword ptr [ebp - local_4]           # 00483f7a
    mov word ptr [ecx + field_1c], 0xffff        # 00483f7d
    mov edx, dword ptr [ebp - local_4]           # 00483f83
    mov dword ptr [edx + field_ba7], 0x0         # 00483f86
    mov eax, dword ptr [ebp - local_4]           # 00483f90
    mov byte ptr [eax + field_bab], 0x0          # 00483f93
    mov ecx, dword ptr [ebp - local_4]           # 00483f9a
    mov byte ptr [ecx + field_bb0], 0x0          # 00483f9d
    mov edx, dword ptr [ebp - local_4]           # 00483fa4
    mov dword ptr [edx + field_a92], 0x0         # 00483fa7
    {load} mov esp, ebp                          # 00483fb1
    pop ebp                                      # 00483fb3
    ret                                          # 00483fb4

