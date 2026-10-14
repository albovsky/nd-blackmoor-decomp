# FUN_004f684a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f684a
# extent:       0x004f684a-0x004f6a7e (564 code bytes)
# span:         0x004f684a-0x004f6a7e (code 564, tables 0, padding 0)
# sha256:       ec0a5c5d12137f671987aea9599e247b21fbc05d82f194c3af9ded151225a56e
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# name:         CDirectSound::Volume
# arguments:    thiscall: ecx=this (CDirectSound); [ebp+8]=arg_channel (dword; scaled by 0x5bb, no range check); callee pops 4 (ret 4); returns eax=1 when the buffer SetVolume call returns 0, otherwise this+0x3be (0)
# locals:       [ebp-4]=local_slot (slot pointer); [ebp-8]=local_this; [ebp-0xc]=local_first_nonpositive (first attenuation limited to <= 0, as int); [ebp-0x10]=local_second_nonpositive; [ebp-0x18]=local_first_as_double (qword, high half at [ebp-0x14]); [ebp-0x20]=local_first_floor_lo and [ebp-0x1c]=local_first_floor_hi (qword: the first value or the constant -2857.142857142857); [ebp-0x28]=local_second_as_double (qword, high half at [ebp-0x24]); [ebp-0x30]=local_second_floor_lo and [ebp-0x2c]=local_second_floor_hi (qword for the second value)
# fields:       this+0x3c2 dword device_error (0x3e8 at entry; 0x3ea, 0x3ef or 0x408 on failure); this+0x3ca dword host result := 0 then the buffer call result; this+0x3be dword device_state (0 on failure, returned); this+0x3ce slot-table pointer; slot=[this+0x3ce]+channel*0x5bb: +0x28f dword buffer pointer; +0x13c dword first_attenuation (clamped to <= 0, floored at -2857.142857142857, converted with __ftol, written back); +0x140 dword second_attenuation (same processing, written back, not passed to any call here); +0x04 file-name text (log argument); globals: double 0x0052e4d8 = -2857.142857142857, word 0x0063a4cd debug-log flag, 0x0063888b log text buffer, format 0x0055e8fc 'CDirectSound::Volume() - volume set to %d on channel %d, %s'
# callees:      FUN_004f709c = reads CDirectSound+0x1a0 (device ready gate); FUN_0050ce04 = CRT __ftol; indirect call [vtable+0x3c] of the interface at slot+0x28f with (buffer, first_attenuation) = IDirectSoundBuffer::SetVolume per S04-1 hook list; FUN_0050ca3e = sprintf-style formatter; FUN_0044a2b7 = log-line writer
# track-n:      outputs/blackmoor-decomp/src/sound_control.c:apply_volume
# unverified:   that vtable offset 0x3c is IDirectSoundBuffer::SetVolume is taken from the S04-1 hook list and the standard DirectSound vtable layout, not verified against a DirectSound import here; only the first attenuation (slot+0x13c) reaches SetVolume, the second (slot+0x140) is clamped and stored but this function does not consume it, and its consumer and any pan meaning are not established (S04-4 open); the buffer-call result is stored raw at this+0x3ca and any nonzero value is treated as failure (error 0x408); the first guard (device not ready, error 0x3ea) uses FUN_004f709c whose polarity follows its one-line body only; the channel argument has no bounds check (Track N rejects channel >= 32); the clamp path through double compare and __ftol is read from the instructions (x87 status bits C0/C3 via test ah,0x41) and assumes FUN_0050ce04 truncates toward zero as the CRT does
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_slot, 0x4  # [ebp - 0x4]
.equ local_this, 0x8  # [ebp - 0x8]
.equ local_first_nonpositive, 0xc  # [ebp - 0xc]
.equ local_second_nonpositive, 0x10  # [ebp - 0x10]
.equ local_first_as_double, 0x18  # [ebp - 0x18]
.equ local_first_floor_hi, 0x1c  # [ebp - 0x1c]
.equ local_first_floor_lo, 0x20  # [ebp - 0x20]
.equ local_second_as_double, 0x28  # [ebp - 0x28]
.equ local_second_floor_hi, 0x2c  # [ebp - 0x2c]
.equ local_second_floor_lo, 0x30  # [ebp - 0x30]
.equ arg_channel, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004f684a - 0x401000
.globl FUN_004f684a
FUN_004f684a:
    # block 0x004f684a: entry: save this, this+0x3c2=0x3e8, this+0x3ca=0, local_slot=[this+0x3ce]+channel*0x5bb, call FUN_004f709c; nonzero goes to L_device_ready
    push ebp                                     # 004f684a
    {load} mov ebp, esp                          # 004f684b
    sub esp, 0x30                                # 004f684d
    mov dword ptr [ebp - local_this], ecx           # 004f6850
    mov eax, dword ptr [ebp - local_this]           # 004f6853
    mov dword ptr [eax + 0x3c2], 0x3e8           # 004f6856
    mov ecx, dword ptr [ebp - local_this]           # 004f6860
    mov dword ptr [ecx + 0x3ca], 0x0             # 004f6863
    mov edx, dword ptr [ebp + arg_channel]             # 004f686d
    imul edx, edx, 0x5bb                         # 004f6870
    mov eax, dword ptr [ebp - local_this]           # 004f6876
    mov ecx, dword ptr [eax + 0x3ce]             # 004f6879
    {load} add ecx, edx                          # 004f687f
    mov dword ptr [ebp - local_slot], ecx           # 004f6881
    mov ecx, dword ptr [ebp - local_this]           # 004f6884
    call FUN_004f709c                            # 004f6887
    test eax, eax                                # 004f688c
    jne.d8 L_device_ready                            # 004f688e
    # block 0x004f6890: device not ready: error 0x3ea, device_state=0, return this+0x3be (0)
    mov edx, dword ptr [ebp - local_this]           # 004f6890
    mov dword ptr [edx + 0x3c2], 0x3ea           # 004f6893
    mov eax, dword ptr [ebp - local_this]           # 004f689d
    mov dword ptr [eax + 0x3be], 0x0             # 004f68a0
    mov ecx, dword ptr [ebp - local_this]           # 004f68aa
    mov eax, dword ptr [ecx + 0x3be]             # 004f68ad
    jmp.d32 L_return                           # 004f68b3
