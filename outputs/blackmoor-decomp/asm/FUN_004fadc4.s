# FUN_004fadc4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fadc4
# extent:       0x004fadc4-0x004faf98 (468 code bytes)
# span:         0x004fadc4-0x004faf98 (code 468, tables 0, padding 0)
# sha256:       0576d48f541320ff06b1ff2f8753d013d9d9c0516f44f4cf475e6d02577f2afa
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# name:         CSound::LoadDIGISound
# arguments:    thiscall: ecx=this (CSound); [ebp+8]=arg_name (pointer to NUL-terminated file-name text); [ebp+0xc]=arg_channel (dword, only the low 16 bits are used); callee pops 8 (ret 8); returns eax=1 when FUN_004f379c succeeds, 0 when it fails
# locals:       [ebp-4]=local_this (CSound this saved from ecx via the push ecx slot); esi and edi are saved and restored
# fields:       per channel ch=(arg_channel & 0xffff) at this+ch*0x5bb: +0x08 file-name buffer (receives a copy of arg_name including NUL, no length check); +0x10c word category (read, sign-extended); +0x138 float first_scalar (read); +0x13c float second_scalar (read); +0x140 dword first_attenuation (written); +0x144 dword second_attenuation (written); +0x132 word volume_update_state := 1 on success; this+0xb764+4*category float master (read); globals: word 0x0063a4cd debug-log flag, 0x0063888b log text buffer, float 0x0052e4e0 = 2857.142822265625, double 0x0052e4d8 = -2857.142857142857, 0x005cf1eb CDirectSound object, formats 0x005605e0 and 0x00560610
# callees:      FUN_0050ca3e = sprintf-style formatter; FUN_0044a2b7 = log-line writer; FUN_0050ce04 = CRT __ftol (st0 to eax, truncating); FUN_004f379c = CDirectSound load of the sound file for the channel (ecx=0x5cf1eb, push channel); FUN_004fa2a8 = CDirectSound error code to text; FUN_0052139c = error report call (buffer, 0, 0)
# track-n:      outputs/blackmoor-decomp/src/sound_control.c:sound_control_calculate_attenuation
# unverified:   Track N sound_control_calculate_attenuation covers ONLY the two attenuation expressions (scalar * master * 2857.142822265625 + (-2857.142857142857), __ftol); the name copy, the FUN_004f379c load, the error report and the update-state store have no Track N counterpart; the name copy is unbounded (strlen+1 bytes into the slot name buffer; whether the buffer can hold it is not established) and must be a native rejection; the role of the two scalars/attenuations (left/right pan or otherwise) is NOT established (S04-4 open), only that both are stored independently; category index is read as a sign-extended word and used as master-table index with no bounds check (Track N rejects category >= 4); scalar and master range are not validated here (Track N rejects values outside [0,1] and expressions outside [-2858,1]); __ftol rounding mode switch comes from FUN_0050ce04 pseudocode/Track N, not from bytes examined here; FUN_004f379c and FUN_0052139c semantics are pseudocode only; the pushed channel dword keeps stale upper 16 bits from the last __ftol result and the callee is assumed to read only a ushort (pseudocode)
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]
.equ arg_name, 0x8  # [ebp + 0x8]
.equ arg_channel, 0xc  # [ebp + 0xc]

