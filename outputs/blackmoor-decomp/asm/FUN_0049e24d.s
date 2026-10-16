# FUN_0049e24d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049e24d
# extent:       0x0049e24d-0x0049e455 (520 code bytes)
# span:         0x0049e24d-0x0049e455 (code 520, tables 0, padding 0)
# sha256:       591c738079a36e246db34ffab45a3dfc68dde72dc315088b3e0467bf9fd4f442
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049e24d
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_1c, field_24, field_e30, field_e3c, field_e44; [ecx + n] field_1c, field_28, field_e1c, field_e20, field_e38, field_e3c; [edx + n] field_1c, field_e44
# callees:      calls FUN_0050cd50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 144 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_e1c, 0xe1c  # offset +0xe1c
.equ field_e20, 0xe20  # offset +0xe20
.equ field_e30, 0xe30  # offset +0xe30
.equ field_e38, 0xe38  # offset +0xe38
.equ field_e3c, 0xe3c  # offset +0xe3c
.equ field_e44, 0xe44  # offset +0xe44

# --- external targets -----------------------------------------------
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0049e24d - 0x401000
.globl FUN_0049e24d
FUN_0049e24d:
    # block 0x0049e24d: entry, 10 instruction(s), falls into the block at 0x0049e274
    push ebp                                     # 0049e24d
    {load} mov ebp, esp                          # 0049e24e
    sub esp, 0x28                                # 0049e250
    mov dword ptr [ebp - local_28], ecx          # 0049e253
    mov dword ptr [ebp - local_14], 0x0          # 0049e256
    mov dword ptr [ebp - local_18], 0x0          # 0049e25d
    mov eax, dword ptr [ebp - local_28]          # 0049e264
    mov ecx, dword ptr [eax + field_24]          # 0049e267
    mov dword ptr [ebp - local_10], ecx          # 0049e26a
    mov dword ptr [ebp - local_24], 0x0          # 0049e26d
L_0049e274:
    # block 0x0049e274: entered by jmp at 0x0049e317, 2 instruction(s), ends with jne to 0x0049e31c (forward)
    cmp dword ptr [ebp - local_24], 0x0          # 0049e274
    jne.d32 L_0049e31c                           # 0049e278
    # block 0x0049e27e: entered by fall-through of jne at 0x0049e278, 5 instruction(s), ends with jg to 0x0049e292 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0049e27e
    sub edx, 0x1                                 # 0049e281
    mov dword ptr [ebp - local_10], edx          # 0049e284
    cmp dword ptr [ebp - local_10], 0x0          # 0049e287
    jg.d8 L_0049e292                             # 0049e28b
    # block 0x0049e28d: entered by fall-through of jg at 0x0049e28b, 1 instruction(s), ends with forward jump to 0x0049e31c
    jmp.d32 L_0049e31c                           # 0049e28d
