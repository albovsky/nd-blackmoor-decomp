# FUN_004c7481
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c7481
# extent:       0x004c7481-0x004c7623 (418 code bytes)
# span:         0x004c7481-0x004c7623 (code 418, tables 0, padding 0)
# sha256:       c9fafe526715e93f5de672a4340002a5cffbff9e1473ba5de1ae462277a8673d
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# name:         CDisplaySurface::pack_native_pixels_to_rgb555
# arguments:    thiscall: ecx=this (spilled to [ebp-0x3c]), [ebp+8]=pointer to 16-bit pixel words that are rewritten in place, [ebp+0xc]=buffer size in bytes (the word count is size>>1, shr by 1, compared unsigned), callee pops 8 (ret 8), no return value
# locals:       [ebp-4]=current pixel word (low 16 bits valid), [ebp-8]=mid field (becomes bits 5-9), [ebp-0xc]=copy of this+0x38ca (width of the high field), [ebp-0x10]=copy of this+0x38c9 (width of the mid field), [ebp-0x14]=copy of the byte count (never read again), [ebp-0x18]=word index, [ebp-0x1c]=copy of this+0x38c0 (shift of the low field), [ebp-0x20]=copy of this+0x38c8 (width of the low field), [ebp-0x24]=high field (becomes bits 10-14), [ebp-0x28]=copy of this+0x38c1 (shift of the mid field), [ebp-0x2c]=low field (becomes bits 0-4), [ebp-0x30]=copy of the pixel pointer (the one used), [ebp-0x34]=second copy of the pixel pointer (never read again), [ebp-0x38]=copy of this+0x38c2 (shift of the high field), [ebp-0x3c]=saved this
# fields:       this+0x38c0, +0x38c1, +0x38c2: byte right-shift counts that bring the low, mid and high component of a source pixel to bit 0, this+0x38c4, +0x38c5, +0x38c6: byte masks ANDed after the shift (low, mid, high), this+0x38c8, +0x38c9, +0x38ca: component widths of low, mid and high, compared with 5, no globals touched, unlike FUN_004c7314 this routine does not test the enable flag at this+0x38a8
# callees:      none
# track-n:      host-adapter: none
# unverified:   The meaning of the this+0x38xx bytes (right shifts, masks, widths of the display surface pixel format, filled by the setter whose Ghidra pseudocode is 0x4c2e97) is inferred from how they are used here and in the sibling FUN_004c7314, not from the owning class, the class name is provisional and borrowed from the batch 001 name of that sibling, the low/mid/high components are positions in the output word and are not established as blue/green/red. This routine is the inverse direction of FUN_004c7314 (Track N src/cif_pixels.c cif_pixels_convert_555 corresponds to that one, nothing in src corresponds to this one). The width test is an else-if chain verified in the bytes: only the first of high, mid, low whose width byte is not 5 is shifted right by 1, at most one component per pixel, whether the original intends this for 6-bit green is not verified. Bit 15 of the stored word is always 0. The byte count is only shifted, so an odd trailing byte is left untouched, there is no bound check and no null check of the pointer. Shift counts are applied with 16-bit shr, so a count of 16..31 yields 0 and the hardware masks the count to 5 bits. The callers (Ghidra pseudocode of 0x4c334f, 0x4c36b2 and 0x4c3c5d pass width*height*global 0x639895 as the size and write BMP data afterwards) were not re-verified in disassembly and the global was not read.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_pixel, 0x4  # [ebp - 0x4]: current pixel word, low 16 bits valid
.equ local_mid, 0x8  # [ebp - 0x8]: mid field, shifted, masked, then placed at bits 5-9
.equ local_width_hi, 0xc  # [ebp - 0xc]: byte copy of this+0x38ca, width of the high field
.equ local_width_mid, 0x10  # [ebp - 0x10]: byte copy of this+0x38c9, width of the mid field
.equ local_saved_byte_count, 0x14  # [ebp - 0x14]: copy of arg_byte_count, never read again
.equ local_index, 0x18  # [ebp - 0x18]: word index, compared unsigned against byte_count>>1
.equ local_shift_lo, 0x1c  # [ebp - 0x1c]: byte copy of this+0x38c0, right shift of the low field
.equ local_width_lo, 0x20  # [ebp - 0x20]: byte copy of this+0x38c8, width of the low field
.equ local_hi, 0x24  # [ebp - 0x24]: high field, shifted, masked, then placed at bits 10-14
.equ local_shift_mid, 0x28  # [ebp - 0x28]: byte copy of this+0x38c1, right shift of the mid field
.equ local_lo, 0x2c  # [ebp - 0x2c]: low field, shifted, masked, then placed at bits 0-4
.equ local_pixels, 0x30  # [ebp - 0x30]: copy of arg_pixels, the pointer actually used
.equ local_saved_pixels, 0x34  # [ebp - 0x34]: second copy of arg_pixels, never read again
.equ local_shift_hi, 0x38  # [ebp - 0x38]: byte copy of this+0x38c2, right shift of the high field
.equ local_saved_this, 0x3c  # [ebp - 0x3c]: this, spilled from ecx
.equ arg_pixels, 0x8  # [ebp + 0x8]: pointer to the 16-bit pixel words, rewritten in place
.equ arg_byte_count, 0xc  # [ebp + 0xc]: buffer size in bytes, the loop runs byte_count>>1 times

