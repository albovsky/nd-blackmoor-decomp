# FUN_004d999b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d999b
# extent:       0x004d999b-0x004d9d29 (910 code bytes)
# span:         0x004d999b-0x004d9d40 (code 910, tables 16, padding 7)
# sha256:       a2dee8df1f9baf72262a59bfe90cdb527db15ce9d8ed634952343be68a55094d
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_load_save_screen_redraw
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4d999b.c.txt, not original source) refers to the data labelled s_LOADSAVE_Cursor_Restoration_0055aaac, s_LOADSAVE_LOAD_Slot_0055ab70, s_LOADSAVE_UP_Button_0055aae8
# name-note:    Redraws the load/save screen: background and cursor restoration, up/down/hilite/disabled buttons and slot images; blit tags with LOADSAVE strings.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 237 instruction(s), 11 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004d999b - 0x401000
.globl FUN_004d999b
FUN_004d999b:
    # block 0x004d999b: entry, 5 instruction(s), ends with je to 0x004d99d5 (forward)
    push ebp                                     # 004d999b
    {load} mov ebp, esp                          # 004d999c
    sub esp, 0x8                                 # 004d999e
    cmp dword ptr [0x5e32bd], 0x0                # 004d99a1
    je.d8 L_004d99d5                             # 004d99a8
    # block 0x004d99aa: entered by fall-through of je at 0x004d99a8, 10 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d9d25
    push 0x55aa68                                # 004d99aa
    push 0x5ec5a4                                # 004d99af
    push 0x5ec594                                # 004d99b4
    mov eax, dword ptr [0x5cf665]                # 004d99b9
    push eax                                     # 004d99be
    mov ecx, dword ptr [0x5ec37a]                # 004d99bf
    push ecx                                     # 004d99c5
    mov ecx, 0x5cf659                            # 004d99c6
    call FUN_004c5377                            # 004d99cb
    jmp.d32 L_004d9d25                           # 004d99d0
L_004d99d5:
    # block 0x004d99d5: entered by je at 0x004d99a8, 2 instruction(s), ends with je to 0x004d9a0e (forward)
    cmp dword ptr [0x5ec3a2], 0x0                # 004d99d5
    je.d8 L_004d9a0e                             # 004d99dc
    # block 0x004d99de: entered by fall-through of je at 0x004d99dc, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x004d9a0e
    push 0x55aa8c                                # 004d99de
    push 0x5ec584                                # 004d99e3
    push 0x5ec574                                # 004d99e8
    mov edx, dword ptr [0x5cf665]                # 004d99ed
    push edx                                     # 004d99f3
    mov eax, dword ptr [0x5ec37e]                # 004d99f4
    push eax                                     # 004d99f9
    mov ecx, 0x5cf659                            # 004d99fa
    call FUN_004c5377                            # 004d99ff
    mov dword ptr [0x5ec3a2], 0x0                # 004d9a04
L_004d9a0e:
    # block 0x004d9a0e: entered by je at 0x004d99dc, 2 instruction(s), ends with je to 0x004d9a48 (forward)
    cmp dword ptr [0x5ec3a6], 0x0                # 004d9a0e
    je.d8 L_004d9a48                             # 004d9a15
    # block 0x004d9a17: entered by fall-through of je at 0x004d9a15, 10 instruction(s), calls FUN_004c5377, falls into the block at 0x004d9a48
    push 0x55aaac                                # 004d9a17
    push 0x5830f2                                # 004d9a1c
    push 0x5830f2                                # 004d9a21
    mov ecx, dword ptr [0x5cf665]                # 004d9a26
    push ecx                                     # 004d9a2c
    mov edx, dword ptr [0x5ec37e]                # 004d9a2d
    push edx                                     # 004d9a33
    mov ecx, 0x5cf659                            # 004d9a34
    call FUN_004c5377                            # 004d9a39
    mov dword ptr [0x5ec3a6], 0x0                # 004d9a3e
L_004d9a48:
    # block 0x004d9a48: entered by je at 0x004d9a15, 2 instruction(s), ends with forward jump to 0x004d9a5a
    mov dword ptr [ebp - local_4], 0x0           # 004d9a48
    jmp.d8 L_004d9a5a                            # 004d9a4f
