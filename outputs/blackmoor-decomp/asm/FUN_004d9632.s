# FUN_004d9632
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d9632
# extent:       0x004d9632-0x004d9910 (734 code bytes)
# span:         0x004d9632-0x004d9910 (code 734, tables 0, padding 0)
# sha256:       d59fc1717a3a141e33da85105a19a57ea011901c8496f9eb497c09f7b802c300
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d9632
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4ee, field_4f0, field_2800, field_2806, field_280e, field_2818, field_45f2, field_94d0, field_94d2, field_98a8; [ecx + n] field_4f2, field_27f8, field_2802, field_280a, field_2814, field_3266, field_94cc, field_98a8; [edx + n] field_476, field_4f4, field_4f6, field_582, field_60e, field_69a, field_27fc, field_2804, field_280c, field_2816, field_281a, field_94ce and 1 more; [esi + n] field_282a
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 154 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_476, 0x476  # offset +0x476
.equ field_4ee, 0x4ee  # offset +0x4ee
.equ field_4f0, 0x4f0  # offset +0x4f0
.equ field_4f2, 0x4f2  # offset +0x4f2
.equ field_4f4, 0x4f4  # offset +0x4f4
.equ field_4f6, 0x4f6  # offset +0x4f6
.equ field_582, 0x582  # offset +0x582
.equ field_60e, 0x60e  # offset +0x60e
.equ field_69a, 0x69a  # offset +0x69a
.equ field_27f8, 0x27f8  # offset +0x27f8
.equ field_27fc, 0x27fc  # offset +0x27fc
.equ field_2800, 0x2800  # offset +0x2800
.equ field_2802, 0x2802  # offset +0x2802
.equ field_2804, 0x2804  # offset +0x2804
.equ field_2806, 0x2806  # offset +0x2806
.equ field_280a, 0x280a  # offset +0x280a
.equ field_280c, 0x280c  # offset +0x280c
.equ field_280e, 0x280e  # offset +0x280e
.equ field_2814, 0x2814  # offset +0x2814
.equ field_2816, 0x2816  # offset +0x2816
.equ field_2818, 0x2818  # offset +0x2818
.equ field_281a, 0x281a  # offset +0x281a
.equ field_282a, 0x282a  # offset +0x282a
.equ field_3266, 0x3266  # offset +0x3266
.equ field_45f2, 0x45f2  # offset +0x45f2
.equ field_94cc, 0x94cc  # offset +0x94cc
.equ field_94ce, 0x94ce  # offset +0x94ce
.equ field_94d0, 0x94d0  # offset +0x94d0
.equ field_94d2, 0x94d2  # offset +0x94d2
.equ field_98a8, 0x98a8  # offset +0x98a8

# --- external targets -----------------------------------------------

.org 0x004d9632 - 0x401000
.globl FUN_004d9632
FUN_004d9632:
    # block 0x004d9632: entry, 11 instruction(s), ends with forward jump to 0x004d966c
    push ebp                                     # 004d9632
    {load} mov ebp, esp                          # 004d9633
    push ecx                                     # 004d9635
    push esi                                     # 004d9636
    push edi                                     # 004d9637
    mov dword ptr [ebp - local_4], ecx           # 004d9638
    mov eax, dword ptr [ebp - local_4]           # 004d963b
    mov dword ptr [eax + field_94d2], 0x1        # 004d963e
    mov ecx, dword ptr [ebp - local_4]           # 004d9648
    mov dword ptr [ecx + field_98a8], 0x0        # 004d964b
    jmp.d8 L_004d966c                            # 004d9655
L_004d9657:
    # block 0x004d9657: entered by jmp at 0x004d968f, 5 instruction(s), falls into the block at 0x004d966c
    mov edx, dword ptr [ebp - local_4]           # 004d9657
    mov eax, dword ptr [edx + field_98a8]        # 004d965a
    add eax, 0x1                                 # 004d9660
    mov ecx, dword ptr [ebp - local_4]           # 004d9663
    mov dword ptr [ecx + field_98a8], eax        # 004d9666
