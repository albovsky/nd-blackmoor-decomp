# FUN_004e49e2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e49e2
# extent:       0x004e49e2-0x004e4a3a (88 code bytes)
# span:         0x004e49e2-0x004e4a3a (code 88, tables 0, padding 0)
# sha256:       f05668191b670b9ebf606ea4db82c77d2602717f5f5512919ab63f53f21bf05f
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e49e2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_6a5, field_53c1; [ecx + n] field_691; [edx + n] field_4, field_8, field_a
# callees:      calls FUN_004e354a, FUN_004e364a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_691, 0x691  # offset +0x691
.equ field_6a5, 0x6a5  # offset +0x6a5
.equ field_53c1, 0x53c1  # offset +0x53c1

# --- external targets -----------------------------------------------
.set FUN_004e354a, .text + (0x004e354a - 0x401000)
.set FUN_004e364a, .text + (0x004e364a - 0x401000)

.org 0x004e49e2 - 0x401000
.globl FUN_004e49e2
FUN_004e49e2:
    # block 0x004e49e2: entry, 24 instruction(s), calls FUN_004e354a, FUN_004e364a, ends with ret
    push ebp                                     # 004e49e2
    {load} mov ebp, esp                          # 004e49e3
    push ecx                                     # 004e49e5
    mov dword ptr [ebp - local_4], ecx           # 004e49e6
    mov eax, dword ptr [ebp - local_4]           # 004e49e9
    mov word ptr [eax + field_6a5], 0x0          # 004e49ec
    {load} xor ecx, ecx                          # 004e49f5
    mov edx, dword ptr [ebp - local_4]           # 004e49f7
    add edx, 0x6a7                               # 004e49fa
    mov dword ptr [edx], ecx                     # 004e4a00
    mov dword ptr [edx + field_4], ecx           # 004e4a02
    mov word ptr [edx + field_8], cx             # 004e4a05
    mov byte ptr [edx + field_a], cl             # 004e4a09
    mov eax, dword ptr [ebp - local_4]           # 004e4a0c
    mov dword ptr [eax + field_53c1], 0x0        # 004e4a0f
    mov ecx, dword ptr [ebp - local_4]           # 004e4a19
    mov dword ptr [ecx + field_691], 0x1         # 004e4a1c
    mov ecx, dword ptr [ebp - local_4]           # 004e4a26
    call FUN_004e354a                            # 004e4a29
    mov ecx, dword ptr [ebp - local_4]           # 004e4a2e
    call FUN_004e364a                            # 004e4a31
    {load} mov esp, ebp                          # 004e4a36
    pop ebp                                      # 004e4a38
    ret                                          # 004e4a39

