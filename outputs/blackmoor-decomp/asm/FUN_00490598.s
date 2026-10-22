# FUN_00490598
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00490598
# extent:       0x00490598-0x00490d50 (1976 code bytes)
# span:         0x00490598-0x00490d50 (code 1976, tables 0, padding 0)
# sha256:       8c65472f2409b6549f4e977b766abdf468b54b743846b0d2bedbb5c98eb00ca0
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00490598
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_1eeb, field_1eef, field_1f07, field_1f13, field_1f1f, field_1f2b, field_1f37, field_1f3b, field_1f3f, field_1f4f, field_1f5b, field_1f67 and 28 more; [ecx + n] field_1e, field_1eff, field_1f0b, field_1f17, field_1f23, field_1f27, field_1f2f, field_1f3b, field_1f47, field_1f53, field_1f5f, field_1f6f and 21 more; [edx + n] field_1c, field_1eeb, field_1f03, field_1f0f, field_1f1b, field_1f33, field_1f43, field_1f4b, field_1f57, field_1f63, field_1f73, field_1f7f and 25 more
# callees:      calls FUN_0050df94
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 401 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_1eeb, 0x1eeb  # offset +0x1eeb
.equ field_1eef, 0x1eef  # offset +0x1eef
.equ field_1eff, 0x1eff  # offset +0x1eff
.equ field_1f03, 0x1f03  # offset +0x1f03
.equ field_1f07, 0x1f07  # offset +0x1f07
.equ field_1f0b, 0x1f0b  # offset +0x1f0b
.equ field_1f0f, 0x1f0f  # offset +0x1f0f
.equ field_1f13, 0x1f13  # offset +0x1f13
.equ field_1f17, 0x1f17  # offset +0x1f17
.equ field_1f1b, 0x1f1b  # offset +0x1f1b
.equ field_1f1f, 0x1f1f  # offset +0x1f1f
.equ field_1f23, 0x1f23  # offset +0x1f23
.equ field_1f27, 0x1f27  # offset +0x1f27
.equ field_1f2b, 0x1f2b  # offset +0x1f2b
.equ field_1f2f, 0x1f2f  # offset +0x1f2f
.equ field_1f33, 0x1f33  # offset +0x1f33
.equ field_1f37, 0x1f37  # offset +0x1f37
.equ field_1f3b, 0x1f3b  # offset +0x1f3b
.equ field_1f3f, 0x1f3f  # offset +0x1f3f
.equ field_1f43, 0x1f43  # offset +0x1f43
.equ field_1f47, 0x1f47  # offset +0x1f47
.equ field_1f4b, 0x1f4b  # offset +0x1f4b
.equ field_1f4f, 0x1f4f  # offset +0x1f4f
.equ field_1f53, 0x1f53  # offset +0x1f53
.equ field_1f57, 0x1f57  # offset +0x1f57
.equ field_1f5b, 0x1f5b  # offset +0x1f5b
.equ field_1f5f, 0x1f5f  # offset +0x1f5f
.equ field_1f63, 0x1f63  # offset +0x1f63
.equ field_1f67, 0x1f67  # offset +0x1f67
.equ field_1f6f, 0x1f6f  # offset +0x1f6f
.equ field_1f73, 0x1f73  # offset +0x1f73
.equ field_1f77, 0x1f77  # offset +0x1f77
.equ field_1f7f, 0x1f7f  # offset +0x1f7f
.equ field_200b, 0x200b  # offset +0x200b
.equ field_200f, 0x200f  # offset +0x200f
.equ field_2013, 0x2013  # offset +0x2013
.equ field_2017, 0x2017  # offset +0x2017
.equ field_201b, 0x201b  # offset +0x201b
.equ field_2035, 0x2035  # offset +0x2035
.equ field_2039, 0x2039  # offset +0x2039
.equ field_2095, 0x2095  # offset +0x2095
.equ field_2099, 0x2099  # offset +0x2099
.equ field_209d, 0x209d  # offset +0x209d
.equ field_20a1, 0x20a1  # offset +0x20a1
.equ field_20a5, 0x20a5  # offset +0x20a5
.equ field_20a9, 0x20a9  # offset +0x20a9
.equ field_20ad, 0x20ad  # offset +0x20ad
.equ field_20b1, 0x20b1  # offset +0x20b1
.equ field_20b5, 0x20b5  # offset +0x20b5
.equ field_20b9, 0x20b9  # offset +0x20b9
.equ field_20bd, 0x20bd  # offset +0x20bd
.equ field_20c1, 0x20c1  # offset +0x20c1
.equ field_20e5, 0x20e5  # offset +0x20e5
.equ field_2239, 0x2239  # offset +0x2239
.equ field_22d9, 0x22d9  # offset +0x22d9
.equ field_242d, 0x242d  # offset +0x242d
.equ field_2491, 0x2491  # offset +0x2491
.equ field_2f31, 0x2f31  # offset +0x2f31
.equ field_3431, 0x3431  # offset +0x3431
.equ field_3ed1, 0x3ed1  # offset +0x3ed1
.equ field_41f1, 0x41f1  # offset +0x41f1
.equ field_4345, 0x4345  # offset +0x4345
.equ field_43e5, 0x43e5  # offset +0x43e5
.equ field_4539, 0x4539  # offset +0x4539
.equ field_459d, 0x459d  # offset +0x459d
.equ field_45a5, 0x45a5  # offset +0x45a5
.equ field_45a9, 0x45a9  # offset +0x45a9
.equ field_45b1, 0x45b1  # offset +0x45b1
.equ field_45b9, 0x45b9  # offset +0x45b9
.equ field_45bd, 0x45bd  # offset +0x45bd
.equ field_45c1, 0x45c1  # offset +0x45c1
.equ field_4765, 0x4765  # offset +0x4765
.equ field_4769, 0x4769  # offset +0x4769
.equ field_476d, 0x476d  # offset +0x476d
.equ field_4781, 0x4781  # offset +0x4781
.equ field_4785, 0x4785  # offset +0x4785
.equ field_4789, 0x4789  # offset +0x4789
.equ field_478d, 0x478d  # offset +0x478d
.equ field_4791, 0x4791  # offset +0x4791
.equ field_4795, 0x4795  # offset +0x4795
.equ field_47a9, 0x47a9  # offset +0x47a9
.equ field_47ed, 0x47ed  # offset +0x47ed
.equ field_47f1, 0x47f1  # offset +0x47f1
.equ field_47f5, 0x47f5  # offset +0x47f5
.equ field_47f9, 0x47f9  # offset +0x47f9
.equ field_47fd, 0x47fd  # offset +0x47fd
.equ field_4801, 0x4801  # offset +0x4801
.equ field_4805, 0x4805  # offset +0x4805
.equ field_4809, 0x4809  # offset +0x4809
.equ field_480d, 0x480d  # offset +0x480d
.equ field_4811, 0x4811  # offset +0x4811
.equ field_4815, 0x4815  # offset +0x4815
.equ field_4819, 0x4819  # offset +0x4819
.equ field_50f3, 0x50f3  # offset +0x50f3
.equ field_50f7, 0x50f7  # offset +0x50f7
.equ field_50fb, 0x50fb  # offset +0x50fb
.equ field_50fc, 0x50fc  # offset +0x50fc
.equ field_50fd, 0x50fd  # offset +0x50fd

