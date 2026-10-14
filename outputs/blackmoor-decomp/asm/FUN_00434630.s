# FUN_00434630
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00434630
# extent:       0x00434630-0x00434773 (323 code bytes)
# span:         0x00434630-0x00434773 (code 323, tables 0, padding 0)
# sha256:       1e03e4187bcd2e6a2fd1ecc8e47bbf55df28e34663f22dedd203b2195dfd7a56
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# name:         CHiff::select_next_chunk
# arguments:    thiscall: ecx=this (spilled); [ebp+8]=arg_id_name NUL-terminated chunk ID to find (case-sensitive); callee pops 4 (ret 4); returns eax = 1 when an unused chunk was selected, 0 when none matched
# locals:       [ebp-4]=cursor, starts at the chunk header pointer and is advanced by 4 twice to the payload; [ebp-8]=chunk index; [ebp-0xc]=pointer to the static 4-char name buffer returned by FUN_00434814; [ebp-0x10]=saved this; [ebp-0x14]=inline strcmp cursor in arg_id_name; [ebp-0x18]=inline strcmp cursor in the name buffer; [ebp-0x19], [ebp-0x1a]=the two bytes held across one comparison step; [ebp-0x20]=strcmp result (0 equal, otherwise 1 or -1 via sbb); [ebp-0x24]=copy of the result; esi/edi saved and restored
# fields:       this+0x5f68: chunk count (read); this+0x20e4[n]: flat chunk header pointers (read); this+0x4fc4[n]: dword used flags, tested and then set to 1 on the selected entry (not cleared here); this+0x1120: selected chunk payload pointer = header + 8; this+0x112c: selected chunk payload length, big-endian dword at header + 4; this+0x1130: selected chunk name buffer, copied with its NUL (these three written on a match only)
# callees:      FUN_00434814 = CHiff::copy_fourcc_static (copy up to four non-NUL bytes to the static buffer at 0x0063a590, NUL terminate, return its address); FUN_004347b8 = read big-endian dword at a pointer (stack arg, thiscall)
# track-n:      outputs/blackmoor-decomp/src/hiff.c:hiff_select_next
# unverified:   the inline pairwise compare is the CRT strcmp expansion (name_buf byte versus argument byte, two bytes per step, stopping at a mismatch or NUL) and only its zero versus non-zero outcome is used, so the sign of a non-zero result is not verified to matter; the chunk length read at header+4 and the name read at header+0 are not bounds checked (the tables are built by FUN_00434025); the static name buffer at 0x0063a590 is a shared global and its reuse between calls is not analysed; a failed selection leaves this+0x1120, 0x112c and 0x1130 unchanged; the used flags are only ever set here and in FUN_004344bf and cleared in FUN_004344bf and the constructor; other writers were not searched for
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

.equ field_1, 0x1  # offset
.equ field_1120, 0x1120  # offset
.equ field_112c, 0x112c  # offset
.equ field_20e4, 0x20e4  # offset
.equ field_4fc4, 0x4fc4  # offset
.equ field_5f68, 0x5f68  # offset

# --- external targets -----------------------------------------------
.set FUN_004347b8, .text + (0x004347b8 - 0x401000)
.set FUN_00434814, .text + (0x00434814 - 0x401000)

.org 0x00434630 - 0x401000
.globl FUN_00434630
FUN_00434630:
    # block 0x00434630: function entry: build frame, spill this, chunk_index = 0, jump to L_chunk_test
    push ebp                                     # 00434630
    {load} mov ebp, esp                          # 00434631
    sub esp, 0x24                                # 00434633
    push esi                                     # 00434636
    push edi                                     # 00434637
    mov dword ptr [ebp - local_saved_this], ecx          # 00434638
    mov dword ptr [ebp - local_chunk_index], 0x0           # 0043463b
    jmp.d8 L_chunk_test                            # 00434642
L_next_chunk:
    # block 0x00434644: L_next_chunk: chunk_index + 1
    mov eax, dword ptr [ebp - local_chunk_index]           # 00434644
    add eax, 0x1                                 # 00434647
    mov dword ptr [ebp - local_chunk_index], eax           # 0043464a
