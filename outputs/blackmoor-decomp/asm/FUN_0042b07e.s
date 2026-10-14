# FUN_0042b07e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042b07e
# extent:       0x0042b07e-0x0042b2e4 (614 code bytes)
# span:         0x0042b07e-0x0042b2e4 (code 614, tables 0, padding 0)
# sha256:       b88ed7735c97e51ccc9c5d0354d8c3749cc1adcc4e3ca03ec39d4d7e92bf23f8
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# name:         ActionSlot::process_by_state
# arguments:    cdecl: one stack argument arg_slot at [ebp+8] = slot index n, read only as a signed 16-bit word (movsx word ptr), so the upper half of the pushed dword is ignored; the caller pops (call sites 0x427c08 and 0x427c41 are followed by add esp,4); plain ret; no result
# locals:       frame 8 bytes: [ebp-0x4] word i = entry index in the search loop (starts at 0); [ebp-0x8] dword state = the slot state dword read at entry (0, 1 or 2 are handled, anything else returns at once)
# fields:       action slot n at 0x005bb5e3 + n*0x8d (stride 0x8d, layout per s0-action-runtime-trace.md; the same slot base as FUN_0042b2e4): +0x02 dword payload pointer (0x5bb5e5 + n*0x8d); +0x42 byte completion latch (0x5bb625, set to 1 in state 2); +0x43 dword (0x5bb626, 0 on state 1 entry, 1 when an entry matched; the trace calls the slot's +0x43 a hotspot-active word while the bytes store a dword to 0x5bb626 covering +0x43..+0x46 (same store in FUN_0042b2e4)); +0x47, +0x49, +0x4b, +0x4d words (0x5bb62a, 0x5bb62c, 0x5bb62e, 0x5bb630, copied from the matching entry; the trace calls slot +0x47..+0x4d the click rectangle of four signed 16-bit coordinates, so they are the hotspot rectangle by the trace, edge order not read from a consumer here, as in FUN_0042b2e4); +0x4f dword state (0x5bb632, the trace's phase/status value: 0, 1 or 2; set to 1 from 0); payload (the data block, layout per action type): +0x00 word, +0x02 word, +0x04 word, +0x06 word, +0x08 dword, +0x0c dword, +0x10 dword (header values copied to globals in state 2); +0x14 word entry count; entries start at +0x16 with 0x12-byte stride: entry word +0x00 (key), +0x02, +0x06, +0x0a, +0x0e (values); globals: 0x005bb1ca dword set to 1 (state 0 only); 0x005bb50b word compared with the entry keys; state 2 writes 0x005bb57b dword (sign-extended block word 0), 0x005bb599 word (block+2), 0x005bb595 word (block+4), 0x005c39ff word (block+6), 0x005bb59b dword (block+8), 0x005bb59f dword (block+0xc), 0x005bb5a3 dword (block+0x10) and 0x00583999 dword = 4 (Track N caption_lifecycle.h names 0x5bb57b scene_request, 0x5c39ff scene_request_flag and 0x583999 engine_state)
# callees:      none
# track-n:      host-adapter: none
# unverified:   The name ActionSlot::process_by_state and all field names are my labels; the bytes establish only the displacements, widths, comparisons and effect order. The identity of the 0x8d-byte slot table as the ACTION_RECORD table, and the case range 0x16 to 0x19 of the callers 0x427c08 and 0x427c41 (inside 0x427a50), come from pseudocode and the call-site disassembly, not from named data; what the state values 0, 1 and 2 mean, what the key word compared with the global at 0x5bb50b is, and what the header values are used for are not established; the copied entry words go to slot +0x47..+0x4d, which the trace calls the click rectangle (same stores as FUN_0042b2e4, see that file); Track N caption_lifecycle.h names 0x5bb57b scene_request, 0x5c39ff scene_request_flag and 0x583999 engine_state. Slot offsets here use slot base 0x5bb5e3 (state at +0x4f, as the trace and FUN_0042b2e4 say). The trace calls the slot's +0x43 a hotspot-active word while the bytes store a dword to 0x5bb626 covering +0x43..+0x46 (same store in FUN_0042b2e4). State 0 stores 1 to both the global 0x5bb1ca and the slot state and then falls through into the state-1 code (verified in the disassembly), so the first call also runs the search. A state outside 0 to 2 returns without any effect. The search loop reads the entry count and each entry through the slot pointer without a null check or a bound on the slot index n (n is a signed word, so a negative n indexes before the table): unsafe original behaviour, unmodelled here. In state 1 the matching flag is cleared before the search and left cleared when no entry matches; the loop stops at the first match.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_entry_idx, 0x4  # [ebp - 0x4]: word i, entry index of the search loop
.equ local_state, 0x8  # [ebp - 0x8]: dword state, slot state read at entry
.equ arg_slot, 0x8  # [ebp + 0x8]: stack argument n, slot index (read as signed word)

