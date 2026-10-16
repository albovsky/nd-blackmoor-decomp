# FUN_004edae5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004edae5
# extent:       0x004edae5-0x004edb97 (178 code bytes)
# span:         0x004edae5-0x004edb97 (code 178, tables 0, padding 0)
# sha256:       7407f52b8423676957b9b22ac02f2a7b8fd634ee95c5c111b6bae9f68fffdb27
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004edae5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4af, field_675, field_681, field_68d; [ecx + n] field_4b3, field_679, field_685; [edx + n] field_4ab, field_67d, field_689
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4ab, 0x4ab  # offset +0x4ab
.equ field_4af, 0x4af  # offset +0x4af
.equ field_4b3, 0x4b3  # offset +0x4b3
.equ field_675, 0x675  # offset +0x675
.equ field_679, 0x679  # offset +0x679
.equ field_67d, 0x67d  # offset +0x67d
.equ field_681, 0x681  # offset +0x681
.equ field_685, 0x685  # offset +0x685
.equ field_689, 0x689  # offset +0x689
.equ field_68d, 0x68d  # offset +0x68d

# --- external targets -----------------------------------------------

.org 0x004edae5 - 0x401000
.globl FUN_004edae5
FUN_004edae5:
    # block 0x004edae5: entry, 36 instruction(s), ends with ret
    push ebp                                     # 004edae5
    {load} mov ebp, esp                          # 004edae6
    push ecx                                     # 004edae8
    push edi                                     # 004edae9
    mov dword ptr [ebp - local_4], ecx           # 004edaea
    mov eax, dword ptr [ebp - local_4]           # 004edaed
    mov dword ptr [eax + field_4af], 0x0         # 004edaf0
    mov ecx, dword ptr [ebp - local_4]           # 004edafa
    mov dword ptr [ecx + field_4b3], 0x0         # 004edafd
    mov edx, dword ptr [ebp - local_4]           # 004edb07
    mov dword ptr [edx + field_4ab], 0x0         # 004edb0a
    mov eax, dword ptr [ebp - local_4]           # 004edb14
    mov dword ptr [eax + field_675], 0x0         # 004edb17
    mov ecx, dword ptr [ebp - local_4]           # 004edb21
    mov dword ptr [ecx + field_679], 0x0         # 004edb24
    mov edx, dword ptr [ebp - local_4]           # 004edb2e
    mov dword ptr [edx + field_67d], 0x0         # 004edb31
    mov eax, dword ptr [ebp - local_4]           # 004edb3b
    mov dword ptr [eax + field_681], 0x0         # 004edb3e
    mov ecx, dword ptr [ebp - local_4]           # 004edb48
    mov dword ptr [ecx + field_685], 0x0         # 004edb4b
    mov dword ptr [0x55cd94], 0x1                # 004edb55
    mov dword ptr [0x63aa10], 0x0                # 004edb5f
    mov edx, dword ptr [ebp - local_4]           # 004edb69
    mov dword ptr [edx + field_689], 0x0         # 004edb6c
    mov eax, dword ptr [ebp - local_4]           # 004edb76
    mov dword ptr [eax + field_68d], 0x0         # 004edb79
    mov ecx, 0xbc                                # 004edb83
    {load} xor eax, eax                          # 004edb88
    mov edi, dword ptr [ebp - local_4]           # 004edb8a
    add edi, 0x2c                                # 004edb8d
    rep stosd dword ptr es:[edi], eax            # 004edb90
    pop edi                                      # 004edb92
    {load} mov esp, ebp                          # 004edb93
    pop ebp                                      # 004edb95
    ret                                          # 004edb96

