# FUN_004ab899
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab899
# extent:       0x004ab899-0x004ab9fa (353 code bytes)
# span:         0x004ab899-0x004ab9fa (code 353, tables 0, padding 0)
# sha256:       b8bca82e2a683874ce0dc476da69240f7d48db523c23b41c1ca1f0b17b836a48
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ab899
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_24, field_2e, field_3a, field_54, field_58, field_5e, field_ad8, field_b3a; [ecx + n] field_1e, field_28, field_59; [edx + n] field_2a, field_5e
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 88 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_3a, 0x3a  # offset +0x3a
.equ field_54, 0x54  # offset +0x54
.equ field_58, 0x58  # offset +0x58
.equ field_59, 0x59  # offset +0x59
.equ field_5e, 0x5e  # offset +0x5e
.equ field_ad8, 0xad8  # offset +0xad8
.equ field_b3a, 0xb3a  # offset +0xb3a

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004ab899 - 0x401000
.globl FUN_004ab899
FUN_004ab899:
    # block 0x004ab899: entry, 14 instruction(s), ends with je to 0x004ab9f4 (forward)
    push ebp                                     # 004ab899
    {load} mov ebp, esp                          # 004ab89a
    sub esp, 0x8                                 # 004ab89c
    push esi                                     # 004ab89f
    push edi                                     # 004ab8a0
    mov dword ptr [ebp - local_8], ecx           # 004ab8a1
    mov eax, dword ptr [ebp - local_8]           # 004ab8a4
    movsx ecx, word ptr [eax + field_1e]         # 004ab8a7
    imul ecx, ecx, 0x8d                          # 004ab8ab
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ab8b1
    mov dword ptr [ebp - local_4], edx           # 004ab8b7
    mov eax, dword ptr [ebp - local_8]           # 004ab8ba
    cmp dword ptr [eax + field_54], 0x0          # 004ab8bd
    je.d32 L_004ab9f4                            # 004ab8c1
    # block 0x004ab8c7: entered by fall-through of je at 0x004ab8c1, 5 instruction(s), ends with jne to 0x004ab9f4 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ab8c7
    {load} xor edx, edx                          # 004ab8ca
    mov dl, byte ptr [ecx + field_59]            # 004ab8cc
    test edx, edx                                # 004ab8cf
    jne.d32 L_004ab9f4                           # 004ab8d1
    # block 0x004ab8d7: entered by fall-through of jne at 0x004ab8d1, 3 instruction(s), ends with jne to 0x004ab9f4 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ab8d7
    cmp dword ptr [eax + field_5e], 0x0          # 004ab8da
    jne.d32 L_004ab9f4                           # 004ab8de
    # block 0x004ab8e4: entered by fall-through of jne at 0x004ab8de, 5 instruction(s), ends with jne to 0x004ab9f4 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ab8e4
    movsx edx, word ptr [ecx + field_1e]         # 004ab8e7
    imul edx, edx, 0x8d                          # 004ab8eb
    cmp dword ptr [edx + 0x5bb632], 0x1          # 004ab8f1
    jne.d32 L_004ab9f4                           # 004ab8f8
    # block 0x004ab8fe: entered by fall-through of jne at 0x004ab8f8, 2 instruction(s), ends with jne to 0x004ab92d (forward)
    cmp dword ptr [0x5c39e5], 0x27d0             # 004ab8fe
    jne.d8 L_004ab92d                            # 004ab908
    # block 0x004ab90a: entered by fall-through of jne at 0x004ab908, 7 instruction(s), ends with forward jump to 0x004ab9f4
    mov eax, dword ptr [ebp - local_8]           # 004ab90a
    mov byte ptr [eax + field_58], 0x1           # 004ab90d
    mov ecx, dword ptr [ebp - local_8]           # 004ab911
    movsx edx, word ptr [ecx + field_1e]         # 004ab914
    imul edx, edx, 0x8d                          # 004ab918
    mov dword ptr [edx + 0x5bb632], 0x2          # 004ab91e
    jmp.d32 L_004ab9f4                           # 004ab928
