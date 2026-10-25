# FUN_004ec087
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ec087
# extent:       0x004ec087-0x004ec1fb (372 code bytes)
# span:         0x004ec087-0x004ec1fb (code 372, tables 0, padding 0)
# sha256:       e7a17b25edd4ed15cf804d58f35ab9b129da0ce57f81b788457afac667cbfd8b
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ec087
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_985, field_ca0, field_ca8, field_fc6, field_28f0; [ecx + n] field_ca0, field_fc6, field_28f0; [edx + n] field_691, field_fc6, field_28da
# callees:      calls FUN_004ee517, FUN_004e26fc, FUN_004ec1fb
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 85 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_691, 0x691  # offset +0x691
.equ field_985, 0x985  # offset +0x985
.equ field_ca0, 0xca0  # offset +0xca0
.equ field_ca8, 0xca8  # offset +0xca8
.equ field_fc6, 0xfc6  # offset +0xfc6
.equ field_28da, 0x28da  # offset +0x28da
.equ field_28f0, 0x28f0  # offset +0x28f0

# --- external targets -----------------------------------------------
.set FUN_004e26fc, .text + (0x004e26fc - 0x401000)
.set FUN_004ec1fb, .text + (0x004ec1fb - 0x401000)
.set FUN_004ee517, .text + (0x004ee517 - 0x401000)

.org 0x004ec087 - 0x401000
.globl FUN_004ec087
FUN_004ec087:
    # block 0x004ec087: entry, 7 instruction(s), ends with je to 0x004ec0ad (forward)
    push ebp                                     # 004ec087
    {load} mov ebp, esp                          # 004ec088
    sub esp, 0x8                                 # 004ec08a
    mov dword ptr [ebp - local_8], ecx           # 004ec08d
    mov eax, dword ptr [ebp - local_8]           # 004ec090
    cmp dword ptr [eax + field_ca0], 0x2         # 004ec093
    je.d8 L_004ec0ad                             # 004ec09a
    # block 0x004ec09c: entered by fall-through of je at 0x004ec09a, 3 instruction(s), ends with je to 0x004ec0ad (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ec09c
    cmp dword ptr [ecx + field_ca0], 0x3         # 004ec09f
    je.d8 L_004ec0ad                             # 004ec0a6
    # block 0x004ec0a8: entered by fall-through of je at 0x004ec0a6, 1 instruction(s), ends with forward jump to 0x004ec1f7
    jmp.d32 L_004ec1f7                           # 004ec0a8
L_004ec0ad:
    # block 0x004ec0ad: entered by je at 0x004ec09a; je at 0x004ec0a6, 4 instruction(s), calls FUN_004ee517, ends with je to 0x004ec0be (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ec0ad
    call FUN_004ee517                            # 004ec0b0
    test eax, eax                                # 004ec0b5
    je.d8 L_004ec0be                             # 004ec0b7
    # block 0x004ec0b9: entered by fall-through of je at 0x004ec0b7, 1 instruction(s), ends with forward jump to 0x004ec1f7
    jmp.d32 L_004ec1f7                           # 004ec0b9
L_004ec0be:
    # block 0x004ec0be: entered by je at 0x004ec0b7, 4 instruction(s), ends with forward jump to 0x004ec0e8
    mov word ptr [ebp - local_4], 0x0            # 004ec0be
    mov edx, dword ptr [ebp - local_8]           # 004ec0c4
    mov dword ptr [edx + field_fc6], 0x0         # 004ec0c7
    jmp.d8 L_004ec0e8                            # 004ec0d1
L_004ec0d3:
    # block 0x004ec0d3: entered by jmp at 0x004ec137, 5 instruction(s), falls into the block at 0x004ec0e8
    mov eax, dword ptr [ebp - local_8]           # 004ec0d3
    mov ecx, dword ptr [eax + field_fc6]         # 004ec0d6
    add ecx, 0x1                                 # 004ec0dc
    mov edx, dword ptr [ebp - local_8]           # 004ec0df
    mov dword ptr [edx + field_fc6], ecx         # 004ec0e2
