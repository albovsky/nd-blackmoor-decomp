# FUN_004fcb5c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fcb5c
# extent:       0x004fcb5c-0x004fccf2 (406 code bytes)
# span:         0x004fcb5c-0x004fccf2 (code 406, tables 0, padding 0)
# sha256:       4feec6951a00a65465aeec5c128621ed090e4dd8030f71e0ef2aadf212257cc5
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# name:         CSound::ClampMasterAndRefreshCategory
# arguments:    thiscall: ecx=this (CSound); [ebp+8]=arg_category (dword index into the float master table at this+0xb764, no range check); callee pops 4 (ret 4); no defined return value (eax holds leftover state)
# locals:       [ebp-4]=local_channel (word channel counter 0..0x1f, sign-extended on use); [ebp-8]=local_this; [ebp-0xc]=local_master_low_clamped (float bits: 0.0f or the master); [ebp-0x10]=local_master_high_clamped (float bits: 1.0f or the master); esi saved and restored
# fields:       this+0xb764+4*category float master scalar (read, clamped to [0,1], written back); per channel ch at this+ch*0x5bb: +0x10c word category (compared with arg_category), +0x132 word volume_update_state (must be 1), +0x138 float first_scalar (read), +0x13c float second_scalar (read), +0x140 dword first_attenuation (written), +0x144 dword second_attenuation (written); globals: float 0x0052db78 = 0.0, float 0x0052cbf4 = 1.0, float 0x0052e4e0 = 2857.142822265625, double 0x0052e4d8 = -2857.142857142857, CDirectSound object 0x005cf1eb
# callees:      FUN_0050ce04 = CRT __ftol; FUN_004f684a = CDirectSound::Volume (ecx=0x005cf1eb, push channel), return value ignored
# track-n:      outputs/blackmoor-decomp/src/sound_control.c:sound_control_set_master_absolute
# unverified:   the name CSound::ClampMasterAndRefreshCategory is a project label: no original symbol or trace string exists for this function, and the class is inferred from its sole caller FUN_004fccf2 and the shared this+0xb764 field; the category argument is used as a table index with no bounds check although Track N rejects category >= 4, so the native module diverges deliberately; the clamp relies on x87 compare status bits (C0 for below 0.0, C0|C3 for at-most 1.0) so a NaN master compares as unordered and is replaced by 0.0, which agrees with Track N but is derived from x87 semantics rather than executed here; scalar values are not range-checked here (Track N rejects scalars outside [0,1]); the return value of FUN_004f684a (failure) is discarded in this loop; the left/right or pan role of first/second scalar is not established (S04-4 open); __ftol truncation is assumed from the CRT routine; the loop counter is a 16-bit word incremented with add dx,1 and compared as signed < 0x20
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_channel, 0x4  # [ebp - 0x4]
.equ local_this, 0x8  # [ebp - 0x8]
.equ local_master_low_clamped, 0xc  # [ebp - 0xc]
.equ local_master_high_clamped, 0x10  # [ebp - 0x10]
.equ arg_category, 0x8  # [ebp + 0x8]

