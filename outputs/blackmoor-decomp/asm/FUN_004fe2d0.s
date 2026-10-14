# FUN_004fe2d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe2d0
# extent:       0x004fe2d0-0x004fe62e (862 code bytes)
# span:         0x004fe2d0-0x004fe630 (code 862, tables 0, padding 2)
# sha256:       57de982dcd417e8686592ed8b479ffc20beac24bfde848141b073fc0de89f7c7
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        ebp
# name:         vorbisfile_read_interleaved_pcm
# arguments:    cdecl, 7 stack args, caller pops 0x1c (plain ret), standard ebp frame, ebx/esi/edi saved; [ebp+8]=vf (decoder-file object, edi); [ebp+0xc]=buffer (output byte pointer, copied to esi/edx/ecx working registers; the slot is also reused as an FISTP dword temp and as a write-pointer home); [ebp+0x10]=length (output capacity in bytes; in one 16-bit path the slot is reused as an FISTP temp); [ebp+0x14]=bigendianp (compared with the host byte-order flag returned by FUN_004fe630); [ebp+0x18]=word (bytes per sample: 1 selects the 8-bit path, any other value the 16-bit path; the slot is reused as a loop counter); [ebp+0x1c]=sgned (nonzero = signed output; the slot is overwritten with the unsigned bias 0 or 0x8000 on the 16-bit path and reused as an FISTP temp in the signed native path); [ebp+0x20]=bitstream (int* receiving vf+0x60, may be NULL); returns eax = bytes written, 0 at end of data, or a negative error code (0xffffff7d = -131)
# locals:       [ebp-4]=pcm_planes (float** from FUN_004ff9a0, per-channel plane pointers); [ebp-8]=frames (frames available, then clamped to length/frame_bytes; loop bound and tail consume count); [ebp-0xc]=channels (info+4 from FUN_004fe290(vf,-1)); [ebp-0x10]=host_endian (FUN_004fe630 result, read only at 0x4fe401); [ebp-0x14]=x87 scratch qword occupying [ebp-0x14..-0xd], whose upper dword aliases the host_endian slot (safe because host_endian is last read at 0x4fe401, before any FSTP); [ebp-0x18]=frame_bytes (channels*word, used for the division and the return value)
# fields:       vf+0x50/vf+0x54: 64-bit running frame total, += frames by add/adc at the tail; vf+0x58: signed state value (< 2 fails, < 3 forces a fetch); vf+0x60: current link, copied to *bitstream; vf+0x1da: embedded decode-state sub-object passed to FUN_004ff9a0 and FUN_004ffa00; info+0x04 (via FUN_004fe290): channel count; globals 0x0052e580 = 128.0f (8-bit scale) and 0x0052e57c = 32768.0f (16-bit scale), both read as float by fmul
# callees:      FUN_004fe630 = host byte-order flag (its original bytes are xor eax,eax; ret, so it returns 0); FUN_004fdfd0 = fetch and decode more data into vf (called with vf, 0, 1; returns -2 at end of data); FUN_004ff9a0 = get planar float pointers and available frame count; FUN_004fe290 = info record lookup (called with link -1); FUN_004ffa00 = consume decoded frames
# track-n:      outputs/blackmoor-decomp/src/his_pcm_quantize.c:his_pcm_quantize_planar
# unverified:   Track N his_pcm_quantize_planar models only the quantization loops of the production call (mono/stereo, word=1 with sgned=0 and word=2 with sgned=1, bigendianp=0, native order); the fetch loop, the length/frame_bytes clamp, the vf+0x50/+0x54 accounting, *bitstream and the return codes are not in Track N. Branches not exercised by the oracle: unsigned native 16-bit (0x4fe496), signed 8-bit (sgned nonzero with word=1), both byte-swapped branches (0x4fe515 onward, unreachable while FUN_004fe630 returns 0 and bigendianp is 0), channel counts above 2, word values other than 1 and 2, and every error return. Any word other than 1 takes the 16-bit path but frame_bytes uses the passed word, so word 3 or more would return more bytes than it writes; not exercised. idiv by channels*word has no zero guard (a zero product would fault); not exercised. Results under x87 control words other than 0x037f are not verified; this function does not set the control word and fstp qword/fistp use the ambient rounding mode. Identification with libvorbisfile ov_read and the field names (state, current link, 64-bit offset, dsp sub-object) are inferred from layout and call pattern. vf+0x1da is not dword aligned; the layout of that sub-object is not verified. FUN_004fdfd0 argument and return meanings (0, 1, -2) are inferred from the call site only.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_pcm_planes, 0x4  # [ebp - 0x4]: float** of per-channel plane pointers from FUN_004ff9a0
.equ local_frames, 0x8  # [ebp - 0x8]: frames available, clamped to length/frame_bytes
.equ local_channels, 0xc  # [ebp - 0xc]: channel count from the info record (+4)
.equ local_host_endian, 0x10  # [ebp - 0x10]: FUN_004fe630 host byte-order flag; aliases the upper dword of local_x87_scratch
.equ local_x87_scratch, 0x14  # [ebp - 0x14]: 8-byte scratch for fstp/fld qword at [ebp-0x14..-0xd]
.equ local_frame_bytes, 0x18  # [ebp - 0x18]: channels*word
.equ arg_vf, 0x8  # [ebp + 0x8]: decoder-file object
.equ arg_buffer, 0xc  # [ebp + 0xc]: output byte pointer; later an FISTP temp in the 8-bit and some 16-bit paths
.equ arg_length, 0x10  # [ebp + 0x10]: output capacity in bytes; reused as FISTP temp in the unsigned native 16-bit path
.equ arg_bigendianp, 0x14  # [ebp + 0x14]: requested output byte order
.equ arg_word, 0x18  # [ebp + 0x18]: bytes per sample; reused as channel counter in the unsigned native path and frame counter in the little-endian-output path
.equ arg_sgned, 0x1c  # [ebp + 0x1c]: signed flag; overwritten by the bias 0/0x8000 on the 16-bit path
.equ arg_bitstream, 0x20  # [ebp + 0x20]: optional int* receiving the current link

