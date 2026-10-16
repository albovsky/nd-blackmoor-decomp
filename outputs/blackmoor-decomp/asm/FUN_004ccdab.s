# FUN_004ccdab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccdab
# extent:       0x004ccdab-0x004ccef1 (326 code bytes)
# span:         0x004ccdab-0x004ccef1 (code 326, tables 0, padding 0)
# sha256:       521ba5342dad32f5ee803b35f61eb0e31887ceece3f254c8babce08117e6f87c
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ccdab
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_17e, field_1d6, field_20a, field_216, field_222, field_23a, field_246, field_256; [ecx + n] field_1de, field_20e, field_222, field_226, field_236, field_23e, field_24a; [edx + n] field_17a, field_206, field_212, field_22a, field_232, field_242, field_24e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 60 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_17a, 0x17a  # offset +0x17a
.equ field_17e, 0x17e  # offset +0x17e
.equ field_1d6, 0x1d6  # offset +0x1d6
.equ field_1de, 0x1de  # offset +0x1de
.equ field_206, 0x206  # offset +0x206
.equ field_20a, 0x20a  # offset +0x20a
.equ field_20e, 0x20e  # offset +0x20e
.equ field_212, 0x212  # offset +0x212
.equ field_216, 0x216  # offset +0x216
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226
.equ field_22a, 0x22a  # offset +0x22a
.equ field_232, 0x232  # offset +0x232
.equ field_236, 0x236  # offset +0x236
.equ field_23a, 0x23a  # offset +0x23a
.equ field_23e, 0x23e  # offset +0x23e
.equ field_242, 0x242  # offset +0x242
.equ field_246, 0x246  # offset +0x246
.equ field_24a, 0x24a  # offset +0x24a
.equ field_24e, 0x24e  # offset +0x24e
.equ field_256, 0x256  # offset +0x256

# --- external targets -----------------------------------------------

.org 0x004ccdab - 0x401000
.globl FUN_004ccdab
FUN_004ccdab:
    # block 0x004ccdab: entry, 60 instruction(s), ends with ret
    push ebp                                     # 004ccdab
    {load} mov ebp, esp                          # 004ccdac
    push ecx                                     # 004ccdae
    push edi                                     # 004ccdaf
    mov dword ptr [ebp - local_4], ecx           # 004ccdb0
    mov eax, dword ptr [ebp - local_4]           # 004ccdb3
    mov dword ptr [eax + field_216], 0x0         # 004ccdb6
    mov ecx, dword ptr [ebp - local_4]           # 004ccdc0
    mov dword ptr [ecx + field_236], 0x0         # 004ccdc3
    mov edx, dword ptr [ebp - local_4]           # 004ccdcd
    mov dword ptr [edx + field_206], 0x0         # 004ccdd0
    mov eax, dword ptr [ebp - local_4]           # 004ccdda
    mov dword ptr [eax + field_20a], 0x0         # 004ccddd
    mov ecx, dword ptr [ebp - local_4]           # 004ccde7
    mov dword ptr [ecx + field_20e], 0x0         # 004ccdea
    mov edx, dword ptr [ebp - local_4]           # 004ccdf4
    mov dword ptr [edx + field_212], 0x0         # 004ccdf7
    mov eax, dword ptr [ebp - local_4]           # 004cce01
    mov dword ptr [eax + field_1d6], 0x0         # 004cce04
    mov ecx, dword ptr [ebp - local_4]           # 004cce0e
    mov dword ptr [ecx + field_222], 0x0         # 004cce11
    mov ecx, 0x73                                # 004cce1b
    {load} xor eax, eax                          # 004cce20
    mov edi, dword ptr [ebp - local_4]           # 004cce22
    add edi, 0x8                                 # 004cce25
    rep stosd dword ptr es:[edi], eax            # 004cce28
    stosw word ptr es:[edi], ax                  # 004cce2a
    mov edx, dword ptr [ebp - local_4]           # 004cce2c
    mov dword ptr [edx + field_17a], 0x1         # 004cce2f
    mov eax, dword ptr [ebp - local_4]           # 004cce39
    mov dword ptr [eax + field_17e], 0x0         # 004cce3c
    mov dword ptr [0x5d1a45], 0x0                # 004cce46
    mov ecx, dword ptr [ebp - local_4]           # 004cce50
    mov dword ptr [ecx + field_1de], 0x0         # 004cce53
    mov edx, dword ptr [ebp - local_4]           # 004cce5d
    mov dword ptr [edx + field_232], 0xffffffff  # 004cce60
    mov eax, dword ptr [ebp - local_4]           # 004cce6a
    mov dword ptr [eax + field_23a], 0x2         # 004cce6d
    mov ecx, dword ptr [ebp - local_4]           # 004cce77
    mov dword ptr [ecx + field_23e], 0xffffffff  # 004cce7a
    mov edx, dword ptr [ebp - local_4]           # 004cce84
    mov dword ptr [edx + field_242], 0xffffffff  # 004cce87
    mov eax, dword ptr [ebp - local_4]           # 004cce91
    mov dword ptr [eax + field_222], 0x0         # 004cce94
    mov ecx, dword ptr [ebp - local_4]           # 004cce9e
    mov dword ptr [ecx + field_226], 0x0         # 004ccea1
    mov edx, dword ptr [ebp - local_4]           # 004cceab
    mov dword ptr [edx + field_22a], 0x0         # 004cceae
    mov eax, dword ptr [ebp - local_4]           # 004cceb8
    mov dword ptr [eax + field_246], 0xffffffff  # 004ccebb
    mov ecx, dword ptr [ebp - local_4]           # 004ccec5
    mov dword ptr [ecx + field_24a], 0xffffffff  # 004ccec8
    mov edx, dword ptr [ebp - local_4]           # 004cced2
    mov dword ptr [edx + field_24e], 0x0         # 004cced5
    mov eax, dword ptr [ebp - local_4]           # 004ccedf
    mov dword ptr [eax + field_256], 0xffffffff  # 004ccee2
    pop edi                                      # 004cceec
    {load} mov esp, ebp                          # 004cceed
    pop ebp                                      # 004cceef
    ret                                          # 004ccef0

