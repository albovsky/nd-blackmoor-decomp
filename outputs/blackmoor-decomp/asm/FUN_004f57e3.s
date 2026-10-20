# FUN_004f57e3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f57e3
# extent:       0x004f57e3-0x004f594d (362 code bytes)
# span:         0x004f57e3-0x004f594d (code 362, tables 0, padding 0)
# sha256:       baf80b880eb76a5550dbccd6364373c9fba5fbc72610cad95590ebdc85758227
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_sound_fill_stream_buffer
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4f57e3.c.txt, not original source) refers to the data labelled s_CDirectSound__FillStreamBuffer___0055e5c0
# name-note:    Fills part of a stream channel buffer when the play cursor has passed; failure reports CDirectSound::FillStreamBuffer.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_10, field_3c2; [ecx + n] field_15e; [edx + n] field_4, field_c, field_10, field_3ce
# callees:      calls FUN_004f594d, FUN_004f356e, FUN_004fa2a8, FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 110 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_15e, 0x15e  # offset +0x15e
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ce, 0x3ce  # offset +0x3ce

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f356e, .text + (0x004f356e - 0x401000)
.set FUN_004f594d, .text + (0x004f594d - 0x401000)
.set FUN_004fa2a8, .text + (0x004fa2a8 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004f57e3 - 0x401000
.globl FUN_004f57e3
FUN_004f57e3:
    # block 0x004f57e3: entry, 20 instruction(s), ends with je to 0x004f583a (forward)
    push ebp                                     # 004f57e3
    {load} mov ebp, esp                          # 004f57e4
    sub esp, 0x14                                # 004f57e6
    mov dword ptr [ebp - local_14], ecx          # 004f57e9
    mov dword ptr [ebp - local_c], 0x0           # 004f57ec
    mov dword ptr [ebp - local_4], 0x5622        # 004f57f3
    mov eax, dword ptr [ebp - local_14]          # 004f57fa
    mov dword ptr [eax + field_3c2], 0x3e8       # 004f57fd
    mov ecx, dword ptr [ebp + arg_8]             # 004f5807
    imul ecx, ecx, 0x5bb                         # 004f580a
    mov edx, dword ptr [ebp - local_14]          # 004f5810
    mov eax, dword ptr [edx + field_3ce]         # 004f5813
    {load} add eax, ecx                          # 004f5819
    mov dword ptr [ebp - local_10], eax          # 004f581b
    mov ecx, dword ptr [ebp - local_10]          # 004f581e
    add ecx, 0x18a                               # 004f5821
    mov dword ptr [ebp - local_8], ecx           # 004f5827
    mov edx, dword ptr [ebp - local_8]           # 004f582a
    cmp dword ptr [edx + field_c], 0x0           # 004f582d
    je.d8 L_004f583a                             # 004f5831
    # block 0x004f5833: entered by fall-through of je at 0x004f5831, 2 instruction(s), ends with forward jump to 0x004f5947
    {load} xor eax, eax                          # 004f5833
    jmp.d32 L_004f5947                           # 004f5835
L_004f583a:
    # block 0x004f583a: entered by je at 0x004f5831, 5 instruction(s), ends with jb to 0x004f5861 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f583a
    mov ecx, dword ptr [ebp - local_8]           # 004f583d
    mov edx, dword ptr [eax + field_4]           # 004f5840
    cmp edx, dword ptr [ecx]                     # 004f5843
    jb.d8 L_004f5861                             # 004f5845
    # block 0x004f5847: entered by fall-through of jb at 0x004f5845, 6 instruction(s), ends with ja to 0x004f5861 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f5847
    mov ecx, dword ptr [eax]                     # 004f584a
    add ecx, 0x5622                              # 004f584c
    mov edx, dword ptr [ebp - local_8]           # 004f5852
    cmp dword ptr [edx + field_4], ecx           # 004f5855
    ja.d8 L_004f5861                             # 004f5858
    # block 0x004f585a: entered by fall-through of ja at 0x004f5858, 2 instruction(s), ends with forward jump to 0x004f5947
    {load} xor eax, eax                          # 004f585a
    jmp.d32 L_004f5947                           # 004f585c
L_004f5861:
    # block 0x004f5861: entered by jb at 0x004f5845; ja at 0x004f5858, 3 instruction(s), ends with jne to 0x004f5890 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f5861
    cmp dword ptr [eax + field_10], -0x1         # 004f5864
    jne.d8 L_004f5890                            # 004f5868
    # block 0x004f586a: entered by fall-through of jne at 0x004f5868, 6 instruction(s), ends with jge to 0x004f5890 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004f586a
    mov edx, dword ptr [ebp - local_8]           # 004f586d
    mov eax, dword ptr [ecx + field_15e]         # 004f5870
    sub eax, dword ptr [edx]                     # 004f5876
    cmp eax, 0x5622                              # 004f5878
    jge.d8 L_004f5890                            # 004f587d
    # block 0x004f587f: entered by fall-through of jge at 0x004f587d, 5 instruction(s), falls into the block at 0x004f5890
    mov ecx, dword ptr [ebp - local_10]          # 004f587f
    mov edx, dword ptr [ebp - local_8]           # 004f5882
    mov eax, dword ptr [ecx + field_15e]         # 004f5885
    sub eax, dword ptr [edx]                     # 004f588b
    mov dword ptr [ebp - local_4], eax           # 004f588d
L_004f5890:
    # block 0x004f5890: entered by jne at 0x004f5868; jge at 0x004f587d, 11 instruction(s), calls FUN_004f594d, ends with jne to 0x004f58ff (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f5890
    push ecx                                     # 004f5893
    mov edx, dword ptr [ebp - local_8]           # 004f5894
    mov eax, dword ptr [edx]                     # 004f5897
    push eax                                     # 004f5899
    mov ecx, dword ptr [ebp + arg_8]             # 004f589a
    push ecx                                     # 004f589d
    mov ecx, dword ptr [ebp - local_14]          # 004f589e
    call FUN_004f594d                            # 004f58a1
    test eax, eax                                # 004f58a6
    jne.d8 L_004f58ff                            # 004f58a8
    # block 0x004f58aa: entered by fall-through of jne at 0x004f58a8, 7 instruction(s), calls FUN_004f356e, ends with je to 0x004f58fb (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004f58aa
    push edx                                     # 004f58ad
    mov ecx, dword ptr [ebp - local_14]          # 004f58ae
    call FUN_004f356e                            # 004f58b1
    movsx eax, word ptr [0x63a4cd]               # 004f58b6
    test eax, eax                                # 004f58bd
    je.d8 L_004f58fb                             # 004f58bf
    # block 0x004f58c1: entered by fall-through of je at 0x004f58bf, 16 instruction(s), calls FUN_004fa2a8, FUN_0050ca3e, FUN_0044a2b7, FUN_0052139c, falls into the block at 0x004f58fb
    mov ecx, dword ptr [ebp - local_14]          # 004f58c1
    call FUN_004fa2a8                            # 004f58c4
    push eax                                     # 004f58c9
    mov ecx, dword ptr [ebp + arg_8]             # 004f58ca
    push ecx                                     # 004f58cd
    push 0x55e5c0                                # 004f58ce
    push 0x63888b                                # 004f58d3
    call FUN_0050ca3e                            # 004f58d8
    add esp, 0x10                                # 004f58dd
    push 0x63888b                                # 004f58e0
    call FUN_0044a2b7                            # 004f58e5
    add esp, 0x4                                 # 004f58ea
    push 0x0                                     # 004f58ed
    push 0x0                                     # 004f58ef
    push 0x55e5f4                                # 004f58f1
    call FUN_0052139c                            # 004f58f6
L_004f58fb:
    # block 0x004f58fb: entered by je at 0x004f58bf, 2 instruction(s), ends with forward jump to 0x004f5947
    {load} xor eax, eax                          # 004f58fb
    jmp.d8 L_004f5947                            # 004f58fd
L_004f58ff:
    # block 0x004f58ff: entered by jne at 0x004f58a8, 8 instruction(s), ends with jne to 0x004f5925 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f58ff
    mov eax, dword ptr [edx]                     # 004f5902
    add eax, dword ptr [ebp - local_4]           # 004f5904
    mov ecx, dword ptr [ebp - local_8]           # 004f5907
    mov dword ptr [ecx], eax                     # 004f590a
    mov edx, dword ptr [ebp - local_8]           # 004f590c
    cmp dword ptr [edx + field_10], -0x1         # 004f590f
    jne.d8 L_004f5925                            # 004f5913
    # block 0x004f5915: entered by fall-through of jne at 0x004f5913, 5 instruction(s), ends with jge to 0x004f5939 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f5915
    mov ecx, dword ptr [ebp - local_10]          # 004f5918
    mov edx, dword ptr [eax]                     # 004f591b
    cmp edx, dword ptr [ecx + field_15e]         # 004f591d
    jge.d8 L_004f5939                            # 004f5923
L_004f5925:
    # block 0x004f5925: entered by jne at 0x004f5913; fall-through of jge at 0x004f5923, 3 instruction(s), ends with je to 0x004f5942 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f5925
    cmp dword ptr [eax + field_10], -0x1         # 004f5928
    je.d8 L_004f5942                             # 004f592c
    # block 0x004f592e: entered by fall-through of je at 0x004f592c, 3 instruction(s), ends with jl to 0x004f5942 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f592e
    cmp dword ptr [ecx], 0x56220                 # 004f5931
    jl.d8 L_004f5942                             # 004f5937
L_004f5939:
    # block 0x004f5939: entered by jge at 0x004f5923; fall-through of jl at 0x004f5937, 2 instruction(s), falls into the block at 0x004f5942
    mov edx, dword ptr [ebp - local_8]           # 004f5939
    mov dword ptr [edx], 0x0                     # 004f593c
L_004f5942:
    # block 0x004f5942: entered by je at 0x004f592c; jl at 0x004f5937, 1 instruction(s), falls into the block at 0x004f5947
    mov eax, 0x1                                 # 004f5942
L_004f5947:
    # block 0x004f5947: entered by jmp at 0x004f5835; jmp at 0x004f585c; jmp at 0x004f58fd, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004f5947
    pop ebp                                      # 004f5949
    ret 0x4                                      # 004f594a

