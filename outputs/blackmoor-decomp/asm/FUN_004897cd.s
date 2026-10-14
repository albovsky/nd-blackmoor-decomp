# FUN_004897cd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004897cd
# extent:       0x004897cd-0x004899ca (509 code bytes)
# span:         0x004897cd-0x004899ca (code 509, tables 0, padding 0)
# sha256:       715a602f9a6f12d750b580d6d7e6d51b73adab4e076b9bd4b531a3d96628423f
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# name:         SceneObjectList::HitTestHoverCursor
# arguments:    thiscall: ecx=this, two stack arguments popped by the callee (ret 8): [ebp+8] = x coordinate and [ebp+0xc] = y coordinate, both sign-extended 16-bit words. Returns eax=1 on the first matching record (after publishing the cursor selection), else eax=0
# locals:       [ebp-local_entry_index] = outer loop index over the entries (0 to this+0xcc). [ebp-local_record_index] = inner loop index over the records of the current entry. [ebp-local_this] = this, spilled from ecx. The frame reserves 0xc bytes
# fields:       this+0x1c: dword, current entry pointer (written each outer pass). this+0x20: dword, second copy of the current entry pointer (read for the record count). this+0x24: dword, current record pointer (entry + 0x6ec + j*0x26). this+0x2c + i*4: array of entry pointers. this+0xcc: dword entry count (0 returns 0 at once). Entry: +0xaa word record count, +0xab0 word action slot index, +0xab2 dword flag (must be non-zero), +0x6ec array of 0x26-byte records. Record: +0x00 word frame (compared with word 0x5bb50b), +0x04 word (must equal 1), +0x16 dword x minimum, +0x1a dword y minimum, +0x1e dword x maximum, +0x22 dword y maximum (all inclusive). Action slot phase dword 0x5bb632 + slotindex*0x8d (slot base 0x5bb5e3 + slotindex*0x8d + 0x4f, one slot table with payload pointer at slot+2) must equal 1. Globals read: 0x5bb50b word, 0x583a29 word (compared with -1), 0x5b44f8 dword, 0x571ad3, 0x5d0377, 0x5b44f0. Globals written on a hit: 0x5b44f0 (held-item branch: word 0x583a29 + 0x25, default branch: 0), 0x5d162d (0x571ad3 or 0x5d0377 in those two branches), 0x5b44f4 = 1, 0x5d1631 = 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4), 0x5d1639 = 1, 0x5c39e5 = entry word +0xab0 (0x005c39e5: dword; s0-action-runtime-trace.md: pending event/hotspot index; Track N caption_lifecycle.h: slider_cursor_scene; here it receives the entry word +0xab0, role not established)
# callees:      none
# track-n:      host-adapter: none
# unverified:   No Track N source covers this routine (the pointer hit test chain it belongs to, 0x4f0059 in the pseudocode hint, is described in s0-action-runtime-trace.md but no C source implements this link). Class and role names are my labels. That the entries relate to action payloads (the +0xab0 word is used as a slot index into the 0x8d-stride slot table, whose +0x4f dword is the executor phase per s0-action-runtime-trace.md) is inferred from the imul 0x8d and the 0x5bb632 base, not from tracing how this+0x2c is filled. The meaning of record fields +0x04 (must be 1) and +0x00 (frame, matched with 0x5bb50b as in 0x42ae73) is not established, and the left, top, right, bottom labels of record +0x16, +0x1a, +0x1e, +0x22 follow only the compare operands (x against +0x16 and +0x1e, y against +0x1a and +0x22). The roles of 0x583a29 (held item index, -1 for none) and 0x5b44f8 (cursor alternate flag) are named by src/caption_lifecycle.h, and the +0x25 offset added to the held item as the cursor type is not explained here. When 0x583a29 != -1 and 0x5b44f8 != 0, or 0x583a29 == -1 and 0x5b44f8 != 0, neither cursor type nor surface is changed (the bytes show that path falls straight to 0x5b44f4 = 1). The only call site is 0x4f1054 inside 0x4f0059, which loads ecx = 0x619935 (a static object) and pushes caller+0x5a then caller+0x5e (so x = caller+0x5e and y = caller+0x5a); whether 0x619935 is the only instance is not established, and the dispatcher 0x4f0059 was read from pseudocode only. 0x5d162d, 0x5d1631 and 0x5d1639 are fields +8, +0xc and +0x14 of entry 2 of the render layer table 0x5d1591 (stride 0x4a, 0x5d1591 + 2*0x4a = 0x5d1625), per tests/caption_lifecycle_original_oracle.py:56-57. Track N's cursor_src_index label counts dwords (src/caption_lifecycle.h:164: (address-0x5b160c)/4); the bytes store the byte address 0x5b160c + (type<<5) + (variant<<4).
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_entry_index, 0x4  # outer loop index over the entry pointer array
.equ local_record_index, 0x8  # inner loop index over the records of the current entry
.equ local_this, 0xc  # this pointer spilled from ecx
.equ rec_enabled, 0x4  # record+0x04: word, must equal 1
.equ arg_x, 0x8  # first stack argument: x coordinate, 16-bit word read with sign extension
.equ arg_y, 0xc  # second stack argument: y coordinate, 16-bit word read with sign extension
.equ rec_left, 0x16  # record+0x16: dword x minimum, inclusive
.equ rec_top, 0x1a  # record+0x1a: dword y minimum, inclusive
.equ obj_entry_cur, 0x1c  # this+0x1c: dword, current entry pointer
.equ rec_right, 0x1e  # record+0x1e: dword x maximum, inclusive
.equ obj_entry_copy, 0x20  # this+0x20: dword, copy of the current entry pointer, read for the record count
.equ rec_bottom, 0x22  # record+0x22: dword y maximum, inclusive
.equ obj_record_cur, 0x24  # this+0x24: dword, current record pointer
.equ obj_entry_array, 0x2c  # this+0x2c: base of the array of entry pointers, entry i at +i*4
.equ ent_record_count, 0xaa  # entry+0xaa: word, number of records
.equ obj_entry_count, 0xcc  # this+0xcc: dword, number of entries
.equ ent_records, 0x6ec  # entry+0x6ec: base of the record array, stride 0x26
.equ ent_slot_index, 0xab0  # entry+0xab0: word, action slot index, also the value published to 0x5c39e5
.equ ent_active_flag, 0xab2  # entry+0xab2: dword flag, non-zero required

