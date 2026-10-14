# FUN_004460d6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004460d6
# extent:       0x004460d6-0x004462d3 (509 code bytes)
# span:         0x004460d6-0x004462d3 (code 509, tables 0, padding 0)
# sha256:       cc71ba678570f339a179e918bf0eb72728be11c478e340ebb2eff5baa18cbf3a
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# name:         CUIScoreDisplay::LoadConfigAndRegisterLayer
# arguments:    thiscall: ecx=this, one stack argument popped by the callee (ret 4): [ebp+8] = pointer to a 0x2e-dword (184 byte) configuration block, copied to this+0xbc by rep movsd. Preserves esi and edi (pushed and popped), no return value. The bytes clobber eax, ecx and edx
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot). esi and edi are saved registers, used as copy pointers
# fields:       this+0x04: dword, set to 0 at the end. this+0x0c: dword, set to 1 at the end. this+0x14 + i*4 (i = 0 to 9): ten dwords, each rect_right - rect_left + 1 of rectangle i. this+0x3c + i*4: ten dwords, each rect_bottom - rect_top + 1 of rectangle i. this+0xbc..0x173: the copied 0x2e-dword block, of which ten 16-byte rectangles at this+0xbc + i*0x10 (left +0xbc, top +0xc0, right +0xc4, bottom +0xc8 by the arithmetic), then this+0x168: dword copied into layer record +8, this+0x16c: dword layer index (records have stride 0x4a), this+0x170: dword copied into layer record +0. this+0x23c: dword cleared. this+0x25c: byte cleared. this+0x27a: byte cleared. this+0x284: dword loop counter, ends at 10. Layer record at 0x5d1591 + this[0x16c]*0x4a: +0x00 = this+0x170, +0x04 = 0x446688 (immediate, a code address stored as data, not called), +0x08 = this+0x168, +0x0c = 0, +0x10 = 0, +0x14 = 1, +0x18 = 1, +0x1c word = 0, +0x22 string (copy of the 14 bytes at 0x548218, the 13 characters SCORE DISPLAY and the terminating zero). Global read: 0x548218
# callees:      none
# track-n:      host-adapter: none
# unverified:   No Track N source covers this routine. Class and role names are my labels: the string copied into the layer record reads SCORE DISPLAY (with a space, Ghidra shows an underscore) and three callers (0x4b8e92, 0x4bca71, 0x452576, from the pseudocode hints) pass an embedded sub-object and a config block, but that this is a score-display object, and that the ten rectangles are digit or glyph images, is not proven by these bytes. The layer-record field meanings come from displacement arithmetic only: that 0x5d1591 + layer*0x4a is a render layer record with surface at +8, source index at +0xc and enable flag at +0x14 is inferred from the cursor layer globals named in src/caption_lifecycle.h (0x5d162d, 0x5d1631, 0x5d1639 are layer 2 at +8, +0xc and +0x14, and 0x5d17f5 is layer 8 at +0x14), while +0, +4, +0x10, +0x18 and +0x1c have no verified meaning. What code at 0x446688 is (the callback) is not recovered here. The rectangle edge order (left, top, right, bottom) follows the subtraction operands. The one config block layout beyond the ten rectangles (this+0x168, +0x16c, +0x170) is not decoded. The string length is computed at run time by repne scasb over 0x548218, and no check guards the layer index range, which the bytes do not bound.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # this pointer spilled from ecx
.equ sd_flag_04, 0x4  # this+0x04: dword, set to 0 at the end
.equ arg_config, 0x8  # stack argument: pointer to the 0x2e-dword configuration block copied to this+0xbc
.equ sd_flag_0c, 0xc  # this+0x0c: dword, set to 1 at the end
.equ sd_rect_width, 0x14  # this+0x14: base of ten width dwords, entry i = right - left + 1
.equ sd_rect_height, 0x3c  # this+0x3c: base of ten height dwords, entry i = bottom - top + 1
.equ sd_rect_left, 0xbc  # this+0xbc: base of ten 16-byte rectangles, left of entry i is at +i*0x10
.equ sd_rect_top, 0xc0  # this+0xc0: top of rectangle i
.equ sd_rect_right, 0xc4  # this+0xc4: right of rectangle i
.equ sd_rect_bottom, 0xc8  # this+0xc8: bottom of rectangle i
.equ sd_layer_surface, 0x168  # this+0x168: dword, copied into layer record +8
.equ sd_layer_index, 0x16c  # this+0x16c: dword, index of the layer record (stride 0x4a)
.equ sd_layer_dword_170, 0x170  # this+0x170: dword, copied into layer record +0
.equ sd_cleared_dword, 0x23c  # this+0x23c: dword, cleared to 0
.equ sd_cleared_byte_25c, 0x25c  # this+0x25c: byte, cleared to 0
.equ sd_cleared_byte_27a, 0x27a  # this+0x27a: byte, cleared to 0
.equ sd_loop_index, 0x284  # this+0x284: dword loop counter over the ten rectangles