L_004d9a51:
    # block 0x004d9a51: entered by jmp at 0x004d9ba4, 3 instruction(s), falls into the block at 0x004d9a5a
    mov eax, dword ptr [ebp - local_4]           # 004d9a51
    add eax, 0x1                                 # 004d9a54
    mov dword ptr [ebp - local_4], eax           # 004d9a57
L_004d9a5a:
    # block 0x004d9a5a: entered by jmp at 0x004d9a4f, 2 instruction(s), ends with jge to 0x004d9ba9 (forward)
    cmp dword ptr [ebp - local_4], 0x5           # 004d9a5a
    jge.d32 L_004d9ba9                           # 004d9a5e
    # block 0x004d9a64: entered by fall-through of jge at 0x004d9a5e, 8 instruction(s), ends with ja to 0x004d9a8a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d9a64
    mov edx, dword ptr [4*ecx + 0x5ec3de]        # 004d9a67
    mov dword ptr [ebp - local_8], edx           # 004d9a6e
    mov eax, dword ptr [ebp - local_8]           # 004d9a71
    sub eax, 0x1                                 # 004d9a74
    mov dword ptr [ebp - local_8], eax           # 004d9a77
    cmp dword ptr [ebp - local_8], 0x3           # 004d9a7a
    ja.d8 L_004d9a8a                             # 004d9a7e
    # block 0x004d9a80: entered by fall-through of ja at 0x004d9a7e, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4d9d29]
    mov ecx, dword ptr [ebp - local_8]           # 004d9a80
    jmp dword ptr [4*ecx + SWTAB_004d9d29_VA]    # 004d9a83
L_004d9a8a:
    # block 0x004d9a8a: entered by ja at 0x004d9a7e, 16 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d9ba4
    push 0x55aac8                                # 004d9a8a
    mov edx, dword ptr [ebp - local_4]           # 004d9a8f
    shl edx, 0x4                                 # 004d9a92
    add edx, 0x5e301b                            # 004d9a95
    push edx                                     # 004d9a9b
    mov eax, dword ptr [ebp - local_4]           # 004d9a9c
    shl eax, 0x4                                 # 004d9a9f
    add eax, 0x5e301b                            # 004d9aa2
    push eax                                     # 004d9aa7
    mov ecx, dword ptr [0x5cf665]                # 004d9aa8
    push ecx                                     # 004d9aae
    mov edx, dword ptr [0x5ec37e]                # 004d9aaf
    push edx                                     # 004d9ab5
    mov ecx, 0x5cf659                            # 004d9ab6
    call FUN_004c5377                            # 004d9abb
    jmp.d32 L_004d9ba4                           # 004d9ac0
L_004d9ac5:
    # block 0x004d9ac5: entered by switch case, 16 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d9ba4
    push 0x55aae8                                # 004d9ac5
    mov eax, dword ptr [ebp - local_4]           # 004d9aca
    shl eax, 0x4                                 # 004d9acd
    add eax, 0x5e301b                            # 004d9ad0
    push eax                                     # 004d9ad5
    mov ecx, dword ptr [ebp - local_4]           # 004d9ad6
    shl ecx, 0x4                                 # 004d9ad9
    add ecx, 0x5e2edb                            # 004d9adc
    push ecx                                     # 004d9ae2
    mov edx, dword ptr [0x5cf665]                # 004d9ae3
    push edx                                     # 004d9ae9
    mov eax, dword ptr [0x5ec34e]                # 004d9aea
    push eax                                     # 004d9aef
    mov ecx, 0x5cf659                            # 004d9af0
    call FUN_004c5377                            # 004d9af5
    jmp.d32 L_004d9ba4                           # 004d9afa
