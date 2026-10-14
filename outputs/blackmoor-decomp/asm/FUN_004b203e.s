# FUN_004b203e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b203e
# extent:       0x004b203e-0x004b2238 (506 code bytes)
# span:         0x004b203e-0x004b2250 (code 506, tables 24, padding 0)
# sha256:       0587435a9434da253f5a166752a86d0b4d96fd8539e1f118729507a1f484ad34
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# name:         Board::compute_span_rect
# arguments:    thiscall: ecx=this (saved at [ebp-local_this]), three signed words and one pointer on the stack, callee pops 0x10 (ret 0x10), no defined return value: [ebp+8]=row index (word, sign-extended, multiplies this+0x152d and the payload gap word and is added to the y origin 0x58318a), [ebp+0xc]=column index (word, multiplies this+0x1529 and the gap word and is added to the x origin 0x583186), [ebp+0x10]=span mode (word, 1..6 handled, any other value leaves the right and bottom outputs unwritten), [ebp+0x14]=pointer to the output rectangle of four dwords (left, top, right, bottom)
# locals:       frame 0xc bytes: [ebp-4]=payload pointer of action slot this+0x1e (the dword at 0x5bb5e5 + word(this+0x1e)*0x8d, which is slot base 0x5bb5e3 + slot*0x8d + 2), [ebp-8]=this (spilled from ecx), [ebp-0xc]=switch index (span mode minus 1, spilled then compared unsigned against 5 and used to index SWTAB_004b2238)
# fields:       this+0x1e: signed word action slot index (times 0x8d into the table at 0x5bb5e5, whose entries are the payload pointers at slot+2, slot base 0x5bb5e3), this+0x1529: dword cell_width (x pitch), this+0x152d: dword cell_height (y pitch), payload+0x19e: dword x origin offset, payload+0x1a2: dword y origin offset, payload+0x1a6: signed word cell gap (all three are labels, layout per action type), out+0x0 left (written), out+0x4 top (written), out+0x8 right (written only for modes 1 to 6), out+0xc bottom (written only for modes 1 to 6), globals 0x005bb5e5 (slot base 0x5bb5e3 + 2: the payload pointer of each action slot, stride 0x8d), 0x00583186 (dword x origin of the view rectangle, first dword of the VIEW tuple copied by 0x435015 per media-recovery.md), 0x0058318a (dword y origin, second dword of that tuple)
# callees:      none (the indirect jump through SWTAB_004b2238 stays inside this function)
# track-n:      host-adapter: none
# unverified:   The name and every field and argument name are role labels from the arithmetic, not from any original symbol. Which game object is this and what the payload pointer behind the 0x5bb5e5 table holds (the pointer at slot+2 of action slot this+0x1e, slot base 0x5bb5e3, stride 0x8d, layout per action type) are not established here, so cell_width, cell_height, the origin offsets and the gap are interpretations of how the products and sums are used. The assignment of arg row to y and arg column to x follows from which pitch and which view origin each is combined with, not from a caller trace redone here (the only direct call site is 0x4b114b inside 0x4b10e3, which is itself called from 0x4b0ba8 and 0x4b10d1; no data references to 0x4b203e were found; none of these callers was traced here). The meaning of span modes 1 to 6 (modes 1 and 6 share one case through the table, mode 5 spans two cells in both directions, modes 3 and 4 span three) is read from the arithmetic only. Modes 0, negative or above 6 skip the table and leave right and bottom as the caller had them, and the original never checks that the action slot index in this+0x1e is inside the 0x5bb5e5 table or that the output pointer is valid, so Track N or the native port must reject a bad index explicitly. Right and bottom are left plus or top plus an extent, whether the original treats them as inclusive or exclusive edges is not proven by this routine. The dwords at this+0x1529 and this+0x152d sit at unaligned offsets (no further claim is made about the object layout). No Track N source corresponds.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_record, 0x4  # [ebp - 0x4]: payload pointer of action slot this+0x1e, loaded from the 0x5bb5e5 table
.equ local_this, 0x8  # [ebp - 0x8]: this, spilled from ecx
.equ local_mode_index, 0xc  # [ebp - 0xc]: span mode minus 1, the switch index
.equ rect_top, 0x4  # output rectangle+0x4: top (y), written from row index
.equ arg_row_index, 0x8  # [ebp + 0x8]: row index (signed word), scales the y pitch
.equ rect_right, 0x8  # output rectangle+0x8: right
.equ arg_col_index, 0xc  # [ebp + 0xc]: column index (signed word), scales the x pitch
.equ rect_bottom, 0xc  # output rectangle+0xc: bottom
.equ arg_span_mode, 0x10  # [ebp + 0x10]: span mode 1..6 (signed word)
.equ arg_out_rect, 0x14  # [ebp + 0x14]: pointer to the four-dword output rectangle
.equ this_slot_index, 0x1e  # this+0x1e: signed word action slot index into the 0x5bb5e5 payload pointer table
.equ rec_origin_x, 0x19e  # payload+0x19e: dword added to the x position (label)
.equ rec_origin_y, 0x1a2  # payload+0x1a2: dword added to the y position (label)
.equ rec_cell_gap, 0x1a6  # payload+0x1a6: signed word gap (label) per cell step and between spanned cells
.equ this_cell_width, 0x1529  # this+0x1529: dword cell width (x pitch)
.equ this_cell_height, 0x152d  # this+0x152d: dword cell height (y pitch)

