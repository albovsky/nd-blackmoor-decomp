# FUN_004c7314
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c7314
# extent:       0x004c7314-0x004c7481 (365 code bytes)
# span:         0x004c7314-0x004c7481 (code 365, tables 0, padding 0)
# sha256:       520d88bc2e141db4903db273c16a89f49a9ed134cfea83ff737e8d8648747906
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# name:         CDisplaySurface::repack_rgb555_pixels
# arguments:    thiscall: ecx=this (spilled to a frame slot); [ebp+8]=arg_pixels pointer to 16-bit pixel words converted in place; [ebp+0xc]=arg_byte_count buffer size in bytes (word count is byte_count>>1, unsigned shift); callee pops 8 (ret 8); no return value
# locals:       [ebp-4]=current pixel word (low 16 bits valid); [ebp-8]=mid field (bits 5-9) ; [ebp-0xc]=copy of this+0x38ca; [ebp-0x10]=copy of this+0x38c9; [ebp-0x14]=copy of arg_byte_count (unused afterwards); [ebp-0x18]=word index; [ebp-0x1c]=copy of this+0x38c0; [ebp-0x20]=copy of this+0x38c8; [ebp-0x24]=high field (bits 10-14); [ebp-0x28]=copy of this+0x38c1; [ebp-0x2c]=low field (bits 0-4); [ebp-0x30]=copy of arg_pixels pointer; [ebp-0x34]=second copy of arg_pixels (unused afterwards); [ebp-0x38]=copy of this+0x38c2; [ebp-0x3c]=saved this
# fields:       this+0x38a8: dword enable flag (zero means do nothing); this+0x38c0, +0x38c1, +0x38c2: output bit positions (left shift counts) of the low, mid and high fields; this+0x38c8, +0x38c9, +0x38ca: widths of the low, mid and high fields (doubling is an else-if chain: the first of high, mid, low whose width byte is not 5 is shifted left by 1, so at most one field per word is doubled)
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/cif_pixels.c:cif_pixels_convert_555
# unverified:   the semantic meaning of the this+0x38xx fields (output shift counts and field widths of the display surface mask description) is inferred from how they are used, not from the owning class definition; the class name is a provisional role name; the else-if chain doubles at most one field per call (high first, then mid, then low) and the bytes show that precedence, but whether the original intends 6-bit green is not verified; no bound check beyond the byte count; odd trailing byte of arg_byte_count is left untouched
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_pixel, 0x4  # [ebp - 0x4]
.equ local_mid, 0x8  # [ebp - 0x8]
.equ local_width_hi, 0xc  # [ebp - 0xc]
.equ local_width_mid, 0x10  # [ebp - 0x10]
.equ local_saved_byte_count, 0x14  # [ebp - 0x14]
.equ local_index, 0x18  # [ebp - 0x18]
.equ local_shift_lo, 0x1c  # [ebp - 0x1c]
.equ local_width_lo, 0x20  # [ebp - 0x20]
.equ local_hi, 0x24  # [ebp - 0x24]
.equ local_shift_mid, 0x28  # [ebp - 0x28]
.equ local_lo, 0x2c  # [ebp - 0x2c]
.equ local_pixels, 0x30  # [ebp - 0x30]
.equ local_saved_pixels, 0x34  # [ebp - 0x34]
.equ local_shift_hi, 0x38  # [ebp - 0x38]
.equ local_saved_this, 0x3c  # [ebp - 0x3c]
.equ arg_pixels, 0x8  # [ebp + 0x8]
.equ arg_byte_count, 0xc  # [ebp + 0xc]

# --- external targets -----------------------------------------------

.org 0x004c7314 - 0x401000
.globl FUN_004c7314
FUN_004c7314:
    # block 0x004c7314: function entry: build frame, spill this, test this+0x38a8 and continue to L_enabled when nonzero
    push ebp                                     # 004c7314
    {load} mov ebp, esp                          # 004c7315
    sub esp, 0x3c                                # 004c7317
    mov dword ptr [ebp - local_saved_this], ecx          # 004c731a
    mov eax, dword ptr [ebp - local_saved_this]          # 004c731d
    cmp dword ptr [eax + 0x38a8], 0x0            # 004c7320
    jne.d8 L_enabled                            # 004c7327
    # block 0x004c7329: enable flag is zero: jump to L_return, buffer untouched
    jmp.d32 L_return                           # 004c7329
