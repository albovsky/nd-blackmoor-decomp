# FUN_004ca81e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ca81e
# extent:       0x004ca81e-0x004ca92e (272 code bytes)
# span:         0x004ca81e-0x004ca92e (code 272, tables 0, padding 0)
# sha256:       88a58e73ab779cebdc6ab2e5d85bc9a9b4a6854231217f0bf6e43be2b70cdf1b
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ca81e
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is not read in the entry block before being written
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_54; [ecx + n] field_4, field_8, field_c, field_4c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 87 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_4c, 0x4c  # offset +0x4c
.equ field_54, 0x54  # offset +0x54

# --- external targets -----------------------------------------------

.org 0x004ca81e - 0x401000
.globl FUN_004ca81e
FUN_004ca81e:
    # block 0x004ca81e: entry, 12 instruction(s), ends with je to 0x004ca848 (forward)
    push ebp                                     # 004ca81e
    {load} mov ebp, esp                          # 004ca81f
    sub esp, 0x18                                # 004ca821
    mov eax, dword ptr [ebp + arg_8]             # 004ca824
    mov ecx, dword ptr [eax + field_4]           # 004ca827
    mov dword ptr [ebp - local_18], ecx          # 004ca82a
    mov edx, dword ptr [ebp + arg_c]             # 004ca82d
    mov dword ptr [ebp - local_14], edx          # 004ca830
    mov eax, dword ptr [ebp - local_18]          # 004ca833
    and eax, 0x4                                 # 004ca836
    test eax, eax                                # 004ca839
    je.d8 L_004ca848                             # 004ca83b
    # block 0x004ca83d: entered by fall-through of je at 0x004ca83b, 4 instruction(s), ends with forward jump to 0x004ca84f
    mov ecx, dword ptr [ebp + arg_8]             # 004ca83d
    mov edx, dword ptr [ecx + field_c]           # 004ca840
    mov dword ptr [ebp - local_c], edx           # 004ca843
    jmp.d8 L_004ca84f                            # 004ca846
L_004ca848:
    # block 0x004ca848: entered by je at 0x004ca83b, 1 instruction(s), falls into the block at 0x004ca84f
    mov dword ptr [ebp - local_c], 0x0           # 004ca848
L_004ca84f:
    # block 0x004ca84f: entered by jmp at 0x004ca846, 4 instruction(s), ends with je to 0x004ca864 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004ca84f
    and eax, 0x2                                 # 004ca852
    test eax, eax                                # 004ca855
    je.d8 L_004ca864                             # 004ca857
    # block 0x004ca859: entered by fall-through of je at 0x004ca857, 4 instruction(s), ends with forward jump to 0x004ca86b
    mov ecx, dword ptr [ebp + arg_8]             # 004ca859
    mov edx, dword ptr [ecx + field_8]           # 004ca85c
    mov dword ptr [ebp - local_4], edx           # 004ca85f
    jmp.d8 L_004ca86b                            # 004ca862
L_004ca864:
    # block 0x004ca864: entered by je at 0x004ca857, 1 instruction(s), falls into the block at 0x004ca86b
    mov dword ptr [ebp - local_4], 0x0           # 004ca864
L_004ca86b:
    # block 0x004ca86b: entered by jmp at 0x004ca862, 4 instruction(s), ends with je to 0x004ca88f (forward)
    mov eax, dword ptr [ebp - local_18]          # 004ca86b
    and eax, 0x1000                              # 004ca86e
    test eax, eax                                # 004ca873
    je.d8 L_004ca88f                             # 004ca875
    # block 0x004ca877: entered by fall-through of je at 0x004ca875, 5 instruction(s), ends with je to 0x004ca88f (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004ca877
    mov edx, dword ptr [ecx + field_4c]          # 004ca87a
    and edx, 0x40                                # 004ca87d
    test edx, edx                                # 004ca880
    je.d8 L_004ca88f                             # 004ca882
    # block 0x004ca884: entered by fall-through of je at 0x004ca882, 4 instruction(s), ends with forward jump to 0x004ca896
    mov eax, dword ptr [ebp + arg_8]             # 004ca884
    mov ecx, dword ptr [eax + field_54]          # 004ca887
    mov dword ptr [ebp - local_8], ecx           # 004ca88a
    jmp.d8 L_004ca896                            # 004ca88d
L_004ca88f:
    # block 0x004ca88f: entered by je at 0x004ca875; je at 0x004ca882, 1 instruction(s), falls into the block at 0x004ca896
    mov dword ptr [ebp - local_8], 0x0           # 004ca88f
