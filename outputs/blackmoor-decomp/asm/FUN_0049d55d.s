# FUN_0049d55d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049d55d
# extent:       0x0049d55d-0x0049d755 (504 code bytes)
# span:         0x0049d55d-0x0049d755 (code 504, tables 0, padding 0)
# sha256:       3ea89a40b5caf9d1b9e55bff4bc528a56d8ca8b3fa0deb0a9983713c5118a2ee
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# name:         MapGrid::expand_cell_flags_to_double_grids
# arguments:    thiscall: ecx=this (saved at [ebp-local_this]), no stack arguments, plain ret, no defined return value. esi and edi are saved and restored around the row copy
# locals:       frame 0x18 bytes: [ebp-4]=row index r (0 up to this+0xe04), [ebp-0xc]=doubled row index 2r, [ebp-8]=column index c (0 up to this+0xe00), [ebp-0x14]=doubled column index 2c, [ebp-0x10]=flag byte of the current cell (only the low byte is written, every read is masked with 0xff), [ebp-0x18]=this
# fields:       this+0x1c: dword stride, in dwords, of the two doubled grids, this+0xde4: pointer to the byte map (one flag byte per cell, row stride this+0xe00 bytes), this+0xe00: dword number of map columns, this+0xe04: dword number of map rows, this+0xe38: pointer to dword grid A (row stride this+0x1c dwords), this+0xe3c: pointer to dword grid B (same stride), globals 0x006329c9: dword set to 2r and 0x006329cd: dword set to 2c when a cell has flag bit 4
# callees:      none (the dword row copy is inline rep movsd)
# track-n:      host-adapter: none
# unverified:   The name, the field names and the grid names are role labels chosen from the arithmetic. What the three flag bits mean in the game (bit 1 into grid A, bit 2 into grid B, bit 4 into the two globals) is not established, only the bit tests and the stores are. Which class this is and how the two grids and the byte map are allocated are not shown here: the routine trusts that grid A and grid B each hold at least 2*this+0xe04 rows of this+0x1c dwords, and has no null or bounds check, so the native port must reject mismatched sizes explicitly. The unfinished pseudocode of 0x49c889 (a hint only) sets this+0xe00 = 2*width+1, this+0xe04 = 2*height+1 and this+0x1c = this+0xe00*2, which is consistent with the indexing here but was not verified against its bytes. Grid A row 2r+1 is overwritten by a copy of row 2r after each map row, and the byte-copy tail after rep movsd always runs with count (stride*4) and 3, which is 0, so it never copies. When several cells carry bit 4 the last one in row-major order wins. No Track N source corresponds.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_row, 0x4  # [ebp - 0x4]: map row index r
.equ local_col, 0x8  # [ebp - 0x8]: map column index c
.equ local_row_x2, 0xc  # [ebp - 0xc]: doubled row index 2r
.equ local_cell_flags, 0x10  # [ebp - 0x10]: flag byte of the current cell (low byte only)
.equ local_col_x2, 0x14  # [ebp - 0x14]: doubled column index 2c
.equ local_this, 0x18  # [ebp - 0x18]: this, spilled from ecx
.equ one_dword, 0x4  # constant displacement of one dword (4 bytes) added to a grid element address to reach the next column
.equ this_grid_stride, 0x1c  # this+0x1c: dword stride of the doubled grids, in dwords
.equ this_cell_map, 0xde4  # this+0xde4: pointer to the one-byte-per-cell flag map
.equ this_map_columns, 0xe00  # this+0xe00: dword number of map columns (row stride of the flag map in bytes)
.equ this_map_rows, 0xe04  # this+0xe04: dword number of map rows
.equ this_grid_a, 0xe38  # this+0xe38: pointer to dword grid A (written for cells with flag bit 1)
.equ this_grid_b, 0xe3c  # this+0xe3c: pointer to dword grid B (written for cells with flag bit 2)

