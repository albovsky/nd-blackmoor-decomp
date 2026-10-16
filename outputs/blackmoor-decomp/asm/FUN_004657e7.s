# FUN_004657e7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004657e7
# extent:       0x004657e7-0x004659f0 (521 code bytes)
# span:         0x004657e7-0x004659f0 (code 521, tables 0, padding 0)
# sha256:       544f4be0ec47938f5b53feb9efbbe853b3dfe0e7e7749819c27e995a7ec6b64d
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004657e7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [ecx + n] field_51, field_61; [edx + n] field_51
# callees:      calls FUN_004c5377, FUN_0046453b, FUN_00454f29, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 136 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_51, 0x51  # offset +0x51
.equ field_61, 0x61  # offset +0x61

# --- external targets -----------------------------------------------
.set FUN_00454f29, .text + (0x00454f29 - 0x401000)
.set FUN_0046453b, .text + (0x0046453b - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004657e7 - 0x401000
.globl FUN_004657e7
FUN_004657e7:
    # block 0x004657e7: entry, 5 instruction(s), ends with je to 0x004659ec (forward)
    push ebp                                     # 004657e7
    {load} mov ebp, esp                          # 004657e8
    sub esp, 0x18                                # 004657ea
    cmp dword ptr [0x624b76], 0x0                # 004657ed
    je.d32 L_004659ec                            # 004657f4
    # block 0x004657fa: entered by fall-through of je at 0x004657f4, 6 instruction(s), ends with jne to 0x00465822 (forward)
    movsx eax, word ptr [0x624b6e]               # 004657fa
    imul eax, eax, 0x8d                          # 00465801
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00465807
    mov dword ptr [ebp - local_18], ecx          # 0046580d
    cmp dword ptr [0x624b7a], 0x0                # 00465810
    jne.d8 L_00465822                            # 00465817
    # block 0x00465819: entered by fall-through of jne at 0x00465817, 2 instruction(s), ends with je to 0x00465852 (forward)
    cmp dword ptr [0x624b7e], 0x0                # 00465819
    je.d8 L_00465852                             # 00465820
L_00465822:
    # block 0x00465822: entered by jne at 0x00465817; fall-through of je at 0x00465820, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x00465852
    push 0x54b3e8                                # 00465822
    push 0x624baa                                # 00465827
    push 0x624b8a                                # 0046582c
    mov edx, dword ptr [0x5cf665]                # 00465831
    push edx                                     # 00465837
    mov eax, dword ptr [0x5d15e3]                # 00465838
    push eax                                     # 0046583d
    mov ecx, 0x5cf659                            # 0046583e
    call FUN_004c5377                            # 00465843
    mov dword ptr [0x624b7e], 0x0                # 00465848
L_00465852:
    # block 0x00465852: entered by je at 0x00465820, 2 instruction(s), ends with je to 0x0046589d (forward)
    cmp dword ptr [0x624b82], 0x0                # 00465852
    je.d8 L_0046589d                             # 00465859
    # block 0x0046585b: entered by fall-through of je at 0x00465859, 16 instruction(s), calls FUN_0046453b, FUN_004c5377, falls into the block at 0x0046589d
    lea ecx, [ebp - local_14]                    # 0046585b
    push ecx                                     # 0046585e
    push 0x624bca                                # 0046585f
    mov ecx, 0x624b50                            # 00465864
    call FUN_0046453b                            # 00465869
    push 0x54b418                                # 0046586e
    lea edx, [ebp - local_14]                    # 00465873
    push edx                                     # 00465876
    push 0x624bca                                # 00465877
    mov eax, dword ptr [0x5cf665]                # 0046587c
    push eax                                     # 00465881
    mov ecx, dword ptr [0x5d15e3]                # 00465882
    push ecx                                     # 00465888
    mov ecx, 0x5cf659                            # 00465889
    call FUN_004c5377                            # 0046588e
    mov dword ptr [0x624b82], 0x0                # 00465893
L_0046589d:
    # block 0x0046589d: entered by je at 0x00465859, 2 instruction(s), ends with forward jump to 0x004658b1
    mov word ptr [ebp - local_4], 0x0            # 0046589d
    jmp.d8 L_004658b1                            # 004658a3
L_004658a5:
    # block 0x004658a5: entered by jmp at 0x0046594e, 3 instruction(s), falls into the block at 0x004658b1
    mov dx, word ptr [ebp - local_4]             # 004658a5
    add dx, 0x1                                  # 004658a9
    mov word ptr [ebp - local_4], dx             # 004658ad
L_004658b1:
    # block 0x004658b1: entered by jmp at 0x004658a3, 3 instruction(s), ends with jge to 0x00465953 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004658b1
    cmp eax, 0x5                                 # 004658b5
    jge.d32 L_00465953                           # 004658b8
    # block 0x004658be: entered by fall-through of jge at 0x004658b8, 9 instruction(s), ends with je to 0x0046594e (forward)
    {load} xor ecx, ecx                          # 004658be
    mov dword ptr [ebp - local_14], ecx          # 004658c0
    mov dword ptr [ebp - local_10], ecx          # 004658c3
    mov dword ptr [ebp - local_c], ecx           # 004658c6
    mov dword ptr [ebp - local_8], ecx           # 004658c9
    movsx edx, word ptr [0x624b86]               # 004658cc
    movsx eax, word ptr [ebp - local_4]          # 004658d3
    {load} cmp edx, eax                          # 004658d7
    je.d8 L_0046594e                             # 004658d9
    # block 0x004658db: entered by fall-through of je at 0x004658d9, 3 instruction(s), ends with jne to 0x0046594e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004658db
    cmp dword ptr [4*ecx + 0x624be4], 0x0        # 004658df
    jne.d8 L_0046594e                            # 004658e7
    # block 0x004658e9: entered by fall-through of jne at 0x004658e7, 30 instruction(s), calls FUN_00454f29, FUN_004c5d4b, falls into the block at 0x0046594e
    lea edx, [ebp - local_14]                    # 004658e9
    push edx                                     # 004658ec
    movsx eax, word ptr [ebp - local_4]          # 004658ed
    shl eax, 0x5                                 # 004658f1
    mov ecx, dword ptr [ebp - local_18]          # 004658f4
    lea edx, [ecx + eax + field_61]              # 004658f7
    push edx                                     # 004658fb
    mov ecx, 0x6249dc                            # 004658fc
    call FUN_00454f29                            # 00465901
    push 0x54b444                                # 00465906
    lea eax, [ebp - local_14]                    # 0046590b
    push eax                                     # 0046590e
    movsx ecx, word ptr [ebp - local_4]          # 0046590f
    shl ecx, 0x5                                 # 00465913
    mov edx, dword ptr [ebp - local_18]          # 00465916
    lea eax, [edx + ecx + field_51]              # 00465919
    push eax                                     # 0046591d
    mov ecx, dword ptr [0x5cf665]                # 0046591e
    push ecx                                     # 00465924
    movsx edx, word ptr [0x624b6c]               # 00465925
    imul edx, edx, 0x4a                          # 0046592c
    mov eax, dword ptr [edx + 0x5d1599]          # 0046592f
    push eax                                     # 00465935
    mov ecx, 0x5cf659                            # 00465936
    call FUN_004c5d4b                            # 0046593b
    {load} xor ecx, ecx                          # 00465940
    mov dword ptr [ebp - local_14], ecx          # 00465942
    mov dword ptr [ebp - local_10], ecx          # 00465945
    mov dword ptr [ebp - local_c], ecx           # 00465948
    mov dword ptr [ebp - local_8], ecx           # 0046594b
L_0046594e:
    # block 0x0046594e: entered by je at 0x004658d9; jne at 0x004658e7, 1 instruction(s), ends with backward jump to 0x004658a5
    jmp.d32 L_004658a5                           # 0046594e
L_00465953:
    # block 0x00465953: entered by jge at 0x004658b8, 26 instruction(s), calls FUN_0046453b, FUN_004c5d4b, ends with je to 0x004659ec (forward)
    lea edx, [ebp - local_14]                    # 00465953
    push edx                                     # 00465956
    mov eax, dword ptr [ebp - local_18]          # 00465957
    add eax, 0x41                                # 0046595a
    push eax                                     # 0046595d
    mov ecx, 0x624b50                            # 0046595e
    call FUN_0046453b                            # 00465963
    push 0x54b470                                # 00465968
    lea ecx, [ebp - local_14]                    # 0046596d
    push ecx                                     # 00465970
    push 0x624bf8                                # 00465971
    mov edx, dword ptr [0x5cf665]                # 00465976
    push edx                                     # 0046597c
    movsx eax, word ptr [0x624b6c]               # 0046597d
    imul eax, eax, 0x4a                          # 00465984
    mov ecx, dword ptr [eax + 0x5d1599]          # 00465987
    push ecx                                     # 0046598d
    mov ecx, 0x5cf659                            # 0046598e
    call FUN_004c5d4b                            # 00465993
    {load} xor edx, edx                          # 00465998
    mov dword ptr [ebp - local_14], edx          # 0046599a
    mov dword ptr [ebp - local_10], edx          # 0046599d
    mov dword ptr [ebp - local_c], edx           # 004659a0
    mov dword ptr [ebp - local_8], edx           # 004659a3
    cmp dword ptr [0x624b7a], 0x0                # 004659a6
    je.d8 L_004659ec                             # 004659ad
    # block 0x004659af: entered by fall-through of je at 0x004659ad, 15 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004659ec
    push 0x54b49c                                # 004659af
    push 0x624bba                                # 004659b4
    movsx eax, word ptr [0x624b86]               # 004659b9
    shl eax, 0x5                                 # 004659c0
    mov ecx, dword ptr [ebp - local_18]          # 004659c3
    lea edx, [ecx + eax + field_51]              # 004659c6
    push edx                                     # 004659ca
    mov eax, dword ptr [0x5cf665]                # 004659cb
    push eax                                     # 004659d0
    movsx ecx, word ptr [0x624b6c]               # 004659d1
    imul ecx, ecx, 0x4a                          # 004659d8
    mov edx, dword ptr [ecx + 0x5d1599]          # 004659db
    push edx                                     # 004659e1
    mov ecx, 0x5cf659                            # 004659e2
    call FUN_004c5d4b                            # 004659e7
L_004659ec:
    # block 0x004659ec: entered by je at 0x004657f4; je at 0x004659ad, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004659ec
    pop ebp                                      # 004659ee
    ret                                          # 004659ef

