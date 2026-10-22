# FUN_00405b72
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00405b72
# extent:       0x00405b72-0x00406739 (3015 code bytes)
# span:         0x00405b72-0x00406739 (code 3015, tables 0, padding 0)
# sha256:       88b97807c10f39a2edd3b79e6abbbd35ed53c9321845aa12a771e97e88521b4d
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m405b72_lifted
# naming:       native port src/original_methods_fl40.c:m405b72_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 673/673 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_8c, field_ddc; [edx + n] field_1c
# callees:      calls FUN_0051e3c8, FUN_0050ca3e, FUN_0051d4c4, FUN_00404b49, FUN_0051d462, USER32.dll!SendMessageA, FUN_00404be1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m405b72_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 673 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_8c, 0x8c  # offset +0x8c
.equ field_ddc, 0xddc  # offset +0xddc

# --- external targets -----------------------------------------------
.set FUN_00404b49, .text + (0x00404b49 - 0x401000)
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051d462, .text + (0x0051d462 - 0x401000)
.set FUN_0051d4c4, .text + (0x0051d4c4 - 0x401000)
.set FUN_0051e3c8, .text + (0x0051e3c8 - 0x401000)

.org 0x00405b72 - 0x401000
.globl FUN_00405b72
FUN_00405b72:
    # block 0x00405b72: entry, 647 instruction(s), calls FUN_0051e3c8, FUN_0050ca3e, FUN_0051d4c4, FUN_00404b49, FUN_0051d462, ends with forward jump to 0x004066ef
    push ebp                                     # 00405b72
    {load} mov ebp, esp                          # 00405b73
    sub esp, 0x10                                # 00405b75
    mov dword ptr [ebp - local_10], ecx          # 00405b78
    mov ecx, dword ptr [ebp - local_10]          # 00405b7b
    call FUN_0051e3c8                            # 00405b7e
    push 0x571b90                                # 00405b83
    push 0x53e934                                # 00405b88
    push 0x63888b                                # 00405b8d
    call FUN_0050ca3e                            # 00405b92
    add esp, 0xc                                 # 00405b97
    push 0x63888b                                # 00405b9a
    push 0x3e9                                   # 00405b9f
    mov ecx, dword ptr [ebp - local_10]          # 00405ba4
    call FUN_0051d4c4                            # 00405ba7
    push 0x571cfd                                # 00405bac
    push 0x53e93c                                # 00405bb1
    push 0x63888b                                # 00405bb6
    call FUN_0050ca3e                            # 00405bbb
    add esp, 0xc                                 # 00405bc0
    push 0x63888b                                # 00405bc3
    push 0x3ea                                   # 00405bc8
    mov ecx, dword ptr [ebp - local_10]          # 00405bcd
    call FUN_0051d4c4                            # 00405bd0
    push 0x571e6a                                # 00405bd5
    push 0x53e944                                # 00405bda
    push 0x63888b                                # 00405bdf
    call FUN_0050ca3e                            # 00405be4
    add esp, 0xc                                 # 00405be9
    push 0x63888b                                # 00405bec
    push 0x3eb                                   # 00405bf1
    mov ecx, dword ptr [ebp - local_10]          # 00405bf6
    call FUN_0051d4c4                            # 00405bf9
    push 0x571fd7                                # 00405bfe
    push 0x53e94c                                # 00405c03
    push 0x63888b                                # 00405c08
    call FUN_0050ca3e                            # 00405c0d
    add esp, 0xc                                 # 00405c12
    push 0x63888b                                # 00405c15
    push 0x3ec                                   # 00405c1a
    mov ecx, dword ptr [ebp - local_10]          # 00405c1f
    call FUN_0051d4c4                            # 00405c22
    push 0x572144                                # 00405c27
    push 0x53e954                                # 00405c2c
    push 0x63888b                                # 00405c31
    call FUN_0050ca3e                            # 00405c36
    add esp, 0xc                                 # 00405c3b
    push 0x63888b                                # 00405c3e
    push 0x3ed                                   # 00405c43
    mov ecx, dword ptr [ebp - local_10]          # 00405c48
    call FUN_0051d4c4                            # 00405c4b
    push 0x5722b1                                # 00405c50
    push 0x53e95c                                # 00405c55
    push 0x63888b                                # 00405c5a
    call FUN_0050ca3e                            # 00405c5f
    add esp, 0xc                                 # 00405c64
    push 0x63888b                                # 00405c67
    push 0x3ee                                   # 00405c6c
    mov ecx, dword ptr [ebp - local_10]          # 00405c71
    call FUN_0051d4c4                            # 00405c74
    push 0x57241e                                # 00405c79
    push 0x53e964                                # 00405c7e
    push 0x63888b                                # 00405c83
    call FUN_0050ca3e                            # 00405c88
    add esp, 0xc                                 # 00405c8d
    push 0x63888b                                # 00405c90
    push 0x3ef                                   # 00405c95
    mov ecx, dword ptr [ebp - local_10]          # 00405c9a
    call FUN_0051d4c4                            # 00405c9d
    push 0x57258b                                # 00405ca2
    push 0x53e96c                                # 00405ca7
    push 0x63888b                                # 00405cac
    call FUN_0050ca3e                            # 00405cb1
    add esp, 0xc                                 # 00405cb6
    push 0x63888b                                # 00405cb9
    push 0x3f0                                   # 00405cbe
    mov ecx, dword ptr [ebp - local_10]          # 00405cc3
    call FUN_0051d4c4                            # 00405cc6
    push 0x5726f8                                # 00405ccb
    push 0x53e974                                # 00405cd0
    push 0x63888b                                # 00405cd5
    call FUN_0050ca3e                            # 00405cda
    add esp, 0xc                                 # 00405cdf
    push 0x63888b                                # 00405ce2
    push 0x3f1                                   # 00405ce7
    mov ecx, dword ptr [ebp - local_10]          # 00405cec
    call FUN_0051d4c4                            # 00405cef
    push 0x572865                                # 00405cf4
    push 0x53e97c                                # 00405cf9
    push 0x63888b                                # 00405cfe
    call FUN_0050ca3e                            # 00405d03
    add esp, 0xc                                 # 00405d08
    push 0x63888b                                # 00405d0b
    push 0x3f2                                   # 00405d10
    mov ecx, dword ptr [ebp - local_10]          # 00405d15
    call FUN_0051d4c4                            # 00405d18
    push 0x5729d2                                # 00405d1d
    push 0x53e984                                # 00405d22
    push 0x63888b                                # 00405d27
    call FUN_0050ca3e                            # 00405d2c
    add esp, 0xc                                 # 00405d31
    push 0x63888b                                # 00405d34
    push 0x3f3                                   # 00405d39
    mov ecx, dword ptr [ebp - local_10]          # 00405d3e
    call FUN_0051d4c4                            # 00405d41
    push 0x572b3f                                # 00405d46
    push 0x53e98c                                # 00405d4b
    push 0x63888b                                # 00405d50
    call FUN_0050ca3e                            # 00405d55
    add esp, 0xc                                 # 00405d5a
    push 0x63888b                                # 00405d5d
    push 0x3f4                                   # 00405d62
    mov ecx, dword ptr [ebp - local_10]          # 00405d67
    call FUN_0051d4c4                            # 00405d6a
    push 0x572cac                                # 00405d6f
    push 0x53e994                                # 00405d74
    push 0x63888b                                # 00405d79
    call FUN_0050ca3e                            # 00405d7e
    add esp, 0xc                                 # 00405d83
    push 0x63888b                                # 00405d86
    push 0x3f5                                   # 00405d8b
    mov ecx, dword ptr [ebp - local_10]          # 00405d90
    call FUN_0051d4c4                            # 00405d93
    push 0x572e19                                # 00405d98
    push 0x53e99c                                # 00405d9d
    push 0x63888b                                # 00405da2
    call FUN_0050ca3e                            # 00405da7
    add esp, 0xc                                 # 00405dac
    push 0x63888b                                # 00405daf
    push 0x3f6                                   # 00405db4
    mov ecx, dword ptr [ebp - local_10]          # 00405db9
    call FUN_0051d4c4                            # 00405dbc
    push 0x572f86                                # 00405dc1
    push 0x53e9a4                                # 00405dc6
    push 0x63888b                                # 00405dcb
    call FUN_0050ca3e                            # 00405dd0
    add esp, 0xc                                 # 00405dd5
    push 0x63888b                                # 00405dd8
    push 0x3f7                                   # 00405ddd
    mov ecx, dword ptr [ebp - local_10]          # 00405de2
    call FUN_0051d4c4                            # 00405de5
    push 0x5730f3                                # 00405dea
    push 0x53e9ac                                # 00405def
    push 0x63888b                                # 00405df4
    call FUN_0050ca3e                            # 00405df9
    add esp, 0xc                                 # 00405dfe
    push 0x63888b                                # 00405e01
    push 0x3f8                                   # 00405e06
    mov ecx, dword ptr [ebp - local_10]          # 00405e0b
    call FUN_0051d4c4                            # 00405e0e
    push 0x573260                                # 00405e13
    push 0x53e9b4                                # 00405e18
    push 0x63888b                                # 00405e1d
    call FUN_0050ca3e                            # 00405e22
    add esp, 0xc                                 # 00405e27
    push 0x63888b                                # 00405e2a
    push 0x3f9                                   # 00405e2f
    mov ecx, dword ptr [ebp - local_10]          # 00405e34
    call FUN_0051d4c4                            # 00405e37
    push 0x5733cd                                # 00405e3c
    push 0x53e9bc                                # 00405e41
    push 0x63888b                                # 00405e46
    call FUN_0050ca3e                            # 00405e4b
    add esp, 0xc                                 # 00405e50
    push 0x63888b                                # 00405e53
    push 0x3fa                                   # 00405e58
    mov ecx, dword ptr [ebp - local_10]          # 00405e5d
    call FUN_0051d4c4                            # 00405e60
    push 0x57353a                                # 00405e65
    push 0x53e9c4                                # 00405e6a
    push 0x63888b                                # 00405e6f
    call FUN_0050ca3e                            # 00405e74
    add esp, 0xc                                 # 00405e79
    push 0x63888b                                # 00405e7c
    push 0x3fb                                   # 00405e81
    mov ecx, dword ptr [ebp - local_10]          # 00405e86
    call FUN_0051d4c4                            # 00405e89
    push 0x5736a7                                # 00405e8e
    push 0x53e9cc                                # 00405e93
    push 0x63888b                                # 00405e98
    call FUN_0050ca3e                            # 00405e9d
    add esp, 0xc                                 # 00405ea2
    push 0x63888b                                # 00405ea5
    push 0x3fc                                   # 00405eaa
    mov ecx, dword ptr [ebp - local_10]          # 00405eaf
    call FUN_0051d4c4                            # 00405eb2
    push 0x573814                                # 00405eb7
    push 0x53e9d4                                # 00405ebc
    push 0x63888b                                # 00405ec1
    call FUN_0050ca3e                            # 00405ec6
    add esp, 0xc                                 # 00405ecb
    push 0x63888b                                # 00405ece
    push 0x3fd                                   # 00405ed3
    mov ecx, dword ptr [ebp - local_10]          # 00405ed8
    call FUN_0051d4c4                            # 00405edb
    push 0x573981                                # 00405ee0
    push 0x53e9dc                                # 00405ee5
    push 0x63888b                                # 00405eea
    call FUN_0050ca3e                            # 00405eef
    add esp, 0xc                                 # 00405ef4
    push 0x63888b                                # 00405ef7
    push 0x3fe                                   # 00405efc
    mov ecx, dword ptr [ebp - local_10]          # 00405f01
    call FUN_0051d4c4                            # 00405f04
    push 0x573aee                                # 00405f09
    push 0x53e9e4                                # 00405f0e
    push 0x63888b                                # 00405f13
    call FUN_0050ca3e                            # 00405f18
    add esp, 0xc                                 # 00405f1d
    push 0x63888b                                # 00405f20
    push 0x3ff                                   # 00405f25
    mov ecx, dword ptr [ebp - local_10]          # 00405f2a
    call FUN_0051d4c4                            # 00405f2d
    push 0x573c5b                                # 00405f32
    push 0x53e9ec                                # 00405f37
    push 0x63888b                                # 00405f3c
    call FUN_0050ca3e                            # 00405f41
    add esp, 0xc                                 # 00405f46
    push 0x63888b                                # 00405f49
    push 0x400                                   # 00405f4e
    mov ecx, dword ptr [ebp - local_10]          # 00405f53
    call FUN_0051d4c4                            # 00405f56
    push 0x573dc8                                # 00405f5b
    push 0x53e9f4                                # 00405f60
    push 0x63888b                                # 00405f65
    call FUN_0050ca3e                            # 00405f6a
    add esp, 0xc                                 # 00405f6f
    push 0x63888b                                # 00405f72
    push 0x401                                   # 00405f77
    mov ecx, dword ptr [ebp - local_10]          # 00405f7c
    call FUN_0051d4c4                            # 00405f7f
    push 0x573f35                                # 00405f84
    push 0x53e9fc                                # 00405f89
    push 0x63888b                                # 00405f8e
    call FUN_0050ca3e                            # 00405f93
    add esp, 0xc                                 # 00405f98
    push 0x63888b                                # 00405f9b
    push 0x402                                   # 00405fa0
    mov ecx, dword ptr [ebp - local_10]          # 00405fa5
    call FUN_0051d4c4                            # 00405fa8
    push 0x5740a2                                # 00405fad
    push 0x53ea04                                # 00405fb2
    push 0x63888b                                # 00405fb7
    call FUN_0050ca3e                            # 00405fbc
    add esp, 0xc                                 # 00405fc1
    push 0x63888b                                # 00405fc4
    push 0x403                                   # 00405fc9
    mov ecx, dword ptr [ebp - local_10]          # 00405fce
    call FUN_0051d4c4                            # 00405fd1
    push 0x57420f                                # 00405fd6
    push 0x53ea0c                                # 00405fdb
    push 0x63888b                                # 00405fe0
    call FUN_0050ca3e                            # 00405fe5
    add esp, 0xc                                 # 00405fea
    push 0x63888b                                # 00405fed
    push 0x404                                   # 00405ff2
    mov ecx, dword ptr [ebp - local_10]          # 00405ff7
    call FUN_0051d4c4                            # 00405ffa
    push 0x57437c                                # 00405fff
    push 0x53ea14                                # 00406004
    push 0x63888b                                # 00406009
    call FUN_0050ca3e                            # 0040600e
    add esp, 0xc                                 # 00406013
    push 0x63888b                                # 00406016
    push 0x405                                   # 0040601b
    mov ecx, dword ptr [ebp - local_10]          # 00406020
    call FUN_0051d4c4                            # 00406023
    push 0x5744e9                                # 00406028
    push 0x53ea1c                                # 0040602d
    push 0x63888b                                # 00406032
    call FUN_0050ca3e                            # 00406037
    add esp, 0xc                                 # 0040603c
    push 0x63888b                                # 0040603f
    push 0x406                                   # 00406044
    mov ecx, dword ptr [ebp - local_10]          # 00406049
    call FUN_0051d4c4                            # 0040604c
    push 0x574656                                # 00406051
    push 0x53ea24                                # 00406056
    push 0x63888b                                # 0040605b
    call FUN_0050ca3e                            # 00406060
    add esp, 0xc                                 # 00406065
    push 0x63888b                                # 00406068
    push 0x407                                   # 0040606d
    mov ecx, dword ptr [ebp - local_10]          # 00406072
    call FUN_0051d4c4                            # 00406075
    push 0x5747c3                                # 0040607a
    push 0x53ea2c                                # 0040607f
    push 0x63888b                                # 00406084
    call FUN_0050ca3e                            # 00406089
    add esp, 0xc                                 # 0040608e
    push 0x63888b                                # 00406091
    push 0x408                                   # 00406096
    mov ecx, dword ptr [ebp - local_10]          # 0040609b
    call FUN_0051d4c4                            # 0040609e
    push 0x574930                                # 004060a3
    push 0x53ea34                                # 004060a8
    push 0x63888b                                # 004060ad
    call FUN_0050ca3e                            # 004060b2
    add esp, 0xc                                 # 004060b7
    push 0x63888b                                # 004060ba
    push 0x409                                   # 004060bf
    mov ecx, dword ptr [ebp - local_10]          # 004060c4
    call FUN_0051d4c4                            # 004060c7
    push 0x574a9d                                # 004060cc
    push 0x53ea3c                                # 004060d1
    push 0x63888b                                # 004060d6
    call FUN_0050ca3e                            # 004060db
    add esp, 0xc                                 # 004060e0
    push 0x63888b                                # 004060e3
    push 0x40b                                   # 004060e8
    mov ecx, dword ptr [ebp - local_10]          # 004060ed
    call FUN_0051d4c4                            # 004060f0
    push 0x574c0a                                # 004060f5
    push 0x53ea44                                # 004060fa
    push 0x63888b                                # 004060ff
    call FUN_0050ca3e                            # 00406104
    add esp, 0xc                                 # 00406109
    push 0x63888b                                # 0040610c
    push 0x40c                                   # 00406111
    mov ecx, dword ptr [ebp - local_10]          # 00406116
    call FUN_0051d4c4                            # 00406119
    push 0x574d77                                # 0040611e
    push 0x53ea4c                                # 00406123
    push 0x63888b                                # 00406128
    call FUN_0050ca3e                            # 0040612d
    add esp, 0xc                                 # 00406132
    push 0x63888b                                # 00406135
    push 0x40e                                   # 0040613a
    mov ecx, dword ptr [ebp - local_10]          # 0040613f
    call FUN_0051d4c4                            # 00406142
    push 0x574ee4                                # 00406147
    push 0x53ea54                                # 0040614c
    push 0x63888b                                # 00406151
    call FUN_0050ca3e                            # 00406156
    add esp, 0xc                                 # 0040615b
    push 0x63888b                                # 0040615e
    push 0x40d                                   # 00406163
    mov ecx, dword ptr [ebp - local_10]          # 00406168
    call FUN_0051d4c4                            # 0040616b
    push 0x575051                                # 00406170
    push 0x53ea5c                                # 00406175
    push 0x63888b                                # 0040617a
    call FUN_0050ca3e                            # 0040617f
    add esp, 0xc                                 # 00406184
    push 0x63888b                                # 00406187
    push 0x40f                                   # 0040618c
    mov ecx, dword ptr [ebp - local_10]          # 00406191
    call FUN_0051d4c4                            # 00406194
    push 0x5751be                                # 00406199
    push 0x53ea64                                # 0040619e
    push 0x63888b                                # 004061a3
    call FUN_0050ca3e                            # 004061a8
    add esp, 0xc                                 # 004061ad
    push 0x63888b                                # 004061b0
    push 0x410                                   # 004061b5
    mov ecx, dword ptr [ebp - local_10]          # 004061ba
    call FUN_0051d4c4                            # 004061bd
    push 0x57532b                                # 004061c2
    push 0x53ea6c                                # 004061c7
    push 0x63888b                                # 004061cc
    call FUN_0050ca3e                            # 004061d1
    add esp, 0xc                                 # 004061d6
    push 0x63888b                                # 004061d9
    push 0x411                                   # 004061de
    mov ecx, dword ptr [ebp - local_10]          # 004061e3
    call FUN_0051d4c4                            # 004061e6
    push 0x575498                                # 004061eb
    push 0x53ea74                                # 004061f0
    push 0x63888b                                # 004061f5
    call FUN_0050ca3e                            # 004061fa
    add esp, 0xc                                 # 004061ff
    push 0x63888b                                # 00406202
    push 0x412                                   # 00406207
    mov ecx, dword ptr [ebp - local_10]          # 0040620c
    call FUN_0051d4c4                            # 0040620f
    push 0x575605                                # 00406214
    push 0x53ea7c                                # 00406219
    push 0x63888b                                # 0040621e
    call FUN_0050ca3e                            # 00406223
    add esp, 0xc                                 # 00406228
    push 0x63888b                                # 0040622b
    push 0x413                                   # 00406230
    mov ecx, dword ptr [ebp - local_10]          # 00406235
    call FUN_0051d4c4                            # 00406238
    push 0x575772                                # 0040623d
    push 0x53ea84                                # 00406242
    push 0x63888b                                # 00406247
    call FUN_0050ca3e                            # 0040624c
    add esp, 0xc                                 # 00406251
    push 0x63888b                                # 00406254
    push 0x414                                   # 00406259
    mov ecx, dword ptr [ebp - local_10]          # 0040625e
    call FUN_0051d4c4                            # 00406261
    push 0x5758df                                # 00406266
    push 0x53ea8c                                # 0040626b
    push 0x63888b                                # 00406270
    call FUN_0050ca3e                            # 00406275
    add esp, 0xc                                 # 0040627a
    push 0x63888b                                # 0040627d
    push 0x415                                   # 00406282
    mov ecx, dword ptr [ebp - local_10]          # 00406287
    call FUN_0051d4c4                            # 0040628a
    push 0x575a4c                                # 0040628f
    push 0x53ea94                                # 00406294
    push 0x63888b                                # 00406299
    call FUN_0050ca3e                            # 0040629e
    add esp, 0xc                                 # 004062a3
    push 0x63888b                                # 004062a6
    push 0x416                                   # 004062ab
    mov ecx, dword ptr [ebp - local_10]          # 004062b0
    call FUN_0051d4c4                            # 004062b3
    push 0x575bb9                                # 004062b8
    push 0x53ea9c                                # 004062bd
    push 0x63888b                                # 004062c2
    call FUN_0050ca3e                            # 004062c7
    add esp, 0xc                                 # 004062cc
    push 0x63888b                                # 004062cf
    push 0x417                                   # 004062d4
    mov ecx, dword ptr [ebp - local_10]          # 004062d9
    call FUN_0051d4c4                            # 004062dc
    push 0x575d26                                # 004062e1
    push 0x53eaa4                                # 004062e6
    push 0x63888b                                # 004062eb
    call FUN_0050ca3e                            # 004062f0
    add esp, 0xc                                 # 004062f5
    push 0x63888b                                # 004062f8
    push 0x418                                   # 004062fd
    mov ecx, dword ptr [ebp - local_10]          # 00406302
    call FUN_0051d4c4                            # 00406305
    push 0x575e93                                # 0040630a
    push 0x53eaac                                # 0040630f
    push 0x63888b                                # 00406314
    call FUN_0050ca3e                            # 00406319
    add esp, 0xc                                 # 0040631e
    push 0x63888b                                # 00406321
    push 0x419                                   # 00406326
    mov ecx, dword ptr [ebp - local_10]          # 0040632b
    call FUN_0051d4c4                            # 0040632e
    push 0x576000                                # 00406333
    push 0x53eab4                                # 00406338
    push 0x63888b                                # 0040633d
    call FUN_0050ca3e                            # 00406342
    add esp, 0xc                                 # 00406347
    push 0x63888b                                # 0040634a
    push 0x41a                                   # 0040634f
    mov ecx, dword ptr [ebp - local_10]          # 00406354
    call FUN_0051d4c4                            # 00406357
    push 0x57616d                                # 0040635c
    push 0x53eabc                                # 00406361
    push 0x63888b                                # 00406366
    call FUN_0050ca3e                            # 0040636b
    add esp, 0xc                                 # 00406370
    push 0x63888b                                # 00406373
    push 0x41b                                   # 00406378
    mov ecx, dword ptr [ebp - local_10]          # 0040637d
    call FUN_0051d4c4                            # 00406380
    push 0x5762da                                # 00406385
    push 0x53eac4                                # 0040638a
    push 0x63888b                                # 0040638f
    call FUN_0050ca3e                            # 00406394
    add esp, 0xc                                 # 00406399
    push 0x63888b                                # 0040639c
    push 0x425                                   # 004063a1
    mov ecx, dword ptr [ebp - local_10]          # 004063a6
    call FUN_0051d4c4                            # 004063a9
    push 0x576447                                # 004063ae
    push 0x53eacc                                # 004063b3
    push 0x63888b                                # 004063b8
    call FUN_0050ca3e                            # 004063bd
    add esp, 0xc                                 # 004063c2
    push 0x63888b                                # 004063c5
    push 0x426                                   # 004063ca
    mov ecx, dword ptr [ebp - local_10]          # 004063cf
    call FUN_0051d4c4                            # 004063d2
    push 0x5765b4                                # 004063d7
    push 0x53ead4                                # 004063dc
    push 0x63888b                                # 004063e1
    call FUN_0050ca3e                            # 004063e6
    add esp, 0xc                                 # 004063eb
    push 0x63888b                                # 004063ee
    push 0x427                                   # 004063f3
    mov ecx, dword ptr [ebp - local_10]          # 004063f8
    call FUN_0051d4c4                            # 004063fb
    push 0x576721                                # 00406400
    push 0x53eadc                                # 00406405
    push 0x63888b                                # 0040640a
    call FUN_0050ca3e                            # 0040640f
    add esp, 0xc                                 # 00406414
    push 0x63888b                                # 00406417
    push 0x428                                   # 0040641c
    mov ecx, dword ptr [ebp - local_10]          # 00406421
    call FUN_0051d4c4                            # 00406424
    push 0x57688e                                # 00406429
    push 0x53eae4                                # 0040642e
    push 0x63888b                                # 00406433
    call FUN_0050ca3e                            # 00406438
    add esp, 0xc                                 # 0040643d
    push 0x63888b                                # 00406440
    push 0x429                                   # 00406445
    mov ecx, dword ptr [ebp - local_10]          # 0040644a
    call FUN_0051d4c4                            # 0040644d
    push 0x5769fb                                # 00406452
    push 0x53eaec                                # 00406457
    push 0x63888b                                # 0040645c
    call FUN_0050ca3e                            # 00406461
    add esp, 0xc                                 # 00406466
    push 0x63888b                                # 00406469
    push 0x42a                                   # 0040646e
    mov ecx, dword ptr [ebp - local_10]          # 00406473
    call FUN_0051d4c4                            # 00406476
    push 0x576b68                                # 0040647b
    push 0x53eaf4                                # 00406480
    push 0x63888b                                # 00406485
    call FUN_0050ca3e                            # 0040648a
    add esp, 0xc                                 # 0040648f
    push 0x63888b                                # 00406492
    push 0x42b                                   # 00406497
    mov ecx, dword ptr [ebp - local_10]          # 0040649c
    call FUN_0051d4c4                            # 0040649f
    push 0x576cd5                                # 004064a4
    push 0x53eafc                                # 004064a9
    push 0x63888b                                # 004064ae
    call FUN_0050ca3e                            # 004064b3
    add esp, 0xc                                 # 004064b8
    push 0x63888b                                # 004064bb
    push 0x42c                                   # 004064c0
    mov ecx, dword ptr [ebp - local_10]          # 004064c5
    call FUN_0051d4c4                            # 004064c8
    push 0x576e42                                # 004064cd
    push 0x53eb04                                # 004064d2
    push 0x63888b                                # 004064d7
    call FUN_0050ca3e                            # 004064dc
    add esp, 0xc                                 # 004064e1
    push 0x63888b                                # 004064e4
    push 0x42d                                   # 004064e9
    mov ecx, dword ptr [ebp - local_10]          # 004064ee
    call FUN_0051d4c4                            # 004064f1
    push 0x576faf                                # 004064f6
    push 0x53eb0c                                # 004064fb
    push 0x63888b                                # 00406500
    call FUN_0050ca3e                            # 00406505
    add esp, 0xc                                 # 0040650a
    push 0x63888b                                # 0040650d
    push 0x42e                                   # 00406512
    mov ecx, dword ptr [ebp - local_10]          # 00406517
    call FUN_0051d4c4                            # 0040651a
    push 0x57711c                                # 0040651f
    push 0x53eb14                                # 00406524
    push 0x63888b                                # 00406529
    call FUN_0050ca3e                            # 0040652e
    add esp, 0xc                                 # 00406533
    push 0x63888b                                # 00406536
    push 0x44d                                   # 0040653b
    mov ecx, dword ptr [ebp - local_10]          # 00406540
    call FUN_0051d4c4                            # 00406543
    push 0x577289                                # 00406548
    push 0x53eb1c                                # 0040654d
    push 0x63888b                                # 00406552
    call FUN_0050ca3e                            # 00406557
    add esp, 0xc                                 # 0040655c
    push 0x63888b                                # 0040655f
    push 0x44e                                   # 00406564
    mov ecx, dword ptr [ebp - local_10]          # 00406569
    call FUN_0051d4c4                            # 0040656c
    push 0x5773f6                                # 00406571
    push 0x53eb24                                # 00406576
    push 0x63888b                                # 0040657b
    call FUN_0050ca3e                            # 00406580
    add esp, 0xc                                 # 00406585
    push 0x63888b                                # 00406588
    push 0x44f                                   # 0040658d
    mov ecx, dword ptr [ebp - local_10]          # 00406592
    call FUN_0051d4c4                            # 00406595
    push 0x577563                                # 0040659a
    push 0x53eb2c                                # 0040659f
    push 0x63888b                                # 004065a4
    call FUN_0050ca3e                            # 004065a9
    add esp, 0xc                                 # 004065ae
    push 0x63888b                                # 004065b1
    push 0x450                                   # 004065b6
    mov ecx, dword ptr [ebp - local_10]          # 004065bb
    call FUN_0051d4c4                            # 004065be
    push 0x5776d0                                # 004065c3
    push 0x53eb34                                # 004065c8
    push 0x63888b                                # 004065cd
    call FUN_0050ca3e                            # 004065d2
    add esp, 0xc                                 # 004065d7
    push 0x63888b                                # 004065da
    push 0x451                                   # 004065df
    mov ecx, dword ptr [ebp - local_10]          # 004065e4
    call FUN_0051d4c4                            # 004065e7
    push 0x57783d                                # 004065ec
    push 0x53eb3c                                # 004065f1
    push 0x63888b                                # 004065f6
    call FUN_0050ca3e                            # 004065fb
    add esp, 0xc                                 # 00406600
    push 0x63888b                                # 00406603
    push 0x452                                   # 00406608
    mov ecx, dword ptr [ebp - local_10]          # 0040660d
    call FUN_0051d4c4                            # 00406610
    push 0x5779aa                                # 00406615
    push 0x53eb44                                # 0040661a
    push 0x63888b                                # 0040661f
    call FUN_0050ca3e                            # 00406624
    add esp, 0xc                                 # 00406629
    push 0x63888b                                # 0040662c
    push 0x453                                   # 00406631
    mov ecx, dword ptr [ebp - local_10]          # 00406636
    call FUN_0051d4c4                            # 00406639
    push 0x577b17                                # 0040663e
    push 0x53eb4c                                # 00406643
    push 0x63888b                                # 00406648
    call FUN_0050ca3e                            # 0040664d
    add esp, 0xc                                 # 00406652
    push 0x63888b                                # 00406655
    push 0x454                                   # 0040665a
    mov ecx, dword ptr [ebp - local_10]          # 0040665f
    call FUN_0051d4c4                            # 00406662
    push 0x577c84                                # 00406667
    push 0x53eb54                                # 0040666c
    push 0x63888b                                # 00406671
    call FUN_0050ca3e                            # 00406676
    add esp, 0xc                                 # 0040667b
    push 0x63888b                                # 0040667e
    push 0x455                                   # 00406683
    mov ecx, dword ptr [ebp - local_10]          # 00406688
    call FUN_0051d4c4                            # 0040668b
    push 0x577df1                                # 00406690
    push 0x53eb5c                                # 00406695
    push 0x63888b                                # 0040669a
    call FUN_0050ca3e                            # 0040669f
    add esp, 0xc                                 # 004066a4
    push 0x63888b                                # 004066a7
    push 0x456                                   # 004066ac
    mov ecx, dword ptr [ebp - local_10]          # 004066b1
    call FUN_0051d4c4                            # 004066b4
    mov ecx, dword ptr [ebp - local_10]          # 004066b9
    call FUN_00404b49                            # 004066bc
    push 0x563                                   # 004066c1
    mov ecx, dword ptr [ebp - local_10]          # 004066c6
    call FUN_0051d462                            # 004066c9
    mov dword ptr [ebp - local_8], eax           # 004066ce
    mov eax, dword ptr [ebp - local_10]          # 004066d1
    mov ecx, dword ptr [ebp - local_8]           # 004066d4
    mov dword ptr [eax + field_ddc], ecx         # 004066d7
    mov dword ptr [ebp - local_4], 0x0           # 004066dd
    jmp.d8 L_004066ef                            # 004066e4
