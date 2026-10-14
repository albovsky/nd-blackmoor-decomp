# FUN_004a42c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a42c0
# extent:       0x004a42c0-0x004a44c0 (512 code bytes)
# span:         0x004a42c0-0x004a44c0 (code 512, tables 0, padding 0)
# sha256:       b899bdc19a2f1b5dc8d9f9a0d94b3869249513ee3d0f4df2d063012104c0af24
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# name:         UIGridObject::SetHoverCursorForRegion
# arguments:    thiscall: ecx=this, three stack arguments popped by the callee (ret 0xc): [ebp+8] = region selector word (sign-extended, one of 0x274f, 0x274c, 0x274d, 0x274e, any other value does nothing), [ebp+0xc] = word stored to this+0x276, [ebp+0x10] = word stored to this+0x278. No return value
# locals:       [ebp-local_this] = this, spilled from ecx. [ebp-local_payload] = the payload pointer of the action slot numbered by the word at this+0x1e (dword 0x5bb5e5 + slot*0x8d), loaded before the selector is tested and used only for selector 0x274f
# fields:       this+0x1e: word slot index (sign-extended, times 0x8d, indexes the payload pointer table at 0x5bb5e5). this+0x276: word, written from arg_hover_a for selectors 0x274c, 0x274d, 0x274e. this+0x278: word, written from arg_hover_b for the same selectors. Payload+0x6bf: word (sign-extended), becomes the cursor type for selector 0x274f. Globals written for every handled selector: 0x005b44f0 (cursor type: payload word for 0x274f, 0x12 for 0x274c and 0x274d, 0x14 for 0x274e), 0x005b44f4 (cursor variant: 1 for 0x274f and 0x274c, 0 for 0x274d and 0x274e), 0x005d162d = dword read from 0x005d0377, 0x005d1631 = 0x5b160c + (type << 5) + (variant << 4), 0x005d1639 = 1, 0x005c39e5 = the selector value (0x274f, 0x274c, 0x274d or 0x274e)
# callees:      none
# track-n:      host-adapter: none
# unverified:   No Track N source covers this routine: src/caption_lifecycle.c and .h model the cursor layer globals (0x5b44f0 type, 0x5b44f4 variant, 0x5d162d surface, 0x5d1631 source index, 0x5d1639 layer enable, 0x5c39e5 scene) but only for the caption text box paths, and 0x4a42c0 is not cited. Class and role names are my labels. The only caller found is 0x4a3f40 in the pseudocode hint, which passes the selector with loop indices (inner index to arg_hover_a, outer index to arg_hover_b) over a grid whose bounds come from payload bytes +0x21 and +0x22, so naming this+0x276 as the column and this+0x278 as the row, and the object as a grid, is inferred from that hint and not verified from the bytes. What the selector values 0x274c to 0x274f (also written to the 0x5c39e5 scene global) and the cursor type numbers 0x12 and 0x14 denote is not established. That the read of this+0x1e is a slot index into the 0x8d-stride action table follows the imul 0x8d and the 0x5bb5e5 base used identically by 0x42ae73 and the s0 trace document. The surface global 0x5d0377 is named the default cursor surface only by src/caption_lifecycle.h. The table at 0x5bb5e5 is the one action slot table: slot base 0x5bb5e3 + slot*0x8d + 2 is the payload pointer (layout per action type, s0-action-runtime-trace.md). 0x5d162d, 0x5d1631 and 0x5d1639 are fields +8, +0xc and +0x14 of entry 2 of the render layer table 0x5d1591 (stride 0x4a, 0x5d1591 + 2*0x4a = 0x5d1625), per tests/caption_lifecycle_original_oracle.py:56-57. Track N's cursor_src_index label counts dwords (src/caption_lifecycle.h:164: (address-0x5b160c)/4); the bytes store the byte address 0x5b160c + (type<<5) + (variant<<4). The direct call sites are 0x4a40ad, 0x4a41b0, 0x4a424e and 0x4a42ac; the containing function was not re-checked here.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_payload, 0x4  # payload pointer of the slot numbered by this+0x1e, read from 0x5bb5e5 + slot*0x8d
.equ local_this, 0x8  # this pointer spilled from ecx
.equ arg_selector, 0x8  # first stack argument: region selector word, sign-extended, compared with 0x274f, 0x274c, 0x274d, 0x274e
.equ arg_hover_a, 0xc  # second stack argument: word stored to this+0x276
.equ arg_hover_b, 0x10  # third stack argument: word stored to this+0x278
.equ obj_slot_index, 0x1e  # this+0x1e: word slot index into the 0x8d-stride action slot table
.equ obj_hover_a, 0x276  # this+0x276: word written from the second stack argument
.equ obj_hover_b, 0x278  # this+0x278: word written from the third stack argument
.equ pl_cursor_type, 0x6bf  # payload+0x6bf: word, cursor type used for selector 0x274f

