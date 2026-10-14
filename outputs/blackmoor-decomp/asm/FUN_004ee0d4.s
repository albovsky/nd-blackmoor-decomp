# FUN_004ee0d4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee0d4
# extent:       0x004ee0d4-0x004ee2a9 (469 code bytes)
# span:         0x004ee0d4-0x004ee2a9 (code 469, tables 0, padding 0)
# sha256:       dc325cfed86c33f37dfe482b7ae9123e6b167b3937d4db7738b553cb5c822622
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# name:         CursorOwner::clamp_point_to_region
# arguments:    thiscall: ecx=this (saved at [ebp-local_this]), one stack argument, callee pops 4 (ret 4), no defined return value: [ebp+8]=pointer to two int32 values (x at +0, y at +4) that are clamped in place
# locals:       frame 8 bytes: [ebp-4]=this (spilled from ecx), [ebp-8]=region mode (the dword at this+0x4af)
# fields:       this+0x4af: dword region mode (2 or 3 handled, any other value leaves the point unchanged), mode 2 region: this+0x1c (left), this+0x20 (top), this+0x24 (right), this+0x28 (bottom), mode 3 region: this+0x665 (left), this+0x669 (top), this+0x66d (right), this+0x671 (bottom), all dwords, point+0x0 (x) and point+0x4 (y) read and written, globals 0x005b44f0 (cursor_type, read), 0x005b44f4 (cursor_variant, read), 0x005b3790 (table of 4-byte entries at 0x5b3790 + 8*cursor_type + 4*cursor_variant, signed word at +0 subtracted from the right limit and signed word at +2 (address 0x5b3792 based) subtracted from the bottom limit). The global names are the labels in src/caption_lifecycle.h
# callees:      none
# track-n:      host-adapter: none
# unverified:   The name, the region field names and the extent table role are labels from the arithmetic, not original symbols. Observed behaviour only: for mode 2 or 3 each coordinate is first raised to the region minimum (signed jge test, so x < left sets x = left), then if the coordinate is at or above (maximum - extent) it is set to maximum - extent, the extent being the signed word at 0x5b3790 (x) or 0x5b3792 (y) in the entry selected by cursor_type*8 + cursor_variant*4. The maximum clamp runs last, so it wins when maximum - extent is below the minimum. That the extents are the cursor image size or hot spot, and what regions 2 and 3 are in the game, are not established. The original does not bounds check cursor_type or cursor_variant against the table at 0x5b3790 or validate the point pointer, so the native port must reject bad values explicitly. Callers are visible only as pseudocode (0x4e4114 forwards its argument here, 0x4e779f, 0x4e89d2 and 0x4ebd6c also reference this address). No Track N function corresponds.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]: this, spilled from ecx
.equ local_mode, 0x8  # [ebp - 0x8]: region mode copied from this+0x4af
.equ point_y, 0x4  # point+0x4: int32 y coordinate of the point being clamped
.equ arg_point_ptr, 0x8  # [ebp + 0x8]: pointer to the two-int32 point (x, y) clamped in place
.equ this_region2_left, 0x1c  # this+0x1c: dword left limit of the mode 2 region
.equ this_region2_top, 0x20  # this+0x20: dword top limit of the mode 2 region
.equ this_region2_right, 0x24  # this+0x24: dword right limit of the mode 2 region
.equ this_region2_bottom, 0x28  # this+0x28: dword bottom limit of the mode 2 region
.equ this_region_mode, 0x4af  # this+0x4af: dword region mode (2 or 3)
.equ this_region3_left, 0x665  # this+0x665: dword left limit of the mode 3 region
.equ this_region3_top, 0x669  # this+0x669: dword top limit of the mode 3 region
.equ this_region3_right, 0x66d  # this+0x66d: dword right limit of the mode 3 region
.equ this_region3_bottom, 0x671  # this+0x671: dword bottom limit of the mode 3 region

# --- external targets -----------------------------------------------

