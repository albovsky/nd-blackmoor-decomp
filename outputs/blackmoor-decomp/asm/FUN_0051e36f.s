# FUN_0051e36f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e36f
# extent:       0x0051e36f-0x0051e3c5 (86 code bytes)
# span:         0x0051e36f-0x0051e3c5 (code 86, tables 0, padding 0)
# sha256:       6e1645435b6484c45816966eb2584db58906716fa7d4e6d915b2c4e584fdb480
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e36f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_8
# fields:       [eax + n] field_4; [edx + n] field_c
# callees:      calls FUN_00525371, FUN_0050c193; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051e3c5
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050c193, .text + (0x0050c193 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051e36f - 0x401000
.globl FUN_0051e36f
FUN_0051e36f:
    # block 0x0051e36f: entry, 10 instruction(s), calls FUN_00525371, ends with jne to 0x0051e386 (forward)
    push ebp                                     # 0051e36f
    {load} mov ebp, esp                          # 0051e370
    push ecx                                     # 0051e372
    push ecx                                     # 0051e373
    push esi                                     # 0051e374
    push edi                                     # 0051e375
    call FUN_00525371                            # 0051e376
    {load} xor edi, edi                          # 0051e37b
    cmp dword ptr [eax + field_4], edi           # 0051e37d
    jne.d8 L_0051e386                            # 0051e380
    # block 0x0051e382: entered by fall-through of jne at 0x0051e380, 2 instruction(s), ends with forward jump to 0x0051e3c1
    {load} xor eax, eax                          # 0051e382
    jmp.d8 L_0051e3c1                            # 0051e384
L_0051e386:
    # block 0x0051e386: entered by jne at 0x0051e380, 4 instruction(s), calls FUN_0050c193, ends with je to 0x0051e3ab (forward)
    call FUN_0050c193                            # 0051e386
    {load} cmp eax, edi                          # 0051e38b
    mov esi, 0xe146                              # 0051e38d
    je.d8 L_0051e3ab                             # 0051e392
    # block 0x0051e394: entered by fall-through of je at 0x0051e392, 10 instruction(s), calls indirect dword ptr [edx + 0xc], ends with je to 0x0051e3ab (forward)
    mov edx, dword ptr [eax]                     # 0051e394
    lea ecx, [ebp - local_8]                     # 0051e396
    push ecx                                     # 0051e399
    push edi                                     # 0051e39a
    push edi                                     # 0051e39b
    push esi                                     # 0051e39c
    {load} mov ecx, eax                          # 0051e39d
    call dword ptr [edx + field_c]               # 0051e39f
    test eax, eax                                # 0051e3a2
    je.d8 L_0051e3ab                             # 0051e3a4
    # block 0x0051e3a6: entered by fall-through of je at 0x0051e3a4, 3 instruction(s), ends with forward jump to 0x0051e3c1
    push 0x1                                     # 0051e3a6
    pop eax                                      # 0051e3a8
    jmp.d8 L_0051e3c1                            # 0051e3a9
L_0051e3ab:
    # block 0x0051e3ab: entered by je at 0x0051e392; je at 0x0051e3a4, 10 instruction(s), calls FUN_00525371, indirect dword ptr [edx + 0xc], falls into the block at 0x0051e3c1
    call FUN_00525371                            # 0051e3ab
    mov eax, dword ptr [eax + field_4]           # 0051e3b0
    lea ecx, [ebp - local_8]                     # 0051e3b3
    push ecx                                     # 0051e3b6
    push edi                                     # 0051e3b7
    mov edx, dword ptr [eax]                     # 0051e3b8
    push edi                                     # 0051e3ba
    push esi                                     # 0051e3bb
    {load} mov ecx, eax                          # 0051e3bc
    call dword ptr [edx + field_c]               # 0051e3be
L_0051e3c1:
    # block 0x0051e3c1: entered by jmp at 0x0051e384; jmp at 0x0051e3a9, 4 instruction(s), ends with ret
    pop edi                                      # 0051e3c1
    pop esi                                      # 0051e3c2
    leave                                        # 0051e3c3
    ret                                          # 0051e3c4

