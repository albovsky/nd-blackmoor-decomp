# FUN_004922f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004922f4
# extent:       0x004922f4-0x0049251f (555 code bytes)
# span:         0x004922f4-0x0049251f (code 555, tables 0, padding 0)
# sha256:       2642cfbf2686b6eb556e22e00053efa28108db43da210e767b75f81855b6048e
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004922f4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c
# fields:       [eax + n] field_2017, field_476d, field_4771, field_47ed, field_50b9, field_50bd; [ecx + n] field_2017, field_4775, field_478d, field_47ed, field_50b9, field_50bd; [edx + n] field_2017, field_476d, field_478d, field_50b9, field_50bd
# callees:      calls FUN_0050e284, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 139 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_2017, 0x2017  # offset +0x2017
.equ field_476d, 0x476d  # offset +0x476d
.equ field_4771, 0x4771  # offset +0x4771
.equ field_4775, 0x4775  # offset +0x4775
.equ field_478d, 0x478d  # offset +0x478d
.equ field_47ed, 0x47ed  # offset +0x47ed
.equ field_50b9, 0x50b9  # offset +0x50b9
.equ field_50bd, 0x50bd  # offset +0x50bd

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050e284, .text + (0x0050e284 - 0x401000)

.org 0x004922f4 - 0x401000
.globl FUN_004922f4
FUN_004922f4:
    # block 0x004922f4: entry, 6 instruction(s), ends with forward jump to 0x0049230f
    push ebp                                     # 004922f4
    {load} mov ebp, esp                          # 004922f5
    sub esp, 0x2c                                # 004922f7
    mov dword ptr [ebp - local_8], ecx           # 004922fa
    mov dword ptr [ebp - local_4], 0x0           # 004922fd
    jmp.d8 L_0049230f                            # 00492304
L_00492306:
    # block 0x00492306: entered by jmp at 0x004923dd, 3 instruction(s), falls into the block at 0x0049230f
    mov eax, dword ptr [ebp - local_4]           # 00492306
    add eax, 0x1                                 # 00492309
    mov dword ptr [ebp - local_4], eax           # 0049230c
L_0049230f:
    # block 0x0049230f: entered by jmp at 0x00492304, 2 instruction(s), ends with jge to 0x004923e2 (forward)
    cmp dword ptr [ebp - local_4], 0x218         # 0049230f
    jge.d32 L_004923e2                           # 00492316
    # block 0x0049231c: entered by fall-through of jge at 0x00492316, 27 instruction(s), calls FUN_0050e284, FUN_0050ce04, ends with jge to 0x004923a4 (forward)
    fild dword ptr [ebp - local_4]               # 0049231c
    fstp dword ptr [ebp - local_c]               # 0049231f
    mov ecx, dword ptr [ebp - local_8]           # 00492322
    fild dword ptr [ecx + field_478d]            # 00492325
    fstp dword ptr [ebp - local_10]              # 0049232b
    fld dword ptr [ebp - local_c]                # 0049232e
    fsub dword ptr [ebp - local_10]              # 00492331
    mov edx, dword ptr [ebp - local_8]           # 00492334
    fild dword ptr [edx + field_476d]            # 00492337
    fstp dword ptr [ebp - local_14]              # 0049233d
    fdiv dword ptr [ebp - local_14]              # 00492340
    sub esp, 0x8                                 # 00492343
    fstp qword ptr [esp]                         # 00492346
    call FUN_0050e284                            # 00492349
    add esp, 0x8                                 # 0049234e
    mov eax, dword ptr [ebp - local_8]           # 00492351
    fmul dword ptr [eax + field_47ed]            # 00492354
    call FUN_0050ce04                            # 0049235a
    mov ecx, dword ptr [ebp - local_8]           # 0049235f
    mov edx, dword ptr [ecx + field_2017]        # 00492362
    mov ecx, dword ptr [ebp - local_4]           # 00492368
    mov dword ptr [edx + 4*ecx], eax             # 0049236b
    mov edx, dword ptr [ebp - local_8]           # 0049236e
    mov eax, dword ptr [edx + field_2017]        # 00492371
    mov ecx, dword ptr [ebp - local_4]           # 00492377
    cmp dword ptr [eax + 4*ecx], 0x0             # 0049237a
    jge.d8 L_004923a4                            # 0049237e
    # block 0x00492380: entered by fall-through of jge at 0x0049237e, 9 instruction(s), falls into the block at 0x004923a4
    mov edx, dword ptr [ebp - local_8]           # 00492380
    mov eax, dword ptr [edx + field_2017]        # 00492383
    mov ecx, dword ptr [ebp - local_4]           # 00492389
    mov edx, dword ptr [eax + 4*ecx]             # 0049238c
    add edx, 0x1000                              # 0049238f
    mov eax, dword ptr [ebp - local_8]           # 00492395
    mov ecx, dword ptr [eax + field_2017]        # 00492398
    mov eax, dword ptr [ebp - local_4]           # 0049239e
    mov dword ptr [ecx + 4*eax], edx             # 004923a1
