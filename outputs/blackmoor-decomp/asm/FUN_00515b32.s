# FUN_00515b32
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00515b32
# extent:       0x00515b32-0x00515c62 (304 code bytes)
# span:         0x00515b32-0x00515c62 (code 304, tables 0, padding 0)
# sha256:       55808f85fec2ed27d2ea06f1a429d81424d294c68dd5ea123c04d511d2fc5974
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00515b32
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00515c62
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 114 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00515c62, .text + (0x00515c62 - 0x401000)

.org 0x00515b32 - 0x401000
.globl FUN_00515b32
FUN_00515b32:
    # block 0x00515b32: entry, 13 instruction(s), ends with jae to 0x00515b4f (forward)
    push ebp                                     # 00515b32
    {load} mov ebp, esp                          # 00515b33
    push ecx                                     # 00515b35
    push ecx                                     # 00515b36
    fld qword ptr [ebp + arg_8]                  # 00515b37
    fcomp qword ptr [0x52c7b0]                   # 00515b3a
    fld qword ptr [ebp + arg_8]                  # 00515b40
    push esi                                     # 00515b43
    {load} xor edx, edx                          # 00515b44
    {load} xor esi, esi                          # 00515b46
    fnstsw ax                                    # 00515b48
    sahf                                         # 00515b4a
    jae.d8 L_00515b4f                            # 00515b4b
    # block 0x00515b4d: entered by fall-through of jae at 0x00515b4b, 1 instruction(s), falls into the block at 0x00515b4f
    fchs                                         # 00515b4d
L_00515b4f:
    # block 0x00515b4f: entered by jae at 0x00515b4b, 5 instruction(s), ends with jne to 0x00515b95 (forward)
    fstp qword ptr [ebp - local_8]               # 00515b4f
    mov eax, 0x7ff00000                          # 00515b52
    mov ecx, 0xfff00000                          # 00515b57
    cmp dword ptr [ebp + arg_14], eax            # 00515b5c
    jne.d8 L_00515b95                            # 00515b5f
    # block 0x00515b61: entered by fall-through of jne at 0x00515b5f, 2 instruction(s), ends with jne to 0x00515bbd (forward)
    cmp dword ptr [ebp + arg_10], edx            # 00515b61
    jne.d8 L_00515bbd                            # 00515b64
    # block 0x00515b66: entered by fall-through of jne at 0x00515b64, 5 instruction(s), ends with ja to 0x00515bd9 (forward)
    fld qword ptr [ebp - local_8]                # 00515b66
    fcomp qword ptr [0x52c598]                   # 00515b69
    fnstsw ax                                    # 00515b6f
    sahf                                         # 00515b71
    ja.d8 L_00515bd9                             # 00515b72
    # block 0x00515b74: entered by fall-through of ja at 0x00515b72, 5 instruction(s), ends with jb to 0x00515bef (forward)
    fld qword ptr [ebp - local_8]                # 00515b74
    fcomp qword ptr [0x52c598]                   # 00515b77
    fnstsw ax                                    # 00515b7d
    sahf                                         # 00515b7f
    jb.d8 L_00515bef                             # 00515b80
L_00515b82:
    # block 0x00515b82: entered by jae at 0x00515bb9; fall-through of jb at 0x00515b80, 6 instruction(s), ends with forward jump to 0x00515c5d
    fld qword ptr [0x568a20]                     # 00515b82
    mov eax, dword ptr [ebp + arg_18]            # 00515b88
    push 0x1                                     # 00515b8b
    pop esi                                      # 00515b8d
    fstp qword ptr [eax]                         # 00515b8e
    jmp.d32 L_00515c5d                           # 00515b90
