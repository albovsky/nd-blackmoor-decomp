# FUN_00484762
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00484762
# extent:       0x00484762-0x00484935 (467 code bytes)
# span:         0x00484762-0x00484935 (code 467, tables 0, padding 0)
# sha256:       18857f1882b6325bbd9f20668785eb0a93c1edd406423aeb122c200b7f5a6fb5
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# name:         RecordTable::records_rects_overlap
# arguments:    thiscall: ecx=this; two stack dwords, [ebp+8] = index a, [ebp+0xc] = index b (record numbers, used only as index*0x85 and not range-checked); callee pops 8 (ret 8); returns eax=1 when the two records' rectangles overlap and every computed overlap coordinate differs from -1, else eax=0
# locals:       this_ptr = this spilled from ecx; rec_a_ptr, rec_b_ptr = record pointers (this+0x28+index*0x85); frame_a_ptr, frame_b_ptr = the current 0x18-byte frame entry of each record; rect_a_ptr, rect_b_ptr = record+2 (a 16-byte rectangle of four signed dwords); isect_x1, isect_y1, isect_x2, isect_y2 = overlap corner results, preset to -1 and written only on overlap; frame_a_word and frame_b_word are word copies of frame+0x14 that are written and never read
# fields:       this+0x28: base of an array of 0x85-byte records; record+0x02: rectangle (+0x00,+0x04,+0x08,+0x0c dwords, compared signed); record+0x22: byte index of the current frame; record+0x24: array of 0x18-byte frame entries; frame+0x14: word copied to a local but never used; no absolute globals touched; no stores to the object (only locals are written)
# callees:      none
# track-n:      host-adapter: none
# unverified:   The role of the 0x85-byte records (the caller FUN_00484935 in the pseudocode loops over a word count at [x+0x21] and calls this for every other record) and of the rectangle are not established; calling the rectangle fields x1,y1,x2,y2 is a label for the pairing that the code uses (+0/+8 share one axis, +4/+0xc the other), not a proven meaning. The x range is treated as inclusive on both ends (jl/jg reject only strictly outside). The result is a boolean; the intersection corners are computed but never returned or stored outside the frame, and a real overlap whose corner coordinate equals -1 is reported as no overlap because -1 doubles as the not-set marker. The frame pointers and the two frame words are computed but unused, so whether a removed field or a removed use was intended cannot be told from these bytes. The method name and class name are my labels from the caller shape, not recovered identifiers.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ rec_b_ptr, 0x4  # record b pointer = this+0x28+arg_index_b*0x85
.equ isect_y2, 0x8  # overlap y2 result (from rect +0x0c), preset -1
.equ isect_x2, 0xc  # overlap x2 result (from rect +0x08), preset -1
.equ isect_y1, 0x10  # overlap y1 result (from rect +0x04), preset -1
.equ isect_x1, 0x14  # overlap x1 result (from rect +0x00), preset -1
.equ rect_a_ptr, 0x18  # rectangle a pointer = record a + 2
.equ frame_b_ptr, 0x1c  # current frame entry of record b: record_b+0x24+frame_index*0x18
.equ rect_b_ptr, 0x20  # rectangle b pointer = record b + 2
.equ rec_a_ptr, 0x24  # record a pointer = this+0x28+arg_index_a*0x85
.equ frame_b_word, 0x28  # word copy of frame_b+0x14, written and never read
.equ frame_a_ptr, 0x2c  # current frame entry of record a: record_a+0x24+frame_index*0x18
.equ frame_a_word, 0x30  # word copy of frame_a+0x14, written and never read
.equ this_ptr, 0x34  # this, spilled from ecx
.equ rect_y1, 0x4  # rectangle +0x04 dword (first value of the second axis)
.equ arg_index_a, 0x8  # stack argument 1: record index a
.equ rect_x2, 0x8  # rectangle +0x08 dword (second value of the first axis)
.equ arg_index_b, 0xc  # stack argument 2: record index b
.equ rect_y2, 0xc  # rectangle +0x0c dword (second value of the second axis)
.equ frame_word_14, 0x14  # frame entry +0x14 word (copied to a local, never used)
.equ rec_frame_index, 0x22  # record +0x22 byte: index of the current frame entry
.equ rec_frames, 0x24  # record +0x24: array of 0x18-byte frame entries
.equ this_records, 0x28  # this+0x28: base of the array of 0x85-byte records

