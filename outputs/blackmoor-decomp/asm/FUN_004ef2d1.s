# FUN_004ef2d1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ef2d1
# extent:       0x004ef2d1-0x004ef3ed (284 code bytes)
# span:         0x004ef2d1-0x004ef3ed (code 284, tables 0, padding 0)
# sha256:       941031c719db562a36740d3ce064964213162878c0ad8a2fe80e58e31125d157
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ef2d1
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_10, field_c2, field_19a; [ecx + n] field_10, field_19a; [edx + n] field_10, field_ca, field_13e, field_142, field_146, field_14a
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 69 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_c2, 0xc2  # offset +0xc2
.equ field_ca, 0xca  # offset +0xca
.equ field_13e, 0x13e  # offset +0x13e
.equ field_142, 0x142  # offset +0x142
.equ field_146, 0x146  # offset +0x146
.equ field_14a, 0x14a  # offset +0x14a
.equ field_19a, 0x19a  # offset +0x19a

# --- external targets -----------------------------------------------

.org 0x004ef2d1 - 0x401000
.globl FUN_004ef2d1
FUN_004ef2d1:
    # block 0x004ef2d1: entry, 9 instruction(s), ends with je to 0x004ef304 (forward)
    push ebp                                     # 004ef2d1
    {load} mov ebp, esp                          # 004ef2d2
    push ecx                                     # 004ef2d4
    mov dword ptr [ebp - local_4], ecx           # 004ef2d5
    mov eax, dword ptr [ebp - local_4]           # 004ef2d8
    mov dword ptr [eax + field_19a], 0x0         # 004ef2db
    mov ecx, dword ptr [ebp - local_4]           # 004ef2e5
    cmp dword ptr [ecx + field_10], 0x0          # 004ef2e8
    je.d8 L_004ef304                             # 004ef2ec
    # block 0x004ef2ee: entered by fall-through of je at 0x004ef2ec, 3 instruction(s), ends with je to 0x004ef304 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ef2ee
    cmp dword ptr [edx + field_10], 0x1          # 004ef2f1
    je.d8 L_004ef304                             # 004ef2f5
    # block 0x004ef2f7: entered by fall-through of je at 0x004ef2f5, 3 instruction(s), ends with jne to 0x004ef3e5 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ef2f7
    cmp dword ptr [eax + field_10], 0x2          # 004ef2fa
    jne.d32 L_004ef3e5                           # 004ef2fe
L_004ef304:
    # block 0x004ef304: entered by je at 0x004ef2ec; je at 0x004ef2f5; fall-through of jne at 0x004ef2fe, 6 instruction(s), ends with jl to 0x004ef3db (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004ef304
    mov edx, dword ptr [ebp - local_4]           # 004ef308
    mov eax, dword ptr [edx + field_142]         # 004ef30b
    add eax, 0x5                                 # 004ef311
    {load} cmp ecx, eax                          # 004ef314
    jl.d32 L_004ef3db                            # 004ef316
    # block 0x004ef31c: entered by fall-through of jl at 0x004ef316, 6 instruction(s), ends with jg to 0x004ef3db (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004ef31c
    mov edx, dword ptr [ebp - local_4]           # 004ef320
    mov eax, dword ptr [edx + field_14a]         # 004ef323
    add eax, 0xa                                 # 004ef329
    {load} cmp ecx, eax                          # 004ef32c
    jg.d32 L_004ef3db                            # 004ef32e
    # block 0x004ef334: entered by fall-through of jg at 0x004ef32e, 6 instruction(s), ends with jl to 0x004ef3db (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ef334
    mov edx, dword ptr [ebp - local_4]           # 004ef338
    mov eax, dword ptr [edx + field_13e]         # 004ef33b
    add eax, 0x5                                 # 004ef341
    {load} cmp ecx, eax                          # 004ef344
    jl.d32 L_004ef3db                            # 004ef346
    # block 0x004ef34c: entered by fall-through of jl at 0x004ef346, 6 instruction(s), ends with jg to 0x004ef3db (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ef34c
    mov edx, dword ptr [ebp - local_4]           # 004ef350
    mov eax, dword ptr [edx + field_146]         # 004ef353
    add eax, 0x5                                 # 004ef359
    {load} cmp ecx, eax                          # 004ef35c
    jg.d8 L_004ef3db                             # 004ef35e
    # block 0x004ef360: entered by fall-through of jg at 0x004ef35e, 5 instruction(s), ends with jne to 0x004ef38c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ef360
    mov dword ptr [ecx + field_19a], 0x1         # 004ef363
    mov edx, dword ptr [ebp - local_4]           # 004ef36d
    cmp dword ptr [edx + field_10], 0x0          # 004ef370
    jne.d8 L_004ef38c                            # 004ef374
    # block 0x004ef376: entered by fall-through of jne at 0x004ef374, 3 instruction(s), ends with je to 0x004ef38c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ef376
    cmp dword ptr [eax + field_c2], 0x0          # 004ef379
    je.d8 L_004ef38c                             # 004ef380
    # block 0x004ef382: entered by fall-through of je at 0x004ef380, 2 instruction(s), falls into the block at 0x004ef38c
    mov ecx, dword ptr [ebp - local_4]           # 004ef382
    mov dword ptr [ecx + field_10], 0x1          # 004ef385
L_004ef38c:
    # block 0x004ef38c: entered by jne at 0x004ef374; je at 0x004ef380, 3 instruction(s), ends with je to 0x004ef3d4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ef38c
    cmp dword ptr [edx + field_ca], 0x0          # 004ef38f
    je.d8 L_004ef3d4                             # 004ef396
    # block 0x004ef398: entered by fall-through of je at 0x004ef396, 9 instruction(s), falls into the block at 0x004ef3d4
    mov dword ptr [0x5c39e5], 0x27d9             # 004ef398
    mov dword ptr [0x5b44f4], 0x1                # 004ef3a2
    mov eax, dword ptr [0x5b44f0]                # 004ef3ac
    shl eax, 0x5                                 # 004ef3b1
    mov ecx, dword ptr [0x5b44f4]                # 004ef3b4
    shl ecx, 0x4                                 # 004ef3ba
    lea edx, [eax + ecx + 0x5b160c]              # 004ef3bd
    mov dword ptr [0x5d1631], edx                # 004ef3c4
    mov dword ptr [0x5d1639], 0x1                # 004ef3ca
L_004ef3d4:
    # block 0x004ef3d4: entered by je at 0x004ef396, 2 instruction(s), ends with forward jump to 0x004ef3e7
    mov eax, 0x1                                 # 004ef3d4
    jmp.d8 L_004ef3e7                            # 004ef3d9
L_004ef3db:
    # block 0x004ef3db: entered by jl at 0x004ef316; jg at 0x004ef32e; jl at 0x004ef346; jg at 0x004ef35e, 2 instruction(s), falls into the block at 0x004ef3e5
    mov eax, dword ptr [ebp - local_4]           # 004ef3db
    mov dword ptr [eax + field_10], 0x0          # 004ef3de
L_004ef3e5:
    # block 0x004ef3e5: entered by jne at 0x004ef2fe, 1 instruction(s), falls into the block at 0x004ef3e7
    {load} xor eax, eax                          # 004ef3e5
L_004ef3e7:
    # block 0x004ef3e7: entered by jmp at 0x004ef3d9, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004ef3e7
    pop ebp                                      # 004ef3e9
    ret 0x8                                      # 004ef3ea

