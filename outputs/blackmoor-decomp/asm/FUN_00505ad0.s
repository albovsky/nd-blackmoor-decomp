# FUN_00505ad0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00505ad0
# extent:       0x00505ad0-0x00505fc5 (1269 code bytes)
# span:         0x00505ad0-0x00505fd0 (code 1269, tables 0, padding 11)
# sha256:       5ac4ae037f55d18aaa874fc6e7d600c154f8cbea009d2c202ec897ee5866bf57
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00505ad0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_14, field_18, field_1c, field_20, field_24, field_28, field_2c, field_30 and 19 more; [esp + n] stk_4, stk_8, stk_c, stk_10
# callees:      calls FUN_00505fd0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 409 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64
.equ field_68, 0x68  # offset +0x68
.equ field_6c, 0x6c  # offset +0x6c
.equ field_70, 0x70  # offset +0x70
.equ field_74, 0x74  # offset +0x74
.equ field_78, 0x78  # offset +0x78
.equ field_7c, 0x7c  # offset +0x7c

# --- external targets -----------------------------------------------
.set FUN_00505fd0, .text + (0x00505fd0 - 0x401000)

.org 0x00505ad0 - 0x401000
.globl FUN_00505ad0
FUN_00505ad0:
    # block 0x00505ad0: entry, 409 instruction(s), calls FUN_00505fd0, ends with ret
    sub esp, 0x8                                 # 00505ad0
    mov eax, dword ptr [esp + stk_c]             # 00505ad3
    fld dword ptr [eax + field_78]               # 00505ad7
    fsub dword ptr [eax + field_38]              # 00505ada
    fld dword ptr [eax + field_7c]               # 00505add
    fsub dword ptr [eax + field_3c]              # 00505ae0
    fstp dword ptr [esp + stk_c]                 # 00505ae3
    fld dword ptr [eax + field_38]               # 00505ae7
    fadd dword ptr [eax + field_78]              # 00505aea
    mov ecx, dword ptr [esp + stk_c]             # 00505aed
    fstp dword ptr [eax + field_78]              # 00505af1
    fld dword ptr [eax + field_7c]               # 00505af4
    fadd dword ptr [eax + field_3c]              # 00505af7
    mov dword ptr [eax + field_3c], ecx          # 00505afa
    fstp dword ptr [eax + field_7c]              # 00505afd
    fstp dword ptr [eax + field_38]              # 00505b00
    fld dword ptr [eax + field_70]               # 00505b03
    fsub dword ptr [eax + field_30]              # 00505b06
    fld dword ptr [eax + field_74]               # 00505b09
    fsub dword ptr [eax + field_34]              # 00505b0c
    fld dword ptr [eax + field_30]               # 00505b0f
    fadd dword ptr [eax + field_70]              # 00505b12
    fstp dword ptr [eax + field_70]              # 00505b15
    fld dword ptr [eax + field_74]               # 00505b18
    fadd dword ptr [eax + field_34]              # 00505b1b
    fstp dword ptr [eax + field_74]              # 00505b1e
    fld st(1)                                    # 00505b21
    fmul dword ptr [0x52e640]                    # 00505b23
    fld st(1)                                    # 00505b29
    fmul dword ptr [0x52e63c]                    # 00505b2b
    fsubp st(1), st                              # 00505b31
    fstp dword ptr [eax + field_30]              # 00505b33
    fmul dword ptr [0x52e640]                    # 00505b36
    fxch st(1)                                   # 00505b3c
    fmul dword ptr [0x52e63c]                    # 00505b3e
    faddp st(1), st                              # 00505b44
    fstp dword ptr [eax + field_34]              # 00505b46
    fld dword ptr [eax + field_68]               # 00505b49
    fsub dword ptr [eax + field_28]              # 00505b4c
    fld dword ptr [eax + field_6c]               # 00505b4f
    fsub dword ptr [eax + field_2c]              # 00505b52
    fld dword ptr [eax + field_28]               # 00505b55
    fadd dword ptr [eax + field_68]              # 00505b58
    fstp dword ptr [eax + field_68]              # 00505b5b
    fld dword ptr [eax + field_6c]               # 00505b5e
    fadd dword ptr [eax + field_2c]              # 00505b61
    fstp dword ptr [eax + field_6c]              # 00505b64
    fld st(1)                                    # 00505b67
    fsub st, st(1)                               # 00505b69
    fmul dword ptr [0x52e638]                    # 00505b6b
    fstp dword ptr [eax + field_28]              # 00505b71
    fadd st, st(1)                               # 00505b74
    fmul dword ptr [0x52e638]                    # 00505b76
    fstp dword ptr [eax + field_2c]              # 00505b7c
    fstp st(0)                                   # 00505b7f
    fld dword ptr [eax + field_60]               # 00505b81
    fsub dword ptr [eax + field_20]              # 00505b84
    fld dword ptr [eax + field_64]               # 00505b87
    fsub dword ptr [eax + field_24]              # 00505b8a
    fld dword ptr [eax + field_20]               # 00505b8d
    fadd dword ptr [eax + field_60]              # 00505b90
    fstp dword ptr [eax + field_60]              # 00505b93
    fld dword ptr [eax + field_64]               # 00505b96
    fadd dword ptr [eax + field_24]              # 00505b99
    fstp dword ptr [eax + field_64]              # 00505b9c
    fld st(1)                                    # 00505b9f
    fmul dword ptr [0x52e63c]                    # 00505ba1
    fld st(1)                                    # 00505ba7
    fmul dword ptr [0x52e640]                    # 00505ba9
    fsubp st(1), st                              # 00505baf
    fstp dword ptr [eax + field_20]              # 00505bb1
    fmul dword ptr [0x52e63c]                    # 00505bb4
    fxch st(1)                                   # 00505bba
    fmul dword ptr [0x52e640]                    # 00505bbc
    faddp st(1), st                              # 00505bc2
    fstp dword ptr [eax + field_24]              # 00505bc4
    fld dword ptr [eax + field_58]               # 00505bc7
    fsub dword ptr [eax + field_18]              # 00505bca
    fld dword ptr [eax + field_1c]               # 00505bcd
    fsub dword ptr [eax + field_5c]              # 00505bd0
    fld dword ptr [eax + field_18]               # 00505bd3
    fadd dword ptr [eax + field_58]              # 00505bd6
    fstp dword ptr [eax + field_58]              # 00505bd9
    fld dword ptr [eax + field_1c]               # 00505bdc
    fadd dword ptr [eax + field_5c]              # 00505bdf
    fstp dword ptr [eax + field_5c]              # 00505be2
    fstp dword ptr [eax + field_18]              # 00505be5
    fstp dword ptr [eax + field_1c]              # 00505be8
    fld dword ptr [eax + field_10]               # 00505beb
    fsub dword ptr [eax + field_50]              # 00505bee
    fld dword ptr [eax + field_14]               # 00505bf1
    fsub dword ptr [eax + field_54]              # 00505bf4
    fld dword ptr [eax + field_50]               # 00505bf7
    fadd dword ptr [eax + field_10]              # 00505bfa
    fstp dword ptr [eax + field_50]              # 00505bfd
    fld dword ptr [eax + field_14]               # 00505c00
    fadd dword ptr [eax + field_54]              # 00505c03
    fstp dword ptr [eax + field_54]              # 00505c06
    fld st(0)                                    # 00505c09
    fmul dword ptr [0x52e640]                    # 00505c0b
    fld st(2)                                    # 00505c11
    fmul dword ptr [0x52e63c]                    # 00505c13
    faddp st(1), st                              # 00505c19
    fstp dword ptr [eax + field_10]              # 00505c1b
    fmul dword ptr [0x52e63c]                    # 00505c1e
    fxch st(1)                                   # 00505c24
    fmul dword ptr [0x52e640]                    # 00505c26
    fsubp st(1), st                              # 00505c2c
    fstp dword ptr [eax + field_14]              # 00505c2e
    fld dword ptr [eax + field_8]                # 00505c31
    fsub dword ptr [eax + field_48]              # 00505c34
    fld dword ptr [eax + field_c]                # 00505c37
    fsub dword ptr [eax + field_4c]              # 00505c3a
    fld dword ptr [eax + field_48]               # 00505c3d
    fadd dword ptr [eax + field_8]               # 00505c40
    fstp dword ptr [eax + field_48]              # 00505c43
    fld dword ptr [eax + field_4c]               # 00505c46
    fadd dword ptr [eax + field_c]               # 00505c49
    fstp dword ptr [eax + field_4c]              # 00505c4c
    fld st(0)                                    # 00505c4f
    fadd st, st(2)                               # 00505c51
    fmul dword ptr [0x52e638]                    # 00505c53
    fstp dword ptr [eax + field_8]               # 00505c59
    fsub st, st(1)                               # 00505c5c
    fmul dword ptr [0x52e638]                    # 00505c5e
    fstp dword ptr [eax + field_c]               # 00505c64
    fstp st(0)                                   # 00505c67
    fld dword ptr [eax]                          # 00505c69
    fsub dword ptr [eax + field_40]              # 00505c6b
    fld dword ptr [eax + field_4]                # 00505c6e
    fsub dword ptr [eax + field_44]              # 00505c71
    fld dword ptr [eax + field_40]               # 00505c74
    fadd dword ptr [eax]                         # 00505c77
    fstp dword ptr [eax + field_40]              # 00505c79
    fld dword ptr [eax + field_44]               # 00505c7c
    fadd dword ptr [eax + field_4]               # 00505c7f
    fstp dword ptr [eax + field_44]              # 00505c82
    fld st(0)                                    # 00505c85
    fmul dword ptr [0x52e63c]                    # 00505c87
    fld st(2)                                    # 00505c8d
    fmul dword ptr [0x52e640]                    # 00505c8f
    faddp st(1), st                              # 00505c95
    {disp8} fstp dword ptr [esp]                 # 00505c97
    fmul dword ptr [0x52e640]                    # 00505c9b
    fxch st(1)                                   # 00505ca1
    fmul dword ptr [0x52e63c]                    # 00505ca3
    fsubp st(1), st                              # 00505ca9
    fld st(0)                                    # 00505cab
    fsub dword ptr [eax + field_24]              # 00505cad
    fstp dword ptr [esp + stk_4]                 # 00505cb0
    {disp8} fld dword ptr [esp]                  # 00505cb4
    fsub dword ptr [eax + field_20]              # 00505cb8
    fstp dword ptr [esp + stk_c]                 # 00505cbb
    {disp8} fld dword ptr [esp]                  # 00505cbf
    fadd dword ptr [eax + field_20]              # 00505cc3
    fstp dword ptr [eax + field_20]              # 00505cc6
    fadd dword ptr [eax + field_24]              # 00505cc9
    fstp dword ptr [eax + field_24]              # 00505ccc
    fld dword ptr [esp + stk_c]                  # 00505ccf
    fadd dword ptr [esp + stk_4]                 # 00505cd3
    fmul dword ptr [0x52e638]                    # 00505cd7
    fstp dword ptr [eax]                         # 00505cdd
    fld dword ptr [esp + stk_4]                  # 00505cdf
    fsub dword ptr [esp + stk_c]                 # 00505ce3
    fmul dword ptr [0x52e638]                    # 00505ce7
    fstp dword ptr [eax + field_4]               # 00505ced
    fld dword ptr [eax + field_c]                # 00505cf0
    fsub dword ptr [eax + field_2c]              # 00505cf3
    fld dword ptr [eax + field_28]               # 00505cf6
    fsub dword ptr [eax + field_8]               # 00505cf9
    fstp dword ptr [esp + stk_c]                 # 00505cfc
    fld dword ptr [eax + field_8]                # 00505d00
    fadd dword ptr [eax + field_28]              # 00505d03
    mov edx, dword ptr [esp + stk_c]             # 00505d06
    fstp dword ptr [eax + field_28]              # 00505d0a
    fld dword ptr [eax + field_c]                # 00505d0d
    fadd dword ptr [eax + field_2c]              # 00505d10
    mov dword ptr [eax + field_c], edx           # 00505d13
    fstp dword ptr [eax + field_2c]              # 00505d16
    fstp dword ptr [eax + field_8]               # 00505d19
    fld dword ptr [eax + field_30]               # 00505d1c
    fsub dword ptr [eax + field_10]              # 00505d1f
    fld dword ptr [eax + field_34]               # 00505d22
    fsub dword ptr [eax + field_14]              # 00505d25
    fld dword ptr [eax + field_30]               # 00505d28
    fadd dword ptr [eax + field_10]              # 00505d2b
    fstp dword ptr [eax + field_30]              # 00505d2e
    fld dword ptr [eax + field_14]               # 00505d31
    fadd dword ptr [eax + field_34]              # 00505d34
    fstp dword ptr [eax + field_34]              # 00505d37
    fld st(1)                                    # 00505d3a
    fsub st, st(1)                               # 00505d3c
    fmul dword ptr [0x52e638]                    # 00505d3e
    fstp dword ptr [eax + field_10]              # 00505d44
    fadd st, st(1)                               # 00505d47
    fmul dword ptr [0x52e638]                    # 00505d49
    fstp dword ptr [eax + field_14]              # 00505d4f
    fstp st(0)                                   # 00505d52
    fld dword ptr [eax + field_38]               # 00505d54
    fsub dword ptr [eax + field_18]              # 00505d57
    fld dword ptr [eax + field_3c]               # 00505d5a
    fsub dword ptr [eax + field_1c]              # 00505d5d
    fstp dword ptr [esp + stk_c]                 # 00505d60
    fld dword ptr [eax + field_38]               # 00505d64
    fadd dword ptr [eax + field_18]              # 00505d67
    fstp dword ptr [eax + field_38]              # 00505d6a
    fld dword ptr [eax + field_1c]               # 00505d6d
    fadd dword ptr [eax + field_3c]              # 00505d70
    fstp dword ptr [eax + field_3c]              # 00505d73
    fld st(0)                                    # 00505d76
    fadd dword ptr [eax + field_8]               # 00505d78
    fstp dword ptr [esp + stk_4]                 # 00505d7b
    fsub dword ptr [eax + field_8]               # 00505d7f
    fld dword ptr [eax]                          # 00505d82
    fadd dword ptr [eax + field_10]              # 00505d84
    fld dword ptr [eax + field_10]               # 00505d87
    fsub dword ptr [eax]                         # 00505d8a
    {disp8} fstp dword ptr [esp]                 # 00505d8c
    fld st(0)                                    # 00505d90
    fadd dword ptr [esp + stk_4]                 # 00505d92
    fstp dword ptr [eax + field_18]              # 00505d96
    fld dword ptr [esp + stk_4]                  # 00505d99
    fsub st, st(1)                               # 00505d9d
    lea ecx, [eax + field_60]                    # 00505d9f
    fstp dword ptr [eax + field_10]              # 00505da2
    fstp st(0)                                   # 00505da5
    fld dword ptr [eax + field_14]               # 00505da7
    fsub dword ptr [eax + field_4]               # 00505daa
    fld dword ptr [esp + stk_c]                  # 00505dad
    fsub dword ptr [eax + field_c]               # 00505db1
    fstp dword ptr [esp + stk_4]                 # 00505db4
    fld st(1)                                    # 00505db8
    fadd st, st(1)                               # 00505dba
    fstp dword ptr [eax]                         # 00505dbc
    fxch st(1)                                   # 00505dbe
    fsub st, st(1)                               # 00505dc0
    fstp dword ptr [eax + field_8]               # 00505dc2
    fstp st(0)                                   # 00505dc5
    fld dword ptr [eax + field_14]               # 00505dc7
    fadd dword ptr [eax + field_4]               # 00505dca
    fld dword ptr [esp + stk_c]                  # 00505dcd
    fadd dword ptr [eax + field_c]               # 00505dd1
    {disp8} fld dword ptr [esp]                  # 00505dd4
    fadd dword ptr [esp + stk_4]                 # 00505dd8
    fstp dword ptr [eax + field_c]               # 00505ddc
    fld dword ptr [esp + stk_4]                  # 00505ddf
    {disp8} fsub dword ptr [esp]                 # 00505de3
    fstp dword ptr [eax + field_4]               # 00505de7
    fld st(0)                                    # 00505dea
    fadd st, st(2)                               # 00505dec
    fstp dword ptr [eax + field_1c]              # 00505dee
    fsub st, st(1)                               # 00505df1
    fstp dword ptr [eax + field_14]              # 00505df3
    fstp st(0)                                   # 00505df6
    fld dword ptr [eax + field_28]               # 00505df8
    fadd dword ptr [eax + field_38]              # 00505dfb
    fld dword ptr [eax + field_38]               # 00505dfe
    fsub dword ptr [eax + field_28]              # 00505e01
    fstp dword ptr [esp + stk_c]                 # 00505e04
    fld dword ptr [eax + field_20]               # 00505e08
    fadd dword ptr [eax + field_30]              # 00505e0b
    fld dword ptr [eax + field_30]               # 00505e0e
    fsub dword ptr [eax + field_20]              # 00505e11
    {disp8} fstp dword ptr [esp]                 # 00505e14
    fld st(0)                                    # 00505e18
    fadd st, st(2)                               # 00505e1a
    fstp dword ptr [eax + field_38]              # 00505e1c
    fxch st(1)                                   # 00505e1f
    fsub st, st(1)                               # 00505e21
    fstp dword ptr [eax + field_30]              # 00505e23
    fstp st(0)                                   # 00505e26
    fld dword ptr [eax + field_34]               # 00505e28
    fsub dword ptr [eax + field_24]              # 00505e2b
    fld dword ptr [eax + field_3c]               # 00505e2e
    fsub dword ptr [eax + field_2c]              # 00505e31
    fstp dword ptr [esp + stk_4]                 # 00505e34
    fld dword ptr [esp + stk_c]                  # 00505e38
    fadd st, st(1)                               # 00505e3c
    fstp dword ptr [eax + field_20]              # 00505e3e
    fld dword ptr [esp + stk_c]                  # 00505e41
    fsub st, st(1)                               # 00505e45
    fstp dword ptr [eax + field_28]              # 00505e47
    fstp st(0)                                   # 00505e4a
    fld dword ptr [eax + field_24]               # 00505e4c
    fadd dword ptr [eax + field_34]              # 00505e4f
    fld dword ptr [eax + field_2c]               # 00505e52
    fadd dword ptr [eax + field_3c]              # 00505e55
    {disp8} fld dword ptr [esp]                  # 00505e58
    fadd dword ptr [esp + stk_4]                 # 00505e5c
    fstp dword ptr [eax + field_2c]              # 00505e60
    fld dword ptr [esp + stk_4]                  # 00505e63
    {disp8} fsub dword ptr [esp]                 # 00505e67
    fstp dword ptr [eax + field_24]              # 00505e6b
    fld st(0)                                    # 00505e6e
    fadd st, st(2)                               # 00505e70
    fstp dword ptr [eax + field_3c]              # 00505e72
    fsub st, st(1)                               # 00505e75
    fstp dword ptr [eax + field_34]              # 00505e77
    fstp st(0)                                   # 00505e7a
    fld dword ptr [eax + field_44]               # 00505e7c
    fsub dword ptr [eax + field_64]              # 00505e7f
    fld dword ptr [eax + field_40]               # 00505e82
    fsub dword ptr [ecx]                         # 00505e85
    fld dword ptr [eax + field_40]               # 00505e87
    fadd dword ptr [ecx]                         # 00505e8a
    fstp dword ptr [ecx]                         # 00505e8c
    fld dword ptr [eax + field_64]               # 00505e8e
    fadd dword ptr [eax + field_44]              # 00505e91
    fstp dword ptr [eax + field_64]              # 00505e94
    fld st(0)                                    # 00505e97
    fadd st, st(2)                               # 00505e99
    fmul dword ptr [0x52e638]                    # 00505e9b
    fstp dword ptr [eax + field_40]              # 00505ea1
    fxch st(1)                                   # 00505ea4
    fsub st, st(1)                               # 00505ea6
    fmul dword ptr [0x52e638]                    # 00505ea8
    fstp dword ptr [eax + field_44]              # 00505eae
    fstp st(0)                                   # 00505eb1
    fld dword ptr [eax + field_4c]               # 00505eb3
    fsub dword ptr [eax + field_6c]              # 00505eb6
    fld dword ptr [eax + field_68]               # 00505eb9
    fsub dword ptr [eax + field_48]              # 00505ebc
    fstp dword ptr [esp + stk_c]                 # 00505ebf
    fld dword ptr [eax + field_48]               # 00505ec3
    fadd dword ptr [eax + field_68]              # 00505ec6
    mov edx, dword ptr [esp + stk_c]             # 00505ec9
    fstp dword ptr [eax + field_68]              # 00505ecd
    fld dword ptr [eax + field_6c]               # 00505ed0
    fadd dword ptr [eax + field_4c]              # 00505ed3
    mov dword ptr [eax + field_4c], edx          # 00505ed6
    fstp dword ptr [eax + field_6c]              # 00505ed9
    fstp dword ptr [eax + field_48]              # 00505edc
    fld dword ptr [eax + field_70]               # 00505edf
    fsub dword ptr [eax + field_50]              # 00505ee2
    fld dword ptr [eax + field_74]               # 00505ee5
    fsub dword ptr [eax + field_54]              # 00505ee8
    fld dword ptr [eax + field_50]               # 00505eeb
    fadd dword ptr [eax + field_70]              # 00505eee
    fstp dword ptr [eax + field_70]              # 00505ef1
    fld dword ptr [eax + field_54]               # 00505ef4
    fadd dword ptr [eax + field_74]              # 00505ef7
    fstp dword ptr [eax + field_74]              # 00505efa
    fld st(1)                                    # 00505efd
    fsub st, st(1)                               # 00505eff
    fmul dword ptr [0x52e638]                    # 00505f01
    fstp dword ptr [eax + field_50]              # 00505f07
    fadd st, st(1)                               # 00505f0a
    fmul dword ptr [0x52e638]                    # 00505f0c
    fstp dword ptr [eax + field_54]              # 00505f12
    fstp st(0)                                   # 00505f15
    fld dword ptr [eax + field_78]               # 00505f17
    fsub dword ptr [eax + field_58]              # 00505f1a
    fld dword ptr [eax + field_7c]               # 00505f1d
    fsub dword ptr [eax + field_5c]              # 00505f20
    fstp dword ptr [esp + stk_c]                 # 00505f23
    fld dword ptr [eax + field_58]               # 00505f27
    fadd dword ptr [eax + field_78]              # 00505f2a
    fstp dword ptr [eax + field_78]              # 00505f2d
    fld dword ptr [eax + field_5c]               # 00505f30
    fadd dword ptr [eax + field_7c]              # 00505f33
    fstp dword ptr [eax + field_7c]              # 00505f36
    fld st(0)                                    # 00505f39
    fadd dword ptr [eax + field_48]              # 00505f3b
    fstp dword ptr [esp + stk_4]                 # 00505f3e
    fsub dword ptr [eax + field_48]              # 00505f42
    fld dword ptr [eax + field_50]               # 00505f45
    fadd dword ptr [eax + field_40]              # 00505f48
    fld dword ptr [eax + field_50]               # 00505f4b
    fsub dword ptr [eax + field_40]              # 00505f4e
    {disp8} fstp dword ptr [esp]                 # 00505f51
    fld st(0)                                    # 00505f55
    fadd dword ptr [esp + stk_4]                 # 00505f57
    fstp dword ptr [eax + field_58]              # 00505f5b
    fld dword ptr [esp + stk_4]                  # 00505f5e
    fsub st, st(1)                               # 00505f62
    push ecx                                     # 00505f64
    fstp dword ptr [eax + field_50]              # 00505f65
    fstp st(0)                                   # 00505f68
    fld dword ptr [eax + field_54]               # 00505f6a
    fsub dword ptr [eax + field_44]              # 00505f6d
    fld dword ptr [esp + stk_10]                 # 00505f70
    fsub dword ptr [eax + field_4c]              # 00505f74
    fstp dword ptr [esp + stk_8]                 # 00505f77
    fld st(1)                                    # 00505f7b
    fadd st, st(1)                               # 00505f7d
    fstp dword ptr [eax + field_40]              # 00505f7f
    fxch st(1)                                   # 00505f82
    fsub st, st(1)                               # 00505f84
    fstp dword ptr [eax + field_48]              # 00505f86
    fstp st(0)                                   # 00505f89
    fld dword ptr [eax + field_44]               # 00505f8b
    fadd dword ptr [eax + field_54]              # 00505f8e
    fld dword ptr [esp + stk_10]                 # 00505f91
    fadd dword ptr [eax + field_4c]              # 00505f95
    fld dword ptr [esp + stk_4]                  # 00505f98
    fadd dword ptr [esp + stk_8]                 # 00505f9c
    fstp dword ptr [eax + field_4c]              # 00505fa0
    fld dword ptr [esp + stk_8]                  # 00505fa3
    fsub dword ptr [esp + stk_4]                 # 00505fa7
    fstp dword ptr [eax + field_44]              # 00505fab
    fld st(0)                                    # 00505fae
    fadd st, st(2)                               # 00505fb0
    fstp dword ptr [eax + field_5c]              # 00505fb2
    fsub st, st(1)                               # 00505fb5
    fstp dword ptr [eax + field_54]              # 00505fb7
    fstp st(0)                                   # 00505fba
    call FUN_00505fd0                            # 00505fbc
    add esp, 0xc                                 # 00505fc1
    ret                                          # 00505fc4

# --- data items (not part of the function) -------------------------
.org 0x00505fc5 - 0x401000
PAD_00505fc5:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

