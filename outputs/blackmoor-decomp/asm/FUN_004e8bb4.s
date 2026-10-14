# FUN_004e8bb4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e8bb4
# extent:       0x004e8bb4-0x004e8d72 (446 code bytes)
# span:         0x004e8bb4-0x004e8d72 (code 446, tables 0, padding 0)
# sha256:       297cedb2821f3c564f004101b600579be69434e6c1be9b3545333442962e30d6
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# name:         CUIInventory::update_hovered_entry_from_cursor
# arguments:    thiscall: ecx=this, no stack arguments, plain ret, no return value (eax is scratch). Called from FUN_004e89eb (after it recomputes the cursor position at this+0x823a and this+0x823e and runs its six-element loop) through mov ecx, [ebp-4] at 0x004e8ba8
# locals:       [ebp-4] = this, spilled from ecx (push ecx reserves the slot)
# fields:       this+0x6b1c: dword hovered entry id (written -1 first, then the id of the first entry hit), this+0x822e: dword loop index over the 16 entries (stored in the object, not in a local, and left at the hit index or at 16), this+0x823a: dword cursor x (read), this+0x823e: dword cursor y (read), entry table at this+0x7fae, 16 entries of 0x28 bytes: entry+0 dword id (-1 means unused), entry+4 dword hot flag (written 1 on the hit, 0 on a miss), entry+0x18 dword x0, entry+0x1c dword y0, entry+0x20 dword x1, entry+0x24 dword y1 (all read), globals 0x00583a29 (int16, compared with -1), 0x00583f1d (int16, compared with -1, only on a path that cannot run), 0x005c39e5 (dword cursor kind word, written 0x2717 or 0x2718), 0x005b44f0 (dword cursor row, read), 0x005b44f4 (dword cursor column, written 1 on a hit and re-read), 0x005d1631 (dword pointer into the 0x005b160c cursor table, written on a hit)
# callees:      none
# track-n:      host-adapter: none
# unverified:   Class name is only my label from the string neighbourhood (CUIInventory::Create and CUIInventory::Process texts bracket this routine) and from the caller FUN_004e89eb (which also loops over six 0xf7-byte records calling FUN_004e22fd), not from RTTI. The meaning of the 16 entries (stride 0x28 at this+0x7fae, an id and a rectangle) is read only from the compares: the cursor must satisfy x >= x0 + 11, x <= x1, y >= y0 + 10 and y <= y1 - 10, all signed, so the rectangle is inset on the left, top and bottom but not on the right. 0x583a29 is called the held item (-1 = none) only because src/caption_lifecycle.h names it that way, and 0x583f1d is not named anywhere, 0x2717 and 0x2718 are written to 0x5c39e5 with no name attached and are compared elsewhere (FUN_004e8e78 tests 0x2717). The re-read of 0x583a29 at 0x004e8be0 repeats the previous test, so the fall-through at 0x004e8bec (0x583f1d != -1) is only reachable if the word changed between the two reads, I kept it as a branch and did not decide whether the original author meant a different variable. After a hit the remaining entries are not visited, so their hot flags keep old values. The empty-entry test (id == -1) sends the entry through the miss path, which also clears its hot flag. The pointer 0x5d1631 is a full 32-bit address into the table at 0x5b160c (row stride 32 bytes from shl 5, column stride 16 from shl 4), not an index.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]: this, spilled from ecx
.equ hovered_entry_id, 0x6b1c  # this+0x6b1c: dword id of the entry under the cursor, -1 when none
.equ entry_id, 0x7fae  # entry+0 of the 16-entry table at this+0x7fae (stride 0x28): dword id, -1 means unused
.equ entry_hot_flag, 0x7fb2  # entry+4: dword hot flag, 1 when the cursor is inside the entry, else 0
.equ entry_x0, 0x7fc6  # entry+0x18: dword left edge
.equ entry_y0, 0x7fca  # entry+0x1c: dword top edge
.equ entry_x1, 0x7fce  # entry+0x20: dword right edge
.equ entry_y1, 0x7fd2  # entry+0x24: dword bottom edge
.equ entry_loop_index, 0x822e  # this+0x822e: dword loop index over the 16 entries, kept in the object
.equ cursor_x, 0x823a  # this+0x823a: dword cursor x position
.equ cursor_y, 0x823e  # this+0x823e: dword cursor y position

# --- external targets -----------------------------------------------