.equ field_8, 0x8  # offset
.equ field_10c, 0x10c  # offset
.equ field_132, 0x132  # offset
.equ field_138, 0x138  # offset
.equ field_13c, 0x13c  # offset
.equ field_140, 0x140  # offset
.equ field_144, 0x144  # offset
.equ field_b764, 0xb764  # offset

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f379c, .text + (0x004f379c - 0x401000)
.set FUN_004fa2a8, .text + (0x004fa2a8 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004fadc4 - 0x401000
.globl FUN_004fadc4
FUN_004fadc4:
    # block 0x004fadc4: entry: save this, esi, edi; if debug-log word [0x63a4cd] is zero skip the begin-log
    push ebp                                     # 004fadc4
    {load} mov ebp, esp                          # 004fadc5
    push ecx                                     # 004fadc7
    push esi                                     # 004fadc8
    push edi                                     # 004fadc9
    mov dword ptr [ebp - local_this], ecx           # 004fadca
    movsx eax, word ptr [0x63a4cd]               # 004fadcd
    test eax, eax                                # 004fadd4
    je.d8 L_after_begin_log                             # 004fadd6
    # block 0x004fadd8: log 'CSound::LoadDIGISound() - channel %d, file %s' (0x5605e0) with channel&0xffff and arg_name via FUN_0050ca3e, then FUN_0044a2b7
    mov ecx, dword ptr [ebp + arg_name]             # 004fadd8
    push ecx                                     # 004faddb
    mov edx, dword ptr [ebp + arg_channel]             # 004faddc
    and edx, 0xffff                              # 004faddf
    push edx                                     # 004fade5
    push 0x5605e0                                # 004fade6
    push 0x63888b                                # 004fadeb
    call FUN_0050ca3e                            # 004fadf0
    add esp, 0x10                                # 004fadf5
    push 0x63888b                                # 004fadf8
    call FUN_0044a2b7                            # 004fadfd
    add esp, 0x4                                 # 004fae02
L_after_begin_log:
    # block 0x004fae05: copy arg_name (strlen+1 bytes via repne scasb / rep movs) to this+ch*0x5bb+8; first attenuation = __ftol(first_scalar@+0x138 * master[category@+0x10c] * 2857.142822265625 + (-2857.142857142857)) stored at +0x140; second attenuation from second_scalar@+0x13c stored at +0x144; then FUN_004f379c(ecx=0x5cf1eb, channel); nonzero result goes to L_load_ok_mark_ready
    mov edi, dword ptr [ebp + arg_name]             # 004fae05
    mov eax, dword ptr [ebp + arg_channel]             # 004fae08
    and eax, 0xffff                              # 004fae0b
    imul eax, eax, 0x5bb                         # 004fae10
    mov ecx, dword ptr [ebp - local_this]           # 004fae16
    lea edx, [ecx + eax + field_8]                   # 004fae19
    or ecx, -0x1                                 # 004fae1d
    {load} xor eax, eax                          # 004fae20
    repne scasb al, byte ptr es:[edi]            # 004fae22
    not ecx                                      # 004fae24
    {load} sub edi, ecx                          # 004fae26
    {load} mov esi, edi                          # 004fae28
    {load} mov eax, ecx                          # 004fae2a
    {load} mov edi, edx                          # 004fae2c
    shr ecx, 0x2                                 # 004fae2e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004fae31
    {load} mov ecx, eax                          # 004fae33
    and ecx, 0x3                                 # 004fae35
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004fae38
    mov ecx, dword ptr [ebp + arg_channel]             # 004fae3a
    and ecx, 0xffff                              # 004fae3d
    imul ecx, ecx, 0x5bb                         # 004fae43
    mov edx, dword ptr [ebp + arg_channel]             # 004fae49
    and edx, 0xffff                              # 004fae4c
    imul edx, edx, 0x5bb                         # 004fae52
    mov eax, dword ptr [ebp - local_this]           # 004fae58
    movsx edx, word ptr [eax + edx + field_10c]      # 004fae5b
    mov eax, dword ptr [ebp - local_this]           # 004fae63
    mov esi, dword ptr [ebp - local_this]           # 004fae66
    fld dword ptr [eax + ecx + field_138]            # 004fae69
    fmul dword ptr [esi + 4*edx + field_b764]        # 004fae70
    fmul dword ptr [0x52e4e0]                    # 004fae77
    fadd qword ptr [0x52e4d8]                    # 004fae7d
    call FUN_0050ce04                            # 004fae83
    mov ecx, dword ptr [ebp + arg_channel]             # 004fae88
    and ecx, 0xffff                              # 004fae8b
    imul ecx, ecx, 0x5bb                         # 004fae91
    mov edx, dword ptr [ebp - local_this]           # 004fae97
    mov dword ptr [edx + ecx + field_140], eax       # 004fae9a
    mov eax, dword ptr [ebp + arg_channel]             # 004faea1
    and eax, 0xffff                              # 004faea4
    imul eax, eax, 0x5bb                         # 004faea9
    mov ecx, dword ptr [ebp + arg_channel]             # 004faeaf
    and ecx, 0xffff                              # 004faeb2
    imul ecx, ecx, 0x5bb                         # 004faeb8
    mov edx, dword ptr [ebp - local_this]           # 004faebe
    movsx ecx, word ptr [edx + ecx + field_10c]      # 004faec1
    mov edx, dword ptr [ebp - local_this]           # 004faec9
    mov esi, dword ptr [ebp - local_this]           # 004faecc
    fld dword ptr [edx + eax + field_13c]            # 004faecf
    fmul dword ptr [esi + 4*ecx + field_b764]        # 004faed6
    fmul dword ptr [0x52e4e0]                    # 004faedd
    fadd qword ptr [0x52e4d8]                    # 004faee3
    call FUN_0050ce04                            # 004faee9
    mov ecx, dword ptr [ebp + arg_channel]             # 004faeee
    and ecx, 0xffff                              # 004faef1
    imul ecx, ecx, 0x5bb                         # 004faef7
    mov edx, dword ptr [ebp - local_this]           # 004faefd
    mov dword ptr [edx + ecx + field_144], eax       # 004faf00
    mov ax, word ptr [ebp + arg_channel]               # 004faf07
    push eax                                     # 004faf0b
    mov ecx, 0x5cf1eb                            # 004faf0c
    call FUN_004f379c                            # 004faf11
    test eax, eax                                # 004faf16
    jne.d8 L_load_ok_mark_ready                            # 004faf18
    # block 0x004faf1a: load failed: format 'CSound::LoadDIGISound() - channel %d error, file %s, %s' (0x560610) with FUN_004fa2a8 error text into 0x63888b, call FUN_0052139c(buffer,0,0); skip the log call when debug-log word is zero
    mov ecx, 0x5cf1eb                            # 004faf1a
    call FUN_004fa2a8                            # 004faf1f
    push eax                                     # 004faf24
    mov ecx, dword ptr [ebp + arg_name]             # 004faf25
    push ecx                                     # 004faf28
    mov edx, dword ptr [ebp + arg_channel]             # 004faf29
    and edx, 0xffff                              # 004faf2c
    push edx                                     # 004faf32
    push 0x560610                                # 004faf33
    push 0x63888b                                # 004faf38
    call FUN_0050ca3e                            # 004faf3d
    add esp, 0x14                                # 004faf42
    push 0x0                                     # 004faf45
    push 0x0                                     # 004faf47
    push 0x63888b                                # 004faf49
    call FUN_0052139c                            # 004faf4e
    movsx eax, word ptr [0x63a4cd]               # 004faf53
    test eax, eax                                # 004faf5a
    je.d8 L_return_failure                             # 004faf5c
    # block 0x004faf5e: debug-log on: log the error text through FUN_0044a2b7
    push 0x63888b                                # 004faf5e
    call FUN_0044a2b7                            # 004faf63
    add esp, 0x4                                 # 004faf68
L_return_failure:
    # block 0x004faf6b: failure result: eax = 0, jump to epilogue
    {load} xor eax, eax                          # 004faf6b
    jmp.d8 L_return                            # 004faf6d
L_load_ok_mark_ready:
    # block 0x004faf6f: load succeeded: volume_update_state word (+0x132) of the channel := 1, eax = 1
    mov ecx, dword ptr [ebp + arg_channel]             # 004faf6f
    and ecx, 0xffff                              # 004faf72
    imul ecx, ecx, 0x5bb                         # 004faf78
    mov edx, dword ptr [ebp - local_this]           # 004faf7e
    mov word ptr [edx + ecx + field_132], 0x1        # 004faf81
    mov eax, 0x1                                 # 004faf8b
L_return:
    # block 0x004faf90: epilogue: restore edi, esi, frame, ret 8
    pop edi                                      # 004faf90
    pop esi                                      # 004faf91
    {load} mov esp, ebp                          # 004faf92
    pop ebp                                      # 004faf94
    ret 0x8                                      # 004faf95
