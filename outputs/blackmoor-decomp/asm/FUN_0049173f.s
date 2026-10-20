# FUN_0049173f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049173f
# extent:       0x0049173f-0x00491885 (326 code bytes)
# span:         0x0049173f-0x00491885 (code 326, tables 0, padding 0)
# sha256:       85553aabad0e8fb1db51d5510232e84c88f3e98fe736c4830a9f248fd01c2ae7
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_raycast_byte_table_builder
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/49173f.c.txt, not original source) refers to the data labelled s_CRayCast__CRayCast___constructor_0054ee24
# name-note:    CRayCast constructor part: reallocates a byte table, fills it with 7 and then with runs of values 0-7; failure message names the CRayCast constructor.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_2095, field_20b5, field_20bd; [ecx + n] field_20b5, field_20bd; [edx + n] field_20b5, field_20bd
# callees:      calls FUN_0051dc6c, FUN_0051dc43, FUN_0052139c, FUN_004c97b4, FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 92 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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
.equ field_2095, 0x2095  # offset +0x2095
.equ field_20b5, 0x20b5  # offset +0x20b5
.equ field_20bd, 0x20bd  # offset +0x20bd

# --- external targets -----------------------------------------------
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0049173f - 0x401000
.globl FUN_0049173f
FUN_0049173f:
    # block 0x0049173f: entry, 8 instruction(s), ends with je to 0x0049177a (forward)
    push ebp                                     # 0049173f
    {load} mov ebp, esp                          # 00491740
    sub esp, 0x20                                # 00491742
    push edi                                     # 00491745
    mov dword ptr [ebp - local_1c], ecx          # 00491746
    mov eax, dword ptr [ebp - local_1c]          # 00491749
    cmp dword ptr [eax + field_20b5], 0x0        # 0049174c
    je.d8 L_0049177a                             # 00491753
    # block 0x00491755: entered by fall-through of je at 0x00491753, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049177a
    mov ecx, dword ptr [ebp - local_1c]          # 00491755
    mov edx, dword ptr [ecx + field_20b5]        # 00491758
    mov dword ptr [ebp - local_14], edx          # 0049175e
    mov eax, dword ptr [ebp - local_14]          # 00491761
    push eax                                     # 00491764
    call FUN_0051dc6c                            # 00491765
    add esp, 0x4                                 # 0049176a
    mov ecx, dword ptr [ebp - local_1c]          # 0049176d
    mov dword ptr [ecx + field_20b5], 0x0        # 00491770
L_0049177a:
    # block 0x0049177a: entered by je at 0x00491753, 11 instruction(s), calls FUN_0051dc43, ends with jne to 0x004917b9 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 0049177a
    mov eax, dword ptr [edx + field_20bd]        # 0049177d
    push eax                                     # 00491783
    call FUN_0051dc43                            # 00491784
    add esp, 0x4                                 # 00491789
    mov dword ptr [ebp - local_18], eax          # 0049178c
    mov ecx, dword ptr [ebp - local_1c]          # 0049178f
    mov edx, dword ptr [ebp - local_18]          # 00491792
    mov dword ptr [ecx + field_20b5], edx        # 00491795
    cmp dword ptr [ebp - local_18], 0x0          # 0049179b
    jne.d8 L_004917b9                            # 0049179f
    # block 0x004917a1: entered by fall-through of jne at 0x0049179f, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004917b9
    push 0x0                                     # 004917a1
    push 0x0                                     # 004917a3
    push 0x54ee24                                # 004917a5
    call FUN_0052139c                            # 004917aa
    mov ecx, 0x5cf659                            # 004917af
    call FUN_004c97b4                            # 004917b4
L_004917b9:
    # block 0x004917b9: entered by jne at 0x0049179f, 14 instruction(s), falls into the block at 0x004917f3
    mov eax, dword ptr [ebp - local_1c]          # 004917b9
    mov ecx, dword ptr [eax + field_20bd]        # 004917bc
    mov eax, 0x7070707                           # 004917c2
    mov edx, dword ptr [ebp - local_1c]          # 004917c7
    mov edi, dword ptr [edx + field_20b5]        # 004917ca
    {load} mov edx, ecx                          # 004917d0
    shr ecx, 0x2                                 # 004917d2
    rep stosd dword ptr es:[edi], eax            # 004917d5
    {load} mov ecx, edx                          # 004917d7
    and ecx, 0x3                                 # 004917d9
    rep stosb byte ptr es:[edi], al              # 004917dc
    mov dword ptr [ebp - local_4], 0x0           # 004917de
    mov dword ptr [ebp - local_10], 0x40c00000   # 004917e5
    mov dword ptr [ebp - local_c], 0x0           # 004917ec