.org 0x004ee0d4 - 0x401000
.globl FUN_004ee0d4
FUN_004ee0d4:
    # block 0x004ee0d4: entry: save this, load the region mode from this+0x4af into local_mode, if it is 2 jump to L_mode2_x_min (je)
    push ebp                                     # 004ee0d4
    {load} mov ebp, esp                          # 004ee0d5
    sub esp, 0x8                                 # 004ee0d7
    mov dword ptr [ebp - local_this], ecx           # 004ee0da
    mov eax, dword ptr [ebp - local_this]           # 004ee0dd
    mov ecx, dword ptr [eax + this_region_mode]         # 004ee0e0
    mov dword ptr [ebp - local_mode], ecx           # 004ee0e6
    cmp dword ptr [ebp - local_mode], 0x2           # 004ee0e9
    je.d8 L_mode2_x_min                             # 004ee0ed
    # block 0x004ee0ef: mode is not 2: if it is 3 jump to L_mode3_x_min (je)
    cmp dword ptr [ebp - local_mode], 0x3           # 004ee0ef
    je.d32 L_mode3_x_min                            # 004ee0f3
    # block 0x004ee0f9: mode is neither 2 nor 3: leave the point unchanged, jump to the epilogue
    jmp.d32 L_epilogue                           # 004ee0f9
L_mode2_x_min:
    # block 0x004ee0fe: mode 2, x minimum: if point.x >= this+0x1c (signed jge) skip to L_mode2_x_max
    mov edx, dword ptr [ebp + arg_point_ptr]             # 004ee0fe
    mov eax, dword ptr [ebp - local_this]           # 004ee101
    mov ecx, dword ptr [edx]                     # 004ee104
    cmp ecx, dword ptr [eax + this_region2_left]          # 004ee106
    jge.d8 L_mode2_x_max                            # 004ee109
    # block 0x004ee10b: point.x < left: point.x = this+0x1c
    mov edx, dword ptr [ebp + arg_point_ptr]             # 004ee10b
    mov eax, dword ptr [ebp - local_this]           # 004ee10e
    mov ecx, dword ptr [eax + this_region2_left]          # 004ee111
    mov dword ptr [edx], ecx                     # 004ee114
L_mode2_x_max:
    # block 0x004ee116: mode 2, x maximum: limit = this+0x24 - signed word at [0x5b3790 + 8*cursor_type + 4*cursor_variant], if point.x < limit (signed jl) skip to L_mode2_y_min
    mov edx, dword ptr [0x5b44f4]                # 004ee116
    shl edx, 0x2                                 # 004ee11c
    mov eax, dword ptr [0x5b44f0]                # 004ee11f
    movsx ecx, word ptr [edx + 8*eax + 0x5b3790] # 004ee124
    mov edx, dword ptr [ebp - local_this]           # 004ee12c
    mov eax, dword ptr [edx + this_region2_right]          # 004ee12f
    {load} sub eax, ecx                          # 004ee132
    mov ecx, dword ptr [ebp + arg_point_ptr]             # 004ee134
    cmp dword ptr [ecx], eax                     # 004ee137
    jl.d8 L_mode2_y_min                             # 004ee139
    # block 0x004ee13b: point.x >= limit: point.x = this+0x24 - the same extent word
    mov edx, dword ptr [0x5b44f4]                # 004ee13b
    shl edx, 0x2                                 # 004ee141
    mov eax, dword ptr [0x5b44f0]                # 004ee144
    movsx ecx, word ptr [edx + 8*eax + 0x5b3790] # 004ee149
    mov edx, dword ptr [ebp - local_this]           # 004ee151
    mov eax, dword ptr [edx + this_region2_right]          # 004ee154
    {load} sub eax, ecx                          # 004ee157
    mov ecx, dword ptr [ebp + arg_point_ptr]             # 004ee159
    mov dword ptr [ecx], eax                     # 004ee15c
