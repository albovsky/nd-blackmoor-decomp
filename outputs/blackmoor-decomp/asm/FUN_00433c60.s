# FUN_00433c60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00433c60
# extent:       0x00433c60-0x00433e63 (515 code bytes)
# span:         0x00433c60-0x00433e63 (code 515, tables 0, padding 0)
# sha256:       1edc11b57e82217f79e36fdb7cd5355260af533d04eaf9b2818d2878b7cde0ca
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# name:         CHiff::CHiff
# arguments:    thiscall: ecx=this (spilled); [ebp+8]=arg_name NUL-terminated resource name to extract; callee pops 4 (ret 4); returns this in eax
# locals:       [ebp-4]=loop index 0..999 for the used-flag table clear; [ebp-8]=saved this; esi/edi saved and restored
# fields:       this+0x00: vtable pointer set to 0x0052c7b8; this+0x08: error text buffer; this+0x1008, +0x100c, +0x1010: zeroed (this+0x1008 is the DATA scan pointer in FUN_00433eaa; the other two are not read in this batch); this+0x1014: copy of arg_name (unbounded strcpy, buffer ends before this+0x1118); this+0x1118: pointer to the extracted resource bytes (return of FUN_00418e52); this+0x111c: zeroed (selected DATA body pointer); this+0x1120: zeroed (selected chunk payload pointer); this+0x1124: size of the extracted resource (out parameter of FUN_00418e52); this+0x1128: zeroed (selected DATA body length); this+0x112c: zeroed (selected chunk payload length); this+0x1130: byte zeroed (selected chunk name buffer); this+0x1136: byte zeroed (selected DATA name buffer); this+0x113c, +0x1140: zeroed (not read in this batch); the 1000-dword table at [this+0x4fc4, this+0x5f64) (last entry at +0xf9c): 1000 dword chunk used flags zeroed; this+0x5f64: zeroed (DATA count); this+0x5f68: zeroed (chunk count); globals 0x005bb1de: mode flag selecting which tree name is queried; 0x0063a58a: exit code set to 2 on failure; 0x005d2f31: archive manager object (ecx of FUN_00418e52); 0x005cf659: object passed to the quit routine
# callees:      FUN_00418e52 = archive lookup and extract (thiscall on the object at 0x005d2f31; args tree-name string, resource name, pointer to size out; returns data pointer or 0; callee pops 0xc); FUN_0050ca3e = sprintf-style formatter into the error buffer; FUN_0052139c = report error message (message, 0, 0); FUN_004c97b4 = post quit message with the exit code in 0x0063a58a; FUN_00433eaa = CHiff::index_data_records (bytewise DATA scan); FUN_00434025 = CHiff::index_chunks (flat chunk list)
# track-n:      outputs/blackmoor-decomp/src/hiff.c:hiff_open_memory
# unverified:   native hiff_open_memory covers only the parse half; the archive extraction half corresponds to cif_tree_extract and the CIF decoder, not to hiff.c; the strings at 0x00545de0 and 0x00545dec (two tree names selected by the flag at 0x005bb1de) were read from the original data and the flag's meaning is unknown; the purpose of the zeroed dwords at this+0x1008/0x100c/0x1010, 0x113c/0x1140 is not established here; the name copy at this+0x1014 is unbounded in the original (Track N rejects); after the failure path quits, the original returns this anyway and does not run the index passes; callee pop count of FUN_00418e52 (0xc) is inferred from the absence of a stack adjustment after the call; the vtable contents are not analysed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_index, 0x4  # [ebp - 0x4]
.equ local_this, 0x8  # [ebp - 0x8]
.equ arg_name, 0x8  # [ebp + 0x8]

