# FUN_004db29b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db29b
# extent:       0x004db29b-0x004db377 (220 code bytes)
# span:         0x004db29b-0x004db377 (code 220, tables 0, padding 0)
# sha256:       a1eced2122ff890a10a286fa87057f47c0f8419808b8ca6b659453630d291172
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004db29b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_10; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 77 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x004db29b - 0x401000
.globl FUN_004db29b
FUN_004db29b:
    # block 0x004db29b: entry, 77 instruction(s), ends with ret
    push ebp                                     # 004db29b
    {load} mov ebp, esp                          # 004db29c
    push ecx                                     # 004db29e
    mov dword ptr [ebp - local_4], ecx           # 004db29f
    mov eax, dword ptr [ebp - local_4]           # 004db2a2
    mov dword ptr [eax + field_4], 0x0           # 004db2a5
    mov ecx, dword ptr [ebp - local_4]           # 004db2ac
    mov dword ptr [ecx + field_8], 0x0           # 004db2af
    mov edx, dword ptr [ebp - local_4]           # 004db2b6
    mov dword ptr [edx + field_c], 0x0           # 004db2b9
    mov eax, dword ptr [ebp - local_4]           # 004db2c0
    mov dword ptr [eax + field_10], 0x0          # 004db2c3
    {load} xor ecx, ecx                          # 004db2ca
    mov edx, dword ptr [ebp - local_4]           # 004db2cc
    add edx, 0x14                                # 004db2cf
    mov dword ptr [edx], ecx                     # 004db2d2
    mov dword ptr [edx + field_4], ecx           # 004db2d4
    {load} xor eax, eax                          # 004db2d7
    mov ecx, dword ptr [ebp - local_4]           # 004db2d9
    add ecx, 0x1c                                # 004db2dc
    mov dword ptr [ecx], eax                     # 004db2df
    mov dword ptr [ecx + field_4], eax           # 004db2e1
    {load} xor edx, edx                          # 004db2e4
    mov eax, dword ptr [ebp - local_4]           # 004db2e6
    add eax, 0x64                                # 004db2e9
    mov dword ptr [eax], edx                     # 004db2ec
    mov dword ptr [eax + field_4], edx           # 004db2ee
    {load} xor ecx, ecx                          # 004db2f1
    mov edx, dword ptr [ebp - local_4]           # 004db2f3
    add edx, 0x6c                                # 004db2f6
    mov dword ptr [edx], ecx                     # 004db2f9
    mov dword ptr [edx + field_4], ecx           # 004db2fb
    {load} xor eax, eax                          # 004db2fe
    mov ecx, dword ptr [ebp - local_4]           # 004db300
    add ecx, 0x34                                # 004db303
    mov dword ptr [ecx], eax                     # 004db306
    mov dword ptr [ecx + field_4], eax           # 004db308
    mov dword ptr [ecx + field_8], eax           # 004db30b
    mov dword ptr [ecx + field_c], eax           # 004db30e
    {load} xor edx, edx                          # 004db311
    mov eax, dword ptr [ebp - local_4]           # 004db313
    add eax, 0x24                                # 004db316
    mov dword ptr [eax], edx                     # 004db319
    mov dword ptr [eax + field_4], edx           # 004db31b
    mov dword ptr [eax + field_8], edx           # 004db31e
    mov dword ptr [eax + field_c], edx           # 004db321
    {load} xor ecx, ecx                          # 004db324
    mov edx, dword ptr [ebp - local_4]           # 004db326
    add edx, 0x44                                # 004db329
    mov dword ptr [edx], ecx                     # 004db32c
    mov dword ptr [edx + field_4], ecx           # 004db32e
    mov dword ptr [edx + field_8], ecx           # 004db331
    mov dword ptr [edx + field_c], ecx           # 004db334
    {load} xor eax, eax                          # 004db337
    mov ecx, dword ptr [ebp - local_4]           # 004db339
    add ecx, 0x54                                # 004db33c
    mov dword ptr [ecx], eax                     # 004db33f
    mov dword ptr [ecx + field_4], eax           # 004db341
    mov dword ptr [ecx + field_8], eax           # 004db344
    mov dword ptr [ecx + field_c], eax           # 004db347
    {load} xor edx, edx                          # 004db34a
    mov eax, dword ptr [ebp - local_4]           # 004db34c
    add eax, 0x74                                # 004db34f
    mov dword ptr [eax], edx                     # 004db352
    mov dword ptr [eax + field_4], edx           # 004db354
    mov dword ptr [eax + field_8], edx           # 004db357
    mov dword ptr [eax + field_c], edx           # 004db35a
    {load} xor ecx, ecx                          # 004db35d
    mov edx, dword ptr [ebp - local_4]           # 004db35f
    add edx, 0x84                                # 004db362
    mov dword ptr [edx], ecx                     # 004db368
    mov dword ptr [edx + field_4], ecx           # 004db36a
    mov dword ptr [edx + field_8], ecx           # 004db36d
    mov dword ptr [edx + field_c], ecx           # 004db370
    {load} mov esp, ebp                          # 004db373
    pop ebp                                      # 004db375
    ret                                          # 004db376

