# FUN_00496410
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00496410
# extent:       0x00496410-0x0049c45c (24652 code bytes)
# span:         0x00496410-0x0049c45c (code 24652, tables 0, padding 0)
# sha256:       69b66b64a729bf10d022f49e19401e65bf790a9462d0d787fdffb13e2481aa4d
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00496410
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       223 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 211 more
# fields:       [eax + n] field_1ef3, field_1ef7, field_1efb, field_1f0f, field_1f1f, field_1f27, field_1f47, field_1f67, field_1f7f, field_1fff, field_200f, field_2013 and 46 more; [ecx + n] field_1ef3, field_1ef7, field_1efb, field_1f17, field_1f23, field_1f47, field_1f4b, field_1f4f, field_1f57, field_1f7f, field_1fff, field_200f and 58 more; [edx + n] field_1ef3, field_1ef7, field_1efb, field_1f57, field_1f5f, field_1f67, field_1fff, field_200f, field_2013, field_2095, field_20ad, field_20b9 and 50 more
# callees:      calls FUN_0050ce04, FUN_0050e3de, FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4, FUN_0050e30f, FUN_0050e19e, FUN_0049192b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4985 instruction(s), 267 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_50, 0x50  # offset -0x50
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_a8, 0xa8  # offset -0xa8
.equ local_ac, 0xac  # offset -0xac
.equ local_b0, 0xb0  # offset -0xb0
.equ local_b4, 0xb4  # offset -0xb4
.equ local_b8, 0xb8  # offset -0xb8
.equ local_bc, 0xbc  # offset -0xbc
.equ local_c0, 0xc0  # offset -0xc0
.equ local_c4, 0xc4  # offset -0xc4
.equ local_c8, 0xc8  # offset -0xc8
.equ local_cc, 0xcc  # offset -0xcc
.equ local_d0, 0xd0  # offset -0xd0
.equ local_d4, 0xd4  # offset -0xd4
.equ local_d8, 0xd8  # offset -0xd8
.equ local_dc, 0xdc  # offset -0xdc
.equ local_e0, 0xe0  # offset -0xe0
.equ local_e4, 0xe4  # offset -0xe4
.equ local_e8, 0xe8  # offset -0xe8
.equ local_ec, 0xec  # offset -0xec
.equ local_f0, 0xf0  # offset -0xf0
.equ local_f4, 0xf4  # offset -0xf4
.equ local_f8, 0xf8  # offset -0xf8
.equ local_fc, 0xfc  # offset -0xfc
.equ local_100, 0x100  # offset -0x100
.equ local_104, 0x104  # offset -0x104
.equ local_108, 0x108  # offset -0x108
.equ local_10c, 0x10c  # offset -0x10c
.equ local_110, 0x110  # offset -0x110
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_120, 0x120  # offset -0x120
.equ local_124, 0x124  # offset -0x124
.equ local_128, 0x128  # offset -0x128
.equ local_12c, 0x12c  # offset -0x12c
.equ local_130, 0x130  # offset -0x130
.equ local_134, 0x134  # offset -0x134
.equ local_138, 0x138  # offset -0x138
.equ local_13c, 0x13c  # offset -0x13c
.equ local_140, 0x140  # offset -0x140
.equ local_144, 0x144  # offset -0x144
.equ local_148, 0x148  # offset -0x148
.equ local_14c, 0x14c  # offset -0x14c
.equ local_150, 0x150  # offset -0x150
.equ local_154, 0x154  # offset -0x154
.equ local_158, 0x158  # offset -0x158
.equ local_15c, 0x15c  # offset -0x15c
.equ local_160, 0x160  # offset -0x160
.equ local_164, 0x164  # offset -0x164
.equ local_168, 0x168  # offset -0x168
.equ local_16c, 0x16c  # offset -0x16c
.equ local_170, 0x170  # offset -0x170
.equ local_174, 0x174  # offset -0x174
.equ local_178, 0x178  # offset -0x178
.equ local_17c, 0x17c  # offset -0x17c
.equ local_180, 0x180  # offset -0x180
.equ local_184, 0x184  # offset -0x184
.equ local_188, 0x188  # offset -0x188
.equ local_18c, 0x18c  # offset -0x18c
.equ local_190, 0x190  # offset -0x190
.equ local_194, 0x194  # offset -0x194
.equ local_198, 0x198  # offset -0x198
.equ local_19c, 0x19c  # offset -0x19c
.equ local_1a0, 0x1a0  # offset -0x1a0
.equ local_1a4, 0x1a4  # offset -0x1a4
.equ local_1a8, 0x1a8  # offset -0x1a8
.equ local_1ac, 0x1ac  # offset -0x1ac
.equ local_1b0, 0x1b0  # offset -0x1b0
.equ local_1b4, 0x1b4  # offset -0x1b4
.equ local_1b8, 0x1b8  # offset -0x1b8
.equ local_1bc, 0x1bc  # offset -0x1bc
.equ local_1c0, 0x1c0  # offset -0x1c0
.equ local_1c4, 0x1c4  # offset -0x1c4
.equ local_1c8, 0x1c8  # offset -0x1c8
.equ local_1cc, 0x1cc  # offset -0x1cc
.equ local_1d0, 0x1d0  # offset -0x1d0
.equ local_1d4, 0x1d4  # offset -0x1d4
.equ local_1d8, 0x1d8  # offset -0x1d8
.equ local_1dc, 0x1dc  # offset -0x1dc
.equ local_1e0, 0x1e0  # offset -0x1e0
.equ local_1e4, 0x1e4  # offset -0x1e4
.equ local_1e8, 0x1e8  # offset -0x1e8
.equ local_1ec, 0x1ec  # offset -0x1ec
.equ local_1f0, 0x1f0  # offset -0x1f0
.equ local_1f4, 0x1f4  # offset -0x1f4
.equ local_1f8, 0x1f8  # offset -0x1f8
.equ local_1fc, 0x1fc  # offset -0x1fc
.equ local_200, 0x200  # offset -0x200
.equ local_204, 0x204  # offset -0x204
.equ local_208, 0x208  # offset -0x208
.equ local_20c, 0x20c  # offset -0x20c
.equ local_210, 0x210  # offset -0x210
.equ local_214, 0x214  # offset -0x214
.equ local_218, 0x218  # offset -0x218
.equ local_21c, 0x21c  # offset -0x21c
.equ local_220, 0x220  # offset -0x220
.equ local_224, 0x224  # offset -0x224
.equ local_228, 0x228  # offset -0x228
.equ local_22c, 0x22c  # offset -0x22c
.equ local_230, 0x230  # offset -0x230
.equ local_234, 0x234  # offset -0x234
.equ local_238, 0x238  # offset -0x238
.equ local_23c, 0x23c  # offset -0x23c
.equ local_240, 0x240  # offset -0x240
.equ local_244, 0x244  # offset -0x244
.equ local_248, 0x248  # offset -0x248
.equ local_24c, 0x24c  # offset -0x24c
.equ local_250, 0x250  # offset -0x250
.equ local_254, 0x254  # offset -0x254
.equ local_258, 0x258  # offset -0x258
.equ local_25c, 0x25c  # offset -0x25c
.equ local_260, 0x260  # offset -0x260
.equ local_264, 0x264  # offset -0x264
.equ local_268, 0x268  # offset -0x268
.equ local_26c, 0x26c  # offset -0x26c
.equ local_270, 0x270  # offset -0x270
.equ local_274, 0x274  # offset -0x274
.equ local_278, 0x278  # offset -0x278
.equ local_27c, 0x27c  # offset -0x27c
.equ local_280, 0x280  # offset -0x280
.equ local_284, 0x284  # offset -0x284
.equ local_288, 0x288  # offset -0x288
.equ local_28c, 0x28c  # offset -0x28c
.equ local_290, 0x290  # offset -0x290
.equ local_294, 0x294  # offset -0x294
.equ local_298, 0x298  # offset -0x298
.equ local_29c, 0x29c  # offset -0x29c
.equ local_2a0, 0x2a0  # offset -0x2a0
.equ local_2a4, 0x2a4  # offset -0x2a4
.equ local_2a8, 0x2a8  # offset -0x2a8
.equ local_2ac, 0x2ac  # offset -0x2ac
.equ local_2b0, 0x2b0  # offset -0x2b0
.equ local_2b4, 0x2b4  # offset -0x2b4
.equ local_2b8, 0x2b8  # offset -0x2b8
.equ local_2bc, 0x2bc  # offset -0x2bc
.equ local_2c0, 0x2c0  # offset -0x2c0
.equ local_2c4, 0x2c4  # offset -0x2c4
.equ local_2c8, 0x2c8  # offset -0x2c8
.equ local_2cc, 0x2cc  # offset -0x2cc
.equ local_2d0, 0x2d0  # offset -0x2d0
.equ local_2d4, 0x2d4  # offset -0x2d4
.equ local_2d8, 0x2d8  # offset -0x2d8
.equ local_2dc, 0x2dc  # offset -0x2dc
.equ local_2e0, 0x2e0  # offset -0x2e0
.equ local_2e4, 0x2e4  # offset -0x2e4
.equ local_2e8, 0x2e8  # offset -0x2e8
.equ local_2ec, 0x2ec  # offset -0x2ec
.equ local_2f0, 0x2f0  # offset -0x2f0
.equ local_2f4, 0x2f4  # offset -0x2f4
.equ local_2f8, 0x2f8  # offset -0x2f8
.equ local_2fc, 0x2fc  # offset -0x2fc
.equ local_300, 0x300  # offset -0x300
.equ local_304, 0x304  # offset -0x304
.equ local_308, 0x308  # offset -0x308
.equ local_30c, 0x30c  # offset -0x30c
.equ local_310, 0x310  # offset -0x310
.equ local_314, 0x314  # offset -0x314
.equ local_318, 0x318  # offset -0x318
.equ local_31c, 0x31c  # offset -0x31c
.equ local_320, 0x320  # offset -0x320
.equ local_324, 0x324  # offset -0x324
.equ local_328, 0x328  # offset -0x328
.equ local_32c, 0x32c  # offset -0x32c
.equ local_330, 0x330  # offset -0x330
.equ local_334, 0x334  # offset -0x334
.equ local_338, 0x338  # offset -0x338
.equ local_33c, 0x33c  # offset -0x33c
.equ local_340, 0x340  # offset -0x340
.equ local_344, 0x344  # offset -0x344
.equ local_348, 0x348  # offset -0x348
.equ local_34c, 0x34c  # offset -0x34c
.equ local_350, 0x350  # offset -0x350
.equ local_354, 0x354  # offset -0x354
.equ local_358, 0x358  # offset -0x358
.equ local_35c, 0x35c  # offset -0x35c
.equ local_360, 0x360  # offset -0x360
.equ local_364, 0x364  # offset -0x364
.equ local_368, 0x368  # offset -0x368
.equ local_36c, 0x36c  # offset -0x36c
.equ local_370, 0x370  # offset -0x370
.equ local_374, 0x374  # offset -0x374
.equ local_378, 0x378  # offset -0x378
.equ local_37c, 0x37c  # offset -0x37c
.equ field_1ef3, 0x1ef3  # offset +0x1ef3
.equ field_1ef7, 0x1ef7  # offset +0x1ef7
.equ field_1efb, 0x1efb  # offset +0x1efb
.equ field_1f0f, 0x1f0f  # offset +0x1f0f
.equ field_1f17, 0x1f17  # offset +0x1f17
.equ field_1f1f, 0x1f1f  # offset +0x1f1f
.equ field_1f23, 0x1f23  # offset +0x1f23
.equ field_1f27, 0x1f27  # offset +0x1f27
.equ field_1f47, 0x1f47  # offset +0x1f47
.equ field_1f4b, 0x1f4b  # offset +0x1f4b
.equ field_1f4f, 0x1f4f  # offset +0x1f4f
.equ field_1f57, 0x1f57  # offset +0x1f57
.equ field_1f5f, 0x1f5f  # offset +0x1f5f
.equ field_1f67, 0x1f67  # offset +0x1f67
.equ field_1f7f, 0x1f7f  # offset +0x1f7f
.equ field_1fff, 0x1fff  # offset +0x1fff
.equ field_200f, 0x200f  # offset +0x200f
.equ field_2013, 0x2013  # offset +0x2013
.equ field_2017, 0x2017  # offset +0x2017
.equ field_2095, 0x2095  # offset +0x2095
.equ field_20ad, 0x20ad  # offset +0x20ad
.equ field_20b1, 0x20b1  # offset +0x20b1
.equ field_20b5, 0x20b5  # offset +0x20b5
.equ field_20b9, 0x20b9  # offset +0x20b9
.equ field_20bd, 0x20bd  # offset +0x20bd
.equ field_2491, 0x2491  # offset +0x2491
.equ field_2f31, 0x2f31  # offset +0x2f31
.equ field_3431, 0x3431  # offset +0x3431
.equ field_3ed1, 0x3ed1  # offset +0x3ed1
.equ field_45ad, 0x45ad  # offset +0x45ad
.equ field_45b1, 0x45b1  # offset +0x45b1
.equ field_45b5, 0x45b5  # offset +0x45b5
.equ field_45bd, 0x45bd  # offset +0x45bd
.equ field_476d, 0x476d  # offset +0x476d
.equ field_4771, 0x4771  # offset +0x4771
.equ field_4775, 0x4775  # offset +0x4775
.equ field_4779, 0x4779  # offset +0x4779
.equ field_477d, 0x477d  # offset +0x477d
.equ field_4781, 0x4781  # offset +0x4781
.equ field_4789, 0x4789  # offset +0x4789
.equ field_47ad, 0x47ad  # offset +0x47ad
.equ field_47d1, 0x47d1  # offset +0x47d1
.equ field_47d5, 0x47d5  # offset +0x47d5
.equ field_47dd, 0x47dd  # offset +0x47dd
.equ field_47e1, 0x47e1  # offset +0x47e1
.equ field_47e5, 0x47e5  # offset +0x47e5
.equ field_4821, 0x4821  # offset +0x4821
.equ field_5081, 0x5081  # offset +0x5081
.equ field_5085, 0x5085  # offset +0x5085
.equ field_5089, 0x5089  # offset +0x5089
.equ field_508d, 0x508d  # offset +0x508d
.equ field_5091, 0x5091  # offset +0x5091
.equ field_5095, 0x5095  # offset +0x5095
.equ field_5099, 0x5099  # offset +0x5099
.equ field_509d, 0x509d  # offset +0x509d
.equ field_50a1, 0x50a1  # offset +0x50a1
.equ field_50a5, 0x50a5  # offset +0x50a5
.equ field_50a9, 0x50a9  # offset +0x50a9
.equ field_50ad, 0x50ad  # offset +0x50ad
.equ field_50b1, 0x50b1  # offset +0x50b1
.equ field_50b5, 0x50b5  # offset +0x50b5
.equ field_50b9, 0x50b9  # offset +0x50b9
.equ field_50bd, 0x50bd  # offset +0x50bd
.equ field_50c1, 0x50c1  # offset +0x50c1
.equ field_50c5, 0x50c5  # offset +0x50c5
.equ field_50c9, 0x50c9  # offset +0x50c9
.equ field_50cd, 0x50cd  # offset +0x50cd
.equ field_50d1, 0x50d1  # offset +0x50d1
.equ field_50d5, 0x50d5  # offset +0x50d5
.equ field_50d9, 0x50d9  # offset +0x50d9
.equ field_50dd, 0x50dd  # offset +0x50dd
.equ field_50e1, 0x50e1  # offset +0x50e1
.equ field_50e5, 0x50e5  # offset +0x50e5
.equ field_50e9, 0x50e9  # offset +0x50e9
.equ field_50ed, 0x50ed  # offset +0x50ed
.equ field_50ee, 0x50ee  # offset +0x50ee
.equ field_50ef, 0x50ef  # offset +0x50ef
.equ field_50f0, 0x50f0  # offset +0x50f0
.equ field_50f1, 0x50f1  # offset +0x50f1
.equ field_50f2, 0x50f2  # offset +0x50f2
.equ field_50f3, 0x50f3  # offset +0x50f3
.equ field_50fb, 0x50fb  # offset +0x50fb
.equ field_50fc, 0x50fc  # offset +0x50fc
.equ field_50fd, 0x50fd  # offset +0x50fd

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0049192b, .text + (0x0049192b - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)
.set FUN_0050e30f, .text + (0x0050e30f - 0x401000)
.set FUN_0050e3de, .text + (0x0050e3de - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00496410 - 0x401000
.globl FUN_00496410
FUN_00496410:
    # block 0x00496410: entry, 24 instruction(s), ends with forward jump to 0x00496483
    push ebp                                     # 00496410
    {load} mov ebp, esp                          # 00496411
    sub esp, 0x37c                               # 00496413
    push esi                                     # 00496419
    mov dword ptr [ebp - local_288], ecx         # 0049641a
    mov eax, dword ptr [ebp - local_288]         # 00496420
    mov ecx, dword ptr [eax + field_47d1]        # 00496426
    add ecx, 0x10                                # 0049642c
    mov dword ptr [ebp - local_50], ecx          # 0049642f
    mov edx, dword ptr [ebp - local_288]         # 00496432
    mov eax, dword ptr [edx + field_47d1]        # 00496438
    add eax, 0x10                                # 0049643e
    mov dword ptr [ebp - local_20], eax          # 00496441
    mov cx, word ptr [0x5d2f29]                  # 00496444
    mov word ptr [ebp - local_e0], cx            # 0049644b
    mov edx, dword ptr [ebp - local_288]         # 00496452
    {load} xor eax, eax                          # 00496458
    mov al, byte ptr [edx + field_50fb]          # 0049645a
    add eax, 0x1                                 # 00496460
    mov byte ptr [ebp - local_b0], al            # 00496463
    mov ecx, dword ptr [ebp - local_288]         # 00496469
    mov edx, dword ptr [ecx + field_4771]        # 0049646f
    mov dword ptr [ebp - local_78], edx          # 00496475
    jmp.d8 L_00496483                            # 00496478
L_0049647a:
    # block 0x0049647a: entered by jmp at 0x0049b9ec, 3 instruction(s), falls into the block at 0x00496483
    mov eax, dword ptr [ebp - local_78]          # 0049647a
    add eax, 0x1                                 # 0049647d
    mov dword ptr [ebp - local_78], eax          # 00496480
L_00496483:
    # block 0x00496483: entered by jmp at 0x00496478, 4 instruction(s), ends with jg to 0x0049b9f1 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00496483
    mov edx, dword ptr [ebp - local_78]          # 00496489
    cmp edx, dword ptr [ecx + field_4775]        # 0049648c
    jg.d32 L_0049b9f1                            # 00496492
    # block 0x00496498: entered by fall-through of jg at 0x00496492, 15 instruction(s), ends with jle to 0x0049650a (forward)
    mov eax, dword ptr [ebp - local_288]         # 00496498
    mov ecx, dword ptr [eax + field_2017]        # 0049649e
    mov edx, dword ptr [ebp - local_288]         # 004964a4
    mov eax, dword ptr [ebp - local_78]          # 004964aa
    mov ecx, dword ptr [ecx + 4*eax]             # 004964ad
    mov dword ptr [edx + field_50c1], ecx        # 004964b0
    mov edx, dword ptr [ebp - local_288]         # 004964b6
    mov eax, dword ptr [edx + field_1ef3]        # 004964bc
    mov ecx, dword ptr [ebp - local_288]         # 004964c2
    add eax, dword ptr [ecx + field_50c1]        # 004964c8
    mov edx, dword ptr [ebp - local_288]         # 004964ce
    mov dword ptr [edx + field_50cd], eax        # 004964d4
    mov eax, dword ptr [ebp - local_288]         # 004964da
    cmp dword ptr [eax + field_50cd], 0xfff      # 004964e0
    jle.d8 L_0049650a                            # 004964ea
    # block 0x004964ec: entered by fall-through of jle at 0x004964ea, 5 instruction(s), falls into the block at 0x0049650a
    mov ecx, dword ptr [ebp - local_288]         # 004964ec
    mov edx, dword ptr [ecx + field_50cd]        # 004964f2
    sub edx, 0x1000                              # 004964f8
    mov eax, dword ptr [ebp - local_288]         # 004964fe
    mov dword ptr [eax + field_50cd], edx        # 00496504
L_0049650a:
    # block 0x0049650a: entered by jle at 0x004964ea, 56 instruction(s), ends with je to 0x00496658 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049650a
    mov edx, dword ptr [ecx + field_50cd]        # 00496510
    and edx, 0xfff                               # 00496516
    mov eax, dword ptr [ebp - local_288]         # 0049651c
    mov ecx, dword ptr [eax + field_2013]        # 00496522
    fld dword ptr [ecx + 4*edx]                  # 00496528
    fmul qword ptr [0x52db88]                    # 0049652b
    fstp dword ptr [ebp - local_d8]              # 00496531
    mov edx, dword ptr [ebp - local_288]         # 00496537
    mov eax, dword ptr [edx + field_50cd]        # 0049653d
    and eax, 0xfff                               # 00496543
    mov ecx, dword ptr [ebp - local_288]         # 00496548
    mov edx, dword ptr [ecx + field_200f]        # 0049654e
    fld dword ptr [edx + 4*eax]                  # 00496554
    fmul qword ptr [0x52db80]                    # 00496557
    fstp dword ptr [ebp - local_128]             # 0049655d
    mov eax, dword ptr [ebp - local_288]         # 00496563
    fild dword ptr [eax + field_1ef7]            # 00496569
    fstp dword ptr [ebp - local_28c]             # 0049656f
    fld dword ptr [ebp - local_d8]               # 00496575
    fadd dword ptr [ebp - local_28c]             # 0049657b
    fstp dword ptr [ebp - local_d8]              # 00496581
    mov ecx, dword ptr [ebp - local_288]         # 00496587
    fild dword ptr [ecx + field_1efb]            # 0049658d
    fstp dword ptr [ebp - local_290]             # 00496593
    fld dword ptr [ebp - local_128]              # 00496599
    fadd dword ptr [ebp - local_290]             # 0049659f
    fstp dword ptr [ebp - local_128]             # 004965a5
    mov edx, dword ptr [ebp - local_288]         # 004965ab
    fild dword ptr [edx + field_1ef7]            # 004965b1
    mov eax, dword ptr [ebp - local_288]         # 004965b7
    fstp dword ptr [eax + field_50a5]            # 004965bd
    mov ecx, dword ptr [ebp - local_288]         # 004965c3
    fild dword ptr [ecx + field_1efb]            # 004965c9
    mov edx, dword ptr [ebp - local_288]         # 004965cf
    fstp dword ptr [edx + field_50a9]            # 004965d5
    mov eax, dword ptr [ebp - local_288]         # 004965db
    fild dword ptr [eax + field_1ef7]            # 004965e1
    fstp dword ptr [ebp - local_294]             # 004965e7
    fld dword ptr [ebp - local_d8]               # 004965ed
    fsub dword ptr [ebp - local_294]             # 004965f3
    mov ecx, dword ptr [ebp - local_288]         # 004965f9
    fstp dword ptr [ecx + field_5099]            # 004965ff
    mov edx, dword ptr [ebp - local_288]         # 00496605
    fild dword ptr [edx + field_1efb]            # 0049660b
    fstp dword ptr [ebp - local_298]             # 00496611
    fld dword ptr [ebp - local_128]              # 00496617
    fsub dword ptr [ebp - local_298]             # 0049661d
    mov eax, dword ptr [ebp - local_288]         # 00496623
    fstp dword ptr [eax + field_509d]            # 00496629
    mov ecx, dword ptr [ebp - local_288]         # 0049662f
    fld dword ptr [ecx + field_5099]             # 00496635
    fcomp dword ptr [0x52db78]                   # 0049663b
    fnstsw ax                                    # 00496641
    test ah, 0x40                                # 00496643
    je.d8 L_00496658                             # 00496646
    # block 0x00496648: entered by fall-through of je at 0x00496646, 2 instruction(s), falls into the block at 0x00496658
    mov edx, dword ptr [ebp - local_288]         # 00496648
    mov dword ptr [edx + field_5099], 0x3a83126f # 0049664e
L_00496658:
    # block 0x00496658: entered by je at 0x00496646, 6 instruction(s), ends with je to 0x00496681 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00496658
    fld dword ptr [eax + field_509d]             # 0049665e
    fcomp dword ptr [0x52db78]                   # 00496664
    fnstsw ax                                    # 0049666a
    test ah, 0x40                                # 0049666c
    je.d8 L_00496681                             # 0049666f
    # block 0x00496671: entered by fall-through of je at 0x0049666f, 2 instruction(s), falls into the block at 0x00496681
    mov ecx, dword ptr [ebp - local_288]         # 00496671
    mov dword ptr [ecx + field_509d], 0x3a83126f # 00496677
L_00496681:
    # block 0x00496681: entered by je at 0x0049666f, 12 instruction(s), ends with je to 0x004966ce (forward)
    mov edx, dword ptr [ebp - local_288]         # 00496681
    mov eax, dword ptr [ebp - local_288]         # 00496687
    fld dword ptr [edx + field_509d]             # 0049668d
    fdiv dword ptr [eax + field_5099]            # 00496693
    mov ecx, dword ptr [ebp - local_288]         # 00496699
    fstp dword ptr [ecx + field_50a1]            # 0049669f
    mov edx, dword ptr [ebp - local_288]         # 004966a5
    fld dword ptr [edx + field_50a1]             # 004966ab
    fcomp dword ptr [0x52db78]                   # 004966b1
    fnstsw ax                                    # 004966b7
    test ah, 0x40                                # 004966b9
    je.d8 L_004966ce                             # 004966bc
    # block 0x004966be: entered by fall-through of je at 0x004966bc, 2 instruction(s), falls into the block at 0x004966ce
    mov eax, dword ptr [ebp - local_288]         # 004966be
    mov dword ptr [eax + field_50a1], 0x3a83126f # 004966c4
L_004966ce:
    # block 0x004966ce: entered by je at 0x004966bc, 5 instruction(s), falls into the block at 0x004966ee
    mov ecx, dword ptr [ebp - local_288]         # 004966ce
    mov edx, dword ptr [ecx + field_477d]        # 004966d4
    mov dword ptr [ebp - local_24], edx          # 004966da
    mov dword ptr [ebp - local_15c], 0x0         # 004966dd
    mov dword ptr [ebp - local_8], 0x0           # 004966e7
L_004966ee:
    # block 0x004966ee: entered by jmp at 0x0049b9e7, 2 instruction(s), ends with jne to 0x0049b9ec (forward)
    cmp dword ptr [ebp - local_15c], 0x0         # 004966ee
    jne.d32 L_0049b9ec                           # 004966f5
L_004966fb:
    # block 0x004966fb: entered by jmp at 0x00498236; fall-through of jne at 0x004966f5, 6 instruction(s), ends with jne to 0x00496744 (forward)
    mov eax, dword ptr [ebp - local_288]         # 004966fb
    fld dword ptr [eax + field_5099]             # 00496701
    fcomp dword ptr [0x52db78]                   # 00496707
    fnstsw ax                                    # 0049670d
    test ah, 0x41                                # 0049670f
    jne.d8 L_00496744                            # 00496712
    # block 0x00496714: entered by fall-through of jne at 0x00496712, 9 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x00496769
    mov ecx, dword ptr [ebp - local_288]         # 00496714
    fld dword ptr [ecx + field_50a5]             # 0049671a
    call FUN_0050ce04                            # 00496720
    and eax, 0xff80                              # 00496725
    mov edx, dword ptr [ebp - local_288]         # 0049672a
    add eax, dword ptr [edx + field_2095]        # 00496730
    mov ecx, dword ptr [ebp - local_288]         # 00496736
    mov dword ptr [ecx + field_50c5], eax        # 0049673c
    jmp.d8 L_00496769                            # 00496742
L_00496744:
    # block 0x00496744: entered by jne at 0x00496712, 7 instruction(s), calls FUN_0050ce04, falls into the block at 0x00496769
    mov edx, dword ptr [ebp - local_288]         # 00496744
    fld dword ptr [edx + field_50a5]             # 0049674a
    call FUN_0050ce04                            # 00496750
    and eax, 0xff80                              # 00496755
    sub eax, 0x1                                 # 0049675a
    mov ecx, dword ptr [ebp - local_288]         # 0049675d
    mov dword ptr [ecx + field_50c5], eax        # 00496763
L_00496769:
    # block 0x00496769: entered by jmp at 0x00496742, 44 instruction(s), ends with je to 0x00496868 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00496769
    fild dword ptr [edx + field_50c5]            # 0049676f
    mov eax, dword ptr [ebp - local_288]         # 00496775
    fstp dword ptr [eax + field_5081]            # 0049677b
    mov ecx, dword ptr [ebp - local_288]         # 00496781
    fild dword ptr [ecx + field_50c5]            # 00496787
    fstp dword ptr [ebp - local_29c]             # 0049678d
    mov edx, dword ptr [ebp - local_288]         # 00496793
    fld dword ptr [ebp - local_29c]              # 00496799
    fsub dword ptr [edx + field_50a5]            # 0049679f
    mov eax, dword ptr [ebp - local_288]         # 004967a5
    fmul dword ptr [eax + field_50a1]            # 004967ab
    mov ecx, dword ptr [ebp - local_288]         # 004967b1
    fadd dword ptr [ecx + field_50a9]            # 004967b7
    mov edx, dword ptr [ebp - local_288]         # 004967bd
    fstp dword ptr [edx + field_5085]            # 004967c3
    mov eax, dword ptr [ebp - local_288]         # 004967c9
    mov ecx, dword ptr [eax + field_1efb]        # 004967cf
    mov dword ptr [ebp - local_190], ecx         # 004967d5
    mov edx, dword ptr [ebp - local_288]         # 004967db
    mov eax, dword ptr [edx + field_1ef7]        # 004967e1
    mov dword ptr [ebp - local_18c], eax         # 004967e7
    mov ecx, dword ptr [ebp - local_288]         # 004967ed
    mov edx, dword ptr [ecx + field_5085]        # 004967f3
    mov dword ptr [ebp - local_188], edx         # 004967f9
    mov eax, dword ptr [ebp - local_288]         # 004967ff
    mov ecx, dword ptr [eax + field_5081]        # 00496805
    mov dword ptr [ebp - local_184], ecx         # 0049680b
    mov edx, dword ptr [ebp - local_288]         # 00496811
    mov eax, dword ptr [edx + field_50c1]        # 00496817
    mov dword ptr [ebp - local_180], eax         # 0049681d
    mov ecx, dword ptr [ebp - local_288]         # 00496823
    mov edx, dword ptr [ecx + field_50cd]        # 00496829
    mov dword ptr [ebp - local_17c], edx         # 0049682f
    mov eax, dword ptr [ebp - local_17c]         # 00496835
    cdq                                          # 0049683b
    and edx, 0x1ff                               # 0049683c
    {load} add eax, edx                          # 00496842
    sar eax, 0x9                                 # 00496844
    mov dword ptr [ebp - local_178], eax         # 00496847
    mov eax, dword ptr [ebp - local_178]         # 0049684d
    and eax, 0x3                                 # 00496853
    test eax, eax                                # 00496856
    je.d8 L_00496868                             # 00496858
    # block 0x0049685a: entered by fall-through of je at 0x00496858, 4 instruction(s), ends with jne to 0x004968d7 (forward)
    mov ecx, dword ptr [ebp - local_178]         # 0049685a
    and ecx, 0x3                                 # 00496860
    cmp ecx, 0x3                                 # 00496863
    jne.d8 L_004968d7                            # 00496866
L_00496868:
    # block 0x00496868: entered by je at 0x00496858; fall-through of jne at 0x00496866, 24 instruction(s), calls FUN_0050e3de, ends with forward jump to 0x00496946
    fild dword ptr [ebp - local_190]             # 00496868
    fstp dword ptr [ebp - local_2a0]             # 0049686e
    fld dword ptr [ebp - local_188]              # 00496874
    fsub dword ptr [ebp - local_2a0]             # 0049687a
    mov edx, dword ptr [ebp - local_178]         # 00496880
    shl edx, 0xa                                 # 00496886
    shl edx                                      # 00496889
    mov eax, dword ptr [ebp - local_17c]         # 0049688b
    {load} sub eax, edx                          # 00496891
    and eax, 0xfff                               # 00496893
    mov ecx, dword ptr [ebp - local_288]         # 00496898
    mov edx, dword ptr [ecx + field_200f]        # 0049689e
    fdiv dword ptr [edx + 4*eax]                 # 004968a4
    mov eax, dword ptr [ebp - local_180]         # 004968a7
    and eax, 0xfff                               # 004968ad
    mov ecx, dword ptr [ebp - local_288]         # 004968b2
    mov edx, dword ptr [ecx + field_200f]        # 004968b8
    fmul dword ptr [edx + 4*eax]                 # 004968be
    sub esp, 0x8                                 # 004968c1
    fstp qword ptr [esp]                         # 004968c4
    call FUN_0050e3de                            # 004968c7
    add esp, 0x8                                 # 004968cc
    fstp dword ptr [ebp - local_174]             # 004968cf
    jmp.d8 L_00496946                            # 004968d5
L_004968d7:
    # block 0x004968d7: entered by jne at 0x00496866, 23 instruction(s), calls FUN_0050e3de, falls into the block at 0x00496946
    fild dword ptr [ebp - local_18c]             # 004968d7
    fstp dword ptr [ebp - local_2a4]             # 004968dd
    fld dword ptr [ebp - local_184]              # 004968e3
    fsub dword ptr [ebp - local_2a4]             # 004968e9
    mov eax, dword ptr [ebp - local_178]         # 004968ef
    shl eax, 0xa                                 # 004968f5
    shl eax                                      # 004968f8
    mov ecx, dword ptr [ebp - local_17c]         # 004968fa
    {load} sub ecx, eax                          # 00496900
    and ecx, 0xfff                               # 00496902
    mov edx, dword ptr [ebp - local_288]         # 00496908
    mov eax, dword ptr [edx + field_2013]        # 0049690e
    fdiv dword ptr [eax + 4*ecx]                 # 00496914
    mov ecx, dword ptr [ebp - local_180]         # 00496917
    and ecx, 0xfff                               # 0049691d
    mov edx, dword ptr [ebp - local_288]         # 00496923
    mov eax, dword ptr [edx + field_200f]        # 00496929
    fmul dword ptr [eax + 4*ecx]                 # 0049692f
    sub esp, 0x8                                 # 00496932
    fstp qword ptr [esp]                         # 00496935
    call FUN_0050e3de                            # 00496938
    add esp, 0x8                                 # 0049693d
    fstp dword ptr [ebp - local_174]             # 00496940
L_00496946:
    # block 0x00496946: entered by jmp at 0x004968d5, 9 instruction(s), ends with jne to 0x004969a1 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00496946
    mov edx, dword ptr [ebp - local_174]         # 0049694c
    mov dword ptr [ecx + field_5091], edx        # 00496952
    mov eax, dword ptr [ebp - local_288]         # 00496958
    fld dword ptr [eax + field_509d]             # 0049695e
    fcomp dword ptr [0x52db78]                   # 00496964
    fnstsw ax                                    # 0049696a
    test ah, 0x41                                # 0049696c
    jne.d8 L_004969a1                            # 0049696f
    # block 0x00496971: entered by fall-through of jne at 0x0049696f, 9 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004969c6
    mov ecx, dword ptr [ebp - local_288]         # 00496971
    fld dword ptr [ecx + field_50a9]             # 00496977
    call FUN_0050ce04                            # 0049697d
    and eax, 0xff80                              # 00496982
    mov edx, dword ptr [ebp - local_288]         # 00496987
    add eax, dword ptr [edx + field_2095]        # 0049698d
    mov ecx, dword ptr [ebp - local_288]         # 00496993
    mov dword ptr [ecx + field_50c9], eax        # 00496999
    jmp.d8 L_004969c6                            # 0049699f
L_004969a1:
    # block 0x004969a1: entered by jne at 0x0049696f, 7 instruction(s), calls FUN_0050ce04, falls into the block at 0x004969c6
    mov edx, dword ptr [ebp - local_288]         # 004969a1
    fld dword ptr [edx + field_50a9]             # 004969a7
    call FUN_0050ce04                            # 004969ad
    and eax, 0xff80                              # 004969b2
    sub eax, 0x1                                 # 004969b7
    mov ecx, dword ptr [ebp - local_288]         # 004969ba
    mov dword ptr [ecx + field_50c9], eax        # 004969c0
L_004969c6:
    # block 0x004969c6: entered by jmp at 0x0049699f, 44 instruction(s), ends with je to 0x00496ac5 (forward)
    mov edx, dword ptr [ebp - local_288]         # 004969c6
    fild dword ptr [edx + field_50c9]            # 004969cc
    fstp dword ptr [ebp - local_2a8]             # 004969d2
    mov eax, dword ptr [ebp - local_288]         # 004969d8
    fld dword ptr [ebp - local_2a8]              # 004969de
    fsub dword ptr [eax + field_50a9]            # 004969e4
    mov ecx, dword ptr [ebp - local_288]         # 004969ea
    fdiv dword ptr [ecx + field_50a1]            # 004969f0
    mov edx, dword ptr [ebp - local_288]         # 004969f6
    fadd dword ptr [edx + field_50a5]            # 004969fc
    mov eax, dword ptr [ebp - local_288]         # 00496a02
    fstp dword ptr [eax + field_5089]            # 00496a08
    mov ecx, dword ptr [ebp - local_288]         # 00496a0e
    fild dword ptr [ecx + field_50c9]            # 00496a14
    mov edx, dword ptr [ebp - local_288]         # 00496a1a
    fstp dword ptr [edx + field_508d]            # 00496a20
    mov eax, dword ptr [ebp - local_288]         # 00496a26
    mov ecx, dword ptr [eax + field_1efb]        # 00496a2c
    mov dword ptr [ebp - local_1b0], ecx         # 00496a32
    mov edx, dword ptr [ebp - local_288]         # 00496a38
    mov eax, dword ptr [edx + field_1ef7]        # 00496a3e
    mov dword ptr [ebp - local_1ac], eax         # 00496a44
    mov ecx, dword ptr [ebp - local_288]         # 00496a4a
    mov edx, dword ptr [ecx + field_508d]        # 00496a50
    mov dword ptr [ebp - local_1a8], edx         # 00496a56
    mov eax, dword ptr [ebp - local_288]         # 00496a5c
    mov ecx, dword ptr [eax + field_5089]        # 00496a62
    mov dword ptr [ebp - local_1a4], ecx         # 00496a68
    mov edx, dword ptr [ebp - local_288]         # 00496a6e
    mov eax, dword ptr [edx + field_50c1]        # 00496a74
    mov dword ptr [ebp - local_1a0], eax         # 00496a7a
    mov ecx, dword ptr [ebp - local_288]         # 00496a80
    mov edx, dword ptr [ecx + field_50cd]        # 00496a86
    mov dword ptr [ebp - local_19c], edx         # 00496a8c
    mov eax, dword ptr [ebp - local_19c]         # 00496a92
    cdq                                          # 00496a98
    and edx, 0x1ff                               # 00496a99
    {load} add eax, edx                          # 00496a9f
    sar eax, 0x9                                 # 00496aa1
    mov dword ptr [ebp - local_198], eax         # 00496aa4
    mov eax, dword ptr [ebp - local_198]         # 00496aaa
    and eax, 0x3                                 # 00496ab0
    test eax, eax                                # 00496ab3
    je.d8 L_00496ac5                             # 00496ab5
    # block 0x00496ab7: entered by fall-through of je at 0x00496ab5, 4 instruction(s), ends with jne to 0x00496b34 (forward)
    mov ecx, dword ptr [ebp - local_198]         # 00496ab7
    and ecx, 0x3                                 # 00496abd
    cmp ecx, 0x3                                 # 00496ac0
    jne.d8 L_00496b34                            # 00496ac3
L_00496ac5:
    # block 0x00496ac5: entered by je at 0x00496ab5; fall-through of jne at 0x00496ac3, 24 instruction(s), calls FUN_0050e3de, ends with forward jump to 0x00496ba3
    fild dword ptr [ebp - local_1b0]             # 00496ac5
    fstp dword ptr [ebp - local_2ac]             # 00496acb
    fld dword ptr [ebp - local_1a8]              # 00496ad1
    fsub dword ptr [ebp - local_2ac]             # 00496ad7
    mov edx, dword ptr [ebp - local_198]         # 00496add
    shl edx, 0xa                                 # 00496ae3
    shl edx                                      # 00496ae6
    mov eax, dword ptr [ebp - local_19c]         # 00496ae8
    {load} sub eax, edx                          # 00496aee
    and eax, 0xfff                               # 00496af0
    mov ecx, dword ptr [ebp - local_288]         # 00496af5
    mov edx, dword ptr [ecx + field_200f]        # 00496afb
    fdiv dword ptr [edx + 4*eax]                 # 00496b01
    mov eax, dword ptr [ebp - local_1a0]         # 00496b04
    and eax, 0xfff                               # 00496b0a
    mov ecx, dword ptr [ebp - local_288]         # 00496b0f
    mov edx, dword ptr [ecx + field_200f]        # 00496b15
    fmul dword ptr [edx + 4*eax]                 # 00496b1b
    sub esp, 0x8                                 # 00496b1e
    fstp qword ptr [esp]                         # 00496b21
    call FUN_0050e3de                            # 00496b24
    add esp, 0x8                                 # 00496b29
    fstp dword ptr [ebp - local_194]             # 00496b2c
    jmp.d8 L_00496ba3                            # 00496b32
L_00496b34:
    # block 0x00496b34: entered by jne at 0x00496ac3, 23 instruction(s), calls FUN_0050e3de, falls into the block at 0x00496ba3
    fild dword ptr [ebp - local_1ac]             # 00496b34
    fstp dword ptr [ebp - local_2b0]             # 00496b3a
    fld dword ptr [ebp - local_1a4]              # 00496b40
    fsub dword ptr [ebp - local_2b0]             # 00496b46
    mov eax, dword ptr [ebp - local_198]         # 00496b4c
    shl eax, 0xa                                 # 00496b52
    shl eax                                      # 00496b55
    mov ecx, dword ptr [ebp - local_19c]         # 00496b57
    {load} sub ecx, eax                          # 00496b5d
    and ecx, 0xfff                               # 00496b5f
    mov edx, dword ptr [ebp - local_288]         # 00496b65
    mov eax, dword ptr [edx + field_2013]        # 00496b6b
    fdiv dword ptr [eax + 4*ecx]                 # 00496b71
    mov ecx, dword ptr [ebp - local_1a0]         # 00496b74
    and ecx, 0xfff                               # 00496b7a
    mov edx, dword ptr [ebp - local_288]         # 00496b80
    mov eax, dword ptr [edx + field_200f]        # 00496b86
    fmul dword ptr [eax + 4*ecx]                 # 00496b8c
    sub esp, 0x8                                 # 00496b8f
    fstp qword ptr [esp]                         # 00496b92
    call FUN_0050e3de                            # 00496b95
    add esp, 0x8                                 # 00496b9a
    fstp dword ptr [ebp - local_194]             # 00496b9d
L_00496ba3:
    # block 0x00496ba3: entered by jmp at 0x00496b32, 14 instruction(s), ends with je to 0x00496ce6 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00496ba3
    mov edx, dword ptr [ebp - local_194]         # 00496ba9
    mov dword ptr [ecx + field_5095], edx        # 00496baf
    mov eax, dword ptr [ebp - local_288]         # 00496bb5
    mov dword ptr [eax + field_50e1], 0xffffffff # 00496bbb
    mov ecx, dword ptr [ebp - local_288]         # 00496bc5
    mov dword ptr [ecx + field_50e5], 0xffffffff # 00496bcb
    mov edx, dword ptr [ebp - local_288]         # 00496bd5
    mov eax, dword ptr [ebp - local_288]         # 00496bdb
    fld dword ptr [edx + field_5091]             # 00496be1
    fcomp dword ptr [eax + field_20ad]           # 00496be7
    fnstsw ax                                    # 00496bed
    test ah, 0x1                                 # 00496bef
    je.d32 L_00496ce6                            # 00496bf2
    # block 0x00496bf8: entered by fall-through of je at 0x00496bf2, 22 instruction(s), calls FUN_0050ce04, ends with jg to 0x00496ce6 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00496bf8
    fld dword ptr [ecx + field_5081]             # 00496bfe
    call FUN_0050ce04                            # 00496c04
    mov edx, dword ptr [ebp - local_288]         # 00496c09
    mov ecx, dword ptr [edx + field_47d1]        # 00496c0f
    sar eax, cl                                  # 00496c15
    mov ecx, dword ptr [ebp - local_288]         # 00496c17
    mov dword ptr [ecx + field_50d1], eax        # 00496c1d
    mov edx, dword ptr [ebp - local_288]         # 00496c23
    fild dword ptr [edx + field_2095]            # 00496c29
    fstp dword ptr [ebp - local_2b4]             # 00496c2f
    mov eax, dword ptr [ebp - local_288]         # 00496c35
    fld dword ptr [eax + field_5085]             # 00496c3b
    fdiv dword ptr [ebp - local_2b4]             # 00496c41
    call FUN_0050ce04                            # 00496c47
    mov ecx, dword ptr [ebp - local_288]         # 00496c4c
    mov dword ptr [ecx + field_50d5], eax        # 00496c52
    mov edx, dword ptr [ebp - local_288]         # 00496c58
    mov eax, dword ptr [ebp - local_288]         # 00496c5e
    mov ecx, dword ptr [edx + field_50d1]        # 00496c64
    cmp ecx, dword ptr [eax + field_20b1]        # 00496c6a
    jg.d8 L_00496ce6                             # 00496c70
    # block 0x00496c72: entered by fall-through of jg at 0x00496c70, 5 instruction(s), ends with jg to 0x00496ce6 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00496c72
    mov eax, dword ptr [ebp - local_288]         # 00496c78
    mov ecx, dword ptr [edx + field_50d5]        # 00496c7e
    cmp ecx, dword ptr [eax + field_20b1]        # 00496c84
    jg.d8 L_00496ce6                             # 00496c8a
    # block 0x00496c8c: entered by fall-through of jg at 0x00496c8a, 3 instruction(s), ends with jl to 0x00496ce6 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00496c8c
    cmp dword ptr [edx + field_50d1], 0x0        # 00496c92
    jl.d8 L_00496ce6                             # 00496c99
    # block 0x00496c9b: entered by fall-through of jl at 0x00496c99, 3 instruction(s), ends with jl to 0x00496ce6 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00496c9b
    cmp dword ptr [eax + field_50d5], 0x0        # 00496ca1
    jl.d8 L_00496ce6                             # 00496ca8
    # block 0x00496caa: entered by fall-through of jl at 0x00496ca8, 11 instruction(s), falls into the block at 0x00496ce6
    mov ecx, dword ptr [ebp - local_288]         # 00496caa
    mov edx, dword ptr [ecx + field_50d1]        # 00496cb0
    imul edx, edx, 0xa6                          # 00496cb6
    mov eax, dword ptr [ebp - local_288]         # 00496cbc
    mov ecx, dword ptr [eax + field_1f47]        # 00496cc2
    lea edx, [ecx + 4*edx]                       # 00496cc8
    mov eax, dword ptr [ebp - local_288]         # 00496ccb
    mov ecx, dword ptr [eax + field_50d5]        # 00496cd1
    mov eax, dword ptr [ebp - local_288]         # 00496cd7
    mov ecx, dword ptr [edx + 4*ecx]             # 00496cdd
    mov dword ptr [eax + field_50e1], ecx        # 00496ce0
L_00496ce6:
    # block 0x00496ce6: entered by je at 0x00496bf2; jg at 0x00496c70; jg at 0x00496c8a; jl at 0x00496c99; jl at 0x00496ca8, 7 instruction(s), ends with je to 0x00496df7 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00496ce6
    mov eax, dword ptr [ebp - local_288]         # 00496cec
    fld dword ptr [edx + field_5095]             # 00496cf2
    fcomp dword ptr [eax + field_20ad]           # 00496cf8
    fnstsw ax                                    # 00496cfe
    test ah, 0x1                                 # 00496d00
    je.d32 L_00496df7                            # 00496d03
    # block 0x00496d09: entered by fall-through of je at 0x00496d03, 22 instruction(s), calls FUN_0050ce04, ends with jg to 0x00496df7 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00496d09
    fild dword ptr [ecx + field_2095]            # 00496d0f
    fstp dword ptr [ebp - local_2b8]             # 00496d15
    mov edx, dword ptr [ebp - local_288]         # 00496d1b
    fld dword ptr [edx + field_5089]             # 00496d21
    fdiv dword ptr [ebp - local_2b8]             # 00496d27
    call FUN_0050ce04                            # 00496d2d
    mov ecx, dword ptr [ebp - local_288]         # 00496d32
    mov dword ptr [ecx + field_50d9], eax        # 00496d38
    mov edx, dword ptr [ebp - local_288]         # 00496d3e
    fld dword ptr [edx + field_508d]             # 00496d44
    call FUN_0050ce04                            # 00496d4a
    mov ecx, dword ptr [ebp - local_288]         # 00496d4f
    mov ecx, dword ptr [ecx + field_47d1]        # 00496d55
    sar eax, cl                                  # 00496d5b
    mov edx, dword ptr [ebp - local_288]         # 00496d5d
    mov dword ptr [edx + field_50dd], eax        # 00496d63
    mov eax, dword ptr [ebp - local_288]         # 00496d69
    mov ecx, dword ptr [ebp - local_288]         # 00496d6f
    mov edx, dword ptr [eax + field_50d9]        # 00496d75
    cmp edx, dword ptr [ecx + field_20b1]        # 00496d7b
    jg.d8 L_00496df7                             # 00496d81
    # block 0x00496d83: entered by fall-through of jg at 0x00496d81, 5 instruction(s), ends with jg to 0x00496df7 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00496d83
    mov ecx, dword ptr [ebp - local_288]         # 00496d89
    mov edx, dword ptr [eax + field_50dd]        # 00496d8f
    cmp edx, dword ptr [ecx + field_20b1]        # 00496d95
    jg.d8 L_00496df7                             # 00496d9b
    # block 0x00496d9d: entered by fall-through of jg at 0x00496d9b, 3 instruction(s), ends with jl to 0x00496df7 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00496d9d
    cmp dword ptr [eax + field_50d9], 0x0        # 00496da3
    jl.d8 L_00496df7                             # 00496daa
    # block 0x00496dac: entered by fall-through of jl at 0x00496daa, 3 instruction(s), ends with jl to 0x00496df7 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00496dac
    cmp dword ptr [ecx + field_50dd], 0x0        # 00496db2
    jl.d8 L_00496df7                             # 00496db9
    # block 0x00496dbb: entered by fall-through of jl at 0x00496db9, 11 instruction(s), falls into the block at 0x00496df7
    mov edx, dword ptr [ebp - local_288]         # 00496dbb
    mov eax, dword ptr [edx + field_50d9]        # 00496dc1
    imul eax, eax, 0xa6                          # 00496dc7
    mov ecx, dword ptr [ebp - local_288]         # 00496dcd
    mov edx, dword ptr [ecx + field_1f47]        # 00496dd3
    lea eax, [edx + 4*eax]                       # 00496dd9
    mov ecx, dword ptr [ebp - local_288]         # 00496ddc
    mov edx, dword ptr [ecx + field_50dd]        # 00496de2
    mov ecx, dword ptr [ebp - local_288]         # 00496de8
    mov edx, dword ptr [eax + 4*edx]             # 00496dee
    mov dword ptr [ecx + field_50e5], edx        # 00496df1
L_00496df7:
    # block 0x00496df7: entered by je at 0x00496d03; jg at 0x00496d81; jg at 0x00496d9b; jl at 0x00496daa; jl at 0x00496db9, 3 instruction(s), ends with jne to 0x00496e91 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00496df7
    cmp dword ptr [eax + field_50e1], -0x1       # 00496dfd
    jne.d32 L_00496e91                           # 00496e04
    # block 0x00496e0a: entered by fall-through of jne at 0x00496e04, 3 instruction(s), ends with jne to 0x00496e91 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00496e0a
    cmp dword ptr [ecx + field_50e5], -0x1       # 00496e10
    jne.d8 L_00496e91                            # 00496e17
    # block 0x00496e19: entered by fall-through of jne at 0x00496e17, 23 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x00496e87 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00496e19
    fld dword ptr [edx + field_20ad]             # 00496e1f
    sub esp, 0x8                                 # 00496e25
    fstp qword ptr [esp]                         # 00496e28
    mov eax, dword ptr [ebp - local_288]         # 00496e2b
    fld dword ptr [eax + field_5095]             # 00496e31
    sub esp, 0x8                                 # 00496e37
    fstp qword ptr [esp]                         # 00496e3a
    mov ecx, dword ptr [ebp - local_288]         # 00496e3d
    fld dword ptr [ecx + field_5091]             # 00496e43
    sub esp, 0x8                                 # 00496e49
    fstp qword ptr [esp]                         # 00496e4c
    push 0x54f950                                # 00496e4f
    push 0x63888b                                # 00496e54
    call FUN_0050ca3e                            # 00496e59
    add esp, 0x20                                # 00496e5e
    push 0x0                                     # 00496e61
    push 0x0                                     # 00496e63
    push 0x63888b                                # 00496e65
    call FUN_0052139c                            # 00496e6a
    movsx edx, word ptr [0x63a4cd]               # 00496e6f
    test edx, edx                                # 00496e76
    je.d8 L_00496e87                             # 00496e78
    # block 0x00496e7a: entered by fall-through of je at 0x00496e78, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00496e87
    push 0x63888b                                # 00496e7a
    call FUN_0044a2b7                            # 00496e7f
    add esp, 0x4                                 # 00496e84
L_00496e87:
    # block 0x00496e87: entered by je at 0x00496e78, 2 instruction(s), calls FUN_004c97b4, falls into the block at 0x00496e91
    mov ecx, 0x5cf659                            # 00496e87
    call FUN_004c97b4                            # 00496e8c
L_00496e91:
    # block 0x00496e91: entered by jne at 0x00496e04; jne at 0x00496e17, 3 instruction(s), ends with jle to 0x00497504 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00496e91
    cmp dword ptr [eax + field_50e5], 0x0        # 00496e97
    jle.d32 L_00497504                           # 00496e9e
    # block 0x00496ea4: entered by fall-through of jle at 0x00496e9e, 5 instruction(s), ends with je to 0x00497504 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00496ea4
    mov edx, dword ptr [ecx + field_50e5]        # 00496eaa
    and edx, 0x4000000                           # 00496eb0
    test edx, edx                                # 00496eb6
    je.d32 L_00497504                            # 00496eb8
    # block 0x00496ebe: entered by fall-through of je at 0x00496eb8, 6 instruction(s), ends with jne to 0x00496f01 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00496ebe
    fld dword ptr [eax + field_509d]             # 00496ec4
    fcomp dword ptr [0x52db78]                   # 00496eca
    fnstsw ax                                    # 00496ed0
    test ah, 0x41                                # 00496ed2
    jne.d8 L_00496f01                            # 00496ed5
    # block 0x00496ed7: entered by fall-through of jne at 0x00496ed5, 8 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x00496f20
    mov ecx, dword ptr [ebp - local_288]         # 00496ed7
    fld dword ptr [ecx + field_508d]             # 00496edd
    call FUN_0050ce04                            # 00496ee3
    and eax, 0xff80                              # 00496ee8
    mov edx, dword ptr [ebp - local_288]         # 00496eed
    add eax, dword ptr [edx + field_2095]        # 00496ef3
    mov dword ptr [ebp - local_1c0], eax         # 00496ef9
    jmp.d8 L_00496f20                            # 00496eff
L_00496f01:
    # block 0x00496f01: entered by jne at 0x00496ed5, 6 instruction(s), calls FUN_0050ce04, falls into the block at 0x00496f20
    mov eax, dword ptr [ebp - local_288]         # 00496f01
    fld dword ptr [eax + field_508d]             # 00496f07
    call FUN_0050ce04                            # 00496f0d
    and eax, 0xff80                              # 00496f12
    sub eax, 0x1                                 # 00496f17
    mov dword ptr [ebp - local_1c0], eax         # 00496f1a
L_00496f20:
    # block 0x00496f20: entered by jmp at 0x00496eff, 62 instruction(s), ends with je to 0x00497083 (forward)
    fild dword ptr [ebp - local_1c0]             # 00496f20
    fstp dword ptr [ebp - local_2bc]             # 00496f26
    mov ecx, dword ptr [ebp - local_288]         # 00496f2c
    fld dword ptr [ebp - local_2bc]              # 00496f32
    fsub dword ptr [ecx + field_508d]            # 00496f38
    mov edx, dword ptr [ebp - local_288]         # 00496f3e
    fdiv dword ptr [edx + field_50a1]            # 00496f44
    mov eax, dword ptr [ebp - local_288]         # 00496f4a
    fadd dword ptr [eax + field_5089]            # 00496f50
    fstp dword ptr [ebp - local_1bc]             # 00496f56
    fild dword ptr [ebp - local_1c0]             # 00496f5c
    fstp dword ptr [ebp - local_1c4]             # 00496f62
    mov ecx, dword ptr [ebp - local_288]         # 00496f68
    fld dword ptr [ecx + field_5089]             # 00496f6e
    mov edx, dword ptr [ebp - local_288]         # 00496f74
    fld dword ptr [ebp - local_1bc]              # 00496f7a
    fsub dword ptr [edx + field_5089]            # 00496f80
    fdiv qword ptr [0x52c678]                    # 00496f86
    faddp st(1), st                              # 00496f8c
    fstp dword ptr [ebp - local_1b4]             # 00496f8e
    mov eax, dword ptr [ebp - local_288]         # 00496f94
    fld dword ptr [eax + field_508d]             # 00496f9a
    mov ecx, dword ptr [ebp - local_288]         # 00496fa0
    fld dword ptr [ebp - local_1c4]              # 00496fa6
    fsub dword ptr [ecx + field_508d]            # 00496fac
    fdiv qword ptr [0x52c678]                    # 00496fb2
    faddp st(1), st                              # 00496fb8
    fstp dword ptr [ebp - local_1b8]             # 00496fba
    mov edx, dword ptr [ebp - local_288]         # 00496fc0
    mov eax, dword ptr [ebp - local_1b4]         # 00496fc6
    mov dword ptr [edx + field_5089], eax        # 00496fcc
    mov ecx, dword ptr [ebp - local_288]         # 00496fd2
    mov edx, dword ptr [ebp - local_1b8]         # 00496fd8
    mov dword ptr [ecx + field_508d], edx        # 00496fde
    mov eax, dword ptr [ebp - local_288]         # 00496fe4
    mov ecx, dword ptr [eax + field_1efb]        # 00496fea
    mov dword ptr [ebp - local_1e4], ecx         # 00496ff0
    mov edx, dword ptr [ebp - local_288]         # 00496ff6
    mov eax, dword ptr [edx + field_1ef7]        # 00496ffc
    mov dword ptr [ebp - local_1e0], eax         # 00497002
    mov ecx, dword ptr [ebp - local_288]         # 00497008
    mov edx, dword ptr [ecx + field_508d]        # 0049700e
    mov dword ptr [ebp - local_1dc], edx         # 00497014
    mov eax, dword ptr [ebp - local_288]         # 0049701a
    mov ecx, dword ptr [eax + field_5089]        # 00497020
    mov dword ptr [ebp - local_1d8], ecx         # 00497026
    mov edx, dword ptr [ebp - local_288]         # 0049702c
    mov eax, dword ptr [edx + field_50c1]        # 00497032
    mov dword ptr [ebp - local_1d4], eax         # 00497038
    mov ecx, dword ptr [ebp - local_288]         # 0049703e
    mov edx, dword ptr [ecx + field_50cd]        # 00497044
    mov dword ptr [ebp - local_1d0], edx         # 0049704a
    mov eax, dword ptr [ebp - local_1d0]         # 00497050
    cdq                                          # 00497056
    and edx, 0x1ff                               # 00497057
    {load} add eax, edx                          # 0049705d
    sar eax, 0x9                                 # 0049705f
    mov dword ptr [ebp - local_1cc], eax         # 00497062
    mov eax, dword ptr [ebp - local_1cc]         # 00497068
    and eax, 0x3                                 # 0049706e
    test eax, eax                                # 00497071
    je.d8 L_00497083                             # 00497073
    # block 0x00497075: entered by fall-through of je at 0x00497073, 4 instruction(s), ends with jne to 0x004970f2 (forward)
    mov ecx, dword ptr [ebp - local_1cc]         # 00497075
    and ecx, 0x3                                 # 0049707b
    cmp ecx, 0x3                                 # 0049707e
    jne.d8 L_004970f2                            # 00497081
L_00497083:
    # block 0x00497083: entered by je at 0x00497073; fall-through of jne at 0x00497081, 24 instruction(s), calls FUN_0050e3de, ends with forward jump to 0x00497161
    fild dword ptr [ebp - local_1e4]             # 00497083
    fstp dword ptr [ebp - local_2c0]             # 00497089
    fld dword ptr [ebp - local_1dc]              # 0049708f
    fsub dword ptr [ebp - local_2c0]             # 00497095
    mov edx, dword ptr [ebp - local_1cc]         # 0049709b
    shl edx, 0xa                                 # 004970a1
    shl edx                                      # 004970a4
    mov eax, dword ptr [ebp - local_1d0]         # 004970a6
    {load} sub eax, edx                          # 004970ac
    and eax, 0xfff                               # 004970ae
    mov ecx, dword ptr [ebp - local_288]         # 004970b3
    mov edx, dword ptr [ecx + field_200f]        # 004970b9
    fdiv dword ptr [edx + 4*eax]                 # 004970bf
    mov eax, dword ptr [ebp - local_1d4]         # 004970c2
    and eax, 0xfff                               # 004970c8
    mov ecx, dword ptr [ebp - local_288]         # 004970cd
    mov edx, dword ptr [ecx + field_200f]        # 004970d3
    fmul dword ptr [edx + 4*eax]                 # 004970d9
    sub esp, 0x8                                 # 004970dc
    fstp qword ptr [esp]                         # 004970df
    call FUN_0050e3de                            # 004970e2
    add esp, 0x8                                 # 004970e7
    fstp dword ptr [ebp - local_1c8]             # 004970ea
    jmp.d8 L_00497161                            # 004970f0
L_004970f2:
    # block 0x004970f2: entered by jne at 0x00497081, 23 instruction(s), calls FUN_0050e3de, falls into the block at 0x00497161
    fild dword ptr [ebp - local_1e0]             # 004970f2
    fstp dword ptr [ebp - local_2c4]             # 004970f8
    fld dword ptr [ebp - local_1d8]              # 004970fe
    fsub dword ptr [ebp - local_2c4]             # 00497104
    mov eax, dword ptr [ebp - local_1cc]         # 0049710a
    shl eax, 0xa                                 # 00497110
    shl eax                                      # 00497113
    mov ecx, dword ptr [ebp - local_1d0]         # 00497115
    {load} sub ecx, eax                          # 0049711b
    and ecx, 0xfff                               # 0049711d
    mov edx, dword ptr [ebp - local_288]         # 00497123
    mov eax, dword ptr [edx + field_2013]        # 00497129
    fdiv dword ptr [eax + 4*ecx]                 # 0049712f
    mov ecx, dword ptr [ebp - local_1d4]         # 00497132
    and ecx, 0xfff                               # 00497138
    mov edx, dword ptr [ebp - local_288]         # 0049713e
    mov eax, dword ptr [edx + field_200f]        # 00497144
    fmul dword ptr [eax + 4*ecx]                 # 0049714a
    sub esp, 0x8                                 # 0049714d
    fstp qword ptr [esp]                         # 00497150
    call FUN_0050e3de                            # 00497153
    add esp, 0x8                                 # 00497158
    fstp dword ptr [ebp - local_1c8]             # 0049715b
L_00497161:
    # block 0x00497161: entered by jmp at 0x004970f0, 12 instruction(s), ends with jne to 0x00497476 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00497161
    mov edx, dword ptr [ebp - local_1c8]         # 00497167
    mov dword ptr [ecx + field_50b5], edx        # 0049716d
    mov eax, dword ptr [ebp - local_288]         # 00497173
    mov ecx, dword ptr [ebp - local_288]         # 00497179
    mov edx, dword ptr [ecx + field_50b5]        # 0049717f
    mov dword ptr [eax + field_5095], edx        # 00497185
    mov eax, dword ptr [ebp - local_288]         # 0049718b
    mov ecx, dword ptr [ebp - local_288]         # 00497191
    mov edx, dword ptr [eax + field_50e1]        # 00497197
    cmp edx, dword ptr [ecx + field_50e5]        # 0049719d
    jne.d32 L_00497476                           # 004971a3
    # block 0x004971a9: entered by fall-through of jne at 0x004971a3, 6 instruction(s), ends with jne to 0x004971ec (forward)
    mov eax, dword ptr [ebp - local_288]         # 004971a9
    fld dword ptr [eax + field_5099]             # 004971af
    fcomp dword ptr [0x52db78]                   # 004971b5
    fnstsw ax                                    # 004971bb
    test ah, 0x41                                # 004971bd
    jne.d8 L_004971ec                            # 004971c0
    # block 0x004971c2: entered by fall-through of jne at 0x004971c0, 8 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x0049720b
    mov ecx, dword ptr [ebp - local_288]         # 004971c2
    fld dword ptr [ecx + field_5081]             # 004971c8
    call FUN_0050ce04                            # 004971ce
    and eax, 0xff80                              # 004971d3
    mov edx, dword ptr [ebp - local_288]         # 004971d8
    add eax, dword ptr [edx + field_2095]        # 004971de
    mov dword ptr [ebp - local_1f0], eax         # 004971e4
    jmp.d8 L_0049720b                            # 004971ea
L_004971ec:
    # block 0x004971ec: entered by jne at 0x004971c0, 6 instruction(s), calls FUN_0050ce04, falls into the block at 0x0049720b
    mov eax, dword ptr [ebp - local_288]         # 004971ec
    fld dword ptr [eax + field_5081]             # 004971f2
    call FUN_0050ce04                            # 004971f8
    and eax, 0xff80                              # 004971fd
    sub eax, 0x1                                 # 00497202
    mov dword ptr [ebp - local_1f0], eax         # 00497205
L_0049720b:
    # block 0x0049720b: entered by jmp at 0x004971ea, 62 instruction(s), ends with je to 0x0049736e (forward)
    fild dword ptr [ebp - local_1f0]             # 0049720b
    fstp dword ptr [ebp - local_1f8]             # 00497211
    fild dword ptr [ebp - local_1f0]             # 00497217
    fstp dword ptr [ebp - local_2c8]             # 0049721d
    mov ecx, dword ptr [ebp - local_288]         # 00497223
    fld dword ptr [ebp - local_2c8]              # 00497229
    fsub dword ptr [ecx + field_5081]            # 0049722f
    mov edx, dword ptr [ebp - local_288]         # 00497235
    fmul dword ptr [edx + field_50a1]            # 0049723b
    mov eax, dword ptr [ebp - local_288]         # 00497241
    fadd dword ptr [eax + field_5085]            # 00497247
    fstp dword ptr [ebp - local_1f4]             # 0049724d
    mov ecx, dword ptr [ebp - local_288]         # 00497253
    fld dword ptr [ecx + field_5081]             # 00497259
    mov edx, dword ptr [ebp - local_288]         # 0049725f
    fld dword ptr [ebp - local_1f8]              # 00497265
    fsub dword ptr [edx + field_5081]            # 0049726b
    fdiv qword ptr [0x52c678]                    # 00497271
    faddp st(1), st                              # 00497277
    fstp dword ptr [ebp - local_1ec]             # 00497279
    mov eax, dword ptr [ebp - local_288]         # 0049727f
    fld dword ptr [eax + field_5085]             # 00497285
    mov ecx, dword ptr [ebp - local_288]         # 0049728b
    fld dword ptr [ebp - local_1f4]              # 00497291
    fsub dword ptr [ecx + field_5085]            # 00497297
    fdiv qword ptr [0x52c678]                    # 0049729d
    faddp st(1), st                              # 004972a3
    fstp dword ptr [ebp - local_1e8]             # 004972a5
    mov edx, dword ptr [ebp - local_288]         # 004972ab
    mov eax, dword ptr [ebp - local_1ec]         # 004972b1
    mov dword ptr [edx + field_5081], eax        # 004972b7
    mov ecx, dword ptr [ebp - local_288]         # 004972bd
    mov edx, dword ptr [ebp - local_1e8]         # 004972c3
    mov dword ptr [ecx + field_5085], edx        # 004972c9
    mov eax, dword ptr [ebp - local_288]         # 004972cf
    mov ecx, dword ptr [eax + field_1efb]        # 004972d5
    mov dword ptr [ebp - local_218], ecx         # 004972db
    mov edx, dword ptr [ebp - local_288]         # 004972e1
    mov eax, dword ptr [edx + field_1ef7]        # 004972e7
    mov dword ptr [ebp - local_214], eax         # 004972ed
    mov ecx, dword ptr [ebp - local_288]         # 004972f3
    mov edx, dword ptr [ecx + field_5085]        # 004972f9
    mov dword ptr [ebp - local_210], edx         # 004972ff
    mov eax, dword ptr [ebp - local_288]         # 00497305
    mov ecx, dword ptr [eax + field_5081]        # 0049730b
    mov dword ptr [ebp - local_20c], ecx         # 00497311
    mov edx, dword ptr [ebp - local_288]         # 00497317
    mov eax, dword ptr [edx + field_50c1]        # 0049731d
    mov dword ptr [ebp - local_208], eax         # 00497323
    mov ecx, dword ptr [ebp - local_288]         # 00497329
    mov edx, dword ptr [ecx + field_50cd]        # 0049732f
    mov dword ptr [ebp - local_204], edx         # 00497335
    mov eax, dword ptr [ebp - local_204]         # 0049733b
    cdq                                          # 00497341
    and edx, 0x1ff                               # 00497342
    {load} add eax, edx                          # 00497348
    sar eax, 0x9                                 # 0049734a
    mov dword ptr [ebp - local_200], eax         # 0049734d
    mov eax, dword ptr [ebp - local_200]         # 00497353
    and eax, 0x3                                 # 00497359
    test eax, eax                                # 0049735c
    je.d8 L_0049736e                             # 0049735e
    # block 0x00497360: entered by fall-through of je at 0x0049735e, 4 instruction(s), ends with jne to 0x004973dd (forward)
    mov ecx, dword ptr [ebp - local_200]         # 00497360
    and ecx, 0x3                                 # 00497366
    cmp ecx, 0x3                                 # 00497369
    jne.d8 L_004973dd                            # 0049736c
L_0049736e:
    # block 0x0049736e: entered by je at 0x0049735e; fall-through of jne at 0x0049736c, 24 instruction(s), calls FUN_0050e3de, ends with forward jump to 0x0049744c
    fild dword ptr [ebp - local_218]             # 0049736e
    fstp dword ptr [ebp - local_2cc]             # 00497374
    fld dword ptr [ebp - local_210]              # 0049737a
    fsub dword ptr [ebp - local_2cc]             # 00497380
    mov edx, dword ptr [ebp - local_200]         # 00497386
    shl edx, 0xa                                 # 0049738c
    shl edx                                      # 0049738f
    mov eax, dword ptr [ebp - local_204]         # 00497391
    {load} sub eax, edx                          # 00497397
    and eax, 0xfff                               # 00497399
    mov ecx, dword ptr [ebp - local_288]         # 0049739e
    mov edx, dword ptr [ecx + field_200f]        # 004973a4
    fdiv dword ptr [edx + 4*eax]                 # 004973aa
    mov eax, dword ptr [ebp - local_208]         # 004973ad
    and eax, 0xfff                               # 004973b3
    mov ecx, dword ptr [ebp - local_288]         # 004973b8
    mov edx, dword ptr [ecx + field_200f]        # 004973be
    fmul dword ptr [edx + 4*eax]                 # 004973c4
    sub esp, 0x8                                 # 004973c7
    fstp qword ptr [esp]                         # 004973ca
    call FUN_0050e3de                            # 004973cd
    add esp, 0x8                                 # 004973d2
    fstp dword ptr [ebp - local_1fc]             # 004973d5
    jmp.d8 L_0049744c                            # 004973db
L_004973dd:
    # block 0x004973dd: entered by jne at 0x0049736c, 23 instruction(s), calls FUN_0050e3de, falls into the block at 0x0049744c
    fild dword ptr [ebp - local_214]             # 004973dd
    fstp dword ptr [ebp - local_2d0]             # 004973e3
    fld dword ptr [ebp - local_20c]              # 004973e9
    fsub dword ptr [ebp - local_2d0]             # 004973ef
    mov eax, dword ptr [ebp - local_200]         # 004973f5
    shl eax, 0xa                                 # 004973fb
    shl eax                                      # 004973fe
    mov ecx, dword ptr [ebp - local_204]         # 00497400
    {load} sub ecx, eax                          # 00497406
    and ecx, 0xfff                               # 00497408
    mov edx, dword ptr [ebp - local_288]         # 0049740e
    mov eax, dword ptr [edx + field_2013]        # 00497414
    fdiv dword ptr [eax + 4*ecx]                 # 0049741a
    mov ecx, dword ptr [ebp - local_208]         # 0049741d
    and ecx, 0xfff                               # 00497423
    mov edx, dword ptr [ebp - local_288]         # 00497429
    mov eax, dword ptr [edx + field_200f]        # 0049742f
    fmul dword ptr [eax + 4*ecx]                 # 00497435
    sub esp, 0x8                                 # 00497438
    fstp qword ptr [esp]                         # 0049743b
    call FUN_0050e3de                            # 0049743e
    add esp, 0x8                                 # 00497443
    fstp dword ptr [ebp - local_1fc]             # 00497446
L_0049744c:
    # block 0x0049744c: entered by jmp at 0x004973db, 7 instruction(s), falls into the block at 0x00497476
    mov ecx, dword ptr [ebp - local_288]         # 0049744c
    mov edx, dword ptr [ebp - local_1fc]         # 00497452
    mov dword ptr [ecx + field_50b1], edx        # 00497458
    mov eax, dword ptr [ebp - local_288]         # 0049745e
    mov ecx, dword ptr [ebp - local_288]         # 00497464
    mov edx, dword ptr [ecx + field_50b1]        # 0049746a
    mov dword ptr [eax + field_5091], edx        # 00497470
L_00497476:
    # block 0x00497476: entered by jne at 0x004971a3, 12 instruction(s), calls FUN_0050ce04, ends with je to 0x00497504 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00497476
    fld dword ptr [eax + field_5089]             # 0049747c
    call FUN_0050ce04                            # 00497482
    and eax, 0x7f                                # 00497487
    mov dword ptr [ebp - local_f8], eax          # 0049748a
    mov ecx, dword ptr [ebp - local_288]         # 00497490
    mov edx, dword ptr [ebp - local_288]         # 00497496
    fld dword ptr [ecx + field_5095]             # 0049749c
    fcomp dword ptr [edx + field_5091]           # 004974a2
    fnstsw ax                                    # 004974a8
    test ah, 0x1                                 # 004974aa
    je.d8 L_00497504                             # 004974ad
    # block 0x004974af: entered by fall-through of je at 0x004974ad, 8 instruction(s), ends with je to 0x00497504 (forward)
    mov eax, dword ptr [ebp - local_288]         # 004974af
    mov ecx, dword ptr [ebp - local_288]         # 004974b5
    fld dword ptr [eax + field_5091]             # 004974bb
    fsub dword ptr [ecx + field_5095]            # 004974c1
    fcomp qword ptr [0x52db70]                   # 004974c7
    fnstsw ax                                    # 004974cd
    test ah, 0x1                                 # 004974cf
    je.d8 L_00497504                             # 004974d2
    # block 0x004974d4: entered by fall-through of je at 0x004974d2, 2 instruction(s), ends with je to 0x004974e6 (forward)
    cmp dword ptr [ebp - local_f8], 0x0          # 004974d4
    je.d8 L_004974e6                             # 004974db
    # block 0x004974dd: entered by fall-through of je at 0x004974db, 2 instruction(s), ends with jne to 0x00497504 (forward)
    cmp dword ptr [ebp - local_f8], 0x7f         # 004974dd
    jne.d8 L_00497504                            # 004974e4
L_004974e6:
    # block 0x004974e6: entered by je at 0x004974db; fall-through of jne at 0x004974e4, 5 instruction(s), falls into the block at 0x00497504
    mov edx, dword ptr [ebp - local_288]         # 004974e6
    fld dword ptr [edx + field_5091]             # 004974ec
    fadd dword ptr [0x52cbf4]                    # 004974f2
    mov eax, dword ptr [ebp - local_288]         # 004974f8
    fstp dword ptr [eax + field_5095]            # 004974fe
L_00497504:
    # block 0x00497504: entered by jle at 0x00496e9e; je at 0x00496eb8; je at 0x004974ad; je at 0x004974d2; jne at 0x004974e4, 3 instruction(s), ends with jle to 0x00497b76 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00497504
    cmp dword ptr [ecx + field_50e1], 0x0        # 0049750a
    jle.d32 L_00497b76                           # 00497511
    # block 0x00497517: entered by fall-through of jle at 0x00497511, 5 instruction(s), ends with je to 0x00497b76 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00497517
    mov eax, dword ptr [edx + field_50e1]        # 0049751d
    and eax, 0x2000000                           # 00497523
    test eax, eax                                # 00497528
    je.d32 L_00497b76                            # 0049752a
    # block 0x00497530: entered by fall-through of je at 0x0049752a, 6 instruction(s), ends with jne to 0x00497573 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00497530
    fld dword ptr [ecx + field_5099]             # 00497536
    fcomp dword ptr [0x52db78]                   # 0049753c
    fnstsw ax                                    # 00497542
    test ah, 0x41                                # 00497544
    jne.d8 L_00497573                            # 00497547
    # block 0x00497549: entered by fall-through of jne at 0x00497547, 8 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x00497592
    mov edx, dword ptr [ebp - local_288]         # 00497549
    fld dword ptr [edx + field_5081]             # 0049754f
    call FUN_0050ce04                            # 00497555
    and eax, 0xff80                              # 0049755a
    mov ecx, dword ptr [ebp - local_288]         # 0049755f
    add eax, dword ptr [ecx + field_2095]        # 00497565
    mov dword ptr [ebp - local_224], eax         # 0049756b
    jmp.d8 L_00497592                            # 00497571
L_00497573:
    # block 0x00497573: entered by jne at 0x00497547, 6 instruction(s), calls FUN_0050ce04, falls into the block at 0x00497592
    mov edx, dword ptr [ebp - local_288]         # 00497573
    fld dword ptr [edx + field_5081]             # 00497579
    call FUN_0050ce04                            # 0049757f
    and eax, 0xff80                              # 00497584
    sub eax, 0x1                                 # 00497589
    mov dword ptr [ebp - local_224], eax         # 0049758c
L_00497592:
    # block 0x00497592: entered by jmp at 0x00497571, 62 instruction(s), ends with je to 0x004976f5 (forward)
    fild dword ptr [ebp - local_224]             # 00497592
    fstp dword ptr [ebp - local_22c]             # 00497598
    fild dword ptr [ebp - local_224]             # 0049759e
    fstp dword ptr [ebp - local_2d4]             # 004975a4
    mov eax, dword ptr [ebp - local_288]         # 004975aa
    fld dword ptr [ebp - local_2d4]              # 004975b0
    fsub dword ptr [eax + field_5081]            # 004975b6
    mov ecx, dword ptr [ebp - local_288]         # 004975bc
    fmul dword ptr [ecx + field_50a1]            # 004975c2
    mov edx, dword ptr [ebp - local_288]         # 004975c8
    fadd dword ptr [edx + field_5085]            # 004975ce
    fstp dword ptr [ebp - local_228]             # 004975d4
    mov eax, dword ptr [ebp - local_288]         # 004975da
    fld dword ptr [eax + field_5081]             # 004975e0
    mov ecx, dword ptr [ebp - local_288]         # 004975e6
    fld dword ptr [ebp - local_22c]              # 004975ec
    fsub dword ptr [ecx + field_5081]            # 004975f2
    fdiv qword ptr [0x52c678]                    # 004975f8
    faddp st(1), st                              # 004975fe
    fstp dword ptr [ebp - local_220]             # 00497600
    mov edx, dword ptr [ebp - local_288]         # 00497606
    fld dword ptr [edx + field_5085]             # 0049760c
    mov eax, dword ptr [ebp - local_288]         # 00497612
    fld dword ptr [ebp - local_228]              # 00497618
    fsub dword ptr [eax + field_5085]            # 0049761e
    fdiv qword ptr [0x52c678]                    # 00497624
    faddp st(1), st                              # 0049762a
    fstp dword ptr [ebp - local_21c]             # 0049762c
    mov ecx, dword ptr [ebp - local_288]         # 00497632
    mov edx, dword ptr [ebp - local_220]         # 00497638
    mov dword ptr [ecx + field_5081], edx        # 0049763e
    mov eax, dword ptr [ebp - local_288]         # 00497644
    mov ecx, dword ptr [ebp - local_21c]         # 0049764a
    mov dword ptr [eax + field_5085], ecx        # 00497650
    mov edx, dword ptr [ebp - local_288]         # 00497656
    mov eax, dword ptr [edx + field_1efb]        # 0049765c
    mov dword ptr [ebp - local_24c], eax         # 00497662
    mov ecx, dword ptr [ebp - local_288]         # 00497668
    mov edx, dword ptr [ecx + field_1ef7]        # 0049766e
    mov dword ptr [ebp - local_248], edx         # 00497674
    mov eax, dword ptr [ebp - local_288]         # 0049767a
    mov ecx, dword ptr [eax + field_5085]        # 00497680
    mov dword ptr [ebp - local_244], ecx         # 00497686
    mov edx, dword ptr [ebp - local_288]         # 0049768c
    mov eax, dword ptr [edx + field_5081]        # 00497692
    mov dword ptr [ebp - local_240], eax         # 00497698
    mov ecx, dword ptr [ebp - local_288]         # 0049769e
    mov edx, dword ptr [ecx + field_50c1]        # 004976a4
    mov dword ptr [ebp - local_23c], edx         # 004976aa
    mov eax, dword ptr [ebp - local_288]         # 004976b0
    mov ecx, dword ptr [eax + field_50cd]        # 004976b6
    mov dword ptr [ebp - local_238], ecx         # 004976bc
    mov eax, dword ptr [ebp - local_238]         # 004976c2
    cdq                                          # 004976c8
    and edx, 0x1ff                               # 004976c9
    {load} add eax, edx                          # 004976cf
    sar eax, 0x9                                 # 004976d1
    mov dword ptr [ebp - local_234], eax         # 004976d4
    mov edx, dword ptr [ebp - local_234]         # 004976da
    and edx, 0x3                                 # 004976e0
    test edx, edx                                # 004976e3
    je.d8 L_004976f5                             # 004976e5
    # block 0x004976e7: entered by fall-through of je at 0x004976e5, 4 instruction(s), ends with jne to 0x00497766 (forward)
    mov eax, dword ptr [ebp - local_234]         # 004976e7
    and eax, 0x3                                 # 004976ed
    cmp eax, 0x3                                 # 004976f0
    jne.d8 L_00497766                            # 004976f3
L_004976f5:
    # block 0x004976f5: entered by je at 0x004976e5; fall-through of jne at 0x004976f3, 24 instruction(s), calls FUN_0050e3de, ends with forward jump to 0x004977d3
    fild dword ptr [ebp - local_24c]             # 004976f5
    fstp dword ptr [ebp - local_2d8]             # 004976fb
    fld dword ptr [ebp - local_244]              # 00497701
    fsub dword ptr [ebp - local_2d8]             # 00497707
    mov ecx, dword ptr [ebp - local_234]         # 0049770d
    shl ecx, 0xa                                 # 00497713
    shl ecx                                      # 00497716
    mov edx, dword ptr [ebp - local_238]         # 00497718
    {load} sub edx, ecx                          # 0049771e
    and edx, 0xfff                               # 00497720
    mov eax, dword ptr [ebp - local_288]         # 00497726
    mov ecx, dword ptr [eax + field_200f]        # 0049772c
    fdiv dword ptr [ecx + 4*edx]                 # 00497732
    mov edx, dword ptr [ebp - local_23c]         # 00497735
    and edx, 0xfff                               # 0049773b
    mov eax, dword ptr [ebp - local_288]         # 00497741
    mov ecx, dword ptr [eax + field_200f]        # 00497747
    fmul dword ptr [ecx + 4*edx]                 # 0049774d
    sub esp, 0x8                                 # 00497750
    fstp qword ptr [esp]                         # 00497753
    call FUN_0050e3de                            # 00497756
    add esp, 0x8                                 # 0049775b
    fstp dword ptr [ebp - local_230]             # 0049775e
    jmp.d8 L_004977d3                            # 00497764
L_00497766:
    # block 0x00497766: entered by jne at 0x004976f3, 23 instruction(s), calls FUN_0050e3de, falls into the block at 0x004977d3
    fild dword ptr [ebp - local_248]             # 00497766
    fstp dword ptr [ebp - local_2dc]             # 0049776c
    fld dword ptr [ebp - local_240]              # 00497772
    fsub dword ptr [ebp - local_2dc]             # 00497778
    mov edx, dword ptr [ebp - local_234]         # 0049777e
    shl edx, 0xa                                 # 00497784
    shl edx                                      # 00497787
    mov eax, dword ptr [ebp - local_238]         # 00497789
    {load} sub eax, edx                          # 0049778f
    and eax, 0xfff                               # 00497791
    mov ecx, dword ptr [ebp - local_288]         # 00497796
    mov edx, dword ptr [ecx + field_2013]        # 0049779c
    fdiv dword ptr [edx + 4*eax]                 # 004977a2
    mov eax, dword ptr [ebp - local_23c]         # 004977a5
    and eax, 0xfff                               # 004977ab
    mov ecx, dword ptr [ebp - local_288]         # 004977b0
    mov edx, dword ptr [ecx + field_200f]        # 004977b6
    fmul dword ptr [edx + 4*eax]                 # 004977bc
    sub esp, 0x8                                 # 004977bf
    fstp qword ptr [esp]                         # 004977c2
    call FUN_0050e3de                            # 004977c5
    add esp, 0x8                                 # 004977ca
    fstp dword ptr [ebp - local_230]             # 004977cd
L_004977d3:
    # block 0x004977d3: entered by jmp at 0x00497764, 12 instruction(s), ends with jne to 0x00497ae8 (forward)
    mov eax, dword ptr [ebp - local_288]         # 004977d3
    mov ecx, dword ptr [ebp - local_230]         # 004977d9
    mov dword ptr [eax + field_50b1], ecx        # 004977df
    mov edx, dword ptr [ebp - local_288]         # 004977e5
    mov eax, dword ptr [ebp - local_288]         # 004977eb
    mov ecx, dword ptr [eax + field_50b1]        # 004977f1
    mov dword ptr [edx + field_5091], ecx        # 004977f7
    mov edx, dword ptr [ebp - local_288]         # 004977fd
    mov eax, dword ptr [ebp - local_288]         # 00497803
    mov ecx, dword ptr [edx + field_50e5]        # 00497809
    cmp ecx, dword ptr [eax + field_50e1]        # 0049780f
    jne.d32 L_00497ae8                           # 00497815
    # block 0x0049781b: entered by fall-through of jne at 0x00497815, 6 instruction(s), ends with jne to 0x0049785e (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049781b
    fld dword ptr [edx + field_509d]             # 00497821
    fcomp dword ptr [0x52db78]                   # 00497827
    fnstsw ax                                    # 0049782d
    test ah, 0x41                                # 0049782f
    jne.d8 L_0049785e                            # 00497832
    # block 0x00497834: entered by fall-through of jne at 0x00497832, 8 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x0049787d
    mov eax, dword ptr [ebp - local_288]         # 00497834
    fld dword ptr [eax + field_508d]             # 0049783a
    call FUN_0050ce04                            # 00497840
    and eax, 0xff80                              # 00497845
    mov ecx, dword ptr [ebp - local_288]         # 0049784a
    add eax, dword ptr [ecx + field_2095]        # 00497850
    mov dword ptr [ebp - local_25c], eax         # 00497856
    jmp.d8 L_0049787d                            # 0049785c
L_0049785e:
    # block 0x0049785e: entered by jne at 0x00497832, 6 instruction(s), calls FUN_0050ce04, falls into the block at 0x0049787d
    mov edx, dword ptr [ebp - local_288]         # 0049785e
    fld dword ptr [edx + field_508d]             # 00497864
    call FUN_0050ce04                            # 0049786a
    and eax, 0xff80                              # 0049786f
    sub eax, 0x1                                 # 00497874
    mov dword ptr [ebp - local_25c], eax         # 00497877
L_0049787d:
    # block 0x0049787d: entered by jmp at 0x0049785c, 62 instruction(s), ends with je to 0x004979e0 (forward)
    fild dword ptr [ebp - local_25c]             # 0049787d
    fstp dword ptr [ebp - local_2e0]             # 00497883
    mov eax, dword ptr [ebp - local_288]         # 00497889
    fld dword ptr [ebp - local_2e0]              # 0049788f
    fsub dword ptr [eax + field_508d]            # 00497895
    mov ecx, dword ptr [ebp - local_288]         # 0049789b
    fdiv dword ptr [ecx + field_50a1]            # 004978a1
    mov edx, dword ptr [ebp - local_288]         # 004978a7
    fadd dword ptr [edx + field_5089]            # 004978ad
    fstp dword ptr [ebp - local_258]             # 004978b3
    fild dword ptr [ebp - local_25c]             # 004978b9
    fstp dword ptr [ebp - local_260]             # 004978bf
    mov eax, dword ptr [ebp - local_288]         # 004978c5
    fld dword ptr [eax + field_5089]             # 004978cb
    mov ecx, dword ptr [ebp - local_288]         # 004978d1
    fld dword ptr [ebp - local_258]              # 004978d7
    fsub dword ptr [ecx + field_5089]            # 004978dd
    fdiv qword ptr [0x52c678]                    # 004978e3
    faddp st(1), st                              # 004978e9
    fstp dword ptr [ebp - local_250]             # 004978eb
    mov edx, dword ptr [ebp - local_288]         # 004978f1
    fld dword ptr [edx + field_508d]             # 004978f7
    mov eax, dword ptr [ebp - local_288]         # 004978fd
    fld dword ptr [ebp - local_260]              # 00497903
    fsub dword ptr [eax + field_508d]            # 00497909
    fdiv qword ptr [0x52c678]                    # 0049790f
    faddp st(1), st                              # 00497915
    fstp dword ptr [ebp - local_254]             # 00497917
    mov ecx, dword ptr [ebp - local_288]         # 0049791d
    mov edx, dword ptr [ebp - local_250]         # 00497923
    mov dword ptr [ecx + field_5089], edx        # 00497929
    mov eax, dword ptr [ebp - local_288]         # 0049792f
    mov ecx, dword ptr [ebp - local_254]         # 00497935
    mov dword ptr [eax + field_508d], ecx        # 0049793b
    mov edx, dword ptr [ebp - local_288]         # 00497941
    mov eax, dword ptr [edx + field_1efb]        # 00497947
    mov dword ptr [ebp - local_280], eax         # 0049794d
    mov ecx, dword ptr [ebp - local_288]         # 00497953
    mov edx, dword ptr [ecx + field_1ef7]        # 00497959
    mov dword ptr [ebp - local_27c], edx         # 0049795f
    mov eax, dword ptr [ebp - local_288]         # 00497965
    mov ecx, dword ptr [eax + field_508d]        # 0049796b
    mov dword ptr [ebp - local_278], ecx         # 00497971
    mov edx, dword ptr [ebp - local_288]         # 00497977
    mov eax, dword ptr [edx + field_5089]        # 0049797d
    mov dword ptr [ebp - local_274], eax         # 00497983
    mov ecx, dword ptr [ebp - local_288]         # 00497989
    mov edx, dword ptr [ecx + field_50c1]        # 0049798f
    mov dword ptr [ebp - local_270], edx         # 00497995
    mov eax, dword ptr [ebp - local_288]         # 0049799b
    mov ecx, dword ptr [eax + field_50cd]        # 004979a1
    mov dword ptr [ebp - local_26c], ecx         # 004979a7
    mov eax, dword ptr [ebp - local_26c]         # 004979ad
    cdq                                          # 004979b3
    and edx, 0x1ff                               # 004979b4
    {load} add eax, edx                          # 004979ba
    sar eax, 0x9                                 # 004979bc
    mov dword ptr [ebp - local_268], eax         # 004979bf
    mov edx, dword ptr [ebp - local_268]         # 004979c5
    and edx, 0x3                                 # 004979cb
    test edx, edx                                # 004979ce
    je.d8 L_004979e0                             # 004979d0
    # block 0x004979d2: entered by fall-through of je at 0x004979d0, 4 instruction(s), ends with jne to 0x00497a51 (forward)
    mov eax, dword ptr [ebp - local_268]         # 004979d2
    and eax, 0x3                                 # 004979d8
    cmp eax, 0x3                                 # 004979db
    jne.d8 L_00497a51                            # 004979de
L_004979e0:
    # block 0x004979e0: entered by je at 0x004979d0; fall-through of jne at 0x004979de, 24 instruction(s), calls FUN_0050e3de, ends with forward jump to 0x00497abe
    fild dword ptr [ebp - local_280]             # 004979e0
    fstp dword ptr [ebp - local_2e4]             # 004979e6
    fld dword ptr [ebp - local_278]              # 004979ec
    fsub dword ptr [ebp - local_2e4]             # 004979f2
    mov ecx, dword ptr [ebp - local_268]         # 004979f8
    shl ecx, 0xa                                 # 004979fe
    shl ecx                                      # 00497a01
    mov edx, dword ptr [ebp - local_26c]         # 00497a03
    {load} sub edx, ecx                          # 00497a09
    and edx, 0xfff                               # 00497a0b
    mov eax, dword ptr [ebp - local_288]         # 00497a11
    mov ecx, dword ptr [eax + field_200f]        # 00497a17
    fdiv dword ptr [ecx + 4*edx]                 # 00497a1d
    mov edx, dword ptr [ebp - local_270]         # 00497a20
    and edx, 0xfff                               # 00497a26
    mov eax, dword ptr [ebp - local_288]         # 00497a2c
    mov ecx, dword ptr [eax + field_200f]        # 00497a32
    fmul dword ptr [ecx + 4*edx]                 # 00497a38
    sub esp, 0x8                                 # 00497a3b
    fstp qword ptr [esp]                         # 00497a3e
    call FUN_0050e3de                            # 00497a41
    add esp, 0x8                                 # 00497a46
    fstp dword ptr [ebp - local_264]             # 00497a49
    jmp.d8 L_00497abe                            # 00497a4f
L_00497a51:
    # block 0x00497a51: entered by jne at 0x004979de, 23 instruction(s), calls FUN_0050e3de, falls into the block at 0x00497abe
    fild dword ptr [ebp - local_27c]             # 00497a51
    fstp dword ptr [ebp - local_2e8]             # 00497a57
    fld dword ptr [ebp - local_274]              # 00497a5d
    fsub dword ptr [ebp - local_2e8]             # 00497a63
    mov edx, dword ptr [ebp - local_268]         # 00497a69
    shl edx, 0xa                                 # 00497a6f
    shl edx                                      # 00497a72
    mov eax, dword ptr [ebp - local_26c]         # 00497a74
    {load} sub eax, edx                          # 00497a7a
    and eax, 0xfff                               # 00497a7c
    mov ecx, dword ptr [ebp - local_288]         # 00497a81
    mov edx, dword ptr [ecx + field_2013]        # 00497a87
    fdiv dword ptr [edx + 4*eax]                 # 00497a8d
    mov eax, dword ptr [ebp - local_270]         # 00497a90
    and eax, 0xfff                               # 00497a96
    mov ecx, dword ptr [ebp - local_288]         # 00497a9b
    mov edx, dword ptr [ecx + field_200f]        # 00497aa1
    fmul dword ptr [edx + 4*eax]                 # 00497aa7
    sub esp, 0x8                                 # 00497aaa
    fstp qword ptr [esp]                         # 00497aad
    call FUN_0050e3de                            # 00497ab0
    add esp, 0x8                                 # 00497ab5
    fstp dword ptr [ebp - local_264]             # 00497ab8
L_00497abe:
    # block 0x00497abe: entered by jmp at 0x00497a4f, 7 instruction(s), falls into the block at 0x00497ae8
    mov eax, dword ptr [ebp - local_288]         # 00497abe
    mov ecx, dword ptr [ebp - local_264]         # 00497ac4
    mov dword ptr [eax + field_50b5], ecx        # 00497aca
    mov edx, dword ptr [ebp - local_288]         # 00497ad0
    mov eax, dword ptr [ebp - local_288]         # 00497ad6
    mov ecx, dword ptr [eax + field_50b5]        # 00497adc
    mov dword ptr [edx + field_5095], ecx        # 00497ae2
L_00497ae8:
    # block 0x00497ae8: entered by jne at 0x00497815, 12 instruction(s), calls FUN_0050ce04, ends with je to 0x00497b76 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00497ae8
    fld dword ptr [edx + field_5085]             # 00497aee
    call FUN_0050ce04                            # 00497af4
    and eax, 0x7f                                # 00497af9
    mov dword ptr [ebp - local_f8], eax          # 00497afc
    mov eax, dword ptr [ebp - local_288]         # 00497b02
    mov ecx, dword ptr [ebp - local_288]         # 00497b08
    fld dword ptr [eax + field_5091]             # 00497b0e
    fcomp dword ptr [ecx + field_5095]           # 00497b14
    fnstsw ax                                    # 00497b1a
    test ah, 0x1                                 # 00497b1c
    je.d8 L_00497b76                             # 00497b1f
    # block 0x00497b21: entered by fall-through of je at 0x00497b1f, 8 instruction(s), ends with je to 0x00497b76 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00497b21
    mov eax, dword ptr [ebp - local_288]         # 00497b27
    fld dword ptr [edx + field_5095]             # 00497b2d
    fsub dword ptr [eax + field_5091]            # 00497b33
    fcomp qword ptr [0x52db70]                   # 00497b39
    fnstsw ax                                    # 00497b3f
    test ah, 0x1                                 # 00497b41
    je.d8 L_00497b76                             # 00497b44
    # block 0x00497b46: entered by fall-through of je at 0x00497b44, 2 instruction(s), ends with je to 0x00497b58 (forward)
    cmp dword ptr [ebp - local_f8], 0x0          # 00497b46
    je.d8 L_00497b58                             # 00497b4d
    # block 0x00497b4f: entered by fall-through of je at 0x00497b4d, 2 instruction(s), ends with jne to 0x00497b76 (forward)
    cmp dword ptr [ebp - local_f8], 0x7f         # 00497b4f
    jne.d8 L_00497b76                            # 00497b56
L_00497b58:
    # block 0x00497b58: entered by je at 0x00497b4d; fall-through of jne at 0x00497b56, 5 instruction(s), falls into the block at 0x00497b76
    mov ecx, dword ptr [ebp - local_288]         # 00497b58
    fld dword ptr [ecx + field_5095]             # 00497b5e
    fadd dword ptr [0x52cbf4]                    # 00497b64
    mov edx, dword ptr [ebp - local_288]         # 00497b6a
    fstp dword ptr [edx + field_5091]            # 00497b70
L_00497b76:
    # block 0x00497b76: entered by jle at 0x00497511; je at 0x0049752a; je at 0x00497b1f; je at 0x00497b44; jne at 0x00497b56, 7 instruction(s), ends with je to 0x00497ee7 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00497b76
    mov ecx, dword ptr [ebp - local_288]         # 00497b7c
    fld dword ptr [eax + field_5091]             # 00497b82
    fcomp dword ptr [ecx + field_5095]           # 00497b88
    fnstsw ax                                    # 00497b8e
    test ah, 0x1                                 # 00497b90
    je.d32 L_00497ee7                            # 00497b93
    # block 0x00497b99: entered by fall-through of je at 0x00497b93, 11 instruction(s), ends with jle to 0x00497ee2 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00497b99
    mov eax, dword ptr [ebp - local_288]         # 00497b9f
    mov ecx, dword ptr [eax + field_5081]        # 00497ba5
    mov dword ptr [edx + field_50a5], ecx        # 00497bab
    mov edx, dword ptr [ebp - local_288]         # 00497bb1
    mov eax, dword ptr [ebp - local_288]         # 00497bb7
    mov ecx, dword ptr [eax + field_5085]        # 00497bbd
    mov dword ptr [edx + field_50a9], ecx        # 00497bc3
    mov edx, dword ptr [ebp - local_288]         # 00497bc9
    cmp dword ptr [edx + field_50e1], 0x0        # 00497bcf
    jle.d32 L_00497ee2                           # 00497bd6
    # block 0x00497bdc: entered by fall-through of jle at 0x00497bd6, 5 instruction(s), ends with jne to 0x00497ee2 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00497bdc
    mov ecx, dword ptr [eax + field_50e1]        # 00497be2
    and ecx, 0x4000000                           # 00497be8
    test ecx, ecx                                # 00497bee
    jne.d32 L_00497ee2                           # 00497bf0
    # block 0x00497bf6: entered by fall-through of jne at 0x00497bf0, 86 instruction(s), ends with je to 0x00497dc3 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00497bf6
    mov eax, dword ptr [edx + field_50e1]        # 00497bfc
    and eax, 0xff                                # 00497c02
    mov ecx, dword ptr [ebp - local_288]         # 00497c07
    mov byte ptr [ecx + field_50ed], al          # 00497c0d
    mov edx, dword ptr [ebp - local_288]         # 00497c13
    mov eax, dword ptr [edx + field_50e1]        # 00497c19
    sar eax, 0x8                                 # 00497c1f
    and eax, 0xff                                # 00497c22
    mov ecx, dword ptr [ebp - local_288]         # 00497c27
    mov byte ptr [ecx + field_50ee], al          # 00497c2d
    mov edx, dword ptr [ebp - local_288]         # 00497c33
    mov eax, dword ptr [edx + field_50e1]        # 00497c39
    sar eax, 0x10                                # 00497c3f
    and eax, 0xff                                # 00497c42
    mov ecx, dword ptr [ebp - local_288]         # 00497c47
    mov byte ptr [ecx + field_50ef], al          # 00497c4d
    mov edx, dword ptr [ebp - local_288]         # 00497c53
    {load} xor eax, eax                          # 00497c59
    mov al, byte ptr [edx + field_50ed]          # 00497c5b
    and eax, 0x80                                # 00497c61
    mov ecx, dword ptr [ebp - local_288]         # 00497c66
    mov byte ptr [ecx + field_50f0], al          # 00497c6c
    mov edx, dword ptr [ebp - local_288]         # 00497c72
    {load} xor eax, eax                          # 00497c78
    mov al, byte ptr [edx + field_50ee]          # 00497c7a
    and eax, 0x80                                # 00497c80
    mov ecx, dword ptr [ebp - local_288]         # 00497c85
    mov byte ptr [ecx + field_50f1], al          # 00497c8b
    mov edx, dword ptr [ebp - local_288]         # 00497c91
    {load} xor eax, eax                          # 00497c97
    mov al, byte ptr [edx + field_50ef]          # 00497c99
    and eax, 0x80                                # 00497c9f
    mov ecx, dword ptr [ebp - local_288]         # 00497ca4
    mov byte ptr [ecx + field_50f2], al          # 00497caa
    mov edx, dword ptr [ebp - local_288]         # 00497cb0
    mov al, byte ptr [edx + field_50ed]          # 00497cb6
    and al, 0x7f                                 # 00497cbc
    mov ecx, dword ptr [ebp - local_288]         # 00497cbe
    mov byte ptr [ecx + field_50ed], al          # 00497cc4
    mov edx, dword ptr [ebp - local_288]         # 00497cca
    mov al, byte ptr [edx + field_50ee]          # 00497cd0
    and al, 0x7f                                 # 00497cd6
    mov ecx, dword ptr [ebp - local_288]         # 00497cd8
    mov byte ptr [ecx + field_50ee], al          # 00497cde
    mov edx, dword ptr [ebp - local_288]         # 00497ce4
    mov al, byte ptr [edx + field_50ef]          # 00497cea
    and al, 0x7f                                 # 00497cf0
    mov ecx, dword ptr [ebp - local_288]         # 00497cf2
    mov byte ptr [ecx + field_50ef], al          # 00497cf8
    mov edx, dword ptr [ebp - local_288]         # 00497cfe
    mov eax, dword ptr [ebp - local_288]         # 00497d04
    mov ecx, dword ptr [eax + field_50e1]        # 00497d0a
    mov dword ptr [edx + field_50e9], ecx        # 00497d10
    mov edx, dword ptr [ebp - local_288]         # 00497d16
    mov eax, dword ptr [edx + field_50d1]        # 00497d1c
    imul eax, eax, 0xa6                          # 00497d22
    mov ecx, dword ptr [ebp - local_288]         # 00497d28
    mov edx, dword ptr [ecx + field_1f57]        # 00497d2e
    lea eax, [edx + 2*eax]                       # 00497d34
    mov ecx, dword ptr [ebp - local_288]         # 00497d37
    mov edx, dword ptr [ecx + field_50d5]        # 00497d3d
    {load} xor ecx, ecx                          # 00497d43
    mov cx, word ptr [eax + 2*edx]               # 00497d45
    mov dword ptr [ebp - local_fc], ecx          # 00497d49
    mov edx, dword ptr [ebp - local_fc]          # 00497d4f
    and edx, 0xf                                 # 00497d55
    mov dword ptr [ebp - local_dc], edx          # 00497d58
    mov eax, dword ptr [ebp - local_fc]          # 00497d5e
    sar eax, 0x4                                 # 00497d64
    and eax, 0xf                                 # 00497d67
    mov dword ptr [ebp - local_bc], eax          # 00497d6a
    mov ecx, dword ptr [ebp - local_fc]          # 00497d70
    sar ecx, 0x8                                 # 00497d76
    and ecx, 0xf                                 # 00497d79
    mov dword ptr [ebp - local_104], ecx         # 00497d7c
    mov edx, dword ptr [ebp - local_288]         # 00497d82
    mov eax, dword ptr [ebp - local_288]         # 00497d88
    mov ecx, dword ptr [eax + field_5091]        # 00497d8e
    mov dword ptr [edx + field_50ad], ecx        # 00497d94
    mov edx, dword ptr [ebp - local_288]         # 00497d9a
    fld dword ptr [edx + field_50ad]             # 00497da0
    fcomp qword ptr [0x52c598]                   # 00497da6
    fnstsw ax                                    # 00497dac
    test ah, 0x1                                 # 00497dae
    je.d8 L_00497dc3                             # 00497db1
    # block 0x00497db3: entered by fall-through of je at 0x00497db1, 2 instruction(s), falls into the block at 0x00497dc3
    mov eax, dword ptr [ebp - local_288]         # 00497db3
    mov dword ptr [eax + field_50ad], 0x3f800000 # 00497db9
L_00497dc3:
    # block 0x00497dc3: entered by je at 0x00497db1, 15 instruction(s), calls FUN_0050ce04, ends with jle to 0x00497e45 (forward)
    mov ecx, dword ptr [ebp - local_78]          # 00497dc3
    mov edx, dword ptr [ebp - local_288]         # 00497dc6
    mov eax, dword ptr [ebp - local_288]         # 00497dcc
    mov eax, dword ptr [eax + field_50ad]        # 00497dd2
    mov dword ptr [edx + 4*ecx + field_4821], eax # 00497dd8
    mov ecx, dword ptr [ebp - local_288]         # 00497ddf
    fld dword ptr [ecx + field_50a9]             # 00497de5
    call FUN_0050ce04                            # 00497deb
    and eax, 0x7f                                # 00497df0
    mov dword ptr [ebp - local_11c], eax         # 00497df3
    mov edx, dword ptr [ebp - local_288]         # 00497df9
    mov eax, dword ptr [ebp - local_288]         # 00497dff
    mov ecx, dword ptr [edx + field_50cd]        # 00497e05
    cmp ecx, dword ptr [eax + field_1f0f]        # 00497e0b
    jle.d8 L_00497e45                            # 00497e11
    # block 0x00497e13: entered by fall-through of jle at 0x00497e11, 5 instruction(s), ends with jge to 0x00497e45 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00497e13
    mov eax, dword ptr [ebp - local_288]         # 00497e19
    mov ecx, dword ptr [edx + field_50cd]        # 00497e1f
    cmp ecx, dword ptr [eax + field_1f1f]        # 00497e25
    jge.d8 L_00497e45                            # 00497e2b
    # block 0x00497e2d: entered by fall-through of jge at 0x00497e2b, 4 instruction(s), falls into the block at 0x00497e45
    mov edx, dword ptr [ebp - local_288]         # 00497e2d
    mov eax, dword ptr [edx + field_45bd]        # 00497e33
    sub eax, dword ptr [ebp - local_11c]         # 00497e39
    mov dword ptr [ebp - local_11c], eax         # 00497e3f
L_00497e45:
    # block 0x00497e45: entered by jle at 0x00497e11; jge at 0x00497e2b, 5 instruction(s), ends with je to 0x00497ea4 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00497e45
    mov edx, dword ptr [ecx + field_50e1]        # 00497e4b
    and edx, 0x1000000                           # 00497e51
    test edx, edx                                # 00497e57
    je.d8 L_00497ea4                             # 00497e59
    # block 0x00497e5b: entered by fall-through of je at 0x00497e59, 5 instruction(s), ends with jne to 0x00497ea4 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00497e5b
    mov ecx, dword ptr [eax + field_50e1]        # 00497e61
    and ecx, 0x10000000                          # 00497e67
    test ecx, ecx                                # 00497e6d
    jne.d8 L_00497ea4                            # 00497e6f
    # block 0x00497e71: entered by fall-through of jne at 0x00497e6f, 5 instruction(s), ends with jne to 0x00497ea4 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00497e71
    mov eax, dword ptr [edx + field_50e1]        # 00497e77
    and eax, 0x20000000                          # 00497e7d
    test eax, eax                                # 00497e82
    jne.d8 L_00497ea4                            # 00497e84
    # block 0x00497e86: entered by fall-through of jne at 0x00497e84, 5 instruction(s), ends with forward jump to 0x00497edd
    mov dword ptr [ebp - local_15c], 0x1         # 00497e86
    mov ecx, dword ptr [ebp - local_288]         # 00497e90
    mov edx, dword ptr [ecx + field_45ad]        # 00497e96
    mov dword ptr [ebp - local_98], edx          # 00497e9c
    jmp.d8 L_00497edd                            # 00497ea2
L_00497ea4:
    # block 0x00497ea4: entered by je at 0x00497e59; jne at 0x00497e6f; jne at 0x00497e84, 11 instruction(s), falls into the block at 0x00497edd
    mov eax, dword ptr [ebp - local_288]         # 00497ea4
    mov ecx, dword ptr [eax + field_50d1]        # 00497eaa
    imul ecx, ecx, 0xa6                          # 00497eb0
    mov edx, dword ptr [ebp - local_288]         # 00497eb6
    mov eax, dword ptr [edx + field_1f67]        # 00497ebc
    lea ecx, [eax + 2*ecx]                       # 00497ec2
    mov edx, dword ptr [ebp - local_288]         # 00497ec5
    mov eax, dword ptr [edx + field_50d5]        # 00497ecb
    {load} xor edx, edx                          # 00497ed1
    mov dx, word ptr [ecx + 2*eax]               # 00497ed3
    mov dword ptr [ebp - local_98], edx          # 00497ed7
L_00497edd:
    # block 0x00497edd: entered by jmp at 0x00497ea2, 1 instruction(s), ends with forward jump to 0x0049823b
    jmp.d32 L_0049823b                           # 00497edd
L_00497ee2:
    # block 0x00497ee2: entered by jle at 0x00497bd6; jne at 0x00497bf0, 1 instruction(s), ends with forward jump to 0x00498236
    jmp.d32 L_00498236                           # 00497ee2
L_00497ee7:
    # block 0x00497ee7: entered by je at 0x00497b93, 11 instruction(s), ends with jle to 0x00498236 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00497ee7
    mov ecx, dword ptr [ebp - local_288]         # 00497eed
    mov edx, dword ptr [ecx + field_5089]        # 00497ef3
    mov dword ptr [eax + field_50a5], edx        # 00497ef9
    mov eax, dword ptr [ebp - local_288]         # 00497eff
    mov ecx, dword ptr [ebp - local_288]         # 00497f05
    mov edx, dword ptr [ecx + field_508d]        # 00497f0b
    mov dword ptr [eax + field_50a9], edx        # 00497f11
    mov eax, dword ptr [ebp - local_288]         # 00497f17
    cmp dword ptr [eax + field_50e5], 0x0        # 00497f1d
    jle.d32 L_00498236                           # 00497f24
    # block 0x00497f2a: entered by fall-through of jle at 0x00497f24, 5 instruction(s), ends with jne to 0x00498236 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00497f2a
    mov edx, dword ptr [ecx + field_50e5]        # 00497f30
    and edx, 0x2000000                           # 00497f36
    test edx, edx                                # 00497f3c
    jne.d32 L_00498236                           # 00497f3e
    # block 0x00497f44: entered by fall-through of jne at 0x00497f3e, 86 instruction(s), ends with je to 0x0049811a (forward)
    mov eax, dword ptr [ebp - local_288]         # 00497f44
    mov ecx, dword ptr [eax + field_50e5]        # 00497f4a
    and ecx, 0xff                                # 00497f50
    mov edx, dword ptr [ebp - local_288]         # 00497f56
    mov byte ptr [edx + field_50ed], cl          # 00497f5c
    mov eax, dword ptr [ebp - local_288]         # 00497f62
    mov ecx, dword ptr [eax + field_50e5]        # 00497f68
    sar ecx, 0x8                                 # 00497f6e
    and ecx, 0xff                                # 00497f71
    mov edx, dword ptr [ebp - local_288]         # 00497f77
    mov byte ptr [edx + field_50ee], cl          # 00497f7d
    mov eax, dword ptr [ebp - local_288]         # 00497f83
    mov ecx, dword ptr [eax + field_50e5]        # 00497f89
    sar ecx, 0x10                                # 00497f8f
    and ecx, 0xff                                # 00497f92
    mov edx, dword ptr [ebp - local_288]         # 00497f98
    mov byte ptr [edx + field_50ef], cl          # 00497f9e
    mov eax, dword ptr [ebp - local_288]         # 00497fa4
    {load} xor ecx, ecx                          # 00497faa
    mov cl, byte ptr [eax + field_50ed]          # 00497fac
    and ecx, 0x80                                # 00497fb2
    mov edx, dword ptr [ebp - local_288]         # 00497fb8
    mov byte ptr [edx + field_50f0], cl          # 00497fbe
    mov eax, dword ptr [ebp - local_288]         # 00497fc4
    {load} xor ecx, ecx                          # 00497fca
    mov cl, byte ptr [eax + field_50ee]          # 00497fcc
    and ecx, 0x80                                # 00497fd2
    mov edx, dword ptr [ebp - local_288]         # 00497fd8
    mov byte ptr [edx + field_50f1], cl          # 00497fde
    mov eax, dword ptr [ebp - local_288]         # 00497fe4
    {load} xor ecx, ecx                          # 00497fea
    mov cl, byte ptr [eax + field_50ef]          # 00497fec
    and ecx, 0x80                                # 00497ff2
    mov edx, dword ptr [ebp - local_288]         # 00497ff8
    mov byte ptr [edx + field_50f2], cl          # 00497ffe
    mov eax, dword ptr [ebp - local_288]         # 00498004
    mov cl, byte ptr [eax + field_50ed]          # 0049800a
    and cl, 0x7f                                 # 00498010
    mov edx, dword ptr [ebp - local_288]         # 00498013
    mov byte ptr [edx + field_50ed], cl          # 00498019
    mov eax, dword ptr [ebp - local_288]         # 0049801f
    mov cl, byte ptr [eax + field_50ee]          # 00498025
    and cl, 0x7f                                 # 0049802b
    mov edx, dword ptr [ebp - local_288]         # 0049802e
    mov byte ptr [edx + field_50ee], cl          # 00498034
    mov eax, dword ptr [ebp - local_288]         # 0049803a
    mov cl, byte ptr [eax + field_50ef]          # 00498040
    and cl, 0x7f                                 # 00498046
    mov edx, dword ptr [ebp - local_288]         # 00498049
    mov byte ptr [edx + field_50ef], cl          # 0049804f
    mov eax, dword ptr [ebp - local_288]         # 00498055
    mov ecx, dword ptr [ebp - local_288]         # 0049805b
    mov edx, dword ptr [ecx + field_50e5]        # 00498061
    mov dword ptr [eax + field_50e9], edx        # 00498067
    mov eax, dword ptr [ebp - local_288]         # 0049806d
    mov ecx, dword ptr [eax + field_50d9]        # 00498073
    imul ecx, ecx, 0xa6                          # 00498079
    mov edx, dword ptr [ebp - local_288]         # 0049807f
    mov eax, dword ptr [edx + field_1f57]        # 00498085
    lea ecx, [eax + 2*ecx]                       # 0049808b
    mov edx, dword ptr [ebp - local_288]         # 0049808e
    mov eax, dword ptr [edx + field_50dd]        # 00498094
    {load} xor edx, edx                          # 0049809a
    mov dx, word ptr [ecx + 2*eax]               # 0049809c
    mov dword ptr [ebp - local_fc], edx          # 004980a0
    mov eax, dword ptr [ebp - local_fc]          # 004980a6
    and eax, 0xf                                 # 004980ac
    mov dword ptr [ebp - local_dc], eax          # 004980af
    mov ecx, dword ptr [ebp - local_fc]          # 004980b5
    sar ecx, 0x4                                 # 004980bb
    and ecx, 0xf                                 # 004980be
    mov dword ptr [ebp - local_bc], ecx          # 004980c1
    mov edx, dword ptr [ebp - local_fc]          # 004980c7
    sar edx, 0x8                                 # 004980cd
    and edx, 0xf                                 # 004980d0
    mov dword ptr [ebp - local_104], edx         # 004980d3
    mov eax, dword ptr [ebp - local_288]         # 004980d9
    mov ecx, dword ptr [ebp - local_288]         # 004980df
    mov edx, dword ptr [ecx + field_5095]        # 004980e5
    mov dword ptr [eax + field_50ad], edx        # 004980eb
    mov eax, dword ptr [ebp - local_288]         # 004980f1
    fld dword ptr [eax + field_50ad]             # 004980f7
    fcomp qword ptr [0x52c598]                   # 004980fd
    fnstsw ax                                    # 00498103
    test ah, 0x1                                 # 00498105
    je.d8 L_0049811a                             # 00498108
    # block 0x0049810a: entered by fall-through of je at 0x00498108, 2 instruction(s), falls into the block at 0x0049811a
    mov ecx, dword ptr [ebp - local_288]         # 0049810a
    mov dword ptr [ecx + field_50ad], 0x3f800000 # 00498110
L_0049811a:
    # block 0x0049811a: entered by je at 0x00498108, 15 instruction(s), calls FUN_0050ce04, ends with jl to 0x00498184 (forward)
    mov edx, dword ptr [ebp - local_78]          # 0049811a
    mov eax, dword ptr [ebp - local_288]         # 0049811d
    mov ecx, dword ptr [ebp - local_288]         # 00498123
    mov ecx, dword ptr [ecx + field_50ad]        # 00498129
    mov dword ptr [eax + 4*edx + field_4821], ecx # 0049812f
    mov edx, dword ptr [ebp - local_288]         # 00498136
    fld dword ptr [edx + field_50a5]             # 0049813c
    call FUN_0050ce04                            # 00498142
    and eax, 0x7f                                # 00498147
    mov dword ptr [ebp - local_11c], eax         # 0049814a
    mov eax, dword ptr [ebp - local_288]         # 00498150
    mov ecx, dword ptr [ebp - local_288]         # 00498156
    mov edx, dword ptr [eax + field_50cd]        # 0049815c
    cmp edx, dword ptr [ecx + field_1f17]        # 00498162
    jl.d8 L_00498184                             # 00498168
    # block 0x0049816a: entered by fall-through of jl at 0x00498168, 5 instruction(s), ends with jle to 0x0049819c (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049816a
    mov ecx, dword ptr [ebp - local_288]         # 00498170
    mov edx, dword ptr [eax + field_50cd]        # 00498176
    cmp edx, dword ptr [ecx + field_1f23]        # 0049817c
    jle.d8 L_0049819c                            # 00498182
L_00498184:
    # block 0x00498184: entered by jl at 0x00498168; fall-through of jle at 0x00498182, 4 instruction(s), falls into the block at 0x0049819c
    mov eax, dword ptr [ebp - local_288]         # 00498184
    mov ecx, dword ptr [eax + field_45bd]        # 0049818a
    sub ecx, dword ptr [ebp - local_11c]         # 00498190
    mov dword ptr [ebp - local_11c], ecx         # 00498196
L_0049819c:
    # block 0x0049819c: entered by jle at 0x00498182, 5 instruction(s), ends with je to 0x004981fb (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049819c
    mov eax, dword ptr [edx + field_50e5]        # 004981a2
    and eax, 0x1000000                           # 004981a8
    test eax, eax                                # 004981ad
    je.d8 L_004981fb                             # 004981af
    # block 0x004981b1: entered by fall-through of je at 0x004981af, 5 instruction(s), ends with jne to 0x004981fb (forward)
    mov ecx, dword ptr [ebp - local_288]         # 004981b1
    mov edx, dword ptr [ecx + field_50e5]        # 004981b7
    and edx, 0x10000000                          # 004981bd
    test edx, edx                                # 004981c3
    jne.d8 L_004981fb                            # 004981c5
    # block 0x004981c7: entered by fall-through of jne at 0x004981c5, 5 instruction(s), ends with jne to 0x004981fb (forward)
    mov eax, dword ptr [ebp - local_288]         # 004981c7
    mov ecx, dword ptr [eax + field_50e5]        # 004981cd
    and ecx, 0x20000000                          # 004981d3
    test ecx, ecx                                # 004981d9
    jne.d8 L_004981fb                            # 004981db
    # block 0x004981dd: entered by fall-through of jne at 0x004981db, 5 instruction(s), ends with forward jump to 0x00498234
    mov dword ptr [ebp - local_15c], 0x1         # 004981dd
    mov edx, dword ptr [ebp - local_288]         # 004981e7
    mov eax, dword ptr [edx + field_45ad]        # 004981ed
    mov dword ptr [ebp - local_98], eax          # 004981f3
    jmp.d8 L_00498234                            # 004981f9
L_004981fb:
    # block 0x004981fb: entered by je at 0x004981af; jne at 0x004981c5; jne at 0x004981db, 11 instruction(s), falls into the block at 0x00498234
    mov ecx, dword ptr [ebp - local_288]         # 004981fb
    mov edx, dword ptr [ecx + field_50d9]        # 00498201
    imul edx, edx, 0xa6                          # 00498207
    mov eax, dword ptr [ebp - local_288]         # 0049820d
    mov ecx, dword ptr [eax + field_1f67]        # 00498213
    lea edx, [ecx + 2*edx]                       # 00498219
    mov eax, dword ptr [ebp - local_288]         # 0049821c
    mov ecx, dword ptr [eax + field_50dd]        # 00498222
    {load} xor eax, eax                          # 00498228
    mov ax, word ptr [edx + 2*ecx]               # 0049822a
    mov dword ptr [ebp - local_98], eax          # 0049822e
L_00498234:
    # block 0x00498234: entered by jmp at 0x004981f9, 1 instruction(s), ends with forward jump to 0x0049823b
    jmp.d8 L_0049823b                            # 00498234
L_00498236:
    # block 0x00498236: entered by jmp at 0x00497ee2; jle at 0x00497f24; jne at 0x00497f3e, 1 instruction(s), ends with backward jump to 0x004966fb
    jmp.d32 L_004966fb                           # 00498236
L_0049823b:
    # block 0x0049823b: entered by jmp at 0x00497edd; jmp at 0x00498234, 17 instruction(s), calls FUN_0050e30f, FUN_0050ce04, ends with jne to 0x0049829d (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049823b
    fild dword ptr [ecx + field_476d]            # 00498241
    fstp dword ptr [ebp - local_2ec]             # 00498247
    fild dword ptr [ebp - local_98]              # 0049824d
    fstp dword ptr [ebp - local_2f0]             # 00498253
    fld dword ptr [ebp - local_2ec]              # 00498259
    fmul dword ptr [ebp - local_2f0]             # 0049825f
    mov edx, dword ptr [ebp - local_288]         # 00498265
    fdiv dword ptr [edx + field_50ad]            # 0049826b
    sub esp, 0x8                                 # 00498271
    fstp qword ptr [esp]                         # 00498274
    call FUN_0050e30f                            # 00498277
    add esp, 0x8                                 # 0049827c
    call FUN_0050ce04                            # 0049827f
    mov dword ptr [ebp - local_12c], eax         # 00498284
    cmp dword ptr [ebp - local_12c], 0x0         # 0049828a
    jne.d8 L_0049829d                            # 00498291
    # block 0x00498293: entered by fall-through of jne at 0x00498291, 1 instruction(s), falls into the block at 0x0049829d
    mov dword ptr [ebp - local_12c], 0x1         # 00498293
L_0049829d:
    # block 0x0049829d: entered by jne at 0x00498291, 48 instruction(s), calls FUN_0050e30f, FUN_0050ce04, ends with jge to 0x004983fe (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049829d
    fild dword ptr [eax + field_476d]            # 004982a3
    fstp dword ptr [ebp - local_2f4]             # 004982a9
    mov ecx, dword ptr [ebp - local_288]         # 004982af
    fild dword ptr [ecx + field_47ad]            # 004982b5
    fstp dword ptr [ebp - local_2f8]             # 004982bb
    fld dword ptr [ebp - local_2f4]              # 004982c1
    fmul dword ptr [ebp - local_2f8]             # 004982c7
    mov edx, dword ptr [ebp - local_288]         # 004982cd
    fdiv dword ptr [edx + field_50ad]            # 004982d3
    mov eax, dword ptr [ebp - local_288]         # 004982d9
    fild dword ptr [eax + field_4789]            # 004982df
    fstp dword ptr [ebp - local_2fc]             # 004982e5
    fadd dword ptr [ebp - local_2fc]             # 004982eb
    sub esp, 0x8                                 # 004982f1
    fstp qword ptr [esp]                         # 004982f4
    call FUN_0050e30f                            # 004982f7
    add esp, 0x8                                 # 004982fc
    call FUN_0050ce04                            # 004982ff
    mov dword ptr [ebp - local_7c], eax          # 00498304
    mov ecx, dword ptr [ebp - local_7c]          # 00498307
    sub ecx, dword ptr [ebp - local_12c]         # 0049830a
    add ecx, 0x1                                 # 00498310
    mov dword ptr [ebp - local_34], ecx          # 00498313
    mov edx, dword ptr [ebp - local_288]         # 00498316
    mov eax, dword ptr [ebp - local_11c]         # 0049831c
    mov ecx, dword ptr [edx + field_47d5]        # 00498322
    shl eax, cl                                  # 00498328
    mov dword ptr [ebp - local_a8], eax          # 0049832a
    mov ecx, dword ptr [ebp - local_288]         # 00498330
    mov edx, dword ptr [ecx + field_45b5]        # 00498336
    sub edx, 0x1                                 # 0049833c
    mov dword ptr [ebp - local_120], edx         # 0049833f
    mov eax, dword ptr [ebp - local_12c]         # 00498345
    mov dword ptr [ebp - local_130], eax         # 0049834b
    mov ecx, dword ptr [ebp - local_98]          # 00498351
    mov dword ptr [ebp - local_158], ecx         # 00498357
    fild dword ptr [ebp - local_98]              # 0049835d
    fstp dword ptr [ebp - local_300]             # 00498363
    fild dword ptr [ebp - local_12c]             # 00498369
    fstp dword ptr [ebp - local_304]             # 0049836f
    fld dword ptr [ebp - local_300]              # 00498375
    fdiv dword ptr [ebp - local_304]             # 0049837b
    fstp dword ptr [ebp - local_16c]             # 00498381
    mov edx, dword ptr [ebp - local_288]         # 00498387
    mov eax, dword ptr [ebp - local_34]          # 0049838d
    cmp eax, dword ptr [edx + field_4779]        # 00498390
    jge.d8 L_004983fe                            # 00498396
    # block 0x00498398: entered by fall-through of jge at 0x00498396, 22 instruction(s), calls FUN_0050e30f, FUN_0050ce04, falls into the block at 0x004983fe
    mov ecx, dword ptr [ebp - local_288]         # 00498398
    mov edx, dword ptr [ecx + field_4779]        # 0049839e
    sub edx, dword ptr [ebp - local_34]          # 004983a4
    mov dword ptr [ebp - local_48], edx          # 004983a7
    mov eax, dword ptr [ebp - local_130]         # 004983aa
    sub eax, dword ptr [ebp - local_48]          # 004983b0
    mov dword ptr [ebp - local_130], eax         # 004983b3
    fild dword ptr [ebp - local_48]              # 004983b9
    fstp dword ptr [ebp - local_308]             # 004983bc
    fld dword ptr [ebp - local_308]              # 004983c2
    fmul dword ptr [ebp - local_16c]             # 004983c8
    sub esp, 0x8                                 # 004983ce
    fstp qword ptr [esp]                         # 004983d1
    call FUN_0050e30f                            # 004983d4
    add esp, 0x8                                 # 004983d9
    call FUN_0050ce04                            # 004983dc
    mov ecx, dword ptr [ebp - local_158]         # 004983e1
    {load} sub ecx, eax                          # 004983e7
    mov dword ptr [ebp - local_158], ecx         # 004983e9
    mov edx, dword ptr [ebp - local_288]         # 004983ef
    mov eax, dword ptr [edx + field_4779]        # 004983f5
    mov dword ptr [ebp - local_34], eax          # 004983fb
L_004983fe:
    # block 0x004983fe: entered by jge at 0x00498396, 3 instruction(s), ends with jle to 0x00498494 (forward)
    mov ecx, dword ptr [ebp - local_7c]          # 004983fe
    cmp ecx, dword ptr [ebp - local_24]          # 00498401
    jle.d32 L_00498494                           # 00498404
    # block 0x0049840a: entered by fall-through of jle at 0x00498404, 32 instruction(s), calls FUN_0050e30f, FUN_0050ce04, FUN_0050e19e, falls into the block at 0x00498494
    mov edx, dword ptr [ebp - local_7c]          # 0049840a
    sub edx, dword ptr [ebp - local_24]          # 0049840d
    mov dword ptr [ebp - local_48], edx          # 00498410
    mov eax, dword ptr [ebp - local_130]         # 00498413
    sub eax, dword ptr [ebp - local_48]          # 00498419
    mov dword ptr [ebp - local_130], eax         # 0049841c
    fild dword ptr [ebp - local_48]              # 00498422
    fstp dword ptr [ebp - local_30c]             # 00498425
    fld dword ptr [ebp - local_30c]              # 0049842b
    fmul dword ptr [ebp - local_16c]             # 00498431
    sub esp, 0x8                                 # 00498437
    fstp qword ptr [esp]                         # 0049843a
    call FUN_0050e30f                            # 0049843d
    add esp, 0x8                                 # 00498442
    call FUN_0050ce04                            # 00498445
    mov ecx, dword ptr [ebp - local_158]         # 0049844a
    {load} sub ecx, eax                          # 00498450
    mov dword ptr [ebp - local_158], ecx         # 00498452
    fild dword ptr [ebp - local_48]              # 00498458
    fstp dword ptr [ebp - local_310]             # 0049845b
    fld dword ptr [ebp - local_310]              # 00498461
    fmul dword ptr [ebp - local_16c]             # 00498467
    sub esp, 0x8                                 # 0049846d
    fstp qword ptr [esp]                         # 00498470
    call FUN_0050e19e                            # 00498473
    add esp, 0x8                                 # 00498478
    call FUN_0050ce04                            # 0049847b
    mov edx, dword ptr [ebp - local_120]         # 00498480
    {load} sub edx, eax                          # 00498486
    mov dword ptr [ebp - local_120], edx         # 00498488
    mov eax, dword ptr [ebp - local_24]          # 0049848e
    mov dword ptr [ebp - local_7c], eax          # 00498491
L_00498494:
    # block 0x00498494: entered by jle at 0x00498404, 2 instruction(s), ends with jge to 0x004984a2 (forward)
    cmp dword ptr [ebp - local_130], 0x2         # 00498494
    jge.d8 L_004984a2                            # 0049849b
    # block 0x0049849d: entered by fall-through of jge at 0x0049849b, 1 instruction(s), ends with forward jump to 0x0049c452
    jmp.d32 L_0049c452                           # 0049849d
L_004984a2:
    # block 0x004984a2: entered by jge at 0x0049849b, 45 instruction(s), calls FUN_0050ce04, ends with jl to 0x00498593 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 004984a2
    mov edx, dword ptr [ebp - local_7c]          # 004984a8
    imul edx, dword ptr [ecx + field_1fff]       # 004984ab
    mov eax, dword ptr [ebp - local_288]         # 004984b2
    mov esi, dword ptr [ebp - local_78]          # 004984b8
    mov ecx, dword ptr [eax + field_47e5]        # 004984bb
    shl esi, cl                                  # 004984c1
    {load} add edx, esi                          # 004984c3
    mov dword ptr [ebp - local_ac], edx          # 004984c5
    mov ecx, dword ptr [ebp - local_288]         # 004984cb
    mov edx, dword ptr [ecx + field_1f7f]        # 004984d1
    add edx, dword ptr [ebp - local_ac]          # 004984d7
    mov dword ptr [ebp - local_160], edx         # 004984dd
    mov eax, dword ptr [ebp - local_7c]          # 004984e3
    imul eax, eax, 0x218                         # 004984e6
    mov ecx, dword ptr [ebp - local_288]         # 004984ec
    mov edx, dword ptr [ecx + field_50f3]        # 004984f2
    {load} add edx, eax                          # 004984f8
    add edx, dword ptr [ebp - local_78]          # 004984fa
    mov dword ptr [ebp - local_84], edx          # 004984fd
    fild dword ptr [ebp - local_158]             # 00498503
    fstp dword ptr [ebp - local_314]             # 00498509
    fild dword ptr [ebp - local_130]             # 0049850f
    fstp dword ptr [ebp - local_318]             # 00498515
    fld dword ptr [ebp - local_314]              # 0049851b
    fdiv dword ptr [ebp - local_318]             # 00498521
    fmul dword ptr [0x52db54]                    # 00498527
    call FUN_0050ce04                            # 0049852d
    mov dword ptr [ebp - local_118], eax         # 00498532
    mov eax, dword ptr [ebp - local_120]         # 00498538
    shl eax, 0x10                                # 0049853e
    mov dword ptr [ebp - local_120], eax         # 00498541
    mov ecx, dword ptr [ebp - local_288]         # 00498547
    mov edx, dword ptr [ecx + field_45b1]        # 0049854d
    shl edx                                      # 00498553
    mov dword ptr [ebp - local_44], edx          # 00498555
    mov eax, dword ptr [ebp - local_78]          # 00498558
    mov ecx, dword ptr [ebp - local_288]         # 0049855b
    fld dword ptr [ecx + 4*eax + field_4821]     # 00498561
    call FUN_0050ce04                            # 00498568
    mov dword ptr [ebp - local_284], eax         # 0049856d
    mov edx, dword ptr [ebp - local_288]         # 00498573
    mov eax, dword ptr [ebp - local_284]         # 00498579
    cmp eax, dword ptr [edx + field_20bd]        # 0049857f
    jl.d8 L_00498593                             # 00498585
    # block 0x00498587: entered by fall-through of jl at 0x00498585, 2 instruction(s), ends with forward jump to 0x004985b0
    mov dword ptr [ebp - local_f4], 0x7          # 00498587
    jmp.d8 L_004985b0                            # 00498591
L_00498593:
    # block 0x00498593: entered by jl at 0x00498585, 6 instruction(s), falls into the block at 0x004985b0
    mov ecx, dword ptr [ebp - local_288]         # 00498593
    mov edx, dword ptr [ecx + field_20b5]        # 00498599
    mov eax, dword ptr [ebp - local_284]         # 0049859f
    {load} xor ecx, ecx                          # 004985a5
    mov cl, byte ptr [edx + eax]                 # 004985a7
    mov dword ptr [ebp - local_f4], ecx          # 004985aa
L_004985b0:
    # block 0x004985b0: entered by jmp at 0x00498591, 13 instruction(s), ends with jle to 0x00498606 (forward)
    mov edx, dword ptr [ebp - local_dc]          # 004985b0
    add edx, dword ptr [ebp - local_f4]          # 004985b6
    mov dword ptr [ebp - local_94], edx          # 004985bc
    mov eax, dword ptr [ebp - local_bc]          # 004985c2
    add eax, dword ptr [ebp - local_f4]          # 004985c8
    mov dword ptr [ebp - local_30], eax          # 004985ce
    mov ecx, dword ptr [ebp - local_104]         # 004985d1
    add ecx, dword ptr [ebp - local_f4]          # 004985d7
    mov dword ptr [ebp - local_14], ecx          # 004985dd
    mov edx, dword ptr [ebp - local_288]         # 004985e0
    mov eax, dword ptr [ebp - local_94]          # 004985e6
    cmp eax, dword ptr [edx + field_20b9]        # 004985ec
    jle.d8 L_00498606                            # 004985f2
    # block 0x004985f4: entered by fall-through of jle at 0x004985f2, 3 instruction(s), falls into the block at 0x00498606
    mov ecx, dword ptr [ebp - local_288]         # 004985f4
    mov edx, dword ptr [ecx + field_20b9]        # 004985fa
    mov dword ptr [ebp - local_94], edx          # 00498600
L_00498606:
    # block 0x00498606: entered by jle at 0x004985f2, 4 instruction(s), ends with jle to 0x00498626 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00498606
    mov ecx, dword ptr [ebp - local_30]          # 0049860c
    cmp ecx, dword ptr [eax + field_20b9]        # 0049860f
    jle.d8 L_00498626                            # 00498615
    # block 0x00498617: entered by fall-through of jle at 0x00498615, 3 instruction(s), falls into the block at 0x00498626
    mov edx, dword ptr [ebp - local_288]         # 00498617
    mov eax, dword ptr [edx + field_20b9]        # 0049861d
    mov dword ptr [ebp - local_30], eax          # 00498623
L_00498626:
    # block 0x00498626: entered by jle at 0x00498615, 4 instruction(s), ends with jle to 0x00498646 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00498626
    mov edx, dword ptr [ebp - local_14]          # 0049862c
    cmp edx, dword ptr [ecx + field_20b9]        # 0049862f
    jle.d8 L_00498646                            # 00498635
    # block 0x00498637: entered by fall-through of jle at 0x00498635, 3 instruction(s), falls into the block at 0x00498646
    mov eax, dword ptr [ebp - local_288]         # 00498637
    mov ecx, dword ptr [eax + field_20b9]        # 0049863d
    mov dword ptr [ebp - local_14], ecx          # 00498643
L_00498646:
    # block 0x00498646: entered by jle at 0x00498635, 5 instruction(s), ends with jne to 0x004991e4 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00498646
    mov eax, dword ptr [edx + field_50e9]        # 0049864c
    and eax, 0x10000000                          # 00498652
    test eax, eax                                # 00498657
    jne.d32 L_004991e4                           # 00498659
    # block 0x0049865f: entered by fall-through of jne at 0x00498659, 5 instruction(s), ends with jne to 0x004991e4 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049865f
    mov edx, dword ptr [ecx + field_50e9]        # 00498665
    and edx, 0x20000000                          # 0049866b
    test edx, edx                                # 00498671
    jne.d32 L_004991e4                           # 00498673
    # block 0x00498679: entered by fall-through of jne at 0x00498673, 5 instruction(s), ends with je to 0x004988b9 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00498679
    mov ecx, dword ptr [eax + field_1f27]        # 0049867f
    mov dword ptr [ebp - local_31c], ecx         # 00498685
    cmp dword ptr [ebp - local_31c], 0x2         # 0049868b
    je.d32 L_004988b9                            # 00498692
    # block 0x00498698: entered by fall-through of je at 0x00498692, 2 instruction(s), ends with je to 0x00498c77 (forward)
    cmp dword ptr [ebp - local_31c], 0x3         # 00498698
    je.d32 L_00498c77                            # 0049869f
    # block 0x004986a5: entered by fall-through of je at 0x0049869f, 5 instruction(s), ends with jne to 0x004986ef (forward)
    mov edx, dword ptr [ebp - local_288]         # 004986a5
    {load} xor eax, eax                          # 004986ab
    mov al, byte ptr [edx + field_50f0]          # 004986ad
    test eax, eax                                # 004986b3
    jne.d8 L_004986ef                            # 004986b5
    # block 0x004986b7: entered by fall-through of jne at 0x004986b5, 11 instruction(s), ends with forward jump to 0x00498725
    mov ecx, dword ptr [ebp - local_94]          # 004986b7
    imul ecx, ecx, 0x154                         # 004986bd
    mov edx, dword ptr [ebp - local_288]         # 004986c3
    lea eax, [edx + ecx + field_2491]            # 004986c9
    mov ecx, dword ptr [ebp - local_288]         # 004986d0
    {load} xor edx, edx                          # 004986d6
    mov dl, byte ptr [ecx + field_50ed]          # 004986d8
    mov eax, dword ptr [eax + 4*edx]             # 004986de
    add eax, dword ptr [ebp - local_a8]          # 004986e1
    mov dword ptr [ebp - local_88], eax          # 004986e7
    jmp.d8 L_00498725                            # 004986ed
L_004986ef:
    # block 0x004986ef: entered by jne at 0x004986b5, 10 instruction(s), falls into the block at 0x00498725
    mov ecx, dword ptr [ebp - local_94]          # 004986ef
    imul ecx, ecx, 0xa0                          # 004986f5
    mov edx, dword ptr [ebp - local_288]         # 004986fb
    lea eax, [edx + ecx + field_2f31]            # 00498701
    mov ecx, dword ptr [ebp - local_288]         # 00498708
    {load} xor edx, edx                          # 0049870e
    mov dl, byte ptr [ecx + field_50ed]          # 00498710
    mov eax, dword ptr [eax + 4*edx]             # 00498716
    add eax, dword ptr [ebp - local_a8]          # 00498719
    mov dword ptr [ebp - local_88], eax          # 0049871f
L_00498725:
    # block 0x00498725: entered by jmp at 0x004986ed, 2 instruction(s), ends with je to 0x00498801 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 00498725
    je.d32 L_00498801                            # 00498729
    # block 0x0049872f: entered by fall-through of je at 0x00498729, 2 instruction(s), ends with forward jump to 0x00498741
    mov dword ptr [ebp - local_74], 0x0          # 0049872f
    jmp.d8 L_00498741                            # 00498736
L_00498738:
    # block 0x00498738: entered by jmp at 0x004987f7, 3 instruction(s), falls into the block at 0x00498741
    mov ecx, dword ptr [ebp - local_74]          # 00498738
    add ecx, 0x1                                 # 0049873b
    mov dword ptr [ebp - local_74], ecx          # 0049873e
L_00498741:
    # block 0x00498741: entered by jmp at 0x00498736, 3 instruction(s), ends with jge to 0x004987fc (forward)
    mov edx, dword ptr [ebp - local_74]          # 00498741
    cmp edx, dword ptr [ebp - local_130]         # 00498744
    jge.d32 L_004987fc                           # 0049874a
    # block 0x00498750: entered by fall-through of jge at 0x0049874a, 7 instruction(s), ends with je to 0x004987ad (forward)
    mov eax, dword ptr [ebp - local_84]          # 00498750
    {load} xor ecx, ecx                          # 00498756
    mov cl, byte ptr [eax]                       # 00498758
    mov edx, dword ptr [ebp - local_b0]          # 0049875a
    and edx, 0xff                                # 00498760
    {load} cmp ecx, edx                          # 00498766
    je.d8 L_004987ad                             # 00498768
    # block 0x0049876a: entered by fall-through of je at 0x00498768, 14 instruction(s), falls into the block at 0x004987ad
    mov eax, dword ptr [ebp - local_120]         # 0049876a
    shr eax, 0x10                                # 00498770
    mov dword ptr [ebp - local_114], eax         # 00498773
    mov ecx, dword ptr [ebp - local_114]         # 00498779
    shl ecx                                      # 0049877f
    mov dword ptr [ebp - local_114], ecx         # 00498781
    mov edx, dword ptr [ebp - local_88]          # 00498787
    add edx, dword ptr [ebp - local_114]         # 0049878d
    mov eax, dword ptr [ebp - local_160]         # 00498793
    mov cx, word ptr [edx]                       # 00498799
    mov word ptr [eax], cx                       # 0049879c
    mov edx, dword ptr [ebp - local_84]          # 0049879f
    mov al, byte ptr [ebp - local_b0]            # 004987a5
    mov byte ptr [edx], al                       # 004987ab
L_004987ad:
    # block 0x004987ad: entered by je at 0x00498768, 3 instruction(s), ends with jbe to 0x004987cd (forward)
    mov ecx, dword ptr [ebp - local_120]         # 004987ad
    cmp ecx, dword ptr [ebp - local_118]         # 004987b3
    jbe.d8 L_004987cd                            # 004987b9
    # block 0x004987bb: entered by fall-through of jbe at 0x004987b9, 3 instruction(s), falls into the block at 0x004987cd
    mov edx, dword ptr [ebp - local_120]         # 004987bb
    sub edx, dword ptr [ebp - local_118]         # 004987c1
    mov dword ptr [ebp - local_120], edx         # 004987c7
L_004987cd:
    # block 0x004987cd: entered by jbe at 0x004987b9, 8 instruction(s), ends with backward jump to 0x00498738
    mov eax, dword ptr [ebp - local_288]         # 004987cd
    mov ecx, dword ptr [ebp - local_160]         # 004987d3
    sub ecx, dword ptr [eax + field_1fff]        # 004987d9
    mov dword ptr [ebp - local_160], ecx         # 004987df
    mov edx, dword ptr [ebp - local_84]          # 004987e5
    sub edx, 0x218                               # 004987eb
    mov dword ptr [ebp - local_84], edx          # 004987f1
    jmp.d32 L_00498738                           # 004987f7
L_004987fc:
    # block 0x004987fc: entered by jge at 0x0049874a, 1 instruction(s), ends with forward jump to 0x004988b4
    jmp.d32 L_004988b4                           # 004987fc
L_00498801:
    # block 0x00498801: entered by je at 0x00498729, 2 instruction(s), ends with forward jump to 0x00498813
    mov dword ptr [ebp - local_74], 0x0          # 00498801
    jmp.d8 L_00498813                            # 00498808
L_0049880a:
    # block 0x0049880a: entered by jmp at 0x004988af, 3 instruction(s), falls into the block at 0x00498813
    mov eax, dword ptr [ebp - local_74]          # 0049880a
    add eax, 0x1                                 # 0049880d
    mov dword ptr [ebp - local_74], eax          # 00498810
L_00498813:
    # block 0x00498813: entered by jmp at 0x00498808, 3 instruction(s), ends with jge to 0x004988b4 (forward)
    mov ecx, dword ptr [ebp - local_74]          # 00498813
    cmp ecx, dword ptr [ebp - local_130]         # 00498816
    jge.d32 L_004988b4                           # 0049881c
    # block 0x00498822: entered by fall-through of jge at 0x0049881c, 14 instruction(s), ends with jbe to 0x00498877 (forward)
    mov edx, dword ptr [ebp - local_120]         # 00498822
    shr edx, 0x10                                # 00498828
    mov dword ptr [ebp - local_114], edx         # 0049882b
    mov eax, dword ptr [ebp - local_114]         # 00498831
    shl eax                                      # 00498837
    mov dword ptr [ebp - local_114], eax         # 00498839
    mov ecx, dword ptr [ebp - local_88]          # 0049883f
    add ecx, dword ptr [ebp - local_114]         # 00498845
    mov edx, dword ptr [ebp - local_160]         # 0049884b
    mov ax, word ptr [ecx]                       # 00498851
    mov word ptr [edx], ax                       # 00498854
    mov ecx, dword ptr [ebp - local_120]         # 00498857
    cmp ecx, dword ptr [ebp - local_118]         # 0049885d
    jbe.d8 L_00498877                            # 00498863
    # block 0x00498865: entered by fall-through of jbe at 0x00498863, 3 instruction(s), falls into the block at 0x00498877
    mov edx, dword ptr [ebp - local_120]         # 00498865
    sub edx, dword ptr [ebp - local_118]         # 0049886b
    mov dword ptr [ebp - local_120], edx         # 00498871
L_00498877:
    # block 0x00498877: entered by jbe at 0x00498863, 11 instruction(s), ends with backward jump to 0x0049880a
    mov eax, dword ptr [ebp - local_288]         # 00498877
    mov ecx, dword ptr [ebp - local_160]         # 0049887d
    sub ecx, dword ptr [eax + field_1fff]        # 00498883
    mov dword ptr [ebp - local_160], ecx         # 00498889
    mov edx, dword ptr [ebp - local_84]          # 0049888f
    mov al, byte ptr [ebp - local_b0]            # 00498895
    mov byte ptr [edx], al                       # 0049889b
    mov ecx, dword ptr [ebp - local_84]          # 0049889d
    sub ecx, 0x218                               # 004988a3
    mov dword ptr [ebp - local_84], ecx          # 004988a9
    jmp.d32 L_0049880a                           # 004988af
L_004988b4:
    # block 0x004988b4: entered by jmp at 0x004987fc; jge at 0x0049881c, 1 instruction(s), ends with forward jump to 0x004991df
    jmp.d32 L_004991df                           # 004988b4
L_004988b9:
    # block 0x004988b9: entered by je at 0x00498692, 5 instruction(s), ends with jne to 0x00498903 (forward)
    mov edx, dword ptr [ebp - local_288]         # 004988b9
    {load} xor eax, eax                          # 004988bf
    mov al, byte ptr [edx + field_50f0]          # 004988c1
    test eax, eax                                # 004988c7
    jne.d8 L_00498903                            # 004988c9
    # block 0x004988cb: entered by fall-through of jne at 0x004988c9, 11 instruction(s), ends with forward jump to 0x00498939
    mov ecx, dword ptr [ebp - local_94]          # 004988cb
    imul ecx, ecx, 0x154                         # 004988d1
    mov edx, dword ptr [ebp - local_288]         # 004988d7
    lea eax, [edx + ecx + field_2491]            # 004988dd
    mov ecx, dword ptr [ebp - local_288]         # 004988e4
    {load} xor edx, edx                          # 004988ea
    mov dl, byte ptr [ecx + field_50ed]          # 004988ec
    mov eax, dword ptr [eax + 4*edx]             # 004988f2
    add eax, dword ptr [ebp - local_a8]          # 004988f5
    mov dword ptr [ebp - local_10c], eax         # 004988fb
    jmp.d8 L_00498939                            # 00498901
L_00498903:
    # block 0x00498903: entered by jne at 0x004988c9, 10 instruction(s), falls into the block at 0x00498939
    mov ecx, dword ptr [ebp - local_94]          # 00498903
    imul ecx, ecx, 0xa0                          # 00498909
    mov edx, dword ptr [ebp - local_288]         # 0049890f
    lea eax, [edx + ecx + field_2f31]            # 00498915
    mov ecx, dword ptr [ebp - local_288]         # 0049891c
    {load} xor edx, edx                          # 00498922
    mov dl, byte ptr [ecx + field_50ed]          # 00498924
    mov eax, dword ptr [eax + 4*edx]             # 0049892a
    add eax, dword ptr [ebp - local_a8]          # 0049892d
    mov dword ptr [ebp - local_10c], eax         # 00498933
L_00498939:
    # block 0x00498939: entered by jmp at 0x00498901, 5 instruction(s), ends with jne to 0x00498980 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00498939
    {load} xor edx, edx                          # 0049893f
    mov dl, byte ptr [ecx + field_50f1]          # 00498941
    test edx, edx                                # 00498947
    jne.d8 L_00498980                            # 00498949
    # block 0x0049894b: entered by fall-through of jne at 0x00498949, 11 instruction(s), ends with forward jump to 0x004989b3
    mov eax, dword ptr [ebp - local_30]          # 0049894b
    imul eax, eax, 0x154                         # 0049894e
    mov ecx, dword ptr [ebp - local_288]         # 00498954
    lea edx, [ecx + eax + field_2491]            # 0049895a
    mov eax, dword ptr [ebp - local_288]         # 00498961
    {load} xor ecx, ecx                          # 00498967
    mov cl, byte ptr [eax + field_50ee]          # 00498969
    mov edx, dword ptr [edx + 4*ecx]             # 0049896f
    add edx, dword ptr [ebp - local_a8]          # 00498972
    mov dword ptr [ebp - local_13c], edx         # 00498978
    jmp.d8 L_004989b3                            # 0049897e
L_00498980:
    # block 0x00498980: entered by jne at 0x00498949, 10 instruction(s), falls into the block at 0x004989b3
    mov eax, dword ptr [ebp - local_30]          # 00498980
    imul eax, eax, 0xa0                          # 00498983
    mov ecx, dword ptr [ebp - local_288]         # 00498989
    lea edx, [ecx + eax + field_2f31]            # 0049898f
    mov eax, dword ptr [ebp - local_288]         # 00498996
    {load} xor ecx, ecx                          # 0049899c
    mov cl, byte ptr [eax + field_50ee]          # 0049899e
    mov edx, dword ptr [edx + 4*ecx]             # 004989a4
    add edx, dword ptr [ebp - local_a8]          # 004989a7
    mov dword ptr [ebp - local_13c], edx         # 004989ad
L_004989b3:
    # block 0x004989b3: entered by jmp at 0x0049897e, 2 instruction(s), ends with je to 0x00498b35 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004989b3
    je.d32 L_00498b35                            # 004989b7
    # block 0x004989bd: entered by fall-through of je at 0x004989b7, 2 instruction(s), ends with forward jump to 0x004989cf
    mov dword ptr [ebp - local_74], 0x0          # 004989bd
    jmp.d8 L_004989cf                            # 004989c4
L_004989c6:
    # block 0x004989c6: entered by jmp at 0x00498b2b, 3 instruction(s), falls into the block at 0x004989cf
    mov eax, dword ptr [ebp - local_74]          # 004989c6
    add eax, 0x1                                 # 004989c9
    mov dword ptr [ebp - local_74], eax          # 004989cc
L_004989cf:
    # block 0x004989cf: entered by jmp at 0x004989c4, 3 instruction(s), ends with jge to 0x00498b30 (forward)
    mov ecx, dword ptr [ebp - local_74]          # 004989cf
    cmp ecx, dword ptr [ebp - local_130]         # 004989d2
    jge.d32 L_00498b30                           # 004989d8
    # block 0x004989de: entered by fall-through of jge at 0x004989d8, 7 instruction(s), ends with jb to 0x00498aa2 (forward)
    mov edx, dword ptr [ebp - local_120]         # 004989de
    shr edx, 0x10                                # 004989e4
    mov dword ptr [ebp - local_114], edx         # 004989e7
    mov eax, dword ptr [ebp - local_288]         # 004989ed
    mov ecx, dword ptr [ebp - local_114]         # 004989f3
    cmp ecx, dword ptr [eax + field_45b1]        # 004989f9
    jb.d32 L_00498aa2                            # 004989ff
    # block 0x00498a05: entered by fall-through of jb at 0x004989ff, 7 instruction(s), ends with je to 0x00498a62 (forward)
    mov edx, dword ptr [ebp - local_84]          # 00498a05
    {load} xor eax, eax                          # 00498a0b
    mov al, byte ptr [edx]                       # 00498a0d
    mov ecx, dword ptr [ebp - local_b0]          # 00498a0f
    and ecx, 0xff                                # 00498a15
    {load} cmp eax, ecx                          # 00498a1b
    je.d8 L_00498a62                             # 00498a1d
    # block 0x00498a1f: entered by fall-through of je at 0x00498a1d, 14 instruction(s), falls into the block at 0x00498a62
    mov edx, dword ptr [ebp - local_114]         # 00498a1f
    and edx, 0x7f                                # 00498a25
    mov dword ptr [ebp - local_114], edx         # 00498a28
    mov eax, dword ptr [ebp - local_114]         # 00498a2e
    shl eax                                      # 00498a34
    mov dword ptr [ebp - local_114], eax         # 00498a36
    mov ecx, dword ptr [ebp - local_10c]         # 00498a3c
    add ecx, dword ptr [ebp - local_114]         # 00498a42
    mov edx, dword ptr [ebp - local_160]         # 00498a48
    mov ax, word ptr [ecx]                       # 00498a4e
    mov word ptr [edx], ax                       # 00498a51
    mov ecx, dword ptr [ebp - local_84]          # 00498a54
    mov dl, byte ptr [ebp - local_b0]            # 00498a5a
    mov byte ptr [ecx], dl                       # 00498a60
L_00498a62:
    # block 0x00498a62: entered by je at 0x00498a1d, 11 instruction(s), ends with forward jump to 0x00498b2b
    mov eax, dword ptr [ebp - local_120]         # 00498a62
    sub eax, dword ptr [ebp - local_118]         # 00498a68
    mov dword ptr [ebp - local_120], eax         # 00498a6e
    mov ecx, dword ptr [ebp - local_288]         # 00498a74
    mov edx, dword ptr [ebp - local_160]         # 00498a7a
    sub edx, dword ptr [ecx + field_1fff]        # 00498a80
    mov dword ptr [ebp - local_160], edx         # 00498a86
    mov eax, dword ptr [ebp - local_84]          # 00498a8c
    sub eax, 0x218                               # 00498a92
    mov dword ptr [ebp - local_84], eax          # 00498a97
    jmp.d32 L_00498b2b                           # 00498a9d
L_00498aa2:
    # block 0x00498aa2: entered by jb at 0x004989ff, 7 instruction(s), ends with je to 0x00498aef (forward)
    mov ecx, dword ptr [ebp - local_84]          # 00498aa2
    {load} xor edx, edx                          # 00498aa8
    mov dl, byte ptr [ecx]                       # 00498aaa
    mov eax, dword ptr [ebp - local_b0]          # 00498aac
    and eax, 0xff                                # 00498ab2
    {load} cmp edx, eax                          # 00498ab7
    je.d8 L_00498aef                             # 00498ab9
    # block 0x00498abb: entered by fall-through of je at 0x00498ab9, 11 instruction(s), falls into the block at 0x00498aef
    mov ecx, dword ptr [ebp - local_114]         # 00498abb
    shl ecx                                      # 00498ac1
    mov dword ptr [ebp - local_114], ecx         # 00498ac3
    mov edx, dword ptr [ebp - local_13c]         # 00498ac9
    add edx, dword ptr [ebp - local_114]         # 00498acf
    mov eax, dword ptr [ebp - local_160]         # 00498ad5
    mov cx, word ptr [edx]                       # 00498adb
    mov word ptr [eax], cx                       # 00498ade
    mov edx, dword ptr [ebp - local_84]          # 00498ae1
    mov al, byte ptr [ebp - local_b0]            # 00498ae7
    mov byte ptr [edx], al                       # 00498aed
L_00498aef:
    # block 0x00498aef: entered by je at 0x00498ab9, 10 instruction(s), falls into the block at 0x00498b2b
    mov ecx, dword ptr [ebp - local_120]         # 00498aef
    sub ecx, dword ptr [ebp - local_118]         # 00498af5
    mov dword ptr [ebp - local_120], ecx         # 00498afb
    mov edx, dword ptr [ebp - local_288]         # 00498b01
    mov eax, dword ptr [ebp - local_160]         # 00498b07
    sub eax, dword ptr [edx + field_1fff]        # 00498b0d
    mov dword ptr [ebp - local_160], eax         # 00498b13
    mov ecx, dword ptr [ebp - local_84]          # 00498b19
    sub ecx, 0x218                               # 00498b1f
    mov dword ptr [ebp - local_84], ecx          # 00498b25
L_00498b2b:
    # block 0x00498b2b: entered by jmp at 0x00498a9d, 1 instruction(s), ends with backward jump to 0x004989c6
    jmp.d32 L_004989c6                           # 00498b2b
L_00498b30:
    # block 0x00498b30: entered by jge at 0x004989d8, 1 instruction(s), ends with forward jump to 0x00498c72
    jmp.d32 L_00498c72                           # 00498b30
L_00498b35:
    # block 0x00498b35: entered by je at 0x004989b7, 2 instruction(s), ends with forward jump to 0x00498b47
    mov dword ptr [ebp - local_74], 0x0          # 00498b35
    jmp.d8 L_00498b47                            # 00498b3c
L_00498b3e:
    # block 0x00498b3e: entered by jmp at 0x00498c6d, 3 instruction(s), falls into the block at 0x00498b47
    mov edx, dword ptr [ebp - local_74]          # 00498b3e
    add edx, 0x1                                 # 00498b41
    mov dword ptr [ebp - local_74], edx          # 00498b44
L_00498b47:
    # block 0x00498b47: entered by jmp at 0x00498b3c, 3 instruction(s), ends with jge to 0x00498c72 (forward)
    mov eax, dword ptr [ebp - local_74]          # 00498b47
    cmp eax, dword ptr [ebp - local_130]         # 00498b4a
    jge.d32 L_00498c72                           # 00498b50
    # block 0x00498b56: entered by fall-through of jge at 0x00498b50, 7 instruction(s), ends with jb to 0x00498bfe (forward)
    mov ecx, dword ptr [ebp - local_120]         # 00498b56
    shr ecx, 0x10                                # 00498b5c
    mov dword ptr [ebp - local_114], ecx         # 00498b5f
    mov edx, dword ptr [ebp - local_288]         # 00498b65
    mov eax, dword ptr [ebp - local_114]         # 00498b6b
    cmp eax, dword ptr [edx + field_45b1]        # 00498b71
    jb.d32 L_00498bfe                            # 00498b77
    # block 0x00498b7d: entered by fall-through of jb at 0x00498b77, 25 instruction(s), ends with forward jump to 0x00498c6d
    mov ecx, dword ptr [ebp - local_114]         # 00498b7d
    and ecx, 0x7f                                # 00498b83
    mov dword ptr [ebp - local_114], ecx         # 00498b86
    mov edx, dword ptr [ebp - local_114]         # 00498b8c
    shl edx                                      # 00498b92
    mov dword ptr [ebp - local_114], edx         # 00498b94
    mov eax, dword ptr [ebp - local_10c]         # 00498b9a
    add eax, dword ptr [ebp - local_114]         # 00498ba0
    mov ecx, dword ptr [ebp - local_160]         # 00498ba6
    mov dx, word ptr [eax]                       # 00498bac
    mov word ptr [ecx], dx                       # 00498baf
    mov eax, dword ptr [ebp - local_120]         # 00498bb2
    sub eax, dword ptr [ebp - local_118]         # 00498bb8
    mov dword ptr [ebp - local_120], eax         # 00498bbe
    mov ecx, dword ptr [ebp - local_288]         # 00498bc4
    mov edx, dword ptr [ebp - local_160]         # 00498bca
    sub edx, dword ptr [ecx + field_1fff]        # 00498bd0
    mov dword ptr [ebp - local_160], edx         # 00498bd6
    mov eax, dword ptr [ebp - local_84]          # 00498bdc
    mov cl, byte ptr [ebp - local_b0]            # 00498be2
    mov byte ptr [eax], cl                       # 00498be8
    mov edx, dword ptr [ebp - local_84]          # 00498bea
    sub edx, 0x218                               # 00498bf0
    mov dword ptr [ebp - local_84], edx          # 00498bf6
    jmp.d8 L_00498c6d                            # 00498bfc
L_00498bfe:
    # block 0x00498bfe: entered by jb at 0x00498b77, 21 instruction(s), falls into the block at 0x00498c6d
    mov eax, dword ptr [ebp - local_114]         # 00498bfe
    shl eax                                      # 00498c04
    mov dword ptr [ebp - local_114], eax         # 00498c06
    mov ecx, dword ptr [ebp - local_13c]         # 00498c0c
    add ecx, dword ptr [ebp - local_114]         # 00498c12
    mov edx, dword ptr [ebp - local_160]         # 00498c18
    mov ax, word ptr [ecx]                       # 00498c1e
    mov word ptr [edx], ax                       # 00498c21
    mov ecx, dword ptr [ebp - local_120]         # 00498c24
    sub ecx, dword ptr [ebp - local_118]         # 00498c2a
    mov dword ptr [ebp - local_120], ecx         # 00498c30
    mov edx, dword ptr [ebp - local_288]         # 00498c36
    mov eax, dword ptr [ebp - local_160]         # 00498c3c
    sub eax, dword ptr [edx + field_1fff]        # 00498c42
    mov dword ptr [ebp - local_160], eax         # 00498c48
    mov ecx, dword ptr [ebp - local_84]          # 00498c4e
    mov dl, byte ptr [ebp - local_b0]            # 00498c54
    mov byte ptr [ecx], dl                       # 00498c5a
    mov eax, dword ptr [ebp - local_84]          # 00498c5c
    sub eax, 0x218                               # 00498c62
    mov dword ptr [ebp - local_84], eax          # 00498c67
L_00498c6d:
    # block 0x00498c6d: entered by jmp at 0x00498bfc, 1 instruction(s), ends with backward jump to 0x00498b3e
    jmp.d32 L_00498b3e                           # 00498c6d
L_00498c72:
    # block 0x00498c72: entered by jmp at 0x00498b30; jge at 0x00498b50, 1 instruction(s), ends with forward jump to 0x004991df
    jmp.d32 L_004991df                           # 00498c72
L_00498c77:
    # block 0x00498c77: entered by je at 0x0049869f, 5 instruction(s), ends with jne to 0x00498cc1 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00498c77
    {load} xor edx, edx                          # 00498c7d
    mov dl, byte ptr [ecx + field_50f0]          # 00498c7f
    test edx, edx                                # 00498c85
    jne.d8 L_00498cc1                            # 00498c87
    # block 0x00498c89: entered by fall-through of jne at 0x00498c87, 11 instruction(s), ends with forward jump to 0x00498cf7
    mov eax, dword ptr [ebp - local_94]          # 00498c89
    imul eax, eax, 0x154                         # 00498c8f
    mov ecx, dword ptr [ebp - local_288]         # 00498c95
    lea edx, [ecx + eax + field_2491]            # 00498c9b
    mov eax, dword ptr [ebp - local_288]         # 00498ca2
    {load} xor ecx, ecx                          # 00498ca8
    mov cl, byte ptr [eax + field_50ed]          # 00498caa
    mov edx, dword ptr [edx + 4*ecx]             # 00498cb0
    add edx, dword ptr [ebp - local_a8]          # 00498cb3
    mov dword ptr [ebp - local_10c], edx         # 00498cb9
    jmp.d8 L_00498cf7                            # 00498cbf
L_00498cc1:
    # block 0x00498cc1: entered by jne at 0x00498c87, 10 instruction(s), falls into the block at 0x00498cf7
    mov eax, dword ptr [ebp - local_94]          # 00498cc1
    imul eax, eax, 0xa0                          # 00498cc7
    mov ecx, dword ptr [ebp - local_288]         # 00498ccd
    lea edx, [ecx + eax + field_2f31]            # 00498cd3
    mov eax, dword ptr [ebp - local_288]         # 00498cda
    {load} xor ecx, ecx                          # 00498ce0
    mov cl, byte ptr [eax + field_50ed]          # 00498ce2
    mov edx, dword ptr [edx + 4*ecx]             # 00498ce8
    add edx, dword ptr [ebp - local_a8]          # 00498ceb
    mov dword ptr [ebp - local_10c], edx         # 00498cf1
L_00498cf7:
    # block 0x00498cf7: entered by jmp at 0x00498cbf, 5 instruction(s), ends with jne to 0x00498d3e (forward)
    mov eax, dword ptr [ebp - local_288]         # 00498cf7
    {load} xor ecx, ecx                          # 00498cfd
    mov cl, byte ptr [eax + field_50f1]          # 00498cff
    test ecx, ecx                                # 00498d05
    jne.d8 L_00498d3e                            # 00498d07
    # block 0x00498d09: entered by fall-through of jne at 0x00498d07, 11 instruction(s), ends with forward jump to 0x00498d71
    mov edx, dword ptr [ebp - local_30]          # 00498d09
    imul edx, edx, 0x154                         # 00498d0c
    mov eax, dword ptr [ebp - local_288]         # 00498d12
    lea ecx, [eax + edx + field_2491]            # 00498d18
    mov edx, dword ptr [ebp - local_288]         # 00498d1f
    {load} xor eax, eax                          # 00498d25
    mov al, byte ptr [edx + field_50ee]          # 00498d27
    mov ecx, dword ptr [ecx + 4*eax]             # 00498d2d
    add ecx, dword ptr [ebp - local_a8]          # 00498d30
    mov dword ptr [ebp - local_13c], ecx         # 00498d36
    jmp.d8 L_00498d71                            # 00498d3c
L_00498d3e:
    # block 0x00498d3e: entered by jne at 0x00498d07, 10 instruction(s), falls into the block at 0x00498d71
    mov edx, dword ptr [ebp - local_30]          # 00498d3e
    imul edx, edx, 0xa0                          # 00498d41
    mov eax, dword ptr [ebp - local_288]         # 00498d47
    lea ecx, [eax + edx + field_2f31]            # 00498d4d
    mov edx, dword ptr [ebp - local_288]         # 00498d54
    {load} xor eax, eax                          # 00498d5a
    mov al, byte ptr [edx + field_50ee]          # 00498d5c
    mov ecx, dword ptr [ecx + 4*eax]             # 00498d62
    add ecx, dword ptr [ebp - local_a8]          # 00498d65
    mov dword ptr [ebp - local_13c], ecx         # 00498d6b
L_00498d71:
    # block 0x00498d71: entered by jmp at 0x00498d3c, 5 instruction(s), ends with jne to 0x00498db5 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00498d71
    {load} xor eax, eax                          # 00498d77
    mov al, byte ptr [edx + field_50f2]          # 00498d79
    test eax, eax                                # 00498d7f
    jne.d8 L_00498db5                            # 00498d81
    # block 0x00498d83: entered by fall-through of jne at 0x00498d81, 11 instruction(s), ends with forward jump to 0x00498de5
    mov ecx, dword ptr [ebp - local_14]          # 00498d83
    imul ecx, ecx, 0x154                         # 00498d86
    mov edx, dword ptr [ebp - local_288]         # 00498d8c
    lea eax, [edx + ecx + field_2491]            # 00498d92
    mov ecx, dword ptr [ebp - local_288]         # 00498d99
    {load} xor edx, edx                          # 00498d9f
    mov dl, byte ptr [ecx + field_50ef]          # 00498da1
    mov eax, dword ptr [eax + 4*edx]             # 00498da7
    add eax, dword ptr [ebp - local_a8]          # 00498daa
    mov dword ptr [ebp - local_60], eax          # 00498db0
    jmp.d8 L_00498de5                            # 00498db3
L_00498db5:
    # block 0x00498db5: entered by jne at 0x00498d81, 10 instruction(s), falls into the block at 0x00498de5
    mov ecx, dword ptr [ebp - local_14]          # 00498db5
    imul ecx, ecx, 0xa0                          # 00498db8
    mov edx, dword ptr [ebp - local_288]         # 00498dbe
    lea eax, [edx + ecx + field_2f31]            # 00498dc4
    mov ecx, dword ptr [ebp - local_288]         # 00498dcb
    {load} xor edx, edx                          # 00498dd1
    mov dl, byte ptr [ecx + field_50ef]          # 00498dd3
    mov eax, dword ptr [eax + 4*edx]             # 00498dd9
    add eax, dword ptr [ebp - local_a8]          # 00498ddc
    mov dword ptr [ebp - local_60], eax          # 00498de2
L_00498de5:
    # block 0x00498de5: entered by jmp at 0x00498db3, 2 instruction(s), ends with je to 0x00499012 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 00498de5
    je.d32 L_00499012                            # 00498de9
    # block 0x00498def: entered by fall-through of je at 0x00498de9, 2 instruction(s), ends with forward jump to 0x00498e01
    mov dword ptr [ebp - local_74], 0x0          # 00498def
    jmp.d8 L_00498e01                            # 00498df6
L_00498df8:
    # block 0x00498df8: entered by jmp at 0x00499008, 3 instruction(s), falls into the block at 0x00498e01
    mov ecx, dword ptr [ebp - local_74]          # 00498df8
    add ecx, 0x1                                 # 00498dfb
    mov dword ptr [ebp - local_74], ecx          # 00498dfe
L_00498e01:
    # block 0x00498e01: entered by jmp at 0x00498df6, 3 instruction(s), ends with jge to 0x0049900d (forward)
    mov edx, dword ptr [ebp - local_74]          # 00498e01
    cmp edx, dword ptr [ebp - local_130]         # 00498e04
    jge.d32 L_0049900d                           # 00498e0a
    # block 0x00498e10: entered by fall-through of jge at 0x00498e0a, 6 instruction(s), ends with jb to 0x00498ecb (forward)
    mov eax, dword ptr [ebp - local_120]         # 00498e10
    shr eax, 0x10                                # 00498e16
    mov dword ptr [ebp - local_114], eax         # 00498e19
    mov ecx, dword ptr [ebp - local_114]         # 00498e1f
    cmp ecx, dword ptr [ebp - local_44]          # 00498e25
    jb.d32 L_00498ecb                            # 00498e28
    # block 0x00498e2e: entered by fall-through of jb at 0x00498e28, 7 instruction(s), ends with je to 0x00498e8b (forward)
    mov edx, dword ptr [ebp - local_84]          # 00498e2e
    {load} xor eax, eax                          # 00498e34
    mov al, byte ptr [edx]                       # 00498e36
    mov ecx, dword ptr [ebp - local_b0]          # 00498e38
    and ecx, 0xff                                # 00498e3e
    {load} cmp eax, ecx                          # 00498e44
    je.d8 L_00498e8b                             # 00498e46
    # block 0x00498e48: entered by fall-through of je at 0x00498e46, 14 instruction(s), falls into the block at 0x00498e8b
    mov edx, dword ptr [ebp - local_114]         # 00498e48
    and edx, 0x7f                                # 00498e4e
    mov dword ptr [ebp - local_114], edx         # 00498e51
    mov eax, dword ptr [ebp - local_114]         # 00498e57
    shl eax                                      # 00498e5d
    mov dword ptr [ebp - local_114], eax         # 00498e5f
    mov ecx, dword ptr [ebp - local_10c]         # 00498e65
    add ecx, dword ptr [ebp - local_114]         # 00498e6b
    mov edx, dword ptr [ebp - local_160]         # 00498e71
    mov ax, word ptr [ecx]                       # 00498e77
    mov word ptr [edx], ax                       # 00498e7a
    mov ecx, dword ptr [ebp - local_84]          # 00498e7d
    mov dl, byte ptr [ebp - local_b0]            # 00498e83
    mov byte ptr [ecx], dl                       # 00498e89
L_00498e8b:
    # block 0x00498e8b: entered by je at 0x00498e46, 11 instruction(s), ends with forward jump to 0x00499008
    mov eax, dword ptr [ebp - local_120]         # 00498e8b
    sub eax, dword ptr [ebp - local_118]         # 00498e91
    mov dword ptr [ebp - local_120], eax         # 00498e97
    mov ecx, dword ptr [ebp - local_288]         # 00498e9d
    mov edx, dword ptr [ebp - local_160]         # 00498ea3
    sub edx, dword ptr [ecx + field_1fff]        # 00498ea9
    mov dword ptr [ebp - local_160], edx         # 00498eaf
    mov eax, dword ptr [ebp - local_84]          # 00498eb5
    sub eax, 0x218                               # 00498ebb
    mov dword ptr [ebp - local_84], eax          # 00498ec0
    jmp.d32 L_00499008                           # 00498ec6
L_00498ecb:
    # block 0x00498ecb: entered by jb at 0x00498e28, 4 instruction(s), ends with jb to 0x00498f81 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00498ecb
    mov edx, dword ptr [ebp - local_114]         # 00498ed1
    cmp edx, dword ptr [ecx + field_45b1]        # 00498ed7
    jb.d32 L_00498f81                            # 00498edd
    # block 0x00498ee3: entered by fall-through of jb at 0x00498edd, 7 instruction(s), ends with je to 0x00498f40 (forward)
    mov eax, dword ptr [ebp - local_84]          # 00498ee3
    {load} xor ecx, ecx                          # 00498ee9
    mov cl, byte ptr [eax]                       # 00498eeb
    mov edx, dword ptr [ebp - local_b0]          # 00498eed
    and edx, 0xff                                # 00498ef3
    {load} cmp ecx, edx                          # 00498ef9
    je.d8 L_00498f40                             # 00498efb
    # block 0x00498efd: entered by fall-through of je at 0x00498efb, 14 instruction(s), falls into the block at 0x00498f40
    mov eax, dword ptr [ebp - local_114]         # 00498efd
    and eax, 0x7f                                # 00498f03
    mov dword ptr [ebp - local_114], eax         # 00498f06
    mov ecx, dword ptr [ebp - local_114]         # 00498f0c
    shl ecx                                      # 00498f12
    mov dword ptr [ebp - local_114], ecx         # 00498f14
    mov edx, dword ptr [ebp - local_13c]         # 00498f1a
    add edx, dword ptr [ebp - local_114]         # 00498f20
    mov eax, dword ptr [ebp - local_160]         # 00498f26
    mov cx, word ptr [edx]                       # 00498f2c
    mov word ptr [eax], cx                       # 00498f2f
    mov edx, dword ptr [ebp - local_84]          # 00498f32
    mov al, byte ptr [ebp - local_b0]            # 00498f38
    mov byte ptr [edx], al                       # 00498f3e
L_00498f40:
    # block 0x00498f40: entered by je at 0x00498efb, 11 instruction(s), ends with forward jump to 0x00499008
    mov ecx, dword ptr [ebp - local_120]         # 00498f40
    sub ecx, dword ptr [ebp - local_118]         # 00498f46
    mov dword ptr [ebp - local_120], ecx         # 00498f4c
    mov edx, dword ptr [ebp - local_288]         # 00498f52
    mov eax, dword ptr [ebp - local_160]         # 00498f58
    sub eax, dword ptr [edx + field_1fff]        # 00498f5e
    mov dword ptr [ebp - local_160], eax         # 00498f64
    mov ecx, dword ptr [ebp - local_84]          # 00498f6a
    sub ecx, 0x218                               # 00498f70
    mov dword ptr [ebp - local_84], ecx          # 00498f76
    jmp.d32 L_00499008                           # 00498f7c
L_00498f81:
    # block 0x00498f81: entered by jb at 0x00498edd, 7 instruction(s), ends with je to 0x00498fcc (forward)
    mov edx, dword ptr [ebp - local_84]          # 00498f81
    {load} xor eax, eax                          # 00498f87
    mov al, byte ptr [edx]                       # 00498f89
    mov ecx, dword ptr [ebp - local_b0]          # 00498f8b
    and ecx, 0xff                                # 00498f91
    {load} cmp eax, ecx                          # 00498f97
    je.d8 L_00498fcc                             # 00498f99
    # block 0x00498f9b: entered by fall-through of je at 0x00498f99, 11 instruction(s), falls into the block at 0x00498fcc
    mov edx, dword ptr [ebp - local_114]         # 00498f9b
    shl edx                                      # 00498fa1
    mov dword ptr [ebp - local_114], edx         # 00498fa3
    mov eax, dword ptr [ebp - local_60]          # 00498fa9
    add eax, dword ptr [ebp - local_114]         # 00498fac
    mov ecx, dword ptr [ebp - local_160]         # 00498fb2
    mov dx, word ptr [eax]                       # 00498fb8
    mov word ptr [ecx], dx                       # 00498fbb
    mov eax, dword ptr [ebp - local_84]          # 00498fbe
    mov cl, byte ptr [ebp - local_b0]            # 00498fc4
    mov byte ptr [eax], cl                       # 00498fca
L_00498fcc:
    # block 0x00498fcc: entered by je at 0x00498f99, 10 instruction(s), falls into the block at 0x00499008
    mov edx, dword ptr [ebp - local_120]         # 00498fcc
    sub edx, dword ptr [ebp - local_118]         # 00498fd2
    mov dword ptr [ebp - local_120], edx         # 00498fd8
    mov eax, dword ptr [ebp - local_288]         # 00498fde
    mov ecx, dword ptr [ebp - local_160]         # 00498fe4
    sub ecx, dword ptr [eax + field_1fff]        # 00498fea
    mov dword ptr [ebp - local_160], ecx         # 00498ff0
    mov edx, dword ptr [ebp - local_84]          # 00498ff6
    sub edx, 0x218                               # 00498ffc
    mov dword ptr [ebp - local_84], edx          # 00499002
L_00499008:
    # block 0x00499008: entered by jmp at 0x00498ec6; jmp at 0x00498f7c, 1 instruction(s), ends with backward jump to 0x00498df8
    jmp.d32 L_00498df8                           # 00499008
L_0049900d:
    # block 0x0049900d: entered by jge at 0x00498e0a, 1 instruction(s), ends with forward jump to 0x004991df
    jmp.d32 L_004991df                           # 0049900d
L_00499012:
    # block 0x00499012: entered by je at 0x00498de9, 2 instruction(s), ends with forward jump to 0x00499024
    mov dword ptr [ebp - local_74], 0x0          # 00499012
    jmp.d8 L_00499024                            # 00499019
L_0049901b:
    # block 0x0049901b: entered by jmp at 0x004991da, 3 instruction(s), falls into the block at 0x00499024
    mov eax, dword ptr [ebp - local_74]          # 0049901b
    add eax, 0x1                                 # 0049901e
    mov dword ptr [ebp - local_74], eax          # 00499021
L_00499024:
    # block 0x00499024: entered by jmp at 0x00499019, 3 instruction(s), ends with jge to 0x004991df (forward)
    mov ecx, dword ptr [ebp - local_74]          # 00499024
    cmp ecx, dword ptr [ebp - local_130]         # 00499027
    jge.d32 L_004991df                           # 0049902d
    # block 0x00499033: entered by fall-through of jge at 0x0049902d, 6 instruction(s), ends with jb to 0x004990d5 (forward)
    mov edx, dword ptr [ebp - local_120]         # 00499033
    shr edx, 0x10                                # 00499039
    mov dword ptr [ebp - local_114], edx         # 0049903c
    mov eax, dword ptr [ebp - local_114]         # 00499042
    cmp eax, dword ptr [ebp - local_44]          # 00499048
    jb.d32 L_004990d5                            # 0049904b
    # block 0x00499051: entered by fall-through of jb at 0x0049904b, 25 instruction(s), ends with forward jump to 0x004991da
    mov ecx, dword ptr [ebp - local_114]         # 00499051
    and ecx, 0x7f                                # 00499057
    mov dword ptr [ebp - local_114], ecx         # 0049905a
    mov edx, dword ptr [ebp - local_114]         # 00499060
    shl edx                                      # 00499066
    mov dword ptr [ebp - local_114], edx         # 00499068
    mov eax, dword ptr [ebp - local_10c]         # 0049906e
    add eax, dword ptr [ebp - local_114]         # 00499074
    mov ecx, dword ptr [ebp - local_160]         # 0049907a
    mov dx, word ptr [eax]                       # 00499080
    mov word ptr [ecx], dx                       # 00499083
    mov eax, dword ptr [ebp - local_120]         # 00499086
    sub eax, dword ptr [ebp - local_118]         # 0049908c
    mov dword ptr [ebp - local_120], eax         # 00499092
    mov ecx, dword ptr [ebp - local_288]         # 00499098
    mov edx, dword ptr [ebp - local_160]         # 0049909e
    sub edx, dword ptr [ecx + field_1fff]        # 004990a4
    mov dword ptr [ebp - local_160], edx         # 004990aa
    mov eax, dword ptr [ebp - local_84]          # 004990b0
    mov cl, byte ptr [ebp - local_b0]            # 004990b6
    mov byte ptr [eax], cl                       # 004990bc
    mov edx, dword ptr [ebp - local_84]          # 004990be
    sub edx, 0x218                               # 004990c4
    mov dword ptr [ebp - local_84], edx          # 004990ca
    jmp.d32 L_004991da                           # 004990d0
L_004990d5:
    # block 0x004990d5: entered by jb at 0x0049904b, 4 instruction(s), ends with jb to 0x0049916d (forward)
    mov eax, dword ptr [ebp - local_288]         # 004990d5
    mov ecx, dword ptr [ebp - local_114]         # 004990db
    cmp ecx, dword ptr [eax + field_45b1]        # 004990e1
    jb.d32 L_0049916d                            # 004990e7
    # block 0x004990ed: entered by fall-through of jb at 0x004990e7, 25 instruction(s), ends with forward jump to 0x004991da
    mov edx, dword ptr [ebp - local_114]         # 004990ed
    and edx, 0x7f                                # 004990f3
    mov dword ptr [ebp - local_114], edx         # 004990f6
    mov eax, dword ptr [ebp - local_114]         # 004990fc
    shl eax                                      # 00499102
    mov dword ptr [ebp - local_114], eax         # 00499104
    mov ecx, dword ptr [ebp - local_13c]         # 0049910a
    add ecx, dword ptr [ebp - local_114]         # 00499110
    mov edx, dword ptr [ebp - local_160]         # 00499116
    mov ax, word ptr [ecx]                       # 0049911c
    mov word ptr [edx], ax                       # 0049911f
    mov ecx, dword ptr [ebp - local_120]         # 00499122
    sub ecx, dword ptr [ebp - local_118]         # 00499128
    mov dword ptr [ebp - local_120], ecx         # 0049912e
    mov edx, dword ptr [ebp - local_288]         # 00499134
    mov eax, dword ptr [ebp - local_160]         # 0049913a
    sub eax, dword ptr [edx + field_1fff]        # 00499140
    mov dword ptr [ebp - local_160], eax         # 00499146
    mov ecx, dword ptr [ebp - local_84]          # 0049914c
    mov dl, byte ptr [ebp - local_b0]            # 00499152
    mov byte ptr [ecx], dl                       # 00499158
    mov eax, dword ptr [ebp - local_84]          # 0049915a
    sub eax, 0x218                               # 00499160
    mov dword ptr [ebp - local_84], eax          # 00499165
    jmp.d8 L_004991da                            # 0049916b
L_0049916d:
    # block 0x0049916d: entered by jb at 0x004990e7, 21 instruction(s), falls into the block at 0x004991da
    mov ecx, dword ptr [ebp - local_114]         # 0049916d
    shl ecx                                      # 00499173
    mov dword ptr [ebp - local_114], ecx         # 00499175
    mov edx, dword ptr [ebp - local_60]          # 0049917b
    add edx, dword ptr [ebp - local_114]         # 0049917e
    mov eax, dword ptr [ebp - local_160]         # 00499184
    mov cx, word ptr [edx]                       # 0049918a
    mov word ptr [eax], cx                       # 0049918d
    mov edx, dword ptr [ebp - local_120]         # 00499190
    sub edx, dword ptr [ebp - local_118]         # 00499196
    mov dword ptr [ebp - local_120], edx         # 0049919c
    mov eax, dword ptr [ebp - local_288]         # 004991a2
    mov ecx, dword ptr [ebp - local_160]         # 004991a8
    sub ecx, dword ptr [eax + field_1fff]        # 004991ae
    mov dword ptr [ebp - local_160], ecx         # 004991b4
    mov edx, dword ptr [ebp - local_84]          # 004991ba
    mov al, byte ptr [ebp - local_b0]            # 004991c0
    mov byte ptr [edx], al                       # 004991c6
    mov ecx, dword ptr [ebp - local_84]          # 004991c8
    sub ecx, 0x218                               # 004991ce
    mov dword ptr [ebp - local_84], ecx          # 004991d4
L_004991da:
    # block 0x004991da: entered by jmp at 0x004990d0; jmp at 0x0049916b, 1 instruction(s), ends with backward jump to 0x0049901b
    jmp.d32 L_0049901b                           # 004991da
L_004991df:
    # block 0x004991df: entered by jmp at 0x004988b4; jmp at 0x00498c72; jmp at 0x0049900d; jge at 0x0049902d, 1 instruction(s), ends with forward jump to 0x0049b97e
    jmp.d32 L_0049b97e                           # 004991df
L_004991e4:
    # block 0x004991e4: entered by jne at 0x00498659; jne at 0x00498673, 5 instruction(s), ends with je to 0x00499e5c (forward)
    mov edx, dword ptr [ebp - local_288]         # 004991e4
    mov eax, dword ptr [edx + field_50e9]        # 004991ea
    and eax, 0x10000000                          # 004991f0
    test eax, eax                                # 004991f5
    je.d32 L_00499e5c                            # 004991f7
    # block 0x004991fd: entered by fall-through of je at 0x004991f7, 5 instruction(s), ends with jne to 0x00499e5c (forward)
    mov ecx, dword ptr [ebp - local_288]         # 004991fd
    mov edx, dword ptr [ecx + field_50e9]        # 00499203
    and edx, 0x20000000                          # 00499209
    test edx, edx                                # 0049920f
    jne.d32 L_00499e5c                           # 00499211
    # block 0x00499217: entered by fall-through of jne at 0x00499211, 5 instruction(s), ends with je to 0x0049947b (forward)
    mov eax, dword ptr [ebp - local_288]         # 00499217
    mov ecx, dword ptr [eax + field_1f27]        # 0049921d
    mov dword ptr [ebp - local_320], ecx         # 00499223
    cmp dword ptr [ebp - local_320], 0x2         # 00499229
    je.d32 L_0049947b                            # 00499230
    # block 0x00499236: entered by fall-through of je at 0x00499230, 2 instruction(s), ends with je to 0x00499883 (forward)
    cmp dword ptr [ebp - local_320], 0x3         # 00499236
    je.d32 L_00499883                            # 0049923d
    # block 0x00499243: entered by fall-through of je at 0x0049923d, 5 instruction(s), ends with jne to 0x0049928d (forward)
    mov edx, dword ptr [ebp - local_288]         # 00499243
    {load} xor eax, eax                          # 00499249
    mov al, byte ptr [edx + field_50f0]          # 0049924b
    test eax, eax                                # 00499251
    jne.d8 L_0049928d                            # 00499253
    # block 0x00499255: entered by fall-through of jne at 0x00499253, 11 instruction(s), ends with forward jump to 0x004992c3
    mov ecx, dword ptr [ebp - local_94]          # 00499255
    imul ecx, ecx, 0x154                         # 0049925b
    mov edx, dword ptr [ebp - local_288]         # 00499261
    lea eax, [edx + ecx + field_2491]            # 00499267
    mov ecx, dword ptr [ebp - local_288]         # 0049926e
    {load} xor edx, edx                          # 00499274
    mov dl, byte ptr [ecx + field_50ed]          # 00499276
    mov eax, dword ptr [eax + 4*edx]             # 0049927c
    add eax, dword ptr [ebp - local_a8]          # 0049927f
    mov dword ptr [ebp - local_88], eax          # 00499285
    jmp.d8 L_004992c3                            # 0049928b
L_0049928d:
    # block 0x0049928d: entered by jne at 0x00499253, 10 instruction(s), falls into the block at 0x004992c3
    mov ecx, dword ptr [ebp - local_94]          # 0049928d
    imul ecx, ecx, 0xa0                          # 00499293
    mov edx, dword ptr [ebp - local_288]         # 00499299
    lea eax, [edx + ecx + field_2f31]            # 0049929f
    mov ecx, dword ptr [ebp - local_288]         # 004992a6
    {load} xor edx, edx                          # 004992ac
    mov dl, byte ptr [ecx + field_50ed]          # 004992ae
    mov eax, dword ptr [eax + 4*edx]             # 004992b4
    add eax, dword ptr [ebp - local_a8]          # 004992b7
    mov dword ptr [ebp - local_88], eax          # 004992bd
L_004992c3:
    # block 0x004992c3: entered by jmp at 0x0049928b, 2 instruction(s), ends with je to 0x004993b1 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004992c3
    je.d32 L_004993b1                            # 004992c7
    # block 0x004992cd: entered by fall-through of je at 0x004992c7, 2 instruction(s), ends with forward jump to 0x004992df
    mov dword ptr [ebp - local_74], 0x0          # 004992cd
    jmp.d8 L_004992df                            # 004992d4
L_004992d6:
    # block 0x004992d6: entered by jmp at 0x004993a7, 3 instruction(s), falls into the block at 0x004992df
    mov ecx, dword ptr [ebp - local_74]          # 004992d6
    add ecx, 0x1                                 # 004992d9
    mov dword ptr [ebp - local_74], ecx          # 004992dc
L_004992df:
    # block 0x004992df: entered by jmp at 0x004992d4, 3 instruction(s), ends with jge to 0x004993ac (forward)
    mov edx, dword ptr [ebp - local_74]          # 004992df
    cmp edx, dword ptr [ebp - local_130]         # 004992e2
    jge.d32 L_004993ac                           # 004992e8
    # block 0x004992ee: entered by fall-through of jge at 0x004992e8, 5 instruction(s), ends with je to 0x0049935d (forward)
    mov eax, dword ptr [ebp - local_288]         # 004992ee
    {load} xor ecx, ecx                          # 004992f4
    mov cl, byte ptr [eax + field_50ed]          # 004992f6
    test ecx, ecx                                # 004992fc
    je.d8 L_0049935d                             # 004992fe
    # block 0x00499300: entered by fall-through of je at 0x004992fe, 7 instruction(s), ends with je to 0x0049935d (forward)
    mov edx, dword ptr [ebp - local_84]          # 00499300
    {load} xor eax, eax                          # 00499306
    mov al, byte ptr [edx]                       # 00499308
    mov ecx, dword ptr [ebp - local_b0]          # 0049930a
    and ecx, 0xff                                # 00499310
    {load} cmp eax, ecx                          # 00499316
    je.d8 L_0049935d                             # 00499318
    # block 0x0049931a: entered by fall-through of je at 0x00499318, 14 instruction(s), falls into the block at 0x0049935d
    mov edx, dword ptr [ebp - local_120]         # 0049931a
    shr edx, 0x10                                # 00499320
    mov dword ptr [ebp - local_114], edx         # 00499323
    mov eax, dword ptr [ebp - local_114]         # 00499329
    shl eax                                      # 0049932f
    mov dword ptr [ebp - local_114], eax         # 00499331
    mov ecx, dword ptr [ebp - local_88]          # 00499337
    add ecx, dword ptr [ebp - local_114]         # 0049933d
    mov edx, dword ptr [ebp - local_160]         # 00499343
    mov ax, word ptr [ecx]                       # 00499349
    mov word ptr [edx], ax                       # 0049934c
    mov ecx, dword ptr [ebp - local_84]          # 0049934f
    mov dl, byte ptr [ebp - local_b0]            # 00499355
    mov byte ptr [ecx], dl                       # 0049935b
L_0049935d:
    # block 0x0049935d: entered by je at 0x004992fe; je at 0x00499318, 3 instruction(s), ends with jbe to 0x0049937d (forward)
    mov eax, dword ptr [ebp - local_120]         # 0049935d
    cmp eax, dword ptr [ebp - local_118]         # 00499363
    jbe.d8 L_0049937d                            # 00499369
    # block 0x0049936b: entered by fall-through of jbe at 0x00499369, 3 instruction(s), falls into the block at 0x0049937d
    mov ecx, dword ptr [ebp - local_120]         # 0049936b
    sub ecx, dword ptr [ebp - local_118]         # 00499371
    mov dword ptr [ebp - local_120], ecx         # 00499377
L_0049937d:
    # block 0x0049937d: entered by jbe at 0x00499369, 8 instruction(s), ends with backward jump to 0x004992d6
    mov edx, dword ptr [ebp - local_288]         # 0049937d
    mov eax, dword ptr [ebp - local_160]         # 00499383
    sub eax, dword ptr [edx + field_1fff]        # 00499389
    mov dword ptr [ebp - local_160], eax         # 0049938f
    mov ecx, dword ptr [ebp - local_84]          # 00499395
    sub ecx, 0x218                               # 0049939b
    mov dword ptr [ebp - local_84], ecx          # 004993a1
    jmp.d32 L_004992d6                           # 004993a7
L_004993ac:
    # block 0x004993ac: entered by jge at 0x004992e8, 1 instruction(s), ends with forward jump to 0x00499476
    jmp.d32 L_00499476                           # 004993ac
L_004993b1:
    # block 0x004993b1: entered by je at 0x004992c7, 2 instruction(s), ends with forward jump to 0x004993c3
    mov dword ptr [ebp - local_74], 0x0          # 004993b1
    jmp.d8 L_004993c3                            # 004993b8
L_004993ba:
    # block 0x004993ba: entered by jmp at 0x00499471, 3 instruction(s), falls into the block at 0x004993c3
    mov edx, dword ptr [ebp - local_74]          # 004993ba
    add edx, 0x1                                 # 004993bd
    mov dword ptr [ebp - local_74], edx          # 004993c0
L_004993c3:
    # block 0x004993c3: entered by jmp at 0x004993b8, 3 instruction(s), ends with jge to 0x00499476 (forward)
    mov eax, dword ptr [ebp - local_74]          # 004993c3
    cmp eax, dword ptr [ebp - local_130]         # 004993c6
    jge.d32 L_00499476                           # 004993cc
    # block 0x004993d2: entered by fall-through of jge at 0x004993cc, 5 instruction(s), ends with je to 0x00499427 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 004993d2
    {load} xor edx, edx                          # 004993d8
    mov dl, byte ptr [ecx + field_50ed]          # 004993da
    test edx, edx                                # 004993e0
    je.d8 L_00499427                             # 004993e2
    # block 0x004993e4: entered by fall-through of je at 0x004993e2, 14 instruction(s), falls into the block at 0x00499427
    mov eax, dword ptr [ebp - local_120]         # 004993e4
    shr eax, 0x10                                # 004993ea
    mov dword ptr [ebp - local_114], eax         # 004993ed
    mov ecx, dword ptr [ebp - local_114]         # 004993f3
    shl ecx                                      # 004993f9
    mov dword ptr [ebp - local_114], ecx         # 004993fb
    mov edx, dword ptr [ebp - local_88]          # 00499401
    add edx, dword ptr [ebp - local_114]         # 00499407
    mov eax, dword ptr [ebp - local_160]         # 0049940d
    mov cx, word ptr [edx]                       # 00499413
    mov word ptr [eax], cx                       # 00499416
    mov edx, dword ptr [ebp - local_84]          # 00499419
    mov al, byte ptr [ebp - local_b0]            # 0049941f
    mov byte ptr [edx], al                       # 00499425
L_00499427:
    # block 0x00499427: entered by je at 0x004993e2, 3 instruction(s), ends with jbe to 0x00499447 (forward)
    mov ecx, dword ptr [ebp - local_120]         # 00499427
    cmp ecx, dword ptr [ebp - local_118]         # 0049942d
    jbe.d8 L_00499447                            # 00499433
    # block 0x00499435: entered by fall-through of jbe at 0x00499433, 3 instruction(s), falls into the block at 0x00499447
    mov edx, dword ptr [ebp - local_120]         # 00499435
    sub edx, dword ptr [ebp - local_118]         # 0049943b
    mov dword ptr [ebp - local_120], edx         # 00499441
L_00499447:
    # block 0x00499447: entered by jbe at 0x00499433, 8 instruction(s), ends with backward jump to 0x004993ba
    mov eax, dword ptr [ebp - local_288]         # 00499447
    mov ecx, dword ptr [ebp - local_160]         # 0049944d
    sub ecx, dword ptr [eax + field_1fff]        # 00499453
    mov dword ptr [ebp - local_160], ecx         # 00499459
    mov edx, dword ptr [ebp - local_84]          # 0049945f
    sub edx, 0x218                               # 00499465
    mov dword ptr [ebp - local_84], edx          # 0049946b
    jmp.d32 L_004993ba                           # 00499471
L_00499476:
    # block 0x00499476: entered by jmp at 0x004993ac; jge at 0x004993cc, 1 instruction(s), ends with forward jump to 0x00499e57
    jmp.d32 L_00499e57                           # 00499476
L_0049947b:
    # block 0x0049947b: entered by je at 0x00499230, 5 instruction(s), ends with jne to 0x004994c5 (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049947b
    {load} xor ecx, ecx                          # 00499481
    mov cl, byte ptr [eax + field_50f0]          # 00499483
    test ecx, ecx                                # 00499489
    jne.d8 L_004994c5                            # 0049948b
    # block 0x0049948d: entered by fall-through of jne at 0x0049948b, 11 instruction(s), ends with forward jump to 0x004994fb
    mov edx, dword ptr [ebp - local_94]          # 0049948d
    imul edx, edx, 0x154                         # 00499493
    mov eax, dword ptr [ebp - local_288]         # 00499499
    lea ecx, [eax + edx + field_2491]            # 0049949f
    mov edx, dword ptr [ebp - local_288]         # 004994a6
    {load} xor eax, eax                          # 004994ac
    mov al, byte ptr [edx + field_50ed]          # 004994ae
    mov ecx, dword ptr [ecx + 4*eax]             # 004994b4
    add ecx, dword ptr [ebp - local_a8]          # 004994b7
    mov dword ptr [ebp - local_10c], ecx         # 004994bd
    jmp.d8 L_004994fb                            # 004994c3
L_004994c5:
    # block 0x004994c5: entered by jne at 0x0049948b, 10 instruction(s), falls into the block at 0x004994fb
    mov edx, dword ptr [ebp - local_94]          # 004994c5
    imul edx, edx, 0xa0                          # 004994cb
    mov eax, dword ptr [ebp - local_288]         # 004994d1
    lea ecx, [eax + edx + field_2f31]            # 004994d7
    mov edx, dword ptr [ebp - local_288]         # 004994de
    {load} xor eax, eax                          # 004994e4
    mov al, byte ptr [edx + field_50ed]          # 004994e6
    mov ecx, dword ptr [ecx + 4*eax]             # 004994ec
    add ecx, dword ptr [ebp - local_a8]          # 004994ef
    mov dword ptr [ebp - local_10c], ecx         # 004994f5
L_004994fb:
    # block 0x004994fb: entered by jmp at 0x004994c3, 5 instruction(s), ends with jne to 0x00499542 (forward)
    mov edx, dword ptr [ebp - local_288]         # 004994fb
    {load} xor eax, eax                          # 00499501
    mov al, byte ptr [edx + field_50f1]          # 00499503
    test eax, eax                                # 00499509
    jne.d8 L_00499542                            # 0049950b
    # block 0x0049950d: entered by fall-through of jne at 0x0049950b, 11 instruction(s), ends with forward jump to 0x00499575
    mov ecx, dword ptr [ebp - local_30]          # 0049950d
    imul ecx, ecx, 0x154                         # 00499510
    mov edx, dword ptr [ebp - local_288]         # 00499516
    lea eax, [edx + ecx + field_2491]            # 0049951c
    mov ecx, dword ptr [ebp - local_288]         # 00499523
    {load} xor edx, edx                          # 00499529
    mov dl, byte ptr [ecx + field_50ee]          # 0049952b
    mov eax, dword ptr [eax + 4*edx]             # 00499531
    add eax, dword ptr [ebp - local_a8]          # 00499534
    mov dword ptr [ebp - local_13c], eax         # 0049953a
    jmp.d8 L_00499575                            # 00499540
L_00499542:
    # block 0x00499542: entered by jne at 0x0049950b, 10 instruction(s), falls into the block at 0x00499575
    mov ecx, dword ptr [ebp - local_30]          # 00499542
    imul ecx, ecx, 0xa0                          # 00499545
    mov edx, dword ptr [ebp - local_288]         # 0049954b
    lea eax, [edx + ecx + field_2f31]            # 00499551
    mov ecx, dword ptr [ebp - local_288]         # 00499558
    {load} xor edx, edx                          # 0049955e
    mov dl, byte ptr [ecx + field_50ee]          # 00499560
    mov eax, dword ptr [eax + 4*edx]             # 00499566
    add eax, dword ptr [ebp - local_a8]          # 00499569
    mov dword ptr [ebp - local_13c], eax         # 0049956f
L_00499575:
    # block 0x00499575: entered by jmp at 0x00499540, 2 instruction(s), ends with je to 0x0049971b (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 00499575
    je.d32 L_0049971b                            # 00499579
    # block 0x0049957f: entered by fall-through of je at 0x00499579, 2 instruction(s), ends with forward jump to 0x00499591
    mov dword ptr [ebp - local_74], 0x0          # 0049957f
    jmp.d8 L_00499591                            # 00499586
L_00499588:
    # block 0x00499588: entered by jmp at 0x00499711, 3 instruction(s), falls into the block at 0x00499591
    mov ecx, dword ptr [ebp - local_74]          # 00499588
    add ecx, 0x1                                 # 0049958b
    mov dword ptr [ebp - local_74], ecx          # 0049958e
L_00499591:
    # block 0x00499591: entered by jmp at 0x00499586, 3 instruction(s), ends with jge to 0x00499716 (forward)
    mov edx, dword ptr [ebp - local_74]          # 00499591
    cmp edx, dword ptr [ebp - local_130]         # 00499594
    jge.d32 L_00499716                           # 0049959a
    # block 0x004995a0: entered by fall-through of jge at 0x0049959a, 7 instruction(s), ends with jb to 0x00499676 (forward)
    mov eax, dword ptr [ebp - local_120]         # 004995a0
    shr eax, 0x10                                # 004995a6
    mov dword ptr [ebp - local_114], eax         # 004995a9
    mov ecx, dword ptr [ebp - local_288]         # 004995af
    mov edx, dword ptr [ebp - local_114]         # 004995b5
    cmp edx, dword ptr [ecx + field_45b1]        # 004995bb
    jb.d32 L_00499676                            # 004995c1
    # block 0x004995c7: entered by fall-through of jb at 0x004995c1, 5 instruction(s), ends with je to 0x00499636 (forward)
    mov eax, dword ptr [ebp - local_288]         # 004995c7
    {load} xor ecx, ecx                          # 004995cd
    mov cl, byte ptr [eax + field_50ed]          # 004995cf
    test ecx, ecx                                # 004995d5
    je.d8 L_00499636                             # 004995d7
    # block 0x004995d9: entered by fall-through of je at 0x004995d7, 7 instruction(s), ends with je to 0x00499636 (forward)
    mov edx, dword ptr [ebp - local_84]          # 004995d9
    {load} xor eax, eax                          # 004995df
    mov al, byte ptr [edx]                       # 004995e1
    mov ecx, dword ptr [ebp - local_b0]          # 004995e3
    and ecx, 0xff                                # 004995e9
    {load} cmp eax, ecx                          # 004995ef
    je.d8 L_00499636                             # 004995f1
    # block 0x004995f3: entered by fall-through of je at 0x004995f1, 14 instruction(s), falls into the block at 0x00499636
    mov edx, dword ptr [ebp - local_114]         # 004995f3
    and edx, 0x7f                                # 004995f9
    mov dword ptr [ebp - local_114], edx         # 004995fc
    mov eax, dword ptr [ebp - local_114]         # 00499602
    shl eax                                      # 00499608
    mov dword ptr [ebp - local_114], eax         # 0049960a
    mov ecx, dword ptr [ebp - local_10c]         # 00499610
    add ecx, dword ptr [ebp - local_114]         # 00499616
    mov edx, dword ptr [ebp - local_160]         # 0049961c
    mov ax, word ptr [ecx]                       # 00499622
    mov word ptr [edx], ax                       # 00499625
    mov ecx, dword ptr [ebp - local_84]          # 00499628
    mov dl, byte ptr [ebp - local_b0]            # 0049962e
    mov byte ptr [ecx], dl                       # 00499634
L_00499636:
    # block 0x00499636: entered by je at 0x004995d7; je at 0x004995f1, 11 instruction(s), ends with forward jump to 0x00499711
    mov eax, dword ptr [ebp - local_120]         # 00499636
    sub eax, dword ptr [ebp - local_118]         # 0049963c
    mov dword ptr [ebp - local_120], eax         # 00499642
    mov ecx, dword ptr [ebp - local_288]         # 00499648
    mov edx, dword ptr [ebp - local_160]         # 0049964e
    sub edx, dword ptr [ecx + field_1fff]        # 00499654
    mov dword ptr [ebp - local_160], edx         # 0049965a
    mov eax, dword ptr [ebp - local_84]          # 00499660
    sub eax, 0x218                               # 00499666
    mov dword ptr [ebp - local_84], eax          # 0049966b
    jmp.d32 L_00499711                           # 00499671
L_00499676:
    # block 0x00499676: entered by jb at 0x004995c1, 5 instruction(s), ends with je to 0x004996d6 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00499676
    {load} xor edx, edx                          # 0049967c
    mov dl, byte ptr [ecx + field_50ee]          # 0049967e
    test edx, edx                                # 00499684
    je.d8 L_004996d6                             # 00499686
    # block 0x00499688: entered by fall-through of je at 0x00499686, 7 instruction(s), ends with je to 0x004996d6 (forward)
    mov eax, dword ptr [ebp - local_84]          # 00499688
    {load} xor ecx, ecx                          # 0049968e
    mov cl, byte ptr [eax]                       # 00499690
    mov edx, dword ptr [ebp - local_b0]          # 00499692
    and edx, 0xff                                # 00499698
    {load} cmp ecx, edx                          # 0049969e
    je.d8 L_004996d6                             # 004996a0
    # block 0x004996a2: entered by fall-through of je at 0x004996a0, 11 instruction(s), falls into the block at 0x004996d6
    mov eax, dword ptr [ebp - local_114]         # 004996a2
    shl eax                                      # 004996a8
    mov dword ptr [ebp - local_114], eax         # 004996aa
    mov ecx, dword ptr [ebp - local_13c]         # 004996b0
    add ecx, dword ptr [ebp - local_114]         # 004996b6
    mov edx, dword ptr [ebp - local_160]         # 004996bc
    mov ax, word ptr [ecx]                       # 004996c2
    mov word ptr [edx], ax                       # 004996c5
    mov ecx, dword ptr [ebp - local_84]          # 004996c8
    mov dl, byte ptr [ebp - local_b0]            # 004996ce
    mov byte ptr [ecx], dl                       # 004996d4
L_004996d6:
    # block 0x004996d6: entered by je at 0x00499686; je at 0x004996a0, 10 instruction(s), falls into the block at 0x00499711
    mov eax, dword ptr [ebp - local_120]         # 004996d6
    sub eax, dword ptr [ebp - local_118]         # 004996dc
    mov dword ptr [ebp - local_120], eax         # 004996e2
    mov ecx, dword ptr [ebp - local_288]         # 004996e8
    mov edx, dword ptr [ebp - local_160]         # 004996ee
    sub edx, dword ptr [ecx + field_1fff]        # 004996f4
    mov dword ptr [ebp - local_160], edx         # 004996fa
    mov eax, dword ptr [ebp - local_84]          # 00499700
    sub eax, 0x218                               # 00499706
    mov dword ptr [ebp - local_84], eax          # 0049970b
L_00499711:
    # block 0x00499711: entered by jmp at 0x00499671, 1 instruction(s), ends with backward jump to 0x00499588
    jmp.d32 L_00499588                           # 00499711
L_00499716:
    # block 0x00499716: entered by jge at 0x0049959a, 1 instruction(s), ends with forward jump to 0x0049987e
    jmp.d32 L_0049987e                           # 00499716
L_0049971b:
    # block 0x0049971b: entered by je at 0x00499579, 2 instruction(s), ends with forward jump to 0x0049972d
    mov dword ptr [ebp - local_74], 0x0          # 0049971b
    jmp.d8 L_0049972d                            # 00499722
L_00499724:
    # block 0x00499724: entered by jmp at 0x00499879, 3 instruction(s), falls into the block at 0x0049972d
    mov ecx, dword ptr [ebp - local_74]          # 00499724
    add ecx, 0x1                                 # 00499727
    mov dword ptr [ebp - local_74], ecx          # 0049972a
L_0049972d:
    # block 0x0049972d: entered by jmp at 0x00499722, 3 instruction(s), ends with jge to 0x0049987e (forward)
    mov edx, dword ptr [ebp - local_74]          # 0049972d
    cmp edx, dword ptr [ebp - local_130]         # 00499730
    jge.d32 L_0049987e                           # 00499736
    # block 0x0049973c: entered by fall-through of jge at 0x00499736, 7 instruction(s), ends with jb to 0x004997f8 (forward)
    mov eax, dword ptr [ebp - local_120]         # 0049973c
    shr eax, 0x10                                # 00499742
    mov dword ptr [ebp - local_114], eax         # 00499745
    mov ecx, dword ptr [ebp - local_288]         # 0049974b
    mov edx, dword ptr [ebp - local_114]         # 00499751
    cmp edx, dword ptr [ecx + field_45b1]        # 00499757
    jb.d32 L_004997f8                            # 0049975d
    # block 0x00499763: entered by fall-through of jb at 0x0049975d, 5 instruction(s), ends with je to 0x004997b8 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00499763
    {load} xor ecx, ecx                          # 00499769
    mov cl, byte ptr [eax + field_50ed]          # 0049976b
    test ecx, ecx                                # 00499771
    je.d8 L_004997b8                             # 00499773
    # block 0x00499775: entered by fall-through of je at 0x00499773, 14 instruction(s), falls into the block at 0x004997b8
    mov edx, dword ptr [ebp - local_114]         # 00499775
    and edx, 0x7f                                # 0049977b
    mov dword ptr [ebp - local_114], edx         # 0049977e
    mov eax, dword ptr [ebp - local_114]         # 00499784
    shl eax                                      # 0049978a
    mov dword ptr [ebp - local_114], eax         # 0049978c
    mov ecx, dword ptr [ebp - local_10c]         # 00499792
    add ecx, dword ptr [ebp - local_114]         # 00499798
    mov edx, dword ptr [ebp - local_160]         # 0049979e
    mov ax, word ptr [ecx]                       # 004997a4
    mov word ptr [edx], ax                       # 004997a7
    mov ecx, dword ptr [ebp - local_84]          # 004997aa
    mov dl, byte ptr [ebp - local_b0]            # 004997b0
    mov byte ptr [ecx], dl                       # 004997b6
L_004997b8:
    # block 0x004997b8: entered by je at 0x00499773, 11 instruction(s), ends with forward jump to 0x00499879
    mov eax, dword ptr [ebp - local_120]         # 004997b8
    sub eax, dword ptr [ebp - local_118]         # 004997be
    mov dword ptr [ebp - local_120], eax         # 004997c4
    mov ecx, dword ptr [ebp - local_288]         # 004997ca
    mov edx, dword ptr [ebp - local_160]         # 004997d0
    sub edx, dword ptr [ecx + field_1fff]        # 004997d6
    mov dword ptr [ebp - local_160], edx         # 004997dc
    mov eax, dword ptr [ebp - local_84]          # 004997e2
    sub eax, 0x218                               # 004997e8
    mov dword ptr [ebp - local_84], eax          # 004997ed
    jmp.d32 L_00499879                           # 004997f3
L_004997f8:
    # block 0x004997f8: entered by jb at 0x0049975d, 5 instruction(s), ends with je to 0x0049983e (forward)
    mov ecx, dword ptr [ebp - local_288]         # 004997f8
    {load} xor edx, edx                          # 004997fe
    mov dl, byte ptr [ecx + field_50ee]          # 00499800
    test edx, edx                                # 00499806
    je.d8 L_0049983e                             # 00499808
    # block 0x0049980a: entered by fall-through of je at 0x00499808, 11 instruction(s), falls into the block at 0x0049983e
    mov eax, dword ptr [ebp - local_114]         # 0049980a
    shl eax                                      # 00499810
    mov dword ptr [ebp - local_114], eax         # 00499812
    mov ecx, dword ptr [ebp - local_13c]         # 00499818
    add ecx, dword ptr [ebp - local_114]         # 0049981e
    mov edx, dword ptr [ebp - local_160]         # 00499824
    mov ax, word ptr [ecx]                       # 0049982a
    mov word ptr [edx], ax                       # 0049982d
    mov ecx, dword ptr [ebp - local_84]          # 00499830
    mov dl, byte ptr [ebp - local_b0]            # 00499836
    mov byte ptr [ecx], dl                       # 0049983c
L_0049983e:
    # block 0x0049983e: entered by je at 0x00499808, 10 instruction(s), falls into the block at 0x00499879
    mov eax, dword ptr [ebp - local_120]         # 0049983e
    sub eax, dword ptr [ebp - local_118]         # 00499844
    mov dword ptr [ebp - local_120], eax         # 0049984a
    mov ecx, dword ptr [ebp - local_288]         # 00499850
    mov edx, dword ptr [ebp - local_160]         # 00499856
    sub edx, dword ptr [ecx + field_1fff]        # 0049985c
    mov dword ptr [ebp - local_160], edx         # 00499862
    mov eax, dword ptr [ebp - local_84]          # 00499868
    sub eax, 0x218                               # 0049986e
    mov dword ptr [ebp - local_84], eax          # 00499873
L_00499879:
    # block 0x00499879: entered by jmp at 0x004997f3, 1 instruction(s), ends with backward jump to 0x00499724
    jmp.d32 L_00499724                           # 00499879
L_0049987e:
    # block 0x0049987e: entered by jmp at 0x00499716; jge at 0x00499736, 1 instruction(s), ends with forward jump to 0x00499e57
    jmp.d32 L_00499e57                           # 0049987e
L_00499883:
    # block 0x00499883: entered by je at 0x0049923d, 5 instruction(s), ends with jne to 0x004998cd (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00499883
    {load} xor edx, edx                          # 00499889
    mov dl, byte ptr [ecx + field_50f0]          # 0049988b
    test edx, edx                                # 00499891
    jne.d8 L_004998cd                            # 00499893
    # block 0x00499895: entered by fall-through of jne at 0x00499893, 11 instruction(s), ends with forward jump to 0x00499903
    mov eax, dword ptr [ebp - local_94]          # 00499895
    imul eax, eax, 0x154                         # 0049989b
    mov ecx, dword ptr [ebp - local_288]         # 004998a1
    lea edx, [ecx + eax + field_2491]            # 004998a7
    mov eax, dword ptr [ebp - local_288]         # 004998ae
    {load} xor ecx, ecx                          # 004998b4
    mov cl, byte ptr [eax + field_50ed]          # 004998b6
    mov edx, dword ptr [edx + 4*ecx]             # 004998bc
    add edx, dword ptr [ebp - local_a8]          # 004998bf
    mov dword ptr [ebp - local_10c], edx         # 004998c5
    jmp.d8 L_00499903                            # 004998cb
L_004998cd:
    # block 0x004998cd: entered by jne at 0x00499893, 10 instruction(s), falls into the block at 0x00499903
    mov eax, dword ptr [ebp - local_94]          # 004998cd
    imul eax, eax, 0xa0                          # 004998d3
    mov ecx, dword ptr [ebp - local_288]         # 004998d9
    lea edx, [ecx + eax + field_2f31]            # 004998df
    mov eax, dword ptr [ebp - local_288]         # 004998e6
    {load} xor ecx, ecx                          # 004998ec
    mov cl, byte ptr [eax + field_50ed]          # 004998ee
    mov edx, dword ptr [edx + 4*ecx]             # 004998f4
    add edx, dword ptr [ebp - local_a8]          # 004998f7
    mov dword ptr [ebp - local_10c], edx         # 004998fd
L_00499903:
    # block 0x00499903: entered by jmp at 0x004998cb, 5 instruction(s), ends with jne to 0x0049994a (forward)
    mov eax, dword ptr [ebp - local_288]         # 00499903
    {load} xor ecx, ecx                          # 00499909
    mov cl, byte ptr [eax + field_50f1]          # 0049990b
    test ecx, ecx                                # 00499911
    jne.d8 L_0049994a                            # 00499913
    # block 0x00499915: entered by fall-through of jne at 0x00499913, 11 instruction(s), ends with forward jump to 0x0049997d
    mov edx, dword ptr [ebp - local_30]          # 00499915
    imul edx, edx, 0x154                         # 00499918
    mov eax, dword ptr [ebp - local_288]         # 0049991e
    lea ecx, [eax + edx + field_2491]            # 00499924
    mov edx, dword ptr [ebp - local_288]         # 0049992b
    {load} xor eax, eax                          # 00499931
    mov al, byte ptr [edx + field_50ee]          # 00499933
    mov ecx, dword ptr [ecx + 4*eax]             # 00499939
    add ecx, dword ptr [ebp - local_a8]          # 0049993c
    mov dword ptr [ebp - local_13c], ecx         # 00499942
    jmp.d8 L_0049997d                            # 00499948
L_0049994a:
    # block 0x0049994a: entered by jne at 0x00499913, 10 instruction(s), falls into the block at 0x0049997d
    mov edx, dword ptr [ebp - local_30]          # 0049994a
    imul edx, edx, 0xa0                          # 0049994d
    mov eax, dword ptr [ebp - local_288]         # 00499953
    lea ecx, [eax + edx + field_2f31]            # 00499959
    mov edx, dword ptr [ebp - local_288]         # 00499960
    {load} xor eax, eax                          # 00499966
    mov al, byte ptr [edx + field_50ee]          # 00499968
    mov ecx, dword ptr [ecx + 4*eax]             # 0049996e
    add ecx, dword ptr [ebp - local_a8]          # 00499971
    mov dword ptr [ebp - local_13c], ecx         # 00499977
L_0049997d:
    # block 0x0049997d: entered by jmp at 0x00499948, 5 instruction(s), ends with jne to 0x004999c1 (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049997d
    {load} xor eax, eax                          # 00499983
    mov al, byte ptr [edx + field_50f2]          # 00499985
    test eax, eax                                # 0049998b
    jne.d8 L_004999c1                            # 0049998d
    # block 0x0049998f: entered by fall-through of jne at 0x0049998d, 11 instruction(s), ends with forward jump to 0x004999f1
    mov ecx, dword ptr [ebp - local_14]          # 0049998f
    imul ecx, ecx, 0x154                         # 00499992
    mov edx, dword ptr [ebp - local_288]         # 00499998
    lea eax, [edx + ecx + field_2491]            # 0049999e
    mov ecx, dword ptr [ebp - local_288]         # 004999a5
    {load} xor edx, edx                          # 004999ab
    mov dl, byte ptr [ecx + field_50ef]          # 004999ad
    mov eax, dword ptr [eax + 4*edx]             # 004999b3
    add eax, dword ptr [ebp - local_a8]          # 004999b6
    mov dword ptr [ebp - local_60], eax          # 004999bc
    jmp.d8 L_004999f1                            # 004999bf
L_004999c1:
    # block 0x004999c1: entered by jne at 0x0049998d, 10 instruction(s), falls into the block at 0x004999f1
    mov ecx, dword ptr [ebp - local_14]          # 004999c1
    imul ecx, ecx, 0xa0                          # 004999c4
    mov edx, dword ptr [ebp - local_288]         # 004999ca
    lea eax, [edx + ecx + field_2f31]            # 004999d0
    mov ecx, dword ptr [ebp - local_288]         # 004999d7
    {load} xor edx, edx                          # 004999dd
    mov dl, byte ptr [ecx + field_50ef]          # 004999df
    mov eax, dword ptr [eax + 4*edx]             # 004999e5
    add eax, dword ptr [ebp - local_a8]          # 004999e8
    mov dword ptr [ebp - local_60], eax          # 004999ee
L_004999f1:
    # block 0x004999f1: entered by jmp at 0x004999bf, 2 instruction(s), ends with je to 0x00499c53 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 004999f1
    je.d32 L_00499c53                            # 004999f5
    # block 0x004999fb: entered by fall-through of je at 0x004999f5, 2 instruction(s), ends with forward jump to 0x00499a0d
    mov dword ptr [ebp - local_74], 0x0          # 004999fb
    jmp.d8 L_00499a0d                            # 00499a02
L_00499a04:
    # block 0x00499a04: entered by jmp at 0x00499c49, 3 instruction(s), falls into the block at 0x00499a0d
    mov ecx, dword ptr [ebp - local_74]          # 00499a04
    add ecx, 0x1                                 # 00499a07
    mov dword ptr [ebp - local_74], ecx          # 00499a0a
L_00499a0d:
    # block 0x00499a0d: entered by jmp at 0x00499a02, 3 instruction(s), ends with jge to 0x00499c4e (forward)
    mov edx, dword ptr [ebp - local_74]          # 00499a0d
    cmp edx, dword ptr [ebp - local_130]         # 00499a10
    jge.d32 L_00499c4e                           # 00499a16
    # block 0x00499a1c: entered by fall-through of jge at 0x00499a16, 6 instruction(s), ends with jb to 0x00499ae9 (forward)
    mov eax, dword ptr [ebp - local_120]         # 00499a1c
    shr eax, 0x10                                # 00499a22
    mov dword ptr [ebp - local_114], eax         # 00499a25
    mov ecx, dword ptr [ebp - local_114]         # 00499a2b
    cmp ecx, dword ptr [ebp - local_44]          # 00499a31
    jb.d32 L_00499ae9                            # 00499a34
    # block 0x00499a3a: entered by fall-through of jb at 0x00499a34, 5 instruction(s), ends with je to 0x00499aa8 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00499a3a
    {load} xor eax, eax                          # 00499a40
    mov al, byte ptr [edx + field_50ed]          # 00499a42
    test eax, eax                                # 00499a48
    je.d8 L_00499aa8                             # 00499a4a
    # block 0x00499a4c: entered by fall-through of je at 0x00499a4a, 7 instruction(s), ends with je to 0x00499aa8 (forward)
    mov ecx, dword ptr [ebp - local_84]          # 00499a4c
    {load} xor edx, edx                          # 00499a52
    mov dl, byte ptr [ecx]                       # 00499a54
    mov eax, dword ptr [ebp - local_b0]          # 00499a56
    and eax, 0xff                                # 00499a5c
    {load} cmp edx, eax                          # 00499a61
    je.d8 L_00499aa8                             # 00499a63
    # block 0x00499a65: entered by fall-through of je at 0x00499a63, 14 instruction(s), falls into the block at 0x00499aa8
    mov ecx, dword ptr [ebp - local_114]         # 00499a65
    and ecx, 0x7f                                # 00499a6b
    mov dword ptr [ebp - local_114], ecx         # 00499a6e
    mov edx, dword ptr [ebp - local_114]         # 00499a74
    shl edx                                      # 00499a7a
    mov dword ptr [ebp - local_114], edx         # 00499a7c
    mov eax, dword ptr [ebp - local_10c]         # 00499a82
    add eax, dword ptr [ebp - local_114]         # 00499a88
    mov ecx, dword ptr [ebp - local_160]         # 00499a8e
    mov dx, word ptr [eax]                       # 00499a94
    mov word ptr [ecx], dx                       # 00499a97
    mov eax, dword ptr [ebp - local_84]          # 00499a9a
    mov cl, byte ptr [ebp - local_b0]            # 00499aa0
    mov byte ptr [eax], cl                       # 00499aa6
L_00499aa8:
    # block 0x00499aa8: entered by je at 0x00499a4a; je at 0x00499a63, 11 instruction(s), ends with forward jump to 0x00499c49
    mov edx, dword ptr [ebp - local_120]         # 00499aa8
    sub edx, dword ptr [ebp - local_118]         # 00499aae
    mov dword ptr [ebp - local_120], edx         # 00499ab4
    mov eax, dword ptr [ebp - local_288]         # 00499aba
    mov ecx, dword ptr [ebp - local_160]         # 00499ac0
    sub ecx, dword ptr [eax + field_1fff]        # 00499ac6
    mov dword ptr [ebp - local_160], ecx         # 00499acc
    mov edx, dword ptr [ebp - local_84]          # 00499ad2
    sub edx, 0x218                               # 00499ad8
    mov dword ptr [ebp - local_84], edx          # 00499ade
    jmp.d32 L_00499c49                           # 00499ae4
L_00499ae9:
    # block 0x00499ae9: entered by jb at 0x00499a34, 4 instruction(s), ends with jb to 0x00499bb0 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00499ae9
    mov ecx, dword ptr [ebp - local_114]         # 00499aef
    cmp ecx, dword ptr [eax + field_45b1]        # 00499af5
    jb.d32 L_00499bb0                            # 00499afb
    # block 0x00499b01: entered by fall-through of jb at 0x00499afb, 5 instruction(s), ends with je to 0x00499b6f (forward)
    mov edx, dword ptr [ebp - local_288]         # 00499b01
    {load} xor eax, eax                          # 00499b07
    mov al, byte ptr [edx + field_50ee]          # 00499b09
    test eax, eax                                # 00499b0f
    je.d8 L_00499b6f                             # 00499b11
    # block 0x00499b13: entered by fall-through of je at 0x00499b11, 7 instruction(s), ends with je to 0x00499b6f (forward)
    mov ecx, dword ptr [ebp - local_84]          # 00499b13
    {load} xor edx, edx                          # 00499b19
    mov dl, byte ptr [ecx]                       # 00499b1b
    mov eax, dword ptr [ebp - local_b0]          # 00499b1d
    and eax, 0xff                                # 00499b23
    {load} cmp edx, eax                          # 00499b28
    je.d8 L_00499b6f                             # 00499b2a
    # block 0x00499b2c: entered by fall-through of je at 0x00499b2a, 14 instruction(s), falls into the block at 0x00499b6f
    mov ecx, dword ptr [ebp - local_114]         # 00499b2c
    and ecx, 0x7f                                # 00499b32
    mov dword ptr [ebp - local_114], ecx         # 00499b35
    mov edx, dword ptr [ebp - local_114]         # 00499b3b
    shl edx                                      # 00499b41
    mov dword ptr [ebp - local_114], edx         # 00499b43
    mov eax, dword ptr [ebp - local_13c]         # 00499b49
    add eax, dword ptr [ebp - local_114]         # 00499b4f
    mov ecx, dword ptr [ebp - local_160]         # 00499b55
    mov dx, word ptr [eax]                       # 00499b5b
    mov word ptr [ecx], dx                       # 00499b5e
    mov eax, dword ptr [ebp - local_84]          # 00499b61
    mov cl, byte ptr [ebp - local_b0]            # 00499b67
    mov byte ptr [eax], cl                       # 00499b6d
L_00499b6f:
    # block 0x00499b6f: entered by je at 0x00499b11; je at 0x00499b2a, 11 instruction(s), ends with forward jump to 0x00499c49
    mov edx, dword ptr [ebp - local_120]         # 00499b6f
    sub edx, dword ptr [ebp - local_118]         # 00499b75
    mov dword ptr [ebp - local_120], edx         # 00499b7b
    mov eax, dword ptr [ebp - local_288]         # 00499b81
    mov ecx, dword ptr [ebp - local_160]         # 00499b87
    sub ecx, dword ptr [eax + field_1fff]        # 00499b8d
    mov dword ptr [ebp - local_160], ecx         # 00499b93
    mov edx, dword ptr [ebp - local_84]          # 00499b99
    sub edx, 0x218                               # 00499b9f
    mov dword ptr [ebp - local_84], edx          # 00499ba5
    jmp.d32 L_00499c49                           # 00499bab
L_00499bb0:
    # block 0x00499bb0: entered by jb at 0x00499afb, 5 instruction(s), ends with je to 0x00499c0d (forward)
    mov eax, dword ptr [ebp - local_288]         # 00499bb0
    {load} xor ecx, ecx                          # 00499bb6
    mov cl, byte ptr [eax + field_50ef]          # 00499bb8
    test ecx, ecx                                # 00499bbe
    je.d8 L_00499c0d                             # 00499bc0
    # block 0x00499bc2: entered by fall-through of je at 0x00499bc0, 7 instruction(s), ends with je to 0x00499c0d (forward)
    mov edx, dword ptr [ebp - local_84]          # 00499bc2
    {load} xor eax, eax                          # 00499bc8
    mov al, byte ptr [edx]                       # 00499bca
    mov ecx, dword ptr [ebp - local_b0]          # 00499bcc
    and ecx, 0xff                                # 00499bd2
    {load} cmp eax, ecx                          # 00499bd8
    je.d8 L_00499c0d                             # 00499bda
    # block 0x00499bdc: entered by fall-through of je at 0x00499bda, 11 instruction(s), falls into the block at 0x00499c0d
    mov edx, dword ptr [ebp - local_114]         # 00499bdc
    shl edx                                      # 00499be2
    mov dword ptr [ebp - local_114], edx         # 00499be4
    mov eax, dword ptr [ebp - local_60]          # 00499bea
    add eax, dword ptr [ebp - local_114]         # 00499bed
    mov ecx, dword ptr [ebp - local_160]         # 00499bf3
    mov dx, word ptr [eax]                       # 00499bf9
    mov word ptr [ecx], dx                       # 00499bfc
    mov eax, dword ptr [ebp - local_84]          # 00499bff
    mov cl, byte ptr [ebp - local_b0]            # 00499c05
    mov byte ptr [eax], cl                       # 00499c0b
L_00499c0d:
    # block 0x00499c0d: entered by je at 0x00499bc0; je at 0x00499bda, 10 instruction(s), falls into the block at 0x00499c49
    mov edx, dword ptr [ebp - local_120]         # 00499c0d
    sub edx, dword ptr [ebp - local_118]         # 00499c13
    mov dword ptr [ebp - local_120], edx         # 00499c19
    mov eax, dword ptr [ebp - local_288]         # 00499c1f
    mov ecx, dword ptr [ebp - local_160]         # 00499c25
    sub ecx, dword ptr [eax + field_1fff]        # 00499c2b
    mov dword ptr [ebp - local_160], ecx         # 00499c31
    mov edx, dword ptr [ebp - local_84]          # 00499c37
    sub edx, 0x218                               # 00499c3d
    mov dword ptr [ebp - local_84], edx          # 00499c43
L_00499c49:
    # block 0x00499c49: entered by jmp at 0x00499ae4; jmp at 0x00499bab, 1 instruction(s), ends with backward jump to 0x00499a04
    jmp.d32 L_00499a04                           # 00499c49
L_00499c4e:
    # block 0x00499c4e: entered by jge at 0x00499a16, 1 instruction(s), ends with forward jump to 0x00499e57
    jmp.d32 L_00499e57                           # 00499c4e
L_00499c53:
    # block 0x00499c53: entered by je at 0x004999f5, 2 instruction(s), ends with forward jump to 0x00499c65
    mov dword ptr [ebp - local_74], 0x0          # 00499c53
    jmp.d8 L_00499c65                            # 00499c5a
L_00499c5c:
    # block 0x00499c5c: entered by jmp at 0x00499e52, 3 instruction(s), falls into the block at 0x00499c65
    mov eax, dword ptr [ebp - local_74]          # 00499c5c
    add eax, 0x1                                 # 00499c5f
    mov dword ptr [ebp - local_74], eax          # 00499c62
L_00499c65:
    # block 0x00499c65: entered by jmp at 0x00499c5a, 3 instruction(s), ends with jge to 0x00499e57 (forward)
    mov ecx, dword ptr [ebp - local_74]          # 00499c65
    cmp ecx, dword ptr [ebp - local_130]         # 00499c68
    jge.d32 L_00499e57                           # 00499c6e
    # block 0x00499c74: entered by fall-through of jge at 0x00499c6e, 6 instruction(s), ends with jb to 0x00499d28 (forward)
    mov edx, dword ptr [ebp - local_120]         # 00499c74
    shr edx, 0x10                                # 00499c7a
    mov dword ptr [ebp - local_114], edx         # 00499c7d
    mov eax, dword ptr [ebp - local_114]         # 00499c83
    cmp eax, dword ptr [ebp - local_44]          # 00499c89
    jb.d32 L_00499d28                            # 00499c8c
    # block 0x00499c92: entered by fall-through of jb at 0x00499c8c, 5 instruction(s), ends with je to 0x00499ce7 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00499c92
    {load} xor edx, edx                          # 00499c98
    mov dl, byte ptr [ecx + field_50ed]          # 00499c9a
    test edx, edx                                # 00499ca0
    je.d8 L_00499ce7                             # 00499ca2
    # block 0x00499ca4: entered by fall-through of je at 0x00499ca2, 14 instruction(s), falls into the block at 0x00499ce7
    mov eax, dword ptr [ebp - local_114]         # 00499ca4
    and eax, 0x7f                                # 00499caa
    mov dword ptr [ebp - local_114], eax         # 00499cad
    mov ecx, dword ptr [ebp - local_114]         # 00499cb3
    shl ecx                                      # 00499cb9
    mov dword ptr [ebp - local_114], ecx         # 00499cbb
    mov edx, dword ptr [ebp - local_10c]         # 00499cc1
    add edx, dword ptr [ebp - local_114]         # 00499cc7
    mov eax, dword ptr [ebp - local_160]         # 00499ccd
    mov cx, word ptr [edx]                       # 00499cd3
    mov word ptr [eax], cx                       # 00499cd6
    mov edx, dword ptr [ebp - local_84]          # 00499cd9
    mov al, byte ptr [ebp - local_b0]            # 00499cdf
    mov byte ptr [edx], al                       # 00499ce5
L_00499ce7:
    # block 0x00499ce7: entered by je at 0x00499ca2, 11 instruction(s), ends with forward jump to 0x00499e52
    mov ecx, dword ptr [ebp - local_120]         # 00499ce7
    sub ecx, dword ptr [ebp - local_118]         # 00499ced
    mov dword ptr [ebp - local_120], ecx         # 00499cf3
    mov edx, dword ptr [ebp - local_288]         # 00499cf9
    mov eax, dword ptr [ebp - local_160]         # 00499cff
    sub eax, dword ptr [edx + field_1fff]        # 00499d05
    mov dword ptr [ebp - local_160], eax         # 00499d0b
    mov ecx, dword ptr [ebp - local_84]          # 00499d11
    sub ecx, 0x218                               # 00499d17
    mov dword ptr [ebp - local_84], ecx          # 00499d1d
    jmp.d32 L_00499e52                           # 00499d23
L_00499d28:
    # block 0x00499d28: entered by jb at 0x00499c8c, 4 instruction(s), ends with jb to 0x00499dd3 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00499d28
    mov eax, dword ptr [ebp - local_114]         # 00499d2e
    cmp eax, dword ptr [edx + field_45b1]        # 00499d34
    jb.d32 L_00499dd3                            # 00499d3a
    # block 0x00499d40: entered by fall-through of jb at 0x00499d3a, 5 instruction(s), ends with je to 0x00499d95 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00499d40
    {load} xor edx, edx                          # 00499d46
    mov dl, byte ptr [ecx + field_50ee]          # 00499d48
    test edx, edx                                # 00499d4e
    je.d8 L_00499d95                             # 00499d50
    # block 0x00499d52: entered by fall-through of je at 0x00499d50, 14 instruction(s), falls into the block at 0x00499d95
    mov eax, dword ptr [ebp - local_114]         # 00499d52
    and eax, 0x7f                                # 00499d58
    mov dword ptr [ebp - local_114], eax         # 00499d5b
    mov ecx, dword ptr [ebp - local_114]         # 00499d61
    shl ecx                                      # 00499d67
    mov dword ptr [ebp - local_114], ecx         # 00499d69
    mov edx, dword ptr [ebp - local_13c]         # 00499d6f
    add edx, dword ptr [ebp - local_114]         # 00499d75
    mov eax, dword ptr [ebp - local_160]         # 00499d7b
    mov cx, word ptr [edx]                       # 00499d81
    mov word ptr [eax], cx                       # 00499d84
    mov edx, dword ptr [ebp - local_84]          # 00499d87
    mov al, byte ptr [ebp - local_b0]            # 00499d8d
    mov byte ptr [edx], al                       # 00499d93
L_00499d95:
    # block 0x00499d95: entered by je at 0x00499d50, 11 instruction(s), ends with forward jump to 0x00499e52
    mov ecx, dword ptr [ebp - local_120]         # 00499d95
    sub ecx, dword ptr [ebp - local_118]         # 00499d9b
    mov dword ptr [ebp - local_120], ecx         # 00499da1
    mov edx, dword ptr [ebp - local_288]         # 00499da7
    mov eax, dword ptr [ebp - local_160]         # 00499dad
    sub eax, dword ptr [edx + field_1fff]        # 00499db3
    mov dword ptr [ebp - local_160], eax         # 00499db9
    mov ecx, dword ptr [ebp - local_84]          # 00499dbf
    sub ecx, 0x218                               # 00499dc5
    mov dword ptr [ebp - local_84], ecx          # 00499dcb
    jmp.d8 L_00499e52                            # 00499dd1
L_00499dd3:
    # block 0x00499dd3: entered by jb at 0x00499d3a, 5 instruction(s), ends with je to 0x00499e16 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00499dd3
    {load} xor eax, eax                          # 00499dd9
    mov al, byte ptr [edx + field_50ef]          # 00499ddb
    test eax, eax                                # 00499de1
    je.d8 L_00499e16                             # 00499de3
    # block 0x00499de5: entered by fall-through of je at 0x00499de3, 11 instruction(s), falls into the block at 0x00499e16
    mov ecx, dword ptr [ebp - local_114]         # 00499de5
    shl ecx                                      # 00499deb
    mov dword ptr [ebp - local_114], ecx         # 00499ded
    mov edx, dword ptr [ebp - local_60]          # 00499df3
    add edx, dword ptr [ebp - local_114]         # 00499df6
    mov eax, dword ptr [ebp - local_160]         # 00499dfc
    mov cx, word ptr [edx]                       # 00499e02
    mov word ptr [eax], cx                       # 00499e05
    mov edx, dword ptr [ebp - local_84]          # 00499e08
    mov al, byte ptr [ebp - local_b0]            # 00499e0e
    mov byte ptr [edx], al                       # 00499e14
L_00499e16:
    # block 0x00499e16: entered by je at 0x00499de3, 10 instruction(s), falls into the block at 0x00499e52
    mov ecx, dword ptr [ebp - local_120]         # 00499e16
    sub ecx, dword ptr [ebp - local_118]         # 00499e1c
    mov dword ptr [ebp - local_120], ecx         # 00499e22
    mov edx, dword ptr [ebp - local_288]         # 00499e28
    mov eax, dword ptr [ebp - local_160]         # 00499e2e
    sub eax, dword ptr [edx + field_1fff]        # 00499e34
    mov dword ptr [ebp - local_160], eax         # 00499e3a
    mov ecx, dword ptr [ebp - local_84]          # 00499e40
    sub ecx, 0x218                               # 00499e46
    mov dword ptr [ebp - local_84], ecx          # 00499e4c
L_00499e52:
    # block 0x00499e52: entered by jmp at 0x00499d23; jmp at 0x00499dd1, 1 instruction(s), ends with backward jump to 0x00499c5c
    jmp.d32 L_00499c5c                           # 00499e52
L_00499e57:
    # block 0x00499e57: entered by jmp at 0x00499476; jmp at 0x0049987e; jmp at 0x00499c4e; jge at 0x00499c6e, 1 instruction(s), ends with forward jump to 0x0049b97e
    jmp.d32 L_0049b97e                           # 00499e57
L_00499e5c:
    # block 0x00499e5c: entered by je at 0x004991f7; jne at 0x00499211, 5 instruction(s), ends with jne to 0x0049ab84 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00499e5c
    mov eax, dword ptr [edx + field_50e9]        # 00499e62
    and eax, 0x10000000                          # 00499e68
    test eax, eax                                # 00499e6d
    jne.d32 L_0049ab84                           # 00499e6f
    # block 0x00499e75: entered by fall-through of jne at 0x00499e6f, 5 instruction(s), ends with je to 0x0049ab84 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 00499e75
    mov edx, dword ptr [ecx + field_50e9]        # 00499e7b
    and edx, 0x20000000                          # 00499e81
    test edx, edx                                # 00499e87
    je.d32 L_0049ab84                            # 00499e89
    # block 0x00499e8f: entered by fall-through of je at 0x00499e89, 5 instruction(s), ends with je to 0x0049a110 (forward)
    mov eax, dword ptr [ebp - local_288]         # 00499e8f
    mov ecx, dword ptr [eax + field_1f27]        # 00499e95
    mov dword ptr [ebp - local_324], ecx         # 00499e9b
    cmp dword ptr [ebp - local_324], 0x2         # 00499ea1
    je.d32 L_0049a110                            # 00499ea8
    # block 0x00499eae: entered by fall-through of je at 0x00499ea8, 2 instruction(s), ends with je to 0x0049a552 (forward)
    cmp dword ptr [ebp - local_324], 0x3         # 00499eae
    je.d32 L_0049a552                            # 00499eb5
    # block 0x00499ebb: entered by fall-through of je at 0x00499eb5, 5 instruction(s), ends with jne to 0x00499f05 (forward)
    mov edx, dword ptr [ebp - local_288]         # 00499ebb
    {load} xor eax, eax                          # 00499ec1
    mov al, byte ptr [edx + field_50f0]          # 00499ec3
    test eax, eax                                # 00499ec9
    jne.d8 L_00499f05                            # 00499ecb
    # block 0x00499ecd: entered by fall-through of jne at 0x00499ecb, 11 instruction(s), ends with forward jump to 0x00499f3b
    mov ecx, dword ptr [ebp - local_94]          # 00499ecd
    imul ecx, ecx, 0x154                         # 00499ed3
    mov edx, dword ptr [ebp - local_288]         # 00499ed9
    lea eax, [edx + ecx + field_2491]            # 00499edf
    mov ecx, dword ptr [ebp - local_288]         # 00499ee6
    {load} xor edx, edx                          # 00499eec
    mov dl, byte ptr [ecx + field_50ed]          # 00499eee
    mov eax, dword ptr [eax + 4*edx]             # 00499ef4
    add eax, dword ptr [ebp - local_a8]          # 00499ef7
    mov dword ptr [ebp - local_88], eax          # 00499efd
    jmp.d8 L_00499f3b                            # 00499f03
L_00499f05:
    # block 0x00499f05: entered by jne at 0x00499ecb, 10 instruction(s), falls into the block at 0x00499f3b
    mov ecx, dword ptr [ebp - local_94]          # 00499f05
    imul ecx, ecx, 0xa0                          # 00499f0b
    mov edx, dword ptr [ebp - local_288]         # 00499f11
    lea eax, [edx + ecx + field_2f31]            # 00499f17
    mov ecx, dword ptr [ebp - local_288]         # 00499f1e
    {load} xor edx, edx                          # 00499f24
    mov dl, byte ptr [ecx + field_50ed]          # 00499f26
    mov eax, dword ptr [eax + 4*edx]             # 00499f2c
    add eax, dword ptr [ebp - local_a8]          # 00499f2f
    mov dword ptr [ebp - local_88], eax          # 00499f35
L_00499f3b:
    # block 0x00499f3b: entered by jmp at 0x00499f03, 2 instruction(s), ends with je to 0x0049a038 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 00499f3b
    je.d32 L_0049a038                            # 00499f3f
    # block 0x00499f45: entered by fall-through of je at 0x00499f3f, 2 instruction(s), ends with forward jump to 0x00499f57
    mov dword ptr [ebp - local_74], 0x0          # 00499f45
    jmp.d8 L_00499f57                            # 00499f4c
L_00499f4e:
    # block 0x00499f4e: entered by jmp at 0x0049a02e, 3 instruction(s), falls into the block at 0x00499f57
    mov ecx, dword ptr [ebp - local_74]          # 00499f4e
    add ecx, 0x1                                 # 00499f51
    mov dword ptr [ebp - local_74], ecx          # 00499f54
L_00499f57:
    # block 0x00499f57: entered by jmp at 0x00499f4c, 3 instruction(s), ends with jge to 0x0049a033 (forward)
    mov edx, dword ptr [ebp - local_74]          # 00499f57
    cmp edx, dword ptr [ebp - local_130]         # 00499f5a
    jge.d32 L_0049a033                           # 00499f60
    # block 0x00499f66: entered by fall-through of jge at 0x00499f60, 7 instruction(s), ends with je to 0x00499fe4 (forward)
    mov eax, dword ptr [ebp - local_84]          # 00499f66
    {load} xor ecx, ecx                          # 00499f6c
    mov cl, byte ptr [eax]                       # 00499f6e
    mov edx, dword ptr [ebp - local_b0]          # 00499f70
    and edx, 0xff                                # 00499f76
    {load} cmp ecx, edx                          # 00499f7c
    je.d8 L_00499fe4                             # 00499f7e
    # block 0x00499f80: entered by fall-through of je at 0x00499f7e, 16 instruction(s), ends with je to 0x00499fe4 (forward)
    mov eax, dword ptr [ebp - local_120]         # 00499f80
    shr eax, 0x10                                # 00499f86
    mov dword ptr [ebp - local_114], eax         # 00499f89
    mov ecx, dword ptr [ebp - local_114]         # 00499f8f
    shl ecx                                      # 00499f95
    mov dword ptr [ebp - local_114], ecx         # 00499f97
    mov edx, dword ptr [ebp - local_88]          # 00499f9d
    add edx, dword ptr [ebp - local_114]         # 00499fa3
    mov ax, word ptr [edx]                       # 00499fa9
    mov word ptr [ebp - local_4], ax             # 00499fac
    mov ecx, dword ptr [ebp - local_4]           # 00499fb0
    and ecx, 0xffff                              # 00499fb3
    mov edx, dword ptr [ebp - local_e0]          # 00499fb9
    and edx, 0xffff                              # 00499fbf
    {load} cmp ecx, edx                          # 00499fc5
    je.d8 L_00499fe4                             # 00499fc7
    # block 0x00499fc9: entered by fall-through of je at 0x00499fc7, 6 instruction(s), falls into the block at 0x00499fe4
    mov eax, dword ptr [ebp - local_160]         # 00499fc9
    mov cx, word ptr [ebp - local_4]             # 00499fcf
    mov word ptr [eax], cx                       # 00499fd3
    mov edx, dword ptr [ebp - local_84]          # 00499fd6
    mov al, byte ptr [ebp - local_b0]            # 00499fdc
    mov byte ptr [edx], al                       # 00499fe2
L_00499fe4:
    # block 0x00499fe4: entered by je at 0x00499f7e; je at 0x00499fc7, 3 instruction(s), ends with jbe to 0x0049a004 (forward)
    mov ecx, dword ptr [ebp - local_120]         # 00499fe4
    cmp ecx, dword ptr [ebp - local_118]         # 00499fea
    jbe.d8 L_0049a004                            # 00499ff0
    # block 0x00499ff2: entered by fall-through of jbe at 0x00499ff0, 3 instruction(s), falls into the block at 0x0049a004
    mov edx, dword ptr [ebp - local_120]         # 00499ff2
    sub edx, dword ptr [ebp - local_118]         # 00499ff8
    mov dword ptr [ebp - local_120], edx         # 00499ffe
L_0049a004:
    # block 0x0049a004: entered by jbe at 0x00499ff0, 8 instruction(s), ends with backward jump to 0x00499f4e
    mov eax, dword ptr [ebp - local_288]         # 0049a004
    mov ecx, dword ptr [ebp - local_160]         # 0049a00a
    sub ecx, dword ptr [eax + field_1fff]        # 0049a010
    mov dword ptr [ebp - local_160], ecx         # 0049a016
    mov edx, dword ptr [ebp - local_84]          # 0049a01c
    sub edx, 0x218                               # 0049a022
    mov dword ptr [ebp - local_84], edx          # 0049a028
    jmp.d32 L_00499f4e                           # 0049a02e
L_0049a033:
    # block 0x0049a033: entered by jge at 0x00499f60, 1 instruction(s), ends with forward jump to 0x0049a10b
    jmp.d32 L_0049a10b                           # 0049a033
L_0049a038:
    # block 0x0049a038: entered by je at 0x00499f3f, 2 instruction(s), ends with forward jump to 0x0049a04a
    mov dword ptr [ebp - local_74], 0x0          # 0049a038
    jmp.d8 L_0049a04a                            # 0049a03f
L_0049a041:
    # block 0x0049a041: entered by jmp at 0x0049a106, 3 instruction(s), falls into the block at 0x0049a04a
    mov eax, dword ptr [ebp - local_74]          # 0049a041
    add eax, 0x1                                 # 0049a044
    mov dword ptr [ebp - local_74], eax          # 0049a047
L_0049a04a:
    # block 0x0049a04a: entered by jmp at 0x0049a03f, 3 instruction(s), ends with jge to 0x0049a10b (forward)
    mov ecx, dword ptr [ebp - local_74]          # 0049a04a
    cmp ecx, dword ptr [ebp - local_130]         # 0049a04d
    jge.d32 L_0049a10b                           # 0049a053
    # block 0x0049a059: entered by fall-through of jge at 0x0049a053, 16 instruction(s), ends with je to 0x0049a0bc (forward)
    mov edx, dword ptr [ebp - local_120]         # 0049a059
    shr edx, 0x10                                # 0049a05f
    mov dword ptr [ebp - local_114], edx         # 0049a062
    mov eax, dword ptr [ebp - local_114]         # 0049a068
    shl eax                                      # 0049a06e
    mov dword ptr [ebp - local_114], eax         # 0049a070
    mov ecx, dword ptr [ebp - local_88]          # 0049a076
    add ecx, dword ptr [ebp - local_114]         # 0049a07c
    mov dx, word ptr [ecx]                       # 0049a082
    mov word ptr [ebp - local_4], dx             # 0049a085
    mov eax, dword ptr [ebp - local_4]           # 0049a089
    and eax, 0xffff                              # 0049a08c
    mov ecx, dword ptr [ebp - local_e0]          # 0049a091
    and ecx, 0xffff                              # 0049a097
    {load} cmp eax, ecx                          # 0049a09d
    je.d8 L_0049a0bc                             # 0049a09f
    # block 0x0049a0a1: entered by fall-through of je at 0x0049a09f, 6 instruction(s), falls into the block at 0x0049a0bc
    mov edx, dword ptr [ebp - local_160]         # 0049a0a1
    mov ax, word ptr [ebp - local_4]             # 0049a0a7
    mov word ptr [edx], ax                       # 0049a0ab
    mov ecx, dword ptr [ebp - local_84]          # 0049a0ae
    mov dl, byte ptr [ebp - local_b0]            # 0049a0b4
    mov byte ptr [ecx], dl                       # 0049a0ba
L_0049a0bc:
    # block 0x0049a0bc: entered by je at 0x0049a09f, 3 instruction(s), ends with jbe to 0x0049a0dc (forward)
    mov eax, dword ptr [ebp - local_120]         # 0049a0bc
    cmp eax, dword ptr [ebp - local_118]         # 0049a0c2
    jbe.d8 L_0049a0dc                            # 0049a0c8
    # block 0x0049a0ca: entered by fall-through of jbe at 0x0049a0c8, 3 instruction(s), falls into the block at 0x0049a0dc
    mov ecx, dword ptr [ebp - local_120]         # 0049a0ca
    sub ecx, dword ptr [ebp - local_118]         # 0049a0d0
    mov dword ptr [ebp - local_120], ecx         # 0049a0d6
L_0049a0dc:
    # block 0x0049a0dc: entered by jbe at 0x0049a0c8, 8 instruction(s), ends with backward jump to 0x0049a041
    mov edx, dword ptr [ebp - local_288]         # 0049a0dc
    mov eax, dword ptr [ebp - local_160]         # 0049a0e2
    sub eax, dword ptr [edx + field_1fff]        # 0049a0e8
    mov dword ptr [ebp - local_160], eax         # 0049a0ee
    mov ecx, dword ptr [ebp - local_84]          # 0049a0f4
    sub ecx, 0x218                               # 0049a0fa
    mov dword ptr [ebp - local_84], ecx          # 0049a100
    jmp.d32 L_0049a041                           # 0049a106
L_0049a10b:
    # block 0x0049a10b: entered by jmp at 0x0049a033; jge at 0x0049a053, 1 instruction(s), ends with forward jump to 0x0049ab7f
    jmp.d32 L_0049ab7f                           # 0049a10b
L_0049a110:
    # block 0x0049a110: entered by je at 0x00499ea8, 5 instruction(s), ends with jne to 0x0049a15a (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049a110
    {load} xor eax, eax                          # 0049a116
    mov al, byte ptr [edx + field_50f0]          # 0049a118
    test eax, eax                                # 0049a11e
    jne.d8 L_0049a15a                            # 0049a120
    # block 0x0049a122: entered by fall-through of jne at 0x0049a120, 11 instruction(s), ends with forward jump to 0x0049a190
    mov ecx, dword ptr [ebp - local_94]          # 0049a122
    imul ecx, ecx, 0x154                         # 0049a128
    mov edx, dword ptr [ebp - local_288]         # 0049a12e
    lea eax, [edx + ecx + field_2491]            # 0049a134
    mov ecx, dword ptr [ebp - local_288]         # 0049a13b
    {load} xor edx, edx                          # 0049a141
    mov dl, byte ptr [ecx + field_50ed]          # 0049a143
    mov eax, dword ptr [eax + 4*edx]             # 0049a149
    add eax, dword ptr [ebp - local_a8]          # 0049a14c
    mov dword ptr [ebp - local_10c], eax         # 0049a152
    jmp.d8 L_0049a190                            # 0049a158
L_0049a15a:
    # block 0x0049a15a: entered by jne at 0x0049a120, 10 instruction(s), falls into the block at 0x0049a190
    mov ecx, dword ptr [ebp - local_94]          # 0049a15a
    imul ecx, ecx, 0xa0                          # 0049a160
    mov edx, dword ptr [ebp - local_288]         # 0049a166
    lea eax, [edx + ecx + field_2f31]            # 0049a16c
    mov ecx, dword ptr [ebp - local_288]         # 0049a173
    {load} xor edx, edx                          # 0049a179
    mov dl, byte ptr [ecx + field_50ed]          # 0049a17b
    mov eax, dword ptr [eax + 4*edx]             # 0049a181
    add eax, dword ptr [ebp - local_a8]          # 0049a184
    mov dword ptr [ebp - local_10c], eax         # 0049a18a
L_0049a190:
    # block 0x0049a190: entered by jmp at 0x0049a158, 5 instruction(s), ends with jne to 0x0049a1d7 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049a190
    {load} xor edx, edx                          # 0049a196
    mov dl, byte ptr [ecx + field_50f1]          # 0049a198
    test edx, edx                                # 0049a19e
    jne.d8 L_0049a1d7                            # 0049a1a0
    # block 0x0049a1a2: entered by fall-through of jne at 0x0049a1a0, 11 instruction(s), ends with forward jump to 0x0049a20a
    mov eax, dword ptr [ebp - local_30]          # 0049a1a2
    imul eax, eax, 0x154                         # 0049a1a5
    mov ecx, dword ptr [ebp - local_288]         # 0049a1ab
    lea edx, [ecx + eax + field_2491]            # 0049a1b1
    mov eax, dword ptr [ebp - local_288]         # 0049a1b8
    {load} xor ecx, ecx                          # 0049a1be
    mov cl, byte ptr [eax + field_50ee]          # 0049a1c0
    mov edx, dword ptr [edx + 4*ecx]             # 0049a1c6
    add edx, dword ptr [ebp - local_a8]          # 0049a1c9
    mov dword ptr [ebp - local_13c], edx         # 0049a1cf
    jmp.d8 L_0049a20a                            # 0049a1d5
L_0049a1d7:
    # block 0x0049a1d7: entered by jne at 0x0049a1a0, 10 instruction(s), falls into the block at 0x0049a20a
    mov eax, dword ptr [ebp - local_30]          # 0049a1d7
    imul eax, eax, 0xa0                          # 0049a1da
    mov ecx, dword ptr [ebp - local_288]         # 0049a1e0
    lea edx, [ecx + eax + field_2f31]            # 0049a1e6
    mov eax, dword ptr [ebp - local_288]         # 0049a1ed
    {load} xor ecx, ecx                          # 0049a1f3
    mov cl, byte ptr [eax + field_50ee]          # 0049a1f5
    mov edx, dword ptr [edx + 4*ecx]             # 0049a1fb
    add edx, dword ptr [ebp - local_a8]          # 0049a1fe
    mov dword ptr [ebp - local_13c], edx         # 0049a204
L_0049a20a:
    # block 0x0049a20a: entered by jmp at 0x0049a1d5, 2 instruction(s), ends with je to 0x0049a3cd (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0049a20a
    je.d32 L_0049a3cd                            # 0049a20e
    # block 0x0049a214: entered by fall-through of je at 0x0049a20e, 2 instruction(s), ends with forward jump to 0x0049a226
    mov dword ptr [ebp - local_74], 0x0          # 0049a214
    jmp.d8 L_0049a226                            # 0049a21b
L_0049a21d:
    # block 0x0049a21d: entered by jmp at 0x0049a3c3, 3 instruction(s), falls into the block at 0x0049a226
    mov eax, dword ptr [ebp - local_74]          # 0049a21d
    add eax, 0x1                                 # 0049a220
    mov dword ptr [ebp - local_74], eax          # 0049a223
L_0049a226:
    # block 0x0049a226: entered by jmp at 0x0049a21b, 3 instruction(s), ends with jge to 0x0049a3c8 (forward)
    mov ecx, dword ptr [ebp - local_74]          # 0049a226
    cmp ecx, dword ptr [ebp - local_130]         # 0049a229
    jge.d32 L_0049a3c8                           # 0049a22f
    # block 0x0049a235: entered by fall-through of jge at 0x0049a22f, 7 instruction(s), ends with jb to 0x0049a319 (forward)
    mov edx, dword ptr [ebp - local_120]         # 0049a235
    shr edx, 0x10                                # 0049a23b
    mov dword ptr [ebp - local_114], edx         # 0049a23e
    mov eax, dword ptr [ebp - local_288]         # 0049a244
    mov ecx, dword ptr [ebp - local_114]         # 0049a24a
    cmp ecx, dword ptr [eax + field_45b1]        # 0049a250
    jb.d32 L_0049a319                            # 0049a256
    # block 0x0049a25c: entered by fall-through of jb at 0x0049a256, 7 instruction(s), ends with je to 0x0049a2d9 (forward)
    mov edx, dword ptr [ebp - local_84]          # 0049a25c
    {load} xor eax, eax                          # 0049a262
    mov al, byte ptr [edx]                       # 0049a264
    mov ecx, dword ptr [ebp - local_b0]          # 0049a266
    and ecx, 0xff                                # 0049a26c
    {load} cmp eax, ecx                          # 0049a272
    je.d8 L_0049a2d9                             # 0049a274
    # block 0x0049a276: entered by fall-through of je at 0x0049a274, 16 instruction(s), ends with je to 0x0049a2d9 (forward)
    mov edx, dword ptr [ebp - local_114]         # 0049a276
    and edx, 0x7f                                # 0049a27c
    mov dword ptr [ebp - local_114], edx         # 0049a27f
    mov eax, dword ptr [ebp - local_114]         # 0049a285
    shl eax                                      # 0049a28b
    mov dword ptr [ebp - local_114], eax         # 0049a28d
    mov ecx, dword ptr [ebp - local_10c]         # 0049a293
    add ecx, dword ptr [ebp - local_114]         # 0049a299
    mov dx, word ptr [ecx]                       # 0049a29f
    mov word ptr [ebp - local_4], dx             # 0049a2a2
    mov eax, dword ptr [ebp - local_4]           # 0049a2a6
    and eax, 0xffff                              # 0049a2a9
    mov ecx, dword ptr [ebp - local_e0]          # 0049a2ae
    and ecx, 0xffff                              # 0049a2b4
    {load} cmp eax, ecx                          # 0049a2ba
    je.d8 L_0049a2d9                             # 0049a2bc
    # block 0x0049a2be: entered by fall-through of je at 0x0049a2bc, 6 instruction(s), falls into the block at 0x0049a2d9
    mov edx, dword ptr [ebp - local_160]         # 0049a2be
    mov ax, word ptr [ebp - local_4]             # 0049a2c4
    mov word ptr [edx], ax                       # 0049a2c8
    mov ecx, dword ptr [ebp - local_84]          # 0049a2cb
    mov dl, byte ptr [ebp - local_b0]            # 0049a2d1
    mov byte ptr [ecx], dl                       # 0049a2d7
L_0049a2d9:
    # block 0x0049a2d9: entered by je at 0x0049a274; je at 0x0049a2bc, 11 instruction(s), ends with forward jump to 0x0049a3c3
    mov eax, dword ptr [ebp - local_120]         # 0049a2d9
    sub eax, dword ptr [ebp - local_118]         # 0049a2df
    mov dword ptr [ebp - local_120], eax         # 0049a2e5
    mov ecx, dword ptr [ebp - local_288]         # 0049a2eb
    mov edx, dword ptr [ebp - local_160]         # 0049a2f1
    sub edx, dword ptr [ecx + field_1fff]        # 0049a2f7
    mov dword ptr [ebp - local_160], edx         # 0049a2fd
    mov eax, dword ptr [ebp - local_84]          # 0049a303
    sub eax, 0x218                               # 0049a309
    mov dword ptr [ebp - local_84], eax          # 0049a30e
    jmp.d32 L_0049a3c3                           # 0049a314
L_0049a319:
    # block 0x0049a319: entered by jb at 0x0049a256, 7 instruction(s), ends with je to 0x0049a387 (forward)
    mov ecx, dword ptr [ebp - local_84]          # 0049a319
    {load} xor edx, edx                          # 0049a31f
    mov dl, byte ptr [ecx]                       # 0049a321
    mov eax, dword ptr [ebp - local_b0]          # 0049a323
    and eax, 0xff                                # 0049a329
    {load} cmp edx, eax                          # 0049a32e
    je.d8 L_0049a387                             # 0049a330
    # block 0x0049a332: entered by fall-through of je at 0x0049a330, 13 instruction(s), ends with je to 0x0049a387 (forward)
    mov ecx, dword ptr [ebp - local_114]         # 0049a332
    shl ecx                                      # 0049a338
    mov dword ptr [ebp - local_114], ecx         # 0049a33a
    mov edx, dword ptr [ebp - local_13c]         # 0049a340
    add edx, dword ptr [ebp - local_114]         # 0049a346
    mov ax, word ptr [edx]                       # 0049a34c
    mov word ptr [ebp - local_4], ax             # 0049a34f
    mov ecx, dword ptr [ebp - local_4]           # 0049a353
    and ecx, 0xffff                              # 0049a356
    mov edx, dword ptr [ebp - local_e0]          # 0049a35c
    and edx, 0xffff                              # 0049a362
    {load} cmp ecx, edx                          # 0049a368
    je.d8 L_0049a387                             # 0049a36a
    # block 0x0049a36c: entered by fall-through of je at 0x0049a36a, 6 instruction(s), falls into the block at 0x0049a387
    mov eax, dword ptr [ebp - local_160]         # 0049a36c
    mov cx, word ptr [ebp - local_4]             # 0049a372
    mov word ptr [eax], cx                       # 0049a376
    mov edx, dword ptr [ebp - local_84]          # 0049a379
    mov al, byte ptr [ebp - local_b0]            # 0049a37f
    mov byte ptr [edx], al                       # 0049a385
L_0049a387:
    # block 0x0049a387: entered by je at 0x0049a330; je at 0x0049a36a, 10 instruction(s), falls into the block at 0x0049a3c3
    mov ecx, dword ptr [ebp - local_120]         # 0049a387
    sub ecx, dword ptr [ebp - local_118]         # 0049a38d
    mov dword ptr [ebp - local_120], ecx         # 0049a393
    mov edx, dword ptr [ebp - local_288]         # 0049a399
    mov eax, dword ptr [ebp - local_160]         # 0049a39f
    sub eax, dword ptr [edx + field_1fff]        # 0049a3a5
    mov dword ptr [ebp - local_160], eax         # 0049a3ab
    mov ecx, dword ptr [ebp - local_84]          # 0049a3b1
    sub ecx, 0x218                               # 0049a3b7
    mov dword ptr [ebp - local_84], ecx          # 0049a3bd
L_0049a3c3:
    # block 0x0049a3c3: entered by jmp at 0x0049a314, 1 instruction(s), ends with backward jump to 0x0049a21d
    jmp.d32 L_0049a21d                           # 0049a3c3
L_0049a3c8:
    # block 0x0049a3c8: entered by jge at 0x0049a22f, 1 instruction(s), ends with forward jump to 0x0049a54d
    jmp.d32 L_0049a54d                           # 0049a3c8
L_0049a3cd:
    # block 0x0049a3cd: entered by je at 0x0049a20e, 2 instruction(s), ends with forward jump to 0x0049a3df
    mov dword ptr [ebp - local_74], 0x0          # 0049a3cd
    jmp.d8 L_0049a3df                            # 0049a3d4
L_0049a3d6:
    # block 0x0049a3d6: entered by jmp at 0x0049a548, 3 instruction(s), falls into the block at 0x0049a3df
    mov edx, dword ptr [ebp - local_74]          # 0049a3d6
    add edx, 0x1                                 # 0049a3d9
    mov dword ptr [ebp - local_74], edx          # 0049a3dc
L_0049a3df:
    # block 0x0049a3df: entered by jmp at 0x0049a3d4, 3 instruction(s), ends with jge to 0x0049a54d (forward)
    mov eax, dword ptr [ebp - local_74]          # 0049a3df
    cmp eax, dword ptr [ebp - local_130]         # 0049a3e2
    jge.d32 L_0049a54d                           # 0049a3e8
    # block 0x0049a3ee: entered by fall-through of jge at 0x0049a3e8, 7 instruction(s), ends with jb to 0x0049a4b9 (forward)
    mov ecx, dword ptr [ebp - local_120]         # 0049a3ee
    shr ecx, 0x10                                # 0049a3f4
    mov dword ptr [ebp - local_114], ecx         # 0049a3f7
    mov edx, dword ptr [ebp - local_288]         # 0049a3fd
    mov eax, dword ptr [ebp - local_114]         # 0049a403
    cmp eax, dword ptr [edx + field_45b1]        # 0049a409
    jb.d32 L_0049a4b9                            # 0049a40f
    # block 0x0049a415: entered by fall-through of jb at 0x0049a40f, 16 instruction(s), ends with je to 0x0049a478 (forward)
    mov ecx, dword ptr [ebp - local_114]         # 0049a415
    and ecx, 0x7f                                # 0049a41b
    mov dword ptr [ebp - local_114], ecx         # 0049a41e
    mov edx, dword ptr [ebp - local_114]         # 0049a424
    shl edx                                      # 0049a42a
    mov dword ptr [ebp - local_114], edx         # 0049a42c
    mov eax, dword ptr [ebp - local_10c]         # 0049a432
    add eax, dword ptr [ebp - local_114]         # 0049a438
    mov cx, word ptr [eax]                       # 0049a43e
    mov word ptr [ebp - local_4], cx             # 0049a441
    mov edx, dword ptr [ebp - local_4]           # 0049a445
    and edx, 0xffff                              # 0049a448
    mov eax, dword ptr [ebp - local_e0]          # 0049a44e
    and eax, 0xffff                              # 0049a454
    {load} cmp edx, eax                          # 0049a459
    je.d8 L_0049a478                             # 0049a45b
    # block 0x0049a45d: entered by fall-through of je at 0x0049a45b, 6 instruction(s), falls into the block at 0x0049a478
    mov ecx, dword ptr [ebp - local_160]         # 0049a45d
    mov dx, word ptr [ebp - local_4]             # 0049a463
    mov word ptr [ecx], dx                       # 0049a467
    mov eax, dword ptr [ebp - local_84]          # 0049a46a
    mov cl, byte ptr [ebp - local_b0]            # 0049a470
    mov byte ptr [eax], cl                       # 0049a476
L_0049a478:
    # block 0x0049a478: entered by je at 0x0049a45b, 11 instruction(s), ends with forward jump to 0x0049a548
    mov edx, dword ptr [ebp - local_120]         # 0049a478
    sub edx, dword ptr [ebp - local_118]         # 0049a47e
    mov dword ptr [ebp - local_120], edx         # 0049a484
    mov eax, dword ptr [ebp - local_288]         # 0049a48a
    mov ecx, dword ptr [ebp - local_160]         # 0049a490
    sub ecx, dword ptr [eax + field_1fff]        # 0049a496
    mov dword ptr [ebp - local_160], ecx         # 0049a49c
    mov edx, dword ptr [ebp - local_84]          # 0049a4a2
    sub edx, 0x218                               # 0049a4a8
    mov dword ptr [ebp - local_84], edx          # 0049a4ae
    jmp.d32 L_0049a548                           # 0049a4b4
L_0049a4b9:
    # block 0x0049a4b9: entered by jb at 0x0049a40f, 13 instruction(s), ends with je to 0x0049a50d (forward)
    mov eax, dword ptr [ebp - local_114]         # 0049a4b9
    shl eax                                      # 0049a4bf
    mov dword ptr [ebp - local_114], eax         # 0049a4c1
    mov ecx, dword ptr [ebp - local_13c]         # 0049a4c7
    add ecx, dword ptr [ebp - local_114]         # 0049a4cd
    mov dx, word ptr [ecx]                       # 0049a4d3
    mov word ptr [ebp - local_4], dx             # 0049a4d6
    mov eax, dword ptr [ebp - local_4]           # 0049a4da
    and eax, 0xffff                              # 0049a4dd
    mov ecx, dword ptr [ebp - local_e0]          # 0049a4e2
    and ecx, 0xffff                              # 0049a4e8
    {load} cmp eax, ecx                          # 0049a4ee
    je.d8 L_0049a50d                             # 0049a4f0
    # block 0x0049a4f2: entered by fall-through of je at 0x0049a4f0, 6 instruction(s), falls into the block at 0x0049a50d
    mov edx, dword ptr [ebp - local_160]         # 0049a4f2
    mov ax, word ptr [ebp - local_4]             # 0049a4f8
    mov word ptr [edx], ax                       # 0049a4fc
    mov ecx, dword ptr [ebp - local_84]          # 0049a4ff
    mov dl, byte ptr [ebp - local_b0]            # 0049a505
    mov byte ptr [ecx], dl                       # 0049a50b
L_0049a50d:
    # block 0x0049a50d: entered by je at 0x0049a4f0, 10 instruction(s), falls into the block at 0x0049a548
    mov eax, dword ptr [ebp - local_120]         # 0049a50d
    sub eax, dword ptr [ebp - local_118]         # 0049a513
    mov dword ptr [ebp - local_120], eax         # 0049a519
    mov ecx, dword ptr [ebp - local_288]         # 0049a51f
    mov edx, dword ptr [ebp - local_160]         # 0049a525
    sub edx, dword ptr [ecx + field_1fff]        # 0049a52b
    mov dword ptr [ebp - local_160], edx         # 0049a531
    mov eax, dword ptr [ebp - local_84]          # 0049a537
    sub eax, 0x218                               # 0049a53d
    mov dword ptr [ebp - local_84], eax          # 0049a542
L_0049a548:
    # block 0x0049a548: entered by jmp at 0x0049a4b4, 1 instruction(s), ends with backward jump to 0x0049a3d6
    jmp.d32 L_0049a3d6                           # 0049a548
L_0049a54d:
    # block 0x0049a54d: entered by jmp at 0x0049a3c8; jge at 0x0049a3e8, 1 instruction(s), ends with forward jump to 0x0049ab7f
    jmp.d32 L_0049ab7f                           # 0049a54d
L_0049a552:
    # block 0x0049a552: entered by je at 0x00499eb5, 5 instruction(s), ends with jne to 0x0049a59c (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049a552
    {load} xor edx, edx                          # 0049a558
    mov dl, byte ptr [ecx + field_50f0]          # 0049a55a
    test edx, edx                                # 0049a560
    jne.d8 L_0049a59c                            # 0049a562
    # block 0x0049a564: entered by fall-through of jne at 0x0049a562, 11 instruction(s), ends with forward jump to 0x0049a5d2
    mov eax, dword ptr [ebp - local_94]          # 0049a564
    imul eax, eax, 0x154                         # 0049a56a
    mov ecx, dword ptr [ebp - local_288]         # 0049a570
    lea edx, [ecx + eax + field_2491]            # 0049a576
    mov eax, dword ptr [ebp - local_288]         # 0049a57d
    {load} xor ecx, ecx                          # 0049a583
    mov cl, byte ptr [eax + field_50ed]          # 0049a585
    mov edx, dword ptr [edx + 4*ecx]             # 0049a58b
    add edx, dword ptr [ebp - local_a8]          # 0049a58e
    mov dword ptr [ebp - local_10c], edx         # 0049a594
    jmp.d8 L_0049a5d2                            # 0049a59a
L_0049a59c:
    # block 0x0049a59c: entered by jne at 0x0049a562, 10 instruction(s), falls into the block at 0x0049a5d2
    mov eax, dword ptr [ebp - local_94]          # 0049a59c
    imul eax, eax, 0xa0                          # 0049a5a2
    mov ecx, dword ptr [ebp - local_288]         # 0049a5a8
    lea edx, [ecx + eax + field_2f31]            # 0049a5ae
    mov eax, dword ptr [ebp - local_288]         # 0049a5b5
    {load} xor ecx, ecx                          # 0049a5bb
    mov cl, byte ptr [eax + field_50ed]          # 0049a5bd
    mov edx, dword ptr [edx + 4*ecx]             # 0049a5c3
    add edx, dword ptr [ebp - local_a8]          # 0049a5c6
    mov dword ptr [ebp - local_10c], edx         # 0049a5cc
L_0049a5d2:
    # block 0x0049a5d2: entered by jmp at 0x0049a59a, 5 instruction(s), ends with jne to 0x0049a619 (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049a5d2
    {load} xor ecx, ecx                          # 0049a5d8
    mov cl, byte ptr [eax + field_50f1]          # 0049a5da
    test ecx, ecx                                # 0049a5e0
    jne.d8 L_0049a619                            # 0049a5e2
    # block 0x0049a5e4: entered by fall-through of jne at 0x0049a5e2, 11 instruction(s), ends with forward jump to 0x0049a64c
    mov edx, dword ptr [ebp - local_30]          # 0049a5e4
    imul edx, edx, 0x154                         # 0049a5e7
    mov eax, dword ptr [ebp - local_288]         # 0049a5ed
    lea ecx, [eax + edx + field_2491]            # 0049a5f3
    mov edx, dword ptr [ebp - local_288]         # 0049a5fa
    {load} xor eax, eax                          # 0049a600
    mov al, byte ptr [edx + field_50ee]          # 0049a602
    mov ecx, dword ptr [ecx + 4*eax]             # 0049a608
    add ecx, dword ptr [ebp - local_a8]          # 0049a60b
    mov dword ptr [ebp - local_13c], ecx         # 0049a611
    jmp.d8 L_0049a64c                            # 0049a617
L_0049a619:
    # block 0x0049a619: entered by jne at 0x0049a5e2, 10 instruction(s), falls into the block at 0x0049a64c
    mov edx, dword ptr [ebp - local_30]          # 0049a619
    imul edx, edx, 0xa0                          # 0049a61c
    mov eax, dword ptr [ebp - local_288]         # 0049a622
    lea ecx, [eax + edx + field_2f31]            # 0049a628
    mov edx, dword ptr [ebp - local_288]         # 0049a62f
    {load} xor eax, eax                          # 0049a635
    mov al, byte ptr [edx + field_50ee]          # 0049a637
    mov ecx, dword ptr [ecx + 4*eax]             # 0049a63d
    add ecx, dword ptr [ebp - local_a8]          # 0049a640
    mov dword ptr [ebp - local_13c], ecx         # 0049a646
L_0049a64c:
    # block 0x0049a64c: entered by jmp at 0x0049a617, 5 instruction(s), ends with jne to 0x0049a690 (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049a64c
    {load} xor eax, eax                          # 0049a652
    mov al, byte ptr [edx + field_50f2]          # 0049a654
    test eax, eax                                # 0049a65a
    jne.d8 L_0049a690                            # 0049a65c
    # block 0x0049a65e: entered by fall-through of jne at 0x0049a65c, 11 instruction(s), ends with forward jump to 0x0049a6c0
    mov ecx, dword ptr [ebp - local_14]          # 0049a65e
    imul ecx, ecx, 0x154                         # 0049a661
    mov edx, dword ptr [ebp - local_288]         # 0049a667
    lea eax, [edx + ecx + field_2491]            # 0049a66d
    mov ecx, dword ptr [ebp - local_288]         # 0049a674
    {load} xor edx, edx                          # 0049a67a
    mov dl, byte ptr [ecx + field_50ef]          # 0049a67c
    mov eax, dword ptr [eax + 4*edx]             # 0049a682
    add eax, dword ptr [ebp - local_a8]          # 0049a685
    mov dword ptr [ebp - local_60], eax          # 0049a68b
    jmp.d8 L_0049a6c0                            # 0049a68e
L_0049a690:
    # block 0x0049a690: entered by jne at 0x0049a65c, 10 instruction(s), falls into the block at 0x0049a6c0
    mov ecx, dword ptr [ebp - local_14]          # 0049a690
    imul ecx, ecx, 0xa0                          # 0049a693
    mov edx, dword ptr [ebp - local_288]         # 0049a699
    lea eax, [edx + ecx + field_2f31]            # 0049a69f
    mov ecx, dword ptr [ebp - local_288]         # 0049a6a6
    {load} xor edx, edx                          # 0049a6ac
    mov dl, byte ptr [ecx + field_50ef]          # 0049a6ae
    mov eax, dword ptr [eax + 4*edx]             # 0049a6b4
    add eax, dword ptr [ebp - local_a8]          # 0049a6b7
    mov dword ptr [ebp - local_60], eax          # 0049a6bd
L_0049a6c0:
    # block 0x0049a6c0: entered by jmp at 0x0049a68e, 2 instruction(s), ends with je to 0x0049a94e (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0049a6c0
    je.d32 L_0049a94e                            # 0049a6c4
    # block 0x0049a6ca: entered by fall-through of je at 0x0049a6c4, 2 instruction(s), ends with forward jump to 0x0049a6dc
    mov dword ptr [ebp - local_74], 0x0          # 0049a6ca
    jmp.d8 L_0049a6dc                            # 0049a6d1
L_0049a6d3:
    # block 0x0049a6d3: entered by jmp at 0x0049a944, 3 instruction(s), falls into the block at 0x0049a6dc
    mov ecx, dword ptr [ebp - local_74]          # 0049a6d3
    add ecx, 0x1                                 # 0049a6d6
    mov dword ptr [ebp - local_74], ecx          # 0049a6d9
L_0049a6dc:
    # block 0x0049a6dc: entered by jmp at 0x0049a6d1, 3 instruction(s), ends with jge to 0x0049a949 (forward)
    mov edx, dword ptr [ebp - local_74]          # 0049a6dc
    cmp edx, dword ptr [ebp - local_130]         # 0049a6df
    jge.d32 L_0049a949                           # 0049a6e5
    # block 0x0049a6eb: entered by fall-through of jge at 0x0049a6e5, 6 instruction(s), ends with jb to 0x0049a7c6 (forward)
    mov eax, dword ptr [ebp - local_120]         # 0049a6eb
    shr eax, 0x10                                # 0049a6f1
    mov dword ptr [ebp - local_114], eax         # 0049a6f4
    mov ecx, dword ptr [ebp - local_114]         # 0049a6fa
    cmp ecx, dword ptr [ebp - local_44]          # 0049a700
    jb.d32 L_0049a7c6                            # 0049a703
    # block 0x0049a709: entered by fall-through of jb at 0x0049a703, 7 instruction(s), ends with je to 0x0049a786 (forward)
    mov edx, dword ptr [ebp - local_84]          # 0049a709
    {load} xor eax, eax                          # 0049a70f
    mov al, byte ptr [edx]                       # 0049a711
    mov ecx, dword ptr [ebp - local_b0]          # 0049a713
    and ecx, 0xff                                # 0049a719
    {load} cmp eax, ecx                          # 0049a71f
    je.d8 L_0049a786                             # 0049a721
    # block 0x0049a723: entered by fall-through of je at 0x0049a721, 16 instruction(s), ends with je to 0x0049a786 (forward)
    mov edx, dword ptr [ebp - local_114]         # 0049a723
    and edx, 0x7f                                # 0049a729
    mov dword ptr [ebp - local_114], edx         # 0049a72c
    mov eax, dword ptr [ebp - local_114]         # 0049a732
    shl eax                                      # 0049a738
    mov dword ptr [ebp - local_114], eax         # 0049a73a
    mov ecx, dword ptr [ebp - local_10c]         # 0049a740
    add ecx, dword ptr [ebp - local_114]         # 0049a746
    mov dx, word ptr [ecx]                       # 0049a74c
    mov word ptr [ebp - local_4], dx             # 0049a74f
    mov eax, dword ptr [ebp - local_4]           # 0049a753
    and eax, 0xffff                              # 0049a756
    mov ecx, dword ptr [ebp - local_e0]          # 0049a75b
    and ecx, 0xffff                              # 0049a761
    {load} cmp eax, ecx                          # 0049a767
    je.d8 L_0049a786                             # 0049a769
    # block 0x0049a76b: entered by fall-through of je at 0x0049a769, 6 instruction(s), falls into the block at 0x0049a786
    mov edx, dword ptr [ebp - local_160]         # 0049a76b
    mov ax, word ptr [ebp - local_4]             # 0049a771
    mov word ptr [edx], ax                       # 0049a775
    mov ecx, dword ptr [ebp - local_84]          # 0049a778
    mov dl, byte ptr [ebp - local_b0]            # 0049a77e
    mov byte ptr [ecx], dl                       # 0049a784
L_0049a786:
    # block 0x0049a786: entered by je at 0x0049a721; je at 0x0049a769, 11 instruction(s), ends with forward jump to 0x0049a944
    mov eax, dword ptr [ebp - local_120]         # 0049a786
    sub eax, dword ptr [ebp - local_118]         # 0049a78c
    mov dword ptr [ebp - local_120], eax         # 0049a792
    mov ecx, dword ptr [ebp - local_288]         # 0049a798
    mov edx, dword ptr [ebp - local_160]         # 0049a79e
    sub edx, dword ptr [ecx + field_1fff]        # 0049a7a4
    mov dword ptr [ebp - local_160], edx         # 0049a7aa
    mov eax, dword ptr [ebp - local_84]          # 0049a7b0
    sub eax, 0x218                               # 0049a7b6
    mov dword ptr [ebp - local_84], eax          # 0049a7bb
    jmp.d32 L_0049a944                           # 0049a7c1
L_0049a7c6:
    # block 0x0049a7c6: entered by jb at 0x0049a703, 4 instruction(s), ends with jb to 0x0049a89d (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049a7c6
    mov edx, dword ptr [ebp - local_114]         # 0049a7cc
    cmp edx, dword ptr [ecx + field_45b1]        # 0049a7d2
    jb.d32 L_0049a89d                            # 0049a7d8
    # block 0x0049a7de: entered by fall-through of jb at 0x0049a7d8, 7 instruction(s), ends with je to 0x0049a85c (forward)
    mov eax, dword ptr [ebp - local_84]          # 0049a7de
    {load} xor ecx, ecx                          # 0049a7e4
    mov cl, byte ptr [eax]                       # 0049a7e6
    mov edx, dword ptr [ebp - local_b0]          # 0049a7e8
    and edx, 0xff                                # 0049a7ee
    {load} cmp ecx, edx                          # 0049a7f4
    je.d8 L_0049a85c                             # 0049a7f6
    # block 0x0049a7f8: entered by fall-through of je at 0x0049a7f6, 16 instruction(s), ends with je to 0x0049a85c (forward)
    mov eax, dword ptr [ebp - local_114]         # 0049a7f8
    and eax, 0x7f                                # 0049a7fe
    mov dword ptr [ebp - local_114], eax         # 0049a801
    mov ecx, dword ptr [ebp - local_114]         # 0049a807
    shl ecx                                      # 0049a80d
    mov dword ptr [ebp - local_114], ecx         # 0049a80f
    mov edx, dword ptr [ebp - local_13c]         # 0049a815
    add edx, dword ptr [ebp - local_114]         # 0049a81b
    mov ax, word ptr [edx]                       # 0049a821
    mov word ptr [ebp - local_4], ax             # 0049a824
    mov ecx, dword ptr [ebp - local_4]           # 0049a828
    and ecx, 0xffff                              # 0049a82b
    mov edx, dword ptr [ebp - local_e0]          # 0049a831
    and edx, 0xffff                              # 0049a837
    {load} cmp ecx, edx                          # 0049a83d
    je.d8 L_0049a85c                             # 0049a83f
    # block 0x0049a841: entered by fall-through of je at 0x0049a83f, 6 instruction(s), falls into the block at 0x0049a85c
    mov eax, dword ptr [ebp - local_160]         # 0049a841
    mov cx, word ptr [ebp - local_4]             # 0049a847
    mov word ptr [eax], cx                       # 0049a84b
    mov edx, dword ptr [ebp - local_84]          # 0049a84e
    mov al, byte ptr [ebp - local_b0]            # 0049a854
    mov byte ptr [edx], al                       # 0049a85a
L_0049a85c:
    # block 0x0049a85c: entered by je at 0x0049a7f6; je at 0x0049a83f, 11 instruction(s), ends with forward jump to 0x0049a944
    mov ecx, dword ptr [ebp - local_120]         # 0049a85c
    sub ecx, dword ptr [ebp - local_118]         # 0049a862
    mov dword ptr [ebp - local_120], ecx         # 0049a868
    mov edx, dword ptr [ebp - local_288]         # 0049a86e
    mov eax, dword ptr [ebp - local_160]         # 0049a874
    sub eax, dword ptr [edx + field_1fff]        # 0049a87a
    mov dword ptr [ebp - local_160], eax         # 0049a880
    mov ecx, dword ptr [ebp - local_84]          # 0049a886
    sub ecx, 0x218                               # 0049a88c
    mov dword ptr [ebp - local_84], ecx          # 0049a892
    jmp.d32 L_0049a944                           # 0049a898
L_0049a89d:
    # block 0x0049a89d: entered by jb at 0x0049a7d8, 7 instruction(s), ends with je to 0x0049a908 (forward)
    mov edx, dword ptr [ebp - local_84]          # 0049a89d
    {load} xor eax, eax                          # 0049a8a3
    mov al, byte ptr [edx]                       # 0049a8a5
    mov ecx, dword ptr [ebp - local_b0]          # 0049a8a7
    and ecx, 0xff                                # 0049a8ad
    {load} cmp eax, ecx                          # 0049a8b3
    je.d8 L_0049a908                             # 0049a8b5
    # block 0x0049a8b7: entered by fall-through of je at 0x0049a8b5, 13 instruction(s), ends with je to 0x0049a908 (forward)
    mov edx, dword ptr [ebp - local_114]         # 0049a8b7
    shl edx                                      # 0049a8bd
    mov dword ptr [ebp - local_114], edx         # 0049a8bf
    mov eax, dword ptr [ebp - local_60]          # 0049a8c5
    add eax, dword ptr [ebp - local_114]         # 0049a8c8
    mov cx, word ptr [eax]                       # 0049a8ce
    mov word ptr [ebp - local_4], cx             # 0049a8d1
    mov edx, dword ptr [ebp - local_4]           # 0049a8d5
    and edx, 0xffff                              # 0049a8d8
    mov eax, dword ptr [ebp - local_e0]          # 0049a8de
    and eax, 0xffff                              # 0049a8e4
    {load} cmp edx, eax                          # 0049a8e9
    je.d8 L_0049a908                             # 0049a8eb
    # block 0x0049a8ed: entered by fall-through of je at 0x0049a8eb, 6 instruction(s), falls into the block at 0x0049a908
    mov ecx, dword ptr [ebp - local_160]         # 0049a8ed
    mov dx, word ptr [ebp - local_4]             # 0049a8f3
    mov word ptr [ecx], dx                       # 0049a8f7
    mov eax, dword ptr [ebp - local_84]          # 0049a8fa
    mov cl, byte ptr [ebp - local_b0]            # 0049a900
    mov byte ptr [eax], cl                       # 0049a906
L_0049a908:
    # block 0x0049a908: entered by je at 0x0049a8b5; je at 0x0049a8eb, 10 instruction(s), falls into the block at 0x0049a944
    mov edx, dword ptr [ebp - local_120]         # 0049a908
    sub edx, dword ptr [ebp - local_118]         # 0049a90e
    mov dword ptr [ebp - local_120], edx         # 0049a914
    mov eax, dword ptr [ebp - local_288]         # 0049a91a
    mov ecx, dword ptr [ebp - local_160]         # 0049a920
    sub ecx, dword ptr [eax + field_1fff]        # 0049a926
    mov dword ptr [ebp - local_160], ecx         # 0049a92c
    mov edx, dword ptr [ebp - local_84]          # 0049a932
    sub edx, 0x218                               # 0049a938
    mov dword ptr [ebp - local_84], edx          # 0049a93e
L_0049a944:
    # block 0x0049a944: entered by jmp at 0x0049a7c1; jmp at 0x0049a898, 1 instruction(s), ends with backward jump to 0x0049a6d3
    jmp.d32 L_0049a6d3                           # 0049a944
L_0049a949:
    # block 0x0049a949: entered by jge at 0x0049a6e5, 1 instruction(s), ends with forward jump to 0x0049ab7f
    jmp.d32 L_0049ab7f                           # 0049a949
L_0049a94e:
    # block 0x0049a94e: entered by je at 0x0049a6c4, 2 instruction(s), ends with forward jump to 0x0049a960
    mov dword ptr [ebp - local_74], 0x0          # 0049a94e
    jmp.d8 L_0049a960                            # 0049a955
L_0049a957:
    # block 0x0049a957: entered by jmp at 0x0049ab7a, 3 instruction(s), falls into the block at 0x0049a960
    mov eax, dword ptr [ebp - local_74]          # 0049a957
    add eax, 0x1                                 # 0049a95a
    mov dword ptr [ebp - local_74], eax          # 0049a95d
L_0049a960:
    # block 0x0049a960: entered by jmp at 0x0049a955, 3 instruction(s), ends with jge to 0x0049ab7f (forward)
    mov ecx, dword ptr [ebp - local_74]          # 0049a960
    cmp ecx, dword ptr [ebp - local_130]         # 0049a963
    jge.d32 L_0049ab7f                           # 0049a969
    # block 0x0049a96f: entered by fall-through of jge at 0x0049a969, 6 instruction(s), ends with jb to 0x0049aa31 (forward)
    mov edx, dword ptr [ebp - local_120]         # 0049a96f
    shr edx, 0x10                                # 0049a975
    mov dword ptr [ebp - local_114], edx         # 0049a978
    mov eax, dword ptr [ebp - local_114]         # 0049a97e
    cmp eax, dword ptr [ebp - local_44]          # 0049a984
    jb.d32 L_0049aa31                            # 0049a987
    # block 0x0049a98d: entered by fall-through of jb at 0x0049a987, 16 instruction(s), ends with je to 0x0049a9f0 (forward)
    mov ecx, dword ptr [ebp - local_114]         # 0049a98d
    and ecx, 0x7f                                # 0049a993
    mov dword ptr [ebp - local_114], ecx         # 0049a996
    mov edx, dword ptr [ebp - local_114]         # 0049a99c
    shl edx                                      # 0049a9a2
    mov dword ptr [ebp - local_114], edx         # 0049a9a4
    mov eax, dword ptr [ebp - local_10c]         # 0049a9aa
    add eax, dword ptr [ebp - local_114]         # 0049a9b0
    mov cx, word ptr [eax]                       # 0049a9b6
    mov word ptr [ebp - local_4], cx             # 0049a9b9
    mov edx, dword ptr [ebp - local_4]           # 0049a9bd
    and edx, 0xffff                              # 0049a9c0
    mov eax, dword ptr [ebp - local_e0]          # 0049a9c6
    and eax, 0xffff                              # 0049a9cc
    {load} cmp edx, eax                          # 0049a9d1
    je.d8 L_0049a9f0                             # 0049a9d3
    # block 0x0049a9d5: entered by fall-through of je at 0x0049a9d3, 6 instruction(s), falls into the block at 0x0049a9f0
    mov ecx, dword ptr [ebp - local_160]         # 0049a9d5
    mov dx, word ptr [ebp - local_4]             # 0049a9db
    mov word ptr [ecx], dx                       # 0049a9df
    mov eax, dword ptr [ebp - local_84]          # 0049a9e2
    mov cl, byte ptr [ebp - local_b0]            # 0049a9e8
    mov byte ptr [eax], cl                       # 0049a9ee
L_0049a9f0:
    # block 0x0049a9f0: entered by je at 0x0049a9d3, 11 instruction(s), ends with forward jump to 0x0049ab7a
    mov edx, dword ptr [ebp - local_120]         # 0049a9f0
    sub edx, dword ptr [ebp - local_118]         # 0049a9f6
    mov dword ptr [ebp - local_120], edx         # 0049a9fc
    mov eax, dword ptr [ebp - local_288]         # 0049aa02
    mov ecx, dword ptr [ebp - local_160]         # 0049aa08
    sub ecx, dword ptr [eax + field_1fff]        # 0049aa0e
    mov dword ptr [ebp - local_160], ecx         # 0049aa14
    mov edx, dword ptr [ebp - local_84]          # 0049aa1a
    sub edx, 0x218                               # 0049aa20
    mov dword ptr [ebp - local_84], edx          # 0049aa26
    jmp.d32 L_0049ab7a                           # 0049aa2c
L_0049aa31:
    # block 0x0049aa31: entered by jb at 0x0049a987, 4 instruction(s), ends with jb to 0x0049aaec (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049aa31
    mov ecx, dword ptr [ebp - local_114]         # 0049aa37
    cmp ecx, dword ptr [eax + field_45b1]        # 0049aa3d
    jb.d32 L_0049aaec                            # 0049aa43
    # block 0x0049aa49: entered by fall-through of jb at 0x0049aa43, 16 instruction(s), ends with je to 0x0049aaac (forward)
    mov edx, dword ptr [ebp - local_114]         # 0049aa49
    and edx, 0x7f                                # 0049aa4f
    mov dword ptr [ebp - local_114], edx         # 0049aa52
    mov eax, dword ptr [ebp - local_114]         # 0049aa58
    shl eax                                      # 0049aa5e
    mov dword ptr [ebp - local_114], eax         # 0049aa60
    mov ecx, dword ptr [ebp - local_13c]         # 0049aa66
    add ecx, dword ptr [ebp - local_114]         # 0049aa6c
    mov dx, word ptr [ecx]                       # 0049aa72
    mov word ptr [ebp - local_4], dx             # 0049aa75
    mov eax, dword ptr [ebp - local_4]           # 0049aa79
    and eax, 0xffff                              # 0049aa7c
    mov ecx, dword ptr [ebp - local_e0]          # 0049aa81
    and ecx, 0xffff                              # 0049aa87
    {load} cmp eax, ecx                          # 0049aa8d
    je.d8 L_0049aaac                             # 0049aa8f
    # block 0x0049aa91: entered by fall-through of je at 0x0049aa8f, 6 instruction(s), falls into the block at 0x0049aaac
    mov edx, dword ptr [ebp - local_160]         # 0049aa91
    mov ax, word ptr [ebp - local_4]             # 0049aa97
    mov word ptr [edx], ax                       # 0049aa9b
    mov ecx, dword ptr [ebp - local_84]          # 0049aa9e
    mov dl, byte ptr [ebp - local_b0]            # 0049aaa4
    mov byte ptr [ecx], dl                       # 0049aaaa
L_0049aaac:
    # block 0x0049aaac: entered by je at 0x0049aa8f, 11 instruction(s), ends with forward jump to 0x0049ab7a
    mov eax, dword ptr [ebp - local_120]         # 0049aaac
    sub eax, dword ptr [ebp - local_118]         # 0049aab2
    mov dword ptr [ebp - local_120], eax         # 0049aab8
    mov ecx, dword ptr [ebp - local_288]         # 0049aabe
    mov edx, dword ptr [ebp - local_160]         # 0049aac4
    sub edx, dword ptr [ecx + field_1fff]        # 0049aaca
    mov dword ptr [ebp - local_160], edx         # 0049aad0
    mov eax, dword ptr [ebp - local_84]          # 0049aad6
    sub eax, 0x218                               # 0049aadc
    mov dword ptr [ebp - local_84], eax          # 0049aae1
    jmp.d32 L_0049ab7a                           # 0049aae7
L_0049aaec:
    # block 0x0049aaec: entered by jb at 0x0049aa43, 13 instruction(s), ends with je to 0x0049ab3e (forward)
    mov ecx, dword ptr [ebp - local_114]         # 0049aaec
    shl ecx                                      # 0049aaf2
    mov dword ptr [ebp - local_114], ecx         # 0049aaf4
    mov edx, dword ptr [ebp - local_60]          # 0049aafa
    add edx, dword ptr [ebp - local_114]         # 0049aafd
    mov ax, word ptr [edx]                       # 0049ab03
    mov word ptr [ebp - local_4], ax             # 0049ab06
    mov ecx, dword ptr [ebp - local_4]           # 0049ab0a
    and ecx, 0xffff                              # 0049ab0d
    mov edx, dword ptr [ebp - local_e0]          # 0049ab13
    and edx, 0xffff                              # 0049ab19
    {load} cmp ecx, edx                          # 0049ab1f
    je.d8 L_0049ab3e                             # 0049ab21
    # block 0x0049ab23: entered by fall-through of je at 0x0049ab21, 6 instruction(s), falls into the block at 0x0049ab3e
    mov eax, dword ptr [ebp - local_160]         # 0049ab23
    mov cx, word ptr [ebp - local_4]             # 0049ab29
    mov word ptr [eax], cx                       # 0049ab2d
    mov edx, dword ptr [ebp - local_84]          # 0049ab30
    mov al, byte ptr [ebp - local_b0]            # 0049ab36
    mov byte ptr [edx], al                       # 0049ab3c
L_0049ab3e:
    # block 0x0049ab3e: entered by je at 0x0049ab21, 10 instruction(s), falls into the block at 0x0049ab7a
    mov ecx, dword ptr [ebp - local_120]         # 0049ab3e
    sub ecx, dword ptr [ebp - local_118]         # 0049ab44
    mov dword ptr [ebp - local_120], ecx         # 0049ab4a
    mov edx, dword ptr [ebp - local_288]         # 0049ab50
    mov eax, dword ptr [ebp - local_160]         # 0049ab56
    sub eax, dword ptr [edx + field_1fff]        # 0049ab5c
    mov dword ptr [ebp - local_160], eax         # 0049ab62
    mov ecx, dword ptr [ebp - local_84]          # 0049ab68
    sub ecx, 0x218                               # 0049ab6e
    mov dword ptr [ebp - local_84], ecx          # 0049ab74
L_0049ab7a:
    # block 0x0049ab7a: entered by jmp at 0x0049aa2c; jmp at 0x0049aae7, 1 instruction(s), ends with backward jump to 0x0049a957
    jmp.d32 L_0049a957                           # 0049ab7a
L_0049ab7f:
    # block 0x0049ab7f: entered by jmp at 0x0049a10b; jmp at 0x0049a54d; jmp at 0x0049a949; jge at 0x0049a969, 1 instruction(s), ends with forward jump to 0x0049b97e
    jmp.d32 L_0049b97e                           # 0049ab7f
L_0049ab84:
    # block 0x0049ab84: entered by jne at 0x00499e6f; je at 0x00499e89, 5 instruction(s), ends with je to 0x0049b97e (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049ab84
    mov eax, dword ptr [edx + field_50e9]        # 0049ab8a
    and eax, 0x10000000                          # 0049ab90
    test eax, eax                                # 0049ab95
    je.d32 L_0049b97e                            # 0049ab97
    # block 0x0049ab9d: entered by fall-through of je at 0x0049ab97, 5 instruction(s), ends with je to 0x0049b97e (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049ab9d
    mov edx, dword ptr [ecx + field_50e9]        # 0049aba3
    and edx, 0x20000000                          # 0049aba9
    test edx, edx                                # 0049abaf
    je.d32 L_0049b97e                            # 0049abb1
    # block 0x0049abb7: entered by fall-through of je at 0x0049abb1, 5 instruction(s), ends with je to 0x0049ae5c (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049abb7
    mov ecx, dword ptr [eax + field_1f27]        # 0049abbd
    mov dword ptr [ebp - local_328], ecx         # 0049abc3
    cmp dword ptr [ebp - local_328], 0x2         # 0049abc9
    je.d32 L_0049ae5c                            # 0049abd0
    # block 0x0049abd6: entered by fall-through of je at 0x0049abd0, 2 instruction(s), ends with je to 0x0049b2e4 (forward)
    cmp dword ptr [ebp - local_328], 0x3         # 0049abd6
    je.d32 L_0049b2e4                            # 0049abdd
    # block 0x0049abe3: entered by fall-through of je at 0x0049abdd, 5 instruction(s), ends with jne to 0x0049ac2d (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049abe3
    {load} xor eax, eax                          # 0049abe9
    mov al, byte ptr [edx + field_50f0]          # 0049abeb
    test eax, eax                                # 0049abf1
    jne.d8 L_0049ac2d                            # 0049abf3
    # block 0x0049abf5: entered by fall-through of jne at 0x0049abf3, 11 instruction(s), ends with forward jump to 0x0049ac63
    mov ecx, dword ptr [ebp - local_94]          # 0049abf5
    imul ecx, ecx, 0x154                         # 0049abfb
    mov edx, dword ptr [ebp - local_288]         # 0049ac01
    lea eax, [edx + ecx + field_2491]            # 0049ac07
    mov ecx, dword ptr [ebp - local_288]         # 0049ac0e
    {load} xor edx, edx                          # 0049ac14
    mov dl, byte ptr [ecx + field_50ed]          # 0049ac16
    mov eax, dword ptr [eax + 4*edx]             # 0049ac1c
    add eax, dword ptr [ebp - local_a8]          # 0049ac1f
    mov dword ptr [ebp - local_88], eax          # 0049ac25
    jmp.d8 L_0049ac63                            # 0049ac2b
L_0049ac2d:
    # block 0x0049ac2d: entered by jne at 0x0049abf3, 10 instruction(s), falls into the block at 0x0049ac63
    mov ecx, dword ptr [ebp - local_94]          # 0049ac2d
    imul ecx, ecx, 0xa0                          # 0049ac33
    mov edx, dword ptr [ebp - local_288]         # 0049ac39
    lea eax, [edx + ecx + field_2f31]            # 0049ac3f
    mov ecx, dword ptr [ebp - local_288]         # 0049ac46
    {load} xor edx, edx                          # 0049ac4c
    mov dl, byte ptr [ecx + field_50ed]          # 0049ac4e
    mov eax, dword ptr [eax + 4*edx]             # 0049ac54
    add eax, dword ptr [ebp - local_a8]          # 0049ac57
    mov dword ptr [ebp - local_88], eax          # 0049ac5d
L_0049ac63:
    # block 0x0049ac63: entered by jmp at 0x0049ac2b, 2 instruction(s), ends with je to 0x0049ad71 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0049ac63
    je.d32 L_0049ad71                            # 0049ac67
    # block 0x0049ac6d: entered by fall-through of je at 0x0049ac67, 2 instruction(s), ends with forward jump to 0x0049ac7f
    mov dword ptr [ebp - local_74], 0x0          # 0049ac6d
    jmp.d8 L_0049ac7f                            # 0049ac74
L_0049ac76:
    # block 0x0049ac76: entered by jmp at 0x0049ad67, 3 instruction(s), falls into the block at 0x0049ac7f
    mov ecx, dword ptr [ebp - local_74]          # 0049ac76
    add ecx, 0x1                                 # 0049ac79
    mov dword ptr [ebp - local_74], ecx          # 0049ac7c
L_0049ac7f:
    # block 0x0049ac7f: entered by jmp at 0x0049ac74, 3 instruction(s), ends with jge to 0x0049ad6c (forward)
    mov edx, dword ptr [ebp - local_74]          # 0049ac7f
    cmp edx, dword ptr [ebp - local_130]         # 0049ac82
    jge.d32 L_0049ad6c                           # 0049ac88
    # block 0x0049ac8e: entered by fall-through of jge at 0x0049ac88, 5 instruction(s), ends with je to 0x0049ad1d (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049ac8e
    {load} xor ecx, ecx                          # 0049ac94
    mov cl, byte ptr [eax + field_50ed]          # 0049ac96
    test ecx, ecx                                # 0049ac9c
    je.d8 L_0049ad1d                             # 0049ac9e
    # block 0x0049aca0: entered by fall-through of je at 0x0049ac9e, 7 instruction(s), ends with je to 0x0049ad1d (forward)
    mov edx, dword ptr [ebp - local_84]          # 0049aca0
    {load} xor eax, eax                          # 0049aca6
    mov al, byte ptr [edx]                       # 0049aca8
    mov ecx, dword ptr [ebp - local_b0]          # 0049acaa
    and ecx, 0xff                                # 0049acb0
    {load} cmp eax, ecx                          # 0049acb6
    je.d8 L_0049ad1d                             # 0049acb8
    # block 0x0049acba: entered by fall-through of je at 0x0049acb8, 16 instruction(s), ends with je to 0x0049ad1d (forward)
    mov edx, dword ptr [ebp - local_120]         # 0049acba
    shr edx, 0x10                                # 0049acc0
    mov dword ptr [ebp - local_114], edx         # 0049acc3
    mov eax, dword ptr [ebp - local_114]         # 0049acc9
    shl eax                                      # 0049accf
    mov dword ptr [ebp - local_114], eax         # 0049acd1
    mov ecx, dword ptr [ebp - local_88]          # 0049acd7
    add ecx, dword ptr [ebp - local_114]         # 0049acdd
    mov dx, word ptr [ecx]                       # 0049ace3
    mov word ptr [ebp - local_4], dx             # 0049ace6
    mov eax, dword ptr [ebp - local_4]           # 0049acea
    and eax, 0xffff                              # 0049aced
    mov ecx, dword ptr [ebp - local_e0]          # 0049acf2
    and ecx, 0xffff                              # 0049acf8
    {load} cmp eax, ecx                          # 0049acfe
    je.d8 L_0049ad1d                             # 0049ad00
    # block 0x0049ad02: entered by fall-through of je at 0x0049ad00, 6 instruction(s), falls into the block at 0x0049ad1d
    mov edx, dword ptr [ebp - local_160]         # 0049ad02
    mov ax, word ptr [ebp - local_4]             # 0049ad08
    mov word ptr [edx], ax                       # 0049ad0c
    mov ecx, dword ptr [ebp - local_84]          # 0049ad0f
    mov dl, byte ptr [ebp - local_b0]            # 0049ad15
    mov byte ptr [ecx], dl                       # 0049ad1b
L_0049ad1d:
    # block 0x0049ad1d: entered by je at 0x0049ac9e; je at 0x0049acb8; je at 0x0049ad00, 3 instruction(s), ends with jbe to 0x0049ad3d (forward)
    mov eax, dword ptr [ebp - local_120]         # 0049ad1d
    cmp eax, dword ptr [ebp - local_118]         # 0049ad23
    jbe.d8 L_0049ad3d                            # 0049ad29
    # block 0x0049ad2b: entered by fall-through of jbe at 0x0049ad29, 3 instruction(s), falls into the block at 0x0049ad3d
    mov ecx, dword ptr [ebp - local_120]         # 0049ad2b
    sub ecx, dword ptr [ebp - local_118]         # 0049ad31
    mov dword ptr [ebp - local_120], ecx         # 0049ad37
L_0049ad3d:
    # block 0x0049ad3d: entered by jbe at 0x0049ad29, 8 instruction(s), ends with backward jump to 0x0049ac76
    mov edx, dword ptr [ebp - local_288]         # 0049ad3d
    mov eax, dword ptr [ebp - local_160]         # 0049ad43
    sub eax, dword ptr [edx + field_1fff]        # 0049ad49
    mov dword ptr [ebp - local_160], eax         # 0049ad4f
    mov ecx, dword ptr [ebp - local_84]          # 0049ad55
    sub ecx, 0x218                               # 0049ad5b
    mov dword ptr [ebp - local_84], ecx          # 0049ad61
    jmp.d32 L_0049ac76                           # 0049ad67
L_0049ad6c:
    # block 0x0049ad6c: entered by jge at 0x0049ac88, 1 instruction(s), ends with forward jump to 0x0049ae57
    jmp.d32 L_0049ae57                           # 0049ad6c
L_0049ad71:
    # block 0x0049ad71: entered by je at 0x0049ac67, 2 instruction(s), ends with forward jump to 0x0049ad83
    mov dword ptr [ebp - local_74], 0x0          # 0049ad71
    jmp.d8 L_0049ad83                            # 0049ad78
L_0049ad7a:
    # block 0x0049ad7a: entered by jmp at 0x0049ae52, 3 instruction(s), falls into the block at 0x0049ad83
    mov edx, dword ptr [ebp - local_74]          # 0049ad7a
    add edx, 0x1                                 # 0049ad7d
    mov dword ptr [ebp - local_74], edx          # 0049ad80
L_0049ad83:
    # block 0x0049ad83: entered by jmp at 0x0049ad78, 3 instruction(s), ends with jge to 0x0049ae57 (forward)
    mov eax, dword ptr [ebp - local_74]          # 0049ad83
    cmp eax, dword ptr [ebp - local_130]         # 0049ad86
    jge.d32 L_0049ae57                           # 0049ad8c
    # block 0x0049ad92: entered by fall-through of jge at 0x0049ad8c, 5 instruction(s), ends with je to 0x0049ae08 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049ad92
    {load} xor edx, edx                          # 0049ad98
    mov dl, byte ptr [ecx + field_50ed]          # 0049ad9a
    test edx, edx                                # 0049ada0
    je.d8 L_0049ae08                             # 0049ada2
    # block 0x0049ada4: entered by fall-through of je at 0x0049ada2, 16 instruction(s), ends with je to 0x0049ae08 (forward)
    mov eax, dword ptr [ebp - local_120]         # 0049ada4
    shr eax, 0x10                                # 0049adaa
    mov dword ptr [ebp - local_114], eax         # 0049adad
    mov ecx, dword ptr [ebp - local_114]         # 0049adb3
    shl ecx                                      # 0049adb9
    mov dword ptr [ebp - local_114], ecx         # 0049adbb
    mov edx, dword ptr [ebp - local_88]          # 0049adc1
    add edx, dword ptr [ebp - local_114]         # 0049adc7
    mov ax, word ptr [edx]                       # 0049adcd
    mov word ptr [ebp - local_4], ax             # 0049add0
    mov ecx, dword ptr [ebp - local_4]           # 0049add4
    and ecx, 0xffff                              # 0049add7
    mov edx, dword ptr [ebp - local_e0]          # 0049addd
    and edx, 0xffff                              # 0049ade3
    {load} cmp ecx, edx                          # 0049ade9
    je.d8 L_0049ae08                             # 0049adeb
    # block 0x0049aded: entered by fall-through of je at 0x0049adeb, 6 instruction(s), falls into the block at 0x0049ae08
    mov eax, dword ptr [ebp - local_160]         # 0049aded
    mov cx, word ptr [ebp - local_4]             # 0049adf3
    mov word ptr [eax], cx                       # 0049adf7
    mov edx, dword ptr [ebp - local_84]          # 0049adfa
    mov al, byte ptr [ebp - local_b0]            # 0049ae00
    mov byte ptr [edx], al                       # 0049ae06
L_0049ae08:
    # block 0x0049ae08: entered by je at 0x0049ada2; je at 0x0049adeb, 3 instruction(s), ends with jbe to 0x0049ae28 (forward)
    mov ecx, dword ptr [ebp - local_120]         # 0049ae08
    cmp ecx, dword ptr [ebp - local_118]         # 0049ae0e
    jbe.d8 L_0049ae28                            # 0049ae14
    # block 0x0049ae16: entered by fall-through of jbe at 0x0049ae14, 3 instruction(s), falls into the block at 0x0049ae28
    mov edx, dword ptr [ebp - local_120]         # 0049ae16
    sub edx, dword ptr [ebp - local_118]         # 0049ae1c
    mov dword ptr [ebp - local_120], edx         # 0049ae22
L_0049ae28:
    # block 0x0049ae28: entered by jbe at 0x0049ae14, 8 instruction(s), ends with backward jump to 0x0049ad7a
    mov eax, dword ptr [ebp - local_288]         # 0049ae28
    mov ecx, dword ptr [ebp - local_160]         # 0049ae2e
    sub ecx, dword ptr [eax + field_1fff]        # 0049ae34
    mov dword ptr [ebp - local_160], ecx         # 0049ae3a
    mov edx, dword ptr [ebp - local_84]          # 0049ae40
    sub edx, 0x218                               # 0049ae46
    mov dword ptr [ebp - local_84], edx          # 0049ae4c
    jmp.d32 L_0049ad7a                           # 0049ae52
L_0049ae57:
    # block 0x0049ae57: entered by jmp at 0x0049ad6c; jge at 0x0049ad8c, 1 instruction(s), ends with forward jump to 0x0049b97e
    jmp.d32 L_0049b97e                           # 0049ae57
L_0049ae5c:
    # block 0x0049ae5c: entered by je at 0x0049abd0, 5 instruction(s), ends with jne to 0x0049aea6 (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049ae5c
    {load} xor ecx, ecx                          # 0049ae62
    mov cl, byte ptr [eax + field_50f0]          # 0049ae64
    test ecx, ecx                                # 0049ae6a
    jne.d8 L_0049aea6                            # 0049ae6c
    # block 0x0049ae6e: entered by fall-through of jne at 0x0049ae6c, 11 instruction(s), ends with forward jump to 0x0049aedc
    mov edx, dword ptr [ebp - local_94]          # 0049ae6e
    imul edx, edx, 0x154                         # 0049ae74
    mov eax, dword ptr [ebp - local_288]         # 0049ae7a
    lea ecx, [eax + edx + field_2491]            # 0049ae80
    mov edx, dword ptr [ebp - local_288]         # 0049ae87
    {load} xor eax, eax                          # 0049ae8d
    mov al, byte ptr [edx + field_50ed]          # 0049ae8f
    mov ecx, dword ptr [ecx + 4*eax]             # 0049ae95
    add ecx, dword ptr [ebp - local_a8]          # 0049ae98
    mov dword ptr [ebp - local_10c], ecx         # 0049ae9e
    jmp.d8 L_0049aedc                            # 0049aea4
L_0049aea6:
    # block 0x0049aea6: entered by jne at 0x0049ae6c, 10 instruction(s), falls into the block at 0x0049aedc
    mov edx, dword ptr [ebp - local_94]          # 0049aea6
    imul edx, edx, 0xa0                          # 0049aeac
    mov eax, dword ptr [ebp - local_288]         # 0049aeb2
    lea ecx, [eax + edx + field_2f31]            # 0049aeb8
    mov edx, dword ptr [ebp - local_288]         # 0049aebf
    {load} xor eax, eax                          # 0049aec5
    mov al, byte ptr [edx + field_50ed]          # 0049aec7
    mov ecx, dword ptr [ecx + 4*eax]             # 0049aecd
    add ecx, dword ptr [ebp - local_a8]          # 0049aed0
    mov dword ptr [ebp - local_10c], ecx         # 0049aed6
L_0049aedc:
    # block 0x0049aedc: entered by jmp at 0x0049aea4, 5 instruction(s), ends with jne to 0x0049af23 (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049aedc
    {load} xor eax, eax                          # 0049aee2
    mov al, byte ptr [edx + field_50f1]          # 0049aee4
    test eax, eax                                # 0049aeea
    jne.d8 L_0049af23                            # 0049aeec
    # block 0x0049aeee: entered by fall-through of jne at 0x0049aeec, 11 instruction(s), ends with forward jump to 0x0049af56
    mov ecx, dword ptr [ebp - local_30]          # 0049aeee
    imul ecx, ecx, 0x154                         # 0049aef1
    mov edx, dword ptr [ebp - local_288]         # 0049aef7
    lea eax, [edx + ecx + field_2491]            # 0049aefd
    mov ecx, dword ptr [ebp - local_288]         # 0049af04
    {load} xor edx, edx                          # 0049af0a
    mov dl, byte ptr [ecx + field_50ee]          # 0049af0c
    mov eax, dword ptr [eax + 4*edx]             # 0049af12
    add eax, dword ptr [ebp - local_a8]          # 0049af15
    mov dword ptr [ebp - local_13c], eax         # 0049af1b
    jmp.d8 L_0049af56                            # 0049af21
L_0049af23:
    # block 0x0049af23: entered by jne at 0x0049aeec, 10 instruction(s), falls into the block at 0x0049af56
    mov ecx, dword ptr [ebp - local_30]          # 0049af23
    imul ecx, ecx, 0xa0                          # 0049af26
    mov edx, dword ptr [ebp - local_288]         # 0049af2c
    lea eax, [edx + ecx + field_2f31]            # 0049af32
    mov ecx, dword ptr [ebp - local_288]         # 0049af39
    {load} xor edx, edx                          # 0049af3f
    mov dl, byte ptr [ecx + field_50ee]          # 0049af41
    mov eax, dword ptr [eax + 4*edx]             # 0049af47
    add eax, dword ptr [ebp - local_a8]          # 0049af4a
    mov dword ptr [ebp - local_13c], eax         # 0049af50
L_0049af56:
    # block 0x0049af56: entered by jmp at 0x0049af21, 2 instruction(s), ends with je to 0x0049b13c (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0049af56
    je.d32 L_0049b13c                            # 0049af5a
    # block 0x0049af60: entered by fall-through of je at 0x0049af5a, 2 instruction(s), ends with forward jump to 0x0049af72
    mov dword ptr [ebp - local_74], 0x0          # 0049af60
    jmp.d8 L_0049af72                            # 0049af67
L_0049af69:
    # block 0x0049af69: entered by jmp at 0x0049b132, 3 instruction(s), falls into the block at 0x0049af72
    mov ecx, dword ptr [ebp - local_74]          # 0049af69
    add ecx, 0x1                                 # 0049af6c
    mov dword ptr [ebp - local_74], ecx          # 0049af6f
L_0049af72:
    # block 0x0049af72: entered by jmp at 0x0049af67, 3 instruction(s), ends with jge to 0x0049b137 (forward)
    mov edx, dword ptr [ebp - local_74]          # 0049af72
    cmp edx, dword ptr [ebp - local_130]         # 0049af75
    jge.d32 L_0049b137                           # 0049af7b
    # block 0x0049af81: entered by fall-through of jge at 0x0049af7b, 7 instruction(s), ends with jb to 0x0049b077 (forward)
    mov eax, dword ptr [ebp - local_120]         # 0049af81
    shr eax, 0x10                                # 0049af87
    mov dword ptr [ebp - local_114], eax         # 0049af8a
    mov ecx, dword ptr [ebp - local_288]         # 0049af90
    mov edx, dword ptr [ebp - local_114]         # 0049af96
    cmp edx, dword ptr [ecx + field_45b1]        # 0049af9c
    jb.d32 L_0049b077                            # 0049afa2
    # block 0x0049afa8: entered by fall-through of jb at 0x0049afa2, 5 instruction(s), ends with je to 0x0049b037 (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049afa8
    {load} xor ecx, ecx                          # 0049afae
    mov cl, byte ptr [eax + field_50ed]          # 0049afb0
    test ecx, ecx                                # 0049afb6
    je.d8 L_0049b037                             # 0049afb8
    # block 0x0049afba: entered by fall-through of je at 0x0049afb8, 7 instruction(s), ends with je to 0x0049b037 (forward)
    mov edx, dword ptr [ebp - local_84]          # 0049afba
    {load} xor eax, eax                          # 0049afc0
    mov al, byte ptr [edx]                       # 0049afc2
    mov ecx, dword ptr [ebp - local_b0]          # 0049afc4
    and ecx, 0xff                                # 0049afca
    {load} cmp eax, ecx                          # 0049afd0
    je.d8 L_0049b037                             # 0049afd2
    # block 0x0049afd4: entered by fall-through of je at 0x0049afd2, 16 instruction(s), ends with je to 0x0049b037 (forward)
    mov edx, dword ptr [ebp - local_114]         # 0049afd4
    and edx, 0x7f                                # 0049afda
    mov dword ptr [ebp - local_114], edx         # 0049afdd
    mov eax, dword ptr [ebp - local_114]         # 0049afe3
    shl eax                                      # 0049afe9
    mov dword ptr [ebp - local_114], eax         # 0049afeb
    mov ecx, dword ptr [ebp - local_10c]         # 0049aff1
    add ecx, dword ptr [ebp - local_114]         # 0049aff7
    mov dx, word ptr [ecx]                       # 0049affd
    mov word ptr [ebp - local_4], dx             # 0049b000
    mov eax, dword ptr [ebp - local_4]           # 0049b004
    and eax, 0xffff                              # 0049b007
    mov ecx, dword ptr [ebp - local_e0]          # 0049b00c
    and ecx, 0xffff                              # 0049b012
    {load} cmp eax, ecx                          # 0049b018
    je.d8 L_0049b037                             # 0049b01a
    # block 0x0049b01c: entered by fall-through of je at 0x0049b01a, 6 instruction(s), falls into the block at 0x0049b037
    mov edx, dword ptr [ebp - local_160]         # 0049b01c
    mov ax, word ptr [ebp - local_4]             # 0049b022
    mov word ptr [edx], ax                       # 0049b026
    mov ecx, dword ptr [ebp - local_84]          # 0049b029
    mov dl, byte ptr [ebp - local_b0]            # 0049b02f
    mov byte ptr [ecx], dl                       # 0049b035
L_0049b037:
    # block 0x0049b037: entered by je at 0x0049afb8; je at 0x0049afd2; je at 0x0049b01a, 11 instruction(s), ends with forward jump to 0x0049b132
    mov eax, dword ptr [ebp - local_120]         # 0049b037
    sub eax, dword ptr [ebp - local_118]         # 0049b03d
    mov dword ptr [ebp - local_120], eax         # 0049b043
    mov ecx, dword ptr [ebp - local_288]         # 0049b049
    mov edx, dword ptr [ebp - local_160]         # 0049b04f
    sub edx, dword ptr [ecx + field_1fff]        # 0049b055
    mov dword ptr [ebp - local_160], edx         # 0049b05b
    mov eax, dword ptr [ebp - local_84]          # 0049b061
    sub eax, 0x218                               # 0049b067
    mov dword ptr [ebp - local_84], eax          # 0049b06c
    jmp.d32 L_0049b132                           # 0049b072
L_0049b077:
    # block 0x0049b077: entered by jb at 0x0049afa2, 5 instruction(s), ends with je to 0x0049b0f7 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049b077
    {load} xor edx, edx                          # 0049b07d
    mov dl, byte ptr [ecx + field_50ee]          # 0049b07f
    test edx, edx                                # 0049b085
    je.d8 L_0049b0f7                             # 0049b087
    # block 0x0049b089: entered by fall-through of je at 0x0049b087, 7 instruction(s), ends with je to 0x0049b0f7 (forward)
    mov eax, dword ptr [ebp - local_84]          # 0049b089
    {load} xor ecx, ecx                          # 0049b08f
    mov cl, byte ptr [eax]                       # 0049b091
    mov edx, dword ptr [ebp - local_b0]          # 0049b093
    and edx, 0xff                                # 0049b099
    {load} cmp ecx, edx                          # 0049b09f
    je.d8 L_0049b0f7                             # 0049b0a1
    # block 0x0049b0a3: entered by fall-through of je at 0x0049b0a1, 13 instruction(s), ends with je to 0x0049b0f7 (forward)
    mov eax, dword ptr [ebp - local_114]         # 0049b0a3
    shl eax                                      # 0049b0a9
    mov dword ptr [ebp - local_114], eax         # 0049b0ab
    mov ecx, dword ptr [ebp - local_13c]         # 0049b0b1
    add ecx, dword ptr [ebp - local_114]         # 0049b0b7
    mov dx, word ptr [ecx]                       # 0049b0bd
    mov word ptr [ebp - local_4], dx             # 0049b0c0
    mov eax, dword ptr [ebp - local_4]           # 0049b0c4
    and eax, 0xffff                              # 0049b0c7
    mov ecx, dword ptr [ebp - local_e0]          # 0049b0cc
    and ecx, 0xffff                              # 0049b0d2
    {load} cmp eax, ecx                          # 0049b0d8
    je.d8 L_0049b0f7                             # 0049b0da
    # block 0x0049b0dc: entered by fall-through of je at 0x0049b0da, 6 instruction(s), falls into the block at 0x0049b0f7
    mov edx, dword ptr [ebp - local_160]         # 0049b0dc
    mov ax, word ptr [ebp - local_4]             # 0049b0e2
    mov word ptr [edx], ax                       # 0049b0e6
    mov ecx, dword ptr [ebp - local_84]          # 0049b0e9
    mov dl, byte ptr [ebp - local_b0]            # 0049b0ef
    mov byte ptr [ecx], dl                       # 0049b0f5
L_0049b0f7:
    # block 0x0049b0f7: entered by je at 0x0049b087; je at 0x0049b0a1; je at 0x0049b0da, 10 instruction(s), falls into the block at 0x0049b132
    mov eax, dword ptr [ebp - local_120]         # 0049b0f7
    sub eax, dword ptr [ebp - local_118]         # 0049b0fd
    mov dword ptr [ebp - local_120], eax         # 0049b103
    mov ecx, dword ptr [ebp - local_288]         # 0049b109
    mov edx, dword ptr [ebp - local_160]         # 0049b10f
    sub edx, dword ptr [ecx + field_1fff]        # 0049b115
    mov dword ptr [ebp - local_160], edx         # 0049b11b
    mov eax, dword ptr [ebp - local_84]          # 0049b121
    sub eax, 0x218                               # 0049b127
    mov dword ptr [ebp - local_84], eax          # 0049b12c
L_0049b132:
    # block 0x0049b132: entered by jmp at 0x0049b072, 1 instruction(s), ends with backward jump to 0x0049af69
    jmp.d32 L_0049af69                           # 0049b132
L_0049b137:
    # block 0x0049b137: entered by jge at 0x0049af7b, 1 instruction(s), ends with forward jump to 0x0049b2df
    jmp.d32 L_0049b2df                           # 0049b137
L_0049b13c:
    # block 0x0049b13c: entered by je at 0x0049af5a, 2 instruction(s), ends with forward jump to 0x0049b14e
    mov dword ptr [ebp - local_74], 0x0          # 0049b13c
    jmp.d8 L_0049b14e                            # 0049b143
L_0049b145:
    # block 0x0049b145: entered by jmp at 0x0049b2da, 3 instruction(s), falls into the block at 0x0049b14e
    mov ecx, dword ptr [ebp - local_74]          # 0049b145
    add ecx, 0x1                                 # 0049b148
    mov dword ptr [ebp - local_74], ecx          # 0049b14b
L_0049b14e:
    # block 0x0049b14e: entered by jmp at 0x0049b143, 3 instruction(s), ends with jge to 0x0049b2df (forward)
    mov edx, dword ptr [ebp - local_74]          # 0049b14e
    cmp edx, dword ptr [ebp - local_130]         # 0049b151
    jge.d32 L_0049b2df                           # 0049b157
    # block 0x0049b15d: entered by fall-through of jge at 0x0049b157, 7 instruction(s), ends with jb to 0x0049b239 (forward)
    mov eax, dword ptr [ebp - local_120]         # 0049b15d
    shr eax, 0x10                                # 0049b163
    mov dword ptr [ebp - local_114], eax         # 0049b166
    mov ecx, dword ptr [ebp - local_288]         # 0049b16c
    mov edx, dword ptr [ebp - local_114]         # 0049b172
    cmp edx, dword ptr [ecx + field_45b1]        # 0049b178
    jb.d32 L_0049b239                            # 0049b17e
    # block 0x0049b184: entered by fall-through of jb at 0x0049b17e, 5 instruction(s), ends with je to 0x0049b1f9 (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049b184
    {load} xor ecx, ecx                          # 0049b18a
    mov cl, byte ptr [eax + field_50ed]          # 0049b18c
    test ecx, ecx                                # 0049b192
    je.d8 L_0049b1f9                             # 0049b194
    # block 0x0049b196: entered by fall-through of je at 0x0049b194, 16 instruction(s), ends with je to 0x0049b1f9 (forward)
    mov edx, dword ptr [ebp - local_114]         # 0049b196
    and edx, 0x7f                                # 0049b19c
    mov dword ptr [ebp - local_114], edx         # 0049b19f
    mov eax, dword ptr [ebp - local_114]         # 0049b1a5
    shl eax                                      # 0049b1ab
    mov dword ptr [ebp - local_114], eax         # 0049b1ad
    mov ecx, dword ptr [ebp - local_10c]         # 0049b1b3
    add ecx, dword ptr [ebp - local_114]         # 0049b1b9
    mov dx, word ptr [ecx]                       # 0049b1bf
    mov word ptr [ebp - local_4], dx             # 0049b1c2
    mov eax, dword ptr [ebp - local_4]           # 0049b1c6
    and eax, 0xffff                              # 0049b1c9
    mov ecx, dword ptr [ebp - local_e0]          # 0049b1ce
    and ecx, 0xffff                              # 0049b1d4
    {load} cmp eax, ecx                          # 0049b1da
    je.d8 L_0049b1f9                             # 0049b1dc
    # block 0x0049b1de: entered by fall-through of je at 0x0049b1dc, 6 instruction(s), falls into the block at 0x0049b1f9
    mov edx, dword ptr [ebp - local_160]         # 0049b1de
    mov ax, word ptr [ebp - local_4]             # 0049b1e4
    mov word ptr [edx], ax                       # 0049b1e8
    mov ecx, dword ptr [ebp - local_84]          # 0049b1eb
    mov dl, byte ptr [ebp - local_b0]            # 0049b1f1
    mov byte ptr [ecx], dl                       # 0049b1f7
L_0049b1f9:
    # block 0x0049b1f9: entered by je at 0x0049b194; je at 0x0049b1dc, 11 instruction(s), ends with forward jump to 0x0049b2da
    mov eax, dword ptr [ebp - local_120]         # 0049b1f9
    sub eax, dword ptr [ebp - local_118]         # 0049b1ff
    mov dword ptr [ebp - local_120], eax         # 0049b205
    mov ecx, dword ptr [ebp - local_288]         # 0049b20b
    mov edx, dword ptr [ebp - local_160]         # 0049b211
    sub edx, dword ptr [ecx + field_1fff]        # 0049b217
    mov dword ptr [ebp - local_160], edx         # 0049b21d
    mov eax, dword ptr [ebp - local_84]          # 0049b223
    sub eax, 0x218                               # 0049b229
    mov dword ptr [ebp - local_84], eax          # 0049b22e
    jmp.d32 L_0049b2da                           # 0049b234
L_0049b239:
    # block 0x0049b239: entered by jb at 0x0049b17e, 5 instruction(s), ends with je to 0x0049b29f (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049b239
    {load} xor edx, edx                          # 0049b23f
    mov dl, byte ptr [ecx + field_50ee]          # 0049b241
    test edx, edx                                # 0049b247
    je.d8 L_0049b29f                             # 0049b249
    # block 0x0049b24b: entered by fall-through of je at 0x0049b249, 13 instruction(s), ends with je to 0x0049b29f (forward)
    mov eax, dword ptr [ebp - local_114]         # 0049b24b
    shl eax                                      # 0049b251
    mov dword ptr [ebp - local_114], eax         # 0049b253
    mov ecx, dword ptr [ebp - local_13c]         # 0049b259
    add ecx, dword ptr [ebp - local_114]         # 0049b25f
    mov dx, word ptr [ecx]                       # 0049b265
    mov word ptr [ebp - local_4], dx             # 0049b268
    mov eax, dword ptr [ebp - local_4]           # 0049b26c
    and eax, 0xffff                              # 0049b26f
    mov ecx, dword ptr [ebp - local_e0]          # 0049b274
    and ecx, 0xffff                              # 0049b27a
    {load} cmp eax, ecx                          # 0049b280
    je.d8 L_0049b29f                             # 0049b282
    # block 0x0049b284: entered by fall-through of je at 0x0049b282, 6 instruction(s), falls into the block at 0x0049b29f
    mov edx, dword ptr [ebp - local_160]         # 0049b284
    mov ax, word ptr [ebp - local_4]             # 0049b28a
    mov word ptr [edx], ax                       # 0049b28e
    mov ecx, dword ptr [ebp - local_84]          # 0049b291
    mov dl, byte ptr [ebp - local_b0]            # 0049b297
    mov byte ptr [ecx], dl                       # 0049b29d
L_0049b29f:
    # block 0x0049b29f: entered by je at 0x0049b249; je at 0x0049b282, 10 instruction(s), falls into the block at 0x0049b2da
    mov eax, dword ptr [ebp - local_120]         # 0049b29f
    sub eax, dword ptr [ebp - local_118]         # 0049b2a5
    mov dword ptr [ebp - local_120], eax         # 0049b2ab
    mov ecx, dword ptr [ebp - local_288]         # 0049b2b1
    mov edx, dword ptr [ebp - local_160]         # 0049b2b7
    sub edx, dword ptr [ecx + field_1fff]        # 0049b2bd
    mov dword ptr [ebp - local_160], edx         # 0049b2c3
    mov eax, dword ptr [ebp - local_84]          # 0049b2c9
    sub eax, 0x218                               # 0049b2cf
    mov dword ptr [ebp - local_84], eax          # 0049b2d4
L_0049b2da:
    # block 0x0049b2da: entered by jmp at 0x0049b234, 1 instruction(s), ends with backward jump to 0x0049b145
    jmp.d32 L_0049b145                           # 0049b2da
L_0049b2df:
    # block 0x0049b2df: entered by jmp at 0x0049b137; jge at 0x0049b157, 1 instruction(s), ends with forward jump to 0x0049b97e
    jmp.d32 L_0049b97e                           # 0049b2df
L_0049b2e4:
    # block 0x0049b2e4: entered by je at 0x0049abdd, 5 instruction(s), ends with jne to 0x0049b32e (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049b2e4
    {load} xor edx, edx                          # 0049b2ea
    mov dl, byte ptr [ecx + field_50f0]          # 0049b2ec
    test edx, edx                                # 0049b2f2
    jne.d8 L_0049b32e                            # 0049b2f4
    # block 0x0049b2f6: entered by fall-through of jne at 0x0049b2f4, 11 instruction(s), ends with forward jump to 0x0049b364
    mov eax, dword ptr [ebp - local_94]          # 0049b2f6
    imul eax, eax, 0x154                         # 0049b2fc
    mov ecx, dword ptr [ebp - local_288]         # 0049b302
    lea edx, [ecx + eax + field_2491]            # 0049b308
    mov eax, dword ptr [ebp - local_288]         # 0049b30f
    {load} xor ecx, ecx                          # 0049b315
    mov cl, byte ptr [eax + field_50ed]          # 0049b317
    mov edx, dword ptr [edx + 4*ecx]             # 0049b31d
    add edx, dword ptr [ebp - local_a8]          # 0049b320
    mov dword ptr [ebp - local_10c], edx         # 0049b326
    jmp.d8 L_0049b364                            # 0049b32c
L_0049b32e:
    # block 0x0049b32e: entered by jne at 0x0049b2f4, 10 instruction(s), falls into the block at 0x0049b364
    mov eax, dword ptr [ebp - local_94]          # 0049b32e
    imul eax, eax, 0xa0                          # 0049b334
    mov ecx, dword ptr [ebp - local_288]         # 0049b33a
    lea edx, [ecx + eax + field_2f31]            # 0049b340
    mov eax, dword ptr [ebp - local_288]         # 0049b347
    {load} xor ecx, ecx                          # 0049b34d
    mov cl, byte ptr [eax + field_50ed]          # 0049b34f
    mov edx, dword ptr [edx + 4*ecx]             # 0049b355
    add edx, dword ptr [ebp - local_a8]          # 0049b358
    mov dword ptr [ebp - local_10c], edx         # 0049b35e
L_0049b364:
    # block 0x0049b364: entered by jmp at 0x0049b32c, 5 instruction(s), ends with jne to 0x0049b3ab (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049b364
    {load} xor ecx, ecx                          # 0049b36a
    mov cl, byte ptr [eax + field_50f1]          # 0049b36c
    test ecx, ecx                                # 0049b372
    jne.d8 L_0049b3ab                            # 0049b374
    # block 0x0049b376: entered by fall-through of jne at 0x0049b374, 11 instruction(s), ends with forward jump to 0x0049b3de
    mov edx, dword ptr [ebp - local_30]          # 0049b376
    imul edx, edx, 0x154                         # 0049b379
    mov eax, dword ptr [ebp - local_288]         # 0049b37f
    lea ecx, [eax + edx + field_2491]            # 0049b385
    mov edx, dword ptr [ebp - local_288]         # 0049b38c
    {load} xor eax, eax                          # 0049b392
    mov al, byte ptr [edx + field_50ee]          # 0049b394
    mov ecx, dword ptr [ecx + 4*eax]             # 0049b39a
    add ecx, dword ptr [ebp - local_a8]          # 0049b39d
    mov dword ptr [ebp - local_13c], ecx         # 0049b3a3
    jmp.d8 L_0049b3de                            # 0049b3a9
L_0049b3ab:
    # block 0x0049b3ab: entered by jne at 0x0049b374, 10 instruction(s), falls into the block at 0x0049b3de
    mov edx, dword ptr [ebp - local_30]          # 0049b3ab
    imul edx, edx, 0xa0                          # 0049b3ae
    mov eax, dword ptr [ebp - local_288]         # 0049b3b4
    lea ecx, [eax + edx + field_2f31]            # 0049b3ba
    mov edx, dword ptr [ebp - local_288]         # 0049b3c1
    {load} xor eax, eax                          # 0049b3c7
    mov al, byte ptr [edx + field_50ee]          # 0049b3c9
    mov ecx, dword ptr [ecx + 4*eax]             # 0049b3cf
    add ecx, dword ptr [ebp - local_a8]          # 0049b3d2
    mov dword ptr [ebp - local_13c], ecx         # 0049b3d8
L_0049b3de:
    # block 0x0049b3de: entered by jmp at 0x0049b3a9, 5 instruction(s), ends with jne to 0x0049b422 (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049b3de
    {load} xor eax, eax                          # 0049b3e4
    mov al, byte ptr [edx + field_50f2]          # 0049b3e6
    test eax, eax                                # 0049b3ec
    jne.d8 L_0049b422                            # 0049b3ee
    # block 0x0049b3f0: entered by fall-through of jne at 0x0049b3ee, 11 instruction(s), ends with forward jump to 0x0049b452
    mov ecx, dword ptr [ebp - local_14]          # 0049b3f0
    imul ecx, ecx, 0x154                         # 0049b3f3
    mov edx, dword ptr [ebp - local_288]         # 0049b3f9
    lea eax, [edx + ecx + field_2491]            # 0049b3ff
    mov ecx, dword ptr [ebp - local_288]         # 0049b406
    {load} xor edx, edx                          # 0049b40c
    mov dl, byte ptr [ecx + field_50ef]          # 0049b40e
    mov eax, dword ptr [eax + 4*edx]             # 0049b414
    add eax, dword ptr [ebp - local_a8]          # 0049b417
    mov dword ptr [ebp - local_60], eax          # 0049b41d
    jmp.d8 L_0049b452                            # 0049b420
L_0049b422:
    # block 0x0049b422: entered by jne at 0x0049b3ee, 10 instruction(s), falls into the block at 0x0049b452
    mov ecx, dword ptr [ebp - local_14]          # 0049b422
    imul ecx, ecx, 0xa0                          # 0049b425
    mov edx, dword ptr [ebp - local_288]         # 0049b42b
    lea eax, [edx + ecx + field_2f31]            # 0049b431
    mov ecx, dword ptr [ebp - local_288]         # 0049b438
    {load} xor edx, edx                          # 0049b43e
    mov dl, byte ptr [ecx + field_50ef]          # 0049b440
    mov eax, dword ptr [eax + 4*edx]             # 0049b446
    add eax, dword ptr [ebp - local_a8]          # 0049b449
    mov dword ptr [ebp - local_60], eax          # 0049b44f
L_0049b452:
    # block 0x0049b452: entered by jmp at 0x0049b420, 2 instruction(s), ends with je to 0x0049b714 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0049b452
    je.d32 L_0049b714                            # 0049b456
    # block 0x0049b45c: entered by fall-through of je at 0x0049b456, 2 instruction(s), ends with forward jump to 0x0049b46e
    mov dword ptr [ebp - local_74], 0x0          # 0049b45c
    jmp.d8 L_0049b46e                            # 0049b463
L_0049b465:
    # block 0x0049b465: entered by jmp at 0x0049b70a, 3 instruction(s), falls into the block at 0x0049b46e
    mov ecx, dword ptr [ebp - local_74]          # 0049b465
    add ecx, 0x1                                 # 0049b468
    mov dword ptr [ebp - local_74], ecx          # 0049b46b
L_0049b46e:
    # block 0x0049b46e: entered by jmp at 0x0049b463, 3 instruction(s), ends with jge to 0x0049b70f (forward)
    mov edx, dword ptr [ebp - local_74]          # 0049b46e
    cmp edx, dword ptr [ebp - local_130]         # 0049b471
    jge.d32 L_0049b70f                           # 0049b477
    # block 0x0049b47d: entered by fall-through of jge at 0x0049b477, 6 instruction(s), ends with jb to 0x0049b56a (forward)
    mov eax, dword ptr [ebp - local_120]         # 0049b47d
    shr eax, 0x10                                # 0049b483
    mov dword ptr [ebp - local_114], eax         # 0049b486
    mov ecx, dword ptr [ebp - local_114]         # 0049b48c
    cmp ecx, dword ptr [ebp - local_44]          # 0049b492
    jb.d32 L_0049b56a                            # 0049b495
    # block 0x0049b49b: entered by fall-through of jb at 0x0049b495, 5 instruction(s), ends with je to 0x0049b529 (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049b49b
    {load} xor eax, eax                          # 0049b4a1
    mov al, byte ptr [edx + field_50ed]          # 0049b4a3
    test eax, eax                                # 0049b4a9
    je.d8 L_0049b529                             # 0049b4ab
    # block 0x0049b4ad: entered by fall-through of je at 0x0049b4ab, 7 instruction(s), ends with je to 0x0049b529 (forward)
    mov ecx, dword ptr [ebp - local_84]          # 0049b4ad
    {load} xor edx, edx                          # 0049b4b3
    mov dl, byte ptr [ecx]                       # 0049b4b5
    mov eax, dword ptr [ebp - local_b0]          # 0049b4b7
    and eax, 0xff                                # 0049b4bd
    {load} cmp edx, eax                          # 0049b4c2
    je.d8 L_0049b529                             # 0049b4c4
    # block 0x0049b4c6: entered by fall-through of je at 0x0049b4c4, 16 instruction(s), ends with je to 0x0049b529 (forward)
    mov ecx, dword ptr [ebp - local_114]         # 0049b4c6
    and ecx, 0x7f                                # 0049b4cc
    mov dword ptr [ebp - local_114], ecx         # 0049b4cf
    mov edx, dword ptr [ebp - local_114]         # 0049b4d5
    shl edx                                      # 0049b4db
    mov dword ptr [ebp - local_114], edx         # 0049b4dd
    mov eax, dword ptr [ebp - local_10c]         # 0049b4e3
    add eax, dword ptr [ebp - local_114]         # 0049b4e9
    mov cx, word ptr [eax]                       # 0049b4ef
    mov word ptr [ebp - local_4], cx             # 0049b4f2
    mov edx, dword ptr [ebp - local_4]           # 0049b4f6
    and edx, 0xffff                              # 0049b4f9
    mov eax, dword ptr [ebp - local_e0]          # 0049b4ff
    and eax, 0xffff                              # 0049b505
    {load} cmp edx, eax                          # 0049b50a
    je.d8 L_0049b529                             # 0049b50c
    # block 0x0049b50e: entered by fall-through of je at 0x0049b50c, 6 instruction(s), falls into the block at 0x0049b529
    mov ecx, dword ptr [ebp - local_160]         # 0049b50e
    mov dx, word ptr [ebp - local_4]             # 0049b514
    mov word ptr [ecx], dx                       # 0049b518
    mov eax, dword ptr [ebp - local_84]          # 0049b51b
    mov cl, byte ptr [ebp - local_b0]            # 0049b521
    mov byte ptr [eax], cl                       # 0049b527
L_0049b529:
    # block 0x0049b529: entered by je at 0x0049b4ab; je at 0x0049b4c4; je at 0x0049b50c, 11 instruction(s), ends with forward jump to 0x0049b70a
    mov edx, dword ptr [ebp - local_120]         # 0049b529
    sub edx, dword ptr [ebp - local_118]         # 0049b52f
    mov dword ptr [ebp - local_120], edx         # 0049b535
    mov eax, dword ptr [ebp - local_288]         # 0049b53b
    mov ecx, dword ptr [ebp - local_160]         # 0049b541
    sub ecx, dword ptr [eax + field_1fff]        # 0049b547
    mov dword ptr [ebp - local_160], ecx         # 0049b54d
    mov edx, dword ptr [ebp - local_84]          # 0049b553
    sub edx, 0x218                               # 0049b559
    mov dword ptr [ebp - local_84], edx          # 0049b55f
    jmp.d32 L_0049b70a                           # 0049b565
L_0049b56a:
    # block 0x0049b56a: entered by jb at 0x0049b495, 4 instruction(s), ends with jb to 0x0049b651 (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049b56a
    mov ecx, dword ptr [ebp - local_114]         # 0049b570
    cmp ecx, dword ptr [eax + field_45b1]        # 0049b576
    jb.d32 L_0049b651                            # 0049b57c
    # block 0x0049b582: entered by fall-through of jb at 0x0049b57c, 5 instruction(s), ends with je to 0x0049b610 (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049b582
    {load} xor eax, eax                          # 0049b588
    mov al, byte ptr [edx + field_50ee]          # 0049b58a
    test eax, eax                                # 0049b590
    je.d8 L_0049b610                             # 0049b592
    # block 0x0049b594: entered by fall-through of je at 0x0049b592, 7 instruction(s), ends with je to 0x0049b610 (forward)
    mov ecx, dword ptr [ebp - local_84]          # 0049b594
    {load} xor edx, edx                          # 0049b59a
    mov dl, byte ptr [ecx]                       # 0049b59c
    mov eax, dword ptr [ebp - local_b0]          # 0049b59e
    and eax, 0xff                                # 0049b5a4
    {load} cmp edx, eax                          # 0049b5a9
    je.d8 L_0049b610                             # 0049b5ab
    # block 0x0049b5ad: entered by fall-through of je at 0x0049b5ab, 16 instruction(s), ends with je to 0x0049b610 (forward)
    mov ecx, dword ptr [ebp - local_114]         # 0049b5ad
    and ecx, 0x7f                                # 0049b5b3
    mov dword ptr [ebp - local_114], ecx         # 0049b5b6
    mov edx, dword ptr [ebp - local_114]         # 0049b5bc
    shl edx                                      # 0049b5c2
    mov dword ptr [ebp - local_114], edx         # 0049b5c4
    mov eax, dword ptr [ebp - local_13c]         # 0049b5ca
    add eax, dword ptr [ebp - local_114]         # 0049b5d0
    mov cx, word ptr [eax]                       # 0049b5d6
    mov word ptr [ebp - local_4], cx             # 0049b5d9
    mov edx, dword ptr [ebp - local_4]           # 0049b5dd
    and edx, 0xffff                              # 0049b5e0
    mov eax, dword ptr [ebp - local_e0]          # 0049b5e6
    and eax, 0xffff                              # 0049b5ec
    {load} cmp edx, eax                          # 0049b5f1
    je.d8 L_0049b610                             # 0049b5f3
    # block 0x0049b5f5: entered by fall-through of je at 0x0049b5f3, 6 instruction(s), falls into the block at 0x0049b610
    mov ecx, dword ptr [ebp - local_160]         # 0049b5f5
    mov dx, word ptr [ebp - local_4]             # 0049b5fb
    mov word ptr [ecx], dx                       # 0049b5ff
    mov eax, dword ptr [ebp - local_84]          # 0049b602
    mov cl, byte ptr [ebp - local_b0]            # 0049b608
    mov byte ptr [eax], cl                       # 0049b60e
L_0049b610:
    # block 0x0049b610: entered by je at 0x0049b592; je at 0x0049b5ab; je at 0x0049b5f3, 11 instruction(s), ends with forward jump to 0x0049b70a
    mov edx, dword ptr [ebp - local_120]         # 0049b610
    sub edx, dword ptr [ebp - local_118]         # 0049b616
    mov dword ptr [ebp - local_120], edx         # 0049b61c
    mov eax, dword ptr [ebp - local_288]         # 0049b622
    mov ecx, dword ptr [ebp - local_160]         # 0049b628
    sub ecx, dword ptr [eax + field_1fff]        # 0049b62e
    mov dword ptr [ebp - local_160], ecx         # 0049b634
    mov edx, dword ptr [ebp - local_84]          # 0049b63a
    sub edx, 0x218                               # 0049b640
    mov dword ptr [ebp - local_84], edx          # 0049b646
    jmp.d32 L_0049b70a                           # 0049b64c
L_0049b651:
    # block 0x0049b651: entered by jb at 0x0049b57c, 5 instruction(s), ends with je to 0x0049b6ce (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049b651
    {load} xor ecx, ecx                          # 0049b657
    mov cl, byte ptr [eax + field_50ef]          # 0049b659
    test ecx, ecx                                # 0049b65f
    je.d8 L_0049b6ce                             # 0049b661
    # block 0x0049b663: entered by fall-through of je at 0x0049b661, 7 instruction(s), ends with je to 0x0049b6ce (forward)
    mov edx, dword ptr [ebp - local_84]          # 0049b663
    {load} xor eax, eax                          # 0049b669
    mov al, byte ptr [edx]                       # 0049b66b
    mov ecx, dword ptr [ebp - local_b0]          # 0049b66d
    and ecx, 0xff                                # 0049b673
    {load} cmp eax, ecx                          # 0049b679
    je.d8 L_0049b6ce                             # 0049b67b
    # block 0x0049b67d: entered by fall-through of je at 0x0049b67b, 13 instruction(s), ends with je to 0x0049b6ce (forward)
    mov edx, dword ptr [ebp - local_114]         # 0049b67d
    shl edx                                      # 0049b683
    mov dword ptr [ebp - local_114], edx         # 0049b685
    mov eax, dword ptr [ebp - local_60]          # 0049b68b
    add eax, dword ptr [ebp - local_114]         # 0049b68e
    mov cx, word ptr [eax]                       # 0049b694
    mov word ptr [ebp - local_4], cx             # 0049b697
    mov edx, dword ptr [ebp - local_4]           # 0049b69b
    and edx, 0xffff                              # 0049b69e
    mov eax, dword ptr [ebp - local_e0]          # 0049b6a4
    and eax, 0xffff                              # 0049b6aa
    {load} cmp edx, eax                          # 0049b6af
    je.d8 L_0049b6ce                             # 0049b6b1
    # block 0x0049b6b3: entered by fall-through of je at 0x0049b6b1, 6 instruction(s), falls into the block at 0x0049b6ce
    mov ecx, dword ptr [ebp - local_160]         # 0049b6b3
    mov dx, word ptr [ebp - local_4]             # 0049b6b9
    mov word ptr [ecx], dx                       # 0049b6bd
    mov eax, dword ptr [ebp - local_84]          # 0049b6c0
    mov cl, byte ptr [ebp - local_b0]            # 0049b6c6
    mov byte ptr [eax], cl                       # 0049b6cc
L_0049b6ce:
    # block 0x0049b6ce: entered by je at 0x0049b661; je at 0x0049b67b; je at 0x0049b6b1, 10 instruction(s), falls into the block at 0x0049b70a
    mov edx, dword ptr [ebp - local_120]         # 0049b6ce
    sub edx, dword ptr [ebp - local_118]         # 0049b6d4
    mov dword ptr [ebp - local_120], edx         # 0049b6da
    mov eax, dword ptr [ebp - local_288]         # 0049b6e0
    mov ecx, dword ptr [ebp - local_160]         # 0049b6e6
    sub ecx, dword ptr [eax + field_1fff]        # 0049b6ec
    mov dword ptr [ebp - local_160], ecx         # 0049b6f2
    mov edx, dword ptr [ebp - local_84]          # 0049b6f8
    sub edx, 0x218                               # 0049b6fe
    mov dword ptr [ebp - local_84], edx          # 0049b704
L_0049b70a:
    # block 0x0049b70a: entered by jmp at 0x0049b565; jmp at 0x0049b64c, 1 instruction(s), ends with backward jump to 0x0049b465
    jmp.d32 L_0049b465                           # 0049b70a
L_0049b70f:
    # block 0x0049b70f: entered by jge at 0x0049b477, 1 instruction(s), ends with forward jump to 0x0049b97e
    jmp.d32 L_0049b97e                           # 0049b70f
L_0049b714:
    # block 0x0049b714: entered by je at 0x0049b456, 2 instruction(s), ends with forward jump to 0x0049b726
    mov dword ptr [ebp - local_74], 0x0          # 0049b714
    jmp.d8 L_0049b726                            # 0049b71b
L_0049b71d:
    # block 0x0049b71d: entered by jmp at 0x0049b979, 3 instruction(s), falls into the block at 0x0049b726
    mov eax, dword ptr [ebp - local_74]          # 0049b71d
    add eax, 0x1                                 # 0049b720
    mov dword ptr [ebp - local_74], eax          # 0049b723
L_0049b726:
    # block 0x0049b726: entered by jmp at 0x0049b71b, 3 instruction(s), ends with jge to 0x0049b97e (forward)
    mov ecx, dword ptr [ebp - local_74]          # 0049b726
    cmp ecx, dword ptr [ebp - local_130]         # 0049b729
    jge.d32 L_0049b97e                           # 0049b72f
    # block 0x0049b735: entered by fall-through of jge at 0x0049b72f, 6 instruction(s), ends with jb to 0x0049b80a (forward)
    mov edx, dword ptr [ebp - local_120]         # 0049b735
    shr edx, 0x10                                # 0049b73b
    mov dword ptr [ebp - local_114], edx         # 0049b73e
    mov eax, dword ptr [ebp - local_114]         # 0049b744
    cmp eax, dword ptr [ebp - local_44]          # 0049b74a
    jb.d32 L_0049b80a                            # 0049b74d
    # block 0x0049b753: entered by fall-through of jb at 0x0049b74d, 5 instruction(s), ends with je to 0x0049b7c9 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049b753
    {load} xor edx, edx                          # 0049b759
    mov dl, byte ptr [ecx + field_50ed]          # 0049b75b
    test edx, edx                                # 0049b761
    je.d8 L_0049b7c9                             # 0049b763
    # block 0x0049b765: entered by fall-through of je at 0x0049b763, 16 instruction(s), ends with je to 0x0049b7c9 (forward)
    mov eax, dword ptr [ebp - local_114]         # 0049b765
    and eax, 0x7f                                # 0049b76b
    mov dword ptr [ebp - local_114], eax         # 0049b76e
    mov ecx, dword ptr [ebp - local_114]         # 0049b774
    shl ecx                                      # 0049b77a
    mov dword ptr [ebp - local_114], ecx         # 0049b77c
    mov edx, dword ptr [ebp - local_10c]         # 0049b782
    add edx, dword ptr [ebp - local_114]         # 0049b788
    mov ax, word ptr [edx]                       # 0049b78e
    mov word ptr [ebp - local_4], ax             # 0049b791
    mov ecx, dword ptr [ebp - local_4]           # 0049b795
    and ecx, 0xffff                              # 0049b798
    mov edx, dword ptr [ebp - local_e0]          # 0049b79e
    and edx, 0xffff                              # 0049b7a4
    {load} cmp ecx, edx                          # 0049b7aa
    je.d8 L_0049b7c9                             # 0049b7ac
    # block 0x0049b7ae: entered by fall-through of je at 0x0049b7ac, 6 instruction(s), falls into the block at 0x0049b7c9
    mov eax, dword ptr [ebp - local_160]         # 0049b7ae
    mov cx, word ptr [ebp - local_4]             # 0049b7b4
    mov word ptr [eax], cx                       # 0049b7b8
    mov edx, dword ptr [ebp - local_84]          # 0049b7bb
    mov al, byte ptr [ebp - local_b0]            # 0049b7c1
    mov byte ptr [edx], al                       # 0049b7c7
L_0049b7c9:
    # block 0x0049b7c9: entered by je at 0x0049b763; je at 0x0049b7ac, 11 instruction(s), ends with forward jump to 0x0049b979
    mov ecx, dword ptr [ebp - local_120]         # 0049b7c9
    sub ecx, dword ptr [ebp - local_118]         # 0049b7cf
    mov dword ptr [ebp - local_120], ecx         # 0049b7d5
    mov edx, dword ptr [ebp - local_288]         # 0049b7db
    mov eax, dword ptr [ebp - local_160]         # 0049b7e1
    sub eax, dword ptr [edx + field_1fff]        # 0049b7e7
    mov dword ptr [ebp - local_160], eax         # 0049b7ed
    mov ecx, dword ptr [ebp - local_84]          # 0049b7f3
    sub ecx, 0x218                               # 0049b7f9
    mov dword ptr [ebp - local_84], ecx          # 0049b7ff
    jmp.d32 L_0049b979                           # 0049b805
L_0049b80a:
    # block 0x0049b80a: entered by jb at 0x0049b74d, 4 instruction(s), ends with jb to 0x0049b8d9 (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049b80a
    mov eax, dword ptr [ebp - local_114]         # 0049b810
    cmp eax, dword ptr [edx + field_45b1]        # 0049b816
    jb.d32 L_0049b8d9                            # 0049b81c
    # block 0x0049b822: entered by fall-through of jb at 0x0049b81c, 5 instruction(s), ends with je to 0x0049b898 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049b822
    {load} xor edx, edx                          # 0049b828
    mov dl, byte ptr [ecx + field_50ee]          # 0049b82a
    test edx, edx                                # 0049b830
    je.d8 L_0049b898                             # 0049b832
    # block 0x0049b834: entered by fall-through of je at 0x0049b832, 16 instruction(s), ends with je to 0x0049b898 (forward)
    mov eax, dword ptr [ebp - local_114]         # 0049b834
    and eax, 0x7f                                # 0049b83a
    mov dword ptr [ebp - local_114], eax         # 0049b83d
    mov ecx, dword ptr [ebp - local_114]         # 0049b843
    shl ecx                                      # 0049b849
    mov dword ptr [ebp - local_114], ecx         # 0049b84b
    mov edx, dword ptr [ebp - local_13c]         # 0049b851
    add edx, dword ptr [ebp - local_114]         # 0049b857
    mov ax, word ptr [edx]                       # 0049b85d
    mov word ptr [ebp - local_4], ax             # 0049b860
    mov ecx, dword ptr [ebp - local_4]           # 0049b864
    and ecx, 0xffff                              # 0049b867
    mov edx, dword ptr [ebp - local_e0]          # 0049b86d
    and edx, 0xffff                              # 0049b873
    {load} cmp ecx, edx                          # 0049b879
    je.d8 L_0049b898                             # 0049b87b
    # block 0x0049b87d: entered by fall-through of je at 0x0049b87b, 6 instruction(s), falls into the block at 0x0049b898
    mov eax, dword ptr [ebp - local_160]         # 0049b87d
    mov cx, word ptr [ebp - local_4]             # 0049b883
    mov word ptr [eax], cx                       # 0049b887
    mov edx, dword ptr [ebp - local_84]          # 0049b88a
    mov al, byte ptr [ebp - local_b0]            # 0049b890
    mov byte ptr [edx], al                       # 0049b896
L_0049b898:
    # block 0x0049b898: entered by je at 0x0049b832; je at 0x0049b87b, 11 instruction(s), ends with forward jump to 0x0049b979
    mov ecx, dword ptr [ebp - local_120]         # 0049b898
    sub ecx, dword ptr [ebp - local_118]         # 0049b89e
    mov dword ptr [ebp - local_120], ecx         # 0049b8a4
    mov edx, dword ptr [ebp - local_288]         # 0049b8aa
    mov eax, dword ptr [ebp - local_160]         # 0049b8b0
    sub eax, dword ptr [edx + field_1fff]        # 0049b8b6
    mov dword ptr [ebp - local_160], eax         # 0049b8bc
    mov ecx, dword ptr [ebp - local_84]          # 0049b8c2
    sub ecx, 0x218                               # 0049b8c8
    mov dword ptr [ebp - local_84], ecx          # 0049b8ce
    jmp.d32 L_0049b979                           # 0049b8d4
L_0049b8d9:
    # block 0x0049b8d9: entered by jb at 0x0049b81c, 5 instruction(s), ends with je to 0x0049b93d (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049b8d9
    {load} xor eax, eax                          # 0049b8df
    mov al, byte ptr [edx + field_50ef]          # 0049b8e1
    test eax, eax                                # 0049b8e7
    je.d8 L_0049b93d                             # 0049b8e9
    # block 0x0049b8eb: entered by fall-through of je at 0x0049b8e9, 13 instruction(s), ends with je to 0x0049b93d (forward)
    mov ecx, dword ptr [ebp - local_114]         # 0049b8eb
    shl ecx                                      # 0049b8f1
    mov dword ptr [ebp - local_114], ecx         # 0049b8f3
    mov edx, dword ptr [ebp - local_60]          # 0049b8f9
    add edx, dword ptr [ebp - local_114]         # 0049b8fc
    mov ax, word ptr [edx]                       # 0049b902
    mov word ptr [ebp - local_4], ax             # 0049b905
    mov ecx, dword ptr [ebp - local_4]           # 0049b909
    and ecx, 0xffff                              # 0049b90c
    mov edx, dword ptr [ebp - local_e0]          # 0049b912
    and edx, 0xffff                              # 0049b918
    {load} cmp ecx, edx                          # 0049b91e
    je.d8 L_0049b93d                             # 0049b920
    # block 0x0049b922: entered by fall-through of je at 0x0049b920, 6 instruction(s), falls into the block at 0x0049b93d
    mov eax, dword ptr [ebp - local_160]         # 0049b922
    mov cx, word ptr [ebp - local_4]             # 0049b928
    mov word ptr [eax], cx                       # 0049b92c
    mov edx, dword ptr [ebp - local_84]          # 0049b92f
    mov al, byte ptr [ebp - local_b0]            # 0049b935
    mov byte ptr [edx], al                       # 0049b93b
L_0049b93d:
    # block 0x0049b93d: entered by je at 0x0049b8e9; je at 0x0049b920, 10 instruction(s), falls into the block at 0x0049b979
    mov ecx, dword ptr [ebp - local_120]         # 0049b93d
    sub ecx, dword ptr [ebp - local_118]         # 0049b943
    mov dword ptr [ebp - local_120], ecx         # 0049b949
    mov edx, dword ptr [ebp - local_288]         # 0049b94f
    mov eax, dword ptr [ebp - local_160]         # 0049b955
    sub eax, dword ptr [edx + field_1fff]        # 0049b95b
    mov dword ptr [ebp - local_160], eax         # 0049b961
    mov ecx, dword ptr [ebp - local_84]          # 0049b967
    sub ecx, 0x218                               # 0049b96d
    mov dword ptr [ebp - local_84], ecx          # 0049b973
L_0049b979:
    # block 0x0049b979: entered by jmp at 0x0049b805; jmp at 0x0049b8d4, 1 instruction(s), ends with backward jump to 0x0049b71d
    jmp.d32 L_0049b71d                           # 0049b979
L_0049b97e:
    # block 0x0049b97e: entered by jmp at 0x004991df; jmp at 0x00499e57; jmp at 0x0049ab7f; je at 0x0049ab97; more, 5 instruction(s), ends with jne to 0x0049b9c0 (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049b97e
    mov eax, dword ptr [edx + field_50e9]        # 0049b984
    and eax, 0x10000000                          # 0049b98a
    test eax, eax                                # 0049b98f
    jne.d8 L_0049b9c0                            # 0049b991
    # block 0x0049b993: entered by fall-through of jne at 0x0049b991, 5 instruction(s), ends with jne to 0x0049b9c0 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049b993
    mov edx, dword ptr [ecx + field_50e9]        # 0049b999
    and edx, 0x20000000                          # 0049b99f
    test edx, edx                                # 0049b9a5
    jne.d8 L_0049b9c0                            # 0049b9a7
    # block 0x0049b9a9: entered by fall-through of jne at 0x0049b9a7, 3 instruction(s), ends with jge to 0x0049b9b7 (forward)
    mov eax, dword ptr [ebp - local_34]          # 0049b9a9
    cmp eax, dword ptr [ebp - local_24]          # 0049b9ac
    jge.d8 L_0049b9b7                            # 0049b9af
    # block 0x0049b9b1: entered by fall-through of jge at 0x0049b9af, 2 instruction(s), falls into the block at 0x0049b9b7
    mov ecx, dword ptr [ebp - local_34]          # 0049b9b1
    mov dword ptr [ebp - local_24], ecx          # 0049b9b4
L_0049b9b7:
    # block 0x0049b9b7: entered by jge at 0x0049b9af, 2 instruction(s), ends with forward jump to 0x0049b9c7
    mov dword ptr [ebp - local_8], 0x0           # 0049b9b7
    jmp.d8 L_0049b9c7                            # 0049b9be
L_0049b9c0:
    # block 0x0049b9c0: entered by jne at 0x0049b991; jne at 0x0049b9a7, 1 instruction(s), falls into the block at 0x0049b9c7
    mov dword ptr [ebp - local_8], 0x1           # 0049b9c0
L_0049b9c7:
    # block 0x0049b9c7: entered by jmp at 0x0049b9be, 4 instruction(s), ends with jle to 0x0049b9e7 (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049b9c7
    mov eax, dword ptr [ebp - local_24]          # 0049b9cd
    cmp eax, dword ptr [edx + field_477d]        # 0049b9d0
    jle.d8 L_0049b9e7                            # 0049b9d6
    # block 0x0049b9d8: entered by fall-through of jle at 0x0049b9d6, 3 instruction(s), falls into the block at 0x0049b9e7
    mov ecx, dword ptr [ebp - local_288]         # 0049b9d8
    mov edx, dword ptr [ecx + field_477d]        # 0049b9de
    mov dword ptr [ebp - local_24], edx          # 0049b9e4
L_0049b9e7:
    # block 0x0049b9e7: entered by jle at 0x0049b9d6, 1 instruction(s), ends with backward jump to 0x004966ee
    jmp.d32 L_004966ee                           # 0049b9e7
L_0049b9ec:
    # block 0x0049b9ec: entered by jne at 0x004966f5, 1 instruction(s), ends with backward jump to 0x0049647a
    jmp.d32 L_0049647a                           # 0049b9ec
L_0049b9f1:
    # block 0x0049b9f1: entered by jg at 0x00496492, 7 instruction(s), ends with jle to 0x0049ba2c (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049b9f1
    mov ecx, dword ptr [eax + field_1ef3]        # 0049b9f7
    mov edx, dword ptr [ebp - local_288]         # 0049b9fd
    add ecx, dword ptr [edx + field_50b9]        # 0049ba03
    mov dword ptr [ebp - local_138], ecx         # 0049ba09
    cmp dword ptr [ebp - local_138], 0xfff       # 0049ba0f
    jle.d8 L_0049ba2c                            # 0049ba19
    # block 0x0049ba1b: entered by fall-through of jle at 0x0049ba19, 3 instruction(s), falls into the block at 0x0049ba2c
    mov eax, dword ptr [ebp - local_138]         # 0049ba1b
    sub eax, 0x1000                              # 0049ba21
    mov dword ptr [ebp - local_138], eax         # 0049ba26
L_0049ba2c:
    # block 0x0049ba2c: entered by jle at 0x0049ba19, 7 instruction(s), ends with jle to 0x0049ba68 (forward)
    mov ecx, dword ptr [ebp - local_288]         # 0049ba2c
    mov edx, dword ptr [ecx + field_1ef3]        # 0049ba32
    mov eax, dword ptr [ebp - local_288]         # 0049ba38
    add edx, dword ptr [eax + field_50bd]        # 0049ba3e
    mov dword ptr [ebp - local_134], edx         # 0049ba44
    cmp dword ptr [ebp - local_134], 0xfff       # 0049ba4a
    jle.d8 L_0049ba68                            # 0049ba54
    # block 0x0049ba56: entered by fall-through of jle at 0x0049ba54, 3 instruction(s), falls into the block at 0x0049ba68
    mov ecx, dword ptr [ebp - local_134]         # 0049ba56
    sub ecx, 0x1000                              # 0049ba5c
    mov dword ptr [ebp - local_134], ecx         # 0049ba62
L_0049ba68:
    # block 0x0049ba68: entered by jle at 0x0049ba54, 5 instruction(s), ends with forward jump to 0x0049ba85
    mov edx, dword ptr [ebp - local_288]         # 0049ba68
    mov eax, dword ptr [edx + field_4789]        # 0049ba6e
    add eax, 0x5                                 # 0049ba74
    mov dword ptr [ebp - local_5c], eax          # 0049ba77
    jmp.d8 L_0049ba85                            # 0049ba7a
L_0049ba7c:
    # block 0x0049ba7c: entered by jmp at 0x0049c3f7, 3 instruction(s), falls into the block at 0x0049ba85
    mov ecx, dword ptr [ebp - local_5c]          # 0049ba7c
    add ecx, 0x1                                 # 0049ba7f
    mov dword ptr [ebp - local_5c], ecx          # 0049ba82
L_0049ba85:
    # block 0x0049ba85: entered by jmp at 0x0049ba7a, 4 instruction(s), ends with jg to 0x0049c3fc (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049ba85
    mov eax, dword ptr [ebp - local_5c]          # 0049ba8b
    cmp eax, dword ptr [edx + field_477d]        # 0049ba8e
    jg.d32 L_0049c3fc                            # 0049ba94
    # block 0x0049ba9a: entered by fall-through of jg at 0x0049ba94, 280 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x0049c07c
    mov ecx, dword ptr [ebp - local_288]         # 0049ba9a
    mov edx, dword ptr [ebp - local_5c]          # 0049baa0
    sub edx, dword ptr [ecx + field_4789]        # 0049baa3
    mov eax, dword ptr [ebp - local_288]         # 0049baa9
    mov ecx, dword ptr [eax + field_4789]        # 0049baaf
    {load} sub ecx, edx                          # 0049bab5
    add ecx, 0x1                                 # 0049bab7
    mov dword ptr [ebp - local_154], ecx         # 0049baba
    mov edx, dword ptr [ebp - local_288]         # 0049bac0
    fild dword ptr [edx + field_476d]            # 0049bac6
    fstp dword ptr [ebp - local_32c]             # 0049bacc
    fild dword ptr [ebp - local_5c]              # 0049bad2
    fstp dword ptr [ebp - local_330]             # 0049bad5
    mov eax, dword ptr [ebp - local_288]         # 0049badb
    fild dword ptr [eax + field_4789]            # 0049bae1
    fstp dword ptr [ebp - local_334]             # 0049bae7
    fld dword ptr [ebp - local_330]              # 0049baed
    fsub dword ptr [ebp - local_334]             # 0049baf3
    fdivr dword ptr [ebp - local_32c]            # 0049baf9
    mov ecx, dword ptr [ebp - local_288]         # 0049baff
    fild dword ptr [ecx + field_47ad]            # 0049bb05
    fstp dword ptr [ebp - local_338]             # 0049bb0b
    fmul dword ptr [ebp - local_338]             # 0049bb11
    fstp dword ptr [ebp - local_6c]              # 0049bb17
    mov edx, dword ptr [ebp - local_288]         # 0049bb1a
    fild dword ptr [edx + field_476d]            # 0049bb20
    fstp dword ptr [ebp - local_33c]             # 0049bb26
    mov eax, dword ptr [ebp - local_288]         # 0049bb2c
    fild dword ptr [eax + field_4789]            # 0049bb32
    fstp dword ptr [ebp - local_340]             # 0049bb38
    fild dword ptr [ebp - local_154]             # 0049bb3e
    fstp dword ptr [ebp - local_344]             # 0049bb44
    fld dword ptr [ebp - local_340]              # 0049bb4a
    fsub dword ptr [ebp - local_344]             # 0049bb50
    fdivr dword ptr [ebp - local_33c]            # 0049bb56
    mov ecx, dword ptr [ebp - local_288]         # 0049bb5c
    mov edx, dword ptr [ebp - local_288]         # 0049bb62
    mov eax, dword ptr [ecx + field_45ad]        # 0049bb68
    sub eax, dword ptr [edx + field_47ad]        # 0049bb6e
    mov dword ptr [ebp - local_348], eax         # 0049bb74
    fild dword ptr [ebp - local_348]             # 0049bb7a
    fstp dword ptr [ebp - local_34c]             # 0049bb80
    fmul dword ptr [ebp - local_34c]             # 0049bb86
    fstp dword ptr [ebp - local_3c]              # 0049bb8c
    mov ecx, dword ptr [ebp - local_288]         # 0049bb8f
    mov edx, dword ptr [ecx + field_50b9]        # 0049bb95
    and edx, 0xfff                               # 0049bb9b
    mov eax, dword ptr [ebp - local_288]         # 0049bba1
    mov ecx, dword ptr [eax + field_200f]        # 0049bba7
    fld dword ptr [ecx + 4*edx]                  # 0049bbad
    fdivr dword ptr [ebp - local_6c]             # 0049bbb0
    fstp dword ptr [ebp - local_70]              # 0049bbb3
    fld dword ptr [ebp - local_70]               # 0049bbb6
    fchs                                         # 0049bbb9
    mov edx, dword ptr [ebp - local_138]         # 0049bbbb
    and edx, 0xfff                               # 0049bbc1
    mov eax, dword ptr [ebp - local_288]         # 0049bbc7
    mov ecx, dword ptr [eax + field_2013]        # 0049bbcd
    fmul dword ptr [ecx + 4*edx]                 # 0049bbd3
    fstp dword ptr [ebp - local_168]             # 0049bbd6
    mov edx, dword ptr [ebp - local_138]         # 0049bbdc
    and edx, 0xfff                               # 0049bbe2
    mov eax, dword ptr [ebp - local_288]         # 0049bbe8
    mov ecx, dword ptr [eax + field_200f]        # 0049bbee
    fld dword ptr [ecx + 4*edx]                  # 0049bbf4
    fmul dword ptr [ebp - local_70]              # 0049bbf7
    fstp dword ptr [ebp - local_14c]             # 0049bbfa
    mov edx, dword ptr [ebp - local_288]         # 0049bc00
    fild dword ptr [edx + field_1ef7]            # 0049bc06
    fstp dword ptr [ebp - local_350]             # 0049bc0c
    fld dword ptr [ebp - local_168]              # 0049bc12
    fadd dword ptr [ebp - local_350]             # 0049bc18
    fstp dword ptr [ebp - local_168]             # 0049bc1e
    mov eax, dword ptr [ebp - local_288]         # 0049bc24
    fild dword ptr [eax + field_1efb]            # 0049bc2a
    fstp dword ptr [ebp - local_354]             # 0049bc30
    fld dword ptr [ebp - local_14c]              # 0049bc36
    fadd dword ptr [ebp - local_354]             # 0049bc3c
    fstp dword ptr [ebp - local_14c]             # 0049bc42
    mov ecx, dword ptr [ebp - local_288]         # 0049bc48
    mov edx, dword ptr [ecx + field_50bd]        # 0049bc4e
    and edx, 0xfff                               # 0049bc54
    mov eax, dword ptr [ebp - local_288]         # 0049bc5a
    mov ecx, dword ptr [eax + field_200f]        # 0049bc60
    fld dword ptr [ecx + 4*edx]                  # 0049bc66
    fdivr dword ptr [ebp - local_6c]             # 0049bc69
    fstp dword ptr [ebp - local_4c]              # 0049bc6c
    fld dword ptr [ebp - local_4c]               # 0049bc6f
    fchs                                         # 0049bc72
    mov edx, dword ptr [ebp - local_134]         # 0049bc74
    and edx, 0xfff                               # 0049bc7a
    mov eax, dword ptr [ebp - local_288]         # 0049bc80
    mov ecx, dword ptr [eax + field_2013]        # 0049bc86
    fmul dword ptr [ecx + 4*edx]                 # 0049bc8c
    fstp dword ptr [ebp - local_68]              # 0049bc8f
    mov edx, dword ptr [ebp - local_134]         # 0049bc92
    and edx, 0xfff                               # 0049bc98
    mov eax, dword ptr [ebp - local_288]         # 0049bc9e
    mov ecx, dword ptr [eax + field_200f]        # 0049bca4
    fld dword ptr [ecx + 4*edx]                  # 0049bcaa
    fmul dword ptr [ebp - local_4c]              # 0049bcad
    fstp dword ptr [ebp - local_90]              # 0049bcb0
    mov edx, dword ptr [ebp - local_288]         # 0049bcb6
    fild dword ptr [edx + field_1ef7]            # 0049bcbc
    fstp dword ptr [ebp - local_358]             # 0049bcc2
    fld dword ptr [ebp - local_68]               # 0049bcc8
    fadd dword ptr [ebp - local_358]             # 0049bccb
    fstp dword ptr [ebp - local_68]              # 0049bcd1
    mov eax, dword ptr [ebp - local_288]         # 0049bcd4
    fild dword ptr [eax + field_1efb]            # 0049bcda
    fstp dword ptr [ebp - local_35c]             # 0049bce0
    fld dword ptr [ebp - local_90]               # 0049bce6
    fadd dword ptr [ebp - local_35c]             # 0049bcec
    fstp dword ptr [ebp - local_90]              # 0049bcf2
    fld dword ptr [ebp - local_68]               # 0049bcf8
    fsub dword ptr [ebp - local_168]             # 0049bcfb
    mov ecx, dword ptr [ebp - local_288]         # 0049bd01
    fild dword ptr [ecx + field_4781]            # 0049bd07
    fstp dword ptr [ebp - local_360]             # 0049bd0d
    fdiv dword ptr [ebp - local_360]             # 0049bd13
    fmul dword ptr [0x52db54]                    # 0049bd19
    call FUN_0050ce04                            # 0049bd1f
    mov dword ptr [ebp - local_10], eax          # 0049bd24
    fld dword ptr [ebp - local_90]               # 0049bd27
    fsub dword ptr [ebp - local_14c]             # 0049bd2d
    mov edx, dword ptr [ebp - local_288]         # 0049bd33
    fild dword ptr [edx + field_4781]            # 0049bd39
    fstp dword ptr [ebp - local_364]             # 0049bd3f
    fdiv dword ptr [ebp - local_364]             # 0049bd45
    fmul dword ptr [0x52db54]                    # 0049bd4b
    call FUN_0050ce04                            # 0049bd51
    mov dword ptr [ebp - local_d0], eax          # 0049bd56
    fld dword ptr [ebp - local_168]              # 0049bd5c
    fmul dword ptr [0x52db54]                    # 0049bd62
    call FUN_0050ce04                            # 0049bd68
    mov dword ptr [ebp - local_164], eax         # 0049bd6d
    fld dword ptr [ebp - local_14c]              # 0049bd73
    fmul dword ptr [0x52db54]                    # 0049bd79
    call FUN_0050ce04                            # 0049bd7f
    mov dword ptr [ebp - local_140], eax         # 0049bd84
    mov eax, dword ptr [ebp - local_288]         # 0049bd8a
    mov edx, dword ptr [ebp - local_5c]          # 0049bd90
    imul edx, dword ptr [eax + field_1fff]       # 0049bd93
    mov eax, dword ptr [ebp - local_288]         # 0049bd9a
    mov ecx, dword ptr [ebp - local_288]         # 0049bda0
    mov eax, dword ptr [eax + field_4771]        # 0049bda6
    mov ecx, dword ptr [ecx + field_47e5]        # 0049bdac
    shl eax, cl                                  # 0049bdb2
    {load} add edx, eax                          # 0049bdb4
    mov dword ptr [ebp - local_54], edx          # 0049bdb6
    mov ecx, dword ptr [ebp - local_288]         # 0049bdb9
    mov edx, dword ptr [ecx + field_50b9]        # 0049bdbf
    and edx, 0xfff                               # 0049bdc5
    mov eax, dword ptr [ebp - local_288]         # 0049bdcb
    mov ecx, dword ptr [eax + field_200f]        # 0049bdd1
    fld dword ptr [ecx + 4*edx]                  # 0049bdd7
    fdivr dword ptr [ebp - local_3c]             # 0049bdda
    fstp dword ptr [ebp - local_150]             # 0049bddd
    fld dword ptr [ebp - local_150]              # 0049bde3
    fchs                                         # 0049bde9
    mov edx, dword ptr [ebp - local_138]         # 0049bdeb
    and edx, 0xfff                               # 0049bdf1
    mov eax, dword ptr [ebp - local_288]         # 0049bdf7
    mov ecx, dword ptr [eax + field_2013]        # 0049bdfd
    fmul dword ptr [ecx + 4*edx]                 # 0049be03
    fstp dword ptr [ebp - local_f0]              # 0049be06
    mov edx, dword ptr [ebp - local_138]         # 0049be0c
    and edx, 0xfff                               # 0049be12
    mov eax, dword ptr [ebp - local_288]         # 0049be18
    mov ecx, dword ptr [eax + field_200f]        # 0049be1e
    fld dword ptr [ecx + 4*edx]                  # 0049be24
    fmul dword ptr [ebp - local_150]             # 0049be27
    fstp dword ptr [ebp - local_d4]              # 0049be2d
    mov edx, dword ptr [ebp - local_288]         # 0049be33
    fild dword ptr [edx + field_1ef7]            # 0049be39
    fstp dword ptr [ebp - local_368]             # 0049be3f
    fld dword ptr [ebp - local_f0]               # 0049be45
    fadd dword ptr [ebp - local_368]             # 0049be4b
    fstp dword ptr [ebp - local_f0]              # 0049be51
    mov eax, dword ptr [ebp - local_288]         # 0049be57
    fild dword ptr [eax + field_1efb]            # 0049be5d
    fstp dword ptr [ebp - local_36c]             # 0049be63
    fld dword ptr [ebp - local_d4]               # 0049be69
    fadd dword ptr [ebp - local_36c]             # 0049be6f
    fstp dword ptr [ebp - local_d4]              # 0049be75
    mov ecx, dword ptr [ebp - local_288]         # 0049be7b
    mov edx, dword ptr [ecx + field_50bd]        # 0049be81
    and edx, 0xfff                               # 0049be87
    mov eax, dword ptr [ebp - local_288]         # 0049be8d
    mov ecx, dword ptr [eax + field_200f]        # 0049be93
    fld dword ptr [ecx + 4*edx]                  # 0049be99
    fdivr dword ptr [ebp - local_3c]             # 0049be9c
    fstp dword ptr [ebp - local_170]             # 0049be9f
    fld dword ptr [ebp - local_170]              # 0049bea5
    fchs                                         # 0049beab
    mov edx, dword ptr [ebp - local_134]         # 0049bead
    and edx, 0xfff                               # 0049beb3
    mov eax, dword ptr [ebp - local_288]         # 0049beb9
    mov ecx, dword ptr [eax + field_2013]        # 0049bebf
    fmul dword ptr [ecx + 4*edx]                 # 0049bec5
    fstp dword ptr [ebp - local_148]             # 0049bec8
    mov edx, dword ptr [ebp - local_134]         # 0049bece
    and edx, 0xfff                               # 0049bed4
    mov eax, dword ptr [ebp - local_288]         # 0049beda
    mov ecx, dword ptr [eax + field_200f]        # 0049bee0
    fld dword ptr [ecx + 4*edx]                  # 0049bee6
    fmul dword ptr [ebp - local_170]             # 0049bee9
    fstp dword ptr [ebp - local_124]             # 0049beef
    mov edx, dword ptr [ebp - local_288]         # 0049bef5
    fild dword ptr [edx + field_1ef7]            # 0049befb
    fstp dword ptr [ebp - local_370]             # 0049bf01
    fld dword ptr [ebp - local_148]              # 0049bf07
    fadd dword ptr [ebp - local_370]             # 0049bf0d
    fstp dword ptr [ebp - local_148]             # 0049bf13
    mov eax, dword ptr [ebp - local_288]         # 0049bf19
    fild dword ptr [eax + field_1efb]            # 0049bf1f
    fstp dword ptr [ebp - local_374]             # 0049bf25
    fld dword ptr [ebp - local_124]              # 0049bf2b
    fadd dword ptr [ebp - local_374]             # 0049bf31
    fstp dword ptr [ebp - local_124]             # 0049bf37
    fld dword ptr [ebp - local_148]              # 0049bf3d
    fsub dword ptr [ebp - local_f0]              # 0049bf43
    mov ecx, dword ptr [ebp - local_288]         # 0049bf49
    fild dword ptr [ecx + field_4781]            # 0049bf4f
    fstp dword ptr [ebp - local_378]             # 0049bf55
    fdiv dword ptr [ebp - local_378]             # 0049bf5b
    fmul dword ptr [0x52db54]                    # 0049bf61
    call FUN_0050ce04                            # 0049bf67
    mov dword ptr [ebp - local_144], eax         # 0049bf6c
    fld dword ptr [ebp - local_124]              # 0049bf72
    fsub dword ptr [ebp - local_d4]              # 0049bf78
    mov edx, dword ptr [ebp - local_288]         # 0049bf7e
    fild dword ptr [edx + field_4781]            # 0049bf84
    fstp dword ptr [ebp - local_37c]             # 0049bf8a
    fdiv dword ptr [ebp - local_37c]             # 0049bf90
    fmul dword ptr [0x52db54]                    # 0049bf96
    call FUN_0050ce04                            # 0049bf9c
    mov dword ptr [ebp - local_ec], eax          # 0049bfa1
    fld dword ptr [ebp - local_f0]               # 0049bfa7
    fmul dword ptr [0x52db54]                    # 0049bfad
    call FUN_0050ce04                            # 0049bfb3
    mov dword ptr [ebp - local_2c], eax          # 0049bfb8
    fld dword ptr [ebp - local_d4]               # 0049bfbb
    fmul dword ptr [0x52db54]                    # 0049bfc1
    call FUN_0050ce04                            # 0049bfc7
    mov dword ptr [ebp - local_c], eax           # 0049bfcc
    mov eax, dword ptr [ebp - local_288]         # 0049bfcf
    mov edx, dword ptr [ebp - local_154]         # 0049bfd5
    imul edx, dword ptr [eax + field_1fff]       # 0049bfdb
    mov eax, dword ptr [ebp - local_288]         # 0049bfe2
    mov ecx, dword ptr [ebp - local_288]         # 0049bfe8
    mov eax, dword ptr [eax + field_4771]        # 0049bfee
    mov ecx, dword ptr [ecx + field_47e5]        # 0049bff4
    shl eax, cl                                  # 0049bffa
    {load} add edx, eax                          # 0049bffc
    mov dword ptr [ebp - local_80], edx          # 0049bffe
    mov ecx, dword ptr [ebp - local_288]         # 0049c001
    mov edx, dword ptr [ecx + field_1f7f]        # 0049c007
    add edx, dword ptr [ebp - local_54]          # 0049c00d
    mov dword ptr [ebp - local_110], edx         # 0049c010
    mov eax, dword ptr [ebp - local_288]         # 0049c016
    mov ecx, dword ptr [eax + field_1f7f]        # 0049c01c
    add ecx, dword ptr [ebp - local_80]          # 0049c022
    mov dword ptr [ebp - local_28], ecx          # 0049c025
    mov edx, dword ptr [ebp - local_5c]          # 0049c028
    imul edx, edx, 0x218                         # 0049c02b
    mov eax, dword ptr [ebp - local_288]         # 0049c031
    mov ecx, dword ptr [eax + field_50f3]        # 0049c037
    {load} add ecx, edx                          # 0049c03d
    mov dword ptr [ebp - local_c4], ecx          # 0049c03f
    mov edx, dword ptr [ebp - local_154]         # 0049c045
    imul edx, edx, 0x218                         # 0049c04b
    mov eax, dword ptr [ebp - local_288]         # 0049c051
    mov ecx, dword ptr [eax + field_50f3]        # 0049c057
    {load} add ecx, edx                          # 0049c05d
    mov dword ptr [ebp - local_38], ecx          # 0049c05f
    mov edx, dword ptr [ebp - local_288]         # 0049c062
    mov eax, dword ptr [edx + field_4771]        # 0049c068
    mov dword ptr [ebp - local_78], eax          # 0049c06e
    jmp.d8 L_0049c07c                            # 0049c071
L_0049c073:
    # block 0x0049c073: entered by jmp at 0x0049c280; jmp at 0x0049c3f2, 3 instruction(s), falls into the block at 0x0049c07c
    mov ecx, dword ptr [ebp - local_78]          # 0049c073
    add ecx, 0x1                                 # 0049c076
    mov dword ptr [ebp - local_78], ecx          # 0049c079
L_0049c07c:
    # block 0x0049c07c: entered by jmp at 0x0049c071, 4 instruction(s), ends with jg to 0x0049c3f7 (forward)
    mov edx, dword ptr [ebp - local_288]         # 0049c07c
    mov eax, dword ptr [ebp - local_78]          # 0049c082
    cmp eax, dword ptr [edx + field_4775]        # 0049c085
    jg.d32 L_0049c3f7                            # 0049c08b
    # block 0x0049c091: entered by fall-through of jg at 0x0049c08b, 8 instruction(s), ends with jne to 0x0049c0e2 (forward)
    mov ecx, dword ptr [ebp - local_c4]          # 0049c091
    add ecx, dword ptr [ebp - local_78]          # 0049c097
    {load} xor edx, edx                          # 0049c09a
    mov dl, byte ptr [ecx]                       # 0049c09c
    mov eax, dword ptr [ebp - local_b0]          # 0049c09e
    and eax, 0xff                                # 0049c0a4
    {load} cmp edx, eax                          # 0049c0a9
    jne.d8 L_0049c0e2                            # 0049c0ab
    # block 0x0049c0ad: entered by fall-through of jne at 0x0049c0ab, 10 instruction(s), ends with forward jump to 0x0049c44d
    mov ecx, dword ptr [ebp - local_110]         # 0049c0ad
    add ecx, 0x2                                 # 0049c0b3
    mov dword ptr [ebp - local_110], ecx         # 0049c0b6
    mov edx, dword ptr [ebp - local_164]         # 0049c0bc
    add edx, dword ptr [ebp - local_10]          # 0049c0c2
    mov dword ptr [ebp - local_164], edx         # 0049c0c5
    mov eax, dword ptr [ebp - local_140]         # 0049c0cb
    add eax, dword ptr [ebp - local_d0]          # 0049c0d1
    mov dword ptr [ebp - local_140], eax         # 0049c0d7
    jmp.d32 L_0049c44d                           # 0049c0dd
L_0049c0e2:
    # block 0x0049c0e2: entered by jne at 0x0049c0ab, 76 instruction(s), falls into the block at 0x0049c246
    mov edx, dword ptr [ebp - local_164]         # 0049c0e2
    mov ecx, dword ptr [ebp - local_50]          # 0049c0e8
    sar edx, cl                                  # 0049c0eb
    mov dword ptr [ebp - local_64], edx          # 0049c0ed
    mov eax, dword ptr [ebp - local_140]         # 0049c0f0
    mov ecx, dword ptr [ebp - local_50]          # 0049c0f6
    sar eax, cl                                  # 0049c0f9
    mov dword ptr [ebp - local_8c], eax          # 0049c0fb
    mov ecx, dword ptr [ebp - local_64]          # 0049c101
    and ecx, 0xff                                # 0049c104
    mov dword ptr [ebp - local_64], ecx          # 0049c10a
    mov edx, dword ptr [ebp - local_8c]          # 0049c10d
    and edx, 0xff                                # 0049c113
    mov dword ptr [ebp - local_8c], edx          # 0049c119
    mov eax, dword ptr [ebp - local_64]          # 0049c11f
    imul eax, eax, 0xa6                          # 0049c122
    add eax, dword ptr [ebp - local_8c]          # 0049c128
    mov dword ptr [ebp - local_18], eax          # 0049c12e
    mov ecx, dword ptr [ebp - local_288]         # 0049c131
    mov edx, dword ptr [ecx + field_1f4b]        # 0049c137
    mov eax, dword ptr [ebp - local_18]          # 0049c13d
    {load} xor ecx, ecx                          # 0049c140
    mov cx, word ptr [edx + 2*eax]               # 0049c142
    mov dword ptr [ebp - local_c0], ecx          # 0049c146
    mov edx, dword ptr [ebp - local_288]         # 0049c14c
    mov eax, dword ptr [edx + field_1f5f]        # 0049c152
    mov ecx, dword ptr [ebp - local_18]          # 0049c158
    {load} xor edx, edx                          # 0049c15b
    mov dx, word ptr [eax + 2*ecx]               # 0049c15d
    mov dword ptr [ebp - local_108], edx         # 0049c161
    mov eax, dword ptr [ebp - local_108]         # 0049c167
    and eax, 0xf                                 # 0049c16d
    mov dword ptr [ebp - local_108], eax         # 0049c170
    mov ecx, dword ptr [ebp - local_108]         # 0049c176
    imul ecx, ecx, 0x154                         # 0049c17c
    mov edx, dword ptr [ebp - local_288]         # 0049c182
    lea eax, [edx + ecx + field_3431]            # 0049c188
    mov ecx, dword ptr [ebp - local_c0]          # 0049c18f
    mov edx, dword ptr [eax + 4*ecx]             # 0049c195
    mov dword ptr [ebp - local_58], edx          # 0049c198
    mov eax, dword ptr [ebp - local_164]         # 0049c19b
    sar eax, 0x10                                # 0049c1a1
    mov dword ptr [ebp - local_cc], eax          # 0049c1a4
    mov ecx, dword ptr [ebp - local_140]         # 0049c1aa
    sar ecx, 0x10                                # 0049c1b0
    mov dword ptr [ebp - local_b8], ecx          # 0049c1b3
    mov edx, dword ptr [ebp - local_cc]          # 0049c1b9
    and edx, 0x7f                                # 0049c1bf
    mov dword ptr [ebp - local_cc], edx          # 0049c1c2
    mov eax, dword ptr [ebp - local_b8]          # 0049c1c8
    and eax, 0x7f                                # 0049c1ce
    mov dword ptr [ebp - local_b8], eax          # 0049c1d1
    mov ecx, dword ptr [ebp - local_288]         # 0049c1d7
    mov edx, dword ptr [ebp - local_cc]          # 0049c1dd
    mov ecx, dword ptr [ecx + field_47dd]        # 0049c1e3
    shl edx, cl                                  # 0049c1e9
    mov eax, dword ptr [ebp - local_288]         # 0049c1eb
    mov esi, dword ptr [ebp - local_b8]          # 0049c1f1
    mov ecx, dword ptr [eax + field_47e5]        # 0049c1f7
    shl esi, cl                                  # 0049c1fd
    {load} add edx, esi                          # 0049c1ff
    mov dword ptr [ebp - local_40], edx          # 0049c201
    mov ecx, dword ptr [ebp - local_58]          # 0049c204
    add ecx, dword ptr [ebp - local_40]          # 0049c207
    mov edx, dword ptr [ebp - local_110]         # 0049c20a
    mov ax, word ptr [ecx]                       # 0049c210
    mov word ptr [edx], ax                       # 0049c213
    mov ecx, dword ptr [ebp - local_110]         # 0049c216
    add ecx, 0x2                                 # 0049c21c
    mov dword ptr [ebp - local_110], ecx         # 0049c21f
    mov edx, dword ptr [ebp - local_164]         # 0049c225
    add edx, dword ptr [ebp - local_10]          # 0049c22b
    mov dword ptr [ebp - local_164], edx         # 0049c22e
    mov eax, dword ptr [ebp - local_140]         # 0049c234
    add eax, dword ptr [ebp - local_d0]          # 0049c23a
    mov dword ptr [ebp - local_140], eax         # 0049c240
L_0049c246:
    # block 0x0049c246: entered by jmp at 0x0049c44d, 8 instruction(s), ends with jne to 0x0049c285 (forward)
    mov ecx, dword ptr [ebp - local_38]          # 0049c246
    add ecx, dword ptr [ebp - local_78]          # 0049c249
    {load} xor edx, edx                          # 0049c24c
    mov dl, byte ptr [ecx]                       # 0049c24e
    mov eax, dword ptr [ebp - local_b0]          # 0049c250
    and eax, 0xff                                # 0049c256
    {load} cmp edx, eax                          # 0049c25b
    jne.d8 L_0049c285                            # 0049c25d
    # block 0x0049c25f: entered by fall-through of jne at 0x0049c25d, 10 instruction(s), ends with backward jump to 0x0049c073
    mov ecx, dword ptr [ebp - local_28]          # 0049c25f
    add ecx, 0x2                                 # 0049c262
    mov dword ptr [ebp - local_28], ecx          # 0049c265
    mov edx, dword ptr [ebp - local_2c]          # 0049c268
    add edx, dword ptr [ebp - local_144]         # 0049c26b
    mov dword ptr [ebp - local_2c], edx          # 0049c271
    mov eax, dword ptr [ebp - local_c]           # 0049c274
    add eax, dword ptr [ebp - local_ec]          # 0049c277
    mov dword ptr [ebp - local_c], eax           # 0049c27d
    jmp.d32 L_0049c073                           # 0049c280
L_0049c285:
    # block 0x0049c285: entered by jne at 0x0049c25d, 80 instruction(s), ends with backward jump to 0x0049c073
    mov edx, dword ptr [ebp - local_2c]          # 0049c285
    mov ecx, dword ptr [ebp - local_20]          # 0049c288
    sar edx, cl                                  # 0049c28b
    mov dword ptr [ebp - local_100], edx         # 0049c28d
    mov eax, dword ptr [ebp - local_c]           # 0049c293
    mov ecx, dword ptr [ebp - local_20]          # 0049c296
    sar eax, cl                                  # 0049c299
    mov dword ptr [ebp - local_e8], eax          # 0049c29b
    mov ecx, dword ptr [ebp - local_100]         # 0049c2a1
    and ecx, 0xff                                # 0049c2a7
    mov dword ptr [ebp - local_100], ecx         # 0049c2ad
    mov edx, dword ptr [ebp - local_e8]          # 0049c2b3
    and edx, 0xff                                # 0049c2b9
    mov dword ptr [ebp - local_e8], edx          # 0049c2bf
    mov eax, dword ptr [ebp - local_100]         # 0049c2c5
    imul eax, eax, 0xa6                          # 0049c2cb
    add eax, dword ptr [ebp - local_e8]          # 0049c2d1
    mov dword ptr [ebp - local_9c], eax          # 0049c2d7
    mov ecx, dword ptr [ebp - local_288]         # 0049c2dd
    mov edx, dword ptr [ecx + field_1f4f]        # 0049c2e3
    mov eax, dword ptr [ebp - local_9c]          # 0049c2e9
    {load} xor ecx, ecx                          # 0049c2ef
    mov cx, word ptr [edx + 2*eax]               # 0049c2f1
    mov dword ptr [ebp - local_1c], ecx          # 0049c2f5
    mov edx, dword ptr [ebp - local_288]         # 0049c2f8
    mov eax, dword ptr [edx + field_1f5f]        # 0049c2fe
    mov ecx, dword ptr [ebp - local_9c]          # 0049c304
    {load} xor edx, edx                          # 0049c30a
    mov dx, word ptr [eax + 2*ecx]               # 0049c30c
    mov dword ptr [ebp - local_a4], edx          # 0049c310
    mov eax, dword ptr [ebp - local_a4]          # 0049c316
    sar eax, 0x4                                 # 0049c31c
    mov dword ptr [ebp - local_a4], eax          # 0049c31f
    mov ecx, dword ptr [ebp - local_a4]          # 0049c325
    and ecx, 0xf                                 # 0049c32b
    mov dword ptr [ebp - local_a4], ecx          # 0049c32e
    mov edx, dword ptr [ebp - local_a4]          # 0049c334
    imul edx, edx, 0x64                          # 0049c33a
    mov eax, dword ptr [ebp - local_288]         # 0049c33d
    lea ecx, [eax + edx + field_3ed1]            # 0049c343
    mov edx, dword ptr [ebp - local_1c]          # 0049c34a
    mov eax, dword ptr [ecx + 4*edx]             # 0049c34d
    mov dword ptr [ebp - local_e4], eax          # 0049c350
    mov ecx, dword ptr [ebp - local_2c]          # 0049c356
    sar ecx, 0x10                                # 0049c359
    mov dword ptr [ebp - local_c8], ecx          # 0049c35c
    mov edx, dword ptr [ebp - local_c]           # 0049c362
    sar edx, 0x10                                # 0049c365
    mov dword ptr [ebp - local_b4], edx          # 0049c368
    mov eax, dword ptr [ebp - local_c8]          # 0049c36e
    and eax, 0x7f                                # 0049c374
    mov dword ptr [ebp - local_c8], eax          # 0049c377
    mov ecx, dword ptr [ebp - local_b4]          # 0049c37d
    and ecx, 0x7f                                # 0049c383
    mov dword ptr [ebp - local_b4], ecx          # 0049c386
    mov edx, dword ptr [ebp - local_288]         # 0049c38c
    mov eax, dword ptr [ebp - local_c8]          # 0049c392
    mov ecx, dword ptr [edx + field_47e1]        # 0049c398
    shl eax, cl                                  # 0049c39e
    mov ecx, dword ptr [ebp - local_288]         # 0049c3a0
    mov edx, dword ptr [ebp - local_b4]          # 0049c3a6
    mov ecx, dword ptr [ecx + field_47e5]        # 0049c3ac
    shl edx, cl                                  # 0049c3b2
    {load} add eax, edx                          # 0049c3b4
    mov dword ptr [ebp - local_a0], eax          # 0049c3b6
    mov eax, dword ptr [ebp - local_e4]          # 0049c3bc
    add eax, dword ptr [ebp - local_a0]          # 0049c3c2
    mov ecx, dword ptr [ebp - local_28]          # 0049c3c8
    mov dx, word ptr [eax]                       # 0049c3cb
    mov word ptr [ecx], dx                       # 0049c3ce
    mov eax, dword ptr [ebp - local_28]          # 0049c3d1
    add eax, 0x2                                 # 0049c3d4
    mov dword ptr [ebp - local_28], eax          # 0049c3d7
    mov ecx, dword ptr [ebp - local_2c]          # 0049c3da
    add ecx, dword ptr [ebp - local_144]         # 0049c3dd
    mov dword ptr [ebp - local_2c], ecx          # 0049c3e3
    mov edx, dword ptr [ebp - local_c]           # 0049c3e6
    add edx, dword ptr [ebp - local_ec]          # 0049c3e9
    mov dword ptr [ebp - local_c], edx           # 0049c3ef
    jmp.d32 L_0049c073                           # 0049c3f2
L_0049c3f7:
    # block 0x0049c3f7: entered by jg at 0x0049c08b, 1 instruction(s), ends with backward jump to 0x0049ba7c
    jmp.d32 L_0049ba7c                           # 0049c3f7
L_0049c3fc:
    # block 0x0049c3fc: entered by jg at 0x0049ba94, 14 instruction(s), ends with jl to 0x0049c44b (forward)
    mov eax, dword ptr [ebp - local_288]         # 0049c3fc
    mov ecx, dword ptr [ebp - local_288]         # 0049c402
    mov dl, byte ptr [eax + field_50fb]          # 0049c408
    add dl, byte ptr [ecx + field_50fd]          # 0049c40e
    mov eax, dword ptr [ebp - local_288]         # 0049c414
    mov byte ptr [eax + field_50fb], dl          # 0049c41a
    mov ecx, dword ptr [ebp - local_288]         # 0049c420
    {load} xor edx, edx                          # 0049c426
    mov dl, byte ptr [ecx + field_50fb]          # 0049c428
    mov eax, dword ptr [ebp - local_288]         # 0049c42e
    {load} xor ecx, ecx                          # 0049c434
    mov cl, byte ptr [eax + field_50fc]          # 0049c436
    {load} cmp edx, ecx                          # 0049c43c
    jl.d8 L_0049c44b                             # 0049c43e
    # block 0x0049c440: entered by fall-through of jl at 0x0049c43e, 2 instruction(s), calls FUN_0049192b, falls into the block at 0x0049c44b
    mov ecx, dword ptr [ebp - local_288]         # 0049c440
    call FUN_0049192b                            # 0049c446
L_0049c44b:
    # block 0x0049c44b: entered by jl at 0x0049c43e, 1 instruction(s), ends with forward jump to 0x0049c457
    jmp.d8 L_0049c457                            # 0049c44b
L_0049c44d:
    # block 0x0049c44d: entered by jmp at 0x0049c0dd, 1 instruction(s), ends with backward jump to 0x0049c246
    jmp.d32 L_0049c246                           # 0049c44d
L_0049c452:
    # block 0x0049c452: entered by jmp at 0x0049849d, 1 instruction(s), ends with backward jump to 0x0049b97e
    jmp.d32 L_0049b97e                           # 0049c452
L_0049c457:
    # block 0x0049c457: entered by jmp at 0x0049c44b, 4 instruction(s), ends with ret
    pop esi                                      # 0049c457
    {load} mov esp, ebp                          # 0049c458
    pop ebp                                      # 0049c45a
    ret                                          # 0049c45b