# --- external targets -----------------------------------------------
.set FUN_004fdfd0, .text + (0x004fdfd0 - 0x401000)
.set FUN_004fe290, .text + (0x004fe290 - 0x401000)
.set FUN_004fe630, .text + (0x004fe630 - 0x401000)
.set FUN_004ff9a0, .text + (0x004ff9a0 - 0x401000)
.set FUN_004ffa00, .text + (0x004ffa00 - 0x401000)

.org 0x004fe2d0 - 0x401000
.globl FUN_004fe2d0
FUN_004fe2d0:
    # block 0x004fe2d0: prologue: standard ebp frame (0x18 bytes), save ebx/esi/edi; call FUN_004fe630 (host byte-order flag), edi=vf, local_host_endian=eax; if vf+0x58 >= 2 (signed) continue
    push ebp                                     # 004fe2d0
    {load} mov ebp, esp                          # 004fe2d1
    sub esp, 0x18                                # 004fe2d3
    push ebx                                     # 004fe2d6
    push esi                                     # 004fe2d7
    push edi                                     # 004fe2d8
    call FUN_004fe630                            # 004fe2d9
    mov edi, dword ptr [ebp + arg_vf]             # 004fe2de
    mov dword ptr [ebp - local_host_endian], eax          # 004fe2e1
    cmp dword ptr [edi + 0x58], 0x2              # 004fe2e4
    jge.d8 L_state_ok                            # 004fe2e8
    # block 0x004fe2ea: vf+0x58 < 2: restore registers and return 0xffffff7d (-131)
    pop edi                                      # 004fe2ea
    pop esi                                      # 004fe2eb
    mov eax, 0xffffff7d                          # 004fe2ec
    pop ebx                                      # 004fe2f1
    {load} mov esp, ebp                          # 004fe2f2
    pop ebp                                      # 004fe2f4
    ret                                          # 004fe2f5
L_state_ok:
    # block 0x004fe2f6: ebx=3, the state threshold compared against vf+0x58 in the fill loop
    mov ebx, 0x3                                 # 004fe2f6
L_fill_loop:
    # block 0x004fe2fb: fill loop head: if vf+0x58 < ebx=3 (signed) go fetch more data without reading the queue
    cmp dword ptr [edi + 0x58], ebx              # 004fe2fb
    jl.d8 L_fetch_more                             # 004fe2fe
    # block 0x004fe300: state >= 3: call FUN_004ff9a0(vf+0x1da, &local_pcm_planes); esi=frames available, local_frames=esi; nonzero -> have data
    lea eax, [ebp - local_pcm_planes]                     # 004fe300
    lea ecx, [edi + 0x1da]                       # 004fe303
    push eax                                     # 004fe309
    push ecx                                     # 004fe30a
    call FUN_004ff9a0                            # 004fe30b
    {load} mov esi, eax                          # 004fe310
    add esp, 0x8                                 # 004fe312
    test esi, esi                                # 004fe315
    mov dword ptr [ebp - local_frames], esi           # 004fe317
    jne.d8 L_have_frames                            # 004fe31a
L_fetch_more:
    # block 0x004fe31c: no frames queued: call FUN_004fdfd0(vf, 0, 1) to fetch/decode more, pop 12; if it returns -2 go to the end-of-data return
    push 0x1                                     # 004fe31c
    push 0x0                                     # 004fe31e
    push edi                                     # 004fe320
    call FUN_004fdfd0                            # 004fe321
    add esp, 0xc                                 # 004fe326
    cmp eax, -0x2                                # 004fe329
    je.d8 L_return_eof                             # 004fe32c
    # block 0x004fe32e: result != -2: if result <= 0 (signed) return it unchanged
    test eax, eax                                # 004fe32e
    jle.d32 L_return_eax                           # 004fe330
    # block 0x004fe336: result > 0: loop back to the fill loop head
    jmp.d8 L_fill_loop                            # 004fe336
