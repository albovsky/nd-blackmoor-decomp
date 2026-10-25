# FUN_00469259
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00469259
# extent:       0x00469259-0x00469374 (283 code bytes)
# span:         0x00469259-0x00469374 (code 283, tables 0, padding 0)
# sha256:       0d25684074687149d88614c3e0e88d2a3fd40311ccf7b2b2978e01349162d749
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00469259
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_7e, field_568, field_588; [ecx + n] field_7e, field_568, field_584; [edx + n] field_48a, field_560, field_564
# callees:      calls FUN_004fca60
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 72 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ field_7e, 0x7e  # offset +0x7e
.equ field_48a, 0x48a  # offset +0x48a
.equ field_560, 0x560  # offset +0x560
.equ field_564, 0x564  # offset +0x564
.equ field_568, 0x568  # offset +0x568
.equ field_584, 0x584  # offset +0x584
.equ field_588, 0x588  # offset +0x588

# --- external targets -----------------------------------------------
.set FUN_004fca60, .text + (0x004fca60 - 0x401000)

.org 0x00469259 - 0x401000
.globl FUN_00469259
FUN_00469259:
    # block 0x00469259: entry, 27 instruction(s), ends with jne to 0x00469339 (forward)
    push ebp                                     # 00469259
    {load} mov ebp, esp                          # 0046925a
    sub esp, 0xc                                 # 0046925c
    mov dword ptr [ebp - local_c], ecx           # 0046925f
    movsx eax, word ptr [ebp + arg_8]            # 00469262
    add eax, 0x3                                 # 00469266
    mov word ptr [ebp - local_8], ax             # 00469269
    mov dword ptr [0x5919f4], 0x0                # 0046926d
    movsx ecx, word ptr [ebp - local_8]          # 00469277
    movsx edx, word ptr [ebp + arg_8]            # 0046927b
    imul edx, edx, 0xc                           # 0046927f
    mov eax, dword ptr [ebp - local_c]           # 00469282
    fld dword ptr [4*ecx + 0x5919dc]             # 00469285
    fmul dword ptr [eax + edx + field_568]       # 0046928c
    movsx ecx, word ptr [ebp + arg_8]            # 00469293
    imul ecx, ecx, 0xc                           # 00469297
    mov edx, dword ptr [ebp - local_c]           # 0046929a
    fadd dword ptr [edx + ecx + field_560]       # 0046929d
    fstp dword ptr [ebp - local_4]               # 004692a4
    movsx eax, word ptr [ebp + arg_8]            # 004692a7
    mov ecx, dword ptr [ebp - local_c]           # 004692ab
    movsx edx, word ptr [ecx + field_7e]         # 004692ae
    imul edx, edx, 0x8d                          # 004692b2
    mov ecx, dword ptr [edx + 0x5bb5e5]          # 004692b8
    movsx edx, word ptr [ecx + field_568]        # 004692be
    {load} cmp eax, edx                          # 004692c5
    jne.d8 L_00469339                            # 004692c7
    # block 0x004692c9: entered by fall-through of jne at 0x004692c7, 8 instruction(s), ends with jne to 0x00469325 (forward)
    movsx eax, word ptr [0x58c94f]               # 004692c9
    imul eax, eax, 0xc                           # 004692d0
    mov ecx, dword ptr [ebp - local_c]           # 004692d3
    fld dword ptr [ebp - local_4]                # 004692d6
    fcomp dword ptr [ecx + eax + field_584]      # 004692d9
    fnstsw ax                                    # 004692e0
    test ah, 0x1                                 # 004692e2
    jne.d8 L_00469325                            # 004692e5
    # block 0x004692e7: entered by fall-through of jne at 0x004692e5, 8 instruction(s), ends with je to 0x00469325 (forward)
    movsx edx, word ptr [0x58c94f]               # 004692e7
    imul edx, edx, 0xc                           # 004692ee
    mov eax, dword ptr [ebp - local_c]           # 004692f1
    fld dword ptr [ebp - local_4]                # 004692f4
    fcomp dword ptr [eax + edx + field_588]      # 004692f7
    fnstsw ax                                    # 004692fe
    test ah, 0x41                                # 00469300
    je.d8 L_00469325                             # 00469303
    # block 0x00469305: entered by fall-through of je at 0x00469303, 7 instruction(s), ends with forward jump to 0x00469339
    movsx ecx, word ptr [ebp + arg_8]            # 00469305
    imul ecx, ecx, 0xc                           # 00469309
    mov edx, dword ptr [ebp - local_c]           # 0046930c
    mov eax, dword ptr [edx + ecx + field_564]   # 0046930f
    mov dword ptr [ebp - local_4], eax           # 00469316
    mov dword ptr [0x5919f4], 0x1                # 00469319
    jmp.d8 L_00469339                            # 00469323
L_00469325:
    # block 0x00469325: entered by jne at 0x004692e5; je at 0x00469303, 5 instruction(s), falls into the block at 0x00469339
    movsx ecx, word ptr [ebp + arg_8]            # 00469325
    imul ecx, ecx, 0xc                           # 00469329
    mov edx, dword ptr [ebp - local_c]           # 0046932c
    mov eax, dword ptr [edx + ecx + field_560]   # 0046932f
    mov dword ptr [ebp - local_4], eax           # 00469336
L_00469339:
    # block 0x00469339: entered by jne at 0x004692c7; jmp at 0x00469323, 17 instruction(s), calls FUN_004fca60, ends with ret 0x4
    mov ecx, dword ptr [ebp - local_4]           # 00469339
    push ecx                                     # 0046933c
    mov edx, dword ptr [ebp - local_4]           # 0046933d
    push edx                                     # 00469340
    mov eax, dword ptr [ebp - local_c]           # 00469341
    movsx ecx, word ptr [eax + field_7e]         # 00469344
    imul ecx, ecx, 0x8d                          # 00469348
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046934e
    movsx eax, word ptr [ebp + arg_8]            # 00469354
    imul eax, eax, 0x31                          # 00469358
    mov cx, word ptr [edx + eax + field_48a]     # 0046935b
    push ecx                                     # 00469363
    mov ecx, 0x5c3a67                            # 00469364
    call FUN_004fca60                            # 00469369
    {load} mov esp, ebp                          # 0046936e
    pop ebp                                      # 00469370
    ret 0x4                                      # 00469371