L_004ab92d:
    # block 0x004ab92d: entered by jne at 0x004ab908, 2 instruction(s), ends with jne to 0x004ab9a0 (forward)
    cmp dword ptr [0x5c39e5], 0x27ce             # 004ab92d
    jne.d8 L_004ab9a0                            # 004ab937
    # block 0x004ab939: entered by fall-through of jne at 0x004ab937, 12 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x004ab99e (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ab939
    mov dword ptr [eax + field_24], 0x1          # 004ab93c
    mov ecx, dword ptr [ebp - local_8]           # 004ab943
    mov word ptr [ecx + field_28], 0x27ce        # 004ab946
    call dword ptr [0x52a23c]                    # 004ab94c
    add eax, 0xfa                                # 004ab952
    mov edx, dword ptr [ebp - local_8]           # 004ab957
    mov dword ptr [edx + field_2a], eax          # 004ab95a
    mov eax, dword ptr [ebp - local_8]           # 004ab95d
    mov dword ptr [eax + field_2e], 0x1          # 004ab960
    cmp dword ptr [0x5bb1ca], 0x0                # 004ab967
    je.d8 L_004ab99e                             # 004ab96e
    # block 0x004ab970: entered by fall-through of je at 0x004ab96e, 7 instruction(s), ends with je to 0x004ab99e (forward)
    mov edi, 0x550fb8                            # 004ab970
    mov esi, dword ptr [ebp - local_4]           # 004ab975
    add esi, 0xab7                               # 004ab978
    mov ecx, 0x9                                 # 004ab97e
    {load} xor edx, edx                          # 004ab983
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ab985
    je.d8 L_004ab99e                             # 004ab987
    # block 0x004ab989: entered by fall-through of je at 0x004ab987, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004ab99e
    mov eax, dword ptr [ebp - local_4]           # 004ab989
    mov cx, word ptr [eax + field_ad8]           # 004ab98c
    push ecx                                     # 004ab993
    mov ecx, 0x5c3a67                            # 004ab994
    call FUN_004fb2e3                            # 004ab999
L_004ab99e:
    # block 0x004ab99e: entered by je at 0x004ab96e; je at 0x004ab987, 1 instruction(s), ends with forward jump to 0x004ab9f4
    jmp.d8 L_004ab9f4                            # 004ab99e
L_004ab9a0:
    # block 0x004ab9a0: entered by jne at 0x004ab937, 2 instruction(s), ends with jne to 0x004ab9f4 (forward)
    cmp dword ptr [0x5c39e5], 0x27cf             # 004ab9a0
    jne.d8 L_004ab9f4                            # 004ab9aa
    # block 0x004ab9ac: entered by fall-through of jne at 0x004ab9aa, 2 instruction(s), ends with je to 0x004ab9e3 (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 004ab9ac
    je.d8 L_004ab9e3                             # 004ab9b3
    # block 0x004ab9b5: entered by fall-through of je at 0x004ab9b3, 7 instruction(s), ends with je to 0x004ab9e3 (forward)
    mov edi, 0x550fc4                            # 004ab9b5
    mov esi, dword ptr [ebp - local_4]           # 004ab9ba
    add esi, 0xb19                               # 004ab9bd
    mov ecx, 0x9                                 # 004ab9c3
    {load} xor edx, edx                          # 004ab9c8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ab9ca
    je.d8 L_004ab9e3                             # 004ab9cc
    # block 0x004ab9ce: entered by fall-through of je at 0x004ab9cc, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004ab9e3
    mov eax, dword ptr [ebp - local_4]           # 004ab9ce
    mov cx, word ptr [eax + field_b3a]           # 004ab9d1
    push ecx                                     # 004ab9d8
    mov ecx, 0x5c3a67                            # 004ab9d9
    call FUN_004fb2e3                            # 004ab9de
L_004ab9e3:
    # block 0x004ab9e3: entered by je at 0x004ab9b3; je at 0x004ab9cc, 4 instruction(s), falls into the block at 0x004ab9f4
    mov edx, dword ptr [ebp - local_8]           # 004ab9e3
    mov dword ptr [edx + field_5e], 0x2          # 004ab9e6
    mov eax, dword ptr [ebp - local_8]           # 004ab9ed
    mov byte ptr [eax + field_3a], 0x1           # 004ab9f0
L_004ab9f4:
    # block 0x004ab9f4: entered by je at 0x004ab8c1; jne at 0x004ab8d1; jne at 0x004ab8de; jne at 0x004ab8f8; more, 5 instruction(s), ends with ret
    pop edi                                      # 004ab9f4
    pop esi                                      # 004ab9f5
    {load} mov esp, ebp                          # 004ab9f6
    pop ebp                                      # 004ab9f8
    ret                                          # 004ab9f9

