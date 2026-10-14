# FUN_0048d3cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048d3cb
# extent:       0x0048d3cb-0x0048d5f4 (553 code bytes)
# span:         0x0048d3cb-0x0048d5f4 (code 553, tables 0, padding 0)
# sha256:       24c7997adcd6e49ebf1cc544724aacb8770595cf8b5831aa00942d01edd94b2b
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# name:         PointerHitTest::apply_hover_cursor
# arguments:    thiscall, stdcall-style stack cleanup: ecx=this; [ebp+8] = hit kind (signed 16-bit read: 0x2766 = special rectangle, 0x2765 = indexed rectangle, anything else = no hit); [ebp+0xc] = rectangle index (signed 16-bit read, only used when kind is 0x2765); callee pops both with ret 0x8; no return value (eax is scratch)
# locals:       [ebp-local_this] = this (spilled from ecx); [ebp-local_payload] = dword read from the action-slot table: *(0x005bb5e5 + (signed word this+0x1e) * 0x8d), the payload pointer of the action slot this object refers to
# fields:       this+0x1e word: action slot index (stride 0x8d, table 0x5bb5e5); this+0x24 byte: written 1 for kinds 0x2766 and 0x2765; this+0x26 byte: read, when zero the index is stored; this+0x27 word: written 0xffff (kind 0x2766 or any other kind) or the low word of the rectangle index (kind 0x2765 and this+0x26 == 0). Payload (via the slot payload pointer): rectangle array +0x203 (left), +0x207 (top), +0x20b (right), +0x20f (bottom) as signed dwords, stride 0x10, indexed by the argument; region A: +0x2f3 word (cursor type), +0x2f5 (left), +0x2f9 (top), +0x2fd (right), +0x301 (bottom) dwords; region B: +0x305 word (cursor type), +0x307 (left), +0x30b (top), +0x30f (right), +0x313 (bottom) dwords. Globals written: 0x005b44f0 (cursor type: 9, the word at payload+0x2f3 or +0x305, or 0), 0x005b44f4 (cursor variant: 1), 0x005d162d (copy of the dword at 0x005d0377), 0x005d1631 (0x005b160c + type*0x20 + variant*0x10), 0x005d1639 (1), 0x005c39e5 (0x2766 or 0x2765, the kind). Globals read: 0x005d0377, 0x005b44f0 and 0x005b44f4 (re-read after being stored). Table base 0x005bb5e5 is read only
# callees:      none
# track-n:      host-adapter: none
# unverified:   Class and method name are my labels. The only caller in the pseudocode corpus is FUN_0048d1e8 (unverified pseudocode: it calls this with 0x2766 and 0 when a point is inside the rectangle at payload +0x7ab..+0x7b7, and with 0x2765 and the loop index when the point is inside rect[i]); that call shape was not re-read in the bytes, and it is the only evidence for the argument roles (kind, index). The names region A and region B, and what the words at payload +0x2f3 and +0x305 mean, are not established: the bytes only show that the chosen rectangle is tested for being contained inside the region (rect.top >= region.top, rect.bottom <= region.bottom, rect.left >= region.left, rect.right <= region.right, all signed dword compares) and that the matching word becomes the cursor type, else 0. Caption_lifecycle.h names 0x5b44f0 cursor_type, 0x5b44f4 cursor_variant, 0x5d162d cursor_surface, 0x5d0377 default_cursor_surface, 0x5d1631 cursor_src_index, 0x5d1639 cursor_layer_enabled and 0x5c39e5 slider_cursor_scene; those are Track N labels, and the meaning of the literals 0x2765 and 0x2766 to the readers of 0x5c39e5 is not established here. Meaning of this+0x24, this+0x26 and this+0x27 is not established beyond the stores and test described. A slot index or rectangle index out of range is not guarded in the original; the native port must reject it explicitly.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_payload, 0x4  # [ebp - 0x4]: payload pointer of the action slot (*(0x5bb5e5 + slot*0x8d))
.equ local_this, 0x8  # [ebp - 0x8]: this, spilled from ecx
.equ arg_kind, 0x8  # [ebp + 0x8]: hit kind (low word, signed): 0x2766 or 0x2765
.equ arg_index, 0xc  # [ebp + 0xc]: rectangle index (low word, signed)

# --- fields of this (ecx) ----------------------------------------------
.equ obj_slot_index, 0x1e  # this+0x1e: signed word, index into the 0x8d-stride action slot table
.equ obj_flag_24, 0x24  # this+0x24: byte, set to 1 on a hit kind
.equ obj_flag_26, 0x26  # this+0x26: byte, zero test only (use not established)
.equ obj_hit_index_27, 0x27  # this+0x27: word, 0xffff or the stored rectangle index

