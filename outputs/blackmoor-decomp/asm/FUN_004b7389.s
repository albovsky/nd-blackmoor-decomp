# FUN_004b7389
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7389
# extent:       0x004b7389-0x004b7563 (474 code bytes)
# span:         0x004b7389-0x004b7563 (code 474, tables 0, padding 0)
# sha256:       e5127f1855b2f91943ce2241bdd73f5dff6d86acd31c5a7c199f0f049f354635
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# name:         HotspotOwner::publish_cursor_for_point
# arguments:    thiscall: ecx=this (saved at [ebp-local_this]), two signed words on the stack, callee pops 8 (ret 8): [ebp+8]=first coordinate (word, sign-extended, compared with the left and right dwords of each rectangle), [ebp+0xc]=second coordinate (word, sign-extended, compared with the top and bottom dwords). Returns eax=0 when the byte at this+0x35 is zero (nothing else touched), otherwise eax=1 after updating the cursor globals, whether or not any rectangle was hit
# locals:       frame 8 bytes: [ebp-4]=payload pointer of action slot this+0x21 (the dword at 0x5bb5e5 + word(this+0x21)*0x8d, which is slot base 0x5bb5e3 + slot*0x8d + 2), [ebp-8]=this (spilled from ecx)
# fields:       this+0x21: signed word action slot index (times 0x8d into the table at 0x5bb5e5, whose entries are the payload pointers at slot+2, slot base 0x5bb5e3), this+0x35: byte enable flag, payload+0x25: byte flag choosing between 0x14 and 0x15, payload+0x2b, +0x2f, +0x33, +0x37: four dwords (left, top, right, bottom) of rectangle B, payload+0x3b, +0x3f, +0x43, +0x47: four dwords of rectangle C, payload+0x3b6, +0x3ba, +0x3be, +0x3c2: four dwords of rectangle A, globals 0x005bb5e5 (payload pointer of each action slot, slot base 0x5bb5e3 + 2, stride 0x8d), 0x005b44f0 (cursor_type, written and read), 0x005b44f4 (cursor_variant, written and read), 0x005d0377 (default_cursor_surface, read), 0x005d162d (cursor_surface, written), 0x005d1631 (cursor_src_index, written with the address 0x5b160c + (cursor_type<<5) + (cursor_variant<<4)), 0x005d1639 (cursor_layer_enabled, written 1), 0x005c39e5 (written with 0x27c1, 0x27bf or 0x27c0 on a rectangle hit). The global names are the labels in src/caption_lifecycle.h; 0x5d162d, 0x5d1631 and 0x5d1639 are fields +8, +0xc and +0x14 of entry 2 of the render layer table 0x5d1591 (stride 0x4a, 0x5d1591 + 2*0x4a = 0x5d1625), per tests/caption_lifecycle_original_oracle.py:56-57.
# callees:      none
# track-n:      host-adapter: none
# unverified:   The routine name (a label chosen because the return value is not a hit result) and the rectangle, coordinate and payload field names are role labels. The return value is not a hit result: eax = 1 whenever this+0x35 is non-zero, hit or not (jl to L_set_descriptor at 0x4b74c4 leads to mov eax,1 at 0x4b7554), unlike FUN_004897cd which returns 1 only on a hit. The roles of the two coordinates (first compared with +0x2b/+0x33 and so on, so probably x, with the caller 0x4f0059 passing this+0x5e as the first argument and this+0x5a as the second, confirmed at the call site) and of the three rectangles are read from the comparison order only, not from a caller trace redone here. Rectangle bounds are inclusive and signed (a point is outside when it is below the minimum or above the maximum). What the cursor type values 9, 0x14 and 0x15, the descriptor table at 0x5b160c (strides 0x20 and 0x10 from the shifts) and the values 0x27c1, 0x27bf and 0x27c0 stored in 0x5c39e5 mean to the game (repo documents call 0x5c39e5 both a pending event index and slider_cursor_scene) is not established here. When no rectangle hits, cursor_type and cursor_variant keep their previous values and the descriptor globals 0x5d162d, 0x5d1631 and 0x5d1639 are still rewritten from them, and 0x5c39e5 is left alone. Rectangle C is tested after rectangle B and wins when both contain the point. The original does not check the action slot index in this+0x21 against the table, so the native port must reject a bad index explicitly. The only call site is 0x4f0cdb inside 0x4f0059, which loads ecx = 0x6249a0 (a static object), pushes caller+0x5a then caller+0x5e so the first argument is caller+0x5e and the second is caller+0x5a; whether 0x6249a0 is the only instance is not established. Track N's cursor_src_index label counts dwords (src/caption_lifecycle.h:164: (address-0x5b160c)/4); the bytes store the byte address 0x5b160c + (type<<5) + (variant<<4). No Track N function corresponds (src/caption_lifecycle.h only declares the globals).
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_payload, 0x4  # [ebp - 0x4]: payload pointer of action slot this+0x21, loaded from the 0x5bb5e5 table
.equ local_this, 0x8  # [ebp - 0x8]: this, spilled from ecx
.equ arg_coord_first, 0x8  # [ebp + 0x8]: first coordinate (signed word), tested against left and right
.equ arg_coord_second, 0xc  # [ebp + 0xc]: second coordinate (signed word), tested against top and bottom
.equ this_slot_index, 0x21  # this+0x21: signed word action slot index into the 0x5bb5e5 payload pointer table
.equ rec_variant_flag, 0x25  # payload+0x25: byte flag, non-zero selects cursor type 0x14, zero selects 0x15
.equ rec_rect_b_left, 0x2b  # payload+0x2b: dword left of rectangle B
.equ rec_rect_b_top, 0x2f  # payload+0x2f: dword top of rectangle B
.equ rec_rect_b_right, 0x33  # payload+0x33: dword right of rectangle B (inclusive)
.equ this_enabled, 0x35  # this+0x35: byte, zero makes the routine return 0 at once
.equ rec_rect_b_bottom, 0x37  # payload+0x37: dword bottom of rectangle B (inclusive)
.equ rec_rect_c_left, 0x3b  # payload+0x3b: dword left of rectangle C
.equ rec_rect_c_top, 0x3f  # payload+0x3f: dword top of rectangle C
.equ rec_rect_c_right, 0x43  # payload+0x43: dword right of rectangle C (inclusive)
.equ rec_rect_c_bottom, 0x47  # payload+0x47: dword bottom of rectangle C (inclusive)
.equ rec_rect_a_left, 0x3b6  # payload+0x3b6: dword left of rectangle A
.equ rec_rect_a_top, 0x3ba  # payload+0x3ba: dword top of rectangle A
.equ rec_rect_a_right, 0x3be  # payload+0x3be: dword right of rectangle A (inclusive)
.equ rec_rect_a_bottom, 0x3c2  # payload+0x3c2: dword bottom of rectangle A (inclusive)

