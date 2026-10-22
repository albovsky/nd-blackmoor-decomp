# FUN_00423af1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423af1
# extent:       0x00423af1-0x00423b51 (96 code bytes)
# span:         0x00423af1-0x00423b51 (code 96, tables 0, padding 0)
# sha256:       9e3c7d9a3d8c0743f3fe63ceefb427ca2cc5a19110c1ea7933aaac7f36e400c5
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_dependency_delete_all
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/423af1.c.txt, not original source) refers to the data labelled s_CDependency__DeleteAll___00544858
# name-note:    CDependency::DeleteAll: loops over 0xf0 entries calling FUN_00423b51 on each.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_00423b51
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m423af1_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_00423b51, .text + (0x00423b51 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x00423af1 - 0x401000
.globl FUN_00423af1
FUN_00423af1:
    # block 0x00423af1: entry, 7 instruction(s), ends with je to 0x00423b24 (forward)
    push ebp                                     # 00423af1
    {load} mov ebp, esp                          # 00423af2
    sub esp, 0x8                                 # 00423af4
    mov dword ptr [ebp - local_8], ecx           # 00423af7
    movsx eax, word ptr [0x63a4cd]               # 00423afa
    test eax, eax                                # 00423b01
    je.d8 L_00423b24                             # 00423b03
    # block 0x00423b05: entered by fall-through of je at 0x00423b03, 7 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00423b24
    push 0x544858                                # 00423b05
    push 0x63888b                                # 00423b0a
    call FUN_0050ca3e                            # 00423b0f
    add esp, 0x8                                 # 00423b14
    push 0x63888b                                # 00423b17
    call FUN_0044a2b7                            # 00423b1c
    add esp, 0x4                                 # 00423b21
L_00423b24:
    # block 0x00423b24: entered by je at 0x00423b03, 2 instruction(s), ends with forward jump to 0x00423b36
    mov dword ptr [ebp - local_4], 0x0           # 00423b24
    jmp.d8 L_00423b36                            # 00423b2b
L_00423b2d:
    # block 0x00423b2d: entered by jmp at 0x00423b4b, 3 instruction(s), falls into the block at 0x00423b36
    mov ecx, dword ptr [ebp - local_4]           # 00423b2d
    add ecx, 0x1                                 # 00423b30
    mov dword ptr [ebp - local_4], ecx           # 00423b33
L_00423b36:
    # block 0x00423b36: entered by jmp at 0x00423b2b, 2 instruction(s), ends with jge to 0x00423b4d (forward)
    cmp dword ptr [ebp - local_4], 0xf0          # 00423b36
    jge.d8 L_00423b4d                            # 00423b3d
    # block 0x00423b3f: entered by fall-through of jge at 0x00423b3d, 5 instruction(s), calls FUN_00423b51, ends with backward jump to 0x00423b2d
    mov edx, dword ptr [ebp - local_4]           # 00423b3f
    push edx                                     # 00423b42
    mov ecx, dword ptr [ebp - local_8]           # 00423b43
    call FUN_00423b51                            # 00423b46
    jmp.d8 L_00423b2d                            # 00423b4b
L_00423b4d:
    # block 0x00423b4d: entered by jge at 0x00423b3d, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00423b4d
    pop ebp                                      # 00423b4f
    ret                                          # 00423b50

