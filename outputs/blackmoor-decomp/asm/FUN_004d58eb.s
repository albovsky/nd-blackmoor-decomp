# FUN_004d58eb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d58eb
# extent:       0x004d58eb-0x004d5b54 (617 code bytes)
# span:         0x004d58eb-0x004d5b54 (code 617, tables 0, padding 0)
# sha256:       32df088195b5985d5eb2b11d5ce63da1130ed31bd6e0d11ae792f16576446784
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# name:         StateObject_52e454::reset_all_fields
# arguments:    thiscall: ecx=this (an object whose first dword is the vtable pointer 0x52e454 stored by its constructor 0x4d58b0); no stack arguments; plain ret; no result
# locals:       frame 4 bytes plus saved edi: [ebp-0x4] = this, spilled from ecx; edi is used as the rep stosd destination
# fields:       this+0x004, +0x445, +0x449, +0x44d, +0x455, +0x459, +0x45d, +0x461, +0x94d2, +0x950e, +0x9512, +0x951a, +0x951e, +0x9532 (stored twice), +0x9536, +0x953a, +0x9546, +0x954a, +0x9556, +0x955a: dword = 0; this+0x94d6, +0x94da, +0x94de, +0x950a: dword = 0 (slots that sibling 0x4d5b54 passes to the release helper 0x4c2dfb when non-zero); this+0x955e and +0x9562: dword = 0xffffffff; this+0x956e[5]: five dwords = 0; this+0x94e2[10]: ten dwords = 0 (release-helper slots in 0x4d5b54); this+0x9582[10]: ten dwords = 0; this+0x95aa + i*0x21 (i<10): first byte of ten 33-byte records = 0; this+0x98a8: loop counter, left at 10 on return; block clears by rep stosd: 0x28 dwords at this+0x9754, 0x2417 dwords at this+0x476 (ends exactly at +0x94d2), 0x29 dwords at this+0x9804 (ends exactly at +0x98a8); global 0x005d2ecb: dword = 0
# callees:      none
# track-n:      host-adapter: none
# unverified:   The class name StateObject_52e454 and the name reset_all_fields are my labels (the only identity evidence is the vtable pointer value 0x52e454 that the constructor 0x4d58b0 stores before calling this, and that 0x4d5b54 calls it again after releasing the owned slots); what the object represents is not established. The symbols obj_cleared_NNNN, obj_minus1_NNNN, obj_array and obj_records state only the verified displacement and the value written here, not the field meaning; the names owned_ptr_NNNN and handle_array10_NNNN are labels whose ownership reading is inferred from sibling 0x4d5b54, as described next. That the four slots at +0x94d6/+0x94da/+0x94de/+0x950a and the array at +0x94e2 hold owned object handles comes from sibling 0x4d5b54 (it tests each against 0 and passes its address to 0x4c2dfb with ecx=0x5cf659, which per its bytes releases the pointed-to object and stores 0 back; Track N documents 0x4c2dfb as freeing a font sheet through the graphics wrapper object 0x5cf659 (src/caption_layout.h:152 release_font_sheet, tests/caption_layout_original_oracle.py:74 and :254 labelled free sheet, tests/action_family28_frame_oracle.py:32 SURFACE_WRAPPER = 0x5CF659)), not from this routine, which only clears them (it does not release, so calling it on a live object leaks). The arrays at +0x956e, +0x9582 and the 0x21-byte records at +0x95aa are only cleared here (first byte of each record); their element meaning and the global 0x5d2ecb are not established. +0x9532 is stored twice (dword = 0 each time): a redundant store in the original, kept. +0x98a8 is used as the loop counter and keeps the value 10 after the loops; whether it also has a field meaning is not established. The call sites checked are 0x4d58c3 (constructor) and 0x4d5c4b.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]: this, spilled from ecx

