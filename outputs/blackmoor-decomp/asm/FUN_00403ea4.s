# FUN_00403ea4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00403ea4
# extent:       0x00403ea4-0x00404186 (738 code bytes)
# span:         0x00403ea4-0x00404186 (code 738, tables 0, padding 0)
# sha256:       8e357101c05d8017be47d5424c5aa20c0d003b0ded87277d8a2443cb65bdede0
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m403ea4_lifted
# naming:       native port src/original_methods_fl40.c:m403ea4_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 6 seeds; oracle 191/191 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 2 more
# fields:       [eax + n] field_498, field_4a4, field_4a8; [ecx + n] field_48c, field_494, field_4a0, field_4ac, field_4b0; [edx + n] field_1c, field_490, field_49c, field_4ac
# callees:      calls FUN_0051e3c8, FUN_0051d3d5, FUN_0051d462, USER32.dll!SendMessageA, KERNEL32.dll!GetTickCount, FUN_004d9302, FUN_004033db
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m403ea4_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 191 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ field_1c, 0x1c  # offset +0x1c
.equ field_48c, 0x48c  # offset +0x48c
.equ field_490, 0x490  # offset +0x490
.equ field_494, 0x494  # offset +0x494
.equ field_498, 0x498  # offset +0x498
.equ field_49c, 0x49c  # offset +0x49c
.equ field_4a0, 0x4a0  # offset +0x4a0
.equ field_4a4, 0x4a4  # offset +0x4a4
.equ field_4a8, 0x4a8  # offset +0x4a8
.equ field_4ac, 0x4ac  # offset +0x4ac
.equ field_4b0, 0x4b0  # offset +0x4b0

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)
.set FUN_004d9302, .text + (0x004d9302 - 0x401000)
.set FUN_0051d3d5, .text + (0x0051d3d5 - 0x401000)
.set FUN_0051d462, .text + (0x0051d462 - 0x401000)
.set FUN_0051e3c8, .text + (0x0051e3c8 - 0x401000)