L_004ca896:
    # block 0x004ca896: entered by jmp at 0x004ca88d, 2 instruction(s), ends with forward jump to 0x004ca8a8
    mov dword ptr [ebp - local_10], 0x0          # 004ca896
    jmp.d8 L_004ca8a8                            # 004ca89d
L_004ca89f:
    # block 0x004ca89f: entered by jmp at 0x004ca91e, 3 instruction(s), falls into the block at 0x004ca8a8
    mov edx, dword ptr [ebp - local_10]          # 004ca89f
    add edx, 0x1                                 # 004ca8a2
    mov dword ptr [ebp - local_10], edx          # 004ca8a5
L_004ca8a8:
    # block 0x004ca8a8: entered by jmp at 0x004ca89d, 2 instruction(s), ends with jge to 0x004ca923 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 004ca8a8
    jge.d8 L_004ca923                            # 004ca8ac
    # block 0x004ca8ae: entered by fall-through of jge at 0x004ca8ac, 5 instruction(s), ends with jne to 0x004ca91e (forward)
    mov eax, dword ptr [ebp - local_10]          # 004ca8ae
    shl eax, 0x6                                 # 004ca8b1
    mov ecx, dword ptr [eax + 0x552bf0]          # 004ca8b4
    cmp ecx, dword ptr [ebp - local_c]           # 004ca8ba
    jne.d8 L_004ca91e                            # 004ca8bd
    # block 0x004ca8bf: entered by fall-through of jne at 0x004ca8bd, 5 instruction(s), ends with jne to 0x004ca91e (forward)
    mov edx, dword ptr [ebp - local_10]          # 004ca8bf
    shl edx, 0x6                                 # 004ca8c2
    mov eax, dword ptr [edx + 0x552bf4]          # 004ca8c5
    cmp eax, dword ptr [ebp - local_4]           # 004ca8cb
    jne.d8 L_004ca91e                            # 004ca8ce
    # block 0x004ca8d0: entered by fall-through of jne at 0x004ca8ce, 5 instruction(s), ends with jne to 0x004ca91e (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004ca8d0
    shl ecx, 0x6                                 # 004ca8d3
    mov edx, dword ptr [ecx + 0x552bec]          # 004ca8d6
    cmp edx, dword ptr [ebp - local_8]           # 004ca8dc
    jne.d8 L_004ca91e                            # 004ca8df
    # block 0x004ca8e1: entered by fall-through of jne at 0x004ca8df, 16 instruction(s), ends with jne to 0x004ca917 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004ca8e1
    shl eax, 0x6                                 # 004ca8e4
    mov ecx, dword ptr [ebp - local_14]          # 004ca8e7
    mov edx, dword ptr [ecx]                     # 004ca8ea
    or edx, dword ptr [eax + 0x552be8]           # 004ca8ec
    mov eax, dword ptr [ebp - local_14]          # 004ca8f2
    mov dword ptr [eax], edx                     # 004ca8f5
    mov ecx, dword ptr [ebp - local_14]          # 004ca8f7
    mov edx, dword ptr [ecx + field_4]           # 004ca8fa
    add edx, 0x1                                 # 004ca8fd
    mov eax, dword ptr [ebp - local_14]          # 004ca900
    mov dword ptr [eax + field_4], edx           # 004ca903
    mov ecx, dword ptr [ebp - local_14]          # 004ca906
    mov edx, dword ptr [ecx]                     # 004ca909
    cmp edx, dword ptr [0x63a8d4]                # 004ca90b
    jne.d8 L_004ca917                            # 004ca911
    # block 0x004ca913: entered by fall-through of jne at 0x004ca911, 2 instruction(s), ends with forward jump to 0x004ca928
    {load} xor eax, eax                          # 004ca913
    jmp.d8 L_004ca928                            # 004ca915
L_004ca917:
    # block 0x004ca917: entered by jne at 0x004ca911, 2 instruction(s), ends with forward jump to 0x004ca928
    mov eax, 0x1                                 # 004ca917
    jmp.d8 L_004ca928                            # 004ca91c
L_004ca91e:
    # block 0x004ca91e: entered by jne at 0x004ca8bd; jne at 0x004ca8ce; jne at 0x004ca8df, 1 instruction(s), ends with backward jump to 0x004ca89f
    jmp.d32 L_004ca89f                           # 004ca91e
L_004ca923:
    # block 0x004ca923: entered by jge at 0x004ca8ac, 1 instruction(s), falls into the block at 0x004ca928
    mov eax, 0x1                                 # 004ca923
L_004ca928:
    # block 0x004ca928: entered by jmp at 0x004ca915; jmp at 0x004ca91c, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004ca928
    pop ebp                                      # 004ca92a
    ret 0x8                                      # 004ca92b