# --- external targets -----------------------------------------------

.org 0x00484762 - 0x401000
.globl FUN_00484762
FUN_00484762:
    # block 0x00484762: entry: build rec_a_ptr and rec_b_ptr as this+0x28+index*0x85, frame_a_ptr/frame_b_ptr as record+0x24+record[+0x22]*0x18, rect_a_ptr/rect_b_ptr as record+2, copy frame+0x14 words to unused locals, preset the four overlap results to -1; then signed compare a.x1 (rect+0x00) with b.x1: jge to the case a starts at or right of b
    push ebp                                     # 00484762
    {load} mov ebp, esp                          # 00484763
    sub esp, 0x34                                # 00484765
    mov dword ptr [ebp - this_ptr], ecx          # 00484768
    mov eax, dword ptr [ebp + arg_index_a]             # 0048476b
    imul eax, eax, 0x85                          # 0048476e
    mov ecx, dword ptr [ebp - this_ptr]          # 00484774
    lea edx, [ecx + eax + this_records]              # 00484777
    mov dword ptr [ebp - rec_a_ptr], edx          # 0048477b
    mov eax, dword ptr [ebp + arg_index_b]             # 0048477e
    imul eax, eax, 0x85                          # 00484781
    mov ecx, dword ptr [ebp - this_ptr]          # 00484787
    lea edx, [ecx + eax + this_records]              # 0048478a
    mov dword ptr [ebp - rec_b_ptr], edx           # 0048478e
    mov eax, dword ptr [ebp - rec_a_ptr]          # 00484791
    {load} xor ecx, ecx                          # 00484794
    mov cl, byte ptr [eax + rec_frame_index]            # 00484796
    imul ecx, ecx, 0x18                          # 00484799
    mov edx, dword ptr [ebp - rec_a_ptr]          # 0048479c
    lea eax, [edx + ecx + rec_frames]              # 0048479f
    mov dword ptr [ebp - frame_a_ptr], eax          # 004847a3
    mov ecx, dword ptr [ebp - rec_b_ptr]           # 004847a6
    {load} xor edx, edx                          # 004847a9
    mov dl, byte ptr [ecx + rec_frame_index]            # 004847ab
    imul edx, edx, 0x18                          # 004847ae
    mov eax, dword ptr [ebp - rec_b_ptr]           # 004847b1
    lea ecx, [eax + edx + rec_frames]              # 004847b4
    mov dword ptr [ebp - frame_b_ptr], ecx          # 004847b8
    mov edx, dword ptr [ebp - rec_a_ptr]          # 004847bb
    add edx, 0x2                                 # 004847be
    mov dword ptr [ebp - rect_a_ptr], edx          # 004847c1
    mov eax, dword ptr [ebp - rec_b_ptr]           # 004847c4
    add eax, 0x2                                 # 004847c7
    mov dword ptr [ebp - rect_b_ptr], eax          # 004847ca
    mov ecx, dword ptr [ebp - frame_a_ptr]          # 004847cd
    mov dx, word ptr [ecx + frame_word_14]            # 004847d0
    mov word ptr [ebp - frame_a_word], dx            # 004847d4
    mov eax, dword ptr [ebp - frame_b_ptr]          # 004847d8
    mov cx, word ptr [eax + frame_word_14]            # 004847db
    mov word ptr [ebp - frame_b_word], cx            # 004847df
    or edx, -0x1                                 # 004847e3
    mov dword ptr [ebp - isect_x1], edx          # 004847e6
    mov dword ptr [ebp - isect_y1], edx          # 004847e9
    mov dword ptr [ebp - isect_x2], edx           # 004847ec
    mov dword ptr [ebp - isect_y2], edx           # 004847ef
    mov eax, dword ptr [ebp - rect_a_ptr]          # 004847f2
    mov ecx, dword ptr [ebp - rect_b_ptr]          # 004847f5
    mov edx, dword ptr [eax]                     # 004847f8
    cmp edx, dword ptr [ecx]                     # 004847fa
    jge.d8 xp2_a_not_left_of_b                            # 004847fc
    # block 0x004847fe: case a.x1 < b.x1: compare a.x2 (rect+0x08) with b.x1; jl means a ends before b starts (miss)
    mov eax, dword ptr [ebp - rect_a_ptr]          # 004847fe
    mov ecx, dword ptr [ebp - rect_b_ptr]          # 00484801
    mov edx, dword ptr [eax + rect_x2]           # 00484804
    cmp edx, dword ptr [ecx]                     # 00484807
    jl.d8 xp1_miss_a_ends_before_b                             # 00484809
    # block 0x0048480b: a.x1 < b.x1 and a.x2 >= b.x1: isect_x1 = b.x1; then compare a.x2 with b.x2 and jle to take a.x2
    mov eax, dword ptr [ebp - rect_b_ptr]          # 0048480b
    mov ecx, dword ptr [eax]                     # 0048480e
    mov dword ptr [ebp - isect_x1], ecx          # 00484810
    mov edx, dword ptr [ebp - rect_a_ptr]          # 00484813
    mov eax, dword ptr [ebp - rect_b_ptr]          # 00484816
    mov ecx, dword ptr [edx + rect_x2]           # 00484819
    cmp ecx, dword ptr [eax + rect_x2]           # 0048481c
    jle.d8 xp1_x2_from_a                            # 0048481f
    # block 0x00484821: a.x2 > b.x2: isect_x2 = b.x2, jump to join
    mov edx, dword ptr [ebp - rect_b_ptr]          # 00484821
    mov eax, dword ptr [edx + rect_x2]           # 00484824
    mov dword ptr [ebp - isect_x2], eax           # 00484827
    jmp.d8 xp1_join                            # 0048482a