# --- external targets -----------------------------------------------

.org 0x004b7389 - 0x401000
.globl FUN_004b7389
FUN_004b7389:
    # block 0x004b7389: entry: save this, payload pointer = pointer at 0x5bb5e5 + word(this+0x21)*0x8d, load the byte at this+0x35 and if it is zero jump to L_return_0 (je)
    push ebp                                     # 004b7389
    {load} mov ebp, esp                          # 004b738a
    sub esp, 0x8                                 # 004b738c
    mov dword ptr [ebp - local_this], ecx           # 004b738f
    mov eax, dword ptr [ebp - local_this]           # 004b7392
    movsx ecx, word ptr [eax + this_slot_index]         # 004b7395
    imul ecx, ecx, 0x8d                          # 004b7399
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b739f
    mov dword ptr [ebp - local_payload], edx           # 004b73a5
    mov eax, dword ptr [ebp - local_this]           # 004b73a8
    {load} xor ecx, ecx                          # 004b73ab
    mov cl, byte ptr [eax + this_enabled]            # 004b73ad
    test ecx, ecx                                # 004b73b0
    je.d32 L_return_0                            # 004b73b2
    # block 0x004b73b8: rectangle A test, part 1: if second coordinate < rec_rect_a_top (signed jl) the point is outside, go to L_test_rect_b
    movsx edx, word ptr [ebp + arg_coord_second]            # 004b73b8
    mov eax, dword ptr [ebp - local_payload]           # 004b73bc
    cmp edx, dword ptr [eax + rec_rect_a_top]         # 004b73bf
    jl.d32 L_test_rect_b                            # 004b73c5
    # block 0x004b73cb: rectangle A test, part 2: if second coordinate > rec_rect_a_bottom (signed jg) go to L_test_rect_b
    movsx ecx, word ptr [ebp + arg_coord_second]            # 004b73cb
    mov edx, dword ptr [ebp - local_payload]           # 004b73cf
    cmp ecx, dword ptr [edx + rec_rect_a_bottom]         # 004b73d2
    jg.d8 L_test_rect_b                             # 004b73d8
    # block 0x004b73da: rectangle A test, part 3: if first coordinate < rec_rect_a_left (signed jl) go to L_test_rect_b
    movsx eax, word ptr [ebp + arg_coord_first]            # 004b73da
    mov ecx, dword ptr [ebp - local_payload]           # 004b73de
    cmp eax, dword ptr [ecx + rec_rect_a_left]         # 004b73e1
    jl.d8 L_test_rect_b                             # 004b73e7
    # block 0x004b73e9: rectangle A test, part 4: if first coordinate > rec_rect_a_right (signed jg) go to L_test_rect_b
    movsx edx, word ptr [ebp + arg_coord_first]            # 004b73e9
    mov eax, dword ptr [ebp - local_payload]           # 004b73ed
    cmp edx, dword ptr [eax + rec_rect_a_right]         # 004b73f0
    jg.d8 L_test_rect_b                             # 004b73f6
    # block 0x004b73f8: point inside rectangle A: cursor_type = 9, cursor_variant = 1, cursor_surface = default_cursor_surface, cursor_src_index = 0x5b160c + (9<<5) + (1<<4) computed from the two globals, cursor_layer_enabled = 1, 0x5c39e5 = 0x27c1, return 1
    mov dword ptr [0x5b44f0], 0x9                # 004b73f8
    mov dword ptr [0x5b44f4], 0x1                # 004b7402
    mov ecx, dword ptr [0x5d0377]                # 004b740c
    mov dword ptr [0x5d162d], ecx                # 004b7412
    mov edx, dword ptr [0x5b44f0]                # 004b7418
    shl edx, 0x5                                 # 004b741e
    mov eax, dword ptr [0x5b44f4]                # 004b7421
    shl eax, 0x4                                 # 004b7426
    lea ecx, [edx + eax + 0x5b160c]              # 004b7429
    mov dword ptr [0x5d1631], ecx                # 004b7430
    mov dword ptr [0x5d1639], 0x1                # 004b7436
    mov dword ptr [0x5c39e5], 0x27c1             # 004b7440
    mov eax, 0x1                                 # 004b744a
    jmp.d32 L_epilogue                           # 004b744f
