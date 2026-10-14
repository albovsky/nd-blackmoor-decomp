# FUN_004fe290
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe290
# extent:       0x004fe290-0x004fe2ca (58 code bytes)
# span:         0x004fe290-0x004fe2d0 (code 58, tables 0, padding 6)
# sha256:       a819a0dee40ece6a3f0f5efddd75d438308cd1bef5a86fcea45c0843006d629a
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x004fe290 - 0x401000
.globl FUN_004fe290
FUN_004fe290:
    # block 0x004fe290: <unfilled>
    mov edx, dword ptr [esp + 0x4]               # 004fe290
    mov eax, dword ptr [edx + 0x4]               # 004fe294
    test eax, eax                                # 004fe297
    je.d8 L_004fe2c6                             # 004fe299
    # block 0x004fe29b: <unfilled>
    mov ecx, dword ptr [esp + 0x8]               # 004fe29b
    test ecx, ecx                                # 004fe29f
    jge.d8 L_004fe2b5                            # 004fe2a1
    # block 0x004fe2a3: <unfilled>
    cmp dword ptr [edx + 0x58], 0x3              # 004fe2a3
    jl.d8 L_004fe2c6                             # 004fe2a7
    # block 0x004fe2a9: <unfilled>
    mov eax, dword ptr [edx + 0x60]              # 004fe2a9
    mov ecx, dword ptr [edx + 0x48]              # 004fe2ac
    shl eax, 0x5                                 # 004fe2af
    {load} add eax, ecx                          # 004fe2b2
    ret                                          # 004fe2b4
L_004fe2b5:
    # block 0x004fe2b5: <unfilled>
    cmp ecx, dword ptr [edx + 0x34]              # 004fe2b5
    jl.d8 L_004fe2bd                             # 004fe2b8
    # block 0x004fe2ba: <unfilled>
    {load} xor eax, eax                          # 004fe2ba
    ret                                          # 004fe2bc
L_004fe2bd:
    # block 0x004fe2bd: <unfilled>
    mov eax, dword ptr [edx + 0x48]              # 004fe2bd
    shl ecx, 0x5                                 # 004fe2c0
    {load} add eax, ecx                          # 004fe2c3
    ret                                          # 004fe2c5
L_004fe2c6:
    # block 0x004fe2c6: <unfilled>
    mov eax, dword ptr [edx + 0x48]              # 004fe2c6
    ret                                          # 004fe2c9

# --- data items (not part of the function) -------------------------
.org 0x004fe2ca - 0x401000
PAD_004fe2ca:  # 6 byte(s) of nop padding
    .fill 6, 1, 0x90
