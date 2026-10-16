# FUN_00506060
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00506060
# extent:       0x00506060-0x00506177 (279 code bytes)
# span:         0x00506060-0x00506180 (code 279, tables 0, padding 9)
# sha256:       6bd8f6ead6f326e4d2d5bcb848292d8f36609e354ecae1c054e3e9d6a15a45fb
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00506060
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_20, field_24; [ecx + n] field_minus_4, field_minus_8, field_minus_c, field_minus_10, field_minus_14, field_minus_18, field_minus_1c; [edi + n] field_minus_20; [edx + n] field_4; [esp + n] stk_c, stk_10, stk_14
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 107 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_1c, 0x1c  # offset -0x1c
.equ field_minus_20, 0x20  # offset -0x20
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x00506060 - 0x401000
.globl FUN_00506060
FUN_00506060:
    # block 0x00506060: entry, 12 instruction(s), falls into the block at 0x00506083
    mov ecx, dword ptr [esp + stk_c]             # 00506060
    push esi                                     # 00506064
    mov esi, dword ptr [esp + stk_14]            # 00506065
    {load} mov edx, ecx                          # 00506069
    push edi                                     # 0050606b
    mov edi, dword ptr [esp + stk_10]            # 0050606c
    sar edx                                      # 00506070
    shl esi, 0x2                                 # 00506072
    lea eax, [edi + 4*edx - field_minus_20]      # 00506075
    {load} sub ecx, edx                          # 00506079
    mov edx, dword ptr [esp + stk_c]             # 0050607b
    lea ecx, [eax + 4*ecx + field_1c]            # 0050607f
L_00506083:
    # block 0x00506083: entered by jae at 0x0050616e, 92 instruction(s), ends with jae to 0x00506083 (backward)
    fld dword ptr [ecx - field_minus_4]          # 00506083
    fsub dword ptr [eax + field_18]              # 00506086
    fld dword ptr [ecx]                          # 00506089
    fsub dword ptr [eax + field_1c]              # 0050608b
    fld dword ptr [ecx - field_minus_4]          # 0050608e
    fadd dword ptr [eax + field_18]              # 00506091
    fstp dword ptr [ecx - field_minus_4]         # 00506094
    fld dword ptr [eax + field_1c]               # 00506097
    fadd dword ptr [ecx]                         # 0050609a
    fstp dword ptr [ecx]                         # 0050609c
    fld st(0)                                    # 0050609e
    fmul dword ptr [edx + field_4]               # 005060a0
    fld st(2)                                    # 005060a3
    fmul dword ptr [edx]                         # 005060a5
    faddp st(1), st                              # 005060a7
    fstp dword ptr [eax + field_18]              # 005060a9
    fmul dword ptr [edx]                         # 005060ac
    fxch st(1)                                   # 005060ae
    fmul dword ptr [edx + field_4]               # 005060b0
    {load} add edx, esi                          # 005060b3
    fsubp st(1), st                              # 005060b5
    fstp dword ptr [eax + field_1c]              # 005060b7
    fld dword ptr [ecx - field_minus_c]          # 005060ba
    fsub dword ptr [eax + field_10]              # 005060bd
    fld dword ptr [ecx - field_minus_8]          # 005060c0
    fsub dword ptr [eax + field_14]              # 005060c3
    fld dword ptr [eax + field_10]               # 005060c6
    fadd dword ptr [ecx - field_minus_c]         # 005060c9
    fstp dword ptr [ecx - field_minus_c]         # 005060cc
    fld dword ptr [ecx - field_minus_8]          # 005060cf
    fadd dword ptr [eax + field_14]              # 005060d2
    fstp dword ptr [ecx - field_minus_8]         # 005060d5
    fld st(0)                                    # 005060d8
    fmul dword ptr [edx + field_4]               # 005060da
    fld st(2)                                    # 005060dd
    fmul dword ptr [edx]                         # 005060df
    faddp st(1), st                              # 005060e1
    fstp dword ptr [eax + field_10]              # 005060e3
    fmul dword ptr [edx]                         # 005060e6
    fxch st(1)                                   # 005060e8
    fmul dword ptr [edx + field_4]               # 005060ea
    {load} add edx, esi                          # 005060ed
    fsubp st(1), st                              # 005060ef
    fstp dword ptr [eax + field_14]              # 005060f1
    fld dword ptr [ecx - field_minus_14]         # 005060f4
    fsub dword ptr [eax + field_8]               # 005060f7
    fld dword ptr [ecx - field_minus_10]         # 005060fa
    fsub dword ptr [eax + field_c]               # 005060fd
    fld dword ptr [eax + field_8]                # 00506100
    fadd dword ptr [ecx - field_minus_14]        # 00506103
    fstp dword ptr [ecx - field_minus_14]        # 00506106
    fld dword ptr [eax + field_c]                # 00506109
    fadd dword ptr [ecx - field_minus_10]        # 0050610c
    fstp dword ptr [ecx - field_minus_10]        # 0050610f
    fld st(0)                                    # 00506112
    fmul dword ptr [edx + field_4]               # 00506114
    fld st(2)                                    # 00506117
    fmul dword ptr [edx]                         # 00506119
    faddp st(1), st                              # 0050611b
    fstp dword ptr [eax + field_8]               # 0050611d
    fmul dword ptr [edx]                         # 00506120
    fxch st(1)                                   # 00506122
    fmul dword ptr [edx + field_4]               # 00506124
    {load} add edx, esi                          # 00506127
    fsubp st(1), st                              # 00506129
    fstp dword ptr [eax + field_c]               # 0050612b
    fld dword ptr [ecx - field_minus_1c]         # 0050612e
    fsub dword ptr [eax]                         # 00506131
    fld dword ptr [ecx - field_minus_18]         # 00506133
    fsub dword ptr [eax + field_4]               # 00506136
    fld dword ptr [eax]                          # 00506139
    fadd dword ptr [ecx - field_minus_1c]        # 0050613b
    fstp dword ptr [ecx - field_minus_1c]        # 0050613e
    fld dword ptr [ecx - field_minus_18]         # 00506141
    fadd dword ptr [eax + field_4]               # 00506144
    fstp dword ptr [ecx - field_minus_18]        # 00506147
    sub eax, 0x20                                # 0050614a
    sub ecx, 0x20                                # 0050614d
    fld st(0)                                    # 00506150
    fmul dword ptr [edx + field_4]               # 00506152
    fld st(2)                                    # 00506155
    fmul dword ptr [edx]                         # 00506157
    faddp st(1), st                              # 00506159
    fstp dword ptr [eax + field_20]              # 0050615b
    fmul dword ptr [edx]                         # 0050615e
    fxch st(1)                                   # 00506160
    fmul dword ptr [edx + field_4]               # 00506162
    {load} add edx, esi                          # 00506165
    {load} cmp eax, edi                          # 00506167
    fsubp st(1), st                              # 00506169
    fstp dword ptr [eax + field_24]              # 0050616b
    jae.d32 L_00506083                           # 0050616e
    # block 0x00506174: entered by fall-through of jae at 0x0050616e, 3 instruction(s), ends with ret
    pop edi                                      # 00506174
    pop esi                                      # 00506175
    ret                                          # 00506176

# --- data items (not part of the function) -------------------------
.org 0x00506177 - 0x401000
PAD_00506177:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