L_return_eof:
    # block 0x004fe338: end of data (-2 from the fetch): restore registers and return 0
    pop edi                                      # 004fe338
    pop esi                                      # 004fe339
    {load} xor eax, eax                          # 004fe33a
    pop ebx                                      # 004fe33c
    {load} mov esp, ebp                          # 004fe33d
    pop ebp                                      # 004fe33f
    ret                                          # 004fe340
L_have_frames:
    # block 0x004fe341: flags still from test esi,esi: if esi < 0 (signed) return esi
    jle.d32 L_return_esi                           # 004fe341
    # block 0x004fe347: esi > 0: call FUN_004fe290(vf,-1), ebx=info+4 (channels), edi=word; ecx=frame_bytes=channels*word; eax=length/frame_bytes (signed idiv); save local_channels and local_frame_bytes; if esi (available) <= eax skip the clamp
    push -0x1                                    # 004fe347
    push edi                                     # 004fe349
    call FUN_004fe290                            # 004fe34a
    mov ebx, dword ptr [eax + 0x4]               # 004fe34f
    mov edi, dword ptr [ebp + arg_word]            # 004fe352
    {load} mov ecx, ebx                          # 004fe355
    mov eax, dword ptr [ebp + arg_length]            # 004fe357
    imul ecx, edi                                # 004fe35a
    cdq                                          # 004fe35d
    idiv ecx                                     # 004fe35e
    add esp, 0x8                                 # 004fe360
    mov dword ptr [ebp - local_channels], ebx           # 004fe363
    mov dword ptr [ebp - local_frame_bytes], ecx          # 004fe366
    {load} cmp esi, eax                          # 004fe369
    jle.d8 L_check_frames_positive                            # 004fe36b
    # block 0x004fe36d: available > length/frame_bytes: local_frames = esi = length/frame_bytes
    mov dword ptr [ebp - local_frames], eax           # 004fe36d
    {load} mov esi, eax                          # 004fe370
L_check_frames_positive:
    # block 0x004fe372: if frames > 0 (signed) continue
    test esi, esi                                # 004fe372
    jg.d8 L_select_sample_width                             # 004fe374
    # block 0x004fe376: frames <= 0 (output buffer too small): return 0xffffff7d (-131)
    pop edi                                      # 004fe376
    pop esi                                      # 004fe377
    mov eax, 0xffffff7d                          # 004fe378
    pop ebx                                      # 004fe37d
    {load} mov esp, ebp                          # 004fe37e
    pop ebp                                      # 004fe380
    ret                                          # 004fe381
L_select_sample_width:
    # block 0x004fe382: if word != 1 take the 16-bit path (L_pcm16_setup), else fall into the 8-bit path
    cmp edi, 0x1                                 # 004fe382
    jne.d8 L_pcm16_setup                            # 004fe385
    # block 0x004fe387: 8-bit setup: edx = (sgned != 0 ? 0 : 0x80) via neg/sbb mask, i.e. the byte bias; edi=frame index 0; the following test esi/jle is redundant here (esi > 0)
    mov edx, dword ptr [ebp + arg_sgned]            # 004fe387
    neg edx                                      # 004fe38a
    {load} sbb edx, edx                          # 004fe38c
    {load} xor edi, edi                          # 004fe38e
    and edx, -0x80                               # 004fe390
    add edx, 0x80                                # 004fe393
    test esi, esi                                # 004fe399
    jle.d32 L_consume_and_account                           # 004fe39b
    # block 0x004fe3a1: esi = output write pointer (arg_buffer)
    mov esi, dword ptr [ebp + arg_buffer]             # 004fe3a1
L_pcm8_frame_loop:
    # block 0x004fe3a4: per frame: eax=channel index 0; skip the channel loop if channels <= 0
    {load} xor eax, eax                          # 004fe3a4
    test ebx, ebx                                # 004fe3a6
    jle.d8 L_pcm8_next_frame                            # 004fe3a8
