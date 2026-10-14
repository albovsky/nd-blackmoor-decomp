# FUN_00478396
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00478396
# extent:       0x00478396-0x00478646 (688 code bytes)
# span:         0x00478396-0x00478656 (code 688, tables 16, padding 0)
# sha256:       ea1b3b7f06b616cc2c3ac36434963621d3966dac8b06545a450bd9e071251f38
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# name:         TileGrid::step_allowed
# arguments:    thiscall: ecx=this (spilled to local_this; reads int16 this+0x1e); [ebp+8]=arg_direction int16 (1..4, other values fall through with result 1); [ebp+0xc]=arg_col int16 column of the cell; [ebp+0x10]=arg_row int16 row of the cell; callee pops 0xc (ret 0xc); returns eax=1 when the step in that direction is allowed, eax=0 when a grid edge or a wall code blocks it
# locals:       frame 0x10 bytes: local_result [ebp-4] = result dword, initialised to 1 and set to 0 when blocked; local_record [ebp-8] = dword loaded from [0x5bb5e5 + int16(this+0x1e) * 0x8d] (pointer to the active grid record); local_this [ebp-0xc] = this spilled from ecx; local_case [ebp-0x10] = arg_direction - 1, the switch index
# fields:       this+0x1e: int16 index into the record table at 0x5bb5e5 (stride 0x8d); record+0x21: int16, the column limit (direction 2 is blocked when arg_col == value-1); record+0x23: int16, the row limit (direction 3 is blocked when arg_row == value-1); record+0x2c: base of the cell grid, int16 cells at record+0x2c + row*0x10 + col*2 (row stride 16 bytes = 8 cells); global table 0x005bb5e5 (stride 0x8d); switch table SWTAB_00478646 (4 case addresses) at 0x478646
# callees:      none
# track-n:      host-adapter: none
# unverified:   No Track N source covers this routine; TileGrid::step_allowed and the field names are my labels. Directions: by the bytes the four cases test rows and columns as follows. Direction 1 is blocked when arg_row == 0, or the cell at (col,row) has code 6 or 2, or the cell at (col,row-1) has code 6 or 4. Direction 2 is blocked when arg_col == record+0x21 minus 1, or the cell has code 5 or 3, or the cell at (col+1,row) has code 5 or 1. Direction 3 is blocked when arg_row == record+0x23 minus 1, or the cell has code 6 or 4, or the cell at (col,row+1) has code 6 or 2. Direction 4 is blocked when arg_col == 0, or the cell has code 5 or 1, or the cell at (col-1,row) has code 5 or 3. That the codes 1..6 are wall-side flags (1 left, 2 top, 3 right, 4 bottom, 5 left and right, 6 top and bottom) and that the directions are up, right, down and left on screen is my inference from which code blocks which move and from the caller 0x478684 (pseudocode only: it calls direction 1 with y-1, 3 with y+1 and 4 with x-1 around position words at this+0x158e), not a game fact proven here; the callers 0x478743..0x478899 and 0x479eed were not traced beyond that pseudocode. The field at record+0x21 is used as a column count and record+0x23 as a row count only because of the compares above. Unsafe original behaviour: no bounds check of arg_col against the 8-cell row width or of arg_row against the grid, no check of the record-table index or of the record pointer; a native port must reject out-of-range column, row and index explicitly. The range test of arg_direction (1 to 4) and the second range test through local_case and the ja are redundant in the bytes; an unlisted direction returns 1 untouched. The switch jump at 0x4783f3 reads SWTAB_00478646 whose four entries are listed as data items for M02.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ cell_prev_delta, 0x2  # cell address - 2 (written as a minus): the previous column cell in the same row
.equ local_result, 0x4  # [ebp - 0x4]: result dword, 1 = step allowed, set to 0 when blocked
.equ local_record, 0x8  # [ebp - 0x8]: pointer to the active grid record from [0x5bb5e5 + this_record_index*0x8d]
.equ local_this, 0xc  # [ebp - 0xc]: this, spilled from ecx
.equ local_case, 0x10  # [ebp - 0x10]: arg_direction - 1, the switch index
.equ cell_next_delta, 0x2  # cell address + 2: the next column cell in the same row
.equ arg_direction, 0x8  # [ebp + 0x8]: int16 direction code 1..4
.equ arg_col, 0xc  # [ebp + 0xc]: int16 column of the cell (scaled by 2 into the row)
.equ arg_row, 0x10  # [ebp + 0x10]: int16 row of the cell (scaled by 16)
.equ this_record_index, 0x1e  # this+0x1e: int16 index into the record table at 0x5bb5e5 (stride 0x8d)
.equ rec_col_limit, 0x21  # record+0x21: int16 compared with arg_col + 1 (direction 2 blocked when arg_col == value - 1)
.equ rec_row_limit, 0x23  # record+0x23: int16 compared with arg_row + 1 (direction 3 blocked when arg_row == value - 1)
.equ rec_cell_grid, 0x2c  # record+0x2c: base of the int16 cell grid (row stride 0x10, cell stride 2)

