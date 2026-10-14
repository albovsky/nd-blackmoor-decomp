# FUN_00434025
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00434025
# extent:       0x00434025-0x0043423d (536 code bytes)
# span:         0x00434025-0x0043423d (code 536, tables 0, padding 0)
# sha256:       1c8b47dd0818cbee7e5cf51258be5e791f8dcf6f991b0dc31cec6646c63067e1
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# name:         CHiff::index_chunks
# arguments:    thiscall: ecx=this (spilled); no stack arguments; plain ret; no return value
# locals:       [ebp-4]=index of the nested DATA record found by the pointer search (initialised 0, never reset between records or iterations); [ebp-8]=declared DATA length (big-endian dword after the marker); [ebp-0xc]=current chunk payload size (rounded up to even); [ebp-0x10]=inner search index; [ebp-0x14]=DATA record index; [ebp-0x18]=cursor pointer; [ebp-0x1c]=bytes consumed counter (starts 5); [ebp-0x20]=saved this; edi saved and restored
# fields:       this+0x5f64: DATA count (read); this+0x1144[n]: DATA marker pointers (read); this+0x3084[n]: DATA extents (read); this+0x20e4[n]: flat chunk header pointer table (written); this+0x5f68: chunk count, reset to 0 at entry and incremented per chunk; globals 0x00545e7c: the 4-character DATA marker string used for its strlen; 0x00583979 and 0x005cf659: objects passed in ecx to the error and quit routines
# callees:      FUN_004347b8 = read big-endian dword at a pointer (stack arg, thiscall); FUN_00434773 = CHiff::is_data_signature (returns 1 when the four bytes are DATA); FUN_0042639d = report error (message, caller name); FUN_004c97b4 = post quit message
# track-n:      outputs/blackmoor-decomp/src/hiff.c:index_chunks
# unverified:   the name CHiff::index_chunks was chosen by the annotator (the error strings in the binary call this routine CreateChunkDatabase); after a DATA record smaller than 9 bytes or after exceeding 0x3e6 chunks the original reports the error and calls the quit routine but then continues (no early return); Track N rejects instead; when the nested-DATA pointer search finds no matching marker the stale nested index (initially 0) is used, which the native code treats as a format error; the meaning of the initial consumed value 5 is not established beyond the arithmetic; the chunk reads are not bounds checked against the resource end; after skipping one nested DATA the code falls straight into chunk insertion without rechecking the next header (the behaviour described in boot-scene-recovery.md and mirrored in the Track N comment); DATA-too-small test uses an unsigned compare against 8 whereas the Track N text says smaller than 9 (equivalent)
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_nested_index, 0x4  # [ebp - 0x4]
.equ local_data_length, 0x8  # [ebp - 0x8]
.equ local_payload_size, 0xc  # [ebp - 0xc]
.equ local_search_index, 0x10  # [ebp - 0x10]
.equ local_data_index, 0x14  # [ebp - 0x14]
.equ local_cursor, 0x18  # [ebp - 0x18]
.equ local_consumed, 0x1c  # [ebp - 0x1c]
.equ local_saved_this, 0x20  # [ebp - 0x20]