.org 0x00403ea4 - 0x401000
.globl FUN_00403ea4
FUN_00403ea4:
    # block 0x00403ea4: entry, 191 instruction(s), calls FUN_0051e3c8, FUN_0051d3d5, FUN_0051d462, USER32.dll!SendMessageA, KERNEL32.dll!GetTickCount, FUN..., ends with ret
    push ebp                                     # 00403ea4
    {load} mov ebp, esp                          # 00403ea5
    sub esp, 0x38                                # 00403ea7
    mov dword ptr [ebp - local_38], ecx          # 00403eaa
    mov ecx, dword ptr [ebp - local_38]          # 00403ead
    call FUN_0051e3c8                            # 00403eb0
    mov eax, dword ptr [ebp - local_38]          # 00403eb5
    push eax                                     # 00403eb8
    push 0x3ee                                   # 00403eb9
    mov ecx, dword ptr [ebp - local_38]          # 00403ebe
    add ecx, 0x8c                                # 00403ec1
    call FUN_0051d3d5                            # 00403ec7
    mov ecx, dword ptr [ebp - local_38]          # 00403ecc
    push ecx                                     # 00403ecf
    push 0x3ef                                   # 00403ed0
    mov ecx, dword ptr [ebp - local_38]          # 00403ed5
    add ecx, 0xcc                                # 00403ed8
    call FUN_0051d3d5                            # 00403ede
    mov edx, dword ptr [ebp - local_38]          # 00403ee3
    push edx                                     # 00403ee6
    push 0x3f0                                   # 00403ee7
    mov ecx, dword ptr [ebp - local_38]          # 00403eec
    add ecx, 0x10c                               # 00403eef
    call FUN_0051d3d5                            # 00403ef5
    mov eax, dword ptr [ebp - local_38]          # 00403efa
    push eax                                     # 00403efd
    push 0x3f2                                   # 00403efe
    mov ecx, dword ptr [ebp - local_38]          # 00403f03
    add ecx, 0x14c                               # 00403f06
    call FUN_0051d3d5                            # 00403f0c
    mov ecx, dword ptr [ebp - local_38]          # 00403f11
    push ecx                                     # 00403f14
    push 0x3f3                                   # 00403f15
    mov ecx, dword ptr [ebp - local_38]          # 00403f1a
    add ecx, 0x18c                               # 00403f1d
    call FUN_0051d3d5                            # 00403f23
    mov edx, dword ptr [ebp - local_38]          # 00403f28
    push edx                                     # 00403f2b
    push 0x3f4                                   # 00403f2c
    mov ecx, dword ptr [ebp - local_38]          # 00403f31
    add ecx, 0x1cc                               # 00403f34
    call FUN_0051d3d5                            # 00403f3a
    mov eax, dword ptr [ebp - local_38]          # 00403f3f
    push eax                                     # 00403f42
    push 0x3f5                                   # 00403f43
    mov ecx, dword ptr [ebp - local_38]          # 00403f48
    add ecx, 0x20c                               # 00403f4b
    call FUN_0051d3d5                            # 00403f51
    mov ecx, dword ptr [ebp - local_38]          # 00403f56
    push ecx                                     # 00403f59
    push 0x3f6                                   # 00403f5a
    mov ecx, dword ptr [ebp - local_38]          # 00403f5f
    add ecx, 0x24c                               # 00403f62
    call FUN_0051d3d5                            # 00403f68
    mov edx, dword ptr [ebp - local_38]          # 00403f6d
    push edx                                     # 00403f70
    push 0x3f7                                   # 00403f71
    mov ecx, dword ptr [ebp - local_38]          # 00403f76
    add ecx, 0x28c                               # 00403f79
    call FUN_0051d3d5                            # 00403f7f
    mov eax, dword ptr [ebp - local_38]          # 00403f84
    push eax                                     # 00403f87
    push 0x3fc                                   # 00403f88
    mov ecx, dword ptr [ebp - local_38]          # 00403f8d
    add ecx, 0x2cc                               # 00403f90
    call FUN_0051d3d5                            # 00403f96
    mov ecx, dword ptr [ebp - local_38]          # 00403f9b
    push ecx                                     # 00403f9e
    push 0x3fd                                   # 00403f9f
    mov ecx, dword ptr [ebp - local_38]          # 00403fa4
    add ecx, 0x30c                               # 00403fa7
    call FUN_0051d3d5                            # 00403fad
    mov edx, dword ptr [ebp - local_38]          # 00403fb2
    push edx                                     # 00403fb5
    push 0x3fe                                   # 00403fb6
    mov ecx, dword ptr [ebp - local_38]          # 00403fbb
    add ecx, 0x34c                               # 00403fbe
    call FUN_0051d3d5                            # 00403fc4
    mov eax, dword ptr [ebp - local_38]          # 00403fc9
    push eax                                     # 00403fcc
    push 0x3f8                                   # 00403fcd
    mov ecx, dword ptr [ebp - local_38]          # 00403fd2
    add ecx, 0x38c                               # 00403fd5
    call FUN_0051d3d5                            # 00403fdb
    mov ecx, dword ptr [ebp - local_38]          # 00403fe0
    push ecx                                     # 00403fe3
    push 0x3f9                                   # 00403fe4
    mov ecx, dword ptr [ebp - local_38]          # 00403fe9
    add ecx, 0x3cc                               # 00403fec
    call FUN_0051d3d5                            # 00403ff2
    mov edx, dword ptr [ebp - local_38]          # 00403ff7
    push edx                                     # 00403ffa
    push 0x3fa                                   # 00403ffb
    mov ecx, dword ptr [ebp - local_38]          # 00404000
    add ecx, 0x40c                               # 00404003
    call FUN_0051d3d5                            # 00404009
    mov eax, dword ptr [ebp - local_38]          # 0040400e
    push eax                                     # 00404011
    push 0x3fb                                   # 00404012
    mov ecx, dword ptr [ebp - local_38]          # 00404017
    add ecx, 0x44c                               # 0040401a
    call FUN_0051d3d5                            # 00404020
    push 0x411                                   # 00404025
    mov ecx, dword ptr [ebp - local_38]          # 0040402a
    call FUN_0051d462                            # 0040402d
    mov dword ptr [ebp - local_2c], eax          # 00404032
    mov ecx, dword ptr [ebp - local_38]          # 00404035
    mov edx, dword ptr [ebp - local_2c]          # 00404038
    mov dword ptr [ecx + field_48c], edx         # 0040403b
    push 0x568                                   # 00404041
    mov ecx, dword ptr [ebp - local_38]          # 00404046
    call FUN_0051d462                            # 00404049
    mov dword ptr [ebp - local_28], eax          # 0040404e
    mov eax, dword ptr [ebp - local_38]          # 00404051
    mov ecx, dword ptr [ebp - local_28]          # 00404054
    mov dword ptr [eax + field_4a8], ecx         # 00404057
    push 0x569                                   # 0040405d
    mov ecx, dword ptr [ebp - local_38]          # 00404062
    call FUN_0051d462                            # 00404065
    mov dword ptr [ebp - local_20], eax          # 0040406a
    mov edx, dword ptr [ebp - local_38]          # 0040406d
    mov eax, dword ptr [ebp - local_20]          # 00404070
    mov dword ptr [edx + field_4ac], eax         # 00404073
    mov dword ptr [ebp - local_10], 0x1          # 00404079
    mov dword ptr [ebp - local_14], 0x1          # 00404080
    mov dword ptr [ebp - local_34], 0x1          # 00404087
    mov ecx, dword ptr [ebp - local_38]          # 0040408e
    mov edx, dword ptr [ecx + field_4ac]         # 00404091
    mov dword ptr [ebp - local_30], edx          # 00404097
    lea eax, [ebp - local_14]                    # 0040409a
    push eax                                     # 0040409d
    mov ecx, dword ptr [ebp - local_34]          # 0040409e
    push ecx                                     # 004040a1
    push 0x46b                                   # 004040a2
    mov edx, dword ptr [ebp - local_30]          # 004040a7
    mov eax, dword ptr [edx + field_1c]          # 004040aa
    push eax                                     # 004040ad
    call dword ptr [0x52a4c8]                    # 004040ae
    call dword ptr [0x52a23c]                    # 004040b4
    mov ecx, dword ptr [ebp - local_38]          # 004040ba
    mov dword ptr [ecx + field_4b0], eax         # 004040bd
    push 0x475                                   # 004040c3
    mov ecx, dword ptr [ebp - local_38]          # 004040c8
    call FUN_0051d462                            # 004040cb
    mov dword ptr [ebp - local_4], eax           # 004040d0
    mov edx, dword ptr [ebp - local_38]          # 004040d3
    mov eax, dword ptr [ebp - local_4]           # 004040d6
    mov dword ptr [edx + field_490], eax         # 004040d9
    push 0x476                                   # 004040df
    mov ecx, dword ptr [ebp - local_38]          # 004040e4
    call FUN_0051d462                            # 004040e7
    mov dword ptr [ebp - local_18], eax          # 004040ec
    mov ecx, dword ptr [ebp - local_38]          # 004040ef
    mov edx, dword ptr [ebp - local_18]          # 004040f2
    mov dword ptr [ecx + field_494], edx         # 004040f5
    push 0x477                                   # 004040fb
    mov ecx, dword ptr [ebp - local_38]          # 00404100
    call FUN_0051d462                            # 00404103
    mov dword ptr [ebp - local_1c], eax          # 00404108
    mov eax, dword ptr [ebp - local_38]          # 0040410b
    mov ecx, dword ptr [ebp - local_1c]          # 0040410e
    mov dword ptr [eax + field_498], ecx         # 00404111
    push 0x478                                   # 00404117
    mov ecx, dword ptr [ebp - local_38]          # 0040411c
    call FUN_0051d462                            # 0040411f
    mov dword ptr [ebp - local_c], eax           # 00404124
    mov edx, dword ptr [ebp - local_38]          # 00404127
    mov eax, dword ptr [ebp - local_c]           # 0040412a
    mov dword ptr [edx + field_49c], eax         # 0040412d
    push 0x479                                   # 00404133
    mov ecx, dword ptr [ebp - local_38]          # 00404138
    call FUN_0051d462                            # 0040413b
    mov dword ptr [ebp - local_24], eax          # 00404140
    mov ecx, dword ptr [ebp - local_38]          # 00404143
    mov edx, dword ptr [ebp - local_24]          # 00404146
    mov dword ptr [ecx + field_4a0], edx         # 00404149
    push 0x47a                                   # 0040414f
    mov ecx, dword ptr [ebp - local_38]          # 00404154
    call FUN_0051d462                            # 00404157
    mov dword ptr [ebp - local_8], eax           # 0040415c
    mov eax, dword ptr [ebp - local_38]          # 0040415f
    mov ecx, dword ptr [ebp - local_8]           # 00404162
    mov dword ptr [eax + field_4a4], ecx         # 00404165
    mov ecx, 0x5e2e70                            # 0040416b
    call FUN_004d9302                            # 00404170
    mov ecx, dword ptr [ebp - local_38]          # 00404175
    call FUN_004033db                            # 00404178
    mov eax, 0x1                                 # 0040417d
    {load} mov esp, ebp                          # 00404182
    pop ebp                                      # 00404184
    ret                                          # 00404185

