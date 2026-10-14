# FUN_004faa03
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004faa03
# extent:       0x004faa03-0x004fad50 (845 code bytes)
# span:         0x004faa03-0x004fad50 (code 845, tables 0, padding 0)
# sha256:       491e2d51e5c4cdd959f82393271b57b982ad2c983fb73b8084345cdc2c4c02bf
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# name:         CSound::InitSoundSystem
# arguments:    thiscall: ecx=this (CSound object); [ebp+8]=arg_ds_init_param, forwarded unchanged as the first argument of CDirectSound init FUN_004f2710 (it stores it at CDirectSound+0x3ba per pseudocode); callee pops 4 (ret 4); eax at return is not a defined result
# locals:       [ebp-4]=local_channel_index (dword loop counter, reused for the three category list loops); [ebp-8]=local_this (CSound this saved from ecx)
# fields:       per channel ch (0..31) at this+ch*0x5bb: +0x04 dword channel index; +0x08 byte first byte of file-name buffer; +0x10c word category (3 default, then 0/1/2 from the 3 word lists); +0x132 word volume_update_state; zeroed dwords +0x12c,+0x156,+0x15a,+0x15e,+0x166,+0x172,+0x176,+0x28b,+0x28f,+0x293,+0x297,+0x29b,+0x29f; channel 16 only: +0x130 word=1, +0x134 dword=0, +0x16a dword=1 (absolute this+0x5ce0,0x5ce4,0x5d1a), category word this+0x5cbc=3, this+0x5e3f dword=0; globals: word 0x0063a4cd debug-log flag, 0x0063888b log text buffer, 0x005cf1eb CDirectSound object (field +0x1a0 read via FUN_004f709c), word tables 0x005604dc/0x005604e4/0x005604f4 (-1 terminated channel lists for categories 0/1/2), string 0x00560570 'silence'
# callees:      FUN_004f709c = reads CDirectSound+0x1a0 (nonzero means already initialized); FUN_0044a2b7 = log-line writer; FUN_004f2710 = CDirectSound init (arg, table pointer this+4); FUN_004fa2a8 = CDirectSound error code to text; FUN_0050ca3e = sprintf-style formatter; FUN_004fc62d = CSound::LoadSound; FUN_004fb2e3 = CSound::PlaySound
# track-n:      outputs/blackmoor-decomp/src/sound_control.c:sound_control_initialize_categories
# unverified:   Track N sound_control_initialize_categories covers ONLY the default category 3 and the three category lists (checked against the word tables in the original); the per-slot field zeroing, the CDirectSound init call, the early return when CDirectSound+0x1a0 is nonzero and the channel-16 'silence' setup have no Track N counterpart; the meaning of arg_ds_init_param (pseudocode: stored at CDirectSound+0x3ba) and of FUN_004f2710/FUN_004fc62d/FUN_004fb2e3 bodies is taken from pseudocode only; the role of channel 16 (flags word 1, control 0, stream_state 1, name 'silence') is not established beyond the stores themselves; stream_state (this+ch*0x5bb+0x16a) is not cleared by the slot loop; on init failure all channels keep category 3 and no cleanup is done; FUN_004f709c polarity (nonzero skips init) follows its one-line body only; field symbols (csnd_ch_*) are CSound-relative (this+ch*0x5bb+off); their equivalence with CDirectSound slot offsets (CSound off = slot off + 4) rests on the S04-1 alias CDirectSound+0x3ce = CSound+4 and offset arithmetic only; the csnd_ch_unk_*_zeroed fields and csnd_ch16_unk_28f have no established role; csnd_ch_gate_dsslot_* names carry the CDirectSound slot offset of the same field
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_channel_index, 0x4  # [ebp - 0x4]
.equ local_this, 0x8  # [ebp - 0x8]
.equ arg_ds_init_param, 0x8  # [ebp + 0x8]