L_004d9aff:
    # block 0x004d9aff: entered by switch case, 16 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d9ba4
    push 0x55aafc                                # 004d9aff
    mov ecx, dword ptr [ebp - local_4]           # 004d9b04
    shl ecx, 0x4                                 # 004d9b07
    add ecx, 0x5e301b                            # 004d9b0a
    push ecx                                     # 004d9b10
    mov edx, dword ptr [ebp - local_4]           # 004d9b11
    shl edx, 0x4                                 # 004d9b14
    add edx, 0x5e2f2b                            # 004d9b17
    push edx                                     # 004d9b1d
    mov eax, dword ptr [0x5cf665]                # 004d9b1e
    push eax                                     # 004d9b23
    mov ecx, dword ptr [0x5ec34e]                # 004d9b24
    push ecx                                     # 004d9b2a
    mov ecx, 0x5cf659                            # 004d9b2b
    call FUN_004c5377                            # 004d9b30
    jmp.d8 L_004d9ba4                            # 004d9b35
L_004d9b37:
    # block 0x004d9b37: entered by switch case, 16 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004d9ba4
    push 0x55ab14                                # 004d9b37
    mov edx, dword ptr [ebp - local_4]           # 004d9b3c
    shl edx, 0x4                                 # 004d9b3f
    add edx, 0x5e301b                            # 004d9b42
    push edx                                     # 004d9b48
    mov eax, dword ptr [ebp - local_4]           # 004d9b49
    shl eax, 0x4                                 # 004d9b4c
    add eax, 0x5e2f7b                            # 004d9b4f
    push eax                                     # 004d9b54
    mov ecx, dword ptr [0x5cf665]                # 004d9b55
    push ecx                                     # 004d9b5b
    mov edx, dword ptr [0x5ec34e]                # 004d9b5c
    push edx                                     # 004d9b62
    mov ecx, 0x5cf659                            # 004d9b63
    call FUN_004c5377                            # 004d9b68
    jmp.d8 L_004d9ba4                            # 004d9b6d
L_004d9b6f:
    # block 0x004d9b6f: entered by switch case, 15 instruction(s), calls FUN_004c5377, falls into the block at 0x004d9ba4
    push 0x55ab2c                                # 004d9b6f
    mov eax, dword ptr [ebp - local_4]           # 004d9b74
    shl eax, 0x4                                 # 004d9b77
    add eax, 0x5e301b                            # 004d9b7a
    push eax                                     # 004d9b7f
    mov ecx, dword ptr [ebp - local_4]           # 004d9b80
    shl ecx, 0x4                                 # 004d9b83
    add ecx, 0x5e2fcb                            # 004d9b86
    push ecx                                     # 004d9b8c
    mov edx, dword ptr [0x5cf665]                # 004d9b8d
    push edx                                     # 004d9b93
    mov eax, dword ptr [0x5ec34e]                # 004d9b94
    push eax                                     # 004d9b99
    mov ecx, 0x5cf659                            # 004d9b9a
    call FUN_004c5377                            # 004d9b9f
L_004d9ba4:
    # block 0x004d9ba4: entered by jmp at 0x004d9ac0; jmp at 0x004d9afa; jmp at 0x004d9b35; jmp at 0x004d9b6d, 1 instruction(s), ends with backward jump to 0x004d9a51
    jmp.d32 L_004d9a51                           # 004d9ba4
L_004d9ba9:
    # block 0x004d9ba9: entered by jge at 0x004d9a5e, 2 instruction(s), ends with jne to 0x004d9c58 (forward)
    cmp dword ptr [0x5ec3ca], 0x0                # 004d9ba9
    jne.d32 L_004d9c58                           # 004d9bb0
    # block 0x004d9bb6: entered by fall-through of jne at 0x004d9bb0, 2 instruction(s), ends with forward jump to 0x004d9bc8
    mov dword ptr [ebp - local_4], 0x1           # 004d9bb6
    jmp.d8 L_004d9bc8                            # 004d9bbd
L_004d9bbf:
    # block 0x004d9bbf: entered by jmp at 0x004d9c4e, 3 instruction(s), falls into the block at 0x004d9bc8
    mov ecx, dword ptr [ebp - local_4]           # 004d9bbf
    add ecx, 0x1                                 # 004d9bc2
    mov dword ptr [ebp - local_4], ecx           # 004d9bc5