.equ this_shift_lo, 0x38c0  # this+0x38c0: byte, right shift that brings the low component to bit 0
.equ this_shift_mid, 0x38c1  # this+0x38c1: byte, right shift that brings the mid component to bit 0
.equ this_shift_hi, 0x38c2  # this+0x38c2: byte, right shift that brings the high component to bit 0
.equ this_mask_lo, 0x38c4  # this+0x38c4: byte mask ANDed with the shifted low component
.equ this_mask_mid, 0x38c5  # this+0x38c5: byte mask ANDed with the shifted mid component
.equ this_mask_hi, 0x38c6  # this+0x38c6: byte mask ANDed with the shifted high component
.equ this_width_lo, 0x38c8  # this+0x38c8: byte, width of the low component, compared with 5
.equ this_width_mid, 0x38c9  # this+0x38c9: byte, width of the mid component, compared with 5
.equ this_width_hi, 0x38ca  # this+0x38ca: byte, width of the high component, compared with 5

# --- external targets -----------------------------------------------

.org 0x004c7481 - 0x401000
.globl FUN_004c7481
FUN_004c7481:
    # block 0x004c7481: entry: build a 0x3c-byte frame, spill this, copy the pixel pointer and byte count into locals (second copies are never read), copy the shift bytes this+0x38c2, 0x38c1, 0x38c0 and the width bytes this+0x38ca, 0x38c9, 0x38c8 into locals, index = 0, jump to L_loop_test
    push ebp                                     # 004c7481
    {load} mov ebp, esp                          # 004c7482
    sub esp, 0x3c                                # 004c7484
    mov dword ptr [ebp - local_saved_this], ecx          # 004c7487
    mov eax, dword ptr [ebp + arg_pixels]             # 004c748a
    mov dword ptr [ebp - local_pixels], eax          # 004c748d
    mov ecx, dword ptr [ebp + arg_byte_count]             # 004c7490
    mov dword ptr [ebp - local_saved_byte_count], ecx          # 004c7493
    mov edx, dword ptr [ebp + arg_pixels]             # 004c7496
    mov dword ptr [ebp - local_saved_pixels], edx          # 004c7499
    mov eax, dword ptr [ebp - local_saved_this]          # 004c749c
    mov cl, byte ptr [eax + this_shift_hi]          # 004c749f
    mov byte ptr [ebp - local_shift_hi], cl            # 004c74a5
    mov edx, dword ptr [ebp - local_saved_this]          # 004c74a8
    mov al, byte ptr [edx + this_shift_mid]          # 004c74ab
    mov byte ptr [ebp - local_shift_mid], al            # 004c74b1
    mov ecx, dword ptr [ebp - local_saved_this]          # 004c74b4
    mov dl, byte ptr [ecx + this_shift_lo]          # 004c74b7
    mov byte ptr [ebp - local_shift_lo], dl            # 004c74bd
    mov eax, dword ptr [ebp - local_saved_this]          # 004c74c0
    mov cl, byte ptr [eax + this_width_hi]          # 004c74c3
    mov byte ptr [ebp - local_width_hi], cl             # 004c74c9
    mov edx, dword ptr [ebp - local_saved_this]          # 004c74cc
    mov al, byte ptr [edx + this_width_mid]          # 004c74cf
    mov byte ptr [ebp - local_width_mid], al            # 004c74d5
    mov ecx, dword ptr [ebp - local_saved_this]          # 004c74d8
    mov dl, byte ptr [ecx + this_width_lo]          # 004c74db
    mov byte ptr [ebp - local_width_lo], dl            # 004c74e1
    mov dword ptr [ebp - local_index], 0x0          # 004c74e4
    jmp.d8 L_loop_test                            # 004c74eb
