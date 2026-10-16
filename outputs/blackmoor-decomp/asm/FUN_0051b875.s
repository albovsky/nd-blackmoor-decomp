# FUN_0051b875
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b875
# extent:       0x0051b875-0x0051b8bb (70 code bytes)
# span:         0x0051b875-0x0051b8bb (code 70, tables 0, padding 0)
# sha256:       edb46b43a956f8051bbf5ff2e8519fd8c9b740afe3e9dd6aaf836fbbf0025eb8
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b875
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_38, field_98
# callees:      calls FUN_00525b0f; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_38, 0x38  # offset +0x38
.equ field_98, 0x98  # offset +0x98

# --- external targets -----------------------------------------------
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051b875 - 0x401000
.globl FUN_0051b875
FUN_0051b875:
    # block 0x0051b875: entry, 25 instruction(s), calls FUN_00525b0f, indirect dword ptr [eax + 0x98], ends with ret 0x8
    push ebp                                     # 0051b875
    {load} mov ebp, esp                          # 0051b876
    sub esp, 0xc                                 # 0051b878
    mov eax, dword ptr [ebp + arg_8]             # 0051b87b
    push esi                                     # 0051b87e
    {load} mov esi, ecx                          # 0051b87f
    mov dword ptr [ebp - local_8], eax           # 0051b881
    mov eax, dword ptr [ebp + arg_c]             # 0051b884
    push 0x52496c                                # 0051b887
    mov ecx, 0x63c444                            # 0051b88c
    mov dword ptr [ebp - local_c], eax           # 0051b891
    call FUN_00525b0f                            # 0051b894
    mov eax, dword ptr [eax + field_38]          # 0051b899
    lea ecx, [ebp - local_c]                     # 0051b89c
    sub eax, 0x132                               # 0051b89f
    push ecx                                     # 0051b8a4
    mov dword ptr [ebp - local_4], eax           # 0051b8a5
    mov eax, dword ptr [esi]                     # 0051b8a8
    push 0x0                                     # 0051b8aa
    push 0x19                                    # 0051b8ac
    {load} mov ecx, esi                          # 0051b8ae
    call dword ptr [eax + field_98]              # 0051b8b0
    pop esi                                      # 0051b8b6
    leave                                        # 0051b8b7
    ret 0x8                                      # 0051b8b8