L_004923a4:
    # block 0x004923a4: entered by jge at 0x0049237e, 5 instruction(s), ends with jle to 0x004923dd (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004923a4
    mov edx, dword ptr [ecx + field_2017]        # 004923a7
    mov eax, dword ptr [ebp - local_4]           # 004923ad
    cmp dword ptr [edx + 4*eax], 0xfff           # 004923b0
    jle.d8 L_004923dd                            # 004923b7
    # block 0x004923b9: entered by fall-through of jle at 0x004923b7, 9 instruction(s), falls into the block at 0x004923dd
    mov ecx, dword ptr [ebp - local_8]           # 004923b9
    mov edx, dword ptr [ecx + field_2017]        # 004923bc
    mov eax, dword ptr [ebp - local_4]           # 004923c2
    mov ecx, dword ptr [edx + 4*eax]             # 004923c5
    sub ecx, 0x1000                              # 004923c8
    mov edx, dword ptr [ebp - local_8]           # 004923ce
    mov eax, dword ptr [edx + field_2017]        # 004923d1
    mov edx, dword ptr [ebp - local_4]           # 004923d7
    mov dword ptr [eax + 4*edx], ecx             # 004923da
L_004923dd:
    # block 0x004923dd: entered by jle at 0x004923b7, 1 instruction(s), ends with backward jump to 0x00492306
    jmp.d32 L_00492306                           # 004923dd
L_004923e2:
    # block 0x004923e2: entered by jge at 0x00492316, 24 instruction(s), calls FUN_0050e284, FUN_0050ce04, ends with jge to 0x00492458 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004923e2
    fild dword ptr [eax + field_4771]            # 004923e5
    fstp dword ptr [ebp - local_18]              # 004923eb
    mov ecx, dword ptr [ebp - local_8]           # 004923ee
    fild dword ptr [ecx + field_478d]            # 004923f1
    fstp dword ptr [ebp - local_1c]              # 004923f7
    fld dword ptr [ebp - local_18]               # 004923fa
    fsub dword ptr [ebp - local_1c]              # 004923fd
    mov edx, dword ptr [ebp - local_8]           # 00492400
    fild dword ptr [edx + field_476d]            # 00492403
    fstp dword ptr [ebp - local_20]              # 00492409
    fdiv dword ptr [ebp - local_20]              # 0049240c
    sub esp, 0x8                                 # 0049240f
    fstp qword ptr [esp]                         # 00492412
    call FUN_0050e284                            # 00492415
    add esp, 0x8                                 # 0049241a
    mov eax, dword ptr [ebp - local_8]           # 0049241d
    fmul dword ptr [eax + field_47ed]            # 00492420
    call FUN_0050ce04                            # 00492426
    mov ecx, dword ptr [ebp - local_8]           # 0049242b
    mov dword ptr [ecx + field_50b9], eax        # 0049242e
    mov edx, dword ptr [ebp - local_8]           # 00492434
    cmp dword ptr [edx + field_50b9], 0x0        # 00492437
    jge.d8 L_00492458                            # 0049243e
    # block 0x00492440: entered by fall-through of jge at 0x0049243e, 5 instruction(s), falls into the block at 0x00492458
    mov eax, dword ptr [ebp - local_8]           # 00492440
    mov ecx, dword ptr [eax + field_50b9]        # 00492443
    add ecx, 0x1000                              # 00492449
    mov edx, dword ptr [ebp - local_8]           # 0049244f
    mov dword ptr [edx + field_50b9], ecx        # 00492452
