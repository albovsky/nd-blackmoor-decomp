# FUN_0045e587
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045e587
# extent:       0x0045e587-0x0045e67d (246 code bytes)
# span:         0x0045e587-0x0045e67d (code 246, tables 0, padding 0)
# sha256:       7b649a2256937de9f6c08eef7db6c69ec34b146fdc587f18c55bf2dbaf24e6e7
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045e587
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_298, field_31d, field_321; [ecx + n] field_39d, field_39e, field_3a2; [edx + n] field_1e, field_299, field_2aa
# callees:      calls FUN_0045e6bd
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1e, 0x1e  # offset +0x1e
.equ field_298, 0x298  # offset +0x298
.equ field_299, 0x299  # offset +0x299
.equ field_2aa, 0x2aa  # offset +0x2aa
.equ field_31d, 0x31d  # offset +0x31d
.equ field_321, 0x321  # offset +0x321
.equ field_39d, 0x39d  # offset +0x39d
.equ field_39e, 0x39e  # offset +0x39e
.equ field_3a2, 0x3a2  # offset +0x3a2

# --- external targets -----------------------------------------------
.set FUN_0045e6bd, .text + (0x0045e6bd - 0x401000)

.org 0x0045e587 - 0x401000
.globl FUN_0045e587
FUN_0045e587:
    # block 0x0045e587: entry, 9 instruction(s), ends with je to 0x0045e679 (forward)
    push ebp                                     # 0045e587
    {load} mov ebp, esp                          # 0045e588
    push ecx                                     # 0045e58a
    mov dword ptr [ebp - local_4], ecx           # 0045e58b
    mov eax, dword ptr [ebp - local_4]           # 0045e58e
    {load} xor ecx, ecx                          # 0045e591
    mov cl, byte ptr [eax + field_321]           # 0045e593
    test ecx, ecx                                # 0045e599
    je.d32 L_0045e679                            # 0045e59b
    # block 0x0045e5a1: entered by fall-through of je at 0x0045e59b, 5 instruction(s), ends with jne to 0x0045e679 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045e5a1
    {load} xor eax, eax                          # 0045e5a4
    mov al, byte ptr [edx + field_2aa]           # 0045e5a6
    test eax, eax                                # 0045e5ac
    jne.d32 L_0045e679                           # 0045e5ae
    # block 0x0045e5b4: entered by fall-through of jne at 0x0045e5ae, 3 instruction(s), ends with je to 0x0045e679 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0045e5b4
    cmp dword ptr [ecx + field_39e], 0xa         # 0045e5b7
    je.d32 L_0045e679                            # 0045e5be
    # block 0x0045e5c4: entered by fall-through of je at 0x0045e5be, 5 instruction(s), ends with jne to 0x0045e679 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045e5c4
    movsx eax, word ptr [edx + field_1e]         # 0045e5c7
    imul eax, eax, 0x8d                          # 0045e5cb
    cmp dword ptr [eax + 0x5bb632], 0x1          # 0045e5d1
    jne.d32 L_0045e679                           # 0045e5d8
    # block 0x0045e5de: entered by fall-through of jne at 0x0045e5d8, 2 instruction(s), ends with jne to 0x0045e60d (forward)
    cmp dword ptr [0x5c39e5], 0x27ef             # 0045e5de
    jne.d8 L_0045e60d                            # 0045e5e8
    # block 0x0045e5ea: entered by fall-through of jne at 0x0045e5e8, 7 instruction(s), ends with forward jump to 0x0045e679
    mov ecx, dword ptr [ebp - local_4]           # 0045e5ea
    mov byte ptr [ecx + field_39d], 0x1          # 0045e5ed
    mov edx, dword ptr [ebp - local_4]           # 0045e5f4
    movsx eax, word ptr [edx + field_1e]         # 0045e5f7
    imul eax, eax, 0x8d                          # 0045e5fb
    mov dword ptr [eax + 0x5bb632], 0x2          # 0045e601
    jmp.d8 L_0045e679                            # 0045e60b
L_0045e60d:
    # block 0x0045e60d: entered by jne at 0x0045e5e8, 2 instruction(s), ends with jne to 0x0045e628 (forward)
    cmp dword ptr [0x5c39e5], 0x27ec             # 0045e60d
    jne.d8 L_0045e628                            # 0045e617
    # block 0x0045e619: entered by fall-through of jne at 0x0045e617, 3 instruction(s), ends with forward jump to 0x0045e679
    mov ecx, dword ptr [ebp - local_4]           # 0045e619
    mov dword ptr [ecx + field_39e], 0x5         # 0045e61c
    jmp.d8 L_0045e679                            # 0045e626
L_0045e628:
    # block 0x0045e628: entered by jne at 0x0045e617, 2 instruction(s), ends with jne to 0x0045e679 (forward)
    cmp dword ptr [0x5c39e5], 0x27ed             # 0045e628
    jne.d8 L_0045e679                            # 0045e632
    # block 0x0045e634: entered by fall-through of jne at 0x0045e632, 16 instruction(s), calls FUN_0045e6bd, falls into the block at 0x0045e679
    push 0x1                                     # 0045e634
    mov edx, dword ptr [ebp - local_4]           # 0045e636
    add edx, 0x326                               # 0045e639
    push edx                                     # 0045e63f
    mov eax, dword ptr [ebp - local_4]           # 0045e640
    mov ecx, dword ptr [eax + field_31d]         # 0045e643
    add ecx, 0xba3                               # 0045e649
    push ecx                                     # 0045e64f
    mov ecx, dword ptr [ebp - local_4]           # 0045e650
    call FUN_0045e6bd                            # 0045e653
    mov edx, dword ptr [ebp - local_4]           # 0045e658
    mov byte ptr [edx + field_299], 0x1          # 0045e65b
    mov eax, dword ptr [ebp - local_4]           # 0045e662
    mov byte ptr [eax + field_298], 0x1          # 0045e665
    mov ecx, dword ptr [ebp - local_4]           # 0045e66c
    mov dword ptr [ecx + field_3a2], 0x5         # 0045e66f
L_0045e679:
    # block 0x0045e679: entered by je at 0x0045e59b; jne at 0x0045e5ae; je at 0x0045e5be; jne at 0x0045e5d8; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0045e679
    pop ebp                                      # 0045e67b
    ret                                          # 0045e67c

