# FUN_0047ea73
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047ea73
# extent:       0x0047ea73-0x0047ec06 (403 code bytes)
# span:         0x0047ea73-0x0047ec06 (code 403, tables 0, padding 0)
# sha256:       b7d749bd5a60867f2126f964406947e35fd016f4d473b9fa6e5ee5ed5070f092
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# name:         RectRecords::test_overlap
# arguments:    thiscall: ecx=this (spilled to [ebp-0x24]), [ebp+8]=index of record A (signed dword, scaled by 0x25 with imul), [ebp+0xc]=index of record B (signed dword, scaled the same way), callee pops 8 (ret 8), returns eax=1 when the two rectangles intersect and all four intersection bounds differ from -1, otherwise eax=0
# locals:       [ebp-0x24]=saved this, [ebp-0x20]=address of record A (this+0x7b4+indexA*0x25), [ebp-4]=address of record B, [ebp-0x18]=rectangle A pointer (record A+2), [ebp-0x1c]=rectangle B pointer (record B+2), [ebp-0x14]=lower bound of the intersection on the first axis, [ebp-0x10]=lower bound on the second axis, [ebp-0xc]=upper bound on the first axis, [ebp-8]=upper bound on the second axis (all four start at -1, the bounds are computed but only tested against -1, never returned)
# fields:       this+0x7b4: array of 0x25-byte records, record+2: a rectangle of four signed dwords at rect+0 (lower bound, first axis), rect+4 (lower bound, second axis), rect+8 (upper bound, first axis), rect+0xc (upper bound, second axis), no globals touched, no stores into this
# callees:      none
# track-n:      host-adapter: none
# unverified:   The record class and the meaning of the rectangle are not established, the method name and the labels for the two axes (the pairs at +0/+8 and +4/+0xc) are mine, only the offsets and the signed comparisons are verified in the bytes. Coordinates are compared as signed dwords with inclusive bounds (rectangles that only touch, A.upper == B.lower, count as intersecting). A valid intersection whose computed lower or upper bound equals -1 is reported as no intersection (the -1 test at the end is on the computed bounds, not only a sentinel for the early returns), this is the original behaviour and is kept as is. Neither index is range checked and the unaligned dword accesses at record+2 are taken as they come. The only caller found (Ghidra pseudocode of 0x47ed96, which passes one index and loops over the record count at this+0x13a2, not re-verified in disassembly) was not examined for what it does with the result.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_record_b, 0x4  # [ebp - 0x4]: address of record B, this+0x7b4+indexB*0x25
.equ local_overlap_hi_v, 0x8  # [ebp - 0x8]: upper bound of the intersection on the second axis, initial -1
.equ local_overlap_hi_u, 0xc  # [ebp - 0xc]: upper bound of the intersection on the first axis, initial -1
.equ local_overlap_lo_v, 0x10  # [ebp - 0x10]: lower bound of the intersection on the second axis, initial -1
.equ local_overlap_lo_u, 0x14  # [ebp - 0x14]: lower bound of the intersection on the first axis, initial -1
.equ local_rect_a, 0x18  # [ebp - 0x18]: rectangle A pointer, record A + 2
.equ local_rect_b, 0x1c  # [ebp - 0x1c]: rectangle B pointer, record B + 2
.equ local_record_a, 0x20  # [ebp - 0x20]: address of record A, this+0x7b4+indexA*0x25
.equ local_saved_this, 0x24  # [ebp - 0x24]: this, spilled from ecx
.equ arg_index_a, 0x8  # [ebp + 0x8]: index of record A, signed dword
.equ arg_index_b, 0xc  # [ebp + 0xc]: index of record B, signed dword

.equ this_records_base, 0x7b4  # this+0x7b4: start of the array of 0x25-byte records

.equ rect_a_lo_v, 0x4  # rectangle A + 4: lower bound on the second axis, signed dword
.equ rect_a_hi_u, 0x8  # rectangle A + 8: upper bound on the first axis, signed dword
.equ rect_a_hi_v, 0xc  # rectangle A + 0xc: upper bound on the second axis, signed dword

