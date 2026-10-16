# FUN_0047823e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047823e
# extent:       0x0047823e-0x00478287 (73 code bytes)
# span:         0x0047823e-0x00478287 (code 73, tables 0, padding 0)
# sha256:       e00fd1b7c62ef8b122c98d6c44e758b947e891e0632e7459e74fcc3bd52c6428
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047823e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004781fa
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_004781fa, .text + (0x004781fa - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0047823e - 0x401000
.globl FUN_0047823e
FUN_0047823e:
    # block 0x0047823e: entry, 7 instruction(s), ends with je to 0x0047825f (forward)
    push ebp                                     # 0047823e
    {load} mov ebp, esp                          # 0047823f
    push ecx                                     # 00478241
    mov dword ptr [ebp - local_4], ecx           # 00478242
    mov eax, dword ptr [ebp - local_4]           # 00478245
    cmp dword ptr [eax + field_20], 0x0          # 00478248
    je.d8 L_0047825f                             # 0047824c
    # block 0x0047824e: entered by fall-through of je at 0x0047824c, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0047825f
    mov ecx, dword ptr [ebp - local_4]           # 0047824e
    add ecx, 0x20                                # 00478251
    push ecx                                     # 00478254
    mov ecx, 0x5cf659                            # 00478255
    call FUN_004c2dfb                            # 0047825a
L_0047825f:
    # block 0x0047825f: entered by je at 0x0047824c, 4 instruction(s), ends with je to 0x0047827b (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047825f
    movsx eax, word ptr [edx + field_1c]         # 00478262
    cmp eax, -0x1                                # 00478266
    je.d8 L_0047827b                             # 00478269
    # block 0x0047826b: entered by fall-through of je at 0x00478269, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0047827b
    mov ecx, dword ptr [ebp - local_4]           # 0047826b
    mov dx, word ptr [ecx + field_1c]            # 0047826e
    push edx                                     # 00478272
    call FUN_004d3992                            # 00478273
    add esp, 0x4                                 # 00478278
L_0047827b:
    # block 0x0047827b: entered by je at 0x00478269, 5 instruction(s), calls FUN_004781fa, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0047827b
    call FUN_004781fa                            # 0047827e
    {load} mov esp, ebp                          # 00478283
    pop ebp                                      # 00478285
    ret                                          # 00478286

