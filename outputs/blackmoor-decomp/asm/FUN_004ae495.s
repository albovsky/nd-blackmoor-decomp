# FUN_004ae495
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ae495
# extent:       0x004ae495-0x004ae4d7 (66 code bytes)
# span:         0x004ae495-0x004ae4d7 (code 66, tables 0, padding 0)
# sha256:       c3bd187642540d10c236a569e3b0f73a8fb7ada27512652cc57b13db526847d3
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ae495
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_26; [ecx + n] field_8, field_6e; [edx + n] field_27
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_6e, 0x6e  # offset +0x6e

# --- external targets -----------------------------------------------

.org 0x004ae495 - 0x401000
.globl FUN_004ae495
FUN_004ae495:
    # block 0x004ae495: entry, 23 instruction(s), ends with ret 0x4
    push ebp                                     # 004ae495
    {load} mov ebp, esp                          # 004ae496
    sub esp, 0xc                                 # 004ae498
    mov dword ptr [ebp - local_c], ecx           # 004ae49b
    mov eax, dword ptr [ebp + arg_8]             # 004ae49e
    imul eax, eax, 0xc7                          # 004ae4a1
    mov ecx, dword ptr [ebp - local_c]           # 004ae4a7
    lea edx, [ecx + eax + field_6e]              # 004ae4aa
    mov dword ptr [ebp - local_8], edx           # 004ae4ae
    mov eax, dword ptr [ebp - local_8]           # 004ae4b1
    {load} xor ecx, ecx                          # 004ae4b4
    mov cl, byte ptr [eax + field_26]            # 004ae4b6
    imul ecx, ecx, 0x28                          # 004ae4b9
    mov edx, dword ptr [ebp - local_8]           # 004ae4bc
    lea eax, [edx + ecx + field_27]              # 004ae4bf
    mov dword ptr [ebp - local_4], eax           # 004ae4c3
    mov ecx, dword ptr [ebp - local_4]           # 004ae4c6
    mov edx, dword ptr [ebp - local_4]           # 004ae4c9
    mov eax, dword ptr [edx]                     # 004ae4cc
    mov dword ptr [ecx + field_8], eax           # 004ae4ce
    {load} mov esp, ebp                          # 004ae4d1
    pop ebp                                      # 004ae4d3
    ret 0x4                                      # 004ae4d4