L_004d966c:
    # block 0x004d966c: entered by jmp at 0x004d9655, 3 instruction(s), ends with jge to 0x004d9691 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d966c
    cmp dword ptr [edx + field_98a8], 0x1e       # 004d966f
    jge.d8 L_004d9691                            # 004d9676
    # block 0x004d9678: entered by fall-through of jge at 0x004d9676, 5 instruction(s), ends with backward jump to 0x004d9657
    mov eax, dword ptr [ebp - local_4]           # 004d9678
    mov ecx, dword ptr [eax + field_98a8]        # 004d967b
    mov edx, dword ptr [ebp - local_4]           # 004d9681
    mov dword ptr [edx + 4*ecx + field_476], 0x0 # 004d9684
    jmp.d8 L_004d9657                            # 004d968f
L_004d9691:
    # block 0x004d9691: entered by jge at 0x004d9676, 11 instruction(s), ends with forward jump to 0x004d96e5
    mov eax, dword ptr [ebp - local_4]           # 004d9691
    mov word ptr [eax + field_4f0], 0x0          # 004d9694
    mov ecx, dword ptr [ebp - local_4]           # 004d969d
    mov word ptr [ecx + field_4f2], 0x0          # 004d96a0
    mov edx, dword ptr [ebp - local_4]           # 004d96a9
    mov word ptr [edx + field_4f4], 0x0          # 004d96ac
    mov eax, dword ptr [ebp - local_4]           # 004d96b5
    mov word ptr [eax + field_4ee], 0xffff       # 004d96b8
    mov ecx, dword ptr [ebp - local_4]           # 004d96c1
    mov dword ptr [ecx + field_98a8], 0x0        # 004d96c4
    jmp.d8 L_004d96e5                            # 004d96ce
L_004d96d0:
    # block 0x004d96d0: entered by jmp at 0x004d974a, 5 instruction(s), falls into the block at 0x004d96e5
    mov edx, dword ptr [ebp - local_4]           # 004d96d0
    mov eax, dword ptr [edx + field_98a8]        # 004d96d3
    add eax, 0x1                                 # 004d96d9
    mov ecx, dword ptr [ebp - local_4]           # 004d96dc
    mov dword ptr [ecx + field_98a8], eax        # 004d96df
L_004d96e5:
    # block 0x004d96e5: entered by jmp at 0x004d96ce, 3 instruction(s), ends with jge to 0x004d974c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d96e5
    cmp dword ptr [edx + field_98a8], 0x46       # 004d96e8
    jge.d8 L_004d974c                            # 004d96ef
    # block 0x004d96f1: entered by fall-through of jge at 0x004d96ef, 17 instruction(s), ends with backward jump to 0x004d96d0
    mov eax, dword ptr [ebp - local_4]           # 004d96f1
    mov ecx, dword ptr [eax + field_98a8]        # 004d96f4
    mov edx, dword ptr [ebp - local_4]           # 004d96fa
    mov dword ptr [edx + 4*ecx + field_69a], 0x0 # 004d96fd
    mov eax, dword ptr [ebp - local_4]           # 004d9708
    mov ecx, dword ptr [eax + field_98a8]        # 004d970b
    mov edx, dword ptr [ebp - local_4]           # 004d9711
    mov word ptr [edx + 2*ecx + field_4f6], 0xffff # 004d9714
    mov eax, dword ptr [ebp - local_4]           # 004d971e
    mov ecx, dword ptr [eax + field_98a8]        # 004d9721
    mov edx, dword ptr [ebp - local_4]           # 004d9727
    mov word ptr [edx + 2*ecx + field_582], 0xffff # 004d972a
    mov eax, dword ptr [ebp - local_4]           # 004d9734
    mov ecx, dword ptr [eax + field_98a8]        # 004d9737
    mov edx, dword ptr [ebp - local_4]           # 004d973d
    mov word ptr [edx + 2*ecx + field_60e], 0xffff # 004d9740
    jmp.d8 L_004d96d0                            # 004d974a