.equ rect_b_lo_v, 0x4  # rectangle B + 4: lower bound on the second axis, signed dword
.equ rect_b_hi_u, 0x8  # rectangle B + 8: upper bound on the first axis, signed dword
.equ rect_b_hi_v, 0xc  # rectangle B + 0xc: upper bound on the second axis, signed dword

# --- external targets -----------------------------------------------

.org 0x0047ea73 - 0x401000
.globl FUN_0047ea73
FUN_0047ea73:
    # block 0x0047ea73: entry: build a 0x24-byte frame, spill this, record A = this+0x7b4+indexA*0x25, record B = this+0x7b4+indexB*0x25, rect A = record A+2, rect B = record B+2, set the four overlap bounds to -1, compare A.lo_u with B.lo_u (signed) and jump to L_a_lo_u_not_below_b when A.lo_u >= B.lo_u
    push ebp                                     # 0047ea73
    {load} mov ebp, esp                          # 0047ea74
    sub esp, 0x24                                # 0047ea76
    mov dword ptr [ebp - local_saved_this], ecx          # 0047ea79
    mov eax, dword ptr [ebp + arg_index_a]             # 0047ea7c
    imul eax, eax, 0x25                          # 0047ea7f
    mov ecx, dword ptr [ebp - local_saved_this]          # 0047ea82
    lea edx, [ecx + eax + this_records_base]             # 0047ea85
    mov dword ptr [ebp - local_record_a], edx          # 0047ea8c
    mov eax, dword ptr [ebp + arg_index_b]             # 0047ea8f
    imul eax, eax, 0x25                          # 0047ea92
    mov ecx, dword ptr [ebp - local_saved_this]          # 0047ea95
    lea edx, [ecx + eax + this_records_base]             # 0047ea98
    mov dword ptr [ebp - local_record_b], edx           # 0047ea9f
    mov eax, dword ptr [ebp - local_record_a]          # 0047eaa2
    add eax, 0x2                                 # 0047eaa5
    mov dword ptr [ebp - local_rect_a], eax          # 0047eaa8
    mov ecx, dword ptr [ebp - local_record_b]           # 0047eaab
    add ecx, 0x2                                 # 0047eaae
    mov dword ptr [ebp - local_rect_b], ecx          # 0047eab1
    or edx, -0x1                                 # 0047eab4
    mov dword ptr [ebp - local_overlap_lo_u], edx          # 0047eab7
    mov dword ptr [ebp - local_overlap_lo_v], edx          # 0047eaba
    mov dword ptr [ebp - local_overlap_hi_u], edx           # 0047eabd
    mov dword ptr [ebp - local_overlap_hi_v], edx           # 0047eac0
    mov eax, dword ptr [ebp - local_rect_a]          # 0047eac3
    mov ecx, dword ptr [ebp - local_rect_b]          # 0047eac6
    mov edx, dword ptr [eax]                     # 0047eac9
    cmp edx, dword ptr [ecx]                     # 0047eacb
    jge.d8 L_a_lo_u_not_below_b                            # 0047eacd
    # block 0x0047eacf: A.lo_u < B.lo_u: compare A.hi_u with B.lo_u (signed), A.hi_u < B.lo_u means the rectangles are disjoint, jump to L_disjoint_u_a_below
    mov eax, dword ptr [ebp - local_rect_a]          # 0047eacf
    mov ecx, dword ptr [ebp - local_rect_b]          # 0047ead2
    mov edx, dword ptr [eax + rect_a_hi_u]           # 0047ead5
    cmp edx, dword ptr [ecx]                     # 0047ead8
    jl.d8 L_disjoint_u_a_below                             # 0047eada
    # block 0x0047eadc: overlap_lo_u = B.lo_u, compare A.hi_u with B.hi_u (signed), A.hi_u <= B.hi_u jumps to L_hi_u_from_a_case1
    mov eax, dword ptr [ebp - local_rect_b]          # 0047eadc
    mov ecx, dword ptr [eax]                     # 0047eadf
    mov dword ptr [ebp - local_overlap_lo_u], ecx          # 0047eae1
    mov edx, dword ptr [ebp - local_rect_a]          # 0047eae4
    mov eax, dword ptr [ebp - local_rect_b]          # 0047eae7
    mov ecx, dword ptr [edx + rect_a_hi_u]           # 0047eaea
    cmp ecx, dword ptr [eax + rect_b_hi_u]           # 0047eaed
    jle.d8 L_hi_u_from_a_case1                            # 0047eaf0
    # block 0x0047eaf2: A.hi_u > B.hi_u: overlap_hi_u = B.hi_u, jump to L_join_u_case1
    mov edx, dword ptr [ebp - local_rect_b]          # 0047eaf2
    mov eax, dword ptr [edx + rect_b_hi_u]           # 0047eaf5
    mov dword ptr [ebp - local_overlap_hi_u], eax           # 0047eaf8
    jmp.d8 L_join_u_case1                            # 0047eafb
