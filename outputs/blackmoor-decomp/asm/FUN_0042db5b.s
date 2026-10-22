# FUN_0042db5b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042db5b
# extent:       0x0042db5b-0x0042dbe1 (134 code bytes)
# span:         0x0042db5b-0x0042dbe1 (code 134, tables 0, padding 0)
# sha256:       58396f1a48822b629675f7a7393260c04462101e253f7dae2d3dfe637700bb00
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042db5b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_6d; [ecx + n] field_2; [edx + n] field_2
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m42db5b_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 42 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6d, 0x6d  # offset +0x6d

# --- external targets -----------------------------------------------

.org 0x0042db5b - 0x401000
.globl FUN_0042db5b
FUN_0042db5b:
    # block 0x0042db5b: entry, 5 instruction(s), ends with je to 0x0042db77 (forward)
    push ebp                                     # 0042db5b
    {load} mov ebp, esp                          # 0042db5c
    sub esp, 0x8                                 # 0042db5e
    cmp dword ptr [0x5b511c], 0x0                # 0042db61
    je.d8 L_0042db77                             # 0042db68
    # block 0x0042db6a: entered by fall-through of je at 0x0042db68, 4 instruction(s), ends with jne to 0x0042db79 (forward)
    mov eax, dword ptr [0x5b5124]                # 0042db6a
    movsx ecx, word ptr [eax + field_6d]         # 0042db6f
    test ecx, ecx                                # 0042db73
    jne.d8 L_0042db79                            # 0042db75
L_0042db77:
    # block 0x0042db77: entered by je at 0x0042db68; fall-through of jne at 0x0042db75, 1 instruction(s), ends with forward jump to 0x0042dbdd
    jmp.d8 L_0042dbdd                            # 0042db77
L_0042db79:
    # block 0x0042db79: entered by jne at 0x0042db75, 2 instruction(s), ends with forward jump to 0x0042db8b
    mov dword ptr [ebp - local_4], 0x0           # 0042db79
    jmp.d8 L_0042db8b                            # 0042db80
L_0042db82:
    # block 0x0042db82: entered by jmp at 0x0042dbdb, 3 instruction(s), falls into the block at 0x0042db8b
    mov edx, dword ptr [ebp - local_4]           # 0042db82
    add edx, 0x1                                 # 0042db85
    mov dword ptr [ebp - local_4], edx           # 0042db88
L_0042db8b:
    # block 0x0042db8b: entered by jmp at 0x0042db80, 4 instruction(s), ends with jge to 0x0042dbdd (forward)
    mov eax, dword ptr [0x5b5124]                # 0042db8b
    movsx ecx, word ptr [eax + field_6d]         # 0042db90
    cmp dword ptr [ebp - local_4], ecx           # 0042db94
    jge.d8 L_0042dbdd                            # 0042db97
    # block 0x0042db99: entered by fall-through of jge at 0x0042db97, 9 instruction(s), ends with je to 0x0042dbdb (forward)
    mov edx, dword ptr [ebp - local_4]           # 0042db99
    imul edx, edx, 0x6                           # 0042db9c
    mov eax, dword ptr [0x5b511c]                # 0042db9f
    {load} add eax, edx                          # 0042dba4
    mov dword ptr [ebp - local_8], eax           # 0042dba6
    mov ecx, dword ptr [ebp - local_8]           # 0042dba9
    movsx edx, word ptr [ecx + field_2]          # 0042dbac
    cmp edx, -0x1                                # 0042dbb0
    je.d8 L_0042dbdb                             # 0042dbb3
    # block 0x0042dbb5: entered by fall-through of je at 0x0042dbb3, 5 instruction(s), ends with jne to 0x0042dbdb (forward)
    mov eax, dword ptr [ebp - local_8]           # 0042dbb5
    movsx ecx, word ptr [eax]                    # 0042dbb8
    movsx edx, word ptr [0x5b5077]               # 0042dbbb
    {load} cmp ecx, edx                          # 0042dbc2
    jne.d8 L_0042dbdb                            # 0042dbc4
    # block 0x0042dbc6: entered by fall-through of jne at 0x0042dbc4, 5 instruction(s), falls into the block at 0x0042dbdb
    mov eax, dword ptr [ebp - local_8]           # 0042dbc6
    movsx ecx, word ptr [eax + field_4]          # 0042dbc9
    mov edx, dword ptr [ebp - local_8]           # 0042dbcd
    movsx eax, word ptr [edx + field_2]          # 0042dbd0
    mov dword ptr [4*eax + 0x585801], ecx        # 0042dbd4
L_0042dbdb:
    # block 0x0042dbdb: entered by je at 0x0042dbb3; jne at 0x0042dbc4, 1 instruction(s), ends with backward jump to 0x0042db82
    jmp.d8 L_0042db82                            # 0042dbdb
L_0042dbdd:
    # block 0x0042dbdd: entered by jmp at 0x0042db77; jge at 0x0042db97, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0042dbdd
    pop ebp                                      # 0042dbdf
    ret                                          # 0042dbe0

