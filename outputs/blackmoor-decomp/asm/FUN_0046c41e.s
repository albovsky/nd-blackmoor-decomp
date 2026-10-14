# FUN_0046c41e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046c41e
# extent:       0x0046c41e-0x0046c6a9 (651 code bytes)
# span:         0x0046c41e-0x0046c6a9 (code 651, tables 0, padding 0)
# sha256:       97dd00785d63c8e2705fdfe79c897c6eef3a9caeb63c9e57cf5fcda6b09184df
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# name:         RequestPanel::post_event_request
# arguments:    thiscall: ecx=this (spilled to local_this; the callers in 0x46bca9 pass an object they keep at [ebp-0x14]); [ebp+8]=arg_event_code int16 (0x27e2..0x27ea, other values do nothing); [ebp+0xc]=arg_value_a int16 (stored to this+0x4a50); [ebp+0x10]=arg_value_b int16 (stored to this+0x4a52); [ebp+0x14]=arg_slot int16 (stored to this+0x49e2 or replaced by 0xffff); callee pops 0x10 (ret 0x10); no return value (eax is not set; callers load eax=1 themselves)
# locals:       frame 8 bytes: local_record [ebp-4] = dword loaded from [0x5bb5e5 + int16(this+0x1e) * 0x8d] (pointer to the active record, read only for code 0x27ea); local_this [ebp-8] = this spilled from ecx
# fields:       this+0x1e: int16 index into the record table at 0x5bb5e5 (stride 0x8d); this+0x4a50: int16 written with arg_value_a; this+0x4a52: int16 written with arg_value_b; this+0x49e2: int16 written with arg_slot or 0xffff; record+0x6e1: int16 read for code 0x27ea and stored sign-extended in [0x5b44f0]; globals 0x005b44f0 (dword selector: 0x24, 0x20 or record+0x6e1), 0x005b44f4 (dword 1 or 0), 0x005d0377 (dword read), 0x005d162d (dword written with the value of 0x5d0377), 0x005d1631 (dword pointer into the table at 0x5b160c), 0x005d1639 (dword, set to 1), 0x005c39e5 (dword event request code, written with arg_event_code sign-extended)
# callees:      none
# track-n:      host-adapter: none
# unverified:   No Track N source covers this routine; RequestPanel::post_event_request, the argument names and the field names are my labels. By the bytes it writes the same family of globals as 0x470ffe (a selector at 0x5b44f0, 0x5b44f4, a copy of 0x5d0377 into 0x5d162d, a pointer built as 0x5b160c + 32*selector + 16*second selector into 0x5d1631, 1 into 0x5d1639, then the event code into 0x5c39e5); what those globals mean to the engine is not established here, and the link of 0x5c39e5 to the pending-event index described in outputs/blackmoor-decomp/s0-action-runtime-trace.md was not traced. The nine call sites in 0x46bca9 push arg_slot first (a loop index or -1) and the event code last; their meaning and the meaning of arg_value_a and arg_value_b (the callers pass values compared with 16-byte entries around this+0x48aa) were only skimmed. Code groups by selector: 0x27e2..0x27e5 use selector 0x24 and store arg_slot to this+0x49e2 only for 0x27e2 and 0x27e4 (0xffff for 0x27e3 and 0x27e5); 0x27e6 and 0x27e8 use selector 0x20 with second selector 1 and store arg_slot; 0x27e7 and 0x27e9 use selector 0x20 with second selector 0 and store 0xffff; 0x27ea takes the selector from the record and does not write this+0x4a50, this+0x4a52 or this+0x49e2. The pointer values (0x5b160c + ...) are computed by the code and not checked against the table that they index. Unsafe original behaviour: no check of the record-table index or of the record pointer (read only for 0x27ea); a native port must reject an out-of-range index explicitly. A code outside 0x27e2..0x27ea returns with no store at all.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_record, 0x4  # [ebp - 0x4]: pointer to the active record from [0x5bb5e5 + this_record_index*0x8d]
.equ local_this, 0x8  # [ebp - 0x8]: this, spilled from ecx
.equ arg_event_code, 0x8  # [ebp + 0x8]: int16 event code 0x27e2..0x27ea
.equ arg_value_a, 0xc  # [ebp + 0xc]: int16 stored to this+0x4a50
.equ arg_value_b, 0x10  # [ebp + 0x10]: int16 stored to this+0x4a52
.equ arg_slot, 0x14  # [ebp + 0x14]: int16 stored to this+0x49e2 for some codes
.equ this_record_index, 0x1e  # this+0x1e: int16 index into the record table at 0x5bb5e5 (stride 0x8d)
.equ rec_selector, 0x6e1  # record+0x6e1: int16 selector copied (sign-extended) into [0x5b44f0] for code 0x27ea
.equ this_request_slot, 0x49e2  # this+0x49e2: int16 slot of the request, arg_slot or 0xffff
.equ this_request_value_a, 0x4a50  # this+0x4a50: int16 copy of arg_value_a
.equ this_request_value_b, 0x4a52  # this+0x4a52: int16 copy of arg_value_b

