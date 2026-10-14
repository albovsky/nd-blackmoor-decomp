# FUN_0049581a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049581a
# extent:       0x0049581a-0x004959ea (464 code bytes)
# span:         0x0049581a-0x004959ea (code 464, tables 0, padding 0)
# sha256:       fbb0c7675310e32f051c1734bf2a5310a9e6b5b093acc2b0e5dda06334de4a83
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# name:         CellGrid::restore_or_mask_cells_tagged_by_record
# arguments:    thiscall: ecx=this; one stack dword [ebp+8] = record index (used only as index*0x1c, not range-checked); callee pops 4 (ret 4); no return value (eax is left as scratch); esi is saved and restored
# locals:       this_ptr = this spilled from ecx; rec_ptr = this+0x45c1+index*0x1c; row_idx = outer counter 0..0xa5 (signed dword, multiplied by 0xa6 to address a row of words); col_idx = inner counter 0..0xa5; tile_a = word read from layer A; tag_a = its top nibble ((tile>>12)&0xf, in a word slot); tile_c = word read from layer C; tag_c = its top nibble
# fields:       this+0x1f57: dword pointer to layer A, a 0xa6*0xa6 array of words; this+0x1f5b: dword pointer to layer B (source of layer A restores); this+0x1f5f: dword pointer to layer C; this+0x1f63: dword pointer to layer D (source of layer C restores); this+0x45c1: base of an array of 0x1c-byte records; record+0x04: dword tag value compared with the tile's top nibble; record+0x0c: dword flag selecting mask (non-zero) or restore (zero); layer cells are read and written as words addressed (row*0xa6+col)*2; no absolute globals touched
# callees:      none
# track-n:      host-adapter: none
# unverified:   What the grid, the four layers and the 0x1c-byte records are in game terms is not established; the names layer A..D are labels for the pointers at +0x1f57, +0x1f5b, +0x1f5f and +0x1f63 and the pairing A with B and C with D comes only from the copy direction in the bytes. Which of row_idx/col_idx is a screen row or column is not proven (row_idx is the outer, multiplied index). The object offsets 0x1f57 and 0x45c1 are unaligned offsets (nothing further is concluded about the object layout); I did not check alignment of the four pointer reads. The grid size 0xa6 comes from the two cmp 0xa6 and the imul 0xa6 constants. The compare against record+4 is 32-bit (cmp eax, dword) with the tag zero-extended, so a tag above 0xf never matches. Mask case keeps only the top nibble (and 0xf000); restore case copies the whole word from the paired layer at the same cell. The class and method names are my labels, not recovered identifiers.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ tile_a, 0x4  # word: current cell of layer A (low word of the slot)
.equ tile_c, 0x8  # word: current cell of layer C (low word of the slot)
.equ row_idx, 0xc  # outer loop counter 0..0xa5 (dword)
.equ col_idx, 0x10  # inner loop counter 0..0xa5 (dword)
.equ rec_ptr, 0x14  # record pointer = this+0x45c1+arg_record_index*0x1c
.equ tag_c, 0x18  # word: top nibble of tile_c, (tile_c>>12)&0xf
.equ tag_a, 0x1c  # word: top nibble of tile_a, (tile_a>>12)&0xf
.equ this_ptr, 0x20  # this, spilled from ecx
.equ rec_tag, 0x4  # record +0x04 dword: tag value compared with the tile top nibble
.equ arg_record_index, 0x8  # stack argument: record index
.equ rec_mask_flag, 0xc  # record +0x0c dword: non-zero = mask the tile to its top nibble, zero = restore it from the paired layer
.equ this_layer_a, 0x1f57  # this+0x1f57: dword pointer to layer A (words)
.equ this_layer_b, 0x1f5b  # this+0x1f5b: dword pointer to layer B (restore source for A)
.equ this_layer_c, 0x1f5f  # this+0x1f5f: dword pointer to layer C (words)
.equ this_layer_d, 0x1f63  # this+0x1f63: dword pointer to layer D (restore source for C)
.equ this_records, 0x45c1  # this+0x45c1: base of the array of 0x1c-byte records

# --- external targets -----------------------------------------------

.org 0x0049581a - 0x401000
.globl FUN_0049581a
FUN_0049581a:
    # block 0x0049581a: entry: save esi, spill this, rec_ptr = this+0x45c1+index*0x1c, row_idx = 0, jump to the row test
    push ebp                                     # 0049581a
    {load} mov ebp, esp                          # 0049581b
    sub esp, 0x20                                # 0049581d
    push esi                                     # 00495820
    mov dword ptr [ebp - this_ptr], ecx          # 00495821
    mov eax, dword ptr [ebp + arg_record_index]             # 00495824
    imul eax, eax, 0x1c                          # 00495827
    mov ecx, dword ptr [ebp - this_ptr]          # 0049582a
    lea edx, [ecx + eax + this_records]            # 0049582d
    mov dword ptr [ebp - rec_ptr], edx          # 00495834
    mov dword ptr [ebp - row_idx], 0x0           # 00495837
    jmp.d8 row_test                            # 0049583e
