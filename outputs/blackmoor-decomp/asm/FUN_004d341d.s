# FUN_004d341d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d341d
# extent:       0x004d341d-0x004d36ed (720 code bytes)
# span:         0x004d341d-0x004d36ed (code 720, tables 0, padding 0)
# sha256:       9c99305bd1c7076252fc4460564077103f6cb28553231714e4742838f110d30d
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d341d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00420b9e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 151 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

# --- external targets -----------------------------------------------
.set FUN_00420b9e, .text + (0x00420b9e - 0x401000)

.org 0x004d341d - 0x401000
.globl FUN_004d341d
FUN_004d341d:
    # block 0x004d341d: entry, 31 instruction(s), ends with forward jump to 0x004d34c3
    push ebp                                     # 004d341d
    {load} mov ebp, esp                          # 004d341e
    sub esp, 0x1c                                # 004d3420
    mov word ptr [0x5b15cc], 0xffff              # 004d3423
    mov word ptr [0x5b15ce], 0xffff              # 004d342c
    mov dword ptr [0x5d1639], 0x1                # 004d3435
    mov eax, dword ptr [0x5b44f0]                # 004d343f
    shl eax, 0x4                                 # 004d3444
    mov ecx, dword ptr [0x5b44f4]                # 004d3447
    mov edx, dword ptr [0x583106]                # 004d344d
    add edx, dword ptr [eax + 8*ecx + 0x5b30d0]  # 004d3453
    mov word ptr [ebp - local_4], dx             # 004d345a
    mov eax, dword ptr [0x5b44f0]                # 004d345e
    shl eax, 0x4                                 # 004d3463
    mov ecx, dword ptr [0x5b44f4]                # 004d3466
    mov edx, dword ptr [0x583102]                # 004d346c
    add edx, dword ptr [eax + 8*ecx + 0x5b30cc]  # 004d3472
    mov word ptr [ebp - local_1c], dx            # 004d3479
    movsx eax, word ptr [ebp - local_1c]         # 004d347d
    sub eax, dword ptr [0x5b0227]                # 004d3481
    mov word ptr [ebp - local_18], ax            # 004d3487
    movsx ecx, word ptr [ebp - local_4]          # 004d348b
    sub ecx, dword ptr [0x5b022b]                # 004d348f
    mov word ptr [ebp - local_10], cx            # 004d3495
    mov dx, word ptr [ebp - local_18]            # 004d3499
    mov word ptr [ebp - local_14], dx            # 004d349d
    movsx eax, word ptr [ebp - local_10]         # 004d34a1
    add eax, dword ptr [0x5b0a82]                # 004d34a5
    mov word ptr [ebp - local_c], ax             # 004d34ab
    mov word ptr [ebp - local_8], 0x0            # 004d34af
    jmp.d8 L_004d34c3                            # 004d34b5
L_004d34b7:
    # block 0x004d34b7: entered by jmp at 0x004d35eb, 3 instruction(s), falls into the block at 0x004d34c3
    mov cx, word ptr [ebp - local_8]             # 004d34b7
    add cx, 0x1                                  # 004d34bb
    mov word ptr [ebp - local_8], cx             # 004d34bf
