# FUN_00437ea1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00437ea1
# extent:       0x00437ea1-0x0043811a (633 code bytes)
# span:         0x00437ea1-0x00438120 (code 633, tables 0, padding 6)
# sha256:       6b5b77e944445a850fdcab16519f38e7336e51e2c4d5d56ca84bcd4be0701831
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# name:         TextInput::is_accepted_char
# arguments:    thiscall: ecx=this (spilled to local_this, never read again; callers pass 0x583208 or their own this); [ebp+8]=arg_char, only its low byte is read and it is sign-extended (movsx byte), so codes 0x80..0xff compare as negative values; callee pops 4 (ret 4); returns eax=1 when the character is accepted, eax=0 otherwise
# locals:       frame 4 bytes: local_this [ebp-4] = this spilled from ecx; no other locals
# fields:       none (no fields touched)
# callees:      none
# track-n:      host-adapter: none
# unverified:   No Track N source covers this routine; TextInput::is_accepted_char is my label for the predicate. The accepted set by the bytes is: A..Z, a..z, 0..9 (signed range compares), backspace 0x08, carriage return 0x0d, and the exact codes space 0x20, 0x2e, 0x2c, 0x3f, 0x21, 0x2f, 0x24, 0x28, 0x29, 0x26, 0x3a, 0x3b, 0x2b, 0x25, 0x3d, 0x2d, plus 27 high-bit byte codes tested as signed negatives: 0xe0 0xe7 0xe8 0xe9 0xea 0xeb 0xf4 0xc0 0xe2 0xee 0xf9 0xc4 0xe4 0xd6 0xf6 0xdc 0xfc 0xa1 0xbf 0xd1 0xf1 0xc9 0xe1 0xed 0xf3 0xfa 0xdf. That these high codes are accented Latin letters and Spanish punctuation of a Latin-1 or Windows-1252 style code page is my reading of the byte values; the game text encoding was not verified. Callers (0x437dcd twice, 0x48e93e, 0x4a1f59, 0x4b8193) were read from pseudocode and call bytes only to see that the argument is a typed character and that ecx is 0x583208 or the caller this; what the three calls at 0x48e997, 0x4a1faf and 0x4b81d7 do with the result is not traced here. The comparisons are done in the order listed, with no table, and there is no behaviour outside the listed set (everything else returns 0). The callers push the whole ecx with the character in cl, so the upper bits of the pushed dword are not meaningful and the callee ignores them.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]: this, spilled from ecx and never read again
.equ arg_char, 0x8  # [ebp + 0x8]: character code, low byte read with sign extension

# --- external targets -----------------------------------------------

.org 0x00437ea1 - 0x401000
.globl FUN_00437ea1
FUN_00437ea1:
    # block 0x00437ea1: entry: spill this; if signed char arg_char < 0x41 (A) go to L_check_lower (jl)
    push ebp                                     # 00437ea1
    {load} mov ebp, esp                          # 00437ea2
    push ecx                                     # 00437ea4
    mov dword ptr [ebp - local_this], ecx           # 00437ea5
    movsx eax, byte ptr [ebp + arg_char]            # 00437ea8
    cmp eax, 0x41                                # 00437eac
    jl.d8 L_check_lower                             # 00437eaf
    # block 0x00437eb1: if signed arg_char <= 0x5a (Z) it is an upper case letter, go to L_accept (jle)
    movsx ecx, byte ptr [ebp + arg_char]            # 00437eb1
    cmp ecx, 0x5a                                # 00437eb5
    jle.d32 L_accept                           # 00437eb8
L_check_lower:
    # block 0x00437ebe: (L_check_lower) if signed arg_char < 0x61 (a) go to L_check_digit (jl)
    movsx edx, byte ptr [ebp + arg_char]            # 00437ebe
    cmp edx, 0x61                                # 00437ec2
    jl.d8 L_check_digit                             # 00437ec5
    # block 0x00437ec7: if signed arg_char <= 0x7a (z) it is a lower case letter, go to L_accept (jle)
    movsx eax, byte ptr [ebp + arg_char]            # 00437ec7
    cmp eax, 0x7a                                # 00437ecb
    jle.d32 L_accept                           # 00437ece
L_check_digit:
    # block 0x00437ed4: (L_check_digit) if signed arg_char < 0x30 (0) go to L_check_listed (jl)
    movsx ecx, byte ptr [ebp + arg_char]            # 00437ed4
    cmp ecx, 0x30                                # 00437ed8
    jl.d8 L_check_listed                             # 00437edb
    # block 0x00437edd: if signed arg_char <= 0x39 (9) it is a digit, go to L_accept (jle)
    movsx edx, byte ptr [ebp + arg_char]            # 00437edd
    cmp edx, 0x39                                # 00437ee1
    jle.d32 L_accept                           # 00437ee4