# --- external targets -----------------------------------------------

.org 0x0049d55d - 0x401000
.globl FUN_0049d55d
FUN_0049d55d:
    # block 0x0049d55d: entry: save this and esi, edi, r = 0, 2r = 0, jump to the row loop test
    push ebp                                     # 0049d55d
    {load} mov ebp, esp                          # 0049d55e
    sub esp, 0x18                                # 0049d560
    push esi                                     # 0049d563
    push edi                                     # 0049d564
    mov dword ptr [ebp - local_this], ecx          # 0049d565
    mov dword ptr [ebp - local_row], 0x0           # 0049d568
    mov dword ptr [ebp - local_row_x2], 0x0           # 0049d56f
    jmp.d8 L_row_loop_head                            # 0049d576
L_next_row:
    # block 0x0049d578: row increment: r = r + 1, 2r = 2r + 2, then falls into the row loop test
    mov eax, dword ptr [ebp - local_row]           # 0049d578
    add eax, 0x1                                 # 0049d57b
    mov dword ptr [ebp - local_row], eax           # 0049d57e
    mov ecx, dword ptr [ebp - local_row_x2]           # 0049d581
    add ecx, 0x2                                 # 0049d584
    mov dword ptr [ebp - local_row_x2], ecx           # 0049d587
L_row_loop_head:
    # block 0x0049d58a: row loop test: if r >= this+0xe04 (signed jge) leave through L_done
    mov edx, dword ptr [ebp - local_this]          # 0049d58a
    mov eax, dword ptr [ebp - local_row]           # 0049d58d
    cmp eax, dword ptr [edx + this_map_rows]         # 0049d590
    jge.d32 L_done                           # 0049d596
    # block 0x0049d59c: start of a row: c = 0, 2c = 0, jump to the column loop test
    mov dword ptr [ebp - local_col], 0x0           # 0049d59c
    mov dword ptr [ebp - local_col_x2], 0x0          # 0049d5a3
    jmp.d8 L_col_loop_head                            # 0049d5aa
L_next_col:
    # block 0x0049d5ac: column increment: c = c + 1, 2c = 2c + 2, then falls into the column loop test
    mov ecx, dword ptr [ebp - local_col]           # 0049d5ac
    add ecx, 0x1                                 # 0049d5af
    mov dword ptr [ebp - local_col], ecx           # 0049d5b2
    mov edx, dword ptr [ebp - local_col_x2]          # 0049d5b5
    add edx, 0x2                                 # 0049d5b8
    mov dword ptr [ebp - local_col_x2], edx          # 0049d5bb
