# FUN_00482248
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00482248
# extent:       0x00482248-0x00482359 (273 code bytes)
# span:         0x00482248-0x00482359 (code 273, tables 0, padding 0)
# sha256:       254a3345993b9af0d18463fc2938a2e932d3fbf630667542062d40624825f406
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00482248
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [edx + n] field_87c
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 87 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_87c, 0x87c  # offset +0x87c

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00482248 - 0x401000
.globl FUN_00482248
FUN_00482248:
    # block 0x00482248: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004822af (forward)
    push ebp                                     # 00482248
    {load} mov ebp, esp                          # 00482249
    sub esp, 0x10                                # 0048224b
    push esi                                     # 0048224e
    push edi                                     # 0048224f
    mov dword ptr [ebp - local_10], ecx          # 00482250
    push 0xef0                                   # 00482253
    call FUN_0051dc43                            # 00482258
    add esp, 0x4                                 # 0048225d
    mov dword ptr [ebp - local_c], eax           # 00482260
    mov eax, dword ptr [ebp + arg_8]             # 00482263
    mov ecx, dword ptr [ebp - local_c]           # 00482266
    mov dword ptr [eax], ecx                     # 00482269
    cmp dword ptr [ebp - local_c], 0x0           # 0048226b
    jne.d8 L_004822af                            # 0048226f
    # block 0x00482271: entered by fall-through of jne at 0x0048226f, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004822af
    movsx edx, word ptr [0x5c39e3]               # 00482271
    push edx                                     # 00482278
    mov eax, dword ptr [0x5bb57b]                # 00482279
    push eax                                     # 0048227e
    push 0x54d840                                # 0048227f
    push 0x63888b                                # 00482284
    call FUN_0050ca3e                            # 00482289
    add esp, 0x10                                # 0048228e
    push 0x63888b                                # 00482291
    push 0x54d86c                                # 00482296
    mov ecx, 0x583979                            # 0048229b
    call FUN_0042639d                            # 004822a0
    mov ecx, 0x5cf659                            # 004822a5
    call FUN_004c97b4                            # 004822aa
L_004822af:
    # block 0x004822af: entered by jne at 0x0048226f, 50 instruction(s), ends with je to 0x00482351 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004822af
    mov esi, dword ptr [ecx]                     # 004822b2
    mov edx, dword ptr [ebp + arg_8]             # 004822b4
    mov edi, dword ptr [edx]                     # 004822b7
    mov ecx, 0x21f                               # 004822b9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004822be
    movsw word ptr es:[edi], word ptr [esi]      # 004822c0
    mov eax, dword ptr [ebp + arg_8]             # 004822c2
    mov ecx, dword ptr [eax]                     # 004822c5
    mov dword ptr [ebp - local_4], ecx           # 004822c7
    mov edx, dword ptr [ebp + arg_10]            # 004822ca
    mov eax, dword ptr [edx]                     # 004822cd
    add eax, 0x87e                               # 004822cf
    mov ecx, dword ptr [ebp + arg_10]            # 004822d4
    mov dword ptr [ecx], eax                     # 004822d7
    mov edx, dword ptr [ebp + arg_c]             # 004822d9
    mov eax, dword ptr [edx]                     # 004822dc
    add eax, 0x87e                               # 004822de
    mov ecx, dword ptr [ebp + arg_c]             # 004822e3
    mov dword ptr [ecx], eax                     # 004822e6
    mov edx, dword ptr [ebp - local_4]           # 004822e8
    movsx eax, word ptr [edx + field_87c]        # 004822eb
    imul eax, eax, 0x37                          # 004822f2
    mov word ptr [ebp - local_8], ax             # 004822f5
    movsx ecx, word ptr [ebp - local_8]          # 004822f9
    mov edx, dword ptr [ebp + arg_c]             # 004822fd
    mov esi, dword ptr [edx]                     # 00482300
    mov edi, dword ptr [ebp - local_4]           # 00482302
    add edi, 0x87e                               # 00482305
    {load} mov eax, ecx                          # 0048230b
    shr ecx, 0x2                                 # 0048230d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00482310
    {load} mov ecx, eax                          # 00482312
    and ecx, 0x3                                 # 00482314
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00482317
    movsx ecx, word ptr [ebp - local_8]          # 00482319
    mov edx, dword ptr [ebp + arg_10]            # 0048231d
    mov eax, dword ptr [edx]                     # 00482320
    {load} add eax, ecx                          # 00482322
    mov ecx, dword ptr [ebp + arg_10]            # 00482324
    mov dword ptr [ecx], eax                     # 00482327
    movsx edx, word ptr [ebp - local_8]          # 00482329
    mov eax, dword ptr [ebp + arg_c]             # 0048232d
    mov ecx, dword ptr [eax]                     # 00482330
    {load} add ecx, edx                          # 00482332
    mov edx, dword ptr [ebp + arg_c]             # 00482334
    mov dword ptr [edx], ecx                     # 00482337
    movsx eax, word ptr [0x63a4cd]               # 00482339
    test eax, eax                                # 00482340
    je.d8 L_00482351                             # 00482342
    # block 0x00482344: entered by fall-through of je at 0x00482342, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00482351
    push 0x54d888                                # 00482344
    call FUN_0044a2b7                            # 00482349
    add esp, 0x4                                 # 0048234e
L_00482351:
    # block 0x00482351: entered by je at 0x00482342, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00482351
    pop esi                                      # 00482352
    {load} mov esp, ebp                          # 00482353
    pop ebp                                      # 00482355
    ret 0xc                                      # 00482356