.equ hiff_scan_ptr, 0x1008  # CHiff+0x1008: DATA scan pointer
.equ hiff_zeroed_100c, 0x100c  # CHiff+0x100c: dword zeroed by the constructor, not read here
.equ hiff_zeroed_1010, 0x1010  # CHiff+0x1010: dword zeroed by the constructor, not read here
.equ hiff_res_base, 0x1118  # CHiff+0x1118: extracted resource base pointer
.equ hiff_data_body_ptr, 0x111c  # CHiff+0x111c: selected DATA body pointer, zeroed
.equ hiff_chunk_payload_ptr, 0x1120  # CHiff+0x1120: selected chunk payload pointer, zeroed
.equ hiff_res_size, 0x1124  # CHiff+0x1124: extracted resource size
.equ hiff_data_body_len, 0x1128  # CHiff+0x1128: selected DATA body length, zeroed
.equ hiff_chunk_payload_len, 0x112c  # CHiff+0x112c: selected chunk payload length, zeroed
.equ hiff_chunk_name_buf, 0x1130  # CHiff+0x1130: selected chunk name buffer, first byte zeroed
.equ hiff_data_name_buf, 0x1136  # CHiff+0x1136: selected DATA name buffer, first byte zeroed
.equ hiff_zeroed_113c, 0x113c  # CHiff+0x113c: dword zeroed by the constructor, not read here
.equ hiff_zeroed_1140, 0x1140  # CHiff+0x1140: dword zeroed by the constructor, not read here
.equ hiff_chunk_used_table, 0x4fc4  # CHiff+0x4fc4: 1000 dword chunk used flags
.equ hiff_data_count, 0x5f64  # CHiff+0x5f64: DATA record count
.equ hiff_chunk_count, 0x5f68  # CHiff+0x5f68: chunk count