L_chunk_test:
    # block 0x0043464d: L_chunk_test: signed compare chunk_index with the chunk count this+0x5f68; index >= count goes to L_not_found
    mov ecx, dword ptr [ebp - local_saved_this]          # 0043464d
    mov edx, dword ptr [ebp - local_chunk_index]           # 00434650
    cmp edx, dword ptr [ecx + field_5f68]            # 00434653
    jge.d32 L_not_found                           # 00434659
    # block 0x0043465f: cursor = chunk header pointer this+0x20e4[chunk_index]; name_buf = FUN_00434814(cursor); arg cursor = arg_id_name, name cursor = name_buf
    mov eax, dword ptr [ebp - local_chunk_index]           # 0043465f
    mov ecx, dword ptr [ebp - local_saved_this]          # 00434662
    mov edx, dword ptr [ecx + 4*eax + field_20e4]    # 00434665
    mov dword ptr [ebp - local_cursor], edx           # 0043466c
    mov eax, dword ptr [ebp - local_cursor]           # 0043466f
    push eax                                     # 00434672
    mov ecx, dword ptr [ebp - local_saved_this]          # 00434673
    call FUN_00434814                            # 00434676
    mov dword ptr [ebp - local_name_buf], eax           # 0043467b
    mov ecx, dword ptr [ebp + arg_id_name]             # 0043467e
    mov dword ptr [ebp - local_arg_cursor], ecx          # 00434681
    mov edx, dword ptr [ebp - local_name_buf]           # 00434684
    mov dword ptr [ebp - local_name_cursor], edx          # 00434687
L_cmp_loop:
    # block 0x0043468a: L_cmp_loop: load a name_buf byte; unequal to the argument byte goes to L_differ
    mov eax, dword ptr [ebp - local_name_cursor]          # 0043468a
    mov cl, byte ptr [eax]                       # 0043468d
    mov byte ptr [ebp - local_byte0], cl            # 0043468f
    mov edx, dword ptr [ebp - local_arg_cursor]          # 00434692
    cmp cl, byte ptr [edx]                       # 00434695
    jne.d8 L_differ                            # 00434697
    # block 0x00434699: bytes equal: a NUL byte means both strings ended, go to L_equal
    cmp byte ptr [ebp - local_byte0], 0x0           # 00434699
    je.d8 L_equal                             # 0043469d
    # block 0x0043469f: compare the next byte pair; unequal goes to L_differ
    mov eax, dword ptr [ebp - local_name_cursor]          # 0043469f
    mov cl, byte ptr [eax + field_1]                 # 004346a2
    mov byte ptr [ebp - local_byte1], cl            # 004346a5
    mov edx, dword ptr [ebp - local_arg_cursor]          # 004346a8
    cmp cl, byte ptr [edx + field_1]                 # 004346ab
    jne.d8 L_differ                            # 004346ae
    # block 0x004346b0: advance both cursors by 2; continue the loop while the second byte was not NUL, else fall into L_equal
    add dword ptr [ebp - local_name_cursor], 0x2          # 004346b0
    add dword ptr [ebp - local_arg_cursor], 0x2          # 004346b4
    cmp byte ptr [ebp - local_byte1], 0x0           # 004346b8
    jne.d8 L_cmp_loop                            # 004346bc
L_equal:
    # block 0x004346be: L_equal: strcmp result = 0, go to L_cmp_done
    mov dword ptr [ebp - local_cmp], 0x0          # 004346be
    jmp.d8 L_cmp_done                            # 004346c5
L_differ:
    # block 0x004346c7: L_differ: sbb eax,eax / sbb eax,-1 turn the carry of the failed unsigned byte compare into -1 (name_buf byte below the argument byte) or +1 (above); only zero versus non-zero is consumed
    {load} sbb eax, eax                          # 004346c7
    sbb eax, -0x1                                # 004346c9
    mov dword ptr [ebp - local_cmp], eax          # 004346cc