L_00515b95:
    # block 0x00515b95: entered by jne at 0x00515b5f, 2 instruction(s), ends with jne to 0x00515bbd (forward)
    cmp dword ptr [ebp + arg_14], ecx            # 00515b95
    jne.d8 L_00515bbd                            # 00515b98
    # block 0x00515b9a: entered by fall-through of jne at 0x00515b98, 2 instruction(s), ends with jne to 0x00515bbd (forward)
    cmp dword ptr [ebp + arg_10], edx            # 00515b9a
    jne.d8 L_00515bbd                            # 00515b9d
    # block 0x00515b9f: entered by fall-through of jne at 0x00515b9d, 5 instruction(s), ends with ja to 0x00515bef (forward)
    fld qword ptr [ebp - local_8]                # 00515b9f
    fcomp qword ptr [0x52c598]                   # 00515ba2
    fnstsw ax                                    # 00515ba8
    sahf                                         # 00515baa
    ja.d8 L_00515bef                             # 00515bab
    # block 0x00515bad: entered by fall-through of ja at 0x00515bab, 5 instruction(s), ends with jae to 0x00515b82 (backward)
    fld qword ptr [ebp - local_8]                # 00515bad
    fcomp qword ptr [0x52c598]                   # 00515bb0
    fnstsw ax                                    # 00515bb6
    sahf                                         # 00515bb8
    jae.d8 L_00515b82                            # 00515bb9
    # block 0x00515bbb: entered by fall-through of jae at 0x00515bb9, 1 instruction(s), ends with forward jump to 0x00515bd9
    jmp.d8 L_00515bd9                            # 00515bbb
L_00515bbd:
    # block 0x00515bbd: entered by jne at 0x00515b64; jne at 0x00515b98; jne at 0x00515b9d, 2 instruction(s), ends with jne to 0x00515bf3 (forward)
    cmp dword ptr [ebp + arg_c], eax             # 00515bbd
    jne.d8 L_00515bf3                            # 00515bc0
    # block 0x00515bc2: entered by fall-through of jne at 0x00515bc0, 2 instruction(s), ends with jne to 0x00515c5d (forward)
    cmp dword ptr [ebp + arg_8], edx             # 00515bc2
    jne.d32 L_00515c5d                           # 00515bc5
    # block 0x00515bcb: entered by fall-through of jne at 0x00515bc5, 5 instruction(s), ends with jbe to 0x00515be1 (forward)
    fld qword ptr [ebp + arg_10]                 # 00515bcb
    fcomp qword ptr [0x52c7b0]                   # 00515bce
    fnstsw ax                                    # 00515bd4
    sahf                                         # 00515bd6
    jbe.d8 L_00515be1                            # 00515bd7
L_00515bd9:
    # block 0x00515bd9: entered by ja at 0x00515b72; jmp at 0x00515bbb; fall-through of jbe at 0x00515bd7, 2 instruction(s), ends with forward jump to 0x00515c58
    fld qword ptr [0x568a18]                     # 00515bd9
    jmp.d8 L_00515c58                            # 00515bdf
L_00515be1:
    # block 0x00515be1: entered by jbe at 0x00515bd7, 5 instruction(s), ends with jae to 0x00515c56 (forward)
    fld qword ptr [ebp + arg_10]                 # 00515be1
    fcomp qword ptr [0x52c7b0]                   # 00515be4
    fnstsw ax                                    # 00515bea
    sahf                                         # 00515bec
    jae.d8 L_00515c56                            # 00515bed
L_00515bef:
    # block 0x00515bef: entered by jb at 0x00515b80; ja at 0x00515bab; fall-through of jae at 0x00515bed, 2 instruction(s), ends with forward jump to 0x00515c58
    fldz                                         # 00515bef
    jmp.d8 L_00515c58                            # 00515bf1