# --- external targets -----------------------------------------------
.set FUN_0050df94, .text + (0x0050df94 - 0x401000)

.org 0x00490598 - 0x401000
.globl FUN_00490598
FUN_00490598:
    # block 0x00490598: entry, 266 instruction(s), calls FUN_0050df94, ends with forward jump to 0x00490b39
    push ebp                                     # 00490598
    {load} mov ebp, esp                          # 00490599
    sub esp, 0x18                                # 0049059b
    mov dword ptr [ebp - local_c], ecx           # 0049059e
    mov eax, dword ptr [ebp - local_c]           # 004905a1
    mov dword ptr [eax + field_200b], 0x0        # 004905a4
    mov ecx, dword ptr [ebp - local_c]           # 004905ae
    mov word ptr [ecx + field_1e], 0xffff        # 004905b1
    mov edx, dword ptr [ebp - local_c]           # 004905b7
    mov word ptr [edx + field_1c], 0xffff        # 004905ba
    mov eax, dword ptr [ebp - local_c]           # 004905c0
    mov dword ptr [eax + field_1f77], 0x0        # 004905c3
    mov ecx, dword ptr [ebp - local_c]           # 004905cd
    mov dword ptr [ecx + field_4769], 0x0        # 004905d0
    mov edx, dword ptr [ebp - local_c]           # 004905da
    mov dword ptr [edx + field_1f7f], 0x0        # 004905dd
    mov eax, dword ptr [ebp - local_c]           # 004905e7
    mov dword ptr [eax + field_1eeb], 0x54524550 # 004905ea
    mov dword ptr [eax + field_1eef], 0x400921fb # 004905f4
    mov ecx, dword ptr [ebp - local_c]           # 004905fe
    mov dword ptr [ecx + field_1f2f], 0x0        # 00490601
    mov edx, dword ptr [ebp - local_c]           # 0049060b
    mov dword ptr [edx + field_1f33], 0x0        # 0049060e
    mov eax, dword ptr [ebp - local_c]           # 00490618
    mov dword ptr [eax + field_1f37], 0x0        # 0049061b
    mov ecx, dword ptr [ebp - local_c]           # 00490625
    mov dword ptr [ecx + field_1eff], 0x0        # 00490628
    mov edx, dword ptr [ebp - local_c]           # 00490632
    mov dword ptr [edx + field_1f03], 0x0        # 00490635
    mov eax, dword ptr [ebp - local_c]           # 0049063f
    mov dword ptr [eax + field_1f07], 0x0        # 00490642
    mov ecx, dword ptr [ebp - local_c]           # 0049064c
    mov dword ptr [ecx + field_1f0b], 0x0        # 0049064f
    mov edx, dword ptr [ebp - local_c]           # 00490659
    mov dword ptr [edx + field_20c1], 0x0        # 0049065c
    mov eax, dword ptr [ebp - local_c]           # 00490666
    mov dword ptr [eax + field_1f3f], 0x6ba4     # 00490669
    mov ecx, dword ptr [ebp - local_c]           # 00490673
    mov dword ptr [ecx + field_1f47], 0x0        # 00490676
    mov edx, dword ptr [ebp - local_c]           # 00490680
    mov dword ptr [edx + field_1f4b], 0x0        # 00490683
    mov eax, dword ptr [ebp - local_c]           # 0049068d
    mov dword ptr [eax + field_1f4f], 0x0        # 00490690
    mov ecx, dword ptr [ebp - local_c]           # 0049069a
    mov dword ptr [ecx + field_1f53], 0x0        # 0049069d
    mov edx, dword ptr [ebp - local_c]           # 004906a7
    mov dword ptr [edx + field_1f57], 0x0        # 004906aa
    mov eax, dword ptr [ebp - local_c]           # 004906b4
    mov dword ptr [eax + field_1f5b], 0x0        # 004906b7
    mov ecx, dword ptr [ebp - local_c]           # 004906c1
    mov dword ptr [ecx + field_1f5f], 0x0        # 004906c4
    mov edx, dword ptr [ebp - local_c]           # 004906ce
    mov dword ptr [edx + field_1f63], 0x0        # 004906d1
    mov eax, dword ptr [ebp - local_c]           # 004906db
    mov dword ptr [eax + field_1f67], 0x0        # 004906de
    mov ecx, dword ptr [ebp - local_c]           # 004906e8
    mov dword ptr [ecx + field_1f6f], 0x0        # 004906eb
    mov edx, dword ptr [ebp - local_c]           # 004906f5
    mov dword ptr [edx + field_1f73], 0x0        # 004906f8
    mov byte ptr [0x58322e], 0x0                 # 00490702
    mov eax, dword ptr [ebp - local_c]           # 00490709
    mov dword ptr [eax + field_2035], 0x0        # 0049070c
    mov ecx, dword ptr [ebp - local_c]           # 00490716
    mov dword ptr [ecx + field_2039], 0x0        # 00490719
    mov byte ptr [0x58322f], 0x0                 # 00490723
    mov byte ptr [0x583230], 0x0                 # 0049072a
    mov byte ptr [0x583231], 0x0                 # 00490731
    mov edx, dword ptr [ebp - local_c]           # 00490738
    mov dword ptr [edx + field_1f43], 0x0        # 0049073b
    mov eax, dword ptr [ebp - local_c]           # 00490745
    mov dword ptr [eax + field_459d], 0x0        # 00490748
    mov ecx, dword ptr [ebp - local_c]           # 00490752
    mov dword ptr [ecx + field_45a5], 0x0        # 00490755
    mov edx, dword ptr [ebp - local_c]           # 0049075f
    mov dword ptr [edx + field_45a9], 0x0        # 00490762
    mov eax, dword ptr [ebp - local_c]           # 0049076c
    mov dword ptr [eax + field_200f], 0x0        # 0049076f
    mov ecx, dword ptr [ebp - local_c]           # 00490779
    mov dword ptr [ecx + field_2013], 0x0        # 0049077c
    mov edx, dword ptr [ebp - local_c]           # 00490786
    mov dword ptr [edx + field_2017], 0x0        # 00490789
    mov eax, dword ptr [ebp - local_c]           # 00490793
    mov dword ptr [eax + field_50f3], 0x0        # 00490796
    mov ecx, dword ptr [ebp - local_c]           # 004907a0
    mov dword ptr [ecx + field_50f7], 0x0        # 004907a3
    mov edx, dword ptr [ebp - local_c]           # 004907ad
    mov byte ptr [edx + field_50fb], 0x0         # 004907b0
    mov eax, dword ptr [ebp - local_c]           # 004907b7
    mov byte ptr [eax + field_50fc], 0x0         # 004907ba
    mov ecx, dword ptr [ebp - local_c]           # 004907c1
    mov byte ptr [ecx + field_50fd], 0x0         # 004907c4
    mov edx, dword ptr [ebp - local_c]           # 004907cb
    mov dword ptr [edx + field_4781], 0x0        # 004907ce
    mov eax, dword ptr [ebp - local_c]           # 004907d8
    mov dword ptr [eax + field_4785], 0x0        # 004907db
    mov ecx, dword ptr [ebp - local_c]           # 004907e5
    mov dword ptr [ecx + field_4789], 0x0        # 004907e8
    mov edx, dword ptr [ebp - local_c]           # 004907f2
    mov dword ptr [edx + field_478d], 0x0        # 004907f5
    mov byte ptr [0x58322d], 0x0                 # 004907ff
    mov eax, dword ptr [ebp - local_c]           # 00490806
    mov dword ptr [eax + field_4791], 0x0        # 00490809
    mov ecx, dword ptr [ebp - local_c]           # 00490813
    mov dword ptr [ecx + field_4795], 0x1        # 00490816
    mov edx, dword ptr [ebp - local_c]           # 00490820
    mov dword ptr [edx + field_20b5], 0x0        # 00490823
    mov eax, dword ptr [ebp - local_c]           # 0049082d
    mov dword ptr [eax + field_2095], 0x80       # 00490830
    mov ecx, dword ptr [ebp - local_c]           # 0049083a
    mov edx, dword ptr [ecx + field_2095]        # 0049083d
    sar edx                                      # 00490843
    mov eax, dword ptr [ebp - local_c]           # 00490845
    mov dword ptr [eax + field_2099], edx        # 00490848
    mov ecx, dword ptr [ebp - local_c]           # 0049084e
    mov dword ptr [ecx + field_209d], 0x0        # 00490851
    mov edx, dword ptr [ebp - local_c]           # 0049085b
    mov eax, dword ptr [edx + field_2095]        # 0049085e
    imul eax, eax, 0xa6                          # 00490864
    sub eax, 0x1                                 # 0049086a
    mov ecx, dword ptr [ebp - local_c]           # 0049086d
    mov dword ptr [ecx + field_20a1], eax        # 00490870
    mov edx, dword ptr [ebp - local_c]           # 00490876
    mov dword ptr [edx + field_20a5], 0x0        # 00490879
    mov eax, dword ptr [ebp - local_c]           # 00490883
    mov ecx, dword ptr [eax + field_2095]        # 00490886
    imul ecx, ecx, 0xa6                          # 0049088c
    sub ecx, 0x1                                 # 00490892
    mov edx, dword ptr [ebp - local_c]           # 00490895
    mov dword ptr [edx + field_20a9], ecx        # 00490898
    mov eax, dword ptr [ebp - local_c]           # 0049089e
    fild dword ptr [eax + field_2095]            # 004908a1
    fstp dword ptr [ebp - local_10]              # 004908a7
    fld dword ptr [0x52db50]                     # 004908aa
    fmul dword ptr [ebp - local_10]              # 004908b0
    mov ecx, dword ptr [ebp - local_c]           # 004908b3
    fild dword ptr [ecx + field_2095]            # 004908b6
    fstp dword ptr [ebp - local_14]              # 004908bc
    fld dword ptr [0x52db50]                     # 004908bf
    fmul dword ptr [ebp - local_14]              # 004908c5
    fmulp st(1), st                              # 004908c8
    .insn 0xdc, 0xc0                             # 004908ca
    sub esp, 0x8                                 # 004908cc
    fstp qword ptr [esp]                         # 004908cf
    call FUN_0050df94                            # 004908d2
    add esp, 0x8                                 # 004908d7
    mov edx, dword ptr [ebp - local_c]           # 004908da
    fstp dword ptr [edx + field_20ad]            # 004908dd
    mov eax, dword ptr [ebp - local_c]           # 004908e3
    mov dword ptr [eax + field_20b1], 0xa5       # 004908e6
    mov ecx, dword ptr [ebp - local_c]           # 004908f0
    mov dword ptr [ecx + field_1f27], 0x1        # 004908f3
    mov edx, dword ptr [ebp - local_c]           # 004908fd
    mov dword ptr [edx + field_1f0f], 0x0        # 00490900
    mov eax, dword ptr [ebp - local_c]           # 0049090a
    mov dword ptr [eax + field_1f13], 0x200      # 0049090d
    mov ecx, dword ptr [ebp - local_c]           # 00490917
    mov dword ptr [ecx + field_1f17], 0x400      # 0049091a
    mov edx, dword ptr [ebp - local_c]           # 00490924
    mov dword ptr [edx + field_1f1b], 0x600      # 00490927
    mov eax, dword ptr [ebp - local_c]           # 00490931
    mov dword ptr [eax + field_1f1f], 0x800      # 00490934
    mov ecx, dword ptr [ebp - local_c]           # 0049093e
    mov dword ptr [ecx + field_1f23], 0xc00      # 00490941
    mov edx, dword ptr [ebp - local_c]           # 0049094b
    mov dword ptr [edx + field_20b9], 0x7        # 0049094e
    mov eax, dword ptr [ebp - local_c]           # 00490958
    mov ecx, dword ptr [eax + field_2095]        # 0049095b
    imul ecx, ecx, 0xa6                          # 00490961
    mov edx, dword ptr [ebp - local_c]           # 00490967
    mov dword ptr [edx + field_20bd], ecx        # 0049096a
    mov eax, dword ptr [ebp - local_c]           # 00490970
    mov ecx, dword ptr [ebp - local_c]           # 00490973
    mov edx, dword ptr [ecx + field_2095]        # 00490976
    mov dword ptr [eax + field_1f3b], edx        # 0049097c
    mov eax, dword ptr [ebp - local_c]           # 00490982
    mov ecx, dword ptr [ebp - local_c]           # 00490985
    mov edx, dword ptr [ecx + field_2095]        # 00490988
    mov dword ptr [eax + field_45b1], edx        # 0049098e
    mov eax, dword ptr [ebp - local_c]           # 00490994
    mov ecx, dword ptr [ebp - local_c]           # 00490997
    mov edx, dword ptr [ecx + field_2095]        # 0049099a
    mov dword ptr [eax + field_45b9], edx        # 004909a0
    mov eax, dword ptr [ebp - local_c]           # 004909a6
    mov ecx, dword ptr [eax + field_45b9]        # 004909a9
    sub ecx, 0x1                                 # 004909af
    mov edx, dword ptr [ebp - local_c]           # 004909b2
    mov dword ptr [edx + field_45bd], ecx        # 004909b5
    mov eax, dword ptr [ebp - local_c]           # 004909bb
    mov dword ptr [eax + field_476d], 0xc0       # 004909be
    mov ecx, dword ptr [ebp - local_c]           # 004909c8
    fild dword ptr [ecx + field_1f3b]            # 004909cb
    fstp dword ptr [ebp - local_18]              # 004909d1
    fld dword ptr [ebp - local_18]               # 004909d4
    fdiv qword ptr [0x52caa8]                    # 004909d7
    mov edx, dword ptr [ebp - local_c]           # 004909dd
    fstp dword ptr [edx + field_47a9]            # 004909e0
    mov eax, dword ptr [ebp - local_c]           # 004909e6
    mov dword ptr [eax + field_1f2b], 0x40900000 # 004909e9
    mov ecx, dword ptr [ebp - local_c]           # 004909f3
    mov edx, dword ptr [ebp - local_c]           # 004909f6
    mov eax, dword ptr [edx + field_2099]        # 004909f9
    mov dword ptr [ecx + field_47f1], eax        # 004909ff
    mov ecx, dword ptr [ebp - local_c]           # 00490a05
    mov edx, dword ptr [ecx + field_2099]        # 00490a08
    sub edx, 0xf                                 # 00490a0e
    mov eax, dword ptr [ebp - local_c]           # 00490a11
    mov dword ptr [eax + field_47f5], edx        # 00490a14
    mov ecx, dword ptr [ebp - local_c]           # 00490a1a
    mov edx, dword ptr [ebp - local_c]           # 00490a1d
    mov eax, dword ptr [ecx + field_2095]        # 00490a20
    sub eax, dword ptr [edx + field_47f5]        # 00490a26
    mov ecx, dword ptr [ebp - local_c]           # 00490a2c
    mov dword ptr [ecx + field_47f9], eax        # 00490a2f
    mov edx, dword ptr [ebp - local_c]           # 00490a35
    mov eax, dword ptr [edx + field_2095]        # 00490a38
    cdq                                          # 00490a3e
    mov ecx, 0x6                                 # 00490a3f
    idiv ecx                                     # 00490a44
    mov edx, dword ptr [ebp - local_c]           # 00490a46
    mov dword ptr [edx + field_47fd], eax        # 00490a49
    mov eax, dword ptr [ebp - local_c]           # 00490a4f
    mov ecx, dword ptr [ebp - local_c]           # 00490a52
    mov edx, dword ptr [eax + field_2095]        # 00490a55
    sub edx, dword ptr [ecx + field_47fd]        # 00490a5b
    mov eax, dword ptr [ebp - local_c]           # 00490a61
    mov dword ptr [eax + field_4801], edx        # 00490a64
    mov ecx, dword ptr [ebp - local_c]           # 00490a6a
    mov edx, dword ptr [ecx + field_2095]        # 00490a6d
    imul edx, edx, 0xa5                          # 00490a73
    mov eax, dword ptr [ebp - local_c]           # 00490a79
    sub edx, dword ptr [eax + field_47f1]        # 00490a7c
    mov ecx, dword ptr [ebp - local_c]           # 00490a82
    mov dword ptr [ecx + field_4805], edx        # 00490a85
    mov edx, dword ptr [ebp - local_c]           # 00490a8b
    mov eax, dword ptr [edx + field_2095]        # 00490a8e
    imul eax, eax, 0xa5                          # 00490a94
    mov ecx, dword ptr [ebp - local_c]           # 00490a9a
    sub eax, dword ptr [ecx + field_47f1]        # 00490a9d
    mov edx, dword ptr [ebp - local_c]           # 00490aa3
    mov dword ptr [edx + field_4809], eax        # 00490aa6
    mov eax, dword ptr [ebp - local_c]           # 00490aac
    mov ecx, dword ptr [eax + field_2095]        # 00490aaf
    mov edx, dword ptr [ebp - local_c]           # 00490ab5
    add ecx, dword ptr [edx + field_47f1]        # 00490ab8
    mov eax, dword ptr [ebp - local_c]           # 00490abe
    mov dword ptr [eax + field_480d], ecx        # 00490ac1
    mov ecx, dword ptr [ebp - local_c]           # 00490ac7
    mov edx, dword ptr [ecx + field_2095]        # 00490aca
    mov eax, dword ptr [ebp - local_c]           # 00490ad0
    add edx, dword ptr [eax + field_47f1]        # 00490ad3
    mov ecx, dword ptr [ebp - local_c]           # 00490ad9
    mov dword ptr [ecx + field_4811], edx        # 00490adc
    mov edx, dword ptr [ebp - local_c]           # 00490ae2
    mov dword ptr [edx + field_4815], 0x3951b717 # 00490ae5
    mov eax, dword ptr [ebp - local_c]           # 00490aef
    mov dword ptr [eax + field_4819], 0x3a1d4952 # 00490af2
    mov ecx, dword ptr [ebp - local_c]           # 00490afc
    mov dword ptr [ecx + field_201b], 0x3db40000 # 00490aff
    mov edx, dword ptr [ebp - local_c]           # 00490b09
    fld qword ptr [0x52c678]                     # 00490b0c
    fmul qword ptr [edx + field_1eeb]            # 00490b12
    fdivr qword ptr [0x52db48]                   # 00490b18
    mov eax, dword ptr [ebp - local_c]           # 00490b1e
    fstp dword ptr [eax + field_47ed]            # 00490b21
    mov dword ptr [ebp - local_8], 0x0           # 00490b27
    jmp.d8 L_00490b39                            # 00490b2e
