# FUN_0041b6e2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041b6e2
# extent:       0x0041b6e2-0x0041b925 (579 code bytes)
# span:         0x0041b6e2-0x0041b925 (code 579, tables 0, padding 0)
# sha256:       8bbf62784b5ec05fb5d4fb11ea2b1170aa6f7777124604f1b9d03c0f7b87b079
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# name:         cif_decode_stream
# arguments:    thiscall-style: ecx=this (spilled, never read); [ebp+8]=arg_in compressed bytes; [ebp+0xc]=arg_out destination buffer; [ebp+0x10]=arg_in_len input byte count; [ebp+0x14]=fourth stack slot used as the running output position, overwritten with 0 at entry (its incoming value is discarded); callee pops 0x10; no explicit return value
# locals:       [ebp-4]=flag word (shifted right each token, 0xff00|byte when reloaded); [ebp-8]=ring write cursor, starts 0xfee; [ebp-0xc]=constant 0x12 used to size the ring clear; [ebp-0x10]=byte counter subtracted from every input byte, starts 0; [ebp-0x14]=ring base pointer constant 0x0056f354; [ebp-0x18]=constant 2 (length bias); [ebp-0x1c]=input index, starts -1; [ebp-0x20]=current decoded byte (dword slot, low byte used); [ebp-0x24]=match source offset (12 bits); [ebp-0x28]=match copy count minus one (low nibble + 2); [ebp-0x2c]=ring size constant 0x1000; [ebp-0x30]=match copy loop index; [ebp-0x34]=saved ecx (this, unused)
# fields:       0x0056f354: 4096-byte LZ dictionary ring (global); bytes 0..0xfed are filled with 0x20 on every call by rep stosd/stosb, bytes 0xfee..0xfff are left as the previous call left them
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/cif_archive.c:cif_decode
# unverified:   whether any caller reads the arg_out_pos slot after the call is not checked here (the slot is popped by ret 0x10 and is written as the output length counter); the original has no output bound (writes arg_out unchecked), an unsafe behaviour that Track N replaces by a native rejection; end-of-input is detected only by input index equality with arg_in_len, so a stream that ends mid token simply returns (Track N reports it as malformed); ecx/this is spilled but unused so its meaning is not verified; the loop count of the literal/match paths was checked from the bytes but the compressor side is not recovered
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_flags, 0x4  # [ebp - 0x4]
.equ local_ring_write, 0x8  # [ebp - 0x8]
.equ local_ring_reserve, 0xc  # [ebp - 0xc]
.equ local_counter, 0x10  # [ebp - 0x10]
.equ local_ring_base, 0x14  # [ebp - 0x14]
.equ local_len_bias, 0x18  # [ebp - 0x18]
.equ local_in_index, 0x1c  # [ebp - 0x1c]
.equ local_byte, 0x20  # [ebp - 0x20]
.equ local_match_offset, 0x24  # [ebp - 0x24]
.equ local_match_count, 0x28  # [ebp - 0x28]
.equ local_ring_size, 0x2c  # [ebp - 0x2c]
.equ local_copy_index, 0x30  # [ebp - 0x30]
.equ local_saved_this, 0x34  # [ebp - 0x34]
.equ arg_in, 0x8  # [ebp + 0x8]
.equ arg_out, 0xc  # [ebp + 0xc]
.equ arg_in_len, 0x10  # [ebp + 0x10]
.equ arg_out_pos, 0x14  # [ebp + 0x14]

# --- external targets -----------------------------------------------

.org 0x0041b6e2 - 0x401000
.globl FUN_0041b6e2
FUN_0041b6e2:
    # block 0x0041b6e2: function entry: build frame; zero counter and arg_out_pos; set in_index -1, ring base 0x56f354, ring size 0x1000, reserve 0x12, bias 2; fill the first 0x1000-0x12 ring bytes with 0x20 (rep stosd then rep stosb); ring write cursor = 0xfee, flags = 0
    push ebp                                     # 0041b6e2
    {load} mov ebp, esp                          # 0041b6e3
    sub esp, 0x34                                # 0041b6e5
    push edi                                     # 0041b6e8
    mov dword ptr [ebp - local_saved_this], ecx          # 0041b6e9
    mov byte ptr [ebp - local_counter], 0x0           # 0041b6ec
    mov dword ptr [ebp + arg_out_pos], 0x0            # 0041b6f0
    mov dword ptr [ebp - local_in_index], 0xffffffff   # 0041b6f7
    mov dword ptr [ebp - local_ring_base], 0x56f354     # 0041b6fe
    mov dword ptr [ebp - local_ring_size], 0x1000       # 0041b705
    mov dword ptr [ebp - local_ring_reserve], 0x12          # 0041b70c
    mov dword ptr [ebp - local_len_bias], 0x2          # 0041b713
    mov ecx, dword ptr [ebp - local_ring_size]          # 0041b71a
    sub ecx, dword ptr [ebp - local_ring_reserve]           # 0041b71d
    mov eax, 0x20202020                          # 0041b720
    mov edi, dword ptr [ebp - local_ring_base]          # 0041b725
    {load} mov edx, ecx                          # 0041b728
    shr ecx, 0x2                                 # 0041b72a
    rep stosd dword ptr es:[edi], eax            # 0041b72d
    {load} mov ecx, edx                          # 0041b72f
    and ecx, 0x3                                 # 0041b731
    rep stosb byte ptr es:[edi], al              # 0041b734
    mov eax, dword ptr [ebp - local_ring_size]          # 0041b736
    sub eax, dword ptr [ebp - local_ring_reserve]           # 0041b739
    mov dword ptr [ebp - local_ring_write], eax           # 0041b73c
    mov dword ptr [ebp - local_flags], 0x0           # 0041b73f
