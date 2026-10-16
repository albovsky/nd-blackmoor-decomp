# FUN_004ab528
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab528
# extent:       0x004ab528-0x004ab706 (478 code bytes)
# span:         0x004ab528-0x004ab706 (code 478, tables 0, padding 0)
# sha256:       f1f1822cd79513ae953393aa48ea417d3f892b8e255c8655a751242eecf69a1d
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ab528
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_54, field_1bf, field_1c3, field_1c7, field_1cb, field_bb3, field_bb7; [ecx + n] field_21, field_24, field_baf; [edx + n] field_21, field_3c, field_5e, field_9f, field_a3, field_a7, field_ab, field_bbb
# callees:      calls FUN_004ab706
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 131 instruction(s), 18 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_24, 0x24  # offset +0x24
.equ field_3c, 0x3c  # offset +0x3c
.equ field_54, 0x54  # offset +0x54
.equ field_5e, 0x5e  # offset +0x5e
.equ field_9f, 0x9f  # offset +0x9f
.equ field_a3, 0xa3  # offset +0xa3
.equ field_a7, 0xa7  # offset +0xa7
.equ field_ab, 0xab  # offset +0xab
.equ field_1bf, 0x1bf  # offset +0x1bf
.equ field_1c3, 0x1c3  # offset +0x1c3
.equ field_1c7, 0x1c7  # offset +0x1c7
.equ field_1cb, 0x1cb  # offset +0x1cb
.equ field_baf, 0xbaf  # offset +0xbaf
.equ field_bb3, 0xbb3  # offset +0xbb3
.equ field_bb7, 0xbb7  # offset +0xbb7
.equ field_bbb, 0xbbb  # offset +0xbbb

# --- external targets -----------------------------------------------
.set FUN_004ab706, .text + (0x004ab706 - 0x401000)

.org 0x004ab528 - 0x401000
.globl FUN_004ab528
FUN_004ab528:
    # block 0x004ab528: entry, 7 instruction(s), ends with je to 0x004ab6fe (forward)
    push ebp                                     # 004ab528
    {load} mov ebp, esp                          # 004ab529
    sub esp, 0xc                                 # 004ab52b
    mov dword ptr [ebp - local_c], ecx           # 004ab52e
    mov eax, dword ptr [ebp - local_c]           # 004ab531
    cmp dword ptr [eax + field_54], 0x0          # 004ab534
    je.d32 L_004ab6fe                            # 004ab538
    # block 0x004ab53e: entered by fall-through of je at 0x004ab538, 3 instruction(s), ends with jne to 0x004ab6fe (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004ab53e
    cmp dword ptr [ecx + field_24], 0x0          # 004ab541
    jne.d32 L_004ab6fe                           # 004ab545
    # block 0x004ab54b: entered by fall-through of jne at 0x004ab545, 3 instruction(s), ends with jne to 0x004ab6fe (forward)
    mov edx, dword ptr [ebp - local_c]           # 004ab54b
    cmp dword ptr [edx + field_5e], 0x0          # 004ab54e
    jne.d32 L_004ab6fe                           # 004ab552
    # block 0x004ab558: entered by fall-through of jne at 0x004ab552, 7 instruction(s), ends with forward jump to 0x004ab580
    mov eax, dword ptr [ebp - local_c]           # 004ab558
    movsx ecx, word ptr [eax + field_1e]         # 004ab55b
    imul ecx, ecx, 0x8d                          # 004ab55f
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004ab565
    mov dword ptr [ebp - local_8], edx           # 004ab56b
    mov dword ptr [ebp - local_4], 0x0           # 004ab56e
    jmp.d8 L_004ab580                            # 004ab575
L_004ab577:
    # block 0x004ab577: entered by jmp at 0x004ab600, 3 instruction(s), falls into the block at 0x004ab580
    mov eax, dword ptr [ebp - local_4]           # 004ab577
    add eax, 0x1                                 # 004ab57a
    mov dword ptr [ebp - local_4], eax           # 004ab57d