L_004d974c:
    # block 0x004d974c: entered by jge at 0x004d96ef, 3 instruction(s), ends with forward jump to 0x004d9770
    mov eax, dword ptr [ebp - local_4]           # 004d974c
    mov dword ptr [eax + field_98a8], 0x0        # 004d974f
    jmp.d8 L_004d9770                            # 004d9759
L_004d975b:
    # block 0x004d975b: entered by jmp at 0x004d9796, 5 instruction(s), falls into the block at 0x004d9770
    mov ecx, dword ptr [ebp - local_4]           # 004d975b
    mov edx, dword ptr [ecx + field_98a8]        # 004d975e
    add edx, 0x1                                 # 004d9764
    mov eax, dword ptr [ebp - local_4]           # 004d9767
    mov dword ptr [eax + field_98a8], edx        # 004d976a
L_004d9770:
    # block 0x004d9770: entered by jmp at 0x004d9759, 3 instruction(s), ends with jge to 0x004d9798 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d9770
    cmp dword ptr [ecx + field_98a8], 0x4e3      # 004d9773
    jge.d8 L_004d9798                            # 004d977d
    # block 0x004d977f: entered by fall-through of jge at 0x004d977d, 5 instruction(s), ends with backward jump to 0x004d975b
    mov edx, dword ptr [ebp - local_4]           # 004d977f
    mov eax, dword ptr [edx + field_98a8]        # 004d9782
    mov ecx, dword ptr [ebp - local_4]           # 004d9788
    mov dword ptr [ecx + 4*eax + field_3266], 0x0 # 004d978b
    jmp.d8 L_004d975b                            # 004d9796
L_004d9798:
    # block 0x004d9798: entered by jge at 0x004d977d, 3 instruction(s), ends with forward jump to 0x004d97bc
    mov edx, dword ptr [ebp - local_4]           # 004d9798
    mov dword ptr [edx + field_98a8], 0x0        # 004d979b
    jmp.d8 L_004d97bc                            # 004d97a5
L_004d97a7:
    # block 0x004d97a7: entered by jmp at 0x004d97e1, 5 instruction(s), falls into the block at 0x004d97bc
    mov eax, dword ptr [ebp - local_4]           # 004d97a7
    mov ecx, dword ptr [eax + field_98a8]        # 004d97aa
    add ecx, 0x1                                 # 004d97b0
    mov edx, dword ptr [ebp - local_4]           # 004d97b3
    mov dword ptr [edx + field_98a8], ecx        # 004d97b6
L_004d97bc:
    # block 0x004d97bc: entered by jmp at 0x004d97a5, 3 instruction(s), ends with jge to 0x004d97e3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d97bc
    cmp dword ptr [eax + field_98a8], 0x2711     # 004d97bf
    jge.d8 L_004d97e3                            # 004d97c9
    # block 0x004d97cb: entered by fall-through of jge at 0x004d97c9, 5 instruction(s), ends with backward jump to 0x004d97a7
    mov ecx, dword ptr [ebp - local_4]           # 004d97cb
    mov edx, dword ptr [ecx + field_98a8]        # 004d97ce
    mov eax, dword ptr [ebp - local_4]           # 004d97d4
    mov word ptr [eax + 2*edx + field_45f2], 0x0 # 004d97d7
    jmp.d8 L_004d97a7                            # 004d97e1
L_004d97e3:
    # block 0x004d97e3: entered by jge at 0x004d97c9, 3 instruction(s), ends with forward jump to 0x004d9807
    mov ecx, dword ptr [ebp - local_4]           # 004d97e3
    mov dword ptr [ecx + field_98a8], 0x0        # 004d97e6
    jmp.d8 L_004d9807                            # 004d97f0
L_004d97f2:
    # block 0x004d97f2: entered by jmp at 0x004d9837, 5 instruction(s), falls into the block at 0x004d9807
    mov edx, dword ptr [ebp - local_4]           # 004d97f2
    mov eax, dword ptr [edx + field_98a8]        # 004d97f5
    add eax, 0x1                                 # 004d97fb
    mov ecx, dword ptr [ebp - local_4]           # 004d97fe
    mov dword ptr [ecx + field_98a8], eax        # 004d9801