# --- external targets -----------------------------------------------

.org 0x004897cd - 0x401000
.globl FUN_004897cd
FUN_004897cd:
    # block 0x004897cd: entry: spill this, if this+0xcc (entry count) != 0 go to start_scan (jne)
    push ebp                                     # 004897cd
    {load} mov ebp, esp                          # 004897ce
    sub esp, 0xc                                 # 004897d0
    mov dword ptr [ebp - local_this], ecx           # 004897d3
    mov eax, dword ptr [ebp - local_this]           # 004897d6
    cmp dword ptr [eax + obj_entry_count], 0x0          # 004897d9
    jne.d8 start_scan                            # 004897e0
    # block 0x004897e2: no entries: return 0 (xor eax, eax)
    {load} xor eax, eax                          # 004897e2
    jmp.d32 epilogue                           # 004897e4
start_scan:
    # block 0x004897e9: start_scan: local_entry_index = 0, go to entry_test
    mov dword ptr [ebp - local_entry_index], 0x0           # 004897e9
    jmp.d8 entry_test                            # 004897f0
entry_next:
    # block 0x004897f2: entry_next: local_entry_index += 1
    mov ecx, dword ptr [ebp - local_entry_index]           # 004897f2
    add ecx, 0x1                                 # 004897f5
    mov dword ptr [ebp - local_entry_index], ecx           # 004897f8
entry_test:
    # block 0x004897fb: entry_test: if local_entry_index >= this+0xcc (signed) return 0 through return_0 (jge)
    mov edx, dword ptr [ebp - local_this]           # 004897fb
    mov eax, dword ptr [ebp - local_entry_index]           # 004897fe
    cmp eax, dword ptr [edx + obj_entry_count]          # 00489801
    jge.d32 return_0                           # 00489807
    # block 0x0048980d: entry body: this+0x1c = this+0x2c[i], this+0x20 = this+0x1c, then if entry+0xab2 == 0 go to entry_skip (je)
    mov ecx, dword ptr [ebp - local_this]           # 0048980d
    mov edx, dword ptr [ebp - local_entry_index]           # 00489810
    mov eax, dword ptr [ebp - local_this]           # 00489813
    mov edx, dword ptr [eax + 4*edx + obj_entry_array]  # 00489816
    mov dword ptr [ecx + obj_entry_cur], edx          # 0048981a
    mov eax, dword ptr [ebp - local_this]           # 0048981d
    mov ecx, dword ptr [ebp - local_this]           # 00489820
    mov edx, dword ptr [ecx + obj_entry_cur]          # 00489823
    mov dword ptr [eax + obj_entry_copy], edx          # 00489826
    mov eax, dword ptr [ebp - local_this]           # 00489829
    mov ecx, dword ptr [eax + obj_entry_cur]          # 0048982c
    cmp dword ptr [ecx + ent_active_flag], 0x0         # 0048982f
    je.d8 entry_skip                             # 00489836
    # block 0x00489838: entry+0xab2 != 0: read word entry+0xab0 (slot index), if dword at 0x5bb632 + slot*0x8d (slot executor phase) == 1 go to record_scan_start (je), else fall into entry_skip
    mov edx, dword ptr [ebp - local_this]           # 00489838
    mov eax, dword ptr [edx + obj_entry_cur]          # 0048983b
    movsx ecx, word ptr [eax + ent_slot_index]        # 0048983e
    imul ecx, ecx, 0x8d                          # 00489845
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 0048984b
    je.d8 record_scan_start                             # 00489852
