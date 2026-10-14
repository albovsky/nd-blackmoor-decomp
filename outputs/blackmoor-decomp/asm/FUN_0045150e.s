# FUN_0045150e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045150e
# extent:       0x0045150e-0x004516c7 (441 code bytes)
# span:         0x0045150e-0x004516c7 (code 441, tables 0, padding 0)
# sha256:       1256a6434fa9106c75a762252be270de6f1cff1424df1b386c3b9205dbfe6bfd
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# name:         PuzzleSprite::clip_rect_to_window_compute_src_dst
# arguments:    thiscall: ecx=this, one stack argument [esp+4] = arg_rect, pointer to four int32 {left, top, right, bottom} (the caller FUN_0044ffa3 builds it with right = left + width - 1 and bottom = top + height - 1), callee pops it (ret 4), returns eax = 0 when the rectangle is at least partly inside the clip window (output rectangles filled), eax = 1 when it is fully outside (both output rectangles zeroed)
# locals:       [ebp-4] = this, spilled from ecx (push ecx reserves the slot)
# fields:       arg_rect+0 left, +4 top, +8 right, +0xc bottom (read), this+0x3c clip left, +0x40 clip top, +0x44 clip right, +0x48 clip bottom (read), this+0x108 source left, +0x10c source top, +0x110 source right, +0x114 source bottom (read, the unclipped source rectangle), output source rectangle this+0x128 left, +0x12c top, +0x130 right, +0x134 bottom and output destination rectangle this+0x138 left, +0x13c top, +0x140 right, +0x144 bottom (written, all dwords), no globals touched
# callees:      none
# track-n:      host-adapter: none
# unverified:   Class name and the words window, sprite, source and destination are my labels: the compare pattern is a rectangle intersection that shifts the source rectangle by the clipped amount, but the bytes do not say what the rectangles are drawn from. The only call site I decoded is 0x00450564 inside FUN_0044ffa3 (the strings nearest that routine are AngleToss puzzle texts, but the class is not proven). In the visible path the top edge is NOT clipped: dst top = arg_rect top and src top = this+0x10c even when arg_rect top is above clip top (only the rejection test compares clip top, against arg_rect bottom), I report this as what the bytes do, and whether the original author intended it is open. All compares are signed (jle, jge, jg, jl forms). The rejection test uses strict inequalities against inclusive rectangles: right <= clip left, left >= clip right, top >= clip bottom and bottom <= clip top reject, whether clip right and clip bottom are inclusive or exclusive coordinates is not established by this routine.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]: this, spilled from ecx
.equ arg_rect, 0x8  # [ebp + 0x8]: pointer to the input rectangle (four int32: left, top, right, bottom)
.equ in_rect_top, 0x4  # arg_rect+4: int32 top
.equ in_rect_right, 0x8  # arg_rect+8: int32 right
.equ in_rect_bottom, 0xc  # arg_rect+0xc: int32 bottom
.equ clip_left, 0x3c  # this+0x3c: int32 clip window left
.equ clip_top, 0x40  # this+0x40: int32 clip window top
.equ clip_right, 0x44  # this+0x44: int32 clip window right
.equ clip_bottom, 0x48  # this+0x48: int32 clip window bottom
.equ src_full_left, 0x108  # this+0x108: int32 unclipped source rectangle left
.equ src_full_top, 0x10c  # this+0x10c: int32 unclipped source rectangle top
.equ src_full_right, 0x110  # this+0x110: int32 unclipped source rectangle right
.equ src_full_bottom, 0x114  # this+0x114: int32 unclipped source rectangle bottom
.equ src_out_left, 0x128  # this+0x128: int32 output source rectangle left (also the base the zeroing code addresses through ecx)
.equ src_out_top, 0x12c  # this+0x12c: int32 output source rectangle top
.equ src_out_right, 0x130  # this+0x130: int32 output source rectangle right
.equ src_out_bottom, 0x134  # this+0x134: int32 output source rectangle bottom
.equ dst_out_left, 0x138  # this+0x138: int32 output destination rectangle left (base of the second zeroing group)
.equ dst_out_top, 0x13c  # this+0x13c: int32 output destination rectangle top
.equ dst_out_right, 0x140  # this+0x140: int32 output destination rectangle right
.equ dst_out_bottom, 0x144  # this+0x144: int32 output destination rectangle bottom
.equ src_rect_top, 0x4  # output source rectangle (ecx = this+0x128) +4: top, zeroed
.equ src_rect_right, 0x8  # output source rectangle (ecx = this+0x128) +8: right, zeroed
.equ src_rect_bottom, 0xc  # output source rectangle (ecx = this+0x128) +0xc: bottom, zeroed
.equ dst_rect_top, 0x4  # output destination rectangle (eax = this+0x138) +4: top, zeroed
.equ dst_rect_right, 0x8  # output destination rectangle (eax = this+0x138) +8: right, zeroed
.equ dst_rect_bottom, 0xc  # output destination rectangle (eax = this+0x138) +0xc: bottom, zeroed

