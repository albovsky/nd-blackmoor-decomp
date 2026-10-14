# FUN_004a10f1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a10f1
# extent:       0x004a10f1-0x004a1358 (615 code bytes)
# span:         0x004a10f1-0x004a1358 (code 615, tables 0, padding 0)
# sha256:       ab3faee814343bd8eb79d4e860eba94d974500229c729bf35a7e00741112ee41
# evidence:     ev_f9d88b0169a812ae2c4ead5dc0ce17ad9653751613cdfaa979f2506d84e4924b
# region:       game
# frame:        ebp
# name:         GridMap::copy_rows_to_global_buffers
# arguments:    thiscall: ecx=this (a grid object: this+0x1c = row width in elements, this+0x20 = row count); no stack arguments; plain ret; no result
# locals:       frame 8 bytes plus saved esi and edi: [ebp-0x4] = row index i (dword, signed, starts at 0); [ebp-0x8] = this, spilled from ecx
# fields:       this+0x1c: row width in elements (dword, read many times); this+0x20: row count (dword, loop bound, signed compare); this+0xe30, +0xe34, +0xe40, +0xe44, +0xe48: pointers to 16-bit element arrays; this+0xe38 and +0xe3c: pointers to 32-bit element arrays; globals (each a dword holding the base pointer of a destination buffer): 0x006329e1 (dwords, filled from this+0xe38), 0x006329e5 (words, from +0xe30), 0x006329e9 (words, from +0xe34), 0x006329ed (dwords, from +0xe3c), 0x006329f1 (words, from +0xe40), 0x006329f5 (words, from +0xe40 again), 0x006329f9 (words, from +0xe44), 0x006329fd (words, from +0xe44 again), 0x00632a01 (words, from +0xe48); destination row i starts 0xa6 * i elements after its buffer base
# callees:      none
# track-n:      host-adapter: none
# unverified:   The name GridMap::copy_rows_to_global_buffers and the field names are my labels from the access pattern; the only caller found (0x49cf4b, inside 0x49c889) was read from pseudocode, which also zeroes the same 0x6329e1.. buffers earlier and sets this+0x1c/+0x20 from a map size, so the grid reading of the object is a hint, not proven by these bytes. The destination row pitch 0xa6 elements is fixed in the code while the source row width is this+0x1c: nothing here checks that this+0x1c <= 0xa6 or that the destination buffers are large enough, so a wider grid overruns the destination row (unsafe original behaviour; native code must reject). Source arrays e40 and e44 are each copied twice into two different destination buffers. The byte tail of each rep movsb is 0 for the dword copies and 0 or 2 bytes for the word copies depending on this+0x1c parity; both are verified in the disassembly. Element meaning of the arrays is not established.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_row, 0x4  # [ebp - 0x4]: dword i, current row index
.equ local_this, 0x8  # [ebp - 0x8]: this, spilled from ecx

.equ grid_row_width, 0x1c  # this+0x1c: row width in elements (also the copy length per row)
.equ grid_row_count, 0x20  # this+0x20: number of rows (loop bound, signed compare)
.equ src_ptr_words_e30, 0xe30  # this+0xe30: pointer to a 16-bit element array, copied to the buffer at 0x6329e5
.equ src_ptr_words_e34, 0xe34  # this+0xe34: pointer to a 16-bit element array, copied to the buffer at 0x6329e9
.equ src_ptr_dwords_e38, 0xe38  # this+0xe38: pointer to a 32-bit element array, copied to the buffer at 0x6329e1
.equ src_ptr_dwords_e3c, 0xe3c  # this+0xe3c: pointer to a 32-bit element array, copied to the buffer at 0x6329ed
.equ src_ptr_words_e40, 0xe40  # this+0xe40: pointer to a 16-bit element array, copied to the buffers at 0x6329f1 and 0x6329f5
.equ src_ptr_words_e44, 0xe44  # this+0xe44: pointer to a 16-bit element array, copied to the buffers at 0x6329f9 and 0x6329fd
.equ src_ptr_words_e48, 0xe48  # this+0xe48: pointer to a 16-bit element array, copied to the buffer at 0x632a01

# --- external targets -----------------------------------------------