.equ field_1144, 0x1144  # offset
.equ field_20e4, 0x20e4  # offset
.equ field_3084, 0x3084  # offset
.equ field_5f64, 0x5f64  # offset
.equ field_5f68, 0x5f68  # offset

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_00434773, .text + (0x00434773 - 0x401000)
.set FUN_004347b8, .text + (0x004347b8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x00434025 - 0x401000
.globl FUN_00434025
FUN_00434025:
    # block 0x00434025: function entry: build frame, spill this, chunk count this+0x5f68 = 0, nested_index = 0, data_index = 0, jump to L_data_test
    push ebp                                     # 00434025
    {load} mov ebp, esp                          # 00434026
    sub esp, 0x20                                # 00434028
    push edi                                     # 0043402b
    mov dword ptr [ebp - local_saved_this], ecx          # 0043402c
    mov eax, dword ptr [ebp - local_saved_this]          # 0043402f
    mov dword ptr [eax + field_5f68], 0x0            # 00434032
    mov dword ptr [ebp - local_nested_index], 0x0           # 0043403c
    mov dword ptr [ebp - local_data_index], 0x0          # 00434043
    jmp.d8 L_data_test                            # 0043404a
L_next_data:
    # block 0x0043404c: L_next_data: data_index + 1
    mov ecx, dword ptr [ebp - local_data_index]          # 0043404c
    add ecx, 0x1                                 # 0043404f
    mov dword ptr [ebp - local_data_index], ecx          # 00434052
L_data_test:
    # block 0x00434055: L_data_test: signed compare data_index with the DATA count this+0x5f64; index >= count goes to L_return
    mov edx, dword ptr [ebp - local_saved_this]          # 00434055
    mov eax, dword ptr [ebp - local_data_index]          # 00434058
    cmp eax, dword ptr [edx + field_5f64]            # 0043405b
    jge.d32 L_return                           # 00434061
    # block 0x00434067: load marker pointer this+0x1144[data_index], add the marker string length (4) to get the length field, read the declared length (big-endian) into data_length; length above 8 (unsigned) continues to L_data_size_ok
    mov ecx, dword ptr [ebp - local_data_index]          # 00434067
    mov edx, dword ptr [ebp - local_saved_this]          # 0043406a
    mov eax, dword ptr [edx + 4*ecx + field_1144]    # 0043406d
    mov dword ptr [ebp - local_cursor], eax          # 00434074
    mov edi, 0x545e7c                            # 00434077
    or ecx, -0x1                                 # 0043407c
    {load} xor eax, eax                          # 0043407f
    repne scasb al, byte ptr es:[edi]            # 00434081
    not ecx                                      # 00434083
    add ecx, -0x1                                # 00434085
    mov edx, dword ptr [ebp - local_cursor]          # 00434088
    {load} add edx, ecx                          # 0043408b
    mov dword ptr [ebp - local_cursor], edx          # 0043408d
    mov eax, dword ptr [ebp - local_cursor]          # 00434090
    push eax                                     # 00434093
    mov ecx, dword ptr [ebp - local_saved_this]          # 00434094
    call FUN_004347b8                            # 00434097
    mov dword ptr [ebp - local_data_length], eax           # 0043409c
    cmp dword ptr [ebp - local_data_length], 0x8           # 0043409f
    ja.d8 L_data_size_ok                             # 004340a3
    # block 0x004340a5: data_length <= 8: report 'DATA is too small' through FUN_0042639d and call the quit routine, then fall through
    push 0x545e84                                # 004340a5
    push 0x545e98                                # 004340aa
    mov ecx, 0x583979                            # 004340af
    call FUN_0042639d                            # 004340b4
    mov ecx, 0x5cf659                            # 004340b9
    call FUN_004c97b4                            # 004340be
L_data_size_ok:
    # block 0x004340c3: L_data_size_ok: cursor += 4 twice (skip length field and type field, now at the first chunk), consumed = 5
    mov ecx, dword ptr [ebp - local_cursor]          # 004340c3
    add ecx, 0x4                                 # 004340c6
    mov dword ptr [ebp - local_cursor], ecx          # 004340c9
    mov edx, dword ptr [ebp - local_cursor]          # 004340cc
    add edx, 0x4                                 # 004340cf
    mov dword ptr [ebp - local_cursor], edx          # 004340d2
    mov dword ptr [ebp - local_consumed], 0x5          # 004340d5
L_chunk_loop:
    # block 0x004340dc: L_chunk_loop: constant-true loop head (mov eax,1 / test / je to L_data_done)
    mov eax, 0x1                                 # 004340dc
    test eax, eax                                # 004340e1
    je.d32 L_data_done                            # 004340e3
    # block 0x004340e9: call FUN_00434773 on cursor; a result other than 1 (not a DATA signature) goes to L_insert_chunk
    mov ecx, dword ptr [ebp - local_cursor]          # 004340e9
    push ecx                                     # 004340ec
    mov ecx, dword ptr [ebp - local_saved_this]          # 004340ed
    call FUN_00434773                            # 004340f0
    cmp eax, 0x1                                 # 004340f5
    jne.d8 L_insert_chunk                            # 004340f8
    # block 0x004340fa: nested DATA at cursor: search_index = 0
    mov dword ptr [ebp - local_search_index], 0x0          # 004340fa
    jmp.d8 L_search_test                            # 00434101
L_search_next:
    # block 0x00434103: L_search_next: search_index + 1
    mov edx, dword ptr [ebp - local_search_index]          # 00434103
    add edx, 0x1                                 # 00434106
    mov dword ptr [ebp - local_search_index], edx          # 00434109
L_search_test:
    # block 0x0043410c: L_search_test: search_index >= DATA count ends the search at L_nested_skip
    mov eax, dword ptr [ebp - local_saved_this]          # 0043410c
    mov ecx, dword ptr [ebp - local_search_index]          # 0043410f
    cmp ecx, dword ptr [eax + field_5f64]            # 00434112
    jge.d8 L_nested_skip                            # 00434118
    # block 0x0043411a: search_index != data_index (skip the current record) continues to L_search_compare
    mov edx, dword ptr [ebp - local_search_index]          # 0043411a
    cmp edx, dword ptr [ebp - local_data_index]          # 0043411d
    jne.d8 L_search_compare                            # 00434120
    # block 0x00434122: search_index == data_index: go straight to L_search_next
    jmp.d8 L_search_next                            # 00434122
L_search_compare:
    # block 0x00434124: L_search_compare: DATA marker pointer this+0x1144[search_index] compared with cursor; not equal goes to L_search_continue
    mov eax, dword ptr [ebp - local_search_index]          # 00434124
    mov ecx, dword ptr [ebp - local_saved_this]          # 00434127
    mov edx, dword ptr [ecx + 4*eax + field_1144]    # 0043412a
    cmp edx, dword ptr [ebp - local_cursor]          # 00434131
    jne.d8 L_search_continue                            # 00434134
    # block 0x00434136: match: nested_index = search_index and leave the search for L_nested_skip
    mov eax, dword ptr [ebp - local_search_index]          # 00434136
    mov dword ptr [ebp - local_nested_index], eax           # 00434139
    jmp.d8 L_nested_skip                            # 0043413c
L_search_continue:
    # block 0x0043413e: L_search_continue: go to L_search_next
    jmp.d8 L_search_next                            # 0043413e
L_nested_skip:
    # block 0x00434140: L_nested_skip: cursor += this+0x3084[nested_index] and consumed += the same extent; consumed below data_length (unsigned) continues to L_insert_chunk
    mov ecx, dword ptr [ebp - local_nested_index]           # 00434140
    mov edx, dword ptr [ebp - local_saved_this]          # 00434143
    mov eax, dword ptr [ebp - local_cursor]          # 00434146
    add eax, dword ptr [edx + 4*ecx + field_3084]    # 00434149
    mov dword ptr [ebp - local_cursor], eax          # 00434150
    mov ecx, dword ptr [ebp - local_nested_index]           # 00434153
    mov edx, dword ptr [ebp - local_saved_this]          # 00434156
    mov eax, dword ptr [ebp - local_consumed]          # 00434159
    add eax, dword ptr [edx + 4*ecx + field_3084]    # 0043415c
    mov dword ptr [ebp - local_consumed], eax          # 00434163
    mov ecx, dword ptr [ebp - local_consumed]          # 00434166
    cmp ecx, dword ptr [ebp - local_data_length]           # 00434169
    jb.d8 L_insert_chunk                             # 0043416c
    # block 0x0043416e: consumed >= data_length: this DATA record is finished, go to L_data_done
    jmp.d32 L_data_done                           # 0043416e
L_insert_chunk:
    # block 0x00434173: L_insert_chunk: signed compare chunk count this+0x5f68 with 0x3e6; at most 0x3e6 skips the error report
    mov edx, dword ptr [ebp - local_saved_this]          # 00434173
    cmp dword ptr [edx + field_5f68], 0x3e6          # 00434176
    jle.d8 L_store_chunk                            # 00434180
    # block 0x00434182: chunk count above 0x3e6: report 'too many CHUNKs' through FUN_0042639d and call the quit routine, then fall through
    push 0x545ebc                                # 00434182
    push 0x545ed0                                # 00434187
    mov ecx, 0x583979                            # 0043418c
    call FUN_0042639d                            # 00434191
    mov ecx, 0x5cf659                            # 00434196
    call FUN_004c97b4                            # 0043419b
L_store_chunk:
    # block 0x004341a0: L_store_chunk: this+0x20e4[chunk count] = cursor, chunk count + 1; cursor += 4 and consumed += 4; payload_size = big-endian dword at cursor; if bit 0 of payload_size is clear go to L_after_size
    mov eax, dword ptr [ebp - local_saved_this]          # 004341a0
    mov ecx, dword ptr [eax + field_5f68]            # 004341a3
    mov edx, dword ptr [ebp - local_saved_this]          # 004341a9
    mov eax, dword ptr [ebp - local_cursor]          # 004341ac
    mov dword ptr [edx + 4*ecx + field_20e4], eax    # 004341af
    mov ecx, dword ptr [ebp - local_saved_this]          # 004341b6
    mov edx, dword ptr [ecx + field_5f68]            # 004341b9
    add edx, 0x1                                 # 004341bf
    mov eax, dword ptr [ebp - local_saved_this]          # 004341c2
    mov dword ptr [eax + field_5f68], edx            # 004341c5
    mov ecx, dword ptr [ebp - local_cursor]          # 004341cb
    add ecx, 0x4                                 # 004341ce
    mov dword ptr [ebp - local_cursor], ecx          # 004341d1
    mov edx, dword ptr [ebp - local_consumed]          # 004341d4
    add edx, 0x4                                 # 004341d7
    mov dword ptr [ebp - local_consumed], edx          # 004341da
    mov eax, dword ptr [ebp - local_cursor]          # 004341dd
    push eax                                     # 004341e0
    mov ecx, dword ptr [ebp - local_saved_this]          # 004341e1
    call FUN_004347b8                            # 004341e4
    mov dword ptr [ebp - local_payload_size], eax           # 004341e9
    mov ecx, dword ptr [ebp - local_payload_size]           # 004341ec
    and ecx, 0x1                                 # 004341ef
    cmp ecx, 0x1                                 # 004341f2
    jne.d8 L_after_size                            # 004341f5
    # block 0x004341f7: payload_size odd: payload_size + 1 (pad to even)
    mov edx, dword ptr [ebp - local_payload_size]           # 004341f7
    add edx, 0x1                                 # 004341fa
    mov dword ptr [ebp - local_payload_size], edx           # 004341fd
L_after_size:
    # block 0x00434200: L_after_size: cursor += 4, consumed += 4, then cursor += payload_size and consumed += payload_size; consumed <= data_length (unsigned) continues to L_chunk_continue
    mov eax, dword ptr [ebp - local_cursor]          # 00434200
    add eax, 0x4                                 # 00434203
    mov dword ptr [ebp - local_cursor], eax          # 00434206
    mov ecx, dword ptr [ebp - local_consumed]          # 00434209
    add ecx, 0x4                                 # 0043420c
    mov dword ptr [ebp - local_consumed], ecx          # 0043420f
    mov edx, dword ptr [ebp - local_cursor]          # 00434212
    add edx, dword ptr [ebp - local_payload_size]           # 00434215
    mov dword ptr [ebp - local_cursor], edx          # 00434218
    mov eax, dword ptr [ebp - local_consumed]          # 0043421b
    add eax, dword ptr [ebp - local_payload_size]           # 0043421e
    mov dword ptr [ebp - local_consumed], eax          # 00434221
    mov ecx, dword ptr [ebp - local_consumed]          # 00434224
    cmp ecx, dword ptr [ebp - local_data_length]           # 00434227
    jbe.d8 L_chunk_continue                            # 0043422a
    # block 0x0043422c: consumed > data_length: this DATA record is finished, go to L_data_done
    jmp.d8 L_data_done                            # 0043422c
L_chunk_continue:
    # block 0x0043422e: L_chunk_continue: back to L_chunk_loop for the next chunk
    jmp.d32 L_chunk_loop                           # 0043422e
L_data_done:
    # block 0x00434233: L_data_done: go to L_next_data for the next DATA record
    jmp.d32 L_next_data                           # 00434233
L_return:
    # block 0x00434238: L_return: restore edi, tear down the frame, plain ret
    pop edi                                      # 00434238
    {load} mov esp, ebp                          # 00434239
    pop ebp                                      # 0043423b
    ret                                          # 0043423c
