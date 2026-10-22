# FUN_00457bd8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00457bd8
# extent:       0x00457bd8-0x00457e58 (640 code bytes)
# span:         0x00457bd8-0x00457e60 (code 640, tables 0, padding 8)
# sha256:       5675c484db9064ed6b22c62baefa0013a5bef597bd5e121208c90b6e70a522be
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_bball_puzzle_ui_renderer
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/457bd8.c.txt, not original source) refers to the data labelled s_Bball_Button_down___button_resto_0054a548, s_Bball__restore_thrower_in_closes_0054a434
# name-note:    Draws or restores the Bball thrower position, power and angle slider elements and the button down/restore image through FUN_004c5377.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_8, local_18
# fields:       [eax + n] field_c7, field_177; [ecx + n] field_37, field_127; [edx + n] field_37, field_f7
# callees:      calls FUN_00457071, FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 177 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_18, 0x18  # offset -0x18
.equ field_37, 0x37  # offset +0x37
.equ field_c7, 0xc7  # offset +0xc7
.equ field_f7, 0xf7  # offset +0xf7
.equ field_127, 0x127  # offset +0x127
.equ field_177, 0x177  # offset +0x177

# --- external targets -----------------------------------------------
.set FUN_00457071, .text + (0x00457071 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x00457bd8 - 0x401000
.globl FUN_00457bd8
FUN_00457bd8:
    # block 0x00457bd8: entry, 17 instruction(s), calls FUN_00457071, ends with jne to 0x00457c3e (forward)
    push ebp                                     # 00457bd8
    {load} mov ebp, esp                          # 00457bd9
    sub esp, 0x18                                # 00457bdb
    movsx eax, word ptr [0x62490b]               # 00457bde
    imul eax, eax, 0x8d                          # 00457be5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00457beb
    mov dword ptr [ebp - local_4], ecx           # 00457bf1
    lea edx, [ebp - local_18]                    # 00457bf4
    push edx                                     # 00457bf7
    mov eax, dword ptr [ebp - local_4]           # 00457bf8
    add eax, 0x67                                # 00457bfb
    push eax                                     # 00457bfe
    mov ecx, 0x6248ed                            # 00457bff
    call FUN_00457071                            # 00457c04
    movsx ecx, word ptr [0x5957c3]               # 00457c09
    test ecx, ecx                                # 00457c10
    jne.d8 L_00457c3e                            # 00457c12
    # block 0x00457c14: entered by fall-through of jne at 0x00457c12, 13 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00457c81
    push 0x54a434                                # 00457c14
    lea edx, [ebp - local_18]                    # 00457c19
    push edx                                     # 00457c1c
    mov eax, dword ptr [ebp - local_4]           # 00457c1d
    add eax, 0x67                                # 00457c20
    push eax                                     # 00457c23
    mov ecx, dword ptr [0x5cf665]                # 00457c24
    push ecx                                     # 00457c2a
    mov edx, dword ptr [0x5d15e3]                # 00457c2b
    push edx                                     # 00457c31
    mov ecx, 0x5cf659                            # 00457c32
    call FUN_004c5377                            # 00457c37
    jmp.d8 L_00457c81                            # 00457c3c
L_00457c3e:
    # block 0x00457c3e: entered by jne at 0x00457c12, 17 instruction(s), calls FUN_004c5377, falls into the block at 0x00457c81
    push 0x54a460                                # 00457c3e
    lea eax, [ebp - local_18]                    # 00457c43
    push eax                                     # 00457c46
    movsx ecx, word ptr [0x5957c3]               # 00457c47
    sub ecx, 0x1                                 # 00457c4e
    shl ecx, 0x4                                 # 00457c51
    mov edx, dword ptr [ebp - local_4]           # 00457c54
    lea eax, [edx + ecx + field_f7]              # 00457c57
    push eax                                     # 00457c5e
    mov ecx, dword ptr [0x5cf665]                # 00457c5f
    push ecx                                     # 00457c65
    movsx edx, word ptr [0x624909]               # 00457c66
    imul edx, edx, 0x4a                          # 00457c6d
    mov eax, dword ptr [edx + 0x5d1599]          # 00457c70
    push eax                                     # 00457c76
    mov ecx, 0x5cf659                            # 00457c77
    call FUN_004c5377                            # 00457c7c
L_00457c81:
    # block 0x00457c81: entered by jmp at 0x00457c3c, 10 instruction(s), calls FUN_00457071, ends with jne to 0x00457cca (forward)
    lea ecx, [ebp - local_18]                    # 00457c81
    push ecx                                     # 00457c84
    mov edx, dword ptr [ebp - local_4]           # 00457c85
    add edx, 0x77                                # 00457c88
    push edx                                     # 00457c8b
    mov ecx, 0x6248ed                            # 00457c8c
    call FUN_00457071                            # 00457c91
    movsx eax, word ptr [0x624915]               # 00457c96
    test eax, eax                                # 00457c9d
    jne.d8 L_00457cca                            # 00457c9f
    # block 0x00457ca1: entered by fall-through of jne at 0x00457c9f, 13 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00457d0c
    push 0x54a484                                # 00457ca1
    lea ecx, [ebp - local_18]                    # 00457ca6
    push ecx                                     # 00457ca9
    mov edx, dword ptr [ebp - local_4]           # 00457caa
    add edx, 0x77                                # 00457cad
    push edx                                     # 00457cb0
    mov eax, dword ptr [0x5cf665]                # 00457cb1
    push eax                                     # 00457cb6
    mov ecx, dword ptr [0x5d15e3]                # 00457cb7
    push ecx                                     # 00457cbd
    mov ecx, 0x5cf659                            # 00457cbe
    call FUN_004c5377                            # 00457cc3
    jmp.d8 L_00457d0c                            # 00457cc8
L_00457cca:
    # block 0x00457cca: entered by jne at 0x00457c9f, 17 instruction(s), calls FUN_004c5377, falls into the block at 0x00457d0c
    push 0x54a4ac                                # 00457cca
    lea edx, [ebp - local_18]                    # 00457ccf
    push edx                                     # 00457cd2
    movsx eax, word ptr [0x624915]               # 00457cd3
    sub eax, 0x1                                 # 00457cda
    shl eax, 0x4                                 # 00457cdd
    mov ecx, dword ptr [ebp - local_4]           # 00457ce0
    lea edx, [ecx + eax + field_127]             # 00457ce3
    push edx                                     # 00457cea
    mov eax, dword ptr [0x5cf665]                # 00457ceb
    push eax                                     # 00457cf0
    movsx ecx, word ptr [0x624909]               # 00457cf1
    imul ecx, ecx, 0x4a                          # 00457cf8
    mov edx, dword ptr [ecx + 0x5d1599]          # 00457cfb
    push edx                                     # 00457d01
    mov ecx, 0x5cf659                            # 00457d02
    call FUN_004c5377                            # 00457d07
L_00457d0c:
    # block 0x00457d0c: entered by jmp at 0x00457cc8, 10 instruction(s), calls FUN_00457071, ends with jne to 0x00457d5b (forward)
    lea eax, [ebp - local_18]                    # 00457d0c
    push eax                                     # 00457d0f
    mov ecx, dword ptr [ebp - local_4]           # 00457d10
    add ecx, 0x87                                # 00457d13
    push ecx                                     # 00457d19
    mov ecx, 0x6248ed                            # 00457d1a
    call FUN_00457071                            # 00457d1f
    movsx edx, word ptr [0x624917]               # 00457d24
    test edx, edx                                # 00457d2b
    jne.d8 L_00457d5b                            # 00457d2d
    # block 0x00457d2f: entered by fall-through of jne at 0x00457d2d, 13 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00457d9e
    push 0x54a4d0                                # 00457d2f
    lea eax, [ebp - local_18]                    # 00457d34
    push eax                                     # 00457d37
    mov ecx, dword ptr [ebp - local_4]           # 00457d38
    add ecx, 0x87                                # 00457d3b
    push ecx                                     # 00457d41
    mov edx, dword ptr [0x5cf665]                # 00457d42
    push edx                                     # 00457d48
    mov eax, dword ptr [0x5d15e3]                # 00457d49
    push eax                                     # 00457d4e
    mov ecx, 0x5cf659                            # 00457d4f
    call FUN_004c5377                            # 00457d54
    jmp.d8 L_00457d9e                            # 00457d59
L_00457d5b:
    # block 0x00457d5b: entered by jne at 0x00457d2d, 17 instruction(s), calls FUN_004c5377, falls into the block at 0x00457d9e
    push 0x54a4f4                                # 00457d5b
    lea ecx, [ebp - local_18]                    # 00457d60
    push ecx                                     # 00457d63
    movsx edx, word ptr [0x624917]               # 00457d64
    sub edx, 0x1                                 # 00457d6b
    shl edx, 0x4                                 # 00457d6e
    mov eax, dword ptr [ebp - local_4]           # 00457d71
    lea ecx, [eax + edx + field_177]             # 00457d74
    push ecx                                     # 00457d7b
    mov edx, dword ptr [0x5cf665]                # 00457d7c
    push edx                                     # 00457d82
    movsx eax, word ptr [0x624909]               # 00457d83
    imul eax, eax, 0x4a                          # 00457d8a
    mov ecx, dword ptr [eax + 0x5d1599]          # 00457d8d
    push ecx                                     # 00457d93
    mov ecx, 0x5cf659                            # 00457d94
    call FUN_004c5377                            # 00457d99
L_00457d9e:
    # block 0x00457d9e: entered by jmp at 0x00457d59, 2 instruction(s), ends with je to 0x00457e54 (forward)
    cmp dword ptr [0x624919], 0x0                # 00457d9e
    je.d32 L_00457e54                            # 00457da5
    # block 0x00457dab: entered by fall-through of je at 0x00457da5, 13 instruction(s), calls FUN_00457071, ends with je to 0x00457e1b (forward)
    mov dx, word ptr [0x62491d]                  # 00457dab
    mov word ptr [ebp - local_8], dx             # 00457db2
    lea eax, [ebp - local_18]                    # 00457db6
    push eax                                     # 00457db9
    movsx ecx, word ptr [ebp - local_8]          # 00457dba
    shl ecx, 0x4                                 # 00457dbe
    mov edx, dword ptr [ebp - local_4]           # 00457dc1
    lea eax, [edx + ecx + field_37]              # 00457dc4
    push eax                                     # 00457dc8
    mov ecx, 0x6248ed                            # 00457dc9
    call FUN_00457071                            # 00457dce
    cmp dword ptr [0x624923], 0x0                # 00457dd3
    je.d8 L_00457e1b                             # 00457dda
    # block 0x00457ddc: entered by fall-through of je at 0x00457dda, 17 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x00457e54
    push 0x54a518                                # 00457ddc
    lea ecx, [ebp - local_18]                    # 00457de1
    push ecx                                     # 00457de4
    movsx edx, word ptr [ebp - local_8]          # 00457de5
    shl edx, 0x4                                 # 00457de9
    mov eax, dword ptr [ebp - local_4]           # 00457dec
    lea ecx, [eax + edx + field_c7]              # 00457def
    push ecx                                     # 00457df6
    mov edx, dword ptr [0x5cf665]                # 00457df7
    push edx                                     # 00457dfd
    movsx eax, word ptr [0x624909]               # 00457dfe
    imul eax, eax, 0x4a                          # 00457e05
    mov ecx, dword ptr [eax + 0x5d1599]          # 00457e08
    push ecx                                     # 00457e0e
    mov ecx, 0x5cf659                            # 00457e0f
    call FUN_004c5d4b                            # 00457e14
    jmp.d8 L_00457e54                            # 00457e19
L_00457e1b:
    # block 0x00457e1b: entered by je at 0x00457dda, 15 instruction(s), calls FUN_004c5377, falls into the block at 0x00457e54
    push 0x54a548                                # 00457e1b
    lea edx, [ebp - local_18]                    # 00457e20
    push edx                                     # 00457e23
    movsx eax, word ptr [ebp - local_8]          # 00457e24
    shl eax, 0x4                                 # 00457e28
    mov ecx, dword ptr [ebp - local_4]           # 00457e2b
    lea edx, [ecx + eax + field_37]              # 00457e2e
    push edx                                     # 00457e32
    mov eax, dword ptr [0x5cf665]                # 00457e33
    push eax                                     # 00457e38
    mov ecx, dword ptr [0x5d15e3]                # 00457e39
    push ecx                                     # 00457e3f
    mov ecx, 0x5cf659                            # 00457e40
    call FUN_004c5377                            # 00457e45
    mov dword ptr [0x624919], 0x0                # 00457e4a
L_00457e54:
    # block 0x00457e54: entered by je at 0x00457da5; jmp at 0x00457e19, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00457e54
    pop ebp                                      # 00457e56
    ret                                          # 00457e57

# --- data items (not part of the function) -------------------------
.org 0x00457e58 - 0x401000
PAD_00457e58:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc

