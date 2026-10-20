# FUN_004c5770
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c5770
# extent:       0x004c5770-0x004c5976 (518 code bytes)
# span:         0x004c5770-0x004c5976 (code 518, tables 0, padding 0)
# sha256:       a632c4b0a48d44d688a9b01096899b1cee877b9d78c0e50ae812d2dd4617cb9d
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_opaque_layer_blit
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_3f_runtime.h:422 says "CONVO3F_BLIT_OPAQUE = 3 / * 0x4c5770: opaque layer * /"
# name-note:    Opaque layer blit variant used by the 0x3f conversation renderer.
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_64, local_78, local_88, local_8c, local_90, local_94, local_190, local_194, local_198 and 2 more
# fields:       [eax + n] field_4, field_c; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_004c4067, FUN_004c4202, FUN_004c952f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 160 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_64, 0x64  # offset -0x64
.equ local_78, 0x78  # offset -0x78
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_190, 0x190  # offset -0x190
.equ local_194, 0x194  # offset -0x194
.equ local_198, 0x198  # offset -0x198
.equ local_19c, 0x19c  # offset -0x19c
.equ local_1a0, 0x1a0  # offset -0x1a0
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_004c4067, .text + (0x004c4067 - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c952f, .text + (0x004c952f - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004c5770 - 0x401000
.globl FUN_004c5770
FUN_004c5770:
    # block 0x004c5770: entry, 9 instruction(s), ends with je to 0x004c586c (forward)
    push ebp                                     # 004c5770
    {load} mov ebp, esp                          # 004c5771
    sub esp, 0x1a0                               # 004c5773
    push esi                                     # 004c5779
    push edi                                     # 004c577a
    mov dword ptr [ebp - local_1a0], ecx         # 004c577b
    movsx eax, word ptr [0x63a4cd]               # 004c5781
    test eax, eax                                # 004c5788
    je.d32 L_004c586c                            # 004c578a
    # block 0x004c5790: entered by fall-through of je at 0x004c578a, 23 instruction(s), ends with jne to 0x004c57fe (forward)
    mov ecx, dword ptr [ebp + arg_10]            # 004c5790
    mov edx, dword ptr [ebp + arg_10]            # 004c5793
    mov eax, dword ptr [ecx + field_8]           # 004c5796
    sub eax, dword ptr [edx]                     # 004c5799
    mov dword ptr [ebp - local_19c], eax         # 004c579b
    mov ecx, dword ptr [ebp + arg_10]            # 004c57a1
    mov edx, dword ptr [ebp + arg_10]            # 004c57a4
    mov eax, dword ptr [ecx + field_c]           # 004c57a7
    sub eax, dword ptr [edx + field_4]           # 004c57aa
    mov dword ptr [ebp - local_198], eax         # 004c57ad
    mov ecx, dword ptr [ebp + arg_14]            # 004c57b3
    mov edx, dword ptr [ebp + arg_14]            # 004c57b6
    mov eax, dword ptr [ecx + field_8]           # 004c57b9
    sub eax, dword ptr [edx]                     # 004c57bc
    mov dword ptr [ebp - local_94], eax          # 004c57be
    mov ecx, dword ptr [ebp + arg_14]            # 004c57c4
    mov edx, dword ptr [ebp + arg_14]            # 004c57c7
    mov eax, dword ptr [ecx + field_c]           # 004c57ca
    sub eax, dword ptr [edx + field_4]           # 004c57cd
    mov dword ptr [ebp - local_194], eax         # 004c57d0
    mov ecx, dword ptr [ebp - local_19c]         # 004c57d6
    cmp ecx, dword ptr [ebp - local_94]          # 004c57dc
    jne.d8 L_004c57fe                            # 004c57e2
    # block 0x004c57e4: entered by fall-through of jne at 0x004c57e2, 3 instruction(s), ends with jne to 0x004c57fe (forward)
    mov edx, dword ptr [ebp - local_198]         # 004c57e4
    cmp edx, dword ptr [ebp - local_194]         # 004c57ea
    jne.d8 L_004c57fe                            # 004c57f0
    # block 0x004c57f2: entered by fall-through of jne at 0x004c57f0, 2 instruction(s), ends with je to 0x004c57fe (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004c57f2
    je.d8 L_004c57fe                             # 004c57f6
    # block 0x004c57f8: entered by fall-through of je at 0x004c57f6, 2 instruction(s), ends with jne to 0x004c586c (forward)
    cmp dword ptr [ebp + arg_c], 0x0             # 004c57f8
    jne.d8 L_004c586c                            # 004c57fc
L_004c57fe:
    # block 0x004c57fe: entered by jne at 0x004c57e2; jne at 0x004c57f0; je at 0x004c57f6; fall-through of jne at 0x004c57fc, 39 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004c596e
    mov eax, dword ptr [ebp + arg_14]            # 004c57fe
    mov ecx, dword ptr [eax + field_c]           # 004c5801
    push ecx                                     # 004c5804
    mov edx, dword ptr [ebp + arg_14]            # 004c5805
    mov eax, dword ptr [edx + field_8]           # 004c5808
    push eax                                     # 004c580b
    mov ecx, dword ptr [ebp + arg_14]            # 004c580c
    mov edx, dword ptr [ecx + field_4]           # 004c580f
    push edx                                     # 004c5812
    mov eax, dword ptr [ebp + arg_14]            # 004c5813
    mov ecx, dword ptr [eax]                     # 004c5816
    push ecx                                     # 004c5818
    mov edx, dword ptr [ebp + arg_10]            # 004c5819
    mov eax, dword ptr [edx + field_c]           # 004c581c
    push eax                                     # 004c581f
    mov ecx, dword ptr [ebp + arg_10]            # 004c5820
    mov edx, dword ptr [ecx + field_8]           # 004c5823
    push edx                                     # 004c5826
    mov eax, dword ptr [ebp + arg_10]            # 004c5827
    mov ecx, dword ptr [eax + field_4]           # 004c582a
    push ecx                                     # 004c582d
    mov edx, dword ptr [ebp + arg_10]            # 004c582e
    mov eax, dword ptr [edx]                     # 004c5831
    push eax                                     # 004c5833
    mov ecx, dword ptr [ebp + arg_1c]            # 004c5834
    push ecx                                     # 004c5837
    push 0x554a7c                                # 004c5838
    lea edx, [ebp - local_190]                   # 004c583d
    push edx                                     # 004c5843
    call FUN_0050ca3e                            # 004c5844
    add esp, 0x2c                                # 004c5849
    push 0x0                                     # 004c584c
    push 0x0                                     # 004c584e
    lea eax, [ebp - local_190]                   # 004c5850
    push eax                                     # 004c5856
    call FUN_0052139c                            # 004c5857
    mov ecx, dword ptr [ebp - local_1a0]         # 004c585c
    call FUN_004c97b4                            # 004c5862
    jmp.d32 L_004c596e                           # 004c5867
L_004c586c:
    # block 0x004c586c: entered by je at 0x004c578a; jne at 0x004c57fc, 40 instruction(s), calls FUN_004c4067, ends with forward jump to 0x004c5900
    mov ecx, dword ptr [ebp + arg_10]            # 004c586c
    mov edx, dword ptr [ecx + field_4]           # 004c586f
    imul edx, dword ptr [ebp + arg_18]           # 004c5872
    mov eax, dword ptr [ebp + arg_8]             # 004c5876
    {load} add eax, edx                          # 004c5879
    movsx ecx, word ptr [0x639895]               # 004c587b
    mov edx, dword ptr [ebp + arg_10]            # 004c5882
    mov edx, dword ptr [edx]                     # 004c5885
    imul edx, ecx                                # 004c5887
    {load} add eax, edx                          # 004c588a
    mov dword ptr [ebp - local_8], eax           # 004c588c
    push 0x20                                    # 004c588f
    mov eax, dword ptr [ebp + arg_1c]            # 004c5891
    push eax                                     # 004c5894
    lea ecx, [ebp - local_88]                    # 004c5895
    push ecx                                     # 004c589b
    mov edx, dword ptr [ebp + arg_14]            # 004c589c
    push edx                                     # 004c589f
    mov eax, dword ptr [ebp + arg_c]             # 004c58a0
    push eax                                     # 004c58a3
    mov ecx, dword ptr [ebp - local_1a0]         # 004c58a4
    call FUN_004c4067                            # 004c58aa
    mov ecx, dword ptr [ebp + arg_10]            # 004c58af
    mov edx, dword ptr [ebp + arg_10]            # 004c58b2
    mov eax, dword ptr [ecx + field_c]           # 004c58b5
    sub eax, dword ptr [edx + field_4]           # 004c58b8
    add eax, 0x1                                 # 004c58bb
    mov dword ptr [ebp - local_8c], eax          # 004c58be
    mov ecx, dword ptr [ebp + arg_10]            # 004c58c4
    mov edx, dword ptr [ebp + arg_10]            # 004c58c7
    mov eax, dword ptr [ecx + field_8]           # 004c58ca
    sub eax, dword ptr [edx]                     # 004c58cd
    add eax, 0x1                                 # 004c58cf
    movsx ecx, word ptr [0x639895]               # 004c58d2
    imul eax, ecx                                # 004c58d9
    mov dword ptr [ebp - local_c], eax           # 004c58dc
    mov edx, dword ptr [ebp - local_64]          # 004c58df
    mov dword ptr [ebp - local_4], edx           # 004c58e2
    mov dword ptr [ebp - local_90], 0x0          # 004c58e5
    jmp.d8 L_004c5900                            # 004c58ef
L_004c58f1:
    # block 0x004c58f1: entered by jmp at 0x004c5937, 3 instruction(s), falls into the block at 0x004c5900
    mov eax, dword ptr [ebp - local_90]          # 004c58f1
    add eax, 0x1                                 # 004c58f7
    mov dword ptr [ebp - local_90], eax          # 004c58fa
L_004c5900:
    # block 0x004c5900: entered by jmp at 0x004c58ef, 3 instruction(s), ends with jge to 0x004c5939 (forward)
    mov ecx, dword ptr [ebp - local_90]          # 004c5900
    cmp ecx, dword ptr [ebp - local_8c]          # 004c5906
    jge.d8 L_004c5939                            # 004c590c
    # block 0x004c590e: entered by fall-through of jge at 0x004c590c, 16 instruction(s), ends with backward jump to 0x004c58f1
    mov ecx, dword ptr [ebp - local_c]           # 004c590e
    mov esi, dword ptr [ebp - local_8]           # 004c5911
    mov edi, dword ptr [ebp - local_4]           # 004c5914
    {load} mov edx, ecx                          # 004c5917
    shr ecx, 0x2                                 # 004c5919
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c591c
    {load} mov ecx, edx                          # 004c591e
    and ecx, 0x3                                 # 004c5920
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c5923
    mov eax, dword ptr [ebp - local_8]           # 004c5925
    add eax, dword ptr [ebp + arg_18]            # 004c5928
    mov dword ptr [ebp - local_8], eax           # 004c592b
    mov ecx, dword ptr [ebp - local_4]           # 004c592e
    add ecx, dword ptr [ebp - local_78]          # 004c5931
    mov dword ptr [ebp - local_4], ecx           # 004c5934
    jmp.d8 L_004c58f1                            # 004c5937
L_004c5939:
    # block 0x004c5939: entered by jge at 0x004c590c, 11 instruction(s), calls FUN_004c4202, ends with jne to 0x004c596e (forward)
    push 0x554b20                                # 004c5939
    mov edx, dword ptr [ebp + arg_14]            # 004c593e
    push edx                                     # 004c5941
    mov eax, dword ptr [ebp + arg_c]             # 004c5942
    push eax                                     # 004c5945
    mov ecx, dword ptr [ebp - local_1a0]         # 004c5946
    call FUN_004c4202                            # 004c594c
    mov ecx, dword ptr [ebp - local_1a0]         # 004c5951
    mov edx, dword ptr [ebp + arg_c]             # 004c5957
    cmp edx, dword ptr [ecx + field_c]           # 004c595a
    jne.d8 L_004c596e                            # 004c595d
    # block 0x004c595f: entered by fall-through of jne at 0x004c595d, 4 instruction(s), calls FUN_004c952f, falls into the block at 0x004c596e
    mov eax, dword ptr [ebp + arg_14]            # 004c595f
    push eax                                     # 004c5962
    mov ecx, dword ptr [ebp - local_1a0]         # 004c5963
    call FUN_004c952f                            # 004c5969
L_004c596e:
    # block 0x004c596e: entered by jmp at 0x004c5867; jne at 0x004c595d, 5 instruction(s), ends with ret 0x18
    pop edi                                      # 004c596e
    pop esi                                      # 004c596f
    {load} mov esp, ebp                          # 004c5970
    pop ebp                                      # 004c5972
    ret 0x18                                     # 004c5973