# --- external targets -----------------------------------------------

.org 0x0046c41e - 0x401000
.globl FUN_0046c41e
FUN_0046c41e:
    # block 0x0046c41e: entry: spill this, local_record = dword [0x5bb5e5 + int16 this_record_index * 0x8d]; if int16 arg_event_code != 0x27ea go to L_check_group_24 (jne)
    push ebp                                     # 0046c41e
    {load} mov ebp, esp                          # 0046c41f
    sub esp, 0x8                                 # 0046c421
    mov dword ptr [ebp - local_this], ecx           # 0046c424
    mov eax, dword ptr [ebp - local_this]           # 0046c427
    movsx ecx, word ptr [eax + this_record_index]         # 0046c42a
    imul ecx, ecx, 0x8d                          # 0046c42e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046c434
    mov dword ptr [ebp - local_record], edx           # 0046c43a
    movsx eax, word ptr [ebp + arg_event_code]            # 0046c43d
    cmp eax, 0x27ea                              # 0046c441
    jne.d8 L_check_group_24                            # 0046c446
    # block 0x0046c448: code 0x27ea: [0x5b44f0] = sign-extended int16 rec_selector, [0x5b44f4] = 1, [0x5d162d] = [0x5d0377], [0x5d1631] = 0x5b160c + 32*[0x5b44f0] + 16*[0x5b44f4], [0x5d1639] = 1, [0x5c39e5] = 0x27ea; nothing is stored to the this+0x49e2/0x4a50/0x4a52 fields; go to L_return
    mov ecx, dword ptr [ebp - local_record]           # 0046c448
    movsx edx, word ptr [ecx + rec_selector]        # 0046c44b
    mov dword ptr [0x5b44f0], edx                # 0046c452
    mov dword ptr [0x5b44f4], 0x1                # 0046c458
    mov eax, dword ptr [0x5d0377]                # 0046c462
    mov dword ptr [0x5d162d], eax                # 0046c467
    mov ecx, dword ptr [0x5b44f0]                # 0046c46c
    shl ecx, 0x5                                 # 0046c472
    mov edx, dword ptr [0x5b44f4]                # 0046c475
    shl edx, 0x4                                 # 0046c47b
    lea eax, [ecx + edx + 0x5b160c]              # 0046c47e
    mov dword ptr [0x5d1631], eax                # 0046c485
    mov dword ptr [0x5d1639], 0x1                # 0046c48a
    mov dword ptr [0x5c39e5], 0x27ea             # 0046c494
    jmp.d32 L_return                           # 0046c49e
L_check_group_24:
    # block 0x0046c4a3: not 0x27ea (L_check_group_24): if arg_event_code == 0x27e2 go to L_group_24 (je)
    movsx ecx, word ptr [ebp + arg_event_code]            # 0046c4a3
    cmp ecx, 0x27e2                              # 0046c4a7
    je.d8 L_group_24                             # 0046c4ad
    # block 0x0046c4af: if arg_event_code == 0x27e3 go to L_group_24 (je)
    movsx edx, word ptr [ebp + arg_event_code]            # 0046c4af
    cmp edx, 0x27e3                              # 0046c4b3
    je.d8 L_group_24                             # 0046c4b9
    # block 0x0046c4bb: if arg_event_code == 0x27e4 go to L_group_24 (je)
    movsx eax, word ptr [ebp + arg_event_code]            # 0046c4bb
    cmp eax, 0x27e4                              # 0046c4bf
    je.d8 L_group_24                             # 0046c4c4
    # block 0x0046c4c6: if arg_event_code != 0x27e5 go to L_check_group_20_on (jne), else fall into L_group_24
    movsx ecx, word ptr [ebp + arg_event_code]            # 0046c4c6
    cmp ecx, 0x27e5                              # 0046c4ca
    jne.d32 L_check_group_20_on                           # 0046c4d0