L_col_loop_head:
    # block 0x0049d5be: column loop test: if c >= this+0xe00 (signed jge) go to L_copy_row
    mov eax, dword ptr [ebp - local_this]          # 0049d5be
    mov ecx, dword ptr [ebp - local_col]           # 0049d5c1
    cmp ecx, dword ptr [eax + this_map_columns]         # 0049d5c4
    jge.d32 L_copy_row                           # 0049d5ca
    # block 0x0049d5d0: fetch the cell flag byte = byte at this+0xde4 + r*this+0xe00 + c into local_cell_flags, if (flags & 2) == 0 skip to L_test_bit4 (je)
    mov edx, dword ptr [ebp - local_this]          # 0049d5d0
    mov eax, dword ptr [ebp - local_row]           # 0049d5d3
    imul eax, dword ptr [edx + this_map_columns]        # 0049d5d6
    mov ecx, dword ptr [ebp - local_this]          # 0049d5dd
    mov edx, dword ptr [ecx + this_cell_map]         # 0049d5e0
    {load} add edx, eax                          # 0049d5e6
    mov eax, dword ptr [ebp - local_col]           # 0049d5e8
    mov cl, byte ptr [edx + eax]                 # 0049d5eb
    mov byte ptr [ebp - local_cell_flags], cl            # 0049d5ee
    mov edx, dword ptr [ebp - local_cell_flags]          # 0049d5f1
    and edx, 0xff                                # 0049d5f4
    and edx, 0x2                                 # 0049d5fa
    test edx, edx                                # 0049d5fd
    je.d32 L_test_bit4                            # 0049d5ff
    # block 0x0049d605: flag bit 2 set: store 1 into the four grid B dwords at (2r,2c), (2r,2c+1), (2r+1,2c), (2r+1,2c+1), element index = row*this+0x1c + col
    mov eax, dword ptr [ebp - local_this]          # 0049d605
    mov ecx, dword ptr [ebp - local_row_x2]           # 0049d608
    imul ecx, dword ptr [eax + this_grid_stride]         # 0049d60b
    mov edx, dword ptr [ebp - local_this]          # 0049d60f
    mov eax, dword ptr [edx + this_grid_b]         # 0049d612
    lea ecx, [eax + 4*ecx]                       # 0049d618
    mov edx, dword ptr [ebp - local_col_x2]          # 0049d61b
    mov dword ptr [ecx + 4*edx], 0x1             # 0049d61e
    mov eax, dword ptr [ebp - local_this]          # 0049d625
    mov ecx, dword ptr [ebp - local_row_x2]           # 0049d628
    imul ecx, dword ptr [eax + this_grid_stride]         # 0049d62b
    mov edx, dword ptr [ebp - local_this]          # 0049d62f
    mov eax, dword ptr [edx + this_grid_b]         # 0049d632
    lea ecx, [eax + 4*ecx]                       # 0049d638
    mov edx, dword ptr [ebp - local_col_x2]          # 0049d63b
    mov dword ptr [ecx + 4*edx + one_dword], 0x1   # 0049d63e
    mov eax, dword ptr [ebp - local_row_x2]           # 0049d646
    add eax, 0x1                                 # 0049d649
    mov ecx, dword ptr [ebp - local_this]          # 0049d64c
    imul eax, dword ptr [ecx + this_grid_stride]         # 0049d64f
    mov edx, dword ptr [ebp - local_this]          # 0049d653
    mov ecx, dword ptr [edx + this_grid_b]         # 0049d656
    lea edx, [ecx + 4*eax]                       # 0049d65c
    mov eax, dword ptr [ebp - local_col_x2]          # 0049d65f
    mov dword ptr [edx + 4*eax], 0x1             # 0049d662
    mov ecx, dword ptr [ebp - local_row_x2]           # 0049d669
    add ecx, 0x1                                 # 0049d66c
    mov edx, dword ptr [ebp - local_this]          # 0049d66f
    imul ecx, dword ptr [edx + this_grid_stride]         # 0049d672
    mov eax, dword ptr [ebp - local_this]          # 0049d676
    mov edx, dword ptr [eax + this_grid_b]         # 0049d679
    lea eax, [edx + 4*ecx]                       # 0049d67f
    mov ecx, dword ptr [ebp - local_col_x2]          # 0049d682
    mov dword ptr [eax + 4*ecx + one_dword], 0x1   # 0049d685
L_test_bit4:
    # block 0x0049d68d: if (flags & 4) == 0 skip to L_test_bit1 (je)
    mov edx, dword ptr [ebp - local_cell_flags]          # 0049d68d
    and edx, 0xff                                # 0049d690
    and edx, 0x4                                 # 0049d696
    test edx, edx                                # 0049d699
    je.d8 L_test_bit1                             # 0049d69b
    # block 0x0049d69d: flag bit 4 set: store 2r into global 0x6329c9 and 2c into global 0x6329cd
    mov eax, dword ptr [ebp - local_row_x2]           # 0049d69d
    mov dword ptr [0x6329c9], eax                # 0049d6a0
    mov ecx, dword ptr [ebp - local_col_x2]          # 0049d6a5
    mov dword ptr [0x6329cd], ecx                # 0049d6a8
