# FUN_004c7314
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c7314
# extent:       0x004c7314-0x004c7481 (365 code bytes)
# span:         0x004c7314-0x004c7481 (code 365, tables 0, padding 0)
# sha256:       520d88bc2e141db4903db273c16a89f49a9ed134cfea83ff737e8d8648747906
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
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
.equ local_14, 0x14  # [ebp - 0x14]
.equ local_18, 0x18  # [ebp - 0x18]
.equ local_1c, 0x1c  # [ebp - 0x1c]
.equ local_20, 0x20  # [ebp - 0x20]
.equ local_24, 0x24  # [ebp - 0x24]
.equ local_28, 0x28  # [ebp - 0x28]
.equ local_2c, 0x2c  # [ebp - 0x2c]
.equ local_30, 0x30  # [ebp - 0x30]
.equ local_34, 0x34  # [ebp - 0x34]
.equ local_38, 0x38  # [ebp - 0x38]
.equ local_3c, 0x3c  # [ebp - 0x3c]
.equ arg_8, 0x8  # [ebp + 0x8]
.equ arg_c, 0xc  # [ebp + 0xc]

# --- external targets -----------------------------------------------

.org 0x004c7314 - 0x401000
.globl FUN_004c7314
FUN_004c7314:
    # block 0x004c7314: <unfilled>
    push ebp                                     # 004c7314
    {load} mov ebp, esp                          # 004c7315
    sub esp, 0x3c                                # 004c7317
    mov dword ptr [ebp - local_3c], ecx          # 004c731a
    mov eax, dword ptr [ebp - local_3c]          # 004c731d
    cmp dword ptr [eax + 0x38a8], 0x0            # 004c7320
    jne.d8 L_004c732e                            # 004c7327
    # block 0x004c7329: <unfilled>
    jmp.d32 L_004c747b                           # 004c7329
L_004c732e:
    # block 0x004c732e: <unfilled>
    mov ecx, dword ptr [ebp + arg_8]             # 004c732e
    mov dword ptr [ebp - local_30], ecx          # 004c7331
    mov edx, dword ptr [ebp + arg_c]             # 004c7334
    mov dword ptr [ebp - local_14], edx          # 004c7337
    mov eax, dword ptr [ebp + arg_8]             # 004c733a
    mov dword ptr [ebp - local_34], eax          # 004c733d
    mov ecx, dword ptr [ebp - local_3c]          # 004c7340
    mov dl, byte ptr [ecx + 0x38c2]              # 004c7343
    mov byte ptr [ebp - local_38], dl            # 004c7349
    mov eax, dword ptr [ebp - local_3c]          # 004c734c
    mov cl, byte ptr [eax + 0x38c1]              # 004c734f
    mov byte ptr [ebp - local_28], cl            # 004c7355
    mov edx, dword ptr [ebp - local_3c]          # 004c7358
    mov al, byte ptr [edx + 0x38c0]              # 004c735b
    mov byte ptr [ebp - local_1c], al            # 004c7361
    mov ecx, dword ptr [ebp - local_3c]          # 004c7364
    mov dl, byte ptr [ecx + 0x38ca]              # 004c7367
    mov byte ptr [ebp - local_c], dl             # 004c736d
    mov eax, dword ptr [ebp - local_3c]          # 004c7370
    mov cl, byte ptr [eax + 0x38c9]              # 004c7373
    mov byte ptr [ebp - local_10], cl            # 004c7379
    mov edx, dword ptr [ebp - local_3c]          # 004c737c
    mov al, byte ptr [edx + 0x38c8]              # 004c737f
    mov byte ptr [ebp - local_20], al            # 004c7385
    mov dword ptr [ebp - local_18], 0x0          # 004c7388
    jmp.d8 L_004c739a                            # 004c738f
L_004c7391:
    # block 0x004c7391: <unfilled>
    mov ecx, dword ptr [ebp - local_18]          # 004c7391
    add ecx, 0x1                                 # 004c7394
    mov dword ptr [ebp - local_18], ecx          # 004c7397
