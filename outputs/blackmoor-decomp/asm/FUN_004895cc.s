# FUN_004895cc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004895cc
# extent:       0x004895cc-0x00489722 (342 code bytes)
# span:         0x004895cc-0x00489722 (code 342, tables 0, padding 0)
# sha256:       717d0de9f08e537cf3833bc5664716f6df3452ed642f638453e4e7567a990410
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# name:         ActionFamily37::construct_static_overlay
# arguments:    thiscall: ecx=this (owner object, saved at [ebp-0xc]); [ebp+8]=out_slot, int32* that receives the allocation address; [ebp+0xc]=cursor, int32* holding the pointer to the 0x45-byte raw record body (advanced by 0x45); [ebp+0x10]=payload_offset, int32* advanced by 0x45; callee pops 0xc (ret 0xc); esi and edi saved and restored; no return value
# locals:       frame 0xc bytes: [ebp-4]=body pointer (*cursor at entry); [ebp-8]=allocation address returned by the allocator; [ebp-0xc]=saved ecx (this)
# fields:       this+0x1c (written with the allocation, same value as *out_slot); this+0x20 (written with this+0x1c, read as the object base afterwards); object bytes 0x000..0xab9 zeroed; object+0x00 (NUL-terminated name copied from body+0x00 including its NUL, length unbounded by the bytes); object+0x23 (word from body+0x21); object+0x27 (word from body+0x23); object+0xac..0xbb (four dwords from body+0x35..0x44); body+0x25 (passed to FUN_0048945b as the rect pointer); globals 0x005bb57b (dword scene number, error text only), 0x005c39e3 (int16 action record number, error text only), 0x0063888b (message buffer), 0x0063a4cd (int16 debug flag), 0x00583979 and 0x005cf659 (objects passed in ecx on the failure path)
# callees:      FUN_0051dc43 = allocator (cdecl, size 0xaba, returns pointer or null, caller pops 4); FUN_0050ca3e = sprintf-style formatter (cdecl, caller pops 0x10); FUN_0042639d = fatal-error text helper called as (title text 0x54e090, buffer 0x63888b) with ecx=0x583979, no caller cleanup after the call; FUN_004c97b4 = shutdown/quit helper called with ecx=0x5cf659 (its bytes call PostQuitMessage through the IAT and return, so it does not stop execution); FUN_0048945b = default initializer, called with (obj = *(this+0x1c), the allocation pointer, rect = body+0x25); FUN_0044a2b7 = debug log line writer (cdecl)
# track-n:      outputs/blackmoor-decomp/src/action_family_37.c:action_family_37_construct
# unverified:   after an allocation failure the original calls the error helpers and the shutdown helper and then falls through into the zeroing store with a null destination instead of returning (verified in the control flow, unsafe original behaviour; Track N has no counterpart and models only success); the name copy is a strlen-based copy with no 33-byte limit, so a name without NUL in its first 33 bytes overruns object+0x00..0x20 into the later fields (Track N rejects this as ERR_NAME); the roles of 0x42639d, 0x4c97b4 and 0x44a2b7 come from pseudocode only; the 0x5c39e3 word and 0x5bb57b dword are named only from their use in the failure text; the meaning of the copied option words and geometry dwords is unidentified; the allocator may in principle invoke a new-handler (pseudocode) so the failure return is not exercised; texts at 0x54e064, 0x54e090 and 0x54e0ac were read from the owned GAME.EXE bytes; the body_* and obj_* names only record source or destination layout, meanings of the option words and geometry dwords are unidentified; this_alloc_ptr (this+0x1c) and this_object_ptr (this+0x20) hold the same value, named after the order they are written
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_body, 0x4  # [ebp - 0x4]
.equ local_alloc, 0x8  # [ebp - 0x8]
.equ local_saved_this, 0xc  # [ebp - 0xc]
.equ arg_out_slot, 0x8  # [ebp + 0x8]
.equ arg_cursor, 0xc  # [ebp + 0xc]
.equ arg_payload_offset, 0x10  # [ebp + 0x10]

