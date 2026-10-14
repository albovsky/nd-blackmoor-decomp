# FUN_004f684a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f684a
# extent:       0x004f684a-0x004f6a7e (564 code bytes)
# span:         0x004f684a-0x004f6a7e (code 564, tables 0, padding 0)
# sha256:       ec0a5c5d12137f671987aea9599e247b21fbc05d82f194c3af9ded151225a56e
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # [ebp - 0x4]
.equ local_8, 0x8  # [ebp - 0x8]
.equ local_c, 0xc  # [ebp - 0xc]
.equ local_10, 0x10  # [ebp - 0x10]
.equ local_18, 0x18  # [ebp - 0x18]
.equ local_1c, 0x1c  # [ebp - 0x1c]
.equ local_20, 0x20  # [ebp - 0x20]
.equ local_28, 0x28  # [ebp - 0x28]
.equ local_2c, 0x2c  # [ebp - 0x2c]
.equ local_30, 0x30  # [ebp - 0x30]
.equ arg_8, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004f684a - 0x401000
.globl FUN_004f684a
FUN_004f684a:
    # block 0x004f684a: <unfilled>
    push ebp                                     # 004f684a
    {load} mov ebp, esp                          # 004f684b
    sub esp, 0x30                                # 004f684d
    mov dword ptr [ebp - local_8], ecx           # 004f6850
    mov eax, dword ptr [ebp - local_8]           # 004f6853
    mov dword ptr [eax + 0x3c2], 0x3e8           # 004f6856
    mov ecx, dword ptr [ebp - local_8]           # 004f6860
    mov dword ptr [ecx + 0x3ca], 0x0             # 004f6863
    mov edx, dword ptr [ebp + arg_8]             # 004f686d
    imul edx, edx, 0x5bb                         # 004f6870
    mov eax, dword ptr [ebp - local_8]           # 004f6876
    mov ecx, dword ptr [eax + 0x3ce]             # 004f6879
    {load} add ecx, edx                          # 004f687f
    mov dword ptr [ebp - local_4], ecx           # 004f6881
    mov ecx, dword ptr [ebp - local_8]           # 004f6884
    call FUN_004f709c                            # 004f6887
    test eax, eax                                # 004f688c
    jne.d8 L_004f68b8                            # 004f688e
    # block 0x004f6890: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 004f6890
    mov dword ptr [edx + 0x3c2], 0x3ea           # 004f6893
    mov eax, dword ptr [ebp - local_8]           # 004f689d
    mov dword ptr [eax + 0x3be], 0x0             # 004f68a0
    mov ecx, dword ptr [ebp - local_8]           # 004f68aa
    mov eax, dword ptr [ecx + 0x3be]             # 004f68ad
    jmp.d32 L_004f6a78                           # 004f68b3
L_004f68b8:
    # block 0x004f68b8: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004f68b8
    cmp dword ptr [edx + 0x28f], 0x0             # 004f68bb
    jne.d8 L_004f68ec                            # 004f68c2
    # block 0x004f68c4: <unfilled>
    mov eax, dword ptr [ebp - local_8]           # 004f68c4
    mov dword ptr [eax + 0x3c2], 0x3ef           # 004f68c7
    mov ecx, dword ptr [ebp - local_8]           # 004f68d1
    mov dword ptr [ecx + 0x3be], 0x0             # 004f68d4
    mov edx, dword ptr [ebp - local_8]           # 004f68de
    mov eax, dword ptr [edx + 0x3be]             # 004f68e1
    jmp.d32 L_004f6a78                           # 004f68e7
L_004f68ec:
    # block 0x004f68ec: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004f68ec
    cmp dword ptr [eax + 0x13c], 0x0             # 004f68ef
    jge.d8 L_004f6906                            # 004f68f6
    # block 0x004f68f8: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004f68f8
    mov edx, dword ptr [ecx + 0x13c]             # 004f68fb
    mov dword ptr [ebp - local_c], edx           # 004f6901
    jmp.d8 L_004f690d                            # 004f6904
L_004f6906:
    # block 0x004f6906: <unfilled>
    mov dword ptr [ebp - local_c], 0x0           # 004f6906
L_004f690d:
    # block 0x004f690d: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004f690d
    mov ecx, dword ptr [ebp - local_c]           # 004f6910
    mov dword ptr [eax + 0x13c], ecx             # 004f6913
    mov edx, dword ptr [ebp - local_4]           # 004f6919
    cmp dword ptr [edx + 0x140], 0x0             # 004f691c
    jge.d8 L_004f6933                            # 004f6923
    # block 0x004f6925: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004f6925
    mov ecx, dword ptr [eax + 0x140]             # 004f6928
    mov dword ptr [ebp - local_10], ecx          # 004f692e
    jmp.d8 L_004f693a                            # 004f6931
L_004f6933:
    # block 0x004f6933: <unfilled>
    mov dword ptr [ebp - local_10], 0x0          # 004f6933
L_004f693a:
    # block 0x004f693a: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004f693a
    mov eax, dword ptr [ebp - local_10]          # 004f693d
    mov dword ptr [edx + 0x140], eax             # 004f6940
    mov ecx, dword ptr [ebp - local_4]           # 004f6946
    fild dword ptr [ecx + 0x13c]                 # 004f6949
    fstp qword ptr [ebp - local_18]              # 004f694f
    fld qword ptr [ebp - local_18]               # 004f6952
    fcomp qword ptr [0x52e4d8]                   # 004f6955
    fnstsw ax                                    # 004f695b
    test ah, 0x41                                # 004f695d
    jne.d8 L_004f6970                            # 004f6960
    # block 0x004f6962: <unfilled>
    mov edx, dword ptr [ebp - local_4]           # 004f6962
    fild dword ptr [edx + 0x13c]                 # 004f6965
    fstp qword ptr [ebp - local_20]              # 004f696b
    jmp.d8 L_004f697e                            # 004f696e