L_test_bit1:
    # block 0x0049d6ae: if (flags & 1) == 0 skip to L_col_done (je)
    mov edx, dword ptr [ebp - local_cell_flags]          # 0049d6ae
    and edx, 0xff                                # 0049d6b1
    and edx, 0x1                                 # 0049d6b7
    test edx, edx                                # 0049d6ba
    je.d8 L_col_done                             # 0049d6bc
    # block 0x0049d6be: flag bit 1 set: store 1 into the two grid A dwords at (2r,2c) and (2r,2c+1)
    mov eax, dword ptr [ebp - local_this]          # 0049d6be
    mov ecx, dword ptr [ebp - local_row_x2]           # 0049d6c1
    imul ecx, dword ptr [eax + this_grid_stride]         # 0049d6c4
    mov edx, dword ptr [ebp - local_this]          # 0049d6c8
    mov eax, dword ptr [edx + this_grid_a]         # 0049d6cb
    lea ecx, [eax + 4*ecx]                       # 0049d6d1
    mov edx, dword ptr [ebp - local_col_x2]          # 0049d6d4
    mov dword ptr [ecx + 4*edx], 0x1             # 0049d6d7
    mov eax, dword ptr [ebp - local_this]          # 0049d6de
    mov ecx, dword ptr [ebp - local_row_x2]           # 0049d6e1
    imul ecx, dword ptr [eax + this_grid_stride]         # 0049d6e4
    mov edx, dword ptr [ebp - local_this]          # 0049d6e8
    mov eax, dword ptr [edx + this_grid_a]         # 0049d6eb
    lea ecx, [eax + 4*ecx]                       # 0049d6f1
    mov edx, dword ptr [ebp - local_col_x2]          # 0049d6f4
    mov dword ptr [ecx + 4*edx + one_dword], 0x1   # 0049d6f7
L_col_done:
    # block 0x0049d6ff: end of the column body: jump back to the column increment
    jmp.d32 L_next_col                           # 0049d6ff
L_copy_row:
    # block 0x0049d704: after the last column of the row: copy grid A row 2r (this+0x1c dwords, rep movsd, then a byte tail with count 0) onto grid A row 2r+1, then jump to the row increment
    mov eax, dword ptr [ebp - local_this]          # 0049d704
    mov ecx, dword ptr [eax + this_grid_stride]          # 0049d707
    shl ecx, 0x2                                 # 0049d70a
    mov edx, dword ptr [ebp - local_this]          # 0049d70d
    mov eax, dword ptr [ebp - local_row_x2]           # 0049d710
    imul eax, dword ptr [edx + this_grid_stride]         # 0049d713
    mov edx, dword ptr [ebp - local_this]          # 0049d717
    mov edx, dword ptr [edx + this_grid_a]         # 0049d71a
    lea esi, [edx + 4*eax]                       # 0049d720
    mov eax, dword ptr [ebp - local_row_x2]           # 0049d723
    add eax, 0x1                                 # 0049d726
    mov edx, dword ptr [ebp - local_this]          # 0049d729
    imul eax, dword ptr [edx + this_grid_stride]         # 0049d72c
    mov edx, dword ptr [ebp - local_this]          # 0049d730
    mov edx, dword ptr [edx + this_grid_a]         # 0049d733
    lea edi, [edx + 4*eax]                       # 0049d739
    {load} mov eax, ecx                          # 0049d73c
    shr ecx, 0x2                                 # 0049d73e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0049d741
    {load} mov ecx, eax                          # 0049d743
    and ecx, 0x3                                 # 0049d745
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0049d748
    jmp.d32 L_next_row                           # 0049d74a
L_done:
    # block 0x0049d74f: done: restore edi, esi and the frame and return
    pop edi                                      # 0049d74f
    pop esi                                      # 0049d750
    {load} mov esp, ebp                          # 0049d751
    pop ebp                                      # 0049d753
    ret                                          # 0049d754