L_mode2_y_min:
    # block 0x004ee15e: mode 2, y minimum: if point.y >= this+0x20 (signed jge) skip to L_mode2_y_max
    mov edx, dword ptr [ebp + arg_point_ptr]             # 004ee15e
    mov eax, dword ptr [ebp - local_this]           # 004ee161
    mov ecx, dword ptr [edx + point_y]           # 004ee164
    cmp ecx, dword ptr [eax + this_region2_top]          # 004ee167
    jge.d8 L_mode2_y_max                            # 004ee16a
    # block 0x004ee16c: point.y < top: point.y = this+0x20
    mov edx, dword ptr [ebp + arg_point_ptr]             # 004ee16c
    mov eax, dword ptr [ebp - local_this]           # 004ee16f
    mov ecx, dword ptr [eax + this_region2_top]          # 004ee172
    mov dword ptr [edx + point_y], ecx           # 004ee175
L_mode2_y_max:
    # block 0x004ee178: mode 2, y maximum: limit = this+0x28 - signed word at [0x5b3792 + 8*cursor_type + 4*cursor_variant], if point.y < limit (signed jl) skip to L_mode2_exit
    mov edx, dword ptr [0x5b44f4]                # 004ee178
    shl edx, 0x2                                 # 004ee17e
    mov eax, dword ptr [0x5b44f0]                # 004ee181
    movsx ecx, word ptr [edx + 8*eax + 0x5b3792] # 004ee186
    mov edx, dword ptr [ebp - local_this]           # 004ee18e
    mov eax, dword ptr [edx + this_region2_bottom]          # 004ee191
    {load} sub eax, ecx                          # 004ee194
    mov ecx, dword ptr [ebp + arg_point_ptr]             # 004ee196
    cmp dword ptr [ecx + point_y], eax           # 004ee199
    jl.d8 L_mode2_exit                             # 004ee19c
    # block 0x004ee19e: point.y >= limit: point.y = this+0x28 - the same extent word
    mov edx, dword ptr [0x5b44f4]                # 004ee19e
    shl edx, 0x2                                 # 004ee1a4
    mov eax, dword ptr [0x5b44f0]                # 004ee1a7
    movsx ecx, word ptr [edx + 8*eax + 0x5b3792] # 004ee1ac
    mov edx, dword ptr [ebp - local_this]           # 004ee1b4
    mov eax, dword ptr [edx + this_region2_bottom]          # 004ee1b7
    {load} sub eax, ecx                          # 004ee1ba
    mov ecx, dword ptr [ebp + arg_point_ptr]             # 004ee1bc
    mov dword ptr [ecx + point_y], eax           # 004ee1bf
L_mode2_exit:
    # block 0x004ee1c2: mode 2 finished: jump to the epilogue
    jmp.d32 L_epilogue                           # 004ee1c2
L_mode3_x_min:
    # block 0x004ee1c7: mode 3, x minimum: if point.x >= this+0x665 (signed jge) skip to L_mode3_x_max
    mov edx, dword ptr [ebp + arg_point_ptr]             # 004ee1c7
    mov eax, dword ptr [ebp - local_this]           # 004ee1ca
    mov ecx, dword ptr [edx]                     # 004ee1cd
    cmp ecx, dword ptr [eax + this_region3_left]         # 004ee1cf
    jge.d8 L_mode3_x_max                            # 004ee1d5
    # block 0x004ee1d7: point.x < left: point.x = this+0x665
    mov edx, dword ptr [ebp + arg_point_ptr]             # 004ee1d7
    mov eax, dword ptr [ebp - local_this]           # 004ee1da
    mov ecx, dword ptr [eax + this_region3_left]         # 004ee1dd
    mov dword ptr [edx], ecx                     # 004ee1e3
