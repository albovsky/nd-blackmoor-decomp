# FUN_004fe700
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe700
# extent:       0x004fe700-0x004fe863 (355 code bytes)
# span:         0x004fe700-0x004fe870 (code 355, tables 0, padding 13)
# sha256:       8b8ada3c1f3c56a118627622d770eb1d598857947f91d8b338dd9853d36c083e
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fe700
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c; [ebx + n] field_minus_100; [edx + n] field_8, field_c; [esi + n] field_8, field_c, field_10, field_14, field_18, field_1c, field_20, field_220, field_420, field_620, field_720, field_b20 and 1 more; [esp + n] stk_4, stk_c
# callees:      calls FUN_0050e936, FUN_005028f0, FUN_00502910, FUN_004ffc30; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 129 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_100, 0x100  # offset -0x100
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_220, 0x220  # offset +0x220
.equ field_420, 0x420  # offset +0x420
.equ field_620, 0x620  # offset +0x620
.equ field_720, 0x720  # offset +0x720
.equ field_b20, 0xb20  # offset +0xb20
.equ field_b24, 0xb24  # offset +0xb24

# --- external targets -----------------------------------------------
.set FUN_004ffc30, .text + (0x004ffc30 - 0x401000)
.set FUN_005028f0, .text + (0x005028f0 - 0x401000)
.set FUN_00502910, .text + (0x00502910 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x004fe700 - 0x401000
.globl FUN_004fe700
FUN_004fe700:
    # block 0x004fe700: entry, 6 instruction(s), ends with je to 0x004fe853 (forward)
    mov eax, dword ptr [esp + stk_4]             # 004fe700
    push esi                                     # 004fe704
    push edi                                     # 004fe705
    mov esi, dword ptr [eax + field_1c]          # 004fe706
    test esi, esi                                # 004fe709
    je.d32 L_004fe853                            # 004fe70b
    # block 0x004fe711: entered by fall-through of je at 0x004fe70b, 6 instruction(s), ends with jle to 0x004fe73a (forward)
    mov eax, dword ptr [esi + field_8]           # 004fe711
    push ebx                                     # 004fe714
    {load} xor ebx, ebx                          # 004fe715
    push ebp                                     # 004fe717
    test eax, eax                                # 004fe718
    jle.d8 L_004fe73a                            # 004fe71a
    # block 0x004fe71c: entered by fall-through of jle at 0x004fe71a, 1 instruction(s), falls into the block at 0x004fe71f
    lea ebp, [esi + field_20]                    # 004fe71c
L_004fe71f:
    # block 0x004fe71f: entered by jl at 0x004fe738, 3 instruction(s), ends with je to 0x004fe72f (forward)
    {disp8} mov eax, dword ptr [ebp]             # 004fe71f
    test eax, eax                                # 004fe722
    je.d8 L_004fe72f                             # 004fe724
    # block 0x004fe726: entered by fall-through of je at 0x004fe724, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fe72f
    push eax                                     # 004fe726
    call FUN_0050e936                            # 004fe727
    add esp, 0x4                                 # 004fe72c
L_004fe72f:
    # block 0x004fe72f: entered by je at 0x004fe724, 5 instruction(s), ends with jl to 0x004fe71f (backward)
    mov eax, dword ptr [esi + field_8]           # 004fe72f
    inc ebx                                      # 004fe732
    add ebp, 0x4                                 # 004fe733
    {load} cmp ebx, eax                          # 004fe736
    jl.d8 L_004fe71f                             # 004fe738
L_004fe73a:
    # block 0x004fe73a: entered by jle at 0x004fe71a; fall-through of jl at 0x004fe738, 4 instruction(s), ends with jle to 0x004fe76a (forward)
    mov eax, dword ptr [esi + field_c]           # 004fe73a
    {load} xor ebp, ebp                          # 004fe73d
    test eax, eax                                # 004fe73f
    jle.d8 L_004fe76a                            # 004fe741
    # block 0x004fe743: entered by fall-through of jle at 0x004fe741, 1 instruction(s), falls into the block at 0x004fe749
    lea ebx, [esi + field_220]                   # 004fe743
L_004fe749:
    # block 0x004fe749: entered by jl at 0x004fe768, 11 instruction(s), calls indirect dword ptr [edx + 0x8], ends with jl to 0x004fe749 (backward)
    mov ecx, dword ptr [ebx - field_minus_100]   # 004fe749
    mov eax, dword ptr [ebx]                     # 004fe74f
    push eax                                     # 004fe751
    mov edx, dword ptr [4*ecx + 0x5669f4]        # 004fe752
    call dword ptr [edx + field_8]               # 004fe759
    mov eax, dword ptr [esi + field_c]           # 004fe75c
    add esp, 0x4                                 # 004fe75f
    inc ebp                                      # 004fe762
    add ebx, 0x4                                 # 004fe763
    {load} cmp ebp, eax                          # 004fe766
    jl.d8 L_004fe749                             # 004fe768
L_004fe76a:
    # block 0x004fe76a: entered by jle at 0x004fe741; fall-through of jl at 0x004fe768, 4 instruction(s), ends with jle to 0x004fe79a (forward)
    mov eax, dword ptr [esi + field_10]          # 004fe76a
    {load} xor ebp, ebp                          # 004fe76d
    test eax, eax                                # 004fe76f
    jle.d8 L_004fe79a                            # 004fe771
    # block 0x004fe773: entered by fall-through of jle at 0x004fe771, 1 instruction(s), falls into the block at 0x004fe779
    lea ebx, [esi + field_420]                   # 004fe773
L_004fe779:
    # block 0x004fe779: entered by jl at 0x004fe798, 11 instruction(s), calls indirect dword ptr [edx + 0xc], ends with jl to 0x004fe779 (backward)
    mov ecx, dword ptr [ebx - field_minus_100]   # 004fe779
    mov eax, dword ptr [ebx]                     # 004fe77f
    push eax                                     # 004fe781
    mov edx, dword ptr [4*ecx + 0x5669e0]        # 004fe782
    call dword ptr [edx + field_c]               # 004fe789
    mov eax, dword ptr [esi + field_10]          # 004fe78c
    add esp, 0x4                                 # 004fe78f
    inc ebp                                      # 004fe792
    add ebx, 0x4                                 # 004fe793
    {load} cmp ebp, eax                          # 004fe796
    jl.d8 L_004fe779                             # 004fe798
L_004fe79a:
    # block 0x004fe79a: entered by jle at 0x004fe771; fall-through of jl at 0x004fe798, 4 instruction(s), ends with jle to 0x004fe7ca (forward)
    mov eax, dword ptr [esi + field_14]          # 004fe79a
    {load} xor ebp, ebp                          # 004fe79d
    test eax, eax                                # 004fe79f
    jle.d8 L_004fe7ca                            # 004fe7a1
    # block 0x004fe7a3: entered by fall-through of jle at 0x004fe7a1, 1 instruction(s), falls into the block at 0x004fe7a9
    lea ebx, [esi + field_620]                   # 004fe7a3
L_004fe7a9:
    # block 0x004fe7a9: entered by jl at 0x004fe7c8, 11 instruction(s), calls indirect dword ptr [edx + 0xc], ends with jl to 0x004fe7a9 (backward)
    mov ecx, dword ptr [ebx - field_minus_100]   # 004fe7a9
    mov eax, dword ptr [ebx]                     # 004fe7af
    push eax                                     # 004fe7b1
    mov edx, dword ptr [4*ecx + 0x5669e8]        # 004fe7b2
    call dword ptr [edx + field_c]               # 004fe7b9
    mov eax, dword ptr [esi + field_14]          # 004fe7bc
    add esp, 0x4                                 # 004fe7bf
    inc ebp                                      # 004fe7c2
    add ebx, 0x4                                 # 004fe7c3
    {load} cmp ebp, eax                          # 004fe7c6
    jl.d8 L_004fe7a9                             # 004fe7c8
L_004fe7ca:
    # block 0x004fe7ca: entered by jle at 0x004fe7a1; fall-through of jl at 0x004fe7c8, 4 instruction(s), ends with jle to 0x004fe80f (forward)
    mov eax, dword ptr [esi + field_18]          # 004fe7ca
    {load} xor ebx, ebx                          # 004fe7cd
    test eax, eax                                # 004fe7cf
    jle.d8 L_004fe80f                            # 004fe7d1
    # block 0x004fe7d3: entered by fall-through of jle at 0x004fe7d1, 2 instruction(s), falls into the block at 0x004fe7db
    {load} xor edi, edi                          # 004fe7d3
    lea ebp, [esi + field_720]                   # 004fe7d5
L_004fe7db:
    # block 0x004fe7db: entered by jl at 0x004fe80d, 3 instruction(s), ends with je to 0x004fe7eb (forward)
    {disp8} mov eax, dword ptr [ebp]             # 004fe7db
    test eax, eax                                # 004fe7de
    je.d8 L_004fe7eb                             # 004fe7e0
    # block 0x004fe7e2: entered by fall-through of je at 0x004fe7e0, 3 instruction(s), calls FUN_005028f0, falls into the block at 0x004fe7eb
    push eax                                     # 004fe7e2
    call FUN_005028f0                            # 004fe7e3
    add esp, 0x4                                 # 004fe7e8
L_004fe7eb:
    # block 0x004fe7eb: entered by je at 0x004fe7e0, 3 instruction(s), ends with je to 0x004fe801 (forward)
    mov eax, dword ptr [esi + field_b20]         # 004fe7eb
    test eax, eax                                # 004fe7f1
    je.d8 L_004fe801                             # 004fe7f3
    # block 0x004fe7f5: entered by fall-through of je at 0x004fe7f3, 4 instruction(s), calls FUN_00502910, falls into the block at 0x004fe801
    lea ecx, [edi + eax]                         # 004fe7f5
    push ecx                                     # 004fe7f8
    call FUN_00502910                            # 004fe7f9
    add esp, 0x4                                 # 004fe7fe
L_004fe801:
    # block 0x004fe801: entered by je at 0x004fe7f3, 6 instruction(s), ends with jl to 0x004fe7db (backward)
    mov eax, dword ptr [esi + field_18]          # 004fe801
    inc ebx                                      # 004fe804
    add ebp, 0x4                                 # 004fe805
    add edi, 0x2c                                # 004fe808
    {load} cmp ebx, eax                          # 004fe80b
    jl.d8 L_004fe7db                             # 004fe80d
L_004fe80f:
    # block 0x004fe80f: entered by jle at 0x004fe7d1; fall-through of jl at 0x004fe80d, 3 instruction(s), ends with je to 0x004fe822 (forward)
    mov eax, dword ptr [esi + field_b20]         # 004fe80f
    test eax, eax                                # 004fe815
    je.d8 L_004fe822                             # 004fe817
    # block 0x004fe819: entered by fall-through of je at 0x004fe817, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x004fe822
    push eax                                     # 004fe819
    call FUN_0050e936                            # 004fe81a
    add esp, 0x4                                 # 004fe81f
L_004fe822:
    # block 0x004fe822: entered by je at 0x004fe817, 4 instruction(s), ends with jle to 0x004fe848 (forward)
    mov eax, dword ptr [esi + field_1c]          # 004fe822
    {load} xor ebx, ebx                          # 004fe825
    test eax, eax                                # 004fe827
    jle.d8 L_004fe848                            # 004fe829
    # block 0x004fe82b: entered by fall-through of jle at 0x004fe829, 1 instruction(s), falls into the block at 0x004fe831
    lea ebp, [esi + field_b24]                   # 004fe82b
L_004fe831:
    # block 0x004fe831: entered by jl at 0x004fe846, 9 instruction(s), calls FUN_004ffc30, ends with jl to 0x004fe831 (backward)
    {disp8} mov edx, dword ptr [ebp]             # 004fe831
    push edx                                     # 004fe834
    call FUN_004ffc30                            # 004fe835
    mov eax, dword ptr [esi + field_1c]          # 004fe83a
    add esp, 0x4                                 # 004fe83d
    inc ebx                                      # 004fe840
    add ebp, 0x4                                 # 004fe841
    {load} cmp ebx, eax                          # 004fe844
    jl.d8 L_004fe831                             # 004fe846
L_004fe848:
    # block 0x004fe848: entered by jle at 0x004fe829; fall-through of jl at 0x004fe846, 5 instruction(s), calls FUN_0050e936, falls into the block at 0x004fe853
    push esi                                     # 004fe848
    call FUN_0050e936                            # 004fe849
    add esp, 0x4                                 # 004fe84e
    pop ebp                                      # 004fe851
    pop ebx                                      # 004fe852
L_004fe853:
    # block 0x004fe853: entered by je at 0x004fe70b, 7 instruction(s), ends with ret
    mov edi, dword ptr [esp + stk_c]             # 004fe853
    mov ecx, 0x8                                 # 004fe857
    {load} xor eax, eax                          # 004fe85c
    rep stosd dword ptr es:[edi], eax            # 004fe85e
    pop edi                                      # 004fe860
    pop esi                                      # 004fe861
    ret                                          # 004fe862

# --- data items (not part of the function) -------------------------
.org 0x004fe863 - 0x401000
PAD_004fe863:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