L_00515bf3:
    # block 0x00515bf3: entered by jne at 0x00515bc0, 2 instruction(s), ends with jne to 0x00515c5d (forward)
    cmp dword ptr [ebp + arg_c], ecx             # 00515bf3
    jne.d8 L_00515c5d                            # 00515bf6
    # block 0x00515bf8: entered by fall-through of jne at 0x00515bf6, 2 instruction(s), ends with jne to 0x00515c5d (forward)
    cmp dword ptr [ebp + arg_8], edx             # 00515bf8
    jne.d8 L_00515c5d                            # 00515bfb
    # block 0x00515bfd: entered by fall-through of jne at 0x00515bfb, 13 instruction(s), calls FUN_00515c62, ends with jbe to 0x00515c31 (forward)
    fld qword ptr [ebp + arg_10]                 # 00515bfd
    push ecx                                     # 00515c00
    push ecx                                     # 00515c01
    fstp qword ptr [esp]                         # 00515c02
    call FUN_00515c62                            # 00515c05
    fld qword ptr [ebp + arg_10]                 # 00515c0a
    fcomp qword ptr [0x52c7b0]                   # 00515c0d
    pop ecx                                      # 00515c13
    pop ecx                                      # 00515c14
    {load} mov ecx, eax                          # 00515c15
    fnstsw ax                                    # 00515c17
    sahf                                         # 00515c19
    jbe.d8 L_00515c31                            # 00515c1a
    # block 0x00515c1c: entered by fall-through of jbe at 0x00515c1a, 3 instruction(s), ends with jne to 0x00515c29 (forward)
    fld qword ptr [0x568a18]                     # 00515c1c
    cmp ecx, 0x1                                 # 00515c22
    jne.d8 L_00515c29                            # 00515c25
    # block 0x00515c27: entered by fall-through of jne at 0x00515c25, 1 instruction(s), falls into the block at 0x00515c29
    fchs                                         # 00515c27
L_00515c29:
    # block 0x00515c29: entered by jne at 0x00515c25, 3 instruction(s), ends with forward jump to 0x00515c58
    fstp qword ptr [ebp + arg_10]                # 00515c29
    fld qword ptr [ebp + arg_10]                 # 00515c2c
    jmp.d8 L_00515c58                            # 00515c2f
L_00515c31:
    # block 0x00515c31: entered by jbe at 0x00515c1a, 5 instruction(s), ends with jae to 0x00515c56 (forward)
    fld qword ptr [ebp + arg_10]                 # 00515c31
    fcomp qword ptr [0x52c7b0]                   # 00515c34
    fnstsw ax                                    # 00515c3a
    sahf                                         # 00515c3c
    jae.d8 L_00515c56                            # 00515c3d
    # block 0x00515c3f: entered by fall-through of jae at 0x00515c3d, 2 instruction(s), ends with jne to 0x00515c4c (forward)
    cmp ecx, 0x1                                 # 00515c3f
    jne.d8 L_00515c4c                            # 00515c42
    # block 0x00515c44: entered by fall-through of jne at 0x00515c42, 2 instruction(s), ends with forward jump to 0x00515c4e
    fld qword ptr [0x568a38]                     # 00515c44
    jmp.d8 L_00515c4e                            # 00515c4a
L_00515c4c:
    # block 0x00515c4c: entered by jne at 0x00515c42, 1 instruction(s), falls into the block at 0x00515c4e
    fldz                                         # 00515c4c
L_00515c4e:
    # block 0x00515c4e: entered by jmp at 0x00515c4a, 3 instruction(s), ends with forward jump to 0x00515c58
    fstp qword ptr [ebp + arg_10]                # 00515c4e
    fld qword ptr [ebp + arg_10]                 # 00515c51
    jmp.d8 L_00515c58                            # 00515c54
L_00515c56:
    # block 0x00515c56: entered by jae at 0x00515bed; jae at 0x00515c3d, 1 instruction(s), falls into the block at 0x00515c58
    fld1                                         # 00515c56
L_00515c58:
    # block 0x00515c58: entered by jmp at 0x00515bdf; jmp at 0x00515bf1; jmp at 0x00515c2f; jmp at 0x00515c54, 2 instruction(s), falls into the block at 0x00515c5d
    mov eax, dword ptr [ebp + arg_18]            # 00515c58
    fstp qword ptr [eax]                         # 00515c5b
L_00515c5d:
    # block 0x00515c5d: entered by jmp at 0x00515b90; jne at 0x00515bc5; jne at 0x00515bf6; jne at 0x00515bfb, 4 instruction(s), ends with ret
    {load} mov eax, esi                          # 00515c5d
    pop esi                                      # 00515c5f
    leave                                        # 00515c60
    ret                                          # 00515c61