.org 0x004a10f1 - 0x401000
.globl FUN_004a10f1
FUN_004a10f1:
    # block 0x004a10f1: entry: spill this, row index i = 0, jump to the loop test
    push ebp                                     # 004a10f1
    {load} mov ebp, esp                          # 004a10f2
    sub esp, 0x8                                 # 004a10f4
    push esi                                     # 004a10f7
    push edi                                     # 004a10f8
    mov dword ptr [ebp - local_this], ecx           # 004a10f9
    mov dword ptr [ebp - local_row], 0x0           # 004a10fc
    jmp.d8 L_row_loop_test                            # 004a1103
L_next_row:
    # block 0x004a1105: row loop increment: i = i + 1
    mov eax, dword ptr [ebp - local_row]           # 004a1105
    add eax, 0x1                                 # 004a1108
    mov dword ptr [ebp - local_row], eax           # 004a110b
L_row_loop_test:
    # block 0x004a110e: row loop test: if i >= grid_row_count (signed compare) leave the loop
    mov ecx, dword ptr [ebp - local_this]           # 004a110e
    mov edx, dword ptr [ebp - local_row]           # 004a1111
    cmp edx, dword ptr [ecx + grid_row_count]          # 004a1114
    jge.d32 L_epilogue                           # 004a1117
    # block 0x004a111d: row body: nine row copies in this order, each from row i of a source array (i * grid_row_width elements) to row i of a destination buffer (i * 0xa6 elements): dwords e38 -> [0x6329e1], words e30 -> [0x6329e5], words e34 -> [0x6329e9], dwords e3c -> [0x6329ed], words e40 -> [0x6329f1], words e40 -> [0x6329f5], words e44 -> [0x6329f9], words e44 -> [0x6329fd], words e48 -> [0x632a01]; then back to the increment
    # copy 1 (32-bit elements): length = grid_row_width * 4 bytes; esi = e38 array + i*grid_row_width*4; edi = [0x6329e1] + i*0xa6*4; rep movsd of length/4 dwords then rep movsb of length%4 bytes (always 0)
    mov eax, dword ptr [ebp - local_this]           # 004a111d
    mov ecx, dword ptr [eax + grid_row_width]          # 004a1120
    shl ecx, 0x2                                 # 004a1123
    mov edx, dword ptr [ebp - local_this]           # 004a1126
    mov eax, dword ptr [ebp - local_row]           # 004a1129
    imul eax, dword ptr [edx + grid_row_width]         # 004a112c
    mov edx, dword ptr [ebp - local_this]           # 004a1130
    mov edx, dword ptr [edx + src_ptr_dwords_e38]         # 004a1133
    lea esi, [edx + 4*eax]                       # 004a1139
    mov eax, dword ptr [ebp - local_row]           # 004a113c
    imul eax, eax, 0xa6                          # 004a113f
    mov edx, dword ptr [0x6329e1]                # 004a1145
    lea edi, [edx + 4*eax]                       # 004a114b
    {load} mov eax, ecx                          # 004a114e
    shr ecx, 0x2                                 # 004a1150
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a1153
    {load} mov ecx, eax                          # 004a1155
    and ecx, 0x3                                 # 004a1157
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a115a
    # copy 2 (16-bit elements): length = grid_row_width * 2 bytes; esi = e30 array + i*grid_row_width*2; edi = [0x6329e5] + i*0xa6*2; rep movsd of length/4 then rep movsb of length%4 bytes
    mov ecx, dword ptr [ebp - local_this]           # 004a115c
    mov ecx, dword ptr [ecx + grid_row_width]          # 004a115f
    shl ecx                                      # 004a1162
    mov edx, dword ptr [ebp - local_this]           # 004a1164
    mov eax, dword ptr [ebp - local_row]           # 004a1167
    imul eax, dword ptr [edx + grid_row_width]         # 004a116a
    mov edx, dword ptr [ebp - local_this]           # 004a116e
    mov edx, dword ptr [edx + src_ptr_words_e30]         # 004a1171
    lea esi, [edx + 2*eax]                       # 004a1177
    mov eax, dword ptr [ebp - local_row]           # 004a117a
    imul eax, eax, 0xa6                          # 004a117d
    mov edx, dword ptr [0x6329e5]                # 004a1183
    lea edi, [edx + 2*eax]                       # 004a1189
    {load} mov eax, ecx                          # 004a118c
    shr ecx, 0x2                                 # 004a118e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a1191
    {load} mov ecx, eax                          # 004a1193
    and ecx, 0x3                                 # 004a1195
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a1198
    # copy 3 (16-bit): e34 array -> [0x6329e9], same arithmetic as copy 2
    mov ecx, dword ptr [ebp - local_this]           # 004a119a
    mov ecx, dword ptr [ecx + grid_row_width]          # 004a119d
    shl ecx                                      # 004a11a0
    mov edx, dword ptr [ebp - local_this]           # 004a11a2
    mov eax, dword ptr [ebp - local_row]           # 004a11a5
    imul eax, dword ptr [edx + grid_row_width]         # 004a11a8
    mov edx, dword ptr [ebp - local_this]           # 004a11ac
    mov edx, dword ptr [edx + src_ptr_words_e34]         # 004a11af
    lea esi, [edx + 2*eax]                       # 004a11b5
    mov eax, dword ptr [ebp - local_row]           # 004a11b8
    imul eax, eax, 0xa6                          # 004a11bb
    mov edx, dword ptr [0x6329e9]                # 004a11c1
    lea edi, [edx + 2*eax]                       # 004a11c7
    {load} mov eax, ecx                          # 004a11ca
    shr ecx, 0x2                                 # 004a11cc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a11cf
    {load} mov ecx, eax                          # 004a11d1
    and ecx, 0x3                                 # 004a11d3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a11d6
    # copy 4 (32-bit): e3c array -> [0x6329ed], same arithmetic as copy 1
    mov ecx, dword ptr [ebp - local_this]           # 004a11d8
    mov ecx, dword ptr [ecx + grid_row_width]          # 004a11db
    shl ecx, 0x2                                 # 004a11de
    mov edx, dword ptr [ebp - local_this]           # 004a11e1
    mov eax, dword ptr [ebp - local_row]           # 004a11e4
    imul eax, dword ptr [edx + grid_row_width]         # 004a11e7
    mov edx, dword ptr [ebp - local_this]           # 004a11eb
    mov edx, dword ptr [edx + src_ptr_dwords_e3c]         # 004a11ee
    lea esi, [edx + 4*eax]                       # 004a11f4
    mov eax, dword ptr [ebp - local_row]           # 004a11f7
    imul eax, eax, 0xa6                          # 004a11fa
    mov edx, dword ptr [0x6329ed]                # 004a1200
    lea edi, [edx + 4*eax]                       # 004a1206
    {load} mov eax, ecx                          # 004a1209
    shr ecx, 0x2                                 # 004a120b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a120e
    {load} mov ecx, eax                          # 004a1210
    and ecx, 0x3                                 # 004a1212
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a1215
    # copy 5 (16-bit): e40 array -> [0x6329f1]
    mov ecx, dword ptr [ebp - local_this]           # 004a1217
    mov ecx, dword ptr [ecx + grid_row_width]          # 004a121a
    shl ecx                                      # 004a121d
    mov edx, dword ptr [ebp - local_this]           # 004a121f
    mov eax, dword ptr [ebp - local_row]           # 004a1222
    imul eax, dword ptr [edx + grid_row_width]         # 004a1225
    mov edx, dword ptr [ebp - local_this]           # 004a1229
    mov edx, dword ptr [edx + src_ptr_words_e40]         # 004a122c
    lea esi, [edx + 2*eax]                       # 004a1232
    mov eax, dword ptr [ebp - local_row]           # 004a1235
    imul eax, eax, 0xa6                          # 004a1238
    mov edx, dword ptr [0x6329f1]                # 004a123e
    lea edi, [edx + 2*eax]                       # 004a1244
    {load} mov eax, ecx                          # 004a1247
    shr ecx, 0x2                                 # 004a1249
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a124c
    {load} mov ecx, eax                          # 004a124e
    and ecx, 0x3                                 # 004a1250
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a1253
    # copy 6 (16-bit): e40 array again -> [0x6329f5]
    mov ecx, dword ptr [ebp - local_this]           # 004a1255
    mov ecx, dword ptr [ecx + grid_row_width]          # 004a1258
    shl ecx                                      # 004a125b
    mov edx, dword ptr [ebp - local_this]           # 004a125d
    mov eax, dword ptr [ebp - local_row]           # 004a1260
    imul eax, dword ptr [edx + grid_row_width]         # 004a1263
    mov edx, dword ptr [ebp - local_this]           # 004a1267
    mov edx, dword ptr [edx + src_ptr_words_e40]         # 004a126a
    lea esi, [edx + 2*eax]                       # 004a1270
    mov eax, dword ptr [ebp - local_row]           # 004a1273
    imul eax, eax, 0xa6                          # 004a1276
    mov edx, dword ptr [0x6329f5]                # 004a127c
    lea edi, [edx + 2*eax]                       # 004a1282
    {load} mov eax, ecx                          # 004a1285
    shr ecx, 0x2                                 # 004a1287
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a128a
    {load} mov ecx, eax                          # 004a128c
    and ecx, 0x3                                 # 004a128e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a1291
    # copy 7 (16-bit): e44 array -> [0x6329f9]
    mov ecx, dword ptr [ebp - local_this]           # 004a1293
    mov ecx, dword ptr [ecx + grid_row_width]          # 004a1296
    shl ecx                                      # 004a1299
    mov edx, dword ptr [ebp - local_this]           # 004a129b
    mov eax, dword ptr [ebp - local_row]           # 004a129e
    imul eax, dword ptr [edx + grid_row_width]         # 004a12a1
    mov edx, dword ptr [ebp - local_this]           # 004a12a5
    mov edx, dword ptr [edx + src_ptr_words_e44]         # 004a12a8
    lea esi, [edx + 2*eax]                       # 004a12ae
    mov eax, dword ptr [ebp - local_row]           # 004a12b1
    imul eax, eax, 0xa6                          # 004a12b4
    mov edx, dword ptr [0x6329f9]                # 004a12ba
    lea edi, [edx + 2*eax]                       # 004a12c0
    {load} mov eax, ecx                          # 004a12c3
    shr ecx, 0x2                                 # 004a12c5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a12c8
    {load} mov ecx, eax                          # 004a12ca
    and ecx, 0x3                                 # 004a12cc
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a12cf
    # copy 8 (16-bit): e44 array again -> [0x6329fd]
    mov ecx, dword ptr [ebp - local_this]           # 004a12d1
    mov ecx, dword ptr [ecx + grid_row_width]          # 004a12d4
    shl ecx                                      # 004a12d7
    mov edx, dword ptr [ebp - local_this]           # 004a12d9
    mov eax, dword ptr [ebp - local_row]           # 004a12dc
    imul eax, dword ptr [edx + grid_row_width]         # 004a12df
    mov edx, dword ptr [ebp - local_this]           # 004a12e3
    mov edx, dword ptr [edx + src_ptr_words_e44]         # 004a12e6
    lea esi, [edx + 2*eax]                       # 004a12ec
    mov eax, dword ptr [ebp - local_row]           # 004a12ef
    imul eax, eax, 0xa6                          # 004a12f2
    mov edx, dword ptr [0x6329fd]                # 004a12f8
    lea edi, [edx + 2*eax]                       # 004a12fe
    {load} mov eax, ecx                          # 004a1301
    shr ecx, 0x2                                 # 004a1303
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a1306
    {load} mov ecx, eax                          # 004a1308
    and ecx, 0x3                                 # 004a130a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a130d
    # copy 9 (16-bit): e48 array -> [0x632a01]
    mov ecx, dword ptr [ebp - local_this]           # 004a130f
    mov ecx, dword ptr [ecx + grid_row_width]          # 004a1312
    shl ecx                                      # 004a1315
    mov edx, dword ptr [ebp - local_this]           # 004a1317
    mov eax, dword ptr [ebp - local_row]           # 004a131a
    imul eax, dword ptr [edx + grid_row_width]         # 004a131d
    mov edx, dword ptr [ebp - local_this]           # 004a1321
    mov edx, dword ptr [edx + src_ptr_words_e48]         # 004a1324
    lea esi, [edx + 2*eax]                       # 004a132a
    mov eax, dword ptr [ebp - local_row]           # 004a132d
    imul eax, eax, 0xa6                          # 004a1330
    mov edx, dword ptr [0x632a01]                # 004a1336
    lea edi, [edx + 2*eax]                       # 004a133c
    {load} mov eax, ecx                          # 004a133f
    shr ecx, 0x2                                 # 004a1341
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004a1344
    {load} mov ecx, eax                          # 004a1346
    and ecx, 0x3                                 # 004a1348
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004a134b
    jmp.d32 L_next_row                           # 004a134d
L_epilogue:
    # block 0x004a1352: loop done: restore edi, esi and the frame, plain ret
    pop edi                                      # 004a1352
    pop esi                                      # 004a1353
    {load} mov esp, ebp                          # 004a1354
    pop ebp                                      # 004a1356
    ret                                          # 004a1357
