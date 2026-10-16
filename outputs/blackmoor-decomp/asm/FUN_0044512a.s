# FUN_0044512a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044512a
# extent:       0x0044512a-0x00445253 (297 code bytes)
# span:         0x0044512a-0x00445253 (code 297, tables 0, padding 0)
# sha256:       171912297d43e79143a33a4a528d48a31aa0f6df3f8620737ad2f6f7dedbe950
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044512a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       15 ebp-relative slot(s): local_4, local_9, local_a, local_c, local_10, local_14, local_18, local_1a, local_1c, local_1e, local_20, local_42 and 3 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cd50, FUN_0043f210, FUN_0041fd08
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 75 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_9, 0x9  # offset -0x9
.equ local_a, 0xa  # offset -0xa
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1c, 0x1c  # offset -0x1c
.equ local_1e, 0x1e  # offset -0x1e
.equ local_20, 0x20  # offset -0x20
.equ local_42, 0x42  # offset -0x42
.equ local_1d2, 0x1d2  # offset -0x1d2
.equ local_1d8, 0x1d8  # offset -0x1d8
.equ local_1dc, 0x1dc  # offset -0x1dc

# --- external targets -----------------------------------------------
.set FUN_0041fd08, .text + (0x0041fd08 - 0x401000)
.set FUN_0043f210, .text + (0x0043f210 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0044512a - 0x401000
.globl FUN_0044512a
FUN_0044512a:
    # block 0x0044512a: entry, 38 instruction(s), calls FUN_0050cd50, FUN_0043f210, ends with je to 0x004451c0 (forward)
    push ebp                                     # 0044512a
    {load} mov ebp, esp                          # 0044512b
    sub esp, 0x1dc                               # 0044512d
    push esi                                     # 00445133
    push edi                                     # 00445134
    call FUN_0050cd50                            # 00445135
    cdq                                          # 0044513a
    mov ecx, 0x3                                 # 0044513b
    idiv ecx                                     # 00445140
    mov word ptr [ebp - local_4], dx             # 00445142
    push 0x548178                                # 00445146
    push 0x63a81c                                # 0044514b
    lea edx, [ebp - local_1d2]                   # 00445150
    push edx                                     # 00445156
    call FUN_0043f210                            # 00445157
    add esp, 0xc                                 # 0044515c
    mov edi, 0x548180                            # 0044515f
    lea edx, [ebp - local_42]                    # 00445164
    or ecx, -0x1                                 # 00445167
    {load} xor eax, eax                          # 0044516a
    repne scasb al, byte ptr es:[edi]            # 0044516c
    not ecx                                      # 0044516e
    {load} sub edi, ecx                          # 00445170
    {load} mov esi, edi                          # 00445172
    {load} mov eax, ecx                          # 00445174
    {load} mov edi, edx                          # 00445176
    shr ecx, 0x2                                 # 00445178
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044517b
    {load} mov ecx, eax                          # 0044517d
    and ecx, 0x3                                 # 0044517f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00445182
    mov dword ptr [ebp - local_18], 0x0          # 00445184
    mov dword ptr [ebp - local_14], 0x0          # 0044518b
    mov dword ptr [ebp - local_10], 0x1          # 00445192
    movsx ecx, word ptr [ebp - local_4]          # 00445199
    mov dword ptr [ebp - local_1dc], ecx         # 0044519d
    cmp dword ptr [ebp - local_1dc], 0x0         # 004451a3
    je.d8 L_004451c0                             # 004451aa
    # block 0x004451ac: entered by fall-through of je at 0x004451aa, 2 instruction(s), ends with je to 0x004451ea (forward)
    cmp dword ptr [ebp - local_1dc], 0x1         # 004451ac
    je.d8 L_004451ea                             # 004451b3
    # block 0x004451b5: entered by fall-through of je at 0x004451b3, 2 instruction(s), ends with je to 0x00445214 (forward)
    cmp dword ptr [ebp - local_1dc], 0x2         # 004451b5
    je.d8 L_00445214                             # 004451bc
    # block 0x004451be: entered by fall-through of je at 0x004451bc, 1 instruction(s), ends with forward jump to 0x0044523c
    jmp.d8 L_0044523c                            # 004451be
L_004451c0:
    # block 0x004451c0: entered by je at 0x004451aa, 8 instruction(s), ends with forward jump to 0x0044523c
    mov word ptr [ebp - local_20], 0x442         # 004451c0
    mov word ptr [ebp - local_1e], 0x0           # 004451c6
    mov word ptr [ebp - local_1c], 0x0           # 004451cc
    mov word ptr [ebp - local_1a], 0x1           # 004451d2
    mov word ptr [ebp - local_c], 0xffff         # 004451d8
    mov byte ptr [ebp - local_a], 0x0            # 004451de
    mov word ptr [ebp - local_9], 0x2            # 004451e2
    jmp.d8 L_0044523c                            # 004451e8
L_004451ea:
    # block 0x004451ea: entered by je at 0x004451b3, 8 instruction(s), ends with forward jump to 0x0044523c
    mov word ptr [ebp - local_20], 0x443         # 004451ea
    mov word ptr [ebp - local_1e], 0x0           # 004451f0
    mov word ptr [ebp - local_1c], 0x0           # 004451f6
    mov word ptr [ebp - local_1a], 0x1           # 004451fc
    mov word ptr [ebp - local_c], 0xffff         # 00445202
    mov byte ptr [ebp - local_a], 0x0            # 00445208
    mov word ptr [ebp - local_9], 0x2            # 0044520c
    jmp.d8 L_0044523c                            # 00445212
L_00445214:
    # block 0x00445214: entered by je at 0x004451bc, 7 instruction(s), falls into the block at 0x0044523c
    mov word ptr [ebp - local_20], 0x444         # 00445214
    mov word ptr [ebp - local_1e], 0x0           # 0044521a
    mov word ptr [ebp - local_1c], 0x0           # 00445220
    mov word ptr [ebp - local_1a], 0x1           # 00445226
    mov word ptr [ebp - local_c], 0xffff         # 0044522c
    mov byte ptr [ebp - local_a], 0x0            # 00445232
    mov word ptr [ebp - local_9], 0x2            # 00445236
L_0044523c:
    # block 0x0044523c: entered by jmp at 0x004451be; jmp at 0x004451e8; jmp at 0x00445212, 9 instruction(s), calls FUN_0041fd08, ends with ret
    lea edx, [ebp - local_1d8]                   # 0044523c
    push edx                                     # 00445242
    mov ecx, 0x6177e8                            # 00445243
    call FUN_0041fd08                            # 00445248
    pop edi                                      # 0044524d
    pop esi                                      # 0044524e
    {load} mov esp, ebp                          # 0044524f
    pop ebp                                      # 00445251
    ret                                          # 00445252

