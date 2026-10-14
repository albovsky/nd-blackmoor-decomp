# FUN_0044d711
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d711
# extent:       0x0044d711-0x0044d8ad (412 code bytes)
# span:         0x0044d711-0x0044d8ad (code 412, tables 0, padding 0)
# sha256:       06e25bdc66b7fa2b9850cb38dd36d767353318e5256fcb572540d2e961d94d0e
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# name:         AlarmClock::derive_hour_and_minute_band_state
# arguments:    thiscall: ecx=this (spilled to [ebp-4]), no stack arguments, plain ret, no return value, reads the int16 globals 0x585d51 (hour) and 0x585d4f (minute) and writes six fields of this
# locals:       [ebp-4]=saved this (written from ecx, re-read before every field access)
# fields:       this+0x35: int16 hour index (hour 0, 12, 24 give 11, hours 1..11 give hour-1, hours 13..23 give hour-13), this+0x37: int16 minute band (0 for minute 0..15, 1 for 16..30, 2 for 31..45, 3 for 46..59, left unchanged for a minute below 0 or above 59), this+0x39: dword flag, 1 by default and cleared for hour 12 and for hours above 12 other than 24 (am/pm-style flag), this+0x3d: int16 next hour index, this+0x3f: int16 next minute band, this+0x41: dword next flag, globals 0x00585d51: int16 hour (read), 0x00585d4f: int16 minute (read)
# callees:      none
# track-n:      host-adapter: none
# unverified:   The roles are inferred from the arithmetic and from the callers' context: world-init-recovery.md and boot-world-inputs-recovery.md name 0x585d51 as the hour and 0x585d4f as the minute (initial values from the boot inputs), and the only caller found (the Ghidra pseudocode of 0x44da08, not re-verified in disassembly) stores the scene index at this+0x1e and references the string ALARM CLOCK OVERLAYS (read from the owned GAME.EXE), so the class name and the label am/pm-style flag are mine, the real meaning of this+0x39 is not proven. Hours outside 0..24 are not rejected: a negative hour gives a negative index and an hour above 24 gives an index above 11, and a minute outside 0..59 leaves this+0x37 as it was before the call (no initialisation here), all verified in the control flow. When the band is above 0 the next-state block uses signed idiv by 12 on the int16 index plus one, stores the remainder as int16, and flips the next flag when the remainder is 11, the reason for that pairing is not established. The fields at this+0x3d, +0x3f and +0x41 are only written here, their readers were not looked up.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_saved_this, 0x4  # [ebp - 0x4]: this, spilled from ecx

.equ this_hour_index, 0x35  # this+0x35: int16 hour index (0..11 for hours in range, 11 for hours 0, 12 and 24)
.equ this_minute_band, 0x37  # this+0x37: int16 minute band 0..3 derived from the minute at 0x585d4f
.equ this_am_flag, 0x39  # this+0x39: dword, set to 1 on entry, cleared for hour 12 and for hours above 12 other than 24
.equ this_next_hour_index, 0x3d  # this+0x3d: int16, hour index of the following step
.equ this_next_minute_band, 0x3f  # this+0x3f: int16, minute band of the following step
.equ this_next_am_flag, 0x41  # this+0x41: dword, flag of the following step

# --- external targets -----------------------------------------------

.org 0x0044d711 - 0x401000
.globl FUN_0044d711
FUN_0044d711:
    # block 0x0044d711: entry: build the frame, spill this, set this+0x39 = 1, load the int16 hour at 0x585d51 (movsx), if it is 0 jump to L_hour_zero_or_24
    push ebp                                     # 0044d711
    {load} mov ebp, esp                          # 0044d712
    push ecx                                     # 0044d714
    mov dword ptr [ebp - local_saved_this], ecx           # 0044d715
    mov eax, dword ptr [ebp - local_saved_this]           # 0044d718
    mov dword ptr [eax + this_am_flag], 0x1          # 0044d71b
    movsx ecx, word ptr [0x585d51]               # 0044d722
    test ecx, ecx                                # 0044d729
    je.d8 L_hour_zero_or_24                             # 0044d72b
    # block 0x0044d72d: hour is non-zero: compare it with 0x18 and jump to L_hour_check_12 when it differs (hour 24 falls into L_hour_zero_or_24)
    movsx edx, word ptr [0x585d51]               # 0044d72d
    cmp edx, 0x18                                # 0044d734
    jne.d8 L_hour_check_12                            # 0044d737
L_hour_zero_or_24:
    # block 0x0044d739: hour 0 or 24: this+0x35 = 0xb (flag stays 1), jump to L_minute_start
    mov eax, dword ptr [ebp - local_saved_this]           # 0044d739
    mov word ptr [eax + this_hour_index], 0xb           # 0044d73c
    jmp.d8 L_minute_start                            # 0044d742