L_pcm8_channel_loop:
    # block 0x004fe3aa: per channel: ecx = pcm_planes[channel]; convert plane[frame] (edi) to int32 (sample*128.0f) into the arg_buffer slot; ecx = that integer
    mov ecx, dword ptr [ebp - local_pcm_planes]           # 004fe3aa
    mov ecx, dword ptr [ecx + 4*eax]             # 004fe3ad
    # x87 sequence (stack depth in brackets): fld loads the float sample -> st0 [1]
    # fmul by the float constant at 0x0052e580 (bytes 00 00 00 43 = 128.0f) -> st0 = sample*scale, exact because the scale is a power of two [1]
    # fstp qword stores st0 as a double into the x87 scratch qword and pops [0]; fld qword reloads it [1]
    # fistp dword converts st0 to int32 using the ambient x87 rounding mode (indefinite 0x80000000 on invalid when masked) into the arg_buffer slot ([ebp+0xc]; the write pointer is in esi) and pops [0]
    fld dword ptr [ecx + 4*edi]                  # 004fe3b0
    fmul dword ptr [0x52e580]                    # 004fe3b3
    fstp qword ptr [ebp - local_x87_scratch]              # 004fe3b9
    fld qword ptr [ebp - local_x87_scratch]               # 004fe3bc
    fistp dword ptr [ebp + arg_buffer]                # 004fe3bf
    mov ecx, dword ptr [ebp + arg_buffer]             # 004fe3c2
    cmp ecx, 0x7f                                # 004fe3c5
    jle.d8 L_pcm8_check_low                            # 004fe3c8
    # block 0x004fe3ca: value > 0x7f: clamp to 0x7f
    mov ecx, 0x7f                                # 004fe3ca
    jmp.d8 L_pcm8_store                            # 004fe3cf
L_pcm8_check_low:
    # block 0x004fe3d1: value <= 0x7f: if value >= -0x80 (signed) keep it
    cmp ecx, -0x80                               # 004fe3d1
    jge.d8 L_pcm8_store                            # 004fe3d4
    # block 0x004fe3d6: value < -0x80: clamp to -0x80
    mov ecx, 0xffffff80                          # 004fe3d6
L_pcm8_store:
    # block 0x004fe3db: bl = bias(dl) + clamped value (byte add, clobbers low byte of ebx); store byte at [esi], esi++, channel++, ecx=channels; loop while channel < channels
    {load} mov bl, dl                            # 004fe3db
    {load} add bl, cl                            # 004fe3dd
    mov ecx, dword ptr [ebp - local_channels]           # 004fe3df
    mov byte ptr [esi], bl                       # 004fe3e2
    inc esi                                      # 004fe3e4
    inc eax                                      # 004fe3e5
    {load} cmp eax, ecx                          # 004fe3e6
    jl.d8 L_pcm8_channel_loop                             # 004fe3e8
    # block 0x004fe3ea: restore ebx=channels (bl was clobbered by the byte add)
    {load} mov ebx, ecx                          # 004fe3ea
L_pcm8_next_frame:
    # block 0x004fe3ec: next frame: edi++; loop while frame < local_frames (signed)
    mov eax, dword ptr [ebp - local_frames]           # 004fe3ec
    inc edi                                      # 004fe3ef
    {load} cmp edi, eax                          # 004fe3f0
    jl.d8 L_pcm8_frame_loop                             # 004fe3f2
    # block 0x004fe3f4: esi = frames (replaces the write pointer for the common tail); jump to the tail
    {load} mov esi, eax                          # 004fe3f4
    jmp.d32 L_consume_and_account                           # 004fe3f6
L_pcm16_setup:
    # block 0x004fe3fb: 16-bit setup: eax=sgned, ecx=bigendianp, edi=host_endian; edx = (sgned != 0 ? 0 : 0x8000) bias stored back into arg_sgned; if host_endian != bigendianp go to the swapped-order paths
    mov eax, dword ptr [ebp + arg_sgned]            # 004fe3fb
    mov ecx, dword ptr [ebp + arg_bigendianp]            # 004fe3fe
    mov edi, dword ptr [ebp - local_host_endian]          # 004fe401
    {load} mov edx, eax                          # 004fe404
    neg edx                                      # 004fe406
    {load} sbb edx, edx                          # 004fe408
    and edx, 0xffff8000                          # 004fe40a
    add edx, 0x8000                              # 004fe410
    {load} cmp edi, ecx                          # 004fe416
    mov dword ptr [ebp + arg_sgned], edx            # 004fe418
    jne.d32 L_swapped_order                           # 004fe41b
    # block 0x004fe421: byte orders agree (native store): if sgned == 0 go to the unsigned native loop
    test eax, eax                                # 004fe421
    je.d8 L_u16_native                             # 004fe423
    # block 0x004fe425: signed native: edi=channel 0; if channels <= 0 go to the tail
    {load} xor edi, edi                          # 004fe425
    test ebx, ebx                                # 004fe427
    jle.d32 L_consume_and_account                           # 004fe429
    # block 0x004fe42f: edx = write pointer (arg_buffer); redundant store back to arg_buffer
    mov edx, dword ptr [ebp + arg_buffer]             # 004fe42f
    mov dword ptr [ebp + arg_buffer], edx             # 004fe432