# --- fields of the slot payload (local_payload) --------------------------
.equ pay_rect_left, 0x203  # payload+0x203+i*0x10: dword, rectangle left
.equ pay_rect_top, 0x207  # payload+0x207+i*0x10: dword, rectangle top
.equ pay_rect_right, 0x20b  # payload+0x20b+i*0x10: dword, rectangle right
.equ pay_rect_bottom, 0x20f  # payload+0x20f+i*0x10: dword, rectangle bottom
.equ pay_region_a_type, 0x2f3  # payload+0x2f3: signed word, cursor type used when the rectangle lies inside region A
.equ pay_region_a_left, 0x2f5  # payload+0x2f5: dword, region A left
.equ pay_region_a_top, 0x2f9  # payload+0x2f9: dword, region A top
.equ pay_region_a_right, 0x2fd  # payload+0x2fd: dword, region A right
.equ pay_region_a_bottom, 0x301  # payload+0x301: dword, region A bottom
.equ pay_region_b_type, 0x305  # payload+0x305: signed word, cursor type used when the rectangle lies inside region B
.equ pay_region_b_left, 0x307  # payload+0x307: dword, region B left
.equ pay_region_b_top, 0x30b  # payload+0x30b: dword, region B top
.equ pay_region_b_right, 0x30f  # payload+0x30f: dword, region B right
.equ pay_region_b_bottom, 0x313  # payload+0x313: dword, region B bottom

# --- external targets -----------------------------------------------

.org 0x0048d3cb - 0x401000
.globl FUN_0048d3cb
FUN_0048d3cb:
    # block 0x0048d3cb: entry: spill this, load the slot payload pointer from 0x5bb5e5 + (signed word this+0x1e)*0x8d into local_payload; if the (signed word) kind is not 0x2766 jump to check_kind_2765 (jne)
    push ebp                                     # 0048d3cb
    {load} mov ebp, esp                          # 0048d3cc
    sub esp, 0x8                                 # 0048d3ce
    mov dword ptr [ebp - local_this], ecx           # 0048d3d1
    mov eax, dword ptr [ebp - local_this]           # 0048d3d4
    movsx ecx, word ptr [eax + obj_slot_index]         # 0048d3d7
    imul ecx, ecx, 0x8d                          # 0048d3db
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048d3e1
    mov dword ptr [ebp - local_payload], edx           # 0048d3e7
    movsx eax, word ptr [ebp + arg_kind]            # 0048d3ea
    cmp eax, 0x2766                              # 0048d3ee
    jne.d8 check_kind_2765                            # 0048d3f3
    # block 0x0048d3f5: kind 0x2766: cursor type 9 to 0x5b44f0, variant 1 to 0x5b44f4; 0x5d162d = dword at 0x5d0377; 0x5d1631 = 0x5b160c + (type<<5) + (variant<<4) (0x5b173c, both globals re-read); 0x5d1639 = 1; 0x5c39e5 = 0x2766; this+0x24 = 1; word this+0x27 = 0xffff; jump to the epilogue
    mov dword ptr [0x5b44f0], 0x9                # 0048d3f5
    mov dword ptr [0x5b44f4], 0x1                # 0048d3ff
    mov ecx, dword ptr [0x5d0377]                # 0048d409
    mov dword ptr [0x5d162d], ecx                # 0048d40f
    mov edx, dword ptr [0x5b44f0]                # 0048d415
    shl edx, 0x5                                 # 0048d41b
    mov eax, dword ptr [0x5b44f4]                # 0048d41e
    shl eax, 0x4                                 # 0048d423
    lea ecx, [edx + eax + 0x5b160c]              # 0048d426
    mov dword ptr [0x5d1631], ecx                # 0048d42d
    mov dword ptr [0x5d1639], 0x1                # 0048d433
    mov dword ptr [0x5c39e5], 0x2766             # 0048d43d
    mov edx, dword ptr [ebp - local_this]           # 0048d447
    mov byte ptr [edx + obj_flag_24], 0x1           # 0048d44a
    mov eax, dword ptr [ebp - local_this]           # 0048d44e
    mov word ptr [eax + obj_hit_index_27], 0xffff        # 0048d451
    jmp.d32 epilogue                           # 0048d457
