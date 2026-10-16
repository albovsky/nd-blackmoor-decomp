# FUN_004afd3a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afd3a
# extent:       0x004afd3a-0x004afd7e (68 code bytes)
# span:         0x004afd3a-0x004afd7e (code 68, tables 0, padding 0)
# sha256:       7581a961d141e222004bd57b15808aa82100a2c89033a1dff60602b6a1fde094
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004afd3a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_1519; [ecx + n] field_1c, field_151d; [edx + n] field_1515
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_1515, 0x1515  # offset +0x1515
.equ field_1519, 0x1519  # offset +0x1519
.equ field_151d, 0x151d  # offset +0x151d

# --- external targets -----------------------------------------------

.org 0x004afd3a - 0x401000
.globl FUN_004afd3a
FUN_004afd3a:
    # block 0x004afd3a: entry, 17 instruction(s), ends with ret
    push ebp                                     # 004afd3a
    {load} mov ebp, esp                          # 004afd3b
    push ecx                                     # 004afd3d
    mov dword ptr [ebp - local_4], ecx           # 004afd3e
    mov eax, dword ptr [ebp - local_4]           # 004afd41
    mov word ptr [eax + field_1e], 0xffff        # 004afd44
    mov ecx, dword ptr [ebp - local_4]           # 004afd4a
    mov word ptr [ecx + field_1c], 0xffff        # 004afd4d
    mov edx, dword ptr [ebp - local_4]           # 004afd53
    mov dword ptr [edx + field_1515], 0x0        # 004afd56
    mov eax, dword ptr [ebp - local_4]           # 004afd60
    mov dword ptr [eax + field_1519], 0x0        # 004afd63
    mov ecx, dword ptr [ebp - local_4]           # 004afd6d
    mov dword ptr [ecx + field_151d], 0x0        # 004afd70
    {load} mov esp, ebp                          # 004afd7a
    pop ebp                                      # 004afd7c
    ret                                          # 004afd7d

