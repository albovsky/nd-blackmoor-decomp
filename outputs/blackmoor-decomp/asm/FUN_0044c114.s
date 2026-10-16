# FUN_0044c114
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c114
# extent:       0x0044c114-0x0044c1a3 (143 code bytes)
# span:         0x0044c114-0x0044c1a3 (code 143, tables 0, padding 0)
# sha256:       009a30874d78d78778789ee8bac19beea6224dd135eb1cafaaaa3029cc646413
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044c114
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4; [ecx + n] field_4; [edx + n] field_4, field_8
# callees:      calls FUN_0050e104, FUN_0050e054, FUN_0044bf4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0044bf4b, .text + (0x0044bf4b - 0x401000)
.set FUN_0050e054, .text + (0x0050e054 - 0x401000)
.set FUN_0050e104, .text + (0x0050e104 - 0x401000)

.org 0x0044c114 - 0x401000
.globl FUN_0044c114
FUN_0044c114:
    # block 0x0044c114: entry, 49 instruction(s), calls FUN_0050e104, FUN_0050e054, FUN_0044bf4b, ends with ret 0x8
    push ebp                                     # 0044c114
    {load} mov ebp, esp                          # 0044c115
    sub esp, 0x1c                                # 0044c117
    mov dword ptr [ebp - local_1c], ecx          # 0044c11a
    fld dword ptr [ebp + arg_c]                  # 0044c11d
    fmul dword ptr [0x52cbf8]                    # 0044c120
    fstp dword ptr [ebp - local_18]              # 0044c126
    fld dword ptr [ebp - local_18]               # 0044c129
    sub esp, 0x8                                 # 0044c12c
    fstp qword ptr [esp]                         # 0044c12f
    call FUN_0050e104                            # 0044c132
    add esp, 0x8                                 # 0044c137
    fstp dword ptr [ebp - local_4]               # 0044c13a
    fld dword ptr [ebp - local_18]               # 0044c13d
    sub esp, 0x8                                 # 0044c140
    fstp qword ptr [esp]                         # 0044c143
    call FUN_0050e054                            # 0044c146
    add esp, 0x8                                 # 0044c14b
    fstp dword ptr [ebp - local_8]               # 0044c14e
    mov eax, dword ptr [ebp + arg_8]             # 0044c151
    fld dword ptr [ebp - local_8]                # 0044c154
    fmul dword ptr [eax]                         # 0044c157
    mov ecx, dword ptr [ebp + arg_8]             # 0044c159
    fld dword ptr [ebp - local_4]                # 0044c15c
    fmul dword ptr [ecx + field_4]               # 0044c15f
    fsubp st(1), st                              # 0044c162
    fstp dword ptr [ebp - local_14]              # 0044c164
    mov edx, dword ptr [ebp + arg_8]             # 0044c167
    fld dword ptr [ebp - local_4]                # 0044c16a
    fmul dword ptr [edx]                         # 0044c16d
    mov eax, dword ptr [ebp + arg_8]             # 0044c16f
    fld dword ptr [ebp - local_8]                # 0044c172
    fmul dword ptr [eax + field_4]               # 0044c175
    faddp st(1), st                              # 0044c178
    fstp dword ptr [ebp - local_10]              # 0044c17a
    lea ecx, [ebp - local_14]                    # 0044c17d
    push ecx                                     # 0044c180
    mov ecx, dword ptr [ebp - local_1c]          # 0044c181
    call FUN_0044bf4b                            # 0044c184
    mov edx, dword ptr [ebp + arg_8]             # 0044c189
    mov eax, dword ptr [ebp - local_14]          # 0044c18c
    mov dword ptr [edx], eax                     # 0044c18f
    mov ecx, dword ptr [ebp - local_10]          # 0044c191
    mov dword ptr [edx + field_4], ecx           # 0044c194
    mov eax, dword ptr [ebp - local_c]           # 0044c197
    mov dword ptr [edx + field_8], eax           # 0044c19a
    {load} mov esp, ebp                          # 0044c19d
    pop ebp                                      # 0044c19f
    ret 0x8                                      # 0044c1a0