L_hi_u_from_a_case1:
    # block 0x0047eafd: A.hi_u <= B.hi_u: overlap_hi_u = A.hi_u
    mov ecx, dword ptr [ebp - local_rect_a]          # 0047eafd
    mov edx, dword ptr [ecx + rect_a_hi_u]           # 0047eb00
    mov dword ptr [ebp - local_overlap_hi_u], edx           # 0047eb03
L_join_u_case1:
    # block 0x0047eb06: first axis done for this case, jump to L_join_u
    jmp.d8 L_join_u                            # 0047eb06
L_disjoint_u_a_below:
    # block 0x0047eb08: disjoint on the first axis: eax = 0, jump to L_epilogue
    {load} xor eax, eax                          # 0047eb08
    jmp.d32 L_epilogue                           # 0047eb0a
L_join_u:
    # block 0x0047eb0f: join: jump to L_axis_v_start
    jmp.d8 L_axis_v_start                            # 0047eb0f
L_a_lo_u_not_below_b:
    # block 0x0047eb11: A.lo_u >= B.lo_u: compare A.lo_u with B.hi_u (signed), A.lo_u > B.hi_u means disjoint, jump to L_disjoint_u_b_below
    mov eax, dword ptr [ebp - local_rect_a]          # 0047eb11
    mov ecx, dword ptr [ebp - local_rect_b]          # 0047eb14
    mov edx, dword ptr [eax]                     # 0047eb17
    cmp edx, dword ptr [ecx + rect_b_hi_u]           # 0047eb19
    jg.d8 L_disjoint_u_b_below                             # 0047eb1c
    # block 0x0047eb1e: overlap_lo_u = A.lo_u, compare A.hi_u with B.hi_u (signed), A.hi_u > B.hi_u jumps to L_hi_u_from_b_case2
    mov eax, dword ptr [ebp - local_rect_a]          # 0047eb1e
    mov ecx, dword ptr [eax]                     # 0047eb21
    mov dword ptr [ebp - local_overlap_lo_u], ecx          # 0047eb23
    mov edx, dword ptr [ebp - local_rect_a]          # 0047eb26
    mov eax, dword ptr [ebp - local_rect_b]          # 0047eb29
    mov ecx, dword ptr [edx + rect_a_hi_u]           # 0047eb2c
    cmp ecx, dword ptr [eax + rect_b_hi_u]           # 0047eb2f
    jg.d8 L_hi_u_from_b_case2                             # 0047eb32
    # block 0x0047eb34: A.hi_u <= B.hi_u: overlap_hi_u = A.hi_u, jump to L_join_u_case2
    mov edx, dword ptr [ebp - local_rect_a]          # 0047eb34
    mov eax, dword ptr [edx + rect_a_hi_u]           # 0047eb37
    mov dword ptr [ebp - local_overlap_hi_u], eax           # 0047eb3a
    jmp.d8 L_join_u_case2                            # 0047eb3d
L_hi_u_from_b_case2:
    # block 0x0047eb3f: A.hi_u > B.hi_u: overlap_hi_u = B.hi_u
    mov ecx, dword ptr [ebp - local_rect_b]          # 0047eb3f
    mov edx, dword ptr [ecx + rect_b_hi_u]           # 0047eb42
    mov dword ptr [ebp - local_overlap_hi_u], edx           # 0047eb45
L_join_u_case2:
    # block 0x0047eb48: first axis done for this case, jump to L_axis_v_start
    jmp.d8 L_axis_v_start                            # 0047eb48