row_next:
    # block 0x00495840: row_next: row_idx = row_idx + 1
    mov eax, dword ptr [ebp - row_idx]           # 00495840
    add eax, 0x1                                 # 00495843
    mov dword ptr [ebp - row_idx], eax           # 00495846
row_test:
    # block 0x00495849: row_test: if row_idx >= 0xa6 (signed) leave through return
    cmp dword ptr [ebp - row_idx], 0xa6          # 00495849
    jge.d32 return                           # 00495850
    # block 0x00495856: start of a row: col_idx = 0, jump to the column test
    mov dword ptr [ebp - col_idx], 0x0          # 00495856
    jmp.d8 col_test                            # 0049585d
col_next:
    # block 0x0049585f: col_next: col_idx = col_idx + 1
    mov ecx, dword ptr [ebp - col_idx]          # 0049585f
    add ecx, 0x1                                 # 00495862
    mov dword ptr [ebp - col_idx], ecx          # 00495865
col_test:
    # block 0x00495868: col_test: if col_idx >= 0xa6 (signed) go to col_loop_exit (next row)
    cmp dword ptr [ebp - col_idx], 0xa6         # 00495868
    jge.d32 col_loop_exit                           # 0049586f
    # block 0x00495875: layer A: tile_a = word at layer_a + (row_idx*0xa6 + col_idx)*2, tag_a = (tile_a >> 12) & 0xf; if tag_a != rec_tag (dword, record+4) skip to layer C
    mov edx, dword ptr [ebp - row_idx]           # 00495875
    imul edx, edx, 0xa6                          # 00495878
    mov eax, dword ptr [ebp - this_ptr]          # 0049587e
    mov ecx, dword ptr [eax + this_layer_a]        # 00495881
    lea edx, [ecx + 2*edx]                       # 00495887
    mov eax, dword ptr [ebp - col_idx]          # 0049588a
    mov cx, word ptr [edx + 2*eax]               # 0049588d
    mov word ptr [ebp - tile_a], cx             # 00495891
    mov edx, dword ptr [ebp - tile_a]           # 00495895
    and edx, 0xffff                              # 00495898
    sar edx, 0xc                                 # 0049589e
    and edx, 0xf                                 # 004958a1
    mov word ptr [ebp - tag_a], dx            # 004958a4
    mov eax, dword ptr [ebp - tag_a]          # 004958a8
    and eax, 0xffff                              # 004958ab
    mov ecx, dword ptr [ebp - rec_ptr]          # 004958b0
    cmp eax, dword ptr [ecx + rec_tag]           # 004958b3
    jne.d8 layer_c_start                            # 004958b6
    # block 0x004958b8: layer A tag matches: if record+0x0c is zero go to layer_a_restore
    mov edx, dword ptr [ebp - rec_ptr]          # 004958b8
    cmp dword ptr [edx + rec_mask_flag], 0x0           # 004958bb
    je.d8 layer_a_restore                             # 004958bf
    # block 0x004958c1: record flag non-zero: tile_a = tile_a & 0xf000 (keep only the tag nibble) and store it back to the same layer A cell, then continue with layer C
    mov ax, word ptr [ebp - tile_a]             # 004958c1
    .insn 0x66, 0x25, 0xf000{:u16}               # 004958c5
    mov word ptr [ebp - tile_a], ax             # 004958c9
    mov ecx, dword ptr [ebp - row_idx]           # 004958cd
    imul ecx, ecx, 0xa6                          # 004958d0
    mov edx, dword ptr [ebp - this_ptr]          # 004958d6
    mov eax, dword ptr [edx + this_layer_a]        # 004958d9
    lea ecx, [eax + 2*ecx]                       # 004958df
    mov edx, dword ptr [ebp - col_idx]          # 004958e2
    mov ax, word ptr [ebp - tile_a]             # 004958e5
    mov word ptr [ecx + 2*edx], ax               # 004958e9
    jmp.d8 layer_c_start                            # 004958ed
layer_a_restore:
    # block 0x004958ef: record flag zero: copy the word at the same cell of layer B into layer A
    mov ecx, dword ptr [ebp - row_idx]           # 004958ef
    imul ecx, ecx, 0xa6                          # 004958f2
    mov edx, dword ptr [ebp - this_ptr]          # 004958f8
    mov eax, dword ptr [edx + this_layer_b]        # 004958fb
    lea ecx, [eax + 2*ecx]                       # 00495901
    mov edx, dword ptr [ebp - row_idx]           # 00495904
    imul edx, edx, 0xa6                          # 00495907
    mov eax, dword ptr [ebp - this_ptr]          # 0049590d
    mov eax, dword ptr [eax + this_layer_a]        # 00495910
    lea edx, [eax + 2*edx]                       # 00495916
    mov eax, dword ptr [ebp - col_idx]          # 00495919
    mov esi, dword ptr [ebp - col_idx]          # 0049591c
    mov cx, word ptr [ecx + 2*esi]               # 0049591f
    mov word ptr [edx + 2*eax], cx               # 00495923