L_enabled:
    # block 0x004c732e: L_enabled: copy arg_pixels and arg_byte_count to locals; load the three shift bytes from this+0x38c2/38c1/38c0 and the three width bytes from this+0x38ca/38c9/38c8; word index = 0; jump to the loop test
    mov ecx, dword ptr [ebp + arg_pixels]             # 004c732e
    mov dword ptr [ebp - local_pixels], ecx          # 004c7331
    mov edx, dword ptr [ebp + arg_byte_count]             # 004c7334
    mov dword ptr [ebp - local_saved_byte_count], edx          # 004c7337
    mov eax, dword ptr [ebp + arg_pixels]             # 004c733a
    mov dword ptr [ebp - local_saved_pixels], eax          # 004c733d
    mov ecx, dword ptr [ebp - local_saved_this]          # 004c7340
    mov dl, byte ptr [ecx + 0x38c2]              # 004c7343
    mov byte ptr [ebp - local_shift_hi], dl            # 004c7349
    mov eax, dword ptr [ebp - local_saved_this]          # 004c734c
    mov cl, byte ptr [eax + 0x38c1]              # 004c734f
    mov byte ptr [ebp - local_shift_mid], cl            # 004c7355
    mov edx, dword ptr [ebp - local_saved_this]          # 004c7358
    mov al, byte ptr [edx + 0x38c0]              # 004c735b
    mov byte ptr [ebp - local_shift_lo], al            # 004c7361
    mov ecx, dword ptr [ebp - local_saved_this]          # 004c7364
    mov dl, byte ptr [ecx + 0x38ca]              # 004c7367
    mov byte ptr [ebp - local_width_hi], dl             # 004c736d
    mov eax, dword ptr [ebp - local_saved_this]          # 004c7370
    mov cl, byte ptr [eax + 0x38c9]              # 004c7373
    mov byte ptr [ebp - local_width_mid], cl            # 004c7379
    mov edx, dword ptr [ebp - local_saved_this]          # 004c737c
    mov al, byte ptr [edx + 0x38c8]              # 004c737f
    mov byte ptr [ebp - local_width_lo], al            # 004c7385
    mov dword ptr [ebp - local_index], 0x0          # 004c7388
    jmp.d8 L_loop_test                            # 004c738f
L_next_word:
    # block 0x004c7391: L_next_word: increment the word index
    mov ecx, dword ptr [ebp - local_index]          # 004c7391
    add ecx, 0x1                                 # 004c7394
    mov dword ptr [ebp - local_index], ecx          # 004c7397
L_loop_test:
    # block 0x004c739a: L_loop_test: unsigned compare index with byte_count >> 1; index >= count ends at L_return
    mov edx, dword ptr [ebp + arg_byte_count]             # 004c739a
    shr edx                                      # 004c739d
    cmp dword ptr [ebp - local_index], edx          # 004c739f
    jae.d32 L_return                           # 004c73a2
    # block 0x004c73a8: loop body: load the 16-bit word, split it into hi = bits 10-14, mid = bits 5-9, lo = bits 0-4; if the high width byte is not 5 fall to the hi doubling, else go to L_check_mid_width
    mov eax, dword ptr [ebp - local_index]          # 004c73a8
    mov ecx, dword ptr [ebp - local_pixels]          # 004c73ab
    mov dx, word ptr [ecx + 2*eax]               # 004c73ae
    mov word ptr [ebp - local_pixel], dx             # 004c73b2
    mov eax, dword ptr [ebp - local_pixel]           # 004c73b6
    and eax, 0xffff                              # 004c73b9
    sar eax, 0xa                                 # 004c73be
    and eax, 0x1f                                # 004c73c1
    mov byte ptr [ebp - local_hi], al            # 004c73c4
    mov ecx, dword ptr [ebp - local_pixel]           # 004c73c7
    and ecx, 0xffff                              # 004c73ca
    sar ecx, 0x5                                 # 004c73d0
    and ecx, 0x1f                                # 004c73d3
    mov byte ptr [ebp - local_mid], cl             # 004c73d6
    mov edx, dword ptr [ebp - local_pixel]           # 004c73d9
    and edx, 0xffff                              # 004c73dc
    and edx, 0x1f                                # 004c73e2
    mov byte ptr [ebp - local_lo], dl            # 004c73e5
    mov eax, dword ptr [ebp - local_width_hi]           # 004c73e8
    and eax, 0xff                                # 004c73eb
    cmp eax, 0x5                                 # 004c73f0
    je.d8 L_check_mid_width                             # 004c73f3
    # block 0x004c73f5: high width != 5: double the high field (shl by 1), then go to L_repack
    mov cl, byte ptr [ebp - local_hi]            # 004c73f5
    shl cl                                       # 004c73f8
    mov byte ptr [ebp - local_hi], cl            # 004c73fa
    jmp.d8 L_repack                            # 004c73fd