.equ obj_cleared_04, 0x4  # this+0x004: dword set to 0 (role not established)
.equ obj_cleared_445, 0x445  # this+0x445: dword set to 0 (unaligned field, role not established)
.equ obj_cleared_449, 0x449  # this+0x449: dword set to 0 (role not established)
.equ obj_cleared_44d, 0x44d  # this+0x44d: dword set to 0 (role not established)
.equ obj_cleared_455, 0x455  # this+0x455: dword set to 0 (role not established)
.equ obj_cleared_459, 0x459  # this+0x459: dword set to 0 (role not established)
.equ obj_cleared_45d, 0x45d  # this+0x45d: dword set to 0 (role not established)
.equ obj_cleared_461, 0x461  # this+0x461: dword set to 0 (role not established)
.equ obj_cleared_94d2, 0x94d2  # this+0x94d2: dword set to 0; the block cleared from this+0x476 ends here
.equ owned_ptr_94d6, 0x94d6  # this+0x94d6: dword set to 0 (a slot released by 0x4d5b54 when non-zero)
.equ owned_ptr_94da, 0x94da  # this+0x94da: dword set to 0 (a slot released by 0x4d5b54 when non-zero)
.equ owned_ptr_94de, 0x94de  # this+0x94de: dword set to 0 (a slot released by 0x4d5b54 when non-zero)
.equ handle_array10_94e2, 0x94e2  # this+0x94e2: array of 10 dwords, each set to 0 (slots released by 0x4d5b54 when non-zero)
.equ owned_ptr_950a, 0x950a  # this+0x950a: dword set to 0 (a slot released by 0x4d5b54 when non-zero)
.equ obj_cleared_950e, 0x950e  # this+0x950e: dword set to 0 (role not established)
.equ obj_cleared_9512, 0x9512  # this+0x9512: dword set to 0 (role not established)
.equ obj_cleared_951a, 0x951a  # this+0x951a: dword set to 0 (role not established)
.equ obj_cleared_951e, 0x951e  # this+0x951e: dword set to 0 (role not established)
.equ obj_cleared_9532, 0x9532  # this+0x9532: dword set to 0, stored twice
.equ obj_cleared_9536, 0x9536  # this+0x9536: dword set to 0 (role not established)
.equ obj_cleared_953a, 0x953a  # this+0x953a: dword set to 0 (role not established)
.equ obj_cleared_9546, 0x9546  # this+0x9546: dword set to 0 (role not established)
.equ obj_cleared_954a, 0x954a  # this+0x954a: dword set to 0 (role not established)
.equ obj_cleared_9556, 0x9556  # this+0x9556: dword set to 0 (role not established)
.equ obj_cleared_955a, 0x955a  # this+0x955a: dword set to 0 (role not established)
.equ obj_minus1_955e, 0x955e  # this+0x955e: dword set to 0xffffffff (role not established)
.equ obj_minus1_9562, 0x9562  # this+0x9562: dword set to 0xffffffff (role not established)
.equ obj_array5_956e, 0x956e  # this+0x956e: array of 5 dwords, each set to 0 (role not established)
.equ obj_array10_9582, 0x9582  # this+0x9582: array of 10 dwords, each set to 0 (role not established)
.equ obj_records10_95aa, 0x95aa  # this+0x95aa: ten 0x21-byte records, first byte of each set to 0 (role not established)
.equ obj_loop_counter_98a8, 0x98a8  # this+0x98a8: dword used as the loop counter of both loops; holds 10 on return

# --- external targets -----------------------------------------------