# --- external targets -----------------------------------------------

.org 0x004b203e - 0x401000
.globl FUN_004b203e
FUN_004b203e:
    # block 0x004b203e: entry: save this, payload pointer = pointer at 0x5bb5e5 + word(this+0x1e)*0x8d, out.left = col*cell_width + payload.origin_x + view x 0x583186 + payload.gap*col, out.top = row*cell_height + record.origin_y + view y 0x58318a + payload.gap*row, then mode = word(arg+0x10) - 1 and unsigned compare against 5, above means skip to the epilogue (ja)
    push ebp                                     # 004b203e
    {load} mov ebp, esp                          # 004b203f
    sub esp, 0xc                                 # 004b2041
    mov dword ptr [ebp - local_this], ecx           # 004b2044
    mov eax, dword ptr [ebp - local_this]           # 004b2047
    movsx ecx, word ptr [eax + this_slot_index]         # 004b204a
    imul ecx, ecx, 0x8d                          # 004b204e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b2054
    mov dword ptr [ebp - local_record], edx           # 004b205a
    movsx eax, word ptr [ebp + arg_col_index]            # 004b205d
    mov ecx, dword ptr [ebp - local_this]           # 004b2061
    imul eax, dword ptr [ecx + this_cell_width]       # 004b2064
    mov edx, dword ptr [ebp - local_record]           # 004b206b
    mov ecx, dword ptr [edx + rec_origin_x]         # 004b206e
    {load} add ecx, eax                          # 004b2074
    mov edx, dword ptr [ebp - local_record]           # 004b2076
    movsx eax, word ptr [edx + rec_cell_gap]        # 004b2079
    movsx edx, word ptr [ebp + arg_col_index]            # 004b2080
    imul eax, edx                                # 004b2084
    mov edx, dword ptr [0x583186]                # 004b2087
    {load} add edx, ecx                          # 004b208d
    {load} add eax, edx                          # 004b208f
    mov ecx, dword ptr [ebp + arg_out_rect]            # 004b2091
    mov dword ptr [ecx], eax                     # 004b2094
    movsx edx, word ptr [ebp + arg_row_index]            # 004b2096
    mov eax, dword ptr [ebp - local_this]           # 004b209a
    imul edx, dword ptr [eax + this_cell_height]       # 004b209d
    mov ecx, dword ptr [ebp - local_record]           # 004b20a4
    mov eax, dword ptr [ecx + rec_origin_y]         # 004b20a7
    {load} add eax, edx                          # 004b20ad
    mov ecx, dword ptr [ebp - local_record]           # 004b20af
    movsx edx, word ptr [ecx + rec_cell_gap]        # 004b20b2
    movsx ecx, word ptr [ebp + arg_row_index]            # 004b20b9
    imul edx, ecx                                # 004b20bd
    mov ecx, dword ptr [0x58318a]                # 004b20c0
    {load} add ecx, eax                          # 004b20c6
    {load} add edx, ecx                          # 004b20c8
    mov eax, dword ptr [ebp + arg_out_rect]            # 004b20ca
    mov dword ptr [eax + rect_top], edx           # 004b20cd
    movsx ecx, word ptr [ebp + arg_span_mode]           # 004b20d0
    mov dword ptr [ebp - local_mode_index], ecx           # 004b20d4
    mov edx, dword ptr [ebp - local_mode_index]           # 004b20d7
    sub edx, 0x1                                 # 004b20da
    mov dword ptr [ebp - local_mode_index], edx           # 004b20dd
    cmp dword ptr [ebp - local_mode_index], 0x5           # 004b20e0
    ja.d32 L_epilogue                            # 004b20e4
    # block 0x004b20ea: mode - 1 is 0..5: indirect jump through SWTAB_004b2238 indexed by mode - 1
    mov eax, dword ptr [ebp - local_mode_index]           # 004b20ea
    jmp dword ptr [4*eax + SWTAB_004b2238_VA]    # 004b20ed