L_004c739a:
    # block 0x004c739a: <unfilled>
    mov edx, dword ptr [ebp + arg_c]             # 004c739a
    shr edx                                      # 004c739d
    cmp dword ptr [ebp - local_18], edx          # 004c739f
    jae.d32 L_004c747b                           # 004c73a2
    # block 0x004c73a8: <unfilled>
    mov eax, dword ptr [ebp - local_18]          # 004c73a8
    mov ecx, dword ptr [ebp - local_30]          # 004c73ab
    mov dx, word ptr [ecx + 2*eax]               # 004c73ae
    mov word ptr [ebp - local_4], dx             # 004c73b2
    mov eax, dword ptr [ebp - local_4]           # 004c73b6
    and eax, 0xffff                              # 004c73b9
    sar eax, 0xa                                 # 004c73be
    and eax, 0x1f                                # 004c73c1
    mov byte ptr [ebp - local_24], al            # 004c73c4
    mov ecx, dword ptr [ebp - local_4]           # 004c73c7
    and ecx, 0xffff                              # 004c73ca
    sar ecx, 0x5                                 # 004c73d0
    and ecx, 0x1f                                # 004c73d3
    mov byte ptr [ebp - local_8], cl             # 004c73d6
    mov edx, dword ptr [ebp - local_4]           # 004c73d9
    and edx, 0xffff                              # 004c73dc
    and edx, 0x1f                                # 004c73e2
    mov byte ptr [ebp - local_2c], dl            # 004c73e5
    mov eax, dword ptr [ebp - local_c]           # 004c73e8
    and eax, 0xff                                # 004c73eb
    cmp eax, 0x5                                 # 004c73f0
    je.d8 L_004c73ff                             # 004c73f3
    # block 0x004c73f5: <unfilled>
    mov cl, byte ptr [ebp - local_24]            # 004c73f5
    shl cl                                       # 004c73f8
    mov byte ptr [ebp - local_24], cl            # 004c73fa
    jmp.d8 L_004c742d                            # 004c73fd
L_004c73ff:
    # block 0x004c73ff: <unfilled>
    mov edx, dword ptr [ebp - local_10]          # 004c73ff
    and edx, 0xff                                # 004c7402
    cmp edx, 0x5                                 # 004c7408
    je.d8 L_004c7417                             # 004c740b
    # block 0x004c740d: <unfilled>
    mov al, byte ptr [ebp - local_8]             # 004c740d
    shl al                                       # 004c7410
    mov byte ptr [ebp - local_8], al             # 004c7412
    jmp.d8 L_004c742d                            # 004c7415
L_004c7417:
    # block 0x004c7417: <unfilled>
    mov ecx, dword ptr [ebp - local_20]          # 004c7417
    and ecx, 0xff                                # 004c741a
    cmp ecx, 0x5                                 # 004c7420
    je.d8 L_004c742d                             # 004c7423
    # block 0x004c7425: <unfilled>
    mov dl, byte ptr [ebp - local_2c]            # 004c7425
    shl dl                                       # 004c7428
    mov byte ptr [ebp - local_2c], dl            # 004c742a
L_004c742d:
    # block 0x004c742d: <unfilled>
    mov eax, dword ptr [ebp - local_24]          # 004c742d
    and eax, 0xff                                # 004c7430
    mov ecx, dword ptr [ebp - local_38]          # 004c7435
    and ecx, 0xff                                # 004c7438
    shl eax, cl                                  # 004c743e
    mov edx, dword ptr [ebp - local_8]           # 004c7440
    and edx, 0xff                                # 004c7443
    mov ecx, dword ptr [ebp - local_28]          # 004c7449
    and ecx, 0xff                                # 004c744c
    shl edx, cl                                  # 004c7452
    {load} or eax, edx                           # 004c7454
    mov edx, dword ptr [ebp - local_2c]          # 004c7456
    and edx, 0xff                                # 004c7459
    mov ecx, dword ptr [ebp - local_1c]          # 004c745f
    and ecx, 0xff                                # 004c7462
    shl edx, cl                                  # 004c7468
    {load} or eax, edx                           # 004c746a
    mov ecx, dword ptr [ebp - local_18]          # 004c746c
    mov edx, dword ptr [ebp - local_30]          # 004c746f
    mov word ptr [edx + 2*ecx], ax               # 004c7472
    jmp.d32 L_004c7391                           # 004c7476
L_004c747b:
    # block 0x004c747b: <unfilled>
    {load} mov esp, ebp                          # 004c747b
    pop ebp                                      # 004c747d
    ret 0x8                                      # 004c747e
