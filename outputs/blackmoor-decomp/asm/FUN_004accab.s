# FUN_004accab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004accab
# extent:       0x004accab-0x004acdc2 (279 code bytes)
# span:         0x004accab-0x004acdc2 (code 279, tables 0, padding 0)
# sha256:       38d0fc3758ae05e1a1e3c61bc97c40f9358444e2d994664cd1e755ffdde3ca49
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004accab
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_c, field_24; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c, field_6e
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4accab_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 90 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_24, 0x24  # offset +0x24
.equ field_6e, 0x6e  # offset +0x6e

# --- external targets -----------------------------------------------

.org 0x004accab - 0x401000
.globl FUN_004accab
FUN_004accab:
    # block 0x004accab: entry, 17 instruction(s), ends with jge to 0x004acd11 (forward)
    push ebp                                     # 004accab
    {load} mov ebp, esp                          # 004accac
    sub esp, 0x10                                # 004accae
    mov dword ptr [ebp - local_10], ecx          # 004accb1
    mov eax, dword ptr [ebp - local_10]          # 004accb4
    movsx ecx, word ptr [eax + field_24]         # 004accb7
    imul ecx, ecx, 0xc7                          # 004accbb
    mov edx, dword ptr [ebp - local_10]          # 004accc1
    lea eax, [edx + ecx + field_6e]              # 004accc4
    mov dword ptr [ebp - local_c], eax           # 004accc8
    mov ecx, dword ptr [ebp - local_c]           # 004acccb
    add ecx, 0x2                                 # 004accce
    mov dword ptr [ebp - local_4], ecx           # 004accd1
    mov edx, dword ptr [ebp - local_4]           # 004accd4
    mov eax, dword ptr [edx + field_4]           # 004accd7
    cmp eax, dword ptr [0x58319a]                # 004accda
    jge.d8 L_004acd11                            # 004acce0
    # block 0x004acce2: entered by fall-through of jge at 0x004acce0, 15 instruction(s), ends with forward jump to 0x004acd4c
    mov ecx, dword ptr [ebp - local_4]           # 004acce2
    mov edx, dword ptr [0x58319a]                # 004acce5
    sub edx, dword ptr [ecx + field_4]           # 004acceb
    mov dword ptr [ebp - local_8], edx           # 004accee
    mov eax, dword ptr [ebp - local_4]           # 004accf1
    mov ecx, dword ptr [eax + field_4]           # 004accf4
    add ecx, dword ptr [ebp - local_8]           # 004accf7
    mov edx, dword ptr [ebp - local_4]           # 004accfa
    mov dword ptr [edx + field_4], ecx           # 004accfd
    mov eax, dword ptr [ebp - local_4]           # 004acd00
    mov ecx, dword ptr [eax + field_c]           # 004acd03
    add ecx, dword ptr [ebp - local_8]           # 004acd06
    mov edx, dword ptr [ebp - local_4]           # 004acd09
    mov dword ptr [edx + field_c], ecx           # 004acd0c
    jmp.d8 L_004acd4c                            # 004acd0f
L_004acd11:
    # block 0x004acd11: entered by jge at 0x004acce0, 4 instruction(s), ends with jle to 0x004acd4c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004acd11
    mov ecx, dword ptr [eax + field_c]           # 004acd14
    cmp ecx, dword ptr [0x5831a2]                # 004acd17
    jle.d8 L_004acd4c                            # 004acd1d
    # block 0x004acd1f: entered by fall-through of jle at 0x004acd1d, 14 instruction(s), falls into the block at 0x004acd4c
    mov edx, dword ptr [ebp - local_4]           # 004acd1f
    mov eax, dword ptr [edx + field_c]           # 004acd22
    sub eax, dword ptr [0x5831a2]                # 004acd25
    mov dword ptr [ebp - local_8], eax           # 004acd2b
    mov ecx, dword ptr [ebp - local_4]           # 004acd2e
    mov edx, dword ptr [ecx + field_4]           # 004acd31
    sub edx, dword ptr [ebp - local_8]           # 004acd34
    mov eax, dword ptr [ebp - local_4]           # 004acd37
    mov dword ptr [eax + field_4], edx           # 004acd3a
    mov ecx, dword ptr [ebp - local_4]           # 004acd3d
    mov edx, dword ptr [ecx + field_c]           # 004acd40
    sub edx, dword ptr [ebp - local_8]           # 004acd43
    mov eax, dword ptr [ebp - local_4]           # 004acd46
    mov dword ptr [eax + field_c], edx           # 004acd49
