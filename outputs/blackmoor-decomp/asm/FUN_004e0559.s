# FUN_004e0559
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e0559
# extent:       0x004e0559-0x004e0619 (192 code bytes)
# span:         0x004e0559-0x004e0619 (code 192, tables 0, padding 0)
# sha256:       3588d6413d5da5a05d2f2b95f48f83c09d778652ca01c5c4d85d9345377831b1
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e0559
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_753; [edx + n] field_753
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_47_runtime.c:a47_step (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 43 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_753, 0x753  # offset +0x753

# --- external targets -----------------------------------------------

.org 0x004e0559 - 0x401000
.globl FUN_004e0559
FUN_004e0559:
    # block 0x004e0559: entry, 6 instruction(s), ends with je to 0x004e0595 (forward)
    push ebp                                     # 004e0559
    {load} mov ebp, esp                          # 004e055a
    push ecx                                     # 004e055c
    mov dword ptr [ebp - local_4], ecx           # 004e055d
    cmp dword ptr [ebp + arg_c], 0x0             # 004e0560
    je.d8 L_004e0595                             # 004e0564
    # block 0x004e0566: entered by fall-through of je at 0x004e0564, 8 instruction(s), ends with forward jump to 0x004e0613
    movsx eax, word ptr [ebp + arg_8]            # 004e0566
    imul eax, eax, 0x1a4                         # 004e056a
    mov dword ptr [eax + 0x5a17b4], 0x1          # 004e0570
    movsx ecx, word ptr [ebp + arg_8]            # 004e057a
    imul ecx, ecx, 0x1a4                         # 004e057e
    movsx edx, word ptr [ebp + arg_10]           # 004e0584
    mov dword ptr [ecx + 4*edx + 0x5a17b8], 0x1  # 004e0588
    jmp.d8 L_004e0613                            # 004e0593
L_004e0595:
    # block 0x004e0595: entered by je at 0x004e0564, 7 instruction(s), ends with forward jump to 0x004e05d2
    movsx eax, word ptr [ebp + arg_8]            # 004e0595
    imul eax, eax, 0x1a4                         # 004e0599
    movsx ecx, word ptr [ebp + arg_10]           # 004e059f
    mov dword ptr [eax + 4*ecx + 0x5a17b8], 0x0  # 004e05a3
    mov edx, dword ptr [ebp - local_4]           # 004e05ae
    mov dword ptr [edx + field_753], 0x0         # 004e05b1
    jmp.d8 L_004e05d2                            # 004e05bb
L_004e05bd:
    # block 0x004e05bd: entered by jmp at 0x004e05fd, 5 instruction(s), falls into the block at 0x004e05d2
    mov eax, dword ptr [ebp - local_4]           # 004e05bd
    mov ecx, dword ptr [eax + field_753]         # 004e05c0
    add ecx, 0x1                                 # 004e05c6
    mov edx, dword ptr [ebp - local_4]           # 004e05c9
    mov dword ptr [edx + field_753], ecx         # 004e05cc
L_004e05d2:
    # block 0x004e05d2: entered by jmp at 0x004e05bb, 3 instruction(s), ends with jge to 0x004e05ff (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e05d2
    cmp dword ptr [eax + field_753], 0x3         # 004e05d5
    jge.d8 L_004e05ff                            # 004e05dc
    # block 0x004e05de: entered by fall-through of jge at 0x004e05dc, 6 instruction(s), ends with jne to 0x004e05fd (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004e05de
    imul ecx, ecx, 0x1a4                         # 004e05e2
    mov edx, dword ptr [ebp - local_4]           # 004e05e8
    mov eax, dword ptr [edx + field_753]         # 004e05eb
    cmp dword ptr [ecx + 4*eax + 0x5a17b8], 0x1  # 004e05f1
    jne.d8 L_004e05fd                            # 004e05f9
    # block 0x004e05fb: entered by fall-through of jne at 0x004e05f9, 1 instruction(s), ends with forward jump to 0x004e0613
    jmp.d8 L_004e0613                            # 004e05fb
L_004e05fd:
    # block 0x004e05fd: entered by jne at 0x004e05f9, 1 instruction(s), ends with backward jump to 0x004e05bd
    jmp.d8 L_004e05bd                            # 004e05fd
L_004e05ff:
    # block 0x004e05ff: entered by jge at 0x004e05dc, 3 instruction(s), falls into the block at 0x004e0613
    movsx ecx, word ptr [ebp + arg_8]            # 004e05ff
    imul ecx, ecx, 0x1a4                         # 004e0603
    mov dword ptr [ecx + 0x5a17b4], 0x0          # 004e0609
L_004e0613:
    # block 0x004e0613: entered by jmp at 0x004e0593; jmp at 0x004e05fb, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004e0613
    pop ebp                                      # 004e0615
    ret 0xc                                      # 004e0616

