# FUN_0044f68b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044f68b
# extent:       0x0044f68b-0x0044f996 (779 code bytes)
# span:         0x0044f68b-0x0044f996 (code 779, tables 0, padding 0)
# sha256:       39bd9d54bae28ce23a7af229501019745fcb291fec2d26d37b61365999c22bc3
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044f68b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_6, field_8, field_c, field_14, field_20, field_8c, field_94, field_ac, field_b4, field_c4, field_184 and 4 more; [ecx + n] field_4, field_8, field_c, field_18, field_24, field_90, field_98, field_a4, field_2a4, field_4dc, field_4e4, field_4fc and 4 more; [edx + n] field_4, field_8, field_c, field_1c, field_28, field_9c, field_a0, field_a8, field_c0, field_2a0, field_414, field_4f4 and 3 more
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 174 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_8c, 0x8c  # offset +0x8c
.equ field_90, 0x90  # offset +0x90
.equ field_94, 0x94  # offset +0x94
.equ field_98, 0x98  # offset +0x98
.equ field_9c, 0x9c  # offset +0x9c
.equ field_a0, 0xa0  # offset +0xa0
.equ field_a4, 0xa4  # offset +0xa4
.equ field_a8, 0xa8  # offset +0xa8
.equ field_ac, 0xac  # offset +0xac
.equ field_b4, 0xb4  # offset +0xb4
.equ field_c0, 0xc0  # offset +0xc0
.equ field_c4, 0xc4  # offset +0xc4
.equ field_184, 0x184  # offset +0x184
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_2a4, 0x2a4  # offset +0x2a4
.equ field_414, 0x414  # offset +0x414
.equ field_4dc, 0x4dc  # offset +0x4dc
.equ field_4e4, 0x4e4  # offset +0x4e4
.equ field_4e8, 0x4e8  # offset +0x4e8
.equ field_4ec, 0x4ec  # offset +0x4ec
.equ field_4f4, 0x4f4  # offset +0x4f4
.equ field_4f8, 0x4f8  # offset +0x4f8
.equ field_4fc, 0x4fc  # offset +0x4fc
.equ field_500, 0x500  # offset +0x500
.equ field_504, 0x504  # offset +0x504
.equ field_508, 0x508  # offset +0x508
.equ field_50c, 0x50c  # offset +0x50c
.equ field_51c, 0x51c  # offset +0x51c
.equ field_520, 0x520  # offset +0x520
.equ field_548, 0x548  # offset +0x548
.equ field_6af, 0x6af  # offset +0x6af

# --- external targets -----------------------------------------------