L_00490b30:
    # block 0x00490b30: entered by jmp at 0x00490b61, 3 instruction(s), falls into the block at 0x00490b39
    mov ecx, dword ptr [ebp - local_8]           # 00490b30
    add ecx, 0x1                                 # 00490b33
    mov dword ptr [ebp - local_8], ecx           # 00490b36
L_00490b39:
    # block 0x00490b39: entered by jmp at 0x00490b2e, 2 instruction(s), ends with jge to 0x00490b63 (forward)
    cmp dword ptr [ebp - local_8], 0x55          # 00490b39
    jge.d8 L_00490b63                            # 00490b3d
    # block 0x00490b3f: entered by fall-through of jge at 0x00490b3d, 7 instruction(s), ends with backward jump to 0x00490b30
    mov edx, dword ptr [ebp - local_8]           # 00490b3f
    mov eax, dword ptr [ebp - local_c]           # 00490b42
    mov dword ptr [eax + 4*edx + field_20e5], 0x0 # 00490b45
    mov ecx, dword ptr [ebp - local_8]           # 00490b50
    mov edx, dword ptr [ebp - local_c]           # 00490b53
    mov dword ptr [edx + 4*ecx + field_41f1], 0x0 # 00490b56
    jmp.d8 L_00490b30                            # 00490b61