xp1_x2_from_a:
    # block 0x0048482c: a.x2 <= b.x2: isect_x2 = a.x2
    mov ecx, dword ptr [ebp - rect_a_ptr]          # 0048482c
    mov edx, dword ptr [ecx + rect_x2]           # 0048482f
    mov dword ptr [ebp - isect_x2], edx           # 00484832
xp1_join:
    # block 0x00484835: join after the first x case: jump on to the common exit
    jmp.d8 xp1_done                            # 00484835
xp1_miss_a_ends_before_b:
    # block 0x00484837: x miss, a ends before b: return 0 through the epilogue
    {load} xor eax, eax                          # 00484837
    jmp.d32 epilogue                           # 00484839
xp1_done:
    # block 0x0048483e: first x case finished: jump to the y range test
    jmp.d8 y_range_start                            # 0048483e
xp2_a_not_left_of_b:
    # block 0x00484840: case a.x1 >= b.x1: compare a.x1 with b.x2; jg means a starts after b ends (miss)
    mov eax, dword ptr [ebp - rect_a_ptr]          # 00484840
    mov ecx, dword ptr [ebp - rect_b_ptr]          # 00484843
    mov edx, dword ptr [eax]                     # 00484846
    cmp edx, dword ptr [ecx + rect_x2]           # 00484848
    jg.d8 xp2_miss_a_starts_after_b                             # 0048484b
    # block 0x0048484d: a.x1 >= b.x1 and a.x1 <= b.x2: isect_x1 = a.x1; compare a.x2 with b.x2 and jg to take b.x2
    mov eax, dword ptr [ebp - rect_a_ptr]          # 0048484d
    mov ecx, dword ptr [eax]                     # 00484850
    mov dword ptr [ebp - isect_x1], ecx          # 00484852
    mov edx, dword ptr [ebp - rect_a_ptr]          # 00484855
    mov eax, dword ptr [ebp - rect_b_ptr]          # 00484858
    mov ecx, dword ptr [edx + rect_x2]           # 0048485b
    cmp ecx, dword ptr [eax + rect_x2]           # 0048485e
    jg.d8 xp2_x2_from_b                             # 00484861
    # block 0x00484863: a.x2 <= b.x2: isect_x2 = a.x2, jump to join
    mov edx, dword ptr [ebp - rect_a_ptr]          # 00484863
    mov eax, dword ptr [edx + rect_x2]           # 00484866
    mov dword ptr [ebp - isect_x2], eax           # 00484869
    jmp.d8 xp2_join                            # 0048486c
