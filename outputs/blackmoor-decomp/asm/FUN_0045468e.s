# FUN_0045468e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045468e
# extent:       0x0045468e-0x004547bc (302 code bytes)
# span:         0x0045468e-0x004547bc (code 302, tables 0, padding 0)
# sha256:       6df4755a698ee7f2513bac6c10cc48a860714c6c7b04e5dd211b361e45673c70
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045468e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_b4, field_290; [ecx + n] field_b4, field_288, field_28c, field_298, field_29c; [edx + n] field_b4, field_290, field_298, field_29c, field_348
# callees:      calls FUN_0045441d, FUN_0044655e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 81 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_b4, 0xb4  # offset +0xb4
.equ field_288, 0x288  # offset +0x288
.equ field_28c, 0x28c  # offset +0x28c
.equ field_290, 0x290  # offset +0x290
.equ field_298, 0x298  # offset +0x298
.equ field_29c, 0x29c  # offset +0x29c
.equ field_348, 0x348  # offset +0x348

# --- external targets -----------------------------------------------
.set FUN_0044655e, .text + (0x0044655e - 0x401000)
.set FUN_0045441d, .text + (0x0045441d - 0x401000)

.org 0x0045468e - 0x401000
.globl FUN_0045468e
FUN_0045468e:
    # block 0x0045468e: entry, 9 instruction(s), ends with je to 0x00454741 (forward)
    push ebp                                     # 0045468e
    {load} mov ebp, esp                          # 0045468f
    sub esp, 0x28                                # 00454691
    mov dword ptr [ebp - local_14], ecx          # 00454694
    mov eax, dword ptr [ebp - local_14]          # 00454697
    mov ecx, dword ptr [ebp - local_14]          # 0045469a
    mov edx, dword ptr [eax + field_b4]          # 0045469d
    cmp edx, dword ptr [ecx + field_298]         # 004546a3
    je.d32 L_00454741                            # 004546a9
    # block 0x004546af: entered by fall-through of je at 0x004546a9, 3 instruction(s), ends with jge to 0x004546cc (forward)
    mov eax, dword ptr [ebp - local_14]          # 004546af
    cmp dword ptr [eax + field_b4], 0xb71b00     # 004546b2
    jge.d8 L_004546cc                            # 004546bc
    # block 0x004546be: entered by fall-through of jge at 0x004546bc, 4 instruction(s), ends with forward jump to 0x004546d3
    mov ecx, dword ptr [ebp - local_14]          # 004546be
    mov edx, dword ptr [ecx + field_b4]          # 004546c1
    mov dword ptr [ebp - local_18], edx          # 004546c7
    jmp.d8 L_004546d3                            # 004546ca
L_004546cc:
    # block 0x004546cc: entered by jge at 0x004546bc, 1 instruction(s), falls into the block at 0x004546d3
    mov dword ptr [ebp - local_18], 0xb71b00     # 004546cc
L_004546d3:
    # block 0x004546d3: entered by jmp at 0x004546ca, 18 instruction(s), ends with jle to 0x0045471b (forward)
    mov eax, dword ptr [ebp - local_14]          # 004546d3
    mov ecx, dword ptr [ebp - local_18]          # 004546d6
    mov dword ptr [eax + field_b4], ecx          # 004546d9
    mov edx, dword ptr [ebp - local_14]          # 004546df
    mov ecx, dword ptr [ebp - local_14]          # 004546e2
    mov eax, dword ptr [edx + field_298]         # 004546e5
    cdq                                          # 004546eb
    idiv dword ptr [ecx + field_288]             # 004546ec
    mov dword ptr [ebp - local_8], eax           # 004546f2
    mov edx, dword ptr [ebp - local_14]          # 004546f5
    mov ecx, dword ptr [ebp - local_14]          # 004546f8
    mov eax, dword ptr [edx + field_b4]          # 004546fb
    cdq                                          # 00454701
    idiv dword ptr [ecx + field_288]             # 00454702
    mov dword ptr [ebp - local_c], eax           # 00454708
    mov edx, dword ptr [ebp - local_c]           # 0045470b
    cmp edx, dword ptr [ebp - local_8]           # 0045470e
    jle.d8 L_0045471b                            # 00454711
    # block 0x00454713: entered by fall-through of jle at 0x00454711, 2 instruction(s), calls FUN_0045441d, falls into the block at 0x0045471b
    mov ecx, dword ptr [ebp - local_14]          # 00454713
    call FUN_0045441d                            # 00454716