# --- external targets -----------------------------------------------

.org 0x004460d6 - 0x401000
.globl FUN_004460d6
FUN_004460d6:
    # block 0x004460d6: entry: save esi and edi, spill this, copy 0x2e dwords from the argument block to this+0xbc (rep movsd), then this+0x284 = 0 and go to rect_loop_test
    push ebp                                     # 004460d6
    {load} mov ebp, esp                          # 004460d7
    push ecx                                     # 004460d9
    push esi                                     # 004460da
    push edi                                     # 004460db
    mov dword ptr [ebp - local_this], ecx           # 004460dc
    mov edi, dword ptr [ebp - local_this]           # 004460df
    add edi, 0xbc                                # 004460e2
    mov ecx, 0x2e                                # 004460e8
    mov esi, dword ptr [ebp + arg_config]             # 004460ed
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004460f0
    mov eax, dword ptr [ebp - local_this]           # 004460f2
    mov dword ptr [eax + sd_loop_index], 0x0         # 004460f5
    jmp.d8 rect_loop_test                            # 004460ff
rect_loop_next:
    # block 0x00446101: rect_loop_next: this+0x284 += 1
    mov ecx, dword ptr [ebp - local_this]           # 00446101
    mov edx, dword ptr [ecx + sd_loop_index]         # 00446104
    add edx, 0x1                                 # 0044610a
    mov eax, dword ptr [ebp - local_this]           # 0044610d
    mov dword ptr [eax + sd_loop_index], edx         # 00446110
rect_loop_test:
    # block 0x00446116: rect_loop_test: if this+0x284 >= 10 (signed) leave the loop for register_layer (jge)
    mov ecx, dword ptr [ebp - local_this]           # 00446116
    cmp dword ptr [ecx + sd_loop_index], 0xa         # 00446119
    jge.d32 register_layer                           # 00446120
    # block 0x00446126: loop body for entry i = this+0x284: this+0x14[i] = rect_right - rect_left + 1 (width), this+0x3c[i] = rect_bottom - rect_top + 1 (height), where entry i sits at this+0xbc + i*0x10, then back to rect_loop_next
    mov edx, dword ptr [ebp - local_this]           # 00446126
    mov eax, dword ptr [edx + sd_loop_index]         # 00446129
    shl eax, 0x4                                 # 0044612f
    mov ecx, dword ptr [ebp - local_this]           # 00446132
    mov edx, dword ptr [ecx + sd_loop_index]         # 00446135
    shl edx, 0x4                                 # 0044613b
    mov ecx, dword ptr [ebp - local_this]           # 0044613e
    mov esi, dword ptr [ebp - local_this]           # 00446141
    mov eax, dword ptr [ecx + eax + sd_rect_right]    # 00446144
    sub eax, dword ptr [esi + edx + sd_rect_left]    # 0044614b
    add eax, 0x1                                 # 00446152
    mov ecx, dword ptr [ebp - local_this]           # 00446155
    mov edx, dword ptr [ecx + sd_loop_index]         # 00446158
    mov ecx, dword ptr [ebp - local_this]           # 0044615e
    mov dword ptr [ecx + 4*edx + sd_rect_width], eax  # 00446161
    mov edx, dword ptr [ebp - local_this]           # 00446165
    mov eax, dword ptr [edx + sd_loop_index]         # 00446168
    shl eax, 0x4                                 # 0044616e
    mov ecx, dword ptr [ebp - local_this]           # 00446171
    mov edx, dword ptr [ecx + sd_loop_index]         # 00446174
    shl edx, 0x4                                 # 0044617a
    mov ecx, dword ptr [ebp - local_this]           # 0044617d
    mov esi, dword ptr [ebp - local_this]           # 00446180
    mov eax, dword ptr [ecx + eax + sd_rect_bottom]    # 00446183
    sub eax, dword ptr [esi + edx + sd_rect_top]    # 0044618a
    add eax, 0x1                                 # 00446191
    mov ecx, dword ptr [ebp - local_this]           # 00446194
    mov edx, dword ptr [ecx + sd_loop_index]         # 00446197
    mov ecx, dword ptr [ebp - local_this]           # 0044619d
    mov dword ptr [ecx + 4*edx + sd_rect_height], eax  # 004461a0
    jmp.d32 rect_loop_next                           # 004461a4