# --- external targets -----------------------------------------------

.org 0x00478396 - 0x401000
.globl FUN_00478396
FUN_00478396:
    # block 0x00478396: entry: spill this, local_record = dword [0x5bb5e5 + int16 this_record_index * 0x8d], local_result = 1; if signed int16 arg_direction < 1 go to L_return (jl)
    push ebp                                     # 00478396
    {load} mov ebp, esp                          # 00478397
    sub esp, 0x10                                # 00478399
    mov dword ptr [ebp - local_this], ecx           # 0047839c
    mov eax, dword ptr [ebp - local_this]           # 0047839f
    movsx ecx, word ptr [eax + this_record_index]         # 004783a2
    imul ecx, ecx, 0x8d                          # 004783a6
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004783ac
    mov dword ptr [ebp - local_record], edx           # 004783b2
    mov dword ptr [ebp - local_result], 0x1           # 004783b5
    movsx eax, word ptr [ebp + arg_direction]            # 004783bc
    cmp eax, 0x1                                 # 004783c0
    jl.d32 L_return                            # 004783c3
    # block 0x004783c9: range check: if signed int16 arg_direction > 4 go to L_return (jg)
    movsx ecx, word ptr [ebp + arg_direction]            # 004783c9
    cmp ecx, 0x4                                 # 004783cd
    jg.d32 L_return                            # 004783d0
    # block 0x004783d6: local_case = arg_direction - 1 (stored and reloaded through memory)
    movsx edx, word ptr [ebp + arg_direction]            # 004783d6
    mov dword ptr [ebp - local_case], edx          # 004783da
    mov eax, dword ptr [ebp - local_case]          # 004783dd
    sub eax, 0x1                                 # 004783e0
    mov dword ptr [ebp - local_case], eax          # 004783e3
    cmp dword ptr [ebp - local_case], 0x3          # 004783e6
    ja.d32 L_return                            # 004783ea
    # block 0x004783f0: if local_case > 3 unsigned go to L_return (ja, redundant after the range check)
    mov ecx, dword ptr [ebp - local_case]          # 004783f0
    jmp dword ptr [4*ecx + SWTAB_00478646_VA]    # 004783f3
L_dir1:
    # block 0x004783fa: direction 1 (switch index 0, L_dir1): if int16 arg_row is not zero go to L_dir1_cells (jne)
    movsx edx, word ptr [ebp + arg_row]           # 004783fa
    test edx, edx                                # 004783fe
    jne.d8 L_dir1_cells                            # 00478400
    # block 0x00478402: direction 1 at the grid edge: arg_row == 0, local_result = 0, go to L_dir1_done
    mov dword ptr [ebp - local_result], 0x0           # 00478402
    jmp.d8 L_dir1_done                            # 00478409
