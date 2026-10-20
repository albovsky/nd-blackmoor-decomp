# FUN_00447ac7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447ac7
# extent:       0x00447ac7-0x00447c1c (341 code bytes)
# span:         0x00447ac7-0x00447c1c (code 341, tables 0, padding 0)
# sha256:       3a19f5c7853668313271d3d46a361add8876f23c1cf9d6e1ee3a15167cee116f
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m447ac7_split_pixels
# naming:       native port src/original_methods_fl19b.c:m447ac7_split_pixels (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m447ac7_split_pixels. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 341 bytes.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       11 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_68, local_7c, local_8c, local_90, local_94, local_98, local_9c
# fields:       [ecx + n] field_8; [edx + n] field_4, field_41, field_45
# callees:      calls FUN_004c3efb, FUN_004c4202
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl19b.c:m447ac7_split_pixels (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 92 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_68, 0x68  # offset -0x68
.equ local_7c, 0x7c  # offset -0x7c
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90
.equ local_94, 0x94  # offset -0x94
.equ local_98, 0x98  # offset -0x98
.equ local_9c, 0x9c  # offset -0x9c
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45

# --- external targets -----------------------------------------------
.set FUN_004c3efb, .text + (0x004c3efb - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)

.org 0x00447ac7 - 0x401000
.globl FUN_00447ac7
FUN_00447ac7:
    # block 0x00447ac7: entry, 19 instruction(s), calls FUN_004c3efb, ends with forward jump to 0x00447b29
    push ebp                                     # 00447ac7
    {load} mov ebp, esp                          # 00447ac8
    sub esp, 0x9c                                # 00447aca
    mov dword ptr [ebp - local_9c], ecx          # 00447ad0
    push 0x5485b4                                # 00447ad6
    lea eax, [ebp - local_8c]                    # 00447adb
    push eax                                     # 00447ae1
    push 0x583186                                # 00447ae2
    mov ecx, dword ptr [ebp + arg_8]             # 00447ae7
    push ecx                                     # 00447aea
    mov ecx, 0x5cf659                            # 00447aeb
    call FUN_004c3efb                            # 00447af0
    mov edx, dword ptr [ebp - local_68]          # 00447af5
    mov dword ptr [ebp - local_c], edx           # 00447af8
    mov eax, dword ptr [ebp - local_7c]          # 00447afb
    mov dword ptr [ebp - local_90], eax          # 00447afe
    mov dword ptr [ebp - local_98], 0x0          # 00447b04
    mov dword ptr [ebp - local_94], 0x0          # 00447b0e
    jmp.d8 L_00447b29                            # 00447b18
L_00447b1a:
    # block 0x00447b1a: entered by jmp at 0x00447bf9, 3 instruction(s), falls into the block at 0x00447b29
    mov ecx, dword ptr [ebp - local_94]          # 00447b1a
    add ecx, 0x1                                 # 00447b20
    mov dword ptr [ebp - local_94], ecx          # 00447b23
L_00447b29:
    # block 0x00447b29: entered by jmp at 0x00447b18, 4 instruction(s), ends with jge to 0x00447bfe (forward)
    mov edx, dword ptr [ebp - local_9c]          # 00447b29
    mov eax, dword ptr [ebp - local_94]          # 00447b2f
    cmp eax, dword ptr [edx + field_41]          # 00447b35
    jge.d32 L_00447bfe                           # 00447b38
    # block 0x00447b3e: entered by fall-through of jge at 0x00447b38, 2 instruction(s), ends with forward jump to 0x00447b50
    mov dword ptr [ebp - local_10], 0x0          # 00447b3e
    jmp.d8 L_00447b50                            # 00447b45
L_00447b47:
    # block 0x00447b47: entered by jmp at 0x00447be8, 3 instruction(s), falls into the block at 0x00447b50
    mov ecx, dword ptr [ebp - local_10]          # 00447b47
    add ecx, 0x2                                 # 00447b4a
    mov dword ptr [ebp - local_10], ecx          # 00447b4d
L_00447b50:
    # block 0x00447b50: entered by jmp at 0x00447b45, 4 instruction(s), ends with jge to 0x00447bed (forward)
    mov edx, dword ptr [ebp - local_9c]          # 00447b50
    mov eax, dword ptr [ebp - local_10]          # 00447b56
    cmp eax, dword ptr [edx + field_45]          # 00447b59
    jge.d32 L_00447bed                           # 00447b5c
    # block 0x00447b62: entered by fall-through of jge at 0x00447b5c, 44 instruction(s), ends with backward jump to 0x00447b47
    mov ecx, dword ptr [ebp - local_c]           # 00447b62
    add ecx, dword ptr [ebp - local_10]          # 00447b65
    {load} xor edx, edx                          # 00447b68
    mov dx, word ptr [ecx]                       # 00447b6a
    mov dword ptr [ebp - local_8], edx           # 00447b6d
    mov eax, dword ptr [ebp - local_98]          # 00447b70
    imul eax, eax, 0xc                           # 00447b76
    mov ecx, dword ptr [ebp + arg_c]             # 00447b79
    {load} add ecx, eax                          # 00447b7c
    mov dword ptr [ebp - local_4], ecx           # 00447b7e
    mov edx, dword ptr [ebp - local_98]          # 00447b81
    add edx, 0x1                                 # 00447b87
    mov dword ptr [ebp - local_98], edx          # 00447b8a
    {load} xor eax, eax                          # 00447b90
    mov al, byte ptr [0x5d2f1b]                  # 00447b92
    {load} mov ecx, eax                          # 00447b97
    mov edx, dword ptr [ebp - local_8]           # 00447b99
    sar edx, cl                                  # 00447b9c
    {load} xor eax, eax                          # 00447b9e
    mov al, byte ptr [0x5d2f1f]                  # 00447ba0
    {load} and edx, eax                          # 00447ba5
    mov ecx, dword ptr [ebp - local_4]           # 00447ba7
    mov dword ptr [ecx], edx                     # 00447baa
    {load} xor edx, edx                          # 00447bac
    mov dl, byte ptr [0x5d2f1a]                  # 00447bae
    {load} mov ecx, edx                          # 00447bb4
    mov eax, dword ptr [ebp - local_8]           # 00447bb6
    sar eax, cl                                  # 00447bb9
    {load} xor ecx, ecx                          # 00447bbb
    mov cl, byte ptr [0x5d2f1e]                  # 00447bbd
    {load} and eax, ecx                          # 00447bc3
    mov edx, dword ptr [ebp - local_4]           # 00447bc5
    mov dword ptr [edx + field_4], eax           # 00447bc8
    {load} xor eax, eax                          # 00447bcb
    mov al, byte ptr [0x5d2f19]                  # 00447bcd
    {load} mov ecx, eax                          # 00447bd2
    mov edx, dword ptr [ebp - local_8]           # 00447bd4
    sar edx, cl                                  # 00447bd7
    {load} xor eax, eax                          # 00447bd9
    mov al, byte ptr [0x5d2f1d]                  # 00447bdb
    {load} and edx, eax                          # 00447be0
    mov ecx, dword ptr [ebp - local_4]           # 00447be2
    mov dword ptr [ecx + field_8], edx           # 00447be5
    jmp.d32 L_00447b47                           # 00447be8
L_00447bed:
    # block 0x00447bed: entered by jge at 0x00447b5c, 4 instruction(s), ends with backward jump to 0x00447b1a
    mov edx, dword ptr [ebp - local_c]           # 00447bed
    add edx, dword ptr [ebp - local_90]          # 00447bf0
    mov dword ptr [ebp - local_c], edx           # 00447bf6
    jmp.d32 L_00447b1a                           # 00447bf9
L_00447bfe:
    # block 0x00447bfe: entered by jge at 0x00447b38, 9 instruction(s), calls FUN_004c4202, ends with ret 0x8
    push 0x5485f4                                # 00447bfe
    push 0x583186                                # 00447c03
    mov eax, dword ptr [ebp + arg_8]             # 00447c08
    push eax                                     # 00447c0b
    mov ecx, 0x5cf659                            # 00447c0c
    call FUN_004c4202                            # 00447c11
    {load} mov esp, ebp                          # 00447c16
    pop ebp                                      # 00447c18
    ret 0x8                                      # 00447c19

