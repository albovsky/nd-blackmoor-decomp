# FUN_00505fd0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00505fd0
# extent:       0x00505fd0-0x0050605c (140 code bytes)
# span:         0x00505fd0-0x00506060 (code 140, tables 0, padding 4)
# sha256:       b27844b1213d4e379060e93172f29cb4800c7e6f5e9cc404c0cab99f197eff2c
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00505fd0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c; [esp + n] stk_4, stk_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 49 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x00505fd0 - 0x401000
.globl FUN_00505fd0
FUN_00505fd0:
    # block 0x00505fd0: entry, 49 instruction(s), ends with ret
    sub esp, 0x8                                 # 00505fd0
    mov eax, dword ptr [esp + stk_c]             # 00505fd3
    fld dword ptr [eax + field_8]                # 00505fd7
    fadd dword ptr [eax + field_18]              # 00505fda
    fld dword ptr [eax + field_18]               # 00505fdd
    fsub dword ptr [eax + field_8]               # 00505fe0
    fstp dword ptr [esp + stk_c]                 # 00505fe3
    fld dword ptr [eax]                          # 00505fe7
    fadd dword ptr [eax + field_10]              # 00505fe9
    fld dword ptr [eax + field_10]               # 00505fec
    fsub dword ptr [eax]                         # 00505fef
    fstp dword ptr [esp + stk_4]                 # 00505ff1
    fld st(0)                                    # 00505ff5
    fadd st, st(2)                               # 00505ff7
    fstp dword ptr [eax + field_18]              # 00505ff9
    fxch st(1)                                   # 00505ffc
    fsub st, st(1)                               # 00505ffe
    fstp dword ptr [eax + field_10]              # 00506000
    fstp st(0)                                   # 00506003
    fld dword ptr [eax + field_14]               # 00506005
    fsub dword ptr [eax + field_4]               # 00506008
    fld dword ptr [eax + field_1c]               # 0050600b
    fsub dword ptr [eax + field_c]               # 0050600e
    {disp8} fstp dword ptr [esp]                 # 00506011
    fld dword ptr [esp + stk_c]                  # 00506015
    fadd st, st(1)                               # 00506019
    fstp dword ptr [eax]                         # 0050601b
    fld dword ptr [esp + stk_c]                  # 0050601d
    fsub st, st(1)                               # 00506021
    fstp dword ptr [eax + field_8]               # 00506023
    fstp st(0)                                   # 00506026
    fld dword ptr [eax + field_4]                # 00506028
    fadd dword ptr [eax + field_14]              # 0050602b
    fld dword ptr [eax + field_c]                # 0050602e
    fadd dword ptr [eax + field_1c]              # 00506031
    fld dword ptr [esp + stk_4]                  # 00506034
    {disp8} fadd dword ptr [esp]                 # 00506038
    fstp dword ptr [eax + field_c]               # 0050603c
    {disp8} fld dword ptr [esp]                  # 0050603f
    fsub dword ptr [esp + stk_4]                 # 00506043
    fstp dword ptr [eax + field_4]               # 00506047
    fld st(0)                                    # 0050604a
    fadd st, st(2)                               # 0050604c
    fstp dword ptr [eax + field_1c]              # 0050604e
    fsub st, st(1)                               # 00506051
    fstp dword ptr [eax + field_14]              # 00506053
    fstp st(0)                                   # 00506056
    add esp, 0x8                                 # 00506058
    ret                                          # 0050605b

# --- data items (not part of the function) -------------------------
.org 0x0050605c - 0x401000
PAD_0050605c:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