L_00490b63:
    # block 0x00490b63: entered by jge at 0x00490b3d, 2 instruction(s), ends with forward jump to 0x00490b75
    mov dword ptr [ebp - local_8], 0x0           # 00490b63
    jmp.d8 L_00490b75                            # 00490b6a
L_00490b6c:
    # block 0x00490b6c: entered by jmp at 0x00490b9d, 3 instruction(s), falls into the block at 0x00490b75
    mov eax, dword ptr [ebp - local_8]           # 00490b6c
    add eax, 0x1                                 # 00490b6f
    mov dword ptr [ebp - local_8], eax           # 00490b72
L_00490b75:
    # block 0x00490b75: entered by jmp at 0x00490b6a, 2 instruction(s), ends with jge to 0x00490b9f (forward)
    cmp dword ptr [ebp - local_8], 0x28          # 00490b75
    jge.d8 L_00490b9f                            # 00490b79
    # block 0x00490b7b: entered by fall-through of jge at 0x00490b79, 7 instruction(s), ends with backward jump to 0x00490b6c
    mov ecx, dword ptr [ebp - local_8]           # 00490b7b
    mov edx, dword ptr [ebp - local_c]           # 00490b7e
    mov dword ptr [edx + 4*ecx + field_2239], 0x0 # 00490b81
    mov eax, dword ptr [ebp - local_8]           # 00490b8c
    mov ecx, dword ptr [ebp - local_c]           # 00490b8f
    mov dword ptr [ecx + 4*eax + field_4345], 0x0 # 00490b92
    jmp.d8 L_00490b6c                            # 00490b9d