L_004ab580:
    # block 0x004ab580: entered by jmp at 0x004ab575, 4 instruction(s), ends with jge to 0x004ab605 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ab580
    movsx edx, word ptr [ecx + field_21]         # 004ab583
    cmp dword ptr [ebp - local_4], edx           # 004ab587
    jge.d8 L_004ab605                            # 004ab58a
    # block 0x004ab58c: entered by fall-through of jge at 0x004ab58a, 6 instruction(s), ends with jl to 0x004ab600 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004ab58c
    mov ecx, dword ptr [ebp - local_4]           # 004ab590
    shl ecx, 0x4                                 # 004ab593
    mov edx, dword ptr [ebp - local_8]           # 004ab596
    cmp eax, dword ptr [edx + ecx + field_a3]    # 004ab599
    jl.d8 L_004ab600                             # 004ab5a0
    # block 0x004ab5a2: entered by fall-through of jl at 0x004ab5a0, 6 instruction(s), ends with jg to 0x004ab600 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004ab5a2
    mov ecx, dword ptr [ebp - local_4]           # 004ab5a6
    shl ecx, 0x4                                 # 004ab5a9
    mov edx, dword ptr [ebp - local_8]           # 004ab5ac
    cmp eax, dword ptr [edx + ecx + field_ab]    # 004ab5af
    jg.d8 L_004ab600                             # 004ab5b6
    # block 0x004ab5b8: entered by fall-through of jg at 0x004ab5b6, 6 instruction(s), ends with jl to 0x004ab600 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004ab5b8
    mov ecx, dword ptr [ebp - local_4]           # 004ab5bc
    shl ecx, 0x4                                 # 004ab5bf
    mov edx, dword ptr [ebp - local_8]           # 004ab5c2
    cmp eax, dword ptr [edx + ecx + field_9f]    # 004ab5c5
    jl.d8 L_004ab600                             # 004ab5cc
    # block 0x004ab5ce: entered by fall-through of jl at 0x004ab5cc, 6 instruction(s), ends with jg to 0x004ab600 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004ab5ce
    mov ecx, dword ptr [ebp - local_4]           # 004ab5d2
    shl ecx, 0x4                                 # 004ab5d5
    mov edx, dword ptr [ebp - local_8]           # 004ab5d8
    cmp eax, dword ptr [edx + ecx + field_a7]    # 004ab5db
    jg.d8 L_004ab600                             # 004ab5e2
    # block 0x004ab5e4: entered by fall-through of jg at 0x004ab5e2, 7 instruction(s), calls FUN_004ab706, ends with forward jump to 0x004ab700
    mov ax, word ptr [ebp - local_4]             # 004ab5e4
    push eax                                     # 004ab5e8
    push 0x27cf                                  # 004ab5e9
    mov ecx, dword ptr [ebp - local_c]           # 004ab5ee
    call FUN_004ab706                            # 004ab5f1
    mov eax, 0x1                                 # 004ab5f6
    jmp.d32 L_004ab700                           # 004ab5fb
L_004ab600:
    # block 0x004ab600: entered by jl at 0x004ab5a0; jg at 0x004ab5b6; jl at 0x004ab5cc; jg at 0x004ab5e2, 1 instruction(s), ends with backward jump to 0x004ab577
    jmp.d32 L_004ab577                           # 004ab600
L_004ab605:
    # block 0x004ab605: entered by jge at 0x004ab58a, 2 instruction(s), ends with forward jump to 0x004ab617
    mov dword ptr [ebp - local_4], 0x0           # 004ab605
    jmp.d8 L_004ab617                            # 004ab60c
L_004ab60e:
    # block 0x004ab60e: entered by jmp at 0x004ab6a7, 3 instruction(s), falls into the block at 0x004ab617
    mov ecx, dword ptr [ebp - local_4]           # 004ab60e
    add ecx, 0x1                                 # 004ab611
    mov dword ptr [ebp - local_4], ecx           # 004ab614