L_dir1_cells:
    # block 0x0047840b: direction 1 cell tests: if the cell at (arg_col, arg_row) has code 6 go to L_dir1_blocked (je)
    movsx eax, word ptr [ebp + arg_row]           # 0047840b
    shl eax, 0x4                                 # 0047840f
    mov ecx, dword ptr [ebp - local_record]           # 00478412
    lea edx, [ecx + eax + rec_cell_grid]              # 00478415
    movsx eax, word ptr [ebp + arg_col]            # 00478419
    movsx ecx, word ptr [edx + 2*eax]            # 0047841d
    cmp ecx, 0x6                                 # 00478421
    je.d8 L_dir1_blocked                             # 00478424
    # block 0x00478426: direction 1: if the cell at (arg_col, arg_row) has code 2 go to L_dir1_blocked (je)
    movsx edx, word ptr [ebp + arg_row]           # 00478426
    shl edx, 0x4                                 # 0047842a
    mov eax, dword ptr [ebp - local_record]           # 0047842d
    lea ecx, [eax + edx + rec_cell_grid]              # 00478430
    movsx edx, word ptr [ebp + arg_col]            # 00478434
    movsx eax, word ptr [ecx + 2*edx]            # 00478438
    cmp eax, 0x2                                 # 0047843c
    je.d8 L_dir1_blocked                             # 0047843f
    # block 0x00478441: direction 1: if the cell at (arg_col, arg_row - 1) has code 6 go to L_dir1_blocked (je)
    movsx ecx, word ptr [ebp + arg_row]           # 00478441
    sub ecx, 0x1                                 # 00478445
    shl ecx, 0x4                                 # 00478448
    mov edx, dword ptr [ebp - local_record]           # 0047844b
    lea eax, [edx + ecx + rec_cell_grid]              # 0047844e
    movsx ecx, word ptr [ebp + arg_col]            # 00478452
    movsx edx, word ptr [eax + 2*ecx]            # 00478456
    cmp edx, 0x6                                 # 0047845a
    je.d8 L_dir1_blocked                             # 0047845d
    # block 0x0047845f: direction 1: if the cell at (arg_col, arg_row - 1) has code 4 go to L_dir1_blocked, otherwise fall to L_dir1_done (jne)
    movsx eax, word ptr [ebp + arg_row]           # 0047845f
    sub eax, 0x1                                 # 00478463
    shl eax, 0x4                                 # 00478466
    mov ecx, dword ptr [ebp - local_record]           # 00478469
    lea edx, [ecx + eax + rec_cell_grid]              # 0047846c
    movsx eax, word ptr [ebp + arg_col]            # 00478470
    movsx ecx, word ptr [edx + 2*eax]            # 00478474
    cmp ecx, 0x4                                 # 00478478
    jne.d8 L_dir1_done                            # 0047847b
L_dir1_blocked:
    # block 0x0047847d: direction 1 blocked (L_dir1_blocked): local_result = 0
    mov dword ptr [ebp - local_result], 0x0           # 0047847d
L_dir1_done:
    # block 0x00478484: direction 1 done (L_dir1_done): go to L_return
    jmp.d32 L_return                           # 00478484
L_dir3:
    # block 0x00478489: direction 3 (switch index 2, L_dir3): compare int16 arg_row with int16 rec_row_limit - 1; if they differ go to L_dir3_cells (jne)
    movsx edx, word ptr [ebp + arg_row]           # 00478489
    mov eax, dword ptr [ebp - local_record]           # 0047848d
    movsx ecx, word ptr [eax + rec_row_limit]         # 00478490
    sub ecx, 0x1                                 # 00478494
    {load} cmp edx, ecx                          # 00478497
    jne.d8 L_dir3_cells                            # 00478499
    # block 0x0047849b: direction 3 at the grid edge: local_result = 0, go to L_dir3_done
    mov dword ptr [ebp - local_result], 0x0           # 0047849b
    jmp.d8 L_dir3_done                            # 004784a2