L_group_24:
    # block 0x0046c4d6: codes 0x27e2..0x27e5 (L_group_24): [0x5b44f0] = 0x24, [0x5b44f4] = 1, [0x5d162d] = [0x5d0377], [0x5d1631] rebuilt from the two globals, [0x5d1639] = 1, [0x5c39e5] = sign-extended arg_event_code, this_request_value_b = arg_value_b, this_request_value_a = arg_value_a; if the code is 0x27e2 go to L_group_24_store_slot (je)
    mov dword ptr [0x5b44f0], 0x24               # 0046c4d6
    mov dword ptr [0x5b44f4], 0x1                # 0046c4e0
    mov edx, dword ptr [0x5d0377]                # 0046c4ea
    mov dword ptr [0x5d162d], edx                # 0046c4f0
    mov eax, dword ptr [0x5b44f0]                # 0046c4f6
    shl eax, 0x5                                 # 0046c4fb
    mov ecx, dword ptr [0x5b44f4]                # 0046c4fe
    shl ecx, 0x4                                 # 0046c504
    lea edx, [eax + ecx + 0x5b160c]              # 0046c507
    mov dword ptr [0x5d1631], edx                # 0046c50e
    mov dword ptr [0x5d1639], 0x1                # 0046c514
    movsx eax, word ptr [ebp + arg_event_code]            # 0046c51e
    mov dword ptr [0x5c39e5], eax                # 0046c522
    mov ecx, dword ptr [ebp - local_this]           # 0046c527
    mov dx, word ptr [ebp + arg_value_b]              # 0046c52a
    mov word ptr [ecx + this_request_value_b], dx          # 0046c52e
    mov eax, dword ptr [ebp - local_this]           # 0046c535
    mov cx, word ptr [ebp + arg_value_a]               # 0046c538
    mov word ptr [eax + this_request_value_a], cx          # 0046c53c
    movsx edx, word ptr [ebp + arg_event_code]            # 0046c543
    cmp edx, 0x27e2                              # 0046c547
    je.d8 L_group_24_store_slot                             # 0046c54d
    # block 0x0046c54f: if arg_event_code != 0x27e4 go to L_group_24_no_slot (jne), else store the slot
    movsx eax, word ptr [ebp + arg_event_code]            # 0046c54f
    cmp eax, 0x27e4                              # 0046c553
    jne.d8 L_group_24_no_slot                            # 0046c558
L_group_24_store_slot:
    # block 0x0046c55a: codes 0x27e2 and 0x27e4 (L_group_24_store_slot): this_request_slot = arg_slot, go to L_group_24_done
    mov ecx, dword ptr [ebp - local_this]           # 0046c55a
    mov dx, word ptr [ebp + arg_slot]              # 0046c55d
    mov word ptr [ecx + this_request_slot], dx          # 0046c561
    jmp.d8 L_group_24_done                            # 0046c568
L_group_24_no_slot:
    # block 0x0046c56a: codes 0x27e3 and 0x27e5 (L_group_24_no_slot): this_request_slot = 0xffff
    mov eax, dword ptr [ebp - local_this]           # 0046c56a
    mov word ptr [eax + this_request_slot], 0xffff      # 0046c56d
L_group_24_done:
    # block 0x0046c576: group 0x24 done (L_group_24_done): go to L_return
    jmp.d32 L_return                           # 0046c576
L_check_group_20_on:
    # block 0x0046c57b: not the 0x24 group (L_check_group_20_on): if arg_event_code == 0x27e6 go to L_group_20_on (je)
    movsx ecx, word ptr [ebp + arg_event_code]            # 0046c57b
    cmp ecx, 0x27e6                              # 0046c57f
    je.d8 L_group_20_on                             # 0046c585
    # block 0x0046c587: if arg_event_code != 0x27e8 go to L_check_group_20_off (jne), else fall into L_group_20_on
    movsx edx, word ptr [ebp + arg_event_code]            # 0046c587
    cmp edx, 0x27e8                              # 0046c58b
    jne.d8 L_check_group_20_off                            # 0046c591