L_004ab617:
    # block 0x004ab617: entered by jmp at 0x004ab60c, 4 instruction(s), ends with jge to 0x004ab6ac (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ab617
    movsx eax, word ptr [edx + field_21]         # 004ab61a
    cmp dword ptr [ebp - local_4], eax           # 004ab61e
    jge.d32 L_004ab6ac                           # 004ab621
    # block 0x004ab627: entered by fall-through of jge at 0x004ab621, 6 instruction(s), ends with jl to 0x004ab6a7 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004ab627
    mov edx, dword ptr [ebp - local_4]           # 004ab62b
    shl edx, 0x4                                 # 004ab62e
    mov eax, dword ptr [ebp - local_8]           # 004ab631
    cmp ecx, dword ptr [eax + edx + field_1c3]   # 004ab634
    jl.d8 L_004ab6a7                             # 004ab63b
    # block 0x004ab63d: entered by fall-through of jl at 0x004ab63b, 6 instruction(s), ends with jg to 0x004ab6a7 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004ab63d
    mov edx, dword ptr [ebp - local_4]           # 004ab641
    shl edx, 0x4                                 # 004ab644
    mov eax, dword ptr [ebp - local_8]           # 004ab647
    cmp ecx, dword ptr [eax + edx + field_1cb]   # 004ab64a
    jg.d8 L_004ab6a7                             # 004ab651
    # block 0x004ab653: entered by fall-through of jg at 0x004ab651, 6 instruction(s), ends with jl to 0x004ab6a7 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ab653
    mov edx, dword ptr [ebp - local_4]           # 004ab657
    shl edx, 0x4                                 # 004ab65a
    mov eax, dword ptr [ebp - local_8]           # 004ab65d
    cmp ecx, dword ptr [eax + edx + field_1bf]   # 004ab660
    jl.d8 L_004ab6a7                             # 004ab667
    # block 0x004ab669: entered by fall-through of jl at 0x004ab667, 6 instruction(s), ends with jg to 0x004ab6a7 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004ab669
    mov edx, dword ptr [ebp - local_4]           # 004ab66d
    shl edx, 0x4                                 # 004ab670
    mov eax, dword ptr [ebp - local_8]           # 004ab673
    cmp ecx, dword ptr [eax + edx + field_1c7]   # 004ab676
    jg.d8 L_004ab6a7                             # 004ab67d
    # block 0x004ab67f: entered by fall-through of jg at 0x004ab67d, 5 instruction(s), ends with jle to 0x004ab6a7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ab67f
    mov edx, dword ptr [ebp - local_c]           # 004ab682
    movsx eax, word ptr [edx + 2*ecx + field_3c] # 004ab685
    test eax, eax                                # 004ab68a
    jle.d8 L_004ab6a7                            # 004ab68c
    # block 0x004ab68e: entered by fall-through of jle at 0x004ab68c, 7 instruction(s), calls FUN_004ab706, ends with forward jump to 0x004ab700
    mov cx, word ptr [ebp - local_4]             # 004ab68e
    push ecx                                     # 004ab692
    push 0x27ce                                  # 004ab693
    mov ecx, dword ptr [ebp - local_c]           # 004ab698
    call FUN_004ab706                            # 004ab69b
    mov eax, 0x1                                 # 004ab6a0
    jmp.d8 L_004ab700                            # 004ab6a5
L_004ab6a7:
    # block 0x004ab6a7: entered by jl at 0x004ab63b; jg at 0x004ab651; jl at 0x004ab667; jg at 0x004ab67d; jle at 0x004ab68c, 1 instruction(s), ends with backward jump to 0x004ab60e
    jmp.d32 L_004ab60e                           # 004ab6a7
L_004ab6ac:
    # block 0x004ab6ac: entered by jge at 0x004ab621, 4 instruction(s), ends with jl to 0x004ab6fe (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004ab6ac
    mov eax, dword ptr [ebp - local_8]           # 004ab6b0
    cmp edx, dword ptr [eax + field_bb3]         # 004ab6b3
    jl.d8 L_004ab6fe                             # 004ab6b9
    # block 0x004ab6bb: entered by fall-through of jl at 0x004ab6b9, 4 instruction(s), ends with jg to 0x004ab6fe (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004ab6bb
    mov edx, dword ptr [ebp - local_8]           # 004ab6bf
    cmp ecx, dword ptr [edx + field_bbb]         # 004ab6c2
    jg.d8 L_004ab6fe                             # 004ab6c8
    # block 0x004ab6ca: entered by fall-through of jg at 0x004ab6c8, 4 instruction(s), ends with jl to 0x004ab6fe (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004ab6ca
    mov ecx, dword ptr [ebp - local_8]           # 004ab6ce
    cmp eax, dword ptr [ecx + field_baf]         # 004ab6d1
    jl.d8 L_004ab6fe                             # 004ab6d7
    # block 0x004ab6d9: entered by fall-through of jl at 0x004ab6d7, 4 instruction(s), ends with jg to 0x004ab6fe (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004ab6d9
    mov eax, dword ptr [ebp - local_8]           # 004ab6dd
    cmp edx, dword ptr [eax + field_bb7]         # 004ab6e0
    jg.d8 L_004ab6fe                             # 004ab6e6
    # block 0x004ab6e8: entered by fall-through of jg at 0x004ab6e6, 6 instruction(s), calls FUN_004ab706, ends with forward jump to 0x004ab700
    push 0x0                                     # 004ab6e8
    push 0x27d0                                  # 004ab6ea
    mov ecx, dword ptr [ebp - local_c]           # 004ab6ef
    call FUN_004ab706                            # 004ab6f2
    mov eax, 0x1                                 # 004ab6f7
    jmp.d8 L_004ab700                            # 004ab6fc
L_004ab6fe:
    # block 0x004ab6fe: entered by je at 0x004ab538; jne at 0x004ab545; jne at 0x004ab552; jl at 0x004ab6b9; more, 1 instruction(s), falls into the block at 0x004ab700
    {load} xor eax, eax                          # 004ab6fe
L_004ab700:
    # block 0x004ab700: entered by jmp at 0x004ab5fb; jmp at 0x004ab6a5; jmp at 0x004ab6fc, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004ab700
    pop ebp                                      # 004ab702
    ret 0x8                                      # 004ab703

