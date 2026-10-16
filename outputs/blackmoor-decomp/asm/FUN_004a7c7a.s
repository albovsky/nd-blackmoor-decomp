# FUN_004a7c7a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7c7a
# extent:       0x004a7c7a-0x004a7d1d (163 code bytes)
# span:         0x004a7c7a-0x004a7d1d (code 163, tables 0, padding 0)
# sha256:       3f6ac37b7e3c9627c436cbdf32ca0abcb879336815759aa0f3acc5d633c3574e
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a7c7a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_e10, field_e62, field_e7c, field_e83; [ecx + n] field_1c, field_e56, field_e5e, field_e7a; [edx + n] field_e5a, field_e72, field_e76, field_e7e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_e10, 0xe10  # offset +0xe10
.equ field_e56, 0xe56  # offset +0xe56
.equ field_e5a, 0xe5a  # offset +0xe5a
.equ field_e5e, 0xe5e  # offset +0xe5e
.equ field_e62, 0xe62  # offset +0xe62
.equ field_e72, 0xe72  # offset +0xe72
.equ field_e76, 0xe76  # offset +0xe76
.equ field_e7a, 0xe7a  # offset +0xe7a
.equ field_e7c, 0xe7c  # offset +0xe7c
.equ field_e7e, 0xe7e  # offset +0xe7e
.equ field_e83, 0xe83  # offset +0xe83

# --- external targets -----------------------------------------------

.org 0x004a7c7a - 0x401000
.globl FUN_004a7c7a
FUN_004a7c7a:
    # block 0x004a7c7a: entry, 33 instruction(s), ends with ret
    push ebp                                     # 004a7c7a
    {load} mov ebp, esp                          # 004a7c7b
    push ecx                                     # 004a7c7d
    mov dword ptr [ebp - local_4], ecx           # 004a7c7e
    mov eax, dword ptr [ebp - local_4]           # 004a7c81
    mov word ptr [eax + field_1e], 0xffff        # 004a7c84
    mov ecx, dword ptr [ebp - local_4]           # 004a7c8a
    mov word ptr [ecx + field_1c], 0xffff        # 004a7c8d
    mov edx, dword ptr [ebp - local_4]           # 004a7c93
    mov dword ptr [edx + field_e72], 0x0         # 004a7c96
    mov eax, dword ptr [ebp - local_4]           # 004a7ca0
    mov word ptr [eax + field_e7c], 0xffff       # 004a7ca3
    mov ecx, dword ptr [ebp - local_4]           # 004a7cac
    mov word ptr [ecx + field_e7a], 0xffff       # 004a7caf
    mov edx, dword ptr [ebp - local_4]           # 004a7cb8
    mov byte ptr [edx + field_e7e], 0x0          # 004a7cbb
    mov eax, dword ptr [ebp - local_4]           # 004a7cc2
    mov byte ptr [eax + field_e83], 0x0          # 004a7cc5
    mov ecx, dword ptr [ebp - local_4]           # 004a7ccc
    mov dword ptr [ecx + field_e5e], 0x0         # 004a7ccf
    mov edx, dword ptr [ebp - local_4]           # 004a7cd9
    mov dword ptr [edx + field_e76], 0x0         # 004a7cdc
    mov eax, dword ptr [ebp - local_4]           # 004a7ce6
    mov word ptr [eax + field_e10], 0xffff       # 004a7ce9
    mov ecx, dword ptr [ebp - local_4]           # 004a7cf2
    mov dword ptr [ecx + field_e56], 0x0         # 004a7cf5
    mov edx, dword ptr [ebp - local_4]           # 004a7cff
    mov dword ptr [edx + field_e5a], 0x0         # 004a7d02
    mov eax, dword ptr [ebp - local_4]           # 004a7d0c
    mov dword ptr [eax + field_e62], 0x0         # 004a7d0f
    {load} mov esp, ebp                          # 004a7d19
    pop ebp                                      # 004a7d1b
    ret                                          # 004a7d1c

