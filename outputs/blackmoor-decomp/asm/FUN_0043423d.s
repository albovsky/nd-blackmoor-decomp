# FUN_0043423d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043423d
# extent:       0x0043423d-0x004343a2 (357 code bytes)
# span:         0x0043423d-0x004343a2 (code 357, tables 0, padding 0)
# sha256:       11fb4c2fba56f1adfa591e51d080cbda140f510f1810e38c96315ab8635f213f
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# name:         CHiff::select_data_by_name
# arguments:    thiscall: ecx=this (spilled); [ebp+8]=arg_type_name NUL-terminated DATA type name to find (case-sensitive); callee pops 4 (ret 4); returns eax = 1 when a DATA record was selected, 0 when none matched
# locals:       [ebp-4]=declared DATA length of the record being tested; [ebp-8]=DATA record index; [ebp-0xc]=cursor pointer into the record; [ebp-0x10]=pointer to the static 4-char name buffer returned by FUN_00434814; [ebp-0x14]=saved this; [ebp-0x18]=inline strcmp cursor in arg_type_name; [ebp-0x1c]=inline strcmp cursor in the name buffer; [ebp-0x1d], [ebp-0x1e]=the two bytes held across one comparison step; [ebp-0x24]=strcmp result (0 equal, 1 or -1 from sbb); [ebp-0x28]=copy of the result; esi/edi saved and restored
# fields:       this+0x5f64: DATA count (read); this+0x1144[n]: DATA marker pointers (read); this+0x111c: selected DATA body pointer (written on a match only); this+0x1128: selected DATA body length, declared length minus 4 (written on a match only); this+0x1136: selected DATA type name buffer, copied with its NUL (written on a match only); globals 0x00545ef0: the 4-character DATA marker string used for its strlen; 0x00583979 and 0x005cf659: objects passed in ecx to the error and quit routines; the static name buffer at 0x0063a590 is written inside FUN_00434814
# callees:      FUN_004347b8 = read big-endian dword at a pointer (stack arg, thiscall); FUN_0042639d = report error (message, caller name); FUN_004c97b4 = post quit message; FUN_00434814 = CHiff::copy_fourcc_static (copy up to four non-NUL bytes to the static buffer at 0x0063a590, NUL terminate, return its address)
# track-n:      outputs/blackmoor-decomp/src/hiff.c:hiff_select_data
# unverified:   the name CHiff::select_data_by_name was chosen by the annotator (the error strings in the binary call this routine SelectData); after a DATA length of 8 or less the original reports an error and calls the quit routine and then continues (no early return), whereas Track N rejects; the inline pairwise compare is the CRT strcmp expansion (name_buf byte versus argument byte, two bytes per step, stopping at a mismatch or NUL) and only its zero versus non-zero outcome is used here, so the sign of a non-zero result is not verified to matter; the strings at 0x545ef0 (marker), 0x545ef8 and 0x545f04 (error texts) were identified by reading original data, not by the instructions; length and type reads are not bounds checked against the resource end; the static name buffer is a shared global, its reuse between calls is not analysed; a failed selection leaves this+0x111c, 0x1128 and 0x1136 unchanged
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_data_length, 0x4  # [ebp - 0x4]
.equ local_data_index, 0x8  # [ebp - 0x8]
.equ local_cursor, 0xc  # [ebp - 0xc]
.equ local_name_buf, 0x10  # [ebp - 0x10]
.equ local_saved_this, 0x14  # [ebp - 0x14]
.equ local_arg_cursor, 0x18  # [ebp - 0x18]
.equ local_name_cursor, 0x1c  # [ebp - 0x1c]
.equ local_byte0, 0x1d  # [ebp - 0x1d]
.equ local_byte1, 0x1e  # [ebp - 0x1e]
.equ local_cmp, 0x24  # [ebp - 0x24]
.equ local_cmp_copy, 0x28  # [ebp - 0x28]
.equ arg_type_name, 0x8  # [ebp + 0x8]

