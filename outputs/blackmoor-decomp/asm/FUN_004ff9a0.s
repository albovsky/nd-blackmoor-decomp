# FUN_004ff9a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ff9a0
# extent:       0x004ff9a0-0x004ff9f8 (88 code bytes)
# span:         0x004ff9a0-0x004ffa00 (code 88, tables 0, padding 8)
# sha256:       e2c8bc41563de52349dc8a8131115483ac2dae1ebb690a12cd12622717ae3ac8
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# name:         vorbis_dsp_get_pcm_planes
# arguments:    cdecl, stack args, caller pops (plain ret): [esp+4]=dsp (decode-state object, loaded to ecx; callers pass vf+0x1da); [esp+8]=out_planes (float*** destination, loaded to esi after push esi so it is read as [esp+0xc]; may be NULL); returns eax = frames available (dsp+0x14 minus dsp+0x18), or 0 when the consumed counter is out of range
# locals:       none (no frame); esi is saved/restored, edi is saved on the non-NULL out_planes path and ebx is saved around the loop (only when the channel count is positive)
# fields:       dsp+0x04: info pointer (edx); info+0x04: signed channel count, loop bound; dsp+0x08: array of per-channel float* bases (read); dsp+0x0c: array of per-channel float* output slots (written, and its address is stored through out_planes); dsp+0x14: frames buffered (upper bound); dsp+0x18: frames already consumed (offset into every plane)
# callees:      none
# track-n:      host-adapter: none
# unverified:   Role names (buffered/consumed counters, plane arrays) are inferred from the arithmetic and from resemblance to libvorbis vorbis_synthesis_pcmout; no source was read. The function never validates that dsp+0x08 and dsp+0x0c point at arrays of at least channel-count entries, and never NULL-checks them; the allocation that guarantees this is not verified here. The oracle hooks this routine with a stub, so its real loop was not executed under the oracle. No Track N source implements it.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x004ff9a0 - 0x401000
.globl FUN_004ff9a0
FUN_004ff9a0:
    # block 0x004ff9a0: entry: ecx=dsp, save esi, eax=dsp+0x18 (consumed), edx=dsp+0x04 (info); if consumed <= -1 (signed, i.e. negative) return 0
    mov ecx, dword ptr [esp + 0x4]               # 004ff9a0
    push esi                                     # 004ff9a4
    mov eax, dword ptr [ecx + 0x18]              # 004ff9a5
    mov edx, dword ptr [ecx + 0x4]               # 004ff9a8
    cmp eax, -0x1                                # 004ff9ab
    jle.d8 L_no_pcm                            # 004ff9ae
    # block 0x004ff9b0: if consumed >= dsp+0x14 (signed, nothing left to read) return 0
    cmp eax, dword ptr [ecx + 0x14]              # 004ff9b0
    jge.d8 L_no_pcm                            # 004ff9b3
    # block 0x004ff9b5: esi=out_planes; if it is NULL skip the plane publishing and just return the available count
    mov esi, dword ptr [esp + 0xc]               # 004ff9b5
    test esi, esi                                # 004ff9b9
    je.d8 L_return_available                             # 004ff9bb
    # block 0x004ff9bd: save edi; edi=info+0x04 (channel count), eax=0 channel index; if channel count <= 0 (signed) skip the loop
    push edi                                     # 004ff9bd
    mov edi, dword ptr [edx + 0x4]               # 004ff9be
    {load} xor eax, eax                          # 004ff9c1
    test edi, edi                                # 004ff9c3
    jle.d8 L_publish_plane_array                            # 004ff9c5
    # block 0x004ff9c7: save ebx for the loop
    push ebx                                     # 004ff9c7
L_channel_loop:
    # block 0x004ff9c8: per channel i: dsp+0x0c[i] = dsp+0x08[i] + consumed*4 (pointer advanced by consumed floats); i++; loop while i < channel count
    mov edi, dword ptr [ecx + 0x8]               # 004ff9c8
    mov ebx, dword ptr [ecx + 0x18]              # 004ff9cb
    mov edi, dword ptr [edi + 4*eax]             # 004ff9ce
    inc eax                                      # 004ff9d1
    lea edi, [edi + 4*ebx]                       # 004ff9d2
    mov ebx, dword ptr [ecx + 0xc]               # 004ff9d5
    mov dword ptr [ebx + 4*eax - 0x4], edi       # 004ff9d8
    mov edi, dword ptr [edx + 0x4]               # 004ff9dc
    {load} cmp eax, edi                          # 004ff9df
    jl.d8 L_channel_loop                             # 004ff9e1
    # block 0x004ff9e3: loop finished: restore ebx
    pop ebx                                      # 004ff9e3
L_publish_plane_array:
    # block 0x004ff9e4: *out_planes = dsp+0x0c (the published plane-pointer array); restore edi
    mov eax, dword ptr [ecx + 0xc]               # 004ff9e4
    pop edi                                      # 004ff9e7
    mov dword ptr [esi], eax                     # 004ff9e8
L_return_available:
    # block 0x004ff9ea: return dsp+0x14 - dsp+0x18 (frames available) and restore esi
    mov eax, dword ptr [ecx + 0x14]              # 004ff9ea
    mov edx, dword ptr [ecx + 0x18]              # 004ff9ed
    {load} sub eax, edx                          # 004ff9f0
    pop esi                                      # 004ff9f2
    ret                                          # 004ff9f3
L_no_pcm:
    # block 0x004ff9f4: out-of-range consumed counter: return 0 and restore esi
    {load} xor eax, eax                          # 004ff9f4
    pop esi                                      # 004ff9f6
    ret                                          # 004ff9f7

# --- data items (not part of the function) -------------------------
.org 0x004ff9f8 - 0x401000
PAD_004ff9f8:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90