# --- external targets -----------------------------------------------

.org 0x0045150e - 0x401000
.globl FUN_0045150e
FUN_0045150e:
    # block 0x0045150e: entry: spill this, rejection test 1: arg_rect right (in_rect_right) <= clip_left (signed) means fully outside, go to L_fully_clipped (jle)
    push ebp                                     # 0045150e
    {load} mov ebp, esp                          # 0045150f
    push ecx                                     # 00451511
    mov dword ptr [ebp - local_this], ecx           # 00451512
    mov eax, dword ptr [ebp + arg_rect]             # 00451515
    mov ecx, dword ptr [ebp - local_this]           # 00451518
    mov edx, dword ptr [eax + in_rect_right]           # 0045151b
    cmp edx, dword ptr [ecx + clip_left]          # 0045151e
    jle.d8 L_fully_clipped                            # 00451521
    # block 0x00451523: rejection test 2: arg_rect left >= clip_right (signed) means fully outside, go to L_fully_clipped (jge)
    mov eax, dword ptr [ebp + arg_rect]             # 00451523
    mov ecx, dword ptr [ebp - local_this]           # 00451526
    mov edx, dword ptr [eax]                     # 00451529
    cmp edx, dword ptr [ecx + clip_right]          # 0045152b
    jge.d8 L_fully_clipped                            # 0045152e
    # block 0x00451530: rejection test 3: arg_rect top >= clip_bottom (signed) means fully outside, go to L_fully_clipped (jge)
    mov eax, dword ptr [ebp + arg_rect]             # 00451530
    mov ecx, dword ptr [ebp - local_this]           # 00451533
    mov edx, dword ptr [eax + in_rect_top]           # 00451536
    cmp edx, dword ptr [ecx + clip_bottom]          # 00451539
    jge.d8 L_fully_clipped                            # 0045153c
    # block 0x0045153e: rejection test 4: arg_rect bottom > clip_top (signed) means the rectangle overlaps, go to L_overlaps (jg), otherwise fall into L_fully_clipped
    mov eax, dword ptr [ebp + arg_rect]             # 0045153e
    mov ecx, dword ptr [ebp - local_this]           # 00451541
    mov edx, dword ptr [eax + in_rect_bottom]           # 00451544
    cmp edx, dword ptr [ecx + clip_top]          # 00451547
    jg.d8 L_overlaps                             # 0045154a
L_fully_clipped:
    # block 0x0045154c: fully outside: zero the four dwords of the output source rectangle at this+0x128 and the four dwords of the output destination rectangle at this+0x138, then return eax = 1
    {load} xor eax, eax                          # 0045154c
    mov ecx, dword ptr [ebp - local_this]           # 0045154e
    add ecx, 0x128                               # 00451551
    mov dword ptr [ecx], eax                     # 00451557
    mov dword ptr [ecx + src_rect_top], eax           # 00451559
    mov dword ptr [ecx + src_rect_right], eax           # 0045155c
    mov dword ptr [ecx + src_rect_bottom], eax           # 0045155f
    {load} xor edx, edx                          # 00451562
    mov eax, dword ptr [ebp - local_this]           # 00451564
    add eax, 0x138                               # 00451567
    mov dword ptr [eax], edx                     # 0045156c
    mov dword ptr [eax + dst_rect_top], edx           # 0045156e
    mov dword ptr [eax + dst_rect_right], edx           # 00451571
    mov dword ptr [eax + dst_rect_bottom], edx           # 00451574
    mov eax, 0x1                                 # 00451577
    jmp.d32 L_epilogue                           # 0045157c