.equ blk_word_02, 0x2  # data block+0x02: word, copied to the global at 0x5bb599 in state 2
.equ blk_word_04, 0x4  # data block+0x04: word, copied to the global at 0x5bb595 in state 2
.equ blk_word_06, 0x6  # data block+0x06: word, copied to the global at 0x5c39ff in state 2
.equ blk_dword_08, 0x8  # data block+0x08: dword, copied to the global at 0x5bb59b in state 2
.equ blk_dword_0c, 0xc  # data block+0x0c: dword, copied to the global at 0x5bb59f in state 2
.equ blk_dword_10, 0x10  # data block+0x10: dword, copied to the global at 0x5bb5a3 in state 2
.equ blk_entry_count, 0x14  # data block+0x14: word, number of entries (signed compare with i)
.equ ent_key, 0x16  # data block+0x16 + i*0x12: word, entry key compared with the global word at 0x5bb50b
.equ ent_val_02, 0x18  # entry+0x02 (block+0x18 + i*0x12): word, copied to the slot at +0x47 (0x5bb62a + n*0x8d)
.equ ent_val_06, 0x1c  # entry+0x06 (block+0x1c + i*0x12): word, copied to the slot at +0x49 (0x5bb62c + n*0x8d)
.equ ent_val_0a, 0x20  # entry+0x0a (block+0x20 + i*0x12): word, copied to the slot at +0x4b (0x5bb62e + n*0x8d)
.equ ent_val_0e, 0x24  # entry+0x0e (block+0x24 + i*0x12): word, copied to the slot at +0x4d (0x5bb630 + n*0x8d)

# --- external targets -----------------------------------------------

.org 0x0042b07e - 0x401000
.globl FUN_0042b07e
FUN_0042b07e:
    # block 0x0042b07e: entry: state = dword at slot n + 0x5bb632 (n = signed word arg, stride 0x8d); if state == 0 go to the first-visit case
    push ebp                                     # 0042b07e
    {load} mov ebp, esp                          # 0042b07f
    sub esp, 0x8                                 # 0042b081
    movsx eax, word ptr [ebp + arg_slot]            # 0042b084
    imul eax, eax, 0x8d                          # 0042b088
    mov ecx, dword ptr [eax + 0x5bb632]          # 0042b08e
    mov dword ptr [ebp - local_state], ecx           # 0042b094
    cmp dword ptr [ebp - local_state], 0x0           # 0042b097
    je.d8 L_state0_first_visit                             # 0042b09b
    # block 0x0042b09d: if state == 1 go to the search case
    cmp dword ptr [ebp - local_state], 0x1           # 0042b09d
    je.d8 L_state1_search                             # 0042b0a1
    # block 0x0042b0a3: if state == 2 go to the header-copy case
    cmp dword ptr [ebp - local_state], 0x2           # 0042b0a3
    je.d32 L_state2_copy_header                            # 0042b0a7
    # block 0x0042b0ad: any other state: return without effect
    jmp.d32 L_epilogue                           # 0042b0ad