entry_skip:
    # block 0x00489854: entry_skip: go to entry_next
    jmp.d8 entry_next                            # 00489854
record_scan_start:
    # block 0x00489856: record_scan_start: local_record_index = 0, go to record_test
    mov dword ptr [ebp - local_record_index], 0x0           # 00489856
    jmp.d8 record_test                            # 0048985d
record_next:
    # block 0x0048985f: record_next: local_record_index += 1
    mov edx, dword ptr [ebp - local_record_index]           # 0048985f
    add edx, 0x1                                 # 00489862
    mov dword ptr [ebp - local_record_index], edx           # 00489865
record_test:
    # block 0x00489868: record_test: if local_record_index >= word entry+0xaa (sign-extended, via this+0x20) leave to entry_done (jge)
    mov eax, dword ptr [ebp - local_this]           # 00489868
    mov ecx, dword ptr [eax + obj_entry_copy]          # 0048986b
    movsx edx, word ptr [ecx + ent_record_count]         # 0048986e
    cmp dword ptr [ebp - local_record_index], edx           # 00489875
    jge.d32 entry_done                           # 00489878
    # block 0x0048987e: record body: this+0x24 = entry + 0x6ec + local_record_index * 0x26, compare word record+0 (sign-extended) with word 0x5bb50b, if not equal go to record_miss (jne)
    mov eax, dword ptr [ebp - local_this]           # 0048987e
    mov ecx, dword ptr [eax + obj_entry_cur]          # 00489881
    mov edx, dword ptr [ebp - local_record_index]           # 00489884
    imul edx, edx, 0x26                          # 00489887
    lea eax, [ecx + edx + ent_records]             # 0048988a
    mov ecx, dword ptr [ebp - local_this]           # 00489891
    mov dword ptr [ecx + obj_record_cur], eax          # 00489894
    mov edx, dword ptr [ebp - local_this]           # 00489897
    mov eax, dword ptr [edx + obj_record_cur]          # 0048989a
    movsx ecx, word ptr [eax]                    # 0048989d
    movsx edx, word ptr [0x5bb50b]               # 004898a0
    {load} cmp ecx, edx                          # 004898a7
    jne.d32 record_miss                           # 004898a9
    # block 0x004898af: frame equal: if word record+4 != 1 go to record_miss (jne)
    mov eax, dword ptr [ebp - local_this]           # 004898af
    mov ecx, dword ptr [eax + obj_record_cur]          # 004898b2
    movsx edx, word ptr [ecx + rec_enabled]          # 004898b5
    cmp edx, 0x1                                 # 004898b9
    jne.d32 record_miss                           # 004898bc
    # block 0x004898c2: y = sign-extended arg_y, if y < record+0x1a (top) go to record_miss (jl signed)
    movsx eax, word ptr [ebp + arg_y]            # 004898c2
    mov ecx, dword ptr [ebp - local_this]           # 004898c6
    mov edx, dword ptr [ecx + obj_record_cur]          # 004898c9
    cmp eax, dword ptr [edx + rec_top]          # 004898cc
    jl.d32 record_miss                            # 004898cf
    # block 0x004898d5: if y > record+0x22 (bottom) go to record_miss (jg signed)
    movsx eax, word ptr [ebp + arg_y]            # 004898d5
    mov ecx, dword ptr [ebp - local_this]           # 004898d9
    mov edx, dword ptr [ecx + obj_record_cur]          # 004898dc
    cmp eax, dword ptr [edx + rec_bottom]          # 004898df
    jg.d32 record_miss                            # 004898e2
    # block 0x004898e8: x = sign-extended arg_x, if x < record+0x16 (left) go to record_miss (jl signed)
    movsx eax, word ptr [ebp + arg_x]            # 004898e8
    mov ecx, dword ptr [ebp - local_this]           # 004898ec
    mov edx, dword ptr [ecx + obj_record_cur]          # 004898ef
    cmp eax, dword ptr [edx + rec_left]          # 004898f2
    jl.d32 record_miss                            # 004898f5
    # block 0x004898fb: if x > record+0x1e (right) go to record_miss (jg signed), otherwise the point is inside the record rectangle
    movsx eax, word ptr [ebp + arg_x]            # 004898fb
    mov ecx, dword ptr [ebp - local_this]           # 004898ff
    mov edx, dword ptr [ecx + obj_record_cur]          # 00489902
    cmp eax, dword ptr [edx + rec_right]          # 00489905
    jg.d32 record_miss                            # 00489908
    # block 0x0048990e: hit: held item = word 0x583a29, if it is -1 go to held_item_none_test (je)
    movsx eax, word ptr [0x583a29]               # 0048990e
    cmp eax, -0x1                                # 00489915
    je.d8 held_item_none_test                             # 00489918
    # block 0x0048991a: held item set: if dword 0x5b44f8 != 0 go to held_item_none_test (jne)
    cmp dword ptr [0x5b44f8], 0x0                # 0048991a
    jne.d8 held_item_none_test                            # 00489921
    # block 0x00489923: held item set and 0x5b44f8 == 0: 0x5b44f0 = word 0x583a29 + 0x25, 0x5d162d = [0x571ad3], go to publish_cursor
    movsx ecx, word ptr [0x583a29]               # 00489923
    add ecx, 0x25                                # 0048992a
    mov dword ptr [0x5b44f0], ecx                # 0048992d
    mov edx, dword ptr [0x571ad3]                # 00489933
    mov dword ptr [0x5d162d], edx                # 00489939
    jmp.d8 publish_cursor                            # 0048993f