L_disjoint_u_b_below:
    # block 0x0047eb4a: disjoint on the first axis: eax = 0, jump to L_epilogue
    {load} xor eax, eax                          # 0047eb4a
    jmp.d32 L_epilogue                           # 0047eb4c
L_axis_v_start:
    # block 0x0047eb51: second axis: compare A.lo_v with B.lo_v (signed), A.lo_v >= B.lo_v jumps to L_a_lo_v_not_below_b
    mov eax, dword ptr [ebp - local_rect_a]          # 0047eb51
    mov ecx, dword ptr [ebp - local_rect_b]          # 0047eb54
    mov edx, dword ptr [eax + rect_a_lo_v]           # 0047eb57
    cmp edx, dword ptr [ecx + rect_b_lo_v]           # 0047eb5a
    jge.d8 L_a_lo_v_not_below_b                            # 0047eb5d
    # block 0x0047eb5f: A.lo_v < B.lo_v: compare A.hi_v with B.lo_v (signed), A.hi_v < B.lo_v means disjoint, jump to L_disjoint_v_a_below
    mov eax, dword ptr [ebp - local_rect_a]          # 0047eb5f
    mov ecx, dword ptr [ebp - local_rect_b]          # 0047eb62
    mov edx, dword ptr [eax + rect_a_hi_v]           # 0047eb65
    cmp edx, dword ptr [ecx + rect_b_lo_v]           # 0047eb68
    jl.d8 L_disjoint_v_a_below                             # 0047eb6b
    # block 0x0047eb6d: overlap_lo_v = B.lo_v, compare A.hi_v with B.hi_v (signed), A.hi_v <= B.hi_v jumps to L_hi_v_from_a_case1
    mov eax, dword ptr [ebp - local_rect_b]          # 0047eb6d
    mov ecx, dword ptr [eax + rect_b_lo_v]           # 0047eb70
    mov dword ptr [ebp - local_overlap_lo_v], ecx          # 0047eb73
    mov edx, dword ptr [ebp - local_rect_a]          # 0047eb76
    mov eax, dword ptr [ebp - local_rect_b]          # 0047eb79
    mov ecx, dword ptr [edx + rect_a_hi_v]           # 0047eb7c
    cmp ecx, dword ptr [eax + rect_b_hi_v]           # 0047eb7f
    jle.d8 L_hi_v_from_a_case1                            # 0047eb82
    # block 0x0047eb84: A.hi_v > B.hi_v: overlap_hi_v = B.hi_v, jump to L_join_v_case1
    mov edx, dword ptr [ebp - local_rect_b]          # 0047eb84
    mov eax, dword ptr [edx + rect_b_hi_v]           # 0047eb87
    mov dword ptr [ebp - local_overlap_hi_v], eax           # 0047eb8a
    jmp.d8 L_join_v_case1                            # 0047eb8d
L_hi_v_from_a_case1:
    # block 0x0047eb8f: A.hi_v <= B.hi_v: overlap_hi_v = A.hi_v
    mov ecx, dword ptr [ebp - local_rect_a]          # 0047eb8f
    mov edx, dword ptr [ecx + rect_a_hi_v]           # 0047eb92
    mov dword ptr [ebp - local_overlap_hi_v], edx           # 0047eb95
L_join_v_case1:
    # block 0x0047eb98: second axis done for this case, jump to L_join_v
    jmp.d8 L_join_v                            # 0047eb98
L_disjoint_v_a_below:
    # block 0x0047eb9a: disjoint on the second axis: eax = 0, jump to L_epilogue
    {load} xor eax, eax                          # 0047eb9a
    jmp.d8 L_epilogue                            # 0047eb9c
L_join_v:
    # block 0x0047eb9e: join: jump to L_check_bounds
    jmp.d8 L_check_bounds                            # 0047eb9e
