# FUN_004a8007
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a8007
# extent:       0x004a8007-0x004a835c (853 code bytes)
# span:         0x004a8007-0x004a835c (code 853, tables 0, padding 0)
# sha256:       7458d1861c9a211060a1833a1a93f45bd97822437d3528df32e011596822f9bd
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a8007
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_e2e, field_e32, field_e36, field_e3a, field_e3e, field_e42, field_e46, field_e4a, field_e4e, field_e52, field_e76, field_e8c and 1 more; [ecx + n] field_e16, field_e1a, field_e1e, field_e22, field_e26, field_e2a, field_e2e, field_e32, field_e36, field_e3a, field_e3e, field_e42 and 5 more; [edx + n] field_e26, field_e2a, field_e2e, field_e32, field_e46, field_e4a, field_e4e, field_e52, field_e84, field_e88, field_13a4, field_13a6
# callees:      calls FUN_004a7f08
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 197 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_e16, 0xe16  # offset +0xe16
.equ field_e1a, 0xe1a  # offset +0xe1a
.equ field_e1e, 0xe1e  # offset +0xe1e
.equ field_e22, 0xe22  # offset +0xe22
.equ field_e26, 0xe26  # offset +0xe26
.equ field_e2a, 0xe2a  # offset +0xe2a
.equ field_e2e, 0xe2e  # offset +0xe2e
.equ field_e32, 0xe32  # offset +0xe32
.equ field_e36, 0xe36  # offset +0xe36
.equ field_e3a, 0xe3a  # offset +0xe3a
.equ field_e3e, 0xe3e  # offset +0xe3e
.equ field_e42, 0xe42  # offset +0xe42
.equ field_e46, 0xe46  # offset +0xe46
.equ field_e4a, 0xe4a  # offset +0xe4a
.equ field_e4e, 0xe4e  # offset +0xe4e
.equ field_e52, 0xe52  # offset +0xe52
.equ field_e76, 0xe76  # offset +0xe76
.equ field_e84, 0xe84  # offset +0xe84
.equ field_e88, 0xe88  # offset +0xe88
.equ field_e8c, 0xe8c  # offset +0xe8c
.equ field_e90, 0xe90  # offset +0xe90
.equ field_13a4, 0x13a4  # offset +0x13a4
.equ field_13a6, 0x13a6  # offset +0x13a6
.equ field_13a8, 0x13a8  # offset +0x13a8
.equ field_13aa, 0x13aa  # offset +0x13aa

# --- external targets -----------------------------------------------
.set FUN_004a7f08, .text + (0x004a7f08 - 0x401000)