L_hour_check_12:
    # block 0x0044d744: compare the hour with 0xc and jump to L_hour_check_below_12 when it differs
    movsx ecx, word ptr [0x585d51]               # 0044d744
    cmp ecx, 0xc                                 # 0044d74b
    jne.d8 L_hour_check_below_12                            # 0044d74e
    # block 0x0044d750: hour 12: this+0x35 = 0xb and this+0x39 = 0, jump to L_minute_start
    mov edx, dword ptr [ebp - local_saved_this]           # 0044d750
    mov word ptr [edx + this_hour_index], 0xb           # 0044d753
    mov eax, dword ptr [ebp - local_saved_this]           # 0044d759
    mov dword ptr [eax + this_am_flag], 0x0          # 0044d75c
    jmp.d8 L_minute_start                            # 0044d763
L_hour_check_below_12:
    # block 0x0044d765: signed compare of the hour with 0xc, hour >= 12 jumps to L_hour_check_above_12
    movsx ecx, word ptr [0x585d51]               # 0044d765
    cmp ecx, 0xc                                 # 0044d76c
    jge.d8 L_hour_check_above_12                            # 0044d76f
    # block 0x0044d771: hour below 12 and not 0: this+0x35 = hour - 1 (low word), jump to L_minute_start
    movsx edx, word ptr [0x585d51]               # 0044d771
    sub edx, 0x1                                 # 0044d778
    mov eax, dword ptr [ebp - local_saved_this]           # 0044d77b
    mov word ptr [eax + this_hour_index], dx            # 0044d77e
    jmp.d8 L_minute_start                            # 0044d782
L_hour_check_above_12:
    # block 0x0044d784: signed compare of the hour with 0xc again, hour <= 12 jumps to L_minute_start (unreachable for the values that got here, kept as the bytes are)
    movsx ecx, word ptr [0x585d51]               # 0044d784
    cmp ecx, 0xc                                 # 0044d78b
    jle.d8 L_minute_start                            # 0044d78e
    # block 0x0044d790: hour above 12 (and not 24): this+0x35 = hour - 0xd (low word), this+0x39 = 0, then fall into L_minute_start
    movsx edx, word ptr [0x585d51]               # 0044d790
    sub edx, 0xd                                 # 0044d797
    mov eax, dword ptr [ebp - local_saved_this]           # 0044d79a
    mov word ptr [eax + this_hour_index], dx            # 0044d79d
    mov ecx, dword ptr [ebp - local_saved_this]           # 0044d7a1
    mov dword ptr [ecx + this_am_flag], 0x0          # 0044d7a4
L_minute_start:
    # block 0x0044d7ab: load the int16 minute at 0x585d4f, a negative minute jumps to L_minute_not_band_0_high
    movsx edx, word ptr [0x585d4f]               # 0044d7ab
    test edx, edx                                # 0044d7b2
    jl.d8 L_minute_not_band_0_high                             # 0044d7b4
    # block 0x0044d7b6: minute >= 0: a minute above 0xf (signed) jumps to L_minute_not_band_0_high
    movsx eax, word ptr [0x585d4f]               # 0044d7b6
    cmp eax, 0xf                                 # 0044d7bd
    jg.d8 L_minute_not_band_0_high                             # 0044d7c0
    # block 0x0044d7c2: minute 0..15: this+0x37 = 0, jump to L_minutes_done
    mov ecx, dword ptr [ebp - local_saved_this]           # 0044d7c2
    mov word ptr [ecx + this_minute_band], 0x0           # 0044d7c5
    jmp.d8 L_minutes_done                            # 0044d7cb
L_minute_not_band_0_high:
    # block 0x0044d7cd: minute is negative or above 15: compare with 0x10 and jump to L_minute_not_band_1 when below (a negative minute)
    movsx edx, word ptr [0x585d4f]               # 0044d7cd
    cmp edx, 0x10                                # 0044d7d4
    jl.d8 L_minute_not_band_1                             # 0044d7d7
    # block 0x0044d7d9: minute >= 16: a minute above 0x1e jumps to L_minute_not_band_1
    movsx eax, word ptr [0x585d4f]               # 0044d7d9
    cmp eax, 0x1e                                # 0044d7e0
    jg.d8 L_minute_not_band_1                             # 0044d7e3
    # block 0x0044d7e5: minute 16..30: this+0x37 = 1, jump to L_minutes_done
    mov ecx, dword ptr [ebp - local_saved_this]           # 0044d7e5
    mov word ptr [ecx + this_minute_band], 0x1           # 0044d7e8
    jmp.d8 L_minutes_done                            # 0044d7ee
L_minute_not_band_1:
    # block 0x0044d7f0: compare the minute with 0x1f and jump to L_minute_not_band_2 when below
    movsx edx, word ptr [0x585d4f]               # 0044d7f0
    cmp edx, 0x1f                                # 0044d7f7
    jl.d8 L_minute_not_band_2                             # 0044d7fa
    # block 0x0044d7fc: minute >= 31: a minute above 0x2d jumps to L_minute_not_band_2
    movsx eax, word ptr [0x585d4f]               # 0044d7fc
    cmp eax, 0x2d                                # 0044d803
    jg.d8 L_minute_not_band_2                             # 0044d806
    # block 0x0044d808: minute 31..45: this+0x37 = 2, jump to L_minutes_done
    mov ecx, dword ptr [ebp - local_saved_this]           # 0044d808
    mov word ptr [ecx + this_minute_band], 0x2           # 0044d80b
    jmp.d8 L_minutes_done                            # 0044d811