L_0045471b:
    # block 0x0045471b: entered by jle at 0x00454711, 9 instruction(s), calls FUN_0044655e, falls into the block at 0x00454741
    mov eax, dword ptr [ebp - local_14]          # 0045471b
    mov ecx, dword ptr [eax + field_b4]          # 0045471e
    push ecx                                     # 00454724
    mov ecx, 0x638603                            # 00454725
    call FUN_0044655e                            # 0045472a
    mov edx, dword ptr [ebp - local_14]          # 0045472f
    mov eax, dword ptr [ebp - local_14]          # 00454732
    mov ecx, dword ptr [eax + field_b4]          # 00454735
    mov dword ptr [edx + field_298], ecx         # 0045473b
L_00454741:
    # block 0x00454741: entered by je at 0x004546a9, 10 instruction(s), ends with jg to 0x004547ab (forward)
    mov edx, dword ptr [ebp - local_14]          # 00454741
    mov eax, dword ptr [edx + field_348]         # 00454744
    {load} xor edx, edx                          # 0045474a
    mov ecx, 0x3e8                               # 0045474c
    div ecx                                      # 00454751
    mov dword ptr [ebp - local_4], eax           # 00454753
    mov edx, dword ptr [ebp - local_14]          # 00454756
    mov eax, dword ptr [ebp - local_4]           # 00454759
    cmp eax, dword ptr [edx + field_290]         # 0045475c
    jg.d8 L_004547ab                             # 00454762
    # block 0x00454764: entered by fall-through of jg at 0x00454762, 20 instruction(s), ends with forward jump to 0x004547b8
    mov ecx, dword ptr [ebp - local_14]          # 00454764
    fild dword ptr [ecx + field_28c]             # 00454767
    fstp dword ptr [ebp - local_1c]              # 0045476d
    mov edx, dword ptr [ebp - local_14]          # 00454770
    fild dword ptr [edx + field_290]             # 00454773
    fstp dword ptr [ebp - local_20]              # 00454779
    fld dword ptr [ebp - local_1c]               # 0045477c
    fdiv dword ptr [ebp - local_20]              # 0045477f
    fstp dword ptr [ebp - local_10]              # 00454782
    mov eax, dword ptr [ebp - local_14]          # 00454785
    fild dword ptr [eax + field_290]             # 00454788
    fstp dword ptr [ebp - local_24]              # 0045478e
    fild dword ptr [ebp - local_4]               # 00454791
    fstp dword ptr [ebp - local_28]              # 00454794
    fld dword ptr [ebp - local_24]               # 00454797
    fsub dword ptr [ebp - local_28]              # 0045479a
    fmul dword ptr [ebp - local_10]              # 0045479d
    mov ecx, dword ptr [ebp - local_14]          # 004547a0
    fstp dword ptr [ecx + field_29c]             # 004547a3
    jmp.d8 L_004547b8                            # 004547a9
L_004547ab:
    # block 0x004547ab: entered by jg at 0x00454762, 2 instruction(s), falls into the block at 0x004547b8
    mov edx, dword ptr [ebp - local_14]          # 004547ab
    mov dword ptr [edx + field_29c], 0x3f800000  # 004547ae
L_004547b8:
    # block 0x004547b8: entered by jmp at 0x004547a9, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004547b8
    pop ebp                                      # 004547ba
    ret                                          # 004547bb