L_next_flag_bit:
    # block 0x0041b746: L_next_flag_bit: shift flags right one bit; if bit 8 (0x100) is still set, the current flag byte has bits left, jump to L_test_literal
    mov ecx, dword ptr [ebp - local_flags]           # 0041b746
    shr ecx                                      # 0041b749
    mov dword ptr [ebp - local_flags], ecx           # 0041b74b
    mov edx, dword ptr [ebp - local_flags]           # 0041b74e
    and edx, 0x100                               # 0041b751
    test edx, edx                                # 0041b757
    jne.d8 L_test_literal                            # 0041b759
    # block 0x0041b75b: flags exhausted: advance in_index and compare with arg_in_len; equal means end of input
    mov eax, dword ptr [ebp - local_in_index]          # 0041b75b
    add eax, 0x1                                 # 0041b75e
    mov dword ptr [ebp - local_in_index], eax          # 0041b761
    mov ecx, dword ptr [ebp - local_in_index]          # 0041b764
    cmp ecx, dword ptr [ebp + arg_in_len]            # 0041b767
    jne.d8 L_flag_read_byte                            # 0041b76a
    # block 0x0041b76c: end of input while reading a flag byte: jump to L_return
    jmp.d32 L_return                           # 0041b76c
L_flag_read_byte:
    # block 0x0041b771: L_flag_read_byte: read arg_in[in_index], subtract the running counter, increment the counter, and set flags = 0xff00 | decoded byte
    mov edx, dword ptr [ebp + arg_in]             # 0041b771
    add edx, dword ptr [ebp - local_in_index]          # 0041b774
    mov al, byte ptr [edx]                       # 0041b777
    mov byte ptr [ebp - local_byte], al            # 0041b779
    mov cl, byte ptr [ebp - local_byte]            # 0041b77c
    sub cl, byte ptr [ebp - local_counter]            # 0041b77f
    mov byte ptr [ebp - local_byte], cl            # 0041b782
    mov dl, byte ptr [ebp - local_counter]            # 0041b785
    add dl, 0x1                                  # 0041b788
    mov byte ptr [ebp - local_counter], dl            # 0041b78b
    mov eax, dword ptr [ebp - local_byte]          # 0041b78e
    and eax, 0xff                                # 0041b791
    or ah, -0x1                                  # 0041b796
    mov dword ptr [ebp - local_flags], eax           # 0041b799
L_test_literal:
    # block 0x0041b79c: L_test_literal: test flag bit 0; zero means a two-byte back reference (L_match_start), one means a literal byte
    mov ecx, dword ptr [ebp - local_flags]           # 0041b79c
    and ecx, 0x1                                 # 0041b79f
    test ecx, ecx                                # 0041b7a2
    je.d8 L_match_start                             # 0041b7a4
    # block 0x0041b7a6: literal path: advance in_index and compare with arg_in_len
    mov edx, dword ptr [ebp - local_in_index]          # 0041b7a6
    add edx, 0x1                                 # 0041b7a9
    mov dword ptr [ebp - local_in_index], edx          # 0041b7ac
    mov eax, dword ptr [ebp - local_in_index]          # 0041b7af
    cmp eax, dword ptr [ebp + arg_in_len]            # 0041b7b2
    jne.d8 L_literal_read                            # 0041b7b5
    # block 0x0041b7b7: end of input at literal: jump to L_return
    jmp.d32 L_return                           # 0041b7b7