L_dir3_cells:
    # block 0x004784a4: direction 3 cell tests (L_dir3_cells): if the cell at (arg_col, arg_row) has code 6 go to L_dir3_blocked (je)
    movsx edx, word ptr [ebp + arg_row]           # 004784a4
    shl edx, 0x4                                 # 004784a8
    mov eax, dword ptr [ebp - local_record]           # 004784ab
    lea ecx, [eax + edx + rec_cell_grid]              # 004784ae
    movsx edx, word ptr [ebp + arg_col]            # 004784b2
    movsx eax, word ptr [ecx + 2*edx]            # 004784b6
    cmp eax, 0x6                                 # 004784ba
    je.d8 L_dir3_blocked                             # 004784bd
    # block 0x004784bf: direction 3: if the cell at (arg_col, arg_row) has code 4 go to L_dir3_blocked (je)
    movsx ecx, word ptr [ebp + arg_row]           # 004784bf
    shl ecx, 0x4                                 # 004784c3
    mov edx, dword ptr [ebp - local_record]           # 004784c6
    lea eax, [edx + ecx + rec_cell_grid]              # 004784c9
    movsx ecx, word ptr [ebp + arg_col]            # 004784cd
    movsx edx, word ptr [eax + 2*ecx]            # 004784d1
    cmp edx, 0x4                                 # 004784d5
    je.d8 L_dir3_blocked                             # 004784d8
    # block 0x004784da: direction 3: if the cell at (arg_col, arg_row + 1) has code 6 go to L_dir3_blocked (je)
    movsx eax, word ptr [ebp + arg_row]           # 004784da
    add eax, 0x1                                 # 004784de
    shl eax, 0x4                                 # 004784e1
    mov ecx, dword ptr [ebp - local_record]           # 004784e4
    lea edx, [ecx + eax + rec_cell_grid]              # 004784e7
    movsx eax, word ptr [ebp + arg_col]            # 004784eb
    movsx ecx, word ptr [edx + 2*eax]            # 004784ef
    cmp ecx, 0x6                                 # 004784f3
    je.d8 L_dir3_blocked                             # 004784f6
    # block 0x004784f8: direction 3: if the cell at (arg_col, arg_row + 1) has code 2 it falls into L_dir3_blocked, otherwise go to L_dir3_done (jne)
    movsx edx, word ptr [ebp + arg_row]           # 004784f8
    add edx, 0x1                                 # 004784fc
    shl edx, 0x4                                 # 004784ff
    mov eax, dword ptr [ebp - local_record]           # 00478502
    lea ecx, [eax + edx + rec_cell_grid]              # 00478505
    movsx edx, word ptr [ebp + arg_col]            # 00478509
    movsx eax, word ptr [ecx + 2*edx]            # 0047850d
    cmp eax, 0x2                                 # 00478511
    jne.d8 L_dir3_done                            # 00478514
L_dir3_blocked:
    # block 0x00478516: direction 3 blocked (L_dir3_blocked): local_result = 0
    mov dword ptr [ebp - local_result], 0x0           # 00478516
L_dir3_done:
    # block 0x0047851d: direction 3 done (L_dir3_done): go to L_return
    jmp.d32 L_return                           # 0047851d
L_dir2:
    # block 0x00478522: direction 2 (switch index 1, L_dir2): compare int16 arg_col with int16 rec_col_limit - 1; if they differ go to L_dir2_cells (jne)
    movsx ecx, word ptr [ebp + arg_col]            # 00478522
    mov edx, dword ptr [ebp - local_record]           # 00478526
    movsx eax, word ptr [edx + rec_col_limit]         # 00478529
    sub eax, 0x1                                 # 0047852d
    {load} cmp ecx, eax                          # 00478530
    jne.d8 L_dir2_cells                            # 00478532
    # block 0x00478534: direction 2 at the grid edge: local_result = 0, go to L_dir2_done
    mov dword ptr [ebp - local_result], 0x0           # 00478534
    jmp.d8 L_dir2_done                            # 0047853b
