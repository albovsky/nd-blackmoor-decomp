# FUN_004ac97d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ac97d
# extent:       0x004ac97d-0x004acbba (573 code bytes)
# span:         0x004ac97d-0x004acbba (code 573, tables 0, padding 0)
# sha256:       441dce5f95bc8f9c1e5b593235a2446ac768434b26e3cc4723aad620a9325f09
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ac97d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_1c, field_27, field_43, field_6e, field_c35, field_e6d; [ecx + n] field_1c, field_27, field_2b, field_6e, field_e59; [edx + n] field_2b, field_43, field_6e, field_c35, field_e59, field_e6d
# callees:      calls FUN_004c2dfb, FUN_0051dc6c, FUN_004d3992, FUN_004ac8da
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 145 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_27, 0x27  # offset +0x27
.equ field_2b, 0x2b  # offset +0x2b
.equ field_43, 0x43  # offset +0x43
.equ field_6e, 0x6e  # offset +0x6e
.equ field_c35, 0xc35  # offset +0xc35
.equ field_e59, 0xe59  # offset +0xe59
.equ field_e6d, 0xe6d  # offset +0xe6d

# --- external targets -----------------------------------------------
.set FUN_004ac8da, .text + (0x004ac8da - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004ac97d - 0x401000
.globl FUN_004ac97d
FUN_004ac97d:
    # block 0x004ac97d: entry, 7 instruction(s), ends with je to 0x004ac9b3 (forward)
    push ebp                                     # 004ac97d
    {load} mov ebp, esp                          # 004ac97e
    sub esp, 0x14                                # 004ac980
    mov dword ptr [ebp - local_14], ecx          # 004ac983
    mov eax, dword ptr [ebp - local_14]          # 004ac986
    cmp dword ptr [eax + field_c35], 0x0         # 004ac989
    je.d8 L_004ac9b3                             # 004ac990
    # block 0x004ac992: entered by fall-through of je at 0x004ac990, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004ac9b3
    mov ecx, dword ptr [ebp - local_14]          # 004ac992
    add ecx, 0xc35                               # 004ac995
    push ecx                                     # 004ac99b
    mov ecx, 0x5cf659                            # 004ac99c
    call FUN_004c2dfb                            # 004ac9a1
    mov edx, dword ptr [ebp - local_14]          # 004ac9a6
    mov dword ptr [edx + field_c35], 0x0         # 004ac9a9
L_004ac9b3:
    # block 0x004ac9b3: entered by je at 0x004ac990, 2 instruction(s), ends with forward jump to 0x004ac9c7
    mov word ptr [ebp - local_8], 0x0            # 004ac9b3
    jmp.d8 L_004ac9c7                            # 004ac9b9
L_004ac9bb:
    # block 0x004ac9bb: entered by jmp at 0x004acb30, 3 instruction(s), falls into the block at 0x004ac9c7
    mov ax, word ptr [ebp - local_8]             # 004ac9bb
    .insn 0x66, 0x05, 0x0001{:u16}               # 004ac9bf
    mov word ptr [ebp - local_8], ax             # 004ac9c3
L_004ac9c7:
    # block 0x004ac9c7: entered by jmp at 0x004ac9b9, 3 instruction(s), ends with jge to 0x004acb35 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004ac9c7
    cmp ecx, 0xf                                 # 004ac9cb
    jge.d32 L_004acb35                           # 004ac9ce
    # block 0x004ac9d4: entered by fall-through of jge at 0x004ac9ce, 2 instruction(s), ends with forward jump to 0x004ac9e8
    mov word ptr [ebp - local_4], 0x0            # 004ac9d4
    jmp.d8 L_004ac9e8                            # 004ac9da
L_004ac9dc:
    # block 0x004ac9dc: entered by jmp at 0x004acb2b, 3 instruction(s), falls into the block at 0x004ac9e8
    mov dx, word ptr [ebp - local_4]             # 004ac9dc
    add dx, 0x1                                  # 004ac9e0
    mov word ptr [ebp - local_4], dx             # 004ac9e4
L_004ac9e8:
    # block 0x004ac9e8: entered by jmp at 0x004ac9da, 3 instruction(s), ends with jge to 0x004acb30 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004ac9e8
    cmp eax, 0x4                                 # 004ac9ec
    jge.d32 L_004acb30                           # 004ac9ef
    # block 0x004ac9f5: entered by fall-through of jge at 0x004ac9ef, 8 instruction(s), ends with je to 0x004aca5b (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004ac9f5
    imul ecx, ecx, 0xc7                          # 004ac9f9
    mov edx, dword ptr [ebp - local_14]          # 004ac9ff
    lea eax, [edx + ecx + field_6e]              # 004aca02
    movsx ecx, word ptr [ebp - local_4]          # 004aca06
    imul ecx, ecx, 0x28                          # 004aca0a
    cmp dword ptr [eax + ecx + field_27], 0x0    # 004aca0d
    je.d8 L_004aca5b                             # 004aca12
    # block 0x004aca14: entered by fall-through of je at 0x004aca12, 17 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004aca5b
    movsx edx, word ptr [ebp - local_8]          # 004aca14
    imul edx, edx, 0xc7                          # 004aca18
    mov eax, dword ptr [ebp - local_14]          # 004aca1e
    lea ecx, [eax + edx + field_6e]              # 004aca21
    movsx edx, word ptr [ebp - local_4]          # 004aca25
    imul edx, edx, 0x28                          # 004aca29
    lea eax, [ecx + edx + field_27]              # 004aca2c
    push eax                                     # 004aca30
    mov ecx, 0x5cf659                            # 004aca31
    call FUN_004c2dfb                            # 004aca36
    movsx ecx, word ptr [ebp - local_8]          # 004aca3b
    imul ecx, ecx, 0xc7                          # 004aca3f
    mov edx, dword ptr [ebp - local_14]          # 004aca45
    lea eax, [edx + ecx + field_6e]              # 004aca48
    movsx ecx, word ptr [ebp - local_4]          # 004aca4c
    imul ecx, ecx, 0x28                          # 004aca50
    mov dword ptr [eax + ecx + field_27], 0x0    # 004aca53
L_004aca5b:
    # block 0x004aca5b: entered by je at 0x004aca12, 8 instruction(s), ends with je to 0x004acac1 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004aca5b
    imul edx, edx, 0xc7                          # 004aca5f
    mov eax, dword ptr [ebp - local_14]          # 004aca65
    lea ecx, [eax + edx + field_6e]              # 004aca68
    movsx edx, word ptr [ebp - local_4]          # 004aca6c
    imul edx, edx, 0x28                          # 004aca70
    cmp dword ptr [ecx + edx + field_2b], 0x0    # 004aca73
    je.d8 L_004acac1                             # 004aca78
    # block 0x004aca7a: entered by fall-through of je at 0x004aca78, 17 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004acac1
    movsx eax, word ptr [ebp - local_8]          # 004aca7a
    imul eax, eax, 0xc7                          # 004aca7e
    mov ecx, dword ptr [ebp - local_14]          # 004aca84
    lea edx, [ecx + eax + field_6e]              # 004aca87
    movsx eax, word ptr [ebp - local_4]          # 004aca8b
    imul eax, eax, 0x28                          # 004aca8f
    lea ecx, [edx + eax + field_2b]              # 004aca92
    push ecx                                     # 004aca96
    mov ecx, 0x5cf659                            # 004aca97
    call FUN_004c2dfb                            # 004aca9c
    movsx edx, word ptr [ebp - local_8]          # 004acaa1
    imul edx, edx, 0xc7                          # 004acaa5
    mov eax, dword ptr [ebp - local_14]          # 004acaab
    lea ecx, [eax + edx + field_6e]              # 004acaae
    movsx edx, word ptr [ebp - local_4]          # 004acab2
    imul edx, edx, 0x28                          # 004acab6
    mov dword ptr [ecx + edx + field_2b], 0x0    # 004acab9
L_004acac1:
    # block 0x004acac1: entered by je at 0x004aca78, 8 instruction(s), ends with je to 0x004acb2b (forward)
    movsx eax, word ptr [ebp - local_8]          # 004acac1
    imul eax, eax, 0xc7                          # 004acac5
    mov ecx, dword ptr [ebp - local_14]          # 004acacb
    lea edx, [ecx + eax + field_6e]              # 004acace
    movsx eax, word ptr [ebp - local_4]          # 004acad2
    imul eax, eax, 0x28                          # 004acad6
    cmp dword ptr [edx + eax + field_43], 0x0    # 004acad9
    je.d8 L_004acb2b                             # 004acade
    # block 0x004acae0: entered by fall-through of je at 0x004acade, 19 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004acb2b
    movsx ecx, word ptr [ebp - local_8]          # 004acae0
    imul ecx, ecx, 0xc7                          # 004acae4
    mov edx, dword ptr [ebp - local_14]          # 004acaea
    lea eax, [edx + ecx + field_6e]              # 004acaed
    movsx ecx, word ptr [ebp - local_4]          # 004acaf1
    imul ecx, ecx, 0x28                          # 004acaf5
    mov edx, dword ptr [eax + ecx + field_43]    # 004acaf8
    mov dword ptr [ebp - local_c], edx           # 004acafc
    mov eax, dword ptr [ebp - local_c]           # 004acaff
    push eax                                     # 004acb02
    call FUN_0051dc6c                            # 004acb03
    add esp, 0x4                                 # 004acb08
    movsx ecx, word ptr [ebp - local_8]          # 004acb0b
    imul ecx, ecx, 0xc7                          # 004acb0f
    mov edx, dword ptr [ebp - local_14]          # 004acb15
    lea eax, [edx + ecx + field_6e]              # 004acb18
    movsx ecx, word ptr [ebp - local_4]          # 004acb1c
    imul ecx, ecx, 0x28                          # 004acb20
    mov dword ptr [eax + ecx + field_43], 0x0    # 004acb23
L_004acb2b:
    # block 0x004acb2b: entered by je at 0x004acade, 1 instruction(s), ends with backward jump to 0x004ac9dc
    jmp.d32 L_004ac9dc                           # 004acb2b
L_004acb30:
    # block 0x004acb30: entered by jge at 0x004ac9ef, 1 instruction(s), ends with backward jump to 0x004ac9bb
    jmp.d32 L_004ac9bb                           # 004acb30
L_004acb35:
    # block 0x004acb35: entered by jge at 0x004ac9ce, 3 instruction(s), ends with je to 0x004acb61 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004acb35
    cmp dword ptr [edx + field_e59], 0x0         # 004acb38
    je.d8 L_004acb61                             # 004acb3f
    # block 0x004acb41: entered by fall-through of je at 0x004acb3f, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004acb61
    mov eax, dword ptr [ebp - local_14]          # 004acb41
    add eax, 0xe59                               # 004acb44
    push eax                                     # 004acb49
    mov ecx, 0x5cf659                            # 004acb4a
    call FUN_004c2dfb                            # 004acb4f
    mov ecx, dword ptr [ebp - local_14]          # 004acb54
    mov dword ptr [ecx + field_e59], 0x0         # 004acb57
L_004acb61:
    # block 0x004acb61: entered by je at 0x004acb3f, 3 instruction(s), ends with je to 0x004acb92 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004acb61
    cmp dword ptr [edx + field_e6d], 0x0         # 004acb64
    je.d8 L_004acb92                             # 004acb6b
    # block 0x004acb6d: entered by fall-through of je at 0x004acb6b, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004acb92
    mov eax, dword ptr [ebp - local_14]          # 004acb6d
    mov ecx, dword ptr [eax + field_e6d]         # 004acb70
    mov dword ptr [ebp - local_10], ecx          # 004acb76
    mov edx, dword ptr [ebp - local_10]          # 004acb79
    push edx                                     # 004acb7c
    call FUN_0051dc6c                            # 004acb7d
    add esp, 0x4                                 # 004acb82
    mov eax, dword ptr [ebp - local_14]          # 004acb85
    mov dword ptr [eax + field_e6d], 0x0         # 004acb88
L_004acb92:
    # block 0x004acb92: entered by je at 0x004acb6b, 4 instruction(s), ends with je to 0x004acbae (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004acb92
    movsx edx, word ptr [ecx + field_1c]         # 004acb95
    cmp edx, -0x1                                # 004acb99
    je.d8 L_004acbae                             # 004acb9c
    # block 0x004acb9e: entered by fall-through of je at 0x004acb9c, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004acbae
    mov eax, dword ptr [ebp - local_14]          # 004acb9e
    mov cx, word ptr [eax + field_1c]            # 004acba1
    push ecx                                     # 004acba5
    call FUN_004d3992                            # 004acba6
    add esp, 0x4                                 # 004acbab
L_004acbae:
    # block 0x004acbae: entered by je at 0x004acb9c, 5 instruction(s), calls FUN_004ac8da, ends with ret
    mov ecx, dword ptr [ebp - local_14]          # 004acbae
    call FUN_004ac8da                            # 004acbb1
    {load} mov esp, ebp                          # 004acbb6
    pop ebp                                      # 004acbb8
    ret                                          # 004acbb9