check_kind_2765:
    # block 0x0048d45c: kind is not 0x2766: if the (signed word) kind is not 0x2765 jump to other_kind (jne)
    movsx ecx, word ptr [ebp + arg_kind]            # 0048d45c
    cmp ecx, 0x2765                              # 0048d460
    jne.d32 other_kind                           # 0048d466
    # block 0x0048d46c: kind 0x2765: 0x5b44f4 = 1; 0x5d162d = dword at 0x5d0377; rectangle top (dword payload+0x207+index*0x10) is compared with region A top (payload+0x2f9); if rect.top < region.top (jl, signed) go to try_region_b
    mov dword ptr [0x5b44f4], 0x1                # 0048d46c
    mov edx, dword ptr [0x5d0377]                # 0048d476
    mov dword ptr [0x5d162d], edx                # 0048d47c
    movsx eax, word ptr [ebp + arg_index]            # 0048d482
    shl eax, 0x4                                 # 0048d486
    mov ecx, dword ptr [ebp - local_payload]           # 0048d489
    mov edx, dword ptr [ebp - local_payload]           # 0048d48c
    mov eax, dword ptr [ecx + eax + pay_rect_top]   # 0048d48f
    cmp eax, dword ptr [edx + pay_region_a_top]         # 0048d496
    jl.d8 try_region_b                             # 0048d49c
    # block 0x0048d49e: if rect.bottom (payload+0x20f+index*0x10) > region A bottom (payload+0x301) go to try_region_b (jg, signed)
    movsx ecx, word ptr [ebp + arg_index]            # 0048d49e
    shl ecx, 0x4                                 # 0048d4a2
    mov edx, dword ptr [ebp - local_payload]           # 0048d4a5
    mov eax, dword ptr [ebp - local_payload]           # 0048d4a8
    mov ecx, dword ptr [edx + ecx + pay_rect_bottom]   # 0048d4ab
    cmp ecx, dword ptr [eax + pay_region_a_bottom]         # 0048d4b2
    jg.d8 try_region_b                             # 0048d4b8
    # block 0x0048d4ba: if rect.left (payload+0x203+index*0x10) < region A left (payload+0x2f5) go to try_region_b (jl, signed)
    movsx edx, word ptr [ebp + arg_index]            # 0048d4ba
    shl edx, 0x4                                 # 0048d4be
    mov eax, dword ptr [ebp - local_payload]           # 0048d4c1
    mov ecx, dword ptr [ebp - local_payload]           # 0048d4c4
    mov edx, dword ptr [eax + edx + pay_rect_left]   # 0048d4c7
    cmp edx, dword ptr [ecx + pay_region_a_left]         # 0048d4ce
    jl.d8 try_region_b                             # 0048d4d4
    # block 0x0048d4d6: if rect.right (payload+0x20b+index*0x10) > region A right (payload+0x2fd) go to try_region_b (jg, signed)
    movsx eax, word ptr [ebp + arg_index]            # 0048d4d6
    shl eax, 0x4                                 # 0048d4da
    mov ecx, dword ptr [ebp - local_payload]           # 0048d4dd
    mov edx, dword ptr [ebp - local_payload]           # 0048d4e0
    mov eax, dword ptr [ecx + eax + pay_rect_right]   # 0048d4e3
    cmp eax, dword ptr [edx + pay_region_a_right]         # 0048d4ea
    jg.d8 try_region_b                             # 0048d4f0
    # block 0x0048d4f2: rectangle lies inside region A: 0x5b44f0 = sign-extended word payload+0x2f3; jump to set_cursor_source
    mov ecx, dword ptr [ebp - local_payload]           # 0048d4f2
    movsx edx, word ptr [ecx + pay_region_a_type]        # 0048d4f5
    mov dword ptr [0x5b44f0], edx                # 0048d4fc
    jmp.d32 set_cursor_source                           # 0048d502