# --- external targets -----------------------------------------------

.org 0x004a42c0 - 0x401000
.globl FUN_004a42c0
FUN_004a42c0:
    # block 0x004a42c0: entry: spill this, local_payload = payload pointer of slot (word this+0x1e) * 0x8d + 0x5bb5e5, if selector (arg_selector, sign-extended) != 0x274f go to test_274c (jne)
    push ebp                                     # 004a42c0
    {load} mov ebp, esp                          # 004a42c1
    sub esp, 0x8                                 # 004a42c3
    mov dword ptr [ebp - local_this], ecx           # 004a42c6
    mov eax, dword ptr [ebp - local_this]           # 004a42c9
    movsx ecx, word ptr [eax + obj_slot_index]         # 004a42cc
    imul ecx, ecx, 0x8d                          # 004a42d0
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004a42d6
    mov dword ptr [ebp - local_payload], edx           # 004a42dc
    movsx eax, word ptr [ebp + arg_selector]            # 004a42df
    cmp eax, 0x274f                              # 004a42e3
    jne.d8 test_274c                            # 004a42e8
    # block 0x004a42ea: selector 0x274f: 0x5b44f0 = payload word +0x6bf (sign-extended), 0x5b44f4 = 1, 0x5d162d = [0x5d0377], 0x5d1631 = 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4), 0x5d1639 = 1, 0x5c39e5 = 0x274f, then go to the epilogue (this+0x276 and +0x278 are not written)
    mov ecx, dword ptr [ebp - local_payload]           # 004a42ea
    movsx edx, word ptr [ecx + pl_cursor_type]        # 004a42ed
    mov dword ptr [0x5b44f0], edx                # 004a42f4
    mov dword ptr [0x5b44f4], 0x1                # 004a42fa
    mov eax, dword ptr [0x5d0377]                # 004a4304
    mov dword ptr [0x5d162d], eax                # 004a4309
    mov ecx, dword ptr [0x5b44f0]                # 004a430e
    shl ecx, 0x5                                 # 004a4314
    mov edx, dword ptr [0x5b44f4]                # 004a4317
    shl edx, 0x4                                 # 004a431d
    lea eax, [ecx + edx + 0x5b160c]              # 004a4320
    mov dword ptr [0x5d1631], eax                # 004a4327
    mov dword ptr [0x5d1639], 0x1                # 004a432c
    mov dword ptr [0x5c39e5], 0x274f             # 004a4336
    jmp.d32 epilogue                           # 004a4340
test_274c:
    # block 0x004a4345: test_274c: if selector != 0x274c go to test_274d (jne)
    movsx ecx, word ptr [ebp + arg_selector]            # 004a4345
    cmp ecx, 0x274c                              # 004a4349
    jne.d8 test_274d                            # 004a434f
    # block 0x004a4351: selector 0x274c: 0x5b44f0 = 0x12, 0x5b44f4 = 1, 0x5d162d = [0x5d0377], 0x5d1631 = 0x5b160c + (type << 5) + (variant << 4), 0x5d1639 = 1, 0x5c39e5 = 0x274c, this+0x276 = arg_hover_a, this+0x278 = arg_hover_b, go to the epilogue
    mov dword ptr [0x5b44f0], 0x12               # 004a4351
    mov dword ptr [0x5b44f4], 0x1                # 004a435b
    mov edx, dword ptr [0x5d0377]                # 004a4365
    mov dword ptr [0x5d162d], edx                # 004a436b
    mov eax, dword ptr [0x5b44f0]                # 004a4371
    shl eax, 0x5                                 # 004a4376
    mov ecx, dword ptr [0x5b44f4]                # 004a4379
    shl ecx, 0x4                                 # 004a437f
    lea edx, [eax + ecx + 0x5b160c]              # 004a4382
    mov dword ptr [0x5d1631], edx                # 004a4389
    mov dword ptr [0x5d1639], 0x1                # 004a438f
    mov dword ptr [0x5c39e5], 0x274c             # 004a4399
    mov eax, dword ptr [ebp - local_this]           # 004a43a3
    mov cx, word ptr [ebp + arg_hover_a]               # 004a43a6
    mov word ptr [eax + obj_hover_a], cx           # 004a43aa
    mov edx, dword ptr [ebp - local_this]           # 004a43b1
    mov ax, word ptr [ebp + arg_hover_b]              # 004a43b4
    mov word ptr [edx + obj_hover_b], ax           # 004a43b8
    jmp.d32 epilogue                           # 004a43bf