.org 0x004e8bb4 - 0x401000
.globl FUN_004e8bb4
FUN_004e8bb4:
    # block 0x004e8bb4: entry: spill this, set hovered_entry_id = -1, load the int16 at 0x583a29 and compare with -1, not equal goes to L_held_item_recheck (jne)
    push ebp                                     # 004e8bb4
    {load} mov ebp, esp                          # 004e8bb5
    push ecx                                     # 004e8bb7
    mov dword ptr [ebp - local_this], ecx           # 004e8bb8
    mov eax, dword ptr [ebp - local_this]           # 004e8bbb
    mov dword ptr [eax + hovered_entry_id], 0xffffffff # 004e8bbe
    movsx ecx, word ptr [0x583a29]               # 004e8bc8
    cmp ecx, -0x1                                # 004e8bcf
    jne.d8 L_held_item_recheck                            # 004e8bd2
    # block 0x004e8bd4: 0x583a29 == -1: set the cursor kind word 0x5c39e5 = 0x2717 and skip to L_start_scan
    mov dword ptr [0x5c39e5], 0x2717             # 004e8bd4
    jmp.d8 L_start_scan                            # 004e8bde
L_held_item_recheck:
    # block 0x004e8be0: 0x583a29 != -1: read it again and compare with -1, not equal goes to L_mode_item_held (jne, always taken unless the word changed between the two reads)
    movsx edx, word ptr [0x583a29]               # 004e8be0
    cmp edx, -0x1                                # 004e8be7
    jne.d8 L_mode_item_held                            # 004e8bea
    # block 0x004e8bec: only if the second read equals -1: test the int16 at 0x583f1d against -1 and go straight to L_start_scan when it is -1 (je), otherwise fall into L_mode_item_held
    movsx eax, word ptr [0x583f1d]               # 004e8bec
    cmp eax, -0x1                                # 004e8bf3
    je.d8 L_start_scan                             # 004e8bf6
L_mode_item_held:
    # block 0x004e8bf8: set the cursor kind word 0x5c39e5 = 0x2718
    mov dword ptr [0x5c39e5], 0x2718             # 004e8bf8
L_start_scan:
    # block 0x004e8c02: scan start: entry_loop_index = 0, jump to the loop test
    mov ecx, dword ptr [ebp - local_this]           # 004e8c02
    mov dword ptr [ecx + entry_loop_index], 0x0        # 004e8c05
    jmp.d8 L_scan_test                            # 004e8c0f
L_next_entry:
    # block 0x004e8c11: next entry: entry_loop_index += 1 (stored back into the object)
    mov edx, dword ptr [ebp - local_this]           # 004e8c11
    mov eax, dword ptr [edx + entry_loop_index]        # 004e8c14
    add eax, 0x1                                 # 004e8c1a
    mov ecx, dword ptr [ebp - local_this]           # 004e8c1d
    mov dword ptr [ecx + entry_loop_index], eax        # 004e8c20