L_dir2_cells:
    # block 0x0047853d: direction 2 cell tests (L_dir2_cells): if the cell at (arg_col, arg_row) has code 5 go to L_dir2_blocked (je)
    movsx ecx, word ptr [ebp + arg_row]           # 0047853d
    shl ecx, 0x4                                 # 00478541
    mov edx, dword ptr [ebp - local_record]           # 00478544
    lea eax, [edx + ecx + rec_cell_grid]              # 00478547
    movsx ecx, word ptr [ebp + arg_col]            # 0047854b
    movsx edx, word ptr [eax + 2*ecx]            # 0047854f
    cmp edx, 0x5                                 # 00478553
    je.d8 L_dir2_blocked                             # 00478556
    # block 0x00478558: direction 2: if the cell at (arg_col, arg_row) has code 3 go to L_dir2_blocked (je)
    movsx eax, word ptr [ebp + arg_row]           # 00478558
    shl eax, 0x4                                 # 0047855c
    mov ecx, dword ptr [ebp - local_record]           # 0047855f
    lea edx, [ecx + eax + rec_cell_grid]              # 00478562
    movsx eax, word ptr [ebp + arg_col]            # 00478566
    movsx ecx, word ptr [edx + 2*eax]            # 0047856a
    cmp ecx, 0x3                                 # 0047856e
    je.d8 L_dir2_blocked                             # 00478571
    # block 0x00478573: direction 2: if the cell at (arg_col + 1, arg_row) (cell_next_delta) has code 5 go to L_dir2_blocked (je)
    movsx edx, word ptr [ebp + arg_row]           # 00478573
    shl edx, 0x4                                 # 00478577
    mov eax, dword ptr [ebp - local_record]           # 0047857a
    lea ecx, [eax + edx + rec_cell_grid]              # 0047857d
    movsx edx, word ptr [ebp + arg_col]            # 00478581
    movsx eax, word ptr [ecx + 2*edx + cell_next_delta]  # 00478585
    cmp eax, 0x5                                 # 0047858a
    je.d8 L_dir2_blocked                             # 0047858d
    # block 0x0047858f: direction 2: if the cell at (arg_col + 1, arg_row) has code 1 it falls into L_dir2_blocked, otherwise go to L_dir2_done (jne)
    movsx ecx, word ptr [ebp + arg_row]           # 0047858f
    shl ecx, 0x4                                 # 00478593
    mov edx, dword ptr [ebp - local_record]           # 00478596
    lea eax, [edx + ecx + rec_cell_grid]              # 00478599
    movsx ecx, word ptr [ebp + arg_col]            # 0047859d
    movsx edx, word ptr [eax + 2*ecx + cell_next_delta]  # 004785a1
    cmp edx, 0x1                                 # 004785a6
    jne.d8 L_dir2_done                            # 004785a9
L_dir2_blocked:
    # block 0x004785ab: direction 2 blocked (L_dir2_blocked): local_result = 0
    mov dword ptr [ebp - local_result], 0x0           # 004785ab
L_dir2_done:
    # block 0x004785b2: direction 2 done (L_dir2_done): go to L_return
    jmp.d32 L_return                           # 004785b2
L_dir4:
    # block 0x004785b7: direction 4 (switch index 3, L_dir4): if int16 arg_col is not zero go to L_dir4_cells (jne)
    movsx eax, word ptr [ebp + arg_col]            # 004785b7
    test eax, eax                                # 004785bb
    jne.d8 L_dir4_cells                            # 004785bd
    # block 0x004785bf: direction 4 at the grid edge: arg_col == 0, local_result = 0, go to L_return
    mov dword ptr [ebp - local_result], 0x0           # 004785bf
    jmp.d8 L_return                            # 004785c6
