# FUN_0048e628
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e628
# extent:       0x0048e628-0x0048e776 (334 code bytes)
# span:         0x0048e628-0x0048e776 (code 334, tables 0, padding 0)
# sha256:       165d2a3ceb6c31c51b7a994502d583c470f1dfac4c93842147f37df96709e5d0
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48e628_hit_test
# naming:       native port src/original_methods_fl23a.c:m48e628_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m48e628_hit_test (callees via host). Direct: objects, ordered calls, edges. Unicorn differential: 300 fixtures, every instruction reached. Window covers all 334 bytes. See tasks/fl23a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e, field_9a, field_b2, field_b6, field_ba, field_be, field_462; [ecx + n] field_a6; [edx + n] field_9e, field_a2, field_b0, field_3fe
# callees:      calls FUN_0048e776
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl23a.c:m48e628_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 85 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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
.equ field_9a, 0x9a  # offset +0x9a
.equ field_9e, 0x9e  # offset +0x9e
.equ field_a2, 0xa2  # offset +0xa2
.equ field_a6, 0xa6  # offset +0xa6
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b2, 0xb2  # offset +0xb2
.equ field_b6, 0xb6  # offset +0xb6
.equ field_ba, 0xba  # offset +0xba
.equ field_be, 0xbe  # offset +0xbe
.equ field_3fe, 0x3fe  # offset +0x3fe
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------
.set FUN_0048e776, .text + (0x0048e776 - 0x401000)

.org 0x0048e628 - 0x401000
.globl FUN_0048e628
FUN_0048e628:
    # block 0x0048e628: entry, 12 instruction(s), ends with je to 0x0048e76e (forward)
    push ebp                                     # 0048e628
    {load} mov ebp, esp                          # 0048e629
    sub esp, 0xc                                 # 0048e62b
    mov dword ptr [ebp - local_c], ecx           # 0048e62e
    mov eax, dword ptr [ebp - local_c]           # 0048e631
    movsx ecx, word ptr [eax + field_1e]         # 0048e634
    imul ecx, ecx, 0x8d                          # 0048e638
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048e63e
    mov dword ptr [ebp - local_8], edx           # 0048e644
    mov eax, dword ptr [ebp - local_c]           # 0048e647
    cmp dword ptr [eax + field_462], 0x0         # 0048e64a
    je.d32 L_0048e76e                            # 0048e651
    # block 0x0048e657: entered by fall-through of je at 0x0048e651, 4 instruction(s), ends with jl to 0x0048e6ac (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0048e657
    mov edx, dword ptr [ebp - local_8]           # 0048e65b
    cmp ecx, dword ptr [edx + field_9e]          # 0048e65e
    jl.d8 L_0048e6ac                             # 0048e664
    # block 0x0048e666: entered by fall-through of jl at 0x0048e664, 4 instruction(s), ends with jg to 0x0048e6ac (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0048e666
    mov ecx, dword ptr [ebp - local_8]           # 0048e66a
    cmp eax, dword ptr [ecx + field_a6]          # 0048e66d
    jg.d8 L_0048e6ac                             # 0048e673
    # block 0x0048e675: entered by fall-through of jg at 0x0048e673, 4 instruction(s), ends with jl to 0x0048e6ac (forward)
    movsx edx, word ptr [ebp + arg_8]            # 0048e675
    mov eax, dword ptr [ebp - local_8]           # 0048e679
    cmp edx, dword ptr [eax + field_9a]          # 0048e67c
    jl.d8 L_0048e6ac                             # 0048e682
    # block 0x0048e684: entered by fall-through of jl at 0x0048e682, 4 instruction(s), ends with jg to 0x0048e6ac (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0048e684
    mov edx, dword ptr [ebp - local_8]           # 0048e688
    cmp ecx, dword ptr [edx + field_a2]          # 0048e68b
    jg.d8 L_0048e6ac                             # 0048e691
    # block 0x0048e693: entered by fall-through of jg at 0x0048e691, 6 instruction(s), calls FUN_0048e776, ends with forward jump to 0x0048e770
    push 0x0                                     # 0048e693
    push 0x27b9                                  # 0048e695
    mov ecx, dword ptr [ebp - local_c]           # 0048e69a
    call FUN_0048e776                            # 0048e69d
    mov eax, 0x1                                 # 0048e6a2
    jmp.d32 L_0048e770                           # 0048e6a7
L_0048e6ac:
    # block 0x0048e6ac: entered by jl at 0x0048e664; jg at 0x0048e673; jl at 0x0048e682; jg at 0x0048e691, 2 instruction(s), ends with forward jump to 0x0048e6c0
    mov word ptr [ebp - local_4], 0x0            # 0048e6ac
    jmp.d8 L_0048e6c0                            # 0048e6b2