L_state0_first_visit:
    # block 0x0042b0b2: state 0: global 0x5bb1ca = 1, slot state (+0x4f, 0x5bb632) = 1, then fall into the state 1 code
    mov dword ptr [0x5bb1ca], 0x1                # 0042b0b2
    movsx edx, word ptr [ebp + arg_slot]            # 0042b0bc
    imul edx, edx, 0x8d                          # 0042b0c0
    mov dword ptr [edx + 0x5bb632], 0x1          # 0042b0c6
L_state1_search:
    # block 0x0042b0d0: state 1 (and state 0 after its stores): slot dword +0x43 (0x5bb626) = 0, i = 0
    movsx eax, word ptr [ebp + arg_slot]            # 0042b0d0
    imul eax, eax, 0x8d                          # 0042b0d4
    mov dword ptr [eax + 0x5bb626], 0x0          # 0042b0da
    mov word ptr [ebp - local_entry_idx], 0x0            # 0042b0e4
    jmp.d8 L_entry_loop_test                            # 0042b0ea
L_next_entry:
    # block 0x0042b0ec: search loop increment: i = i + 1 (16-bit)
    mov cx, word ptr [ebp - local_entry_idx]             # 0042b0ec
    add cx, 0x1                                  # 0042b0f0
    mov word ptr [ebp - local_entry_idx], cx             # 0042b0f4
L_entry_loop_test:
    # block 0x0042b0f8: search loop test: if i >= entry count word (block+0x14), both sign-extended, leave the loop
    movsx edx, word ptr [ebp - local_entry_idx]          # 0042b0f8
    movsx eax, word ptr [ebp + arg_slot]            # 0042b0fc
    imul eax, eax, 0x8d                          # 0042b100
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042b106
    movsx eax, word ptr [ecx + blk_entry_count]         # 0042b10c
    {load} cmp edx, eax                          # 0042b110
    jge.d32 L_leave_state1                           # 0042b112
    # block 0x0042b118: compare: if the key word of entry i (block+0x16 + i*0x12) != the word at 0x5bb50b go to the next entry
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b118
    imul ecx, ecx, 0x8d                          # 0042b11c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b122
    movsx eax, word ptr [ebp - local_entry_idx]          # 0042b128
    imul eax, eax, 0x12                          # 0042b12c
    movsx ecx, word ptr [edx + eax + ent_key]   # 0042b12f
    movsx edx, word ptr [0x5bb50b]               # 0042b134
    {load} cmp ecx, edx                          # 0042b13b
    jne.d32 L_key_differs                           # 0042b13d
    # block 0x0042b143: key matches: slot dword +0x43 (0x5bb626) = 1; copy the entry words +2, +6, +0xa, +0xe to the slot words +0x47, +0x49, +0x4b, +0x4d; leave the loop
    movsx eax, word ptr [ebp + arg_slot]            # 0042b143
    imul eax, eax, 0x8d                          # 0042b147
    mov dword ptr [eax + 0x5bb626], 0x1          # 0042b14d
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b157
    imul ecx, ecx, 0x8d                          # 0042b15b
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b161
    movsx eax, word ptr [ebp - local_entry_idx]          # 0042b167
    imul eax, eax, 0x12                          # 0042b16b
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b16e
    imul ecx, ecx, 0x8d                          # 0042b172
    mov dx, word ptr [edx + eax + ent_val_02]      # 0042b178
    mov word ptr [ecx + 0x5bb62a], dx            # 0042b17d
    movsx eax, word ptr [ebp + arg_slot]            # 0042b184
    imul eax, eax, 0x8d                          # 0042b188
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0042b18e
    movsx edx, word ptr [ebp - local_entry_idx]          # 0042b194
    imul edx, edx, 0x12                          # 0042b198
    movsx eax, word ptr [ebp + arg_slot]            # 0042b19b
    imul eax, eax, 0x8d                          # 0042b19f
    mov cx, word ptr [ecx + edx + ent_val_06]      # 0042b1a5
    mov word ptr [eax + 0x5bb62c], cx            # 0042b1aa
    movsx edx, word ptr [ebp + arg_slot]            # 0042b1b1
    imul edx, edx, 0x8d                          # 0042b1b5
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0042b1bb
    movsx ecx, word ptr [ebp - local_entry_idx]          # 0042b1c1
    imul ecx, ecx, 0x12                          # 0042b1c5
    movsx edx, word ptr [ebp + arg_slot]            # 0042b1c8
    imul edx, edx, 0x8d                          # 0042b1cc
    mov ax, word ptr [eax + ecx + ent_val_0a]      # 0042b1d2
    mov word ptr [edx + 0x5bb62e], ax            # 0042b1d7
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b1de
    imul ecx, ecx, 0x8d                          # 0042b1e2
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b1e8
    movsx eax, word ptr [ebp - local_entry_idx]          # 0042b1ee
    imul eax, eax, 0x12                          # 0042b1f2
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b1f5
    imul ecx, ecx, 0x8d                          # 0042b1f9
    mov dx, word ptr [edx + eax + ent_val_0e]      # 0042b1ff
    mov word ptr [ecx + 0x5bb630], dx            # 0042b204
    jmp.d8 L_leave_state1                            # 0042b20b