L_004f6970:
    # block 0x004f6970: <unfilled>
    mov dword ptr [ebp - local_20], 0x24924924   # 004f6970
    mov dword ptr [ebp - local_1c], 0xc0a65249   # 004f6977
L_004f697e:
    # block 0x004f697e: <unfilled>
    fld qword ptr [ebp - local_20]               # 004f697e
    call FUN_0050ce04                            # 004f6981
    mov ecx, dword ptr [ebp - local_4]           # 004f6986
    mov dword ptr [ecx + 0x13c], eax             # 004f6989
    mov edx, dword ptr [ebp - local_4]           # 004f698f
    fild dword ptr [edx + 0x140]                 # 004f6992
    fstp qword ptr [ebp - local_28]              # 004f6998
    fld qword ptr [ebp - local_28]               # 004f699b
    fcomp qword ptr [0x52e4d8]                   # 004f699e
    fnstsw ax                                    # 004f69a4
    test ah, 0x41                                # 004f69a6
    jne.d8 L_004f69b9                            # 004f69a9
    # block 0x004f69ab: <unfilled>
    mov eax, dword ptr [ebp - local_4]           # 004f69ab
    fild dword ptr [eax + 0x140]                 # 004f69ae
    fstp qword ptr [ebp - local_30]              # 004f69b4
    jmp.d8 L_004f69c7                            # 004f69b7
L_004f69b9:
    # block 0x004f69b9: <unfilled>
    mov dword ptr [ebp - local_30], 0x24924924   # 004f69b9
    mov dword ptr [ebp - local_2c], 0xc0a65249   # 004f69c0
L_004f69c7:
    # block 0x004f69c7: <unfilled>
    fld qword ptr [ebp - local_30]               # 004f69c7
    call FUN_0050ce04                            # 004f69ca
    mov ecx, dword ptr [ebp - local_4]           # 004f69cf
    mov dword ptr [ecx + 0x140], eax             # 004f69d2
    mov edx, dword ptr [ebp - local_4]           # 004f69d8
    mov eax, dword ptr [edx + 0x13c]             # 004f69db
    push eax                                     # 004f69e1
    mov ecx, dword ptr [ebp - local_4]           # 004f69e2
    mov edx, dword ptr [ecx + 0x28f]             # 004f69e5
    mov eax, dword ptr [ebp - local_4]           # 004f69eb
    mov ecx, dword ptr [eax + 0x28f]             # 004f69ee
    mov eax, dword ptr [ecx]                     # 004f69f4
    push edx                                     # 004f69f6
    call dword ptr [eax + 0x3c]                  # 004f69f7
    mov ecx, dword ptr [ebp - local_8]           # 004f69fa
    mov dword ptr [ecx + 0x3ca], eax             # 004f69fd
    mov edx, dword ptr [ebp - local_8]           # 004f6a03
    cmp dword ptr [edx + 0x3ca], 0x0             # 004f6a06
    jne.d8 L_004f6a55                            # 004f6a0d
    # block 0x004f6a0f: <unfilled>
    movsx eax, word ptr [0x63a4cd]               # 004f6a0f
    test eax, eax                                # 004f6a16
    je.d8 L_004f6a4e                             # 004f6a18
    # block 0x004f6a1a: <unfilled>
    mov ecx, dword ptr [ebp - local_4]           # 004f6a1a
    add ecx, 0x4                                 # 004f6a1d
    push ecx                                     # 004f6a20
    mov edx, dword ptr [ebp + arg_8]             # 004f6a21
    push edx                                     # 004f6a24
    mov eax, dword ptr [ebp - local_4]           # 004f6a25
    mov ecx, dword ptr [eax + 0x13c]             # 004f6a28
    push ecx                                     # 004f6a2e
    push 0x55e8fc                                # 004f6a2f
    push 0x63888b                                # 004f6a34
    call FUN_0050ca3e                            # 004f6a39
    add esp, 0x14                                # 004f6a3e
    push 0x63888b                                # 004f6a41
    call FUN_0044a2b7                            # 004f6a46
    add esp, 0x4                                 # 004f6a4b
L_004f6a4e:
    # block 0x004f6a4e: <unfilled>
    mov eax, 0x1                                 # 004f6a4e
    jmp.d8 L_004f6a78                            # 004f6a53
L_004f6a55:
    # block 0x004f6a55: <unfilled>
    mov edx, dword ptr [ebp - local_8]           # 004f6a55
    mov dword ptr [edx + 0x3c2], 0x408           # 004f6a58
    mov eax, dword ptr [ebp - local_8]           # 004f6a62
    mov dword ptr [eax + 0x3be], 0x0             # 004f6a65
    mov ecx, dword ptr [ebp - local_8]           # 004f6a6f
    mov eax, dword ptr [ecx + 0x3be]             # 004f6a72
L_004f6a78:
    # block 0x004f6a78: <unfilled>
    {load} mov esp, ebp                          # 004f6a78
    pop ebp                                      # 004f6a7a
    ret 0x4                                      # 004f6a7b
