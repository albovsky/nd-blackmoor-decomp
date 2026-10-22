# FUN_004740e5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004740e5
# extent:       0x004740e5-0x004741eb (262 code bytes)
# span:         0x004740e5-0x004741eb (code 262, tables 0, padding 0)
# sha256:       d6c7f282e74d0f9aa2bf6a2387ab93d5d5e038e86cb5deaa3b4015df67e75676
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004740e5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_96, field_a6; [ecx + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      calls FUN_004d5316, FUN_004754a1
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4740e5_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 70 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_96, 0x96  # offset +0x96
.equ field_a6, 0xa6  # offset +0xa6

# --- external targets -----------------------------------------------
.set FUN_004754a1, .text + (0x004754a1 - 0x401000)
.set FUN_004d5316, .text + (0x004d5316 - 0x401000)

.org 0x004740e5 - 0x401000
.globl FUN_004740e5
FUN_004740e5:
    # block 0x004740e5: entry, 6 instruction(s), ends with forward jump to 0x00474100
    push ebp                                     # 004740e5
    {load} mov ebp, esp                          # 004740e6
    sub esp, 0x8                                 # 004740e8
    mov dword ptr [ebp - local_8], ecx           # 004740eb
    mov dword ptr [ebp - local_4], 0x0           # 004740ee
    jmp.d8 L_00474100                            # 004740f5
L_004740f7:
    # block 0x004740f7: entered by jmp at 0x004741b2, 3 instruction(s), falls into the block at 0x00474100
    mov eax, dword ptr [ebp - local_4]           # 004740f7
    add eax, 0x1                                 # 004740fa
    mov dword ptr [ebp - local_4], eax           # 004740fd
L_00474100:
    # block 0x00474100: entered by jmp at 0x004740f5, 2 instruction(s), ends with jge to 0x004741b7 (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 00474100
    jge.d32 L_004741b7                           # 00474104
    # block 0x0047410a: entered by fall-through of jge at 0x00474104, 3 instruction(s), ends with jne to 0x004741b2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047410a
    cmp dword ptr [4*ecx + 0x5a4b4e], 0x0        # 0047410d
    jne.d32 L_004741b2                           # 00474115
    # block 0x0047411b: entered by fall-through of jne at 0x00474115, 13 instruction(s), calls FUN_004d5316, ends with je to 0x004741b2 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047411b
    imul edx, edx, 0x38                          # 0047411e
    mov eax, dword ptr [ebp - local_8]           # 00474121
    lea ecx, [eax + edx + field_96]              # 00474124
    push ecx                                     # 0047412b
    mov edx, dword ptr [ebp - local_4]           # 0047412c
    shl edx, 0x4                                 # 0047412f
    add edx, 0x5a4b5e                            # 00474132
    push edx                                     # 00474138
    mov ecx, 0x570450                            # 00474139
    call FUN_004d5316                            # 0047413e
    test eax, eax                                # 00474143
    je.d8 L_004741b2                             # 00474145
    # block 0x00474147: entered by fall-through of je at 0x00474145, 22 instruction(s), ends with jne to 0x004741a8 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00474147
    mov dword ptr [4*eax + 0x5a4b4e], 0x1        # 0047414a
    mov ecx, dword ptr [ebp - local_4]           # 00474155
    mov dword ptr [4*ecx + 0x5a4bbe], 0x0        # 00474158
    mov edx, dword ptr [ebp - local_4]           # 00474163
    imul edx, edx, 0x38                          # 00474166
    mov eax, dword ptr [ebp - local_8]           # 00474169
    lea ecx, [eax + edx + field_a6]              # 0047416c
    mov edx, dword ptr [ebp - local_4]           # 00474173
    shl edx, 0x4                                 # 00474176
    add edx, 0x5a4b5e                            # 00474179
    mov eax, dword ptr [ecx]                     # 0047417f
    mov dword ptr [edx], eax                     # 00474181
    mov eax, dword ptr [ecx + field_4]           # 00474183
    mov dword ptr [edx + field_4], eax           # 00474186
    mov eax, dword ptr [ecx + field_8]           # 00474189
    mov dword ptr [edx + field_8], eax           # 0047418c
    mov ecx, dword ptr [ecx + field_c]           # 0047418f
    mov dword ptr [edx + field_c], ecx           # 00474192
    mov edx, dword ptr [0x5a4bce]                # 00474195
    cmp edx, dword ptr [ebp - local_4]           # 0047419b
    jne.d8 L_004741a8                            # 0047419e
    # block 0x004741a0: entered by fall-through of jne at 0x0047419e, 2 instruction(s), calls FUN_004754a1, falls into the block at 0x004741a8
    mov ecx, dword ptr [ebp - local_8]           # 004741a0
    call FUN_004754a1                            # 004741a3
L_004741a8:
    # block 0x004741a8: entered by jne at 0x0047419e, 1 instruction(s), falls into the block at 0x004741b2
    mov dword ptr [0x5a4bce], 0xffffffff         # 004741a8
L_004741b2:
    # block 0x004741b2: entered by jne at 0x00474115; je at 0x00474145, 1 instruction(s), ends with backward jump to 0x004740f7
    jmp.d32 L_004740f7                           # 004741b2
L_004741b7:
    # block 0x004741b7: entered by jge at 0x00474104, 2 instruction(s), ends with forward jump to 0x004741c9
    mov dword ptr [ebp - local_4], 0x0           # 004741b7
    jmp.d8 L_004741c9                            # 004741be
L_004741c0:
    # block 0x004741c0: entered by jmp at 0x004741e0, 3 instruction(s), falls into the block at 0x004741c9
    mov eax, dword ptr [ebp - local_4]           # 004741c0
    add eax, 0x1                                 # 004741c3
    mov dword ptr [ebp - local_4], eax           # 004741c6
L_004741c9:
    # block 0x004741c9: entered by jmp at 0x004741be, 2 instruction(s), ends with jge to 0x004741e2 (forward)
    cmp dword ptr [ebp - local_4], 0x4           # 004741c9
    jge.d8 L_004741e2                            # 004741cd
    # block 0x004741cf: entered by fall-through of jge at 0x004741cd, 3 instruction(s), ends with jne to 0x004741e0 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004741cf
    cmp dword ptr [4*ecx + 0x5a4b4e], 0x0        # 004741d2
    jne.d8 L_004741e0                            # 004741da
    # block 0x004741dc: entered by fall-through of jne at 0x004741da, 2 instruction(s), ends with forward jump to 0x004741e7
    {load} xor eax, eax                          # 004741dc
    jmp.d8 L_004741e7                            # 004741de
L_004741e0:
    # block 0x004741e0: entered by jne at 0x004741da, 1 instruction(s), ends with backward jump to 0x004741c0
    jmp.d8 L_004741c0                            # 004741e0
L_004741e2:
    # block 0x004741e2: entered by jge at 0x004741cd, 1 instruction(s), falls into the block at 0x004741e7
    mov eax, 0x1                                 # 004741e2
L_004741e7:
    # block 0x004741e7: entered by jmp at 0x004741de, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004741e7
    pop ebp                                      # 004741e9
    ret                                          # 004741ea

