# FUN_004343a2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004343a2
# extent:       0x004343a2-0x004344bf (285 code bytes)
# span:         0x004343a2-0x004344bf (code 285, tables 0, padding 0)
# sha256:       42bc2851f2cbbfc26f27ab7df384e93cdea9de4afed171578553f362fd12366c
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# name:         CHiff::select_chunk_by_id
# arguments:    thiscall: ecx=this (spilled); [ebp+8]=arg_id_name NUL-terminated chunk ID to find (case-sensitive); callee pops 4 (ret 4); returns eax = 1 when a chunk was selected, 0 when none matched
# locals:       [ebp-4]=cursor, starts at the chunk header pointer and is advanced by 4 twice to the payload; [ebp-8]=chunk index; [ebp-0xc]=pointer to the static 4-char name buffer returned by FUN_00434814; [ebp-0x10]=saved this; [ebp-0x14]=inline strcmp cursor in arg_id_name; [ebp-0x18]=inline strcmp cursor in the name buffer; [ebp-0x19], [ebp-0x1a]=the two bytes held across one comparison step; [ebp-0x20]=strcmp result (0 equal, otherwise 1 or -1 via sbb); [ebp-0x24]=copy of the result; esi/edi saved and restored
# fields:       this+0x5f68: chunk count (read); this+0x20e4[n]: flat chunk header pointers (read); this+0x1120: selected chunk payload pointer = header + 8 (written on a match only); this+0x112c: selected chunk payload length, big-endian dword at header + 4 (written on a match only); this+0x1130: selected chunk name buffer, copied with its NUL (written on a match only); the used-flag table at this+0x4fc4 is not touched
# callees:      FUN_00434814 = CHiff::copy_fourcc_static (copy up to four non-NUL bytes to the static buffer at 0x0063a590, NUL terminate, return its address); FUN_004347b8 = read big-endian dword at a pointer (stack arg, thiscall)
# track-n:      outputs/blackmoor-decomp/src/hiff.c:hiff_select_chunk
# unverified:   the inline pairwise compare is the CRT strcmp expansion (name_buf byte versus argument byte, two bytes per step, stopping at a mismatch or NUL) and only its zero versus non-zero outcome is used, so the sign of a non-zero result is not verified to matter; the chunk length read at header+4 and the name read at header+0 are not bounds checked (the tables are built by FUN_00434025); the static name buffer at 0x0063a590 is a shared global and its reuse between calls is not analysed; a failed selection leaves this+0x1120, 0x112c and 0x1130 unchanged
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_cursor, 0x4  # [ebp - 0x4]
.equ local_chunk_index, 0x8  # [ebp - 0x8]
.equ local_name_buf, 0xc  # [ebp - 0xc]
.equ local_saved_this, 0x10  # [ebp - 0x10]
.equ local_arg_cursor, 0x14  # [ebp - 0x14]
.equ local_name_cursor, 0x18  # [ebp - 0x18]
.equ local_byte0, 0x19  # [ebp - 0x19]
.equ local_byte1, 0x1a  # [ebp - 0x1a]
.equ local_cmp, 0x20  # [ebp - 0x20]
.equ local_cmp_copy, 0x24  # [ebp - 0x24]
.equ arg_id_name, 0x8  # [ebp + 0x8]

.equ str_second_byte, 0x1  # string+1: second byte of each compared string (inline strcmp pair step)
.equ hiff_chunk_payload_ptr, 0x1120  # CHiff+0x1120: selected chunk payload pointer, zeroed
.equ hiff_chunk_payload_len, 0x112c  # CHiff+0x112c: selected chunk payload length, zeroed
.equ hiff_chunk_ptr_table, 0x20e4  # CHiff+0x20e4: flat table of chunk header pointers
.equ hiff_chunk_count, 0x5f68  # CHiff+0x5f68: chunk count

# --- external targets -----------------------------------------------
.set FUN_004347b8, .text + (0x004347b8 - 0x401000)
.set FUN_00434814, .text + (0x00434814 - 0x401000)