L_004d9807:
    # block 0x004d9807: entered by jmp at 0x004d97f0, 3 instruction(s), ends with jge to 0x004d9839 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d9807
    cmp dword ptr [edx + field_98a8], 0xa        # 004d980a
    jge.d8 L_004d9839                            # 004d9811
    # block 0x004d9813: entered by fall-through of jge at 0x004d9811, 10 instruction(s), ends with backward jump to 0x004d97f2
    mov ecx, 0x41                                # 004d9813
    {load} xor eax, eax                          # 004d9818
    mov edx, dword ptr [ebp - local_4]           # 004d981a
    mov edx, dword ptr [edx + field_98a8]        # 004d981d
    imul edx, edx, 0x106                         # 004d9823
    mov esi, dword ptr [ebp - local_4]           # 004d9829
    lea edi, [esi + edx + field_282a]            # 004d982c
    rep stosd dword ptr es:[edi], eax            # 004d9833
    stosw word ptr es:[edi], ax                  # 004d9835
    jmp.d8 L_004d97f2                            # 004d9837
L_004d9839:
    # block 0x004d9839: entered by jge at 0x004d9811, 41 instruction(s), calls KERNEL32.dll!GetTickCount, ends with ret
    call dword ptr [0x52a23c]                    # 004d9839
    mov ecx, dword ptr [ebp - local_4]           # 004d983f
    mov dword ptr [ecx + field_27f8], eax        # 004d9842
    mov edx, dword ptr [ebp - local_4]           # 004d9848
    mov dword ptr [edx + field_27fc], 0x0        # 004d984b
    mov eax, dword ptr [ebp - local_4]           # 004d9855
    mov word ptr [eax + field_2800], 0x0         # 004d9858
    mov ecx, dword ptr [ebp - local_4]           # 004d9861
    mov word ptr [ecx + field_2802], 0x0         # 004d9864
    mov edx, dword ptr [ebp - local_4]           # 004d986d
    mov word ptr [edx + field_2804], 0x0         # 004d9870
    mov eax, dword ptr [ebp - local_4]           # 004d9879
    mov dword ptr [eax + field_2806], 0x0        # 004d987c
    mov ecx, dword ptr [ebp - local_4]           # 004d9886
    mov word ptr [ecx + field_280a], 0x0         # 004d9889
    mov edx, dword ptr [ebp - local_4]           # 004d9892
    mov word ptr [edx + field_280c], 0x0         # 004d9895
    mov eax, dword ptr [ebp - local_4]           # 004d989e
    mov word ptr [eax + field_280e], 0x0         # 004d98a1
    mov ecx, dword ptr [ebp - local_4]           # 004d98aa
    mov word ptr [ecx + field_2814], 0x0         # 004d98ad
    mov edx, dword ptr [ebp - local_4]           # 004d98b6
    mov word ptr [edx + field_2816], 0x0         # 004d98b9
    call dword ptr [0x52a23c]                    # 004d98c2
    movsx ecx, word ptr [0x5b0280]               # 004d98c8
    {load} add eax, ecx                          # 004d98cf
    mov edx, dword ptr [ebp - local_4]           # 004d98d1
    mov dword ptr [edx + field_281a], eax        # 004d98d4
    mov eax, dword ptr [ebp - local_4]           # 004d98da
    mov word ptr [eax + field_2818], 0x0         # 004d98dd
    mov ecx, dword ptr [ebp - local_4]           # 004d98e6
    mov word ptr [ecx + field_94cc], 0x0         # 004d98e9
    mov edx, dword ptr [ebp - local_4]           # 004d98f2
    mov word ptr [edx + field_94ce], 0x0         # 004d98f5
    mov eax, dword ptr [ebp - local_4]           # 004d98fe
    mov word ptr [eax + field_94d0], 0x0         # 004d9901
    pop edi                                      # 004d990a
    pop esi                                      # 004d990b
    {load} mov esp, ebp                          # 004d990c
    pop ebp                                      # 004d990e
    ret                                          # 004d990f

