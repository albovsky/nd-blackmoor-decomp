# FUN_00495608
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00495608
# extent:       0x00495608-0x004956d3 (203 code bytes)
# span:         0x00495608-0x004956d3 (code 203, tables 0, padding 0)
# sha256:       ed620a3d20df9efa3e4f3ff642b8c1b0d31702edc34e033ae914d039c490d8e6
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m495608_check_object
# naming:       native port src/original_methods_fl39f.c:m495608_check_object (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Compares nine bytes of the record behind [self+0x201f] with 0x54f888 (gate dword [self+0x4769] set) or 0x54f894 (clear); All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_201f, field_4769; [ecx + n] field_49, field_201f; [edx + n] field_49
# callees:      calls FUN_004f6334, FUN_004fb2e3, FUN_004fc878
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m495608_check_object (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 63 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_49, 0x49  # offset +0x49
.equ field_201f, 0x201f  # offset +0x201f
.equ field_4769, 0x4769  # offset +0x4769

# --- external targets -----------------------------------------------
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fc878, .text + (0x004fc878 - 0x401000)

.org 0x00495608 - 0x401000
.globl FUN_00495608
FUN_00495608:
    # block 0x00495608: entry, 9 instruction(s), ends with je to 0x00495677 (forward)
    push ebp                                     # 00495608
    {load} mov ebp, esp                          # 00495609
    sub esp, 0xc                                 # 0049560b
    push esi                                     # 0049560e
    push edi                                     # 0049560f
    mov dword ptr [ebp - local_c], ecx           # 00495610
    mov eax, dword ptr [ebp - local_c]           # 00495613
    cmp dword ptr [eax + field_4769], 0x0        # 00495616
    je.d8 L_00495677                             # 0049561d
    # block 0x0049561f: entered by fall-through of je at 0x0049561d, 8 instruction(s), ends with je to 0x00495675 (forward)
    mov edi, 0x54f888                            # 0049561f
    mov ecx, dword ptr [ebp - local_c]           # 00495624
    mov esi, dword ptr [ecx + field_201f]        # 00495627
    add esi, 0x28                                # 0049562d
    mov ecx, 0x9                                 # 00495630
    {load} xor edx, edx                          # 00495635
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00495637
    je.d8 L_00495675                             # 00495639
    # block 0x0049563b: entered by fall-through of je at 0x00495639, 10 instruction(s), calls FUN_004f6334, ends with jne to 0x00495675 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0049563b
    mov ecx, dword ptr [eax + field_201f]        # 0049563e
    movsx edx, word ptr [ecx + field_49]         # 00495644
    mov dword ptr [ebp - local_4], edx           # 00495648
    mov eax, dword ptr [ebp - local_4]           # 0049564b
    push eax                                     # 0049564e
    mov ecx, 0x5cf1eb                            # 0049564f
    call FUN_004f6334                            # 00495654
    test eax, eax                                # 00495659
    jne.d8 L_00495675                            # 0049565b
    # block 0x0049565d: entered by fall-through of jne at 0x0049565b, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00495675
    mov ecx, dword ptr [ebp - local_c]           # 0049565d
    mov edx, dword ptr [ecx + field_201f]        # 00495660
    mov ax, word ptr [edx + field_49]            # 00495666
    push eax                                     # 0049566a
    mov ecx, 0x5c3a67                            # 0049566b
    call FUN_004fb2e3                            # 00495670
L_00495675:
    # block 0x00495675: entered by je at 0x00495639; jne at 0x0049565b, 1 instruction(s), ends with forward jump to 0x004956cd
    jmp.d8 L_004956cd                            # 00495675
L_00495677:
    # block 0x00495677: entered by je at 0x0049561d, 8 instruction(s), ends with je to 0x004956cd (forward)
    mov edi, 0x54f894                            # 00495677
    mov ecx, dword ptr [ebp - local_c]           # 0049567c
    mov esi, dword ptr [ecx + field_201f]        # 0049567f
    add esi, 0x28                                # 00495685
    mov ecx, 0x9                                 # 00495688
    {load} xor edx, edx                          # 0049568d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0049568f
    je.d8 L_004956cd                             # 00495691
    # block 0x00495693: entered by fall-through of je at 0x00495691, 10 instruction(s), calls FUN_004f6334, ends with je to 0x004956cd (forward)
    mov eax, dword ptr [ebp - local_c]           # 00495693
    mov ecx, dword ptr [eax + field_201f]        # 00495696
    movsx edx, word ptr [ecx + field_49]         # 0049569c
    mov dword ptr [ebp - local_8], edx           # 004956a0
    mov eax, dword ptr [ebp - local_8]           # 004956a3
    push eax                                     # 004956a6
    mov ecx, 0x5cf1eb                            # 004956a7
    call FUN_004f6334                            # 004956ac
    test eax, eax                                # 004956b1
    je.d8 L_004956cd                             # 004956b3
    # block 0x004956b5: entered by fall-through of je at 0x004956b3, 6 instruction(s), calls FUN_004fc878, falls into the block at 0x004956cd
    mov ecx, dword ptr [ebp - local_c]           # 004956b5
    mov edx, dword ptr [ecx + field_201f]        # 004956b8
    mov ax, word ptr [edx + field_49]            # 004956be
    push eax                                     # 004956c2
    mov ecx, 0x5c3a67                            # 004956c3
    call FUN_004fc878                            # 004956c8
L_004956cd:
    # block 0x004956cd: entered by jmp at 0x00495675; je at 0x00495691; je at 0x004956b3, 5 instruction(s), ends with ret
    pop edi                                      # 004956cd
    pop esi                                      # 004956ce
    {load} mov esp, ebp                          # 004956cf
    pop ebp                                      # 004956d1
    ret                                          # 004956d2