L_device_ready:
    # block 0x004f68b8: slot+0x28f (buffer pointer) nonzero goes to L_buffer_present
    mov edx, dword ptr [ebp - local_slot]           # 004f68b8
    cmp dword ptr [edx + 0x28f], 0x0             # 004f68bb
    jne.d8 L_buffer_present                            # 004f68c2
    # block 0x004f68c4: no buffer: error 0x3ef, device_state=0, return this+0x3be (0)
    mov eax, dword ptr [ebp - local_this]           # 004f68c4
    mov dword ptr [eax + 0x3c2], 0x3ef           # 004f68c7
    mov ecx, dword ptr [ebp - local_this]           # 004f68d1
    mov dword ptr [ecx + 0x3be], 0x0             # 004f68d4
    mov edx, dword ptr [ebp - local_this]           # 004f68de
    mov eax, dword ptr [edx + 0x3be]             # 004f68e1
    jmp.d32 L_return                           # 004f68e7
L_buffer_present:
    # block 0x004f68ec: first attenuation slot+0x13c: signed compare with 0, >= 0 goes to L_first_clamp_zero
    mov eax, dword ptr [ebp - local_slot]           # 004f68ec
    cmp dword ptr [eax + 0x13c], 0x0             # 004f68ef
    jge.d8 L_first_clamp_zero                            # 004f68f6
    # block 0x004f68f8: first attenuation is negative: local_first_nonpositive = slot+0x13c
    mov ecx, dword ptr [ebp - local_slot]           # 004f68f8
    mov edx, dword ptr [ecx + 0x13c]             # 004f68fb
    mov dword ptr [ebp - local_first_nonpositive], edx           # 004f6901
    jmp.d8 L_first_clamp_done                            # 004f6904
L_first_clamp_zero:
    # block 0x004f6906: first attenuation >= 0: local_first_nonpositive = 0
    mov dword ptr [ebp - local_first_nonpositive], 0x0           # 004f6906