L_00490b9f:
    # block 0x00490b9f: entered by jge at 0x00490b79, 2 instruction(s), ends with forward jump to 0x00490bb1
    mov dword ptr [ebp - local_8], 0x0           # 00490b9f
    jmp.d8 L_00490bb1                            # 00490ba6
L_00490ba8:
    # block 0x00490ba8: entered by jmp at 0x00490bd9, 3 instruction(s), falls into the block at 0x00490bb1
    mov edx, dword ptr [ebp - local_8]           # 00490ba8
    add edx, 0x1                                 # 00490bab
    mov dword ptr [ebp - local_8], edx           # 00490bae
L_00490bb1:
    # block 0x00490bb1: entered by jmp at 0x00490ba6, 2 instruction(s), ends with jge to 0x00490bdb (forward)
    cmp dword ptr [ebp - local_8], 0x55          # 00490bb1
    jge.d8 L_00490bdb                            # 00490bb5
    # block 0x00490bb7: entered by fall-through of jge at 0x00490bb5, 7 instruction(s), ends with backward jump to 0x00490ba8
    mov eax, dword ptr [ebp - local_8]           # 00490bb7
    mov ecx, dword ptr [ebp - local_c]           # 00490bba
    mov dword ptr [ecx + 4*eax + field_22d9], 0x0 # 00490bbd
    mov edx, dword ptr [ebp - local_8]           # 00490bc8
    mov eax, dword ptr [ebp - local_c]           # 00490bcb
    mov dword ptr [eax + 4*edx + field_43e5], 0x0 # 00490bce
    jmp.d8 L_00490ba8                            # 00490bd9
