# FUN_004f5b50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f5b50
# extent:       0x004f5b50-0x004f5e35 (741 code bytes)
# span:         0x004f5b50-0x004f5e35 (code 741, tables 0, padding 0)
# sha256:       157262bbb9905bacfac1cabd6964914a7db6690ee32abf7c386175170ece5e1c
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# name:         CDirectSound::CopyFromSoundFile
# arguments:    thiscall, standard ebp frame: ecx=this (saved to the this slot); [ebp+8]=sound index (signed int, scaled by 0x5bb into the entry table); [ebp+0xc]=dest buffer (bytes); [ebp+0x10]=byte count requested; callee pops 0xc (ret 0xc); returns eax = bytes produced, or -1 on error with this+0x3c2 set to the failure code
# locals:       [ebp-4]=entry_aux (entry+0x18a, stored and never read); [ebp-8]=result (bytes produced, returned on the success paths); [ebp-0xc]=entry (this+0x3ce table base + index*0x5bb); [ebp-0x10]=vf (entry+0x2f1 decoder-file object passed to FUN_004fe2d0 and FUN_004fdc70); [ebp-0x14]=last_read (latest FUN_004fe2d0 return, doubles as the loop continue flag, initial 1); [ebp-0x18]=sgned argument for the converter (1, or 0 for 8-bit); [ebp-0x1c]=bytes_done (running total); [ebp-0x20]=word argument for the converter (2, or 1 for 8-bit); [ebp-0x24]=bitstream_out (receives the converter's link output, initial 0); [ebp-0x28]=this
# fields:       this+0x3c2: status dword, set to 0x3e8 on entry, 0x3ec on a read failure, 0x3f9 on an unknown codec id; this+0x3ce: pointer to the sound entry table (entries 0x5bb bytes apart); entry+0x04: name string used in messages; entry+0x126: codec id word (2 = Ogg path through FUN_004fe2d0, 1 = raw file read path); entry+0x156: file stream pointer for codec 1 (its dword at +0x0c is tested against flag bits 0x20 and 0x10); entry+0x18a: stored in a local only; entry+0x2ed: word, 8 selects the 8-bit converter parameters, anything else 16-bit; entry+0x2f1: embedded decoder-file object; globals: word at 0x0063a4cd (trace level: 2 enables start/finish traces, nonzero enables error messages), message buffer at 0x0063888b, format strings at 0x0055e63c, 0x0055e680, 0x0055e6c8, 0x0055e718 and 0x0055e754
# callees:      FUN_004fe2d0 = vorbisfile_read_interleaved_pcm (cdecl, 7 args, pops 0x1c); FUN_004fdc70 = restart/seek of the decoder-file object, called as (vf, 0, 0) when the converter returns 0; FUN_0050ca3e = printf-style formatter into 0x0063888b (format and arguments pushed, cdecl); FUN_0044a2b7 = emits the formatted message buffer (1 arg); FUN_0050cf61 = fread-style read (dest, 1, count, stream); FUN_0050ce2b = fseek-style call (stream, 0x1e, 0); FUN_0052139c = error report with (format, 0, 0)
# track-n:      host-adapter: none
# unverified:   No Track N source reproduces this function: his_pcm_quantize.h only mentions the 0x4f5b50 -> 0x4fe2d0 path in a comment, and the oracle (tests/his_pcm_quantize_original_oracle.py) calls 0x4fe2d0 directly with word=1/sgned=0 or word=2/sgned=1, bigendianp=0; this caller, including the choice of word/sgned from entry+0x2ed (== 8) that his-pcm-quantization-validation.md describes, was not executed under an oracle. The class name in the function name comes only from the embedded trace strings, not from symbols. The roles of FUN_0050ca3e, FUN_0044a2b7, FUN_0050cf61, FUN_0050ce2b, FUN_004fdc70 and FUN_0052139c, and reading entry+0x156+0x0c as a stdio FILE flag word (0x20 error, 0x10 end of file), are inferred from call shapes and from Ghidra names only. FUN_0052139c is called with three pushed arguments and no cleanup in this function, and the callee ends in ret 0xc, so it pops them itself (verified); a nonzero bitstream_out with a non-negative read reaches the error message and prints a byte count as the error number. The status constants 0x3e8, 0x3ec and 0x3f9 are not given meanings beyond their use here. When the converter returns 0 the stream is restarted through FUN_004fdc70 and the loop then ends because last_read is 0, so the destination may be left partly filled with a short count returned; derived from the bytes, not exercised, and the result of FUN_004fdc70 is ignored. A nonzero bitstream_out (a link change) is treated as corruption. The raw-read short-read path with neither flag bit set is treated as corruption; not exercised. Field names entry_name, entry_codec_id, entry_file_stream, entry_sample_bits, entry_vf, this_status, this_entry_table, file_flags are role guesses from use only.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_entry_aux, 0x4  # [ebp - 0x4]: entry+0x18a, written once and never read
.equ local_result, 0x8  # [ebp - 0x8]: bytes produced, returned on the success paths
.equ local_entry, 0xc  # [ebp - 0xc]: sound entry pointer (table base + index*0x5bb)
.equ local_vf, 0x10  # [ebp - 0x10]: embedded decoder-file object at entry+0x2f1
.equ local_last_read, 0x14  # [ebp - 0x14]: latest converter return; also the loop continue flag
.equ local_sgned, 0x18  # [ebp - 0x18]: sgned argument for the converter (1, or 0 for 8-bit)
.equ local_bytes_done, 0x1c  # [ebp - 0x1c]: running byte total
.equ local_word, 0x20  # [ebp - 0x20]: word argument for the converter (2, or 1 for 8-bit)
.equ local_bitstream_out, 0x24  # [ebp - 0x24]: int receiving the converter's bitstream output
.equ local_this, 0x28  # [ebp - 0x28]: saved ecx (this)
.equ arg_sound_index, 0x8  # [ebp + 0x8]: sound entry index
.equ arg_dest, 0xc  # [ebp + 0xc]: destination buffer
.equ arg_byte_count, 0x10  # [ebp + 0x10]: bytes requested