L_004d34c3:
    # block 0x004d34c3: entered by jmp at 0x004d34b5, 4 instruction(s), ends with jge to 0x004d35f0 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004d34c3
    movsx eax, word ptr [0x5b0a8e]               # 004d34c7
    {load} cmp edx, eax                          # 004d34ce
    jge.d32 L_004d35f0                           # 004d34d0
    # block 0x004d34d6: entered by fall-through of jge at 0x004d34d0, 6 instruction(s), ends with jl to 0x004d35eb (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004d34d6
    movsx edx, word ptr [ebp - local_8]          # 004d34da
    imul edx, edx, 0x29                          # 004d34de
    movsx eax, word ptr [edx + 0x5b0a92]         # 004d34e1
    {load} cmp ecx, eax                          # 004d34e8
    jl.d32 L_004d35eb                            # 004d34ea
    # block 0x004d34f0: entered by fall-through of jl at 0x004d34ea, 6 instruction(s), ends with jg to 0x004d35eb (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004d34f0
    movsx edx, word ptr [ebp - local_8]          # 004d34f4
    imul edx, edx, 0x29                          # 004d34f8
    movsx eax, word ptr [edx + 0x5b0a96]         # 004d34fb
    {load} cmp ecx, eax                          # 004d3502
    jg.d32 L_004d35eb                            # 004d3504
    # block 0x004d350a: entered by fall-through of jg at 0x004d3504, 6 instruction(s), ends with jl to 0x004d35eb (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004d350a
    movsx edx, word ptr [ebp - local_8]          # 004d350e
    imul edx, edx, 0x29                          # 004d3512
    movsx eax, word ptr [edx + 0x5b0a94]         # 004d3515
    {load} cmp ecx, eax                          # 004d351c
    jl.d32 L_004d35eb                            # 004d351e
    # block 0x004d3524: entered by fall-through of jl at 0x004d351e, 6 instruction(s), ends with jg to 0x004d35eb (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004d3524
    movsx edx, word ptr [ebp - local_8]          # 004d3528
    imul edx, edx, 0x29                          # 004d352c
    movsx eax, word ptr [edx + 0x5b0a98]         # 004d352f
    {load} cmp ecx, eax                          # 004d3536
    jg.d32 L_004d35eb                            # 004d3538
    # block 0x004d353e: entered by fall-through of jg at 0x004d3538, 12 instruction(s), ends with je to 0x004d35e6 (forward)
    mov dword ptr [0x5b44f4], 0x1                # 004d353e
    mov dword ptr [0x5b44f0], 0x4                # 004d3548
    mov cx, word ptr [ebp - local_8]             # 004d3552
    mov word ptr [0x5b15cc], cx                  # 004d3556
    mov edx, dword ptr [0x5b44f0]                # 004d355d
    shl edx, 0x5                                 # 004d3563
    mov eax, dword ptr [0x5b44f4]                # 004d3566
    shl eax, 0x4                                 # 004d356b
    lea ecx, [edx + eax + 0x5b160c]              # 004d356e
    mov dword ptr [0x5d1631], ecx                # 004d3575
    cmp dword ptr [0x5c39e9], 0x0                # 004d357b
    je.d8 L_004d35e6                             # 004d3582
    # block 0x004d3584: entered by fall-through of je at 0x004d3582, 19 instruction(s), calls FUN_00420b9e, falls into the block at 0x004d35e6
    mov dword ptr [0x5b15da], 0x1                # 004d3584
    movsx edx, word ptr [ebp - local_8]          # 004d358e
    imul edx, edx, 0x29                          # 004d3592
    movsx eax, word ptr [edx + 0x5b0a92]         # 004d3595
    mov dword ptr [0x5b15de], eax                # 004d359c
    movsx ecx, word ptr [ebp - local_8]          # 004d35a1
    imul ecx, ecx, 0x29                          # 004d35a5
    movsx edx, word ptr [ecx + 0x5b0a96]         # 004d35a8
    mov dword ptr [0x5b15e6], edx                # 004d35af
    movsx eax, word ptr [ebp - local_8]          # 004d35b5
    imul eax, eax, 0x29                          # 004d35b9
    movsx ecx, word ptr [eax + 0x5b0a94]         # 004d35bc
    mov dword ptr [0x5b15e2], ecx                # 004d35c3
    movsx edx, word ptr [ebp - local_8]          # 004d35c9
    imul edx, edx, 0x29                          # 004d35cd
    movsx eax, word ptr [edx + 0x5b0a98]         # 004d35d0
    mov dword ptr [0x5b15ea], eax                # 004d35d7
    mov ecx, 0x6177e8                            # 004d35dc
    call FUN_00420b9e                            # 004d35e1
L_004d35e6:
    # block 0x004d35e6: entered by je at 0x004d3582, 1 instruction(s), ends with forward jump to 0x004d36e9
    jmp.d32 L_004d36e9                           # 004d35e6
L_004d35eb:
    # block 0x004d35eb: entered by jl at 0x004d34ea; jg at 0x004d3504; jl at 0x004d351e; jg at 0x004d3538, 1 instruction(s), ends with backward jump to 0x004d34b7
    jmp.d32 L_004d34b7                           # 004d35eb
L_004d35f0:
    # block 0x004d35f0: entered by jge at 0x004d34d0, 2 instruction(s), ends with forward jump to 0x004d3604
    mov word ptr [ebp - local_8], 0x0            # 004d35f0
    jmp.d8 L_004d3604                            # 004d35f6
L_004d35f8:
    # block 0x004d35f8: entered by jmp at 0x004d36b2, 3 instruction(s), falls into the block at 0x004d3604
    mov cx, word ptr [ebp - local_8]             # 004d35f8
    add cx, 0x1                                  # 004d35fc
    mov word ptr [ebp - local_8], cx             # 004d3600