L_a_lo_v_not_below_b:
    # block 0x0047eba0: A.lo_v >= B.lo_v: compare A.lo_v with B.hi_v (signed), A.lo_v > B.hi_v means disjoint, jump to L_disjoint_v_b_below
    mov eax, dword ptr [ebp - local_rect_a]          # 0047eba0
    mov ecx, dword ptr [ebp - local_rect_b]          # 0047eba3
    mov edx, dword ptr [eax + rect_a_lo_v]           # 0047eba6
    cmp edx, dword ptr [ecx + rect_b_hi_v]           # 0047eba9
    jg.d8 L_disjoint_v_b_below                             # 0047ebac
    # block 0x0047ebae: overlap_lo_v = A.lo_v, compare A.hi_v with B.hi_v (signed), A.hi_v > B.hi_v jumps to L_hi_v_from_b_case2
    mov eax, dword ptr [ebp - local_rect_a]          # 0047ebae
    mov ecx, dword ptr [eax + rect_a_lo_v]           # 0047ebb1
    mov dword ptr [ebp - local_overlap_lo_v], ecx          # 0047ebb4
    mov edx, dword ptr [ebp - local_rect_a]          # 0047ebb7
    mov eax, dword ptr [ebp - local_rect_b]          # 0047ebba
    mov ecx, dword ptr [edx + rect_a_hi_v]           # 0047ebbd
    cmp ecx, dword ptr [eax + rect_b_hi_v]           # 0047ebc0
    jg.d8 L_hi_v_from_b_case2                             # 0047ebc3
    # block 0x0047ebc5: A.hi_v <= B.hi_v: overlap_hi_v = A.hi_v, jump to L_join_v_case2
    mov edx, dword ptr [ebp - local_rect_a]          # 0047ebc5
    mov eax, dword ptr [edx + rect_a_hi_v]           # 0047ebc8
    mov dword ptr [ebp - local_overlap_hi_v], eax           # 0047ebcb
    jmp.d8 L_join_v_case2                            # 0047ebce
L_hi_v_from_b_case2:
    # block 0x0047ebd0: A.hi_v > B.hi_v: overlap_hi_v = B.hi_v
    mov ecx, dword ptr [ebp - local_rect_b]          # 0047ebd0
    mov edx, dword ptr [ecx + rect_b_hi_v]           # 0047ebd3
    mov dword ptr [ebp - local_overlap_hi_v], edx           # 0047ebd6
L_join_v_case2:
    # block 0x0047ebd9: second axis done for this case, jump to L_check_bounds
    jmp.d8 L_check_bounds                            # 0047ebd9
L_disjoint_v_b_below:
    # block 0x0047ebdb: disjoint on the second axis: eax = 0, jump to L_epilogue
    {load} xor eax, eax                          # 0047ebdb
    jmp.d8 L_epilogue                            # 0047ebdd
L_check_bounds:
    # block 0x0047ebdf: both axes intersect: if overlap_lo_v equals -1 jump to L_return_0
    cmp dword ptr [ebp - local_overlap_lo_v], -0x1         # 0047ebdf
    je.d8 L_return_0                             # 0047ebe3
    # block 0x0047ebe5: if overlap_hi_v equals -1 jump to L_return_0
    cmp dword ptr [ebp - local_overlap_hi_v], -0x1          # 0047ebe5
    je.d8 L_return_0                             # 0047ebe9
    # block 0x0047ebeb: if overlap_lo_u equals -1 jump to L_return_0
    cmp dword ptr [ebp - local_overlap_lo_u], -0x1         # 0047ebeb
    je.d8 L_return_0                             # 0047ebef
    # block 0x0047ebf1: if overlap_hi_u equals -1 fall into L_return_0, otherwise jump to L_return_1
    cmp dword ptr [ebp - local_overlap_hi_u], -0x1          # 0047ebf1
    jne.d8 L_return_1                            # 0047ebf5
L_return_0:
    # block 0x0047ebf7: a computed bound is -1: eax = 0, jump to L_epilogue
    {load} xor eax, eax                          # 0047ebf7
    jmp.d8 L_epilogue                            # 0047ebf9
L_return_1:
    # block 0x0047ebfb: all four bounds differ from -1: eax = 1
    mov eax, 0x1                                 # 0047ebfb
L_epilogue:
    # block 0x0047ec00: epilogue: restore the frame and return, popping the two stack arguments (ret 8)
    {load} mov esp, ebp                          # 0047ec00
    pop ebp                                      # 0047ec02
    ret 0x8                                      # 0047ec03
