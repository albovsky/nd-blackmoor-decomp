# FUN_004f55d5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f55d5
# extent:       0x004f55d5-0x004f572b (342 code bytes)
# span:         0x004f55d5-0x004f572b (code 342, tables 0, padding 0)
# sha256:       a23c29361019147dba61cee42d23f4b37bdc30ff70f03e579aff3b2244cad70f
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# name:         CDirectSound::UpdateChannel
# arguments:    thiscall: ecx=this (CDirectSound); [ebp+8]=arg_channel (dword; scaled by 0x5bb, no range check); callee pops 4 (ret 4); no defined return value
# locals:       [ebp-4]=local_unused_slot_plus_18a (slot+0x18a, stored and never read); [ebp-8]=local_tick (tick count read at entry); [ebp-0xc]=local_slot (slot pointer = [this+0x3ce] + channel*0x5bb); [ebp-0x10]=local_repeat_range (repeat_max - repeat_min); [ebp-0x14]=local_this
# fields:       this+0x3c2 dword device_error := 0x3e8; this+0x3ce dword slot-table pointer (CSound+4 per Track N alias); slot=[this+0x3ce]+channel*0x5bb: +0x287,+0x16e,+0x172,+0x166 dword early-out gates (+0x166 is stream_state); +0x12c word flags (0x20 stage chain, 0x10 random-repeat); +0x130 dword raw control; +0x19e dword repeat_marker := 1; +0x1aa repeat_min, +0x1ae repeat_max (signed); +0x1a2 dword repeat_delay (written); +0x1a6 dword repeat_due_tick := tick + delay (written); slot+0x2a3 address passed to FUN_004f9040; IAT dword at 0x0052a23c called with no arguments
# callees:      [0x0052a23c] = KERNEL32 GetTickCount (IAT entry resolved from the import table); FUN_004f9f92 = flag-0x20 stage 1 (ecx=this, push channel); FUN_004f8f94 = stage 2 (ecx=this, push channel); FUN_004f9040 = stage 3 (ecx=this, push channel and slot+0x2a3 pointer); FUN_0050cd50 = CRT rand (the MSVC linear congruential generator: *0x343fd + 0x269ec3, >> 16 & 0x7fff); FUN_004f6059 = CDirectSound::Play
# track-n:      outputs/blackmoor-decomp/src/sound_control.c:sound_control_update
# unverified:   the name CDirectSound::UpdateChannel is a project label: no original symbol or trace string exists for this function, and the class is inferred from the this+0x3c2/+0x3ce layout shared with CDirectSound::Play; the bodies of FUN_004f9f92/FUN_004f8f94/FUN_004f9040 are not examined here: Track N calls them fade stages but their pseudocode looks like per-channel 3D-parameter setters, so the 'fade' meaning of flag 0x20 is unproven; the bytes pass a second argument (pointer slot+0x2a3) to the third stage which Track N's SoundControlHost fade_stage_3 (channel only) does not model; GetTickCount identity of IAT 0x52a23c comes from the oracle hook list, not from this function; the channel argument is a full dword with no bounds check (Track N rejects channel >= 32 and uses 16 bits); local_unused_slot_plus_18a is a dead store; the return value of FUN_004f6059 is discarded; rand is assumed to return a nonnegative value (CRT rand returns 0..0x7fff per its pseudocode) so idiv sign handling is not exercised for negatives; raw-flag combinations other than bits 0x10 and 0x20 and the semantics of gates +0x287/+0x16e/+0x172 are not established
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_unused_slot_plus_18a, 0x4  # [ebp - 0x4]
.equ local_tick, 0x8  # [ebp - 0x8]
.equ local_slot, 0xc  # [ebp - 0xc]
.equ local_repeat_range, 0x10  # [ebp - 0x10]
.equ local_this, 0x14  # [ebp - 0x14]
.equ arg_channel, 0x8  # [ebp + 0x8]

.equ field_12c, 0x12c  # offset
.equ field_130, 0x130  # offset
.equ field_166, 0x166  # offset
.equ field_16e, 0x16e  # offset
.equ field_172, 0x172  # offset
.equ field_19e, 0x19e  # offset
.equ field_1a2, 0x1a2  # offset
.equ field_1a6, 0x1a6  # offset
.equ field_1aa, 0x1aa  # offset
.equ field_1ae, 0x1ae  # offset
.equ field_287, 0x287  # offset
.equ field_3c2, 0x3c2  # offset
.equ field_3ce, 0x3ce  # offset

