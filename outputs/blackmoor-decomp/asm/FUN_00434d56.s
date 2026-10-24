# FUN_00434d56
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00434d56
# extent:       0x00434d56-0x00435015 (703 code bytes)
# span:         0x00434d56-0x00435015 (code 703, tables 0, padding 0)
# sha256:       d77b2010abeae83f65671fa9465e1f69109facaa2a784aba7632404c24630c7a
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m434d56_lifted
# naming:       native port src/original_methods_fl40.c:m434d56_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 8 seeds; oracle 216/216 instructions, 22/22 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       30 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34 and 18 more
# fields:       [eax + n] field_1; [edx + n] field_1
# callees:      calls FUN_0051ea75, KERNEL32.dll!GetPrivateProfileStringA, FUN_0051eac4, FUN_0051e8f7, FUN_00519acb, FUN_0050da98, FUN_00519b47, FUN_0051e7ba, FUN_00519c12, FUN_0051ea21, FUN_0051ea5d, FUN_0051e8a7, FUN_0050d960
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m434d56_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 216 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
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
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_5d, 0x5d  # offset -0x5d
.equ local_5e, 0x5e  # offset -0x5e
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050d960, .text + (0x0050d960 - 0x401000)
.set FUN_0050da98, .text + (0x0050da98 - 0x401000)
.set FUN_00519acb, .text + (0x00519acb - 0x401000)
.set FUN_00519b47, .text + (0x00519b47 - 0x401000)
.set FUN_00519c12, .text + (0x00519c12 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051e8a7, .text + (0x0051e8a7 - 0x401000)
.set FUN_0051e8f7, .text + (0x0051e8f7 - 0x401000)
.set FUN_0051ea21, .text + (0x0051ea21 - 0x401000)
.set FUN_0051ea5d, .text + (0x0051ea5d - 0x401000)
.set FUN_0051ea75, .text + (0x0051ea75 - 0x401000)
.set FUN_0051eac4, .text + (0x0051eac4 - 0x401000)

.org 0x00434d56 - 0x401000
.globl FUN_00434d56
FUN_00434d56:
    # block 0x00434d56: entry, 33 instruction(s), calls FUN_0051ea75, KERNEL32.dll!GetPrivateProfileStringA, FUN_0051eac4, falls into the block at 0x00434dce
    push ebp                                     # 00434d56
    {load} mov ebp, esp                          # 00434d57
    push -0x1                                    # 00434d59
    push 0x527e44                                # 00434d5b
    mov eax, dword ptr fs:[0x0]                  # 00434d60
    push eax                                     # 00434d66
    mov dword ptr fs:[0x0], esp                  # 00434d67
    sub esp, 0x6c                                # 00434d6e
    mov eax, dword ptr [0x5679b0]                # 00434d71
    mov dword ptr [ebp - local_14], eax          # 00434d76
    mov dword ptr [ebp - local_4], 0x0           # 00434d79
    mov ecx, dword ptr [0x5679b0]                # 00434d80
    mov dword ptr [ebp - local_10], ecx          # 00434d86
    mov byte ptr [ebp - local_4], 0x1            # 00434d89
    push 0x639897                                # 00434d8d
    push 0x104                                   # 00434d92
    push 0x104                                   # 00434d97
    lea ecx, [ebp - local_14]                    # 00434d9c
    call FUN_0051ea75                            # 00434d9f
    push eax                                     # 00434da4
    mov edx, dword ptr [ebp + arg_c]             # 00434da5
    push edx                                     # 00434da8
    mov eax, dword ptr [ebp + arg_8]             # 00434da9
    push eax                                     # 00434dac
    push 0x5462fc                                # 00434dad
    call dword ptr [0x52a298]                    # 00434db2
    push -0x1                                    # 00434db8
    lea ecx, [ebp - local_14]                    # 00434dba
    call FUN_0051eac4                            # 00434dbd
    mov ecx, dword ptr [ebp - local_14]          # 00434dc2
    mov dword ptr [ebp - local_58], ecx          # 00434dc5
    mov edx, dword ptr [ebp + arg_c]             # 00434dc8
    mov dword ptr [ebp - local_5c], edx          # 00434dcb
L_00434dce:
    # block 0x00434dce: entered by jne at 0x00434e00, 6 instruction(s), ends with jne to 0x00434e0b (forward)
    mov eax, dword ptr [ebp - local_5c]          # 00434dce
    mov cl, byte ptr [eax]                       # 00434dd1
    mov byte ptr [ebp - local_5d], cl            # 00434dd3
    mov edx, dword ptr [ebp - local_58]          # 00434dd6
    cmp cl, byte ptr [edx]                       # 00434dd9
    jne.d8 L_00434e0b                            # 00434ddb
    # block 0x00434ddd: entered by fall-through of jne at 0x00434ddb, 2 instruction(s), ends with je to 0x00434e02 (forward)
    cmp byte ptr [ebp - local_5d], 0x0           # 00434ddd
    je.d8 L_00434e02                             # 00434de1
    # block 0x00434de3: entered by fall-through of je at 0x00434de1, 6 instruction(s), ends with jne to 0x00434e0b (forward)
    mov eax, dword ptr [ebp - local_5c]          # 00434de3
    mov cl, byte ptr [eax + field_1]             # 00434de6
    mov byte ptr [ebp - local_5e], cl            # 00434de9
    mov edx, dword ptr [ebp - local_58]          # 00434dec
    cmp cl, byte ptr [edx + field_1]             # 00434def
    jne.d8 L_00434e0b                            # 00434df2
    # block 0x00434df4: entered by fall-through of jne at 0x00434df2, 4 instruction(s), ends with jne to 0x00434dce (backward)
    add dword ptr [ebp - local_5c], 0x2          # 00434df4
    add dword ptr [ebp - local_58], 0x2          # 00434df8
    cmp byte ptr [ebp - local_5e], 0x0           # 00434dfc
    jne.d8 L_00434dce                            # 00434e00
L_00434e02:
    # block 0x00434e02: entered by je at 0x00434de1; fall-through of jne at 0x00434e00, 2 instruction(s), ends with forward jump to 0x00434e13
    mov dword ptr [ebp - local_64], 0x0          # 00434e02
    jmp.d8 L_00434e13                            # 00434e09
L_00434e0b:
    # block 0x00434e0b: entered by jne at 0x00434ddb; jne at 0x00434df2, 3 instruction(s), falls into the block at 0x00434e13
    {load} sbb eax, eax                          # 00434e0b
    sbb eax, -0x1                                # 00434e0d
    mov dword ptr [ebp - local_64], eax          # 00434e10
L_00434e13:
    # block 0x00434e13: entered by jmp at 0x00434e09, 4 instruction(s), ends with jne to 0x00434fcc (forward)
    mov ecx, dword ptr [ebp - local_64]          # 00434e13
    mov dword ptr [ebp - local_68], ecx          # 00434e16
    cmp dword ptr [ebp - local_68], 0x0          # 00434e19
    jne.d32 L_00434fcc                           # 00434e1d
    # block 0x00434e23: entered by fall-through of jne at 0x00434e1d, 26 instruction(s), calls FUN_0051e8f7, FUN_00519acb, FUN_0050da98, ends with je to 0x00434ec2 (forward)
    push 0x63a2c5                                # 00434e23
    lea ecx, [ebp - local_10]                    # 00434e28
    call FUN_0051e8f7                            # 00434e2b
    push 0x1                                     # 00434e30
    lea edx, [ebp - local_1c]                    # 00434e32
    push edx                                     # 00434e35
    lea ecx, [ebp - local_10]                    # 00434e36
    call FUN_00519acb                            # 00434e39
    mov dword ptr [ebp - local_6c], eax          # 00434e3e
    mov eax, dword ptr [ebp - local_6c]          # 00434e41
    mov dword ptr [ebp - local_3c], eax          # 00434e44
    mov byte ptr [ebp - local_4], 0x2            # 00434e47
    mov ecx, dword ptr [ebp - local_3c]          # 00434e4b
    mov edx, dword ptr [ecx]                     # 00434e4e
    mov dword ptr [ebp - local_38], edx          # 00434e50
    push 0x546308                                # 00434e53
    mov eax, dword ptr [ebp - local_38]          # 00434e58
    push eax                                     # 00434e5b
    call FUN_0050da98                            # 00434e5c
    add esp, 0x8                                 # 00434e61
    neg eax                                      # 00434e64
    {load} sbb eax, eax                          # 00434e66
    inc eax                                      # 00434e68
    and eax, 0xff                                # 00434e69
    test eax, eax                                # 00434e6e
    je.d8 L_00434ec2                             # 00434e70
    # block 0x00434e72: entered by fall-through of je at 0x00434e70, 24 instruction(s), calls FUN_00519b47, FUN_0050da98, FUN_0051e7ba, ends with je to 0x00434ec2 (forward)
    push 0x1                                     # 00434e72
    lea ecx, [ebp - local_24]                    # 00434e74
    push ecx                                     # 00434e77
    lea ecx, [ebp - local_14]                    # 00434e78
    call FUN_00519b47                            # 00434e7b
    mov dword ptr [ebp - local_44], eax          # 00434e80
    mov edx, dword ptr [ebp - local_44]          # 00434e83
    mov eax, dword ptr [edx]                     # 00434e86
    mov dword ptr [ebp - local_40], eax          # 00434e88
    push 0x54630c                                # 00434e8b
    mov ecx, dword ptr [ebp - local_40]          # 00434e90
    push ecx                                     # 00434e93
    call FUN_0050da98                            # 00434e94
    add esp, 0x8                                 # 00434e99
    neg eax                                      # 00434e9c
    {load} sbb eax, eax                          # 00434e9e
    inc eax                                      # 00434ea0
    mov byte ptr [ebp - local_20], al            # 00434ea1
    lea ecx, [ebp - local_24]                    # 00434ea4
    call FUN_0051e7ba                            # 00434ea7
    mov edx, dword ptr [ebp - local_20]          # 00434eac
    and edx, 0xff                                # 00434eaf
    test edx, edx                                # 00434eb5
    je.d8 L_00434ec2                             # 00434eb7
    # block 0x00434eb9: entered by fall-through of je at 0x00434eb7, 2 instruction(s), ends with forward jump to 0x00434ec9
    mov dword ptr [ebp - local_70], 0x1          # 00434eb9
    jmp.d8 L_00434ec9                            # 00434ec0
L_00434ec2:
    # block 0x00434ec2: entered by je at 0x00434e70; je at 0x00434eb7, 1 instruction(s), falls into the block at 0x00434ec9
    mov dword ptr [ebp - local_70], 0x0          # 00434ec2
L_00434ec9:
    # block 0x00434ec9: entered by jmp at 0x00434ec0, 9 instruction(s), calls FUN_0051e7ba, ends with je to 0x00434ef7 (forward)
    mov al, byte ptr [ebp - local_70]            # 00434ec9
    mov byte ptr [ebp - local_18], al            # 00434ecc
    mov byte ptr [ebp - local_4], 0x1            # 00434ecf
    lea ecx, [ebp - local_1c]                    # 00434ed3
    call FUN_0051e7ba                            # 00434ed6
    mov ecx, dword ptr [ebp - local_18]          # 00434edb
    and ecx, 0xff                                # 00434ede
    test ecx, ecx                                # 00434ee4
    je.d8 L_00434ef7                             # 00434ee6
    # block 0x00434ee8: entered by fall-through of je at 0x00434ee6, 4 instruction(s), calls FUN_00519c12, ends with forward jump to 0x00434fbe
    push 0x5c                                    # 00434ee8
    lea ecx, [ebp - local_10]                    # 00434eea
    call FUN_00519c12                            # 00434eed
    jmp.d32 L_00434fbe                           # 00434ef2
L_00434ef7:
    # block 0x00434ef7: entered by je at 0x00434ee6, 23 instruction(s), calls FUN_00519acb, FUN_0050da98, ends with je to 0x00434f8b (forward)
    push 0x1                                     # 00434ef7
    lea edx, [ebp - local_2c]                    # 00434ef9
    push edx                                     # 00434efc
    lea ecx, [ebp - local_10]                    # 00434efd
    call FUN_00519acb                            # 00434f00
    mov dword ptr [ebp - local_74], eax          # 00434f05
    mov eax, dword ptr [ebp - local_74]          # 00434f08
    mov dword ptr [ebp - local_4c], eax          # 00434f0b
    mov byte ptr [ebp - local_4], 0x3            # 00434f0e
    mov ecx, dword ptr [ebp - local_4c]          # 00434f12
    mov edx, dword ptr [ecx]                     # 00434f15
    mov dword ptr [ebp - local_48], edx          # 00434f17
    push 0x546310                                # 00434f1a
    mov eax, dword ptr [ebp - local_48]          # 00434f1f
    push eax                                     # 00434f22
    call FUN_0050da98                            # 00434f23
    add esp, 0x8                                 # 00434f28
    neg eax                                      # 00434f2b
    {load} sbb eax, eax                          # 00434f2d
    neg eax                                      # 00434f2f
    and eax, 0xff                                # 00434f31
    test eax, eax                                # 00434f36
    je.d8 L_00434f8b                             # 00434f38
    # block 0x00434f3a: entered by fall-through of je at 0x00434f38, 24 instruction(s), calls FUN_00519b47, FUN_0050da98, FUN_0051e7ba, ends with je to 0x00434f8b (forward)
    push 0x1                                     # 00434f3a
    lea ecx, [ebp - local_34]                    # 00434f3c
    push ecx                                     # 00434f3f
    lea ecx, [ebp - local_14]                    # 00434f40
    call FUN_00519b47                            # 00434f43
    mov dword ptr [ebp - local_54], eax          # 00434f48
    mov edx, dword ptr [ebp - local_54]          # 00434f4b
    mov eax, dword ptr [edx]                     # 00434f4e
    mov dword ptr [ebp - local_50], eax          # 00434f50
    push 0x546314                                # 00434f53
    mov ecx, dword ptr [ebp - local_50]          # 00434f58
    push ecx                                     # 00434f5b
    call FUN_0050da98                            # 00434f5c
    add esp, 0x8                                 # 00434f61
    neg eax                                      # 00434f64
    {load} sbb eax, eax                          # 00434f66
    neg eax                                      # 00434f68
    mov byte ptr [ebp - local_30], al            # 00434f6a
    lea ecx, [ebp - local_34]                    # 00434f6d
    call FUN_0051e7ba                            # 00434f70
    mov edx, dword ptr [ebp - local_30]          # 00434f75
    and edx, 0xff                                # 00434f78
    test edx, edx                                # 00434f7e
    je.d8 L_00434f8b                             # 00434f80
    # block 0x00434f82: entered by fall-through of je at 0x00434f80, 2 instruction(s), ends with forward jump to 0x00434f92
    mov dword ptr [ebp - local_78], 0x1          # 00434f82
    jmp.d8 L_00434f92                            # 00434f89
L_00434f8b:
    # block 0x00434f8b: entered by je at 0x00434f38; je at 0x00434f80, 1 instruction(s), falls into the block at 0x00434f92
    mov dword ptr [ebp - local_78], 0x0          # 00434f8b
L_00434f92:
    # block 0x00434f92: entered by jmp at 0x00434f89, 9 instruction(s), calls FUN_0051e7ba, ends with je to 0x00434fbe (forward)
    mov al, byte ptr [ebp - local_78]            # 00434f92
    mov byte ptr [ebp - local_28], al            # 00434f95
    mov byte ptr [ebp - local_4], 0x1            # 00434f98
    lea ecx, [ebp - local_2c]                    # 00434f9c
    call FUN_0051e7ba                            # 00434f9f
    mov ecx, dword ptr [ebp - local_28]          # 00434fa4
    and ecx, 0xff                                # 00434fa7
    test ecx, ecx                                # 00434fad
    je.d8 L_00434fbe                             # 00434faf
    # block 0x00434fb1: entered by fall-through of je at 0x00434faf, 3 instruction(s), calls FUN_0051ea21, falls into the block at 0x00434fbe
    push 0x546318                                # 00434fb1
    lea ecx, [ebp - local_10]                    # 00434fb6
    call FUN_0051ea21                            # 00434fb9
L_00434fbe:
    # block 0x00434fbe: entered by jmp at 0x00434ef2; je at 0x00434faf, 5 instruction(s), calls FUN_0051ea5d, ends with forward jump to 0x00434fd8
    lea edx, [ebp - local_14]                    # 00434fbe
    push edx                                     # 00434fc1
    lea ecx, [ebp - local_10]                    # 00434fc2
    call FUN_0051ea5d                            # 00434fc5
    jmp.d8 L_00434fd8                            # 00434fca
L_00434fcc:
    # block 0x00434fcc: entered by jne at 0x00434e1d, 4 instruction(s), calls FUN_0051e8a7, falls into the block at 0x00434fd8
    lea eax, [ebp - local_14]                    # 00434fcc
    push eax                                     # 00434fcf
    lea ecx, [ebp - local_10]                    # 00434fd0
    call FUN_0051e8a7                            # 00434fd3
L_00434fd8:
    # block 0x00434fd8: entered by jmp at 0x00434fca, 19 instruction(s), calls FUN_0050d960, FUN_0051e7ba, ends with ret
    mov ecx, dword ptr [ebp + arg_14]            # 00434fd8
    push ecx                                     # 00434fdb
    mov edx, dword ptr [ebp - local_10]          # 00434fdc
    push edx                                     # 00434fdf
    mov eax, dword ptr [ebp + arg_10]            # 00434fe0
    push eax                                     # 00434fe3
    call FUN_0050d960                            # 00434fe4
    add esp, 0xc                                 # 00434fe9
    mov byte ptr [ebp - local_4], 0x0            # 00434fec
    lea ecx, [ebp - local_10]                    # 00434ff0
    call FUN_0051e7ba                            # 00434ff3
    mov dword ptr [ebp - local_4], 0xffffffff    # 00434ff8
    lea ecx, [ebp - local_14]                    # 00434fff
    call FUN_0051e7ba                            # 00435002
    mov ecx, dword ptr [ebp - local_c]           # 00435007
    mov dword ptr fs:[0x0], ecx                  # 0043500a
    {load} mov esp, ebp                          # 00435011
    pop ebp                                      # 00435013
    ret                                          # 00435014