.org 0x004a8007 - 0x401000
.globl FUN_004a8007
FUN_004a8007:
    # block 0x004a8007: entry, 27 instruction(s), ends with je to 0x004a81cf (forward)
    push ebp                                     # 004a8007
    {load} mov ebp, esp                          # 004a8008
    sub esp, 0xc                                 # 004a800a
    mov dword ptr [ebp - local_c], ecx           # 004a800d
    mov eax, dword ptr [ebp - local_c]           # 004a8010
    mov ecx, dword ptr [ebp - local_c]           # 004a8013
    mov eax, dword ptr [eax + field_e8c]         # 004a8016
    sub eax, dword ptr [ecx + field_e84]         # 004a801c
    cdq                                          # 004a8022
    {load} sub eax, edx                          # 004a8023
    sar eax                                      # 004a8025
    mov edx, dword ptr [ebp - local_c]           # 004a8027
    add eax, dword ptr [edx + field_e84]         # 004a802a
    mov dword ptr [ebp - local_8], eax           # 004a8030
    mov eax, dword ptr [ebp - local_c]           # 004a8033
    mov ecx, dword ptr [ebp - local_c]           # 004a8036
    mov eax, dword ptr [eax + field_e90]         # 004a8039
    sub eax, dword ptr [ecx + field_e88]         # 004a803f
    cdq                                          # 004a8045
    {load} sub eax, edx                          # 004a8046
    sar eax                                      # 004a8048
    mov edx, dword ptr [ebp - local_c]           # 004a804a
    add eax, dword ptr [edx + field_e88]         # 004a804d
    mov dword ptr [ebp - local_4], eax           # 004a8053
    mov eax, dword ptr [ebp - local_c]           # 004a8056
    cmp dword ptr [eax + field_e76], 0x0         # 004a8059
    je.d32 L_004a81cf                            # 004a8060
    # block 0x004a8066: entered by fall-through of je at 0x004a8060, 81 instruction(s), calls FUN_004a7f08, ends with forward jump to 0x004a8358
    mov ecx, dword ptr [ebp - local_c]           # 004a8066
    mov edx, dword ptr [ebp - local_c]           # 004a8069
    mov eax, dword ptr [edx + field_e2a]         # 004a806c
    mov dword ptr [ecx + field_e1a], eax         # 004a8072
    mov ecx, dword ptr [ebp - local_c]           # 004a8078
    mov edx, dword ptr [ebp - local_c]           # 004a807b
    mov eax, dword ptr [edx + field_e32]         # 004a807e
    mov dword ptr [ecx + field_e22], eax         # 004a8084
    mov ecx, dword ptr [ebp - local_c]           # 004a808a
    mov edx, dword ptr [ebp - local_c]           # 004a808d
    mov eax, dword ptr [edx + field_e26]         # 004a8090
    mov dword ptr [ecx + field_e16], eax         # 004a8096
    mov ecx, dword ptr [ebp - local_c]           # 004a809c
    mov edx, dword ptr [ebp - local_c]           # 004a809f
    mov eax, dword ptr [edx + field_e2e]         # 004a80a2
    mov dword ptr [ecx + field_e1e], eax         # 004a80a8
    mov ecx, dword ptr [ebp - local_c]           # 004a80ae
    mov edx, dword ptr [ebp - local_c]           # 004a80b1
    mov eax, dword ptr [edx + field_e4a]         # 004a80b4
    mov dword ptr [ecx + field_e3a], eax         # 004a80ba
    mov ecx, dword ptr [ebp - local_c]           # 004a80c0
    mov edx, dword ptr [ebp - local_c]           # 004a80c3
    mov eax, dword ptr [edx + field_e52]         # 004a80c6
    mov dword ptr [ecx + field_e42], eax         # 004a80cc
    mov ecx, dword ptr [ebp - local_c]           # 004a80d2
    mov edx, dword ptr [ebp - local_c]           # 004a80d5
    mov eax, dword ptr [edx + field_e46]         # 004a80d8
    mov dword ptr [ecx + field_e36], eax         # 004a80de
    mov ecx, dword ptr [ebp - local_c]           # 004a80e4
    mov edx, dword ptr [ebp - local_c]           # 004a80e7
    mov eax, dword ptr [edx + field_e4e]         # 004a80ea
    mov dword ptr [ecx + field_e3e], eax         # 004a80f0
    mov ecx, dword ptr [ebp - local_c]           # 004a80f6
    movsx edx, word ptr [ecx + field_13aa]       # 004a80f9
    mov eax, dword ptr [ebp - local_4]           # 004a8100
    {load} sub eax, edx                          # 004a8103
    mov ecx, dword ptr [ebp - local_c]           # 004a8105
    mov dword ptr [ecx + field_e2a], eax         # 004a8108
    mov edx, dword ptr [ebp - local_c]           # 004a810e
    movsx eax, word ptr [edx + field_13a6]       # 004a8111
    mov ecx, dword ptr [ebp - local_c]           # 004a8118
    mov edx, dword ptr [ecx + field_e2a]         # 004a811b
    {load} add edx, eax                          # 004a8121
    mov eax, dword ptr [ebp - local_c]           # 004a8123
    mov dword ptr [eax + field_e32], edx         # 004a8126
    mov ecx, dword ptr [ebp - local_c]           # 004a812c
    movsx edx, word ptr [ecx + field_13a8]       # 004a812f
    mov eax, dword ptr [ebp - local_8]           # 004a8136
    {load} sub eax, edx                          # 004a8139
    mov ecx, dword ptr [ebp - local_c]           # 004a813b
    mov dword ptr [ecx + field_e26], eax         # 004a813e
    mov edx, dword ptr [ebp - local_c]           # 004a8144
    movsx eax, word ptr [edx + field_13a4]       # 004a8147
    mov ecx, dword ptr [ebp - local_c]           # 004a814e
    mov edx, dword ptr [ecx + field_e26]         # 004a8151
    {load} add edx, eax                          # 004a8157
    mov eax, dword ptr [ebp - local_c]           # 004a8159
    mov dword ptr [eax + field_e2e], edx         # 004a815c
    mov ecx, dword ptr [ebp - local_c]           # 004a8162
    call FUN_004a7f08                            # 004a8165
    mov ecx, dword ptr [ebp - local_c]           # 004a816a
    mov edx, dword ptr [ecx + field_e2a]         # 004a816d
    add edx, dword ptr [0x58318a]                # 004a8173
    mov eax, dword ptr [ebp - local_c]           # 004a8179
    mov dword ptr [eax + field_e4a], edx         # 004a817c
    mov ecx, dword ptr [ebp - local_c]           # 004a8182
    mov edx, dword ptr [ecx + field_e32]         # 004a8185
    add edx, dword ptr [0x58318a]                # 004a818b
    mov eax, dword ptr [ebp - local_c]           # 004a8191
    mov dword ptr [eax + field_e52], edx         # 004a8194
    mov ecx, dword ptr [ebp - local_c]           # 004a819a
    mov edx, dword ptr [ecx + field_e26]         # 004a819d
    add edx, dword ptr [0x583186]                # 004a81a3
    mov eax, dword ptr [ebp - local_c]           # 004a81a9
    mov dword ptr [eax + field_e46], edx         # 004a81ac
    mov ecx, dword ptr [ebp - local_c]           # 004a81b2
    mov edx, dword ptr [ecx + field_e2e]         # 004a81b5
    add edx, dword ptr [0x583186]                # 004a81bb
    mov eax, dword ptr [ebp - local_c]           # 004a81c1
    mov dword ptr [eax + field_e4e], edx         # 004a81c4
    jmp.d32 L_004a8358                           # 004a81ca