L_literal_read:
    # block 0x0041b7bc: L_literal_read: decode arg_in[in_index] (minus counter, counter++), store it to arg_out[arg_out_pos++] and to ring[ring_write++], wrap ring_write with and 0xfff, jump to L_main_loop
    mov ecx, dword ptr [ebp + arg_in]             # 0041b7bc
    add ecx, dword ptr [ebp - local_in_index]          # 0041b7bf
    mov dl, byte ptr [ecx]                       # 0041b7c2
    mov byte ptr [ebp - local_byte], dl            # 0041b7c4
    mov al, byte ptr [ebp - local_byte]            # 0041b7c7
    sub al, byte ptr [ebp - local_counter]            # 0041b7ca
    mov byte ptr [ebp - local_byte], al            # 0041b7cd
    mov cl, byte ptr [ebp - local_counter]            # 0041b7d0
    add cl, 0x1                                  # 0041b7d3
    mov byte ptr [ebp - local_counter], cl            # 0041b7d6
    mov edx, dword ptr [ebp + arg_out]             # 0041b7d9
    add edx, dword ptr [ebp + arg_out_pos]            # 0041b7dc
    mov al, byte ptr [ebp - local_byte]            # 0041b7df
    mov byte ptr [edx], al                       # 0041b7e2
    mov ecx, dword ptr [ebp + arg_out_pos]            # 0041b7e4
    add ecx, 0x1                                 # 0041b7e7
    mov dword ptr [ebp + arg_out_pos], ecx            # 0041b7ea
    mov edx, dword ptr [ebp - local_ring_base]          # 0041b7ed
    add edx, dword ptr [ebp - local_ring_write]           # 0041b7f0
    mov al, byte ptr [ebp - local_byte]            # 0041b7f3
    mov byte ptr [edx], al                       # 0041b7f6
    mov ecx, dword ptr [ebp - local_ring_write]           # 0041b7f8
    add ecx, 0x1                                 # 0041b7fb
    mov dword ptr [ebp - local_ring_write], ecx           # 0041b7fe
    mov edx, dword ptr [ebp - local_ring_size]          # 0041b801
    sub edx, 0x1                                 # 0041b804
    mov eax, dword ptr [ebp - local_ring_write]           # 0041b807
    {load} and eax, edx                          # 0041b80a
    mov dword ptr [ebp - local_ring_write], eax           # 0041b80c
    jmp.d32 L_main_loop                           # 0041b80f
L_match_start:
    # block 0x0041b814: L_match_start: back reference, advance in_index and compare with arg_in_len
    mov ecx, dword ptr [ebp - local_in_index]          # 0041b814
    add ecx, 0x1                                 # 0041b817
    mov dword ptr [ebp - local_in_index], ecx          # 0041b81a
    mov edx, dword ptr [ebp - local_in_index]          # 0041b81d
    cmp edx, dword ptr [ebp + arg_in_len]            # 0041b820
    jne.d8 L_match_read_low                            # 0041b823
    # block 0x0041b825: end of input before the first reference byte: jump to L_return
    jmp.d32 L_return                           # 0041b825
L_match_read_low:
    # block 0x0041b82a: L_match_read_low: decode the first reference byte (minus counter, counter++) into match_offset, advance in_index and compare with arg_in_len
    mov eax, dword ptr [ebp + arg_in]             # 0041b82a
    add eax, dword ptr [ebp - local_in_index]          # 0041b82d
    mov cl, byte ptr [eax]                       # 0041b830
    mov byte ptr [ebp - local_byte], cl            # 0041b832
    mov dl, byte ptr [ebp - local_byte]            # 0041b835
    sub dl, byte ptr [ebp - local_counter]            # 0041b838
    mov byte ptr [ebp - local_byte], dl            # 0041b83b
    mov al, byte ptr [ebp - local_counter]            # 0041b83e
    add al, 0x1                                  # 0041b841
    mov byte ptr [ebp - local_counter], al            # 0041b843
    mov ecx, dword ptr [ebp - local_byte]          # 0041b846
    and ecx, 0xff                                # 0041b849
    mov dword ptr [ebp - local_match_offset], ecx          # 0041b84f
    mov edx, dword ptr [ebp - local_in_index]          # 0041b852
    add edx, 0x1                                 # 0041b855
    mov dword ptr [ebp - local_in_index], edx          # 0041b858
    mov eax, dword ptr [ebp - local_in_index]          # 0041b85b
    cmp eax, dword ptr [ebp + arg_in_len]            # 0041b85e
    jne.d8 L_match_read_high                            # 0041b861
    # block 0x0041b863: end of input between the two reference bytes: jump to L_return
    jmp.d32 L_return                           # 0041b863
