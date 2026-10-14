# FUN_004fe290
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe290
# extent:       0x004fe290-0x004fe2ca (58 code bytes)
# span:         0x004fe290-0x004fe2d0 (code 58, tables 0, padding 6)
# sha256:       a819a0dee40ece6a3f0f5efddd75d438308cd1bef5a86fcea45c0843006d629a
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# name:         vorbisfile_get_link_info
# arguments:    cdecl, stack args, caller pops (plain ret): [esp+4]=vf (decoder-file object, loaded to edx); [esp+8]=link (signed int, loaded to ecx; -1 selects the current link); returns eax = pointer to a 0x20-byte info record, or 0 when link >= link count
# locals:       none (no frame, nothing pushed; leaf function using only eax, ecx, edx)
# fields:       vf+0x04: dword tested for zero, selecting the default record when zero; vf+0x34: signed link count bounding the link index; vf+0x48: pointer to an array of 0x20-byte info records (record 0 is the default result); vf+0x58: state dword compared signed against 3 (any negative link takes the current-link path); vf+0x60: current link index used when the link argument is negative
# callees:      none
# track-n:      host-adapter: none
# unverified:   Role names are inferred, not read from source: the 0x20 record stride, the +0x04 gate, +0x34 link count, +0x58 state and +0x60 current link resemble a libvorbisfile ov_info lookup, but that identification rests on field layout only. What vf+0x04 means (it is merely compared with zero) is not established. The oracle (tests/his_pcm_quantize_original_oracle.py) hooks this function with a stub returning a fixed record, so its real branches (link >= 0 in range, link >= count, link -1 with state < 3) were never executed under the oracle. No Track N source implements it.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x004fe290 - 0x401000
.globl FUN_004fe290
FUN_004fe290:
    # block 0x004fe290: entry: edx=vf, eax=vf+0x04; if that dword is zero, take the default record path
    mov edx, dword ptr [esp + 0x4]               # 004fe290
    mov eax, dword ptr [edx + 0x4]               # 004fe294
    test eax, eax                                # 004fe297
    je.d8 L_return_first_record                             # 004fe299
    # block 0x004fe29b: ecx=link; if link >= 0 (signed) go to the indexed lookup
    mov ecx, dword ptr [esp + 0x8]               # 004fe29b
    test ecx, ecx                                # 004fe29f
    jge.d8 L_link_nonnegative                            # 004fe2a1
    # block 0x004fe2a3: link < 0 (current link requested): if vf+0x58 < 3 (signed) return the default record
    cmp dword ptr [edx + 0x58], 0x3              # 004fe2a3
    jl.d8 L_return_first_record                             # 004fe2a7
    # block 0x004fe2a9: link < 0 and vf+0x58 >= 3: return vf+0x48 + (vf+0x60)*0x20 (current-link record)
    mov eax, dword ptr [edx + 0x60]              # 004fe2a9
    mov ecx, dword ptr [edx + 0x48]              # 004fe2ac
    shl eax, 0x5                                 # 004fe2af
    {load} add eax, ecx                          # 004fe2b2
    ret                                          # 004fe2b4
L_link_nonnegative:
    # block 0x004fe2b5: link >= 0: if link < vf+0x34 (signed link count) the index is in range, else fall to the null result
    cmp ecx, dword ptr [edx + 0x34]              # 004fe2b5
    jl.d8 L_link_in_range                             # 004fe2b8
    # block 0x004fe2ba: link >= link count: return NULL (eax=0)
    {load} xor eax, eax                          # 004fe2ba
    ret                                          # 004fe2bc
L_link_in_range:
    # block 0x004fe2bd: in range: return vf+0x48 + link*0x20
    mov eax, dword ptr [edx + 0x48]              # 004fe2bd
    shl ecx, 0x5                                 # 004fe2c0
    {load} add eax, ecx                          # 004fe2c3
    ret                                          # 004fe2c5
L_return_first_record:
    # block 0x004fe2c6: default record: return vf+0x48 (first 0x20-byte record)
    mov eax, dword ptr [edx + 0x48]              # 004fe2c6
    ret                                          # 004fe2c9

# --- data items (not part of the function) -------------------------
.org 0x004fe2ca - 0x401000
PAD_004fe2ca:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90