.org 0x004343a2 - 0x401000
.globl FUN_004343a2
FUN_004343a2:
    # block 0x004343a2: function entry: build frame, spill this, chunk_index = 0, jump to L_chunk_test
    push ebp                                     # 004343a2
    {load} mov ebp, esp                          # 004343a3
    sub esp, 0x24                                # 004343a5
    push esi                                     # 004343a8
    push edi                                     # 004343a9
    mov dword ptr [ebp - local_saved_this], ecx          # 004343aa
    mov dword ptr [ebp - local_chunk_index], 0x0           # 004343ad
    jmp.d8 L_chunk_test                            # 004343b4
L_next_chunk:
    # block 0x004343b6: L_next_chunk: chunk_index + 1
    mov eax, dword ptr [ebp - local_chunk_index]           # 004343b6
    add eax, 0x1                                 # 004343b9
    mov dword ptr [ebp - local_chunk_index], eax           # 004343bc
L_chunk_test:
    # block 0x004343bf: L_chunk_test: signed compare chunk_index with the chunk count this+0x5f68; index >= count goes to L_not_found
    mov ecx, dword ptr [ebp - local_saved_this]          # 004343bf
    mov edx, dword ptr [ebp - local_chunk_index]           # 004343c2
    cmp edx, dword ptr [ecx + hiff_chunk_count]            # 004343c5
    jge.d32 L_not_found                           # 004343cb
    # block 0x004343d1: cursor = chunk header pointer this+0x20e4[chunk_index]; name_buf = FUN_00434814(cursor) (static copy of the 4-byte ID); arg cursor = arg_id_name, name cursor = name_buf
    mov eax, dword ptr [ebp - local_chunk_index]           # 004343d1
    mov ecx, dword ptr [ebp - local_saved_this]          # 004343d4
    mov edx, dword ptr [ecx + 4*eax + hiff_chunk_ptr_table]    # 004343d7
    mov dword ptr [ebp - local_cursor], edx           # 004343de
    mov eax, dword ptr [ebp - local_cursor]           # 004343e1
    push eax                                     # 004343e4
    mov ecx, dword ptr [ebp - local_saved_this]          # 004343e5
    call FUN_00434814                            # 004343e8
    mov dword ptr [ebp - local_name_buf], eax           # 004343ed
    mov ecx, dword ptr [ebp + arg_id_name]             # 004343f0
    mov dword ptr [ebp - local_arg_cursor], ecx          # 004343f3
    mov edx, dword ptr [ebp - local_name_buf]           # 004343f6
    mov dword ptr [ebp - local_name_cursor], edx          # 004343f9
L_cmp_loop:
    # block 0x004343fc: L_cmp_loop: load a name_buf byte; unequal to the argument byte goes to L_differ
    mov eax, dword ptr [ebp - local_name_cursor]          # 004343fc
    mov cl, byte ptr [eax]                       # 004343ff
    mov byte ptr [ebp - local_byte0], cl            # 00434401
    mov edx, dword ptr [ebp - local_arg_cursor]          # 00434404
    cmp cl, byte ptr [edx]                       # 00434407
    jne.d8 L_differ                            # 00434409
    # block 0x0043440b: bytes equal: a NUL byte means both strings ended, go to L_equal
    cmp byte ptr [ebp - local_byte0], 0x0           # 0043440b
    je.d8 L_equal                             # 0043440f
    # block 0x00434411: compare the next byte pair; unequal goes to L_differ
    mov eax, dword ptr [ebp - local_name_cursor]          # 00434411
    mov cl, byte ptr [eax + str_second_byte]                 # 00434414
    mov byte ptr [ebp - local_byte1], cl            # 00434417
    mov edx, dword ptr [ebp - local_arg_cursor]          # 0043441a
    cmp cl, byte ptr [edx + str_second_byte]                 # 0043441d
    jne.d8 L_differ                            # 00434420
    # block 0x00434422: advance both cursors by 2; continue the loop while the second byte was not NUL, else fall into L_equal
    add dword ptr [ebp - local_name_cursor], 0x2          # 00434422
    add dword ptr [ebp - local_arg_cursor], 0x2          # 00434426
    cmp byte ptr [ebp - local_byte1], 0x0           # 0043442a
    jne.d8 L_cmp_loop                            # 0043442e