L_test_rect_b:
    # block 0x004b7454: rectangle B test, part 1: if second coordinate < rec_rect_b_top (signed jl) go to L_test_rect_c
    movsx edx, word ptr [ebp + arg_coord_second]            # 004b7454
    mov eax, dword ptr [ebp - local_payload]           # 004b7458
    cmp edx, dword ptr [eax + rec_rect_b_top]          # 004b745b
    jl.d8 L_test_rect_c                             # 004b745e
    # block 0x004b7460: rectangle B test, part 2: if second coordinate > rec_rect_b_bottom (signed jg) go to L_test_rect_c
    movsx ecx, word ptr [ebp + arg_coord_second]            # 004b7460
    mov edx, dword ptr [ebp - local_payload]           # 004b7464
    cmp ecx, dword ptr [edx + rec_rect_b_bottom]          # 004b7467
    jg.d8 L_test_rect_c                             # 004b746a
    # block 0x004b746c: rectangle B test, part 3: if first coordinate < rec_rect_b_left (signed jl) go to L_test_rect_c
    movsx eax, word ptr [ebp + arg_coord_first]            # 004b746c
    mov ecx, dword ptr [ebp - local_payload]           # 004b7470
    cmp eax, dword ptr [ecx + rec_rect_b_left]          # 004b7473
    jl.d8 L_test_rect_c                             # 004b7476
    # block 0x004b7478: rectangle B test, part 4: if first coordinate > rec_rect_b_right (signed jg) go to L_test_rect_c
    movsx edx, word ptr [ebp + arg_coord_first]            # 004b7478
    mov eax, dword ptr [ebp - local_payload]           # 004b747c
    cmp edx, dword ptr [eax + rec_rect_b_right]          # 004b747f
    jg.d8 L_test_rect_c                             # 004b7482
    # block 0x004b7484: point inside rectangle B: cursor_variant = 1, test the byte at payload+0x25 and if it is zero jump to L_b_type_15 (je)
    mov dword ptr [0x5b44f4], 0x1                # 004b7484
    mov ecx, dword ptr [ebp - local_payload]           # 004b748e
    {load} xor edx, edx                          # 004b7491
    mov dl, byte ptr [ecx + rec_variant_flag]            # 004b7493
    test edx, edx                                # 004b7496
    je.d8 L_b_type_15                             # 004b7498
    # block 0x004b749a: payload+0x25 non-zero: cursor_type = 0x14, jump to L_b_store_scene
    mov dword ptr [0x5b44f0], 0x14               # 004b749a
    jmp.d8 L_b_store_scene                            # 004b74a4
L_b_type_15:
    # block 0x004b74a6: payload+0x25 zero: cursor_type = 0x15
    mov dword ptr [0x5b44f0], 0x15               # 004b74a6