test_274d:
    # block 0x004a43c4: test_274d: if selector != 0x274d go to test_274e (jne)
    movsx ecx, word ptr [ebp + arg_selector]            # 004a43c4
    cmp ecx, 0x274d                              # 004a43c8
    jne.d8 test_274e                            # 004a43ce
    # block 0x004a43d0: selector 0x274d: 0x5b44f0 = 0x12, 0x5b44f4 = 0, 0x5d162d = [0x5d0377], 0x5d1631 = 0x5b160c + (type << 5) + (variant << 4), 0x5d1639 = 1, 0x5c39e5 = 0x274d, this+0x276 = arg_hover_a, this+0x278 = arg_hover_b, go to the epilogue
    mov dword ptr [0x5b44f0], 0x12               # 004a43d0
    mov dword ptr [0x5b44f4], 0x0                # 004a43da
    mov edx, dword ptr [0x5d0377]                # 004a43e4
    mov dword ptr [0x5d162d], edx                # 004a43ea
    mov eax, dword ptr [0x5b44f0]                # 004a43f0
    shl eax, 0x5                                 # 004a43f5
    mov ecx, dword ptr [0x5b44f4]                # 004a43f8
    shl ecx, 0x4                                 # 004a43fe
    lea edx, [eax + ecx + 0x5b160c]              # 004a4401
    mov dword ptr [0x5d1631], edx                # 004a4408
    mov dword ptr [0x5d1639], 0x1                # 004a440e
    mov dword ptr [0x5c39e5], 0x274d             # 004a4418
    mov eax, dword ptr [ebp - local_this]           # 004a4422
    mov cx, word ptr [ebp + arg_hover_a]               # 004a4425
    mov word ptr [eax + obj_hover_a], cx           # 004a4429
    mov edx, dword ptr [ebp - local_this]           # 004a4430
    mov ax, word ptr [ebp + arg_hover_b]              # 004a4433
    mov word ptr [edx + obj_hover_b], ax           # 004a4437
    jmp.d8 epilogue                            # 004a443e
test_274e:
    # block 0x004a4440: test_274e: if selector != 0x274e go to the epilogue (jne), other selectors have no effect
    movsx ecx, word ptr [ebp + arg_selector]            # 004a4440
    cmp ecx, 0x274e                              # 004a4444
    jne.d8 epilogue                            # 004a444a
    # block 0x004a444c: selector 0x274e: 0x5b44f0 = 0x14, 0x5b44f4 = 0, 0x5d162d = [0x5d0377], 0x5d1631 = 0x5b160c + (type << 5) + (variant << 4), 0x5d1639 = 1, 0x5c39e5 = 0x274e, this+0x276 = arg_hover_a, this+0x278 = arg_hover_b, fall into the epilogue
    mov dword ptr [0x5b44f0], 0x14               # 004a444c
    mov dword ptr [0x5b44f4], 0x0                # 004a4456
    mov edx, dword ptr [0x5d0377]                # 004a4460
    mov dword ptr [0x5d162d], edx                # 004a4466
    mov eax, dword ptr [0x5b44f0]                # 004a446c
    shl eax, 0x5                                 # 004a4471
    mov ecx, dword ptr [0x5b44f4]                # 004a4474
    shl ecx, 0x4                                 # 004a447a
    lea edx, [eax + ecx + 0x5b160c]              # 004a447d
    mov dword ptr [0x5d1631], edx                # 004a4484
    mov dword ptr [0x5d1639], 0x1                # 004a448a
    mov dword ptr [0x5c39e5], 0x274e             # 004a4494
    mov eax, dword ptr [ebp - local_this]           # 004a449e
    mov cx, word ptr [ebp + arg_hover_a]               # 004a44a1
    mov word ptr [eax + obj_hover_a], cx           # 004a44a5
    mov edx, dword ptr [ebp - local_this]           # 004a44ac
    mov ax, word ptr [ebp + arg_hover_b]              # 004a44af
    mov word ptr [edx + obj_hover_b], ax           # 004a44b3
epilogue:
    # block 0x004a44ba: epilogue: restore the frame, ret 0xc pops the three stack arguments
    {load} mov esp, ebp                          # 004a44ba
    pop ebp                                      # 004a44bc
    ret 0xc                                      # 004a44bd
