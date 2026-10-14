# FUN_004ffa00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ffa00
# extent:       0x004ffa00-0x004ffa2b (43 code bytes)
# span:         0x004ffa00-0x004ffa30 (code 43, tables 0, padding 5)
# sha256:       e7f7014383c1b91c2a26c8adb30802be0f32fad3907c2994b41edbe6e423d128
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

.org 0x004ffa00 - 0x401000
.globl FUN_004ffa00
FUN_004ffa00:
    # block 0x004ffa00: <unfilled>
    mov ecx, dword ptr [esp + 0x8]               # 004ffa00
    mov eax, dword ptr [esp + 0x4]               # 004ffa04
    test ecx, ecx                                # 004ffa08
    je.d8 L_004ffa20                             # 004ffa0a
    # block 0x004ffa0c: <unfilled>
    mov edx, dword ptr [eax + 0x18]              # 004ffa0c
    push esi                                     # 004ffa0f
    mov esi, dword ptr [eax + 0x14]              # 004ffa10
    {load} add edx, ecx                          # 004ffa13
    {load} cmp edx, esi                          # 004ffa15
    pop esi                                      # 004ffa17
    jle.d8 L_004ffa20                            # 004ffa18
    # block 0x004ffa1a: <unfilled>
    mov eax, 0xffffff7d                          # 004ffa1a
    ret                                          # 004ffa1f
L_004ffa20:
    # block 0x004ffa20: <unfilled>
    mov edx, dword ptr [eax + 0x18]              # 004ffa20
    {load} add edx, ecx                          # 004ffa23
    mov dword ptr [eax + 0x18], edx              # 004ffa25
    {load} xor eax, eax                          # 004ffa28
    ret                                          # 004ffa2a

# --- data items (not part of the function) -------------------------
.org 0x004ffa2b - 0x401000
PAD_004ffa2b:  # 5 byte(s) of nop padding
    .fill 5, 1, 0x90