L_00490bdb:
    # block 0x00490bdb: entered by jge at 0x00490bb5, 2 instruction(s), ends with forward jump to 0x00490bed
    mov dword ptr [ebp - local_8], 0x0           # 00490bdb
    jmp.d8 L_00490bed                            # 00490be2
L_00490be4:
    # block 0x00490be4: entered by jmp at 0x00490c15, 3 instruction(s), falls into the block at 0x00490bed
    mov ecx, dword ptr [ebp - local_8]           # 00490be4
    add ecx, 0x1                                 # 00490be7
    mov dword ptr [ebp - local_8], ecx           # 00490bea
L_00490bed:
    # block 0x00490bed: entered by jmp at 0x00490be2, 2 instruction(s), ends with jge to 0x00490c17 (forward)
    cmp dword ptr [ebp - local_8], 0x19          # 00490bed
    jge.d8 L_00490c17                            # 00490bf1
    # block 0x00490bf3: entered by fall-through of jge at 0x00490bf1, 7 instruction(s), ends with backward jump to 0x00490be4
    mov edx, dword ptr [ebp - local_8]           # 00490bf3
    mov eax, dword ptr [ebp - local_c]           # 00490bf6
    mov dword ptr [eax + 4*edx + field_242d], 0x0 # 00490bf9
    mov ecx, dword ptr [ebp - local_8]           # 00490c04
    mov edx, dword ptr [ebp - local_c]           # 00490c07
    mov dword ptr [edx + 4*ecx + field_4539], 0x0 # 00490c0a
    jmp.d8 L_00490be4                            # 00490c15