L_key_differs:
    # block 0x0042b20d: key differs: go to the loop increment
    jmp.d32 L_next_entry                           # 0042b20d
L_leave_state1:
    # block 0x0042b212: search finished (match or no entry left): go to the epilogue
    jmp.d32 L_epilogue                           # 0042b212
L_state2_copy_header:
    # block 0x0042b217: state 2: slot completion latch byte (+0x42, 0x5bb625) = 1; copy the data block header to globals: 0x5bb57b = block word 0 (sign-extended), 0x5bb599 = block+2, 0x5bb595 = block+4, 0x5c39ff = block+6, 0x5bb59b = block+8, 0x5bb59f = block+0xc, 0x5bb5a3 = block+0x10; 0x583999 = 4
    movsx eax, word ptr [ebp + arg_slot]            # 0042b217
    imul eax, eax, 0x8d                          # 0042b21b
    mov byte ptr [eax + 0x5bb625], 0x1           # 0042b221
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b228
    imul ecx, ecx, 0x8d                          # 0042b22c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b232
    movsx eax, word ptr [edx]                    # 0042b238
    mov dword ptr [0x5bb57b], eax                # 0042b23b
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b240
    imul ecx, ecx, 0x8d                          # 0042b244
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b24a
    mov ax, word ptr [edx + blk_word_02]             # 0042b250
    mov word ptr [0x5bb599], ax                  # 0042b254
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b25a
    imul ecx, ecx, 0x8d                          # 0042b25e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b264
    mov ax, word ptr [edx + blk_word_04]             # 0042b26a
    mov word ptr [0x5bb595], ax                  # 0042b26e
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b274
    imul ecx, ecx, 0x8d                          # 0042b278
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b27e
    mov ax, word ptr [edx + blk_word_06]             # 0042b284
    mov word ptr [0x5c39ff], ax                  # 0042b288
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b28e
    imul ecx, ecx, 0x8d                          # 0042b292
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b298
    mov eax, dword ptr [edx + blk_dword_08]           # 0042b29e
    mov dword ptr [0x5bb59b], eax                # 0042b2a1
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b2a6
    imul ecx, ecx, 0x8d                          # 0042b2aa
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b2b0
    mov eax, dword ptr [edx + blk_dword_0c]           # 0042b2b6
    mov dword ptr [0x5bb59f], eax                # 0042b2b9
    movsx ecx, word ptr [ebp + arg_slot]            # 0042b2be
    imul ecx, ecx, 0x8d                          # 0042b2c2
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0042b2c8
    mov eax, dword ptr [edx + blk_dword_10]          # 0042b2ce
    mov dword ptr [0x5bb5a3], eax                # 0042b2d1
    mov dword ptr [0x583999], 0x4                # 0042b2d6
L_epilogue:
    # block 0x0042b2e0: epilogue: restore the frame, plain ret (cdecl)
    {load} mov esp, ebp                          # 0042b2e0
    pop ebp                                      # 0042b2e2
    ret                                          # 0042b2e3