L_004d9bc8:
    # block 0x004d9bc8: entered by jmp at 0x004d9bbd, 2 instruction(s), ends with jg to 0x004d9c53 (forward)
    cmp dword ptr [ebp - local_4], 0x9           # 004d9bc8
    jg.d32 L_004d9c53                            # 004d9bcc
    # block 0x004d9bd2: entered by fall-through of jg at 0x004d9bcc, 3 instruction(s), ends with je to 0x004d9c4e (forward)
    mov edx, dword ptr [ebp - local_4]           # 004d9bd2
    cmp dword ptr [4*edx + 0x5ec3f2], 0x0        # 004d9bd5
    je.d8 L_004d9c4e                             # 004d9bdd
    # block 0x004d9bdf: entered by fall-through of je at 0x004d9bdd, 31 instruction(s), calls FUN_004c5377, FUN_004c5d4b, falls into the block at 0x004d9c4e
    push 0x55ab48                                # 004d9bdf
    mov eax, dword ptr [ebp - local_4]           # 004d9be4
    shl eax, 0x4                                 # 004d9be7
    add eax, 0x5e306b                            # 004d9bea
    push eax                                     # 004d9bef
    mov ecx, dword ptr [ebp - local_4]           # 004d9bf0
    shl ecx, 0x4                                 # 004d9bf3
    add ecx, 0x5e306b                            # 004d9bf6
    push ecx                                     # 004d9bfc
    mov edx, dword ptr [0x5cf665]                # 004d9bfd
    push edx                                     # 004d9c03
    mov eax, dword ptr [0x5ec37e]                # 004d9c04
    push eax                                     # 004d9c09
    mov ecx, 0x5cf659                            # 004d9c0a
    call FUN_004c5377                            # 004d9c0f
    push 0x55ab70                                # 004d9c14
    mov ecx, dword ptr [ebp - local_4]           # 004d9c19
    shl ecx, 0x4                                 # 004d9c1c
    add ecx, 0x5e306b                            # 004d9c1f
    push ecx                                     # 004d9c25
    mov edx, dword ptr [ebp - local_4]           # 004d9c26
    shl edx, 0x4                                 # 004d9c29
    add edx, 0x5ec5c4                            # 004d9c2c
    push edx                                     # 004d9c32
    mov eax, dword ptr [0x5cf665]                # 004d9c33
    push eax                                     # 004d9c38
    mov ecx, dword ptr [ebp - local_4]           # 004d9c39
    mov edx, dword ptr [4*ecx + 0x5ec352]        # 004d9c3c
    push edx                                     # 004d9c43
    mov ecx, 0x5cf659                            # 004d9c44
    call FUN_004c5d4b                            # 004d9c49
L_004d9c4e:
    # block 0x004d9c4e: entered by je at 0x004d9bdd, 1 instruction(s), ends with backward jump to 0x004d9bbf
    jmp.d32 L_004d9bbf                           # 004d9c4e
L_004d9c53:
    # block 0x004d9c53: entered by jg at 0x004d9bcc, 1 instruction(s), ends with forward jump to 0x004d9cf6
    jmp.d32 L_004d9cf6                           # 004d9c53
L_004d9c58:
    # block 0x004d9c58: entered by jne at 0x004d9bb0, 2 instruction(s), ends with forward jump to 0x004d9c6a
    mov dword ptr [ebp - local_4], 0x0           # 004d9c58
    jmp.d8 L_004d9c6a                            # 004d9c5f
L_004d9c61:
    # block 0x004d9c61: entered by jmp at 0x004d9cf1, 3 instruction(s), falls into the block at 0x004d9c6a
    mov eax, dword ptr [ebp - local_4]           # 004d9c61
    add eax, 0x1                                 # 004d9c64
    mov dword ptr [ebp - local_4], eax           # 004d9c67