try_region_b:
    # block 0x0048d507: try region B: if rect.top < region B top (payload+0x30b) go to cursor_type_zero (jl, signed)
    movsx eax, word ptr [ebp + arg_index]            # 0048d507
    shl eax, 0x4                                 # 0048d50b
    mov ecx, dword ptr [ebp - local_payload]           # 0048d50e
    mov edx, dword ptr [ebp - local_payload]           # 0048d511
    mov eax, dword ptr [ecx + eax + pay_rect_top]   # 0048d514
    cmp eax, dword ptr [edx + pay_region_b_top]         # 0048d51b
    jl.d8 cursor_type_zero                             # 0048d521
    # block 0x0048d523: if rect.bottom > region B bottom (payload+0x313) go to cursor_type_zero (jg, signed)
    movsx ecx, word ptr [ebp + arg_index]            # 0048d523
    shl ecx, 0x4                                 # 0048d527
    mov edx, dword ptr [ebp - local_payload]           # 0048d52a
    mov eax, dword ptr [ebp - local_payload]           # 0048d52d
    mov ecx, dword ptr [edx + ecx + pay_rect_bottom]   # 0048d530
    cmp ecx, dword ptr [eax + pay_region_b_bottom]         # 0048d537
    jg.d8 cursor_type_zero                             # 0048d53d
    # block 0x0048d53f: if rect.left < region B left (payload+0x307) go to cursor_type_zero (jl, signed)
    movsx edx, word ptr [ebp + arg_index]            # 0048d53f
    shl edx, 0x4                                 # 0048d543
    mov eax, dword ptr [ebp - local_payload]           # 0048d546
    mov ecx, dword ptr [ebp - local_payload]           # 0048d549
    mov edx, dword ptr [eax + edx + pay_rect_left]   # 0048d54c
    cmp edx, dword ptr [ecx + pay_region_b_left]         # 0048d553
    jl.d8 cursor_type_zero                             # 0048d559
    # block 0x0048d55b: if rect.right > region B right (payload+0x30f) go to cursor_type_zero (jg, signed)
    movsx eax, word ptr [ebp + arg_index]            # 0048d55b
    shl eax, 0x4                                 # 0048d55f
    mov ecx, dword ptr [ebp - local_payload]           # 0048d562
    mov edx, dword ptr [ebp - local_payload]           # 0048d565
    mov eax, dword ptr [ecx + eax + pay_rect_right]   # 0048d568
    cmp eax, dword ptr [edx + pay_region_b_right]         # 0048d56f
    jg.d8 cursor_type_zero                             # 0048d575
    # block 0x0048d577: rectangle lies inside region B: 0x5b44f0 = sign-extended word payload+0x305; jump to set_cursor_source
    mov ecx, dword ptr [ebp - local_payload]           # 0048d577
    movsx edx, word ptr [ecx + pay_region_b_type]        # 0048d57a
    mov dword ptr [0x5b44f0], edx                # 0048d581
    jmp.d8 set_cursor_source                            # 0048d587
cursor_type_zero:
    # block 0x0048d589: rectangle outside both regions: 0x5b44f0 = 0
    mov dword ptr [0x5b44f0], 0x0                # 0048d589
set_cursor_source:
    # block 0x0048d593: 0x5d1631 = 0x5b160c + (0x5b44f0<<5) + (0x5b44f4<<4); 0x5d1639 = 1; 0x5c39e5 = 0x2765; this+0x24 = 1; if the byte this+0x26 is non-zero jump to after_index_store (jne)
    mov eax, dword ptr [0x5b44f0]                # 0048d593
    shl eax, 0x5                                 # 0048d598
    mov ecx, dword ptr [0x5b44f4]                # 0048d59b
    shl ecx, 0x4                                 # 0048d5a1
    lea edx, [eax + ecx + 0x5b160c]              # 0048d5a4
    mov dword ptr [0x5d1631], edx                # 0048d5ab
    mov dword ptr [0x5d1639], 0x1                # 0048d5b1
    mov dword ptr [0x5c39e5], 0x2765             # 0048d5bb
    mov eax, dword ptr [ebp - local_this]           # 0048d5c5
    mov byte ptr [eax + obj_flag_24], 0x1           # 0048d5c8
    mov ecx, dword ptr [ebp - local_this]           # 0048d5cc
    {load} xor edx, edx                          # 0048d5cf
    mov dl, byte ptr [ecx + obj_flag_26]            # 0048d5d1
    test edx, edx                                # 0048d5d4
    jne.d8 after_index_store                            # 0048d5d6
    # block 0x0048d5d8: this+0x26 == 0: store the low word of the rectangle index into the word this+0x27
    mov eax, dword ptr [ebp - local_this]           # 0048d5d8
    mov cx, word ptr [ebp + arg_index]               # 0048d5db
    mov word ptr [eax + obj_hit_index_27], cx            # 0048d5df
after_index_store:
    # block 0x0048d5e3: kind 0x2765 path done: jump to the epilogue
    jmp.d8 epilogue                            # 0048d5e3
other_kind:
    # block 0x0048d5e5: any other kind: word this+0x27 = 0xffff
    mov edx, dword ptr [ebp - local_this]           # 0048d5e5
    mov word ptr [edx + obj_hit_index_27], 0xffff        # 0048d5e8
epilogue:
    # block 0x0048d5ee: epilogue: restore the frame and return, popping the two stack arguments (ret 8)
    {load} mov esp, ebp                          # 0048d5ee
    pop ebp                                      # 0048d5f0
    ret 0x8                                      # 0048d5f1
