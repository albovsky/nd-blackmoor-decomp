# FUN_0046ebff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046ebff
# extent:       0x0046ebff-0x0046ee20 (545 code bytes)
# span:         0x0046ebff-0x0046ee20 (code 545, tables 0, padding 0)
# sha256:       213d8f44003046cbba49bdb55cdbf7273f56671e22c1f27f9ff6cd27f20fd0fb
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46ebff_click_27c2_27c3
# naming:       native port src/original_methods_fl24a.c:m46ebff_click_27c2_27c3 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m46ebff_click_27c2_27c3 (events 27c2/27c3, tick, 4f6334/4fb2e3, 4709bb/4709de loop, 448d11). Differential and oracle: every instruction reached. See tasks/fl24a-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_1e, field_28, field_32, field_52, field_5f, field_67, field_85; [ecx + n] field_1e, field_28, field_2c, field_36, field_46, field_53; [edx + n] field_1e, field_21, field_2e, field_52, field_53, field_5f, field_64, field_85
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004f6334, FUN_004fb2e3, FUN_004709bb, FUN_004709de, FUN_00448d11
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24a.c:m46ebff_click_27c2_27c3 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 146 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_46, 0x46  # offset +0x46
.equ field_52, 0x52  # offset +0x52
.equ field_53, 0x53  # offset +0x53
.equ field_5f, 0x5f  # offset +0x5f
.equ field_64, 0x64  # offset +0x64
.equ field_67, 0x67  # offset +0x67
.equ field_85, 0x85  # offset +0x85