L_check_listed:
    # block 0x00437eea: if arg_char == backspace (0x08) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00437eea
    cmp eax, 0x8                                 # 00437eee
    je.d32 L_accept                            # 00437ef1
    # block 0x00437ef7: if arg_char == carriage return (0x0d) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 00437ef7
    cmp ecx, 0xd                                 # 00437efb
    je.d32 L_accept                            # 00437efe
    # block 0x00437f04: if arg_char == space (0x20) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 00437f04
    cmp edx, 0x20                                # 00437f08
    je.d32 L_accept                            # 00437f0b
    # block 0x00437f11: if arg_char == '.' (0x2e) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00437f11
    cmp eax, 0x2e                                # 00437f15
    je.d32 L_accept                            # 00437f18
    # block 0x00437f1e: if arg_char == ',' (0x2c) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 00437f1e
    cmp ecx, 0x2c                                # 00437f22
    je.d32 L_accept                            # 00437f25
    # block 0x00437f2b: if arg_char == '?' (0x3f) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 00437f2b
    cmp edx, 0x3f                                # 00437f2f
    je.d32 L_accept                            # 00437f32
    # block 0x00437f38: if arg_char == '!' (0x21) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00437f38
    cmp eax, 0x21                                # 00437f3c
    je.d32 L_accept                            # 00437f3f
    # block 0x00437f45: if arg_char == '/' (0x2f) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 00437f45
    cmp ecx, 0x2f                                # 00437f49
    je.d32 L_accept                            # 00437f4c
    # block 0x00437f52: if arg_char == '$' (0x24) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 00437f52
    cmp edx, 0x24                                # 00437f56
    je.d32 L_accept                            # 00437f59
    # block 0x00437f5f: if arg_char == '(' (0x28) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00437f5f
    cmp eax, 0x28                                # 00437f63
    je.d32 L_accept                            # 00437f66
    # block 0x00437f6c: if arg_char == ')' (0x29) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 00437f6c
    cmp ecx, 0x29                                # 00437f70
    je.d32 L_accept                            # 00437f73
    # block 0x00437f79: if arg_char == '&' (0x26) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 00437f79
    cmp edx, 0x26                                # 00437f7d
    je.d32 L_accept                            # 00437f80
    # block 0x00437f86: if arg_char == ':' (0x3a) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00437f86
    cmp eax, 0x3a                                # 00437f8a
    je.d32 L_accept                            # 00437f8d
    # block 0x00437f93: if arg_char == ';' (0x3b) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 00437f93
    cmp ecx, 0x3b                                # 00437f97
    je.d32 L_accept                            # 00437f9a
    # block 0x00437fa0: if arg_char == '+' (0x2b) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 00437fa0
    cmp edx, 0x2b                                # 00437fa4
    je.d32 L_accept                            # 00437fa7
    # block 0x00437fad: if arg_char == '%' (0x25) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00437fad
    cmp eax, 0x25                                # 00437fb1
    je.d32 L_accept                            # 00437fb4
    # block 0x00437fba: if arg_char == '=' (0x3d) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 00437fba
    cmp ecx, 0x3d                                # 00437fbe
    je.d32 L_accept                            # 00437fc1
    # block 0x00437fc7: if arg_char == '-' (0x2d) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 00437fc7
    cmp edx, 0x2d                                # 00437fcb
    je.d32 L_accept                            # 00437fce
    # block 0x00437fd4: if signed arg_char == -0x20 (byte 0xe0) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00437fd4
    cmp eax, -0x20                               # 00437fd8
    je.d32 L_accept                            # 00437fdb
    # block 0x00437fe1: if signed arg_char == -0x19 (byte 0xe7) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 00437fe1
    cmp ecx, -0x19                               # 00437fe5
    je.d32 L_accept                            # 00437fe8
    # block 0x00437fee: if signed arg_char == -0x18 (byte 0xe8) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 00437fee
    cmp edx, -0x18                               # 00437ff2
    je.d32 L_accept                            # 00437ff5
    # block 0x00437ffb: if signed arg_char == -0x17 (byte 0xe9) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00437ffb
    cmp eax, -0x17                               # 00437fff
    je.d32 L_accept                            # 00438002
    # block 0x00438008: if signed arg_char == -0x16 (byte 0xea) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 00438008
    cmp ecx, -0x16                               # 0043800c
    je.d32 L_accept                            # 0043800f
    # block 0x00438015: if signed arg_char == -0x15 (byte 0xeb) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 00438015
    cmp edx, -0x15                               # 00438019
    je.d32 L_accept                            # 0043801c
    # block 0x00438022: if signed arg_char == -0xc (byte 0xf4) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00438022
    cmp eax, -0xc                                # 00438026
    je.d32 L_accept                            # 00438029
    # block 0x0043802f: if signed arg_char == -0x40 (byte 0xc0) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 0043802f
    cmp ecx, -0x40                               # 00438033
    je.d32 L_accept                            # 00438036
    # block 0x0043803c: if signed arg_char == -0x1e (byte 0xe2) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 0043803c
    cmp edx, -0x1e                               # 00438040
    je.d32 L_accept                            # 00438043
    # block 0x00438049: if signed arg_char == -0x12 (byte 0xee) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00438049
    cmp eax, -0x12                               # 0043804d
    je.d32 L_accept                            # 00438050
    # block 0x00438056: if signed arg_char == -0x7 (byte 0xf9) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 00438056
    cmp ecx, -0x7                                # 0043805a
    je.d32 L_accept                            # 0043805d
    # block 0x00438063: if signed arg_char == -0x3c (byte 0xc4) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 00438063
    cmp edx, -0x3c                               # 00438067
    je.d32 L_accept                            # 0043806a
    # block 0x00438070: if signed arg_char == -0x1c (byte 0xe4) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00438070
    cmp eax, -0x1c                               # 00438074
    je.d32 L_accept                            # 00438077
    # block 0x0043807d: if signed arg_char == -0x2a (byte 0xd6) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 0043807d
    cmp ecx, -0x2a                               # 00438081
    je.d32 L_accept                            # 00438084
    # block 0x0043808a: if signed arg_char == -0xa (byte 0xf6) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 0043808a
    cmp edx, -0xa                                # 0043808e
    je.d8 L_accept                             # 00438091
    # block 0x00438093: if signed arg_char == -0x24 (byte 0xdc) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 00438093
    cmp eax, -0x24                               # 00438097
    je.d8 L_accept                             # 0043809a
    # block 0x0043809c: if signed arg_char == -0x4 (byte 0xfc) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 0043809c
    cmp ecx, -0x4                                # 004380a0
    je.d8 L_accept                             # 004380a3
    # block 0x004380a5: if signed arg_char == -0x5f (byte 0xa1) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 004380a5
    cmp edx, -0x5f                               # 004380a9
    je.d8 L_accept                             # 004380ac
    # block 0x004380ae: if signed arg_char == -0x41 (byte 0xbf) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 004380ae
    cmp eax, -0x41                               # 004380b2
    je.d8 L_accept                             # 004380b5
    # block 0x004380b7: if signed arg_char == -0x2f (byte 0xd1) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 004380b7
    cmp ecx, -0x2f                               # 004380bb
    je.d8 L_accept                             # 004380be
    # block 0x004380c0: if signed arg_char == -0xf (byte 0xf1) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 004380c0
    cmp edx, -0xf                                # 004380c4
    je.d8 L_accept                             # 004380c7
    # block 0x004380c9: if signed arg_char == -0x37 (byte 0xc9) go to L_accept (je)
    movsx eax, byte ptr [ebp + arg_char]            # 004380c9
    cmp eax, -0x37                               # 004380cd
    je.d8 L_accept                             # 004380d0
    # block 0x004380d2: if signed arg_char == -0x1f (byte 0xe1) go to L_accept (je)
    movsx ecx, byte ptr [ebp + arg_char]            # 004380d2
    cmp ecx, -0x1f                               # 004380d6
    je.d8 L_accept                             # 004380d9
    # block 0x004380db: if signed arg_char == -0x13 (byte 0xed) go to L_accept (je)
    movsx edx, byte ptr [ebp + arg_char]            # 004380db
    cmp edx, -0x13                               # 004380df
    je.d8 L_accept                             # 004380e2
    # block 0x004380e4: two exact codes without a branch between them: ecx = (arg_char == -0xd, byte 0xf3) via sete, eax = (arg_char == -6, byte 0xfa) via sete, or them; if the result is non-zero go to L_accept (jne)
    movsx eax, byte ptr [ebp + arg_char]            # 004380e4
    {load} xor ecx, ecx                          # 004380e8
    cmp eax, -0xd                                # 004380ea
    sete cl                                      # 004380ed
    movsx edx, byte ptr [ebp + arg_char]            # 004380f0
    {load} xor eax, eax                          # 004380f4
    cmp edx, -0x6                                # 004380f6
    sete al                                      # 004380f9
    {load} or ecx, eax                           # 004380fc
    test ecx, ecx                                # 004380fe
    jne.d8 L_accept                            # 00438100
    # block 0x00438102: if arg_char != -0x21 (byte 0xdf) go to L_reject (jne), else fall into L_accept
    movsx ecx, byte ptr [ebp + arg_char]            # 00438102
    cmp ecx, -0x21                               # 00438106
    jne.d8 L_reject                            # 00438109
L_accept:
    # block 0x0043810b: accept (L_accept): eax = 1, go to L_return
    mov eax, 0x1                                 # 0043810b
    jmp.d8 L_return                            # 00438110
L_reject:
    # block 0x00438112: reject (L_reject): eax = 0 (xor eax, eax)
    {load} xor eax, eax                          # 00438112
L_return:
    # block 0x00438114: epilogue (L_return): restore the frame and return, callee pops one argument (ret 4)
    {load} mov esp, ebp                          # 00438114
    pop ebp                                      # 00438116
    ret 0x4                                      # 00438117

# --- data items (not part of the function) -------------------------
.org 0x0043811a - 0x401000
PAD_0043811a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc
