# FUN_00407da0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407da0
# extent:       0x00407da0-0x004080fc (860 code bytes)
# span:         0x00407da0-0x004080fc (code 860, tables 0, padding 0)
# sha256:       fa77a387096a9a54d0a75af1b15af0f81ce663b1f9bd5fc8de79d13827c3026d
# evidence:     ev_f077da93048f8988a96399f357fa9b0d462c71f5ee4ac3437f49adc8ae869a09
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407da0_lifted
# naming:       native port src/original_methods_fl40.c:m407da0_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 228/228 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051e3c8, FUN_0051d3d5, FUN_00407ca7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m407da0_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 228 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00407ca7, .text + (0x00407ca7 - 0x401000)
.set FUN_0051d3d5, .text + (0x0051d3d5 - 0x401000)
.set FUN_0051e3c8, .text + (0x0051e3c8 - 0x401000)

.org 0x00407da0 - 0x401000
.globl FUN_00407da0
FUN_00407da0:
    # block 0x00407da0: entry, 228 instruction(s), calls FUN_0051e3c8, FUN_0051d3d5, FUN_00407ca7, ends with ret
    push ebp                                     # 00407da0
    {load} mov ebp, esp                          # 00407da1
    push ecx                                     # 00407da3
    mov dword ptr [ebp - local_4], ecx           # 00407da4
    mov ecx, dword ptr [ebp - local_4]           # 00407da7
    call FUN_0051e3c8                            # 00407daa
    mov eax, dword ptr [ebp - local_4]           # 00407daf
    push eax                                     # 00407db2
    push 0x4b8                                   # 00407db3
    mov ecx, dword ptr [ebp - local_4]           # 00407db8
    add ecx, 0x8c                                # 00407dbb
    call FUN_0051d3d5                            # 00407dc1
    mov ecx, dword ptr [ebp - local_4]           # 00407dc6
    push ecx                                     # 00407dc9
    push 0x4b9                                   # 00407dca
    mov ecx, dword ptr [ebp - local_4]           # 00407dcf
    add ecx, 0xcc                                # 00407dd2
    call FUN_0051d3d5                            # 00407dd8
    mov edx, dword ptr [ebp - local_4]           # 00407ddd
    push edx                                     # 00407de0
    push 0x4ba                                   # 00407de1
    mov ecx, dword ptr [ebp - local_4]           # 00407de6
    add ecx, 0x10c                               # 00407de9
    call FUN_0051d3d5                            # 00407def
    mov eax, dword ptr [ebp - local_4]           # 00407df4
    push eax                                     # 00407df7
    push 0x4bb                                   # 00407df8
    mov ecx, dword ptr [ebp - local_4]           # 00407dfd
    add ecx, 0x14c                               # 00407e00
    call FUN_0051d3d5                            # 00407e06
    mov ecx, dword ptr [ebp - local_4]           # 00407e0b
    push ecx                                     # 00407e0e
    push 0x4bc                                   # 00407e0f
    mov ecx, dword ptr [ebp - local_4]           # 00407e14
    add ecx, 0x18c                               # 00407e17
    call FUN_0051d3d5                            # 00407e1d
    mov edx, dword ptr [ebp - local_4]           # 00407e22
    push edx                                     # 00407e25
    push 0x4bd                                   # 00407e26
    mov ecx, dword ptr [ebp - local_4]           # 00407e2b
    add ecx, 0x1cc                               # 00407e2e
    call FUN_0051d3d5                            # 00407e34
    mov eax, dword ptr [ebp - local_4]           # 00407e39
    push eax                                     # 00407e3c
    push 0x4be                                   # 00407e3d
    mov ecx, dword ptr [ebp - local_4]           # 00407e42
    add ecx, 0x20c                               # 00407e45
    call FUN_0051d3d5                            # 00407e4b
    mov ecx, dword ptr [ebp - local_4]           # 00407e50
    push ecx                                     # 00407e53
    push 0x4bf                                   # 00407e54
    mov ecx, dword ptr [ebp - local_4]           # 00407e59
    add ecx, 0x24c                               # 00407e5c
    call FUN_0051d3d5                            # 00407e62
    mov edx, dword ptr [ebp - local_4]           # 00407e67
    push edx                                     # 00407e6a
    push 0x4c0                                   # 00407e6b
    mov ecx, dword ptr [ebp - local_4]           # 00407e70
    add ecx, 0x28c                               # 00407e73
    call FUN_0051d3d5                            # 00407e79
    mov eax, dword ptr [ebp - local_4]           # 00407e7e
    push eax                                     # 00407e81
    push 0x4c1                                   # 00407e82
    mov ecx, dword ptr [ebp - local_4]           # 00407e87
    add ecx, 0x2cc                               # 00407e8a
    call FUN_0051d3d5                            # 00407e90
    mov ecx, dword ptr [ebp - local_4]           # 00407e95
    push ecx                                     # 00407e98
    push 0x4c2                                   # 00407e99
    mov ecx, dword ptr [ebp - local_4]           # 00407e9e
    add ecx, 0x30c                               # 00407ea1
    call FUN_0051d3d5                            # 00407ea7
    mov edx, dword ptr [ebp - local_4]           # 00407eac
    push edx                                     # 00407eaf
    push 0x4c3                                   # 00407eb0
    mov ecx, dword ptr [ebp - local_4]           # 00407eb5
    add ecx, 0x34c                               # 00407eb8
    call FUN_0051d3d5                            # 00407ebe
    mov eax, dword ptr [ebp - local_4]           # 00407ec3
    push eax                                     # 00407ec6
    push 0x4c4                                   # 00407ec7
    mov ecx, dword ptr [ebp - local_4]           # 00407ecc
    add ecx, 0x38c                               # 00407ecf
    call FUN_0051d3d5                            # 00407ed5
    mov ecx, dword ptr [ebp - local_4]           # 00407eda
    push ecx                                     # 00407edd
    push 0x4c5                                   # 00407ede
    mov ecx, dword ptr [ebp - local_4]           # 00407ee3
    add ecx, 0x3cc                               # 00407ee6
    call FUN_0051d3d5                            # 00407eec
    mov edx, dword ptr [ebp - local_4]           # 00407ef1
    push edx                                     # 00407ef4
    push 0x4c6                                   # 00407ef5
    mov ecx, dword ptr [ebp - local_4]           # 00407efa
    add ecx, 0x40c                               # 00407efd
    call FUN_0051d3d5                            # 00407f03
    mov eax, dword ptr [ebp - local_4]           # 00407f08
    push eax                                     # 00407f0b
    push 0x4c7                                   # 00407f0c
    mov ecx, dword ptr [ebp - local_4]           # 00407f11
    add ecx, 0x44c                               # 00407f14
    call FUN_0051d3d5                            # 00407f1a
    mov ecx, dword ptr [ebp - local_4]           # 00407f1f
    push ecx                                     # 00407f22
    push 0x4c8                                   # 00407f23
    mov ecx, dword ptr [ebp - local_4]           # 00407f28
    add ecx, 0x48c                               # 00407f2b
    call FUN_0051d3d5                            # 00407f31
    mov edx, dword ptr [ebp - local_4]           # 00407f36
    push edx                                     # 00407f39
    push 0x4c9                                   # 00407f3a
    mov ecx, dword ptr [ebp - local_4]           # 00407f3f
    add ecx, 0x4cc                               # 00407f42
    call FUN_0051d3d5                            # 00407f48
    mov eax, dword ptr [ebp - local_4]           # 00407f4d
    push eax                                     # 00407f50
    push 0x4d0                                   # 00407f51
    mov ecx, dword ptr [ebp - local_4]           # 00407f56
    add ecx, 0x50c                               # 00407f59
    call FUN_0051d3d5                            # 00407f5f
    mov ecx, dword ptr [ebp - local_4]           # 00407f64
    push ecx                                     # 00407f67
    push 0x4d1                                   # 00407f68
    mov ecx, dword ptr [ebp - local_4]           # 00407f6d
    add ecx, 0x54c                               # 00407f70
    call FUN_0051d3d5                            # 00407f76
    mov edx, dword ptr [ebp - local_4]           # 00407f7b
    push edx                                     # 00407f7e
    push 0x4d2                                   # 00407f7f
    mov ecx, dword ptr [ebp - local_4]           # 00407f84
    add ecx, 0x58c                               # 00407f87
    call FUN_0051d3d5                            # 00407f8d
    mov eax, dword ptr [ebp - local_4]           # 00407f92
    push eax                                     # 00407f95
    push 0x4d3                                   # 00407f96
    mov ecx, dword ptr [ebp - local_4]           # 00407f9b
    add ecx, 0x5cc                               # 00407f9e
    call FUN_0051d3d5                            # 00407fa4
    mov ecx, dword ptr [ebp - local_4]           # 00407fa9
    push ecx                                     # 00407fac
    push 0x4d4                                   # 00407fad
    mov ecx, dword ptr [ebp - local_4]           # 00407fb2
    add ecx, 0x60c                               # 00407fb5
    call FUN_0051d3d5                            # 00407fbb
    mov edx, dword ptr [ebp - local_4]           # 00407fc0
    push edx                                     # 00407fc3
    push 0x4d5                                   # 00407fc4
    mov ecx, dword ptr [ebp - local_4]           # 00407fc9
    add ecx, 0x64c                               # 00407fcc
    call FUN_0051d3d5                            # 00407fd2
    mov eax, dword ptr [ebp - local_4]           # 00407fd7
    push eax                                     # 00407fda
    push 0x4d6                                   # 00407fdb
    mov ecx, dword ptr [ebp - local_4]           # 00407fe0
    add ecx, 0x68c                               # 00407fe3
    call FUN_0051d3d5                            # 00407fe9
    mov ecx, dword ptr [ebp - local_4]           # 00407fee
    push ecx                                     # 00407ff1
    push 0x4d7                                   # 00407ff2
    mov ecx, dword ptr [ebp - local_4]           # 00407ff7
    add ecx, 0x6cc                               # 00407ffa
    call FUN_0051d3d5                            # 00408000
    mov edx, dword ptr [ebp - local_4]           # 00408005
    push edx                                     # 00408008
    push 0x4d8                                   # 00408009
    mov ecx, dword ptr [ebp - local_4]           # 0040800e
    add ecx, 0x70c                               # 00408011
    call FUN_0051d3d5                            # 00408017
    mov eax, dword ptr [ebp - local_4]           # 0040801c
    push eax                                     # 0040801f
    push 0x4d9                                   # 00408020
    mov ecx, dword ptr [ebp - local_4]           # 00408025
    add ecx, 0x74c                               # 00408028
    call FUN_0051d3d5                            # 0040802e
    mov ecx, dword ptr [ebp - local_4]           # 00408033
    push ecx                                     # 00408036
    push 0x4da                                   # 00408037
    mov ecx, dword ptr [ebp - local_4]           # 0040803c
    add ecx, 0x78c                               # 0040803f
    call FUN_0051d3d5                            # 00408045
    mov edx, dword ptr [ebp - local_4]           # 0040804a
    push edx                                     # 0040804d
    push 0x4db                                   # 0040804e
    mov ecx, dword ptr [ebp - local_4]           # 00408053
    add ecx, 0x7cc                               # 00408056
    call FUN_0051d3d5                            # 0040805c
    mov eax, dword ptr [ebp - local_4]           # 00408061
    push eax                                     # 00408064
    push 0x4dc                                   # 00408065
    mov ecx, dword ptr [ebp - local_4]           # 0040806a
    add ecx, 0x80c                               # 0040806d
    call FUN_0051d3d5                            # 00408073
    mov ecx, dword ptr [ebp - local_4]           # 00408078
    push ecx                                     # 0040807b
    push 0x4dd                                   # 0040807c
    mov ecx, dword ptr [ebp - local_4]           # 00408081
    add ecx, 0x84c                               # 00408084
    call FUN_0051d3d5                            # 0040808a
    mov edx, dword ptr [ebp - local_4]           # 0040808f
    push edx                                     # 00408092
    push 0x4de                                   # 00408093
    mov ecx, dword ptr [ebp - local_4]           # 00408098
    add ecx, 0x88c                               # 0040809b
    call FUN_0051d3d5                            # 004080a1
    mov eax, dword ptr [ebp - local_4]           # 004080a6
    push eax                                     # 004080a9
    push 0x4df                                   # 004080aa
    mov ecx, dword ptr [ebp - local_4]           # 004080af
    add ecx, 0x8cc                               # 004080b2
    call FUN_0051d3d5                            # 004080b8
    mov ecx, dword ptr [ebp - local_4]           # 004080bd
    push ecx                                     # 004080c0
    push 0x4e0                                   # 004080c1
    mov ecx, dword ptr [ebp - local_4]           # 004080c6
    add ecx, 0x90c                               # 004080c9
    call FUN_0051d3d5                            # 004080cf
    mov edx, dword ptr [ebp - local_4]           # 004080d4
    push edx                                     # 004080d7
    push 0x4e1                                   # 004080d8
    mov ecx, dword ptr [ebp - local_4]           # 004080dd
    add ecx, 0x94c                               # 004080e0
    call FUN_0051d3d5                            # 004080e6
    mov ecx, dword ptr [ebp - local_4]           # 004080eb
    call FUN_00407ca7                            # 004080ee
    mov eax, 0x1                                 # 004080f3
    {load} mov esp, ebp                          # 004080f8
    pop ebp                                      # 004080fa
    ret                                          # 004080fb