L_004d9c6a:
    # block 0x004d9c6a: entered by jmp at 0x004d9c5f, 2 instruction(s), ends with jg to 0x004d9cf6 (forward)
    cmp dword ptr [ebp - local_4], 0x8           # 004d9c6a
    jg.d32 L_004d9cf6                            # 004d9c6e
    # block 0x004d9c74: entered by fall-through of jg at 0x004d9c6e, 3 instruction(s), ends with je to 0x004d9cf1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004d9c74
    cmp dword ptr [4*ecx + 0x5ec3f2], 0x0        # 004d9c77
    je.d8 L_004d9cf1                             # 004d9c7f
    # block 0x004d9c81: entered by fall-through of je at 0x004d9c7f, 31 instruction(s), calls FUN_004c5377, FUN_004c5d4b, falls into the block at 0x004d9cf1
    push 0x55ab84                                # 004d9c81
    mov edx, dword ptr [ebp - local_4]           # 004d9c86
    shl edx, 0x4                                 # 004d9c89
    add edx, 0x5e306b                            # 004d9c8c
    push edx                                     # 004d9c92
    mov eax, dword ptr [ebp - local_4]           # 004d9c93
    shl eax, 0x4                                 # 004d9c96
    add eax, 0x5e306b                            # 004d9c99
    push eax                                     # 004d9c9e
    mov ecx, dword ptr [0x5cf665]                # 004d9c9f
    push ecx                                     # 004d9ca5
    mov edx, dword ptr [0x5ec37e]                # 004d9ca6
    push edx                                     # 004d9cac
    mov ecx, 0x5cf659                            # 004d9cad
    call FUN_004c5377                            # 004d9cb2
    push 0x55abac                                # 004d9cb7
    mov eax, dword ptr [ebp - local_4]           # 004d9cbc
    shl eax, 0x4                                 # 004d9cbf
    add eax, 0x5e306b                            # 004d9cc2
    push eax                                     # 004d9cc7
    mov ecx, dword ptr [ebp - local_4]           # 004d9cc8
    shl ecx, 0x4                                 # 004d9ccb
    add ecx, 0x5ec5c4                            # 004d9cce
    push ecx                                     # 004d9cd4
    mov edx, dword ptr [0x5cf665]                # 004d9cd5
    push edx                                     # 004d9cdb
    mov eax, dword ptr [ebp - local_4]           # 004d9cdc
    mov ecx, dword ptr [4*eax + 0x5ec352]        # 004d9cdf
    push ecx                                     # 004d9ce6
    mov ecx, 0x5cf659                            # 004d9ce7
    call FUN_004c5d4b                            # 004d9cec
L_004d9cf1:
    # block 0x004d9cf1: entered by je at 0x004d9c7f, 1 instruction(s), ends with backward jump to 0x004d9c61
    jmp.d32 L_004d9c61                           # 004d9cf1
L_004d9cf6:
    # block 0x004d9cf6: entered by jmp at 0x004d9c53; jg at 0x004d9c6e, 2 instruction(s), ends with je to 0x004d9d25 (forward)
    cmp dword ptr [0x5ec3aa], 0x0                # 004d9cf6
    je.d8 L_004d9d25                             # 004d9cfd
    # block 0x004d9cff: entered by fall-through of je at 0x004d9cfd, 9 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004d9d25
    push 0x55abc0                                # 004d9cff
    push 0x583102                                # 004d9d04
    push 0x5ec564                                # 004d9d09
    mov edx, dword ptr [0x5cf665]                # 004d9d0e
    push edx                                     # 004d9d14
    mov eax, dword ptr [0x5d0377]                # 004d9d15
    push eax                                     # 004d9d1a
    mov ecx, 0x5cf659                            # 004d9d1b
    call FUN_004c5d4b                            # 004d9d20
L_004d9d25:
    # block 0x004d9d25: entered by jmp at 0x004d99d0; je at 0x004d9cfd, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d9d25
    pop ebp                                      # 004d9d27
    ret                                          # 004d9d28

# --- data items (not part of the function) -------------------------
.org 0x004d9d29 - 0x401000
SWTAB_004d9d29:  # 4 case address(es)
    .long L_004d9ac5 - .text + 0x401000
    .long L_004d9aff - .text + 0x401000
    .long L_004d9b37 - .text + 0x401000
    .long L_004d9b6f - .text + 0x401000
.org 0x004d9d39 - 0x401000
PAD_004d9d39:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc
.set SWTAB_004d9d29_VA, SWTAB_004d9d29 - .text + 0x401000

