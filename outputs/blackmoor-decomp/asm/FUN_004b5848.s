# FUN_004b5848
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b5848
# extent:       0x004b5848-0x004b5a61 (537 code bytes)
# span:         0x004b5848-0x004b5a70 (code 537, tables 0, padding 15)
# sha256:       31265fa2001d223b6d1937a3d0fc567591abad1e9767b196abd05bb77488cae8
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b5848
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [ecx + n] field_89; [edx + n] field_29
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 128 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_29, 0x29  # offset +0x29
.equ field_89, 0x89  # offset +0x89

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004b5848 - 0x401000
.globl FUN_004b5848
FUN_004b5848:
    # block 0x004b5848: entry, 6 instruction(s), ends with je to 0x004b5889 (forward)
    push ebp                                     # 004b5848
    {load} mov ebp, esp                          # 004b5849
    sub esp, 0xc                                 # 004b584b
    movsx eax, word ptr [0x6177b2]               # 004b584e
    test eax, eax                                # 004b5855
    je.d8 L_004b5889                             # 004b5857
    # block 0x004b5859: entered by fall-through of je at 0x004b5857, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x004b5889
    push 0x551990                                # 004b5859
    push 0x617792                                # 004b585e
    push 0x6177a2                                # 004b5863
    mov ecx, dword ptr [0x5cf665]                # 004b5868
    push ecx                                     # 004b586e
    mov edx, dword ptr [0x5d15e3]                # 004b586f
    push edx                                     # 004b5875
    mov ecx, 0x5cf659                            # 004b5876
    call FUN_004c5377                            # 004b587b
    mov word ptr [0x6177b2], 0x0                 # 004b5880
L_004b5889:
    # block 0x004b5889: entered by je at 0x004b5857, 3 instruction(s), ends with je to 0x004b58bb (forward)
    movsx eax, word ptr [0x6177b6]               # 004b5889
    test eax, eax                                # 004b5890
    je.d8 L_004b58bb                             # 004b5892
    # block 0x004b5894: entered by fall-through of je at 0x004b5892, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004b58bb
    push 0x5519bc                                # 004b5894
    push 0x617772                                # 004b5899
    push 0x617752                                # 004b589e
    mov ecx, dword ptr [0x5cf665]                # 004b58a3
    push ecx                                     # 004b58a9
    mov edx, dword ptr [0x5d15e3]                # 004b58aa
    push edx                                     # 004b58b0
    mov ecx, 0x5cf659                            # 004b58b1
    call FUN_004c5377                            # 004b58b6
L_004b58bb:
    # block 0x004b58bb: entered by je at 0x004b5892, 3 instruction(s), ends with je to 0x004b5927 (forward)
    movsx eax, word ptr [0x6177b4]               # 004b58bb
    test eax, eax                                # 004b58c2
    je.d8 L_004b5927                             # 004b58c4
    # block 0x004b58c6: entered by fall-through of je at 0x004b58c4, 3 instruction(s), ends with jne to 0x004b5927 (forward)
    movsx ecx, word ptr [0x6177b6]               # 004b58c6
    test ecx, ecx                                # 004b58cd
    jne.d8 L_004b5927                            # 004b58cf
    # block 0x004b58d1: entered by fall-through of jne at 0x004b58cf, 19 instruction(s), calls FUN_004c5377, falls into the block at 0x004b5927
    push 0x5519e4                                # 004b58d1
    push 0x617772                                # 004b58d6
    push 0x617752                                # 004b58db
    mov edx, dword ptr [0x5cf665]                # 004b58e0
    push edx                                     # 004b58e6
    mov eax, dword ptr [0x5d15e3]                # 004b58e7
    push eax                                     # 004b58ec
    mov ecx, 0x5cf659                            # 004b58ed
    call FUN_004c5377                            # 004b58f2
    push 0x551a14                                # 004b58f7
    push 0x617762                                # 004b58fc
    push 0x617742                                # 004b5901
    mov ecx, dword ptr [0x5cf665]                # 004b5906
    push ecx                                     # 004b590c
    mov edx, dword ptr [0x5d15e3]                # 004b590d
    push edx                                     # 004b5913
    mov ecx, 0x5cf659                            # 004b5914
    call FUN_004c5377                            # 004b5919
    mov word ptr [0x6177b4], 0x0                 # 004b591e
L_004b5927:
    # block 0x004b5927: entered by je at 0x004b58c4; jne at 0x004b58cf, 2 instruction(s), ends with forward jump to 0x004b593b
    mov word ptr [ebp - local_4], 0x0            # 004b5927
    jmp.d8 L_004b593b                            # 004b592d
L_004b592f:
    # block 0x004b592f: entered by jmp at 0x004b59fc, 3 instruction(s), falls into the block at 0x004b593b
    mov ax, word ptr [ebp - local_4]             # 004b592f
    .insn 0x66, 0x05, 0x0001{:u16}               # 004b5933
    mov word ptr [ebp - local_4], ax             # 004b5937
L_004b593b:
    # block 0x004b593b: entered by jmp at 0x004b592d, 3 instruction(s), ends with jge to 0x004b5a01 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b593b
    cmp ecx, 0x3                                 # 004b593f
    jge.d32 L_004b5a01                           # 004b5942
    # block 0x004b5948: entered by fall-through of jge at 0x004b5942, 2 instruction(s), ends with forward jump to 0x004b595c
    mov word ptr [ebp - local_8], 0x0            # 004b5948
    jmp.d8 L_004b595c                            # 004b594e