L_0049e292:
    # block 0x0049e292: entered by jg at 0x0049e28b, 21 instruction(s), calls FUN_0050cd50, ends with jne to 0x0049e317 (forward)
    call FUN_0050cd50                            # 0049e292
    mov ecx, dword ptr [ebp - local_28]          # 0049e297
    cdq                                          # 0049e29a
    idiv dword ptr [ecx + field_e20]             # 0049e29b
    add edx, dword ptr [ebp + arg_8]             # 0049e2a1
    mov dword ptr [ebp - local_14], edx          # 0049e2a4
    call FUN_0050cd50                            # 0049e2a7
    mov ecx, dword ptr [ebp - local_28]          # 0049e2ac
    cdq                                          # 0049e2af
    idiv dword ptr [ecx + field_e1c]             # 0049e2b0
    add edx, dword ptr [ebp + arg_c]             # 0049e2b6
    mov dword ptr [ebp - local_18], edx          # 0049e2b9
    mov edx, dword ptr [ebp - local_28]          # 0049e2bc
    mov eax, dword ptr [ebp - local_14]          # 0049e2bf
    imul eax, dword ptr [edx + field_1c]         # 0049e2c2
    mov ecx, dword ptr [ebp - local_28]          # 0049e2c6
    mov edx, dword ptr [ecx + field_e38]         # 0049e2c9
    lea eax, [edx + 4*eax]                       # 0049e2cf
    mov ecx, dword ptr [ebp - local_18]          # 0049e2d2
    cmp dword ptr [eax + 4*ecx], 0x0             # 0049e2d5
    jne.d8 L_0049e317                            # 0049e2d9
    # block 0x0049e2db: entered by fall-through of jne at 0x0049e2d9, 9 instruction(s), ends with jne to 0x0049e317 (forward)
    mov edx, dword ptr [ebp - local_28]          # 0049e2db
    mov eax, dword ptr [ebp - local_14]          # 0049e2de
    imul eax, dword ptr [edx + field_1c]         # 0049e2e1
    mov ecx, dword ptr [ebp - local_28]          # 0049e2e5
    mov edx, dword ptr [ecx + field_e3c]         # 0049e2e8
    lea eax, [edx + 4*eax]                       # 0049e2ee
    mov ecx, dword ptr [ebp - local_18]          # 0049e2f1
    cmp dword ptr [eax + 4*ecx], 0x0             # 0049e2f4
    jne.d8 L_0049e317                            # 0049e2f8
    # block 0x0049e2fa: entered by fall-through of jne at 0x0049e2f8, 3 instruction(s), ends with jne to 0x0049e310 (forward)
    mov edx, dword ptr [ebp - local_14]          # 0049e2fa
    cmp edx, dword ptr [0x6329c9]                # 0049e2fd
    jne.d8 L_0049e310                            # 0049e303
    # block 0x0049e305: entered by fall-through of jne at 0x0049e303, 3 instruction(s), ends with je to 0x0049e317 (forward)
    mov eax, dword ptr [ebp - local_18]          # 0049e305
    cmp eax, dword ptr [0x6329cd]                # 0049e308
    je.d8 L_0049e317                             # 0049e30e
L_0049e310:
    # block 0x0049e310: entered by jne at 0x0049e303; fall-through of je at 0x0049e30e, 1 instruction(s), falls into the block at 0x0049e317
    mov dword ptr [ebp - local_24], 0x1          # 0049e310
L_0049e317:
    # block 0x0049e317: entered by jne at 0x0049e2d9; jne at 0x0049e2f8; je at 0x0049e30e, 1 instruction(s), ends with backward jump to 0x0049e274
    jmp.d32 L_0049e274                           # 0049e317