# --- external targets -----------------------------------------------
.set FUN_00418e52, .text + (0x00418e52 - 0x401000)
.set FUN_00433eaa, .text + (0x00433eaa - 0x401000)
.set FUN_00434025, .text + (0x00434025 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00433c60 - 0x401000
.globl FUN_00433c60
FUN_00433c60:
    # block 0x00433c60: function entry: build frame, set this+0 to the vtable 0x52c7b8, copy arg_name (strlen+1, rep movsd/movsb) to this+0x1014, zero the scalar fields (this+0x1008/100c/1010, 0x1118..0x112c, bytes 0x1130/0x1136, 0x113c/1140, 0x5f64, 0x5f68), local_index = 0
    push ebp                                     # 00433c60
    {load} mov ebp, esp                          # 00433c61
    sub esp, 0x8                                 # 00433c63
    push esi                                     # 00433c66
    push edi                                     # 00433c67
    mov dword ptr [ebp - local_this], ecx           # 00433c68
    mov eax, dword ptr [ebp - local_this]           # 00433c6b
    mov dword ptr [eax], 0x52c7b8                # 00433c6e
    mov edi, dword ptr [ebp + arg_name]             # 00433c74
    mov ecx, dword ptr [ebp - local_this]           # 00433c77
    add ecx, 0x1014                              # 00433c7a
    {load} mov edx, ecx                          # 00433c80
    or ecx, -0x1                                 # 00433c82
    {load} xor eax, eax                          # 00433c85
    repne scasb al, byte ptr es:[edi]            # 00433c87
    not ecx                                      # 00433c89
    {load} sub edi, ecx                          # 00433c8b
    {load} mov esi, edi                          # 00433c8d
    {load} mov eax, ecx                          # 00433c8f
    {load} mov edi, edx                          # 00433c91
    shr ecx, 0x2                                 # 00433c93
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00433c96
    {load} mov ecx, eax                          # 00433c98
    and ecx, 0x3                                 # 00433c9a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00433c9d
    mov ecx, dword ptr [ebp - local_this]           # 00433c9f
    mov dword ptr [ecx + hiff_zeroed_1010], 0x0            # 00433ca2
    mov edx, dword ptr [ebp - local_this]           # 00433cac
    mov dword ptr [edx + hiff_zeroed_100c], 0x0            # 00433caf
    mov eax, dword ptr [ebp - local_this]           # 00433cb9
    mov dword ptr [eax + hiff_scan_ptr], 0x0            # 00433cbc
    mov ecx, dword ptr [ebp - local_this]           # 00433cc6
    mov dword ptr [ecx + hiff_res_base], 0x0            # 00433cc9
    mov edx, dword ptr [ebp - local_this]           # 00433cd3
    mov dword ptr [edx + hiff_data_body_ptr], 0x0            # 00433cd6
    mov eax, dword ptr [ebp - local_this]           # 00433ce0
    mov dword ptr [eax + hiff_chunk_payload_ptr], 0x0            # 00433ce3
    mov ecx, dword ptr [ebp - local_this]           # 00433ced
    mov dword ptr [ecx + hiff_res_size], 0x0            # 00433cf0
    mov edx, dword ptr [ebp - local_this]           # 00433cfa
    mov dword ptr [edx + hiff_data_body_len], 0x0            # 00433cfd
    mov eax, dword ptr [ebp - local_this]           # 00433d07
    mov dword ptr [eax + hiff_chunk_payload_len], 0x0            # 00433d0a
    mov ecx, dword ptr [ebp - local_this]           # 00433d14
    mov byte ptr [ecx + hiff_chunk_name_buf], 0x0             # 00433d17
    mov edx, dword ptr [ebp - local_this]           # 00433d1e
    mov byte ptr [edx + hiff_data_name_buf], 0x0             # 00433d21
    mov eax, dword ptr [ebp - local_this]           # 00433d28
    mov dword ptr [eax + hiff_zeroed_113c], 0x0            # 00433d2b
    mov ecx, dword ptr [ebp - local_this]           # 00433d35
    mov dword ptr [ecx + hiff_zeroed_1140], 0x0            # 00433d38
    mov edx, dword ptr [ebp - local_this]           # 00433d42
    mov dword ptr [edx + hiff_data_count], 0x0            # 00433d45
    mov eax, dword ptr [ebp - local_this]           # 00433d4f
    mov dword ptr [eax + hiff_chunk_count], 0x0            # 00433d52
    mov dword ptr [ebp - local_index], 0x0           # 00433d5c
    jmp.d8 L_clear_test                            # 00433d63
L_clear_next:
    # block 0x00433d65: L_clear_next: increment the loop index
    mov ecx, dword ptr [ebp - local_index]           # 00433d65
    add ecx, 0x1                                 # 00433d68
    mov dword ptr [ebp - local_index], ecx           # 00433d6b
L_clear_test:
    # block 0x00433d6e: L_clear_test: signed compare index with 1000 (0x3e8); index >= 1000 leaves the loop for L_choose_tree
    cmp dword ptr [ebp - local_index], 0x3e8         # 00433d6e
    jge.d8 L_choose_tree                            # 00433d75
    # block 0x00433d77: loop body: this+0x4fc4+4*index = 0 (clear the chunk used-flag table), loop to L_clear_next
    mov edx, dword ptr [ebp - local_index]           # 00433d77
    mov eax, dword ptr [ebp - local_this]           # 00433d7a
    mov dword ptr [eax + 4*edx + hiff_chunk_used_table], 0x0    # 00433d7d
    jmp.d8 L_clear_next                            # 00433d88
L_choose_tree:
    # block 0x00433d8a: L_choose_tree: test global 0x5bb1de; zero selects L_query_default_tree
    cmp dword ptr [0x5bb1de], 0x0                # 00433d8a
    je.d8 L_query_default_tree                             # 00433d91
    # block 0x00433d93: flag set: call FUN_00418e52 (ecx=0x5d2f31) with the first tree name (0x545de0), this+0x1014 and &this+0x1124; store the result at this+0x1118; jump to L_check_extract
    mov ecx, dword ptr [ebp - local_this]           # 00433d93
    add ecx, 0x1124                              # 00433d96
    push ecx                                     # 00433d9c
    mov edx, dword ptr [ebp - local_this]           # 00433d9d
    add edx, 0x1014                              # 00433da0
    push edx                                     # 00433da6
    push 0x545de0                                # 00433da7
    mov ecx, 0x5d2f31                            # 00433dac
    call FUN_00418e52                            # 00433db1
    mov ecx, dword ptr [ebp - local_this]           # 00433db6
    mov dword ptr [ecx + hiff_res_base], eax            # 00433db9
    jmp.d8 L_check_extract                            # 00433dbf
L_query_default_tree:
    # block 0x00433dc1: L_query_default_tree: flag clear, same call with the second tree name (0x545dec); store the result at this+0x1118
    mov edx, dword ptr [ebp - local_this]           # 00433dc1
    add edx, 0x1124                              # 00433dc4
    push edx                                     # 00433dca
    mov eax, dword ptr [ebp - local_this]           # 00433dcb
    add eax, 0x1014                              # 00433dce
    push eax                                     # 00433dd3
    push 0x545dec                                # 00433dd4
    mov ecx, 0x5d2f31                            # 00433dd9
    call FUN_00418e52                            # 00433dde
    mov ecx, dword ptr [ebp - local_this]           # 00433de3
    mov dword ptr [ecx + hiff_res_base], eax            # 00433de6
L_check_extract:
    # block 0x00433dec: L_check_extract: if this+0x1118 (data pointer) is zero go to L_extract_failed
    mov edx, dword ptr [ebp - local_this]           # 00433dec
    cmp dword ptr [edx + hiff_res_base], 0x0            # 00433def
    je.d8 L_extract_failed                             # 00433df6
    # block 0x00433df8: pointer non-null: test this+0x1124 (size); non-zero goes to L_index_resource, zero falls to the failure path
    mov eax, dword ptr [ebp - local_this]           # 00433df8
    cmp dword ptr [eax + hiff_res_size], 0x0            # 00433dfb
    jne.d8 L_index_resource                            # 00433e02
L_extract_failed:
    # block 0x00433e04: L_extract_failed: format the constructor failure message with the resource name into this+0x8, report it, store 2 in the exit-code global 0x63a58a, call the quit routine with ecx=0x5cf659, jump to L_return
    mov ecx, dword ptr [ebp - local_this]           # 00433e04
    add ecx, 0x1014                              # 00433e07
    push ecx                                     # 00433e0d
    push 0x545df4                                # 00433e0e
    mov edx, dword ptr [ebp - local_this]           # 00433e13
    add edx, 0x8                                 # 00433e16
    push edx                                     # 00433e19
    call FUN_0050ca3e                            # 00433e1a
    add esp, 0xc                                 # 00433e1f
    push 0x0                                     # 00433e22
    push 0x0                                     # 00433e24
    mov eax, dword ptr [ebp - local_this]           # 00433e26
    add eax, 0x8                                 # 00433e29
    push eax                                     # 00433e2c
    call FUN_0052139c                            # 00433e2d
    mov dword ptr [0x63a58a], 0x2                # 00433e32
    mov ecx, 0x5cf659                            # 00433e3c
    call FUN_004c97b4                            # 00433e41
    jmp.d8 L_return                            # 00433e46
L_index_resource:
    # block 0x00433e48: L_index_resource: call FUN_00433eaa then FUN_00434025 on this (DATA scan, then chunk flat list)
    mov ecx, dword ptr [ebp - local_this]           # 00433e48
    call FUN_00433eaa                            # 00433e4b
    mov ecx, dword ptr [ebp - local_this]           # 00433e50
    call FUN_00434025                            # 00433e53
L_return:
    # block 0x00433e58: L_return: eax = this, restore edi/esi, tear down the frame, ret 4
    mov eax, dword ptr [ebp - local_this]           # 00433e58
    pop edi                                      # 00433e5b
    pop esi                                      # 00433e5c
    {load} mov esp, ebp                          # 00433e5d
    pop ebp                                      # 00433e5f
    ret 0x4                                      # 00433e60