L_s16_channel_loop:
    # block 0x004fe435: per channel edi: ecx = pcm_planes[edi]; if frames <= 0 skip the sample loop
    mov eax, dword ptr [ebp - local_pcm_planes]           # 004fe435
    test esi, esi                                # 004fe438
    mov ecx, dword ptr [eax + 4*edi]             # 004fe43a
    jle.d8 L_s16_next_channel                            # 004fe43d
    # block 0x004fe43f: esi = frames counter; ebx = channels*2, the byte stride between consecutive samples of one channel in the interleaved output
    mov esi, dword ptr [ebp - local_frames]           # 004fe43f
    {load} add ebx, ebx                          # 004fe442
L_s16_sample_loop:
    # block 0x004fe444: per sample: fld [ecx] (next plane float), convert sample*32768.0f to int32 into the arg_sgned slot (bias is 0 on this path); eax = that integer
    # x87 sequence (stack depth in brackets): fld loads the float sample -> st0 [1]
    # fmul by the float constant at 0x0052e57c (bytes 00 00 00 47 = 32768.0f) -> st0 = sample*scale, exact because the scale is a power of two [1]
    # fstp qword stores st0 as a double into the x87 scratch qword and pops [0]; fld qword reloads it [1]
    # fistp dword converts st0 to int32 using the ambient x87 rounding mode (indefinite 0x80000000 on invalid when masked) into the arg_sgned slot ([ebp+0x1c]; bias is 0 here) and pops [0]
    fld dword ptr [ecx]                          # 004fe444
    fmul dword ptr [0x52e57c]                    # 004fe446
    fstp qword ptr [ebp - local_x87_scratch]              # 004fe44c
    fld qword ptr [ebp - local_x87_scratch]               # 004fe44f
    fistp dword ptr [ebp + arg_sgned]               # 004fe452
    mov eax, dword ptr [ebp + arg_sgned]            # 004fe455
    cmp eax, 0x7fff                              # 004fe458
    jle.d8 L_s16_check_low                            # 004fe45d
    # block 0x004fe45f: value > 0x7fff: clamp to 0x7fff
    mov eax, 0x7fff                              # 004fe45f
    jmp.d8 L_s16_store                            # 004fe464
L_s16_check_low:
    # block 0x004fe466: value <= 0x7fff: if value >= -0x8000 (signed) keep it
    cmp eax, 0xffff8000                          # 004fe466
    jge.d8 L_s16_store                            # 004fe46b
    # block 0x004fe46d: value < -0x8000: clamp to -0x8000
    mov eax, 0xffff8000                          # 004fe46d
L_s16_store:
    # block 0x004fe472: store word ax at [edx] (little-endian), edx += channels*2, ecx += 4 (next plane float), frames counter--; loop while nonzero
    mov word ptr [edx], ax                       # 004fe472
    {load} add edx, ebx                          # 004fe475
    add ecx, 0x4                                 # 004fe477
    dec esi                                      # 004fe47a
    jne.d8 L_s16_sample_loop                            # 004fe47b
    # block 0x004fe47d: restore ebx=local_channels and esi=local_frames
    mov ebx, dword ptr [ebp - local_channels]           # 004fe47d
    mov esi, dword ptr [ebp - local_frames]           # 004fe480
L_s16_next_channel:
    # block 0x004fe483: next channel: edx = arg_buffer + 2, saved back; edi++; loop while edi < channels (signed)
    mov edx, dword ptr [ebp + arg_buffer]             # 004fe483
    inc edi                                      # 004fe486
    add edx, 0x2                                 # 004fe487
    {load} cmp edi, ebx                          # 004fe48a
    mov dword ptr [ebp + arg_buffer], edx             # 004fe48c
    jl.d8 L_s16_channel_loop                             # 004fe48f
    # block 0x004fe491: jump to the common tail
    jmp.d32 L_consume_and_account                           # 004fe491
L_u16_native:
    # block 0x004fe496: unsigned native: arg_word slot = 0 (channel counter); if channels <= 0 go to the tail
    {load} xor eax, eax                          # 004fe496
    test ebx, ebx                                # 004fe498
    mov dword ptr [ebp + arg_word], eax            # 004fe49a
    jle.d32 L_consume_and_account                           # 004fe49d
    # block 0x004fe4a3: ecx = write pointer (arg_buffer); redundant store back
    mov ecx, dword ptr [ebp + arg_buffer]             # 004fe4a3
    mov dword ptr [ebp + arg_buffer], ecx             # 004fe4a6
L_u16_channel_loop:
    # block 0x004fe4a9: per channel (arg_word slot): edx = pcm_planes[channel]; if frames <= 0 skip the sample loop
    mov edx, dword ptr [ebp - local_pcm_planes]           # 004fe4a9
    test esi, esi                                # 004fe4ac
    mov edx, dword ptr [edx + 4*eax]             # 004fe4ae
    jle.d8 L_u16_next_channel                            # 004fe4b1
    # block 0x004fe4b3: esi = frames counter; ebx = channels*2 byte stride
    mov esi, dword ptr [ebp - local_frames]           # 004fe4b3
    {load} add ebx, ebx                          # 004fe4b6