L_loop_next:
    # block 0x004c74ed: next word: index = index + 1
    mov eax, dword ptr [ebp - local_index]          # 004c74ed
    add eax, 0x1                                 # 004c74f0
    mov dword ptr [ebp - local_index], eax          # 004c74f3
L_loop_test:
    # block 0x004c74f6: loop test: if index >= byte_count>>1 (unsigned, shr by 1) leave through L_done
    mov ecx, dword ptr [ebp + arg_byte_count]             # 004c74f6
    shr ecx                                      # 004c74f9
    cmp dword ptr [ebp - local_index], ecx          # 004c74fb
    jae.d32 L_done                           # 004c74fe
    # block 0x004c7504: load the word pixels[index], make three copies (hi, mid, lo), shift each right by its shift byte (16-bit shr), AND each with its mask byte from this+0x38c6, 0x38c5, 0x38c4, then test the high width byte against 5 and jump to L_hi_width_is_5 when equal
    mov edx, dword ptr [ebp - local_index]          # 004c7504
    mov eax, dword ptr [ebp - local_pixels]          # 004c7507
    mov cx, word ptr [eax + 2*edx]               # 004c750a
    mov word ptr [ebp - local_pixel], cx             # 004c750e
    mov dx, word ptr [ebp - local_pixel]             # 004c7512
    mov word ptr [ebp - local_lo], dx            # 004c7516
    mov ax, word ptr [ebp - local_lo]            # 004c751a
    mov word ptr [ebp - local_mid], ax             # 004c751e
    mov cx, word ptr [ebp - local_mid]             # 004c7522
    mov word ptr [ebp - local_hi], cx            # 004c7526
    movzx cx, byte ptr [ebp - local_shift_hi]          # 004c752a
    mov dx, word ptr [ebp - local_hi]            # 004c752f
    shr dx, cl                                   # 004c7533
    mov word ptr [ebp - local_hi], dx            # 004c7536
    movzx cx, byte ptr [ebp - local_shift_mid]          # 004c753a
    mov ax, word ptr [ebp - local_mid]             # 004c753f
    shr ax, cl                                   # 004c7543
    mov word ptr [ebp - local_mid], ax             # 004c7546
    movzx cx, byte ptr [ebp - local_shift_lo]          # 004c754a
    mov dx, word ptr [ebp - local_lo]            # 004c754f
    shr dx, cl                                   # 004c7553
    mov word ptr [ebp - local_lo], dx            # 004c7556
    mov eax, dword ptr [ebp - local_saved_this]          # 004c755a
    movzx cx, byte ptr [eax + this_mask_hi]        # 004c755d
    mov dx, word ptr [ebp - local_hi]            # 004c7565
    {load} and dx, cx                            # 004c7569
    mov word ptr [ebp - local_hi], dx            # 004c756c
    mov eax, dword ptr [ebp - local_saved_this]          # 004c7570
    movzx cx, byte ptr [eax + this_mask_mid]        # 004c7573
    mov dx, word ptr [ebp - local_mid]             # 004c757b
    {load} and dx, cx                            # 004c757f
    mov word ptr [ebp - local_mid], dx             # 004c7582
    mov eax, dword ptr [ebp - local_saved_this]          # 004c7586
    movzx cx, byte ptr [eax + this_mask_lo]        # 004c7589
    mov dx, word ptr [ebp - local_lo]            # 004c7591
    {load} and dx, cx                            # 004c7595
    mov word ptr [ebp - local_lo], dx            # 004c7598
    mov eax, dword ptr [ebp - local_width_hi]           # 004c759c
    and eax, 0xff                                # 004c759f
    cmp eax, 0x5                                 # 004c75a4
    je.d8 L_hi_width_is_5                             # 004c75a7
    # block 0x004c75a9: high width is not 5: hi = hi >> 1, jump to L_pack_word
    mov cx, word ptr [ebp - local_hi]            # 004c75a9
    shr cx                                       # 004c75ad
    mov word ptr [ebp - local_hi], cx            # 004c75b0
    jmp.d8 L_pack_word                            # 004c75b4