L_check_mid_width:
    # block 0x004c73ff: L_check_mid_width: if the mid width byte is not 5 double the mid field and go to L_repack, otherwise go on to L_check_lo_width
    mov edx, dword ptr [ebp - local_width_mid]          # 004c73ff
    and edx, 0xff                                # 004c7402
    cmp edx, 0x5                                 # 004c7408
    je.d8 L_check_lo_width                             # 004c740b
    # block 0x004c740d: mid width != 5: double the mid field (shl by 1), then go to L_repack
    mov al, byte ptr [ebp - local_mid]             # 004c740d
    shl al                                       # 004c7410
    mov byte ptr [ebp - local_mid], al             # 004c7412
    jmp.d8 L_repack                            # 004c7415
L_check_lo_width:
    # block 0x004c7417: L_check_lo_width: if the low width byte equals 5 go to L_repack unchanged
    mov ecx, dword ptr [ebp - local_width_lo]          # 004c7417
    and ecx, 0xff                                # 004c741a
    cmp ecx, 0x5                                 # 004c7420
    je.d8 L_repack                             # 004c7423
    # block 0x004c7425: low width != 5: double the low field (shl by 1)
    mov dl, byte ptr [ebp - local_lo]            # 004c7425
    shl dl                                       # 004c7428
    mov byte ptr [ebp - local_lo], dl            # 004c742a
L_repack:
    # block 0x004c742d: L_repack: word = (hi << shift_hi) | (mid << shift_mid) | (lo << shift_lo); store the low 16 bits back in place; loop to L_next_word
    mov eax, dword ptr [ebp - local_hi]          # 004c742d
    and eax, 0xff                                # 004c7430
    mov ecx, dword ptr [ebp - local_shift_hi]          # 004c7435
    and ecx, 0xff                                # 004c7438
    shl eax, cl                                  # 004c743e
    mov edx, dword ptr [ebp - local_mid]           # 004c7440
    and edx, 0xff                                # 004c7443
    mov ecx, dword ptr [ebp - local_shift_mid]          # 004c7449
    and ecx, 0xff                                # 004c744c
    shl edx, cl                                  # 004c7452
    {load} or eax, edx                           # 004c7454
    mov edx, dword ptr [ebp - local_lo]          # 004c7456
    and edx, 0xff                                # 004c7459
    mov ecx, dword ptr [ebp - local_shift_lo]          # 004c745f
    and ecx, 0xff                                # 004c7462
    shl edx, cl                                  # 004c7468
    {load} or eax, edx                           # 004c746a
    mov ecx, dword ptr [ebp - local_index]          # 004c746c
    mov edx, dword ptr [ebp - local_pixels]          # 004c746f
    mov word ptr [edx + 2*ecx], ax               # 004c7472
    jmp.d32 L_next_word                           # 004c7476
L_return:
    # block 0x004c747b: L_return: tear down the frame, ret 8
    {load} mov esp, ebp                          # 004c747b
    pop ebp                                      # 004c747d
    ret 0x8                                      # 004c747e