L_00490c17:
    # block 0x00490c17: entered by jge at 0x00490bf1, 2 instruction(s), ends with forward jump to 0x00490c29
    mov dword ptr [ebp - local_8], 0x0           # 00490c17
    jmp.d8 L_00490c29                            # 00490c1e
L_00490c20:
    # block 0x00490c20: entered by jmp at 0x00490d0c, 3 instruction(s), falls into the block at 0x00490c29
    mov eax, dword ptr [ebp - local_8]           # 00490c20
    add eax, 0x1                                 # 00490c23
    mov dword ptr [ebp - local_8], eax           # 00490c26
L_00490c29:
    # block 0x00490c29: entered by jmp at 0x00490c1e, 2 instruction(s), ends with jge to 0x00490d11 (forward)
    cmp dword ptr [ebp - local_8], 0x8           # 00490c29
    jge.d32 L_00490d11                           # 00490c2d
    # block 0x00490c33: entered by fall-through of jge at 0x00490c2d, 2 instruction(s), ends with forward jump to 0x00490c45
    mov dword ptr [ebp - local_4], 0x0           # 00490c33
    jmp.d8 L_00490c45                            # 00490c3a
L_00490c3c:
    # block 0x00490c3c: entered by jmp at 0x00490c68, 3 instruction(s), falls into the block at 0x00490c45
    mov ecx, dword ptr [ebp - local_4]           # 00490c3c
    add ecx, 0x1                                 # 00490c3f
    mov dword ptr [ebp - local_4], ecx           # 00490c42
L_00490c45:
    # block 0x00490c45: entered by jmp at 0x00490c3a, 2 instruction(s), ends with jge to 0x00490c6a (forward)
    cmp dword ptr [ebp - local_4], 0x55          # 00490c45
    jge.d8 L_00490c6a                            # 00490c49
    # block 0x00490c4b: entered by fall-through of jge at 0x00490c49, 7 instruction(s), ends with backward jump to 0x00490c3c
    mov edx, dword ptr [ebp - local_8]           # 00490c4b
    imul edx, edx, 0x154                         # 00490c4e
    mov eax, dword ptr [ebp - local_c]           # 00490c54
    lea ecx, [eax + edx + field_2491]            # 00490c57
    mov edx, dword ptr [ebp - local_4]           # 00490c5e
    mov dword ptr [ecx + 4*edx], 0x0             # 00490c61
    jmp.d8 L_00490c3c                            # 00490c68
L_00490c6a:
    # block 0x00490c6a: entered by jge at 0x00490c49, 2 instruction(s), ends with forward jump to 0x00490c7c
    mov dword ptr [ebp - local_4], 0x0           # 00490c6a
    jmp.d8 L_00490c7c                            # 00490c71
L_00490c73:
    # block 0x00490c73: entered by jmp at 0x00490c9f, 3 instruction(s), falls into the block at 0x00490c7c
    mov eax, dword ptr [ebp - local_4]           # 00490c73
    add eax, 0x1                                 # 00490c76
    mov dword ptr [ebp - local_4], eax           # 00490c79
L_00490c7c:
    # block 0x00490c7c: entered by jmp at 0x00490c71, 2 instruction(s), ends with jge to 0x00490ca1 (forward)
    cmp dword ptr [ebp - local_4], 0x28          # 00490c7c
    jge.d8 L_00490ca1                            # 00490c80
    # block 0x00490c82: entered by fall-through of jge at 0x00490c80, 7 instruction(s), ends with backward jump to 0x00490c73
    mov ecx, dword ptr [ebp - local_8]           # 00490c82
    imul ecx, ecx, 0xa0                          # 00490c85
    mov edx, dword ptr [ebp - local_c]           # 00490c8b
    lea eax, [edx + ecx + field_2f31]            # 00490c8e
    mov ecx, dword ptr [ebp - local_4]           # 00490c95
    mov dword ptr [eax + 4*ecx], 0x0             # 00490c98
    jmp.d8 L_00490c73                            # 00490c9f