xp2_x2_from_b:
    # block 0x0048486e: a.x2 > b.x2: isect_x2 = b.x2
    mov ecx, dword ptr [ebp - rect_b_ptr]          # 0048486e
    mov edx, dword ptr [ecx + rect_x2]           # 00484871
    mov dword ptr [ebp - isect_x2], edx           # 00484874
xp2_join:
    # block 0x00484877: join after the second x case: jump on to the y range test
    jmp.d8 y_range_start                            # 00484877
xp2_miss_a_starts_after_b:
    # block 0x00484879: x miss, a starts after b ends: return 0 through the epilogue
    {load} xor eax, eax                          # 00484879
    jmp.d32 epilogue                           # 0048487b
y_range_start:
    # block 0x00484880: y range test: compare a.y1 (rect+0x04) with b.y1; jge to the case a starts at or below b
    mov eax, dword ptr [ebp - rect_a_ptr]          # 00484880
    mov ecx, dword ptr [ebp - rect_b_ptr]          # 00484883
    mov edx, dword ptr [eax + rect_y1]           # 00484886
    cmp edx, dword ptr [ecx + rect_y1]           # 00484889
    jge.d8 yp2_a_not_above_b                            # 0048488c
    # block 0x0048488e: case a.y1 < b.y1: compare a.y2 (rect+0x0c) with b.y1; jl means a ends before b (miss)
    mov eax, dword ptr [ebp - rect_a_ptr]          # 0048488e
    mov ecx, dword ptr [ebp - rect_b_ptr]          # 00484891
    mov edx, dword ptr [eax + rect_y2]           # 00484894
    cmp edx, dword ptr [ecx + rect_y1]           # 00484897
    jl.d8 yp1_miss_a_ends_before_b                             # 0048489a
    # block 0x0048489c: a.y1 < b.y1 and a.y2 >= b.y1: isect_y1 = b.y1; compare a.y2 with b.y2 and jle to take a.y2
    mov eax, dword ptr [ebp - rect_b_ptr]          # 0048489c
    mov ecx, dword ptr [eax + rect_y1]           # 0048489f
    mov dword ptr [ebp - isect_y1], ecx          # 004848a2
    mov edx, dword ptr [ebp - rect_a_ptr]          # 004848a5
    mov eax, dword ptr [ebp - rect_b_ptr]          # 004848a8
    mov ecx, dword ptr [edx + rect_y2]           # 004848ab
    cmp ecx, dword ptr [eax + rect_y2]           # 004848ae
    jle.d8 yp1_y2_from_a                            # 004848b1
    # block 0x004848b3: a.y2 > b.y2: isect_y2 = b.y2, jump to join
    mov edx, dword ptr [ebp - rect_b_ptr]          # 004848b3
    mov eax, dword ptr [edx + rect_y2]           # 004848b6
    mov dword ptr [ebp - isect_y2], eax           # 004848b9
    jmp.d8 yp1_join                            # 004848bc
yp1_y2_from_a:
    # block 0x004848be: a.y2 <= b.y2: isect_y2 = a.y2
    mov ecx, dword ptr [ebp - rect_a_ptr]          # 004848be
    mov edx, dword ptr [ecx + rect_y2]           # 004848c1
    mov dword ptr [ebp - isect_y2], edx           # 004848c4
yp1_join:
    # block 0x004848c7: join after the first y case: jump on to the common exit
    jmp.d8 yp1_done                            # 004848c7
yp1_miss_a_ends_before_b:
    # block 0x004848c9: y miss, a ends before b: return 0 through the epilogue
    {load} xor eax, eax                          # 004848c9
    jmp.d8 epilogue                            # 004848cb