.org 0x004d58eb - 0x401000
.globl FUN_004d58eb
FUN_004d58eb:
    # block 0x004d58eb: entry: spill this; store 0 to the scalar fields listed in the header (0xffffffff to +0x955e and +0x9562), set the loop counter +0x98a8 to 0, jump to the first loop test
    push ebp                                     # 004d58eb
    {load} mov ebp, esp                          # 004d58ec
    push ecx                                     # 004d58ee
    push edi                                     # 004d58ef
    mov dword ptr [ebp - local_this], ecx           # 004d58f0
    mov eax, dword ptr [ebp - local_this]           # 004d58f3
    mov dword ptr [eax + obj_cleared_04], 0x0           # 004d58f6
    mov ecx, dword ptr [ebp - local_this]           # 004d58fd
    mov dword ptr [ecx + obj_cleared_455], 0x0         # 004d5900
    mov edx, dword ptr [ebp - local_this]           # 004d590a
    mov dword ptr [edx + obj_cleared_461], 0x0         # 004d590d
    mov eax, dword ptr [ebp - local_this]           # 004d5917
    mov dword ptr [eax + obj_minus1_955e], 0xffffffff # 004d591a
    mov ecx, dword ptr [ebp - local_this]           # 004d5924
    mov dword ptr [ecx + obj_minus1_9562], 0xffffffff # 004d5927
    mov edx, dword ptr [ebp - local_this]           # 004d5931
    mov dword ptr [edx + obj_cleared_955a], 0x0        # 004d5934
    mov eax, dword ptr [ebp - local_this]           # 004d593e
    mov dword ptr [eax + obj_cleared_9556], 0x0        # 004d5941
    mov ecx, dword ptr [ebp - local_this]           # 004d594b
    mov dword ptr [ecx + obj_cleared_459], 0x0         # 004d594e
    mov edx, dword ptr [ebp - local_this]           # 004d5958
    mov dword ptr [edx + obj_cleared_45d], 0x0         # 004d595b
    mov eax, dword ptr [ebp - local_this]           # 004d5965
    mov dword ptr [eax + obj_cleared_445], 0x0         # 004d5968
    mov ecx, dword ptr [ebp - local_this]           # 004d5972
    mov dword ptr [ecx + obj_cleared_449], 0x0         # 004d5975
    mov edx, dword ptr [ebp - local_this]           # 004d597f
    mov dword ptr [edx + obj_cleared_44d], 0x0         # 004d5982
    mov eax, dword ptr [ebp - local_this]           # 004d598c
    mov dword ptr [eax + obj_cleared_94d2], 0x0        # 004d598f
    mov ecx, dword ptr [ebp - local_this]           # 004d5999
    mov dword ptr [ecx + obj_cleared_951a], 0x0        # 004d599c
    mov edx, dword ptr [ebp - local_this]           # 004d59a6
    mov dword ptr [edx + obj_cleared_951e], 0x0        # 004d59a9
    mov eax, dword ptr [ebp - local_this]           # 004d59b3
    mov dword ptr [eax + obj_cleared_9532], 0x0        # 004d59b6
    mov ecx, dword ptr [ebp - local_this]           # 004d59c0
    mov dword ptr [ecx + obj_cleared_9536], 0x0        # 004d59c3
    mov edx, dword ptr [ebp - local_this]           # 004d59cd
    mov dword ptr [edx + obj_cleared_953a], 0x0        # 004d59d0
    mov eax, dword ptr [ebp - local_this]           # 004d59da
    mov dword ptr [eax + obj_cleared_9532], 0x0        # 004d59dd
    mov ecx, dword ptr [ebp - local_this]           # 004d59e7
    mov dword ptr [ecx + owned_ptr_94d6], 0x0        # 004d59ea
    mov edx, dword ptr [ebp - local_this]           # 004d59f4
    mov dword ptr [edx + owned_ptr_94da], 0x0        # 004d59f7
    mov eax, dword ptr [ebp - local_this]           # 004d5a01
    mov dword ptr [eax + owned_ptr_94de], 0x0        # 004d5a04
    mov ecx, dword ptr [ebp - local_this]           # 004d5a0e
    mov dword ptr [ecx + owned_ptr_950a], 0x0        # 004d5a11
    mov edx, dword ptr [ebp - local_this]           # 004d5a1b
    mov dword ptr [edx + obj_cleared_950e], 0x0        # 004d5a1e
    mov eax, dword ptr [ebp - local_this]           # 004d5a28
    mov dword ptr [eax + obj_cleared_9512], 0x0        # 004d5a2b
    mov ecx, dword ptr [ebp - local_this]           # 004d5a35
    mov dword ptr [ecx + obj_cleared_9546], 0x0        # 004d5a38
    mov edx, dword ptr [ebp - local_this]           # 004d5a42
    mov dword ptr [edx + obj_cleared_954a], 0x0        # 004d5a45
    mov eax, dword ptr [ebp - local_this]           # 004d5a4f
    mov dword ptr [eax + obj_loop_counter_98a8], 0x0        # 004d5a52
    jmp.d8 L_array5_test                            # 004d5a5c
L_array5_next:
    # block 0x004d5a5e: first loop increment: obj_loop_counter_98a8 = obj_loop_counter_98a8 + 1
    mov ecx, dword ptr [ebp - local_this]           # 004d5a5e
    mov edx, dword ptr [ecx + obj_loop_counter_98a8]        # 004d5a61
    add edx, 0x1                                 # 004d5a67
    mov eax, dword ptr [ebp - local_this]           # 004d5a6a
    mov dword ptr [eax + obj_loop_counter_98a8], edx        # 004d5a6d
L_array5_test:
    # block 0x004d5a73: first loop test: if obj_loop_counter_98a8 >= 5 (signed) leave the loop
    mov ecx, dword ptr [ebp - local_this]           # 004d5a73
    cmp dword ptr [ecx + obj_loop_counter_98a8], 0x5        # 004d5a76
    jge.d8 L_array10_init                            # 004d5a7d
    # block 0x004d5a7f: first loop body: this+0x956e + 4*counter = 0, then back to the increment
    mov edx, dword ptr [ebp - local_this]           # 004d5a7f
    mov eax, dword ptr [edx + obj_loop_counter_98a8]        # 004d5a82
    mov ecx, dword ptr [ebp - local_this]           # 004d5a88
    mov dword ptr [ecx + 4*eax + obj_array5_956e], 0x0 # 004d5a8b
    jmp.d8 L_array5_next                            # 004d5a96
