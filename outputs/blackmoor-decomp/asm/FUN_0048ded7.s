# FUN_0048ded7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ded7
# extent:       0x0048ded7-0x0048e166 (655 code bytes)
# span:         0x0048ded7-0x0048e170 (code 655, tables 0, padding 10)
# sha256:       dfbb7f7b66b96fa8afd7398629b9b4ecd32cbc096a5e40fc6db5ae9261643225
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48ded7_draw_hover
# naming:       native port src/original_methods_fl19b.c:m48ded7_draw_hover (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m48ded7_draw_hover. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 655 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_117, field_11b, field_11f; [ecx + n] field_113, field_11f; [edx + n] field_23, field_113, field_117, field_11b
# callees:      calls FUN_004c5377, FUN_0048d89e
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:create_native_scene_session (function ledger class native_oracle_verified; also native_ad0_alloc_slot, native_ad0_render, native_caption_finish_tick; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 135 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ field_23, 0x23  # offset +0x23
.equ field_113, 0x113  # offset +0x113
.equ field_117, 0x117  # offset +0x117
.equ field_11b, 0x11b  # offset +0x11b
.equ field_11f, 0x11f  # offset +0x11f

# --- external targets -----------------------------------------------
.set FUN_0048d89e, .text + (0x0048d89e - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x0048ded7 - 0x401000
.globl FUN_0048ded7
FUN_0048ded7:
    # block 0x0048ded7: entry, 11 instruction(s), ends with je to 0x0048e162 (forward)
    push ebp                                     # 0048ded7
    {load} mov ebp, esp                          # 0048ded8
    sub esp, 0x18                                # 0048deda
    movsx eax, word ptr [0x61d363]               # 0048dedd
    imul eax, eax, 0x8d                          # 0048dee4
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0048deea
    mov dword ptr [ebp - local_8], ecx           # 0048def0
    {load} xor edx, edx                          # 0048def3
    mov dl, byte ptr [0x61d369]                  # 0048def5
    test edx, edx                                # 0048defb
    je.d32 L_0048e162                            # 0048defd
    # block 0x0048df03: entered by fall-through of je at 0x0048defd, 2 instruction(s), ends with je to 0x0048e162 (forward)
    cmp dword ptr [0x61d374], 0x0                # 0048df03
    je.d32 L_0048e162                            # 0048df0a
    # block 0x0048df10: entered by fall-through of je at 0x0048df0a, 6 instruction(s), ends with je to 0x0048e030 (forward)
    movsx eax, word ptr [0x61d36c]               # 0048df10
    mov dword ptr [ebp - local_4], eax           # 0048df17
    {load} xor ecx, ecx                          # 0048df1a
    mov cl, byte ptr [0x61d36b]                  # 0048df1c
    test ecx, ecx                                # 0048df22
    je.d32 L_0048e030                            # 0048df24
    # block 0x0048df2a: entered by fall-through of je at 0x0048df24, 2 instruction(s), ends with je to 0x0048e030 (forward)
    cmp dword ptr [ebp - local_4], -0x1          # 0048df2a
    je.d32 L_0048e030                            # 0048df2e
    # block 0x0048df34: entered by fall-through of je at 0x0048df2e, 52 instruction(s), calls FUN_004c5377, ends with forward jump to 0x0048e15b
    movsx edx, word ptr [0x61d363]               # 0048df34
    imul edx, edx, 0x8d                          # 0048df3b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0048df41
    mov ecx, dword ptr [ebp - local_4]           # 0048df47
    shl ecx, 0x4                                 # 0048df4a
    mov edx, dword ptr [eax + ecx + field_117]   # 0048df4d
    add edx, dword ptr [0x58318a]                # 0048df54
    mov dword ptr [ebp - local_14], edx          # 0048df5a
    movsx eax, word ptr [0x61d363]               # 0048df5d
    imul eax, eax, 0x8d                          # 0048df64
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0048df6a
    mov edx, dword ptr [ebp - local_4]           # 0048df70
    shl edx, 0x4                                 # 0048df73
    mov eax, dword ptr [ecx + edx + field_11f]   # 0048df76
    add eax, dword ptr [0x58318a]                # 0048df7d
    mov dword ptr [ebp - local_c], eax           # 0048df83
    movsx ecx, word ptr [0x61d363]               # 0048df86
    imul ecx, ecx, 0x8d                          # 0048df8d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048df93
    mov eax, dword ptr [ebp - local_4]           # 0048df99
    shl eax, 0x4                                 # 0048df9c
    mov ecx, dword ptr [edx + eax + field_113]   # 0048df9f
    add ecx, dword ptr [0x583186]                # 0048dfa6
    mov dword ptr [ebp - local_18], ecx          # 0048dfac
    movsx edx, word ptr [0x61d363]               # 0048dfaf
    imul edx, edx, 0x8d                          # 0048dfb6
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0048dfbc
    mov ecx, dword ptr [ebp - local_4]           # 0048dfc2
    shl ecx, 0x4                                 # 0048dfc5
    mov edx, dword ptr [eax + ecx + field_11b]   # 0048dfc8
    add edx, dword ptr [0x583186]                # 0048dfcf
    mov dword ptr [ebp - local_10], edx          # 0048dfd5
    push 0x54e8e0                                # 0048dfd8
    lea eax, [ebp - local_18]                    # 0048dfdd
    push eax                                     # 0048dfe0
    movsx ecx, word ptr [0x61d363]               # 0048dfe1
    imul ecx, ecx, 0x8d                          # 0048dfe8
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048dfee
    mov eax, dword ptr [ebp - local_4]           # 0048dff4
    shl eax, 0x4                                 # 0048dff7
    lea ecx, [edx + eax + field_23]              # 0048dffa
    push ecx                                     # 0048dffe
    mov edx, dword ptr [0x5cf665]                # 0048dfff
    push edx                                     # 0048e005
    movsx eax, word ptr [0x61d361]               # 0048e006
    imul eax, eax, 0x4a                          # 0048e00d
    mov ecx, dword ptr [eax + 0x5d1599]          # 0048e010
    push ecx                                     # 0048e016
    mov ecx, 0x5cf659                            # 0048e017
    call FUN_004c5377                            # 0048e01c
    mov dword ptr [0x61d370], 0x0                # 0048e021
    jmp.d32 L_0048e15b                           # 0048e02b
L_0048e030:
    # block 0x0048e030: entered by je at 0x0048df24; je at 0x0048df2e, 4 instruction(s), ends with je to 0x0048e15b (forward)
    {load} xor edx, edx                          # 0048e030
    mov dl, byte ptr [0x61d36a]                  # 0048e032
    test edx, edx                                # 0048e038
    je.d32 L_0048e15b                            # 0048e03a
    # block 0x0048e040: entered by fall-through of je at 0x0048e03a, 3 instruction(s), ends with je to 0x0048e15b (forward)
    movsx eax, word ptr [0x61d36e]               # 0048e040
    cmp eax, -0x1                                # 0048e047
    je.d32 L_0048e15b                            # 0048e04a
    # block 0x0048e050: entered by fall-through of je at 0x0048e04a, 51 instruction(s), calls FUN_004c5377, FUN_0048d89e, falls into the block at 0x0048e15b
    movsx ecx, word ptr [0x61d363]               # 0048e050
    imul ecx, ecx, 0x8d                          # 0048e057
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048e05d
    movsx eax, word ptr [0x61d36e]               # 0048e063
    shl eax, 0x4                                 # 0048e06a
    mov ecx, dword ptr [edx + eax + field_117]   # 0048e06d
    add ecx, dword ptr [0x58318a]                # 0048e074
    mov dword ptr [ebp - local_14], ecx          # 0048e07a
    movsx edx, word ptr [0x61d363]               # 0048e07d
    imul edx, edx, 0x8d                          # 0048e084
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0048e08a
    movsx ecx, word ptr [0x61d36e]               # 0048e090
    shl ecx, 0x4                                 # 0048e097
    mov edx, dword ptr [eax + ecx + field_11f]   # 0048e09a
    add edx, dword ptr [0x58318a]                # 0048e0a1
    mov dword ptr [ebp - local_c], edx           # 0048e0a7
    movsx eax, word ptr [0x61d363]               # 0048e0aa
    imul eax, eax, 0x8d                          # 0048e0b1
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0048e0b7
    movsx edx, word ptr [0x61d36e]               # 0048e0bd
    shl edx, 0x4                                 # 0048e0c4
    mov eax, dword ptr [ecx + edx + field_113]   # 0048e0c7
    add eax, dword ptr [0x583186]                # 0048e0ce
    mov dword ptr [ebp - local_18], eax          # 0048e0d4
    movsx ecx, word ptr [0x61d363]               # 0048e0d7
    imul ecx, ecx, 0x8d                          # 0048e0de
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048e0e4
    movsx eax, word ptr [0x61d36e]               # 0048e0ea
    shl eax, 0x4                                 # 0048e0f1
    mov ecx, dword ptr [edx + eax + field_11b]   # 0048e0f4
    add ecx, dword ptr [0x583186]                # 0048e0fb
    mov dword ptr [ebp - local_10], ecx          # 0048e101
    push 0x54e8fc                                # 0048e104
    lea edx, [ebp - local_18]                    # 0048e109
    push edx                                     # 0048e10c
    movsx eax, word ptr [0x61d363]               # 0048e10d
    imul eax, eax, 0x8d                          # 0048e114
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0048e11a
    movsx edx, word ptr [0x61d36e]               # 0048e120
    shl edx, 0x4                                 # 0048e127
    lea eax, [ecx + edx + field_113]             # 0048e12a
    push eax                                     # 0048e131
    mov ecx, dword ptr [0x5cf665]                # 0048e132
    push ecx                                     # 0048e138
    mov edx, dword ptr [0x5d15e3]                # 0048e139
    push edx                                     # 0048e13f
    mov ecx, 0x5cf659                            # 0048e140
    call FUN_004c5377                            # 0048e145
    mov byte ptr [0x61d36a], 0x0                 # 0048e14a
    mov ecx, 0x61d345                            # 0048e151
    call FUN_0048d89e                            # 0048e156
L_0048e15b:
    # block 0x0048e15b: entered by jmp at 0x0048e02b; je at 0x0048e03a; je at 0x0048e04a, 1 instruction(s), falls into the block at 0x0048e162
    mov byte ptr [0x61d369], 0x0                 # 0048e15b
L_0048e162:
    # block 0x0048e162: entered by je at 0x0048defd; je at 0x0048df0a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048e162
    pop ebp                                      # 0048e164
    ret                                          # 0048e165

# --- data items (not part of the function) -------------------------
.org 0x0048e166 - 0x401000
PAD_0048e166:  # 10 byte(s) of int3 padding
    .fill 10, 1, 0xcc