L_u16_sample_loop:
    # block 0x004fe4b8: per sample: fld [edx], convert sample*32768.0f to int32 into the arg_length slot; eax = that integer
    # x87 sequence (stack depth in brackets): fld loads the float sample -> st0 [1]
    # fmul by the float constant at 0x0052e57c (bytes 00 00 00 47 = 32768.0f) -> st0 = sample*scale, exact because the scale is a power of two [1]
    # fstp qword stores st0 as a double into the x87 scratch qword and pops [0]; fld qword reloads it [1]
    # fistp dword converts st0 to int32 using the ambient x87 rounding mode (indefinite 0x80000000 on invalid when masked) into the arg_length slot ([ebp+0x10]) and pops [0]
    fld dword ptr [edx]                          # 004fe4b8
    fmul dword ptr [0x52e57c]                    # 004fe4ba
    fstp qword ptr [ebp - local_x87_scratch]              # 004fe4c0
    fld qword ptr [ebp - local_x87_scratch]               # 004fe4c3
    fistp dword ptr [ebp + arg_length]               # 004fe4c6
    mov eax, dword ptr [ebp + arg_length]            # 004fe4c9
    cmp eax, 0x7fff                              # 004fe4cc
    jle.d8 L_u16_check_low                            # 004fe4d1
    # block 0x004fe4d3: value > 0x7fff: clamp to 0x7fff
    mov eax, 0x7fff                              # 004fe4d3
    jmp.d8 L_u16_store                            # 004fe4d8
L_u16_check_low:
    # block 0x004fe4da: value <= 0x7fff: if value >= -0x8000 (signed) keep it
    cmp eax, 0xffff8000                          # 004fe4da
    jge.d8 L_u16_store                            # 004fe4df
    # block 0x004fe4e1: value < -0x8000: clamp to -0x8000
    mov eax, 0xffff8000                          # 004fe4e1
L_u16_store:
    # block 0x004fe4e6: edi = bias 0x8000 (arg_sgned slot) + clamped value; store word di at [ecx], ecx += stride, edx += 4, frames counter--; loop while nonzero
    mov edi, dword ptr [ebp + arg_sgned]            # 004fe4e6
    add edx, 0x4                                 # 004fe4e9
    {load} add edi, eax                          # 004fe4ec
    mov word ptr [ecx], di                       # 004fe4ee
    {load} add ecx, ebx                          # 004fe4f1
    dec esi                                      # 004fe4f3
    jne.d8 L_u16_sample_loop                            # 004fe4f4
    # block 0x004fe4f6: reload eax=channel counter, ebx=local_channels, esi=local_frames
    mov eax, dword ptr [ebp + arg_word]            # 004fe4f6
    mov ebx, dword ptr [ebp - local_channels]           # 004fe4f9
    mov esi, dword ptr [ebp - local_frames]           # 004fe4fc
L_u16_next_channel:
    # block 0x004fe4ff: next channel: write base (arg_buffer) += 2, channel counter++ stored back; loop while counter < channels
    mov ecx, dword ptr [ebp + arg_buffer]             # 004fe4ff
    inc eax                                      # 004fe502
    add ecx, 0x2                                 # 004fe503
    {load} cmp eax, ebx                          # 004fe506
    mov dword ptr [ebp + arg_word], eax            # 004fe508
    mov dword ptr [ebp + arg_buffer], ecx             # 004fe50b
    jl.d8 L_u16_channel_loop                             # 004fe50e
    # block 0x004fe510: jump to the common tail
    jmp.d32 L_consume_and_account                           # 004fe510
L_swapped_order:
    # block 0x004fe515: host byte order != bigendianp: edi=0; if bigendianp == 0 go to the little-endian-output loop
    {load} xor edi, edi                          # 004fe515
    {load} cmp ecx, edi                          # 004fe517
    je.d8 L_le_on_swapped_host                             # 004fe519
    # block 0x004fe51b: bigendianp != 0: if frames <= 0 go to the tail
    {load} cmp esi, edi                          # 004fe51b
    jle.d32 L_consume_and_account                           # 004fe51d
    # block 0x004fe523: esi = write pointer (arg_buffer)
    mov esi, dword ptr [ebp + arg_buffer]             # 004fe523
L_be_frame_loop:
    # block 0x004fe526: big-endian output, per frame (edi): ecx=channel 0; skip if channels <= 0
    {load} xor ecx, ecx                          # 004fe526
    test ebx, ebx                                # 004fe528
    jle.d8 L_be_next_frame                            # 004fe52a
