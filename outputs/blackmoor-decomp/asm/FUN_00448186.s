# FUN_00448186
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00448186
# extent:       0x00448186-0x00448254 (206 code bytes)
# span:         0x00448186-0x00448254 (code 206, tables 0, padding 0)
# sha256:       cf007f3faf2a24c79d6cec03b320f6ff128c2c21de1b7be067228be4a9035ec6
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00448186
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 62 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00448186 - 0x401000
.globl FUN_00448186
FUN_00448186:
    # block 0x00448186: entry, 9 instruction(s), ends with je to 0x0044824c (forward)
    push ebp                                     # 00448186
    {load} mov ebp, esp                          # 00448187
    sub esp, 0xc                                 # 00448189
    push esi                                     # 0044818c
    push edi                                     # 0044818d
    mov dword ptr [ebp - local_c], ecx           # 0044818e
    mov eax, dword ptr [ebp - local_c]           # 00448191
    cmp dword ptr [eax + field_1e], 0x0          # 00448194
    je.d32 L_0044824c                            # 00448198
    # block 0x0044819e: entered by fall-through of je at 0x00448198, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x004481fb (forward)
    push 0xac                                    # 0044819e
    call FUN_0051dc43                            # 004481a3
    add esp, 0x4                                 # 004481a8
    mov dword ptr [ebp - local_8], eax           # 004481ab
    mov ecx, dword ptr [ebp + arg_8]             # 004481ae
    mov edx, dword ptr [ebp - local_8]           # 004481b1
    mov dword ptr [ecx], edx                     # 004481b4
    cmp dword ptr [ebp - local_8], 0x0           # 004481b6
    jne.d8 L_004481fb                            # 004481ba
    # block 0x004481bc: entered by fall-through of jne at 0x004481ba, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004481fb
    movsx eax, word ptr [0x5c39e3]               # 004481bc
    push eax                                     # 004481c3
    mov ecx, dword ptr [0x5bb57b]                # 004481c4
    push ecx                                     # 004481ca
    push 0x548734                                # 004481cb
    push 0x63888b                                # 004481d0
    call FUN_0050ca3e                            # 004481d5
    add esp, 0x10                                # 004481da
    push 0x63888b                                # 004481dd
    push 0x548760                                # 004481e2
    mov ecx, 0x583979                            # 004481e7
    call FUN_0042639d                            # 004481ec
    mov ecx, 0x5cf659                            # 004481f1
    call FUN_004c97b4                            # 004481f6
L_004481fb:
    # block 0x004481fb: entered by jne at 0x004481ba, 22 instruction(s), ends with je to 0x0044824c (forward)
    mov edx, dword ptr [ebp + arg_c]             # 004481fb
    mov esi, dword ptr [edx]                     # 004481fe
    mov eax, dword ptr [ebp + arg_8]             # 00448200
    mov edi, dword ptr [eax]                     # 00448203
    mov ecx, 0x2b                                # 00448205
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044820a
    mov ecx, dword ptr [ebp + arg_8]             # 0044820c
    mov edx, dword ptr [ecx]                     # 0044820f
    mov dword ptr [ebp - local_4], edx           # 00448211
    mov eax, dword ptr [ebp + arg_c]             # 00448214
    mov ecx, dword ptr [eax]                     # 00448217
    add ecx, 0xac                                # 00448219
    mov edx, dword ptr [ebp + arg_c]             # 0044821f
    mov dword ptr [edx], ecx                     # 00448222
    mov eax, dword ptr [ebp + arg_10]            # 00448224
    mov ecx, dword ptr [eax]                     # 00448227
    add ecx, 0xac                                # 00448229
    mov edx, dword ptr [ebp + arg_10]            # 0044822f
    mov dword ptr [edx], ecx                     # 00448232
    movsx eax, word ptr [0x63a4cd]               # 00448234
    test eax, eax                                # 0044823b
    je.d8 L_0044824c                             # 0044823d
    # block 0x0044823f: entered by fall-through of je at 0x0044823d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044824c
    push 0x54877c                                # 0044823f
    call FUN_0044a2b7                            # 00448244
    add esp, 0x4                                 # 00448249
L_0044824c:
    # block 0x0044824c: entered by je at 0x00448198; je at 0x0044823d, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0044824c
    pop esi                                      # 0044824d
    {load} mov esp, ebp                          # 0044824e
    pop ebp                                      # 00448250
    ret 0xc                                      # 00448251