.equ str_second_byte, 0x1  # string+1: second byte of each compared string (inline strcmp pair step)
.equ hiff_data_body_ptr, 0x111c  # CHiff+0x111c: selected DATA body pointer, zeroed
.equ hiff_data_body_len, 0x1128  # CHiff+0x1128: selected DATA body length, zeroed
.equ hiff_data_marker_table, 0x1144  # CHiff+0x1144: table of DATA marker pointers
.equ hiff_data_count, 0x5f64  # CHiff+0x5f64: DATA record count

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004347b8, .text + (0x004347b8 - 0x401000)
.set FUN_00434814, .text + (0x00434814 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x0043423d - 0x401000
.globl FUN_0043423d
FUN_0043423d:
    # block 0x0043423d: function entry: build frame, spill this, data_index = 0, jump to L_data_test
    push ebp                                     # 0043423d
    {load} mov ebp, esp                          # 0043423e
    sub esp, 0x28                                # 00434240
    push esi                                     # 00434243
    push edi                                     # 00434244
    mov dword ptr [ebp - local_saved_this], ecx          # 00434245
    mov dword ptr [ebp - local_data_index], 0x0           # 00434248
    jmp.d8 L_data_test                            # 0043424f
L_next_data:
    # block 0x00434251: L_next_data: data_index + 1
    mov eax, dword ptr [ebp - local_data_index]           # 00434251
    add eax, 0x1                                 # 00434254
    mov dword ptr [ebp - local_data_index], eax           # 00434257
L_data_test:
    # block 0x0043425a: L_data_test: signed compare data_index with the DATA count this+0x5f64; index >= count goes to L_not_found
    mov ecx, dword ptr [ebp - local_saved_this]          # 0043425a
    mov edx, dword ptr [ebp - local_data_index]           # 0043425d
    cmp edx, dword ptr [ecx + hiff_data_count]            # 00434260
    jge.d32 L_not_found                           # 00434266
    # block 0x0043426c: cursor = marker pointer this+0x1144[data_index] + strlen of the marker string (4), giving the length field; data_length = big-endian dword there; length above 8 (unsigned) continues to L_size_ok
    mov eax, dword ptr [ebp - local_data_index]           # 0043426c
    mov ecx, dword ptr [ebp - local_saved_this]          # 0043426f
    mov edx, dword ptr [ecx + 4*eax + hiff_data_marker_table]    # 00434272
    mov dword ptr [ebp - local_cursor], edx           # 00434279
    mov edi, 0x545ef0                            # 0043427c
    or ecx, -0x1                                 # 00434281
    {load} xor eax, eax                          # 00434284
    repne scasb al, byte ptr es:[edi]            # 00434286
    not ecx                                      # 00434288
    add ecx, -0x1                                # 0043428a
    mov eax, dword ptr [ebp - local_cursor]           # 0043428d
    {load} add eax, ecx                          # 00434290
    mov dword ptr [ebp - local_cursor], eax           # 00434292
    mov ecx, dword ptr [ebp - local_cursor]           # 00434295
    push ecx                                     # 00434298
    mov ecx, dword ptr [ebp - local_saved_this]          # 00434299
    call FUN_004347b8                            # 0043429c
    mov dword ptr [ebp - local_data_length], eax           # 004342a1
    cmp dword ptr [ebp - local_data_length], 0x8           # 004342a4
    ja.d8 L_size_ok                             # 004342a8
    # block 0x004342aa: data_length <= 8: report 'DATA is too small' through FUN_0042639d and call the quit routine, then fall through
    push 0x545ef8                                # 004342aa
    push 0x545f04                                # 004342af
    mov ecx, 0x583979                            # 004342b4
    call FUN_0042639d                            # 004342b9
    mov ecx, 0x5cf659                            # 004342be
    call FUN_004c97b4                            # 004342c3
L_size_ok:
    # block 0x004342c8: L_size_ok: cursor += 4 (now at the type field); name_buf = FUN_00434814(cursor) (static copy of the type, at most 4 bytes + NUL); arg cursor = arg_type_name, name cursor = name_buf
    mov edx, dword ptr [ebp - local_cursor]           # 004342c8
    add edx, 0x4                                 # 004342cb
    mov dword ptr [ebp - local_cursor], edx           # 004342ce
    mov eax, dword ptr [ebp - local_cursor]           # 004342d1
    push eax                                     # 004342d4
    mov ecx, dword ptr [ebp - local_saved_this]          # 004342d5
    call FUN_00434814                            # 004342d8
    mov dword ptr [ebp - local_name_buf], eax          # 004342dd
    mov ecx, dword ptr [ebp + arg_type_name]             # 004342e0
    mov dword ptr [ebp - local_arg_cursor], ecx          # 004342e3
    mov edx, dword ptr [ebp - local_name_buf]          # 004342e6
    mov dword ptr [ebp - local_name_cursor], edx          # 004342e9
L_cmp_loop:
    # block 0x004342ec: L_cmp_loop: load name_buf byte; unequal to the argument byte goes to L_differ
    mov eax, dword ptr [ebp - local_name_cursor]          # 004342ec
    mov cl, byte ptr [eax]                       # 004342ef
    mov byte ptr [ebp - local_byte0], cl            # 004342f1
    mov edx, dword ptr [ebp - local_arg_cursor]          # 004342f4
    cmp cl, byte ptr [edx]                       # 004342f7
    jne.d8 L_differ                            # 004342f9
    # block 0x004342fb: bytes equal: a NUL byte means both strings ended, go to L_equal
    cmp byte ptr [ebp - local_byte0], 0x0           # 004342fb
    je.d8 L_equal                             # 004342ff
    # block 0x00434301: compare the next byte pair; unequal goes to L_differ
    mov eax, dword ptr [ebp - local_name_cursor]          # 00434301
    mov cl, byte ptr [eax + str_second_byte]                 # 00434304
    mov byte ptr [ebp - local_byte1], cl            # 00434307
    mov edx, dword ptr [ebp - local_arg_cursor]          # 0043430a
    cmp cl, byte ptr [edx + str_second_byte]                 # 0043430d
    jne.d8 L_differ                            # 00434310
    # block 0x00434312: advance both cursors by 2; continue the loop while the second byte was not NUL, else fall into L_equal
    add dword ptr [ebp - local_name_cursor], 0x2          # 00434312
    add dword ptr [ebp - local_arg_cursor], 0x2          # 00434316
    cmp byte ptr [ebp - local_byte1], 0x0           # 0043431a
    jne.d8 L_cmp_loop                            # 0043431e
L_equal:
    # block 0x00434320: L_equal: strcmp result = 0, go to L_cmp_done
    mov dword ptr [ebp - local_cmp], 0x0          # 00434320
    jmp.d8 L_cmp_done                            # 00434327
L_differ:
    # block 0x00434329: L_differ: sbb eax,eax / sbb eax,-1 turn the carry of the failed unsigned byte compare into -1 (name_buf byte below the argument byte) or +1 (above); only zero versus non-zero is consumed
    {load} sbb eax, eax                          # 00434329
    sbb eax, -0x1                                # 0043432b
    mov dword ptr [ebp - local_cmp], eax          # 0043432e
L_cmp_done:
    # block 0x00434331: L_cmp_done: copy the result; non-zero goes to L_continue
    mov ecx, dword ptr [ebp - local_cmp]          # 00434331
    mov dword ptr [ebp - local_cmp_copy], ecx          # 00434334
    cmp dword ptr [ebp - local_cmp_copy], 0x0          # 00434337
    jne.d8 L_continue                            # 0043433b
    # block 0x0043433d: names equal: cursor += 4 to the body; this+0x111c = cursor; this+0x1128 = data_length - 4; copy name_buf (strlen+1) to this+0x1136; return eax = 1 (jump to L_return)
    mov edx, dword ptr [ebp - local_cursor]           # 0043433d
    add edx, 0x4                                 # 00434340
    mov dword ptr [ebp - local_cursor], edx           # 00434343
    mov eax, dword ptr [ebp - local_saved_this]          # 00434346
    mov ecx, dword ptr [ebp - local_cursor]           # 00434349
    mov dword ptr [eax + hiff_data_body_ptr], ecx            # 0043434c
    mov edx, dword ptr [ebp - local_data_length]           # 00434352
    sub edx, 0x4                                 # 00434355
    mov eax, dword ptr [ebp - local_saved_this]          # 00434358
    mov dword ptr [eax + hiff_data_body_len], edx            # 0043435b
    mov edi, dword ptr [ebp - local_name_buf]          # 00434361
    mov ecx, dword ptr [ebp - local_saved_this]          # 00434364
    add ecx, 0x1136                              # 00434367
    {load} mov edx, ecx                          # 0043436d
    or ecx, -0x1                                 # 0043436f
    {load} xor eax, eax                          # 00434372
    repne scasb al, byte ptr es:[edi]            # 00434374
    not ecx                                      # 00434376
    {load} sub edi, ecx                          # 00434378
    {load} mov esi, edi                          # 0043437a
    {load} mov eax, ecx                          # 0043437c
    {load} mov edi, edx                          # 0043437e
    shr ecx, 0x2                                 # 00434380
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00434383
    {load} mov ecx, eax                          # 00434385
    and ecx, 0x3                                 # 00434387
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043438a
    mov eax, 0x1                                 # 0043438c
    jmp.d8 L_return                            # 00434391
L_continue:
    # block 0x00434393: L_continue: go to L_next_data to test the next record
    jmp.d32 L_next_data                           # 00434393
L_not_found:
    # block 0x00434398: L_not_found: eax = 0 (no match; selection fields untouched)
    {load} xor eax, eax                          # 00434398
L_return:
    # block 0x0043439a: L_return: restore edi/esi, tear down the frame, ret 4
    pop edi                                      # 0043439a
    pop esi                                      # 0043439b
    {load} mov esp, ebp                          # 0043439c
    pop ebp                                      # 0043439e
    ret 0x4                                      # 0043439f
