# FUN_00484d87
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00484d87
# extent:       0x00484d87-0x00484f0d (390 code bytes)
# span:         0x00484d87-0x00484f0d (code 390, tables 0, padding 0)
# sha256:       cd2af4863633ab6d2638e2b3ee1332d9199e004cf9ae737fab7bb52df66ff661
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00484d87
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_aa0, field_aa4, field_aa8, field_aac, field_ab8, field_ac0, field_ac4, field_ac8, field_acc, field_bb9, field_bbd, field_bc5 and 1 more; [ecx + n] field_ab0, field_ab4, field_ab8, field_abc, field_ad0, field_ad4, field_ad8, field_adc, field_bb1, field_bb5; [edx + n] field_ab0, field_ab4, field_bb1, field_bb5, field_bc5
# callees:      calls FUN_00484caf, FUN_004841cb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 104 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_aa0, 0xaa0  # offset +0xaa0
.equ field_aa4, 0xaa4  # offset +0xaa4
.equ field_aa8, 0xaa8  # offset +0xaa8
.equ field_aac, 0xaac  # offset +0xaac
.equ field_ab0, 0xab0  # offset +0xab0
.equ field_ab4, 0xab4  # offset +0xab4
.equ field_ab8, 0xab8  # offset +0xab8
.equ field_abc, 0xabc  # offset +0xabc
.equ field_ac0, 0xac0  # offset +0xac0
.equ field_ac4, 0xac4  # offset +0xac4
.equ field_ac8, 0xac8  # offset +0xac8
.equ field_acc, 0xacc  # offset +0xacc
.equ field_ad0, 0xad0  # offset +0xad0
.equ field_ad4, 0xad4  # offset +0xad4
.equ field_ad8, 0xad8  # offset +0xad8
.equ field_adc, 0xadc  # offset +0xadc
.equ field_bb1, 0xbb1  # offset +0xbb1
.equ field_bb5, 0xbb5  # offset +0xbb5
.equ field_bb9, 0xbb9  # offset +0xbb9
.equ field_bbd, 0xbbd  # offset +0xbbd
.equ field_bc5, 0xbc5  # offset +0xbc5
.equ field_bc7, 0xbc7  # offset +0xbc7

# --- external targets -----------------------------------------------
.set FUN_004841cb, .text + (0x004841cb - 0x401000)
.set FUN_00484caf, .text + (0x00484caf - 0x401000)

