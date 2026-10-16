# FUN_004cc79a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cc79a
# extent:       0x004cc79a-0x004cc87b (225 code bytes)
# span:         0x004cc79a-0x004cc880 (code 225, tables 0, padding 5)
# sha256:       78370978db560fe2da87a4f817f771b648ad5206f897d09217d4019737cd1dc1
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cc79a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_4, field_9, field_10; [ecx + n] field_9, field_c; [edx + n] field_2, field_8, field_9
# callees:      calls FUN_004c7623
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 61 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_9, 0x9  # offset +0x9
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_004c7623, .text + (0x004c7623 - 0x401000)

.org 0x004cc79a - 0x401000
.globl FUN_004cc79a
FUN_004cc79a:
    # block 0x004cc79a: entry, 8 instruction(s), ends with je to 0x004cc877 (forward)
    push ebp                                     # 004cc79a
    {load} mov ebp, esp                          # 004cc79b
    sub esp, 0x1c                                # 004cc79d
    mov word ptr [ebp - local_4], 0x10           # 004cc7a0
    mov eax, dword ptr [0x63848d]                # 004cc7a6
    mov dword ptr [ebp - local_8], eax           # 004cc7ab
    cmp dword ptr [0x638483], 0x0                # 004cc7ae
    je.d32 L_004cc877                            # 004cc7b5
    # block 0x004cc7bb: entered by fall-through of je at 0x004cc7b5, 2 instruction(s), ends with forward jump to 0x004cc7cd
    mov dword ptr [ebp - local_1c], 0x0          # 004cc7bb
    jmp.d8 L_004cc7cd                            # 004cc7c2
L_004cc7c4:
    # block 0x004cc7c4: entered by jmp at 0x004cc868, 3 instruction(s), falls into the block at 0x004cc7cd
    mov ecx, dword ptr [ebp - local_1c]          # 004cc7c4
    add ecx, 0x1                                 # 004cc7c7
    mov dword ptr [ebp - local_1c], ecx          # 004cc7ca
L_004cc7cd:
    # block 0x004cc7cd: entered by jmp at 0x004cc7c2, 4 instruction(s), ends with jge to 0x004cc86d (forward)
    mov edx, dword ptr [ebp - local_8]           # 004cc7cd
    movsx eax, word ptr [edx + field_2]          # 004cc7d0
    cmp dword ptr [ebp - local_1c], eax          # 004cc7d4
    jge.d32 L_004cc86d                           # 004cc7d7
    # block 0x004cc7dd: entered by fall-through of jge at 0x004cc7d7, 40 instruction(s), calls FUN_004c7623, ends with backward jump to 0x004cc7c4
    mov ecx, dword ptr [ebp - local_1c]          # 004cc7dd
    imul ecx, ecx, 0x18                          # 004cc7e0
    mov edx, dword ptr [ebp - local_8]           # 004cc7e3
    mov eax, dword ptr [edx + field_9]           # 004cc7e6
    mov ecx, dword ptr [eax + ecx + field_4]     # 004cc7e9
    add ecx, dword ptr [0x583186]                # 004cc7ed
    mov dword ptr [ebp - local_18], ecx          # 004cc7f3
    mov edx, dword ptr [ebp - local_1c]          # 004cc7f6
    imul edx, edx, 0x18                          # 004cc7f9
    mov eax, dword ptr [ebp - local_8]           # 004cc7fc
    mov ecx, dword ptr [eax + field_9]           # 004cc7ff
    mov edx, dword ptr [ecx + edx + field_c]     # 004cc802
    add edx, dword ptr [0x583186]                # 004cc806
    mov dword ptr [ebp - local_10], edx          # 004cc80c
    mov eax, dword ptr [ebp - local_1c]          # 004cc80f
    imul eax, eax, 0x18                          # 004cc812
    mov ecx, dword ptr [ebp - local_8]           # 004cc815
    mov edx, dword ptr [ecx + field_9]           # 004cc818
    mov eax, dword ptr [edx + eax + field_8]     # 004cc81b
    add eax, dword ptr [0x58318a]                # 004cc81f
    mov dword ptr [ebp - local_14], eax          # 004cc825
    mov ecx, dword ptr [ebp - local_1c]          # 004cc828
    imul ecx, ecx, 0x18                          # 004cc82b
    mov edx, dword ptr [ebp - local_8]           # 004cc82e
    mov eax, dword ptr [edx + field_9]           # 004cc831
    mov ecx, dword ptr [eax + ecx + field_10]    # 004cc834
    add ecx, dword ptr [0x58318a]                # 004cc838
    mov dword ptr [ebp - local_c], ecx           # 004cc83e
    mov dx, word ptr [ebp - local_4]             # 004cc841
    push edx                                     # 004cc845
    lea eax, [ebp - local_18]                    # 004cc846
    push eax                                     # 004cc849
    mov ecx, dword ptr [0x5cf665]                # 004cc84a
    push ecx                                     # 004cc850
    mov ecx, 0x5cf659                            # 004cc851
    call FUN_004c7623                            # 004cc856
    mov dx, word ptr [ebp - local_4]             # 004cc85b
    .insn 0x6681/0, edx, 1024{:s16}              # 004cc85f
    mov word ptr [ebp - local_4], dx             # 004cc864
    jmp.d32 L_004cc7c4                           # 004cc868
L_004cc86d:
    # block 0x004cc86d: entered by jge at 0x004cc7d7, 1 instruction(s), falls into the block at 0x004cc877
    mov dword ptr [0x638483], 0x0                # 004cc86d
L_004cc877:
    # block 0x004cc877: entered by je at 0x004cc7b5, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004cc877
    pop ebp                                      # 004cc879
    ret                                          # 004cc87a

# --- data items (not part of the function) -------------------------
.org 0x004cc87b - 0x401000
PAD_004cc87b:  # 5 byte(s) of int3 padding
    .fill 5, 1, 0xcc