L_004b5950:
    # block 0x004b5950: entered by jmp at 0x004b59f7, 3 instruction(s), falls into the block at 0x004b595c
    mov dx, word ptr [ebp - local_8]             # 004b5950
    add dx, 0x1                                  # 004b5954
    mov word ptr [ebp - local_8], dx             # 004b5958
L_004b595c:
    # block 0x004b595c: entered by jmp at 0x004b594e, 4 instruction(s), ends with jge to 0x004b59fc (forward)
    movsx eax, word ptr [ebp - local_8]          # 004b595c
    movsx ecx, word ptr [0x591a22]               # 004b5960
    {load} cmp eax, ecx                          # 004b5967
    jge.d32 L_004b59fc                           # 004b5969
    # block 0x004b596f: entered by fall-through of jge at 0x004b5969, 8 instruction(s), ends with je to 0x004b59f7 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b596f
    imul edx, edx, 0xc                           # 004b5973
    movsx eax, word ptr [ebp - local_8]          # 004b5976
    mov cx, word ptr [edx + 2*eax + 0x5919fe]    # 004b597a
    mov word ptr [ebp - local_c], cx             # 004b5982
    movsx edx, word ptr [ebp - local_c]          # 004b5986
    cmp edx, -0x1                                # 004b598a
    je.d8 L_004b59f7                             # 004b598d
    # block 0x004b598f: entered by fall-through of je at 0x004b598d, 25 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004b59f7
    push 0x551a44                                # 004b598f
    movsx eax, word ptr [ebp - local_c]          # 004b5994
    imul eax, eax, 0x120                         # 004b5998
    movsx ecx, word ptr [ebp - local_4]          # 004b599e
    imul ecx, ecx, 0x60                          # 004b59a2
    lea edx, [eax + ecx + 0x617082]              # 004b59a5
    movsx eax, word ptr [ebp - local_8]          # 004b59ac
    shl eax, 0x4                                 # 004b59b0
    {load} add edx, eax                          # 004b59b3
    push edx                                     # 004b59b5
    movsx ecx, word ptr [0x61778e]               # 004b59b6
    imul ecx, ecx, 0x8d                          # 004b59bd
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b59c3
    movsx eax, word ptr [ebp - local_c]          # 004b59c9
    shl eax, 0x4                                 # 004b59cd
    lea ecx, [edx + eax + field_29]              # 004b59d0
    push ecx                                     # 004b59d4
    mov edx, dword ptr [0x5cf665]                # 004b59d5
    push edx                                     # 004b59db
    movsx eax, word ptr [0x61778c]               # 004b59dc
    imul eax, eax, 0x4a                          # 004b59e3
    mov ecx, dword ptr [eax + 0x5d1599]          # 004b59e6
    push ecx                                     # 004b59ec
    mov ecx, 0x5cf659                            # 004b59ed
    call FUN_004c5d4b                            # 004b59f2
L_004b59f7:
    # block 0x004b59f7: entered by je at 0x004b598d, 1 instruction(s), ends with backward jump to 0x004b5950
    jmp.d32 L_004b5950                           # 004b59f7
L_004b59fc:
    # block 0x004b59fc: entered by jge at 0x004b5969, 1 instruction(s), ends with backward jump to 0x004b592f
    jmp.d32 L_004b592f                           # 004b59fc
L_004b5a01:
    # block 0x004b5a01: entered by jge at 0x004b5942, 3 instruction(s), ends with je to 0x004b5a5d (forward)
    movsx edx, word ptr [0x6177b6]               # 004b5a01
    test edx, edx                                # 004b5a08
    je.d8 L_004b5a5d                             # 004b5a0a
    # block 0x004b5a0c: entered by fall-through of je at 0x004b5a0a, 17 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004b5a5d
    push 0x551a60                                # 004b5a0c
    push 0x617762                                # 004b5a11
    movsx eax, word ptr [0x61778e]               # 004b5a16
    imul eax, eax, 0x8d                          # 004b5a1d
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b5a23
    movsx edx, word ptr [0x617782]               # 004b5a29
    shl edx, 0x4                                 # 004b5a30
    lea eax, [ecx + edx + field_89]              # 004b5a33
    push eax                                     # 004b5a3a
    mov ecx, dword ptr [0x5cf665]                # 004b5a3b
    push ecx                                     # 004b5a41
    movsx edx, word ptr [0x61778c]               # 004b5a42
    imul edx, edx, 0x4a                          # 004b5a49
    mov eax, dword ptr [edx + 0x5d1599]          # 004b5a4c
    push eax                                     # 004b5a52
    mov ecx, 0x5cf659                            # 004b5a53
    call FUN_004c5d4b                            # 004b5a58
L_004b5a5d:
    # block 0x004b5a5d: entered by je at 0x004b5a0a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b5a5d
    pop ebp                                      # 004b5a5f
    ret                                          # 004b5a60

# --- data items (not part of the function) -------------------------
.org 0x004b5a61 - 0x401000
PAD_004b5a61:  # 15 byte(s) of int3 padding
    .fill 15, 1, 0xcc