L_mode3_x_max:
    # block 0x004ee1e5: mode 3, x maximum: limit = this+0x66d - signed word at [0x5b3790 + 8*cursor_type + 4*cursor_variant], if point.x < limit (signed jl) skip to L_mode3_y_min
    mov edx, dword ptr [0x5b44f4]                # 004ee1e5
    shl edx, 0x2                                 # 004ee1eb
    mov eax, dword ptr [0x5b44f0]                # 004ee1ee
    movsx ecx, word ptr [edx + 8*eax + 0x5b3790] # 004ee1f3
    mov edx, dword ptr [ebp - local_this]           # 004ee1fb
    mov eax, dword ptr [edx + this_region3_right]         # 004ee1fe
    {load} sub eax, ecx                          # 004ee204
    mov ecx, dword ptr [ebp + arg_point_ptr]             # 004ee206
    cmp dword ptr [ecx], eax                     # 004ee209
    jl.d8 L_mode3_y_min                             # 004ee20b
    # block 0x004ee20d: point.x >= limit: point.x = this+0x66d - the same extent word
    mov edx, dword ptr [0x5b44f4]                # 004ee20d
    shl edx, 0x2                                 # 004ee213
    mov eax, dword ptr [0x5b44f0]                # 004ee216
    movsx ecx, word ptr [edx + 8*eax + 0x5b3790] # 004ee21b
    mov edx, dword ptr [ebp - local_this]           # 004ee223
    mov eax, dword ptr [edx + this_region3_right]         # 004ee226
    {load} sub eax, ecx                          # 004ee22c
    mov ecx, dword ptr [ebp + arg_point_ptr]             # 004ee22e
    mov dword ptr [ecx], eax                     # 004ee231
L_mode3_y_min:
    # block 0x004ee233: mode 3, y minimum: if point.y >= this+0x669 (signed jge) skip to L_mode3_y_max
    mov edx, dword ptr [ebp + arg_point_ptr]             # 004ee233
    mov eax, dword ptr [ebp - local_this]           # 004ee236
    mov ecx, dword ptr [edx + point_y]           # 004ee239
    cmp ecx, dword ptr [eax + this_region3_top]         # 004ee23c
    jge.d8 L_mode3_y_max                            # 004ee242
    # block 0x004ee244: point.y < top: point.y = this+0x669
    mov edx, dword ptr [ebp + arg_point_ptr]             # 004ee244
    mov eax, dword ptr [ebp - local_this]           # 004ee247
    mov ecx, dword ptr [eax + this_region3_top]         # 004ee24a
    mov dword ptr [edx + point_y], ecx           # 004ee250
L_mode3_y_max:
    # block 0x004ee253: mode 3, y maximum: limit = this+0x671 - signed word at [0x5b3792 + 8*cursor_type + 4*cursor_variant], if point.y < limit (signed jl) skip to the epilogue
    mov edx, dword ptr [0x5b44f4]                # 004ee253
    shl edx, 0x2                                 # 004ee259
    mov eax, dword ptr [0x5b44f0]                # 004ee25c
    movsx ecx, word ptr [edx + 8*eax + 0x5b3792] # 004ee261
    mov edx, dword ptr [ebp - local_this]           # 004ee269
    mov eax, dword ptr [edx + this_region3_bottom]         # 004ee26c
    {load} sub eax, ecx                          # 004ee272
    mov ecx, dword ptr [ebp + arg_point_ptr]             # 004ee274
    cmp dword ptr [ecx + point_y], eax           # 004ee277
    jl.d8 L_epilogue                             # 004ee27a
    # block 0x004ee27c: point.y >= limit: point.y = this+0x671 - the same extent word
    mov edx, dword ptr [0x5b44f4]                # 004ee27c
    shl edx, 0x2                                 # 004ee282
    mov eax, dword ptr [0x5b44f0]                # 004ee285
    movsx ecx, word ptr [edx + 8*eax + 0x5b3792] # 004ee28a
    mov edx, dword ptr [ebp - local_this]           # 004ee292
    mov eax, dword ptr [edx + this_region3_bottom]         # 004ee295
    {load} sub eax, ecx                          # 004ee29b
    mov ecx, dword ptr [ebp + arg_point_ptr]             # 004ee29d
    mov dword ptr [ecx + point_y], eax           # 004ee2a0
L_epilogue:
    # block 0x004ee2a3: epilogue shared by every path: restore the frame and return, popping the 4 bytes of argument
    {load} mov esp, ebp                          # 004ee2a3
    pop ebp                                      # 004ee2a5
    ret 0x4                                      # 004ee2a6