.equ body_geom_dword1, 0x4  # raw record body+0x35 geometry block, +0x4: second dword (source)
.equ body_geom_dword2, 0x8  # raw record body+0x35 geometry block, +0x8: third dword (source)
.equ body_geom_dword3, 0xc  # raw record body+0x35 geometry block, +0xc: fourth dword (source)
.equ obj_geom_dword1, 0x4  # action object+0xac geometry block, +0x4: second dword (destination)
.equ obj_geom_dword2, 0x8  # action object+0xac geometry block, +0x8: third dword (destination)
.equ obj_geom_dword3, 0xc  # action object+0xac geometry block, +0xc: fourth dword (destination)
.equ this_alloc_ptr, 0x1c  # owner object this+0x1c: allocation address (same value as *out_slot)
.equ this_object_ptr, 0x20  # owner object this+0x20: action object base (copied from this+0x1c)
.equ body_option21, 0x21  # raw record body+0x21: option word (copied to object+0x23)
.equ obj_option21, 0x23  # action object+0x23: option word from body+0x21
.equ body_option23, 0x23  # raw record body+0x23: option word (copied to object+0x27)
.equ obj_option23, 0x27  # action object+0x27: option word from body+0x23

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0048945b, .text + (0x0048945b - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004895cc - 0x401000
.globl FUN_004895cc
FUN_004895cc:
    # block 0x004895cc: prologue; save esi, edi, this; alloc = allocator(0xaba); *out_slot = alloc; if alloc is non-null go to the allocation-ok case
    push ebp                                     # 004895cc
    {load} mov ebp, esp                          # 004895cd
    sub esp, 0xc                                 # 004895cf
    push esi                                     # 004895d2
    push edi                                     # 004895d3
    mov dword ptr [ebp - local_saved_this], ecx           # 004895d4
    push 0xaba                                   # 004895d7
    call FUN_0051dc43                            # 004895dc
    add esp, 0x4                                 # 004895e1
    mov dword ptr [ebp - local_alloc], eax           # 004895e4
    mov eax, dword ptr [ebp + arg_out_slot]             # 004895e7
    mov ecx, dword ptr [ebp - local_alloc]           # 004895ea
    mov dword ptr [eax], ecx                     # 004895ed
    cmp dword ptr [ebp - local_alloc], 0x0           # 004895ef
    jne.d8 L_alloc_ok                            # 004895f3
    # block 0x004895f5: allocation failed: sprintf(0x63888b, 0x54e064, scene (dword 0x5bb57b), record (int16 0x5c39e3)); call error helper 0x42639d(0x54e090, 0x63888b) with ecx=0x583979; call 0x4c97b4 with ecx=0x5cf659; then fall through with alloc null
    movsx edx, word ptr [0x5c39e3]               # 004895f5
    push edx                                     # 004895fc
    mov eax, dword ptr [0x5bb57b]                # 004895fd
    push eax                                     # 00489602
    push 0x54e064                                # 00489603
    push 0x63888b                                # 00489608
    call FUN_0050ca3e                            # 0048960d
    add esp, 0x10                                # 00489612
    push 0x63888b                                # 00489615
    push 0x54e090                                # 0048961a
    mov ecx, 0x583979                            # 0048961f
    call FUN_0042639d                            # 00489624
    mov ecx, 0x5cf659                            # 00489629
    call FUN_004c97b4                            # 0048962e
L_alloc_ok:
    # block 0x00489633: zero 0xaba bytes at *out_slot (0x2ae dwords plus one word); *(this+0x1c) = *out_slot; *(this+0x20) = *(this+0x1c); body = *cursor; call 0x48945b(this, *(this+0x1c), body+0x25); copy the NUL-terminated name from body to this+0x20 including the NUL; object+0x23 = body word +0x21; object+0x27 = body word +0x23; copy body+0x35..0x44 (four dwords) to object+0xac; *cursor += 0x45; *payload_offset += 0x45; if the debug flag word 0x63a4cd is nonzero log 0x54e0ac
    mov ecx, 0x2ae                               # 00489633
    {load} xor eax, eax                          # 00489638
    mov edx, dword ptr [ebp + arg_out_slot]             # 0048963a
    mov edi, dword ptr [edx]                     # 0048963d
    rep stosd dword ptr es:[edi], eax            # 0048963f
    stosw word ptr es:[edi], ax                  # 00489641
    mov eax, dword ptr [ebp - local_saved_this]           # 00489643
    mov ecx, dword ptr [ebp + arg_out_slot]             # 00489646
    mov edx, dword ptr [ecx]                     # 00489649
    mov dword ptr [eax + this_alloc_ptr], edx              # 0048964b
    mov eax, dword ptr [ebp - local_saved_this]           # 0048964e
    mov ecx, dword ptr [ebp - local_saved_this]           # 00489651
    mov edx, dword ptr [ecx + this_alloc_ptr]              # 00489654
    mov dword ptr [eax + this_object_ptr], edx              # 00489657
    mov eax, dword ptr [ebp + arg_cursor]             # 0048965a
    mov ecx, dword ptr [eax]                     # 0048965d
    mov dword ptr [ebp - local_body], ecx           # 0048965f
    mov edx, dword ptr [ebp - local_body]           # 00489662
    add edx, 0x25                                # 00489665
    push edx                                     # 00489668
    mov eax, dword ptr [ebp - local_saved_this]           # 00489669
    mov ecx, dword ptr [eax + this_alloc_ptr]              # 0048966c
    push ecx                                     # 0048966f
    mov ecx, dword ptr [ebp - local_saved_this]           # 00489670
    call FUN_0048945b                            # 00489673
    mov edi, dword ptr [ebp - local_body]           # 00489678
    mov edx, dword ptr [ebp - local_saved_this]           # 0048967b
    mov edx, dword ptr [edx + this_object_ptr]              # 0048967e
    or ecx, -0x1                                 # 00489681
    {load} xor eax, eax                          # 00489684
    repne scasb al, byte ptr es:[edi]            # 00489686
    not ecx                                      # 00489688
    {load} sub edi, ecx                          # 0048968a
    {load} mov esi, edi                          # 0048968c
    {load} mov eax, ecx                          # 0048968e
    {load} mov edi, edx                          # 00489690
    shr ecx, 0x2                                 # 00489692
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00489695
    {load} mov ecx, eax                          # 00489697
    and ecx, 0x3                                 # 00489699
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048969c
    mov ecx, dword ptr [ebp - local_saved_this]           # 0048969e
    mov edx, dword ptr [ecx + this_object_ptr]              # 004896a1
    mov eax, dword ptr [ebp - local_body]           # 004896a4
    mov cx, word ptr [eax + body_option21]                # 004896a7
    mov word ptr [edx + obj_option21], cx                # 004896ab
    mov edx, dword ptr [ebp - local_saved_this]           # 004896af
    mov eax, dword ptr [edx + this_object_ptr]              # 004896b2
    mov ecx, dword ptr [ebp - local_body]           # 004896b5
    mov dx, word ptr [ecx + body_option23]                # 004896b8
    mov word ptr [eax + obj_option23], dx                # 004896bc
    mov eax, dword ptr [ebp - local_body]           # 004896c0
    add eax, 0x35                                # 004896c3
    mov ecx, dword ptr [ebp - local_saved_this]           # 004896c6
    mov edx, dword ptr [ecx + this_alloc_ptr]              # 004896c9
    add edx, 0xac                                # 004896cc
    mov ecx, dword ptr [eax]                     # 004896d2
    mov dword ptr [edx], ecx                     # 004896d4
    mov ecx, dword ptr [eax + body_geom_dword1]               # 004896d6
    mov dword ptr [edx + obj_geom_dword1], ecx               # 004896d9
    mov ecx, dword ptr [eax + body_geom_dword2]               # 004896dc
    mov dword ptr [edx + obj_geom_dword2], ecx               # 004896df
    mov eax, dword ptr [eax + body_geom_dword3]               # 004896e2
    mov dword ptr [edx + obj_geom_dword3], eax               # 004896e5
    mov ecx, dword ptr [ebp + arg_cursor]             # 004896e8
    mov edx, dword ptr [ecx]                     # 004896eb
    add edx, 0x45                                # 004896ed
    mov eax, dword ptr [ebp + arg_cursor]             # 004896f0
    mov dword ptr [eax], edx                     # 004896f3
    mov ecx, dword ptr [ebp + arg_payload_offset]            # 004896f5
    mov edx, dword ptr [ecx]                     # 004896f8
    add edx, 0x45                                # 004896fa
    mov eax, dword ptr [ebp + arg_payload_offset]            # 004896fd
    mov dword ptr [eax], edx                     # 00489700
    movsx ecx, word ptr [0x63a4cd]               # 00489702
    test ecx, ecx                                # 00489709
    je.d8 L_epilogue                             # 0048970b
    # block 0x0048970d: debug flag set: call 0x44a2b7(0x54e0ac), caller removes its 4-byte argument
    push 0x54e0ac                                # 0048970d
    call FUN_0044a2b7                            # 00489712
    add esp, 0x4                                 # 00489717
L_epilogue:
    # block 0x0048971a: restore esi/edi, return popping 0xc
    pop edi                                      # 0048971a
    pop esi                                      # 0048971b
    {load} mov esp, ebp                          # 0048971c
    pop ebp                                      # 0048971e
    ret 0xc                                      # 0048971f