L_match_read_high:
    # block 0x0041b868: L_match_read_high: decode the second byte, match_offset |= (b & 0xf0) << 4, match_count = (b & 0xf) + 2, copy_index = 0
    mov ecx, dword ptr [ebp + arg_in]             # 0041b868
    add ecx, dword ptr [ebp - local_in_index]          # 0041b86b
    mov dl, byte ptr [ecx]                       # 0041b86e
    mov byte ptr [ebp - local_byte], dl            # 0041b870
    mov al, byte ptr [ebp - local_byte]            # 0041b873
    sub al, byte ptr [ebp - local_counter]            # 0041b876
    mov byte ptr [ebp - local_byte], al            # 0041b879
    mov cl, byte ptr [ebp - local_counter]            # 0041b87c
    add cl, 0x1                                  # 0041b87f
    mov byte ptr [ebp - local_counter], cl            # 0041b882
    mov edx, dword ptr [ebp - local_byte]          # 0041b885
    and edx, 0xff                                # 0041b888
    mov dword ptr [ebp - local_match_count], edx          # 0041b88e
    mov eax, dword ptr [ebp - local_match_count]          # 0041b891
    and eax, 0xf0                                # 0041b894
    shl eax, 0x4                                 # 0041b899
    mov ecx, dword ptr [ebp - local_match_offset]          # 0041b89c
    {load} or ecx, eax                           # 0041b89f
    mov dword ptr [ebp - local_match_offset], ecx          # 0041b8a1
    mov edx, dword ptr [ebp - local_match_count]          # 0041b8a4
    and edx, 0xf                                 # 0041b8a7
    add edx, dword ptr [ebp - local_len_bias]          # 0041b8aa
    mov dword ptr [ebp - local_match_count], edx          # 0041b8ad
    mov dword ptr [ebp - local_copy_index], 0x0          # 0041b8b0
    jmp.d8 L_copy_test                            # 0041b8b7
L_copy_next:
    # block 0x0041b8b9: L_copy_next: increment copy_index
    mov eax, dword ptr [ebp - local_copy_index]          # 0041b8b9
    add eax, 0x1                                 # 0041b8bc
    mov dword ptr [ebp - local_copy_index], eax          # 0041b8bf
L_copy_test:
    # block 0x0041b8c2: L_copy_test: unsigned compare copy_index with match_count; copy_index above match_count ends the copy and jumps to L_main_loop (so match_count + 1 bytes are copied)
    mov ecx, dword ptr [ebp - local_copy_index]          # 0041b8c2
    cmp ecx, dword ptr [ebp - local_match_count]          # 0041b8c5
    ja.d8 L_main_loop                             # 0041b8c8
    # block 0x0041b8ca: copy body: byte = ring[(match_offset + copy_index) & 0xfff]; store to arg_out[arg_out_pos++] and ring[ring_write++] (wrapped with and 0xfff); loop to L_copy_next
    mov edx, dword ptr [ebp - local_match_offset]          # 0041b8ca
    add edx, dword ptr [ebp - local_copy_index]          # 0041b8cd
    mov eax, dword ptr [ebp - local_ring_size]          # 0041b8d0
    sub eax, 0x1                                 # 0041b8d3
    {load} and edx, eax                          # 0041b8d6
    mov ecx, dword ptr [ebp - local_ring_base]          # 0041b8d8
    mov dl, byte ptr [ecx + edx]                 # 0041b8db
    mov byte ptr [ebp - local_byte], dl            # 0041b8de
    mov eax, dword ptr [ebp + arg_out]             # 0041b8e1
    add eax, dword ptr [ebp + arg_out_pos]            # 0041b8e4
    mov cl, byte ptr [ebp - local_byte]            # 0041b8e7
    mov byte ptr [eax], cl                       # 0041b8ea
    mov edx, dword ptr [ebp + arg_out_pos]            # 0041b8ec
    add edx, 0x1                                 # 0041b8ef
    mov dword ptr [ebp + arg_out_pos], edx            # 0041b8f2
    mov eax, dword ptr [ebp - local_ring_base]          # 0041b8f5
    add eax, dword ptr [ebp - local_ring_write]           # 0041b8f8
    mov cl, byte ptr [ebp - local_byte]            # 0041b8fb
    mov byte ptr [eax], cl                       # 0041b8fe
    mov edx, dword ptr [ebp - local_ring_write]           # 0041b900
    add edx, 0x1                                 # 0041b903
    mov dword ptr [ebp - local_ring_write], edx           # 0041b906
    mov eax, dword ptr [ebp - local_ring_size]          # 0041b909
    sub eax, 0x1                                 # 0041b90c
    mov ecx, dword ptr [ebp - local_ring_write]           # 0041b90f
    {load} and ecx, eax                          # 0041b912
    mov dword ptr [ebp - local_ring_write], ecx           # 0041b914
    jmp.d8 L_copy_next                            # 0041b917
L_main_loop:
    # block 0x0041b919: L_main_loop: back to L_next_flag_bit for the next token
    jmp.d32 L_next_flag_bit                           # 0041b919
L_return:
    # block 0x0041b91e: L_return: restore edi, tear down the frame, ret 0x10
    pop edi                                      # 0041b91e
    {load} mov esp, ebp                          # 0041b91f
    pop ebp                                      # 0041b921
    ret 0x10                                     # 0041b922
