# FUN_004e7970
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7970
# extent:       0x004e7970-0x004e79ca (90 code bytes)
# span:         0x004e7970-0x004e79ca (code 90, tables 0, padding 0)
# sha256:       add65266e22e905672c2a797c04caa6e81883c7c173a011555ca66b119514f5a
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e7970
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_991
# callees:      calls FUN_004ee6c7, FUN_004e7757, FUN_004d3137
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_004d3137, .text + (0x004d3137 - 0x401000)
.set FUN_004e7757, .text + (0x004e7757 - 0x401000)
.set FUN_004ee6c7, .text + (0x004ee6c7 - 0x401000)

.org 0x004e7970 - 0x401000
.globl FUN_004e7970
FUN_004e7970:
    # block 0x004e7970: entry, 9 instruction(s), ends with je to 0x004e7993 (forward)
    push ebp                                     # 004e7970
    {load} mov ebp, esp                          # 004e7971
    sub esp, 0x8                                 # 004e7973
    mov dword ptr [ebp - local_4], ecx           # 004e7976
    mov eax, dword ptr [ebp - local_4]           # 004e7979
    mov ecx, dword ptr [eax + field_991]         # 004e797c
    mov dword ptr [ebp - local_8], ecx           # 004e7982
    cmp dword ptr [ebp - local_8], 0x2           # 004e7985
    je.d8 L_004e7993                             # 004e7989
    # block 0x004e798b: entered by fall-through of je at 0x004e7989, 2 instruction(s), ends with je to 0x004e79b0 (forward)
    cmp dword ptr [ebp - local_8], 0x3           # 004e798b
    je.d8 L_004e79b0                             # 004e798f
    # block 0x004e7991: entered by fall-through of je at 0x004e798f, 1 instruction(s), ends with forward jump to 0x004e79c6
    jmp.d8 L_004e79c6                            # 004e7991
L_004e7993:
    # block 0x004e7993: entered by je at 0x004e7989, 5 instruction(s), calls FUN_004ee6c7, ends with jne to 0x004e79a9 (forward)
    push 0x1                                     # 004e7993
    mov ecx, dword ptr [ebp - local_4]           # 004e7995
    call FUN_004ee6c7                            # 004e7998
    test eax, eax                                # 004e799d
    jne.d8 L_004e79a9                            # 004e799f
    # block 0x004e79a1: entered by fall-through of jne at 0x004e799f, 2 instruction(s), calls FUN_004e7757, falls into the block at 0x004e79a9
    mov ecx, dword ptr [ebp - local_4]           # 004e79a1
    call FUN_004e7757                            # 004e79a4
L_004e79a9:
    # block 0x004e79a9: entered by jne at 0x004e799f, 2 instruction(s), calls FUN_004d3137, ends with forward jump to 0x004e79c6
    call FUN_004d3137                            # 004e79a9
    jmp.d8 L_004e79c6                            # 004e79ae
L_004e79b0:
    # block 0x004e79b0: entered by je at 0x004e798f, 5 instruction(s), calls FUN_004ee6c7, ends with jne to 0x004e79c6 (forward)
    push 0x1                                     # 004e79b0
    mov ecx, dword ptr [ebp - local_4]           # 004e79b2
    call FUN_004ee6c7                            # 004e79b5
    test eax, eax                                # 004e79ba
    jne.d8 L_004e79c6                            # 004e79bc
    # block 0x004e79be: entered by fall-through of jne at 0x004e79bc, 2 instruction(s), calls FUN_004e7757, falls into the block at 0x004e79c6
    mov ecx, dword ptr [ebp - local_4]           # 004e79be
    call FUN_004e7757                            # 004e79c1
L_004e79c6:
    # block 0x004e79c6: entered by jmp at 0x004e7991; jmp at 0x004e79ae; jne at 0x004e79bc, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e79c6
    pop ebp                                      # 004e79c8
    ret                                          # 004e79c9