L_00490ca1:
    # block 0x00490ca1: entered by jge at 0x00490c80, 2 instruction(s), ends with forward jump to 0x00490cb3
    mov dword ptr [ebp - local_4], 0x0           # 00490ca1
    jmp.d8 L_00490cb3                            # 00490ca8
L_00490caa:
    # block 0x00490caa: entered by jmp at 0x00490cd6, 3 instruction(s), falls into the block at 0x00490cb3
    mov edx, dword ptr [ebp - local_4]           # 00490caa
    add edx, 0x1                                 # 00490cad
    mov dword ptr [ebp - local_4], edx           # 00490cb0
L_00490cb3:
    # block 0x00490cb3: entered by jmp at 0x00490ca8, 2 instruction(s), ends with jge to 0x00490cd8 (forward)
    cmp dword ptr [ebp - local_4], 0x55          # 00490cb3
    jge.d8 L_00490cd8                            # 00490cb7
    # block 0x00490cb9: entered by fall-through of jge at 0x00490cb7, 7 instruction(s), ends with backward jump to 0x00490caa
    mov eax, dword ptr [ebp - local_8]           # 00490cb9
    imul eax, eax, 0x154                         # 00490cbc
    mov ecx, dword ptr [ebp - local_c]           # 00490cc2
    lea edx, [ecx + eax + field_3431]            # 00490cc5
    mov eax, dword ptr [ebp - local_4]           # 00490ccc
    mov dword ptr [edx + 4*eax], 0x0             # 00490ccf
    jmp.d8 L_00490caa                            # 00490cd6
L_00490cd8:
    # block 0x00490cd8: entered by jge at 0x00490cb7, 2 instruction(s), ends with forward jump to 0x00490cea
    mov dword ptr [ebp - local_4], 0x0           # 00490cd8
    jmp.d8 L_00490cea                            # 00490cdf
L_00490ce1:
    # block 0x00490ce1: entered by jmp at 0x00490d0a, 3 instruction(s), falls into the block at 0x00490cea
    mov ecx, dword ptr [ebp - local_4]           # 00490ce1
    add ecx, 0x1                                 # 00490ce4
    mov dword ptr [ebp - local_4], ecx           # 00490ce7
L_00490cea:
    # block 0x00490cea: entered by jmp at 0x00490cdf, 2 instruction(s), ends with jge to 0x00490d0c (forward)
    cmp dword ptr [ebp - local_4], 0x19          # 00490cea
    jge.d8 L_00490d0c                            # 00490cee
    # block 0x00490cf0: entered by fall-through of jge at 0x00490cee, 7 instruction(s), ends with backward jump to 0x00490ce1
    mov edx, dword ptr [ebp - local_8]           # 00490cf0
    imul edx, edx, 0x64                          # 00490cf3
    mov eax, dword ptr [ebp - local_c]           # 00490cf6
    lea ecx, [eax + edx + field_3ed1]            # 00490cf9
    mov edx, dword ptr [ebp - local_4]           # 00490d00
    mov dword ptr [ecx + 4*edx], 0x0             # 00490d03
    jmp.d8 L_00490ce1                            # 00490d0a
L_00490d0c:
    # block 0x00490d0c: entered by jge at 0x00490cee, 1 instruction(s), ends with backward jump to 0x00490c20
    jmp.d32 L_00490c20                           # 00490d0c
L_00490d11:
    # block 0x00490d11: entered by jge at 0x00490c2d, 4 instruction(s), ends with forward jump to 0x00490d30
    mov eax, dword ptr [ebp - local_c]           # 00490d11
    mov dword ptr [eax + field_4765], 0x0        # 00490d14
    mov dword ptr [ebp - local_8], 0x0           # 00490d1e
    jmp.d8 L_00490d30                            # 00490d25
L_00490d27:
    # block 0x00490d27: entered by jmp at 0x00490d4a, 3 instruction(s), falls into the block at 0x00490d30
    mov ecx, dword ptr [ebp - local_8]           # 00490d27
    add ecx, 0x1                                 # 00490d2a
    mov dword ptr [ebp - local_8], ecx           # 00490d2d
L_00490d30:
    # block 0x00490d30: entered by jmp at 0x00490d25, 2 instruction(s), ends with jge to 0x00490d4c (forward)
    cmp dword ptr [ebp - local_8], 0xf           # 00490d30
    jge.d8 L_00490d4c                            # 00490d34
    # block 0x00490d36: entered by fall-through of jge at 0x00490d34, 5 instruction(s), ends with backward jump to 0x00490d27
    mov edx, dword ptr [ebp - local_8]           # 00490d36
    imul edx, edx, 0x1c                          # 00490d39
    mov eax, dword ptr [ebp - local_c]           # 00490d3c
    mov dword ptr [eax + edx + field_45c1], 0x0  # 00490d3f
    jmp.d8 L_00490d27                            # 00490d4a
L_00490d4c:
    # block 0x00490d4c: entered by jge at 0x00490d34, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00490d4c
    pop ebp                                      # 00490d4e
    ret                                          # 00490d4f

