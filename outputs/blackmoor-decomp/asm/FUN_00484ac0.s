# FUN_00484ac0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00484ac0
# extent:       0x00484ac0-0x00484caf (495 code bytes)
# span:         0x00484ac0-0x00484caf (code 495, tables 0, padding 0)
# sha256:       d4cadc5e8a635142bbb45e5c8cf6b3d41e61b5bb3668796faec47b365653a004
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m484ac0_latch_hit
# naming:       native port src/original_methods_fl30a.c:m484ac0_latch_hit (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Latches the hit index (stored word or 0x4846c2 answer), stores the two word offsets at +0xbc5/+0xbc7, calls 0x4853b0/0x485f12/0x484935; all instructions and jump directions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_25, field_26, field_32, field_36, field_a92, field_a9e, field_ba7, field_bc5, field_bc7; [ecx + n] field_24, field_a92, field_a9e, field_bac, field_bc7, field_bf9; [edx + n] field_26, field_36, field_a9e, field_bb0, field_bc5; [esi + n] field_2a, field_2e
# callees:      calls FUN_004853b0, FUN_004846c2, FUN_00485f12, FUN_00484935
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30a.c:m484ac0_latch_hit (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 121 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_26, 0x26  # offset +0x26
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_a92, 0xa92  # offset +0xa92
.equ field_a9e, 0xa9e  # offset +0xa9e
.equ field_ba7, 0xba7  # offset +0xba7
.equ field_bac, 0xbac  # offset +0xbac
.equ field_bb0, 0xbb0  # offset +0xbb0
.equ field_bc5, 0xbc5  # offset +0xbc5
.equ field_bc7, 0xbc7  # offset +0xbc7
.equ field_bf9, 0xbf9  # offset +0xbf9

# --- external targets -----------------------------------------------
.set FUN_004846c2, .text + (0x004846c2 - 0x401000)
.set FUN_00484935, .text + (0x00484935 - 0x401000)
.set FUN_004853b0, .text + (0x004853b0 - 0x401000)
.set FUN_00485f12, .text + (0x00485f12 - 0x401000)

.org 0x00484ac0 - 0x401000
.globl FUN_00484ac0
FUN_00484ac0:
    # block 0x00484ac0: entry, 13 instruction(s), ends with je to 0x00484caa (forward)
    push ebp                                     # 00484ac0
    {load} mov ebp, esp                          # 00484ac1
    sub esp, 0xc                                 # 00484ac3
    push esi                                     # 00484ac6
    mov dword ptr [ebp - local_c], ecx           # 00484ac7
    mov eax, dword ptr [ebp - local_c]           # 00484aca
    movsx ecx, word ptr [eax + field_26]         # 00484acd
    imul ecx, ecx, 0x8d                          # 00484ad1
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00484ad7
    mov dword ptr [ebp - local_8], edx           # 00484add
    mov eax, dword ptr [ebp - local_c]           # 00484ae0
    cmp dword ptr [eax + field_ba7], 0x0         # 00484ae3
    je.d32 L_00484caa                            # 00484aea
    # block 0x00484af0: entered by fall-through of je at 0x00484aea, 5 instruction(s), ends with je to 0x00484caa (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00484af0
    {load} xor edx, edx                          # 00484af3
    mov dl, byte ptr [ecx + field_24]            # 00484af5
    test edx, edx                                # 00484af8
    je.d32 L_00484caa                            # 00484afa
    # block 0x00484b00: entered by fall-through of je at 0x00484afa, 5 instruction(s), ends with jne to 0x00484caa (forward)
    mov eax, dword ptr [ebp - local_8]           # 00484b00
    {load} xor ecx, ecx                          # 00484b03
    mov cl, byte ptr [eax + field_25]            # 00484b05
    test ecx, ecx                                # 00484b08
    jne.d32 L_00484caa                           # 00484b0a
    # block 0x00484b10: entered by fall-through of jne at 0x00484b0a, 5 instruction(s), ends with jne to 0x00484caa (forward)
    mov edx, dword ptr [ebp - local_c]           # 00484b10
    {load} xor eax, eax                          # 00484b13
    mov al, byte ptr [edx + field_bb0]           # 00484b15
    test eax, eax                                # 00484b1b
    jne.d32 L_00484caa                           # 00484b1d
    # block 0x00484b23: entered by fall-through of jne at 0x00484b1d, 3 instruction(s), ends with jne to 0x00484caa (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00484b23
    cmp dword ptr [ecx + field_bac], 0x0         # 00484b26
    jne.d32 L_00484caa                           # 00484b2d
    # block 0x00484b33: entered by fall-through of jne at 0x00484b2d, 5 instruction(s), ends with jne to 0x00484caa (forward)
    mov edx, dword ptr [ebp - local_c]           # 00484b33
    movsx eax, word ptr [edx + field_26]         # 00484b36
    imul eax, eax, 0x8d                          # 00484b3a
    cmp dword ptr [eax + 0x5bb632], 0x1          # 00484b40
    jne.d32 L_00484caa                           # 00484b47
    # block 0x00484b4d: entered by fall-through of jne at 0x00484b47, 4 instruction(s), ends with je to 0x00484caa (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00484b4d
    movsx edx, word ptr [ecx + field_bf9]        # 00484b50
    test edx, edx                                # 00484b57
    je.d32 L_00484caa                            # 00484b59
    # block 0x00484b5f: entered by fall-through of je at 0x00484b59, 3 instruction(s), ends with je to 0x00484be3 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00484b5f
    cmp dword ptr [eax + field_a92], 0x0         # 00484b62
    je.d8 L_00484be3                             # 00484b69
    # block 0x00484b6b: entered by fall-through of je at 0x00484b69, 28 instruction(s), calls FUN_004853b0, ends with forward jump to 0x00484c95
    mov ecx, dword ptr [ebp - local_c]           # 00484b6b
    mov dx, word ptr [ecx + field_a9e]           # 00484b6e
    mov word ptr [ebp - local_4], dx             # 00484b75
    mov ax, word ptr [ebp - local_4]             # 00484b79
    push eax                                     # 00484b7d
    mov ecx, dword ptr [ebp - local_c]           # 00484b7e
    call FUN_004853b0                            # 00484b81
    movsx ecx, word ptr [ebp - local_4]          # 00484b86
    imul ecx, ecx, 0x85                          # 00484b8a
    movsx edx, word ptr [ebp - local_4]          # 00484b90
    imul edx, edx, 0x85                          # 00484b94
    mov eax, dword ptr [ebp - local_c]           # 00484b9a
    mov esi, dword ptr [ebp - local_c]           # 00484b9d
    mov ecx, dword ptr [eax + ecx + field_32]    # 00484ba0
    sub ecx, dword ptr [esi + edx + field_2a]    # 00484ba4
    mov edx, dword ptr [ebp - local_c]           # 00484ba8
    mov word ptr [edx + field_bc5], cx           # 00484bab
    movsx eax, word ptr [ebp - local_4]          # 00484bb2
    imul eax, eax, 0x85                          # 00484bb6
    movsx ecx, word ptr [ebp - local_4]          # 00484bbc
    imul ecx, ecx, 0x85                          # 00484bc0
    mov edx, dword ptr [ebp - local_c]           # 00484bc6
    mov esi, dword ptr [ebp - local_c]           # 00484bc9
    mov eax, dword ptr [edx + eax + field_36]    # 00484bcc
    sub eax, dword ptr [esi + ecx + field_2e]    # 00484bd0
    mov ecx, dword ptr [ebp - local_c]           # 00484bd4
    mov word ptr [ecx + field_bc7], ax           # 00484bd7
    jmp.d32 L_00484c95                           # 00484bde
L_00484be3:
    # block 0x00484be3: entered by je at 0x00484b69, 6 instruction(s), calls FUN_004846c2, ends with jne to 0x00484bfd (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00484be3
    call FUN_004846c2                            # 00484be6
    mov word ptr [ebp - local_4], ax             # 00484beb
    movsx edx, word ptr [ebp - local_4]          # 00484bef
    cmp edx, -0x1                                # 00484bf3
    jne.d8 L_00484bfd                            # 00484bf6
    # block 0x00484bf8: entered by fall-through of jne at 0x00484bf6, 1 instruction(s), ends with forward jump to 0x00484caa
    jmp.d32 L_00484caa                           # 00484bf8
L_00484bfd:
    # block 0x00484bfd: entered by jne at 0x00484bf6, 33 instruction(s), calls FUN_004853b0, falls into the block at 0x00484c95
    mov ax, word ptr [ebp - local_4]             # 00484bfd
    push eax                                     # 00484c01
    mov ecx, dword ptr [ebp - local_c]           # 00484c02
    call FUN_004853b0                            # 00484c05
    mov ecx, dword ptr [ebp - local_c]           # 00484c0a
    mov dword ptr [ecx + field_a92], 0x1         # 00484c0d
    mov edx, dword ptr [ebp - local_c]           # 00484c17
    mov ax, word ptr [ebp - local_4]             # 00484c1a
    mov word ptr [edx + field_a9e], ax           # 00484c1e
    mov ecx, dword ptr [ebp - local_c]           # 00484c25
    movsx edx, word ptr [ecx + field_a9e]        # 00484c28
    imul edx, edx, 0x85                          # 00484c2f
    mov eax, dword ptr [ebp - local_c]           # 00484c35
    movsx ecx, word ptr [eax + field_a9e]        # 00484c38
    imul ecx, ecx, 0x85                          # 00484c3f
    mov eax, dword ptr [ebp - local_c]           # 00484c45
    mov esi, dword ptr [ebp - local_c]           # 00484c48
    mov edx, dword ptr [eax + edx + field_32]    # 00484c4b
    sub edx, dword ptr [esi + ecx + field_2a]    # 00484c4f
    mov eax, dword ptr [ebp - local_c]           # 00484c53
    mov word ptr [eax + field_bc5], dx           # 00484c56
    mov ecx, dword ptr [ebp - local_c]           # 00484c5d
    movsx edx, word ptr [ecx + field_a9e]        # 00484c60
    imul edx, edx, 0x85                          # 00484c67
    mov eax, dword ptr [ebp - local_c]           # 00484c6d
    movsx ecx, word ptr [eax + field_a9e]        # 00484c70
    imul ecx, ecx, 0x85                          # 00484c77
    mov eax, dword ptr [ebp - local_c]           # 00484c7d
    mov esi, dword ptr [ebp - local_c]           # 00484c80
    mov edx, dword ptr [eax + edx + field_36]    # 00484c83
    sub edx, dword ptr [esi + ecx + field_2e]    # 00484c87
    mov eax, dword ptr [ebp - local_c]           # 00484c8b
    mov word ptr [eax + field_bc7], dx           # 00484c8e
L_00484c95:
    # block 0x00484c95: entered by jmp at 0x00484bde, 6 instruction(s), calls FUN_00485f12, FUN_00484935, falls into the block at 0x00484caa
    mov ecx, dword ptr [ebp - local_c]           # 00484c95
    call FUN_00485f12                            # 00484c98
    mov cx, word ptr [ebp - local_4]             # 00484c9d
    push ecx                                     # 00484ca1
    mov ecx, dword ptr [ebp - local_c]           # 00484ca2
    call FUN_00484935                            # 00484ca5
L_00484caa:
    # block 0x00484caa: entered by je at 0x00484aea; je at 0x00484afa; jne at 0x00484b0a; jne at 0x00484b1d; more, 4 instruction(s), ends with ret
    pop esi                                      # 00484caa
    {load} mov esp, ebp                          # 00484cab
    pop ebp                                      # 00484cad
    ret                                          # 00484cae