L_004917f3:
    # block 0x004917f3: entered by jmp at 0x0049187b, 2 instruction(s), ends with jge to 0x00491880 (forward)
    cmp dword ptr [ebp - local_4], 0x8           # 004917f3
    jge.d32 L_00491880                           # 004917f7
    # block 0x004917fd: entered by fall-through of jge at 0x004917f7, 4 instruction(s), ends with jge to 0x00491880 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004917fd
    mov ecx, dword ptr [ebp - local_c]           # 00491800
    cmp ecx, dword ptr [eax + field_20bd]        # 00491803
    jge.d8 L_00491880                            # 00491809
    # block 0x0049180b: entered by fall-through of jge at 0x00491809, 2 instruction(s), ends with forward jump to 0x0049181d
    mov dword ptr [ebp - local_8], 0x0           # 0049180b
    jmp.d8 L_0049181d                            # 00491812
L_00491814:
    # block 0x00491814: entered by jmp at 0x00491864, 3 instruction(s), falls into the block at 0x0049181d
    mov edx, dword ptr [ebp - local_8]           # 00491814
    add edx, 0x1                                 # 00491817
    mov dword ptr [ebp - local_8], edx           # 0049181a
L_0049181d:
    # block 0x0049181d: entered by jmp at 0x00491812, 8 instruction(s), calls FUN_0050ce04, ends with jge to 0x00491866 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 0049181d
    fild dword ptr [eax + field_2095]            # 00491820
    fstp dword ptr [ebp - local_20]              # 00491826
    fld dword ptr [ebp - local_20]               # 00491829
    fmul dword ptr [ebp - local_10]              # 0049182c
    call FUN_0050ce04                            # 0049182f
    cmp dword ptr [ebp - local_8], eax           # 00491834
    jge.d8 L_00491866                            # 00491837
    # block 0x00491839: entered by fall-through of jge at 0x00491837, 4 instruction(s), ends with jl to 0x00491849 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 00491839
    mov edx, dword ptr [ebp - local_c]           # 0049183c
    cmp edx, dword ptr [ecx + field_20bd]        # 0049183f
    jl.d8 L_00491849                             # 00491845
    # block 0x00491847: entered by fall-through of jl at 0x00491845, 1 instruction(s), ends with forward jump to 0x00491866
    jmp.d8 L_00491866                            # 00491847
L_00491849:
    # block 0x00491849: entered by jl at 0x00491845, 9 instruction(s), ends with backward jump to 0x00491814
    mov eax, dword ptr [ebp - local_1c]          # 00491849
    mov ecx, dword ptr [eax + field_20b5]        # 0049184c
    mov edx, dword ptr [ebp - local_c]           # 00491852
    mov al, byte ptr [ebp - local_4]             # 00491855
    mov byte ptr [ecx + edx], al                 # 00491858
    mov ecx, dword ptr [ebp - local_c]           # 0049185b
    add ecx, 0x1                                 # 0049185e
    mov dword ptr [ebp - local_c], ecx           # 00491861
    jmp.d8 L_00491814                            # 00491864
L_00491866:
    # block 0x00491866: entered by jge at 0x00491837; jmp at 0x00491847, 7 instruction(s), ends with backward jump to 0x004917f3
    fld dword ptr [ebp - local_10]               # 00491866
    fadd dword ptr [0x52cbf4]                    # 00491869
    fstp dword ptr [ebp - local_10]              # 0049186f
    mov edx, dword ptr [ebp - local_4]           # 00491872
    add edx, 0x1                                 # 00491875
    mov dword ptr [ebp - local_4], edx           # 00491878
    jmp.d32 L_004917f3                           # 0049187b
L_00491880:
    # block 0x00491880: entered by jge at 0x004917f7; jge at 0x00491809, 4 instruction(s), ends with ret
    pop edi                                      # 00491880
    {load} mov esp, ebp                          # 00491881
    pop ebp                                      # 00491883
    ret                                          # 00491884