L_first_clamp_done:
    # block 0x004f690d: slot+0x13c = local_first_nonpositive; second attenuation slot+0x140: signed compare with 0, >= 0 goes to L_second_clamp_zero
    mov eax, dword ptr [ebp - local_slot]           # 004f690d
    mov ecx, dword ptr [ebp - local_first_nonpositive]           # 004f6910
    mov dword ptr [eax + 0x13c], ecx             # 004f6913
    mov edx, dword ptr [ebp - local_slot]           # 004f6919
    cmp dword ptr [edx + 0x140], 0x0             # 004f691c
    jge.d8 L_second_clamp_zero                            # 004f6923
    # block 0x004f6925: second attenuation is negative: local_second_nonpositive = slot+0x140
    mov eax, dword ptr [ebp - local_slot]           # 004f6925
    mov ecx, dword ptr [eax + 0x140]             # 004f6928
    mov dword ptr [ebp - local_second_nonpositive], ecx          # 004f692e
    jmp.d8 L_second_clamp_done                            # 004f6931
L_second_clamp_zero:
    # block 0x004f6933: second attenuation >= 0: local_second_nonpositive = 0
    mov dword ptr [ebp - local_second_nonpositive], 0x0          # 004f6933
L_second_clamp_done:
    # block 0x004f693a: slot+0x140 = local_second_nonpositive; load slot+0x13c as double and compare with double -2857.142857142857 (0x52e4d8); value <= constant (C3|C0 set) goes to L_first_use_floor_const
    mov edx, dword ptr [ebp - local_slot]           # 004f693a
    mov eax, dword ptr [ebp - local_second_nonpositive]          # 004f693d
    mov dword ptr [edx + 0x140], eax             # 004f6940
    mov ecx, dword ptr [ebp - local_slot]           # 004f6946
    fild dword ptr [ecx + 0x13c]                 # 004f6949
    fstp qword ptr [ebp - local_first_as_double]              # 004f694f
    fld qword ptr [ebp - local_first_as_double]               # 004f6952
    fcomp qword ptr [0x52e4d8]                   # 004f6955
    fnstsw ax                                    # 004f695b
    test ah, 0x41                                # 004f695d
    jne.d8 L_first_use_floor_const                            # 004f6960
    # block 0x004f6962: first value is above the constant: local_first_floor = (double)slot+0x13c, jump to L_first_ftol
    mov edx, dword ptr [ebp - local_slot]           # 004f6962
    fild dword ptr [edx + 0x13c]                 # 004f6965
    fstp qword ptr [ebp - local_first_floor_lo]              # 004f696b
    jmp.d8 L_first_ftol                            # 004f696e
L_first_use_floor_const:
    # block 0x004f6970: first value <= constant: local_first_floor = bit pattern 0xc0a6524924924924 (-2857.142857142857)
    mov dword ptr [ebp - local_first_floor_lo], 0x24924924   # 004f6970
    mov dword ptr [ebp - local_first_floor_hi], 0xc0a65249   # 004f6977
L_first_ftol:
    # block 0x004f697e: slot+0x13c = __ftol(local_first_floor); load slot+0x140 as double and compare with the same constant; <= goes to L_second_use_floor_const
    fld qword ptr [ebp - local_first_floor_lo]               # 004f697e
    call FUN_0050ce04                            # 004f6981
    mov ecx, dword ptr [ebp - local_slot]           # 004f6986
    mov dword ptr [ecx + 0x13c], eax             # 004f6989
    mov edx, dword ptr [ebp - local_slot]           # 004f698f
    fild dword ptr [edx + 0x140]                 # 004f6992
    fstp qword ptr [ebp - local_second_as_double]              # 004f6998
    fld qword ptr [ebp - local_second_as_double]               # 004f699b
    fcomp qword ptr [0x52e4d8]                   # 004f699e
    fnstsw ax                                    # 004f69a4
    test ah, 0x41                                # 004f69a6
    jne.d8 L_second_use_floor_const                            # 004f69a9
    # block 0x004f69ab: second value is above the constant: local_second_floor = (double)slot+0x140, jump to L_second_ftol
    mov eax, dword ptr [ebp - local_slot]           # 004f69ab
    fild dword ptr [eax + 0x140]                 # 004f69ae
    fstp qword ptr [ebp - local_second_floor_lo]              # 004f69b4
    jmp.d8 L_second_ftol                            # 004f69b7