L_0049e31c:
    # block 0x0049e31c: entered by jne at 0x0049e278; jmp at 0x0049e28d, 2 instruction(s), ends with je to 0x0049e44f (forward)
    cmp dword ptr [ebp - local_24], 0x0          # 0049e31c
    je.d32 L_0049e44f                            # 0049e320
    # block 0x0049e326: entered by fall-through of je at 0x0049e320, 83 instruction(s), falls into the block at 0x0049e44f
    mov dword ptr [ebp - local_c], 0x0           # 0049e326
    mov ecx, dword ptr [ebp - local_c]           # 0049e32d
    or ecx, dword ptr [ebp + arg_10]             # 0049e330
    mov dword ptr [ebp - local_c], ecx           # 0049e333
    mov edx, dword ptr [ebp - local_c]           # 0049e336
    shl edx, 0x8                                 # 0049e339
    mov dword ptr [ebp - local_c], edx           # 0049e33c
    mov eax, dword ptr [ebp - local_c]           # 0049e33f
    or al, 0x2                                   # 0049e342
    mov dword ptr [ebp - local_c], eax           # 0049e344
    mov ecx, dword ptr [ebp - local_28]          # 0049e347
    mov edx, dword ptr [ebp - local_14]          # 0049e34a
    imul edx, dword ptr [ecx + field_1c]         # 0049e34d
    mov eax, dword ptr [ebp - local_28]          # 0049e351
    mov ecx, dword ptr [eax + field_e3c]         # 0049e354
    lea edx, [ecx + 4*edx]                       # 0049e35a
    mov eax, dword ptr [ebp - local_18]          # 0049e35d
    mov ecx, dword ptr [ebp - local_c]           # 0049e360
    mov dword ptr [edx + 4*eax], ecx             # 0049e363
    mov dword ptr [ebp - local_20], 0x0          # 0049e366
    mov edx, dword ptr [ebp - local_20]          # 0049e36d
    mov dword ptr [ebp - local_4], edx           # 0049e370
    mov ax, word ptr [ebp - local_4]             # 0049e373
    mov word ptr [ebp - local_8], ax             # 0049e377
    mov ecx, dword ptr [ebp - local_28]          # 0049e37b
    mov edx, dword ptr [ebp - local_14]          # 0049e37e
    imul edx, dword ptr [ecx + field_1c]         # 0049e381
    mov eax, dword ptr [ebp - local_28]          # 0049e385
    mov ecx, dword ptr [eax + field_e44]         # 0049e388
    lea edx, [ecx + 2*edx]                       # 0049e38e
    mov eax, dword ptr [ebp - local_18]          # 0049e391
    mov cx, word ptr [edx + 2*eax]               # 0049e394
    mov word ptr [ebp - local_8], cx             # 0049e398
    mov edx, dword ptr [ebp - local_8]           # 0049e39c
    and edx, 0xffff                              # 0049e39f
    sar edx, 0x4                                 # 0049e3a5
    and edx, 0xf                                 # 0049e3a8
    mov dword ptr [ebp - local_20], edx          # 0049e3ab
    mov eax, dword ptr [ebp - local_8]           # 0049e3ae
    and eax, 0xffff                              # 0049e3b1
    and eax, 0xf                                 # 0049e3b6
    mov dword ptr [ebp - local_4], eax           # 0049e3b9
    mov ecx, dword ptr [ebp - local_8]           # 0049e3bc
    and ecx, 0xffff                              # 0049e3bf
    and ecx, 0xf000                              # 0049e3c5
    mov word ptr [ebp - local_1c], cx            # 0049e3cb
    mov edx, dword ptr [ebp - local_4]           # 0049e3cf
    sub edx, 0x2                                 # 0049e3d2
    mov dword ptr [ebp - local_4], edx           # 0049e3d5
    {load} xor eax, eax                          # 0049e3d8
    cmp dword ptr [ebp - local_4], 0x0           # 0049e3da
    setle al                                     # 0049e3de
    dec eax                                      # 0049e3e1
    and eax, dword ptr [ebp - local_4]           # 0049e3e2
    mov dword ptr [ebp - local_4], eax           # 0049e3e5
    mov ecx, dword ptr [ebp - local_20]          # 0049e3e8
    shl ecx, 0x4                                 # 0049e3eb
    mov dword ptr [ebp - local_20], ecx          # 0049e3ee
    mov word ptr [ebp - local_8], 0x0            # 0049e3f1
    mov edx, dword ptr [ebp - local_1c]          # 0049e3f7
    and edx, 0xffff                              # 0049e3fa
    or edx, dword ptr [ebp - local_20]           # 0049e400
    or edx, dword ptr [ebp - local_4]            # 0049e403
    mov word ptr [ebp - local_8], dx             # 0049e406
    mov eax, dword ptr [ebp - local_28]          # 0049e40a
    mov ecx, dword ptr [ebp - local_14]          # 0049e40d
    imul ecx, dword ptr [eax + field_1c]         # 0049e410
    mov edx, dword ptr [ebp - local_28]          # 0049e414
    mov eax, dword ptr [edx + field_e44]         # 0049e417
    lea ecx, [eax + 2*ecx]                       # 0049e41d
    mov edx, dword ptr [ebp - local_18]          # 0049e420
    mov ax, word ptr [ebp - local_8]             # 0049e423
    mov word ptr [ecx + 2*edx], ax               # 0049e427
    mov ecx, dword ptr [ebp - local_28]          # 0049e42b
    mov edx, dword ptr [ebp - local_14]          # 0049e42e
    imul edx, dword ptr [ecx + field_1c]         # 0049e431
    mov eax, dword ptr [ebp - local_28]          # 0049e435
    mov ecx, dword ptr [eax + field_e30]         # 0049e438
    lea edx, [ecx + 2*edx]                       # 0049e43e
    mov eax, dword ptr [ebp - local_18]          # 0049e441
    mov ecx, dword ptr [ebp - local_28]          # 0049e444
    mov cx, word ptr [ecx + field_28]            # 0049e447
    mov word ptr [edx + 2*eax], cx               # 0049e44b
L_0049e44f:
    # block 0x0049e44f: entered by je at 0x0049e320, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 0049e44f
    pop ebp                                      # 0049e451
    ret 0xc                                      # 0049e452