L_mode_1_and_6:
    # block 0x004b20f4: modes 1 and 6 (table entries 0 and 5): bottom = top + cell_height, right = left + 2*cell_width + gap, then leave
    mov ecx, dword ptr [ebp + arg_out_rect]            # 004b20f4
    mov edx, dword ptr [ecx + rect_top]           # 004b20f7
    mov eax, dword ptr [ebp - local_this]           # 004b20fa
    add edx, dword ptr [eax + this_cell_height]        # 004b20fd
    mov ecx, dword ptr [ebp + arg_out_rect]            # 004b2103
    mov dword ptr [ecx + rect_bottom], edx           # 004b2106
    mov edx, dword ptr [ebp - local_this]           # 004b2109
    mov eax, dword ptr [edx + this_cell_width]        # 004b210c
    mov ecx, dword ptr [ebp + arg_out_rect]            # 004b2112
    mov edx, dword ptr [ecx]                     # 004b2115
    lea eax, [edx + 2*eax]                       # 004b2117
    mov ecx, dword ptr [ebp - local_record]           # 004b211a
    movsx edx, word ptr [ecx + rec_cell_gap]        # 004b211d
    {load} add eax, edx                          # 004b2124
    mov ecx, dword ptr [ebp + arg_out_rect]            # 004b2126
    mov dword ptr [ecx + rect_right], eax           # 004b2129
    jmp.d32 L_epilogue                           # 004b212c
L_mode_2:
    # block 0x004b2131: mode 2: right = left + cell_width, bottom = top + 2*cell_height + gap, then leave
    mov edx, dword ptr [ebp + arg_out_rect]            # 004b2131
    mov eax, dword ptr [edx]                     # 004b2134
    mov ecx, dword ptr [ebp - local_this]           # 004b2136
    add eax, dword ptr [ecx + this_cell_width]        # 004b2139
    mov edx, dword ptr [ebp + arg_out_rect]            # 004b213f
    mov dword ptr [edx + rect_right], eax           # 004b2142
    mov eax, dword ptr [ebp - local_this]           # 004b2145
    mov ecx, dword ptr [eax + this_cell_height]        # 004b2148
    mov edx, dword ptr [ebp + arg_out_rect]            # 004b214e
    mov eax, dword ptr [edx + rect_top]           # 004b2151
    lea ecx, [eax + 2*ecx]                       # 004b2154
    mov edx, dword ptr [ebp - local_record]           # 004b2157
    movsx eax, word ptr [edx + rec_cell_gap]        # 004b215a
    {load} add ecx, eax                          # 004b2161
    mov edx, dword ptr [ebp + arg_out_rect]            # 004b2163
    mov dword ptr [edx + rect_bottom], ecx           # 004b2166
    jmp.d32 L_epilogue                           # 004b2169
L_mode_3:
    # block 0x004b216e: mode 3: bottom = top + cell_height, right = left + 3*cell_width + 2*gap, then leave
    mov eax, dword ptr [ebp + arg_out_rect]            # 004b216e
    mov ecx, dword ptr [eax + rect_top]           # 004b2171
    mov edx, dword ptr [ebp - local_this]           # 004b2174
    add ecx, dword ptr [edx + this_cell_height]        # 004b2177
    mov eax, dword ptr [ebp + arg_out_rect]            # 004b217d
    mov dword ptr [eax + rect_bottom], ecx           # 004b2180
    mov ecx, dword ptr [ebp - local_this]           # 004b2183
    mov edx, dword ptr [ecx + this_cell_width]        # 004b2186
    imul edx, edx, 0x3                           # 004b218c
    mov eax, dword ptr [ebp + arg_out_rect]            # 004b218f
    mov ecx, dword ptr [eax]                     # 004b2192
    {load} add ecx, edx                          # 004b2194
    mov edx, dword ptr [ebp - local_record]           # 004b2196
    movsx eax, word ptr [edx + rec_cell_gap]        # 004b2199
    lea ecx, [ecx + 2*eax]                       # 004b21a0
    mov edx, dword ptr [ebp + arg_out_rect]            # 004b21a3
    mov dword ptr [edx + rect_right], ecx           # 004b21a6
    jmp.d32 L_epilogue                           # 004b21a9