L_004ec0e8:
    # block 0x004ec0e8: entered by jmp at 0x004ec0d1, 3 instruction(s), ends with jge to 0x004ec139 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ec0e8
    cmp dword ptr [eax + field_fc6], 0x2         # 004ec0eb
    jge.d8 L_004ec139                            # 004ec0f2
    # block 0x004ec0f4: entered by fall-through of jge at 0x004ec0f2, 6 instruction(s), ends with je to 0x004ec137 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ec0f4
    mov edx, dword ptr [ecx + field_fc6]         # 004ec0f7
    imul edx, edx, 0xf7                          # 004ec0fd
    mov eax, dword ptr [ebp - local_8]           # 004ec103
    cmp dword ptr [eax + edx + field_985], 0x0   # 004ec106
    je.d8 L_004ec137                             # 004ec10e
    # block 0x004ec110: entered by fall-through of je at 0x004ec10e, 8 instruction(s), calls FUN_004e26fc, ends with je to 0x004ec137 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ec110
    mov edx, dword ptr [ecx + field_fc6]         # 004ec113
    imul edx, edx, 0x18f                         # 004ec119
    mov eax, dword ptr [ebp - local_8]           # 004ec11f
    lea ecx, [eax + edx + field_ca8]             # 004ec122
    call FUN_004e26fc                            # 004ec129
    test eax, eax                                # 004ec12e
    je.d8 L_004ec137                             # 004ec130
    # block 0x004ec132: entered by fall-through of je at 0x004ec130, 1 instruction(s), ends with forward jump to 0x004ec1f7
    jmp.d32 L_004ec1f7                           # 004ec132
L_004ec137:
    # block 0x004ec137: entered by je at 0x004ec10e; je at 0x004ec130, 1 instruction(s), ends with backward jump to 0x004ec0d3
    jmp.d8 L_004ec0d3                            # 004ec137
L_004ec139:
    # block 0x004ec139: entered by jge at 0x004ec0f2, 2 instruction(s), ends with jne to 0x004ec1f7 (forward)
    cmp dword ptr [0x5c39e5], 0x27dc             # 004ec139
    jne.d32 L_004ec1f7                           # 004ec143
    # block 0x004ec149: entered by fall-through of jne at 0x004ec143, 9 instruction(s), ends with je to 0x004ec1a2 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004ec149
    imul ecx, ecx, 0x320                         # 004ec14d
    mov edx, dword ptr [ebp - local_8]           # 004ec153
    movsx eax, word ptr [edx + field_28da]       # 004ec156
    mov edx, dword ptr [ebp - local_8]           # 004ec15d
    sub eax, dword ptr [edx + field_691]         # 004ec160
    movsx eax, word ptr [ecx + 2*eax + 0x59fbdf] # 004ec166
    cmp eax, -0x1                                # 004ec16e
    je.d8 L_004ec1a2                             # 004ec171
    # block 0x004ec173: entered by fall-through of je at 0x004ec171, 9 instruction(s), ends with jne to 0x004ec1e1 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004ec173
    imul ecx, ecx, 0x320                         # 004ec177
    mov edx, dword ptr [ebp - local_8]           # 004ec17d
    movsx eax, word ptr [edx + field_28da]       # 004ec180
    mov edx, dword ptr [ebp - local_8]           # 004ec187
    sub eax, dword ptr [edx + field_691]         # 004ec18a
    movsx eax, word ptr [ecx + 2*eax + 0x59fbdf] # 004ec190
    cmp dword ptr [4*eax + 0x585801], 0x1        # 004ec198
    jne.d8 L_004ec1e1                            # 004ec1a0
L_004ec1a2:
    # block 0x004ec1a2: entered by je at 0x004ec171; fall-through of jne at 0x004ec1a0, 13 instruction(s), calls FUN_004ec1fb, ends with forward jump to 0x004ec1f7
    movsx ecx, word ptr [ebp - local_4]          # 004ec1a2
    imul ecx, ecx, 0x320                         # 004ec1a6
    mov edx, dword ptr [ebp - local_8]           # 004ec1ac
    movsx eax, word ptr [edx + field_28da]       # 004ec1af
    mov edx, dword ptr [ebp - local_8]           # 004ec1b6
    sub eax, dword ptr [edx + field_691]         # 004ec1b9
    mov word ptr [ecx + 2*eax + 0x59f279], 0x8   # 004ec1bf
    mov eax, dword ptr [ebp - local_8]           # 004ec1c9
    mov word ptr [eax + field_28f0], 0x0         # 004ec1cc
    push 0x1                                     # 004ec1d5
    mov ecx, dword ptr [ebp - local_8]           # 004ec1d7
    call FUN_004ec1fb                            # 004ec1da
    jmp.d8 L_004ec1f7                            # 004ec1df
L_004ec1e1:
    # block 0x004ec1e1: entered by jne at 0x004ec1a0, 5 instruction(s), calls FUN_004ec1fb, falls into the block at 0x004ec1f7
    mov ecx, dword ptr [ebp - local_8]           # 004ec1e1
    mov word ptr [ecx + field_28f0], 0x0         # 004ec1e4
    push 0x0                                     # 004ec1ed
    mov ecx, dword ptr [ebp - local_8]           # 004ec1ef
    call FUN_004ec1fb                            # 004ec1f2
L_004ec1f7:
    # block 0x004ec1f7: entered by jmp at 0x004ec0a8; jmp at 0x004ec0b9; jmp at 0x004ec132; jne at 0x004ec143; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ec1f7
    pop ebp                                      # 004ec1f9
    ret                                          # 004ec1fa