L_004a81cf:
    # block 0x004a81cf: entered by je at 0x004a8060, 86 instruction(s), calls FUN_004a7f08, falls into the block at 0x004a8358
    mov ecx, dword ptr [ebp - local_c]           # 004a81cf
    movsx edx, word ptr [ecx + field_13aa]       # 004a81d2
    mov eax, dword ptr [ebp - local_4]           # 004a81d9
    {load} sub eax, edx                          # 004a81dc
    mov ecx, dword ptr [ebp - local_c]           # 004a81de
    mov dword ptr [ecx + field_e2a], eax         # 004a81e1
    mov edx, dword ptr [ebp - local_c]           # 004a81e7
    movsx eax, word ptr [edx + field_13a6]       # 004a81ea
    mov ecx, dword ptr [ebp - local_c]           # 004a81f1
    mov edx, dword ptr [ecx + field_e2a]         # 004a81f4
    {load} add edx, eax                          # 004a81fa
    mov eax, dword ptr [ebp - local_c]           # 004a81fc
    mov dword ptr [eax + field_e32], edx         # 004a81ff
    mov ecx, dword ptr [ebp - local_c]           # 004a8205
    movsx edx, word ptr [ecx + field_13a8]       # 004a8208
    mov eax, dword ptr [ebp - local_8]           # 004a820f
    {load} sub eax, edx                          # 004a8212
    mov ecx, dword ptr [ebp - local_c]           # 004a8214
    mov dword ptr [ecx + field_e26], eax         # 004a8217
    mov edx, dword ptr [ebp - local_c]           # 004a821d
    movsx eax, word ptr [edx + field_13a4]       # 004a8220
    mov ecx, dword ptr [ebp - local_c]           # 004a8227
    mov edx, dword ptr [ecx + field_e26]         # 004a822a
    {load} add edx, eax                          # 004a8230
    mov eax, dword ptr [ebp - local_c]           # 004a8232
    mov dword ptr [eax + field_e2e], edx         # 004a8235
    mov ecx, dword ptr [ebp - local_c]           # 004a823b
    call FUN_004a7f08                            # 004a823e
    mov ecx, dword ptr [ebp - local_c]           # 004a8243
    mov edx, dword ptr [ebp - local_c]           # 004a8246
    mov eax, dword ptr [edx + field_e2a]         # 004a8249
    mov dword ptr [ecx + field_e1a], eax         # 004a824f
    mov ecx, dword ptr [ebp - local_c]           # 004a8255
    mov edx, dword ptr [ebp - local_c]           # 004a8258
    mov eax, dword ptr [edx + field_e32]         # 004a825b
    mov dword ptr [ecx + field_e22], eax         # 004a8261
    mov ecx, dword ptr [ebp - local_c]           # 004a8267
    mov edx, dword ptr [ebp - local_c]           # 004a826a
    mov eax, dword ptr [edx + field_e26]         # 004a826d
    mov dword ptr [ecx + field_e16], eax         # 004a8273
    mov ecx, dword ptr [ebp - local_c]           # 004a8279
    mov edx, dword ptr [ebp - local_c]           # 004a827c
    mov eax, dword ptr [edx + field_e2e]         # 004a827f
    mov dword ptr [ecx + field_e1e], eax         # 004a8285
    mov ecx, dword ptr [ebp - local_c]           # 004a828b
    mov edx, dword ptr [ecx + field_e2a]         # 004a828e
    add edx, dword ptr [0x58318a]                # 004a8294
    mov eax, dword ptr [ebp - local_c]           # 004a829a
    mov dword ptr [eax + field_e4a], edx         # 004a829d
    mov ecx, dword ptr [ebp - local_c]           # 004a82a3
    mov edx, dword ptr [ecx + field_e32]         # 004a82a6
    add edx, dword ptr [0x58318a]                # 004a82ac
    mov eax, dword ptr [ebp - local_c]           # 004a82b2
    mov dword ptr [eax + field_e52], edx         # 004a82b5
    mov ecx, dword ptr [ebp - local_c]           # 004a82bb
    mov edx, dword ptr [ecx + field_e26]         # 004a82be
    add edx, dword ptr [0x583186]                # 004a82c4
    mov eax, dword ptr [ebp - local_c]           # 004a82ca
    mov dword ptr [eax + field_e46], edx         # 004a82cd
    mov ecx, dword ptr [ebp - local_c]           # 004a82d3
    mov edx, dword ptr [ecx + field_e2e]         # 004a82d6
    add edx, dword ptr [0x583186]                # 004a82dc
    mov eax, dword ptr [ebp - local_c]           # 004a82e2
    mov dword ptr [eax + field_e4e], edx         # 004a82e5
    mov ecx, dword ptr [ebp - local_c]           # 004a82eb
    mov edx, dword ptr [ecx + field_e1a]         # 004a82ee
    add edx, dword ptr [0x58318a]                # 004a82f4
    mov eax, dword ptr [ebp - local_c]           # 004a82fa
    mov dword ptr [eax + field_e3a], edx         # 004a82fd
    mov ecx, dword ptr [ebp - local_c]           # 004a8303
    mov edx, dword ptr [ecx + field_e22]         # 004a8306
    add edx, dword ptr [0x58318a]                # 004a830c
    mov eax, dword ptr [ebp - local_c]           # 004a8312
    mov dword ptr [eax + field_e42], edx         # 004a8315
    mov ecx, dword ptr [ebp - local_c]           # 004a831b
    mov edx, dword ptr [ecx + field_e16]         # 004a831e
    add edx, dword ptr [0x583186]                # 004a8324
    mov eax, dword ptr [ebp - local_c]           # 004a832a
    mov dword ptr [eax + field_e36], edx         # 004a832d
    mov ecx, dword ptr [ebp - local_c]           # 004a8333
    mov edx, dword ptr [ecx + field_e1e]         # 004a8336
    add edx, dword ptr [0x583186]                # 004a833c
    mov eax, dword ptr [ebp - local_c]           # 004a8342
    mov dword ptr [eax + field_e3e], edx         # 004a8345
    mov ecx, dword ptr [ebp - local_c]           # 004a834b
    mov dword ptr [ecx + field_e76], 0x1         # 004a834e
L_004a8358:
    # block 0x004a8358: entered by jmp at 0x004a81ca, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a8358
    pop ebp                                      # 004a835a
    ret                                          # 004a835b