yp1_done:
    # block 0x004848cd: first y case finished: jump to the all-coordinates-set check
    jmp.d8 check_all_set                            # 004848cd
yp2_a_not_above_b:
    # block 0x004848cf: case a.y1 >= b.y1: compare a.y1 with b.y2; jg means a starts after b ends (miss)
    mov eax, dword ptr [ebp - rect_a_ptr]          # 004848cf
    mov ecx, dword ptr [ebp - rect_b_ptr]          # 004848d2
    mov edx, dword ptr [eax + rect_y1]           # 004848d5
    cmp edx, dword ptr [ecx + rect_y2]           # 004848d8
    jg.d8 yp2_miss_a_starts_after_b                             # 004848db
    # block 0x004848dd: a.y1 >= b.y1 and a.y1 <= b.y2: isect_y1 = a.y1; compare a.y2 with b.y2 and jg to take b.y2
    mov eax, dword ptr [ebp - rect_a_ptr]          # 004848dd
    mov ecx, dword ptr [eax + rect_y1]           # 004848e0
    mov dword ptr [ebp - isect_y1], ecx          # 004848e3
    mov edx, dword ptr [ebp - rect_a_ptr]          # 004848e6
    mov eax, dword ptr [ebp - rect_b_ptr]          # 004848e9
    mov ecx, dword ptr [edx + rect_y2]           # 004848ec
    cmp ecx, dword ptr [eax + rect_y2]           # 004848ef
    jg.d8 yp2_y2_from_b                             # 004848f2
    # block 0x004848f4: a.y2 <= b.y2: isect_y2 = a.y2, jump to join
    mov edx, dword ptr [ebp - rect_a_ptr]          # 004848f4
    mov eax, dword ptr [edx + rect_y2]           # 004848f7
    mov dword ptr [ebp - isect_y2], eax           # 004848fa
    jmp.d8 yp2_join                            # 004848fd
yp2_y2_from_b:
    # block 0x004848ff: a.y2 > b.y2: isect_y2 = b.y2
    mov ecx, dword ptr [ebp - rect_b_ptr]          # 004848ff
    mov edx, dword ptr [ecx + rect_y2]           # 00484902
    mov dword ptr [ebp - isect_y2], edx           # 00484905
yp2_join:
    # block 0x00484908: join after the second y case: jump on to the all-coordinates-set check
    jmp.d8 check_all_set                            # 00484908
yp2_miss_a_starts_after_b:
    # block 0x0048490a: y miss, a starts after b ends: return 0 through the epilogue
    {load} xor eax, eax                          # 0048490a
    jmp.d8 epilogue                            # 0048490c
check_all_set:
    # block 0x0048490e: overlap found on both axes: if isect_y1 is -1 take return_zero
    cmp dword ptr [ebp - isect_y1], -0x1         # 0048490e
    je.d8 return_zero                             # 00484912
    # block 0x00484914: if isect_y2 is -1 take return_zero
    cmp dword ptr [ebp - isect_y2], -0x1          # 00484914
    je.d8 return_zero                             # 00484918
    # block 0x0048491a: if isect_x1 is -1 take return_zero
    cmp dword ptr [ebp - isect_x1], -0x1         # 0048491a
    je.d8 return_zero                             # 0048491e
    # block 0x00484920: if isect_x2 is not -1 take return_one, else fall into return_zero
    cmp dword ptr [ebp - isect_x2], -0x1          # 00484920
    jne.d8 return_one                            # 00484924
return_zero:
    # block 0x00484926: result 0: eax = 0 (a coordinate equals the -1 marker), jump to the epilogue
    {load} xor eax, eax                          # 00484926
    jmp.d8 epilogue                            # 00484928
return_one:
    # block 0x0048492a: result 1: the rectangles overlap and no corner is -1, eax = 1
    mov eax, 0x1                                 # 0048492a
epilogue:
    # block 0x0048492f: epilogue: restore the frame and return, popping the two stack arguments (ret 8)
    {load} mov esp, ebp                          # 0048492f
    pop ebp                                      # 00484931
    ret 0x8                                      # 00484932