register_layer:
    # block 0x004461a9: register_layer: fill the record at 0x5d1591 + this[0x16c]*0x4a: +0 = this+0x170, +4 = 0x446688, +8 = this+0x168, +0xc = 0, +0x10 = 0, +0x14 = 1, +0x18 = 1, word +0x1c = 0, then strlen (repne scasb) of the string at 0x548218 and copy it with its terminator (rep movsd then rep movsb) to record +0x22, then clear this+0x23c, byte this+0x25c, byte this+0x27a, set this+0x04 = 0 and this+0x0c = 1, restore edi and esi and return with ret 4
    mov edx, dword ptr [ebp - local_this]           # 004461a9
    mov eax, dword ptr [edx + sd_layer_index]         # 004461ac
    imul eax, eax, 0x4a                          # 004461b2
    mov ecx, dword ptr [ebp - local_this]           # 004461b5
    mov edx, dword ptr [ecx + sd_layer_dword_170]         # 004461b8
    mov dword ptr [eax + 0x5d1591], edx          # 004461be
    mov eax, dword ptr [ebp - local_this]           # 004461c4
    mov ecx, dword ptr [eax + sd_layer_index]         # 004461c7
    imul ecx, ecx, 0x4a                          # 004461cd
    mov dword ptr [ecx + 0x5d1595], 0x446688     # 004461d0
    mov edx, dword ptr [ebp - local_this]           # 004461da
    mov eax, dword ptr [edx + sd_layer_index]         # 004461dd
    imul eax, eax, 0x4a                          # 004461e3
    mov ecx, dword ptr [ebp - local_this]           # 004461e6
    mov edx, dword ptr [ecx + sd_layer_surface]         # 004461e9
    mov dword ptr [eax + 0x5d1599], edx          # 004461ef
    mov eax, dword ptr [ebp - local_this]           # 004461f5
    mov ecx, dword ptr [eax + sd_layer_index]         # 004461f8
    imul ecx, ecx, 0x4a                          # 004461fe
    mov dword ptr [ecx + 0x5d159d], 0x0          # 00446201
    mov edx, dword ptr [ebp - local_this]           # 0044620b
    mov eax, dword ptr [edx + sd_layer_index]         # 0044620e
    imul eax, eax, 0x4a                          # 00446214
    mov dword ptr [eax + 0x5d15a1], 0x0          # 00446217
    mov ecx, dword ptr [ebp - local_this]           # 00446221
    mov edx, dword ptr [ecx + sd_layer_index]         # 00446224
    imul edx, edx, 0x4a                          # 0044622a
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0044622d
    mov eax, dword ptr [ebp - local_this]           # 00446237
    mov ecx, dword ptr [eax + sd_layer_index]         # 0044623a
    imul ecx, ecx, 0x4a                          # 00446240
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 00446243
    mov edx, dword ptr [ebp - local_this]           # 0044624d
    mov eax, dword ptr [edx + sd_layer_index]         # 00446250
    imul eax, eax, 0x4a                          # 00446256
    mov word ptr [eax + 0x5d15ad], 0x0           # 00446259
    mov edi, 0x548218                            # 00446262
    mov ecx, dword ptr [ebp - local_this]           # 00446267
    mov edx, dword ptr [ecx + sd_layer_index]         # 0044626a
    imul edx, edx, 0x4a                          # 00446270
    add edx, 0x5d15b3                            # 00446273
    or ecx, -0x1                                 # 00446279
    {load} xor eax, eax                          # 0044627c
    repne scasb al, byte ptr es:[edi]            # 0044627e
    not ecx                                      # 00446280
    {load} sub edi, ecx                          # 00446282
    {load} mov esi, edi                          # 00446284
    {load} mov eax, ecx                          # 00446286
    {load} mov edi, edx                          # 00446288
    shr ecx, 0x2                                 # 0044628a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044628d
    {load} mov ecx, eax                          # 0044628f
    and ecx, 0x3                                 # 00446291
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00446294
    mov ecx, dword ptr [ebp - local_this]           # 00446296
    mov dword ptr [ecx + sd_cleared_dword], 0x0         # 00446299
    mov edx, dword ptr [ebp - local_this]           # 004462a3
    mov byte ptr [edx + sd_cleared_byte_25c], 0x0          # 004462a6
    mov eax, dword ptr [ebp - local_this]           # 004462ad
    mov byte ptr [eax + sd_cleared_byte_27a], 0x0          # 004462b0
    mov ecx, dword ptr [ebp - local_this]           # 004462b7
    mov dword ptr [ecx + sd_flag_04], 0x0           # 004462ba
    mov edx, dword ptr [ebp - local_this]           # 004462c1
    mov dword ptr [edx + sd_flag_0c], 0x1           # 004462c4
    pop edi                                      # 004462cb
    pop esi                                      # 004462cc
    {load} mov esp, ebp                          # 004462cd
    pop ebp                                      # 004462cf
    ret 0x4                                      # 004462d0