# --- external targets -----------------------------------------------
.set FUN_004f6059, .text + (0x004f6059 - 0x401000)
.set FUN_004f8f94, .text + (0x004f8f94 - 0x401000)
.set FUN_004f9040, .text + (0x004f9040 - 0x401000)
.set FUN_004f9f92, .text + (0x004f9f92 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004f55d5 - 0x401000
.globl FUN_004f55d5
FUN_004f55d5:
    # block 0x004f55d5: entry: save this, read the tick via [0x52a23c] into local_tick, this+0x3c2=0x3e8, compute local_slot=[this+0x3ce]+channel*0x5bb and the unused slot+0x18a; if slot+0x287 != 0 jump to L_return_gated
    push ebp                                     # 004f55d5
    {load} mov ebp, esp                          # 004f55d6
    sub esp, 0x14                                # 004f55d8
    mov dword ptr [ebp - local_this], ecx          # 004f55db
    call dword ptr [0x52a23c]                    # 004f55de
    mov dword ptr [ebp - local_tick], eax           # 004f55e4
    mov eax, dword ptr [ebp - local_this]          # 004f55e7
    mov dword ptr [eax + field_3c2], 0x3e8           # 004f55ea
    mov ecx, dword ptr [ebp + arg_channel]             # 004f55f4
    imul ecx, ecx, 0x5bb                         # 004f55f7
    mov edx, dword ptr [ebp - local_this]          # 004f55fd
    mov eax, dword ptr [edx + field_3ce]             # 004f5600
    {load} add eax, ecx                          # 004f5606
    mov dword ptr [ebp - local_slot], eax           # 004f5608
    mov ecx, dword ptr [ebp - local_slot]           # 004f560b
    add ecx, 0x18a                               # 004f560e
    mov dword ptr [ebp - local_unused_slot_plus_18a], ecx           # 004f5614
    mov edx, dword ptr [ebp - local_slot]           # 004f5617
    cmp dword ptr [edx + field_287], 0x0             # 004f561a
    jne.d8 L_return_gated                            # 004f5621
    # block 0x004f5623: gate: slot+0x16e != 0 jumps to L_return_gated
    mov eax, dword ptr [ebp - local_slot]           # 004f5623
    cmp dword ptr [eax + field_16e], 0x0             # 004f5626
    jne.d8 L_return_gated                            # 004f562d
    # block 0x004f562f: gate: slot+0x172 != 0 jumps to L_return_gated
    mov ecx, dword ptr [ebp - local_slot]           # 004f562f
    cmp dword ptr [ecx + field_172], 0x0             # 004f5632
    jne.d8 L_return_gated                            # 004f5639
    # block 0x004f563b: gate: slot+0x166 (stream_state) zero continues at L_check_stage_flag, nonzero falls to L_return_gated
    mov edx, dword ptr [ebp - local_slot]           # 004f563b
    cmp dword ptr [edx + field_166], 0x0             # 004f563e
    je.d8 L_check_stage_flag                             # 004f5645
L_return_gated:
    # block 0x004f5647: gated early return: jump to epilogue without touching the channel
    jmp.d32 L_return                           # 004f5647
L_check_stage_flag:
    # block 0x004f564c: test (word slot+0x12c & 0x20); zero skips the stage chain
    mov eax, dword ptr [ebp - local_slot]           # 004f564c
    {load} xor ecx, ecx                          # 004f564f
    mov cx, word ptr [eax + field_12c]               # 004f5651
    and ecx, 0x20                                # 004f5658
    test ecx, ecx                                # 004f565b
    je.d8 L_check_raw_control                             # 004f565d
    # block 0x004f565f: flag 0x20: call FUN_004f9f92(channel), FUN_004f8f94(channel), FUN_004f9040(channel, slot+0x2a3) in this order
    mov edx, dword ptr [ebp + arg_channel]             # 004f565f
    push edx                                     # 004f5662
    mov ecx, dword ptr [ebp - local_this]          # 004f5663
    call FUN_004f9f92                            # 004f5666
    mov eax, dword ptr [ebp + arg_channel]             # 004f566b
    push eax                                     # 004f566e
    mov ecx, dword ptr [ebp - local_this]          # 004f566f
    call FUN_004f8f94                            # 004f5672
    mov ecx, dword ptr [ebp - local_slot]           # 004f5677
    add ecx, 0x2a3                               # 004f567a
    push ecx                                     # 004f5680
    mov edx, dword ptr [ebp + arg_channel]             # 004f5681
    push edx                                     # 004f5684
    mov ecx, dword ptr [ebp - local_this]          # 004f5685
    call FUN_004f9040                            # 004f5688
L_check_raw_control:
    # block 0x004f568d: if slot+0x130 (raw control) != 0 jump to epilogue (no restart, no repeat)
    mov eax, dword ptr [ebp - local_slot]           # 004f568d
    cmp dword ptr [eax + field_130], 0x0             # 004f5690
    jne.d32 L_return                           # 004f5697
    # block 0x004f569d: raw control == 0: test (word slot+0x12c & 0x10); zero goes to L_restart_play
    mov ecx, dword ptr [ebp - local_slot]           # 004f569d
    {load} xor edx, edx                          # 004f56a0
    mov dx, word ptr [ecx + field_12c]               # 004f56a2
    and edx, 0x10                                # 004f56a9
    test edx, edx                                # 004f56ac
    je.d8 L_restart_play                             # 004f56ae
    # block 0x004f56b0: random-repeat: slot+0x19e=1, local_repeat_range = slot+0x1ae - slot+0x1aa; signed range <= 0 goes to L_range_not_positive
    mov eax, dword ptr [ebp - local_slot]           # 004f56b0
    mov dword ptr [eax + field_19e], 0x1             # 004f56b3
    mov ecx, dword ptr [ebp - local_slot]           # 004f56bd
    mov edx, dword ptr [ebp - local_slot]           # 004f56c0
    mov eax, dword ptr [ecx + field_1ae]             # 004f56c3
    sub eax, dword ptr [edx + field_1aa]             # 004f56c9
    mov dword ptr [ebp - local_repeat_range], eax          # 004f56cf
    cmp dword ptr [ebp - local_repeat_range], 0x0          # 004f56d2
    jle.d8 L_range_not_positive                            # 004f56d6
    # block 0x004f56d8: range > 0: slot+0x1a2 = (rand() % local_repeat_range, signed idiv remainder) + slot+0x1aa, then jump to L_set_due_tick
    call FUN_0050cd50                            # 004f56d8
    cdq                                          # 004f56dd
    idiv dword ptr [ebp - local_repeat_range]              # 004f56de
    mov ecx, dword ptr [ebp - local_slot]           # 004f56e1
    add edx, dword ptr [ecx + field_1aa]             # 004f56e4
    mov eax, dword ptr [ebp - local_slot]           # 004f56ea
    mov dword ptr [eax + field_1a2], edx             # 004f56ed
    jmp.d8 L_set_due_tick                            # 004f56f3
L_range_not_positive:
    # block 0x004f56f5: range <= 0: slot+0x1a2 = 0
    mov ecx, dword ptr [ebp - local_slot]           # 004f56f5
    mov dword ptr [ecx + field_1a2], 0x0             # 004f56f8
L_set_due_tick:
    # block 0x004f5702: slot+0x1a6 = local_tick + slot+0x1a2, then jump to epilogue
    mov edx, dword ptr [ebp - local_slot]           # 004f5702
    mov eax, dword ptr [ebp - local_tick]           # 004f5705
    add eax, dword ptr [edx + field_1a2]             # 004f5708
    mov ecx, dword ptr [ebp - local_slot]           # 004f570e
    mov dword ptr [ecx + field_1a6], eax             # 004f5711
    jmp.d8 L_return                            # 004f5717
L_restart_play:
    # block 0x004f5719: restart: call FUN_004f6059(channel) (ecx=this), result ignored
    mov edx, dword ptr [ebp + arg_channel]             # 004f5719
    push edx                                     # 004f571c
    mov ecx, dword ptr [ebp - local_this]          # 004f571d
    call FUN_004f6059                            # 004f5720
L_return:
    # block 0x004f5725: epilogue: restore frame, ret 4
    {load} mov esp, ebp                          # 004f5725
    pop ebp                                      # 004f5727
    ret 0x4                                      # 004f5728