.org 0x0044f68b - 0x401000
.globl FUN_0044f68b
FUN_0044f68b:
    # block 0x0044f68b: entry, 174 instruction(s), ends with ret
    push ebp                                     # 0044f68b
    {load} mov ebp, esp                          # 0044f68c
    push ecx                                     # 0044f68e
    push edi                                     # 0044f68f
    mov dword ptr [ebp - local_4], ecx           # 0044f690
    mov eax, dword ptr [ebp - local_4]           # 0044f693
    mov word ptr [eax + field_6], 0xffff         # 0044f696
    mov ecx, dword ptr [ebp - local_4]           # 0044f69c
    mov word ptr [ecx + field_4], 0xffff         # 0044f69f
    mov edx, dword ptr [ebp - local_4]           # 0044f6a5
    mov dword ptr [edx + field_8], 0x0           # 0044f6a8
    mov eax, dword ptr [ebp - local_4]           # 0044f6af
    mov dword ptr [eax + field_14], 0x0          # 0044f6b2
    mov ecx, dword ptr [ebp - local_4]           # 0044f6b9
    mov dword ptr [ecx + field_18], 0x0          # 0044f6bc
    mov edx, dword ptr [ebp - local_4]           # 0044f6c3
    mov dword ptr [edx + field_1c], 0x0          # 0044f6c6
    mov eax, dword ptr [ebp - local_4]           # 0044f6cd
    mov dword ptr [eax + field_20], 0x0          # 0044f6d0
    mov ecx, dword ptr [ebp - local_4]           # 0044f6d7
    mov dword ptr [ecx + field_24], 0x0          # 0044f6da
    mov edx, dword ptr [ebp - local_4]           # 0044f6e1
    mov dword ptr [edx + field_28], 0x0          # 0044f6e4
    mov eax, dword ptr [ebp - local_4]           # 0044f6eb
    mov dword ptr [eax + field_8c], 0x0          # 0044f6ee
    mov ecx, dword ptr [ebp - local_4]           # 0044f6f8
    mov dword ptr [ecx + field_90], 0x0          # 0044f6fb
    mov edx, dword ptr [ebp - local_4]           # 0044f705
    mov dword ptr [edx + field_c0], 0x0          # 0044f708
    mov eax, dword ptr [ebp - local_4]           # 0044f712
    mov dword ptr [eax + field_c4], 0x0          # 0044f715
    mov ecx, dword ptr [ebp - local_4]           # 0044f71f
    mov dword ptr [ecx + field_548], 0x0         # 0044f722
    mov edx, dword ptr [ebp - local_4]           # 0044f72c
    mov dword ptr [edx + field_a0], 0x0          # 0044f72f
    mov eax, dword ptr [ebp - local_4]           # 0044f739
    mov dword ptr [eax + field_94], 0x0          # 0044f73c
    mov ecx, dword ptr [ebp - local_4]           # 0044f746
    mov dword ptr [ecx + field_98], 0x0          # 0044f749
    mov edx, dword ptr [ebp - local_4]           # 0044f753
    mov dword ptr [edx + field_9c], 0x0          # 0044f756
    mov eax, dword ptr [ebp - local_4]           # 0044f760
    mov dword ptr [eax + field_4e8], 0x0         # 0044f763
    mov ecx, dword ptr [ebp - local_4]           # 0044f76d
    mov dword ptr [ecx + field_4e4], 0x0         # 0044f770
    mov edx, dword ptr [ebp - local_4]           # 0044f77a
    mov dword ptr [edx + field_4f4], 0x0         # 0044f77d
    mov eax, dword ptr [ebp - local_4]           # 0044f787
    mov dword ptr [eax + field_4f8], 0x0         # 0044f78a
    mov ecx, dword ptr [ebp - local_4]           # 0044f794
    mov dword ptr [ecx + field_4fc], 0x0         # 0044f797
    mov edx, dword ptr [ebp - local_4]           # 0044f7a1
    mov dword ptr [edx + field_500], 0x0         # 0044f7a4
    mov eax, dword ptr [ebp - local_4]           # 0044f7ae
    mov dword ptr [eax + field_504], 0x0         # 0044f7b1
    mov ecx, dword ptr [ebp - local_4]           # 0044f7bb
    mov dword ptr [ecx + field_508], 0x0         # 0044f7be
    mov edx, dword ptr [ebp - local_4]           # 0044f7c8
    mov dword ptr [edx + field_50c], 0x0         # 0044f7cb
    mov eax, dword ptr [ebp - local_4]           # 0044f7d5
    mov dword ptr [eax + field_4ec], 0x0         # 0044f7d8
    mov ecx, dword ptr [ebp - local_4]           # 0044f7e2
    mov dword ptr [ecx + field_51c], 0x0         # 0044f7e5
    mov edx, dword ptr [ebp - local_4]           # 0044f7ef
    mov dword ptr [edx + field_2a0], 0x0         # 0044f7f2
    mov eax, dword ptr [ebp - local_4]           # 0044f7fc
    mov dword ptr [eax + field_ac], 0x0          # 0044f7ff
    mov ecx, dword ptr [ebp - local_4]           # 0044f809
    mov dword ptr [ecx + field_a4], 0x0          # 0044f80c
    mov edx, dword ptr [ebp - local_4]           # 0044f816
    mov dword ptr [edx + field_a8], 0x0          # 0044f819
    mov eax, dword ptr [ebp - local_4]           # 0044f823
    mov dword ptr [eax + field_c], 0x0           # 0044f826
    mov ecx, dword ptr [ebp - local_4]           # 0044f82d
    mov dword ptr [ecx + field_2a4], 0x0         # 0044f830
    mov edx, dword ptr [ebp - local_4]           # 0044f83a
    mov dword ptr [edx + field_6af], 0x0         # 0044f83d
    mov eax, dword ptr [ebp - local_4]           # 0044f847
    mov dword ptr [eax + field_b4], 0x0          # 0044f84a
    mov ecx, dword ptr [ebp - local_4]           # 0044f854
    mov dword ptr [ecx + field_520], 0x0         # 0044f857
    mov ecx, 0x27                                # 0044f861
    {load} xor eax, eax                          # 0044f866
    mov edi, dword ptr [ebp - local_4]           # 0044f868
    add edi, 0xe8                                # 0044f86b
    rep stosd dword ptr es:[edi], eax            # 0044f871
    {load} xor edx, edx                          # 0044f873
    mov eax, dword ptr [ebp - local_4]           # 0044f875
    add eax, 0x2c                                # 0044f878
    mov dword ptr [eax], edx                     # 0044f87b
    mov dword ptr [eax + field_4], edx           # 0044f87d
    mov dword ptr [eax + field_8], edx           # 0044f880
    mov dword ptr [eax + field_c], edx           # 0044f883
    {load} xor ecx, ecx                          # 0044f886
    mov edx, dword ptr [ebp - local_4]           # 0044f888
    add edx, 0xc8                                # 0044f88b
    mov dword ptr [edx], ecx                     # 0044f891
    mov dword ptr [edx + field_4], ecx           # 0044f893
    mov dword ptr [edx + field_8], ecx           # 0044f896
    mov dword ptr [edx + field_c], ecx           # 0044f899
    {load} xor eax, eax                          # 0044f89c
    mov ecx, dword ptr [ebp - local_4]           # 0044f89e
    add ecx, 0xd8                                # 0044f8a1
    mov dword ptr [ecx], eax                     # 0044f8a7
    mov dword ptr [ecx + field_4], eax           # 0044f8a9
    mov dword ptr [ecx + field_8], eax           # 0044f8ac
    mov dword ptr [ecx + field_c], eax           # 0044f8af
    {load} xor edx, edx                          # 0044f8b2
    mov eax, dword ptr [ebp - local_4]           # 0044f8b4
    add eax, 0x3c                                # 0044f8b7
    mov dword ptr [eax], edx                     # 0044f8ba
    mov dword ptr [eax + field_4], edx           # 0044f8bc
    mov dword ptr [eax + field_8], edx           # 0044f8bf
    mov dword ptr [eax + field_c], edx           # 0044f8c2
    {load} xor ecx, ecx                          # 0044f8c5
    mov edx, dword ptr [ebp - local_4]           # 0044f8c7
    add edx, 0x34c                               # 0044f8ca
    mov dword ptr [edx], ecx                     # 0044f8d0
    mov dword ptr [edx + field_4], ecx           # 0044f8d2
    mov dword ptr [edx + field_8], ecx           # 0044f8d5
    mov dword ptr [edx + field_c], ecx           # 0044f8d8
    {load} xor eax, eax                          # 0044f8db
    mov ecx, dword ptr [ebp - local_4]           # 0044f8dd
    add ecx, 0x4c                                # 0044f8e0
    mov dword ptr [ecx], eax                     # 0044f8e3
    mov dword ptr [ecx + field_4], eax           # 0044f8e5
    mov dword ptr [ecx + field_8], eax           # 0044f8e8
    mov dword ptr [ecx + field_c], eax           # 0044f8eb
    mov ecx, 0xc                                 # 0044f8ee
    {load} xor eax, eax                          # 0044f8f3
    mov edi, dword ptr [ebp - local_4]           # 0044f8f5
    add edi, 0x645                               # 0044f8f8
    rep stosd dword ptr es:[edi], eax            # 0044f8fe
    stosb byte ptr es:[edi], al                  # 0044f900
    mov ecx, 0x13                                # 0044f901
    {load} xor eax, eax                          # 0044f906
    mov edi, dword ptr [ebp - local_4]           # 0044f908
    add edi, 0x254                               # 0044f90b
    rep stosd dword ptr es:[edi], eax            # 0044f911
    mov ecx, 0x2a                                # 0044f913
    {load} xor eax, eax                          # 0044f918
    mov edi, dword ptr [ebp - local_4]           # 0044f91a
    add edi, 0x2a4                               # 0044f91d
    rep stosd dword ptr es:[edi], eax            # 0044f923
    {load} xor edx, edx                          # 0044f925
    mov eax, dword ptr [ebp - local_4]           # 0044f927
    add eax, 0x6a7                               # 0044f92a
    mov dword ptr [eax], edx                     # 0044f92f
    mov dword ptr [eax + field_4], edx           # 0044f931
    mov ecx, 0x2e                                # 0044f934
    {load} xor eax, eax                          # 0044f939
    mov edi, dword ptr [ebp - local_4]           # 0044f93b
    add edi, 0x364                               # 0044f93e
    rep stosd dword ptr es:[edi], eax            # 0044f944
    mov ecx, 0x32                                # 0044f946
    {load} xor eax, eax                          # 0044f94b
    mov edi, dword ptr [ebp - local_4]           # 0044f94d
    add edi, 0x41c                               # 0044f950
    rep stosd dword ptr es:[edi], eax            # 0044f956
    mov ecx, dword ptr [ebp - local_4]           # 0044f958
    mov dword ptr [ecx + field_4dc], 0xffffffff  # 0044f95b
    mov edx, dword ptr [ebp - local_4]           # 0044f965
    mov dword ptr [edx + field_414], 0xffffffff  # 0044f968
    mov ecx, 0x34                                # 0044f972
    {load} xor eax, eax                          # 0044f977
    mov edi, dword ptr [ebp - local_4]           # 0044f979
    add edi, 0x184                               # 0044f97c
    rep stosd dword ptr es:[edi], eax            # 0044f982
    mov eax, dword ptr [ebp - local_4]           # 0044f984
    mov dword ptr [eax + field_184], 0xfffffffe  # 0044f987
    pop edi                                      # 0044f991
    {load} mov esp, ebp                          # 0044f992
    pop ebp                                      # 0044f994
    ret                                          # 0044f995