L_equal:
    # block 0x00434430: L_equal: strcmp result = 0, go to L_cmp_done
    mov dword ptr [ebp - local_cmp], 0x0          # 00434430
    jmp.d8 L_cmp_done                            # 00434437
L_differ:
    # block 0x00434439: L_differ: sbb eax,eax / sbb eax,-1 turn the carry of the failed unsigned byte compare into -1 (name_buf byte below the argument byte) or +1 (above); only zero versus non-zero is consumed
    {load} sbb eax, eax                          # 00434439
    sbb eax, -0x1                                # 0043443b
    mov dword ptr [ebp - local_cmp], eax          # 0043443e
L_cmp_done:
    # block 0x00434441: L_cmp_done: copy the result; non-zero goes to L_continue
    mov ecx, dword ptr [ebp - local_cmp]          # 00434441
    mov dword ptr [ebp - local_cmp_copy], ecx          # 00434444
    cmp dword ptr [ebp - local_cmp_copy], 0x0          # 00434447
    jne.d8 L_continue                            # 0043444b
    # block 0x0043444d: names equal: cursor += 4, this+0x112c = big-endian dword at cursor (payload length); cursor += 4, this+0x1120 = cursor (payload pointer); copy name_buf (strlen+1) to this+0x1130; return eax = 1 (jump to L_return)
    mov edx, dword ptr [ebp - local_cursor]           # 0043444d
    add edx, 0x4                                 # 00434450
    mov dword ptr [ebp - local_cursor], edx           # 00434453
    mov eax, dword ptr [ebp - local_cursor]           # 00434456
    push eax                                     # 00434459
    mov ecx, dword ptr [ebp - local_saved_this]          # 0043445a
    call FUN_004347b8                            # 0043445d
    mov ecx, dword ptr [ebp - local_saved_this]          # 00434462
    mov dword ptr [ecx + hiff_chunk_payload_len], eax            # 00434465
    mov edx, dword ptr [ebp - local_cursor]           # 0043446b
    add edx, 0x4                                 # 0043446e
    mov dword ptr [ebp - local_cursor], edx           # 00434471
    mov eax, dword ptr [ebp - local_saved_this]          # 00434474
    mov ecx, dword ptr [ebp - local_cursor]           # 00434477
    mov dword ptr [eax + hiff_chunk_payload_ptr], ecx            # 0043447a
    mov edi, dword ptr [ebp - local_name_buf]           # 00434480
    mov edx, dword ptr [ebp - local_saved_this]          # 00434483
    add edx, 0x1130                              # 00434486
    or ecx, -0x1                                 # 0043448c
    {load} xor eax, eax                          # 0043448f
    repne scasb al, byte ptr es:[edi]            # 00434491
    not ecx                                      # 00434493
    {load} sub edi, ecx                          # 00434495
    {load} mov esi, edi                          # 00434497
    {load} mov eax, ecx                          # 00434499
    {load} mov edi, edx                          # 0043449b
    shr ecx, 0x2                                 # 0043449d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004344a0
    {load} mov ecx, eax                          # 004344a2
    and ecx, 0x3                                 # 004344a4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004344a7
    mov eax, 0x1                                 # 004344a9
    jmp.d8 L_return                            # 004344ae
L_continue:
    # block 0x004344b0: L_continue: go to L_next_chunk to test the next chunk
    jmp.d32 L_next_chunk                           # 004344b0
L_not_found:
    # block 0x004344b5: L_not_found: eax = 0 (no match; selection fields untouched)
    {load} xor eax, eax                          # 004344b5
L_return:
    # block 0x004344b7: L_return: restore edi/esi, tear down the frame, ret 4
    pop edi                                      # 004344b7
    pop esi                                      # 004344b8
    {load} mov esp, ebp                          # 004344b9
    pop ebp                                      # 004344bb
    ret 0x4                                      # 004344bc