L_overlaps:
    # block 0x00451581: overlap: dst top (dst_out_top) = arg_rect top, src top (src_out_top) = src_full_top (the top edge is not clipped), then compare arg_rect left with clip_left, not below goes to L_left_not_clipped (jge)
    mov ecx, dword ptr [ebp - local_this]           # 00451581
    mov edx, dword ptr [ebp + arg_rect]             # 00451584
    mov eax, dword ptr [edx + in_rect_top]           # 00451587
    mov dword ptr [ecx + dst_out_top], eax         # 0045158a
    mov ecx, dword ptr [ebp - local_this]           # 00451590
    mov edx, dword ptr [ebp - local_this]           # 00451593
    mov eax, dword ptr [edx + src_full_top]         # 00451596
    mov dword ptr [ecx + src_out_top], eax         # 0045159c
    mov ecx, dword ptr [ebp + arg_rect]             # 004515a2
    mov edx, dword ptr [ebp - local_this]           # 004515a5
    mov eax, dword ptr [ecx]                     # 004515a8
    cmp eax, dword ptr [edx + clip_left]          # 004515aa
    jge.d8 L_left_not_clipped                            # 004515ad
    # block 0x004515af: left edge starts outside the window: dst left = clip_left, src left = src_full_left + (clip_left - arg_rect left), jump to L_bottom_check
    mov ecx, dword ptr [ebp - local_this]           # 004515af
    mov edx, dword ptr [ebp - local_this]           # 004515b2
    mov eax, dword ptr [edx + clip_left]          # 004515b5
    mov dword ptr [ecx + dst_out_left], eax         # 004515b8
    mov ecx, dword ptr [ebp - local_this]           # 004515be
    mov edx, dword ptr [ebp + arg_rect]             # 004515c1
    mov eax, dword ptr [ecx + clip_left]          # 004515c4
    sub eax, dword ptr [edx]                     # 004515c7
    mov ecx, dword ptr [ebp - local_this]           # 004515c9
    mov edx, dword ptr [ecx + src_full_left]         # 004515cc
    {load} add edx, eax                          # 004515d2
    mov eax, dword ptr [ebp - local_this]           # 004515d4
    mov dword ptr [eax + src_out_left], edx         # 004515d7
    jmp.d8 L_bottom_check                            # 004515dd
L_left_not_clipped:
    # block 0x004515df: left edge inside: dst left = arg_rect left, src left = src_full_left
    mov ecx, dword ptr [ebp - local_this]           # 004515df
    mov edx, dword ptr [ebp + arg_rect]             # 004515e2
    mov eax, dword ptr [edx]                     # 004515e5
    mov dword ptr [ecx + dst_out_left], eax         # 004515e7
    mov ecx, dword ptr [ebp - local_this]           # 004515ed
    mov edx, dword ptr [ebp - local_this]           # 004515f0
    mov eax, dword ptr [edx + src_full_left]         # 004515f3
    mov dword ptr [ecx + src_out_left], eax         # 004515f9
L_bottom_check:
    # block 0x004515ff: bottom edge: compare arg_rect bottom with clip_bottom, not above goes to L_bottom_not_clipped (jle)
    mov ecx, dword ptr [ebp + arg_rect]             # 004515ff
    mov edx, dword ptr [ebp - local_this]           # 00451602
    mov eax, dword ptr [ecx + in_rect_bottom]           # 00451605
    cmp eax, dword ptr [edx + clip_bottom]          # 00451608
    jle.d8 L_bottom_not_clipped                            # 0045160b
    # block 0x0045160d: bottom edge below the window: dst bottom = clip_bottom, src bottom = src_full_bottom - (arg_rect bottom - clip_bottom), jump to L_right_check
    mov ecx, dword ptr [ebp - local_this]           # 0045160d
    mov edx, dword ptr [ebp - local_this]           # 00451610
    mov eax, dword ptr [edx + clip_bottom]          # 00451613
    mov dword ptr [ecx + dst_out_bottom], eax         # 00451616
    mov ecx, dword ptr [ebp + arg_rect]             # 0045161c
    mov edx, dword ptr [ebp - local_this]           # 0045161f
    mov eax, dword ptr [ecx + in_rect_bottom]           # 00451622
    sub eax, dword ptr [edx + clip_bottom]          # 00451625
    mov ecx, dword ptr [ebp - local_this]           # 00451628
    mov edx, dword ptr [ecx + src_full_bottom]         # 0045162b
    {load} sub edx, eax                          # 00451631
    mov eax, dword ptr [ebp - local_this]           # 00451633
    mov dword ptr [eax + src_out_bottom], edx         # 00451636
    jmp.d8 L_right_check                            # 0045163c