L_dir4_cells:
    # block 0x004785c8: direction 4 cell tests (L_dir4_cells): if the cell at (arg_col, arg_row) has code 5 go to L_dir4_blocked (je)
    movsx ecx, word ptr [ebp + arg_row]           # 004785c8
    shl ecx, 0x4                                 # 004785cc
    mov edx, dword ptr [ebp - local_record]           # 004785cf
    lea eax, [edx + ecx + rec_cell_grid]              # 004785d2
    movsx ecx, word ptr [ebp + arg_col]            # 004785d6
    movsx edx, word ptr [eax + 2*ecx]            # 004785da
    cmp edx, 0x5                                 # 004785de
    je.d8 L_dir4_blocked                             # 004785e1
    # block 0x004785e3: direction 4: if the cell at (arg_col, arg_row) has code 1 go to L_dir4_blocked (je)
    movsx eax, word ptr [ebp + arg_row]           # 004785e3
    shl eax, 0x4                                 # 004785e7
    mov ecx, dword ptr [ebp - local_record]           # 004785ea
    lea edx, [ecx + eax + rec_cell_grid]              # 004785ed
    movsx eax, word ptr [ebp + arg_col]            # 004785f1
    movsx ecx, word ptr [edx + 2*eax]            # 004785f5
    cmp ecx, 0x1                                 # 004785f9
    je.d8 L_dir4_blocked                             # 004785fc
    # block 0x004785fe: direction 4: if the cell at (arg_col - 1, arg_row) (cell_prev_delta) has code 5 go to L_dir4_blocked (je)
    movsx edx, word ptr [ebp + arg_row]           # 004785fe
    shl edx, 0x4                                 # 00478602
    mov eax, dword ptr [ebp - local_record]           # 00478605
    lea ecx, [eax + edx + rec_cell_grid]              # 00478608
    movsx edx, word ptr [ebp + arg_col]            # 0047860c
    movsx eax, word ptr [ecx + 2*edx - cell_prev_delta] # 00478610
    cmp eax, 0x5                                 # 00478615
    je.d8 L_dir4_blocked                             # 00478618
    # block 0x0047861a: direction 4: if the cell at (arg_col - 1, arg_row) has code 3 it falls into L_dir4_blocked, otherwise go to L_return (jne)
    movsx ecx, word ptr [ebp + arg_row]           # 0047861a
    shl ecx, 0x4                                 # 0047861e
    mov edx, dword ptr [ebp - local_record]           # 00478621
    lea eax, [edx + ecx + rec_cell_grid]              # 00478624
    movsx ecx, word ptr [ebp + arg_col]            # 00478628
    movsx edx, word ptr [eax + 2*ecx - cell_prev_delta] # 0047862c
    cmp edx, 0x3                                 # 00478631
    jne.d8 L_return                            # 00478634
L_dir4_blocked:
    # block 0x00478636: direction 4 blocked (L_dir4_blocked): local_result = 0
    mov dword ptr [ebp - local_result], 0x0           # 00478636
L_return:
    # block 0x0047863d: epilogue (L_return): eax = local_result, restore the frame and return, callee pops three arguments (ret 0xc)
    mov eax, dword ptr [ebp - local_result]           # 0047863d
    {load} mov esp, ebp                          # 00478640
    pop ebp                                      # 00478642
    ret 0xc                                      # 00478643

# --- data items (not part of the function) -------------------------
.org 0x00478646 - 0x401000
SWTAB_00478646:  # 4 case address(es)
    .long L_dir1 - .text + 0x401000
    .long L_dir2 - .text + 0x401000
    .long L_dir3 - .text + 0x401000
    .long L_dir4 - .text + 0x401000
.set SWTAB_00478646_VA, SWTAB_00478646 - .text + 0x401000
