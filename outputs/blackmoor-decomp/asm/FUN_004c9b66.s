# FUN_004c9b66
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c9b66
# extent:       0x004c9b66-0x004c9c10 (170 code bytes)
# span:         0x004c9b66-0x004c9c10 (code 170, tables 0, padding 0)
# sha256:       836091d83c0ba302b4f06642a1321354eb96b5c8feef642656db841547e2ac56
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_display_file_reader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4c9b66.c.txt, not original source) refers to the data labelled s_display_00557c9c
# name-note:    Opens the display file and reads a 0x1764-byte block into the object, setting a loaded flag; the file name is the display string.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1f34; [edx + n] field_1f28
# callees:      calls FUN_0050cd72, FUN_0050d0a9, FUN_0050cf61, FUN_0050cee4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1f28, 0x1f28  # offset +0x1f28
.equ field_1f34, 0x1f34  # offset +0x1f34

# --- external targets -----------------------------------------------
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)

.org 0x004c9b66 - 0x401000
.globl FUN_004c9b66
FUN_004c9b66:
    # block 0x004c9b66: entry, 20 instruction(s), calls FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x004c9bbc (forward)
    push ebp                                     # 004c9b66
    {load} mov ebp, esp                          # 004c9b67
    sub esp, 0x8                                 # 004c9b69
    mov dword ptr [ebp - local_8], ecx           # 004c9b6c
    mov eax, dword ptr [ebp - local_8]           # 004c9b6f
    mov dword ptr [eax + field_1f34], 0x0        # 004c9b72
    push 0x557c94                                # 004c9b7c
    push 0x557c9c                                # 004c9b81
    push 0x639aa2                                # 004c9b86
    push 0x639a9f                                # 004c9b8b
    push 0x63888b                                # 004c9b90
    call FUN_0050cd72                            # 004c9b95
    add esp, 0x14                                # 004c9b9a
    push 0x557ca4                                # 004c9b9d
    push 0x63888b                                # 004c9ba2
    call FUN_0050d0a9                            # 004c9ba7
    add esp, 0x8                                 # 004c9bac
    mov dword ptr [ebp - local_4], eax           # 004c9baf
    cmp dword ptr [ebp - local_4], 0x0           # 004c9bb2
    jne.d8 L_004c9bbc                            # 004c9bb6
    # block 0x004c9bb8: entered by fall-through of jne at 0x004c9bb6, 2 instruction(s), ends with forward jump to 0x004c9c0c
    {load} xor eax, eax                          # 004c9bb8
    jmp.d8 L_004c9c0c                            # 004c9bba
L_004c9bbc:
    # block 0x004c9bbc: entered by jne at 0x004c9bb6, 11 instruction(s), calls FUN_0050cf61, ends with je to 0x004c9bee (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004c9bbc
    push ecx                                     # 004c9bbf
    push 0x1                                     # 004c9bc0
    push 0x1764                                  # 004c9bc2
    mov edx, dword ptr [ebp - local_8]           # 004c9bc7
    mov eax, dword ptr [edx + field_1f28]        # 004c9bca
    push eax                                     # 004c9bd0
    call FUN_0050cf61                            # 004c9bd1
    add esp, 0x10                                # 004c9bd6
    cmp eax, 0x1                                 # 004c9bd9
    je.d8 L_004c9bee                             # 004c9bdc
    # block 0x004c9bde: entered by fall-through of je at 0x004c9bdc, 6 instruction(s), calls FUN_0050cee4, ends with forward jump to 0x004c9c0c
    mov ecx, dword ptr [ebp - local_4]           # 004c9bde
    push ecx                                     # 004c9be1
    call FUN_0050cee4                            # 004c9be2
    add esp, 0x4                                 # 004c9be7
    {load} xor eax, eax                          # 004c9bea
    jmp.d8 L_004c9c0c                            # 004c9bec
L_004c9bee:
    # block 0x004c9bee: entered by je at 0x004c9bdc, 7 instruction(s), calls FUN_0050cee4, falls into the block at 0x004c9c0c
    mov edx, dword ptr [ebp - local_4]           # 004c9bee
    push edx                                     # 004c9bf1
    call FUN_0050cee4                            # 004c9bf2
    add esp, 0x4                                 # 004c9bf7
    mov eax, dword ptr [ebp - local_8]           # 004c9bfa
    mov dword ptr [eax + field_1f34], 0x1        # 004c9bfd
    mov eax, 0x1                                 # 004c9c07
L_004c9c0c:
    # block 0x004c9c0c: entered by jmp at 0x004c9bba; jmp at 0x004c9bec, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004c9c0c
    pop ebp                                      # 004c9c0e
    ret                                          # 004c9c0f