L_0048e6b4:
    # block 0x0048e6b4: entered by jmp at 0x0048e769, 3 instruction(s), falls into the block at 0x0048e6c0
    mov ax, word ptr [ebp - local_4]             # 0048e6b4
    .insn 0x66, 0x05, 0x0001{:u16}               # 0048e6b8
    mov word ptr [ebp - local_4], ax             # 0048e6bc
L_0048e6c0:
    # block 0x0048e6c0: entered by jmp at 0x0048e6b2, 5 instruction(s), ends with jge to 0x0048e76e (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0048e6c0
    mov edx, dword ptr [ebp - local_8]           # 0048e6c4
    movsx eax, word ptr [edx + field_b0]         # 0048e6c7
    {load} cmp ecx, eax                          # 0048e6ce
    jge.d32 L_0048e76e                           # 0048e6d0
    # block 0x0048e6d6: entered by fall-through of jge at 0x0048e6d0, 6 instruction(s), ends with jl to 0x0048e769 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0048e6d6
    movsx edx, word ptr [ebp - local_4]          # 0048e6da
    imul edx, edx, 0xd0                          # 0048e6de
    mov eax, dword ptr [ebp - local_8]           # 0048e6e4
    cmp ecx, dword ptr [eax + edx + field_b6]    # 0048e6e7
    jl.d8 L_0048e769                             # 0048e6ee
    # block 0x0048e6f0: entered by fall-through of jl at 0x0048e6ee, 6 instruction(s), ends with jg to 0x0048e769 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0048e6f0
    movsx edx, word ptr [ebp - local_4]          # 0048e6f4
    imul edx, edx, 0xd0                          # 0048e6f8
    mov eax, dword ptr [ebp - local_8]           # 0048e6fe
    cmp ecx, dword ptr [eax + edx + field_be]    # 0048e701
    jg.d8 L_0048e769                             # 0048e708
    # block 0x0048e70a: entered by fall-through of jg at 0x0048e708, 6 instruction(s), ends with jl to 0x0048e769 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0048e70a
    movsx edx, word ptr [ebp - local_4]          # 0048e70e
    imul edx, edx, 0xd0                          # 0048e712
    mov eax, dword ptr [ebp - local_8]           # 0048e718
    cmp ecx, dword ptr [eax + edx + field_b2]    # 0048e71b
    jl.d8 L_0048e769                             # 0048e722
    # block 0x0048e724: entered by fall-through of jl at 0x0048e722, 6 instruction(s), ends with jg to 0x0048e769 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 0048e724
    movsx edx, word ptr [ebp - local_4]          # 0048e728
    imul edx, edx, 0xd0                          # 0048e72c
    mov eax, dword ptr [ebp - local_8]           # 0048e732
    cmp ecx, dword ptr [eax + edx + field_ba]    # 0048e735
    jg.d8 L_0048e769                             # 0048e73c
    # block 0x0048e73e: entered by fall-through of jg at 0x0048e73c, 5 instruction(s), ends with je to 0x0048e769 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0048e73e
    mov edx, dword ptr [ebp - local_c]           # 0048e742
    movsx eax, word ptr [edx + field_3fe]        # 0048e745
    {load} cmp ecx, eax                          # 0048e74c
    je.d8 L_0048e769                             # 0048e74e
    # block 0x0048e750: entered by fall-through of je at 0x0048e74e, 7 instruction(s), calls FUN_0048e776, ends with forward jump to 0x0048e770
    mov cx, word ptr [ebp - local_4]             # 0048e750
    push ecx                                     # 0048e754
    push 0x27b8                                  # 0048e755
    mov ecx, dword ptr [ebp - local_c]           # 0048e75a
    call FUN_0048e776                            # 0048e75d
    mov eax, 0x1                                 # 0048e762
    jmp.d8 L_0048e770                            # 0048e767
L_0048e769:
    # block 0x0048e769: entered by jl at 0x0048e6ee; jg at 0x0048e708; jl at 0x0048e722; jg at 0x0048e73c; je at 0x0048e74e, 1 instruction(s), ends with backward jump to 0x0048e6b4
    jmp.d32 L_0048e6b4                           # 0048e769
L_0048e76e:
    # block 0x0048e76e: entered by je at 0x0048e651; jge at 0x0048e6d0, 1 instruction(s), falls into the block at 0x0048e770
    {load} xor eax, eax                          # 0048e76e
L_0048e770:
    # block 0x0048e770: entered by jmp at 0x0048e6a7; jmp at 0x0048e767, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0048e770
    pop ebp                                      # 0048e772
    ret 0x8                                      # 0048e773