L_second_use_floor_const:
    # block 0x004f69b9: second value <= constant: local_second_floor = bit pattern 0xc0a6524924924924
    mov dword ptr [ebp - local_second_floor_lo], 0x24924924   # 004f69b9
    mov dword ptr [ebp - local_second_floor_hi], 0xc0a65249   # 004f69c0
L_second_ftol:
    # block 0x004f69c7: slot+0x140 = __ftol(local_second_floor); call buffer vtable +0x3c (SetVolume) with (buffer slot+0x28f, slot+0x13c) and store eax at this+0x3ca; nonzero result goes to L_set_volume_failed
    fld qword ptr [ebp - local_second_floor_lo]               # 004f69c7
    call FUN_0050ce04                            # 004f69ca
    mov ecx, dword ptr [ebp - local_slot]           # 004f69cf
    mov dword ptr [ecx + 0x140], eax             # 004f69d2
    mov edx, dword ptr [ebp - local_slot]           # 004f69d8
    mov eax, dword ptr [edx + 0x13c]             # 004f69db
    push eax                                     # 004f69e1
    mov ecx, dword ptr [ebp - local_slot]           # 004f69e2
    mov edx, dword ptr [ecx + 0x28f]             # 004f69e5
    mov eax, dword ptr [ebp - local_slot]           # 004f69eb
    mov ecx, dword ptr [eax + 0x28f]             # 004f69ee
    mov eax, dword ptr [ecx]                     # 004f69f4
    push edx                                     # 004f69f6
    call dword ptr [eax + 0x3c]                  # 004f69f7
    mov ecx, dword ptr [ebp - local_this]           # 004f69fa
    mov dword ptr [ecx + 0x3ca], eax             # 004f69fd
    mov edx, dword ptr [ebp - local_this]           # 004f6a03
    cmp dword ptr [edx + 0x3ca], 0x0             # 004f6a06
    jne.d8 L_set_volume_failed                            # 004f6a0d
    # block 0x004f6a0f: SetVolume returned 0: skip the log when debug-log word [0x63a4cd] is zero
    movsx eax, word ptr [0x63a4cd]               # 004f6a0f
    test eax, eax                                # 004f6a16
    je.d8 L_set_volume_ok                             # 004f6a18
    # block 0x004f6a1a: log 'CDirectSound::Volume() - volume set to %d on channel %d, %s' (0x55e8fc) with slot+0x13c, channel and slot+4 text via FUN_0050ca3e, then FUN_0044a2b7
    mov ecx, dword ptr [ebp - local_slot]           # 004f6a1a
    add ecx, 0x4                                 # 004f6a1d
    push ecx                                     # 004f6a20
    mov edx, dword ptr [ebp + arg_channel]             # 004f6a21
    push edx                                     # 004f6a24
    mov eax, dword ptr [ebp - local_slot]           # 004f6a25
    mov ecx, dword ptr [eax + 0x13c]             # 004f6a28
    push ecx                                     # 004f6a2e
    push 0x55e8fc                                # 004f6a2f
    push 0x63888b                                # 004f6a34
    call FUN_0050ca3e                            # 004f6a39
    add esp, 0x14                                # 004f6a3e
    push 0x63888b                                # 004f6a41
    call FUN_0044a2b7                            # 004f6a46
    add esp, 0x4                                 # 004f6a4b
L_set_volume_ok:
    # block 0x004f6a4e: success: eax = 1, jump to epilogue
    mov eax, 0x1                                 # 004f6a4e
    jmp.d8 L_return                            # 004f6a53
L_set_volume_failed:
    # block 0x004f6a55: SetVolume failed: error 0x408, device_state=0, return this+0x3be (0)
    mov edx, dword ptr [ebp - local_this]           # 004f6a55
    mov dword ptr [edx + 0x3c2], 0x408           # 004f6a58
    mov eax, dword ptr [ebp - local_this]           # 004f6a62
    mov dword ptr [eax + 0x3be], 0x0             # 004f6a65
    mov ecx, dword ptr [ebp - local_this]           # 004f6a6f
    mov eax, dword ptr [ecx + 0x3be]             # 004f6a72
L_return:
    # block 0x004f6a78: epilogue: restore frame, ret 4
    {load} mov esp, ebp                          # 004f6a78
    pop ebp                                      # 004f6a7a
    ret 0x4                                      # 004f6a7b
