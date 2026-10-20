# FUN_00484622
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00484622
# extent:       0x00484622-0x004846c2 (160 code bytes)
# span:         0x00484622-0x004846c2 (code 160, tables 0, padding 0)
# sha256:       26068d405e89ae2e3abfc6f8adad7507b4364a2c8909872bb283c7ac3efd25f6
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         top_piece_placed
# naming:       native port src/action_family_ea_runtime.c:top_piece_placed (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with top_piece_placed (greatest layer in the rotate-zone list, first on ties, -1 if empty). FL-15's rotate:placed* oracle scenarios run all 160 bytes; the return value is checked by the direct test.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_c23; [ecx + n] field_28; [edx + n] field_bfb, field_c23
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:top_piece (function ledger class native_oracle_verified; also top_piece_placed; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 44 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_28, 0x28  # offset +0x28
.equ field_bfb, 0xbfb  # offset +0xbfb
.equ field_c23, 0xc23  # offset +0xc23

# --- external targets -----------------------------------------------

.org 0x00484622 - 0x401000
.globl FUN_00484622
FUN_00484622:
    # block 0x00484622: entry, 9 instruction(s), ends with jne to 0x00484645 (forward)
    push ebp                                     # 00484622
    {load} mov ebp, esp                          # 00484623
    sub esp, 0xc                                 # 00484625
    mov dword ptr [ebp - local_c], ecx           # 00484628
    mov word ptr [ebp - local_8], 0xffff         # 0048462b
    mov eax, dword ptr [ebp - local_c]           # 00484631
    movsx ecx, word ptr [eax + field_c23]        # 00484634
    test ecx, ecx                                # 0048463b
    jne.d8 L_00484645                            # 0048463d
    # block 0x0048463f: entered by fall-through of jne at 0x0048463d, 2 instruction(s), ends with forward jump to 0x004846be
    mov ax, word ptr [ebp - local_8]             # 0048463f
    jmp.d8 L_004846be                            # 00484643
L_00484645:
    # block 0x00484645: entered by jne at 0x0048463d, 5 instruction(s), ends with forward jump to 0x00484665
    mov edx, dword ptr [ebp - local_c]           # 00484645
    mov ax, word ptr [edx + field_bfb]           # 00484648
    mov word ptr [ebp - local_8], ax             # 0048464f
    mov dword ptr [ebp - local_4], 0x1           # 00484653
    jmp.d8 L_00484665                            # 0048465a
L_0048465c:
    # block 0x0048465c: entered by jmp at 0x004846b8, 3 instruction(s), falls into the block at 0x00484665
    mov ecx, dword ptr [ebp - local_4]           # 0048465c
    add ecx, 0x1                                 # 0048465f
    mov dword ptr [ebp - local_4], ecx           # 00484662
L_00484665:
    # block 0x00484665: entered by jmp at 0x0048465a, 4 instruction(s), ends with jge to 0x004846ba (forward)
    mov edx, dword ptr [ebp - local_c]           # 00484665
    movsx eax, word ptr [edx + field_c23]        # 00484668
    cmp dword ptr [ebp - local_4], eax           # 0048466f
    jge.d8 L_004846ba                            # 00484672
    # block 0x00484674: entered by fall-through of jge at 0x00484672, 12 instruction(s), ends with jle to 0x004846b8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00484674
    mov edx, dword ptr [ebp - local_c]           # 00484677
    movsx eax, word ptr [edx + 2*ecx + field_bfb] # 0048467a
    imul eax, eax, 0x85                          # 00484682
    mov ecx, dword ptr [ebp - local_c]           # 00484688
    movsx edx, word ptr [ecx + eax + field_28]   # 0048468b
    movsx eax, word ptr [ebp - local_8]          # 00484690
    imul eax, eax, 0x85                          # 00484694
    mov ecx, dword ptr [ebp - local_c]           # 0048469a
    movsx eax, word ptr [ecx + eax + field_28]   # 0048469d
    {load} cmp edx, eax                          # 004846a2
    jle.d8 L_004846b8                            # 004846a4
    # block 0x004846a6: entered by fall-through of jle at 0x004846a4, 4 instruction(s), falls into the block at 0x004846b8
    mov ecx, dword ptr [ebp - local_4]           # 004846a6
    mov edx, dword ptr [ebp - local_c]           # 004846a9
    mov ax, word ptr [edx + 2*ecx + field_bfb]   # 004846ac
    mov word ptr [ebp - local_8], ax             # 004846b4
L_004846b8:
    # block 0x004846b8: entered by jle at 0x004846a4, 1 instruction(s), ends with backward jump to 0x0048465c
    jmp.d8 L_0048465c                            # 004846b8
L_004846ba:
    # block 0x004846ba: entered by jge at 0x00484672, 1 instruction(s), falls into the block at 0x004846be
    mov ax, word ptr [ebp - local_8]             # 004846ba
L_004846be:
    # block 0x004846be: entered by jmp at 0x00484643, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004846be
    pop ebp                                      # 004846c0
    ret                                          # 004846c1

