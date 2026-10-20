# FUN_004b2a9e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b2a9e
# extent:       0x004b2a9e-0x004b2c32 (404 code bytes)
# span:         0x004b2a9e-0x004b2c32 (code 404, tables 0, padding 0)
# sha256:       fd8b4da13e9aea0341c81505f4fac7c14e23640ce3e11a20d1039ff455c886ce
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b2a9e_click_2792_2793
# naming:       native port src/original_methods_fl23b.c:m4b2a9e_click_2792_2793 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4b2a9e_click_2792_2793 (guards, record-state compare, selector arms, callees via host). Direct: matrix and arms. Unicorn differential and oracle: 224 fixtures, every instruction reached. See tasks/fl23b-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_24, field_1515, field_1535; [ecx + n] field_295, field_2f7, field_151d, field_1531, field_1537; [edx + n] field_24, field_1510, field_1519
# callees:      calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23b.c:m4b2a9e_click_2792_2793 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 97 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_295, 0x295  # offset +0x295
.equ field_2f7, 0x2f7  # offset +0x2f7
.equ field_1510, 0x1510  # offset +0x1510
.equ field_1515, 0x1515  # offset +0x1515
.equ field_1519, 0x1519  # offset +0x1519
.equ field_151d, 0x151d  # offset +0x151d
.equ field_1531, 0x1531  # offset +0x1531
.equ field_1535, 0x1535  # offset +0x1535
.equ field_1537, 0x1537  # offset +0x1537

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x004b2a9e - 0x401000
.globl FUN_004b2a9e
FUN_004b2a9e:
    # block 0x004b2a9e: entry, 14 instruction(s), ends with je to 0x004b2c2c (forward)
    push ebp                                     # 004b2a9e
    {load} mov ebp, esp                          # 004b2a9f
    sub esp, 0x8                                 # 004b2aa1
    push esi                                     # 004b2aa4
    push edi                                     # 004b2aa5
    mov dword ptr [ebp - local_8], ecx           # 004b2aa6
    mov eax, dword ptr [ebp - local_8]           # 004b2aa9
    movsx ecx, word ptr [eax + field_1e]         # 004b2aac
    imul ecx, ecx, 0x8d                          # 004b2ab0
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b2ab6
    mov dword ptr [ebp - local_4], edx           # 004b2abc
    mov eax, dword ptr [ebp - local_8]           # 004b2abf
    cmp dword ptr [eax + field_1515], 0x0        # 004b2ac2
    je.d32 L_004b2c2c                            # 004b2ac9
    # block 0x004b2acf: entered by fall-through of je at 0x004b2ac9, 3 instruction(s), ends with jne to 0x004b2c2c (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004b2acf
    cmp dword ptr [ecx + field_151d], 0x0        # 004b2ad2
    jne.d32 L_004b2c2c                           # 004b2ad9
    # block 0x004b2adf: entered by fall-through of jne at 0x004b2ad9, 3 instruction(s), ends with jne to 0x004b2c2c (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b2adf
    cmp dword ptr [edx + field_24], 0x0          # 004b2ae2
    jne.d32 L_004b2c2c                           # 004b2ae6
    # block 0x004b2aec: entered by fall-through of jne at 0x004b2ae6, 5 instruction(s), ends with jne to 0x004b2c2c (forward)
    mov eax, dword ptr [ebp - local_8]           # 004b2aec
    movsx ecx, word ptr [eax + field_1e]         # 004b2aef
    imul ecx, ecx, 0x8d                          # 004b2af3
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 004b2af9
    jne.d32 L_004b2c2c                           # 004b2b00
    # block 0x004b2b06: entered by fall-through of jne at 0x004b2b00, 2 instruction(s), ends with jne to 0x004b2b3b (forward)
    cmp dword ptr [0x5c39e5], 0x2793             # 004b2b06
    jne.d8 L_004b2b3b                            # 004b2b10
    # block 0x004b2b12: entered by fall-through of jne at 0x004b2b10, 7 instruction(s), ends with forward jump to 0x004b2c18
    mov edx, dword ptr [ebp - local_8]           # 004b2b12
    mov dword ptr [edx + field_1519], 0x1        # 004b2b15
    mov eax, dword ptr [ebp - local_8]           # 004b2b1f
    movsx ecx, word ptr [eax + field_1e]         # 004b2b22
    imul ecx, ecx, 0x8d                          # 004b2b26
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004b2b2c
    jmp.d32 L_004b2c18                           # 004b2b36