held_item_none_test:
    # block 0x00489941: held_item_none_test: if word 0x583a29 != -1 go to publish_cursor (jne)
    movsx eax, word ptr [0x583a29]               # 00489941
    cmp eax, -0x1                                # 00489948
    jne.d8 publish_cursor                            # 0048994b
    # block 0x0048994d: held item is -1: if dword 0x5b44f8 != 0 go to publish_cursor (jne)
    cmp dword ptr [0x5b44f8], 0x0                # 0048994d
    jne.d8 publish_cursor                            # 00489954
    # block 0x00489956: held item is -1 and 0x5b44f8 == 0: 0x5b44f0 = 0, 0x5d162d = [0x5d0377]
    mov dword ptr [0x5b44f0], 0x0                # 00489956
    mov ecx, dword ptr [0x5d0377]                # 00489960
    mov dword ptr [0x5d162d], ecx                # 00489966
publish_cursor:
    # block 0x0048996c: publish_cursor: 0x5b44f4 = 1, 0x5d1631 = 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4), 0x5d1639 = 1, 0x5c39e5 = word entry+0xab0 (sign-extended), eax = 1, go to the epilogue
    mov dword ptr [0x5b44f4], 0x1                # 0048996c
    mov edx, dword ptr [0x5b44f0]                # 00489976
    shl edx, 0x5                                 # 0048997c
    mov eax, dword ptr [0x5b44f4]                # 0048997f
    shl eax, 0x4                                 # 00489984
    lea ecx, [edx + eax + 0x5b160c]              # 00489987
    mov dword ptr [0x5d1631], ecx                # 0048998e
    mov dword ptr [0x5d1639], 0x1                # 00489994
    mov edx, dword ptr [ebp - local_this]           # 0048999e
    mov eax, dword ptr [edx + obj_entry_cur]          # 004899a1
    movsx ecx, word ptr [eax + ent_slot_index]        # 004899a4
    mov dword ptr [0x5c39e5], ecx                # 004899ab
    mov eax, 0x1                                 # 004899b1
    jmp.d8 epilogue                            # 004899b6
record_miss:
    # block 0x004899b8: record_miss: go to record_next
    jmp.d32 record_next                           # 004899b8
entry_done:
    # block 0x004899bd: entry_done: go to entry_next
    jmp.d32 entry_next                           # 004899bd
return_0:
    # block 0x004899c2: return_0: eax = 0 (xor eax, eax)
    {load} xor eax, eax                          # 004899c2
epilogue:
    # block 0x004899c4: epilogue: restore the frame, ret 8 pops the two stack arguments
    {load} mov esp, ebp                          # 004899c4
    pop ebp                                      # 004899c6
    ret 0x8                                      # 004899c7