.equ entry_name, 0x4  # entry+0x04: sound name string used in trace messages
.equ file_flags, 0xc  # FILE-like stream+0x0c: flag dword (0x20 error, 0x10 end of file; inferred)
.equ entry_codec_id, 0x126  # entry+0x126: codec id word (2 = Ogg, 1 = raw file read)
.equ entry_file_stream, 0x156  # entry+0x156: file stream pointer for codec 1
.equ entry_sample_bits, 0x2ed  # entry+0x2ed: word, 8 selects the 8-bit converter parameters
.equ entry_vf, 0x2f1  # entry+0x2f1: embedded decoder-file object (vf)
.equ this_status, 0x3c2  # this+0x3c2: status dword (0x3e8 entry, 0x3ec read failure, 0x3f9 unknown codec)
.equ this_entry_table, 0x3ce  # this+0x3ce: pointer to the sound entry table (entries 0x5bb bytes apart)

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004fdc70, .text + (0x004fdc70 - 0x401000)
.set FUN_004fe2d0, .text + (0x004fe2d0 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce2b, .text + (0x0050ce2b - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004f5b50 - 0x401000
.globl FUN_004f5b50
FUN_004f5b50:
    # block 0x004f5b50: prologue: save this; this+0x3c2 = 0x3e8; entry = this+0x3ce table + index*0x5bb saved to local_entry; local_entry_aux = entry+0x18a; codec = signed word entry+0x126; if codec != 2 go to the raw-codec check
    push ebp                                     # 004f5b50
    {load} mov ebp, esp                          # 004f5b51
    sub esp, 0x28                                # 004f5b53
    mov dword ptr [ebp - local_this], ecx          # 004f5b56
    mov eax, dword ptr [ebp - local_this]          # 004f5b59
    mov dword ptr [eax + this_status], 0x3e8           # 004f5b5c
    mov ecx, dword ptr [ebp + arg_sound_index]             # 004f5b66
    imul ecx, ecx, 0x5bb                         # 004f5b69
    mov edx, dword ptr [ebp - local_this]          # 004f5b6f
    mov eax, dword ptr [edx + this_entry_table]             # 004f5b72
    {load} add eax, ecx                          # 004f5b78
    mov dword ptr [ebp - local_entry], eax           # 004f5b7a
    mov ecx, dword ptr [ebp - local_entry]           # 004f5b7d
    add ecx, 0x18a                               # 004f5b80
    mov dword ptr [ebp - local_entry_aux], ecx           # 004f5b86
    mov edx, dword ptr [ebp - local_entry]           # 004f5b89
    movsx eax, word ptr [edx + entry_codec_id]            # 004f5b8c
    cmp eax, 0x2                                 # 004f5b93
    jne.d32 L_check_raw_codec                           # 004f5b96
    # block 0x004f5b9c: codec 2: local_vf = entry+0x2f1; bitstream_out=0, last_read=1, bytes_done=0, sgned=1, word=2; then unsigned word entry+0x2ed; if it != 8 keep the 16-bit parameters
    mov ecx, dword ptr [ebp + arg_sound_index]             # 004f5b9c
    imul ecx, ecx, 0x5bb                         # 004f5b9f
    mov edx, dword ptr [ebp - local_this]          # 004f5ba5
    mov eax, dword ptr [edx + this_entry_table]             # 004f5ba8
    lea ecx, [eax + ecx + entry_vf]                 # 004f5bae
    mov dword ptr [ebp - local_vf], ecx          # 004f5bb5
    mov dword ptr [ebp - local_bitstream_out], 0x0          # 004f5bb8
    mov dword ptr [ebp - local_last_read], 0x1          # 004f5bbf
    mov dword ptr [ebp - local_bytes_done], 0x0          # 004f5bc6
    mov dword ptr [ebp - local_sgned], 0x1          # 004f5bcd
    mov dword ptr [ebp - local_word], 0x2          # 004f5bd4
    mov edx, dword ptr [ebp - local_entry]           # 004f5bdb
    {load} xor eax, eax                          # 004f5bde
    mov ax, word ptr [edx + entry_sample_bits]               # 004f5be0
    cmp eax, 0x8                                 # 004f5be7
    jne.d8 L_after_width_select                            # 004f5bea
    # block 0x004f5bec: entry+0x2ed == 8: sgned=0, word=1 (8-bit unsigned output)
    mov dword ptr [ebp - local_sgned], 0x0          # 004f5bec
    mov dword ptr [ebp - local_word], 0x1          # 004f5bf3
L_after_width_select:
    # block 0x004f5bfa: trace level word at 0x0063a4cd (signed); if it != 2 skip the start trace
    movsx ecx, word ptr [0x63a4cd]               # 004f5bfa
    cmp ecx, 0x2                                 # 004f5c01
    jne.d8 L_decode_loop                            # 004f5c04
    # block 0x004f5c06: trace level 2: format the start message with the sound index (FUN_0050ca3e into 0x0063888b) and emit it with FUN_0044a2b7
    mov edx, dword ptr [ebp + arg_sound_index]             # 004f5c06
    push edx                                     # 004f5c09
    push 0x55e63c                                # 004f5c0a
    push 0x63888b                                # 004f5c0f
    call FUN_0050ca3e                            # 004f5c14
    add esp, 0xc                                 # 004f5c19
    push 0x63888b                                # 004f5c1c
    call FUN_0044a2b7                            # 004f5c21
    add esp, 0x4                                 # 004f5c26
L_decode_loop:
    # block 0x004f5c29: decode loop head: leave when bytes_done >= byte count (signed)
    mov eax, dword ptr [ebp - local_bytes_done]          # 004f5c29
    cmp eax, dword ptr [ebp + arg_byte_count]            # 004f5c2c
    jge.d32 L_decode_done                           # 004f5c2f
    # block 0x004f5c35: leave when last_read == 0
    cmp dword ptr [ebp - local_last_read], 0x0          # 004f5c35
    je.d32 L_decode_done                            # 004f5c39
    # block 0x004f5c3f: call FUN_004fe2d0(vf, dest+bytes_done, count-bytes_done, 0, word, sgned, &bitstream_out), pop 0x1c; last_read = eax; if last_read < 0 (signed) go to the error path
    lea ecx, [ebp - local_bitstream_out]                    # 004f5c3f
    push ecx                                     # 004f5c42
    mov edx, dword ptr [ebp - local_sgned]          # 004f5c43
    push edx                                     # 004f5c46
    mov eax, dword ptr [ebp - local_word]          # 004f5c47
    push eax                                     # 004f5c4a
    push 0x0                                     # 004f5c4b
    mov ecx, dword ptr [ebp + arg_byte_count]            # 004f5c4d
    sub ecx, dword ptr [ebp - local_bytes_done]          # 004f5c50
    push ecx                                     # 004f5c53
    mov edx, dword ptr [ebp + arg_dest]             # 004f5c54
    add edx, dword ptr [ebp - local_bytes_done]          # 004f5c57
    push edx                                     # 004f5c5a
    mov eax, dword ptr [ebp - local_vf]          # 004f5c5b
    push eax                                     # 004f5c5e
    call FUN_004fe2d0                            # 004f5c5f
    add esp, 0x1c                                # 004f5c64
    mov dword ptr [ebp - local_last_read], eax          # 004f5c67
    cmp dword ptr [ebp - local_last_read], 0x0          # 004f5c6a
    jl.d8 L_decode_error                             # 004f5c6e
    # block 0x004f5c70: last_read >= 0: if bitstream_out != 0 go to the error path, else continue at the ok path
    cmp dword ptr [ebp - local_bitstream_out], 0x0          # 004f5c70
    je.d8 L_decode_ok                             # 004f5c74
L_decode_error:
    # block 0x004f5c76: error path: read the trace level; if it is 0 skip the message
    movsx ecx, word ptr [0x63a4cd]               # 004f5c76
    test ecx, ecx                                # 004f5c7d
    je.d8 L_decode_error_status                             # 004f5c7f
    # block 0x004f5c81: format the corrupted-with-error-number message (name = entry+4, error = last_read) into 0x0063888b and emit it
    mov edx, dword ptr [ebp - local_last_read]          # 004f5c81
    push edx                                     # 004f5c84
    mov eax, dword ptr [ebp + arg_sound_index]             # 004f5c85
    imul eax, eax, 0x5bb                         # 004f5c88
    mov ecx, dword ptr [ebp - local_this]          # 004f5c8e
    mov edx, dword ptr [ecx + this_entry_table]             # 004f5c91
    lea eax, [edx + eax + entry_name]                   # 004f5c97
    push eax                                     # 004f5c9b
    push 0x55e680                                # 004f5c9c
    push 0x63888b                                # 004f5ca1
    call FUN_0050ca3e                            # 004f5ca6
    add esp, 0x10                                # 004f5cab
    push 0x63888b                                # 004f5cae
    call FUN_0044a2b7                            # 004f5cb3
    add esp, 0x4                                 # 004f5cb8
L_decode_error_status:
    # block 0x004f5cbb: this+0x3c2 = 0x3ec; return -1
    mov ecx, dword ptr [ebp - local_this]          # 004f5cbb
    mov dword ptr [ecx + this_status], 0x3ec           # 004f5cbe
    or eax, -0x1                                 # 004f5cc8
    jmp.d32 L_epilogue                           # 004f5ccb
L_decode_ok:
    # block 0x004f5cd0: ok path: if last_read != 0 skip the restart
    cmp dword ptr [ebp - local_last_read], 0x0          # 004f5cd0
    jne.d8 L_decode_accumulate                            # 004f5cd4
    # block 0x004f5cd6: last_read == 0 (converter produced nothing): call FUN_004fdc70(vf, 0, 0), pop 0xc
    push 0x0                                     # 004f5cd6
    push 0x0                                     # 004f5cd8
    mov edx, dword ptr [ebp - local_vf]          # 004f5cda
    push edx                                     # 004f5cdd
    call FUN_004fdc70                            # 004f5cde
    add esp, 0xc                                 # 004f5ce3
L_decode_accumulate:
    # block 0x004f5ce6: bytes_done += last_read; loop again
    mov eax, dword ptr [ebp - local_bytes_done]          # 004f5ce6
    add eax, dword ptr [ebp - local_last_read]          # 004f5ce9
    mov dword ptr [ebp - local_bytes_done], eax          # 004f5cec
    jmp.d32 L_decode_loop                           # 004f5cef
L_decode_done:
    # block 0x004f5cf4: loop exit: local_result = bytes_done; if trace level != 2 skip the finish trace
    mov ecx, dword ptr [ebp - local_bytes_done]          # 004f5cf4
    mov dword ptr [ebp - local_result], ecx           # 004f5cf7
    movsx edx, word ptr [0x63a4cd]               # 004f5cfa
    cmp edx, 0x2                                 # 004f5d01
    jne.d8 L_return_result_a                            # 004f5d04
    # block 0x004f5d06: trace level 2: format the finish message (index, bytes_done) and emit it
    mov eax, dword ptr [ebp - local_bytes_done]          # 004f5d06
    push eax                                     # 004f5d09
    mov ecx, dword ptr [ebp + arg_sound_index]             # 004f5d0a
    push ecx                                     # 004f5d0d
    push 0x55e6c8                                # 004f5d0e
    push 0x63888b                                # 004f5d13
    call FUN_0050ca3e                            # 004f5d18
    add esp, 0x10                                # 004f5d1d
    push 0x63888b                                # 004f5d20
    call FUN_0044a2b7                            # 004f5d25
    add esp, 0x4                                 # 004f5d2a
L_return_result_a:
    # block 0x004f5d2d: jump to the common result return
    jmp.d32 L_return_result                           # 004f5d2d
L_check_raw_codec:
    # block 0x004f5d32: codec != 2: reload codec word entry+0x126; if it != 1 go to the unknown-codec path
    mov edx, dword ptr [ebp - local_entry]           # 004f5d32
    movsx eax, word ptr [edx + entry_codec_id]            # 004f5d35
    cmp eax, 0x1                                 # 004f5d3c
    jne.d32 L_unknown_codec                           # 004f5d3f
    # block 0x004f5d45: codec 1: call FUN_0050cf61(dest, 1, count, entry+0x156 stream), pop 0x10; local_result = eax; if it equals the requested count go to the result return
    mov ecx, dword ptr [ebp - local_entry]           # 004f5d45
    mov edx, dword ptr [ecx + entry_file_stream]             # 004f5d48
    push edx                                     # 004f5d4e
    mov eax, dword ptr [ebp + arg_byte_count]            # 004f5d4f
    push eax                                     # 004f5d52
    push 0x1                                     # 004f5d53
    mov ecx, dword ptr [ebp + arg_dest]             # 004f5d55
    push ecx                                     # 004f5d58
    call FUN_0050cf61                            # 004f5d59
    add esp, 0x10                                # 004f5d5e
    mov dword ptr [ebp - local_result], eax           # 004f5d61
    mov edx, dword ptr [ebp - local_result]           # 004f5d64
    cmp edx, dword ptr [ebp + arg_byte_count]            # 004f5d67
    je.d32 L_return_result_b                            # 004f5d6a
    # block 0x004f5d70: short read: stream dword +0x0c & 0x20; if nonzero go to the read-error path
    mov eax, dword ptr [ebp - local_entry]           # 004f5d70
    mov ecx, dword ptr [eax + entry_file_stream]             # 004f5d73
    mov edx, dword ptr [ecx + file_flags]               # 004f5d79
    and edx, 0x20                                # 004f5d7c
    test edx, edx                                # 004f5d7f
    jne.d8 L_raw_read_error                            # 004f5d81
    # block 0x004f5d83: flag 0x20 clear: stream dword +0x0c & 0x10; if nonzero go to the end-of-file path (not an error)
    mov eax, dword ptr [ebp - local_entry]           # 004f5d83
    mov ecx, dword ptr [eax + entry_file_stream]             # 004f5d86
    mov edx, dword ptr [ecx + file_flags]               # 004f5d8c
    and edx, 0x10                                # 004f5d8f
    test edx, edx                                # 004f5d92
    jne.d8 L_raw_read_eof                            # 004f5d94
L_raw_read_error:
    # block 0x004f5d96: read-error path: if the trace level word is 0 skip the message
    movsx eax, word ptr [0x63a4cd]               # 004f5d96
    test eax, eax                                # 004f5d9d
    je.d8 L_raw_read_error_status                             # 004f5d9f
    # block 0x004f5da1: format the corrupted-file message (name = entry+4) into 0x0063888b and emit it
    mov ecx, dword ptr [ebp + arg_sound_index]             # 004f5da1
    imul ecx, ecx, 0x5bb                         # 004f5da4
    mov edx, dword ptr [ebp - local_this]          # 004f5daa
    mov eax, dword ptr [edx + this_entry_table]             # 004f5dad
    lea ecx, [eax + ecx + entry_name]                   # 004f5db3
    push ecx                                     # 004f5db7
    push 0x55e718                                # 004f5db8
    push 0x63888b                                # 004f5dbd
    call FUN_0050ca3e                            # 004f5dc2
    add esp, 0xc                                 # 004f5dc7
    push 0x63888b                                # 004f5dca
    call FUN_0044a2b7                            # 004f5dcf
    add esp, 0x4                                 # 004f5dd4
L_raw_read_error_status:
    # block 0x004f5dd7: this+0x3c2 = 0x3ec; return -1
    mov edx, dword ptr [ebp - local_this]          # 004f5dd7
    mov dword ptr [edx + this_status], 0x3ec           # 004f5dda
    or eax, -0x1                                 # 004f5de4
    jmp.d8 L_epilogue                            # 004f5de7
L_raw_read_eof:
    # block 0x004f5de9: end-of-file flag set: call FUN_0050ce2b(stream, 0x1e, 0), pop 0xc; fall into the result return with the short count
    push 0x0                                     # 004f5de9
    push 0x1e                                    # 004f5deb
    mov eax, dword ptr [ebp - local_entry]           # 004f5ded
    mov ecx, dword ptr [eax + entry_file_stream]             # 004f5df0
    push ecx                                     # 004f5df6
    call FUN_0050ce2b                            # 004f5df7
    add esp, 0xc                                 # 004f5dfc
L_return_result_b:
    # block 0x004f5dff: jump to the common result return
    jmp.d8 L_return_result                            # 004f5dff
L_unknown_codec:
    # block 0x004f5e01: codec is neither 2 nor 1: if the trace level word is 0 skip the report
    movsx edx, word ptr [0x63a4cd]               # 004f5e01
    test edx, edx                                # 004f5e08
    je.d8 L_unknown_codec_status                             # 004f5e0a
    # block 0x004f5e0c: call FUN_0052139c(format 0x0055e754, 0, 0); the call site pops nothing afterwards
    push 0x0                                     # 004f5e0c
    push 0x0                                     # 004f5e0e
    push 0x55e754                                # 004f5e10
    call FUN_0052139c                            # 004f5e15
L_unknown_codec_status:
    # block 0x004f5e1a: this+0x3c2 = 0x3f9; return -1
    mov eax, dword ptr [ebp - local_this]          # 004f5e1a
    mov dword ptr [eax + this_status], 0x3f9           # 004f5e1d
    or eax, -0x1                                 # 004f5e27
    jmp.d8 L_epilogue                            # 004f5e2a
L_return_result:
    # block 0x004f5e2c: return local_result
    mov eax, dword ptr [ebp - local_result]           # 004f5e2c
L_epilogue:
    # block 0x004f5e2f: epilogue: restore esp/ebp and ret 0xc
    {load} mov esp, ebp                          # 004f5e2f
    pop ebp                                      # 004f5e31
    ret 0xc                                      # 004f5e32