L_be_channel_loop:
    # block 0x004fe52c: per channel: eax = pcm_planes[channel]; convert plane[frame]*32768.0f to int32 into the arg_buffer slot; eax = that integer
    mov eax, dword ptr [ebp - local_pcm_planes]           # 004fe52c
    mov eax, dword ptr [eax + 4*ecx]             # 004fe52f
    # x87 sequence (stack depth in brackets): fld loads the float sample -> st0 [1]
    # fmul by the float constant at 0x0052e57c (bytes 00 00 00 47 = 32768.0f) -> st0 = sample*scale, exact because the scale is a power of two [1]
    # fstp qword stores st0 as a double into the x87 scratch qword and pops [0]; fld qword reloads it [1]
    # fistp dword converts st0 to int32 using the ambient x87 rounding mode (indefinite 0x80000000 on invalid when masked) into the arg_buffer slot ([ebp+0xc]; the write pointer is in esi) and pops [0]
    fld dword ptr [eax + 4*edi]                  # 004fe532
    fmul dword ptr [0x52e57c]                    # 004fe535
    fstp qword ptr [ebp - local_x87_scratch]              # 004fe53b
    fld qword ptr [ebp - local_x87_scratch]               # 004fe53e
    fistp dword ptr [ebp + arg_buffer]                # 004fe541
    mov eax, dword ptr [ebp + arg_buffer]             # 004fe544
    cmp eax, 0x7fff                              # 004fe547
    jle.d8 L_be_check_low                            # 004fe54c
    # block 0x004fe54e: value > 0x7fff: clamp to 0x7fff
    mov eax, 0x7fff                              # 004fe54e
    jmp.d8 L_be_store                            # 004fe553
L_be_check_low:
    # block 0x004fe555: value <= 0x7fff: if value >= -0x8000 (signed) keep it
    cmp eax, 0xffff8000                          # 004fe555
    jge.d8 L_be_store                            # 004fe55a
    # block 0x004fe55c: value < -0x8000: clamp to -0x8000
    mov eax, 0xffff8000                          # 004fe55c
L_be_store:
    # block 0x004fe561: eax += bias (edx); store high byte (value>>8, sar) then low byte at [esi]; reload edx = bias from arg_sgned; channel++; loop while channel < channels
    {load} add eax, edx                          # 004fe561
    {load} mov edx, eax                          # 004fe563
    sar edx, 0x8                                 # 004fe565
    mov byte ptr [esi], dl                       # 004fe568
    inc esi                                      # 004fe56a
    mov edx, dword ptr [ebp + arg_sgned]            # 004fe56b
    mov byte ptr [esi], al                       # 004fe56e
    inc esi                                      # 004fe570
    inc ecx                                      # 004fe571
    {load} cmp ecx, ebx                          # 004fe572
    jl.d8 L_be_channel_loop                             # 004fe574
L_be_next_frame:
    # block 0x004fe576: next frame: edi++ ; loop while frame < local_frames (signed)
    mov eax, dword ptr [ebp - local_frames]           # 004fe576
    inc edi                                      # 004fe579
    {load} cmp edi, eax                          # 004fe57a
    jl.d8 L_be_frame_loop                             # 004fe57c
    # block 0x004fe57e: esi = frames for the common tail; jump to the tail
    {load} mov esi, eax                          # 004fe57e
    jmp.d8 L_consume_and_account                            # 004fe580
L_le_on_swapped_host:
    # block 0x004fe582: little-endian output while host order differs: frame counter slot (arg_word) = 0; if frames <= 0 go to the tail
    {load} cmp esi, edi                          # 004fe582
    mov dword ptr [ebp + arg_word], edi            # 004fe584
    jle.d8 L_consume_and_account                            # 004fe587
    # block 0x004fe589: edx = write pointer (arg_buffer)
    mov edx, dword ptr [ebp + arg_buffer]             # 004fe589
L_le_frame_loop:
    # block 0x004fe58c: per frame: ecx=channel 0; skip if channels <= 0
    {load} xor ecx, ecx                          # 004fe58c
    test ebx, ebx                                # 004fe58e
    jle.d8 L_le_next_frame                            # 004fe590
L_le_channel_loop:
    # block 0x004fe592: per channel: eax = pcm_planes[channel], edi = frame counter (arg_word slot); convert plane[frame]*32768.0f to int32 into the arg_buffer slot; eax = that integer
    mov eax, dword ptr [ebp - local_pcm_planes]           # 004fe592
    mov edi, dword ptr [ebp + arg_word]            # 004fe595
    mov eax, dword ptr [eax + 4*ecx]             # 004fe598
    # x87 sequence (stack depth in brackets): fld loads the float sample -> st0 [1]
    # fmul by the float constant at 0x0052e57c (bytes 00 00 00 47 = 32768.0f) -> st0 = sample*scale, exact because the scale is a power of two [1]
    # fstp qword stores st0 as a double into the x87 scratch qword and pops [0]; fld qword reloads it [1]
    # fistp dword converts st0 to int32 using the ambient x87 rounding mode (indefinite 0x80000000 on invalid when masked) into the arg_buffer slot ([ebp+0xc]; the write pointer is in edx) and pops [0]
    fld dword ptr [eax + 4*edi]                  # 004fe59b
    fmul dword ptr [0x52e57c]                    # 004fe59e
    fstp qword ptr [ebp - local_x87_scratch]              # 004fe5a4
    fld qword ptr [ebp - local_x87_scratch]               # 004fe5a7
    fistp dword ptr [ebp + arg_buffer]                # 004fe5aa
    mov eax, dword ptr [ebp + arg_buffer]             # 004fe5ad
    cmp eax, 0x7fff                              # 004fe5b0
    jle.d8 L_le_check_low                            # 004fe5b5
    # block 0x004fe5b7: value > 0x7fff: clamp to 0x7fff
    mov eax, 0x7fff                              # 004fe5b7
    jmp.d8 L_le_store                            # 004fe5bc