layer_c_start:
    # block 0x00495927: layer C: tile_c = word at layer_c + (row_idx*0xa6 + col_idx)*2, tag_c = (tile_c >> 12) & 0xf; if tag_c != rec_tag (dword, record+4) go to cell_done
    mov edx, dword ptr [ebp - row_idx]           # 00495927
    imul edx, edx, 0xa6                          # 0049592a
    mov eax, dword ptr [ebp - this_ptr]          # 00495930
    mov ecx, dword ptr [eax + this_layer_c]        # 00495933
    lea edx, [ecx + 2*edx]                       # 00495939
    mov eax, dword ptr [ebp - col_idx]          # 0049593c
    mov cx, word ptr [edx + 2*eax]               # 0049593f
    mov word ptr [ebp - tile_c], cx             # 00495943
    mov edx, dword ptr [ebp - tile_c]           # 00495947
    and edx, 0xffff                              # 0049594a
    sar edx, 0xc                                 # 00495950
    and edx, 0xf                                 # 00495953
    mov word ptr [ebp - tag_c], dx            # 00495956
    mov eax, dword ptr [ebp - tag_c]          # 0049595a
    and eax, 0xffff                              # 0049595d
    mov ecx, dword ptr [ebp - rec_ptr]          # 00495962
    cmp eax, dword ptr [ecx + rec_tag]           # 00495965
    jne.d8 cell_done                            # 00495968
    # block 0x0049596a: layer C tag matches: if record+0x0c is zero go to layer_c_restore
    mov edx, dword ptr [ebp - rec_ptr]          # 0049596a
    cmp dword ptr [edx + rec_mask_flag], 0x0           # 0049596d
    je.d8 layer_c_restore                             # 00495971
    # block 0x00495973: record flag non-zero: tile_c = tile_c & 0xf000 and store it back to the same layer C cell, then go to cell_done
    mov ax, word ptr [ebp - tile_c]             # 00495973
    .insn 0x66, 0x25, 0xf000{:u16}               # 00495977
    mov word ptr [ebp - tile_c], ax             # 0049597b
    mov ecx, dword ptr [ebp - row_idx]           # 0049597f
    imul ecx, ecx, 0xa6                          # 00495982
    mov edx, dword ptr [ebp - this_ptr]          # 00495988
    mov eax, dword ptr [edx + this_layer_c]        # 0049598b
    lea ecx, [eax + 2*ecx]                       # 00495991
    mov edx, dword ptr [ebp - col_idx]          # 00495994
    mov ax, word ptr [ebp - tile_c]             # 00495997
    mov word ptr [ecx + 2*edx], ax               # 0049599b
    jmp.d8 cell_done                            # 0049599f
layer_c_restore:
    # block 0x004959a1: record flag zero: copy the word at the same cell of layer D into layer C
    mov ecx, dword ptr [ebp - row_idx]           # 004959a1
    imul ecx, ecx, 0xa6                          # 004959a4
    mov edx, dword ptr [ebp - this_ptr]          # 004959aa
    mov eax, dword ptr [edx + this_layer_d]        # 004959ad
    lea ecx, [eax + 2*ecx]                       # 004959b3
    mov edx, dword ptr [ebp - row_idx]           # 004959b6
    imul edx, edx, 0xa6                          # 004959b9
    mov eax, dword ptr [ebp - this_ptr]          # 004959bf
    mov eax, dword ptr [eax + this_layer_c]        # 004959c2
    lea edx, [eax + 2*edx]                       # 004959c8
    mov eax, dword ptr [ebp - col_idx]          # 004959cb
    mov esi, dword ptr [ebp - col_idx]          # 004959ce
    mov cx, word ptr [ecx + 2*esi]               # 004959d1
    mov word ptr [edx + 2*eax], cx               # 004959d5
cell_done:
    # block 0x004959d9: cell_done: continue with the next column
    jmp.d32 col_next                           # 004959d9
col_loop_exit:
    # block 0x004959de: col_loop_exit: continue with the next row
    jmp.d32 row_next                           # 004959de
return:
    # block 0x004959e3: return: restore esi, frame, return popping the one stack argument (ret 4)
    pop esi                                      # 004959e3
    {load} mov esp, ebp                          # 004959e4
    pop ebp                                      # 004959e6
    ret 0x4                                      # 004959e7
