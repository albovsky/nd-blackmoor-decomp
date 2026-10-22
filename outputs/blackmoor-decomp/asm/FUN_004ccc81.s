# FUN_004ccc81
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccc81
# extent:       0x004ccc81-0x004ccd25 (164 code bytes)
# span:         0x004ccc81-0x004ccd25 (code 164, tables 0, padding 0)
# sha256:       cdbbaf3f453fa8115a5a17094e800b8848b0be715fec33076e26e470c20956e5
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ccc81
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_14, field_28, field_30; [ecx + n] field_8, field_10, field_24, field_38; [edx + n] field_4, field_8, field_18, field_20, field_34
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_18, 0x18  # offset +0x18
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------

.org 0x004ccc81 - 0x401000
.globl FUN_004ccc81
FUN_004ccc81:
    # block 0x004ccc81: entry, 58 instruction(s), ends with ret 0x14
    push ebp                                     # 004ccc81
    {load} mov ebp, esp                          # 004ccc82
    push ecx                                     # 004ccc84
    mov dword ptr [ebp - local_4], ecx           # 004ccc85
    mov eax, dword ptr [ebp + arg_8]             # 004ccc88
    fld dword ptr [ebp + arg_10]                 # 004ccc8b
    fmul dword ptr [eax]                         # 004ccc8e
    mov ecx, dword ptr [ebp + arg_8]             # 004ccc90
    fld dword ptr [ebp + arg_14]                 # 004ccc93
    fmul dword ptr [ecx + field_10]              # 004ccc96
    faddp st(1), st                              # 004ccc99
    mov edx, dword ptr [ebp + arg_8]             # 004ccc9b
    fld dword ptr [ebp + arg_18]                 # 004ccc9e
    fmul dword ptr [edx + field_20]              # 004ccca1
    faddp st(1), st                              # 004ccca4
    mov eax, dword ptr [ebp + arg_8]             # 004ccca6
    fld dword ptr [eax + field_30]               # 004ccca9
    fmul dword ptr [0x52cbf4]                    # 004cccac
    faddp st(1), st                              # 004cccb2
    mov ecx, dword ptr [ebp + arg_c]             # 004cccb4
    fstp dword ptr [ecx]                         # 004cccb7
    mov edx, dword ptr [ebp + arg_8]             # 004cccb9
    fld dword ptr [ebp + arg_10]                 # 004cccbc
    fmul dword ptr [edx + field_4]               # 004cccbf
    mov eax, dword ptr [ebp + arg_8]             # 004cccc2
    fld dword ptr [ebp + arg_14]                 # 004cccc5
    fmul dword ptr [eax + field_14]              # 004cccc8
    faddp st(1), st                              # 004ccccb
    mov ecx, dword ptr [ebp + arg_8]             # 004ccccd
    fld dword ptr [ebp + arg_18]                 # 004cccd0
    fmul dword ptr [ecx + field_24]              # 004cccd3
    faddp st(1), st                              # 004cccd6
    mov edx, dword ptr [ebp + arg_8]             # 004cccd8
    fld dword ptr [edx + field_34]               # 004cccdb
    fmul dword ptr [0x52cbf4]                    # 004cccde
    faddp st(1), st                              # 004ccce4
    mov eax, dword ptr [ebp + arg_c]             # 004ccce6
    fstp dword ptr [eax + field_4]               # 004ccce9
    mov ecx, dword ptr [ebp + arg_8]             # 004cccec
    fld dword ptr [ebp + arg_10]                 # 004cccef
    fmul dword ptr [ecx + field_8]               # 004cccf2
    mov edx, dword ptr [ebp + arg_8]             # 004cccf5
    fld dword ptr [ebp + arg_14]                 # 004cccf8
    fmul dword ptr [edx + field_18]              # 004cccfb
    faddp st(1), st                              # 004cccfe
    mov eax, dword ptr [ebp + arg_8]             # 004ccd00
    fld dword ptr [ebp + arg_18]                 # 004ccd03
    fmul dword ptr [eax + field_28]              # 004ccd06
    faddp st(1), st                              # 004ccd09
    mov ecx, dword ptr [ebp + arg_8]             # 004ccd0b
    fld dword ptr [ecx + field_38]               # 004ccd0e
    fmul dword ptr [0x52cbf4]                    # 004ccd11
    faddp st(1), st                              # 004ccd17
    mov edx, dword ptr [ebp + arg_c]             # 004ccd19
    fstp dword ptr [edx + field_8]               # 004ccd1c
    {load} mov esp, ebp                          # 004ccd1f
    pop ebp                                      # 004ccd21
    ret 0x14                                     # 004ccd22