L_minute_not_band_2:
    # block 0x0044d813: compare the minute with 0x2e and jump to L_minutes_done when below (this+0x37 unchanged for a negative minute)
    movsx edx, word ptr [0x585d4f]               # 0044d813
    cmp edx, 0x2e                                # 0044d81a
    jl.d8 L_minutes_done                             # 0044d81d
    # block 0x0044d81f: minute >= 46: a minute above 0x3b jumps to L_minutes_done (this+0x37 unchanged)
    movsx eax, word ptr [0x585d4f]               # 0044d81f
    cmp eax, 0x3b                                # 0044d826
    jg.d8 L_minutes_done                             # 0044d829
    # block 0x0044d82b: minute 46..59: this+0x37 = 3, then fall into L_minutes_done
    mov ecx, dword ptr [ebp - local_saved_this]           # 0044d82b
    mov word ptr [ecx + this_minute_band], 0x3           # 0044d82e
L_minutes_done:
    # block 0x0044d834: this+0x41 = this+0x39 (copy of the flag), then test the signed int16 this+0x37 and jump to L_band_not_positive when it is <= 0
    mov edx, dword ptr [ebp - local_saved_this]           # 0044d834
    mov eax, dword ptr [ebp - local_saved_this]           # 0044d837
    mov ecx, dword ptr [eax + this_am_flag]          # 0044d83a
    mov dword ptr [edx + this_next_am_flag], ecx          # 0044d83d
    mov edx, dword ptr [ebp - local_saved_this]           # 0044d840
    movsx eax, word ptr [edx + this_minute_band]         # 0044d843
    test eax, eax                                # 0044d847
    jle.d8 L_band_not_positive                            # 0044d849
    # block 0x0044d84b: band above 0: this+0x3f = 0, this+0x3d = (int16 this+0x35 + 1) mod 12 (signed idiv by 0xc, remainder stored as int16), compare this+0x3d with 0xb and jump to L_next_state_done when different
    mov ecx, dword ptr [ebp - local_saved_this]           # 0044d84b
    mov word ptr [ecx + this_next_minute_band], 0x0           # 0044d84e
    mov edx, dword ptr [ebp - local_saved_this]           # 0044d854
    movsx eax, word ptr [edx + this_hour_index]         # 0044d857
    add eax, 0x1                                 # 0044d85b
    cdq                                          # 0044d85e
    mov ecx, 0xc                                 # 0044d85f
    idiv ecx                                     # 0044d864
    mov eax, dword ptr [ebp - local_saved_this]           # 0044d866
    mov word ptr [eax + this_next_hour_index], dx            # 0044d869
    mov ecx, dword ptr [ebp - local_saved_this]           # 0044d86d
    movsx edx, word ptr [ecx + this_next_hour_index]         # 0044d870
    cmp edx, 0xb                                 # 0044d874
    jne.d8 L_next_state_done                            # 0044d877
    # block 0x0044d879: next hour index is 11: this+0x41 = 1 if this+0x39 is 0, else 0 (the flag is inverted)
    mov eax, dword ptr [ebp - local_saved_this]           # 0044d879
    {load} xor ecx, ecx                          # 0044d87c
    cmp dword ptr [eax + this_am_flag], 0x0          # 0044d87e
    sete cl                                      # 0044d882
    mov edx, dword ptr [ebp - local_saved_this]           # 0044d885
    mov dword ptr [edx + this_next_am_flag], ecx          # 0044d888
L_next_state_done:
    # block 0x0044d88b: jump over the band-zero block to L_epilogue
    jmp.d8 L_epilogue                            # 0044d88b
L_band_not_positive:
    # block 0x0044d88d: band is 0 or negative: this+0x3f = this+0x37 and this+0x3d = this+0x35 (the next state repeats the current one), then fall into L_epilogue
    mov eax, dword ptr [ebp - local_saved_this]           # 0044d88d
    mov ecx, dword ptr [ebp - local_saved_this]           # 0044d890
    mov dx, word ptr [ecx + this_minute_band]            # 0044d893
    mov word ptr [eax + this_next_minute_band], dx            # 0044d897
    mov eax, dword ptr [ebp - local_saved_this]           # 0044d89b
    mov ecx, dword ptr [ebp - local_saved_this]           # 0044d89e
    mov dx, word ptr [ecx + this_hour_index]            # 0044d8a1
    mov word ptr [eax + this_next_hour_index], dx            # 0044d8a5
L_epilogue:
    # block 0x0044d8a9: epilogue: restore the frame and return with a plain ret
    {load} mov esp, ebp                          # 0044d8a9
    pop ebp                                      # 0044d8ab
    ret                                          # 0044d8ac
