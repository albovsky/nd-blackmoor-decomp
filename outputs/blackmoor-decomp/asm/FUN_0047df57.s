# FUN_0047df57
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047df57
# extent:       0x0047df57-0x0047e134 (477 code bytes)
# span:         0x0047df57-0x0047e140 (code 477, tables 0, padding 12)
# sha256:       fbf64d7a5c459aaa0a2d0746e9295b0f38734f3fc82e4ff1fad9d38741caed5e
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47df57_update_view
# naming:       native port src/original_methods_fl33b.c:m47df57_update_view (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Builds two rectangles and an offset pair from globals plus origin and calls 0x4c5377, then 0x4c62f0 or 0x4c6929 by byte [item+0x22]; the signed size/width/height compares are covered.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       16 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 4 more
# fields:       [edx + n] field_22
# callees:      calls FUN_004c5377, FUN_004c62f0, FUN_004c6929
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl33b.c:m47df57_update_view (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 124 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ field_22, 0x22  # offset +0x22

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c62f0, .text + (0x004c62f0 - 0x401000)
.set FUN_004c6929, .text + (0x004c6929 - 0x401000)

.org 0x0047df57 - 0x401000
.globl FUN_0047df57
FUN_0047df57:
    # block 0x0047df57: entry, 11 instruction(s), ends with je to 0x0047e130 (forward)
    push ebp                                     # 0047df57
    {load} mov ebp, esp                          # 0047df58
    sub esp, 0x40                                # 0047df5a
    movsx eax, word ptr [0x6246f9]               # 0047df5d
    imul eax, eax, 0x8d                          # 0047df64
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0047df6a
    mov dword ptr [ebp - local_24], ecx          # 0047df70
    {load} xor edx, edx                          # 0047df73
    mov dl, byte ptr [0x6246f8]                  # 0047df75
    test edx, edx                                # 0047df7b
    je.d32 L_0047e130                            # 0047df7d
    # block 0x0047df83: entered by fall-through of je at 0x0047df7d, 56 instruction(s), calls FUN_004c5377, ends with jge to 0x0047e087 (forward)
    movsx eax, word ptr [0x624731]               # 0047df83
    shl eax                                      # 0047df8a
    mov dword ptr [ebp - local_40], eax          # 0047df8c
    mov ecx, dword ptr [0x62470d]                # 0047df8f
    sub ecx, dword ptr [0x624705]                # 0047df95
    add ecx, 0x1                                 # 0047df9b
    mov dword ptr [ebp - local_3c], ecx          # 0047df9e
    mov edx, dword ptr [0x624711]                # 0047dfa1
    sub edx, dword ptr [0x624709]                # 0047dfa7
    add edx, 0x1                                 # 0047dfad
    mov dword ptr [ebp - local_38], edx          # 0047dfb0
    mov eax, dword ptr [0x624719]                # 0047dfb3
    add eax, dword ptr [0x58318a]                # 0047dfb8
    mov dword ptr [ebp - local_1c], eax          # 0047dfbe
    mov ecx, dword ptr [0x624721]                # 0047dfc1
    add ecx, dword ptr [0x58318a]                # 0047dfc7
    mov dword ptr [ebp - local_14], ecx          # 0047dfcd
    mov edx, dword ptr [0x624715]                # 0047dfd0
    add edx, dword ptr [0x583186]                # 0047dfd6
    mov dword ptr [ebp - local_20], edx          # 0047dfdc
    mov eax, dword ptr [0x62471d]                # 0047dfdf
    add eax, dword ptr [0x583186]                # 0047dfe4
    mov dword ptr [ebp - local_18], eax          # 0047dfea
    push 0x54d3ec                                # 0047dfed
    lea ecx, [ebp - local_20]                    # 0047dff2
    push ecx                                     # 0047dff5
    push 0x624715                                # 0047dff6
    mov edx, dword ptr [0x5cf665]                # 0047dffb
    push edx                                     # 0047e001
    mov eax, dword ptr [0x5d15e3]                # 0047e002
    push eax                                     # 0047e007
    mov ecx, 0x5cf659                            # 0047e008
    call FUN_004c5377                            # 0047e00d
    mov ecx, dword ptr [0x624709]                # 0047e012
    add ecx, dword ptr [0x58318a]                # 0047e018
    mov dword ptr [ebp - local_c], ecx           # 0047e01e
    mov edx, dword ptr [0x624711]                # 0047e021
    add edx, dword ptr [0x58318a]                # 0047e027
    mov dword ptr [ebp - local_4], edx           # 0047e02d
    mov eax, dword ptr [0x624705]                # 0047e030
    add eax, dword ptr [0x583186]                # 0047e035
    mov dword ptr [ebp - local_10], eax          # 0047e03b
    mov ecx, dword ptr [0x62470d]                # 0047e03e
    add ecx, dword ptr [0x583186]                # 0047e044
    mov dword ptr [ebp - local_8], ecx           # 0047e04a
    mov dword ptr [ebp - local_34], 0x0          # 0047e04d
    mov dword ptr [ebp - local_30], 0x0          # 0047e054
    mov edx, dword ptr [ebp - local_40]          # 0047e05b
    sub edx, 0x1                                 # 0047e05e
    mov dword ptr [ebp - local_2c], edx          # 0047e061
    mov eax, dword ptr [ebp - local_40]          # 0047e064
    sub eax, 0x1                                 # 0047e067
    mov dword ptr [ebp - local_28], eax          # 0047e06a
    mov ecx, dword ptr [ebp - local_3c]          # 0047e06d
    cmp ecx, dword ptr [ebp - local_40]          # 0047e070
    jge.d8 L_0047e087                            # 0047e073
    # block 0x0047e075: entered by fall-through of jge at 0x0047e073, 2 instruction(s), ends with jne to 0x0047e087 (forward)
    cmp dword ptr [0x624705], 0x0                # 0047e075
    jne.d8 L_0047e087                            # 0047e07c
    # block 0x0047e07e: entered by fall-through of jne at 0x0047e07c, 3 instruction(s), falls into the block at 0x0047e087
    mov edx, dword ptr [ebp - local_40]          # 0047e07e
    sub edx, dword ptr [ebp - local_3c]          # 0047e081
    mov dword ptr [ebp - local_34], edx          # 0047e084
L_0047e087:
    # block 0x0047e087: entered by jge at 0x0047e073; jne at 0x0047e07c, 3 instruction(s), ends with jge to 0x0047e0a1 (forward)
    mov eax, dword ptr [ebp - local_38]          # 0047e087
    cmp eax, dword ptr [ebp - local_40]          # 0047e08a
    jge.d8 L_0047e0a1                            # 0047e08d
    # block 0x0047e08f: entered by fall-through of jge at 0x0047e08d, 2 instruction(s), ends with jne to 0x0047e0a1 (forward)
    cmp dword ptr [0x624709], 0x0                # 0047e08f
    jne.d8 L_0047e0a1                            # 0047e096
    # block 0x0047e098: entered by fall-through of jne at 0x0047e096, 3 instruction(s), falls into the block at 0x0047e0a1
    mov ecx, dword ptr [ebp - local_40]          # 0047e098
    sub ecx, dword ptr [ebp - local_38]          # 0047e09b
    mov dword ptr [ebp - local_30], ecx          # 0047e09e
L_0047e0a1:
    # block 0x0047e0a1: entered by jge at 0x0047e08d; jne at 0x0047e096, 5 instruction(s), ends with je to 0x0047e0f5 (forward)
    mov edx, dword ptr [ebp - local_24]          # 0047e0a1
    {load} xor eax, eax                          # 0047e0a4
    mov al, byte ptr [edx + field_22]            # 0047e0a6
    test eax, eax                                # 0047e0a9
    je.d8 L_0047e0f5                             # 0047e0ab
    # block 0x0047e0ad: entered by fall-through of je at 0x0047e0ab, 20 instruction(s), calls FUN_004c62f0, ends with forward jump to 0x0047e130
    push 0x54d408                                # 0047e0ad
    lea ecx, [ebp - local_34]                    # 0047e0b2
    push ecx                                     # 0047e0b5
    lea edx, [ebp - local_10]                    # 0047e0b6
    push edx                                     # 0047e0b9
    push 0x624705                                # 0047e0ba
    push 0x624705                                # 0047e0bf
    mov eax, dword ptr [0x624729]                # 0047e0c4
    push eax                                     # 0047e0c9
    mov ecx, dword ptr [0x5cf665]                # 0047e0ca
    push ecx                                     # 0047e0d0
    mov edx, dword ptr [0x5d15e3]                # 0047e0d1
    push edx                                     # 0047e0d7
    movsx eax, word ptr [0x6246ff]               # 0047e0d8
    imul eax, eax, 0x4a                          # 0047e0df
    mov ecx, dword ptr [eax + 0x5d1599]          # 0047e0e2
    push ecx                                     # 0047e0e8
    mov ecx, 0x5cf659                            # 0047e0e9
    call FUN_004c62f0                            # 0047e0ee
    jmp.d8 L_0047e130                            # 0047e0f3
L_0047e0f5:
    # block 0x0047e0f5: entered by je at 0x0047e0ab, 16 instruction(s), calls FUN_004c6929, falls into the block at 0x0047e130
    push 0x54d434                                # 0047e0f5
    lea edx, [ebp - local_34]                    # 0047e0fa
    push edx                                     # 0047e0fd
    lea eax, [ebp - local_10]                    # 0047e0fe
    push eax                                     # 0047e101
    push 0x624705                                # 0047e102
    mov ecx, dword ptr [0x62472d]                # 0047e107
    push ecx                                     # 0047e10d
    mov edx, dword ptr [0x5cf665]                # 0047e10e
    push edx                                     # 0047e114
    movsx eax, word ptr [0x6246ff]               # 0047e115
    imul eax, eax, 0x4a                          # 0047e11c
    mov ecx, dword ptr [eax + 0x5d1599]          # 0047e11f
    push ecx                                     # 0047e125
    mov ecx, 0x5cf659                            # 0047e126
    call FUN_004c6929                            # 0047e12b
L_0047e130:
    # block 0x0047e130: entered by je at 0x0047df7d; jmp at 0x0047e0f3, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047e130
    pop ebp                                      # 0047e132
    ret                                          # 0047e133

# --- data items (not part of the function) -------------------------
.org 0x0047e134 - 0x401000
PAD_0047e134:  # 12 byte(s) of int3 padding
    .fill 12, 1, 0xcc