L_mode_4:
    # block 0x004b21ae: mode 4: right = left + cell_width, bottom = top + 3*cell_height + 2*gap, then leave
    mov eax, dword ptr [ebp + arg_out_rect]            # 004b21ae
    mov ecx, dword ptr [eax]                     # 004b21b1
    mov edx, dword ptr [ebp - local_this]           # 004b21b3
    add ecx, dword ptr [edx + this_cell_width]        # 004b21b6
    mov eax, dword ptr [ebp + arg_out_rect]            # 004b21bc
    mov dword ptr [eax + rect_right], ecx           # 004b21bf
    mov ecx, dword ptr [ebp - local_this]           # 004b21c2
    mov edx, dword ptr [ecx + this_cell_height]        # 004b21c5
    imul edx, edx, 0x3                           # 004b21cb
    mov eax, dword ptr [ebp + arg_out_rect]            # 004b21ce
    mov ecx, dword ptr [eax + rect_top]           # 004b21d1
    {load} add ecx, edx                          # 004b21d4
    mov edx, dword ptr [ebp - local_record]           # 004b21d6
    movsx eax, word ptr [edx + rec_cell_gap]        # 004b21d9
    lea ecx, [ecx + 2*eax]                       # 004b21e0
    mov edx, dword ptr [ebp + arg_out_rect]            # 004b21e3
    mov dword ptr [edx + rect_bottom], ecx           # 004b21e6
    jmp.d8 L_epilogue                            # 004b21e9
L_mode_5:
    # block 0x004b21eb: mode 5: right = left + 2*cell_width + gap, bottom = top + 2*cell_height + gap, falls into the epilogue
    mov eax, dword ptr [ebp - local_this]           # 004b21eb
    mov ecx, dword ptr [eax + this_cell_width]        # 004b21ee
    mov edx, dword ptr [ebp + arg_out_rect]            # 004b21f4
    mov eax, dword ptr [edx]                     # 004b21f7
    lea ecx, [eax + 2*ecx]                       # 004b21f9
    mov edx, dword ptr [ebp - local_record]           # 004b21fc
    movsx eax, word ptr [edx + rec_cell_gap]        # 004b21ff
    {load} add ecx, eax                          # 004b2206
    mov edx, dword ptr [ebp + arg_out_rect]            # 004b2208
    mov dword ptr [edx + rect_right], ecx           # 004b220b
    mov eax, dword ptr [ebp - local_this]           # 004b220e
    mov ecx, dword ptr [eax + this_cell_height]        # 004b2211
    mov edx, dword ptr [ebp + arg_out_rect]            # 004b2217
    mov eax, dword ptr [edx + rect_top]           # 004b221a
    lea ecx, [eax + 2*ecx]                       # 004b221d
    mov edx, dword ptr [ebp - local_record]           # 004b2220
    movsx eax, word ptr [edx + rec_cell_gap]        # 004b2223
    {load} add ecx, eax                          # 004b222a
    mov edx, dword ptr [ebp + arg_out_rect]            # 004b222c
    mov dword ptr [edx + rect_bottom], ecx           # 004b222f
L_epilogue:
    # block 0x004b2232: epilogue shared by every path: restore the frame and return, popping the 0x10 bytes of arguments
    {load} mov esp, ebp                          # 004b2232
    pop ebp                                      # 004b2234
    ret 0x10                                     # 004b2235

# --- data items (not part of the function) -------------------------
.org 0x004b2238 - 0x401000
SWTAB_004b2238:  # 6 case address(es)
    .long L_mode_1_and_6 - .text + 0x401000
    .long L_mode_2 - .text + 0x401000
    .long L_mode_3 - .text + 0x401000
    .long L_mode_4 - .text + 0x401000
    .long L_mode_5 - .text + 0x401000
    .long L_mode_1_and_6 - .text + 0x401000
.set SWTAB_004b2238_VA, SWTAB_004b2238 - .text + 0x401000
