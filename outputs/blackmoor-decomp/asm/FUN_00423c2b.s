# FUN_00423c2b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423c2b
# extent:       0x00423c2b-0x00423d33 (264 code bytes)
# span:         0x00423c2b-0x00423d33 (code 264, tables 0, padding 0)
# sha256:       f1df4868273536687c29bf03d920c7cd21242fcd7b8c03921f0ceec30a1d4cc7
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_dependency_clear_all
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/423c2b.c.txt, not original source) refers to the data labelled s_CDependency__ClearAll___00544874
# name-note:    CDependency::ClearAll: resets the dependency fields of all 0xf0 scene entries to zero (or -1 for one field).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_c, field_18, field_24, field_30; [ecx + n] field_4, field_10, field_1c, field_28, field_34; [edx + n] field_8, field_14, field_20, field_2c, field_38
# callees:      calls FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 61 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00423c2b - 0x401000
.globl FUN_00423c2b
FUN_00423c2b:
    # block 0x00423c2b: entry, 7 instruction(s), ends with je to 0x00423c5e (forward)
    push ebp                                     # 00423c2b
    {load} mov ebp, esp                          # 00423c2c
    sub esp, 0x10                                # 00423c2e
    mov dword ptr [ebp - local_10], ecx          # 00423c31
    movsx eax, word ptr [0x63a4cd]               # 00423c34
    test eax, eax                                # 00423c3b
    je.d8 L_00423c5e                             # 00423c3d
    # block 0x00423c3f: entered by fall-through of je at 0x00423c3d, 7 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00423c5e
    push 0x544874                                # 00423c3f
    push 0x63888b                                # 00423c44
    call FUN_0050ca3e                            # 00423c49
    add esp, 0x8                                 # 00423c4e
    push 0x63888b                                # 00423c51
    call FUN_0044a2b7                            # 00423c56
    add esp, 0x4                                 # 00423c5b
L_00423c5e:
    # block 0x00423c5e: entered by je at 0x00423c3d, 2 instruction(s), ends with forward jump to 0x00423c70
    mov dword ptr [ebp - local_8], 0x0           # 00423c5e
    jmp.d8 L_00423c70                            # 00423c65
L_00423c67:
    # block 0x00423c67: entered by jmp at 0x00423d2a, 3 instruction(s), falls into the block at 0x00423c70
    mov ecx, dword ptr [ebp - local_8]           # 00423c67
    add ecx, 0x1                                 # 00423c6a
    mov dword ptr [ebp - local_8], ecx           # 00423c6d
L_00423c70:
    # block 0x00423c70: entered by jmp at 0x00423c65, 2 instruction(s), ends with jge to 0x00423d2f (forward)
    cmp dword ptr [ebp - local_8], 0xf0          # 00423c70
    jge.d32 L_00423d2f                           # 00423c77
    # block 0x00423c7d: entered by fall-through of jge at 0x00423c77, 37 instruction(s), ends with backward jump to 0x00423c67
    mov edx, dword ptr [ebp - local_8]           # 00423c7d
    imul edx, edx, 0x8d                          # 00423c80
    add edx, 0x5bb5e9                            # 00423c86
    mov dword ptr [ebp - local_4], edx           # 00423c8c
    mov eax, dword ptr [ebp - local_4]           # 00423c8f
    mov dword ptr [ebp - local_c], eax           # 00423c92
    mov ecx, dword ptr [ebp - local_4]           # 00423c95
    mov dword ptr [ecx + field_1c], 0x0          # 00423c98
    mov edx, dword ptr [ebp - local_4]           # 00423c9f
    mov dword ptr [edx + field_20], 0x0          # 00423ca2
    mov eax, dword ptr [ebp - local_4]           # 00423ca9
    mov dword ptr [eax + field_24], 0x0          # 00423cac
    mov ecx, dword ptr [ebp - local_4]           # 00423cb3
    mov dword ptr [ecx + field_28], 0x0          # 00423cb6
    mov edx, dword ptr [ebp - local_4]           # 00423cbd
    mov dword ptr [edx + field_2c], 0x0          # 00423cc0
    mov eax, dword ptr [ebp - local_4]           # 00423cc7
    mov dword ptr [eax + field_30], 0x0          # 00423cca
    mov ecx, dword ptr [ebp - local_4]           # 00423cd1
    mov dword ptr [ecx + field_34], 0x0          # 00423cd4
    mov edx, dword ptr [ebp - local_4]           # 00423cdb
    mov dword ptr [edx + field_38], 0x0          # 00423cde
    mov eax, dword ptr [ebp - local_c]           # 00423ce5
    mov dword ptr [eax], 0x0                     # 00423ce8
    mov ecx, dword ptr [ebp - local_c]           # 00423cee
    mov dword ptr [ecx + field_4], 0x0           # 00423cf1
    mov edx, dword ptr [ebp - local_c]           # 00423cf8
    mov dword ptr [edx + field_8], 0xffffffff    # 00423cfb
    mov eax, dword ptr [ebp - local_c]           # 00423d02
    mov dword ptr [eax + field_c], 0x0           # 00423d05
    mov ecx, dword ptr [ebp - local_c]           # 00423d0c
    mov dword ptr [ecx + field_10], 0x0          # 00423d0f
    mov edx, dword ptr [ebp - local_c]           # 00423d16
    mov dword ptr [edx + field_14], 0x0          # 00423d19
    mov eax, dword ptr [ebp - local_c]           # 00423d20
    mov dword ptr [eax + field_18], 0x0          # 00423d23
    jmp.d32 L_00423c67                           # 00423d2a
L_00423d2f:
    # block 0x00423d2f: entered by jge at 0x00423c77, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00423d2f
    pop ebp                                      # 00423d31
    ret                                          # 00423d32