L_le_check_low:
    # block 0x004fe5be: value <= 0x7fff: if value >= -0x8000 (signed) keep it
    cmp eax, 0xffff8000                          # 004fe5be
    jge.d8 L_le_store                            # 004fe5c3
    # block 0x004fe5c5: value < -0x8000: clamp to -0x8000
    mov eax, 0xffff8000                          # 004fe5c5
L_le_store:
    # block 0x004fe5ca: eax += bias (arg_sgned slot); store low byte then high byte (sar 8) at [edx]; channel++; loop while channel < channels
    add eax, dword ptr [ebp + arg_sgned]            # 004fe5ca
    mov byte ptr [edx], al                       # 004fe5cd
    inc edx                                      # 004fe5cf
    sar eax, 0x8                                 # 004fe5d0
    mov byte ptr [edx], al                       # 004fe5d3
    inc edx                                      # 004fe5d5
    inc ecx                                      # 004fe5d6
    {load} cmp ecx, ebx                          # 004fe5d7
    jl.d8 L_le_channel_loop                             # 004fe5d9
L_le_next_frame:
    # block 0x004fe5db: next frame: counter (arg_word slot) ++; loop while counter < frames in esi (signed)
    mov eax, dword ptr [ebp + arg_word]            # 004fe5db
    inc eax                                      # 004fe5de
    {load} cmp eax, esi                          # 004fe5df
    mov dword ptr [ebp + arg_word], eax            # 004fe5e1
    jl.d8 L_le_frame_loop                             # 004fe5e4
L_consume_and_account:
    # block 0x004fe5e6: common tail: edi=vf; call FUN_004ffa00(vf+0x1da, frames) to consume; then vf+0x50/+0x54 (64-bit) += sign-extended frames via add/adc
    mov edi, dword ptr [ebp + arg_vf]             # 004fe5e6
    push esi                                     # 004fe5e9
    lea ecx, [edi + 0x1da]                       # 004fe5ea
    push ecx                                     # 004fe5f0
    call FUN_004ffa00                            # 004fe5f1
    mov ecx, dword ptr [edi + 0x50]              # 004fe5f6
    {load} mov eax, esi                          # 004fe5f9
    cdq                                          # 004fe5fb
    add esp, 0x8                                 # 004fe5fc
    {load} add ecx, eax                          # 004fe5ff
    mov eax, dword ptr [ebp + arg_bitstream]            # 004fe601
    mov dword ptr [edi + 0x50], ecx              # 004fe604
    mov ebx, dword ptr [edi + 0x54]              # 004fe607
    {load} adc ebx, edx                          # 004fe60a
    test eax, eax                                # 004fe60c
    mov dword ptr [edi + 0x54], ebx              # 004fe60e
    je.d8 L_return_bytes                             # 004fe611
    # block 0x004fe613: bitstream pointer non-NULL: *bitstream = vf+0x60
    mov edx, dword ptr [edi + 0x60]              # 004fe613
    mov dword ptr [eax], edx                     # 004fe616
L_return_bytes:
    # block 0x004fe618: return local_frame_bytes * frames (bytes written) and restore registers
    mov eax, dword ptr [ebp - local_frame_bytes]          # 004fe618
    pop edi                                      # 004fe61b
    imul eax, esi                                # 004fe61c
    pop esi                                      # 004fe61f
    pop ebx                                      # 004fe620
    {load} mov esp, ebp                          # 004fe621
    pop ebp                                      # 004fe623
    ret                                          # 004fe624
L_return_esi:
    # block 0x004fe625: return the negative queue value held in esi
    {load} mov eax, esi                          # 004fe625
L_return_eax:
    # block 0x004fe627: common error/EOF return: restore registers, eax already holds the result
    pop edi                                      # 004fe627
    pop esi                                      # 004fe628
    pop ebx                                      # 004fe629
    {load} mov esp, ebp                          # 004fe62a
    pop ebp                                      # 004fe62c
    ret                                          # 004fe62d

# --- data items (not part of the function) -------------------------
.org 0x004fe62e - 0x401000
PAD_004fe62e:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90
