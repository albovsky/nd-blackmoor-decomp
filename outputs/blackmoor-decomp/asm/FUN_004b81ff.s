# FUN_004b81ff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b81ff
# extent:       0x004b81ff-0x004b82cd (206 code bytes)
# span:         0x004b81ff-0x004b82cd (code 206, tables 0, padding 0)
# sha256:       cc4313cc869bfafef7d9744a0c7a43cd22e0dd0c201c96b181f073f21871f3f5
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b81ff
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_14, field_55c, field_55e, field_562, field_566, field_56a; [edx + n] field_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_55c, 0x55c  # offset +0x55c
.equ field_55e, 0x55e  # offset +0x55e
.equ field_562, 0x562  # offset +0x562
.equ field_566, 0x566  # offset +0x566
.equ field_56a, 0x56a  # offset +0x56a

# --- external targets -----------------------------------------------

.org 0x004b81ff - 0x401000
.globl FUN_004b81ff
FUN_004b81ff:
    # block 0x004b81ff: entry, 7 instruction(s), ends with je to 0x004b82c5 (forward)
    push ebp                                     # 004b81ff
    {load} mov ebp, esp                          # 004b8200
    push ecx                                     # 004b8202
    mov dword ptr [ebp - local_4], ecx           # 004b8203
    mov eax, dword ptr [ebp - local_4]           # 004b8206
    cmp dword ptr [eax + field_14], 0x0          # 004b8209
    je.d32 L_004b82c5                            # 004b820d
    # block 0x004b8213: entered by fall-through of je at 0x004b820d, 5 instruction(s), ends with jl to 0x004b82c5 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004b8213
    mov edx, dword ptr [ebp - local_4]           # 004b8217
    mov eax, dword ptr [edx + field_8]           # 004b821a
    cmp ecx, dword ptr [eax + field_562]         # 004b821d
    jl.d32 L_004b82c5                            # 004b8223
    # block 0x004b8229: entered by fall-through of jl at 0x004b8223, 5 instruction(s), ends with jg to 0x004b82c5 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004b8229
    mov edx, dword ptr [ebp - local_4]           # 004b822d
    mov eax, dword ptr [edx + field_8]           # 004b8230
    cmp ecx, dword ptr [eax + field_56a]         # 004b8233
    jg.d32 L_004b82c5                            # 004b8239
    # block 0x004b823f: entered by fall-through of jg at 0x004b8239, 5 instruction(s), ends with jl to 0x004b82c5 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004b823f
    mov edx, dword ptr [ebp - local_4]           # 004b8243
    mov eax, dword ptr [edx + field_8]           # 004b8246
    cmp ecx, dword ptr [eax + field_55e]         # 004b8249
    jl.d8 L_004b82c5                             # 004b824f
    # block 0x004b8251: entered by fall-through of jl at 0x004b824f, 5 instruction(s), ends with jg to 0x004b82c5 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004b8251
    mov edx, dword ptr [ebp - local_4]           # 004b8255
    mov eax, dword ptr [edx + field_8]           # 004b8258
    cmp ecx, dword ptr [eax + field_566]         # 004b825b
    jg.d8 L_004b82c5                             # 004b8261
    # block 0x004b8263: entered by fall-through of jg at 0x004b8261, 17 instruction(s), ends with forward jump to 0x004b82c7
    mov ecx, dword ptr [0x5d0377]                # 004b8263
    mov dword ptr [0x5d162d], ecx                # 004b8269
    mov edx, dword ptr [ebp - local_4]           # 004b826f
    mov eax, dword ptr [edx + field_8]           # 004b8272
    movsx ecx, word ptr [eax + field_55c]        # 004b8275
    mov dword ptr [0x5b44f0], ecx                # 004b827c
    mov dword ptr [0x5b44f4], 0x1                # 004b8282
    mov edx, dword ptr [0x5b44f0]                # 004b828c
    shl edx, 0x5                                 # 004b8292
    mov eax, dword ptr [0x5b44f4]                # 004b8295
    shl eax, 0x4                                 # 004b829a
    lea ecx, [edx + eax + 0x5b160c]              # 004b829d
    mov dword ptr [0x5d1631], ecx                # 004b82a4
    mov dword ptr [0x5d1639], 0x1                # 004b82aa
    mov dword ptr [0x5c39e5], 0x27eb             # 004b82b4
    mov eax, 0x1                                 # 004b82be
    jmp.d8 L_004b82c7                            # 004b82c3
L_004b82c5:
    # block 0x004b82c5: entered by je at 0x004b820d; jl at 0x004b8223; jg at 0x004b8239; jl at 0x004b824f; jg at 0x004b8261, 1 instruction(s), falls into the block at 0x004b82c7
    {load} xor eax, eax                          # 004b82c5
L_004b82c7:
    # block 0x004b82c7: entered by jmp at 0x004b82c3, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004b82c7
    pop ebp                                      # 004b82c9
    ret 0x8                                      # 004b82ca

