# FUN_00419dab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00419dab
# extent:       0x00419dab-0x0041a102 (855 code bytes)
# span:         0x00419dab-0x0041a102 (code 855, tables 0, padding 0)
# sha256:       744f3f364fa132f0bd49276edfc20e369bae15fe827ed9ee8f3156e0fc00e108
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# name:         CCifTreeSet::open_tree
# arguments:    thiscall: ecx=this (tree-set object, saved to a frame slot); [ebp+8]=arg_path NUL-terminated tree file path; callee pops 4 (ret 4); no return value (success is recorded in the entry's open flag)
# locals:       [ebp-0x64]=100-byte scratch buffer holding a copy of arg_path for the error message; [ebp-0x68]=malloc result for the record array; [ebp-0x6c]=saved this; esi/edi saved and restored
# fields:       this+0x1c: drive buffer (splitpath output); this+0x1f: directory buffer; this+0x11f: file-name buffer (upper-cased, must be at most 0x20 chars); this+0x21f: extension buffer; this+0x571: int16 slot index (-1 means none); this+0x57b: pointer to the selected entry; entries start at this+0x57f with stride 0x84d; entry+0x00: 33-byte name copy; entry+0x21: 32-byte header read from the file; entry+0x39: header version word (must be 2); entry+0x3b: header version word (must be 1); entry+0x3d: int16 record count; entry+0x41: pointer to malloc'd records (count*0x5e bytes); entry+0x45: 0x800-byte bucket table; entry+0x845: FILE pointer; entry+0x849: open flag set to 1 on success; globals 0x0063888b: error text buffer; 0x0063a58a: shutdown/exit code set to 3 on failure; 0x005cf659: object passed in ecx to the quit routine
# callees:      FUN_0041a2e9 = find free entry slot (scans 30 entries for open flag zero, returns index or -1); FUN_0050ca3e = sprintf-style formatter into the error buffer; FUN_0052139c = report error message (message, 0, 0); FUN_0050d1f0 = path splitter taking (path, drive, dir, fname, ext) in the _splitpath argument pattern; FUN_0050d0bc = in-place ASCII upper-casing of a string (CRT strupr); FUN_0050d0a9 = file open (path, mode string) returning FILE pointer; FUN_0050cf61 = locked fread(buf, size, count, FILE); FUN_0051dc43 = malloc with new-handler retry loop; FUN_004c97b4 = post quit message with the exit code in 0x0063a58a
# track-n:      outputs/blackmoor-decomp/src/cif_archive.c:cif_tree_open_file  (nearest counterpart: Track N reads the whole file and validates entries and hash chains; this function reads only the 32-byte header, the bucket table and the record array and validates no chains)
# unverified:   the CRT identities of FUN_0050d1f0/FUN_0050d0bc/FUN_0050d0a9/FUN_0050cf61 are inferred from argument shape and callee code, not proved here; the 100-byte copy of arg_path into the local buffer is unbounded (an overlong path overruns the frame), which Track N rejects instead; the file-name copy into the entry name is bounded by the 0x20 check but the extension, drive and directory buffers are not size-checked here; the original does not close the FILE or free the record array on the failure paths, and entry+0x849 is only set on success (leaks and the slot state on failure paths are not analysed); the name CCifTreeSet::open_tree was chosen by the annotator (the binary has no string for it); the native tree loader reads the whole file into memory and does not upper-case the path; the type of the object at 0x005cf659 is not identified; whether the stored slot index is ever read back as -1 elsewhere is not verified
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_path_copy, 0x64  # [ebp - 0x64]
.equ local_records, 0x68  # [ebp - 0x68]
.equ local_saved_this, 0x6c  # [ebp - 0x6c]
.equ arg_path, 0x8  # [ebp + 0x8]