# --- external targets -----------------------------------------------
.set FUN_004f684a, .text + (0x004f684a - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004fcb5c - 0x401000
.globl FUN_004fcb5c
FUN_004fcb5c:
    # block 0x004fcb5c: entry: save esi and this; compare master[category] (float at this+0xb764+4*category) with 0.0f via fcomp and test ah,1; C0 clear (master >= 0.0) goes to L_master_keep
    push ebp                                     # 004fcb5c
    {load} mov ebp, esp                          # 004fcb5d
    sub esp, 0x10                                # 004fcb5f
    push esi                                     # 004fcb62
    mov dword ptr [ebp - local_this], ecx           # 004fcb63
    mov eax, dword ptr [ebp + arg_category]             # 004fcb66
    mov ecx, dword ptr [ebp - local_this]           # 004fcb69
    fld dword ptr [ecx + 4*eax + 0xb764]         # 004fcb6c
    fcomp dword ptr [0x52db78]                   # 004fcb73
    fnstsw ax                                    # 004fcb79
    test ah, 0x1                                 # 004fcb7b
    je.d8 L_master_keep                             # 004fcb7e
    # block 0x004fcb80: master < 0 (or unordered): local_master_low_clamped = 0.0f
    mov dword ptr [ebp - local_master_low_clamped], 0x0           # 004fcb80
    jmp.d8 L_master_store_low                            # 004fcb87
L_master_keep:
    # block 0x004fcb89: master >= 0: local_master_low_clamped = master[category]
    mov edx, dword ptr [ebp + arg_category]             # 004fcb89
    mov eax, dword ptr [ebp - local_this]           # 004fcb8c
    fld dword ptr [eax + 4*edx + 0xb764]         # 004fcb8f
    fstp dword ptr [ebp - local_master_low_clamped]               # 004fcb96
L_master_store_low:
    # block 0x004fcb99: store local_master_low_clamped back to master[category]; compare it with 1.0f via test ah,0x41; <= 1.0 goes to L_master_keep_high
    mov ecx, dword ptr [ebp + arg_category]             # 004fcb99
    mov edx, dword ptr [ebp - local_this]           # 004fcb9c
    mov eax, dword ptr [ebp - local_master_low_clamped]           # 004fcb9f
    mov dword ptr [edx + 4*ecx + 0xb764], eax    # 004fcba2
    mov ecx, dword ptr [ebp + arg_category]             # 004fcba9
    mov edx, dword ptr [ebp - local_this]           # 004fcbac
    fld dword ptr [edx + 4*ecx + 0xb764]         # 004fcbaf
    fcomp dword ptr [0x52cbf4]                   # 004fcbb6
    fnstsw ax                                    # 004fcbbc
    test ah, 0x41                                # 004fcbbe
    jne.d8 L_master_keep_high                            # 004fcbc1
    # block 0x004fcbc3: master > 1.0: local_master_high_clamped = 0x3f800000 (1.0f)
    mov dword ptr [ebp - local_master_high_clamped], 0x3f800000   # 004fcbc3
    jmp.d8 L_master_store_high                            # 004fcbca
L_master_keep_high:
    # block 0x004fcbcc: master <= 1.0: local_master_high_clamped = master[category]
    mov eax, dword ptr [ebp + arg_category]             # 004fcbcc
    mov ecx, dword ptr [ebp - local_this]           # 004fcbcf
    fld dword ptr [ecx + 4*eax + 0xb764]         # 004fcbd2
    fstp dword ptr [ebp - local_master_high_clamped]              # 004fcbd9
L_master_store_high:
    # block 0x004fcbdc: store local_master_high_clamped to master[category]; local_channel = 0, jump to the loop test
    mov edx, dword ptr [ebp + arg_category]             # 004fcbdc
    mov eax, dword ptr [ebp - local_this]           # 004fcbdf
    mov ecx, dword ptr [ebp - local_master_high_clamped]          # 004fcbe2
    mov dword ptr [eax + 4*edx + 0xb764], ecx    # 004fcbe5
    mov word ptr [ebp - local_channel], 0x0            # 004fcbec
    jmp.d8 L_channel_loop_test                            # 004fcbf2
L_next_channel:
    # block 0x004fcbf4: loop step: local_channel += 1 (word add)
    mov dx, word ptr [ebp - local_channel]             # 004fcbf4
    add dx, 0x1                                  # 004fcbf8
    mov word ptr [ebp - local_channel], dx             # 004fcbfc
L_channel_loop_test:
    # block 0x004fcc00: loop test: signed local_channel >= 0x20 goes to the epilogue
    movsx eax, word ptr [ebp - local_channel]          # 004fcc00
    cmp eax, 0x20                                # 004fcc04
    jge.d32 L_return                           # 004fcc07
    # block 0x004fcc0d: read word category (+0x10c) of this channel; != arg_category goes to L_channel_done
    movsx ecx, word ptr [ebp - local_channel]          # 004fcc0d
    imul ecx, ecx, 0x5bb                         # 004fcc11
    mov edx, dword ptr [ebp - local_this]           # 004fcc17
    movsx eax, word ptr [edx + ecx + 0x10c]      # 004fcc1a
    cmp eax, dword ptr [ebp + arg_category]             # 004fcc22
    jne.d32 L_channel_done                           # 004fcc25
    # block 0x004fcc2b: read word volume_update_state (+0x132, zero-extended); != 1 goes to L_channel_done
    movsx ecx, word ptr [ebp - local_channel]          # 004fcc2b
    imul ecx, ecx, 0x5bb                         # 004fcc2f
    mov edx, dword ptr [ebp - local_this]           # 004fcc35
    {load} xor eax, eax                          # 004fcc38
    mov ax, word ptr [edx + ecx + 0x132]         # 004fcc3a
    cmp eax, 0x1                                 # 004fcc42
    jne.d32 L_channel_done                           # 004fcc45
    # block 0x004fcc4b: first attenuation +0x140 = __ftol(first_scalar@+0x138 * master[category] * 2857.142822265625 + (-2857.142857142857)); second attenuation +0x144 likewise from second_scalar@+0x13c; then FUN_004f684a(ecx=0x5cf1eb, channel)
    movsx ecx, word ptr [ebp - local_channel]          # 004fcc4b
    imul ecx, ecx, 0x5bb                         # 004fcc4f
    mov edx, dword ptr [ebp - local_this]           # 004fcc55
    mov eax, dword ptr [ebp + arg_category]             # 004fcc58
    mov esi, dword ptr [ebp - local_this]           # 004fcc5b
    fld dword ptr [edx + ecx + 0x138]            # 004fcc5e
    fmul dword ptr [esi + 4*eax + 0xb764]        # 004fcc65
    fmul dword ptr [0x52e4e0]                    # 004fcc6c
    fadd qword ptr [0x52e4d8]                    # 004fcc72
    call FUN_0050ce04                            # 004fcc78
    movsx ecx, word ptr [ebp - local_channel]          # 004fcc7d
    imul ecx, ecx, 0x5bb                         # 004fcc81
    mov edx, dword ptr [ebp - local_this]           # 004fcc87
    mov dword ptr [edx + ecx + 0x140], eax       # 004fcc8a
    movsx eax, word ptr [ebp - local_channel]          # 004fcc91
    imul eax, eax, 0x5bb                         # 004fcc95
    mov ecx, dword ptr [ebp - local_this]           # 004fcc9b
    mov edx, dword ptr [ebp + arg_category]             # 004fcc9e
    mov esi, dword ptr [ebp - local_this]           # 004fcca1
    fld dword ptr [ecx + eax + 0x13c]            # 004fcca4
    fmul dword ptr [esi + 4*edx + 0xb764]        # 004fccab
    fmul dword ptr [0x52e4e0]                    # 004fccb2
    fadd qword ptr [0x52e4d8]                    # 004fccb8
    call FUN_0050ce04                            # 004fccbe
    movsx ecx, word ptr [ebp - local_channel]          # 004fccc3
    imul ecx, ecx, 0x5bb                         # 004fccc7
    mov edx, dword ptr [ebp - local_this]           # 004fcccd
    mov dword ptr [edx + ecx + 0x144], eax       # 004fccd0
    movsx eax, word ptr [ebp - local_channel]          # 004fccd7
    push eax                                     # 004fccdb
    mov ecx, 0x5cf1eb                            # 004fccdc
    call FUN_004f684a                            # 004fcce1
L_channel_done:
    # block 0x004fcce6: channel done: jump to the loop step
    jmp.d32 L_next_channel                           # 004fcce6
L_return:
    # block 0x004fcceb: epilogue: restore esi and frame, ret 4
    pop esi                                      # 004fcceb
    {load} mov esp, ebp                          # 004fccec
    pop ebp                                      # 004fccee
    ret 0x4                                      # 004fccef
