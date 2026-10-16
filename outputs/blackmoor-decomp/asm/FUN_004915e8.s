# FUN_004915e8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004915e8
# extent:       0x004915e8-0x0049173f (343 code bytes)
# span:         0x004915e8-0x0049173f (code 343, tables 0, padding 0)
# sha256:       ae56a615e9648d3776d52db3d855012ad27a834437bbe995a652f04d2b275d3b
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004915e8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_24, local_28, local_2c
# fields:       [eax + n] field_200f, field_2013; [ecx + n] field_1eeb, field_200f, field_2017; [edx + n] field_2013
# callees:      calls FUN_0051dc43, FUN_0052139c, FUN_004c97b4, FUN_004922f4, FUN_00491885, FUN_0049173f, FUN_0050e054, FUN_0050e104
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 98 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ field_1eeb, 0x1eeb  # offset +0x1eeb
.equ field_200f, 0x200f  # offset +0x200f
.equ field_2013, 0x2013  # offset +0x2013
.equ field_2017, 0x2017  # offset +0x2017

# --- external targets -----------------------------------------------
.set FUN_0049173f, .text + (0x0049173f - 0x401000)
.set FUN_00491885, .text + (0x00491885 - 0x401000)
.set FUN_004922f4, .text + (0x004922f4 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050e054, .text + (0x0050e054 - 0x401000)
.set FUN_0050e104, .text + (0x0050e104 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004915e8 - 0x401000
.globl FUN_004915e8
FUN_004915e8:
    # block 0x004915e8: entry, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049162b (forward)
    push ebp                                     # 004915e8
    {load} mov ebp, esp                          # 004915e9
    sub esp, 0x2c                                # 004915eb
    mov dword ptr [ebp - local_1c], ecx          # 004915ee
    push 0x4000                                  # 004915f1
    call FUN_0051dc43                            # 004915f6
    add esp, 0x4                                 # 004915fb
    mov dword ptr [ebp - local_10], eax          # 004915fe
    mov eax, dword ptr [ebp - local_1c]          # 00491601
    mov ecx, dword ptr [ebp - local_10]          # 00491604
    mov dword ptr [eax + field_200f], ecx        # 00491607
    cmp dword ptr [ebp - local_10], 0x0          # 0049160d
    jne.d8 L_0049162b                            # 00491611
    # block 0x00491613: entered by fall-through of jne at 0x00491611, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049162b
    push 0x0                                     # 00491613
    push 0x0                                     # 00491615
    push 0x54ed40                                # 00491617
    call FUN_0052139c                            # 0049161c
    mov ecx, 0x5cf659                            # 00491621
    call FUN_004c97b4                            # 00491626
L_0049162b:
    # block 0x0049162b: entered by jne at 0x00491611, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x00491665 (forward)
    push 0x4000                                  # 0049162b
    call FUN_0051dc43                            # 00491630
    add esp, 0x4                                 # 00491635
    mov dword ptr [ebp - local_14], eax          # 00491638
    mov edx, dword ptr [ebp - local_1c]          # 0049163b
    mov eax, dword ptr [ebp - local_14]          # 0049163e
    mov dword ptr [edx + field_2013], eax        # 00491641
    cmp dword ptr [ebp - local_14], 0x0          # 00491647
    jne.d8 L_00491665                            # 0049164b
    # block 0x0049164d: entered by fall-through of jne at 0x0049164b, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x00491665
    push 0x0                                     # 0049164d
    push 0x0                                     # 0049164f
    push 0x54ed88                                # 00491651
    call FUN_0052139c                            # 00491656
    mov ecx, 0x5cf659                            # 0049165b
    call FUN_004c97b4                            # 00491660
L_00491665:
    # block 0x00491665: entered by jne at 0x0049164b, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x0049169f (forward)
    push 0x860                                   # 00491665
    call FUN_0051dc43                            # 0049166a
    add esp, 0x4                                 # 0049166f
    mov dword ptr [ebp - local_18], eax          # 00491672
    mov ecx, dword ptr [ebp - local_1c]          # 00491675
    mov edx, dword ptr [ebp - local_18]          # 00491678
    mov dword ptr [ecx + field_2017], edx        # 0049167b
    cmp dword ptr [ebp - local_18], 0x0          # 00491681
    jne.d8 L_0049169f                            # 00491685
    # block 0x00491687: entered by fall-through of jne at 0x00491685, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x0049169f
    push 0x0                                     # 00491687
    push 0x0                                     # 00491689
    push 0x54edd0                                # 0049168b
    call FUN_0052139c                            # 00491690
    mov ecx, 0x5cf659                            # 00491695
    call FUN_004c97b4                            # 0049169a
L_0049169f:
    # block 0x0049169f: entered by jne at 0x00491685, 8 instruction(s), calls FUN_004922f4, FUN_00491885, FUN_0049173f, ends with forward jump to 0x004916c9
    mov ecx, dword ptr [ebp - local_1c]          # 0049169f
    call FUN_004922f4                            # 004916a2
    mov ecx, dword ptr [ebp - local_1c]          # 004916a7
    call FUN_00491885                            # 004916aa
    mov ecx, dword ptr [ebp - local_1c]          # 004916af
    call FUN_0049173f                            # 004916b2
    mov dword ptr [ebp - local_c], 0x0           # 004916b7
    jmp.d8 L_004916c9                            # 004916be
L_004916c0:
    # block 0x004916c0: entered by jmp at 0x00491739, 3 instruction(s), falls into the block at 0x004916c9
    mov eax, dword ptr [ebp - local_c]           # 004916c0
    add eax, 0x1                                 # 004916c3
    mov dword ptr [ebp - local_c], eax           # 004916c6
L_004916c9:
    # block 0x004916c9: entered by jmp at 0x004916be, 2 instruction(s), ends with jge to 0x0049173b (forward)
    cmp dword ptr [ebp - local_c], 0x1000        # 004916c9
    jge.d8 L_0049173b                            # 004916d0
    # block 0x004916d2: entered by fall-through of jge at 0x004916d0, 33 instruction(s), calls FUN_0050e054, FUN_0050e104, ends with backward jump to 0x004916c0
    fild dword ptr [ebp - local_c]               # 004916d2
    fstp qword ptr [ebp - local_24]              # 004916d5
    mov ecx, dword ptr [ebp - local_1c]          # 004916d8
    fld qword ptr [ebp - local_24]               # 004916db
    fmul qword ptr [ecx + field_1eeb]            # 004916de
    .insn 0xdc, 0xc0                             # 004916e4
    fdiv qword ptr [0x52db48]                    # 004916e6
    fstp qword ptr [ebp - local_8]               # 004916ec
    mov edx, dword ptr [ebp - local_4]           # 004916ef
    push edx                                     # 004916f2
    mov eax, dword ptr [ebp - local_8]           # 004916f3
    push eax                                     # 004916f6
    call FUN_0050e054                            # 004916f7
    add esp, 0x8                                 # 004916fc
    fstp dword ptr [ebp - local_28]              # 004916ff
    fld dword ptr [ebp - local_28]               # 00491702
    mov ecx, dword ptr [ebp - local_1c]          # 00491705
    mov edx, dword ptr [ecx + field_200f]        # 00491708
    mov eax, dword ptr [ebp - local_c]           # 0049170e
    fstp dword ptr [edx + 4*eax]                 # 00491711
    mov ecx, dword ptr [ebp - local_4]           # 00491714
    push ecx                                     # 00491717
    mov edx, dword ptr [ebp - local_8]           # 00491718
    push edx                                     # 0049171b
    call FUN_0050e104                            # 0049171c
    add esp, 0x8                                 # 00491721
    fstp dword ptr [ebp - local_2c]              # 00491724
    fld dword ptr [ebp - local_2c]               # 00491727
    mov eax, dword ptr [ebp - local_1c]          # 0049172a
    mov ecx, dword ptr [eax + field_2013]        # 0049172d
    mov edx, dword ptr [ebp - local_c]           # 00491733
    fstp dword ptr [ecx + 4*edx]                 # 00491736
    jmp.d8 L_004916c0                            # 00491739
L_0049173b:
    # block 0x0049173b: entered by jge at 0x004916d0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0049173b
    pop ebp                                      # 0049173d
    ret                                          # 0049173e