L_bottom_not_clipped:
    # block 0x0045163e: bottom edge inside: dst bottom = arg_rect bottom, src bottom = src_full_bottom
    mov ecx, dword ptr [ebp - local_this]           # 0045163e
    mov edx, dword ptr [ebp + arg_rect]             # 00451641
    mov eax, dword ptr [edx + in_rect_bottom]           # 00451644
    mov dword ptr [ecx + dst_out_bottom], eax         # 00451647
    mov ecx, dword ptr [ebp - local_this]           # 0045164d
    mov edx, dword ptr [ebp - local_this]           # 00451650
    mov eax, dword ptr [edx + src_full_bottom]         # 00451653
    mov dword ptr [ecx + src_out_bottom], eax         # 00451659
L_right_check:
    # block 0x0045165f: right edge: compare arg_rect right with clip_right, not beyond goes to L_right_not_clipped (jle)
    mov ecx, dword ptr [ebp + arg_rect]             # 0045165f
    mov edx, dword ptr [ebp - local_this]           # 00451662
    mov eax, dword ptr [ecx + in_rect_right]           # 00451665
    cmp eax, dword ptr [edx + clip_right]          # 00451668
    jle.d8 L_right_not_clipped                            # 0045166b
    # block 0x0045166d: right edge beyond the window: dst right = clip_right, src right = src_full_right - (arg_rect right - clip_right), jump to L_return_visible
    mov ecx, dword ptr [ebp - local_this]           # 0045166d
    mov edx, dword ptr [ebp - local_this]           # 00451670
    mov eax, dword ptr [edx + clip_right]          # 00451673
    mov dword ptr [ecx + dst_out_right], eax         # 00451676
    mov ecx, dword ptr [ebp + arg_rect]             # 0045167c
    mov edx, dword ptr [ebp - local_this]           # 0045167f
    mov eax, dword ptr [ecx + in_rect_right]           # 00451682
    sub eax, dword ptr [edx + clip_right]          # 00451685
    mov ecx, dword ptr [ebp - local_this]           # 00451688
    mov edx, dword ptr [ecx + src_full_right]         # 0045168b
    {load} sub edx, eax                          # 00451691
    mov eax, dword ptr [ebp - local_this]           # 00451693
    mov dword ptr [eax + src_out_right], edx         # 00451696
    jmp.d8 L_return_visible                            # 0045169c
L_right_not_clipped:
    # block 0x0045169e: right edge inside: dst right = arg_rect right, src right = src_full_right
    mov ecx, dword ptr [ebp - local_this]           # 0045169e
    mov edx, dword ptr [ebp + arg_rect]             # 004516a1
    mov eax, dword ptr [edx + in_rect_right]           # 004516a4
    mov dword ptr [ecx + dst_out_right], eax         # 004516a7
    mov ecx, dword ptr [ebp - local_this]           # 004516ad
    mov edx, dword ptr [ebp - local_this]           # 004516b0
    mov eax, dword ptr [edx + src_full_right]         # 004516b3
    mov dword ptr [ecx + src_out_right], eax         # 004516b9
L_return_visible:
    # block 0x004516bf: visible result: eax = 0 (xor eax, eax)
    {load} xor eax, eax                          # 004516bf
L_epilogue:
    # block 0x004516c1: epilogue: restore the frame and return, popping the one stack argument (ret 4), eax = 0 or 1
    {load} mov esp, ebp                          # 004516c1
    pop ebp                                      # 004516c3
    ret 0x4                                      # 004516c4