.org 0x00484d87 - 0x401000
.globl FUN_00484d87
FUN_00484d87:
    # block 0x00484d87: entry, 104 instruction(s), calls FUN_00484caf, FUN_004841cb, ends with ret
    push ebp                                     # 00484d87
    {load} mov ebp, esp                          # 00484d88
    sub esp, 0xc                                 # 00484d8a
    mov dword ptr [ebp - local_c], ecx           # 00484d8d
    mov eax, dword ptr [ebp - local_c]           # 00484d90
    mov ecx, dword ptr [ebp - local_c]           # 00484d93
    mov eax, dword ptr [eax + field_bb9]         # 00484d96
    sub eax, dword ptr [ecx + field_bb1]         # 00484d9c
    cdq                                          # 00484da2
    {load} sub eax, edx                          # 00484da3
    sar eax                                      # 00484da5
    mov edx, dword ptr [ebp - local_c]           # 00484da7
    add eax, dword ptr [edx + field_bb1]         # 00484daa
    mov dword ptr [ebp - local_8], eax           # 00484db0
    mov eax, dword ptr [ebp - local_c]           # 00484db3
    mov ecx, dword ptr [ebp - local_c]           # 00484db6
    mov eax, dword ptr [eax + field_bbd]         # 00484db9
    sub eax, dword ptr [ecx + field_bb5]         # 00484dbf
    cdq                                          # 00484dc5
    {load} sub eax, edx                          # 00484dc6
    sar eax                                      # 00484dc8
    mov edx, dword ptr [ebp - local_c]           # 00484dca
    add eax, dword ptr [edx + field_bb5]         # 00484dcd
    mov dword ptr [ebp - local_4], eax           # 00484dd3
    mov eax, dword ptr [ebp - local_c]           # 00484dd6
    mov ecx, dword ptr [ebp - local_c]           # 00484dd9
    mov edx, dword ptr [ecx + field_ab4]         # 00484ddc
    mov dword ptr [eax + field_aa4], edx         # 00484de2
    mov eax, dword ptr [ebp - local_c]           # 00484de8
    mov ecx, dword ptr [ebp - local_c]           # 00484deb
    mov edx, dword ptr [ecx + field_abc]         # 00484dee
    mov dword ptr [eax + field_aac], edx         # 00484df4
    mov eax, dword ptr [ebp - local_c]           # 00484dfa
    mov ecx, dword ptr [ebp - local_c]           # 00484dfd
    mov edx, dword ptr [ecx + field_ab0]         # 00484e00
    mov dword ptr [eax + field_aa0], edx         # 00484e06
    mov eax, dword ptr [ebp - local_c]           # 00484e0c
    mov ecx, dword ptr [ebp - local_c]           # 00484e0f
    mov edx, dword ptr [ecx + field_ab8]         # 00484e12
    mov dword ptr [eax + field_aa8], edx         # 00484e18
    mov eax, dword ptr [ebp - local_c]           # 00484e1e
    mov ecx, dword ptr [ebp - local_c]           # 00484e21
    mov edx, dword ptr [ecx + field_ad4]         # 00484e24
    mov dword ptr [eax + field_ac4], edx         # 00484e2a
    mov eax, dword ptr [ebp - local_c]           # 00484e30
    mov ecx, dword ptr [ebp - local_c]           # 00484e33
    mov edx, dword ptr [ecx + field_adc]         # 00484e36
    mov dword ptr [eax + field_acc], edx         # 00484e3c
    mov eax, dword ptr [ebp - local_c]           # 00484e42
    mov ecx, dword ptr [ebp - local_c]           # 00484e45
    mov edx, dword ptr [ecx + field_ad0]         # 00484e48
    mov dword ptr [eax + field_ac0], edx         # 00484e4e
    mov eax, dword ptr [ebp - local_c]           # 00484e54
    mov ecx, dword ptr [ebp - local_c]           # 00484e57
    mov edx, dword ptr [ecx + field_ad8]         # 00484e5a
    mov dword ptr [eax + field_ac8], edx         # 00484e60
    mov eax, dword ptr [ebp - local_c]           # 00484e66
    movsx eax, word ptr [eax + field_bc7]        # 00484e69
    cdq                                          # 00484e70
    {load} sub eax, edx                          # 00484e71
    sar eax                                      # 00484e73
    mov ecx, dword ptr [ebp - local_4]           # 00484e75
    {load} sub ecx, eax                          # 00484e78
    mov edx, dword ptr [ebp - local_c]           # 00484e7a
    mov dword ptr [edx + field_ab4], ecx         # 00484e7d
    mov eax, dword ptr [ebp - local_c]           # 00484e83
    movsx eax, word ptr [eax + field_bc5]        # 00484e86
    cdq                                          # 00484e8d
    {load} sub eax, edx                          # 00484e8e
    sar eax                                      # 00484e90
    mov ecx, dword ptr [ebp - local_8]           # 00484e92
    {load} sub ecx, eax                          # 00484e95
    mov edx, dword ptr [ebp - local_c]           # 00484e97
    mov dword ptr [edx + field_ab0], ecx         # 00484e9a
    mov eax, dword ptr [ebp - local_c]           # 00484ea0
    movsx ecx, word ptr [eax + field_bc7]        # 00484ea3
    mov edx, dword ptr [ebp - local_c]           # 00484eaa
    mov eax, dword ptr [edx + field_ab4]         # 00484ead
    {load} add eax, ecx                          # 00484eb3
    mov ecx, dword ptr [ebp - local_c]           # 00484eb5
    mov dword ptr [ecx + field_abc], eax         # 00484eb8
    mov edx, dword ptr [ebp - local_c]           # 00484ebe
    movsx eax, word ptr [edx + field_bc5]        # 00484ec1
    mov ecx, dword ptr [ebp - local_c]           # 00484ec8
    mov edx, dword ptr [ecx + field_ab0]         # 00484ecb
    {load} add edx, eax                          # 00484ed1
    mov eax, dword ptr [ebp - local_c]           # 00484ed3
    mov dword ptr [eax + field_ab8], edx         # 00484ed6
    mov ecx, dword ptr [ebp - local_c]           # 00484edc
    add ecx, 0xab0                               # 00484edf
    push ecx                                     # 00484ee5
    mov ecx, dword ptr [ebp - local_c]           # 00484ee6
    call FUN_00484caf                            # 00484ee9
    mov edx, dword ptr [ebp - local_c]           # 00484eee
    add edx, 0xad0                               # 00484ef1
    push edx                                     # 00484ef7
    mov eax, dword ptr [ebp - local_c]           # 00484ef8
    add eax, 0xab0                               # 00484efb
    push eax                                     # 00484f00
    mov ecx, dword ptr [ebp - local_c]           # 00484f01
    call FUN_004841cb                            # 00484f04
    {load} mov esp, ebp                          # 00484f09
    pop ebp                                      # 00484f0b
    ret                                          # 00484f0c