L_00492458:
    # block 0x00492458: entered by jge at 0x0049243e, 3 instruction(s), ends with jle to 0x0049247f (forward)
    mov eax, dword ptr [ebp - local_8]           # 00492458
    cmp dword ptr [eax + field_50b9], 0xfff      # 0049245b
    jle.d8 L_0049247f                            # 00492465
    # block 0x00492467: entered by fall-through of jle at 0x00492465, 5 instruction(s), falls into the block at 0x0049247f
    mov ecx, dword ptr [ebp - local_8]           # 00492467
    mov edx, dword ptr [ecx + field_50b9]        # 0049246a
    sub edx, 0x1000                              # 00492470
    mov eax, dword ptr [ebp - local_8]           # 00492476
    mov dword ptr [eax + field_50b9], edx        # 00492479
L_0049247f:
    # block 0x0049247f: entered by jle at 0x00492465, 24 instruction(s), calls FUN_0050e284, FUN_0050ce04, ends with jge to 0x004924f5 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0049247f
    fild dword ptr [ecx + field_4775]            # 00492482
    fstp dword ptr [ebp - local_24]              # 00492488
    mov edx, dword ptr [ebp - local_8]           # 0049248b
    fild dword ptr [edx + field_478d]            # 0049248e
    fstp dword ptr [ebp - local_28]              # 00492494
    fld dword ptr [ebp - local_24]               # 00492497
    fsub dword ptr [ebp - local_28]              # 0049249a
    mov eax, dword ptr [ebp - local_8]           # 0049249d
    fild dword ptr [eax + field_476d]            # 004924a0
    fstp dword ptr [ebp - local_2c]              # 004924a6
    fdiv dword ptr [ebp - local_2c]              # 004924a9
    sub esp, 0x8                                 # 004924ac
    fstp qword ptr [esp]                         # 004924af
    call FUN_0050e284                            # 004924b2
    add esp, 0x8                                 # 004924b7
    mov ecx, dword ptr [ebp - local_8]           # 004924ba
    fmul dword ptr [ecx + field_47ed]            # 004924bd
    call FUN_0050ce04                            # 004924c3
    mov edx, dword ptr [ebp - local_8]           # 004924c8
    mov dword ptr [edx + field_50bd], eax        # 004924cb
    mov eax, dword ptr [ebp - local_8]           # 004924d1
    cmp dword ptr [eax + field_50bd], 0x0        # 004924d4
    jge.d8 L_004924f5                            # 004924db
    # block 0x004924dd: entered by fall-through of jge at 0x004924db, 5 instruction(s), falls into the block at 0x004924f5
    mov ecx, dword ptr [ebp - local_8]           # 004924dd
    mov edx, dword ptr [ecx + field_50bd]        # 004924e0
    add edx, 0x1000                              # 004924e6
    mov eax, dword ptr [ebp - local_8]           # 004924ec
    mov dword ptr [eax + field_50bd], edx        # 004924ef
L_004924f5:
    # block 0x004924f5: entered by jge at 0x004924db, 3 instruction(s), ends with jle to 0x0049251b (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004924f5
    cmp dword ptr [ecx + field_50bd], 0xfff      # 004924f8
    jle.d8 L_0049251b                            # 00492502
    # block 0x00492504: entered by fall-through of jle at 0x00492502, 5 instruction(s), falls into the block at 0x0049251b
    mov edx, dword ptr [ebp - local_8]           # 00492504
    mov eax, dword ptr [edx + field_50bd]        # 00492507
    sub eax, 0x1000                              # 0049250d
    mov ecx, dword ptr [ebp - local_8]           # 00492512
    mov dword ptr [ecx + field_50bd], eax        # 00492515
L_0049251b:
    # block 0x0049251b: entered by jle at 0x00492502, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0049251b
    pop ebp                                      # 0049251d
    ret                                          # 0049251e