L_b_store_scene:
    # block 0x004b74b0: rectangle B hit: 0x5c39e5 = 0x27bf, falls into the rectangle C test
    mov dword ptr [0x5c39e5], 0x27bf             # 004b74b0
L_test_rect_c:
    # block 0x004b74ba: rectangle C test, part 1: if second coordinate < rec_rect_c_top (signed jl) go to L_set_descriptor
    movsx eax, word ptr [ebp + arg_coord_second]            # 004b74ba
    mov ecx, dword ptr [ebp - local_payload]           # 004b74be
    cmp eax, dword ptr [ecx + rec_rect_c_top]          # 004b74c1
    jl.d8 L_set_descriptor                             # 004b74c4
    # block 0x004b74c6: rectangle C test, part 2: if second coordinate > rec_rect_c_bottom (signed jg) go to L_set_descriptor
    movsx edx, word ptr [ebp + arg_coord_second]            # 004b74c6
    mov eax, dword ptr [ebp - local_payload]           # 004b74ca
    cmp edx, dword ptr [eax + rec_rect_c_bottom]          # 004b74cd
    jg.d8 L_set_descriptor                             # 004b74d0
    # block 0x004b74d2: rectangle C test, part 3: if first coordinate < rec_rect_c_left (signed jl) go to L_set_descriptor
    movsx ecx, word ptr [ebp + arg_coord_first]            # 004b74d2
    mov edx, dword ptr [ebp - local_payload]           # 004b74d6
    cmp ecx, dword ptr [edx + rec_rect_c_left]          # 004b74d9
    jl.d8 L_set_descriptor                             # 004b74dc
    # block 0x004b74de: rectangle C test, part 4: if first coordinate > rec_rect_c_right (signed jg) go to L_set_descriptor
    movsx eax, word ptr [ebp + arg_coord_first]            # 004b74de
    mov ecx, dword ptr [ebp - local_payload]           # 004b74e2
    cmp eax, dword ptr [ecx + rec_rect_c_right]          # 004b74e5
    jg.d8 L_set_descriptor                             # 004b74e8
    # block 0x004b74ea: point inside rectangle C: cursor_variant = 1, test the byte at payload+0x25 and if it is zero jump to L_c_type_15 (je)
    mov dword ptr [0x5b44f4], 0x1                # 004b74ea
    mov edx, dword ptr [ebp - local_payload]           # 004b74f4
    {load} xor eax, eax                          # 004b74f7
    mov al, byte ptr [edx + rec_variant_flag]            # 004b74f9
    test eax, eax                                # 004b74fc
    je.d8 L_c_type_15                             # 004b74fe
    # block 0x004b7500: payload+0x25 non-zero: cursor_type = 0x14, jump to L_c_store_scene
    mov dword ptr [0x5b44f0], 0x14               # 004b7500
    jmp.d8 L_c_store_scene                            # 004b750a
L_c_type_15:
    # block 0x004b750c: payload+0x25 zero: cursor_type = 0x15
    mov dword ptr [0x5b44f0], 0x15               # 004b750c
L_c_store_scene:
    # block 0x004b7516: rectangle C hit: 0x5c39e5 = 0x27c0, falls into L_set_descriptor
    mov dword ptr [0x5c39e5], 0x27c0             # 004b7516
L_set_descriptor:
    # block 0x004b7520: common tail for the B and C paths: cursor_surface = default_cursor_surface, cursor_src_index = 0x5b160c + (cursor_type<<5) + (cursor_variant<<4), cursor_layer_enabled = 1, return 1
    mov ecx, dword ptr [0x5d0377]                # 004b7520
    mov dword ptr [0x5d162d], ecx                # 004b7526
    mov edx, dword ptr [0x5b44f0]                # 004b752c
    shl edx, 0x5                                 # 004b7532
    mov eax, dword ptr [0x5b44f4]                # 004b7535
    shl eax, 0x4                                 # 004b753a
    lea ecx, [edx + eax + 0x5b160c]              # 004b753d
    mov dword ptr [0x5d1631], ecx                # 004b7544
    mov dword ptr [0x5d1639], 0x1                # 004b754a
    mov eax, 0x1                                 # 004b7554
    jmp.d8 L_epilogue                            # 004b7559
L_return_0:
    # block 0x004b755b: this+0x35 was zero: eax = 0 (xor eax,eax)
    {load} xor eax, eax                          # 004b755b
L_epilogue:
    # block 0x004b755d: epilogue shared by both returns: restore the frame and return, popping the 8 bytes of arguments
    {load} mov esp, ebp                          # 004b755d
    pop ebp                                      # 004b755f
    ret 0x8                                      # 004b7560
