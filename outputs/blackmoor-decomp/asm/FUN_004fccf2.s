# FUN_004fccf2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fccf2
# extent:       0x004fccf2-0x004fcd4d (91 code bytes)
# span:         0x004fccf2-0x004fcd4d (code 91, tables 0, padding 0)
# sha256:       076b72ed4cb5aa88182dda67619a38e3aaadaf0462696a5b8f357e375f5a3cfc
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# name:         CSound::SetVolumeAbsolute
# arguments:    thiscall: ecx=this (CSound); [ebp+8]=arg_percent (low 16 bits used, unsigned percent); [ebp+0xc]=arg_category (dword index into the master table, no range check); callee pops 8 (ret 8); no defined return value
# locals:       [ebp-4]=local_this; [ebp-8]=local_percent_masked (arg_percent & 0xffff, dword for fild); [ebp-0xc]=local_percent_float (float conversion of the percent)
# fields:       this+0xb764+4*category float master scalar := float(percent) / 100.0f (written); globals: word 0x0063a4cd debug-log flag, string 0x005609d4 'CSound::SetVolumeAbsolute()', float 0x0052cbec = 100.0
# callees:      FUN_0044a2b7 = log-line writer; FUN_004fcb5c = clamp master and refresh the category's channels (ecx=this, push category)
# track-n:      outputs/blackmoor-decomp/src/sound_control.c:sound_control_set_master_absolute
# unverified:   the [0,1] clamp of the stored master and the per-channel refresh are in FUN_004fcb5c, not here; the category argument is used as a table index with no bounds check although Track N rejects category >= 4 (deliberate native rejection); Track N computes (double)percent / 100.0 then rounds to float, the bytes do float(percent) via fild/fstp then fdiv by the float 100.0 at x87 precision and fstp to float, which agrees under the startup precision-53 round-to-nearest control word that Track N requires but this was not executed here; percent above 100 is stored unclamped until FUN_004fcb5c clamps it; the argument order (percent, category) is the reverse of Track N's (category, percent) wrapper; csnd_master_table is the float table at this+0xb764 indexed by category (name from Track N master[])
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]
.equ local_percent_masked, 0x8  # [ebp - 0x8]
.equ local_percent_float, 0xc  # [ebp - 0xc]
.equ arg_percent, 0x8  # [ebp + 0x8]
.equ arg_category, 0xc  # [ebp + 0xc]

.equ csnd_master_table, 0xb764  # CSound+0xb764+4*category: float master scalar table

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004fcb5c, .text + (0x004fcb5c - 0x401000)

.org 0x004fccf2 - 0x401000
.globl FUN_004fccf2
FUN_004fccf2:
    # block 0x004fccf2: entry: save this; if debug-log word [0x63a4cd] is zero skip the trace log
    push ebp                                     # 004fccf2
    {load} mov ebp, esp                          # 004fccf3
    sub esp, 0xc                                 # 004fccf5
    mov dword ptr [ebp - local_this], ecx           # 004fccf8
    movsx eax, word ptr [0x63a4cd]               # 004fccfb
    test eax, eax                                # 004fcd02
    je.d8 L_after_debug_log                             # 004fcd04
    # block 0x004fcd06: log string 0x5609d4 'CSound::SetVolumeAbsolute()' through FUN_0044a2b7
    push 0x5609d4                                # 004fcd06
    call FUN_0044a2b7                            # 004fcd0b
    add esp, 0x4                                 # 004fcd10
L_after_debug_log:
    # block 0x004fcd13: master[category] = float(arg_percent & 0xffff) / 100.0f (fild, fstp float, fdiv by 0x52cbec, fstp to this+0xb764+4*category), then call FUN_004fcb5c(ecx=this, category) and return
    mov ecx, dword ptr [ebp + arg_percent]             # 004fcd13
    and ecx, 0xffff                              # 004fcd16
    mov dword ptr [ebp - local_percent_masked], ecx           # 004fcd1c
    fild dword ptr [ebp - local_percent_masked]               # 004fcd1f
    fstp dword ptr [ebp - local_percent_float]               # 004fcd22
    fld dword ptr [ebp - local_percent_float]                # 004fcd25
    fdiv dword ptr [0x52cbec]                    # 004fcd28
    mov edx, dword ptr [ebp + arg_category]             # 004fcd2e
    mov eax, dword ptr [ebp - local_this]           # 004fcd31
    fstp dword ptr [eax + 4*edx + csnd_master_table]        # 004fcd34
    mov ecx, dword ptr [ebp + arg_category]             # 004fcd3b
    push ecx                                     # 004fcd3e
    mov ecx, dword ptr [ebp - local_this]           # 004fcd3f
    call FUN_004fcb5c                            # 004fcd42
    {load} mov esp, ebp                          # 004fcd47
    pop ebp                                      # 004fcd49
    ret 0x8                                      # 004fcd4a