# --- external targets -----------------------------------------------
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004709bb, .text + (0x004709bb - 0x401000)
.set FUN_004709de, .text + (0x004709de - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0046ebff - 0x401000
.globl FUN_0046ebff
FUN_0046ebff:
    # block 0x0046ebff: entry, 17 instruction(s), ends with je to 0x0046ee1a (forward)
    push ebp                                     # 0046ebff
    {load} mov ebp, esp                          # 0046ec00
    sub esp, 0x20                                # 0046ec02
    push esi                                     # 0046ec05
    push edi                                     # 0046ec06
    mov dword ptr [ebp - local_20], ecx          # 0046ec07
    mov eax, dword ptr [ebp - local_20]          # 0046ec0a
    movsx ecx, word ptr [eax + field_1e]         # 0046ec0d
    imul ecx, ecx, 0x8d                          # 0046ec11
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046ec17
    mov dword ptr [ebp - local_c], edx           # 0046ec1d
    mov eax, dword ptr [ebp - local_c]           # 0046ec20
    add eax, 0x64d                               # 0046ec23
    mov dword ptr [ebp - local_8], eax           # 0046ec28
    mov ecx, dword ptr [ebp - local_20]          # 0046ec2b
    cmp dword ptr [ecx + field_46], 0x0          # 0046ec2e
    je.d32 L_0046ee1a                            # 0046ec32
    # block 0x0046ec38: entered by fall-through of je at 0x0046ec32, 3 instruction(s), ends with jne to 0x0046ee1a (forward)
    mov edx, dword ptr [ebp - local_20]          # 0046ec38
    cmp dword ptr [edx + field_5f], 0x0          # 0046ec3b
    jne.d32 L_0046ee1a                           # 0046ec3f
    # block 0x0046ec45: entered by fall-through of jne at 0x0046ec3f, 3 instruction(s), ends with jne to 0x0046ee1a (forward)
    mov eax, dword ptr [ebp - local_20]          # 0046ec45
    cmp dword ptr [eax + field_28], 0x0          # 0046ec48
    jne.d32 L_0046ee1a                           # 0046ec4c
    # block 0x0046ec52: entered by fall-through of jne at 0x0046ec4c, 5 instruction(s), ends with jne to 0x0046ee1a (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0046ec52
    movsx edx, word ptr [ecx + field_1e]         # 0046ec55
    imul edx, edx, 0x8d                          # 0046ec59
    cmp dword ptr [edx + 0x5bb632], 0x1          # 0046ec5f
    jne.d32 L_0046ee1a                           # 0046ec66
    # block 0x0046ec6c: entered by fall-through of jne at 0x0046ec66, 2 instruction(s), ends with jne to 0x0046ed4a (forward)
    cmp dword ptr [0x5c39e5], 0x27c2             # 0046ec6c
    jne.d32 L_0046ed4a                           # 0046ec76
    # block 0x0046ec7c: entered by fall-through of jne at 0x0046ec76, 5 instruction(s), ends with jge to 0x0046ec92 (forward)
    mov eax, dword ptr [ebp - local_20]          # 0046ec7c
    {load} xor ecx, ecx                          # 0046ec7f
    mov cl, byte ptr [eax + field_52]            # 0046ec81
    cmp ecx, 0xa                                 # 0046ec84
    jge.d8 L_0046ec92                            # 0046ec87
    # block 0x0046ec89: entered by fall-through of jge at 0x0046ec87, 2 instruction(s), ends with forward jump to 0x0046eca0
    mov dword ptr [ebp - local_4], 0x0           # 0046ec89
    jmp.d8 L_0046eca0                            # 0046ec90
L_0046ec92:
    # block 0x0046ec92: entered by jge at 0x0046ec87, 5 instruction(s), falls into the block at 0x0046eca0
    mov edx, dword ptr [ebp - local_20]          # 0046ec92
    {load} xor eax, eax                          # 0046ec95
    mov al, byte ptr [edx + field_52]            # 0046ec97
    sub eax, 0x9                                 # 0046ec9a
    mov dword ptr [ebp - local_4], eax           # 0046ec9d
L_0046eca0:
    # block 0x0046eca0: entered by jmp at 0x0046ec90, 14 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x0046ed45 (forward)
    mov ecx, dword ptr [ebp - local_20]          # 0046eca0
    mov dword ptr [ecx + field_28], 0x1          # 0046eca3
    mov edx, dword ptr [ebp - local_20]          # 0046ecaa
    movzx ax, byte ptr [edx + field_52]          # 0046ecad
    mov ecx, dword ptr [ebp - local_20]          # 0046ecb2
    mov word ptr [ecx + field_2c], ax            # 0046ecb5
    call dword ptr [0x52a23c]                    # 0046ecb9
    add eax, 0xfa                                # 0046ecbf
    mov edx, dword ptr [ebp - local_20]          # 0046ecc4
    mov dword ptr [edx + field_2e], eax          # 0046ecc7
    mov eax, dword ptr [ebp - local_20]          # 0046ecca
    mov dword ptr [eax + field_32], 0x1          # 0046eccd
    cmp dword ptr [0x5bb1ca], 0x0                # 0046ecd4
    je.d8 L_0046ed45                             # 0046ecdb
    # block 0x0046ecdd: entered by fall-through of je at 0x0046ecdb, 9 instruction(s), ends with je to 0x0046ed45 (forward)
    mov edi, 0x54c140                            # 0046ecdd
    mov ecx, dword ptr [ebp - local_4]           # 0046ece2
    imul ecx, ecx, 0x95                          # 0046ece5
    mov edx, dword ptr [ebp - local_8]           # 0046eceb
    lea esi, [edx + ecx + field_64]              # 0046ecee
    mov ecx, 0x9                                 # 0046ecf2
    {load} xor eax, eax                          # 0046ecf7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046ecf9
    je.d8 L_0046ed45                             # 0046ecfb
    # block 0x0046ecfd: entered by fall-through of je at 0x0046ecfb, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x0046ed45 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0046ecfd
    imul ecx, ecx, 0x95                          # 0046ed00
    mov edx, dword ptr [ebp - local_8]           # 0046ed06
    movsx eax, word ptr [edx + ecx + field_85]   # 0046ed09
    mov dword ptr [ebp - local_1c], eax          # 0046ed11
    mov ecx, dword ptr [ebp - local_1c]          # 0046ed14
    push ecx                                     # 0046ed17
    mov ecx, 0x5cf1eb                            # 0046ed18
    call FUN_004f6334                            # 0046ed1d
    test eax, eax                                # 0046ed22
    jne.d8 L_0046ed45                            # 0046ed24
    # block 0x0046ed26: entered by fall-through of jne at 0x0046ed24, 7 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0046ed45
    mov edx, dword ptr [ebp - local_4]           # 0046ed26
    imul edx, edx, 0x95                          # 0046ed29
    mov eax, dword ptr [ebp - local_8]           # 0046ed2f
    mov cx, word ptr [eax + edx + field_85]      # 0046ed32
    push ecx                                     # 0046ed3a
    mov ecx, 0x5c3a67                            # 0046ed3b
    call FUN_004fb2e3                            # 0046ed40
L_0046ed45:
    # block 0x0046ed45: entered by je at 0x0046ecdb; je at 0x0046ecfb; jne at 0x0046ed24, 1 instruction(s), ends with forward jump to 0x0046ee1a
    jmp.d32 L_0046ee1a                           # 0046ed45
L_0046ed4a:
    # block 0x0046ed4a: entered by jne at 0x0046ec76, 2 instruction(s), ends with jne to 0x0046ee1a (forward)
    cmp dword ptr [0x5c39e5], 0x27c3             # 0046ed4a
    jne.d32 L_0046ee1a                           # 0046ed54
    # block 0x0046ed5a: entered by fall-through of jne at 0x0046ed54, 6 instruction(s), ends with forward jump to 0x0046ed83
    mov edx, dword ptr [ebp - local_20]          # 0046ed5a
    movsx eax, word ptr [edx + field_1e]         # 0046ed5d
    imul eax, eax, 0x8d                          # 0046ed61
    mov dword ptr [eax + 0x5bb632], 0x2          # 0046ed67
    mov dword ptr [ebp - local_18], 0x0          # 0046ed71
    jmp.d8 L_0046ed83                            # 0046ed78
L_0046ed7a:
    # block 0x0046ed7a: entered by jmp at 0x0046ed93, 3 instruction(s), falls into the block at 0x0046ed83
    mov ecx, dword ptr [ebp - local_18]          # 0046ed7a
    add ecx, 0x1                                 # 0046ed7d
    mov dword ptr [ebp - local_18], ecx          # 0046ed80
L_0046ed83:
    # block 0x0046ed83: entered by jmp at 0x0046ed78, 2 instruction(s), ends with jge to 0x0046ed95 (forward)
    cmp dword ptr [ebp - local_18], 0x8          # 0046ed83
    jge.d8 L_0046ed95                            # 0046ed87
    # block 0x0046ed89: entered by fall-through of jge at 0x0046ed87, 4 instruction(s), ends with backward jump to 0x0046ed7a
    mov edx, dword ptr [ebp - local_20]          # 0046ed89
    add edx, dword ptr [ebp - local_18]          # 0046ed8c
    mov byte ptr [edx + field_53], 0x1           # 0046ed8f
    jmp.d8 L_0046ed7a                            # 0046ed93
L_0046ed95:
    # block 0x0046ed95: entered by jge at 0x0046ed87, 6 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0046edba
    mov eax, dword ptr [ebp - local_20]          # 0046ed95
    mov dword ptr [eax + field_5f], 0x1          # 0046ed98
    call dword ptr [0x52a23c]                    # 0046ed9f
    mov dword ptr [ebp - local_14], eax          # 0046eda5
    mov dword ptr [ebp - local_10], 0x0          # 0046eda8
    jmp.d8 L_0046edba                            # 0046edaf
L_0046edb1:
    # block 0x0046edb1: entered by jmp at 0x0046edfe, 3 instruction(s), falls into the block at 0x0046edba
    mov ecx, dword ptr [ebp - local_10]          # 0046edb1
    add ecx, 0x1                                 # 0046edb4
    mov dword ptr [ebp - local_10], ecx          # 0046edb7
L_0046edba:
    # block 0x0046edba: entered by jmp at 0x0046edaf, 4 instruction(s), ends with jge to 0x0046ee00 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046edba
    movsx eax, word ptr [edx + field_21]         # 0046edbd
    cmp dword ptr [ebp - local_10], eax          # 0046edc1
    jge.d8 L_0046ee00                            # 0046edc4
    # block 0x0046edc6: entered by fall-through of jge at 0x0046edc4, 20 instruction(s), calls FUN_004709bb, FUN_004709de, ends with backward jump to 0x0046edb1
    mov ecx, dword ptr [ebp - local_20]          # 0046edc6
    add ecx, dword ptr [ebp - local_10]          # 0046edc9
    {load} xor edx, edx                          # 0046edcc
    mov dl, byte ptr [ecx + field_53]            # 0046edce
    push edx                                     # 0046edd1
    mov ecx, dword ptr [ebp - local_20]          # 0046edd2
    call FUN_004709bb                            # 0046edd5
    push eax                                     # 0046edda
    mov eax, dword ptr [ebp - local_10]          # 0046eddb
    mov ecx, dword ptr [ebp - local_20]          # 0046edde
    movsx edx, word ptr [ecx + 2*eax + field_36] # 0046ede1
    push edx                                     # 0046ede6
    mov ecx, dword ptr [ebp - local_20]          # 0046ede7
    call FUN_004709de                            # 0046edea
    mov ecx, dword ptr [ebp - local_14]          # 0046edef
    {load} add ecx, eax                          # 0046edf2
    mov edx, dword ptr [ebp - local_10]          # 0046edf4
    mov eax, dword ptr [ebp - local_20]          # 0046edf7
    mov dword ptr [eax + 4*edx + field_67], ecx  # 0046edfa
    jmp.d8 L_0046edb1                            # 0046edfe
L_0046ee00:
    # block 0x0046ee00: entered by jge at 0x0046edc4, 7 instruction(s), calls FUN_00448d11, falls into the block at 0x0046ee1a
    push 0x0                                     # 0046ee00
    push -0x1                                    # 0046ee02
    push 0x54c14c                                # 0046ee04
    mov ecx, dword ptr [0x5d03b3]                # 0046ee09
    push ecx                                     # 0046ee0f
    mov ecx, 0x619a05                            # 0046ee10
    call FUN_00448d11                            # 0046ee15
L_0046ee1a:
    # block 0x0046ee1a: entered by je at 0x0046ec32; jne at 0x0046ec3f; jne at 0x0046ec4c; jne at 0x0046ec66; more, 5 instruction(s), ends with ret
    pop edi                                      # 0046ee1a
    pop esi                                      # 0046ee1b
    {load} mov esp, ebp                          # 0046ee1c
    pop ebp                                      # 0046ee1e
    ret                                          # 0046ee1f