L_cmp_done:
    # block 0x004346cf: L_cmp_done: copy the result; non-zero goes to L_continue
    mov ecx, dword ptr [ebp - local_cmp]          # 004346cf
    mov dword ptr [ebp - local_cmp_copy], ecx          # 004346d2
    cmp dword ptr [ebp - local_cmp_copy], 0x0          # 004346d5
    jne.d32 L_continue                           # 004346d9
    # block 0x004346df: names equal: if this+0x4fc4[chunk_index] already equals 1 (chunk consumed earlier) go to L_continue
    mov edx, dword ptr [ebp - local_chunk_index]           # 004346df
    mov eax, dword ptr [ebp - local_saved_this]          # 004346e2
    cmp dword ptr [eax + 4*edx + field_4fc4], 0x1    # 004346e5
    je.d8 L_continue                             # 004346ed
    # block 0x004346ef: set this+0x4fc4[chunk_index] = 1; cursor += 4, this+0x112c = big-endian dword at cursor; cursor += 4, this+0x1120 = cursor; copy name_buf (strlen+1) to this+0x1130; return eax = 1 (jump to L_return)
    mov ecx, dword ptr [ebp - local_chunk_index]           # 004346ef
    mov edx, dword ptr [ebp - local_saved_this]          # 004346f2
    mov dword ptr [edx + 4*ecx + field_4fc4], 0x1    # 004346f5
    mov eax, dword ptr [ebp - local_cursor]           # 00434700
    add eax, 0x4                                 # 00434703
    mov dword ptr [ebp - local_cursor], eax           # 00434706
    mov ecx, dword ptr [ebp - local_cursor]           # 00434709
    push ecx                                     # 0043470c
    mov ecx, dword ptr [ebp - local_saved_this]          # 0043470d
    call FUN_004347b8                            # 00434710
    mov edx, dword ptr [ebp - local_saved_this]          # 00434715
    mov dword ptr [edx + field_112c], eax            # 00434718
    mov eax, dword ptr [ebp - local_cursor]           # 0043471e
    add eax, 0x4                                 # 00434721
    mov dword ptr [ebp - local_cursor], eax           # 00434724
    mov ecx, dword ptr [ebp - local_saved_this]          # 00434727
    mov edx, dword ptr [ebp - local_cursor]           # 0043472a
    mov dword ptr [ecx + field_1120], edx            # 0043472d
    mov edi, dword ptr [ebp - local_name_buf]           # 00434733
    mov eax, dword ptr [ebp - local_saved_this]          # 00434736
    add eax, 0x1130                              # 00434739
    {load} mov edx, eax                          # 0043473e
    or ecx, -0x1                                 # 00434740
    {load} xor eax, eax                          # 00434743
    repne scasb al, byte ptr es:[edi]            # 00434745
    not ecx                                      # 00434747
    {load} sub edi, ecx                          # 00434749
    {load} mov esi, edi                          # 0043474b
    {load} mov eax, ecx                          # 0043474d
    {load} mov edi, edx                          # 0043474f
    shr ecx, 0x2                                 # 00434751
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00434754
    {load} mov ecx, eax                          # 00434756
    and ecx, 0x3                                 # 00434758
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043475b
    mov eax, 0x1                                 # 0043475d
    jmp.d8 L_return                            # 00434762
L_continue:
    # block 0x00434764: L_continue: go to L_next_chunk to test the next chunk
    jmp.d32 L_next_chunk                           # 00434764
L_not_found:
    # block 0x00434769: L_not_found: eax = 0 (no unused chunk matched; selection fields untouched)
    {load} xor eax, eax                          # 00434769
L_return:
    # block 0x0043476b: L_return: restore edi/esi, tear down the frame, ret 4
    pop edi                                      # 0043476b
    pop esi                                      # 0043476c
    {load} mov esp, ebp                          # 0043476d
    pop ebp                                      # 0043476f
    ret 0x4                                      # 00434770