L_hi_width_is_5:
    # block 0x004c75b6: high width is 5: test the mid width byte against 5 and jump to L_mid_width_is_5 when equal
    mov edx, dword ptr [ebp - local_width_mid]          # 004c75b6
    and edx, 0xff                                # 004c75b9
    cmp edx, 0x5                                 # 004c75bf
    je.d8 L_mid_width_is_5                             # 004c75c2
    # block 0x004c75c4: mid width is not 5: mid = mid >> 1, jump to L_pack_word
    mov ax, word ptr [ebp - local_mid]             # 004c75c4
    shr ax                                       # 004c75c8
    mov word ptr [ebp - local_mid], ax             # 004c75cb
    jmp.d8 L_pack_word                            # 004c75cf
L_mid_width_is_5:
    # block 0x004c75d1: high and mid widths are 5: test the low width byte against 5 and jump to L_pack_word when equal
    mov ecx, dword ptr [ebp - local_width_lo]          # 004c75d1
    and ecx, 0xff                                # 004c75d4
    cmp ecx, 0x5                                 # 004c75da
    je.d8 L_pack_word                             # 004c75dd
    # block 0x004c75df: low width is not 5: lo = lo >> 1 (the only field halved when both other widths are 5)
    mov dx, word ptr [ebp - local_lo]            # 004c75df
    shr dx                                       # 004c75e3
    mov word ptr [ebp - local_lo], dx            # 004c75e6
L_pack_word:
    # block 0x004c75ea: pack: (hi & 0xffff) << 10 | (mid & 0xffff) << 5 | (lo & 0xffff), store the low word back to pixels[index], jump to L_loop_next
    mov eax, dword ptr [ebp - local_hi]          # 004c75ea
    and eax, 0xffff                              # 004c75ed
    shl eax, 0xa                                 # 004c75f2
    mov ecx, dword ptr [ebp - local_mid]           # 004c75f5
    and ecx, 0xffff                              # 004c75f8
    shl ecx, 0x5                                 # 004c75fe
    {load} or eax, ecx                           # 004c7601
    mov edx, dword ptr [ebp - local_lo]          # 004c7603
    and edx, 0xffff                              # 004c7606
    {load} or eax, edx                           # 004c760c
    mov ecx, dword ptr [ebp - local_index]          # 004c760e
    mov edx, dword ptr [ebp - local_pixels]          # 004c7611
    mov word ptr [edx + 2*ecx], ax               # 004c7614
    jmp.d32 L_loop_next                           # 004c7618
L_done:
    # block 0x004c761d: epilogue: restore the frame and return, popping the two stack arguments (ret 8)
    {load} mov esp, ebp                          # 004c761d
    pop ebp                                      # 004c761f
    ret 0x8                                      # 004c7620