L_004066e6:
    # block 0x004066e6: entered by jmp at 0x00406726, 3 instruction(s), falls into the block at 0x004066ef
    mov edx, dword ptr [ebp - local_4]           # 004066e6
    add edx, 0x1                                 # 004066e9
    mov dword ptr [ebp - local_4], edx           # 004066ec
L_004066ef:
    # block 0x004066ef: entered by jmp at 0x004066e4, 2 instruction(s), ends with jge to 0x00406728 (forward)
    cmp dword ptr [ebp - local_4], 0x47          # 004066ef
    jge.d8 L_00406728                            # 004066f3
    # block 0x004066f5: entered by fall-through of jge at 0x004066f3, 15 instruction(s), calls USER32.dll!SendMessageA, ends with backward jump to 0x004066e6
    mov eax, dword ptr [ebp - local_10]          # 004066f5
    mov ecx, dword ptr [eax + field_ddc]         # 004066f8
    mov dword ptr [ebp - local_c], ecx           # 004066fe
    mov edx, dword ptr [ebp - local_4]           # 00406701
    imul edx, edx, 0x30                          # 00406704
    mov eax, dword ptr [ebp - local_10]          # 00406707
    lea ecx, [eax + edx + field_8c]              # 0040670a
    push ecx                                     # 00406711
    push 0x0                                     # 00406712
    push 0x180                                   # 00406714
    mov edx, dword ptr [ebp - local_c]           # 00406719
    mov eax, dword ptr [edx + field_1c]          # 0040671c
    push eax                                     # 0040671f
    call dword ptr [0x52a4c8]                    # 00406720
    jmp.d8 L_004066e6                            # 00406726
L_00406728:
    # block 0x00406728: entered by jge at 0x004066f3, 6 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_10]          # 00406728
    call FUN_00404be1                            # 0040672b
    mov eax, 0x1                                 # 00406730
    {load} mov esp, ebp                          # 00406735
    pop ebp                                      # 00406737
    ret                                          # 00406738