L_array10_init:
    # block 0x004d5a98: counter = 0 before the second loop
    mov edx, dword ptr [ebp - local_this]           # 004d5a98
    mov dword ptr [edx + obj_loop_counter_98a8], 0x0        # 004d5a9b
    jmp.d8 L_array10_test                            # 004d5aa5
L_array10_next:
    # block 0x004d5aa7: second loop increment: obj_loop_counter_98a8 = obj_loop_counter_98a8 + 1
    mov eax, dword ptr [ebp - local_this]           # 004d5aa7
    mov ecx, dword ptr [eax + obj_loop_counter_98a8]        # 004d5aaa
    add ecx, 0x1                                 # 004d5ab0
    mov edx, dword ptr [ebp - local_this]           # 004d5ab3
    mov dword ptr [edx + obj_loop_counter_98a8], ecx        # 004d5ab6
L_array10_test:
    # block 0x004d5abc: second loop test: if obj_loop_counter_98a8 >= 10 (signed) leave the loop
    mov eax, dword ptr [ebp - local_this]           # 004d5abc
    cmp dword ptr [eax + obj_loop_counter_98a8], 0xa        # 004d5abf
    jge.d8 L_clear_blocks                            # 004d5ac6
    # block 0x004d5ac8: second loop body: dword at +0x94e2 + 4*i = 0; byte at +0x95aa + 0x21*i = 0; dword at +0x9582 + 4*i = 0; back to the increment
    mov ecx, dword ptr [ebp - local_this]           # 004d5ac8
    mov edx, dword ptr [ecx + obj_loop_counter_98a8]        # 004d5acb
    mov eax, dword ptr [ebp - local_this]           # 004d5ad1
    mov dword ptr [eax + 4*edx + handle_array10_94e2], 0x0 # 004d5ad4
    mov ecx, dword ptr [ebp - local_this]           # 004d5adf
    mov edx, dword ptr [ecx + obj_loop_counter_98a8]        # 004d5ae2
    imul edx, edx, 0x21                          # 004d5ae8
    mov eax, dword ptr [ebp - local_this]           # 004d5aeb
    mov byte ptr [eax + edx + obj_records10_95aa], 0x0   # 004d5aee
    mov ecx, dword ptr [ebp - local_this]           # 004d5af6
    mov edx, dword ptr [ecx + obj_loop_counter_98a8]        # 004d5af9
    mov eax, dword ptr [ebp - local_this]           # 004d5aff
    mov dword ptr [eax + 4*edx + obj_array10_9582], 0x0 # 004d5b02
    jmp.d8 L_array10_next                            # 004d5b0d
L_clear_blocks:
    # block 0x004d5b0f: zero blocks with rep stosd: 0x28 dwords at this+0x9754, global 0x5d2ecb = 0, 0x2417 dwords at this+0x476, 0x29 dwords at this+0x9804; restore edi and the frame, plain ret
    mov ecx, 0x28                                # 004d5b0f
    {load} xor eax, eax                          # 004d5b14
    mov edi, dword ptr [ebp - local_this]           # 004d5b16
    add edi, 0x9754                              # 004d5b19
    rep stosd dword ptr es:[edi], eax            # 004d5b1f
    mov dword ptr [0x5d2ecb], 0x0                # 004d5b21
    mov ecx, 0x2417                              # 004d5b2b
    {load} xor eax, eax                          # 004d5b30
    mov edi, dword ptr [ebp - local_this]           # 004d5b32
    add edi, 0x476                               # 004d5b35
    rep stosd dword ptr es:[edi], eax            # 004d5b3b
    mov ecx, 0x29                                # 004d5b3d
    {load} xor eax, eax                          # 004d5b42
    mov edi, dword ptr [ebp - local_this]           # 004d5b44
    add edi, 0x9804                              # 004d5b47
    rep stosd dword ptr es:[edi], eax            # 004d5b4d
    pop edi                                      # 004d5b4f
    {load} mov esp, ebp                          # 004d5b50
    pop ebp                                      # 004d5b52
    ret                                          # 004d5b53