.equ csnd_ch_index, 0x4  # CSound+ch*0x5bb+0x4: channel index dword (= CDirectSound slot+0x0)
.equ csnd_ch_name_buf, 0x8  # CSound+ch*0x5bb+0x8: file-name text buffer (= CDirectSound slot+0x4)
.equ csnd_ch_category, 0x10c  # CSound+ch*0x5bb+0x10c: category word (= slot+0x108)
.equ csnd_ch_unk_12c_zeroed, 0x12c  # CSound+ch*0x5bb+0x12c: dword zeroed at init, role not established (= slot+0x128)
.equ csnd_ch_volume_update_state, 0x132  # CSound+ch*0x5bb+0x132: volume_update_state word (= slot+0x12e)
.equ csnd_ch_unk_156_zeroed, 0x156  # CSound+ch*0x5bb+0x156: dword zeroed at init, role not established (= slot+0x152)
.equ csnd_ch_unk_15a_zeroed, 0x15a  # CSound+ch*0x5bb+0x15a: dword zeroed at init, role not established (= slot+0x156)
.equ csnd_ch_unk_15e_zeroed, 0x15e  # CSound+ch*0x5bb+0x15e: dword zeroed at init, role not established (= slot+0x15a)
.equ csnd_ch_resource_ready, 0x166  # CSound+ch*0x5bb+0x166: resource_ready dword (= slot+0x162)
.equ csnd_ch_gate_dsslot_16e, 0x172  # CSound+ch*0x5bb+0x172: early-out gate dword (= slot+0x16e)
.equ csnd_ch_gate_dsslot_172, 0x176  # CSound+ch*0x5bb+0x176: early-out gate dword (= slot+0x172)
.equ csnd_ch_gate_dsslot_287, 0x28b  # CSound+ch*0x5bb+0x28b: early-out gate dword (= slot+0x287)
.equ csnd_ch_unk_28f_zeroed, 0x28f  # CSound+ch*0x5bb+0x28f: dword zeroed at init, role not established (= slot+0x28b)
.equ csnd_ch_buffer_ptr, 0x293  # CSound+ch*0x5bb+0x293: DirectSound buffer pointer dword (= slot+0x28f)
.equ csnd_ch_unk_297_zeroed, 0x297  # CSound+ch*0x5bb+0x297: dword zeroed at init, role not established (= slot+0x293)
.equ csnd_ch_unk_29b_zeroed, 0x29b  # CSound+ch*0x5bb+0x29b: dword zeroed at init, role not established (= slot+0x297)
.equ csnd_ch_unk_29f_zeroed, 0x29f  # CSound+ch*0x5bb+0x29f: dword zeroed at init, role not established (= slot+0x29b)
.equ csnd_ch16_category, 0x5cbc  # CSound+0x5cbc: channel 16 category word (16*0x5bb+0x10c)
.equ csnd_ch16_flags_word, 0x5ce0  # CSound+0x5ce0: channel 16 flags word (16*0x5bb+0x130, = DS slot+0x12c)
.equ csnd_ch16_raw_control, 0x5ce4  # CSound+0x5ce4: channel 16 raw control dword (16*0x5bb+0x134, = DS slot+0x130)
.equ csnd_ch16_stream_state, 0x5d1a  # CSound+0x5d1a: channel 16 stream_state dword (16*0x5bb+0x16a, = DS slot+0x166)
.equ csnd_ch16_unk_28f, 0x5e3f  # CSound+0x5e3f: channel 16 dword (16*0x5bb+0x28f, = csnd_ch_unk_28f_zeroed)

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f2710, .text + (0x004f2710 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_004fa2a8, .text + (0x004fa2a8 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fc62d, .text + (0x004fc62d - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004faa03 - 0x401000
.globl FUN_004faa03
FUN_004faa03:
    # block 0x004faa03: entry: save CSound this, ecx=0x5cf1eb (CDirectSound), call FUN_004f709c; zero result continues to L_not_initialized
    push ebp                                     # 004faa03
    {load} mov ebp, esp                          # 004faa04
    sub esp, 0x8                                 # 004faa06
    mov dword ptr [ebp - local_this], ecx           # 004faa09
    mov ecx, 0x5cf1eb                            # 004faa0c
    call FUN_004f709c                            # 004faa11
    test eax, eax                                # 004faa16
    je.d8 L_not_initialized                             # 004faa18
    # block 0x004faa1a: CDirectSound+0x1a0 nonzero (already initialized): skip everything, jump to epilogue
    jmp.d32 L_return                           # 004faa1a
L_not_initialized:
    # block 0x004faa1f: if debug-log word [0x63a4cd] is nonzero fall into the begin-log, else skip it
    movsx eax, word ptr [0x63a4cd]               # 004faa1f
    test eax, eax                                # 004faa26
    je.d8 L_init_slots                             # 004faa28
    # block 0x004faa2a: log string 0x56051c 'CSound::InitSoundSystem() begin...' through FUN_0044a2b7
    push 0x56051c                                # 004faa2a
    call FUN_0044a2b7                            # 004faa2f
    add esp, 0x4                                 # 004faa34
L_init_slots:
    # block 0x004faa37: local_channel_index = 0, jump to the loop test
    mov dword ptr [ebp - local_channel_index], 0x0           # 004faa37
    jmp.d8 L_slot_loop_test                            # 004faa3e
L_slot_next:
    # block 0x004faa40: loop step: ++local_channel_index
    mov ecx, dword ptr [ebp - local_channel_index]           # 004faa40
    add ecx, 0x1                                 # 004faa43
    mov dword ptr [ebp - local_channel_index], ecx           # 004faa46
L_slot_loop_test:
    # block 0x004faa49: loop test: signed local_channel_index >= 0x20 leaves the slot-init loop
    cmp dword ptr [ebp - local_channel_index], 0x20          # 004faa49
    jge.d32 L_init_directsound                           # 004faa4d
    # block 0x004faa53: slot init for channel idx at this+idx*0x5bb: +0x132=0 (word), +0x10c=3 (word category), +0x12c=0, +0x28b=0, +0x04=idx, +0x08=0 (byte), +0x293,+0x29f,+0x15a,+0x166,+0x156,+0x172,+0x176,+0x15e,+0x297,+0x29b,+0x28f = 0 (dwords); then jump to loop step
    mov edx, dword ptr [ebp - local_channel_index]           # 004faa53
    imul edx, edx, 0x5bb                         # 004faa56
    mov eax, dword ptr [ebp - local_this]           # 004faa5c
    mov word ptr [eax + edx + csnd_ch_volume_update_state], 0x0        # 004faa5f
    mov ecx, dword ptr [ebp - local_channel_index]           # 004faa69
    imul ecx, ecx, 0x5bb                         # 004faa6c
    mov edx, dword ptr [ebp - local_this]           # 004faa72
    mov word ptr [edx + ecx + csnd_ch_category], 0x3        # 004faa75
    mov eax, dword ptr [ebp - local_channel_index]           # 004faa7f
    imul eax, eax, 0x5bb                         # 004faa82
    mov ecx, dword ptr [ebp - local_this]           # 004faa88
    mov dword ptr [ecx + eax + csnd_ch_unk_12c_zeroed], 0x0       # 004faa8b
    mov edx, dword ptr [ebp - local_channel_index]           # 004faa96
    imul edx, edx, 0x5bb                         # 004faa99
    mov eax, dword ptr [ebp - local_this]           # 004faa9f
    mov dword ptr [eax + edx + csnd_ch_gate_dsslot_287], 0x0       # 004faaa2
    mov ecx, dword ptr [ebp - local_channel_index]           # 004faaad
    imul ecx, ecx, 0x5bb                         # 004faab0
    mov edx, dword ptr [ebp - local_this]           # 004faab6
    mov eax, dword ptr [ebp - local_channel_index]           # 004faab9
    mov dword ptr [edx + ecx + csnd_ch_index], eax         # 004faabc
    mov ecx, dword ptr [ebp - local_channel_index]           # 004faac0
    imul ecx, ecx, 0x5bb                         # 004faac3
    mov edx, dword ptr [ebp - local_this]           # 004faac9
    mov byte ptr [edx + ecx + csnd_ch_name_buf], 0x0          # 004faacc
    mov eax, dword ptr [ebp - local_channel_index]           # 004faad1
    imul eax, eax, 0x5bb                         # 004faad4
    mov ecx, dword ptr [ebp - local_this]           # 004faada
    mov dword ptr [ecx + eax + csnd_ch_buffer_ptr], 0x0       # 004faadd
    mov edx, dword ptr [ebp - local_channel_index]           # 004faae8
    imul edx, edx, 0x5bb                         # 004faaeb
    mov eax, dword ptr [ebp - local_this]           # 004faaf1
    mov dword ptr [eax + edx + csnd_ch_unk_29f_zeroed], 0x0       # 004faaf4
    mov ecx, dword ptr [ebp - local_channel_index]           # 004faaff
    imul ecx, ecx, 0x5bb                         # 004fab02
    mov edx, dword ptr [ebp - local_this]           # 004fab08
    mov dword ptr [edx + ecx + csnd_ch_unk_15a_zeroed], 0x0       # 004fab0b
    mov eax, dword ptr [ebp - local_channel_index]           # 004fab16
    imul eax, eax, 0x5bb                         # 004fab19
    mov ecx, dword ptr [ebp - local_this]           # 004fab1f
    mov dword ptr [ecx + eax + csnd_ch_resource_ready], 0x0       # 004fab22
    mov edx, dword ptr [ebp - local_channel_index]           # 004fab2d
    imul edx, edx, 0x5bb                         # 004fab30
    mov eax, dword ptr [ebp - local_this]           # 004fab36
    mov dword ptr [eax + edx + csnd_ch_unk_156_zeroed], 0x0       # 004fab39
    mov ecx, dword ptr [ebp - local_channel_index]           # 004fab44
    imul ecx, ecx, 0x5bb                         # 004fab47
    mov edx, dword ptr [ebp - local_this]           # 004fab4d
    mov dword ptr [edx + ecx + csnd_ch_gate_dsslot_16e], 0x0       # 004fab50
    mov eax, dword ptr [ebp - local_channel_index]           # 004fab5b
    imul eax, eax, 0x5bb                         # 004fab5e
    mov ecx, dword ptr [ebp - local_this]           # 004fab64
    mov dword ptr [ecx + eax + csnd_ch_gate_dsslot_172], 0x0       # 004fab67
    mov edx, dword ptr [ebp - local_channel_index]           # 004fab72
    imul edx, edx, 0x5bb                         # 004fab75
    mov eax, dword ptr [ebp - local_this]           # 004fab7b
    mov dword ptr [eax + edx + csnd_ch_unk_15e_zeroed], 0x0       # 004fab7e
    mov ecx, dword ptr [ebp - local_channel_index]           # 004fab89
    imul ecx, ecx, 0x5bb                         # 004fab8c
    mov edx, dword ptr [ebp - local_this]           # 004fab92
    mov dword ptr [edx + ecx + csnd_ch_unk_297_zeroed], 0x0       # 004fab95
    mov eax, dword ptr [ebp - local_channel_index]           # 004faba0
    imul eax, eax, 0x5bb                         # 004faba3
    mov ecx, dword ptr [ebp - local_this]           # 004faba9
    mov dword ptr [ecx + eax + csnd_ch_unk_29b_zeroed], 0x0       # 004fabac
    mov edx, dword ptr [ebp - local_channel_index]           # 004fabb7
    imul edx, edx, 0x5bb                         # 004fabba
    mov eax, dword ptr [ebp - local_this]           # 004fabc0
    mov dword ptr [eax + edx + csnd_ch_unk_28f_zeroed], 0x0       # 004fabc3
    jmp.d32 L_slot_next                           # 004fabce
L_init_directsound:
    # block 0x004fabd3: call FUN_004f2710 on CDirectSound 0x5cf1eb with (arg_ds_init_param, this+4); nonzero result continues at L_cat0_start, zero falls through to the failure path
    mov ecx, dword ptr [ebp - local_this]           # 004fabd3
    add ecx, 0x4                                 # 004fabd6
    push ecx                                     # 004fabd9
    mov edx, dword ptr [ebp + arg_ds_init_param]             # 004fabda
    push edx                                     # 004fabdd
    mov ecx, 0x5cf1eb                            # 004fabde
    call FUN_004f2710                            # 004fabe3
    test eax, eax                                # 004fabe8
    jne.d8 L_cat0_start                            # 004fabea
    # block 0x004fabec: init failed: skip logging when debug-log word [0x63a4cd] is zero
    movsx eax, word ptr [0x63a4cd]               # 004fabec
    test eax, eax                                # 004fabf3
    je.d8 L_init_failed_done                             # 004fabf5
    # block 0x004fabf7: init failed and logging on: format 'CSound - DIRECTSOUND::Init() Error return, %s' (0x560540) with FUN_004fa2a8 text into 0x63888b and log it
    mov ecx, 0x5cf1eb                            # 004fabf7
    call FUN_004fa2a8                            # 004fabfc
    push eax                                     # 004fac01
    push 0x560540                                # 004fac02
    push 0x63888b                                # 004fac07
    call FUN_0050ca3e                            # 004fac0c
    add esp, 0xc                                 # 004fac11
    push 0x63888b                                # 004fac14
    call FUN_0044a2b7                            # 004fac19
    add esp, 0x4                                 # 004fac1e
L_init_failed_done:
    # block 0x004fac21: init failed: jump to epilogue (slots stay zeroed with category 3)
    jmp.d32 L_return                           # 004fac21
L_cat0_start:
    # block 0x004fac26: category 0 list: local_channel_index = 0
    mov dword ptr [ebp - local_channel_index], 0x0           # 004fac26
    jmp.d8 L_cat0_test                            # 004fac2d
L_cat0_next:
    # block 0x004fac2f: category 0 list step: ++local_channel_index
    mov ecx, dword ptr [ebp - local_channel_index]           # 004fac2f
    add ecx, 0x1                                 # 004fac32
    mov dword ptr [ebp - local_channel_index], ecx           # 004fac35
L_cat0_test:
    # block 0x004fac38: load signed word table0[idx] (0x5604dc); -1 ends the list and goes to L_cat1_start
    mov edx, dword ptr [ebp - local_channel_index]           # 004fac38
    movsx eax, word ptr [2*edx + 0x5604dc]       # 004fac3b
    cmp eax, -0x1                                # 004fac43
    je.d8 L_cat1_start                             # 004fac46
    # block 0x004fac48: category word (+0x10c) of channel table0[idx] = 0, next entry
    mov ecx, dword ptr [ebp - local_channel_index]           # 004fac48
    movsx edx, word ptr [2*ecx + 0x5604dc]       # 004fac4b
    imul edx, edx, 0x5bb                         # 004fac53
    mov eax, dword ptr [ebp - local_this]           # 004fac59
    mov word ptr [eax + edx + csnd_ch_category], 0x0        # 004fac5c
    jmp.d8 L_cat0_next                            # 004fac66
L_cat1_start:
    # block 0x004fac68: category 1 list: local_channel_index = 0
    mov dword ptr [ebp - local_channel_index], 0x0           # 004fac68
    jmp.d8 L_cat1_test                            # 004fac6f
L_cat1_next:
    # block 0x004fac71: category 1 list step: ++local_channel_index
    mov ecx, dword ptr [ebp - local_channel_index]           # 004fac71
    add ecx, 0x1                                 # 004fac74
    mov dword ptr [ebp - local_channel_index], ecx           # 004fac77
L_cat1_test:
    # block 0x004fac7a: load signed word table1[idx] (0x5604e4); -1 ends the list and goes to L_cat2_start
    mov edx, dword ptr [ebp - local_channel_index]           # 004fac7a
    movsx eax, word ptr [2*edx + 0x5604e4]       # 004fac7d
    cmp eax, -0x1                                # 004fac85
    je.d8 L_cat2_start                             # 004fac88
    # block 0x004fac8a: category word (+0x10c) of channel table1[idx] = 1, next entry
    mov ecx, dword ptr [ebp - local_channel_index]           # 004fac8a
    movsx edx, word ptr [2*ecx + 0x5604e4]       # 004fac8d
    imul edx, edx, 0x5bb                         # 004fac95
    mov eax, dword ptr [ebp - local_this]           # 004fac9b
    mov word ptr [eax + edx + csnd_ch_category], 0x1        # 004fac9e
    jmp.d8 L_cat1_next                            # 004faca8
L_cat2_start:
    # block 0x004facaa: category 2 list: local_channel_index = 0
    mov dword ptr [ebp - local_channel_index], 0x0           # 004facaa
    jmp.d8 L_cat2_test                            # 004facb1
L_cat2_next:
    # block 0x004facb3: category 2 list step: ++local_channel_index
    mov ecx, dword ptr [ebp - local_channel_index]           # 004facb3
    add ecx, 0x1                                 # 004facb6
    mov dword ptr [ebp - local_channel_index], ecx           # 004facb9
L_cat2_test:
    # block 0x004facbc: load signed word table2[idx] (0x5604f4); -1 ends the list and goes to L_setup_silence_channel
    mov edx, dword ptr [ebp - local_channel_index]           # 004facbc
    movsx eax, word ptr [2*edx + 0x5604f4]       # 004facbf
    cmp eax, -0x1                                # 004facc7
    je.d8 L_setup_silence_channel                             # 004facca
    # block 0x004faccc: category word (+0x10c) of channel table2[idx] = 2, next entry
    mov ecx, dword ptr [ebp - local_channel_index]           # 004faccc
    movsx edx, word ptr [2*ecx + 0x5604f4]       # 004faccf
    imul edx, edx, 0x5bb                         # 004facd7
    mov eax, dword ptr [ebp - local_this]           # 004facdd
    mov word ptr [eax + edx + csnd_ch_category], 0x2        # 004face0
    jmp.d8 L_cat2_next                            # 004facea
L_setup_silence_channel:
    # block 0x004facec: channel 16 setup: this+0x5e3f=0, category word this+0x5cbc=3, flags word this+0x5ce0=1, this+0x5d1a=1 (stream_state), control dword this+0x5ce4=0; then FUN_004fc62d(ch 16, 'silence' 0x560570, 0, 0, 1) and FUN_004fb2e3(ch 16)
    mov ecx, dword ptr [ebp - local_this]           # 004facec
    mov dword ptr [ecx + csnd_ch16_unk_28f], 0x0            # 004facef
    mov edx, dword ptr [ebp - local_this]           # 004facf9
    mov word ptr [edx + csnd_ch16_category], 0x3             # 004facfc
    mov eax, dword ptr [ebp - local_this]           # 004fad05
    mov word ptr [eax + csnd_ch16_flags_word], 0x1             # 004fad08
    mov ecx, dword ptr [ebp - local_this]           # 004fad11
    mov dword ptr [ecx + csnd_ch16_stream_state], 0x1            # 004fad14
    mov edx, dword ptr [ebp - local_this]           # 004fad1e
    mov dword ptr [edx + csnd_ch16_raw_control], 0x0            # 004fad21
    push 0x1                                     # 004fad2b
    push 0x0                                     # 004fad2d
    push 0x0                                     # 004fad2f
    push 0x560570                                # 004fad31
    push 0x10                                    # 004fad36
    mov ecx, dword ptr [ebp - local_this]           # 004fad38
    call FUN_004fc62d                            # 004fad3b
    push 0x10                                    # 004fad40
    mov ecx, dword ptr [ebp - local_this]           # 004fad42
    call FUN_004fb2e3                            # 004fad45
L_return:
    # block 0x004fad4a: epilogue: restore frame, ret 4
    {load} mov esp, ebp                          # 004fad4a
    pop ebp                                      # 004fad4c
    ret 0x4                                      # 004fad4d