L_004b2b3b:
    # block 0x004b2b3b: entered by jne at 0x004b2b10, 2 instruction(s), ends with jne to 0x004b2bbb (forward)
    cmp dword ptr [0x5c39e5], 0x2792             # 004b2b3b
    jne.d8 L_004b2bbb                            # 004b2b45
    # block 0x004b2b47: entered by fall-through of jne at 0x004b2b45, 2 instruction(s), ends with je to 0x004b2b91 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 004b2b47
    je.d8 L_004b2b91                             # 004b2b4e
    # block 0x004b2b50: entered by fall-through of je at 0x004b2b4e, 7 instruction(s), ends with je to 0x004b2b91 (forward)
    mov edi, 0x551764                            # 004b2b50
    mov esi, dword ptr [ebp - local_4]           # 004b2b55
    add esi, 0x2d6                               # 004b2b58
    mov ecx, 0x9                                 # 004b2b5e
    {load} xor edx, edx                          # 004b2b63
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b2b65
    je.d8 L_004b2b91                             # 004b2b67
    # block 0x004b2b69: entered by fall-through of je at 0x004b2b67, 10 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004b2b91
    mov eax, dword ptr [ebp - local_4]           # 004b2b69
    add eax, 0x2d6                               # 004b2b6c
    push eax                                     # 004b2b71
    mov ecx, 0x5c3a67                            # 004b2b72
    call FUN_004fb77a                            # 004b2b77
    mov ecx, dword ptr [ebp - local_4]           # 004b2b7c
    mov dx, word ptr [ecx + field_2f7]           # 004b2b7f
    push edx                                     # 004b2b86
    mov ecx, 0x5c3a67                            # 004b2b87
    call FUN_004fb2e3                            # 004b2b8c
L_004b2b91:
    # block 0x004b2b91: entered by je at 0x004b2b4e; je at 0x004b2b67, 9 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004b2c18
    call dword ptr [0x52a23c]                    # 004b2b91
    add eax, 0x1f4                               # 004b2b97
    mov ecx, dword ptr [ebp - local_8]           # 004b2b9c
    mov dword ptr [ecx + field_1537], eax        # 004b2b9f
    mov edx, dword ptr [ebp - local_8]           # 004b2ba5
    mov byte ptr [edx + field_1510], 0x1         # 004b2ba8
    mov eax, dword ptr [ebp - local_8]           # 004b2baf
    mov dword ptr [eax + field_24], 0x3          # 004b2bb2
    jmp.d8 L_004b2c18                            # 004b2bb9
L_004b2bbb:
    # block 0x004b2bbb: entered by jne at 0x004b2b45, 4 instruction(s), ends with je to 0x004b2c18 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004b2bbb
    movsx edx, word ptr [ecx + field_1531]       # 004b2bbe
    test edx, edx                                # 004b2bc5
    je.d8 L_004b2c18                             # 004b2bc7
    # block 0x004b2bc9: entered by fall-through of je at 0x004b2bc7, 6 instruction(s), ends with je to 0x004b2c18 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004b2bc9
    mov dword ptr [eax + field_24], 0x2          # 004b2bcc
    mov ecx, dword ptr [ebp - local_8]           # 004b2bd3
    movsx edx, word ptr [ecx + field_1531]       # 004b2bd6
    test edx, edx                                # 004b2bdd
    je.d8 L_004b2c18                             # 004b2bdf
    # block 0x004b2be1: entered by fall-through of je at 0x004b2bdf, 2 instruction(s), ends with je to 0x004b2c18 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 004b2be1
    je.d8 L_004b2c18                             # 004b2be8
    # block 0x004b2bea: entered by fall-through of je at 0x004b2be8, 7 instruction(s), ends with je to 0x004b2c18 (forward)
    mov edi, 0x551770                            # 004b2bea
    mov esi, dword ptr [ebp - local_4]           # 004b2bef
    add esi, 0x274                               # 004b2bf2
    mov ecx, 0x9                                 # 004b2bf8
    {load} xor eax, eax                          # 004b2bfd
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b2bff
    je.d8 L_004b2c18                             # 004b2c01
    # block 0x004b2c03: entered by fall-through of je at 0x004b2c01, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004b2c18
    mov ecx, dword ptr [ebp - local_4]           # 004b2c03
    mov dx, word ptr [ecx + field_295]           # 004b2c06
    push edx                                     # 004b2c0d
    mov ecx, 0x5c3a67                            # 004b2c0e
    call FUN_004fb2e3                            # 004b2c13
L_004b2c18:
    # block 0x004b2c18: entered by jmp at 0x004b2b36; jmp at 0x004b2bb9; je at 0x004b2bc7; je at 0x004b2bdf; more, 4 instruction(s), falls into the block at 0x004b2c2c
    mov eax, dword ptr [ebp - local_8]           # 004b2c18
    mov ecx, dword ptr [ebp - local_8]           # 004b2c1b
    mov dx, word ptr [ecx + field_1531]          # 004b2c1e
    mov word ptr [eax + field_1535], dx          # 004b2c25
L_004b2c2c:
    # block 0x004b2c2c: entered by je at 0x004b2ac9; jne at 0x004b2ad9; jne at 0x004b2ae6; jne at 0x004b2b00, 5 instruction(s), ends with ret
    pop edi                                      # 004b2c2c
    pop esi                                      # 004b2c2d
    {load} mov esp, ebp                          # 004b2c2e
    pop ebp                                      # 004b2c30
    ret                                          # 004b2c31