L_group_20_on:
    # block 0x0046c593: codes 0x27e6 and 0x27e8 (L_group_20_on): [0x5b44f0] = 0x20, [0x5b44f4] = 1, [0x5d162d] = [0x5d0377], [0x5d1631] rebuilt, [0x5d1639] = 1, [0x5c39e5] = sign-extended arg_event_code, this_request_value_b = arg_value_b, this_request_value_a = arg_value_a, this_request_slot = arg_slot; go to L_return
    mov dword ptr [0x5b44f0], 0x20               # 0046c593
    mov dword ptr [0x5b44f4], 0x1                # 0046c59d
    mov eax, dword ptr [0x5d0377]                # 0046c5a7
    mov dword ptr [0x5d162d], eax                # 0046c5ac
    mov ecx, dword ptr [0x5b44f0]                # 0046c5b1
    shl ecx, 0x5                                 # 0046c5b7
    mov edx, dword ptr [0x5b44f4]                # 0046c5ba
    shl edx, 0x4                                 # 0046c5c0
    lea eax, [ecx + edx + 0x5b160c]              # 0046c5c3
    mov dword ptr [0x5d1631], eax                # 0046c5ca
    mov dword ptr [0x5d1639], 0x1                # 0046c5cf
    movsx ecx, word ptr [ebp + arg_event_code]            # 0046c5d9
    mov dword ptr [0x5c39e5], ecx                # 0046c5dd
    mov edx, dword ptr [ebp - local_this]           # 0046c5e3
    mov ax, word ptr [ebp + arg_value_b]              # 0046c5e6
    mov word ptr [edx + this_request_value_b], ax          # 0046c5ea
    mov ecx, dword ptr [ebp - local_this]           # 0046c5f1
    mov dx, word ptr [ebp + arg_value_a]               # 0046c5f4
    mov word ptr [ecx + this_request_value_a], dx          # 0046c5f8
    mov eax, dword ptr [ebp - local_this]           # 0046c5ff
    mov cx, word ptr [ebp + arg_slot]              # 0046c602
    mov word ptr [eax + this_request_slot], cx          # 0046c606
    jmp.d32 L_return                           # 0046c60d
L_check_group_20_off:
    # block 0x0046c612: not 0x27e6 or 0x27e8 (L_check_group_20_off): if arg_event_code == 0x27e7 go to L_group_20_off (je)
    movsx edx, word ptr [ebp + arg_event_code]            # 0046c612
    cmp edx, 0x27e7                              # 0046c616
    je.d8 L_group_20_off                             # 0046c61c
    # block 0x0046c61e: if arg_event_code != 0x27e9 go to L_return (jne, any other code does nothing), else fall into L_group_20_off
    movsx eax, word ptr [ebp + arg_event_code]            # 0046c61e
    cmp eax, 0x27e9                              # 0046c622
    jne.d8 L_return                            # 0046c627
L_group_20_off:
    # block 0x0046c629: codes 0x27e7 and 0x27e9 (L_group_20_off): [0x5b44f0] = 0x20, [0x5b44f4] = 0, [0x5d162d] = [0x5d0377], [0x5d1631] rebuilt, [0x5d1639] = 1, [0x5c39e5] = sign-extended arg_event_code, this_request_value_b = arg_value_b, this_request_value_a = arg_value_a, this_request_slot = 0xffff
    mov dword ptr [0x5b44f0], 0x20               # 0046c629
    mov dword ptr [0x5b44f4], 0x0                # 0046c633
    mov ecx, dword ptr [0x5d0377]                # 0046c63d
    mov dword ptr [0x5d162d], ecx                # 0046c643
    mov edx, dword ptr [0x5b44f0]                # 0046c649
    shl edx, 0x5                                 # 0046c64f
    mov eax, dword ptr [0x5b44f4]                # 0046c652
    shl eax, 0x4                                 # 0046c657
    lea ecx, [edx + eax + 0x5b160c]              # 0046c65a
    mov dword ptr [0x5d1631], ecx                # 0046c661
    mov dword ptr [0x5d1639], 0x1                # 0046c667
    movsx edx, word ptr [ebp + arg_event_code]            # 0046c671
    mov dword ptr [0x5c39e5], edx                # 0046c675
    mov eax, dword ptr [ebp - local_this]           # 0046c67b
    mov cx, word ptr [ebp + arg_value_b]              # 0046c67e
    mov word ptr [eax + this_request_value_b], cx          # 0046c682
    mov edx, dword ptr [ebp - local_this]           # 0046c689
    mov ax, word ptr [ebp + arg_value_a]               # 0046c68c
    mov word ptr [edx + this_request_value_a], ax          # 0046c690
    mov ecx, dword ptr [ebp - local_this]           # 0046c697
    mov word ptr [ecx + this_request_slot], 0xffff      # 0046c69a
L_return:
    # block 0x0046c6a3: epilogue (L_return): restore the frame and return, callee pops four arguments (ret 0x10)
    {load} mov esp, ebp                          # 0046c6a3
    pop ebp                                      # 0046c6a5
    ret 0x10                                     # 0046c6a6
