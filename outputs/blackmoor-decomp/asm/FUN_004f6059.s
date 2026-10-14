# FUN_004f6059
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f6059
# extent:       0x004f6059-0x004f61e7 (398 code bytes)
# span:         0x004f6059-0x004f61e7 (code 398, tables 0, padding 0)
# sha256:       f4096a7793dfdd7cfb28a8603c92c3a7a83836ecc1e3367b42c6b63ad52f106f
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# name:         CDirectSound::Play
# arguments:    thiscall: ecx=this (CDirectSound); [ebp+8]=arg_channel (dword; scaled by 0x5bb, no range check); callee pops 4 (ret 4); returns eax = this+0x3be (1 on success, 0 on failure paths)
# locals:       [ebp-4]=local_slot (slot pointer = [this+0x3ce] + channel*0x5bb); [ebp-8]=local_play_flags (0 or 1, passed to FUN_004f80d3); [ebp-0xc]=local_this
# fields:       this+0x3c2 dword device_error (0x3e8 at entry; 0x3ea, 0x3ef or 0x403 on failure); this+0x3be dword device_state (1 at entry, 0 on every failure, returned); this+0x3ce slot-table pointer; slot: +0x162 dword resource_ready, +0x28f dword buffer pointer, +0x130 dword raw control, +0x12c word flags (bit 0x01 and bit 0x100 read), +0x166 dword stream_state, +0x287 dword cleared to 0 before Play, +0x04 file-name text (log argument); globals: word 0x0063a4cd debug-log flag, 0x0063888b log text buffer, 0x0055e78c format 'CDirectSound::Play() - Playing channel %d, %s'
# callees:      FUN_004f709c = reads CDirectSound+0x1a0 (device ready gate); FUN_004f80d3 = Play wrapper (ecx=this, push buffer pointer slot+0x28f, push play flags; pseudocode: stores HRESULT at this+0x3ca, retries after a buffer-lost result, returns nonzero when the final HRESULT is 0); FUN_0050ca3e = sprintf-style formatter; FUN_0044a2b7 = log-line writer
# track-n:      outputs/blackmoor-decomp/src/sound_control.c:sound_control_play
# unverified:   the body of FUN_004f80d3 (DirectSound Play call through vtable +0x30, HRESULT store at this+0x3ca, buffer-lost restore-and-retry) is pseudocode only and is a host boundary in Track N, so 'nonzero return = success' and the 0x403 mapping rest on the pseudocode; the meaning of play flag 1 as DirectSound looping and of flag bits 0x01/0x100 and stream_state is inferred from Track N/S04-1 and not independently established; the channel argument is a full dword with no bounds check (Track N rejects channel >= 32); the success-path debug log format arguments (channel, slot+4 text) are read from the pushes only; this+0x3ca is not written by this function itself so Track N's explicit host_result := 0 before the call is a modelling choice; the order of the pushes to FUN_004f80d3 (flags first, buffer second) is taken from the instructions but the callee's parameter names are pseudocode
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_slot, 0x4  # [ebp - 0x4]
.equ local_play_flags, 0x8  # [ebp - 0x8]
.equ local_this, 0xc  # [ebp - 0xc]
.equ arg_channel, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_004f80d3, .text + (0x004f80d3 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f6059 - 0x401000
.globl FUN_004f6059
FUN_004f6059:
    # block 0x004f6059: entry: save this, this+0x3c2=0x3e8, local_slot=[this+0x3ce]+channel*0x5bb, local_play_flags=0, this+0x3be=1, call FUN_004f709c; nonzero goes to L_device_ready
    push ebp                                     # 004f6059
    {load} mov ebp, esp                          # 004f605a
    sub esp, 0xc                                 # 004f605c
    mov dword ptr [ebp - local_this], ecx           # 004f605f
    mov eax, dword ptr [ebp - local_this]           # 004f6062
    mov dword ptr [eax + 0x3c2], 0x3e8           # 004f6065
    mov ecx, dword ptr [ebp + arg_channel]             # 004f606f
    imul ecx, ecx, 0x5bb                         # 004f6072
    mov edx, dword ptr [ebp - local_this]           # 004f6078
    mov eax, dword ptr [edx + 0x3ce]             # 004f607b
    {load} add eax, ecx                          # 004f6081
    mov dword ptr [ebp - local_slot], eax           # 004f6083
    mov dword ptr [ebp - local_play_flags], 0x0           # 004f6086
    mov ecx, dword ptr [ebp - local_this]           # 004f608d
    mov dword ptr [ecx + 0x3be], 0x1             # 004f6090
    mov ecx, dword ptr [ebp - local_this]           # 004f609a
    call FUN_004f709c                            # 004f609d
    test eax, eax                                # 004f60a2
    jne.d8 L_device_ready                            # 004f60a4
    # block 0x004f60a6: device not ready: error 0x3ea, device_state=0, return this+0x3be (0)
    mov edx, dword ptr [ebp - local_this]           # 004f60a6
    mov dword ptr [edx + 0x3c2], 0x3ea           # 004f60a9
    mov eax, dword ptr [ebp - local_this]           # 004f60b3
    mov dword ptr [eax + 0x3be], 0x0             # 004f60b6
    mov ecx, dword ptr [ebp - local_this]           # 004f60c0
    mov eax, dword ptr [ecx + 0x3be]             # 004f60c3
    jmp.d32 L_return                           # 004f60c9
L_device_ready:
    # block 0x004f60ce: channel gate: slot+0x162 (resource_ready) zero goes to L_err_channel_not_loaded
    mov edx, dword ptr [ebp - local_slot]           # 004f60ce
    cmp dword ptr [edx + 0x162], 0x0             # 004f60d1
    je.d8 L_err_channel_not_loaded                             # 004f60d8
    # block 0x004f60da: channel gate: slot+0x28f (buffer pointer) nonzero goes to L_select_play_flags, zero falls to the error
    mov eax, dword ptr [ebp - local_slot]           # 004f60da
    cmp dword ptr [eax + 0x28f], 0x0             # 004f60dd
    jne.d8 L_select_play_flags                            # 004f60e4
L_err_channel_not_loaded:
    # block 0x004f60e6: channel not loaded: error 0x3ef, device_state=0, return this+0x3be (0)
    mov ecx, dword ptr [ebp - local_this]           # 004f60e6
    mov dword ptr [ecx + 0x3c2], 0x3ef           # 004f60e9
    mov edx, dword ptr [ebp - local_this]           # 004f60f3
    mov dword ptr [edx + 0x3be], 0x0             # 004f60f6
    mov eax, dword ptr [ebp - local_this]           # 004f6100
    mov eax, dword ptr [eax + 0x3be]             # 004f6103
    jmp.d32 L_return                           # 004f6109
L_select_play_flags:
    # block 0x004f610e: if slot+0x130 (raw control) != 0 go to L_check_stream_state
    mov ecx, dword ptr [ebp - local_slot]           # 004f610e
    cmp dword ptr [ecx + 0x130], 0x0             # 004f6111
    jne.d8 L_check_stream_state                            # 004f6118
    # block 0x004f611a: raw control == 0: (word slot+0x12c & 1) != 0 goes to L_set_play_flag_1
    mov edx, dword ptr [ebp - local_slot]           # 004f611a
    {load} xor eax, eax                          # 004f611d
    mov ax, word ptr [edx + 0x12c]               # 004f611f
    and eax, 0x1                                 # 004f6126
    test eax, eax                                # 004f6129
    jne.d8 L_set_play_flag_1                            # 004f612b
L_check_stream_state:
    # block 0x004f612d: slot+0x166 (stream_state) != 0 goes to L_set_play_flag_1
    mov ecx, dword ptr [ebp - local_slot]           # 004f612d
    cmp dword ptr [ecx + 0x166], 0x0             # 004f6130
    jne.d8 L_set_play_flag_1                            # 004f6137
    # block 0x004f6139: (word slot+0x12c & 0x100) == 0 goes to L_clear_gate_and_play, otherwise falls to L_set_play_flag_1
    mov edx, dword ptr [ebp - local_slot]           # 004f6139
    {load} xor eax, eax                          # 004f613c
    mov ax, word ptr [edx + 0x12c]               # 004f613e
    and eax, 0x100                               # 004f6145
    test eax, eax                                # 004f614a
    je.d8 L_clear_gate_and_play                             # 004f614c
L_set_play_flag_1:
    # block 0x004f614e: local_play_flags |= 1
    mov ecx, dword ptr [ebp - local_play_flags]           # 004f614e
    or ecx, 0x1                                  # 004f6151
    mov dword ptr [ebp - local_play_flags], ecx           # 004f6154
L_clear_gate_and_play:
    # block 0x004f6157: slot+0x287=0, call FUN_004f80d3(slot+0x28f, local_play_flags) with ecx=this; zero result falls to the failure
    mov edx, dword ptr [ebp - local_slot]           # 004f6157
    mov dword ptr [edx + 0x287], 0x0             # 004f615a
    mov eax, dword ptr [ebp - local_play_flags]           # 004f6164
    push eax                                     # 004f6167
    mov ecx, dword ptr [ebp - local_slot]           # 004f6168
    mov edx, dword ptr [ecx + 0x28f]             # 004f616b
    push edx                                     # 004f6171
    mov ecx, dword ptr [ebp - local_this]           # 004f6172
    call FUN_004f80d3                            # 004f6175
    test eax, eax                                # 004f617a
    jne.d8 L_play_ok                            # 004f617c
    # block 0x004f617e: Play failed: error 0x403, device_state=0, return this+0x3be (0)
    mov eax, dword ptr [ebp - local_this]           # 004f617e
    mov dword ptr [eax + 0x3c2], 0x403           # 004f6181
    mov ecx, dword ptr [ebp - local_this]           # 004f618b
    mov dword ptr [ecx + 0x3be], 0x0             # 004f618e
    mov edx, dword ptr [ebp - local_this]           # 004f6198
    mov eax, dword ptr [edx + 0x3be]             # 004f619b
    jmp.d8 L_return                            # 004f61a1
L_play_ok:
    # block 0x004f61a3: Play succeeded: skip the log when debug-log word [0x63a4cd] is zero
    movsx eax, word ptr [0x63a4cd]               # 004f61a3
    test eax, eax                                # 004f61aa
    je.d8 L_return_state                             # 004f61ac
    # block 0x004f61ae: log 'CDirectSound::Play() - Playing channel %d, %s' (0x55e78c) with channel and slot+4 text into 0x63888b via FUN_0050ca3e, then FUN_0044a2b7
    mov ecx, dword ptr [ebp - local_slot]           # 004f61ae
    add ecx, 0x4                                 # 004f61b1
    push ecx                                     # 004f61b4
    mov edx, dword ptr [ebp + arg_channel]             # 004f61b5
    push edx                                     # 004f61b8
    push 0x55e78c                                # 004f61b9
    push 0x63888b                                # 004f61be
    call FUN_0050ca3e                            # 004f61c3
    add esp, 0x10                                # 004f61c8
    push 0x63888b                                # 004f61cb
    call FUN_0044a2b7                            # 004f61d0
    add esp, 0x4                                 # 004f61d5
L_return_state:
    # block 0x004f61d8: return this+0x3be (device_state, 1)
    mov eax, dword ptr [ebp - local_this]           # 004f61d8
    mov eax, dword ptr [eax + 0x3be]             # 004f61db
L_return:
    # block 0x004f61e1: epilogue: restore frame, ret 4
    {load} mov esp, ebp                          # 004f61e1
    pop ebp                                      # 004f61e3
    ret 0x4                                      # 004f61e4