L_004d3604:
    # block 0x004d3604: entered by jmp at 0x004d35f6, 4 instruction(s), ends with jge to 0x004d36b7 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004d3604
    movsx eax, word ptr [0x5b0a90]               # 004d3608
    {load} cmp edx, eax                          # 004d360f
    jge.d32 L_004d36b7                           # 004d3611
    # block 0x004d3617: entered by fall-through of jge at 0x004d3611, 6 instruction(s), ends with jl to 0x004d36b2 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004d3617
    movsx edx, word ptr [ebp - local_8]          # 004d361b
    imul edx, edx, 0x29                          # 004d361f
    movsx eax, word ptr [edx + 0x5b142e]         # 004d3622
    {load} cmp ecx, eax                          # 004d3629
    jl.d32 L_004d36b2                            # 004d362b
    # block 0x004d3631: entered by fall-through of jl at 0x004d362b, 6 instruction(s), ends with jg to 0x004d36b2 (forward)
    movsx ecx, word ptr [ebp - local_14]         # 004d3631
    movsx edx, word ptr [ebp - local_8]          # 004d3635
    imul edx, edx, 0x29                          # 004d3639
    movsx eax, word ptr [edx + 0x5b1432]         # 004d363c
    {load} cmp ecx, eax                          # 004d3643
    jg.d8 L_004d36b2                             # 004d3645
    # block 0x004d3647: entered by fall-through of jg at 0x004d3645, 6 instruction(s), ends with jl to 0x004d36b2 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004d3647
    movsx edx, word ptr [ebp - local_8]          # 004d364b
    imul edx, edx, 0x29                          # 004d364f
    movsx eax, word ptr [edx + 0x5b1430]         # 004d3652
    {load} cmp ecx, eax                          # 004d3659
    jl.d8 L_004d36b2                             # 004d365b
    # block 0x004d365d: entered by fall-through of jl at 0x004d365b, 6 instruction(s), ends with jg to 0x004d36b2 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004d365d
    movsx edx, word ptr [ebp - local_8]          # 004d3661
    imul edx, edx, 0x29                          # 004d3665
    movsx eax, word ptr [edx + 0x5b1434]         # 004d3668
    {load} cmp ecx, eax                          # 004d366f
    jg.d8 L_004d36b2                             # 004d3671
    # block 0x004d3673: entered by fall-through of jg at 0x004d3671, 11 instruction(s), ends with forward jump to 0x004d36e9
    mov dword ptr [0x5b44f4], 0x1                # 004d3673
    mov dword ptr [0x5b44f0], 0x4                # 004d367d
    mov cx, word ptr [ebp - local_8]             # 004d3687
    mov word ptr [0x5b15ce], cx                  # 004d368b
    mov edx, dword ptr [0x5b44f0]                # 004d3692
    shl edx, 0x5                                 # 004d3698
    mov eax, dword ptr [0x5b44f4]                # 004d369b
    shl eax, 0x4                                 # 004d36a0
    lea ecx, [edx + eax + 0x5b160c]              # 004d36a3
    mov dword ptr [0x5d1631], ecx                # 004d36aa
    jmp.d8 L_004d36e9                            # 004d36b0
L_004d36b2:
    # block 0x004d36b2: entered by jl at 0x004d362b; jg at 0x004d3645; jl at 0x004d365b; jg at 0x004d3671, 1 instruction(s), ends with backward jump to 0x004d35f8
    jmp.d32 L_004d35f8                           # 004d36b2
L_004d36b7:
    # block 0x004d36b7: entered by jge at 0x004d3611, 8 instruction(s), falls into the block at 0x004d36e9
    mov dword ptr [0x5b44f4], 0x0                # 004d36b7
    mov dword ptr [0x5b44f0], 0x4                # 004d36c1
    mov edx, dword ptr [0x5b44f0]                # 004d36cb
    shl edx, 0x5                                 # 004d36d1
    mov eax, dword ptr [0x5b44f4]                # 004d36d4
    shl eax, 0x4                                 # 004d36d9
    lea ecx, [edx + eax + 0x5b160c]              # 004d36dc
    mov dword ptr [0x5d1631], ecx                # 004d36e3
L_004d36e9:
    # block 0x004d36e9: entered by jmp at 0x004d35e6; jmp at 0x004d36b0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d36e9
    pop ebp                                      # 004d36eb
    ret                                          # 004d36ec