L_scan_test:
    # block 0x004e8c26: loop test: entry_loop_index >= 16 (signed) leaves through L_epilogue (jge), otherwise continue
    mov edx, dword ptr [ebp - local_this]           # 004e8c26
    cmp dword ptr [edx + entry_loop_index], 0x10       # 004e8c29
    jge.d32 L_epilogue                           # 004e8c30
    # block 0x004e8c36: entry check 1: entry = this+0x7fae+index*0x28, an entry_id of -1 is unused and goes to L_entry_miss (je)
    mov eax, dword ptr [ebp - local_this]           # 004e8c36
    mov ecx, dword ptr [eax + entry_loop_index]        # 004e8c39
    imul ecx, ecx, 0x28                          # 004e8c3f
    mov edx, dword ptr [ebp - local_this]           # 004e8c42
    cmp dword ptr [edx + ecx + entry_id], -0x1 # 004e8c45
    je.d32 L_entry_miss                            # 004e8c4d
    # block 0x004e8c53: entry check 2: cursor_x < entry_x0 + 11 (signed) is a miss, go to L_entry_miss (jl)
    mov eax, dword ptr [ebp - local_this]           # 004e8c53
    mov ecx, dword ptr [eax + entry_loop_index]        # 004e8c56
    imul ecx, ecx, 0x28                          # 004e8c5c
    mov edx, dword ptr [ebp - local_this]           # 004e8c5f
    mov eax, dword ptr [edx + ecx + entry_x0]  # 004e8c62
    add eax, 0xb                                 # 004e8c69
    mov ecx, dword ptr [ebp - local_this]           # 004e8c6c
    cmp dword ptr [ecx + cursor_x], eax        # 004e8c6f
    jl.d32 L_entry_miss                            # 004e8c75
    # block 0x004e8c7b: entry check 3: cursor_x > entry_x1 (signed) is a miss, go to L_entry_miss (jg)
    mov edx, dword ptr [ebp - local_this]           # 004e8c7b
    mov eax, dword ptr [edx + entry_loop_index]        # 004e8c7e
    imul eax, eax, 0x28                          # 004e8c84
    mov ecx, dword ptr [ebp - local_this]           # 004e8c87
    mov edx, dword ptr [ebp - local_this]           # 004e8c8a
    mov ecx, dword ptr [ecx + cursor_x]        # 004e8c8d
    cmp ecx, dword ptr [edx + eax + entry_x1]  # 004e8c93
    jg.d32 L_entry_miss                            # 004e8c9a
    # block 0x004e8ca0: entry check 4: cursor_y < entry_y0 + 10 (signed) is a miss, go to L_entry_miss (jl)
    mov edx, dword ptr [ebp - local_this]           # 004e8ca0
    mov eax, dword ptr [edx + entry_loop_index]        # 004e8ca3
    imul eax, eax, 0x28                          # 004e8ca9
    mov ecx, dword ptr [ebp - local_this]           # 004e8cac
    mov edx, dword ptr [ecx + eax + entry_y0]  # 004e8caf
    add edx, 0xa                                 # 004e8cb6
    mov eax, dword ptr [ebp - local_this]           # 004e8cb9
    cmp dword ptr [eax + cursor_y], edx        # 004e8cbc
    jl.d32 L_entry_miss                            # 004e8cc2
    # block 0x004e8cc8: entry check 5: cursor_y > entry_y1 - 10 (signed) is a miss, go to L_entry_miss (jg)
    mov ecx, dword ptr [ebp - local_this]           # 004e8cc8
    mov edx, dword ptr [ecx + entry_loop_index]        # 004e8ccb
    imul edx, edx, 0x28                          # 004e8cd1
    mov eax, dword ptr [ebp - local_this]           # 004e8cd4
    mov ecx, dword ptr [eax + edx + entry_y1]  # 004e8cd7
    sub ecx, 0xa                                 # 004e8cde
    mov edx, dword ptr [ebp - local_this]           # 004e8ce1
    cmp dword ptr [edx + cursor_y], ecx        # 004e8ce4
    jg.d8 L_entry_miss                             # 004e8cea
    # block 0x004e8cec: hit: 0x5b44f4 = 1, hovered_entry_id = entry_id, 0x5d1631 = 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4), entry_hot_flag = 1, then leave the loop to L_epilogue
    mov dword ptr [0x5b44f4], 0x1                # 004e8cec
    mov eax, dword ptr [ebp - local_this]           # 004e8cf6
    mov ecx, dword ptr [eax + entry_loop_index]        # 004e8cf9
    imul ecx, ecx, 0x28                          # 004e8cff
    mov edx, dword ptr [ebp - local_this]           # 004e8d02
    mov eax, dword ptr [ebp - local_this]           # 004e8d05
    mov ecx, dword ptr [eax + ecx + entry_id]  # 004e8d08
    mov dword ptr [edx + hovered_entry_id], ecx        # 004e8d0f
    mov edx, dword ptr [0x5b44f0]                # 004e8d15
    shl edx, 0x5                                 # 004e8d1b
    mov eax, dword ptr [0x5b44f4]                # 004e8d1e
    shl eax, 0x4                                 # 004e8d23
    lea ecx, [edx + eax + 0x5b160c]              # 004e8d26
    mov dword ptr [0x5d1631], ecx                # 004e8d2d
    mov edx, dword ptr [ebp - local_this]           # 004e8d33
    mov eax, dword ptr [edx + entry_loop_index]        # 004e8d36
    imul eax, eax, 0x28                          # 004e8d3c
    mov ecx, dword ptr [ebp - local_this]           # 004e8d3f
    mov dword ptr [ecx + eax + entry_hot_flag], 0x1  # 004e8d42
    jmp.d8 L_epilogue                            # 004e8d4d
L_entry_miss:
    # block 0x004e8d4f: miss: entry_hot_flag = 0 for the current entry and go back to L_next_entry
    mov edx, dword ptr [ebp - local_this]           # 004e8d4f
    mov eax, dword ptr [edx + entry_loop_index]        # 004e8d52
    imul eax, eax, 0x28                          # 004e8d58
    mov ecx, dword ptr [ebp - local_this]           # 004e8d5b
    mov dword ptr [ecx + eax + entry_hot_flag], 0x0  # 004e8d5e
    jmp.d32 L_next_entry                           # 004e8d69
L_epilogue:
    # block 0x004e8d6e: epilogue: restore the frame and return (plain ret)
    {load} mov esp, ebp                          # 004e8d6e
    pop ebp                                      # 004e8d70
    ret                                          # 004e8d71