.equ entry_hdr_version_a, 0x39  # tree entry+0x39: header version word, must be 2
.equ entry_hdr_version_b, 0x3b  # tree entry+0x3b: header version word, must be 1
.equ entry_record_count, 0x3d  # tree entry+0x3d: int16 record count
.equ entry_records_ptr, 0x41  # tree entry+0x41: malloc record array pointer
.equ this_slot_index, 0x571  # CCifTreeSet+0x571: int16 selected slot index, -1 none
.equ this_entry_ptr, 0x57b  # CCifTreeSet+0x57b: pointer to the selected entry
.equ this_entries_base, 0x57f  # CCifTreeSet+0x57f: first entry, stride 0x84d
.equ entry_file_ptr, 0x845  # tree entry+0x845: FILE pointer
.equ entry_open_flag, 0x849  # tree entry+0x849: open flag, 1 on success

# --- external targets -----------------------------------------------
.set FUN_0041a2e9, .text + (0x0041a2e9 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)
.set FUN_0050d1f0, .text + (0x0050d1f0 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00419dab - 0x401000
.globl FUN_00419dab
FUN_00419dab:
    # block 0x00419dab: function entry: build frame, save esi/edi, spill this, call the free-slot finder, store its int16 result to this+0x571, branch to L_slot_found unless it is -1
    push ebp                                     # 00419dab
    {load} mov ebp, esp                          # 00419dac
    sub esp, 0x6c                                # 00419dae
    push esi                                     # 00419db1
    push edi                                     # 00419db2
    mov dword ptr [ebp - local_saved_this], ecx          # 00419db3
    mov ecx, dword ptr [ebp - local_saved_this]          # 00419db6
    call FUN_0041a2e9                            # 00419db9
    mov ecx, dword ptr [ebp - local_saved_this]          # 00419dbe
    mov word ptr [ecx + this_slot_index], ax               # 00419dc1
    mov edx, dword ptr [ebp - local_saved_this]          # 00419dc8
    movsx eax, word ptr [edx + this_slot_index]            # 00419dcb
    cmp eax, -0x1                                # 00419dd2
    jne.d8 L_slot_found                            # 00419dd5
    # block 0x00419dd7: no free slot (index == -1): format the 'unable to find empty slot' message into the error buffer, report it, jump to the L_fail_exit chain
    push 0x542f30                                # 00419dd7
    push 0x63888b                                # 00419ddc
    call FUN_0050ca3e                            # 00419de1
    add esp, 0x8                                 # 00419de6
    push 0x0                                     # 00419de9
    push 0x0                                     # 00419deb
    push 0x63888b                                # 00419ded
    call FUN_0052139c                            # 00419df2
    jmp.d32 L_chain_no_slot                           # 00419df7
L_slot_found:
    # block 0x00419dfc: L_slot_found: entry pointer this+0x57b = this + 0x57f + slot * 0x84d; split arg_path into drive/dir/file/ext buffers; upper-case the file-name buffer; inline strlen of it, branch to L_name_length_ok when length <= 0x20
    mov ecx, dword ptr [ebp - local_saved_this]          # 00419dfc
    movsx edx, word ptr [ecx + this_slot_index]            # 00419dff
    imul edx, edx, 0x84d                         # 00419e06
    mov eax, dword ptr [ebp - local_saved_this]          # 00419e0c
    lea ecx, [eax + edx + this_entries_base]                 # 00419e0f
    mov edx, dword ptr [ebp - local_saved_this]          # 00419e16
    mov dword ptr [edx + this_entry_ptr], ecx             # 00419e19
    mov eax, dword ptr [ebp - local_saved_this]          # 00419e1f
    add eax, 0x21f                               # 00419e22
    push eax                                     # 00419e27
    mov ecx, dword ptr [ebp - local_saved_this]          # 00419e28
    add ecx, 0x11f                               # 00419e2b
    push ecx                                     # 00419e31
    mov edx, dword ptr [ebp - local_saved_this]          # 00419e32
    add edx, 0x1f                                # 00419e35
    push edx                                     # 00419e38
    mov eax, dword ptr [ebp - local_saved_this]          # 00419e39
    add eax, 0x1c                                # 00419e3c
    push eax                                     # 00419e3f
    mov ecx, dword ptr [ebp + arg_path]             # 00419e40
    push ecx                                     # 00419e43
    call FUN_0050d1f0                            # 00419e44
    add esp, 0x14                                # 00419e49
    mov edx, dword ptr [ebp - local_saved_this]          # 00419e4c
    add edx, 0x11f                               # 00419e4f
    push edx                                     # 00419e55
    call FUN_0050d0bc                            # 00419e56
    add esp, 0x4                                 # 00419e5b
    mov edi, dword ptr [ebp - local_saved_this]          # 00419e5e
    add edi, 0x11f                               # 00419e61
    or ecx, -0x1                                 # 00419e67
    {load} xor eax, eax                          # 00419e6a
    repne scasb al, byte ptr es:[edi]            # 00419e6c
    not ecx                                      # 00419e6e
    add ecx, -0x1                                # 00419e70
    cmp ecx, 0x20                                # 00419e73
    jbe.d8 L_name_length_ok                            # 00419e76
    # block 0x00419e78: file name longer than 0x20: format the 'tree file name too long' message with the file name, report it, jump to the L_fail_exit chain
    mov eax, dword ptr [ebp - local_saved_this]          # 00419e78
    add eax, 0x11f                               # 00419e7b
    push eax                                     # 00419e80
    push 0x542f6c                                # 00419e81
    push 0x63888b                                # 00419e86
    call FUN_0050ca3e                            # 00419e8b
    add esp, 0xc                                 # 00419e90
    push 0x0                                     # 00419e93
    push 0x0                                     # 00419e95
    push 0x63888b                                # 00419e97
    call FUN_0052139c                            # 00419e9c
    jmp.d32 L_chain_name_too_long                           # 00419ea1
L_name_length_ok:
    # block 0x00419ea6: L_name_length_ok: copy the NUL-terminated file name into entry+0 (rep movsd/movsb), open arg_path with the mode string, store the FILE pointer at entry+0x845, branch to L_file_opened when non-null
    mov ecx, dword ptr [ebp - local_saved_this]          # 00419ea6
    add ecx, 0x11f                               # 00419ea9
    {load} mov edi, ecx                          # 00419eaf
    mov edx, dword ptr [ebp - local_saved_this]          # 00419eb1
    mov edx, dword ptr [edx + this_entry_ptr]             # 00419eb4
    or ecx, -0x1                                 # 00419eba
    {load} xor eax, eax                          # 00419ebd
    repne scasb al, byte ptr es:[edi]            # 00419ebf
    not ecx                                      # 00419ec1
    {load} sub edi, ecx                          # 00419ec3
    {load} mov esi, edi                          # 00419ec5
    {load} mov eax, ecx                          # 00419ec7
    {load} mov edi, edx                          # 00419ec9
    shr ecx, 0x2                                 # 00419ecb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00419ece
    {load} mov ecx, eax                          # 00419ed0
    and ecx, 0x3                                 # 00419ed2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00419ed5
    push 0x542f8c                                # 00419ed7
    mov ecx, dword ptr [ebp + arg_path]             # 00419edc
    push ecx                                     # 00419edf
    call FUN_0050d0a9                            # 00419ee0
    add esp, 0x8                                 # 00419ee5
    mov edx, dword ptr [ebp - local_saved_this]          # 00419ee8
    mov ecx, dword ptr [edx + this_entry_ptr]             # 00419eeb
    mov dword ptr [ecx + entry_file_ptr], eax             # 00419ef1
    mov edx, dword ptr [ebp - local_saved_this]          # 00419ef7
    mov eax, dword ptr [edx + this_entry_ptr]             # 00419efa
    cmp dword ptr [eax + entry_file_ptr], 0x0             # 00419f00
    jne.d8 L_file_opened                            # 00419f07
    # block 0x00419f09: open failed: copy arg_path (unbounded) into local_path_copy, format the 'unable to open CAL or CIF TREE file' message with it, report it, jump to the L_fail_exit chain
    mov edi, dword ptr [ebp + arg_path]             # 00419f09
    lea edx, [ebp - local_path_copy]                    # 00419f0c
    or ecx, -0x1                                 # 00419f0f
    {load} xor eax, eax                          # 00419f12
    repne scasb al, byte ptr es:[edi]            # 00419f14
    not ecx                                      # 00419f16
    {load} sub edi, ecx                          # 00419f18
    {load} mov esi, edi                          # 00419f1a
    {load} mov eax, ecx                          # 00419f1c
    {load} mov edi, edx                          # 00419f1e
    shr ecx, 0x2                                 # 00419f20
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00419f23
    {load} mov ecx, eax                          # 00419f25
    and ecx, 0x3                                 # 00419f27
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00419f2a
    lea ecx, [ebp - local_path_copy]                    # 00419f2c
    push ecx                                     # 00419f2f
    push 0x542f90                                # 00419f30
    push 0x63888b                                # 00419f35
    call FUN_0050ca3e                            # 00419f3a
    add esp, 0xc                                 # 00419f3f
    push 0x0                                     # 00419f42
    push 0x0                                     # 00419f44
    push 0x63888b                                # 00419f46
    call FUN_0052139c                            # 00419f4b
    jmp.d32 L_chain_open_failed                           # 00419f50
L_file_opened:
    # block 0x00419f55: L_file_opened: fread 0x20 bytes x 1 from the file into entry+0x21 (the header); branch to L_check_signature when exactly 1 item was read
    mov edx, dword ptr [ebp - local_saved_this]          # 00419f55
    mov eax, dword ptr [edx + this_entry_ptr]             # 00419f58
    mov ecx, dword ptr [eax + entry_file_ptr]             # 00419f5e
    push ecx                                     # 00419f64
    push 0x1                                     # 00419f65
    push 0x20                                    # 00419f67
    mov edx, dword ptr [ebp - local_saved_this]          # 00419f69
    mov eax, dword ptr [edx + this_entry_ptr]             # 00419f6c
    add eax, 0x21                                # 00419f72
    push eax                                     # 00419f75
    call FUN_0050cf61                            # 00419f76
    add esp, 0x10                                # 00419f7b
    cmp eax, 0x1                                 # 00419f7e
    je.d8 L_check_signature                             # 00419f81
    # block 0x00419f83: header read failed: report the 'unable to read TREE HEADER' message, jump to the L_fail_exit chain
    push 0x0                                     # 00419f83
    push 0x0                                     # 00419f85
    push 0x542fdc                                # 00419f87
    call FUN_0052139c                            # 00419f8c
    jmp.d32 L_chain_header_read_failed                           # 00419f91
L_check_signature:
    # block 0x00419f96: L_check_signature: repe cmpsb 0x14 bytes of entry+0x21 against the 'CIF TREE WayneSikes' string; mismatch goes to L_bad_header
    mov edi, 0x54301c                            # 00419f96
    mov ecx, dword ptr [ebp - local_saved_this]          # 00419f9b
    mov esi, dword ptr [ecx + this_entry_ptr]             # 00419f9e
    add esi, 0x21                                # 00419fa4
    mov ecx, 0x14                                # 00419fa7
    {load} xor edx, edx                          # 00419fac
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00419fae
    jne.d8 L_bad_header                            # 00419fb0
    # block 0x00419fb2: signature matched: load the header version word at entry+0x39; not equal to 2 goes to L_bad_header
    mov eax, dword ptr [ebp - local_saved_this]          # 00419fb2
    mov ecx, dword ptr [eax + this_entry_ptr]             # 00419fb5
    {load} xor edx, edx                          # 00419fbb
    mov dx, word ptr [ecx + entry_hdr_version_a]                # 00419fbd
    cmp edx, 0x2                                 # 00419fc1
    jne.d8 L_bad_header                            # 00419fc4
    # block 0x00419fc6: load the header version word at entry+0x3b; equal to 1 goes on to L_read_hash_table, otherwise falls to L_bad_header
    mov eax, dword ptr [ebp - local_saved_this]          # 00419fc6
    mov ecx, dword ptr [eax + this_entry_ptr]             # 00419fc9
    {load} xor edx, edx                          # 00419fcf
    mov dx, word ptr [ecx + entry_hdr_version_b]                # 00419fd1
    cmp edx, 0x1                                 # 00419fd5
    je.d8 L_read_hash_table                             # 00419fd8
L_bad_header:
    # block 0x00419fda: L_bad_header: report the 'TREE HEADER contains invalid ID or version' message, jump to the L_fail_exit chain
    push 0x0                                     # 00419fda
    push 0x0                                     # 00419fdc
    push 0x543030                                # 00419fde
    call FUN_0052139c                            # 00419fe3
    jmp.d32 L_chain_header_invalid                           # 00419fe8
L_read_hash_table:
    # block 0x00419fed: L_read_hash_table: fread 0x800 bytes x 1 from the file into entry+0x45 (the bucket table); branch to L_alloc_records when exactly 1 item was read
    mov eax, dword ptr [ebp - local_saved_this]          # 00419fed
    mov ecx, dword ptr [eax + this_entry_ptr]             # 00419ff0
    mov edx, dword ptr [ecx + entry_file_ptr]             # 00419ff6
    push edx                                     # 00419ffc
    push 0x1                                     # 00419ffd
    push 0x800                                   # 00419fff
    mov eax, dword ptr [ebp - local_saved_this]          # 0041a004
    mov ecx, dword ptr [eax + this_entry_ptr]             # 0041a007
    add ecx, 0x45                                # 0041a00d
    push ecx                                     # 0041a010
    call FUN_0050cf61                            # 0041a011
    add esp, 0x10                                # 0041a016
    cmp eax, 0x1                                 # 0041a019
    je.d8 L_alloc_records                             # 0041a01c
    # block 0x0041a01e: hash table read failed: report the 'unable to read TREE HASH TABLE' message, jump to the L_fail_exit chain
    push 0x0                                     # 0041a01e
    push 0x0                                     # 0041a020
    push 0x543084                                # 0041a022
    call FUN_0052139c                            # 0041a027
    jmp.d32 L_chain_hash_read_failed                           # 0041a02c
L_alloc_records:
    # block 0x0041a031: L_alloc_records: malloc (signed 16-bit count at entry+0x3d) * 0x5e bytes, store the pointer at entry+0x41, branch to L_read_records when non-null
    mov edx, dword ptr [ebp - local_saved_this]          # 0041a031
    mov eax, dword ptr [edx + this_entry_ptr]             # 0041a034
    movsx ecx, word ptr [eax + entry_record_count]             # 0041a03a
    imul ecx, ecx, 0x5e                          # 0041a03e
    push ecx                                     # 0041a041
    call FUN_0051dc43                            # 0041a042
    add esp, 0x4                                 # 0041a047
    mov dword ptr [ebp - local_records], eax          # 0041a04a
    mov edx, dword ptr [ebp - local_saved_this]          # 0041a04d
    mov eax, dword ptr [edx + this_entry_ptr]             # 0041a050
    mov ecx, dword ptr [ebp - local_records]          # 0041a056
    mov dword ptr [eax + entry_records_ptr], ecx              # 0041a059
    cmp dword ptr [ebp - local_records], 0x0          # 0041a05c
    jne.d8 L_read_records                            # 0041a060
    # block 0x0041a062: allocation failed: report the 'unable to allocate memory' message, jump to the L_fail_exit chain
    push 0x0                                     # 0041a062
    push 0x0                                     # 0041a064
    push 0x5430c8                                # 0041a066
    call FUN_0052139c                            # 0041a06b
    jmp.d8 L_chain_alloc_failed                            # 0041a070
L_read_records:
    # block 0x0041a072: L_read_records: fread count*0x5e bytes x 1 from the file into the record array; branch to L_open_ok when exactly 1 item was read
    mov edx, dword ptr [ebp - local_saved_this]          # 0041a072
    mov eax, dword ptr [edx + this_entry_ptr]             # 0041a075
    mov ecx, dword ptr [eax + entry_file_ptr]             # 0041a07b
    push ecx                                     # 0041a081
    push 0x1                                     # 0041a082
    mov edx, dword ptr [ebp - local_saved_this]          # 0041a084
    mov eax, dword ptr [edx + this_entry_ptr]             # 0041a087
    movsx ecx, word ptr [eax + entry_record_count]             # 0041a08d
    imul ecx, ecx, 0x5e                          # 0041a091
    push ecx                                     # 0041a094
    mov edx, dword ptr [ebp - local_saved_this]          # 0041a095
    mov eax, dword ptr [edx + this_entry_ptr]             # 0041a098
    mov ecx, dword ptr [eax + entry_records_ptr]              # 0041a09e
    push ecx                                     # 0041a0a1
    call FUN_0050cf61                            # 0041a0a2
    add esp, 0x10                                # 0041a0a7
    cmp eax, 0x1                                 # 0041a0aa
    je.d8 L_open_ok                             # 0041a0ad
    # block 0x0041a0af: record read failed: report the 'unable to read TREE INFO BLOCKS' message, jump to the L_fail_exit chain
    push 0x0                                     # 0041a0af
    push 0x0                                     # 0041a0b1
    push 0x543110                                # 0041a0b3
    call FUN_0052139c                            # 0041a0b8
    jmp.d8 L_chain_records_read_failed                            # 0041a0bd
L_open_ok:
    # block 0x0041a0bf: L_open_ok: set entry+0x849 (open flag) to 1 and jump to L_return, skipping the failure handling
    mov edx, dword ptr [ebp - local_saved_this]          # 0041a0bf
    mov eax, dword ptr [edx + this_entry_ptr]             # 0041a0c2
    mov dword ptr [eax + entry_open_flag], 0x1             # 0041a0c8
    jmp.d8 L_return                            # 0041a0d2
L_fail_exit:
    # block 0x0041a0d4: L_fail_exit: failure tail, store 3 in the exit-code global 0x0063a58a and call FUN_004c97b4 with ecx = 0x005cf659 (post quit), then jump to L_return
    mov dword ptr [0x63a58a], 0x3                # 0041a0d4
    mov ecx, 0x5cf659                            # 0041a0de
    call FUN_004c97b4                            # 0041a0e3
    jmp.d8 L_return                            # 0041a0e8
L_chain_records_read_failed:
    # block 0x0041a0ea: L_chain_records_read_failed: jump to L_fail_exit (compiler-emitted jump chain, no work)
    jmp.d8 L_fail_exit                            # 0041a0ea
L_chain_alloc_failed:
    # block 0x0041a0ec: L_chain_alloc_failed: jump to L_fail_exit (no work)
    jmp.d8 L_fail_exit                            # 0041a0ec
L_chain_hash_read_failed:
    # block 0x0041a0ee: L_chain_hash_read_failed: jump to L_fail_exit (no work)
    jmp.d8 L_fail_exit                            # 0041a0ee
L_chain_header_invalid:
    # block 0x0041a0f0: L_chain_header_invalid: jump to L_fail_exit (no work)
    jmp.d8 L_fail_exit                            # 0041a0f0
L_chain_header_read_failed:
    # block 0x0041a0f2: L_chain_header_read_failed: jump to L_fail_exit (no work)
    jmp.d8 L_fail_exit                            # 0041a0f2
L_chain_open_failed:
    # block 0x0041a0f4: L_chain_open_failed: jump to L_fail_exit (no work)
    jmp.d8 L_fail_exit                            # 0041a0f4
L_chain_name_too_long:
    # block 0x0041a0f6: L_chain_name_too_long: jump to L_fail_exit (no work)
    jmp.d8 L_fail_exit                            # 0041a0f6
L_chain_no_slot:
    # block 0x0041a0f8: L_chain_no_slot: jump to L_fail_exit (no work)
    jmp.d8 L_fail_exit                            # 0041a0f8
L_return:
    # block 0x0041a0fa: L_return: restore edi/esi, tear down the frame, ret 4
    pop edi                                      # 0041a0fa
    pop esi                                      # 0041a0fb
    {load} mov esp, ebp                          # 0041a0fc
    pop ebp                                      # 0041a0fe
    ret 0x4                                      # 0041a0ff
