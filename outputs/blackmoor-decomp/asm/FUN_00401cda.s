# FUN_00401cda
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401cda
# extent:       0x00401cda-0x00402322 (1608 code bytes)
# span:         0x00401cda-0x00402322 (code 1608, tables 0, padding 0)
# sha256:       49ac86dac2a3c07f46a88c2f1922eddf94da115df6c3ca7f273af84186e1a5e2
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401cda
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0051e3c8, FUN_0050ca3e, FUN_0051d4c4, FUN_0051d58b, FUN_0040236a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m401cda_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 502 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0040236a, .text + (0x0040236a - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051d4c4, .text + (0x0051d4c4 - 0x401000)
.set FUN_0051d58b, .text + (0x0051d58b - 0x401000)
.set FUN_0051e3c8, .text + (0x0051e3c8 - 0x401000)

.org 0x00401cda - 0x401000
.globl FUN_00401cda
FUN_00401cda:
    # block 0x00401cda: entry, 502 instruction(s), calls FUN_0051e3c8, FUN_0050ca3e, FUN_0051d4c4, FUN_0051d58b, FUN_0040236a, ends with ret
    push ebp                                     # 00401cda
    {load} mov ebp, esp                          # 00401cdb
    push ecx                                     # 00401cdd
    mov dword ptr [ebp - local_4], ecx           # 00401cde
    mov ecx, dword ptr [ebp - local_4]           # 00401ce1
    call FUN_0051e3c8                            # 00401ce4
    mov eax, dword ptr [0x569138]                # 00401ce9
    imul eax, eax, 0x14                          # 00401cee
    mov ecx, dword ptr [ebp - local_4]           # 00401cf1
    mov edx, dword ptr [eax + 0x5370ec]          # 00401cf4
    mov dword ptr [ecx + field_5c], edx          # 00401cfa
    mov eax, dword ptr [ebp - local_4]           # 00401cfd
    mov ecx, dword ptr [eax + field_5c]          # 00401d00
    mov edx, dword ptr [4*ecx + 0x5374d0]        # 00401d03
    push edx                                     # 00401d0a
    mov eax, dword ptr [ebp - local_4]           # 00401d0b
    mov ecx, dword ptr [eax + field_5c]          # 00401d0e
    push ecx                                     # 00401d11
    push 0x53e808                                # 00401d12
    mov edx, dword ptr [ebp - local_4]           # 00401d17
    add edx, 0x60                                # 00401d1a
    push edx                                     # 00401d1d
    call FUN_0050ca3e                            # 00401d1e
    add esp, 0x10                                # 00401d23
    mov eax, dword ptr [ebp - local_4]           # 00401d26
    add eax, 0x60                                # 00401d29
    push eax                                     # 00401d2c
    push 0x3fc                                   # 00401d2d
    mov ecx, dword ptr [ebp - local_4]           # 00401d32
    call FUN_0051d4c4                            # 00401d35
    mov ecx, dword ptr [ebp - local_4]           # 00401d3a
    mov edx, dword ptr [ecx + field_5c]          # 00401d3d
    mov eax, dword ptr [4*edx + 0x5374d4]        # 00401d40
    push eax                                     # 00401d47
    mov ecx, dword ptr [ebp - local_4]           # 00401d48
    mov edx, dword ptr [ecx + field_5c]          # 00401d4b
    add edx, 0x1                                 # 00401d4e
    push edx                                     # 00401d51
    push 0x53e810                                # 00401d52
    mov eax, dword ptr [ebp - local_4]           # 00401d57
    add eax, 0x60                                # 00401d5a
    push eax                                     # 00401d5d
    call FUN_0050ca3e                            # 00401d5e
    add esp, 0x10                                # 00401d63
    mov ecx, dword ptr [ebp - local_4]           # 00401d66
    add ecx, 0x60                                # 00401d69
    push ecx                                     # 00401d6c
    push 0x3fd                                   # 00401d6d
    mov ecx, dword ptr [ebp - local_4]           # 00401d72
    call FUN_0051d4c4                            # 00401d75
    mov edx, dword ptr [ebp - local_4]           # 00401d7a
    mov eax, dword ptr [edx + field_5c]          # 00401d7d
    mov ecx, dword ptr [4*eax + 0x5374d8]        # 00401d80
    push ecx                                     # 00401d87
    mov edx, dword ptr [ebp - local_4]           # 00401d88
    mov eax, dword ptr [edx + field_5c]          # 00401d8b
    add eax, 0x2                                 # 00401d8e
    push eax                                     # 00401d91
    push 0x53e818                                # 00401d92
    mov ecx, dword ptr [ebp - local_4]           # 00401d97
    add ecx, 0x60                                # 00401d9a
    push ecx                                     # 00401d9d
    call FUN_0050ca3e                            # 00401d9e
    add esp, 0x10                                # 00401da3
    mov edx, dword ptr [ebp - local_4]           # 00401da6
    add edx, 0x60                                # 00401da9
    push edx                                     # 00401dac
    push 0x3fe                                   # 00401dad
    mov ecx, dword ptr [ebp - local_4]           # 00401db2
    call FUN_0051d4c4                            # 00401db5
    mov eax, dword ptr [ebp - local_4]           # 00401dba
    mov ecx, dword ptr [eax + field_5c]          # 00401dbd
    mov edx, dword ptr [4*ecx + 0x5374dc]        # 00401dc0
    push edx                                     # 00401dc7
    mov eax, dword ptr [ebp - local_4]           # 00401dc8
    mov ecx, dword ptr [eax + field_5c]          # 00401dcb
    add ecx, 0x3                                 # 00401dce
    push ecx                                     # 00401dd1
    push 0x53e820                                # 00401dd2
    mov edx, dword ptr [ebp - local_4]           # 00401dd7
    add edx, 0x60                                # 00401dda
    push edx                                     # 00401ddd
    call FUN_0050ca3e                            # 00401dde
    add esp, 0x10                                # 00401de3
    mov eax, dword ptr [ebp - local_4]           # 00401de6
    add eax, 0x60                                # 00401de9
    push eax                                     # 00401dec
    push 0x3ff                                   # 00401ded
    mov ecx, dword ptr [ebp - local_4]           # 00401df2
    call FUN_0051d4c4                            # 00401df5
    mov ecx, dword ptr [ebp - local_4]           # 00401dfa
    mov edx, dword ptr [ecx + field_5c]          # 00401dfd
    mov eax, dword ptr [4*edx + 0x5374e0]        # 00401e00
    push eax                                     # 00401e07
    mov ecx, dword ptr [ebp - local_4]           # 00401e08
    mov edx, dword ptr [ecx + field_5c]          # 00401e0b
    add edx, 0x4                                 # 00401e0e
    push edx                                     # 00401e11
    push 0x53e828                                # 00401e12
    mov eax, dword ptr [ebp - local_4]           # 00401e17
    add eax, 0x60                                # 00401e1a
    push eax                                     # 00401e1d
    call FUN_0050ca3e                            # 00401e1e
    add esp, 0x10                                # 00401e23
    mov ecx, dword ptr [ebp - local_4]           # 00401e26
    add ecx, 0x60                                # 00401e29
    push ecx                                     # 00401e2c
    push 0x400                                   # 00401e2d
    mov ecx, dword ptr [ebp - local_4]           # 00401e32
    call FUN_0051d4c4                            # 00401e35
    mov edx, dword ptr [ebp - local_4]           # 00401e3a
    mov eax, dword ptr [edx + field_5c]          # 00401e3d
    mov ecx, dword ptr [4*eax + 0x5374e4]        # 00401e40
    push ecx                                     # 00401e47
    mov edx, dword ptr [ebp - local_4]           # 00401e48
    mov eax, dword ptr [edx + field_5c]          # 00401e4b
    add eax, 0x5                                 # 00401e4e
    push eax                                     # 00401e51
    push 0x53e830                                # 00401e52
    mov ecx, dword ptr [ebp - local_4]           # 00401e57
    add ecx, 0x60                                # 00401e5a
    push ecx                                     # 00401e5d
    call FUN_0050ca3e                            # 00401e5e
    add esp, 0x10                                # 00401e63
    mov edx, dword ptr [ebp - local_4]           # 00401e66
    add edx, 0x60                                # 00401e69
    push edx                                     # 00401e6c
    push 0x401                                   # 00401e6d
    mov ecx, dword ptr [ebp - local_4]           # 00401e72
    call FUN_0051d4c4                            # 00401e75
    mov eax, dword ptr [ebp - local_4]           # 00401e7a
    mov ecx, dword ptr [eax + field_5c]          # 00401e7d
    mov edx, dword ptr [4*ecx + 0x5374e8]        # 00401e80
    push edx                                     # 00401e87
    mov eax, dword ptr [ebp - local_4]           # 00401e88
    mov ecx, dword ptr [eax + field_5c]          # 00401e8b
    add ecx, 0x6                                 # 00401e8e
    push ecx                                     # 00401e91
    push 0x53e838                                # 00401e92
    mov edx, dword ptr [ebp - local_4]           # 00401e97
    add edx, 0x60                                # 00401e9a
    push edx                                     # 00401e9d
    call FUN_0050ca3e                            # 00401e9e
    add esp, 0x10                                # 00401ea3
    mov eax, dword ptr [ebp - local_4]           # 00401ea6
    add eax, 0x60                                # 00401ea9
    push eax                                     # 00401eac
    push 0x402                                   # 00401ead
    mov ecx, dword ptr [ebp - local_4]           # 00401eb2
    call FUN_0051d4c4                            # 00401eb5
    mov ecx, dword ptr [ebp - local_4]           # 00401eba
    mov edx, dword ptr [ecx + field_5c]          # 00401ebd
    mov eax, dword ptr [4*edx + 0x5374ec]        # 00401ec0
    push eax                                     # 00401ec7
    mov ecx, dword ptr [ebp - local_4]           # 00401ec8
    mov edx, dword ptr [ecx + field_5c]          # 00401ecb
    add edx, 0x7                                 # 00401ece
    push edx                                     # 00401ed1
    push 0x53e840                                # 00401ed2
    mov eax, dword ptr [ebp - local_4]           # 00401ed7
    add eax, 0x60                                # 00401eda
    push eax                                     # 00401edd
    call FUN_0050ca3e                            # 00401ede
    add esp, 0x10                                # 00401ee3
    mov ecx, dword ptr [ebp - local_4]           # 00401ee6
    add ecx, 0x60                                # 00401ee9
    push ecx                                     # 00401eec
    push 0x403                                   # 00401eed
    mov ecx, dword ptr [ebp - local_4]           # 00401ef2
    call FUN_0051d4c4                            # 00401ef5
    mov edx, dword ptr [ebp - local_4]           # 00401efa
    mov eax, dword ptr [edx + field_5c]          # 00401efd
    mov ecx, dword ptr [4*eax + 0x5374f0]        # 00401f00
    push ecx                                     # 00401f07
    mov edx, dword ptr [ebp - local_4]           # 00401f08
    mov eax, dword ptr [edx + field_5c]          # 00401f0b
    add eax, 0x8                                 # 00401f0e
    push eax                                     # 00401f11
    push 0x53e848                                # 00401f12
    mov ecx, dword ptr [ebp - local_4]           # 00401f17
    add ecx, 0x60                                # 00401f1a
    push ecx                                     # 00401f1d
    call FUN_0050ca3e                            # 00401f1e
    add esp, 0x10                                # 00401f23
    mov edx, dword ptr [ebp - local_4]           # 00401f26
    add edx, 0x60                                # 00401f29
    push edx                                     # 00401f2c
    push 0x40e                                   # 00401f2d
    mov ecx, dword ptr [ebp - local_4]           # 00401f32
    call FUN_0051d4c4                            # 00401f35
    mov eax, dword ptr [ebp - local_4]           # 00401f3a
    mov ecx, dword ptr [eax + field_5c]          # 00401f3d
    mov edx, dword ptr [4*ecx + 0x5374f4]        # 00401f40
    push edx                                     # 00401f47
    mov eax, dword ptr [ebp - local_4]           # 00401f48
    mov ecx, dword ptr [eax + field_5c]          # 00401f4b
    add ecx, 0x9                                 # 00401f4e
    push ecx                                     # 00401f51
    push 0x53e850                                # 00401f52
    mov edx, dword ptr [ebp - local_4]           # 00401f57
    add edx, 0x60                                # 00401f5a
    push edx                                     # 00401f5d
    call FUN_0050ca3e                            # 00401f5e
    add esp, 0x10                                # 00401f63
    mov eax, dword ptr [ebp - local_4]           # 00401f66
    add eax, 0x60                                # 00401f69
    push eax                                     # 00401f6c
    push 0x40d                                   # 00401f6d
    mov ecx, dword ptr [ebp - local_4]           # 00401f72
    call FUN_0051d4c4                            # 00401f75
    mov ecx, dword ptr [ebp - local_4]           # 00401f7a
    mov edx, dword ptr [ecx + field_5c]          # 00401f7d
    mov eax, dword ptr [4*edx + 0x5374f8]        # 00401f80
    push eax                                     # 00401f87
    mov ecx, dword ptr [ebp - local_4]           # 00401f88
    mov edx, dword ptr [ecx + field_5c]          # 00401f8b
    add edx, 0xa                                 # 00401f8e
    push edx                                     # 00401f91
    push 0x53e858                                # 00401f92
    mov eax, dword ptr [ebp - local_4]           # 00401f97
    add eax, 0x60                                # 00401f9a
    push eax                                     # 00401f9d
    call FUN_0050ca3e                            # 00401f9e
    add esp, 0x10                                # 00401fa3
    mov ecx, dword ptr [ebp - local_4]           # 00401fa6
    add ecx, 0x60                                # 00401fa9
    push ecx                                     # 00401fac
    push 0x40c                                   # 00401fad
    mov ecx, dword ptr [ebp - local_4]           # 00401fb2
    call FUN_0051d4c4                            # 00401fb5
    mov edx, dword ptr [ebp - local_4]           # 00401fba
    mov eax, dword ptr [edx + field_5c]          # 00401fbd
    mov ecx, dword ptr [4*eax + 0x5374fc]        # 00401fc0
    push ecx                                     # 00401fc7
    mov edx, dword ptr [ebp - local_4]           # 00401fc8
    mov eax, dword ptr [edx + field_5c]          # 00401fcb
    add eax, 0xb                                 # 00401fce
    push eax                                     # 00401fd1
    push 0x53e860                                # 00401fd2
    mov ecx, dword ptr [ebp - local_4]           # 00401fd7
    add ecx, 0x60                                # 00401fda
    push ecx                                     # 00401fdd
    call FUN_0050ca3e                            # 00401fde
    add esp, 0x10                                # 00401fe3
    mov edx, dword ptr [ebp - local_4]           # 00401fe6
    add edx, 0x60                                # 00401fe9
    push edx                                     # 00401fec
    push 0x40b                                   # 00401fed
    mov ecx, dword ptr [ebp - local_4]           # 00401ff2
    call FUN_0051d4c4                            # 00401ff5
    mov eax, dword ptr [ebp - local_4]           # 00401ffa
    mov ecx, dword ptr [eax + field_5c]          # 00401ffd
    mov edx, dword ptr [4*ecx + 0x537500]        # 00402000
    push edx                                     # 00402007
    mov eax, dword ptr [ebp - local_4]           # 00402008
    mov ecx, dword ptr [eax + field_5c]          # 0040200b
    add ecx, 0xc                                 # 0040200e
    push ecx                                     # 00402011
    push 0x53e868                                # 00402012
    mov edx, dword ptr [ebp - local_4]           # 00402017
    add edx, 0x60                                # 0040201a
    push edx                                     # 0040201d
    call FUN_0050ca3e                            # 0040201e
    add esp, 0x10                                # 00402023
    mov eax, dword ptr [ebp - local_4]           # 00402026
    add eax, 0x60                                # 00402029
    push eax                                     # 0040202c
    push 0x404                                   # 0040202d
    mov ecx, dword ptr [ebp - local_4]           # 00402032
    call FUN_0051d4c4                            # 00402035
    mov ecx, dword ptr [ebp - local_4]           # 0040203a
    mov edx, dword ptr [ecx + field_5c]          # 0040203d
    mov eax, dword ptr [4*edx + 0x537504]        # 00402040
    push eax                                     # 00402047
    mov ecx, dword ptr [ebp - local_4]           # 00402048
    mov edx, dword ptr [ecx + field_5c]          # 0040204b
    add edx, 0xd                                 # 0040204e
    push edx                                     # 00402051
    push 0x53e870                                # 00402052
    mov eax, dword ptr [ebp - local_4]           # 00402057
    add eax, 0x60                                # 0040205a
    push eax                                     # 0040205d
    call FUN_0050ca3e                            # 0040205e
    add esp, 0x10                                # 00402063
    mov ecx, dword ptr [ebp - local_4]           # 00402066
    add ecx, 0x60                                # 00402069
    push ecx                                     # 0040206c
    push 0x405                                   # 0040206d
    mov ecx, dword ptr [ebp - local_4]           # 00402072
    call FUN_0051d4c4                            # 00402075
    mov edx, dword ptr [ebp - local_4]           # 0040207a
    mov eax, dword ptr [edx + field_5c]          # 0040207d
    mov ecx, dword ptr [4*eax + 0x537508]        # 00402080
    push ecx                                     # 00402087
    mov edx, dword ptr [ebp - local_4]           # 00402088
    mov eax, dword ptr [edx + field_5c]          # 0040208b
    add eax, 0xe                                 # 0040208e
    push eax                                     # 00402091
    push 0x53e878                                # 00402092
    mov ecx, dword ptr [ebp - local_4]           # 00402097
    add ecx, 0x60                                # 0040209a
    push ecx                                     # 0040209d
    call FUN_0050ca3e                            # 0040209e
    add esp, 0x10                                # 004020a3
    mov edx, dword ptr [ebp - local_4]           # 004020a6
    add edx, 0x60                                # 004020a9
    push edx                                     # 004020ac
    push 0x406                                   # 004020ad
    mov ecx, dword ptr [ebp - local_4]           # 004020b2
    call FUN_0051d4c4                            # 004020b5
    mov eax, dword ptr [ebp - local_4]           # 004020ba
    mov ecx, dword ptr [eax + field_5c]          # 004020bd
    mov edx, dword ptr [4*ecx + 0x53750c]        # 004020c0
    push edx                                     # 004020c7
    mov eax, dword ptr [ebp - local_4]           # 004020c8
    mov ecx, dword ptr [eax + field_5c]          # 004020cb
    add ecx, 0xf                                 # 004020ce
    push ecx                                     # 004020d1
    push 0x53e880                                # 004020d2
    mov edx, dword ptr [ebp - local_4]           # 004020d7
    add edx, 0x60                                # 004020da
    push edx                                     # 004020dd
    call FUN_0050ca3e                            # 004020de
    add esp, 0x10                                # 004020e3
    mov eax, dword ptr [ebp - local_4]           # 004020e6
    add eax, 0x60                                # 004020e9
    push eax                                     # 004020ec
    push 0x407                                   # 004020ed
    mov ecx, dword ptr [ebp - local_4]           # 004020f2
    call FUN_0051d4c4                            # 004020f5
    mov ecx, dword ptr [ebp - local_4]           # 004020fa
    mov edx, dword ptr [ecx + field_5c]          # 004020fd
    mov eax, dword ptr [4*edx + 0x537510]        # 00402100
    push eax                                     # 00402107
    mov ecx, dword ptr [ebp - local_4]           # 00402108
    mov edx, dword ptr [ecx + field_5c]          # 0040210b
    add edx, 0x10                                # 0040210e
    push edx                                     # 00402111
    push 0x53e888                                # 00402112
    mov eax, dword ptr [ebp - local_4]           # 00402117
    add eax, 0x60                                # 0040211a
    push eax                                     # 0040211d
    call FUN_0050ca3e                            # 0040211e
    add esp, 0x10                                # 00402123
    mov ecx, dword ptr [ebp - local_4]           # 00402126
    add ecx, 0x60                                # 00402129
    push ecx                                     # 0040212c
    push 0x408                                   # 0040212d
    mov ecx, dword ptr [ebp - local_4]           # 00402132
    call FUN_0051d4c4                            # 00402135
    mov edx, dword ptr [ebp - local_4]           # 0040213a
    mov eax, dword ptr [edx + field_5c]          # 0040213d
    mov ecx, dword ptr [4*eax + 0x537514]        # 00402140
    push ecx                                     # 00402147
    mov edx, dword ptr [ebp - local_4]           # 00402148
    mov eax, dword ptr [edx + field_5c]          # 0040214b
    add eax, 0x11                                # 0040214e
    push eax                                     # 00402151
    push 0x53e890                                # 00402152
    mov ecx, dword ptr [ebp - local_4]           # 00402157
    add ecx, 0x60                                # 0040215a
    push ecx                                     # 0040215d
    call FUN_0050ca3e                            # 0040215e
    add esp, 0x10                                # 00402163
    mov edx, dword ptr [ebp - local_4]           # 00402166
    add edx, 0x60                                # 00402169
    push edx                                     # 0040216c
    push 0x409                                   # 0040216d
    mov ecx, dword ptr [ebp - local_4]           # 00402172
    call FUN_0051d4c4                            # 00402175
    mov eax, dword ptr [ebp - local_4]           # 0040217a
    mov ecx, dword ptr [eax + field_5c]          # 0040217d
    mov edx, dword ptr [4*ecx + 0x537518]        # 00402180
    push edx                                     # 00402187
    mov eax, dword ptr [ebp - local_4]           # 00402188
    mov ecx, dword ptr [eax + field_5c]          # 0040218b
    add ecx, 0x12                                # 0040218e
    push ecx                                     # 00402191
    push 0x53e898                                # 00402192
    mov edx, dword ptr [ebp - local_4]           # 00402197
    add edx, 0x60                                # 0040219a
    push edx                                     # 0040219d
    call FUN_0050ca3e                            # 0040219e
    add esp, 0x10                                # 004021a3
    mov eax, dword ptr [ebp - local_4]           # 004021a6
    add eax, 0x60                                # 004021a9
    push eax                                     # 004021ac
    push 0x40a                                   # 004021ad
    mov ecx, dword ptr [ebp - local_4]           # 004021b2
    call FUN_0051d4c4                            # 004021b5
    mov ecx, dword ptr [ebp - local_4]           # 004021ba
    mov edx, dword ptr [ecx + field_5c]          # 004021bd
    mov eax, dword ptr [4*edx + 0x53751c]        # 004021c0
    push eax                                     # 004021c7
    mov ecx, dword ptr [ebp - local_4]           # 004021c8
    mov edx, dword ptr [ecx + field_5c]          # 004021cb
    add edx, 0x13                                # 004021ce
    push edx                                     # 004021d1
    push 0x53e8a0                                # 004021d2
    mov eax, dword ptr [ebp - local_4]           # 004021d7
    add eax, 0x60                                # 004021da
    push eax                                     # 004021dd
    call FUN_0050ca3e                            # 004021de
    add esp, 0x10                                # 004021e3
    mov ecx, dword ptr [ebp - local_4]           # 004021e6
    add ecx, 0x60                                # 004021e9
    push ecx                                     # 004021ec
    push 0x40f                                   # 004021ed
    mov ecx, dword ptr [ebp - local_4]           # 004021f2
    call FUN_0051d4c4                            # 004021f5
    mov edx, dword ptr [ebp - local_4]           # 004021fa
    mov eax, dword ptr [edx + field_5c]          # 004021fd
    mov ecx, dword ptr [4*eax + 0x537520]        # 00402200
    push ecx                                     # 00402207
    mov edx, dword ptr [ebp - local_4]           # 00402208
    mov eax, dword ptr [edx + field_5c]          # 0040220b
    add eax, 0x14                                # 0040220e
    push eax                                     # 00402211
    push 0x53e8a8                                # 00402212
    mov ecx, dword ptr [ebp - local_4]           # 00402217
    add ecx, 0x60                                # 0040221a
    push ecx                                     # 0040221d
    call FUN_0050ca3e                            # 0040221e
    add esp, 0x10                                # 00402223
    mov edx, dword ptr [ebp - local_4]           # 00402226
    add edx, 0x60                                # 00402229
    push edx                                     # 0040222c
    push 0x410                                   # 0040222d
    mov ecx, dword ptr [ebp - local_4]           # 00402232
    call FUN_0051d4c4                            # 00402235
    mov eax, dword ptr [ebp - local_4]           # 0040223a
    mov ecx, dword ptr [eax + field_5c]          # 0040223d
    mov edx, dword ptr [4*ecx + 0x537524]        # 00402240
    push edx                                     # 00402247
    mov eax, dword ptr [ebp - local_4]           # 00402248
    mov ecx, dword ptr [eax + field_5c]          # 0040224b
    add ecx, 0x15                                # 0040224e
    push ecx                                     # 00402251
    push 0x53e8b0                                # 00402252
    mov edx, dword ptr [ebp - local_4]           # 00402257
    add edx, 0x60                                # 0040225a
    push edx                                     # 0040225d
    call FUN_0050ca3e                            # 0040225e
    add esp, 0x10                                # 00402263
    mov eax, dword ptr [ebp - local_4]           # 00402266
    add eax, 0x60                                # 00402269
    push eax                                     # 0040226c
    push 0x411                                   # 0040226d
    mov ecx, dword ptr [ebp - local_4]           # 00402272
    call FUN_0051d4c4                            # 00402275
    mov ecx, dword ptr [ebp - local_4]           # 0040227a
    mov edx, dword ptr [ecx + field_5c]          # 0040227d
    mov eax, dword ptr [4*edx + 0x537528]        # 00402280
    push eax                                     # 00402287
    mov ecx, dword ptr [ebp - local_4]           # 00402288
    mov edx, dword ptr [ecx + field_5c]          # 0040228b
    add edx, 0x16                                # 0040228e
    push edx                                     # 00402291
    push 0x53e8b8                                # 00402292
    mov eax, dword ptr [ebp - local_4]           # 00402297
    add eax, 0x60                                # 0040229a
    push eax                                     # 0040229d
    call FUN_0050ca3e                            # 0040229e
    add esp, 0x10                                # 004022a3
    mov ecx, dword ptr [ebp - local_4]           # 004022a6
    add ecx, 0x60                                # 004022a9
    push ecx                                     # 004022ac
    push 0x412                                   # 004022ad
    mov ecx, dword ptr [ebp - local_4]           # 004022b2
    call FUN_0051d4c4                            # 004022b5
    mov edx, dword ptr [ebp - local_4]           # 004022ba
    mov eax, dword ptr [edx + field_5c]          # 004022bd
    mov ecx, dword ptr [4*eax + 0x53752c]        # 004022c0
    push ecx                                     # 004022c7
    mov edx, dword ptr [ebp - local_4]           # 004022c8
    mov eax, dword ptr [edx + field_5c]          # 004022cb
    add eax, 0x17                                # 004022ce
    push eax                                     # 004022d1
    push 0x53e8c0                                # 004022d2
    mov ecx, dword ptr [ebp - local_4]           # 004022d7
    add ecx, 0x60                                # 004022da
    push ecx                                     # 004022dd
    call FUN_0050ca3e                            # 004022de
    add esp, 0x10                                # 004022e3
    mov edx, dword ptr [ebp - local_4]           # 004022e6
    add edx, 0x60                                # 004022e9
    push edx                                     # 004022ec
    push 0x413                                   # 004022ed
    mov ecx, dword ptr [ebp - local_4]           # 004022f2
    call FUN_0051d4c4                            # 004022f5
    mov eax, dword ptr [0x569138]                # 004022fa
    imul eax, eax, 0x14                          # 004022ff
    mov ecx, dword ptr [eax + 0x5370f4]          # 00402302
    push ecx                                     # 00402308
    mov ecx, dword ptr [ebp - local_4]           # 00402309
    call FUN_0051d58b                            # 0040230c
    mov ecx, dword ptr [ebp - local_4]           # 00402311
    call FUN_0040236a                            # 00402314
    mov eax, 0x1                                 # 00402319
    {load} mov esp, ebp                          # 0040231e
    pop ebp                                      # 00402320
    ret                                          # 00402321