L_004acd4c:
    # block 0x004acd4c: entered by jmp at 0x004acd0f; jle at 0x004acd1d, 4 instruction(s), ends with jge to 0x004acd85 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004acd4c
    mov edx, dword ptr [ecx]                     # 004acd4f
    cmp edx, dword ptr [0x583196]                # 004acd51
    jge.d8 L_004acd85                            # 004acd57
    # block 0x004acd59: entered by fall-through of jge at 0x004acd57, 15 instruction(s), ends with forward jump to 0x004acdbe
    mov eax, dword ptr [ebp - local_4]           # 004acd59
    mov ecx, dword ptr [0x583196]                # 004acd5c
    sub ecx, dword ptr [eax]                     # 004acd62
    mov dword ptr [ebp - local_8], ecx           # 004acd64
    mov edx, dword ptr [ebp - local_4]           # 004acd67
    mov eax, dword ptr [edx]                     # 004acd6a
    add eax, dword ptr [ebp - local_8]           # 004acd6c
    mov ecx, dword ptr [ebp - local_4]           # 004acd6f
    mov dword ptr [ecx], eax                     # 004acd72
    mov edx, dword ptr [ebp - local_4]           # 004acd74
    mov eax, dword ptr [edx + field_8]           # 004acd77
    add eax, dword ptr [ebp - local_8]           # 004acd7a
    mov ecx, dword ptr [ebp - local_4]           # 004acd7d
    mov dword ptr [ecx + field_8], eax           # 004acd80
    jmp.d8 L_004acdbe                            # 004acd83
L_004acd85:
    # block 0x004acd85: entered by jge at 0x004acd57, 4 instruction(s), ends with jle to 0x004acdbe (forward)
    mov edx, dword ptr [ebp - local_4]           # 004acd85
    mov eax, dword ptr [edx + field_8]           # 004acd88
    cmp eax, dword ptr [0x58319e]                # 004acd8b
    jle.d8 L_004acdbe                            # 004acd91
    # block 0x004acd93: entered by fall-through of jle at 0x004acd91, 14 instruction(s), falls into the block at 0x004acdbe
    mov ecx, dword ptr [ebp - local_4]           # 004acd93
    mov edx, dword ptr [ecx + field_8]           # 004acd96
    sub edx, dword ptr [0x58319e]                # 004acd99
    mov dword ptr [ebp - local_8], edx           # 004acd9f
    mov eax, dword ptr [ebp - local_4]           # 004acda2
    mov ecx, dword ptr [eax]                     # 004acda5
    sub ecx, dword ptr [ebp - local_8]           # 004acda7
    mov edx, dword ptr [ebp - local_4]           # 004acdaa
    mov dword ptr [edx], ecx                     # 004acdad
    mov eax, dword ptr [ebp - local_4]           # 004acdaf
    mov ecx, dword ptr [eax + field_8]           # 004acdb2
    sub ecx, dword ptr [ebp - local_8]           # 004acdb5
    mov edx, dword ptr [ebp - local_4]           # 004acdb8
    mov dword ptr [edx + field_8], ecx           # 004acdbb
L_004acdbe:
    # block 0x004acdbe: entered by jmp at 0x004acd83; jle at 0x004acd91, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004acdbe
    pop ebp                                      # 004acdc0
    ret                                          # 004acdc1

